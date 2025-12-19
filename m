Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E32D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77F86B008C; Fri, 19 Dec 2025 14:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07BC6B0092; Fri, 19 Dec 2025 14:44:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9842A6B0093; Fri, 19 Dec 2025 14:44:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8264F6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55078160163
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:34 +0000 (UTC)
X-FDA: 84237247668.20.68D635E
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C2E140010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HakHnk3V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173472; a=rsa-sha256;
	cv=none;
	b=WKfry1fp0HcG0pC0mPdfG3l6ZB1ywS/+Io/lRS5aA2kr2ylXnme9MKRpll0dGu3GZ5b/ef
	lWRzz95yTR4HIbjfC2W21p2beGRPWdDV3BPyG43r1U/2gUO+ZuZR9+bWN3j9ChtcQv8BiU
	fsh9njT+b8vz2AugbhSe1Ia70YHD9FE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HakHnk3V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wdy65Ou8JbWRDmKXo9PQRW4JzY5cc2LJzS9tndH63Hw=;
	b=V7EzuJjVlD+Jmncu1I5XBFQL0axDJVXJgA7iFQF1rEJfn2Z6+MDQxaL2fGwvq7FlDDGIOO
	6tpH65VfrbQjlsArQDD3gCHkJhufrefreTQDNITsxUdhqqCU9cVDQqUhJla8JWE9DiIxRi
	v/rS+IRpUjPJZxN9k0jljufZ3WmaSxY=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a0ac29fca1so19268325ad.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173471; x=1766778271; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wdy65Ou8JbWRDmKXo9PQRW4JzY5cc2LJzS9tndH63Hw=;
        b=HakHnk3VrocdEHv9kSw0a95wZC0mk8iLrqUYmllZamjs1b0EQcFbaWBpYhZltKGCkR
         ZPaOukzEdTQy9BUNE5iyWiGHa3WrxLRwYYA1+vLP/1pidPgLLtSFuamXSqLOc1VmaO3V
         T8yT6htu/xRqZANTT1LZWI3Uz2M5qPtEEE3Kr3b1v1Iu8r8Wa+RmTr4Kx47jl80kEDMC
         Krs9dxXEDM9k+0VkX7/sMOD/17t7fT3iv5JWiPFSciQEOzxpZpyH7S4jRxPlob9vMnRr
         /36UEbaC/na4StccdkAllX7RF4vbdUK4yZnUYb1im3gmyWs1+pGkDhozW6ksnZOXBfSK
         jfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173471; x=1766778271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wdy65Ou8JbWRDmKXo9PQRW4JzY5cc2LJzS9tndH63Hw=;
        b=T9ppe0DWPQZ2+NVFWAToqAU/sNep+xnm1XZQJB7SiRWwnT/HnYvE+YdZnuF8WuP6wu
         Fyhos5hVCDs2mpm9FtNyPs/ukZP8+JErYHf1ZP1xpN7gbVBmfm5Vvy3M9zHQnIPpJr2M
         x276s3TvSXqP0WJeur8B4RLGXi5fOYZkW5gABnz6w9+e0QJ+d5HIgSAhAGALPt2ewyHw
         kzhcSUMZOAcJXbXHe39M8VqSPUx3hdGoWMR4AFgmGqjqrZXXuIoCI49FAWi3AFkqAeEw
         Gq1RWQo88lVJnbmwA96d6Xs3yi/KLWDXb+sBY5Ok9WRMpzSupa7QLXQcHkxyNFDa9BD3
         3pKA==
X-Gm-Message-State: AOJu0Yw38s15GJ9C3NrmnlMDubc1qb8clz2CZpbd/P+AdBG3RezGHbyd
	OLCGNL9gB9CRg5yVWR8CvBOt4K43BRfydNfgnqhLhPUVFTzriRYv7W9F
