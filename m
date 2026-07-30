Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14329C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCC86B0095; Thu, 30 Jul 2026 06:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5F16B0096; Thu, 30 Jul 2026 06:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5E46B0098; Thu, 30 Jul 2026 06:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1D3B6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:56:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C858160980
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:24 +0000 (UTC)
X-FDA: 85045139088.06.4EE8455
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89D2E20005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2C+CCdO;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785408982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVX/ZLhSYqzqIVhWf+VtDwCnqLiC5pfYqTBKkO89Rpk=;
	b=d0PYthMLf2DgRJuRjPm2NRNWD7ifPVBSt0HHokke9XplJrjyM2SFRD0yMpeD585LO1M16J
	Z+fsaiJOaMXhDkiEuFn/3X4kYk6ZgDRIFOkNW36QrqbMkR3gMQolXFtU1Lr3G0dyJ4JxMn
	ueJ/7pDeg5Sp3Lxu3WlYNdIT4uGZ1+0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2C+CCdO;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785408982;
	b=AV7o8xfyj67P8LgkbjWaJCkC/DP4vqo+Z3sfEHviTMDvrwCaJE2RJzbP0xN78X0o4Ln/ek
	iPKvZMyl65qNDe54cTKf0fyUwBwmcXQeDNLvrQzcD0BiWYPYqtyvrwu1Ho22iHafKrkm+S
	RYFG84vp5knSVj+rFnhSvjdlD1wfatg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD35543E97;
	Thu, 30 Jul 2026 10:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9795A1F00A3E;
	Thu, 30 Jul 2026 10:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408981;
	bh=xVX/ZLhSYqzqIVhWf+VtDwCnqLiC5pfYqTBKkO89Rpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e2C+CCdOQzN3wwcKwjjyQyL6Op1FIWTdiYoWKMQXzZjFghnnGfXoKDTJaK/VJDdqF
	 I5efTmk8dkWBKHE0HnCBH5YulYIMO97pQC5i6LrMeh9v4odf1lj5pCjBSeE1qimdGN
	 IKbSnn2tA8xuIUyLK8kf8lluXw0kz5jfh4MER5RdgfL/lhb04/JHzdEE6C8JHaP/Xu
	 MxaI/e45ka+ZEQ7315z20WqXvmiIixyagDlG0epXzg+bjBeqgUwB2JSzbAVz4Svuvf
	 7q8RDqTdfFsfKYqxbk01yH0DJ3KxdAFuyRQ8h72dxJjJoA9VyH7C9u3R9DeS19XRHv
	 QGfMZqPoF3w3Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 30 Jul 2026 11:55:48 +0100
