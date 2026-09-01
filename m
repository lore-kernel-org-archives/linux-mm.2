Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FA0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08876B0271; Tue,  1 Sep 2026 11:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A932E6B0272; Tue,  1 Sep 2026 11:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A296B0273; Tue,  1 Sep 2026 11:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1996B0271
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:08:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57573160407
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:08:29 +0000 (UTC)
X-FDA: 85165524738.19.4BBEF01
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67A251C0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:08:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhgCbXAi;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275307;
	b=h1lEx5TUvBFH4djJp0zPAg2dYdkC//K2kbhXvOz4HNKMrbrmpEBZRkO22fwW7bu8F+77u2
	LmdccrQao7lvPHE9ImMk7NwrsGr26D9juuoRcqjiwVy9OMLz5vwDI3WMN9cvajkNgyW4fF
	EYySdc9v3XOGfg4B8tJNdG/53Lpf9P0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/o6CDpDoiumdf70zLvYrkixliDa/i4j2e/4W+sIqmw=;
	b=Kep/jtIv7Cq6FCC6dZIqYtMVEsjbQyXPE2+/g2Gy3xIF08+MPFln0MFEs8HXMHKghSIRLV
	VzKLL0ho2fgoxeE4VZWreWgoOCHjv1I9mOaXWJ2QgDiu+SsyVuduB99NBV/TzITez75w0O
	As9dNOnH+64G2roGHl5chq+kPcUMaK8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhgCbXAi;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-43bf9548df4so4456504fac.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275306; x=1788880106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J/o6CDpDoiumdf70zLvYrkixliDa/i4j2e/4W+sIqmw=;
        b=RhgCbXAivMCg9v8EQ1OqVX4tkZ5hi+BfelPPKGNuRLB/rMUEzOMawL2RMbGOiDUJbH
         rF4C0qadgh/98RlTVDu7wYrKbw1Jkh9opx9adGFTMnBb39FyX3Mlbrs2l63VGB3ccWfy
         i+w2QVvwkE878pfdii+grVg7bMxxe4SFW6DV4dfN92ATDaWkJ/2ODB4cdyqlPeZ3UbKq
         YEF35+S1r6IK7T6sWdHKnMVUvJETi14E6kkArTn73eKGTy5AbFbJ7Qq+hfQDn8DGCgDJ
         WwEf7LHjE9XZekrT0lUodxGC4af2Kd64J6xWhrEULEwjfRGxfEVR9qjOO7SoFcLi9P3g
         5lAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275306; x=1788880106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J/o6CDpDoiumdf70zLvYrkixliDa/i4j2e/4W+sIqmw=;
        b=n5i6mFRKCoLGmeGT4Sbht4eFIBIEdqnoRGLNGR7XhPZCFk8tEjEBPTk95Uv900FJA4
         /Ddvy5sqUS9RT+cABOj9eEa6bGyBxSWgGZxMzey5rVNP6DxvGKBiIpocx7adtgKHR6J5
         dfjMI1So6KSDERakXNd+8+wXnPm6VHCuffXRDomhFrkgPqi9oKMDMpdJVBbWfkhD8tfk
         5AFqEKEPtrdcN7IVOELTYhiSZUI8BOmKWrFp5Vxxr+mWaHXUGXWdShBJz+rqajz9LSwY
         gbQCJ6lGbe1R6xUiw7HESV0LZaT28vtLBqJytrsJAwzLs44B2MEFrDPTYKcQyVVkUavb
         OP+w==
X-Forwarded-Encrypted: i=1; AKwUvBx3Bhluqc80bVvrK9UABGXLLcFPsbgw8w3Lz1kN9lrC2ZymSOczdAFwUTjl9/DouZHlX1IJ4ANVIw==@kvack.org
X-Gm-Message-State: AFuF++n1eLNL+dic+0PPLUxC0ZeKecgTbDH0kF4pVIlp3JoQ1NjyjigQ
	7EQl7/zgPDuaz0cQ59WFvn5fcDsWdg11hcYtndjJ/6CGt2LppvJZ41F/+ZT4M3dv
X-Gm-Gg: AYBFou0dcPlGPBiLIW/b0aTxdKGsKzTruaCshfEYkFkjlwj96hTBXXHTyvKWyABpIPy
	+uVutf+WYVincKkc5NbbHNGzUvrax7QqsbMxsVGSEMqt9HRQbjXzLSEU6sX+9AqH9aYSrZaLGRD
	RBWJfaJeOncjzEI/iABBUWmzmMJFCZpZw0gPlLNXuLUU6FlhaGb7lKhNUaiqryEWWoX20Zj+Cn8
	1tKA9nkEAiJ7gUtov7aFlQJfCzv4X7Ptmy4RV0hw+0dqhri/SYRVaE/0qtWsCbTcNNdCRDHmmB/
	PFwzYTBdDVCxB67EWjwwc4JLmwut1cPg3dVvqjKj3JljkfFgALOTkuD4ivZcsYj6fn+jXfw/qfp
	ei2Ln8zqE8SjCvoM3bkuAXNJgt46HJr3JFOofxeIMaOuAWrHMPDDEkoQjN5fs/xt7XtYIPSmxDr
	h+7GKDtZZEL17sMIjAYgwBLkoFuAKMle/CinbF72Qks5/c1DShtr/e2Ys059I=
