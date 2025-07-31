Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A35AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A3D6B008C; Thu, 31 Jul 2025 11:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9044E6B0092; Thu, 31 Jul 2025 11:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819E56B0095; Thu, 31 Jul 2025 11:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67BFF6B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:19:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C4681605E6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:19:28 +0000 (UTC)
X-FDA: 83724918816.18.34AE6B3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3CEBE100008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:19:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U3SR7QUC;
	spf=pass (imf05.hostedemail.com: domain of 3fYmLaAYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3fYmLaAYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRIt8AKcHnKINXyvEkxYf94Yh7IhkF311FvqvgzwnyM=;
	b=ECMov0quxja8NtkjNaXsx4rfH/jnMJM8DKGqcppRx49q8rXb8sgDDKUgswTAFXZKj79TLs
	UE0HIQeRJtTeijGluI0NiyansilTvjlWh86B27qtYEItIcixuo7J94Dggb97QQLZAknlat
	B49xbyoTLGqUzef64spCTwrtp8g5Egc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975166; a=rsa-sha256;
	cv=none;
	b=7MobhBNO8mIhRnnY81nfO89/jx6CbDN38PF/RodICh/FlT8i9YR2mKt+oCFrFrJSn9tKgT
	JMM3ldIOrO6wJB/1EbamusL2YlOgcNDHaTWYyDj92Y6whviAb3puF6utTsFTQNFpXY3O3H
	ZaNdeWDOudZfudnk3RiEo3lDO9WngKE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U3SR7QUC;
	spf=pass (imf05.hostedemail.com: domain of 3fYmLaAYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3fYmLaAYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f729bf733so1561019a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753975165; x=1754579965; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRIt8AKcHnKINXyvEkxYf94Yh7IhkF311FvqvgzwnyM=;
        b=U3SR7QUCgYsZrUYwcohwP8gJ1WOJkfeglXdpDBMbCC0fLRdXyoADIUx7YHydGPWtRE
         u4mG8+NvGvejCOdlBWOnW2Ch9oTswM+TGYvNSDta6DcDMP1jhC2LXLpwKY7BdRzMUS8G
         oae4dHLp43CmE5md4rarNJiYWHXlvBXs7RotPjhKqdjVHI3ufJw9wF1owKM9ObS89i+s
         vSiK9fNmLYYNKTmzY3xuoWTR+xcNEbqRgpbvgKFc5AbtMgf6EGUzTxO6TLgdYG8S31g5
         EhShaNOfwI4saklwUSEt1tMFvQIRAeqNhFtsHJSQpAlStMINuxDTMCgOHQD27qPT2KG0
         Q62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753975165; x=1754579965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRIt8AKcHnKINXyvEkxYf94Yh7IhkF311FvqvgzwnyM=;
        b=s9MZlTWlp6Upe20eJM49qmLd5h0hpk4kNt5DHSE/x2XIic/EReP2oBt8Ae3Bn5BU0+
         dP9Ntip1DoHOF1MdcXKEMttjC2CU4ny4VQC+bhGcDgovhoVrwvcSZPXGs3x0XTZRT5Y6
         lQAabsMAz3MrxqWUhJZjZYTfBDt5vQhRYMM2/wn8DuHq+FVHwm1spxAcGwyJMH7rlIgq
         +AshVBapFUX0YhmzDSbGGpw5s07Kbrez0YN+UWsPgSQhmqCuYAHKMiX+HbDV5a/Djj1Z
         5wam565fWZHnwtl5lF4WDhlXzSc+fxCUw3e+8+L67zqMjW9wc6UjcSewSjOCOpDqb3q7
         pzpw==
X-Forwarded-Encrypted: i=1; AJvYcCUwHscjxqEOkVBWEK6MMzMTY4pIa5PyO7wdMtr30T9Q/ZBmxxMuubE+LNZ1rdxJ/lSn9rsftLouEg==@kvack.org
X-Gm-Message-State: AOJu0YwLx8OTCfo9PmJqOWqaWWfFVYFuN5mwf/3BQfsNUdhHvSRnR6eE
	ERySA52504ju6Ro2eCLmQA7ZWeD+DtF4ZbuUMUbkeFw/Oz9+m9lU+fAG5esEbthVD2zoFF/ezgH
	DqDPoLw==
X-Google-Smtp-Source: AGHT+IG+hqz8k3yQGzHNMFz+PXNcZKFUGe9Z5W3kyHUNP/PcUJ2Ofl9W0o8GvY+qmKvXki2uaR6Oh1vSMeI=
X-Received: from pjk16.prod.google.com ([2002:a17:90b:5590:b0:312:151d:c818])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2888:b0:312:959:dc3f
 with SMTP id 98e67ed59e1d1-31f5dd8ca12mr10609509a91.3.1753975165105; Thu, 31
 Jul 2025 08:19:25 -0700 (PDT)
Date: Thu, 31 Jul 2025 08:19:19 -0700
In-Reply-To: <20250731151919.212829-1-surenb@google.com>
Mime-Version: 1.0
References: <20250731151919.212829-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731151919.212829-2-surenb@google.com>
Subject: [PATCH v2 2/2] mm: change vma_start_read() to drop RCU lock on failure
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CEBE100008
X-Stat-Signature: ddnpmdf4wtthx9pobquc7h987oebzcsy
X-Rspam-User: 
X-HE-Tag: 1753975166-898068
X-HE-Meta: U2FsdGVkX19mhqsh/zo60fOqPvFL6Wj+XayDMfZE+EBAgGj1Hb3pVG7KcnyFpB6H0mLRIJY3zKi0g7FdCFCo4jh1IzqJGMbbbBcuKwGnV68acpsmQpHcfbmHoFNQ1jKK1yocmzmqIBnhKEw0xzvHXfgWla+tDZ1VmLI1BENilDUEORyuCYcIOcg8b1712S6SUlC4mr79WgmJk3/J7fFdtY+djC7jDvi548JVjYRT2xweBmH8EDtBIRqz99yMxwdqj4URmEbj8W0WZEHJsYA6eo+eXgpBPi5ZtJat5IOw8mrv4cvje/neZER8TegbQZH+Z/Jk3pngSVqMlCG49M+vDMfuLJEdqdt0033xRyPDsFNqLRHyl+bwSKse2bfZsnsT0FdXlMCwivr38GKOoE44Garlqri809ECCURQTIszRvHmuVs5YtwOpG9tp1oydXNh3AmAO1Hck3w3LI+tVqnoSzRhvbg2aBl4cnh1a31bOC5K9dn+5Q4ZrCrU3Z94M2Qg/n5YDMyaSG+s6PE4Ht/aroWQJL2WSKTQuvgmy5hyhSXrplD9s15UPGOK9QjK06NdLE/W5OPdTyYFy/PTJTYA1T5M3NJSQopnqXIoMOS0lDHcy0icTphpt/5YsXkUul1cpQa610ZUQhNl8++uPhVVOI89exqv6/BABbVLTqHzmCYGFFQf5t0y9HZJCV3yh4m8wYrOMR2e/Y3b+koWOqfpHmis81vxCFIksW4SCeGoB4X7gdUaXwTgaHSg02Hskr/2Nbwx+qaabe+m9dqsIvvIUJgA7A2kBgRyxr4nNT+thYnnlD6JIvjagc0rOba/qpK+9wXNrMvpuYEf0vJPijIJHGQLhp70suqsp4HKUph4EYnv19B6Ta3HDVmg6pecqQU6k96eG8eHz5KCJjuxgP0CquuGjEyldegqhnwbXMx8ghZpmHFAf26SVeZoL3ZpYkQmtWBlhmDcUiMK1j/sXw9
 kYI25446
 UVXRMxWbTlxqEEVAEt4ygWAxeTuk15C8apMY0d8LsTBxlSgho6Is2iPsnx8RwDfI27W1+BN2gyHbaq+h0jiltO9qMWa25A3+SvEQJOsQcGffH8iiTJN+PHcouEDmMHFv6tQJX4zpvftbMY9rY966p6XrTDQ4ecJDa4pJ/8f6NDlBkZUJwbB+YoDfLxHmhqdmmNR2FfKNfOG0q0Ys2ciR7PNcgoEXhvQ3xRvNOI+RM5j+K7NZotnJA55ZFUF+WZ9e1z8RwxF7ttoycDcvYV/fp0ZF32dc9NHBlkLdXv61mLCnNxJIf9zzGXdn4wjmDC/iv62B6b7sof1/8RzkEDMOlIwLwKhlm4ll6EuzxWDWMCN6712xXR3hM515jjYndr2PH43cOVIGqHVJywxnJBpGhOwHM3Q0wbLubiBKyYXRjC3zDgn1d8Og88J2BhpkgA6wgkAkX3RY4BsbbXwTafo7YXtuCxYM9myjLpGWPVTB2BoNwWpEH0UomskagZ3g7bkBIzyCLeOPhwgDsflcqB+JG0YDmbfHNzXX9N9bx/pd6cpHjG71v2GKUgbGN9SROKAY2xBUeuUKMEWTG828piQkV8U6yblOyqHRiS9dA64Oq2l72rrYteOXsn41cjgrlqqcGelw8vL4Ca9m+xcY=
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
Changes since v1 [1]:
- Fixed missing RCU unlock in lock_vma_under_rcu(), per Lorenzo Stoakes
- Modified comments, per Lorenzo Stoakes

[1] https://lore.kernel.org/all/20250731013405.4066346-2-surenb@google.com/

 mm/mmap_lock.c | 86 +++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 10826f347a9f..7ea603f26975 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -136,15 +136,16 @@ void vma_mark_detached(struct vm_area_struct *vma)
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
  *
- * WARNING! The vma passed to this function cannot be used if the function
- * fails to lock it because in certain cases RCU lock is dropped and then
- * reacquired. Once RCU lock is dropped the vma can be concurently freed.
+ * IMPORTANT: RCU lock must be held upon entering the function, but upon error
+ *            IT IS RELEASED. The caller must handle this correctly.
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
@@ -152,8 +153,10 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
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
@@ -164,34 +167,14 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
 							      VMA_REF_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
-		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		goto err;
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
 
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
+	if (unlikely(vma->vm_mm != mm))
+		goto err_unstable;
 
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
@@ -206,10 +189,31 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
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
+	/*
+	 * If vma got attached to another mm from under us, that mm is not
+	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
+	 * releasing vma->vm_refcnt.
+	 */
+	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
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
@@ -223,11 +227,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	MA_STATE(mas, &mm->mm_mt, address, address);
 	struct vm_area_struct *vma;
 
-	rcu_read_lock();
 retry:
+	rcu_read_lock();
 	vma = mas_walk(&mas);
-	if (!vma)
+	if (!vma) {
+		rcu_read_unlock();
 		goto inval;
+	}
 
 	vma = vma_start_read(mm, vma);
 	if (IS_ERR_OR_NULL(vma)) {
@@ -241,6 +247,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 		/* Failed to lock the VMA */
 		goto inval;
 	}
+
+	rcu_read_unlock();
+
 	/*
 	 * At this point, we have a stable reference to a VMA: The VMA is
 	 * locked and we know it hasn't already been isolated.
@@ -249,16 +258,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
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
@@ -313,6 +320,7 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 		 */
 		if (PTR_ERR(vma) == -EAGAIN) {
 			/* reset to search from the last address */
+			rcu_read_lock();
 			vma_iter_set(vmi, from_addr);
 			goto retry;
 		}
@@ -342,9 +350,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
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


