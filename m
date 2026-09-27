Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8B5C9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424CB6B008C; Sat, 26 Sep 2026 22:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5056B0092; Sat, 26 Sep 2026 22:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311C36B0093; Sat, 26 Sep 2026 22:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09E796B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 735494036E
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:04 +0000 (UTC)
X-FDA: 85258025328.20.3A1C084
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07B88120004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MOKWuGrX;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAkta7mZeKcSnQKAIidETfQVRbQyIgGdyROsCEAgaZU=;
	b=w4ZHYesPmC3DwpUyv0+NMfFVihTrhplJQH+QTeDWAcQpeKmqIiCehomXrKTxDKuzYJqWSz
	6mliHAgi0PKEWDW1faPluOOBD9KBfORUk/kuMd7r3s9gB7MnDQvXWz+9w+eXg0EQs4mrLu
	UjHbEoKVk2zu1xm3e4JkIGUUySjUldo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MOKWuGrX;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477702;
	b=6b1ir6KPHgUmsOcRFPPrgHfEZllfZVGaz4utwR4sQiBWlDoPcI81Pu5d/sX93ovGYrr73+
	8UdSAHyx0nPxPgv2CWkrI1UW+7pxff0JC6IIJzrbeObsLEMU6ATxEJ4jRdKPpw71uqiphG
	OiptCNt3DEHt6V3D30n6Wl/Aw+6LUxA=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39d654f02baso850274a91.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477701; x=1791082501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mAkta7mZeKcSnQKAIidETfQVRbQyIgGdyROsCEAgaZU=;
        b=MOKWuGrXIGrLbyUL0LhzevgxZVWBzJTg8vooaV+ZqYiUfATNqCzrwQA7dCjEi8CY3Q
         C09Df2WMO+RtiiasMparheTcEebJ4L9eI3MSZtYNlaGCZIFAQ/ok7XQf//lZbhKc6dgg
         v36Er0w4rSwTNuLfOX3a2L9yKOt01vdQMfRZRjtNWFMsTva3xmlZkAg61KrdsXqaNuuR
         G84DXZVU9jQtcyxwueUdGRb4pZJOpiF4CKPvvrJIxeliIJ+PdSjcHYGtVddUYXJHDrp6
         scT0HhmIlnMGBkm1qSe2rgvMeDJ1bu3yl5dQ9pOjhpLnGRclvjtaAWRbEObqZAql/lzm
         92mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477701; x=1791082501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mAkta7mZeKcSnQKAIidETfQVRbQyIgGdyROsCEAgaZU=;
        b=brVbpDk/BivPfVnhBVptoL3PReBgZRL/ICKbsWQofyX2/24ZC6iTkOtLeFbglKrsBd
         Q2lRMSk5g1LvmuEslhey5dJqdQJ+9/44jet+XvYJ5AYG+/jNzkvP7ejkV0NwqoJ/3vq5
         o+TxJUdJr3tUW0y4y0hSJx63nTOv+i03cr4FV+vium2JiyvOEowvz2la+BrmgM3j1ByA
         EyJhlKFmDvpsJ0E+4e8fYulOndBxAxylOHZQwWPE0EaJl8WHt0S9rLSlYFYMQZOW4uCL
         GoIHVFq2yA+kX4MI2FviufYvU7/mPfRASresNKm5NQNc8vtjJ2QLeNVmm0rFmlQC4BeD
         7Ogw==
X-Gm-Message-State: AFq9FYJrLVog5tgPdw7OCujgwYb53aRCPRo/ATH4j54bsYxs9TskKqXd
	DUsJkPwaV9UxLIy+9RcgiO6T1W0f2O+EHJKa2saCDhZkjwQAd6DBHB2NLBIdGQ8fPXs=
