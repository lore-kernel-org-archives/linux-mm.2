Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFD3C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2784D8E000E; Wed,  6 Aug 2025 14:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229A58E0002; Wed,  6 Aug 2025 14:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118658E000E; Wed,  6 Aug 2025 14:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F373E8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:57:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 896411365B2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:57:36 +0000 (UTC)
X-FDA: 83747241312.05.5CC9897
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C201040013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:57:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5DgpZMb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754506655; a=rsa-sha256;
	cv=none;
	b=2JsARqC8vdXt484W5uABqPERkMrjXamFxEdHBThd48Ryr+xWrPl+tvm5ugbNfGAM56v0rm
	ph+MoXXWRuhpnx5nbsZhpOq+McyzznHpn49t3nJU5ZGGm2kZ+IelGReEWrd4XCTQa9heJI
	p4DVOsTcdGASNjLpKr5Wv0TIccs9QEY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5DgpZMb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754506655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adSdq3TwyTGHTDYm+HrW/qgmY2je4v4jMKvY5+Usnv8=;
	b=8o5HfuwxuIk+2l5eK+VIJvmVZtncQBL1F7IAG2eF4AFIJZcMVk0e7UllKjh6jW+cp2qoEA
	xk8Ps7H647HlRExIRaddqmYATAeH91Vh3aEUobdl8heOCx7y2lJzll4tM9KgeHXm81naP8
	/RBrvyB9gehNcNJTmKpDvs5982EP7q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D8FB43ABC;
	Wed,  6 Aug 2025 18:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC07C4CEE7;
	Wed,  6 Aug 2025 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754506653;
	bh=S1tpOXHvVmGvkkUcDTVIht6ckWqyaRnBwEeo7jDPZu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u5DgpZMbBrMlEHCD0U2XV9oAFeSNwqE2saBD4NroNIwSwfQOb6fR/e+Hj+9dkXYza
	 GSdnwVTypo0RrO1uPIi9p5Gqgw4zsLp9qhaHYpo0fGtuA457QbxgTpNfPio863LrTQ
	 eE/2/ZbnCVJ75QckPgb1x3qVBiirfktGC62Y/rdLagTJEQ1cwOQrfn77EHN7tACR6k
	 bOOrjC0euY0CI30rXkLWpEgVVxW8u1x8ZX5SED+CC6sycNRZn8b0Rl7vZF3GvgW088
	 63MpRrSxhEIoxOV5Y40cqoToFFG/aWeNYTEWMcnI74UVv+t4xrHm5jhdGDglSVCJ2Q
	 mlvn4La0hLeiw==
Date: Wed, 6 Aug 2025 11:57:32 -0700
From: Kees Cook <kees@kernel.org>
To: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [RFC RESEND] binfmt_elf: preserve original ELF e_flags in core
 dumps
Message-ID: <202508061152.6B26BDC6FB@keescook>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C201040013
X-Stat-Signature: 8c4swax5akki1hquykd7gwwkym1nopep
X-HE-Tag: 1754506654-972078
X-HE-Meta: U2FsdGVkX1+dkGMeU8JQXrIuphxi2Um98y6dNE/VEG1d6kz6s7Jj/sBD2d+HnFb2lrgYgMmYbjwW9b1eqimMcZZ6pCxlSduHpavhuYjARHmEfAwJU5w88jEhJ+xWL+AwyswKEBsV4lIbjCWR2O3cl+VEQz/yDWqnMYoGE3yC8VZ4z2FT0Lguud6VMYYFLBVdB6CxS0Iq4ohz1qz/pnWVmOAvekIDNAq9/Z4NCzFux8QN1VkNZK/66XDIXCSShkOlBqQjqkEO+sJzVWrHaZ4HCujGkUBOqy0e+A381Nr2GVrO6ALYIcdO3Z4GIS4cGSYRiKq3J2bYNMym/r8nWKZE6AwU80QOMXNs/XyMnh5ZJbbYWVtzZ8yIUlYrCSlxP4cdESUBxqHD7+s6k4hKqGlMa5uMLSsXdLn68E3kdGkY/f6KKhy/v0cR0rT6qake/dh7XFe1sU/hENASmn+l7d+nVB8K88jL9/nSceuxNyTUA5c3gfwf+yMv5VvAyW6r0g2kggzUPSDP6H1oHzVGhLCe6q6jPa5wN//697Ob3OfeaTZmuEgWTw/JjjtotpmAZh6REwZn4+APn34YmibeRup8jt2LjgpSkesGsT96UU1dPS66UdrN/LIaHFJ7yiRmi4Xy8Rgjshxs0g/cXJcxxlR3jhzaWLnmBAn/cim7K6j6RYNoeLP+/vMiw0KTIx/+eWq4INDjCkuxXnYI7WmIuz050cRjOu1hYeS6VqNPqT9bbvPoSxh0g/Xyk7IhnJWO6CXvu8O8LfjebOZWNUDdEiCMMtSpU6QnRjg/VNsiU7c+k7cSk3sXPgmlhtlNyHhY2fSHsws/GFcGAwmUHbKHZ0iiFlBDAETUhaWBwQYaEW0x+ebup5Ql8LUV7OyOZa0z3GirtcJuKy6oAIJe6TM6aEicgJ6qrJ4LifxyuTAVuHLYMBo635z0LTNuBEiwNT7AB1EOedYTfWixNR23KedPj6+
 hg5RBEBx
 qTc5Q9gwh+r4NdfbSEIKdK7QJ7kbtr8g03FTrpeGBTAUPUumww/8I6ysh1gVlhhhiBDj+9HiEFm/Q3hHI2R3vc+dT8kz5O0ES98J55R7wK8NbiadF5lD22vqzn6569nnnfouccWho3qdxDBriZr27K5zQ6QXZVFAvGI/9ggl77YGu23aG/j5nNMawbKwQIBvu9L/t1e34pC8hOg79mphdmS54iyekGhJgW0KZ2HlgRxlTw8SFd+si9NHwUDEHX+7mwjYTm2aUDtHgBBY7Muwugz+oxNSovsL2jzp6CMbf1PTi/sd+b8iRYczGhjZnrrxwkRGXxQugHdk/0sjRKX6X73Cp0AcsIpFRxN5IwCyC9rzYRIj03ybGTqll7DH387Sk4dBG3Mqeapwu7uJGGYyZ0HVSADa3JSfOw3UhDKUNsSzBZzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:18:14PM +0600, Svetlana Parfenova wrote:
