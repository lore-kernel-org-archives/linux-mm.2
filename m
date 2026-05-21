Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926B8CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680E46B0088; Wed, 20 May 2026 23:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631AD6B008A; Wed, 20 May 2026 23:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F95E6B008C; Wed, 20 May 2026 23:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB836B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:17:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A20691C02EB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:17:02 +0000 (UTC)
X-FDA: 84789965484.13.0795EE0
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6501B40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:17:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=b7kTVk7p;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779333420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jELMhKLGUtWyEbvchAP5Mgs2MLb2HNlCeWKkazBlD+8=;
	b=whSMBGffjaK83yaNWTFUgwUlzz9DQh2tG2a8i4p308VxWO2106GNPPPX6JA8tRyvzdxl6q
	fctis57MODX79zU4yrPtwsMEEJ1llaCB38H8bzj0dHFjcMnZ1ctMw2uH6qhvzSnyUN3zuU
	h2mhp6Z1gxBZqH3OWvjPa9eGa6oTFxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779333420; a=rsa-sha256;
	cv=none;
	b=A70CcHt3zjZ1SDQAGE1aqq57cS15H7bqDqfqla5++EwAqSwgjQ97QGQnh0h8WOEf/S4Bst
	NEQiU+sGBPvaCb2L1x6P6lih+T/iVskiH55fpcnnyjGnnuM82XRm6bZWKvyaqnx8EHSAIG
	rFGzxaUFUNRH1covIlxafO7Q8QsuFKc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=b7kTVk7p;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3697c35eab7so3170904a91.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779333419; x=1779938219; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jELMhKLGUtWyEbvchAP5Mgs2MLb2HNlCeWKkazBlD+8=;
        b=b7kTVk7pDiuKVckBGy1wCQa6N8AwMNq5670wJzkgR2ydmlOlQw4+ZLrRV/1HesPtbY
         GgvleRmSY80tgF344B3AOjGFDp4ElxgDFbLLm56tfENl42/Fn8KQ+yNUPh+ASftiVuzF
         TvgGDhE505sHsUPP3QG4g6OEQ/5nDPXd35B3H/NlFIU+BWzV16Q7ZQIXZCOJj5pRvq6N
         fbUJJNii1AGwKM3xYb8s+d+2SIKsRAGHqCXuB675NALM8sIvxidycs6msg0q2vI6gRz2
         2+bQxGaiPriQC21XFYsSIX7/Uja51LR3vyVUD2JyWsCvaTVIztlOcun93/9S/koQysa8
         CR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779333419; x=1779938219;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jELMhKLGUtWyEbvchAP5Mgs2MLb2HNlCeWKkazBlD+8=;
        b=Ja/faxZ3cWQr5cpWbHDsy9rfVdMhNoapu9vY8NanX+pxo5i7uCv2pEWegUahjGRp9l
         usqDammowGBohwrM6PXkmc2ot9/pRBt+vtBL0FFn/7YPt82HV3pkdSv86tZkFd550QcW
         GCiQJNBoKvTfbpDqKSsC6VE8HB65DaPopVjmY4stn4pc1AAvOkVIheYSvq4TEqYyqKwB
         tUITVDZBKhhT06G/h7+ZK8oF7LBUPpa4/K9ELKkjUa4XNpub23Ulci1Z2+SJtKOrVLAV
         2UOckPlj7C09BshAne2YYBeqqMq8fHCO9PQdFYFMeNDsSQpxt50it7ESXf4A3QSquNOB
         12sw==
X-Forwarded-Encrypted: i=1; AFNElJ9uLwto9q/qTu3RDoF+Oh3QXRAJv6quzMRKAbLRe8UUJ8bsoA+4dbqe4UnjGyNRfde98kBA7JwVCw==@kvack.org
X-Gm-Message-State: AOJu0YxMyrk5qbJI1hRA87yKDUyoy1+AeTjoaPVjLiCKW9HGTSSMMCV6
	ZzOuN4j0+NiW6JQpMrmC/YM7AslmP0j432i2hx9ktroaiZMKu7NtdEzZWTug7yWWK1Y=
