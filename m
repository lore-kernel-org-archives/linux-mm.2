Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9EADC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E57D6B00A1; Mon,  7 Sep 2026 02:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD756B00A3; Mon,  7 Sep 2026 02:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1374F6B00A4; Mon,  7 Sep 2026 02:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D60FB6B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52A431A0675
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:27 +0000 (UTC)
X-FDA: 85186014774.23.4B0C04A
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F3D980003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jMYOtx/t";
	spf=pass (imf30.hostedemail.com: domain of 3HFyeagYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3HFyeagYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763165;
	b=w00fawY5iCvDPi8bMHdiLAqZVh3smrna+hc9M8A6vus3m+Q0wz4lvCcePXx0bggcUrYCIE
	uwNjEacP+hyaBJCZVI9Xq12bQ3xQ1ZVnHjbKurDA5s/ct8NKBr+XTglobvBOSz4YvRru6v
	+Qg38MhsgMMd95ic6PphnrHRcAMjLy0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jMYOtx/t";
	spf=pass (imf30.hostedemail.com: domain of 3HFyeagYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3HFyeagYKCKkbdaNWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4B0N/rPIgypiVNXAn0XPbbBc+Skfopg6i5mY1KeQYA=;
	b=FdnQSfcXhbnlz9WLFLpVMQwalXkiwH5ivuPNRbxno47CLNFMGhJBAGN+eY86fqFn6rAbcr
	gm8WJA/ZcMYEXpgZKoucgT6nskVIP6M6oQdc0sT0dOmudPNFbSXfSTILvk4cMbCdQsL5UX
	fHXy7bCLfdTihYxWqxAWcErMkJ5HnAs=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb835525b10so4004435a12.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763164; x=1789367964; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4B0N/rPIgypiVNXAn0XPbbBc+Skfopg6i5mY1KeQYA=;
        b=jMYOtx/tGpuvot+CHhRQ8y3Q01GHfZVVfLiBpsac+O8KjGupyIDSQHb2hypyO2aAje
         b18kUeID2ZvQz3t05Fd3Hoorrrz3AcduY9QZqBLKDxbiDi3ebtIOBjDMgfyZbRzZMarx
         mCh1O6UYvxeW5ysjkLAeDomLaiu5uSxQN2j3AbXI4uEhkJ5jyKUUWuRKC/EyHet8tMLa
         pCXn6EKTlF1fRR0FwIVfNWpzRc1BmxQAEupKUZMWZknsot88lrPE7kcHoFvw3KPGKT+Y
         lB29kJg4lqolh2vFg50fQD5rsJd9bFkbKobyg7XGH8vheJbHVQ/etvvurqWV+ARZzr9k
         BNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763164; x=1789367964;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4B0N/rPIgypiVNXAn0XPbbBc+Skfopg6i5mY1KeQYA=;
        b=J/JORxE3MupyFU///FsgXvEDS/ay//hBU3HeEY2qE4ubA72vAQOLztehPmZVI19kD4
         ODpNkha0MnUrNnLxWIA7sNn2bbM/Vk6GiH++v4g8YJ07RPQNv1tJXU0PlxDbvnPThsBe
         hWXUoEu8JOyrt9RID9Wsqsy2LCAD3F1hvlfkjBPwi5CRoPKxXuYM52GLjHMk9N+zqQMM
         iLsvithU4TMvtCk7m2R49osZkxi9IMWkYMlpvymeLA7iwU74eCwSeTaI4eMksUugRfHG
         be/ed62wKtnZ57L18Ra6a4xvbjqhVP5lOFsH42P3Sg9jq8xOXeirP03ITR+Qup29B3N3
         OS2g==
X-Forwarded-Encrypted: i=1; AKwUvBzEGsG34d20WZXW2xxUywUfWXrrHkYWFN9vNf1qfODDda4JyF1SadN/h2CsIHXLp1vNX+8nbqTxag==@kvack.org
X-Gm-Message-State: AFuF++nUNFD6ycSWM7nUCXy0rmlWB/0yu2knY1zF7hiLlDsvKnjcSWuw
	g1VRz2OJGKvPUFNPn7+yA+80TcNJ4ne8R5Tvuvg4iilVRuXFQzjexLJaa2kRflGMb/4QP1hcDey
	kk9q2gw==
X-Received: from dlbro6.prod.google.com ([2002:a05:7022:1586:b0:141:ac8:b5ae])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca8:b0:3c4:46ca:334b
 with SMTP id adf61e73a8af0-3da39cf4744mr31781029637.9.1788763164089; Sun, 06
 Sep 2026 23:39:24 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:14 -0700
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
Mime-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-2-surenb@google.com>
Subject: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: n3xureeyggwpxuw9wtfeuxkn875taguj
X-Rspamd-Queue-Id: 8F3D980003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788763165-842150
X-HE-Meta: U2FsdGVkX1+D2De3Qk5Lej1JbL26hAfeWSOiXw/VO7HzSbTqutEV+Lzau260aBJILHHfv9zTRz52/I45/zo/mreuMS9VzZsmIpqVTgDXWMsz5G7qU5CMdvxDZZsaANW1zQJld4vkZEoeBgk0DN6BJ0hW6iTVKKha6aY1v3pGO/3ROVDbpk9noqbQOnSF5JrH/5/OKktnTQ4/aFnl8L82D+XNir2kMBmM1wfLK9ZKf3MX8JJGvC69WafB7FKbQ0hvAKNnadS/OwiJBvi+nBEMruM8UpfnH/Rrj2r1sAxKuGBOuzHRxz5BPzf4VqmMuVI/jh0ED2xd2d55Bu7TRgdzS36CcguXvzEWaLZ96NAqOXD50gsKPeQ3scuhjsTYhDQqGttuOWil5Uk83mN/lzAPwc+m7SpB9wUsOAN0G3YnmPUjFZpPMkejLTa/mCwM+j9BJ06IHhFoT1Z7UTcD3jnxDJJGEntwmZmhei13Gx8m8UWoK2PISdNAKxsMBKXabsxQoYt2Y5ps0XWxo9hnz1X1JNUCQJt/0KrHuSUUu4URFVLBxW87AGdhxf2IYOfA9Wo5F86Ni5BUPeSi94Mh0JRIVPmwNsiYYjvhQuYgSkcR9sKQivgbzMBkvu3GknuGcrox+v9mm3uTPwhsgaq2l8OINE9GWkup/XCsTUd/Jek+eKIzPxz9AL+o0vFRa1LoSCjNip52z3DCI8gHuf7huvrZYvVqKrd2xgAvJwFGDGZEksToLkfmi1QVL3H/tYdTI7qCB0vm8wR87P5+DAafxKnPAbAw50Vouia7e1wqV+hZGFAP1T6/fth2wijNy8MMdVePdzwhwb++qcz+tCRhELPGGvr0mBD7c6z3gSP3Nm9Zd/iFmODz9GGWNXg5d/pWGq7RuS6DQVLKnbuWndJX7DvxrYS5woNZnPCcuEyxeSH+qJiqifZVF0CQK0b2uAdqN0nO7eklGjIEMFHwXGUOiOL
 QwnWHZI/
 ds3OD0KcavE9rvZJaK0KItdEnUvtomnq3HqeW52myHCST+ai6/dpBOHDDD5CXj7t3BaU+2hbJkYnXBhy2HmvRvt5uvBuDa8l8a7PAmRQmV45nk+9wCgCvTKT7W0fo99iH/tTl8N7YSekkU6ZxSdGIfla1lVXe05cNbB4M8JPgI2dEoSJ7iSjBnfZTzJ5Nev7FP+sWZvTNBqNYhJSXLFJuWMMd6VFQFOGsAWkqz9QI5UcyW+VdJgtCh9HKvBu6Huf4wSO+a0Ltfdp7O+LjcR9y/OzzkZI/E5rjhgcVrqED5R/deRNxypiPi9padAWqHJKd+HvNBuJBPI9+4XtCe6MtGyCDSfS8BOxvmg2LvR7mC2RFEyoEa2xHr7MLLs66xwCQxsZ+Rr1fYUVT6fwGiv8XcJp7OxOsHOGljwS0YeWBe8C7AF/OFNQSkCwH/1Q4K/0c2VO1Io8MURf+VH1SGOlPraFTbnCU4CtC5zFlusFYjlHVdpFThR6j9yj0hoN4wfxNiFY5xcNorlEPCfQEf+HeOrEK8ZN6zFN6mzFVPLJdjtwy5+1gzCBHgxTQpWJzgNecXDEqO72qK/UPIkdAkHayWcTlbPGMRt+2zxu7YV+hwc4pLISiLPTbbOz4tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When per-vma locks were behind a config option, a number of helper
functions were needed to simplify the locking code. Now that these
locks are universally available, we can do a little cleanup.
Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
query_vma_teardown() helpers.

No functional change intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 67 ++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 50 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8ded..2f500d639db5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -160,25 +160,6 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 	}
 }
 
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
-{
-	rcu_read_lock();
-	reset_lock_ctx(lock_ctx);
-
-	return true;
-}
-
-static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked) {
-		unlock_ctx_mm(lock_ctx);
-	} else {
-		unlock_ctx_vma(lock_ctx);
-		rcu_read_unlock();
-	}
-}
-
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
@@ -286,13 +267,8 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 		return NULL;
 	}
 
