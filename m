Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50953CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2106B0005; Sun, 17 May 2026 17:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8C26B0088; Sun, 17 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF246B008C; Sun, 17 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27236B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 970B6C2381
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:36 +0000 (UTC)
X-FDA: 84778160712.24.800FBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE9A040008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b1E3GALC;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TJ+CGOkLMv7NevPUnCa2muMcWL2EUiWvaYd3S9qzAD8=;
	b=qYbtxkuywn9NQ5ovSR7VK3HgXE3n+os80nPIId1KG5Gcx8GXWu8J67K3wLOaAELhyxdir0
	3OHdDNv8TK5fOfrTTQ1vl6dnldbQALu3F+wCacScWR2K2xaoghug4mL84KbpqXA8eRGeGG
	WjC2/5yxnjJoV6NyHPZX+4Ub2sibhRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052355; a=rsa-sha256;
	cv=none;
	b=MqrtrBJ+wAVr815ZvaxXRLvd4QS4QS9XRG/YPBlc9hIhLjiHZyRH8Ve/tJBjQw9DsYlGWK
	58Ccs25BbkEPvs5V5UWt+XFk5A60R6dJ4MJTLWUq67HSn0MpLztsFFYry/6nz1a2Gvho1X
	il64Z28X5YyTW/ZhAAA8eLgRawHC2Jg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b1E3GALC;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8565F417E7;
	Sun, 17 May 2026 21:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3183CC2BCB0;
	Sun, 17 May 2026 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052353;
	bh=a6e2ffrarYvyiSnMafrOD30AH1WgN2On1KkShq4mS0c=;
	h=From:To:Cc:Subject:Date:From;
	b=b1E3GALC51Qetd6cxGgeJWodhsrwgRKSs66mftcTKX7YzsuPZuhfJgvzz9CTKlQ0j
	 RD04UYukWDAL3gqHgnYHUJSRZ1ywZiNWfWZnr4UkHIZ76W/0P/hmT2oWqo8zkGp5bl
	 kUm5Di17xgAkIoWjni6+yWi2vr9iHQxGTZZWvtqmffmGxPcu3AE1BDpnCDA11bOruT
	 sQ/JBJ2qLlebcnI3trMS7Ao+wiulQYCuoVdrFRBwWQURPs/2oqdaGpVEOkYX6klWLk
	 bUcW0aEfl155cUNw+IrTf7HNrcYSpWusjR8szBAfI3Gpm19fwj2+HsBBHnICPKQVnE
	 te8EPOPinvSRQ==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCHSET v2 sched_ext/for-7.2] bpf/arena: Direct kernel-side access
Date: Sun, 17 May 2026 11:12:24 -1000
Message-ID: <20260517211232.1670594-1-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE9A040008
X-Rspam-User: 
X-Stat-Signature: ir5nyf3a3tux4d58hre6z88pifoo1zx9
X-HE-Tag: 1779052354-276829
X-HE-Meta: U2FsdGVkX1/OdfGPPU9YiahkukKUrEbJmQMpHDQUjtatoAQOom6PBXpTY11kj1wciWdtR1x/vk/OpR0ZgeCzvSc1QUEVpEXHOdSiS+rbVJnfoFRQtwphrPD8UtWffpV1BGyKkLeLsv6FXCX0qE0p86yRtJTenPEksIwK9JRXvsKnW1Jrl0nc21c7td8d8KWe53eBPYmBO8k3S5YT7xylA5an5IU+1G8VY4V0WyutlLngeGeXURAfnpXUXmOljRa1k6PeIfhz2YopcC+mf4w0rAYNPK+E3z/rs37fkTbCLxrGcR6HldwdVtAdRZOaqk5B96ixi+Eb9XTdSA/W5ICrlPGetsFgbXlK79KwDb2jdamQpLPyozithSnmUJPZnfZ0RzV3ZZnXPDxrEyrQzWrWsZWTnnP+xYI/qOjnQUi1uqoiz2lTb72Rx5Ku6c9OI7OHAjZAEqwMmBmBhrcc6qcFxbtj4ntENAWYl//84IDSi6hm8mBLm00GakGx7pQL61gsVoWNfBXABC605+dcDjc2U06tHsIlqESAsT2TwHAuU4H27kWRV1lJWIQCxW3/WhNjPB6sX7bMin/fsbs4hAcHW8yGQ4EVXPyY6uiZIX3HQXnBFq1t9xkKveFTsUj/f3n2OzgAIuZ+Y1YrLg5Tx/RHGHcRKmlWuEpI9fPAdqJQCHuv3+pvrDHUJEqxWSb2L0L02o6LQWTwN94vaIqk7YIKil/KlcCt1CU6Q1rFoafrndONdE5Ddpr1OXrH1VNs8phFuwENT5QtElngKjm98LIl79KtBgRKqi/FTaEbiNiTcowYX6jnOXg7jUdfem7PzQdSoSNnhyNLLw4oct6rS8gprrEWJ4ZokBR6xAckWLiVOPbnYKOvFwx4EtqU410WlUR1lry5bkLOkFhJEgP05RZZlEn7wC1pyDN07fJWWX/3kwR7CGRVtQzZsjyY43PQEEH/VJU+hq9mYOOThLSka6T
 7YjyFYSo
 ntTpR8Z7U5HLoE2v9pB03pMsi5ZEyRGm4sa+2juz5V+ozmLBtAoHgupgVZ9kuctd5Am+BjSOzSJfUTbby2joTAOaD7voz0hp77XK0LZhfBaVtBZwUGPOGrpCOdEhKgP7Cm290sD+qfQfEXgg2mm0avt6r7Mk8/Vmz+0+k9cumXfAWmr6Lr1DeJrvL8grm7Ud12WSioJIIBtRR9B9ALLBADGS2DOWgHed7C4wOuJMj6VNjgOFbyWbT59ko8OI6qlO2jjuYblx1OLZkir+iuUB3OKFYgUlZa0LQiQ7t
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

