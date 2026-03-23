Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477D0EC01C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCBA6B008C; Mon, 23 Mar 2026 06:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86A06B0092; Mon, 23 Mar 2026 06:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3386B0093; Mon, 23 Mar 2026 06:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA246B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:34:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34A9BC3450
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:43 +0000 (UTC)
X-FDA: 84576969246.25.3604F6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EB5840007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Hr2rWXBF;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MKoH2PQ5LrIpcGGcQNvv1kVkb7GywcLjC1NtWghbIBg=;
	b=pSDDJkTNlBRswQnLKnNvRwufhFMtBViHuzRjPVT4IFPEEl0uRUkwnU3LkM9hqOOiYxnc9d
	JOKfEk/lDb2cuk2b2A0hpNR6wEQK6du4i+vT6Cttb3lKojQEeQ9y5MuckpjDgvt+KHqijB
	ipkjHd7oMB64zYgwSaB8nf+95Fw5150=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Hr2rWXBF;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262081; a=rsa-sha256;
	cv=none;
	b=QI6vG43H11+uC/1df3H7auK3lh6m6S9zjFwN9tV9NUXfK3RGBsD5VGzWXSqixqKxuQubP4
	cBcsR/esR7Up8P7hWOC3Ivm3DNFtc/viM6BLm4ytW7WTO6GVL3Vvr2MQO4DVz4iZAgoxLA
	jjUEG10fcArrms1TyAMJLCXVxWi7k5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A5D743F2A;
	Mon, 23 Mar 2026 10:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB449C4CEF7;
	Mon, 23 Mar 2026 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774262080;
	bh=fxjn1JJaPgpH4EhTFPXGtHVcQ4WOSI4YYYxfY72hfLs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Hr2rWXBF0yjMSfAcNJA3+pcHAynMppsRA/qPy0JW60Jx1D1vWfvBUYY9VKV0YR8xK
	 t1tSf7S629BuWQOco1wpqgwD/Ed+nu2zDt+wQpQ+NdVQKmaLOm7k0rso1rd+5hPh2H
	 tAc9eOCZ1kMEEk1HMaszFLBADroTwXItCbiVfTKk=
