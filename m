Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9FBCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D54B6B00A6; Fri, 22 May 2026 13:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987CC6B00A7; Fri, 22 May 2026 13:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CE36B00AD; Fri, 22 May 2026 13:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7873E6B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 228801A0793
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:23 +0000 (UTC)
X-FDA: 84795724566.30.2DF36C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7EA76A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Subo8wxF;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470541; a=rsa-sha256;
	cv=none;
	b=FfYb6o11sJCcKZcF6B+AdT7Y3IjXJdG4aeaJJjHb07f++H2L5x7VPcDomfGG03dQ/6UoQ8
	MWRC1mzMm63fPpRMg92TZPyQjTqXUYXHRdS8Tu6a5Yexn0tzhJprX//Fkunett5Ddr67rf
	3NQZviNBbrdEC0wUzdmCeO2dMrN8KEc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Subo8wxF;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ittPUYBhsbhDW6vpPwO5mjeXazHqCn/TQP6Y2RPQFf8=;
	b=TKG9P/wsbrxmWD+2fRP8xN1UeHqVlTFuJxzVlDfgDde6icT4ThOqezUfYCFUCMY24Rc+TV
	WjleYy2ug0s3wwrOY493R0u0JoE2iBL9J5dAruM2swPh7xHCJ0y4lFkDUzBRFGyAokV4xS
	0yWj19VRckp9XifJO0Si5cqelpne8Lo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1CFC60138;
	Fri, 22 May 2026 17:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510551F000E9;
	Fri, 22 May 2026 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470540;
	bh=ittPUYBhsbhDW6vpPwO5mjeXazHqCn/TQP6Y2RPQFf8=;
	h=From:To:Cc:Subject:Date;
	b=Subo8wxFI57ZYTUn7j+MflfUDw1vw1qdzw+yEmQ1zQeRRqXLAFbtBmkwHP5ijZIp0
	 gykqtYIO/rrl71skwA50LIA4/fMKIpOqg1swKLKdj18YuPaQoNum+2tlFRjGDD27xS
	 f7wQrCevRm/d4yC4cQswvP2Lwnn0OdGh+nv2VdX3nWljwGkZamES2DutuUJc4vQASF
	 JIsJkjoR24hWXH+Uvqy5v7B9Al4G2Djs7P4NxZfdosVMB8FcnzDSbsq9zjJsQMTbFM
	 lNm20DL3Hi3nhSu1tF9m8G9y07ONmbsbfPLk0yYyhQfoIccPryxwQEOhmXL3yfQVnn
	 LV+u6dVZ1vqkA==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v4 sched_ext/for-7.2] bpf/arena: Direct kernel-side access
