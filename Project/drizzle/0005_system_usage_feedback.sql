CREATE TABLE `system_activity` (
	`id` text PRIMARY KEY NOT NULL,
	`account_id` text NOT NULL,
	`role` text NOT NULL,
	`department` text NOT NULL,
	`action` text NOT NULL,
	`created_at` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_activity_created` ON `system_activity` (`created_at`);
--> statement-breakpoint
CREATE INDEX `idx_activity_department` ON `system_activity` (`department`,`created_at`);
--> statement-breakpoint
CREATE TABLE `department_feedback` (
	`id` text PRIMARY KEY NOT NULL,
	`account_id` text NOT NULL,
	`department` text NOT NULL,
	`rating` integer NOT NULL,
	`category` text NOT NULL,
	`message` text NOT NULL,
	`created_at` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_department_feedback_created` ON `department_feedback` (`created_at`);
