Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2A4606A332
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2DN3zDp
Received: by kanga.kvack.org (Postfix)
	id 428426B05C1; Sun, 22 Nov 2026 07:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D95E6B05C2; Sun, 22 Nov 2026 07:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0E06B05C3; Sun, 22 Nov 2026 07:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F17EE6B05C1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:43:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9109F1C4028
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:43:00 +0000 (UTC)
X-FDA: 85462719720.07.571D884
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C386340003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:42:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2DN3zDp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351379;
	b=boF0+OS68/mf7/qBB5gy5bt4m2bZbK1ekQHQbdDY3DAuHmzTBSpuT3yePWokzQWn6A5WFH
	0Q+jKWZUDYGXGNwlZbEKt96/CT5T2dk2flZIvbi2yVxIZh1QDfNd1lAZYAVQlICQWb4BwP
	5+TbUC3I2URUwf/wquW93D5/V+G5Kyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prSkEV3qUSQsXfBvO3BgrBMDcq6TDmX7yh8NVtmfjX8=;
	b=riECQNMBIZzQq4w4UYGxVRenA8YbK9jJ/NNgXxwhJNpSNB6T8ufAGKANEAdHd/tEzZM+5A
	Xsipl4rkSjjVY+N2WhcIA51mIk7ZVn3PDgfutQ8/m9JZxR5baRL751rANMfQT1YJy3Uo+n
	oeAUFvIwQPIOZyjYKJYwBTCGitlGsPo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2DN3zDp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D2E43EF3;
	Sun, 22 Nov 2026 12:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891F91F000C6;
	Sun, 22 Nov 2026 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795351377;
	bh=prSkEV3qUSQsXfBvO3BgrBMDcq6TDmX7yh8NVtmfjX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F2DN3zDpfzlAFEs1RV733+O8P9L4dFs4bfg6vNKrU1S+dcKF9x++tDnmL79ryBeOC
	 M5gGX1HzxcyFEVTr/tB8Yz6YU6nowJqc4WFP3Rp15bZF9paeEWdJoX2q3dKUAI/9Qb
	 vTHaQCdmlsKlZ1n5csPyoJBwNBXOi+DCVbU7dDReQ4ejBm+qTqwJlDU903RnhI2lP5
	 lBGjWqD18oKf2tlRFBqmG4VdrplNer3pgnTMEPoykZyIIdjHxC1KY1fFkn8OzIrRm7
	 2T+UVXDTIMedjV8pFLRCUAeWX5j2aXwdCwUvt8MVmJoEYXdnRxGjSQA8kIf8Xcy3jn
	 0tmnZQ3cLAyVA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 13:42:18 +0100
Subject: [PATCH 2/2] mm/migrate: allocate destination folios before locking
 a batch
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-migrate_reclaim_deadlock-v1-2-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10238; i=david@kernel.org;
 h=from:subject:message-id; bh=iRR0SjdNoHcH4WpV13Z+oejWwFpcHvtvx5X9gVhezrg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZHpsezVUJmah4c1X0j8f/DBz23q1iPSYgVn6k6dOMj
 M+z5im/7ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi5gUM/92zrSoVZgo1K58O
 TTc7IteeLv++fInhIhmfCRH+7dHc4Qx/+KZeSS2r9b2RsrrpoWCy4Yre20Kh7962SZebTmi0VKx
 nAAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C386340003
