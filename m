Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE855C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD84E6B008A; Thu, 27 Aug 2026 15:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89066B008C; Thu, 27 Aug 2026 15:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A775C6B0092; Thu, 27 Aug 2026 15:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 790606B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:33:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1C6FC0193
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:33:14 +0000 (UTC)
X-FDA: 85148047908.26.132293A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2CC49C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:33:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6dTwqdt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787859193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBxAGEwWU0H0ff3LVsxf4cSkIdLbDrdQ68KoXtPl+VA=;
	b=Nd4q78YT79kKUrXOr24kyJVOsVw2wy7ust2atKK3vV6FdPEKfQYW0Rp5UGl8u3stoqhh8U
	8m1NuvGl+HEGIWGbhwzyyNH7MiucK6xH5TFfzwy1C2zzw/Ue8w5KvM07KDElzBd1mG9xo5
	5lQdmfkeZgIzx/VOMPKzWW2LsxpoaII=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6dTwqdt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787859193;
	b=M57swil3KOM/x4UDnFUXE273qu5yMOEE9CQneHCAOT/75abV7GrkTdDiKccyLAAJIbMzJJ
	wE5gJk8/jLVeTEW8VztOtRrrKnSwt2JNa/xDHNeOA8eht4zDqNzAxsftRHtR8pshoHNMp9
	iylKQ9tSD7NsSJvmfpfthFg9J44OQbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51EA74162A;
	Thu, 27 Aug 2026 19:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D121F000E9;
	Thu, 27 Aug 2026 19:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787859192;
	bh=QBxAGEwWU0H0ff3LVsxf4cSkIdLbDrdQ68KoXtPl+VA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e6dTwqdtGf+SyEahxsEzGjp57PZcdWa3GU4Uz7Xd9yCRQN1Fe+cZ/zUpgCul2Y23+
	 XyP93+n5L/BowvMUDI4/vMQcmXOGe3/ZNjAdYWOUypx7JmXVXv03QPBCDE0TeHFiwg
	 mEdGzDn7K+cMXBMlrEeHVlgSd40tjkliSIE/D9BQu++seWSRY87lxADLmVDA2q4t5B
	 kjvIpNKxjCF2vccxPmLA7xkOrXmP+fqhL0/UfY/Dp8sAks+c5k4Beel/zy8oKUU7Ry
	 NQv+sgbN/DtcRwcQNEL6kNLSiilORjRruaRv8o259RHSF4XMFhXrq8Ix4O2VOBQAIk
	 9gO8ShXQxXjLw==
Message-ID: <08115f0c-e2a4-4c65-a56d-29c751ee9360@kernel.org>
Date: Thu, 27 Aug 2026 21:33:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/18] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-14-9b43f5163238@tencent.com>
 <9adcaf53-3a40-4d97-9365-b9af97891894@kernel.org>
 <CAMgjq7BShyGaT0rvZqbHP7r6_A7BJwnJLsVyo9cvj1ZVt2e=cg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7BShyGaT0rvZqbHP7r6_A7BJwnJLsVyo9cvj1ZVt2e=cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uha9fpncj4ouuh6h7ymwrnw4stripfpk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CC49C0009
