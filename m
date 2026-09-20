Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93160C982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F666B0088; Sun, 20 Sep 2026 09:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528C76B008A; Sun, 20 Sep 2026 09:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0F66B0092; Sun, 20 Sep 2026 09:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 145A06B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:25:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 085C3C0432
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:25:44 +0000 (UTC)
X-FDA: 85234213008.05.E4E4922
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF4D140004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:25:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uro0nBkd;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789910742;
	b=gXwXP/nnvTtwzcrdyQUhGmaCGVywJ/sSeGvIdcSDNKJ6jpFDNrnMYnm3LuVVQ1wXtNL4W/
	IcP/YlgCg8jb/5jYJ5XlMGayAD4TuAzZk2bHyr7eYMCzrGFx2jWekE9IkhJkdTOYCBraJU
	jVkbFOLRA/K0fqf0nIuNu4Rad5pLysc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uro0nBkd;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789910742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y1Xrc3ttFPfr7EMnbRknnznV0NJneGqcF9hcQrywfe8=;
	b=y5ywoHey4vISroZAn6z6FebhWxvg8fDoyztdF1WuURa+HgXftBhjSeCXuSbLbIWV4z6Kb3
	0bBUiHBoXk3IrGUcTQtLyZoVQEsyt0NH5xFB1ap+VX4qfaR2uX4nq2V8YsDZDxguD4Vnrm
	/Vj8+fMXCWP2QTK62nQ48sTE6J2ydxk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2FjJE9PDNzwg8wqFlDFAwHfdMqqaHvEgbFuf0Zw7tso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789910740; v=1; x=1790515540;
 b=Uro0nBkdxPeb8ffcE/EWaEIsEPvz3KkI/ch2VRyY2TXd/YdNlodSIKtLN9Ii3jtl2+6yAZEd
 YVeUcRZWAt9WN4BfHiftQyZMTBLS2xVamgZoY/3GjsBCo+D+Siutonr2GNzv4KYXDfCgNhSEJ7f
 AbuSeveXIi5yFtrXlGOWVJzo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e531f2b7286c07b;
	Sun, 20 Sep 2026 13:25:39 +0000
X-Mizu-Trace-ID: 6e531f2b7286c07b
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
Subject: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the LRU tail
Date: Sun, 20 Sep 2026 21:25:19 +0800
Message-Id: <20260920132519.3369946-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF4D140004
X-Stat-Signature: exax4zz6esqkbnza79585hhwfnxoichw
X-HE-Tag: 1789910741-151664
X-HE-Meta: U2FsdGVkX19udy1ae2i85FJ767etDxqzUHpVFZHlLC3El/ERgjYJCdnnQ2aEqbrYyHxSlRWwZl9Akp1BO4twi0qa5cK3Tpn/9Vp4Yq1U39i0x+HTz2PHfRaJsOODZPBw8+XuwkjJ1N15zZqCJc7MY52m/ZDgGy3n2QaShsrYlU2OtsqJfzhgol7+r9i0JahaazomoHhWTMINZvR+VAN9/3Vevu3i+EYSb9u4yIEgPtEcQOzv2kaXbr/5/t79f97DYlEf+Ua8+jU9UPmlV7YeIRn8JJPkpv8Ni4Xl7vI224njaDXoNZCfBfWjo7yV9cm/rK5nwZ4sSsY6lNfnRRvFE6yULBFpBBV+EGNyiUOw44F0zucENmlHChO1pghrVdupYPmvgjXg4LccvynAEAcJpOKjfvtg6SNaKTi8G4ObSHff5Cf1qgYxXtjouqq9JZyk/nKLAaVl9EN5irTywtTuxXtfxedePG+lIFN9JwZjjdYihkDiy8YISv3V/KSOQP8KFVC2CLi43SaslgnYn12TpWPaaez5ZKnHMxzoXrBVNPRnSRje+3vVC+uOf5jmPkrY/dWMbmOghKjGfySHFgc1jYiiKWaqlu88Rm3n/q3LOdQ/6IEE3We0R4k//ZACwDepZ2IV/D0Zq9MB93fhgM3e3Rugbq82CI42hEE38j2uGBgSrJNv2afTXSjkvKiBBvUbrqbGigceySz+l3NGtd1ZDZrwkOxgDQL+QO2al0eS2ZzXHVpZD63KwSzK+puowL5zE4Mtx1lIokhI8hCUcC4riF2vPBlqQJlJZFrawE0RDGA/JDRh+jWImlgRG+m1vgLPVs5gJk5Mom3QbXMlPR3Ex7jpJn1YTWm8h3T9bLcuLLM5P8grYaTtGvCoi2XVH/mpCa2bMdWrDIuKRKZ6YFHTHaGr93zwaI6Si81IXnk6tcimGKYmHExzOV2200UUgKlui3oEjFke61Croc4b+mO
 QcKmMwXt
 S18gFSvLF6WHw8IBQrqZ1k0Ii6MZYrnSqvIi/OJ26l9bt9mHlnFQPqQX+oIZZ2l1GUB3IL+EuLdW7x2cW5epGeQIUZ0N1ai+UIgM7T5BBTPWrB6takOcHu2Y+Y45eWMxSZtE2GLkcHhpGdUZ0vtB5hVD4pTpOxr1u2avi0IoGb18nOetWBmQW+4n/lwgKV13Majx1VJ9eVujZq+u0ZTYBbgo3EN74vp9UG9oi5l57IzPPK0id68lnHbwb6iS3V880EmX0N7ZoJY6zHhdRxE74ZsmvI1C1gqceDghpbL3ktRGng2z/gTwT9sWxnVZPe1i7CrMZ
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


