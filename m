Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D8AC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270696B0088; Sat, 29 Aug 2026 03:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221C16B0095; Sat, 29 Aug 2026 03:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112086B0096; Sat, 29 Aug 2026 03:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE3DD6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:44:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8D3940692
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:44:17 +0000 (UTC)
X-FDA: 85153518954.05.CF197D8
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B71BA0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:44:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RYYA3fJ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lsqWf+/1tDSOdv/lJYj0i1KUGSvqW9WqoCLbT3SwEuY=;
	b=1rjvXjRTxmknkRhFTbdyhY7R41P17JVopDXG34a5HnaDMhZ91ZPxF5JjqGdWIwvg1yzc02
	nc5d8orey5V5RRFUDfzOc4mdz23MaVkQeoRXifDizLnwjDEt8pY3mnUb1hv9acSELBy6vQ
	jeiuw/pci/rJ4tZjOV9FUHNcqJMm9Gc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RYYA3fJ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989456;
	b=L1k0R2LYnpOHJX4Ua6+ud0lDcmzo9Lsa+Ff68rXWtRCnjOP8f/ZDPxauD3cZfai8/v4tS4
	x4L+0YBZeaeIEloOxzfwxPyWf/HrQClfSQgTQxmJfrexCInkKP5AsqnaiQ7Av40m4i6PDz
	9Hz3rN2kPB99p0ShrKVvGgpowLz9wc0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so1413937a12.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989455; x=1788594255; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lsqWf+/1tDSOdv/lJYj0i1KUGSvqW9WqoCLbT3SwEuY=;
        b=RYYA3fJ3ZZUAzWqXgEkiGJ0JY4Kdn1/MCPRHcL14+mTS2E9LBPJBUMizIDPplFBUOf
         kEDPP8qB7kEgSSLukLHV5odWcjFymOVGi+R693Bx2KUbn6A+cC5MgsSClKLbnjNI4sqx
         xl3RZRqlNt3NpKCxgjJagRXuINnNT0mDz2VnfWAYvc5asM6TozMzDXXws3mZWynP3NMx
         1n7goW0/spVzvU9tT3stwkD12oshu1Xmac6MvE1p8dVlOiTh6exCKIe8Opsx/36RfG+U
         ADGIlSarnQk8bQECPInZZPGii2cOtU/PhY22+BijhpvQC37UHJ+iXk2Fr+xv/OaWlmFh
         x1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989455; x=1788594255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lsqWf+/1tDSOdv/lJYj0i1KUGSvqW9WqoCLbT3SwEuY=;
        b=MgbvJz6j/syJ7kdVM2Y+1b/kK2fWo3BPpEyq6uoACywJifZ3APBj5uhc/qGg6H3C5C
         xw2htwH4RSsk4x0uDPw9izYBJHI4KRgNOIevfI7q4Iltlr/AG23x/eeGCGnVsw4aYz1M
         hK3QU/IIMypOruO55JXuxPWH7KIKAEv9ojy57oQY9pkmRQ7+pNAnSxmY+j0toRa/Y1Wr
         hdZSakY/cx7oCVWelGBFC+WD5r1x2UbAN6AacP4fduYRPl8p1nGNJQP9OlslB95GQqT9
         kA8QVuxOw6D+Dg8wZxvpVAwuf6vY7Imi/DbPU6f7mSuxsdTsBCELURKndDlzK9J53FBC
         ml3w==
X-Gm-Message-State: AFuF++kiy9ONfHU6HVOtTA428Nss9kL8c5PRYtiIPlpWnmodYn4MS5wD
	0TixVhH2yvEWzbJqcuaJiqB0OjsxBmgszksMkEXM+n+/13uM2x3EQ2nAqVE1Ww==
X-Gm-Gg: AYBFou3/w74wE6E3EN01kKQnRHvdzsK7HfZPFXVHEDKt5krX4kTTycvrWpcJLQauKV/
	u3ESthUEc3JiS6lpKD6S9Q8gOBGkMzUhpvQZ8Nk5EZNEZ6Uo/BPDOLgxGXc6XAtHt2KHKPyO/v2
	1PPq9samucufEE2bV5BWOv+ME0wyzG/lOz4hSLg6mwfj5E+WepMnkDE2EFJsp3C8KQkyscYsz7x
	JWaVkIXt8BFhPLNV3FYXwlxdYUCk1jF3GBWKYBa8MnX7l854XbBt9Z3Y/P2HhZq1nQP21XxXsXT
	Nv7HjZS7ZT79H5hBcTJH+UpVGY1wF8dFgHfBenv/P9VsDnN6HOp735o2z+28E3QBZ2k146WhIsT
	TZLCzwnDcXUk7xvS36pAltdwOBIYTzsXx9bLJlWAaXJOw6zEAILlIGA3RDtNYnVA/z8VgI9c3vU
	q6eCAeocYS1TaD/2WvdQpdYsGL1Ks1FUmOuhcuaiQY/b7VfkJgzzohvolmXKQcFIsu5eK0fzvZI
	9v75+sA4/p2M7KND/ebhj8fYXCg
