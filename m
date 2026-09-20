Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012AEC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 04:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10876B0088; Sun, 20 Sep 2026 00:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1D46B008A; Sun, 20 Sep 2026 00:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6FE6B008C; Sun, 20 Sep 2026 00:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 888E06B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 00:30:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 082A14038B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 04:30:39 +0000 (UTC)
X-FDA: 85232864598.02.47966FC
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf15.hostedemail.com (Postfix) with ESMTP id B99BAA0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 04:30:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e4VmGXpK;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789878637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e1Ub8okJs7IcitWQ+xDKWOR2h/g7iI20C2C780mvtcI=;
	b=EZu2/uW+PriWzuCtV63eJ+DXV3euJNc+rxXd0nEhBLWGLITivvsIDwTFf+Pl1BV2uWCHVI
	QduoFhqseYS8qnX0yN6JotmlZdoEe67BTgarcD33xGAp3yxT93JIxZvu56+NEDGHIyrYZs
	8F2+8vn58p/Wvmhhg6FJOG3NcHvuJrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789878637;
	b=iO/WxEPI/8JYzpMTi64hL3tNrUYve62pqNXWoVbayx2VNBzBDbyJ3wt2UOrcuDyrHpgtyc
	PMGE1gvLLbYjvjIU9ojqIPTFq0HeXMYZ/K04qB1I3EMMiEExB5SIdzghxcws288irf1IRB
	f4qVxcKLlhrJF+LHEAlHrhUN1XFR29c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e4VmGXpK;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TgrUaoIcfeyXCzjO0gIV1NEvHecdV5MhC5ykQWIT36o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789878635; v=1; x=1790483435;
 b=e4VmGXpKHlhLHeZexgq2+8IOwttKu+oAwkaVFcf8oA/3+8bCewKHXNZ8U71kDeZmOfi/J5DF
 sHAVKV63MmYJ4yVO2YNrRyqNGHXubWX2zTxWCowrRK/W2sQMxDjaUKIgmFFLCBfpJuOwJPOrXAc
 7QeC1c7DmQ/r8pWF7IGnzDPA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dacf3ab7917213a9;
	Sun, 20 Sep 2026 04:30:35 +0000
X-Mizu-Trace-ID: dacf3ab7917213a9
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH mm-new] mm: vmscan: put rotation-missed folios at the LRU tail
Date: Sun, 20 Sep 2026 12:30:15 +0800
Message-Id: <20260920043015.3126317-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 37uyd1t8exrsfdzxr4b4p8gmajc7cgji
X-Rspamd-Queue-Id: B99BAA0002
X-HE-Tag: 1789878636-280539
X-HE-Meta: U2FsdGVkX1+IeNEWWhZYFGccHPnTq0cXd7AOv3crZo/0PK4NVBULpHcmCsCu0sJjcMtGvCKChOq6t/Ct1LugQSjAIuC0K+/78ocOcHGKQ2Rq9K2i9Z//rGVm7AzHV4rOCK9jgf3X3UpQ61MdUM/8qzytN+bgWAmLsMetUWnvkNi0VmvQ770keuoxnejSsegGQOS2gOzcTtKeAMNdfBohLCPFxtYTJ1oCAmoUzwJMw4xyaff8o2y0Lo2ZN1KqKYHK7ML9Cf+Y5PfDPbHr+z2ngVrI00MryDBeAqXSzyjBUgYzBb+ymO236rOo4+jFpjG8LRQmsDnjXLg+IcHnANqIGnsIw2fmdXve8UThjaVp5DRwBVft9rQDL+EnfNaxfUwyBgOZkmzjH1X4XtD/tpOIW+1izgMMgcORyBevkJ64Bav5YwcKgosRErC81bsFM9HlLHtbsGDMXYTUN+W5cN4PkHXyMIuDbF27mSg4Zk4NDB3DrLF+8kHSXlMd2DpmiyjJzEbtEqAsckcK2dwy52Qjrg9T2GAH3lhTVGCoGFzRS5HdqB5A6PEtLJedPP0EmG4VhCPT1TZd1HKLP1MmUV5WCg8G5s2ZKSjIUmJekwa2xsgMv2EtwMKiiNks4bETncE/gWtt+9OXrTV3YdC8q4C1X3zDp6bonUf8vLlBzABJjjl9l6ztDyZyni4tDr9VR/nhm/1O5onLxd/hcLDczhawyxQyrvXbnapMBEjnTQNrNsAR4hN1siP/Lf8i7JQF6xRhouDsqeP5JGudBQ81yCQ9bPdIJOuSTsUg4sR0/yOnq3DIeP/pT2yLIURn1JnDUauBsz0FhiXk5J79rlUjG0E4mXNlqIzEmQVL/Gk3ah4YEs+yMSiGh4GtRYDGhFcNfjZefv9MjeJRcrVPEoZyAaMD6SXoBObhdkgRj83DYu8FXz/epXkJP8ttCcIzp3VS7UwOyRv+YqJY6MqESzxKVKo
 6uILxXLf
 Qk73poMnKH2Bo35WhN3U9RXsNpcXB0XWUfKm/QPQPZYOPFwTLRcksTUHeVTXEg3sXApeMFLJ6rda1ORwCtZl1eN1tNIqQGln2inU7Ks0PY165S//00ih4EWK5Lsg0Eac4b7EAx06QxhhtGBwUdMfnhoYqC4B3gaJoccSA6CHgQkDkrlKLrtK7k29M+M6o3XeFFEBVV1pUeBs/kGWUgS1IqWo2mCi5m7SmHnyiRXDgtUd3f2LzdU5nzOzjmbg3R2C1gJNtgR0D9mPPF2cOAcL0ba84a487Uh8Za3AGA6lbzuZF9bdzA4c6aSxBeIEszLd88ryP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The page reclaim isolates a batch of folios from the tail of an LRU list
