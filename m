Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA09CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 08:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8396B0111; Sun, 31 May 2026 04:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231886B0112; Sun, 31 May 2026 04:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9C26B0113; Sun, 31 May 2026 04:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFA196B0111
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:48:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88D44120294
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:48:37 +0000 (UTC)
X-FDA: 84827089074.20.15C1DB6
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9841380002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:48:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aoIoHeGS;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780217316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtWyv+l/PUjKD80QEnpdDAWmHtcb20b8E/xmF2pmiZc=;
	b=XmT+OfDjiwABif/XEYz+wxPrElMi5mM4vdxhfN1DwRRwY+nMo8O1YBsnC8+YzQqEWIkpro
	b6uczF/mUOmPAffYyWBAxrbzc8XqlmtulkBq9z4AxlOWKx25c5+frtePElWfYqAVq9a3CI
	jJ1ejYG5yev99f0TFQ7C7Yo0BNtEp5Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aoIoHeGS;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780217316; a=rsa-sha256;
	cv=none;
	b=QnDjSyx+fLTZG24hHv2fws263RlIl9AT1bae8vv5FNTZ4Mpesyr6KrmTptceDzArMztTBn
	k9EdhvkrbZ1ABVIdOBvgEyU3KHOEDGPRx6s3GYzddJax1FTaI+rJPMwlshtBvvtp7ZMm/E
	j8dVeevfb6koxtCK52YO0q0j35Uxs4Y=
Message-ID: <6a9f062c-8376-4f83-90a9-8b167f925dc6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780217312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtWyv+l/PUjKD80QEnpdDAWmHtcb20b8E/xmF2pmiZc=;
	b=aoIoHeGSPv7WJAUGcwp8gvMotVzsI7iE0R9cK8zt8tCXV44otjV2XtrKmsWdhCusYmakor
	0G8XAsjLn21UL2vyqYY9VyPR0mcD7GaqVNcRo7DEf9pLj1qvz2RziNjQmJnHOjSQwtNeav
	STvc2+9ZkdHUwWEQ6I4akRieqYKUEvw=
Date: Sun, 31 May 2026 16:48:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-12-npache@redhat.com>
 <20260531071845.10875-1-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260531071845.10875-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9841380002
X-Stat-Signature: o5xxi19aa41na4ez1848ae1q1fgn45hk
X-HE-Tag: 1780217315-759200
X-HE-Meta: U2FsdGVkX190hP03leq9bvo9XB80fSctE5yQyKSrAXA6n//8062QfAxrpMPM13zUUQ7lFFtFJLDkfLyUWWK1Qignu1hMLrsIaifr4n71sA04NbLl77VvNe3zYkPs9Enbe9h0DGaW2BcriIXGY5nyiv0yBeVDeU7BZaoVXP0aSMRaE7tE9xeisFEF8s7ukKzAwLn9zT+f+rH0SEDcZ9jH1tEEi7ki0AZ9nCE9CW0OZ3WO+E7qSf5rqAx00Qh/RqECiUr9Ksg3DPPuNf8oqeHGWLcg1DivOq3nptaiZWcLWufF+DeH4Q4hUihiwmwOsx2N51UpIFSDajjU4555vhvh68Wc3HF7TBGa7hy4tezNwoSmAJG8cwr42RA6y2hK5cVq0JSuoM/xmu89Yu/9AqNmF364QaO3cNbf7A+nZiMr96zxl1PjMJqvgMdwLQObhfRAbjnkyjaDFmztCHkDfMcCHDnXZH/v7Cegdn/5pXkhqakDij+S9c/1CjqmlhJ7FE3ENhwCUcnovJFc3oCnKvvONVy06cop+rb3gon2aVh0mUuzaHL4K9IbWts3fpL+9eA9d8oAyk2ieOHTpvCC4HlVT89LQf6lV0qg5QPUjnjaMi8yZhiCYdr9n1n+yd+T8+73z5596BRCNVEVEYdWltIJEIubZm2U1f+1vNcPZyNflcNawmNCK1HnUtu0PYMlkGnC/3SZNZYLa6vHZo274Me/vrXgWKhP6/jTOTLfdP21BGPcVz/RT0tuJlrOIhl/igry3KQ7gsTFFC8Fqxl2WsEBzzSlcbfUHneMuybyU+GwO/t0FMYUp8K/JxNIvUa3QSCCjkkuk1w7YB/CgNcXmt73940UimulziQjcYIdpD9xVhY0kXTbP4WyaNOR8ZIqV7BexOVoO7M78tM7xR7kV90rx9pALN+4HnViMAe2uFM4KEZe/s4v/IFEQPtDxrhVNurH41tMgpBQ0hstHL0Yika
 y/0jDxFu
 kzl5deYy1PkqcPaGsFffcoBQH4uDppc2m4Lwh2ZEazxHlJLJ98sBe7mCGO14kOyAUuHGeB9u3OzIPpu+9XCbg+b0mdIFXBgbvqd6IN+60pBSAM5MZb2dVTsJw6IvwEo1oYulW/joOb8B4ShAyqhbSLnDCSfMklAybhQp9Blna3gZuCDp1pQAnfdsTKkpYmLZaEO0U6xE1NV+mmIVPtMXJiIqJ8KigDqQkUrvon5j1iyPlWuFL6C0P30+a3V/ykbsvppDgzAEjI2rR5HEVubP72dDahg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/31 15:18, Lance Yang wrote:
> 
> On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
> [...]
>> @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> 	if (result == SCAN_SUCCEED) {
>> 		/* collapse_huge_page expects the lock to be dropped before calling */
>> 		mmap_read_unlock(mm);
>> -		result = collapse_huge_page(mm, start_addr, referenced,
>> -					    unmapped, cc, HPAGE_PMD_ORDER);
>> -		/* collapse_huge_page will return with the mmap_lock released */
>> +		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
>> +					     unmapped, cc, enabled_orders);
>> +		/* mmap_lock was released above, set lock_dropped */
>> 		*lock_dropped = true;
>> +		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> 
> Hmm ... don't we lose the allocation-failure result here?
> 
> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
> in khugepaged_do_scan().
> 
> Now if allocation fails and nr_collapsed stays 0, we just return
> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?

Looks like this is a more general issue with mthp_collapse() only
returning nr_collapsed.

For example, SCAN_PMD_MAPPED used to be propagated too, and
madvise_collapse() treats that as success. With the new code, if
nothing was collapsed by this call, that can also become SCAN_FAIL ...

So I think we should keep both.

Cheers, Lance


