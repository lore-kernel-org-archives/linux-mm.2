Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F94CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC828E0006; Wed,  1 Oct 2025 06:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DA68E0002; Wed,  1 Oct 2025 06:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583048E0006; Wed,  1 Oct 2025 06:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44C338E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:06:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAA3111B130
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:06:20 +0000 (UTC)
X-FDA: 83949115320.16.DE4B68F
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC4F320011
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:06:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NP+oJT9X;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759313179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=393rN1ZpjbBC/kxJBIELF7diTurMQySclAxKyAjIUr4=;
	b=Hfwk3ZvHCaH+MOfB17aqX7npvByzVw7R52pgQR/wfqzrDzUepq3sHE/KVvTpIPgF8ErnDu
	R6o9GgOnCRTAzz5Txs4UXJ9QsKIFD7a7aD+tYH+Qqq8Iiv5ffbtyDFQRP1ZSd1zE1Ma5Sm
	6KBKUQCIt603iMhyCj61E7dATTnIo1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759313179; a=rsa-sha256;
	cv=none;
	b=6lh6YwDza0bgXnXGYXS7U1H0I6zNAWWSROnD1ByqFSVfBvSZ3tKZxUoZ+scO5f+XmqeXQW
	m6luUyDfN3lKLhbtbWuaa1EXBIiO4aYXwQx4JhG2bu/TKR3hnsDDGCIxNdmV+RJEJuZ9g8
	5VRlRrV3+c8Yrizx5KlIDJIdQLnG7tg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NP+oJT9X;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759313176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=393rN1ZpjbBC/kxJBIELF7diTurMQySclAxKyAjIUr4=;
	b=NP+oJT9Xu+AIdWD3V7YlGutu+9IPikN9WZKVvB11Dhj7ychLuogT3WtOw5FNQXyilQPRnp
	dmwRpn5dn5cV7eXJ7Gf1MxlWz95XyJ1jBzFfPsHAfTHsrStEKsNUb6mJqGtTglcsiJxw71
	1Z6rlohEHy+UlVPl7khZgQyjYDHluhY=
Date: Wed, 1 Oct 2025 18:05:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251001085425.5iq2mgfom6sqkbbx@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e83ji36bw5pzq5ttk7cetpx6dre66exn
X-Rspamd-Queue-Id: DC4F320011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759313178-114168
X-HE-Meta: U2FsdGVkX1+V2tSa8TE5G5w6jfsNSETnF1l55YL+fmjeBhd/8NWGfheJVchxSzXAs3oAvKocUVqbHmq6OinlqO/X1Z/aKB6bNzNlYPYu0ue5aiMiIwiUI6jiR8a+dFlgMSbNDmXnBieJeUbj88rz13kPElTRKF0hDXoJgepFa0T9CnzT/FrNQgDgZrHcI/TTcW0jWiyX4s2ee1YE7a12TN8mCqQdDMx1K+TR/dFIAMWleJioPqWTK9emNA00QyZdCDwl9e+00Arc8XpAqXBIBWp1sEwtvwN4TDV6rj1zqrd905In2uXWwP4mitR14PyIERTyvOmsPlnRGnCP2wR0BbInwzj1+ZliOMiHNVCaPEkOEervLJld9fyNQSZyD9S3oSv32PizrS4iyWZAaz8wJflNJ6fIQUPHbmNcuWyc7jYqr+hI+H6ZZpgjI/HUm+seOtXCMvV6iOEHgttNICnytYniLdSL6RaecGFVKw9vCiScI9D8BnpBLbRQXV2PMckNwazv+kK1/nlfYElxhN4JuHm1RTHi6VU59p+oEVDg+NTLIFYdOSZ1YnuVeY4Bv31Gk734re/GVgVxMYyt3y6ggss4Ic+uB5sQz7+m6wyOoW6xD9hakJsKIsG4/LlNBaGZPqolAb/HPm66hZGIXS7SFmcGX5iv+/uSXkPudP9FMLwsu5eBkU3RDr9RQNmP3/9R8JLt/r232Fxi4OHvxwfDxXNGNd/3dshqJjDDc9dKv5KVRWJgOHGnKXG++PHxZeB6ZTToy/cbWJZE1+NglIkTmt7A5MZkXRP4HWHU2TeLRtdkqLt5NuNgk4AOwY27KsjiloG5Lc+euQzu8HU5z5qEZwwYeam5SRbD3KRieN4riv6AQOl5k5MKtJ0/uTHUJHARH4BpVoCW3hOmnZbq6pfYtJ3wzM4l150Nl36Disa/OpP6tYogCw8eQG1RtEk5KTj2v2Rt+9VohJx05kuZXun
 8wEM90vw
 AF7J2pKx5qC04q3K1wKnMK3PV8MlMgdYv0r2TgEFu/RwzO0vFsiZ748xNo7citClUykc5peQrrjaSvlHNgjb1v1FCWkdWMoP3ffucPfnr6b0CG9KhV36QoGX3qJI58WFSdtgW/MgRwxx3Xd+4eODsudtKNb+loguVAZZ1YsiLVZRpKsq8qQyE8syR+w3231DBjFPcfhxQd3ePrwjEj/gnzZGLjsp+zZB1sjCu5+p3nc1Vb5gNnaYYcNVmzGyYNGT+GbL+U0xxXe6eVwOCttLsOtn1qPxchDvWbGf55BeU6H/IXPkusWNONEEFx6rILEqWa2EajHMLU/L/FJ3SIpOFmap7WIalKvpGhsyv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/1 16:54, Wei Yang wrote:
> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> failures deep in the swap-in logic.
>>
>> hpage_collapse_scan_pmd()
>> `- collapse_huge_page()
>>      `- __collapse_huge_page_swapin() -> fails!
>>
>> As David suggested[1], this patch skips any such non-swap entries
>> early. If any one is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work.
>>
>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v1 -> v2:
>> - Skip all non-present entries except swap entries (per David) thanks!
>> - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>>
>> mm/khugepaged.c | 32 ++++++++++++++++++--------------
>> 1 file changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7ab2d1a42df3..d0957648db19 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> 	     _pte++, addr += PAGE_SIZE) {
>> 		pte_t pteval = ptep_get(_pte);
>> -		if (is_swap_pte(pteval)) {
> 
> It looks is_swap_pte() is mis-leading?

Hmm.. not to me, IMO. is_swap_pte() just means:

!pte_none(pte) && !pte_present(pte)

> 
>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +			++none_or_zero;
>> +			if (!userfaultfd_armed(vma) &&
>> +			    (!cc->is_khugepaged ||
>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>> +				continue;
>> +			} else {
>> +				result = SCAN_EXCEED_NONE_PTE;
>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +				goto out_unmap;
>> +			}
>> +		} else if (!pte_present(pteval)) {
>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> +				result = SCAN_PTE_NON_PRESENT;
>> +				goto out_unmap;
>> +			}
>> +
>> 			++unmapped;
>> 			if (!cc->is_khugepaged ||
>> 			    unmapped <= khugepaged_max_ptes_swap) {
>> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 				 * enabled swap entries.  Please see
>> 				 * comment below for pte_uffd_wp().
>> 				 */
>> -				if (pte_swp_uffd_wp_any(pteval)) {
>> +				if (pte_swp_uffd_wp(pteval)) {
> 
> I am not sure why we want to change this. There is no description in the
> change log.
> 
> Would you mind giving some hint on this?

The reason is that pte_swp_uffd_wp_any(pte) is broader than what
we need :)

static inline bool pte_swp_uffd_wp_any(pte_t pte)
{
#ifdef CONFIG_PTE_MARKER_UFFD_WP
	if (!is_swap_pte(pte))
		return false;

	if (pte_swp_uffd_wp(pte))
		return true;

	if (pte_marker_uffd_wp(pte))
		return true;
#endif
	return false;
}

In the context within hpage_collapse_scan_pmd(), we are already inside
an is_swap_pte() block, and we have just handled all non-swap entries
(which would include pte_marker_uffd_wp()).

So we only need to check if the swap entry itself is write-protected
for userfaultfd ;)

Hope that explains it. I skipped it in the changelog as it's a tiny
cleanup ...

Thanks,
Lance

> 
>> 					result = SCAN_PTE_UFFD_WP;
>> 					goto out_unmap;
>> 				}
>> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 				goto out_unmap;
>> 			}
>> 		}
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> -			++none_or_zero;
>> -			if (!userfaultfd_armed(vma) &&
>> -			    (!cc->is_khugepaged ||
>> -			     none_or_zero <= khugepaged_max_ptes_none)) {
>> -				continue;
>> -			} else {
>> -				result = SCAN_EXCEED_NONE_PTE;
>> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> -				goto out_unmap;
>> -			}
>> -		}
>> 		if (pte_uffd_wp(pteval)) {
>> 			/*
>> 			 * Don't collapse the page if any of the small
>> -- 
>> 2.49.0
> 


