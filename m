Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A702CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B562880026; Mon, 27 Oct 2025 05:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DA28000A; Mon, 27 Oct 2025 05:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A9B80026; Mon, 27 Oct 2025 05:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 910A08000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:03:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CB381A0510
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:03:37 +0000 (UTC)
X-FDA: 84043306074.21.D59512E
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id F18771A000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:03:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXI77pie;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761555815; a=rsa-sha256;
	cv=none;
	b=tYOHO+xbywmv/3WP97TZFVy0jFbqOQjXyvmC2WapmIVANntmH6kNw7Xe1B7NrUN9ndNC1Y
	YrK6FXFaZq6ZbruBLabtY7LoLEWgNqC3degWxSrntCOgU5ze+Iy6AytlDlOtvyCfdhCmLj
	ileLPIuzR5v+3aBmdC5UuKLRruHcr+Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXI77pie;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761555815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV8YyUI50b9YTzBcIMKZgPznygfBMpGKiWQNdsbpj0o=;
	b=b0VAyosoK/LiTF9ZYqqF9usUjpKcAr63udlTS8ff9JthH2nFXSZOIybrS09+ONlvUIOaBG
	erSfzgR5FQwdTNM3RIRTzBqDFnVZvm6oRnJtOSDnz9D2sqsYOIstyMIEwrGy1sS+3a6unb
	KNuLAjyYl2lrCO6g6pmv9mQ0L0RpzEA=
Message-ID: <bbadcbfa-0250-4d53-975e-97b81559c6ad@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761555812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lV8YyUI50b9YTzBcIMKZgPznygfBMpGKiWQNdsbpj0o=;
	b=SXI77pieU9uobUn+uaGz12VeYJLIB8q+z5LXhhnSmvbtcqjcLAupoE56fQ6yyy/zD+RCXp
	0TcGiSKcLO8IuwWlvFsoK3fGn3qdNwM2DryuFyrejF81na/PPHQi7m476EIvr7z4TYp/7R
	sl3s7OAZ8xOGeh9E/aEq96cG+CNFdUM=
Date: Mon, 27 Oct 2025 17:02:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v12 mm-new 03/15] khugepaged: generalize
 hugepage_vma_revalidate for mTHP support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 linux-kernel@vger.kernel.org, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-4-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251022183717.70829-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ytuwfz6c49istqbrst4c75jhe45i79df
