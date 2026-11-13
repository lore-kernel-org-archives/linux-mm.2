Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D570F606A8AA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDjzVVrU
Received: by kanga.kvack.org (Postfix)
	id C76AE6B00EF; Fri, 13 Nov 2026 09:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9C56B05B2; Fri, 13 Nov 2026 09:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC06B6B05B3; Fri, 13 Nov 2026 09:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856796B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:36:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01788C0162
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:36:19 +0000 (UTC)
X-FDA: 85430346120.03.E556C24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48BD080007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:36:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDjzVVrU;
	spf=pass (imf02.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794580578;
	b=kGMNB0FnKv52TmmZIIjtpdkCaGJbLbIRePSpaswLjyfOlUBpQIBMZsuqqYolNhQzNP9Ono
	qntXK3soBdNPQidufib7N0GxpGRwrjEQS3i/zjAgwzRntoBzj88nyNhox7cLYv4ybhHUJI
	FE1AYG/j5a3U9OTlqiL6boIyxZOkeHI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDjzVVrU;
	spf=pass (imf02.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794580578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w49hyKAjJNYQc0T0xEVaI68+0oF+m2dcDRcRYzEk8rs=;
	b=jjvH8gzgigSnZBM2mSJ+dho83QiSXxDywUh5pvpGFah5xZHzytQBh8JGV6uVXEwP+qDilk
	uN1PEMkRZ6MjvUdU4iTNV7FTUEfW7Yv5jo7BTYzL0u1I3h9BZtjqVdrmv1nspHhjAN/425
	41+2KWFBYW/S7pTQj4uXyqQseuvHJOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47A0540039;
	Fri, 13 Nov 2026 14:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B8A1F000C4;
	Fri, 13 Nov 2026 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794580577;
	bh=w49hyKAjJNYQc0T0xEVaI68+0oF+m2dcDRcRYzEk8rs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jDjzVVrUjcqqvOcF2zRf/R4D2SkobqauH5sB4E4FWc03X74m4jxFCQSio9YHHHuuR
	 9Ml4Tlrckfk60OSmZz+hec4p2l9kmjLvQBMrX/YWsRQQvgUFJp0NHQZIrCyw0Gwiek
	 QZbpgzhogd+cwsY3Nd25gGqUKt3Baw/aKdlCaoUNBkxmn6Z5pyPj2weF8qqKc3/A8M
	 /Hvf3OTZxfDyyZ1sLXoNdqhyld8LAWFVmEcfNS1X7e6OGeS63NUqhOrnPQq/ZF6Igj
	 DMtYYds7K9Hh4P0SFcSWYXYIJSddoBhMr/8mdEZ/t7+gx48plf7GD6vYahVdtRVM4l
	 DMbaEQTybkmNw==
Message-ID: <3f7af771-87a7-4ae7-9919-bc4c23bd31c9@kernel.org>
Date: Fri, 13 Nov 2026 15:36:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v8 11/16] powerpc: extend execmem_params for
 kprobes allocations
To: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>,
 Donald Dutile <ddutile@redhat.com>, Eric Chanudet <echanude@redhat.com>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>, Liviu Dudau
 <liviu@dudau.co.uk>, Luis Chamberlain <mcgrof@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Nadav Amit <nadav.amit@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Peter Zijlstra <peterz@infradead.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Russell King <linux@armlinux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
 Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 bpf@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
References: <20240505160628.2323363-1-rppt@kernel.org>
 <20240505160628.2323363-12-rppt@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20240505160628.2323363-12-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48BD080007
X-Stat-Signature: i4knyum4nhpk94fjgtruq1j533yppwx9
X-Rspam-User: 
X-HE-Tag: 1794580578-6472
X-HE-Meta: U2FsdGVkX1+F6kEfw6VNodGebxCikQG+Uh1Q/6ztJNRpx6pESOdyW65+zCbVqTGI/QVU8Q2SxA5isgx4lt+OjPyk7P2tsob6Xc5MaLJF+C6IyQYsKtXHplBbFpCmBdvufgLqMBGQnpgx/IBBReaBAm4mqYy+fTKS/zMyb/0ifpG74h0XsHJT08CHc7v3SrV3XRZLQZvX2pbvOJ+xm9sNifhlcEZ8i7/6a2siKBroW5RyyfvpWY04Sm3K5oeBovSO0diNdl1wyqYkosiHL7CSOdNwYqrTiAMzSkRARgxfN4JCms9Cgf8Ed3it22QcI1AESENrYKsu6DxbUPdd2/SP7R9tFyN6s6sfc4+ZLaUN9s9cYLbkiICr4YK7WwT4/BgzdoZ7pxd10aqK23L+9QpkBHfa88bAHre/cxGwr24BzBYyvHJYo2sjin8m3l2wQ6pVMeE6d6MjZls4ReT60QXyxqCN5uVaKB2l2da4YAFhQyvIQtjWUJxJUOutHW8EXQpQg3GOh/Xbw0vort60Stk0gO1HYW+Xl1nqnpojeFrezNJLRpXnisIWvnhKK7Ggtq0E05xN6CXT+rpNKhCqmcEI0Vf2N5JwtPbz9BxtGF4iZOeX3v0MQprcyRp6sUxaAF3kW6Sdi0rLAfsFSo/wxb7+c79HT7LZ2t0ADGt6iVhWZGR5c8FyLIe15Fny1J+ddBVqbzSPi3QX5yp8kZNKXT26wFMMR1M7ujdfmjvJ8TPYEtE6DmO3TwqEMsNl7oz+9DrHAo9T6kxRBZzmu/4060uoLAm2qwMoL0Won8qT7il/v6iSD06/hjrOQ0KNAz2gEdstuva4NPz7hSXTxjSlo7n2vn0iE3aAQpe3uY2KGVatQRMP2RCD1xj1RcOk8ZT0lXyOTT2blYQ/uggVJdWEtJYrtyOOZGIYyWP3V9y4k9/wsygGMZutKXyg0BkAfG+AP3jok9kfwbQBCSTOJIs0FSx
 YHlnzAQ6
 bRdyzgiOjswaYM/E0EYlJY8DcWfRLY8nZaAdXY1DqtfLQoOmpf4741lVTZbmOrZg95DK+vwI8hddt6jtBiKokMpCWZsOd02247Ld5plcmoWToU5CgOiANfp+GMXpJ41GLf9shjvSvb7Llw3yZ/104zTQ/5i4/fcurALdTG0wMX7Kj+YnKKe3H6QNEy16PenJEdnNPw5xDvvM5VwsgupUE/IgGHy7Zi2pRm7CT/+udSDOTrxPyhAtTJwcRuOukE8ObLSNkJ8nJVOKy9jZSsTgZeOVtlUgJrKB+WLC4+HtNxoPgE+gNLtibMADcv8Jl0N6Nsn+dVX9tFqDYAarmQkLnRZbt6HPHJAoO400fRqMy2P1lg6zmDLdajoHjbyk5tKu+We1SSI6kI2RXb96tKDqPzX+XAooXiXWDHWhwafnRrEv/LPIVuVo9cmiNOMtL90jDmvM3s+m2OdSCArg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

Looks like I missed this change ...

Le 05/05/2024 à 18:06, Mike Rapoport a écrit :
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> 
> powerpc overrides kprobes::alloc_insn_page() to remove writable
> permissions when STRICT_MODULE_RWX is on.
> 
> Add definition of EXECMEM_KRPOBES to execmem_params to allow using the
> generic kprobes::alloc_insn_page() with the desired permissions.
> 
> As powerpc uses breakpoint instructions to inject kprobes, it does not
> need to constrain kprobe allocations to the modules area and can use the
> entire vmalloc address space.

Using breakpoint means the segment must still be executable.
On book3s/32 VMALLOC segment is not executable, while module segment is.

See commit 6ca055322da8 ("powerpc/32s: Use dedicated segment for modules 
with STRICT_KERNEL_RWX")

See report and fix at 
https://lore.kernel.org/all/ed03d290d440d579a81ae0b7de5243721291d903.1794543909.git.ritesh.list@gmail.com/

Christophe



> 
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> ---
>   arch/powerpc/kernel/kprobes.c | 20 --------------------
>   arch/powerpc/kernel/module.c  |  7 +++++++
>   2 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 9fcd01bb2ce6..14c5ddec3056 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -126,26 +126,6 @@ kprobe_opcode_t *arch_adjust_kprobe_addr(unsigned long addr, unsigned long offse
>   	return (kprobe_opcode_t *)(addr + offset);
>   }
>   
> -void *alloc_insn_page(void)
> -{
> -	void *page;
> -
> -	page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
> -	if (!page)
> -		return NULL;
> -
> -	if (strict_module_rwx_enabled()) {
> -		int err = set_memory_rox((unsigned long)page, 1);
> -
> -		if (err)
> -			goto error;
> -	}
> -	return page;
> -error:
> -	execmem_free(page);
> -	return NULL;
> -}
> -
>   int arch_prepare_kprobe(struct kprobe *p)
>   {
>   	int ret = 0;
> diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
> index ac80559015a3..2a23cf7e141b 100644
> --- a/arch/powerpc/kernel/module.c
> +++ b/arch/powerpc/kernel/module.c
> @@ -94,6 +94,7 @@ static struct execmem_info execmem_info __ro_after_init;
>   
>   struct execmem_info __init *execmem_arch_setup(void)
>   {
> +	pgprot_t kprobes_prot = strict_module_rwx_enabled() ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
>   	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
>   	unsigned long fallback_start = 0, fallback_end = 0;
>   	unsigned long start, end;
> @@ -132,6 +133,12 @@ struct execmem_info __init *execmem_arch_setup(void)
>   				.fallback_start	= fallback_start,
>   				.fallback_end	= fallback_end,
>   			},
> +			[EXECMEM_KPROBES] = {
> +				.start	= VMALLOC_START,
> +				.end	= VMALLOC_END,
> +				.pgprot	= kprobes_prot,
> +				.alignment = 1,
> +			},
>   			[EXECMEM_MODULE_DATA] = {
>   				.start	= VMALLOC_START,
>   				.end	= VMALLOC_END,


