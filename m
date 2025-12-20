Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA5BE6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C88C6B0088; Sat, 20 Dec 2025 00:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9765F6B0089; Sat, 20 Dec 2025 00:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857B26B008A; Sat, 20 Dec 2025 00:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718DC6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:49:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AA046029E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:49:27 +0000 (UTC)
X-FDA: 84238771974.13.D1473A3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id C6C0C40003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:49:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766209765; a=rsa-sha256;
	cv=none;
	b=wW+XJgBH5E3eWe74/GJwUmqhcdM+Eibkt2jmZELuTWlavoPvW3E7P8LTN0elz9o++SUo4Q
	+4hMDTq2QsyjOhYkeAa3pAZSW9F8xIGj31EmaMNijdDOFKtDG6nnUHEiC6B1YAzkuLak5d
	I4z83AHguFlCtiYTEjOOFZeUv9JGpQY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766209765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7okOQ6xSw3cIWjhsylDeT146yAKFlCiQ/V+Z3H0RxOo=;
	b=KC/csX9VTIX5n+IjlLX1ClUMM7ouDJxctd808h+uzQrZIr6Useo0d1iBGroDZiQdNheL8v
	vftm35VTNxRH0rQ4NsURQQ4g4k54nN5cU0VITcWAvV1UssFcGTOiAU98FeA+mHgY6DkkDD
	KfFRBAsF0G4okd1/8Xk5G+geZxGIS1U=
X-UUID: db8d1ab4dd6611f0a38c85956e01ac42-20251220
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:51651edb-493c-41a1-801f-dabd13d97b87,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:51651edb-493c-41a1-801f-dabd13d97b87,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:ff1733cf03d1e39fa358ca7d4eb7e3f6,BulkI
	D:251219101318D8IDDZQS,BulkQuantity:2,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: db8d1ab4dd6611f0a38c85956e01ac42-20251220
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(61.48.209.219)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1618505666; Sat, 20 Dec 2025 13:43:48 +0800
Message-ID: <b2e84054-bf3b-4a1a-b946-bd024f341512@kylinos.cn>
Date: Sat, 20 Dec 2025 13:43:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] LoongArch: kfence: avoid use
 CONFIG_KFENCE_NUM_OBJECTS
To: Huacai Chen <chenhuacai@kernel.org>, yuan linyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, WANG Xuerui <kernel@xen0n.name>,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, enze.li@gmx.com
References: <20251218063916.1433615-1-yuanlinyu@honor.com>
 <20251218063916.1433615-2-yuanlinyu@honor.com>
 <CAAhV-H5n_3Ndk5yRm=S-9WktD9xivVF8-JLaycV8JB-pVuybbA@mail.gmail.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <CAAhV-H5n_3Ndk5yRm=S-9WktD9xivVF8-JLaycV8JB-pVuybbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6C0C40003
