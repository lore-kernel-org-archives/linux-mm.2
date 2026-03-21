Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518F4109447E
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFDE6B00B8; Sat, 21 Mar 2026 10:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397516B00B9; Sat, 21 Mar 2026 10:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE6B6B00BA; Sat, 21 Mar 2026 10:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194826B00B8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:09:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6318C2142
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:09:38 +0000 (UTC)
X-FDA: 84570253236.12.26B48D7
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB43AA0015
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:09:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxUvRyjL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774102176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qYuRLOkVEr0vMq2UyeWKGNVMl1LS0aZ8xRKS/OadUGE=;
	b=DCpaSpttXJfkwtP7D5GJTf/n27tDQj2J1EXSechdQG1KaI2iNSQh9mVbltof2lQjFfcNW7
	f/7lTc8N/kDcmLCsC3yJpbABt+ToKV6h3vHQ3HNQJUVch/Mz6iXLIHK373lF1BhJZHavEa
	fnxJZQFimZCMxDh1lV4WKg5jS0wqSo0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxUvRyjL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774102176; a=rsa-sha256;
	cv=none;
	b=pdLtHwWqtPSLG25FaXXt9M3haz6iEc7DuMajlcNQyHlhJfAyfQZSxCB+OilArnuBn/Wkvd
	fEUp7KmIZKUkoZsYq8T7DHMZxD72Yo4nLtnUkyETTGIgzKoe9QFv6yVeS85ROoampKcweD
	yAeOTahHGjeIdIur3gElOrFJniy6J1s=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ad21f437eeso24283905ad.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 07:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774102175; x=1774706975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qYuRLOkVEr0vMq2UyeWKGNVMl1LS0aZ8xRKS/OadUGE=;
        b=HxUvRyjLvM/wq5HMIoS+yGyHyK1VtYcN7S+tl2KUPqVdlwRSXHfnxQhDs/RmhOiS6h
         qBT87XC+QgP/lQRivD5JqGZ0/Xk0LE349mwFioas4gr5tB0ErwVspysBMZPrzAAv2q7e
         A6V+ss4nrAocj2a/0a6oksMY+7w0IN8VRH2KNh4Xowf0/9Eu5x9QYWMONIPPnSPEN7Qx
         0gY5Dgv6GAtKrs7kUN9WIDyuyNIt/lFdIqU+SdSwed4bxFPszYopWVqn1mKTrr/4h2OS
         ye+zd3P5IdjtZbS1wVy3opPYlaRVBb0Ua4wUEMdy82zBkBLRgPr5KI/LbEnf5a6MaZl8
         3ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774102175; x=1774706975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYuRLOkVEr0vMq2UyeWKGNVMl1LS0aZ8xRKS/OadUGE=;
        b=R6DQgM5RE469o8PTyHYia8NLHV312PL9vZu5kpIoyt61Dzt7sv21Ag+fAhP1V7qr2F
         gJMOLLwoTB17wTCNBvKD0WUY3ip/sbgv3ModkLYByLwAIpMXjXRw4NssiBwNCVvDaOl4
         UVofxN0WSjvGlb7zAzqgz7IDsATAdLd+YdEtChcytsHMOu2iqRv4OkJ+/y8os6BWIhmi
         AAR0MnS9OjELkzsM8KOTdn5Q9fo3bIBzJ26lzfBKKCPil1Bnk+scF4iRMCDz+/HUS+3t
         1B38QHgiobTdHYhEcFw0ARbw6aY1lYceA6EFgRegkCuz9eOR65IKiEyvAYXV50rtlDYn
         RNnw==
X-Forwarded-Encrypted: i=1; AJvYcCVUit4UXwD2+KsfggS4J386M67Wd76PubF8M2A11yVZBFKHSJQhxHkpKPzL0HgV1U0dDGo2+PiO7w==@kvack.org
X-Gm-Message-State: AOJu0YwU3jqOIRVXMPUbA+TVHVvnPA7v509Dp2iPvuwiIDtPW+hO3/MY
	MqowFWVB+w3iB2C/ksc9FjfEJih4jx1v7PmXkpfUB8yY6VCdIVM39HWz
