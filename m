Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F503E6BF0E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 13:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AC56B0005; Fri, 30 Jan 2026 08:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E816B0089; Fri, 30 Jan 2026 08:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0B36B008A; Fri, 30 Jan 2026 08:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 386F46B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:34:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEAC9D4492
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:34:51 +0000 (UTC)
X-FDA: 84388725582.17.C837446
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id D428540010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:34:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KT/rqX0Q";
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769780089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBlsa1vr6ZeB2QvpQ71ZYV6glQGH5Ds/8UMAFBywU/c=;
	b=I0pbL/Gk3FNB1109huktgOF1a+htZoCdWAH/mSXUQUtkkpWPpw70guvU4JA+uKTZ9CVjEx
	jYREsNkRUxAepiMN92LhEwlpbWueVDTf2ucjCkJNhnT3mUcebWPtRRUhPvQbTpJh9dfgh4
	cxldW5MnWSeQakD0OtgmkgVNzxjKEgU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KT/rqX0Q";
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769780089; a=rsa-sha256;
	cv=none;
	b=k9Udp6lYBHVFTzLMgtOAYoKecaL4rrCWXvYJiKzzehFN04clhU3Tc7Ks6hjebl79hbm4w9
	KD7pujihRuAdg7eVDFGoPpWTmt7k4BTDmVsBz0odF1jjVcydclAe1jETeg35JlnJbb86IV
	okGimCzL5FsMYMSUJCIGNeG16Xvn+1I=
Message-ID: <b62d0a63-624f-4822-b0b3-07e75d97721c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769780086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IBlsa1vr6ZeB2QvpQ71ZYV6glQGH5Ds/8UMAFBywU/c=;
	b=KT/rqX0Q1rH5fQrJsOvYoaGjogI6RddJi+9rCtaewr/0tgz/SMGbybWw/IYOyxs1XiP4TN
	Xu3bblr5El/xMJUdM4Px7qCtcaKe0SmuDphEJJP0PjpBkye4qZUKb73WYI7wGHMClnpEvb
	W4AALt8EBn6nd7JEsA1WycJFXDZi0fk=
Date: Fri, 30 Jan 2026 21:34:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
 <1a33fe3e-b0dd-4553-95b4-89619b9229d2@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1a33fe3e-b0dd-4553-95b4-89619b9229d2@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D428540010
X-Stat-Signature: 8eth7zncyjwsdttys3yry78yjhcdbhoc
X-Rspam-User: 
X-HE-Tag: 1769780088-41891
X-HE-Meta: U2FsdGVkX19aB8p7ONDctbuUeZza146PfEEOsCQTflQIK2FLu37pTv/TFrqKjtoxjQltQ/pfWzFJ1cHMn01quvt63ML2fE20oVZlZik9PjTxFmzGMms78GFWacFlyDzkroHsWDKKtEx7fSdJ7vhpu35KFo5g/fRAk4Ga0zGucufT0OSWIq1kzkDjgPzbq7GX9UWV5tV09maQIFygiWfbnmDDRABtFbePkT60EgZv67qlltgoFfTra0+XMBG4FmnD3z7Is2dKv8xEyWd1M3DzPlD6qAtDRkk/qqfBcdtWBSQ81JcVjZnmpxooRbKdjQqew5bi9dzd7Z/qQT3FWTKhmBX/sb365NjUBB71badlFOgYUDtFYDZJw5hl+yqhHOcAGJwK1jeipnwgY05AKGEGdGw3vj0O3ea4xmltoUeVOjuOxbvzHmaiEiLxqdQyACITN1L55lAAlcU4VdnjM7pky2g9sm8AblY+TB6X9nPZ4Z5nLHWHKdvCF6JZX7RaFYBdjw96UgTrrFWt8APpTeJPp/8YuRE8Oa5YvjN174FApSJUugj56udEXU4+OkM1PhlGlTQ41nMjv39+nYejwbwI+N6OhuDOe5hJCE5SlmGeKlLnk46E+mLSgszPeZKFwXrWj1EhvrmOtMp2bYSL6g3tehBOpxsKVeKCVPJNib35WdGmH/zoBjR8U13kQhd9WwAwRoY4NuG4D/QjpE4EJ9ZEL1N6t/bcA8en89ZQllDOBGLcH6bsY4SAyxen+Y5WFyArFppDgGrHxnRercVAknsYoeJWSMrz1zO2LScBs/OBbaKrcyLsxzGZqtFQ1mrsiBgaBVE/VzhgafxijhNhT5QgE+re088CUxMR8iANkjd0wvMMCbU8swpBMXoqTZHLtQ58N9uPmYQ6AEqfy8spQxTu5KTtMTf9S6JxcYI0enGb4am2IIhPvULsm0DpE2RSt/1/QforxjOzoPBu/hTMhpy
 YPntglDC
 z/4oWmdEEME6qj3GVcy6PvU0rOPPNAMNcTRC2A34m0I8LwnXJKPJO/tRpqjX68Jn56VaGpbxpkKPv+iOHkGRdR9NLhPALiz+k6yivZ4PRnDQlKQWkIaeZ5LRbpkWlOfasStphHNI300aXI4ZKrUfWOvZCZevXtL2VTA/6pOb5QWOL+XJaAiBovFurv1v+X3oKhFYQUqvSDpFGLxNr9rBF+/DrfJpeyuvXKwFzeF+9M5eZix41LX7zRkvXqTH6kWDve6jAi/QhtyNIUlrszSVb/JnVcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/30 16:10, Dev Jain wrote:
> 
> On 30/01/26 9:59 am, Shakeel Butt wrote:
>> In META's fleet, we observed high-level cgroups showing zero file memcg
>> stats while their descendants had non-zero values. Investigation using
>> drgn revealed that these parent cgroups actually had negative file stats,
>> aggregated from their children.
>>
>> This issue became more frequent after deploying thp-always more widely,
>> pointing to a correlation with THP file collapsing. The root cause is
>> that collapse_file() assumes old folios and the new THP belong to the
>> same node and memcg. When this assumption breaks, stats become skewed.
>> The bug affects not just memcg stats but also per-numa stats, and not
>> just NR_FILE_PAGES but also NR_SHMEM.
>>
>> The assumption breaks in scenarios such as:
>>
>> 1. Small folios allocated on one node while the THP gets allocated on a
>>     different node.
>>
>> 2. A package downloader running in one cgroup populates the page cache,
>>     while a job in a different cgroup executes the downloaded binary.
>>
>> 3. A file shared between processes in different cgroups, where one
>>     process faults in the pages and khugepaged (or madvise(COLLAPSE))
>>     collapses them on behalf of the other.
>>
>> Fix the accounting by explicitly incrementing stats for the new THP and
>> decrementing stats for the old folios being replaced.
>>
>> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
> 
> Thanks.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
>>   mm/khugepaged.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1d994b6c58c6..fa1e57fd2c46 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2195,16 +2195,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   		xas_lock_irq(&xas);
>>   	}
>>   
>> -	if (is_shmem)
>> +	if (is_shmem) {
>> +		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
>>   		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
>> -	else
>> +	} else {
>>   		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
>> -
>> -	if (nr_none) {
>> -		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
>> -		/* nr_none is always 0 for non-shmem. */
>> -		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
>>   	}
>> +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
>>   
>>   	/*
>>   	 * Mark new_folio as uptodate before inserting it into the
>> @@ -2238,6 +2235,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	 */
>>   	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
>>   		list_del(&folio->lru);
>> +		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
>> +				      -folio_nr_pages(folio));
>> +		if (is_shmem)
>> +			lruvec_stat_mod_folio(folio, NR_SHMEM,
>> +					      -folio_nr_pages(folio));
> 
> I notice here that we don't need to do accounting for NR_SHMEM_THPS or NR_FILE_THPS -
> but the following bit:
> 
> if (folio_order(folio) == HPAGE_PMD_ORDER && folio->index == start)
> 
> in the khugepaged code, seems to suggest that we can reach this stat accounting path
> with a PMD order old folio, if folio->index != start. But this condition should not be possible;
> a folio is always order-aligned within the file, which means the folio->index here
> is PMD-aligned. The entry of collapse_file() asserts that start is also PMD-aligned (guaranteed


Yep, good catch! There are checks in __filemap_add_folio():

	VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);

and at the top of collapse_file():

	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));

guarantee that any PMD folio in the scan range [start, start + HPAGE_PMD_NR)
must have index == start.

Converting this to a VM_WARN_ON looks good to me :)


Cheers,
Lance

> by thp_vma_allowable_order in khugepaged_scan_mm_slot). Therefore start must equal folio->index.
> 
> If I am not missing something here, I'll send a patch to convert this to a VM_WARN_ON.
>   
> 
>>   		folio->mapping = NULL;
>>   		folio_clear_active(folio);
>>   		folio_clear_unevictable(folio);


