Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E06C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586A06B00A5; Mon,  4 Aug 2025 19:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F4D6B00A6; Mon,  4 Aug 2025 19:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE426B00A7; Mon,  4 Aug 2025 19:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0DC6B00A5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:16:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF44013656F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:16:04 +0000 (UTC)
X-FDA: 83740635048.28.7C822C2
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44FDFC0010
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:16:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=znXCJXej;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Mj-RaAYKCEEvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Mj-RaAYKCEEvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349363; a=rsa-sha256;
	cv=none;
	b=1qEvuFn70EZIK0EuE7Cy2Zf/AVbw5TeAGgJt22y5SMCkNjIgsM643Q0+gmbjAIxn3TYfBv
	dMqOLdZfwCrwcQrux11oJJ0nfZO0LWkWcIJHcEBe1scQtLVIZ5keOs/ZrJBkM2UyRqE3gU
	t5w1uV+sfUj9bIOPSnqMGovuwzD2mdA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=znXCJXej;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Mj-RaAYKCEEvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Mj-RaAYKCEEvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nn/QlXxKr04lsk0BQprsWZ8fvAafoan6Kc4Ifd428WQ=;
	b=zvOay94UVBav7z7zp3rhWTHUlGmMAPjVzIxAYBxX2Z57dfa9zzqijtgBnD8nDsKKDQeolp
	VaBhMFe39bxoMgPh1xFXIrDBXPTHRl4dOWn/1w6tSnnxNK2Ion1gx0WkOlgMsrr4BMFXcB
	QSXSDUjMq058iuWDH+LbD5CKy6fJO6E=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bcd829ff1so3706191b3a.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754349362; x=1754954162; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nn/QlXxKr04lsk0BQprsWZ8fvAafoan6Kc4Ifd428WQ=;
        b=znXCJXejiIYWZjCS9YhMfEuuMHlmDruI8J34jKZ2OrEpYb1UayhNyQ5T/+ixvqfuPv
         jREWkuOaU1OcW+0FrTVCkLmR+zlpnhQMTns5xW6AVugQ9A3/hnAEGDmvU1cE8MpEwEgJ
         WZrUcW0zJQ2fjSMDYgo5GZfEZVLEChaMVzsH+2czmc5RMs5MAMPyYRjzDCzIjwUvNXxn
         khhoKcSSzSj7rEoKIBzlXA+lHQHO4V1LAKTnYIY07H6PTdoIhvqpZmGVYIXknP9Iv9Vx
         wbOquESHaQn12rSnG+tv21+dTiBmdZurpa9hvjto9uf5ByDoHRZN6dQXkGWRtqoL+ax/
         n+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349362; x=1754954162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nn/QlXxKr04lsk0BQprsWZ8fvAafoan6Kc4Ifd428WQ=;
        b=cJEoisxrSppc7ZADSDna8j0breO3gMc1ne6tkoW6yv+9B1kEyaAp1FCcWEo/eJ8U6f
         jmOc5ObXiGU1pmtVuXWVfr6pX1X6OlvU6un5ON+QtqqXjkr3JhmyN7lPIYupPxmVMqQ7
         JUQA2e1IkNO0S7AontvQh2cMa3yQ2+YJrBuaRRz0AmN87dNTp8Jw4zjG0efSWE+DNDEp
         iqZZZ/WS4y5a8puuqqeppjUFKjOK9gCpagF1ob9KadQheeT/BUTRV0hF/u6IPuSWVjlV
         cMithQejmYJ27Ad2n4SGv36vVtNF/3MGmUQsNHWc1w4O0khandkOdsp4HNfCYFPoYaEA
         LNHA==
X-Forwarded-Encrypted: i=1; AJvYcCXHUXo0e3LlFDyCFoC4J1ha719iKCSTDrUXF3jMACvJ6+aOlXZEB/4ZK/7cZyt8TOmR76Klz8mV6A==@kvack.org
X-Gm-Message-State: AOJu0YyuvboiBI+BcwgioUpFtyin5h0u5vdQFOQcSOMSRaPGgkSLyrNE
	cRxNnYs1OVA5TIylpNvH90BkvvZq/+GIqxAGyNm73b8Itd75O6LcY3HppqOhM5TM+mYpdOwXU+c
	6ucST2A==
X-Google-Smtp-Source: AGHT+IHSKj2r68iHuJ6mz0Uqid6yqFPSiOF1csXgv0QqUAcL3Sg9DHhAyqp/y83a4PMGePmffR52Td+bl/E=
X-Received: from pgnh8.prod.google.com ([2002:a63:3848:0:b0:b42:14da:59ac])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:244f:b0:240:d12:775c
 with SMTP id adf61e73a8af0-2400d12a143mr7876300637.36.1754349362131; Mon, 04
 Aug 2025 16:16:02 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:15:51 -0700
