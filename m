Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687A4606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zvwT7Q2x
Received: by kanga.kvack.org (Postfix)
	id 76B3C6B07FF; Tue, 27 Oct 2026 12:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7428A6B0801; Tue, 27 Oct 2026 12:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6580D6B0802; Tue, 27 Oct 2026 12:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6DE6B07FF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:00:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C054D1C4477
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:00:44 +0000 (UTC)
X-FDA: 85368869208.16.39E95C8
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BC9EC0012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:00:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zvwT7Q2x;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116843;
	b=rwmjFj3G5aeBQLCbXNMy143YWdQSpOApLD0G+qejMCMMELjWAsuKBeWkjv6cui+co7e7Pg
	Vp9aZm/a7w0FNC6hFDaQxGLgeGod3/iCXdgl7OUkMjvA+f1jm7iX1MHpLIeIqG3foeNVZ9
	DWRcOfYmldRjGH3ha2bkhoIjKlNsNrw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zvwT7Q2x;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lUFPvWUhnbq1nlKdj+4iPr3v7FCFuq1r2DJKFXSbd2o=;
	b=4zNDPQq6YPtDG+moSgS/Fd3dBalnCKUeKMDZ84yylRgj0MwjFguDqhGF5Qg3xYRzjZWaa9
	a0dL5WjiBVz4Ji3YcDrBP9zkPHlWnahiwXySyTQD9E4O+5YOiVHauRUr3SMROTAK6zvzPO
	jZVjJWmEnlj8Iwc0qXeATCmdUlhr9Hc=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso49378a12.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116842; x=1793721642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lUFPvWUhnbq1nlKdj+4iPr3v7FCFuq1r2DJKFXSbd2o=;
        b=zvwT7Q2xUtRqSljk2W7NU+Z77sCQkeTQ38xBrzg0yeg0CwN4ZlgJ9CL0RjuoC6o0hJ
         BJft/USImgH56nG3yGz7QFz9h22mhAwK96nVp2cRlGm/8k8nI2/Xl1XiAIT2ChpA5li1
         tRAIrEA+OogvTy6QObkze/DBf/R4gC+0cY46NZ7kIr0llTua1qHwfMu9wtmfQB9h6eIC
         wLE7FdFYjXGISgWMm7+JfsSjT4/boI0fH7A9aOPt5xJmFvpQhjIhKTSIa8VIC8h3nJ57
         Jm8Imdhj2LAufUzQecr8RB0VJvO1jExsADT1O7P3FHbfy33MMRqZjcG2885Pa52j97Ur
         SnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116842; x=1793721642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lUFPvWUhnbq1nlKdj+4iPr3v7FCFuq1r2DJKFXSbd2o=;
        b=qsXLkAxBCTGx4U7lyGner8+7ACVgRjN95Lm+gRiYE07z1gCqeywYzyBfFbpDgtNSYq
         S5hDEUkqhKXg9IVBdoFB1ky7C983pkkbYwC3TB12lMp5oHLTQngvRKXYVXq+Ir//wzdX
         SBcxyd2yMqxYT1NcIajLYD/hqp+Hwm8u8ynGnvNZmvBprrDEFVFfkBYoS9hLKTn2ANgP
         huienN/q166InoU6SUhR2LiYmt6rhJxXb6Q6TSBvLV1w25/sC1Ru6IKWlHFBZtquX2zI
         EWFf2TmGtwuaDrZ9M30u8W9Aha0B9z8uytf1PJixmVsFATueRyWfuIT6YY191unZy1EJ
         CTXw==
X-Gm-Message-State: AFq9FYKYJhf0ighrdetsnNeM2/DcLoRT/GmsjZZZIxSw44VsGxeDEp6J
	MPxuEdv156b1W9HLUwllsLCPqssekwIQx8N5blRy/9pjNMoSeZeqN2DicRMWDg==
