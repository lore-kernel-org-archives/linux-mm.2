Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F95606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E7r9Du/H
Received: by kanga.kvack.org (Postfix)
	id C2E6C6B00EF; Thu, 29 Oct 2026 00:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE00C6B05B1; Thu, 29 Oct 2026 00:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF58C6B05B2; Thu, 29 Oct 2026 00:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 944F96B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:15:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D778C0246
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:15:46 +0000 (UTC)
X-FDA: 85374350292.09.68131E5
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CD56140002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:15:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E7r9Du/H";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793247344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5Iw6XNOv11IMqEOTa+b+9SQzWGBF50EMs427zf5Llk=;
	b=7TdKcWNbPuJ/vCvaWI1X0Ya59GS3h/ycS97Yh6cHxyMA9XZEBDSOiq5/vMXvbdLDXKWbWP
	fjc0R8BhssWwtU1gYgVbrCt8YT58IgPXPB9AH8d5edTn0R9quxTzIbDSGU7xX41lnwo1dX
	wFTR+uRCYcC1qZxQ5hLwFXVH2ogo9tQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E7r9Du/H";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793247344;
	b=qSfAtIuiMmsqvGNnNLZ1cqvQ+gcWfx7+WYVpXt6Pn+kmEs8GbkELnYFlXC5ARJusZg/d2U
	HlbhQWxk4VVKKP8tNVAG9Cc/d6XGJBA16X3WbRlDlVSxzSNxzjQ6h+vAbIq+pB7LX6iDUp
	9bBubALGpHhNTE7ER/EMJ8q7IHu5UfI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YEZp3sGN8gs48o4bStQAvC9Qt9Sv9D5jLzzzs1e263Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793247337; v=1; x=1793852137;
 b=E7r9Du/HofmzApl61zpJXYUqnn5MpnM03T6rVnFrcyBHY71X0Y9vsrSZvbEKgGaT0i2EaUJI
 Gk7pM8P9rwh6Zr2lqVRP2/q2783uSiMNoRJmxmSHT0IV6+hj0Rmw+eIPYSA8N7dHZl2qzn9j6in
 PzqACY6e1+6BXSvS33bz3048=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c6635af0f1e01899;
	Thu, 29 Oct 2026 04:15:33 +0000
