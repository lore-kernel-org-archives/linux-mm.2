Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6241FC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F306B0098; Fri,  8 Aug 2025 08:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0001D6B0099; Fri,  8 Aug 2025 08:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F526B009A; Fri,  8 Aug 2025 08:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D79316B0098
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A433DB6377
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:12 +0000 (UTC)
X-FDA: 83753477304.23.749D2D9
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC47020006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=QGUnXZHl;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/ct59qYuG3RzWBHGmFR3jjZkQ8rYUbub3Dfwy3OQL8=;
	b=p7yIrnDaBbTyoKjWlmNqabL/CYSop3dhG+ygPayt4km6mY4ybDHNJfxrfFIEs/zIY5rD+D
	bYx9HpbapgN6aYMeWN2p7SC2z1wAU2EZKtPNzOT0rfuzD7nLu3muFdaJS31xI7+ZOhHgGw
	aCu3Qc+ZAA+LoQ70IWXXBFFINDScCvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655131; a=rsa-sha256;
	cv=none;
	b=lemGG/YDR2B8cuLV6y4tUd/E1vMaKUkv3nfCzfQkvMDPX017M5qEzYhPHMBdMfGurGpODl
	WAsf70YcLemLbO75WcY9Xra6UxTM78tM017LEjKMs6c8QxyY7Y8A4eMuJhpPD/qTYJRG/h
	0Pf0AK9Ef40nlQ0wR72WNmwGWyBtnm4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=QGUnXZHl;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bz2vp6Ymsz9t24;
	Fri,  8 Aug 2025 14:12:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/ct59qYuG3RzWBHGmFR3jjZkQ8rYUbub3Dfwy3OQL8=;
	b=QGUnXZHlRNWqOMSVO0Y5Peq+yB1a9+GxThUm3ERkXjm3E9T+3p4Fj7E2d+i4XqRZzdsC3r
	vhOn0P934owXGjzttjgAXA1XHOnEQwFFS+490iTAnHUNPOvCAVIKMWL2byS1zPSb/ruWLX
	xtE7sce+hygMs/cARuruABHNlPW2w3gHC7+tjSzqSB371JD4GJD6rmSFQtSMjhNtJvNsIj
	sbYC+J8kGKhyk9By8B+/sqbS7roIpvgMRJglVsGjkX6wNmFAFZK2jiRY3aOva/TSzVVclY
	bdodhTDFWZnJjg+aXJ4PCMN8R6cf5HJqPvG+EdIx0pc9jLtTx7TGLzZ+PhyEyg==
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
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 1/5] mm: rename huge_zero_page to huge_zero_folio
Date: Fri,  8 Aug 2025 14:11:37 +0200
Message-ID: <20250808121141.624469-2-kernel@pankajraghav.com>
In-Reply-To: <20250808121141.624469-1-kernel@pankajraghav.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC47020006
X-Stat-Signature: 8gbheqti9aqyk7hh8bje7r8mruq1673e
X-Rspam-User: 
X-HE-Tag: 1754655130-709799
X-HE-Meta: U2FsdGVkX18A1Fe9GwY8yTzUrZV5vslZtsN4OCO1DyCRLuPALgYm05xefOp5oJXCeC/FwQXeetjomUcgNYiC9+BQEx68b0c050TRXthr8QA9DWdwAVMATPx5ZMYgpCqupKKBKAMvsZHb7Rwh2iq5C9tmJczXq4KDp1dheKyHvTAWP96KSUK0z6OuW9MBm9iHsSXvZEcg1f+lFRzISipAdatZypc5k/W1uW3K9rzU5tM0O7n+1jl9IP6yOkcy3YtpG44i2tTuLSaCxuIS441SGs/Nj86HoMvGRN7zTmq+c0DyycCIhpwErYDSRbUH6OVTKB6KTWUiH9ZJe8A6XRLL1eqy6qTEs72tewt/VwiO7fodh9DARaVb6xNuHX4k5GJzrfcMQIoH0rTZMs2CA7z5msdg+ZhjICXAfU1kVwzfbHj0F98UL+gLJQdIO64rYfVaQdG13/oiKfDB8LlwGIj4ff9oVzQmIT8IF13RQtRuo2GeB0xDWx+5hovgnE0InBOvXYctbSo8ZjuGeWd/fjHEPNaeKMpVWhSp6bIhMrK2dDmzo2i/xar4AKjYQ9e6K5upz+jlGJ04Ddbf3FxVgse8Vnpc852ITYgCkuDlZcJSHC9V6Oeleo+dBOW1bX5EjyFzUA1Qwln152K8/HTFPzFpUKSnGPmgD42TyFwO5ATNyP/sUzVydrw5whf7muiTVcomIM2+lMZW9OXQXVXBJpJJggSZxPBr+VED5wXiO0ZBBYapWCb9jSjOUSCnHxhGIuNn6E1WMjv9SNuKj4ylWBHAgJbDKuVOaWZwrBUKH+CVGwycVXbKVfybsEJQb1Nx10ZlMsXou/wno09Q7aWktYUtesDjHcT3p82Z9Dn/Sgho15k5m7Tyolc4aZAR1HLCAsq+ydROEEjQNF52tg83iplYG/zeP06EjOtW4/YBXF8Hv7MJ9YgHcvYZSXLwWR8hCbTQ3L6LiCwFrEPR9ZSjqye
 GhNORmPg
 f4ZG6sONj17EB827A/JseM7O8uK2b25Gt/89cwDnmL1T9sW+a2AO/vJlKRNqKyupZlU5NswQqIPlDlKkiX5kT84kAGfUmeT8tIE54W9bX2/jdqSNM3hInGhliEmgpQ43nZhiw1t0Nqkd23tiMppoYPPUL+KnVvHDvuT2wN2UtPbJYeKUcw41iLAwmc0fQNbaqhe8+19W9N9vH8FF5DWmmCM2OY1fQ5kx3O890oLjgCelDk2MGHglsLNuMYe/3fStaker9/TXCdpBDxipV4Uot8Gjh+RppDfJfSa8R+kPMSoJ/RP29j1XEVviiQHGJUD8jzCMM2EN0WQcHpGTYgUgfxdxVdSLnxib/HVq8SHFXNaFR7iLGJBD3yO8ovbjMeaAu8RlLb82E5Ps7Z8GnTWF37hd4btvR9um9bxZ76wB0za8rubkduMlPEWCYqXHEjI+aUWR8qjNSz6T5njQDBZGPit5sVRPZrC7rCN6tbhtDMr/I3jXHrPP0rVBJfPa5rSqZy+dR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As the transition already happened from exposing huge_zero_page to