X-Gm-Gg: ATEYQzycTmPOwCl3ySzCvVjsgjTMx1GN0ce/0gMpMkiq/oy2y//5TkbgBWVA3pzDg50
	YPRgY0xIIWQdC2AaOaLsp4V2Hx4EtxwHePIuleSPa/gdP9D2GBVdQHkYKhZAbSKqOc5sX63AYtI
	RAWAYnByMJyDK9oa8zsIPBvrJyvVtQjR0i3yq4T2qJBPx5FCciGOgWoFr4CaLfljVr3Cf8hVT5T
	dFh2GOx9zN18w4TvNx2UFjV06AdwZHhG3GsfreHPwRcFtqFslO/T1FbThVIGlPyC15WiYIcnsf1
	97eLEMCVgt+anP3fb2YZHbth31cb/QdsZsekRKIByLvLMDM7Vl6hlVD6B2YYprLvJvuZytNzDdg
	f9beQMtFY/AmKIA12GeTvxbnWfqsi4BAvQtfE5YWqlQDYvPGnEnqswwcSHWRL45DcvG8HwUel97
	Yc2apyRiyKrHS//1Acz7lIDIUyxRla7ue84+B31EdDLsIxFWYAh5M=
X-Received: by 2002:a17:903:b84:b0:2b0:4446:5a34 with SMTP id d9443c01a7336-2b07724f804mr84505275ad.27.1774102175434;
        Sat, 21 Mar 2026 07:09:35 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083683a8fsm49609995ad.66.2026.03.21.07.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:09:34 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 22:09:26 +0800
Message-ID: <20260321140926.22163-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB43AA0015
X-Stat-Signature: wj8jtfg7rrsspxxygm8dfdb4q5y9r3bk
X-Rspam-User: 
X-HE-Tag: 1774102176-96311
X-HE-Meta: U2FsdGVkX1/hSkccbLRUpEehEn7EO9lIaAnziigCq2/fnj23VaQhOYS5a/wZzMEKwan08m8sYvGO1VOvLFjglLjkgPLRDKPIOvUUskTPvr6GHp6wIAAOwu0cIKgf1+UMnzHGEpxrD3BB7jLb0qoyutxZKxVC8/lPzJtnx0SJT0mDRf3XA/gUhmwkDLyYh12lXfPAC731wU0jonZlHKa7uCFWtb7w85LJ7a/cYCZO9gDC530WJth0YkRjA1XFRPTSPt85Mf3C4OR9ntdp1JiggVpN1tAKVYg1ZoqhO16C33zWBOYJN2BaIAbYT6a5bAVNIqeJBhI3r5E6jiywNrOQWfO6UpMy/cx1wtg1ak5eveEkD2ayuHX9EWIEZcQoBdoDHAexVQ9kX1f5cx+6DSEwdBUGFJMb2DyH7YPpqwEs0ZHgyfTRg20n1/cU3tnsDCuyDVX5SrGifHKGPm5tYvXTXwqmJGTm5qoB4LQqWaDhRAxvJ+p6e68zAU3RJSTNkJppBPrfeciHTCRQIIyPt35RBM3fX246dEhCqzKBMd1QSCdqCWzVl21Pb0J33LexiiP4EdoH0MbsyrIrcn8wZGAu6tjb3B+TEcbM3wlwEKByXmJjFNROryNEQhu90fh075PfMOZlOKBjGfrxiOaTgEuaFqp8dmDUK6SAXS6Q/gYrf9O1exQjy09s3XtS6+p18SdDew1v4P9b1P6xG5E0bt9FuJ67jtr+SDF3iL9qYaz1UcJVK1WzDfvL9I9MCzemiV/YFxrLzEAfP9Y1tMvY8Ht1dm5S1ImDhbMUjWAnZBzEMvSh2X0FnaY0+H3vEmAO14pmQzaa/7WVELPtZExN1YfqLzMZHvdXUY9cBdRGc6fbZIZxZrr7B9x7EDVU6qgYYurBlfeQ2X9oVZ7yh/61lA3yE7yQiK1JLs8diXfnogZGscNqL/SXky2IkWEm5m3IeD8wOuCPV3ykAWdpK63HZcl
 xof1ELVj
 eXtj/5zAgF9zAZWy3enhkftWRAk9BEet2lCPElFvDNPGkOG7crM3ztEdPJEGWXaTHlpIUuStZeG2xlna8YxupEd/uIgmbJtXnHv9aWhTuMALHoFD+g5nbXLl00orS6Vcm/r5xJxqOEdAempgv2X4cslcJDsMjRcLDEw7Y14+7uZEMBLjVNMaaH+qshfcPhNifH0+yyXdmJ/d4Jap0yxlWSIAHm/ictAuRVpwstVqzoU8G0eXO0qmxDIE5+XzujDjGh57uyeZ1ZTuNr/Tw1IVr2s3XQ/iHpzupo21rFsSXub0f5ENkX5I1aLIf/Zc0q/tC1Ctso5oHDlcSqonrLY4xM6KAWHecKBsRL871sNza3u3VwVrtCuHhkQHCHTVGuhGVoMLZ2mk2MIc/DvaHr84c3QYi9C4Nzbs92KF75hZy0YB6t98hQ49sqyA0ZiT7ggEdGfrR9Mf4hJp0v1pps9GBoBGHopjPgymef3wpeb5/AfmLiG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
