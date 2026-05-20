Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2076CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CE96B008C; Wed, 20 May 2026 10:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3446F6B0092; Wed, 20 May 2026 10:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A7B6B0095; Wed, 20 May 2026 10:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15D846B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:09:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBFA4A0345
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:37 +0000 (UTC)
X-FDA: 84787981194.13.1CF624B
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC43CC0012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tx0m3HN0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
	b=Ye61fOKB46AcANIMhuHtqvxbI+qp4gqzbCs7qIV0MwbqmPLQWmWWlxWMFl/OZJ9vSxvQPN
	0Dub98GHE7UWvhdZSJxJX8e3firvQRlC9T9gDnKo0bPeK3GsSjT+9MfGYU16AJWrfi5sTF
	LcFtySVcaH1xTDVd8NeS7w0/VsaYy1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286175; a=rsa-sha256;
	cv=none;
	b=ov9GJJRg7EebAQhDcRV78hbGHKBqJ9UE56EXJ14iU7nzTY6hRpt2mUi9hrAgWw2dExtCBg
	z5IfnrsA63EIbxBxKgiuRTqy7CW7pP/v5xKVIVBu38kZxvHbtoMdUtbJp14/juGRT0ttCB
	RkGRm/MXxh2ihgVtLyslbMJ6dQTzfEc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tx0m3HN0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-367d88b9940so3127041a91.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779286174; x=1779890974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
        b=Tx0m3HN0ZEWnCMAEB74hmc2SN9CJp4KkE8UCwTGbN5P6VbD58G1rIL4rLerNPmO8Xc
         8ws0Gr8QOx3et86SnU6ZQxvvxeA+Iheg4Y1XsKi6CeX1kQTq0VeY8TmMZFZWziqP+D9s
         m8EepX+QWXfkJ6YtZ3hk8JrWHDMRz5gIwGPd86wbigfC+JiigyAzUkJcK26Mm52Kkf9E
         9vTJ8q0avUDRL3/MDVnxKGxZ+jS5ZKO47UYywFuEJz2A8LXsQdtzL+1fZNc5FGUeWJ+L
         PW5PyhEpfWZ10r2GoKb+7RqPV+9EgiDn6qKF/bUUVg7dQX3Znw8tE4prVTblo/WInQUy
         qNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286174; x=1779890974;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
        b=cY0Ss8QTCmXWl6ve1kLRwEDRKmHaqrYe4zgg5efWbsuQNeVP29lfSCXjnh0TM9rw+E
         bGbIDNIMbqQ5vZQxwfQ2GQ+cHEAJWevyPkpFVTWr8pVD5VNXnlfcCk+syhFesdll+l39
         LS9McfeZNgw9eWXwcXfbIRAF4gnAxcNwmiI3Z8iu30dqayl+fZIJc42RLoW46ODsm8hB
         LmbLsPphKZ0/0FFJOO532oQsDebz6Y/QPMatLLE0hAi3azWDRIHmyBbg+jRCS0q7MUs3
         +bFjOYirWDKNeVBNPPN2az7hSxNH2f5MPnvUJ1GuUt6qvCeDl5Sx4J7WJiwOVDGq1M76
         WtIA==
X-Forwarded-Encrypted: i=1; AFNElJ/tEaMhDo1lTN/swqdg5gA9eccMhp2Iozpb5hOUdAShd7Wk/eujNk/Xw5YyLOC9pAUwmP9TQrQk4w==@kvack.org
X-Gm-Message-State: AOJu0Yy19obQaiWnZM/swvI2KNOJwdAgfSF+PxIB27EDRJ1ixD+a33py
	15o1lqxu3BI5QEXhTbAy0KNIHP17yEZzOv/IoVDD6Euc+jw9FEOMyeJN
X-Gm-Gg: Acq92OFUnfHB0wFzoWjnvkGYUNqX1TAEuYuBRochRShVmHlGvJLM083pK9AAf0aA1kT
	9APiAPZAmHyvmzaBQYZ1V0gfuIQxg56n2V4GU2s0kgPVAwzsbFfizcs0xe+mqseXMQaN/otRniI
	lGHgPkUwf12H5DqSthyBsJQJ8GN1yecOq1pl5ZniQpwEVTyAFgZQMDlhH9QFTJK5j36zWN1LLxQ
	iQKvQtbZPKtTEGpgnpaPYRKJJt/VqSSX4KaJiGedfFBjUR5QnLKVN63wMTSDGm5g/LsJq0hkLLI
	ZtqOwh2yhO93j4bu45VkyaMxX5jnNQx3qvWVzTwHR7dXzL3StOhHllDN+lcPZtIAgQADYDSwzm/
	DD+AUmDqcSokbIpp+D87i7soempDTRsgBAyIJ3mBr6wYJ5h103aovAF3jk/7pRAx5cUG+q+KP1k
	rZC71YrjPNyHGzRnJcz9/gKnOr/CpkzbW3UnxhpZcYWJCILE1W52W8ozIKBfz0XC6n/iQPog==
