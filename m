Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15481CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588346B00B3; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A24B6B00B9; Mon, 18 May 2026 19:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE186B00B4; Mon, 18 May 2026 19:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 045466B00B9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C24B5C3440
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:30 +0000 (UTC)
X-FDA: 84782164740.30.AB1C03B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2183E40005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRdfq4b2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vcrPARd6XJpB3C8pJ/OHvVQSPm2D987YXTwgdTepxs=;
	b=6VsmLciBKUUmRbdp2AIppGMpxo0WaLc5a/WzbJ5gzfAfV+F2aTEbkWbKalKTZBsaVLf++b
	mEOp9TfC9X2xoQh2Zhq0BHpVX2asqA2wH4iNV4RgWUuw/pJX2lPc/2YFT6L8L6i4ZIo4bO
	b6GjVahtJ0m3bSKRH1sz8OQCRs2qRpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147689; a=rsa-sha256;
	cv=none;
	b=Yl6Rhv7xJyDFt7VB0aaap5SDJe+uQJb7GyRyPZHWeQ0otKxsqo7sXg4BJT8/FlRMsxNwYK
	jheB34opLkAdFZUsMQHb8iKm+DkyEZ9ONFnL4M/P7yRzknwBYuG4IbXJ4oo4vLLPjOE9ia
	bErvWNQR1j1FjLlaElpDvEuARFnTAjY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRdfq4b2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FE89445A3;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4ABC2BCB7;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147688;
	bh=iQV6uszTSASR7SPrN3OuATode4ysgHHPU+n3qGy6r2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRdfq4b2Z4RMt54O4rh/DHjSSfMRDWBJgbO2JPOqIO3JnLYnF59ElNO15mTckEh6/
	 rmdJs0hrf77dZBSubA5knpRrY92Pw7+7gJ03Tf0hlRwjxl6trKumdwMIw18h3TQJ0P
	 I7z/n2kdhEHP1DCWD89OSgwpgjjrwioFLLn1VxF7ALLa0WLlv5H+H0aCLqNTzwya/2
	 ShQA9airxY5mc565VYqTITRVknU79aByJGmoZZsb/VVxo9ucDxwnjjkADN+dQY2L/i
	 kDCMR1J+ATHvwqZGS0vTcT3A89Bknn61J5NgbIKDm8T0EZWVkgvpVqVLJxo+imDM7G
	 aU4x+XAx2W5rw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/28] mm/damon/sysfs: implement filter dir files
Date: Mon, 18 May 2026 16:41:01 -0700
Message-ID: <20260518234119.97569-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2183E40005
X-Stat-Signature: 4r4w5wernnhc3wsjp7u3sade3qioz7yb
X-Rspam-User: 
X-HE-Tag: 1779147688-789755
X-HE-Meta: U2FsdGVkX1/D4apXzPjVCpHphIc84+YuMj1sVIRUHwLovBmDjEN8XxIrBMgNEHjnQOcwWE08dz+g28qNM75fob/c+oORsKZ2Agi+c8298fUPFkhAaFRCDzPEjiv/boU62kEw16jv8zyKZLzqTsWAqdqV9IKzP9dsmbeWFLWbSEx0b+XbWct8kt0PVwTaVcf2+9uatiyZsJlTKX0MUnaF1awCJf1mutd+6jbqSoB1SUZv4xtLc9JbDuYARFAG7yk3INw8pQK8Wi+dn35UO1erpMK8eanO2Xitxcu0rgYBlR447uI2KKOtZxDL389+GX7ngCFk0lds/shMgIORzd8aHgdoumfZbej8lZ4/w8CEVrUYsqY1p4KB5JExje9B+bGHlOs3PnG7c37jO5zUd0/bcyhI2yQQipJVAiMcbBodWAgN61t/gDOWmWqt6ZB23EkAvedV6UT2dEzgRoUb67rc1ggU5HuannZyYY7LFHpffo8RRnq8VYu4otSdr5y6qOngoau9X3N/PQgjPvo8tuFWH/p3QiFIcmDQVZqbLXpGXAKjNZtnCjXFoD9k+l7OWA4qpLl6TCWDMRt1e/DdI2ux9JOQ3SIE/ZBZoLYruKCQjFRo6bdY0OmDayMGMhhcQOYyDx4cfNxZOchNRjE/KeQZk39FbljQEER+DphCPCIyTIgmcmvfgsgUUmB8IU/5v2PQJz3Y6iTNaEOWmsDBAq+EXLd3X2n3W+v065BI3FkKPTUcnojuG52EHww7IUvDiTT/zzhGi5PuZmsiFk0tK4BWMvOy4uXsF0V9a+xjcaQ0GXHYPdhypD/XtjAUFcyF4C3+YSm7xQzfA2HFAPfi//AjFBlgDHprxIQ+PqBl302Y8eBXircJS1IvpFtoyVxA8d4InukFlSroEJfNTPMA3R7ZAMC5ZzDQqBg+CFgCeWEc3PiJyU8HvQ9jbORk4TKmeA23TN6H2HSEwprqwZ72L/f
 BAkQCm59
 LUqiGhK7+jAeJ2eZi/+Qu7JrQAJalKB301ltPOY4JM1VNVvwd/TW0+E+GkhunSv2VpVSPdrbZAAxpfZmOkqMbbmXgTwEOToUSDvQSltELBqkYrkseqLkFkPnCBwFnUUHXtCVyoPXBkFVWf4JExVPFVyfufz41QmSZdG5CjyYnePnwTLMZD3bgH3GJxEKwRD9eoBjQ5IWJZ7pP5XkMSSf7wxhtweRgQYLCDHMOW/w4Beb6hZ0=
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
index 2dc475ea0f0f7..51a4f05c9275c 100644
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

