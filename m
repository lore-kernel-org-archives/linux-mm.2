Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02194C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4A46B00AF; Mon, 20 Jul 2026 05:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0668E6B00B1; Mon, 20 Jul 2026 05:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE856B00B2; Mon, 20 Jul 2026 05:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC41A6B00AF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 665E2A1003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:43 +0000 (UTC)
X-FDA: 85008640206.02.AF8872E
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9FB72C000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z6G8YzBf;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZmQ/vHHln8qDG8kPEldYQhj1SA8zCGzuopSX4ZYgfs=;
	b=EBOfI1DkJ0/Knjvof/oyPdyRnFTYSufTDBEfM71bwu6Wlaa19ffxoesbvRDGezg/pRjJqW
	hWZgFvaYe8GsN7k9EVch+1FKEsj9RuLcz5pUOLAmtx97g9EQh+utSnFsa08DrQPVNbDjJH
	U0zY59w2csrkR2NxlIDyuZpmeNbRwAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539961;
	b=molBgFOe1YtZ6ovvYReuXxsKBwjLrVGFikgOopCBQ5r5y+2wzQSxqIScuGbKhQanfwNJPL
	8+UhRr5yuZPVttQjjGVbZibDKacKpGOvkLwqOyQ6plBhQgrmspPGrW1B5Dq1UR3cL9Ef5G
	0BbxtkTnHgvFzQB6/wn/2YdFGdf2hUE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z6G8YzBf;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2caed617615so109058975ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539960; x=1785144760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JZmQ/vHHln8qDG8kPEldYQhj1SA8zCGzuopSX4ZYgfs=;
        b=Z6G8YzBfGDi+EQmRb4a2UpzUPLX+Cf/Qg76IQFzE6wvNOlpg1SmCNBTmWADOXav2A+
         +Z2PP6RieMz9JxLwaAhoHAjjcHRM2/qg24pCkQ2U5JBa7L0h28zd7cZr/wDS5y1w6c1x
         diA7pNHOUOigyIbG7Ck0eQqqG1KsEe53MyZxnNH/nG+SutQY95onk3izLj2r3mtY1ggy
         /oCMFUe4wjlzIZP4QuKoPTgOGkbNzvxswvBIJV6PUg5x/U8t2BpkYYq5kmoFm1/5eeyV
         gGFb2JTXk2epgbYqy7MCk8NddXdLiQQKaGV+3Z76XgGenmB4ybX4/47B1O46eAdEz4Sy
         XO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539960; x=1785144760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZmQ/vHHln8qDG8kPEldYQhj1SA8zCGzuopSX4ZYgfs=;
        b=YCZwCAaqv1WHwJmVHVHP3x9WNHDBz/0mFz97omSRoNHYRoinnQjwzhFRjdClbLlNlh
         80zd+5SbkZ662dboZkt2lznQDaaHeQzlw9V2dkya5VW0X1azV9rulAd8x+nRpzymjeYH
         jBqq0CT+O3v6kgAAdnYy0xKaWcdmS3Y/pm9I8lop/CYuhGFSm2CwG0cRiARECORQKqHT
         n1WjrHHgEE5ttLGdUvaPq+DvQhyq59itTejZwnruVTGxKThQF6xCajOxReR5+wLuFUMu
         ygpMwff+xG6Rjg7H6GxJfzg0dniMJ7q/c7lrMmSROr+W6vEskihyegb7E9ebbZIZL0er
         osYg==
X-Forwarded-Encrypted: i=1; AHgh+RqtUz4RgqZj5ykyiXUt3T3HeiV5XIEgYm3ondfofzIqfFBw66uIPFZCZsJqNLcZh39gy1DPGO8OMw==@kvack.org
X-Gm-Message-State: AOJu0YwzzIojG5ur7rzmWXwYASdl58WE+ppHPdT4/6iDAgtVSrve0n0K
	olrexabW9HtIUArhHFNUchHQP0H0BOEtAUOzMnEo9pfKYl7uJ7Mv3gn8hBqyFGNfTms=
