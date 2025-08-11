Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341F9C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAA56B00B7; Mon, 11 Aug 2025 04:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C927A6B00B9; Mon, 11 Aug 2025 04:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8B66B00BE; Mon, 11 Aug 2025 04:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7A506B00B7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:41:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39A9AC0729
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:56 +0000 (UTC)
X-FDA: 83763833832.17.9A7FE51
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B0E3140007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=gBlz1RVR;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901714; a=rsa-sha256;
	cv=none;
	b=S8IryEpofnATEqvuoqRYj3XRvMuBp01Vz1FoP3xQVP9+9dIGPsImTlFmuAJg6aTArO6VEx
	mw+ZaWxwU4Dhw6+AHJBH6wUoMCJDIp5XD3apOAvhKnpWW04nc5XCnTGaP4fCMZHhGDG0bN
	g/7kcGozhgBBiUUYCN6cOFguntddvmA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=gBlz1RVR;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHSeKOMw7l+pStcGyuQlwa9eRqPMVMMIKBkvUO8W9Ak=;
	b=W04XlAf9d9JCisGhpMqUSrJY9zaIh3o9fpEqHqsazgFt5xCEZ6kFUBosz9uxKfR25dn8oy
	11TDHEcgCCTpKJ7ICbJDu+sw3i5VEmsAJS1U4HvZgY0IWOnC3NpMxyRMbuLftzid7M2b83
	wKEUYB8PdZJ0xwkdwv2xcNynruSGeJw=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4c0p5p4vylz9st3;
	Mon, 11 Aug 2025 10:41:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHSeKOMw7l+pStcGyuQlwa9eRqPMVMMIKBkvUO8W9Ak=;
	b=gBlz1RVR3MHa+jwwbGxchOX7mNK5kGfgcYep5YrEHGKNTYDA2LyL1hS6okPt5QhVyOs6YM
	5HDLvwZUK5rkbJ5XjA7/DcV2w/0uIY70npLSS5EtsnR99pHCcBL+6Zb7EQvkMfhh9jFT5G
	F1emO7nlk8/mAq8c9EdkEH0YOweeltAnp9vAnrgFAH5lpvTtaeY8vtuPPZzVanMTpafyNh
	eyrKd17lzaT4rSW6cF75yO+e0Sjl6iRbEzz1PWXCN9lOao67Jae7Ey0ZNdEJYrfInsxrmo
	EJ4SxvFT7IPzklGlwjhOo/xVnaz38fAiBthdJ6KLtZeba76XEXKiwf2hHKqWqw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 3/5] mm: add persistent huge zero folio
Date: Mon, 11 Aug 2025 10:41:11 +0200
Message-ID: <20250811084113.647267-4-kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5m9ocxoghijni6px7yf64hyrpwqphc46
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B0E3140007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754901714-821553
X-HE-Meta: U2FsdGVkX1+coR9CT9nD+Y+w5vwMff/aDYcoC/pCbX1sjIt392Hh/gvDQtLBWPIW2RTO6Uo1pvnrsCQ9ys5XHy6yRrqAFv0m0LKO0Pzeeht41vS7YcoiFCGqsSEHRbhlrvhnQ9QrFKLwuv6VimWx7ysJ0aZjJ587H0OkPL86dzfASrbfa9W+r81o+9B/BIpcz0/j/aZmQDBFOkdG1Xngvbyl2NLBjTmP5Vs8EG2ZHCLUETqIiU6+ntmaB5FCE3DoOm2dRHrUjNjMH5vTH5p5fJ0Er+aEppO+kjwX3l8c0rt/OFpzDvNQIb2WQEzCNQ6W1kVwCfFZPg/BFqlt8pbTXbBTCqeSPjDw+hIwycU/VikC8DJZzWgxGkOU2nUzYhjxyAtdkJlf+ZJ8qb5K1joeGU/+n8YZnkx2Z3LLQoTyR1J3W2OszOFrBU6Z3h/5QQ77o2tcQ0rOGdOOoy0Gip9JtGOjuQHdME30JWppIX1Wry7pmB+/H9onFoetvTn2MP1zJ3Vt/1B7ykrV/1pkxkvXTfO34kr2w4ksHrWUDn/GCtejXm6P8aozLyjTjsf+libWqM/m6V5CV/PQNdZGljnJJs9UTWaRS+h4yUGvwQvJqQQ1fC6k8ElcoeT1NWLBc9Mw1yt7FhyLznAPNmriPXWyTV6yyEgiWpjgQl/wavPZVkU/2erP5+1SRr/CCqMtpXG0EWl2hiHihPG8cAZ/VSU3C9ieMT7E1Aq5mIiLPxZgNF2w7fv/zOVZG31Skc8iM9rjlqjHktOdC5uQ0TKzoZH3pHY/prqzrDd9FrmyJNE1dF2ALCpxiHZiNwQeShDYVDrH3F2GLiTZehaeNZMAJIG4AyVf4pz+WDz+KmAa6uwhmhXA7kiOUAXp7/OgAXcNmD+KnIy9/xWaLFVpOQMOj8KSSNS+TRr6R8gVcVemgygb3TSGVW9S7MZl7h/6VJk1MeY4WygeAp1uKzg0DmFRoPO
 hIh4IfJd
 SnfFrIunevBEmuJ9pm0wkxDpstIedJ4AWchXcA6eGUfzpFYGNELqI/JDMgaojBU6g6xusF/vyPymAHcHLh0dnePkJwDCffO5twJX/1/ATc/JtBUPVVSLZ1wYWDusz97L613MJomAPXx/9j3x6izSp07NMl3W4LAKAlBEB71M8eDWn1rYeObTDfmFYxiMPtW2XAZCoUIkueiz/fDq6F4KEs6fbO8TeAooUJR66qGGDbRRkGlMI6BzwTeB2A9HuflO+GFqIzd5uu8cKDktsLnrUZ5Sgo2nQtZjAS0pc73lj5EGQvmrARtILm/akJX0kd68nT6lotTG8U2QiDtYjcFPf48P54jAIjeyI8qMuLHUMhJF82TmcGE5JgEclimfZDtZDoyyhJhdczCnZt4NPUslv2xoFAXsZfTAP0MNe0B8rsUtufcrhscpRCdHXfZQBia1ozb8HcamtMnB9CVjmqxboud9FfVqTRlbt32ze1mDaFukmqNkjKSUg53XyErRvLrwrM6Ksn/J80kUPt2g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Many places in the kernel need to zero out larger chunks, but the