X-Mizu-Trace-ID: c6635af0f1e01899
X-Migadu-Flow: FLOW_OUT
Message-ID: <3410e049-2e61-4ab1-b776-e77f3b97517f@linux.dev>
Date: Thu, 29 Oct 2026 12:15:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAKEwX=NfFNbBwhvNpYz8iWgimFuOow8J8x1SzV_6GcC_bb=Etg@mail.gmail.com>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <CAKEwX=NfFNbBwhvNpYz8iWgimFuOow8J8x1SzV_6GcC_bb=Etg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CD56140002
X-Stat-Signature: 94h8cex648x69cmo9d88ro3shtae7uk8
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793247342-742028
X-HE-Meta: U2FsdGVkX19y71gIZ7NLEYMLuNac71C7WHGXBs9qmXKdHwJK+tbmDoBZcKspp0Od4T7fpnKPd3GKBkpwJAGUM086ebmsqFBVR17oCPlxWdkVcWvDM9l3WLqm0tpH9pZeqkWozXZxdBEdzWOOsLOqsnTkVGgdQG437OclUoplmM69boFffZlQKCaBLzXIu2YAU5iyZwSsIhJyoy+f0GfzNRpec67OR6nCJJN9QZ7fck8CU+cMbBBAVU+kyBzKlJPoRMCMSOBGnoqMf6iFefXjCdkB0fGwUibzpK7gfe0P4lR9Nxf7jeAr0KVzZA+0Xnrmxk8Uw9z6FzC20mG+0LSZkYKzpPOvbJsJEszFsyQsRiDT2q8PSIwDti8OTjkUDTJU4Kg1gno5RYZf8WFDuJc4bSr80JLFFSBZ3b7d9gMPAvrGR9jw4E7O9lFNTrBa0Yhda/rsZ3GXAHGc/edNsoDpFbTcM91lcKvwyiUguKTi2zIexdpsMgvRS5908Cint/B9+Nrgr+Fn7PGlS3y0uXujrhT3vJg7bm0bh99ZEpZFSruqdwNwi1k3ADyxqGqxf4Mf7FS3NY337I5BnVVbw80UqQuPOv0B6NN7UduWZF37J197+jRHqb7WIsxnxpie/mg8cxzePdJb27d5PguIWfNtuVbmwceYGm3ebzJShuPfGmViNYMwWfbhkUvSukdo6L/3iD0s/6tizhGFfsMq65BEi1MSh1UqcmKEBqFkmAOfoAJU+q0ipAo30yiWjJyiAIj82pqLmUNZG1wfHw02nJZgeg64d3E4B6gfk9GYDBskmeliPped63z9vcO5zkaDpsJk30s+2+JoiWKS20lRtVzhHfeyressZgreWEsKrFsplkqRCBBN9+nS4/X7MqEdxSHHdHIcB7X39fPjMgkPJivrS01MU7aYsoM5oghAUTqcJFI4naHaNAVHvVgA0ngxrJ18dveL+aFzibyoWBwcFhR
 z7/Ncmyl
 rrdVkaqIJYjHsa4SmnnIpu8T1Ew/q+/Y/9XasEP79hRanq707yNiD5PKjA4Wj93jGepdZD93hXkxjiRZXZsBz7y4Rd4WU4VC+tSeGKGPVuaDZjlxjlpWAsKl0Ucfzth5hDjoa4gsmthSVnAV/dnIi9dOVCM8ehM7sHzQqr8rI6DzV8HxJM3ug9CaeBqM1JxhzCyo4Tbln52iKyNkrGCkjxu2Ke4psFuFQ707IRUjp11bxH5gWaTSq6Kc2w+8iz6VANoF/MzhcC1jkpdpXDUG+ZShg8NF+IkdcjpGzvriULa7Vzkhql3AR059K9w82+LKNl8YwF96FQZs+SVIhJ/gFKCLINIJ8YDfIabOymdqePHrC9sI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/29 02:47, Nhat Pham 写道:
> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> Successful writeback calls zswap_entry_free(), which removes the entry
>> from the LRU and decrements both the sublist and node item counts.
>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
>> to decrement the node count again.
>>
>> The affected call path before this change is:
>>
>>   __list_lru_walk_one()
>>     shrink_memcg_cb()
>>       zswap_writeback_entry()
>>         zswap_entry_free()
>>           zswap_lru_del()
>>             list_lru_del()
>>               __list_lru_del()
>>                 atomic_long_dec()  /* first node count decrement */
>>       return LRU_REMOVED_RETRY
>>     atomic_long_dec()              /* second node count decrement */
>>
>> Add zswap_lru_del_nocnt() to remove the entry and update only the sublist
>> count, leaving node accounting to the walker. Split data cleanup into
>> __zswap_entry_free() so writeback can free the entry without performing
>> another LRU deletion. Other free paths retain their existing accounting.
> 
> What is the visible effect? Is there any effect, be it in reclaim
> dynamics or userspace counters? Can you add it to the changelog?
> 
> I'm not against fixing it, but need to gauge the effect for
> prioritization, whether to cc stable etc. etc.
> 

This is only an accounting issue; I could not find any code in zswap that
reads lru->node[nid].nr_items.

>>
>> Fixes: 5878303c5353 ("mm/zswap: fix race between lru writeback and swapoff")
>> Link: https://sashiko.dev/#/bug/linux-68d2ca49-23be-4504-9a75-b8526ec92388
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

-- 
Thanks
Kaitao Cheng


