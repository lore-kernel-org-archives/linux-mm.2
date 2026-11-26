Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC06606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XjAV3zvE
Received: by kanga.kvack.org (Postfix)
	id 883DA6B05B2; Thu, 26 Nov 2026 11:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834996B05B3; Thu, 26 Nov 2026 11:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724086B05B4; Thu, 26 Nov 2026 11:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF976B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C1B6A89B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:20:38 +0000 (UTC)
X-FDA: 85477783356.13.C44C45F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 76ABC140006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:20:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjAV3zvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795710036;
	b=G4q0gjwE03eCBeWjv8C+uDqLz5LLeDbcyL5FSVl0jpfKZh93wUjbLc61+fF1QTsgQymlTM
	7R8XfaCDLw1a56rJQ+STghT36p0psCl4jQYytW+PLoAKn6B9DUUIEEIRgWfbmVkvmbH4FS
	Zxx5IPfO8E45mVY/X4kaVhwJSxZB0zY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795710036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OxF1KJH3JU8jPbBzu5FzY7JrD43enLgivaMaCEpx/o=;
	b=cdsllq1gUUakXNB/xqZFauAU4LuhuduP1kuNPzbunawikFyVb/ZdLV22JgYp5wGnL8bLI4
	B8gZga/9cyI6+cri6gtFAshopw/f8GyMXiwkABFEjDDy2r0mGqXjou1Gq5lUX5cRe/l+4n
	qR5FXe9g4cZuJS0VhfGYTsY5ZlyARqo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjAV3zvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9756622A9;
	Thu, 26 Nov 2026 16:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ACB1F000C4;
	Thu, 26 Nov 2026 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710035;
	bh=/OxF1KJH3JU8jPbBzu5FzY7JrD43enLgivaMaCEpx/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XjAV3zvEkm4CEN3LwtZGmVncSvR7QXRzP/FaY9yt0QKShmVBDtBesugBlAM7gE8Cg
	 O9Moejqjkhadl5rh9ILJHfhZTDLAJB5LNhjr6gi6cjkehoGWRk5XAj9byHIoqTH33R
	 7e35JgIlEF5Str4oyGVIecTIppzyZaFWOk4sUYqWpE0au5ff94Fpzm6Kp2USIaF43v
	 eYQWFK2fZ+PxuZ0/UDoNTQSVXdPC+dA0EJLBvKCKeW0Ocz2PagT7WAfQxLdcgoTFjC
	 CIKNppM63fHvvm9RjlbTmXV9TlzM/B8OE40Ly/qvO64Gy4p6y8eSMe4WTxi2QnwUSs
	 NN1yDyMgPfN6A==
Message-ID: <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
Date: Thu, 26 Nov 2026 17:20:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 Baoquan He <baoquan.he@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Youngjun Park <youngjun.park@lge.com>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20261126094318.244973-1-alex@ghiti.fr>
 <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
 <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ob3o779bqsjshjn44x9bagjaymogbaa7
X-Rspamd-Queue-Id: 76ABC140006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795710036-38337
X-HE-Meta: U2FsdGVkX1+pJQ8IxkbWWp7Ovz+HfzNm22Byp/Ma6ve4CKklG39ITHVsLvcVVXiK4wpSRFPzb2jrMtRULJDDHEleFZHFMf75VqGd9imZdg65stEtKwZqNCDO3ETbcP2hfK5eNWnRhpQyW7eb3wGaptLs+02iSAwT6z480YRjhLmUm5LFNkFNagyttfyBjAccTVQDrl5CrxRetCzgui+lP237EIYBVJQXo1+V2RQrEDCxBi93TMQyHl4TwdrKCBrq5gglyXC58wmMdrlTPewV5DYyOiJb7apr0BrP4IIl+TBmRGPrullxfk1oTA1dDsv1Iq0hvaQHYWzxDEkfcREFTpnL9q/IITFzG0AeHT/6DvsEoczlHRJmdmAkkBpxe4zLYpu+FJ3/VWOxcoz8sE8hSUmzukf7Z1xtXS8QW7+AImHKMw26dXsogWbbhs8e4Ntq4JYD4bhUYjoWFhlmK8RZ47EXropdm4R711CNBkWS9v77M72osWfCTnVy4QPOa/uIIuTddsdw8W2LzXjpS/OGpuOT32BvBxidtQYOCu+SzaCN5LKiOYgYmiiq5iuVndJ9IWPPu70Ta8+QEf1vGle3YdbQn3vPBKpGNUr3mZqdvMgoeUPLXGLwc3c4XxI6dnQFC4HTWf8uOQO5kPWkIhMb7fb6IhqymFepbgAeGbiTg1lU8kXsS3vxSApxselOM6u0Z3/NwAO7q/rmFlf3SwvyqzOiXnxKILyZDQu6CDjhV62BqXR2xc06Q4PTA4By20Eq9eNIc83wcHv2iuLOIL3/M/JaRgCHJnfvupDqXeC00B47u9DfmupKE1fDExTBLJlcru0QkyrnEZBAfyJK0fosVc5T7V6eVteMQIlr1g4XjR8yKRxeZ4O/6xsGAVpo8X2UA2DB5vOxU/tNI/S5QLzD6o0S2gwD0UwwMcitmsDQ6MqOu7yHMkfFXfzmYLE+kvWRA2w9blmEMmQpiGeG51w
 atA+lp+D
 /fDPE9dMbPv/+kzJvHhznzZH9PMomwlE+dLXsHEc7yGrLAqIl7xoqTknScI2N0TAybUr8l1ae1tAg+QBR0knTxm3W+Ug4wCQZlmZsb/L8HmxdDtLaIu3qLgMTxbFI/GbD+KVcv8hqmskB9RkoCTXwqkDYADXNzOoCqs7kWpG16U2EedXgNDdkc4qG5BGd3H0YVvhRB8Oc5Owny3DozHDGuiD4WHF2L7P19YvUlHAqhL9e6mE+/Ienl9Mz7J8e6HzqDqFONfRe5mLjVQd64f5wWYmnG/BOnFVsb/21R9UJNCqe7+a3IE+y/PcaZ4D8CAW90NW4B3xBXPvaGUW6ziKJFOuUAi3xK245zOILcAPEtBXa+Udp4yLf5nFAbXVcy838npI9dBaDc7P+TQjJFc5S59l6MXB10/pIX/s8owcwaAHlBnzEQJ6r4gnRlpzIno+TKrn4Go110fey3kbyPYeRgeghKbpFQH7d0D5MKwqxlFPAQXZes3E0+hveTsIIAgRBSp3jxT/oHuVFtr8Z9kF2uDbHOEiILFJnzDHGdEoCdN3j07sFlSKptYl1Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 16:01, Alexandre Ghiti wrote:
