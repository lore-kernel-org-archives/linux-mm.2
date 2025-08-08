Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99D7C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D19E8E0005; Fri,  8 Aug 2025 11:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587568E0001; Fri,  8 Aug 2025 11:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449EA8E0005; Fri,  8 Aug 2025 11:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 296378E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:29:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8C7B58455
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:29:02 +0000 (UTC)
X-FDA: 83753973324.14.FBA8603
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id E9F1B4000E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:29:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=waWTeod6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3uxeWaAYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3uxeWaAYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754666941; a=rsa-sha256;
	cv=none;
	b=nAvAgdfVVPQ48jyzEWF8z3penvmtg08lWFtDFXSCoFYSkDPurKycmvASvwkTw4wUtDKkfw
	3mGviUJJkSbuJT6aKR6nibG739Ia/hD92nyabIZMgttmDPxgmFqDtcSDYxumruatxFQwxn
	K+7DV1AJE+jYbaepouY2vt25coEiJtU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=waWTeod6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3uxeWaAYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3uxeWaAYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754666941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qaVRp5+Q87psp1cSnwtcdG7GaGDDk1FPXSJsj5vDHc=;
	b=3NnsZPEsmfaLWom7r8uLGU1jhKekEu452HbUKJnvnY55IsKVZ5RaTBIfBYGjlwdrs5m4JQ
	9ypsm98PaJHC0fpIARIEMBsky707Hcb+x7W4/ClIo/Q3PLmkKfECHQu+y9ktjHsq2v2ZIW
	WVpi0g9j6ST3PBqPnK0QrM/PAsMRk2U=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3217aae3f90so1864276a91.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754666940; x=1755271740; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5qaVRp5+Q87psp1cSnwtcdG7GaGDDk1FPXSJsj5vDHc=;
        b=waWTeod6tNQopBtrQ7L5TxEyOWgq4FKUGDrezSnkN+YbHErCPgLZECmzvGIJ4AnnQ2
         A6fc/yfOwq3BwSRkTLkfoJ59qMJvZw1pqg2hSfTHTRJgDPMjlcBFEkSkeC7437J4CwNj
         xnJlnjJ33RyCIictXvDghodEKDtgSAT+OF5820xtpl7zIQpbJ/zBfN+MFvmsw+DzIVjV
         ccQBvjY01ahtNexM7b7VvuFz1L39VxjYdpiCai0krA/Hmd1cX4uIAHVa84w//FThWaxm
         5L/xyy5Rq7w8b9KCvH+Pqf9IJ8endXj5DyaoeLGUvY1JIc5YBJbJtlk+KTf//p6rKWIJ
         ISIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754666940; x=1755271740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qaVRp5+Q87psp1cSnwtcdG7GaGDDk1FPXSJsj5vDHc=;
        b=e/JPXGp8n28fNS/H2LQFlzlarQJlhoptZ0CVP7aUK2n0J5ESj0U/omdofN9DOAqYDc
         dmrv/h6SxOzV8YG2IdewsSWSvqiahhyDMxcjxPZASB2E1kK5HhoYgbpinFX+ivKL9HPF
         MWNhakTc1Q2ScKoeCAGzoO34j6gsDfhYmN+zMqTDnGte0LtkC/qA5TFKz7Vh3/9D1haa
         cBlJmHWFrjkzhoqPve9S88vHe3XoEVsDIyNJWQBzHcTJWM4+gHfY49c38jZISaAo3kDf
         sxC1oZGrVclOTT/IxxyyPQLcLuCkYdKnM3XBhigDbZISbR+VD39z6WlSyuGgjtcncfvp
         tyag==
X-Forwarded-Encrypted: i=1; AJvYcCXf6sjKPCxd/QX+qk/XViOXsLtSk2y1ZLFd44TzWM/AhuodzYYBnN14z5kLFPa43vwU0qwXWNi9jg==@kvack.org
X-Gm-Message-State: AOJu0YyKTX0PRR4im0sTHdpGVQMSoUbB3cANd3791pc0JZfYBcPxiANG
	1dNugGnj+md7Z4s90htvdK4aQ8ZwYoB5nXr7sv3U7fqo5ftyf9pWbKb3ipUJmvEd0bljbDLbS3c
	nIkUGag==
