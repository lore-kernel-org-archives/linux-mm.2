Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8EC606A333
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o2tEyI1X
Received: by kanga.kvack.org (Postfix)
	id 63A1A6B00EF; Mon,  9 Nov 2026 17:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAC46B05B0; Mon,  9 Nov 2026 17:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500B86B05B1; Mon,  9 Nov 2026 17:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C01C6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:13:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F1B11C40C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:13:46 +0000 (UTC)
X-FDA: 85416983652.15.D59FDAE
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7EB5EC0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:13:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o2tEyI1X;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794262424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e9/dY28AbnB9XPn1NP4bpPoQIANiGH4RxOhNWOkNHmo=;
	b=3NDb97k6NHdGNo+3nsHmrHJDQYmkMaPG0feJwAJtVw1EsqjNkfxUc4d4RFkcKjmkn92UAe
	gVQ5FSxQOduK3rjGOeClkadKZ6ugrzHNnmh/cQMxNLrDuPx9+woNIxHZIZcmTWP7jjjpoC
	hRHYTWVqVGRmhdqS7+AXkE7ugbrsHr0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o2tEyI1X;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794262424;
	b=dJzmg1DN35OvOeJdH58RuyvifBIT9glVr8iFzAn0ZOYT6wf5Vs9TqTE6vuxuDw60WhJIgr
	rU1uTSDlvG6ZX2uWklKhHXdC91Wgwyix3NGaUoY0B1tmPLTzQMIGhlrRkLzQQ4OHYhuK3v
	SVeepYs3/U8s/hqzh8iVcifGaF7JiqY=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso1300165b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 14:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794262423; x=1794867223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e9/dY28AbnB9XPn1NP4bpPoQIANiGH4RxOhNWOkNHmo=;
        b=o2tEyI1XlXGseGQXg54QXdhGYSnuxY+7mAR0uJ62q9SVm83G3A4SXtm0bAyR5h+7ZX
         TpxLWAOGp65sKwwkK3iv7fBrkQ7fNSVY3Jq26q4y3Pqqo41w4DWgygbClfVnCRoGuN9G
         g5c3DTr9FlfF2x7iky7l2qlK4OTzpbdtJRexkDpzmRMe06+GtPCM7BvbSwTr+PM8TmTm
         9VMT6/FDNTDZ3d7+RkcbfsIznELuAz62UHcq2Tbvul5ES6nLitHsBSNVmFi+RCKeL4Fr
         4LdGARmf0Yq+uuIB+JBqs1kovcskJYmwrYOHBzRL0TDlCvSzpL3OvjGm024oE3LVfJFu
         9xNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794262423; x=1794867223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e9/dY28AbnB9XPn1NP4bpPoQIANiGH4RxOhNWOkNHmo=;
        b=UP2+OBnibO1R+eEBhc7ed97c3aYQd5V72uukqog+x8kzzkmTPge2m68R/BAUtGq02u
         qLHJ+rz9XIxpMRbw8qkJ2LZGVEOnEdR8NctlPzSxCGDJPrST6Xu+9XR4QtRFp74m4D9U
         uF3p15Z6Bg4peWLviXa4j9t96mCbGIsEJ06vRK7Zb/I6rTcXCHHeGtDWR9qq6ZT4dWtc
         FZaZejSUbrYTDpSz/lEYDYttj3gR64UvrQTy7m0iP384WstCAfCwqWNcDcbp5f10aXLg
         YB92jnwSJiq2PmeY7xEmOq56gr6S5ukWcrBHYqxlk+emIjYWrwZ8RTLMh9T4ZL/3ZZYR
         bcww==
X-Forwarded-Encrypted: i=1; AL+hErHYeKFP0v7kjDqYfjb+khnLIL0kQRl1wMiYFb2ui0FE2UbFejgQEj8ykKjikYqSpowJJjzIohqe8A==@kvack.org
X-Gm-Message-State: APuU4Z9lwsaO3Zaxj4w4XnWqXe3W4iMLwHcbpiLl5fYBkl4/KatJT2Iw
	J8Ni237BhiBHipxGi8/lgYXrpcSNH0C4TOG/VML7GM3WAhfeBtZBlmOj
