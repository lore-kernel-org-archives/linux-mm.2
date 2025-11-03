Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B083CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51798E0057; Mon,  3 Nov 2025 13:03:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E088E00B8; Mon,  3 Nov 2025 13:03:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE13C8E0057; Mon,  3 Nov 2025 13:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 972898E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:03:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61BB587C3A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:58 +0000 (UTC)
X-FDA: 84070069356.05.A83CDE1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id BECFB20018
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mkVpVYcZ;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uf9qDwPpBKti/2vnaQsg3CnnbY9LC6EdMZfUqv38W5Y=;
	b=rFi4ZFsJYZnHK81NmsbiqJedJkzq3RQPRm3dgRY7e63fT93nHyuQEKRKJ5A3C8L0ysdwHc
	SIg2jEgWaQas3oVDK+eufwwsEuCtr1mwFPRwFyr06WKaFno9WevO+E8o7SgdnO8QcBe0Sj
	wL9K8R/EJ1nKAkT+G9/e4HfouPbZJ5c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mkVpVYcZ;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193036; a=rsa-sha256;
	cv=none;
	b=mIpinz0mTcgDZjCAh1/ZFzI1Z02SrgrXLv6kAtUQFHr6MjRIQZcGZ85T6oXvpadqvyfRxn
	Ql0ap4/rN5KMsWbhs/j0WMdww2oGvDe8xfFLFl2vHQSCVvW18huflDD3WrknCXpefbquaU
	8RYOja3trCxGCT3e9iRjLEat5eUmZZo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Uf9qDwPpBKti/2vnaQsg3CnnbY9LC6EdMZfUqv38W5Y=; b=mkVpVYcZb3WtBD8r+RMbRIAi4u
	xJNWmn+qD31QMSIhDhVT6NxO8lw9lB/BWL3Q82iQLW5tqRVDk/xYqWiOehU/6oKfK5z5DNKgD9TDj
	AzZvzkWMLh2Kp9ImF2pnpW5vsII8+bhO4yCco0W048ZmeVpJoSM3G3rD7x9t7k1kx9bb9aVH+YUog
	Kn5jb6S1yhG+I+MHSqlt6ZSUdAjAFZ6gzp3uvxlQ8BcSdiPKb0QMwzZxRBFysQwHeDdfVKbP1aLuB
	ln20PelbC1fsL50m3RVDM4ssHCB/BBbAKvrxeVdFTc+q/2+k3kq8Paf8QTYC/BmDRJhEXgvHEXym1
	4QmAqY5A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFyuF-0000000E8Ra-0VAE;
	Mon, 03 Nov 2025 18:03:51 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Chris Li <chriscli@google.com>
Subject: [PATCH 1/2] mm: Add vma_start_write_killable()
Date: Mon,  3 Nov 2025 18:03:45 +0000
Message-ID: <20251103180348.3368668-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180348.3368668-1-willy@infradead.org>
References: <20251103180348.3368668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BECFB20018
X-Stat-Signature: umttmm6k33kw9yksnip5cx6w6za3kix1
X-Rspam-User: 
X-HE-Tag: 1762193036-527838
X-HE-Meta: U2FsdGVkX18zvtazq32SMGlrz5A2GBwejS7mzTG2B++dRyKyZUnx4rDq0afvCDhzzysHi6/uxxi69OsDLXXWpES0YJKZzxigZCEFd0vZqS+9m8/QTJxH6xlJxOaRL6WBCN1U74eZmV0ywo2HnjOR6+OHZFxkaH3avcfyRAeMZmgYwXPj2zc/G3Dpgobe8c+AjK/K+icIMJHTvkjczU9Cd3NBqJ/wtbZmQjSyOosSNmluIFfIN0ngE3a48QOLqVKogTc7pGe+N/Nu9tVCa2qWhQQjWjklhiDoY6bpwhOYEZ9L36yb95ugpMY/UumFWUQnT9CLNaCRNr4BZ5yt3eKSUcDK8Ec9RqmKLIZHSYmt9qeLAwyucUwNuIMTRn0/+WzylpdmrNulXIx6OfVLU4EunlStemQeJ2o5ExbKYXRXPb5fXxDC25QzDp170X7jdmlzCl1G4HLvH0nZH7uVkQDT/ISNEkVwRD0MlnSpz5z2vXdYbq6Zhcq2wsDPeT9W5KRoFM5XDRWtw+2vcg1vGuat9tGHubniCCniDeSM0P4r0sxss/8L/O0V8OctO5MqqVfJS/0ODMgjvWpn36kiYt4ihrDPWtbrVpb3pmvPTdaqQaiSb7Ep2Ht6QgjizbqybpHkKqJtlXrZI5jHmXrY++snj7yUblUJeBvhU4v3ANeYA/RVzJUaPanGJ8e454nUz3HxLePxVE3K1D4rjJENk8QlDlYue1LhqHy6MntxgjMuH7FJ8dwwbW5VOivN1MH5oKr6CdPV6ZdHPN8jY+65kkKedddJQYamsUJISUVwltTUYVo97ZadWUrwW8jqczkp4Mydp4pmV6sNcGwsF8XDbykaKcSnh35WX0Dzq3EkCluTRUmO6w7l4XDMFKIOToVspoPhQ49ZolOfB3LJ6ohMxC9DW0tFGJ4EDeq9c0JnytYLsNRrkqR+H2xchHOzuQ4uwZ7MenZKPdMIOcA0zc4Sxip
 H03lYt70
 FbBVm7FTkkXATjgxzYo1HizuMJfcVmJODWCejZ6L4toEQGuauJblZ/zjsQN7acNGiFR/p4xee3xjEnubkT0SUA6EGYhsfehfVqsJvGvC76QdzqcOzdrNNxUOcI/eGpBSH8V3ArlKIwWVGWOmMKU302zq0q0mgiPdJ9A93XrGpoZ+e1pNWRCOy7LJSaKz8J23seHx2zCmaj+bMz5Z1PVO/RiWdSbErGUQYguJgJoUlVXqGhLbvnrL9cr1eC6R/sRzOUtFSZcePnKMEsmxIMjRJn06yXMC/9RHwHdOWjzGfghSMx2iQc/0IvC2UxDlB7oaJQvmEMSHpwFRV5H6F9tb7TmNACw==
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
---
 include/linux/mmap_lock.h        | 31 +++++++++++++++++++++++++++++--
 mm/mmap_lock.c                   | 27 ++++++++++++++++++---------
 tools/testing/vma/vma_internal.h |  8 ++++++++
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714..b198d6443355 100644
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
+static inline
+int __must_check vma_start_write_killable(struct vm_area_struct *vma)
+{
+	unsigned int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
+		return 0;
+	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
@@ -286,6 +310,9 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline
+int __must_check vma_start_write_killable(struct vm_area_struct *vma)
+{ return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 0a0db5849b8e..dbaa6376a870 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -45,8 +45,10 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
-static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching)
+static inline int __vma_enter_locked(struct vm_area_struct *vma,
+		bool detaching, int state)
 {
+	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
 	/* Additional refcnt if the vma is attached. */
@@ -58,15 +60,17 @@ static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching
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
+	if (err)
+		return err;
 	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
 
-	return true;
+	return 1;
 }
 
 static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
@@ -75,16 +79,19 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
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
@@ -100,6 +107,8 @@ void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
 		__vma_exit_locked(vma, &detached);
 		WARN_ON_ONCE(detached); /* vma should remain attached */
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__vma_start_write);
 
@@ -118,7 +127,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
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