X-Stat-Signature: 1haobifwyyojuzmw5iwwnsp37oh9d4db
X-Rspam-User:
X-HE-Tag: 1795351378-324752
X-HE-Meta: U2FsdGVkX1+pvSIsiWU7JCx5fzfhrhTmnkrePOSP1Rd48Y2lXfOhV2OZXhDGSyWuOC90nNy7LbR5OdPOAhQeiZ+9HekK/KJBXlJBOTYI1T7Qg5hrh7jpSIuqv5+c4It+OkMnG7xGApKORNt6W1YqudTnScUKf+ncw43Xc1+XpI5+QcT98HW7TuEOrFAjJ2VvaLNtiTDHi31iS+m7tjim6IXQbp4hJl+hVr9meduV1zb/pG3T/xytKLuk2Bd9oYurZiz2d7i51Zgz36N4yTJBptJ0pzA5eSLeqZtL6BJKMiUxdHPuwPXRSOv5Mgk1i7Uf72mnJbdK1YQpdA4OJlcsD7leTmc9CVJOuhNbLgIXHcuqDmIm+wAZb2G+Bit3VgzKBJrhXX6HZiCSZSH2tRCizsmK+5h15+ryPuD9aAIwRoitOBZ/BjMOx8nG1LHG+EWUY/5ii7FQRVRoIb/6vWmj27wtvCvauY7g+GTlWHg+yr8THLSJxHrBlGfDtCK9tBKQf5M/qR1SoKa9JQ72koSgyyFeBpbiFMPfcwQyJegmyrc+JsYuKYgC9ym8WnsB/gRG23kuF/KUFCR+xUdwGFQIdhI7X+DPAP6/nvmNVPTPYsJ/DWub5E+SwiOt8uRUIvzuP4NGknrCo3YuvVJUvL6ESCbJWsNd+weKM9lhfYzoCWP2j51/dMUIu9S+PNL4bq7k13r8xaQUEDowouUUC4cDACbic81pGF+TWCh5CYJpl5KZI7C2VdwyosgsZSTvMp/+g7j4gvls6yIbcStyjEKnLsVXgw8dAuoCPaZ25miGMfLWRsJiF4jlUrA7eLWyY2QjQ/qIAwNHABlw5tZ7csAfL7RBZ/YPO3SMWNtmcb2VCv7fqwT4AIuWCo9Hv0QPZ/iu3A7BVd19N09nNUjxWkE5kELAfmU6Ks/HQoPoQISxvC+ghNAK9DvoKw9YmOyKzng2hOvn3Nu/5ii61AqgHqs
 CStPHgmX
 rs8NrO74XxqLWxuDUYecluBYY87IkwT26W4HHkVo2ywyAF+yDz/r+/0bBwgVyhs+hy/1md194loCNCEuUOMiNIZG8NjPncwz2IQm9N00ey/Nn+AvlmuU5Jp8cc25hc4JAaDjkK0i6l7KAiZjVT+DNgcNKz6pCbRQe8wOipFunROMfaHtxsA9UJEnv5MT26I1T217QoYY8sOVd6BsbsimRFKXfGZ8hlQiDfO5qZUR1yHBQSLVzPT9xsgvrXr/b8StQUCP/FRBB7LBmPGrDms44P/9kqy9GMrMcDdq3U1Mw6fQL+qseyLEuDytpN1wl7DintJMersCPDdbr59yAwCYOZ/jdTytHVys6CtBtHmovkrenXl7kpcUpWCqEUOmdEqK3ESFvAGuTDyGuVLE6JxieIW9kIIYjBogRsD7cTkCZG0xOo1hj8TE6xpybqg+UBJFWJDgCY+eN1Wbs1njzvqLKEHAGJ6kLmmVw5PsndcslneBQhtVRLUREv1vcwOi9r1Ufy54JelVtdJT7w77+BmQY4/SDakM1zqIYaHp3CRXB6gm6jFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Migration locks folios without holding a reference on their inode.
migrate_pages_batch() keeps a whole batch locked while allocating the
destinations of the next folios. If such an allocation ends up in direct
reclaim with __GFP_FS, reclaim can evict an inode through the dcache
shrinker, and wait in truncate_inode_pages_final() for a folio that we
hold locked:

    migrate_pages_batch()
      migrate_folio_unmap(A)
        folio_trylock(A)
      migrate_folio_unmap(B)
        get_new_folio()
          try_to_free_pages()
            super_cache_scan()
              prune_dcache_sb()
                iput_final()
                  evict()
                    truncate_inode_pages_final()
                      folio_lock(A)

This requires that nothing else holds a reference on the inode, and can
be triggered most easily with FUSE, which evicts inodes on the last
reference.

Consequently, allocations under the folio lock are dangerous if we
cannot prevent that scenario through an inode reference; and we want to
avoid grabbing inode references, because we might then drop the last
one, and would have to evict the inode from migration context, ideally
without holding any folio locks.

