Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56414E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96A26B00AB; Sun, 21 Dec 2025 04:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43C76B00AD; Sun, 21 Dec 2025 04:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A475B6B00B1; Sun, 21 Dec 2025 04:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 933466B00AB
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:40:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B47013B9F0
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:40:41 +0000 (UTC)
X-FDA: 84242983482.18.EC2462B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 966FA40007
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:40:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hW8kMe6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310039; a=rsa-sha256;
	cv=none;
	b=05r0bNaqfDbOgmUmwv26pcJakAU61whIYDJ1d7v61H9JsVqF5nctegLx+1LNcwc3A+PqTq
	jO4NSSaKu4hBS8b41vvDmFPjiqNIqLVG5V7DbncI6U6oNoxcKX2RfKZHoRA1xOVCWgVugs
	n/pNQmv954iA1zNFKhbSLh7EUXBp2rw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hW8kMe6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10w6n4Sop6yhPg01WeHQS8K6DVLuWo28GS5/ExjqBcc=;
	b=H4Zvl/iN5+sNUTzzE8ZnIY0m27FGzssFT9Rwr5MukICy4e/1E9QQWGM7RuseDb+q6u3XEu
	0zmXBDXW9seIQU9Y7rCyMUdkIcmXJeDJK/9OgLjGASfuLfdMt93XY2uDTDs/DVKYvSCCuf
	msUULieFsqu52nmH8N/2coxSLE7+wAc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC32460052;
	Sun, 21 Dec 2025 09:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0EBC4CEFB;
	Sun, 21 Dec 2025 09:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766310038;
	bh=VPOsV3JAwGjMJpXTBHYMu/MU7OLR+Gl9ZYxkeDnSBN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hW8kMe6YQBHYzNeIpwFxaVfInYVgS3k9pP3Rf996cOZAwGi4ADxEsMRakYDCgKbeh
	 wlN1av5t/wk6hk4HsWsvEYHEuJr5doFqskwxu/NZ4RUzSfSmW/p47sWQPlTtu/VsQR
	 avm+kG8hqHBCUPMLK9SBK3kApQ+oVabtUYNsN7dTN4WzXZeUX2LJ/NNiz1YldGGZEi
	 3CAkNiWTZ1rGcMi1a+DBX3qHnpadYwq/+QBaTXGN2ecxNwKxw5XXDdVrpiPN+obebE
	 PSBTf+CUw9zakybMsj1nxuUbRYstrws3mV6ceJAMT4r416fFKiIF5O82CJXt9XK6BN
	 2GvKi8dZUXcIA==
Message-ID: <34fafda2-9f54-408a-be9f-d54c39b72878@kernel.org>
Date: Sun, 21 Dec 2025 10:40:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: bail out do_swap_page() when no PTE table exist
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, hanchuanhua@oppo.com,
 v-songbaohua@oppo.com
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-2-richard.weiyang@gmail.com>
 <4c2027d3-2665-42e0-8cfa-712b1d8f8870@kernel.org>
 <20251220032407.xeszwxus664jp7tq@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251220032407.xeszwxus664jp7tq@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 966FA40007
X-Stat-Signature: fmdgkfhx8hqtdww6hwuhcjwrou1xyo95
X-HE-Tag: 1766310039-558422
X-HE-Meta: U2FsdGVkX19vA9aKYaB6XhPmhXavYuLxuzhv+ROu3/Vv4aR7xCp3O7f5JCjZBuM3DF2ttxcJbiE2UT23BMXnzRQgZFnGnYexV6MKMyx2+75kF0WpFFnYHQPWSfjt5SeWLWvSX2L19gqZVP/Z7DcbZFkdI3SgK5YgzWAVLJONptg33mZIlWQNCl0rPxpHQ8e1Gl0vUoejiqE0/U8C2762Y56+bV4Hq91FGvCbHlapXf3dcgAzgkEKUZkNtgvXuETlOBQ7i43gchzDkDSAqzD5HzHT2qyIdh8dhvXcMJbKdNSRrSVQJe1hnk7JlHuWDfMFLi/YC8NcNYgPQ8d5tnP19/Eb9/i+Ih5UNFFIrg29hLICR+GF+6InYASKun3x8qaDCp6lqXS/1AZ/RjU0xkpdeCC81SIjnWurulTtzDyCy7KJV1l9aODqEP3zWwuxxkR2yk1fv5pdZMQTASuyH9uU6DoVnmc8XDsl5ahU5VrowzWMbltrqPsWXjh04LFfz0YmApW53mS6iO5yWvvdyKA69OUGUViff5x4Oa/nOMmcqLVU6LZU0slqcHHaVtvoVoe7huKQyvVhloYmkLA5UQGe8DsRRwimMNzedk+TMSATHYVO81NUrZhWrkehqq3TB9cO7NYRXZ4BZN0CP8Ru4wULbd8nTYsY2kuGXtO2j77DEXsl3UE0dbE6WDBMwb1XIBYwsMAlMoDD2sbG8nMYs9jPQBhZPlhXlkKzQMBSJ/ZdYCtak5vbrJqrc0evbGmqprzgSJzANBBtAfjT+WMAUyoDfhvDARGF+PUPpNVSaONsDrlgIfpL5oPD3VZmMP17+OSXqfAieMyKoI2SveJ7fFPobuY3lR0U+YbQZeK1Z7HTbyhPIOc69/TXoAwCM3ps8Dtdv1/dVoLLL17SvbkgnT3LhiN2+dfPDRuM0KQ2B6r7WyN1xeIOAobDimxEA8BgNKrTMemKkIlV2fxFjI0v92F
 ssmeqDny
 tlW2ZnNX9BL6o9Lh/otnR2U/DmbI7QLV3EUrY3X7q7dYCeS37wEXHH7kegSVka9hjYbUWL2C0tMF7Ei44yifayg9WZ8vqocuE2OBq5xdml+4ZFR2rVrmlcxEWSWuMIA2RWh7v9ceKA+9aRRlUebT7szIC5Wgxdz0xJHGCnWtprI9MPRGcJzlRO2g2yaTNiGSWQOmQULVO08cuy9zmGGKcFSs4jtJ5drUNeqzeZKkr2kxKONjeWAhTDN52RLIqZGR+AH3/r2JTIfcQS2Pmx8DJgEtuog2W+xkdG4wV2o1Tnwckz4VWEuwPUvXItaL4azLFQzVIdkxPDLqsLYLvxmmZcXm7VKVIwMyAGKOyDFbiDm1HrxknNaGNe/KllHeWHYtB9WdXBUjN5xIITLf5HM249cOJ/woY+T6VHE+E/rnEhyeXrVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 04:24, Wei Yang wrote:
> On Fri, Dec 19, 2025 at 09:42:16AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/16/25 08:59, Wei Yang wrote:
>>> The alloc_swap_folio() function scans the PTE table to determine the
>>> potential size (order) of the folio content to be swapped in.
>>>
>>> Currently, if the call to pte_offset_map_lock() returns NULL, it
>>> indicates that no PTE table exists for that range. Despite this, the
>>> code proceeds to allocate an order-0 folio and continues the swap-in
>>> process. This is unnecessary if the required table is absent.
>>>
>>> This commit modifies the logic to immediately bail out of the swap-in
>>> process when the PTE table is missing (i.e., pte_offset_map_lock()
>>> returns NULL). This ensures we do not attempt to continue swapping when
>>> the page table structure is incomplete or changed, preventing
>>> unnecessary work.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Chuanhua Han <hanchuanhua@oppo.com>
>>> Cc: Barry Song <v-songbaohua@oppo.com>
>>> ---
>>>    mm/memory.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 2a55edc48a65..1b8ef4f0ea60 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4566,7 +4566,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>    	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>>>    				  vmf->address & PMD_MASK, &ptl);
>>>    	if (unlikely(!pte))
>>> -		goto fallback;
>>> +		return ERR_PTR(-EAGAIN);
>>>    	/*
>>>    	 * For do_swap_page, find the highest order where the aligned range is
>>> @@ -4709,6 +4709,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>    		    __swap_count(entry) == 1) {
>>>    			/* skip swapcache */
>>>    			folio = alloc_swap_folio(vmf);
>>> +			if (IS_ERR(folio))
>>> +				goto out;
>>>    			if (folio) {
>>>    				__folio_set_locked(folio);
>>>    				__folio_set_swapbacked(folio);
>>
>> How would we be able to even trigger this?
> 
> To be honest, I haven't thought about it. Thanks for the question.

Always ask yourself that question when trying to optimize something :)

Optimizing out unnecessary work in something that doesn't happen all the 
frequently is not particularly helpful.

> 
>>
>> Trigger a swap fault with concurrent MADV_DONTNEED and concurrent page table
>> reclaim.
>>
> 
> Let me try to catch up with you.
> 
>    swap fault is triggered because user is access this range.

And there was a page table with a swap entry.

>    MADV_DONTNEED is also triggered by user and means this range is not necessary.

Right, another thread could be zapping that range.

> 
> So, we don't expect user will do these two contrary behavior at the same time.
> This is your point, right?

They could. And it's valid. It just likely doesn't make a lot of sense :)

> 
>> Is that really something we should be worrying about?

But for the page table to vanish you'd actually need page table reclaim 
(as triggered by MADV_DONTNEED) to zap the whole page table.

>>
> 
> Now I question myself why alloc_anon_folio() need to bail out like this.

Your patch adds more complication by making it valid for 
alloc_swap_folio() to return an error pointer. I don't like that when 
there is no evidence that we frequently trigger that.

Also, there is no real difference between not finding a page table 
(reclaimed) or if the pte changed (as handled by can_swapin_thp()).

In fact, the latter (PTE changed) is even much more likely than a 
reclaimed page table.

-- 
Cheers

David