Date: Fri, 22 May 2026 07:22:11 -1000
Message-ID: <20260522172219.1423324-1-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EA76A0004
X-Rspamd-Server: rspam03
X-Stat-Signature: rsm33b6iqiosfbdewqgjgqs8iqbspdgi
X-HE-Tag: 1779470541-288164
X-HE-Meta: U2FsdGVkX1+JZFgvkcBK/OEGC5dcX7miZGapurrpVyQ6/Qojd8N1m5aKyobBvQO41esRp4+FXG5U3hTlL9nF+pq9lckp/TyV//QLbnAmxgb5fKdheUZBlwZCpiJusWrg6A7CPbrYtrsx/hloeULeEAYYktGlg3uuoiZTM+VYc0a6TZFecXhZqmzhRXN7Ce2Vb3k0XUt99plPkbZghVMZYE8qqXtflYg26gajg+iGgynVtTZ47Hxi4hpKtrXXCg18T6Zue3qgYCRx5UMi6xvNS7Kx8CpcZM02+p6hVkWd27KASvqFoIl4VOtE+rmICCkmGc9GgGUnM+NZKNxwQKI3HldxQbR3Do213joLPiHoMIoA2JZ6XKGDMzlRl5w7vKMfAaLpr/tM3JM4LxMRwi+xrSychLKt/gZnfOrPCWlYpCJvTOzZGCeQFJTHYJzlbXT2/wQZSBy6Uy5Y0+++uz0rv1hWZj3EOmQVKGyxW21PC/Rt1s3YX2tqPkX5y1Izrz8OKto9Cdb9yraJXNCQkqkHWVpW9nhgoJGbv8J4n/u9AY1C9AquQ6B7mjYsFUh7wq5l/cV1LRo058Radd3nkGNiZfpwZKs4APUSRupjUxWUxnV6REV0Gf24hV10dRbogpCm8gxaG13yyxq0VbEcfJ71+2JOUa5ir2oXapcmF1sabJt0+/4mDq/usWtYV/8dgkmDzOXVwJXnas7Op2rkYQ61Yheac92zeb6CfG5HWidt2W3p2MpcStVcmZrH+sHoLMl1imiasjl8xmSf74B+vkViZrsn26DGRsOeOmmKGxGUhEu/BGg4ULzwOtTMQYiUDNfpQt2qUz5ZbnkBPnXbrtBIRvpXkNidDh2KlYgwFL4wLLl3XJpoh1ZJTbuEWlGLkPV1cqDiq7seyR26SpaU3xASs0Uy8V3ToCgFi5Mw9DyNqIyB/36sMfwBGjnPtBN3YWwee38BB5Rst7S98w4MEEQ
 KMAsy+0Y
 iiA+nb1eKdTZkNNzcUys8z0E/6gikaPpplMCa1Ci2EjXqntv4SQeZkyJIlxUVBkWJ4eA5Cqlhv7Dv1TIRmMSmML6aVr3y6QPPzrEKn9KJQ1o4+25MZZ4T3xSe573u0GzBFLqWthysZ8Xe4eVACqEdNlHTs7jECRmomQmQtowtOUFw1UjsTMWjzKUhR/4r+dPM40uKvzJ9LJDft8TuzLTQS0Ylpavc2Dk7rUUHBc8zyiwNsC56OA3r4sGxOBmsc2JM9igeqF1P9rGKBkP5gt5KsKYGaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This makes BPF arena memory directly dereferenceable from kernel code
(struct_ops callbacks, kfuncs). Each arena gets a per-arena scratch page
that an arch fault hook installs into empty PTEs on kernel-side faults,
after KFENCE. The faulting instruction retries and the violation is reported
through the program's BPF stream.

v4:
- Patch 1: note that the strict-zero cmpxchg is narrower than pte_none() in
  inline comments on both x86 and arm64. (Andrea)
- Patch 2: stub bpf_arena_handle_page_fault() for !CONFIG_BPF_SYSCALL via a
  new include/linux/bpf_defs.h. (lkp)
- Patch 7: scx_arena_alloc() retries via a loop instead of a single retry on
  pool growth. (Andrea)
- Picked up Reviewed-by tags from Emil and Andrea.

v3: https://lore.kernel.org/r/20260520235052.4180316-1-tj@kernel.org
v2: https://lore.kernel.org/r/20260517211232.1670594-1-tj@kernel.org
v1 (RFC): https://lore.kernel.org/r/20260427105109.2554518-1-tj@kernel.org

Motivation
----------

sched_ext's ops_cid.set_cmask() hands the BPF scheduler a struct scx_cmask
*. The kernel translates a kernel cpumask to a cmask, but it had no way to
write into the arena, so the cmask lived in kernel memory and was passed as
a trusted pointer. BPF cmask helpers all operate on arena cmasks though, so
the BPF side had to word-by-word probe-read the kernel cmask into an arena
cmask via cmask_copy_from_kernel() before any helper could touch it. It
works, but is clumsy.

The shape isn't unique to set_cmask. Sub-scheduler support is on the way and
more sched_ext callbacks will want to pass structured data to BPF. Anywhere
a kfunc or struct_ops callback wants to hand a struct to a BPF program,
arena residence is the natural answer.

Approach
--------

