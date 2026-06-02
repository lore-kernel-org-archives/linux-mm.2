Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DC8CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F816B00D7; Tue,  2 Jun 2026 06:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620236B00D8; Tue,  2 Jun 2026 06:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E79E6B00D9; Tue,  2 Jun 2026 06:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 343E46B00D7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65C8BA0899
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:24 +0000 (UTC)
X-FDA: 84834557808.23.52147CD
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A04D180007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S2v+nxDd;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqtFBpfBq6FrNHW9ccKxFbBIkIWdyfnMbN3qSInC4vE=;
	b=KP7oQBvkhffAzNqtd1f0J38c+D8i70ZWQxTQa2fTaKDmKuX9T7OQW1DLXpycNYBGPE9tJm
	PzmjJb2aYoJSNnU62DOvEYx2OCfCiFX+zeqXrf9FjBDeYLa/yaW6lSLoF0Ll1xxLeNap/8
	Biu5zrqCkBFqLN4bv+ow7P7Yhc7PWEs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S2v+nxDd;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395142;
	b=NmSPnopi1Mkpw5uTaf2xuBOzFEA2lonnu6azHjDZ+Ooxkl+6uebhJomleHY9RPodsTIbf6
	AOrM+2SIe8mNt5YGJ+VBYb0Y79FPyqDi0LI6emOKdxNkJ0kPD5ysHEkFRoXC+Vo9BqfwnX
	SoFikUDnwymiYzKUYlBT1GUmcrw9RVI=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84232e83ca9so1043790b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395141; x=1780999941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aqtFBpfBq6FrNHW9ccKxFbBIkIWdyfnMbN3qSInC4vE=;
        b=S2v+nxDdtkjcJydpPpZOl9/zVWJuRJRdxg+dF8cSY5fx9Vor4k7m2IyGUes5i2CDFb
         lNbubUn9YkZwU1Lyq5ZcD9KjUA5o1qPOzhcUsw/djWN8b1Rhg5P9WTr26o0So/nFN+pN
         bfRPgx3c4plErX7iDq8pYn6GqqsHbmuQDypqVq6O7V0SPXjieyw8PCqADtKBISJDZwW3
         WpnlIAzBpTKKU0yQGWMvpM5milTHA38iKdUorUO5h5omYWOqyWchzsf7nh4Veex3ii/4
         E3WPYxALoIssSGHn+pFX+twEFhVMUC53SvDKzFtk1/wjvg7YBiwTCTfH2Uba6KDpfyue
         HPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395141; x=1780999941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aqtFBpfBq6FrNHW9ccKxFbBIkIWdyfnMbN3qSInC4vE=;
        b=QivHr5rR5GyMqthQh8npcY++jnP6q8mYSfAcY9fGZgVYhmLLxp5SZiB+0yH2bTcUfG
         VmJa/BrYurIfAkxIUrXiJEKXpbTJfLUwkJnhqWPMaeHj6LH63rv1RYU0KCk8ERLLMB6r
         SfXIAfQNqDvKgLr1qqGZ/XI9zsGoafgsQsrMFZI9wQ/WTEtKkOP3eomf9LRwyuKgD4n0
         /2cspKRRYqPuZFCpb5mDFQhmmL8VVZ1+OXuFpqHEVlQqpxAr1bylk6ORSlMUaoNoWKEM
         SWqdcACEySFOCozMTkXtyLuCOo7SM2ROOKBzLUVzWqOVJcUXWaaRAquTB1zzVd3v1bOQ
         GQOw==
X-Forwarded-Encrypted: i=1; AFNElJ8RpbxaFK4IiATwUSroSKJ/gVpgoc+UWQksKHxOu4lzNh9AW9/6B3kwy4pFuJREY2PMg5XvCD+ZDQ==@kvack.org
X-Gm-Message-State: AOJu0YwqNykuar7LrJYkQ+Fxtanf3SIzjOYT1JaZJllSt6OYkG2z/EG3
	DWBu6um0kJZoExIr3xptS2hjzN6H2daa1+GrZEB9/fDctyBEQ92kTU4V4B8a55zXYik=