X-Received: by 2002:a17:903:1983:b0:2d7:203b:9863 with SMTP id d9443c01a7336-2d94a75bfadmr136713045ad.1.1788274894707;
        Tue, 01 Sep 2026 08:01:34 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd4bc66esm209375ad.68.2026.09.01.08.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:01:33 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	linux-mm@kvack.org,
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
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority allocation queues
Date: Tue,  1 Sep 2026 23:01:20 +0800
Message-ID: <20260901150122.3374554-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67A251C0003
X-Stat-Signature: qojupzz1pzaeupdo3nb5f9tsohez8xnn
X-HE-Tag: 1788275307-269403
X-HE-Meta: U2FsdGVkX19qqRAYC3Ojw7PA0cFOa1oJY0c2Jb1DnmTBELO8t/9nUW1SCWmlE4UYyilidwpPZoLaE9Vzw24czVsr+AK+RIOTydAcUE54/+ZWpbmSbeTQVs8W3eZEEaonAD8/p8iO8OwVjjfvO50ZiPVEe50xm/sIHLtWE+pt0a+gAiebPqaV0C2u4hXQw+2p4XgRblaCnBUTBKlYLMApe33VbmzlzqKZLjGMerk8Ml4ZsCf4QTl8OobyXf2nIImpNuMBycCW8GC8DZHjBqNciw42T5DizXUzzzp/d96zZnGbtgH7MU8M9XQ4Mk/Jz37qTVC9lWAt8yXQgXvhI8kTP+bVEEwysX+YQ+38yKw/9iy4KlaBI4+ymyxa3xApFaHnzGXMOal0TPvnH6s7N6IX/D445sWUPivJoRRSUb15RuUayY0xiGZdNyFBqx+1yE136fzIOQJLlXRPAP0d5BaXI/Wc96qPEZBf9WVuxLqu2x690q9KBLq+LfdpjyccfwEaEr1GWne0MeT/i3521LWsS9bmZ3B6UealmJR2n+rfapCRXEYAHnX0idTnBuHh+Mkbav4LTIKk7GQfKd/g9HqmknI//TV/LqXnQr2quqr3kUwsmZ9hDs6Nh9fwoxsP80cDOh5qeMDOf7UhtVPlr+HE5CCA4LxAGPHWbKQjbbqd/dB9VbFc6eF/z0VnT6jGD30PAHa13LiAP5MorAhJUCdv40F1eap4e9SE5SHJknUTj7Z+RcLs+mwldJRmglbtuTO2UbLZB9VQjgwrh+yOB/QxRGMamgze3EYi+/GKKNgVNJhShMFDxL3fBgCcKqY7yYADMB6+swNvNoy6oOsbp25Lr/v96fGtkRKenmf8zwvoSJE7jC5pUh7tUS+iFOfwiwhIjUvAc6DISElDsNO1LNU7wbbQm0tOLKB9cA3+kIhG+fq8utSfObopIa3m63ZvppOZJeQnKrCS8lN8reFtpEd
 QOxu6ns3
 SvV8++yuaB6tBNjz8+82UuY/SOxFcyROJLG4W4G85zuFdiE8qx1IBWQN0KCVjGVB0k977tst4+Rqyp0xOCTzbRP6jfT4WliUqdpHheyIHTjHCSGpGNuODa9VXXgXtGNGvy/JfRUgbY46eHXNoNSIT30LTCZI1dVb0Zqyg1FOKCiuO8B4hhdvb8craW2aHofw1zJ7bAT1+LBiNY2ZjeId9H7BxiMfxf5CJVubPVNSxE3sMNiI/qapaBf2JS/0e2f4AJd1S5XgXdeYpvzYwvQw7gAVFXsQo2DfgmWk5V/dOZ38RRrgvfm5fGoruTBucI/AyVy3jWPLsBQvZy+dhSOVIRfh9tkM4A/TaBzQOSSZJbjWCgwLVddFm/klAVeguaWKPLSFSc+IZjcGvqz815IOZcBszqpn5zjMUr08+yJjFLXP+JgLXfdCQQixPHSMJQbJdRibhIPgYy6XZNVWrpR1tGODu9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 15:43:50 +0800 "Lian Wang (ProcessMission)" <lianux.mm@gmail.com> wrote:

> Hi all,
> 
> RESEND: Only the first cover letter was sent, with an outdated sender
> display name.  No patches from the series were sent.  This resend uses
> the corrected sender identity and starts the complete thread.  There are
> no code or content changes from the previously reviewed v2 draft.
> 
> This is v2 of Kairui's swap priority queue RFC [1].  With Kairui's
> agreement, I am carrying this revision while preserving the original
> authorship of his patches and Youngjun's per-device percpu-cluster patch.
> 
> My substantive code changes are concentrated in patches 3, 9 and 11.
> Patches 5, 10 and 12 contain the dependent adaptations needed to keep
> the stack coherent and bisectable.  The code patch-ids of patches 1, 2,
> 4, 6, 7, 8 and 13 are unchanged from v1.  My Signed-off-by on the full
> series records the handoff and DCO chain; Co-developed-by is limited to
> the three patches with substantive changes.
> 
> The current swap allocator rotates swap_avail_head with plist_requeue()
> when it moves between devices of the same priority.  That couples device
> selection to the global cluster cache and serializes cluster transitions
> on swap_avail_lock.
> 
> This series first restores per-device percpu clusters, then replaces the
> allocation-time plist rotation with a priority-ordered queue.  Each
> priority has a mostly immutable ring of devices.  Per-CPU readers rotate
> within a ring after a fixed allocation quota, so the allocator preserves
> strict priority ordering without contending on one global rotation point.
> 
> The queue is also intended to separate device selection policy from the
> per-device cluster allocator.  Youngjun's swap-tier series [2] remains
> under separate review.  This RFC does not introduce a tier ABI or assume
> that the tier series has landed: a ring is keyed by the existing swap
> priority.  If tiers land first, the same queue can become an in-tier
> allocation policy rather than a competing tier definition.
> 


I've completed the functional, stress, and A/B/C/D/E performance testing
on my side.

The results are consistent with the expected v1 performance shape, and
I don't see a significant performance regression for the full v2 series
in this workload.

I'm also reviewing the v2 code, particularly the allocation queue,
locking, and swapoff/lifetime changes. I'll follow up on the thread with
any findings.

Tested-by: Kunwu Chan <kunwu.chan@gmail.com>

Best,
Kunwu

