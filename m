Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80A6606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooN8pDp4
Received: by kanga.kvack.org (Postfix)
	id 8E7E96B05B7; Thu, 29 Oct 2026 18:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF8F6B05B8; Thu, 29 Oct 2026 18:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6276B05B9; Thu, 29 Oct 2026 18:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57BE96B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:12:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC1F4140567
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:12:15 +0000 (UTC)
X-FDA: 85377063030.24.6A9E27C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2915318000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:12:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooN8pDp4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQTsXzaRX7+0ljFV40z6eTGTsIFH1cPIAtZZ0aw7Uo4=;
	b=jgpQ3e3WQZzF0GbCAaRvFCTxLgzSfC3MmcJYhrFNtYPs0HIKGavFgPhygaUyPcXjMci/SN
	KRZkfuj8zAmcsb9eiFCjq/vgqJhoWGd2FKWikd/cdBbJqriJH+vcdSvMQJxUMOHnbjetoc
	OBUAtqxaBJrX39A07fK9AercfrhNHj4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooN8pDp4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311934;
	b=qj/8f99irmLJnNcoUwXCpu9OvPvjyw2E0Jf5fbH5ZQMtzpgJxnlKsPRqKVYKYmzjaTkvBa
	ZGTRmZ3cz3Oacj97AcSEPwDBYT9dCZwiyTTTTu78Mv9fSZ3U52m2OQsVRYDsbfsKKKdDVh
	WCl4Ll32OKGgRxPdVjBzXMEvlqj82gM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97B6143AE8;
	Thu, 29 Oct 2026 22:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E83A1F01816;
	Thu, 29 Oct 2026 22:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793311932;
	bh=rQTsXzaRX7+0ljFV40z6eTGTsIFH1cPIAtZZ0aw7Uo4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ooN8pDp4KF3yus8ObRbzo0tW2AKfvN640ktisMWso1/hChOhvrwrqAagb0dbJ21fS
	 96+RPAhnMIfwXhmrJT9PPcktGjBTJsxnzcHOwk2lwW8GNWoleWdPaqvVxkiVe9lYFq
	 rcRDEdgKEjpv1czBJZou6OUtXEvr8ZRPhK5LINaqGvDBDPVj714f9MA5jzxaYJOayu
	 Yn6NWOSmo+mKfUXUVO7EPpPxSf7UoKBXLnXg6q9XZGaYs5Im1GjKfIrpJEHeS/h02v
	 TCd8aJWGznD9Mfh8EmEf8OEcFF9PnSg4NbiHsu7niehnPw8gSXmRRLR13Sh83JipKI
	 rb7V9vViefx6w==
