Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6788AC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2D96B009D; Wed,  9 Sep 2026 06:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553CC6B009E; Wed,  9 Sep 2026 06:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442016B00A1; Wed,  9 Sep 2026 06:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD426B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:08:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69AA48017E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:08:34 +0000 (UTC)
X-FDA: 85193799348.30.8070B4B
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9826A1C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:08:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QFBoGQCW;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZP7Izy7OCFS/wAqshdE6rdYOBHqDiQ7cVSskEfKxxg=;
	b=VxTkhJRyzLroUfEfWbRBrXtY3swp+WhgCMHxTMn9cZ/7F2yV/911lZbvbYJMblBfmypB6B
	lGUAcbNtHudD5KepRS8r5neiMtEIKHfy0LJCW/7PS8OKBLyYPiYQuFb/GZNINazywfdkIS
	LBmnc3kyHndzO/PvT979dh9tqzWWjO0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QFBoGQCW;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948512;
	b=Sd74nXMWOYmvsSycOzKsv/VABIUAGeg+pFdFRg1VxuVZWtFx6g8kKRHy/NrSerhPKi41d3
	N5HOLgms4yWEQ9v8VPOgKLG2HJlWtCuOSyxjtaigpOQFFH+UtKn2MZj4rCMzActUtzcWLF
	fp06xTBBA7WY9WLJn5KJsCKw1GliAnw=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-836c8bde2dcso37479397b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948512; x=1789553312; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZP7Izy7OCFS/wAqshdE6rdYOBHqDiQ7cVSskEfKxxg=;
        b=QFBoGQCWfcTnTmDN2O5Etzvn8jvydOSP+vfP6xrc02/2vnkskV7KSrEXqXFXODDpoX
         /ver5ZKF5pdE5tOnTymmsbtyp4i2PJvsTVYYWk8Ekm8Cy/9QBzc2JY7vPfp2SBmCB5Ly
         72MAKIHs+QHVZ0OA+nU+oLGR6E2UsdyxUfYaHR5DG10iaoCCtPBXSjBlkBUsnT5VS4Fc
         v8beuJq87lKGu3tTgJPq1LhmnBUJJYPzxyRtRihZF8fAkaiFprQ30DYtFkV7ZYP+Xrl3
         Yl8wMam2YgdD+lljyQZg3miia5tdQF+MtFOYVBfxp0XIgm4WplIwG1QQ6IX9QSWKAP+j
         iqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948512; x=1789553312;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XZP7Izy7OCFS/wAqshdE6rdYOBHqDiQ7cVSskEfKxxg=;
        b=jVFtvrM4um9JOY0ntlgEjkmnRRGqfpZeXMAAADcyZS/1u1w0088YTHLpnjen4U3cTz
         cyvd7CTN/a8fbgUhbf7Fu5F3lhTFtiYecT+Mdcn3gIEfyArAjeFJwCgD06COcodSXRf0
         v+7W1XkAdrb1gmk+LUV4NYPkKeE8DoImTspKlxx+9AzaYgENSKNc/7HxvJ3+nPDJlw2q
         Nlzeqshf/BKz21kDgODLiC8EX341R92WwYnlw4TxPCJLcd3zsLuvN3Gnw/5qBuXJBmHq
         O5xjK/3/jfVaWHa+rwze/567bUpespnHpv7O5XDXrsHMzTTPAFWD0D4sp4z5SJKeQNN0
         Hsmw==
X-Forwarded-Encrypted: i=1; AKwUvByg/uIaQ1HGU9Zjl3k1PJYV34KUcE+zWMm19fnXpwrTlY5tnp4to6Z9zC5vQptH9qd4qZpNRubRZA==@kvack.org
X-Gm-Message-State: AFuF++lHtEcRA9nevyXEMPdYZKkY4YthDDmqtO6nb4VSyjgLK8BDknUi
	NqVWgQ800itAkhIc3IQ2RNALO2BFHKR8zuC5kMU4JUPqiLg8qOpsMzlCKjz/kg3O1g==
