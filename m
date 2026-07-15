Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A44E8C4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90ECE6B0088; Tue, 14 Jul 2026 23:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6A46B0098; Tue, 14 Jul 2026 23:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D58B6B009B; Tue, 14 Jul 2026 23:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4386B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:31:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2698A05C2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:31:49 +0000 (UTC)
X-FDA: 84989586738.01.DE3190C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7DB61160002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:31:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="rQ4i2MP/";
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784086308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAlT/hdiMjcuftcBzs39fQKwgSfOlubr11BXpOQZe60=;
	b=wMKLJ24/YpqOZ8ST3Tza5JmIZ599aVVcUCt79qg09mZj0hyspmxWF6igiqSc/R7CJSUH9v
	F8xizHLLk51T3vTHEZ8dDMN1S9NkfTaQhaRn+tehlIGGtOInLhASp14OVa9xMdwi6VU1xk
	xlDU12j+X4b7otvNFv+mbid/o6xEm2k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="rQ4i2MP/";
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784086308;
	b=7v9eorN+0E0uuH/0ASEbECNs0Co5mcG1HYqY2bZywg31bgIELroijhmni7okUVb3QLPqQ2
	3zbqlI/KlsbKBiqGf8q+VwZgzErJp+8ykZ5pCQOX2NGU0XBuoAmh1N6cLqjxV39Ugt5VyV
	YPH2gaTeUev0JM5I1Wk6EITwNwN6Lxk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDC96339;
	Tue, 14 Jul 2026 20:31:41 -0700 (PDT)
