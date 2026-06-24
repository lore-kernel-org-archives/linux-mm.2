Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3ADCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A9B6B008C; Wed, 24 Jun 2026 12:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4576B0092; Wed, 24 Jun 2026 12:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DF86B0095; Wed, 24 Jun 2026 12:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFE66B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:44:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C1FA1A03E9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:44:26 +0000 (UTC)
X-FDA: 84915379332.05.EBE4875
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id 894AD20006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:44:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c4KpaYcG;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782319464;
	b=8RvznfGBNYdkb4YNPjqmirpf72/bnHp14RvJR/n/Oa84+ARIg3yW8rvaBkmNXnZNybVH0q
	x1SpnZzjXXbT/+co7ZKGPdaz8RY2J1/tjgZ0hfKEiZlpXlUt771zv2nViYOWj4OC9cTQw5
	5coWlYRv56wnS2fTBm1EXpx5X1f0nuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782319464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nf45tH+DZxDmO3Xa8ocD4s3OrE54bf3xPt2q+j677fQ=;
	b=Vd3aWAPsRTmp3QiuS3cwaO/SEbvB0pPcVOI6wVrFWarJNAKrULbsAJRtu/+x3WTjsC3pRP
	ZLXkCrbm2oMCq9z3EmRgPvjLxr7phvufTfhTbhe83vCYsDM3UwGu2WW4DOQjGU7wnFitJu
	LlpNaIHli1N0JLcMzdMoOLjf4hQ2qlg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c4KpaYcG;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <120367a5-0a3c-40ba-a821-f46f8494ef85@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782319462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nf45tH+DZxDmO3Xa8ocD4s3OrE54bf3xPt2q+j677fQ=;
	b=c4KpaYcGLpCl50YxEoCnwFd4Lo6D9bMArzTKSQ6bqq7KH+Es0YpHgnF8/5t9/egp5Qikeq
	UP7tnUOU72oz76r6+m98C/WFMvQd7o0fM4iDOyBu+UOp4P5jHBbzTYhEZcqCeFT3ZBFQsE
	z2SzxS1mc4zxpdgiDD8ceOUNzqKqKVA=
Date: Wed, 24 Jun 2026 17:43:56 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/5] mm/memcontrol: convert memcg to use
 page_counter_stock
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam.howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260624152331.2228828-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260624152331.2228828-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tm9q3ba6u1kjzbjbkfj967xf3gbttd3c
X-Rspam-User: 
X-Rspamd-Queue-Id: 894AD20006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782319464-239414
X-HE-Meta: U2FsdGVkX1/8bM4IjMkoy9tiS4kglrlEpn24HDpnkLvaNPmOSMa9t45n7gGRPzYwxd0kuiW8M6gmuBTT1CfdktsVkfQujAz1Cwdfu1TTnDe42gNs6eHY3E4LymRgKSiYlX5VY6SfD177qQwL4U55ktGpJQVV2UsK8Y3rp/rlVTstrIZL9gQAh/9aSBadQjo7So0BPN0x7OaKydYtxJE6hwT3bshsBCUU/3gGequF4H75yYpW805EaT6lfw0lay571Iw3YRRLZteKh8jOSyV3YnX8QUuHh3XdKPv+DEl6km3xJR8aYdf1WR1TK+9fu1NetlsHCkFd1rxU3saEjH49fQYleShy04OCDY4ERWHwGun9xNK8Sexv03nvBLe6F7s0lE+dT7Vq4Z2+06YB6Jg9a2aHWTpicnDDmFdnPjhubcIyY2gR0Ue26D6hqyT5b6uSPL/XPr53ZBojJUtGk5Lxy3TuRCXSxBWcP1B3Wav0UjYn6pWKnNO932CKMqRmqbMdrHUf53usnb5X12doE5qhqhOPkF4mdw9cqU1MpToa6M2aUYaX4q8f6EUSsAMWURI6KWW8EwGu7ofSgKX79hn540SuibZi74dMqryqgTc92ZCfbwIF9bSZGlxIzZoN6eLgFpERttk5L8G0SD1PoQFowipSp4zFPzdwsVcOzbvFmZ50OcM1daefEhXi/6K6XFKvU2V9YoHdXKHf3eDxUMYuhK1iHBqHte0P0T0RsFOaP7Mlb/co3C9iBMIb95AIKDQw3zc7yUPlDkQJc9J+UYQdlZeft6LkhvFZonzynuPJichlb/1OAivXocHzcBtEGx5Cg3UQUdC8yfj2q+2XfRARshwCoS2oTZoKtoOpls98NoHDzIZozmyVNodDEP42vbfHMIzdEJfqcpCtgTM86fX2vdtkm0XQs3CXMZ14V2Aom+TdteWrQfd0saB8Ae25YqvhlzXLFl47UflgK8MzZ6i
 24CLn4kO
 kxsay/1Bzsbr2PUAKTEQqfVh2nrpXEjjOCywPpNlGlVnb/S+yxRDVvvIPEUlFbX842iUkU9YuqgbX4bi5q9bcJY6NnjcY5k+jJKfms6ulPTU02tIj0QZu8FX8C8NsBW6ZLgfySXNO+5rS6CzgjdBqv/FPnTpT3ZjoEEep6XVZDQ62UxPgAlChaVQtVmLdj2chbgUkZeU162/6cJBPzwEAAKpU4QzP0ojK2HEBsiob3eDeyrlrw30BVbk1I2erL7YdXwIaMeR0uwQz7OadFdYA1VV0Upmy2W5CVn+cZAYcvzk/IcittKIVh/BVbyEHfyGGrfgYTbvgW8DqfqBChmSD/80W6PaqdCDn+L0vf9j8atB8O5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/06/2026 16:23, Joshua Hahn wrote:
> On Wed, 24 Jun 2026 07:43:47 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> On Tue, 23 Jun 2026 11:01:22 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> Hello Usama!!
> 
> Thank you for reviewing the patch : -)
> 
> [...snip...]
> 
>>> @@ -2595,7 +2596,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>>>  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>>  			    unsigned int nr_pages)
>>>  {
>>> -	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
>>>  	int nr_retries = MAX_RECLAIM_RETRIES;
>>>  	struct mem_cgroup *mem_over_limit;
>>>  	struct page_counter *counter;
>>> @@ -2606,36 +2606,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>>  	bool raised_max_event = false;
>>>  	unsigned long pflags;
>>>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>>> +	unsigned long nr_charged = 0;
>>>  
>>>  retry:
>>> -	if (consume_stock(memcg, nr_pages))
>>> -		return 0;
>>> -
>>> -	if (!allow_spinning)
>>> -		/* Avoid the refill and flush of the older stock */
>>> -		batch = nr_pages;
>>> -
>>>  	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
>>>  	if (do_memsw_account() &&
>>> -	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>>> +	    !page_counter_try_charge_stock(&memcg->memsw, nr_pages,
>>> +					   &counter, NULL)) {
>>>  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
>>>  		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
>>>  		goto reclaim;
>>>  	}
>>>  
>>> -	if (page_counter_try_charge(&memcg->memory, batch, &counter))
>>> -		goto done_restock;
>>> +	if (page_counter_try_charge_stock(&memcg->memory, nr_pages,
>>> +					  &counter, &nr_charged)) {
>>> +		if (!nr_charged)
>>> +			return 0;
>>> +		goto handle_high;
>>> +	}
>>>  
>>>  	if (do_memsw_account())
>>> -		page_counter_uncharge(&memcg->memsw, batch);
>>> +		page_counter_uncharge(&memcg->memsw, nr_pages);
>>
>> This needs a transactional rollback. page_counter_try_charge_stock() can
>> succeed by consuming memsw stock and charging 0 new pages, but the
>> memory-failure path unconditionally uncharges nr_pages from memsw.
>> That turns a failed allocation into a real memsw usage decrement.
> 
> Hmmmmmmmmmm....... I'm not sure.
> 
> At this point in the code, we are either (1) using cgroup v1 with memsw
> and charged successfully, or (2) not using cgroup v1 with memsw. So I'm
> not sure if this really is unconditional, we're just distinguishing
> between cases (1) and (2) by checking if we're using cgroupv1.
> 
> Or is your concern with taking a charge via stock, but uncharging with
> a hierarchical page_counter walk?

This was my concern. But I re-read the page_counter stock invariant,
and the stock-hit case is not an undercount? Consuming stock transfers
already-charged credit to the pending allocation; if the later memory charge
fails, page_counter_uncharge() discards that consumed credit from the
hierarchy. That should keeps usage equal to real charges plus remaining stock?

> If so, I think there's a case to be
> made here with just simply returning the stock. I just wanted to keep
> it consistent with the original memcontrol code, which only used
> stock to fulfill charges, not uncharges, since this could make the
> stock grow without bound.
> 
> What do you think? Thanks again for reviewing Usama, I hope you have a
> great day!!!
> Joshua


