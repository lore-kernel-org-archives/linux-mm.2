Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7294C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70146B0096; Fri, 18 Sep 2026 05:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A481E6B0098; Fri, 18 Sep 2026 05:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D376B0099; Fri, 18 Sep 2026 05:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD4F6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94986A0600
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:14 +0000 (UTC)
X-FDA: 85226314068.26.F5FA6FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BFB8016000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FcgVFMee;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dG/NQKkV41YhIgrIyd1kGa7K3ptoEDA2CGGt3WrAYAE=;
	b=LFOmTsQ5RfFzTuH8ylBTXoTqp+zykMhIeto0AAbC82N42g8XP2XvjfWnJ2/u81PfyItJpP
	oMCMhuSGsVOJnb3GiS0JjldAhmabM9JBOKT9bgfkk9E+K7Uflku/oa3GY4TYHWHWMF0lv5
	sGj1IaDbIK4F+u3ABn04W/fGIdz4uVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722672;
	b=PtFet/UwWnlTwhR4xmCd+SvNn/hMpx/+E6mw4CubsSF2U58OA0RTQ2mfuN+EY8Mpalb1S8
	09FRp1FEzYJM+jGQB5XNnXK3N7gdlZXsjEY5pYznuQGlhwiKJfF/m1IvG9p/yYFtyNLn/4
	6iD53e/u5GfOzUTZRDGyv6Rbsy7RDlA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FcgVFMee;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C426E40193;
	Fri, 18 Sep 2026 09:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAB21F00893;
	Fri, 18 Sep 2026 09:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789722671;
	bh=dG/NQKkV41YhIgrIyd1kGa7K3ptoEDA2CGGt3WrAYAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FcgVFMee+7sqAMMPEXTmkt4Ce4EqkYw/71EiqfiHMdlyb3ofAgUVEqi1SAGuiQ3IP
	 Z0xlcRWx8VoB9qokS9t1VxTzx+gFGV7kzSxOxWThG/a+ERFdVpq0rr8yxZHwIn13VO
	 Bb1ni3BbkCkjdpaUZ9NQhibPREdVJFxI5PdG4QQsfiEdcTiJtgLkIoYXypHnLI+YJu
	 a0WQ54kX1lr8qictRHrNQUoz5VfQmxDrLrTCuHaabztx3f33sw14YBlKYxpxlu1Leh
	 tYGkxMvWrqr2maFU8Z9S6g1dGkY0GDCwjiP539adNBTTDrEFmRIaQ3qZ5whpL33YE5
	 J8D58mL5RX1Dw==
Message-ID: <930f3db4-9034-4a48-98b2-07a44de3a718@kernel.org>
Date: Fri, 18 Sep 2026 11:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
To: Barry Song <baohua@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, david@kernel.org, dev.jain@arm.com,
 jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
 <58e3b456-7389-4752-8de5-1cc82964c3c7@kernel.org>
 <CAGsJ_4wKG91hd1Y3W4mbdh6B8Kq09JyDjyvXeeCmQj+L6bHm2A@mail.gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <CAGsJ_4wKG91hd1Y3W4mbdh6B8Kq09JyDjyvXeeCmQj+L6bHm2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wcm8m95jtb85qufq8k9ey6tnxar983p7
X-Rspam-User: 
X-Rspamd-Queue-Id: BFB8016000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789722672-870453
X-HE-Meta: U2FsdGVkX19pAzf7yihLfvCDdE4rNBJtWhVR2RlW0nsfCHsWf7lZKKXTnKloNFFfl3DXwqL+XG7wi9pF5k6BUjQr61lQQyKwNWxNCs+OZumefg3gHR0up19h9uM/R5iAJQW3FTM9Jaam10ru+E7q0WBXPkQzdEoRnbXEFGlvGfyE/X7BU27gXACj4ghwkFBESVoatPTwgurjXLoKReuTAU/RFWw0Li4Ehv8TAx3x9mpTquTG0O1jpJvZoHE/tqGt7l3CONepNQhwkGrgX90Mmv97HoiIpTxXnW+Ic/aiFRfbP6XbFmsOl6FEw5E6GePDOgujcfHErZCUZb2O9tWgZpXyetKblPeHtI+S1LU1gUvd5TLYCjtR/tudByBp+nKvgQU+O0OyTnE1A3LRpS6u3+xvAjfMjMiNh5N0GKKra9nbnNgKEregOI6q2ix/5pJLwHzYG9t0y/0YRB0QfI7LvLYAhpWaISnpICamJPPZwG7pG+pvQpQ8AWR2zxiWaSTOaYKadeEp7NyLr8Teq2Bmt10Zj7AEQ0ZYkRtHcxE1WczapWcD8JZQ8ulEad+4rOOlgYxsC3dJ1/kl9/oFU7fZ/hDnmbUixslC7H0RfOTHXItjU7i8OkIW2kbrDqLT2oDyTCN1R0kp8uy+fGZIsmU8uciXwplNTJncVd4fwMXImisVz+Z7SPW8qOhGjMs/1NMYFEwc1cvttOcEzH5nUKY7RvYr4Gtnl4+B/WxHnaLmEP3ZKBV+4HurbAFYm6+CfdlH4mIiP9wWgcam0D/WvrRzKMMcMnHJc7DRJg2M7WRpdlRTwwDbaJ+ipTkL+/YSz214yn5D+pYMn8HpmbVcpJpFu3BXThxZi2HkEPpc8M4w+mu5rlnZWYCRvnbRvxqxExFbhTwkSv4fTf/2T7qSO4ddJuy3ogM09eTrd7A8GJk/UWuHwDmkFWyS98kfUGnkiH12t2yDx+fKiv2jaEsjckV
 NkGGhwyD
 dtnCDLoEEfFVaPNPQ4tXdaQlQ94y1OLPVo8OIbwhKhsgvxFQcvteAUqjxGqyuky5H1BWB4n0fs7+KKx2uH25vF2nn1Tb4Zxy5o9kcAUC0OgKz547DBGqkKeCLNysd1H3r3tR8X1qbRnMRlYugbjBs+/4vgd/fWQqG4qyWthfwEYa5w3plZhMQ3intMqUsufnDT8LA+Vl9w0O8B0c59xbjC/1D/eJvrZM8siIpTG1m4RLKJbuRs9oDZbEyB5bpQYmIW+s/ymecXUfOc7+zzfqQneqVn6vd+2XVxqd0VuuBq68a7PwcRu+6LUfFrV6YOURJSy1ZlFuP7nSSbN3YhgezMeu3neVrVwmlLzlarJL2WK0x24BmtVkNGYA9gNBMwc7LWidmEIitheYWHg2Y17fxQB/kyaqnMyPB6M9Zo/NN9LE4OmiTW6USyBcAvxjDgAl7FIxZoBwwJl5YAAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 18/09/2026 à 10:44, Barry Song a écrit :
> On Fri, Sep 18, 2026 at 2:14 PM Christophe Leroy (CS GROUP)
> <chleroy@kernel.org> wrote:
>>
>>
>>
>> Le 17/09/2026 à 07:29, Wen Jiang a écrit :
>>> From: Wen Jiang <jiangwen6@xiaomi.com>
>>>
>>> vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
>>> by reusing set_huge_pte_at(), a HugeTLB helper gated by
>>> CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
>>> CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
>>> internals it does not otherwise need.
>>>
>>> Add pte_set_huge() to powerpc/8xx, next to the existing
>>> pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
>>> PTE and writes it into the backing cells directly, without going through
>>> set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.
>>>
>>> No pte_clear_huge() is needed: 8xx does not implement
>>> arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
>>> block-mapping branch.
>>>
>>> In practice PPC_8xx selects HUGETLBFS unconditionally, so
>>> CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
>>> cleanup rather than a new configuration.
>>
>> 8xx selects CONFIG_HUGETLB_PAGE because it uses set_huge_pte_at() to map
>> kernel text with large pages. That was added by commit 34536d780683
>> ("powerpc/8xx: Add a function to early map kernel via huge pages")
>>
>> But now pte_set_huge() could be used instead in
>> __early_map_kernel_hugepage() and then CONFIG_HUGETLB_PAGE could be removed.
> 
> Hi Christophe,
> 
> Do you mean the code below? If so, it sounds like a good place to
> clean this up for powerpc as a separate cleanup patch.

Yes this is what I have in mind allthough I have not studied it in details.

> 
> diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
> index 2518d2a6bdb4..830cdb391161 100644
> --- a/arch/powerpc/mm/nohash/8xx.c
> +++ b/arch/powerpc/mm/nohash/8xx.c
> @@ -87,9 +87,7 @@ static int __ref
> __early_map_kernel_hugepage(unsigned long va, phys_addr_t pa,
>          if (WARN_ON(!ptep))
>                  return -ENOMEM;
> 
> -       set_huge_pte_at(&init_mm, va, ptep,
> -                       arch_make_huge_pte(pfn_pte(pa >> PAGE_SHIFT,
> prot), shift, 0),
> -                       1UL << shift);
> +       pte_set_huge(ptep, va, pa, prot, 1UL << shift);
> 
>          return 0;
>   }
> diff --git a/arch/powerpc/platforms/Kconfig.cputype
> b/arch/powerpc/platforms/Kconfig.cputype
> index f0adbf7ecb7f..efba4d960083 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -41,7 +41,6 @@ config PPC_8xx
>          select FSL_SOC
>          select PPC_KUEP
>          select HAVE_ARCH_VMAP_STACK
> -       select HUGETLBFS
> 
>   config 44x
>          bool "AMCC 44x, 46x or 47x"
> 
>>
>>>
>>> There is no caller yet: mm/vmalloc.c is converted later in this series,
>>> once the generic fallbacks are in place.
>>>
>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>
>> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> 
> Best Regards
> Barry


