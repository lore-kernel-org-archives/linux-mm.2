Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399FEE8B387
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C51C6B009F; Tue,  3 Feb 2026 19:50:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672296B00A0; Tue,  3 Feb 2026 19:50:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5717B6B00A1; Tue,  3 Feb 2026 19:50:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 426786B009F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:50:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D590E8C188
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:50:46 +0000 (UTC)
X-FDA: 84404944092.05.4164B32
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF53040002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:50:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=RWTj5e+h;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770166245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ejpaqsz9CMO56IB7gVAQcbMCdvB+s9mbb2E3+bpwa/4=;
	b=bCGS2FVjxISsTu0kccPri3dyLPUkMpCsHY+BQbXCdos+gR5hcYiu2FkQLGf7EIYYupUiPF
	W4oCexwbBlc+2s+tVFJbKwulLj0GoSplhljDy4Wh8Iz8u8rp2P5MMONncJnSfp+3gfEna1
	PNpLZ7a2t0WYUypljPRQy7wFxedA1Ls=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=RWTj5e+h;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770166245; a=rsa-sha256;
	cv=none;
	b=o/WbM8rWWWO3eTujnlZOzqoRDTGSTM0UtcMhYlOz8zIhagJ2pd+10dphdo7ekOkS+irU3a
	mmkzJkzPOIMk50+ZKG37xoJiBSZSTgMEdaXF57/K/9SnGlAfeyFTIFcMrmr6fQbajo/qjX
	1+SnR7Pf8KmFX/dWLaK59JB/jyFlGW4=
Received: from [IPV6:2601:646:8081:9484:7f27:8faf:e50:c87b] ([IPv6:2601:646:8081:9484:7f27:8faf:e50:c87b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6140o2eC3687362
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 16:50:05 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6140o2eC3687362
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770166207;
	bh=Ejpaqsz9CMO56IB7gVAQcbMCdvB+s9mbb2E3+bpwa/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RWTj5e+h1GfgY2uJUjhz+ZDqeE3AlVlEAgP9GkHrXJZVFnIPqKSm0iBR/rykX6U60
	 Pe7NjbAs0rJ2VbwvNuAooQlZj6dlXjUbjLB2AzoEAT0NyTPLYaHvr5IVlmySydgoKo
	 srrQOtWAUzNgHurf4mlIrxciyK6wAQL40q+qaJUNUR/nfnMw0PtdWFAA96j44VUZgS
	 VVzbV3gTd3t7nYdJMSRxY/FV4iNnhqTzuyVTsdIsayaKkqVUJmhdwYfzqNTR7gyikd
	 ZUfkPXSCCZ6FPF3kkb/4+YDggZf80bIpZJY+9rYq9aUfNIPNtK3u1SL417rVoujXia
	 KPQihnp3o/pnQ==
Message-ID: <f671c79a-ee73-4a12-af48-2811f97b9f3d@zytor.com>
Date: Tue, 3 Feb 2026 16:49:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] x86/vdso: Enable sframe generation in VDSO
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
 <20260203171958.1522030-7-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260203171958.1522030-7-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EF53040002
X-Stat-Signature: 1nbw9srs5jec8hjwyzq5rf7frxu1j1wo
X-Rspam-User: 
X-HE-Tag: 1770166244-269914
X-HE-Meta: U2FsdGVkX18NdBv22/TLgmea8q20JSqfuoXEAQZCKY/25bKVLfM+PQGBqQ0Io+1oOT8iBhJewXQFoggR87XTufx740dJ+GX3SHXjYEo6ABqom7Z5ElB7FFty+XEl5ZW3UfWafwLu48mpaSSSPX25txdr9wXJ7kyWpgSuQnP0XBv/kpf+Ga8ewWtoyVLFQtJoShByhYfsPA08hV/kdN3JEVcQxHAXdECMdei7RywQQ8//j4WxOPBmGHybOjvli5I633DaLZAaB0trw0/OmaEkRvhv//GV4i1Ystjj/vU/XMgE0o9De/V9cVSM2ZBGNWJrJncIeydur61gAwFNlBoBuAz6SIM9ClSpM64ud42Yldtv2+mgE0jqhW+ORxSSfpM/MEqKRh1W7PzzsMY8OwvEKWju+BmvxDJC3HMwspQTQLPFD1OEM4OMtVYOmcjh/PUmd9Pw53zAKo/293vqekybeWQ1d4VQiax+OvwrF0JszzLUt/YyFBpHX3AWp9rC6jhiVoFNJM8zNQwb/0WVKT1zs4hO3OU3968pjHifPJoqf7k8RCyW0266fNHXomhB1IYuahmS6bmoF46rpr7EC5xaI7apMbRvpn6fTgp3pmyq07B57QZ88a/8ltZ6MoCCOAspOM7hMdGOR+fwv++yeKImm0VVgdDPVC8y4sjIWvxjzNshYUq7vnq048KIPQpwAwYBwkkVNPBXM758bXnnxwGzRcfb21rwDreg7d1ccBTIpzpY2AlXwvwVCY0aXLQjuAGk86dVU6EuZxe/FHqCQEVj8IJC60VE9dKm5+krOUPzaGza9mw8ZY5auwT4gdKn6STKMG4xJMNdEnh8EUtHiq27O1E2aOZ+DuUJzu4zKoJOm/g3fmLjMiXfRdykGPZy1xNK8vu7gjsK1NouqUKK8Y+Wri3I8wiaGlxge7bs5+FLBnTB5TJzsGF4PwrPFC7nmjkkn1HH8Bb9imBGF+MFKJb
 828eyRsS
 fcph9Q1FolsVf3OmBlxYvO8q7tqb7kD4aqoz754ZwivbFro4hBkc67rba90DpcqPOZlijUSZQNtzJrLSVuu53NtPt543Fn3XONffRSUJKyOr0RXDH+hATjDIJmslV5x47cLmF3rkoKt5srHGZCXBk1FQesL0jlrdHq9n+V5WHppP9XL6g0YfXwKmc6I2m6m5eI19w4znOQSMuFh51qRkCkhOVYopHJ+/BuT8mHRxTxp1TQl1R6IqoqVGTgIQz/JSHe1siJxaVjSbrlZrdu5ITSXYNlDc04Z5LbSiwy1jmvEJ7pmew4tlSnQoHfE1e5eVDkKG1S95TZPZ+jDj5l9cbbv1AULKGPNQFYthSDrnJI+PDp3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-03 09:19, Jens Remus wrote:
> -
> +#if defined(__x86_64__) && defined(CONFIG_AS_SFRAME)
> +	.cfi_sections .eh_frame, .debug_frame, .sframe
> +#else
>  	.cfi_sections .eh_frame, .debug_frame
> +#endif
>  

It would be better to:

#undef CONFIG_AS_SFRAME	/* i386 doesn't support .sframe */

in fake_32bit_build.h.

	-hpa


