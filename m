Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76786D41C31
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477EA6B0005; Thu, 11 Dec 2025 07:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428F56B0007; Thu, 11 Dec 2025 07:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3181E6B0008; Thu, 11 Dec 2025 07:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0C26B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:56:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA5241A006F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:56:37 +0000 (UTC)
X-FDA: 84207189234.26.FE3744D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EB4C140013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:56:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457795; a=rsa-sha256;
	cv=none;
	b=jl9UeInjTRN/h262V2WoUzDhDRlnjiZyoW8fRVljaMjUrym8BWacByijtUvCIimeA0yqHK
	BP/d5Dls/cNc5dh0INinV/iDKijF+NJphzgSh2v01qNBmdfC3Xq810trDYKf/k6sq2RgFf
	uJFMvcpX1iqxBpvYDDc0LCgvglZh8tA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IApp5Zq2pWN9QswcUIPFDpgq3y5QzfcLSKeWPisFBsM=;
	b=FsjQHh/KsYFIyyyjylAq3vjNE8oLb4m3TYRMtZCfs0LPy8PrU3TOUKVqsRfcFZpPbmIkj0
	YyhrQou5IvwfqYuT1ma8Dm0GR1qul+WxVCAU1nOeeR5/fk0iFv+owWFWuG1VnBTXGR0p9B
	Mjv0mhUGgBcjayGG4NbCUhpV8/Ao020=
X-UUID: ca2bc78ed69011f0a38c85956e01ac42-20251211
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:b815228f-5004-4bfb-8de6-d055e296cf9e,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:b815228f-5004-4bfb-8de6-d055e296cf9e,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:9d3d869a785c8be25cb357e3a72a6f05,BulkI
	D:2512112056224ZFS4ZVI,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ca2bc78ed69011f0a38c85956e01ac42-20251211
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 262288006; Thu, 11 Dec 2025 20:56:20 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon: add loadable module support for sample modules
Date: Thu, 11 Dec 2025 20:56:14 +0800
Message-ID: <20251211125614.1242713-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bsqrf39wswp1hmzadqf6capw91it3iz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EB4C140013
X-Rspamd-Server: rspam01
X-HE-Tag: 1765457792-380614
X-HE-Meta: U2FsdGVkX1/47yOdNq8OnXiYJKhJw+9GQqmpwcrSGiAriGMUxH7gqUGut2NGO29Kl5NHkDZCQUXEx5GuPnGD4LoR7XZ4ic6OPdBP/AErEXM4tbmF1z6i5LkKUwtZlMN1grGdNhSsFzxgihGng6/MF5DAuvsZouVYkR2XCh1Hb9+QbJk6oQzQID3nlnbsyfwGWt/s0BbuiOuyg+89dRxlCHGD51qeUEyxEzA73E66FktQG+Z4okvGMu3DI+97hriRvMDZ0J/13gPClbuRet+qWX8STNc9Sobo7n8t65kDDRlWYe0Zc6THIvdI+y+tgbLoNyjSes3T1TnHV5B0+RkULanAdlMSV9ftBZ7XLPx3bBh5f6Hz2bgm/N+FY2lP1lsjc4tohNqNe3C8czMSmwEA5hZRxxqR+oh/02XmFTzEGDkGKeog8IF+lDDAEuzQ8rvnJMMcRHzvNP0QmQoLxeH8z2VyoMbXjlnF5rAZDi298RjGcnBTYShFZFH85HVgVZDuq5vrS/+hWpufuiKE/ABuVFElH/56HFLLxjRizh+6dBewgLybi7ir/SmWgg8AeGo+S/UGVWiOonPhIN739gxa3I/j9yZSA+hatgSSds9iqoO8zXLtlgasbvy6fvQHQcESimd954UWHmwpLGwkamxKBKHyX/rsGk5wakymxxQrtu5bBTKTfNcI2Jma7pDWssuRXmvaKgrlRr2ZmVtIpChQ+nqxQX0lAeyDoe5E9qt3M+aTS+SJkls6AHr36f1pM1el0yfGRcpYFqlbP1xExAeYqmFbEvIMX2cQpJ+jvkwXGPELMwpJiYCCrx32uBQ+wPxtEBYSOaX+g+3AQMOEbTYYNGSClpO9s2WKYZtMl8nxlavGk5/B5xd3/WOUwgGaFro2RSl4+3tvbugoiqCxWbQgthbXOdEQUVLc/cr/Nvo9jYY5K8ZLuV/QboTfPbZVU8SvT80W5D2fRWRtavGlQ7k
 5huQCyd0
 aYTLL0uEASVK9lpi681vLpDHQew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds loadable kernel module compilation support for the three
