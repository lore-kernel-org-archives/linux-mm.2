Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6403E8B387
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A14B6B0096; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DA46B0098; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281E96B0099; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13C7B6B0096
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE95C160637
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:26 +0000 (UTC)
X-FDA: 84404930652.19.B535084
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf11.hostedemail.com (Postfix) with ESMTP id E180340002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=1WuCWlAZ;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j99Bl1HWmVYx7aLiUOrbHBPAuPixzOzdzIN5XbrCTiI=;
	b=YqYSdOd0fJ/du9PtaIggRL5S6H7tRzMrQmZukocFyChZrL9mEgiOcRvaTseB2T2J2flW1R
	wVcUznW5Tb8prMKmV+kANQ+dRWcGhMXm2fHvDBA24/d+/4ghLWvleCOXExOZo6XI2UAoRa
	Y068W63Sr/yiYmBtnvyJ2K7Ccid5hNM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=1WuCWlAZ;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165925; a=rsa-sha256;
	cv=none;
	b=zinuMXy+BhptxPRxa6pRBg3WmvPBR7RC9XAhNlywUyTp/gTeU9dplklSqbpd9bcBpB31HM
	naqBT2NPIBzB9dJXQwMOKorWud7U5VQm0mrSal2oq5j/9CAoaOyTAA87zg6l6+NkYWCcQQ
	0PSQRXr+3pddBdE487nRvy5hmaLZco4=
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140iX2x3686652
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:44:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140iX2x3686652
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770165897;
	bh=j99Bl1HWmVYx7aLiUOrbHBPAuPixzOzdzIN5XbrCTiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=1WuCWlAZ2LhZ2XdJJ//0ZKbxmRZIMy+v0Q5Gs+tyjOaTdMQRWYkOsudn7MKWqWVj9
	 7MOkiVAg9MeJkyt9wpViQhHOzhaI4cLck8cqu8Q5oZAn3yaGJ3hmgnZUwC57NKUG4a
	 9Cd6aLdiAeDMlHU31HZdzetIgs+2qDwu0z7wG6CRIA8wiZhY5Vm7Sr/URCsMiP2TWx
	 92ZwmWLg4zz9CBBrZu7gBRDNA0XHl3a0Y4HhbfY4l97iKjFZxMD3dDVAuaTF9vYaMi
	 lIOUHeu+YHDGAZko7kuLNPRKFLShhAcrJhcISGLtcCf3nrmXRK5Q4rRz5da+K79hPT
	 vqMZkagnMRgMw==
Message-ID: <63dd1427-06c3-4bb8-b57e-f36cb417c381@zytor.com>
Date: Tue, 3 Feb 2026 16:44:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] x86/vdso: Use SYM_FUNC_{START,END} in
 __kernel_vsyscall()
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
 <20260203171958.1522030-5-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-5-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E180340002
