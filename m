Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C351C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436226B009E; Fri, 18 Sep 2026 11:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E966B009F; Fri, 18 Sep 2026 11:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324706B00A0; Fri, 18 Sep 2026 11:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 086626B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42D0840726
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:28 +0000 (UTC)
X-FDA: 85227277296.08.225E80A
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 81D3A1C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R5nNQrUC;
	spf=pass (imf20.hostedemail.com: domain of 3xVmtagYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3xVmtagYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWMWdX0M04Ux74D6qkwQk3CE9vSTuvtr+k+ENnhVHRs=;
	b=oAHLHZCFW8+vr7AZ98KMb235LKTjScnNzkiE9Q9Zo/g94lgKzPondgF0JE62wZaDni973P
	2DXKdbJPfFIEiC6JgA7m3ZVhW3bmvJFodqQcLJNi+FQkVHyJqvFz4wxkNAY1Dlzcpsa7Ny
	EA03/6fmGCNfn0g/B6Yw9+wZLn6Be3I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R5nNQrUC;
	spf=pass (imf20.hostedemail.com: domain of 3xVmtagYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3xVmtagYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745606;
	b=lVe+uX8Ps0TDrl78sIXL1n8CNjej8RnLEM9YdwNqyBMdmAMH1HjVZvK62Ur8TqM5aIKWqW
	ZrcuoiX6xuSbpVcgUoYiyiLSXvqDMyvs3R26Df/HSgGpGATckxAlUn/fN9Mt+i51UjsL0f
	bNYJnugPyedSw3yPMQDsSY8zCgbD840=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso1736831a91.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745605; x=1790350405; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CWMWdX0M04Ux74D6qkwQk3CE9vSTuvtr+k+ENnhVHRs=;
        b=R5nNQrUCNTluD4xNTl9MwzjOrLAXalU0rrriyL8uk/KUrEaMvcQc3Br0Xh5YQLeMe4
         qX3QKvMo5EEOXxPQxljurkzDAnNmLJNWNWr+daOGuV7w5ZRP43qzry0B1HUQaLZGKBDK
         6l+rNvNABhtdFb6IVtXKVEO/MVHW+0LCIxsZaehlrtSIHsYAUWR5uoxZrST7x9DHywlp
         V9G946uC8lX60gmwVFQxmwKKKnfhYPvyGSYIiZ2unnQUQG/oG1/tKBdyD+96KkPdWl+p
         8JGySzcgqtZkgKbVqLu0yEYKdtmF9E5kxFZPtGQ8tm7l7roG1Z0prULG//edlIgJ4bDv
         SnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745605; x=1790350405;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWMWdX0M04Ux74D6qkwQk3CE9vSTuvtr+k+ENnhVHRs=;
        b=CsPUFa2GxEy+TZrvjMFtuOjEs8vcgW9q2o/ScRgg5QrqXVBC7ubKs+GH6CS/xfLvgS
         oJF5LYG9VAIeSVcmAYjM2cs5uaZqFNAl+HKF3CKmEJgHdzyv9oiKS2ncd3s4iE0cyR7w
         THjKToMNYO9GXzelrdrU0VRFFRQcQmbupgBbvYK8EhwRwamdaByVtV97aBLQabtM5j8P
         iIdHEhgM+3F+VlAAVhfkHdt+acdPdqYFRjYPag4hvvcKzoN3FoyXfAFk3R2KxLPTUCMQ
         1Imb4dfKAGr0plg6gKj+8An7KKrdDJw8Lh0eqH1V59EVHIqbumWaI77p6Z6la7ySyGHN
         ETWw==
X-Forwarded-Encrypted: i=1; AKwUvBzZPkp3oriZLseallQGua4/jbQ5a952rJvBXyVGFa+IDH27Ld1hBo2ROu8XaIA7+oD8dCKH948SpA==@kvack.org
X-Gm-Message-State: AFuF++lfZ5d8kM4tkOikr3N+kIq5qLvEfjQyTG5u+2PPSUDUh542PQxQ
	+P4LhErBVpiYwuUcD7XCs7TLkjjTsj9tXJ3trOhiGdI2dM48z9yaqLUtjNJKbOy7zCLsmC1wCH9
	ksgd0Mw==
X-Received: from dlev11.prod.google.com ([2002:a05:701b:464b:b0:143:966c:32eb])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d47:b0:39e:6a81:5a91
 with SMTP id 98e67ed59e1d1-39e6a815e2cmr504732a91.37.1789745605293; Fri, 18
 Sep 2026 08:33:25 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:13 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-3-surenb@google.com>
Subject: [PATCH v5 2/7] proc/task_mmu: remove unnecessary inlines in function definitions
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81D3A1C0003
X-Stat-Signature: b1r7qkdmtjbepixj13prupgan1k991np
X-Rspam-User: 
X-HE-Tag: 1789745606-790140
X-HE-Meta: U2FsdGVkX1/SPQdXysfut1tPaFNqHWUuin+pAX1RZLQndu7Fb7xDvtcwdNAK6dmZlIvtg92WtSfRoc90AT0zJ9/hLFBRnP/2VeGU3AMuOkZchl1QYN2YkYoHf5iw41ebw3zndwN7wVAMI6PJ2vFwrIYZdEVi8py+gcHHXq+rIwdJqfq+MZSt9CHcjSEUu51lTb8VW7MUxGWeUZVn7VhQkIuGGKZF3nq3hOaKvu0FktsWzAm8FzJRGGN56+b81HYI1pC5H+NrjUsYwcCArI3QRLewwW8j8tf+liyQNm5ar4GOlT7WkZAxNfLMqNgvIDoqXPtcNq4LsMEADBXuqDaOHrF6DzzoqzQJLyLswfeqjtmVkP5cKdL/ZJR7hPwUoFFDphu89Zckh5lZTZ7OENFmZLyaDravv9yfNb6PGUD6b/AbyiFsur1CTcv/bXwxMUye7uZ2FPMTXG451k0vgS6aVGS5JdPo4NEXIdkKEdxC8HEeRKW8oScLWii9WGDjsoOSXrSFcGzLp5bKJweN4Mm64hUOQEmcd/hjsDP/XrFS0fHgX1dficNs/GPkJYcywgUpUQJL099XIPCqgzOaHFYgMLbgqEJnIVYSE3RKwsOOZRVXyCbz9nnk5RsM/1N3EDWKNWplvCbxhGQ3Ka8g+uuViyvIPll4YgNa1s1NyxU0PXDDaye2ENn5Aq6SrVplrV6pf8STgnf3Tqpw4JzSRgfpjfANxvLaxET70vst1Y0vpcA+c1bk59CNi0bvwJV1VbOxqBpoGhzN14Mfo7wNTbFIwCJmy/G2fApGos8nKNnafKgXZhh7FlZ2gPj1uwWJwVPdgJaw0vyWBSjkCOnlftYV4kACdio40S0CuV8DChUYzVxeCGKJlHYMInZeIrRYOdX5NiVTDm9xGiKoXDYGoxvPeIG8HbMhNsbk9cQ7dM1qI3GRUy6Q4+1gB6QmZGf4PK62a+DC3+9WmhJ1vqStj3m
 GbKVD+5M
 yV13R4TAiQIkrs1y0NwKW/zo/i8zlnAc0nBw0fXAJSoRcTIa8hfiGMK/duVvU+tn/Xpc+dcZzOj2PyCrvjhu3RBLYeLzez+5RXIJtErjlE6NtFpqADHY+FbSPsBdw9bqcMUZ9CIRpFyCQzgE/dQMTR+zCcVGJexBM4gw8U7ikUaWurVSWU7QLWhSAEk9cNUjXNT2ovlW2AH98v8T8oUcC7saHhamGEEAvActXWYhiQnG8NXl/voYyQqkomMx3/x4Fyb0BrSdTOya1Jn6kcOC1cE68cb+UbWPylVe1W+4hIEOPB7DtrvXFYr7pxNA7ONklZ5hj4lQi4SbdpLuQRxBr9YCPa6zVIO4fztIAn5jqV3WdJdK0CeD3Qn1s+LP0YHo2HTay4hljwtE7srME6rQzDzHRA58Tz9nyfp9qoxAC1Y8O8wr1Ox2hXPJrotoIhv9wVRwtVq4Qni/0Ag+H+q92+xkYsnrDzVZPiMhYdryRSxj7hs9LSKO69nxwPJc+q7hV8Yb7jP3UjsNdJu2go9yJ0zy1OMsOAok3SFPHGx3wM1o0tVE1SusIw1N9G2glO/HCgE1qkCVRHybBtHDGbWy5e+VBS8MeiXzb+rWBTOa3wzcg+ceMqSOnhEZgluP3fLRAtLA2bIiJI3YKlsnEmyXlTTILOp21SA4vjntnMredsH1pTG/sLHmGYv3mIziRZCKm7I+WpbK7FFjTH7ENvvnXwr6xQitzboIIFJbXOx8osMp/ek1Ou3YHWezpiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compiler
can make that decision by itself. Cleanup these definitions.

No change in the resulting binary file size with gcc v15.2.0.
No functional change intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 191a054d7e40..8a72dc0dc945 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -130,7 +130,8 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 }
 #endif
 
-static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+#ifdef CONFIG_PROC_PAGE_MONITOR
+static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -139,8 +140,9 @@ static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 
 	return ret;
 }
