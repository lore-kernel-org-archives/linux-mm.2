Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101A9CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701C18E0008; Wed, 15 Oct 2025 03:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8F38E0002; Wed, 15 Oct 2025 03:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6160E8E0008; Wed, 15 Oct 2025 03:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5108D8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:32:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FE441A0B5A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:32:56 +0000 (UTC)
X-FDA: 83999531952.07.FB235AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5DDDF4000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:32:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513574; a=rsa-sha256;
	cv=none;
	b=esprjyVu/5DYKuweHDRWT4GuhQeIw/MseOWHjT6QdgWdWF5RIh0t/OSQRG0mxKRtW8UugL
	EL0BVMvNv/fgFKxsgngSqcUmt4R91OCMkZ8oatB1stuP/0a6Cyvw1+6jnZ8KkyysdFhMC2
	KTtySDFbZ+I3Vfm98rnQx13XkNAmsc0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wn/hyPiwdJdYZYWO3jFX4fEnYpfhFH2kObF8se4qmbs=;
	b=ATnfz+G//eN5oxHVKl9DY/sNiXWU67ks2FLWXcgeRYfmySv68GXTlYzJN2MyV5Z6MsUSy4
	zoGbQIhxx0TL3YtdgjZF7eremKqWdnvxpF9KqQWRss5oUMbRAZhzEMrfHpY7ZDdYEFwrzz
	5nAjEytBQ85rfyYmKidmjbSJJtOoXx0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6776C1A32;
	Wed, 15 Oct 2025 00:32:45 -0700 (PDT)
Received: from [10.163.67.182] (unknown [10.163.67.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A337E3F6A8;
	Wed, 15 Oct 2025 00:32:48 -0700 (PDT)
Message-ID: <1562a70d-6778-41cb-be30-c83ca7eab373@arm.com>
Date: Wed, 15 Oct 2025 13:02:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9a4sct4ghb7bdfnndr3y3pa1ty6smniq
X-Rspamd-Queue-Id: 5DDDF4000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760513574-302982
X-HE-Meta: U2FsdGVkX1+BY31VbTqYy9uMzPTFvhwwTNErt/F4LAoBnEBLJeY+VI9G0xCc5/geO95RPvrcBdsoIYDKHhC21E5P1GmJirrTIu9qu7cRzNP2bK8dt0AKOj2lPVuuWiwaZlYISCk5lMPq0tqUNZEiAfwyvpd7QWHClEfwrso9ZBZjXgL/AM23s/9jYLKRPKMXQpKY1uOttQUBSjhXAIw2Pli5FA3X14HZCNP/rZllQFyb+ZV7wNX87l3NvMEv9p6VHpO7B7lx3YEDn5YKre6NuOEinzGpvHJiYIKvxIOk1+XMK1ogUb7ACnRlNCf4F5vXANfgHhe6BrIkUOddelj0gwB492rbh/O2ZyxvOO0OhbNgALFLG21iaeTZL1UoJYqAXgjoYHbbVtAgTMhqDmVzOMpPmdFMXLBeePZhcHosR/Vl8lKWB+MKBpmpSbp7NhMSpCml6Awo50AZQ3KdBIptqKFYQU8uLlkWPdogqVxnw8Y8DQRbKtPJdJx5snDbOqzL95nsA3XiHZ1pZcOQbaGlj1X/tnpeYqyCQeKwuwBkVnNN230rN/us/HX78bt4NGY5Awfhrzc02cddozo4FRfXZcnnrQHKu/W0lNdrB+z26pn/GgK5S0CZNK2Are/0wgnlu5TvY796HLgMpM3rYVvN+GytJlPEOSMJY1TmymFt2Z2GCO5WWfRhGG6FLgyxno6CXLyr6DemmI5a81L4vCH3E7uuPwS5TARpudUz1GBB3sDuI2J6Rvgd6Q0DEWD2PdjmaHi0YweQDZV0baTHXptauhSexnDkcCz+cZlA+sKv1m9q5h4vqXFe41KK1ADtZxeUSl8AjLddsMudnYX+HaPxKh79A/aanMn1IH3gc+PEKr+HXQpduxdC+SoWBzmnXs85ukQde52Ipf99VRbDWFtDi5/LuBe1r/sgLnoObl4i8Mx39t3ayhtNVNlJep+E49xveiERvehzcXwZ1o4ru3P
 a0Qz0yC9
 RAsyalySZINfCRvMNdwveaNM9y7Sf6FNNGvJJsbX0oStm0Q5voMFqBYy/X3XBxrgePg+4+5LLsng30D6yzpdqv/VKF4Su75MZAgLJUvtTKHE+7dkyOi4j2z1D6zR4IvatKt7e8hTOZDecPcniNb9pUjfCAmBDHGmBiMtYxqpeQbE86Cf/tIIIgpV1+DvEreU5w7wLff2nQIswR00OQQq3/yYCGpNrQDCzTpZ7xpBB3pyrIOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/10/25 5:03 pm, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Thanks.

>   mm/mprotect.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bb59a42809b8..7affa88a6de7 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>   {
>   	bool ret = true;
>   	bool toptier;
>   	int nid;
>   
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>   	if (!folio)
>   		goto skip;
>   
> @@ -307,23 +302,23 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			struct page *page;
>   			pte_t ptent;
>   
> +			/* Already in the desired state. */
> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;
> +
>   			page = vm_normal_page(vma, addr, oldpte);
>   			if (page)
>   				folio = page_folio(page);
> +

Unrelated change but I guess this is needed since we usually leave a line
before starting a comment.

>   			/*
>   			 * Avoid trapping faults against the zero or KSM
>   			 * pages. See similar comment in change_huge_pmd.
>   			 */
> -			if (prot_numa) {
> -				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, folio);
> -				if (ret) {
> -
> -					/* determine batch to skip */
> -					nr_ptes = mprotect_folio_pte_batch(folio,
> -						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> -					continue;
> -				}
> +			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {

Why not "&&" instead of "&"?

> +				/* determine batch to skip */
> +				nr_ptes = mprotect_folio_pte_batch(folio,
> +					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> +				continue;
>   			}
>   
>   			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);

