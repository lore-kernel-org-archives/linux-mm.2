Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4D9CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265456B0098; Thu, 18 Jun 2026 08:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239426B0099; Thu, 18 Jun 2026 08:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F166B009D; Thu, 18 Jun 2026 08:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8B996B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:15:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2D8F1C4BAF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:50 +0000 (UTC)
X-FDA: 84892559220.17.183CDC5
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14CDA120002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xccj5eS3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YMLQTADz6AnzpUepxHGqYwO7011QTCioGMDUqQIMy2A=;
	b=thgwpgQnPMoe84VSdjjLJRY4pf+z45ouQZe1HSnNo/QRR9TB7eqpU5tLbEyEGiAfUMv6Zh
	5HqgXluYn184/HADXNPLjZCCJ7cyhA4/o2ubS1T89Ftp4V510RBu3GKjm0XjfhGoXisN+D
	M5eG6cyChibxaYscmklq2ozV/W60/Mo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xccj5eS3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776129;
	b=zKZQK988mHMtyxEN9cbw1e4bM4btsUkie36aKQBFV9eRaHqJW+c/77xI38umg6boz7CAwf
	MSqu83Z9RoMO+k8gr3BuxBrmTprlf5dGSSyp8zUxVU/7zTj4IqWpJGQIPjzSIQlAGOvDfy
	4sE5QcQq/TdcR8EQSP83NoLfJksXG7Y=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1384ebe7a10so1531740c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776128; x=1782380928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YMLQTADz6AnzpUepxHGqYwO7011QTCioGMDUqQIMy2A=;
        b=Xccj5eS3f2xTm0ECsofegHKw7/RsP5QZZnlrLASFqeWbiFiwdonKz3UUZ6qZ1yXqeF
         j+58ZaCMzObO74r056n79FLSkYKCvpjV8ixxjhrhY6zlvMnaAHkcUWek9PldeoADdPLZ
         CcTqSEF6xkY8vygv8orPD2na8P9JrgfxyVvT0SIeyFhHEYfh6k4SokxqktEzxGX5qSbX
         /hbE0KVOHSMs2rciJawF+JuNyOZFnlt6HAYGUH4HOhJ5qMqxWOQqqRYFPTB7W1zh2q65
         FE0Zyfk89eQalhhKrxehlatP56FyXPj4gyskve/r8nSlk0pqUTepwkuskoHjU6vzOd47
         636Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776128; x=1782380928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMLQTADz6AnzpUepxHGqYwO7011QTCioGMDUqQIMy2A=;
        b=DLWmOpzmkp5bDJuUHM5mPbSQwpsXDToDm6YqsjQR7PleSvSUl641pxuz+lE5ki58CQ
         5nvPSlAy5WOO9WDXxNrkPEIE3c4vVteIQQeQ/WfGdH4Ba1UWVkj+C5Bb+1Skpaexl1Ow
         O6TrNsfCu+5HhAaKl2fJ0lP6wf9B7VIIJ8xtiCXmvZ/D9ZTWZwt+Jl8EUbabMuFgZpmO
         Uplj538+14k2dl2JQlgUmWcUEAFedNVp2l8fuTHKxszO8PEYodXJb0IMyIKKEjKSou3I
         ZU4wDppMHx7THSAXhjqj7W2ouS/Q/2p0TiWxC0GPbzmVGcBLIFns6Wy5LcPpHkozwiTA
         BsJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wDqNQPmNGF0+ZihtvgkWDJzbj6oqHPxvAqw4gGK9XtNwkMPTjCzO5w/k/LRoMjY6WtNzADYyrsg==@kvack.org
X-Gm-Message-State: AOJu0YypgJRl6eWgXQlE5JR1nekVj0ei0tGm66IbRt1VDuyAI5AeD7sE
	WjfRn/erXwQZJ1zaGgf3Ezw7KKGbasfQG1yrV/JtU6QyFHmPWmRCFl17