X-Gm-Gg: AYBFou045zcO87HiIYVrRw0nuxAiwEPiC2QVMs+vyad1c0X4fG8JZY4G5sUFpkkCj8M
	Tuf7tFwhSR1unNo1Lw8pfIQGKrX3FbN6a01m0jhDhfY296RD4ChIK2ncK5V0Nt6EQwGqA28LqgI
	ZvGJgoERlXRplx5jtK7jrG4gue3aJ+v1Bdwd6ScXiKTD4Okrnhyt5G7NapbUBl5Dsy0JCAfbdhi
	c3hdmlW0+wo8rVc/dzxUCnTlHIkG/WYhHS6TsIcM5s1t9Ec1UZ3K4fOll2vQEVR+sjD8tYem+Zj
	mPcFJ/YreejdqqB0V5H9y+ilGo3ivT3H5emjMFs1FOT42aXJgpB6z7/xpA8j6NMT/7M0o8EVREK
	icylxJhLJ7Z1LmRJWoly8jzwx/mNCTTKpsikMvjWl12atDSa+2iPzjUW4Gxh1tDWLE9a8HIBH19
	yjxdrryYK8u6TzmYVfAjGMAESaaczBvgyYl/XMkgD5eoiEtObVJZmBv4bBJhW9k/2YzE7O33J8T
	RKmtvXCgrM0dUCKHudi0pEsbNPayILshB1DV2JOoJ4DobIpkzMm/f0PUoWwdW4jjB17TBEcCYTZ
	GQgd8bz+3qE3D7/eW2ktXH2NKv/DcsLTKy/nYFxS0/Y7Hb5FM7aHqBdAaZG6tYSYI05u
X-Received: by 2002:a17:90b:528c:b0:3a0:e4ce:31fd with SMTP id 98e67ed59e1d1-3adead444ecmr8771470a91.10.1793116841476;
        Tue, 27 Oct 2026 09:00:41 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4064f4bdsm4334209a91.11.2026.10.27.09.00.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:00:40 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 00/18] mm/swap: introduce priority queues for swap device allocation
Date: Tue, 27 Oct 2026 23:58:40 +0800
Message-ID: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BC9EC0012
X-Stat-Signature: gb7aoqfeteientz18uqnrb67ac6sogqj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793116842-431592
X-HE-Meta: U2FsdGVkX19zo6aIudP+rHoAvqJlhY6pwf5FImvFSkT+jFo/PzuFsbRhCL4Z8tT5Xp+R4ruVCKNeEhpIcBDkN+Dg26ymIzNn3g7EgpQ2J5s5E9fhYybXDCyou2SajnGzi6HWAkfnilNuKbNOS9G+jaZEesNflfxgxRBEF43xcGsPPNjIDRa2aXBqxStHtlUXxov9Agwbx2eFwv1ekZt/bcwsqL/Wtn8zWL738q+o4muW4ymBM+kEuUTq5Sl+im4iXAWixA/5bPRSkKUwXciUbZAqBP9yktlwT66hU08cnP0W1BScejJCGswy8qmNOw2EHVMzv0ukm+D2BYPEnVmj+lfPApw/C/QJ7K+NU4x8SovNUoVyExEIWHsp3rntP/QLb6q9WJmYQt8p1PP/x+bNykdApsDRVJ6uayoRH19w/WDd3f9sgwTdvb2rK4Vmi/30IVEznlJklOzazNp1Bhwe5XXXyw85sggrRU8etQr6Umyj/H2frl1gDcH9Loqc2ug7uNGCZlRk2WkGSGgjMssKf9bzHBsIrvbASRWp7WYpNg0n8AG6uGzPoJiiRruc+MdFpD6Sa4NAcoR4tE9zUOAVM3p5xAjoMvOdcmZ/+3f7MyQMGdGN/XwI41krSPLAuz2MAngEZjg4L1AEjKRmdp0t75vAS/ah+KUeuloXgym0Ye5NxshRbLBxz6Kdd3h8r4r+Ratc9QW8jx/Mq5gGaHZgYaj0cBFKgzRmepuQdSqFiRXc3R85l1M1H8heYqrR4eGvDSz/xclj3iTe7gkmVmOyRYCzT3qBJDyCN7YEcqXCgeM8x4BKf3Sz9riD5ydN6NFTbrkn/3LnMjkhyHwoqCVkQ1OrfIlgFKo6jw+8C8atkA/j7kp+DoYeFrg2DHYFwq1//pPRiRppzB18kkmK9BVpe6e6gxtEX8T2RtKvO/BsK2Cu0IkLuZU/6533e9yUBs1sRRRRvkt12Jy4pLBH9Sh
 nWI8DmUJ
 mKBTdT23+bMubm0LIi2SrV0TkQglZwwFWqsV6GSa06+InFwjhecRzAo6+tfg39TqnUhYE6ejgS31wGgsLWboj8alIbzw/AvV12L0OGnVfBv+MLJOtfShp3dq2nGz5k1HpSduJwle2Bc9ExlGZb95SMFaW3IUAbM9HlCC9eNJy4TgYHsr5l3s+by8bZ7ZZ5CUC6Haem/1PTnhb6Z7XOFYBYp4gDnkjsQo36eWNVndycPJJ1QZJtRI2VqXjSvo8TkcIMI/QdCtcngE/bCwP1RFFq5LtgW0IEZdXFRAdSb2GuOlCa2o/gK94uoSaoxC/zc6/VpkWiNwBdf1TLTeVuWROkPg+J6DrEWKoVeo93qeBE3s1tYS79/iQ22cl3B6iBpOQntOPfjtik4mwGPl2C7HM7KA/pMz+3mqUGXuzfHL7i95C1yMulpBh3/PbEhq6gZTkBE2sGP241XX0+0gJpUeU7CfoDV6WVbSjR/LnW+On6+odBb29MSTuJK7KQdrpzJmQjZ2nrtY/wmPPK1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This is v3 of Kairui's swap priority queue RFC [1, 2], retaining the
