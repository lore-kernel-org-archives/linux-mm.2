Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C72CCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A266B00A2; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3711B6B00A1; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BD96B00A3; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB6416B00A1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8230160591
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
X-FDA: 84774141102.29.AC94FBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0629A0002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcZGFwAW;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfV0obp/+FuqzK/GeVY1GFOaibbQmAhuraPe4Oc6L7w=;
	b=JbXeyoT2sw1bkbo+c/1e0+yf2zFCv9HGluwmQz0cQ7HD89/983w9Aj3McMaxeGySy3YVly
	j563LsVcKX3Szj9UlWxvksTFOtMsr5DfiIawnUIpuTRvsUPnZ17+VtehLFqQsug7N2Lax5
	dc4pKUQSV+rJqPIoqDYaR5wrvftr7Jg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcZGFwAW;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956650; a=rsa-sha256;
	cv=none;
	b=rJ+2KnkxPC1XxP1MSbfAUzQjI1WPghU96VoApYuyeuicaWtEYbfpcJcBeEQgRgPVGr4ixH
	uVDMY/0PoGGzSWmG0RymOIsz7aheogNsCkuOgtHOZm4buNx8EbgTbTthAqrt1msgpPXyT1
	oUL5fWfZ7V8040lQcxkg3SWdEMFGo8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 266734460A;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D511EC2BCC7;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956649;
	bh=AEUZoeUvUNqOaA5YHBasjSzwVa8wJwIKAzC/F+JHBy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcZGFwAWHksQbXFOC2ZF2/ShDMrkfd/9uWhwrnJA8lykQ8lRSM5ydlTysZ5oFdo4V
	 rfDdaBpwZbgWGq5YPOAMR3Nmz78o78CvXRnkGIjqT4LEOF+InPP4nBlH7FMQ3h1rvp
	 RkWaR63ZGk0ODY1Ah2PTmZ/skoI2Hw8YbTF/zqZ+VpxqRRVOt/Q0PFWJYuWuIrjDlu
	 WcpmQnWtOu4MLKvaAFyHcUST7ZDLWYA0l0lqkRsK66o4xab4VjLZr+FmWFRn7nj4uL
	 Cp7fS7z4kWJiCb7j59xMpmvxtN+oLo4RqCqiVMZ67NcOZxNHEQnmGjwR1olN37rASd
	 c4ilaOt+hLjAA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 13/28] mm/damon/sysfs: implement filter dir files
Date: Sat, 16 May 2026 11:36:54 -0700
Message-ID: <20260516183712.81393-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0629A0002
X-Stat-Signature: oztutah3ikbz4h7bppqz7hniuytoionu
X-HE-Tag: 1778956649-799171
X-HE-Meta: U2FsdGVkX187/gJkMJsbrbUDSvVwpk4k3/ZrDQrbm35r5OYCyfmyRs5BxNBMpodFjEqQP8TmYqKJEQIs+usp4HpM6tWvWdFmE7+/ycwXazq1wJdLj0I9F780PpAB4bAUNSdYnZWg4eU1kpmdbEeVWfdbhOu/BJErWYK1TRgXhGLEDj0Gi8vf79d1/8pFrD14nAxzn0IH1H8dmUUFKPJvY1U/VZwSB/aIDhcSX8VJOOR8Ydg2XBnkdKw0jh0qJ2iDfvZuHV0Uvi3gdztZ7qUa42YQ5kuX36B5w3a8/hv1MjfhTm2fAL9+nbr6Tm9Z9gLnLQoAuLzP1pZodyudXw1sAZkyPYhP+5fUc//jW/ZoSa7rtU7lGj/mTnDMhsMdaXZ5ILMdORUTIS63l8FlF5aSss7zLYF74dlU8/u/xzeLTR835tPqo+3MFboSHsKd0zoPJ+kekvLNBZfH/04+/tnfwYEFFdJkvmNZgcFIqTi8UUENjFc141fit/JqO34oGMiy9QSBO1hDHPLzLoSHiqXmfIvIR5zJuJGSE1sR9IiHiV/recW8lrv67VYU9YaQA1o7jZOo+ZNPMUOGob9EwK7v4NH/Q2wc3Jy/2q/BzT7gDZLeqeYsg5Yxeg5wYl5SeanUkiDyiR/bMgi5FffttIuDhUDUIv/6mAhfY5K0SbVL3FoLTT8g4LzaLZSXC4FhKAWIvFESHR9rNOJqTRZjDYe3kQCT4OUQWo3On1uG+IYn9aAiyk8dEOGEX6iCqapZpMDUMBx2m99x8OxzEwZohiLL6UHVeLyNXGVuejiI4pRHH6JWBYLGx7KBf2381oZXa7pZ07t6u/FR1oMxOcMvwrC3sWVP+s2B2W33NLtSNQlWa2nXvSo86e7Y+pZH8EdzKnhs8GPLZQRbhmWZaVMOP2vnCudKDSIF9toQVZ0vgO48mKqOjrveXW+9jqP/adnHk8HNYzdAz7va5hl+njdzSFl
 U9eWUEIs
 thjgqb3eY+5Pi1qW8zLhA4l5kLNswzyQ3gyR9gG44hg48+Y6I6qT+NaSf1/g9x6yNt5p1s+HJIfEqLALdp0sPWqloYJGyjU9tow/KBsUA4XIEVq51cMqiYnh13vdJgcxslSLZVHNPrHtv9vYV52zoWdXJx/1YJPp591NOdOllFCTQaqA1K3ls4PgQ5UDokOWBLCH1lW/Ji5TY555TWUs5U1/1tMgGFoBXXB5lydXp7pJ9zGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs files under the data probe filter directory for letting
users to configure each filter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 18c669ce6f81f..35a4fa5c530f5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -753,6 +753,9 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_filter {
 	struct kobject kobj;
+	enum damon_filter_type type;
+	bool matching;
+	bool allow;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -760,6 +763,105 @@ static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_filter);
 }
 
+struct damon_sysfs_filter_type_name {
+	enum damon_filter_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_filter_type_name
+damon_sysfs_filter_type_names[] = {
+	{
+		.type = DAMON_FILTER_TYPE_ANON,
+		.name = "anon",
+	},
+};
+
+static ssize_t type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
+		const struct damon_sysfs_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_filter_type_names[i];
+		if (type_name->type == filter->type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
+		const struct damon_sysfs_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_filter_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t matching_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->matching ? 'Y' : 'N');
+}
+
+static ssize_t matching_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	bool matching;
+	int err = kstrtobool(buf, &matching);
+
+	if (err)
+		return err;
+
+	filter->matching = matching;
+	return count;
+}
+
+static ssize_t allow_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->allow ? 'Y' : 'N');
+}
+
+static ssize_t allow_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	bool allow;
+	int err = kstrtobool(buf, &allow);
+
+	if (err)
+		return err;
+
+	filter->allow = allow;
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -768,7 +870,19 @@ static void damon_sysfs_filter_release(struct kobject *kobj)
 	kfree(filter);
 }
 
+static struct kobj_attribute damon_sysfs_filter_type_attr =
+		__ATTR_RW_MODE(type, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_matching_attr =
+		__ATTR_RW_MODE(matching, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_allow_attr =
+		__ATTR_RW_MODE(allow, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
+	&damon_sysfs_filter_type_attr.attr,
+	&damon_sysfs_filter_matching_attr.attr,
+	&damon_sysfs_filter_allow_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