X-Gm-Gg: Acq92OFOUSggU+RXm9FMc/PnZVJzov8Vb3Slmb6XAiGrGXSjqX5EzpC8523rgAe6ocu
	Z37mvf7oR18UbkEXUcLvaO1cZhQNargMCaloCEpZRpx13Hgyr5GaLI13gMfFl07vtSbaOZgFvhJ
	Yq/2XWQ7KzJK+/rce4C32wfjBqVXVQTmcZJHs04twbS6IlkDCRQLnDcukGhZEXVVauO9dIrKDSP
	w/fE/EQ6pBV8qlykCNoDEfVAMT9DDufbJCimoGjXi7zhRDy8a+ZZeHCQHNAr92hjwkf1TSAKS2F
	teaP2NS2bzBSOYOAEU0omi9uNfaOJrH+mmGGncFga2ISPRuOae/Wo3bisuFJRcf2FsQaVIQ1aDb
	ITaXNh2B9lY7la/WzjNwZGVUUI9mf8oPd2cXHbXnGBSYsmgYLPOZvamyzGSnSdhKggwnQsHX8yM
	A6v/EnzftBKuIgmda+uIwZeUTki5m7TJOjxMg8M42S9Q6V1fFnDk1PGqY=
X-Received: by 2002:a05:6a00:92a9:b0:842:6f13:1461 with SMTP id d2e1a72fcca58-8426f131bffmr2620970b3a.11.1780395141260;
        Tue, 02 Jun 2026 03:12:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:20 -0700 (PDT)
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
Subject: [PATCH v3 16/19] mm/hugetlb: Remove obsolete bootmem cross-zone checks
Date: Tue,  2 Jun 2026 18:10:36 +0800
Message-ID: <20260602101039.1867613-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A04D180007
X-Stat-Signature: cp9x38bi3xm73ki1c87jbsohhr6mr8d1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780395142-26138
X-HE-Meta: U2FsdGVkX1+9d/CPnFNvC0QCY+N3022XXMz89Z0WqG1AB2q0Bw+9GlIB6/4V8dVq3+jkglTIxs1hBVpKKFy1K75iusW23uUBzf5b9dk9BaYMBpe4fGYEjNybnBO02xboScdSp/61P/kjQDtRwxlI4uOioe2vB/s7PYvFyYHtpFrcPSeB2Ffb81futf+Cq4n+hnUQWeG+GU3HnNIB4ocKtqxKPmbpMPGXIayLzrJ3h++oyUgdCbPTrGSnZpUBlTLojPqP1srGlbPHhcjGIU7UAfNizMudIP3pHeUm7KYaQMaBYdaPV3bV3BP0NOeH0+uv3IWwgZ8AKj4wZLHWbPUKDgtJkDXQDwZGBKbzK7ro/PZQuXyGxzuvBhBWb6+uQsz9Yl1Y0gsC2bDBa4vackghtyCOTzVSMlQ8ONsZpTt1Hmj2M/SunXqEPfG6n0meckqOXHRnAXS9eety8BR6mXI0HegG0GS6CgtGBJaCztGZeWebdKJhGLa9HHTxkmfpppnRsPXbwwdQ/aUB4z8Qb9TE+NdWqOZxK1pEzItMYviUyt2Np1mAfeQkgYDEwNkN7ePOHnbY8fQzvna0Q37gAuZaap7nljHCvvYiKVM+6BOj//X83RxDTiNLWM74XBZMPzmZcCzR1d5qhxwBhQ5q1Xo0QYOth1qQBmK55BxorSOAPLUYEGKXrK3dP2fpWe1UMFmKHM2haAnue1EvAywPImLTs2hAJtGujWcJe0I3MzA0dDzkEdpXlcn03BGfJacYSs0JicKu1ZTBMg4eshVh8QM53ZrCSlsdNm6jSMUx12tXOh3jQYg+z+nQa+LJSpu2wilIrT4ArzjI4+RWIx/sZcQ5F5RJx1xNTQCOkUaNzCgOSWYKa3rYkvJZAV60CfKF83NlHuA5n1bozcD5hkDQ6IcO/Oz/rRgXubK44Hs8US8AVqqW1k72sfEuv6PPKk64IiZPTWKC5MtgHzOLTmkXBdz
 6OM6YwDP
 KpwI8he0bUbt8gKy38h2d0/wJyY8bad5+AM6rUpkcroxu3xeTa/aR6tDSbjsgM2eZeCe5t3yi/etCuIZ32mFbrwd9Y1SK0JWd0Io3XpBkgTZ51m0Uif8mVXHHDg9/VktB+OCEgrYtKt/L1E9wbjUCM5bw45Zvl1igavy1NyRNWJjY65h1UA5j2qLX/i9XxDiUPBfRwsfAgkt/VY6DibySNTIUDLUPRCbFkmmka2QTBsx5Blz4Ifn0gjzfI+3c1SzQGg2xWptYaCowCCT0ZsBB0jiSDoMWCQekUWZPddVQA5eQkKgehNlFsf0DJDUk4EmaoXp/IcpSEUp3N0GeilbeADzpUgOFxN/S0iYSxu7i5lhBjHhsTeFpk8rDwWs8f/kW4BYhmo73TkYW2CVPnX5WasZkico+ffoLPFJsSsLuNv9Pk4e2LFeWLlIMybnxGKTvYGuspup5nYuZ6FbZvG86KTDkrZrJ19xMGygA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootmem gigantic HugeTLB pages used to be validated again during