Each arena gets a per-arena scratch page. Arenas stay sparsely mapped as
today - PTEs are populated only for allocated pages. A new arch fault hook
(bpf_arena_handle_page_fault) is wired into x86 page_fault_oops() and arm64
__do_kernel_fault(), after KFENCE. When a kernel-side access faults inside
an arena's kern_vm range, the helper walks the stack to find the BPF program
responsible, range-checks the fault address against prog->aux->arena, and
atomically installs the scratch page into the empty PTE via the new
ptep_try_set() wrapper. The kernel instruction retries and reads/writes the
scratch page. Free paths and map destruction treat scratch as non-owned.
Real allocation refuses to overwrite scratch (apply_range_set_cb returns
-EBUSY). A scratched address stays dead until map destroy, since its
presence means the BPF program has already malfunctioned.

The mechanism is default behavior - no UAPI flag.

What this preserves
-------------------

All the debugging properties of today's sparse-PTE design are preserved:

* BPF programs still fault on unmapped arena accesses. The fault semantics
  (instruction retry with rdst = 0) and the violation report through
  bpf_streams are unchanged for prog-side accesses.

* The first kernel-side touch of an unmapped address is reported via
  bpf_streams the same way as a prog-side fault, with the stack walk
  attributing it to the originating prog.

* User-side fault on a never-scratched address still lazy-allocates a real
  page (or returns SIGSEGV under BPF_F_SEGV_ON_FAULT). User-side fault on a
  scratched address SIGSEGVs.

What changes for the kernel-side caller is just that an unmapped deref no
longer oopses - it retries through the scratch page and emits a violation
report. The same shape today's BPF instruction faults have.

Patches 1-2 (atomic PTE install + arena scratch-page recovery)
--------------------------------------------------------------

  mm: Add ptep_try_set() for lockless empty-slot installs
  bpf: Recover arena kernel faults with scratch page

Patches 3-5 (helpers used by struct_ops registration)
-----------------------------------------------------

  bpf: Add sleepable variant of bpf_arena_alloc_pages for kernel callers
  bpf: Add bpf_struct_ops_for_each_prog()
  bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()

Patches 6-8 (sched_ext: arena auto-discovery, allocator, set_cmask)
-------------------------------------------------------------------

  sched_ext: Require an arena for cid-form schedulers
  sched_ext: Sub-allocator over kernel-claimed BPF arena pages
  sched_ext: Convert ops.set_cmask() to arena-resident cmask

Patch 6 reads each member prog's prog->aux->arena via bpf_prog_arena() and
requires the cid-form struct_ops to reference exactly one arena. Patch 7
builds a gen_pool sub-allocator inside that arena. Patch 8 converts
set_cmask() to write into arena memory. BPF dereferences via __arena like
any other arena struct, no probe-reads.

Base
----

sched_ext/for-7.2 (f31e89a8f583)

Git tree: git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git arena-direct-v4

 Documentation/bpf/kfuncs.rst          |  14 +++
 arch/arm64/include/asm/pgtable.h      |  12 ++
 arch/arm64/mm/fault.c                 |  10 +-
 arch/x86/include/asm/pgtable.h        |  12 ++
 arch/x86/mm/fault.c                   |  12 +-
 include/linux/bpf.h                   |  14 +++
 include/linux/bpf_defs.h              |  19 +++
 include/linux/pgtable.h               |  25 ++++
 kernel/bpf/arena.c                    | 216 +++++++++++++++++++++++++++-------
 kernel/bpf/bpf_struct_ops.c           |  36 ++++++
 kernel/bpf/core.c                     |   5 +
 kernel/sched/build_policy.c           |   4 +
 kernel/sched/ext.c                    | 135 ++++++++++++++++++++-
 kernel/sched/ext_arena.c              | 126 ++++++++++++++++++++
 kernel/sched/ext_arena.h              |  18 +++
 kernel/sched/ext_cid.c                |  20 +---
 kernel/sched/ext_internal.h           |  23 +++-
 tools/sched_ext/include/scx/cid.bpf.h |  52 --------
 tools/sched_ext/scx_qmap.bpf.c        |   5 +-
 19 files changed, 630 insertions(+), 128 deletions(-)

Thanks.

--
tejun

