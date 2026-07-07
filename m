Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D513C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978F56B00A4; Tue,  7 Jul 2026 15:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950D26B00A5; Tue,  7 Jul 2026 15:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866E06B00A6; Tue,  7 Jul 2026 15:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54F4F6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C61B6C296D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:06 +0000 (UTC)
X-FDA: 84963014052.26.C92A47F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6CFC180005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V6zS4BN5;
	spf=pass (imf24.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+CVN3h9eUUn5cnhwzVU69Wvf2wjPvEZWVRD1j6vs7c=;
	b=U/ukqC6dPC2Zd5yFqB/a5bh0vCNQwF1XtK4hybfRy8TvTrX83lfFvLXD8zZgvwt0jPy5l+
	MiNWowT7GMglUdUtUJu/crz7LSW3yr5fLoWbDZMfqjjX1JCzSns4+IH+p3YklINxzIQdGl
	kWg93FfYkr/JKav988thD9pasc/sFv4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V6zS4BN5;
	spf=pass (imf24.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453624;
	b=GErv7awNq5ZPHoKS9T+lTqT+WvpBP7/gxutWTcqoKcC9Hh12+DP+tGn76UvmyyEklr3xL1
	g9MNk5x5CZbfGBeKBymylb0bqrk1HXqTpsuzGQ14OE1uAak87Fh0RMCoN5hWYxR1wR6vIY
	9dWkaYuzcO7QTFK8RMLqc/1Q7ppD0Os=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so37720165ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453624; x=1784058424; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=X+CVN3h9eUUn5cnhwzVU69Wvf2wjPvEZWVRD1j6vs7c=;
        b=V6zS4BN5S0QKxXQo2Wow+radmzw+cOGGDofAZipYgvoqYgyRqJEMo/K1kw4l2/17D8
         Pxr6CUNdWFQQBBxfrO5y872osd1OdmmwbDB90SFZf+wWo7/VsJN/QulY9/RUQM5LyZ24
         ePeCvWoN5QGn9aAJBdIaNQfTgYhsdRRlQaoZ33aLy9D8YN+2sFt3FhtCAjdx0uvVfSe5
         Vtt3UyK0BtsUzicyA6oUfwqA+t59vOKM4plHBPbePvKcxwx8fqqJs95gF555Hjw8dZCY
         Zglq4CzAMVKWFX4UmOazoOq1aCJTqyIjHCemXH0eKsTdXGjbXDF+Jbvn/UPM2OBwyb0U
         w5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453624; x=1784058424;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+CVN3h9eUUn5cnhwzVU69Wvf2wjPvEZWVRD1j6vs7c=;
        b=h7lfYRe/yLt5XGYvgYGz5blpF78up+hPYdo9CU7LqDglZAWKV8noebrOq6Z8qXXc4a
         kl9i36lREuFgY3U4R6gohDJrNhIEP5mnTHZFqdZDqd0+AUW8WQyXAnVx1pkR/Qh4GGDH
         1WeUJVpwnEmRLOF7AKm90RIsuxpi/DYhlPsE9oTfryIkCv0WxS538ifJFbslZxTxxpNy
         SCur5V574AdUtyoK8EZERe8h8i/YLkGqXegknuMzgarhkgqcRYccmjntcvEjYfB5L3W9
         QZOpsT42jH3beyC6RirKaO2aHJVdFYdAr/hQu9ApZ4DjOPYpvoziDx1BtKe7jnw3WT3Q
         LJLA==
X-Forwarded-Encrypted: i=1; AHgh+Rrqd23g3Oxl8OR5Lv2nDCZoY3Ax4/FDHttyoBpRp6ud7+RznuHV5tbzX6UHjcrpPHGyNcVNl9Uy3A==@kvack.org
X-Gm-Message-State: AOJu0YwsOoenCaKLk1wardxEv63hUMugZ4sITKY3MslcFOPsn8lmAZ6d
	QqpzVRV3ekEaMsn7dcRbg3c77g0WVmlUrdqG6BvaL4vDsr00/VEWcrwF
X-Gm-Gg: AfdE7cmyZwxK3/DyrrLEE5R2vkN6S00MEBR/Lj0Kl5wSiSxy9xcxVH83ZmLQtGaVgSH
	bL46t40/PGmXmBv0qZz9cDevIeNtGhmVvSFxeOWdX0zTi9AcOKEpZfZdwQaFkJ0fVLVd91LXYZF
	e8W8zhgeQ5fXoV3LsEZNNQuQycBLALevcDK3JLPRc5PS3XIk+xu4UpFn4rRHX0U8gNFgBb2E7tA
	k+ox5F/enkYub0Qx0Oo3gOk+h5X3SlySy99smMo6R/owIcN8YLXCXrvzI8IZSj2OkBFdZH7LLRO
	53hW28XLs2nOAgs4/5vrXwC1UBvz/J/OMzL3iNkZrhIymsrHSJbV7WW5n7JTj9jGLiYnb2lnO8A
	0xmtWzsAaP9P+JRJhRtbvuXHb1KRy7PbvbLeC2ikoY6SHD+oL4zzHFMRFYKngu/9YiC/o4/es3G
	k7dgxpgSARAxzwrfiut61wBFCnX8WPR2klH/MN/qPEvoZ6PU3gGnapL+QBDzg=
X-Received: by 2002:a17:903:37c3:b0:2cc:9473:97c8 with SMTP id d9443c01a7336-2ccbe722810mr68422355ad.15.1783453623691;
        Tue, 07 Jul 2026 12:47:03 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1ea7fsm17010495ad.38.2026.07.07.12.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:03 -0700 (PDT)
Subject: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout() for
 mmap lock-drop support
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:47:01 -0700
Message-ID: <178345362182.660027.12809852179204464964.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6CFC180005
X-Stat-Signature: xgsuoiokdbgihth1xkkta8xpuj1kjy6b
X-HE-Tag: 1783453624-819702
X-HE-Meta: U2FsdGVkX1/Sr/DvGws3dTYnQGrpXPrPYUnwfPIOZIxMDsleRlNF4wBYLAXSRBP6sE1dIaq3p5bsskJwYLtkhOZ+4vuOeg/FXss7Ef1es6jkCyxppzeNw9mlv+y0Vgg1ZUActq9o0kU8VoZ38+U0wQ4FVBV7CTOcwz4d7XOrcLhOpQ/jTkHAfPIy4v+3qvcGw1RTckRSHclI5C/JWPshhlLXiU9qdKpJVJVPRLxvF+jIt5bIbVgvzrPxkEOHCxm4ZbgiGSNKGSt1yrCYmlypfzze8cf3smV/qu/YiYEdUvmp17gE33Yp2NqGGzQKK4nR/nW5cp4aoaRSPv9ODBU43VXtB3UsAs2S1Q/OLoXnJLV8gUv8lSWX0t/enwry3FLAuaKlxIItTV8z0YjayKvtDmVyeF4jQ9ZV1jRtVQZRfS0raUjmmPc2TyeW0Vb/zhN6MNBfqhiXCJXLiScNabKezFrJjou41aOSGnGaWzYhlDA0OZrEib/14cuE8OML9jx9yYSM9ajjtXcF47NEc9LdmLAIVrenHOu0QCc8p0bK+lskz6VNJxE/x7ro7n2l+IZ7nwsMXCMInWPisQGpnMaD190FVkI8xgpGBpJBO6wK+1FCtWqihzasz/6Cn8Nc6JypVgtdb3pHjG9m+whAcq1lms2n3Ew82y9uH4LPeW7lYTtbJO+VvmEoogzJXbrgW5gKuwOn11oU3o1J/2Ygjwzjb/athIUs6E0nuCVjHUj7D5LR/bcwc2PLp8FAu2qPRr87IuHUQHifUp0q9tZLRQuaH5vfc+6KRj1gPVKku27ZBiTWaHW/tnALgnmzLnIc92gmsb6sS5j8JtHyE1xTVP/rHZ8hgi7VIGsMF3KS+YqOVE6MqLP7y0wB7BTw9/1WgU7rFfJaYFFFaSvfnT2r1JrgPHbN9/pNqhnSKay+SLDAAnnPO/gleZMD/gc7jFrm7GRHI6cFwrL++Br135bEfvN
 hy42DAIp
 zAUM3goRz9xUNaUi7r896QaJHoCzKNsILyRQxEBqcnamJyPelZ0z841N8x5HawWz8NGBVjQIItAD1Mb9ArE2TPSnj02hT2KovPdKrJHekDzh1QghbrA9PWzBTWPvASJd54+udXU0r/h10tKEaufuorEkDKltSLXw/YvT6qsIoLstcjsynzrpeCManvofhe/d28sSU3aGHB9eRSu41Rufngzz4DQnxnlxnNhCFs3m6SCJzp3Ys+UtJwr2ip9RUACvXcdbIqlISXcxLEJyAbp0i2Pp+uo9aKvuX4SWpCl3R5Au/UiJ0Docz0MXjGEKqcwUjFdFpltVgQnzaMypuEL/e1TkX4b9vmvYoKr4LxJ6cxv0tUCfm5MOwRcHud2vjfXRP/tbarYjskQWqPDAlScRS3PIwp2HFC2gKYllE0oICzPGg9P3vDR/j+UMBeH0ENS6xdJRm8aiBMZbx8QYv05APeD6oajj/do15gFmOi0drMInWNBHB2OP0HgLake1SSaq+IxwlIQhmn9TTdAnTOwJ9il+yUIjVxM0dDzmXkFw14GQthCGqKRP6TX+wLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() requires the caller to hold the mmap read lock for the
duration of the call. This is incompatible with mappings whose fault
handler may release the mmap lock, notably userfaultfd-managed regions,
where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
after dropping the lock. Drivers that need to populate device page tables
for such mappings have no way to do so today.

Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
mmap_lock across any work outside the HMM fault itself. The helper takes
mmap_read_lock_killable() internally, calls the common HMM fault
implementation, and releases the lock before returning if it is still held.
The timeout is specified in jiffies; passing 0 retries indefinitely, while
a non-zero timeout makes the helper return -EBUSY when the retry budget
expires.

When handle_mm_fault() drops mmap_lock, or when the range is invalidated,
hmm_range_fault_unlocked_timeout() refreshes range->notifier_seq and
retries the walk internally. The caller only needs to perform the usual
post-success mmu_interval_read_retry() check while holding its update lock
before consuming the pfns. If mmap_lock acquisition is interrupted or a
fatal signal is pending during retry handling, -EINTR is returned instead.

The common implementation conditionally sets FAULT_FLAG_ALLOW_RETRY and
FAULT_FLAG_KILLABLE only for hmm_range_fault_unlocked_timeout(). The
existing hmm_range_fault() path still passes no locked state, does not
allow handle_mm_fault() to drop mmap_lock, and remains a thin wrapper
preserving the existing API contract for current callers.

The previous refactor that moved page fault handling out of the page-table
walk callbacks is what makes this change small. Faults now run after
walk_page_range() has unwound, with only mmap_lock held, so dropping it
does not interact with the walker's pte spinlock or hugetlb_vma_lock.
Hugetlb regions therefore participate in the unlocked path uniformly with
PTE- and PMD-level mappings; no special case is required.

Documentation/mm/hmm.rst is updated with a description of the new API and
the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |   63 +++++++++++++++++++
 include/linux/hmm.h      |    2 +
 mm/hmm.c                 |  152 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 188 insertions(+), 29 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..70885f153d03 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,69 @@ invalidate() callback. That lock must be held before calling
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
+  int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+                                       unsigned long timeout);
+
+The caller must not hold ``mmap_read_lock`` before the call.
+``hmm_range_fault_unlocked_timeout()`` takes the mmap read lock internally and
+allows ``handle_mm_fault()`` to drop it during fault handling. If the mmap lock
+is dropped or the range is invalidated, the function refreshes
+``range->notifier_seq`` and restarts the walk internally. ``-EINTR`` is
+returned if mmap lock acquisition is interrupted or a fatal signal is pending
+during retry handling.
+
+The timeout is specified in jiffies; passing ``0`` means retry indefinitely. If
+the timeout expires while the function is retrying after ``-EBUSY``,
+``-EBUSY`` is returned to the caller.
+
+A typical caller looks like this::
+
+ int driver_populate_range_unlocked(...)
+ {
+      struct hmm_range range;
+      unsigned long timeout;
+      ...
+
+      timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+      range.notifier = &interval_sub;
+      range.start = ...;
+      range.end = ...;
+      range.hmm_pfns = ...;
+
+      if (!mmget_not_zero(interval_sub.mm))
+          return -EFAULT;
+
+ again:
+      ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+      if (ret)
+          goto out_put;
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
+      ret = 0;
+
+ out_put:
+      mmput(interval_sub.mm);
+      return ret;
+ }
+
 Leverage default_flags and pfn_flags_mask
 =========================================
 
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..6f04e3932f5b 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -123,6 +123,8 @@ struct hmm_range {
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+				     unsigned long timeout);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/mm/hmm.c b/mm/hmm.c
index 2129b1ee4c35..15110409be00 100644
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
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault_locked() drops
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
+ * Called from the outer loop in hmm_range_fault_locked() after a callback
  * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
  * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
  * framework have already been released by the unwind.
@@ -641,6 +650,9 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
 	vma = vma_lookup(mm, addr);
 	if (!vma)
 		return -EFAULT;
@@ -651,37 +663,33 @@ static int hmm_do_fault(struct mm_struct *mm,
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
+		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
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
+	}
 
 	return -EBUSY;
 }
 