X-Received: by 2002:a17:90b:5443:b0:395:4de0:b78f with SMTP id 98e67ed59e1d1-396d0d4cf4emr21803112a91.1.1787989454783;
        Sat, 29 Aug 2026 00:44:14 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddc58f3dsm6090933a91.16.2026.08.29.00.44.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:44:14 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
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
Subject: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority allocation queues
Date: Sat, 29 Aug 2026 15:43:50 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rdcztdedtwq1jysdo6nuff5g7j5e8gon
X-Rspamd-Queue-Id: 1B71BA0003
X-HE-Tag: 1787989455-576334
X-HE-Meta: U2FsdGVkX19bQnWiI0ul2PvPytwBV5Q30fAEgUi3LZhBW6YwuSRuIbmzF7pIlO53OBQ6tdzR/I/RB7BUJmix+fSv6Fr6nUpLR3ePwSfWnyVd3seGUvpRjwG1QIp5edix6FNJKLBguWoLxDS8htCJxZEtTeOOqaA0W+RkWtb/qHqTM5hAGAsyiQHd3Rsxe4wLz3sFEz5x7CkwPj+yHp2LtHPlxyPaEFplw4L+DyyLd6sKhysAOQecIHuHRWhTdgDegGufxtGS8cbaJ6AAejw4I0s6dBKoz3rY3joGoA3ojLFe0iU073CO/+KUJgRw3CgBx9jFQIeyAFT5o8T55s0Oqlpb/vPJZPSE2LbjS1mUOAA6rTH5NOff+SbsYtkBmQGZUFYzszBavSiHBI2bmdEzLnhszrxuWvsDc98dNSMN2DW8MX86Qn0/j9Qat5a/FNpRIGDZd++lDrRXtegSguLnWz2TKz0SuEDFNMEQmU10TDjYLUejiV/HkaK5SvGVJvt/CHlZilSzEC944RAfaoQXnMCV1JWtP0h919CNvg4e7ol3lJSV33Iaff94RsOcD8tDoNqgU6G60CfdY9WMmW748fzzeYtKlSLVIgXORQOUd+YqUNQYzJRrnzzG3emTOuHH0fMoJh1sEKTa1M6uxFJTIww5APtqKdcmqkdV88zlOzeEsSkNE2nrUFXGjBdMPGNOwhNhHAFkeGQKFFbWkXm6ODhHULuUcDhFJ/SeMzZ2vpBnxkUCkBuJHgsKRGnBrw9zwLF3IWSGxH7Nu7du4SZNavwH36DwBqlExIB+9WB7NFsBMOh+FlH9PXWvPu1j7b0ycQkOnJxSYGsL0nGz1edzq/XK+pQRz2npkZvGHPcwpdA+xqxVgiBsXcTuUjgxwOedCm2kYsA7jRtxjQ4SFcFH6JUVlDR3BVo7Z5WdfapldHo32hqcEPAECXhtwd7ddclA/omGZJeBYTaQPfDZDW+
 jjh9kv5m
 XDUmKMWK/3zz3ea17YWmxRezhWtX6XGiRHlWF90AjBVbZIHwMfiDXjazQU/hnDm8oPmb0zDDIbnDcr9z7aAErCHRIw4aQv3j4rWPiDwLitESy5Gp97xjEVSEImD3EH/xv1iTuu5CsJZc4Jl0DvVslxNaDT8D2yPwVqqMUX3cUFxmW1zuWJVVl7hZrPUoc1E9cYD11dou1pcPyBiq2yp/FzIvBRXIvYucgwOwq9QTko+cP+Yf2Y8pIg1VgmhC+66MiZQsbRkSbGfX0IBbZkO3BaX9vJ33LaCmixLDajliCQaCQNQl/1vyRmYnC7evbr02Z3GVEOMmQ7glu7k1b3r2jAtWN2LuZ6+mTBBeKmI43V5aoKXLenr4oIs8o+U0cy0nFn9jUvusM1oUK+4EHGNScP11F8fEUQ4cO84XWPRqWwxqLLTWA3BGz/Jf/YxlncEWrp77u6Sktnq7VJfJuzno/gz8MMY4Gqp4MVx88BuXvkVvjSyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

RESEND: Only the first cover letter was sent, with an outdated sender
display name.  No patches from the series were sent.  This resend uses
the corrected sender identity and starts the complete thread.  There are
no code or content changes from the previously reviewed v2 draft.

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