> Preserve the original ELF e_flags from the executable in the core dump
> header instead of relying on compile-time defaults (ELF_CORE_EFLAGS or
> value from the regset view). This ensures that ABI-specific flags in
> the dump file match the actual binary being executed.
> 
> Save the e_flags field during ELF binary loading (in load_elf_binary())
> into the mm_struct, and later retrieve it during core dump generation
> (in fill_note_info()). Use this saved value to populate the e_flags in
> the core dump ELF header.
> 
> Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS, to guard
> this behavior. Although motivated by a RISC-V use case, the mechanism is
> generic and can be applied to all architectures.

In the general case, is e_flags mismatched? i.e. why hide this behind a
Kconfig? Put another way, if I enabled this Kconfig and dumped core from
some regular x86_64 process, will e_flags be different?

> This change is needed to resolve a debugging issue encountered when
> analyzing core dumps with GDB for RISC-V systems. GDB inspects the
> e_flags field to determine whether optional register sets such as the
> floating-point unit are supported. Without correct flags, GDB may warn
> and ignore valid register data:
> 
>     warning: Unexpected size of section '.reg2/213' in core file.
> 
> As a result, floating-point registers are not accessible in the debugger,
> even though they were dumped. Preserving the original e_flags enables
> GDB and other tools to properly interpret the dump contents.
> 
> Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
> ---
>  fs/Kconfig.binfmt        |  9 +++++++++
>  fs/binfmt_elf.c          | 26 ++++++++++++++++++++------
>  include/linux/mm_types.h |  5 +++++
>  3 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index bd2f530e5740..45bed2041542 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -184,4 +184,13 @@ config EXEC_KUNIT_TEST
>  	  This builds the exec KUnit tests, which tests boundary conditions
>  	  of various aspects of the exec internals.
>  
> +config CORE_DUMP_USE_PROCESS_EFLAGS
> +	bool "Preserve ELF e_flags from executable in core dumps"
> +	depends on BINFMT_ELF && ELF_CORE && RISCV
> +	default n
> +	help
> +	  Save the ELF e_flags from the process executable at load time
> +	  and use it in the core dump header. This ensures the dump reflects
> +	  the original binary ABI.
> +
>  endmenu
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index caeddccaa1fe..e5e06e11f9fc 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1290,6 +1290,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	mm->end_data = end_data;
>  	mm->start_stack = bprm->p;
>  
> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
> +	/* stash e_flags for use in core dumps */
> +	mm->saved_e_flags = elf_ex->e_flags;
> +#endif

Is this structure actually lost during ELF load? I thought we preserved
some more of the ELF headers during load...

> +
>  	/**
>  	 * DOC: "brk" handling
>  	 *
> @@ -1804,6 +1809,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  	struct elf_thread_core_info *t;
>  	struct elf_prpsinfo *psinfo;
>  	struct core_thread *ct;
> +	u16 machine;
> +	u32 flags;
>  
>  	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
>  	if (!psinfo)
> @@ -1831,17 +1838,24 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  		return 0;
>  	}
>  
> -	/*
> -	 * Initialize the ELF file header.
> -	 */
> -	fill_elf_header(elf, phdrs,
> -			view->e_machine, view->e_flags);
> +	machine = view->e_machine;
> +	flags = view->e_flags;
>  #else
>  	view = NULL;
>  	info->thread_notes = 2;
> -	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
> +	machine = ELF_ARCH;
> +	flags = ELF_CORE_EFLAGS;
>  #endif
>  
> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
> +	flags = dump_task->mm->saved_e_flags;
> +#endif

This appears to clobber the value from view->e_flags. Is that right? It
feels like this change should only be needed in the default
ELF_CORE_EFLAGS case. How is view->e_flags normally set?

> +
> +	/*
> +	 * Initialize the ELF file header.
> +	 */
> +	fill_elf_header(elf, phdrs, machine, flags);
> +
>  	/*
>  	 * Allocate a structure for each thread.
>  	 */
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d6b91e8a66d6..39921b32e4f5 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1098,6 +1098,11 @@ struct mm_struct {
>  
>  		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>  
> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
> +		/* the ABI-related flags from the ELF header. Used for core dump */
> +		unsigned long saved_e_flags;
> +#endif
> +
>  		struct percpu_counter rss_stat[NR_MM_COUNTERS];
>  
>  		struct linux_binfmt *binfmt;
> -- 
> 2.50.1
> 

-Kees

-- 
Kees Cook

