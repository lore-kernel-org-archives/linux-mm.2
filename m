Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE82D41C07
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1CC6B0005; Thu, 11 Dec 2025 03:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C376B0007; Thu, 11 Dec 2025 03:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223DF6B0008; Thu, 11 Dec 2025 03:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC686B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:48:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0E521407F1
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:47:59 +0000 (UTC)
X-FDA: 84206562678.27.112F279
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F32E1180012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:47:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJ0iyKYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765442878; a=rsa-sha256;
	cv=none;
	b=u86Y02OvGNgJ41dhZ88iPeIYXR6G0LzrQzVL5zgc8YrmJ31UDpKnMuWLSFiFDi8YhThH1z
	0Axe4EzrWbDLbSzE01MXbm70H110VnykFnBMspnDWmdDu1WyaB0phMu0IMSwXVVhzFjmHR
	C1H1OarfhtvrvP0TFvhSeu8zRktJd1s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJ0iyKYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765442878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axg/xYyoTF1MoYsK+FAGR4FGvCWNnkR8+2190eZM6hs=;
	b=gYW+CQmSa708lhsMIf++QQ6ZmG1ZTQmtM1AEj6wNFXl6CYudQabTv9ontN/lYf8r3AI2uy
	roGQHopmuxGmCJu/loqeVi2gAtJRnOH1RH0I4CggRkhEo1NG3LLCnL1TQgmRs/D4WNeiFk
	y/QqAU52bx2BRFrlX3MMNskEfA7s8Jg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 812D743CB4;
	Thu, 11 Dec 2025 08:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193FAC116B1;
	Thu, 11 Dec 2025 08:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765442876;
	bh=j9P0IoM2VBePZSGPEbquteAAJ7kda9NDqMa0x5DcGEA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=bJ0iyKYn09dnRksKbPpgQmWootITzm8qVZhTdWApSd9uvdsPxcVhV7mIhnSB0VyVw
	 CdEpBfzhw5XdXRzCX9L82VIBXUczNVsYnFc+ucOJzF19XzZO4VMQX1ADrokC2/oDkG
	 9ggl9wYfnF3lz9Wq/njMYTLjJ/x3PDVZXo/1+OL3UU1Y15RmT4rH6q2uX5k5y1gEq4
	 bXiHzR1v1YiwnkitVB0pZDC4IYcpMPOr3pD98vZCRK2y4L5RtPmrkNnkeRFxC6vyBl
	 w1uq9/KBI2S5tSZuzi3PpZkt3/5F8hLa3tInVhJ2Nr+1Cz/Q0Z9YXPlNYbezWTsly6
	 4Jlt9kQkWrogQ==
Date: Thu, 11 Dec 2025 01:47:42 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
    Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
    Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
    Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
    kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
    evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
    samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
    Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
    Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v25 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <20251205-v5_user_cfi_series-v25-6-1a07c0127361@rivosinc.com>
Message-ID: <b2acb9ca-1320-ab42-3937-2ea17153fac2@kernel.org>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com> <20251205-v5_user_cfi_series-v25-6-1a07c0127361@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: F32E1180012
X-Stat-Signature: fou7prhy8edddad41ysknenh6118aywz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765442877-784494
X-HE-Meta: U2FsdGVkX1+l51uw/MCdNTpjZXt091/UDuFO2CQS0M0aVZX+aHh5tisLDyH0N2Hs8p/c6rsB+CbDEbpfKkrn19vOE504Kwg5j7Pnf0CK+AN+afeNkkz51aKInt8+cfRHRpKHe2M5R67tBl00zad9c1bhCp9GQJeI03V8VzCDyLkrzmha3XwPNZUbWZtx2jrTPOcIUeVcgxxMapbr6rOqF9U2Y4DnK5o9WG4S4wJ8jfu8mjpUKkAmE22WwexeioOvaki0AH5iBA6LgnCfry63gPgCfufOqTdJisdW/cmCYgE7SdUFC3f08jD5pl7l15PLxPvVkkPN7ygpo7Gv2xVlaMjWXgxf6c6s7Fu8iuXXcXDtBcDc4FPGch7jamNLRTAWcR0PLnHmWrLdAohQRWy16ALPTG8Nz4UBtuCJ4IgqaAOdkfxxhd/TkwCtmJDNzfiUakxRL5YFzFvuEVQiwxyaMkIBwrEH4oYtLt9lYz53PfifphWzhcNqS3QL6hzuu8B5zLxqaW6lyVuH+jWZ8GCEbIAXhH43AuJ1VniOia4UOlU7jP/Tt/SwOy/oebPtxWnztrlnVCKW3CP3SXVA7OX43VNBAQK16miv0H7IaKnqnNTj6eGthbjlXjQUo63ftMaeeLqo/plwZTFlwdQ6HZv5D+YcJarC/dttSszowrPMS3cbUCl/eTy8Fgv3AA9FnSTHxuY/p5eOfIRzw0ghqP6yiaAPP4aEDJjAXwKUhD0DV7IWPTVxe+TL8VOpcLzkVDwd1/gfVvZYOvvzuic7EvaHZn+2SH11UNyK1Qof6l5lc5uG2NphLcZIlOa/mY4bv6NRJCSstvMqM+3tS7Ci+ZZDQoVSHBqawLY8YDABQSR5gJHWeXS33tMO4SkyYJpZNrIkkCEFqepVuvQXMRkmMYMWc8OWKV7OG4eHnycntL3hOtJzjYOVfb20bzPQreQBscQBOwIsk7zBKOshcUl6C5C
 KMOX5HAk
 tGZFcgEeHXonL4VprcKoUhPUGx18ptV7oTDJG+zqXUnzcTBgZoBvaFKbceNrsgca4WPByEVkp8A5TapQpaieCeNnNcu39ojYs+a9Ih/qwZNu+kcWW+Qu756hQ3NhehYP0cllL5hr3KgMGtJ8dSGBNU8hScZs44qb5+MoU18B3cAzO4BxoA9HSSQ0QO6pDjNRZq503Gj8GdZqt7cXqNuJ1usBAO4ur4Z2ssstIqkC7wxgd0liV000ZoudQtROHMR9ueVLSaIo7au38Ku6hdIS/wj8epEN06k0qQFR/cb5J+pnfXhDrS3i1pgpL5VFjNevqHIzW7N0E+6mwhyCJ+BWOsEmXj1Iuspqv5/O9Pl/RipXKHSIKjWv2idne+SsKRLeXyuAeGCsS78lYaNWNF+Gq0ds2aCcz0vyFxq2Ni0fcNjrHHP+89M/ZXgfpPQLZpfgR83usyEQF7SCzNGIb0dKBWapnaDSUuKXDhtxn5LHr6st5gBReFHAm5h4Gg1EsPlLbRrW+WfPhsvmhHpzhEZwh45DRwxsVeixIlku5Vj905UqcftEDRgkCPvZ1AJPLmhsDtA0d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
