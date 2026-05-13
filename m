Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D34CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC766B00D4; Wed, 13 May 2026 09:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3F46B00D5; Wed, 13 May 2026 09:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC31B6B00D6; Wed, 13 May 2026 09:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACB2B6B00D4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70E90C2848
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:43 +0000 (UTC)
X-FDA: 84762431166.29.94A0065
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AF43100016
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AqrIOFEc;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677841; a=rsa-sha256;
	cv=none;
	b=xKI9rIALYGVM5Csjs5UOkoU9etVasHzpMZF+DwJHHmSpiLAIr7UL3OsZE//WPTmR+sGFma
	hl0W3itWLCWV07FSWI9vFPVEUq5LbiDp5PaA2ysOceNR+rcfgBTMv3kVh6SlmOYfctW1e/
	WAWy3QvusC5SjjbbQnp0lk1jF/EbxC8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AqrIOFEc;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjpGKbpR87QdpAXzElJEcltafcXUZyW4c5xpVY2ebxg=;
	b=68NifMNHOH5v0uhAP9vWHIrVE5fAmGFWlp6ZvqVjjjFBM/vwhpugZ25VcFqPfuctXZ0sxH
	h6KxuiTAH+Z5AbcvLC60FimPcv7wOP64rrPdXYHkUSup04ZSuT6qY4zbVazZSFr4FagD8Z
	Xt1ctIexlK/478HJBU4USltU2Tyoi4s=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3660b84347dso4364135a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677840; x=1779282640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LjpGKbpR87QdpAXzElJEcltafcXUZyW4c5xpVY2ebxg=;
        b=AqrIOFEckFe2P0NdYbdEBjtBzHQH7cKHZ5MPjRY3k52fNtk7aqslTtgMtxUeWKwmxj
         XLywSMy+/n35O6tM+F045agHJNiOAKWO5sy8Z/Dy+8eMyN//XWYsmwHlwyidEUGERlVA
         EHu84rQ+4vnVqGDYsEpdLI2553a6tOBz+X7eghqiSECuDlaF+itpiu9QuFIJOe0q5TGA
         Vsn/hI7xFofFmvNA9tLXkmpiwvRUpmWFmikNuTdvRVVvxXnYPEUPshE0O2QcjbWIzhxl
         MnZdcpgHu4pTc3h7iywNGufSgp/vSfKDTQgPFtYNn0ewt07ZH6gzp5BCxp2XsmQ/gtRk
         5INQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677840; x=1779282640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LjpGKbpR87QdpAXzElJEcltafcXUZyW4c5xpVY2ebxg=;
        b=fygMeg1tMUoZ8A44cMGGL1n6fCDp/Twy6CV22wDhm8Gp+l4x7AhOKFRnpxyd8jOLAg
         aOTrE88B3tJVxLpKfIz7n2usYHCO56JLPbBLiu8X1Vr3RD3Mhy0dWS+duNaoWH2dhL49
         uUpeiDx90md66HOzjJjxb77xdYlIlVJGT13EFlXxNbuZIL2jRS8Z4lPN24S9DWLiQ3MQ
         mDEwa3KBTXJW5mL7aEpHuTIEqxmMPlqicIaFDn2BiVEUR/dDlyOgHRv+R8clynefUeMj
         YIfpegnSKoOTN4672+ug7tSlJkgvPGtJPaEEpxpQvqKWb/5euG6T+0GzWrcBNBZsI7Lq
         6ldg==
X-Forwarded-Encrypted: i=1; AFNElJ8mqrhFzaU4tAe3JfSCs3fiMgsOepUx3Zn3w/bmDSwp3PKXOaXr9fcps8s0gzpEgs34V5N8sQ+E+Q==@kvack.org
X-Gm-Message-State: AOJu0Yzq+aakLU33zpjQscI/aDEyJr8LUi0f+ilz6uCEcJ70qj7VTU8R
	bnpxf17LtxWQ2BIHd8Toq3Bloj99xoDn8YmGqgssnbkRW8YgHEUBjLuxVouZbzSsxWk=
X-Gm-Gg: Acq92OFMz83yG6PmTrumeYG6NtyQrVjpoZq8Bw54c3yxsGvt26xY2Vmryu7raG7X4Qa
	kEFBD9zJS3tbAzSwBPTzOlF1claSRoPCW07pIlyT1NzTRxJwGS5oLK6x73PcDAwq+vvR0P+4W37
	SZ2NEKU7Clx6rczsu5WIEY9rMqD452vcxiwYGmU7bYSru0mwFdpnXvt9Jk31UEu0z8IkEfPMygl
	aGdLtPDloyXbGX6uXG3d3285gCuRpCeOhLFKYluETWX6LXkKNUPWrHT2P1X62B992jPFMnjQUDj
	z+4ZjrcX/refKeRRGe2TyYKmD/jZTbwa0wGn00hJqTp5lVdNeeqJor3rPZ8FmSf1MlCu6ZU069F
	e+GtL5YhI8Kz4HYBNCogLMVB0JbQL/GDI4WwoTAtKxVfXRoJXv84VzASHzWAO3tFaPwxjgHkNDT
	DshK7byNzigjNB2bwa96w/d86IpgTfDKBXlPW0oy9X7eaf94RTJLdCu6r+lMPG5MWkPE2Yzg==
