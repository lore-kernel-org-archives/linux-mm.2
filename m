Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF05C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143A96B009B; Fri, 18 Sep 2026 03:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B2F6B009D; Fri, 18 Sep 2026 03:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0312A6B009E; Fri, 18 Sep 2026 03:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72956B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:04:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 604E314059A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:04:06 +0000 (UTC)
X-FDA: 85225993692.27.518518B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B5B21C0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:04:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWKDEaWg;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C99qchwVmIf8eGzA2KZRAlNCqTMDn2E/1eNOjto5V1g=;
	b=1nJQHB/0tfWLA066vmXoxMHQw9epmhrFigbfC1B0JeUngdA4GAwfA/05bFNxMT7jh+RhDG
	kPIHhEhd7y+/utskp9F9kT6V5Zk9YLhd+qfCLlxbw7T7fGxZxHNBcmkbrBlVkSK0SIhiRQ
	MoS1mhyHwOEbGUsZbi3Pk15FyXB1nU0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWKDEaWg;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715044;
	b=etLkPmyV7aJUz8Lc70ZJ5elrsPv+B8pZra6QF6TBBnFkr8wu7ErWSV9JmX36kMCDpwMiaZ
	L9K3aoUVCl8TVn/Hz1EfQcxmehf3TskihoknoqJAU40Uj+Oc7Oo//89FWBiOmdo3n0Hjst
	U/wa2509bWbIPiDq/aamLtvVGj2JsAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0D1941842;
	Fri, 18 Sep 2026 07:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136851F000FF;
	Fri, 18 Sep 2026 07:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715043;
	bh=C99qchwVmIf8eGzA2KZRAlNCqTMDn2E/1eNOjto5V1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jWKDEaWgQ8tOV8amlp5t9MgYwzBijBFVifWz9yuQo8X4L5EFh32Flzu4XXAbDfnGm
	 UDL93p7kB9G3Rd42nYwUtj6uT0m3roRBv2y8vs/mC/hhbavAalLWNzIamZ9CawgJa5
	 pHnOvDOLIlc6CP9lOwT216XgLvfodA7hkiX+FB/0Ct+bfDmyj/AqncmimtUagrt8Eb
	 oF0sbTAHHKTDObi0AO6aHDc2FHQ2Fy45mE5vliTDkO5ZU6YC6Yt14abrG5j+Mj0rNr
	 Yjv8AMXd9/oiS5ceTffHmQV+p3xP+CkZLZuUIpC2CQ619hXKr9pxjr41fijo1ig8F1
	 DgCMlNLI1L+8Q==
Message-ID: <24aedc8c-a5c6-418b-a37e-051f0d6d9fa7@kernel.org>
Date: Fri, 18 Sep 2026 09:03:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
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
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com>
 <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
 <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
 <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
 <2462f67c-f7d3-4eb3-a093-6a338ef49f14@kernel.org>
 <CAGsJ_4zMG6v-ioi8-NhveqowPVAnsHkFCNy_c7+KHDMRW3JH-Q@mail.gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <CAGsJ_4zMG6v-ioi8-NhveqowPVAnsHkFCNy_c7+KHDMRW3JH-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bn71dobmpd46bbwkbedbyn8sxxyjz4r3
X-Rspamd-Queue-Id: 9B5B21C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789715044-300510
X-HE-Meta: U2FsdGVkX18Ks8B7zplbKYxXjvN1UVtrBSrWp2a7M/maldzLgooN2mhJBq1e0FUEW2t/ll+DxciSSA9oHjIhAlm4u/X92brGDFAhCB1EO9nCXJCr92eaMcz8gxu0bVbtG2xtO/d5ZrcXAwl0QHgvhdShF3Cxr0wb59pDTISGL2HTR0D6Wa6gp76yl1E0rQg8utiQorqJhxGaRJAel1Gz05tTy2sR63dSbjdD5teK2ZsTujXPLBEFJZwNsxjUpnlcfkpZGEB+K1ur23UHTtUJjh+/GWjoacbaDDmdYOUzBoDVz8KZPBAUll3oSok+58zE/3s0Zun+eOsoyzDmrH6gD6saNwDQHl/r1x3bfKk/xTsv9jxowNRJI0toMViQJwOkqNat5jJeVHQW37+LjoRg0VZnQlpAgsU2i0tcYEgMp8WkoiZWYGSU0KJSc6/qTVr2G+94tgPDqYfyQKgdpnOgIL2K0c1nrbKE1J/eQR85Nk57D896/h2QhzcdLqourd6BjHX2sgjFnVBjeoW2U5dSSsy7Q/8E9Y60wgsMz///LU93ASRzZTirSWmBuc3kzwQnWSsy12wA+lwYFtTP8sIhTqmc10tEMb4A5l0dh1p2jP1jPSAqVkzloH5wBQNYOW7V8X2r/IxDEe8LK9dUd0G9mbhNq3GsHEgz5qQeIlIHkZo72BWle3VMT54la24Qk/L/Q72PCgwj1fbCLdX/qBH/4neOYNSotUGEAa5Gm+5HqArRSlGRkoO8hblHG4xpqfun1WXgGV6AMtrX6Xt3P+cAPZW8kXr7c3kFeLUBKwCDjEYqBhxFPSv4z9KGFZ2AeppMhgym1N3dOB9daJJqHb8kH65sAfiN9rud9ZfC22s/I3da4vp0QEZ5iYng1xh2/UIFQ3J3CmIyphFEqVUVbACfMtINDdsVmwqpgTcQc4gIrHuneCHpdOk6vmCw0N7m2dewNH4w1ZKnEiqhUZrnB7Y
 j/jr0Z20
 7G+WkmF/DzGahG5n/TGL7WwUsjn0wfuLo6weliMtbCmqZiW3sT0nevtMpgmuMA1GqB5R0nmuDwvsvCcMIou8b//Vf1POgmtg9LwmclPKwWKh572J3ZOvqJG7UPsuIvunWff/yrJRkvrU0TqE7JR87AzjSsEBJASpDMO9niPCXzl4ievtfnW4mkM79d/q/8mbiHzlwQQw/gS5bsKP62AEopvDczcvuJ11QWlbWjXbW17CRLV5W9jnevugheAOqph/cSQgiognwKsN27OioKl9z7Y67FH6yCt+rH/I8x8g/H6dDn5TJbLuPoosib0y6SWkxnLIDyHRC4l7z5eqccC9lVtTnJadKjgByp/Fd1/hrD/eeLl8Vb7H95+ixfclV174DEYJfBcFapSJd27kx8+krpxuSRqRDYqbf5OeBwGutqm6SA4YD2Nyb1eONPhfk8PQVJS6deTdY2ggGWmdxi3kvdSCvEx7NLGGJZVpH+RL4VvIntHuLQZrfVuP8akM/bc/e0r1S88FKoeuo61in6FSYUwYPhxjxYgnHDTlpNBuTQx66+1SgCDKK6qe4X9S+C+y7zzZyts7XAKX5VPKcSWXOzVCTtq2cWwMd+tJ6DP5dF4bY0o0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 18/09/2026 à 08:14, Barry Song a écrit :
