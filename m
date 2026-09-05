Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04826C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 07:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8EE6B008A; Sat,  5 Sep 2026 03:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1276B0092; Sat,  5 Sep 2026 03:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DB06B0095; Sat,  5 Sep 2026 03:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBA4A6B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:12:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFF37802BE
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:12:30 +0000 (UTC)
X-FDA: 85178840460.29.E37569E
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf03.hostedemail.com (Postfix) with ESMTP id 68E8720003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:12:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tAZU/ufA";
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788592348;
	b=ACF+3WedEjJm6Zd5llP1jU61Y2hxlbz0XU0VVhp3MvaG4JrS589TosK/jaLhTZn5KsLv0K
	0M71rMk84J2o2dl5S0es0JeT6kwrQPqX0Lo5k7FzzUPCB56Gtx/W3RZ66RPA25x9uTZc3M
	BFEZfQ1s2W4IK/KoXBx3VIqaq7rURzc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tAZU/ufA";
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788592348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ylatCMgTzLKdjjjJEDVHuOD252cUDlG0gVVqPxIQPw=;
	b=RVS4gJEo16U6swxcthDP+gmsNeXcFDG6GFUz4drNiZjQOmQOha6/8eScRlrT7szG5b20hJ
	uLOw+CSiopi0ONrM+uPssJhaDxHDSGulytIVQU2j5CMan62+Gph+uGKNY27I8MKzIvI+yj
	h8+3Iqn+hQaHBO7KZcf5o+Dv6UnRhaM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NDEQnPZ0MaLk8wFMT+/bNULPhdcxRN/4BxqEM/TV/So=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788592346; v=1; x=1789197146;
 b=tAZU/ufAEEpRfnTicQ+t3GppjgsIbdu+OOXQ0z3fFbtBGLW3h7xZVrVKaFe2KgnAE04Nrroc
 yeip7kA9uI0EwVV003A0bY0zQwAeFbmRLRKBlOOhHbMXIL4kEFU442D1acLfFZBrZFWoQSaUVc5
 ti5iv/7J6BT89RhwR7f1riic=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 78ea68531be7ce2e;
	Sat, 05 Sep 2026 07:12:26 +0000
X-Mizu-Trace-ID: 78ea68531be7ce2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
Date: Sat, 5 Sep 2026 15:12:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after
 swap charging success
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
 <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68E8720003
X-Stat-Signature: wzyduikw7o7gpx4ao4irua1qwocdzox7
X-Rspam-User: 
X-HE-Tag: 1788592348-584989
X-HE-Meta: U2FsdGVkX1+2CyulR4+Mg4fgWjSWIThFHuDTPzx+aceOld4KqSjSs4l6y4hEi756ThJEOz3GgvVrllOmhddD5PjVIyotrUHtLEfN/0EVwuAm42UcS8IgdRwJGutdoLu51aOj5A5aZxw5uIzuk/bEMfwkkU+2CNIVktlUptUxZv33JXAAZde+90Q4jEaY7ENObvLd9dgLQSb+cPw6/dd4OfVKDjQSO95tNzkg5Zop1yByBopA0SfQEo/y/LRluINU9oRurRPBd3chED5xmemqOZtARJ5Pgi/thb2KwOVtRPswx8oWqSwVybxARMJlwl8TXQ25iA1UVi0Kfwrl4HUyEn9dhJ7Hphpmz+9/furUfIp3RdOhNImu436ei5xLj8HHQpKoulwDMe0+LIP1+TUvMhPj1ZMZ5dThqBm+5NEDlnDYUEvHer2hMcR1sSBqbwndr3xyKOF8INvuryalzXiKaFX6emFkUTps0knev9SSxJepHsPRTKlHwxCvPyGxiFnp5X+R+mIzx1vm9cQ/1q0IATzdOyQsEihfRARKfwXztiPPxq4zETeVUtHJzYH0csexf3d0HqPnJJl6tHRriK9BaEhUEETJSZ0PhRyI+4/G/OzXQeAaCKtypSy9qjnWM10z/MKbl8mHhuQrelMXX61+f5w0ZFldGK15IrBDVkWsTzmcJfefhO79lygsot19ZuwF3QHtRk6wvV4DJ5n9OCQSxgvOg7Pc3CqOo3B4E667s7LDPZCNz7IlVxjRbNFVQsQ5IekKGFUgc+AvnpECJCAAizKhVsMyos4cKCjjWGCchkCM7MHNbnd3Our//aAwkju5R2K+XfeMpRPciedCejgVAzu0jBMDgZbwXOmynOdJQLVjXaV3helwl7maoiNq/C02uXEMjjaEIArJ0WcbY5zGOrlFESC11B/0nKb4L2M63vyINhe4D/M6DpZUWm1lbZQpK7s94Pn2w9fUDSFIXVq
 aHs9N/Xa
 8fw2AjuF6OZUjGitrrKt67lUF8yQRTycXg05EUn0vtY1oHrbMlCvI9aQjTrN+LaPKD7q7Rnp0GPDpEYtg16xPjSXzeMqfBmpICm+b2aDAyrrNqwiFRpsqMhARpbA/5EPWqfsfWhk76yzmsgVFqaVYFC3Fu3cj7Xm588NeVOM7/j1H6/y6mNSUB4zVBs9G4b0TVpdnxT0ydUaLFuSclW8FIyUTY00qScb3or2bY4HfWFKQjRUBqHImhH7rSDRJ8jR7C986RyBdBgVbNeXkL8XhOTfsyakvG+Vzha+YvjUhPi9M0Ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> __mem_cgroup_try_charge_swap() pinned the memcg private id before the
> swap counter was charged and had to undo the pin on the failure path.
> Hold RCU lock for an extended period (which should be fine,
> __memcg1_swapout() does this as well) so concurrent memcg release can
> be avoided, and take the id reference to its online parent only after
> charging has succeeded.
>
> The failure path is now a plain return, and the id is only pinned for
> entries that actually end up charged to swap.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 31cec9dde55f0..ecb4fb07d7735 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>   	struct page_counter *counter;
>   	struct mem_cgroup *memcg;
>   	struct obj_cgroup *objcg;
> +	unsigned short memcgid;
>   
>   	if (do_memsw_account())
>   		return 0;
> @@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>   		return 0;
>   	}
>   
> -	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> -	/* memcg is pined by memcg ID. */
> -	rcu_read_unlock();
> +	while (memcg_is_dying(memcg))
> +		memcg = parent_mem_cgroup(memcg);

Since we've already chosen to expand the scope of RCU holding, it
seems we don't need to check whether the memcg is in a dying state
here. The upcoming stats updates aren't really tied to whether the
memcg is dying anyway, right? Why don't we just simplify the code?

Muchun,
Thanks.
>   
>   	if (!mem_cgroup_is_root(memcg) &&
>   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>   		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> -		mem_cgroup_private_id_put(memcg, nr_pages);
> +		rcu_read_unlock();
>   		return -ENOMEM;
>   	}
>   	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>   
> +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> +	memcgid = mem_cgroup_private_id(memcg);
> +	rcu_read_unlock();
> +
>   	ci = swap_cluster_get_and_lock(folio);
> -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> -			  mem_cgroup_private_id(memcg));
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
>   	swap_cluster_unlock(ci);
>   
>   	return 0;
>


