Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45184D0EE29
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 06:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926216B0008; Wed, 26 Nov 2025 01:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D78A6B000A; Wed, 26 Nov 2025 01:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC666B000C; Wed, 26 Nov 2025 01:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1CE6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 01:14:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C411B9557
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:14:58 +0000 (UTC)
X-FDA: 84151745076.28.5600258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B05240003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:14:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2+Jm4tm;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764137696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6LSysDobRnthSd72nEmOzvteCi+xEJb90N+EReU/z0=;
	b=cHsplgMpjXOSBKUL3iHwOOaSrwK+n5H3bY7SGuJldEBOK7SePrC+72hiPMKN7n3ciJNquH
	KFJkUnpwcIcvtsgLhZ7zVNBYztCRHX6W7m9IG3hUPA5gsYmwHgOebNkhjtmv4LGci5xjqk
	89vsA91E+vRbGOhlMCYFUs9uUYqUXy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764137696; a=rsa-sha256;
	cv=none;
	b=v6WOIsAv6DZTD1mBSR15v/1UzE3jMKaHY7v1QAuWkKGR+FtIgQ5NlE7Rt8bwPrEj3a1yIi
	/eQmZlFxdMzZ6rUeKswcvPRKzQwy0US6ydFIvKrbKsqJNfalWwn2knRxUE1KP+VaSO4sby
	rHO5vS/67BgLo5Uw6+zA8+/q++dhHNs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2+Jm4tm;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE6C144202;
	Wed, 26 Nov 2025 06:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CE4C116B1;
	Wed, 26 Nov 2025 06:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764137694;
	bh=KHq6RTmFZreZl8Ny8VrKdwkCEv/KsgDv4Jdqciors9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r2+Jm4tmyRBJyvRBKWgA2qSpM20+vvWUXMfz2qKCywFp+YE9w+vvTBW6dznpcY0JY
	 DfxsT1iMWt8T3Jdc4dJwm5C20DI9y9BRD/VqahlJp57I3dc8vKhgRJtVbUJ8bnKmX7
	 frEyCAgrrwKREbYV8nkcNrx3KRlQcFogb8mhnbz54xVcfxdQ8qTqrm+AwW2rm2tGzq
	 YASMR7YJLted08W83SurUyWyhCbKmn05bK7cCsp5+1vkAjRzAa6d5gKgOnCBUq9Hzy
	 iWToWEeahr6AlFK5fcaeSN/hgVTKtL3yBnlodlxVH/bwoulwIDVhfvvm2O/MibDea2
	 oHKq232o9k83A==
Date: Wed, 26 Nov 2025 08:14:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com,
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org,
	bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net,
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
	dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com,
	hpa@zytor.com, jgowans@amazon.com, kexec@lists.infradead.org,
	krzk@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
	mark.rutland@arm.com, mingo@redhat.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterz@infradead.org, robh@kernel.org,
	rostedt@goodmis.org, saravanak@google.com,
	skinsburskii@linux.microsoft.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org,
	Breno Leitao <leitao@debian.org>, thevlad@meta.com
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
Message-ID: <aSaazgjKX8PfFDXf@kernel.org>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-13-changyuanl@google.com>
 <a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
 <mafs01plmxngp.fsf@kernel.org>
 <aSW0MF9BXjLnY2Fr@kernel.org>
 <ba690e06-c2a1-4d2e-9428-9ca2ea9f2b86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba690e06-c2a1-4d2e-9428-9ca2ea9f2b86@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B05240003
X-Stat-Signature: 9xzxj31n3o8sfqir1nt6ua6hhwupposn
X-HE-Tag: 1764137696-839473
X-HE-Meta: U2FsdGVkX18GkiOovxPof/xiS86sj2aD4tddbvaPKOjNbxtTBd6ayOBzBhT5wbN+bHZb0gIjgEYEMMZo5VQULdTyAkWglmWXuXWsp2CZsTjq5v4++iG0aXcwUqfQYUoiqKh79LXjWcTbiLh7/ux/WYEliEnneMzBvKY0ggqBIbAmx2rL0+3PhUvBABSkC/wy6D06FaEd9exI4AXO8pc5OQVRlQuaOU+Ougio/6UKI0xuzmqAjICGtNOTyi8iURpH5JR4u3Fd5G95RD5KXosFVzoGCWsg54RTwRDtCmo9FdZxkKH5AflvTjNxxkYVDzvolVWsLEvYKOQZAcADoV1c7Qv61NhR1TPoPzAtq02xdMwBGwWq4KErm5Nx0nnfhcD2cwIqdQpKvETjLtq+xs5ZtYRndW0bF+cyfGcTxedRPNXGFbju5fPJxt1PbpoSE2sctlxXLdzgiyMvM26QoeeqFYqOtI7h2zK8ixQh7AAMNLLbWcwA/l6yQkaKJFh2yLoA+9i4cYa1lXMH7SDRyaESbSg520l5ZgH/ro7ht3CL7fQ5Kxr0zbL0dsLPWDz8YjzdWKEu8x6Ly7Z1sSnDwj94hb9fUCMUYcIkUI3V9mD4YJq0T8e6ckOD4q0bwAGrnPxKaoUZj+vUwGFy1ni0d6yuGnH+KbD9Io7pCdfzgYZNl+Icw+8vKx2DGBmuiXcNdsRVUuoO/6W8z0Os17CN9luZMshAay9ys6PKu3Xblq5wYxvlWgC2qGNSK79fZVzEzzdiavO2Z7o7vg9QMvSK+XNwPAi58rePMM0nz/Fnkn942n9FQpP4eZ/ZQEB/FKnin5Vw8xwKirtc2nQOiuP8Q+9Rl2aJNu/iTXqBxvsWFWRzavdkyMhLz74+v3zzYaTkhc/2E5CmY/Zstzkb5LAJ7QWzl6+LRWahCF3CayUq4NiVeS5FIgujvH6Lb2MHHiHE7z3gIk0Zp8DyeAW8zQTELsC
 sILfcYLq
 QqJ9Q/iPEBuU/Iz85b54hbjQy/7hh9Utod5JT6155OUi2u8ZGABs6cXso8EyH5hvuyxzZuZNDqGQ50Ceg6JbWYNfZAtPAUB5+cH0gJap7IG4bvWvgYCZzVrEykp9GThZUYI1gwGpSOqrjfIryaxVGFcN8lLevjFbkJeLGKCC4ONrSny+1cxIc/nV1XSpIgXOkfqPQWPHoj0Ps6TKWT5gabuuFTvgaaasgdroP+xxBfoWrFJqzPER8qrppgPyyJM9Rme0Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 06:47:15PM +0000, Usama Arif wrote:
