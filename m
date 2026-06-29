Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A377FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DF66B0092; Mon, 29 Jun 2026 04:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8069E6B0093; Mon, 29 Jun 2026 04:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5086B0095; Mon, 29 Jun 2026 04:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F49D6B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:23:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F5141C36A6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:23:12 +0000 (UTC)
X-FDA: 84932260224.30.5F97812
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 240D5A0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:23:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ev1aNmXq;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782721391;
	b=x4Ki5TSv81aAdefP901NRWVDJi9tZGGhvfFSzHoK1AT9NLGK6hwifz+6egtSv8cNnzP0yz
	Ah0uGxs7KJ7AE8w9t2CFXCBPkbYfrnljad8dSqVjpBWcwlaRM+Wn79WtP+87ErDsUWtrSm
	U+VwPoLqMW3L5+TLb2wBLukuVVytWtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782721391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFxUO7tgIcr0aaRoeEv4WTyZn0JslVlD209KcTGHDqc=;
	b=QyK8JzHatEVIdGPCUWBPCSvihmUR8oMJoSLzXEWg0PulrdMKFh03i1OKZfaB9Ci/slm2AU
	20zPIyULWyUyvubGUJsAjW2trE376RYGjvXF8OOr/QURdDoebxjBrllolG1vp9lUfwb8EF
	Y1ZE2t+tErdRZ6+FE0Gmh/Zvtl+mseo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ev1aNmXq;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <458f63e2-6ee4-44c7-a230-636e1927f857@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782721385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hFxUO7tgIcr0aaRoeEv4WTyZn0JslVlD209KcTGHDqc=;
	b=ev1aNmXq7ogiDIfLA6fwdm8/E4svVMoXrQk1fT8rGFz3UmiKKzsl/hv4jM6VSXvdeRIXSY
	+hGUGRGHVpH/oq+1s7hpJexHb9LmvsPTB68wx+kCIH4MG4qC7Bk/doclxFP0JZyxlaaHbm
	u4aXlpHb3wvosR2bMj24RfY4WpKOuaI=
Date: Mon, 29 Jun 2026 16:22:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>, dev.jain@arm.com
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
 <20260629074802.42727-1-lance.yang@linux.dev>
 <a1c6c3dd-8db1-4db6-b032-e350bacc4577@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a1c6c3dd-8db1-4db6-b032-e350bacc4577@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 240D5A0002
X-Rspam-User: 
X-Stat-Signature: ek48odbehrbihqndtccb749huwqeoyqr
X-HE-Tag: 1782721389-284713
X-HE-Meta: U2FsdGVkX1/c0U6yUEAaBn/anUEoTvq+HKOsqsnTZ61KmSWXGhPAd5/z3hIMKxb+rmQa4DC06LHkMFtGjmrayKJoP/c3bDa27CXX24TiTMet1jYFUN61+mr8t//QMg4XDJSjPrV9s1+IP37xaZOOi6acmvvizKWt2kVodupQy9ZJk3obZnU4dveQtw2jlH/yrUob/Z/lPrDGJ3FGv5z2oU9pzjIp2eYuDJEhjR9JbG0IjIWIhvHS/23S1EecMDTb/N7JAcAx5zRRz9dffesJ182wMT/BrkF3lzRP3LXxCMxW3CtaNq8eegP1rqN2Wr/MoxDpEcWtOwLuJ9DtpsO3C3eamhgKB11ytZvguCPf93bwInY+aQFJLOB970i4bbmyozlzhMnSjZTCRy472s+ADaaQjnq0Eo6jOsZ+RwUpek70xv6cu6wITkXY7nOtCiUNZ1NbMfoWfJcTIbh5247FMQhTE1M5RnxQ41RJtOjSfd7qEkdp7R8eYRv5AjxUr7jl+ljss99nGXBwYAwQ/6yBmDmvxwXT5EjZDL/0r3xfH6iDnLLwrmGDXFYx3qZ+mZIa804fANkrbCNv+fhEf4LwQ0OdXWqGzTzj2h2xqwEvYXSigmw933Z6YJssHGrMc4Z4Ghdbl1RGrDX+PT/yDhlrsAK5NDVlpObK08CYKPxc+mZHU21DoACyFoZE4hn6oRPPZET0V/+1vkZYCd9Eqg/lLXIRjIxCm4BlxYM5tzGS7DsRXyEhk7yfXLTG4L4uWrwXkTEbddEUg3Fw3W0oc3E/mFvP64hzXktwdnEMUonsga+xP/ivO8hHxDIbY9TT86FtiLwQkXfBFD7CZi18L8grCmFiA+s3PhUrXl/GakyqNcEp0BKP3x8hEZzq7eXWn0krEUUAn4jGo9uuUKz2A2O6zAK/YuOOmd/OEPgPXpha/mFA1FfKOBM65Ar2lMPQDy9WMCRitUWrEFhpnBfxg95
 W56mL5yM
 AQms3zSpt7i/y90kBUhS0X0rw31uGxajHha83TtVGc5aNb7LeSx22CJfdkG/qfFxH99XvXCms4Xa9mKI62SxM+X2/E1+H2gko38dKKhsLDalx1I7maVWl4Qk/3ZXgU2DJybwuMTG0UgKw258u+G/jp7sP41jFBslCtz5eCJw/ieVmFqQPJEdbApzagpFIbK4dWsMP+pWCQe79Gdj41AenNgNxti+RpMzi07LOZ1nFVkoZ4RHQ+LQ1PS3eoU5o9VLh0ruP1b+6T0W5c0ghCZzYaSz+2Qq553g42N470tLS/dD+LW7tvWH3qVpkXhgCRZr5xa1BbwFsKepIHgC+ALNARBJxJ5f5r6KeeWYWB74moLAJGpcqpJhOIA/KyZ2SpURMFCvwNhTThY4vuFHPnmhGDLSNc7NlcR0WZBMa3uvcQcyleJkC0Tuo5mKW1+3GZHeiqNc/XLFvAXpGFoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/29 16:05, David Hildenbrand (Arm) wrote:
> On 6/29/26 09:48, Lance Yang wrote:
>>
>> On Mon, Jun 29, 2026 at 09:25:48AM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/29/26 08:48, Dev Jain wrote:
>>>>
>>>>
>>>>
>>>> Sashiko notes other places:
>>>>
>>>> https://sashiko.dev/#/patchset/20260625112955.3254283-1-dev.jain%40arm.com
>>>
>>> Yeah, that looks shaky. We do seem to have a bunch of these cases, primarily
>> >from pagewalk code (where some users like pagemap need the actual address).
>>
>> Indeed ...
>>
>>> I think we have two options
>>>
>>> 1) To prevent any (further) issues, make huge_ptep_get() always consume the
>>> hstate, and let the arch code deal with aligning it. Invasive.
>>
>> Kinda lean toward option 1, even if it's more invasive. If we pass the
>> hstate down, each arch can figure out the right addr from there.
>>
>>> 2) Make the arch code handle aligning without the hstate.
>>>
>>> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>>> index 30772a909aea3..303a1b74796c9 100644
>>> --- a/arch/arm64/mm/hugetlbpage.c
>>> +++ b/arch/arm64/mm/hugetlbpage.c
>>> @@ -126,6 +126,9 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>>                 return orig_pte;
>>>
>>>         ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>> +       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * ncontig);
>>> +       orig_pte = __ptep_get(ptep);
>>> +
>>>         for (i = 0; i < ncontig; i++, ptep++) {
>>>                 pte_t pte = __ptep_get(ptep);
>>>
>>> (nshift/order instead of ncontig might avoid a multiplication, but not sure if that matters in practice)
>>>
>>> IIUC, that's similar to what huge_ptep_get() does on ppc.
>>>
>>>
>>> static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>> {
>>> 	if (ptep_is_8m_pmdp(mm, addr, ptep))
>>> 		ptep = pte_offset_kernel((pmd_t *)ptep, ALIGN_DOWN(addr, SZ_8M));
>>> 	return ptep_get(ptep);
>>> }
>>>
>>> I'd assume we could do the same on riscv. Besides that, I don't think any arch has cont
>>> entries.
>>
>> AFAICT, for huge_ptep_get() the addr users are arm64 and powerpc, riscv
>> doesn't really care about addr there. Looks mostly arm64-specific ...
> powerpc handles it correctly in the weird "span two PMD entries" case by
> aligning the PMD down.
> 
> Risc-v copied from arm64, but can simply derive the #entries from the PTE value.
> it doesn't have to re-walk the table using the address.

Yeah, fair enough, thanks for spelling that out!

> But I think the following is required to fix, no?
> 
> diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
> index a6d217112cf46..7e25cc13b3dba 100644
> --- a/arch/riscv/mm/hugetlbpage.c
> +++ b/arch/riscv/mm/hugetlbpage.c
> @@ -5,6 +5,7 @@
>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
>   pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>   {
> -       unsigned long pte_num;
> +       unsigned long pte_num, pte_order;
>          int i;
>          pte_t orig_pte = ptep_get(ptep);
> @@ -12,7 +13,11 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
> pte_t *ptep)
>          if (!pte_present(orig_pte) || !pte_napot(orig_pte))
>                  return orig_pte;
> 
> -       pte_num = napot_pte_num(napot_cont_order(orig_pte));
> +       pte_order = napot_cont_order(orig_pte);
> +       pte_num = napot_pte_num(pte_order);
> +
> +       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) << pte_order);
> +       orig_pte = ptep_get(ptep);
> 
>          for (i = 0; i < pte_num; i++, ptep++) {
>                  pte_t pte = ptep_get(ptep);
> 
> 
> 
> I'd prefer (2) as a simple stable fix first.

Right. I'm good with (2) as the stable fix first :)

Still pretty new to arch code, but happy to stare at it some more.

> If we do (1) on top, huge_ptep_get() on arm64 could stop walking the page table
> another time.
> 
> If we pass the hstate (or vma) to set_huge_pte_at(), huge_pte_clear(),
> huge_ptep_get_and_clear(), we could likely get rid of the re-walk in
> num_contig_ptes() entirely and possibly just remove it.
> 
> That would probably be cleanest.

Agreed!

