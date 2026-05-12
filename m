Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7CACD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFFD6B00A3; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD546B00A4; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695E26B00A6; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 505FF6B00A3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 121C8C1E65
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.08.809AD6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 56C7540015
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SHMVRwn/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPpgt8uQhwb5QEc0FW5ir3Y+kErBExDQbIaI9fUx4lk=;
	b=hMSkaTuohxjH94/nbMR6wSQyhVziW6OxWAD7L72xFSJYALS/0jk8u5uwd3HbeYDGcqSkF+
	nV0WGTXbYBs6pDKsbb6FFnpokIhvT0qbNBdRVd/Lyi8L8CiBboazEb/rMjSFJ4KcG/ZZln
	bJ+/qRBTf6ErNJvT9JJBeomkwenXOx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596623; a=rsa-sha256;
	cv=none;
	b=Tb9DM85M5QWeMx+qpcEADrlATtwatMUXc/1gaR+/e9UMVvBF9dHg0P0hc6lztvZP+yynBT
	ngePVmmjn6oXLCaKvrPF5x9OJg4mqWAGRfQuiDmPZpF9Y+Wg+RWiTM9hdy3psN6USzKT33
	b/Hbqk2XI/W47qlV24b1wJWtxL2jo6Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SHMVRwn/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A69B44AA7;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429F6C2BCF7;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596622;
	bh=xxAnM/x521/ipQQKxInfDno6KUEv3MR4zVVk+LBGBIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHMVRwn/Zeq/e9kwvzPieilOrUAThIlto2cdeb1Wer75RXW9pVv2dxib7XoLbdgc5
	 uIpXH5vn+w6f32RZ5L3CAGnggs7C2n9ETWUc5zS0bLVydTu0Tr/Ur85iyS5LShlX01
	 mOOWrGz3izK4JkIh1JUioFtrExhQswzF+HgGD01eH/uhAaFW6amHiISOW9fTrRVh6C
	 sN6IdHSZ6oyr1zRnw394QDRqbn3a3MtgR4f64evB41gS39KxxIDm0qXyk8acpqiuS5
	 LTRZ+Av0JPyydd9OeE1QdmMCX3re8QTLuYkPN0SZwJVtsefkNSfwFjAWGNEjQUhctM
	 Mb30YvG80/3/g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 13/28] mm/damon/sysfs: implement filter dir files
Date: Tue, 12 May 2026 07:36:28 -0700
Message-ID: <20260512143645.113201-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56C7540015
X-Stat-Signature: thdnajnosizj94y669nka1gixq8pieyd
X-Rspam-User: 
X-HE-Tag: 1778596623-676148
X-HE-Meta: U2FsdGVkX1+/+Qn0KsepCKphT9pU1E9QjVw59zNdSxslqFISeXxmoU6AZCbms8ZNcYmsx/Zr89B8KOhJlcaoPXNG7ttezMVr2AO71O9LghGJlIPNO+54wGFdVSWU4i/z4X2FkTNOAnin22hJReu0/v/udm2YQozUw6Ah8wtXTnwOj5eAdtsSndFxJ7RVpp6rCZBxrxieoRwIxQI2KBJL8ZF6UImJVIDoX9vy6kaWOPgBeqxnTE65XGXxtnQ9PNIcbY0PLay1w/BGcrmcmid4ghi4tTStUDhkcE+0wTDBKdRX3TXhgxA+VaZTsFx1A8cCcoYNpYxEGEkpdviD7S+i18Y+gCJp7oWjCVLvdRRKJw71PcLMd1NtAVxP0OPVtNhRSOxry/pmlnpirl1666FbABueRtwmNEB36QC5muHJowWch7q2N5HTY6aGjD9r52xP+ktviz3JHJ7dL/VYawBoeTLN8GrmrIuuS0MnjEHVmlewfp/VbF+B5SYvlrx7U2kf/TH1oWc5nXaGYG09lMEvJKpW+fzwZyn4Y/WT18hLpKeADujUvc++0m9Ym3sXuj2zl2srX4PZzMNtn0dRgK/hhmHt0ycIGcaXVvVfxfFQQBoNjXZ2twfM7r4a/k5o0Jakb49dlf+jAceARyQpeRtyMSy8eNHLwD89i7ZMFon5BowbKd01uAsft0yW79BBQ0ETW6Z0pYevH39LJLt9wlqSYH4qV0vIA5VwpBb/vZnVtjCBYlvgZw6n+zT0gjjpsNA0zxUqo4VVzNEMnLsVU3PI/zrXMRpDDKVeu7YVkVoTrN7AuF/b254N3aL0e2k1EnyH0RqXfhq2XvxM3Zv6Nrx2Wz3ZIIIYFoPmeylOaM3jJ7j9RQrpnwueKRZ6kKwR2oNJH1R6Uc1J+GtYXwnS07IiODIVMIof75dRWCNjJyNWCaZLuboBvW9xC0micCoxC0N8bpFDBK6Vj9s3F8A/hdO
 ht4K7eqF
 fAVoFTYZAThfCviprrWlkUuYn6UU8E4UKfnWXlqbidOchk6HkaxTBlDoh8p0CKzuUGLxJ7t/QGUlwjLQGYjZ3XrUcFm9jz/kkiS3TscaZNv6BCjz7OjCXPVXy5/ItGz/um3+COH0NMV2Vx/zgWLMKntooo19i9tIVz7MAofM7fZmT1umrh5hipnYAtunUcWnZBpdpFfyeYuI7amj00cYmFjr9tLes0zqRvjfahFNC8fLLZ6M=
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
index 25487a0268cbe..ed7bb734a236b 100644
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

