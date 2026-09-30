Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EBACA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F056B00AA; Wed, 30 Sep 2026 10:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247536B00AB; Wed, 30 Sep 2026 10:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D046B00AC; Wed, 30 Sep 2026 10:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFFC96B00AA
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77EB4A743C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:51 +0000 (UTC)
X-FDA: 85270609662.20.10B9704
Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA2CD140009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eUT0Q3Ls;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xa6t5Ld51NH0IkEH0Cbkiyr6aGf7JfNQsVmQ3uezLic=;
	b=WHcmeoCT/EvKSM6zK7mtYVhJa95fOPujN7OxZVOZvliU0AcWTBQRDOvcjIOYrCATB07GKE
	ZgpNF6+tiqTvGDcOz/VwtVg5xHppQMDnfGYA6p/LxlY0PIAna+Hoa1Vf7lm44eCbz/TDYk
	IhcmzP39PRZNlvRbhU/EczCKHGfPecM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eUT0Q3Ls;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777329;
	b=KdvIu8efIs9VcJmYQUL9nbc+uAQ7dVAhrOgu6Ehi+sxYuV/ZxQTf5LXPUb8J5fQ1GWsTO2
	YzQLMB2tIrk6wroX7hktAK2xuWozC3H0yJ6/sDMkvkonQjjey1QfKKt0LS+nKs7fmxY1J5
	s7G/HXcaW8dWsDvsq0woHLhIeA0aboU=
Received: by mail-pj2-f38.google.com with SMTP id 98e67ed59e1d1-3a4bb1ed012so929015a91.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777328; x=1791382128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xa6t5Ld51NH0IkEH0Cbkiyr6aGf7JfNQsVmQ3uezLic=;
        b=eUT0Q3LsJhAK2/bEURFs7JpW2X43zHdkj5XOTTLRP4KopXqZoh4fdvEurz9Th0UssV
         X6l4Dhff9a2f+W4gqAZFeR5n9gKnkyvC/Q01fIBNK6v+LGchOVAGvK2mPwed81Wn7DZA
         oaLFSkCiUvWPRhKcnMC3WOJCOJLP73SF3Jc/j84Eoh39VZdntDpVf6923GGMGM++TRPc
         MrnvvHrhpOdqRRVtOlCzdBCnqbJLm28H37/2XPeynCJLo7beuiadmBJuCWEPVnP6+dob
         DX5lN0y8aQ3h7tRTdxE71fo+LZsa0bGXkcUjaUALvWxVlx274PLNfkeSrypmWzUyRABK
         AG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777328; x=1791382128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xa6t5Ld51NH0IkEH0Cbkiyr6aGf7JfNQsVmQ3uezLic=;
        b=b6yeOb3Hbro4zgZxJArHslCqSYspeb/G9X4Ft6FR05Rb5nGBwee97T+HF2RzUSacPn
         gm0vfYUtXbtIeMqutNXy5clD1bHdgz/qwmzeQxLVh3c7cB7BnKYqRCbtfK83hzrpixH6
         VPX5c4Avyz6bg/DxSqn1nT6KZehEel1N/9enRfjU0Wq/2Fi3DUru34JT+OpLLkdZpp6L
         HDRN6DMRbn4gIQeQdsmK66Y5XCTFayEtnD3aZb4N+/jmYgwLxgvqahdBUIYqPFqNo1Im
         qMNkb4WeB2Xnf+h7zZNERpsDfWo7NuTSJoPQp/WR4eiNbWHyKbvNBfDn7zeQZKjX6IGR
         fx9Q==
X-Gm-Message-State: AFq9FYIWs7uP1sMZfobbhtt4ODVv4/kWnCLf13+IdIeQ7AWyLvxBL/e4
	RGbpfFPoiH7VlBcY7EQcJFPaurosMJmDd7FdZj3o1vdu6S4MmjAv32zOMEnTZIG/9kw=
X-Gm-Gg: AYBFou0sWE+TbtIqnw6G959a9oCbhhBbrtfPbA/lfdqCb7xk99hQC6Znte8HPYTY+bt
	PZ4DySmZ5koFaQ389Op59d4EFWprM3YNRYSXbK/1BL18+UYCrS/iDaIRJnePYF8iiDHZzoivwJV
	yHOQ5SagtYndeMmmKeWqTF3LVwAadD/h6sPRmr5n60qzBj8X3mwD0+hsHH/UH+BF6fOHtclgoGQ
	MVE/KVMGzvVnMwvuPFT9bamgfeiOtLReVFtS0ntXthLAPENn9Xtta4+fJiskIa2VGyjMAbnl3g/
	JcfANLP6z8wPeXp97tPKmUJeLwy/gW09QmmNT2s9QSjFxY1YIdIyRnv6OM/lPmiIjiIFj3fNiMC
	ucnSuDS3kM2aWfkczsWm8cvJ6bSwVorJIsDVskqNlUSoJGcGzUgG9FY67lyDekhV40520c8flbR
	yJ8tseeR9dEZeAJmSQ/ri9G20OmI1v5KGeLHsZvZEV6Ssa67zBZMcouIr1d0WIcGznvymZTyRfM
	5y0F8dRHJwmr0Qh4FfSooKI
