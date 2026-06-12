Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 821BDCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E065B6B00AD; Fri, 12 Jun 2026 00:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDDF66B00AF; Fri, 12 Jun 2026 00:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF34F6B00B0; Fri, 12 Jun 2026 00:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6F86B00AD
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EC141C3AEC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:20 +0000 (UTC)
X-FDA: 84869908200.02.690C740
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90A1BA0015
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="GnERo1w/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K17o2xzrKCCnQsTBiihj6xsLYHSl3LYnDWpfyCRPu3g=;
	b=wVj7RXgdSpkkqQQwc978QgnwDOJ7J9xn6Y+o/6XYGEghlKkQp6QFOpIU0IGrjPoIFXTNoD
	4guSpUZczkUPbvaw3bn2sCsAz1YHSrVYjMYpheNtNDJjIZ/VvBRTHtc9uHgzmhNXkEVt30
	OiW5bBDMuvRQQzyq4nxXJGlq1FgrQ+M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="GnERo1w/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236818;
	b=ojn5LflrbTcjQLFUewbZh+/nMBtOqaWcUb/GQJNj3289AWR3VgFPPtPQ0ZtMJ+MelPTV7a
	knQ6GvqIX4JaeuFc1aKHrNNrzBtXmfYzP3aVg6HQ4Ho5DILKQ3MDQQ8Wnr/RaowEwAAVFH
	R/A1VJLnaHeWjGFRrosJX5BN8Oh88NM=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8423efad617so393989b3a.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236817; x=1781841617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K17o2xzrKCCnQsTBiihj6xsLYHSl3LYnDWpfyCRPu3g=;
        b=GnERo1w/3SiCfXYYN6AFGYqBvo1k3kffj/QAgeHeiJ+mahQd8DaC+wE7tfJdmB0gIo
         CrXleY78kcNhibniIc9xUHO5YRGCdk7xR4LAGSgyK4Xt9rCbzrZKVJcOWUecBQ6+I+6f
         XGzzbtqu/T0ObCpuxm0JhzZqblmcwR4GnW+58fo9Vz2rcfOJSkipOtFz7GspH1zY8KM+
         oxwJuNUSGnkh2a1GHM5YP5VzSoD5ZuvRgH+ER0gf3JWsYldKa5tYe7mjsg1nbwAM2FL5
         bNcT4eBOepTIj+yxf9N7EQMd8BzQE8nMetup5JPITKrVeF6wTnlDlOuvBnK6ITLVn5le
         pavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236817; x=1781841617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K17o2xzrKCCnQsTBiihj6xsLYHSl3LYnDWpfyCRPu3g=;
        b=oz/DWwlG/cfRXLW8LbQ/C1zzky3qZ1lPgb3iDFd31p4j/9MCRUFh/eZJwdkaPEY4ZC
         DQlRx5aGNY6vdNwZ80tHtqqByCnTvElFze9819jt5TKd89NTvqSPBpdQzoLnjt56rm5m
         tWAN2cGNDgZeLO0LHyuniCwdg5xo5nXkiJ1PtTVLH6d3q6+fkbLbM/XqDbJx6vPMi/sS
         4FFqKjN+JgampE9QzIehxUlxz6d569lLA/D1VRUDsc80stvLXNo84lbsSY61k4Sy6sra
         BUz5z0x3S/FWQbrV4aZHxEZKYMX6C5Epw0WkG2dT3LsrOuUecCDLQAo9OaHkyH1P0kdk
         bWPg==
X-Forwarded-Encrypted: i=1; AFNElJ+ti5+DH/WVBLS443MpFJ9bcQhXIYbfCcCpon4d8zAqSyk62LDFHw0UMjTI/Kaywiqr1nLwT8dcLw==@kvack.org
X-Gm-Message-State: AOJu0Yx9iNVq8A+8rM/Rnr9D/kbH3Z0pepj7zPIzr7GdX7ltacjFcFp7
	wi7Goght5NRHMTloHVsdNdmKah1Xcfmbybne65Y8mKJo/P7v92QPw/Tscl7pE8Qi5p0=
