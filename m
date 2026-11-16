Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFD0606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTv0PSI7
Received: by kanga.kvack.org (Postfix)
	id 35EE76B05DB; Mon, 16 Nov 2026 06:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337066B05DD; Mon, 16 Nov 2026 06:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FBA6B05DE; Mon, 16 Nov 2026 06:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC9126B05DB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 882A4A08BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:36:23 +0000 (UTC)
X-FDA: 85440779046.19.404624C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3CBD140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:36:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTv0PSI7;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAYwOqj72xaPTAga9I5XXxlhmXlx4t/3+61UtxIhuH4=;
	b=zJ3hG6B1C2Molu/LqcHBnXlf1EjhmPZwvpy9dQeTumtTCIBPUHbQmCrW3B4Sbh8c5uwNGb
	7Gk2B7MSiqWCswS76qIlaaOKd/ko/0+IR+Zh7d4og5VWWz6Z7D3DX7++npVW+kVRjz7WG2
	EF5iScU7Pau72X7NWJLNzDeUc2Dc/DY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828981;
	b=OrtDHcRAKHLlABSwXYOv+Q77BG66OtQjXnwx/sKYov83m//ljNtJhPID5aJQBHKbXNfMOi
	f0c6I9/HYyHgsFwy3dgSHMwXuVbalKLwC1HElvKNd17gJoiPbdwgMQziJTc4XQsnrMYe0i
	9716KzgN5evS+TARatJ7HSCmDJr41TE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTv0PSI7;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5A02456C4;
	Mon, 16 Nov 2026 11:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B9C1F000C4;
	Mon, 16 Nov 2026 11:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828980;
	bh=pAYwOqj72xaPTAga9I5XXxlhmXlx4t/3+61UtxIhuH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kTv0PSI7IUDsu8y078oL7oMWnCU2IlWTNtMb8yCl0kYXvUvuBMP97EuqYc0pnvWah
	 Z3z16+lOzn7oRU+zdC8d0huLlYIKnEHMoNLOXatg9xkRo9Ly3i1r8Qw4G2OQkWeFI1
	 O9YUGB+wSKJ9GU7bk1T8wWpoCEYjxWYHq0PwM74scSQA/9h8KxrGxxlWykW/V1ZBZA
	 gLt0T6RJ30N98+9OXDn4pRH7BIYeC5A5yaL5+QaRP/oWLILT76V1PxusJoVwqiIL3r
	 oQZzLlIXHTl1w9scVpvv7h839eW9rPt4pIxmmK2jEUVte41RTX1+K75eFidNoivJyw
	 ugZ+/k8UNW9bg==
Message-ID: <b6765576-0db0-498f-8564-3a0ecf420b37@kernel.org>
Date: Mon, 16 Nov 2026 12:36:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: sample empty pageblocks again from a
 random offset
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261104101747.2485913-1-kas@kernel.org>
 <28a340e0-76f5-416f-a74e-f74f4a2c2d36@arm.com>
 <d92f9b62-5d2a-44af-908a-ef80fc8e1766@kernel.org>
 <avroysmflhyRZ42p@shutemov.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avroysmflhyRZ42p@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3CBD140009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6rstqx9yc8zw3khfmpfr4y8iqgxgz7ng
X-Rspam-User: 
X-HE-Tag: 1794828981-260696
X-HE-Meta: U2FsdGVkX1/PVOJKzjDUloNb1eM5+ZGNAoIktE04BiTipdFS5Ir2iQgL5e2jNwrWx4ITQaQmlCo/D2lPfcuQgn9LFwW6/nQN0WORrX35G77233w21xRsKPZwnWmRw3qnSiEeIk1nFqNTtKp/YXMzl6UuKk7VL0WQxvkp5wXT9Qt79Ga4Bw44mjMW+OcC8N14smHoinnqSAEF+NZcdt2Gec2m8nl6N8K3NnNi8b0OhBNzFtWjC7llu1FL2CAa/zjjXC5OPCc6ZNODao8bgzTVsRwhEy5eUK8v6i5IXPPRJpAYKVeOa6dzNov9l/fXvbEtmd4bYRnu5Q4zy3x9ckSHnlVGYtU/dkM8HNnzwpsl+EC6l0Hi0d02N+FOeqjsbIK0KaND0u7naRpy7RjSVFDS6belvFCajfinSeAs7hMeY7hQGV9gl+glfeZp7/6W1mfLk4NrubWSbLPf0+DZwBT76PefME+uoSYGx2JZtgRjVVEI+WlFjr1W/a+uyl6EX3cWK/EID8o0Qh2ULO9IYTrTQJqdw25iFA54ZyZbUJzobI9J3mDDwWVyruEk9gYfIGMYbCrrQz8K2d6HfMNGGqTngDv3od1gtTZepaz/hRjwqkhEWSi1uOw/IRhIJumiroOSExSRGbsF5fDb+CySpgqsoslSBfbhn4PwzaXf6b4zriHE8jxTZpmustuSbzI3cDUaCgMHm/ZaFw5rpDEA5vHN4XllcQj5KcdhDIEXW0Q/TbkzavCZ8vt+qgag2PLOjyISSaAqLReJfwdxFoi9PPETB/n+GD6IwTfyq/7gxQGS3Pht0wAltofC1ajcVnBr4utL2Bo5tQiCEqCyQlnTbuu6VaXGPRY/Em7gfQS/D2nOMkBbeAIj2ppzCWreSIBfa+YaOctKnz28TxmDZYBmtQZl4UHVINxHp126DuEHp0Eo0Cyr4hBwlhDPGip0BbqcQFPthqnZR/TZ+nfk0MTLe/4
 WqxMNhgH
 0IB2HIDXHF5TtTgt/qS2VNdncb4y445d3ObmYoRRY7kH6NAl6pG2NukybbjvRqoEHxDJnWzXxtMDYzoelyBWO3rtcUpGaptm5rkHLj/fKRoUmQfKQfnptSxw7GMpkF02q8bft26x6YKMcGV+bEEP/53NKJ5MNtLCPkbLMXlCFSNSSEuGoaGdnZ0CVfWppOXl8cbNHbRVNg4TeqVSOsUMPfne+lTC2rFhJXFnmJcnw3v2dcjwxxpaSbe96iFJu5uhPM51E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 12:32, Kiryl Shutsemau (Meta) wrote:
> On Mon, Nov 16, 2026 at 09:38:29AM +0100, Vlastimil Babka (SUSE) wrote:
>> > IOW I think the probability this patch is going to have a downside is
>> > more than that of upside.
>> 
>> Agreed. This seems to all be based on a hypothetical scenario, only
>> constructed artificially to demonstrate it. A real-life motivation is needed.
> 
> Fair enough, let's drop it.
> 
> It is not entirely made up, though.
> 
> I stepped on it while testing another series. A fragmentation stress
> test gave bimodal results: no direct reclaim in most runs and hundreds
> to thousands of allocstalls in others.
> 
> It was confusing and looked like a regression in that series.
> 
> It took a bisection to find that the only thing that mattered was where
> the free pages fell relative to the stride grid. The test in the
> changelog was built after that, to show it on purpose.

Yeah I think it's better to make such stress tests randomized instead. Such
regularity might hit even other unintended effects.

> The workload is very artificial, but the fix looked simple enough to
> post.
> 