Subject: [PATCH mm-hotfixes v2 2/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org>
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
In-Reply-To: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, 
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hengbin Zhang <uqbarz@gmail.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7408; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Bdhqr5S4tEK+aTxT4d4rhVG867HIHgX+zTIRmcaT1+g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKydXdZnTXZfcJkuVZvpo7BB8O/si/dxM4etD4xd3Hc2
 TU/J27O7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEwmUZ/qka64mvfnBO1+bi
 FfVZ6SsfVJoF3llzbMqlXX3ZP6dMfBLG8D+D6ypf3wrtA4vfRNjxRfs+L7i3bMrNM56bgzuMzpx
 KvM4GAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89D2E20005
X-Stat-Signature: 3zmj4w3cqxcr1saiayukwkq89ouziown
X-HE-Tag: 1785408982-996816
X-HE-Meta: U2FsdGVkX19lQcyEbcQKY5UdpcDiYYdvjl5WBwAyjWK5dzv1T4nL6NDviFtEUk4YiwzDOiF/RTAdlYGJCmTCUWZ48qN4oEv8e1MzogZy4/ZwMdDSQEA4sTSjr+3mYmiUySdJBMLMNpBUNIDcSS/jx05L6Nqwa6XzgBXtKh6APqXufPTKj5TYzR2JVJIu+g1PQZZDRG/96nHk0RzksB+ZkvE9rZI7DOUgJz7cgaap+FaPOdLdNKN31lnKc9x+HUcUB7xLLTAO3vYhGVsO/B2odCzYrHzo8nYAR9MlpAEPONyI1X42A/rSKYSi64pzzdF2PU20B1lueIKwZgdeQ4zIMnibV2XKySwFTMdlm69yizmrP+bZ+whg4XgsYCdfQLQ7er8qe258RhuXmDogDFIc8k51xVaPgpiz8X95V2v4JMjhw3XAp3q/cIIGWt8LLhV0Pph2B5vaYsxwcDqKCdsVnL9Vl/hc/NQ/PQaaS35/fIOLAiSyZqSIEFc64julVbrt2pIk6LTkygC5NdHy1yariABcwKIJFW91jDorHvn63gNYXXq9YpWPicV57bhuJI/Vc/j3tXrIKDFDbpE4SMhc4FC06W4Yim8pACZQO3KmOIHWmMb/nKFjfHce6pyn1Y5Sn/AETyvYGSIg9nbN7mccKrTZ/uylew70YGgZPA9KMzj8KCIFAw0jAfEoLOmuVPHrb3pvhj1Yimurx+EBBdBXxQDYll5rd8OpcdOog3JVeKatp5VcNMkrVfqyBugMoEcgmtTsj9rMVKS/7PeN3TCFtcUM3xnfqO84U32bb7R/dmEvCSkuKNjqL8ePXi69qh5gVCedzTTpyH9cG2NxbbC2lsPGGXkVD6bsITFy65UMG/McqSD3jXUVlgASKGXKpp/QXpIT/kDPj2y6XA0J6HJTfuNtlwt/Offp8cju2ZA+uRZ9h2y8NqSTfpWbrEvdhcahl8UlUbpzien5WxO9GQd
 JCG5mhRZ
 ejDMEiV99rSjQEa7FiGg663LVyxnUDSwIaKDMumq9z1V27drEy06pUTFIxAt9quHF6uehDZmxg07I0whp1ts8vE6AD5obRekEuO6TNvY7KyHhzUcrqBNm3OZjkLc6lnxK/5ZE7RrV2j0Ggw8vuTga4TiYl3/1iGJz1LqAg2H9GvTHEF863zltD5ZCsRDCksAF6gWUq8W2n8Pnv3dFxnWeAkzoSZRuJ3jd3XkVco4HsfQXVLqzkdvR0omC+2/R9h0Qfo2gdgv3pSW6zj91P2xA6QBy4H+b6fbVtBxL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than mixing the refcounted and non-refcounted
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly
so it is clear what happens when this configuration option is set and what
happens when it is not.

Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
introduce the refcount, lock and shrinker if
!CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, abstract initialisation and teardown,
abstract the huge zero folio allocation from refcounting.

Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 160 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 66 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0535721652..4d2c891b1968 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -78,10 +78,15 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
 static bool split_underused_thp = true;
 
+#define HUGE_ZERO_UNSET_PFN (~0UL)
+struct folio *huge_zero_folio __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
+#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
 static atomic_t huge_zero_refcount;
 static DEFINE_SPINLOCK(huge_zero_lock);
-struct folio *huge_zero_folio __read_mostly;
-unsigned long huge_zero_pfn __read_mostly = ~0UL;
+static struct shrinker *huge_zero_folio_shrinker;
+#endif
+
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
@@ -223,23 +228,58 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static bool get_huge_zero_folio(void)
+static struct folio *alloc_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
 
-	/* Paired with atomic_set_release(). */
-	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return true;
-
 	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
 				 ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
-		return false;
+		return NULL;
+	}
+	folio_clear_large_rmappable(zero_folio); /* Explicitly not rmappable. */
+	return zero_folio;
+}
+
+#ifdef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+static int __init huge_zero_init(void)
+{
+	huge_zero_folio = alloc_huge_zero_folio();
+	if (!huge_zero_folio) {
+		pr_warn("Allocating persistent huge zero folio failed\n");
+	} else {
+		huge_zero_pfn = folio_pfn(huge_zero_folio);
+		count_vm_event(THP_ZERO_PAGE_ALLOC);
 	}
-	/* Ensure zero folio won't have large_rmappable flag set. */
-	folio_clear_large_rmappable(zero_folio);
+	return 0;
+}
+
+static void __init huge_zero_shrinker_exit(void)
+{
+}
+
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
+{
+	return huge_zero_folio;
+}
+
+void mm_put_huge_zero_folio(struct mm_struct *mm)
+{
+}
+#else
+static bool get_huge_zero_folio(void)
+{
+	struct folio *zero_folio;
+
+	/* Paired with atomic_set_release(). */
+	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
+		return true;
+
+	zero_folio = alloc_huge_zero_folio();
+	if (unlikely(!zero_folio))
+		return false;
 
 	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
 	spin_lock(&huge_zero_lock);
@@ -266,33 +306,7 @@ static void put_huge_zero_folio(void)
 	 * Counter should never go to zero here. Only shrinker can put
 	 * last reference.
 	 */
-	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
-}
-
-struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
-{
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
-		return huge_zero_folio;
-
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		return READ_ONCE(huge_zero_folio);
-
-	if (!get_huge_zero_folio())
-		return NULL;
-
-	if (mm_flags_test_and_set(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
-
-	return READ_ONCE(huge_zero_folio);
-}
-
-void mm_put_huge_zero_folio(struct mm_struct *mm)
-{
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
-		return;
-
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
+	WARN_ON_ONCE(atomic_dec_and_test(&huge_zero_refcount));
 }
 
 static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
@@ -316,14 +330,53 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 		zero_folio = huge_zero_folio;
 		VM_WARN_ON_ONCE(!zero_folio);
 		WRITE_ONCE(huge_zero_folio, NULL);
-		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
 	}
 
 	folio_put(zero_folio);
 	return HPAGE_PMD_NR;
 }
 
