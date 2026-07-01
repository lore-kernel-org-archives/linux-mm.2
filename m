Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FC6C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDF06B00A8; Wed,  1 Jul 2026 07:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6056B00A9; Wed,  1 Jul 2026 07:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213176B00AB; Wed,  1 Jul 2026 07:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0150B6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 740F48C857
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:31 +0000 (UTC)
X-FDA: 84940032702.14.B1BB199
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id A50FB140008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGKosnee;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906449;
	b=ni/H2ww9GeVu9XoJBtS8DRVaIeDevBuJWGeSWJCAzAQ+9NXLQm7mFa5UgNkWMBpehSPHiu
	UHWlR8xsi8vX2+XiQRvlUwMPqxLpB6rGYL4AKhVFILmwJX3Z9zZ9EmDZ47nt5HQSl32q+v
	huEiDbeN5PXLEYHqxerg0Ek1gqBMmpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzJQz5GnN2ox5PLzrp2Ge3nxM0G2/PXl7LwNvmx7vnM=;
	b=0cy9rvPzc1fwBU3K/+BeLxywD7zNLXdv97SjFk8EMJaO/i9KUxak2gvSWHU2qxKV7gKOxx
	nAbDeTIdel1uBTLGoqXSaAY8zhQ8Ts36asL1lhro0lEp4ftsDw87f/YGOoI6Hm5OOXGYZO
	/IWnotphI0YC4JTj21LQ/pI0ZqPXacE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eGKosnee;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30ec3dfbcd1so933553eec.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906448; x=1783511248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bzJQz5GnN2ox5PLzrp2Ge3nxM0G2/PXl7LwNvmx7vnM=;
        b=eGKosneeQn0p2h5ImHLycZ/eQZr23YFzncHbsAL9x5up0OD49oKbqyd+xdkFRp8Bf0
         CfJ6VwilyPIrYnxOths2rydq+bqd+/1q+RJXe5/j5r/5ayuFHxLUWmTFZlOCYjTfkv7e
         gxN8+X70WV5pSTo7KSMKQRUIBZmi7oawyB1HPILrwqfF8Z7LJOYJgr/cj5OtxOSXizxV
         Ag+YM1K/lrC29W5FJqMRZ1ZbDGqdjV8F+kaIlr67qtmUbC4c34YSAN3O3RoUn9jFZ37D
         PYi4VYWX+muKT/RH5sHrbrKZzm8R58eE7WobcKB3D6dnzUXnvYxXxQnJjIIngtso/Rsd
         tyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906448; x=1783511248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bzJQz5GnN2ox5PLzrp2Ge3nxM0G2/PXl7LwNvmx7vnM=;
        b=oFQRzzLKs/KCa9ruTgqEGttK6WcM8R2zTNVqO3WMNDL+h1PSShkbhfXa+ZE6j/JVuo
         rpzT3ZCE2L7Vc6XtTMkO98HHFW6vHG6zdSQVSHDGFpdHfvEnfIUO4SdYdmoJueD9BM6e
         QTEV8TfW5IL2rG11EgiywhOfinTPzX4fRsaO0iWa48d5n70e+rhwxJW08A+lFpHUOa5q
         PLenBU7M7/JzGQ4Gai6AJxL4a6yf4aJPX/bkBUkPMtczszZ+mttb1N7KdwAd1z2D4HxP
         Q8W0zFdJ9rB/BtDkvA9wkvA+CQ+sn5bjiTMowCgxgLhicvlZ41OgIpi1UIqNP22yBrtF
         WmgQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqVVMzfklTJXhz8cumPpbbg+U4+K/3JCpIT6h9FG3AK1JrPaN2UGSN1X+HCaWpnDroX1BCFbkUcA==@kvack.org
X-Gm-Message-State: AOJu0YxcuLi3DAXib+Qp1oFnj7VtuKne09VC7+/gTmrFaBSGbop88tFx
	6CtNuCoCckuxEMKcGrzzE4y3auOfWThRLvblHWPy3PtZVn2mF/EO2gHj