-/**
- * hmm_range_fault - try to fault some address in a virtual address range
- * @range:	argument structure
- *
- * Returns 0 on success or one of the following error codes:
- *
- * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
- *		(e.g., device file vma).
- * -ENOMEM:	Out of memory.
- * -EPERM:	Invalid permission (e.g., asking for write and range is read
- *		only).
- * -EBUSY:	The range has been invalidated and the caller needs to wait for
- *		the invalidation to finish.
- * -EFAULT:     A page was requested to be valid and could not be made valid
- *              ie it has no backing VMA or it is illegal to access
- *
- * This is similar to get_user_pages(), except that it can read the page tables
- * without mutating them (ie causing faults).
- */
-int hmm_range_fault(struct hmm_range *range)
+static int hmm_range_fault_locked(struct hmm_range *range, int *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +712,14 @@ int hmm_range_fault(struct hmm_range *range)
 		 * returns -EBUSY so the loop re-walks and picks up the
 		 * now-present entries.
 		 */
-		if (ret == HMM_FAULT_PENDING)
+		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
+			if (ret == HMM_FAULT_UNLOCKED) {
+				if (fatal_signal_pending(current))
+					return -EINTR;
+				return -EBUSY;
+			}
+		}
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
@@ -715,8 +729,88 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
+
+/**
+ * hmm_range_fault - try to fault some address in a virtual address range
+ * @range:	argument structure
+ *
+ * Returns 0 on success or one of the following error codes:
+ *
+ * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
+ *		(e.g., device file vma).
+ * -ENOMEM:	Out of memory.
+ * -EPERM:	Invalid permission (e.g., asking for write and range is read
+ *		only).
+ * -EBUSY:	The range has been invalidated and the caller needs to wait for
+ *		the invalidation to finish.
+ * -EFAULT:     A page was requested to be valid and could not be made valid
+ *              ie it has no backing VMA or it is illegal to access
+ *
+ * This is similar to get_user_pages(), except that it can read the page tables
+ * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * For a variant that allows the mmap lock to be dropped during faults (e.g.,
+ * for userfaultfd support), see hmm_range_fault_unlocked_timeout().
+ */
+int hmm_range_fault(struct hmm_range *range)
+{
+	return hmm_range_fault_locked(range, NULL);
+}
 EXPORT_SYMBOL(hmm_range_fault);
 
