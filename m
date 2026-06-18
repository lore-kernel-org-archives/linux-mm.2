Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFC0CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14056B009E; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C716B00A0; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64A26B00A1; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78D9F6B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:17:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CDEF166698
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:05 +0000 (UTC)
X-FDA: 84892559850.24.F1E936C
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 44DB740004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yzv3XRnb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfvukYAwbFp2g5Admau+TmMD4cVWEsG3RqzVu1bH8I8=;
	b=PfUG+c30vhz0lxzoPo5xO6++Cg+80ST21RWEVG8r/ETKmelVUj1rzQzR6z2wxPYI358sby
	G5b7kBt2HB+uLSq5M6QCubD1E2FKgscIqgsm0qNqOd41EACu5RTnOdnhqg+q5Vn18JKZpR
	ryKOOhJMy4M+cnUjlsJA/TpittLxusM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yzv3XRnb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776143;
	b=o9zlSlLv+b4eNq+4hp/bSDbhRZXENBvdH5f3OvYFYrXdhGOWb68Uobz0rwsjMU7IhQJpPB
	lkAtswjRjQlGWdlitfuLoI01S+kCGoO3QITRMMnWqvelBuBTlmrE1nGu6zNV1qFzxcM7KE
	YeoKWS42NaS69T9Yvdonsr4f49DpLMc=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-13810b63a1aso410896c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776142; x=1782380942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfvukYAwbFp2g5Admau+TmMD4cVWEsG3RqzVu1bH8I8=;
        b=Yzv3XRnbgO/DMo4s996CSPYIoYMqsMVhvOSlUW78cIOn2OJaxAEkC4Pbl+YOaVcAqr
         Fy8aoqpCzst9PqtOipRlxr+s0bMiqgdeveoCelK64FMQ/8/0h1r7NWwrzVVSvOdqY7At
         QZJJ4bz4Eg9j21CZzGdDU1EVTW20j6YibeNqEdO/CHnR6jRxbwhI6mUVQ3mCo8pWSPGO
         xXykAb3zjDIsx3Kt5vSCTmnRvnruY/8Za8bGjLJcCfxtjDKbsRgjakgjKpc1wCWgujVN
         sJkSODC2ilyIbPVwooSSRQLNHora7VCxGJxQss6rs6kq/N/WqcuqC4xnPdPFej3NPjOQ
         5eCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776142; x=1782380942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JfvukYAwbFp2g5Admau+TmMD4cVWEsG3RqzVu1bH8I8=;
        b=msBjse6iqYROmKnTxOTSfkKijBdrY6ppVLlwrswgsfKk1DDx+f3FQlQyYPAnCUQBSQ
         DIP6w8KmyXa7aDXjBtW5dTBEbeIamSE1+MqfPJFpWSxGuJuyjqgU2lVKdyYLOA9uz1zv
         NPx78aUmUd7JUqpiZ/iWZvNV0+5ryso+JSgSicJJTUCpUoMloRppCRMz+Gp0oHFvuCRt
         LOiil459ZOj7G94RDxK7vreplc0j34UpIobWtv6PFUAE0ym/6m35o8QK8lxNZqzDL3Xz
         kdg85vu1ekoit+lLTefF68SsPUCalW7WLDW34V44/JeXPQ6CoQF/rFxA4zPMza57Vy4D
         GOkA==
X-Forwarded-Encrypted: i=1; AFNElJ8rThrJw5VgrlwYm9xD4/u0DWbg5TkgQPCJLbhz2bA5vjztlJ8F8eJeO5cQVRKHP9ghtKY+7QW+aA==@kvack.org
X-Gm-Message-State: AOJu0YzxFCX3dw7EqlH3dhdttlgAVKFA8WX8Ts+GrDVJWA6Nrnj9tuug
	dZpBAL2/MGze4hY6Ra7e92lmSj1pCZAjotZGqahikjF2u79EY3vyVZR3
X-Gm-Gg: Acq92OGSefGHoJGiZeMK1Jk+LtZQnGQCfSjo/GDeoUwwZIT3v/m10rGD97u2ZXgcN0a
	6VoW9hRnVFNstpgauqcYl3Z+oB9IbZVCoeVtB1mN110uv1o0/x9bZje/NP4G+l7RQAhXRaBX7+l
	xua6WKGzsRb4zAexUJfwA9F0UICm76pxMY8p1Xmj/fXK4nT1ACGUusXpiJekfzEhzAQEMR4F9Z8
	pYvrx0t0hvvOItpk26+6pCmSB8mtBjzledAWq9AvOCAfSiAtMLMOR+J8ukVXc7WDeRauoWzSj4R
	7Me83MrznaiD56LneiHbJa9PzebW7zYLyfIbNeRwgJ3fNNvtWocIHcXE4up4ttvNCW/SY/BYiVk
	fZ+lVXanIjrhOox7FJz6oRccTir5Oudtr2o/XZzfxkxZA1TboYMPmYGLyo5MlR8KSqjltypBpkm
	N4Gjex5mFxHhCmsLRpo4SlnMTl
