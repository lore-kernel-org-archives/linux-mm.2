Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207FCC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F296B00A1; Fri, 11 Sep 2026 01:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940116B00A2; Fri, 11 Sep 2026 01:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA4E6B00A3; Fri, 11 Sep 2026 01:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35E816B00A1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 535FB160735
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:21 +0000 (UTC)
X-FDA: 85200290322.08.218DBE7
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90C43C0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MzbwQu5D;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103059;
	b=H1gPsO36GAR+XuDeb+chAX0H1fmZYomAnLxMGXoTIHLaF/gPefs5aaCCHn2vPQSuYpeygr
	IoV9zA955DBVDWSw21TVhHqiExm/hJDDlMPLZSCzcMYEpce+7F8IA7Tg9VMwuedwLdLf5F
	wYpMAOju1hqG82LY8AGlICqlPIc1Gkk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MzbwQu5D;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
	b=Px9Ulnqt5wBKg8PA8hEQMEqhk8JNXUwg51LpbglA2xMY0JewKLE9lgcMQqVRJ4/14A57hR
	Tdk90NXrvwN8KrtB4twsBPNiG6nKi8YQfD0iXWt+uzHxAXqNIVe6yY+42uD3Fj4H5uL3Ow
	KQvqswDymeYZE1ey4qPxx6SPDcsno6Q=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-398b3c37877so480120a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103058; x=1789707858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
        b=MzbwQu5DkeTmnMGwCCh9Dn3AHIR11NcPO5FPL/xJpR61lJwh/kFgu2xTEZ5KI1II7u
         lK0u4i+REKpzAYwmbwqtH7pey14jx/iRipm4V0YJnF/n+1ByrCza7c2mBN1eoZg0JZsd
         0Qgnjq19xXHiwXl0N5y0bZ7yKtxUl9koQ18HZuel0APXncEJ4tayFNXxAoBLSjk9O3k4
         bqHXBI9K7VnVaqiBiUZivhs0aBcUpnBpa80eiETiwA0r37B55qVnewdMUsifzIsMHqxy
         2uoqgVux0GMkM/neMUXIBsFGtMq1e6W4bqMjPSZEW0t0ggkXFL6469p9xxnJ2GvD6noA
         V6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103058; x=1789707858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
        b=U18E77Hl5KvZ7xqXx1IJAPq60k+Fj8YXjbyI9EIAbJVB5GDcwUzlgeVdsbitmG7rm0
         rdfNfX74uWSpqCNEB2+DYLk5WSnOxDL0nKaEWFKaiOB2W63giKc4avYX0/LWQSRgMOC5
         EYSCtry8TPPpHJ8CoBeLCzOKL7y2H1nm5cfBRN7gD8zc5GA/bscLkVBs8q1tazfbNXZX
         h9X6IY0BDFr82D7nVsfWfReUP/ub0nQqfoHXifGYX5NHFEmDmjPsVbP8SVtYbxB9hgtH
         qRsX9NKOHUcoWh/Ap0Fpa8vAoHLgiIA6/G0b8v/58AE+STEmQHVyn1hfdWirRECJ9DTG
         Srkg==
X-Gm-Message-State: AFuF++kUMSIftWoqbzhnX0rkDghFf68gAr9MBgpCcsv8TO6YS0CqGfS3
	RoUpGwz48j4pRVmb8GkqMRyQPoLmpJxn5dApKIJnjEvvVND2KKM+S1JF9Rpthm8cDyM=
X-Gm-Gg: AYBFou1Ndt3Yw8JtO7Zb8OjZDYvqEl0sDfnF33FKskPEtcfZK1pL7FYs0ai+0NBmBlD
	yjyM1qDkTbasnguXBcvX/tHargMP+f2Iqq+GarOFHA3al8wQwFBzxRYW/EuNHx5jwabDIZP2hzW
	K9kc2f7EK4vXuooArI0jIOIUuQkO7iqHlPEaahVnLAn4cZ0zCS2+5wqanmNY7GbL40PRapNXddo
	q9CQwgSshryciEcfRjmGC30nggJOJr2+xtlae+9XjG7B9jlZl/D0YD5tgdLAK7Vq6f3gTgCdRvD
	HmRcv72wNSMAK9Ui4XCF+zR9nE2xiFZ3xiflc7ZXWcDQj1aSvde6j/yX3cjUjRBRvTr1V0IKrpx
	FGQFYz7LvdhbXQLd+Hg/lX/iVtc1iPDv/D8bdgvnX+Rk7tHWIDemQlXhwYgg8+ts568RM+3Msvf
	6ZV9/QQBz7tl7r/XdD2Ta0Cwqo3g5ghK6aD4TTlHiBfzJWvRCd0+kJh8itA/bZpjFb7X2pIsStw
	2avTTcTrF4Axl/YYFicxlhyPWqyctnvQAca
