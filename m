Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA48FED9EE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3C06B0005; Tue, 17 Mar 2026 12:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264E86B0088; Tue, 17 Mar 2026 12:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A656B008A; Tue, 17 Mar 2026 12:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0663C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:51:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0D671A028C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:51:32 +0000 (UTC)
X-FDA: 84556146024.29.AD71615
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E179180003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:51:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AGVc1Xt8;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlRZf+1klkDtNdL1crLosxTI4J+DLVi+i/8N7BfE66k=;
	b=Y6oAvDUK6vWOy8P/yE01SoWBCfzbV1MjTxMbPY/BNsTNm8LdlxkE+SxSU5V6ItOJuvhUXW
	ZuCc1QUISX01Z2xmAb3NZJwUxLi12aKaHC1J4cw/ENaRiyOp5YyFtO8Yn/5K9szqEiJQ8k
	TqTXKtCtMjBWA848qCEhaI3xmQAnaSo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AGVc1Xt8;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766290; a=rsa-sha256;
	cv=none;
	b=axF8+u2P4OY6rdb/KFKX9y2WHuLvu7ZodHVggeLVdDh0xAhQrlw9iCMSaKOkuYwTUXUSlE
	4q4h/G7K0TCCPBMXJnXmrXJsUv+eAYAwQUX0vRQT1Rby+zcvJ/5Bf8nbJx1qcS1xrT9vCQ
	mUIQoqE7bi+rluTjmE1+gOvy2ChSwEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9428043F1F;
	Tue, 17 Mar 2026 16:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3219C4CEF7;
	Tue, 17 Mar 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766289;
	bh=YkXEYIH74A56mhfHo8kocYF0waTbnTtPT4gCDq7DILc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGVc1Xt8VNAQFCNx6mZFG9maV6EngS7Ao5CWcaJY7AD+jHgO+vgoCCjZZY8d0ZN1V
	 Ts12XZk6SkA0C1v/EHxgaUDsQWEFcGQNrPa44yUsFSxsRKzd62S/15F6NjPX96wOUC
	 5/IYPdfey4inKNiQa6VqbrApyOcLik4yvzuv8PMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
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
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.19 212/378] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue, 17 Mar 2026 17:32:49 +0100
Message-ID: <20260317163014.806356728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9E179180003
X-Stat-Signature: c61h4ioxgqcm3ixo9gjy69fo1oihmhtg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773766290-192388
X-HE-Meta: U2FsdGVkX1+WA3fApFe5raWCBICabyq93TNL4Ws/SqtHQjnjua8yI8H1nIL64qD7f3aOxMlqp5SvdAHdi9YtCX9qsd1OhHHOEIIAPP82JzLFX1m3yG6ft/kKMrqEiiQOGGQcITezcjNzt+uWlmrLbOFdsNu1svpKtq2xj4qAoxSvhHEEEaE2fhLZyXZb7z+MukUeJZ9b2p2Qvv1QuUIP2c6a+0yIx1ZV5LITdy47o3RBgGzcOQA2kn5w099kGAmNzKGOyeyHmf2C3wvxgGGKFLmtjVN+olZYyMMZXzYBy9WEZjU8agjnnRwW/f8M+xOqOoONs4+Kqnvlv+MJmwzwcrEzmDt9tVwni42eORDnEbni2EtM5jLCWDOO4ANsNrOaP72YpLoXiEltK3RdBdWmZIqFDJM/gw0em6nWDRQUNUM/gXoD1WnklYFlukTjqbK/yHRi+icoJcQ/Ov20m5PX36zyJkcMcucbSH7bQ6BJjg9O/LjepvYRIcpGcV49zDRKzggC4eH91QqjoNtgUrmyzkAKdrd4jqk7W4QpO0m/p+O9cKMPkdxUgKPz5k1HH/ktK6TpCvI1UUF4caxuQcTFEfRx8gNVi7oxxgibM/L/YdXnnyWFp8w2StCs+WYGMDhONea3K2EExU+UsfgY9bs/Qgw0jyjVUAdK9o64Oe/MpSzCKxjTpz37qmi0JiXknNkol6TWIR80N1aN9QBk2ZKYIvwfbz3hMs8jftTzGocXgJL4hiqZQusSanIdgAtY9ZRgxdvVxGsO8qq62OCFiBIh3+ZrDaOGKKoUTPiY0YDCwRUqqi8cFzkjdjIAeL/mTg2it/J76q5LdWFDAXXcdQj5ud69GCCSFoYVPEhUlTiVDMLNCO9KiP7XCqSrU0Ckb7qNBwg5u3BOWmpok8hOjbyds3KlIjKz06M7Ez5dvtEQbpK6X4fWvGoAsc3nAbMgY3LAzCvmBTlrJhi2e/+sOJO
 CEZ9OOfU
 CkC1JOdv2C2JB40ICjl9haEMkZnhOJgsY8prbm39EulG4GMltNn4A0DT/KsDukZmW1ovHOPlrQy98myOb69h8t/FDvo+LC4MOqx+79Yal3J45UuPY7RHPjMYuOV6nOWOilVJh7w5EfsLu70nOq5Zavey88KtVvzk1HTvv0VGL/lN7ojGG877rU7jZuTomCTeDc6Sdmhht7und00d//N2VUHm6+b7QpPNCejw8JqG0k2zrsqbpu1yojZbMLefguSFjCb4MugEmcFMBl4B4VzjHcK8D8DvxLtoyl0mSgMnGupzO6at/HmxngBrmxN/yWqSkX2kKVqE6sC+AZDryorYWLEl8ANxofBG9RzTMdhJktbXRTZmzPXKPhgqugc9LPRH50v/f1MlKNO9zS4eVlPk9OotL0SbPiAfr7jYkdU5ynaAOWF9pplXCoNbyaUX3Hrd+HI34dpj2umsH31dRuEwF807AmbUc2D46/ZZvmAKb9WfywDbIhIDkcoO60WcDmvoxstXvFrbfkO0dqq9rU/Vc0c2R642YoSNCZ0gRoRBGKtcI9zU2z2W69XahETM5y6rnla6mdwPtS7Vyd1tyH7dipLSA1Nj1Jx6fVHWwTG2BicWj/QqEdR+B0/AqKmIir0ldqxx1bgQtLURwjkVym2iUFTD7TUJ7SFCzIpJiq6tERzYNRybj08aghQ6Rzmrs2mD5Vfikz6yBHSVodm889gLcQbLyGN1KDvKHqtgYbPvx7zigDJAnq1/janPmKnRirC7UxGtzFxz2hnBFQsuLYxpdq3yMZnptNdBEwU3H+3YQbvO3ggwOrBDXJXPCVdvltCKvTop7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