Allocating in a NOFS scope would be one option, but it would have rather
bad side effects, such as direct compaction not migrating file folios
and the OOM killer not being invoked.

So let's fix it by allocating all destination folios of a batch before
locking any source folio. Now, we no longer allocate destination folios
while holding folio locks, which also avoids holding these locks during
direct reclaim or compaction for these allocations: an improvement on
its own.

We keep the destination folio of a folio that we have to retry, instead
of freeing it and allocating a new one. If we would have to allocate
while already holding folio locks, which can happen when retrying a
failed split for longterm pinning, we leave the folio to the synchronous
fallback in migrate_pages_sync() instead, which migrates folios one by
one.

Note that nfs_migrate_folio() still writes back the folio while holding
its lock in MIGRATE_SYNC mode, which allocates memory. As NFS only
evicts stale or unlinked inodes on the last reference, this is unlikely
to deadlock; this must be sorted out in NFS code independently.

This has medium urgency.

Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/migrate.c | 134 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 37 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e6cd83cf32aa1..3bfa4f9dc5078 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1220,25 +1220,15 @@ static void migrate_folio_done(struct folio *src,
 }
 
 /* Obtain the lock on page, remove all ptes. */
-static int migrate_folio_unmap(new_folio_t get_new_folio,
-		free_folio_t put_new_folio, unsigned long private,
-		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+static int migrate_folio_unmap(struct folio *src, struct folio *dst,
+		enum migrate_mode mode, struct list_head *ret)
 {
-	struct folio *dst;
 	int rc = -EAGAIN;
 	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
 
-	dst = get_new_folio(src, private);
-	if (!dst)
-		return -ENOMEM;
-	*dstp = dst;
-
-	dst->migrate_info = 0;
-
 	if (!folio_trylock(src)) {
 		if (mode == MIGRATE_ASYNC)
 			goto out;
@@ -1364,7 +1354,8 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 
 	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, locked, ret);
-	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
+	if (dst_locked)
+		folio_unlock(dst);
 
 	return rc;
 }
@@ -1809,6 +1800,25 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	}
 }
 
