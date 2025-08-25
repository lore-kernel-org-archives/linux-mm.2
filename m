Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08FBCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259338E005B; Mon, 25 Aug 2025 13:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230AD8E0038; Mon, 25 Aug 2025 13:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D688E005B; Mon, 25 Aug 2025 13:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 070F58E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:17:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C0311DDC12
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:17:14 +0000 (UTC)
X-FDA: 83815935588.10.504343D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2BE4C0012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:17:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4UkVnPS;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756142232; a=rsa-sha256;
	cv=none;
	b=BDN+bt+7A5bxBDME6qYONFLHBZY8MljhQQCFSuEsIgwbedRix/A0AZ+r6gKkGEfDqVnOPX
	KeRj+i05t0N8D0Ik3/jPSIh+ZUqN3Cx4jcBISS0IFAY2AgPdLwckKouk7VU4n4vsZkhzOv
	15lHSsCoe87RNP98oKmO1kcbwqTzlX8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4UkVnPS;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756142232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFkafUW92m/2ecZ5LtRNShxTUu1gOQb4haZ8gbIIYYA=;
	b=K9rBBudsza16WDUiRCM+Qxqty6krQJZvIlBsZecwmBnWGw7mq/UauBT0t6Zn3WzU3o6Nej
	plPGyoZWVHsjkNHLeLy632dO7bs2/q2x2xRMVgqVynXeBJaiFNOnC75y/C2zkYEUDmA5er
	u/6NmZUTw3uMQpt8FQSPWedCnCZwk88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CB9A6023B;
	Mon, 25 Aug 2025 17:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73417C4CEED;
	Mon, 25 Aug 2025 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756142227;
	bh=fanRgUaxIj09krYa7fxG1OndohAbT5Q13tqT+sXc9hY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4UkVnPSVEy/q7m+lriWEU0OD6KJ183jkCaMpnxprhCPsumeklpe/KAiUrRlV189T
	 R2zLcPPXieceyDBHOKhOQj2p8Q+9XFUvH5E9NAfqL4jIPPHA8edNeR6UXP0JTP5GnI
	 EO92FF3+tJDd9Wef2UOYZ8xEmgplHwL/VNC/JEWmIBHC8tKCq03lbc4BZFXQlD2smz
	 VBXcH3TUsC000gZHAq8aAtG89ZQIIb6+kE2LMrZHbsy4IBT8HNRStju185P0h6PZa6
	 t/uEq1AS0DIVbznf1/KhrFGO+GFh1CkOSdqynrzXsxFtzaIjyHd7BDIrU2Ol43ZNlb
	 q3Y4pbpqugNIQ==
Date: Mon, 25 Aug 2025 10:17:07 -0700
From: Kees Cook <kees@kernel.org>
To: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [RFC RESEND v2] binfmt_elf: preserve original ELF e_flags for
 core dumps
Message-ID: <202508251009.CB5EB2E304@keescook>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <20250811095328.256869-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811095328.256869-1-svetlana.parfenova@syntacore.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D2BE4C0012
X-Stat-Signature: iw4xku3rikkrgsem14iyjj7tipet56tq
X-Rspam-User: 
X-HE-Tag: 1756142232-99250
X-HE-Meta: U2FsdGVkX18fZG5FN8SAqJhdqABN5ienQumCOkyAgrX1X82wYdtSP76AcsNqCP1Fajh/khmHNc8TjWt2Ci9XDRwbQfl3W99HjLq4exO82UHhlq3KK94MQvc60mSdCo5WfTOf9rAJBb+zMh0I96HFEUPPuTdDyA1yisqWZ8JMFUpo2P8053F7pB1066rMsCDsn1jIjWY3SXVIeqxbr5GmcJuY3wv2aXv5G42Cgo66zhOTwCMNbl750qzFTY86nIj/ToJWXMx3x1u3XoRKF5p6DMJTZ8DAVRAB/CdouJjs1casnKOgXKcuQFJTeiacBB3rOZ45JBa+SCViQsPrc7pLXwJLURWNOFEwK6qpp3S/UOyEZ0+5guuD6Ky8oBXuwLigW8PHbSiJCtN01E7rh6/KooH7qWGHO595RSTsYxbe9h4ZpQ57mPQEea44KjX8gVANtc+cTTHud94Uc4OA95HqVYX3tHmLUlpbiN7k/k3oNtQN973eugnm4nei12gevNVVZmjksr0k16wTSln7J4UXseWnQpZZiIILkCbhlQDdcBZlLb2V1TQTMEFmq7fNocADLIIbnvNIpFhk0XArIKBarBYaC0EWX/meyN4P3ReJRa6sD/3nm9eyMcY7vHsgeqzjqBLL9q/kO3khgrqhQxvCO9YJ5JXTkuTv9BqntCVYy5r1DQ5A9UIMH/1Jl5amxB9Q6lL6rOzD2GMEaRdNSQ9cc+LlzMhp99RL/LJJcdZ6B3FhaEuwOud5ZJX8aPdUdYFcLruxHI7xgShJXej5sQUWTrRdXF9pkv617OLylFpgXOlek55dyljCZrqoOJJnByBX+jEARfgKt6mT1ugx2ehwqyLIuQ74850WxC8SN75ZuAVsg9OHOuW3UaGb+PI0fYBd3oMItzInJYkb/xWdUTKXq3Kn/M4nIeY15KRNXe5J3soAnCYkKHhVR3OfwQuHl5Zm5Wqan+QX1brsGiwJ9xv
 boMagtJW
 28ifsjvLHy24jKIYAWyBW0J13ajHra9BsEMhbgmUZpiZXwn7H8KcoL21JCoH8hUyKvXKbtYmEBMFQU91GVi0CAgystPg7cHA0WeiedOg4BZuia05saIKgg1iQr8N62rrCgR5/LkRbJvPc2wwG7bR2/AAGqIEkIxCi3Wx3Mms0mzK/erswlkY21RB0aGW4XxJwGAjUNGVFWXLkDsXfhLh3VQGL6qlkjEFiWtfckAJewtxqXkTkA/dH5uVczv5a1GT/d96+WWMlM9p1cDMf18tDeIOeNRiWGYDPgh8Pj7zHLXnDjCS0gFloZ8DyDw24uSrXOjdm2Z0IauaGt8GwTr/Fgq1BZHs9K0G71Qw1ydIQ3JBYGkRtu4wtjsl5ajGZE9ryxfnsIR7lnCmn3tk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 03:53:28PM +0600, Svetlana Parfenova wrote:
> Some architectures, such as RISC-V, use the ELF e_flags field to encode
> ABI-specific information (e.g., ISA extensions, fpu support). Debuggers
> like GDB rely on these flags in core dumps to correctly interpret
> optional register sets. If the flags are missing or incorrect, GDB may
> warn and ignore valid data, for example:
> 
>     warning: Unexpected size of section '.reg2/213' in core file.
> 
> This can prevent access to fpu or other architecture-specific registers
> even when they were dumped.
> 
> Save the e_flags field during ELF binary loading (in load_elf_binary())
> into the mm_struct, and later retrieve it during core dump generation
> (in fill_note_info()). A new macro ELF_CORE_USE_PROCESS_EFLAGS allows
> architectures to enable this behavior - currently just RISC-V.
> 
> Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
> ---
> Changes in v2:
>  - Remove usage of Kconfig option.
>  - Add an architecture-optional macro to set process e_flags. Enabled
>    by defining ELF_CORE_USE_PROCESS_EFLAGS. Defaults to no-op if not
>    used.
> 
>  arch/riscv/include/asm/elf.h |  1 +
>  fs/binfmt_elf.c              | 34 ++++++++++++++++++++++++++++------
>  include/linux/mm_types.h     |  3 +++
>  3 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
> index c7aea7886d22..5d9f0ac851ee 100644
> --- a/arch/riscv/include/asm/elf.h
> +++ b/arch/riscv/include/asm/elf.h
> @@ -20,6 +20,7 @@
>   * These are used to set parameters in the core dumps.
>   */
>  #define ELF_ARCH	EM_RISCV
> +#define ELF_CORE_USE_PROCESS_EFLAGS

Let's move this to the per-arch Kconfig instead, that way we can use it
in other places. Maybe call in CONFIG_ARCH_HAS_ELF_CORE_EFLAGS?

>  
>  #ifndef ELF_CLASS
>  #ifdef CONFIG_64BIT
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index caeddccaa1fe..e52b1e077218 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -66,6 +66,14 @@
>  #define elf_check_fdpic(ex) false
>  #endif
>  
> +#ifdef ELF_CORE_USE_PROCESS_EFLAGS
> +#define elf_coredump_get_process_eflags(dump_task, e_flags) \
> +	(*(e_flags) = (dump_task)->mm->saved_e_flags)
> +#else
> +#define elf_coredump_get_process_eflags(dump_task, e_flags) \
> +	do { (void)(dump_task); (void)(e_flags); } while (0)
> +#endif

Let's make specific set/get helpers here, instead.

static inline
u32 coredump_get_mm_eflags(struct mm_struct *mm, u32 flags)
{
#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
	flags = mm->saved_e_flags;
#else
	return flags;
}

static inline
void coredump_set_mm_eflags(struct mm_struct *mm, u32 flags)
{
#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
	mm->saved_e_flags = flags;
#endif
}


> +
>  static int load_elf_binary(struct linux_binprm *bprm);
>  
>  /*
> @@ -1290,6 +1298,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	mm->end_data = end_data;
>  	mm->start_stack = bprm->p;
>  
> +	/* stash e_flags for use in core dumps */
> +	mm->saved_e_flags = elf_ex->e_flags;

Then this is:

	coredump_set_mm_eflags(mm, elf_ex->e_flags);

> +
>  	/**
>  	 * DOC: "brk" handling
>  	 *
> @@ -1804,6 +1815,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  	struct elf_thread_core_info *t;
>  	struct elf_prpsinfo *psinfo;
>  	struct core_thread *ct;
> +	u16 machine;
> +	u32 flags;
>  
>  	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
>  	if (!psinfo)
> @@ -1831,17 +1844,26 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
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
> +	/*
> +	 * Override ELF e_flags with value taken from process,
> +	 * if arch wants to.
> +	 */
> +	elf_coredump_get_process_eflags(dump_task, &flags);

And this is:

	flags = coredump_get_mm_eflags(dump_task->mm, flags);

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
> index d6b91e8a66d6..e46f554f8d91 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1098,6 +1098,9 @@ struct mm_struct {
>  
>  		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>  

And then add:

#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS

> +		/* the ABI-related flags from the ELF header. Used for core dump */
> +		unsigned long saved_e_flags;

#endif

around this part

> +
>  		struct percpu_counter rss_stat[NR_MM_COUNTERS];
>  
>  		struct linux_binfmt *binfmt;
> -- 
> 2.50.1
> 

-- 
Kees Cook

