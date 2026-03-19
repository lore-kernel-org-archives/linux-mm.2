Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD1B107526E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A686B0414; Thu, 19 Mar 2026 03:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430726B0416; Thu, 19 Mar 2026 03:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3460A6B0417; Thu, 19 Mar 2026 03:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FDE6B0414
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:21:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF1D4B944A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:21:28 +0000 (UTC)
X-FDA: 84561967056.23.1882387
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0375F20007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:21:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AV6ddI55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFyiJ8GUGtbtjOmLfcA/YW745zhlRl6BAbX8Iyrbu5k=;
	b=uWgl2/0P9RnfGt8DQwtiRZBT5DvyU+Z89wPbclxvt37Cp/eqaHMRgqk2SyFod62ARCnjwt
	QkIyHo3+GbiBTBqsT7X1xPdoNR4Xvaa6g3MdvwLckpzCf0/tBrljDmbtCKfaPM3ojnnpUg
	c2H8NBiF+/vMMC6FVxqib/NLW6e2HiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773904887; a=rsa-sha256;
	cv=none;
	b=YDF8QMHYi2Axdq+CjyTovde5Bck6U7lodIb64skXzW9ebhbArmt4cgI6TUf3raOWGEAfjd
	oyO6oBb/PzR/8uY3qU4bssCey5ZcPnzpEnYVGlqGI99H/ph1DpHgLLuCDyEeaKmDwHPf70
	PqHKX9KedXxT/HBsdQ+zPb6Jvs5qVcc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AV6ddI55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E184843F2E;
	Thu, 19 Mar 2026 07:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E71AC19424;
	Thu, 19 Mar 2026 07:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773904885;
	bh=CspEV/eL2jUsFjVlynNQZqKA/uixA05pxZrqR2Qsnx8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AV6ddI55Ndkjzzz3wu3kEgTrfY/Ql9eyIC8/LV0ef31ZjJaEEXTRmvTxeDBs3RC63
	 c+i7DjJ8JvUNYIaj+sbA9CQJVXAzgOOVq6hYoMD9YS1Eu2yjBgcxdaGQMn6rvtNOn7
	 iedvX0w7hROERMiK7QDZciTMlJYtxDtA2tKVmDaFe/lyODJYTx5jHEq4M2cVRYGQtQ
	 ZGLe/Fnqpq8Yq3sSfWf9C+vUXUnicrt3Co6cXNpsxxtaVTPQgtHmUUGhPm5vL/w4+s
	 t3rRHYWXZ1i0a21ygfU4tnchQyJmIXmGbRZthvQvo+OhD6wBj5Uu2m6N4rQEo2Zxsi
	 exeS7+rLeE9lQ==
Message-ID: <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
Date: Thu, 19 Mar 2026 08:21:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
 <absr1vgNP_tM1OEP@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <absr1vgNP_tM1OEP@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0375F20007
X-Stat-Signature: 9jmt6iqugmn4jr34z1ajhfnfx6rmq4se
X-Rspam-User: 
X-HE-Tag: 1773904886-344575
X-HE-Meta: U2FsdGVkX18hJ/U4QjiBY/ENIsdO1zxRtU3rQNwtm331jZHnhW2hRO9haKk5D3Y7wKc5lkUFExnz9xeUeJhOmhESkcPmc0pA1AOJ+ywXyQAJMoGj5venLXsesCg4XGJZRQmJhZiaPWundBkkiuNZPsAYjZ49BdjZJJuT3JEV5VOIvKpAZOJll7BnYrO0P+58MzOvQSZFZmEx4gXRLVy0ocbcZxYsDA6BEalseysLR9bX5njPjqcM9RzUS6AgNnuMVT8Csbw9Y4jomJ9TxETnLEAg+eESvOLBNpEhWLjkoNg++Au7lzz5+vup9QJGaLZMuP+rnWKGe92GhRumpyLPNmSuUqwaKvtHfC65nj+hke/ijDqA+RQz7Lzlf+WYE82bQcWG2xnE2bbYZHSqqcOzgshnH57jUhZ+JsZpOwo2vZ3UZjnhcAfpMNN8QY8cSHKIRjTX0dzLq6NUgig3tX7IXlbwOZV0WFoiprwIjBA59YAyhtxcLB06ryblip2T/s3HohdzMKZ7i61ZMmE4j6spa0QT+H2Zw1mjedRdYCpGL+PkKz/KXvZ6rTMspWbcD/OnWHZSVSRCvHB3eO5d7/7JU2YhKfsfNedOhQoSnIIYpdz+WUE8BpuN51HmHKvTyBffQ6OAJYJ3nFNU3squqqqjke2BI8cPYO+XTvnKuP59S7eZ0X+DaGuwIs5nSAqnzVeZpT+9Cqys0H/dTUSZrYdy1fjBoL0kkjWEbP4D6P4/f5Yjo3lHEVRC0c3nPq2TYU4drc3//1w8QOOR/EBfGSd9yHMitykVns1zIGlXBc7xUYOlHNIIUuPkRP3BetsPaZIILl34E8O6lm4gunmmDYyhsf4uFRK9vDSAi+sJ9DTlAVCSlRJ7C3tNSjocmOlgh7XvmQJkL4RcXa2t16mi4bJcwsY0aIyHVzRcV5B/KdnptBytNkRIFPNjXEM33mdSEErQow9VK+Eq3YAysBsuyYR
 gE2Vltmc
 LL0Xl1IiBWDrnrDQCKqCFD1cf+waIRBx7k7gBeZUHVRumb+l/X0oXw33aqeU1VwLJLpKQEyPNYD0JKz6lidVHGs+S0Y4ZCkEHhZOdFSQp6uOh7GNAb5SINQDsFmTF9Sr19mf9AY3kJYDb1fDvMfYfcj3IzKIbW3KY7Ut6Y4HUKqr94kfZ5op1+cxW407Vy8kkRZZJReuLxpTv+O8GRXd4IwpUe16SQQVI6U724xNQLHQCNuYO6S564FmTJ2oDYCaDLhUgJgjC5ACeDnaUHViJGa7H1OHG/ZG657I+mvoVUFrooH9+5+6tL0yU3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> So, in all anon alloc paths, we essentialy have
