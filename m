Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2022CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C6D8E0096; Wed, 29 Oct 2025 11:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EC48E0045; Wed, 29 Oct 2025 11:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4F98E0096; Wed, 29 Oct 2025 11:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 182798E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE02014088E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:14 +0000 (UTC)
X-FDA: 84051611028.29.AE4931C
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6E28C000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k4lEQVrC;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz2hi28hudNS4IT/qIl1dMVj4a37Bo5V3Z4J+XpiKOE=;
	b=YEwvDYt7smhHOtK9l0IVy0lNd35J6X7Cysn+7qP4iUSP/larHr9IGHrs2YYtgozvKn/hlQ
	6UOuHsQAe0KePzlO+mAnBjSycbDq563EzSWH22T2jRcMYzjNHEV9EG8oeE8AR0NxfAgBW1
	TyC/P/Xnjg+LY0USdnBpEJk3xG27oIs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k4lEQVrC;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753553; a=rsa-sha256;
	cv=none;
	b=KckJlupmVzAYiZpCMu7H/Vy5R+ib/T83skPIKTFJRsujPBzVPmt/RFsb3+qhkVaZS+RHtn
	AhsiFXxTPLrKZPTGtZBph89qolQxYhMl0+1XvtK4tTd0YcNrbaPeqFm/au4kBZuVFP683H
	UM9bQEoi0iz03eCXxG/XfINh8oYdmzk=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33226dc4fc9so82220a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753552; x=1762358352; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rz2hi28hudNS4IT/qIl1dMVj4a37Bo5V3Z4J+XpiKOE=;
        b=k4lEQVrCRYj3RcAFpdAYrRctz8gGoRnrRE/Yuyz2L5zQzJbKO5/61LZCI7xhk15uLQ
         zzi7TimezfnF4ghRRsmTkcp7QL9IyMUWhnoDgt0Q2wpxhG4XbliIc/3ni4l7TO/h8jPj
         4SAvKDY3SZSREnH9+wPAxozFPnTaSmdG/9jQLxGZeGmUazcpd4x/IE8iXltBLAI6Q4zi
         PlmroBvgVO7A5AwAVb/Sg4OKb5laBLhXldaQ7kq74XmZ6XborzDnz3so3TR+cwehPX/9
         jrYivWHDIPrV9WkIM2gLyndpQTRdsIF+7hJn57DJcYrwM6PLv5vU1wS80ji4Cr9s42jQ
         uyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753552; x=1762358352;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rz2hi28hudNS4IT/qIl1dMVj4a37Bo5V3Z4J+XpiKOE=;
        b=Z9MWS85qFvMn+1QTDn10yxbfWo5CaHEyFKpnCbvwthC+AVORAlOXszCerB3JT/0wQm
         JZQ6O3BjpM3sKQ57CO8HutY58yjpHNADcoqH/N6NppfRToN1hF8n6eR38LO9FAYh1NRO
         Cd9Py2SXmNixk7ReeGS+Qxfo/ASxtbwFyEkgvmxI6XEsXcxvIuQ79j2TvduVuNS84b8T
         q+3z/JFC476SWznVGMBOk4UyUElMMOOjIJtBlED1N9QvA53gOSYcRmE15pPa6pEK2Fui
         gALUZaKUgMtPxsirmqSX4HMwFg/c41fqjpoq8qJkAYVwXKocr+XXU7Hd9iD7tV4Sw+Ab
         xUpg==
X-Gm-Message-State: AOJu0YzGs1t7RwgNDMfUYsAYBrcybpxKXkMWm4yyj1yEnMOB70LorV9r
	07gzASxboJr8GYYVXcKAMAmTvH/9aMHOIgdhKuCTzzMypZMsVVE4gdgQ
