Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95631D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 09:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68EE6B0088; Mon, 22 Dec 2025 04:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33096B0089; Mon, 22 Dec 2025 04:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40546B008A; Mon, 22 Dec 2025 04:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 936866B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:47:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 555E760E10
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:47:35 +0000 (UTC)
X-FDA: 84246629670.05.BB01545
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F23A4000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:47:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766396853; a=rsa-sha256;
	cv=none;
	b=mGDviuqRuhE25DQcreV/YBXJDpEVSJT0De3q1caTLpBqTmScpNTl9eMsoOWEU9s9fjFuBr
	5PJBmif8gKquLHVCFgZzgaSxVw9YRfvw6T+CoxZwmEiT+i8vXJ6kuHULN05SoLPM65jY8U
	Y6c3U94Cb/yrnDhbr+ADgFRyXEXUoYw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766396853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aimI8FiNIO7ZgQp7ZWhdgpnUgUlmkdtRi5vbPLo3vA=;
	b=5lHhNGaC1hwX4z/ckJu5ZJGzSVJU4fHWG/uWdvObFXiT9301PvoU3I16sLobBmYK48ygdt
	DU6YqjMYxNC+AAkBZfJv1/tD/+FbOx2pGaJtludKIc0Db7yOh4S0xX0FPxmmwToi9Y+d6k
	NGevgYbympTf3HXkAjiMlZo+UGLkR3E=
X-UUID: d11e6e98df1911f0a38c85956e01ac42-20251222
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:de4d8268-dc8d-48f1-805e-f682d3a06cd1,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:de4d8268-dc8d-48f1-805e-f682d3a06cd1,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:ccaa6ce40de7d863f75bdf900ecd0ee9,BulkI
	D:251219101318D8IDDZQS,BulkQuantity:6,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d11e6e98df1911f0a38c85956e01ac42-20251222
X-User: lienze@kylinos.cn
Received: from [192.168.31.182] [(183.242.174.20)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1610835472; Mon, 22 Dec 2025 17:37:22 +0800
Message-ID: <44d4cf82-982c-455b-85c1-138e8c37cc8f@kylinos.cn>
Date: Mon, 22 Dec 2025 17:37:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] LoongArch: kfence: avoid use
 CONFIG_KFENCE_NUM_OBJECTS
To: yuanlinyu <yuanlinyu@honor.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, WANG Xuerui <kernel@xen0n.name>,
 "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "enze.li@gmx.com" <enze.li@gmx.com>
References: <20251218063916.1433615-1-yuanlinyu@honor.com>
 <20251218063916.1433615-2-yuanlinyu@honor.com>
 <CAAhV-H5n_3Ndk5yRm=S-9WktD9xivVF8-JLaycV8JB-pVuybbA@mail.gmail.com>
 <b2e84054-bf3b-4a1a-b946-bd024f341512@kylinos.cn>
 <ab69f5a942824394af6010f75a06c5f7@honor.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <ab69f5a942824394af6010f75a06c5f7@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F23A4000C
X-Stat-Signature: 11q4az4m8wfyiwbskuz4k9bhawng4bok
X-Rspam-User: 
X-HE-Tag: 1766396851-273337
X-HE-Meta: U2FsdGVkX1+MUfusebfaJnFj0SoDKKjndfzLVpeh9ifTPsueEXc6wEEd8g0V6vqdb2+VNW+6PX64FV2QJXtHAupA/b07e5mZjRqS3VZWkB3qRa2ZvtKoby+s4ZU2nHSg8r/UaQPD96Wp+Cj7d3s9YhuUWOW36e2VCcyIxPxashyJvggkir4eO5cBC5+eXlVGn5Wbf/v44oSykkhM1NX/vTScdnn5eoGpQ1zCETfBNXbxs+CNojf3fwt00+woA8fUEJYKteDUib4hEPM2zuSEDZSEBJtrFnsrxg28PrmYn3gFOpqEgtM4ODxqw24M6JN8WhliGkJvv6fhq1e9/E8KBGJjgVufSa9sHIQchl5RTRjvtLPHbP2F6RC1J6SFUqjNt+uXGupBPMka+XkqJ8S+Nz85OL9FjHaGhOU4HGhaidtVSpFb7Gv9PKbtD2fa7JIPWrFz35os5NNIsX7ey8oFngGACyqaxKLGXN5VwLYecsIZPhgg982QV9agCQSQdzin9T98VpM7vri+ZT7NOHAAQC75Bmkf2q7ZNKaG1ayFFZCLQYobQ4B4tyvTLbF3tU4oBF8B0T21FVnOSJz5eAncvnaKKPlitdbIqCWRdozIk7rbqENJYDUVfJB0apTeRmJU0Yi4KjrugLDlUNnC0Ae8OgojqovzxGg7fvns+QjikwTbp2c/gwKGpcK/OrvhuaPNUh4qLgVPhp18f1RYYyyJO8oGLCphqsEEy2Iqgp3itfk9Jl/LoKsD73t9XdPmcCycmBhmz17I9wLrNRDvW6pjKsUxO/Cxoc8StLiNDgXNnnxH/SZyuJnXWZBuU9BqUIc7ja2m7n6sVEIDPZWuE0hI1BVbkaBH5EBXG4FFUpO+/27ftDxOnxkLNF1jDceoxsbeTI+88B7ql6cC/7nI3iOTXKroHjWZJKx1IWgwK8IO4F2Z9eYj4VbEKVmgXtydGV+1O/V4AErWLlHSh1y72uD
 /8UlDN1E
 X+NatxsKOyNr69ft36bulNMR9GNL916U3233B8u038y0/AIBGttZRBwmXRVfrpj3p53nIISZQ4KESDYSaoo9f6baiW76GOQYZZeT1F3ocIR+npGcQaKmLeSaTPWEcRZUzbRG3n2GgB7Jq7a96yBUGKYLQG/Wc+sedMvpMOvEO5EeajtLeqv1CcKnDx4qCdWZ89dlNNCbxk0TLF+oalCEe1oMuAT0p+H0gHFTCoMIlaopjtzH/XTD0mALP2XQ2SUdXss55YTKG9yCin2ZvRk9pa+mYCciR/IP+rSfRJPRnOWiJz+CWwiRn1Fa6HLjFIpFx/+PrvtoSF0iBnVninp+8yNc6iMnLK3ThY+c/++8uXqEtQ2fGT6q8x6ohXYi4piivJmlXY2wqcBBs+a7qCl+qrUlntVp+hfnEYJiVlz7xZ5oe2vQpDjtecTSLk/+M/eGx8yB+CtMW5B/6+JPPV9oE9KQ9aBgOP/4UHl/z/zL0F81DlKXGyqCrY/oNXej3sSjhlZFi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 5:16 PM, yuanlinyu wrote:
>> From: Enze Li <lienze@kylinos.cn>
>> Sent: Saturday, December 20, 2025 1:44 PM
>> To: Huacai Chen <chenhuacai@kernel.org>; yuanlinyu <yuanlinyu@honor.com>
>> Cc: Alexander Potapenko <glider@google.com>; Marco Elver
>> <elver@google.com>; Dmitry Vyukov <dvyukov@google.com>; Andrew Morton
>> <akpm@linux-foundation.org>; WANG Xuerui <kernel@xen0n.name>;
>> kasan-dev@googlegroups.com; linux-mm@kvack.org; loongarch@lists.linux.dev;
>> linux-kernel@vger.kernel.org; enze.li@gmx.com
>> Subject: Re: [PATCH v2 1/2] LoongArch: kfence: avoid use
>> CONFIG_KFENCE_NUM_OBJECTS
>>
>> On 2025/12/19 10:13, Huacai Chen wrote:
>>> Hi, Enze,
>>>
>>> On Thu, Dec 18, 2025 at 2:39 PM yuan linyu <yuanlinyu@honor.com> wrote:
>>>>
>>>> use common kfence macro KFENCE_POOL_SIZE for KFENCE_AREA_SIZE
>>>> definition
>>>>
>>>> Signed-off-by: yuan linyu <yuanlinyu@honor.com>
>>>> ---
>>>>  arch/loongarch/include/asm/pgtable.h | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/loongarch/include/asm/pgtable.h
>>>> b/arch/loongarch/include/asm/pgtable.h
>>>> index f41a648a3d9e..e9966c9f844f 100644
>>>> --- a/arch/loongarch/include/asm/pgtable.h
>>>> +++ b/arch/loongarch/include/asm/pgtable.h
>>>> @@ -10,6 +10,7 @@
>>>>  #define _ASM_PGTABLE_H
>>>>
>>>>  #include <linux/compiler.h>
>>>> +#include <linux/kfence.h>
>>>>  #include <asm/addrspace.h>
>>>>  #include <asm/asm.h>
>>>>  #include <asm/page.h>
>>>> @@ -96,7 +97,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE /
>> sizeof(unsigned long)];
>>>>  #define MODULES_END    (MODULES_VADDR + SZ_256M)
>>>>
>>>>  #ifdef CONFIG_KFENCE
>>>> -#define KFENCE_AREA_SIZE       (((CONFIG_KFENCE_NUM_OBJECTS + 1)
>> * 2 + 2) * PAGE_SIZE)
>>>> +#define KFENCE_AREA_SIZE       (KFENCE_POOL_SIZE + (2 *
>> PAGE_SIZE))
>>> Can you remember why you didn't use KFENCE_POOL_SIZE at the first place?
>>
>> I don't recall the exact reason off the top of my head, but I believe it was due to
>> complex dependency issues with the header files where KFENCE_POOL_SIZE is
>> defined.  To avoid those complications, we likely opted to use
>> KFENCE_NUM_OBJECTS directly.
>>
>> I checked out the code at commit
>> (6ad3df56bb199134800933df2afcd7df3b03ef33 "LoongArch: Add KFENCE
>> (Kernel
>> Electric-Fence) support") and encountered the following errors when compiling
>> with this patch applied.
>>
>> 8<------------------------------------------------------
>>   CC      arch/loongarch/kernel/asm-offsets.s
>> In file included from ./arch/loongarch/include/asm/pgtable.h:13,
>>                  from ./include/linux/pgtable.h:6,
>>                  from ./include/linux/mm.h:29,
>>                  from arch/loongarch/kernel/asm-offsets.c:9:
>> ./include/linux/kfence.h:93:35: warning: 'struct kmem_cache' declared inside
>> parameter list will n ot be visible outside of this definition or declaration
>>    93 | void kfence_shutdown_cache(struct kmem_cache *s);
>>       |                                   ^~~~~~~~~~
>> ./include/linux/kfence.h:99:29: warning: 'struct kmem_cache' declared inside
>> parameter list will n ot be visible outside of this definition or declaration
>>    99 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags);
>>       |                             ^~~~~~~~~~
>> ./include/linux/kfence.h:117:50: warning: 'struct kmem_cache' declared inside
>> parameter list will not be visible outside of this definition or declaration
>>   117 | static __always_inline void *kfence_alloc(struct kmem_cache *s, size_t
>> size, gfp_t flags)
>>       |
>> ^~~~~~~~~~
>> ./include/linux/kfence.h: In function 'kfence_alloc':
>> ./include/linux/kfence.h:128:31: error: passing argument 1 of '__kfence_alloc'
>> from incompatible p ointer type [-Wincompatible-pointer-types]
>>   128 |         return __kfence_alloc(s, size, flags);
>>       |                               ^
>>       |                               |
>>       |                               struct kmem_cache *
>> ./include/linux/kfence.h:99:41: note: expected 'struct kmem_cache *' but
>> argument is of type 'stru ct kmem_cache *'
>>    99 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags);
>>       |                      ~~~~~~~~~~~~~~~~~~~^
>> ------------------------------------------------------>8
>>
>> Similarly, after applying this patch to the latest code
>> (dd9b004b7ff3289fb7bae35130c0a5c0537266af "Merge tag 'trace-v6.19-rc1'")
>> from the master branch of the Linux repository and enabling KFENCE, I
>> encountered the following compilation errors.
>>
>> 8<------------------------------------------------------
>>   CC      arch/loongarch/kernel/asm-offsets.s
>> In file included from ./arch/loongarch/include/asm/pgtable.h:13,
>>                  from ./include/linux/pgtable.h:6,
>>                  from ./include/linux/mm.h:31,
>>                  from arch/loongarch/kernel/asm-offsets.c:11:
>> ./include/linux/kfence.h:97:35: warning: 'struct kmem_cache' declared inside
>> parameter list will n ot be visible outside of this definition or declaration
>>    97 | void kfence_shutdown_cache(struct kmem_cache *s);
>>       |                                   ^~~~~~~~~~
>> ./include/linux/kfence.h:103:29: warning: 'struct kmem_cache' declared inside
>> parameter list will not be visible outside of this definition or declaration
>>   103 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags);
>>       |                             ^~~~~~~~~~
>> ./include/linux/kfence.h:121:50: warning: 'struct kmem_cache' declared inside
>> parameter list will not be visible outside of this definition or declaration
>>   121 | static __always_inline void *kfence_alloc(struct kmem_cache *s, size_t
>> size, gfp_t flags)
>>       |
>> ^~~~~~~~~~
>> ./include/linux/kfence.h: In function 'kfence_alloc':
>> ./include/linux/kfence.h:132:31: error: passing argument 1 of '__kfence_alloc'
>> from incompatible p ointer type [-Wincompatible-pointer-types]
>>   132 |         return __kfence_alloc(s, size, flags);
>>       |                               ^
>>       |                               |
>>       |                               struct kmem_cache *
>> ./include/linux/kfence.h:103:41: note: expected 'struct kmem_cache *'
>> but argument is of type 'str
>> uct kmem_cache *'
>>   103 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags);
>>       |                      ~~~~~~~~~~~~~~~~~~~^
>> ------------------------------------------------------>8
>>
>> So, this patch currently runs into compilation issues.  linyu probably didn't have
>> KFENCE enabled when compiling locally, which is why this error was missed.
>> You can enable it as follows:
>>
>>   Kernel hacking
>>     Memory Debugging
>>       [*] KFENCE: low-overhead sampling-based memory safety
> 
> Hi Enze,
> 
> Sorry only test on arm64.
> 
> Could you help fix the compile issue and provide a correct change ?
> 
> Or I need sometime to resolve the issue.
> 

Thanks for pointing out this issue.  I've taken a look at the
compilation problem you mentioned.  Based on my current understanding,
the header dependencies are quite complex, and I couldn't find a
straightforward fix without potentially affecting other parts of the
codebase.

Given the risk of introducing broader compilation errors, I think it
might be safer to hold off on using the KFENCE_POOL_SIZE macro for now,
unless there's a clear and safe path forward that I might have missed.
I'm happy to discuss this further if you have any insights or suggestions.

Thanks,
Enze




