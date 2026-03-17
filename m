Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BDFFED9E4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 15:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751586B0005; Tue, 17 Mar 2026 11:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728C26B0088; Tue, 17 Mar 2026 11:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63ED96B008A; Tue, 17 Mar 2026 11:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B8F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:40:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D1FCC1360
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:40:24 +0000 (UTC)
X-FDA: 84555966768.04.E28E575
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2E2EA0013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:40:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PmxBHKrY;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773762022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ss/YOY0MlM2EkDO/K4VslbhqFyTIhNCI6DZCT7IaoOM=;
	b=cKvsi7GT/SKLN1PNGMMJvzI2AhJW26mEysZ5JWGx6yB3Fi6EsJZugzaE0ISjK6aQXaYWdp
	304XyF3i5fZ6d7TT5tn7h2E9ZtawxPvBY60Gl1/PUIn4wHrLRcQmo7oo4LHdatNGn+GDpJ
	9oLJmNSeHOXXgDHRn1JAgnJa07Er72A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773762022; a=rsa-sha256;
	cv=none;
	b=Y73F/dhEGvnlnfTwf+q2zWf6TfnTOzKlyEJb3tqO6357k6rgl/ypwBo5xLP9dihWGwDybQ
	uiTts6fRw5B2VXIJY1mE0Zg8WT2u8M8DGapalOPCXlWaOehttWhK3oyFb/PKBMSayIjSup
	uTQr61YAR88zpNq6jJq9XI0iRWnixOk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PmxBHKrY;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EFA040337;
	Tue, 17 Mar 2026 15:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A2C4CEF7;
	Tue, 17 Mar 2026 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773762021;
	bh=RbyKYx3ZltiVONewaa+6ZOG0VhY4IhEX8bM8BbZm0j8=;
	h=Subject:To:Cc:From:Date:From;
	b=PmxBHKrY9PX6Cvpr1C55nHd5fkGE18WYKIkiV2dC6Mob6NMwwPvFjbAc9rvCKMDfl
	 ef4Y4Dy6dEgjaMsZ6jxKb23TxJE+BwGNwSVLXtSDtVoJ8ctsl0M9MxCAuEevsMx74O
	 2wTRrSJWu9MkzTYpHjfwCjWZvkYaiSfkQs8IIkvQ=