huge_zero_folio, change the name of the shrinker and the other helper
function to reflect that.

No functional changes.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 mm/huge_memory.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..6625514f622b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -207,7 +207,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static bool get_huge_zero_page(void)
+static bool get_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
 retry:
@@ -237,7 +237,7 @@ static bool get_huge_zero_page(void)
 	return true;
 }
 
-static void put_huge_zero_page(void)
+static void put_huge_zero_folio(void)
 {
 	/*
 	 * Counter should never go to zero here. Only shrinker can put
@@ -251,11 +251,11 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
-	if (!get_huge_zero_page())
+	if (!get_huge_zero_folio())
 		return NULL;
 
 	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 
 	return READ_ONCE(huge_zero_folio);
 }
@@ -263,18 +263,18 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 }
 
-static unsigned long shrink_huge_zero_page_count(struct shrinker *shrink,
-					struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
+						  struct shrink_control *sc)
 {
 	/* we can free zero page only if last reference remains */
 	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 }
 
-static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
-				       struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
+						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
@@ -287,7 +287,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	return 0;
 }
 
-static struct shrinker *huge_zero_page_shrinker;
+static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -849,8 +849,8 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_page_shrinker)
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker)
 		return -ENOMEM;
 
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -858,13 +858,13 @@ static int __init thp_shrinker_init(void)
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_page_shrinker);
+		shrinker_free(huge_zero_folio_shrinker);
 		return -ENOMEM;
 	}
 
-	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
-	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
-	shrinker_register(huge_zero_page_shrinker);
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
 
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
@@ -875,7 +875,7 @@ static int __init thp_shrinker_init(void)
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_page_shrinker);
+	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 }
 
-- 
2.49.0


