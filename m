Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9153DEA8103
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 11:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B6D6B0005; Tue, 10 Feb 2026 06:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055926B008A; Tue, 10 Feb 2026 06:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEC86B008C; Tue, 10 Feb 2026 06:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC3A76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:57:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9602D589F0
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:57:34 +0000 (UTC)
X-FDA: 84428397228.21.40EB490
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F61620011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:57:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HElx798Q;
	spf=pass (imf03.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770724652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fMBycn+6Hqv/SqgZRPKg6DJ/QECGq8agdmypoIIoct0=;
	b=ejHtjs4Y5IyDzHqcfkBzptujKmujnX/dlKkbbAojF+77iqGhTRllguRwTfzxrLCFQy8M1R
	27khiFSndSAQhk4G54nDSAvwzKrgHlddi6u0OarKHD5Fo77IINKYbPorWr+Pqbr8jfB11q
	NKrtbFHOhaI7CER0DFlQO01OFU7yP5Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HElx798Q;
	spf=pass (imf03.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770724652; a=rsa-sha256;
	cv=none;
	b=q2Eohd6hqyF+q7Y6es+51B6+jSi3FNrIDfQB7pPRJ2jUtn01ckQyEyyRlXThdNj0pFW2Fa
	svwaQisLsmOYqGQ38uOsn/pB+R1aYdho+hPSZ/gKxMH+17taKx5QAIssydMxVPTCBpjovf
	70bZNfbIpe56V75gFby/mPI7Uvwczzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770724652; x=1802260652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pwErsOgwLbr3un5GzP9BcdCLJrLywj7KiDxutoyTg04=;
  b=HElx798Q9rEVfmy7qomFmKmYllqsRJc6ZFh1EmnU7CCxg/3PHmuz9GtS
   AHR86CsrLC4O5pYydCweZ5rjAukitcHRU77kvVOVhXXmGX7BfCSNcK3HD
   j3RD6v3Ctxj30qmdYWHaWEj08p3S/BJoEhLXzVzTPZVxrzyPo6Emvxr9l
   TaSKRo1sHqj01HgQHCqZAV3LtrUVVzLrfNlaNb3Jf9Jnn4ZmYP76HV0Df
   mbdHtcCjScN7qfUd4OUBhPchV2apnGhVIqknIk1B8pPvb3V4r1NKJm97S
   HXOG0KQQEnGi7ccbzRRYSFc9PsiMGuXR0b+WHsHR0ShnhdmrWwUUwAnBA
   A==;
X-CSE-ConnectionGUID: XOvJjjFrQbeua/DaOA+Zmw==
X-CSE-MsgGUID: hk1MMrMgSBq7E4jgWKiH/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82173452"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82173452"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 03:57:31 -0800
X-CSE-ConnectionGUID: FotHYaynQ8i5KDPZZW0qiw==
X-CSE-MsgGUID: jDhgKCpJR7u9maQ00bUpdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211076283"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO fedora) ([10.245.244.80])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 03:57:27 -0800
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
Subject: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue, 10 Feb 2026 12:56:53 +0100
Message-ID: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: z1afkfk3dj9pji5x8s3bcpw8ypjxb6cc
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F61620011
X-HE-Tag: 1770724651-652966
X-HE-Meta: U2FsdGVkX19ceqVM6kZjGgxA5i5sMTgPBu+H1FyUoiRCENtjqFq0wK94MksX3kP7sTUDxpIrkfWLPu/kSnvnUG/AV7Wm6803moVcZEeJd6ZpJi5crh/ffKPE243sFBEByqyp9C6UAOhobrS9C0fPnyYD0fgyRPntX+sMlZTPhJ0k9sHe78T9Ynpx9bmwYP7bJ/pr6aDKAyRR6aENsOAMrt9xXTLLAzLO3butvUwyQbDSp3ZpbZGJ5ZsSKIyGIzKZ0nlJ5O7fxY9Q1ZZzmAyIpcuzKA3sun2K6NfCNfbiuUaX3lLVpXrJqNOksF3zQw3DW3Bpl2Uuv/me2TIzc5KwhBcKzaA4qQwgazNQIxI2/Fd8L0OjzCfGBy6FiIhdUP/wGikFl8+l1UdDVQf+G6L90NSHalVTS/zjifegp0IZ19NaMq1gK7iBIiJMHPBlBaJC764pvVpft4yAjyMU+2mFjus2TR6Uw9h/QKP5dNmMQo3YX5hsSbUt8Qk8f4lqtTR11s9X7tsHUH/5e3aluMGAHr0glczF26OX+w0oUZr75+75FkkaYCN1euPoFtIQz+t5LqngcLFizoSHHEsPjmjg7fPBHSATOjqm16LZNTl8AC8yO2kPnE+jpfvD+TFdIejAw3O8iEb3NQ2Ve+mTySfGnuFBrk06/5gJ6lkE6yxQuAPV4ncAjcpZinYrJIvT9lvUFfRXNPymOf29KEnd4V5UGdI/kyOkCwCyj96ZoJCGljOgv2znfNbibPtfIMIQVDyWrDzMoSuibVjcvFmEN6eB0Q00WusR4SYM+E6sYlmfRG3xkYcJAfb2pPcBidxfG+zX5vFieWNYJF8+G9YXxCvFQwKLKrzuLfFvei4NW36ccXvXEf5dd/H/pA+pPpvuRWkOvcqZkkuBBKBRHMEdyk+EyqEVhcK/nrnfSYUNtJdjoPQI5qBiFzziFj24FPEVumnjP8kina0xQsJOsBoiQAq
 Wnq7y2IP
 ggrh7Fp3Nbt1OKj/L0xWV6qprDvCUtysmea8tuIqZMMaEZI92hGJbslR2GjAN+pTHbfzKNu7U+1L8XBHYFZJPR9hKzhTWf0A9oMKjQ5u23iP+R4addtx/eeavGrXJwVql5qQO0FT1iRyo8u98tEPCOvUoIpuWQ5LM8hxmfJcBcfmexWMVgRAHW9sGuaghxSBQ6DdpPlbsH4JBzBlI5W+HyrXqzpTi8a8/clZxntd4TuP5hHgoL0/Lner7+3JPLFv/Peipar5NZUg7fvz/q+lP54zxqsppHJ2mqMn1n9G21w8iUEM5yLBbzTaqGTjzPDzxImUHBerUZyeIuJo/adzJznff6Ajpnc6NtNXc+wd+L3/tCQNKnn2zgmOIGmGK+i2gvjxpub1rThoSOLrpVpFmKkn8QeY/29zx0b9L7Mu8eBDpWP6KOTolN/bRCk7hiLxzk610jgU5G/tJ0Ah7gnPEa+S5gPpOdQGiFRctW/lG9uRSCzM0/gWwVc9U0rVkfOtbhaMqYRJefEcNyX2m3GWWeLQqQvlzz83jHI6ictUF/mZHaCdKG8IJjRneze6H07OzIOgBxOv8F7r1GqMBxvQafybGxg+tszcTQbGVVNb3F1GPCuIJ/X30H1vV5V3xN1osiZ+PiYVawqrcYuQFEi8Qb9dL2A==
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
---
 include/linux/migrate.h | 10 +++++++++-
 mm/filemap.c            | 15 ++++++++++-----
 mm/memory.c             |  3 ++-
 mm/migrate.c            |  8 ++++----
 mm/migrate_device.c     |  2 +-
 5 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..d5af2b7f577b 100644
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
@@ -97,6 +97,14 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
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


