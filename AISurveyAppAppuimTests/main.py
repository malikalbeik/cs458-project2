from appium import webdriver
import unittest
from appium.webdriver.common.mobileby import MobileBy
from selenium.common.exceptions import NoSuchElementException
import time


class SurveyAppTests(unittest.TestCase):
    def setUp(self):
        """Sets up desired capabilities and the Appium driver."""
        self.driver = webdriver.Remote(
            command_executor="http://127.0.0.1:4723/wd/hub",
            desired_capabilities={
                # Note: change the app path when testing on other machines
                "app": "/Users/malikalbeik/Desktop/AISurveyApp.app",
                "platformName": "iOS",
                "platformVersion": "17.4",
                "deviceName": "iPhone 15 Pro",
                "automationName": "XCUITest",
                "bundleId": "cs458.AISurveyApp",
            },
        )
        self.driver.implicitly_wait(
            10
        )  # Waits up to 10 seconds for elements to become available

    def test_field_validation_logic(self):
        """Tests the logic for field validation and enabling the Send button."""
        # Corrected the accessibility ID based on the provided SwiftUI code
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "NameSurname").send_keys(
            "Test User"
        )

        # Correctly catching the exception if the send button does not exist
        try:
            send_button = self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, "SendButton"
            ).is_enabled()
        except NoSuchElementException:
            send_button = False
        self.assertFalse(send_button, "Send button should be disabled with no inputs")

    def test_survey_submission_success(self):
        """Test successful submission of the survey with all fields filled correctly."""
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "NameSurname").send_keys(
            "Test User"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "BirthDate").send_keys(
            "01/01/1990"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "EducationLevel").send_keys(
            "Bachelor's"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "City").send_keys(
            "New York"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "Gender").send_keys(
            "Female"
        )

        ai_model_ids = [
            "ChatGPT",
        ]
        for model_id in ai_model_ids:
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"{model_id}Checkbox"
            ).click()
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"DefectsField_{model_id}"
            ).send_keys("Defect 1, Defect 2")

        self.driver.find_element(
            MobileBy.ACCESSIBILITY_ID, "BeneficialUseCaseField"
        ).send_keys("Automating repetitive tasks")

        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "SendButton").click()

        time.sleep(2)

        try:
            success_message = self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, "SuccessMessage"
            )
            submission_successful = success_message.is_displayed()
        except NoSuchElementException:
            submission_successful = False

        self.assertTrue(
            submission_successful, "Survey should be successfully submitted."
        )

    def test_date_picker_constraints(self):
        """Ensures the date picker does not allow future dates to be selected."""
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "NameSurname").send_keys(
            "Test User"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "BirthDate").send_keys(
            "01/01/2030"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "EducationLevel").send_keys(
            "Bachelor's"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "City").send_keys(
            "New York"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "Gender").send_keys(
            "Female"
        )

        ai_model_ids = [
            "ChatGPT",
        ]
        for model_id in ai_model_ids:
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"{model_id}Checkbox"
            ).click()
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"DefectsField_{model_id}"
            ).send_keys("Defect 1, Defect 2")

        self.driver.find_element(
            MobileBy.ACCESSIBILITY_ID, "BeneficialUseCaseField"
        ).send_keys("Automating repetitive tasks")

        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "SendButton").click()

        time.sleep(2)

        try:
            failure_message = self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, "DateFailureMessage"
            )
            submission_failed = failure_message.is_displayed()
        except NoSuchElementException:
            submission_failed = False

        self.assertTrue(
            submission_failed, "Survey should be failing due to invalid date submitted."
        )

    def test_dynamic_ai_model_defect_entries(self):
        """Checks dynamic addition of defect fields based on AI model selection."""
        ai_model_ids = ["ChatGPT", "Bard", "Claude", "Copilot"]
        for model_id in ai_model_ids:
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"{model_id}Checkbox"
            ).click()

            try:
                defect_fields_element = self.driver.find_element(
                    MobileBy.ACCESSIBILITY_ID, f"DefectsField_{model_id}"
                )
                defect_fields_visible = defect_fields_element.is_displayed()
                self.assertTrue(
                    defect_fields_visible,
                    f"Defect entry field for AI model '{model_id}' should be visible after selection.",
                )
            except NoSuchElementException:
                self.fail(
                    f"Defect entry field for AI model '{model_id}' not found after selection."
                )

    def test_handling_of_large_input_texts(self):
        """Checks app behavior with large texts in the beneficial AI use case field,
        ensuring all required fields are filled to allow form submission."""
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "NameSurname").send_keys(
            "Test User"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "BirthDate").send_keys(
            "01/01/1990"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "EducationLevel").send_keys(
            "Bachelor's"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "City").send_keys(
            "New York"
        )
        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "Gender").send_keys(
            "Female"
        )

        ai_model_ids = [
            "ChatGPT",
        ]
        for model_id in ai_model_ids:
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"{model_id}Checkbox"
            ).click()
            self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, f"DefectsField_{model_id}"
            ).send_keys("Defect 1, Defect 2")

        large_text = "A" * 1500  # Generating a large text input
        self.driver.find_element(
            MobileBy.ACCESSIBILITY_ID, "BeneficialUseCaseField"
        ).send_keys(large_text)

        self.driver.find_element(MobileBy.ACCESSIBILITY_ID, "SendButton").click()

        time.sleep(2)

        try:
            success_message = self.driver.find_element(
                MobileBy.ACCESSIBILITY_ID, "SuccessMessage"
            )
            submission_successful = success_message.is_displayed()
        except NoSuchElementException:
            submission_successful = False

        self.assertTrue(
            submission_successful, "Survey should be successfully submitted."
        )

    def tearDown(self):
        """Tear down the test environment."""
        self.driver.quit()


if __name__ == "__main__":
    unittest.main()
