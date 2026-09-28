Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEAFCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DAA6B0099; Mon, 28 Sep 2026 13:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804E36B009E; Mon, 28 Sep 2026 13:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB9F6B00A0; Mon, 28 Sep 2026 13:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30EA46B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C41EB1A0283
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:50 +0000 (UTC)
X-FDA: 85263888780.29.E152DE6
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19837180004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HxFiy0wR;
	spf=pass (imf16.hostedemail.com: domain of 326a6aggKCHAgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=326a6aggKCHAgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i6dOIeR3pXAhPYZMt7PFHzXVozdl2RGhyvaCgErXxW0=;
	b=yIH8PZ6g4DYRWGzHA7ksxiBjJAU8EkRqvbXxayoVv3n/x17ObPCI3ET8vlxjQBiTpOavg5
	IVcyJwsHMMQsD8gAe58XPuiOR2MVENj9iHoE50ckQLt+hdO0G6HYviF/4cHz73QVgWrHqi
	ZXZix9lHOZv8MtMsPKqd4M6pKC3219I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HxFiy0wR;
	spf=pass (imf16.hostedemail.com: domain of 326a6aggKCHAgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=326a6aggKCHAgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617309;
	b=OigWImluhEJ+wbDgPb1SK5nzy6q8+iwmvCHJUhQfBJYIDSbkskx1sCNwovTf1nKvFqkkB3
	9RQu7pgEvbmpdmzUMOvkFI/EfTQ5378Yxn+rgnPjqKY269rmbw/lGH53s199NzSXocapVN
	/MB/9VcG2ntAE3N6ew6aVTzMS4lKPBA=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a006552b00so7629705e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617307; x=1791222107; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i6dOIeR3pXAhPYZMt7PFHzXVozdl2RGhyvaCgErXxW0=;
        b=HxFiy0wRylHRIb36s2uSEvjNNo7YMr6B7q010g1mlQzTBtiIsv/NoNyGDz/askbred
         540jhUAE+cIrFtSHNq2xZzJ/KY8eUDCYMzSRwps+ruqeAGtLkm6hngRRES/IvaGxpY1l
         aS/VAN8uJJFPfrZ6HNOCsfYz8x84UQlJXOq/lOjeBG1ryg7tChF46M2wW8pytiIrtFp2
         ZWCz3MnfcGYtZPwgymyk9SMZNZYb8MIJA7QTghJzfqYpPLW7ovuIOniAcL4hQETlmNFs
         L8zzkxMfery5dMxEJBPWsHJ8aJjpOlS3ZrSX8A0psCIdAbniv6+VAsyqRXPEm+b2Pqvd
         +mbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617307; x=1791222107;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i6dOIeR3pXAhPYZMt7PFHzXVozdl2RGhyvaCgErXxW0=;
        b=jxvDeNsgFmz5nzpQ8y10iGnIcKb9IgqQ6/ZzHZ3jj6KZlII4Mp1dV2usVTPp9QtNnU
         lT58QEBXGZn2Nmvt8SSdY1n2q9yNjUyjsptIucwakschPEWl8UijbmOi1LNVzXLnXReL
         N0yfsvgjLnnF1loVHySUEP1Aut177RIG+MqYnsIYRgA2ti4mcaZu7HyKp/BgnPWWPukP
         o36PrfGQdDD5nZOim/7LLkcb5i3013+lltMzbcaM6x6/xd3hezFRuKYtpTz8sJ4LuwfN
         5MiIBe4kNipDL2g1k54IxrnZzv4S0ssG3nxxtJySqz+oBX1QmMc1y/+IYAQu7ZpAz3g6
         R0sw==
X-Forwarded-Encrypted: i=1; AKwUvBwrAYSogRm814GXQWehz6BExpfVX7/yRF/lPTqxe/UwpNTcMJsOfwk3nkbecmE7eXS1f/3I8muAQw==@kvack.org
X-Gm-Message-State: AFuF++kC/4JWimbQzZrwU4pJgMwNnwlJ4omGm8NTz+pcRfMpt7fVfr5l
	MbEP/LjiJPP0kDC6A7Uwf9RbwAsHZW5NNuyOmKNq9/PJbrswOp9qr9ahvYBGOdj2ZnM3dJ00Ymz
	O0piMnjoSgMGpDQ==
X-Received: from wmdv19.prod.google.com ([2002:a05:600c:12d3:b0:49f:f099:7fc3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c494:b0:49c:fa21:1c81 with SMTP id 5b1f17b1804b1-49fe7bab979mr230718305e9.22.1790617307210;
 Mon, 28 Sep 2026 10:41:47 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:07 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-1-smostafa@google.com>
Subject: [RFC PATCH 00/15] arm64: Set kernel stack size from cmdline
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c8yist3ap4gy64qzxmxz1ku95m7txsou
X-Rspamd-Queue-Id: 19837180004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790617308-782191
X-HE-Meta: U2FsdGVkX19XD6x2xm5brKPMRvrMbK0GleeoYpUvpxQnUGflpEtMSh3jNZLk2yllsCI6ZlP1S8bM4AjNMSFu057BxXGWYKdXtx2sxIzG6uNSS0qLYbIYSVmsOcPrJe0TnoZf8hJzFDDowQcXpmsy4xT+qAhCUPSzBBEd7+bUpX+aSRsxwKOweiNFsDDc5zPxbn7/pdk4MbBPgYqQphZGuQq69dPtpF1IWLIS6Rw7IPr9GhurDAEQDK/pHlQDTXi8kCi6SAmp3KFWCliD0oQM8icmoDVFpnXb+2BUSa83GbNqpINNLuUkFp21fvhvfEHLaEaXb8mBD+uVJO9YAEAahIaXeRNEY1eOiSyo0zpH87J+cuefWuJUBrld7LNergpGikthDfocZsRhaXW4tRqmAdtSkmjaSSPSaEybutxHwalJaLEc2DmOV12CFiOT7ipWnnDhB9OiHwqB1GdxN96GxkAMUlzzUqZMdEVAXFmWC25CbST1gicp8TIoBWKBVNk1Vj/ncw6YCz21ll7UygOQzNBUs7suPmMYcRh/9oUJCuJjBKS2dKhgetEWSC1ZtvS9w+POn3KBtLF8fgKwKVe8cdop07S/b8u1Pb2nbazt+fnjIqaDxjT2bCFmTCZTG9xRM+I/pgnI9SDYaZJvEi7flLI7SmnShwTgv7oMKSSQBFC72UrhDk/fqXYeySYPX2ioTIMf2KYWjMJvrhgeYJ7Li4rOQLhXwoA9jn7ZFEOiUeO1Hyt3jOAzUyQK951fdRoCuR3ViAylMEt8h+8HIHGVnu94vUIG5b9GtE69dllhFIz4VXxDKLHxL+ppNuaeocoxbRRJmjuWyoa8QGZ9giYr+4I/kQFgM4sGOw/W4Mk0kS7je8dH69t0A/svQHgHCEmLgC2E8r/AK1RToxuf/owoaT3JJmbImGFaFwzWVGVrhX9Lgusmzf2JRqKVj+tq/QD1C0A6hYJ0v8ts0E22yPx
 iXXetLE0
 y98ftdE1kkvxsI692Y2u/3yw+0HUEWKGGkW7NgiqEbU9HccUn+IfNvsFk1X8BAOiAS47yS03QOg/jSp4tbuDRds+Itf3ek7ns29A7tVLOACl6dJDROcKoi2oxxmPVpFu7L2NCFKx0Ko03yVTquhobcwT2YapCf1SLF5yQYzcik7OIh8/lmg2I+1oS0RSHFMNJXb/J+yqcUnVxoCAT3YYtqJBwykIsM2K1Iaqu2MpmBsTlg4/qsZNhXieLdjux3C8Uro8Dx2LhMYb/tFK6Xgl3Wq6Dl+tV9fo2I39lxPWtAYvOcFbC+9+w7IzdV10ZkrYakueZ0/h179eDsxmGqB7/TA9oST/n+NKffcxl7m3iZZlRHqKea44nPmShnQjQbi+O7zmJvDfqqQirswJ/+T0u7WurAoIKg9gJ8r7l0bwmXxwPrzlxJvOIUHMxkJs8ln40DpLbrpEyExw/KMRzGglt9dKoTgBoBdhZqrHhzv+CVh/prNd9uQUIwLi+NnF2aspdFPeYvCO5NWyM1s53Ym02BrFxGqoiXJXcYFNrQ3xlHGViQOh2ULKTEWRWjNaJyQbkQyI6UKv3UYntLlHV+FNLtHA9oQUbAsnFfcTSp6Y0ywg131GHSQ0sxIMgNSUQYCt8BV8yQCTnasmK6DHZpIXQPKs5nlO0Rx4tn1MvWivaHVWpt2Nh8OAh1v/Oijj24ziCgFiyAuouQi6TQ6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Summary
=======
This patch series adds the ability to configure the kernel stack size
for arm64 from the kernel command line.

On some systems (specifically, Android), this provides a mechanism to
reduce the kernel memory consumption, as the default kernel stack size
of 16kB (with 4kB pages) can result in ~100MB of allocated memory,
despite the fact that most threads do not come close to exhausting
their allocation [1].

There have been multiple alternative attempts to improve this
situation, including for x86 and cloud workloads. However, these
have typically focussed on more dynamic behaviours such as allocating
kernel stack pages lazily (based on faults) [2] or reclaiming unused
stack pages from blocked tasks [1], whereas this series focusses on
making the kernel stack size configurable without changing the way in
which it is allocated.
It also permits a 12kB stack size, which is currently not supported
by arm64's stack overflow checking logic.

This series re-uses the first part of the dynamic stack patches which
makes it possible to partially back the VA space of the stack
(THREAD_SIZE) with memory, but never attempts to dynamically grow the
stack.

The size of the stack (<= THREAD_SIZE) is determined from the kernel
command line and is not further configurable at runtime, all threads
on the system (except the init_task, see below) will use the size set
from the command line.

Patches
=======
The patches have dependency on the ongoing arm re-work[3] to move the
overflow stack to sp_el1 allowing the early kernel exception to use it
without clobbering any registers.

- Patches 01-09: have no functional change, they abstract the code
  dealing with the stack to avoid hardcoding the stack size
- Patches 10-13: Introduce the new ARCH_HAS_VARIABLE_STACK_SIZE and
  make the kernel deal with stack sizes set in the run time.
- Patches 14-15: arm64 selecting ARCH_HAS_VARIABLE_STACK_SIZE and
  setting the kernel stack size from the command line.

KASAN
======
The KASAN stack helpers keep unpoisoning the whole THREAD_SIZE area.
As they only write shadow memory which is populated for the whole vmap
area.

init_task
=========
init_task is the only kernel thread that has a full stack allocation
as it is allocated statically. However, the additional stack pages are
not usable because the overflow check on exception entry will continue
to check against the configured stack size.

Future work
===========
There are multiple paths that can build on this
- Per task stack size (either via an in-kernel API for kthreads or
  potentially a prctl() for userspace to configure)
- It is still possible to build on top of this on the fault path to
  add dynamic stacks if the challenges raised in [2] can be solved.

Will Deacon will host a discussion at LPC next week [4]

Testing
=======
I tested on Lenovo Mini-x gen 10 (Qualcomm X1 CPU).

With configs KMEMLEAK, DEBUG_STACK_USAGE, SCHED_STACK_END_CHECK.

1) 4kB kernel - 16kB stack (default)
2) 4kB kernel - 8kB stack
3) 4kB kernel - 12kB stack
4) 64kB kernel - 64kB stack

