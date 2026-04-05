Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD02F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F2B6B00B6; Sun,  5 Apr 2026 08:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6B26B00B8; Sun,  5 Apr 2026 08:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC1A6B00B9; Sun,  5 Apr 2026 08:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324E36B00B6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3DC9E22BB
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:30 +0000 (UTC)
X-FDA: 84624498420.29.3D1C88D
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26104C0002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a4VO73ZJ;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JrFioPtriOOEM2n2rZ0j26nDzRll/vGxWzMg0geq/4=;
	b=LGcic4SaIz6xDp6yKrbGbC8TpBAck1P/9/SqHHPAsl4lcID4kUkENA9wK10lWDHvkoxbLX
	G60YfgSMaecPFplhY9GCGKtjVXXPTzzcKrbNyYoR987KXbWkfNpXPjglLDPqOyy+fEHvPE
	quzHHtkkacBK97UaiKi2OvDwfFgOMA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393729; a=rsa-sha256;
	cv=none;
	b=aBDErxOZ8zFgToRjcE4aguO6a51Z0pi2CWzaxwijS1A06po0qYGmLimsNBB+Hczttb44Pj
	0MHgDZa1iIvVh+f8SEcJG62py5v0CM5xgPTkbQJQ0Y7HOtwOXm+lphLRFmPQjiNucsc3je
	hxVeQlJxe60cJY19iXdYOlXhmldltsA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a4VO73ZJ;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so2695455a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393728; x=1775998528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JrFioPtriOOEM2n2rZ0j26nDzRll/vGxWzMg0geq/4=;
        b=a4VO73ZJXC10FR7hle5s7+bSmNkgipn+cdWb5r6Vue4ppK2PgtyVyht1ArneVsICp3
         o92QfZGGmGCrFLvyZBYqE8lAE5QmMWxOsJrQbXr9hzIdHfcdIIxa1SL6JRUWO46C0cHJ
         iVNGgeuNRtrRyrniDfqLRHXlr0vklVU0cBTtvRmDxLccDcfg3qNEmrOkbIgQPsOMERfR
         /wL+B3ID72EdVrEi/qxTwrosr/fJm7uPUglGglqdvsF4/8UsymUM90A30ZFmIpNoU+Fl
         xXBon6smMtSfdw5I9HK3Ko1P2pxJXJkhAkM2CfIi5Z5yVT3hyEsbmifUqaKbJj0qM/uZ
         goAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393728; x=1775998528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2JrFioPtriOOEM2n2rZ0j26nDzRll/vGxWzMg0geq/4=;
        b=GDgRmgu75Lk/qZ57+yxaSkxXwCpo+vkedmLBhP2bVWUIbtZ4+FZEN84T3HXgt4BSrW
         ENQFfQ47uKTkkPUyqMZaBeeLQdY0RGSPEMP0tD2A2RtrZ6AwAh/Hv+EH8dOCZcAs5Afn
         lr52pq2kkty1xhyMC9D9tuVMHE9YjjHzw2mVl91IR8KQDtTKFn7N5qJyr4aBk6Ncj6ae
         3k5/s9uIhqku67xq/rqusRohuZmIq4rYcfnP2iLEPjLLfgK8q+FaTKKFwdjerkMPZZJD
         kd6sHlAPyjvrOIKoFh5rfBfyNl0csne01aXImE3ZVu0wM867QAol+DEtqdv8lYi+OPz/
         +Slg==
X-Forwarded-Encrypted: i=1; AJvYcCW2cgk9/TQ+BvGxlSbBbXEVMfox5hf8VzDWjwKVO375b7On+Z+vnlMgdaBGbI7qk7XcVNjopJn9aw==@kvack.org
X-Gm-Message-State: AOJu0Ywf90wKUZT77ACVyjRq3rlZpG75Xx5oaDXtqU8lxHj5M78T3yjw
	igY1l6aNGOhnCrttFTxWAwqyC92oY7B2u4hidzKgFLSJUrB2hWv8022ljGGEDQwDKfQdljPZC/x
	dsYr8
X-Gm-Gg: AeBDievqGue4ltT7vNM1/M7xzHXUNhlK2a0fklWGcC8PSouwwO/GkqPPVQm6R5yvbe+
	TmQIXi90SEUXvipM9uTnjvqCA7E/pqHsBEct11PH+e6JEvjw1qBdr8GO+g5HBmQm9iW4BwgC/qb
	hpdnZloXWA4kRglISYxWpOCQEEXhGvyqxRCcrNVHxtYViMGYZqHLYFVNoNkpNJDzrRjil4wyMt4
	F5tIzCpusDHiTZv7FS5URH86fE8lDB74HKO7RKvmFMxz6JklT/J2PZOiJ1eBHuH+kLvtSBdCED3
	NdrX1EhEqz9QGgUG6nYnU9bAFneoy8JxgUqnyQkmNH21RIpJEaxWQx2nqgjwDoEdB0+h/8pfz4C
	Ng9Zet2uOFsA92FHtsuzVjzgGpd9WCf409otUkZP1S7GmI1a0Yx5Y/B7qC6fBhxtrY7Ih5v3mhM
	dicCHEG8dvlbzqEOWZoYzKDCsYMuKgvKsi2nmlNsTWIh4=
