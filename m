Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFD3CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16346B0005; Mon, 22 Jun 2026 12:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE936B008A; Mon, 22 Jun 2026 12:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDB16B008C; Mon, 22 Jun 2026 12:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7FB6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:45:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D53D1663C7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:45:02 +0000 (UTC)
X-FDA: 84908123244.08.824A54A
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9EBAF8000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:45:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsRdLFfi;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782146701;
	b=dk91X2ceiM+T0WFkWbTuoe/o5DJyjgJQYRThUKD7ax2jDtslwtm4/Y9nLzC5CWXBso86s0
	rIA4v0EeVDm12fNDGGAHhz5ZYl07KkQ5HGUpbUWk0Ks3oTdTcEKSZFH3zqs/NrJE0a1veY
	s7+ymqBZpenS5YYaLgNPNPO+kqVLn44=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsRdLFfi;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782146701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=il/CHFZlvXOVfdz3Uj3nhgSGn8a07SJ8y7KWOpcXefE=;
	b=uJy4p0CTtKOjCI4yY2bMVw45CigvOvB734kHKxp/cPDKg1R6lVaC4LuB7+2nXJK+Oe4gnE
	6vXobhVOGAe2JLvfdxfAIWyMmwJBgSn8NdTBOgEa1yUjWhydtipsPUfSWBzJUxKgt0C2tf
	hWclcG52fBnF959Z+m/4dqtNiXu3y5I=
Message-ID: <eb11e336-c77f-49f7-b97f-9ed336f44097@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782146698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=il/CHFZlvXOVfdz3Uj3nhgSGn8a07SJ8y7KWOpcXefE=;
	b=CsRdLFfi1aBT3qWPVCEqqLyDD3L/TNWmDmV3XOsg6CfYigqzY0L2K1LliUdygwXFd36HcW
	THK08vM2MAaIkBLClVP2GgjcDWKqMUsc947KRP5bEW3RNjtW/IKsXQUT9j1HVHBN/e+wUy
	hdvpKHswllvZh/J8Dc70HmFS6cdYjt4=
Date: Mon, 22 Jun 2026 17:44:46 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
To: Wei Yang <richard.weiyang@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260310105419.3256755-1-usama.arif@linux.dev>
 <20260620072721.x4dfh6gy4wnjqre4@master>
 <f820a74a-ee28-4888-a5ac-e1c4de8c0202@kernel.org>
 <20260622134331.xvbpu6edwml65myp@master>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260622134331.xvbpu6edwml65myp@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dune73q6erfbeko1oqsn4gee6364j3e6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9EBAF8000D
X-HE-Tag: 1782146700-730847
X-HE-Meta: U2FsdGVkX19uTwj8VqwgshpIT5CUq+by0oK7+qv6xo8NSry50QCjqS1iVq1LzHCO/mYcccbuBbBZBj0jRvMy6VKmVB4n61emXjYI7urzacdkyWtO3edhgUgS9ApSIIC7wuEs/fLurldr5KPBOo4ZSTbbd+63W+KQ7Ahuc5gh7MIyUnZjsEoDza2c5YTNiEB4a3abAWSMfI0ddAG8naalKEYYrgKnVizphWE9TSHZutrbB6wfbq3k3+EyY2vyOy59eXBdmpdpjaoaqj1jTEo3TIQM8DG6Snmeo20MBjiXxUQtJ0kwpDAcQakgpojgXwuLHsh0Mi8u0WGi7NmbLx5NL+/UakeN90gXxmY5WKvnu8yuwlq6hNAp3Qwyq4leSSTZ/B8mEvRwjj2yh1Prkw6k3Hwkz4wfsoCNh6R9PUduY8pdhP43hvWIPv3U4yHeHOqsURT9c8gHEOSBuGk1EriWYdtAcmXa5dCx5tFnOZjksEpyrGcwPdHIwUiPuT6K9uZODcers442DWC2myAhhZBZ7batGxd8Z4xqF4Jehixl57ZjHfFgDWzGu7BdXTWjvOrW1pieXA0Fh8A2NgY9kDUlj83avAc/z3+XyyyTl7Wb9Z1fms52FPRA0EWeOGVSSvdngeez7CpznPgzVPYmGjb53RFMmWa5cJhMYAUuuagnRBtgjEj4eYEe1fZ8ECzp/VPgGgTgXkRSYKsmTrrnxryi1UjSxS3odsFfBh9ttDMlPPkTuIN4THjbhHKsVJcmm+zJvmJuG06giodp1AwqNsPRDNtPv0dnCqKUzmKpWIirlT7sSkEWKnq/pEtAXLQr3aT4mxuugMFyZQOWMknh4RefinWIYNkuYvEXcWQGPbz456MO+IKz1u5vX6MT+QvMOt2j9/OJ6feOA3KF3zrWA+ZS7JEBdq3MIN/d5wckZwoW+k6fkvg8y07Dvtl5jBddmfdqBgdik5m6vQM0zu3UUuh
 AOjj27Wp
 rdgsZLUyl43neIqi28YQMy/OyPokqRowVQfoR4PfXWLUSIHrDIWunclotoi2oh4hMCgmaZEP4YLZjBlYV2U/4uvMhwddKRox1mcbJa1eTNOaziJbEuqr6B2KLybd5D3fwnJSmBLM3C8cZFjlQrbijiNBBJeSq+1jBoLDkIzVdtaceuLtJWTez2+jM6HYW5gWwWk5SL8x4hqedQkFndWhG3mjwnq7vRGvb1dqgHC8Lv8WOdVkUnEkNLf0J0HH4RPWkRdQSGbD0Q45Tv95qepOTCQkkR5z7/p2DAJFNvG0v9yaFnbJl5ooA2GkcuzNz6u6Rgq5xV6Z4+uTfTQjJIEPJxHjd1K4//WG6FE8H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/06/2026 14:43, Wei Yang wrote:
