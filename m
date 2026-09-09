Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7E3C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD896B009D; Wed,  9 Sep 2026 05:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F326B00A2; Wed,  9 Sep 2026 05:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8467A6B00A3; Wed,  9 Sep 2026 05:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55EB56B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:53:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2C26A36EF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:53:43 +0000 (UTC)
X-FDA: 85193761926.19.DB0B9C0
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE165100003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:53:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VUfb2DN0;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klQabvPBSdHuFjYsQkDymGQq+sX0bqmcbAmBz8NKUgY=;
	b=t0jQtOcjxPeANvDQTXH3luR8JbqIYq09v0nhi4dyr43SMzr4hoF2+YGKTXagzCx4Txmt0q
	z2SAe+hOb/6shAj0SQ2iJ0G28fvDTZH79O0OVo9BvCjYwodOqWIT7dmpCDhhwHz4B44yJ8
	iISvaiFIs6fTcUjFPaiStDaEr9fN3LQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VUfb2DN0;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947621;
	b=0OPAlMbTMKLfSZFnHTa7tolERr6fJWDJpu6oqZfb1B/7rBwWdjSodgiWfYrPDA9Xt4USE4
	o6AbHn6tZ8wYbS20EyviZXIk0dhCdl4szqx+CMjg9HdOWdORiSwXlbP16BUDG9pCIbvCIw
	LfYcq8fcx7EJfwhp0aaAeOu9eJgdlVk=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdcbso7561827b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947621; x=1789552421; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=klQabvPBSdHuFjYsQkDymGQq+sX0bqmcbAmBz8NKUgY=;
        b=VUfb2DN0/9hMDsGnp4Z94gWPJxYGmTBS8Y/NVAgKQeMSJKfvw+X1xTwaV0Qk/vnS0W
         YwwF0uRsTK0wX9oMSRa1+Zl1IDHYTDgcLpkODulchszBX4hUru7WmPLhi8p13YbwrAWS
         B59B1hQFaKoLNp5RKqfkPOuLuYdhyy2jV9GgGb1bKpZkiJ8gYtJs3em98aBBTiWUzWxZ
         cTvBzxynQpeaCFRG/VU5X84xYd4TwtcxMEtioVlnjF1JeZ0ygihpE+H1N+G6Vyt1ikHX
         regGwfEydYTTH3DgFN0nVycin6YQpyP7BKp5swNimqieXPZthLQeF6RAw6XJoVkK5U5I
         gBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947621; x=1789552421;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=klQabvPBSdHuFjYsQkDymGQq+sX0bqmcbAmBz8NKUgY=;
        b=p8IhKQ4Ymqo7J0jlMVe4VIZT3nzF0Cf1mJPg4InEp0SBYEeMiG6tSlZl8QJ2XTMnmG
         dlcKzW8PtKUbcU1MhU0BZdb7cuVl16+z/+JO9r6bc88bCR/HpelzyaTpGjxm7IR+K+tN
         SwczmBimxcxTJJuKez2Rt+lRPFkWloFk3dSu/DVCPlKP4eH1Pq4RvVh/Vp3IcK0Qp4Ag
         FjSexMMlntLqHmlQcmb21stDcreykf62XOdU34yDG0PBQCqPSnJyZLS2xNFi2YZ13ltl
         GSJ9tMVPPNzHs8ndYXjEW3C7NURV7+ii3FGY/4D91L3W2Ay4jhDszLJi8RO2p1tj/24A
         2S3A==
X-Forwarded-Encrypted: i=1; AKwUvBzuKsSlM/8phDTfAzLWjKivqMJkRorSDWFBU2syzBDb5OKVEDNYpHk+c/Rijd7wNls2up5hLm82zQ==@kvack.org
X-Gm-Message-State: AFuF++mLZVii/4s0GWnRgmxWlca4DBcbUNajAETU4qXrhsALmyGPHggk
	nFavKK3lV42Myo6OC19h8SPUioBdGMfGC/HQtbK7sgvZj44k+aOWFQTDwvZy4NPTAQ==
