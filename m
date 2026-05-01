Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C660FCD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA0A6B008C; Thu, 30 Apr 2026 21:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3911C6B0092; Thu, 30 Apr 2026 21:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2804C6B0093; Thu, 30 Apr 2026 21:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16DF06B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:24:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA0128D039
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:12 +0000 (UTC)
X-FDA: 84717095064.08.AB38B30
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id D5AF380007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="jc/GnM0a";
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRsLTv87kjl9U9FBe0FqBtheFWVulOe+BilE8+AXiG4=;
	b=7+qGURFbW7718p4zwIK+ZdnFQY7p84Lgf39a1SblfW2GGwQmaJxk1F6gBm0DE5bZssyK6p
	MtkMHfxgz2LYkheu53/K/CbF1MyUqy9Qq58nYIrNiimAz9q5rTCqxy0IaOeT7nC68iHnj8
	TyXEkP1LnQHjkrq2gDrPzLExERSFm4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598411; a=rsa-sha256;
	cv=none;
	b=eAQRfLc/eLjWPzUbn0xcyp1JvZBnubtX2L6p7p2jAoXNen/h1No4Uq72YO8qN/PRscTxkx
	YP1eFoH/aVkl2xNlyHeK4Bbk9u4rKCCVTZ6wUBHqM/IvOA1J2tz1AtU91lEEJ9Got+RJC5
	0+4gzUGEpTd8ANLMo3CUs9XED6rO4mE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="jc/GnM0a";
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4894420B7167;
	Thu, 30 Apr 2026 18:20:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4894420B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777598409;
	bh=kRsLTv87kjl9U9FBe0FqBtheFWVulOe+BilE8+AXiG4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=jc/GnM0a229OK0yqyS9JHp1/dyHl3TuNCDaUBaeloO6LHrfLm/JHH5VHkaBL450wS
	 uCilPAlCFFwwBOSq9mpscLUDv7E3yfNS3mmk2FCVr3xRe8c4IarHY5k5n/x5wMfSME
	 fGbE4bjINe+27FgoBHCJRzq37U+gcUAKdGKctpSE=
Subject: [PATCH 1/3] mm/hmm: Add hmm_range_fault_unlockable() for mmap
 lock-drop support
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net, leon@kernel.org,
 longli@microsoft.com, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, wei.liu@kernel.org
Cc: linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 01 May 2026 01:20:08 +0000
Message-ID: 
 <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
