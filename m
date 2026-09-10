Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD333C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE2D6B00B2; Thu, 10 Sep 2026 02:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57906B00B3; Thu, 10 Sep 2026 02:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F216B00B4; Thu, 10 Sep 2026 02:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 869D66B00B2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3D8CC041E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:29 +0000 (UTC)
X-FDA: 85196888658.18.62BCC9B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5C5CA0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jEDnDvKy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jEDnDvKy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022067;
	b=Okh3S5ST9hDEx6GYNMeyTydu1jYafnkgH09JP327itdplg0PT3pCnrGliSWGQls3jPHzwz
	Br05YtlroePsXOm04V+Pn2dyh1CiVjxR/yUmXufkn9p9taoY6ix4SihLWSCYDZ5+CDNHCw
	ODbLLxhjDCTh/CQAFoz/Piba/tXyVnQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jQmh4S0MKyAUesk/qTiiCNB9x5yb6aCEsrSfgP9kbM=;
	b=Cif5z74XNozK8qDN1n6Vd9GX/ORh6bdmvbuOjDjx1+k5g5DPBEeEPC1TCvrRJvvntQUzWw
	sI+ytCdtTV5K94H5fGHOor8CKlXlw7qE3Bv5dPdVWEIiFkrWvpJsL9Cef/zeFHEbWW7iYI
	HCQgcIHmdCeWkGOGeNSiwJDOl3bfNDs=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d6f9e2f681so76428315ad.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022067; x=1789626867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/jQmh4S0MKyAUesk/qTiiCNB9x5yb6aCEsrSfgP9kbM=;
        b=jEDnDvKyETEBWG678kD9sZy/+kDVRUfl7ofYnmbF4qnt1G+BCKpc+db8kCA3F+vgfi
         fCcDMk4Q+c0TH4Nd5WdCs5RWTDYMKOGhj99yKgapTr6TqAo+SsZUcSuFew0vPIxqxhlq
         GsdMvRlJ1Ac3XC2QNMv/PMO9tRL2p2xFjcfSVE+meboeX567E3VuVMxaXrGCqru57aLT
         Kg/ZEz/pXTMN2I+au3X342HMNVujaOydGS9N2+5olGAYDHqgW9kSljkCkWkgNcmOXkzb
         Jf2TUZUY3Vq4vwlWBzjAI3sX8Rz8OYSd1HQ/0j73IfjRn/3FDbcky4CsN3GlfvGKSeWM
         P/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022067; x=1789626867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/jQmh4S0MKyAUesk/qTiiCNB9x5yb6aCEsrSfgP9kbM=;
        b=ry8NaMn3RxsDdOpwYoAl9RY5H0H8l6en52RnFDdvUNsoDqnANsysilxs2CKawDuR6w
         Gtp5ZuYIm0x0Zt7gXFoGgIRRIs/EFbEMDTKz/9H+gc22uKJvR7g96h6nhuU5Zm9YkB2e
         68YilRou7PwB/eaAdh15cfKsA/7jGIgaBxR5bhU2QCaCvDnrRXNZX2fl6yhW6TC4nFQ4
         7BkIvN7ScaMmxc2DcooWRx5vod6UDg/6WRjBJiL/bwCksYJI/7uz8zGNE9E5CpNWzq50
         QdMpQEkY5co9Dsb/haWSiDDCyWKQ+3/8vWOLlCov55NCbcnnL5R0kBPdYYTi+7KQSydx
         hiCA==
X-Forwarded-Encrypted: i=1; AKwUvBwLW3YQp6SyKW3KkHVIcg8CVeJzK4ihUIxxuceQLFBhbanIxzDhKjVlBMoiwgqdWNdxGv4Av/6o7g==@kvack.org
X-Gm-Message-State: AFuF++lJp9vFnmS6tTnxmIZoqIklPsVFN69cpnVRYWSZ5AWnmT3ydmGK
	T+fTWtQxrtQfM83DRcKUzXp2WFxZfc+iYW6xUUAnyO+SNDcm8GL4QpI1ITNZWQjFd24=
X-Gm-Gg: AYBFou2L7JVnIR6ManAWcRWN8e5TSQOfx+dK+EHThi+reIQkcq0POCehYypz7QnFwIV
	JPWiBYbgSaVqknbJ5DLlwAI39X94o1jC5CjoM7sP7pH6IMVZBXCSFeY+ynP31ZSmebdkRQPQRAr
	H0LI5wzDq5S3EERSoE3DzS8MZhUCEgXyTPPuh6iwmiviVEE2Ulxy4QfS+sbcT3eZs1+970anQ42
	NUPU3FjskiXhD/XsfZ7OfBAU/zZQTFG02EnZJNbvmYr3UAPrzqv1j7UzYM1txrpvLXQRqO+eiZf
	rxwmLHdAEHvy+D58be900y1v1VRS0H88DcvCr7UuLf4o5Wg2B71ur8m4hjhWlVUx4bj9HsRjgXw
	P1wvilzYYgb1R/T+its0j04vHl0wLmzz3EcDayYtDSQMx2PGpazNxF6r2QYKLBrdp4Cxc4hds8U
	NSLsIzZ818hOu/CKtHWMSkAmWtFmfaaGjLk+zGBmNcBPIICbMXnCSm3WT6TOvkr100RFJcUhRQG
	lJPmDpSjEfBVRhIcXeEb9JI5YydbmL5AyS7WdoAsUfgfg==
X-Received: by 2002:a17:90b:538c:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-39b26204a3emr62256716a91.13.1789022066635;
        Wed, 09 Sep 2026 23:34:26 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 16/17] mm/hugetlb: localize struct huge_bootmem_page
