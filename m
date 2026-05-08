Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4065CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A516B014C; Fri,  8 May 2026 07:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BCA6B014E; Fri,  8 May 2026 07:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA7B6B014F; Fri,  8 May 2026 07:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C426B014C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:46:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 897E5C2C10
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:46:13 +0000 (UTC)
X-FDA: 84744074226.06.216E1BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC8871C000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:46:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqs1FXjS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778240771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWxUbS/vGELB6UVAy0bgIjJZgcFE8RaVSoy4suV3OQM=;
	b=QuL/0Ybz0Oytbitt6vyNoAQrEkNXzK6MoaSVaXguZaIp4tGkGNt6zCvqf6elAFv6s4Lt7Y
	DAr6JVQbrSLk8tPNidsPiJ59n4qqT0vpF46wf/K24aNyTCNglrIFzZ0onNiXqmqiveGA3P
	wcF15sJNyTQDQqLl9Tb5SssuR4Z+YFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778240771; a=rsa-sha256;
	cv=none;
	b=TN+g9wnykksGvZAIUjMLqFNT+2lxWLlzJ69fUaIb74ZpTfeGezfHPfbcXofcyiFnC/QzJe
	dR9bgwQcJWRVBiYXk9dZDhtRcJygWs8PVuEOW8nS3hFl+TUfGuYfjdKhPJkdxtATLerg06
	QqK11RPqbuvE5nG/ILY4aOQwK5nTdZI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqs1FXjS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B37D6405A5;
	Fri,  8 May 2026 11:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13763C2BCB0;
	Fri,  8 May 2026 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778240770;
	bh=2kzRnBqgBU5KvKIDqJxGWoWinU1iXToqRq/hGbyW4rI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bqs1FXjS13wNgcrsExd9ewUN58pNMxoAP7eGdSlYnjyF9xKfP2iBHfxOe2KfZVREM
	 9gxfVARpua7JlcnWeFDB36Ex/f7obduxKx7a0GCETaRR9lUsUihaUKvaK18xEp9oXQ
	 EY0CpVjwQJzDNGZVmxxjeVnj4xgCbadZtPEi+x6O7czh1R5FJzdEmTz2myEDvJV5r5
	 qBXv/Sp+zgF4dzaeaYRg1oDi+w5cSztHW6FsrRzRsCQnX51ZZY4sObGOlPDyPUTaaJ
	 ileYHXScFqnzAik6050zNfYLeWzMHmZI+BsS7c9EbmjnQ3tlKrKYq/ykTeRAnIJPO3
	 cL2zQ6WDr2C6g==
Message-ID: <a5660e22-b1f9-4dcb-a190-f3dc5253c570@kernel.org>
Date: Fri, 8 May 2026 13:46:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
To: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Christoph Hellwig <hch@lst.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
 <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
 <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
 <aftiQuHOA0t2lfyP@U-2FWC9VHC-2323.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aftiQuHOA0t2lfyP@U-2FWC9VHC-2323.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AC8871C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: m7rjgzzyot1i5iw9pcgofryjmkzmm74o
