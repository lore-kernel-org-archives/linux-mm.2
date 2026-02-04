Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF04E8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85466B0098; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F866B0099; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE676B009B; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAB656B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AD5359E26
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:27 +0000 (UTC)
X-FDA: 84404930694.18.7306248
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id 627F5C000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=ZibLcVuL;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165925; a=rsa-sha256;
	cv=none;
	b=ooIxmNvPmveC4OUDn4qwbtdr2uT4cACVujBtDD2PwTqAKpjgGpPqLBuTBaeV+O4m7JK+TG
	MrZdtgiAVvGTbOU7cpQ8Ugj/C1+bR7KDXQg/nOJIOMtANpGmgOCx3I0eT07BlnwLOizoWk
	B3/euNXYJPuC1Sr9IfEVlj6Nvk03bIM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=ZibLcVuL;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBm6ZcPisQkneG596+7CCtRNo4FR94Kwhkfm4afnAkE=;
	b=XqknM01NXznxMlquV4V8TqmLJUFnBIc6taW4xzgUmIF/hTiLZjiTYEx33+8e3FfUsDhegi
	NK6Zxzw1zrgQWUxShGc7tnD/sheIpk5HK4H4XEA7xpVjqchBOsztJrVRu969BN1FlvGvTn
	FRirNNzpuyma4vzy3+thPFNvzljDK7M=
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140iX303686652
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:44:57 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140iX303686652
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770165899;
	bh=QBm6ZcPisQkneG596+7CCtRNo4FR94Kwhkfm4afnAkE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZibLcVuLSIucGujyPOk0lr2GRGfUUCwgewWStAdXcf/4eRKgVHDfKOXWNg2lO5PRE
	 dLm7rAOfvt39WHhl2/igmMZiEMY3s9iDuDW3bqCuqMyFmk5KQRtQc8yHI24ggAN8BV
	 fLPIxXQMMaQsNFwEpHD7xnQBJgBepF2c5pqKRyIpJUDckn/K6QTq1Zaj/1xSk0QH1O
	 +O70azzWqPCTO/qEpBfMH18/eZUmOOAn5apaFAQw/mMtr683Ky5jXLKITWvhet4IQk
	 AxPzqM1kLIJxy/Bw5w89KatVX4Squ1ATMkFKGnR0NQIgkCFVVWjlzjEgsnvgGaunDY
	 NmVBuCBx8kDnw==
Message-ID: <7030a829-12aa-45dd-b78d-86cf72fb9a2d@zytor.com>
Date: Tue, 3 Feb 2026 16:44:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] x86/vdso: Use CFI macros in
 __vdso_sgx_enter_enclave()
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
 <20260203171958.1522030-6-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-6-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 627F5C000D