X-Received: by 2002:a17:90b:2d0c:b0:369:7433:2fe with SMTP id 98e67ed59e1d1-369743303a4mr19190776a91.6.1779286174420;
        Wed, 20 May 2026 07:09:34 -0700 (PDT)
Received: from [192.168.0.159] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3695a0efa7esm6546608a91.11.2026.05.20.07.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 07:09:34 -0700 (PDT)
Subject: [PATCH v3 2/3] mm/hmm: add hmm_range_fault_unlockable() for mmap
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
Date: Wed, 20 May 2026 07:09:32 -0700
Message-ID: <177928617293.589431.17688544423323771407.stgit@skinsburskii>
In-Reply-To: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC43CC0012
X-Stat-Signature: 8ptjt41rytrzdcn1y974b5nswgmpoi5b
X-Rspam-User: 
X-HE-Tag: 1779286175-515713
X-HE-Meta: U2FsdGVkX19SQZfzdFCAfgZWNdxA46Jf24i7dc446ohioQPkwIjP+YwXLf6bAUf9lIq5tUOHNhcg22E0bEiOoYLRkfniSMRrmtK2TJhISLo69xb4mvzZ7CUR8z5Zbv6pxNAjtw7ZLkzR+Nh/aHeCo7oDdYThUD/Jy/8wAON8l5HamObTg0flAnAUTQsQQat1rRcl5DPovWgXUbBR6PcHjrjQZzCy74DLWY89vEWp3orzqxG3cY/5sXVxDFAlvlmCt4lnyh6buH2V1s2WxUkIfBF0CTJ6PozJ1Ch+H8DGhWko4Oll2eF8YYfaDlJBjuilozNYBWAn0J3H1loe6TLb6MKhYTd6EXPEb2KRxkd8C6IRKENijqvsAdeEyk4BOfUy6Y7WKFhy4mxFMvTX7VMUdjVKVSQgVWLkz5IduxR3/S2UuaMrUmmtbuwZZL2Zkc6tp2mcT1RjhaLYbnMx8s8JIvO+s70Swf9DBTzsDgay1fnI5GzPYptJcW0djfvqbuuoR3wr8u60BoIxxSqnnQjrF8nKwCc9eUbrVf+1IUUM1F/t3VGmpX3YQbhmWf2qdqvyEHtAblH2zAHiDpHjxrQgjQxTC16GvKElKwxVpgK2woInz6bpvXO/Zoxq8m48U50MOofC5ShsHc1Jq0JMAbLASAnjcaIvZy6tMANoOsbGzXXLd1nqZ3BlnG3iYXw56LwSgOxyrXY7TF4pRvpgfTxlKzgV1H0nxfc35labsiYaqhkc4SNhU9QEWOVMzyJW+x7pqWAkBGqePHRDQWBKDPkPqRF8ihvmgsliSl/EzD6y9ixbhku18b7uX6zuEx3q7CG98qBJ18Ma24WQc0lRrp3b46N4ipTGb8kjGOTv1qh6EGIjausvd9EnirWgD2S4opxsxpKd99yEb84VI+CXjArB0yfsRqqMJgD2o7vEJmlDQYi+SBFAckNaIgB0rGj1cM/p6oOKzlqHlLcSo7pNpN3
 CuGMKd9B
 61ceuJnAsSv1lwlWCXFt/eHtg6H/ODeTv1CVww88mJkvhkjmBoR8oVnFjUW7imIBeKI0S+M7HBkaFkZ7Ej1c4vhYOfmL667HHyFxLRYTi5Xc37EszqPkmxALweQic/P4f4E+eRaVgcKhK74GPQuxSaOSm0sqCY6JW21hSsv6H0UjDdutdGVKK8zCDuZ2UoaJXsqXmfeGw+hriYJkViLOw6hXPUaNMK9SrJUQG0idex3zsqjiHakCFkE6bY46VYjzin3nl5+O3+Epocd/shir/jxbe1XjMCN5oOaqu2hpKgpwnmLZdfz34XosVobJItuoZIW0tbOFr0TZJpBgO9fq/fW4qgXdtD7ce2ofpT7G/QebYVzg15e+9r05ZKdoWtoAQe2pkdNgKc4k1isS1KiAKz0PYw7eDXOEdk8sdPlURlNeQrH+WgxQCWxzSQmvwXbxlozOXcIJp27Pqz2F69Tm2k9FgKB+671WMKQBrtjrDF6wRKxJBKvVHX2SIR7D1JXyYRysa5KW3RqcQCNR/hJDYsi/OMDK2rGV6aRTLszox4HT6XXPnX/luUs5ZEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

