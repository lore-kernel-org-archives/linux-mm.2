Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20C9CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E396B00AB; Wed, 13 May 2026 09:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446386B00AD; Wed, 13 May 2026 09:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B786B00AE; Wed, 13 May 2026 09:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 221626B00AB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A87D48EAD8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:47 +0000 (UTC)
X-FDA: 84762426294.19.6773A1A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id C6D561C000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jiasXk6i;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SgGCn4266En8ULwXbiJTViXgAGbT0n5na/Xl2vlhYU=;
	b=KduIA8kXKMXJzjtRu5od3j8tTe0zwDvtk05L7t0U5QUQbhdfzHbxAF4KC/vkwZNff8/Z5X
	53LqPhhExAvdvUfkw0nKND0C+JiPTHsva84Mew/mx55WmXNg9aZQKG084gsutALz+VK/6h
	SCpZ9REqKjejwjoZZF4PCV0ZtPHJSEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677725; a=rsa-sha256;
	cv=none;
	b=FaowpL3/thWSOg1cooCZcSYeP/6hf3Lm2bmHQ6SDueyXp3wPx0Uyx7nV281DP7zP02zh7g
	nrUljsQSbScd/5kOqYiZiOj1Y7Vh+ce9B/beFDJL3TOfVAi/92nX5xb9XhFKwKhEBLMW2g
	XuVMfrWhGwZhANmOHm9BtkxYVw8HD4w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jiasXk6i;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b7d3ecc10dso65491125ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677725; x=1779282525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SgGCn4266En8ULwXbiJTViXgAGbT0n5na/Xl2vlhYU=;
        b=jiasXk6ivdrH3bjZyQdVOdkWUwa1zEI3ApYs//jc7CaGihR/FThPpFK9cBCxbmIcb/
         KHWREwqJJqaDYbqguD6/e3mPRHK/JU7gP6Oyv++yMNMFWE2hgTiTfm21uCA092vl/0/f
         jazu+jkgNYL2u8+iep1j+Iw0Zof8JaEBYMTkH7/XXCNvVDTKkUaDf+x8Pgtd43b7raZT
         Tf0PbT65TEjmUq7j6b20pcgTDDm42Z/bcoYNsP8JMrB3gfLF1U2NVRa58dCNOKC8hSBe
         8yddEwkb+J8zJavN7RWYqwesqq5UJYLWDQZUE2FKv8Npi45om/xl9+mjT7U7jRa0v+AX
         NbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677725; x=1779282525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8SgGCn4266En8ULwXbiJTViXgAGbT0n5na/Xl2vlhYU=;
        b=qsEb0kgYtuwBPzxY6VtLdshGcE9jX8n/e0Zgo2TNXSFUGVXfr8vphMJBnyHRCW3mfq
         0UbYes48TAefCAicLOJ1b3rzUEqcU1v9yLAo+bORuPVGioKUgSXxxmIoLKX2MbpJFruT
         LIKFu8TH9ELLhYpLUDmNQUeXcf5kBPd5Lt8FfE4Held+YRXYBDSOZ6YoCH2ZewMmkKuw
         v1p9u0xYDVj9/Jfv1J8mggmWaT+0fpacNXCgzW+9iHWIlfFDO5wVlwv3b4dasKlzsh38
         QPyNl8h4yAXrZKu+dF5B/IfzDEHgwVSjY5qFB1qi3gdBbSuIaEZLfC4ShdiLgSnDXSiG
         BHmQ==
X-Forwarded-Encrypted: i=1; AFNElJ/T74dLwQzvx1tLU6bvPYVtCy5P4G2inTWjD/QI429kGBeAJA1xyfDdCzo6qZFSj6fVcocA9gbeyw==@kvack.org
X-Gm-Message-State: AOJu0YyA2opUuXQPJeDz+F8qiq789xf+uCL6v+m5Lz4gqWDnQngRIu9s
	91TD67pfoSCFVc1f7dni5bpwPZ32kIR4nfPCDcJC4Oq8DTCOnITkUWLJBxRwateF0/M=
X-Gm-Gg: Acq92OFAZJJmw7m2hiwUQErg9V8utqPbZNFd4wGrCyTNei37j6sxN3WbsaX6d9w9Upc
	nGnzHhq2s+59KFYeO5JS3mfwdTp7pdGNcSGOS42XQi5NLCiIKatzfUS2tCSUdLuaVWedMmXpmZE
	BAWhCjU+8WaQ7C1/cYiBNom3josPeMW7v4FYmfDelDJiI4D14PqSBHs4tTdIjAVZ88HIt8V+HEb
	NdRw408qpVQfh+r0cca9fV2yhKwc3a/fmLUvsUIIYJxUAN/1iIa1Zj32QKA6G4VWedp0XOTK2PM
	6luw1KBRNtNzB2FmEF3et+EfZNqjImeJrvHePoBIenndhA1QtP4H6/RHXDZV0COzGOx72sXBwz+
	ZpT231TlGzE/amzW2GOEk6VZqzGQnTTyHg9CHNvlP9JdJ6V/6JZm/O3GKzw2F+t3FwL9Wt29Kb8
	sghitEVjn2ybfthqiL0lYh9UAY6FDK2R1oh2FsPYeo1RFv11FZl6j4NZf9UJ4=
X-Received: by 2002:a17:903:138a:b0:2bc:eea4:83c3 with SMTP id d9443c01a7336-2bd276f5ce9mr42050215ad.25.1778677724547;
        Wed, 13 May 2026 06:08:44 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 13/69] mm/hugetlb: Refactor early boot gigantic hugepage allocation