Received: from [10.164.18.40] (unknown [10.164.18.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E47B03F915;
	Tue, 14 Jul 2026 20:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784086306; bh=eLKwuGJoJsIHeWJ4YMqsFz5ZrWo7Q9PIiUGspHsiu5s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rQ4i2MP/E8rGhbitmZxBMF/eBICIDl4M9VpN0LVW/s45WpNvdHjMQvfUFGYkVZKLC
	 K6dRT3KTvI9iWA+dVcIejo09e7sjeTMQUeQphJtTliE0mP9yWN86gGssY2NprEypZ+
	 7PcsDpK5swHcKJJJXdkFPTHN+fe2i0JNkVH6l2lA=
Message-ID: <71e8601c-ce7e-4a4e-aa0e-66c9f2a5c9b5@arm.com>
Date: Wed, 15 Jul 2026 09:01:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, "Barry Song (Xiaomi)" <baohua@kernel.org>,
 Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-3-jiangwen6@xiaomi.com>
 <bc4ab9da-0b16-4203-9901-4845323c3e5c@arm.com>
 <CAHKocdFn9DP=wGLYJrhndxTnxz=eMeWYjK1m2OzPotcvz_sVjA@mail.gmail.com>
 <CAHKocdEOveLGiad3pOFMNGEKec-wvnwY7w88-8k1Npm1t_YTcA@mail.gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <CAHKocdEOveLGiad3pOFMNGEKec-wvnwY7w88-8k1Npm1t_YTcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: etyzxz4xarnq7bbanqfurt13fs74kprw
X-Rspamd-Queue-Id: 7DB61160002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784086307-231304
X-HE-Meta: U2FsdGVkX19VgYl7UWX40Ef8Kua5Kk2rZ5o6YL/M9c5JQ7e/rVrCAQU7csUUTyGPy8dDK6WgDoY+xAuJgmQLAwhZRiec3C0WeGQew72PBd0czOe5UKlkYbkkJpfNmql0rjmSKXDC+y7gIYCy6kmGwXe+95KuYB66QaMvlx1wz/X70hCzeESZUUN8uJtdKA02L4+y8MFtsenWuMnORr7vN+t8UvQvA7LbieyV1WNl1d+Xr2uWSOKcYYFGFDRI9yR20orTIC4CWQntb5uXGTjKp1420mKROR3SuMpGj2n86FCA74I0D/KTkfZSaCkj+Z4LRHUFE/c+1bXR+22GiMn9r+9fwQwQKMVlkg61jPt2JBt6GOseUmczro9ssb3NjMH+40UUqGz3GtY51xduwHVQS0Y7SKmHR+i3yG2zWdAyZuTQXRk3UZnO9kksQeyuxsEL/NJkG7m1IBxmOKgZLS5+VGB2hife2+b+kqStcTmRn+b+WuC95ERjYqgsQDc7RAKJi4tH7onSCInBU4RP+AbWP4s58VmVUxGXGrJtIk4Cwb422MhlFg2O86GZ1X4pvnxR/lFmNgEViZJ3Ym7EPc6+nm/oqxH3rSxdRPcbagrmoPqNUl5RfEEYk96+D4N0bRnqXOP41IA0ES2k8zFmUeLYtIBQmBYqCWVwgtI3B4/dZRhH90G3NRwf2I1aSL9nu6CGXyG4pDGABspIDG0b1uNgPDPSDCL6LZjDJq1fL4yQA7oKZLuZnRyfGnnqpEXbb8Rj/QLbGgv7FzfgeSDu2QON2E248qzsiRcGedTpl3Py2teLqLb1/TeRUJOFKEoG8lQIADRElcH56v+BA7/en0ah3VKIonsOSAEB1Ydrm+5Nyeby8nbrqEQcAgsZ/PsWYztVYb7cVyrZuTMJImry4Nivlw6evr8hd9K4Ikn6wTEbG2dB+fWvD9g3SorzdR7notTYUEJFpQqenm7EniY7Ayk
 mHlrHZWQ
 BatQa3xaAxk3ezJ9LD7NBTF18W05eAKL6NwtTtyfxE0qdoWVYphPvZ2sU3H0TCfB7lRxsByndLXh2mHYil+f5ih72NBejGUCmDxYgEco/J5c1prUuQJYWsdEeSSBw8IWk7TYa3nVn3CZrYuHq6ADBefjmyLeP5mk6WABiGrPWhCQwHekRcFvvx+93uGgQFdur5VUvDhSOadbCtBrHtqTOLIXWVMbwyl02ghWra9Y5LRP1tkee3JQKh7E4rd8c122jvzGY3uO2/9aZ+u+tAH/jf5wz7LtVhaDxtjAL0wkxP06lKVTKxUBLkBx/LS/9j7pKwvU7CBq4JqljFiYP+Lx/vOSGKoxfqslz3crCvRO0jWiHEJQSMlLTOa1nPyyuKD676MBbx6sa6sIs3Ql0wwg6RE9E/qoeHlHQ2eBYYsG7op3dEXZWe0AvFszzsmV4LRN2XrQUpyeAIODf9n7R7PP/uZCTctUycF8DcejeXp132soatOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/07/26 8:19 AM, Wen Jiang wrote:
> On Tue, 14 Jul 2026 at 17:24, Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>
>> On Tue, 14 Jul 2026 at 15:13, Anshuman Khandual
>> <anshuman.khandual@arm.com> wrote:
>>>
>>>
>>>
>>> On 09/07/26 1:08 PM, Wen Jiang wrote:
>>>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>>>
>>>> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
>>>> blocks, reducing both PTE setup and TLB flush iterations.
>>>
>>> Too little commit description for the proposed change here.
>>>>
>>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>>> Tested-by: Leo Yan <leo.yan@arm.com>
>>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/vmalloc.h | 6 +++++-
>>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
>>>> index 4ec1acd3c1b34..7d9c7dc795c42 100644
>>>> --- a/arch/arm64/include/asm/vmalloc.h
>>>> +++ b/arch/arm64/include/asm/vmalloc.h
>>>> @@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>>>>                                               unsigned long end, u64 pfn,
>>>>                                               unsigned int max_page_shift)
>>>>  {
>>>> +     unsigned long size;
>>>> +
>>>>       /*
>>>>        * If the block is at least CONT_PTE_SIZE in size, and is naturally
>>>>        * aligned in both virtual and physical space, then we can pte-map the
>>>> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>>>>       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>>>>               return PAGE_SIZE;
>>>>
>>>> -     return CONT_PTE_SIZE;
>>>> +     size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
>>>> +     size = rounddown_pow_of_two(size);
>>>> +     return size;
>>>
>>> Please do explain the fact in a comment that huge pte mappings
>>> upto PMD_SIZE are being allowed here, if the given block is
>>> CONT_PTE_SIZE aligned.
>>>
> 
> Hi Anshuman,
> 
> Would the following comment address your concern?
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -29,6 +29,8 @@ static inline unsigned long
> arch_vmap_pte_range_map_size(unsigned long addr,
>   * If the block is at least CONT_PTE_SIZE in size, and is naturally
>   * aligned in both virtual and physical space, then we can pte-map the
>   * block using the PTE_CONT bit for more efficient use of the TLB.
> + * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
> + * capped below PMD_SIZE.

Yes sounds good.
>   */
>   if (max_page_shift < CONT_PTE_SHIFT)
>   return PAGE_SIZE;
> 
>>> IIUC arch_vmap_pte_range_map_size() gets used only when config
>>> CONFIG_HUGETLB_PAGE is enabled. Hence should not these new huge
>>> sizes being supported here also be added as valid HugeTLB sizes
>>> thus updating __hugetlb_valid_size() and adding corresponding
>>> new HugeTLB page sizes with hugetlb_add_hstate() ?
>>>
>>> OR could arch_vmap_pte_range_map_size() and set_huge_pte_at()
>>> can be updated for vmalloc without doing corresponding changes
>>> into HugeTLB itself ?
>>
>> These sizes are not new HugeTLB page sizes. They are only vmalloc mapping
>> spans selected for a particular virtually and physically aligned range, so that
>> the PTEs can be installed with the contiguous bit in larger batches.
>>
>> Therefore I do not think they should be added to __hugetlb_valid_size() or
>> registered with hugetlb_add_hstate(). Those describe the HugeTLB hstate sizes,
>> while this change only affects how vmalloc chooses the PTE-level mapping span.
>>
>> Thanks,
>> Wen
>>>>  }
>>>>
>>>>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
>>>


