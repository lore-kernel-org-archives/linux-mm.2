Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2997CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A318E0006; Mon, 10 Nov 2025 15:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5612F8E0002; Mon, 10 Nov 2025 15:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450838E0006; Mon, 10 Nov 2025 15:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4E98E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:32:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF3A814018C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:12 +0000 (UTC)
X-FDA: 84095844504.21.30F87D9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15B581C0009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HnyCPb3B;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762806731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLe283o4vMysaCqrwno0HqJtodx+oXYkkx187sYaHGg=;
	b=eZdoNo1qHrgWCxDv+8XT9cyxKo2bRh1M3ALRUIW9YnfXezsNJd5PLi3adu6irD7381wDwp
	wdmA5tmxeTR7VYi+FfnAujn2lcD7r5IP3PUFoy6ZRIu7qd74ZU9/baQtFWYudfZHoMYt7Z
	s8v79rfOWqqSEP9gAE1DRWf9JmIfw3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762806731; a=rsa-sha256;
	cv=none;
	b=xvIIKTCk2c4wjPxm2Tl/7wz8GdxCo2gqJXQVYPlwUQ2H4L+LNB0HWyXE+J0vMC5GEfwlaM
	eA0y7bIzol8a2jixuRlwoCT9jzydK3Cshf7TKR1HHdH2XN51YI3oNk+QaKfJVWZOe59Hir
	PV59iukXU8+lmB1Fl3umfo8Sv4vnGJc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HnyCPb3B;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wLe283o4vMysaCqrwno0HqJtodx+oXYkkx187sYaHGg=; b=HnyCPb3BY5rrFjMFTsNakt3ckE
	0b6KKY7V3C+wjuZJnzlDp9eHg+Qsi4uPWkmKS9168qJeRpBRWiYSKJLdqLC9nrp5xZD4T85Sag++O
	AMhsdBVLxgT71w028twFDmAk89VpcCeuaFGsjImFNZL/mCPd4GWfVfHpU4JfrAOnUqOpt3EPEJCr7
	b3ozH1misgwfj9NzO+GVf0V8ImPo5ZBl4qH3bCoNeWum6/+G1gkfAFfIYoaYqqpPd6cxvw12/iew4
	s2bw6VIcQBhL17JqM2MLtO69SysHqJgI7IeEXrfqr/uHiO1sBp0qj67cSViLH2xK9jyIjRHlFemX7
	E6F1AGEA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIYYX-000000066Kg-2U7n;
	Mon, 10 Nov 2025 20:32:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Li <chriscli@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 1/2] mm: Add vma_start_write_killable()
Date: Mon, 10 Nov 2025 20:32:01 +0000
Message-ID: <20251110203204.1454057-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110203204.1454057-1-willy@infradead.org>
References: <20251110203204.1454057-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 15B581C0009
X-Stat-Signature: dqomqk7x3gwr5e8mueerczmag8x8ikyx
X-HE-Tag: 1762806730-364121
X-HE-Meta: U2FsdGVkX1+KfiSruRr9NesEnpysbShabRybjYY6lVH3RinkBoQribezCB7r1grDjuLfCNCpn7mCnLv3bQqE/P3oXK1V2j/kpL8NjsqKkql11iV+29tn41hZe9KZ63E8ncoLJibTvrsq4UWdfNnzWN2SfNTs0Z8qkbtAetczSr+MURXtjTsjtgKtYU3qffrQP8E162QQ31/NAPEQQpFD3pbhTDMbEK1NgigL3IUGbhk6utqMrB+0gubYsr9xmJjqDNQ3+RAxE6Q9cWQdLgwsu5x1+8xeIHd6gPuenya5sZMxTAh+1tXgcEKpOCP8hSYAgEcc6+8eeXImn0RnNKdyOh1oTKEUIoHhq+65BDdW+olAjtupwwsbUCKjAIA8sG2fhxaY7ROgugpTx3g62RMqCqd22QAtIe02R2ITb+Whm2z5Xu2A6S0FeP+H3R8HS1qJorAwfblSZ/hb0uwZyTQ8WfQzVqcgIxeTJqqXCBroR5Br3fJZ+7Of9Xn6xynQ4uKIkKWC6KGlsIiCLBWbPLxXU5t+8zQtfPOcdc0McR33cpmXBg1YZcF6Thu5xR9/Nw5tCBfBFTArG8AF6ii2fpL2OeDJ3jEAGq/L2jV15TK7jvjJH/sHztbtZqQ0M74C3u46nK7+ZXw//NMa4uL0kEvmRMNk+xL676wQpe7745jp4tzYPDTBffisPMCNxwRp5JQ1cHxfxv6u4HGpoT43sECY9K3NJtbhoYNH1BqcTp7pBcqRFq4iiqq58unHiCd7v4dVXT5vkjsMorJzKzzHHq56+Iagbt9MCE4N+kg/hcnMvoB4rrI4nr6rf32Vtxw+sD2eT8+qqUCGgBbE9iK1HwNNThfWj8jHGFS7X7AOAhvKnBXbi4kw0Cip+uGdG8JJUUxJiTEDbTv4s31pqgJ7uX2Xxw+ga6MShubgSOc3ivPCztKhYPY0UYmkWqDyWARAv4G++FZSDcmFvNSgrwFHvpO
 yCc+Q3+9
 wCz2M4sXlK8N4gDHIEx/gGqrrEhSYY1yRb1WhuxvYHCwJRqtnSrMc45fONbmWlSPx5HPD6BFOVk/3nrIcOsDPEhpNa3ooNs3qEHQRzqvL4Ar2L9rXpLP36ehuYgsxe8CmV+f2WQnYblkdwiuO8Y9Cnbjs8zSsIBjAPpuACyQae52zb3d8syMM/pwyJB1PwOKdRllrMOJm0WVDJEAFGK2+TrPt4qgATwDTXF+qop4NLHw/+IMNmcF3tG2d536LnhFxND95R5T9qyntIohxuUDXqU6B+G/moLaLJ8OIf9A7/unrbzdUz20tEzc6d6hO7x0i6+HZu2/jdL4itsgQlbv4j4zBHj4dddEj73UqtxRoM4ePMh2iA42VmNkTT1sX47LAZLoxfUM+QJo9muA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vma can be held read-locked for a substantial period of time, eg if