X-Gm-Gg: AfdE7cl7peXYAUUumjaVHgF+oKUI1OCoqPPhh2n9Lw3RnkFk4pfu0jWWgkT7c7zqk2F
	+/cQulGTM8ufKIwwrIEQYaivQnN3iRASFmFMGkJxCKQPrOwpZBc1aGzRnWa4BHzxmUNTYgj9va9
	Xnnof2KqbWie1to8L3bujiOgYlWDlWx2wlyhuyQ9OB8BzSXcWhXMxom8I+Krloh9cpoaQGUVMl6
	tfkKSDsYktUxtbPX2sRK+ovfTdjBbNDywAGMe8qV4zrAXfLB+pBItDZOpt7KZbRYCAHwI7Ro5pm
	8UyR6Wu9iZypLOy3Bt1jZBh1V6lnP6xuq4LJjuSEIWHaUvGGFT7I7fkqMGIjRb7UmP9D3f0ObVz
	ke47ib+/hHU6uQnzUSODJQmh3X8hOFMMIW4N8wLHUd3aS70UA9vTwxJEYWQr2oM3Ko4kyGG9n8w
	H7xg==
X-Received: by 2002:a05:7301:2e85:b0:30c:efc:c399 with SMTP id 5a478bee46e88-30f05434252mr367328eec.35.1782906448364;
        Wed, 01 Jul 2026 04:47:28 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:28 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH v2 1/5] mm/damon: add target_order field for DAMOS_COLLAPSE
Date: Wed,  1 Jul 2026 19:47:12 +0800
Message-ID: <20260701114716.56503-2-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: <20260701114716.56503-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A50FB140008
X-Stat-Signature: h1aroe9tg78a8zbohwffjub5y1jus4xb
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782906449-129746
X-HE-Meta: U2FsdGVkX1+1OMpN36NTPa7A/vYWD8zoU3FHFRgwFwe7WRY2Lxx/yNi5IosmqkLvW17Fk4ML1uhWmInk6Fv8qaF5a7g7AzBWaVfEyvVFxS7noJrHvv9QykiIfHDJ1Y+OuprWpASdZ9jGn1ugp/y7D7fdsXC5vebhvP//zQu26KLMnhEUXRUTIuB/E1OJedjCCKpZIWHk584dm6oH1WvVGpDaLLZQmu7EOj+xXx1Lg88jIdHZxd0c/hPNmgKj7Zn36d9DGJa5NOFaN/rMjA/wQpfZyW/r5/bf30OIRGAoj7vCWoxfj9HdHtBEu1EaLQWUxBsOGFI6XfA1Vt2ESSQTWggDkjTfF8Mc4RphqUtbXHoFWZyaFSTWv7kqmZlp3SlqbxLQMerh8RXZdAwiaKz6wQjHUgv0MwjA9ozfMzrjpBYZHX/wJ0kkdiHEBLq30aWEwk2RIKmei8Os2hiOGYktiWdLDmXQngCLzzK7iZSNssYgaYB31DBDf1t/GUZ0Xao/LEEz62TjrYE8mbatRfNmdoYjZU7o4AlWg8owfgkBLLUd3Isy1RSCh+7/Rmv13qp6EgbYveukpQiafrNkGgz5+zCLYGcEyD4bVG/JKv2P3d75J6yUoUxN1Lm8+vqW9f1g5qfnRaRoe8fo1s8GzLEYN0Ufm5Vg+xRf7PtBs9HEh/IRyEsvDGMsvvwg7kNs/ahxOJ5qdqeHR/hVUW3fdoASYV6EZ6nKIUgcpelIGS9zgWXGkJCCwkL/wiA50TNdyTFfJNBtJo6w+UZ0hmig93aIm3C3gEEovMG+8aO1hUTvRSYBlf6+h7UtF/canB1kOpygXyTEIwDPrsf0Z5JD5Z4t/w8rvTGxzKBG6PIe4WOjNzrJZUk13I+ypzcifG3sRH0PGkEUuIpllag0KgXEamyHXsNgSKhvy0M6rWQJlKw8TpyT70YWflj1UJJbFRUkuzCLpldbqNZJxEK05lvs51S
 8g/Jo7pe
 1L9oMAuzkMuuQgtCJgPDst6jCwKF5mhYz7Nz31O0UkhSjC/w/7ypTbceLlDYfSdfcuO6Abwe3DmjGB1rtlIrYWHBY+EUR4nJ2+S6ihBPcYLj9+1CkQZ9+vdXOaFZzx6PEK+2yqI9BPp9CxPanU0/IIkIB/fsszAmCM0MnLdl2OHJuzvl3cvkY8Vhh2ut5gb7v2XmeMvbu9hvKo6vofmvmtjhhIF+U1sTIHZJ7qSIYPmRjJlueHi5CBtRV59LKMOsuka/u53W4UGU5UqMWbwJCgzYpEZAjCSmU1SqM45+9ULRWThpuAfs7+IkKUqMnD5UGT1iMuyLrxvBc5mIUu7Ww4yv8rxYDgHtGi7jG9bzyfXc820gbFeb8enp1cSepVPA3Onv4uZ9pZwtmaSNrfxWqK3YMJgevpa7akyEAcwh3iW+9xgPrpgtEafY95dIZD6LwX5Lu3FKLPwzWfIK7cumTQBsV1QLARKf8Mn+PSYhh7v0hHZ6EYMSjkzojFFoy/zx/aEdEaVe2XvIASQSOv6ewg/k83z2uABHh6T81MhCXNGEEbeIVyNifEanZBJ2tqpZ/F33mdKFkZKu+6H2tzF9fqOPbDVqe9yVV6JRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

