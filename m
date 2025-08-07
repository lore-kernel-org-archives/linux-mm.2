Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A404C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A83A8E0005; Thu,  7 Aug 2025 10:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FCA8E0001; Thu,  7 Aug 2025 10:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899FF8E0005; Thu,  7 Aug 2025 10:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 792388E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:54:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 297DF1A0E6D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:54:51 +0000 (UTC)
X-FDA: 83750258382.01.757D65A
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf29.hostedemail.com (Postfix) with ESMTP id F27C212000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:54:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754578489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/a0okRX/dH41N/ukS8AO30Ls9D9SS8xbqWSrZ78na8=;
	b=HUQMKxVGlAHXi1E5BTP+Bl+jjH0cfwBgMG5o0P2zYtKQVu7FSeHyi5B/57mpd0cnb/4jzE
	dYQA1fq0s9h7iZvmpOZOxJLpwZz1roOG4HT1R2tjrAKz+oRVqdsrhldUS17MZ32kLnLWg3
	iK7MiPRxYK8bugiQhPjhzH/bRkbm4k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754578489; a=rsa-sha256;
	cv=none;
	b=y5e4H2Zkvkeqiv1tehhBAIn6813llgu3DQCHgZcb1ru3MolR9zdpvyOY998LW8ctWPYbxT
	Z8OssVjQcBq6Sfrsbtt88+D+DI2JCuQRRzayK/JTCFQtDuuxX3Eef17n11UO9HWX4ZdYPB
	WubLEpYtpKQEjF2E4Dwwj+vBekmFoI8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id D2F4C441B8;
	Thu,  7 Aug 2025 14:54:44 +0000 (UTC)
Message-ID: <416b8286-7c78-4c56-8328-5e1b99bf15d4@ghiti.fr>
Date: Thu, 7 Aug 2025 16:54:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH RFC 2/2] riscv: introduce percpu.h into
 include/asm
To: yunhui cui <cuiyunhui@bytedance.com>
Cc: yury.norov@gmail.com, linux@rasmusvillemoes.dk, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@gentwo.org, linux-mm@kvack.org
References: <20250618034328.21904-1-cuiyunhui@bytedance.com>
 <20250618034328.21904-2-cuiyunhui@bytedance.com>
 <c9ba6163-6703-441b-915c-d784044f862f@ghiti.fr>
 <b0583098-204a-4ad1-b173-4bd00a358d61@ghiti.fr>
 <CAEEQ3w=uz-kTe05-fnPa_BfkZ6ZocQHg-G001yBtLqRM2zEr+g@mail.gmail.com>
 <404d38d7-f21b-4c97-b851-8b331deb3f8a@ghiti.fr>
 <CAEEQ3wknpn0Y6H8A-MEk-9hkvUwv0VapbtBR97Qhz9ipCk2Jew@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAEEQ3wknpn0Y6H8A-MEk-9hkvUwv0VapbtBR97Qhz9ipCk2Jew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduvdduvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeeuffefvdelteelteejhfejhedujeetteevtddvvddthfeiteffledvffeggfeiieenucffohhmrghinhepihhnfhhrrgguvggrugdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmeelfhgtfhemkegsfhelmeelleduugemkegrrghfnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmeelfhgtfhemkegsfhelmeelleduugemkegrrghfpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmeelfhgtfhemkegsfhelmeelleduugemkegrrghfngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduvddprhgtphhtthhopegtuhhihihunhhhuhhisegshihtvggurghntggvrdgtohhmpdhrtghpthhtohephihurhihrdhnohhrohhvsehgmhgrihhlrdgtohhmp
 dhrtghpt
 hhtoheplhhinhhugiesrhgrshhmuhhsvhhilhhlvghmohgvshdrughkpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhivhgvrdgtohhmpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F27C212000C
