Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739B010A3D81
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F006B00B6; Thu, 26 Mar 2026 08:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56086B00B8; Thu, 26 Mar 2026 08:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BF56B00B9; Thu, 26 Mar 2026 08:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4E2A6B00B6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:41:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7893F160B6B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:41:29 +0000 (UTC)
X-FDA: 84588175098.13.65AB2E0
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E48D4000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:41:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4yXwAFX;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06KB53lThvomRpyYQxy3Sh2rJb39T5D6WNpA7eb1gCM=;
	b=Z4gyMkxMlTnrd7rdkszBYgAbsd5ekrf825bxIkiiZadKCKwG0SEhAcVps6DT4zhWcpkH/R
	VVlZJ26l/bphE5BMkhtVFitl+AOavl00r1vb8aAi8z+2dK217zNeFo38zjWvLJExFgN/XR
	TWRjuqOiqZ6lEXOvBw9qKzPDxeCMAqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4yXwAFX;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528887; a=rsa-sha256;
	cv=none;
	b=1g13/uBc2kKpomjWtJXjZzwnT9OhWMQintj53weN1ee6tGvf3IIZ8bhjHAT+K2zTBE1618
	iSKhMdqw6e0vsAUaJnRrztDIlqVNG4CiIJJ2hSBx5vVwmsLBENYZhXsjaCaDr6aPnIso3l
	MoE27AQ4VmYTFYDx0irM4K5XGQi6JTI=
Message-ID: <0ce07bc5-6365-4c54-90e2-4e56ad2b7465@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774528885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06KB53lThvomRpyYQxy3Sh2rJb39T5D6WNpA7eb1gCM=;
	b=K4yXwAFXMX0fmJ8EBL0HJNpbjd+3Q1RJx589DnC0Z6DFYmyjstFt8kC+beKS2yTg3QT2AD
	0sT6NpNguoAvjDsNI17ZlCd877xod5JgPcDxp4aJyO9QfJCSdDQETFzDUiubr4AqzwuQ01
	yfW+d4keIyheJf1HUII1d5s6AvtIIOc=
Date: Thu, 26 Mar 2026 08:40:21 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] mm: replace exec_folio_order() with generic
 preferred_exec_order()
To: Jan Kara <jack@suse.cz>, david@kernel.org, ryan.roberts@arm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	linux-mm@kvack.org, r@hev.cc, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@quack3.kvack.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-3-usama.arif@linux.dev>
 <k45xs6btmt62uerbglqe665jozrtkeoklu4rek6odgxjdj63ni@ftw6ef3ug33x>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <k45xs6btmt62uerbglqe665jozrtkeoklu4rek6odgxjdj63ni@ftw6ef3ug33x>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E48D4000D
X-Stat-Signature: e9fdo7zncscwqonqkdbikxcsb8tm9jer
X-Rspamd-Server: rspam06
X-HE-Tag: 1774528887-915369
X-HE-Meta: U2FsdGVkX18vUdu/UTSXiT1+imjG/2T1t3rdRdZJcW4NAAtUngkXKJc3URyWprJKuHRvwyVPcY56ri5C8jQnn8URyi5S4uzIxbgPWXfvpAJq4GNQc9bC8nK94fW4eRCEhIIdc6gbbV+U+/3ZD83R9M8b5uEeW5GfUxl+iz6Z9M42SbSjGpC6UJzYlbMnD2Vn/AJISFRFRiU/iOC4wf694xDw0QaUVBi8b75eEggH9GRu++S8Jl+AJdRE/re65fdE+J5bpztoYKfU+3+50jqfwBSmf52KN3Hv2K969VGT5dE8O1x0WuVkQq2ktxZBRfqyIzQTmqSi/P8PAOKlL1uZEhsChcwkIuUDrZGdvSOVeQdxbJeEWTcADzTHZbWXMQ6bdVcQ/HTvyV3l2DBFq8deEe348sjSGNKIB0wRa2IgMMfkBRb3/6jmaDXrlJkJ2ctEMcRcA3rI0fv19+NeedrUyiGkL/sDBFKy1Lbet2SaixE6zFoDQTdS8KXbuU/Hfcqc9+2Kbe4KPqD80gXycpGj9xr3JneO+cIwMpiB/9YlzU1jXMQrDIJYeSRRe5sUY9Ghhc3nEbDUYcddOCZTUWyUoeHQqIxGiRkG2DR5zW6fDmH3JiAQuhzqNw0jwo3JslVejCgFmH9rAVscPO6SAOp5i4Qn73WBgRynYmre9+a+C0x3Jg9w/vbzpoDh5/ZlLeRQPBRJqj9HGVY+mCew2lBTqOfQ21S5NyNSpTKBJ2AB4VG/1UJ/xoOo8qG9tGh/5wV9YafDALaZBnRtDFdztsTLtnq7FaULEHELFLpCNaYCCExeoF+pfSBInvk9rjADsp89qL5T/Yvc/8jvgPQAxijO2mOkj46yxj+43sIfxbXLaFyTre0gzevv1G8EJAL5+pmck+htxkUPptgK8jGfZbxLQd1KsdKZ8IPnQM2Zg8PZwslV3c7JxQKqBMlC1wK+zgr9+jqBjubVtfhO8CNcJmg
 klmtugSm
 /dkUxr/RziPmj/CxZHlQBVbDTxLb3bFV1MKDem8glSSeBcGbOE+Hc+sDBTeOnFGr3E4xPPqsHZEXd355zkXD9O/JN1CyrCsBaGXsM03XbfRgiMvQ8gDpfvBRzVlnDzkKPrcxYHzHMVpHKu8trEBtcwUZ2A9OpUNJBrYCwutvHd6bhY95C7OG2cZnZ/Ag77O+td45Jdzh8cHG65tn+yJv9J/vtWR7u4A2NboELC7w4etH8Xth+HjREHkH9wB2wFDU56du/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/03/2026 17:42, Jan Kara wrote:
> On Fri 20-03-26 06:58:52, Usama Arif wrote:
>> Replace the arch-specific exec_folio_order() hook with a generic
>> preferred_exec_order() that dynamically computes the readahead folio
>> order for executable memory. It targets min(PMD_ORDER, 2M) as the
>> maximum, which optimally gives the right answer for contpte (arm64),
>> PMD mapping (x86, arm64 4K), and architectures with smaller PMDs
>> (s390 1M). It adapts at runtime based on:
>>
>> - VMA size: caps the order so folios fit within the mapping
>> - Memory pressure: steps down the order when the local node's free
>>   memory is below the high watermark for the requested order
>>
>> This avoids over-allocating on memory-constrained systems while still
>> requesting the optimal order when memory is plentiful.
>>
>> Since exec_folio_order() is no longer needed, remove the arm64
>> definition and the generic default from pgtable.h.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ...
>> +static unsigned int preferred_exec_order(struct vm_area_struct *vma)
>> +{
>> +	int order;
>> +	unsigned long vma_len = vma_pages(vma);
>> +	struct zone *zone;
>> +	gfp_t gfp;
>> +
>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>> +		return 0;
>> +
>> +	/* Cap at min(PMD_ORDER, 2M) */
>> +	order = min(HPAGE_PMD_ORDER, ilog2(SZ_2M >> PAGE_SHIFT));
>> +
>> +	/* Don't request folios larger than the VMA */
>> +	order = min(order, ilog2(vma_len));
> 

Hi Jan,

Thanks for the feedback and sorry for the late reply! I was travelling
during the week.

> Hum, as far as I'm checking page_cache_ra_order() used in
> do_sync_mmap_readahead(), ra->order is the preferred order but it will be
> trimmed down to fit both within the file and within ra->size. And ra->size
> is set for the readahead to fit within the vma so I don't think any order
> trimming based on vma length is needed in this place?

Ack, yes makes sense.

> 
>> +	/* Step down under memory pressure */
>> +	gfp = mapping_gfp_mask(vma->vm_file->f_mapping);
>> +	zone = first_zones_zonelist(node_zonelist(numa_node_id(), gfp),
>> +				    gfp_zone(gfp), NULL)->zone;
>> +	if (zone) {
>> +		while (order > 0 &&
>> +		       !zone_watermark_ok(zone, order,
>> +					  high_wmark_pages(zone), 0, 0))
>> +			order--;
>> +	}
> 
> It looks wrong for this logic to be here. Trimming order based on memory
> pressure makes sense (and we've already got reports that on memory limited
> devices large order folios in the page cache have too big memory overhead
> so we'll likely need to handle that for page cache allocations in general)
> but IMHO it belongs to page_cache_ra_order() or some other common place
> like that.
> 
> 								Honza

So I have been thinking about this. readahead_gfp_mask() already sets
__GFP_NORETRY, so we wont try aggressive reclaim/compaction to satisfy
the allocation. page_cache_ra_order() falls through to the fallback path
faulting in order 0 page when allocation is not satsified.

So the allocator already naturally steps down under memory pressure,
the explicit zone_watermark_ok() loop might be redundant?

What are your thoughts on just setting
ra->order = min(HPAGE_PMD_ORDER, ilog2(SZ_2M >> PAGE_SHIFT))?
We can do the higher orlder allocation with gfp &= ~__GFP_RECLAIM
for the VM_EXEC case.


