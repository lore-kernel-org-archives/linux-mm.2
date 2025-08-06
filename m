Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC655C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754608E000A; Wed,  6 Aug 2025 11:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C228E0003; Wed,  6 Aug 2025 11:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641558E000A; Wed,  6 Aug 2025 11:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F18A8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:59:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21CC51DCF34
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:17 +0000 (UTC)
X-FDA: 83746791954.23.053BE9D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 515E2A0007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhhAZsSw;
	spf=pass (imf15.hostedemail.com: domain of 30nuTaAYKCGMTVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30nuTaAYKCGMTVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79cST+DpT8JLjhSc853c7Vp44fp4YLe4km92lxkzOhQ=;
	b=IMxUO4m5amSRjhL4ZmNE2oHdzY0a2v4w3a1daqBOlPa0CCbNGWPE6sCwrH7yYRcQQaGQcK
	5I9D6Qy/HWcdWFgZ74mH66+rMbo683FfQRPiHER1/rblQHlkz8j0dmnSPMIHKKoKRpzgAR
	KSWeO7r5sAMZHTJfTg5tc+L9FUCnVVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495955; a=rsa-sha256;
	cv=none;
	b=2f5GfV+KVDPVMc/YURVAHCQBcql3oTd7tFhsCrlyHEW1YlWe3iVbQeRfjkoiDaNBX/ex0a
	J4l43E5oNjYERK17TkFNlzpUXNxubuhWV8rHRDkWCbTT4lc3KokQxRKyO0273eXL36LL5i
	zVjKl1uYL5zsjmfaqLGgzMlGnB5Ut6E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhhAZsSw;
	spf=pass (imf15.hostedemail.com: domain of 30nuTaAYKCGMTVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30nuTaAYKCGMTVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2425e41424cso54599465ad.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754495954; x=1755100754; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=79cST+DpT8JLjhSc853c7Vp44fp4YLe4km92lxkzOhQ=;
        b=vhhAZsSw/vReX1vpgu6fdop62SLFC1XX9ZDOrm9EGK5CLaRoKl+komSOtyRaeXTX53
         LsqOCxiFxNbekn3jXUg5AVqRq3CmMUlqx27nuAbuU3Hz3PMYovmt2Er/pm50ZA9f/s3j
         NWW/0/awGqNRxxqBoxRD8hA+sMRsYS27AoLqTGK1+42C9a5FFJYWQo/cSUEev+cJMDaM
         zv4BUHbSugtDDTFHHcGQnyJv15f/5OyT0ULMghPIz4tqBQZ6NHQp9JwVOhlrC/qw9jeU
         SovRqmrcxWAt7okuQr3q4r7F/g2BAsGxeOBmE/QTV+tbZ3kSkKRILunYMNkgH6HsXp3K
         G3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495954; x=1755100754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=79cST+DpT8JLjhSc853c7Vp44fp4YLe4km92lxkzOhQ=;
        b=sO5qN2zuoOYw2XK0GK7xHEIE8s5inbgpO+8KY0wAWuMjkKyELY0/OmJ5RMuZ8aca3x
         ft899jZZx01UjuB1RCafNxior786rCJFHrX+Da6F2gfdbrjzuizCtpd0piUexF2ucf2/
         m7SyDOoPRgAUD4iBPvAuC9xHX+ngS4DEKAb1OMBebtzMGO8HgQY51m8DMLOzwPUkAoB0
         2+sSEw1ynsuiug1/qdxy3maVhtMsL5m8fLkrna6Wv4hu11SdnicqFcqePFFW6jc+XhxQ
         PA+UB0UFtKoGnV1KFaHAllWjGO5YGo585R87ffsfPPioFQCgRu1GM8MBE7kktypZFCLM
         sA0A==
X-Forwarded-Encrypted: i=1; AJvYcCWUuiYBF+kQGb9lHE7t/eBPHN99JqXILuvAWcQuNhkQHLc//qJw3ZcBVdfERIezahlZGWCFOAAF3Q==@kvack.org
X-Gm-Message-State: AOJu0YzCisaW3cuk+nztcYUH9AqZTf9WDVk7/rfKXqbAAv93O/b9AN0K
	Z1aVzZBayL5Pa/sRggYk+/mMqtHiZnoEkso0Aqh4/polzjXtPS3OGLD9tO8PJ62DwAFoko/RFbE
	1OUTVsg==
X-Google-Smtp-Source: AGHT+IFlS+JvIsWnRvs7bTfyfgC/5w+RmEgonVOp9GJDKi3AshY2Fhxqa2lT8Ee9l8rZG2GebQuiHk0ZMyQ=
X-Received: from pjboe1.prod.google.com ([2002:a17:90b:3941:b0:31e:c61e:663b])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dacc:b0:240:92cc:8fcf
 with SMTP id d9443c01a7336-2429f496c6bmr47463745ad.49.1754495954146; Wed, 06
 Aug 2025 08:59:14 -0700 (PDT)
Date: Wed,  6 Aug 2025 08:59:04 -0700
In-Reply-To: <20250806155905.824388-1-surenb@google.com>
Mime-Version: 1.0
References: <20250806155905.824388-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806155905.824388-4-surenb@google.com>
Subject: [PATCH v3 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
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
X-Rspamd-Queue-Id: 515E2A0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bgmihne16mweyf8fc7szf96ifa8xxnfe
X-HE-Tag: 1754495955-947955
X-HE-Meta: U2FsdGVkX184x2rPFaMDOA/RBtNCp0inSUk8pG+SXRzUxHsL5het7zHs+imCc4YsxomygeW0CWPfhB6A5gNaWL6udXgAI7C4KctAVore3KSYTQyff1uiC+QhyAAru5KZgFFzIdfBfxDARM8J9mTEQl94Rmhc2rZqUAKP2sKCqf16ksXu3WATPwE2s/lBMWgnNp+RxJIN5pS/fB9e0liviwVDTGuIwypOxJJ7kPA2gIhm06hXhWqz9F3tbQpn/8aVG8KgMMShWlpsnDDjFhUHDeJyDuSXjcwpeeBXZ9UEHiwxauK4IjZHxahCb2+AX5cog5P9vCc7GI7L0holT9fHto6/0qvMh9coOKN2InkvVWei7GQUnAi/BtsOQfD6nJcFkJKAmb6nfOfxFDZ9OuH7TrF+5GEJLKgY33D+6bUQc/G1Olx9b9PLOuzvu47hmeg5Zyi0OHj93Z3WizYRqMJyjgqK3E88W1Uuoi0oFepvrNNYZGU53tmyco6RjxhKtEvTbIR8+QTMGlvNpIVmW/L+k8MYBu5vsl/Vzmo0jX7f7W6ViPpzmPaDKlFC2AkbG7FImKa4bu/Q4BIjLiCIsG4JN5JJEuODN4OsjbfSsPDWMfCzClcd59GZDq+WPeEFsoy1FSfnPG4jpquti5M9A3MLJqm42qXiBMyY/+ZrjyWWYosEdngS+jvXvn5wmWsqBXUqGdDZWako5EXXFAAzmQPURRD4R/J1Ldl1phafA40x8IyLlmD/Id8RFgGLZOy1M22W9TcjaTpKlVAH4cy535EuRbkYIjY5a1e529nAu5zS47am+QQEP3kyIgykJ3IMtZbxs3G2P1QjTjEWAsAS2O6a5wZv0IYmBm0kOd+nPK315BW3Bcd7nHoPrDTKX4NkZs8VmVpqZe57IZrCo/VhUU94cM5ypubRVVVLpUPV13+tuQ9lec1dx7eXq3e/VvArLun3U0VQ/HzEFFL7vZfuahp
 PWBoWGma
 vAwI9WYNm84CxSSGw5tmtdbKH4xs82759L7URwBpa63vMzbDEGz3sODj6HctpJ48XFVEvUhHo0oeKRFczRxfnEVJ3YrTBIT1raGIqTJzh4IgHoImT86KJ1wmzTAKE9YnV6CrlEQB40RFewfE3Z2/SRv9uTLM5S9Xph8zCY6dfJThLpWS7T8rpwVZZeCbpnPXziqni2APrmT7J8tlz/TiujOMTZ7RqN4j5TMpjw94wEb2ysDtUEZWJx9XEvpJnAveyhnPvsZFFEbA2w099WSrWaAQHuPQ/bQidhb6e9ynYGLHQtCKWoMmSChdBSpSVvMubX5YvtmKaD2KAW93l2fSG0wu1qVIClmdirnwRYvHvf/qOa4+Cs431P+Xi6tHC5LeVlco9ndU8OOyKgh5m7gNMd0o3GHd8iMX/Lv6eMw9yOcRga0CINySecBG8jeH+oiXaCNK+MVfrhss8jFDeB2VZsihUqWXqRy0IHgfsmSgIP2OhEHqXNUCgm6qaeIqHkr7I66Vuz0tgB9AouiUpMcmRb/dxr6L6vho7nBzy3k1G3h4vnUYwvFTM4gs27l6RpcASvDbxerdvH4md5CnbqJV5S9fX96mHp6O/5P5TLVXeclrElhEu89zDMXx5dg==
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
 fs/proc/task_mmu.c | 84 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 68 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 45134335e086..0396315dfaee 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -517,28 +517,81 @@ static int pid_maps_open(struct inode *inode, struct file *file)
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
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
+						     unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	if (lock_ctx->mmap_locked)
+		return find_vma(lock_ctx->mm, addr);
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
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
+{
+	return mmap_read_lock_killable(lock_ctx->mm);
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
 {
-	return find_vma(mm, addr);
+	mmap_read_unlock(lock_ctx->mm);
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
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
 
@@ -579,11 +632,11 @@ static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
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
@@ -610,17 +663,16 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
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
@@ -705,7 +757,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -725,7 +777,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
@@ -738,7 +790,7 @@ static long procfs_procmap_ioctl(struct file *file, unsigned int cmd, unsigned l
 
 	switch (cmd) {
 	case PROCMAP_QUERY:
-		return do_procmap_query(priv, (void __user *)arg);
+		return do_procmap_query(priv->lock_ctx.mm, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.50.1.565.gc32cd1483b-goog