X-Gm-Gg: AYBFou2M0VJ+qP/hio97e0RhWe0bFWbZIqa/s5OXqK2ehBfCZSRb8vGY3ANNgid1zbs
	Bapz5JV5SDyP6o7GRQ/lL9/blm7DCGxAjgXG5DQG3REoGkrVMy+QKmqsnZBbMGhSsG1YBQXHNr+
	FCUNc9rsaUOTt6c68PuTNR4ErUEx3rkmqa6L4c/anxriK2s/L71vVDjdPCVRYNQvp5aeYek93Ha
	iAqq5d6cIZk0Aaz2DknHRaHZJWyE2RzSe7qdMZlFWu7ZRozNSGMuTc4LNEuYHNJDDQdVYH82Rxe
	RqyPhuXNaqZB/D6LkVLHxKUPD/sGYG6Nplc9yx3xCaVJVPR9+wBjf/409KEyXKHlWDS6W9Nud3q
	mkpRsaE0Y1dqCRx/TT3su6dkJywAMrOMGk5KxZ+s0F+LE5vDsQ4zEdjvetsVJ2OJAuT6ndVkuOg
	gaCUbpBg2yJqPG93Imv95UOdDnyA08C7PLGZcHu2OWQeV45ySVEXq53F4yddqeoECVPOx9tx/KF
	PGtvF18MZWMHqRhkCZ+aTMx6GDzFDl6t86/sdHdkGPTWZJOScRL9NIUIPA=
X-Received: by 2002:a05:690c:c0b:b0:81e:1b3c:9e4 with SMTP id 00721157ae682-87f23fe8f10mr27261477b3.14.1788947620263;
        Wed, 09 Sep 2026 02:53:40 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714b62503dsm108292997b3.38.2026.09.09.02.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:53:39 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:53:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 06/26] mm/fbatch: fbatch_drain_lazyfree(onstack fbatch)
 before ptl unlock
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <17e1a6c3-525b-1cc3-0731-349f0850e3ea@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE165100003
X-Stat-Signature: on8unfpssrk189schsjdo3edtt3d3aii
X-Rspam-User: 
X-HE-Tag: 1788947621-281119
X-HE-Meta: U2FsdGVkX1+CsLsO5NqPE20jaOKPeOagNnfKUmoIQxAXjHq+lk4ZciIyltFlCbhY5S9kNFQhjUsuj458Y/bIEtkGMaAtbYpLNAP1aAh+D+LBcnDVB76FcAstVpIE85sAT5KlZcGeCTnagjszv3OjCYmVkt43ikf3CZ/sPMmWpYUesigHi4FdHhAnfh0D+AEgWNcXG0ko5dGXehOa6iOynNXnhN1ppWx0sfYIE2uZ2h0QdhGlRjjYo5mntj27X7tY/xhHFFUNOblihEQLYi7DVdmiGa5top9MS6iWQJRydOZjvKGRJ6DPmQ1w8JE22a0484kaMgjmJLMB1l1lHO8LWbbEb9LXoAK5MuTruw4vESW7LEvGueTU8Akc+QwnNwTmQiRF+ddu9vrAr08Fbr3361B8X+gWmjvxgQ4gfKeb4Za9lOv5hA017OA+OkObY/jttuX+gqavbS0Hs4AWWg4zaoRAIrWfZsznFS11Du13GzU2ZYGsEXU5xlY1WCAjxs4P4ykNmHcpilmrszuPGHdoS0AWoTEq2BT4OGO9PrR59IfqQXUzNIaPvlwqk6c1uMqyvowo8+VJ+b2IZC4u90EXQuNXBas5CwFM38jOh39wKGLGxDvqC1tdU9UvydgmB0U4IXIirtCg/Ey+qfLerHcPx+mYGYu3Q70+lNkix3rJ1InUMow6fDC74FcXQoWSjJ9RUhddb1vHolfO5SLHlibYeMDy5zfcDKKaFV17LV888AhWv5lvhPW9H4DYyEqJVf6XVMLFZUdU6FMkgRZnBdRkvHwIxQaeEfukaxEZ6jAIWAzmTZcHe9dyzj8ovRMIsbiS5bChkf6RCLZYOefCm7hBOa6BQxJZZg8OuLBVfTKVcSdbA/o3fo3sV2pJIVuw32AMe/d72pI4AUx2eXQqfEQ6GpVY5Y8oAS9KgnOFx+3lx7dUVOBct9Ng1UMYyWqOUb4ciOx1SkRLXIEqbdGEGok
 ZU21EE8d
 78+W5oG9/O+ZEu0Tdu246959Dce+rvCyQ6ViCilLUx/T94ovu0hxKGuw0eYt1EwTPnDL6riqXC1g/hnAxhE8kLFUu2YLP2maFhxauZKnCIGtQiaW0y25/dI32aTGhECsl5hdll/+S0039aVCKCbchkZEGjP+T+lwTLgb2dv4NQCqNSfm8BzbyMBtntePmZLgd1vDd32kYgtk0h09VaefO8NsdOCWXvSwnaSfigxw2r819S6NkFG65kw6rkdCnhJA4e4xE+LJtHBs2lj+khG8L+oRiFxBhigxHjoTigMCExMulV5VCTaZmjU1F52b4Xn2pCsRiRIhhh3OhXGpZEUbyfMQAIuOVW1uRXuY87IekhFmI6betkvnE0xS2+eSi30cpINrNwiNTkfhlPpORHkiaeVzFk/ptWEu6vKaR+EIkyDHWk7cTEOSaBisP60C6XnUCfVxL1Tiz4yS2LsKg7kyGhvOU4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Re-enable lazyfree batching for MADV_FREE. But it's not safe now to leave