X-Gm-Gg: AfdE7ckV6CXUR3jqVXmoJ4DxeAIkhS1vKp/W2n34Gt1nrGTL/i61GDyjUi/hWdX9KVo
	jCEED9iyMBn7Dlf/JTqss1oxq2WCWMxRoHV+ikM4hmgIUieeuS//kxTow5hUJJ23C8nE0FGfNZo
	EwNLIxr3r7g/MmcyP7ekv8OoATxlUrJIQCsMHcE2+tY1UwaOLMtv2w+fxGUWutk+KgWzFkRkvfx
	Z1+3a/4xirDNNBPf0xR70Xuj1F503nZUXO7IjhaB3aX8/bWMZCVotCAjdN2SA+x4BIdExEtmCge
	YDrdGNzjY6jfbwzMK548s2AB5mu3FO+Nc7YPbHNeV13wv/9kSj1GD1dOV/sfMzpiqKKkmQh8YsP
	COW1qQRSfVgOgbmaKEIr/LTTiVHkTX9avXDoweojZ+V2dcUf6RgzASLrZJFS6BVd09y8O+iZudO
	7uepSYg/orcKWNRgWVoCyeAFw=
X-Received: by 2002:a17:903:184b:b0:2c0:e5ee:f55e with SMTP id d9443c01a7336-2cf3481b67bmr141615205ad.7.1784539960299;
        Mon, 20 Jul 2026 02:32:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 11/17] mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Mon, 20 Jul 2026 17:31:21 +0800
Message-ID: <20260720093127.540540-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FB72C000B
X-Stat-Signature: 1g74ka9s6bhbtk5qcysomb9gwgebjbeu
X-HE-Tag: 1784539961-993022
X-HE-Meta: U2FsdGVkX19irwuqUF7MCSjyscsrKB2z4vqKUHZSzyBXs2gYZOBv23jLoy/ja5F+5cye+Eu9uz/KLFnRh8mJY87fqeWq5H7uSRjUYim3vQ0ac3HPSHuje27Bc0UO7I9cb86YKOprbFvf08JUSxJVQ1N4YnohGJ/cOsIZFATc6u5dxLcPosPSUjCS1f9KN4JhrbhkXoYUtz5k9lIvIrkHYh7E3Qgj6+mqmWYoV9T2YnKjNxlnZAEDQrCgqKRASNGIGHQAnBQ9hGaKnByjUxqARQPOCiRhFxBsUuie8Dp5iE+bSRfmnIKGkYqn6Tfk2EzKnK2ZRu/TX32u2o+CIEaO52HbeAV2lsXgMpylTSOB9rsZc/emIb01SeICD5O63fgSVeZj6jMb687VbemgaYVDLKhvsWrs2cB+WbPfRgCSiZzG+YxaErrAJiLE7ZMljVbWRKvnGJ/2B+dhZuBBsBz8ov3Q+ESFQgzYXmhEcOQgRTVT8mwK1plge8N7fSR3jCgRg4AjZj9Bp32nBxxkTe9tn9wbKjgJqVK7GuePs0fhEssZ9q+YB0y33stOW1TKAmNBWK5JvxBfn3FyaDSku2XihsX1kpxSx7zquA7bEU/XzAw6+jBhVb8uU78sz9OoRmZbPT5v3XAef+N3LlSg2q7e984q+ckpRa0ZzKBPUqaTkKN0nJuQ+T10FwWMde5/fo3ET1wORzaHwCgVL9rbV48hNLJyofU7WkIuF8M9qeMgqzu9CIeNro1e/OtLve1awySDHn7n3Oc3VGFH2yunvji8t0VE+TjrsklklIQpGWoad9SOhjmZBZ75OfhVg0xIVPEMKNeYgNdLqcvQC8txdsN3+bG+/mTRiDtwXMFfIbZWgwR10zqr275Sok7NOueNaDWQbQgdqOJ0P87rOMRLDGFRFSaLikSpZ7/coLIGACbiaVKXIubce4XZQQUFIkbwpV0RID5Q/AiCb7s2dunKN1z
 Kpz4GM/z
 dT9JOBkjRAscE7iKyYdCQAH1pya+cW9oiI83a6wwpeAtqeQ6pnSIE9hCTI6dYQSspDiRx8p9IFEV+iKJ0HDdiwk4sKZ0uEZ0Ru3RtiMjtLlFwdW+SHEAXgGEn4DilKqd/hlNCUIw4UGE92E5v2cY3Ehxpex1g0wVcocUrz8Ff4xzxWjsllKUJXsNqlFAsREm8yljxw+N8cnxmydYAQcMUr0kq7MUCijwoIrJE1X7UUuXzWdhrEHzGD8zQ/3R10D9k0QVhaQwC13SRtxINfh1NJDPurrlCFVmZe/q5Hf3UY79Y9mtBQK/zGIEdO6sUlYNbQXb34Y+GCxqf8iRERQ2VUoYaGC0j/QEBBZRZmwokr0OnHTEECrMxeHepyZK9smqv9Yw1f0a562Cb9JQLGxeFekFHgUP7H+2pR4VxwfcMESYHHEIyhkfGt896MIkydP7xfP26LjlqZU1XoAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SPARSEMEM_VMEMMAP_PREINIT existed only to support HugeTLB's early