X-Gm-Gg: Acq92OH3kj6gRUerP0GGGgwj2aitBSurwl0USjx+p1YpyxIt3mD2CC619pDaBA3emJc
	5W3vdH975yrSJq194zqaPM4htkIXgO4f1pvHtUBjQr9J2OpWQOvirRZD7F4QGcrLE36UeE04lZ9
	gyWzGy426vh9b1Wl2E+0RxuESe7PCMhM+pl29lOZmDBfe2l6GsyWkH5P2R7Rk6rzi3OIr0ZmkbZ
	RSG0UMQut0RUiIuggWf5S6b3rKde1+6WgsLBt/Sx/uRbGRVw9/6DuOEjuZ5XdGq7Pc9WznYvNha
	tA9UuMvPzc8lOHaDlvIroCRMNC+5poznbB+nH1ERkNE/OLbmyYmbvEA93mDcnUa/TQjOp610ugP
	BTpIwPAVhkwuYh0MCoMkvY7gEtutiMKFxPjv3hAbKWKj6ii6H7d//bPNY50Gc1UKFNr1+c1gYPG
	c4VvzTS9qESv73/cBL2dt7duwM
X-Received: by 2002:a05:7022:2206:b0:128:d4be:7428 with SMTP id a92af1059eb24-1398f6cbc71mr4432771c88.19.1781776127632;
        Thu, 18 Jun 2026 02:48:47 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.48.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:48:46 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM SPE feedback
Date: Thu, 18 Jun 2026 17:48:32 +0800
Message-ID: <20260618094838.32805-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dfb9hn3x8zhxnzune4t5cfuxxbpehc9z
X-Rspamd-Queue-Id: 14CDA120002
X-HE-Tag: 1781776128-314230
X-HE-Meta: U2FsdGVkX18bOPMeoPMoYc299nsBW+rJMx5jcAWFlsh8PDm2+K0maTNzhoMDJnINDsyrbok1p/Y/xaQOfw81bXEyyTNQi2vRtv+AjUcq41keFde5aQ34aJUF6xWaOMQDmHoTJ0RQD2nIr4Gd5xnd4Av3aSG/HTqzeKtYeaKQru2/AZcUka1v79qeTP+wubvFOF87VNd9W1L5vsBUAl4aspl/J7wHdHRy89htJnVw0WlJLaMb+UbzGFAVsRa0A0KgVm5dPvh8EnyK0k9qL6afAAiXaiWjk80KRTQ/eCyF1AJULhfcDTBPCDsqOA1QoZnXXGJ4yxQ9klFk+gS8VnFav4foNxhcbeekGhtmHTVwJVlpA+CHmJjrvLR4xIsuBsG7Yey/mfZj7wkeFLFsnv86Cz+UmMKNyaDi3qs/gHl0OSpS3+3aX0jSBISVyRJQ0V+UFWRRSt00qxb8mQNP119kvg94x58iLLzRWYu6ioVvvIQjhnjPLDPKAgqPlQYc0WR4hQhrDvcluCp9pug7/IwK/zQnjeZyhxeJWSxrLx3YJCxCzsjxja5SdGrKJD4d3yFn/cMjwf7s6I5u3CQk3kl6Ff9kak/KrIr3wOx0qpxf3JO95UH3p1SgB+Ubv8LFRS3ZhMCylEgd9uo49tsQ/AVb1XDRiRLVnm9bkZEvuTlJqErDWKUCSrUmbAKba/nBdVLYcjcLfKwfVI+xa+AaWIuF9yQhXUUCPSNPp6gEDFYxW4MwHP1qD80nVWuAq2WwmkrI6cCn+YspyTEqG52aLJq8biG2TZqSxGO+B62H3dST/IaR2AjE1DTnKE+t4Rzt4OA0de2oFrB4Ezx0ObYEkZViVQ/AYgb6HWSmykpC30Z3URyiR1ruch4kzFv80I4g67oArVoC0jpA/ubgjtXgPGRlj3uKGSQfUQ+2ZJTpCgTaaaotD6WrNp20xQGej/yPGGsbI6p/dvAGqnZutxXiPwX
 apqNXedx
 dMxmYn2bs7gorolKfOcdOr2nBHA4j/nn4Mn8dueK+pySx7VtVykNUsvECg8SxfIpPzTe3wEHDyeC9quv1u2zoHYDoimPVfDP0q/vuB2RdYUS1I+1lfU519IT6OaKFTd8pNUq6grBSDRf6mCgYtNZ7PCN6Bph0tNXUKVwNtyaWvWC5sa2B2Iim7OThdYVm5vsJXC48eej1r2+YTCpW8lVwrFLWg2joyJzYNDAX9LX1cmTzOhYuslNNFI2lplxGwrditPSEl2hQhY/0nRQlFlZpf5ziqu3VFfRQP25QXOVK6ZnYnzMXVGkA0E4dcIIBE+41q5oVb/VMmhA+A9fQ4NDBcAQ8Vsy8XPS1WamMxUR/WXlKsNN/UpWm868iXWatvF+Z1X5wg44bHZUsXkeKRDmXORWdrqMxWwh00uPFF00fEX9tSxUc9BhgZRmlOdHxolq4JwVDQqJo+m28TpByCOg+H7nLQohBcnXWSCuaw+hdIOdW5UbaYgHlKcszAIiTduJN1qNNi+G8F5Cn/WkvCrjO66gl9DdMmkwm8eCQ+j39YWr6Z+4TUcnPN5Mhdmql2iUtbTURBZip6KifstWjwBU6UbdA8hY3MK6Nh9w8m0amDlVe8qX/r4nnQijon+OWOInvB0sBgHmJuht6/CGpJDknlujIG2q8GFvwy03ZYGcIvo6pcgsi4e8dg6ceMttuWQW+OYbiDeYmOf6Zl/lxOZZ21CCo1FXVIKjPpzaN0KDTNHknp4VT/SVIXc6krikqb3hlYYuuEje1Y4+57+pjMAW90ilOLSc+SKIPlZ0ZSXgZNoXK03VdWJlK8hDaWc9khKOfiZ0EtF4+n7q0EaHYwXICU0JG+GQ/jFztFXQdY/d9Jb0raqOEAgfiuq5i4qPqNslq9JEopKZAdDzvFfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Received an off-list report that DAMON significantly overestimates
hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
running Oracle workloads.

The root cause is structural: a PMD entry covers 512 4KB subpages with
a single Access Flag (AF) bit. When any one subpage is accessed, the entire
2MB region appears "hot" to DAMON. On ARM64, this is compounded by the
hardware AF mechanism -- the AF is only set on a TLB miss. Consequently, when the
working set fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB THP
running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes completely blind to
subsequent accesses. x86 is not subject to this specific blindness under similar
conditions.

We reproduced this memory inflation on a Kunpeng 920 platform using a synthetic
workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually hot):
THP=always causes DAMON to report the entire 8GB as hot, while THP=never
reports only a few hundred MB -- a 512x overestimate relative to the actual
16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM SPE hardware profiling
independently confirms this asymmetry: out of 2,005 THPs sampled system-wide
over 10 seconds, 97% had fewer than 10% of their 4KB subpages actually accessed.

To mitigate this, this series extends the existing DAMOS_COLLAPSE action to be
mTHP-aware via a new target_order field, and introduces a new
DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD THPs
into smaller mTHPs when most subpages are probed as cold, and collapse them
back when beneficial. To resolve the sub-PMD monitoring blindness, the split
path can incorporate fine-grained hardware feedback from ARM SPE.

The hardware feedback loop (damon_spe_folio_heatmap) implements a two-pass
signal filter: it first identifies the peak chunk access count, and then marks
sub-chunks with >= 1/10 of the peak count as hot, effectively filtering out
SPE sampling noise. A configurable hot_threshold (default 30%) controls the
split decision: only folios with a hot fraction below this threshold are
eligible for splitting. When no SPE data is available, the infrastructure
gracefully falls back to explicit PTE-level scanning via folio_walk.