X-Received: by 2002:a05:7022:6093:b0:136:c565:e862 with SMTP id a92af1059eb24-13999b4d769mr1166356c88.26.1781776141957;
        Thu, 18 Jun 2026 02:49:01 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.48.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:49:01 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 4/6] mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
Date: Thu, 18 Jun 2026 17:48:36 +0800
Message-ID: <20260618094838.32805-5-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qd58oj5qjikiufgruomu9xnrwe5d85ci
X-Rspamd-Queue-Id: 44DB740004
X-HE-Tag: 1781776143-618968
X-HE-Meta: U2FsdGVkX18Wg0xNaVe/YIb5OmMdTZznwqVDTab5Y4wNzpoCHd6Y6sdKKTP0/DtwrgvctQ5QgxI/VDM10pNcCp3n5W+lPa17MbOWPHObJ3CqL0kMoKszCTG/PSh/BGw2oCbN3kY9E+v3DfPIYRl9a1+Wd/PABPaGDiMF7TOaLpxl0eKB/9WObVsNwvaGjJ+/KIwcXwVbpyFOOb2VxPTfnI2Ni+y1ZoGlBaUO6L6esNTYsznfLijEJBn+XqPs9y60/Jx1MQwcwMVXUMT1JVd2jI/t61e+kNSZEOAx/7b5gmJLWFnsgxmwCR0j+GT29vst79goCgNxk2aqRX2b5umfIHI6WtrsZ4gWlhM2h6XaDzO8UqEUXMo8XMReOd++GUF7KOrK9oNNwnjnh8rOHN6ZaawK6D/U2QfOAqgXUcajSI1+/Acbb8NKLghbz7ZwnGpU1mKu2UXZFozT96z6eTp+SBDfhiWPurkmmdB7FqakI4jJYaLndUW4x8FFIJs/I8meU8wtCpBQMZT7G/EEsJJqS1kiCGiquyctAuqZHSLK50XPi5KD7uvrPQgN42GUycpkYwwT2l5Hpreni4PO9tN+3FeKpBDQn5RM4PKA/KRYFC9frKb1MS7NU8UhG6fFMXZf80A86W+c9t0VTD15BAoBUJTz4fpZoxq0moaqZJ0Twf7jWC+1ZFW9fn3wWLWSDZtqIcOdQ/KZ0mHzapucUiRHfQOm301IeEZ98+28QpyrJKMHk0Ol5qaHufQJkmCYMqQhv7+D8BdJRpIGUocDRk/oLvvJ+qjQc14JR3jBY8w/egi06nftiKmEGWezbXJX9bsyA9AL+vpeBKhQdbF3KxSVxLM2QuEMJqz2rtXkIYFTsoZOYM9C5AwvRH1VT9DY0xNspmThjGURiw2srK5MpqoM/bPkVgvutgEL/ft3mTLCXou5PRFb/jIdOXtVojp/fXX32PY8TIua5iokWzctyye
 HmwXPBLi
 8XHgvAbj6n7+3BAIrda0n0mwq8OH9xDFHBfjlTC86Ue6vhx/ilNkSsWkgrmJ+15Ll2FVvsBqoSh9u5dOmpPwIYcYwxlGSQZhEDYmb6P3L8MDfSkJI7wvxoSfopo3970NLqVxGkQf3YJcpiIE2Fh5s/OmcxQLslWKlcDbCL8PDxb7OMnmf0MByAAQG1OkAqvyEb4MLcZVA4V23Kj+/11RKzBtWiU7EI8pWSsLuM8oeSRAi0b7NwOajg9E3ArLdsC2VwKNs+NzPXHdW6uJBLShrcbsiOGKrl+PQ6EyOU0l+YPcAITbUQ/WdGC+t2o96GfqKA0aPf0VQlCNq+qDrptwcpVenoRnmMVvtqWAAnGFCDWq7d4UG6k1SC1kMFygmSjur2bASWRl47XEmwWVWPIeGEwXfZDxy0kZGZrF/0u3m/v/duuaWHPtmI2anbbKeocgDcbXhwa4B/kMgj2JM2A4/g6NXeYKyEzxTMN6QbEbCzoUFauZCppON1TwzPLsQ0w49HcyoFVF/DKilCkqAEXjOHujAbjWFW564qFPnrAXIRmZkgIvcA5zXlpepxNcKFyPWVX2a2TKDTPSjhFefCGvleuz6eH9NKc/pqiT82S0OOLXLMaPEkXvDEshkEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMOS_MTHP_SPLIT action to split a large folio to the
specified target_order, and a hot_threshold parameter to control
split decisions based on sub-page access heatmap.