X-Gm-Gg: AYBFou2b8DKxvTFZDfWbGwU1zcjLFQzTaEmgWJHkvK7NhorFSgLYrkcKg2jMFcZeaRf
	3wF+3zTXH1RVF2VOFMtbhR+l3TWKMJcE7Ex8M3oP/LtxvAbTdclyD5lC0FZYBiuM/KhN/GVG1xP
	gPp3EylxbtCDl+ZPU4+/E6XSSMwDck2xQt9iTjrvlncOoEsJIa4Sb/zXk4DlKvB/rbwZWGlMURg
	o4mu6JkRR7CZmQuF+X+t46XWtt/5azu26yfJ1bZmQhgHK/125j0BB2Qy3UISRO+D9aLBh9f0Em6
	bM6L/5rTLODOrgeISKfRUEACq4PY8cGHOT87AVgPFQMZQdeE8bqCR+MzXKb2l7HcXiZzsWUbpzi
	AyURhuRATIXW0Q6M5DW/qfaIpp+DEytLA6YNniUhosdcTHcpA0lTp6QGZapNv6HLjQW5YusPxoA
	22oUGwXtRw03raG1aIkCRoqikCmrt+sy08Em1C4oC9IelxoSQ3ytpQC+Zo8xNVMYZdfUIlBNz64
	zu6m1/IkQCrORK2FaSwbJGBnNtE59g0XncugcjzECqxxrwdItEsUvWWCxw=
X-Received: by 2002:a05:690e:12c8:b0:66f:bdef:7d95 with SMTP id 956f58d0204a3-66fbdef8a7bmr8856733d50.20.1788948510918;
        Wed, 09 Sep 2026 03:08:30 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb47a8b8fsm12160676d50.2.2026.09.09.03.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:08:29 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:08:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 13/26] mm/fbatch: no lru_add_drain to
 collect_longterm_unpinnable_folios()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <716d267e-11ea-f400-2cfe-d8775e6ac027@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9826A1C0007
X-Stat-Signature: gty5fuyhk7j3wuojmhog7ag16fzd8h4e
X-Rspam-User: 
X-HE-Tag: 1788948512-100004
X-HE-Meta: U2FsdGVkX1/1zp/ztYYwL2yP2es6J3UNsd8ScSUp811JL9eP3e4rRcQwZrZJ9ttjo7dhg3oAC1pE8WArPJXHtphgNmzesSvZBfQJeKUCBmvC9IEP8uRXdHyxJxJHjETLYZkC07M3AUQ/y4OltwcoO1K3dVy3XN0DxZtttum6TVS0uxTgzBf/zMPYZQ4HFORuHeu6xT4p3MJ3dPfH4OV6R9N/HjR2GxGpyxM3MzQHj7YAEVe30vDEj/+QR73QVZV78/9ZqcQFnZwCi1gwqC0QsySmj3Zg9qujpjX06lK44JQoglvi8NdL+aCnY2jR6Zzerfnj/cdYcNqKrOgv1jU3uAtF19odJoqiOFx/LnkGJMcEzuflt8njPohKUqZ6UCxyIulwc4pspo2RbMSLZH8jjmzb83sBMTMOq7lcVP/2ECCvuDNzPnkN8UsmmzE9QLF2E0d+azyWEb3aGwSnzs91B/tnYQg9YefoewYi9Oi8Bzx06JAvfepj3AgW2LMnKS9Ib8yk28P02zuJCjt3jRS4pmkqw+RYbbXw7AMFV3Bv3gDBbM3/zKQ5K8ogl04mwp58ul66bsKRx5GM/l47pbk0STMWqHwZ3nQXSLNy5RBLXRoAATBaN0Uzerop3enfYqP23gIlfU1eOOPx1eefUFmioowX4dIFOwaM6KJPVsVCqxBsugqJpirQa2f5IoyK3283xG2XkhIT06HY22QhXI3HQL8pr4vvWw+/7uwuVrjxhxl49GMV1joo6ZO3hrAFuysASKslTdm+S1rKTdlmn1rL4hQEa+0ulS1OTjx1eNoXwzFEAah6HkgUlHoeFP3ZsLiWeeWGMfG2EUL70bUmFPg4gX+Qr2T8BW3hcbwZD/zeh3FbG8C6znmhDQg27OLc5NwzZs3yiGxL+FyIQpWj7y6RpRwZNFxdx5YxvVXf+GCDOUpxubkYban0cXeK7A/O30P3+a/Xl/zoOhN7FGzqAVa
 NtVYhWRQ
 i0Gkfi6UMWq1IXM/UxYOE+em5adl6RxVrUXC17UThaW7UaiTtsvFHCJ3i9GA3/tNGcBoa0Sx4I/1neMFPRjj0ru6CC00mhaOcZnT8hTdN3EiPMYa/AzMPjeU05bJsgpQtWfOOX7lj5t/2P4C224IfPcPtKMpn7zeJwVwOwFkENmLMUth8LqQp4IW27KbJClOvLX+igni8Hpkz6adFijw8vVhEWDMNoxfBQAEojUhz/eZodsDJH0Z/pZwnZ2kFtqKHqbXgUDy/hxkP+5nvzUdunE6C8Wc1ERKWuR8YhO7bv9kwyV1y3jr2Dq29yQLJfOGJ+mrwQl0ZsonAtuqKH6r/tE9H1HwARKlEyVPjlgmyVyhrlxODCVUzh56/MqFbVNpJFd8UKaPvRLfe0oMVhosJ7mlkmY8VMJcMRh2N7/JnmMKTiWkXhqjKynPzj5AdXKZDGAgcUzAif1hKCRDC0rbWaaVln+4h/HYzVij6UqJwlN3FTaEgzWIPjGiPT2g4u2jSQEOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
