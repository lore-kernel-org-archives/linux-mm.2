Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3887CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3DE8E0018; Sun, 16 Nov 2025 13:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BFD8E0005; Sun, 16 Nov 2025 13:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1D88E0018; Sun, 16 Nov 2025 13:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F07B28E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DBD612D804
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:20 +0000 (UTC)
X-FDA: 84117264840.23.EB30FD3
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94A55A000F
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vk71Hhc3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316738; a=rsa-sha256;
	cv=none;
	b=2qOwOahQ8696ZWVQFPHbQDDNUfAplGJoQhvNZxlgtATRRcy+hxKhaYSpK+KbJTRIwEerjm
	TWNywO6ls7R+6BMq5IijP+AvBiHdT8n1f55xu3Mic9pMIE2gYtQzNQiriAdbmel6u4gYDH
	YPYcj6YxJmXk7QzQcGxWBGKTqC0r06M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vk71Hhc3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+yrKxxFBgRhUgP2kRwlDCD5oqZTa2zSHgr+iWIew3I=;
	b=tGryfVrNQhLGUX1ClKG/XthOFBgzS1IQGJlVhdVMwh/bYpsoMQf4assvCL+RCvMzsEdGua
	UKutWp/F2gbVi0b1rTjEiAVhbSCNR0dIBlhZhXR1STR2G+CP8eqp9TBmIk1zropmI8x1w2
	j6qsRsQOTQd7TaP6eo987Wg1zWr/jKU=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2ea5a44a9so43148985a.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316738; x=1763921538; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+yrKxxFBgRhUgP2kRwlDCD5oqZTa2zSHgr+iWIew3I=;
        b=Vk71Hhc3owOv43X7nP4cmPtAvD/SCPbKypmHl3s7v0aOynV/ahBbXBw241UoAuKZuI
         SO0JwPpEjWy+M0VYfcgVLDyBa/BW4Gb437hD0xy3sOr/2f9r2cRZFbs+aAI/Q5A8WcJm
         GF2RiD6cNKoj0+nqqfRZQvICXduqxsRYrvd+UEhOY7Jh580B0MSnIYMbPAajCQMUtlXM
         tpKX01/bLSnrqwTOxeUm8Zk3A0P91ZJnTxJTEnlZqV2nhZMJBk3sFb8JSzm44j70QEpU
         w/7IOA52384WYT8+PgVD1lfCTwqgpoc0S5Z9fBCouHE6A+uhBWwN7jrH+Pm9fz6K31J4
         j51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316738; x=1763921538;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h+yrKxxFBgRhUgP2kRwlDCD5oqZTa2zSHgr+iWIew3I=;
        b=WPpf3rwPa3A2x/SQiZZ5YkpCxZt3B+G7YBt/wE/PvH3rBGHavFD0UbmMwdT1gopAnd
         AONjGOOsC3fqCnfvtK+4Uvm4fsgIR3T4703moocJv2OCi63wTgUdlNWfSbBhHMszz45M
         OuZRKScw6wk5WWFlrptHmlrm0lccNmociGQAarEHYysoHyOFqY2OPC/nypK2oE+90CIP
         g2+dgQENvxI8z8DIhbO9x4OpoeX7fGHvHIJOYQV1H8+N2rAeSQijDTDtRAf5oW3O3nYx
         2ZUgsDyAY/o6PzuJIncAc0DErb3CvOBWzxfpNg76l+O5M7N8tJUVkT9edyPzg6s5URUr
         Sj7g==
X-Gm-Message-State: AOJu0Yxy7PXnVwDrVvpW4DeTtl2aQDoFzE/dYhoRfraFX34vNYU7fEvP
	dmemyycnjPUBL1a4WvGb98hOWEYXwWyB65dZ/2tskkfgL/ncAFj5DrKX
X-Gm-Gg: ASbGncvpnaGeeMIniX/ZNUR36DE8tU0asTloClnMGjN6ZgnDSfC8F+jbgpg276hwh1R
	ay8aKYnB9wegpLE8r2iAcvAThhLMFj8IxJSR6UcNeJYzgLZ2+XoVkF/Rz38m1ztosKBb/urn2Hp
	dN+JoTLxz6t3U4imb5J/js0b/b9yTUyotwvx7+1HZpWuJ024/rMJSTiaFerNV6aZHTbJ1v4wv3K
	uEG8DTIhGE3Kn0v/k7Ezo0YbQ4NzAU4fxTCtVCX69gTvVQZ4vhIOTqJdNFi1EskLYBY/Og2x1MU
	JOeN4DL56kgTH2qR7syNQob1r2WjldJNZFMPL6rgqgp+Yca2CmnBr45v+6v2H7wODOxdMkNrL3t
	mqoJS2BuJLQ0KusBWYDatuqoakgv1yBY7eaRSeHVn86kF3XJdHvZ2no6Cs4bURJjiK+S/6hjkGP
	uIU8CoLovM6JcnGNlMP0aGwXwOdAADcMuLh+M347gYFZJDuc3I0hd9
X-Google-Smtp-Source: AGHT+IFKOh4yyOIFfU71bYVn1d/ZY5kEZcI/m4NJFf82ElPxYueeLKWrQY2+UDy/nQ2Eu/Pg7CRo8Q==
X-Received: by 2002:a05:620a:1aa9:b0:8b2:e958:740c with SMTP id af79cd13be357-8b2e9588108mr241421885a.72.1763316737536;
        Sun, 16 Nov 2025 10:12:17 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:17 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:44 +0800