In-Reply-To: <20250804231552.1217132-1-surenb@google.com>
Mime-Version: 1.0
References: <20250804231552.1217132-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804231552.1217132-4-surenb@google.com>
Subject: [PATCH v2 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
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
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 44FDFC0010
X-Stat-Signature: d8dk6ikgpxdb4q3j5t1t5rnx3jqowr54
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754349363-77829
X-HE-Meta: U2FsdGVkX1/Vyo1HrcW4wOofm2MSwHegUkiGpzRyXHCPe63g0vSAghr8AHjDLMLUa9bzKiu/YLQGPk97Lwq6PjcaaLgFkh3QLmqogr0VJZIGfE/kvmcU9NiM8Ui45jluAl8MF84zJ35BzW1fe8ZYHXU4Bj257j99sa6dPMZ7a6eDyJFG2AOzuwrzrg/IbuL6P+smboyIBEkXUl6ZLntsQn+y0RXN6h2nE4Mt7EoLjKwfhcd08Fpngez2XoT5MlOC2mFPaTysfNTgd6s9kiHjLuCrhpZJeNjuxN38US1fwDQWVk9eZuRVfygexrUEiqcKPS9uSrFIE1OnWJxIMM4PYSUVWcs5QsNs1SmdFdvBwLm/Cm8nxaR05OV87KCz0sFuQMs7gQlTF6ecs09fjTgGn9MiBYv3SaiE+ShyAdOvlLdpdf87Ay24s+NHTrwJozP1yU+WCz4c7ijilsGfC1WnkRTfbn6UobVB6he7SkjmqSrd2U/hZd1adEmN9+B8rkYWW3EGeA1YOZ13NwMPvydYPFqA/tT8U/kJM+sCKWcUVh6BT6rzmT3UMe67k2RMILx+x9NRWSoSNTxkWDFbLf7QLVYPbwUjVa0MjVCZQJIbw8kyxL3VWE7LpEtNSKpzLgOk2QT/80r/1Mgrl526mekWBZKeAiJXD8aNDvkqfs5jvFmbriA9d9trSrBczXsN4Xt1D6I5EnCE+Vir0YHEG7ep0fBfGHziXUw6N6gfPMfhU3B+r/0C5cWWmnXcIOg0fdKIaPo1CWO6/fGW3prKAXef4l54u/VCiAwtPhPxBnBRl5Trf3R12UKsr+wDg7oNV+S49birNaJiHEjyqVMCVCZmKSdpPTDRbrj4E8zJvlPFLhpG/yyNcfNHL9sQ+NV0KT81PsLwbCIt6r/bfiGmtLU7A3FReagQOmwhH8Oe3Fn1Bvv5wL1nHXiaw3QGdsqfUGlhuVXGjI0uDvGMAK5151/
 RRvzGt4b
 Es+L1jmb6ZrMx4Zq6WouvVf+YrR/TOwk55/GXfPhTmo+9mLOcaFSitqJXWW9avgJoKNNDCqMrliN98ZiNj/8rAfH/nQhpajAuoCd+r6gPkgn2cSKKt5ZtDCDAYM+wzy6FR/y4i7GGlbuWAmj1/+BjR8qBb/wNFllZ88valUQ5fgnHc05wPHEfMFVjvVgA2YAlPPoIYgm/z0LByw1KFEfRXbjDV97jwORYv9eKoNqIccSRqOf1cLGrpiWzc+OD9UX7FY7VBN2lAM6UvZjjl0PcoUeuF0gPqWGr4OhhzP3PbCQiPETLuBPjIwlZULNY4QHJmGyCCERnAQ30/wSNbWCeT+AkLQ==
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
---
 fs/proc/task_mmu.c | 81 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 843577aa7a32..1d06ecdbef6f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -517,28 +517,78 @@ static int pid_maps_open(struct inode *inode, struct file *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct mm_struct *mm)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 {
-	return mmap_read_lock_killable(mm);
+	lock_ctx->locked_vma = NULL;
+	lock_ctx->mmap_locked = false;
+
+	return 0;
 }
 
-static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
 {
-	mmap_read_unlock(mm);
+	if (lock_ctx->mmap_locked)
+		mmap_read_unlock(lock_ctx->mm);
+	else
+		unlock_vma(lock_ctx);
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
 {
-	return find_vma(mm, addr);
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	unlock_vma(lock_ctx);
+	rcu_read_lock();
+	vma_iter_init(&vmi, lock_ctx->mm, addr);
+	vma = lock_next_vma(lock_ctx->mm, &vmi, addr);
+	rcu_read_unlock();
+
+	if (!IS_ERR_OR_NULL(vma)) {
+		lock_ctx->locked_vma = vma;
+	} else if (PTR_ERR(vma) == -EAGAIN) {
+		/* Fallback to mmap_lock on vma->vm_refcnt overflow */
+		mmap_read_lock(lock_ctx->mm);
+		vma = find_vma(lock_ctx->mm, addr);
+		lock_ctx->mmap_locked = true;
+	}
+
+	return vma;
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
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
+{
+	return find_vma(lock_ctx->mm, addr);
+}
+
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
 
@@ -579,11 +629,11 @@ static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
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
@@ -610,17 +660,16 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
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
@@ -705,7 +754,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -725,7 +774,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
@@ -738,7 +787,7 @@ static long procfs_procmap_ioctl(struct file *file, unsigned int cmd, unsigned l
 
 	switch (cmd) {
 	case PROCMAP_QUERY:
-		return do_procmap_query(priv, (void __user *)arg);
+		return do_procmap_query(priv->lock_ctx.mm, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.50.1.565.gc32cd1483b-goog