X-Gm-Gg: ASbGncsFJ+ZQtad+HE8SYaUUvFsat5D789JL/5QyBigmJhs3BbSEFv0+PZ6/2q+QjWX
	gntQKKYSl/zrNgSKfH07FUA695Jlr0qEWVvb5ehtON9HavSP8iD7PROpZ2kaiMZdKtgqDw3FbdZ
	8tke62tJdRB9gQkfwfhheKT5y7VjNAxctEWno/+/wXBUORCQ6BqaOjx4N4LW+i0wl8GhLXR2ok4
	ohuKf/1KWPNOTXXp9+XhjpNPgSOKbnPsDGsgIiFZta58JZygkreHnZw/ttaQk1+FiDNBboxfQuB
	cTXcxwtOCG/A8Wz7Tk8ilil1p/O8g+YCJpz7z8QVx1Bpxch5Bmj462nioAhdvjwbBvbVZbavveh
	9nNV5QKjTJPgf8qFtIMa+8nJ8KU4cbX3Qw2ZCzK0xjWxAyMQgkdrKlXZnHRP4QA+qQyaKlOTxN/
	6NnUU+Fx8cndBTzX02ITr+
X-Google-Smtp-Source: AGHT+IE9F28VM9txLlXQyguLph+CDkmsOFET1zyslpkasaXaif9c0pcrkP9t25GnzgOy0wRXAaEphQ==
X-Received: by 2002:a17:90a:fc46:b0:32e:38b0:1600 with SMTP id 98e67ed59e1d1-3403a25a8e2mr4106451a91.6.1761753551634;
        Wed, 29 Oct 2025 08:59:11 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:11 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:29 +0800
Subject: [PATCH 03/19] mm, swap: never bypass the swap cache even for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-3-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: 3cdfwmdmkxcsyb1nyyy38jm4ukamz9gf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6E28C000B
X-HE-Tag: 1761753552-625768
X-HE-Meta: U2FsdGVkX1+6bpgCVjXT1joG7/fQWtYM0QP4p2SiFB9rNWa+aJ8fzPUSoJWu3k9kJgM1KGvdtBJ2Vesbzve4XtA0eoWGpRjBA5nnJy+qb/Bd/hSQohrrfNrZhk7kflBmospioXSUTW6rBl7pt32JMlIfT8iC118TnE+qUOB0lEjc1qoI/YHL4lwM1HYdlryau5Iwtx3ZDCPDrDBSMLGwF5iAFm29v2OAcB9r2evHgDynZUupp5g/RTZD8YonojyTy/niORdRwyVOq4Xe9CYG6/8xCw1JxUiZLX5MWZL01JWe83oBF3FBchKG8ydvXDpQ4hpQX5b8Dn8xANfhh9+NxK9CNOs+SyaawLxS4qKAXN64DKoIyr1lAetmO9HcCKiT0pJ0JmSjYWaNZZ8wdQJBOzfl+JVBzmJ4Ooygt8wO27BBK92OPF8AE2uRM+hO7dOjhEexXnAXtYyuzWfL3N0g4YAaqTWHBSUwCrvV57hXeYdrFzjXvYlze6UsX38JBsOlRUuFmQ9u9j0vRpfwK9LHdrFdRUjs0xUyj3Ko102yo1LU3DZKbNd3biAo2JkT88pXYujy6KIJjK6qIP6p1STTt/ICky0gFLyrEZ+eXIm6lzBmyytNyA09jWmprxaFitPG8nu0XRLdisKz7EmkLcZy4nAxgR9HjH3akjLCrOX6Yy7S7yahFoVi1R5/CcPCG+lYc71eOrwfS0DYWUHXDmMFiOxCZ8csB5piZjnqZoiJNKfRRtotdJzcUuaEjkOpzG2oErjbRLZJL/scdrm4V/PLQo4ZJ6Urq1nGBhagp5s15R4FAIZsoeO+p20030l6f3VyvY6IvfrHqRRjiSVbapYeJoeBq0SCaX3SgRENrdx20QokCvJiuCmY/7aOBwzODlL0l6OrNEO6wL8L8+70Jqf5ZeDBn9Uae0wpi3iMB8oCj0AnTe6TgqtKGF0agY7gYtscggUPmSNK/IENelMqVnJ
 X1fsRSn1
 5RPcIDrhYeltfuuPo3G3Ne3IUqdVBe+SB/k6jdOoZlx1JBkA8NEMLn9rtk7Q5GcAiEFqJsuW47B/KKvKueI9ts/GiynB5Or2Io7Iin8h2j1ZERr8fhg7si8JuMXifFQlzbiO1asWXg7FgAmpaqhtLE1lj3LNnXWZfAneIHnaAsknaicBiLpYpChWCUSv/ZJm++j6djzwyIAJbOEgWhnAUN63QxhU8fc4Mu7XeVOzifY0Mt8Zp+U55qDHRps0aoJ7Nst4FWjMP34yPZUkAaRPJi/XaCDqcLcw6Tun/99QscEJihcXPTe6SXfKNnyUZjl+lT9A6ljnTfJAhMxMJPqcgFUDhTVdxdJSw1IOyTBKG0Urdl8jZNvluv6Do7ltArJkexwX9WkA7YBCPN3/pTIbxbhVG2UdiJAiOHqp2wlBmgc3Ylx7rL27TjOAQ3IkFoEs4ZzOjE2BWmQXUep/M77wEbvWcBTl3IIUG9tXZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial, bypassing the swap