maximum segment that can be zeroed out at a time by ZERO_PAGE is limited
by PAGE_SIZE.

This is especially annoying in block devices and filesystems where
multiple ZERO_PAGEs are attached to the bio in different bvecs. With
multipage bvec support in block layer, it is much more efficient to send
out larger zero pages as a part of single bvec.

This concern was raised during the review of adding Large Block Size
support to XFS[1][2].

Usually huge_zero_folio is allocated on demand, and it will be
deallocated by the shrinker if there are no users of it left. At moment,
huge_zero_folio infrastructure refcount is tied to the process lifetime
that created it. This might not work for bio layer as the completions
can be async and the process that created the huge_zero_folio might no
longer be alive. And, one of the main points that came up during
discussion is to have something bigger than zero page as a drop-in
replacement.

Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will result in
allocating the huge zero folio during early init and never free the memory
by disabling the shrinker. This makes using the huge_zero_folio without
having to pass any mm struct and does not tie the lifetime of the zero
folio to anything, making it a drop-in replacement for ZERO_PAGE.

If PERSISTENT_HUGE_ZERO_FOLIO config option is enabled, then
mm_get_huge_zero_folio() will simply return the allocated page instead of
dynamically allocating a new PMD page.

Use this option carefully in resource constrained systems as it uses
one full PMD sized page for zeroing purposes.

[1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 16 ++++++++++++++++
 mm/Kconfig              | 16 ++++++++++++++++
 mm/huge_memory.c        | 40 ++++++++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..bd547857c6c1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -495,6 +495,17 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return NULL;
+
+	if (unlikely(!huge_zero_folio))
+		return NULL;
+
+	return huge_zero_folio;
+}
+
 static inline bool thp_migration_supported(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
@@ -685,6 +696,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
 {
 	return 0;
 }
+
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	return NULL;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..d81726f112b9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -823,6 +823,22 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
+config PERSISTENT_HUGE_ZERO_FOLIO
+	bool "Allocate a PMD sized folio for zeroing"
+	depends on TRANSPARENT_HUGEPAGE
+	help
+	  Enable this option to reduce the runtime refcounting overhead
+	  of the huge zero folio and expand the places in the kernel
+	  that can use huge zero folios. For instance, block I/O benefits
+	  from access to large folios for zeroing memory.
+
+	  With this option enabled, the huge zero folio is allocated
+	  once and never freed. One full huge page's worth of memory shall
+	  be used.
+
+	  Say Y if your system has lots of memory. Say N if you are
+	  memory constrained.
+
 config MM_ID
 	def_bool n
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ff06dee213eb..5c00e59ca5da 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -248,6 +248,9 @@ static void put_huge_zero_folio(void)
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return huge_zero_folio;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
@@ -262,6 +265,9 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		put_huge_zero_folio();
 }
@@ -849,16 +855,34 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker)
-		return -ENOMEM;
-
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						 SHRINKER_MEMCG_AWARE |
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
-	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_folio_shrinker);
+	if (!deferred_split_shrinker)
+		return -ENOMEM;
+
+	deferred_split_shrinker->count_objects = deferred_split_count;
+	deferred_split_shrinker->scan_objects = deferred_split_scan;
+	shrinker_register(deferred_split_shrinker);
+
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		/*
+		 * Bump the reference of the huge_zero_folio and do not
+		 * initialize the shrinker.
+		 *
+		 * huge_zero_folio will always be NULL on failure. We assume
+		 * that get_huge_zero_folio() will most likely not fail as
+		 * thp_shrinker_init() is invoked early on during boot.
+		 */
+		if (!get_huge_zero_folio())
+			pr_warn("Allocating persistent huge zero folio failed\n");
+		return 0;
+	}
+
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker) {
+		shrinker_free(deferred_split_shrinker);
 		return -ENOMEM;
 	}
 
@@ -866,10 +890,6 @@ static int __init thp_shrinker_init(void)
 	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
 	shrinker_register(huge_zero_folio_shrinker);
 
-	deferred_split_shrinker->count_objects = deferred_split_count;
-	deferred_split_shrinker->scan_objects = deferred_split_scan;
-	shrinker_register(deferred_split_shrinker);
-
 	return 0;
 }
 
-- 
2.49.0


