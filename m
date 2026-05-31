Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFE9CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 20:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD4F6B017F; Sun, 31 May 2026 16:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5A76B0181; Sun, 31 May 2026 16:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0B26B0182; Sun, 31 May 2026 16:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989916B017F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:02:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CB5F405D8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:02:24 +0000 (UTC)
X-FDA: 84828787008.13.5FB7CE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 694D21C000E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:02:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPoX9hoS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780257742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+kQsErqGbRV4q1yTjSudUgveQYxJiNOKFMvO3C/34w=;
	b=JD6iPAJk/HY+8v1vEjQD7qjXU9YBZvPzh//Aga6BUxoIG+RbVTZ2QWnBs7P6zMCkECyHGr
	8VFkg2DFhOLF/TJUFsKZF7ex30VrdSNLwPoxFlKzNKusM3UWL19fPKIqRi5gw8wfwHRpM4
	VBSHapj8KtjfY24l0Y4695SWspLze+4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPoX9hoS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780257742; a=rsa-sha256;
	cv=none;
	b=ZxZ9+iwz59/3H/FZ8d7J+Kd9CHRDwN7tnTpQgq/mtUTF/X99HLAo1zDZPpIl+u2KLgEUc2
	WCqqzBQrWQeaEKSv3S3buQoDWPeg50/gt6CaDT/hNc4f0csqQP1SwJawPhuiksYDcTgikb
	5IugcPNeu3QxQ+gmRziALirtVbVM/a8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6414601FE;
	Sun, 31 May 2026 20:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E301F00893;
	Sun, 31 May 2026 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780257741;
	bh=T+kQsErqGbRV4q1yTjSudUgveQYxJiNOKFMvO3C/34w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LPoX9hoSuHAevhuAsdaNtw7K5pNs9DDP1Iv4g0ypR420Z4m+6X52d1pLhKSnlHAZj
	 hsQBOfbXCXIlY7RGzxW72Yd5i8A5IYl01u3AQDe/TdXUwJkMmambVbpBYwC6KqgW4c
	 MMBo9n+p8b3sr7q4XSyuMJHaexevO0WlycVCyyxAf8AQbpuhhtfh0QJwdRAMpM0CGl
	 Ibo4DaSgoTPhRj7qGpF79Hi+ftM5Gmqk6X+V+pvbSQ0BtCTsNEy4RquvWwYdZhDBoI
	 N8RWI14jMPca3RI6bdDCNgpwleqWHGFS8zTjH9vxQ8b4KzftsAuDvWkxkqmyIb1g6i
	 1N2+leEyRP8CQ==
