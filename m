Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37111CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCB08E000F; Mon,  8 Sep 2025 21:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893E18E0002; Mon,  8 Sep 2025 21:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9B68E000F; Mon,  8 Sep 2025 21:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 669968E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17CB513AA9B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:13 +0000 (UTC)
X-FDA: 83867905506.11.CF3899E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E7D520004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TORna6B2;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3I0VmGs2kpEbMcr5q5JKcZdoO9Oa/TvNmRGysVtq0no=;
	b=7pmbkP9MU5pGezRsuZ4HLUWS+mqLhsQdWQM9bYvGEJ8Odi7KjwPBcFvSWZye7QE6pc16fi
	DDb9+zfY47kOXu/I6++kQjm/cEMrKPfBGWEsQx4PokUfRSXOSyPjxIQPAeILq5G8LQcrW8
	/n8znxWGE2ZZmoLKl9WMFFk4b8MsBJM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TORna6B2;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379611; a=rsa-sha256;
	cv=none;
	b=io5P3YnEefCrUoqjRQAPhj6FurC57jjmBrqlRJcCmuZrrXDuPKVwLc0aBFYM+WEyoHMtJT
	uwD4UQLWGTa4Bp8K7pz9Y1DfuDg/CGda8w3H1vYU9wo+fc0ds6zqLEEh4c0sQvsOeLiesz
	pdfbCOxbVYUZfnbWnMjE/7tyNuah0SU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24c784130e6so55841705ad.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379610; x=1757984410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3I0VmGs2kpEbMcr5q5JKcZdoO9Oa/TvNmRGysVtq0no=;
        b=TORna6B2hw4WZo0NFwXLWgFs+JEfG0dvja4kED14WlZMWXlbszpiS1CpX9II72XgM1
         D67LJEjRLe0xxsx1s9r42xYm6MCHO7VKGJnq4oQasTwfovaCTTQ9yFBnC84+a36Xn06x
         EFtJiNNHeJgiVloywZpw44tYfG+ARhz5Aaju071bxqnoVmpqHMpSiDJIBhwtjVObllFK
         e2L+fEPmZyjQHpyru9O88f1T7gOpFkU28m+kCOU1sWigdX3qL2d81chJCE4qxjPr4cuN
         Y3MvTpxmZveCZCFC7R8PNpyLjoZU+gPmL2AoNZ4fgpWMz5+igIrwBOlxeOtFkuumlXy/
         qxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379610; x=1757984410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3I0VmGs2kpEbMcr5q5JKcZdoO9Oa/TvNmRGysVtq0no=;
        b=SoduR5HmK0tyaVbAbG3ZiA0r9kRmFynJWmN5W0EhX03HjIrubm2kSxNG78xWUxX5y9
         cW6Zm8mWwYdEVBkIy9FrFzzPyEiSAtkUSML3cIf1j88DwRDHfsph2MMIM88FkMLPoACd
         eX4dsKB6llJ9xPTa3ZbIR5GYtCxC72bAGsfUMXbNIbB7SOSY+cr7kpAHGoiNjrPoU6zO
         CQFApRIyWkS4N7mmMtdvH23XauAlR5enbUbhnBACW/8F0MJ+zr3iAtDPfPlp41D3FPsx
         1L5YeSHkbGxhP+NYfAN/w5l09hBju1ic29lOJYG7+2kDDMzU+ZtoLPaKOEBut/98CpJr
         VMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVd9uWMOhWgP1f9Dd6oRjMYb9CIg/YoZ9BEJFPF1r0ukxMH5gxRYqKeRq3ejrhHnJoSLtP9V1+dA==@kvack.org
X-Gm-Message-State: AOJu0YyXX40/rcN6YVJlJzLXUNXEfDAUqEywutJCNUBvw9fl671mtRR0
	C7bQALOp/8I1676siHITnKNJNhDZm0RbcKeUgxJi3RCnHjzvQYoLmDmM
X-Gm-Gg: ASbGnctarTLJK1Fh4Ik2EyN4Q6v7RfExwkfFcv1N5kcJmwjQPbQDjiOa255EcGtVbrd
	SsnGGCYvXJUypJ6FgzPex+Dbit8fz47YJLAjI7FeOFlihiz8DdkB4PnELCciY5AbuN5QDfOG0jb
	3BADyDnofC6WGGYOCuFGAv9vLP871TuGWV0wfgR/CbxxRVCfBIMz8NMAD5RoD4vnnW0EUK/MnwI
	JHskYwHpwa+At8w5VRzXCjZ5naWJQlGSZ/Jt7lm+/WgotpkBo7tQecdKQByMygSwd/Z2M5qvD6k
	cul4ZK8oxQ4ScC6xsk9eHaDn8846VHLYabtrlJ4okQEPrjwsEKtNZo58gksB3aoChZMiGesCXlg
	xosb0YjTmGX0AKRa3Cl/p0M5VDls4xz96VEJv5imRqo6x0XRjidZeCrCJymiha4zoJO5uh1vafR
	a5N2JzrCT/
