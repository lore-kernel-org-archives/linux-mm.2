Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F63C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065616B009B; Fri,  8 Aug 2025 11:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CC86B009C; Fri,  8 Aug 2025 11:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95316B009E; Fri,  8 Aug 2025 11:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAE356B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:54:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C9AE1DBEB0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:54:38 +0000 (UTC)
X-FDA: 83754037836.01.CDB6D0E
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03297100012
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:54:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=cY1qxj6u;
	dmarc=pass (policy=none) header.from=syntacore.com;
	spf=pass (imf05.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754668476; a=rsa-sha256;
	cv=none;
	b=GNO1cURMxca/7P/+Kf8RJpx82rqYzKi25LDqkp07uZXAznbrbz7sNysROJbFm+qLOnuJjt
	qL+cX7MD0fpI4m0jWDYGh5nlgil/3guU6lnDQnVjaVYHYkVFHa4hPNeRL7DnejUW52e2Jo
	LQuDhOVKCSRk5xDycYR7+7IodzsDAjM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=cY1qxj6u;
	dmarc=pass (policy=none) header.from=syntacore.com;
	spf=pass (imf05.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754668476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc+rXQkjUIWlJHfTJTdiMVQq7J3K3zY9PQJSj6n1aPY=;
	b=spltDUwvxYECbF+yaYoDmL3mR1LGy2JzFJbNitf1b+cUmP8+Env5CH6HzlPXscj96plzfp
	BzZ0Vxaa9bOOjKuYc9pycCmKQW7WwNayy9Qic0GVfh7m6r+wiBdcBZxfDIQPffckNVRU+4
	fDYpYHlqFfW03iKa0YUqdWiUHpf+Kv0=
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 6A5741A0005;
	Fri,  8 Aug 2025 15:54:34 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 6A5741A0005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1754668474; bh=Kc+rXQkjUIWlJHfTJTdiMVQq7J3K3zY9PQJSj6n1aPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=cY1qxj6ujcXBoiuVPCl+xltzfS9Mli+br7NY1LQ7Y90FmKAMBaild5S9xJtD1UwL3
	 rCeoJBbLFG6tWSxbNwIEr/UWXAS9aERBN6cNQ9DOM8DMmxkdygcC+s5udB4H03T4Ma
	 zHqVGkbJEFzMaTmNqi4SfXObpMVNU9c1ib4KMChRBPLZ36JSZlnEqDN4vi4vSyFGP6
	 mq58f6e+axpHdDFRM9z4jWo1T5WSoVHBmSujkERo0l/0zui/ydNGuFpQZlU7jUQk9Y
	 CXQkXjJJDUGknP8UkGrSGa2p+SQEmXSlDCuOkMr0kkdIYNWVBcHfLlp39csWrHwJ/v
	 /j8jBVf745PtA==
Received: from S-SC-EXCH-01.corp.syntacore.com (exchange.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Fri,  8 Aug 2025 15:54:32 +0000 (UTC)
Received: from [10.178.118.36] (10.178.118.36) by
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 8 Aug 2025 18:53:53 +0300
Message-ID: <2c196c3f-4d49-494c-898e-8a1f6249ce24@syntacore.com>
Date: Fri, 8 Aug 2025 21:54:30 +0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND] binfmt_elf: preserve original ELF e_flags in core
 dumps
To: Kees Cook <kees@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <202508061152.6B26BDC6FB@keescook>
 <e9990237-bc83-4cbb-bab8-013b939a61fb@syntacore.com>
 <202508071414.5A5AB6B2@keescook>
Content-Language: en-US
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
In-Reply-To: <202508071414.5A5AB6B2@keescook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.178.118.36]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/08/08 08:14:00 #27646097
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03297100012
X-Stat-Signature: o3kzsmi4876x4sfk8kgjjybyjttedip7
X-Rspam-User: 
X-HE-Tag: 1754668475-589735
X-HE-Meta: U2FsdGVkX18XvSx1zE/1lwHXn1mx3qy/6/PUdD49td/U5KWsZ1svgj8J1nlo0KZibBrv/oE7n/eHmneZWPzLg4+a+XXwczRqz+UV0FJZOMbZYBMyCcZJI43tLY2ygOABuu/OeGC2KfnCF3BUbooURBrItyYttOPm3tbLgi/+M1gPwwzlnC4MkqVem2zmMhHL5Pc5HUCdPwaOaDjfJC1lkzSFiBsLwXkV5uoc+DrTFgheqca8l80KQeJ62f0g8FyHs+Krnzzgo2nc7J+VS8Pij6wmHPLa+UfYfw6aueQy4f6sRl68LSDdDrxaZDr6zez5DnPYO6wjVFWWN0GgiCoqJvvTiX0hy8dfsQhagrnko3Zry4SX+TXUYMZdkdBqx7Ss6hpMhveFwlxOZUfOb+lmvbyQ/zTI3AHYjyKgSY3yBAqZG4/qhpHaWjVZ30MkahzeHcQIXjy2ORbFr4kj8klU3rrpzWFtIOWs1gv76dDhwK4pvnJUsuj3k3SAV0dpBcliHat++/T8FH7JRzphthKxFeD8GlUodUckM0q+5pAM1R5LPpvv//e6QAyo6FgQ3qmfiWaH4FJl3f3pSaquvOJpaT1V0sRUikNTjKB1qfxN9pemnw9U1JfJmWJtng0/jYP2s/1JAKa9DItNNqk8mVl2yKT0/ogXznNkbjjxg9D5SLzw2DF2TVRV00pvppsuvC3KUjHH8+veW12ypWPyjBYiy28T8bjQO433EcbQ0HyC4eDdr41Oix7pjCgmsdOtXIAWwmehcSuF4YsQWUc/SCTN68wrZc2grHjShVr81mwAbXKEm7263COLnl9JqPB7hCF0Q7aOGpPRFso+hvtazQcMXOVjnQQ7GDqeBenFYiO5EkbMn+dZ7lowvw8hDh7H6zg6EeXoZZzkQJjOQTy/QA2GKfR0A253JSnVkZFCsP+d1tPCueVk3KqfHsnkdpYkdCBPIrb23upidP92TlqtiBb
 FEdSraYn
 yHl2RXs/YK/7Iko848YTukqiKr5fOHc0nUsn+orjjKAxAGn6pxYQiFwfYyQxISfeRklOHnd38xeFU84WCUydbqeD5hq1oAN3B6JpQXhoYOR+1dkiXFxQzCGw7pY72qdq4qD7b5EM/QkvihMhwtWcvK/c0FMOCy3CbAITmvHVEtVngWHhIysnPoMX7ho39wsEVOMjp+I2PWEbRBfNHJPWB2qiYuVh5fKDVHJUK+dOT4173m8sAglMkkC4gDEoslhPGjht+HXiF7Vwpd4r2Rjx1d0MP6+t3GwqVLgCZXSA/6GeCcdPTuSyp3oi5gfXCIiggJecv5vSw01XjFvHjUzc/Z2laIdin9w0myzNdjMUqWWFhf9vkibhSnzxHDHUVpHEzBWg0FNMoWpRl5vHjlvwBHJGYXbF7FPiDH+Cx2+B3Q9SaDCWw0YaEjfegBjLOgivo26BxLSKDEwOluLYy0jIgyu8nQ3BsTdxCxPMc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08/2025 03.14, Kees Cook wrote:
> On Thu, Aug 07, 2025 at 07:13:50PM +0600, Svetlana Parfenova wrote:
>> On 07/08/2025 00.57, Kees Cook wrote:
>>> On Wed, Aug 06, 2025 at 10:18:14PM +0600, Svetlana Parfenova
>>> wrote:
>>>> Preserve the original ELF e_flags from the executable in the
>>>> core dump header instead of relying on compile-time defaults
>>>> (ELF_CORE_EFLAGS or value from the regset view). This ensures
>>>> that ABI-specific flags in the dump file match the actual
>>>> binary being executed.
>>>> 
>>>> Save the e_flags field during ELF binary loading (in
>>>> load_elf_binary()) into the mm_struct, and later retrieve it
>>>> during core dump generation (in fill_note_info()). Use this
>>>> saved value to populate the e_flags in the core dump ELF
>>>> header.
>>>> 
>>>> Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS,
>>>> to guard this behavior. Although motivated by a RISC-V use
>>>> case, the mechanism is generic and can be applied to all
>>>> architectures.
>>> 
>>> In the general case, is e_flags mismatched? i.e. why hide this
>>> behind a Kconfig? Put another way, if I enabled this Kconfig and
>>> dumped core from some regular x86_64 process, will e_flags be
>>> different?
>>> 
>> 
>> The Kconfig option is currently restricted to the RISC-V
>> architecture because it's not clear to me whether other
>> architectures need actual e_flags value from ELF header. If this
>> option is disabled, the core dump will always use a compile time
>> value for e_flags, regardless of which method is selected:
>> ELF_CORE_EFLAGS or CORE_DUMP_USE_REGSET. And this constant does 
>> not necessarily reflect the actual e_flags of the running process
>> (at least on RISC-V), which can vary depending on how the binary
>> was compiled. Thus, I made a third method to obtain e_flags that
>> reflects the real value. And it is gated behind a Kconfig option,
>> as not all users may need it.
> 
> Can you check if the ELF e_flags and the hard-coded e_flags actually 
> differ on other architectures? I'd rather avoid using the Kconfig so
> we can have a common execution path for all architectures.
> 

I checked various architectures, and most don’t use e_flags in core
dumps - just zero value. For x86 this is valid since it doesn’t define
values for e_flags. However, architectures like ARM do have meaningful
e_flags, yet still they are set to zero in core dumps. I guess the real
question isn't about core dump correctness, but whether tools like GDB
actually rely on e_flags to provide debug information. Seems like most
architectures either don’t use it or can operate without it. RISC-V
looks like black sheep here ... GDB relies on e_flags to determine the
ABI and interpret the core dump correctly.

What if I rework my patch the following way:
- remove Kconfig option;
- add function/macro that would override e_flags with value taken from
process, but it would only be applied if architecture specifies that.

Would that be a better approach?

-- 
Best regards,
Svetlana Parfenova