X-Gm-Gg: Acq92OGaSrH9XNj/MST/dtmc+Ho1DYKKYWHaadLF4uPhmy38lGkRFvp98E8ICQpfpTn
	o/iC3vtWjH0Pb70HqabJOCCFlCtVHqR6u3Xrpu0o+4h3DTE4rAUpt3OcbaqTnG9RGA/XHkHu7Ih
	dMKygg6KlNnLJuVY12pQ0koqWgC4hyXY2Yr8rjxMh/8YE5P0hPpQoHGyRMjtx2o85jPrY9/c8hd
	kLrTMVPsOQhE+lA7FePYSnihYei7TRrYziZbEzmGNwyrW/TmecIiGXJDP5lHIw8Svk1eEleoUVI
	IqApiDQ8G9wEtpOw2iR8xWSg1+H5n5bh6ck6VYgN8QJ4iLHjDF0vKRnZKHG6On6RLoF/L6B9jLL
	xH9O9u1unFFbiTLloPaBw/0/HD2mRT6rmmxJWwpp+U3hJsThsPxLrcpwKBKbQWCN85I4HpH3Zzt
	aQ8h2BRpqBUyZQca77rRbHOez29GQ3Xq3bA5LOmUOQpbk=
X-Received: by 2002:a05:6a00:2e13:b0:835:3949:3c22 with SMTP id d2e1a72fcca58-8434cf17aabmr1096032b3a.27.1781236817042;
        Thu, 11 Jun 2026 21:00:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 13/19] mm/hugetlb: Refactor early boot gigantic hugepage allocation
Date: Fri, 12 Jun 2026 11:58:57 +0800
Message-ID: <20260612035903.2468601-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90A1BA0015
X-Stat-Signature: jeet9m9ohh7zho5kn5tzp1zm5r4bff67
X-HE-Tag: 1781236818-139793
X-HE-Meta: U2FsdGVkX1/zhS32qEFF7l2CxpKzJCR+hOAm5z5t+U21g8JTXAS0cMsGkMDj71fkb531V/FEWcjDC7u3gdrymqaqoQDHlqCZrEN6sqTHWBZ8vAuy4NEDhIYaBW8cFqC6ZMi5YeikiiyR11OBwUYx7iNsarKmnJ0ewihKRVfOvUBEhsivflJEW3Y9nHFHZXDbaeIQFNKDXKf7LT3ws/yaP86oIpM4FTIopNLwNyJ/tO1Ou15eiHDBMWJE5jdJ2O7Th+B9fJc0NsPqC4ZIAehasGlNwM097aMPUKXFinjmeSP4aRBdX+oCRGzZmqdZ8yPs8GuOr3h/WMsMW7F+aU1bXnw5jgW3sopuv7Fzt5/0PAn06CTLLdPis/wpKrNnbm2gjuxOkpq+WQWhqx9uZDKcB4JrJbdbEs8nxr05BJFvpCsGRx/L5ckBdjcqv4NFbZH+nz3beXa7uRu+xRjl+wqKMC1sETd8T1YlaEDf2PkjBAB8iVDHUZbSFLUtKMNuqIsCkxrSbIe02bEyhxYtDawYfy6HXmTif/w2PumOf4hDhceD5c4DoIDcEbgm7oyvxzfesqjCPwnw2S22Cd22y3hquGsKCRcVknKGOHLgiV43ZmxLIgNAsSPGSqZLbT/zqCbe1tnGLllYvINprum8QNW4j+tQ21dSfG+7byR5bsKqjpRhA7oGIauCVKcVbrQ2EsrGM7GXf68+77czzAHssXnR7OF8csrrwIAuM9VUpMHh/qVkMNREs8cLMmOCRS52XYpYJU4EwxaYzpspRayTxXmDFJ/o5Ip2IC3AIK7FNPLFVKD/2VOWYm1ooXE55gF9kxGsOeguc7s/j+UYm7fRwAdaG1yLQfXYoLHB+uGLP7nMYzuKq53OPOk9e2v0EzNFONDG5kNtqJRZLsSrM5EbBDOWTFPI1JnBtfnxmI2V4UwmniczZvH18R+tKsT7ROlYv7futNRrBwhKi27Bi2nLJDu
 TXDqJgZn
 1T+rzQpfBkam8Eo3dxsoYJIzFnSmjn0cdor4e7cUqobE/rJi9A7xWJSS1Md9K78t4YbUYWZGESVoN6373GxGlknmGoqsUwaO6YNHknEwsbT/IAg03Pt9vIoom63LOLVvJUtavy0NCzvIBJlDNrJyfYGb1Fq6sDtoqQ6JB33Yxg4ZgndhqOebsSiHAgmlZcILUPW5HcH0NIC9beUbIxci3xwQNBErkj4XAdBR6Sj4lLkhNpm8t6pEzCmfdT6X9/G2QCKsiswGZqWwGxF2MPqfdkoPZi8iV6ItUj4FRmmmlksoCmBa59FRTPear2upJ1KY+FLQat0VzAo6H+8oPlcfcO7tt+H4ZvIdPnZmCH4aF4/2XbYi0o5R5cDwLjpaoIbYMAPi15XVjaKc2WCXdnqOqVbeRHfb1iod4Rr1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The early boot gigantic hugepage allocation helpers currently mix
