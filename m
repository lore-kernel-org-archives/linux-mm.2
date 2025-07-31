Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B41C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDE16B0089; Thu, 31 Jul 2025 11:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5826B008C; Thu, 31 Jul 2025 11:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCB96B0092; Thu, 31 Jul 2025 11:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0446B0089
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:19:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01CF0C0121
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:19:25 +0000 (UTC)
X-FDA: 83724918732.15.F5B0545
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 484434001D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:19:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vPI8QO1H;
	spf=pass (imf01.hostedemail.com: domain of 3eomLaAYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3eomLaAYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975164; a=rsa-sha256;
	cv=none;
	b=liEhFoZ+M0iQXt+pyInsuaMOXvbtc1AYSkbnIEAMi1EDqdFJlweUCY0JObpR+h0NwkXme6
	jnodTxv8MsjeeZLCwxulV6/Pw0UxSugWdFNp+Dg4lpzsegUgxIibcVDV3ONNiGcheu1CLI
	nP5QXIu2W7t6ZCGvwkkeELujhsVG+u0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vPI8QO1H;
	spf=pass (imf01.hostedemail.com: domain of 3eomLaAYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3eomLaAYKCAcz1yluinvvnsl.jvtspu14-ttr2hjr.vyn@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rB92jD43gXUv8AEcDtD5VmVQXDaAyFtARma7oKwYEvQ=;
	b=ejrvQzLLRd9KlkVg2c1XGoIP1dNETX5l8YD+ASAFlYlsh5gXB80l6Gac3vm78XHKK8rtJH
	7baaAwPzxi1Mfd+jFh0PDm9v/ZI7pOYPUwxvWDBPXWCvdrhfTLhdptar1+6z700j3R7UfQ
	Yi7GmpUETJWzHZQwkRVDJ/9J1G5grCY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4225ab1829so775839a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753975163; x=1754579963; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rB92jD43gXUv8AEcDtD5VmVQXDaAyFtARma7oKwYEvQ=;
        b=vPI8QO1HriDdJMep//OZ+jJCoDDrRY44qQxFVzBs2skvaEWEbxfAmEX8znSyLPthhQ
         M+6yee0UfJC8g3mgv1akRrgfrEqXvd9uimcT9STDaWF0/0hn3lg9vRtWt98AlkFVHZN/
         /IQv4eiw1WI/P5sBG0MnSazQAj8Cy9cqWKNvswvM7bQwOMHJH+gkc4q5aCHZ4S9e/dVA
         hH38wplcu1ImZKBiW85wO1ePZ/vZiYnDjPNnEZ55ubI2DTy2I5b2sMkuMpHq97kzZG5R
         FnrncJk1MRIXx68WY0agDEiLEx94BI9OPH+W675AEFUW6JSplh3u+d8jem6O5bSZMRM1
         UnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753975163; x=1754579963;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rB92jD43gXUv8AEcDtD5VmVQXDaAyFtARma7oKwYEvQ=;
        b=jxr0pYJg36kqSbIxr++K5ZhBfyjJAXUQPkQzIaz7UmUMD2c1PXAOsPm3VkUITT+QAe
         QXvNQ9iEbocTTQBbQHuqcEKCXPiQpLzY3ZT/Yz/u5+aTRFxbVOsoiQuZaZwlB2tEXd2Z
         lzWEP18nW06xyM1WjAjB2DEkejwdv5AKHor8Ph20FqtOqOdNnctU1bQaxtyfWmAY6Mko
         FNOft5bk1cupOxddn6ciXWpW7nm+lsRAhbQElrLwFY0TcdGZ1p256a1ArH3GeMYstWWu
         Pjqlrw1Y6Fqdxe1/FPWsV3NsNm9LaLxcCh+ZEN6GEgYuX0IAJPORbbaOD+N0NN3hYpq0
         a4hg==
X-Forwarded-Encrypted: i=1; AJvYcCUrvPkUJSkQT1PGJWH2w3X3/jr6dQZs1B+dGUGHKsOQ/DV1NFSkaC43du3DmRrw5DxUNLv3jyT4eQ==@kvack.org
X-Gm-Message-State: AOJu0YzvtZJbBFemmKxaz1IuyKeZaU+ggqUDOq9ITLN3arCK+Zv+Hc/U
	bOwDsGpR5T2gyfbTSCIG8dKBpjrDa2LaP7biQSmdyMWn1ZivTGWSQ5uisB/IEPYk63+HQPmpEz+
	YoNh4Ng==
X-Google-Smtp-Source: AGHT+IFycxqU1nsBtsiPJqQ9SIyZmgKdOXZHM3ZE9nPZBjUAHvqIptVuh4EUlzGZst3nTg88jL8l2xDazsk=
X-Received: from pjbqx14.prod.google.com ([2002:a17:90b:3e4e:b0:31f:6a10:6ea6])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c4:b0:31f:44a:229c
 with SMTP id 98e67ed59e1d1-31f5dde6ae1mr12120454a91.12.1753975162973; Thu, 31
 Jul 2025 08:19:22 -0700 (PDT)
Date: Thu, 31 Jul 2025 08:19:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731151919.212829-1-surenb@google.com>
Subject: [PATCH v2 1/2] mm: limit the scope of vma_start_read()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 484434001D
X-Stat-Signature: j71wkhbzhccc5qzi8yyh339tzijcpjw8
X-HE-Tag: 1753975164-623626
X-HE-Meta: U2FsdGVkX18ojASra79+z7Z9udCRqwmo0xeHpjCHA3zNxjHJfWxQAIAeIsPJqpPPOdhWBYr2oc00RWHGqhmFMqjzxG6FtfwzfnZWBAeBkNNZptYQAojR0a6n/XGG5/OkSAHBxNUe0eiOPkDfclD02SGfJ+b7o8FCXKm0XvRKxzlijJGkeKg0pgVNg8FqG/a/2WObCo85fRQzPkXrenRJZa9EDohY/HYCVfJJLOP1ssldxdzNsjtXte2ERrRdKnGQuCVWgGDbHqqYvB9AFO0KVqSTnOWt0fIpk65TgKrK/0zvNdHDI2ht73h1GWFKuP7Uy25X+PGySxdwWX+Z3H6t0Exhpd/XX6WP6L5GynXjGd67GLi7KbAZoTYz/Wkrsajl3pml07XaAwWHotda0zxOKLjHto9/UlEY6rBC27mpim+S2ckHnq82Bw138AWSFhIVt6vTzb8Mpc0YV/az/kBGYjo7bhLLbLhVR4r1uRC0oKIeZxwOjCd4wPsTGLsFj8/FXUYpOFq0SXkT9wiPO8dqIZM466qBWP+YejSF+N+3frqj2j/GUK1rD/XY+8zHSdi/p7j5S1uODtMdQVTR5yeoK7PzM0UBufqNU4BH0z6CAP2/6janSMsmUyiumubLlZ4VJCI3/d7OQsP2Ssr5WKyDimisKM+mLfcU0qJiw7AB0fPpmrHvzQxGVEaFrAhcdO2X0NHSTNMazhJUHXZppLifuVg5vHsznsm+TNS9BIMlgAtqlBDDVIuogS7X+5jJNg8btABLLvp6zent+8l6BATfYffVxbY3ooqQnNF2kpILV0IvuKFOgR0zkVJM4iqcclPiW//nN5lqm+bLoWZmhkBU6ssUP8lHzi4vYFDgIiXl2pgJ53BV+HXWtnej3ImVN3rrTpkyoAGzc/hfLoEMsDdP/nML9ExckN4bHNkdN0xUtExzmg2d7sVQWs70Mp0REFYhkeRABd1K1mlcXgBmuX7
 QnC5w+Q4
 19QdP7xIStBo0GqcHmuFXFINHJ3gdYQHL5c6aA88/RFTgaXy57zw+vB6uvrBcd7AfTRM+Gg2Uuh6KiGKxvojNWT0SgAeH3v1jcvxXyhoZjDa2GxaCHu3Ptr7PAjowdNDLs6Fwzdw+C+2yhvQPEJ8wNNFmId+ma+ctPu8VK3bWYmRZk5Wtvgdxi36GU3JJgZ97f8O2rrd/7pAFg9F3mj+ueYcxlnXe1R5B9T+pNySLvCxQ3wfFmYgKj3cwFCVeMdyPf1p67lpwryoCzE12JZLHoW93zwnFHrebZJeKQWLoeY/VUceDwAihbLOE0Z7gxS7YujScjnsRtsHnLDW2kU9SFzknS66dwfF+HbzwX0mB60oNrU5Zr34qqVzBgpNgwIec9B/ptqT1XZNtCY09r1Hc0w4VHIyJ2C9zFE5mzQ/BarbaRRdvclpr8PJ+j0T+onpXwSbVwG690ooN7AVVYJPONJFSP7Yy3R3cMH6YvAMDusPM1+mU/cENKV6PekjkhBiR/h+DoWs6rYDr4J+hgsWvhZ461ECx8kwRHTzU9EuEvOxQGScRHlyM9EV1QQt8gPz6ibZSwrZIo5yU6bZG66SxF73jHWM1eEw9c+0UJxPO9e6Dv/6c1CXb1csYhA==
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
2.50.1.552.g942d659e1b-goog


