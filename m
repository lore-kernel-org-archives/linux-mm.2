Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1599F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316296B00D8; Sun,  5 Apr 2026 08:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6186B00DA; Sun,  5 Apr 2026 08:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC696B00DB; Sun,  5 Apr 2026 08:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4696B00D8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C609513BFAE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:18 +0000 (UTC)
X-FDA: 84624502956.22.581916C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA9821C000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bRLXYute;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhCvzWzEYwqtXTRdhJr7F88/ilDc9KP9wceAmsw7dyk=;
	b=Sg8y3t8kixbvwBl+iDy/IHLGus6H4W13NxlkkDaqBC4cCG8fB+5IitYb3DUn2w+9s0NDD+
	4/hyx593nyTdgenWcnvd6JAbhNk7FdX/SX58/aaWWPEY8gHtps5O6+Zl8O9UwCeQMXJL0y
	ZVZKaCzrHnKvU7c+qivGcXzBtDf2J2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393837; a=rsa-sha256;
	cv=none;
	b=mQNSiSQt8vfWFIRaygEDubwFNtGfmFggERIpjnTpAOxHCsXC8AM0CzyGTlJ1rf/RT6/N33
	2c8vFa6U1jeiIIGK5j2mL9u3/IwovIHMPVtGX5NjpP+1+J2LS85NnCBS9706MsvEQNiuga
	yrZ0XWlMMdUuf4jQYm7o3W6ttQKCTxs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bRLXYute;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35d90833cacso1832389a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393836; x=1775998636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhCvzWzEYwqtXTRdhJr7F88/ilDc9KP9wceAmsw7dyk=;
        b=bRLXYutefSU4FPaLChfvV4Zl5y9edSKEN66yaZQ9UQ4HifMNVnP6AZFJzBUvIyUolH
         yPZU3o2bHrnX6CMVYYGHLwGCn2Wgif/NnaWX40bIN97Ri/nUXbSciHTWZcnmY5n13t85
         98Jg8jOKSROO4nWzt8UbHkUXiCNDIr9yJW9Xd5b+Ucls38xQZdqVGgBbTlquunubp+pU
         mOFVmLIr8K4UwYDz9OUf8zSz2VQiZ4KIbVH3Tmt3DXYzOYKwgqdn+oOdPgCWJrywFnFC
         EUHqp+VlP295QWjc20bnhwL3WDXO6gHyjKjGFRx0qZpe6iHrM3nMwS7jzPDv1tN+mBK4
         lskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393836; x=1775998636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dhCvzWzEYwqtXTRdhJr7F88/ilDc9KP9wceAmsw7dyk=;
        b=s/EnSgkZ4VZLZ9xSbdOwLNJ3BhksdQKNxtKuf8qGIwKhM1atHdEJ94VLdd9jzLDs91
         wfCJFqGUTMZzvTTbXCVmA/h/3PB2g+u6W0xuPVJ+HEkxx76SPykj5P8vTIjsAM5/qA4q
         F2HvN7spwAf1sudDFbiHbZ3Kq/6aZlG5/aG2wcYjBWS/LhdQhAKtYedSD7jdJwRxYNQd
         c4Pc0k0/oETEF2MHbWF7roVCukqRy6ZgWXNJ8GGxLohA1OzGDaxBdkRw86O6uf5/A4oZ
         Nzqdi0/bQ+rL7lEEiLucwBofUDVEMGgfpKOdPYUv026mAIMKSoJKY1c+yJVhxuXzFJhB
         3dSg==
X-Forwarded-Encrypted: i=1; AJvYcCWG4uTOUkCsSSaFDUMPYUDWSPGAosD6Toj2zj55sDdDr26tpeE9HVR5GmEWCd+38SMpIWcEIKD/MA==@kvack.org
X-Gm-Message-State: AOJu0Yxozo+Gv/VpBnk50rgOJfRm6ocbz32kd8QMFk4ibUXqA21YW733
	mQxQQbnO2+T6cbumeQgHwxsKD7X7Oouu6yRxJtkrDJZ7duG+EIl8HZYIZCJm/rjFmQDZ6f8hyYo
	FsSaT
X-Gm-Gg: AeBDieuKr/5/7tFqRU4y4sFJrQUvuUAbQQ/VKDTCbMXVm3GBYkM0TDRVB0RlAoWXVTG
	ysGpMmf8KUcQ2UDVWtCdZfLk2Y6+OqkT4+3N1bbdOTFqnD2R/m6zM4ftSsm3PEFPpIMwZ3vW/I4
	/iONmmdps+NLMPFah378lN8PR4V7m3Bo4nWjXBEgMU9D4DrVO3tLrrPGlSrJK8doYRynNyytR6y
	yuSlQAq0OsniSeTrjhFyvinoOfvEPeR66HTrs+I3/jnotw4OmVzpq1ex+Euvt+V6XDfUh7lcxxj
	/E2szywwR9hvF5N3e3ngs7WFyYP7HjsLbEYrE6+9zvXNgMYm4AiiN4pAwFKyqfvK1BbOj5r60t5
	xzUQDuIxRqsBLwJ/kut5Nfc2St8Jxv4DEv+t1lgS3TZ7uEtdyaJqZ779bV/DRFZiNQD4UEJ/aBA
	K9yG9/atjcbMIWSwjFmXu+dczWhkRRWObt8cxlOimOZlI=