vmemmap optimization setup.

Now that HugeTLB bootmem vmemmap optimization uses the common
section-based sparse-vmemmap path, the sparse initialization code no
longer needs a separate pre-initialization mechanism for vmemmap
population.

Remove the related Kconfig symbols, section flag, and empty early hook,
so present sections always go through the normal sparse setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 arch/x86/Kconfig       |  1 -
 fs/Kconfig             |  1 -
 include/linux/mmzone.h | 25 -------------------------
 mm/Kconfig             |  5 -----
 mm/sparse-vmemmap.c    | 13 -------------
 mm/sparse.c            | 23 ++++++++---------------
 6 files changed, 8 insertions(+), 60 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 583b4cf4922a..7be1fab6f365 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -149,7 +149,6 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
-	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
diff --git a/fs/Kconfig b/fs/Kconfig
index 64ff193fb42c..5af471024abc 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,7 +278,6 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
-	select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 025ea69f57d8..4a4310552976 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2085,9 +2085,6 @@ enum {
 	SECTION_IS_EARLY_BIT,
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
-#endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
 #endif
 	SECTION_MAP_LAST_BIT,
 };
@@ -2099,9 +2096,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2156,24 +2150,6 @@ static inline int online_device_section(const struct mem_section *section)
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return (section &&
-		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
-}
-
-void sparse_vmemmap_init_nid_early(int nid);
-#else
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return 0;
-}
-static inline void sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static inline int online_section_nr(unsigned long nr)
 {
 	return online_section(__nr_to_section(nr));
@@ -2377,7 +2353,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #else
 struct mem_section;
 
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 3cec14092b28..2885fba13ebe 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -459,8 +459,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -471,9 +469,6 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
-config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 531927bc9380..3cfcd490dcba 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -559,19 +559,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	return pfn_to_page(pfn);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-/*
- * This is called just before initializing sections for a NUMA node.
- * Any special initialization that needs to be done before the
- * generic initialization can be done from here. Sections that
- * are initialized in hooks called from here will be skipped by
- * the generic initialization.
- */
-void __init sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 		unsigned long nr_pages)
 {
diff --git a/mm/sparse.c b/mm/sparse.c
index d4641aa70497..f0d9b7263bb2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -294,27 +294,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	if (sparse_usage_init(nid, map_count))
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	sparse_vmemmap_init_nid_early(nid);
-
 	for_each_present_section_nr(pnum_begin, pnum) {
-		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
+		struct page *map;
 
 		if (pnum >= pnum_end)
 			break;
 
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms)) {
-			struct page *map;
-
-			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-							nid, NULL, NULL);
-			if (!map)
-				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-								       NULL, NULL));
-			sparse_init_early_section(nid, map, pnum, 0);
-		}
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
+						nid, NULL, NULL);
+		if (!map)
+			panic("Failed to allocate memmap for section %lu\n", pnum);
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							       NULL, NULL));
+		sparse_init_early_section(nid, map, pnum, 0);
 	}
 	sparse_usage_fini();
 }
-- 
2.54.0


