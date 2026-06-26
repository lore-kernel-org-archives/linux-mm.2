Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47AAEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47976B011C; Fri, 26 Jun 2026 14:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF94C6B011E; Fri, 26 Jun 2026 14:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3496B011F; Fri, 26 Jun 2026 14:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B26B6B011C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:07:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 152DF1C34AC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:07:53 +0000 (UTC)
X-FDA: 84922847226.28.72C4E02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53717140007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:07:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQKUT1uS;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782497271;
	b=QRQ/gd9m31LhKENHZV6B4KnqAHBcxsxFUjdrI8fVt1oc/5Y3khjCRcMdOLZXAd+QdLCclt
	WIeDEabbgjR++rq9/lo/JmS9HBGYD06/SHNlHoJJ7OmM2L1zA7XmKh+pJlCBuJl+aKs44W
	pIDO/+5udzvUw3ANVATVB3ugolN+smc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782497271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VL1nHVZPTfavofIwp9gpOh3SmHbzNBRcvKHEMSpIbFg=;
	b=OOsS4S2DxDU5AgAhbFfecjM17/830kTQIDSg4fXw/pXreL6XGZZQ15Kyu0i5q3v9ZM41Bd
	yGJd7Q0ADj9vHadRzut4LtuD9ZaYL155OW5TQxChOlAhgmXM/4fIPmZVdfUFobkFsOna0A
	L+c2ToWwLmz4/u+QjbvgBuSc4bnP0PE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQKUT1uS;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EE33601C4;
	Fri, 26 Jun 2026 18:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973BB1F000E9;
	Fri, 26 Jun 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782497270;
	bh=VL1nHVZPTfavofIwp9gpOh3SmHbzNBRcvKHEMSpIbFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UQKUT1uS4wbGc81aYsivha4ghMYSw+zS2A8Jw6cgXRoAyLdFw8mG3RmH/1Xv+Pgaf
	 x9LWCsRJVv0e9Lw/naxu8UwhIPNcs5FxQRe+mfzcKy+ZXZJGzqLU2mMVGWflgoVYGQ
	 JKhokP3ca0R+GBKN0omFwlcWHWatUxW4GvRUTJoz874+WDh4fJI4+6hugg1t2d5NK/
	 xr7JHoupim3OF7y7fwAoLtYJ2eG6t6en2p8qhnGFipIgTU5/2a5CJaG7pgmQw3mAvs
	 UA/v05PIUZxOY1lID555z4QY9Z2Jg+37m8pl+Xpzdja0ojRAM9j2knyU/yvyB2SaYf
	 xXWTb52WhTDOw==
Message-ID: <ccac4af6-56f0-43f3-9964-1a5a45d10188@kernel.org>
Date: Fri, 26 Jun 2026 20:07:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
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
 <521f8943-bfc3-4414-a630-634712c709e4@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <521f8943-bfc3-4414-a630-634712c709e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53717140007