Message-ID: <65e201dd-10d6-43f6-8758-0fc313158fe7@kernel.org>
Date: Sun, 31 May 2026 22:02:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 12/14] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: Lance Yang <lance.yang@linux.dev>, npache@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <20260522150009.121603-13-npache@redhat.com>
 <20260531073102.20318-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260531073102.20318-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 497sqrh77xyrid3196zucumoy9bpqgee
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 694D21C000E
X-HE-Tag: 1780257742-220331
X-HE-Meta: U2FsdGVkX1/7B1qGZSr4Pu0n0CG4wfLzSRnF6n1FAB4J31iWzp1SowFSQFvltyHvvrmqcyPUYOcV4112qaywEg0fffP7DCsOdtWcJvYcGuI7KM9MHEGqZ5Zr7Ke1HaJffFLjqeUspI1UkIkxKCdxdG//Og+Mc5cLCcBQwYw08cv6d6MaYPqLWZeX+sGT1Z0EE/ezYqHGP5PyK9+nH0UYYvD/cWho1DLcLpHs1Q3mV1uWaN0EHOPzCVqS7fznvJBbPHfBztsUaSAKdFd6RqioYrfOxkHsRSbvEaYJ87olad12Lt6HCbCxyxdiiYIj6zfn7eJTuoKqOXcpt5zYUAIJtQSyBkOK2sH9bpX8UcZ8V029cH/750x9G2SN5hjRneeSDTiXRP370bIBV13NVABkVKltoXCdP1mL0XPNbLQ+/BSV+fBdM5xEZsdASKyf0S0b2YRZgqqdlnAIPyW+D/DCwznziKEIy7JnP57KpkmipB/Hhk6eVlfUeXd4oTlrVlYieRQ3CPvPKgotKlPhYHOGM1deEwE+yH3DROoGgR159JBVabSt8qK0EZ2A98W5Wsu8QL7ExWpHsi5Jife9W5UOLV4YzYy/y8iVem7slZnu6LFBz6FerEstkoicwSxyQMj/KxuAzYywyZoFCxjvXg1ghCekBZEeVLMO/N0BMyacAWnj6d/zh41MlKrohMRJ39JN2I6HWZyp3CeYdX9SoFKYfYxJ0BUp1xZ7tkbQx+nzTOBQUuAmdWXwe767L3Y/+dluFXcD0mltkzN07wdsLVjYOuQJ2/xaV0B55Hiy/cDuMCafCNB38GxwontQibltjDegiPDrFdaoy5TbKjueVmb1RFPb1P0sUZVNQDGaybgjdJ4qUZVSzPqLxu0QbPnXeU2vBL/bWj+rvEzC9b+K2ZjhvZZoZXQx8frlE6pgGYT2i9vUcMFjKBt4l8ugLcWlRwE/7pK5C6tAbiefi4KC9jk
 x/LGPR+x
 FVAxo3eI5rkaw4hGrb6+o7Husz2BDHuxMS2sMVgbS/5wiV4mZ9Zks0KuZkJPV88E3/aq8oauOcJ15uvYM96p6ixyYDtByoGSUXiAw5qjE8xH5d19r6cMA5sPh1q/eeeavBJxcBBJPWxhCa0YsPP3bO0y5GtjCVwqWNxlK7KGeMwKLBOgL5Y9jtwUoEIR3Vlp6TnkIlb9ZrJ01Ayw+VM4cWgl6NkIIKijt21kprrw3G7+CT1tuaZeid9uqRoRj+dK8hc5RlMgK4SIZxS0bE8mzQBtrPev2Xx2oFUjCfjc5S1iD2rObJVPs3P04ZZ8bd+uKRo38hylHbwMDp/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 09:31, Lance Yang wrote:
> 
> On Fri, May 22, 2026 at 09:00:07AM -0600, Nico Pache wrote:
>> There are cases where, if an attempted collapse fails, all subsequent
>> orders are guaranteed to also fail. Avoid these collapse attempts by
>> bailing out early.
>>
>> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>> mm/khugepaged.c | 24 +++++++++++++++++++++++-
>> 1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d3d7db8be26c..15b7298bc225 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1535,9 +1535,31 @@ static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
>> 			collapse_address = address + offset * PAGE_SIZE;
>> 			ret = collapse_huge_page(mm, collapse_address, referenced,
>> 						 unmapped, cc, order);
>> -			if (ret == SCAN_SUCCEED) {
>> +
>> +			switch (ret) {
>> +			/* Cases where we continue to next collapse candidate */
>> +			case SCAN_SUCCEED:
>> 				collapsed += nr_ptes;
>> +				fallthrough;
>> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>> 				continue;
>> +			/* Cases where lower orders might still succeed */
>> +			case SCAN_LACK_REFERENCED_PAGE:
>> +			case SCAN_EXCEED_NONE_PTE:
>> +			case SCAN_EXCEED_SWAP_PTE:
>> +			case SCAN_EXCEED_SHARED_PTE:
>> +			case SCAN_PAGE_LOCK:
>> +			case SCAN_PAGE_COUNT:
>> +			case SCAN_PAGE_NULL:
>> +			case SCAN_DEL_PAGE_LRU:
>> +			case SCAN_PTE_NON_PRESENT:
>> +			case SCAN_PTE_UFFD_WP:
>> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> 
> Nit: shouldn't SCAN_CGROUP_CHARGE_FAIL go with SCAN_ALLOC_HUGE_PAGE_FAIL
> here?
> 
> If charging the current order fails, a smaller order might still fit :)

I think the reasoning was here, that if we are already that close to our mem
limit, we should just give up instead of trying to squeeze it in .. :)

-- 
Cheers,

David

