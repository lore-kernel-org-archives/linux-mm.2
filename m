Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D13606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nbVhAchV
Received: by kanga.kvack.org (Postfix)
	id 4451E6B05B2; Thu, 26 Nov 2026 04:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F57C6B05B3; Thu, 26 Nov 2026 04:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4AA6B05B4; Thu, 26 Nov 2026 04:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E47CB6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:43:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A9A516034E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:43:35 +0000 (UTC)
X-FDA: 85476782790.26.C75DBED
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2B39240004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:43:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbVhAchV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686213;
	b=j6Si40Lou6QUd2v1mDj3mIhqz29Ge0sFtvv7Ov5eU4l/hBPKpNVsjCyBqf5yfTZX/9wDF6
	uRw3TfVXZYFlVpb69mjkQgnDB1kmLcqiU5GU1dhS8m0W7g+Q7QgeJt7lzQM1kcjloTblsk
	au4Pq6jMoDdOlqB7O/6P2YiCtiBBnoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45243M13KOvb9KniU4MCiqJ1WOWt7TIcLK3eH++OB0U=;
	b=YzZf/Th4j22WDLp3riQXu7kSxCq3ogYCAhTA6Q62DFXslZ+TJ9Lbh9EBywqksTOySokTHl
	OP2dtYCW8EYgVAcF5LgRHuO3MkEl5CMS4JxUUWFdyJijVOn+ysTmon5dBZL63ozhr72oPB
	M325RwZBcvAW+f5Yc9LeWy7JmkWqzuU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbVhAchV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D32CMv1v+3bZYh/n5UdiiqLQfDC+3bfpicw46CnpCFQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795686210; v=1; x=1796291010;
 b=nbVhAchVucldszUIDs3Fxw8OH3B1265gjHbv4PRnkuMQ5IVnWDaaVoAoZnFpaDbFZjUOeNLv
 S4sLw8AH/h2ZQIG57bcTgDWKx+Dzb1sMDisUUx0joqD13lMretLAZ/iNJDjVZzPpevgvCdz/DbI
 AQptCLp9n3ZCVvFQt/8xl0Vc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5d6fe757d0ca69c4;
	Thu, 26 Nov 2026 09:43:30 +0000