X-Rspamd-Server: rspam03
X-Stat-Signature: 9t358q67bx6wap7bmq1u4rst7awhu36m
X-Rspam-User: 
X-HE-Tag: 1766209760-343574
X-HE-Meta: U2FsdGVkX184w0fOdVd9YrVbvZJh1piD98YCkvWtHmSv6RNTtlsB6EzKi6FoXo02MtbR4cEa8e0y/hTOfhpzrm/dRGWGZt6hZrmaUrfOf4hPyUltNm/l55rOXSZokgL0J3EFQnxp1GopUbn6rhegCAKMoGPktyKbsAHnk6lHKuqUn2e3IGo8eOq8tbuQKfzKqmrF66WMutKnySXELUe4j8vheANL1VMfWFth2bXN3G4lmnet75wE5gEg7x9mxdrWMO+U5OYIBZ6w59Q+9AkrSCgxkVc3ODjHuAPVbXWpB/lmrmb5ouLtYsP8b+wOdcwGoPmbHr3CMwy+wVu4YrsK7BN1EycAAfRh84RgHQ0YPa3b8FCFYkRdvrdBqHv1heKmfMQiHVvgkvDUIswVaEWHq2Fkn0scWbMOt1guuq5dprSPuaKi+7mVpigb/SVoiOiZrx+RgKLFsgLyRqCetnwmeNB+Hu79HrTWHRoTRiSKrhT8/cj4ZcW47Saye4r8n3Ly1gQu3jZuwkvgJKd0SpBE9+mm+4MCH2+Uh1Ns5W85Cr09ZjWovfw+/+zNa+/vAmjckf4aiogSf8m10jq7R7166Xy6c8SxOm1FBvAqoP3Hx7bA/bWj3zBOH3AcTirD2CiSwFjM0pMzX0+4ZTVe/KSfDiVQYlYtCimuVkQ5Eob37dvMVdDC6gbc4DTtFXpVlQLoZePSKnPj2U+zV71Q+0UuPjgKfB9WPFA4QD5TjCDrBy4bK8UE3SNh3w2MBUqccgGVB2SvtQQG364PFPbkFYPdgfhmFhu+YyLRJ8EdadyFhpvQYFRRKNeWaoeI+L8J7hF+FQ1vHLouxSamqwUFlYBuYudU1ZeEULQT9qapHHaioNw340VVJYCWAZTSJriW0NAP56bIuzyxK6VfRCaSnLVSnNm+hkXqZcDPqbBhuZxprdF58qZ87kQw7eCQWXgihVJGltxf+KboWgBbEyMJZu0
 6VyyAiNI
 /j7wmLtXBiT6QX2Ehx/4M+NwHjFPaNXeCKgBHOvZzhIkC0ErijsvxXZ3aCzuUoPkNR2g1qPrSDQ6JrjXk0PBaTOOTX4XZekQvdNVcXyFfThDwWcv4qZiYsaPcNbq2zk4em0dcTK8c4S5ztOCnTifTDJEvoFsOgxhzoZtPRxuHUXdyIeB7bFtI8xHW0PpYI4asHUIBHpncFPv3E1epi/swn7vciWn/ddm875hn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/19 10:13, Huacai Chen wrote:
> Hi, Enze,
> 
> On Thu, Dec 18, 2025 at 2:39 PM yuan linyu <yuanlinyu@honor.com> wrote:
>>
>> use common kfence macro KFENCE_POOL_SIZE for KFENCE_AREA_SIZE definition
>>
>> Signed-off-by: yuan linyu <yuanlinyu@honor.com>
>> ---
>>  arch/loongarch/include/asm/pgtable.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
>> index f41a648a3d9e..e9966c9f844f 100644
>> --- a/arch/loongarch/include/asm/pgtable.h
>> +++ b/arch/loongarch/include/asm/pgtable.h
>> @@ -10,6 +10,7 @@
>>  #define _ASM_PGTABLE_H
>>
>>  #include <linux/compiler.h>
>> +#include <linux/kfence.h>
>>  #include <asm/addrspace.h>
>>  #include <asm/asm.h>
>>  #include <asm/page.h>
>> @@ -96,7 +97,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>>  #define MODULES_END    (MODULES_VADDR + SZ_256M)
>>
>>  #ifdef CONFIG_KFENCE
>> -#define KFENCE_AREA_SIZE       (((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
>> +#define KFENCE_AREA_SIZE       (KFENCE_POOL_SIZE + (2 * PAGE_SIZE))
> Can you remember why you didn't use KFENCE_POOL_SIZE at the first place?

I don't recall the exact reason off the top of my head, but I believe it
was due to complex dependency issues with the header files where
KFENCE_POOL_SIZE is defined.  To avoid those complications, we likely
opted to use KFENCE_NUM_OBJECTS directly.

I checked out the code at commit
(6ad3df56bb199134800933df2afcd7df3b03ef33 "LoongArch: Add KFENCE (Kernel
Electric-Fence) support") and encountered the following errors when
compiling with this patch applied.

8<------------------------------------------------------
  CC      arch/loongarch/kernel/asm-offsets.s
In file included from ./arch/loongarch/include/asm/pgtable.h:13,
                 from ./include/linux/pgtable.h:6,
                 from ./include/linux/mm.h:29,
                 from arch/loongarch/kernel/asm-offsets.c:9:
./include/linux/kfence.h:93:35: warning: 'struct kmem_cache' declared
inside parameter list will n
ot be visible outside of this definition or declaration
   93 | void kfence_shutdown_cache(struct kmem_cache *s);
      |                                   ^~~~~~~~~~
./include/linux/kfence.h:99:29: warning: 'struct kmem_cache' declared
inside parameter list will n
ot be visible outside of this definition or declaration
   99 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t
flags);
      |                             ^~~~~~~~~~
./include/linux/kfence.h:117:50: warning: 'struct kmem_cache' declared
inside parameter list will
not be visible outside of this definition or declaration
  117 | static __always_inline void *kfence_alloc(struct kmem_cache *s,
size_t size, gfp_t flags)
      |                                                  ^~~~~~~~~~
./include/linux/kfence.h: In function 'kfence_alloc':
./include/linux/kfence.h:128:31: error: passing argument 1 of
'__kfence_alloc' from incompatible p
ointer type [-Wincompatible-pointer-types]
  128 |         return __kfence_alloc(s, size, flags);
      |                               ^
      |                               |
      |                               struct kmem_cache *
./include/linux/kfence.h:99:41: note: expected 'struct kmem_cache *' but
argument is of type 'stru
ct kmem_cache *'
   99 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t
flags);
      |                      ~~~~~~~~~~~~~~~~~~~^
------------------------------------------------------>8

Similarly, after applying this patch to the latest code
(dd9b004b7ff3289fb7bae35130c0a5c0537266af "Merge tag 'trace-v6.19-rc1'")
from the master branch of the Linux repository and enabling KFENCE, I
encountered the following compilation errors.

8<------------------------------------------------------
  CC      arch/loongarch/kernel/asm-offsets.s
In file included from ./arch/loongarch/include/asm/pgtable.h:13,
                 from ./include/linux/pgtable.h:6,
                 from ./include/linux/mm.h:31,
                 from arch/loongarch/kernel/asm-offsets.c:11:
./include/linux/kfence.h:97:35: warning: 'struct kmem_cache' declared
inside parameter list will n
ot be visible outside of this definition or declaration
   97 | void kfence_shutdown_cache(struct kmem_cache *s);
      |                                   ^~~~~~~~~~
./include/linux/kfence.h:103:29: warning: 'struct kmem_cache' declared
inside parameter list will
not be visible outside of this definition or declaration
  103 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t
flags);
      |                             ^~~~~~~~~~
./include/linux/kfence.h:121:50: warning: 'struct kmem_cache' declared
inside parameter list will
not be visible outside of this definition or declaration
  121 | static __always_inline void *kfence_alloc(struct kmem_cache *s,
size_t size, gfp_t flags)
      |                                                  ^~~~~~~~~~
./include/linux/kfence.h: In function 'kfence_alloc':
./include/linux/kfence.h:132:31: error: passing argument 1 of
'__kfence_alloc' from incompatible p
ointer type [-Wincompatible-pointer-types]
  132 |         return __kfence_alloc(s, size, flags);
      |                               ^
      |                               |
      |                               struct kmem_cache *
./include/linux/kfence.h:103:41: note: expected 'struct kmem_cache *'
but argument is of type 'str
uct kmem_cache *'
  103 | void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t
flags);
      |                      ~~~~~~~~~~~~~~~~~~~^
------------------------------------------------------>8

So, this patch currently runs into compilation issues.  linyu probably
didn't have KFENCE enabled when compiling locally, which is why this
error was missed.  You can enable it as follows:

  Kernel hacking
    Memory Debugging
      [*] KFENCE: low-overhead sampling-based memory safety

Thanks,
Enze

<...>

