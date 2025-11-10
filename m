Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94869CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49AD8E000B; Mon, 10 Nov 2025 08:25:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20F38E0002; Mon, 10 Nov 2025 08:25:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5EAF8E000B; Mon, 10 Nov 2025 08:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1F898E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:25:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B9E313C358
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:25:09 +0000 (UTC)
X-FDA: 84094768338.09.71BB77E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6DDFC0013
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:25:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762781107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUJsuQsbTZO/r3FsIQZwCllbuT86QgPTYNNkN6JKTUc=;
	b=hLSJBQn1TnEATrAwGaI/K2gRGxtMwnOIKJdQ4h2VsvDWncBewmDGz9z3kDP3mC6/yWoNyG
	ILKuKl8MDG1jR+LnFgtftLiAZNyvx/FVEYOU6QAJXQKJxgbtbQq4XZBlliUF1VCoFepFpu
	WCKcp1zE3oG1HtkZLm43dci/Eub6tLo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762781107; a=rsa-sha256;
	cv=none;
	b=ovAlRuyLV2Sg5Bo9cGvsbwm9b8MjCFGRAwWtz7o53wbayNssgr0i5ie1j7F+J1sls1WA9P
	nBb/GTbon+9inE7aiaPuyD+HVFmC8OJQS3iyO9Sj41hkpu5D2kWHNtPgkvZzgP09JcpNvh
	8oL1WTQqbLLgQfnV8A9Y2s9pf3MlpbM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5247497;
	Mon, 10 Nov 2025 05:24:58 -0800 (PST)