X-Gm-Gg: AYBFou28zTFKFinSXVQPwnVPqiCubzb2IMb16+augAWRwnVsEF5nY9fWjSB0olhQz3j
	m1n5SFg1/go9TA1FddCQQX2XKDxUnMCYUVAeIZcqOslWvSEzlYqCfo3C+r/jeMfuz8dKF0dFxnp
	LfrgyQJc7WTK/SAPXjISI/ZCkI7+30/x/cOJ8dOaXmTpMARGsalzRi1pGS1hLzStchRBcgz2jHl
	EH9tXlQYX70do0g+oLEeHVeEPMdlzsaLvVLMvQ4jzSMTrWAHvTYUw+4eWiTF/W7oqrH/i9BxrzG
	gBjGxJ/o3prrGEiKgrX42vbG6YoTSLBY3vihKz2O8aO0zEIuT+mKbYebVc9T8D/WXSrFySKdeaP
	Tmw5zeBDBw5/YGuZqzHSQaPjOkeKNuPDHXKtVOFJ+9HRYikdj/6zTBkNqi6/DOuu9LqHLCHgkTv
	vbuyO0PP1xoQKEkax9W6WGOENCjDZFI7uV/2QW+UKDnqAx8cWNKR4LXWC/rKtPjbLbgsdNCqmUW
	kBehSg9F+m8Im6EIm/m
X-Received: by 2002:a17:90b:17c8:b0:39e:433:23b5 with SMTP id 98e67ed59e1d1-3a098b973c5mr8380169a91.5.1790477700749;
        Sat, 26 Sep 2026 19:55:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 02/12] mm/sparse-vmemmap: allocate shared tail page array dynamically
Date: Sun, 27 Sep 2026 10:54:31 +0800
Message-ID: <20260927025441.741633-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07B88120004
X-Stat-Signature: wmq6agn98a65kwm8eqxb9rg5qhwtuyn5
X-Rspam-User: 
X-HE-Tag: 1790477701-832686
X-HE-Meta: U2FsdGVkX1+kpM5G6yVdM6vqWNw9aW2ncqQo2XEmnIH0Nw5TZaHYhK4gZXXyPQPlqIjWn5EYcXn8bdRjtbWg4QV3j5gGUja+hHXQEcFQEPxfn8EshZvBKkop0Mc7vvbbhHsKv4vmMtMXoD+MYGT9yPh2Xm/LLZ++jqZEJQSpxFbxlbS4cM8uAXYMON9yJIkuqLGUvwRJYbNDadC//7FdRzG904EusiprTtiuBBxvp8uNT2/cCLon5BHypqkBNW/E/z48Ch4b24a8Jg/FjdGjJ2rcsn5LgafyeN2jOtB8ZuHKnM3VhYN4IWoVGgJpJhmfPX30pptRFBZIijH+oIDZJrzv5/msqHHt5+DFpOv1jCbTQj2IN787itpZwyF+d9+vIuS530M+OxuFj34t9Ra1ggnxBQEASbVr1Pe6gYd05tUUosqFKE7KlGNeKb1teMx+Oo/NglQEmpK0lz4chiEjpcEvKTsM7FXc70fEEZi4a6bUmygeJhIsC4YKLBBRwU+nwanlRMu+A5kDafbJS3xprDflao2FjclexWuQi2488yjzaC+o76i0AORzebCfdV3pZ75JiG9VeN5UVYoC4aNqpvWsCX22sqENGeflVkGSrqzFs+LoHeVEtotRYWt6rfrRgJ0PkOcdV0fv9Cqvv2hGoBEVJApyF7lTJ0YBUSKfHqKJRzasGKrxnsBdha/hh2e0eFN7p2PrFvhF4bxbfWarTuxsvOPG1HC+kRNN+8K1W3CehZv//8DtgcfumJv/10N+jKynUt+1m2OFXJfv5p9BPFErMQY924oYnzzz9TZKLvh9RAyTYuhdhQQJi5NAkNWNt+OHTyZ0PFJ+K9LfgAPsUvk/9h0gRtO2WF3dkW3zJmedWZ4+mrYTr+29OM/P6C+gNQDnO2RTaoAn28NsPL+q260ghrUaxWqKCsZAenqTs+TFTktz40+exVNAgWsV+l5Nhw1VTWnZdLfdvvUuP6d
 JUUlGCb6
 4iHYv4wA9Yw1wGYY6IDxmQgRKLYJQYUJwjK0h62McuB8gPu1TJwfWvb4lZ/I8QV3JoUPzktgyPR110b4Rhe/w4ZyRzbmD3HahXd1x839UmtiI0CEl0CLqcEZFMRLCSDWwkSD1oVWXiuCdHKPsraSMwF9M/4hnXUj0Ju4YaCYpRSwmLFxzO2NRU00+EDwrPwnu/Bkq/z9mE0vwhxov7wSS2P4mKskoy4wjW5W/ZL+Xfm49FEsGqIpoRHk3wg+9cqCHqxDnmrIwiEmvB5EeU/wiQo58ysbJGS/95f2dHMca8qb8EO6J4vI8pGuXUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") added the
