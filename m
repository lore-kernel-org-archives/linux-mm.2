Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B5CFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272A46B00A4; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1609A6B00A0; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E585E6B00A2; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5FCF6B009F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A77434063B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
X-FDA: 84701905722.15.517B3D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F2AD340002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCzEf8JI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz312XeuMurfmqSyXTVEs1ZaKp6R/XDDq0AZYQyH6v8=;
	b=nVBXahIYOiay6DLKjrw/QPc99KQT556wXUns1bmIlw3tUEVo3s5J+OoSzEDfEh9036tBFb
	PwpPuBnzxCeMmqUdOa/9m/bg6JkUtYy/YYOILb3FUSszGzfd4kdU2iJ3bJ4qhm/PtE0F4O
	eRUXgNVz18MtE56h42XPzIxAAV34V/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236760; a=rsa-sha256;
	cv=none;
	b=abTXxZ0/z46BIOavOyNwxYfRGLXliKsmU31TuPoCbv0zFoOIHzDyF0scUkPB+wticpNMG1
	rxlBOSI/Y4GnyNJPzOzIOvCBOjGtujRaGqHcT7Ogo4iTtpuaKNn2iLvAdg2H+bPn+P/RpR
	r6qQjminyMASyDaHgiIvBQu853flRQc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCzEf8JI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3808544189;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E371EC2BCAF;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236759;
	bh=3u3zgK6Y4SMO63Qqlb5LCCFkNgTg1crzSGGdU4/aQYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCzEf8JIgKuwpVxirzBj9NGN5xAhR2irUV3Lb1yAmeF3PZERbNZfo+8cC4B4CJOZO
	 FAoHkIPgEsVGzrRaYcu4XEGs+R4MV1PeQKv/iX5k1IoGTEKr9ib7lNXjXAqdN0bgIO
	 Q2bKK05jk8ACq4gitwjtu2lly8FnyARRqSA0OtbcIxJpYLDAtU7BDNw/3ntTUkdHq1
	 TCHfjtOwDM40T4czjv+Dt22T9XAAIxvyAg0SRyCPAjCPNk2BvMBO17pSnGBqmuUg+O
	 0NuU6UPa4SW4ebsIeUu1YKqMgsFucs5+81wcVbJXnaZ/bUeBpFGQE4lLFTSQFQPGQF
	 rYsm8wKbSyuhw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/19] mm/damon/sysfs: implement filter dir files
Date: Sun, 26 Apr 2026 13:52:14 -0700
Message-ID: <20260426205222.93895-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2AD340002
X-Stat-Signature: yucoijetp6ib49d5rc4mjiip3qjudpjr
X-Rspam-User: 
X-HE-Tag: 1777236759-143009
X-HE-Meta: U2FsdGVkX1+eIvHcQYAuXgp+FLHp1ALAeKQ1+MEEjDm2C9Lp0GvpN9SJ8NVhKwrYvtoPaWcsuScMssxLTyQhLlartdPE9u9KOFUP/T3+8jWQmi67PF4NbZrIvm+8muvFf9yvJfcOGnBCJaH3TVGGYio6UBYI7a+Et+XamzmkKGNy4RaTiG62h2d9z7benw6nFKn0L69OUKACrsjUZWmt/Sros82+fnHr69koK4xNohmubvH1vi/iGXYopf2qV0BWRqP9HI4uakGBtG8cSPGCrXMR17fyDq5NoRkpF/lwqLXq6IBOvVNgm4zoHzKg9VfZyx+2oPE5PKtG/V/0QAVxoP6kHeSemENl0Qb8kXQ4Jbj7MzSw99ESz3nQuHMuqw2POq6nEzvbutbT+v26dDnSosdzSDqXu2SaXzWqBHxyr2OaQhqFM7WkIrXb/d9wy2bBku9gvBS1U1irzbLMZLKRJ9FAfrpQWYJ5d4G5JeAUVP/+c5yh29HlBb9wYoNoKiXuauoDeVI8khfnwpuHb4PVCeEiHlRgYoNx9QpQynzUdYd7JL87PEWdhyGtVbrziuUb1uAnpe4n4Y2CWzOkelMopEZPKQxz4fHsmRBCIiSqx1HrUiFsoGfTdviaRdxOduHzBonsf7sf2tZwMYoBxzqdPgyWKq/KGfUVnkGn6/z/CIOZVgyLVen2eQ+Y19srZaIvvpXYfrsFcHjyO9Wx32uUeWKWcd5OxyZq3TCiG/pCRW1ZBbZf4BVWTFZStsUtSc3t6IGQz6MGCMj8P5PN9QPqAQs9lxnBTIWyy2uPiaLwZ2rDXaKOx58wRH1dV1c7tWjNM8a8c9FuwPhju881reosWxBqqOJhNxam7rrkvpdQlUkPIrCnUqzQRBdtBsoXTMWRFCGwxXM1riFdKwQi3/ffgmOxHWIU29bUkl7xWOslw7pGbwzFUsJZlBZV6PfvzAveEv8Xs7oQ5wcEmtWpynQ
 7SGQCp51
 L8NRW6Jlykm+N4p7dR2oIkEkg8S1oAZ7ybU5V7SQOQDa5d6fOwZFB+rqf9lS7ODmo98eNIzI7x1mDEQp5frbPOaTmmp2OL8lqq/vYVaWLXnF2jZzqsN1vTSnk41JtJYc/ub3dOSx9DO+7ysvWWxiCPj5vgqR8Ic4xI9rfJRoq5CvBVgryIxJJo1aKQ5kzkNTNocHqqOlOSekreY901L+9cDk1gjhgoR0+y2ewDGNDbMy7nSc=
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
index 25487a0268cbe..2e0b7eca6bcbf 100644
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
+		.type = DAMON_TEST_TYPE_ANON,
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

