Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30CBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9706B00A6; Wed,  1 Jul 2026 04:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A496B00A8; Wed,  1 Jul 2026 04:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841C46B00A9; Wed,  1 Jul 2026 04:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4F46B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:26:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1C1D1A02AA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:26:37 +0000 (UTC)
X-FDA: 84939526434.19.29F2477
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E481C000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:26:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3Z7BMXD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894396;
	b=cF+1ClDvOm/+bN8lKxFa/VJx03SjiO+rRXMCjUhkbE5StG5sGOpe+RrDPe2jrOEnbDdnzN
	zNX+/KH2mX2jGjUOd4nJyE3q0uxoywVAHqSGZm+6zMJ7v9B2uh09PW5is4MZCus/gxQ0Df
	+FR1IAHt3Ezr3zjTeRH56I2WgPaIyfI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T+6J6rF16tlV8s9JGhRswkVJRz4ywliNTiQ4lmmWRg=;
	b=zAf9ofY3bF9U7xG0B2jQ5u9ylwGxIYpJ4r6UBQJ9VXRx9pW9gLfFro7z/jcR9zq9AM2+py
	xz6CP1sO0Ff2afDhrJnyXOfM6gWbpEYB7TjFd0Q1ycL9k1X50p6n0HD/SvSnDkHn9vzSgn
	Bxw6M9syvLQJ9QjfT4/fWpPwreMc60U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3Z7BMXD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38D4643356;
	Wed,  1 Jul 2026 08:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8569F1F00A3D;
	Wed,  1 Jul 2026 08:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894395;
	bh=+T+6J6rF16tlV8s9JGhRswkVJRz4ywliNTiQ4lmmWRg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O3Z7BMXD/3eyk+k/b4yeYELZ1QysIsroVxIbhrZy8ce8eHAFukhtRLDsgY2+iPhy2
	 Fwhrf5+Cpin6juYgi7dSgn5vPHWFXIq8NmZOOeGOR8XkuWJChLFiNjG+8xtb/bpuit
	 cZ/O39SiQykRMytVEDFPLz6LBZLoKYhB59d8FOgLY8TdAi9vLnWIC/sqqZVNT5DuIe
	 PiVhwssdVaT7lfDToXrHQW2KbU0rge7a1y//tJtWiFGxGlPQU31sW4fDOQt3AX46XJ
	 lkmeS1LpVJWaWSXro1KZXp7c1OqEHtqKB8ImYlY3YDgV9TFXCevaxMIe5bPL440PQi
	 VsFRQVqZUeGZw==
Message-ID: <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
Date: Wed, 1 Jul 2026 10:26:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
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
References: <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701041112-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E481C000B
X-Stat-Signature: fg1qqc6pu5yc7s8fbete9utmmfoysbe7
X-HE-Tag: 1782894395-93397
X-HE-Meta: U2FsdGVkX1+zY169YFJGqBgRPp5IV7682dMXgeD8Z/4gSWTRExdqjJQw1npRNskSgg96K36fyuoska/lf/BNMkdoatjkCc9JRHcbx0obpuzioYR5L1guQdUGMuXO/7hylGrjJ2hMOMkpBxqpm04PB6STk+AvxooFQp0jIE2LyIsZ8Dhoq6IAYM4Yousykt36kLZE/UD6Xs3DvEV/edCLaN3Ogm3gkie3EYMtKDXFvJ1Te1KQ6uP11F4joBkXexueIGF3hLjI9ksdAPAWGF+KiFWOJWkKoXHot3t0h+CvSUjqWa2N73iUjjzHwAixZNSwI65i0eSIXM9zZSQoqX7IuNqWOpTk4nSsdUwMuJ5d/CjCFlZtNBQVGMmXD59lB34st1f84qY7Y6yfuB4hrtcoVgrFx7AcAlE3uQZDXKlO0khRwiH7xc4PUJRl/lYxSThM/3RADa99od/Adt9OnCm/HmPEiv+VhxljpU2UjxIPPvLLXwocXLXtz1E854XnZcPIDJ6cuLph1eNQJii1fgT7IkNKTHpAxMjzX2ny1OPPrwMhv1lLvau6FQksMppD75X7EVSEX6dyNpzrz50oLAQmBg7VqnGvdVYb2d6EciB0VE93rbNyv4JSN3fDMLQp6AxzQScyDfvYlJDzzlNXA9nx5kDjIXxHwR512HmdZDY8lhUeSADFEEH38KGXW99SAhUl3yhIlmqkJebGSSZS3BLlJXCjd0+zA/lJjJGZN2E/oGahnrRIz7FmHVpntKNCmmlp8GC/PVTf5pAZN/jBHNpiP5lgnlIE3mlDC0/X8F7y1T6O9Rn3Ehgkbzq73cOazwmXswujidnkintjQjK/d1va9w/mlNA3b7lIQE/S+qOO8fLytMAgnCGjAiM7v+PWLfsdwN95WcyJj6Y4bP+VvzY+C2MdUh0tNHdUa/i2nz9WWzIQmkCWRMKk6mD4a1EVv9dLb8p1PIBhj1+hNk5ocKl
 tnlEOQgw
 xS+2XzjT5PX1O6h/EkAmXp1ykvPzycdkaozbT7ojSWuLmykrV3lFihSLIMyP5sIC1Hc4yNkHvvjCeQKRDcX8Ievfoky4WUAEbMODh79LchtKnWmbhuPl/+OLASlviEdf+HHE5QS49g8DdJ8bvYVe4OLL3Mbc3SfRALhImE2YT94aXgjP9x7LZxH5gRKu11LD+qMgOudzagcTwq7m1F3hJ/ze2cV9P/DmqE9C6iF0T7D1sdaU8HRVKlFXi+OPjQ9vRCZBU5Qo6tToLh/LotpUc/UeoSibD12LdTLAhxY5M2JosUrmvy9H2pJWpSJeu+8uWrgD5Go908bb/SkOrHDwaGlLlrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 10:18, Michael S. Tsirkin wrote:
> On Wed, Jul 01, 2026 at 10:08:45AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Yay. I did that + dropped the extra lock/unlock and now it's in the noise in
>>> my testing. needs much more testing of course.
>>
>> Cool. I'd expect that latency-sensitive workloads (PREEMPT_RT) would not want to
>> have hwpoison handling either way, so using the no_resched variants at these
>> places might be doable.
>>
>>>
>>> If you want me to post (including addressing your other feedback) let me
>>> know.
>>>
>>
>> Let's first discuss the options. We essentially have the following one so far:
>>
>> 1) Ignore the problem
>>
>> It's been there forever ... but I am not quite happy about that.
>>
>> 2) Use atomics everywhere
>>
>> The easiest+cleanest, but as measured, the performance hit is real.
>>
>> 3) Keep retrying for a couple of times
>>
>> The big problem is "how long". A CPU in a hypervisor might be stalled for quite
>> a while (20s? can be longer).
> 
> So on this idea. It might not matter. What I had in mind is:
> 1. run the current logic
> 2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
>    (or call_rcu_tasks_rude) maybe
> 3. in the callback, recheck and if poison cleared, go back to 1
> 4. otherwise everyone will see the bit set, remove from list we are done
> 
> it seems to not regress anything, and for the rare race, we set
> the bit eventually.
> 

So test-and-set (and friends) would also have to check the data structure that
remembers bit to set/clear (and possibly update the data structure).

That does seem doable. Do you have a prototype?

-- 
Cheers,

David

