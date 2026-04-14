Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B1EF9D0D5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DBC6B0095; Tue, 14 Apr 2026 11:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054FB6B0096; Tue, 14 Apr 2026 11:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4156B0098; Tue, 14 Apr 2026 11:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF9736B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:37:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAE2C1A011B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:37:39 +0000 (UTC)
X-FDA: 84657566238.15.1E8BDDF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7D87180008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:37:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAGKQfzg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776181058; a=rsa-sha256;
	cv=none;
	b=adLMaDmewQwwRi1Kj2Md7r8m3HC4sFnYyxWgdwGRoyMrJjEamo2HnMuweTF5KqUhQfpM+N
	QQzwHhWXE1s/FZhDvYXy1dp3JwS9LNjrAwi2o2BZO8b64q09NjUhEjJyOOyW1WLcX9FHLz
	2mwJkVsgyCQLu0Bxuelqzn0gcXaONAY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAGKQfzg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776181058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1TDAGgzmOk8H25UKOcIJUxhIEuJydpP4AYeIgjDbV4=;
	b=vHfF4lstkQdYLgzrpw64X7/x/4o65hu3ae6w7IgqDzDio6gYhq15E7U7KfaeUcZYXak7h/
	633deMsUjAAadFYJgrcTJmxfnUva3M70tbb3rudADvrB7SayD20jz4BweLWv0+Sf65xj9w
	jctf2Szm8wH3fZzeXowl9ckJMY0P95E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776181055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m1TDAGgzmOk8H25UKOcIJUxhIEuJydpP4AYeIgjDbV4=;
	b=lAGKQfzgeioiew63mH3E5n+R9eC1bKNYhY1BlrajddJgdTLtmQ+SiAx0mv0jnamulB/1aj
	fBWttHSarXPes6jFjVQVGNOlcwl6F2y26bDpQGPgdg4yq9BE7BsqWIynXleZNk8qemiG46
	L1j3NTnooylL4ejFk0HNXT7EkZrFaAU=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Tue, 14 Apr 2026 23:37:24 +0800
Message-Id: <20260414153724.35950-1-lance.yang@linux.dev>
In-Reply-To: <a2632ace-1ffd-4e9c-8fcb-803b9835d8d4@kernel.org>
References: <a2632ace-1ffd-4e9c-8fcb-803b9835d8d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kr7ctczmi4pzez1zqjjhqohskh5xtjey
X-Rspamd-Queue-Id: B7D87180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776181057-718348
X-HE-Meta: U2FsdGVkX1+CnjXb3pXa7un4U+Buld24NAzPlai0ZC8L/dE/TAV0Idh6i2vYN1/3pg03b/kL3V/7RO7ogqNfQ1F4dVrKnPA88cO1fHFDCGa6R3oRIRfz605kCV2iSBHCzEZ+izDnUuS2GkW4fepUNjDHhzXfCbFBtMySdsgZuoomRxTVD90TTHoHGTL9CcX4uWrAP3PjcMX+eReEmrbsAAaYrzs0BTaHGVTJeGAXZPuek7s2Ddt0zoravj/gP/jcE05IO5Pka+jshI7v1vTBBmW5xhj6lpbPabj/MaCBliNQczUTSdnKzZlwjZjmUpjhnR8x6xNGfE9vLTmhXDgGLcYDLCSItcy/isFcT0IcSaditdUciEZnyQzHv2ANVaM0irKRxf08JrtSw52w15BpudeG8AeTrv5xszralG++uToT4F4PDjnJX3BHoSEPHW1vj58wQ8ZxsWsSmBNR1lc50NEaiJ4xQHDJJsf3XjxL9HbNSh4sVtXvPvnycg7TcoM1tqEP6bSAurz96uer4sPVq0fLwnSqQ0NGu5Adu6cZu/XKlFLeuisZhF6F+OEfcZEYulJK/HFuHjEcMhohO4OTDkSw+YOPa8OjQ+j2MvfgIZXcEh2Wya4Iec8UqnzwSIHYNL6K5ZZDI8mWZJJCHHwWSGt8fFITlmRNr26xX265VrBgm7xcDRSw10vrR99fLu0anUrcq+SBGUId/MEUa/oGMy2dJE206t6Ao7IOOXfjlrUY4cwdpSeP+9BDvcH8Gi80AjGzIVSCwkPqm0NafoNTJTLOkHkSO6dheIe8CFSlMTMzK9sVT9Qxg0SOoG9/6m67PAUvDY/qPanfhLxWshB4tL15R1zVSbiYFUufGY8c9lLYopVx44pwDN7cd920jVjvSf6jxiCUe8FDfEb3ylZzmwFB7gMJHlUcH2utvr3UJL/yF4kiXHoAfkqdNePC7vO4IND3rvphrsLSETMpMuc
 d8MLmQNG
 +pa5f4B9U7Mn20Vou0UVY4KJcNhsUZyElEq9XHip9SdyI5CdOCldfU1+PA8CuLxPbL/brl+18PIMaByWI6vKpxEKUCBLCIPsP2rue5k6aBsTpe1e0bGDuU/2cGM1Qho0+wTQsYnplCG4ImYx749kIb4vU4EF6mDjBKoSIoDkTeO0giSeFRHRc9nMoRvFTwkc05FJ9oWscRwP2S6mJnP58qL+GHlXLpmy/ulKIyruQug4cX8zYOkETiteOVZKSF+TtxJ8hcSQM8yBDaKFndX7Kth9gSdAxMlvnDglFkj/L7XJ3xyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 14, 2026 at 12:29:04PM +0200, David Hildenbrand (Arm) wrote:
>On 4/13/26 21:20, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>> 
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>> 
>> In collapse_scan_file(), add FS eligibility check to avoid redundant scans.
>> 
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..d2f0acd2dac2 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  	int nr_none = 0;
>>  	bool is_shmem = shmem_file(file);
>>  
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>> +	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
>> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>  
>>  	result = alloc_charge_folio(&new_folio, mm, cc);
>>  	if (result != SCAN_SUCCEED)
>> @@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>>  	int node = NUMA_NO_NODE;
>>  	enum scan_result result = SCAN_SUCCEED;
>>  
>> +	/*
>> +	 * skip files without PMD-order folio support
>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>> +	 */
>
>How is the !collapse path handled? Through thp_vma_allowable_order() in
>collapse_scan_mm_slot()?
>
>Wouldn't it be better to have that check exactly there?

Right! Looks like patch #03[1] already does that, as David also pointed
out there :)

With that in place, regular files should end up in file_thp_enabled(),
which checks that mapping_max_folio_order() >= PMD_ORDER.

For khugepaged, collapse_scan_mm_slot() calls thp_vma_allowable_order()
before entering the per-PMD scan loop, so ineligible regular file VMAs
should already get filtered there.

madvise_collapse() also calls thp_vma_allowable_order() early, so it
should get the same filtering before reaching collapse_scan_file().

So the extra check here looks redundant :)

[1] https://lore.kernel.org/linux-mm/20260413192030.3275825-4-ziy@nvidia.com/

Cheers,
Lance