+/**
+ * hmm_range_fault_unlocked_timeout - fault in a range with a retry timeout
+ * @range:	argument structure
+ * @timeout:	timeout in jiffies for internal -EBUSY retries, or 0 to retry
+ *		indefinitely
+ *
+ * This is similar to hmm_range_fault(), except the caller must not hold the
+ * mmap lock. The function takes the mmap read lock internally and allows
+ * handle_mm_fault() to drop it during faults. If the mmap lock is dropped or
+ * the range is invalidated, the function refreshes range->notifier_seq and
+ * restarts the walk internally. Passing 0 for @timeout retries indefinitely;
+ * otherwise, if @timeout expires while retrying -EBUSY, -EBUSY is returned to
+ * the caller.
+ *
+ * Returns 0 on success or one of the error codes documented for
+ * hmm_range_fault(). -EINTR is returned if mmap_lock acquisition is
+ * interrupted or a fatal signal is pending during retry handling.
+ */
+int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+				     unsigned long timeout)
+{
+	struct mm_struct *mm = range->notifier->mm;
+	unsigned long deadline = 0;
+	int locked, ret;
+
+	if (timeout)
+		deadline = jiffies + timeout;
+
+	do {
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		if (timeout && time_after(jiffies, deadline))
+			return -EBUSY;
+
+		range->notifier_seq =
+			mmu_interval_read_begin(range->notifier);
+
+		ret = mmap_read_lock_killable(mm);
+		if (ret)
+			return ret;
+
+		locked = 1;
+		ret = hmm_range_fault_locked(range, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+	} while (ret == -EBUSY);
+
+	return ret;
+}
+EXPORT_SYMBOL(hmm_range_fault_unlocked_timeout);
+
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure
  * @dev: device to allocate structure for



