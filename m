Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0410E8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DCF6B0089; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDBC6B0093; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905EB6B008A; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9A36B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 161B91A065C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:06 +0000 (UTC)
X-FDA: 84404929812.11.CD49318
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBC541C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=GNRLYIoY;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRxhu1y96n3UH4hdO/qWkE190Cf2AF4FqJrGWR7q6xQ=;
	b=O2I5aXyt2vRB3PC96r5hH4YM4rGOG9AGd6MnfyHQtj4tWiPgwExtFDaOJfxbMTWAL95LM3
	uX2W1OV/cyyO+f4NxXQJRnuV1E8nd38pFd624Jmyi2j1IVbuplmza/xMh2BDrBetTcr0Kg
	cp+gbFmWMwlzuedo7zEuuyg6SLtkXG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165904; a=rsa-sha256;
	cv=none;
	b=1+zMkdEbt/N7qpIS2W1c1wbURPzXAQjFbNwub1/HIqMp3iHMJkPMKCsVx+anKZ4tDXXGSV
	OUWkY/8DN70HIdmJqoUV2ygOE2q5J7wyuH+PV08/aT5Yx0xovkZ1PDSbTd6axSSaqIM27v
	M/GxOlqyQ+cSpX5aKvtG9KvU9vwv+mc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=GNRLYIoY;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140hAvI3684475
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:44:13 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140hAvI3684475
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770165855;
	bh=GRxhu1y96n3UH4hdO/qWkE190Cf2AF4FqJrGWR7q6xQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GNRLYIoY9SpQilkizC8FaQUne5RT0+llizCOZTFclKFfPdeiVruz/e/sLFutiAuSm
	 CbhmY4DWqyb2eVket35KKUR0JRXTX1QzXDZuc0L3iXQqLPpn8aXP1yP57jHp6rzR8B
	 AruzaMp+6X5KvlBPyEZ6cYq9hU1oS//kFwKBgRzAQ5yvh0k0BZcTWT/cxpHnYJujRW
	 IzxdYqSozkZr5Iu+H0ua7HgepLndfOUZzhCtQUihOTtcMA3sLUr+W7pA3g4mPb1/Sc
	 32YOh37hNKxEOV4mEzkkd3UIkk3/gBO+RtGjItROA+lrtAId271Qld6A+9vrixxWYl
	 U4jLPEQt9xhQQ==
Message-ID: <b8d73b0e-c007-4556-960a-96ee3d74a9f5@zytor.com>
Date: Tue, 3 Feb 2026 16:44:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] x86/asm: Simplify VDSO DWARF generation
To: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
 <20260203171958.1522030-4-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-4-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DBC541C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p619x9ngp6trmyqquergs38dedfa7rap