-static struct shrinker *huge_zero_folio_shrinker;
+static int __init huge_zero_init(void)
+{
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker) {
+		shrinker_free(deferred_split_shrinker);
+		list_lru_destroy(&deferred_split_lru);
+		return -ENOMEM;
+	}
+
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
+	return 0;
+}
+
+static void __init huge_zero_shrinker_exit(void)
+{
+	shrinker_free(huge_zero_folio_shrinker);
+}
+
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
+{
+	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
+		return READ_ONCE(huge_zero_folio);
+
+	if (!get_huge_zero_folio())
+		return NULL;
+
+	if (mm_flags_test_and_set(MMF_HUGE_ZERO_FOLIO, mm))
+		put_huge_zero_folio();
+
+	return READ_ONCE(huge_zero_folio);
+}
+
+void mm_put_huge_zero_folio(struct mm_struct *mm)
+{
+	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
+		put_huge_zero_folio();
+}
+#endif /* CONFIG_PERSISTENT_HUGE_ZERO_FOLIO */
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -987,39 +1040,14 @@ static int __init thp_shrinker_init(void)
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
 	shrinker_register(deferred_split_shrinker);
 
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
-		/*
-		 * Bump the reference of the huge_zero_folio and do not
-		 * initialize the shrinker.
-		 *
-		 * huge_zero_folio will always be NULL on failure. We assume
-		 * that get_huge_zero_folio() will most likely not fail as
-		 * thp_shrinker_init() is invoked early on during boot.
-		 */
-		if (!get_huge_zero_folio())
-			pr_warn("Allocating persistent huge zero folio failed\n");
-		return 0;
-	}
-
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker) {
-		shrinker_free(deferred_split_shrinker);
-		list_lru_destroy(&deferred_split_lru);
-		return -ENOMEM;
-	}
-
-	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
-	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
-	shrinker_register(huge_zero_folio_shrinker);
-
-	return 0;
+	return huge_zero_init();
 }
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 	list_lru_destroy(&deferred_split_lru);
+	huge_zero_shrinker_exit();
 }
 
 static int __init hugepage_init(void)

-- 
2.55.0