X-Gm-Gg: AY/fxX5JkIQvH5sMdskRxcfVqsAA5yGwAdT20kDmSyOS7MDTDSg74rgssn9wh+Ev+dL
	wn7MwiQpYUGmNtxsf/2K3v/e2RtZF/IoTCgChT3SLf+nhRTnQdj8KeFRLnnG8ZlT21AGdvdNPgT
	hWISzvWCjaIzQl0+THc2DxR6yxYh7Rl/ABhX6QyUtxBdXBZ4XXadEYxc0X2m60I2Z1xUK/e6VQy
	6wt7SDnzcmCz8VIvAseEgTLnfZqtd959r4dQIKtNIjbAIqwMq+tYXi8JIpAm1wUfInVrKrcqswr
	6k+jaqCXSmAr8DfTQXRSeBnIR5CKTwcYfjmvMNsMFzVuN+pHSWuRYMJR7sX5Cdqz0X0hy4d9s3w
	UXzrP/VMS6Jnyjm21tO/fI90cdMF7Ouc/9SIlyZNRyvg0v36go1wOX74Bc4eFKC6namek4I5B4r
	uIHL1ArzW8lnAp6APau8TXThhDRXw4OicyEM+etLDbZHhrd3HVESLv
X-Google-Smtp-Source: AGHT+IG4CDonbV3GFvhsjxzJk22Gacbkw05BqfVp934Sw3htWv1tWnWtHgdeJa2AVGj6kHEDd3u2wg==
X-Received: by 2002:a17:902:ce8b:b0:295:b46f:a6c2 with SMTP id d9443c01a7336-2a2f27325d5mr34529775ad.37.1766173471122;
        Fri, 19 Dec 2025 11:44:31 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:30 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:32 +0800
Subject: [PATCH v5 03/19] mm, swap: never bypass the swap cache even for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-3-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=12641;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+3pLR6DNAmoEtneFzdsLDCbvXyTZwRGJx+xHGBkb1j0=;
 b=0fD8hCCxok4pcURnS9vGRUviNahfagzA/y3AIqUeiBm+PgPFRAbUucN/XlEBrnO6zGNr7P1pT
 HASK/jzthWpBtDvvkWWv3RW3Hb1YqcJ8Uw/NPFVuxvTNkyjGBSP1FL7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C2E140010