X-Stat-Signature: 8do1smr9qsmbj3tiz9hbedh93dnrg9bn
X-Rspam-User: 
X-HE-Tag: 1754578488-363720
X-HE-Meta: U2FsdGVkX18xz/i7E5ZzkwuUP7mFOVBKSCOx4kaylIDeKe8vVURWXJ+Vz2z4Ak2IZ/zx0s5AN6jWzrhyy6hng+2sMwmklWdggX5FiJ0AVEBShp47uNkxdRRBdRxEWCwLMbclC+ZxINm+QN7Xox/zDia8GM0iv4wKwh4FU5stWJYcXni4Ksb1BoQK1jMEzpi6sjI+qcej9DchtKxk3WR4AfUsFRSpM2GMfYgjaWo7uYQ+XzMyQIx6nGwFz6j3gGDefLeGI5YVvYqi+t0ePl5+d8G5zFUqAlr5Ec/IyEGcFGHze/1ABt/eWHQB25YtRL80Qe8ARoHMoQMcL6gycFMokPJopUPjPRBhlybkXVEKdUb8/dFtQrduPIPYKXwgoMnYZeeBwzdLoj2oL1ZvW0UTyMSveuc1pqxKDrHOEsBq+075ysB6ZGqHaFGsxnFX2RSlHE6MbpuMDmsVDenR5GIWoxQdqsvffFUOFCG6OhBMOQ0SkEs/Jjl6YMVm3O3ovCzWFZFaMFis8VC9RMC6sZeR8YEFAw93BqJivOU6oxaqIIKP/iPqeRvPFlPjOu03nmMriiRKg57YQVowsSJYwxMskajmZKwY6m0OqCkYNUCMl5aeYLewVGRI7G1XtxeMqSoReYDK9ZSF0CGO6XTnQLV+RJlLk8L1deern8WLNqxcikl7ZZ6uY061A3zJTrhorPJQ8dYyJqqXjsPZrTPoYZgif4K5G1BaeEbkKWp+XWiVzmTd9nYyEDZxOnvQizgwwYOZnkxX6GIkIh5ShwmuRxmWJYjbqpmQuIlhMbpp8VSmwFvNAkgVo3Xch9QKf8bu0hE2d4ttXUQZbfE8CHGK+GmeUIgEqj1O0TQFS1WhW7qpPk/X/vvruTF6jZUzC361W07lbD4KeykX4iKNfe8Ypz68NZy/6gNppi9xQGOvNU1RL2ZRMntHPf3Jxmeim12bZLtIgnGVnOpF0V8ATO26bkA
 Nhtzn3Lo
 Dbx10y1I9ap1sYCgepdxQ/F4iqSKBcX6PMh3AbWtgVxCU4scgQXumV7u8AapB7BZ+dbyp017JcSmiCXRUZXFKXpmNedegs/F7Se54Jdm/g3waVvhWn8siDTEwtC8joVvnb2vJCBTBKSFGSUMjYVQt4LrPMk6SoGC2n7hw++G6qhVjWatbIuAxSNjKUISl4/5HOUVdq2NG28Z02vV0neLLf0dSaE2/t0pc6f1DivRHfeGVQZPn7T+s2VQJqbn80NcfrKUs7MdFp5cqEOtfLh4Rpowl9816qAXU4vqoHbGDJHBW1JQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunhui,