DAMON sample modules.  While preserving the existing built-in compilation
option, the change introduces necessary code exports and configuration
updates, enabling these modules to also be built as independent loadable
modules.

Key modifications include exporting required function symbols from
damon/core.c and changing relevant Kconfig options from bool to
tristate.  This allows users to select between "built-in", "module", and
"disabled" configurations.

This enhancement provides greater flexibility for both development and
deployment.  Users can now compile the sample modules as loadable
modules and manage them dynamically at runtime without reconfiguration
or system reboots.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c       | 18 ++++++++++++++++++
 samples/damon/Kconfig | 12 ++++++------
 samples/damon/mtier.c |  3 +++
 samples/damon/prcl.c  |  3 +++
 samples/damon/wsse.c  |  3 +++
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..2e16684e512d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -108,6 +108,7 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	mutex_unlock(&damon_ops_lock);
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_select_ops);
 
 /*
  * Construct a damon_region struct
@@ -133,12 +134,14 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 
 	return region;
 }
+EXPORT_SYMBOL_GPL(damon_new_region);
 
 void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
 	t->nr_regions++;
 }
+EXPORT_SYMBOL_GPL(damon_add_region);
 
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
@@ -276,6 +279,7 @@ struct damos_filter *damos_new_filter(enum damos_filter_type type,
 	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
+EXPORT_SYMBOL_GPL(damos_new_filter);
 
 /**
  * damos_filter_for_ops() - Return if the filter is ops-hndled one.
@@ -303,6 +307,7 @@ void damos_add_filter(struct damos *s, struct damos_filter *f)
 	else
 		list_add_tail(&f->list, &s->core_filters);
 }
+EXPORT_SYMBOL_GPL(damos_add_filter);
 
 static void damos_del_filter(struct damos_filter *f)
 {
@@ -334,11 +339,13 @@ struct damos_quota_goal *damos_new_quota_goal(
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
+EXPORT_SYMBOL_GPL(damos_new_quota_goal);
 
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g)
 {
 	list_add_tail(&g->list, &q->goals);
 }
+EXPORT_SYMBOL_GPL(damos_add_quota_goal);
 
 static void damos_del_quota_goal(struct damos_quota_goal *g)
 {
@@ -409,6 +416,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 
 	return scheme;
 }
+EXPORT_SYMBOL_GPL(damon_new_scheme);
 
 static void damos_set_next_apply_sis(struct damos *s, struct damon_ctx *ctx)
 {
@@ -478,11 +486,13 @@ struct damon_target *damon_new_target(void)
 
 	return t;
 }
+EXPORT_SYMBOL_GPL(damon_new_target);
 
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
 {
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
+EXPORT_SYMBOL_GPL(damon_add_target);
 
 bool damon_targets_empty(struct damon_ctx *ctx)
 {
@@ -553,6 +563,7 @@ struct damon_ctx *damon_new_ctx(void)
 
 	return ctx;
 }
+EXPORT_SYMBOL_GPL(damon_new_ctx);
 
 static void damon_destroy_targets(struct damon_ctx *ctx)
 {
@@ -573,6 +584,7 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 
 	kfree(ctx);
 }
+EXPORT_SYMBOL_GPL(damon_destroy_ctx);
 
 static bool damon_attrs_equals(const struct damon_attrs *attrs1,
 		const struct damon_attrs *attrs2)
@@ -742,6 +754,7 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(damon_set_attrs);
 
 /**
  * damon_set_schemes() - Set data access monitoring based operation schemes.
@@ -763,6 +776,7 @@ void damon_set_schemes(struct damon_ctx *ctx, struct damos **schemes,
 	for (i = 0; i < nr_schemes; i++)
 		damon_add_scheme(ctx, schemes[i]);
 }
+EXPORT_SYMBOL_GPL(damon_set_schemes);
 
 static struct damos_quota_goal *damos_nth_quota_goal(
 		int n, struct damos_quota *q)
@@ -1371,6 +1385,7 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_start);
 
 /*
  * __damon_stop() - Stops monitoring of a given context.
@@ -1414,6 +1429,7 @@ int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_stop);
 
 /**
  * damon_is_running() - Returns if a given DAMON context is running.
@@ -1469,6 +1485,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 		return -ECANCELED;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(damon_call);
 
 /**
  * damos_walk() - Invoke a given functions while DAMOS walk regions.
@@ -2924,6 +2941,7 @@ bool damon_initialized(void)
 {
 	return damon_region_cache != NULL;
 }
+EXPORT_SYMBOL_GPL(damon_initialized);
 
 static int __init damon_init(void)
 {
diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
index cbf96fd8a8bf..87abb8c10926 100644
--- a/samples/damon/Kconfig
+++ b/samples/damon/Kconfig
@@ -3,8 +3,8 @@
 menu "DAMON Samples"
 
 config SAMPLE_DAMON_WSSE
-	bool "DAMON sample module for working set size estimation"
-	depends on DAMON && DAMON_VADDR
+	tristate "DAMON sample module for working set size estimation"
+	depends on DAMON && DAMON_VADDR && m
 	help
 	  This builds DAMON sample module for working set size estimation.
 
@@ -15,8 +15,8 @@ config SAMPLE_DAMON_WSSE
 	  If unsure, say N.
 
 config SAMPLE_DAMON_PRCL
-	bool "DAMON sample module for access-aware proactive reclamation"
-	depends on DAMON && DAMON_VADDR
+	tristate "DAMON sample module for access-aware proactive reclamation"
+	depends on DAMON && DAMON_VADDR && m
 	help
 	  This builds DAMON sample module for access-aware proactive
 	  reclamation.
@@ -28,8 +28,8 @@ config SAMPLE_DAMON_PRCL
 	  If unsure, say N.
 
 config SAMPLE_DAMON_MTIER
-	bool "DAMON sample module for memory tiering"
-	depends on DAMON && DAMON_PADDR
+	tristate "DAMON sample module for memory tiering"
+	depends on DAMON && DAMON_PADDR && m
 	help
 	  Thps builds DAMON sample module for memory tierign.
 
diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d93..3e9efc67a3ea 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -238,3 +238,6 @@ static int __init damon_sample_mtier_init(void)
 }
 
 module_init(damon_sample_mtier_init);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("A DAMON module for memory tiering");
+MODULE_AUTHOR("SeongJae Park <sj@kernel.org>");
diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index b7c50f2656ce..290a3335aa06 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -167,3 +167,6 @@ static int __init damon_sample_prcl_init(void)
 }
 
 module_init(damon_sample_prcl_init);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("A DAMON module for proactive reclamation");
+MODULE_AUTHOR("SeongJae Park <sj@kernel.org>");
diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 799ad4443943..183bcb7b8516 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -147,3 +147,6 @@ static int __init damon_sample_wsse_init(void)
 }
 
 module_init(damon_sample_wsse_init);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("A DAMON module for working set size estimation");
+MODULE_AUTHOR("SeongJae Park <sj@kernel.org>");

base-commit: d358e5254674b70f34c847715ca509e46eb81e6f
-- 
2.43.0


