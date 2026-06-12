Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B08CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C8A6B00B5; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9239D6B00B7; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839ED6B00B8; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 731F86B00B5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A8F01659FA
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:40 +0000 (UTC)
X-FDA: 84869909040.19.294C04D
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 255231C0007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="K9pgOAH/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HtmZnZAkf01rz+eJDlHmM06i2kCJlpB00/bCPPffXw=;
	b=nkTpq17HBrJEOOVRdWkRaE0oJQFYATwJrWxaKf2Pqurbmi8w4BHxAe8Wybs15VaFBhG4V0
	O9xWGeEvdRCJ5aHApCwjQnCSfNg/fDztzMhcuWQUX8WC68E2eWg6djS8MlArw4lud1+8Cl
	4l8Xia6TADRSraJRc3oQrLAUWu0Yh9c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="K9pgOAH/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236838;
	b=t1XOP+dYsqV3efA32gV/AdERVc2piy946WUe4CMlNMvyYikXFXz64EJ6HVUKUQRzqCu9jZ
	F6erTezJgM4G69P1bVKAI2HP7XKpwwMLKD0t2iUjjwLTxPBmWI5vxGGjbNSIYmOMbl0ztv
	uZ7Ytu//2RrT6KOPKRO3Pv5JSx5FIV4=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84230ab8857so295577b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236837; x=1781841637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2HtmZnZAkf01rz+eJDlHmM06i2kCJlpB00/bCPPffXw=;
        b=K9pgOAH/zbThFOs7Ycso6Ymzxo/aY1YYj+8BYzgliH6ltYgqjUAinuzcIXIwIXX1yu
         I0Ft4sREl2Dnlr78GjsN9gRQmtZ1hLWA024Ba9wHOLRvJoUhR0+K3RsbFBwLje457F/+
         EDCw8q17DBVQh8ncQz3xaLbY5htivl7wQeXK76XJwdSZ1Xpx+/lukrlI4yJXoEAUFJfk
         ymYXU7igKr545oxyMbYD5J8DAQjOV00sCaT8qTWkZIYF2oEykT5W/ssgYu4XX1f0ctf5
         5Ir5PkFSyuW8p2kO0yQrdLAdJicitgh255ffx4C50UsvwUF5gcfjiABHxC84o53OqDRn
         m3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236837; x=1781841637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2HtmZnZAkf01rz+eJDlHmM06i2kCJlpB00/bCPPffXw=;
        b=Shci4cPL6T9nQdY/nz3/55RMw3CkqYlC1Y320MU0lQqMoVcxfQI43YaTjQV4yCqJMf
         4GnVWrBZgLV0UX3uMNNmcFyFXwoFpQo+cwQ5U2E7BINqxAUoWPfe8aXP+V0MLE8pVBaS
         7IdX/VjhIy3IlDePdmP8iOMoVohvYuO1xp0ZrmGfUn3xioiqJFIC4aJhU3mn8hrcScUi
         NZPQV2e5OCMY0rBPyVLLeubf+BImoyrB039McVBzg2ZhlUP+iFnnkUFc3txPdW3Khv1R
         TnqobpOjXZB9EvK13MZBP6PY3VZrXNSDTk7bfZeOZ7KDyOfrDDUBSYqQe+2QJHJnDSGq
         gyRg==
X-Forwarded-Encrypted: i=1; AFNElJ8SD8QXRu3zCE/1GxrTPgXzTeBbLTBEoEojLOGydpyngZRo4e3LvICfHZi9FW6ByFaEAT7vOTuL5A==@kvack.org
X-Gm-Message-State: AOJu0Yw0sZZjmEbT83Ub5dQG7CdqwiTWd2vu6KkwsbKgLbTYI4rJhhSN
	MzdzEAUCu702Vi5vk3y9Gsm0gGLlFh5tdGufJM6LwgWEHpsKIqK17uFChBp+G7I5LO0=
X-Gm-Gg: Acq92OH1cUggSDhefoQktnf7RBQZueOu4NgXc5FDBofAY5lyX82J22aaDzPctz4lRMR
	APdE0XBypydSZRuNlBeE06R7IIKPq4uAIKphEsVqSGcZ2FR4cBRAREMKXdo1/ir2IUnzHecZ1N/
	pgtWb217mIyEXlbmrPnCJUEElyWOpvKmp6nqqSW+iYAbOz/yHNun74CWHjexwlYEN3x3lcRaVqP
	VDzurZiWXWCLQfZusfjCthjzdtDtsHHrfmiu8jGHKAtDdtBmVI8G23X4ZhwqrfhbQ0MSSaKec06
	IVi+dfs0mK778Ygr8jNAAbIk5CV0dLZoufDTkFabxtI0r6UcE6uhVRVLrPp+tnGxCM78F3Z/9yL
	xasqVLmz7018cACZw2N+b0xAW3FS2BFTtDw/jSN61/lQebJOGdAKOdwqgIOp4jmu5RYaFkJRtd9
	A26PbSHdQHtsNIXugdHxf9g+V7wDoRBFh2VuGt6TO6mhyx+G1AfjFl7g==
