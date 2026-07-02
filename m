Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A38E9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5926B0109; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD666B010B; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4206B010C; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4412E6B0109
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:41:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 564C51C18B7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:54 +0000 (UTC)
X-FDA: 84944531868.15.7F9FAFC
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7052F14000F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="LU/A0lKl";
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013572;
	b=f4K4ihatUKOt5slDOC/IHwHAIjFHawXj4faLJYuFu8oMCSEkHL1Z3mT0zG/3aeI4f8P1eX
	9dtQVgD4YJZWMG2yqhchxg13l04nnRg4hhyNLOUqEE4HG7wS9XBTsr5JsZT5igaAjxKgry
	5GfxgH58d3VpI8mkKqcwy0bpn8+2KFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4y+Zl/3YkvNN8FzMg6Af9oGiKQKRE/0ZpwWnqvzLb6Q=;
	b=LNWy3jKEhgbwj8pOP0T4ne47nLyrPPc8yviUZkCrAyjnXPxpcnvMfzoR1d/ZVTt6rDwsp/
	EEo9GjQU5GCjh552Sbpd09LHD2m7qZWJ2P3TuCaq9fn2EBOgQr0ZM+Prkj37qOO89lCiDo
	S8LPzychWDXztTJ9FMLLd12myoYS8oU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="LU/A0lKl";
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-37e0a189b0bso1374412a91.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783013571; x=1783618371; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4y+Zl/3YkvNN8FzMg6Af9oGiKQKRE/0ZpwWnqvzLb6Q=;
        b=LU/A0lKlQgOjJRjc7WvF07jE5Z0uNOpTezCT3jJ8WVtNMrfq7JFJc77unGZHLXb0+L
         fI2c6jtK7XsBGuW0r07tJ5PwEfDybLPRJtdLAZFGaNV2hy5tXztSc2BPHfTW2ReALEyx
         oaIKYfHsO0GC3I89AFDmmajuzBeRQq18drDK/hN2jhdjHR4gNE+LflbEY8NGUrYvXmzU
         IrSte9zM+e/mUKHQ9+EiZc9BIbNTek3DiKftUR+I48cLhxLgK5A9jXARMG9hzTcp8s9p
         zZxRInzZvkfJkrxq0pyfgyJm12P2NQncZA5yLKeEAZUxH+SBB95q9UcX90+iMaO3SMAg
         yxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783013571; x=1783618371;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4y+Zl/3YkvNN8FzMg6Af9oGiKQKRE/0ZpwWnqvzLb6Q=;
        b=cAdwp1tnh068FBilu8/Ade5JxyCzIVF7xpZBBeZ3RCUNi+FPFQk/SVD2KzkCK9DUiB
         ZLniKqHu55ekQo/WysXphtm06WqZ9MyTjpQc6o25jv15KMuDG9Ukz8IHIqeZUX07VQDQ
         P0pXo3U0Q9JqyoIoJsGVtXm1TV3JLFB64P/b60tZeurIW6yOIxl6wu+MUO7LDBivgx1c
         fSr0Y1rqyuYzOPXzOsP4jOL0xKG8/lYQTvUyqlGq76SL+M/bsAypUPLjKy4+XEr1z1tP
         iCJseomUsLiPI4tsPKEOAGaB9JMg8rx9ayzFyM4hcwMUZJfOxOIQVg+AEVULk20WR7Bp
         DIZw==
X-Forwarded-Encrypted: i=1; AHgh+RrT1f8bIiz4bRmnZleoZMHMZrtgGNMIu8B2MGhvdm1aHeSwq52zuer1S0nT26EQHuFcGMb6lOkuQA==@kvack.org
X-Gm-Message-State: AOJu0YwpQEWaqjnTjNjLkaJ17UZaBcE6E1Zw4XVHxWlye7SGyO/s2AbS
	YtS56dtIhZT6qZPNp0nDNV0Kujb1FgNICAF7fG9aUTkdEn6xLVnup8zw
X-Gm-Gg: AfdE7ckYdFd5JZ34r/N5xWLTK/VPdSsZL/PdC64t5fHSABZqnOOimLUmDLsNXdFimh5
	WSrvVobXPs3b/3W2ENVguywUPmFk/PphJKlAr3BIbh6mrToVwlj7tREgXusaxr/Q0XQV+U4Ukha
	1VZ+byxQHMAxSaLLIHYLnNzlOlm55OC6L2zSwUKYQQ7jWfUa9TmnFdDrPe2vL6tLsaT33KVSvWt
	1V41Nl2q6MBpgZcBqdMzQdeDLz/fIn0A9h1xrSr41svQ19SWcVHOUmi64vcqBNmR4fZElppf0qi
	u30ioa/Acgmdxyp6gE8sL0VDTaWCUN2S8QaI1f+CLh7L3bbudpPSvYjhXIXkX/XSEqIz8sBkEyo
	lhpm2qEpulRT3jLllM+NioXvDs9blIjNtUc8jwIe32uIGuq8WeMW4CCQNWGttVrOtlZsqp953IR
	YQtKz/xeakGo39PGxIMZ3dgqKUEtKun4ChL6kVU2MBZjb1UMqYRDd6i+8XcY0=
