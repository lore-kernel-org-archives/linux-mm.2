Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D62DFF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D378F6B0005; Fri, 24 Apr 2026 19:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8C06B008A; Fri, 24 Apr 2026 19:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03876B008C; Fri, 24 Apr 2026 19:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA8206B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:10:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F01D140173
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:10:39 +0000 (UTC)
X-FDA: 84694995798.25.176AEB5
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5BF3BA0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:10:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXHbxxZf;
	spf=pass (imf25.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777072237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZF2xo+im5ABqQb8juDoszdqEpMu6aUbnETaBqpZGMY0=;
	b=8bCJtj/PVJ9SFjJeR/XrHpNl1tLKaJY3mFSJB0016fb/e9QH3GFJnXMQMHBO0awl2Vb+KX
	gn3pz8TUHjSzAgjVTg3f1AJsgc+byMdFh7RnkhOSb2FlkEKDh+c11QC1pwkJfX9wMouXqI
	B+C5XfhTZ6hoA6mblcXfSeXuwH5wbA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777072237; a=rsa-sha256;
	cv=none;
	b=mpy82QyRyDD18J1dInT4dp7SKbpWTzYAmNSHUQ/QRCmnl+UlJNCoM0pSet+26FvzFPTSLo
	KsZ95Xi8eYARwvmgUd9PxxnMrfUZAsnfRO3FiroTxc5ZhFFVMYbPELHAYxSiY+tnvQiJqe
	AaSYDRHzI1YB+flIitCsSYhHNOTrHwY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXHbxxZf;
	spf=pass (imf25.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777072234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZF2xo+im5ABqQb8juDoszdqEpMu6aUbnETaBqpZGMY0=;
	b=VXHbxxZfy9OoLtXfzxZ8LCjQMjD/OkCiG8Davia89CJr1Bfd4TuZZXt6E5Iwkup+l0h+3v
	cFjh3APLkpXSJQIKe7Yoo0ID2ftKfKivDSn005tkbrPGCE8tOLFAb99bTVlgqSaCzwUXKq
	dS3LDHdZC3mJaN1fdjTfIxwCD2pD6Pc=
Date: Fri, 24 Apr 2026 16:10:19 -0700
MIME-Version: 1.0
Subject: Re: [PATCH RFC bpf-next 0/8] bpf: add support for KASAN checks in
 JITed programs
To: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?=
 <alexis.lothore@bootlin.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 Jiri Olsa <jolsa@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org,
 Bastien Curutchet <bastien.curutchet@bootlin.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BF3BA0002
X-Stat-Signature: g3kcsmjomesz7hfqtd6om3rs51y75ocx
X-Rspam-User: 
X-HE-Tag: 1777072237-988543
X-HE-Meta: U2FsdGVkX1/obDEbc5m8vXp2I1ED07YGcWcD5+jppXGAKioGK58lJgykeEEC4EAKURRKrlZGfMl0Xe+KxBC2MAdBJzn9etrLlzkS8yn/CsJp/9R2DxVjNIQekQWTqMKLOJRK7tgFZENwL/r4HrgaoU7v/Z1iKkCzbCzT3BmSUFxwvHbIRdrepVbwlshg2dyneLEvKi2UijP2y41kPqA4+fiZYUAy7XaiVBsQF/omkzFrG2kgP2Ofp112C8Xow3elaXL/RTp7mw4Bn7WljC3/5yqagu8zscYD4IRJvBsU3zLK6Dc6aJQYMIqunUdFAJqy7AXfiKmv+AV8nvYPqRdyG4sB0i89SMD/azLMTXedgLDiYArBUEjWiUptpf13mrW1nNjXj94MkOfi6ZdB90gUHjnu3ldnm1SQmv9hS6oyBaVTyoHXrUddceFxkXBBNdvE8hWRcRcmFHw+SBqgdQo6O47ekr5PgWkFvCYQBIBnAVkZOs7ByizttFrvCi+BpK7rTabUFSHdI5Pk4/NfecElHaQumODAaNTEq0ExyOmbCAIeXPFNHerquif3GjejkH5fvxOJ1v9DF7fAPDzEa4Kdr03mTd48YW2KPca4YuWKAT1g4615c15Zyr7SEDOTsPQi+ZQA80PvR1pW2HGI2mDZMLX4RIbYt5j3z5/Y6SK4GNpEYqBKQM1TaS4Uriretkot+Wz5r+JKk/naxfnFeVRWGHtpPQrgU5kvl3DkHgVh58Adglpo7QX2HEvgB/N78ONJe9f88nlbiwcDR5zYa5PFiDb4gq1zGxkF4okppDN30ypKeSt6kRtyLpVGdhm9QnqSJS84hEMUUdtShjyuaDxAdGu7ajoBqycd6GOIL94qHcggGgpmQLMnTTsV5+n59rZhKnYoAoVl4Vt17MpEeMheX8XXoGCp9z7kqO/Zq21dEzC1qcP6iu64FhQS/saN1bLW7z2nu7hKiwEPp+9O4WN
 4ELLlDxz
 ctMExVLbwyvUwitdXQI+hxbrJG4amoJNMr/L8XGQPqzdS2BrdYu9Ur4aEXnL3XlnhfusL9q/1XrsOTiwuDIaKQeWcSDJc2nWtU2PYZbzNnWdC4yOiTFxBOXP8poGdINxqJa44bGfKijs9Kl2WgmAPkspT1+R7MJFjU9u/8LeroSvxxmSXfkZm0TxDo19PPyQlXhzA9+PbZcuuV4AqfPeAtrCOXPCCAX6DOstD6la6l82g8IR97Ob3zX4qKhvIBEebMMjjS7PuJCp46lZWhWqyXM7VlvtzSmTTpRM2Lyw++r+PkMYfSpXOROVPCEjSbE/5Z808KJ2uoQHxF+0gv06mE84aNNRhV2uLAa8ccEbT0ORe0R/LmX4LlVDp87Ha/aAFRW8ZuLSuV9sKpTd0sjlUHDqDDMjShu4+s6Yl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 11:28 AM, Alexis LothorÃ© (eBPF Foundation) wrote:
> Hello,
> this series aims to bring basic support for KASAN checks to BPF JITed
> programs. This follows the first RFC posted in [1].

Hi Alexis,

Thank you for working on this, it's a real testing gap.
I have a few comments, see below.

The series doesn't apply cleanly on bpf-next right now, but I was able
to apply to a little older revision (eb5249b12507).

> 
> KASAN allows to spot memory management mistakes by reserving a fraction
> of memory as "shadow memory" that will map to the rest of the memory and
> allow its monitoring. Each memory-accessing instruction is then
> instrumented at build time to call some ASAN check function, that will
> analyze the corresponding bits in shadow memory, and if it detects the
> access as invalid, trigger a detailed report. The goal of this series is
> to replicate this mechanism for BPF programs when they are being JITed
> into native instructions: that's then the (runtime) JIT compiler who is
> in charge of inserting calls to the corresponding kasan checks, when a
> program is being loaded into the kernel. This task involves:
> - identifying at program load time the instructions performing memory
>   accesses
> - identifying those accesses properties (size ? read or write ?) to
>   define the relevant kasan check function to call
> - just before the identified instructions:
>   - perform the basic context saving (ie: saving registers)
>   - inserting a call to the relevant kasan check function 
>   - restore context
> - whenever the instrumented program executes, if it performs an invalid
>   access, it triggers a kasan report identical to those instrumented on
>   kernel side at build time.
> 
> As discussed in [1], this series is based on some choices and
> assumptions:
> - it focuses on x86_64 for now, and so only on KASAN_GENERIC

I wonder if it's feasible to implement KASAN support on the verifier
side in post-verification fixups. AI slop for illustration:

  ;; Original (1 BPF insn):
  dst = *(u64 *)(src + off)           ; BPF_LDX | BPF_MEM | BPF_DW

  ;; Rewrite (~7 BPF insns):
  r_tmp1 = src                         ; BPF_MOV64_REG
  r_tmp1 += off                        ; BPF_ALU64 | BPF_ADD | K   (full address)
  r_tmp2 = r_tmp1                      ; copy
  r_tmp2 >>= 3                         ; KASAN_SHADOW_SCALE_SHIFT
  r_tmp2 += KASAN_SHADOW_OFFSET        ; shadow address
  r_tmp3 = *(u8 *)(r_tmp2 + 0)         ; BPF_LDX | BPF_B   (load shadow byte)
  if r_tmp3 != 0 goto +2               ; BPF_JNE | PC+2
  dst = *(u64 *)(src + off)            ; original access (fast path)
  goto +1                              ; skip slowpath
  call __asan_report_load8             ; BPF kfunc
  dst = *(u64 *)(src + off)            ; retry the access after report (non-fatal)

A sort of inline kasan directly in BPF.

There are plenty of issues with it: instruction limit, exposing asan
API as kfuncs, etc. On the flip side we get cross-arch support out of
the box with no or mininal JIT changes.

Honestly I'm not excited about this approach, but curious if anyone
thought about this, or maybe it was already discussed?


> - not all memory accessing BPF instructions are being instrumented:
>   - it focuses on STX/LDX instructions
>   - it discards instructions accessing BPF program stack (already
>     monitored by page guards)
>   - it discards possibly faulting instructions, like BPF_PROBE_MEM or
>     BPF_PROBE_ATOMIC insns
> 
> The series is marked and sent as RFC:
> - to allow collecting feedback early and make sure that it goes into the
>   right direction
> - because it depends on Xu's work to pass data between the verifier and
>   JIT compilers. This work is not merged yet, see [2]. I have been
>   tracking the various revisions he sent on the ML and based my local
>   branch on his work
> - because tests brought by this series currently can't run on BPF CI:
>   they expect kasan multishot to be enabled, otherwise the first test
>   will make all other kasan-related tests fail.

AFAICT this can be trivially fixed on BPF CI side, we just need to set
kasan_multi_shot for the VMs running the tests. I will do that, your
next revision doesn't have to be and RFC.

> - because some cases like atomic loads/stores are not instrumented yet
>   (and are still making me scratch my head)
> - because it will hopefully provide a good basis to discuss the topic at
>   LSFMMBPF (see [3])

Apparently, KASAN reporting routine takes a lock [1]:

   __asan_load()
     -> check_region_inline()
        -> kasan_report()
           -> start_report()
             -> raw_spin_lock_irqsave(&report_lock, *flags);

BPF programs can run in NMI context, and so it appears to be possible
to get an unflagged (because of lockdep_off() in start_report)
deadlock, if an NMI fires on a CPU already holding report_lock.
Although I guess you'd need two KASAN bugs to happen
simultaneously for that to occur?... A rare event, I would hope.

It could be addressed with either in_nmi() check at runtime, or
forbidding kasan for NMI-runnable BPF program types.

That said, this may be a case of being overly defensive to appease the
ai overlords.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/kasan/report.c?h=v7.0#n204

> 
> Despite this series not being ready for integration yet, anyone
> interested in running it locally can perform the following steps to run
> the JITed KASAN instrumentation selftests:
> - rebasing locally this series on [2]
> - building and running the corresponding kernel with kasan_multi_shot
>   enabled
> - running `test_progs -a kasan`
> 
> And should get a variety of KASAN tests executed for BPF programs:
> 
>   #162/1   kasan/bpf_kasan_uaf_read_1:OK
>   #162/2   kasan/bpf_kasan_uaf_read_2:OK
>   #162/3   kasan/bpf_kasan_uaf_read_4:OK
>   #162/4   kasan/bpf_kasan_uaf_read_8:OK
>   #162/5   kasan/bpf_kasan_uaf_write_1:OK
>   #162/6   kasan/bpf_kasan_uaf_write_2:OK
>   #162/7   kasan/bpf_kasan_uaf_write_4:OK
>   #162/8   kasan/bpf_kasan_uaf_write_8:OK
>   #162/9   kasan/bpf_kasan_oob_read_1:OK
>   #162/10  kasan/bpf_kasan_oob_read_2:OK
>   #162/11  kasan/bpf_kasan_oob_read_4:OK
>   #162/12  kasan/bpf_kasan_oob_read_8:OK
>   #162/13  kasan/bpf_kasan_oob_write_1:OK
>   #162/14  kasan/bpf_kasan_oob_write_2:OK
>   #162/15  kasan/bpf_kasan_oob_write_4:OK
>   #162/16  kasan/bpf_kasan_oob_write_8:OK
>   #162     kasan:OK
>   Summary: 1/16 PASSED, 0 SKIPPED, 0 FAILED
> 
> [1] https://lore.kernel.org/bpf/DG7UG112AVBC.JKYISDTAM30T@bootlin.com/
> [2] https://lore.kernel.org/bpf/cover.1776062885.git.xukuohai@hotmail.com/
> [3] https://lore.kernel.org/bpf/DGGNCXX79H8O.2P6K8L1QW1M8K@bootlin.com/
> 
> Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
> ---
> Alexis Lothoré (eBPF Foundation) (8):
>       kasan: expose generic kasan helpers
>       bpf: mark instructions accessing program stack
>       bpf: add BPF_JIT_KASAN for KASAN instrumentation of JITed programs
>       bpf, x86: add helper to emit kasan checks in x86 JITed programs
>       bpf, x86: emit KASAN checks into x86 JITed programs
>       selftests/bpf: do not run verifier JIT tests when BPF_JIT_KASAN is enabled
>       bpf, x86: enable KASAN for JITed programs on x86
>       selftests/bpf: add tests to validate KASAN on JIT programs
> 
>  arch/x86/Kconfig                                   |   1 +
>  arch/x86/net/bpf_jit_comp.c                        | 106 +++++++++++++
>  include/linux/bpf.h                                |   2 +
>  include/linux/bpf_verifier.h                       |   2 +
>  include/linux/kasan.h                              |  13 ++
>  kernel/bpf/Kconfig                                 |   9 ++
>  kernel/bpf/core.c                                  |  10 ++
>  kernel/bpf/verifier.c                              |   7 +
>  mm/kasan/kasan.h                                   |  10 --
>  tools/testing/selftests/bpf/prog_tests/kasan.c     | 165 +++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/kasan.c          | 146 ++++++++++++++++++
>  .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  79 ++++++++++
>  tools/testing/selftests/bpf/test_loader.c          |   5 +
>  tools/testing/selftests/bpf/unpriv_helpers.c       |   5 +
>  tools/testing/selftests/bpf/unpriv_helpers.h       |   1 +
>  15 files changed, 551 insertions(+), 10 deletions(-)
> ---
> base-commit: 7990a071b32887a1a883952e8cf60134b6d6fea0
> change-id: 20260126-kasan-fcd68f64cd7b
> 
> Best regards,
> --  
> Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
> 


