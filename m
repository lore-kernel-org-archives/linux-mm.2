Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93714C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749D16B008A; Tue, 11 Aug 2026 21:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9D26B0092; Tue, 11 Aug 2026 21:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FC76B0093; Tue, 11 Aug 2026 21:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3762B6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:11:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9E851202BE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:07 +0000 (UTC)
X-FDA: 85090838574.04.EF9F6F5
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2638140008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ERMgpdG3;
	spf=pass (imf09.hostedemail.com: domain of 3KMh7agYKCAMvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3KMh7agYKCAMvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZlNadoz9hw/Qazebdu35JxugcbAL2T4c5Oordu9rIQ=;
	b=fCjuhtkdKDLFEIcoe9nYi9huV61mvBCTRs1SJf/zRKLqlnDBvRLcHWVfo58edFr7+JLaY6
	sWrfm4OVEhkF2O81hHFW+ffEPgVun5wWeFAZoyYdLJ3vXOwKhmBtEn7hc8g3aZ6HqWb+8K
	R2Yby8PgwuoKioldunsFfnH+ifeQQ/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497065;
	b=Uv3O/zCnrPqGdRnTVaISSCtiLsjLVGlTg9J0DRhn7hpnA/tCWBhYl4wKgSAYJ7vrJgp3Bd
	H1U4RO8yVv7a/d2wBfUOXxezPysioKuW3Wrlwow6DgHiGcXihuRj9xMWiXtOgzQ+4LgmM5
	7Hs+IDKD0me6gFKc4N1qpA7I/AgXwf8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ERMgpdG3;
	spf=pass (imf09.hostedemail.com: domain of 3KMh7agYKCAMvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3KMh7agYKCAMvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb7049fa552so308844a12.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786497064; x=1787101864; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DZlNadoz9hw/Qazebdu35JxugcbAL2T4c5Oordu9rIQ=;
        b=ERMgpdG3YlsS0Cv5JTe/SMXpqTlBrbK9FO0jOaEfLmmZl8rBjIsEB21cK4XNRccYex
         THC1GLV6SL8unUULxafqYMoNHJGXnbEhtH5IW/oML1yO4PV7s7VB52YeGaUKWg0Z/5ND
         n32Ua6qX4QTbZ/PQvex2ooIGq7+fYKoBbzB3YHva76aqxa4X/F2PNoFY8Kka+rw53RcG
         bgXARn81p7tC4vpYg+ntB9T4gHyiNtTFOFwGEj1T1AZfQAivfAYw44K5nAhK0vLq0szd
         IIz1iiLEoNu68AA/j6824LtHCLCNogmnR6CIAtfjT3QIc6kqfayb5hK2Q1mr5WhtY0WS
         9Yng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497064; x=1787101864;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZlNadoz9hw/Qazebdu35JxugcbAL2T4c5Oordu9rIQ=;
        b=GTyGI1HmsLUqplNpAIG4xuP8HlIoL4Nw6RSfWtBID1die9XuDXUpO7zXmkAYV16ODi
         ibA/tPW/32ZBCGVjxqfLPWS11oO2Q9d0cex3lFNwJOCDgh9WBU3IiCKJL/RNtk1ZVYZR
         4+BK3va0v1g+eqti2HX71FEqT/FtAW7nAzUK5iEywypoJ5HghKf+wmTOdEwFQ4TY0Bpy
         5DnfIwe9eXXkMFpe+mm7pVH8B2OmkQaIMoxLjGCMhrPCVILOlg69juU65Ll11c3sD/Y1
         MrHLLNLbzNRT7NfZdRe/X6QD2zOPxi+ZUqa6fY/JtxZDkMtHe33eVQyLtw8BXFD0zvz+
         gyag==
X-Forwarded-Encrypted: i=1; AHgh+RoTMDxbFfqF/SP9DpXqG0ZS8sDbbnhUEifcB313l5ltqaiz9raQEmLS3L6aWi3gI4wjdUXaa5KICQ==@kvack.org
X-Gm-Message-State: AOJu0YyhAGZqBJYGNX6t1mXJ9T9ya3U/bo+kIJ4zQ4fLS4LK9YG/J7fA
	7VDtZxGYTgKZVpgOudW/78PEvxbqoGX++OeZ4/Q6E/vkI2kUm7y3sqsZsYNbCHTmPAt1EAbB7A5
	UnEbujw==
X-Received: from dlae9.prod.google.com ([2002:a05:701b:2309:b0:13f:9a05:46df])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c90:b0:38f:240d:b857
 with SMTP id 98e67ed59e1d1-393012cf07bmr1280322a91.2.1786497064329; Tue, 11
 Aug 2026 18:11:04 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:10:52 -0700
In-Reply-To: <20260812011056.902771-1-surenb@google.com>
Mime-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260812011056.902771-3-surenb@google.com>
Subject: [PATCH v5 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: m4ju7wnjm61wsa7d1n8y5mxgz6z73fu8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2638140008
X-HE-Tag: 1786497065-382424
X-HE-Meta: U2FsdGVkX19Hmx7DSExlufP4vd4NvNdIeXGOl8jyUt/5MVzc4JB+VDeJx8KTxZpWxrQAfWorq6beqKdWZxJ1RZIlnwSYQVUSmdhfFcuZVLpKWn0q+xgZZtfRMgWFXQKuJM7YUzHPouAHZsAPBjS9yOzbh0wtCR4bYYCSqnYWHVK7nQk1ESZtJMV9Hcj6jFCx+vHh2Nh6s8F+U9y+u7d9wXyOJEg4h3mVI4CgF4xqe7naq+qaEyCPaBx9tnzSAOyLkN2ctxo4bwzNXEEMxdTP+bbJK04nj56UtJYZZrjzVqwu00fTDZIiFY5XLncGvilANKSCR3Lrju9BrEYY8DmA5UehcEYWOUYj1kulq3vj7vjhTAiS0whjfarw5M3LQBDtV2lN9UEfYcr1eaErMvZmYiXXQxp4CE1qO8ciTGhdS/SEEwJzEjnExezD02Hxdoa95eZKDmAtrJhy4BZpxz9xEG9Enf/Tz0PCXsdeASpXcgyXMGYaD694ukvrejv6JwHQTSEsDdGvl0rnDPdhPd8DiSG+qyrJSFOv+yK1ZGU2x7bT5AjR+WhOd9VnvGEuSroboM17SMlsf3Cr1GCCjYHrY9M3M16p/VncvHyvSY5EmnumwlBDCE0XttYOCRfBYi2KORh+DRp0SyXLOjkKs/lo+dbwAhtyGRhmWFAOcUfleP7FKRQ/40ssQJ9TjoaOWl3qZoxEy1GrQEgW3EMixUmFSQqKF+KVpM5MbmBSxctqAnluBL4cx1d6uA7qZYWvFGwQHkaT7cxN/OATTG3Hsn6B4nNbGuqKiffEsr0U4kJruAiVQiB36ldLeCFZMA32nF6PHcpezuIReq9IMRkZL3IOiObcBE2vADO9+9bUrslGvHcy3s/owHf/JYHpmE0xWkMrv4QXviyKQ7LmyasFDbi46+6inSi/UpggUD1rAlWaX3MtCIYZIKRXQBByd33IwZoHfH2J/C6UrxfL1/Ub9NT
 IC9zlJtK
 kiDvtpd+ottthztmmhwA6na50/uM6TwZJuLiitgwsX9DpKbz4cwiOtrjf4iIePoic3aiaheOgaY9eTM2pYKmbBnobre8b7ZZdwTniorhujYGIGj0RxZ3UHCZMg9l6O33g8RXFjKXewlKgYF4pbXqyMpuaKPTMtm3ylFJDt2pXcJWQSGYzPsQq2NSMq8VwBlHCb4YqNb4ECWoDsEQKyEYgBJydIGC8We6+9BUPBQR+HZBYKdGFYfzvTY3eREkxWmeOxCKU/bb21ACWSPNQSo10ClU+pOhRyCyqzHbRgG/+nctbf3HchXQMl4jkvnvOyUG02brsvJk8iNr9w0WNxEqQ3m6UZW6I+8aoAr18PWdVBbrw1AuvEs7XdNDLq73Gry8HAPIBdlBzOie/6SU9ioOuDQx6kKNQBUkNa4J3C1lRQY9NjmKHXb/GXkkMAqgM/wnTSCJIdwh4dbmOKGH2U9dq5XjD3hqfCZybcJlXMEklkTg7SSp6NhpL3K3A2ptAZ6jIgYdmx/z7AnmAUxdInviSHshpBL65aNphT8Q8PIq1riIcoYtMgrEyIwRm321HrtFLeF3DNC6tAhGgngeFWCKImzzUTzEwu7PKeWY0XETGpLfuPOGPn+NNLm4VldiI7uoUwbVizMsyCkURe1HDhE/WxtX/EX29ZnTRS2B9+2ReKr37zaaEKKFZVA7pI5VtUz9F2aJ9BvVlasS7XWcWELKTEj21VWTNDJ1ojbMLlwyrNXLuIpg5SiPyIRRDDzf5SN8QM/NMxZmWbvXthkdMOfrRUyKav18VzpbJoaufWe3gnyPbm6b5s3L55hFtAGTyGWuFP0wdMhfaUXgSeg7DOie/34YC0yLeD1y+iZRPACMWm0Q6oW5gKh4H3S3f0WbWFwaPwAe/kVQVjD+4jOqSp63l/Z7mBHH8VCRjPPFqQek/RxvZi73/TbeJKw+egApBhq4b6etj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
it and mmap_read_trylock().

Long Version:

=3D=3D Background =3D=3D

Historically, binder used an mmap_read_trylock() in its shrinker code.
This ensures that reclaim is not blocked on an mmap_lock. Commit
95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
support for the per-VMA lock, but left mmap_read_trylock() as a
fallback.

This was presumably because the per-VMA locking can fail for several
reasons and most (all?) lock_vma_under_rcu() callers have a fallback
to mmap_read_trylock().

=3D=3D Problem =3D=3D

The fallback is not worth the complexity here. lock_vma_under_rcu() is
essentially already a non-blocking trylock. The main reason it fails
is also the reason mmap_read_trylock() fails: something is holding
mmap_write_lock().

The only remedy for a collision with mmap_write_lock() is to wait,
which this code can not do. So the "fallback" after
lock_vma_under_rcu() failure is not really a fallback: it is really
likely to just be retrying in vain. That retry in an of itself isn't
horrible. But it adds complexity.

=3D=3D Solution =3D=3D

Now that per-VMA locks are universally available, lock_vma_under_rcu()
will not persistently fail. Rely on it alone and simplify the code.
The removal of the fallback does not affect NOMMU case because binder
driver depends on CONFIG_MMU.

While at it we also make the handling of the cases where the original
binder VMA is gone consistent. There are two cases to consider when
Binder VMA is gone:
1. there is no VMA at that location anymore.
2. there is now another unrelated VMA at that location.

Before this change we handle case 1 by having the shrinker proceed to
free the page, and just skip the zap_vma_range() call. And we handle
case 2 by having the shrinker return LRU_SKIP. While either behavior
is acceptable, we need to handle them in a consistent way. Handle both
cases by freeing the page without touching the VMA (skipping the
zap_vma_range()).

Full disclosure: I originally tried to do this with
lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
trylock semantics. Claude caught this in a review and suggested the
approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
I guess.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.=
c
index e4488ad86a65..c13a588c37de 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_he=
ad *item,
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked =3D 0;
 	size_t index;
=20
 	if (!mmget_not_zero(mm))
@@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct list_=
head *item,
 	index =3D mdata->page_index;
 	page_addr =3D alloc->vm_start + index * PAGE_SIZE;
=20
-	/* attempt per-vma lock first */
+	/*
+	 * Attempt per-vma lock. This is essentially a
+	 * "trylock". It can fail even if the VMA exists
+	 * for 'page_addr'.
+	 */
 	vma =3D lock_vma_under_rcu(mm, page_addr);
 	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked =3D 1;
-		vma =3D vma_lookup(mm, page_addr);
+		/*
+		 * If the vma exists, we can't continue because we cannot
+		 * remove the page from the vma. However, if the vma was
+		 * unmapped, it's okay to continue.
+		 */
+		if (binder_alloc_is_mapped(alloc))
+			goto err_vma_lock_failed;
 	}
=20
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
=20
-	/*
-	 * Since a binder_alloc can only be mapped once, we ensure
-	 * the vma corresponds to this mapping by checking whether
-	 * the binder_alloc is still mapped.
-	 */
-	if (vma && !binder_alloc_is_mapped(alloc))
-		goto err_invalid_vma;
-
 	trace_binder_unmap_kernel_start(alloc, index);
=20
 	page_to_free =3D alloc->pages[index];
@@ -1182,7 +1179,12 @@ enum lru_status binder_alloc_free_page(struct list_h=
ead *item,
 	list_lru_isolate(lru, item);
 	spin_unlock(&lru->lock);
=20
-	if (vma) {
+	/*
+	 * Since a binder_alloc can only be mapped once, we ensure
+	 * the vma corresponds to this mapping by checking whether
+	 * the binder_alloc is still mapped.
+	 */
+	if (vma && binder_alloc_is_mapped(alloc)) {
 		trace_binder_unmap_user_start(alloc, index);
=20
 		zap_vma_range(vma, page_addr, PAGE_SIZE);
@@ -1191,23 +1193,18 @@ enum lru_status binder_alloc_free_page(struct list_=
head *item,
 	}
=20
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
=20
 	return LRU_REMOVED_RETRY;
=20
-err_invalid_vma:
 	mutex_unlock(&alloc->mutex);
 err_get_alloc_mutex_failed:
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
+	if (vma)
 		vma_end_read(vma);
-err_mmap_read_lock_failed:
+err_vma_lock_failed:
 	mmput_async(mm);
 err_mmget:
 	return LRU_SKIP;
--=20
2.55.0.691.gc56d675ccc-goog