hmm_range_fault() holds the mmap read lock for the duration of the call.
This is incompatible with mappings whose fault handler may release the mmap
lock - notably userfaultfd-managed regions, where handle_mm_fault() returns
VM_FAULT_RETRY or VM_FAULT_COMPLETED after dropping the lock. Drivers that
need to populate device page tables for such mappings have no way to do so
today.

Add hmm_range_fault_unlockable(), modelled on the int *locked pattern from
get_user_pages_remote() in mm/gup.c.  Callers set *locked = 1 and pass
&locked; the function may set *locked = 0 to report that handle_mm_fault()
dropped the mmap lock during a page fault, in which case the caller must
reacquire it and restart the walk with a fresh mmu_interval_read_begin()
sequence.

The implementation is local to hmm_do_fault() and the outer loop in
hmm_range_fault_unlockable(). hmm_do_fault() conditionally sets
FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE when locked is non-NULL and
translates VM_FAULT_RETRY / VM_FAULT_COMPLETED into *locked = 0 plus a
private return code consumed by the outer loop, which in turn returns 0 (or
-EINTR on fatal signal) to the caller.

The previous refactor that moved page fault handling out of the page-table
walk callbacks is what makes this change small. Faults now run after
walk_page_range() has unwound, with only the mmap lock held, so dropping it
does not interact with the walker's pte spinlock or hugetlb_vma_lock.
Hugetlb regions therefore participate in the unlockable path uniformly with
PTE- and PMD-level mappings; no special case is required.

hmm_range_fault() becomes a thin wrapper, preserving exact behaviour for
all existing callers. No EXPORT_SYMBOL behaviour change for
hmm_range_fault.

Documentation/mm/hmm.rst is updated with a description of the new API and
the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 Documentation/mm/hmm.rst |   62 +++++++++++++++++++++++++++++++++++++
 include/linux/hmm.h      |    1 +
 mm/hmm.c                 |   77 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 135 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..a9309023ec23 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,68 @@ invalidate() callback. That lock must be held before calling
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
+If the mmap lock is dropped inside ``handle_mm_fault()``, the function sets
+``*locked = 0`` and returns ``0``; the caller is responsible for reacquiring
+the lock and restarting the walk from ``range->start`` with a fresh notifier
+sequence. When ``locked`` is ``NULL`` the function keeps the lock held for the
+duration of the call, identical to ``hmm_range_fault()``.
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
index 446dd0c39b3a..b9ced5003e16 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -32,6 +32,7 @@
 
 struct hmm_vma_walk {
 	struct hmm_range	*range;
+	int			*locked;
 	unsigned long		last;
 	unsigned long		end;
 	unsigned int		required_fault;
@@ -44,6 +45,13 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_PENDING	-EAGAIN
 
+/*
+ * Internal sentinel returned by hmm_do_fault() when handle_mm_fault() drops
+ * the mmap lock during a page fault. hmm_do_fault() sets *locked = 0; the
+ * outer loop consumes the sentinel and never propagates it to the caller.
+ */
+#define HMM_FAULT_UNLOCKED	-ENOLCK
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -639,6 +647,7 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned long end = hmm_vma_walk->end;
 	unsigned int required_fault = hmm_vma_walk->required_fault;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	int *locked = hmm_vma_walk->locked;
 	struct vm_area_struct *vma;
 
 	vma = vma_lookup(mm, addr);
@@ -651,10 +660,20 @@ static int hmm_do_fault(struct mm_struct *mm,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
+	if (locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
+			*locked = 0;
+			return HMM_FAULT_UNLOCKED;
+		}
+		if (ret & VM_FAULT_ERROR)
 			return -EFAULT;
+	}
 
 	return -EBUSY;
 }
@@ -677,11 +696,53 @@ static int hmm_do_fault(struct mm_struct *mm,
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
+ * hmm_range_fault_unlockable - fault in a range, possibly dropping the mmap lock
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
+ * *@locked = 1 before the call.  On return:
+ *
+ *   *@locked == 1: the mmap lock is still held.  The return value has the
+ *                  same meaning as hmm_range_fault() (0 on success, or one
+ *                  of the error codes documented there).
+ *
+ *   *@locked == 0: the mmap lock was dropped during a page fault.  No PFNs
+ *                  collected so far are guaranteed to be valid because the
+ *                  address space may have changed under us.  The return
+ *                  value is either 0 (caller must reacquire the lock and
+ *                  restart with a fresh mmu_interval_read_begin()) or
+ *                  -EINTR (a fatal signal is pending; abort).
+ *
+ * The caller is responsible for reacquiring mmap_read_lock and restarting
+ * the operation from range->start.  See Documentation/mm/hmm.rst for the
+ * full usage pattern.
+ */
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +765,14 @@ int hmm_range_fault(struct hmm_range *range)
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
@@ -715,7 +782,7 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
-EXPORT_SYMBOL(hmm_range_fault);
+EXPORT_SYMBOL(hmm_range_fault_unlockable);
 
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure



