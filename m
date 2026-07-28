Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134DDC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E3A6B008A; Tue, 28 Jul 2026 08:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75DA6B0093; Tue, 28 Jul 2026 08:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BF26B0095; Tue, 28 Jul 2026 08:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4AC6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:06:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDADF1C0A9F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:18 +0000 (UTC)
X-FDA: 85038057636.24.288E058
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BB071C0012
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTCPnacC;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjgKH/kkJdGm2VMudiDfggXGTukvUfp1G7/FRSrbX4M=;
	b=CCXURRFCCiThqpNgEy6en8er62YRMgXlVRXRURNdME61TsJ75exM9ZpsZ3U6NhC7vNnJcI
	jkVlRf5DFYqtVAPvMzl1kYdIOyJ7gbMkN44sVyiW40HuqR9ZXlW2hqaB1p3j42SXr7eqHy
	bxjwzSxlsQFI+olUa0U3+CsO30u1a/s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTCPnacC;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240377;
	b=qMSRj2TD6g328fsgwgaU/5TY7oRyNpmOdjI/qqINXNpR5d09UzG0w76jis/GkRjrBMVXzb
	J19UkJzOgrynHTUPlj1vwuP/NiSnlBZVW/Q7zBG6djL6zKqr5giecfuyMZ2znvUgAkTIUA
	tNi/r/FKyY8qTJuGrPXEts9ZtHvm/Jc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87E7A60AAA;
	Tue, 28 Jul 2026 12:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17191F00A3A;
	Tue, 28 Jul 2026 12:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785240376;
	bh=RjgKH/kkJdGm2VMudiDfggXGTukvUfp1G7/FRSrbX4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RTCPnacCxEmlvezLDHXwR/oIW5fGnB70RoTj2f/08M6cydz+roZXGqI2TnwI3hV94
	 1uJYBvj34CrUoQ958hn1gfHGnRIZwlYg/wfVeP3pn1V9BxIpHzz8KTwp/305RZhHFq
	 KyjqOSAJFt37wN66bl3ZlCMYrKpYVVucPEapaaknBtA2FJdE7V7iGwqbQtQPb1dbt+
	 VPZMgIn1DmajkR1je8GuMl2sNOh2ipHRJ+RDm2E41n6LO2E7zFJcqI0xZ6Sia/OLDV
	 RSbTYbVs2wuwhbayZI+tbWO8nxipeLS/+JYjfJcRf5ryFUtRwvbagAZCEm3//tiGPC
	 Iy38jRzYGicQg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 28 Jul 2026 13:05:44 +0100
