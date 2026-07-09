Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA56C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9166C6B0088; Thu,  9 Jul 2026 05:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7126B008C; Thu,  9 Jul 2026 05:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7A46B0092; Thu,  9 Jul 2026 05:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC716B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:25:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB2E41A043F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:25:10 +0000 (UTC)
X-FDA: 84968704380.04.B7CA1C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B64251C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:25:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VrC7iemp;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXU5bAkjcEfm558OIfix+71NANWmyBlMfRmCGCUrFf4=;
	b=Kk8JuldvzUvsus2nJj3D2stoWJb+N0kl3qGnF3hfZOPAM9MUOR5hRJDE8lh2InmsRU3oIT
	AY9b993bjgkrAlcfTeK/R7ijk83Rp8EJ8d4O/gXfwehfPHZnzzP6Gb/fYIcgCc6G1tHU6j
	QIejKRezlYj1RPu5KhjmI2hyMkafjIw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VrC7iemp;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589109;
	b=ACrB6gqwmdtP7wSBMgwPaH3RuUXWXQldix2FgkqixlKJwjlAK5giGo0eEmvaYWiaei0n1+
	o/rKFijYXcSHjP54zgK4xAeGlFPli0cJkYeGKPtTUZ+QGNAHzH94Ceol/UIzYfsLMNSHC7
	ugYh8ftn7p90f3opHRGUE6UbVOtcnZw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FCC9357B;
	Thu,  9 Jul 2026 02:25:03 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2F8B3F66F;
	Thu,  9 Jul 2026 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783589107; bh=P6N6xO3jiXC17j35RozzgSiXhE/5ke2qgViVz/0PmXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VrC7iempF4TXRSX1kWqoiXsHnH01XpWNbyVdeZ5LtBeGHQU/ZLWMcjNuWVgAnz5kH
	 Y/uoNHUZVmg+A15K5lQ3TXSmUjktXyO/m8vFqyYN+Qnbdehbcd7uJ2EwtzLfeY8LnV
	 DbOeboPfAdk0qZYZoWLIlv+gHa307jgmwoMS9vjU=
Message-ID: <cf1a9870-ed78-47ef-933f-5a5fed18f8e2@arm.com>
Date: Thu, 9 Jul 2026 14:54:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
 <d7cac057-c270-4b3d-bc9b-c3503c5b6f50@amd.com>
 <d3f79924-6ad9-4b08-9669-c6acea584147@arm.com>
 <9a486b16-e4ee-4f1d-8686-022ef34a186f@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9a486b16-e4ee-4f1d-8686-022ef34a186f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B64251C0009
