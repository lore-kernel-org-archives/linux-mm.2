Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832E3CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0A38E0029; Mon, 29 Sep 2025 06:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91268E0002; Mon, 29 Sep 2025 06:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80188E0029; Mon, 29 Sep 2025 06:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1E258E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:29:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52FCC13A8DD
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:29:50 +0000 (UTC)
X-FDA: 83941916940.26.1D9952F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 734C7140003
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:29:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wy1pfPgs;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759141788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUhtBwI4+jsvsk1lD+y61YKvfckMQnAYP5yAxgvSD1Y=;
	b=FwNEoe+2gyQjAFtNQr9L1iY3+tvkXnvAkN1WyG7UxIpPU4lsV2nqqCi0m9tOevhoAHYQLq
	H8P3XdbD8LTN8yL79Z2KAaCvSIBPMTuYFMPcwwLJpA32MrfAbcU5FXSxyAjXi/pKEEgnjN
	5b35U8eoYeRQ0mblPES/S+Lt6HHpbe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759141788; a=rsa-sha256;
	cv=none;
	b=4Xjh9vHjayIRcz8wgEsvkiqawUzTcjnMwbhCgKOUBRcVACpIoHb+JQ8bIt5ltcrtKkYKLh
	1h6L4VVlmqq9oEpvsp3XmlI2aEy7GkciKohE/AkVF+kT8lxuuNmIO4r4c9JhdyZyTtyOcZ
	xR5vPyQya66qlU/8ASPIsZP+KdNe/QE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wy1pfPgs;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <900d0314-8e9a-4779-a058-9bb3cc8840b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759141785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUhtBwI4+jsvsk1lD+y61YKvfckMQnAYP5yAxgvSD1Y=;
	b=wy1pfPgsXvK57QzoBeqr38f+zuFNCl6FGSxmZUjM9R6wCDpTZ9t0hX+gNSnKfZRrtSEzA2
	vMeMSkorolNri5VHunRvbqe4Jdmtwk0/YyW7YagrfXI2cfA6FZd0GNUORN+sUTg80Ry2xf
	dJmG4C3A07A0TWBt0xR4IUcaf1bOrc8=
Date: Mon, 29 Sep 2025 18:29:33 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
To: David Hildenbrand <david@redhat.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <20250928044855.76359-1-lance.yang@linux.dev>
 <b19b4880-169f-4946-8c50-e82f699bb93b@redhat.com>