X-Received: by 2002:a17:90b:3f4d:b0:35d:9482:2233 with SMTP id 98e67ed59e1d1-35de69a66e1mr8904624a91.24.1775393835707;
        Sun, 05 Apr 2026 05:57:15 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:15 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 36/49] powerpc/mm: use generic vmemmap_shared_tail_page() in compound vmemmap
Date: Sun,  5 Apr 2026 20:52:27 +0800
Message-Id: <20260405125240.2558577-37-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA9821C000C
X-Stat-Signature: 567du5yamwk4q9agnysj8eicohib6ouq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775393836-865135
X-HE-Meta: U2FsdGVkX19j5gXJyQl76AORpIM47F/oM9o0Swr5u7wpKh86lOfrPhc2N2yXRS7xJCkaZnMfGy4VgEOJcoII0de1TdeY4jlpMVcvcYBT+RwMXxis5BQThjOwfAxmkNZK5Iqt34pKmzRt4tBfi37Q0Q5a37GDCsd5Sn2QO+L9yU7qP/4axFcZvv+4iryeBXT8S58vZhbPsS8LSsi+ufZ/NZc7VOi7HB3fmakqOnWRHZvskW2D2pMGyJqJY+y9tZNn8+oFBb6feQGAfTa0OoQtv2otjBP5PVhq+9C2K+sObAPP7Fi8nN9jAEvaE5XM8DhzwUUczMTXH5sMmhtTrpYns/hGa1q55sVc7vIxEBbf/Ah2ChcikitrRWYLCx9/fc939LxWB7HWO8mXVB59qKv23o62o38943v10+IQOsiY0oCPW31zRKpph3uaY4riIb9IvsGsPJ6i2iMgOu5dtS3g9u0D7QFODv+KKoFJcVh6DUdQ/RcvQNL7coMX0GSjM5MlQTengtd9Z0lSWapnhIPjM2cSVL/7oyXH2Mshh2xtRc2qGi61xlkqmBX6c7nolhHkw1Zsy9dGYof/DBEvqXWVb8ediymyXfbfMV3LVtoCrwZKjW83A5nwWGQToWE1e0alQrAT9Ko9FyrkZrIPAi4N1B0l2FqXhPbfA0ZOVSnw9KW+UjiR2EqRPaZdFfrOqvyRnXv75tWZ797yBrPqXe2neBtrx1JD3EXoLP+eOv1vGnbEm9RCAQVQPkT1/J98Hm6p0mZM26y51JuI0+EFURWemO0CmCqwWqeqCK2vDLM7++W6A/rWVHivCRpJJus8/a5U7A9LvfRjDVBb4Uqa/j0ys/UyqXSy1gkEKFsuM3+uuMcbYDFdzE8mnK4hUBqdNgFziS+k67+KP0EUzINUW92C/t4aQbLCXRE/hGZHbDheBgXN90MUq6ck8JtMEm5QbWVtxgyVkeOn3N1qbEzLoNa
 KZ8962i5
 fAKws2vqvv5dFTS3oS8T/zBYx7KyYt1mIoGsXojo7VGTSt4tsqpqZ067XtjGD7rL8WIM1W7t2pXQC/tPfS4+NxfoB+uTKTQ6cQxEbb48SBpmaDCzPLhDUOIIOCDnJM1my7d7eHkykQ1XK39r2TgPTp7bkrds0bAK1xOUVola6amewrs0lAGFEsa7yFhLXxkjyHkzrTUAdDkXKH39lrFTZY5CDbmj7m58odh67qpiNBY3mIAj/SXq9WgMfccaLcapeTC8VKXl/szDunKHyA0VJCFeGUrnzr9XEiYrskmM+T4vMKE7i/suFrROBYFvR5YF30mSGKoidruIEFoC9WjUSlM6VK4dZHhMooS/oBBDOfOFBS3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ultimate goal is to unify the vmemmap optimization logic for both
DAX and HugeTLB. To achieve this, all platforms need to align with the
standard HugeTLB approach of using vmemmap_shared_tail_page() for tail
page mappings.

This patch updates PowerPC to utilize vmemmap_shared_tail_page() to
retrieve the pre-allocated and initialized shared tail page, instead of
dynamically looking up and constructing the tail page mapping via
vmemmap_compound_tail_page().

As a byproduct of this alignment, it greatly simplifies the vmemmap
compound page mapping logic in radix_pgtable by removing
vmemmap_compound_tail_page() entirely.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 81 +++---------------------
 1 file changed, 9 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ad44883b1030..5ce3deb464d5 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1256,59 +1256,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
@@ -1327,6 +1274,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	const struct mem_section *ms = __pfn_to_section(start_pfn);
+	struct page *tail_page;
+
+	tail_page = vmemmap_shared_tail_page(section_order(ms),
+					     &NODE_DATA(node)->node_zones[section_zone(ms)]);
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1358,9 +1312,8 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1L << section_order(ms);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1386,24 +1339,8 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				addr_pfn += 1;
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-- 
2.20.1


