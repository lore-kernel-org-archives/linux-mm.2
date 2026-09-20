Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF74CC982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE346B008C; Sun, 20 Sep 2026 09:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF1E6B0096; Sun, 20 Sep 2026 09:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4C96B0098; Sun, 20 Sep 2026 09:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877E06B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:20:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08ED6120460
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:20:54 +0000 (UTC)
X-FDA: 85234200828.09.B5A1B87
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6110140005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:20:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAHegx7U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAHegx7U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789910452;
	b=v9TtI5HGJm9GqWEb0m9DsoUikqMedMA//rOedd/7BsQdyEWFp81FV2tBHCvCcA8NVoc0xj
	mm5YYLzTuyE6K7tHq11zocKvCViKtShGe0P2UbJ8uRsnWUr+IrAFuikRLxeZpkjKT+0loX
	ebXNG+RWGtuMbJfBbGAql/1/OiqxgXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789910452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N8Ta0j6yxQE8E6d6QJNn10RZEWq+rkhSZxxfc8apJyA=;
	b=d+PcVYWaVho2fP8xGzCaa/A0MY1pEZ6v9JGXWN9qtBsi3HGSee+12446f3FE4nA9+LYuLD
	UUCH2s9BDm/klbKj58AtkQ3fiabIjCzBIUWB1UxSqauHiARsQsMuZeGHUt7SdR8t0rEfsf
	YPn+iw/ZgGHhokjqCnVZqhz4RJCcTSI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+qiJEwOkGGHEtLddlrncV+pPVsmFD1CLTG+vezQeo6I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789910450; v=1; x=1790515250;
 b=lAHegx7ULugygqfGHNO+V7kWVDrQDkExRfzyewMxbgPuIJnTig4GMZyJDD4S5sYdvAgoNnjz
 9A+pFSgnSN7lMazCd5kb/sIpVCRONCYSM4H2uMjFY3BlyfdCJUg284L8+GDGl8a8sVZVxYVF5XG
 E0atIbOXjtOFpgWrB3WDuKi4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2fa7e308769992a5;
	Sun, 20 Sep 2026 13:20:50 +0000
X-Mizu-Trace-ID: 2fa7e308769992a5
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm: vmscan: put rotation-missed folios at the LRU tail
Date: Sun, 20 Sep 2026 21:20:30 +0800
Message-Id: <20260920132030.3368138-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D6110140005
X-Stat-Signature: n76n5udwzhx7z6c378iesbectggz1s4u
X-Rspamd-Server: rspam01
X-HE-Tag: 1789910451-210604
X-HE-Meta: U2FsdGVkX1+7FkpyVwA0obTlf8MzXqUlPFfS4ANnXGpmiAfgd+Gv32OyxtF5C1RMEH3bPZF6QHyIPWfCXgE8D40xgmtXb79THMRIVR/ru1yDbIVFXwpESds3G92QTYF0B2l/eiiI79VJbJo/arCRduFNTOYsXJIX940Eo3YL3K+KEJtlAnHiPc6tkggwTB5EO6jcsHDdDy5JSTEBFCGcbHqRZrmvdT+RZ5ZSEnjJ27mO6hjhNlQZtbgiCDwbvE11wihf/9cq/8gF/tE5O+MqyzRBOQzdScDlO+fqTBK4E9DXS5CaPadSac4TiIBqs/1gOGPCv+Gm4c6sTEgWypyJSf5+5sLv5fP+We6sSA3g+J6UUydQLhforKOfGJWqUUafEx+Slwx94qJXMKtVArA3u6w+hl7hIxJV/5IeP0J6I+FEvJWSmIzAN81lXkJzfHZ/2wIXBYEXevuZLSsY4Gc6LgbhS1mcEPjSWhNYL8qUE0KhTHZEcjTNNU7Y7MMOWQnErhHKQaQdqtf0nLSnmJ0JOJtvOCUix9J8wrntGwAaY1XWV1Bg/Nivntulpkm6rU2cDWImFdwv1iiOZAS/ppT47CmFneFF2tkJ4hA9e+N0zNvv6vkknMqKk3HEudrmFP4u4s6p1WJNuc+mIUNFoGOKgMhWdt4EdIUCMPnyRK8Zn3gbOHitHaqjnL9b0RwfTWm+rs7hU1GMTL1RFgbP3ANlotYwUXx93hJlxz74aOHj1cXdNKwaiS+KJ8dXvrQEObDJlyC/JRWN5DIXtitEBPO9SZWb0N140gN98SFOpbho5WkYZ2RM0t5PwgYpZ1kk3qnjmRfFJnsMQDHaCT9sv3GA8ss3D1ulLDLusvrX4eyU9q2wJewggkQsBvyJX86ApBvev1cJBPlONRQ7K5cRJl/Z3P4/U2OveAk9Mix92nqwlajlDODvQ9+kwiz7ohaTtoG86ZKqvtAmWptfFfGirM0
 xQIV9pjV
 7zViEq9oL58WJd9yGX06zj3DB2HF42X4A+lVFY0UYqBtHwu3rGfNOyFxKtEiv+B/dQq/9TL+OxnrexxqUSVSomLgeHBuszU7l/ncmREuDY5mstLWfdGoDrso0Vyv5c9ES5feICnIyUG/6qzuf6YpcscYLF4sv58yceKuZw9cC5WLC8K+ABGS+rRgUsUkG9Z+82a/BfvQ7RLNx9VTD6I85qaUc/VA1lAtivxygTr9zPM6xXkUY+N0EXdgj0notHOCIr3Hs54XGhOrrIKhStlv0fqXqNPXREQG7RgTbpbuGIMQTDvefdI7i9/dy1CjWgyXnGqLM
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
mapped, not dirty and not under writeback).  A referenced folio is left at
the head so it still gets a second chance, and a folio with an unexpected
reference (e.g. a GUP or speculative pin) is left at the head because it
cannot be reclaimed yet anyway.  A new do_rotate parameter gates this so
it only applies on the reclaim put-back path (shrink_inactive_list()), not
on shrink_active_list() where the list order is already deliberate.  This
approach was suggested by Barry Song [3].