X-Received: by 2002:a17:90b:5404:b0:3a0:b959:4479 with SMTP id 98e67ed59e1d1-3a4d18a28a5mr1270065a91.38.1790777328422;
        Wed, 30 Sep 2026 07:08:48 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:47 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 11/12] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Wed, 30 Sep 2026 22:06:26 +0800
Message-ID: <20260930140627.57431-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qmomco6718xun837c4e17dn3epeb5rc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA2CD140009
X-HE-Tag: 1790777329-541604
X-HE-Meta: U2FsdGVkX188i9TvIgYSvCUpKNhDEY+hq9L9HfcSZce6OIg2F+D3z1rHe/t3TAHoMlaw60k1Vg08TCVNynLgm3oKg3P5GI6WkXSlYkJERZPJxZmPjRJWwHKeNEOCzwZQkiKEtq4Z0CwZ4xDdis49HV/J7BLLbZ29IGN+k76cR1e7l92YdvpGZcYFgvOz+nvziHqbLy20kMOxQa+fNhKMIcMA+/W0xI/sdqQRd4hpjnJKdzB7IUXiDS/SvzKooGAtHngcrk5hj8nsyWvEWZ3HkWaGX7nn1GE1I5jSHM5sLpUN+ltgDKtf+nXHqC9mwLAaYWVnaBV2QRVpaxtsIxKD3CMgcrxJl0Yo+a7T2jBaVNbpS294LqIMzNzw50+zLRn5bcxBqAitjhpGbnYrs5+A+Yffgz4d7sKLhPZ3mSoapYDT068XG2sZexWJ02CiC4277svnm7f8XgeEFStqSXV9kDWzKv4ewn6cqVWQkZk/QDqBzoGnlXVuzDM91dge0RP/JJL9e2Z2UEphfD5SBuNoRwoLpNUKia3ewY6pTwsQ7ZP709aPiq6DZeOMgGICaxFnepCxgadyZ2V+VhilYX1d99iS+xFhWTP/123r6wkc/UFmis+o1dWH/OfAawQn/vlGE0tnIytlzzq0PYapk8n2zJ0ObNuwR9QF4UAqS7D+I5nLU3eZZXgGpNLXwqUMxD3ymL0rA904gr89I+IcHLE/tM0T4EHjEojLvLmg1qSIr/6KMCyD8DwYtcNTUMCapUazBX+LdWJlyarLTsEebCUXwbyfX4eKPEvZ3tLaHYGXFt9Ou5UaUyWpv4qEcr84qaN4nD94lK1yMfEI93QHUZ7t/r14WO6ZpTd76+zS1XZDiGz5wuGKDzOLKQCHwsH6vrQZF/A+X/UnaSAr71kFRmkVvt1eiDtAIZcPDIktHPJGJfSG0NHA3fGxmwNz+k3UZyiH2kEWacB0/iCi51OmGu0
 K3UmiCJv
 svXnArBiVfyFgmsEn9iAmEJalGaTOaHeonLOJr8ipynhFEXLAVF20+nDxVBBbuVPYajh5Hhhx+LAqhjjT++lxlBBwxg51yFNEQE+NXY8gLMkxpTIcX4btoQIqeRA1lnYYl6EFGorImGMuTCkHH+ug08dW1JQzOvefzgkzwVP7QdnzOduF5oj6p86b1plJ0dPlvTqWCj5dHA+KrpI7cJPPol/cm7zlWUEervcJPTzVb7FK35fvHOUKzMCY95WWzrFsFo28vvC7bbvJKFsZGYuyKtoYCji3k2A5gJbsDqBaQ1zRcJHTCpa5ywRlyG1/8ApCkEo0UyX7+WFIF8T4vbS1s+DZrnYdzRuf//xEAeR+DaNBwF3NwK6m4/Cck1t7U8x+92RlH58VXT70qE8fBY9/FHMzx4cQKFJXsalm4UlEeccvkaslMCKnDMAhEYUOVShFm7w44SwDBW5XHnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v3:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 4cea94126cf6..4be85e194c78 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
@@ -674,7 +673,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -685,7 +684,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -695,8 +694,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index cc28bb41fdb1..b75921c622ed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -250,8 +250,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
diff --git a/mm/sparse.h b/mm/sparse.h
index a5111087ee3a..530692cdd516 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
-- 
2.54.0


