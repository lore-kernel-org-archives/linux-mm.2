Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FDBFD8740
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B5D6B0005; Tue, 17 Mar 2026 07:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312D26B0088; Tue, 17 Mar 2026 07:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229956B0089; Tue, 17 Mar 2026 07:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6C46B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:24:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5F0EBA5E8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:24:57 +0000 (UTC)
X-FDA: 84555323034.13.E401311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFF0540005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:24:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xJaw0TnE;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773746696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vfVunknyLBLJuep0I64MK5J5O4tuOK7I29d2D2gXkvQ=;
	b=4AncJNP1QaX9D40ns3u6e9UuHnfVctawkzoUi4I9DvLq+8Xf+pRC+XmFdr7t+n3xZ8wwrM
	7HX7okZtPYK3OXy4VVq90DRe3V0qJ+ybVH0Hc3PBsdZr7XsKSb9WcuNhzoEP9JJyj8VEFB
	nOQvrPStSyEaF2GZxImcc+5SBuzggqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773746696; a=rsa-sha256;
	cv=none;
	b=dFABtASnqv4GUksPpdmlOCyBvf/X1zxdpIYnq3PuUb5TZ698EKLXvDQkqjEta3A+u+G1pN
	awTJEI8V/TboOMYmssN1QQ4Zn9L9HEWC9hdTBV4hP/oca8vgqtSmGOCsl5f0LyyVqdTJJh
	tplCxRRGVrM4G378ltorpG1CUcOKCHg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xJaw0TnE;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 758AC41737;
	Tue, 17 Mar 2026 11:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD75FC2BC9E;
	Tue, 17 Mar 2026 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773746694;
	bh=0+/PiWhH1H9yOROoWEdYq9+vELjnzpbqXmH3HFEqGxI=;
	h=Subject:To:Cc:From:Date:From;
	b=xJaw0TnEB1DgtOGthTcKFTZfomtzyMeRbbatBtCVrHjvidkNAODgriaZM7NCqyYqS
	 TL8Pqh8OscZ6sl+ht/83DVhlLbQ0IEZMmaN8d81tmz7jMbV2fIKu/mNTx8rvKeAal9
	 GDo57MAc6BeXa/NCmA9PyxHlqCuvnJl3vxGS0woI=
