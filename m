Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761F2C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC346B00A1; Mon, 24 Aug 2026 10:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875896B00A5; Mon, 24 Aug 2026 10:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF6F6B00A6; Mon, 24 Aug 2026 10:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4097D6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:06:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4207A0158
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:06:37 +0000 (UTC)
X-FDA: 85136338434.16.0F83462
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0388EC0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:06:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=exbRfNWb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9t24td1SIXy4MUg0Hzwh5Pqt3oG+R8+H8KjX8Zm4YEA=;
	b=Ce8VdPHOc6hSKpLY5nlTuMUkRDKTaZ0M+7g1vmlP2kjqh3uZA/0gs1yhjfYVd6OFRvsif/
	fHvgE4tew+UcU8w6Tqg7LeH6wQ8LgIgG4fGOOyLq24FFtrpbEkl3GAVQ83z2BWsJKM3Yae
	bFsx+PqH2pHsJyGi0LUED96NbHHkfW4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=exbRfNWb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580396;
	b=p6LzJfNVBBYiEyQq9hpiuWO5w/Y5/YqYx43ZOirombOwlUxKVXZuEYcSj7LEFpI966P0TJ
	M9uGScLtwvXLdLyp2eteHCWTNi62CLXMRLXyh+q0qnSW7pk08BgE7ZUbpXwXQMAa9QstO1
	iUTNfO/UuawbWsnM60JApH+/sor9nSw=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-836cda225c1so49090747b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580395; x=1788185195; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9t24td1SIXy4MUg0Hzwh5Pqt3oG+R8+H8KjX8Zm4YEA=;
        b=exbRfNWbJLUPL2IDK+babYGgtmpCDrZf5GEqnp9OY+0teI6RgWGd8HqzjaDHg3gLg8
         TUbLI7YLks7J4Yr6DuTN7VILXUmTl0B67SIDwDggYTFXaHD2avDdBwbJKOmljtFXHpW/
         T/tl4+yH+5PkFUSqpx0uQl+kHNe1CVP6FUt0WKlSzvs3o1Oh4/VAE0yGHgzxNhDaLti2
         hBwApY4gdwriBLnHuCuX5gM4l2kAJCpUtyLlKC7MrJNZ3OhB3xSrPt5dKooIp/LYQgcj
         dto6Tr8oAEuTuvZXjtcxG1+QausXbEndbt7zTQun/uWKvsDdbUXz9E1a3RuP8NPosx/t
         xU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580395; x=1788185195;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9t24td1SIXy4MUg0Hzwh5Pqt3oG+R8+H8KjX8Zm4YEA=;
        b=nlfHhQxAHdtpKGsMok/P11PYfoG9qf6wpBFKs15JeW7YQcxHJq9NT9wiSK1glUULPB
         eghEKS/c4+EL5NYkdAHxwGHzlTyE6WInek3jhrOCFEWurnWEO0LWLRXaNS8KD9P+g3hZ
         ZjQPw2dAaaam/HUh8Ju9Hxg9rGTae3g6G4onYQFpbn3SEw9OILiFn0dsx4qJXhuvsO/b
         3uAqbRYHw0/N/5JoB/HdqQtV5WoUtgKXRWmZPS5FqPDT9C/pXuucNW4QToPFCbVLicoV
         nCITkMs1gWgHcDGIur8vMeibRK1e6PxAYStStD5zgR1O2oAo1XIL5gWFKzhYCnzbjS+U
         VhNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOFkHfodBtQtS+JnVdRskFd8R/qbMKiZeoXLTdqd2xpekUqAhs4oJ0UdftoFgRsiemebamOQpf7Q==@kvack.org
X-Gm-Message-State: AFuF++kWPDDiriqxtLLFTEMGej1tK7vwQ4Suiy4p6dOeu5eNKwaozM86
	o1lOwo31uJbBXfQ8jUzkv9SNt8boOEvgG/zfW0kK7J9lU0rP4w3Ni4VSmxDgfxic8A==