X-Stat-Signature: eqq56tos9tnm8hgdh4sjykb5nufqzmwc
X-HE-Tag: 1783589108-675966
X-HE-Meta: U2FsdGVkX19LJRxrRSgpiaR3s5Vv6QLCCSWsoaBM5Lgo8TUP7wBpBjEBrsDPtjGsJz6elFwQWdHUCJkb7PI7QZBM5R5WDrA/FABjFI4sxMWFxwOrv3bWkgnsms3yLFEtd0dEohdH9tGttg4zqJi9l8uMB5w/aFN3yjSyRyJeDnvKh14me1uuRqiB853NA0qAKA9zHZjwPH1Gbu4qPWa6OBONeRV9dWdUMFRJXvie2ixi5aBer2sSndIYGmKRl5ZL9xxJlTNP5+18feW+ArXlyThJAlvNMBD0K7Hs7W1NExXYdD/NK1QsXBAqfeIsLO8i3fTBaSUeIbgetntixWR187H8iceyvSHoLSOgNJV7gPW0JU4qpASWf1WjSQzb8W/+9X4+AbADIvnbxKJmTMsXMRnYpIOgzUcZ9do5pKNxplPCWzPNBKKzFSOhtQHSWj8p1JLtoZPC7egyp/1TrcnUEcX4vWy21qAjfDFXcLpUrZpW4gUi3FOwGCFhUsDx4j8SG20bmYj7VqJwrmxaNoUWFVZgVAqKP9fvGmFeTCzJrgtLUwDqHn8bN+eaP4g6aekEtdnsu4ekuwhUAX0h5rMSnNzK3g5r3lKT+GZQryU6Kn/GYOftd1BrDuqiHYueaZMhTymVSJo8voP2S/nn5JVnauuQTBW8yHFnsRlptBlwmi9Bo+m4h6J66ja3uYPHPgA+ErB36TGg1xlVbZ2D60SWm16tcXqWUKRtSVIR+3oTJAgnvlc6zY/A8ODMS/a8msMc7lBmuy1GwT+tBal7x9CGfMsIc1vomOAymJNk8hkFjC0fc8uPQF6AUbuxBR1nr5MoieWpI05iSl3GYyYnft1yHzAVVRKihxs/pR5roykFsOKOP7g2pbf85+LJFwlhWERKma5wNfD9MFKu5P3lDOPEK4vlJK0OU/UxQXSPwCRhXLMgDXJGxxE6UuCbsIKv6YCyDOpALzA4mBnqdySbPQd
 NWrT55wv
 6gQO8ps7OIeiS7Ui+09rJL8YcXeJgIioCnZCV1YQHxMqxBbaEW+dNTjYJjdQQJCoYlSnwreq3W4ZqSQdkoosam4t3+oyTOiVPOnMHyJEF6HwTiqHUaIShYriS8+WrJ3WfyF/MlyOPJAFD0KHdl+Fh8cAas+s9aLmX0gP6f6CYtsYX8sYB7yNAVcbRgBBrd44CCepjsFHYpzwThI4N7Kn0n5X5RNyF9ms2saHCaLY/JhTRwU15nFSLvHJBFXp3WNG1C4GSrQ/Bz60PmQRApQJ3rlvAkQriCaZbV6Y2rEuzKaTeZcz2w5QCyLnIUEUEdIaMCVp7JSGbXCxbQiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 2:50 pm, Garg, Shivank wrote:
> 
> 
> On 7/9/2026 2:28 PM, Dev Jain wrote:
>>
>>
>> On 09/07/26 12:46 pm, Garg, Shivank wrote:
>>>
>>>
>>> On 5/26/2026 12:06 PM, Dev Jain wrote:
>>>> Simplify try_to_unmap_one by separating out the hugetlb parts into
>>>> try_to_unmap_hugetlb_one.
>>>
>>> [snip]
>>>
>>>> @@ -2393,7 +2431,8 @@ static int folio_not_mapped(struct folio *folio)
>>>>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>>>>  {
>>>>  	struct rmap_walk_control rwc = {
>>>> -		.rmap_one = try_to_unmap_one,
>>>> +		.rmap_one = folio_test_hugetlb(folio) ?
>>>> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>>>>  		.arg = (void *)flags,
>>>>  		.done = folio_not_mapped,
>>>>  		.anon_lock = folio_lock_anon_vma_read,
>>>
>>> Now that try_to_unmap_hugetlb_one() is split out, should we wrap it in
>>> #ifdef CONFIG_HUGETLB_PAGE and a stub function for !HUGETLB case?
>>
>> I'd rather not, if everything builds correctly?
>>
>>
>>>
>>> I'm working on similar change for try_to_migrate() and had this thought.
>>
>> Wait, are you doing the batching work for try_to_migrate()? I had
>> that as an obvious follow up to this series so if you are already on it
>> then great!
>>
> 
> Yes,
> I'm seeing significant throughput boost when combining it with my batch copy offloading series [1]
> Once batch copying removes the copy bottleneck, the rmap walk becomes the dominant cost for PTE-mapped
> large folios.
> 
> My experiment with move_pages() on two-socket EPYC Zen 3 to move 1GB anon memory from node 0 -> node 1:
> 
>   folio   vanilla     DMA (dcbm, 16 chan)
>   -----   --------    -------------------
>   2MB     10.7 GB/s   64.3  (6.0x) -> no change for PMD mapped
>   1MB      7.0 GB/s   14.3  (2.0x) copy offlaod
>                       39.0  (5.6x) + rmap batching
>   256KB    6.7 GB/s   13.0  (1.9x) copy offload
>                       32.3  (4.8x) + rmap batching

Ooh very nice, numbers are awesome!


> 
> [1] https://lore.kernel.org/linux-mm/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com
>  
>> One other function to batch is page_vma_mkclean_one, but we do not already
>> have the folio there, so have to be careful.
> 
> 
> Thanks,
> Shivank
> 