gather_bootmem_prealloc_node() and any cross-zone pages were discarded
there.

That validation is no longer needed. Cross-zone bootmem gigantic pages
are now detected during allocation and freed before they reach the later
bootmem gathering path, so the remaining pages are already zone-valid.

Remove the obsolete cross-zone validation, invalid-page freeing, and the
associated discarded-page accounting.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  3 --
 mm/hugetlb.c            | 70 -----------------------------------------
 2 files changed, 73 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 09f28dd773b7..f68a390d43bd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -678,9 +678,6 @@ struct hstate {
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 #define HUGE_BOOTMEM_CMA		0x0004
 
-struct huge_bootmem_page;
-bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 218fb1ca45f4..47c3d6d11c58 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -58,7 +58,6 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
-static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3221,57 +3220,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	}
 }
 
-bool __init hugetlb_bootmem_page_zones_valid(int nid,
-					     struct huge_bootmem_page *m)
-{
-	unsigned long start_pfn;
-	bool valid;
-
-	if (m->flags & HUGE_BOOTMEM_ZONES_VALID) {
-		/*
-		 * Already validated, skip check.
-		 */
-		return true;
-	}
-
-	if (hugetlb_bootmem_page_earlycma(m)) {
-		valid = cma_validate_zones(m->cma);
-		goto out;
-	}
-
-	start_pfn = virt_to_phys(m) >> PAGE_SHIFT;
-
-	valid = !pfn_range_intersects_zones(nid, start_pfn,
-			pages_per_huge_page(m->hstate));
-out:
-	if (!valid)
-		hstate_boot_nrinvalid[hstate_index(m->hstate)]++;
-
-	return valid;
-}
-
-/*
- * Free a bootmem page that was found to be invalid (intersecting with
- * multiple zones).
- *
- * Since it intersects with multiple zones, we can't just do a free
- * operation on all pages at once, but instead have to walk all
- * pages, freeing them one by one.
- */
-static void __init hugetlb_bootmem_free_invalid_page(int nid, struct page *page,
-					     struct hstate *h)
-{
-	unsigned long npages = pages_per_huge_page(h);
-	unsigned long pfn;
-
-	while (npages--) {
-		pfn = page_to_pfn(page);
-		__init_page_from_nid(pfn, nid);
-		free_reserved_page(page);
-		page++;
-	}
-}
-
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
@@ -3287,17 +3235,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 
 		h = m->hstate;
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Can't use this page. Initialize the
-			 * page structures if that hasn't already
-			 * been done, and give them to the page
-			 * allocator.
-			 */
-			hugetlb_bootmem_free_invalid_page(nid, page, h);
-			continue;
-		}
-
 		/*
 		 * It is possible to have multiple huge page sizes (hstates)
 		 * in this list.  If so, process each size separately.
@@ -3692,20 +3629,13 @@ static void __init hugetlb_init_hstates(void)
 static void __init report_hugepages(void)
 {
 	struct hstate *h;
-	unsigned long nrinvalid;
 
 	for_each_hstate(h) {
 		char buf[32];
 
-		nrinvalid = hstate_boot_nrinvalid[hstate_index(h)];
-		h->max_huge_pages -= nrinvalid;
-
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
-		if (nrinvalid)
-			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
-					buf, nrinvalid, str_plural(nrinvalid));
 		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
-- 
2.54.0