X-Stat-Signature: 6a385enjdie7j7eckc3grnhoucuo5tz5
X-HE-Tag: 1766173472-729418
X-HE-Meta: U2FsdGVkX1+tNzGXHMoUEF6udbgUw0wl31R6jsoMeCFQtVVM8sPA+CrSr/rFF0vrGpShrykcujUOvQNOFi/5mQ91ZK+i3nk9J6G6F7HxCUrThQeNTlKu5HIENKe862Wfto6zwWns44hf0k3FqgRhiqwZ1aZHahijon+/Hmsr01jroTWG4X53VYPve2RRNHCs1J51M9sHj+Fkb5hm4cpBzXYDHssdrmFAiAsHCFr8kDizJcMQLnu+niQhX6O62bXsSIGWNtz/q1ltwVu3iX7Kn657I2PWKEsB8VRIMwstJ3v0wzEh5yijfARiIMRkzH0OJyX1ALxxkarbWLxiGiOaK4DQkvmwQJ4W6BYCkRLfRrx2gErfJzuahD5JGZqZipj/xSsEGSP/npHX4h4NNrHtYNsgmc9KTelilC1ML5QrUDu2oeQYyn8Ot15P7WZ4sI0gb1sxwWmIbepGzPo4mix6vNd0gSyA7CDJP3lm+6K5+5Jo32gPjgB/QTFHhy/ukEyZoA4q8+SApgNozk5b63jHQ9LnlQvkM8KDp9bkjubZLj7AiAXnDfM0CsK/sbuTgkXDi/TlCe9t589rTs3WtPLhXNuoukJHgnce+T8F/KAMW/xWRp0JODMciNtVNRGyHBOk89x9w07OHfT2Bbav1uhQt+h7GbApwXPUNj+QuKmsk2hBTCfNWQn+mRgLgaIlsn+CLd7nChyTFCJclPnW6QLz5za9bxue+9q/zuZZPT5/kHBzzabmFBUlqLlka2ftrRnH4X5Px3sZzd12VTCDeFibx+Q34hfP7AbRSko+VUpFQl6YkEfL4aKFRxcLT0irXddtNcHRBYUtOVe2NGO6BS2NPB/PtATTzUznGhyp0P2K5uWQagXdckKYaAcY+hV7jOgvsps3wDFfYpWYNiefWoKuxPraCzto7GEHHFPNHn3ElucTH/Ih1n3qJxdwASwICatUFoMHTN29ZhZ6VGHrb3a
 NTdqXZd7
 SvK1sKkVSc67vzXF90ogRyh3aGMZ2HUxUHG3cZI1dEcUdXtaEIYHW9egDL5V2Jj7PAdGtukHCZtArs+3+oKmpg8aJtwfhtLIM4w1j+5xEEjlpodUlZVX8ZfxmnD/Yr+rxyLywij/T0k5u72vTOjmdw007LR5G2v46gW4MpZBLOZQQ0ajamBJls+l62cGfblb5tuo/mtskqk2a1AsMZUsNMGXSp+dYjAi4jJ9JmT9+X2aqeO5hI/cbdF2LuBvQNO7F0ws5FUxGzH1D5ayUrn/YWA9S+Aaxy1ZTT2kgjZr40CYdCwdmgOcS1LjPv9yjKIblo7MJK8Js5Xy8mTf2hJQScaiWMT7B8g2ti3kyZOAJ8Nzt99m/wbq8+GoDmfNTwbqteDV/0yhwJ+SzMHbniQjArUsL7esrB2f9P8dHKGp33Z+3+iqdgQUsIqcUnQ+NxISCL4hVENEEIuDtTYymzRCqplpT1TZEHkfLHpagZXwD7eXAk0Ih9XTyQaidN1NEIn5fqlMgSWWJWsBZPK+8THL8ABGvlh+Nlkhy8vvmDEOenCW4MY6GRVArWP5fcGwGJ4Cg84Ai
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial. Bypassing the swap cache
is no longer a valid optimization. So unify the swapin path using the
swap cache. This changes the swap in behavior in two observable ways.

Readahead is now always disabled for SWP_SYNCHRONOUS_IO devices, which
is a huge win for some workloads: We used to rely on `SWP_SYNCHRONOUS_IO
&& __swap_count(entry) == 1` as the indicator to bypass both the swap
cache and readahead, the swap count check made bypassing ineffective in
many cases, and it's not a good indicator. The limitation existed
because the current swap design made it hard to decouple readahead
bypassing and swap cache bypassing. We do want to always bypass
readahead for SWP_SYNCHRONOUS_IO devices, but bypassing swap cache at
the same time will cause repeated IO and memory overhead. Now that swap
cache bypassing is gone, this swap count check can be dropped.

The second thing here is that this enabled large swapin for all swap
entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
also coupled with swap cache bypassing, and so the swap count checking
also makes large swapin less effective. Now this is also improved. We
will always have large swapin supported for all SWP_SYNCHRONOUS_IO cases.

And to catch potential issues with large swapin, especially with page
exclusiveness and swap cache, more debug sanity checks and comments are
added. But overall, the code is simpler. And new helper and routines
will be used by other components in later commits too. And now it's
possible to rely on the swap cache layer for resolving synchronization
issues, which will also be done by a later commit.

Worth mentioning that for a large folio workload, this may cause more
serious thrashing. This isn't a problem with this commit, but a generic
large folio issue. For a 4K workload, this commit increases the
performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     | 137 +++++++++++++++++++++-----------------------------------
 mm/swap.h       |   6 +++
 mm/swap_state.c |  27 +++++++++++
 3 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ee15303c4041..3d6ab2689b5e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4608,7 +4608,16 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