X-Gm-Gg: Acq92OEFE7OMUZ7nMYB6w9VpQMkeVvovsqh0aHT9Kq42AM06faIO/5TWDZZMMuE9QwM
	o+Q+YozNUzYY1sBmNLSCzcYdaotVNBoto4hBiswTJUy0cyz6I0c8iOEEr72mWArE0BvVEPiY7KA
	i3RZAkrILuNNReggzYOh5El5re+j471kieDnTNGXPRVsk0RycjqHVespx7YDDt9T6CtzLL8PbCn
	ewiCkU+Fdu6ynBMeSwejQtzwngUTe2CE+Op5Wqw9VbpENOodU+vvkGI6HxDLlnUEo/vhgCdUAUb
	mI1zGFJlNYyZkxl+kQCWR3iSbyAtaiUkoY3yh7j5wj6vGGBl4SRUNV91r2IaC0EDjWgUXxCCEvO
	Zor/DdTniVID+p8JK7rykN1gsScZLRONWdq30CAtwzIsxCpmvFLNkOXRU49po9+RG39POC65n/t
	kYe7vxfBWtKpjSSJlzingCRM5J
X-Received: by 2002:a17:90b:1fc6:b0:369:c5f4:9681 with SMTP id 98e67ed59e1d1-36a45626bb0mr1185388a91.22.1779333418913;
        Wed, 20 May 2026 20:16:58 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a3d0d847dsm999527a91.10.2026.05.20.20.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 20:16:58 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 May 2026 23:16:57 -0400
Message-Id: <DIO11ZK1AJTB.1U25TXKLC0W90@etsalapatis.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-3-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-3-tj@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6501B40002
X-Stat-Signature: r9n5kbps89acqa3typfb5of3z1ny7w6q
X-Rspam-User: 
X-HE-Tag: 1779333420-129539
X-HE-Meta: U2FsdGVkX182JO6zgz7O3ntMr3A6dM5FyWLYnrPbvATHBoKy1E7pel/VpEOpN7+/ngISLJ3lgMz5tA4dq4x/c7KTX6LSbeNvOVVl7q3QxskhnhtKAyf9KcKzvrv+3jGDWq6TfT6MxAGPwzliSapDpkGlkrQrOj99Osam6RsgU3vpdjrBymXDdUla3BStAX1dMSMsPogEHVRlMIFIMp9HnSGSbZY2VhAffmP4yxjkomY3FS/Q7aleKjwNE3LHlA/57+a3U3sZVJANyxr2MskFcDiB8lkBo/XdyDsJJHK3i8VmbNq6o27xApXxG45DrXlHQTOPXOao4GLNK/7UC7rmnTT0nSK6/6Dz0RV/B3RNXAA2BUaXfAYZWWIC6bMBMFHW2ElwimQ5Ukcoaz5U3YIvnfp2SCMtNS5csfhaiIn+umfwlniUxeCOl/XQ1EgyaIv4U8mV4EOnCalW+3FKjBtXz5sFqnT2/hNUQewOM3ElqyJ3AMj6jULar0HNrQipyNnen94FZbIQl9/OKw4iaAcqGIWqUHHU9MKwTp7HbQ9biqLDWKWcO/jUK4o67nXsKVjOP/zf1aKYNMKjYVAQkpGXGDNhHwT7WKKfjbJekFqBo4s+gEAcNjQc8Im1RvONuMsLjoFEffGRyS+JhdO8x86/O/OS22wuU3yPHtmIuJPKAy+KXfwxxamsBvQNaKfT57RtZu74DeW8ZhcNcjiVpxICRFVnAhgqVqGyLWqN71LNBvC6ixZO6zWLWvAkOO9GSrYik95FcVaKX4rQ2rkbskCWtJ5te4R4hlR6htfr/t37yfm7MrL/Dm+c0vS6DPv81larI8rvZ6t5kwv3/0S943sIG8D+rbDxmy/rmAeh2vIypBIzolIJqcHJaxCZVjKQ6sgrt8VhI0oNDfUDT7JIV5XkZRPkjp9ao2y7zT98mlk7a5BmrKAevoucllGzFA3toBBOAIWrR0AY+FnJitZocfi
 RrewQy9b
 ydE2qW0i2IvLEalQnjdghm0PbuXtLT6ypM9zl8e1IT6aVKeSNPrCbXvE6LjJWRuuOq/4Cc7HGZjmt0IO/t/lUDHCDsJzLYLEBDmTKdH6xtyCzsTvZEOVmvZIbwFetkfp1UREPaQIwLiw5UOiTbcTMSrYlmb/AdAhqubqNQ/iSnd/POo9fHx99ejP3ML3/Mh/zKtId8aSTyXODjGp0UXKA45gsGjSuM3vEJBtA7RpWikMBLUgLNrgqkJtLa4DkIYDOf0lkHZQR2EbmxE04aYrcZ38TsUSHOmxMVqrPtPeSgmydcU2IpbRQdnsdY6o4v21tjBjnkQg9nhVAtmhjD61PVannr7qQsEx7Ddka052PR74ZgylFyMmt3ivaL06DN7gWPJxX/rbL2+kQ45i+uXBJdhxiLO6iFfizGYeWLMRrFUAKbfihcYNDSC5is7XU6myKxWwvCmg7JgjIxTt58FxljyxsKhnzXmI54uC3r6cVukXp5mbugrj2F58wYQeOqqNSI2C7iQFcZWsmrt8HzCjyPB1tYhD0/0U+6gtMW24qYt+7Rn0JOkA1QL4uyl4s6QnPpR1RfNIALZp+usq+hM2DXIa/v+chgctgr6Sy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> BPF arena usage is becoming more prevalent, but kernel <-> BPF communicat=
