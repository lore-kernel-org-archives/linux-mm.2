Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC5DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD136B00A1; Mon,  4 Aug 2025 19:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD806B00A2; Mon,  4 Aug 2025 19:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74DC6B00A3; Mon,  4 Aug 2025 19:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C14F16B00A1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:33:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485431A0956
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:33:55 +0000 (UTC)
X-FDA: 83740680030.30.48FB5EA
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8814D1C000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:33:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3uPAnGqT;
	spf=pass (imf18.hostedemail.com: domain of 3YEORaAYKCHcnpmZiWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YEORaAYKCHcnpmZiWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754350433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K8kBr0sEdWPq/rMgi5JjXlkIUuqL1mTAE0S/a8VUHQA=;
	b=bWG/L3fx4r2Tu+Kdz5V1wT2pu+40EnU8uVph3k5qNpMTeXN/vTOEV/1k7ReW/WR7f9zXdt
	R1YnJA7XwqPxN0+gIdQTVI1s0BgU3SWuj619fKjM+4iLfz1jGrCvR7D2gxV65YFYCS+TX0
	2RnxRmz10lMYk8JRpC8Ug/IPKhtOgNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754350433; a=rsa-sha256;
	cv=none;
	b=q/FDY8/cix+sBRUfDZYZru991zsBqhDSs7ztfMBS8GJ92H/6YlSBZTYkywopdJLmEZG/9M
	ktxRHc+OEybN9FaRQdocSqsxDhq7o2JtcSaXK+09N+yi3tMGkWd4RPouF9Hoi5KfnGd+YD
	9zV8nEt3MHeom1ACuvZqWY1CgANNSPg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3uPAnGqT;
	spf=pass (imf18.hostedemail.com: domain of 3YEORaAYKCHcnpmZiWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YEORaAYKCHcnpmZiWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fed1492f6so71940395ad.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754350432; x=1754955232; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K8kBr0sEdWPq/rMgi5JjXlkIUuqL1mTAE0S/a8VUHQA=;
        b=3uPAnGqTsb+OD+8IwMKJAIpVRNb+eYkoUZxhdG0XMy+UtgiNJkE7v7awmDtsFLqyxx
         g09CZhVpfxadAHoePXN6EADtTkOfOVdETnTwT0Jsd50IUC9a7FhuXgp2TmvyJk4UUWfE
         jvuLaP77RWEF8ZjZCaz17BhLNmqB8CD+8+YN0L87DQDhe69fXT3XwaClKkW5SQv/eNWK
         BejGG0hBAWflTNxX17bCi4yGlXybewtBqnXVXjELnHxJO/iXmrbHXFL18x+Sz1Z2FVL9
         3czBU8/JK4qWFP3oW5pjwCZL+GSFxr2vM43wl43oQGKgAKbp2gK3UsNcsc6GQ/Dd9G8y
         maxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754350432; x=1754955232;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K8kBr0sEdWPq/rMgi5JjXlkIUuqL1mTAE0S/a8VUHQA=;
        b=jDVgZ3JLB39jUjePvf5X+rbOen16XmXFpV3T6zbI/TA534JSsjfX0OZsQXG+337Mn5
         yoFQ2nPitJRU8zmg+tEJn1B6yPg1QtL0T8cOXA6GHulC/0je1ktm3Rt12HyHLKXTZpNv
         Cwturfskpl5FUKlxQidTTb30t1YC2WVgubBi6Puz/7XGqMViTElkVIPssRvbnswsTCRN
         JYtqP0y0/wGVg3lUydvTw5jrp5EESvRISSve5BA0Cg60KcZCTn3CDjc0zDxp3l39Xxny
         KsYeeUg42IfvUQOnJQygs6JgMGYYPDJ0eg+yOtF3Q1AhQIGa+NYI8fK0N8f9XPtXlcNd
         Letg==
X-Forwarded-Encrypted: i=1; AJvYcCX80jkUYbc6pYhSErHXzT/BPtvLr9kJyj3a3AYBN+xUKtPQko/Z4X207un4co5mkI/fPH/qVmNRfw==@kvack.org
X-Gm-Message-State: AOJu0YxQmlGL9kzKQ7JQRprFU1v1umCChfNyQHGpIIeiGE8C97A2Ip2A
	bVXPzL6lgLxEAmx8fUZAEVrPCyJuNhGJPmBHMI8giPkag97YX4fExhym5dC1sI0A4XxYM5iY6YL
	8ruuxWg==
X-Google-Smtp-Source: AGHT+IGsJpocfloOVPr6u9A95As5/2zobosaAdFactB/XqeVKMru/t83xLTZYroGA2eQMfT7vptdCESTqYI=
X-Received: from plbli8.prod.google.com ([2002:a17:903:2948:b0:23f:d6f2:cb9d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c8:b0:234:d292:be95
 with SMTP id d9443c01a7336-2424703f838mr146561815ad.42.1754350432369; Mon, 04
 Aug 2025 16:33:52 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:33:48 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804233349.1278678-1-surenb@google.com>
Subject: [PATCH v3 1/2] mm: limit the scope of vma_start_read()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8814D1C000B
X-Stat-Signature: 8ogyyx7hbxy3ho7kjwgu8pgudikpfucr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754350433-931325
X-HE-Meta: U2FsdGVkX1/e48fXhzU31HsAnZZZUsBA1Y8spNlikesUnzJ6A5hy17fQmbK8az9W7XXg9K3D++v3ziMg575qHyi462dZtn4klvt6oeSY9MOe8dTy+OFEajTkkI+JiRyBvSOfWXmhHFL2qha47aAJTIZZfR9Ni8535/395jTuxnHIOekZvdPt6T/kQCOSRWYORSiKZD3uOGo9umkLT/cmhktvtkqRngOUvbTA7CCTKaf3DeT/2pbq8V7i+stsPZe/qlOgUbLG3hknD0JPG+SET2qgnGxb3neHuLP9zZgvEW3dwCnOYvgkQ2R8QMZFqdbijZEdrD2DttmqdmoJ9871EGEt4RudH+Q7+/LldtXIuzkzYEYI63pREhR1dRq4aIlnYwffCTrPTP2K7CTHXSMCgbl8Zori1y5dC/KUEl+1M9S1Vele1VEXzPej75QdURd7sqcu9CHbHPONc4KUwE79S2RdONAluZ5GfHeYdj0ebzSJWHDhydPx4G2NrYU2gXpzMMnU5ds2aJmaVtPrJendDcIWsff/wb0ERutY+5aer8RKYkgx539d3Mb+tRSaTQIFdajxtKRJRDpWiWCCA0p7EU4tcqzh981XDv7mI322lURVC5bLdcLa5RmQjIMeCEjAZjijFFPr/gtlC12HlVPJHijMKe2e1pjFiKOOX1YvhbGalO8xEKEizei9jBPj1rmpymPQU1Z03/48WFb150L5nqJ6YzzR/jPN/ABuQd4fAW+xLf5AX3GABOoMZtj7a4RFV6OzIZkePCMCLW3KC/RP8Qc5sGUUCFwpE5mW51YqrgqIdRECiThWuo2mbBCBUN22v8tCui6g95ztqRS0ypPqn12HOPeWBAJwYaoa/sv+FMmqDwUSFgPuT6JPCY92qMzIGPM5D9nD6sbptojnfqNmBs4Pvh6jHinNiJJ/wMg593vonDx3hJCxQNsAbJfa+L0eE3Ch4fAJpTfNWz2xT80
 aNECvGWo
 ODfxBfkR07eLlfTL41uoXOLe5Ku/GxRQkcOFiUadp3eu2xBEk7iqJQD1ECxiP8kzltVo7NrMRSH/hwnI++/5wIwAz1vwTUAtDzRSDM0yDEII6JaAIFG05tEq9xjtOFz73gf+5MUYn2n0qcc6oA/xCQ20NUZjPYroirnvOjg5la6LAs3fLFPuE5QVb0pM8mmUuV8ZRPSZhDl9YQQJI1WqJm53KsqhJQd3ivDtpHjVzzK4cgVJVuMUhBhcaOANQcDZ00Lhilam+plCBF3qKsxFReVXJeTZ1PPOiTPYD7jk+nYudWhsOMRs59OVMCIl6sK702QjLda1n5agTb2pibP2sFrFtZqyOT0rbJnJz2XwnhLpvWy+gfrey6KdJDFdcTsCFLFrHLw9yGwgGmSEla20zzV8G0Up3w9CfcMI3Au6zFi/qOaL5Q+auY0Q6pPNa8izHCQAAVSnS/BzLkAYANHHiRDZj3uP3G0M/YqlplMruao7BoSP2MVwqigU2p3Ky8L1oDjygfIVrRd+2LVBnSqllTJaR7n3rG1h357giz9gF+ELmxYTmVFIl86JqPU6z04/zbU0OYdBGmqquZMiIFWO4FdROjwrncB6EWfI06hAUKjtaWGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Limit the scope of vma_start_read() as it is used only as a helper for
higher-level locking functions implemented inside mmap_lock.c and we are
about to introduce more complex RCU rules for this function.
The change is pure code refactoring and has no functional changes.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mmap_lock.h | 85 ---------------------------------------
 mm/mmap_lock.c            | 85 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 11a078de9150..2c9fffa58714 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -147,91 +147,6 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	}
 }
 
-/*
- * Try to read-lock a vma. The function is allowed to occasionally yield false
- * locked result to avoid performance overhead, in which case we fall back to
- * using mmap_lock. The function should never yield false unlocked result.
- * False locked result is possible if mm_lock_seq overflows or if vma gets
- * reused and attached to a different mm before we lock it.
- * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
- * detached.
- *
- * WARNING! The vma passed to this function cannot be used if the function
- * fails to lock it because in certain cases RCU lock is dropped and then
- * reacquired. Once RCU lock is dropped the vma can be concurently freed.
- */
-static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-						    struct vm_area_struct *vma)
-{
-	int oldcnt;
-
-	/*
-	 * Check before locking. A race might cause false locked result.
-	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
-	 * ACQUIRE semantics, because this is just a lockless check whose result
-	 * we don't rely on for anything - the mm_lock_seq read against which we
-	 * need ordering is below.
-	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
-		return NULL;
-
-	/*
-	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
-	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
-	 * Acquire fence is required here to avoid reordering against later
-	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
-	 */
-	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
-							      VMA_REF_LIMIT))) {
-		/* return EAGAIN if vma got detached from under us */
-		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
-	}
-
-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
-
-	/*
-	 * If vma got attached to another mm from under us, that mm is not
-	 * stable and can be freed in the narrow window after vma->vm_refcnt
-	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
-	 * releasing vma->vm_refcnt.
-	 */
-	if (unlikely(vma->vm_mm != mm)) {
-		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
-		struct mm_struct *other_mm = vma->vm_mm;
-
-		/*
-		 * __mmdrop() is a heavy operation and we don't need RCU
-		 * protection here. Release RCU lock during these operations.
-		 * We reinstate the RCU read lock as the caller expects it to
-		 * be held when this function returns even on error.
-		 */
-		rcu_read_unlock();
-		mmgrab(other_mm);
-		vma_refcount_put(vma);
-		mmdrop(other_mm);
-		rcu_read_lock();
-		return NULL;
-	}
-
-	/*
-	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
-	 * False unlocked result is impossible because we modify and check
-	 * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lock_seq
-	 * modification invalidates all existing locks.
-	 *
-	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
-	 * racing with vma_end_write_all(), we only start reading from the VMA
-	 * after it has been unlocked.
-	 * This pairs with RELEASE semantics in vma_end_write_all().
-	 */
-	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
-		vma_refcount_put(vma);
-		return NULL;
-	}
-
-	return vma;
-}
-
 /*
  * Use only while holding mmap read lock which guarantees that locking will not
  * fail (nobody can concurrently write-lock the vma). vma_start_read() should
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index b006cec8e6fe..10826f347a9f 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -127,6 +127,91 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	}
 }
 
+/*
+ * Try to read-lock a vma. The function is allowed to occasionally yield false
+ * locked result to avoid performance overhead, in which case we fall back to
+ * using mmap_lock. The function should never yield false unlocked result.
+ * False locked result is possible if mm_lock_seq overflows or if vma gets
+ * reused and attached to a different mm before we lock it.
+ * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
+ * detached.
+ *
+ * WARNING! The vma passed to this function cannot be used if the function
+ * fails to lock it because in certain cases RCU lock is dropped and then
+ * reacquired. Once RCU lock is dropped the vma can be concurently freed.
+ */
+static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
+						    struct vm_area_struct *vma)
+{
+	int oldcnt;
+
+	/*
+	 * Check before locking. A race might cause false locked result.
+	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
+	 * ACQUIRE semantics, because this is just a lockless check whose result
+	 * we don't rely on for anything - the mm_lock_seq read against which we
+	 * need ordering is below.
+	 */
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
+		return NULL;
+
+	/*
+	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
+	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
+	 * Acquire fence is required here to avoid reordering against later
+	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
+	 */
+	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
+							      VMA_REF_LIMIT))) {
+		/* return EAGAIN if vma got detached from under us */
+		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
+	}
+
+	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+
+	/*
+	 * If vma got attached to another mm from under us, that mm is not
+	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
+	 * releasing vma->vm_refcnt.
+	 */
+	if (unlikely(vma->vm_mm != mm)) {
+		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+		struct mm_struct *other_mm = vma->vm_mm;
+
+		/*
+		 * __mmdrop() is a heavy operation and we don't need RCU
+		 * protection here. Release RCU lock during these operations.
+		 * We reinstate the RCU read lock as the caller expects it to
+		 * be held when this function returns even on error.
+		 */
+		rcu_read_unlock();
+		mmgrab(other_mm);
+		vma_refcount_put(vma);
+		mmdrop(other_mm);
+		rcu_read_lock();
+		return NULL;
+	}
+
+	/*
+	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
+	 * False unlocked result is impossible because we modify and check
+	 * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lock_seq
+	 * modification invalidates all existing locks.
+	 *
+	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
+	 * racing with vma_end_write_all(), we only start reading from the VMA
+	 * after it has been unlocked.
+	 * This pairs with RELEASE semantics in vma_end_write_all().
+	 */
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
+		vma_refcount_put(vma);
+		return NULL;
+	}
+
+	return vma;
+}
+
 /*
  * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
  * stable and not isolated. If the VMA is not found or is being modified the

base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.565.gc32cd1483b-goog


