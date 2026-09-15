Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3897DC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE5D6B0099; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB956B0095; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137246B0098; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B715D6B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7B711602CE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
X-FDA: 85214365362.26.4A4F4EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E0B720004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ok4/X9zr";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	b=vKWnc151sqhzW1uP7LX9S1meDiAeSQu+KauCLlHa/C5JvjIqvBoDIrkzBHGWCijC9XroHT
	dED2LWtT8UlIH7dz4RNAfGJiMV2dM4bml7VJNohAr0h0lie/Zuj/C/fZjfVWqh5LOnGAFf
	fQL1zM6xclB09XoN+2tkQSsTctMcU6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438180;
	b=hR7ntMeFTns1/dJUi/3XhEfvnHPXsYP9MzRyMlPTM98o+6MxLfB8E30XL3Dny1xZR5xBkh
	am+XnKa9M+MB2k+eAI5lTNuj3Hw8qkNEXxSz+o0Q+4gY2JW/S0FtUMxbx4TgDTc1dM1Zku
	uMK7NZ+21OTNsV56oJTb2xCthUkNvv0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ok4/X9zr";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D426D602BE;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6359A1F00899;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438179;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ok4/X9zrJPY6LPSYJUCoK93OZvdhLSXsy7mPxMMB4K2c7cRQ0IuvUNKw/Vbr6cuTQ
	 GGkNEW6AL1+4ZbpBIOk/d2/QMqrB2ocmnC8K9PuRvCM7J91yUiYFecvTrlyaIyJG3x
	 7dgrn0c3gGAQIfmVLQft+ZhvNKKNTl9Mi3AB2hoqRtEwqVAgiQYjPuoGPhBI9d7xf9
	 pnL+xZ4kY0Jbh2ni5f4T36uxHYBbwTwEUlnO7M0VwhXFMAJG/qOBBTjgMv0WKydYAJ
	 N5NzwGytky/w1QT08ya/feMA5Jg9Tq/4fP4b1inLHruKu9JNcTxrfPUF1ekLZUBlOh
	 HzkiAbBo8k2Ag==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 4/8] mm/damon/sysfs: add min,max files under probe filter directory
Date: Mon, 14 Sep 2026 19:09:23 -0700
Message-ID: <20260915020929.102953-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E0B720004
X-Stat-Signature: t4mdrah7yxfwzdhbp7z7rn4p8ubc88yx
X-Rspam-User: 
X-HE-Tag: 1789438180-355178
X-HE-Meta: U2FsdGVkX1/6DCB3BMwmZOWwmNH4mlZh7EIbupKBb9AJHQ7zNAL/5S5Evd1sdtvGzhONSGKVjZoyDeQRJH5BOGEjQXf8xN/JM4mBnz1dk24tJT3wWj/i+Ie+Whdqco+IPl30nrU+k8Zo6T/oassE7soTOKT8NLn1auxasAaHVrOceIbX9xONYej5JD+TloHP6wnPhoVw7kH4bHW8/2cCH8Hq/C9iHAg5wIhG54hKCTgG/kgXhQurJq3D9lBPUrwG5JGJj973tIp8xVdT5ElGMYyU6s+8vuAqrA7uruzAspOhCiGGVcl3f2Wk7f1ctX3FvxBeaoxLAh7wmgNepHQk6LmXC+mHIYehtmuxa2duz0NFOnPgZbHUC6TiJyVd3BseXanhjt/pEMbQhVfAqJnb2iOYSkYVM7FpsWHTDjQ84Eo2m1+EKuTyBlqIDl8iOSXFDL0FN1/jFeqRRZQ839yL4/7QFwPt1cqEeLLEfE+OK/ulbJExu3MsxD0K4LCByGymrrGlPClOW7XCt6m1yez3vzM/TIO/4XcQ3EKEoym+mrYXCFfqO4Ch8tlOyPy7rTz2rdf9RGccnJWxeZnfXfoe1j/V4qj4kH+RfPFO8rIOq+ZTpwM0J7ksH4eM8cvvS2OxRmO8H87tDcEJvVnJT58CLW4Yxb7UkP4BS54uU147S9EMcE1TsxtKIqT5Z2Y7+CC3/+v6ttcYnnm3DOyE8PiviIijQ3+CtXu3rERmKXqhhrlHW2Fc3oVm6FXJttoe/ZcB7CyspdS/aCErqusRNlj55Ag27Gh+9fQKWEdvcFNqkSXxzPOEqSCPBslIeOwMGyRWkj4MJDGy7z5gMNBVsTY7nGkxqRYIJx3NWgd1cHna7AQF6IQisao1VGSRLPwlASxTPPFM+JrVBLMlzrYiZy0qElUN7j5q5MYAK52HJ4jyf5TURmT103dDT9/W3snuO6H6k1IcVkWMLDxiNaOLELr
 dGfF6olG
 OsKkWSZpFdGXEZS4HAm7x3yAflEuQUiBUnCRNLOwUqNiSdkmMNHtRtxHqjf305/Yb1kz2wIX522isT+OOzy8sB2ZSZf/2pt0CLGMEJWvZi6ZBDy0qP4C+Te5BKUQGfZo4PZRhYUORMWmhdT39kLwXSk+J3mkMp5VxoK7gKu5LBAejpF9eBCofTqkNzQj+tf0uEBT+LCTldXPZsruEAoctqISlvRMyr9Bo4WqRGnIHvUnuV2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In future, DAMON sysfs interface will support data attribute probe
filter types that have range arguments like the newly added
hugepage_size type filter.  To prepare such supports, add two new DAMON
sysfs files, min and max, under the probe filter directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 51fa506c879b0..8e8d89b8ed981 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -975,6 +975,8 @@ struct damon_sysfs_filter {
 	bool matching;
 	bool allow;
 	char *path;
+	unsigned long range_min;
+	unsigned long range_max;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1127,6 +1129,44 @@ static ssize_t path_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t min_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
+}
+
+static ssize_t min_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_min);
+
+	return err ? err : count;
+}
+
+static ssize_t max_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
+}
+
+static ssize_t max_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_max);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1148,11 +1188,19 @@ static struct kobj_attribute damon_sysfs_filter_allow_attr =
 static struct kobj_attribute damon_sysfs_filter_path_attr =
 		__ATTR_RW_MODE(path, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_min_attr =
+		__ATTR_RW_MODE(min, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_max_attr =
+		__ATTR_RW_MODE(max, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
 	&damon_sysfs_filter_path_attr.attr,
+	&damon_sysfs_filter_min_attr.attr,
+	&damon_sysfs_filter_max_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