Content-Type: multipart/mixed; boundary="===============7147148259061016126=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <571f32a410a85199bc9bcecfe07a9a9b6ef425b2052643e64031dd246c13691e@mail.kernel.org>
In-Reply-To: <20261029212551.56964-3-jolsa@kernel.org>
References: <20261029212551.56964-3-jolsa@kernel.org>
Subject: Re: [PATCH bpf-next 2/8] bpf: Add user memory kfuncs
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 29 Oct 2026 22:12:12 +0000 (UTC)
X-Rspamd-Queue-Id: 2915318000A
X-Stat-Signature: 7o99x6js9czrzohjo3o1tbmsxiritazq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793311934-308802
X-HE-Meta: U2FsdGVkX1+x+MzzEgFGCLR0wr5Wm5RlUC3DNGSYHkoFGzy0E04gom19rgAXKUQWqaMj2DaaHqjj+PRbfPpfv004X09jAZsNA+uDLjroGNaX5KTMnL5Xumo4jgOt/svHd76SmcIR1iTBkyC4/iCXE50dH6rqWG+lcpOZWsv3ThVvy9O1NKHZ8qvgbfvr9LnvifafEUOhkLmHnJU6MIl1rnrtIH9aYrJUHRDfnowTBX1jmZnn93xkj/whB2NgM1p2tMfza0vLTqBPIyugP1qweG3/u1aNQ1P5+FETy8CHtgBcAPxBg4XwvmKJjjkHksvLhtzmucmDebK1pVGMdXZ7bsgA/wPrcwAaLLNwNHRFLveRTCaLpR8fn9Zh+2n83GpVKzPLAk5UPM7p93ZRnwzA2AcLlEhdJ8fVeQ4WJ9czuNDUewMtPIyoAJKm9BgJA19L31P/GbzvmcR+HiSZ2UjMzw8Ag3F25UNyzY6ssQtsoPBVY8vPLfKeg10OPvQvUJlzD++p8BvGCx1NpfetMffu0zzlTv+IPok2HSf/65dk6OKYmfllBGafU4JL2Ks1NjfM3dCBIpmBHsyXjIRUIaFHSoVkfMRu5LHY2RTLSJS2/9gyhn7ywPvtmVT3efj0PjKPI4F5W9c5ROTOwD3Gi7q7q5n2FHOq6fSVI7efStVoRr/I6wT6Zu4KKm6QJmUIJqpumHQLYuD7iLlPp4cTA6MBDEp1ot+30Gyg+P1wJESpf/QngEZedu3w/K6J1lYScOSqzWdF0oNT/QNmlxM69Xvn+tXjGDPrDrlrI6V1aBwLNiHLV8vW+eVgr0xtKaGIcIGHsbYC4VZCe42auhLKRYg5q3x1vloeIncyiRBFNU+Mw8GRBBL8qOXgCC++1X8EJ0/dTpP3itWGECF2hpLDm5vVN2+BBKRQzgYfEVGx/xPuBNmO3NB4FpnX4/IEAB/Uc43/vAhDjmNi59SOlUi9Mse
 od96cMK3
 sQekasFomJW7UIfwASGxGg5ylWNHFWtMa+rbcWsF0Ppg2ix2nBxiBJVatJRttlLVc5JfS1N0znxSiCq1mzTx2xqFFCG1FEmZnhI7e+g09qQR6lf/SNpVxrO+xPcuUmMNEKnpRdf1caEW5Pet4uIs3Ym3A9hxhv5BvCRLHF83yPnrvsM/Naam6RlUa0u2Nqk/oGh+8HWCaxJkmGej8v4GX9kE/OSPU4roA3mhhVmWcQTgcPR30xTypSm4eilwoqNAysdCmCwXPk57Aurr5++Jos0g8niVgDRBaVqF0QgSmPjmn/JfzEhOXlNyAjqgFzvSvDsJXlVPhtAdy1CtTOuv3LzgC4F0oIQPV/yGBR7u3hlTQN/rII+zIA0iNyre/WdzCB+O+YckhBnBB/XXsf6rP7riHk5m+O5d5iP/tq9YW9z+DQ49co4KJNStybsYT9yjJpK4+xfAoKxR8/cWy0BHuBo6io4AAZuU/KM7tPVOIGC8cA4HKENdGaD+AH7xDpsZMexENAXEZkxSNouzgRirro/v5+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7147148259061016126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Add user memory kfuncs

TL;DR:
- bpf_user_mmap() may return -ENOMEM for ia32 tasks (and some 64-bit tasks
  with X32_ABI) on x86, since vm_mmap() isn't called from a syscall
- Skipping arch_validate_prot() may allow mappings mmap(2) rejects, e.g.
  powerpc PROT_SAO

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 648abe1ba63a..0540e415c7dd 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3738,6 +3741,83 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,

[ ... ]

> +/**
> + * bpf_user_mmap() - Map private anonymous memory into the current process
> + * @len:  Length of the mapping
> + * @prot: PROT_* flags of mmap(2), including PROT_EXEC
> + *
> + * This maps memory by calling vm_mmap() directly. It does not invoke the
> + * mmap(2) syscall, so seccomp filters do not mediate this mapping.
> + *
> + * Return: The address of the mapping on success, -EPERM if the caller has no
> + * user mm, or an unsigned-long encoded negative error code, as returned by
> + * vm_mmap().
> + */
> +__bpf_kfunc unsigned long bpf_user_mmap(unsigned long len, unsigned long prot)
> +{
> +	if (!bpf_user_mm_ok())
> +		return -EPERM;
> +	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> +}