X-HE-Tag: 1778240771-159922
X-HE-Meta: U2FsdGVkX1/vdwWt73e6ewcHkVgg/DpKwMOgIcX0HTtJbCrmaXgCLzrzrKAUseXr5a2O8K0UxdXhoH1xcgxq8mkNwvoUsomwLpRBf86NvTD+B5qc35//GTBZYckf7MuAryK/+gVpyoIWbWHwMcqpsXUUEgxAd2Bl5AW3bVsHKgMfbVaHaneMLeIxstNZ6a8pZYoLrCXwVkShn+VdLx915frvc9UUNqJeNQ9lbPM5lNrP6En5Yok1KQRnkZ34jcjl1u4wfG6roi3DVJAPlXhLwGvwGzbzPtdxKfodQ7XpCxKTFgNWPZeMqHMaw18/q+ZJgSxpD/kwwXe2GgfLv0HFVXMmo11A81BiYsQBhujbSydyJab7aOv9uLtypf6JIM4XHvRlzIun5SRIyvAJev4z7trlvNHYM1cvGwqi3yU5nqIGsk+hAQa6nycdjxMkNZDce4xDBi7nl4GVoouP5Qu8cMYrUak+aQj3BVpUR+DcQDZtp9qMYo/BE46kD8zrN9V4FDJS4uG7ULqsQ/ybBKC1RkMXzGNvKCDW/exZqeYb9LOKp5YnoOlsNHx7I7eigxtzlM/s0zwUKFXC5VcoB+2GJhbBYb0/jyQGJtlM6ojks2OS7tm3Izg0/Tu0wWR2gN4ignjfB1HgNbpHrt2M0wm1VzAlWDIjmRvInIYSNPud8kbxOufVnCuX1Ep17DN2bNkXxzRa1gaUo3v6Uj3VvYAq1N+63jK20iGr+Y9BTzi97sr/hAk6ZzPZ7yBVa+srvRUhOJmP2pC6vHSrCkCC9/6ncv/fXYVolnbhjv1TRJOmAcdnAYCkcX+FQXCldBmkJ2I65/6LQOrdlRRRpLrGcYFBndp8pOgynph30jX98l0WOIm+76i/5nMcGi7PVUZ+hftmQ2nLV4ffFZXsiAp392RakjIdD+EOiIGokjwqHeGm2/f1EOFgwcAaGlHkZRLqwUxwvUe4iMGYohghLxXGpFU
 dJmRlRPp
 F0gTRBtHBNhy7CF/Q2MI/qVYJcfH6gHrOVAvG4V5UoZ5029Mvx9SjHTjfgAUUjZOD4tXKc71UtvS57d0nVfIUI9gSQC80s9qhgrYRlpfco8S4T03lO6oM6KvzqAXoEpjZdDM+KrKUwKwgPKMGgpPYYZcRZOInl9LSzyWhHKIDWjcoIPURd1AlUNVC0w+5H9BIkaVyrI8lxod8sU5gXYLjluxlZPp52MP1gpettVFNRRtPLsMmO91cwqg58/aeSKDZK2Xm7rknavW/gIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 17:46, Feng Tang wrote:
> On Fri, May 01, 2026 at 08:51:39PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/28/26 10:37, Feng Tang wrote:
>>> Hi David,
>>
>> Hi!
>>
>> [...]
>>
>>>
>>> Right for default kernel configs.
>>>
>>> In kernel/dma/Kconfig:
>>>
>>> config CMA_SIZE_MBYTES
>>> 	int "Size in Mega Bytes"
>>> 	depends on !CMA_SIZE_SEL_PERCENTAGE
>>> 	default 0 if X86
>>> 	default 16
>>>
>>> config CMA_SIZE_PERCENTAGE
>>> 	int "Percentage of total memory"
>>> 	depends on !CMA_SIZE_SEL_MBYTES
>>> 	default 0 if X86
>>> 	default 10
>>>
>>>
>>> Yes. I thought about that, and didn't have good solution, and used this
>>> given it's on a multi-numa-node machine, which may not be too bad
>>> regarding memory usage.
>>
>> It sounds wrong given the existing config options.
> 
> Yes, it is confusing. 
> 
>>>
>>> Robin did concern about the memory usage for embedded/small devices in
>>> v2 review, and we change to v3 to not affect them.
>>>
>>>
>>> I agree :)
>>>
>>>  
>>> This sounds good to me, if no objection from others. Maybe default 64MB
>>> or more. One good part is, all these setup is under protection of
>>> CONFIG_DMA_NUMA_CMA. 
>>
>> I cannot do the heavy thinking here because -EBUSY, but maybe you want a config
>> option similar to CMA_SIZE_MBYTES/CMA_SIZE_PERCENTAGE that either controls that
>> these sizes will be split over NUMA nodes, or another one, that sets the default
>> for pernuma.
> 
> Maybe a CMA_NUMA_SIZE_MBYTES?

Maybe, I'm hoping some CMA DMA people have the capacity to provide input.

>  
>> [...]
>>
>>>
>>> My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
>>> it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
>>> cma area (cmdline like cma=XXG@YYG could make it on different node)
>>
>> Ah, yeah. It's a bit nasty that we have to handle the default area like that.
>>
>> Another sign that we probably shouldn't deal with the default area :)
> 
> Yep, in v2 I didn't touch the default area, while Robin had a concern
> that the v2 approach will bindly add an extra per-numa cma area for
> the node which already has the default area, which will hurt those
> small/embedded devices which has limited number of memory. Adding
> the nid check is trying to keep the behavior of one node device
> unchanged.
> 
>>>
>>>
>>> Per my understanding, it won't. There is a cma_validate_zones() to prevent it
>>> from crossing zones.
>>
>> It's a bit confusing, because it ignores other nids.
> 
> I might have missed your point. Do you mean one cma are could have
> multiple ranges?

I don't know, it's confusing :)

-- 
Cheers,

David