> Changes since v1
> ================
> 
> The core allocator and lifetime changes are:
> 
> - keep a task-local cursor stable across retries, so a retry walk visits
>   each same-priority peer exactly once even if another task rotates the
>   shared per-CPU reader;
> - disable task migration across the queue walk, keeping queue accounting
>   and per-CPU cluster allocation on the same CPU while leaving the loop
>   sleepable;
> - retry every same-priority peer for a large folio before returning
>   -E2BIG, without falling through to a lower priority merely because one
>   device is fragmented;
> - initialize the per-CPU quota consistently;
> - represent full/disabled devices with tagged ring entries, serialize tag
>   writers, and use READ_ONCE()/WRITE_ONCE() for lockless readers;
> - publish swap_file, the live percpu reference, queue membership and
>   SWP_WRITEOK in one swapon writer section, and tighten swapoff disable
>   and teardown ordering;
> - fix the transitional available-list locking and publication issues
>   reported by Jihan;
> - bound allocation-path synchronous discard to one cluster, while the
>   background worker can continue draining the list; and
> - remove the transitional available/active plists and the now-unused
>   plist_requeue() API after the queue becomes authoritative.
> 
> These changes address the public review on patch 9 from Youngjun and
> Jihan [3][4].
> 
> Open questions
> ==============
> 
> Two performance-policy questions from the v1 discussion remain open:
> 
> - A one-device ring, which is likely the most common configuration,
>   still follows the common reader path and takes the local lock.  A
>   size-one fast path could return ring->dev[0] directly while
>   swapon_rwsem keeps the ring stable.  This revision keeps the tested
>   common path unchanged; feedback on whether the special case is worth
>   adding would be welcome.
> - Full devices remain as masked entries in the static ring.  Readers skip
>   them rather than rebuilding the ring on each full/available transition.
>   This keeps writers simple, but a workload with many full devices in a
>   higher-priority ring still pays the masked-entry checks before falling
>   through.  It is not clear that extra per-ring availability state would
>   justify its synchronization complexity.
> 
> Testing
> =======
> 
> Kunwu ran an A/B/C/D/E matrix on a Kunpeng 920 server with 256 CPUs,
> 249 GiB RAM and an aarch64 kernel.  The workload built a fixed kernel
> source with "make -j96 defconfig Image modules" under 2 GiB and 3 GiB
> memory cgroups, using eight equal-priority ZRAM devices.  Every arm used
> one warm-up followed by 12 measured runs.
> 
> A/B/C share the v1 base and reproduce the progression reported in v1:
> 
>   A: before the series
>   B: after patch 8, with per-device percpu clusters but the old plist
>   C: after patch 13, with the complete priority queue
> 
> D/E share the tested v2 base and isolate the current series:
> 
>   D: before the series
>   E: after all 13 v2 patches
> 
> 1. Reproducing the v1 performance shape
> 
> Average system time over 12 measured kernel builds:
> 
>                               2 GiB       3 GiB
>   Before (A)                40899.14s    22621.86s
>   After patch 8 (B)         88712.52s    53244.70s
>   After patch 13 (C)        41140.76s    22925.48s
> 
> Patch 8 alone increased system time by 116.9% in the 2 GiB workload
> and 135.4% in the 3 GiB workload.  Adding the priority queue returned
> system time to within 0.59% and 1.34% of A, respectively.  The absolute
> times differ from the v1 machine, but the expected performance shape is
> reproduced: moving the cluster cache back to device scope is expensive
> while allocation still rotates the plist, and the queue removes that
> contention.
> 
> 2. Isolating the v2 delta
> 
> Average system time over 12 measured runs:
> 
>                               2 GiB       3 GiB
>   Base (D)                  39643.77s    22139.66s
>   Full v2 (E)              40336.91s    22984.62s
>   Delta                       +1.75%       +3.82%
> 
> Average elapsed time, with sample standard deviation:
> 
>                               2 GiB       3 GiB
>   Base (D)              518.97 +/- 5.87s  334.07 +/- 4.01s
>   Full v2 (E)           527.24 +/- 5.21s  342.98 +/- 2.78s
>   Delta                       +1.59%       +2.67%
> 
> The arms were run sequentially rather than interleaved, so these small
> D/E deltas may include temporal drift.  They are reported as observed
> instead of being described as zero regression.
> 
> 3. Correctness and stress
> 
> All 120 measured builds completed with build_exit=0, oom_kill=0,
> pswpout>0 and a clean dmesg delta.  Arm E also passed tests covering:
> 
> - same-priority distribution and lower-priority isolation;
> - concurrent swapon/swapoff and /proc/swaps readers;
> - full-device mask, unmask and peer refill;
> - same-ring large-folio peer retry without fallback; and
> - dmesg cleanliness and complete cleanup.
> 
> A 600-second stress run concurrently migrated the memory-pressure tasks
> across CPUs and inserted and removed a device from the priority ring.  It
> completed with live workers, swapout progress and a clean dmesg delta.
> 
> For the 48 D/E measured runs, all eight ZRAM devices had nonzero recorded
> peak usage.  On E, the per-sample largest/smallest peak ratio averaged
> 1.021 for 2 GiB and 1.031 for 3 GiB; the worst observed ratio was 1.049.
> 
> 4. Scope and posting base
> 
> The full server matrix was run from commit 94f9b3980dd4
> ("mm/page_reporting: Add page_reporting_delay_ms module parameter") to
> commit d5c8964cf19f ("lib/plist.c: remove requeue function").  The series
> below is rebased onto current mm-unstable; range-diff shows all 13 patches
> are patch-identical.
> 
> The original 48 GiB BRD workload and a real multi-SSD workload were not
> rerun, so this revision makes no BRD or hardware-scaling claim.
> 
> Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com [1]
> Link: https://lore.kernel.org/20260713025644.170839-1-youngjun.park@lge.com [2]
> Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330 [3]
> Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com [4]
> 
> Thanks to Kairui for the original design and handoff, Youngjun and Jihan
> for the v1 review, and Kunwu for the server validation.
> 
> Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
> ---
> 
> Kairui Song (12):
>   mm/swap: remove unused parameter for reading swap header
>   mm/swap: slightly cleanup the code for hibernation error handling
>   mm/swap: cleanup and document swap device availability flag usage
>   mm/swap: introduce swap device iteration helper
>   mm/swap: change the swapon lock into a percpu rwsem
>   mm/swap: remove swapon mutex and update proc reader
>   mm/swap: consolidate swap inuse accounting helpers
>   mm/swap: add priority queue for swap device allocation
>   mm/swap: remove available list
>   mm/swap: bound synchronous discard during allocation
>   mm/swap: drop swap active plist
>   lib/plist.c: remove requeue function
> 
> Youngjun Park (1):
>   mm/swap: change back to use each swap device's percpu cluster
> 
>  include/linux/plist.h |    2 -
>  include/linux/swap.h  |   43 +-
>  lib/plist.c           |   64 --
>  mm/swap.h             |   12 +-
>  mm/swapfile.c         | 1301 +++++++++++++++++++++++++----------------
>  5 files changed, 817 insertions(+), 605 deletions(-)
> 
> 
> base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
> -- 
> 2.55.0
> 

Sent using hkml (https://github.com/sjp38/hackermail)