X-Received: by 2002:a17:90b:1844:b0:37f:c2a9:468 with SMTP id 98e67ed59e1d1-380baa6b497mr6238459a91.18.1783013571218;
        Thu, 02 Jul 2026 10:32:51 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3811584a9a9sm168539a91.16.2026.07.02.10.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 10:32:50 -0700 (PDT)
Subject: [PATCH v5 2/3] mm/hmm: add hmm_range_fault_unlockable() for mmap
 lock-drop support
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Thu, 02 Jul 2026 10:32:49 -0700
Message-ID: <178301356964.373695.14274584821659522979.stgit@skinsburskii>
In-Reply-To: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
References: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rsoqpogumeydrrjwtorp6bou6bxj4y7g
X-Rspam-User: 
X-Rspamd-Queue-Id: 7052F14000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1783013572-763533
X-HE-Meta: U2FsdGVkX1/1U0NGBYuz7/yJACgF2kttDbqmWIRcCY6kJZUD1w18wYLsSsKK5wZHbUJChjJT0pmu1DwGnPktVeUYQuL4NktO/uWdtk7QvAfCNd2ZuiS65FRwcsNB6NvBl8CwAXB5MCSEo+2x+PumuzFjSvFwUCTmFuV33/pErZIAbulaUxkW0BO9Vy9MdNztABMJj615egMe5Kx4PczPNkkVGwTPXI/kbFf0S5r5HQ77KPLslh6tDj46vbSRTUdNUTkY/RmqNfWpSgBZagB+Uz2Cc+ZS50FUW/BipqBRHG5wiMbiRXYtXEzYxRL4vsgbkVYgun5zsUuD5uvI/25jPsULfNThnvfXV/uMehdOGjb3q6PDCHp7xYjQxUih5UQvni5nEpOISyooeTK4RJpSeoyssF79pGgQ9rcyp9dDZKWI3Ta1uOjAyxCtyyYITUVPjGpDJwcXpaqCoQ2Ojk1MiAkS4jE9Lkib4a4MgiS6QdAG/ab2t+fCZ6oGGMMoGNffMP/xMTM6WWhAmEJ4nZGUBs4mFICpPrr+eWBdP87udCLkTKAOqKbIP7B6pIsDCJxJYeJrRp5SEnF6Qi5jbdzXeOEUEgUWcZV/7U+ig/WixZMf7wfoCUMc/TG1wVVERBwskr6w5Svb8gV1BqZE6dH6kWxXAiAXjrcf0NLd/tDvNesGfjDFFCvmU9/6+VxBWE3122Tia+7kp6GjTSiwWFd1Wri9UmTa36kVFKmN3koiY3eOAW+gM5tMDBBrq/qThLPR0Vai1uJmCfy7KQSACrBI8Bh8n6NURVxqwitU23Sz1dpfzqvNGZOQ/Jc5YlrmqFHXhPxZA+hgz7FywQ7+MCunnz4fZlTIDZdVowWU7Ad/uMB262y41G3nxAQL4ifhvYhPhsOSS1Qd91W7N2T82y9rQNhKmp2d6IAlFBFesdhHwdqCd59aIdTsJEL7MUgTo//5PzBRVCwKpOIgwq1Eavk
 lRfLEHZ7
 JxmfGNdC64xB4EMjVHunIPXUvi2lYDU8NZm8+uzXG0xtQ/DbfAHfNzNo5nCePbg2cHQbSeQ3s/5Fe+zOcUPugEaEy4Pyy/iUCiFDY1VGmExef18U6VdFHJxeZvhB1nmxNLyZMuSu/dU0jDJQqXXkwv2hNuY8wdcBNhUicrkTEBWdYTBAwd52SnO4OzJW8pcRO0EfCXY1AagxdtXJTYwavU5SX1BzmjoRxg1TLnsysDqqZ8rp694gKXUz5ekh0XrJs44IX6j+zsqESI6ICJRkxDQQNfj9ZbfRrr24xvZkvvrwZ+lXGq6p9LHW2EZ2JYjexvBijRHQz3y/RrRpIrbRt5J2Wjj3AdWDSIaLIa/84sleM5/hpny4BynHEmEYwGUXO6A62YO9+1S0/H5UCC29RcUfUchXxgDpNYIwLcwIEbwIE4mVBGCmupRF2dLZiUAPoarYlC4GJ666UmI7ONpb62JMo7ARuhiY+F6oNwpCHOKk3pbkuXam3AHhiud8BHJqBElJvb0cl9S9AqpOUFTJ96sQ3a8RPbgjeHT/pEDla4PL5WjsRaumVfNgq0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() holds the mmap read lock for the duration of the
