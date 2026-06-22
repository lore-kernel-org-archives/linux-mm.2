Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A78CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE5A6B008C; Mon, 22 Jun 2026 10:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE3D6B0095; Mon, 22 Jun 2026 10:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075BD6B00C1; Mon, 22 Jun 2026 10:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1956B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:30:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C844A1C475B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:30:33 +0000 (UTC)
X-FDA: 84907784346.09.4C35FFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C3FE18000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:30:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqKGfHkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29wlnAiI2bMRng9KpYCVmkZd+U6WPzK0BpRtgoiriR8=;
	b=NlvWOi6Y/n+b0hgOCDDNIRZUBI/FtjIKHNtbk+NQP9eKr588LEJqOlIrjpqJHV/yI6KyT4
	bF7mccYQgAJbcV+YWI/HbyWqCgwntzCrQ4Lkb/eGcfvl7nOyZPzKY5bl//xBDTdNrTvZE2
	dJyMCnkVZIAQm3SwK/RDBllo71i9kQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqKGfHkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138632;
	b=cquPXADTHW/xUDc4miADMw/l2YIrHYi3KEOce+GWZhmAgnSzYvjRUVd41Ti+8TpnlbrKp4
	jlQYmN82Bsl2+oQZWlbNycdV8piZR+cXfbXWscQJTpC5qYK+7ICDOoKU9QR9gRi4s6f7+c
	Ucg/P32JHD4dmKsgE06dRuEqcu7iMtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87EBD601F6;
	Mon, 22 Jun 2026 14:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE941F000E9;
	Mon, 22 Jun 2026 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138631;
	bh=29wlnAiI2bMRng9KpYCVmkZd+U6WPzK0BpRtgoiriR8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FqKGfHkAaTmFHI7Tpe5byixGjH6JaBo6Y46v0JrmWT/fqTFFmigr0uO/bs4YN18Zg
	 2z8RlY60jutBXu67OSzfz2HIAqKQ7GZm0DyRoUauplYC/7FHprjMErsBCGwgrsuD68
	 aQBUCRWVXW5GboO3WEnp+9DWGMFL+nll1E2s88dTVJZhhuCLy7K9ej+b/jeQJzgjl9
	 3vaiD/pdKq06uNSwhWKkuQ7KpEufBtJRNpLtSvyFnQXwhmHehyJTZfjKzYp1YyCu9S
	 YK9s8Vmt1lUvbn5XS/Axv4adqEy5CnGCeQWAd/WJqVM8G8d37pZ037PTNGUPNrgfWP
	 vfISQalsYjJhA==
Message-ID: <521f8943-bfc3-4414-a630-634712c709e4@kernel.org>
Date: Mon, 22 Jun 2026 16:30:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
 <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
 <DJFLNQEBX3PK.1ONMJBA46AQNL@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJFLNQEBX3PK.1ONMJBA46AQNL@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C3FE18000A