Currently, SPE data is fed from userspace via debugfs (e.g., perf script piped
through a histogram builder into /sys/kernel/debug/damon/spe_feed).

Collapse path (patches 1-3):
  DAMON scheme action=COLLAPSE, target_order=N
  -> damos_va_collapse() -> damon_collapse_folio_range()
  -> collapse_huge_page()

Split path (patches 4-5):
  DAMON scheme action=MTHP_SPLIT, target_order=N, hot_threshold=M
  -> damos_va_mthp_split() -> damon_spe_hot_fraction()
  -> split_folio_to_order()

SPE feedback infrastructure (patch 6):
  perf script -> spe_hist -> debugfs spe_feed
  -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
  -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision

The userspace helper tools (including the spe_hist histogram builder and
validation scripts) are archived at:
  https://github.com/lianux-mm/damon_spe

Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, base kernel
7.1.0-rc5+):

  T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely within the
     L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using 512MB
     with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB reach), allowed
     DAMON to function normally.

  T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
     THP=always: DAMON reported 8GB hot (512x vs ground truth);
     THP=never: ~245MB (15x vs ground truth).  The THP-induced gap
     between the two modes was ~33x.

  T3 RocksDB: Fragmented malloc allocation prevented THP formation, and DAMON
     behaved normally. We could not reproduce THP inflation with RocksDB.
     The workloads fundamentally vulnerable to this structural issue remain KVM
     guests, JVM large heaps, and PostgreSQL shared_buffers.

  T4 min=0 deadlock break: A 256MB THP induced the DAMON blind spot.
     Triggering an unconditional mthp_split (via nr_accesses/min=0) successfully
     shattered the space into 16384x16KB folios, allowing DAMON to fully recover.

  T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% hot subpages.
     A typical trace showed PFN 0x820db800 accumulated 39,794 hardware accesses
     concentrated across only 3 out of 512 subpages.

  End-to-end: Verified hot/cold discrimination. The SPE feed preserved a 90%
     hot THP intact, while successfully splitting a 25% cold THP into 128x16KB folios.

Known limitations:
- The full KVM + Oracle production chain has not yet been benchmarked end-to-end.
  While individual component verification is complete, full integration testing
  is planned in collaboration with Sangfor.
- khugepaged may aggressively re-collapse the mTHPs that DAMON splits. A
  coordination/back-off mechanism is required to avoid ping-pong effects.
- SPE data is currently funneled via a userspace daemon and debugfs. Direct
  kernel-side perf_event sampling integration is planned as a follow-up.
- The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are empirical
  defaults subject to further tuning.
- The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing hardware-MMU
  characteristic, not introduced by this series. Setting nr_accesses/min=0
  serves as an effective workaround for the split path.

Reported-by: Chaobing Dai <daichaobing@sangfor.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Wang Lian <lianux.mm@gmail.com>

Wang Lian (6):
  mm/damon: add target_order field for DAMOS_COLLAPSE
  mm/khugepaged: add damon_collapse_folio_range() for external callers
  mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
  mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
  mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
  mm/damon: add SPE feedback for sub-THP split decisions

 include/linux/damon.h      |  18 ++
 include/linux/khugepaged.h |   3 +
 mm/damon/Kconfig           |  12 +
 mm/damon/Makefile          |   1 +
 mm/damon/core.c            |   3 +
 mm/damon/spe.c             | 505 +++++++++++++++++++++++++++++++++++++
 mm/damon/spe.h             |  62 +++++
 mm/damon/sysfs-schemes.c   |  96 +++++++
 mm/damon/vaddr.c           | 118 +++++++++
 mm/khugepaged.c            |  39 +++
 10 files changed, 857 insertions(+)
 create mode 100644 mm/damon/spe.c
 create mode 100644 mm/damon/spe.h

--
2.50.1 (Apple Git-155)


