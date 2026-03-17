Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF6BFD8746
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16EE6B0088; Tue, 17 Mar 2026 07:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA06C6B008A; Tue, 17 Mar 2026 07:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68056B008C; Tue, 17 Mar 2026 07:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2946B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:40:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 446E3160116
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:40:03 +0000 (UTC)
X-FDA: 84555361086.22.70E1A67
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2FE6A000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:40:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YptRYm3o;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773747601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0dOuYZ9665JyjRzs52t+EPnVMxJiUbFuVuNik4vFBo=;
	b=LYnTs21J1xyTq4NWUMdz1g8LXt6eM/bQWOMOd4lmhpqsYh8I5qCHA5rw+Yg7Deh7CyEPJ0
	HhaQIYp7lj2GBbsLusnNT32RQxtlq+aXACeq1UWSLt0e8c1lV7NY6ByaTPH64PY6H8/5mT
	XIyxcmsJ085V9/A0O0QYpYp572FszCM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YptRYm3o;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773747601; a=rsa-sha256;
	cv=none;
	b=kCaRTOtqL2xIYaNMghW+gFKb4cHa6pTih/Up1v1cHAIG9M/pHvlF7L/Qe7jEzCtSejdM0A
	CBqGNCQlAmqJj0VJJISkJHloeCKUloXF3GpxCb8UNGteLO96r/cW+LHPkh2Gq0CFeFcFnr
	+l8ljMuK+v55b5oco0Q96mNNFSvw/NE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773747601; x=1805283601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRgtFoQIanVkXzBuwaf/6kB/9aC7bCosZ4GDzrkN5kQ=;
  b=YptRYm3o9WELwA84NM5TCFVOWgfWRclwOUQ4bpUqO9eeqN/8ZbSUFQSq
   cSWgZ7BdyHyWo6YuWnkKNJsfK7J1h7RXhVUQJ/LQXcb0KP5az6KdMRo2p
   TEf20n5kQS/Rw4HiguPoRIB2K549drlWN/OXFWMcn60pBHFIieBwwKIBm
   stOyHV6D8i9x6qZXHZItaW+NTJDWCWXkYuOT9CIrEdvzeEzO9jyxFYr7M
   1VvlG/DJCvorhVdZPbQcOaKqwEHc/Go3n9gaau/GM1gg4inOA+5UmuVac
   x3zB1vzPUxp5EisWvzIgA/kn3cXSKGwIyvq47cKqMNYM5RPqYbOhVn8cK
   w==;