+#endif
 
-static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
@@ -177,8 +179,8 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 	return vma;
 }
 
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
+static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
+		loff_t pos)
 {
 	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
 
@@ -194,7 +196,8 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return true;
 }
 
-static inline void drop_rcu(struct proc_maps_private *priv)
+#ifdef CONFIG_PROC_PAGE_MONITOR
+static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +205,7 @@ static inline void drop_rcu(struct proc_maps_private *priv)
 	rcu_read_unlock();
 }
 
-static inline void reacquire_rcu(struct proc_maps_private *priv)
+static void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -211,6 +214,7 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
 	/* Reinitialize the iterator. */
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
+#endif
 
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {
@@ -1230,7 +1234,7 @@ static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
 	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1238,7 +1242,7 @@ get_smaps_walk_ops(struct proc_maps_private *priv)
 	return &smaps_walk_vma_lock_ops;
 }
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1572,7 +1576,7 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
 
@@ -1588,8 +1592,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 	return folio_maybe_dma_pinned(folio);
 }
 
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
+static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1620,7 +1624,7 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
@@ -1646,7 +1650,7 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 	}
 }
 #else
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 }
@@ -1848,7 +1852,7 @@ struct pagemapread {
 
 #define PM_END_OF_BUFFER    1
 
-static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
+static pagemap_entry_t make_pme(u64 frame, u64 flags)
 {
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
@@ -3390,7 +3394,7 @@ static const struct mm_walk_ops show_numa_vma_lock_ops = {
 	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_show_numa_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
-- 
2.55.0.1082.g2b9226bbc0-goog


