Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E57AE8B388
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B170A6B008A; Tue,  3 Feb 2026 19:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8EE6B0092; Tue,  3 Feb 2026 19:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7BF6B0093; Tue,  3 Feb 2026 19:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 473DE6B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 131A81A064F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:07 +0000 (UTC)
X-FDA: 84404929854.20.4580C06
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf08.hostedemail.com (Postfix) with ESMTP id 165E916000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=crXiy018;
	spf=pass (imf08.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfjaUaIuA0bRrAc4cE77mBYy+gfHHyNJYKQPy6J33YE=;
	b=7sigc4OnbQKkxfswsex1jaa8hFhNdt4QQwCxMkARiPo4Uz3SRjO4KnPOacUF8dhmCOem3E
	wKUytoBChviLrHfnEeKibBJHkoi+yKaBB2IPDPzzvWtjQnMsbCqmSCtmfkXyW1usISGdGG
	trKu6Fgwxs5ObnDoWrDW9JTIfkVErXY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=crXiy018;
	spf=pass (imf08.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165905; a=rsa-sha256;
	cv=none;
	b=D24DozutquOpAs9NBPkjeB/zUibGQ7FESKq3nE0F1XCoWx5KL+ZlOPg8RE/JMBBLJq0D/q
	j9fJcemYp6GrFhDPP7m9hYAOj6yAPfMW/4UhsOUYnz47Rs/GhVb93pnPD+l0tDAuvLnhID
	j5FXM9pcPAJ5SF3lv0NSYAGjlPKO9lw=
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140hAvG3684475
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:44:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140hAvG3684475
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770165850;
	bh=UfjaUaIuA0bRrAc4cE77mBYy+gfHHyNJYKQPy6J33YE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=crXiy01897ayeasjguHKSzOn2NtespesB5xpL8Yz8Rro2GlQ+haqoeVfRwHO2y2Ex
	 m3GhQjzYodiuSlJ6RZGrBCU6iR57vXf5PayhAHKnL1Pv112u37riVXjQKdaq0vCe/b
	 ydVdAY7lyHrnl4HKaNsjKP8nG4CWoFCSEDXkPVeRUuwjWF9XDdYGeUicLa/knHNU/N
	 C2QNci0MUUj5Y7z1je88PgYSuhPDWNZGcNbn1GC/aVVG8aBNf5SGwaVgFGiCwU5wmj
	 IPwjHDCPKoUJkoh55eUg9V82sNLOEkpCqYnTGSiLUg7sGJ4ZrLnoHASpDWWnGpOsQK
	 zp+2hiw2M+duw==
Message-ID: <45453806-e861-4084-a89a-38adc48ff67b@zytor.com>
Date: Tue, 3 Feb 2026 16:43:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] x86/vdso: Fix DWARF generation for getrandom()
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
 <20260203171958.1522030-2-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-2-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yw93h5iqr6e8roubjstjzmydauxf3t64
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 165E916000B
X-HE-Tag: 1770165904-325034
X-HE-Meta: U2FsdGVkX1+D1BxiaE+IhaAE/ZCB8RxANCjMUMb5hi/gwZP82cFl0JGFf8GLcU0Nq375EFYsFe7hTQccSjcO0XdtX7Ch04Jn9v2vqzsSHTWM6INyawfRhNBFpFTOa0d8izcsafGLRuQ7HeWNhG+EnxLWpEDJi2DlSVtueCWNnjAdMSxNs0j01WOE2rPVH3iPJE0uc+X16G2ZQX8339e8npdoMrdoZO8VLAWcEhj+Ml65BB7wcjJyi+Afr/SnaIJm75iaNXMYgZGrm9VSe9UNzHrGZzH8mbo/Q8Ym1EvMliWs9Ne3WcWwLXxpH9hzzvAfXTWe554YO4Ypvaer2NPCVDd31s6K7ebi2p/MBgVL2+WgVTN7XTV5IwWFNHIz2I21M2Vu6FyIugBt44nsY1BUnFYpKAbu0zix7JF/79ydBGJBmyU0v7NI/vTUOByOVhPRaMY05/8RKOrzq8AjSPj5R65CQki5vYAEVNtJ1EyAirEYYiZlZoHgu6VlX/ccrV0Y4xWHdVl/cNyiwlBwMFLRugCmgbgmKa4I9mlT4tDTkKsdniRnkXm32Y3LtdQjogWQNz+2IFb10vkXaGqHGBo5h6TYQoZZ1PQToH8YB6IRRDD9O51y0Kaw1gbOpvK0r03NEZSay7rvxLIruFawI+K+Jvgw3Q0SNwctIBqrE38po5RRArablAOBCsrZ21+E+z0ydgC6rtJgt/jcf8b1+J9iIiRbaZl4wobLsftSAPlPRx5hkxsVb8nKRgO2jIb804UDIT/D6nJ7UuwM/MSvK7ZQ7fxO+IxCmk6PFL7gFldMZhq0eok/Dyg9PYYPE60GfOprR1LWbsWzbv0IBh9qZLKsbSoq/jaQbFxZqV9/rPvdm/98Ly3KQPFLeN9H913ThmnZ9l5hUydY+Za5UvBwBxHmhfLrExAA+UrDHy/gadxFFhwtLjLwfAc/c+l+YKyurq6pfgEiR4jS/3XAUN85bFv
 VNL3X7pH
 0Rj0+4NJMEi0dsA/nSe3md7FcjPgeghgwS8cvujbvnVS7mGqCihU+Rp/xolrk567pQRSDkuVAhazg2j4xQHonWPh8aMYHZflykB1opldqIBdjrRvfnS7MSahmTDoPny2o0loqVchfv28XP33CCLR+8aLAZaKxGhX1afqVSBvNFVh81SErgmXA7LJHy/2UYXI76oR/nd+tUMnt/HnywnScwPv/237M2yoHZ8ByiNkUvaPCaXMOZah7uysXl5TLzTlI96ZYiOGyaVjSk/PadhF3CvAsq/ZgnHNp3DZdhOEpA+BaFnQhGcsiDFLVAB0carz2iXTouTuZy0IixF4eFN/THPDmVr4xFKTLjWXCtupHtDTQlq3LnrY6qCrIxgiNaRKY1Wft7SFWOx7J/4ahvaQ/7s6n/1QsQqfyc2pjWlAlSIots4Ruu0xm0frsstkDDzixyUxDNNQHd2RlTd786BE2vtyQr09sfiq6nBuvAqnyOsbmbwj5oYoOx+y+EOyr3aIoGcr65v9gk5yf+zjjFKBrezE+Ew==
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
> Add CFI annotations to the VDSO implementation of getrandom() so it will
> have valid DWARF unwinding metadata.
> 
> Fixes: 33385150ac45 ("x86: vdso: Wire up getrandom() vDSO implementation")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
>  arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> index bcba5639b8ee..cc82da9216fb 100644
> --- a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> +++ b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
> @@ -4,7 +4,7 @@
>   */
>  
>  #include <linux/linkage.h>
> -#include <asm/frame.h>
> +#include <asm/dwarf2.h>
>  
>  .section	.rodata, "a"
>  .align 16
> @@ -22,7 +22,7 @@ CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
>   *	rcx: number of 64-byte blocks to write to output
>   */
>  SYM_FUNC_START(__arch_chacha20_blocks_nostack)
> -
> +	CFI_STARTPROC
>  .set	output,		%rdi
>  .set	key,		%rsi
>  .set	counter,	%rdx
> @@ -175,4 +175,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>  	pxor		temp,temp
>  
>  	ret
> +	CFI_ENDPROC
>  SYM_FUNC_END(__arch_chacha20_blocks_nostack)

Looks good to me.

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>


