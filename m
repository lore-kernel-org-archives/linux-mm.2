Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC343D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368A86B00B4; Thu,  4 Dec 2025 14:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318576B00B6; Thu,  4 Dec 2025 14:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0AF6B00B7; Thu,  4 Dec 2025 14:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0744D6B00B4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:29:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B299160331
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:56 +0000 (UTC)
X-FDA: 84182778792.11.CBBD6C6
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8CBABA001C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S7sr/E+w";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMtnpXktxseEAfJmqRUtm2vGM2gGL4F/IU4EU59raAk=;
	b=Fv1yHdIvW6VoHGaBsBJKmDfcTR3nIbBWx0MbXKb/9yqANRn44REii85tySEeJDmkIdhTEM
	t+rgYpiccX532o8jPRpSfGgg+1WrmBJiYGOH4wCB37s6xsMhgKh6oifRzMWQzT/ihD8cp5
	YW+OKsEK1jqeJJKfaD/H08jSeqZcNzk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S7sr/E+w";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876594; a=rsa-sha256;
	cv=none;
	b=PB6YjPYyPfUptX3riUQrFoG0Wj6eebYHY71f/NrKWM/97H2rczW07qGCY1hS6/8Dx5suD/
	5VMMLJj+ZghssaHs5oElbPGGYISad/HohpaQ95qDcHmYUdMURIqzIHaPUmtACBea7DOiLz
	WGyqdCNuwj2pJX/tSjb96hDbF1jgU+w=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so1378449b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876593; x=1765481393; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMtnpXktxseEAfJmqRUtm2vGM2gGL4F/IU4EU59raAk=;
        b=S7sr/E+w2oYrHeb9qZ5Sf9chUFjW8X28j8n5+IqqhoUhaVxcJaXLqnbwGZ3gXPG30G
         ofK8HZQHYGQD1d3E7Wcze48BaEEp2CiC/mufzCa1cOM1WyuYev/SpMzzQ9Smc2DXTB85
         1Xp7DLOpPJpqf16ja15o33xkjjkBQTkr2yCrCxrBWpRg4BggaZDUIMftzPTK+GJdXsoC
         /MMb9Az0vy0P4TELaICEH8PTYgmCzP8nUdo5i6ZJlGJSZrcxQyYX4DAO167rVM2UQlYW
         4ZZwcEqCiT5DErBCXIpQacXj+T1iDfiA2+WSfd5aJfHT7+ZO7CDBtlMLqbvPqbGk/hls
         ohyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876593; x=1765481393;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sMtnpXktxseEAfJmqRUtm2vGM2gGL4F/IU4EU59raAk=;
        b=e2dOnwJuHYgLjgrEjA2ya1emZcXNLQUP8Q+GvBvGNT0Pn6+EjN+ICJsVyDUEaKEXka
         VSDVqTlXyDPCzRFY5ehnbmmU/y9msLai4ivEtGpRgrex+YiiHYdrAvy84SrK2olJf97g
         ahWJtjwnej6xcMohDZciJmfWIqopVnFpYi1L//FGGVJvm64JXhDiS6aHkfhb+g4xoUbw
         LNKEnUYDuMEfZEZVitovW4bgv/4S2gLTuIgH5ssv/IxhY00qxli6/zbr+3jeKLe5r9xL
         3cckUQbXoQTFv0zccEvzWPlTyy+9SFzmWNQKro14+u8WQzwV/VhgM///IxpkSnLDblHY
         eiOQ==
X-Gm-Message-State: AOJu0YwdmGZiX4/MhsIWHIwUqI4HJzTjab1Hx282yAHBbg7pd71QHHuY
	gGIzxc7RTCNE3DBU3TVBBemUidZ9PlbJzDywhvQaHwktWovz4t0cuHBr
X-Gm-Gg: ASbGnctbddceupHr1y0zAk6iERW7nZG8Ofi4RrAqfuIU0+D8hIYyy3jFqa6kCgmZ6Uu
	wMaxm/lDHyf4hp5PEugR7p+SyshoN627C0D4kqiBP+ptz2AgMpp7I2iDdmk0sR1Guxa5qESKcr4
	ogN7Q2M7nhMe0K5d4vlydU1zsINA8fOx4+A5Gi6R4fvy8pTl1Hy6RO6vgbKRizxEEvP0TRDO/vL
	NFRaMQvLO2GHIh4SNE5BFHVvrJB5186G7Hhci1q1qRTzc6Ut0uWllQNvIVbaU12PtnAg9JP/3yF
	27/TjEc9VBJjcLeVd5Rr2lkW6oXkSTekjd7InjQNuEzwvNC2eAx4nZ4lFiv56pOzuCOVNhEZ+MZ
	3CLrHDtxmA5LDh4sm59GzcZ8COHB+IZVNAt1jZrznINoRx2iP1Ng/R2Vmc/eeA2KrlwWEXJOFt4
	g3P55drRG+7jga5MeIQX31kLismml1/0r14m1fpWkaP0TejjzV
