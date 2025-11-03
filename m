Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A73CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA858E0045; Mon,  3 Nov 2025 03:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A858E002A; Mon,  3 Nov 2025 03:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0DB8E0045; Mon,  3 Nov 2025 03:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66D478E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:44:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F17A489582
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:44:07 +0000 (UTC)
X-FDA: 84068658534.26.DAB302C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5A4240006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:44:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762159446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kqus/bENyLqUugbsvbTj5CuNW139iThTvbetDlSt2PI=;
	b=P/OeFv3gtZE0YMV15WMJtF3nW/F59VMzb0PijslXaABXIvzOe/uy6osA+E5YkkkDvwarVt
	NFy35vEe5Bj4bPUQNLSJv09Y4RXoZlzghSnladn73rYw7BXvU1mRLm4ImN2FjL7lkelgzs
	kia1l3FENdHEVRonL2XV9Ie41BjE6mg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762159446; a=rsa-sha256;
	cv=none;
	b=8VeORfSLlMXdttlgQoI56dwfg0U5oGob6OnyWv4kXppBBz0/xPN4/RZ88EQZMSubg2hO0J
	bYKtautsukY2Xc39obdN5m5RI/kOvbggUJypsHCISbd3PZT52K4h6iA4HWvQnS1da6sbsG
	KyAMbal36gS41A5h9I/CquA7JlYTNFo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF88A1D13;
	Mon,  3 Nov 2025 00:43:56 -0800 (PST)
Received: from [10.164.136.41] (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3999F3F694;
	Mon,  3 Nov 2025 00:43:57 -0800 (PST)
Message-ID: <666e012e-0b13-4def-82de-55ccd5868d36@arm.com>
Date: Mon, 3 Nov 2025 14:13:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
To: Qi Zheng <zhengqi.arch@bytedance.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, hannes@cmpxchg.org
Cc: ryan.roberts@arm.com, hpa@zytor.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shakeel.butt@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251103063718.90743-1-dev.jain@arm.com>
 <044e3f9a-3de2-4939-afff-3bb527eb024b@bytedance.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <044e3f9a-3de2-4939-afff-3bb527eb024b@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tox79y77b93x548fgyfrus4839kssumi
X-Rspam-User: 
X-Rspamd-Queue-Id: B5A4240006
X-HE-Tag: 1762159445-477258
X-HE-Meta: U2FsdGVkX1/FJD1zHhjBmDsaGPfoPzzZr3BGCIliaohHGBnnYULwcdq/XZyQTpMKbWAjZhb6AzVjZv27zgsHQPN6xnkNROfvybpK8bftufUxiyp1l45GvBFSyNAEU+lfJ/p5dKb3y4hdWYjS0D4TOXQxytXD2W6PSb5Nq6HwIPfp9rkxp3MgFNx6jPM24fVHJSoR85+guKKNeFcZgnO5faAeYyHZojZQPNRuFgbJBTfyvWKTkvrpyVnEIJw2mtGU8253k4xDlTd4AVzRsYN8U5zvzK2EEZVTjRfsVCzPpYAoBKRqZGc+oAtQvQUlH0ZLqZmJBdBlEerHOEKPOwJ+gpB4q7HApMMD1XzR8ua+ySBLYs67UQ1qvVzjAeB0OuKAp+HDtl8IV0LgqrX+bNs+/81zurvQJpKEnov5dYFE9/F4rW0OsCt8hNAfqS2XwbdK8uTk/kfDXVubh1SSfNs/3DfOF5ckPZoqLc6Z9WPJwi09Pw0YfKlc21f+dWKkJ80Yigpnu/G4cgrEwBApCKe8uyrKPzDXx62J6DbkEPtrxKvz14JgsZoShM+ml1KKXXvPmQyCFjayc/S5ty4ct3+1lbFdIeonylVX0yFVKgWYH0gmed+xwaKLUlMNV359MMOsWxiO/+Gu6VS47oGZexENc8x+PMJUn98pI7syAMcA9u65+mYSnX4z/psxQA/Fg+gVFsZwDSTCdg9E2mP1/gdQwQ1psefVi2VBVkl7ovXG/LkgSJUzNNWXOwdysk3Vqh/QmUyFtX0nQmDMQnAyF07n8+buoS3+Gk6fbSu8PtJKhhQijZyEfQPTnBeAxTDbaolAZtUBj51BIMgsm2bD6Re/g4kr/FmvUwL5vmkuOncHHPcXw8SDs/FQhrhpu0WEcATqWz/0861fG2F5EUPe4iVVXcTe5IUtDd20H2fD35UikqXxdpGg+94QiqQakycq7hwvV1+Mq0IdmQ8Zjz1nCNU
 lmOo1MM2
 otV2Yct2oyiAXWjCm3QRdhJRIEjX9P7nSU5VvxVPqciu6vXwjWOtjN6sRzAMTTOxCA8aEZieYQ5Jlw9XCSM8A391O7e3i5hk/3r51Zs9CILOiK1uRttO4nG3powi5Ttgj4dXo6DL4Olyy6Ud9gG9kvXe0cSeo+Ajde3HBtIY20/t/dBABjpJrOZ4H0a3pNePq5LJKXU9PdyTZkOgScsN86XYjjGUS6GwXqAKCl0T8oEZj779Rot5tT/echJyrQFwqidhLNZVH/FckKrDTzJMVTcrENr6rpimI+38IsIpYQOTaeETLcJPtYhHGkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/11/25 12:33 pm, Qi Zheng wrote:
> Hi Dev,
>
> On 11/3/25 2:37 PM, Dev Jain wrote:
>> The implementation of CONFIG_PT_RECLAIM is completely contained in 
>> generic
>> mm code. It depends on the RCU callback which will reclaim the 
>> pagetables -
>> there is nothing arch-specific about that. So, enable this config for
>> all architectures.
>
> Thanks for doing this!
>
> But unfortunately, not all architectures call tlb_remove_ptdesc() in
> __pte_free_tlb(). Some architectures directly call pte_free() to
> free PTE pages (without RCU).

Thanks! This was not obvious to figure out.

Is there an arch bottleneck because of which they do this? I mean to say,

is something stopping us from simply redirecting __pte_free_tlb to 
tlb_remove_ptdesc

or pte_free_defer?


I am looking to enable this config at least on arm64 by default, I 
believe it will be legal

to do this at least here.


>
> We need to modify these architectures first, otherwise it will
> lead to UAF. This approach is feasible because Hugh provides similar
> support in pte_free_defer().
>
> Enabling PT_RECLAIM on all architecture has always been on my
> TODO list, but it's been blocked by other things. :(
>
> Thanks,
> Qi
>
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   arch/x86/Kconfig | 1 -
>>   mm/Kconfig       | 5 +----
>>   mm/pt_reclaim.c  | 2 +-
>>   3 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index fa3b616af03a..5681308a5650 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -327,7 +327,6 @@ config X86
>>       select FUNCTION_ALIGNMENT_4B
>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>       select SCHED_SMT            if SMP
>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 0e26f4fc8717..903c37d02555 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>         The architecture has hardware support for userspace shadow call
>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>   -config ARCH_SUPPORTS_PT_RECLAIM
>> -    def_bool n
>> -
>>   config PT_RECLAIM
>>       bool "reclaim empty user page table pages"
>>       default y
>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> +    depends on MMU && SMP
>>       select MMU_GATHER_RCU_TABLE_FREE
>>       help
>>         Try to reclaim empty user page table pages in paths other 
>> than munmap
>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>> index 7e9455a18aae..049e17f08c6a 100644
>> --- a/mm/pt_reclaim.c
>> +++ b/mm/pt_reclaim.c
>> @@ -1,6 +1,6 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   #include <linux/hugetlb.h>
>> -#include <asm-generic/tlb.h>
>> +#include <asm/tlb.h>
>>   #include <asm/pgalloc.h>
>>     #include "internal.h"
>