memory allocation needs to go into reclaim.  It's useful to be able to
send fatal signals to threads which are waiting for the write lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 Documentation/mm/process_addrs.rst |  9 +++++++-
 include/linux/mmap_lock.h          | 30 ++++++++++++++++++++++++--
 mm/mmap_lock.c                     | 34 ++++++++++++++++++++++--------
 tools/testing/vma/vma_internal.h   |  8 +++++++
 4 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index be49e2a269e4..7f2f3e87071d 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -48,7 +48,8 @@ Terminology
 * **VMA locks** - The VMA lock is at VMA granularity (of course) which behaves
   as a read/write semaphore in practice. A VMA read lock is obtained via
   :c:func:`!lock_vma_under_rcu` (and unlocked via :c:func:`!vma_end_read`) and a
-  write lock via :c:func:`!vma_start_write` (all VMA write locks are unlocked
+  write lock via vma_start_write() or vma_start_write_killable()
+  (all VMA write locks are unlocked
   automatically when the mmap write lock is released). To take a VMA write lock
   you **must** have already acquired an :c:func:`!mmap_write_lock`.
 * **rmap locks** - When trying to access VMAs through the reverse mapping via a
@@ -907,3 +908,9 @@ Stack expansion
 Stack expansion throws up additional complexities in that we cannot permit there
 to be racing page faults, as a result we invoke :c:func:`!vma_start_write` to
 prevent this in :c:func:`!expand_downwards` or :c:func:`!expand_upwards`.
+
+------------------------
+Functions and structures
+------------------------
+
+.. kernel-doc:: include/linux/mmap_lock.h
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714..378dfb9f1335 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -195,7 +195,8 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_l
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
-void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq);
+int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
+		int state);
 
 /*
  * Begin writing to a VMA.
@@ -209,7 +210,30 @@ static inline void vma_start_write(struct vm_area_struct *vma)
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
-	__vma_start_write(vma, mm_lock_seq);
+	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
+}
+
+/**
+ * vma_start_write_killable - Begin writing to a VMA.
+ * @vma: The VMA we are going to modify.
+ *
+ * Exclude concurrent readers under the per-VMA lock until the currently
+ * write-locked mmap_lock is dropped or downgraded.
+ *
+ * Context: May sleep while waiting for readers to drop the vma read lock.
+ * Caller must already hold the mmap_lock for write.
+ *
+ * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
+ * received.
+ */
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma)
+{
+	unsigned int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
+		return 0;
+	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
@@ -286,6 +310,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 0a0db5849b8e..39f341caf32c 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -45,8 +45,15 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
-static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching)
+/*
+ * Return value: 0 if vma detached,
+ * 1 if vma attached with no readers,
+ * -EINTR if signal received,
+ */
+static inline int __vma_enter_locked(struct vm_area_struct *vma,
+		bool detaching, int state)
 {
+	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
 	/* Additional refcnt if the vma is attached. */
@@ -58,15 +65,19 @@ static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
 	 */
 	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
-		return false;
+		return 0;
 
 	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
-	rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
+	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
-		   TASK_UNINTERRUPTIBLE);
+		   state);
+	if (err) {
+		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+		return err;
+	}
 	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
 
-	return true;
+	return 1;
 }
 
 static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
@@ -75,16 +86,19 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 }
 
-void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
+int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
+		int state)
 {
-	bool locked;
+	int locked;
 
 	/*
 	 * __vma_enter_locked() returns false immediately if the vma is not
 	 * attached, otherwise it waits until refcnt is indicating that vma
 	 * is attached with no readers.
 	 */
-	locked = __vma_enter_locked(vma, false);
+	locked = __vma_enter_locked(vma, false, state);
+	if (locked < 0)
+		return locked;
 
 	/*
 	 * We should use WRITE_ONCE() here because we can have concurrent reads
@@ -100,6 +114,8 @@ void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
 		__vma_exit_locked(vma, &detached);
 		WARN_ON_ONCE(detached); /* vma should remain attached */
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__vma_start_write);
 
@@ -118,7 +134,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true)) {
+		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
 			bool detached;
 
 			__vma_exit_locked(vma, &detached);
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index dc976a285ad2..917062cfbc69 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -844,6 +844,14 @@ static inline void vma_start_write(struct vm_area_struct *vma)
 	vma->vm_lock_seq++;
 }
 
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma)
+{
+	/* Used to indicate to tests that a write operation has begun. */
+	vma->vm_lock_seq++;
+	return 0;
+}
+
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
-- 
2.47.2


