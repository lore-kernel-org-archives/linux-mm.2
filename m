Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B38C87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 01:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5546B007B; Wed, 30 Jul 2025 21:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D2E6B0088; Wed, 30 Jul 2025 21:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7CE06B008A; Wed, 30 Jul 2025 21:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A93366B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 21:34:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46A6F1DBBEE
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:34:11 +0000 (UTC)
X-FDA: 83722839102.07.E1185AA
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85F35A000E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:34:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DtPNsAKz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3EMiKaAYKCBcFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3EMiKaAYKCBcFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753925649; a=rsa-sha256;
	cv=none;
	b=U13ZwB1uJmmlWADqAMVMF//7ozS/MTokZQCd+ZLKgJymQ5/kw54Kqa51NMUFroPwGELht8
	KPCJzE4jCpbe+jheB9KfspNslc7SaTBPWQnR9aKx8tc3DyPlQ0xLrLGDcFD+IUd7/ftKVM
	FFJlExz69hrd/VdDVYgrM9vU1sz9VJ8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DtPNsAKz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3EMiKaAYKCBcFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3EMiKaAYKCBcFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753925649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a+R+pUDhLLfQRqY7ulzy0ZSPAJIfV+A1iE7M1Yu6mNg=;
	b=o7UOk0RBaUciLDBovrawRGck7Gs+8OFeKN0qpyAev1AS1Y/ZU8YQqGPW1a8W/X2fP6bvOQ
	bH6c4tUHNF4xUoNM5H9JH8tOHCkqU2U7qw5+OGK6aRFmApgvSc/+FH7Vcxe6ysJNHmh4zv
	bIXS/7T6SpMN4d+GvYNjGywMdAs7he4=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7641e7c233cso420440b3a.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753925648; x=1754530448; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a+R+pUDhLLfQRqY7ulzy0ZSPAJIfV+A1iE7M1Yu6mNg=;
        b=DtPNsAKzqYkkDgh941qdlXHWwcY5YxtOf+MHlHYNehIdtJmnL8aI93+3PlMpvittTr
         va3sh6ZRiHK271gPusdojRvq48PNXHMEylhfg4qUtbYxAMZu+xGmlCPqy6940Gp4+m3Q
         06e9rVB+19Zo5Ls3cSGD+35xBfpVDeuoS71At+IIRj7rxP0bc++Orc9DqizLqi01K4SB
         oO59p9xHiPux3x7CUuyEanXvVhBgdBGNMSPszxEFjFGt785koe1sgGk1fUig+3kq/MB3
         ocrWyAGSzha+CjMpltG1YOEkt8hRbIvg+mA9AhUoh/EW5Er8quACiTZfwOusIOqcFJR6
         VyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753925648; x=1754530448;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+R+pUDhLLfQRqY7ulzy0ZSPAJIfV+A1iE7M1Yu6mNg=;
        b=q4kGVQ8fJIwFx95foR2HvSlOOXePJ982a7pzIF/85pONJNNWyXALOcHB9EFBW8Pf7H
         Y6E8LP12eqmhDi4kGRpfZ46pVc7TpahWTIzsqaib4kvHOiVBrzEXhBKOfL2YDqsJ+mEr
         kpxa0Oq4Yz1CHiOtAofKjnXECCCuz2h/qb6sLAMrLu5XcQ67/hBnL09txd7C2iyG/3xD
         mL7cDXHYw/gGUkkroLCzLFY7fooMXsULs9UChrccXjD/gqTmpPzR6Tzx+Dp01N0sj5mY
         nhk9cm1+vfDXdCwT5+GRaCf08iCNFjLSPXXJD3igqx769xd8DqdsQ9+f2G27QSy1Rq3B
         so7A==
X-Forwarded-Encrypted: i=1; AJvYcCX9JHCLrEkqQK3V9COnyspnTTPM95ycdcwUOZcenS6VJSi4qnFzJ3TB3/ZQ9NiyJy+1uCvEzeMTAQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+ZeH5dhc05V5hPnAwft5gx4E7SltuzUNkUcnO6EYT6ojv0m13
	mpXZ6X5Ckr8MIT4UoYtFdTv8by7uwjXCjzlV924IzQW7qXoUJN9kr0ug2ZL1J9iE9F3qxrj9gcX
	KA4H1hg==
