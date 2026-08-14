Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E376C5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69F66B05F2; Thu, 13 Aug 2026 22:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E236E6B05F3; Thu, 13 Aug 2026 22:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2DF6B05F4; Thu, 13 Aug 2026 22:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DED76B05F2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:03:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22D0CA0109
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:03:40 +0000 (UTC)
X-FDA: 85098228600.06.6625ACA
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id 094D7160006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:03:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vp8cxxFF;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786673018;
	b=Pl55z3cL2z+FAjnYXq/SO0bP+JoPOXDFFKsEY6YRtkBI1D6+zCqEX8mVjOEGXJbk6F01cl
	hOi0qK+mrpF1/6EUCgmF1uNWMmjuN6EqoS2iCfP+dxlI6XFZwUVcSpeYCiIYaEuJ+H2FMu
	ti0TqMwSdEA7NHokK7mchifKGncEuV4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vp8cxxFF;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786673018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X3gEMHb5DGgjRHDTMqwtUuArcBJYU+RDmksBN2tQZK0=;
	b=h2KWMxC1zN+WPPiA88Us3BnvSP1UBvJDukVz6t4y+20mTsO3xT/NyauGRQ81gbL11m0y9l
	Bunc0zfKaE/9gJeCszIBxsa3hF/ZJBY8sebnbAYqPdgwFmfNlJ424vp90uDK3lsUwdF0Jz
	9zxOJl5z532GbOBP+mD7le1JVhfFw8s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FDTPR1K3i1romvlfONK2csdHyjQzry+zjKN1gNuyHmY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786673016; v=1; x=1787277816;
 b=vp8cxxFF+RhutuJN2RgsXA49IDkpuvSJpR2oMdJuyjM/paKpx+TBhRxgutMc7LRcK+vtEXOB
 rLJNEDmuzD5mz87igQa8uhUsVjFFjIneLzeWuQ+oKjeJhyzRImsWTvrtefUuF+KVD0yLObo+DGn
 3SGrcFpAyVNmnHwoaHUezSjM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id 394907fbe8eec464;
	Fri, 14 Aug 2026 02:03:25 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <f42dd57c-29fe-441c-ac5d-d4f990b7f6ee@linux.dev>
Date: Fri, 14 Aug 2026 10:03:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
 <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
 <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
 <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev>
 <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 094D7160006
X-Rspam-User: 
X-Stat-Signature: gwuega5rcd6juqg15kcan78pitqp4nof
X-Rspamd-Server: rspam06
X-HE-Tag: 1786673017-920616
X-HE-Meta: U2FsdGVkX19cTLVG4YvCV+tmPYUOMNqd0hThcVMa4H4UJ3Aos0gpqXZY1qkIzGHg+0tuZvjpNKCeo0taZfGW82TLSmcVwzZQaXrKtuzkm3mM7Q5PaVWlvPWn8zq1CNSua5UuqalNimlHw14pnUZSDYndLE+jr/mWYuYaUQzC0S+smNPIGv6o+ZFCpA/IA/SWFNwuIPCTfIEdlOoRdCvFD+D3ykE6bovyRNm4qPdck0OpbyarEA1osoT+J28RXQPSNewlD4kZBhOcbj+0+rYvXZDoOtkyCmKD//CmE6WD2PVRIcbAfOPrnM3mPHkq1AxR6NY4BLa+S0HB2l5rMOjsontYBuLlOU95LCMD4+dXdERpqoruFU9xOuWkWFpa5XzfDU8oQPP3oWac3ucWCRk2SRMpyFCdSiVBbSTIFI3alpYWb1gwdz060Wfh2NrFj1XrvHnr9MjPbYmzj4ud4nx7O+uIXhi5xNjInKgZlcK5fDm9lANOZFEA9BYJ4XB0YLvPtZPvRXhQV/i2ucMZqvmkQIpL6ME1JOtncKpTU+UvpASkP6gAnc/Z+2I4M/p5xmVDNj+EA+Ocs/PtRAxU99t4Et6msBvh9x1I5e2c1fri65HJjiyMe1nTKcXcb8aMzomhO9M/5IUl/4S5DW9MOHHBO4q14ZeQWXsTTpNT9R6l6QsO5yOj0AiWomkej7qI+ZbB2B/ghekohg+qqchhflN4wi465BjWQyktMgIkhbe0sFydVQ+UQqRH+6KqVAnZ/s4YBEIlUpYhun8zQOY6CskS14IL/1eqMdHqvgMVEY2QyjtfARjCmoN3I13LzCkWnzmWRgEsyrBfbEFTYliG60INWSQ4ldUKbH/FXsyeHcw90oaM2/jlT/GgYnhpm8sXOObMatUjIVqOZ6AsdkscrgNIcepeARJXUGW/ObMmldwDwBlmvouZP/Ff2Qg5Zqfk/pEpp+0YwZlmByqlT0LpMcP
 DZAby4pc
 1JJOXbNnyvut1pHaWPGqJK3tC01yJ7o3Q0IMi6moQHZVXkVC4hS+7lhrZ7tacpWNDBPLibAHz7ZXaJkBnJpzWLn08NuPXNfRSyGOPs4BoSWO8stxnZAsv7a7s/1MSVgBZHInH7nDoIOJfUMHW5AXDhsRLGP6oNkrwNFPMoBKdr3ydz3jKysnTYPD20pPdr2r26yXoah02i2O/qHxk2FEWU53ul4VZSyxsPWEbHDjRWZMphlwqLjj40Y6UZUMV6dRF7z3QmelxoYyQuEtCBrTJF8oN3paNEZfZOh5hczdS+nKhRTJ35SSwQ07W5wBpS2HcGMuoTb1G/r7eeW6pabcbGcqCcutoMYRlAWFlzObVM+MijN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2026 6:37 AM, Barry Song wrote:
> On Tue, Jul 28, 2026 at 4:34 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 7/24/2026 7:12 PM, Barry Song wrote:
>>> On Fri, Jul 24, 2026 at 10:43 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>>
>>>>
>>>> On 7/24/2026 8:18 AM, Andrew Morton wrote:
>>>>> On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote:
>>>>>
>>>>>> Fixes and one cleanup.
>>>>>>
>>>>>> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
>>>>>> sat after the "cannot reclaim anon" check, so when no anon was
>>>>>> reclaimable the request fell back to SCAN_FILE and evicted page cache
>>>>>> instead.
>>>>>>
>>>>>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
>>>>>> callers can no longer tell an invalid argument from a busy interface;
>>>>>> propagate the real error code, matching the memcg path.
>>>>>>
>>>>>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
>>>>>>
>>>>>> Patch 4 fixes the same "swappiness=max" issue for MGLRU.
>>>>>
>>>>> Thanks.  AI review might have found several pre-existing issues which
>>>>> might interest the maintainers.  Also a suggestion against your [4/4]:
>>>>>
>>>>>         https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
>>>>
>>>> Hi all, sashiko review:
>>>>
>>>>      This is a pre-existing issue, but I noticed that per-node proactive reclaim
>>>>      fails to reclaim memory if the node's unmapped file or slab pages are below
>>>>      minimum thresholds, completely ignoring anonymous memory.
>>>>      In mm/vmscan.c:__node_reclaim():
>>>>           if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>>>               node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
>>>> pgdat->min_slab_pages) {
>>>>      Does this condition incorrectly block proactive reclaim of anonymous memory
>>>>      by applying legacy zone-reclaim thresholds?
>>>>      It seems to bypass shrink_node() entirely if file/slab pages are low, even
>>>>      when sc->proactive is set, which could falsely return -EAGAIN to userspace
>>>>      for anon-heavy workloads.
>>>>
>>>> Should we add:
>>>>
>>>> if (sc->proactive ||
>>>>        node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>>>        node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
>>>
>>
>> Hi Barry, sorry for the late reply.
>>
>>> Nop.
>>> I assume reclaiming file cache and slab becomes problematic when their
>>> amounts are already very limited, so we should still honor these two
>>> checks.
>>>
>>> Maybe we could relax them only when swappiness == 201
>>> (SWAPPINESS_ANON_ONLY)?
>>>
>>> BTW, for global proactive reclaim, when setting swappiness to 201, does
>>> it prevent slab shrinking? If not, it seems problematic when
>>> node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <
>>> pgdat->min_slab_pages.
>>>
>>
>> in __node_reclaim, we will shrink the node when
>> node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages, even if
>> node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <= pgdat->min_slab_pages.
>> This means slab shrinking can still occur even when below the limit (since
>> shrink_slab is called unconditionally after shrink_lruvec). This is not an issue
>> only for global proactive reclaim.
>>
>>
>>> Your recent patchset prevents all file reclamation when swappiness is
>>> set to 201, so we only need to check whether there could be a slab issue
>>> before allowing shrink_node() to continue in this case.
>>>
>>
>> So can we add just like?
>>
>> if ((sc->proactive && node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
>> pgdat->min_slab_pages) ||
>>          node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>          node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
> 
> I feel both pgdat->min_unmapped_pages and
> pgdat->min_slab_pages are quite broken in mainline.
> 
> For example, even when the page cache is below
> min_unmapped_pages, it may still be reclaimed. Similarly, slab may
> still be reclaimed even when it is below min_slab_pages.
> 
> Also, when both the page cache and slab are below their respective
> thresholds, node_reclaim() may reclaim nothing even if we have
> plenty of anon folios available.
> 
>          if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
>              node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
>              pgdat->min_slab_pages)
>                  return 0;
> 
> For example, if slab > min_slab_pages but the page cache is below
> min_unmapped_pages, we still reclaim file pages, even though the
> comment says we should not.
> 
> So we are not going to introduce another broken mechanism.
> Maybe we should start by fixing the existing broken protection
> against reclaiming slab and page cache?
> 
For example, Maybe we can skip shrink_slab when node_page_state_pages(pgdat, 
NR_SLAB_RECLAIMABLE_B) <= pgdat->min_slab_pages?

And similarly, in get_scan_count, we could avoid reclaiming file page cache if 
node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages.

-- 
Best regards
Ridong