+/* Sanity check that a folio is fully exclusive */
+static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
+				 unsigned int nr_pages)
+{
+	/* Called under PT locked and folio locked, the swap count is stable */
+	do {
+		VM_WARN_ON_ONCE_FOLIO(__swap_count(entry) != 1, folio);
+		entry.val++;
+	} while (--nr_pages);
+}
 
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
@@ -4621,17 +4630,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct folio *swapcache, *folio = NULL;
-	DECLARE_WAITQUEUE(wait, current);
+	struct folio *swapcache = NULL, *folio;
 	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
-	bool need_clear_cache = false;
 	bool exclusive = false;
 	softleaf_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
-	void *shadow = NULL;
 	int nr_pages;
 	unsigned long page_idx;
 	unsigned long address;
@@ -4702,57 +4708,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio = swap_cache_get_folio(entry);
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-	swapcache = folio;
-
 	if (!folio) {
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
-		    __swap_count(entry) == 1) {
-			/* skip swapcache */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			folio = alloc_swap_folio(vmf);
 			if (folio) {
-				__folio_set_locked(folio);
-				__folio_set_swapbacked(folio);
-
-				nr_pages = folio_nr_pages(folio);
-				if (folio_test_large(folio))
-					entry.val = ALIGN_DOWN(entry.val, nr_pages);
 				/*
-				 * Prevent parallel swapin from proceeding with
-				 * the cache flag. Otherwise, another thread
-				 * may finish swapin first, free the entry, and
-				 * swapout reusing the same entry. It's
-				 * undetectable as pte_same() returns true due
-				 * to entry reuse.
+				 * folio is charged, so swapin can only fail due
+				 * to raced swapin and return NULL.
 				 */
-				if (swapcache_prepare(entry, nr_pages)) {
-					/*
-					 * Relax a bit to prevent rapid
-					 * repeated page faults.
-					 */
-					add_wait_queue(&swapcache_wq, &wait);
-					schedule_timeout_uninterruptible(1);
-					remove_wait_queue(&swapcache_wq, &wait);
-					goto out_page;
-				}
-				need_clear_cache = true;
-
-				memcg1_swapin(entry, nr_pages);
-
-				shadow = swap_cache_get_shadow(entry);
-				if (shadow)
-					workingset_refault(folio, shadow);
-
-				folio_add_lru(folio);
-
-				/* To provide entry to swap_read_folio() */
-				folio->swap = entry;
-				swap_read_folio(folio, NULL);
-				folio->private = NULL;
+				swapcache = swapin_folio(entry, folio);
+				if (swapcache != folio)
+					folio_put(folio);
+				folio = swapcache;
 			}
 		} else {
-			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
-						vmf);
-			swapcache = folio;
+			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
 		}
 
 		if (!folio) {
@@ -4774,6 +4744,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 	}
 
+	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
@@ -4843,24 +4814,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_nomap;
 	}
 
-	/* allocated large folios for SWP_SYNCHRONOUS_IO */
-	if (folio_test_large(folio) && !folio_test_swapcache(folio)) {
-		unsigned long nr = folio_nr_pages(folio);
-		unsigned long folio_start = ALIGN_DOWN(vmf->address, nr * PAGE_SIZE);
-		unsigned long idx = (vmf->address - folio_start) / PAGE_SIZE;
-		pte_t *folio_ptep = vmf->pte - idx;
-		pte_t folio_pte = ptep_get(folio_ptep);
-
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
-		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
-			goto out_nomap;
-
-		page_idx = idx;
-		address = folio_start;
-		ptep = folio_ptep;
-		goto check_folio;
-	}
-
 	nr_pages = 1;
 	page_idx = 0;
 	address = vmf->address;
@@ -4904,12 +4857,37 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
 	BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
 