Can this vm_mmap() call fail for ia32 tasks, and for 64-bit tasks when
CONFIG_X86_X32_ABI=y, because it is not made from a syscall?

On x86_64 the address picked by vm_mmap() depends on the bitness of the
current syscall:

vm_mmap()
  do_mmap()
    __get_unmapped_area()
      arch_get_unmapped_area_topdown()
          info.high_limit = get_mmap_base(0);

arch/x86/mm/mmap.c:get_mmap_base() {
    if (in_32bit_syscall()) {
        return is_legacy ? mm->mmap_compat_legacy_base
                         : mm->mmap_compat_base;
    }
    return is_legacy ? mm->mmap_legacy_base : mm->mmap_base;
}

The sleepable kprobe programs that can call this kfunc run either from
uprobe_notify_resume() -> handle_swbp() -> handler_chain() (or
uprobe_prog_run()) on the int3 return-to-user path, or from bpf_task_work
callbacks run by task_work_run().  TS_COMPAT is set only in
syscall_32_enter() and is cleared on every return to user mode, so it is
clear in all of these paths.

For an ia32 task (TIF_ADDR32) on a kernel without CONFIG_X86_X32_ABI, the
top-down search therefore runs below the 64-bit mm->mmap_base.  Everything
above 4GB is free in such a task, so the search returns an address above 4GB
and __get_unmapped_area() rejects it:

    if (addr > TASK_SIZE - len)
        return -ENOMEM;

The bottom-up legacy layout fails the same way, because find_start_end() also
starts from get_mmap_base(1).  So the kfunc always returns -ENOMEM for ia32
processes.

With CONFIG_X86_X32_ABI=y the result is the opposite.  Exception entry
stores orig_ax = -1, so in_x32_syscall() is true in the uprobe handler and
64-bit processes get the compat (below 4GB) layout.  A large len then fails
with -ENOMEM in the bottom-up fallback (end = task_size_32bit()) even though
64-bit address space is free.

The kernel documents this dependency in __set_personality_x32(): "The x86
mmap() code relies on the syscall bitness so set x32 syscall bit right here
to make in_32bit_syscall() work during exec()".  The uprobes XOL area avoids
the problem by passing an explicit TASK_SIZE - PAGE_SIZE hint.

Neither the kernel-doc ("into the current process") nor the commit message
mentions this limitation, and the selftests later in the series only exercise
64-bit binaries.  Should this limitation be handled or documented?

Also, does passing prot straight to vm_mmap() skip the architecture prot
validation that mmap(2) performs?  The kernel-doc describes @prot as "PROT_*
flags of mmap(2)", but the mmap(2) entry points call arch_validate_prot()
and the vm_mmap() path does not.  For example, on powerpc64:

arch/powerpc/kernel/syscalls.c:do_mmap2() {
    if (!arch_validate_prot(prot, addr))
        return -EINVAL;
    ...
}

arch_validate_prot() in arch/powerpc/include/asm/mman.h rejects:

- any bit outside PROT_READ|PROT_WRITE|PROT_EXEC|PROT_SEM|PROT_SAO
- PROT_SAO when !cpu_has_feature(CPU_FTR_SAO), for example on Power10
- PROT_SAO in a guest without CONFIG_PPC_PROT_SAO_LPAR

vm_mmap() -> vm_mmap_pgoff() -> do_mmap() never calls arch_validate_prot().
Instead do_mmap() -> calc_vm_prot_bits() -> arch_calc_vm_prot_bits() sets
VM_SAO for PROT_SAO without any check, and vm_get_page_prot() then adds
_PAGE_SAO to the page table entries.

So a program can create strong-access-ordering mappings that the architecture
code deliberately refuses.  The Kconfig help for PPC_PROT_SAO_LPAR warns that
using them may cause issues when migrating a guest from a host that supports
strong access ordering to one that does not.

Would it make sense to validate prot with arch_validate_prot(), or to
restrict it to PROT_READ|PROT_WRITE|PROT_EXEC?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40959191771
--===============7147148259061016126==--