X-Stat-Signature: mws37u17adc838trhczzrw7rsh4o1djo
X-Rspam-User: 
X-HE-Tag: 1770165924-127788
X-HE-Meta: U2FsdGVkX18SapYA8D1hZF9qMj1eQOnWYBIxmrDToXXaC5SnQYuwgVzPOh6hXXJkTerntGL7TdO7snLnWwxR7sFtiy1OYgArqsAmSCP1Wa2nJoNPKUoHyisVInBOWq99SP5Ttn4OH/IN4ktjuEVIQUN9es9AYMt+dALvGkSWooNRBIvyS9D7fAubgMW2mZ+kbb5cW+aWz53Z52WtPEY0yybymd68Xqzjhvk7bcC8wOvGYhX8D5EXWPUh3rKNrb9pxx40XmdRrQFBli+bDk/KN/wGYfeApk6IVEjyaGODIzsl3hYfd+BK9tDBDtcUho+qH5ub7+enVDNdtHUc3SS5DmGM+r/43sX1V1z3kiyAdFJ/SMCICr6P/kM5EGwpyqatlqMMkvoOE9Okrsa5DS4DeFo2bpz5EVpAaUmVhbf8CGChseUjpvsMJdd1iqmxK3EpIUaGj/RtWoj+hRbFZGWwDJAmoYGIHMZkm3qBMoldKrqEUfy5QEpKGRsfLi9y0fROtqfehj9gde56fMqy8aY+fciuiN38uGsoxP6uI1v2LflDdp1A1FSY7fy5fz3aMyjZXC6akhAsinw0+w/6cD6d4G8jVWEmqi/JFd/nQhInYpKWGJYxCLIwi4BOcMnW9EJTg7AacqpC7hYHDCMfhQXDgqp3F3ZxfFygBSOco+RMBGEi1ePLgwto1IvbGLt5lfrNs34Pz115lIhQ/ZXq8+teqxNkqahpnvS89H1PUp2s3XU7hYLzwwAw0Qy8Kp+oCOf8KCRsLnbEkZH9t9/6jmcTF7M8DWRh/ixdSoXbRxjKz2gYpeS1uej4NUjcJl47UE6uNojiR5SK+v1bonvZUwI5snOmm9ot72FAuhvHJg65xjm6i80mKUlq/8ofyp5VrlUOtZRmvaY/4tEpwfkKyH/izyr2G8AD3haym/ptQ7BXkmEelj53STzZ4X4SrTtXZbrdiwTV0Ka2U9dGRcfvivW
 uQkNremI
 UFBytnkL8fZnBdZ2c4VBpil+FBi0WtmoWcp5nthCqXJD3wj6COPP4JVzrSN4ZoAqhIa+X25AzTvzIFmKdf3k5YT8DXxwnqloCYZt3N4Gf3hecHxXW3CZfNBWW9EteL44WwffOwDIXIsg6YaGw/DncKTLuJAGDuszPex7qe5/5D6T8+XG2mt3S+EvvWyie8s1JMbjPCGSVqjIgtgarAaVVLq8QGL4Pc93xLq/TG1DbMiMEMBvsFjyksGxFiBoEFMRp7ddSBpTsJqdiuLn0/1pXS8nP/P58NabJPyukCqlyKZ3W58ouRPB8JgdjBCfGjUGwg3OnGhfYKLuJ6IWO8Rvuuut8s5SHvzHhUdwwBvj58KJ6jjNZHCTJsTV9DOqmfHefD+FnJmbEwtN/IbE1POoaMKU2wzQmpPIrhBI6rWj+/QAucy9D3y8wmbcYQrLIQyxblVlXjbuTubhIPe+pzkrMmwZuxCmrO8kkhpZ4B8ksEU6wwCXL1UMX77g1gioi4kT3tFcPI31U4kL4usMGl0A5dADFgwet3/No/o6rl1Y1bZQ94cblYtL1IaVvn8h6w0gc6bD6ZsF0B7bUtlo=
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
> Use SYM_FUNC_{START,END} instead of all the boilerplate.  No functional
> change.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
> 
> Notes (jremus):
>     Changes in v7:
>     - Rebase on H. Peter Anvin's vDSO changes on tip:x86/entry.
> 
>  arch/x86/entry/vdso/vdso32/system_call.S | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
> index 9157cf9c5749..a90f4f7de396 100644
> --- a/arch/x86/entry/vdso/vdso32/system_call.S
> +++ b/arch/x86/entry/vdso/vdso32/system_call.S
> @@ -9,11 +9,7 @@
>  #include <asm/alternative.h>
>  
>  	.text
> -	.globl __kernel_vsyscall
> -	.type __kernel_vsyscall,@function
> -	ALIGN
> -__kernel_vsyscall:
> -	CFI_STARTPROC
> +SYM_FUNC_START(__kernel_vsyscall)
>  
>  	/*
>  	 * If using int $0x80, there is no reason to muck about with the
> @@ -85,7 +81,5 @@ SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
>  	CFI_RESTORE		ecx
>  	CFI_ADJUST_CFA_OFFSET	-4
>  	RET
> -	CFI_ENDPROC
> -
> -	.size __kernel_vsyscall,.-__kernel_vsyscall
> +SYM_FUNC_END(__kernel_vsyscall)
>  	.previous

Looks good to me.

Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>


