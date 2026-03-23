Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B0DD58CC1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 02:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F356B0005; Sun, 22 Mar 2026 22:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0506B0088; Sun, 22 Mar 2026 22:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5CC6B0089; Sun, 22 Mar 2026 22:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5726B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:12:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23D261E9B1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:12:19 +0000 (UTC)
X-FDA: 84575703198.13.2207581
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9082380005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:12:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jX4e9TlB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774231937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fP+Lbq2mzGcFGL6RZjQPbF6+oL36HH3daBGTHIiwlI=;
	b=SiBdUNrpzFTyXGH50lDfGI9RqjaL0RwY+6Xlo2NLKQSkU5mCnlImHZGqUi+uqdkAVz3p67
	rewoY/G57RQEFdsZ8rhgTrXjcb2QZmcIyX6adaIDPTBThoa84xmQz/r/TymHYZTTK8BTOc
	K73CdMmHPTFGgODjb+cTsQvLtdAaFSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774231937; a=rsa-sha256;
	cv=none;
	b=yj7eBJYgDGQVuKMFtoNRcgg0+d7pGcVy+byJz42qFm/5/rXv1s4ZVyxUieg3MP7qhNhjtn
	sBs/fK8WhimVabJ93LJ1+YJZPaDHFzUD7zil530YuKfOuzWPf1o6j/aYJjc47wJg3VmDBE
	pJgoI5oi9alx/aDMKyCuQYx4FOq/hHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jX4e9TlB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <db5ac1d4-9d07-4fdf-8127-b4e5d1a5df1c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774231935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7fP+Lbq2mzGcFGL6RZjQPbF6+oL36HH3daBGTHIiwlI=;
	b=jX4e9TlBHFivYzXhtQeiqJ6WURnOVA+1u2ohki/UxH3ZMJZExRqRLN7BhPgdnOj+C6BT/k
	rbOjjISEO7C59LHl6ktsv8kcVUnD7UIFppBch1S9/3lMJLOy2IYQxtwm69ofZwBWb3YhXo
	69b5Z0tKw4I/ydVGFd5TRGn9JMhv4iM=
Date: Mon, 23 Mar 2026 10:12:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in
 mem_cgroup_css_online() error path
To: David Carlier <devnexen@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20260322080142.5834-1-devnexen@gmail.com>
 <20260322193631.45457-1-devnexen@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260322193631.45457-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9082380005
X-Stat-Signature: 5ypjfj9szcyoik5urwkbu7mhy1dx6tec
X-Rspam-User: 
X-HE-Tag: 1774231937-511531
X-HE-Meta: U2FsdGVkX1/Z71fOoqeXGig4ssJocqGsImJgjA1cL3RB2Pn87c/VON5xg1OzYFQCipaDZA9HZcH74lZG/Gf4w58v/4dC+oePJmYw516sk3LKrKi7Sj9cRWufN5LO5MphHW7WQ6c00InZ/Koj/gDv0XG3hwTlHipE2l6usFBIcfRgFQ9dlkVYdEOv3zdn6ZoF3/24g9uq9xBds6dr3C4/1IKsblWxbNk9aPDvBV8jiowts2ZOJgyBYbeR5AtpUcmrtn3peymtbmqlZJ97oqpVDMIzlQl45tVwLnINO0wlPj4KbGnRfIMlwQSBAaSN4idKH2R5VNxKeseoxeSfQih/ZtZ1b3YKEUohfZhWWo5a8gE1eUjafIAI09HKZ6eON2zpzMe9dvgzTbRDg+8ib1Z2jxq6925XFFCNycaECVfBTp0vrhh//dYuHmf8q/l+EYbHuvjtJdSjSWPfqcqMGGJPPrpNYAk6oJ03c2tFQLx+JmgCGnILMNgprZFx+3vyra7Ca+SDnTcb1M67TyDvkpizesrnMuBZwRLWUG8NeE548vvaZVwCiUM43l4ugSMbOjhToEfebDuf/ddSkdODux+TOHy15ECXghWdL9erXEwyp2E5abM3k/HvTQbAjNq/3rYkeZfezjs6PxipfRc8aHnxIX6dNQ4Fi33kP8F5EWybf0rJ/48oFV9pzkOqAiENP9mUV97o3DEng6e8poOjCRs3uNRyYiN7cmtq6ycaaTc0TZlI53HvoCdqnHNHQykJ96i06DZAMuj3aYIut8swD8Vxx31hn85iTS4u1a+2fu8hZT5ibSzRI/MeoYGjOI5uR+eZ8rA9UFGXBxipyedHoryutmLXbII6cVajXlCM1Tbx/IMPYi87GkagF39jkdQlTPeGvC0fVD/pq/NkBoZx5CE7ecYtf1uNI9/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 3:36 AM, David Carlier wrote:
> When obj_cgroup_alloc() fails partway through the NUMA node loop in
> mem_cgroup_css_online(), the free_objcg error path drops the extra
> reference held by pn->orig_objcg but never kills the initial percpu_ref
> from obj_cgroup_alloc() stored in pn->objcg.
> 
> Since css_offline is never called when css_online fails,
> memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> normally drops this initial reference never executes. The obj_cgroup and
> its per-cpu ref allocations are leaked.
> 
> Clear pn->objcg via rcu_replace_pointer() and add the missing
> percpu_ref_kill() in the error path, matching the normal teardown
> sequence in memcg_reparent_objcgs().
> 
> Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
> pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
> through the node loop in mem_cgroup_alloc().
> 
> Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>   mm/memcontrol.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..00b3bb81aee4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3936,6 +3936,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
>   
>   	for_each_node(node) {
>   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> +		if (!pn)
> +			continue;
>   
>   		obj_cgroup_put(pn->orig_objcg);
>   		free_mem_cgroup_per_node_info(pn);
> @@ -4137,8 +4139,11 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>   free_objcg:
>   	for_each_node(nid) {
>   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];

Nit: A newline character is needed here, otherwise the checkpatch might
complain.

> +		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
> +		if (objcg)
> +			percpu_ref_kill(&objcg->refcnt);
>   
> -		if (pn && pn->orig_objcg) {
> +		if (pn->orig_objcg) {
>   			obj_cgroup_put(pn->orig_objcg);
>   			/*
>   			 * Reset pn->orig_objcg to NULL to prevent

Make sense, thanks!

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>