Subject: Patch "mm/shmem, swap: improve cached mTHP handling and fix potential hang" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,bhe@redhat.com,chrisl@kernel.org,david@kernel.org,dev.jain@arm.com,gregkh@linuxfoundation.org,groeck@google.com,gthelen@google.com,hughd@google.com,kasong@tencent.com,lance.yang@linux.dev,linux-mm@kvack.org,nphamcs@gmail.com,shikemeng@huaweicloud.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 11:34:05 +0100
In-Reply-To: <318493ca-2bc3-acad-43bf-b9f694e643b0@google.com>
Message-ID: <2026032305-gap-drainer-3bcb@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EB5840007
X-Rspamd-Server: rspam08
X-Stat-Signature: uuekjsgs9e8omp4ykf9uyo18w3csa6ht
X-HE-Tag: 1774262080-137117
X-HE-Meta: U2FsdGVkX1/uFYiTz3CRPObBg1TuucsJmrL0Y5gzH+y6V3GRZ2/Il34xzY1ytya1cgklZMl2UuoxyFTFehM1d/U1SzhH4EK+5O61TLOs5M7+azGkBq/KHhXLaLNcRYWbxMHCNlfDEaKTzHO8sKNteYsLIsfXG92xSt8I9uHzy1NRxLxB0qp/du+wjFItkFzQBZFnoIhRq/BdD4BqKTil6IbbzsXtXWNHS/yRyT32U/Sr57CdBnIbHD6RoddczBkqBqfiiDsFGhw66lgROjq1ySRxymEekTGnd3sE9nkxUFtxsm4NdugDXN6l7enGWFqllhSsekwriReISfHBsKGahW5VTpFmCCNxPumLmUJ927XibygjXAKmnNoXrGJ6AC2GhgaPmUWliSRtuDNzhzYgyHWdhXqqYSePY/dSVScwLag924IRfZZslNo+rjM9vOHyGa3JZX/D3UpXxTmIjobuS19VwQ4G/KRlFJ5pZ/t/LmSG+/8QCje2WX5Bs2wZvRhfxonjFpKLt01/sQvSsFUjWJsMv5SFblpiAIodz5l2meuT3qqUcVSOrNw9yOC+vSlL/CO37WTkFLrLQKYKX93z3fe/KPLLFXDNaugr4kKI6ScTcX4W6w5aBaIe+IwdGe4Xo3VHw+bP/2gn3vJpZPK/BcLPqPGvIo0MtL/GX0WXNtSBbY6GpIAs2FERkvYhAer1e0YPpDvcjgv0RSL1U0dLDh+euYR8J6ezOWVH2ccETxeLOJ0gNup/Wm3EQJhNJ8QKrDTmn3xQH/RlidVb3+VbAHJy2DQwfdrA0UdeQBNuhyEyVLsr2IRt0GprPKqgDyC9sCkhVYgKjKWuuJCm/mboELGUxPJ+4xehMY10wTy1qYYKG793ElF41xYq+Egg0Ji3Ggldjrao7MfWec2gTTds8ENgDEdGKJvNI5TeHS5FrViGaM9VGHwtYg+zBH4QcExvNL5MLC1ehOHVjAiZd61
 t4LGHIvY
 3LCG7yS4iPoH6HmB/JKN8cW2ZG2Na3Cmqi/RtkQ0keEId0JPZgtA3ptphXhr9EIRWpcugxcz60MEipaMTCDc3Pjx4r+MATzXTDfGfIgt63UAG7twSSEDmDqzzu/0waC1mETysAIvQ4V1r9Dg75VLqCkydkYAmoh6KGzolakojHiRuJmQJkVYn4GbSoOGHJzfohZyFwBAm4bdXDWUyWFgmqKrenYBMaRTnZNhUMe7mO1+i3uAEQanGZGaqpACAXOgswqf3cxMca5NyG1k7GrYL2DF5gi+mpFm0thYSGS5TSbzc1djC+wEhi5uiLGJhy5NUuvEM32OqkZF0e7q7mmv7aCRvr/hVyKKe1W96UIzstrZVWytAhU0zmAzoiWNcbHMrmOQCX0XUpWhMUipLp8FYPH1rem/J5fi2mkE1rneaOSpwF7cpka4Lo+CJeZ3w1EaLH84Otaq5pMAAhN1qtCHcobKJa3+DQmg3C83OH6xKeASXXOpyaZew/jL7Y1BqzwC1Klp5JhFWXXa+yC3rAiGo1ZODCNtHK6krdMHQs+OGn/Dgr4iQXy/3GLJ2QZU5NqIqPP2LtDNMRnNH4P5Jv42/EDlM9eGMDIMt69lsi0FC0TYssyoqAVwHzdwiEXQkMYNTYBMycXBugtUhNkEC/Jd8E8dFVJ96wL1RKS0Jb3Vtwi4StdKRRG2M11J0ru5btkdRg75hXcMCMX+VNCvwKIVkpQeiYijnMuqdbl39lXI+i8Vr/8vrQBu3ua8f5T9VRVwCH0K0u+3R9jY2c3vdVwHEc7cqVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/shmem, swap: improve cached mTHP handling and fix potential hang

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From hughd@google.com Mon Mar 23 10:40:20 2026
From: Hugh Dickins <hughd@google.com>
Date: Mon, 23 Mar 2026 02:40:16 -0700 (PDT)
Subject: mm/shmem, swap: improve cached mTHP handling and fix potential hang
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,  David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,  Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>,  Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,  Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,  Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Message-ID: <318493ca-2bc3-acad-43bf-b9f694e643b0@google.com>

From: Kairui Song <kasong@tencent.com>

commit 5c241ed8d031693dadf33dd98ed2e7cc363e9b66 upstream.

The current swap-in code assumes that, when a swap entry in shmem mapping
is order 0, its cached folios (if present) must be order 0 too, which
turns out not always correct.