> 
> `arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
> VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
> updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
> This is to make sure that any existing apps using PROT_WRITE still work.
> 
> Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
> Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
> encodings for shadow stack. Above changes ensure that existing apps
> continue to work because underneath kernel will be picking
> `protection_map[VM_WRITE|VM_READ]` PTE encodings.
> 
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This Signed-off-by: doesn't look right.  It doesn't look like Arnd 
developed this patch, and it doesn't appear that he replied with a 
Signed-off-by: to the list regarding a patch that you wrote.  Did I miss 
it?  Did you mean Co-developed-by: or some other tag?

> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/include/asm/mman.h    | 26 ++++++++++++++++++++++++++
>  arch/riscv/include/asm/pgtable.h |  1 +
>  arch/riscv/kernel/sys_riscv.c    | 10 ++++++++++
>  arch/riscv/mm/init.c             |  2 +-
>  4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/mman.h b/arch/riscv/include/asm/mman.h
> new file mode 100644
> index 000000000000..0ad1d19832eb
> --- /dev/null
> +++ b/arch/riscv/include/asm/mman.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_MMAN_H__
> +#define __ASM_MMAN_H__
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +#include <linux/mm.h>
> +#include <uapi/asm/mman.h>
> +
> +static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
> +						   unsigned long pkey __always_unused)
> +{
> +	unsigned long ret = 0;
> +
> +	/*
> +	 * If PROT_WRITE was specified, force it to VM_READ | VM_WRITE.
> +	 * Only VM_WRITE means shadow stack.
> +	 */
> +	if (prot & PROT_WRITE)
> +		ret = (VM_READ | VM_WRITE);
> +	return ret;
> +}
> +
> +#define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
> +
> +#endif /* ! __ASM_MMAN_H__ */
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 29e994a9afb6..4c4057a2550e 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -182,6 +182,7 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
>  #define PAGE_READ_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ | _PAGE_EXEC)
>  #define PAGE_WRITE_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ |	\
>  					 _PAGE_EXEC | _PAGE_WRITE)
> +#define PAGE_SHADOWSTACK       __pgprot(_PAGE_BASE | _PAGE_WRITE)
>  
>  #define PAGE_COPY		PAGE_READ
>  #define PAGE_COPY_EXEC		PAGE_READ_EXEC
> diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
> index 795b2e815ac9..22fc9b3268be 100644
> --- a/arch/riscv/kernel/sys_riscv.c
> +++ b/arch/riscv/kernel/sys_riscv.c
> @@ -7,6 +7,7 @@
>  
>  #include <linux/syscalls.h>
>  #include <asm/cacheflush.h>
> +#include <asm-generic/mman-common.h>
>  
>  static long riscv_sys_mmap(unsigned long addr, unsigned long len,
>  			   unsigned long prot, unsigned long flags,
> @@ -16,6 +17,15 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
>  	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
>  		return -EINVAL;
>  
> +	/*
> +	 * If PROT_WRITE is specified then extend that to PROT_READ
> +	 * protection_map[VM_WRITE] is now going to select shadow stack encodings.
> +	 * So specifying PROT_WRITE actually should select protection_map [VM_WRITE | VM_READ]
> +	 * If user wants to create shadow stack then they should use `map_shadow_stack` syscall.
> +	 */
> +	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
> +		prot |= PROT_READ;
> +
>  	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
>  			       offset >> (PAGE_SHIFT - page_shift_offset));
>  }
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index d85efe74a4b6..62ab2c7de7c8 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -376,7 +376,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
>  static const pgprot_t protection_map[16] = {
>  	[VM_NONE]					= PAGE_NONE,
>  	[VM_READ]					= PAGE_READ,
> -	[VM_WRITE]					= PAGE_COPY,
> +	[VM_WRITE]					= PAGE_SHADOWSTACK,
>  	[VM_WRITE | VM_READ]				= PAGE_COPY,
>  	[VM_EXEC]					= PAGE_EXEC,
>  	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,
> 
> -- 
> 2.43.0
> 
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
> 

