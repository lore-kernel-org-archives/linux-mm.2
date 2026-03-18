Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E981088E50
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A426B0128; Wed, 18 Mar 2026 19:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11E06B01AB; Wed, 18 Mar 2026 19:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C502E6B0179; Wed, 18 Mar 2026 19:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6B096B0381
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:18:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8654213965B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:18:47 +0000 (UTC)
X-FDA: 84560750694.08.EFD68D2
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 96B4B18000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:18:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYjeeKYM;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773875926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjKHYPc+B5BboVXqMjZK9++bZMqF+zx4HN4Q+1hWflo=;
	b=lIoECMPMs/56ZdqigT+Qcq6+HiOskow6eenEiphhtdWIJYBD2oUXqpqgw46+9qaECrW2RJ
	dLH+ji2FFde/Hv/klqQN0gsjhEW5zz5gFxWgYTaGaYVbmUs8nVxvY1makvYIOQW3YxMHz+
	MVa1m6aFRZU1rlpm2uNM/trKFHYqL+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773875926; a=rsa-sha256;
	cv=none;
	b=Gd+Qy/N+CJNn4S7ng4jkJkqAiR6v/hmxc6JxfqaTz7kUHikYiskoE7cQQU7CaYG4H22nBh
	35at4U/2sDxGqhD7BDeyt4vrbGKyi4W63/K7SKMyeOur0Q103SrmLvJ29AX35Xm7a7HG5t
	iLb/HQVem/cecvU0FRBwr6a9zfwjuH8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYjeeKYM;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 16:18:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773875923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjKHYPc+B5BboVXqMjZK9++bZMqF+zx4HN4Q+1hWflo=;
	b=tYjeeKYMEP0E5b3GvYxkMH61Bw7cW2YMfRBzxlBQMXeY54vb4ynPIeuE9BCpVXmLeW4HEh
	1mDr8WaJoeNH//V0R6Hb7sushSyEqU7Gkg8LGV72ElTViQYbj9G1U7qi+ernx3HGsPgBeJ
	MARIdAxBEgLINq5UEIFddalgUVXlsRI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <absyranDm_lH59k8@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-8-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96B4B18000B
X-Stat-Signature: foi3hjnbrawra17qnn8k6emuwohf7ti6
X-Rspam-User: 
X-HE-Tag: 1773875925-285071
X-HE-Meta: U2FsdGVkX1+f2fH3RrxbBpZKflveEC7pprbPqp4GIaAYKXdC2mXTjU/1va6oaRPDdN9UTsaSIFt7DZd1cKj5AJWRTOeqkA8BJw+HgFSCSRHKCehbyVP9Wma53cQXV/m+zGnRVlvGqpYurD2DH5NN6B8EmaHyVtcis9sObIntv+a2XlvaheLUV3RBpkmDlm821akGhUk8imhXCFN0KxviLq71UjDmGD/7SMcHm1EGlX1Sk+k0zWeAV8mTf/Hizk8LI3sgbAGVSVg2xzGtew7am0ksWvKiicgXJf1lw3kxg6Ot4hDKD/RKIdnJsQs8nlDIrkqnunL0LPmwQ2kxPPqpkru5l+GqGSwWzQs8Jn+AQa+7UeVQbjYaYMvRLDNcRZNes0wp6DRYMCf0BO2R34LKHbWynEsXkephiS84WvF8A8+dtdC1z76A3zMsrDvo1N4q7HtKK29dKp016H85YJFWc9bKzNNQdzTVO6k3xNfH03ljrAS/sMCMZ7lilD9clq7vlLBW2RdhMwBv+t1MAXTsk/9Hy8sjQspG98fD6uDvgcbDEy3GrOYFsYzsbUvyHeU9VQkrh3DRI/+vhPzvqPkRJv+JI/3Cn4Kmwem/xQ8LHS6jqOUFu4Jt8A5Im5fenXBzmMzugDdmaWNs4ntyFEzUfRlKCD3BjFRkeQry+wql9OIkZ6BupEU/jVmUXe/Nu79fb7IcJhD2rsGrv2ggr5y0pnPu4GeogflbuYyQqgUYFMEXfMKkM2+VlI54YYyO8Ms1XR54YK2pq/sYCQ/jF1YK0KSomvF9Hd2cOScAa3N9GTA22e6t8JmJMI0u/IZJMeMO/BmVX/D6TGfH/5a3qGYcOoCnFJGqrZDAb0FDkc1sUJ2v/zR8kWrhoWkN2GqPgXD3em4KJcsinSfpdpaNCr4iYf7PocwFL4CYLEokLSgjX+eukCcNlFP5uw0xN25idFJA7eKEOFWTG1QxUpPs7pj
 rSdPQG28
 8bU/KKzs96elp7drlHzTh0/J44Ium83aXyritvsd5F+ZRxz3bG56zBS2vJZ1vynwE58pKtLsrsgjkXZf9wUvfK5ugrlpg2PPw8icKyP279PnEiyKCY/OLzfCEn2rBh+ULAiE5nJBkeRpOYU6f/PGRxSFQO8WouYVAvzU31XtUHRgpkHStZRvteoBAANqKapVSGRHKFxnzojP43r3VKMLdUaAdaMG8HugytHwzm+FWNf6sJYTsh8AK2FJJoNvshF/ojx06DE/EJnDokzvRLlx5s3/tCUMvqgKydpPrUkAwTy3ZJhswqrFqOLO/7Na8bX3GwJ+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:25PM -0400, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 	          deferred_split_scan()
> 	            walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

