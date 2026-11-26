Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16170606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 03:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LSdyAs8J
Received: by kanga.kvack.org (Postfix)
	id EE8A86B05B0; Wed, 25 Nov 2026 22:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B536B05B1; Wed, 25 Nov 2026 22:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB606B05B2; Wed, 25 Nov 2026 22:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA9F6B05B0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:39:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEFAC120234
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:39:05 +0000 (UTC)
X-FDA: 85475864250.07.44A0A68
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8F4E180006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:39:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LSdyAs8J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795664344;
	b=T5MZC0U3WZBu/E7KTMusDMGmvweGUZEHntm/gPcWX9k6UPqiNOBfVu/xQ2VITBsqckzA67
	jrWw+X8sZ18sv7UMt2UF88RHXzx1yXUBdCnpptxPnUb875FW8BUURsGgiCad4uo1mWTguA
	EWOn7QWmVIvJvWA0dazEkGSz7F8fcww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795664344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZXhqqMJtGtQSFqs9mp5EiyQrG4t9fKkEiiJJfk1V94=;
	b=76lq3xuDytjpWcx9Ix78UJrCZSXaorPzlYbgIlA6wrJ+w/Pi4E28G+k8RAwZJM139UHfBd
	Hahw5z1W+5VyClwnPq1ZMPSav50YfZjutoZGJzuQ2thTMfMOnF3e/xaagL5k2ZhMFDzp/i
	BbWSpX7RtXPfdbOAUj8C/MJLk2qywBI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LSdyAs8J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3UV2O3vp01qJF08PlpVk7+NJu2+NXqvyVZ3Kr2qDcy8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795664342; v=1; x=1796269142;
 b=LSdyAs8J7bC0cwji/tGdQecq8Tb/rUDxBvCZ8eA2i2W2wcoPx32DxmBSqPsZUXpyVC/jASZp
 W5Q5gHCmigHcxUkWUsIUEaW4tZX8X/02c4qBdNrJInCsJGoAobC5G7g7oXcnSlYNUKq0omgJe+s
 93KKvNA1mcwtd7Dgk23bKn94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5700fc680564a234;
	Thu, 26 Nov 2026 03:39:02 +0000
X-Mizu-Trace-ID: 5700fc680564a234
X-Migadu-Flow: FLOW_OUT
Message-ID: <8685acd8-4546-4414-9b92-217048766321@linux.dev>
Date: Thu, 26 Nov 2026 11:38:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when
 reparenting local stats
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
 <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8F4E180006