Content-Language: en-US
In-Reply-To: <b19b4880-169f-4946-8c50-e82f699bb93b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 734C7140003
X-Stat-Signature: xhyb19f9tuksx5akmj6a1y1191eztoca
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759141788-882096
X-HE-Meta: U2FsdGVkX1/2oMw6u951XAZXyealXOOy9DZRqyMBzCU8YH7+7S8u8Phgu7aj97GsKVXmh3W5Rw/mARycaLV+jDFlIYokcR2ycI1YmCpDuFxiuymTWz5NgxpXryOgL5fsAzgfJy6RmvDK0v2lx2s/qE9SFkz1GxcXi3XAoNlmMg32YRZvHW/iKnXG6XwUAwg381Rkp1ZyBEZP4BBy9UA8NThkgr3pvs6Wf5dwBeOUZu2Q3UOloKmQf8VNvJPbMoJF7PBv5P+6TLBo1d6hxsLm9iMTLbpm+JBudKka+cbcuRfCP85MnjTdymRVy6PsgODKK6uCMaOZDjBo2CPURmXjLmslJeL4JkjjWAb6X8AR+bGH4jav6jwnZfxkc8jtLy0zTo5mhgV0CsF4LxWMfjlhhF9aZhZ+ZFmigodnRbrTZoP+WPut+HgxyW0CzRl29ToA8mg2VLZT2idwsZ4womNi7cSyXW9rWIvKEgiR/q3gHZc5xHaBA6JciyisBPiKr/y2JKEAyyqx6+XUhy+oAbkfj8YbMT5ZUtd3WVkTvJm8qUqm1mYKLQPmAYoHmZybmP1YNhR64PquqnHVSCdzV60E2LAUxNoDCgyqcrTuSnSEsvSRgxgIc8DiYIbQWDZW7OIAlvXL+Qsr0ndYOqrRKqBQN5ZIhe5w6jgYDfbhM5aW8O6EJrGO/LYchLst6PB4ZQFkyyv1gZMLqoe035Ph3Dbq3y5svZmOtoB5BqW+gzttFkhwi/0zJ3eZu79gwRC5hx1LCp5OGAqRslRx5BHTzyur08DiR2aFzYUf0xGF3uhJ8QDg5uW6hUBG4zD4F5QFg3EKuJVBm/+WnfIex5eSUpKXYDxfcvTiQoZMFTf1oHY9tz8Fq70TO8/sZ0DTl9R1ZLISeckaKvlnKNMhNab0b0uA2GPAHBbEPmK434W1cm0BEmz8moexJlP3iYtww4wKBhYHxyibzzlTw8qUeBfv9sS
 OfxxGEvf
 YLMrq8k7wtIFFOfSWw0MxJGMmN69kIWn07YzH34f08LxAdTTs0ailcsthJF4/oA5EhKEkPceU41/0KvES9TzU1OFm2ypITA0tJZE/7ZImRNmK/bXYIlc5uir5qZzkHNInMn98jusCAElxYQloyo9re2O1Bhzb2QclRtORx4toGwdhvgfKpqGQ2tB+Uvf/tfj3T2xC54FAC0Ng/KR72mb3WpJSBmjtMfjoloEohy0r+chtV2/DgEXeYMxoqYG1PgR0VXdadb5Z/KDSGioVyS7YtDR6W+40tLu3/S4tTRwFnku2IvQzhzPVHM9sZfdX1kDmG0uoZAEbESVckl8cNxWWmc6uPShQ+oMCvepR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 15:25, David Hildenbrand wrote:
> On 28.09.25 06:48, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When splitting an mTHP and replacing a zero-filled subpage with the 
>> shared
>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
>> bit.
>>
>> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
>> incremental snapshots, losing this bit means modified pages are missed,
>> leading to inconsistent memory state after restore.
>>
>> Preserve the soft-dirty bit from the old PTE when creating the zeropage
>> mapping to ensure modified pages are correctly tracked.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>> when splitting isolated thp")
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/migrate.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ce83c2c3c287..bf364ba07a3f 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>       newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>                       pvmw->vma->vm_page_prot));
>> +
>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>> +        newpte = pte_mksoft_dirty(newpte);
>> +
>>       set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>       dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
> 
> It's interesting that there isn't a single occurrence of the stof-dirty 
> flag in khugepaged code. I guess it all works because we do the
> 
>      _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> 
> and the pmd_mkdirty() will imply marking it soft-dirty.
> 
> Now to the problem at hand: I don't think this is particularly 
> problematic in the common case: if the page is zero, it likely was never 
> written to (that's what the unerused shrinker is targeted at), so the 
> soft-dirty setting on the PMD is actually just an over-indication for 
> this page.

Cool. Thanks for the insight! Good to know that ;)

> 
> For example, when we just install the shared zeropage directly in 
> do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.
> 
> Now, one could argue that if the content was changed from non-zero to 
> zero, it ould actually be soft-dirty.

Exactly. A false negative could be a problem for the userspace tools, IMO.

> 
> Long-story short: I don't think this matters much in practice, but it's 
> an easy fix.
> 
> As said by dev, please avoid double ptep_get() if possible.

Sure, will do. I'll refactor it in the next version.

> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

> 
> 
> @Lance, can you double-check that the uffd-wp bit is handled correctly? 
> I strongly assume we lose that as well here.

Certainly, I'll check the uffd-wp bit as well and get back to you soon.

Cheers,
Lance