Subject: Patch "mm: Fix a hmm_range_fault() livelock / starvation problem" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,apopple@nvidia.com,dri-devel@lists.freedesktop.org,gregkh@linuxfoundation.org,hch@lst.de,jgg@mellanox.com,jgg@ziepe.ca,jhubbard@nvidia.com,leon@kernel.org,linux-mm@kvack.org,matthew.brost@intel.com,rcampbell@nvidia.com,rodrigo.vivi@intel.com,thomas.hellstrom@linux.intel.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Mar 2026 16:38:58 +0100
Message-ID: <2026031757-jackknife-bacterium-3840@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2E2EA0013
X-Stat-Signature: yxwr77opra69td69dfrqhh4bwp5hfwxu
X-HE-Tag: 1773762022-699618
X-HE-Meta: U2FsdGVkX18zjfMi7lE88ShiIemXTVCZcdoDZUMmEse90eKpOA5dv53nlWeiwQgfob36UP2+g5WrBWysvYdgvDnYZFjvQKp1d70CsitBnVfX3nGv0jKDfCHeJjEjJfsflnJIS7tqNsG6Uo98w9z7f1Yw4SD03uewZk/bWh5ThDJu51NXOJt6LeMoquFACVOJdCz6VOLacJVzDnBOlQ2/3BRMXdJwWpa8lAlZOOEUQS/rPmAu/JL/t/8syG+zaslzBwwwXWeDEWuNbFiKVuA2b097TDZRtM+aq3i0xMe+36q3i/CNnE56seUjTBpjXA/G9I44RAciE8pGzfE8nMBsAKM08fzWoV4CZq03O2RkFaXwCktFI+BJQtBHyhPS50DgeAfOHXP2BW8k82D4Q2xSOXMDAsWF7Dra34/iWos2sPx+m74oj4LTqxpw7p6J23SVgveIJmiasibJzv3j+tCzUvCUA9SSaTPBD4W4gQ57C1G3xitb+wyyT/D+2vAUzCtZQ+MXHUQnhsxaqivLCXK7unTj49p1Mf7+NL+gk/5ciNucohmSKR1FWRqDcoIfT6l5hESshEIiBCgDNN1pe/G5V5SbWJg2lVY/41+WmrCtnUmBb68aCBd4ZQ0rqi1/GHzBUCcf/dbkbV7PdxUkJvq4kiWUQ4Gk3Kn1PWlReBC9K4ajFf5p9e1h13saHZSm8vznbcwe8f8Qsyv+u2UUq78b9k+HnUcQ6WB8SXU0SuOOAnPSXKvmly7DAkREBwYj3g+ejSe+mym8MVSoMlMoTeGl0UgKEOuIVhTke37QZTVlG2ASx55wgo4eYRHcFQyB2xVJtYQSHpGBchwfH+g4YGDu9ydnnXZPV2KnsRWqk666s42kf3n6Rd2s5UNIMVWT52JzEaqzGa+8YGggnpNP3x0aREAL43RUeX88lUlBAP3cFEkCR+O7U5Fb4HzV+hEeCw/gPHOQq71jra6M89hnGRJ
 ZPqOunKP
 GhGYvDaBrIg/FPnTYfiuZC1x4JuaoNFSkc7wH1IgiKx23aVFI3SeyoVCQ5+2Cj3DftcAWuKjng/1njfqwI3lzYn+iE6Uhr8RHXHhnOqLwKIFHxfTRGVoD1B/cSNQ3rbmuuJG3FYbL/mdblWZljGev5/11Mg/jlSu0Pyt2GSLHbe1ISF2sdSMDLGEBAAYMMdiBh2d3Ym1gGKbR2UZFwSukifa5+2VEeKaF2yCLI4PgI93tjqASBIo+62x+nwwzKs6II5wYO+wH24mIo+7Zf6dSCCKl301pVAke/haMk8Z4UBSSPRpMli301VNmBb7QADMJC1Hw0psTKrmHBQnjd2ldNW/wRYjyNZlUwZim6sgmdTUADdSYSSHapM0vrCKUzL1jYaY/y+dLKyt5OBegQAf/5G5dUSZLG4gpsn3XnvmZouleL31HtcZrn46n1DGbIr7ZZlRj1zo+XwQi314s3myfup9j4uQwNpxK5M9GuysC/nAnJmRQ7YxDO2lJPCyALGVybWe/zlf8LgbyOlDrzE+CxM3TIo90qg6pO4HFiP14yFcIWm+r8e8UFkT+2Ul7IS4WD1fPV6Obkg/CfQYSUtxuV41PeQtuV8Bu0YTo1dl8OkDC2rO4EKeTOz7zQ14Ea3bq+uBLECQpmPJ/Ldz5DHkI5BzrBuEVKZUC6hR33huBeMASnfWuOH1G27Y4j5rh9I2PqX3k2IYUjcw4FvADTux4RQXQE++XnSKbl0suWtBaWGliL9F+9wZLODIocENgUjPd83/cEoN0FHx+kt9ELIWNtRQMcsJApzee8lS5vGWP3t7vwoWwmTBDt/wayUYkwmeGsYOj+K7wyrMqQ2YXbBFCtMJKecw1/IXYDi/NTDpEI5gxog1+mClzuY2rT0ixQhhhKTVDNP7crHj1MSwmX4mAeZzucfWI26vScK2//8ccvsNrv4tgEQZt00r9Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: Fix a hmm_range_fault() livelock / starvation problem

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch
and it can be found in the queue-6.18 subdirectory.

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
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/migrate.h |    8 ++++++++
 mm/filemap.c            |   13 +++++++++----
 mm/memory.c             |    3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -97,6 +97,14 @@ static inline int set_movable_ops(const
 	return -ENOSYS;
 }
 
+static inline void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
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
@@ -1386,14 +1386,16 @@ repeat:
 
 #ifdef CONFIG_MIGRATION
 /**
- * migration_entry_wait_on_locked - Wait for a migration entry to be removed
- * @entry: migration swap entry.
+ * migration_entry_wait_on_locked - Wait for a migration entry or
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
@@ -1435,6 +1437,9 @@ void migration_entry_wait_on_locked(swp_
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
@@ -4642,7 +4642,8 @@ vm_fault_t do_swap_page(struct vm_fault
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				migration_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;


Patches currently in stable-queue which might be from thomas.hellstrom@linux.intel.com are

queue-6.18/mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