allocation with huge_bootmem_page setup, and leave part of the
initialization flow in architecture code.

Refactor the interface to return the allocated huge page pointer and
move the huge_bootmem_page setup into the generic hugetlb code. This
makes the architecture-specific paths focus only on finding memory,
while the common code handles node placement and early page metadata
setup in one place.

This also lets powerpc benefit from memblock_reserved_mark_noinit(),
which it did not enable before.

In addition, upcoming cross-zone validation for boot-time gigantic
hugetlb reservation is common logic. With this refactoring, that logic
can stay in the generic code instead of being duplicated in
architecture-specific paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
---
 arch/powerpc/mm/hugetlbpage.c | 13 ++---
 include/linux/hugetlb.h       | 18 ++-----
 mm/hugetlb.c                  | 95 ++++++++++++++---------------------
 mm/hugetlb_cma.c              | 13 ++---
 mm/hugetlb_cma.h              |  8 ++-
 mm/internal.h                 |  9 ++++
 6 files changed, 64 insertions(+), 92 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 558fafb82b8a..a298746dc143 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -104,17 +104,14 @@ void __init pseries_add_gpage(u64 addr, u64 page_size, unsigned long number_of_p
 	}
 }
 
-static int __init pseries_alloc_bootmem_huge_page(struct hstate *hstate)
+static __init void *pseries_alloc_bootmem_huge_page(struct hstate *hstate)
 {
-	struct huge_bootmem_page *m;
+	void *m;
 	if (nr_gpages == 0)
-		return 0;
+		return NULL;
 	m = phys_to_virt(gpage_freearray[--nr_gpages]);
 	gpage_freearray[nr_gpages] = 0;
-	list_add(&m->list, &huge_boot_pages[0]);
-	m->hstate = hstate;
-	m->flags = 0;
-	return 1;
+	return m;
 }
 
 bool __init hugetlb_node_alloc_supported(void)
@@ -124,7 +121,7 @@ bool __init hugetlb_node_alloc_supported(void)
 #endif
 
 
-int __init alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3700c0a1f6ff..09f28dd773b7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -674,19 +674,11 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-struct cma;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-	struct cma *cma;
-};
-
 #define HUGE_BOOTMEM_HVO		0x0001
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 #define HUGE_BOOTMEM_CMA		0x0004
 
+struct huge_bootmem_page;
 bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
@@ -706,8 +698,8 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct folio *folio);
 
 /* arch callback */
-int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
-int __init alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid);
 bool __init hugetlb_node_alloc_supported(void);
 
 void __init hugetlb_add_hstate(unsigned order);
@@ -1138,9 +1130,9 @@ alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 	return NULL;
 }
 
-static inline int __alloc_bootmem_huge_page(struct hstate *h)
+static inline void *__alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	return 0;
+	return NULL;
 }
 
 static inline struct hstate *hstate_file(struct file *f)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2bf9fe16abb9..5e557c05d80a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3027,79 +3027,58 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
-	struct huge_bootmem_page *m;
-	int listnode = nid;
-
 	if (hugetlb_early_cma(h))