X-Google-Smtp-Source: AGHT+IEM2XoQeUfxViqxHUBGb9ymPiInaAJmBJ0r2R3U73+XlaqvewD+wzVN2Y2P6L12bEYs46pCRg==
X-Received: by 2002:a17:903:1b64:b0:24b:4a9a:703a with SMTP id d9443c01a7336-2516e4aeb33mr144178765ad.17.1757379609741;
        Mon, 08 Sep 2025 18:00:09 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cb28c30f4sm135606085ad.110.2025.09.08.18.00.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:09 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 0/6] slab: Re-entrant kmalloc_nolock() 
Date: Mon,  8 Sep 2025 18:00:01 -0700
Message-Id: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2E7D520004
X-Stat-Signature: iiq6gnnx5bgo1paba9wpdgo4rx6qdx67
X-HE-Tag: 1757379610-317013
X-HE-Meta: U2FsdGVkX1+JDCAvfeSwWDUuZkU2n7hEV2kfKIQk/WXZDKsWdc6a2s7YZ0XIiKzy3B5ESv+ERk4Y3NGQ/v+/558ja1rwPURgh2SlBwrzz+xdhCZ+Emm5/jX8rpZegw75hCrQxloKqaQyzwQ9Ay3lrFKDi9XBr5+tLHqyvSQJdHO1xPjXmci8c/zA2b2FEcvQhbOh3Wn+ZXf/ecu4TXNAyiJaJKcSE7YBbF+5SvoKK4vN/2hfLki+kLyr2nQZ5+HSyMeiYCj1SZTw1f1R+u9WVlULilPsJZJiCaDUZPhKjsNJtZr4l8PTyJkU0ugZ6AeiAxG5MnzIa4XdKh5fETI6UCnIz6PfUFFI46lquYqrC8YbgN+HvOphbwhgxAmNdNkL7i9OxCayQ54DzlIqlvxX/O5QDoYQblw/1fJsz80nGHOJVGOH2x+8zAIjO12tk4etokwc+61zjDVGfiUMjxVf+wJjq/X1GF51s68/x7sHlkNgzsoAxemXHAN4xtSDS7+zy2S+k9KsTQhV4xp01uBpiZEuYCTTHYf4pUL4WLW3VmSlPmCuu/ErjR9A2jfnk8UTO6OX65ec5MNX+KZcsoVWzzo7H3YOgvLhQJiT2+v359mcwUi0YOUHy0ril1z3WhWFqDrGTyOWeSQnirBAfoYbP84bGW4pKOVvmGYv2UvIEtP36sYkqmuKsPIqgOS/bqzjocecErOI0dr/HSpX+GIWhyLUNA9J1Knqm38uh5j133UleGtl2uZ7R+C04g5adqePuQwP+e78QRpWPXkNAygfhpJCglo9P5hNoOO8CeICEvYrFmaXTY5Kt0xtQSOaaOYHIhDsPjCkjJPReLbPJm4cVUUf5iLYMc2UBNtWTQIzCmPt6hzpieQyTGHxPTU3fxtZEwtgG/B7GmIrk0sN92+m/2Uy7q2hZbyNPHx1GdxE2NX4DqyB/dCRtHTZPNodD6ANhDejMugVugnR4JhKKM/
 0C0ts1aF
 ifXQiIxFT1CZJvEHhyIuzBKqpkiHgD6U+muRFUW9ins3e+25VM6rBfJwecz0pRMmauTob2xAkoFJdAGSJ5no2CcxYQjn+w205gY7+BjbYbGG5cQoJwrC0wjD9VUJMhtmHSFzyU4NcRl06cQPonJgs8AYRpbBGaoCViu9qN2Wf7tA+rox4VC+rG8fv3dniP1R2AgokIZfZymQTLQbE/M9W7+AmNg/rtcatXtyLGVU2lPKLV1XltIl3hBFCPacXB+XnOBAbVi2/P4fip8HAkahTSPBY0ed4MiFFdMt80ToZVljpR25WDIfDyqoI0YVXhqMGZhBU4IHuDMBwhWvyNaourDVAj2kg4p9reb3rWwDPULJ11bOlrTAjfbNNs84Xq+0S6VMr4TNSl5hbbOujqekVQKOZTwb017UCldLEfD5REHv+FxLRfXY2JBP9DXpmvzIIHKSyX5dfE02Nl9Fx1sneMHV03UqZ8WNgyxXFaJCcOVwEJCgtHWiqJMjbVnswFRr8PQOrJDhON0gyGhLvdvKIzpCP+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Overview:

This patch set introduces kmalloc_nolock() which is the next logical
step towards any context allocation necessary to remove bpf_mem_alloc
and get rid of preallocation requirement in BPF infrastructure.
In production BPF maps grew to gigabytes in size. Preallocation wastes
memory. Alloc from any context addresses this issue for BPF and
other subsystems that are forced to preallocate too.
This long task started with introduction of alloc_pages_nolock(),
then memcg and objcg were converted to operate from any context
including NMI, this set completes the task with kmalloc_nolock()
that builds on top of alloc_pages_nolock() and memcg changes.
After that BPF subsystem will gradually adopt it everywhere.

