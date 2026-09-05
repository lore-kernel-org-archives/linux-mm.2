Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF416C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29D66B008C; Sat,  5 Sep 2026 06:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01F16B0092; Sat,  5 Sep 2026 06:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19196B0095; Sat,  5 Sep 2026 06:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A54FE6B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:02:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44AD9C02DA
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:03 +0000 (UTC)
X-FDA: 85179267726.30.B198607
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01513A0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ER7TzV+b;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788602521;
	b=mnNd7awTlC4UYy16HicchNjyG09+KNr79gNGXwI9st4QgyUfcm69OTAhjvVa/wCY1R8ZC9
	8GuPNTNFF4jo/IdVkOpcfWF+GQHMhoYEmiJmiWo7hDHXqvc6aY3uCeW1dYqF3zHHJ4E1bW
	dIS1j7lrY3KZKvZJnKTEzs39//0XZSY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ER7TzV+b;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788602521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IG1pIC8/hO+7E7dXK1qYzwXUJLZTgWqJypppX8IF8U=;
	b=M/FOI5nNR40PxorqiZ4SH0IQs4TpeihnJMkH1sF903nO5md5VyVOkxKui6SM1tFzr/tSwC
	uMmmsTo30NY2u4FxtvLeUMEg70Eo6gBhJ5UARrE0M99cKc01O0uUD7FhUnia0IyCwYINX0
	BHAj/AgZA/5bUK+D5BPvWRo079xHzkc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ueDZ8PzmB2BcxpWqII3y7lg815/Y5Ff1RHaLqlhWFZw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788602519; v=1; x=1789207319;
 b=ER7TzV+bwlECkmT3+aEov2C09ncU2MvaVMnzd6Mh7+6580ZpRH3qYikC9R2ssc0rJalH/ek8
 flxTWSZcl0afyJBr4Byo/5Ode5Hb1PEwpjdS/0W2XB+O+6mQAZWfCgWgCe2WDrzcGKS4G/04ink
 Q+Unn1jOSL/45R0MtUFVZuGE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f97f8397945b4985;
	Sat, 05 Sep 2026 10:01:49 +0000
X-Mizu-Trace-ID: f97f8397945b4985
X-Migadu-Flow: FLOW_OUT
Message-ID: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
Date: Sat, 5 Sep 2026 18:01:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
To: bingfangguo@tencent.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zhcqsupbwd8xiiw4askrsku3bhhxgbrr
X-Rspamd-Queue-Id: 01513A0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788602520-693877
X-HE-Meta: U2FsdGVkX1+dWKYc5xEpK1J7SioB954eU0hM3j/b36IfZoIMGRwOlyWJVE0CHpqFaWvzkaWGokwu00gmalOsgQvymMmMlNf9nBhvHtuBYL7aznEq9OilcxIY/dHTxoMKk/TEpoG5k1AVrmwMoVv/xENQ/iiiJuqtn1my5iwayDEyyZiSwE95mCe62mbWXVn1f6g3KC4ODfwVe4t07edNMSpoHrTb/If8WTxcMRaPc5C+lIzjgfWazEL3gCUggkaErw4Ma1PD1Y0I6p2WT94Rv/WibcWL8XtmGz4ZB5FZWLZH9GGR/tV3mQ8El2+Eq+63hF+UuGX9sw0Vht+zuxmCgmrkqV7uQvuB4X155GH116eE8HMGLlsdgTF91gSfrfPdIoVn3tl+T9DHGRq3Tu/XsXZn9hm5bWgp+YO9NKeCP/xc9jlGBCRYIHxlgbfU4VHg6k6696VGVGfTmKz+BrZ12Wh3BFTwtiURYNQsHy6nyjCRz92iQQfuo12HEGeK+fTP0Kq5YFRxMw7dzuuZ1HeAgKMAN5xqEj5qBUkdRAlZ+cWUIunvWOSb6Cuv+jGt4gHGUY/gt7DHkMY7gTZbuBXTDspTn5B6YwaxsV3cA46KTG34FNa8slb7v9McVtJWr1XvAkNeofvh7aAwRuSx5b7Dm2aFtPwxeXrPYjS6yl9ZCLZEzprgc51bjzBHV3ZITlOZFtequ5z8gkOg8zidxta3q0SOF6vWUhFHJP81Lb6Z8NpZT9AF2I77ad3NeShCs2/L7P7JRSYVY+7QXBbyfwdyHrAkzXS2+9ClsoG9tX9Mcwwq+i6U12lLHPEI7ZXd+gisqsa2M4W33WwLJzfHsv+3VDV9xogprZqXioSHMynipe9AmFa8x/TfjT/7IPv92e73meVVUa29pW11Lmx2A2B9iFandRy8rPVQmPxVG2duzHqRhygncoqpXvN5CMCk2F5jIIgvla9J0LvHzeysgDn
 OBZVcYMf
 mqftLtVa9FZgl65WLHhnVz9XxtpdnZsYO3BW6wNFUZzJgdwN0djn+WORzgEPm/KPknSS9aZvinFdXY/tUhdTD6YMbVDtGtwACcd/Fgp3iHNeMsU4vlF7baACQcMxjOZgTpkyLTsu8hzN3x4UWuaC9+yNpWULMAadj5kLz1eUjk5WBTHihmL/QpvSGrzFH0hq56jiqNkngLXSe3ZHALKfpR/BHCj4xRqGh22CDHs6/tOVD0sczQ0QsyYUo1VS0SBi/0u5DV9AYR2u9GbVzaEEdI657Gnom9uoOc1kMuo9S13+c9+hWXtvLI9dMkLyDxtTNU3zsK4Iqb0ECI/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> Swap uncharge knows the memcg only by its private id, and the id can
> outlive the memcg it used to belong to after we rebind memcgid to
> objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
> memcg containing the refcount internally, and keep the underlying
> __mem_cgroup_private_id_put() for the offline path that still holds a
> memcg pointer.
>
> In the uncharge path, the memcg pointer will have to be read from the
> xarray twice, but we'll fix that later by returning the memcg from the
> put path, so the uncharge path can obtain a reference in the same step.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ecb4fb07d7735..048c9bb0fad79 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>   	}
>   }
>   
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
>   {
>   	if (refcount_sub_and_test(n, &memcg->id.ref)) {
>   		mem_cgroup_private_id_remove(memcg);
> @@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>   	}
>   }
>   
> +static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_private_id(id);
> +	__mem_cgroup_private_id_put(memcg, n);
> +	rcu_read_unlock();
> +}

To me, the direction of this change makes sense. At the same
time, I would also suggest applying a similar change to the get
function, for example: change mem_cgroup_private_id_get_online
to:

     unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
                                              unsigned int n);

Have it return a private ID. That way, I think the two interfaces
look much more symmetrical overall.

Based on this change, it should be easier to implement the
direction of my last suggestion in Patch 5.

Muchun,
Thanks.

> +
>   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>   {
> -	mem_cgroup_private_id_put(memcg, 1);
> +	__mem_cgroup_private_id_put(memcg, 1);
>   }
>   
>   struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   				page_counter_uncharge(&memcg->swap, nr_pages);
>   		}
>   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put(memcg, nr_pages);
> +		mem_cgroup_private_id_put(id, nr_pages);
>   	}
>   	rcu_read_unlock();
> +
>   }
>   
>   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>


