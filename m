Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A05C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0D06B0088; Sat, 29 Aug 2026 03:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A1A6B008A; Sat, 29 Aug 2026 03:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831B56B008C; Sat, 29 Aug 2026 03:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54D736B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:38:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C736CA0680
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:38:30 +0000 (UTC)
X-FDA: 85153504380.17.F7D30F6
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 25E2640005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:38:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAK+k6MQ;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989109;
	b=y8ziLtwoEbZkjKj6BcIevNfas2NXAKCjKMNprF5UaaNLy3vvODCxZw+Howfida319BgU9u
	2Pcugq8lvCvncvAVLufv/tYfCwF9ICM2e48tLIlimIJMdVwQ+yBvL9mKpm3CynaxpNRmP/
	xRElYoDEzeblQS+2JlaeEORWYc9RZ2k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AygLwoJ1AVtSpfiyYiWc6BhU8FQ//SlXkeaxEkXuQqo=;
	b=W8sQZ+t2N9OnXbvgvcpHxd9EsO/ApxNijlZtFPz6oe9sPps4iiNJZ7TYPH7ktsMHwbC84V
	4Sx7QOgG/XZyNTvyDR0I4nshqQLehqqqEwqLIQ+8iGXC7th42FPwVqlfZMqhT9fM+co74L
	JiTLDaMnbCWf+8lQEagvML+vtpVCvYg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAK+k6MQ;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso1620250a12.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989108; x=1788593908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AygLwoJ1AVtSpfiyYiWc6BhU8FQ//SlXkeaxEkXuQqo=;
        b=kAK+k6MQGXgV/j6W3649g5JpRdc8iUBdB5j3w6LyhdutovBbp1F/uM5MPtil+EQTB3
         z7iaEwMs6Na3EiUBfKCk6Gc5ObeNTpPBi1SA8nnq5DPXMMyrSJlWRd9PHZ8qkGLetmvm
         Q06IXgoIVAwnPzSuBobKfFELnbv8ReqMehQaPp9Y/qtQuH64QA0FvGV2V9ThJoM0+Wya
         ZpakYZrzeWtXQfh2M7lCbX+WVvDdV+nqwYomyfIrRkQHgd/UJuMES+PXHW5XmM3UJVTu
         4DdvUc+ppHnXPzEMKKlcx9w0DYFtSewgIrVfD7CQn47viJTCgPXu3v8I0pNEqhd5gCI8
         hdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989108; x=1788593908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AygLwoJ1AVtSpfiyYiWc6BhU8FQ//SlXkeaxEkXuQqo=;
        b=VgeWskC19UOBWR85i/zaqfJz2u0xT4IalE7xhfqC+pKNzEncECtQUja4ZYpWDiWIAD
         MsO1jdHgbaWsvDXSNec69HKzpX/OP7nKzFDPzPGdime7p6Bv7YWlOOpJMRTc00Uo+k9O
         DJmv8rWOCe1kAVa5ocqx2tfYSEoKzZN1TVpuCD4Lbh2Rwi+8LLXugbcS6P6SmK5OQTyB
         RuAx0lnZbquDkLvgO28cYr+Z9ChbLMS/Igxgy5+APyZP64UNrS5MLcE3PqNUjXZutlK3
         4Aegxxc9woBOIJPJdNlpoFndbSwXm3WCaNgi3ZSIJQEf83rkW2H/yXTcg+ejcvOZt/Qb
         coAg==
X-Gm-Message-State: AFuF++lIrIVdDwlTP7FBkA3bgaiywkqY2te3Db2TUEkdNnYSvZ4KxZ9p
	L+BNGWyfaXJLCpzfh2mWP7rhygA2apGy9Q1SEUCC/TGlTwcCkyraWjobQ9XEgA==
