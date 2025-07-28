Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64488C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF25C6B008A; Mon, 28 Jul 2025 13:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9636B008C; Mon, 28 Jul 2025 13:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF356B0092; Mon, 28 Jul 2025 13:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDC5C6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:54:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91C1680389
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:54:01 +0000 (UTC)
X-FDA: 83714421882.27.924DDA9
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id D506A40006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:53:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wn/931J0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3NrmHaAYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3NrmHaAYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753725239; a=rsa-sha256;
	cv=none;
	b=tXIhwLX67l3n1+Z7MGisU7XqUSrA2D5k0lVEESu09lMWz0j1Z44w7pQGL8P9W6NuMjscPL
	X6w4rPkrBQseCkN0SD4oHTUenevkoKtKYNE7Yl8Vk6uGfcKbo8wDhhqnxVh82Hw1Z+pxTZ
	f5JKcK5oD9EIm7lvnZ4Ytm+YDY5aI0I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wn/931J0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3NrmHaAYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3NrmHaAYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753725239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CsmkSz7oeq7HMJDzlu8bMB8qretQ/dwlis7q/g4uBKU=;
	b=7ym7XTC0xXV7EWBxr04cB5r9bi5/QGRGtI8ZEWXKAtS0t6J8I469PEZKlhMrUfDXdMWdKO
	cn38Zzu1fkocqA4Ge42J9rUreNEx0MzN6/wBQ39/8Tj8SFzjv+tn3rP9Zn4DZiZ835h3Xn
	A3pbbbYFih6vrxrIbqd6qEvbMaodJqI=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ebadfb7f2so1544752a91.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725239; x=1754330039; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CsmkSz7oeq7HMJDzlu8bMB8qretQ/dwlis7q/g4uBKU=;
        b=Wn/931J09k2RlNKgc0C6Wv1sGPNj7wIhXbyJzxmndKEOUVfdGvf8Syr9aaPrlCPLQo
         Clv5fJGrOZ5Ro1Hv/JLcQk+tqdulNwgVeVw7AQk6fD0fcSMzBwZx/9QPW8m0SgTRyZ98
         z6ABy/evLQ2bhUndOxOvMy+ZJKr+ALQ2EKMr1FPQ/TmvfI4SQ+v3tM7Cz+hJnk3SBsRB
         YwEE0pO0gp/NuNd6QOaF0xa290alAL6+ym1+ucp7OEvxfXdu9wnNydYjYGNSCd0GMr3t
         0V6WIT6Y41GiHC8Y1ACG8JKY/eVr5+GxZnlgDbkExmmJ/TriiREVTefqj7Qb3IN3EJDH
         PpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725239; x=1754330039;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CsmkSz7oeq7HMJDzlu8bMB8qretQ/dwlis7q/g4uBKU=;
        b=X6dbPTFn22kPszUBHEs3kGXyWgPu36K9j5b/f789vBBnxmmVmAAWtlvBd7gIqAWJwf
         BWtGOXUhOw2omZf6f3JaD3mKwaTKyYwaEhL9BosYiq36QgpS2VHwMUrvgXTyCxEh7Ji5
         r1lboPRH/6YPLxWdBtXdH+HBJySj11gQCRcNFNvI8oT3rMy3ZOo3fVmk/qNIh+GmKXKS
         CvtKCzV5Flx/wnUMaVOXaWSi8BKWBhjCY/pMwXOvTIFbZNyVzYBs8TBhDgdDV9wpWYxn
         W84AVHksbnC5HkXVvjehLcpkvVu/JiIwXaUXaHKmdrGNH1NZFb8DMqj4DQ4FHrS2JDJz
         SsIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWWH8vCVadIDdm09jVY++CsZhVO+eeiVlhHhUUkNL+FQMW78PtsyYRqYAU6J1iY/JsW3P0vj1hhw==@kvack.org
X-Gm-Message-State: AOJu0Yxn2wZBYHUFljbbHAcs+Jx6VaZ6Z0W/vaLYncOjHaH0knNTrjxA
	Vso/E7XLwb+PoXlCnrbc1vxF3ZuXOtr1+NjXwTnAoJjdgSkzRNL8sXrck/YXocKGCIdBt5T+uo3
	8KkUqRg==
X-Google-Smtp-Source: AGHT+IGWBAtmMVPRkSv2vbxg+lJ0GqdvX81gg47Uv9TyhPMSsOBhXdi9Q/f4gBG5YR7+TJysH+MScLJ/WmU=
X-Received: from pjtu8.prod.google.com ([2002:a17:90a:c888:b0:31c:2fe4:33b7])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514c:b0:31c:c434:dec8
 with SMTP id 98e67ed59e1d1-31e77af1e9amr18091051a91.20.1753725238711; Mon, 28
 Jul 2025 10:53:58 -0700 (PDT)