X-Google-Smtp-Source: AGHT+IFc+GuYPfa9fzIhYQzqHqCTOK+dIE+0wJqbFAFjp2yjLZ6zYOgtHRY8Tjmoc+W0/zRNvdykn1vxr8o=
X-Received: from pfbic11.prod.google.com ([2002:a05:6a00:8a0b:b0:756:c6cf:2462])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1586:b0:736:8c0f:7758
 with SMTP id d2e1a72fcca58-76ab161aa28mr6861606b3a.10.1753925648164; Wed, 30
 Jul 2025 18:34:08 -0700 (PDT)
Date: Wed, 30 Jul 2025 18:34:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731013405.4066346-1-surenb@google.com>
Subject: [PATCH 1/2] mm: limit the scope of vma_start_read()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 85F35A000E
X-Stat-Signature: etbeb6mfxciw85pbg16pqxodyijeu55e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753925649-68339
X-HE-Meta: U2FsdGVkX19R1nHyyQ+GLIgYcf7t1VIHFqTtYuqt1a2lzJLHPkwLOEw2inZMblSqKG/R7E8Xdmb6WCkjpGRdrNg5HxbVsIIhPetwtzfAfvOCYp6pZVFBAfoGH1tFx5xYEmKAlRt5lvIIC9cxFUG/Uswji1qvmY0ZI5ODVFE8Wm/LYicRnCAr+hWxg3E5FQzl1IZBr72oXR1mTWkj5K1PlOW0puSLc9L7wYb+kcdrLG/2K8Ofm7CrMPDY9tdm1CP5qsrqV8cV0Y6A8VXyI1NIs23QRiooBmoeHehrlh7yx7qm9og83OwXDnrcKSVL6jR5vRo2d3Icpfp9565q9ox4VpHAG1PT5PoXRj0jQMP1+TAyFGp/cKURPykeYx3AN3ckTETr8JryK1o8imvc7Bqri+HhjAqHV5ov/Jl5H/RmH5Aluq0tPQai6P6k25NF3L3RXX3ILKhdbi6FuFDb6nxbU4shuOpRR6GYQTjp/GltwyGTk7CJqqjCSLQ1JnOoMT6H5KPyR+TjGry5DQ3hi1A1UxG+CLNMinFqMxeDMxb2+bhNVVA9JMW9t5OZERq4hQD6T9Ozv+P3R0tSEJUsd4lpRr2CH9flf3gGq6c6WFk6VfaAGhM/Em78Pl0bhV1OK+jYKA+W8je86usH3717tIGrOnfQomgfM83FK4KDe91Kid00BCdrso+akA9deMEu8u4n4+MT7/r84BMZzzDwRDkwX3r1U9G9bMBglzd8O98xj86p/J1iibpVX8/Z+qEKspKMelC1u+tjdeQQs1lZYFpt9AJIBs9arLW8CHQBZ5alZOoRwP5rUvoTxX+E7RaE8EZAABMFDJ0HJ4qOfqff6clXk2XGkf3x+eQbllJzsvL+kqq/mSVxRYLI92XiVNjnSfFXHUmew3C/R6gvRZ/P08Be4+Dl5w11yoDy7BIneRZ8GAiR7W4DLKQwZCreEn2ERVjRGnqzdQzrtub95FH0WyF
 jee4XzHD
 G84IQsqvbcnfaFhwnRD99VEJWqcNwi1mcwdDNzYqV1U4e+PwOiNZmtRZGTlZkBTA/FgZP7Ycx+GQlB1KvsFcfRWl5Nbt5ZmWaRi5mEtJZwOQ6rAx1ilVTZrQ8dLC6xfBDo2cCs+rsXd63EOVq5GJHmOt8Y8L/p6/6ykdAEXwGSa6nVRitROW0B3i6I2Yrp89EUWcfRTavmxphpT9RR45dEVqEnz/UkFJ95pOis65SaEnhQvajrNEljHtwqO8SfG9liHmDwuC1THbcLfNKb6FlfH8E1iDWUFRkHrEqsxIe7EgSohTXrSL6YszPp1/FXu50S7pAZq0FX0LycWCZ+TLuB9nM2iMsmMyLbAYDgny+x0zzYFCISrI3lNgsCDhpAyINMEpj4BeRuQR/Wb7u2diY1yvw/K8xGxenCHFtKSsx+dRwREhb3yYHv2T7uXZZZrRpbooCCKwTpMC6AQZc+zE2D1LHiEneFQUMMLeOznRjqBI2Yqy+QrnA2N6LJE9uFjHfxoYpgEHpoUjAZxzvAzuRZWEy7NW3pUA9uz25vsrRK3tu2Rf6hJJqHDmFZExgSXe8d6mQ8YTjKVI7dDEejb3lCSr5vQ==
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
-- 
2.50.1.552.g942d659e1b-goog


