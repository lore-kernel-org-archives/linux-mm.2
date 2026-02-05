Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707D8EC1E9D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A210A6B00A2; Thu,  5 Feb 2026 06:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEAC6B00A3; Thu,  5 Feb 2026 06:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD986B00A4; Thu,  5 Feb 2026 06:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B86F6B00A2
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:10:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18A6C140479
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:10:54 +0000 (UTC)
X-FDA: 84410135628.20.E180EB4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5EDF51C0011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:10:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bmGn13cj;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770289852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JAhAF/TqAOcdirEE4QbAA/umy1aPPDrVrZvLwEDbY00=;
	b=eWp9k4yq3ssoJanPdxp9vD1jeX4YfkYarwnfRmX72mrHrw9i29p/IIo/GvOr7KNmEkI1oE
	tFVD75VmTX61Qw9Zeshgb9L5R58MyGCiHWrAFWKCCWZTQZXV3S+3Ihmt6WeUzocdbDn6hb
	nNYwk2k1wqiJnb/9L801OAh47ccSx+o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bmGn13cj;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770289852; a=rsa-sha256;
	cv=none;
	b=an1gQffDixkCRLr/NZ/hYXOQvunGoA15CX1xewZrQ9YKL0dhpMBRY5D7rR+gkinXBmetfe
	WCXra8QpKNhqZJCbimxvov+sEMEjNDk/vZVk3BaufTug+3nysxN8MoVf49a7B1sph2f0Be
	dewN0dAtZd8B1YZd2xxA9kuT3BKa/bI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770289852; x=1801825852;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b1ZngIBgu7/voNCfGbRGo3ybVy950T6qMrS+/q00oy8=;
  b=bmGn13cj8/prVQ/C9m4CM3BqLDn+dPvdIMBJ6eEDdc30dPv6+eNBv1fk
   Mq/Za+0tCrW9ZTAa11IZT2EdDFj5tGi9lcFWYbl4ytRUon734H8Dq4/zx
   t7WwIm1kY40edPxgeh81uegRcO6wYpZwXX4an6UTNcvImDFlKDc43BLEf
   9EVVfErBJp2SpQBa6OP8zh/5O7I/dFwxvrJd5izVOU9lO42ILa6hAwTeQ
   ySzTnF6nI80RUZpZOUjWLZNQ4if2GJx1EQ/jeZuNrf8qbAzhPTPl4w8wP
   V4jNDu+K3cdws9FfsVQNFghpZ4Sb/66Xxvi9C17mImnAuPB+D2LLeOoD6
   w==;
X-CSE-ConnectionGUID: 7VRoeTA9Roi94YM+8iSjmA==
X-CSE-MsgGUID: TyPI/ksgRfOlKzfETApm4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="94136080"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="94136080"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 03:10:50 -0800
X-CSE-ConnectionGUID: tj475tctT8SCc8pMpUaVuA==
X-CSE-MsgGUID: VNKoHmVzQ9CME6YhJjCwdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="248086185"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.93])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 03:10:46 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
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
	stable@vger.kernel.org