cache is no longer a valid optimization. So unify the swapin path using
the swap cache. This changes the swap in behavior in multiple ways:

We used to rely on `SWP_SYNCHRONOUS_IO && __swap_count(entry) == 1` as
the indicator to bypass both the swap cache and readahead. The swap
count check is not a good indicator for readahead. It existed because
the previously swap design made readahead strictly coupled with swap
cache bypassing. We actually want to always bypass readahead for
SWP_SYNCHRONOUS_IO devices even if swap count > 1, But bypassing the
swap cache will cause redundant IO.

Now that limitation is gone, with the new introduced helpers and design,
we will always swap cache, so this check can be simplified to check
SWP_SYNCHRONOUS_IO only, effectively disabling readahead for all
SWP_SYNCHRONOUS_IO cases, this is a huge win for many workloads.

The second thing here is that this enabled a large swap for all swap
entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
also coupled with swap cache bypassing, and so the count checking side
effect also makes large swap in less effective. Now this is also fixed.
We will always have a large swap in support for all SWP_SYNCHRONOUS_IO
cases.

And to catch potential issues with large swap in, especially with page
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
 mm/memory.c     | 136 +++++++++++++++++++++-----------------------------------
 mm/swap.h       |   6 +++
 mm/swap_state.c |  27 +++++++++++
 3 files changed, 84 insertions(+), 85 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4c3a7e09a159..9a43d4811781 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4613,7 +4613,15 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
+/* Sanity check that a folio is fully exclusive */
+static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
+				 unsigned int nr_pages)
+{
+	do {
+		VM_WARN_ON_ONCE_FOLIO(__swap_count(entry) != 1, folio);
+		entry.val++;
+	} while (--nr_pages);
+}
 
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
@@ -4626,17 +4634,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
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
 	swp_entry_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
-	void *shadow = NULL;
 	int nr_pages;
 	unsigned long page_idx;
 	unsigned long address;
@@ -4707,57 +4712,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4779,6 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 	}
 
+	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
@@ -4848,24 +4818,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4909,12 +4861,37 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
+		 * same exclusivenss, only check one PTE is fine.
+		 */
 		exclusive = pte_swp_exclusive(vmf->orig_pte);
+		if (exclusive)
+			check_swap_exclusive(folio, entry, nr_pages);
 		if (folio != swapcache) {
 			/*
 			 * We have a fresh page that is not exposed to the
@@ -4992,18 +4969,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -5043,12 +5018,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -5056,6 +5025,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
@@ -5063,11 +5034,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index d18ca765c04f..b3737c60aad9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -544,6 +544,33 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
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
+ * and this raced with another swapin, NULL will be returned. Else, if
+ * another folio was already added to the swap cache, return that swap
+ * cache folio instead.
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
2.51.1


