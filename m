Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE298C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51F16B012E; Mon, 17 Aug 2026 22:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27876B012D; Mon, 17 Aug 2026 22:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D656B012E; Mon, 17 Aug 2026 22:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A61456B012C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:34:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E547A0A3B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:50 +0000 (UTC)
X-FDA: 85112822340.03.0B85B86
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id D21E640008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5AYsA+w3DDPdWAR7DwuVg9BVzNd+4WYpcT4XqwjjP4s=;
	b=uZye5oakQKAZKOfnkmeIwAJujKTa/v55upAMRZ/eYuSNdRrIBflXwjtleav0nQ55Hqledb
	ho5Lff94wO1sYVYB0ZmotXehfTOOsS73ZYBMknJ05brd96f+TZaA5GIwdOtJI2KtfunzZY
	yfU/DAT61w+D3C2ZjctCuYz13ZFSU+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020488;
	b=sKrxob7Lxu1+TiaGetdSE+Clfk68IaULrujFAaaWsn3+IpdCKEBXYvOwTpHZiH9vXd+rVY
	c4mmWUWS9mTFCVHQkVP3H99S5pWbPYgO3Zb4W6jpWOTG226XKRC5mOHMjItnCQhbwgB2x3
	mAXcWKS4OSbvWPWqk2TguI8qa4z6gko=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: 599707d69aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3fff914a-1cc0-4a8a-a1b3-abb84a3bdc0a,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.19,REQID:3fff914a-1cc0-4a8a-a1b3-abb84a3bdc0a,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:7db8b62,CLOUDID:2037933290f126fd66af66823effcce8,BulkI
	D:260818103439T0MG27UH,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 599707d69aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 204743495; Tue, 18 Aug 2026 10:34:34 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
Date: Tue, 18 Aug 2026 10:31:15 +0800
Message-Id: <20260818023121.100613-3-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1to6gwh3w9jrca74qdomzxa7ezhxs37b
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D21E640008
X-HE-Tag: 1787020486-259142
X-HE-Meta: U2FsdGVkX1+Y2UNdB1QZp2YXtYMHMiqgHzDbyqHfacm5+TtU/lAu6l0o3icvG9B1oRq27iQjZGQGMVGlEal73QYD1I2dTjtTtQA7MTN+INDfiAz5MMAdHvWDUYzGumurOA0PPSTJ8Ghn8yoHA/qNxO7uVFR4a3YdecFHUONoEcjt3hqyaw2K6UEJE6NSmbAQrB5ffmR9FuGQWCSmM9oooTg7Xs91pJ9TWkhH0aoonSa/MWV9QwiWiTQeFrtgxbItl7T2xCOcXcVgZdlbRoR9RNUfvlMH8K2e9jTpsx31jL9pp/xSTHEuJG2oQ7V3d08KxfNPv88boEi6shfpC8TVSF0fPJ7wnVkPrY/j0Eoyw5t26YEk0VfMgkp2MRZNJWVR5jae8ko8Q1qHd/+pVpBA1VBwP9jAxnTo5RnlV+8g988qEKjc8+kO9GfRNknIYJTFFkUtqNK22UyqY1GVhK3w1jqMXs5LW1i35+GkfzhzUsMyKcPsg1KpjZYmrW6MhcKDJWqkqNF5sj9d4Ry85Kuiqqt/hph23M8R1i2jq3FXSqXidombRFqJHhiM/E1Yve947Yt6d2gRPBrQZD6UgzI+QFXAebSEykVioMDbK4SSv592HiEmgUi1vor5gjSp5cDBeGfsxJ0e6AVKwlA02CsVLKhEqldbpDBl7wQIMZfNSy17xJ1TPVms94PgOov074FMYpM/o2S35jF8KIDo1eRK9SiDlrI/DwB+1XPzRiHmf1IaIeVrhLvksQHSAEZCWHeeTBAfqUCBuIj6gntoANaUPlEX3xHpCUMpHQolqkCN8kI1N+z8K0+KYB7WSo77jfnVfvh8OaL1zAZdt/DkOEbNom2Lwb/JR9Mn1sXGke82bWbw1klE6A2xdx3uQBw023nResDir0elBPIkN8flhcaE6ErM7yn/jDMh0t63/8bO/zYBDYyALxwuaBYG3APgtQ5Pb6AbYJR+9mfU5eUgBh1
 74WFzYI1
 hPpF/JDjwlfv8pxEUXSFr5KUs1UqSyDFDd2OiJ44sHQ2a6LdQGwby6zo0dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

try_to_free_mem_cgroup_pages() reclaims from all nodes of a cgroup.
Refactor it to call a new helper,
try_to_free_mem_cgroup_pages_nodemask(), which constrains scanning to a
caller-supplied nodemask. The existing API is preserved as a wrapper
passing NULL, leaving all current callers unchanged.

The reclaim core already honours sc->nodemask for cgroup reclaim via
shrink_zones(), so this change integrates cleanly.

This is needed for per-tier memory control: reclaim must be scoped to
the nodes of the over-limit tier so that enforcing one tier's limit
does not evict pages from unrelated tiers. The new helper will be used
to enforce both tier.high and tier.max.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/swap.h |  6 ++++++
 mm/vmscan.c          | 26 ++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..6a79d6995082 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -367,6 +367,12 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  gfp_t gfp_mask,
 						  unsigned int reclaim_options,
 						  int *swappiness);
+extern unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
+					      unsigned long nr_pages,
+					      gfp_t gfp_mask,
+					      unsigned int reclaim_options,
+					      int *swappiness,
+					      nodemask_t *nodemask);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..e0602e681d96 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6759,11 +6759,12 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	return sc.nr_reclaimed;
 }
 
-unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6779,6 +6780,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6799,6 +6801,16 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 
 	return nr_reclaimed;
 }
+
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					   unsigned long nr_pages,
+					   gfp_t gfp_mask,
+					   unsigned int reclaim_options,
+					   int *swappiness)
+{
+	return try_to_free_mem_cgroup_pages_nodemask(memcg, nr_pages, gfp_mask,
+						      reclaim_options, swappiness, NULL);
+}
 #else
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
@@ -6808,6 +6820,16 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 {
 	return 0;
 }
+
+unsigned long try_to_free_mem_cgroup_pages_nodemask(struct mem_cgroup *memcg,
+					      unsigned long nr_pages,
+					      gfp_t gfp_mask,
+					      unsigned int reclaim_options,
+					      int *swappiness,
+					      nodemask_t *nodemask)
+{
+	return 0;
+}
 #endif
 
 static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
-- 
2.43.0


