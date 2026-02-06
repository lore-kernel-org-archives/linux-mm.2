Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724CBEE6B48
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77246B0089; Fri,  6 Feb 2026 13:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C219D6B0092; Fri,  6 Feb 2026 13:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24526B0093; Fri,  6 Feb 2026 13:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE706B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:52:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B2C813A2A8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:52:21 +0000 (UTC)
X-FDA: 84414927282.12.FA097AE
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90A1680014
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:52:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sitd4Vye;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770403939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7mumZbXKpp+UcC6LYCZ5Q8LNGAoHw/22vUr8wOhvA4=;
	b=8NBrFx/7jODG2WTx2kiuKklL5m9yZxv3AfVoYd2Vrz7behlcKbpEEJ2RlYqhdFIoVWTc0N
	x2V5Tuan6Y/hI8j5Et/ghmJIdtyclo1CorRSWC9KW1R0oW5krGCBOmPJaCrM01+9wp17L6
	c4CBu6I7tgXjGbKUhRtwF0pYwKO8DRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770403939; a=rsa-sha256;
	cv=none;
	b=gyrmffXnH1Cjj//YrdDDsE47syf9u2X7CpvCOqrW187HT843fqBHYTtbJILaeh4drWbVHV
	5MZ8F4ZXgnnzgfYT6nw6TzvjATt8nbl5AoXq5dbcIeYIzlVEVrmqdy+VuZWNw0JiZUEkYI
	dQ1VaNjL7Cb8BQsPm6h1P7PTESEwDc0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sitd4Vye;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 6 Feb 2026 10:52:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770403933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7mumZbXKpp+UcC6LYCZ5Q8LNGAoHw/22vUr8wOhvA4=;
	b=sitd4Vye4V/h7qHTBkS38bDEsI6P/BMUzZU1dGeEAQ7LW0tF0D+Xry1ug3ppPBmOqyXrwC
	D/QEjYc8d0wumdHpoeTnUJMnl6As6win53CMiNTMMfcYMZmcmkNwIbLcCqTZl7FzJM52eF
	Bwl6eGOB4b2Q1AbfDVxoZfR38JQX/mQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bing Jiao <bingjiao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/vmscan: select the closest perferred node in
 demote_folio_list()
Message-ID: <aYY39YGAHmF1Oi5H@linux.dev>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
 <20260114205305.2869796-3-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114205305.2869796-3-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 90A1680014
X-Stat-Signature: f8rjbdxt56mdp1nsgjf7q5jkrwnjqofd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770403937-499953
X-HE-Meta: U2FsdGVkX1/dDXF2RKNmlR2OOm1zLDaDMv+mnBDAM8vI4jZoTGceuYjwFrFcFtxBXfqOUho2rbiu0n778TpA2Xy7YHvD+lQzr6DzrgReaiVqjRjquOMVHxiN94fhSbkmtKRxlQVyASPwPtA1obkqYYIvWTzXsLpbd6nKhynmk8T0nZCLIy68V7cVrTuMYYTrDS31a96dg1u277ZqErSZXhjCEQk9ZRrG3thRUgUT4dHqYQJe4yjBns3o8uNlLbmq7q3osFeYA+pbX3mi5I8u67f7Z8ufX2OxGy4QX8pUH13lrSn3nabWZ2evPjGWbkgAqMZs6iDo8FC/LehjQwxX1jX3lByfh0xE0Cttod3+vE9BnShQV56VrA9iboQdtw52n6OAA/oRgw1/WEaVPm69KMykloFLYySIUOk79c0IODzrpjGtt6henVKIelxT6rCA6dx2acWMEQBYXjKO8KBOD42FPGWxlpOI01IXzFQWjKa3DxG3qZQyPp9B4vFIh7VDoUvSYpnCgiXDfmqGi3BpoRD7LsRMqw3xNzmyCy7Y8Fuc3r6c6EyUhbv+sjRdkJBJNbPU0+br2U2o8YSIumlocack7cr0JoCo//rcWn5eFktVA38yQ/b5xQ/31TO2tMbuBXBirqnppnSYO+SfBEdiAp1RQvPX1+IfhY4uDgoGThV3TuGiYirSsLIMS+Ck77yzFHVO+E5eiOh/SXWnVWSHR+SVw27rQs+yGMQ/Hnwh+jGVJ6m0M2sShBoY4+MC7pYE6/dNHL99dx1nMm3m1L9dRAsEZjXhbDk7N6Fz8DcEk3Ob6vweBHqGgQE8JmpviM884FL2ugnyz/fnjGqqIx0DALW9ArNmysNM6hdGO8akyWwXIYJ1V/rncGJWS0mYPeq4bPI9BllkGWVyLR3w17RWTP8CRy39zwRR6RUyZaLI/JQELhfdw6/jO4SYLQPI8/cR4XU+YFhyuMlW5FPGhst
 UN4DE7n7
 XS1bhYGSHr6/wLkfUaizL7uYRDWVnypkpGZA9Idc8kiax3IflDgZJaguhKp84cBsWjT/kdMRL47ePyTP6aiqH5rB2dW4XKLxqgiOTQ768lQmDSyY7haD8Q6Q5HisgfgqQJzDRveoY8pjwH/I/Dx337vsPollgdD1OU+4H7Xbhq5/kv3RwTg28dcE/i7hCkaXA4pV89JOC3qewxWnXrpWFv8AVFyyLj+XqRgKe8J+LWY5RtPCapu1tt6NCe4g8xE6ll4anYX1ZFb1qKx6vttyAhean4FnfZhA4F3K+mcPX8x0I+FPWSL79hBI55r6k7L9DdmNZKgeNCFA4uRr6M3emh/9VHCaQavh7cJG+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 08:53:03PM +0000, Bing Jiao wrote:
> The preferred demotion node (migration_target_control.nid) should be the
> one closest to the source node to minimize migration latency.  Currently,
> a discrepancy exists where demote_folio_list() randomly selects an allowed
> node if the preferred node from next_demotion_node() is not set in
> mems_effective.
> 
> To address it, update next_demotion_node() to select a preferred target
> against allowed nodes; and to return the closest demotion target if all
> preferred nodes are not in mems_effective via next_demotion_node().
> 
> It ensures that the preferred demotion target is consistently the closest
> available node to the source node.
> 
> Signed-off-by: Bing Jiao <bingjiao@google.com>

One nit below:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

[...]

> @@ -320,16 +320,17 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
>  /**
>   * next_demotion_node() - Get the next node in the demotion path
>   * @node: The starting node to lookup the next node
> + * @allowed_mask: The pointer to allowed node mask
>   *
>   * Return: node id for next memory node in the demotion path hierarchy
>   * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
>   * @node online or guarantee that it *continues* to be the next demotion
>   * target.
>   */
> -int next_demotion_node(int node)
> +int next_demotion_node(int node, const nodemask_t *allowed_mask)
>  {
>  	struct demotion_nodes *nd;
> -	int target;
> +	nodemask_t mask;
> 
>  	if (!node_demotion)
>  		return NUMA_NO_NODE;
> @@ -344,6 +345,10 @@ int next_demotion_node(int node)
>  	 * node_demotion[] reads need to be consistent.
>  	 */
>  	rcu_read_lock();
> +	/* Filter out nodes that are not in allowed_mask. */
> +	nodes_and(mask, nd->preferred, *allowed_mask);
> +	rcu_read_unlock();
> +
>  	/*
>  	 * If there are multiple target nodes, just select one
>  	 * target node randomly.
> @@ -356,10 +361,16 @@ int next_demotion_node(int node)
>  	 * caching issue, which seems more complicated. So selecting
>  	 * target node randomly seems better until now.
>  	 */
> -	target = node_random(&nd->preferred);
> -	rcu_read_unlock();
> +	if (!nodes_empty(mask))
> +		return node_random(&mask);
> 
> -	return target;
> +	/*
> +	 * Preferred nodes are not in allowed_mask. Filp bits in

Filp -> Flip

> +	 * allowed_mask as used node mask. Then, use it to get the
> +	 * closest demotion target.
> +	 */
> +	nodes_complement(mask, *allowed_mask);
> +	return find_next_best_node(node, &mask);
>  }
> 

