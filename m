Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C7FEE6B6A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B02A6B0098; Fri,  6 Feb 2026 18:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D846B0099; Fri,  6 Feb 2026 18:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F5D6B009B; Fri,  6 Feb 2026 18:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 308EB6B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:11:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD951160251
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:11:45 +0000 (UTC)
X-FDA: 84415580970.09.BB32268
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94B85140004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:11:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=f6mExEWV;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf09.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770419504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVE23sU8f0tF/woG1DKU3iF/2D4ifdEew5Zjv3zRdio=;
	b=YRKLype2pZpqeRiQ7TVUAc9fOH8QOa0PyACanWa2GeCEGneLwQgmyJUIRIZv+Ft6myXVov
	uM5ESilrXbNl2pjHeTeIkZz7np6lzXOnqECg4uOf13yu5YSGdZ9a7GRMuHN6EUh0oKuwJz
	mU5UNzRxqB1iZadd188TBKmlxahnnYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770419504; a=rsa-sha256;
	cv=none;
	b=8jXDKOp2ab5f1DrCYwZzJuzaePuG9l6cMvRSMvJdHyWvSBrCCkGqVB6TiHD+FSmNBLm+0O
	BkolYowmOWB4C0QRy6b8oWdOHzf+MddEz+DC5I9ZCkxGzAZI44XU94cxFB/keKgcOts1ww
	r/iw5x/oDefRRkcy5g2T6sJjhZi5VYM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=f6mExEWV;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf09.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from [IPV6:2601:646:8081:9484:da7e:5e09:3c1e:8002] ([IPv6:2601:646:8081:9484:da7e:5e09:3c1e:8002])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 616N8MNN1391383
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 6 Feb 2026 15:08:29 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 616N8MNN1391383
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770419312;
	bh=FVE23sU8f0tF/woG1DKU3iF/2D4ifdEew5Zjv3zRdio=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f6mExEWVcFoGl+DPFS7WpxlxeCRIHac6tvcqDNllvY7fcn5iEbosRIzvziGMVi/jr
	 IlZrZd/QABAJm2OHwDCNpqS9Bw2KbrG4IncZjpAWpmV6APHhylB1Bq9EOsCNzpQe1c
	 pz4U8RZ3j8bVG6TzLrp+r8xc4p+Kt8wLNpOS0TqiPsWKN/d9wFnwjWOh04emb2YoTR
	 svx3yUV2tx8YCHfBHxvpyy21Ps1+5ztp55UBPmKZTWspjimi2ZvfuvNGRAI5DS5db8
	 5dBNmHcpOQXuS2bisH9Fug5kgfNmaEss+y8njKZu8sjy7noBU6YSnK1NreRaOSUXl0
	 4okmimMg43c4g==
Message-ID: <4304d18a-f647-4709-9f29-43d9995cc24e@zytor.com>
Date: Fri, 6 Feb 2026 15:08:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/6] x86/vdso: Enable sframe generation in VDSO
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
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
 <20260206193642.1580787-7-jremus@linux.ibm.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260206193642.1580787-7-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94B85140004
