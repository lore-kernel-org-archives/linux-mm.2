Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FA2CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393AB8E00A6; Mon,  3 Nov 2025 11:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343BF8E0057; Mon,  3 Nov 2025 11:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232E98E00A6; Mon,  3 Nov 2025 11:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8B08E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:22:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4A0812AABB
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:22:17 +0000 (UTC)
X-FDA: 84069813114.26.83C1600
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2968B4001B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:22:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvA9utsz;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93+ZMb/4mIf4qQ3AmCtM7G53Wq6Z0RQUPhK6X+iKcsA=;
	b=HYb8bhyr71GJCyCoZ+JtwLdaoGS8MqyRAtwfJQyfcMNzBAo4S6XOx/ywFuLkEktpi9NzUy
	or+Vmm0IZkFqdgWbgjGS9VcHx8u4TYvZQAgHiCDuemyP10BOfxCighFAnd33SaXplHp9/5
	JCXoNJVfJVghAZTrWREccncsa0JTkHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvA9utsz;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186936; a=rsa-sha256;
	cv=none;
	b=miXw7S8Tr+bpsMuB2sEq0CDSz6zc0ZJG2O22H9mxWRDU+PFEt8hfSCTbkbk8VUyHi9zcxp
	0Bg1rTrBdeUzvrNb6smgkqo4Mtb3QNm7z2a7hawgF3sxgFbN1WtMWYAsRrKccZQQVfoU+J
	npZ6eVKM4wEoJ5WC6xbDx9m6DtxCQ44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A39F9601AC;
	Mon,  3 Nov 2025 16:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1BBC4CEE7;
	Mon,  3 Nov 2025 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186935;
	bh=Z7KjMXog1PRlKh4Zv4wlbe/+ecFkJDd8Z4g1l7xwdxo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=jvA9utszEKdicNEG7rEx83mKM4agoKVT+X1bIfGUdcFsab40r4S+uYzz/jtd+2yi5
	 RBeBNKr8dlP+Q0aK9CGdE5MAcbpM3RePEsjrSeXxWUiIFoNyS73wLD1g55NQA6Fydy
	 s5VMSOU8NXHFVGsjKVb3iZznKtdA1U1VZxTIM5VsLQTjd9LFCRuhle2kE1c4amsZB5
	 hBKpJjttBlDJCby6V7l7pY/uqtfzKCRrxoYD593X3y5o88va7rzyip6oeDjiVgLUgB
	 Uhi+95xtRYaApYpek8T0UosOGFN6ySjDtEGB99dqO3m7Sq4ouYP0ssTPYfzppbwkp+
	 S0emZsnI1qjBw==
Message-ID: <7870dde4-801e-4bcc-bb92-7b75a6a4a4a9@kernel.org>
Date: Mon, 3 Nov 2025 17:22:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
 <3b098e0f-7632-40b7-9201-41a1b5b0ae42@kernel.org>
