Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55386C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBFF6B00A4; Mon,  4 Aug 2025 19:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957466B00A6; Mon,  4 Aug 2025 19:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B336B00A5; Mon,  4 Aug 2025 19:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72F166B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:16:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C5C81DD6CA
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:16:03 +0000 (UTC)
X-FDA: 83740635006.07.22A2A85
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 46FD41C0006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:16:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fOEOCbtC;
	spf=pass (imf20.hostedemail.com: domain of 3MD-RaAYKCD8tvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3MD-RaAYKCD8tvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LLlVoqHDMFMIDh4+31o+ONV2fLHn7v9sHgdKTjexS4=;
	b=oh9a1F0gNaMCKafpqoIfQnFysK7rBxwUzFLQvnokefDYw8p57ErYEDmqxpPLTbu57+PZtO
	RTUieX/Yc/2x5c5e9RVC7DyUFCNCvKtd4KyZjrREfno7QvPsqMPQmXRgUrRsubDFmoqvsJ
	f4xxK9A4l5gfkvqRbTom5bjsx0Jl6JI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349361; a=rsa-sha256;
	cv=none;
	b=j0VSFCoVa3gJTl9n29+SaSU3lPVEF7FCHJoE2ybROTnjkLi+EFoEpwxaKIPJtPljUHdcw9
	EcVAOn3QRo4gieB0dVrPWlETua6msjlPgwNNtEPX16NEei0pqhMFAHHIu8of3edvAoSTBc
	4GAeQ2EMij+4C5RPkpoze9rsWIk93QE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fOEOCbtC;
	spf=pass (imf20.hostedemail.com: domain of 3MD-RaAYKCD8tvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3MD-RaAYKCD8tvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24004ac2ecdso68343435ad.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754349360; x=1754954160; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7LLlVoqHDMFMIDh4+31o+ONV2fLHn7v9sHgdKTjexS4=;
        b=fOEOCbtC1RsK9RrrpjCf6yoSX/ECLuB/V8P9zE53DLNh+SQCYGftIcZyLGoR1spyDj
         5APyV0TL2Nm2U/WYKIzyw7KL0cGLcyzOGBWIZ+cqlLT1hf9Gsoqm7V+Bj8R5YZKqtStL
         PlVEQXY1UdZxvVlGtLfKF2VUGuTEC7UgBOPMGDA/zVcrXIjQtMwzvB8y6SGPeeACIzxL
         Ze5J7RVhUzQf2zIE5ELap8uwYuvzWRSdQf2IT7qZwaJJWkM1QmqaLGtOUD1Y81bs/Xi7
         Vgn0MrxBLksCN3tmCvNCEZrLEMMyFU3hgfAq8ZczRaJ+qJX3wLsVb0Z2Ny4NwoJnnE9P
         fl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349360; x=1754954160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LLlVoqHDMFMIDh4+31o+ONV2fLHn7v9sHgdKTjexS4=;
        b=GyBzc4w+t2iFyGYIN7YtIHkWWPhWIlCznvnrE9kjF1/Khjt/IMCib8IDNnwqSX5/Tr
         D3+ZE3Nx938DXTNVI5PPwyIY4XrTWV+tFf3+fhhI6D/lpzKwAjhq4ULijA2kDWnuBieL
         kzgqseYmOFLpH6XcUwJ4tJLdPXDO4ZLHr2ercfV8tK7qHgeU4glO3ZCIIWaPF6sGf0SU
         irLBOELnLb7Q9d5WHPDoBelS62dBpQPUxx/zNxO08HD4ngJVn8VRTXdqhT50pEcUY+6k
         7xhRhWixuRCMgyfx6ZOoc9j3bRm+9vAjaeGknnl4xOLaU9WxT8DpUquajaDtaPrp+QYk
         nEAg==
X-Forwarded-Encrypted: i=1; AJvYcCUStzNKOAl3lKt+kHOP580EHMIN7LnhykCqjadgSIQbMwG0PRdQltEUZdbu2ZuYNvHpMS3vZm54fQ==@kvack.org
X-Gm-Message-State: AOJu0YwkDf6IBU5hfG7Y925Vz4DFAAEjikwuEBHoP8S8ZwT5Vmu9AMYL
	bbCAxtkaHCMvLRUJ/F7LU9XhALAh4PMeBpTH1Ivh7Tpitq6IixdE76jA84Xj9SMsQG7a5S7Iq7Q
	31w+pgQ==
X-Google-Smtp-Source: AGHT+IF/QZzIgmBa6VwolABoKQDtTpPz3bEroyjsnVJNVCeHAjwJivrabr8q4l1Lq6BpaMaysvV3u9CBYtw=
X-Received: from plcx13.prod.google.com ([2002:a17:903:cd:b0:240:1be2:19ee])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec4:b0:240:48f4:40d5
 with SMTP id d9443c01a7336-24247023e9cmr137793735ad.39.1754349360090; Mon, 04
 Aug 2025 16:16:00 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:15:50 -0700
In-Reply-To: <20250804231552.1217132-1-surenb@google.com>
Mime-Version: 1.0
References: <20250804231552.1217132-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804231552.1217132-3-surenb@google.com>
Subject: [PATCH v2 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
 used by PROCMAP_QUERY
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
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 46FD41C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: us3okmuhkojwyz81qnphh5ntno91titz
X-HE-Tag: 1754349361-100003
X-HE-Meta: U2FsdGVkX1/9oDKmSiBVug834mKicNH8jEBf8XHI9TCxFXHkDtHrieY9pTHJr3I3PR5RtP6UHxmNkzt0LvlqLLaBMNIfrDFdbj/NQayupGqIetsga29uEzqw2hk5aa7e9rBmdX/rDJ6DCTuPYuekYct+V8RS3dIvBazDji3iRjQzvHp7FgMxVyt9P5GQ1oyMHMaePasA7eo8fGKgKBK7XN/m01ew8yYM3hCkif/1pgDbiv46rR0tfhWqkeKHYzSiqdoi5GzvLbJ5nAn/vxH2L0tipR9JbCwDiWqxZCRehrqDbRhTJ+f4131cdQyVvWYxeSnduGe/Q7XokCxxK77OP/duwpK7wdiMZUNz5QBcpI3KHJhC8LjwVSCxrBUs8+tEqZqIYUyO+YiuD7JhJgl7H3/M8q8XNv8qslEUcrVWA7bdpE4Bh6KOffbbeQYpPQcy2dJykXN605fyQ/LzhA56UcKvevN3fqBpFE9wvscTDx/MSqXtKnVEqDXUFzbKRoX61O4GyqczepwdZCyT4GsSmY1T/f41VohZlpQy5an3YDnFvVaiEdBIiaNeYkQPKUbfrCL9UDnhjmvS0or46Xl7XM7hbB2nX4OV+tIweKXKR29p6dae3XNL9ShFS45awdrUEAuf2hvE+ufMMMxZOpwG+VitS06tuPRQkXuOLWobCWvTCuBzmBljeoS5wmap23Jq5v4D+APl4ISMsvykpO8Z9Ipyb9GgTIZGpvlW9n97wqvmr5z1BPLuJg3A2gMLc0lI+FHtng3bOSM7tnx7uWebWjOD+EZE3VbmQBUhVfc+run4I6j66rZm1o0n8XD32GGhZpvQzrQqb//Qc+uZE4fMQcDObAcUIFUC1V5xgDU8QE0T2CSxay1VKFmgMWlwhV06HXdAFlyfnF2UHu6HT/Z1VAbm9ieRVC60U/7BtjjQnqSJy3jjhsf1WXUHnJre6MsxtYaK1CU3iwERyf8xpwE
 V6h05MjO
 uhz2Qp77xayFk9hXBLzHh/goD/vrcMVwzncC5CW+Mh7/m2YHWQXMRx2nBVjhbTRkdfnMEGpAH2IWT8OIiEgQd6DTUPS4cFaaJscAekvOOOu10bx3mkRFKctdmouzmsmjxjRohHm03MQ7y0K4XGQPj3AgJZk6SWeJ5YPI+NICb+sIs4qSwnBNWyUol3TZ+lwVyTJi/q5c3A+3viIJaEiiOP1Mvr5ixmhITICv0wFxqI8JmbKStlDsNfL0NcN6GAmzTZU22IlQA9gYJ4vussw+GDgPhppgIIYYOmyXCnlbs0c0BuY/4zVCNmYRv1jp63CUeJIQiJl2Vt5OH5AdGtj4+07Evh8x7JsNF+FPJyF+w0pk814DMVuBdv5QvuTXi53sX4L292f5FEJ/Q/lnnJplX9lq1L/iVIYdZLK2piAcwHy6GCk5NqgmSRg1E9UsB+FFMNQ8jhNhcN2j3qEZVByfISbO6QjKG47ncK+xsAAH7Tzqpdx5OT9XHSlHdHYHRE7JXLJkqxHddOqFGYrUVJtcSjLZ/9hCB0tHSmcelgh5DI+zXGLVkWCSJ0UyAybKCHrwSFQ/orOZsYWr1EEZEverKQYyw9Yph5Ham4ASgJIK9VhEPqd1HGwc5rH1Ynw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
ioctl are moved into a separate structure. In the next patch this allows
ioctl to reuse some of the functions used for reading /proc/pid/maps
without using file->private_data. This prevents concurrent modification
of file->private_data members by ioctl and /proc/pid/maps readers.

The change is pure code refactoring and has no functional changes.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/internal.h   | 15 ++++++----
 fs/proc/task_mmu.c   | 70 ++++++++++++++++++++++----------------------
 fs/proc/task_nommu.c | 14 ++++-----
 3 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 7c235451c5ea..663dc0510315 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -379,16 +379,21 @@ extern void proc_self_init(void);
  * task_[no]mmu.c
  */
 struct mem_size_stats;
-struct proc_maps_private {
-	struct inode *inode;
-	struct task_struct *task;
+
+struct proc_maps_locking_ctx {
 	struct mm_struct *mm;
-	struct vma_iterator iter;
-	loff_t last_pos;
 #ifdef CONFIG_PER_VMA_LOCK
 	bool mmap_locked;
 	struct vm_area_struct *locked_vma;
 #endif
+};
+
+struct proc_maps_private {
+	struct inode *inode;
+	struct task_struct *task;
+	struct vma_iterator iter;
+	loff_t last_pos;
+	struct proc_maps_locking_ctx lock_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3d6d8a9f13fc..843577aa7a32 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,11 +132,11 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
-static void unlock_vma(struct proc_maps_private *priv)
+static void unlock_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
-	if (priv->locked_vma) {
-		vma_end_read(priv->locked_vma);
-		priv->locked_vma = NULL;
+	if (lock_ctx->locked_vma) {
+		vma_end_read(lock_ctx->locked_vma);
+		lock_ctx->locked_vma = NULL;
 	}
 }
 
@@ -151,14 +151,14 @@ static inline bool lock_vma_range(struct seq_file *m,
 	 * walking the vma tree under rcu read protection.
 	 */
 	if (m->op != &proc_pid_maps_op) {
-		if (mmap_read_lock_killable(priv->mm))
+		if (mmap_read_lock_killable(priv->lock_ctx.mm))
 			return false;
 
-		priv->mmap_locked = true;
+		priv->lock_ctx.mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		priv->locked_vma = NULL;
-		priv->mmap_locked = false;
+		priv->lock_ctx.locked_vma = NULL;
+		priv->lock_ctx.mmap_locked = false;
 	}
 
 	return true;
@@ -166,10 +166,10 @@ static inline bool lock_vma_range(struct seq_file *m,
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	if (priv->mmap_locked) {
-		mmap_read_unlock(priv->mm);
+	if (priv->lock_ctx.mmap_locked) {
+		mmap_read_unlock(priv->lock_ctx.mm);
 	} else {
-		unlock_vma(priv);
+		unlock_vma(&priv->lock_ctx);
 		rcu_read_unlock();
 	}
 }
@@ -179,13 +179,13 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 {
 	struct vm_area_struct *vma;
 
-	if (priv->mmap_locked)
+	if (priv->lock_ctx.mmap_locked)
 		return vma_next(&priv->iter);
 
-	unlock_vma(priv);
-	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
+	unlock_vma(&priv->lock_ctx);
+	vma = lock_next_vma(priv->lock_ctx.mm, &priv->iter, last_pos);
 	if (!IS_ERR_OR_NULL(vma))
-		priv->locked_vma = vma;
+		priv->lock_ctx.locked_vma = vma;
 
 	return vma;
 }
@@ -193,14 +193,14 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 					 loff_t pos)
 {
-	if (priv->mmap_locked)
+	if (priv->lock_ctx.mmap_locked)
 		return false;
 
 	rcu_read_unlock();
-	mmap_read_lock(priv->mm);
+	mmap_read_lock(priv->lock_ctx.mm);
 	/* Reinitialize the iterator after taking mmap_lock */
 	vma_iter_set(&priv->iter, pos);
-	priv->mmap_locked = true;
+	priv->lock_ctx.mmap_locked = true;
 
 	return true;
 }
@@ -210,12 +210,12 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 static inline bool lock_vma_range(struct seq_file *m,
 				  struct proc_maps_private *priv)
 {
-	return mmap_read_lock_killable(priv->mm) == 0;
+	return mmap_read_lock_killable(priv->lock_ctx.mm) == 0;
 }
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	mmap_read_unlock(priv->mm);
+	mmap_read_unlock(priv->lock_ctx.mm);
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -258,7 +258,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		*ppos = vma->vm_end;
 	} else {
 		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->mm);
+		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -278,7 +278,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -318,7 +318,7 @@ static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 
 	if (!priv->task)
 		return;
@@ -339,9 +339,9 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
+		int err = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -355,8 +355,8 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	return seq_release_private(inode, file);
 }
@@ -610,7 +610,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
@@ -1307,7 +1307,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
@@ -1452,9 +1452,9 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
 		goto out_free;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
+		ret = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
 
 		single_release(inode, file);
 		goto out_free;
@@ -1472,8 +1472,8 @@ static int smaps_rollup_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	kfree(priv);
 	return single_release(inode, file);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 59bfd61d653a..d362919f4f68 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -204,7 +204,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -226,7 +226,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 
 	if (!priv->task)
 		return;
@@ -259,9 +259,9 @@ static int maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
+		int err = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -276,8 +276,8 @@ static int map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	return seq_release_private(inode, file);
 }
-- 
2.50.1.565.gc32cd1483b-goog


