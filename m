Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEF0CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEA26B0088; Tue,  9 Jun 2026 04:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D55C6B0092; Tue,  9 Jun 2026 04:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB456B0093; Tue,  9 Jun 2026 04:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1D56B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:03:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0E1E1204D0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:03:10 +0000 (UTC)
X-FDA: 84859633740.14.E333A33
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4CB5C140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:03:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jRsT/4aB";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992189;
	b=hcinwgnlYSTzFHbPZb+eusdzg5T6g/u2xqUQtDvvzMsyKm3mF35hMVsI/YcluTtRHu6LLF
	ygJ7XDHKCEHGR6iHB47C56ioXdbd9OdrYIcPabqXP6B35c1oGcomWynEQXwQ5dXcJ2z/Yf
	gQLaf3lCOvAeO0+5KP3zvMuepM+2338=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jRsT/4aB";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUcVuWAo1N6d6dSjCQRntUYShy5LQAwX8omMTfd5mYY=;
	b=HrX5s1VnVHLHUVivfIlj7g67Qt6ew2dHdqB7lDXSuYC1Jn/YqYXJv27PJCrlS8jhKkG528
	rncBkTDaixY2qwK8fPM4HfcQaFuQP6j9tt1ADartmVim9jobCerHdI3TkoM+2881VyxlnV
	fWC1BEmslrTJ1mr29is8cZigoB9NZMs=
Message-ID: <3306b3b4-a063-43f9-a740-2311dd87be3c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780992180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUcVuWAo1N6d6dSjCQRntUYShy5LQAwX8omMTfd5mYY=;
	b=jRsT/4aBlYtkb7QyMASuQsaRCIGhVQN28SEQahPXRkP6GdrPmLYHyV3FPEJEvccUtoUjgS
	bqwbEEfE3urBD6PIGshjjfBeQMLGqIgDhPHFvxB1Pdzq/taY9MywfQfbiAgh8BaO4tcAgd
	CgI1a9LIBP+8p3ujctXEZz1NlV8s3XI=
Date: Tue, 9 Jun 2026 16:02:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: hannes@cmpxchg.org, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, david@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <ah3MuK3GuimKVORB@cmpxchg.org>
 <20260609032058.23770-1-lance.yang@linux.dev> <aifB-YGdJAGzgprt@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aifB-YGdJAGzgprt@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4CB5C140007
X-Rspam-User: 
X-Stat-Signature: hhd94bm3hq4xt8cxeufmekj88ncnxhyz
X-HE-Tag: 1780992187-326999
X-HE-Meta: U2FsdGVkX19UTtxcdziP3T3EWOu5jXcQqEv6w1w5a6MRHVrnmJBkxJdxuB5rlw8SKcpoxGPNiFXKa5D8jSU0ikkd/ws/uP8EhVxI+eytM3cGmkNXv4KFHjurbj+T1R3XsANo2LRhMHZe4GmwlVLblbXrF7sr9dUMMBRlQSFGm+X3xMzRzjSemU8OhQIAtGWr+dSW7QYZZg6g1Nrwdaez/k/i5sQ6R6b6d6jqjbdds20C9/aL7v1fFiF2GKxOACeWPmx4nYHZ/7duiYIcTINCrfi1O2g6ydXM0SaZyFzKqL/r5ZdeKXkWwfS5/5PLSY/dgOoa2ZotOorNzIRUQDaEaVZKbAbrM/V/d2OhqtjVMLrbauht/oUxw012An2SvTJNKRubOaXIeQFSESOeF/4n5Y12a4/AZJ5wvFllSwuRpp83ul9V9UkCPwMrPIQgI/Fv/xYfoPzu3voYvet6TZ4gkrI4lFQSh7MFyAhocuR89ZsFm1XZKIjK0hpztk+cpyzDto/aqlg9I+VJMn12ygAx92SSkOe8dV+Jbz2v1/Z9sg3BmEZJB6W67x4YKiBghFHD8OcnkQ6dV3gCMMhfNHUnfAAVkkMT0/00LqKjWND+mBQ3qFngLeyENmvrBKzrWl/1AYjjzrc7cKSDHccPeEDx2zM4yXACU7AHDXQ6/fBKAIurrRtjyumgIPjYufcdLhgEIu/++tF1ma3Dy4Zemc3LU2RFHeCKTdsK7jg5QVxL5h5WftHvi2eaZnaEQhHmFESPC4IFoWT2ZYQ/nYTznMVLC5BV6cpWu9UsiB0bk1eXLYlcUaVwcckn5W/ISQZ71wS0utNqjMpca3b39CvAaqcPk6mWH+FnzkOq94pcarfl9BSrFqVa8nkH6l59TPTgJXGEtFKgiYPh2mU6IGItJt7oHT4p9Q3ZnRV25M4jH7en5kRGV66THL5SttwoVhuXwGTa7fYNaMtkxDSxnHp8gNG
 JBNKLE1e
 k5f1fdhioDTcbPGYb3P4lgVQsSMwMGcN67dNALGRFyzkYOGe/3o03Woqyv1MRjSsjhCXnrbOTNvQU7MUyBscFLyPoS3Z5HBfEJzkX8ngATcSg+dDEJJmwxS+kNCi1cfuROrzUARyHSD63zYnAavK2e/aBuV/szsCPhP3FhVn6c9RzqZOgCYDqasigK3+ic7CGXJmdq3DaXIGgcC0B8WNKiH9/EQs7iYaAM/Ze9eaOC64YgCizBR9lp/weuVLNn8HfzEkwuO8bnR8v4zVW8TvNgD3v/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 15:35, Lorenzo Stoakes wrote:
> On Tue, Jun 09, 2026 at 11:20:58AM +0800, Lance Yang wrote:
>>
>> On Mon, Jun 01, 2026 at 02:17:28PM -0400, Johannes Weiner wrote:
>>> On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
>>>>
>>>> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
>>>> [...]
>>>>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>>>>> index 04f5ce992401..9c3a5cf99778 100644
>>>>> --- a/mm/swap_state.c
>>>>> +++ b/mm/swap_state.c
>>>>> @@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>>>> 		return ERR_PTR(-ENOMEM);
>>>>> 	}
>>>>>
>>>>
>>>> Shouldn't this be limited to anon swapin?
>>>>
>>>> e.g. vmf && vma_is_anonymous(vmf->vma)
>>>>
>>>>> +	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>>>>
>>>> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
>>>> get here too when handling a large swap entry:
>>>>
>>>> shmem_get_folio_gfp()
>>>>    shmem_swapin_folio()
>>>>      shmem_swap_alloc_folio()
>>>>        swapin_sync()
>>>>          swap_cache_alloc_folio()
>>>>            __swap_cache_alloc()
>>>>              folio_memcg_alloc_deferred()
>>>
>>> Good catch, I think you're right. I shouldn't have dismissed that
>>> branch due to "/* Direct swapin skipping swap cache & readahead */"
>>>
>>>> @Baolin please correct me if I got it wrong :)
>>>>
>>>> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
>>>> only allocates the memcg list_lru metadata for deferred_split_lru:
>>>>
>>>> int folio_memcg_alloc_deferred(struct folio *folio)
>>>> {
>>>> 	if (mem_cgroup_disabled())
>>>> 		return 0;
>>>> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
>>>> }
>>>>
>>>> Since deferred_split_lru only queues anon large folios, doing this for
>>>> shmem swapin doesn't buy us anything :)
>>>
>>> Yes, agreed. I don't think it's a big deal / show stopper in terms of
>>> user-visible effect, but of course still worth fixing.
>>>
>>> I'll send a follow-up patch.
>>
>> Thanks.
>>
>> Looks like this has already landed in mm-stable. If you're okay with it,
>> I can send the follow-up.
>>
>> From: Lance Yang <lance.yang@linux.dev>
>> Date: Tue, 9 Jun 2026 10:56:45 +0800
>> Subject: [PATCH] mm: prepare deferred split metadata only for anon swapin
>>
>> __swap_cache_alloc() prepares deferred split metadata for large swapcache
>> folios.
>>
>> That also covers shmem swapin, because shmem_swap_alloc_folio() can call
>> swapin_sync() with a large order[1]. But shmem folios are not queued on
>> the deferred split queue, so preparing the metadata doesn't buy us
>> anything there.
>>
>> So let's limit it to anon swapin.
>>
>> [1] https://lore.kernel.org/all/20260601132135.14272-1-lance.yang@linux.dev/
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/swap_state.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index 9c3a5cf99778..7adac957c2b8 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -465,7 +465,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>   		return ERR_PTR(-ENOMEM);
>>   	}
>>
>> -	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>> +	if (order > 1 && vma && vma_is_anonymous(vma) &&
> 
> A folio can be anon for a non-shmem file-backed VMA though?
> E.g. MAP_PRIVATE-mapped file-backed mappings?

Ah, good point! vma_is_anonymous() is too strong here ...

Maybe use !vma_is_shmem(vma) instead?

> Not sure if that's something that'd be a factor here/meaningful though.
> 
>> +	    folio_memcg_alloc_deferred(folio)) {
>>   		spin_lock(&ci->lock);
>>   		__swap_cache_do_del_folio(ci, folio, entry, shadow);
>>   		spin_unlock(&ci->lock);
>> --
>> 2.39.3 (Apple Git-146)
> 
> Cheers, Lorenzo