X-Stat-Signature: xqow6kpbkkoj4kc514nnckfdkywwatun
X-HE-Tag: 1782497271-64691
X-HE-Meta: U2FsdGVkX19kS6g6vYxMBab1R87v15sTp9wGtgyMwrhFJewFSpj7tVCUAVhsBoaUyByiq9IOO9KvdB3RM7nfqvT608xqjfeVW4h06tB+6/6td8Ch7Y335ATuuRn42634onHzwpRtV2hJNnGU9C5vFcW8CylQHcqgBjLN62E1HpUOL1eTh5hI+eUl3rQO32LuH4Gzzj2vVJoHADc3823St86k3Wq/hT6GXFpVSY8BOxOPgVHKIMNuwFK0fgDjxGYfesTKx2G5DBDcD8aQ5YCKJWFIRbAMhoSl0C8YD+tTOEVh91KiiJqcT7j//whjxAKgiY2Lexc0EcJd8XtrujSXx1qdskFmS2PcYMEmId/tDJ1nimSlGsrlKRqL5/3ANo9PT3NWTKfxXwPdpDZBxkCx6ml6LGCPXEBhLgTxnwfdHf7wBu99+2eWOJdToH6QQDyuYCO1pi8yrDsWDMGQ1ZegHX0vgsAAI9CbOeWPOw2/nJ4wZBRNRukWAnnOI5B1pHRP5Tijk9YLmfefy3QJKAwtvhLQg4SHuOVPsGsuGDS9P3ESDeJnFcuP7QxZCVo0Mmz9Ezod3YsMO8D/suWJHvnNwSPuTEtN9Chnzglcf+28A+MWoqQHkN7GbthFMwWBvW+3MxY/EFzNHRMv7gN71OTVvXm5aHd5XE8H6eEm1b0nMFDI/Jg9kqZPTONyriHiCB5EeiKojntUiJjQR2m8iEeS3y+/puZnYRpixErS7IRb9Ort2rKhTaiN7TY7/OA0G0yIk1rgnxUZgRrE8Va1EAfHPZT62Z7iwe+LzKjMLF53oid79VRVrL0VWtvGnXIBgezcAeHfFEpVCLlG5VBlwUwulDPVIfm65kUbeGsPtty7S/XIXQk1qEKTDS63FecbRIoP2+GWJA0h0JDtnJxA8EmiKDQ5Y/YdUGG3KriVPTvpDsY74qce4R/6Mm+Af7F97G5s0flcRFwATbNIdLplL2H
 uXOJF9cC
 PB7xln1qcFmHdSvAmef+WSPBGiLOCCv/mDlax2YVZ+JalMzX50mPcuyP+ymLbrKEpyC8cQHYY17lT7VeqqjPZ/m8lkRboFO3J4HMqKl3ZsT342Iuf2rOWsrIxCIrzXixzBqFROPQTiuTBoDOvTTDxdr8BtNuKCye/UMs09eBbbQuhQu8diRQ6x+b7E3paxc4uysN5DEI5hW7fSW3IcCxbD0CwAtI+Bzph48uX3Xu/EFnLRicSNRlUkL8kJQMD7kelpJONQ2JxvdFy6bPpKmeGG5EKNyFz1FRN3u/X0KXccOtPLYIJfthQRuLJiU7e0to8OrAY4eBtg7PlBSX1LMr/HkbbpPGOuyEsHl4Una5YnqZVie+uHfPYjsttyqHfIGlKxTOVIbs3dmHQVsEtfv+VquliKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 16:30, David Hildenbrand (Arm) wrote:
> On 6/22/26 15:07, Brendan Jackman wrote:
>> On Mon Jun 22, 2026 at 12:24 PM UTC, David Hildenbrand (Arm) wrote:
>>> On 6/22/26 12:01, Brendan Jackman wrote:
>>>> It's no longer used outside of mm/.
>>>>
>>>> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
>>>> this also means moving the definition of alloc_pages_node_noprof into
>>>> the .c file.
>>>>
>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>> ---
>>>>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>>>>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>>>>  include/linux/gfp.h                             | 16 +---------------
>>>>  mm/internal.h                                   |  4 ++++
>>>>  mm/page_alloc.c                                 | 11 +++++++++++
>>>>  5 files changed, 18 insertions(+), 17 deletions(-)
>>>
>>> Do we want some mm/page_alloc.h , to start splitting up mm/internal.h
>> 
>> Don't see why not, if people are on board I'm happy to do that for v3.
>> 
>> (I just realised I put __alloc_pages_noprof() at the bottom of the file,
>> while it should be next to __alloc_frozen_pages etc, should fix that in
>> case we don't end up going for the separated header).
>> 
>> So what would go in the new header...
>> 
>> - All the buddy alloc/free entry points
>> - ALLOC_ flags
>> - alloc_context
>> - buddy_order*(), page_is_buddy(), find_buddy_page_pfn() and
>>   __find_buddy_pfn()
>> - post_alloc_hook(), free_pages_prepare()
>> - zone_pcp_*()
>> - find_suitable_fallback()
>> - free_area_empty()
>> 
>> Anything else? Or anything on that list that should stay in
>> mm/internal.h?
> 
> Above looks like a decent start :) Thanks!

Ack!