call. This is incompatible with mappings whose fault handler may release
the mmap lock - notably userfaultfd-managed regions, where
handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED after
dropping the lock. Drivers that need to populate device page tables for
such mappings have no way to do so today.

Add hmm_range_fault_unlockable(), modelled on the int *locked pattern
from get_user_pages_remote() in mm/gup.c. Callers set *locked = 1 and
pass &locked. The function may transiently drop and reacquire the mmap
lock while servicing retryable faults, and may set *locked = 0 if a
completed fault returns with the mmap lock dropped. In the latter case
the caller must reacquire the lock and restart the walk with a fresh
mmu_interval_read_begin() sequence.

The implementation is local to hmm_do_fault() and the outer loop in
hmm_range_fault_unlockable(). hmm_do_fault() conditionally sets
FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE when locked is non-NULL.
VM_FAULT_RETRY is handled internally by reacquiring mmap_lock and
retrying with FAULT_FLAG_TRIED set so fault handlers make forward
progress. VM_FAULT_COMPLETED is translated into *locked = 0 plus a
private return code consumed by the outer loop, which in turn returns 0
(or -EINTR on fatal signal) to the caller.

The previous refactor that moved page fault handling out of the
page-table walk callbacks is what makes this change small. Faults now
run after walk_page_range() has unwound, with only the mmap lock held, so
dropping it does not interact with the walker's pte spinlock or
hugetlb_vma_lock. Hugetlb regions therefore participate in the
unlockable path uniformly with PTE- and PMD-level mappings; no special
case is required.

hmm_range_fault() becomes a thin wrapper, preserving exact behaviour for
all existing callers. No EXPORT_SYMBOL behaviour change for
hmm_range_fault.

Documentation/mm/hmm.rst is updated with a description of the new API
and the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |   66 ++++++++++++++++++++++++++++
 include/linux/hmm.h      |    1 
 mm/hmm.c                 |  109 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 166 insertions(+), 10 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..751ef3fb0434 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,72 @@ invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
 update.
 
