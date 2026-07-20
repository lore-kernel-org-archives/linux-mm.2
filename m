Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324C9C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546B06B0093; Mon, 20 Jul 2026 15:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3406B0096; Mon, 20 Jul 2026 15:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3945E6B0095; Mon, 20 Jul 2026 15:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0BCD6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 514B21A02A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:49 +0000 (UTC)
X-FDA: 85010157498.06.E2F4FAD
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FD2B180008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ucd2cdLq;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4ZbFLqrZPbRYYHVyM+GUe32g3SELymPp/g2pETaCC4=;
	b=AgBg5WdwGvOhvHkQaAsFeUc//ITmpEFdUbXhTPgAkFAPmHNPcd293lRHgK3gdWVr/fVUJL
	oO4dhID+rGVjUaLe4HpZb9OeItKmPMO7jsKO7iwE8U5e5QWuwOtSVQ41i5h+8/o5cVP7hQ
	M3U1FbHBZFEZYnZKUYbWwrQ7beuiUYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576087;
	b=kdIbFh0DUMH2uxKg+acVKL5li/1MIDt3NBE4prhlZ1NjoPDizGrwadJcTUfXEUg6ArltKI
	gaY3whednTtoOFKCTkPXnInbvRQHodRin16Tt/AcJtG0p1EJ5M2ZCONbYsOs4cF4tX+PNv
	T0/q0fAbSgUjKijfQy8xOjWRQQ6caYM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ucd2cdLq;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e54f8c051so797880285a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576087; x=1785180887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4ZbFLqrZPbRYYHVyM+GUe32g3SELymPp/g2pETaCC4=;
        b=Ucd2cdLq7pBT/fWrklsE3mgsks36pUM++7QMRH4EmqJcqCtvlm/FztqsFcwMEobMhQ
         rIPgBdEsqL/Zz1dSnT4mFosX4Aeam7gIeXRqvISr9dsGhLslc/1UiQvAirMcInBgGNgv
         ObgG0zbzPfJQod6UJxrwe94TwtpcoitHabs2YsLP2SWYztVXTDGHxjNJL2QXM0mAcsrx
         CDSkfX6s0cs/9Wczy0mZTg9k2YwmgBqCExIniR8iX8iJJa4gkX+pS+FrgYOdtaPODf1j
         mj5l9hP99slmHvAk06FDNYI3Fhv4nC/xXOs+r9nxCANmewi7bNqTTbtdnE9NJ3lS6B23
         Ugmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576087; x=1785180887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4ZbFLqrZPbRYYHVyM+GUe32g3SELymPp/g2pETaCC4=;
        b=KdvPHwpexEjeserI/i4FOKuUFM/Lm4lJIINWq0Qlz0CFgB+4mkRrUHZaKfBjBkwdBQ
         YpXUplNfUfzCIeO/+Q0V66M3KniG596XhYIZ7fFsmyDodVdd+BQXWc0erC16NXc++N2I
         4tZfR42sqdqtQPMblPfKMZCdr7ZHEKP7IWXEfdhg2lUObQAh9sR56tg7C2BHjxLTb7Kt
         I4v2GFTxTJgp2Au1CWDsZuzklHnr/VvR61Rsg/5bkq0GtFtA2Ac5sWLT+ynwbfGCytUP
         ug/8yMET/gSLE7a8FwZH0WDMe1cyEaOw93hVzZzbBg2sqFifjXYIQVxH/GYRZiNtgMD/
         pO1g==
X-Gm-Message-State: AOJu0YwB7Z+c8HBS0sHmQET8mbRLORy+eYo1YUTd0ybkHn+JOG5ht1Er
	hpY2SJUCwSZ6xzgc3hUybS3So2gH8+cX/iAXAA9VSnc5htXMxeTzm8hiTgRkvv144GagWTJ6Qm5
	ED5ET