+static void migrate_folio_free_dst(struct folio *dst,
+		free_folio_t put_new_folio, unsigned long private)
+{
+	list_del(&dst->lru);
+	dst->private = NULL;
+	migrate_folio_undo_dst(dst, false, put_new_folio, private);
+}
+
+static void migrate_folios_undo_unused(struct list_head *pending_folios,
+		struct list_head *new_folios, free_folio_t put_new_folio,
+		unsigned long private, struct list_head *from)
+{
+	struct folio *dst, *tmp;
+
+	list_for_each_entry_safe(dst, tmp, new_folios, lru)
+		migrate_folio_free_dst(dst, put_new_folio, private);
+	list_splice(pending_folios, from);
+}
+
 /*
  * migrate_pages_batch() first unmaps folios in the from list as many as
  * possible, then move the unmapped folios.
@@ -1831,8 +1841,10 @@ static int migrate_pages_batch(struct list_head *from,
 	int pass = 0;
 	bool is_thp = false;
 	bool is_large = false;
-	struct folio *folio, *folio2, *dst = NULL;
+	struct folio *folio, *dst, *tmp;
 	int rc, rc_saved = 0, nr_pages;
+	LIST_HEAD(pending_folios);
+	LIST_HEAD(new_folios);
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
@@ -1845,7 +1857,14 @@ static int migrate_pages_batch(struct list_head *from,
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
-		list_for_each_entry_safe(folio, folio2, from, lru) {
+		/*
+		 * Prepare the source folios, and allocate the destination
+		 * folios before locking any source folio. We lock source folios
+		 * without holding an inode reference, and direct reclaim could
+		 * try evicting the inode to then deadlock on folio locks.
+		 * Further, this reduces folio locking times.
+		 */
+		list_for_each_entry_safe(folio, tmp, from, lru) {
 			is_large = folio_test_large(folio);
 			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
@@ -1925,21 +1944,24 @@ static int migrate_pages_batch(struct list_head *from,
 				continue;
 			}
 
-			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
 			/*
-			 * The rules are:
-			 *	0: folio will be put on unmap_folios list,
-			 *	   dst folio put on dst_folios list
-			 *	-EAGAIN: stay on the from list
-			 *	-ENOMEM: stay on the from list
-			 *	Other errno: put on ret_folios list
+			 * Don't allocate while holding folio locks, but leave
+			 * the folio to the one-by-one fallback in
+			 * migrate_pages_sync().
 			 */
-			switch(rc) {
-			case -ENOMEM:
+			if (!list_empty(&unmap_folios)) {
+				retry++;
+				thp_retry += is_thp;
+				nr_retry_pages += nr_pages;
+				continue;
+			}
+
+			dst = get_new_folio(folio, private);
+			if (!dst) {
 				/*
 				 * When memory is low, don't bother to try to migrate
-				 * other folios, move unmapped folios, then exit.
+				 * other folios, migrate the folios that we have
+				 * destination folios for, then exit.
 				 */
 				nr_failed++;
 				stats->nr_thp_failed += is_thp;
@@ -1950,7 +1972,7 @@ static int migrate_pages_batch(struct list_head *from,
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
 						stats->nr_split++;
-						break;
+						continue;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
 						/*
@@ -1963,18 +1985,42 @@ static int migrate_pages_batch(struct list_head *from,
 						/* Undo duplicated failure counting. */
 						nr_failed--;
 						stats->nr_thp_failed -= is_thp;
-						break;
+						continue;
 					}
 				}
 
-				stats->nr_failed_pages += nr_pages + nr_retry_pages;
-				/* nr_failed isn't updated for not used */
-				stats->nr_thp_failed += thp_retry;
-				rc_saved = rc;
-				if (list_empty(&unmap_folios))
-					goto out;
-				else
-					goto move;
+				stats->nr_failed_pages += nr_pages;
+				rc_saved = -ENOMEM;
+				break;
+			}
+			/* Remember the source folio until we unmap it. */
+			dst->private = folio;
+			list_move_tail(&folio->lru, &pending_folios);
+			list_add_tail(&dst->lru, &new_folios);
+		}
+
+		/*
+		 * Lock and unmap the source folios. Each destination folio
+		 * remembers its source folio in ->private, so walk the
+		 * destination folios.
+		 */
+		list_for_each_entry_safe(dst, tmp, &new_folios, lru) {
+			folio = dst->private;
+			is_thp = folio_test_pmd_mappable(folio);
+			nr_pages = folio_nr_pages(folio);
+
+			cond_resched_tasks_rcu_qs();
+
+			rc = migrate_folio_unmap(folio, dst, mode, ret_folios);
+			/*
+			 * The rules are:
+			 *	0: folio will be put on unmap_folios list,
+			 *	   dst folio put on dst_folios list
+			 *	-EAGAIN: stay on the pending_folios list,
+			 *		 keep dst
+			 *	Other errno: put on ret_folios list, free dst
+			 */
+			switch (rc) {
 			case -EAGAIN:
 				retry++;
 				thp_retry += is_thp;
@@ -1982,7 +2028,7 @@ static int migrate_pages_batch(struct list_head *from,
 				break;
 			case 0:
 				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				list_move_tail(&dst->lru, &dst_folios);
 				break;
 			default:
 				/*
@@ -1991,12 +2037,24 @@ static int migrate_pages_batch(struct list_head *from,
 				 * removed from migration folio list and not
 				 * retried in the next outer loop.
 				 */
+				migrate_folio_free_dst(dst, put_new_folio,
+						       private);
 				nr_failed++;
 				stats->nr_thp_failed += is_thp;
 				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
+
+		if (rc_saved) {
+			stats->nr_failed_pages += nr_retry_pages;
+			/* We return rc_saved, so don't update nr_failed. */
+			stats->nr_thp_failed += thp_retry;
+			rc = rc_saved;
+			if (list_empty(&unmap_folios))
+				goto out;
+			goto move;
+		}
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
@@ -2026,6 +2084,8 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Cleanup remaining folios */
 	migrate_folios_undo(&unmap_folios, &dst_folios,
 			put_new_folio, private, ret_folios);
+	migrate_folios_undo_unused(&pending_folios, &new_folios, put_new_folio,
+				   private, from);
 
 	return rc;
 }

-- 
2.56.1