Date: Thu, 10 Sep 2026 14:32:55 +0800
Message-ID: <20260910063256.64386-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5C5CA0004
X-Stat-Signature: r13mybah43conqkw6yhikjeiztbhrso6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789022067-63069
X-HE-Meta: U2FsdGVkX18rh2FDz7HMzs6JB5bv3e5uT381kDL9PDz2fvrvG/JS9wyUmW0OsjkbzfletX6n6GIULDaWtH/gfCuaCvICLcLEDSECMHU/3F/d6aVXeyE3IfmiWU2CGp1IugpQxbzJZO6GgbFG/aHXtsKtuFMMmWsZRu3sohzE6S3G2wS+1M0oLbsQEQhPeavK3131bKMOnUUEsfqxHuDfZyAUPkZFQRbIyjFsP9O+VekqfGwZ7XUi0eXaHrzhmmAAaw8qIXsefHTLIYuIqxx+e66iGRNgnqB2ziSxlIq+ReSqnsgvbdXgg+Pqk7mLBohDR7NzO7DiQVytGUrzoMOE5gF3nzWXrxrD6/rqIpypu7e+ElgcjUgmohWtprVwl+Jf69g6MaVeSzYAyrSBTPAVms8yTNtlMH2JBFV/sQ2w9wzJuTwOKeF+uLUQ0Ijop/pUbjQJJluBbDEjXmmvnQGvy8LxuuZwivRGssPyjSrzPTzIFbZqPlPvdn9O0c/2UI9cS+XlzkJDBfS5U3kaYyhrfRiSEs2/feEtZQdqoR2jGGGRdxelM41az2896BcOVF31TRbQeHwc+raBc82WNBzDj79Wdw1m0d2SShfbsd9JXnUlFDtEqUOgjbyZNoUTB/enSTkrpcBypxmeDz1xWb2EsXpmK2wXcQtguLlsFOg5TKpzaNcTKmjb9SW143oMrehUhsTzfsr8oKtOpL63Dndh6L9Ft8pTA/yNPITwwjYI06dZnWT9TxlHUT1QCPack37ZxXumOi4Tdkg0rHjWZOBfGVcmGbaUgHX9x2OxmAKWCVrJNCVsxl+fVm74Rci8IAp2bOZOsMHWa/l9v+eueoqXI6TyBa7Cu+ttas+5Nioj2xB0zrdawKozwgEuwb0pHYqzJMlGjj7IcBew2bK3CeHjQKyd218f06Min/HLHHHU3QuOWYXJqSZVOTOZoQzrnpMoCfJytpeuLSJQAm4xkbl
 1K83gKmY
 Quo8XdVQWLkV/OJFNUnvjowlPcgCYF/k3P39rbk4Zhca79cV7PRCt5BNzg23OI542JK5hc6FjnDxUGRYabFvkDeFGTnJdVPgzem1o7+lfAf+J8NX/8o+6faG/8SSlWyxSxi3qKkYAt66evCcMdD3662UQKsFLm0FcdcWN/8DY+LzvUaqdehHiZvgw1pnNFKQRDWufPe4Zx+e4CGqrWspAqwOKwkknBqd0QCz90QSw0SL3eVngdygWti+j63H/3Zcs4UCmIU46k092VHI7Jv7Xn+ejDhgfYM8Z47hXNqnav532QXZtnfQcua8WTiTcKQ39hL3K0hMGZHxps9n2jar8R8stja87KOhLlt5BW1Ic1WWu14BWDSjNFIn9djP+sw3Bgh4thIKU51Q2sEV/EN7HfvyFqjoI8/BkYgLyrABz6rG8nSxhHTeX/rSkAe7/WwDNauhwzPifcWueY88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page is only used by hugetlb boot-time allocation
code, but its definition currently lives in mm/internal.h because
hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument. This
exposes a hugetlb-specific internal type more broadly than needed.

Change hugetlb_vmemmap_optimize_bootmem_page() to take the information
it actually needs. With that interface, mm/hugetlb_vmemmap.h no longer
needs to include mm/internal.h, and struct huge_bootmem_page can move
into mm/hugetlb.c.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Use the compound page order range setter (suggested by David
  Hildenbrand)
- Collect Acked-by from Qi Zheng

v2:
- Pass PFN and order to hugetlb_vmemmap_optimize_bootmem_page() instead
  of struct hstate and bootmem metadata to simplify the code further
- Collect Acked-by from Mike Rapoport
---
 mm/hugetlb.c         | 8 +++++++-
 mm/hugetlb_vmemmap.c | 9 +++------
 mm/hugetlb_vmemmap.h | 5 ++---
 mm/internal.h        | 7 -------
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f9b609b84509..c8fd3a6ce812 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,12 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+};
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -3162,7 +3168,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-		hugetlb_vmemmap_optimize_bootmem_page(m);
+		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fba0c5a7d46f..f977d0a7e002 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -705,16 +706,12 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
-	struct hstate *h = m->hstate;
-	unsigned long pfn = PHYS_PFN(__pa(m));
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_compound_order_range(pfn, pages_per_huge_page(h),
-					 huge_page_order(h));
+	section_set_compound_order_range(pfn, 1UL << order, order);
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 20eb03df542a..464192e32dec 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -26,7 +25,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
+void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -77,7 +76,7 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
diff --git a/mm/internal.h b/mm/internal.h
index d7673a2b5f6b..18d147487d45 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -23,13 +23,6 @@
 #include "vma.h"
 
 struct folio_batch;
-struct hstate;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-};
 
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-- 
2.54.0