X-Stat-Signature: p15h764btx9ft6pkdyas79f13rmr5goj
X-Rspam-User: 
X-HE-Tag: 1782138631-565004
X-HE-Meta: U2FsdGVkX19I/hD8HxIBEnfU8GAlWGrESf0PY6/mjuDPnllwb2FTskfmmr2LHegn0iBxF6nzFnUspglj+gJb+It79tBQi3ILZmYLR2YyKw1s/0AvWca8gMooGWaanLGny6GItabQCLbeZRUDGoR7IjmtpqFe2/m17I8sn5rknWwBlT3CkhB/C2910px0oOaO0NLHmVKNheIa04Lgs8SnCK0ff15opfmfZisEwYtuL/SCuuxIomBqp/9Edefr809BBqJ5A+KpjttWEk1pB5oGYIXpqceEEX3CE4t3Hg3jIUasdIqkTtHUbNrOP460e4a50BskeNtGmHPlWS+/XEp3RE9TME4P7M2oZK8VCXSBaeGmmPbKeNUYYKsU7/5u2MD4fL9Lt4bZk5Ji5TFIYOBCRZ8LBN3ZoRlHbi9/N6yqJDZDeqFD0P3auaBQjDidFEnJoFvhYlRVwIKB7SQB4xxSdHGwC73WY9d25SFWaG6SwbuN/Y0RYSxme2T0eg3meaxNi2io1d1Syn1xOloH/MVEKnhghMJswu4SBSSkqRSwIYapgQCKYnli4OMRI+zjGVY+JZER4Rdrv4zB+xgKiW2ulgslQfl40b2cLk62HGue/4+7UqaY2HzWrVd5+Rzx0vTyFk2v+W3NKqIB6rR0gXrClNRtvwG2191XYVzelpXSzJCtqu0Xea3KmQyPHkPZCT8OQMOD9drzmBlgHGAo613JdlrTXosOcEPruDFZLHayN+x2iXarb0WUvneWStzvIJvUYXNaVkhE6h8EmAqYbPKd60dJHwKfQDcefJOaCTu9aPc/uTtB/aBeEH67dk5WD0tyvBI+g15JwBwwCouZWndXEsa0rNnBRmo7RfbC0meH89YFXkUuLAPuFxFPvXNjumJVY18ycMqF4jKXkNn2+qC/AlMCzn7hA0fQSATAqo+sMEYhm8fvVpgixnzMkO8/S7a9aNHs1cE32OvRzlGiDpf
 2OuGZ1IW
 +DENQIjTHhHziNllSuiG9cneqIo5l4vJxkZDFwoOYgaaFt/vSJvMBDR/sTZ7evxieETcXaHgIpN4pDtfoFsgiW+nBrjiqjnsyeDE+XfGp62WFXslL4SsQ/ElqAKgqR7+oJjmfFPtP67cC9X/kqHJn7pMD+INrrBk2VKt1pymg8l7wGZKpdHl7MqGpNm+FkY9XK/pIWKDKFW1394O+gDpqjjIsLia/slb1XygR76+rxacVywYlMkJ6onlwiFyjTCgM9jwxna4tWfIGmeftBZQMIf87YxW8x/Jj0U3EEkf7541En9IaSuVjGiE794KD+3uEhK5/dRzHDbacaxIr8kL4NbuD+G6Re+9jSGifflMEdDWSJgI2qOaT2eRUj/9F64ybX5Cudup/irSuBQsM0NhELA4e8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 15:07, Brendan Jackman wrote:
> On Mon Jun 22, 2026 at 12:24 PM UTC, David Hildenbrand (Arm) wrote:
>> On 6/22/26 12:01, Brendan Jackman wrote:
>>> It's no longer used outside of mm/.
>>>
>>> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
>>> this also means moving the definition of alloc_pages_node_noprof into
>>> the .c file.
>>>
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>> ---
>>>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>>>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>>>  include/linux/gfp.h                             | 16 +---------------
>>>  mm/internal.h                                   |  4 ++++
>>>  mm/page_alloc.c                                 | 11 +++++++++++
>>>  5 files changed, 18 insertions(+), 17 deletions(-)
>>
>> Do we want some mm/page_alloc.h , to start splitting up mm/internal.h
> 
> Don't see why not, if people are on board I'm happy to do that for v3.
> 
> (I just realised I put __alloc_pages_noprof() at the bottom of the file,
> while it should be next to __alloc_frozen_pages etc, should fix that in
> case we don't end up going for the separated header).
> 
> So what would go in the new header...
> 
> - All the buddy alloc/free entry points
> - ALLOC_ flags
> - alloc_context
> - buddy_order*(), page_is_buddy(), find_buddy_page_pfn() and
>   __find_buddy_pfn()
> - post_alloc_hook(), free_pages_prepare()
> - zone_pcp_*()
> - find_suitable_fallback()
> - free_area_empty()
> 
> Anything else? Or anything on that list that should stay in
> mm/internal.h?

Above looks like a decent start :) Thanks!

-- 
Cheers,

David