X-Gm-Gg: AYBFou0kMQWkE985PMOYi7XOKhsotopEtMs9HNdr8OIvFW3h9uPgwg6K7D+P0gYQyfI
	n0FJnqdhzNysVVjUanS20vvzKBOyS9RPZbkCwv4xAI0qI4C1ZwIEOO1jiR9hlv3sCGe9ErnxyfN
	rDGRYUFlhin98rD58uY94I8VOzVHndQuGtimKc81nPP6mJmivu2xVPAep7TO2pXbTSNSt4DKSjI
	1VUvp5nJthvHyj7DZOxE49MFOZdFQ+soUgfvw5TtDu6gn6ZzwDAH8LG8VMmS9yWNKrFl1lBW5tS
	LFKvoAFZf0iDiiQOTaRpqC/Ifp2/TuVIhQ8hYyyAsDP0ZWw3D9z2ABQEzwZyYO9EgrwZg+BqOCj
	sU0Und/hOC9Tabm8pN5ygZtQ/vPvX6JcQLYSMtkI/inbF/IepylAktETZAquVmguvFnyKpD8spv
	spndPqavoHpvhIHT1KZAoT5F56jmALyWzWth/IVbV32SKyKiKfIkCcrMwv6CKgMnj/DNFfGhUOR
	Rq9bOrx4QEibFhg+vXjYIu9bJ0O
X-Received: by 2002:a17:903:3b85:b0:2d8:d4d3:da4c with SMTP id d9443c01a7336-2d8d4d3db71mr79800865ad.16.1787989107667;
        Sat, 29 Aug 2026 00:38:27 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8dad3ddeesm5987615ad.61.2026.08.29.00.38.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:38:27 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v2 00/13] mm/swap: introduce per-priority allocation queues
Date: Sat, 29 Aug 2026 15:38:02 +0800
Message-ID: <20260829-swap-pcp-priq-v2-0-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 25E2640005
X-Stat-Signature: brtpnic1x7cbqne6tt7abunk187m4t3d
X-HE-Tag: 1787989108-981489
X-HE-Meta: U2FsdGVkX185YAQJ8rqafHnNPb/GzsD8sm/Ojmi+p4YWWo2l93ajeXAHzf/01m2h6YA0JUv6YAxLaxcJX8AT3uJXJcZAanysitpWzj5qfvjiJxPh1FDX8119qbbms0Jtrb3dfQi8Mmv5FEBH8ldaiZW6W3oJ2j/YPl1MJrJSGz9/56S84Zvy1njyx9MbMdhJ+HmR8/FTV++v9WpcCMZ0u4EpaYxec6DEGndPttRG9xFuKQec6/HYH4gyYvR7BFQnar9iukS1eVJe1oYxbPpJHBxg7ysdL+YooSxHEURLT279OSRl/8Lbvml1dcMl7kCzv1YOKWqr/C5tiQAjEurec2JThn1m9z2eariSDuERjrMYmRQ2CPHBhHxqGAElfVrar6ex2uotQ4uAVLua83JQrv4Wjp+sCAlln86c0mJnYSKdpWsviu0N8fajVXjYgn7c/7yFuDNAobMTzamP6SUCeBrSnkXx+O7+II5QMJYQxF7XcTzDKkpEO5f5sqEqLfZU0tDrw8pcEp8JEm937Lrjnoh5oHDdy8ZcMx+q6LMzzex2b9tU/2Zy1OjarNPhMODPrItDwCY2kjx2LkHn/AehToafiNFcwAtwoahgEEOZnqvSKgGmgGgoA7m/LmyaJzgRp5mhCkOcHlbKsg0dgqHCUlWQDpJM42KsuSXGtG6fGnw4DUXMDhKo285e52Gtexd2+9pG1qPLJpYV8EnVnWec0bAvMqODaPzhZgaPP8cjjQsHtIz8eJOX0iv/7c+OCDTcevOyAoNsvF2y6GVvwZXH2v8joc1VJ0T/kUiaLf1NDZ68AGqMcG749yUpiiS6rcpIxXlNWhM8v0GDxMreiYdYdO/GW6mOkYGcbOCFrn85HK5mpJ4ySQ8s14GmiLWvE9KQ8MKkwUsbvxDYKTDgMFmYq5Qfp83UhUrlDTZmNqyrvRhSX5Fcs+BCxXz4aupAQvDJdcKP7dxGkcpzx0CcV2D
 3cD9P5Sv
 qAafrSWycYqjcfmzV+4oNnFKdAjd7pvrnjSzlW5dw9F87nbJo+QfvF9PB6Uze7FoOw7/UIU68k1Hfsd0YISJsN/9n6L/tU7s4elxj2sTCgnDVJklzmspPotrjsEn/Y+NAHaO1Puunv0gNR5hobquVpQ31NOIprB5Yw09V9mqlTfSToH0A/6P/MHueShGix+tGR+QIfUXc/GN9uoC18LmKMuV+ZMsOWuPmyKaj+VxWlHUVWCRgtAroJ5jqIgcnZ8xKcheo2kXrUYOL5VMgKPK7ZtAAcDY6WV2bsHzF0M2xnwFW1Agc2AtNws5pI0EVTu8yjY9ZFSMyhtBuvFaTxDAOVLhI5HKJ37JP0W83iE/0atOSUiOYL/ECqbi4iAmcBYNak+fjUmuKwoIXGT+n58DnjLXPhiYEyYPduJb5HfgPuVmZM7GvYI/zhmmSIA2Z8wBuRvpqCckUP6c1ZIiL1IFdHhptjuDwLoMzbHLMlQFnL83U4kG+MxIG1eG8zx8ZOPQF/6MgyBcBSngGI2OBWcLwcxMu8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi all,