ion
> over arena memory is awkward today. Data has to be staged through a trust=
ed
> kernel pointer with extra code and copying on the BPF side. While reads
> through arena pointers can use a fault-safe helper, writes don't have a g=
ood
> solution. The in-line alternative would need instruction emulation or asm
> fixup labels.
>
> Enable direct kernel-side reads and writes within GUARD_SZ / 2 of any
> handed-in arena pointer, without bounds checking. A per-arena scratch pag=
e
> is installed by the arch fault path into empty arena kernel PTEs - x86 fr=
om
> page_fault_oops() for not-present faults, arm64 from __do_kernel_fault() =
for
> translation faults, both after the existing exception-table and KFENCE
> handling. The faulting instruction retries and the access is also reporte=
d
> through the program's BPF stream, preserving error reporting.
>
> bpf_prog_find_from_stack() resolves the current BPF program (and its aren=
a)
> from the kernel stack - no new bpf_run_ctx state is added. Recovery cover=
s
> the 4 GiB arena plus the upper half-guard (GUARD_SZ / 2). The lower
> half-guard is excluded because well-behaved kfuncs only access forward fr=
om
> arena pointers. The kfunc-author contract - access at most GUARD_SZ / 2 p=
ast
> a handed-in pointer - is documented in Documentation/bpf/kfuncs.rst.
>
> The install is lock-free via ptep_try_set(). On race-loss the winning
> installer's PTE is already valid, so the access retry succeeds. The arena
> clear path uses ptep_get_and_clear() so installer and clearer race throug=
h
> atomic accessors. No flush_tlb_kernel_range() afterwards. Stale "not mapp=
ed"
> entries just cause one extra re-fault, cheaper than a global IPI on every
> install.
>
> Scratch exists only to keep the kernel from oopsing on an in-line arena
> access. Its presence at a PTE means the BPF program has already
> malfunctioned, and the violation is reported through the program's BPF
> stream. The only requirement for behavior on a scratched PTE is that the
> kernel doesn't crash. In particular, any user-side access through such a =
PTE
> may segfault. The shared scratch page is freed once during map destructio=
n.
>
> BPF instruction faults continue to use the existing JIT exception-table
> path. This patch changes only the kernel-text fault path. No UAPI flag is
> added. The new behavior is the default.
>
> v2: Use ptep_get_and_clear() in apply_range_clear_cb(). (David)
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> ---

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