> On Fri, Sep 18, 2026 at 2:05 PM Christophe Leroy (CS GROUP)
> <chleroy@kernel.org> wrote:
>>
>>
>>
>> Le 17/09/2026 à 23:44, Barry Song a écrit :
>>> On Thu, Sep 17, 2026 at 10:41 PM Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> [...]
> 
>>>>>>
>>>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>>>> index cdd68ed3ae1a9..349ced999f959 100644
>>>>>> --- a/include/linux/pgtable.h
>>>>>> +++ b/include/linux/pgtable.h
>>>>>> @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
>>>>>>     }
>>>>>>     #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
>>>>>>
>>>>>> +/*
>>>>>> + * PTE-level block mappings for vmap.
>>>>>> + *
>>>>>> + * pte_set_huge() only has to be implemented by architectures whose
>>>>>> + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
>>>>>> + */
>>>>>> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
>>>>>> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
>>>>>> +                             phys_addr_t phys, pgprot_t prot,
>>>>>> +                             unsigned long size)
>>>>>> +{
>>>>>> +     WARN_ON_ONCE(1);
>>>>>
>>>>> BUILD_BUG_ON() would be better here.
>>>>>
>>>>> It should be possible because fallback arch_vmap_pte_range_map_size()
>>>>> will constant-fold PAGE_SIZE so pte_set_huge() will never be called.
>>>>>
>>>>
>>>> Agreed. These fallbacks exist only to keep the build working on
>>>> architectures with PTE-level block mappings and should never actually
>>>> be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.
>>>>
>>>
>>> I am not quite sure. It won't be called at runtime because
>>> `vmap size`/`unmap size` return `PAGE_SIZE`, so the code won't
>>> reach this branch. But it will still be built.
>>
>> The fallbacks are defined as:
>>
>> #ifndef arch_vmap_pte_range_map_size
>> static inline unsigned long arch_vmap_pte_range_map_size(unsigned long
>> addr, unsigned long end,
>>                                                           u64 pfn, unsigned int max_page_shift)
>> {
>>          return PAGE_SIZE;
>> }
>> #endif
>>
>> #ifndef arch_vmap_pte_range_unmap_size
>> static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned long
>> addr,
>>                                                             pte_t *ptep)
>> {
>>          return PAGE_SIZE;
>> }
>> #endif
>>
>> Therefore in:
>>
>>                   size = arch_vmap_pte_range_unmap_size(addr, pte);
>>                   if (size != PAGE_SIZE) {
>>
>> GCC knows 'size' is const and its value is PAGE_SIZE, so it won't emit
>> the branch at all.
>>
>> It is call constant folding, some explanation here:
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FConstant_folding&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C869dac21f28d45988a3d08df154c225a%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639253088878897551%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=Dvtz1%2FAHvAbVYO%2BRaHTOizcD%2FclJ9FqTcWXKMhIFVyw%3D&reserved=0
>>
>>>
>>> So, would a `BUILD_BUG_ON()` trigger a build failure here?
>>
>> It shouldn't, if it does it is a compiled bug or this is because someone
>> has redefined arch_vmap_pte_range_map_size() and not pte_set_huge()
>> which we'd better know at build time rather than at runtime.
> 
> Thanks, Christophe. I was also thinking about compiler optimization. I
> was just a bit worried that we're touching the common MM code, which
> affects almost all architectures, so I'm not quite sure whether this is
> supported by all GCC versions used by those architectures.
> 
> If it is supported by all of them, I agree that `BUILD_BUG_ON()` is a
> perfect approach.

AFAIU this is the assumption made by the kernel, see 
https://docs.kernel.org/process/coding-style.html#conditional-compilation

This is the same compiler, I see no reason why ability to constant-fold 
would be dependant on architecture.

Christophe