aynchronously in the kdamond.

Solution
========
To fix this, I proposed adding synchronous validation in
damon_lru_sort_commit_inputs_store() and
damon_reclaim_commit_inputs_store() before setting the 'commit_inputs'
flag. This allow users to receive immediate feedback (e.g., -EINVAL) if
the parameters are invalid.

Changes
=======
1. Added damon_lru_sort_commit_inputs_store() and
   damon_reclaim_commit_inputs_store() to handle parameter validation
   before setting 'commit_inputs'.
2. Added damon_validate_attrs() to centralize validation logic.

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
Changes from RFC-v1:
- Remove question from commit message area.
- Added synchronous validation for DAMON_RECLAIM.
- Rename damon_valid_attrs() -> damon_validate_attrs().
- Exported a new function damon_validate_attrs() and declared it in
  damon.h.
- Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com

 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 34 +++++++++++++++++++++++++---------
 mm/damon/lru_sort.c   | 34 +++++++++++++++++++++++++++++++++-
 mm/damon/reclaim.c    | 34 +++++++++++++++++++++++++++++++++-
 4 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc1..00ca58dbe978 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -997,6 +997,8 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
+int damon_validate_attrs(struct damon_attrs *attrs);
+
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4dae03a37f9a..a459cdcaaed2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -751,6 +751,27 @@ static bool damon_valid_intervals_goal(struct damon_attrs *attrs)
 	return true;
 }
 
+/**
+ * damon_validate_attrs() - Check if the given DAMON attributes are valid.
+ * @attrs:		attributes to be checked
+ *
+ * Return: 0 if valid, negative error code otherwise.
+ */
+int damon_validate_attrs(struct damon_attrs *attrs)
+{
+	if (!damon_valid_intervals_goal(attrs))
+		return -EINVAL;
+	if (attrs->min_nr_regions < 3)
+		return -EINVAL;
+	if (attrs->min_nr_regions > attrs->max_nr_regions)
+		return -EINVAL;
+	if (attrs->sample_interval > attrs->aggr_interval)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(damon_validate_attrs);
+
 /**
  * damon_set_attrs() - Set attributes for the monitoring.
  * @ctx:		monitoring context
@@ -778,16 +799,11 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 	struct damos *s;
 	bool aggregating = ctx->passed_sample_intervals <
 		ctx->next_aggregation_sis;
+	int err;
 
-	if (!damon_valid_intervals_goal(attrs))
-		return -EINVAL;
-
-	if (attrs->min_nr_regions < 3)
-		return -EINVAL;
-	if (attrs->min_nr_regions > attrs->max_nr_regions)
-		return -EINVAL;
-	if (attrs->sample_interval > attrs->aggr_interval)
-		return -EINVAL;
+	err = damon_validate_attrs(attrs);
+	if (err)
+		return err;
 
 	/* calls from core-external doesn't set this. */
 	if (!attrs->aggr_samples)
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..883860721d3b 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -361,6 +360,39 @@ static int damon_lru_sort_handle_commit_inputs(void)
 	return err;
 }
 
+static int damon_lru_sort_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	struct damon_attrs attrs;
+	bool yes;
+	int err;
+
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
+		return 0;
+
+	if (!yes)
+		return 0;
+
+	attrs = damon_lru_sort_mon_attrs;
+	err = damon_validate_attrs(&attrs);
+	if (err)
+		return err;
+
+	commit_inputs = yes;
+	return err;
+}
+
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..6ea44b02cc76 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -267,6 +266,39 @@ static int damon_reclaim_handle_commit_inputs(void)
 	return err;
 }
 
+static int damon_reclaim_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	struct damon_attrs attrs;
+	bool yes;
+	int err;
+
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
+		return 0;
+
+	if (!yes)
+		return 0;
+
+	attrs = damon_reclaim_mon_attrs;
+	err = damon_validate_attrs(&attrs);
+	if (err)
+		return err;
+
+	commit_inputs = yes;
+	return err;
+}
+
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
-- 
2.53.0