X-Gm-Gg: AYBFou3sdx6Ojx5W4yjjv/+KrhkFSjy9nrRD3+Yb/7MIVEpAU1MmFWN9beFAeRFwrg0
	ufatiHNnnOTpXWZidO4syL2ycR/79SUBaCAfdPoNwKWLLLEg8kW8d8C34IKp8d+KOxa+Ca1wFIw
	9G0jTfGf3t3731UMWEst2iPp0vrA4WuKJrmuuO17qhv3gf3vmcaaDjgRuzDY/t4zgjmavq83MnM
	0tXSfaNWb8mZtYaYAdQ0I8d84Y3sjE0qQJM4qXQCU8wh4hPCy5krNQu68MQN3BR7as3Nehq9W9W
	JL6qslsJKsSKc7NuVg1Z/dbXTZ4MPcV8ENbhsYzWtwTigtgBiGb5ncnpGxQKvuFogBVspY9vQ4w
	n8sw0UdHnsoHrCwpTnCmnMF1Fa/1KZdfRNe+8/Q1TeTY8S0urGGdP2zla0ZaiHqyKMqdbR6fF9W
	W+5gbRWMj8Hk9L+TDB96fAfXtrIra8NKOdOPns5QwvY+KDUje35wc2bf91oVK1lQK9n+zVfLsml
	dof/ftcnjb/SazREfuT0lhMcFV8wUZIH+qxiVhC4NqSS+P9Y5BLQGd5+zlcHFQcV3WPaq/jh5TY
	L7UG+nw06wsDacrYJo067mJL448sMC4Gq3YIgZgfjuCKCjhEcVUYlYfBrFFoNOrZPZ0DCYMsVIo
	wAD92FA==
X-Received: by 2002:a05:6a00:3c86:b0:893:8a6:3801 with SMTP id d2e1a72fcca58-8ba867aaca6mr859654b3a.24.1794262422762;
        Mon, 09 Nov 2026 14:13:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dffb5sm132255b3a.55.2026.11.09.14.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 14:13:42 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v1] mm/rmap: fix migration entries being treated as partial unmaps
Date: Mon,  9 Nov 2026 14:09:58 -0800
Message-ID: <20261109220958.2071687-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: trib5qgwiw6d1xiasrouzijwt6wtskqx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7EB5EC0005
X-HE-Tag: 1794262424-813083
X-HE-Meta: U2FsdGVkX1+9h4fLsCPnCg0VoYUFHrZcK6nLZW0vYVrEvnR/WhsS4kuIfFFgKEIePZOoYY8gpxkbLGwAVTkcy75PVFKV4kI9xA6PjxKXZVZsNjnL7ZxigD9CqYMHyAPNTZpo1CJFY8PtYhfJiA7mmcVoEufO6GXxJ9zDh74IcYrhBVAsP+dqLvGnftGV+ChBvHBqVFt4TyhiBOfb0xWAQGLnjab0Gop5fHYALg7Zqlr6Z8Pb+eqc30giKiDZizIy9hNqFEt46x4akhMOWhCKiYgKm29LqX9madW6YFYPgLM5/hr1m5uTHXUXu/O9BhbCs77Pttj/hT92cloNehvKRClEkAuxJT/Hsdsi/+wL0ydOXdDTb+3HKeTgV466Gmbs7yaMN75SGB2XAdBT2l+FpGljRJBS41ldHvLlMx0bChK7U7DXdyvXbbW025/p7ax5DXDwZkRrU+pdolr5BkRp1ksipJ+oOtTQc3Dct7UAXwwHo19uBV6usKk8xUOJOzusKSaXKWe/4wpLdfMoEDexqXlFqwIvrrxBjHWocQr+aKFa0dE4t9pq8DPE/4TzHKJXdS32zIbSJ/q2pDBkE550OQhAmTxRbOziEzyeha9Ao3S+urFUMndX0Sg2UfLcN5mq/agV+/b2qkXNiK/zIRGYYM35v3ko8B0zjBbXgpYPMDfMoqNBwFdslnU9mdqRdNYD99ZXiHvIn3LHRUOqs0Vu65AS1fbzzG7udA1SQjtGx1AQJ+m8EUqPVHmqk2XclJTVzavN58OIDEJNusUqRFkLFpLynfn+JO9plXDANrj3mKyM8Gu/GA8B0T+io51+nSunw6hUyyDYBGlGmF8Cx4wmp+wXev00vXWNKGfCDPArXRT/9ElXCRAKEVM3huQRIQOTyvXjpYhdy/2MGxyRYQkQX8SEGieFfMXi3v26rn2ZU1rmIOYNH2wi1crNSmR85tU+uENgEX8u9yb6hAkJN5B
 Ema4n+Ti
 Q/HJ7fueHRz5CNq9tA3LekdVGeY96mxCMWLXFLwBTJZB1T/nihrAdDc52r/53DR8tS7SRbwlmq5HyqqPYB0Eqp2eSsMHXpVq5Qg75+6xFIRi6dV1IAaxavVpPY8a1Kd1KDzNRZF4y3xqFIHpgGxtOpYeJvnPI0wxC0kXvF1O6P1exszCLQKlVXRsxUCFqTdBzSI2yiTbJmaAXMJOBJZD2y3akrM21Xo+Ih36MLlT7hkVCUrqwU06dwv3xIJ+8Pi3xso571VWMJlVPQ80DXbYpYb6QQLazgvQx3Ds7kWn196dpU1gAEfq4g0Pb8lKDAlM2b95mszfbTpKPPRqV8TnswvB4JLbxXsDUR9iVvf6rhJ5z7PkyV5NPYY/8OcQzWsqA9m+sVmjJtH1WuJXgcGEs6blvoI5vrx2zVm/fFUVdzy/4neV/9TSh4X5cXPiSdd6yLK+0ecIx3TRVuN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When try_to_migrate_one() unmaps a large anonymous folio that is mapped by
