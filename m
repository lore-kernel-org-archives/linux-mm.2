Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875FCC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EBE6B06EE; Tue, 18 Aug 2026 14:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16176B06EF; Tue, 18 Aug 2026 14:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9049D6B06F1; Tue, 18 Aug 2026 14:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642B46B06EE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:21:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E45338024A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:21:44 +0000 (UTC)
X-FDA: 85115208528.19.1DB76DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 10EFC20008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:21:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha70fL+a;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTaxowGYxPAPGFyxd1NFA2Af0dHR5XEqV4XaIiJGh1k=;
	b=G/c9M6ZGPsxJ//M3uncokzdnxv6Roap6L6EWJ9BABMMrRFu4SHC0pWepVEOlL5WzDBOyz5
	PswyTCbL8h9W/nQrQhUbz/d5FqU9fTSt0KTcVl4iaFUI21WVY2r+QGExhI8KG9+sLjKLml
	NKWffDOITi0zZ5Brc4gcQjVKOQD8GyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077303;
	b=c6rQjpn7DxBSbTb2J5nAn8q3/PN5i0krW0DcIioYNq5zeXqQSbzyG1ANgBmcaCjc9q21/P
	KVEtXGhCTcPXKAE7+tgnX1k56xoRVY7ULoZ3LD7StAqV8a1JGYiW9+PsJAjB0wQAjYxUF1
	RoRSd1nf0ZMRHAVfLo85h5te1KS2rl8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha70fL+a;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4802E41A54;
	Tue, 18 Aug 2026 18:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9B61F000E9;
	Tue, 18 Aug 2026 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077302;
	bh=oTaxowGYxPAPGFyxd1NFA2Af0dHR5XEqV4XaIiJGh1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ha70fL+aGh3fQT2cA0gDU+rSONQ0xfV4rN9SR4DUJkI3H6GrHl41CDWWp+uT1UrLb
	 dxa1AGDS5pE0KOkya2w8jTciQewaLuKhhoKVvXPTgCMF0m94/z/Tan5uAJ2CsTvUzd
	 2recbwMoxdDzn2CC8nsw3siQXHUXggEzQ4trU34NSrDJ1NANqUBRR3Yu9niAlBRqHX
	 hkL6sqeBGDCMhNFL8XwIZCnWQh/EYRueccbzeY2i1fytTpmWQUBJN33FU6ep0nvaGQ
	 q6IRduP/fdiAt50DgJlrsk8pZViQlyMyUfExEVMm583/dI4uDYnwSa0SyCRy8UI6nO
	 1S9zStDyNiggw==
Message-ID: <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
Date: Tue, 18 Aug 2026 20:21:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
 <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
 <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cifj3hjszr7uddtpgcfcuye8bjnzfdgt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10EFC20008
