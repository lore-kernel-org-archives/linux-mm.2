Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8239BCEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5D26B002E; Mon,  8 Dec 2025 01:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B005A6B002F; Mon,  8 Dec 2025 01:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1746B0030; Mon,  8 Dec 2025 01:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 876FD6B002E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58341134542
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:24 +0000 (UTC)
X-FDA: 84195329568.13.DA6F4DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BBD210000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aurXw1mb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175422; a=rsa-sha256;
	cv=none;
	b=UVH3UNgimbjeehsLY75/jz5PeYg7Dvu+o8QsHLJX7q17A7z4ac0uvqttNTT0pu01QHG7BR
	R1ZId8QWaUqmsRSO08GCnApUf3/IdDwF+NOgeOvv8ia3VvhTfWGcKca/bmNYQ4XRhihNHo
	sflgXa3LLBIwZY4x1qk8KNDUiDarvN4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aurXw1mb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hzMK7WrIEkt/tycKb1y64Iji3zgOP29tA5gxpF80Qo=;
	b=y1mkvV5il7MZ3COqlJeUQjOfR+q7LJbOYf9EQXSMa73/O+fQPN2BtwWnheeynHvtmS4P+s
	82dQfakOPE0vE6cJ6JdChoz1/zCGDZghb9HxMOv5NXg+ki6XWcDj7+EigQder8DnWUOdn6
	+vjRoZ9JW+mNdi4oz5MdgDXNaW4ttH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28FC760147;
	Mon,  8 Dec 2025 06:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D9BC19422;
	Mon,  8 Dec 2025 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175421;
	bh=WawtKcdhhI5OD3ibegWa6UMwH2uHq8mmOHPfQB4SyPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aurXw1mb7+DNtDpJv9c+X16hkpu7iLBKNTqx3ERbpveUEL1bLXLkCTPqiCj4TmA61
	 sdDkXckh9cBhOeKgjKPG5C4RW0kPzYzcIXKCJa8nnP5u5nOCXNSTx2QctBlb/swGvs
	 /iBJ3qv2lXDDAh0vhogHIF4P3J5MvZlunpW88MFJAL6sZvdwvXN6tWNDAd2axqY46/
	 pFTzuRlkJPWy/c4Gp0QVSh/o00y7K78T05ZGpPs0yzpxZR/iB0gKVvh6/7yQ3EdtoF
	 hdtWm4tjFlzkvelHHAY/sNDo0yA7mqnL6/KVEoqaAsA+3M+hUOKHlY7uJlI97L6nFA
	 Stny1jirD/d9g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 22/37] mm/damon/sysfs: implement cpumask file under sample filter dir