Subject: [PATCH v4] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Thu,  5 Feb 2026 12:10:28 +0100
Message-ID: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5EDF51C0011
X-Stat-Signature: yziqaredsh1a3pfzgunroaaxauhebsia
X-Rspam-User: 
X-HE-Tag: 1770289851-275
X-HE-Meta: U2FsdGVkX1/F/SgHjCqwkt7Q57pz1y3AaQLrbkRUtjDDTjiCqsDIl+G4cIiUB8RNn6yIi0mh9YnzGBL/ZkSlE+tew2R8eX40cp3WH/ZUM0MAdxzl44JG1TNS9PX+K+o5iKtbbI/IlInGUlKvZc70iE9Pk5zG8fMnHF+zhVjA8JHDciDoellNAmK0IHbzypLukii4U+zsHR85MZTSgrpBcxkIgi1uCoGar1XOs6CaUc2aO8zYBgrBDJRP7xDm9CbThVDoVrP1j8PT+rMRBielaa3+xn1rtgBC/UW/gI4lzD9EMjqEWemSbNRxeA6Pv5vBL85Fev5lpYEOoIMl/z2tziwPzeOTXZAKvHIZAbfzjLAhQN3ISgWb5pTYLRQBm0R90hMZbjaXo1vOpJQcqk7caNMV9BfDWJhfuTiHTmD2N1lmFjwqyi4D8PYX4WbS5FMT63yByvdvG5uE9SA+mcM1S/YaYLAo1xudBhXs6U6jhZFVWidkT9POGiiQWsvIw8Rec1Ee1g3RLwrSktJmtL0Jzo7dGovsKukzxb4HprOPgRIHDrwoUSUSV1lWi1vp+X7HzJGTbro0T0EEYvD2kMpviGm3SomJdqqdchiZ4JSNyS9Znfhgph9cCRe3qwijwrHqm9/Kn/75AKxaJENqlE+uS9cgzMNd7ddqIIYpa52Z0vI/EFIPGaMAQRn/nEE7zS9YScuSmXEz1vAiOhnmeF42WpzlzodSXHXvKf3fWkUDDyM/EOIr/B0LzLOP1IBMo7LpgB1eb5flf5WDfCpVyvDeJ6mj3Q1lcPqlmObKRYB8ihVw5KWwdo4qxTUYqCALoHaGMNKan9mX2Q7jF8rVeKuLntsj3E5elX2/GXbqaT2Jj23e5a2fFdCplh2lFZMHQAvz8YTxNzbNcohoaadotT+4Rfx0TEwB5hrTi6Wy5YbqtTxI7ckWc/vK0z9kpsJi3S3W3iVA/oG3s3xbn2yZ9v2
 tb7ArLW2
 8L0fjs/Lkh7PyTtMoXSAFskvADOWhS0LQsy0TN87S3lolloTwaQn6MlnsmoGJE86yiRcSJEXFut1qIUvNbFcb26PxlsY4EpSfISVKeOu/mOytU8kPL5ct4QkwcHrfXZ+mzC2Oe6m6HgYUGHidwGh/hYWBaXsaCFfy7Qj9PMNvFtGBhUol6YPLlzh+XoGH/6jsMNQopv3oBnyKkf7JbEI9Y/VwdIkRSSBSOtaddXFMoTfy01Z3u9ZXXg/bYIivYyn0V2R9UsfM6WGzMD2sbK2MB0HkTbQ2TkVhqlI24Etas0l58nJ6xi7ah+U2EYlhBDZjpdq1ZxhX4zbaSmqtjSkgnvuRz5hD78eEJb/wTIAw7kun03DtTzHZcw8nyPqHPK2Q8W2E60YeZPNDD3RJzoR34r9CQ8BANnEFvsC7HlJufdhMudCQnUITdkZcHLyevc95dHTjOowIzthe1N86WkVsQtiEglym+88cy3hlZ3B1QwixQ6OqDfyf+7zyZG+O9NI7k7v2mLQZgANhsRZiNU6ClXvlyMekjijzebAkuXTDcx3+P25Qhenz+H4bwcvGJ5KF3XP9HJOMwUrk5cu99IJdyuUuY1/IcfWfoBo6A2qUHKXPJ/FqIzYkeA8dpXLfKZJS2jvuAbtlX/qch1BkMspDOo01zE1EL+yx/zVNYHoLqY/oAQhyCVB5pajl8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
The lru_add_drain_all() function requires a short work-item
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
folio_trylock() fails in the do_swap_page() function.

Rename the migration_entry_wait_on_locked() function to
softleaf_entry_wait_unlock() and update its documentation to
indicate the new use-case.

Future code improvements might consider moving
the lru_add_drain_all() call in migrate_device_unmap() to be
called *after* all pages have migration entries inserted.
That would eliminate also b) above.

v2:
- Instead of a cond_resched() in the hmm_range_fault() function,
  eliminate the problem by waiting for the folio to be unlocked
  in do_swap_page() (Alistair Popple, Andrew Morton)
v3:
- Add a stub migration_entry_wait_on_locked() for the
  !CONFIG_MIGRATION case. (Kernel Test Robot)
v4:
- Rename migrate_entry_wait_on_locked() to
  softleaf_entry_wait_on_locked() and update docs (Alistair Popple)

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
---
 include/linux/migrate.h |  8 +++++++-
 mm/filemap.c            | 15 ++++++++++-----
 mm/memory.c             |  3 ++-
 mm/migrate.c            |  8 ++++----
 mm/migrate_device.c     |  2 +-
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..3cc387f1957d 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
@@ -97,6 +97,12 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
 	return -ENOSYS;
 }
 
+static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
+	spin_unlock(ptl);
+}
+
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..d98e4883f13d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1379,14 +1379,16 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
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
@@ -1394,7 +1396,7 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
  * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	__releases(ptl)
 {
 	struct wait_page_queue wait_page;
@@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	 * If a migration entry exists for the page the migration path must hold
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
+	 * Similarly any path attempting to drop the last reference to a
+	 * device-private page needs to grab the ptl to remove the device-private
+	 * entry.
 	 */
 	spin_unlock(ptl);
 
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..20172476a57f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				softleaf_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret = VM_FAULT_HWPOISON;
diff --git a/mm/migrate.c b/mm/migrate.c
index 4688b9e38cd2..cf6449b4202e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	if (!softleaf_is_migration(entry))
 		goto out;
 
-	migration_entry_wait_on_locked(entry, ptl);
+	softleaf_entry_wait_on_locked(entry, ptl);
 	return;
 out:
 	spin_unlock(ptl);
@@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, p
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
 
@@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 	ptl = pmd_lock(mm, pmd);
 	if (!pmd_is_migration_entry(*pmd))
 		goto unlock;
-	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
+	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..deab89fd4541 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 		}
 
 		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
+			softleaf_entry_wait_on_locked(entry, ptl);
 			spin_unlock(ptl);
 			return -EAGAIN;
 		}
-- 
2.52.0