Subject: Patch "mm: Fix a hmm_range_fault() livelock / starvation problem" has been added to the 6.19-stable tree
To: akpm@linux-foundation.org,apopple@nvidia.com,dri-devel@lists.freedesktop.org,gregkh@linuxfoundation.org,hch@lst.de,jgg@mellanox.com,jgg@ziepe.ca,jhubbard@nvidia.com,leon@kernel.org,linux-mm@kvack.org,matthew.brost@intel.com,rcampbell@nvidia.com,rodrigo.vivi@intel.com,thomas.hellstrom@linux.intel.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Mar 2026 12:24:39 +0100
Message-ID: <2026031739-lusty-italicize-e41e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFF0540005
X-Stat-Signature: bquum8sh968umypo1uzukrf8xj6664iu
X-Rspam-User: 
X-HE-Tag: 1773746695-522938
X-HE-Meta: U2FsdGVkX19Qn2Csua22ccxEp62wZmIHRznzF2P8HGNeWODpcs6JUs4dgFLCZpcWmtbI3FckVc+95rXunJ2QcI6U3N5scw3GDgoWEDNMESTOguLxRyKmR5nZUgDelaCME18s7z6/E0/KSxBAdzP93GM6v1HlixOU77DX/2WLXj/ey+re9s+mRjWtG157s6JO2ukcmsvDY5dff6CF8b0ke8ylcxi8VBcsA8cb7VkfTWIpHruGR8FXphKKdbsESwpAarufby+d/BUAFoApEijAN3C17ZUufpxehgTGPdSAYiHyInXgMX+PGnAYTo3dIqzbSXO3WBrCJFM/UyA2CA+ZN0owlhZHmyY2Wo0sE52hxv1ztLxOyEvkn64W2QOGY1RObrn2da19vpA84+ln7MAcOiUftHaH9cUh7UYt8vYA6ZZtql2VlYx7IFFUdvlER76N4WYyjMclFGItFg1Ez5F5uFKKrY23/Fx5c42sAHqyAYKhbON2AzlmSclu7p594bc8sXramxhK3kXctLER+VkjIWNsYd5dBksd3wqFtcIy5tZm4HvFuFqSVsiDsXU6kDQjgDynu4uqeGG7EsVTG4a2rmnUJtP9bsJXwmb6qYp7d40gwjKxyKg4zc4iPWCYGUMIjj6i1lLqp4hYMth/Rb9vDemyWtkz45nHp2pACmVLhuye0XulBGFktHerR3ajDTRbdGPQqYNi2n1LvGrOJTpArnheCfIJQQl1x0pITw+IKYC+1tDrQdw6RFF+slq6QMLhNVEnjwRNFlhpq7Jsr1NiXiO+Xtwj4vTMq4KkrYvsZroVDkinkDjJU/LrBlgNxgsV+CLQ/p2kpxKTi0m0QTsmRGkrjoie3lPjkvP16Gze03/S77KDyXjKbDfH+p2sbjaVzs6yVMASmzd7lLQrjfA8EeulmawnhJw8OCfKjz76vmasqZFcvhND5tKI6DYPXblxQucjWxfSVbRva5t4PQc
 q4045ENu
 WXnlC2Bb0Pn69SRBWLH7OWXVvhLnHNNjAJV3mxCqtDyurqS6PlXMVeAXGrYxgPrhPGruLp5AyDlZIiNhzKRgCsmoBJKHYrXRQNp+DcSmaKqYx2O9CXg/Mj2BHypWgGecY7587o/xXDBaBrBQkb6sLLxndCElGSAGzP6WlvhntYcmzTHKMiV4cDQnk2cc6+o9PCQBkYY6SKcBsxTsF3u59prXYrgrtxWFNaDu+7ri/pOuRv29PZ0GtSV+f6rZ/oM2JnimqqBhL0FmUpBmER1P1QDyGH1P6NvUEdV8oAZg0Z0eiYB1pyAq4VKFfjrTM4u9O+vdT1SOFtkPV9QTHEoojdKP/oib6iMttFEqXKcWU40ml1fhW+thheCmGWbVqZ2Z1krOQa9Ld3XCq8CzD2+E6zaMGdrwCgxcY1IJ2dQghNnqoAuNW5RevRbl3vbDw1O6K4zt6M2/Slu1mHvypZ2fpMt3RBEumMdGLWIE+2PeJMWbritdiCIyL1A0S64cIcmQ8bf1MU8raQnf/Fd5sHx/NWTVFzb3UPseOWBI57NHMrndY7omiF8kGqF3CiFJJd8/KlbbdDU68nLCvxtK1zVnCqm7eGB2mre0pGJvVHgscaHfIe2kvwYeNoVtqJVZH8DiBYzOqT7NHUPSdqQVcXsdjhVbs1wh0A8+D5f9LTUdHSLBT2unepHHNHL26f/NhMYk0Or6sseABvCc8ddq1yj7KB0Ui5/vykuY14+vFsotv+PfxOuL6xZopvgt0BgFl2aeZ7dz8F0HRNWUSdgt/VeVfqmaqgghVNWs+U7XZB3eCjPTN104A/4MDuxldFhQTbscjn+JitFDAHwgMnLAU5ud8ZFIkyPtTGMlyiK8wTU9OcXtPB7v14nO5b8OGSOfJ7MYBOhy+2V7KrKCAv5nXm/MIzj6s7GAD7ZBKwKlMO7I1P+GBWWfJsjPbN1Ikaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: Fix a hmm_range_fault() livelock / starvation problem

to the 6.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch
and it can be found in the queue-6.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From b570f37a2ce480be26c665345c5514686a8a0274 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Date: Tue, 10 Feb 2026 12:56:53 +0100
Subject: mm: Fix a hmm_range_fault() livelock / starvation problem
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit b570f37a2ce480be26c665345c5514686a8a0274 upstream.

If hmm_range_fault() fails a folio_trylock() in do_swap_page,
trying to acquire the lock of a device-private folio for migration,
to ram, the function will spin until it succeeds grabbing the lock.

However, if the process holding the lock is depending on a work
item to be completed, which is scheduled on the same CPU as the
spinning hmm_range_fault(), that work item might be starved and
we end up in a livelock / starvation situation which is never
resolved.

This can happen, for example if the process holding the
device-private folio lock is stuck in
   migrate_device_unmap()->lru_add_drain_all()
sinc lru_add_drain_all() requires a short work-item
to be run on all online cpus to complete.

A prerequisite for this to happen is:
a) Both zone device and system memory folios are considered in
   migrate_device_unmap(), so that there is a reason to call
   lru_add_drain_all() for a system memory folio while a
   folio lock is held on a zone device folio.
b) The zone device folio has an initial mapcount > 1 which causes
   at least one migration PTE entry insertion to be deferred to
   try_to_migrate(), which can happen after the call to
   lru_add_drain_all().
c) No or voluntary only preemption.

