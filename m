Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4DEC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53CE6B00A2; Mon,  4 Aug 2025 19:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDA36B00A3; Mon,  4 Aug 2025 19:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DEC6B00A4; Mon,  4 Aug 2025 19:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83FCE6B00A2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:33:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C13ABC35D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:33:57 +0000 (UTC)
X-FDA: 83740680114.27.E5C7DA9
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA5951A0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:33:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9MbFI6+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3YkORaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YkORaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754350435; a=rsa-sha256;
	cv=none;
	b=xCXy6Ck843c6YACpToGalh4Boj0pU7dxH3hgVOIJdGB4RKdklRh5qAuqu9MNRtZRAmBlJf
	/ZJMlDu/1UJsdluoe199ixh3Ey6FQT1WV5o94NfghnquX4TnfOp3f1SACxbiHWkf6BkV5Y
	0NUboiXcWtfbhgyyx2yHmwnKeAZ5lR4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9MbFI6+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3YkORaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YkORaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754350435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWnvQbLaliZ0jo0wCZxWQpnIqkjnNecbczSGEo1/eA0=;
	b=YZg/WlJP+bNP4NVM+Z83B89K1iQGGEBIvMciIOeMmxTNvDuf9d+Y6HssA9odE8FC+U7L4I
	rGJVjI058Z2KN+MxdnjfKk2HQaDogZfMj8ofEOL0OIpRay11ET1pLU2q+TLMmrgSNEPxcW
	HH3wITUaf+r/nuIT3yDs97kPMlROEpE=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3214259ce67so1523967a91.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754350434; x=1754955234; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWnvQbLaliZ0jo0wCZxWQpnIqkjnNecbczSGEo1/eA0=;
        b=u9MbFI6+DVgwd5IbQyxU2a/15cLeIWZ6mjRnzotxG7IftQcQLjBXCZzgCpggngg4BR
         FAr8uvvNYIY/mSwUd66xKxAUxFoOgadVWB10ieOXemBAtdXRm9gQiIscQN698F5bgwJy
         gQL/dc9U8v3tPko+UR+D2zfw1DO5447CPLzrjT9PZmGHiW78Gyp+Iyk8PLXlorKX6bWq
         uZ+6f3tCp88iooqbwbkICZe4vFjDRYseasltk/e2WykHT0cJ2N4j1aLUW9zbOeughxlN
         tsxhEDOGf/BR0OkQhd+C6uYxLMv1b0SE/02EYbVY0xT7Hro7aUDvzOLUHtC0ekZGWXr/
         7bWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754350434; x=1754955234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWnvQbLaliZ0jo0wCZxWQpnIqkjnNecbczSGEo1/eA0=;
        b=XfwdofAxQUy6xWdDxIpZ0Yl1QXaoRtLc3PcyL7ka1CMpDiDIcuec81ecqUnY3/icj4
         oh5OYxSikM158d833/fVFy3UvscmGsZd/byvNIwd5f6bnPfK+yEXoDig6BK3CqmC/lKx
         Pd2Zdloh6USyVdsC9sKyiUms6cpqwbYHcJsxYUMzV2VA2zpQURYJFjknupNXkeyHhKiK
         BEmx6QusTw0sRvsKzR28axlqtszCda/IgOLsBph3kLbM1lZCS5ZokfZGFHpooMTNBi8o
         NIgIvQ3ph+W3hpf6PignCCUh1H/BqlmBq08qv6x40x8ERsAygqvwmyC5E3EQlbfpLxda
         VFww==
X-Forwarded-Encrypted: i=1; AJvYcCXX7IrdGoU3a1V4L61r+KhepKHduFlkgs1keDcjMHc+PI+RIBmaSFqXWHq44nqjUIL1BVKwUjBeYA==@kvack.org
X-Gm-Message-State: AOJu0Yx1JJbayRA5YaZeG3ytx8KTZ5O3cYwz3kSfYmrpaI3aOJvQmg3G
	1fstPqyXb5XjVDK/XHyGxuSxnIDdisDHZE+SsWZP72AKqfgV9O8UbRAqMbT09aFpgTsAXBfNBUj
	bSo5OMQ==