lru_add_drain_all(), now that the per-cpu fbatch references are gone.

Replace the recently added lru_cache_drain_for_folio() by a temporary
stub, so any callers outside mm may build independently of this series.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/swap.h |  9 +++++----
 mm/folio.c           | 48 --------------------------------------------
 mm/gup.c             |  9 ---------
 3 files changed, 5 insertions(+), 61 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a6fad5127118..0052a6890435 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -304,11 +304,12 @@ void lru_add_drain_all(void);
 
 enum lru_cache_drained {
 	LRU_CACHE_NOT_DRAINED,
-	LRU_CACHE_DRAINED,
-	LRU_CACHE_DRAINED_ALL,
 };
-void lru_cache_drain_for_folio(const struct folio *folio,
-		unsigned int extra_refs, enum lru_cache_drained *drained);
+static inline void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	/* Temporary stub for callers' build independent of mm/fbatch series */
+}
 
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
diff --git a/mm/folio.c b/mm/folio.c
index 5021639c5494..d66aa2469e86 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -33,7 +33,6 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
-#include <linux/kvm_types.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -843,53 +842,6 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
-/**
- * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
- *				 folio references
- * @folio: The folio.
- * @extra_refs: Extra folio references held by the caller.
- * @drained: Drain status for batch folio processing.
- *
- * Drain LRU caches if the caches might hold folio references. Start
- * with a local LRU cache drain, to then drain LRU caches on all CPUs if
- * local draining was insufficient.
- *
- * This function detects LRU cache references by comparing the folio refcount
- * with the sum of the expected folio refcount + extra references held by the
- * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
- * cache references, and there are rare scenarios (concurrent folio (un)mapping)
- * where this function might miss detecting LRU cache references.
- *
- * If @drained is not NULL, the function will avoid re-draining LRU caches
- * when processing multiple folios in a row. In that case, the variable
- * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
- * the first invocation by the caller.
- */
-void lru_cache_drain_for_folio(const struct folio *folio,
-		unsigned int extra_refs, enum lru_cache_drained *drained)
-{
-	if (!folio_may_be_lru_cached(folio))
-		return;
-
-	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
-		if (folio_ref_count(folio) ==
-		    folio_expected_ref_count(folio) + extra_refs)
-			return;
-		lru_add_drain();
-		if (drained)
-			*drained = LRU_CACHE_DRAINED;
-	}
-	if (!drained || *drained == LRU_CACHE_DRAINED) {
-		if (folio_ref_count(folio) ==
-		    folio_expected_ref_count(folio) + extra_refs)
-			return;
-		lru_add_drain_all();
-		if (drained)
-			*drained = LRU_CACHE_DRAINED_ALL;
-	}
-}
-EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
-
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*
diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22..fa17f99cbb60 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,14 +2266,12 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
-		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2288,13 +2286,6 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		/*
-		 * We drain not only to make the folio_isolate_lru() succeed,
-		 * but also to remove any other folio references from LRU
-		 * caches.
-		 */
-		lru_cache_drain_for_folio(folio, pin_refs, &drained);
-
 		if (!folio_isolate_lru(folio))
 			continue;
 
-- 
2.51.0


