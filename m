Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9B0FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C106B0005; Wed, 29 Apr 2026 02:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D376B008A; Wed, 29 Apr 2026 02:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B926B008C; Wed, 29 Apr 2026 02:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 429606B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:13:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C056D402C7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:13:02 +0000 (UTC)
X-FDA: 84710575404.09.E60A69C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D61454000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:13:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uUr3y9ph;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777443181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CKeFIhbxyLN1HmhgD0lGku0qszHyE0iHhGb06/UsXQ=;
	b=8Rp/vak/Kx/pMrqNVG77CmSgXu1ovxyO4HldDaFvM3KfcdbZKed9R9/fwGCOGZC+umVkgm
	xtRtJBsdlSzJStG+LZncvYUWwlnBHop2PDusw3wmB6yYFu88I6WDlqeOlU6D/x1A/q/Y9S
	qhfZh/9r1Y++3++nF6X8S/XhnlJkJvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777443181; a=rsa-sha256;
	cv=none;
	b=5E+ctwvnOjxxHQIrsyYkfdaqxK9AmUGEzd7OQpHrdxWusSiQXrMcTdkETb9UR8pfNgkat5
	wmRilHwOPkvoPEuVc++BSZDK4I4Xz5a1gEiMbuWXx+QKvQ1G2CM7T4jkVos/OA5D0JoeIY
	M9q5hT+pqaSfFiTm/oUtf7EoWYtxHM0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uUr3y9ph;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6556438B2;
	Wed, 29 Apr 2026 06:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AD8C19425;
	Wed, 29 Apr 2026 06:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777443179;
	bh=xZa8k9fky7Ud+r6bs3yOKVp9CCZDmGO9fFO4lmRkXtg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uUr3y9phDo822hbAIS7QxCaW0+64MhkDdMXRtC2QnDwcw7VR21QwVcXF/3vyRk/UW
	 k2vBpNMjbaCHvK9MjLiC6dAWWoD53uocTMzq4fln3zAbX4lPKc/eRY9sNjp/CNK3Ua
	 KeXUzf4HdDHWIrADViwyQar8ZYOhX4ilPBmayvVlW5XVWvQTgH1tPSwY8PE7YHV0F3
	 6tjYmvXq5kiMqHlUOC1OzrrAbXrqB4jRAX3tsJoemB69wKewgfMlZbSJAAgRje4+sw
	 Xt2OTYLGvj1Z77PXZS8ZwEQDQfZzkXfu4ExbROgaO3fIGZ33I8GxNT8ko5NSMfeJ4A
	 Gb3+ovAjIXsag==
Message-ID: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
Date: Wed, 29 Apr 2026 08:12:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
To: Lance Yang <lance.yang@linux.dev>, hughd@google.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com,
 zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com,
 ziy@nvidia.com, linux-mm@kvack.org
References: <74a75b59-2e13-3985-ee99-d5521f39df2a@google.com>
 <20260429055447.9220-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429055447.9220-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D61454000D
X-Stat-Signature: haah8eruacbd33d8cjo5q5xaczbm3qb5
X-Rspam-User: 
X-HE-Tag: 1777443180-467839
X-HE-Meta: U2FsdGVkX19E78dIa4gZ07kMs4np5ayOnpKKaMfwYZt2XNPYnGGnzKrvYViAZm8+8xgXqdhkqbl1kyeCVXkbnlFaPuWIX0T17VnVdiycWnd9EskK1xwCZXgdPDvyDY3lGNve1TeeMuiVMV6m/89om4CKQ6/rotVGXbT74TPrMdGTTDlYa4Use7YNm3BZUtXIkItJZ2laAh8Y4THw/Ixd3bQEYPpFLat7295dGnTaBgIBDyurM/e1HJb4BdhPq0XBfD+rK8uXdPE6DiYqwsk/hvYdFMcckj00LSfWHo9AgRjYTjgMT6JaRpSABVrb99REgjH4AEGO8HYfgjyIl1eZnm1MtljPwch6wB/MZwzG6F6ikLSn/xL/PYBUt2p9c2iI0l6cd9p/CUqofajTo6RmyqhgzeqQfS8QcduFD1jt5z/2Vtab2OTWSOXJn7lGPQ47ihu/tO/T0vJo31wFmcNj7yQg5irIb/ksHwJoYnBHasvzHSxRQuktLIutDAvIKNFe+4XpakxBI1652lXawl3+lieHyOi2+PTl5LbJskwgkhetWrq+FHCBg4UAI9epuAMULDGfPWZpzx/QLyqdHlrZQSop1h3vrLAN88hVliXUB7z8vZz3znxJ7DLJERv1AFAtI6pe+iWL7kxaxozRtVOjCuIVOqEMQXmOxLG/ajT+Rklg7JZQNYwQGoQ/W0afMqE6QtwC4XDs3x4mwGFB/KDJJhSfEqqxIMNGvgsy2KDZSce6CGascPO2JC9/3yUou1f4EkLWudunJP0QwYfozf6RhAc20G7eB0zCF8xvBerdD619jY0yPhxNxGrzLDk1GhIOEsXXdaXb8s1RUD6faQHvtPChb5RvyhLI9cBgk5RN9MlIZ6KVtfs9jBlQfGKt2zOcte5/tdACoYBim5iRtQstsvNLlhSjPdmtfBj/DUAOrJf25Xm+HcruWdJJY+LIQ4raxovdZyJt3R7uXUThLvq
 NVzss8v6
 GQKd6eroQr6KKG9zid9Et6Pnm8+qKSzjcyimuBk3qoTHa0TDWQ3cywH/npZ2WYgQYD3CV3nhM0lgxVOJ45tJfNLNOCRPrgCQ2uOJkBjQsxOW3GwY+WZ/NG2zU/J+668FGsHHuVqVKIO7RX3cHlXR6L+jBU3phCemfZRAR/ZvQQ9y8LYCIifbWhe9H8TqZM9uG6Hl++ebiXPN+NkYeYpqAi6FQz2vzDEcqdoh1ajTRxmxKytOea1EaCPOr2n8tSmZkz/9KZtgKv9l1VXSBdkuyM9nh9sPrIdaxN7LCcRYkSZXTkEMn1lvYZB6dCWrSzMZ8N/xs/NFB+4h4fOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 07:54, Lance Yang wrote:
> 
> On Tue, Apr 28, 2026 at 10:08:37PM -0700, Hugh Dickins wrote:
>> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
>> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
>> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
>> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
>> when reclaim gets to call shrink_huge_zero_folio_scan().
> 
> Good catch!
> 
>> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
>> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
>> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
>> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
>> on any 32-bit architecture.
>>
>> Add CONFIG_ARCH_HAS_PMD_SPECIAL?  Perhaps; but I think it's better just
>> to observe the huge_zero pmd in the fallback version of pmd_special().
>>
>> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")

Likely it should be

	Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")

Because vm_normal_page_pmd() would return the wrong thing.

But I am surprised that we didn't run into the

	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));

earlier. 	

>> Signed-off-by: Hugh Dickins <hughd@google.com>
>> ---
>> include/linux/mm.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 0b776907152e..3b02ac43bcb7 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3422,7 +3422,7 @@ static inline pte_t pte_mkspecial(pte_t pte)
>> #ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>> static inline bool pmd_special(pmd_t pmd)
>> {
>> -	return false;
>> +	return is_huge_zero_pmd(pmd);
>> }
> 
> Emm ... feels a bit odd to me ...

Agreed. But it could be a temporary fix until we fixed up relevant architectures.

> 
> On these configs pmd_mkspecial() is still a no-op, so pmd_special()
> would no longer really mean that the PMD was made special :)
> 
> Could we handle the huge zero PMD in vm_normal_page_pmd() instead?

That adds unnecessary checks for architectures that properly implement pmd_special.

pmd_special() should be fixed longterm on architectures that support THP
and CONFIG_ARCH_HAS_PTE_SPECIAL. It should not be glued to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP.


arch/arc/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARC_MMU_V4
arch/arm/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
arch/arm64/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE
arch/loongarch/Kconfig: select HAVE_ARCH_TRANSPARENT_HUGEPAGE
arch/mips/Kconfig:      select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
arch/powerpc/platforms/Kconfig.cputype:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
arch/riscv/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT && MMU
arch/s390/Kconfig:      select HAVE_ARCH_TRANSPARENT_HUGEPAGE
arch/sparc/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE
arch/x86/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE

arch/arc/Kconfig:       select ARCH_HAS_PTE_SPECIAL
arch/arm/Kconfig:       select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
arch/arm64/Kconfig:     select ARCH_HAS_PTE_SPECIAL
arch/loongarch/Kconfig: select ARCH_HAS_PTE_SPECIAL
arch/mips/Kconfig:      select ARCH_HAS_PTE_SPECIAL if !(32BIT && CPU_HAS_RIXI)
arch/parisc/Kconfig:    select ARCH_HAS_PTE_SPECIAL
arch/powerpc/Kconfig:   select ARCH_HAS_PTE_SPECIAL
arch/riscv/Kconfig:     select ARCH_HAS_PTE_SPECIAL
arch/s390/Kconfig:      select ARCH_HAS_PTE_SPECIAL
arch/sh/Kconfig:        select ARCH_HAS_PTE_SPECIAL
arch/sparc/Kconfig:     select ARCH_HAS_PTE_SPECIAL
arch/x86/Kconfig:       select ARCH_HAS_PTE_SPECIAL

That's a bit of work given that only arm64, powerpc (64), riscv and x86 (64)
properly implement pmd_special().


So I think Hugh's patch here makes sense for now.

-- 
Cheers,

David