target_order: For MTHP_SPLIT, valid range is 2..HPAGE_PMD_ORDER-1,
allowing splits to e.g. order-2 (16KB) or order-3 (32KB) mTHP.
An invalid value (0 or >= PMD_ORDER) defaults to order-2; 0 would
mean "split to base page" which defeats the purpose of mTHP split.

hot_threshold: Minimum percentage (0-100) of hot subpages required
to preserve a THP.  THPs with hot_fraction >= hot_threshold are
kept intact; below it, the THP is split to target_order.  Default
is 30%, based on ARM SPE profiling on Kunpeng 920 which showed:

  - 97% of THPs have <10% hot subpages (clearly cold, split)
  - 1-2% have 10-30% (borderline, tunable)
  - <1% have >30% (genuinely hot, preserve)

The 30% default catches genuinely hot THPs while splitting the vast
majority of cold THPs.  Exposed as sysfs attribute for per-scheme
tuning (e.g. lower for memory-pressure scenarios, higher for
latency-sensitive workloads).

sysfs interface:
  /sys/kernel/mm/damon/admin/kdamonds/.../schemes/0/hot_threshold

The actual split implementation follows in subsequent patches.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 include/linux/damon.h    | 17 ++++++++++++--
 mm/damon/sysfs-schemes.c | 51 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5a0587556573..982057bbce3b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -121,6 +121,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
+ * @DAMOS_MTHP_SPLIT:	Split large folios to the target mTHP order.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
@@ -141,6 +142,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_COLLAPSE,
+	DAMOS_MTHP_SPLIT,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
@@ -573,10 +575,21 @@ struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
 	/*
-	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
-	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
+	 * @target_order: target mTHP order for DAMOS_COLLAPSE and
+	 * DAMOS_MTHP_SPLIT.  For COLLAPSE, 0 means PMD order default,
+	 * valid values: 0, 2..HPAGE_PMD_ORDER.  For MTHP_SPLIT,
+	 * valid values: 2..HPAGE_PMD_ORDER-1; 0 and HPAGE_PMD_ORDER
+	 * are rejected at scheme creation time (defaulting to 2).
 	 */
 	unsigned int target_order;
+	/*
+	 * @hot_threshold: minimum hot subpage percentage (0-100) to
+	 * preserve a THP during DAMOS_MTHP_SPLIT.  A THP with
+	 * hot_fraction >= hot_threshold is kept intact; below it, the
+	 * THP is split to @target_order.  Default 30 based on SPE
+	 * profiling showing 97% of THPs have <10% hot subpages.
+	 */
+	unsigned int hot_threshold;
 	unsigned long apply_interval_us;
 /* private: internal use only */
 	/*
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 735970717048..823f1ca9bd90 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2260,6 +2260,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_scheme_regions *tried_regions;
 	int target_nid;
 	unsigned int target_order;
+	unsigned int hot_threshold;
 	struct damos_sysfs_dests *dests;
 };
 
@@ -2293,6 +2294,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_COLLAPSE,
 		.name = "collapse",
 	},
+	{
+		.action = DAMOS_MTHP_SPLIT,
+		.name = "mthp_split",
+	},
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
@@ -2673,6 +2678,34 @@ static ssize_t target_order_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t hot_threshold_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%u\n", scheme->hot_threshold);
+}
+
+static ssize_t hot_threshold_store(struct kobject *kobj,
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
+	if (val > 100)
+		return -EINVAL;
+
+	scheme->hot_threshold = val;
+	return count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -2690,11 +2723,15 @@ static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
 static struct kobj_attribute damon_sysfs_scheme_target_order_attr =
 		__ATTR_RW_MODE(target_order, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_hot_threshold_attr =
+		__ATTR_RW_MODE(hot_threshold, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
 	&damon_sysfs_scheme_apply_interval_us_attr.attr,
 	&damon_sysfs_scheme_target_nid_attr.attr,
 	&damon_sysfs_scheme_target_order_attr.attr,
+	&damon_sysfs_scheme_hot_threshold_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -3048,8 +3085,22 @@ static struct damos *damon_sysfs_mk_scheme(
 			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
 		sysfs_scheme->target_order = 0;
 	}
+	if (sysfs_scheme->action == DAMOS_MTHP_SPLIT &&
+	    (sysfs_scheme->target_order == 0 ||
+	     sysfs_scheme->target_order >= HPAGE_PMD_ORDER)) {
+		pr_warn("DAMON mthp_split: target_order %u invalid, need 2..%u. Defaulting to 2.\n",
+			sysfs_scheme->target_order,
+			HPAGE_PMD_ORDER - 1);
+		sysfs_scheme->target_order = 2;
+	}
 	scheme->target_order = sysfs_scheme->target_order;
 
+	if (sysfs_scheme->action == DAMOS_MTHP_SPLIT) {
+		if (sysfs_scheme->hot_threshold == 0)
+			sysfs_scheme->hot_threshold = 30;
+		scheme->hot_threshold = sysfs_scheme->hot_threshold;
+	}
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
-- 
2.50.1 (Apple Git-155)