Content-Language: en-US
In-Reply-To: <3b098e0f-7632-40b7-9201-41a1b5b0ae42@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2968B4001B
X-Stat-Signature: dbnkd79g75qx7z5skjs6bn6fwfm4o6uw
X-Rspam-User: 
X-HE-Tag: 1762186936-898873
X-HE-Meta: U2FsdGVkX1+zjZ5cK7Gc7psLYgy+eMRSa5tftR+AhZevyOu7pmC9HMcwFTjY0cXeoevihsLf9UD8oyukxInTybC1tnCflSQZZzB4nxSbifNBqz1elNr5jCmQcvKJuCflsIH0D8rlExwpu6s7w8f5N+QKWjQ5M9pGrNkHV0D+bnl9l1f3mDy7E8qo91SZmOVLX+UAevbzOJ/SlITjC79kowyBCOzg5mwvAARcHvW8esDUsFT9JwafBZPsihK84IUr4pg4gT3P2HMdwn8NlNeU32Vd7n85fucQzrwtHsEC3gWXdnyXt/s7rsNm8rIdqfYZSz8F+oH5XVTMI+rvZRSeI8vw6u7oo8HqHHQeb12FJU24buQBkVU4nQS2xIjLBtIhgu4hkx+pnRGIsLWPQa8Tl5DcUwIyobKB4UZ7gVjWM/sDAcJGPLOq+2zoGq6IiVF0cAWhoeem4zccy/5irw+7KXVEnjMzCswbYNgJJVFelLMmFF+E0pGuONf9T/5GJAA0HtcgctRJxWBJ2DnmcYl/dxkFCWEfn2DK0EUFB5iheqb0mI825hQNqI3xr+DmU+eTrQBdtoQAAXiPtjwZ5dI51ys+h0WiuN5Cy/NSGOwDga0m57wvzrysFhaxaT5Xc2komXVtyr6tF/PeQxaUISHivUDdSTGi0tmNdNYEiNp+bxuANwnD5uQm7XZnCz1uTmAzn2Jx/6WzPfPhrUrGjyj1Ngee6If1XsdbeyDGGMZHqw9oFTNP7y3HbYUhGK+a3fmAb6+1tAycg5i3TNBDQG1wHw2GbwaCyaJkr9NFaQuhBK4S2rYDqOgoY9y8lTJ68CEFrieHa4cVm2Ez1R4qC1dSuK3p2RSKy2/95/4isOP/rM3Y18IplMcjIA0EjQrTlvtjqjREmPjG4AjyOrCI/946usCZaFsvGfcFZugscP1e8YTl8VK4h0wxZ29RIMMu5UpofcC5Y7ABR8raKAW+6y4
 53M5Z5ye
 2PO3fAMqpuqXQMp+t5Cx+ZsC/UKA30Gk4HbMeU3rS2R76AB6BQ2vEGHmtnQqz0VIw2KkkMcgN9w7OyqQLKD88KCfoQLncRu7jFkKnHa3A1I+kF/hajhu5XMVUhKBpDBlCmbd99bicmVPdJkpnavKoKKc8lTN7ojxnyOHJwbxtLAPROMhbJFb47ItMYQ7adJQW28KKWXcUlkYS2FdTRAMNj4XvdqLOP0h+rHzluaPc9FiSEWaa+6OiwIeWMvLaZ0fl2mDfm8TEYAqIlINXwvaw8kLmJG36liNams2AvwVKB7T56jEcMYa8xe9LNKSOGmBcqI1jKkfjO3uBlFtTqbOvJxLyRoVnBgNDK5uUoYucl9iTd02y0T3xCgA5hNvwXEbM29RSze0ecbZrZFUas69V5QpNxnPucaxMR0pfbHuz/xKwicGB/W5fos/7AkQet4MJu3ZI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 17:21, David Hildenbrand (Red Hat) wrote:
> On 03.11.25 17:20, David Hildenbrand (Red Hat) wrote:
>> On 01.11.25 01:29, Wei Yang wrote:
>>> The folio splitting process involves several related tasks that are
>>> executed together:
>>>
>>>        Adjusting memcg (memory control group) accounting.
>>>        Updating page owner tracking.
>>>        Splitting the folio to the target size (new_order).
>>>        Updating necessary folio statistics.
>>>
>>> This commit introduces the new helper function,
>>> __split_folio_and_update_stats(), to gather all these tasks. This
>>> consolidation improves modularity and is a necessary preparation step
>>> for further cleanup and simplification of the surrounding folio
>>> splitting logic.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> ---
>>>     mm/huge_memory.c | 28 +++++++++++++++++-----------
>>>     1 file changed, 17 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index c37fe6ad0c96..abde0f1aa8ff 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>     		ClearPageCompound(&folio->page);
>>>     }
>>>     
>>> +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>>> +		int new_order, bool is_anon)
>>
>> Is there any good reason we want to pass things like "is_anon" instead
>> of just querying it in that helper?
>>
>>
>>> +{
>>> +	int nr_new_folios = 1UL << (old_order - new_order);
>>
>> Could be const.
>>
>>
> 
> Looking at it again, and that we are not reusing this function on patch
> #2, I am not sure factoring this out is really helpful at this point?

Ignore that, I was briefly confused by patch #2 :)

-- 
Cheers

David

