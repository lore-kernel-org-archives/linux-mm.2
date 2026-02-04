Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C2DE8B387
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A050F6B0088; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2D56B0089; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A456B0092; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1A86B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14CDE1B23E6
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:06 +0000 (UTC)
X-FDA: 84404929812.12.D31791C
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB4471A0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=A667aHHn;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfjcLG/RUmRtt9wxHxBQ6mL+sKk+V7CX7MeisYlYpJc=;
	b=0BobNyGcLX+URtlgCnRnrEVRxGFMG5pr1vKJDFu2/uFaONhu9Pv1BlVZ8wcZqpvCyin3sb
	On44Ss+kfaG8CNo46ACxNrFhFrZ8kWCVWXNs9+NRTxzsPTKkv2d/nYaCba/3sZhTamikld
	iVq0kIWIBFPI3xphgJhnAWbY0md+9I4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=A667aHHn;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165904; a=rsa-sha256;
	cv=none;
	b=m3Al/IUxF7pvRG1QqUdhu2GEr5fNKxfUYPN51ptqEgeP5wFbSkflUCgllXPHCwa3hJOld6
	DmhRtW3+1WHClqoHQLY42qTNMg7tnEfbBLVA4uppfiCQooMOBYHRDAHJd+Mx6wYCdQAAEm
	05hm1vDKc7OfSiuuIOeRFHUTao9bbTE=
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140hAvH3684475
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:44:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140hAvH3684475
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770165853;
	bh=SfjcLG/RUmRtt9wxHxBQ6mL+sKk+V7CX7MeisYlYpJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A667aHHnZjPtA3vHvH0jpqhwqdKf4X6/35CpgUlJSQSe8LQuTsAR5kPmP4uY2ByIn
	 ifXxRqU5OoZ1IoPKwL2BVP5QUwz+R3SGHYL3uh11dVN2rYTroBzK1nnGRvaco9x3AV
	 PJkukzXaZTKyfW4NdDv8FFAy72MvB3KMvFwpcfVVbCZ4l72ccV320HTpY/RDFTQiHJ
	 0B5tAvHF0AYi85FhQDMbDhUuXXulb3MZHpeluT4WdNX/UDpsLb9qVSVz8Tvxd3EigZ
	 2CCyraJ5yWcTjnGmIAjRCwmsIoillqKATqXgWxaHjK8wsBFZ/B/ylwPhstUWBamK/p
	 FX9idc7SfXpvw==
Message-ID: <bd2fdf83-e460-46ad-8617-16319bc55ca5@zytor.com>
Date: Tue, 3 Feb 2026 16:43:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
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
 <20260203171958.1522030-3-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-3-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qam7ciw6xgrg81nqyc8jt7dddhyzjfjw
