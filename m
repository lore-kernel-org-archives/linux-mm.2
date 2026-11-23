Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F390606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iBLogXYw
Received: by kanga.kvack.org (Postfix)
	id 4E4686B05B2; Mon, 23 Nov 2026 07:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC216B05B3; Mon, 23 Nov 2026 07:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2EF6B05B4; Mon, 23 Nov 2026 07:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19B0E6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:24:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D9B8C031C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:24:18 +0000 (UTC)
X-FDA: 85466301396.18.90BB0DB
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16124180009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:24:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iBLogXYw;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795436656;
	b=bCDzyTHklq6u4b4IT/v6EO9Yn0Dgat1lGgad2EqX93N5jrLxn0e1b3uVfzsNeKYqCP2J0r
	psx15Q0qcqes0HgERPKPu51kOnQJ8JI00lfzgMLmp3CY95gcfgZS7t/p1FjUrMrU7/GHtY
	1QoRWIxNFcKY1c5NWzdQEOQXLEW8H9c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795436656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2y8a/aJsfWDdsgIUvnM1WLiUvisiUU/U1gufkqx14Q=;
	b=F8uQLJwJvuDJIjSnMcEAGsQVf9YQgkstwDhrdLbBKqZrVc7IoFxhESPo3sDMp30aULuiGX
	zvEilXNcRtrKhGJA74jghMgDcWGdZbUz4RM55uuzQj2PWdedxd7hjqHOVwTNNWcUU4nc6s
	mvQzi2ib8bAc+WRdjKrJV/K7pZoo4Wk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iBLogXYw;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ckKSZhwUn7LT+lpCjWursw7EjXIKhQt9XVV2CuTg7pQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436654; v=1; x=1796041454;
 b=iBLogXYweSyIf7ypQdnNycaGhQkgtwLwNEhirezZkoJD2DDj8FBIWjc4SCMhjXQqf/iMhgWT
 kCgkOtMBsLdRO8AiXqmuZffu4GjR/QZiehGNXgTlkybdY3H6LqI4OeqpB8X7rAAgWmkBExs0AUu
 56zBGNpGcBEC9RdhtCwWsupw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9061a3063b574a26;
	Mon, 23 Nov 2026 12:24:13 +0000
X-Mizu-Trace-ID: 9061a3063b574a26
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 2/4] mm: list_lru: keep per-memcg lists with nokmem for
 NONSLAB-backed lrus
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:23:54 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4AA82151-066C-48E4-BFD2-99F03F043BC9@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Queue-Id: 16124180009
X-Stat-Signature: ejd3wb6qagunjqao4obotz8hcpqdkcne
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795436655-137450
X-HE-Meta: U2FsdGVkX18eAuEPVIvjENrxMkXW4W65VvytYU0dIyEWqtNZlqHD4KXaW2T9kj4FxeIKthUSTxIRBMOwgynj0gyVFzpkzTQPdnBnKvHGZfI5lQ3gBAiS5UY97hT8Ps+tz78A1aw+/OaplmZo3H4GoNR1Ys84yTvdMg08PNK1FZanKcpvBfMjtJOTzAsQ2YJBDbWqMH4s8myProZuc51USZpAe9X+eV78b1Te/kEK9UUS96ZZz4YG0rHyKMBGVat0LR3Kj6U0XUovdZjj7rZqtk7AvWqmuUPj9vYSC2QurxvqzM59hLqEjX81CnANpRenV8eQWFje3t/tonkEe8t6/NndMUpxmA02YMTeRZgsr7a1K7UqzCFz9i2tT9AhvN+osAX1fQGuX/13RXjU4Yk26u02Gk+AMIcztAcWwNEohuNqjvYRthMvrBUWLUJtOZGOsN6XHEsjBt1C4aYZZeWoib04g3s9w1ry+ke5w9Z0FvnyqyPVr3z5dgNaiHbll6D+aEivV68koCLMPjh01ctO0V6PTAZSKp3ikHZQV+hH6aDmF6sdrOGdbtnBPcE62x5G0uixpXyPpx4SZ7upDfJ+OMTOkfEeKw9nR1H9A9DEZSoSuMMBhtAgz8BSPLrkLBDoJpCuhv5BYkMB3kiuCIKMi4Tkozq8213J4x7H6gfieX0tR5swUWw+aVBpILIuLmC6mDwgHKJ48Z3QWfalMwvUSgfO3fd2/E/ZN+hTr8Z+ZrIL68YoGG5HugbeYDoEFQM3WDCGCDS4/5ruFcw8ruvwBvi8vaKWyxOSKDhaUd3mNcm9CFDYGf+ey/0pGMrGuue2cN7Gl+MsA/2/gynV/HAJDaaLrnPLUfzPjLmL4d78ACnWWtFPxvofhkK5d7NhrtMa/3eoDAiwRQzb93KORPxvIxY27c9JJ4u0tla44P09OigweniuSu5SOkDEVd6XSTqJRETy0twZ/OAtEo4oK/T
 lFRnstBN
 jRvP8HnpwtvCPuiBJG+TA4chCQVot5cPTKyuBSW2UtMLgkInEXv24KVbdF+3hK+ejKYD0N2U+aUGjB3o9grNOdt7HCFGWt7ahmUmCtE5hNsO697EYI8ZtQF2rJ4363SSQ3QtLloBP6N2KqqWucshub8cgJktx/NVjsUFHfBlMs9L9urxI4AunrpxkWW5OsQHK5o3D5kh533Rx5vlxubsVE3sf5nC2AtDxXfCQeh/e4/XD4+mY6gav6pMHVtdsicGfxycTOtHL/IgW3n9ujuTFgtWj81GGViOktfhsYyi9ygT1EMlKGrYRHSjqlZZPUl5w6gCk8kAb5LSJIrWwcqUSdp3BsCfwbh858RyGydrPPLa3RH0EYg4s8sBY8Vh6kfEbb9YKkeWttbhpoK+fg0bqp96Xge2p70IUMRz5za/qTkojIKTSjdJnj3Aq+7XjeFrbgOXDdFvuxmGcu/Qrnv0mXmdX5Y6JRE5ua/R+cHeVdvKd8Ad67+mC5gImfZBtH0HONP4usd4zwP+q7Ywa8jDZ3Nr5YvZhcIXcrRadRY+48ahHhmnYaCc3sXuAU2qsB0rkxQkwfx6rJadsnWvVmuj4C/VohWAU6pxW3ULc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
> into per-node lists.  That is fine for slab objects, which are not
> charged per memcg without kmem accounting.  But a lru backed by a
> SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
> zswap entries, holds user memory, which is charged regardless of
> nokmem.  Collapsing such an lru loses the per-memcg view of its
> objects.  Reclaim can no longer target just the cgroup under pressure.
> 
> Keep such lrus memcg aware under nokmem when their backing shrinker is
> registered SHRINKER_NONSLAB.
> 
> This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to the per-node lists,
> and the per-memcg lists are allocated only when a memcg actually holds
> such objects.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