On 7/18/25 16:33, yunhui cui wrote:
> Hi Alex，
>
> On Fri, Jul 18, 2025 at 10:23 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
>> Hi Yunhui,
>>
>> On 7/18/25 08:40, yunhui cui wrote:
>>> Hi Alex,
>>>
>>> On Thu, Jul 17, 2025 at 9:06 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
>>>> On 7/17/25 15:04, Alexandre Ghiti wrote:
>>>>> Hi Yunhui,
>>>>>
>>>>> On 6/18/25 05:43, Yunhui Cui wrote:
>>>>>> Current percpu operations rely on generic implementations, where
>>>>>> raw_local_irq_save() introduces substantial overhead. Optimization
>>>>>> is achieved through atomic operations and preemption disabling.
>>>>>>
>>>>>> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
>>>>>> ---
>>>>>>     arch/riscv/include/asm/percpu.h | 138 ++++++++++++++++++++++++++++++++
>>>>>>     1 file changed, 138 insertions(+)
>>>>>>     create mode 100644 arch/riscv/include/asm/percpu.h
>>>>>>
>>>>>> diff --git a/arch/riscv/include/asm/percpu.h
>>>>>> b/arch/riscv/include/asm/percpu.h
>>>>>> new file mode 100644
>>>>>> index 0000000000000..423c0d01f874c
>>>>>> --- /dev/null
>>>>>> +++ b/arch/riscv/include/asm/percpu.h
>>>>>> @@ -0,0 +1,138 @@
>>>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>>> +
>>>>>> +#ifndef __ASM_PERCPU_H
>>>>>> +#define __ASM_PERCPU_H
>>>>>> +
>>>>>> +#include <linux/preempt.h>
>>>>>> +
>>>>>> +#define PERCPU_RW_OPS(sz)                        \
>>>>>> +static inline unsigned long __percpu_read_##sz(void *ptr)        \
>>>>>> +{                                    \
>>>>>> +    return READ_ONCE(*(u##sz *)ptr);                \
>>>>>> +}                                    \
>>>>>> +                                    \
>>>>>> +static inline void __percpu_write_##sz(void *ptr, unsigned long
>>>>>> val)    \
>>>>>> +{                                    \
>>>>>> +    WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);                \
>>>>>> +}
>>>>>> +
>>>>>> +#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)            \
>>>>>> +static inline void                            \
>>>>>> +__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)        \
>>>>>> +{                                    \
>>>>>> +    asm volatile (                            \
>>>>>> +    "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
>>>>>> +    : [ptr] "+A" (*(u##sz *)ptr)                    \
>>>>>> +    : [val] "r" ((u##sz)(val))                    \
>>>>>> +    : "memory");                            \
>>>>>> +}
>>>>>> +
>>>>>> +#define __PERCPU_AMO_RET_OP_CASE(sfx, name, sz, amo_insn)        \
>>>>>> +static inline u##sz                            \
>>>>>> +__percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long
>>>>>> val)    \
>>>>>> +{                                    \
>>>>>> +    register u##sz ret;                        \
>>>>>> +                                    \
>>>>>> +    asm volatile (                            \
>>>>>> +    "amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"            \
>>>>>> +    : [ptr] "+A" (*(u##sz *)ptr), [ret] "=r" (ret)            \
>>>>>> +    : [val] "r" ((u##sz)(val))                    \
>>>>>> +    : "memory");                            \
>>>>>> +                                    \
>>>>>> +    return ret + val;                        \
>>>>>> +}
>>>>>> +
>>>>>> +#define PERCPU_OP(name, amo_insn)                    \
>>>>>> +    __PERCPU_AMO_OP_CASE(.b, name, 8, amo_insn)            \
>>>>>> +    __PERCPU_AMO_OP_CASE(.h, name, 16, amo_insn)            \
>>>>>> +    __PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)            \
>>>>>> +    __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)            \
>>>>>> +
>>>>>> +#define PERCPU_RET_OP(name, amo_insn)                    \
>>>>>> +    __PERCPU_AMO_RET_OP_CASE(.b, name, 8, amo_insn) \
>>>>>> +    __PERCPU_AMO_RET_OP_CASE(.h, name, 16, amo_insn)        \
>>>>>> +    __PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)        \
>>>>>> +    __PERCPU_AMO_RET_OP_CASE(.d, name, 64, amo_insn)
>>>>>> +
>>>>>> +PERCPU_RW_OPS(8)
>>>>>> +PERCPU_RW_OPS(16)
>>>>>> +PERCPU_RW_OPS(32)
>>>>>> +PERCPU_RW_OPS(64)
>>>>>> +
>>>>>> +PERCPU_OP(add, add)
>>>>>> +PERCPU_OP(andnot, and)
>>>>>> +PERCPU_OP(or, or)
>>>>>> +PERCPU_RET_OP(add, add)
>>>>>> +
>>>>>> +#undef PERCPU_RW_OPS
>>>>>> +#undef __PERCPU_AMO_OP_CASE
>>>>>> +#undef __PERCPU_AMO_RET_OP_CASE
>>>>>> +#undef PERCPU_OP
>>>>>> +#undef PERCPU_RET_OP
>>>>>> +
>>>>>> +#define _pcp_protect(op, pcp, ...)                    \
>>>>>> +({                                    \
>>>>>> +    preempt_disable_notrace();                    \
>>>>>> +    op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                \
>>>>>> +    preempt_enable_notrace();                    \
>>>>>> +})
>>>>>> +
>>>>>> +#define _pcp_protect_return(op, pcp, args...)                \
>>>>>> +({                                    \
>>>>>> +    typeof(pcp) __retval;                        \
>>>>>> +    preempt_disable_notrace();                    \
>>>>>> +    __retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);    \
>>>>>> +    preempt_enable_notrace();                    \
>>>>>> +    __retval;                            \
>>>>>> +})
>>>>>> +
>>>>>> +#define this_cpu_read_1(pcp) _pcp_protect_return(__percpu_read_8, pcp)
>>>>>> +#define this_cpu_read_2(pcp) _pcp_protect_return(__percpu_read_16, pcp)
>>>>>> +#define this_cpu_read_4(pcp) _pcp_protect_return(__percpu_read_32, pcp)
>>>>>> +#define this_cpu_read_8(pcp) _pcp_protect_return(__percpu_read_64, pcp)
>>>>>> +
>>>>>> +#define this_cpu_write_1(pcp, val) _pcp_protect(__percpu_write_8,
>>>>>> pcp, (unsigned long)val)
>>>>>> +#define this_cpu_write_2(pcp, val) _pcp_protect(__percpu_write_16,
>>>>>> pcp, (unsigned long)val)
>>>>>> +#define this_cpu_write_4(pcp, val) _pcp_protect(__percpu_write_32,
>>>>>> pcp, (unsigned long)val)
>>>>>> +#define this_cpu_write_8(pcp, val) _pcp_protect(__percpu_write_64,
>>>>>> pcp, (unsigned long)val)
>>>>>> +
>>>>>> +#define this_cpu_add_1(pcp, val)
>>>>>> _pcp_protect(__percpu_add_amo_case_8, pcp, val)
>>>>>> +#define this_cpu_add_2(pcp, val)
>>>>>> _pcp_protect(__percpu_add_amo_case_16, pcp, val)
>>>>>> +#define this_cpu_add_4(pcp, val)
>>>>>> _pcp_protect(__percpu_add_amo_case_32, pcp, val)
>>>>>> +#define this_cpu_add_8(pcp, val)
>>>>>> _pcp_protect(__percpu_add_amo_case_64, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_add_return_1(pcp, val)        \
>>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_8, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_add_return_2(pcp, val)        \
>>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_16, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_add_return_4(pcp, val)        \
>>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_32, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_add_return_8(pcp, val)        \
>>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_and_1(pcp, val)
>>>>>> _pcp_protect(__percpu_andnot_amo_case_8, pcp, ~val)
>>>>>> +#define this_cpu_and_2(pcp, val)
>>>>>> _pcp_protect(__percpu_andnot_amo_case_16, pcp, ~val)
>>>>>> +#define this_cpu_and_4(pcp, val)
>>>>>> _pcp_protect(__percpu_andnot_amo_case_32, pcp, ~val)
>>>>>> +#define this_cpu_and_8(pcp, val)
>>>>>> _pcp_protect(__percpu_andnot_amo_case_64, pcp, ~val)
>>>>> Why do we define __percpu_andnot based on amoand, and use
>>>>> __percpu_andnot with ~val here? Can't we just define __percpu_and?
>>
>> What about that ^?
>>
>>
>>>>>> +
>>>>>> +#define this_cpu_or_1(pcp, val) _pcp_protect(__percpu_or_amo_case_8,
>>>>>> pcp, val)
>>>>>> +#define this_cpu_or_2(pcp, val)
>>>>>> _pcp_protect(__percpu_or_amo_case_16, pcp, val)
>>>>>> +#define this_cpu_or_4(pcp, val)
>>>>>> _pcp_protect(__percpu_or_amo_case_32, pcp, val)
>>>>>> +#define this_cpu_or_8(pcp, val)
>>>>>> _pcp_protect(__percpu_or_amo_case_64, pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_xchg_1(pcp, val) _pcp_protect_return(xchg_relaxed,
>>>>>> pcp, val)
>>>>>> +#define this_cpu_xchg_2(pcp, val) _pcp_protect_return(xchg_relaxed,
>>>>>> pcp, val)
>>>>>> +#define this_cpu_xchg_4(pcp, val) _pcp_protect_return(xchg_relaxed,
>>>>>> pcp, val)
>>>>>> +#define this_cpu_xchg_8(pcp, val) _pcp_protect_return(xchg_relaxed,
>>>>>> pcp, val)
>>>>>> +
>>>>>> +#define this_cpu_cmpxchg_1(pcp, o, n)
>>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>>>>>> +#define this_cpu_cmpxchg_2(pcp, o, n)
>>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>>>>>> +#define this_cpu_cmpxchg_4(pcp, o, n)
>>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>>>>>> +#define this_cpu_cmpxchg_8(pcp, o, n)
>>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>>>>>> +
>>>>>> +#include <asm-generic/percpu.h>
>>>>>> +
>>>>>> +#endif /* __ASM_PERCPU_H */
>>>>> It all looks good to me, just one thing, can you also implement
>>>>> this_cpu_cmpxchg64/128()?
>>>>>
>>>> One last thing sorry, can you add a cover letter too?
>>> Okay.
>>>
>>>> Thanks!
>>>>
>>>> Alex
>>>>
>>>>
>>>>> And since this is almost a copy/paste from arm64, either mention it at
>>>>> the top of the file or (better) merge both implementations somewhere
>>>>> to avoid redefining existing code :) But up to you.
>>> Actually, there's a concern here. We should account for scenarios
>>> where ZABHA isn't supported. Given that xxx_8() and xxx_16() are
>>> rarely used in practice, could we initially support only xxx_32() and
>>> xxx_64()? For xxx_8() and xxx_16(), we could default to the generic
>>> implementation.
>>
>> Why isn't lr/sc enough?
> If I'm not mistaken, the current RISC-V does not support lr.bh/sc.bh,
> is that right?


Yes, that's right, but we have an implementation of cmpxchg[8|16]() that 
uses lr.w/sc.w which works (unless I missed something, I have just 
checked again), so I think that's alright no?

Thanks,

Alex


>
>>
>>>
>>>>> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Alex
>>>>>
>>>>>
>>>>>
>>> Thanks,
>>> Yunhui
>>>
>>> _______________________________________________
>>> linux-riscv mailing list
>>> linux-riscv@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
> Thanks,
> Yunhui
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