X-Google-Smtp-Source: AGHT+IGfHbSuaYkDvkzFDZll/OyuLjbjmWu+3tdj38KsO6i2Mr+NdU7aQQPpEiVzAfcHA2GS7b/edCdIm5g=
X-Received: from pjboe9.prod.google.com ([2002:a17:90b:3949:b0:321:9285:be8])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e4b:b0:316:3972:b9d0
 with SMTP id 98e67ed59e1d1-321838a7672mr5733158a91.0.1754666939750; Fri, 08
 Aug 2025 08:28:59 -0700 (PDT)
Date: Fri,  8 Aug 2025 08:28:49 -0700
In-Reply-To: <20250808152850.2580887-1-surenb@google.com>
Mime-Version: 1.0
References: <20250808152850.2580887-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250808152850.2580887-4-surenb@google.com>
Subject: [PATCH v4 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
 per-vma locks
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9F1B4000E
X-Stat-Signature: 3u5mppfor36ijjhdprpybzg5estrf1aw
X-HE-Tag: 1754666940-991692
X-HE-Meta: U2FsdGVkX1+RDkfAmHy70xrYtE7eT5DCCd69tGm49Pyg7Ghj1tQpJzXwKv78m0ZmKPRQYT39//y7xz+ciFnZuIskTqWv+XV5RSGnbX+FNeh6OAXi+aTf4xplFhCNrSWAatFFmAB8UHMny0KPnK8efyUEqfCOfcdlopEPh/vvrt1dbkJGiqbqNbC9ViZehmJwwmMUL2P3HEmCHRspTVEyo8TCEx37aB6fV1mgxxXkrc5woGI8GuISXrIa/e62XmFBWHKw9bg2fxn6kmcYzGyrSPerifN/HBe+xpAlHHgLQHZ0g77eIOYl6dTEeBtl+14WZ/rFQA4YNlNWK8l0vqtVglM4kWRDvPc4Bp8ZrVgIcTc+xFxjfESmyeljhZftlnSTH9WNniCJLxo9vCPlV5BnGyKtocERgrlaYDKMdt00zJlerd7iDc2Ku1fEPm34uByZK+nvLbCLeWxYTB7NovO+ahg4vbcf3gMX93d7z80FRWx5X2xfaSeWxHPqoHX2IPA/7ygOKW7g76e1IuFHZKyp8/pp0AtoBUtXDh2L0ao75RgHAYs+tg3wotOsQINXISYvc87l+JYj4pBP8QwJEg1mwokWzIXNUD2nBbfY2Ifi9k86EJHNvxWtXz2l9gBYcIoHfwvBXcqA3GTmpxbK/aC6dDd7l/q6usx7wJcroesxfkorJA4lMTBWsLhocYpfclmXgGW+3pVov48E3KTzmsF1EPH3kMKq05nximieNqrT5U7xuFYiEK6xojSt47fUbNq+Hjba5yTZufMswWHdNGjweVR0KExvHcgzFjQQJF2zb+Y3VdKz8+kdCDvI5pNJsM7lTX1cQwG1taY09jAoe85JTtpMoxec7bZVkV6J4YiqB3Tw57QM7k3zPE67nixs2ZgTTOs9lk1Ms8nh04XMnH88UFVkWymZiwRjloOJW2XgzMXXgsNdkAShdupzfgKTgrktW3TqqAYsmw13f7PsZTO
 BeWEeBkQ
 IFJbGkpxksDnGmbwXSaOIeGkS5bJJNVm6qCBO/5gHuXnsJ7wJERniRxRzFBrjZSRJNaqS7BTBMxL+UU7a0NEDC2FdCdar8qju8WikUOmX204YQdb+gGkD5N1GhN1xZATmnFg62XGzTbXMutppoxvQ+tV7SSiK775HAlTCDAmXqv1G2r/vtFwViXW3K7F5u4P6mNVSTYwfCbONsfmYUDdMqFfGyH74Oz7v3ZeykvH7ipKBnyMV5FzBte11txKI+BqFzephHG/iGHaNYfVLcXROvbp7iI92ZoWyziSoNpwo8bYT/tn4TS29KmS7rJZ4iLvqcfWElJFVtL728BXWtJus/p1vnlyZE4uis8vJpBBMGu0emH5aEgpbk7Pxmbvwc9bPR+EEwztOBjFGEFHCqsEFlCtIX3cvACPdHTGm9CchbW6d4KQWKe11RLE5RuX0lEcidDe5bEPc9ZZjkJOcmGnmQvw7Ab4jCmioKulfVPuUenaunkSHNKW4GuBea5FYf+KyUJdUj7z4fX2expJaKDk+oQhoaKBzRY9iNzKXf2DF3sztkbphrecpOwUDWgziXMkk+ZughI7/aZBaccVlwwyKMeyDGWAWwhk+BJP4rg9wz/LFA5sl3SllMLEJ8cjfrSHxovtPI0zkcli414D44KnBnmf/kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Utilize per-vma locks to stabilize vma after lookup without taking
mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
contended, we fall back to mmap_lock but take it only momentarily
to lock the vma and release the mmap_lock. In a very unlikely case
of vm_refcnt overflow, this fall back path will fail and ioctl is
done under mmap_lock protection.

This change is designed to reduce mmap_lock contention and prevent
PROCMAP_QUERY ioctl calls from blocking address space updates.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SeongJae Park <sj@kernel.org>
---
 fs/proc/task_mmu.c | 103 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 18 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c0968d293b61..e64cf40ce9c4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,6 +132,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
+{
+	lock_ctx->locked_vma = NULL;
+	lock_ctx->mmap_locked = false;
+}
+
 static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
 	if (lock_ctx->locked_vma) {
@@ -157,8 +163,7 @@ static inline bool lock_vma_range(struct seq_file *m,
 		lock_ctx->mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		lock_ctx->locked_vma = NULL;
-		lock_ctx->mmap_locked = false;
+		reset_lock_ctx(lock_ctx);
 	}
 
 	return true;
@@ -522,28 +527,90 @@ static int pid_maps_open(struct inode *inode, struct file *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct mm_struct *mm)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 {
-	return mmap_read_lock_killable(mm);
+	reset_lock_ctx(lock_ctx);
+
+	return 0;
 }
 
-static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
 {
-	mmap_read_unlock(mm);
+	if (lock_ctx->mmap_locked) {
+		mmap_read_unlock(lock_ctx->mm);
+		lock_ctx->mmap_locked = false;
+	} else {
+		unlock_ctx_vma(lock_ctx);
+	}
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
+{
+	struct mm_struct *mm = lock_ctx->mm;
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	if (lock_ctx->mmap_locked)
+		return find_vma(mm, addr);
+
+	/* Unlock previously locked VMA and find the next one under RCU */
+	unlock_ctx_vma(lock_ctx);
+	rcu_read_lock();
+	vma_iter_init(&vmi, mm, addr);
+	vma = lock_next_vma(mm, &vmi, addr);
+	rcu_read_unlock();
+
+	if (!vma)
+		return NULL;
+
+	if (!IS_ERR(vma)) {
+		lock_ctx->locked_vma = vma;
+		return vma;
+	}
+
+	if (PTR_ERR(vma) == -EAGAIN) {
+		/* Fallback to mmap_lock on vma->vm_refcnt overflow */
+		mmap_read_lock(mm);
+		vma = find_vma(mm, addr);
+		lock_ctx->mmap_locked = true;
+	}
+
+	return vma;
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+#else /* CONFIG_PER_VMA_LOCK */
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
+{
+	return mmap_read_lock_killable(lock_ctx->mm);
+}
+
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
+{
+	mmap_read_unlock(lock_ctx->mm);
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
 {
-	return find_vma(mm, addr);
+	return find_vma(lock_ctx->mm, addr);
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
+#endif  /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *lock_ctx,
 						 unsigned long addr, u32 flags)
 {
 	struct vm_area_struct *vma;
 
 next_vma:
-	vma = query_vma_find_by_addr(mm, addr);
+	vma = query_vma_find_by_addr(lock_ctx, addr);
+	if (IS_ERR(vma))
+		return vma;
+
 	if (!vma)
 		goto no_vma;
 
@@ -584,11 +651,11 @@ static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
 	return ERR_PTR(-ENOENT);
 }
 
-static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
+static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 {
+	struct proc_maps_locking_ctx lock_ctx = { .mm = mm };
 	struct procmap_query karg;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
 	const char *name = NULL;
 	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
@@ -615,17 +682,16 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(mm);
+	err = query_vma_setup(&lock_ctx);
 	if (err) {
 		mmput(mm);
 		return err;
 	}
 
-	vma = query_matching_vma(mm, karg.query_addr, karg.query_flags);
+	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
 		vma = NULL;
@@ -710,7 +776,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -730,7 +796,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
@@ -743,7 +809,8 @@ static long procfs_procmap_ioctl(struct file *file, unsigned int cmd, unsigned l
 
 	switch (cmd) {
 	case PROCMAP_QUERY:
-		return do_procmap_query(priv, (void __user *)arg);
+		/* priv->lock_ctx.mm is set during file open operation */
+		return do_procmap_query(priv->lock_ctx.mm, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.50.1.703.g449372360f-goog