X-Stat-Signature: fyz5zmpokubtad6o7ea7yma7fzru6k3d
X-HE-Tag: 1770165925-726918
X-HE-Meta: U2FsdGVkX18AvRyTquh6mgp6iXY+zp4wb41c+t47SZwg/OtHxX5r8EI889VjZeZlBAU4sl5OmtBybVrdIF4ILNnmpVQQVPy+iVQhcEsStrXtAv1UmjWM00Z5rAcLRmval4uvIVa13C/clHOwa4GaEBkTjeO2df3XzYjk91hvSWftMXK4KV/rndB1N9EVViFgzVom/uVjapXPWzENfQbjnCt3GT0kgpibyEMz3OF9G0+8QYfSa5W3aLmjFVwfWFxzthaRNm4OvECtCWJup+SD4nqMTMv8p3coyKIgtT4HqeSDreNREDCfv3eTxKrWr/OsDUoYpsuUV67vIxNdM8wmjZ1252sztVXF4vye75rNUnGN0noRHyaz7pCmU2hKNXA546u4VQZdt+VHE7UteLRafZj8FnIgOZ3llM95Lvw/AMrTJI69YG/CCwFCvnp2KD+CI5e5SFeN29eaobH5oiN7t2a3FPsK7FCpgpMdGWDKvdeP2EGEKfuIxomqvwXgXKNqdpyHJc5DjIUzrJ1FhsXbPw+BdB/DS889KU/X4yJU6h0VzE/0s5I1IbWX9xazH8G3cmLWviQz7cM2Wqoyx4K3vi3ib9txS0YDuYF0Cn4RSKWjL6E4Kd9UT97P8v1NwuiDBQCQnoS/88MID+WAEIizTIosZJLzPhgri/PaXyF2+EMb6b+wCrkqbKziySCDBb/nfwUb9QZaRlpW2HHKLJyM92eK5WboBbAXwIgbQgBXS+muqP8tnvMgmjI1c3Df8xix6l3L8Bc1LXrKlJyrHpQEEBKW64YSh20+6HbtHKHu0OzAPyAufcvK8qjwiX0tfy/TjFQqkteqM9l0hldUhlGbSP2A2v6C+IF+7aRgZmqpbrESmi1ELxSVkAVbFpFC5+xFvnSN/I2aRZnULrNqI+bZEYnzu/4mcfI36BTt1rOuj6h5+Bv+yH86nEymRQiJiPQ3uT3cwwanikQtnkEGFkR
 vYpY08nn
 rdCtXcj+HboJQ+mPv7NM++Q3ezdFcJtQfoajtSqDxEKsRqJWJEbdYKi8CXcpejva6uGP5zuG8StQgMxpAVaWYeqzWo0jP9TtexY+sCsU1QHvW/pecNVG8TEQzRSamoaP8Cy/Ahw+BdkkyXcv0DJ7vXFvCMohG+WkdNzPaEoiFmDHSnQbTlXEErDjeM39lWHbzl7jhJmrcgq+cO3udbpK/7omXTZE26l13b7FeIEGqILbxJDNPaUr83CnDXpw8PqcLmK6L1th+4sy/XlwnaAxuLqZiYeNRQZWQ/DKe8Zkm0ue0ykPiMYiCWjHtp8v7k/LVzED32UKx36w17I9N69ADX5ubfMjAe3tK52RTHnL53Pt4WOFpK0igJMrjOVXe4+p2XvtrTqZM1THYtEYhhnJtiXsAlmDfT3DSB830jtF8k5bXkv8ce/6CL/hkiMhkhr1+G8CZPj4c7VnstdTPxbGDImPPAVxqRKaP0izvWovqN7YKoojamz6/trnTSxDOL0z8Sai+RAca0euluE0zKpO4FXpQT5ZhCa9LpjR3k3k6edFNtIwf0eEfbANKu2tjcrk8HCK2Cisp5/6KXxs=
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
> Use the CFI macros instead of the raw .cfi_* directives to be consistent
> with the rest of the VDSO asm.  It's also easier on the eyes.
> 
> No functional changes.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
>  arch/x86/entry/vdso/vdso64/vsgx.S | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
> index c0342238c976..8d7b8eb45c50 100644
> --- a/arch/x86/entry/vdso/vdso64/vsgx.S
> +++ b/arch/x86/entry/vdso/vdso64/vsgx.S
> @@ -24,13 +24,14 @@
>  .section .text, "ax"
>  
>  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> +	SYM_F_ALIGN
>  	push	%rbp
> -	.cfi_adjust_cfa_offset	8
> -	.cfi_rel_offset		%rbp, 0
> +	CFI_ADJUST_CFA_OFFSET	8
> +	CFI_REL_OFFSET		%rbp, 0
>  	mov	%rsp, %rbp
> -	.cfi_def_cfa_register	%rbp
> +	CFI_DEF_CFA_REGISTER	%rbp
>  	push	%rbx
> -	.cfi_rel_offset		%rbx, -8
> +	CFI_REL_OFFSET		%rbx, -8
>  
>  	mov	%ecx, %eax
>  .Lenter_enclave:
> @@ -77,13 +78,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  .Lout:
>  	pop	%rbx
>  	leave
> -	.cfi_def_cfa		%rsp, 8
> +	CFI_DEF_CFA		%rsp, 8
>  	RET
>  
> -	/* The out-of-line code runs with the pre-leave stack frame. */
> -	.cfi_def_cfa		%rbp, 16
> -
>  .Linvalid_input:
> +	CFI_DEF_CFA		%rbp, 16
>  	mov	$(-EINVAL), %eax
>  	jmp	.Lout
>  

Looks good to me.

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>