Subject: [PATCH mm-hotfixes 1/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-fix-refcounted-huge-zero-v1-1-3f261f5447b4@kernel.org>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
In-Reply-To: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
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
 Hengbin Zhang <uqbarz@gmail.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7572; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a2sgHY75/sCkkIEJ+2hyk3OnRW+f6UoOzAj9DJaHb5g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIyZist4VjtpSfbaZKku6qHgbnERVEjpfRg+//da/6vT
 rjesWtSRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACby6C7DH47Xx/i/KHYvzF5R
 Ozd4bhy70u/7T2ZOn3C0TaIwZG3Mh80Mf+Vn2dnlnL6/WZfnX5P+clNVR4Unqu+7/skv37k9vfb
 KKjYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1BB071C0012
X-Stat-Signature: wnmdm55absdqxn9sdo9qxuiy6k69xbac
X-HE-Tag: 1785240376-962765
X-HE-Meta: U2FsdGVkX19lkZDlGcVBPDOk4C55FWcBdN8AZtJINgXreo5Stx54NiXP6iyFb7zg5IP13HoEDUbaAieLxpK71soDVJcpmmEXsMRi6PsUWdW96JvAZhDAu9nhy8IlzZN1wAVd6NYeIX8yHE3NlcHH4AjiZa4v6U08f8r3s66eznB16tNZN2Jt54Useb/FW2kQvuBvehi2IQT9m+zFl6wQSXeAoxMZ/r50YRJXob7m0yL1oRl7MLiB/or2N5Qs4zLFdeYWGIh/e955XZMhlffZKVPpqANDvupx69UdhjgKKnh9+s677nC5nNvk1bdIXYqyjcFWZC+pb7nU+FwGWpWWk543sAH4W7B9zIbovdklpWKrg7OgDYVltwqPvlUKHFzSTY67O+QI6anXFCApt8w7Xqv/PDrssuqPEDyhVVuYNwxIylFnpJbZwyyTWo4/iZBkGwY0qLVBLHIQ2bXBX2CAfIpE2mntY7G2a0mvZRD2FPobPqlLzo/Z2qEDgwjxc3tc/utVvOL72Aa4J6Ko4D+/3QP5VLX9XWz/p8B0TWTxBvQSxDw9C5LbZilmsZRKaZ3bZ3XStv5EhFf+MfEhS6lC7onCkLjel2RDyUBWzVJP77zll8wr2St6Vm+H8BqnnvA6ldWs4NByGqJOR3Gp63OZL5HvGLMLdptX7wkqreCP4yQUskTne6NNxm83F8IbMuekFN/nyZMdUNkTmOTP64p7sLfXEtDRVyJPNuTKEbgLCNjqN9kbAwqe1TmzE75UhvfzmXxsuw8cICE615OUXuY5eyp6NOTCA7/dRrnjq/1u9Q++7fsydQwSyg+O23JutNvrt+KpAJu+xxMHOCnAOs6QixYEI3y29qpzArdLLGnLuyV15jo3rUorlzrhNSuKZeHk/2DrbcMGC6+bZGDhavDrTosBlJSs/Mos+10lVRoOFvEVSg+jPPtLFZRwnIy4kQn4g52SeNmjXa+pyss0+R3
 Mv5XzjAi
 SUV22twp953HPNRZSx4FAgu0fd9n/T1rfLOSgqWzkkA9OrhzrneMpe6Q5bd1SzZhpBJnE9l3wbpqop0gVtjMgM2Yn7SwpFQi9jOcDOGF6llIONKcPI3QIWS6eVgsNYNHgodgV0H7viNjQlsgiPQilNFMwzMcjPINUUoeyFduVBEgziejwfSjoozJ5jhcLZxfoRgfhopl8igZSTZYoNxfAkvpB8s9wpqQkr2UyyiHz8niQVMnvJpiHLai0fegZBtmrHLYi1uWwo17lA6Dj/7l8D5GJ8YIlx8KWH+KU
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
introduce the refcount and shrinker if !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO,
abstract initialisation and teardown, abstract the huge zero folio
allocation from refcounting.

Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.

Without this change, the subsequent fix for a subtle race is harder to
understand thus this is a dependency of it.

Cc: stable@vger.kernel.org # 6.18.x: dependency of subsequent fix
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 159 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 65 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032702a4637b..0f60bc82e87a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -77,9 +77,14 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
 static bool split_underused_thp = true;
 
-static atomic_t huge_zero_refcount;
+#define HUGE_ZERO_UNSET_PFN (~0UL)
 struct folio *huge_zero_folio __read_mostly;
-unsigned long huge_zero_pfn __read_mostly = ~0UL;
+unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
+#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+static atomic_t huge_zero_refcount;
+static struct shrinker *huge_zero_folio_shrinker;
+#endif
+
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
@@ -221,22 +226,58 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static bool get_huge_zero_folio(void)
+static struct folio *alloc_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
-retry:
-	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return true;
 
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
+retry:
+	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
+		return true;
+
+	zero_folio = alloc_huge_zero_folio();
+	if (unlikely(!zero_folio))
+		return false;
+
 	preempt_disable();
 	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();
@@ -258,33 +299,7 @@ static void put_huge_zero_folio(void)
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
@@ -300,7 +315,7 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
 		BUG_ON(zero_folio == NULL);
-		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
@@ -308,7 +323,46 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 	return 0;
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
@@ -972,39 +1026,14 @@ static int __init thp_shrinker_init(void)
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