X-Gm-Gg: AR+sD10VkcNjq7k2farSe3OVpxA7edonGQr5ZTrWbmkHT9RgskLfvuPveKwqNqQr4oV
	3MvE6StxPxopN6fvGDWRTlNVtxKh34Th3XFrrt9geaOb8m2/+owmVxuvV8nfZmGBJot3Im45UgH
	pPwl72cPE6mFzbDNkhK5DRszs66rEF30sSsWmNpjKNrpHi6D9u2zZRKtlGzPHPCIvkzQM/PnBFo
	1waCs9LeozywOiQZVES9HnppRnJ6v86M+mzhcSaCK7ZJ7g/YEfjeMzhdNzHf4qRT/Kie2TLh2dz
	IlRO1IZT8YhzgoYO6EYk7NNS0NrBAy3Mpyz5pE6UdLtxA/zmKXW43tQNhZgeNUZfdeFr1ISTOhO
	xA7mxTSbglaswbfHh+ZSTjemRJiQfeN/xocINjs6bpOl0hFESlpcSNJiPgNfx+OyrkUUUvYaGKu
	eiqt+G117H2Ycew9mBj4xk3kIH3TAbTrMZzP4F6RL6Ysj6M4EJ1hX04vTvks+/bcFb7Yb8yIjzt
	XeAbj2zGcLRvAMypb5wiZOIEDBN2FAIu0JOzJJ3xW5qWt2I