X-Gm-Gg: AfdE7ckauURbojJcDro8m9td9TrH4mQo7k6VwKs8vkxnQlaKzb+qhRGi16yaH4A9UNd
	UpTTIfxPms0ZxVmH5TcNJKDFKwqBs1l4RKrO6ZDKYiuc2iaV1FHQBdHYmHfJWOxN0aI9k0XhRkj
	ENtYl38bmBoUzzFJx3e6bMpM22Tc7dMSJE4U4m47Gko/jCSAK9zHN2GgoIdo1x7kIg+8Xc8u0PK
	Ga+HYFJvKn2blxh7hjLKwfPqdRf9fBtoQ8JD2jpCZHdxTHDASS9i+uMy+SS3TMD5PmmAQ3ZEb84
	9c+AEe5COum9D5YknIE0+v6wFnIK+OTyRshFrw7/sWtpyznOMFkoo5czlpcpsoVxwsV/ZEjrmGm
	pA6G+AfbrYniHrXWQK2q5wb7uMqAzneOdV1gPc/2xnUCzc3rhWPigwT18OdEB+MgABxIN5NYRnL
	XFlIh9qS3I4PNYYwKXaHlpBNZW1DYsdaBHBBOtO4DafbfizYJKZgHeYI9trpqGL/I=
X-Received: by 2002:a05:620a:4713:b0:92b:67e6:4b66 with SMTP id af79cd13be357-930b416d8f5mr1564037585a.61.1784576086371;
        Mon, 20 Jul 2026 12:34:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:45 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 03/36] mm/page_alloc: let the bulk and folio allocators carry alloc_flags
Date: Mon, 20 Jul 2026 15:33:57 -0400
Message-ID: <20260720193431.3841992-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FD2B180008
X-Stat-Signature: 8ciq71tubgnzrbyarrep6hhf3z3btf8d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784576087-370934
X-HE-Meta: U2FsdGVkX1+LuddiG9PTam4/GBXnbV4fHPTlqfZQDhS152FqIk0ypcsS21OMGA7lkn7rDX2Mw05w8rRMJOBg/I/q6I1gmP5LKKS7cjQ9tQARhCxdD1BfOxc8XQyf6SA6yhgCkDckpI81yMag5KYVyfhN8N+nCnBXEZef8tY/73HLpP19PVzl9DnbEFrkrjhrVmAcSWnDc/Zsxkm8Tnvyx7WIxYTVLp2Z9A83FcryMQGltZ+tsa0iJr+Wip2N0zrePNwRn+za+JIUd5lQd/MfHKNPfIJdrIpK0uMAX7ZXLRCQnDgukxmorvqEkCLK4k2LRTHl8nOwcbGvth/PTFV8F2A6dm0PuviZa4LHP0ZSy/SBhYjQbP3nUMsA7Stn3CnAG4VkjtjTwBuMNtKTw4r66ZK4zNLIklq/7uiMOthTeu6GFlUw+UOOHX7o1etFOYbPij6Ac/Q3XQq9TBaARP3V2hTwsbodOZGdzb5XlxhCkmEUs8k/HKcYKOtato3XH4U/nh7JkAFYFU1ML+QgSIds80fF4P2GRubD9tMEs2xkil/nd4oBFcQ60KpbyY9GcJ4EHBbxShzd22aDrq+FcI9vX7i2DPi3U//jQPlS3iqEceN5rWXqowovmZMWYZBLlPaG7do/asXQCV6jbBxH1EF/V/sv489SU5cUb1881D1n41UKbrVRGWEuPCeULI0N1qSMxSIx+EfG+qJqMhBcWnPsVqzCY3L0WZRWaS0RGq1UksiH6wdHzne97D6YZcyld8cLcdLDw37iz0Zqfrs8CJ0cdBooWMWTYZ6LaKrRUL0z3H/mPh55kPTgF4n7csGCCntbCprR+FPOgz2LlNfQtoZ8Ee4ewlwtkSMnKo5wtFT8LV/4F2hkBETed0EJfc736Kx8VlWYLrBmV3n0WgK/P7oeL8qDS6DBwW8K7Y2OGsnux+wBYxN/d1Z8lBsSbgYSd9Jud2X+fTIIc4dD32g8gsw
 QJX9wx1C
 jf+P8ERncQUUDSM8+YMneuXA6SKXboiCU3yNyCLVndWZLaA5QXaPzQXj6kEdTz1emhFfKALqUDf35h5k3Go+Pb8baFfIbFtu9wOQQjGnypHhjOrGMofAw1jpwRFEEVVITxjKHnt6r5Ah4W23FYoG7ECcYxzYZGPaUXthjo/r6NzVDWnrxgvCGScL0glr+onhZj/sakrJUafbr7swLxQgN1BlSGOQb+B+IMyFu4OCRpWDbYcSLeTn+Hje2t6SXZwHPwYNNhEuNVh/G7N4weZFzviGy3JiwaOwVYyngm+iqKj1VlV493OlZIg2kMZttFRbw7ARc/FVswSaEvIzQ4j65L+s+ptyLVt1UcmSQpEt3jPLcTyDb6GdN4OfuBpuTXrBUlD4ZZsk1+ayk9j87g8zl4brhjmnUwWWFvWVotuDbfZ2nDLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