per-zone vmemmap_tails array. Its size depends on MAX_FOLIO_ORDER, which
had been moved to mmzone.h in preparation for the array.

PUD_ORDER is defined by linux/pgtable.h, which cannot be included from
mmzone.h without creating an include cycle. It was therefore open-coded
as PUD_SHIFT - PAGE_SHIFT.

This removed the dependency on PUD_ORDER, but not the underlying
dependency on architecture page-table definitions. PUD_SHIFT is
generally provided by architecture page-table headers, which are not
guaranteed to have been included when mmzone.h is parsed.

The dependency remained hidden because vmemmap_tails was originally
guarded by CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP. Under that condition,
MAX_FOLIO_ORDER resolves to either MAX_PAGE_ORDER or the fixed HugeTLB
limit, rather than the PUD_SHIFT-based definition.

Device DAX, however, does not require CONFIG_HUGETLB_PAGE. When it is
converted to use section-based vmemmap optimization, MAX_FOLIO_ORDER can
resolve to PUD_SHIFT - PAGE_SHIFT while it is being used to size
vmemmap_tails. This would make struct zone depend on architecture
page-table definitions being available when mmzone.h is parsed.

Replace the embedded array with a pointer and allocate it on first use.
This moves the order-count evaluation into sparse-vmemmap.c, after the
architecture page-table definitions are available, and removes the
dependency from mmzone.h.

Removing the compile-time array also removes the original reason for
keeping MAX_FOLIO_ORDER and the vmemmap optimization sizing definitions
in mmzone.h. Follow-up cleanups can place each definition in the header
owned by its respective subsystem.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v5:
- Add this patch to fix the RISC-V build failure under the configuration
  reported by the kernel test robot
---
 include/linux/mmzone.h |  7 +------
 mm/sparse-vmemmap.c    | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acd94cecc0d3..68807ff7f946 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -113,11 +113,6 @@
 	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
-#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
-	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
-#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -1156,7 +1151,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
+	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9b00085122b2..46d9a25b3275 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -170,16 +170,43 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+
+static __ref struct page **vmemmap_tails_alloc(struct zone *zone)
+{
+	struct page **pages;
+	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS, sizeof(*pages));
+
+	pages = slab_is_available() ? kzalloc_objs(*pages, VMEMMAP_OPTIMIZATION_NR_ORDERS) :
+		memblock_alloc(size, __alignof__(*pages));
+	if (!pages)
+		return NULL;
+
+	if (cmpxchg(&zone->vmemmap_tails, NULL, pages) != NULL) {
+		if (slab_is_available())
+			kfree(pages);
+		else
+			memblock_free(pages, size);
+		pages = READ_ONCE(zone->vmemmap_tails);
+	}
+
+	return pages;
+}
+
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	void *addr;
-	struct page *page;
+	struct page *page, **pages;
 	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 
 	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
 		return NULL;
 
-	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	pages = READ_ONCE(zone->vmemmap_tails) ? : vmemmap_tails_alloc(zone);
+	if (!pages)
+		return NULL;
+
+	page = READ_ONCE(pages[idx]);
 	if (likely(page))
 		return page;
 
@@ -194,12 +221,12 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	}
 
 	page = virt_to_page(addr);
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+	if (cmpxchg(&pages[idx], NULL, page) != NULL) {
 		if (slab_is_available())
 			__free_page(page);
 		else
 			memblock_free(addr, PAGE_SIZE);
-		page = READ_ONCE(zone->vmemmap_tails[idx]);
+		page = READ_ONCE(pages[idx]);
 	}
 
 	return page;
-- 
2.54.0