+	/*
+	 * If a large folio already belongs to anon mapping, then we
+	 * can just go on and map it partially.
+	 * If not, with the large swapin check above failing, the page table
+	 * have changed, so sub pages might got charged to the wrong cgroup,
+	 * or even should be shmem. So we have to free it and fallback.
+	 * Nothing should have touched it, both anon and shmem checks if a
+	 * large folio is fully appliable before use.
+	 *
+	 * This will be removed once we unify folio allocation in the swap cache
+	 * layer, where allocation of a folio stabilizes the swap entries.
+	 */
+	if (!folio_test_anon(folio) && folio_test_large(folio) &&
+	    nr_pages != folio_nr_pages(folio)) {
+		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
+			swap_cache_del_folio(folio);
+		goto out_nomap;
+	}
+
 	/*
 	 * Check under PT lock (to protect against concurrent fork() sharing
 	 * the swap entry concurrently) for certainly exclusive pages.
 	 */
 	if (!folio_test_ksm(folio)) {
+		/*
+		 * The can_swapin_thp check above ensures all PTE have
+		 * same exclusiveness. Checking just one PTE is fine.
+		 */
 		exclusive = pte_swp_exclusive(vmf->orig_pte);
+		if (exclusive)
+			check_swap_exclusive(folio, entry, nr_pages);
 		if (folio != swapcache) {
 			/*
 			 * We have a fresh page that is not exposed to the
@@ -4987,18 +4965,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	vmf->orig_pte = pte_advance_pfn(pte, page_idx);
 
 	/* ksm created a completely new copy */
-	if (unlikely(folio != swapcache && swapcache)) {
+	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	} else if (!folio_test_anon(folio)) {
 		/*
-		 * We currently only expect small !anon folios which are either
-		 * fully exclusive or fully shared, or new allocated large
-		 * folios which are fully exclusive. If we ever get large
-		 * folios within swapcache here, we have to be careful.
+		 * We currently only expect !anon folios that are fully
+		 * mappable. See the comment after can_swapin_thp above.
 		 */
-		VM_WARN_ON_ONCE(folio_test_large(folio) && folio_test_swapcache(folio));
-		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
+		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
@@ -5038,12 +5014,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	/* Clear the swap cache pin for direct swapin after PTL unlock */
-	if (need_clear_cache) {
-		swapcache_clear(si, entry, nr_pages);
-		if (waitqueue_active(&swapcache_wq))
-			wake_up(&swapcache_wq);
-	}
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -5051,6 +5021,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
@@ -5058,11 +5030,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}
-	if (need_clear_cache) {
-		swapcache_clear(si, entry, nr_pages);
-		if (waitqueue_active(&swapcache_wq))
-			wake_up(&swapcache_wq);
-	}
 	if (si)
 		put_swap_device(si);
 	return ret;
diff --git a/mm/swap.h b/mm/swap.h
index 0fff92e42cfe..214e7d041030 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -268,6 +268,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
+struct folio *swapin_folio(swp_entry_t entry, struct folio *folio);
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
@@ -386,6 +387,11 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 	return NULL;
 }
 
+static inline struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+{
+	return NULL;
+}
+
 static inline void swap_update_readahead(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a8511ce43242..8c429dc33ca9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -545,6 +545,33 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	return result;
 }
 
+/**
+ * swapin_folio - swap-in one or multiple entries skipping readahead.
+ * @entry: starting swap entry to swap in
+ * @folio: a new allocated and charged folio
+ *
+ * Reads @entry into @folio, @folio will be added to the swap cache.
+ * If @folio is a large folio, the @entry will be rounded down to align
+ * with the folio size.
+ *
+ * Return: returns pointer to @folio on success. If folio is a large folio
+ * and this raced with another swapin, NULL will be returned to allow fallback
+ * to order 0. Else, if another folio was already added to the swap cache,
+ * return that swap cache folio instead.
+ */
+struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+{
+	struct folio *swapcache;
+	pgoff_t offset = swp_offset(entry);
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	if (swapcache == folio)
+		swap_read_folio(folio, NULL);
+	return swapcache;
+}
+
 /*
  * Locate a page of swap in physical memory, reserving swap cache space
  * and reading the disk if it is not already cached.

-- 
2.52.0