> On Mon, Jun 22, 2026 at 11:16:39AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/20/26 09:27, Wei Yang wrote:
>>> On Tue, Mar 10, 2026 at 03:54:19AM -0700, Usama Arif wrote:
>>>> During folio migration, __folio_migrate_mapping() removes the source
>>>> folio from the deferred split queue, but the destination folio is never
>>>> re-queued.  This causes underutilized THPs to escape the shrinker after
>>>> NUMA migration, since they silently drop off the deferred split list.
>>>>
>>>> Fix this by recording whether the source folio was on the deferred split
>>>> queue and its partially mapped state before move_to_new_folio() unqueues
>>>> it, and re-queuing the destination folio after a successful migration if
>>>> it was.
>>>>
>>>> By the time migrate_folio_move() runs, partially mapped folios without a
>>>> pin have already been split by migrate_pages_batch().  So only two cases
>>>> remain on the deferred list at this point:
>>>>  1. Partially mapped folios with a pin (split failed).
>>>>  2. Fully mapped but potentially underused folios.
>>>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>>>> so that the destination folio is correctly re-queued in both cases.
>>>>
>>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>> v1 -> v2:
>>>> - record whether source folio was on the deferred split queue before
>>>>  move_to_folio() (David)
>>>> - record partially mapped state and update commit message (Zi)
>>>> ---
>>>> mm/migrate.c | 17 +++++++++++++++++
>>>> 1 file changed, 17 insertions(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index ece77ccb2ec0..61013d258eb4 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>>> 	int rc;
>>>> 	int old_page_state = 0;
>>>> 	struct anon_vma *anon_vma = NULL;
>>>> +	bool src_deferred_split = false;
>>>> +	bool src_partially_mapped = false;
>>>> 	struct list_head *prev;
>>>>
>>>> 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>>>> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>>> 		goto out_unlock_both;
>>>> 	}
>>>>
>>>> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>>>> +	    !data_race(list_empty(&src->_deferred_list))) {
>>>> +		src_deferred_split = true;
>>>> +		src_partially_mapped = folio_test_partially_mapped(src);
>>>> +	}
>>>
>>> Hi, Usama
>>>
>>> I am afraid there maybe a race between migration and defer_split.
>>>
>>>                 A                              B
>>>   migrate_pages_batch                   deferred_split_scan
>>>     migrate_folio_unmap                   list_del_init(&folio->_deferred_list)
>>>       folio_lock/folio_trylock
>>>
>>>     migrate_folios_move
>>>       migrate_folio_move
>>>         list_empty(&src->_deferred_list)
>>>                                           folio_trylock()
>>>                                           requeue:
>>>
>>> In case list_empty() check happens after folio removed from defer_list but
>>> before requeued, we will miss this folio.
>>
>> deferred_split_isolate() would grab a reference through folio_try_get().
>>
>> How can we migrate a folio with a raised refcount?
>>
> 
> Thanks, I missed expected_refcount check in __migrate_folio().
> 

Thanks David for pointing it out! I have just started looking at the
mailing list for today :)

>> -- 
>> Cheers,
>>
>> David
> 