Subject: [PATCH v2 03/19] mm, swap: never bypass the swap cache even for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=12598;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UHgfdSRoDfEx3tpsZtN/ZZWCxEq66GZO725UZ+92o1E=;
 b=bsrgbFZyifpucjYW/QrJ+zApu6rto8kENJVxebAPWYMTG9yB5e2cl2NiOrn1KM7q9Tq0hTa09
 8+SAhIZ4XmUDms/VLwRBLUJHrbcWKmil3fNjiv7d26LoQFkbOUxonOU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94A55A000F
X-Stat-Signature: efp9u7i7j7mqra11i8mdrys7rgmxpygj
X-HE-Tag: 1763316738-909847
X-HE-Meta: U2FsdGVkX18k2Jtvu0gi3eoXzHsnC16nWt3/KtiwQg37DcbzTR1ostp2DM+UF8Q1eYcB6BgbUo4LGyvjPvbDwTP/lUcZsAWaP75/K+zUK0Z2mzHkAA8j9P7j8IZlz8WikXK649lvjbKif22OrFFarZuo0/8PN5visFhR3smjPr/qYVHBGk1ipcCUKwEDdbOJPJeQ5FBeVxm4lEwcJB5J/7LH2dBrHduqOSXeTxYV7dgfHPbo/K9ySNZ5/tKMe0BN/NtI/1ODjjZGAET9/8WlV7OZzL/JdxUIslAU8dL9CsiEyhp08sVVZ9ZfA9J1okWP9NqLlcIn+CLlP0qvXPTgUFIGznuXdQOUrkZInDxYzUuLHYQ/5YUj8g+Rb/eGDjiJem75/Abm6PiAGujy/PFmlri+ilPMxIMJZ8UMjrUpl5GG9QWbKvFU90JK1bB2NSGh3Iz7lTon5rHq5vR8k6k5vaEMzHrrpaE+1SlVyZeCyzTFF0hSaIVInEGv16I/FLGbV5eYMKxH6PnJ37allMLkqZQaHPkEjiZqxI6CyfZHjaxYTZmJ5IaUA0j4HK+MY/G9HC9ivVph7yuooqN26/9LUiMM77oFd/ZUw5s0GXE5ciA43WTsf0XtRSwoRQHJfsAdeNNTOKA2vppSoAUf2I74nvF+Fro0W2p4n9nebO0jpW0jNzYeVdNyo33Cx3rLsKKcouIv3hk2d3BVNRLy3Gm68t+Grz8RuEGNQc3OSqzrZXwBpBfrxY9OMo6yeYtqyjfpiOs7rn1e6vCAngXPO3x/xPluMWsUAjS6/kAfnE3NH+GhMyilOQMuj4uOAC4L3A+0xDNj1jDb1f4eITM3ujrplX2jpCaLHTn3dKpWFxsOUAShO2lo8MGM1ISkCAbgSWRlTfCNu+M7RgG6AIlRFMysBhnd1tk+6afg6gxne7v8s693feyqxALm5T8C5uhoUWJocCzJOpT+23sQaR1yOF2
 7n808zp6
 TJpxgTW0LYn8nnFsIngxVdqhSELyjzbiD2wbqBed/xES/Y5LS7fU1Ib2EtTDv2P9rE+BOEZD4FlMSMYiwjH1lKL0r9l378QjyEGNDotunY1SGRruN7xR3IY2lfbHuRiEJRT6Z3hSAQaf+1xkqnvlKJNRJtt0YsR1Yb1+Nv+M/bATjiTOUMEw+HPxUnI/TMU2Z9/7RgyhnouLqWeAWji3aRBGXG4/fMsaO24wZR7bC0QA0yfzrPK1GUFzoUC3FHTdZ7obD00WfQxqHH4UZXVimeKHHwsCvKohqY18kYbuCEqCIf/zUrB+rpLLn+awdwNr/DOGyCwRiKMnu17z80LyVGA7kRwjEhRvQiN/WMJ7fFnDJe4D3D3vGzW0NVsyseW42K0t0MW21eAO9Ch1V1egFRsc92TaQSUJ1MTX4YzhdxrfWwSC8t7TEjFJPpn2cn1aCOeJZooT+Ct0dqx8rz0HzzcuWvb+BF/QzFmrf
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
is a huge win for most workloads: We used to rely on `SWP_SYNCHRONOUS_IO
&& __swap_count(entry) == 1` as the indicator to bypass both the swap
cache and readahead, the swap count check made bypassing ineffective in
many cases, and it's not a good indicator. The limitation existed
because the current swap design made it hard to decouple readahead
bypassing and swap cache bypassing [1]. We do want to always bypass
readahead for SWP_SYNCHRONOUS_IO devices, but bypassing swap cache will
cause redundant IO and memory overhead. Now that swap cache bypassing is
gone, this swap count check can be dropped, the new introduced swap path
is now always effective to skip the readahead.

The second thing here is that this enabled a large swap for all swap
entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
also coupled with swap cache bypassing, and so the swap count checking
also makes large swap in less effective. Now this is also improved. We
will always have large swap supported for all SWP_SYNCHRONOUS_IO cases.

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
index 50b93b45b174..c95c36efc26a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4606,7 +4606,15 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
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
@@ -4619,17 +4627,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
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
@@ -4700,57 +4705,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4772,6 +4741,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 	}
 
+	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
@@ -4841,24 +4811,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4902,12 +4854,37 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4985,18 +4962,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -5036,12 +5011,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -5049,6 +5018,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
@@ -5056,11 +5027,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 7b93704fcbe7..826bec661305 100644
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
2.51.2