X-Rspam-User: 
X-Rspamd-Queue-Id: DB4471A0008
X-HE-Tag: 1770165903-281249
X-HE-Meta: U2FsdGVkX1+Tu4o7k/ISmg3pZi4oCPmbpTKzREjSdwGs1+j2eLP3vR5akYhU8faY6UWmxeY5MB31r9pX4lTPKRQH/KHvc8NxnNqEHT7P+Xz6rnzQ5fXKcBOeeOl9vH2I5xoDWHqRc0MnbTy3LOGn966UNVVETQ4cu0vS4DMPmslAPSrZuONP0aAIgeELCVSrNbU6+GLxL6qfW+O0xnK0EUt/i50UyEE7jKIsQgRxb0graGwqf38gA5uST3wtrb4dwwcTjpV/kR9ivSk+qkDiwTHY1lx24z8UlV6PU52sma0mh0v5WWxWY55uFRQsGcDxgpfSCNX5PQDVwCrcNJUlDaWuTWEa0ud1pMYrTxJPNLf7PLeY42cWePflZCKzV6cHQIeC72T5qpOX0751+aACDAeu+5HJM2jG8oreOk8HEzXpvPGspuKebjs5BHEz1KpshGRKbchcxgHPSLFprnJFucTf/rtUdOLfj2l/m1FmvvYMl9Q8PugjIo0Afd7nIi+Bzm+5Ri6dGo6sk1iie9aG3QN5p+RrFmwepgTaAa9bpYS7ncBPHLmdAURXLWZbaSFnlrjtG8/2sYBkL9OoFu3CtgDa08s6yNV1Jir0cRSYCBbJgLn/zL3CMCsKlj2WhxYY48pxW6QUXSPKQ+osGLqnM2E36gI8RNh4lxmknK4sG19kwfx7dVHBlQwgNSZ3OECZYXHA1b2XF6x9J/Sw2yh7Umf7L/TvMQtWYhIP4lNG67jYzejpv9LzviKkhQDrCy1x6ir3Gtmg0azN3GDLiG3FqV9whA2aoVIwgSJMom1yGTO1FiV8V1u8WoZ2oy051qlJ4+yiPLoU/ByurBGeJj20d64hlXeJS7Gbj8dxtyy0i/FFaaV3VreAHnJDraK1NsPCqxpGt3EAYV9z38r/3qqzzByTYCJen8BKUime12r1CZylEIeL9Aq3KvMhLophC0p9hwRHjSXU+hIF8mOWl75
 Ofo1Scjv
 D55kB6ComiZ1nKT6evRCXhTbRhePYcPDcEKeGyBo9Mctns5+PCs4kVSq+kbO3ovg6o4aC5mEC2gJoZM9/4ZaH6/GZ9wywE7g1rnnxStaOMZzHtRoag/TPd5ltQD6zoTrxQrXi859JScGyddeUrqtj5hdvEUg8R6QeBDhaGwic2xVdtVvpj66+elYX6sSM2LhV0wR9e2ylc3xLpQNcu9fvn6He7tzfPydCFPTDQ2x8ZpA/aoTFhSl0KZQo+8DEgzoM1H1zp2FTtO9bW0RJeAqUFPe7r99gvXhhS6/PX7OyhaEJ3+U8/yifdyAzxSXwl/QJlW5m+nmkiKIaio3izKgNc10UJeaGEnFnqWixK3KBz/JD5B63v/G1qJI71ajVACqDfqgU5mePdWg29AZ0g1ohMPrHGdc8aT/Isj4f7zQK0VEVbg8YqSV6ROkgLcl3ylD/sVgb/Wb6Oy4prj1MCWZ8rk9HwCmIZsNELM7QaGnKbFB5iNg58hclTxeW0QsorzcZCag8YCQ4rB3nS10Ezyk6yCFkBw==
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
> It was decided years ago that .cfi_* annotations aren't maintainable in
> the kernel.  They were replaced by objtool unwind hints.  For the kernel
> proper, ensure the CFI_* macros don't do anything.
> 
> On the other hand the VDSO library *does* use them, so user space can
> unwind through it.
> 
> Make sure these macros only work for VDSO.  They aren't actually being
> used outside of VDSO anyway, so there's no functional change.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
>  arch/x86/include/asm/dwarf2.h | 51 ++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
> index 09c9684d3ad6..7cc30500c095 100644
> --- a/arch/x86/include/asm/dwarf2.h
> +++ b/arch/x86/include/asm/dwarf2.h
> @@ -6,6 +6,15 @@
>  #warning "asm/dwarf2.h should be only included in pure assembly files"
>  #endif
>  
> +#ifdef BUILD_VDSO
> +
> +	/*
> +	 * For the vDSO, emit both runtime unwind information and debug
> +	 * symbols for the .dbg file.
> +	 */
> +
> +	.cfi_sections .eh_frame, .debug_frame
> +
>  #define CFI_STARTPROC		.cfi_startproc
>  #define CFI_ENDPROC		.cfi_endproc
>  #define CFI_DEF_CFA		.cfi_def_cfa
> @@ -22,21 +31,31 @@
>  #define CFI_ESCAPE		.cfi_escape
>  #define CFI_SIGNAL_FRAME	.cfi_signal_frame
>  
> -#ifndef BUILD_VDSO
> -	/*
> -	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
> -	 * The latter we currently just discard since we don't do DWARF
> -	 * unwinding at runtime.  So only the offline DWARF information is
> -	 * useful to anyone.  Note we should not use this directive if we
> -	 * ever decide to enable DWARF unwinding at runtime.
> -	 */
> -	.cfi_sections .debug_frame
> -#else
> -	 /*
> -	  * For the vDSO, emit both runtime unwind information and debug
> -	  * symbols for the .dbg file.
> -	  */
> -	.cfi_sections .eh_frame, .debug_frame
> -#endif
> +#else /* !BUILD_VDSO */
> +
> +/*
> + * On x86, these macros aren't used outside VDSO.  As well they shouldn't be:
> + * they're fragile and very difficult to maintain.
> + */
> +
> +.macro nocfi args:vararg
> +.endm
> +
> +#define CFI_STARTPROC		nocfi
> +#define CFI_ENDPROC		nocfi
> +#define CFI_DEF_CFA		nocfi
> +#define CFI_DEF_CFA_REGISTER	nocfi
> +#define CFI_DEF_CFA_OFFSET	nocfi
> +#define CFI_ADJUST_CFA_OFFSET	nocfi
> +#define CFI_OFFSET		nocfi
> +#define CFI_REL_OFFSET		nocfi
> +#define CFI_REGISTER		nocfi
> +#define CFI_RESTORE		nocfi
> +#define CFI_REMEMBER_STATE	nocfi
> +#define CFI_RESTORE_STATE	nocfi
> +#define CFI_UNDEFINED		nocfi
> +#define CFI_ESCAPE		nocfi
> +
> +#endif /* !BUILD_VDSO */
>  
>  #endif /* _ASM_X86_DWARF2_H */

I guess patch 3 justifies this.

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>