original authorship. It separates device selection from device-local
cluster allocation to support integration with the ongoing swap tier
work, while preserving existing swap priorities, the swapon interface,
and memcg swap accounting and limits.

The global per-CPU cluster cache couples device choice to cluster
locality. Moving that cache below device selection gives each device its
own allocation hints. The available plist's shared rotation is then
replaced by a priority-ordered array of same-priority device rings, with
per-CPU starting offsets and quotas. A task-local cursor keeps each retry
walk stable. Rotational devices retain per-device sequential hints shared
across CPUs.

This remains an RFC. I would appreciate feedback on the allocation model
and its integration with the ongoing swap tier work.

Following v1, the changes address related allocation problems:

1) A cache above device selection couples the chosen device to the cached
   cluster. Device-local ownership lets selection determine the eligible
   device before consulting its hints, which is useful for tiering.

2) Rotating the available plist changes shared state under
   swap_avail_lock. Per-CPU readers keep rotation state off that shared
   selection path, with a quota measured in base pages.

3) Device rotation was tied to cluster draining and the fast/slow split.
   Selecting a device first also lets allocation handle its pending
   discard directly, with a bounded amount of synchronous work.

The series is organized as follows:

  01-04: Cleanup, device-state boundaries and iteration helpers.
  05-07: Locking, writer-serialized publication and accounting.
  08:    Restore per-device per-CPU cluster locality.
  09:    Keep cluster metadata population out of direct reclaim.
  10-11: Introduce the safely published queue and remove the avail plist.
  12:    Bound synchronous discard to one cluster per device attempt.
  13-14: Preserve priority-aware throttle selection while removing the
         active plist and unused plist_requeue API.
  15-18: Reuse reader capacity, advance cursors directly, bypass singleton
         rotation and redistribute reader phases on membership changes.

Test results
============
The kernel-build and BRD tests follow the v1 workloads on a newer
baseline. The results below compare the unpatched baseline 4dbe24720eb3
with queue revision db66c58fac8f. The additional usemem and lock-call
results compare the same baseline with 18ec4b962755. These are
measurements of the named revisions; this posting contains revision
fdfe5fac0d5b.

Eight-ZRAM kernel build
----------------------
The workload used eight 8-GiB ZRAM devices and make -j96 in 2-GiB and
3-GiB memcgs. Each case had 12 fresh-output builds per revision, with no
warm-up. The workload source was fixed at 4dbe, using x86 defconfig and
the targets bzImage modules. The revisions ran on separate boots, Before
first; the 12 samples are within-boot repeats.

Mean system CPU time in seconds (lower is better):

                         Before       Queue (db66)       delta
  2-GiB memcg          4469.0100          4457.1575       -0.27%
  3-GiB memcg          2352.7325          2338.9325       -0.59%

Mean elapsed time changed from 170.1283 to 170.3675 s (+0.14%) at 2 GiB
and from 136.6125 to 136.6775 s (+0.05%) at 3 GiB. No clear regression
was observed in these kernel-build runs.

Twelve-BRD usemem
----------------
The same Before/db66 pair used twelve 8-GiB BRD devices and a private
memcg with 24 GiB of memory and 64 GiB of swap allowance.

  usemem --init-time -O -y -x -n 32 1536M

There was one complete invocation per revision. Mapped throughput below
is the requested 48 GiB divided by elapsed time, in MiB/s.

                         Before       Queue (db66)       delta
  elapsed time (s)          7.00                7.11       +1.57%
  mapped MiB/s           7021.71             6913.08       -1.55%