X-Received: by 2002:a17:903:4b03:b0:2ba:99a2:c44e with SMTP id d9443c01a7336-2bd275c6b33mr34992375ad.21.1778677840351;
        Wed, 13 May 2026 06:10:40 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:40 -0700 (PDT)
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
Subject: [PATCH v2 34/69] mm/sparse: Inline usemap allocation into sparse_init_nid()
Date: Wed, 13 May 2026 21:05:02 +0800
Message-ID: <20260513130542.35604-35-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dham59knh3r4zifamm8456no1tsfpx6x
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AF43100016
X-Rspamd-Server: rspam07
X-HE-Tag: 1778677841-520684
X-HE-Meta: U2FsdGVkX1+pXwCeM24+FuQy9u4zc5rCtmcyasZnlQGCC0RxHOn3n7Swo8sZp+t58dw60Uq0bHkcPtdTNbhs7N0taUYYESQu3/IEVq8H0+G793RkrKjtYXxK1EGZxpN26akAHU993YnwyDViReqjiFRoenYGHYxZ5080X3kg45iMENqpvCbPfseoewvACBkf9764Q2hrPVMatTeNm6+0KIU/CEuuMdmQjWIHadd4XhjAQqi5RX1+r97CR0MOl/LfH2dyuBU8gQ4CJ0RpLWsYmHRFzq+wcpC5TQE98Vjdbt9P2wt/7HS/VhscGjnmCZQKLM4BRGBorht2suGIokUjPlJTmCrJEoNBzMLpHKPGjTvJ8wXX8dqizPwOnWHOCm4aWBBKZlRDlx/1D+fXvT+FCp1hWPc8QG1S/sNB0igFXgxu/RfF85AfD7OzJk+QQnjDYdzwRE+KYbP0xf+9XaRbXnLV6uICCj5laeSoNPksOuGWORiA5u9BBCxdBloNynoRiIo5M7J4zqBUhy6g5xsZzeSdGlA62LCq7RiP5ldRur8AIkwehpP0EUxSK6pf6cY9ml8MPrkjkBmCekdlm3fiyLjwTW46haPIVaQKK0sx6SJBCVKVG5jrc2I9ja8m3urMXXCerEhEdg0Ewqy9doZZX7LlfJHzMrV7Ww2fDOJnkSboz5/kxr4zBeiuSC9mrVxuB4iMrWZ441z8mypQyUPtR30hmbo0C64/w7Mhda0j3EOri6LkMnM4Gtru2qynnp9YgmoB1Gp4wgI6GKfkbCRoL16CNenBPmImzz4uph3Iag1XxeRmbp1fz+SDAyJA1tdzdrx3CamCSGWL+IOyw2Mv4YQXRb8Oaff1L4etBHSK+DXcELXQ7+LaWNECvpyOL0qeQUujcyIByecdKor4jwvDHGSRtZ5xt1gUT7lp3hjPGsK1fyrIs+tD+3S3Ro9hAd2JEELiMXv4WbXatItc/1C
 kBK+fIGn
 o7PsdSFHSv4HP+0e/htzshsxaR/H89DULS/WIXkJPO0tFzUtkGtn8z1yXOGstLkkI5zS3xVb0msBvIb6U/iK3C/swd/IHxJCWLLSUng/2/yAK12ieEwWjSdPAca3HInOGioK1Iu+QWDfg5Sa92KlZcXXf/OaU0EDzt+ouY8J7ZzY9pQWsXpegDQJR8PvHnUij/r8uFtlfirWmaX2fXPIjRe8RM2AzC/d93LhImJstgJ5NPOrDhS6R7QBkaVKN4oakq4VFMvWNnqwQ8kxNAqFytka13ExwmNBioVn7aNQBCU4e97bhBEGNvKNxtiqRiRaOIree
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  3 ---
 mm/sparse.c            | 46 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b9baef8cca91..a60fd5785fa5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2265,9 +2265,6 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
 	return section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
 }
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index eab37504819d..54c38ea08190 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -237,42 +237,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __meminitdata;
-static void *sparse_usagebuf_end __meminitdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
@@ -312,8 +276,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -329,9 +296,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
-- 
2.54.0