This all seems pretty unlikely to happen, but indeed is hit by
the "xe_exec_system_allocator" igt test.

Resolve this by waiting for the folio to be unlocked if the
folio_trylock() fails in do_swap_page().

Rename migration_entry_wait_on_locked() to
softleaf_entry_wait_unlock() and update its documentation to
indicate the new use-case.

Future code improvements might consider moving
the lru_add_drain_all() call in migrate_device_unmap() to be
called *after* all pages have migration entries inserted.
That would eliminate also b) above.

v2:
- Instead of a cond_resched() in hmm_range_fault(),
  eliminate the problem by waiting for the folio to be unlocked
  in do_swap_page() (Alistair Popple, Andrew Morton)
v3:
- Add a stub migration_entry_wait_on_locked() for the
  !CONFIG_MIGRATION case. (Kernel Test Robot)
v4:
- Rename migrate_entry_wait_on_locked() to
  softleaf_entry_wait_on_locked() and update docs (Alistair Popple)
v5:
- Add a WARN_ON_ONCE() for the !CONFIG_MIGRATION
  version of softleaf_entry_wait_on_locked().
- Modify wording around function names in the commit message
  (Andrew Morton)

Suggested-by: Alistair Popple <apopple@nvidia.com>
Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
Cc: <dri-devel@lists.freedesktop.org>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.15+
Reviewed-by: John Hubbard <jhubbard@nvidia.com> #v3
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Link: https://patch.msgid.link/20260210115653.92413-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit a69d1ab971a624c6f112cea61536569d579c3215)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/migrate.h |   10 +++++++++-
 mm/filemap.c            |   15 ++++++++++-----
 mm/memory.c             |    3 ++-
 mm/migrate.c            |    8 ++++----
 mm/migrate_device.c     |    2 +-
 5 files changed, 26 insertions(+), 12 deletions(-)

--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
@@ -97,6 +97,14 @@ static inline int set_movable_ops(const
 	return -ENOSYS;
 }
 
+static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
+	WARN_ON_ONCE(1);
+
+	spin_unlock(ptl);
+}
+
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1379,14 +1379,16 @@ repeat:
 
 #ifdef CONFIG_MIGRATION
 /**
- * migration_entry_wait_on_locked - Wait for a migration entry to be removed
- * @entry: migration swap entry.
+ * softleaf_entry_wait_on_locked - Wait for a migration entry or
+ * device_private entry to be removed.
+ * @entry: migration or device_private swap entry.
  * @ptl: already locked ptl. This function will drop the lock.
  *
- * Wait for a migration entry referencing the given page to be removed. This is
+ * Wait for a migration entry referencing the given page, or device_private
+ * entry referencing a dvice_private page to be unlocked. This is
  * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
  * this can be called without taking a reference on the page. Instead this
- * should be called while holding the ptl for the migration entry referencing
+ * should be called while holding the ptl for @entry referencing
  * the page.
  *
  * Returns after unlocking the ptl.
@@ -1394,7 +1396,7 @@ repeat:
  * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	__releases(ptl)
 {
 	struct wait_page_queue wait_page;
@@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(soft
 	 * If a migration entry exists for the page the migration path must hold
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
+	 * Similarly any path attempting to drop the last reference to a
+	 * device-private page needs to grab the ptl to remove the device-private
+	 * entry.
 	 */
 	spin_unlock(ptl);
 
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				softleaf_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret = VM_FAULT_HWPOISON;
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_stru
 	if (!softleaf_is_migration(entry))
 		goto out;
 
-	migration_entry_wait_on_locked(entry, ptl);
+	softleaf_entry_wait_on_locked(entry, ptl);
 	return;
 out:
 	spin_unlock(ptl);
@@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct vm
 		 * If migration entry existed, safe to release vma lock
 		 * here because the pgtable page won't be freed without the
 		 * pgtable lock released.  See comment right above pgtable
-		 * lock release in migration_entry_wait_on_locked().
+		 * lock release in softleaf_entry_wait_on_locked().
 		 */
 		hugetlb_vma_unlock_read(vma);
-		migration_entry_wait_on_locked(entry, ptl);
+		softleaf_entry_wait_on_locked(entry, ptl);
 		return;
 	}
 
@@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_
 	ptl = pmd_lock(mm, pmd);
 	if (!pmd_is_migration_entry(*pmd))
 		goto unlock;
-	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
+	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(
 		}
 
 		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
+			softleaf_entry_wait_on_locked(entry, ptl);
 			spin_unlock(ptl);
 			return -EAGAIN;
 		}


Patches currently in stable-queue which might be from thomas.hellstrom@linux.intel.com are

queue-6.19/mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

