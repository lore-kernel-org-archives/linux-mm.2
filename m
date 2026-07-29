Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32972C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427846B00A6; Wed, 29 Jul 2026 09:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400286B00A9; Wed, 29 Jul 2026 09:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315676B00AA; Wed, 29 Jul 2026 09:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1100C6B00A6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:57:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21067406BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:39:01 +0000 (UTC)
X-FDA: 85041768882.19.184479C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 687F54000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:38:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3fDs+lK;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785328739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNT8IlfcupNjYzcLhZRaW5yCCnoEWSPoABJ1/0dyLlc=;
	b=G1xF1mjXAG+IJG/yS7mB7d9kBXpCK1hnZIko3+P8Ttv7efcr9f01IBXrmt9gAeFR7VGEbE
	c2Gn+mpny7DUr4MMMy8XwFiAL/q00jM4A1+4cJ/Oy2JKm4KeFrrsCXZfwO699RPLJwfirL
	ia09JknGhS9Rd3U/Xz5o7qGumwmifho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785328739;
	b=YutcOIYcokAxy678F57dcA3duDBuOk0ax4JCcpMC9I62qZHhXC0XsyN2FMUMaIwejlanaC
	avgRgQbfR5wAyM73Lfp1cBwRfLI60GtRDlmKsFWh0TcB3/QssK1lBX/acF8bgchBIs4pq+
	FIkimEKP+DF9tPrww7JgHfCAU6qJVJc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3fDs+lK;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5BFF6001D;
	Wed, 29 Jul 2026 12:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5071F000E9;
	Wed, 29 Jul 2026 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328738;
	bh=GNT8IlfcupNjYzcLhZRaW5yCCnoEWSPoABJ1/0dyLlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W3fDs+lKqS7yAg/3WlFioP8nceJExVZFLStdzWpTtm1Qk8QF+GCMSuTFn1LwizMmu
	 UU/zLWW3e85YX+tm/vvx8ISoylPuEB/yNq0unwJ1ycup2N9ol1FFSzJhlluI8nJXl/
	 fP7qzvuBCSy8Sn//vFeHPM4g3yM5fNSmVzzo9n0ZfypKYhMaA0CAGDmtr9ibjChefC
	 FlsKd+SaFnalzmwBdSdKkbSAITA51F6rWXiTMFu2NDkywsGKOMg9OB5yBH+hvFiamR
	 M4i5tsrLAtq3sRTfowyDjGi6oPFZ7OG6Y9bR98HfO4hFH2YXpFsgCh2A5nUozOPUuy
	 bRAx5CvppbGmg==