+Dropping the mmap lock during page faults
+=========================================
+
+Some VMAs have fault handlers that need to release the mmap lock while
+servicing a fault (for example, regions managed by ``userfaultfd``).
+``hmm_range_fault()`` cannot be used on such mappings because it must hold the
+mmap lock for the duration of the call. Drivers that need to support them
+should call::
+
+  int hmm_range_fault_unlockable(struct hmm_range *range, int *locked);
+
+The caller sets ``*locked = 1`` and holds ``mmap_read_lock`` before the call.
+If ``handle_mm_fault()`` returns ``VM_FAULT_RETRY``, the function reacquires
+the mmap lock internally and retries the fault with ``FAULT_FLAG_TRIED`` set.
+If ``handle_mm_fault()`` returns ``VM_FAULT_COMPLETED``, the function sets
+``*locked = 0``. If the return value is ``0``, the caller must reacquire
+the lock and restart the walk from ``range->start`` with a fresh notifier
+sequence. If the return value is ``-EINTR``, a fatal signal is pending and
+the caller should abort; the mmap lock is no longer held. When ``locked`` is
+``NULL`` the function keeps the lock held for the duration of the call,
+identical to ``hmm_range_fault()``.
+
+A typical caller looks like this::
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
+      if (!mmget_not_zero(interval_sub.mm))
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
+              goto again;
+          return ret;
+      }
+      if (!locked)
+          goto again;
+
+      take_lock(driver->update);
+      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
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
 Leverage default_flags and pfn_flags_mask
 =========================================
 
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..46e581865c48 100644
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
index 2129b1ee4c35..1869b6df23a6 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -32,6 +32,7 @@
 
 struct hmm_vma_walk {
 	struct hmm_range	*range;
+	int			*locked;
 	unsigned long		last;
 	unsigned long		end;
 	unsigned int		required_fault;
@@ -44,6 +45,14 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_PENDING	-EAGAIN
 
+/*
+ * Internal sentinel returned by hmm_do_fault() when handle_mm_fault()
+ * completes a page fault with the mmap lock dropped. hmm_do_fault() sets
+ * *locked = 0; the outer loop consumes the sentinel and never propagates it
+ * to the caller.
+ */
+#define HMM_FAULT_UNLOCKED	-ENOLCK
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -73,9 +82,9 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
  *
  * Called by the walk callbacks when they discover that part of the range
  * needs a page fault.  The callback records what to fault and returns
- * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
- * walk_page_range() and invokes handle_mm_fault() from a context where no
- * page-table or hugetlb_vma_lock is held.
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault_unlockable() drops
+ * back out of walk_page_range() and invokes handle_mm_fault() from a context
+ * where no page-table or hugetlb_vma_lock is held.
  */
 static int hmm_record_fault(unsigned long addr, unsigned long end,
 			    unsigned int required_fault,
@@ -624,7 +633,7 @@ static const struct mm_walk_ops hmm_walk_ops = {
 /*
  * hmm_do_fault - fault in a range recorded by a walk callback
  *
- * Called from the outer loop in hmm_range_fault() after a callback
+ * Called from the outer loop in hmm_range_fault_unlockable() after a callback
  * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
  * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
  * framework have already been released by the unwind.
@@ -641,6 +650,14 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
+retry:
+	if ((fault_flags & FAULT_FLAG_TRIED) &&
+	    fatal_signal_pending(current))
+		return -EINTR;
+
 	vma = vma_lookup(mm, addr);
 	if (!vma)
 		return -EFAULT;
@@ -651,10 +668,30 @@ static int hmm_do_fault(struct mm_struct *mm,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & VM_FAULT_COMPLETED) {
+			*hmm_vma_walk->locked = 0;
+			return HMM_FAULT_UNLOCKED;
+		}
+
+		if (ret & VM_FAULT_ERROR) {
+			int err = vm_fault_to_errno(ret, 0);
+
+			if (err)
+				return err;
+			BUG();
+		}
+
+		if (ret & VM_FAULT_RETRY) {
+			mmap_read_lock(mm);
+			fault_flags |= FAULT_FLAG_TRIED;
+			goto retry;
+		}
+	}
 
 	return -EBUSY;
 }
@@ -677,11 +714,57 @@ static int hmm_do_fault(struct mm_struct *mm,
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * For a variant that allows the mmap lock to be dropped during faults (e.g.,
+ * for userfaultfd support), see hmm_range_fault_unlockable().
  */
 int hmm_range_fault(struct hmm_range *range)
+{
+	return hmm_range_fault_unlockable(range, NULL);
+}
+EXPORT_SYMBOL(hmm_range_fault);
+
+/**
+ * hmm_range_fault_unlockable - fault in a range, possibly dropping the mmap
+ *                              lock
+ * @range:     argument structure
+ * @locked:    pointer to caller's lock state, or %NULL
+ *
+ * Behaves like hmm_range_fault(), but allows handle_mm_fault() to drop the
+ * mmap read lock during a fault.  This makes the function usable on mappings
+ * whose fault path may release the lock (for example, userfaultfd-managed
+ * regions).
+ *
+ * If @locked is %NULL the mmap lock is never released and the function
+ * behaves exactly like hmm_range_fault().
+ *
+ * If @locked is non-%NULL the caller must hold mmap_read_lock and set
+ * *@locked = 1 before the call.  Retryable faults may drop and reacquire the
+ * mmap lock internally before retrying the fault with FAULT_FLAG_TRIED set.
+ * On return:
+ *
+ *   *@locked == 1: the mmap lock is still held. The return value has the
+ *                  same meaning as hmm_range_fault() (0 on success, or one
+ *                  of the error codes documented there).
+ *
+ *   *@locked == 0: the mmap lock was dropped during a completed page fault.
+ *                  No PFNs collected so far are guaranteed to be valid because
+ *                  the address space may have changed under us. If the return
+ *                  value is 0, the caller must reacquire the lock and restart
+ *                  with a fresh mmu_interval_read_begin(). If the return value
+ *                  is -EINTR, a fatal signal is pending and the caller should
+ *                  abort; the mmap lock is no longer held.
+ *
+ * -EINTR may also be returned if a fatal signal is pending during retry
+ * handling.
+ * See Documentation/mm/hmm.rst for the full usage pattern.
+ */
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +787,14 @@ int hmm_range_fault(struct hmm_range *range)
 		 * returns -EBUSY so the loop re-walks and picks up the
 		 * now-present entries.
 		 */
-		if (ret == HMM_FAULT_PENDING)
+		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
+			if (ret == HMM_FAULT_UNLOCKED) {
+				if (fatal_signal_pending(current))
+					return -EINTR;
+				return 0;     /* caller must restart */
+			}
+		}
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
@@ -715,7 +804,7 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
-EXPORT_SYMBOL(hmm_range_fault);
+EXPORT_SYMBOL(hmm_range_fault_unlockable);
 
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure



