Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC439C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7536B0088; Mon, 28 Jul 2025 13:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AED26B0089; Mon, 28 Jul 2025 13:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4226B008A; Mon, 28 Jul 2025 13:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD176B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:09:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C122160391
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:09:58 +0000 (UTC)
X-FDA: 83714310876.26.4732153
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C3F340014
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:09:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=keMwUI35;
	spf=pass (imf04.hostedemail.com: domain of 3466HaAYKCKocebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3466HaAYKCKocebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753722596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eh6IvKrrVHAEt11I1o/Ron2ZJq2dRDEO+l/5Ggjas3E=;
	b=T7OcdsxPTVzHD+oGa7+dUgJmYm0G1g3T4RCgiYqQDvuCJ8j/bx6SM2hIxHePG23u4w5TqS
	OfkS4LrLqrIWWjyOhRAUgprjgfL8oLH2ARXIekvGEkjnYiYMiRZ3Pz+49RjRqJbZklZaL7
	hK4yQpxqLOf9v4a9m5Ovl2sD+KQazQM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=keMwUI35;
	spf=pass (imf04.hostedemail.com: domain of 3466HaAYKCKocebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3466HaAYKCKocebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753722596; a=rsa-sha256;
	cv=none;
	b=Ugpw+0YjRr3Nmz+uvy4Ob2kXkxzv6Mx5czoeTcwBiVO4ta4W/Xh0Q8JwMY9LQsVSwYWZlu
	ndH1vLggrrpvgmlpN/znW7YC3mcXi6JuyfqluVRbrtryydoYiTn6IHGk9JWJuOLhhNF7sA
	maKf92dZbbLFR0/o9KRQjh/4ijGsGZo=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fe984fe57so26736575ad.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753722595; x=1754327395; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eh6IvKrrVHAEt11I1o/Ron2ZJq2dRDEO+l/5Ggjas3E=;
        b=keMwUI353vUk7TJTqgC8p1Ef4BTNwWoWZ1UQNChAPsB2FrzNEVMmhsYexBTE3cle35
         xcCxArw8eBq4vsyl88Bv4n+ITP5ZHLZOisOmsY0lyhm2Bn4yshoLyoOWJ4jDF9tWYjn2
         ilHhlgDWec4oe/J0NIhWLQ5bd8CNgd2tF+poDo32ZC+plfC2suT4mNWb3cWllBbAuI4A
         bQwiFfvX7llIGTrCk1n0bTahF5s6FwUJ6ztx8uddZo887xQK52Px21KiF1gQNd1LTEIq
         y+BEHfYh7W+u8tiRdpm+U+QrEAYLbPq9rr+6zsBqj8CglCrrEVht8rvxssCSnzn7h5M3
         xAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753722595; x=1754327395;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eh6IvKrrVHAEt11I1o/Ron2ZJq2dRDEO+l/5Ggjas3E=;
        b=wqXaLg78Kn5cc/04yYpuFmq6hN97HSkkTaOt+adiXzxaopt6VR6rIR9+qhs/RCtIMn
         YNvyfYetAJ/EvlCNoZdr49JzW2FBiaT3QNYAky3YVGcmWawfFcYva3cNQUyDVkXm4Di1
         KkSUV48rigWjgp9yH02v3PGfs6tStZBjeiWb1T34cxLiiY+0DcN4O5RlZdqAwUV3Jkx7
         EQHgMsxkRyrsxPUiXydAHuxy+Z7yT+QhyCuGPZxO1+/59vmEFS0m+cW2VJOAXiSP7paM
         bGBP0Zeqe55pPwpA+wNNfGTHGPhVCTZV+1QgLzc6kXy1NIZTUeWB4DDDOLeq5v3d4IAz
         P1lg==
X-Forwarded-Encrypted: i=1; AJvYcCVd3b5EqQJitzMMIsImwzy/bdMfZaMQGkjmRaCbzhGJBF43iTb3FreZ5rtAHoWJRaSG220v32qFig==@kvack.org
X-Gm-Message-State: AOJu0Yy03Ih56dA2jqCtnfnnjlNf3x2aXnfBfpJxqyv4+c4ugIrPhTWy
	AILeqmDnevXRlr4hHUzgcflNk+isDWyjBvxt2ZNJIDmn3/l1+V8T9gVP+5qulf8v0RSpZJmDXq7
	CX/e0uA==
X-Google-Smtp-Source: AGHT+IFd2+VRWI3M+Kfoauwo/cT4HXIsIJL90+W0WrGWufYg6PKRrmk/3I6NP6HrbQ2n89hPQHxfP8Zj3x4=
X-Received: from plwp15.prod.google.com ([2002:a17:903:248f:b0:240:1be2:19ee])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b07:b0:240:4b3b:334f
 with SMTP id d9443c01a7336-2404b3b34a8mr26618875ad.34.1753722595188; Mon, 28
 Jul 2025 10:09:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 10:09:50 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250728170950.2216966-1-surenb@google.com>
Subject: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after vma->vm_refcnt
 got dropped
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C3F340014
X-Rspamd-Server: rspam06
X-Stat-Signature: 3s8cd5hmioqidsdxuke67astdo65k7mo
X-HE-Tag: 1753722596-982413
X-HE-Meta: U2FsdGVkX1/ANdPFrhsgI0DMTPgT81ueOtQ/WjH64W9U4jI+T3GflcoeH96Or4wY3jMvG9t1/K3R08jtx90FtPuRuJ79vrW5UaRIjCo6t2uUtT3FJhHoIytUmTPHK1XYvCJwG3TzZLYdI2S0vnUUANxNR72H6hG9Ioymd2PxB4bHpKBswKITtRBpeZ1gEFKbQKwY8xgINSG5KjVHdNWEcadnWTZnYndL5Vfl+CmuU4zPwZzTBTbjjNrv7bSSoRS8RpipdSKjVV3vMCwfxdY/ZviIhd/9twRh7ZvaEnlpD24gWw/CLT3tJqVvu5izc5Z5kfsoil6E+fQo6208kXdvNYQVobUTbodxTCOuHlKYSILQHl7Tdwa06EWyzNehyrZvGxZKS6ZiaLo7AXcawqiQR2D6qOWKtL/ixZ0pXi2k/moKL8sxDCsyF1Bq0VZ95jGwvND9/4SWb/9i+oJzUCHn/wdUL+OY7swX5TFnfOujb4vnh0YlK2UQlm36BRZU96H3XUZQFzEhJZcG3ZPUdWAhA353UtL8KbMNWzExAa4fAu1gzEwfifKnTlQeYFSzbqwTdcNRCRSQFj+yL3pAkVawitUHlW7k8hOa66K6I/6/0vA/OCrecQ/EBKYhq9OroMBcyo6agaNkrO/WwZeqBcFiqVS4jc0xDWLsyREzlnJZ4Sa1PJJXa5uoiQiv2PixyjQTfc51QUcOyb3c1CAIWIZlGAxWxylbxYhVzinxBcQ6ASNOAM0hFbIGNfTFUXxRv3C2jP4atyZD6rVG/mXbvkcqG1/xAoB9blX+M579KaPeTkg7wMlgHEXJNMJ36isQfuNUEWMpVwX6bwRm+ibjDX+viCWphcBuANeWHvxRkX0dkby70cvpMt8uhMpZnKSe+UD7qXglcL2M/x0z0pIj/XSOQfzg4vW9P0wUvRQHkUdeTtaNvvOctIUXUa8gXJyerp0FgSEdBiGyM1T45YzPeTi
 mEkoqyqX
 oHiZpAZhZsDIDws9SKt5vItsunv8m6PLNP2nAYAdIYi6DMh5XN/OzoxlYSMgJk+9OYAjpKkUS5co7JTKMIIONPGT0gmuDFytUoBk51IliGkX39rugpRvO3V5vs4LqdPxtI+WIwrwm2QPVNBg3iHIIR4lnI4m0GvXsfNSbrLqqqiCyNJbnkJatDIohDE/UtKOptceZ14HJSLxgy9Pd21ofdFQTBlx7G4JsrsXA4UiHDp0s6rwy8FfTczDHicuAqTc/8Qww/V03NMOnkzPQtrr2Y35smP8w/WG4P2sJse7XSt7eglp+/JDmRPeBUumTBSc0oL3SqblaInYA/rO7BPwJdwWyi/MoF0v6oijmEkzR43sgtILwDmACJGUVINy5B/BaRo8K4sfo5DRP7b2wG0m8rqSvBD5k2FFy7izI5UBHsnVyH7pLDjMpYGKxhKcpaFTzjJfC1G6aZUmNlNaCLj27oSBW0+s8ZttICetIz1KtyxYOK8bwh87bWwhPnxiPzV4iDmxAfOBwhAfx8dKxkxD4wjAVdH6ua5IdY1JWHD/DNdT0pF7KQQokz4y7B3I0+7RTnbGn/PGSL4TseFF9fpyD7r6cEIBCcBPkM8LkoyJG+4TKJPvB9xf7saE4mIUAaO+e5ZLgSTB4WeuJ2m9l12ocgiNZM9bbTAtp59+/
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
Cc: <stable@vger.kernel.org>
---
- Applies cleanly over mm-unstable.
- Should be applied to 6.15 and 6.16 but these branches do not
have lock_next_vma() function, so the change in lock_next_vma() should be
skipped when applying to those branches.

 include/linux/mmap_lock.h | 21 +++++++++++++++++++++
 mm/mmap_lock.c            | 10 +++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 1f4f44951abe..4ee4ab835c41 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 #include <linux/tracepoint-defs.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched/mm.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
@@ -183,6 +184,26 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
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
+		/*
+		 * __mmdrop() is a heavy operation and we don't need RCU
+		 * protection here. Release RCU lock during these operations.
+		 */
+		rcu_read_unlock();
+		mmgrab(vma->vm_mm);
+		vma_refcount_put(vma);
+		mmdrop(vma->vm_mm);
+		rcu_read_lock();
+		return NULL;
+	}
+
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 729fb7d0dd59..aa3bc42ecde0 100644
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
+	/* Verify the vma is not behind of the last search position. */
+	if (unlikely(from_addr >= vma->vm_end))
 		goto fallback_unlock;
 
 	/*

base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
-- 
2.50.1.487.gc89ff58d15-goog