potentially stale (then reused) folios in a per-cpu fbatch for lazyfree.
Instead, madvise_free_pte_range() keep an fbatch on its stack, and drain
it each time before dropping pagetable lock, while the folios are secure.

Ignore folio_may_be_lru_cached() and lru_cache_disabled(): limitations
irrelevant to this fbatch drained under spinlock (even if RT); though
in practice madvise_free_huge_pmd() does have to drain every time.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/huge_mm.h |  6 ++++--
 mm/folio.c              | 34 +++++++++++++++++++++-------------
 mm/huge_memory.c        |  6 ++++--
 mm/internal.h           |  3 ++-
 mm/madvise.c            |  9 +++++++--
 5 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..d50906327d1d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -24,9 +24,11 @@ static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 }
 #endif
 
-vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
+struct folio_batch;
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			   pmd_t *pmd, unsigned long addr, unsigned long next);
+			   pmd_t *pmd, unsigned long addr, unsigned long next,
+			   struct folio_batch *fbatch);
+vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
 		  unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
diff --git a/mm/folio.c b/mm/folio.c
index e743cd539b9e..a18d8ef6afd5 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -51,7 +51,6 @@ struct cpu_fbatches {
 	struct folio_batch lru_activate;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
-	struct folio_batch lru_lazyfree;
 	/* Protecting the following batches which require disabling interrupts */
 	local_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
@@ -194,8 +193,6 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			/* XXX Temporarily disable lazyfree batching */
-			fbatch == &cpu_fbatches.lru_lazyfree ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
@@ -585,10 +582,6 @@ void lru_add_drain_cpu(int cpu)
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate);
-
-	fbatch = &fbatches->lru_lazyfree;
-	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_lazyfree);
 }
 
 /**
@@ -634,19 +627,35 @@ void folio_deactivate(struct folio *folio)
 
 /**
  * folio_mark_lazyfree - make an anon folio lazyfree
- * @folio: folio to deactivate
+ * @fbatch: batch to which folio will be added
+ * @folio: folio to be lazily freed
  *
- * folio_mark_lazyfree() moves @folio to the inactive file list.
- * This is done to accelerate the reclaim of @folio.
+ * folio_mark_lazyfree() moves @folio to the inactive file list
+ * via @fbatch. This is done to accelerate the reclaim of @folio.
  */