folio entry points do not, so callers cannot select allocator behaviour
(e.g. an alternate zonelist) through them.

Thread alloc_flags through both, matching __alloc_pages_noprof(), and
keep the flag-carrying primitives mm-internal (page_alloc.h) so the
public gfp.h wrappers stay flag-free:

 - add __alloc_pages_bulk_noprof(gfp, alloc_flags, ...) in page_alloc.h
   alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT

 - give __folio_alloc_noprof() an alloc_flags parameter and moves
   __folio_alloc_node_noprof() moves into page_alloc.c
   __folio_alloc_noprof() is no longer exported

No functional change: every caller passes ALLOC_DEFAULT.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp.h | 13 +------------
 mm/khugepaged.c     |  2 +-
 mm/migrate.c        |  2 +-
 mm/page_alloc.c     | 46 ++++++++++++++++++++++++++++++---------------
 mm/page_alloc.h     |  8 ++++++++
 5 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec8..a327e58c313f8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,10 +204,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
-
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
@@ -252,14 +248,7 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-static inline
-struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
-{
-	warn_if_node_offline(nid, gfp);
-
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
-}
-
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid);
 #define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80f..89ce6bcbc376b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1243,7 +1243,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
 	if (!folio) {
 		*foliop = NULL;
 		if (is_pmd_order(order))
diff --git a/mm/migrate.c b/mm/migrate.c
index 60355be9f652c..a8a86141dbb54 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2231,7 +2231,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
 }
 
 #ifdef CONFIG_NUMA_MIGRATION
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4c1ef84c02a3d..aa35bbe5d4c3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5103,8 +5103,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * @page_array were set to %NULL on entry, the slots from 0 to the return value
  * - 1 will be filled.
  */
-unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
-			nodemask_t *nodemask, int nr_pages,
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+			int preferred_nid, nodemask_t *nodemask, int nr_pages,
 			struct page **page_array)
 {
 	struct page *page;
@@ -5112,8 +5112,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	struct alloc_context ac = { .alloc_flags = alloc_flags };
+	unsigned int fastpath_alloc_flags = alloc_flags | ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5153,7 +5153,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &fastpath_alloc_flags))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5161,7 +5161,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() && (fastpath_alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
 		}
@@ -5171,16 +5171,17 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, fastpath_alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
+		mark = wmark_pages(zone, fastpath_alloc_flags & ALLOC_WMARK_MASK) +
+		       nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				fastpath_alloc_flags, gfp)) {
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, fastpath_alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -5212,7 +5213,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, fastpath_alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
@@ -5238,11 +5239,19 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, alloc_flags);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
 }
+
+unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct page **page_array)
+{
+	return __alloc_pages_bulk_noprof(gfp, ALLOC_DEFAULT, preferred_nid,
+					 nodemask, nr_pages, page_array);
+}
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
 /*
@@ -5433,13 +5442,20 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+		nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask, ALLOC_DEFAULT);
+					preferred_nid, nodemask, alloc_flags);
 	return page_rmappable_folio(page);
 }
-EXPORT_SYMBOL(__folio_alloc_noprof);
+
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
+{
+	warn_if_node_offline(nid, gfp);
+
+	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
+}
+EXPORT_SYMBOL(__folio_alloc_node_noprof);
 
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59d..23fc79ce97b60 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -258,6 +258,14 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask, unsigned int alloc_flags);
+#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
+
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+		int preferred_nid, nodemask_t *nodemask, int nr_pages,
+		struct page **page_array);
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
-- 
2.53.0-Meta