Date: Mon, 28 Jul 2025 10:53:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250728175355.2282375-1-surenb@google.com>
Subject: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D506A40006
X-Stat-Signature: j5zxwyi6qs7ao337mzwpc6qmrur4bu5f
X-HE-Tag: 1753725239-788298
X-HE-Meta: U2FsdGVkX19zMS45cvqXhy9RDbzENZwvSvFOXedpP/MIjQ6C7luuRb/EomJcpqcMh/EU7X7Q49762WycWi0GjgwmHXq3SFc6lvuo233vgxQKhZmgj0ljv4bn7pRGNyVIfkK+4MpHMolA2f674y1qNMOHTZKDjFHvdmrD3Fq6Mwxym2Zk4Ud91bhInwYfutRNuXah/2fjjsExsJUq25LLELa8e32KSr5qkAEkPO+wW9ZKAv5qAsrS7L6Lzf827i7rR6TFK0fu6LHP3a0R+uwoZig7+qZdYK8aDSdQs8C6wmzFGBt3zgEGoV9rMkReT3Xewy1+h4PcNawqYQxbmNzxQZvTQOHwZbzTzjTLhsBE3rTJ/HHQIvtijfxsN7VeYX4tJlk8QIP3xQWCPIMAuj4PJ0AUAWdRfbPuuQGWh2Mdl9CXeTOx3C78bDE3keR+k12ulIRONw8+kRa9nRRLAFHuTsVfvYWk6g/Ad+6QwcdfnM0YY7EEspT8H/Yx4vNIPMqTw24VsHhedSeYgIezeFoB285TAnCveiqfSrcuvUMyxEyGITAunjou9OAIJp1Yzu+j46Ab9+Isr6IexUuXrfOZ8hTsm52usAezTtaVFZtn1FBW4ZAmEuxdSC0ew4kL1/3mp6hcOgwj4l29K2j2LjWoPDD9i5h86HEYI52KQkkpm5RU5IZJInQ7rJpsraRaEwQ1IdpE/itRys6Xvn2rCLrC08tbRw9ypZY0NZd+OP7uS/6yPtc3SBpmjhyffyXNDnk7mUsSBJK7fehVczw6WlgPd8eSssoUpbGYnntZOJvbpVNVqZ23xFKUJ51X0km9QOmrREN3G+mUvOw9Dol9830CUoY0sAa8C4lYR6ld+30AbkZqexu0n3gTb/B+2MrKQypW44c5M5mh1RSGUre6TDCiFhsqg6c9g56+/HYtymH82JT8zcO6w86vgixVT1zhoKTGl7X0eoSIZFHsvtDgi2H
 MGOLfmff
 J2OqGd6ASvDz14GXq/hXSRpH7a1lCZOLZs2yTiiTsa9cMOIXfyDXDKvzq68kM9LTtNfPpVYGy5XbIbz5Rh1qw0fhhQ0BXdhtzty/pjaKtKSjqRayhBluv5pAlAGvnuJqOuThKlikmexzINrJJG3uKhrAv3vZHNf8iSMGEfYba8aCSFLypqlgfIy9CmME0Y8XJ8kA2gG9nctpkCDWrixUNkqwtnE+L0zM1q3noLNpUbwmWAgNVJqV9UbQszhbVfeGRYl1Quu6whRbRBeCA37CURwPE13y3OP9jSzbJkkeuxf+Jml6vrWKTXgPZgGmb/EoSZ9bPK66mUJsfZQU52W551CEJO5IE5YA3qirflaG7k1CqZ/+E6WcGeKkViK4RhZR2cjnx+oUhSo53fRkfAxsD3ZrO/DdK+fkAfeT66EbJGMqChV5+63MuFfyCzcjpnAs6b1EOIl9ri7PqBy4iVOTkCTmXzdYvSqP047BbMlN7sYbOhpdFJLZlLNSedOuKFCcHa8MFffvGtulMx4xZvVSlEtsLhVLOxsEs8dVz1UaN7k9MEMkY8h+NG/jL4IK52MkQfp8HF4XYXf3Qe5Lv/LGFdkZieppWesNG5u88ll3/8C2Zj8Iwrr4FVSaLsLk/w96OjlrjxX1nMYDp+C8cBFhsOWosAPBIijFJZafS
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
Changes since v1 [1]
- Made a copy of vma->mm before using it in vma_start_read(),
per Vlastimil Babka

Notes:
- Applies cleanly over mm-unstable.
- Should be applied to 6.15 and 6.16 but these branches do not
have lock_next_vma() function, so the change in lock_next_vma() should be
skipped when applying to those branches.

[1] https://lore.kernel.org/all/20250728170950.2216966-1-surenb@google.com/

 include/linux/mmap_lock.h | 23 +++++++++++++++++++++++
 mm/mmap_lock.c            | 10 +++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 1f4f44951abe..da34afa2f8ef 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 #include <linux/tracepoint-defs.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched/mm.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
@@ -183,6 +184,28 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
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
+		/*
+		 * __mmdrop() is a heavy operation and we don't need RCU
+		 * protection here. Release RCU lock during these operations.
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


