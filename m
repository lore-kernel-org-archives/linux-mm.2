Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43845C87FC9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 01:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EA26B0088; Wed, 30 Jul 2025 21:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66906B008A; Wed, 30 Jul 2025 21:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57F16B008C; Wed, 30 Jul 2025 21:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0CD76B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 21:34:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D9C71346D8
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:34:13 +0000 (UTC)
X-FDA: 83722839186.17.F13B03E
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0117100003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:34:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1pv3wYs;
	spf=pass (imf14.hostedemail.com: domain of 3EsiKaAYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3EsiKaAYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753925651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30lJY2pYa96sEXS83/LQNWaYvxLZIBXFvHOTGDEcIF4=;
	b=hBPM/shW/XJayl+hqfGcMvqFTdtMATYDQhO+X+inK3e5M6xLUCj9AXcnUe2ENOVxLVNpvN
	Oef3gj66Cy8XTjltWfYo/70Er0HMz22x8dA0Qgzm+aL+cCJdR+ULd0e7WzuJpbWV9Lnpr+
	qNZGNp8EtgvDjsYVB6Uz5qK3S1ZMhu4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753925651; a=rsa-sha256;
	cv=none;
	b=msjv6G0yuiaQ3U6MOd7gNj4XGaNGLxuLK+V+Z7/Vm/DiGzxwDGLJOxvnE/v7hnRGn8TGrt
	2pJE0vZM/LxZNcdrRs1PiTdpGxSZn9EaF70YpK5czPpqVotVVTMG0Hd9Uyw2wh8Vi1yJIu
	7nqHlDFUjPD52PbGuLxGxehW+Qk/kfs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1pv3wYs;
	spf=pass (imf14.hostedemail.com: domain of 3EsiKaAYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3EsiKaAYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b38ec062983so285221a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753925650; x=1754530450; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=30lJY2pYa96sEXS83/LQNWaYvxLZIBXFvHOTGDEcIF4=;
        b=r1pv3wYsqomFdgBCyXFmM7nACyLrBzmf8QmqUYrkZgisZHb7I0Rb2oedOaw1HRTea2
         l7buQg+BK1EDk75PTAwpS/D4wbBbab0F6OnASl+VFBTiNmkNCwFGZ9fQKQeLym8A9UHc
         YIQogcWpPMGitxt7+LMhwYYwkgryJ9cu5tL+7KSczQbZ0QNm24vjXWSXewBXEVMZFNFE
         F3zdXibyTLlYKAdcWp1IpyvkZI4tYM9QP3Me7XP3XNeHclUJuogU0u0rUyoQ+jBGWqZs
         QTYIfkjGeZE/9gHLP3kdcIrfDHuD4+OONTf6FQ9NJPqJAxEsSVFKAcVrM3E4xrXg0nFQ
         9NTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753925650; x=1754530450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30lJY2pYa96sEXS83/LQNWaYvxLZIBXFvHOTGDEcIF4=;
        b=ILdTD19DsGiTCzTOKIjjidbgcFNLdJYZ1O3sQqNDZhY5xUG9/s5HruzATu+qfnZI9C
         kFWZGl6T1Cq8sVDMTWMJdaVBcyd8tvbh5JGw8NeLxxlrf3pPtB5qx51RUGuPBhNprtDX
         jGxAAbSVbU/7ZOUvheGukuEurt5ZbjGcwvL6U6LV+t+vV+zykvFqapbsgAi6HlqVbfPF
         2SR60crIa0IWR7mnqWwCL7LVF9HPQRGWCrIO/QLXiIKn5IBMm5FYOhwTb3K0iCGNV8q3
         HEETyAgjTH1sPkU6kaCdxTLvgy8ij1zbjX0RWVY5DPJzYoxdSaxtNslhdbHk9oqUHybH
         qjVg==
X-Forwarded-Encrypted: i=1; AJvYcCXFMMqAPH6ViWYrFG74i+LV5cM753tabcvaJyocTXG11cy2UXrzCCBJWL2QR56RIkg/pFD1jt8tfg==@kvack.org
X-Gm-Message-State: AOJu0YzoR4A6T59c1XyhDnrIQ3wFSClSoWi/zUm4B6wzl1tmZdCw+TRk
	/TogyvO0AiqDP+KFBe+3dORBChYIXgJnNS9Thgm0S7LDrPuI0/z9Xea9vXwdsEtyMYt6vVwA+Qh
	tBno5HQ==
X-Google-Smtp-Source: AGHT+IGYUSYFqq9ut2qwwG8uB2jzzc7y/YUxC9HqxGAM4IYnR2gPpcg8Thc8TWH7ouQHpVQc3spF01BUWGQ=
X-Received: from pghl11.prod.google.com ([2002:a63:f30b:0:b0:b42:fe:62e2])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d24:b0:23d:b4cf:c834
 with SMTP id adf61e73a8af0-23dc0ec6837mr8924328637.22.1753925650327; Wed, 30
 Jul 2025 18:34:10 -0700 (PDT)
Date: Wed, 30 Jul 2025 18:34:04 -0700
In-Reply-To: <20250731013405.4066346-1-surenb@google.com>
Mime-Version: 1.0
References: <20250731013405.4066346-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731013405.4066346-2-surenb@google.com>
Subject: [PATCH 2/2] mm: change vma_start_read() to drop RCU lock on failure
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A0117100003
X-Stat-Signature: f5qpgwj7ustoecwsccngbg8x9x846wfu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753925651-646047
X-HE-Meta: U2FsdGVkX1/BD7kdLsQARSkxWPoaaqRnmAPOY0NYLZnuUCEkDLo0ZzWJUwpkRNFwuJifjPjkulES3US+XhkMTMx9gKBR91W2FT5kG1UTbIc7jvKbthisQ8UIgcEgXjsoh/V8yrdRXDAjYs1GM7Gc48vYu6JpDxe46e1RzOdjmnDfp84y2WQv4DYYifoKIli3hAE80Xzz6e43E1WYtPWkHxq3NyXJteysYctvM/m9ub/n02Lr443bccLlGAJEwsOwuA/V3bInzDp7ltOb0k1RhcKHmIZJTin4motg6XuWu64tHNcmDHBi1q0xqNlBRpdgs/F+iw7kpOGkZfK5T4eubmk6OAk5t0gqKqcjh6sl+IlN8dQbQF08I3t51yuSPT5+b1iZzDkuBnjP2aLJpnr4x8b8oP8S7G5VvTBh9pyy5aucMcsY2uPLzwDIi/0j0437ZYDKmYyFWXT+tSOR1qUVc8hQ+ntCMvdShXja7oDbjdAdBGNfYjKTmsN2m9t3COVAjPBiEzlJ2dvVQN0/hsfVq2/RYRB7pHKvcZ+95PAo0fOkHuBdi2DvFM5uwcI6G1TjR5Otn2IB05NxBadvP+5VrWZH79/ucIe9DDbCbCuTFAQT/luLDQrJDxpR6uGe9fkmjeswxjA11kRo1wwifahX59JBGHKZfWA/Lgxs7l+sogsfnxgoU6KYNn/g5pKdXbH9rnx0wkE0cXQUirtpc+B2ihDI6h7oDiFry/mT85sjqntOTV86EiDimFxS8t4/68PLjou5ZLaCpXwJ7q4hWbX6Nzc/UwKvqMty/zDPPiIkf9riGg7Iw8Vlskh5zzrXaZyz/0OfzPmS8WGQE/riEP2MpoTvQv9PyGv5n7a4kZfLQFIm5z4ym8tTbGqo/QAMBAlERrWaFfxcBlXDZ4fOZrDUDKFd5wGCaGh3+tIKsXO3dqHKznWCnzdz5AP7SjAqgl7Pf1IWpLnSNInb5H2EtoE
 p5tH+7Cn
 mqjtdR3bmCVGyLuoIwUWu0WsJXFs8lNZFSaw/jXMIFvz5GTV8YetdunPGm6k4ugg2l6o3VQxkhkTTBEyf5LA7W6Tf5LHVy2YV57pP/0OTaMQKPHZK6ciZ3rtCJIJumQvT6jh2TIyfmrhuL9XrqwlzTFTQr5aa9BgKRFgaIllbI5ni/0rZy5h0LqmyxKh1C24dKaf2GDVjB4sJQSvrl0J4bpydwKBvtbtoJtYkD0nlR7UvwoMBY7lFtiwAtCGy/6wxEuUQSt8RbmjJXBAx3am/qGGqhFcZMKsrBaNPNDlEpC5c0Lv4RdBUJbCNEOin48MmwsDZBQtZcfXewvQIe3uXCVwiR5H1WF8y/lf/cr9cIbS/u4eu6p9jaOG909cKfNw6gIkEXJMDYn6+fQWf74eiu0zShvDKED7NewDBXNd8t7fpGD3A4cy02Av1c42eyD5qZs42R2caKlfYFX4YGeIcgIXJd0KG8Qw6hy/vImrl4sJvz08XVqCrkFxnwTuupbFDMh3RykSMy34h8oSFs/5u9NQjxvBbgExTyfFvHhX9qZl2vb3oSqKitNpncKfF08LMTgZZaeDyu8QTHJ9/U1TDKKILKVeiasgB7VJD5jwm7GniGdCBX3hx0LxA9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_start_read() can drop and reacquire RCU lock in certain failure
cases. It's not apparent that the RCU session started by the caller of
this function might be interrupted when vma_start_read() fails to lock
the vma. This might become a source of subtle bugs and to prevent that
we change the locking rules for vma_start_read() to drop RCU read lock
upon failure. This way it's more obvious that RCU-protected objects are
unsafe after vma locking fails.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/mmap_lock.c | 76 +++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 10826f347a9f..0129db8f652f 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -136,15 +136,21 @@ void vma_mark_detached(struct vm_area_struct *vma)
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
  *
- * WARNING! The vma passed to this function cannot be used if the function
- * fails to lock it because in certain cases RCU lock is dropped and then
- * reacquired. Once RCU lock is dropped the vma can be concurently freed.
+ * WARNING! On entrance to this function RCU read lock should be held and it
+ * is released if function fails to lock the vma, therefore vma passed to this
+ * function cannot be used if the function fails to lock it.
+ * When vma is successfully locked, RCU read lock is kept intact and RCU read
+ * session is not interrupted. This is important when locking is done while
+ * walking the vma tree under RCU using vma_iterator because if the RCU lock
+ * is dropped, the iterator becomes invalid.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
 {
+	struct mm_struct *other_mm;
 	int oldcnt;
 
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
 	/*
 	 * Check before locking. A race might cause false locked result.
 	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
@@ -152,8 +158,10 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
-		return NULL;
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence)) {
+		vma = NULL;
+		goto err;
+	}
 
 	/*
 	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
@@ -164,7 +172,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
 							      VMA_REF_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
-		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		goto err;
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
@@ -175,23 +184,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
 	 * releasing vma->vm_refcnt.
 	 */
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
+	if (unlikely(vma->vm_mm != mm))
+		goto err_unstable;
 
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
@@ -206,10 +200,26 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 */
 	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		vma_refcount_put(vma);
-		return NULL;
+		vma = NULL;
+		goto err;
 	}
 
 	return vma;
+err:
+	rcu_read_unlock();
+
+	return vma;
+err_unstable:
+	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+	other_mm = vma->vm_mm;
+
+	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
+	rcu_read_unlock();
+	mmgrab(other_mm);
+	vma_refcount_put(vma);
+	mmdrop(other_mm);
+
+	return NULL;
 }
 
 /*
@@ -223,8 +233,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	MA_STATE(mas, &mm->mm_mt, address, address);
 	struct vm_area_struct *vma;
 
-	rcu_read_lock();
 retry:
+	rcu_read_lock();
 	vma = mas_walk(&mas);
 	if (!vma)
 		goto inval;
@@ -241,6 +251,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 		/* Failed to lock the VMA */
 		goto inval;
 	}