X-Rspam-User: 
X-HE-Tag: 1787859193-718074
X-HE-Meta: U2FsdGVkX19GspxjoOWaCG1Qqc+Omd7ZnMWANcfttGRhDqgaYdcIu7cUNeke9RvhNI8ZDBN6+sYtkp6NDgyMogHDEy52Bx+ycaU3OAoxxAtH55hgn0H4QYliqMJkf02W0rcWPUgvP5KGY8hpJDRn6IcUqXLX5HAIGqwNli4uIYzFqPKeMGtfwdlfxT31DYhSwfVZ8KfkHhvnstCu71LwUXpx7sjPyn8hg2CaVtyRPQ0616O+QDlIiL5uAc9a3+pVPNWRmv4hIADotP1iM33F3FSa/c1MvY7Sgt8qgnyhHrrrvqKlCyQb9c6NqOfc0yFBM1EyoufixhD4ScTM2PL2fS9QWvsCO2CtsNsW5W7K2nrM4qwDZirPoDSTo8/0oU1xiZXOD4STVHwZefaM4Mgmi3j0WhcuKrIIBeKmhwHzgKS/WXx/3//C+0ugcqyaaGonrvoTi/Q2Agw8vnIXS6lbZui5rBHJ7vAJ9QdhXW6ThkyLWt7jHblhpeSwqg55pLtiWTeMde6ISRZ3swI3AF+JLODnAY0WV05HoiTkUny2d7UCIqzX2IVcoC6oMnNMnfBjpDCmQZJp4P0ATjtYXOaCRQvDmjWCFSfV0D7wCIbFm5eo6Ov18d4sovoCZEZXNecyy38AHuNuy3tIQ7ZPR/kTfMqWuVINp4kdnWHf0UcYK1YQuaL3NyfIzzaZPTxjxK/7SXtyvEHHjacdBzgt0Bp9lyQSh6Qy/33tbgK6/Q4aLMXnTC5Ry1lFTFxEX60X0qkt9nDymutS4UbVGiWQ5wqJCiQ0UIpcGljmY6nte23hV+zjBLcz7zAhdvsMdD0xeKmVTcaiBZWC9o1wQcmaUfxD/hDmoOL+R6WbjtMLGCAuvTDMzXGR2zt/j929E2bxVYSOKhl3PVWpBCrDQYYZH3wOyQZ9zKtYbBfhoeJ5F0WBtDjljqXFiGdixF42pznIiAIZ7Nhl+vVktPHJFnEbJmB
 zrV5euk0
 4NdLB2Li9JPi0gHwJtRBM2jYUsU7r/web6Ld9asXzpoJZYREr43F8SwE7Vq/ooa0ntXCGNIhEVkbW5U8JCDJC5LoxzlCc5uw19ufRPlgYSxBPZbLUja5zGMdOJgHdZo45R+B6IG9l6xQVIlvILSGNYzitYW/RRvCSe+nEtX3CIAwf9OB4nUvJavMQla8w1OfY0/s4657On7rRtVOLVesgMyHI4AKIPG3a1A+JOclRH4cKdn10qol/xkRUsRI3ktYVdkntKCV1oo3B04ZUeL6btzWm46s7YiytNukTRdF3QB6Nx3AjYxdDH+mvdxJLK+AQl+8X/Dv40UzBPC22wtMAp6opQO5QHe88qCwzKoUi9q0mX9sBMwWegVk7LsmJr0XUL8qjCLwy+5x19z8MJFlEmZcm1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 19:47, Kairui Song wrote:
> On Fri, Aug 28, 2026 at 12:48 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
>>> and folio_put() in the after-split loop.  free_folio_and_swap_cache()
>>> unlocks the folio, then free_swap_cache() must trylock it again and
>>> re-check folio_mapped() before freeing the swap cache entries; if the
>>> trylock loses a race, the entries are left behind even though the folio
>>> reference is dropped.  The sub folios are still locked and unmapped
>>> here, so just directly call folio_free_swap() directly under the lock,
>>> unlock and drop the reference.  This makes the swap cache freeing
>>> deterministic and the reference drop explicit.
>>>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>  mm/huge_memory.c | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 84c6e4bbaa88..113a33cddace 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4337,14 +4337,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>               if (new_folio == page_folio(lock_at))
>>>                       continue;
>>>
>>> -             folio_unlock(new_folio);
>>>               /*
>>>                * Subpages whose mapping has been zapped may be freed
>>>                * earlier, but freeing them requires taking the
>>> -              * lru_lock, so we defer put_page() on tail pages until
>>> +              * lru_lock, so we defer folio_put() on tail pages until
>>>                * after the split completes.
>>>                */
>>> -             free_folio_and_swap_cache(new_folio);
>>> +             if (is_swapcache && !folio_mapped(new_folio))
>>> +                     folio_free_swap(new_folio);
>>
>> But this is effectively duplicating code that belongs into swap code.
>>
>> Should we instead have a helper next to free_folio_and_swap_cache that consumes
>> an already locked folio?
> 
> I think the only duplication here is the is_swapcache and folio_mapped
> check? folio_free_swap is a common swap helper. And putting the
> folio_unlock and folio_put in the swap side looks odd to me, since the
> folio is locked here and refs get here through the function's
> convention. Pairing these unlock and put closer to the convention
> doesn't seem too bad IMO.

I was more concerned about the folio_mapped() check. Because the code now has to
guess under which circumstances it makes sense to call folio_free_swap(), which
is precisely what free_folio_and_swap_cache() avoided.

And we already do have other code doing that, like KSM's replace_page(), and it
feels like that should all be cleaned up.

But no strong objection to your current code. It just looks a bit suboptimal
that we have no helper that wraps the swapcache and folio_mapped() check.

-- 
Cheers,

David