X-Stat-Signature: s5yjxek4thxxzoxy4fhysifmfjuhhfd1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770419503-355760
X-HE-Meta: U2FsdGVkX1+ZnplQ0Yc+MjxMlaZXcEZPbLfkVUD0x8LrirKIxSlWWrOBvChV5wMjoQcX+9bcOxeIHXo91ZVu6fAIe/IGN3yBmxsnFZaNGmkrUX2xwipeYzWoqfy4O3jTk/KW7iBsjYqEk8B0KZEywR1iWg7eUFD8CvytQv/XJ+aVwq5vhfe5WWtRakrAiVubH5eWQUd35wP2IPQ3G7m7P5YvjwAlCKxnei42wXa8m5zZId3JQu7Y2DrfZ3cD3/DKGQIJkHqZv2XvvqZev7jpxZFJDq92M7Orcb0hcwCR4pJHzbw0ZVv89TYcteafMq5J8LWFy/ELAQcsN+SZ1twp8NBYW3yyfGqmGHd34x22BbZoebrPPVhUEhOOEDoNMg0RjPVu+mXPMXroA3SdGONZOqO9H6RCtkH2kXkG97fQgUZxOcQyZMVLSeaqJ6D4MRjepegSjxPwUUCU/tPgR69hcamFnrDBrT9fUwYtqRimjQwgp+HR6Kz1HajBuiMvX75M0BR8kIRmkFjfykRluLSJRiDE3CHDRoAb88PkzwthkMJVqrJe9z7pVQOlskzuugl2tNkcmixerC++kkN8dU/D70U+7SPE8RZ5z+Hl/3byvHe3WVwkPzPYUkv3efzn3aucjkouoxAgqPRygbYPRtTqoxg1qkjs+xpG9Bh74MP2+/JH6Zpz9H4u9fw+d1LTeS9Tx5e/f3rj/E5jCIYgNtTRBmgGIsTgd4tSwnP468cLMxZiFdBfkKF/QpfTb8sMccaGoXQORzZugQWrBZDaThkgkF4gZr/20sUiUuBlEJJeM+FCZoNT6/WnD7RqkXKZYFciglnLGuJ7Ii6Ky99E6AfwalaTA6o/33tJOo/LECpMIpLoe27PFUKNeY1GFjaFNPgSSKz9iQAlU9gXSI98uMSkcPpZuzozGv3q5Bvku4qvtuzwhUf14br4S7i0yPsVke0d4oudSQi9sQdRSObbfFU
 bIUtOIZ2
 q3/Q7N6upv9YasQwDDpF7vIUjyD3rt2rqVLyL++/sKOHlTG0/EuHA41ZHrU19CT1qfawqDbC8hDX3xLCYftPwsmGfBH0dE7NFneLxGRBOZx7WbmrsMTNVoEW637hUAi0QMymYSdCBVMKbtuoMoziWA23WdpidFtsASUttoSwhoyrszLGjTh5UOTgMyGqGY3L/q4Vkbv5OGcLXFo38g0xf5cAt6Moyno7BrFzPj2fTTsQSRM+ASm77bA4y2Wh4396O+f+Vz7U5vZ0tmYCvZvSA763ahxAc98lH4ftpSceQ+DioAkIKvfumnw4loOJZjeWBYTrdDWANLNhQpQo2ZZw/13b4QKFJI/h/pJzsCU72LMJ8QhYMEUI8f6Xpi7K9b2fAMqQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-06 11:36, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Enable sframe generation in the VDSO library so kernel and user space
> can unwind through it.
> 
> SFrame isn't supported for x32 or x86-32.  Discard .sframe sections for
> those VDSOs.
> 
> [ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
> table entry to empty .sframe section. ]
> 

This will not break the x86-32 build if the assembler encounters .sframe?

> Notes (jremus):
>     Changes in v8:
>     - Discard .sframe for x32 and x86-32 VDSOs. (Josh/Indu)
>       Note that the use of KEEP_SFRAME enables to define it for x86-64
>       VDSO only.  Unlike CONFIG_AS_SFRAME, which may also be defined
>       for x32 and x86-32 VDSO.  In x32 VDSO it would result in superfluous
>       .sframe (copied from the x86-64 build - could be removed in X32
>       build step).  In x86-32 VDSO it would cause a bogus GNU_SFRAME
>       program table entry.

For x32, this would be a "valid" sframe, right, even if the tools currently
don't know how to consume it (and potentially never will)? If so, is there
really any reason to explicitly remove it?

>  	/*
>  	 * Text is well-separated from actual data: there's plenty of
>  	 * stuff that isn't used at runtime in between.
> @@ -80,6 +87,10 @@ SECTIONS
>  		*(.discard)
>  		*(.discard.*)
>  		*(__bug_table)
> +#ifndef KEEP_SFRAME
> +		*(.sframe)
> +		*(.sframe.*)
> +#endif

This #ifndef is actually not necessary: if we have already "consumed" the
.sframe* sections they will not be encountered here.

I would prefer to have KEEP_SFRAME always defined (as true or false, and using
#if) instead of using #ifdef. I believe that also means you can do:

#define KEEP_SFRAME IS_ENABLED(CONFIG_AS_SFRAME)

... instead of #ifdef.

	-hpa


