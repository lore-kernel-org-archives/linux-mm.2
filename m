Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9993BCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007768E001C; Tue, 30 Sep 2025 02:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2BD8E0002; Tue, 30 Sep 2025 02:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73AB8E001C; Tue, 30 Sep 2025 02:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE6A88E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:33:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A201441A3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:51 +0000 (UTC)
X-FDA: 83944951062.08.18E40E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 601E2140003
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kg/rtcgKydY9e6DitVYeYNYidjQwm8usT9dDMBR+Y/s=;
	b=mRrKpSinLukOvG4g1v1HRAw3t/7fiW9YEtQGLRy7uR0bwNzNm7izXRDcQzxdXgqdbEtZLc
	iz2ZsGF1UY5y98+pIM4HEzwJIyl3/SSnvH71S5bE26LxVjWIIg154JquHqw3kZsRcaN+bm
	NYtcTeD1vTCIg2vYVN9+xYSGUieBOOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214030; a=rsa-sha256;
	cv=none;
	b=cOAXhmNE/c1C7OqP/7myNDjccQQAUzyBGTrqPaIIdmpbiosA0FhuRBVgNLCZknu5TexE7U
	vj055yzu5vV8X4JDhvtAHlBnr7rnGXcV4HlT0qHusspxCFow+TUbVpF1VnyRxWKMIecfZG
	D1HyllsgjYT8rrpMcV2scwXgI6rm+yI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3074E1424;
	Mon, 29 Sep 2025 23:33:40 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE13A3F66E;
	Mon, 29 Sep 2025 23:33:39 -0700 (PDT)
Message-ID: <838505c8-053e-49af-b37b-0475520daf68@arm.com>
Date: Tue, 30 Sep 2025 12:03:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
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
References: <20250930060557.85133-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250930060557.85133-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4k59m5jpkgk6wq64e9yq8oubddf99hi6
X-Rspamd-Queue-Id: 601E2140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759214029-856997
X-HE-Meta: U2FsdGVkX1+tVM+BOCQbzglaSPE03e5gr1MIQQYUcs7YYwIzBtsgfNcdUpsR3UhvfzzbykjmmyYgV1thSA29YASvEUk3VtoipIddlgOCe/SVvGM7XARw8mwAzLGi1ZlrVOzD7MknmT0aBtS0AJDLVCrMCHbfa9brXb26cU+Yvl+/HYAxOzVmayWOB+4rd/SF6cxv3xRA1Xz3CJVjGVsIPFgtbjuZ1gRjYn8GLuVx25IqByL2DDy3Ts4mOj5Yg8++QKC26NsTagYy+6RSph2xwIAMjnDxpBQ4mwW5zPd8Khdn+4cSOYeih/5uAySTDzbKnok48MwKZFHjQVuSPq2noWry0g1hrQIRty/M6mV4eIx2wejwReuPaCWTl6aiNQxrkw4NTygmQv9BuoradfRuHBwhS39K0Fi4SsQLgIQ6gVwPst019LkohXgq8GnQ1PteONc9Hk5lBomoRPjRkGiAP/0DxqGKRdpUE8qKOd7NWVJtyFOCuu0YyttjZmekxcCYZURS756hmtEGEvmUYZ4WqLZC9OUZtk7rtEnyKSg8/ueTyANCm10x7mjcKKTocZj+uFFDsCNLj/ZNwYtsrE7kgCcKEYZexmxmt+L/0DS4b+xv4b60tNP6HZO7E37LAlaSAnEiNxy9kz/yTsN5+zdjHwm6QkBTh5kCfKXGEVXAJA0xM4hM97+Wsyp20i9TYTR1wQWVY3tEz9U7H24Q/FhoxRNwB2/xZ1bV5fPnY7CXU2LP54PCLYkDW138RmwE6+7k1vBXoNJavjtf5JNWiCOd0UNJC6HbNKhcIZAwh7gOqJflLR5q2b5Av4MNVmwinOO0xSLaDwYw195VvM4zOudjvhXE4rcZ8pYSJdI67mv1GitIlz9JDXPN7v/C3xvCIxVry7dVhOB8UjqP2rWL7cXvyTKTkUYqWIkDr3OcQno+miwiYbSZomQQOw0xkjfg8y89dA1b+DFpT8DEaCAsA1J
 GZjNc2Ev
 WzatRFTEI1XORCvhaOnxYHGdpcOwQbRucPxPDhvRlPzup7XMP55VBOxh9/UNpcgH1yDkUzyd8Oy+stfQXo1gdlMaGjsincjuszhSU3krZ9Ih8lIgY40z8CsVzd9PKM7WCQGqilLxwFRRsrmhzR6th9ByGk9fBzvb1/+NHlq4NI/vr7FIm7Q3k74HUq0yGeM740WunrVZcvxDE2C/tkbYr2OOAOnr5y+zYk0+Sy1RhoddsWhvXKpA6WmRnfuWUiJCinrBRHbIGOlNsyphBIPqDkNPzsiv78DZfnpf3C8c0GT8zq15HStSTIhfP/4DdvFVPej0E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 11:35 am, Lance Yang wrote:
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
> v2 -> v3:
>   - ptep_get() gets called only once per iteration (per Dev)
>   - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/
>
> v1 -> v2:
>   - Avoid calling ptep_get() multiple times (per Dev)
>   - Double-check the uffd-wp bit (per David)
>   - Collect Acked-by from David - thanks!
>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/
>
>   mm/migrate.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..bafd8cb3bebe 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
>   
>   static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   					  struct folio *folio,
> +					  pte_t old_pte,
>   					  unsigned long idx)

Could have just added this in the same line as folio?

>   {
>   	struct page *page = folio_page(folio, idx);
> @@ -306,7 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   		return false;
>   	VM_BUG_ON_PAGE(!PageAnon(page), page);
>   	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> +	VM_BUG_ON_PAGE(pte_present(old_pte), page);
>   
>   	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
>   	    mm_forbids_zeropage(pvmw->vma->vm_mm))
> @@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   
>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>   					pvmw->vma->vm_page_prot));
> +
> +	if (pte_swp_soft_dirty(old_pte))
> +		newpte = pte_mksoft_dirty(newpte);
> +	if (pte_swp_uffd_wp(old_pte))
> +		newpte = pte_mkuffd_wp(newpte);
> +
>   	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>   
>   	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
> @@ -344,7 +351,7 @@ static bool remove_migration_pte(struct folio *folio,
>   
>   	while (page_vma_mapped_walk(&pvmw)) {
>   		rmap_t rmap_flags = RMAP_NONE;
> -		pte_t old_pte;
> +		pte_t old_pte = ptep_get(pvmw.pte);
>   		pte_t pte;
>   		swp_entry_t entry;
>   		struct page *new;
> @@ -365,12 +372,11 @@ static bool remove_migration_pte(struct folio *folio,
>   		}
>   #endif
>   		if (rmap_walk_arg->map_unused_to_zeropage &&
> -		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
> +		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>   			continue;
>   
>   		folio_get(folio);
>   		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> -		old_pte = ptep_get(pvmw.pte);
>   
>   		entry = pte_to_swp_entry(old_pte);
>   		if (!is_migration_entry_young(entry))

Looks good, the special bit does not overlay on any arch with the soft-dirty bit.
It shouldn't overlay with uffd-wp as well since split_huge_zero_page_pmd does the
same bit preservation.

Reviewed-by: Dev Jain <dev.jain@arm.com>