Date: Sun,  7 Dec 2025 22:29:26 -0800
Message-ID: <20251208062943.68824-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BBD210000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: x79dkor3z6rrj3tygmioqmug7tjmn8ab
X-HE-Tag: 1765175422-542744
X-HE-Meta: U2FsdGVkX1+R0ac1Nd5uYCYiulhMuJ+kwFFdFDcnZJGddEAR4x2pb9cif2vncYTZoZTUezK6ZRSdvah60UUviSLtJTu2j0YVMi7eq5a7vHqrawLZDF9EBwO3d1AWyFeURvZL2nVTrk7PJFsxx5GofeAzSy+gWMWR3W6R6tA/I09kmGUKTA8Q9FcJ5QbphC6BVTl5C5mScBrNKNKYodyfPrD2gQUjAr1GwzfGEqEtahJiQHWTbiZVa35/uDncg7rrNPBX6BqixjnHm09XotpdQZzCa1R40OsfrugQX56tHeqPZ7SkM8FMRmoutNOhmmCIVByYufS8Zc0IKJGS6gfumvpydOkt8UEtRNJwLN75axGGblk2Ohg/6FOmKNYx+52nkJL8TVjDWJrWb78UbjcTk4u8jyTleqECE9jBAdWxIaooTeEIPFOVUVZUQgLCsCPQl/MbblZGTDhOBPkW1Ug/p8hxN1ageu4RYLmJkJMBgvLlP6ZoSQU3XzZTZbI5m+RzQxMENaBA3C6PkbLmj3Ciy+nqyJVATGop/qNVoxIGhVf3Y0mVpi2QyG90dgievksoOxAD8ecJ438YuPlSosU04ELHYZlPz2VC6bh2mZIFGFZTC9zWeiE+NqTz4WnZSA/NlFXxylMue9iHarBbTAPsRXveCNpumz8TWjhpcaS880nYF0MYGoGQ6DUUNA4/wJp4KluUS0Y1xY0w1eGLgS8WdVLaMyRbW4hzI0WDXJtsMJ7EdUQB7nwcUUHEGlC42m+XY5XG+JaL9Mg0QslLs9OKRO3He9jltutydUN9RO3HnYPasd+p7xNXS3Ks2rRPWgwowdbfeyhK5gSCIpuq4UkiRUOV+UN600nTVXz0jDtNoAcH8FosPaVoay1tAhvtFibnbfKSi0Ifq+yRV0EFK6buy423OMvIfoV+0JPMgBzYNZVkGHgUFCoXHEhlV3G5GPhBWeetLZxXfOqdPcUaxyT
 GKBZaLtC
 FI/dcqz1kTMe07HmDegXiCIAKn4UAoCo7jZNjAInJUIEUWLw39D0wHKDQ2+PCN3/MrOphUVfX9rhmcDaETT3wpayDeNe1up9mrpHSbzBTiMldLIQRYUU+rmccsI7YvOHaM3LfRyGzMHmPdeumP0dfAfQzeweaFzKSpdQNrMdIagLFUIigeY14TIz/kp55Mp3mfh6r2LZxk2yEChhMV8R/lCpDQj4a8ogBJNedrUJu3CWKp/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAON sample filter directory has files for only common properties.
Add a file to further specify the CPUs to filter in or out.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 74594e6e461c..d6b0b6513fd1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -758,6 +758,7 @@ struct damon_sysfs_sample_filter {
 	enum damon_sample_filter_type type;
 	bool matching;
 	bool allow;
+	cpumask_t cpumask;
 };
 
 static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
@@ -765,6 +766,19 @@ static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
 	return kzalloc(sizeof(struct damon_sysfs_sample_filter), GFP_KERNEL);
 }
 
+struct damon_sysfs_sample_filter_type_name {
+	enum damon_sample_filter_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_sample_filter_type_name
+damon_sysfs_sample_filter_type_names[] = {
+	{
+		.type = DAMON_FILTER_TYPE_CPUMASK,
+		.name = "cpumask",
+	},
+};
+
 static ssize_t type_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -851,6 +865,29 @@ static ssize_t allow_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t cpumask_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+
+	return sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(&filter->cpumask));
+}
+
+static ssize_t cpumask_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	cpumask_t cpumask;
+	int err = cpulist_parse(buf, &cpumask);
+
+	if (err)
+		return err;
+	filter->cpumask = cpumask;
+	return count;
+}
+
 static void damon_sysfs_sample_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_sample_filter *filter = container_of(kobj,
@@ -868,10 +905,14 @@ static struct kobj_attribute damon_sysfs_sample_filter_matching_attr =
 static struct kobj_attribute damon_sysfs_sample_filter_allow_attr =
 		__ATTR_RW_MODE(allow, 0600);
 
+static struct kobj_attribute damon_sysfs_sample_filter_cpumask_attr =
+		__ATTR_RW_MODE(cpumask, 0600);
+
 static struct attribute *damon_sysfs_sample_filter_attrs[] = {
 	&damon_sysfs_sample_filter_type_attr.attr,
 	&damon_sysfs_sample_filter_matching_attr.attr,
 	&damon_sysfs_sample_filter_allow_attr.attr,
+	&damon_sysfs_sample_filter_cpumask_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_sample_filter);
-- 
2.47.3