Date: Wed, 13 May 2026 21:04:41 +0800
Message-ID: <20260513130542.35604-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6D561C000A
X-Stat-Signature: kd47icrymirtcwo9bkid9z94jf9dfqu1
X-Rspam-User: 
X-HE-Tag: 1778677725-92321
X-HE-Meta: U2FsdGVkX19gdS4SBCIcOadqrcBEpqyKkD7hjSZ76mKdsVQgvZTfTNoi6vazLNPdrc3i10QMXgIxzWvL0QGszj+52/gBEIlvoQXvDzIBrZrocHruFQHoZqYWMdt79sMRFJxpx/KuoC0mk7TKCkoJIt8CjsREiIJ5iJfWV6ZCxsx2B9YvCujkszgiR26OsUG8z+pTKmuiS0HHf8unSy+vgj+YgFoBgYfkHKokr2B4PoCHzMvpH84YjOoR+lxeoMyjGjkVV4qSJ1TNJvDRBCn7FbqG02hhlXgxEQjq6OiQ9YI5qZpCO4w1m/V620kjj5i/TERK8QHRRKnLKBDAk8ZUK2SWt9UbJabLzzc5EwdZgvRmgdCRpojKBCKMt5aQtqvQf1DCRVoDkTnAuO1FQNd1K8AMcYZ5rzmkKuxirYWd7UCmguBfdkHBHZcfpdGrZ8Bfyo0utsBmMy/Gi7N1dMZ+u9HF0xDdC91uzhlVG+oVxaBIKr6s7m2jCIkBmOjiVGUkudhSDpEPugQYMehnbh/1xuqwBi7C+j+B4c7YGjbsFZasi0+QBgzTcPYo0dU20+DncBnavyDcimf9iMbmoeZvjgg/xKWEm8AYWLXC7JKfu1801utWp/sE/z8O5bGLnfMCntSHKmsVnUtyLbzevKDu9cIiCogPrCfjc6hdIR5EmYudgZQSE91bxvZ5a1t1mLnK4GGG5y/PnexGFTUrzm/OUNf89v3hgpHlL/pRMYF+1AzmUE/1l4ucObGx8SuIfjaSzzs9fLXhC4aWY07mYKQNMkKxBG/LyeY5P5Ftzw5IDUFbzfyuhL5F3/mGhmJySWzPPGgsCHQvkFmDvzIQ8HXGU6gBdoCG3XL6iV8SjInqUIYOpD/V+VKOzk8oadyuuOHX+mJOPHv0h9xudqrr9aBsjOf2eoEBrELp5JjyISpuQlPo3LV0TV8i8H7NS1RXwlIlAvtLEW3oGD5BgkfKDfr
 4h7iDMlT
 7ugsVA3EkYX+ApelYHiEcdv1ORvzZ0fDuAO65121De3u5+DBjSRJDOtFu6eC1u0seZQ4aB0toKir+meaMUq5LN6Tx8cK4IZCDgqNJefosp8hfmX74CbDsoQp0WBAz6YJWkLD93Q8jbB0vqXv8NXcloET8E1xpW1GYB0+fSrgjqze2WIjuiOHJkIQEsue2aJhA7tnVvcoMwMuj6+Vf4Y2+CdBAfJmHo6jKToP3KZZM7/fI5tCYraYb21qQmitqanzanpcG6K6OLO6IilmiOiTzyCRZoHQOxakhZ5e91dfnNK9+tHhUI3nJoUK/FQ==
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
---
 arch/powerpc/mm/hugetlbpage.c | 11 ++--
 include/linux/hugetlb.h       |  8 +--
 mm/hugetlb.c                  | 95 ++++++++++++++---------------------
 mm/hugetlb_cma.c              | 12 ++---
 mm/hugetlb_cma.h              |  4 +-
 5 files changed, 52 insertions(+), 78 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 558fafb82b8a..ff8c5ec831bb 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -104,17 +104,14 @@ void __init pseries_add_gpage(u64 addr, u64 page_size, unsigned long number_of_p
 	}
 }
 
-static int __init pseries_alloc_bootmem_huge_page(struct hstate *hstate)
+static __init void *pseries_alloc_bootmem_huge_page(struct hstate *hstate)
 {
 	struct huge_bootmem_page *m;
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
index 52a2c30f866c..9a65271d167c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -720,8 +720,8 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct folio *folio);
 
 /* arch callback */
-int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
-int __init alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid);
 bool __init hugetlb_node_alloc_supported(void);
 
 void __init hugetlb_add_hstate(unsigned order);
@@ -1152,9 +1152,9 @@ alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
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
index b4999653a156..e9ba0be2eb17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3044,79 +3044,58 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
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
@@ -3128,7 +3107,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
 
-	return 1;
+	return true;
 }
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 57a7b3acc758..6b5c2aec4449 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -57,13 +57,13 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 }
 
 struct huge_bootmem_page * __init
-hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
+hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
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
@@ -71,13 +71,11 @@ hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
 
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
index c619c394b1ae..057852c792bd 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -6,7 +6,7 @@
 void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
+struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
 						    bool node_exact);
 bool hugetlb_cma_exclusive_alloc(void);
 unsigned long hugetlb_cma_total_size(void);
@@ -24,7 +24,7 @@ static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
 }
 
 static inline
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
+struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
 						    bool node_exact)
 {
 	return NULL;
-- 
2.54.0