Received: from [10.164.136.34] (Mac.blr.arm.com [10.164.136.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E21ED3F63F;
	Mon, 10 Nov 2025 05:25:00 -0800 (PST)
Message-ID: <3f5f8a48-fa3b-4985-95e1-dd0ac21b5dcc@arm.com>
Date: Mon, 10 Nov 2025 18:54:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6DDFC0013
X-Stat-Signature: 14i6sttfcb6kc7wc9u7n387ecn6wnhz3
X-Rspam-User: 
X-HE-Tag: 1762781107-307765
X-HE-Meta: U2FsdGVkX1+VfI+3m+c9RrXByeJTjeM14J9n4aoR7TkXC2RaQWtMxbcwTZTZAadPcQ3N7yd5E21MZY3JFYRIzInxsFhpumN0xeZLyvFczUkXvHDpM+Ad9PUfP4H69jADKcg31rMxBVoLX9RrvHLX0WNaRpPVR4HhhRhVAgWBmI6WQ7agi1GOp6c4oEs2p3rSPPZGMNJreTsB5We2MuFjCYlG03S8leydY+RR3JaTPB5Tnk0tJ0dgZ0pbHbhXMxGh/Dz++dP/zjE20HMBRe709DYeevvBCfwH5JHw+wA2nSUiTrRz/LUZYhh5yiv9ZyKbQ1UCqNgqHYNmI/UG/P7dKPqsWxCTJyXY5nTb7p3g5/fCREbP7X4XfAcrJCwelpdoCDcR0iZVmHUQaUSLFx836yrNvPAF0i90tdADr9DzqqRcOSMR47Ynlw/NxMJHueZjajyeaFSFNFOhjTmzYmaNPGK1u/w7qlrmKPNkGbaFifDz4o2MvyTz4xH6Q+w+/kQCETHDMATDthuhlpSA0X4osEe1heVGT/5j7h5b4ELmPJd71MEfy8ta7QVKMVbzdfljWLxSq1be3JkWYwSThsYLky0Mx+MN6+rBO+xNFk/y9iVkQJqPfcANslCEntd8asfV32cHi3QF61euUpKITWHeOAIrggMhZE8PACjWWOSVpq28hL2NZiEThVPDS8W3k0d6EmpTswag6QGXvQPI8tWrxUOZ4MqeYPfH5IbdvJsjgVRtYElNUmHX6RlfN7wFybk75KHC+0qwa86hEXK3Vjb+x7lK5SxMJhCOhrWCiBfhUbPiZg1szvgXJsvgEkIQhpMPYWgO0xftY13KT7oVBg1ZPtDpH/u9VXX8zAPaC+XGnHB1p8qCW4FZS4a0s984pgkAlZJdmZkKL90GZMKwJPcEC3dFEUBMEDGXzoGVKZ4AbkSrLW8iEn8HupzKRU8dcavqv9vSq4CmUEWktCW77tX
 buXODTKo
 PP4jAjd2tc5xR7r8+iRgyhGfpOTFGhl0xCJLfqjxquHDl9eaVOyegJwng7H8d6PW7fuNmlP8j7uwldW48fioh3foqVuNnUFpywd7rMiotDxsQ3uJdM7Mki0ySovb99GsaCcznjcy+uIHnruyMZJEglMoetsBcAv1nhKm0XyVjlyUoeKxUBqO66bvOxI+U64MuPFLEfudlv+2of5td7RTcjIKk8/eW9tUa7N87BXH66CrJZiUWaI/AylR0wmqNtctBi5w88Nu+V3szxH/2vIZUnx8D05BBpuj6Jb7uRKrqm7qKD/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/11/25 5:31 pm, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes. The
>> current code triggers an async flush via filemap_flush() and returns
>> SCAN_FAIL, requiring userspace to retry the operation.
>>
>> This is problematic for userspace that wants to collapse text pages into
>> THPs to reduce ITLB pressure. The first madvise() call always fails with
>> EINVAL, and only subsequent calls succeed after writeback completes.
>>
>> For direct MADV_COLLAPSE calls (!cc->is_khugepaged), perform a synchronous
>> writeback using filemap_write_and_wait_range() before scanning the folios.
>> This ensures that folios are clean on the first attempt.
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>> Applies cleanly on:
>> 6.18-rc5
>> mm-stable:e9a6fb0bc
> Please base on mm-unstable. mm-stable is usually out of date until very close to
> merge window.
>
>>
>>   mm/khugepaged.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index abe54f0043c7..d08ed6eb9ce1 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/shmem_fs.h>
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>> +#include <linux/backing-dev.h>
>>
>>   #include <asm/tlb.h>
>>   #include <asm/pgalloc.h>
>> @@ -1845,6 +1846,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	struct page *dst;
>>   	struct folio *folio, *tmp, *new_folio;
>>   	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
>> +	loff_t range_start, range_end;
>>   	LIST_HEAD(pagelist);
>>   	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
>>   	int nr_none = 0, result = SCAN_SUCCEED;
>> @@ -1853,6 +1855,21 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>   	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>
>> +	/*
>> +	 * For MADV_COLLAPSE on regular files, do a synchronous writeback
>> +	 * to ensure dirty folios are flushed before we attempt collapse.
>> +	 * This is a best-effort approach to avoid failing on the first
>> +	 * attempt when freshly-written executable text is still dirty.
>> +	 */
>> +	if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
>> +		range_start = (loff_t)start << PAGE_SHIFT;
>> +		range_end = ((loff_t)end << PAGE_SHIFT) - 1;
>> +		if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
>> +			result = SCAN_FAIL;
>> +			goto out;
>> +		}
>> +	}
> I feel this is the wrong level of abstraction.
>
> We explicitly invoke this oth from khugepaged and madvise(..., MADV_COLLAPSE):
>
>
> khugepaged_scan_mm_slot() / madvise_collapse()
> -> hpage_collapse_scan_file()
> -> collapse_file()
>
> ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
> better off just doing it in madvise_collapse().

I suppose the common case is that writeback is not needed, and I don't know what
is the overhead of filemap_write_and_wait_range() in that case, but your
suggestion will force that unconditional overhead and skip all the early exits
possible in hpage_collapse_scan_file()?

> I wonder also if doing I/O without getting the mmap lock again and revalidating
> is wise, as the state of things might have changed significantly.
>
> So maybe need a hugepage_vma_revalidate() as well?

The file collapse path (apart from collapse_pte_mapped_thp) is solely concerned
about doing the collapse in the page cache, for which information about the mm or
the vma is not needed, that is why no locking is required. The get_file() in
khugepaged_scan_mm_slot() seems to be serving the same function as maybe_unlock_mmap_for_io().
So I don't think this is needed?

>
>
>> +
>>   	result = alloc_charge_folio(&new_folio, mm, cc);
>>   	if (result != SCAN_SUCCEED)
>>   		goto out;
>>
>> base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
>> --
>> 2.43.0
>>
> Thanks, Lorenzo