-void folio_mark_lazyfree(struct folio *folio)
+void folio_mark_lazyfree(struct folio_batch *fbatch, struct folio *folio)
 {
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
 	    !folio_test_lru(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_lazyfree);
+	if (!folio_batch_add(fbatch, folio))
+		folio_batch_move_lru(fbatch, lru_lazyfree);
+}
+
+/**
+ * fbatch_drain_lazyfree - drain the caller's folio batch
+ * @fbatch: batch of folios to be lazily freed
+ *
+ * Must be called before caller drops the page table lock: that is,
+ * before dropping the last certain reference to the folios in @fbatch.
+ * It would be very bad to lazyfree a folio after it was freed and reused.
+ */
+void fbatch_drain_lazyfree(struct folio_batch *fbatch)
+{
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_lazyfree);
 }
 
 void lru_add_drain(void)
@@ -700,7 +709,6 @@ static bool cpu_needs_drain(unsigned int cpu)
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
-			 folio_batch_count(&fbatches->lru_lazyfree) ||
 			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c7510d875433..abebd8a23e56 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2356,7 +2356,8 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
  * Otherwise, return false.
  */
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		pmd_t *pmd, unsigned long addr, unsigned long next)
+		pmd_t *pmd, unsigned long addr, unsigned long next,
+		struct folio_batch *fbatch)
 {
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2417,7 +2418,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	}
 
-	folio_mark_lazyfree(folio);
+	folio_mark_lazyfree(fbatch, folio);
+	fbatch_drain_lazyfree(fbatch);
 	ret = true;
 out:
 	spin_unlock(ptl);
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..0d78406eb126 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -63,7 +63,8 @@ void lru_add_drain(void);
 void lru_add_drain_cpu(int cpu);
 void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
-void folio_mark_lazyfree(struct folio *folio);
+void folio_mark_lazyfree(struct folio_batch *fbatch, struct folio *folio);
+void fbatch_drain_lazyfree(struct folio_batch *fbatch);
 
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f..b2eab519af19 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -27,6 +27,7 @@
 #include <linux/file.h>
 #include <linux/blk_plug.h>
 #include <linux/backing-dev.h>
+#include <linux/folio_batch.h>
 #include <linux/pagewalk.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -666,6 +667,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	struct mmu_gather *tlb = walk->private;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
+	struct folio_batch fbatch;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
 	struct folio *folio;
@@ -673,9 +675,10 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	unsigned long next;
 	int nr, max_nr;
 
+	folio_batch_init(&fbatch);
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd))
-		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
+		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next, &fbatch))
 			return 0;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -733,6 +736,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 					continue;
 				folio_get(folio);
 				lazy_mmu_mode_disable();
+				fbatch_drain_lazyfree(&fbatch);
 				pte_unmap_unlock(start_pte, ptl);
 				start_pte = NULL;
 				err = split_folio(folio);
@@ -777,13 +781,14 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 			clear_young_dirty_ptes(vma, addr, pte, nr, cydp_flags);
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
-		folio_mark_lazyfree(folio);
+		folio_mark_lazyfree(&fbatch, folio);
 	}
 
 	if (nr_swap)
 		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
 	if (start_pte) {
 		lazy_mmu_mode_disable();
+		fbatch_drain_lazyfree(&fbatch);
 		pte_unmap_unlock(start_pte, ptl);
 	}
 	cond_resched();
-- 
2.51.0