The patch set is on top of slab/for-next that already has
pre-patch "locking/local_lock: Expose dep_map in local_trylock_t." applied.
I think the patch set should be routed via vbabka/slab.git.

v4->v5:
- New patch "Reuse first bit for OBJEXTS_ALLOC_FAIL" to free up a bit
  and use it to mark slabobj_ext vector allocated with kmalloc_nolock(),
  so that freeing of the vector can be done with kfree_nolock()
- Call kasan_slab_free() directly from kfree_nolock() instead of deferring to
  do_slab_free() to avoid double poisoning
- Addressed other minor issues spotted by Harry

v4:
https://lore.kernel.org/all/20250718021646.73353-1-alexei.starovoitov@gmail.com/

v3->v4:
- Converted local_lock_cpu_slab() to macro
- Reordered patches 5 and 6
- Emphasized that kfree_nolock() shouldn't be used on kmalloc()-ed objects
- Addressed other comments and improved commit logs
- Fixed build issues reported by bots

v3:
https://lore.kernel.org/bpf/20250716022950.69330-1-alexei.starovoitov@gmail.com/

v2->v3:
- Adopted Sebastian's local_lock_cpu_slab(), but dropped gfpflags
  to avoid extra branch for performance reasons,
  and added local_unlock_cpu_slab() for symmetry.
- Dropped local_lock_lockdep_start/end() pair and switched to
  per kmem_cache lockdep class on PREEMPT_RT to silence false positive
  when the same cpu/task acquires two local_lock-s.
- Refactorred defer_free per Sebastian's suggestion
- Fixed slab leak when it needs to be deactivated via irq_work and llist
  as Vlastimil proposed. Including defer_free_barrier().
- Use kmem_cache->offset for llist_node pointer when linking objects
  instead of zero offset, since whole object could be used for slabs
  with ctors and other cases.
- Fixed "cnt = 1; goto redo;" issue.
- Fixed slab leak in alloc_single_from_new_slab().
- Retested with slab_debug, RT, !RT, lockdep, kasan, slab_tiny
- Added acks to patches 1-4 that should be good to go.

v2:
https://lore.kernel.org/bpf/20250709015303.8107-1-alexei.starovoitov@gmail.com/

v1->v2:
Added more comments for this non-trivial logic and addressed earlier comments.
In particular:
- Introduce alloc_frozen_pages_nolock() to avoid refcnt race
- alloc_pages_nolock() defaults to GFP_COMP
- Support SLUB_TINY
- Added more variants to stress tester to discover that kfree_nolock() can
  OOM, because deferred per-slab llist won't be serviced if kfree_nolock()
  gets unlucky long enough. Scraped previous approach and switched to
  global per-cpu llist with immediate irq_work_queue() to process all
  object sizes.
- Reentrant kmalloc cannot deactivate_slab(). In v1 the node hint was
  downgraded to NUMA_NO_NODE before calling slab_alloc(). Realized it's not
  good enough. There are odd cases that can trigger deactivate. Rewrote
  this part.
- Struggled with SLAB_NO_CMPXCHG. Thankfully Harry had a great suggestion:
  https://lore.kernel.org/bpf/aFvfr1KiNrLofavW@hyeyoo/
  which was adopted. So slab_debug works now.
- In v1 I had to s/local_lock_irqsave/local_lock_irqsave_check/ in a bunch
  of places in mm/slub.c to avoid lockdep false positives.
  Came up with much cleaner approach to silence invalid lockdep reports
  without sacrificing lockdep coverage. See local_lock_lockdep_start/end().

v1:
https://lore.kernel.org/bpf/20250501032718.65476-1-alexei.starovoitov@gmail.com/

Alexei Starovoitov (6):
  locking/local_lock: Introduce local_lock_is_locked().
  mm: Allow GFP_ACCOUNT to be used in alloc_pages_nolock().
  mm: Introduce alloc_frozen_pages_nolock()
  slab: Make slub local_(try)lock more precise for LOCKDEP
  slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
  slab: Introduce kmalloc_nolock() and kfree_nolock().

 include/linux/gfp.h                 |   2 +-
 include/linux/kasan.h               |  13 +-
 include/linux/local_lock.h          |   2 +
 include/linux/local_lock_internal.h |   7 +
 include/linux/memcontrol.h          |  12 +-
 include/linux/rtmutex.h             |  10 +
 include/linux/slab.h                |   4 +
 kernel/bpf/stream.c                 |   2 +-
 kernel/bpf/syscall.c                |   2 +-
 kernel/locking/rtmutex_common.h     |   9 -
 mm/Kconfig                          |   1 +
 mm/internal.h                       |   4 +
 mm/kasan/common.c                   |   5 +-
 mm/page_alloc.c                     |  55 ++--
 mm/slab.h                           |   7 +
 mm/slab_common.c                    |   3 +
 mm/slub.c                           | 495 +++++++++++++++++++++++++---
 17 files changed, 541 insertions(+), 92 deletions(-)

-- 
2.47.3