>  Documentation/bpf/kfuncs.rst |  14 +++
>  arch/arm64/mm/fault.c        |  10 +-
>  arch/x86/mm/fault.c          |  12 ++-
>  include/linux/bpf.h          |   1 +
>  include/linux/bpf_defs.h     |  11 +++
>  kernel/bpf/arena.c           | 177 +++++++++++++++++++++++++++--------
>  kernel/bpf/core.c            |   5 +
>  7 files changed, 183 insertions(+), 47 deletions(-)
>  create mode 100644 include/linux/bpf_defs.h
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 75e6c078e0e7..6d497e720998 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -462,6 +462,20 @@ In order to accommodate such requirements, the verif=
ier will enforce strict
>  PTR_TO_BTF_ID type matching if two types have the exact same name, with =
one
>  being suffixed with ``___init``.
> =20
> +2.8 Accessing arena memory through kfunc arguments
> +--------------------------------------------------
> +
> +A read or write at any address inside an arena does not oops the kernel.
> +Unallocated arena pages are lazily backed by a scratch page and the
> +access is reported through the program's BPF stream as an error. Only
> +the BPF program's correctness is affected; the kernel itself remains
> +intact.
> +
> +The arena is followed by a ``GUARD_SZ / 2`` (32 KiB) guard region that
> +is also covered by this recovery. A kfunc handed an arena pointer may
> +therefore access up to ``GUARD_SZ / 2`` past it without bounds-checking
> +against the arena. Larger accesses must verify the range explicitly.
> +
>  .. _BPF_kfunc_lifecycle_expectations:
> =20
>  3. kfunc lifecycle expectations
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 920a8b244d59..0d58d667fcd8 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -9,6 +9,7 @@
> =20
>  #include <linux/acpi.h>
>  #include <linux/bitfield.h>
> +#include <linux/bpf_defs.h>
>  #include <linux/extable.h>
>  #include <linux/kfence.h>
>  #include <linux/signal.h>
> @@ -416,9 +417,12 @@ static void __do_kernel_fault(unsigned long addr, un=
signed long esr,
>  	} else if (addr < PAGE_SIZE) {
>  		msg =3D "NULL pointer dereference";
>  	} else {
> -		if (esr_fsc_is_translation_fault(esr) &&
> -		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
> -			return;
> +		if (esr_fsc_is_translation_fault(esr)) {
> +			if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
> +				return;
> +			if (bpf_arena_handle_page_fault(addr, esr & ESR_ELx_WNR, regs->pc))
> +				return;
> +		}
> =20
>  		msg =3D "paging request";
>  	}
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f0e77e084482..b0f103ddbd23 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -8,6 +8,7 @@
>  #include <linux/sched/task_stack.h>	/* task_stack_*(), ...		*/
>  #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
>  #include <linux/memblock.h>		/* max_low_pfn			*/
> +#include <linux/bpf_defs.h>		/* bpf_arena_handle_page_fault	*/
>  #include <linux/kfence.h>		/* kfence_handle_page_fault	*/
>  #include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
>  #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
> @@ -688,10 +689,13 @@ page_fault_oops(struct pt_regs *regs, unsigned long=
 error_code,
>  	if (IS_ENABLED(CONFIG_EFI))
>  		efi_crash_gracefully_on_page_fault(address);
> =20
> -	/* Only not-present faults should be handled by KFENCE. */
> -	if (!(error_code & X86_PF_PROT) &&
> -	    kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
> -		return;
> +	/* Only not-present faults should be handled by KFENCE or BPF arena. */
> +	if (!(error_code & X86_PF_PROT)) {
> +		if (kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs)=
)
> +			return;
> +		if (bpf_arena_handle_page_fault(address, error_code & X86_PF_WRITE, re=
gs->ip))
> +			return;
> +	}
> =20
>  oops:
>  	/*
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0136a108d083..831996c411cf 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -6,6 +6,7 @@
> =20
>  #include <uapi/linux/bpf.h>
>  #include <uapi/linux/filter.h>
> +#include <linux/bpf_defs.h>
> =20
>  #include <crypto/sha2.h>
>  #include <linux/workqueue.h>
> diff --git a/include/linux/bpf_defs.h b/include/linux/bpf_defs.h
> new file mode 100644
> index 000000000000..d98e033b8c0b
> --- /dev/null
> +++ b/include/linux/bpf_defs.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Subset of bpf.h declarations, split out so files that need only these
> + * declarations can avoid bpf.h's full include cost.
> + */
> +#ifndef _LINUX_BPF_DEFS_H
> +#define _LINUX_BPF_DEFS_H
> +
> +bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsi=
gned long fault_ip);
> +
> +#endif /* _LINUX_BPF_DEFS_H */
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 08d008cc471e..1c0b87ecc817 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -53,6 +53,7 @@ struct bpf_arena {
>  	u64 user_vm_start;
>  	u64 user_vm_end;
>  	struct vm_struct *kern_vm;
> +	struct page *scratch_page;
>  	struct range_tree rt;
>  	/* protects rt */
>  	rqspinlock_t spinlock;
> @@ -118,6 +119,11 @@ struct apply_range_data {
>  	int i;
>  };
> =20
> +struct clear_range_data {
> +	struct llist_head *free_pages;
> +	struct page *scratch_page;
> +};
> +
>  static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data=
)
>  {
>  	struct apply_range_data *d =3D data;
> @@ -144,33 +150,59 @@ static void flush_vmap_cache(unsigned long start, u=
nsigned long size)
>  	flush_cache_vmap(start, start + size);
>  }
> =20
> -static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *fr=
ee_pages)
> +static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *da=
ta)
>  {
> +	struct clear_range_data *d =3D data;
>  	pte_t old_pte;
>  	struct page *page;
> =20
> -	/* sanity check */
> -	old_pte =3D ptep_get(pte);
> +	/*
> +	 * Pairs with ptep_try_set() in the kernel-fault scratch installer.
> +	 * Both sides must be atomic.
> +	 */
> +	old_pte =3D ptep_get_and_clear(&init_mm, addr, pte);
>  	if (pte_none(old_pte) || !pte_present(old_pte))
> -		return 0; /* nothing to do */
> +		return 0;
> =20
>  	page =3D pte_page(old_pte);
>  	if (WARN_ON_ONCE(!page))
>  		return -EINVAL;
> =20
> -	pte_clear(&init_mm, addr, pte);
> +	/*
> +	 * Skip the per-arena scratch page. A kernel fault on an unallocated ua=
ddr
> +	 * scratches its PTE. A later bpf_arena_free_pages() over that range wa=
lks
> +	 * here. Without the skip, scratch_page would be freed.
> +	 */
> +	if (page =3D=3D d->scratch_page)
> +		return 0;
> +
> +	__llist_add(&page->pcp_llist, d->free_pages);
> +	return 0;
> +}
> =20
> -	/* Add page to the list so it is freed later */
> -	if (free_pages)
> -		__llist_add(&page->pcp_llist, free_pages);
> +static int apply_range_set_scratch_cb(pte_t *pte, unsigned long addr, vo=
id *data)
> +{
> +	struct page *scratch_page =3D data;
> =20
> +	if (!pte_none(ptep_get(pte)))
> +		return 0;
> +	/*
> +	 * Best-effort install. ptep_try_set() returns false only if another
> +	 * installer (real allocation or concurrent fault) won the cmpxchg.
> +	 * Their PTE is already valid, so the access retry succeeds.
> +	 *
> +	 * No flush_tlb_kernel_range() needed. Stale "not mapped" entries just
> +	 * cause one extra re-fault through this same path.
> +	 */
> +	ptep_try_set(pte, mk_pte(scratch_page, PAGE_KERNEL));
>  	return 0;
>  }
> =20
>  static int populate_pgtable_except_pte(struct bpf_arena *arena)
>  {
> +	/* Populate intermediates for the recovery range (4 GiB + upper half-gu=
ard). */
>  	return apply_to_page_range(&init_mm, bpf_arena_get_kern_vm_start(arena)=
,
> -				   KERN_VM_SZ - GUARD_SZ, apply_range_set_cb, NULL);
> +				   SZ_4G + GUARD_SZ / 2, apply_range_set_cb, NULL);
>  }
> =20
>  static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
> @@ -221,22 +253,29 @@ static struct bpf_map *arena_map_alloc(union bpf_at=
tr *attr)
>  	init_irq_work(&arena->free_irq, arena_free_irq);
>  	INIT_WORK(&arena->free_work, arena_free_worker);
>  	bpf_map_init_from_attr(&arena->map, attr);
> +
> +	err =3D bpf_map_alloc_pages(&arena->map, NUMA_NO_NODE, 1, &arena->scrat=
ch_page);
> +	if (err)
> +		goto err_free_arena;
> +
>  	range_tree_init(&arena->rt);
>  	err =3D range_tree_set(&arena->rt, 0, attr->max_entries);
> -	if (err) {
> -		bpf_map_area_free(arena);
> -		goto err;
> -	}
> +	if (err)
> +		goto err_free_scratch;
>  	mutex_init(&arena->lock);
>  	raw_res_spin_lock_init(&arena->spinlock);
>  	err =3D populate_pgtable_except_pte(arena);
> -	if (err) {
> -		range_tree_destroy(&arena->rt);
> -		bpf_map_area_free(arena);
> -		goto err;
> -	}
> +	if (err)
> +		goto err_destroy_rt;
> =20
>  	return &arena->map;
> +
> +err_destroy_rt:
> +	range_tree_destroy(&arena->rt);
> +err_free_scratch:
> +	__free_page(arena->scratch_page);
> +err_free_arena:
> +	bpf_map_area_free(arena);
>  err:
>  	free_vm_area(kern_vm);
>  	return ERR_PTR(err);
> @@ -244,6 +283,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr=
 *attr)
