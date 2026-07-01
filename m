Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5818C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E5E6B00A6; Wed,  1 Jul 2026 07:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF2B6B00A8; Wed,  1 Jul 2026 07:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F53F6B00A9; Wed,  1 Jul 2026 07:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 463706B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B19CB120340
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:27 +0000 (UTC)
X-FDA: 84940032534.16.D8D5C12
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF0FA4000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="n/Qmux0k";
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906445;
	b=LvtM9I9w8lulChGtxNRecEsW8z+XCW+GVk4o7NmVGNa5Dap7oArxybPukHw9erpCldE/iK
	JW/R0s1o23baKbLtWaXIX8QPXzaPy/nNJuzZNGrvrpTn6k7PPdglipQovN/h7CmeHB4jWj
	IFloP3hOdoam4Dd4EqXWBIXZZ+HE2P8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sIUByjOvpuMIXwE7ycHcWkFtOVzaObJYqxXVUpWPPy0=;
	b=wUtk0+S6aS4Ygi+H+uAomVjWWyqNHaJDNP5eUp5kL1BhY8Pp09uohPnFfUbaOZRabPoEq4
	5facnDD5KF2MQyPfze482U4JIiTYPbaRud0NgqYwaZGWuSSmakUm+Ph2U0LTWgN/vXighC
	/onMPvD9fgv+XC6v+/Hz6C3qvNsdP80=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="n/Qmux0k";
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-30e18c3e0b8so620998eec.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906445; x=1783511245; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sIUByjOvpuMIXwE7ycHcWkFtOVzaObJYqxXVUpWPPy0=;
        b=n/Qmux0kVnWDJsTjh2yG9raq1vZh59kgd7zKvbQxRfz81aJ8rDqhTWwRcbNZJYl4zs
         hoP311EGV+byJx1OvSPQf1yPkWHlOjHAzbl00RQAc2Mnonke2+3tJFFfau1yd4v2IbLf
         0qAyozuWKDdCetVWXkB//ZTGCue2yrNDALdD8sBJoYDF6rNBthWeT8MhFbuWiW7YkWPd
         cZ8pnnuT7i28kWqs+7xN9kTJdqV614ONLxHA+Qp6TLAkp2476exCoCIHmagFULZ/3Z32
         CO1jwwEfH2GRPbIGBikJLcxEAR/Xr8IaOYO2z5xHRYD8EJcOTI9r93vghLEWGyjadtyc
         2WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906445; x=1783511245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIUByjOvpuMIXwE7ycHcWkFtOVzaObJYqxXVUpWPPy0=;
        b=VR8HSUxvyqiqYjeRrSNhwF14q7zg3hwbvVGHUGizL49PVlYc1GH66sK/1CegY95AVB
         FF3vxXJWuH7u7tXOLZS/VfO1wjqv7DeslLN1Q/i4i/4cz/AjOXUotq8b2XfcQwCu2gzn
         LjPuXcGeKcFLG8z46EkSn3f7tpwqD6zyGKjfeeWBL5pKjWtsZQK8hx18bu8BAaONy1w3
         WkQdvxFoRCDtcL3y56t13AGfNjjNPUO+QYT5wTv7N992AkYwGyqkmOqxrCe31k0Shufc
         hN2vwIX2F0bpdRJctUrxHBQteR8JpLYCmousltlybdPwFdOn10c6msjDjQh1HlXhLTEy
         8vIw==
X-Forwarded-Encrypted: i=1; AHgh+RrJdGkigtqo5VTk+TcsLHvMccSvzoz50Cmffs3OUAyJ8+k18uzMQqVQOUhhlGJ/WjRTjMqQ6fIOxA==@kvack.org
X-Gm-Message-State: AOJu0YwLeTfaGx2MF3zBWV3Tuk8Mwk1i76yLehEZeAGJso643e6g2S9O
	M/ZZQ5TNAoLAwlja/IUuB+AY/kavvLNbCuaoo6oPcrhVZb8ZwEsbNHuN
