Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169AAC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245136B00A4; Fri, 11 Sep 2026 15:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8CD6B00A5; Fri, 11 Sep 2026 15:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0705D6B00A6; Fri, 11 Sep 2026 15:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBB936B00A4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:41:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A55C80341
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:54 +0000 (UTC)
X-FDA: 85202501748.21.B5BA170
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id 90D7E100003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M8wWB6Cg;
	spf=pass (imf05.hostedemail.com: domain of 3f1mkagYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3f1mkagYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155712;
	b=c/hh7Oe7d8QFGxMdYJAl9fm0Yl0eNhDepvW8VZ6oWnrHmwctAIj5VYpP57OqHrnHxlJLOl
	/V3qeJy1DAXqkPMS/yEwtEVEOKQD7ddvbDIW5JY4OHk6puKP0kl8QZMzlDSfO9NSlJy4dI
	0BGxBh4wF5n1WV/3EFD+6c4N/yaTokA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M8wWB6Cg;
	spf=pass (imf05.hostedemail.com: domain of 3f1mkagYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3f1mkagYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
	b=QVgI/DER9sbNQpQgJ9fiulS9JBmJqQO+spZNXeRsEcRMl29qwyV1rwOS5PjqdLlNFwyLBI
	L34NACCZhvAlCCPOha/EQNNQAVTVKVpy8VB/vFJMeVo3RdXMZz9Rj3niAMCsxWmrYTJbzv
	z5+WSsi3aTM1iUmuZ5gBN23kCLPVvPc=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-396b9ef3070so2186694a91.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155711; x=1789760511; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
        b=M8wWB6CgyssV9AArfkLzrW1pmPePNjUmx0U06TI2IO3hKjCK66kUVxRZtTT54yYsrz
         R3EHno6Lr+L4f7d2pFjmoDIGEi6R33eZ66+DGEEfoXrSYC3K5wDhKtlVc6kpbKtx9kC6
         IGLkwTG8aJ5rhlD4Y2fipBEgvQmAdNlxvKjqT0Xy8/qrZQw6L4lBSk0rQUtrI7+KFU+M
         C7/Wom6OemqGGqG+yNyULwiqHx66Xnjwir15X3PARadGpF8yygW7L7X3kUas9pxZtJBk
         U6zEG/U7ohZ825AzSHElNX8/5+VZXFUl4SNDT7mJRsoiSECYuLo2ujF78HG+Jc49hJ3c
         FWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155711; x=1789760511;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
        b=eJNm/PgZFux5Fju0fPTeh3ggCZouldbMAtR9gilNZn9QSB3o+bLnvaNvTU5+1Z/OQw
         YuOOH4h/vfav7yOedcbK4xS8I4phRnKpzND1P706GYbe/qW2fD7TKQl0uz8zGpj6JyD6
         4cVOyC0OjevC0BKSR89fl5/Tm2x/1naSqkr42n9fgI0RMzRfpsLcu6rEwGqZZLgJmC27
         uOlGhtq1acoMgdtQXjIvKpzfDwJWDFUIMQ7POBEAy7T42H3oaeMuqJc7QzmYXLUcTiE1
         TiKZWBrj+bDe7gTSkEWJG+7C0RchMEv356Rm6eF9UQrngZdXdyYCSuaOW44yCtisy8ZM
         LUfA==
X-Forwarded-Encrypted: i=1; AKwUvBwj/HFgQogQbQtxd2WWrCIHQmH9wgAEfsm/lJ9EirSRRKTlrWkNz+DrO1M7wXxrxCnpwJ9qbJO3jg==@kvack.org
X-Gm-Message-State: AFuF++loQ7basQjm2t4gjRFcJq9pzArtoGSin92ZWqSLHHOqegSfkqSt
	bc+7in2bDnlPPbgDb8iRhuV+xTQiXVC8dvs3yiqs/URORNR2tyHMGioVYmje1VqCt6CS0f0rQGb
	G4ZHaRQ==
X-Received: from dlbrj7.prod.google.com ([2002:a05:7022:f407:b0:143:5fe6:4e1a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5246:b0:398:d2a0:87ff
 with SMTP id 98e67ed59e1d1-39d9bc67660mr10045684a91.1.1789155711065; Fri, 11
 Sep 2026 12:41:51 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:39 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-2-surenb@google.com>
Subject: [PATCH v4 1/7] proc/task_mmu: remove unnecessary helpers
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90D7E100003
X-Stat-Signature: 6n9k5uhf4ci3ap6gopfm8xu8nojugdgu
X-Rspam-User: 
X-HE-Tag: 1789155712-892433
X-HE-Meta: U2FsdGVkX19MoZoXFKZiNm23aVDyyMZsTHW5hn+3IKQ8lL687scdpbuI3XtPJslI/d7OOA1jJGKNAntLVGogT3pOGk3kvBuTO1SS6e+oJZxX+Mq/x20E1c6Xr9v1ztZx6EGuHK6IGQghPiXMjS0Dw6s37XNM/dtlGNPle34jmHNA7ciEFT0/Up6CJ4mcxyerW/AShY+xg5s2zU2atbWQtYw1xq3hP0HP0vVLtPYMR8S2dzOeDGll++w07WbykU7VNO3IJQNehHLqICYUk7NkhzT/GLqSByiHu9zk27nBqmTGLCi4f8PNQE0ALbRKJfP/GA62fjOXDDYe99WyeOSoopahbdfylbVpN5BmCaxfOg42KzHS2KNftTDTLCTltNEPTCEg+oUpBrBxBeJpkVPbIkMYV819aZSnw+b4nYSFQQYoLFY78ayNvjFkUt02l7LN8mucczskV774TMfHhCBBhYyqSvB8OXGVqovrtLjTbjkf4h0rC6DDbC7KdfcZba6gsyYwACKxUBLtu+mjGWV12pT3R/iPmdwLnJzc96v3qN0sI06V1WiJ7HnqzTp2UGJ2N+QBacUbnKEchUABUsOM4HfNlSgHijIh7cOhc4H5ENDlHnBVf0RGFNToFTDq/dMr2cRdflbMiYu2/MojfaxKRCCpftCu5IN/UgmaHUFk7M4fduaFClVMkI1J1e1XfvHbCdkgQ5VyYAXCdK5gGdutCWTl02oHvu47c2qlgeMH43EyzjWlZs1gaFseSdCXkUnK0c/okEqYiccoCEOtmLvUDKJiUY5uSF9djqc051zpe9NdyBDXLinrcvDRkzLZ4Mfknr/plPMPEnU2bRt8hWIYclgyDSZ9XK64Ahl9MnP3zFr8yaBIb0pKjR+cH6qMsli6JbVvFhXFHBwgQuKYemx938kyzrbqew3n1ng07ftSpWFqHZfkbLkxbTzdY9zYNfnes7svXCnVyJhB/ZhM3GV
 1Bbj1JT9
 Q+pYJTSOdltaEkv3oJn5pFSSUPdlm6pw5IvFS7niH9Q/hi033hgBaaPrUCqxBiflGqlyS4Lpl7Y/YagfuVCp0ucKGvAjLDQpQcveEOuHOBuX/cHiYWV3j+08btcrLjH4Zb95VBnIpTUNvAP+Hl2p4eUMZKURRanYkjOPmb7V8WAoep1fTiQo8d6iY/S4e4FUlkFaw0r57NrQaWjhLzflvGMGO9vnlIInLYwsDKuq+n75jCigW2YnNleshpangYn+Xt4F9nw38tQpNNf/rbTP97ouvDdJmDQBL3a3NI4rEt9GtEgMrTny+BJ83nk9qfxc0l9A8pCTGStSQGP7Ol6EW6FE8QpEzMbL1MtELrLpxTnHJRM3K5/aHEEf+NCLSwqQOkfFvXw5ibuHinYtI6E8ywMUGHU0+YFg7bqSwRQmMmjz/CBMYwOZd4hQKVGGUebIhm3yHEUUiMApFHQ7KEG/7Ko/sIzGvMy3HXkz2J9aGy2PBVIayf4r3wWpG9z+jIsYehAm9cuqdSnVE6yGTP248ntgPWSbiDSvXJY+cW9FkvBbjMSkDhWPDUD0jWPXG0Q6/xkx64QszgByE3bxZOarxyCjT2MMvpTLobH+ZBe/6JP1OhhoZ/tEz7sizWqC2fBjLNcLuU9RrR2o6on2ReHXqM66WGIlhmRxE+r7EXF4csLl2NME4pEI+uDl0rs6N01w/53nCp3CNhIYZBLDTo9/V/6Fq9XezFMGll0VBZgZFqouh5rfcj0QmQ8V/Ng==
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
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
2.55.0.1007.g17ff1f9808-goog