X-Received: by 2002:a17:90b:3ecc:b0:380:540:d499 with SMTP id 98e67ed59e1d1-39d9bc382b7mr3533958a91.6.1789103056004;
        Thu, 10 Sep 2026 22:04:16 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.04.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:04:15 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 10/11] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Fri, 11 Sep 2026 13:02:27 +0800
Message-ID: <20260911050228.58884-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90C43C0004
X-Stat-Signature: y8grmhxorkunp3rmu5hpoxshr18pdtn1
X-Rspam-User: 
X-HE-Tag: 1789103059-904152
X-HE-Meta: U2FsdGVkX18amfRmZnK7ROB9SW57aPHrkcPZG0NybVbbZTkEmFMl0xtPbTQvqYxc3c+UW3Eb6bic7KimIOA1mDI45VQlGAWSY9ApOVk+M7+nWG3nfEO9Suh91awsKdb3ScohnB0ivaJG696VYvg/bex/rTaU5vJjuTVfrQCwoGZsMQD19rQdJDE3djyTyl0GEQ7cBg60U07l3Qekqnzqtvtgv+P4GrHzh5ZEmXcGN9zDYJA7nHPy+xfzwS3BA+f+TK+OFi5PuanWBe2vj8ZMLWrjT2s+046QCIoCastFf1+568pTHkYMwP29LwvbQFskJjmHGUzolw4PVcU5JEeePsNKeNDTO6IpaTcGLrNFCGhyFL2PBbQzc66qOkNt51rFQtuMLiUJOzzo8m7bTt21rVLNYHUvvr6Zzys9k5/zCKPNxbMyN3VqbUmeAKrpazK/2oI+dsKxhEdYKuFlTU7x2F00C4qu5fwfiu84uCftDSX8biBGCfmchg6p+P9HSBcWq9wfXSd+vNlheJzIXTERwerHBhY4R+0qAsZVA+CQ3qeP6o7/PgbWzfVo8gHtN0mewFC4xWiDbd/+FNq14hgNiGhQWeOdtUI8hPIhsftoD65UNZDGVytqiT8CSywcCqBvZI6DwlLmBRaeVN3b7oChwfLA1tDYxRQznRMywI3ktMYsI1UImeXoPZztI3eIpN16155RhGAN3gq+DpS4fAdwblzxCu39GnRY0yUpBxzBzHdU4ymPZ95i9WYaxCIPkB0rB3OCzmPjYujaMnu97dHHWGZB25ZppdKw/oeeykGaIGlfZtFXqONghtT0mkWr4Y3elZqR0fUww0ZcjJ8bI42cc1aDfzSUTlUo+TdSkZ2QOgJhCjDBxUPvUVY609mfyfqXdVKc3P5zogpEXP2ElEaeTUKZENSjGwt67OnhEcrdCmqhmT4Kgs4UFutTK2BnVhDtBrP60ZUmeNTEo7sXU1f
 Brxu864H
 VCCL+9IIRZ/J9xN6hYGbE4r8y35EKsG41PuV+gtUefBBefmfC2msFtarU1fqIkLti44iC7meVvLWKP2rf20PQ9GUj5Bd7q9uCnXCvX21+Z2kpkdzmMn/2sVP4ZAPIQSgyA/OTRiiBfb9deLO1+rXfPSCMnpONTDg/Ruf6Bz84p1hpxC7DYpUkkzXsg+85xUrODFCqXajmggqTqhv9EnntVSSiXFXhBd5HRRnT242HX9H909b5nqYCbYaiaNf+D3BaLQc6p3R/RI7l+ME0mg69HYcsu6dIEFpjxnRpEwFz5lGoT016pmo2SzSCrM1n5v/NB3Kx0eXmWR+0iTItY0n18Be8lcdCpC21jGfeP+Nnzb1gXhA=
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
---
v3:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 39f0cfeefc6a..96506f594924 100644
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
@@ -637,7 +636,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -648,7 +647,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -658,8 +657,7 @@ static void free_map_bootmem(struct page *memmap)
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