X-HE-Tag: 1787077302-84082
X-HE-Meta: U2FsdGVkX1+bFgWkCymbKVUwU5My3P57L6fXOK5fmqRCIxeLP8SkBQfcTEt2xdkn/IMGqyfIkb6RStE2fcLD7gLA1H5qnoRio1Fp3riF6ufl39NwHJ7741JzYysmvgEFffdmiPDz7+QJScqARWfqwYT436cO6XicP8YAGoBGSf6SF4rSFhqGF6DA6NCrRfMks/swp+vJxuCzNgRp0pESKrD+hI28ZdVWXnPejnKYmEdDed63EPEFIM4yGGiyhZctg0G0bQOrstXfRB2LmjxMgPvt5S//oJzUk+RxH/c7Tv+lrrmdByNE1LSNYLikfU1LcIeJQR5Ss7jMZfWJQf4Q/7mjsqaF1d9xpYiDdZCnBcdfNA0QTG/V9zxpP5dZ2erVOZ/8gw2GUToHNQCWNljTjlx30YE/7Ya0By3BcbsjAam6B9n3NS5E6Tdt6KMA+DajHAByq8wTsXBsg0CUYs46RYgWFLOBm/CJljAhWakjOCXJI/Soj1VYjcq7YBG4XrSfOqNKdnnL2RbHE1Sqvm//JJEC+KoNzhkTurgn67liJknuUWqhpE7zsXH/I2FjdEKpmDT/0lr3EZDF5cQykgLfRPCUC19TLJxsRGsHLk91DoEO+Rva4eBd8jdmn7ZoS5UjJxxeI9PZYgxDR9S+9umWlaXTnkY1q8yI3INTEvCsYpF9WEDKU04XTfch0K20sidkTMwK3YYutSwSnYUreYrU5Sa4ZGYTPG2Z6mOLJYepbxYDuwrdD4Xsyt3Q43MdTXZbi45xZxcJLvC1+CsG41HtJk/UgYUtgFwyQt4q/iKD4EyFZEXrerd2Zo/NqPqjzcaaHv6JRFx65SK4o5tc1LTpPnOjkxDFlRc7CjxYZcTZlLgpQHOglyNVnvTT+9YJeM8xrtDfMg78YwZ9vIfLdra/DJXLigyhn2lZoPFhToUKFxhwrH8VFk1WyM6q5exAGqYtHNLYnaZIGr46Hhjkh/F
 /Zg7OdO/
 VB4dJhcEb12r4knDbgbamGhGfDVe8q/ic256qpqI5d5PJYlm9Q7UeiAl1AzYDWIYGKZ53+V87yxHqv6nOW48ItMGNpUOcR7MxYIQGuilfl4KbkumdTvZYuO+/JFDSRf9eMWdH3zlwb0o5UTZ1OZg+7GOs/UR5/XYdJxdO4wvT0/Y5YPBI+b6GFNSeeBxnHhmgFwMoi6FjEAgB7k+1/akCglq2dvIy4VdQjAqaTOwPS3qrVix29OHlzydd/asOXN5rkyWfF4HS7UXkQG7CmO5V7dkRPy7rUndJKK/Nxc6DfUetS6rTIs8+yizs68vMB1Eq6HUCFysEPq5PGBFZMKpp+gzfP+q14VEGk22ib18Z2QNpN2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 20:17, Andrew Morton wrote:
> On Tue, 18 Aug 2026 16:23:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 8/18/26 15:50, Leon Hwang wrote:
>>> Packet receive timeouts were traced to sparse HugeTLB unmapping in
>>> production. A task unmapping a sparse 2.5 TiB HugeTLB mapping could
>>> remain in kernel context for over 40 ms without reaching a scheduling
>>> point while walking empty huge PTEs. Although hard IRQs could still be
>>> handled, the per-CPU ksoftirqd thread and other runnable tasks could not
>>> run during that interval, delaying NET_RX softirq work queued to
>>> ksoftirqd.
>>>
>>> Add cond_resched() at the beginning of the hugepage loop so ksoftirqd
>>> and other runnable tasks can run between iterations. Testing with
>>> PREEMPT_NONE showed that the maximum interval between scheduling points
>>> fell from over 40 ms to below 2.5 ms. Total time spent in
>>> __unmap_hugepage_range() remained about 36 ms.
>>>
>>> Reported-by: Lance Yang <lance.yang@linux.dev>
>>> Tested-by: Lance Yang <lance.yang@linux.dev>
> 
> Is there a Link: to Lance's report?
> 
>>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>>> ---
>>>  mm/hugetlb.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index dded1768193a..0a91aac2369f 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -5233,6 +5233,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>  	last_addr_mask = hugetlb_mask_last_page(h);
>>>  	address = start;
>>>  	for (; address < end; address += sz) {
>>> +		cond_resched();
>>> +
>>>  		ptep = hugetlb_walk(vma, address, sz);
>>>  		if (!ptep) {
>>>  			address |= last_addr_mask;
>>
>> As Michal just put it:
>>
>> "PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
>> removed. Is there any reason why you are not using full preemption when
>> requiring low latencies?"
>>
>> https://lore.kernel.org/r/aoRnUxUlgf_kRlm8@tiehlicka
> 
> That's pretty bad behavior and we might want to fix it in earlier
> kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> existing users?
> 
> If yes, we do want to fix older kernels then we should merge this.
> 

Okay, but that would be stable-only fixes?

-- 
Cheers,

David

