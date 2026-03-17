Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7AEFED9F8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8E66B00AA; Tue, 17 Mar 2026 13:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99CD6B00AB; Tue, 17 Mar 2026 13:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF5F6B00AC; Tue, 17 Mar 2026 13:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7DD26B00AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:29:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6840513A619
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:29:01 +0000 (UTC)
X-FDA: 84556240482.15.60F6C82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA6264000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:28:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="ZdR4s/7X";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773768539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra2RmPh5RuJo8d8C71BBQ1EEFV+2ZazLgHXIUcbhywg=;
	b=Y+rQnm2AGZEt9vPwiMSvB1uQX1sc8z0oM+apisnTd8T9f+3a035DzejN897IfrVR79tYMt
	g6t7W+BsDBxmGxVK+OHP7VjX5HF++YlEwxH1TRF1UiWod9SaZGX/3uD2eh66nQKD9nIdC7
	TEhB7kv1L8QBMvlJzm2AvvtKat3cHHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773768539; a=rsa-sha256;
	cv=none;
	b=BbSFWMLYJ98x7RcwO3C4SBOTesrmImTpDIbnjGmcwuQem4YoKHqLJoBgPag6qrt593eTcj
	7dlu9fD5FL3ee55Kn8tjTN2VoQV0G5i43GXtC5s+0qcR8sPggRq1ATzU+H/Jlf3Jvsn5lc
	szsBy3ZLLCGiZnPbzsaJw2ZMg2AZKHU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="ZdR4s/7X";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11393600AD;
	Tue, 17 Mar 2026 17:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F31EC4CEF7;
	Tue, 17 Mar 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768538;
	bh=ni9KnkEM49HfIQy7PSdXAs68H+yiwWUClh7elHlsmeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdR4s/7XJ7nVo0ncX8q71RrybZG6FjywtcqPw5iNTMfDdETCjP4n989NMaY6DF8zG
	 GNEO9pvLHYW2JgNHcaOHXM8SKQ0ZRnlz9JXLTQXQv8oxJZqBiYBkW3EIB3tgWdZke0
	 gS3JZJNAUi5eraLUafsaEeNmk+pvEMpLDc36ak8o=
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
Subject: [PATCH 6.18 316/333] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue, 17 Mar 2026 17:35:45 +0100
Message-ID: <20260317163011.100781577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA6264000B
X-Stat-Signature: cqbx71n4c8xhazinzang94buihmo7ttt
X-Rspam-User: 
X-HE-Tag: 1773768539-870054
X-HE-Meta: U2FsdGVkX1/ZneWDgy3+TG1TSm2ZOvBUKZfCX9uXsLu3pBqbe0oKai4ghcoKPFijaXAhLx45gZgXLlrNzo1UJNi6w95E3uufdl/f6kxyQYNknebnZBnAWeCT3es7WrSjmD7+A0QJTQWMnH4I/PUCt03I/PKDBkUrX+UV6J/eAyDx50MfrsMA2eHyJKHmciJ/Pe9BsFkGE3jASOuoE/vPDjmsUQpAH65aVeBQhbqHHxxFF6BI69kit0Tyf3e8YizbL7S/9iPOVP5DO9OtSS2HmnruS60QwoHF9IJclhcHKp2WV1y7fNPMqbBhPTw3/RxdqHTTWz0artA+ihw5HA329xtNVQbQt17uVd3fCuu+Kg0M+gSsqdxbUbCP7fzQPD6l7BC/cYqVkNq0wstbF04OzIi4Z3uihLuoRs7OtGxMBsBTWJYMQRvPKL1EXkETB4r4x+k+jc9f3YmMTpox65Ozf4i4oYVEoNwcvYlpgkrH/DUW1+TxmUbEnmVAjK9bWRwqyiZ+WPbRy8MrHuvb5+KKQQ+NAGX264n4BvGuviuitNnf+ksBzk5s1siDiED144n1J9Tu9L+eeZATxgO/QnA+Nz6vR6K4rs/b9J4oAhSt2WQLg73cFuPhspXcoaPQQOQMMkRNUVJpyX0LfKdBWrMbtAP/o4TohMl2QP5FVJ0UUgfVd7I1olkLFeQtJRogimG5K21OID8EFFryhnB8wFfAg/nOdhiDhvuHdB1QTidN4GKrC7lA4AF2QlaTtnGLKrB/2J1LEOOYy8I/13EUBbXubtsRc1r7ZQHiiGTw9xViTXGVhC6LRK/YXVPxdUYxlEbDmZ4EFcxXDcn4p5VpWwnYphG2Ze3gSvPgqr6Hz3Lsd4vAihfiu2NVgI3bcsKhWqFy7UPWlozqX4rj62AD++T6k/3znXg+ygyyyk0/MDC7Thvm6tyGfnujqFf6zNqvdkLitXsTjgqZKUQtlmlAh7q
 RXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6.18-stable review patch.  If anyone has any objections, please let me know.

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