X-HE-Tag: 1770165903-603063
X-HE-Meta: U2FsdGVkX18VW1MjOvboOIooXeEWhYki/D6VPpml4+BeWvkY1lPrf1y7teZwk1R1j6Hs8DozUwD3lOwXHudmnqBI937C8aZrMHTM7nmfniRulpbSxRRHsFwnbJMNImGWAtPEkotuQuUFdTX5h0U2DVg7F3DFjvr7CtaPllHbogbHvffgBdOiT7K3BPpVK2HF4kI17VYrTQ1RBz4Nd7daIp2q6QZIoUJXR9Xdf1ZikBHpYiI2g9/9C5pSw3R2Q5MOygZEOnXibbgVVW0x6tOxNCf1vdJpJEc57RtffvDMa6dqbhCpUuyZWvCsBGw7/yAH8/9j7GCmLHpa0Rr5gUaOibQMpsP1ba+51aZYQl+Id73mAMqCJjRaqu2OWdN/ypiq46xWm6IVgCml1b/V4YYHBJUInX9JdFyUZ0MCm1q17KN2x7HWFEZW/D38ed5k++VaWY6qYvQiQVHsOZFDtYC17gtxKuSUc/LuzRsWf5VjUMV6bdGeeku2ifZkwnw/09fK8M+NZDZcqyP194gvXATSt4paYJSGkvjL5OYZN8XOsrw2hw1hEKiMScr2/yRyzolxQgR83U+qdFtwoxl7igwwOFI7wBNoHTo0MAKiV0tePdPmjilR2wFB4251c72ttrXdt79F8OHfl+7Oe1w4jfq2E92ScFgKuXom04qSWO0IPTM1OHSa30SEiQ5tiHqabkpWkXxTwkUfhkOVOXZCIG/PXSWpAcrcLss4iM457pT0g2NZFLsJu2xpk3Xzkuz+QCXPqyndXGhnjmey3XxkyOwDPEToN4cfZHIPPvppUh/hqarA/lY92mXe/I+uRI6EVblFbGBOBtMO/brxEDI6NadKCYyiUu62v0d2m5H2cc8k4cRVjv6KNkdhkyX6/Mh2qRvyA4IkI2DW1jQtgAJHlcKtAa2QH1foU+YSKy1zjR52ZHiPdqf8TujAg9lgUYBMTJHeiKjAG9A1VviDKlQO4E0
 rhVPWokY
 7TO1hv2mS0qNITF/8UP3C/XlfBTEqUmOWMlS1723X1/3k1du04OwL/EW6bac92b+XMUEbUwdAKhfpoM1SCDP0Cge+HN+bY2CfEXlk4JddhMLqlD6uGpddUrhyBL2LzZ7phGTwsjJLqZ6QiFy/AtcPYs95SVlfEEfXt9w4s5fvThGmaZnPRmxaZMQjr2j8xpBofz5gVNI4oCgEmTU5KKfeEcfMnhnh0wh1Ue9col1lS/6ihPzlhmoF/mwos7XbKoAWwpNLCYCYUEmaW39jnubg1VuMl6i06xPeb6F16iTFv6Zj6j2xfGwn4d5mo95dQe5/NxDcnJrH5ZnPGTdHedKk0ChtOw45sHSXMPnbe6nKgZcI2AYKBFgzD0oHQ4z+IFJK21MHQk7nxMielpOw4mz7BGtPtAswt1JGADRD/gl3sslBsqnxjsKoHQOmdbLhBiLttbMK0MU6TJcumYO1KD8Jo9Le2iCf+tZ0qyjHf7Ia9nd2MeS9yuGywpP0F8dobq1p43ZUwBFBHXLTtYYcXqqZ5ZX+Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-03 09:19, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Add CFI_STARTPROC and CFI_ENDPROC annotations to the SYM_FUNC_* macros