> =20
>  static int existing_page_cb(pte_t *ptep, unsigned long addr, void *data)
>  {
> +	struct bpf_arena *arena =3D data;
>  	struct page *page;
>  	pte_t pte;
> =20
> @@ -251,6 +291,12 @@ static int existing_page_cb(pte_t *ptep, unsigned lo=
ng addr, void *data)
>  	if (!pte_present(pte)) /* sanity check */
>  		return 0;
>  	page =3D pte_page(pte);
> +	/*
> +	 * Skip the scratch page. The walk is page-table-driven, not range-tree=
-driven,
> +	 * so it can visit scratch PTEs at uaddrs the BPF program never allocat=
ed.
> +	 */
> +	if (page =3D=3D arena->scratch_page)
> +		return 0;
>  	/*
>  	 * We do not update pte here:
>  	 * 1. Nobody should be accessing bpf_arena's range outside of a kernel =
bug
> @@ -286,9 +332,10 @@ static void arena_map_free(struct bpf_map *map)
>  	 * free those pages.
>  	 */
>  	apply_to_existing_page_range(&init_mm, bpf_arena_get_kern_vm_start(aren=
a),
> -				     KERN_VM_SZ - GUARD_SZ, existing_page_cb, NULL);
> +				     SZ_4G + GUARD_SZ / 2, existing_page_cb, arena);
>  	free_vm_area(arena->kern_vm);
>  	range_tree_destroy(&arena->rt);
> +	__free_page(arena->scratch_page);
>  	bpf_map_area_free(arena);
>  }
> =20
> @@ -374,33 +421,37 @@ static vm_fault_t arena_vm_fault(struct vm_fault *v=
mf)
>  		return VM_FAULT_RETRY;
> =20
>  	page =3D vmalloc_to_page((void *)kaddr);
> -	if (page)
> +	if (page) {
> +		if (page =3D=3D arena->scratch_page)
> +			/* BPF triggered scratch here; don't lazy-alloc over it */
> +			goto out_sigsegv;
>  		/* already have a page vmap-ed */
>  		goto out;
> +	}
> =20
>  	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
> =20
>  	if (arena->map.map_flags & BPF_F_SEGV_ON_FAULT)
>  		/* User space requested to segfault when page is not allocated by bpf =
prog */
> -		goto out_unlock_sigsegv;
> +		goto out_sigsegv_memcg;
> =20
>  	ret =3D range_tree_clear(&arena->rt, vmf->pgoff, 1);
>  	if (ret)
> -		goto out_unlock_sigsegv;
> +		goto out_sigsegv_memcg;
> =20
>  	struct apply_range_data data =3D { .pages =3D &page, .i =3D 0 };
>  	/* Account into memcg of the process that created bpf_arena */
>  	ret =3D bpf_map_alloc_pages(map, NUMA_NO_NODE, 1, &page);
>  	if (ret) {
>  		range_tree_set(&arena->rt, vmf->pgoff, 1);
> -		goto out_unlock_sigsegv;
> +		goto out_sigsegv_memcg;
>  	}
> =20
>  	ret =3D apply_to_page_range(&init_mm, kaddr, PAGE_SIZE, apply_range_set=
_cb, &data);
>  	if (ret) {
>  		range_tree_set(&arena->rt, vmf->pgoff, 1);
>  		free_pages_nolock(page, 0);
> -		goto out_unlock_sigsegv;
> +		goto out_sigsegv_memcg;
>  	}
>  	flush_vmap_cache(kaddr, PAGE_SIZE);
>  	bpf_map_memcg_exit(old_memcg, new_memcg);
> @@ -409,8 +460,9 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf=
)
>  	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
>  	vmf->page =3D page;
>  	return 0;
> -out_unlock_sigsegv:
> +out_sigsegv_memcg:
>  	bpf_map_memcg_exit(old_memcg, new_memcg);
> +out_sigsegv:
>  	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
>  	return VM_FAULT_SIGSEGV;
>  }
> @@ -668,6 +720,7 @@ static void arena_free_pages(struct bpf_arena *arena,=
 long uaddr, long page_cnt,
>  	struct llist_head free_pages;
>  	struct llist_node *pos, *t;
>  	struct arena_free_span *s;
> +	struct clear_range_data cdata;
>  	unsigned long flags;
>  	int ret =3D 0;
> =20
> @@ -696,9 +749,11 @@ static void arena_free_pages(struct bpf_arena *arena=
, long uaddr, long page_cnt,
>  	range_tree_set(&arena->rt, pgoff, page_cnt);
> =20
>  	init_llist_head(&free_pages);
> +	cdata.free_pages =3D &free_pages;
> +	cdata.scratch_page =3D arena->scratch_page;
>  	/* clear ptes and collect struct pages */
>  	apply_to_existing_page_range(&init_mm, kaddr, page_cnt << PAGE_SHIFT,
> -				     apply_range_clear_cb, &free_pages);
> +				     apply_range_clear_cb, &cdata);
> =20
>  	/* drop the lock to do the tlb flush and zap pages */
>  	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
> @@ -788,6 +843,7 @@ static void arena_free_worker(struct work_struct *wor=
k)
>  	struct arena_free_span *s;
>  	u64 arena_vm_start, user_vm_start;
>  	struct llist_head free_pages;
> +	struct clear_range_data cdata;
>  	struct page *page;
>  	unsigned long full_uaddr;
>  	long kaddr, page_cnt, pgoff;
> @@ -801,6 +857,8 @@ static void arena_free_worker(struct work_struct *wor=
k)
>  	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
> =20
>  	init_llist_head(&free_pages);
> +	cdata.free_pages =3D &free_pages;
> +	cdata.scratch_page =3D arena->scratch_page;
>  	arena_vm_start =3D bpf_arena_get_kern_vm_start(arena);
>  	user_vm_start =3D bpf_arena_get_user_vm_start(arena);
> =20
> @@ -813,7 +871,7 @@ static void arena_free_worker(struct work_struct *wor=
k)
> =20
>  		/* clear ptes and collect pages in free_pages llist */
>  		apply_to_existing_page_range(&init_mm, kaddr, page_cnt << PAGE_SHIFT,
> -					     apply_range_clear_cb, &free_pages);
> +					     apply_range_clear_cb, &cdata);
> =20
>  		range_tree_set(&arena->rt, pgoff, page_cnt);
>  	}
> @@ -928,23 +986,12 @@ static int __init kfunc_init(void)
>  }
>  late_initcall(kfunc_init);
> =20
> -void bpf_prog_report_arena_violation(bool write, unsigned long addr, uns=
igned long fault_ip)
> +static void __bpf_prog_report_arena_violation(struct bpf_prog *prog, boo=
l write,
> +					      unsigned long addr, unsigned long fault_ip)
>  {
>  	struct bpf_stream_stage ss;
> -	struct bpf_prog *prog;
>  	u64 user_vm_start;
> =20
> -	/*
> -	 * The RCU read lock is held to safely traverse the latch tree, but we
> -	 * don't need its protection when accessing the prog, since it will not
> -	 * disappear while we are handling the fault.
> -	 */
> -	rcu_read_lock();
> -	prog =3D bpf_prog_ksym_find(fault_ip);
> -	rcu_read_unlock();
> -	if (!prog)
> -		return;
> -
>  	/* Use main prog for stream access */
>  	prog =3D prog->aux->main_prog_aux->prog;
> =20
> @@ -957,3 +1004,53 @@ void bpf_prog_report_arena_violation(bool write, un=
signed long addr, unsigned lo
>  		bpf_stream_dump_stack(ss);
>  	}));
>  }
> +
> +bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsi=
gned long fault_ip)
> +{
> +	struct bpf_arena *arena;
> +	struct bpf_prog *prog;
> +	unsigned long kbase;
> +	unsigned long page_addr =3D addr & PAGE_MASK;
> +
> +	prog =3D bpf_prog_find_from_stack();
> +	if (!prog)
> +		return false;
> +
> +	arena =3D prog->aux->arena;
> +	/* a prog not using arena may be on stack, so arena can be NULL */
> +	if (!arena)
> +		return false;
> +
> +	kbase =3D bpf_arena_get_kern_vm_start(arena);
> +
> +	/*
> +	 * Recovery covers the 4 GiB mappable band plus the upper half-guard.
> +	 * Lower guard is unreachable from kfuncs; an address there indicates
> +	 * a different bug class - leave it to the regular kernel oops path.
> +	 */
> +	if (page_addr < kbase || page_addr >=3D kbase + SZ_4G + GUARD_SZ / 2)
> +		return false;
> +
> +	apply_to_page_range(&init_mm, page_addr, PAGE_SIZE,
> +			    apply_range_set_scratch_cb, arena->scratch_page);
> +	flush_vmap_cache(page_addr, PAGE_SIZE);
> +	__bpf_prog_report_arena_violation(prog, is_write, page_addr - kbase, fa=
ult_ip);
> +	return true;
> +}
> +
> +void bpf_prog_report_arena_violation(bool write, unsigned long addr, uns=
igned long fault_ip)
> +{
> +	struct bpf_prog *prog;
> +
> +	/*
> +	 * The RCU read lock is held to safely traverse the latch tree, but we
> +	 * don't need its protection when accessing the prog, since it will not
> +	 * disappear while we are handling the fault.
> +	 */
> +	rcu_read_lock();
> +	prog =3D bpf_prog_ksym_find(fault_ip);
> +	rcu_read_unlock();
> +	if (!prog)
> +		return;
> +	__bpf_prog_report_arena_violation(prog, write, addr, fault_ip);
> +}
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 066b86e7233c..fa368d8920d9 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -3290,6 +3290,11 @@ __weak u64 bpf_arena_get_kern_vm_start(struct bpf_=
arena *arena)
>  {
>  	return 0;
>  }
> +__weak bool bpf_arena_handle_page_fault(unsigned long addr, bool is_writ=
e,
> +					unsigned long fault_ip)
> +{
> +	return false;
> +}
> =20
>  #ifdef CONFIG_BPF_SYSCALL
>  static int __init bpf_global_ma_init(void)


