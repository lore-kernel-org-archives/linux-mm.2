Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB365C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA01A6B0098; Mon, 20 Jul 2026 01:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50806B0099; Mon, 20 Jul 2026 01:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67FD6B009B; Mon, 20 Jul 2026 01:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 830C76B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:08:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09B191C0A80
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:29 +0000 (UTC)
X-FDA: 85007974338.09.758E450
Received: from outbound.qs.icloud.com (qs-2006i-snip4-11.eps.apple.com [57.103.85.221])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C57D140005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="pUdKd/7d";
	spf=pass (imf26.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.221 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5HyYFMk+G/YKnBn8V0qp4YenxBWpgT+6vv4nWfMrPQ=;
	b=j8UMkyNRq+oownKwkLhwHA2lRzRHz0cf1hQQ11cQb2iBlVfuEAmwg2K3JyWpveyUM9iK4K
	MpuT5a9SIGN45u90TZUf4Ni9xfc3a+OxJe0ckl0iPfzyImiybvPJGs+vaimKhsW+aqe0H5
	ByhKqbjabd4fiz7LtnJ84mmwws+55tI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="pUdKd/7d";
	spf=pass (imf26.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.221 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524107;
	b=EIOV2l8WGsJy36+QCZwjoeGHUKXIKsFGDvgxjmur+OYx1i6rVwukRAwiFwMRYWwOgV7KSG
	wtqutlB49fJrQntjMxgmDJkIe0G+kquyJuFNxorC/DWurxYZavIgTbc4IZg5HEc9gMwRO+
	uIF6ZAyGuQrofrwSEw+GthO9Rq82Sig=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id CA171180013D;
	Mon, 20 Jul 2026 05:08:23 +0000 (UTC)
X-ICL-RepId: 019f7dec-e043-74fb-9e93-c65bb5ca77ab
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddDFVXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524106; x=1787116106; bh=p5HyYFMk+G/YKnBn8V0qp4YenxBWpgT+6vv4nWfMrPQ=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=pUdKd/7dRm/6yP4H6XvLXbgOKm9ud6pR7M/zuwXdYHFmheJkAtI80umHQAJFeiQWRoG7yOjoK/Dbfv/amK/oJz3IJWANDVkDjUD4GC2w6RDu5rY57wKKBtUE0cagorvn/PX+ls+T5U9P1zGqnK8UF0y7CYSNb8+gAKj30gT1upYolOgdmLvItQqDoRRo956YDAOSHn9WQe/0lO5kHQYHZKnsVUrJ3u7YX1yW6Z8k+xN+NA+nd+I26wCcougb7AZMaTIcoxS4aS7j2HPsCBHfQUNvuIheMuongNEiwyBfGUFlPvt5IC3QkIyrJomIR+ZeqeoWCFn1n7Bmi84SgZXVNA==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 5E84E180012E;
	Mon, 20 Jul 2026 05:08:16 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 20 Jul 2026 13:07:42 +0800
Subject: [PATCH v5 5/5] mm/vmscan: flush TLB for every 31 folios evictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-batch-tlb-flush-v5-5-db943a0d0d6b@icloud.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=5688;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=vRfWGSnXj1NRnsdshI2zRjQUulhC/QjmbpiKDROQvIQ=;
 b=EvGUlVN4y70BkfYRM2zX0HE1C0Yr+zYubCcxUThrRzZh/56vO9L1FCC5cpqFHfSBKXSks/K6x
 ab87sJ8slkXC8FC71/vMjQO1RI+QwEvN7iw8I9vdFs7xRGYx+2jvU/A
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: NROdlRa12C_BqvsJFnYbjXxtk8lK5x-b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfX9Qxm5rjC/Y+/
 Nyqv2bSDk/Ad1hz66wVCz5lEFOdq1ruTvxVh8zXnAitzw8Lioa4ihJjdbfn9toUKidIR8+jXm1T
 PYfDTm1JbV7+Bt7WNkH9dFnpHYsXTmjiV8Oc/ZQrpnVI6IqdHFN+MBbMi5LZRiEsSp2nzVLbGRF
 5M7za2BW9HVDq/ecRgMVspYC/kvC2wRn67QlDRz3cUced4gnl6mqPOja5Xck3rXtAaZINeFpdFP
 C86P+xbvl3aaVLJ8GQL812k2UPb6Sx5DA79KlMWXKCqYiqYZWpaioaajzr5eOin97XWGzet02KK
 9tcZL8xbjj1Mu0wWWRi
X-Proofpoint-GUID: NROdlRa12C_BqvsJFnYbjXxtk8lK5x-b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C57D140005
X-Stat-Signature: 1oicn157rheocw9bda6ox4gfcrju69b6
X-HE-Tag: 1784524106-365503
X-HE-Meta: U2FsdGVkX19TIqRX1T4H5acOC7Zsv6RAxaXA2ioFSylUxpNvDeMHllP+fXWfnqnNwNS9SypTv9mv5sQTkEK1uA7MrcLC8qDUtwrAOfTWR4W4GwmJDYO58Mgzb4KXrjYz3rvdXkbqfNjWZpuI8erE2Tiy3Ic5B3TZ3GvLgTbYHa13DJR7NeXOoY0CtUmA5adw1fYCTu8Vx6p7S1ALEU4b7mQHu5iKOkA7OMMzYAuwvJCTMTzwY6eHDDBPOnZpYriB5oQYFTyAfDCUQXiDYZ2TfxHOYfN0NFi9ZWOy9i2hvLAPIrjXpLddzpWB2bxpTqB08EyQtoG7pMaz1sb+OH05svnSMQQhfAheIn7LSmGJxSwTAlDudxDZrq8ACVIbgJ9J1N0NWw8RB/J0AZnO7gmV2ZcKLZGaTevFykamyY5w+0LQBTx86CDIB8Nkix0xPnJwOwfR3UtRKhXRJtnm6J8npZd4iGQuKEf0teHvxVHBbKojrUWXKCr/0YOJoG5jVNBE/QJVZK4yhguaMi26a6uUPivZw4SxBTBh/GIC913HJMZMQrxXdq5gVEmkWnouZNxWFbmmjLKqCr4v/vQLnGz5ZA5L0OiQP6YOmz8XPxQmx884PpZCphXGEg4+sE1tYaYxK2/t9bb093pbeuq3fOuMCSii3q39ZBKqzJTApmU5FWu1KG7Kf74DdrlFvigVBTz0XkRIMLC5RsTeR63qgRkWlpQUCxvAtIm/h5XzauFCHGN2TILjn46+oOi6Vf70BaOpTvR+tEcyN4sgwvx0yIH6Xeihrd09/mVvlagOepXOPtkCNI62h3Bubb4PWbF/arOQqeb5KFmpOxeg4FByd9flkX2oUftsQ0p968w+vHvILEfPgc4XJQZjdwrdDOXIFF7hzH+Nqjz3D3LL8Zbfz87yFpXmQkMF52wGSW3jEsj5xo/znzzKDgjdehg1i2FIQEkPrRDW0xrCnzvHre2190N
 KZYhVNmu
 mxxXT/yJBj/K0mFcSTeUjJL6wur2BTYULZLQptHfld1ayne01WsgLF8ukziIBaBnc9GRx2v1Mhej2C2KqheAXsk2FtlFWa17rBa13pytN5+tA5UxCHHYK4CCqdnacp/IYFJDmKdcw191uPOUDPVY6QmpD6pw8elPKIQUWy1WwJWj3sFTPffIOhbRhjIDZJJNbHBCj/CP8iXtmSNmpdu7YkFhwwwSSpUw/jw9E2eXNw1zvaMog5MbHrf+4PFJ6y/tCJ+rccr+bHS99hoETa3NAdgtjyXnj2KQcEnX2tR+diXpz9YFx3YJl2FGLbqBP8xaRTkFd2mfRadtz0EM23MFFu24TmAjUtaxH2BBgJczjVTIgLpZZmKj2Jq+ruwGLE5vJdipSodl3t0MCKRcRrX55+7FtvVniRF4rX+HkwV9S6A0rfKEfPOQvX80GrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we flush TLB for every dirty folio, which is a bottleneck for
systems with many cores as this causes heavy IPI usage.

So instead, batch the folios, and flush once for every 31 folios (one
folio_batch). These folios will be held in a folio_batch with their lock
released, then when the folio_batch is full, do the following steps:

  - For each folio: trylock - recheck still evictable (writeback, mapped,
    dma_pinned). If no longer evictable, put back via ret_folios.
  - Flush TLB once for the whole batch.
  - Pageout each survivor via folio_try_pageout().

The recheck step is required because dropping the folio lock between
shrink_folio_list() and pageout_batch() opens a window in which a
parallel swapin (do_swap_page) can fully complete and install a new PTE;
once mapped, a parallel GUP can pin the folio without taking the folio
lock. Folios caught by any of these checks are put back via ret_folios.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bb479ead1ee0..251535613336 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1220,6 +1220,71 @@ static bool folio_try_pageout(struct folio *folio,
 	return false;
 }
 
+static void pageout_batch(struct folio_batch *fbatch,
+			  struct list_head *ret_folios,
+			  struct folio_batch *free_folios,
+			  struct scan_control *sc, struct reclaim_stat *stat,
+			  struct swap_iocb **plug, struct list_head *folio_list,
+			  unsigned int *nr_reclaimed)
+{
+	int i, nr = folio_batch_count(fbatch);
+	int count = 0;
+	struct folio *folios[FOLIO_BATCH_SIZE];
+
+	/*
+	 * Collect survivors into a local array: this avoids walking and
+	 * mutating @fbatch in the same loop, so its invariant (only
+	 * folios[0..nr) are valid) is preserved throughout.
+	 */
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);
+
+		/*
+		 * Recheck what shrink_folio_list() verified before dropping
+		 * the folio lock. Between that folio_unlock() and our
+		 * folio_trylock() here, a parallel swapin (do_swap_page) can
+		 * fully complete -- taking the lock, installing a new PTE,
+		 * and releasing the lock -- after which a parallel GUP
+		 * (O_DIRECT, vmsplice, RDMA, ...) can pin the folio through
+		 * that PTE without taking the folio lock. Each flag catches
+		 * one case:
+		 *   folio_test_writeback   -- defensive guard.
+		 *   folio_mapped           -- swapin installed a PTE.
+		 *   folio_maybe_dma_pinned -- GUP pinned through such a PTE.
+		 */
+		if (folio_test_writeback(folio) || folio_mapped(folio) ||
+		    folio_maybe_dma_pinned(folio)) {
+			folio_unlock(folio);
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		folios[count++] = folio;	/* keep lock held */
+	}
+	folio_batch_reinit(fbatch);
+
+	if (!count)
+		return;
+
+	/* One TLB flush for the whole batch */
+	try_to_unmap_flush_dirty();
+
+	for (i = 0; i < count; i++) {
+		struct folio *folio = folios[i];
+
+		if (!folio_try_pageout(folio, free_folios, sc, stat, plug,
+				       folio_list, nr_reclaimed))
+			list_add(&folio->lru, ret_folios);
+	}
+}
+
 static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
 		unsigned int nr_pages)
 {
@@ -1261,6 +1326,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
+	struct folio_batch flush_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
@@ -1269,6 +1335,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	struct swap_iocb *plug = NULL;
 
 	folio_batch_init(&free_folios);
+	folio_batch_init(&flush_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1564,15 +1631,18 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			if (!sc->may_writepage)
 				goto keep_locked;
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * Drop the lock so swap faults finding this folio
+			 * via swap cache lookup can make progress; the
+			 * recheck that this necessitates is documented in
+			 * pageout_batch().
 			 */
-			try_to_unmap_flush_dirty();
-			if (!folio_try_pageout(folio, &free_folios, sc, stat,
-					      &plug, folio_list, &nr_reclaimed))
-				goto keep;
-			continue;
+			folio_unlock(folio);
+			if (!folio_batch_add(&flush_folios, folio))
+				pageout_batch(&flush_folios,
+					      &ret_folios, &free_folios,
+					      sc, stat, &plug,
+					      folio_list, &nr_reclaimed);
+			goto next;
 		}
 
 		if (!folio_try_reclaim_free(folio, &free_folios, sc, stat,
@@ -1597,6 +1667,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		list_add(&folio->lru, &ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
+next:
+		continue;
+	}
+	if (folio_batch_count(&flush_folios)) {
+		pageout_batch(&flush_folios, &ret_folios, &free_folios, sc,
+			      stat, &plug, folio_list, &nr_reclaimed);
 	}
 	/* 'folio_list' is always empty here */
 

-- 
2.43.7