X-Rspam-User:
X-Stat-Signature: ctybapfmrjncw4iez1fmjgxbadsmccse
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795664343-831047
X-HE-Meta: U2FsdGVkX1/XgXrVyr4C0EVRekC/k5GbL1NrVPNzQ1uBl7XIu0syQMPA+SliSHQtRv2mM053GBQ9o9p6V839X/WAGcGuIbz0VVq2BtqbiW5M5h3iB+WmNjxY1+m7oO78XF6r2Lqax/fo8PbY+ALKo0x0m1/65D/F+pKjQFfnoL+rg5zT/hog1y6uV/LIfhJqp6P16quki1DdWYCuIOcnCJzH5cIyRaet1bT5eJfr9Vrg5abEwqdARYwcWpKm2W9KhKDjd3DFFXRYWQrF/rtdm8+rfvMVcrW3QNdGjkZeC6mKuzAXQMO0vN4++uYT4W+QmtJuHk5Cg2X5NyiC5ikyfawckvMz1v9flX8AZAu33VifSkGDMrRQEFG4YFvZQtVOPdK5fhmRvwaOcwUaOHqDTQXrN9Oymzf6MseHsG2nFOcFPq0oMxNQR+4zYqMW3wwo4sYW4HFocBq+iJEjp7sGU3iNSjyyXUyWwepOkzmHxil+REUNxtI8DwXBa9olCprBbuvnRbKbrhpkihxcRp8iiDnBPMg/DwlKLpAiOLTgd4KzzkIMV9pew6c2oWomlBuTaR2QPXjwV95+X8KvI/rL/Medlqu7kQXN56stTRgi9J0HSGtGECUzeSOUHiCVrpOKE4yLtggwgdgfFFAzvGRmtQb7CV41/IvS4ObX5uAZi5OLUjUwsZEujqcqFd/CAa3ropv9euosbcoLocMu2qnav/Rp0cnAw3bpHHVuhhCbUEYJlCEi4WL3KgTNiDzBPPNzI2MJBn9cwFS9rWi4wwOudJWQI6l/ymtHD4IJMZ0UCkC0sQK3gwDzLVEufh/eY85T+l3uH89OE+wsbe8Xk8jq9OxBjURdxxKGTLO8UuWNg5i8A/oWNAEGD+INmc4pDMrsfcWzefFEDbhYUfVBailJUEw4etobdBEcvIepZIejBJZKsfrnOXeP4CLt6dvPC8DxEpMEyyR7brvnGNqXAeC
 88KcCL2Q
 pi2zv06883w1t0aHC34EteBlxMuWb4FYzb/TSHfE0u/Izpg0RZRhiG7RD3m8iArBKeIf6EWG6DuKsPExgivjuQaWDHAaBMahIuVY7/qZJfRhYZ3w8ZV9gIp442wQboTErLogEB08RixAcbAdu5ufEnffJD6TmIjan5sredxNRh8Tenfq1pBL4OP/FUT1CXP/UA8i1LkUyvs6vLS8MTuiXEoG6X3qDCrq0y1iZjjBOR0pIdS5sZSf0qTKM6e6PsmIz8937p8Q+zFSRCawbJGEpMsRgoCP6ICILnozlyWpBjo0uO8bi8BKkyEfMu1Emcubt1X0V0mrC4sU6Pwd+QUM2v+dRkB5CY8N3Jynw6wbps6p2QPVqdlyVXFTOvLE+CEk4R3SUc6Hz3Di7Q5fmRMgZxLjiv/D8NmQyTK9/0/HWyrREhj7hjaA9iEKAnX/IAhUocJvbtuB3I/e4TcAHIeXzL7LJOE7IVxWU7tgsJ4ZMNjdjsVJNtGCEepyiChRlgLblJc9ICshnS1rlkdxJWUD87/oWPlIIE0o3nBMNuzFm3iiHaQ1Y+KdBcrWe35t2balnH+QIl0Ll/aPHXh7MgSWxlLfL/6q+1DwhjCmfhJt/JO1nXdZkVZwHXyUDTsGOwG8Q0Iu+
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
> lruvec_page_state_local() clamps negative values to zero on SMP.  That
> is right for readers reporting page counts, but can be wrong for
> reparenting once MGLRU updates the counters without the lruvec lock.
> 
> Reparenting runs after the forced stats flush, so a negative is a real
> balance that has to move to the parent, not be discarded. We will
> introduce lockless MGLRU promotion which may cause following problem:
> 
>   1. A refs CAS on a folio on the child's lruvec moves it from
>      inactive to active, and its active/inactive counter update follows
>      as a separate step.
> 
>   2. A concurrent isolation of the folio reads the folio as active,
>      debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
>      to it.
> 
>   3. The child is killed, and the two __update_lru_size() calls from
>      step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
>      +delta.
> 
> The child is left with NR_ACTIVE_* -delta while the parent holds the
> matching +delta, and reparenting the child's raw value is what cancels
> the parent's credit.  However, if the child happens to hold few enough
> folios for that counter to be negative, lruvec_page_state_local() clamps
> the child's negative to zero, which drops the debit instead, so the
> parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
> total overcounted as well, permanently: the child's local counters are
> gone once reparenting is done.
> 
> So use a raw signed helper and reparent with that.  Ordinary readers
> still keep the clamp.
> 
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/memcontrol.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..3f551e2e3206 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>   	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>   }
>   
> -unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +static long __lruvec_page_state_local(const struct lruvec *lruvec,
>   				      enum node_stat_item idx)
>   {
>   	const struct mem_cgroup_per_node *pn;
> -	long x;
>   	int i;
>   
>   	if (mem_cgroup_disabled())
> @@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   		return 0;
>   
>   	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
> -	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
> +	return READ_ONCE(pn->lruvec_stats->state_local[i]);
> +}
> +
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +				      enum node_stat_item idx)
> +{
> +	long x = __lruvec_page_state_local(lruvec, idx);
> +
>   #ifdef CONFIG_SMP
>   	if (x < 0)
>   		x = 0;
> @@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>   
>   	for_each_node(nid) {
>   		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> -		unsigned long value = lruvec_page_state_local(lruvec, idx);
> +		/* Reparent the raw value: the clamp drops the child's debit. */
> +		long value = __lruvec_page_state_local(lruvec, idx);
>   
>   		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
>   		__mod_memcg_lruvec_state(parent, nid, idx, value);
> 

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