> 
> 
> On 25/11/2025 13:50, Mike Rapoport wrote:
> > Hi,
> > 
> > On Tue, Nov 25, 2025 at 02:15:34PM +0100, Pratyush Yadav wrote:
> >> On Mon, Nov 24 2025, Usama Arif wrote:
> > 
> >>>> --- a/arch/x86/realmode/init.c
> >>>> +++ b/arch/x86/realmode/init.c
> >>>> @@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
> >>>>  	 * setup_arch().
> >>>>  	 */
> >>>>  	memblock_reserve(0, SZ_1M);
> >>>> +
> >>>> +	memblock_clear_kho_scratch(0, SZ_1M);
> >>>>  }
> >>>>  
> >>>>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
> >>>
> >>> Hello!
> >>>
> >>> I am working with Breno who reported that we are seeing the below warning at boot
> >>> when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
> >>> manually but we are seeing this several times a day inside the fleet.
> >>>
> >>>  20:16:33  ------------[ cut here ]------------
> >>>  20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
> >>>  20:16:33  Modules linked in:
> >>>  20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
> >>>  20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
> >>>  20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
> >>>  20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
> >>>  20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
> >>>  20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
> >>>  20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
> >>>  20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
> >>>  20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
> >>>  20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
> >>>  20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> >>>  20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
> >>>  20:16:33  Call Trace:
> >>>  20:16:33   <TASK>
> >>>  20:16:33   ? __memblock_reserve+0x75/0x80
> > 
> > Do you have faddr2line for this?
> > >>>  20:16:33   ? setup_arch+0x30f/0xb10
> > 
> > And this?
> > 
> 
> 
> Thanks for this! I think it helped narrow down the problem.
> 
> The stack is:
> 
> 20:16:33 ? __memblock_reserve (mm/memblock.c:936) 
> 20:16:33 ? setup_arch (arch/x86/kernel/setup.c:413 arch/x86/kernel/setup.c:499 arch/x86/kernel/setup.c:956) 
> 20:16:33 ? start_kernel (init/main.c:922) 
> 20:16:33 ? x86_64_start_reservations (arch/x86/kernel/ebda.c:57) 
> 20:16:33 ? x86_64_start_kernel (arch/x86/kernel/head64.c:231) 
> 20:16:33 ? common_startup_64 (arch/x86/kernel/head_64.S:419) 
> 
> This is 6.16 kernel.
> 
> 20:16:33 ? __memblock_reserve (mm/memblock.c:936) 
> Thats memblock_add_range call in memblock_reserve
> 
> 20:16:33 ? setup_arch (arch/x86/kernel/setup.c:413 arch/x86/kernel/setup.c:499 arch/x86/kernel/setup.c:956) 
> That is parse_setup_data -> add_early_ima_buffer -> add_early_ima_buffer -> memblock_reserve_kern
> 
> 
> I put a simple print like below:
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 680d1b6dfea41..cc97ffc0083c7 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -409,6 +409,7 @@ static void __init add_early_ima_buffer(u64 phys_addr)
>         }
>  
>         if (data->size) {
> +               pr_err("PPP %s %s %d data->addr %llx, data->size %llx \n", __FILE__, __func__, __LINE__, data->addr, data->size);
>                 memblock_reserve_kern(data->addr, data->size);
>                 ima_kexec_buffer_phys = data->addr;
>                 ima_kexec_buffer_size = data->size;
> 
> 
> and I see (without replicating the warning):
> 
> [    0.000000] PPP arch/x86/kernel/setup.c add_early_ima_buffer 412 data->addr 9e000, data->size 1000                                                                                          
> ....

So it looks like in cases when the warning reproduces there's something
that reserves memory overlapping with IMA buffer before
add_early_ima_buffer().

> 
> [    0.000348] MEMBLOCK configuration:
> [    0.000348]  memory size = 0x0000003fea329ff0 reserved size = 0x00000000050c969b
> [    0.000350]  memory.cnt  = 0x5
> [    0.000351]  memory[0x0]     [0x0000000000001000-0x000000000009ffff], 0x000000000009f000 bytes flags: 0x40
> [    0.000353]  memory[0x1]     [0x0000000000100000-0x0000000067c65fff], 0x0000000067b66000 bytes flags: 0x0
> [    0.000355]  memory[0x2]     [0x000000006d8db000-0x000000006fffffff], 0x0000000002725000 bytes flags: 0x0
> [    0.000356]  memory[0x3]     [0x0000000100000000-0x000000407fff8fff], 0x0000003f7fff9000 bytes flags: 0x0
> [    0.000358]  memory[0x4]     [0x000000407fffa000-0x000000407fffffff], 0x0000000000006000 bytes flags: 0x0
> [    0.000359]  reserved.cnt  = 0x7
> 
> 
> So MEMBLOCK_RSRV_KERN and MEMBLOCK_KHO_SCRATCH seem to overlap..

It does not matter, they are set on different arrays. RSRV_KERN is set on
regions in memblock.reserved and KHO_SCRATCH is set on regions in
memblock.memory.

So dumping memblock.memory is completely irrelevant, you need to check
memblock.reserved for potential conflicts.
 
> >>>  20:16:33   ? start_kernel+0x58/0x960
> >>>  20:16:33   ? x86_64_start_reservations+0x20/0x20
> >>>  20:16:33   ? x86_64_start_kernel+0x13d/0x140
> >>>  20:16:33   ? common_startup_64+0x13e/0x140
> >>>  20:16:33   </TASK>
> >>>  20:16:33  ---[ end trace 0000000000000000 ]--- 
> >>>
> >>>
> >>> Rolling out with memblock=debug is not really an option in a large scale fleet due to the
> >>> time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:
> > 
> > Is it a problem to roll out a kernel that has additional debug printouts as
> > Breno suggested earlier? I.e.
> > 
> > 	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
> > 		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
> > 			&rgn->base, &rend);
> > 		pr_warn("  Existing region flags: %#x\n", rgn->flags);
> > 		pr_warn("  New range flags: %#x\n", flags);
> > 		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
> > 		WARN_ON_ONCE(1);
> > 	}
> > 
> 
> I can add this, but the only thing is that it might be several weeks between me putting this in the
> kernel and that kernel being deployed to enough machines that it starts to show up. I think the IMA coinciding
> with memblock_mark_kho_scratch in e820__memblock_setup could be the reason for the warning. It might be better to
> fix that case and deploy it to see if the warnings still show up?
> I can add these prints as well incase it doesnt fix the problem.
 
I really don't think that effectively disabling memblock_mark_kho_scratch()
when KHO is disabled will solve the problem because as I said the flags it
sets are on different structure than the flags set by
memblock_reserve_kern().

> > If you have the logs from failing boots up to the point where SLUB reports
> > about it's initialization, e.g. 
> > 
> > [    0.134377] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> > 
> > something there may hint about what's the issue. 
> 
> So the boot doesnt fail, its just giving warnings in the fleet.
> I have added the dmesg to the end of the mail.
 
Thanks, unfortunately nothing jumped at me there.

> Does something like this look good? I can try deploying this (although it will take sometime to find out).
> We can get it upstream as well as that makes backports easier.
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f2..257c6f0eee03d 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1119,8 +1119,13 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>   */
>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -       return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -                                   MEMBLOCK_KHO_SCRATCH);
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> +       if (is_kho_boot())

Please use 

	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH)

instead of indef.

If you send a formal patch with it, I'll take it.
I'd suggest still deploying additional debug printouts internally.

> +               return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +                                           MEMBLOCK_KHO_SCRATCH);
> +#else
> +       return 0;
> +#endif
>  }
>  
>  /**
> @@ -1133,8 +1138,13 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>   */
>  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -       return memblock_setclr_flag(&memblock.memory, base, size, 0,
> -                                   MEMBLOCK_KHO_SCRATCH);
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> +       if (is_kho_boot())
> +               return memblock_setclr_flag(&memblock.memory, base, size, 0,
> +                                           MEMBLOCK_KHO_SCRATCH);
> +#else

If nothing sets the flag _clear is anyway nop, but let's update it as well
for symmetry.

-- 
Sincerely yours,
Mike.