X-Google-Smtp-Source: AGHT+IEuCG8ZHqraJFHyrAEoAYUtLmLQWL+oFRwQZZ30kqwMa0dI/KuSFYK+YyoSo6Xb3pey+QxBevkLsEc=
X-Received: from pji11.prod.google.com ([2002:a17:90b:3fcb:b0:311:ff32:a85d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a03:b0:31c:15da:2175
 with SMTP id 98e67ed59e1d1-321161f0728mr15680679a91.9.1754350434616; Mon, 04
 Aug 2025 16:33:54 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:33:49 -0700
In-Reply-To: <20250804233349.1278678-1-surenb@google.com>
Mime-Version: 1.0
References: <20250804233349.1278678-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804233349.1278678-2-surenb@google.com>
Subject: [PATCH v3 2/2] mm: change vma_start_read() to drop RCU lock on failure
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1qi45zdjaw1nx8wcy1c8cwidqzubeq4e
X-Rspam-User: 
X-Rspamd-Queue-Id: BA5951A0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754350435-594689
X-HE-Meta: U2FsdGVkX1+VMoilzCGFOutaZ56WWsx6K7XiWqzf+SuGuEvFgSBpSr7Rk15VKjEEg7PtH/T/9HhMRKkV7L00a3RXyyA5PH4gmFwf3feWA1LSAtccZP85TRCzntN92UofaFrz42fqVyD97EKjZUEkYm4Rh/d7eWeIdccBATnRHbW06vkoH60fUAx9eY5X1VJNcMH3xFQU/9Mn04uOexhOY3TzsLKW8/TTPNuNbPK5WZ1y4M0SKnTEh1+pd93R8KAhbhLZqLNGQGWV/f3ZcLtNALYRWRoAWsq7xHhOJKWDJBaGLw+JL3bSliqXWVAt0Foh2Q3zdz/Ciz4ASsFbCq527tliFEJq6SgZKXqxBaBowN0XnHcblIMFcAMcKiM0KZOHqlROxpsOsxYL2HC9vs7VA1mkpD4Vk9VZAbBLY2pBszmw5NCzRRKzLfxMcq8Jg71MHwAquL8thrw5g9vG9CQ0xnU307zJ3SSqKwm4K+Ptf0UB8CNuvZz+EGThIk6FXJavUK5jTfws+E6FD4/QYtWeRSASNggCAl2/rLDLDWfAn5zVDe9K2ZkqZjsbGJykjmrYdtXuDGgegYKnVAr56X0zxnyTDYwEfKNEhwdm3gQzwQTp1e3Ws+pdYmm0o8Wm+aswdfmNiV8pPHaw+kUWTpUxI+OTiquAU2updcLrgRSkPcGMajE3F7FjvkPeOSKsafk7xU+S5RZWgaLb6U7PqHUct81Hm0F4VrofbQlAdGhzLzirX8YAgLlNBIXiA8I058RkfrBuUtrzNzkAlrtf5SDn+3UGcXLsk+pLQN8gesjC45uS44sHcYbp11Ll9G+muVbaIwjNu8jQQTnfoqpGsee5YZ3+YhBG7KLBnbfEnlWgYA6ucuSKwCx9r7HGOeRilEvT8VxbkPTJslIft7pTwKxBXn7W27oJ5AFBNHqYGGici5CDPJRvk7bwB4TXJ1ZlrgaHtx8CnjJpzrgtnGMdqTc
 XmRyAQ4s
 bXp8+W6Ug/LmEvsQg0goSUGRbqsJV1n/pIYIdkCOk+ZPQpjbTdNufl0wrq6ZBFq2Aw3qUPJQEw5DUriBSMV8hXfCsdnwLXaekDLa0QFkBmx7nIKyEgUaUpvNN+KjtPxSNreII3eNjULUd8he/6tHjOp8Zy+F3sB9Du4EqxpmmGv6ppQ6EYSYb25pmAItPzq+yf1Ru5J9ya1Zafr9H5I+oGZj+ZVuTYhw7KoIo9D/6Mz/2+wQLjj+rtVG7TtjQrf8xrsFN7KeEYU2rXHQJXt2rlMtd4wRRQno8MSJesUDbqbrYrCiKDjff0hl+hQmAhCWZfx6gRy/XwyGW0sc=
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
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
Changes since v2 [1]:
- Addressed nit about comment placement, per Vlastimil Babka
- Added Reviewed-by and Tested-by, per Lorenzo Stoakes and
Vlastimil Babka

[1] https://lore.kernel.org/all/20250731151919.212829-2-surenb@google.com/

 mm/mmap_lock.c | 84 +++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 10826f347a9f..0a0db5849b8e 100644
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
@@ -247,18 +253,17 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	 * From here on, we can access the VMA without worrying about which
 	 * fields are accessible for RCU readers.
 	 */
+	rcu_read_unlock();
 
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
@@ -313,6 +318,7 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 		 */
 		if (PTR_ERR(vma) == -EAGAIN) {
 			/* reset to search from the last address */
+			rcu_read_lock();
 			vma_iter_set(vmi, from_addr);
 			goto retry;
 		}
@@ -342,9 +348,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
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
2.50.1.565.gc32cd1483b-goog