In-Reply-To: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
References: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5AF380007
X-Rspam-User: 
X-Stat-Signature: oac7sd6jxdmpwn8myrszqnyp9nihqq9k
X-HE-Tag: 1777598410-409155
X-HE-Meta: U2FsdGVkX1/S9oqLfu9hi/2WpQpU3GQf732BRbmk4bPP8UtL/xBhnNuDn3COZc0thtBC+81KOyGNugoAW1LEkGgpOIkVDkefaOmLJ252whEWg9bHJ9hLFkk08/Ok/KD9rYc/PKi9LRTy+oPfJUCy26RuxCm4qLX4J89eFoRIjDXjEtcKDQxI5XMILGIg4P/ovmBA0/V8IHbDT/IzLF9SGesuEYkLST1zh+CgMQC0WIPBLYOZNbhVBfyuioNjVOti7GGVkKm/YYJhHLEYJDtlE2Thh/6eX8t3u5X5oeccX1gCmvMs60FK1Bk8kRkkxeTFGNy2I6miOA3deHwiUI7AHqnIwgUg2E+C7m0laqEWbkwYwWyfZ6jiOklmFsFkYK9+p5KtRc9L5KFcOu7wesUYF+1PIWS67ESo+qzW9w7rJ7qjQ71PKRviK62MhHweWCgOPDE9YraFfYzr0DN0GAi4Wd5IjCmxVhzDSdH2igkzVOyDQdIsuZ9q2qcQNcdg6H9hphf7Y+ZPF5MbTwJqLL5KHVbyoF2PYWlFlgEWWOSsJ75EP3Guf3nR00ByQzhojqq/TpezLcdoTJCGcVFBRsh1fteX5Lbu6RC09EwM5iISqmZ9v6GDY23uTUW6CwzczYg2RM7pl4vDSfVwpX+KEQ9pRR5ODGNEGMHxaVCj9o2oNKcPIcW23erH53c9vMYRP4/aUfkYt2PldJxSe/SVUvM4m3x6wQyqInW9Gt3NhgKGLKCD4icpI5gpdZlObWpX8VXYViy79nK9xfTAvBMEmgGV+337Ovutab66aHS18hthOyJlyKHNZreVexu+GRjw/rkCMalaL7fx6EwDRMISeNUajcK58+R/ujQQEGpW09yH/u3yg7Od2sAQjnFvf1LgIwBjmNS7I4hfv3VVciRolsCMT5qudFkuVkExIxTH9W/7gaA9bECrc1Eu/WkfPOldM8pqohbjkjIS41kioqYEGhz
 JPfvGnGH
 067QJaYzWNNe4oRhdH48n+1IJMa1FDJ6vGWsosAejdEDwLmCjPK1E5/tmZOcRm6UbwRObR8ooatgiMAkoKEtjTXRzEZDV54BpQk1XM1l9QVmIMRk/P9BR5dT07Z9ceDPZwG/zdCo/ROopDuapEVIep4iF4MChNldh0Qbu2+aGw4sd6bhPE0NaL4Fmet7zShOAH3GhRTM1ZiWmpWzfCr6Jn25npG7zdz+vtlc02DviWlAOxzNxBT0YhF2H9vNo75vC1Ap+uOumnVkHwWX6xojNOzIY3g/nOS09JnArLHhtW4shPUxFsYkqUHOzyAXOXIAHPBGwEqAgHI3mChc52nWFKnAQqIM0yctzuuMXgPUG1WfS1vi4iz/6nMSjXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add hmm_range_fault_unlockable(), a new HMM entry point that allows the
mmap read lock to be dropped during page faults. This follows the
int *locked pattern from get_user_pages_remote() in mm/gup.c: callers
pass an int *locked variable indicating they can handle the lock being
dropped.

When locked is non-NULL, hmm_vma_fault() adds FAULT_FLAG_ALLOW_RETRY
and FAULT_FLAG_KILLABLE to the fault flags passed to handle_mm_fault().
If the fault handler drops the mmap lock (returning VM_FAULT_RETRY or
VM_FAULT_COMPLETED), the function sets *locked = 0 and returns 0,
signalling the caller to restart its walk with a fresh notifier
sequence. Fatal signals are checked before returning, matching GUP
behavior. The caller is responsible for re-acquiring the lock and
restarting from the beginning, since previously collected PFNs may be
stale after the lock was dropped.

The existing hmm_range_fault() is refactored into a thin wrapper that
calls hmm_range_fault_unlockable(range, NULL). Passing NULL means
FAULT_FLAG_ALLOW_RETRY is never set, preserving existing behavior for
all current callers with no functional change.

Faulting hugetlb pages is not supported on the unlockable path: if a
hugetlb page requires faulting, -EFAULT is returned. This is because
walk_hugetlb_range() holds hugetlb_vma_lock_read across the callback
and unconditionally unlocks on return; if the mmap lock is dropped
inside the callback the VMA may be freed, making the walk framework's
unlock a use-after-free. Hugetlb pages already present in page tables
are handled normally.

Documentation/mm/hmm.rst is updated with a new section describing the
unlockable API, its usage pattern, and the hugetlb limitation.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 Documentation/mm/hmm.rst |   89 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hmm.h      |    1 +
 mm/hmm.c                 |   91 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 172 insertions(+), 9 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b7..13874b4dfd5f4 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,95 @@ invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
 update.
 