PTEs, it replaces the PTEs with migration entries one at a time and drops
the rmap for each page with folio_remove_rmap_pte(). After the first PTE
is replaced, __folio_remove_rmap() sees a folio that is no longer fully
mapped but still has pages mapped, and calls
deferred_split_folio(folio, true). That marks the folio
PG_partially_mapped, bumps split_deferred and nr_anon_partially_mapped,
and puts it on the deferred split queue, even though nothing was actually
unmapped. The migration entries are turned back into mappings once the
split or migration is done.

This happens whenever a fully mapped, PTE-mapped anon large folio is
migrated or split. Its effects:

 - Migrated folios can later be split for no reason. migrate_folio_move()
   copies the source folio's deferred split state to the destination, but
   reads it after the unmap, when PG_partially_mapped has already been
   wrongly set. So a fully mapped mTHP ends up queued as partially mapped
   after migration, and the shrinker can later split it without checking
   whether it is underused.

 - split_deferred is overcounted. Every such split increments it, so the
   stat counts folios that were never partially mapped.

 - A folio whose split fails can later be split for no reason. If the
   split fails at folio_ref_freeze(), the folio is remapped but stays on
   the deferred split queue marked partially mapped. The deferred split
   shrinker then splits it without checking whether it is underused,
   breaking up a folio that is fully mapped and possibly fully in use.

Mappings replaced by migration entries are not really unmapped, so don't
queue the folio for deferred split when try_to_migrate_one() installs a
migration entry. Pass a flag down to __folio_remove_rmap() and have
try_to_migrate_one() clear it for those PTEs only. PTEs that it replaces
with a hwpoison entry or discards because they are unused are really
unmapped and keep the current behaviour, as do all other callers.

One consequence is that if part of the folio is really unmapped while the
migration entries are in place, zapping the migration entries does not go
through the rmap, so the folio is not marked partially mapped afterwards.
For a split this does not matter, as the folio is split anyway. For a
migrated folio it means the destination is not queued until a later unmap
notices it, which seems preferable to queueing every migrated folio.

Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on deferred split queue")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org/
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
This bug was found by Sashiko in its review of the mTHP shrinker series
(https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/). The
migration / rmap code is still new to me. This patch is a fix with the help of
AI, so I'd appreciate a careful look from people who know this code better.

This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 fully mapped
folios through the split_huge_pages debugfs file no longer increases
split_deferred (was +64), and migrating 64 to another node no longer leaves
nr_anon_partially_mapped up (was +64). split_huge_page_test, migration, and
khugepaged selftests pass.

 mm/rmap.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fa34e1ccbd8f..e5d17481c0c0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1799,7 +1799,7 @@ void folio_add_file_rmap_pud(struct folio *folio, struct page *page,
 
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum pgtable_level level)
+		enum pgtable_level level, bool may_defer_split)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last = 0, nr = 0, nr_pmdmapped = 0;
@@ -1888,8 +1888,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 *
 	 * Device private folios do not support deferred splitting and
 	 * shrinker based scanning of the folios to free.
+	 *
+	 * Skip this if the caller is only replacing the mappings with
+	 * migration entries. The folio is not really becoming partially
+	 * mapped. Once the split or migration finishes, every migration
+	 * entry becomes a mapping again.
 	 */
-	if (partially_mapped && folio_test_anon(folio) &&
+	if (may_defer_split && partially_mapped && folio_test_anon(folio) &&
 	    !folio_test_partially_mapped(folio) &&
 	    !folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
@@ -1921,7 +1926,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 void folio_remove_rmap_ptes(struct folio *folio, struct page *page,
 		int nr_pages, struct vm_area_struct *vma)
 {
-	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
+	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE, true);
 }
 
 /**
@@ -1938,7 +1943,8 @@ void folio_remove_rmap_pmd(struct folio *folio, struct page *page,
 		struct vm_area_struct *vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
+	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD,
+			    true);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1959,7 +1965,8 @@ void folio_remove_rmap_pud(struct folio *folio, struct page *page,
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
+	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD,
+			    true);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -2516,6 +2523,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		bool may_defer_split = true;
+
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			__maybe_unused unsigned long pfn;
@@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
+
+			/*
+			 * The folio only looks partially unmapped while this PTE
+			 * holds a migration entry, which is later turned back
+			 * into a mapping. Don't queue it for deferred split.
+			 */
+			may_defer_split = false;
 		}
 
 		if (unlikely(folio_test_hugetlb(folio)))
 			hugetlb_remove_rmap(folio);
 		else
-			folio_remove_rmap_pte(folio, subpage, vma);
+			__folio_remove_rmap(folio, subpage, 1, vma,
+					    PGTABLE_LEVEL_PTE, may_defer_split);
 		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);

base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.52.0


