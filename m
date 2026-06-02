Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B92CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202E46B00CE; Tue,  2 Jun 2026 06:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B4A6B00D0; Tue,  2 Jun 2026 06:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053746B00D3; Tue,  2 Jun 2026 06:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E441F6B00CE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3E7D1408B2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:08 +0000 (UTC)
X-FDA: 84834557136.17.ACAF3ED
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8777100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jBkraZDj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izaqgnnNIWyz1SuOc+YrUva6s2Nz3vC7JJgyPQLHyJ8=;
	b=x6IfjNzsU4ea+BbJoT6Br2INZVk84XXR88aYvWI8RH22Qe4zykluFfEGa/jdTp2POMZLIM
	FEW2DjFOObOyHUaR5rcQD7fMIqYTceRXLKzL+rgWBWPOSwnVYXv87zY1g+zHs3pcdV91RQ
	ujqZvFwtnuIvj+nLdGkE48zMRax8rzM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jBkraZDj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395126;
	b=yrnhbuEv08nbflcN0a/rHJb0J7zQ07SUVgBa+gjI6PVNqCFgx50WTMqx5aI/iwfZD43hJv
	HWvx1uMvTq0lirwI4NpSo/BLF+WMmdI+eAridb1cHruwQDIiPoUEy4+YfV4sHp98VINcz+
	k5nrLbvKEIlXdktabE/Sb0OrHX17xTg=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8423f420455so931230b3a.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395126; x=1780999926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izaqgnnNIWyz1SuOc+YrUva6s2Nz3vC7JJgyPQLHyJ8=;
        b=jBkraZDjneu8LHmiAgMsDmEqJPnxQpED0d/AfPvQy40avlYrO0NHw+8j5qAIhFubzV
         WFVS7FfoeeOT4HG5HqHmnb93u5e6lZpkEZk6+cwUH8Bv3DrCjNA1Kzh/Qm4GRPswEfUV
         V4lsRN9HQwa5pa9MIQhn2s0n8oPSl7uB9WWbF1D7ozdQwFkRjW5jpwsfIDWdUtwjFpnl
         NRnIoovq+67P54Lh0f8hKzrwY/05urTNR3eu8i0wlMzFsTyUeTU+8l8cPVV9k2dWxtsH
         y5vsbWkzGiCKL1/Lcn1g1rFykQnVkBz4tm2tgOw5//N6Cn2p82FBzNAwpANM8nwmVWai
         nPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395126; x=1780999926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=izaqgnnNIWyz1SuOc+YrUva6s2Nz3vC7JJgyPQLHyJ8=;
        b=G3LxZCw0YI5PY5RNoza1jf9BJSNpgKqASxhkbAHFnilkfubcxzHru8Z0Ll+S8j2xB7
         EL/1PWG7VbTrgBfjrkZAE9NZrzj3RHs/6mj2UppyrT65Dolhj+qbHj2q1g3HRQrHGOow
         Gn+qOfjLTrp6RnmpANdv7tGjLErTlLvV4kzCS04ea8TgBoWoTx2LaHcIXmAdUPicXBPn
         5oR5wWrowssESwzclpbJw4e/yVDAx/qBlweyeS/U7Q1vnd8iGMxXDLY2xmbo5wC55FY6
         W6VhJnpC/1dVxJaB+YtUAEU08Tknbz7Kp/V7HkuwOHxjZiUaO1jz9f0KeV6npJr2ud8k
         eBag==
X-Forwarded-Encrypted: i=1; AFNElJ9skRiRk/6h2rGSwU08a5pbqTDXnHfeBqs0mYPcDUo45fl3dBlPCXM+BFFdpqjuQIzxR2bbWPxWOQ==@kvack.org
X-Gm-Message-State: AOJu0YwxTeTvzft0D9aS9TQK+DPHmTXDAzgITmjyyesVWKpZ9TfYZIur
	vfXHVJp7EIwF8qMgtYN8yBDXhxtSRLibKOJyLso4u7kEu0AB/+ApJDVCngYjrG3ltwM=
X-Gm-Gg: Acq92OESsF3t2tjyXknBDwtMEQGa8xPR9QXkAiY3CdN5mVArDaumVM8ricm27K+pGW0
	dbJTmPxGkz/jy7piRRfGmH3AZAo48I5zgl7Pfkm1QJ91Qc8AT8YVZq0xCv9dzDyLj+9YMdl9+6m
	SLv2wMj6lgonePrw0iFAJbqR0EkrvQFtnuyJdO6pdDHIB0RGDqkjlmoK+OR99WXGB+rtpyvx3KQ
	7qYeb9FDvc4lATTes2bmJ33lljQkdgQvdDLV67my+PfRKqFMmhpVMVlABMdPN0Vr4PhDy3YtzCN
	Eo4ManX96BZNN4hdOKAl4wQCmqec1qKTQtUb8xl1prxTMwB6z1nXyui1PAFX6pmwdKZzWDHZLet
	wxI2UTprjO/AmevP+fnK0UBoNh/+t/yiDArRK+JCRoqu+6rq+jkfRT069Vy6utmOBxHaV6uSgGT
	1kJngVsNo1Q5IAq1YMxhOYhPM4Zpb0qUX2UVaHQZz8cf3K4CelRZFBe3MoxSpsSo43oQ==
X-Received: by 2002:a05:6a00:744c:b0:842:3aee:12c1 with SMTP id d2e1a72fcca58-8423aee321dmr9318619b3a.18.1780395125556;
        Tue, 02 Jun 2026 03:12:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:05 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 13/19] mm/hugetlb: Refactor early boot gigantic hugepage allocation
Date: Tue,  2 Jun 2026 18:10:33 +0800
Message-ID: <20260602101039.1867613-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8777100003
X-Stat-Signature: spngjxoeomihq54b7to9e8exjp1gycwo
X-Rspam-User: 
X-HE-Tag: 1780395126-183290
X-HE-Meta: U2FsdGVkX18GPqymon98HhEJzFT6o30se0n1bLmrdR4IqNMQ8h6evbceXXWRlN3yHr/iTjnBIprNWSmGS+kg1l26GT20VLmMcPmw7CQCPpFE3TGnk8pwwBgyP16FLUq02G/it3tO4sQQQlFlnoSF8v5dazkT8Z8bCqkjy98GT5NIHhvHrL5RA+aOlbJJc0bOIq1fubpJfvUnaqT4mEZuOCNhc9FssZ4eul/NdsfP99saTYcsGjM5Fxln+EI5wUwE4ANvC8wc/wo2GGqQXzf/YvbptgZrvuUH26C8IoR7zsGlArNZw5SgFZ79Inbt22uNgyR2kxGXsnJN542B+qmCiuDMi5guYEZC94gR95hPifjmKvLYMJL04yiyis7Drv2phsv7oZ3UKYJvlHddU1sOaIUFsLayFeuJ0krx1sXwT21uLaJTvtVGmNs6shIN1m8VIL6PkCSS6ncsreIMqbAfhOGoONQ5326tPqJY1eUbuH6Gyh6yAjqpSjUP/HfFkCPX9t7agxP5F3cRV6ZGwsleWvuEYQO1uG7915YGSgvyqURmg3UKGfjPp9KMyzJSEOkHr4rof8YfDxBpczTZoQssFy02hm/y/ABThnCudlZBbNxJs5MdOBqDsDr/PR8Xcp4NDz8XWOFo1LSUIhuEmkXJQoBMgtGgA5+K3uGKURca4Ygp74E0/TXy/cc/smgx79+vKGL2aWncW/taG89nKv6CJudrO3U6mjGvIMXjf1uFTTWMoTG9/xkvNVT7jpmU2VUx5W6oh6fORIbiu3sGeUp3UXKrbJh6J4hIhW1tJfVSoMFoEdIMYMAHvSW5uNupraYGaIJSOg9zSxznlwjht+CB028nyE72Sx4cyYig+sczSRlosJ/F/qWeDlgRcfwKHvpbgo/duuOHUyGkRrda4qAAS3PQZqnP/cujNEAUjdIvv5qkNvqFblv3369usmeArrJEF8UDDDltzTvrUjPuNWd
 q87qYVj8
 OPE3/YpkXC9p3oYMi+jO7SYK04kJf6o3zl3Fj/6lBXbtnvsecj67VIFZGasV+FukwwInDbIRhoiUPH4YYf+q/b2rJ7JXPpMl7dz97UU9xB+vk6U4K/uM0Y0GG1bxEO4lwHF5yc5sSUHRkj0Q1t/h/VdkCup/4bndDe2TC/gIChmNEo8Tv+bErKEH9iDoG4MO5ECzA++b5AEKDhRuj2l4+J+RMCFFkbuyAzqjTvoQMwU15neh9Ysu3zkwd8ZfYcr1hiwSIWrK+MBx+Q89Q6sPRNIOrJMvbWIMmWiDAfaiobPjS5iUthnEZ59YzipPK01cFIEDEBornlkBw1XB2K/rrESUrA2ojGrd8gLjPXxb/gNdWFbAFO410d8+tSHIxq1ts9DatFvJq1jq1KFN7WXfm4b5yQw==
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
v2->v3:
- keep powerpc code independent of struct huge_bootmem_page by switching
  it to void * (per Mike Rapoport)
- move huge_bootmem_page internals out of include/linux/hugetlb.h and keep
  them in mm-private scope so the arch code does not need to see the type
  (per Mike Rapoport, echoed by Oscar Salvador)
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
index 004a3f1d5006..6b9802460a7c 100644
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