This is v2 of Kairui's swap priority queue RFC [1].  With Kairui's
agreement, I am carrying this revision while preserving the original
authorship of his patches and Youngjun's per-device percpu-cluster patch.

My substantive code changes are concentrated in patches 3, 9 and 11.
Patches 5, 10 and 12 contain the dependent adaptations needed to keep
the stack coherent and bisectable.  The code patch-ids of patches 1, 2,
4, 6, 7, 8 and 13 are unchanged from v1.  My Signed-off-by on the full
series records the handoff and DCO chain; Co-developed-by is limited to
the three patches with substantive changes.

The current swap allocator rotates swap_avail_head with plist_requeue()
when it moves between devices of the same priority.  That couples device
selection to the global cluster cache and serializes cluster transitions
on swap_avail_lock.

This series first restores per-device percpu clusters, then replaces the
allocation-time plist rotation with a priority-ordered queue.  Each
priority has a mostly immutable ring of devices.  Per-CPU readers rotate
within a ring after a fixed allocation quota, so the allocator preserves
strict priority ordering without contending on one global rotation point.

The queue is also intended to separate device selection policy from the
per-device cluster allocator.  Youngjun's swap-tier series [2] remains
under separate review.  This RFC does not introduce a tier ABI or assume
that the tier series has landed: a ring is keyed by the existing swap
priority.  If tiers land first, the same queue can become an in-tier
allocation policy rather than a competing tier definition.

Changes since v1
================

The core allocator and lifetime changes are:

- keep a task-local cursor stable across retries, so a retry walk visits
  each same-priority peer exactly once even if another task rotates the
  shared per-CPU reader;
- disable task migration across the queue walk, keeping queue accounting
  and per-CPU cluster allocation on the same CPU while leaving the loop
  sleepable;
- retry every same-priority peer for a large folio before returning
  -E2BIG, without falling through to a lower priority merely because one
  device is fragmented;
- initialize the per-CPU quota consistently;
- represent full/disabled devices with tagged ring entries, serialize tag
  writers, and use READ_ONCE()/WRITE_ONCE() for lockless readers;
- publish swap_file, the live percpu reference, queue membership and
  SWP_WRITEOK in one swapon writer section, and tighten swapoff disable
  and teardown ordering;
- fix the transitional available-list locking and publication issues
  reported by Jihan;
- bound allocation-path synchronous discard to one cluster, while the
  background worker can continue draining the list; and
- remove the transitional available/active plists and the now-unused
  plist_requeue() API after the queue becomes authoritative.

These changes address the public review on patch 9 from Youngjun and
Jihan [3][4].

Open questions
==============

Two performance-policy questions from the v1 discussion remain open:

- A one-device ring, which is likely the most common configuration,
  still follows the common reader path and takes the local lock.  A
  size-one fast path could return ring->dev[0] directly while
  swapon_rwsem keeps the ring stable.  This revision keeps the tested
  common path unchanged; feedback on whether the special case is worth
  adding would be welcome.
- Full devices remain as masked entries in the static ring.  Readers skip
  them rather than rebuilding the ring on each full/available transition.
  This keeps writers simple, but a workload with many full devices in a
  higher-priority ring still pays the masked-entry checks before falling
  through.  It is not clear that extra per-ring availability state would
  justify its synchronization complexity.

Testing
=======

Kunwu ran an A/B/C/D/E matrix on a Kunpeng 920 server with 256 CPUs,
249 GiB RAM and an aarch64 kernel.  The workload built a fixed kernel
source with "make -j96 defconfig Image modules" under 2 GiB and 3 GiB
memory cgroups, using eight equal-priority ZRAM devices.  Every arm used
one warm-up followed by 12 measured runs.