X-Gm-Gg: AfdE7ck+A+XInSJzvtFv9CUtG9BVOkcAAkEo9/RmKgsc4CvNHzan6wT+ZZpVZSY7OUz
	xQ7JqYcOiNplbda6lmRHvKUKnm9iOeVN/T1aAMW7iv0aXIKDyEzY0zefPamzP00KCJW38mv9ETO
	IjVe0rMzEDNQrBkkHz4Yvm6WpQQIPOxNyjQiLxgMFU1gEoWozZ8o6LQxVqdfAWwDHeWlmQ5GY/C
	cSVdAJMqD8U0tG+rQahpF3lFaNr9KJUOhvh7ctQOGlN+e6ydartECtK0b6UH77Eq4WQRbBRdFyy
	0a2Y7DET3wXnTq11wxfhGIjQZRQY/sNmcFjxHrsmjSENIRmaYhLUJxntQKk0wj/IEt86010mOjI
	Li0lPNri7sUXYkcEZcB7Q/KEA1e6ak68lMpsQ3q5iF4MTAo/ta8qb0zsazEbu4W6MotXZEIkiQX
	SbfOGXkIYd/R98
X-Received: by 2002:a05:7301:3d1b:b0:30c:ab4f:9ba4 with SMTP id 5a478bee46e88-30f0548b54bmr417068eec.44.1782906444364;
        Wed, 01 Jul 2026 04:47:24 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:23 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Wed,  1 Jul 2026 19:47:11 +0800
Message-ID: <20260701114716.56503-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ctg3jz38h8aoht6n6ht7y8dbufppyuya
X-Rspamd-Queue-Id: EF0FA4000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782906445-628646
X-HE-Meta: U2FsdGVkX19QidTKBKu+AIpM0bSeiI09Hz9qkt44yFye4neTP6bvN5CG+8Yalg1Nfnh4vGlViXFQpciX/N/iLQsg2yDRkbJ8MPLT/JGmdXKH6nNe/7Gw+ckmfMkqJ1kKPMTgg10H4qyONEZrVSeKrw2rtqTpYh4AiMvmQluTXRZF9qf6xNaq1QZWjmwPz9ZVC/aVELWRQZI7Zf+ku60dJEyBuDPS8Qm+KvwvP1oypWhoWJu9lbOWqd0uTI1K9d7BbZjgzRvi0hGf9xyQtBmbu3wJitWqOYr+vWWya0J6NSBPsbkbgreukpnz+M2ek5MUHXNBD1otXrWzXbwHKaQXmoNBJrJ060h5MKDpSCmsJD8Xa3kaO/b4Yny8kvXv5HF5mXbiwADSoKCr5LehUd8y1hJWyqKTjAl5cFfa1lBCuFM/AMQ2gna+unwxtEU8Y61F23qjFqkMxRUitV9wCnOiSwFqFbk8N8joGGwzr36tnBxuDDWzPpGCBHwK+eyQMLCFECCh1edpFNAPaEB2pwaC0r/5dHhXWfx6Uy3OW+DHPpWh3MKp+BN+ZlOY9WOw3Q+q4s0ToBBoIYLte9H7gO0C7zxnoRec6MWRSgUiyxqR2GCvaH1N5nWs87K4KVPLyw4Tnj1PL4nGN2iJNYEusa0wkEGpS4cYCHH2VcvkDk/es+Kg1aw9ZsLhAVBZIGoBRpeXhf/4cvZpj6gOFTPAfhssxcktm1d9Cn/0JU9UfBMnbqYlCHJfkVnv1FhS1GXJD3LBjBZJTPfo9X3d066b+0p3X5AI9R+nBu5D75EvkP8gsIH6/QLPtRU+0L2wvww9Se8N1tb6QFcFMdGPh/s8EQNThpymFp2Ee7JkUy+DApSvRruktR2IouwjdTk2nD9M5zHqCRO1mwXpT5ydyoBrQmew4VegACVX2WPT4ea0OyJ2XBQHSnN1j67/OBmiZWhZ0mG2nUIJG9bjkFwbgiwjYV8
 R6OVtIE7
 IZo9YQkAXTGVdQY8la6QzRuB3TE7dV4nXv42yT6d7ozoHV7C1H0pZzLfCbfVoEuZFJ71mFLHYS4l5hGDWc4sIzLSop7LSnJZlg3KM2le+zSqs9SM/81MCyQSPpgNF7h2mocvPAjCI3oyU7oerlMzA2fbfHN8AwHv8ww1wmr0daxIppRXvFFow5xxuLlpFWZ1EHlfbXlAp0Umu8BlX3j0S3C7NGwGrU998z8w61LCnuwurO02J6OMCii9hH+GzyQCEYNyggNuUHCobdTdaJlOTnsoiGoL2amtpz2ED3TQ/nfTkOQLUKZ97mQRIiihUdOkuP3aPzSHWix62iZshPD7x5lzezPP/q5TNASTVqqx1dFie43s2ooL8tS2SkSlSp6YdMst3mGh31+vd/t3mqxbXAhS+8iH/r6wwNKnq4Gc4sRxLa65d0VCHYM2giPkHC3cUXzx5ZnZ2xNOKtHxzDSkfSnbRaF11gDW1bl7bnOdJNzJ/xNad8/JPvyOkkmwn1ss8GnpWFYZCKkc95to=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