All 50 kernel-build and BRD invocations exited successfully, reported no
memcg OOM events and performed swap I/O.

Additional eight-ZRAM usemem and lock-call measurements
-----------------------------------------------------
A separate experiment used eight 8-GiB equal-priority ZRAM devices and
the same usemem command, with memory.max=24 GiB, memory.swap.max=64 GiB
and memory.zswap.max=0 in the workload's memcg. Both kernels ran on the
same x86-64 host with configs differing only in LOCALVERSION. There was
one workload timing run per revision, with no warm-up, on separate boots,
18ec first.

                         Before       Queue (18ec)       delta
  elapsed time (s)          7.97                8.59       +7.78%
  system CPU time (s)     175.13              192.39       +9.86%
  pswpout (pages)      6,317,548           6,317,684         +136

Both runs exited successfully and completed 32 workers, with no memcg
OOM events. The times increased in this single-sample comparison; the
cause has not been established.

Separate sampled runs recorded 12,451 swap_avail_lock acquisitions at
the selected allocation callsites in Before. Source and binary inspection
confirmed that these calls are absent from the 18ec allocation reader
path. Availability-update callsites recorded zero acquisitions during
both sampled workload windows. This shows removal of the shared
selection-lock calls, rather than an end-to-end speedup.

Current revision checks
-----------------------
All 18 patches in fdfe replay to their expected intermediate trees and
pass checkpatch. Static review and userspace checks of the actual helper
code with ASan/UBSan cover publication, ownership, rollback, selector
progression and throttle priority selection. These checks use userspace
shims and do not constitute kernel runtime testing.

Cooperation with swap tiers
==========================
Device-local cluster hints remain below device selection, so a future
tier policy can determine the eligible candidates before those hints are
used.

V1 proposed taking tiering first and rebasing this queue onto it as an
optimization [1]. I am happy to follow that route. Another option, if
reviewers agree, is to take the refactoring under the existing swap
priority model first, then work with Youngjun on adapting the queue and
reader scope to the tier infrastructure [3].

Youngjun, which ordering would fit your current work better? Are there
constraints we should preserve to make a later rebase straightforward?

The integration should have one authority for device membership,
swapon/swapoff publication and lifetime. Tier policy would determine the
eligible candidates before any device-local hint is used. Within-tier
priority semantics need agreement with that work; this series adds no
tier ABI or per-memcg device-selection control.

Link: https://lore.kernel.org/all/20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com/ [1]
Link: https://lore.kernel.org/all/20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com/ [2]
Link: https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/ [3]

---
Changes in v3:
- Serialize file/ref/writable publication when removing swapon_mutex.
- Establish metadata and writer allocation safety at their first use.
- Preserve priority-aware blkcg throttling when removing the active list.
- Add reader-capacity reuse, direct cursor advancement, singleton
  selection and membership redistribution.
- Present the completed ZRAM/BRD results with their tested revisions and
  sample counts, including the observed time increases.
- Add measurements of shared selection-lock calls.

---
Kairui Song (12):
  mm/swap: remove unused parameter for reading swap header
  mm/swap: slightly cleanup the code for hibernation error handling
  mm/swap: cleanup and document swap device availability flag usage
  mm/swap: introduce swap device iteration helper
  mm/swap: change the swapon lock into a percpu rwsem
  mm/swap: serialize swap publication before removing swapon mutex
  mm/swap: consolidate swap inuse accounting helpers
  mm/swap: add priority queue for swap device allocation
  mm/swap: remove available list
  mm/swap: bound synchronous discard during allocation
  mm/swap: drop swap active plist
  lib/plist.c: remove requeue function

Lian Wang (5):
  mm/swap: avoid direct reclaim when populating swap cluster metadata
  mm/swap: reuse per-CPU queue readers across priority changes
  mm/swap: advance the global queue cursor directly between priority
    rings
  mm/swap: skip reader rotation for single-device priority rings
  mm/swap: redistribute queue readers after membership changes

Youngjun Park (1):
  mm/swap: change back to use each swap device's percpu cluster

 include/linux/plist.h |    2 -
 include/linux/swap.h  |   43 +-
 lib/plist.c           |   64 --
 mm/swap.h             |   12 +-
 mm/swapfile.c         | 1421 ++++++++++++++++++++++++++---------------
 5 files changed, 926 insertions(+), 616 deletions(-)
---
base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a

Best regards,
-- 
Lian Wang <lianux.mm@gmail.com>