DAMOS_COLLAPSE currently collapses into PMD-size THP only.  Add a
target_order field to express per-order mTHP collapse intent.  Zero
means system default (PMD order, same as current behavior).  Valid
values are 0 and 2..HPAGE_PMD_ORDER.

Wire up the sysfs interface: a per-scheme rw file "target_order".
Validate at store time that the value is in range, and warn at scheme
creation time if DAMOS_COLLAPSE is used with an unsupported non-PMD
order, resetting to 0.

The actual mTHP application via the khugepaged wrapper will be added
in subsequent patches.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.wang@processmission.com>
---
 include/linux/damon.h    |  5 +++++
 mm/damon/sysfs-schemes.c | 45 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6f7edb3590ef..5a0587556573 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -572,6 +572,11 @@ struct damos_migrate_dests {
 struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
+	/*
+	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
+	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
+	 */
+	unsigned int target_order;
 	unsigned long apply_interval_us;
 /* private: internal use only */
 	/*
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..735970717048 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -6,7 +6,9 @@
  */
 
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/numa.h>
+#include <linux/huge_mm.h>
 
 #include "sysfs-common.h"
 
@@ -2257,6 +2259,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
 	int target_nid;
+	unsigned int target_order;
 	struct damos_sysfs_dests *dests;
 };
 
@@ -2642,6 +2645,34 @@ static ssize_t target_nid_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+static ssize_t target_order_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%u\n", scheme->target_order);
+}
+
+static ssize_t target_order_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+	unsigned int val;
+	int err;
+
+	err = kstrtouint(buf, 0, &val);
+	if (err)
+		return err;
+
+	if (val != 0 && (val < 2 || val > HPAGE_PMD_ORDER))
+		return -EINVAL;
+
+	scheme->target_order = val;
+	return count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -2656,10 +2687,14 @@ static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
 static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
 		__ATTR_RW_MODE(target_nid, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_target_order_attr =
+		__ATTR_RW_MODE(target_order, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
 	&damon_sysfs_scheme_apply_interval_us_attr.attr,
 	&damon_sysfs_scheme_target_nid_attr.attr,
+	&damon_sysfs_scheme_target_order_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -3005,6 +3040,16 @@ static struct damos *damon_sysfs_mk_scheme(
 	if (!scheme)
 		return NULL;
 
+	if (sysfs_scheme->action == DAMOS_COLLAPSE &&
+	    sysfs_scheme->target_order != 0 &&
+	    sysfs_scheme->target_order != HPAGE_PMD_ORDER) {
+		pr_warn("DAMON collapse: target_order %u not supported, only PMD order (%u) is available. Use 0 or %u.\n",
+			sysfs_scheme->target_order,
+			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
+		sysfs_scheme->target_order = 0;
+	}
+	scheme->target_order = sysfs_scheme->target_order;
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
-- 
2.50.1 (Apple Git-155)