X-Received: by 2002:a17:90b:134f:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-35de691a6bamr8984676a91.23.1775393727846;
        Sun, 05 Apr 2026 05:55:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:27 -0700 (PDT)
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
Subject: [PATCH 19/49] mm/sparse-vmemmap: remove the VMEMMAP_POPULATE_PAGEREF flag
Date: Sun,  5 Apr 2026 20:52:10 +0800
Message-Id: <20260405125240.2558577-20-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26104C0002
X-Stat-Signature: fr79a9671i5cd4kqjpunyaixt9jo4qkh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775393728-510476
X-HE-Meta: U2FsdGVkX1+gIoQTwEo+LxHICUTk8qxCU0SXWI58K0oq4MIQV+oK9aKFpcSndOVVSfRoAG5Vy81pehQNLiHZqO+d8KAEDs+d69U6wNVYIMXQWUEalzov2q4rWXU7/cQyeMFi9/DPm0h9BP2NlrbJWMY2Uma2l1TgReHUEvv2iByNN9Bj1QOb9PGGA+UF/4HD5UMMcD3FDS2dbnzcEDc6Vtfe0mLaT5cxU9TNBFaLM6hrqe0LHX1tvsc6Iiaagx5OAAAP699giVEHIo9N/6hr5xSXXTpUWAE+fRj/x/qWcXoTqZzChVRlkgIfLLKkuPNHWhEeutQzDgMRiTQPcURx0IDwLFL8Hk3AIX1rEWGYFTzb2x7SoAN/9R2aL0PDiblNUY2Pg4oD/hFiGv+ChZgMb9Rs6NMh+Bh+fFw4M2ZQ/PCPRzNdq0QBwUl6p8l4ifp4l1n9ehHbPxLqWLk9S+RCV73MIyQB3Q4GUoZ93ychMhF0YNw+JKmwTlhqMPuaYvBV0pBUIhYuHPcOJmpfBJHVj5sc2+CKbSYNLa++W3/KS8fLWNZxkPnynVtc0jSz3O/B9dFMIxuLAbpP1CzGDh7PJJ2wMNkvkVOJMprMgA6ie1yEOAQ/xn1Lg40qwtFDdXwQDYuiVW3egh7sXcyFtSxVSKNCVmp0UOFGGrPCD9mB+kHqOCoWbWMDW94wV+bWBgvSa79B+SX+cwDw5JsPOoRLoCSof+XAOaFA2P+S0txjFcNoIdY8oQ+8OL09Bc77iVOVUJclKMACk7/NPgFFqnfr2HhYSqIzxTn50GF8pvjN6FXO3M2MGCABxq6wOe1IoPElIpjN3FTkJHINVb8wpJJ6VSthfbOwKBhbUEW2M8XsRVmf6XYibbHUvmPNegyRpGk9UZsN4HlSavFFLxKb44DLBOxAD+GJELfHfs4PUuxqisAPkcazo2T4m3G7/6iLifhZh/aI01PsESarBPvzXey
 2tk6QXgz
 D/hCgjvdC0JSNFL238SUm85q8anxLQdmlwyg1eNJXQxHKFoDsZoShgSfku4Y5cqDlEzYk5o+LMB7Ba4+gdSP8T4YGiXP2nKVhBJ0q4uGFnImSNzFFIX2V2SVjtf959N1ZpwewVfPtibiNSdirgTE9piO3ewEA0nz1Ot24SX2ZiItllqP1AmTyCr1RTmTTp3h+4ISalUAiS+e7+1A731xiCGoWdEFLtkB1evSG1SecFFI97s13ayzamMY3bl0o2qyWU9cvl+YRF3lZXOYhniea1QPOobQ9Kt/Lbvx+eWIugMuIWDcR99wEIJwMxtPtS+bv+ef1/ygvxSXzWsit8FaFqxYE5/5TrCZGlLisj0wH30ygE8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMEMMAP_POPULATE_PAGEREF flag is only used to ensure that we call
get_page() when slab is available, as mentioned in the comment:
"and through vmemmap_populate_compound_pages() when slab is available".

Since we can check slab_is_available() directly, the flag and the
associated argument passing can be removed to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 26cb55c12a83..3fdb6808e8ab 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -33,13 +33,6 @@
 #include <asm/tlbflush.h>
 
 #include "hugetlb_vmemmap.h"
-
-/*
- * Flags for vmemmap_populate_range and friends.
- */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
-
 #include "internal.h"
 
 /*
@@ -152,8 +145,8 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+					      struct vmem_altmap *altmap,
+					      unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(ptep_get(pte))) {
@@ -175,7 +168,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (slab_is_available())
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -248,8 +241,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -269,7 +261,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -280,15 +272,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
 					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn,
-					    unsigned long flags)
+					    unsigned long ptpfn)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn, flags);
+					       ptpfn);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -306,7 +297,7 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 {
 	if (vmemmap_can_optimize(altmap, pgmap))
 		return vmemmap_populate_compound_pages(start, end, node, pgmap);
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -382,7 +373,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 		return -ENOMEM;
 
 	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(maddr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -390,8 +381,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 	/*
 	 * Reuse the last page struct page mapped above for the rest.
 	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-				      page_to_pfn(tail), 0);
+	return vmemmap_populate_range(maddr, end, node, NULL, page_to_pfn(tail));
 }
 #endif
 
@@ -518,8 +508,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)));
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -527,13 +516,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
@@ -543,8 +532,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)));
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.20.1