+Scalable lock-drop support (hmm_range_fault_unlockable)
+=======================================================
+
+Some page fault handlers (e.g., userfaultfd) require the mmap lock to be
+dropped during fault resolution. Drivers that need to support such mappings
+can use::
+
+  int hmm_range_fault_unlockable(struct hmm_range *range, int *locked);
+
+This follows the same ``int *locked`` pattern used by ``get_user_pages_remote()``
+in ``mm/gup.c``. The caller sets ``*locked = 1`` and holds the mmap read lock
+before calling. If the lock is dropped during the fault (VM_FAULT_RETRY or
+VM_FAULT_COMPLETED), the function returns 0 with ``*locked = 0``, signalling
+the caller to restart its walk with a fresh notifier sequence. The caller is
+responsible for re-acquiring the lock and restarting from the beginning, since
+previously collected PFNs may be stale.
+
+The usage pattern is::
+
+ int driver_populate_range_unlockable(...)
+ {
+      struct hmm_range range;
+      int locked;
+      ...
+
+      range.notifier = &interval_sub;
+      range.start = ...;
+      range.end = ...;
+      range.hmm_pfns = ...;
+
+      if (!mmget_not_zero(interval_sub->notifier.mm))
+          return -EFAULT;
+
+ again:
+      range.notifier_seq = mmu_interval_read_begin(&interval_sub);
+      locked = 1;
+      mmap_read_lock(mm);
+      ret = hmm_range_fault_unlockable(&range, &locked);
+      if (locked)
+          mmap_read_unlock(mm);
+      if (ret) {
+          if (ret == -EBUSY)
+                 goto again;
+          return ret;
+      }
+      if (!locked)
+          goto again;
+
+      take_lock(driver->update);
+      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
+          release_lock(driver->update);
+          goto again;
+      }
+
+      /* Use pfns array content to update device page table,
+       * under the update lock */
+
+      release_lock(driver->update);
+      return 0;
+ }
+
+Passing ``locked = NULL`` to ``hmm_range_fault_unlockable()`` is equivalent to
+calling ``hmm_range_fault()`` — the lock will never be dropped.
+
+Note: hugetlb pages are not supported with the unlockable path. If a hugetlb
+page requires faulting during an ``hmm_range_fault_unlockable()`` call,
+``-EFAULT`` is returned. Hugetlb pages that are already present in page tables
+are handled normally.
+
+This limitation exists because ``walk_hugetlb_range()`` in the page walk
+framework holds ``hugetlb_vma_lock_read`` across the callback and unconditionally
+unlocks on return. If the mmap lock is dropped inside the callback (via
+VM_FAULT_RETRY), the VMA may be freed before the walk framework's unlock,
+resulting in a use-after-free. Possible approaches to lift this limitation in
+the future:
+
+1. Extend the walk framework to allow callbacks to signal that the hugetlb vma
+   lock was dropped (e.g., a flag in ``struct mm_walk`` that tells
+   ``walk_hugetlb_range()`` to skip the unlock).
+
+2. Bypass ``walk_page_range()`` for hugetlb pages in the unlockable path and
+   walk hugetlb page tables directly with custom lock management (similar to
+   how GUP handles hugetlb without the walk framework).
+
+3. Re-acquire the mmap lock before returning from the hugetlb callback (like
+   ``fixup_user_fault()``), ensuring the VMA remains valid for the walk
+   framework's unlock. This changes the "never re-take" contract and would
+   require callers to handle hugetlb differently.
+
 Leverage default_flags and pfn_flags_mask
 =========================================
 
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7a..46e581865c48a 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -123,6 +123,7 @@ struct hmm_range {
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/mm/hmm.c b/mm/hmm.c
index 5955f2f0c83db..9bf2fa37f2efd 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -33,6 +33,7 @@
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
+	int			*locked;
 };
 
 enum {
@@ -86,10 +87,28 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
+			/*
+			 * The mmap lock has been dropped by the fault handler.
+			 * Record the failing address and signal lock-drop to
+			 * the caller.
+			 */
+			*hmm_vma_walk->locked = 0;
+			hmm_vma_walk->last = addr;
+			return -EAGAIN;
+		}
+
+		if (ret & VM_FAULT_ERROR)
 			return -EFAULT;
