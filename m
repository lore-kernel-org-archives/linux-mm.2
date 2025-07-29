Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F48C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B640F6B008A; Tue, 29 Jul 2025 10:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B1A6B0089; Tue, 29 Jul 2025 10:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50646B008A; Tue, 29 Jul 2025 10:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 989356B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:57:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4408812B9F2
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:57:15 +0000 (UTC)
X-FDA: 83717605230.06.4C55715
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93075C000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:57:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UNBRXsVp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3SOGIaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3SOGIaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753801033; a=rsa-sha256;
	cv=none;
	b=YIJ5rTbC5hBUZXgUP0IafA5Y6eS5bzXDylg60ybeKvEA8PB9KZVYpqhvtJH7Q0gE/eSxHN
	7jh8skvXD3QolLzFhECTxYAXsALuUEVmpgJW8ZA1odoyDknP9PXLAL+JtQkWkp+WqctHQU
	jWirqSjYAK5/sk0WGnEUL8ntwAgYPDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UNBRXsVp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3SOGIaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3SOGIaAYKCHkprobkYdlldib.Zljifkru-jjhsXZh.lod@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753801033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rE5QaqGtBbgEZH/uZ7FzXjyerj3ccqofJgA61gtYGaw=;
	b=yyDNhuXqFeryT0WoJhARRebBXsdVtukaSNcE+FCvYgnK2EGV4Uh/sjIUis0PArK4IoVh/L
	RweXWMP3XBdGejKEWT/IDbOlRW9jz12vYiUHl5twR5VdJSJaVuI6RENl0jHj3yE1gwiD+6
	ky+cjHvEbtV2OUd+8fM69gzyydxqBYw=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b4d2f67d5so5588521b3a.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753801032; x=1754405832; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rE5QaqGtBbgEZH/uZ7FzXjyerj3ccqofJgA61gtYGaw=;
        b=UNBRXsVpgtpJR/F73Yd+zR8qJaDQeMlhg4O3eW88PfJYoNLvb4onUrKH/avNkmG8As
         VyF/PxHQEc9NgEl+C8w6wnfefyY6NaNLL9i6cbFu0HWfGXzdPiX6KkT/97KJsdco/Qvg
         LNoi8R6BkN5hNbvpVCycXjB9hAX04eVSFqjsveTGCAhD4aYHrK0yu7ebF4NhIWt7t8G7
         VpcI3Jp1cD1EZ4a7/3b1l7T051de13LO8nNeEsUsvI7OPEr5mDThPGuJCWERtf9yWRVS
         J1yJBtw7/VNk2l8WffNkx4OmdoY/36FbD8FtqSS2rrqvXCxJ1FUZ9VBDJmcxa9ahPA4E
         G88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753801032; x=1754405832;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rE5QaqGtBbgEZH/uZ7FzXjyerj3ccqofJgA61gtYGaw=;
        b=ASGaQ3Hs9WHmbL3y5LzZ8KVhaiijsDHWTFbA7t5u3tAKtVA0j5VHpMdIG6izTFgO9k
         8CPxHXweO7WfWBqL2rPHxPPku/OM5He9ygCeb/9zkYVqd5f/ryWKLJVbyTmDg8O4rhbP
         IvPqVua0cqpV4tBgE0g8pPguhSa8bR7tE6WJ45ouzwzD+9YHqTKbpCmuZTqSMSEphZGs
         m1ONX10MkWczZr0P5ahr8cTdVD5+2WT9RIj6X3E+3+/afzX/4czTh6/Ttt29whVClgvZ
         iZRgR1N+kmB6Ej1AJvIXJVQUBVpG/xoZfxi9W1UOXxDfEMRd9EJlifC5SRqlfdnhg+HD
         2pZA==
X-Forwarded-Encrypted: i=1; AJvYcCUdRT+XUBmVJYNj3z/4FwfsFuJIAPKDKZ91lFMv12FianiHrJnsLByI0hnxB9vcPuMLhiC88eFZYg==@kvack.org
X-Gm-Message-State: AOJu0YzqfEflwcdxC9vPVhZNiwrk6KV0EOEaur5l/DVYSuk72fayvEaQ
	WexEsl0nchEetZZHFeY5/naWrpFW99RgBd+/jGIK3MLI77YN8XB7soZJWwT+EbmZNgD392yzOYO
	fwCe7Fw==