The problem is shmem_split_large_entry is called before verifying the
folio will eventually be swapped in, one possible race is:

    CPU1                          CPU2
shmem_swapin_folio
/* swap in of order > 0 swap entry S1 */
  folio = swap_cache_get_folio
  /* folio = NULL */
  order = xa_get_order
  /* order > 0 */
  folio = shmem_swap_alloc_folio
  /* mTHP alloc failure, folio = NULL */
  <... Interrupted ...>
                                 shmem_swapin_folio
                                 /* S1 is swapped in */
                                 shmem_writeout
                                 /* S1 is swapped out, folio cached */
  shmem_split_large_entry(..., S1)
  /* S1 is split, but the folio covering it has order > 0 now */

Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
folio lookup will return a folio with order > 0.  The
`xa_get_order(&mapping->i_pages, index) != folio_order(folio)` will always
return false causing swap-in to return -EEXIST.

And this looks fragile.  So fix this up by allowing seeing a larger folio
in swap cache, and check the whole shmem mapping range covered by the
swapin have the right swap value upon inserting the folio.  And drop the
redundant tree walks before the insertion.

This will actually improve performance, as it avoids two redundant Xarray
tree walks in the hot path, and the only side effect is that in the
failure path, shmem may redundantly reallocate a few folios causing
temporary slight memory pressure.

And worth noting, it may seems the order and value check before inserting
might help reducing the lock contention, which is not true.  The swap
cache layer ensures raced swapin will either see a swap cache folio or
failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
bypassed), so holding the folio lock and checking the folio flag is
already good enough for avoiding the lock contention.  The chance that a
folio passes the swap entry value check but the shmem mapping slot has
changed should be very low.

Link: https://lkml.kernel.org/r/20250728075306.12704-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250728075306.12704-2-ryncsn@gmail.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -794,7 +794,9 @@ static int shmem_add_to_page_cache(struc
 				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
-	long nr = folio_nr_pages(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	swp_entry_t iter, swap;
+	void *entry;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -806,14 +808,25 @@ static int shmem_add_to_page_cache(struc
 
 	gfp &= GFP_RECLAIM_MASK;
 	folio_throttle_swaprate(folio, gfp);
+	swap = radix_to_swp_entry(expected);
 
 	do {
+		iter = swap;
 		xas_lock_irq(&xas);
-		if (expected != xas_find_conflict(&xas)) {
-			xas_set_err(&xas, -EEXIST);
-			goto unlock;
+		xas_for_each_conflict(&xas, entry) {
+			/*
+			 * The range must either be empty, or filled with
+			 * expected swap entries. Shmem swap entries are never
+			 * partially freed without split of both entry and
+			 * folio, so there shouldn't be any holes.
+			 */
+			if (!expected || entry != swp_to_radix_entry(iter)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+			iter.val += 1 << xas_get_order(&xas);
 		}
-		if (expected && xas_find_conflict(&xas)) {
+		if (expected && iter.val - nr != swap.val) {
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
@@ -2189,7 +2202,7 @@ static int shmem_swapin_folio(struct ino
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order != folio_order(folio)) {
+	} else if (order > folio_order(folio)) {
 		/*
 		 * Swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
@@ -2214,14 +2227,22 @@ static int shmem_swapin_folio(struct ino
 
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
+	} else if (order < folio_order(folio)) {
+		swap.val = round_down(swap.val, 1 << folio_order(folio));
+		index = round_down(index, 1 << folio_order(folio));
 	}
 
-	/* We have to do this with folio locked to prevent races */
+	/*
+	 * We have to do this with the folio locked to prevent races.
+	 * The shmem_confirm_swap below only checks if the first swap
+	 * entry matches the folio, that's enough to ensure the folio
+	 * is not used outside of shmem, as shmem swap entries
+	 * and swap cache folios are never partially freed.
+	 */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
-	    folio->swap.val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap) ||
-	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
+	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
 	}


Patches currently in stable-queue which might be from hughd@google.com are

queue-6.12/mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
queue-6.12/mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
queue-6.12/mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
queue-6.12/mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