X-CSE-ConnectionGUID: kNwrnmpFTTWgQBLEii9kJw==
X-CSE-MsgGUID: 1th1sjobRymfw1RvSBKW+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="74893925"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="74893925"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 04:39:59 -0700
X-CSE-ConnectionGUID: xPRzCKTrSqOQHh5rh5AZ8w==
X-CSE-MsgGUID: egKHkaI0QjGYmbobZe8KqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="226930061"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO fedora) ([10.245.245.163])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 04:39:56 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18.y] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue, 17 Mar 2026 12:39:30 +0100
Message-ID: <20260317113930.193553-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026031727-elective-spilt-6870@gregkh>
References: <2026031727-elective-spilt-6870@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2FE6A000E
X-Stat-Signature: kn58aywbss4ggyxctd9jqrub7g3kw6ra
X-Rspam-User: 
X-HE-Tag: 1773747600-40155
X-HE-Meta: U2FsdGVkX1+gYOxPwsC8AfKzCHlMsptCbLVJUcShtedn8w4/hIjbod/3sqs3yx5qEnaA1ffvAsm3Ubm2pzUQsvuTOSPkH+ezDGgOCtDIW/Qo87wlq5/zn00FVNi0oGClofUIb/asrFYanutfSlyRcX3ZFyAghgIvCuV17A2TM2+ABumf9gVPiQXDKE8UUuVj7Q2gupD24IjTNeAd5tuEEvkmJmCoHrCfPi49hgwTiRiwyyTJvfG1f2RHZDhojaFWX8Eni9uAAv8Su0KN3LqBPJmWU9ntsZbB35CWdsbTCS2too22huNBE6HByymaNs4m9cfyL5Hs6MJNMPBAYak54G91VQLC8VzN5VVq0HcUUiNqlAdcBdHxnSeEbzHDE73v9lBJedgZh7XJu44l8hYVl4J90TcsSwa0k3qDvL73qixUls4ZD2e17s00TEtgIVeAt+l8+9UV9G5RkqWauD/8VxdrBBm60aRNEcnhx9mDYHgYve29mVQkuKi0bWZFY7B7YnkafrKkGY1V1/belSmgj0xnOAtcYDif2ILS41icWG1JChMsRNsnu+vGOexsR6hW3ho6l6HK0O4YgdB6sfwTr+FWq7kFndC8qCLZkqjuvin9gM7DwagpuMd82X587a3weVei56gW1HvCC1nWLAcv7tEwHNO8SaxziF2tWFXUBxQKlTASrCSYEyU3/69V3P9AG96GdcikflJMQRPz/gMUkcmYw5yZPVDmVJb5n53t/Owk06VQjJm10ivhTczXGfYzrWQ1r5vCCtSSOSDaFun9cjIAqwFXA3BnQfQljjQRYDOA0atcrQx+lWdilpe0+CFzu6bIe8IHkef8eq8lsLoHzXQrJelAdWdrxz9lsKIvfb03ZMbp9WAoyTnPaJABCdESKWX6qqEkgOfjgFb3eLzhAr7KYkqa0gPTUejykpsEl0laTL+XZcNFX2wAMzZfXdd0OiMeV9QnKIu3/8mYuvM
 EjtT8oCV
 YaB38vYsmTGwWM93ukqSAVQVSGIeBtHTdtMm8ReCzzqbWTyVGgz2v97Z41RvYF1rdCrgITnGBg0o6+M9kLmqyoTOPsrCmvqQU7IX+omujum6OXZXu/j/WFtftzcUC+rVDOrgyP1E1OH5stkXvKtkyf4+/9ad7NOqDkrV1m8KhCa9DLrJh90ZHNwPL+1Tzv5SpT6xVzVh++SoA0mqBcBC98eyXDrC/jC2NHYA5t18l2et8d8BW1XWE0FoKhPcrNZgcR6bA7Q8r3CNZ5VVgCQO5fnYH1diuJvrqOVrB1LU4v7rOUmGwnLLhPcu3IM9gY+gDsPT7Y+bN08tHV1jv6OHrWDnBLvxB4Qmsr790pCXhCJFJFmbJ2F8Nu6Z5ErXBx16Eicjhzavm3MInNLdisGAY6tpa8Xjovn1pwdQ4+MPmwqNKTZzP1pO6AfDqOdGjbmP960Xo7AqUX7dUnCue45CqU2kjAk5WaYdGDJgFwWswGXshacp+qXPNELr2hmu6p/9vb15HjpXC6yAzcapos/PJL0iArE1z7SqDRMhaZt/ez+9B5gf/+zs0e3glIlGrZkL4V50DLg/8Toux/Jk6+QVROPGf/uG1BYBdkRu6OxpeXlOSClTNFZ4GATgBjCsOQk6g+TwBRDlEYKLXaqAZxlkW3+vA5T62iwgd0GFL0OCPTozoXt1dIm7UtjVYBI1oFDyL1WNN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
(cherry picked from commit b570f37a2ce480be26c665345c5514686a8a0274)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 include/linux/migrate.h |  8 ++++++++
 mm/filemap.c            | 13 +++++++++----
 mm/memory.c             |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 1f0ac122c3bf..8061efd89041 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -97,6 +97,14 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
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
diff --git a/mm/filemap.c b/mm/filemap.c
index 024b71da5224..8a7f4ce69aff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1386,14 +1386,16 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
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
@@ -1435,6 +1437,9 @@ void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
 	 * If a migration entry exists for the page the migration path must hold
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
+	 * Similarly any path attempting to drop the last reference to a
+	 * device-private page needs to grab the ptl to remove the device-private
+	 * entry.
 	 */
 	spin_unlock(ptl);
 
diff --git a/mm/memory.c b/mm/memory.c
index 61748b762876..e43f0a4702c4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4642,7 +4642,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				migration_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
-- 
2.53.0