X-Google-Smtp-Source: AGHT+IFDml4zNGaJ1zKmMR1NyN0gSdJWNGBXLXoW5SMl/nv2qV0kjDFsiIu04w7rnc9M13ijsMxP8A==
X-Received: by 2002:a05:6a20:7d9f:b0:35d:8881:e6ce with SMTP id adf61e73a8af0-363f5d738bamr9164823637.26.1764876593300;
        Thu, 04 Dec 2025 11:29:53 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:29:52 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:11 +0800
Subject: [PATCH v4 03/19] mm, swap: never bypass the swap cache even for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-3-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=12641;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CXPZcptUllHnmdZrRzWq+Am/UqMjEzTPQssi/cWdxwc=;
 b=Mq8neUUI2VZYCEQdis3FGQ9Tf1+Kl2YdVw2CNc1nR4f7MzY1OMAtQVoYghMAIFHhJIpva9tje
 FkknpeBDkYyA61Ja0M9R2zwn8mnneUgNWTsioY2qPGQmNO2PKt4UtbK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8CBABA001C
X-Stat-Signature: x5we3da6asiqg6kg6fjzubtukew16bfb
X-Rspam-User: 
X-HE-Tag: 1764876594-353167
X-HE-Meta: U2FsdGVkX189/79IUCVDmX00uBBt49AAR1azJ28sI5VID8OoQqLbUI2Zfs8/7sjCgtJKVOrOP84o0lL/QJS2bCE/D2gqpQVYHXpDpnik8GgDZ4hGzHhVSn1yuLgvdQceaCTmwz/60pl1OzM0ly/AtBtFSTrWwHHoeElmp79mwQgm7/nIN99sSCrRHSIsSr8CkuWyK8befapuWV8aza8nNL0pLvb1Qvc9vwdZWv9nohjhuWWRfXTYn6bzkwW5RK7wLTvqoV96qXetLz0yCqmOy60UcHqe3oONNH21tlUJ86Spj8SeLa45YZc0m2l/EhTGw70PntxWIjT5XuQxB5r/yXzZR5yByB5jPV1kNDArmxnG8H3h+JiXDK3oVvT7psKnpEKwbfZZJNbVXYcApV/1sjpPgWLlI5vv1d4qvg7YbJvqiLfHlRSsojywivH32ULYJth0W0STYA2P5uR1NghCVYpAhIs8WxmI3k6+xDpdTHmWTcSd4UYrJW6uoBW2dqOUByw1DbFvv3dwuHYL3nl3KhviuWEO7KyHi5AWqbBQ1PMg47N9iLVfTDoDcIlcunf24bUCPm/NzpHhrme0+2iwiaJUyrmYYK5hXqllIFwrA0Y5uaHGTJYtr65+9kzh7MdWI6EnF6mAiFlL/OHHotxpCcuS+P/nxqxwAxqkK5tKbehlOM875cnybB6jJcE5oIwNoM/GfWuIAU2lZyIL/r8gGI+YiXKT2jEvkeCEzRsWVMtNzmoHC8+hSMdDEOfWc5RYcsCi128C8Vr0p+nYzk4mTmJJllmzDooorJhbsrz/BcdL9Z4BYGLwuQh/ObxLmk7P/sMi6pyUxAY0zJoOrsEiOi3xgfRE8XMwX8jG1UYG9y1j6bVSgZWMdF+vx554vTDwbjYJPca5h16sy4ue+F5Qd4PW8pBP4mbG2a7fYuWORNJp35bq/uRlV3QnydJKOuw/UJ3BC7bYABMyOjn7hLT
 KqsVtTOM
 jnrz4obE85tEBWvqNbSLPhJ7QHS8QXgUzL/RoQOLVQJLkL9Yc/T4agXyASzKEHfKfdFO9SYvcF6IaWriIx+8J9ewkqiSRv+d5SpEx4g06iV1SyQQcwtpzys+zKi60vuCOlJU4cGSzDkdzjZlwd35woy8Qlv7ktzMPdP0WDpu7HX+TQsl0CoETNOPT1f+JG2Y4+1F1xZ5HgNL32hAr0TNoFWHGdjNbC3ws1AdikxXEHu4mqQdPKcRLVKxHZmbXcvdT3/umib12hhpbQZ9b7Karg9sWf1d7Hc5nQ6hpQQzrlRRm+cMOVvjKdyD8z71PqS3SDVEaMea14r5BBptO4oRZpTZ6dSfvqvXCIXVhwiZubJvOBIOCnRZe7LO1Bx+ogTsgpsTTdbXsbBNN2JbDnEqTReQLyVg+NERmp2S2Oo0tChvJZy26X6Uz1Vb8Onpim3csqBoLLPKu4dLgzE53FlIHLebcLA4WgVVKna+M
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
index 6675e87eb7dd..41b690eb8c00 100644
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


