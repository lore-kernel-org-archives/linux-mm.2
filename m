Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4135FCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 04:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEA18E0005; Tue, 30 Sep 2025 00:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FC58E0002; Tue, 30 Sep 2025 00:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894CC8E0005; Tue, 30 Sep 2025 00:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749E08E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:50:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C61C13B4A3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:50:29 +0000 (UTC)
X-FDA: 83944690578.19.2B88791
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id DABD080007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759207827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0sTCIjsvKrSRxvqquy8MOm/EjeTPKwFhzTfdLWYozs=;
	b=IYeeerEPEv3PtqfxbUGSL7aSNcNj58JjUwJMFE76Xs3yBfxXVfBfZi6Rsr/xiJnetvnelg
	RJ7ucTF3RENYZJxqdQj3iYp4mqjLPu8WZWIVBMf0CmKPuCgmAHfuo0X56i5z3A9OYTAll1
	d9pCv7mR4asBTbVX+rWY52UoHyESPWs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759207827; a=rsa-sha256;
	cv=none;
	b=4yZBZi5eoT8X1G1Xcp4Nj7ESongagBSOrBO5vht3/5xYaH4zHZ93+BpZynBqTNpfw3/jyY
	kGQTfZJ2F489IC+UAevGGjiSK90zkH+T0DgZd40TdJvOaiGpgv30J1E5m7DaK6DQrrLWLh
	XmST+lMtQd9fCbqXGdmvZrhmjeyzWIw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D70691424;
	Mon, 29 Sep 2025 21:50:17 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78AB33F66E;
	Mon, 29 Sep 2025 21:50:17 -0700 (PDT)
Message-ID: <0c498301-7434-4b2b-b7bc-73abe2057b67@arm.com>
Date: Tue, 30 Sep 2025 10:20:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 usamaarif642@gmail.com, yuzhao@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
References: <20250930043351.34927-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250930043351.34927-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DABD080007
X-Stat-Signature: 5hcpesbymzptaxsjk5gzid5398ojrc9q
X-HE-Tag: 1759207826-975666
X-HE-Meta: U2FsdGVkX1/xs8vs9O7x58ur9dYzuQSKbmTI6hsgXdYD13Bszflmxexpi2mXCfrBf0kwmBHNRIGhCPSSm1AB877l/QXRfsAr9pjcTX80DtfmfpbohKkHvA8Dq4Iytxv3vvSkBeN9mr/WDg1FmxeZwXpaM61/ME7q4QdVfljSRl4qkqMvaVxl3lP+aytt5hHoe3kCejKfeMWIK46+WhjfjmuKRkMf2/SEb1JVp3rzjpmT77SgBHvaXyaemVp2Y/JtXAeFTtg7CjjoUyNJ3p9q9NXeYlapjJ9cj+t+qI+9dFP9ljyLfG4tykuCNacmqB2W0gQg8UhdfYu60FyG8nN6bCxwE8AUZ7chhhU3SJ7nFaERRb7mdiAwRP4Oia+jcuS5eRWIR+/LqH0pzswq5oeIcj4gvxeLG0xWvn9e8cfsX9Kxw59mOd9ocpWX/3nh34TEDVfxnE/0nxeJ9cM7V0zrfF3EcZDb3upAvPndX75GB2RYsCehqOeP1ZI2emEJxV6faCI0PTksxT7rlsSXjnaH9MGBZAH4eto5CLTqBqFKZkFrDoPGHgeMvtCo7arNMJwiD1FpdkwOSm5Ao2Tgd6J39q+L19PwZWMaAZ9nQHnrSJCrT1qQYdjHx1n17Qey2oUdi6v69g6MT3NOxCPooYC3CYRhLEtfPeixwsT9V+rt1SNibasGqh4adzbKwg8Zp146YPEpuZSbsKa2n7ficiOUE7Dkr8YOtoC5hI92fESVawrrrBMF53f15v+a8R1qDLsk/+JsolkfRVQBdgZ+g1qv+HD8jex0UL3fXDHRiu/a1PBWd6kNIH7xMm1Ue3Ql/BYtraGcFd5dXMZtpvPZzaPeMRbUL4gFwRpn6KaEIMBsjrNkqF31Igj1ZfUGv+WRzEMxE4XyvTZQ8r8p1mlda1z3hW0+0Wxueh+A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 10:03 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops several important
> PTE bits.
>
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing the soft-dirty bit means modified pages are
> missed, leading to inconsistent memory state after restore.
>
> As pointed out by David, the more critical uffd-wp bit is also dropped.
> This breaks the userfaultfd write-protection mechanism, causing writes
> to be silently missed by monitoring applications, which can lead to data
> corruption.
>
> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> creating the new zeropage mapping to ensure they are correctly tracked.
>
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v1 -> v2:
>   - Avoid calling ptep_get() multiple times (per Dev)
>   - Double-check the uffd-wp bit (per David)
>   - Collect Acked-by from David - thanks!
>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/
>
>   mm/migrate.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..50aa91d9ab4e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -300,13 +300,14 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   					  unsigned long idx)
>   {
>   	struct page *page = folio_page(folio, idx);
> +	pte_t oldpte = ptep_get(pvmw->pte);

What I meant to say was, you can pass oldpte from remove_migration_pte to this
function. Basically define old_pte = ptep_get(pvmw.pte) in the declarations of
the start of the while block in remove_migration_pte and remove the existing
one. That will ensure ptep_get() gets called only once per iteration.

>   	pte_t newpte;
>   
>   	if (PageCompound(page))
>   		return false;
>   	VM_BUG_ON_PAGE(!PageAnon(page), page);
>   	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> +	VM_BUG_ON_PAGE(pte_present(oldpte), page);
>   
>   	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
>   	    mm_forbids_zeropage(pvmw->vma->vm_mm))
> @@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   
>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>   					pvmw->vma->vm_page_prot));
> +
> +	if (pte_swp_soft_dirty(oldpte))
> +		newpte = pte_mksoft_dirty(newpte);
> +	if (pte_swp_uffd_wp(oldpte))
> +		newpte = pte_mkuffd_wp(newpte);
> +
>   	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>   
>   	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));