X-Received: by 2002:a05:6a00:4fcf:b0:842:5711:9a2f with SMTP id d2e1a72fcca58-8434cf4f362mr1184453b3a.36.1781236832074;
        Thu, 11 Jun 2026 21:00:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:31 -0700 (PDT)
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
Subject: [PATCH v4 16/19] mm/hugetlb: Remove obsolete bootmem cross-zone checks
Date: Fri, 12 Jun 2026 11:59:00 +0800
Message-ID: <20260612035903.2468601-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5mymt8onw5weh3kpxuapeq8yjejcja5j
X-Rspamd-Queue-Id: 255231C0007
X-HE-Tag: 1781236837-857694
X-HE-Meta: U2FsdGVkX1/1cE2BvvcMIQYGvEJiCo5ui12uYdFYAbEwV5vS7VqwjvYvOE/htPCJq89tpqBlzMdASshXgAjUo14HnIGASCY5ma9l5fwzhysYsK4ppBgR51fSCdozQwChhmIdKD6L4wx5Pdot4LzHpHKkH1IMRfGZ4YBbt9xUbMwzoAGxUfgPdBszoKxsKs1FjMmQkoRmd4FxFHnG/ZUYljqoGRx/DVxdjjUqmfiLVcwo+bUXpytmrxMPGQBhOqhCF2k+ZQDmeiLMJzXIq3dqYs576iPbUY73dofCmj0vr1uNNgcRld68dPRUM6Yw9bjmilXR3sYUA5Bw5Xd5atZJBIBhgRE7zIJhLi7zxQxZv771RoBYHfT1CuWZDV8HVFi+UfmMZopm1EzrADjd2jCQaUKGNfj4T6v2zvlR2pqnjlta+cAXRN+Hbei53vzY7RnDOE3b0u4c+z6cy4t3ZNw4e6Uqua1ooOc6NeTruqy8xdQqix/i8gRC5CCtXkqCXgsAA36UmmoZWGon+WmxlGGFTy4pX5VGU4KD+UMGtvtIelJDEV7b4CNHn+PVhpIQeUnd+1PqaNOGLxir5bjY5ABzIqwtjGSbdIlRB6yCKPFcV/BrdBdFnYcunTVpQaAPjILjjTwmUj8NIBxWz/tYvYpv3/xlSJEQmAPh7Dz6wzoIpJ20+5pergMUZsJ8TfQ4B0qwZ7dvH31Ghr/OlEOCqcmHrZ9f68N6vz1rkkDNNyjv/GDNDFWvsaTHiBbV762wne1cTX93dy+IuK817oqgddzOE2POyoWeg0CPEH33IUtSudPVdq8u8uIryclnvdXGOpdPHVAHNVsWv3QlmckfrReQhEmaR6am+4e1KOb9TYuV+F17uj0WVLay4IFGTT23hG+NPejz/gy0SQfYi3PJTTPeH9oefCTmuFutHFgKMVX99EEXGJLWk8Xn9KRQ1C2DDBmSDqkgoIkV7zJ5AccvO8+
 AN8s1LHY
 3IivNxCnQy6nLvNp2jNGxBmJAud/djOi0JxWGYk5gpC64YHE9rjYdDBDde9B4e8l76LaD/EPNFxs05oohXMXJTGpCe8tqLX1Ec/+8UMh/104yoFx9U1XV5g5M86W9U4e31kR7YJPbesnqNHQ4sZv9XS5JsZaWssIWub8s9Ep0aiAGyvSVtuINNZKVMkrtmRbJ5nbzast6MRAkeBkBv1JK53QvDqJ4oed7+71yBeJK6Sh/ZZb6t4qf54QmeUVTS+bBEGmPpXmydOryV47p4mi+1IVzHi3mS4W+LOGescl8Me974E1Y6KpdPxC9zHMA/yvmdOhlJP68Lcv7m/puEN78xqnDH3ob7pmCJXPFvsx72887cSJKJ4Hdt605WRYZDxIq9DwsYBRAwGygd3B650e7XZfEttopm77lt8HH
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

---
v3->v4:
- Collect Acked-by from Mike Rapoport
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