X-Rspamd-Queue-Id: F18771A000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761555814-650914
X-HE-Meta: U2FsdGVkX1//2QGWEljrkZk14eh+FRSh9MDc22NVeZQpC5+wt3V56vpFxkBHo3PQfQJmbtYD8/GDU4j7dvm29jOduApmxZmzeTAqGDACaJNNUVt3CaGO0KgFD2GljZFSzRX+5aYU8yiKSgc7mq7ZqB96wwUvmX2PDp5YVldcvDAaInld6WuLXziU49TJNvvqiGXfMTjqTJLLj5t4V5XRSF+izpizqPWdvKQaa9G4tFlf6gpwmUlmXH3XQLgmzt5CbVOrJULATi+kzgCfF2ptvhnUXzb+x21giHfEu1Cz/n0oDohAIzXS4AhywLeglzsCkyxnUB8PNLeNhjheYe3XiLujPMSYXMPLHSD7JBkR61YFLzBFwc/jywUh+w/YgdniQ5G7TIZdc1Nt60NYi47Dgjd3clzZfGwaAa0BxQ7YKOdsa8t2aoTmG3lcNHFNF3TPR1bfPFjxSBKFsr0ln4k+v/wz7nLh5rsPs2A4s/HUAmd7TphiroIXhxVh31BWW1J0Bk8rIX6bJd2UewUw5m+F49945sAnlpAPiHEPxG5pMMSqvubVneTlFz2rGRRh0Gz9L4DkMaCHatPDf+AlL0Gd/9pNwyy9Vam9yeAvYWbovcV8wyhb7Xih2zXbB0d/R0m3qjy+f3VxbnosBN858CNx9Ws2Y+omD+G4Ms/YSHefyF0OiPvP9kAaigRG8hV53Ru6sVKFmeXlHCXV0dnnRRL1uyEkxw2A/6llv8HDA5we5jM+4WSxFHXKc4vr9DftzWR1jmoruDPFJCSej9rxxZyhLkhS/Sls3T2ZJfoNunla2Gui91kGh7Rx9QChXC7pMMVJR3wtBLfVjZU2SS0SRSUAjwn2l+AlB9syZb7C1kOsyYlYIcEjakQMVmdcbfKSer4rLR5ihjDhcSF5Mh7wZEOzGX3gCuURS0U43wR0xUfgAyyTOA0TuuSBWPzxQindRGH6UWtCKDYq/2qxyfjvuxA
 woNyPwPE
 nPRfXHt+5mddCloecyPJV2DFJI8gFZux8+SNpv6ejpoMR1PO80AIAMYfVA/tCFbEhGSuzvpMNQVjCTuO4IODhI+doh/vg0Q9mco2k4b4tUy/t/VBHJFLd29dM7ZIiwsU64zVfjUKt81RtOh8hRoxJOltX2imwYL3BDvQ1XwR4fH9WZ6R/6zYBlKFMj5W+ZzzUbmf4ljafdcx9TKP1zvBotQh9lru9ac4Ausa9hM4xb4q1527MfqDl4a7Z86TYFSl8Mz+E/ilPeDdEmxMzRRM5jkM6YjpfYzrf/yR73hPAudedvrZ6XpeEKejCW3iLOxYynvVezf+6nHFjA7LESnPYjcU1+Imf4J+LH8QiiI8TDkJl1NRzL8VHTiHEsZFwyDhWBzgNLAO4MeSfFyfbzP+2TfURLTMiDV+/ML+TBNUOHAgo8h9bK9BzlMJfU8yeE2jGDzRNSmB8ATNuRF6Z/xy7GExLOuWOX8soTcxcKOee0xuGrbjeE7pqHTBBSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 02:37, Nico Pache wrote:
> For khugepaged to support different mTHP orders, we must generalize this
> to check if the PMD is not shared by another VMA and that the order is
> enabled.
> 
> No functional change in this patch. Also correct a comment about the
> functionality of the revalidation.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 36e31d99e507..6cf8700823f9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -893,14 +893,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
>   
>   /*
>    * If mmap_lock temporarily dropped, revalidate vma
> - * before taking mmap_lock.
> + * after taking the mmap_lock again.
>    * Returns enum scan_result value.
>    */
>   
>   static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> -				   bool expect_anon,
> -				   struct vm_area_struct **vmap,
> -				   struct collapse_control *cc)
> +		bool expect_anon, struct vm_area_struct **vmap,
> +		struct collapse_control *cc, unsigned int order)
>   {
>   	struct vm_area_struct *vma;
>   	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> @@ -913,15 +912,16 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>   	if (!vma)
>   		return SCAN_VMA_NULL;
>   
> +	/* Always check the PMD order to ensure its not shared by another VMA */
>   	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>   		return SCAN_ADDRESS_RANGE;
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
> +	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
>   		return SCAN_VMA_CHECK;
>   	/*
>   	 * Anon VMA expected, the address may be unmapped then
>   	 * remapped to file after khugepaged reaquired the mmap_lock.
>   	 *
> -	 * thp_vma_allowable_order may return true for qualified file
> +	 * thp_vma_allowable_orders may return true for qualified file
>   	 * vmas.
>   	 */
>   	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
> @@ -1117,7 +1117,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   		goto out_nolock;
>   
>   	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 HPAGE_PMD_ORDER);
>   	if (result != SCAN_SUCCEED) {
>   		mmap_read_unlock(mm);
>   		goto out_nolock;
> @@ -1151,7 +1152,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	 * mmap_lock.
>   	 */
>   	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 HPAGE_PMD_ORDER);
>   	if (result != SCAN_SUCCEED)
>   		goto out_up_write;
>   	/* check if the pmd is still valid */
> @@ -2792,7 +2794,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			mmap_read_lock(mm);
>   			mmap_locked = true;
>   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> -							 cc);
> +							 cc, HPAGE_PMD_ORDER);
>   			if (result  != SCAN_SUCCEED) {
>   				last_fail = result;
>   				goto out_nolock;