+
+	rcu_read_unlock();
+
 	/*
 	 * At this point, we have a stable reference to a VMA: The VMA is
 	 * locked and we know it hasn't already been isolated.
@@ -249,16 +262,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	 */
 
 	/* Check if the vma we locked is the right one. */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		goto inval_end_read;
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
+		vma_end_read(vma);
+		goto inval;
+	}
 
-	rcu_read_unlock();
 	return vma;
 
-inval_end_read:
-	vma_end_read(vma);
 inval:
-	rcu_read_unlock();
 	count_vm_vma_lock_event(VMA_LOCK_ABORT);
 	return NULL;
 }
@@ -313,6 +324,7 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 		 */
 		if (PTR_ERR(vma) == -EAGAIN) {
 			/* reset to search from the last address */
+			rcu_read_lock();
 			vma_iter_set(vmi, from_addr);
 			goto retry;
 		}
@@ -342,9 +354,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 	return vma;
 
 fallback_unlock:
+	rcu_read_unlock();
 	vma_end_read(vma);
 fallback:
-	rcu_read_unlock();
 	vma = lock_next_vma_under_mmap_lock(mm, vmi, from_addr);
 	rcu_read_lock();
 	/* Reinitialize the iterator after re-entering rcu read section */
-- 
2.50.1.552.g942d659e1b-goog