X-Google-Smtp-Source: AGHT+IEyb7DFh1Ctr01+r2+P02e+x/ttb54C/yw3CRQSNoviHIgWG2NyMvi3eNyzh9bqPdN2qlAcWUvfG4c=
X-Received: from pfbhm20.prod.google.com ([2002:a05:6a00:6714:b0:748:f270:c438])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9999:b0:235:2cd8:6cd1
 with SMTP id adf61e73a8af0-23d701886f8mr24958186637.34.1753801032262; Tue, 29
 Jul 2025 07:57:12 -0700 (PDT)
Date: Tue, 29 Jul 2025 07:57:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729145709.2731370-1-surenb@google.com>
Subject: [PATCH v3 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 93075C000B
X-Stat-Signature: jt6pniqdzspqttfon388ti8u7ucqpt1d
X-HE-Tag: 1753801033-472614
X-HE-Meta: U2FsdGVkX1/Rv2xko7NMW5/ibql3tuNANYdktDNoYCSne89yc9WJfzY4cs+GWtMz8egAkEuwkIhyg4pl/6iwjXc8wqsqCgp5opENZysUzlfjq8f0q7xd1CfVdDI33U9qL+r3+Wg56nkLE0br4HLxvSHQADK/nRVMaWYbI/js0WaloInG4uSWW/dgQIblHJQp4FkN+EDo8jKHcQ9D9b+JUM8bNhP9khWHIlB5FyozJFuvVAVco4sE29MvFCoK/sIRVNNmLmYGBk0Qmq7wQbE5R9QgnEQ32HHuNCWk7qw7rOfSWK6uc/bcEDcmP3PkeKPJiNgdMbJZDA+ilhqAWuTZFyIZu4SESlJZ+mI5mvjKfU5t1JE3nX/reLT+6aXxfkNfC7fU6LiIv5GXNZjgHaZ4TlJkQ+cvOn6hSdREdcBuHc3lN6F/6CH9jACwcEakWwCqbPyK7foQ+RzXqln5+qvDVZ2nsbJGierXPy+6kuw68X0wnTecKUsQTAo8zLUmMTpVlNe/+yqq4uv5qoeNa9ZyClv6V/9CLxK3XO1Fe1Nj5fH8uOnaPd2QtF6phfvXenIrqA26ajP/u02lVscXC9P9kKLL5FxOLhGozAm9RB0hG41c2N8kXu5C0XRjoMRMK1tPbNmef7ZrBuHC8g1LEUaemtOfdnhJmdRXAjx4neR38Ccx6XvW9ZnMeaaawMsWKXLD95WqjNYTF849/20l0tWcmyn6u4GnDo13kAlPwQK3laYHmDxpl+7HYAWYwMYdvIn0ClbuX3ZNwcXZqceFhAumCB6mxDPi7RKbspic6JKFgfengVC25H+OJWDXaaxZPE5OpXCOqRoJmLug22Gejx0cfk3y8YeUP5RI5JolW5X2kEwXt8rRq4v9Y3GKfMx7gtOJrpAwxCaVGe6pAzssbtzSiTD6tfqAXc1hLlaRO57qJ8zkQDNsmtd5ceBI1ej0LpE8Z0XEktpFVIRmXF55zQX
 FdhJ6U6V
 AOvrzp3yOStfvWyV/eri6XfWbbKk/VcXbulFiPAX7elDEtq52P4x6jQRy65ssd0Y8n5Ab6BO+eSuqcmHh+KYX1rw4Owk5S6jBoEKo1EmOO/7ZScG7EVaKicd/9/2XjwJxRUQRq+1y5ugu1hPxOvc1jkHWu6+iLsNJm2onRp6dyjfozf/VgsikU1XSXRHHJFmjwrNasDQnDTqZHsl1efOZJJJA0OyM+UdyiN0+nW9KkWHdducl0hlSX6sdFvtAuQA+/MHRJ2MoEtOYjGHuOqkRhUrbr/HvvV/9uGpP4iQCfNiBNF8GuPWWNWn7e6bkxcBY2ujc7XkHEesuTnYU0VSreiulJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By inducing delays in the right places, Jann Horn created a reproducer
for a hard to hit UAF issue that became possible after VMAs were allowed
to be recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.

Race description is borrowed from Jann's discovery report:
lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
rcu_read_lock(). At that point, the VMA may be concurrently freed, and
it can be recycled by another process. vma_start_read() then
increments the vma->vm_refcnt (if it is in an acceptable range), and
if this succeeds, vma_start_read() can return a recycled VMA.

In this scenario where the VMA has been recycled, lock_vma_under_rcu()
will then detect the mismatching ->vm_mm pointer and drop the VMA
through vma_end_read(), which calls vma_refcount_put().
vma_refcount_put() drops the refcount and then calls rcuwait_wake_up()
using a copy of vma->vm_mm. This is wrong: It implicitly assumes that
the caller is keeping the VMA's mm alive, but in this scenario the caller
has no relation to the VMA's mm, so the rcuwait_wake_up() can cause UAF.

The diagram depicting the race:
T1         T2         T3
==         ==         ==
lock_vma_under_rcu
  mas_walk
          <VMA gets removed from mm>
                      mmap
                        <the same VMA is reallocated>
  vma_start_read
    __refcount_inc_not_zero_limited_acquire
                      munmap
                        __vma_enter_locked
                          refcount_add_not_zero
  vma_end_read
    vma_refcount_put
      __refcount_dec_and_test
                          rcuwait_wait_event
                            <finish operation>
      rcuwait_wake_up [UAF]

Note that rcuwait_wait_event() in T3 does not block because refcount
was already dropped by T1. At this point T3 can exit and free the mm
causing UAF in T1.
To avoid this we move vma->vm_mm verification into vma_start_read() and
grab vma->vm_mm to stabilize it before vma_refcount_put() operation.

Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
---
Changes since v2 [1]
- Addressed Lorenzo's nits, per Lorenzo Stoakes
- Added a warning comment for vma_start_read()
- Added Reviewed-by and Acked-by, per Vlastimil Babka and Lorenzo Stoakes

Notes:
- Applies cleanly over mm-unstable after reverting previous version of
this patch [1].
- Should be applied to 6.15 and 6.16 but these branches do not
have lock_next_vma() function, so the change in lock_next_vma() should be
skipped when applying to those branches.

[1] https://lore.kernel.org/all/20250728175355.2282375-1-surenb@google.com/

 include/linux/mmap_lock.h | 30 ++++++++++++++++++++++++++++++
 mm/mmap_lock.c            | 10 +++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 1f4f44951abe..11a078de9150 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 #include <linux/tracepoint-defs.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched/mm.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
@@ -154,6 +155,10 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
  * reused and attached to a different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
+ *
+ * WARNING! The vma passed to this function cannot be used if the function
+ * fails to lock it because in certain cases RCU lock is dropped and then
+ * reacquired. Once RCU lock is dropped the vma can be concurently freed.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
@@ -183,6 +188,31 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
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
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 729fb7d0dd59..b006cec8e6fe 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -164,8 +164,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	 */
 
 	/* Check if the vma we locked is the right one. */
-	if (unlikely(vma->vm_mm != mm ||
-		     address < vma->vm_start || address >= vma->vm_end))
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
@@ -236,11 +235,8 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 		goto fallback;
 	}
 
-	/*
-	 * Verify the vma we locked belongs to the same address space and it's
-	 * not behind of the last search position.
-	 */
-	if (unlikely(vma->vm_mm != mm || from_addr >= vma->vm_end))
+	/* Verify the vma is not behind the last search position. */
+	if (unlikely(from_addr >= vma->vm_end))
 		goto fallback_unlock;
 
 	/*
-- 
2.50.1.487.gc89ff58d15-goog