and works on them one by one.  For a suitable swap-backed folio on an
async swap device, it queues the folio for writeback and, after finishing
the batch, puts the folio back to the head of the original LRU list.

Meanwhile the page writeback flushes the queued folios in its own,
independent batches.  For each folio it writes back it calls
folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
tail.  But folio_rotate_reclaimable() only takes effect once the folio has
been put back by reclaim.  If the async swap device is fast enough, the
writeback can complete a folio while reclaim is still working on the rest
of the batch that contains it.  In that case the folio stays near the head
and reclaim will not revisit it before wrapping around, causing a cold/hot
inversion: a clean, written-back folio that should be a prime reclaim
candidate is kept ahead of hotter folios.

commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
isolated") addressed this for MGLRU only.  The traditional active/inactive
LRU has the same problem, reported at [1].  A reproducer is available at
[2].

Rather than re-reclaiming those folios (which would drop the swap cache
that may still be useful for a future hit [4]), restore the rotation that
was missed: when move_folios_to_lru() puts a folio back, add it to the LRU
tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
mapped, not dirty and not under writeback).  A new do_rotate parameter
gates this so it only applies on the reclaim put-back path
(shrink_inactive_list()), not on shrink_active_list() where the list order
is already deliberate.  This approach was suggested by Barry Song [3].

Only the traditional LRU is handled here.  MGLRU already retries such
folios via its own clean-list retry pass in evict_folios(), so it is left
unchanged.  The same do_rotate scheme could later replace that retry pass
to unify both LRUs, which is left for a follow-up.

[1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
[2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
[3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/
[4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e200ce3eb056..026b844c681f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list)
+static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -2018,7 +2018,16 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		lruvec_add_folio(lruvec, folio);
+		/*
+		 * Put folios that may have missed folio_rotate_reclaimable()
+		 * at the tail to avoid cold/hot inversion.
+		 */
+		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio))
+			lruvec_add_folio_tail(lruvec, folio);
+		else
+			lruvec_add_folio(lruvec, folio);
+
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
 		if (folio_test_active(folio))
@@ -2135,7 +2144,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list);
+	move_folios_to_lru(&folio_list, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2246,8 +2255,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active);
-	nr_deactivate = move_folios_to_lru(&l_inactive);
+	nr_activate = move_folios_to_lru(&l_active, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -5115,7 +5124,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list);
+	move_folios_to_lru(&list, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
-- 
2.34.1