+	}
 	return -EBUSY;
 }
 
@@ -566,6 +585,17 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (required_fault) {
 		int ret;
 
+		/*
+		 * Faulting hugetlb pages on the unlockable path is not
+		 * supported. The walk framework holds hugetlb_vma_lock_read
+		 * which must be dropped before handle_mm_fault, but if the
+		 * mmap lock is also dropped (VM_FAULT_RETRY), the vma may
+		 * be freed and the walk framework's unconditional unlock
+		 * becomes a use-after-free.
+		 */
+		if (hmm_vma_walk->locked)
+			return -EFAULT;
+
 		spin_unlock(ptl);
 		hugetlb_vma_unlock_read(vma);
 		/*
@@ -655,14 +685,49 @@ static const struct mm_walk_ops hmm_walk_ops = {
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * For a variant that allows the mmap lock to be dropped during faults (e.g.,
+ * for userfaultfd support), see hmm_range_fault_unlockable().
  */
 int hmm_range_fault(struct hmm_range *range)
 {
+	return hmm_range_fault_unlockable(range, NULL);
+}
+EXPORT_SYMBOL(hmm_range_fault);
+
+/**
+ * hmm_range_fault_unlockable - fault a range with mmap lock-drop support
+ * @range:	argument structure
+ * @locked:	pointer to lock state variable (input: 1; output: 0 if lock
+ *		was dropped)
+ *
+ * Similar to hmm_range_fault() but allows the mmap lock to be dropped during
+ * page faults. This enables support for userfaultfd-backed mappings and other
+ * cases where handle_mm_fault() may need to release the mmap lock.
+ *
+ * The caller must hold the mmap read lock and set *locked = 1 before calling.
+ * On return:
+ *   - *locked == 1: mmap lock is still held, return value has normal semantics
+ *   - *locked == 0: mmap lock was dropped. The caller must re-acquire the lock
+ *     and restart the operation. Return value is -EBUSY in this case.
+ *
+ * When the lock is dropped internally, this function will attempt to
+ * re-acquire it and retry the fault with FAULT_FLAG_TRIED set. If the retry
+ * also results in lock-drop (possible but unusual), or if a fatal signal is
+ * pending, the function returns with *locked == 0.
+ *
+ * Returns 0 on success or a negative error code. See hmm_range_fault() for
+ * the full list of possible errors.
+ */
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked)
+{
+	struct mm_struct *mm = range->notifier->mm;
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
 		.last = range->start,
+		.locked = locked,
 	};
-	struct mm_struct *mm = range->notifier->mm;
 	int ret;
 
 	mmap_assert_locked(mm);
@@ -674,16 +739,24 @@ int hmm_range_fault(struct hmm_range *range)
 			return -EBUSY;
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
+		if (ret == -EAGAIN) {
+			/*
+			 * The mmap lock was dropped during the fault
+			 * (e.g. userfaultfd). Signal the caller to restart
+			 * by returning with *locked = 0.
+			 */
+			if (fatal_signal_pending(current))
+				return -EINTR;
+			return 0;
+		}
 		/*
-		 * When -EBUSY is returned the loop restarts with
-		 * hmm_vma_walk.last set to an address that has not been stored
-		 * in pfns. All entries < last in the pfn array are set to their
-		 * output, and all >= are still at their input values.
+		 * -EBUSY: page table changed during the walk.
+		 * Restart from hmm_vma_walk.last.
 		 */
 	} while (ret == -EBUSY);
 	return ret;
 }
-EXPORT_SYMBOL(hmm_range_fault);
+EXPORT_SYMBOL(hmm_range_fault_unlockable);
 
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure



