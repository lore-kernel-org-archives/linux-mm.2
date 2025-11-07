Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B865CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BF68E0005; Fri,  7 Nov 2025 10:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC848E0002; Fri,  7 Nov 2025 10:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB2C8E0005; Fri,  7 Nov 2025 10:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA838E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:23:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F7DA1A02C0
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:23:03 +0000 (UTC)
X-FDA: 84084179046.04.33BCDA9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 78A061C0014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:23:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762528981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=201pH6E+MecV9mtWTOJQYihUJg/+5cjD8vrLDVAbi6g=;
	b=mES5hU3AKNKy6Wxn0HqUWH+VMr5LvL8vwXTqeoONc9FLlmrcLGZKej0ebA2nt0b8bbZ1a4
	ai/qRPSJt0u0mlbSgmgFYkCtCfPgNfVlcPMNof55G4z8fiJd6+yy5GlVArVm/lhnynDFmS
	L3kE/MlcGBom9iE6nN0FOPJQTvn5R+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762528981; a=rsa-sha256;
	cv=none;
	b=SMsEzQUOsema+VZlZosoaE34dqA3A07TJ81zEOwEXSHnK8UZZWTKe9eg7lSEHePAoLiDF8
	+9P2boxTjs4+jr/cZCCxsu/p49GV77HmH2s2Mk4MUYNLmZQY04M/VMSMVKXbEpGWs+5MnK
	MdhR0i1SnXR+pYCLWLyd0KNbdlDC94M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C58F1515;
	Fri,  7 Nov 2025 07:22:52 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0C093F694;
	Fri,  7 Nov 2025 07:22:55 -0800 (PST)
Message-ID: <645178fd-df4e-42fe-b55e-97d9506499be@arm.com>
Date: Fri, 7 Nov 2025 15:22:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
 <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49e1i8idrxzwdfkw5i4ha3zhi9eqhcpa
X-Rspam-User: 
X-Rspamd-Queue-Id: 78A061C0014
X-Rspamd-Server: rspam01
X-HE-Tag: 1762528981-895595
X-HE-Meta: U2FsdGVkX18oPhxbE70zvBA08Nwhvi/9Y3jMTSmRSOKgdugrF5I0iXYP/DPFIvhB9C2tHs/s0io9xteSnT72F3SKO8gX8b4FH0f9AAWoEguDDBGLDIEAnDG936FOV0lrmAI4lJli/mztOGKLkYTFuOOjvaej9aXJ30yw55eVaxzhij9KiZOEUkja3cMOVEQ9Mz15Hjd6FkHVjuIyvBLhlzZCS9Kx1sH1VTUhWJ5BbDRRPk6UQAh1uKxQUeSFsZoq8y9QrsNzK+HN61kxpKpVCHaqJqLLHn+9qa42JNBMBijp/IlYyDq4DKZ6oG4TaYxkEofTTWwx6VlNUhd0LHl6md9QyqBNiCCSGMA5znElx2pn9Jh7HilpQoLQuvwmp8F0f7AIfyFNeJWiojjxfgWDsr8DyOhCpKuRlHf1j6yGPDparQSIint7ozxzGNK+PNW5ZDKYzS9YiRhlPWxaX46xGo/WhfWEiz1ZSa5f9eihdxTriJgvzO9bbODjURnxu/GkiaYwP5UjWA0ZSbSlRrQZr3VeU1C9+ilLZ1BJoirUqXAKVR40N/9zQMmv3KB5H19OsGeN9kq7Ubuwf3V76zyJjrFg3HHNDzh1pHNfSUOa/nFvu4LofvfwLhmnsDBAGv0Dys1XBc37ASdVnfozV5pcL+QD8Ozi+qFEGxzLS61ac/zue28mlq8Cl9ohA8C2egZZ/8pCcZUiPJ2c48VcC+KoYZhMp0Ds7EfuQrtEZcQdXwlgUOoVYEVnx4WdD6HOSUidBnLVGzVD0pJrwTeKo3PUvkQc0KPF6IGJGhOxEn0kenyYRdpHWwVNQcrmU+hGeKD5JAafel5FJaeXV1zhYzI+/jxO92/KyhwQXULj/PoCeRJkxqR/JJAxcWc+g4dnotkbO/HZLhCacLStxrYN/07MRcRBI8CSAn2VnaxuHTnBbfHxYdtnSmu3I2lF+6ZtVL0oqksW7wap7NLesqtzbrj
 ct705oMU
 0YOD/wkajOQn6M3kTWn/CTvrO6GCVdjdcCK35CyAu2N4g2DqFGvacq0SWFz1dMsKCxrbmoGEMUPO9ooHzHjfGAgWtIBN8rV3tCnCzy64+wXeZx0HY4GC4pjsYpgw+qg9spryr4IIdtih6o36wzzr2bHDUimcmuisuHuTK6q3cSHkkVhEQWxgYtl/LrMmCI38hF5/69uGAGljg9s6MUL87qxa1Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 14:34, David Hildenbrand (Red Hat) wrote:
>>>   #ifndef pte_batch_hint
>>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>>> index 5d2a876035d6..c49b029d3593 100644
>>> --- a/mm/kasan/shadow.c
>>> +++ b/mm/kasan/shadow.c
>>> @@ -305,7 +305,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep,
>>> unsigned long addr,
>>>       pte_t pte;
>>>       int index;
>>>   -    arch_leave_lazy_mmu_mode();
>>> +    lazy_mmu_mode_pause();
>>
>> I wonder if there really are use cases that *require* pause/resume? I think
>> these kasan cases could be correctly implemented using a new nest level instead?
>> Are there cases where the effects really need to be immediate or do the effects
>> just need to be visible when you get to where the resume is?
>>
>> If the latter, that could just be turned into a nested disable (e.g. a flush).
>> In this case, there is only 1 PTE write so no benefit, but I wonder if other
>> cases may have more PTE writes that could then still be batched. It would be
>> nice to simplify the API by removing pause/resume if we can?
> 
> It has clear semantics, clearer than some nest-disable IMHO.
> 
> Maybe you can elaborate how you would change ("simplify") the API in that
> regard? What would the API look like?

By simplify, I just meant can we remove lazy_mmu_mode_pause() and
lazy_mmu_mode_resume() ?


We currently have:

apply_to_page_range
  lazy_mmu_mode_enable()
    kasan_populate_vmalloc_pte()
      lazy_mmu_mode_pause()
      <code>
      lazy_mmu_mode_resume()
  lazy_mmu_mode_disable()

Where <code> is setting ptes. But if <code> doesn't need the effects to be
visible until lazy_mmu_mode_resume(), then you could replace the block with:

apply_to_page_range
  lazy_mmu_mode_enable()
    kasan_populate_vmalloc_pte()
      lazy_mmu_mode_enable()
      <code>
      lazy_mmu_mode_disable()
  lazy_mmu_mode_disable()

However, looking at this more closely, I'm not really clear on why we need *any*
special attention to lazy mmu inside of kasan_populate_vmalloc_pte() and
kasan_depopulate_vmalloc_pte().

I *think* that the original concern was that we were doing ptep_get(ptep) inside
of a lazy_mmu block? So we need to flush so that the getter returns the most
recent value? But given we have never written to that particular ptep while in
the lazy mmu block, there is surely no hazard in the first place?

apply_to_existing_page_range() will only call kasan_depopulate_vmalloc_pte()
once per pte, right? So given we read the ptep before writing it, there should
be no hazard? If so we can remove pause/resume.

Thanks,
Ryan