Message-ID: <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
Date: Wed, 29 Jul 2026 14:38:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 687F54000A
X-Stat-Signature: rorpjhba9bzwbogk1rr9u5dgpoergzyn
X-Rspam-User: 
X-HE-Tag: 1785328739-447630
X-HE-Meta: U2FsdGVkX18PrF7golpEQDh6X6EwHULk7NK5Iwoq+gO4gcv4if4Hc4HD9hdINw1JTdEtaD4YuSUAoVC0+lANieK/jnXls3PyvqjVxemZkLRveF9LypoVn2NY0ZPQdd2EI7qguW0AwE8hW4ML3OrKrQaQo1ZUw+km3xFKQafJQDmBT1NRClKnCuci2W8/c7B9efE6+5U194Be166wbz1fk6+t5YELv0Bp4mmwW7Pwr9PYkZi3xg+dnT/gclF3wwaP1+E9rYL/jiqaorGFWDv+M1Sqb0u1gO1ia3Gxq9IXxiY56r87sJgNWefLm5sSXv1gPZlNkwbEUcU54OFe8Y6YgCTG8PR+iMAkO5Jx6fZRMGsYhd9aks5adiDsBuv1dsXWNqhaROekW9L5hugdzc3ypj6CmHyTD2XR0CseNyy3iAAGcYMM0ngM/oibI80mgztMEs5ECfNTJsKfploknYOcClLQfwOGsx8GsDvCvTaKyPQ8Zs5Aqyf5aNBdzf87LrZjZtpkXjNHIyEcy7xc3q30JsjLZOpsepTfgJOEo919fxV53phMjFse+uyE9VQ4Q3ic7fTR/HpqCWk5k0er53AvA4FzbMucWGn4CVI6LCbaV6Da4aHJhUg3mJQ9nFHU8yA1bqOTMNwQDooDK9brBBXuoOabOWfBCNNLUpWZtw4GYjXV1xHDP/IkKJv3VWcmPvsQZ/qDhGSe7Cw0kIvDqDvjr51IcQqNNafAPKUFd64PMVQASaPT7Iy8iuWdqAWtitE5gC4RNETEyOxw+MQidGNsvRh7no7jOD+tNs2v1iZgaBQxJoSDWanI6Os9f5Qn1Fe3ZsWnU6zksgk2ciDDN+oXIF97VKGLusp/rxqohrqKX3L2ZLPtH18T30hYUYTP4VeEvmUykuL+HsEUPd6FATL+nA3S/G5dsyto9Lgf3VUi949FrI16ea9ekOLXjl2DdKuq47eHlU7W4bnAvyVHvGT
 VJsrRgyA
 QEv2BMZ63SVGEeCZxGZU2dOCfjls6m/FvHpsIcz0IXPzjuk8+YUkLoOzQm95MKQLRaKABxdPamADksOt17ynNhBWOf/qY4Gcx4Of5oLpz8Tz0oF9etnMZaM2axNIMu9GkVBwltaloH7vxxc72PyEBzjpMbYDDAsDeC94eHY/IsrsqyZ40hYM4VdgK5Y8COLuyuq2TEgcPcsQ8nEmifurRox2vWvz8NmJSOgoR2Sn86tD4shS+9wL9zEt7b5HSPF4zklWLDY7ERgcYYiA0AOJfkkmCpDS8Rp4WfKEjBPzPqCvqlreI3Z53g845ekab0uLPEs2qk8BzcpBRonMoHCEAF7ynl3dHiog5huSV9SG+JBgd1nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 19:52, Joanne Koong wrote:
> On Wed, Jul 8, 2026 at 12:56 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/7/26 22:17, Joanne Koong wrote:
>>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
>>> to the deferred split list at fault or collapse time. As a result, a
>>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
>>> the deferred split shrinker when the system is under memory pressure.
>>>
>>> Add anonymous mTHP folios to the deferred split list so that if there's
>>> memory pressure, a zero-filled mTHP can be split with its zero pages
>>> remapped to the shared zero page and then reclaimed.
>>>
>>> To minimize overhead on the common order-0 fault path, the
>>> deferred_split_folio() call is guarded by an inline folio_test_large()
>>> check.
>>>
>>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  mm/memory.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 6637c5b13c9b..441d918e3dc0 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>>       folio_add_lru_vma(folio, vma);
>>>       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>>       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>>> +     if (folio_test_large(folio))
>>> +             deferred_split_folio(folio, false);
>>>  }
>>>
>>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>>
>> I had a session [1] at LSF/MM about having essentially all large anon folios
>> part of the the deferred split queue.
>>
>> (1) I don't think this scales.
>>
>> (2) I suspect the shrinker should make smarter decisions of what to scan/reclaim
>> first.
>>
>> I think this needs more proper thought.
>>
>> [1]
>> https://docs.google.com/presentation/d/1RfKWCY1AMVns-WLn-QdAWbI2a-rA7fbFyh7XD1Wn5BY/edit?usp=sharing
> 
> Thanks for the link to the slides! Was there a conclusion from the
> LSF/MM discussion about the future path forward for deferred splitting
> or is that still being determined?

Sorry for the late reply. Unfortunately, it wasn't clear yet if we could
reporpuse the LRU, whereby we would just naturally benefit from the LRU cache
(soon) and only manage pages on a single list.

The concern was that we might end up scanning many items on the LRU to detect
splitting candidates.

I am not 100% sure if that is a real problem.

As raised during the last THP cabal, my gut feeling is that Johannes might have
an idea on how to improve things here.

-- 
Cheers,

David