v2 changes since RFC v1 (20260427105109.2554518-1-tj@kernel.org):

Switched from pre-filling the arena recovery range with a fallback page to
leaving PTEs sparse and installing the scratch page from an arch fault hook
on demand. Pre-fill erased the fault and lost error attribution; on-demand
keeps the fault visible and reports the violation through the program's
bpf_stream. Plus misc fixes.

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
responsible, range- checks the fault address against prog->aux->arena, and
atomically installs the scratch page into the empty PTE via the new
ptep_try_install() wrapper. The kernel instruction retries and reads/writes
the scratch page. Free paths and map destruction treat scratch as non-owned.
Real allocation refuses to overwrite scratch (apply_range_set_cb returns
-EBUSY); a scratched address stays dead until map destroy, since its
presence means the BPF program has already malfunctioned.

The mechanism is default behavior - no UAPI flag.

What this preserves
-------------------

All the debugging properties of today's sparse-PTE design are
preserved:

* BPF programs still fault on unmapped arena accesses. The fault semantics
  (instruction retry with rdst = 0) and the violation report through
  bpf_streams are unchanged for prog-side accesses.

* The first kernel-side touch of an unmapped address is reported via
  bpf_streams the same way as a prog-side fault, with the stack walk
  attributing it to the originating prog.

* User-side fault on a never-scratched address still lazy-allocates a real
  page (or returns SIGSEGV under BPF_F_SEGV_ON_FAULT). User- side fault on a
  scratched address SIGSEGVs.

What changes for the kernel-side caller is just that an unmapped deref no
longer oopses - it retries through the scratch page and emits a violation
report. The same shape today's BPF instruction faults have.

Patches 1-2 (atomic PTE install + arena scratch-page recovery)
--------------------------------------------------------------

  mm: Add ptep_try_install() for lockless empty-slot installs
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
set_cmask() to write into arena memory; BPF dereferences via __arena like
any other arena struct, no probe-reads.

Base
----

sched_ext/for-7.2 (c9017d335aab) with cmask-prep-v2.1 applied:
  https://lore.kernel.org/r/20260517183614.1191534-1-tj@kernel.org

Git tree: git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git arena-direct-v2

 Documentation/bpf/kfuncs.rst          |  14 +++
 arch/arm64/include/asm/pgtable.h      |   8 ++
 arch/arm64/mm/fault.c                 |  10 +-
 arch/x86/include/asm/pgtable.h        |   8 ++
 arch/x86/mm/fault.c                   |  12 +-
 include/linux/bpf.h                   |  14 +++
 include/linux/bpf_defs.h              |  11 ++
 include/linux/pgtable.h               |  16 +++
 kernel/bpf/arena.c                    | 209 ++++++++++++++++++++++++++++------
 kernel/bpf/bpf_struct_ops.c           |  36 ++++++
 kernel/bpf/core.c                     |   5 +
 kernel/sched/build_policy.c           |   4 +
 kernel/sched/ext.c                    | 135 +++++++++++++++++++++-
 kernel/sched/ext_arena.c              | 127 +++++++++++++++++++++
 kernel/sched/ext_arena.h              |  18 +++
 kernel/sched/ext_cid.c                |  20 +---
 kernel/sched/ext_internal.h           |  23 +++-
 tools/sched_ext/include/scx/cid.bpf.h |  52 ---------
 tools/sched_ext/scx_qmap.bpf.c        |   5 +-
 19 files changed, 604 insertions(+), 123 deletions(-)

Thanks.

--
tejun