A/B/C share the v1 base and reproduce the progression reported in v1:

  A: before the series
  B: after patch 8, with per-device percpu clusters but the old plist
  C: after patch 13, with the complete priority queue

D/E share the tested v2 base and isolate the current series:

  D: before the series
  E: after all 13 v2 patches

1. Reproducing the v1 performance shape

Average system time over 12 measured kernel builds:

                              2 GiB       3 GiB
  Before (A)                40899.14s    22621.86s
  After patch 8 (B)         88712.52s    53244.70s
  After patch 13 (C)        41140.76s    22925.48s

Patch 8 alone increased system time by 116.9% in the 2 GiB workload
and 135.4% in the 3 GiB workload.  Adding the priority queue returned
system time to within 0.59% and 1.34% of A, respectively.  The absolute
times differ from the v1 machine, but the expected performance shape is
reproduced: moving the cluster cache back to device scope is expensive
while allocation still rotates the plist, and the queue removes that
contention.

2. Isolating the v2 delta

Average system time over 12 measured runs:

                              2 GiB       3 GiB
  Base (D)                  39643.77s    22139.66s
  Full v2 (E)              40336.91s    22984.62s
  Delta                       +1.75%       +3.82%

Average elapsed time, with sample standard deviation:

                              2 GiB       3 GiB
  Base (D)              518.97 +/- 5.87s  334.07 +/- 4.01s
  Full v2 (E)           527.24 +/- 5.21s  342.98 +/- 2.78s
  Delta                       +1.59%       +2.67%

The arms were run sequentially rather than interleaved, so these small
D/E deltas may include temporal drift.  They are reported as observed
instead of being described as zero regression.

3. Correctness and stress

All 120 measured builds completed with build_exit=0, oom_kill=0,
pswpout>0 and a clean dmesg delta.  Arm E also passed tests covering:

- same-priority distribution and lower-priority isolation;
- concurrent swapon/swapoff and /proc/swaps readers;
- full-device mask, unmask and peer refill;
- same-ring large-folio peer retry without fallback; and
- dmesg cleanliness and complete cleanup.

A 600-second stress run concurrently migrated the memory-pressure tasks
across CPUs and inserted and removed a device from the priority ring.  It
completed with live workers, swapout progress and a clean dmesg delta.

For the 48 D/E measured runs, all eight ZRAM devices had nonzero recorded
peak usage.  On E, the per-sample largest/smallest peak ratio averaged
1.021 for 2 GiB and 1.031 for 3 GiB; the worst observed ratio was 1.049.

4. Scope and posting base

The full server matrix was run from commit 94f9b3980dd4
("mm/page_reporting: Add page_reporting_delay_ms module parameter") to
commit d5c8964cf19f ("lib/plist.c: remove requeue function").  The series
below is rebased onto current mm-unstable; range-diff shows all 13 patches
are patch-identical.

The original 48 GiB BRD workload and a real multi-SSD workload were not
rerun, so this revision makes no BRD or hardware-scaling claim.

Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com [1]
Link: https://lore.kernel.org/20260713025644.170839-1-youngjun.park@lge.com [2]
Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330 [3]
Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com [4]

Thanks to Kairui for the original design and handoff, Youngjun and Jihan
for the v1 review, and Kunwu for the server validation.

Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
---

Kairui Song (12):
  mm/swap: remove unused parameter for reading swap header
  mm/swap: slightly cleanup the code for hibernation error handling
  mm/swap: cleanup and document swap device availability flag usage
  mm/swap: introduce swap device iteration helper
  mm/swap: change the swapon lock into a percpu rwsem
  mm/swap: remove swapon mutex and update proc reader
  mm/swap: consolidate swap inuse accounting helpers
  mm/swap: add priority queue for swap device allocation
  mm/swap: remove available list
  mm/swap: bound synchronous discard during allocation
  mm/swap: drop swap active plist
  lib/plist.c: remove requeue function

Youngjun Park (1):
  mm/swap: change back to use each swap device's percpu cluster

 include/linux/plist.h |    2 -
 include/linux/swap.h  |   43 +-
 lib/plist.c           |   64 --
 mm/swap.h             |   12 +-
 mm/swapfile.c         | 1301 +++++++++++++++++++++++++----------------
 5 files changed, 817 insertions(+), 605 deletions(-)


base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
-- 
2.55.0