>>
>> 1) vma_alloc_folio / __folio_alloc (khugepaged being odd)
>> 2) mem_cgroup_charge / mem_cgroup_swapin_charge_folio
>> 3) memcg_list_lru_alloc_folio
>>
>> I wonder if we could do better in most cases and have something like a
>>
>> 	vma_alloc_anon_folio()
>>
>> That wraps the vma_alloc_folio() + memcg_list_lru_alloc_folio(), but
>> still leaves the charging to the caller?
> 
> Hm, but it's the charging that figures out the memcg and sets
> folio_memcg() :(

Oh ... right. I guess we would then have to do all 3 things at the same
time, which makes the helper a bit more involved.

I'll note that collapse_file() also calls alloc_charge_folio(), but not
for allocating an anonymous folio that would have to be placed on the
deferred split queue.

> 
>> The would at least combine 1) and 3) in a single API. (except for the
>> odd cases without a VMA).
>>
>> I guess we would want to skip the memcg_list_lru_alloc_folio() for
>> order-0 folios, correct?
> 
> Yeah, we don't use the queue for < order-1. In deferred_split_folio():
> 
> 	/*
> 	 * Order 1 folios have no space for a deferred list, but we also
> 	 * won't waste much memory by not adding them to the deferred list.
> 	 */
> 	if (folio_order(folio) <= 1)
> 		return;
> 
>>> @@ -3802,33 +3706,28 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>>  	struct folio *new_folio, *next;
>>>  	int old_order = folio_order(folio);
>>>  	int ret = 0;
>>> -	struct deferred_split *ds_queue;
>>> +	struct list_lru_one *l;
>>>  
>>>  	VM_WARN_ON_ONCE(!mapping && end);
>>>  	/* Prevent deferred_split_scan() touching ->_refcount */
>>> -	ds_queue = folio_split_queue_lock(folio);
>>> +	rcu_read_lock();
>>
>> The RCU lock is for the folio_memcg(), right?
>>
>> I recall I raised in the past that some get/put-like logic (that wraps
>> the rcu_read_lock() + folio_memcg()) might make this a lot easier to get.
>>
>>
>> memcg = folio_memcg_lookup(folio)
>>
>> ... do stuff
>>
>> folio_memcg_putback(folio, memcg);
>>
>> Or sth like that.
>>
>>
>> Alternativey, you could have some helpers that do the
>> list_lru_lock+unlock etc.
>>
>> folio_memcg_list_lru_lock()
>> ...
>> folio_memcg_list_ru_unlock(l);
>>
>> Just some thoughts as inspiration :)
> 
> I remember you raising this in the objcg + reparenting patches. There
> are a few more instances of
> 
> 	rcu_read_lock()
> 	foo = folio_memcg()
> 	...
> 	rcu_read_unlock()
> 
> in other parts of the code not touched by these patches here, so the
> first pattern is a more universal encapsulation.
> 
> Let me look into this. Would you be okay with a follow-up that covers
> the others as well?

Of course :) If list_lru lock helpers would be the right thing to do, it
might be better placed in this series.

-- 
Cheers,

David

