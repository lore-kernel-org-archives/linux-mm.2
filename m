Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D05F9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085C06B0089; Tue, 14 Apr 2026 11:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FA16B0092; Tue, 14 Apr 2026 11:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A4C6B0095; Tue, 14 Apr 2026 11:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD2F96B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:43:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 619CE160172
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:43:30 +0000 (UTC)
X-FDA: 84657580980.26.95EDB27
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0051E40014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:43:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a+Zoy3/H";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776181407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xofRIGZTZWakFR4r7hnHb6VQphFQ4wt9gOLnTsomTno=;
	b=S+OB5GW08w2xDBsrzAavUPJsZW0cP69zj/I+2nL7I8DGSfCdPxH2ctvbqQ39bjhIjE0yPj
	GAyuJqUMp9EXLcBgSQS1Fda44O8CFJHSbpO6K4+gY10stm5/VTFCXQMrPyCQJoE1GeNkkc
	FmfLi50eoEAF/ivTdFtuAb7czArdsE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776181407; a=rsa-sha256;
	cv=none;
	b=z9OYqfwDUvr6kjaBkVDrnmhOmuTTFSdgQEpJ7es/ZzMizVSpSfnntUrglYw6+ist+SNTQh
	P0PAObJ30JbvtSL2X5NctnAJVPAA09bG+3ERUHghSJ6O/JxKmQ83VicZ98gOhHPHkquIls
	tnM1xYdd2u9XLIT9J/2glah7ra1Q/wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a+Zoy3/H";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776181404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xofRIGZTZWakFR4r7hnHb6VQphFQ4wt9gOLnTsomTno=;
	b=a+Zoy3/HP0If3I2KC+z/xy+o4Zd3PZ4Kc0jqpMBHxJwT2FNA1df/rmFfyx81rcasSH+5Hv
	3D8TW/roWmTFaZKQaN7FwnaCG0eCBFeUrBT5hmsEqIkTCywMek5EgN3BWqJqRa7+KXE8dh
	ISMIBMFQ06zz7nJpwbC5FH7qif4qJk0=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com,
	david@kernel.org
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
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Tue, 14 Apr 2026 23:43:16 +0800
Message-Id: <20260414154316.42935-1-lance.yang@linux.dev>
In-Reply-To: <20260414153724.35950-1-lance.yang@linux.dev>
References: <20260414153724.35950-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0051E40014
X-Stat-Signature: d8gn8n7g3c611hd771i5zq85ttakcngm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776181406-878093
X-HE-Meta: U2FsdGVkX1/L0tjLj9oec0sfWfhdI3A5TUd9o0jUcZBRWai/mul7Ba/vlFjFa/uApoyK6H0B2y5be6gkS20ySrsqq+J2yWg5Nv9/GTCjpajsXVNEDg5nJgo0OZEjaLTe0ME9SQ5gw8eHlylatBQ4l8wjceqPcC+XViXUp8CaXEe4n+47GuUMIhm0kfGCIhDKX0m/CPzZtWXEeoO11sar5DCE7E9/fDfSgxbY3ZSahDZ3kluDj1KbZx0aF1Iz5J8FVFdMb+OXwLit6qeStzmMkb4NYuxnfTT/oo46ojhNTbjINRrFW0gUVHy08LLR7qWc1pEHnr7xp6EYdmh4+eUKLFwEicGt8MR9z5EnX4NDMeB7VmZt3LuS7hWgxj7850J9wO2UXKYjnD3ZzaNQKVH/h0XxiGnE6fFZfdh9yPkPye/pnUTTSoRYU1VBzdKE68BIpYHVezFrG0bEUxtq9cRmmqdg5C3R4o6oCDljlHrDui48r6xrzrr+XpTvrKDE1sBbcnPOnV9XWzwopXoQ0OWmvd7J0pvEoHeAO9djzIMZ8FQzyxe7P7v1cN5IrCFeamjv9FQLEXaxOT+MPhzJAtx/LSvunBe5KFtWDi8zcq5W+r3FRNiBT2U7RYPXTbFDE7UHwAXhpXjm3WuA7ZfYAAcsh0ExXnNst3Gi+v4onK9YhYTTAT81x/3e/0YDTGlwAGxYITjI4XwHSwjN6N+MEhNLIV5ZPqsch2SIE7Q6JQm+xzqc8ti2JcWYVQfylxPFcQSZrv7dNQGRFRRV5yhc6wu9zp7plz2OcF/oTaaDuTAajLNPdQ8TAD2yE7ZtqO+zOzPTRjVGKTtHC5D/iiFlNvaOSau0zei1Af5djf155csLxYCfCcg0SKtsIFzTjG0NmajHyvSzSGS+j+ja6ExfZepkypcgVCLfKYF4bZoj4MIrZ1EaEAhMzEC0rarT4p27WJPOiGRaArKKjHGn0Dscslg
 16VCWjmE
 o+9OmFojjB82KMNMbMmBkz6i33W14vI37ARSt7wWhdbtle3gyRch/mNCtbqQtI/g/JSDMA1RYDXQLvAUHjBVCK6/NcYMwuPXZ01RYk+nkJIXmJgotYQ6D2t84otNdMeMIhp9662+0zqRVZlV3BV4L5BaWIc7aTl0Thw+ETdsDfwk3CTHXWYkMiMomhHh7VWeY6Ix00QwSxfjW+dfnNhLxvDygM877YVnUGVQVjHaxDKzkWakjIr0bVx3gOswbFX6Y/LZn6StyXeYyppgFXneGByNoRGDG2AEkab4l50EaF3VrM1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 14, 2026 at 11:37:24PM +0800, Lance Yang wrote:
>
>On Tue, Apr 14, 2026 at 12:29:04PM +0200, David Hildenbrand (Arm) wrote:
>>On 4/13/26 21:20, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>> 
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>> 
>>> In collapse_scan_file(), add FS eligibility check to avoid redundant scans.
>>> 
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/khugepaged.c | 12 ++++++++++--
>>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b8452dbdb043..d2f0acd2dac2 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>  	int nr_none = 0;
>>>  	bool is_shmem = shmem_file(file);
>>>  
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>>> +	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
>>> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>>  
>>>  	result = alloc_charge_folio(&new_folio, mm, cc);
>>>  	if (result != SCAN_SUCCEED)
>>> @@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>>>  	int node = NUMA_NO_NODE;
>>>  	enum scan_result result = SCAN_SUCCEED;
>>>  
>>> +	/*
>>> +	 * skip files without PMD-order folio support
>>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>>> +	 */
>>
>>How is the !collapse path handled? Through thp_vma_allowable_order() in
>>collapse_scan_mm_slot()?
>>
>>Wouldn't it be better to have that check exactly there?
>
>Right! Looks like patch #03[1] already does that, as David also pointed
>out there :)
>
>With that in place, regular files should end up in file_thp_enabled(),
>which checks that mapping_max_folio_order() >= PMD_ORDER.

Forgot to add:

thp_vma_allowable_order()
	-> file_thp_enabled()
	-> mapping_max_folio_order() check

>For khugepaged, collapse_scan_mm_slot() calls thp_vma_allowable_order()
>before entering the per-PMD scan loop, so ineligible regular file VMAs
>should already get filtered there.
>
>madvise_collapse() also calls thp_vma_allowable_order() early, so it
>should get the same filtering before reaching collapse_scan_file().
>
>So the extra check here looks redundant :)
>
>[1] https://lore.kernel.org/linux-mm/20260413192030.3275825-4-ziy@nvidia.com/
>
>Cheers,
>Lance
>