This series gives DAMOS two order-aware folio actions so that an
access-aware policy can manage memory at mTHP granularity: a
target_order field for the existing DAMOS_COLLAPSE, and a new
DAMOS_SPLIT action.  The kernel provides the mechanism; deciding
which specific address ranges to act on is left to user space and
expressed through the existing DAMOS address filter.

v1: https://lore.kernel.org/linux-mm/20260618094838.32805-1-lianux.mm@gmail.com/

Changes since v1

 - Rename DAMOS_MTHP_SPLIT -> DAMOS_SPLIT for naming consistency with
   the existing actions (per SJ's review).
 - Drop the per-scheme hot_threshold field.  Hotness policy does not
   belong in the kernel; target selection now lives in user space and
   is expressed to DAMOS via the address filter (per SJ's review).
 - Drop the v1 SPE debugfs patch entirely.  debugfs is not the right
   interface for a feature, and the SPE profiler belongs in user space
   (see "User-space target selection" below).  v2 is kernel mechanism
   only: 5 patches.
 - Decouple T1 (a lab observation) from T2 (the production issue), and
   correct the architecture claim: ptep_test_and_clear_young() skips
   the TLB flush on both x86_64 and arm64, so the blind spot is
   architecture-independent rather than arm64-only.
 - Terminology: avoid "stale TLB".  A valid TLB entry is doing its
   job; the point is only that it lets the CPU satisfy a translation
   without a page-table walk, so the Accessed bit cleared by DAMON is
   not re-set.

Background

Two effects degrade DAMON's PTE-Accessed-bit (AF) signal once THP is
in play.  Both are described here as motivation only; this series does
not change the AF monitoring path.

T2 -- PMD-granularity inflation (production issue)

A 2MB THP is tracked by a single PMD-level Accessed bit.  One access
to any 4KB sub-page sets the AF for the whole 2MB, so DAMON reports
the entire THP as hot and cannot distinguish a genuinely hot 2MB
region from a 2MB region with a single hot 4KB page.  Cold memory
hides inside "hot" THPs, and access-driven pageout/migration becomes
coarse.

This is the workload that drove the work: Sangfor's Kunpeng 920 KVM
hosts running Oracle.  ARM SPE sampling of that workload shows 94.6%
of THPs have fewer than 10% of their sub-pages actually accessed.

T1 -- TLB-reach blind spot (lab observation)

When the working set fits within L2 TLB reach (Kunpeng 920: 2048
entries x 2MB = 4GB), the CPU keeps hitting the TLB and never walks
the page table.  Because ptep_test_and_clear_young() does not flush
the TLB, valid TLB entries continue to satisfy translations and the
AF that DAMON cleared is never re-set, so DAMON sees nr_accesses=0 for
memory that is in fact hot, and no scheme triggers.  This reproduces
in the lab with small workloads; it is not something we have seen
reported from production, where working sets exceed TLB reach.

What this series adds

Rather than change AF monitoring, this series adds two order-aware
DAMOS actions so a policy layer can act at mTHP granularity:

 - DAMOS_COLLAPSE + target_order (patches 1-3): collapse small folios
   up to a chosen mTHP order.  Patch 1 adds the target_order field and
   its sysfs file; patch 2 exports a khugepaged helper
   (damon_collapse_folio_range()); patch 3 wires the vaddr handler.

 - DAMOS_SPLIT + target_order (patches 4-5): split large folios down
   to a chosen mTHP order via split_folio_to_order(), for both
   anonymous and file-backed (tmpfs/shmem) folios.

The two are complementary, not competing:

   THP=never  + DAMOS_COLLAPSE: start at 4KB, grow hot regions up.
   THP=always + DAMOS_SPLIT:    start at 2MB, shrink cold regions down.

This dual-path design aligns with ideas discussed with Asier
Gutierrez; we plan to unify our mTHP automation and evaluation
roadmaps under this standard DAMOS_SPLIT action.

A deployment can pick either baseline, or run both, and let DAMOS
manage the placement.  THP is still wanted for the hot working set
(fewer TLB misses, shallower walks); the goal is not "no THP" but
"THP where it is hot, small pages where it is cold."

User-space target selection

The decision of *which* regions to collapse or split is left to user
space and fed to DAMOS through the existing DAMOS address filter
(DAMOS_FILTER_TYPE_ADDR) -- the interface suggested during v1 review.
The kernel provides the mechanism; user space provides the policy,
consistent with the perf/BPF "kernel samples, user space decides"
model and with the DAMON-X direction.

Because the AF signal is unreliable at PMD granularity (T1/T2), the
scheme is run with min_nr_accesses=0 so it does not gate on access
count, and the address filter selects targets.  min_nr_accesses=0 is
also what unblocks the T1 case, where nr_accesses is pinned at 0.

Why not just turn khugepaged off?  You can, but khugepaged is global
and usually left enabled because other workloads rely on it; it cannot
be disabled per region.  DAMOS_COLLAPSE gives per-region,
access-pattern-driven collapse -- a more precise, targeted complement
to khugepaged's global scan, not a replacement for it.  To handle the
runtime race where khugepaged might aggressively re-collapse what
DAMOS_SPLIT just split, we are evaluating a precise VMA-level handshake
or back-off mechanism to prevent ping-pong effects in mixed
environments.

Two user-space data sources produce the candidate address ranges:

 1. ARM SPE (ARMv8.2+): perf record (SPE) -> per-2MB hot-fraction
    histogram -> PA->VA via /proc/<pid>/pagemap -> sparse-THP VA
    ranges.  SPE reads physical addresses from the CPU pipeline,
    bypassing the TLB and page tables, so it is immune to T1 and T2.

 2. smaps fallback (no SPE): scan /proc/<pid>/smaps for THP-backed
    VMAs and treat the 2MB-aligned ranges as split candidates.

The SPE profiler stays in user space deliberately: the SPE PMU is a
single-consumer resource, so a kernel consumer would lock out
user-space perf and tooling (x86 PEBS / AMD IBS have the same
property).  Keeping it in user space avoids that and keeps the metric
source pluggable, in line with DAMON-X.  This is why v2 drops the v1
SPE debugfs patch.

Testing

Tested on aarch64 with this series applied to 7.1.0-rc5, THP=always,
using a DAMOS_SPLIT scheme (target_order=2, min_nr_accesses=0) and a
single DAMOS address filter selecting one 2MB-aligned range:

 - Anonymous THP: the filter splits exactly that one THP --
   sz_applied=2MB and AnonHugePages drops by 2MB, the rest of the
   256MB mapping untouched.
 - File-backed THP (tmpfs/shmem mounted huge=always): the same setup
   splits exactly one 2MB shmem THP -- sz_applied=2MB and
   ShmemPmdMapped drops by 2MB.  This confirms split_folio_to_order()
   works for shmem folios (the KVM-guest-on-THP-tmpfs case).
 - The address filter is what bounds the action: sz_tried covers the
   whole ~2GB monitored region while sz_applied is exactly the 2MB the
   filter selected.
 - A smaps-based path (for hosts without SPE) enumerates THP-backed
   ranges and splits all THP in the target workload.
 - checkpatch clean on all 5 patches.

Wang Lian (5):
  mm/damon: add target_order field for DAMOS_COLLAPSE
  mm/khugepaged: add damon_collapse_folio_range() for external callers
  mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
  mm/damon: introduce DAMOS_SPLIT action
  mm/damon/vaddr: implement DAMOS_SPLIT handler

 include/linux/damon.h      |  10 ++++
 include/linux/khugepaged.h |   3 ++
 mm/damon/sysfs-schemes.c   |  57 ++++++++++++++++++++
 mm/damon/vaddr.c           | 106 +++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c            |  39 ++++++++++++++
 5 files changed, 215 insertions(+)


base-commit: 01a87376d94249407343653a63e8ecfbe4c79cda
--
2.50.1 (Apple Git-155)