X-Mizu-Trace-ID: 5d6fe757d0ca69c4
X-Migadu-Flow: FLOW_OUT
Message-ID: <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>
Date: Thu, 26 Nov 2026 17:43:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B39240004
X-Stat-Signature: f5tkjusnhpnibybgq1y9b8sb4uuw8g57
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795686212-732083
X-HE-Meta: U2FsdGVkX1+kwwz8nOVYeuu/ltFReYMOXkk+5/rxfpAWCuIGrZQIl6sl+jLREz8AYLFhz+oHIL4crHE75nUcGgSnM5/6vdEu5I9yZlRYQgHeYPf34ek8HnjxRzHhPNolHjiEY8czlJKI+EGr60T5gZztU9dRpyDJMGOHYNola6FVriM6ffmBopNYB2Euxxc8013Mk1hOKYJIzABHmEdJqTzzUckAwU5cqorgswEzVUdxuvOyHE58lP4ucLMUfXlonJJZVCrkt4SexhyLXK7LMwMS7Ay/ef1dfMA3qsXicVBMRWJH8R6I2KuWIN2YArxG0LxY6QOlmrlAUxjjVNHwpdXrNPMSyPRc7jOQ1Amv4n61fRxrj3htJBg2cz8gr0fqstDvutwLMeZ95inTkDNULBKd2gvb+gvRprjUYGkZPLpHLgUbUlOJrzCvRvX15vx4q1nO7nyxiYL5gvtbQTeeAgTqH2mm8nSIl6ip8SxLMUHaD21V3PFqVTVn0NpmwyV7XtFSuTJHZdTEieCe8F74+UoBeALVsOcYQ6b4eG1mNWcue6IhIVH84wPbphnXiAM8KQskBnEjaa3vuRucIxwJRUDj78cMMRf6NW+HUi5L/NyCZszZbZYjueV/eOL4Sr4rzf42iR6PYr+4vuM5EDefUZrcyWYCJ5qI/34tNhf99aa5h7oABaMfzVcWL1uu8vur2U4FP+GWv3cdn0BqC9PNjSyF3WTDw2bT8DbvHoh8zwerKuMrI6VPYczQ6FIMiscWfB8NpV1LjY9Jjo7TiTUx2iLymBsZGL4txs0B3jbWhkpcLtrtRMoM5ypIzUPn8ufbhIklzLT0EfitX3u4B9GXPLHt0ZZPBDa1V/pbfFSOIn5xH2tsDyh3gzEKadCpGK5td5zDAYHYiFLhYSiQ3ULFUPtLixdornTUfq5+e8Krvr/GNXOykipWvJ/t5zwSP/Kt8TxQeF3AHRqvSbB6LpO
 5HuwzP+e
 e3tU998pBgWOFI1A//gR7eWWmuzFdR0tGTdTZ8WTmeMLtMtE7h541Hdo7BVfg6SdEgGoOBJxGnrp+CLfitN3KW15Pz8BW2SFA8gTHQ1G/NNAkT6NsF3xey2pkCApuyruaWQzl79DC/z9e6kSFL+SFiawPV8JVaNmmcJVpak+QgVy+GUEQdWtV78nbIRRT9Xuc1+u8ec+ZDgF+tIU8Q6DlLzlOGCJoSWOA0Bf8nTdljNXReLxVEuI3y0oU6x/pVx5Kp2K4XmC2X2CqPXg8JJe1Fb81UvP3Wa9RiIWLwVQli0NaD8YdCYbMCOlGLIPFTWJ0v227Cn1F3hYVkXX9Fy1vxZVO/gLUH2izlnGvwC5OFV90ym1L4B//IYSMUzVHkPa0W14s/B0+96CQAu0QTOPU2Tjg6oLWismBHNKzkQnRaVM/09VaUPQwvyV9Qh3TWf2salCfr6y+Zjc5Vf66HzpbdH96zE0J+GCI+MqB7zLHANiB9ECCAbx3RF0rgyhkn6UrTlN0IeEohJFzlfuVECy0RS4V0ZORYTvTIT3Yf/NB57QIJSspB+7BWb9rXhZrodEOg2L9+cfxVjP94Wsc0LFKBj/jwBqs81ox9Ru7prBeH0LjRn3c86DQmPnwbCJVtsdAEp7fTV4WZGfXVJwexCjBPJuijoLdBmOdONZMCdRZeBvDa2FH7g1ZRHEr5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	lockdep_assert_held(&lruvec->lru_lock);
>   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
>   
>   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -	__mod_zone_page_state(&pgdat->node_zones[zid],
> -				NR_ZONE_LRU_BASE + lru, nr_pages);
> +	mod_zone_page_state(&pgdat->node_zones[zid],
> +			    NR_ZONE_LRU_BASE + lru, nr_pages);
>   }
>   
>   static __always_inline void update_lru_size(struct lruvec *lruvec,
> 

Hi Kairui,

Just a heads-up: this may conflict with Joanne's "mm: move LRU size stat
updates out of lru_lock in folio batches" [1], which is in linux-next now.

That patch makes __update_lru_size() add to a batch attached to the
lruvec by the lru_lock holder, and relies on lockdep_assert_held() there.
Once this patch lets folio_inc_lru_refs()/folio_reset_lru_refs() call it
without the lock, they could write into another CPU's on-stack batch.
So the lockless paths probably need to bypass the batch.

[1] https://lore.kernel.org/20261029204157.117879-1-joannelkoong@gmail.com

-- 
Best regards
Ridong


