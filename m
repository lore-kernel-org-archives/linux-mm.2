Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5757CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415FD8000B; Sun, 26 Oct 2025 18:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6748000A; Sun, 26 Oct 2025 18:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4EC8000B; Sun, 26 Oct 2025 18:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 155AD8000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:24:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DA3D13AEE6
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:24:39 +0000 (UTC)
X-FDA: 84041695878.14.319A1A8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id B28861C0004
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:24:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fME87SLA;
	spf=pass (imf21.hostedemail.com: domain of 3o5_-aAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3o5_-aAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761517477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHGZJ/FWhRHS3eTWCGRfR1qdcXyKkde8moMbVfyV3dM=;
	b=IETZN04HPEfo5xxTgMwvb9XcbMLHu1Yk6glOoEcWH+GtipcB+L5/xzVhi//r95R+Cht7lZ
	QymxP7pDW0B1V9GMn0te3p6CGjbnT7YOZE1b7em0gY/2f9prPzgLdIBCB85lfGnD6naylp
	9mNBbu1QhWli5mBZ4cAM/a3nBiBtm3Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fME87SLA;
	spf=pass (imf21.hostedemail.com: domain of 3o5_-aAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3o5_-aAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761517477; a=rsa-sha256;
	cv=none;
	b=GbixDKFtTUXYX9GH8lNSp8pojjc/jYrfoL2vj7BQufRiFnArcVITtpux+1nmzRPN+dmvFr
	f5Ka8XUOSld8cD1KTuoY2eSu6ZcR3x6vMB4ZMmEMq9VTThTgIPdMxMckzJqgZB/Gyn8Da8
	BtMuweHC03pyhEXg29rhy5OODreUhoo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso23147505e9.0
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 15:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761517476; x=1762122276; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cHGZJ/FWhRHS3eTWCGRfR1qdcXyKkde8moMbVfyV3dM=;
        b=fME87SLAcC2e48jne/4oiU1CenHAtNXRfrGsQt9kRVkIJdobo2Mbyo9x5r1UAs0/86
         MMlNQmkeuPECxzfXb+rIIcijxLnGCflBgz3BlQ6N8F6r8yLoSeHRaSiauopLI7140T9v
         iEUV4g5gimFKkwE+sVokGWfHN62OS63Pzyc/hHtlK4I8tnSSAtgw3mlgghltn8CCs2Ln
         fk2Q4xsaTt/DiDSG6ReKL5SX9yiiDmvaEKlihFksrEjlnSXcMI99UsB6/sbbOkfRm7od
         CYfLGjcrrPjtlkH/K7E8yVJolUTUwMzTYu4nzCR4sINZ/4plwIbxZmWVxYu21zGNfAnU
         ulHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761517476; x=1762122276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHGZJ/FWhRHS3eTWCGRfR1qdcXyKkde8moMbVfyV3dM=;
        b=FmT/ud431PUEE4Ag65IcWNtcx1qdufrNpBR+1Kx7qX+vK4LXe/xUnUG4tjFl+67Jvc
         2rfruK89MrtoIx/Gy8tA2nPpKb/EeNeSkSFQKLFkiBjvPGiv8QV6xF1qMwkw+3SXkFYy
         Pt7T1EJQbTMuU2BkbBBxO4/Z6nr0XcZXNtyPtYK95E/jHQWovCC6O/5Vi3JKXTupo5ck
         0jt1pRXKUueiI5hstbakJsKtf1USO6rqlscJz4yNm41jJA2JmQbKX23GueZmpkXEh5q7
         QHwagA/SvUvGzn73wsBmhx2AdVAe0cU1wDY6QXhCfTLy+85tlyLCT7VdBUi12YtC1snn
         KIaw==
X-Forwarded-Encrypted: i=1; AJvYcCXlpRvIf+U5XthnC4uJoS05ONVzBZnaTNZ9BL22h+aw4BNlCZVCyVvCfogrrjSDbwoEcaFKuNRS6w==@kvack.org
X-Gm-Message-State: AOJu0YyGefST19H9aEg8rB1041dNyJSAnxgHfqd3MzwsjhsnPTiBUaR+
	Ufg56GThMAffhI1K4QSvpRYdSFjRuRhYMAKCNmyhbDNlD7q6OgBOs/ziiXP9Jz6vhvAjKSH+3cA
	BCmci1NPs5mmQmg==
X-Google-Smtp-Source: AGHT+IHj/c8LyqHGoW5GCJEuHvxHaDbxWQRZUdfupcgzlN6fiqnXJsRG2h1ZOkjY2++CsrtrHb/vSh2pHHLn6Q==
X-Received: from wmol4.prod.google.com ([2002:a05:600c:47c4:b0:475:decb:4c4d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3541:b0:46e:5302:7751 with SMTP id 5b1f17b1804b1-475d24259d9mr78139875e9.9.1761517475888;
 Sun, 26 Oct 2025 15:24:35 -0700 (PDT)
Date: Sun, 26 Oct 2025 22:24:35 +0000
In-Reply-To: <20251025100642.GVaPyhMp4CEmsYW3xy@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com> <20251025100642.GVaPyhMp4CEmsYW3xy@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DDSLTWM2FL58.3MIDS5WUOEEZW@google.com>
Subject: Re: [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o4g3euro4wstyyznygzu96xibn1mxd7q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B28861C0004
X-HE-Tag: 1761517477-418924
X-HE-Meta: U2FsdGVkX19GkBwdS9/NM6IqYRHoihVN/xjg4bYNDNBGrvEIyMwb7At9sXWPF2oXHG7DVypfKI15lp3WzfrI95zHLBallbFaa4X/zZNz5u0TwfEQEfLylBHjhOiDQpInBtgZhbv1GhNKacRa5vldoGSLjPaquzbiyGQ9ZtUkzvodSREehNfFTBKfr7gz/vSpQRdDpBsrRULl+MYRnTXaT3ZyQhzQXnpWzD97GHWqqisCPvJC0Jy35uP7/91mPgyQYE7NcNIf1ukcl1UiWycCeFjUGBCv4fW6qojKWVuge2hxkw7lFfrAqfCTwt6ygnDWUwEn7GMcu7wo4tWM+KgacWnEF8MVrj22fM7VQVCF5x4bVUnkZMO+b/aSoGuzgI4lX0HEnYaLAbSZHEv8crE5GeHxkXqXibPh+fZcNZx3T8BAU7NtKD48vs98gjnPXRd+EjoeGrrKnViEdZntIqstG2lWSUSToQVNmD7gfLK93WOHTefbH+mpr6x0jbPwvqStEVofRE5vHyx2Hg3ioR8t384WbJV5tkGCdmxlNHFR0B+HuT4dIac1ONxLJsk+HVrLjH4BjPTOL1TwBWSDFpcoJhyw5vsmrE+2lWUewXOJD2yL5dH712x3c1ND0KyCXyKIuy+bdxY7o6oqhwLMKQW3h6hopsHVsuXf58a6MowjzfwbOAy/YsrOVymS0sHgZMrIbipwsguzRFTxiHpJtugppzEWPUW1T0ljeSebit6nBOd9F5z8KqfO9wiveHDVz6u6Nb0bpE7eRnPJrCP48ouNxZG7ZbFCbyE8QSvc3LTjp3snuKsVIL7LJV9JPEsvhm4qz0cYnk+KVswwi/c9OOIw4yUdGWpmK+gAs+nofhDaf2NQm9pIvo3yyLpAiHrKFQIpHwr7Q89AK5BLmJOQxvo1mgpklG72joKQEMszMhzWgrM52JvlAmmkUeWU/eTENr4VHiAevW7dT30NHh86y8C
 fhj2JP+2
 37XjHABTD9QqRaiIu+3tEeTjVYM4xuWgWepByNebnlQ4l+0Flq34ulGj1YK4OW69mK3a00JDSq3oGTlY4BasGdaOR3KiqV3ilA3J0+q8a4Uw9IezVV3Wmwq/FbT+e+QSKvqzusgvtJDtuMKR0YiNUHo8DnfZ3kPjLxUSUf65NijLRGEu5gMmWg5qIMEjU8TMU1EZ3ouKICJ0fasN1dQFiwWmEkYjp0F37EmZtiqwc8i65Y4+XrfI7vEASCN2w++q3FuULdps1DxarWYdEYCicH0IrQVKnyxFl617KwSoW0jBb8xL1DUn3dO4U4Jh4cwQF+49Mhcem9yYZHnge9LGgROvfW60ECrxUuZ3VmGbb8H979mo6nFPHpkZ2A8i+bBKYQLg1YHW+gYeGwm77KnuSiCTuO44mZGVqeZVo9wqjD/uNOUtUZcxucMEM1DDXRLeSvFDjBAcHjR+NIpiNZ0z2mNiZLykeDzj4AJSj2mIrovNitrKodmXOnoew2hbwF5pfzBT6veQI5Zuk/xPqYCuqSLB9ByC7s/IBmYcgyimF9Xe8BL7a4ZvA9Sqqvk+L67YkRTV9ixWkxv5+CvODPqJweLKavwrr78/LMxnDIFeq0RJcG07C7fNGn2r7/0MQGJg+djIwAoc77maYLV2cQV3uIDwgehTn1gyEXr3pdt1LYFlNicTCYMoEm+0jdzCQAoE8sQ4PEhyY0OkPzGHrL7dKks5ENlsBGIcEHh6n+oiVJMZKp5ECwr1Y77gfSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Oct 25, 2025 at 10:06 AM UTC, Borislav Petkov wrote:
> On Wed, Sep 24, 2025 at 02:59:37PM +0000, Brendan Jackman wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..9b8330fc1fe31721af39b08b58b729ced78ba803 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -5324,6 +5324,14 @@
>>  
>>  			Not specifying this option is equivalent to pti=auto.
>>  
>> +	asi=		[X86-64] Control Address Space Isolation (ASI), a
>> +			technology for mitigating CPU vulnerabilities.
>
>> 			ASI is
>> +			not yet ready to provide security guarantees but can be
>> +			enabled for evaluation.
>
> Yeah, no need for such "temporary" statements in the help text since you're
> going to have to touch it again once it becomes a full-fledged feature.

Sure. Per Dave's feedback it is anyway gonna have to be merged in a
state where it already does something useful, so I guess this statement
will need to be updated regardless.

>> +			on   - unconditionally enable
>> +			off  - unconditionally disable
>
> "unconditionally" as opposed to some other setting which is conditional?

My assumption here is that eventually we'll end up with an "auto"
setting or something, where the big startup condiguration dance in
bugs.c decides whether to enable ASI based on your CPU/attack vector
controls/individual mitigation configs.

>> +
>>  	pty.legacy_count=
>>  			[KNL] Number of legacy pty's. Overwrites compiled-in
>>  			default number.
>> diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
>> index 53acdf22fe33efc6ccedbae52b262a904868459a..32a4c04c4be0f6f425c7cbcff4c58f1827a4b4c4 100644
>> --- a/arch/x86/include/asm/asi.h
>> +++ b/arch/x86/include/asm/asi.h
>> @@ -2,4 +2,14 @@
>>  #ifndef _ASM_X86_ASI_H
>>  #define _ASM_X86_ASI_H
>>  
>> +#include <asm/cpufeature.h>
>> +
>> +void asi_check_boottime_disable(void);
>> +
>> +/* Helper for generic code. Arch code just uses cpu_feature_enabled(). */
>> +static inline bool asi_enabled_static(void)
>
> "static" because? There will be a dynamic one too?

Actually... no, probably not - should drop this from the name, thanks.

(At some point I think I was worried about spamming the kernel image
with too many static branches, but this seems like a bridge to cross if
we ever actually come to it).

>> +{
>> +	return cpu_feature_enabled(X86_FEATURE_ASI);
>> +}
>> +
>>  #endif /* _ASM_X86_ASI_H */
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3eee24a4cabf3b2131c34596236d8bc8eec05b3b 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -499,6 +499,7 @@
>>  #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
>>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
>> +#define X86_FEATURE_ASI			(21*32+17) /* Kernel Address Space Isolation */
>
> I think we really will need to show this in /proc/cpuinfo as it is a real, big
> feature which gets proper kernel glue vs some silly CPUID bit.
>
> IOW,
>
> #define X86_FEATURE_ASI			(21*32+17) /* "asi" Kernel Address Space Isolation */
> 						      ^^^^
>
> Not sure, though, when we should make it an ABI - perhaps once the whole pile
> has landed...

Hm yeah, I actually also thought I had some direct feedback from one of
the x86 maintainers saying not to expose it here. I can no longer find
that feedback on Lore so I think I must be misremembering, the flag
was already hidden back in [0].

[0] https://lore.kernel.org/linux-mm/20240712-asi-rfc-24-v1-5-144b319a40d8@google.com/

If that feedback indeed doesn't exist then personally I'd lean towards
exposing it right away, I don't see that much downside in terms of ABI,
since ASI kinda "doesn't do anything", from a SW point of view it's just
a very weird and complicated NOP. It's hard for me to see how userspace
could grow a functional dependency on this flag. Whereas for general
monitoring it's handy.

Still, there's definitely no hill I'd die on here.

>>  /*
>>   * BUG word(s)
>> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
>> index 5b9908f13dcfd092897f3778ee56ea4d45bdb868..5ecbff70964f61a903ac96cec3736a7cec1221fd 100644
>> --- a/arch/x86/mm/Makefile
>> +++ b/arch/x86/mm/Makefile
>> @@ -52,6 +52,7 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
>>  obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
>>  obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
>>  obj-$(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)	+= pti.o
>> +obj-$(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION)	+= asi.o
>>  
>>  obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
>>  obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
>> diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..8c907f3c84f43f66e412ecbfa99e67390d31a66f
>> --- /dev/null
>> +++ b/arch/x86/mm/asi.c
>> @@ -0,0 +1,28 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <linux/asi.h>
>> +#include <linux/init.h>
>> +#include <linux/string.h>
>> +
>> +#include <asm/cmdline.h>
>> +#include <asm/cpufeature.h>
>> +
>> +void __init asi_check_boottime_disable(void)
>> +{
>> +	bool enabled = false;
>> +	char arg[4];
>> +	int ret;
>> +
>> +	ret = cmdline_find_option(boot_command_line, "asi", arg, sizeof(arg));
>> +	if (ret == 3 && !strncmp(arg, "off", 3)) {
>> +		enabled = false;
>> +		pr_info("ASI explicitly disabled by kernel cmdline.\n");
>> +	} else if (ret == 2 && !strncmp(arg, "on", 2)) {
>> +		enabled = true;
>> +		pr_info("ASI enabled.\n");
>
> I'm not sure about those pr_info()s. When it is disabled, you can clear
> X86_FEATURE_ASI so you won't see it in /proc/cpuinfo and then it is disabled.
> And the same when it is enabled.

Agreed, if we expose the CPU flag we don't need the printks.

>> +	} else if (ret) {
>> +		pr_err("Unknown asi= flag '%s', try 'off' or 'on'\n", arg);
>> +	}
>> +
>> +	if (enabled)
>> +		setup_force_cpu_cap(X86_FEATURE_ASI);
>> +}
>
> Not an early_param() ?

Oh this is just for consistency with pti_check_boottime_disable(). But,
I think that function actually exists because of init ordering issues
that aren't relevant here, so early_param() seems fine to me (or, if I
find some reason why it doesn't, work, I'll add a comment in v2 to
explain why we don't use it).

Thanks for taking a look :)