Only the traditional LRU is handled here.  MGLRU already retries such
folios via its own clean-list retry pass in evict_folios(), so it is left
unchanged.  The same do_rotate scheme could later replace that retry pass
to unify both LRUs, which is left for a follow-up.

Test result with [2]:

  Without patch:
    cat memory.usage_in_bytes
    1073700864
    cat memory.memsw.usage_in_bytes
    1413124096

    free -h
                  total        used        free
    Mem:           1.6Gi       1.2Gi       299Mi
    Swap:          1.0Gi       678Mi       346Mi

  With patch:
    cat memory.usage_in_bytes
    1071140864
    cat memory.memsw.usage_in_bytes
    1413423104

    free -h
                  total        used        free
    Mem:           1.6Gi       1.2Gi       322Mi
    Swap:          1.0Gi       328Mi       695Mi

After applying the patch, the difference between
memory.memsw.usage_in_bytes and memory.usage_in_bytes is close to the swap
"used" value reported by 'free -h'.

[1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
[2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
[3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/
[4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---

v1 -> v2:
 - skip referenced folios (FOLIOREF_KEEP) and unexpectedly pinned folios
   when rotating to the LRU tail.
 - add test result to the commit message.

 mm/vmscan.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e200ce3eb056..91295070ca33 100644
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
@@ -2018,7 +2018,19 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		lruvec_add_folio(lruvec, folio);
+		/*
+		 * Put clean, unreferenced and unpinned folios that may have
+		 * missed folio_rotate_reclaimable() at the tail to avoid
+		 * cold/hot inversion.
+		 */
+		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio) &&
+		    !folio_test_referenced(folio) &&
+		    folio_ref_count(folio) == folio_expected_ref_count(folio))
+			lruvec_add_folio_tail(lruvec, folio);
+		else
+			lruvec_add_folio(lruvec, folio);
+
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
 		if (folio_test_active(folio))
@@ -2135,7 +2147,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list);
+	move_folios_to_lru(&folio_list, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2246,8 +2258,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active);
-	nr_deactivate = move_folios_to_lru(&l_inactive);
+	nr_activate = move_folios_to_lru(&l_active, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -5115,7 +5127,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list);
+	move_folios_to_lru(&list, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
-- 
2.34.1