> Hi David,
> 
> On Thu, Nov 26, 2026 at 1:54 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>>
>> On 11/26/26 10:42, Alexandre Ghiti wrote:
>>> do_swap_page() frees the swap cache of an exclusive folio on a write
>>> fault only. A folio loaded from zswap is dirty: zswap drops its copy on
>>> load, so the slot no longer holds the data and only reserves swap space
>>> until the folio is reclaimed again or its owner exits.
>>>
>>> Such folios add up, and they are expensive to free at exit: on a large
>>> production workload, the exit time doubled when zswap was enabled. A
>>> third of the increase comes from the folios left in the swap cache,
>>> each costing about 3x a resident page to tear down; the rest comes from
>>> freeing the zswap entries.
>>>
>>> So free the swap cache of an exclusive dirty folio as well, so that the
>>> slot is released at swapin, as is already done on an exclusive write
>>> fault. The folio is dirty, so it would get written out again anyway:
>>> the only cost is a new slot allocation on its next reclaim, which write
>>> faults already pay.
>>>
>>> On the production workload, this patch removed that third: the exit time
>>> decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
>>> memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
>>> guest (mean +- stddev of 9 runs):
>>>
>>>                      base            patched
>>>   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
>>>
>>> The cost is paid by folios that keep cycling between zswap and memory:
>>> each reclaim allocates a new slot and adds the folio to the swap cache
>>> again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
>>> not measurable (mean +- stddev of 5 runs on bare metal):
>>>
>>>                        base            patched
>>>   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
>>>   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
>>>
>>> In the worst case, random reads over 4 GiB of anonymous memory in a
>>> 3 GiB memcg, so that half the reads are zswap read faults and the task
>>> spends all its time in the kernel, throughput drops by 1.1-1.4%
>>> (mean +- stddev of 5 runs on bare metal):
>>>
>>>                        base            patched
>>>   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
>>>   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)
>>>
>>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>>> ---
>>>
>>> Notes:
>>>     Previous discussion:
>>>     https://lore.kernel.org/all/CAGsJ_4xBtKGqXFP4zvp+Qn+tb4X7aCvXn+wqDqot_cXR92DjhQ@mail.gmail.com/
>>>
>>>  mm/memory.c | 9 ++++++---
>>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index d477a4f986bc..dac0f0a24bc7 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4711,10 +4711,13 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>>               return true;
>>>
>>>       /*
>>> -      * Free the swapcache only if we are the exclusive user and
>>> -      * this is a write fault.
>>> +      * Free the swapcache only if we are the exclusive user and this is a
>>> +      * write fault, or the folio is dirty: its copy in the swap slot is
>>> +      * stale then (zswap loads are exclusive and dirty the folio), so the
>>> +      * slot only holds swap space.
>>>        */
>>> -     return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
>>> +     return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
>>> +                          folio_test_dirty(folio));
>>
>> Why not more readable as
>>
>> if (!exclusive)
>>         return false;
>> return (fault_flags & FAULT_FLAG_WRITE) || folio_test_dirty(folio);
> 
> Agree, I'll change that for v2.
> 
>>
>> But ... isn't this zswap specific? Why do we have zswap specific stuff in this
>> common code?
>>
>> The comment already gives away that something is not quite right here.
> 
> I am mostly interested in the zswap benefits, but nothing is zswap
> specific here: do_swap_page() can also find a dirty folio in the swap
> cache when reclaim bailed out before writeout, or when the swap write
> failed. In all those cases, the copy in the slot is stale, so the slot
> only reserves swap space. zswap is simply the common case, since
> zswap_load() dirties the folio.
> 
> What do you think?

If it's generic, then the comment shouldn't mention zswap in the comment :)

And the patch description should be all about zswap.

And we should measure the effect without zswap.

So, folio dirty -> We'd need another writeback because the content on disk is stale.

If we reclaim swap, the next reclaim run will have to re-allocate one.


But why is this "is dirty" linked to exclusive?

What if we did

/*
 * Free the swapcache if the folio is already dirty, or if we will dirty it
 * immediately afterwards by writing to it.
 */
if (folio_test_dirty(folio))
	return true;
return (fault_flags & FAULT_FLAG_WRITE) && exclusive;

-- 
Cheers,

David