X-Received: by 2002:a05:690c:e1c5:20b0:80c:2874:67c6 with SMTP id 00721157ae682-849f5a0fb48mr73986717b3.24.1787580394257;
        Mon, 24 Aug 2026 07:06:34 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84caacaf1e9sm34320857b3.23.2026.08.24.07.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:06:31 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:06:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Subject: [PATCH 06/25] mm/fbatch: fbatch_drain_lazyfree(onstack fbatch) before
 ptl unlock
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <7155e86c-17f7-77d0-21dd-2d267f384a72@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: bh5jjutkp9z6qbj7iegt6rfa3hdbfynm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0388EC0004
X-HE-Tag: 1787580395-508927
X-HE-Meta: U2FsdGVkX1+9toNQKOA9/04tTkMozFYwiyNGXudEWdXHS/zshvRdErWmJsRL578MYndBHH7t8ZJpeW3lkvh5G8EpK+mVXwKiSJK5T3vaX8KmJfmloFvLcyjdd069eYsFX8CFHDtObBoR5HK/+bQ60Yn7ix0zu6GUhFDITJs9XWBk8ptOeyf6Is3i8EERegiYHySrHBLHV8RX7c4X5+HozH3kvD0smwciCtBCl4WE891txaKCNU7Yi2xURhTgzbE/r6u0z2H1FXLmjcO4Bc4xsiJ85qldeq+RHQNHR6MTBUN8BP2e3lwsXFBYY704xmWiBsvyhaGp9t64oS+UpESSVsU1MnimN5Tq2WQEUvw/rIhpmeKxvGLmCwQgl4ZONGl22J9R4YYg6TyPUDLHR42WcwZFZNgn6jWnphlQrMFiWUn/sXr1odYSPn0eBbUh5vzqvM7oxpW3iaTrk2nBEpGh3sYtejONKkd/Xxfi6S1ZSlywXaa4tvaovghpygRkV7hq+B2Yak6zbFCMvYeISwREnGQArZSPlXX0BQNlGzomlH36dhuWg3ohG8jy74x+eMNT/v0fdAEtTESHFI2awA+BUQneqDUcA+MDuIfeunqFDIjUMPLMGx97kuvU+pr2idlfBle01H+Y704EGtAMkMLJnT6HKVR/ULbj4T2lzb/0sxkrODr2P/NNYHDpXfxtHtqXJU9hHXjfPLW3HFcOVipb42LfxHuQSBynXL6amYXrJ1VMtN4j32dJwGtYY1kr28LGwZrUiEn7VCycEz3g72IQQQ8nSSABvn/KGaFJKe43llkQc47IuwTr+14UsqxUQeqwtuq53+m7XLrHOA6xXl4p0XuiDwyfDeWiHBpGWaYtFkwB1/iRkpBtXDuztoLSRzKTGXuVUwpIFzPTj+/5ms9G/OFM2HkydrIM127ONT69KtigYbBd1+aQFjfrlWpeIqRXMNBs9PnV++NawD9VQiY
 Bzi92UjZ
 qaVh9NM33lzfNK8tWCqGkXwIBt5EeHNxSTIo+HN8PrL+xECy0AggIIIcJHJOFaqqM+t0VPg3Mquk/wCkbUaZ6ejxzG5eifhOIBFY4d5xC9Jj5SV6gK12SEjJviApDgF1R7giXGDu83Q+IoMXqFZGx298AaaV/BOREG+bEPxT1vSozvuO37X7wihoyTRMfv4VcQkbQJHVWzoiR2pdBFcv8zNvU9JVnQxHg0Qwxa0HEUoKxWfjuP9u6PD/kDPDWf5hW+5A7py4KIhTpC94Syv9g//JJYuydP3GvqRybOtl7hRdGiDIx18dTljpKM4bBPxd7nZ9nKEMP4S/5FNJo7AmzdBqC3TjumFECqz2C03yDIPNvzv7O/6TcTnLEJ+T5kGtNdSb6UXBVi0jD+GTKeTDAcDhUA4ZTZDVPlM0imXDaoSr9BGXbsnIJDftBLexHVtDmNZk5pSmCcHhMjL+umLcldtek9mwE3K1BtFXK
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
index 88e3ebd7e652..e76868c95acc 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -50,7 +50,6 @@ struct cpu_fbatches {
 	struct folio_batch lru_activate;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
-	struct folio_batch lru_lazyfree;
 	/* Protecting the following batches which require disabling interrupts */
 	local_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
@@ -193,8 +192,6 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			/* XXX Temporarily disable lazyfree batching */
-			fbatch == &cpu_fbatches.lru_lazyfree ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
@@ -651,10 +648,6 @@ void lru_add_drain_cpu(int cpu)
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate);
-
-	fbatch = &fbatches->lru_lazyfree;
-	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_lazyfree);
 }
 
 /**
@@ -700,19 +693,35 @@ void folio_deactivate(struct folio *folio)
 
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
@@ -766,7 +775,6 @@ static bool cpu_needs_drain(unsigned int cpu)
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
-			 folio_batch_count(&fbatches->lru_lazyfree) ||
 			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 98b1d0ea50f0..b1f315400111 100644
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
index 68db5abd0a4c..ababee1a8872 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -66,7 +66,8 @@ void lru_add_drain(void);
 void lru_add_drain_cpu(int cpu);
 void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
-void folio_mark_lazyfree(struct folio *folio);
+void folio_mark_lazyfree(struct folio_batch *fbatch, struct folio *folio);
+void fbatch_drain_lazyfree(struct folio_batch *fbatch);
 
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
diff --git a/mm/madvise.c b/mm/madvise.c
index 240d9161ee74..6ef1f489123c 100644
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
@@ -657,6 +658,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	struct mmu_gather *tlb = walk->private;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
+	struct folio_batch fbatch;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
 	struct folio *folio;
@@ -664,9 +666,10 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	unsigned long next;
 	int nr, max_nr;
 
+	folio_batch_init(&fbatch);
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd))
-		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
+		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next, &fbatch))
 			return 0;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -724,6 +727,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 					continue;
 				folio_get(folio);
 				lazy_mmu_mode_disable();
+				fbatch_drain_lazyfree(&fbatch);
 				pte_unmap_unlock(start_pte, ptl);
 				start_pte = NULL;
 				err = split_folio(folio);
@@ -768,13 +772,14 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
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


