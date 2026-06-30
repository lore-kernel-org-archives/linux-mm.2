Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1F3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648A16B00AA; Tue, 30 Jun 2026 02:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620E06B00AB; Tue, 30 Jun 2026 02:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535A96B00AC; Tue, 30 Jun 2026 02:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3506B00AA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:41:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3F221C64B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:41:18 +0000 (UTC)
X-FDA: 84935632236.17.8EED813
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEB911C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:41:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFB6IX51;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782801677;
	b=QXgEaywoJMtXDVDZPWZgoBqom/OECu16TXz78AaDTMD7ej0Rqsq0tkpoJw81xCivsSGYBx
	kjSxN3QHx/8d8wbItydm2EGsk5k9EAkAuqYHyO3Wwx481ASeL7Agt8HZ1D6HriS1UOmrx4
	JThmfSbIdwvh7VIwThXrX5kNmddeyNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782801677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nI2NQuj9axv7/9GpcIQsccJdAB4fSHkpahn0YO/2zjs=;
	b=gAmtTS701mK7vcn9hlh8RIYr+xIxVlWfgY9NU5Jkv9ejYob9VX9JVOPVK3C5r30+g0qPmK
	OwiJzYH2/VXw3wa243NekeEpoppyOnaJv43NOUKh7eODYO2gMhQeLZoj9+RrLN5VmPZRat
	ee/jQ40ok0ziVr7+aHOa4y27zn5C7mI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFB6IX51;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F364F41820;
	Tue, 30 Jun 2026 06:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4421F000E9;
	Tue, 30 Jun 2026 06:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782801675;
	bh=nI2NQuj9axv7/9GpcIQsccJdAB4fSHkpahn0YO/2zjs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=MFB6IX51UbWeIAS409nXOBLdnR1JlNtyXp9puSvgJvGFWdSCOmehHKqu3qPIiKa11
	 3oe44E3mkkab2kDp47lU+FDliMetYVAXG4i9762UnIatpbgIMk2erzvstLqLlse5gW
	 thLA67JMpu8TaRumNcbskKicY5MfP5DG95E76WU+cmN6s3y25sd6lWzec+wRFVMEZR
	 uc23iP4xMkxGR8VIHqy7upIO+4pg6IWCdueNrIqj+ifmOLIXCTJB2BffmVWCR7jMZy
	 1fA1IcNPhVipd6NgCX2yRODTKOZ5b7Nl3glTypFKXOAk8d4rCxuCq8hnw+H0xARgjy
	 8y+UpG9sCrpwg==
Message-ID: <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
Date: Tue, 30 Jun 2026 08:41:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEB911C0002
X-Stat-Signature: xkehgudmoyzd184bb7dgdnkpjp7f9met
X-HE-Tag: 1782801676-844670
X-HE-Meta: U2FsdGVkX1/BeSRQHfCXCiGjQke31zrZ0FYsEXmFWq8ExB85jV/prJrBQEs8WY04QUNwHu+cnfZv9penkYNmALyiPHYXKH9lf8JXtvvAmf4vSJFzFjAtZuloPAhIRc+Ac6KRYGYGl3WTazA/BuwYsVt46/U/MhXWDAgNCxHJd52mvsUqKRXXhHkr5EfZmQ+FZzpL8/ytOCYB4y3SaBhwR49tPzYenM4hBQagKK0GSDtTby7v6tzOqTyD+aajC4L9CJoYhsBXQoF9fAkW0Nmu6JLLdcjdfc1mk3ElijmZsVfoZUd/jlZZWRJp/4V5WaWu9VUvWVpdKAIdHT857d/fWNDaZuyfIOf8ca465uUNt9Wkb9P0Fs65fadMIg/2iqd/BKGQifeH763FUK1yMI95qWqjK7YeoYbSZn2GQLWAnxuB20AVeQcjBVgvG3OM0A7t8+bIG2wY40uJq/i5VmFsUBXvl1RMicPIT8blP8Vd38GF5r4upsTy6h9QAssa2x+ZL8RSG3whH0ohKMGGkxbLcXk0I0GrL4fMJk+8SuLocBRBpM4JdYVzKUW3XCDwknEvW8aVqxWD2Do0VboA7s8Z7R8gEuzW+lcFCyMvo8/9AEGxNof9m1T8CpESEH/cKofMinOzZrntNvCr5CtOT/PkSaVwyCm33qTtD+N0Blu9CstKmMjU02qlBQbnNbNIHANe0eU9tGzu90WGhAM+6cgai0q9N+W4xaAGkHndj+tYGhIhSgDy3u2w3nM0Np91KPHCtgkxfirSLW9ZB96G47ZY4pgqxwVKPrqxorJBN5wzEv6N7+vtsolIPRLUNZFtTiowCNQPiy7/V3RwupmN71F+GEntjQqKuPD9Ies9F8OLrd3QrqLdqZvIdfzm9tKpO7RTdF7MZKrVByv8Rxnj/10XffKZ+gbSQFU0zWupwyvPNk44hjGLF6HvCx755QK05dlwPW5hQXa3VQm/EQNIk6f
 mMlEt9mf
 h0Hp/iCbJYkqYMpBBht0TaaZ+2e7UCTIyj4aMeKNcY15JeWXku4deuhXH+R2SFiS7Eet69IJyrqoTulne6yBO3j01xhULeXTNvQlL7JAojxutGs0U2UcJvWSF0G+faUIrhSnH6Sr6L6spMT321Sy5B/LSIjshekRxzZkCPLfjlFLPFqDlam8GO4fnscd5FFpYVahJTb9JwUjV9BB+kcS2DMcDciPnTRdPC842dg6HNH96TrthiEPNYddyngBeYBFTDEeR1LyxJJ8486Mt+mqX/aWaqlXclLKklwIlbgKQeKaQZlvWKLcJKqLEjIMrXjcr3zi+FhbG9eoUSltOqVGF8bDCuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 08:30, David Hildenbrand (Arm) wrote:
> On 6/29/26 23:50, Michael S. Tsirkin wrote:
>> On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
>>> [...]
>>>
>>>
>>> Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
>>> read side locking is essentially for free ... well in some configs :) )
>>>
>>> The question if we could optimize it reasonably enough ...
>>>
>>>
>>> ... for example, by doing the rcu read lock + unlock around the
>>>
>>> 	for (i = 1; i < (1 << order); i++) {
>>>
>>> loop on the alloc path.
>>
>> Is this different from what this patch is doing?
> 
> Ah, I missed that we batch this already. We could make it include the
> 
> page_cpupid_reset_last(page);
> page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> As well, to reduce from 3 to 1 locks.
> 
> So I guess there is potential for optimization.
> 
> [...]
> 
>>
>>> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
>>>
>>> I wonder if something could be built out of preempt_disable() and sync SMP
>>> calls. hmm :(
>>
>> rcu_lock is basically same as preempt_disable if rcu is non preemptible,
>> no?
> 
> Yes. See my other mail, I learned that preempt_disable() should likely just do
> for our use case. So the preemptible RCU case would not matter.
> 
> I assume that's as good as it gets.
> 
> 1) Use preempt_disable/preempt_enable to protect
> 2) Batch as good as possible in the page allocator
> 
> If the overhead is then still noticeable, there is not a lot we can do to handle
> this cleanly I'm afraid.

FWIW, there seems to be preempt_enable_no_resched() that is a bit more
lightweight. I'm sure there is some downside, but it might be worth a try.

-- 
Cheers,

David