With running VMs with KVM, stress-ng and LKDTM.

16kB tests done on Qemu.

[1] https://lore.kernel.org/all/20260827232948.2520558-1-stevensd@google.com/
[2] https://lore.kernel.org/all/20260424191456.2679717-1-stevensd@google.com/
[3] https://lore.kernel.org/all/20260918161407.2300-1-will@kernel.org/
[4] https://lpc.events/event/20/contributions/2419/

David Stevens (3):
  fork: Don't assume fully populated stack during reuse
  fork: Move vm_stack to the beginning of the stack
  fork: Move vmap stack freeing to work queue

Mostafa Saleh (9):
  sched/task_stack: Add helpers for stack high/low
  exit: Don't assume the kernel stack size
  usercopy: Don't assume the kernel stack size
  mm: kmemleak: Don't assume the kernel stack size
  arm64: Don't assume the kernel stack size
  sched/task_stack: Introduce ARCH_HAS_VARIABLE_STACK_SIZE
  fork: Implement partial VMAP stack allocation
  arm64: mm: Relax kernel stack alignment
  arm64: mm: Set stack size from the kernel command line

Pasha Tatashin (3):
  fork: Remove assumption that vm_area->nr_pages equals to THREAD_SIZE
  fork: Separate vmap stack allocation and free calls
  mm/vmalloc: Add a get_vm_area_node()

 .../admin-guide/kernel-parameters.txt         |   7 +
 arch/Kconfig                                  |  10 ++
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/memory.h               |  19 ++-
 arch/arm64/include/asm/stacktrace.h           |   4 +-
 arch/arm64/kernel/entry.S                     |  91 ++++++++++--
 arch/arm64/kernel/setup.c                     |  24 ++++
 arch/arm64/kernel/traps.c                     |   5 +-
 include/linux/sched/task_stack.h              |  61 +++++++-
 include/linux/thread_info.h                   |   8 ++
 include/linux/vmalloc.h                       |   3 +
 kernel/exit.c                                 |   2 +-
 kernel/fork.c                                 | 134 +++++++++++++++---
 mm/kmemleak.c                                 |   2 +-
 mm/usercopy.c                                 |   4 +-
 mm/vmalloc.c                                  |  24 ++++
 16 files changed, 348 insertions(+), 51 deletions(-)

-- 
2.56.0.rc1.315.gc6ed9934b7-goog