> so the VDSO asm functions don't need to add them manually.  Note this
> only affects VDSO, the CFI_* macros are empty for the kernel proper.
> 
> [ Jens Remus: Reword commit subject and message as suggested by Josh. ]
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
>  arch/x86/entry/vdso/common/vdso-layout.lds.S  |  2 +-
>  .../x86/entry/vdso/vdso64/vgetrandom-chacha.S |  2 --
>  arch/x86/entry/vdso/vdso64/vsgx.S             |  4 ---
>  arch/x86/include/asm/linkage.h                | 33 +++++++++++++++----
>  arch/x86/include/asm/vdso.h                   |  1 -
>  5 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> index a1e30be3e83d..856b8b9d278c 100644
> --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -#include <asm/vdso.h>
> +#include <asm/page_types.h>
>  #include <asm/vdso/vsyscall.h>
>  #include <vdso/datapage.h>
>  
> diff --git a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> index cc82da9216fb..a33212594731 100644
> --- a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> +++ b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> @@ -22,7 +22,6 @@ CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
>   *	rcx: number of 64-byte blocks to write to output
>   */
>  SYM_FUNC_START(__arch_chacha20_blocks_nostack)
> -	CFI_STARTPROC
>  .set	output,		%rdi
>  .set	key,		%rsi
>  .set	counter,	%rdx
> @@ -175,5 +174,4 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>  	pxor		temp,temp
>  
>  	ret
> -	CFI_ENDPROC
>  SYM_FUNC_END(__arch_chacha20_blocks_nostack)
> diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
> index 37a3d4c02366..c0342238c976 100644
> --- a/arch/x86/entry/vdso/vdso64/vsgx.S
> +++ b/arch/x86/entry/vdso/vdso64/vsgx.S
> @@ -24,8 +24,6 @@
>  .section .text, "ax"
>  
>  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> -	/* Prolog */
> -	.cfi_startproc
>  	push	%rbp
>  	.cfi_adjust_cfa_offset	8
>  	.cfi_rel_offset		%rbp, 0
> @@ -143,8 +141,6 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	jle	.Lout
>  	jmp	.Lenter_enclave
>  
> -	.cfi_endproc
> -
>  _ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
>  
>  SYM_FUNC_END(__vdso_sgx_enter_enclave)
> diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
> index 9d38ae744a2e..9d7f90c57451 100644
> --- a/arch/x86/include/asm/linkage.h
> +++ b/arch/x86/include/asm/linkage.h
> @@ -40,6 +40,10 @@
>  
>  #ifdef __ASSEMBLER__
>  
> +#ifndef LINKER_SCRIPT
> +#include <asm/dwarf2.h>
> +#endif
> +
>  #if defined(CONFIG_MITIGATION_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
>  #define RET	jmp __x86_return_thunk
>  #else /* CONFIG_MITIGATION_RETPOLINE */
> @@ -112,34 +116,51 @@
>  # define SYM_FUNC_ALIAS_MEMFUNC	SYM_FUNC_ALIAS
>  #endif
>  
> +#define __SYM_FUNC_START				\
> +	CFI_STARTPROC ASM_NL
> +
> +#define __SYM_FUNC_END					\
> +	CFI_ENDPROC ASM_NL
> +
>  /* SYM_TYPED_FUNC_START -- use for indirectly called globals, w/ CFI type */
>  #define SYM_TYPED_FUNC_START(name)				\
>  	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)	\
> +	__SYM_FUNC_START					\
>  	ENDBR
>  
>  /* SYM_FUNC_START -- use for global functions */
>  #define SYM_FUNC_START(name)				\
> -	SYM_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)
> +	SYM_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)	\
> +	__SYM_FUNC_START
>  
>  /* SYM_FUNC_START_NOALIGN -- use for global functions, w/o alignment */
>  #define SYM_FUNC_START_NOALIGN(name)			\
> -	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)
> +	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)	\
> +	__SYM_FUNC_START
>  
>  /* SYM_FUNC_START_LOCAL -- use for local functions */
>  #define SYM_FUNC_START_LOCAL(name)			\
> -	SYM_START(name, SYM_L_LOCAL, SYM_F_ALIGN)
> +	SYM_START(name, SYM_L_LOCAL, SYM_F_ALIGN)	\
> +	__SYM_FUNC_START
>  
>  /* SYM_FUNC_START_LOCAL_NOALIGN -- use for local functions, w/o alignment */
>  #define SYM_FUNC_START_LOCAL_NOALIGN(name)		\
> -	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)
> +	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)	\
> +	__SYM_FUNC_START
>  
>  /* SYM_FUNC_START_WEAK -- use for weak functions */
>  #define SYM_FUNC_START_WEAK(name)			\
> -	SYM_START(name, SYM_L_WEAK, SYM_F_ALIGN)
> +	SYM_START(name, SYM_L_WEAK, SYM_F_ALIGN)	\
> +	__SYM_FUNC_START
>  
>  /* SYM_FUNC_START_WEAK_NOALIGN -- use for weak functions, w/o alignment */
>  #define SYM_FUNC_START_WEAK_NOALIGN(name)		\
> -	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)
> +	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
> +	__SYM_FUNC_START
> +
> +#define SYM_FUNC_END(name)				\
> +	__SYM_FUNC_END					\
> +	SYM_END(name, SYM_T_FUNC)
>  
>  /*
>   * Expose 'sym' to the startup code in arch/x86/boot/startup/, by emitting an
> diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
> index e8afbe9faa5b..498ac423741c 100644
> --- a/arch/x86/include/asm/vdso.h
> +++ b/arch/x86/include/asm/vdso.h
> @@ -2,7 +2,6 @@
>  #ifndef _ASM_X86_VDSO_H
>  #define _ASM_X86_VDSO_H
>  
> -#include <asm/page_types.h>
>  #include <linux/linkage.h>
>  #include <linux/init.h>
>  

Makes sense to me.

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>