-	if (!lock_vma_range(m, lock_ctx)) {
-		mmput(mm);
-		put_task_struct(priv->task);
-		priv->task = NULL;
-		return ERR_PTR(-EINTR);
-	}
-
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 	/*
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
@@ -325,7 +301,12 @@ static void m_stop(struct seq_file *m, void *v)
 		return;
 
 	release_task_mempolicy(priv);
-	unlock_vma_range(&priv->lock_ctx);
+	if (priv->lock_ctx.mmap_locked) {
+		unlock_ctx_mm(&priv->lock_ctx);
+	} else {
+		unlock_ctx_vma(&priv->lock_ctx);
+		rcu_read_unlock();
+	}
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -518,21 +499,6 @@ static int pid_maps_open(struct inode *inode, struct file *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
-{
-	reset_lock_ctx(lock_ctx);
-
-	return 0;
-}
-
-static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked)
-		unlock_ctx_mm(lock_ctx);
-	else
-		unlock_ctx_vma(lock_ctx);
-}
-
 static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
 						     unsigned long addr)
 {
@@ -653,12 +619,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(&lock_ctx);
-	if (err) {
-		mmput(mm);
-		return err;
-	}
-
+	reset_lock_ctx(&lock_ctx);
 	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
@@ -732,7 +693,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		vm_file = get_file(vma->vm_file);
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 
 	if (karg.build_id_size) {
@@ -773,7 +737,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 out_file:
 	if (vm_file)
-- 
2.55.0.979.g7e5102b832-goog