-		m = hugetlb_cma_alloc_bootmem(h, &listnode, node_exact);
-	else {
-		if (node_exact)
-			m = memblock_alloc_exact_nid_raw(huge_page_size(h),
+		return hugetlb_cma_alloc_bootmem(h, nid, node_exact);
+
+	if (node_exact)
+		return memblock_alloc_exact_nid_raw(huge_page_size(h),
 				huge_page_size(h), 0,
 				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-		else {
-			m = memblock_alloc_try_nid_raw(huge_page_size(h),
+
+	return memblock_alloc_try_nid_raw(huge_page_size(h),
 				huge_page_size(h), 0,
 				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-			/*
-			 * For pre-HVO to work correctly, pages need to be on
-			 * the list for the node they were actually allocated
-			 * from. That node may be different in the case of
-			 * fallback by memblock_alloc_try_nid_raw. So,
-			 * extract the actual node first.
-			 */
-			if (m)
-				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
-		}
-
-		if (m) {
-			m->flags = 0;
-			m->cma = NULL;
-		}
-	}
-
-	if (m) {
-		/*
-		 * Use the beginning of the huge page to store the
-		 * huge_bootmem_page struct (until gather_bootmem
-		 * puts them into the mem_map).
-		 *
-		 * Put them into a private list first because mem_map
-		 * is not up yet.
-		 */
-		INIT_LIST_HEAD(&m->list);
-		list_add(&m->list, &huge_boot_pages[listnode]);
-		m->hstate = h;
-	}
-
-	return m;
 }
 
-int alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid)
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
-int __alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node = nid;
 
 	/* do node specific alloc */
-	if (nid != NUMA_NO_NODE) {
-		m = alloc_bootmem(h, node, true);
-		if (!m)
-			return 0;
-		goto found;
-	}
+	if (nid != NUMA_NO_NODE)
+		return alloc_bootmem(h, node, true);
 
 	/* allocate from next node when distributing huge pages */
 	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node,
-				    &hugetlb_bootmem_nodes) {
-		m = alloc_bootmem(h, node, false);
-		if (!m)
-			return 0;
-		goto found;
-	}
+				    &hugetlb_bootmem_nodes)
+		return alloc_bootmem(h, node, false);
 
-found:
+	return NULL;
+}
+
+static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
+{
+	struct huge_bootmem_page *m = arch_alloc_bootmem_huge_page(h, nid);
+
+	if (!m)
+		return false;
+
+	nid = early_pfn_to_nid(PHYS_PFN(__pa(m)));
+	/*
+	 * Use the beginning of the huge page to store the huge_bootmem_page
+	 * struct (until gather_bootmem puts them into the mem_map).
+	 *
+	 * Put them into a private list first because mem_map is not up yet.
+	 */
+	INIT_LIST_HEAD(&m->list);
+	list_add(&m->list, &huge_boot_pages[nid]);
+	m->hstate = h;
+	if (!hugetlb_early_cma(h)) {
+		m->cma = NULL;
+		m->flags = 0;
+	}
 
 	/*
 	 * Only initialize the head struct page in memmap_init_reserved_pages,
@@ -3111,7 +3090,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
 
-	return 1;
+	return true;
 }
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index ce999391cc14..e487d0ffffc0 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -56,14 +56,13 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	return folio;
 }
 
-struct huge_bootmem_page * __init
-hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
+void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct cma *cma;
 	struct huge_bootmem_page *m;
-	int node = *nid;
+	int node;
 
-	cma = hugetlb_cma[*nid];
+	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
 	if (!m) {
 		if (node_exact)
@@ -71,13 +70,11 @@ hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
 
 		for_each_node_mask(node, hugetlb_bootmem_nodes) {
 			cma = hugetlb_cma[node];
-			if (!cma || node == *nid)
+			if (!cma || node == nid)
 				continue;
 			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m) {
-				*nid = node;
+			if (m)
 				break;
-			}
 		}
 	}
 
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index c619c394b1ae..3aa483573d17 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -6,8 +6,7 @@
 void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
-						    bool node_exact);
+void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact);
 bool hugetlb_cma_exclusive_alloc(void);
 unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
@@ -23,9 +22,8 @@ static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
 	return NULL;
 }
 
-static inline
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
-						    bool node_exact)
+static inline void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
+					      bool node_exact)
 {
 	return NULL;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 09efb9f4d126..3401759924d9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -23,6 +23,15 @@
 #include "vma.h"
 
 struct folio_batch;
+struct hstate;
+struct cma;
+
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+	struct cma *cma;
+};
 
 /*
  * Maintains state across a page table move. The operation assumes both source
-- 
2.54.0


