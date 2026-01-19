Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE71D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088B46B00F6; Sun, 18 Jan 2026 22:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FFA6B00F7; Sun, 18 Jan 2026 22:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8566B00F8; Sun, 18 Jan 2026 22:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB3556B00F6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:40:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D6A91605F4
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:40:06 +0000 (UTC)
X-FDA: 84347310012.06.4260B8A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97148C0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:40:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vb18RKe9;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768794004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUhhhWP2jSDUI41mEAYgwc1tmgkjJxYhACRaQUEM408=;
	b=sjNyGZG+mld98Qlmzcp2hjeeyC0oFCf+JuQ6PlfVEVzyCvq0B6TQJXruI6GNkqN3A1ahk8
	xrcOYt5/NKHR3IKv0udfOrSjWOkaTdlMstTg+UP9roDtDmnybpFV5eSXVX0ZZ0XyWMrOII
	JjkmLHs4HOVFwVxg52Cq1kApX+/aCA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768794004; a=rsa-sha256;
	cv=none;
	b=qwzUhAh3EiChtsiCsEICZuJjgh/lMTEssWWfzzMP4jWHBAPwuNOM8rwhjEdWYrV5jCmPpL
	Y8KF2HLqFd1742IcfwFDuaXvBgSpFNQIh8qqOhyhEKL8bS2Xf0Mc/Smdzow2hIWri9fgLu
	PJrbeGmHN06gwmiQuvd/bCtfGUJhdmA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vb18RKe9;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7cd937c3-148c-43ed-ac51-18d90cb9a5cc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768794002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UUhhhWP2jSDUI41mEAYgwc1tmgkjJxYhACRaQUEM408=;
	b=Vb18RKe9L/jlWkEUZ70IlnlFdjiOwcuHVpqI0uvYrIG4CC4RcGyYPsamjIXs65AM5726cL
	n8YSQrMKJEUEfheCvIftZjf3eCjXZj266U+GOK0MgZp43Ltkw1RROLEJ31qcJkUZSwHxbr
	I41DnLIyGS7t8xTuMVk7Tx1stkQmZ5w=
Date: Mon, 19 Jan 2026 11:39:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
 <mhxt3oheta2enk562jt25qdac2tkq6ulc3olxairfow6tb5qpl@n5dhssfcyhea>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <mhxt3oheta2enk562jt25qdac2tkq6ulc3olxairfow6tb5qpl@n5dhssfcyhea>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97148C0005
X-Rspam-User: 
X-Stat-Signature: d879cgyueuyzz4thfru63qgnwxuy9hzg
X-HE-Tag: 1768794004-157867
X-HE-Meta: U2FsdGVkX18iMPCFKGHriA131iiy+V11ZO6TEt6SL0ZIL4VzYG32kYEx5Gh8oJLwNmKHHuf5Yxm/94h8XaargyqFuMLp0DRL/KGySdZQpjpP97IATan1uYakMW2jWpSadzSHzve4lvGr2we6cnsCiVSe3ZmiOyriyxh0EymeRXPmulRU2hUJCYQcFTqWEAZW0dir8U35nids92fdScYgcCoWGuudh1uYcaFYgD2BDGHqFKhjr/p0mte1FCizxGUHWJfYgUT8qzUmklQ5UKEYGNZv9pcngE6k1AJpvJ3HtE9XLw3dODOwvV5juqkESsXHtX+MJTD3LQ5JKAQA6ReV20p421XxuaVjc6ov2mbHf3iHcTqTvxpPFn8jSe7T2Tq4VCdrb1UovJPHTChA2ZjOF2JLW/Q+sBKpnBEKJr/FvMyj/pZw5tf+P0eJfQMmPikQ3LTGU0W6mn8TMot3ZwLsOFKah1URaYzamU05tHzDZOr8tQzpDuAyW6KT16r1jDaNAuQZTPlGqDuBnmkR17wQ7o8B6GQwpQjYHQdK0TY8Pgwt3ZejkFIiOIHMYq7QqW3MY8g9BbLabRAF+QpDyNzAGh7HclPzdxg9vafyKA+9AQuoufqGYzuK/+ebkdbFsXPo7evBIj+DrHMYQG7HQJz9sgfSPlzZItu6/2Nafr+vMSevwz8njyJpFwCu0qVOE4ETztwzUK4ECdj/a0yoFaFR3J1O8WLn9MwRtW+5rkQYCqXJI+GGN2fT1xhr1AG3jnkY557bA+ilBl/ZypkRmhbeg4UUhh1Dq9wAuxxUFLiisFSw+blkaW7+pdmJczHQA/EQx2FTER9R921vO1Q/Ts+gmpXDUoNireF0LfmelRFMufo18KuHiRWhlH1p1RUBBEuyZJsAsM5uCe8YP6vedmYjzx8vZEVs5v8vUYeZOnOD+huOhpSNC9H+JIoyJw4cLKqmriQJNGqjx+lpubMKOEu
 A9nyb7L7
 xVnJwbO0N1X4iv2CDl5C6tHli6wQpL9YfVNqYGIHmOnOuI+P6mkJ2FpX63JjGqqj6y6I0FxcXBoM/DRqG/7D5RTurdb8B4tsigFFyD7Dx4RvaZ70xJ0h6pa0ItkMLBE5oxhfCano0RV9JpbRgDaGD3g/h8enp12mYyjgh37iwipSxZurhhaRsyPUy+JB3QqMwOKDtKu/tH+s1qZFMldh3itMY48zs8/wupxXozCeYe5zz6tY/e7BWmoC+XBKa8cBGhB5s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 11:29 AM, Shakeel Butt wrote:
> I asked AI to review this patch and it find following potential issues:

Thanks.

> 
> Author: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> mm: vmscan: prepare for reparenting MGLRU folios
> 
> This commit adds infrastructure for reparenting MGLRU folios from dying
> memcg to parent memcg, including functions to ensure parent has MAX_NR_GENS
> generations before reparenting.
> 
> Link: https://lkml.kernel.org/r/92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com
> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f1a45c94c2fc..284292653d14 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
> 
> [ ... ]
> 
>> +static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
>> +				      struct lruvec *lruvec)
>> +{
>> +	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
>> +	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
>> +	int swappiness = mem_cgroup_swappiness(memcg);
>> +	DEFINE_MAX_SEQ(lruvec);
>> +	bool success = false;
>> +
>> +	/*
>> +	 * We are not iterating the mm_list here, updating mm_state->seq is just
>> +	 * to make mm walkers work properly.
>> +	 */
>> +	if (mm_state) {
>> +		spin_lock(&mm_list->lock);
>> +		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
>> +		if (max_seq > mm_state->seq) {
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> When mm_state->seq equals max_seq (which can happen when mm walkers have
> completed their iteration), this condition is false, success remains false,
> and inc_max_seq() is never called.

I expect that once mm walkers complete their iterations, the number of
generations will have increased, so it won't cause an infinite loop.

> 
> The caller max_lru_gen_memcg() loops with:
> 
>      while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
>          try_to_inc_max_seq_nowalk(memcg, lruvec);
>          cond_resched();
>      }
> 
> If try_to_inc_max_seq_nowalk() fails to increment max_seq, get_nr_gens()
> returns the same value, and the while loop continues indefinitely.
> 
> Can this cause an infinite loop during memcg offline when mm_state->seq has
> caught up to max_seq?
> 
> Suggested fix: Remove the success variable and always call inc_max_seq().
> The mm_state->seq update is only for coordination with mm walkers - it should
> not gate whether we increment the generation. inc_max_seq() has its own
> staleness check (seq < READ_ONCE(lrugen->max_seq)) so calling it unconditionally
> is safe:
> 
>      if (mm_state) {
>          spin_lock(&mm_list->lock);
>          VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
>          if (max_seq > mm_state->seq)
>              WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>          spin_unlock(&mm_list->lock);
>      }
> 
>      inc_max_seq(lruvec, max_seq, swappiness);
> 
>> +			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>> +			success = true;
>> +		}
>> +		spin_unlock(&mm_list->lock);
>> +	} else {
>> +		success = true;
>> +	}
>> +
>> +	if (success)
>> +		inc_max_seq(lruvec, max_seq, swappiness);
>> +}
> 
> [ ... ]
> 
>> +static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
>> +				     int zone, int type)
>> +{
>> +	struct lru_gen_folio *child_lrugen, *parent_lrugen;
>> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
>> +	int i;
> 
> [ ... ]
> 
>> +		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
>> +		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
>> +			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
>> +
>> +		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This update_lru_size() call updates both __update_lru_size() counters and
> mem_cgroup_update_lru_size(). However, lru_gen_reparent_memcg() also calls
> mem_cgroup_update_lru_size() for LRU_UNEVICTABLE. The combination appears
> to cause incorrect accounting.
> 
> Note: This issue was fixed in later commit ("mm: mglru: do not call
> update_lru_size() during reparenting").

Right.

> 
>> +	}
>> +}
> 


