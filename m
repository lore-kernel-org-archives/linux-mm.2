Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2370710854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6677B6B014D; Wed, 18 Mar 2026 05:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E6B6B014F; Wed, 18 Mar 2026 05:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BB16B0150; Wed, 18 Mar 2026 05:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 467796B014D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:27:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 105B513B2D6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:27:31 +0000 (UTC)
X-FDA: 84558655902.30.3A17694
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BFE9180017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:27:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ys835fqg;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773826049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1TvrhslTZe3ORZZvlXBl8IaIydCP3TVm9eL8k75o9Y=;
	b=YVEtSglpDKnDE0KUvWDQNQwjOj/OdK+ghAUtv8sbrorJZJOT9pJXL5boMVwoR/v9zPNKY9
	PA4ZLA5Wii2bCeHoeX44wQNxw5lmbdxJ/AUnjOPL5tNyEKleDpHhjaeUmOTrJKhRop7jnD
	xAPbUcjSbfnTDsHd228lMPCvCuI0kHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773826049; a=rsa-sha256;
	cv=none;
	b=F5Ic0MEqnhTwoDjLKyjAmJIDrgP/Md7phKnyx3C6qrxTtifKV6Nl7LIE0DZZdsA8X6E8g9
	Zi1z/PEJOJ+ZuOmxGj30OND8iAMLgOwT9/11pgjlWAfbdQQNeaHbajuBixOU4qf92S6S5K
	cx9ESLrUhwFPXsOuWXMBcUxNV7XvBJg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ys835fqg;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 17:27:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773826047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G1TvrhslTZe3ORZZvlXBl8IaIydCP3TVm9eL8k75o9Y=;
	b=Ys835fqg4kVZHth7oPUB5IJsgGsoAj+Qb/Wz+rQEQBtZV0nIvU7uI3trfVOFlILNlMaUiy
	7Eun1cZdwpLXbEQGI3SbAUpdlicYFfOZKkw8fPyewbHoZwZE/RSTNwD2Ds2Dq469PZdy0p
	kRA1uYx0ccXpASaXgPxUqV7CpS4zzFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Message-ID: <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2BFE9180017
X-Stat-Signature: 8cig86ofsgujoepkgi7iz91c9eqmpj5t
X-Rspam-User: 
X-HE-Tag: 1773826048-449001
X-HE-Meta: U2FsdGVkX1+kQUqZTzQOD3GM2krR+iIfIKuw31+TEo/MwmEzgXpARKpBnbPAg6CsNkmC+SoW9DyC7PyDHAQyyjemkcrsH9WhxrjCOC6xhBEfE8Njj1vAPqEevzhBp+0kTzxNnCOiYGdDPLD36UA3i7890hLMOIjxtpQkVIz0tntSdRVfQseGuJGErOKzKwOtHvGuhgNIWZ4ETjKdrfHzUFXC+5xqeesCcR1XCRctPQskCk8oDNFECsHx3MIPLc4GxzQPzLnk3gdFwT5upQSehD7s26YE/eiel4o42Y0mb9jtHFy57XqCDSHo37OqO6+IzBBEHTpUfZAYLVC2AejpVxiXVb4cRPKWpk+FO9TViRYUQISrsXg56wrPPDfm1C6uORHrb12I7v5xsXgmGwdk/gBWb97M77QhP2SQPZ2VS2fs8f6QMDukXUTN8qQVjYOU6KrwVtwxbH0k4w5dR0hrxoiZwPxDoPTt4HpDl1e61NkxmEGu326muKCT2077Rvuv/GPxrMMakxt4M+2moOR4Drf5PpoYW4Bmram6rrgImI11Zv++kxmLeJ4p/L/mtvvXQjzV8vLtj7B0H9ra+rW2aOV9V815+6aoqbCeVqZhJ5jdpIMMASjZYy9qbK5TVYlSwdaNGnkWUYeNAamjpdYFeC4rSffwwOJnzhX0NdnfMj+LdQNGknUojvppRepsTd4sV/c72V686xlqXdx5OF2IZDETX5xr+nW5dC4tP8QW6j7/7RSmj1Lb7EwY7kDhuPsC53Fk/fVzI4Rv8Aqpb/olNwSuihVGr/lbWOT5jU/zeiVVO60on9amwAHaQAnkejBFxIi3Rlj2vDPAse0JRQJVLF6TriI0djsgd5ifHjNysOf51jynxg1OFfz0f6K1lyXHK6ScA3G+hB4wkrcR/eiSQq/2Ijek/XCTAYo7UTdCIS0mxM6Y7HXr++38LChw5KNfXJVBiAtp9ElBmtElfH+
 yef0rs87
 LMpFRL9eIppffCX0YSFIEhchbUKD73pXuSc4XE7K7fL3qi4mz46Me/lGGFAIUvyN/n5OS6V/B2V/PQfeyV+HF1msDptMGMdvxv796dKcRYn5rX4L8RTId2fXruGvSkRr/iTLikX0IQDuFo4OqcruxuwL0W0hXCY5er68dris24rMs68bKPkTcCk07D2Q4Thkh0wA5przLOJy2Inrk1r8221ebb+1DMnhm/cFCB1bj+sKxdCQjKvWEbAUFx9KWYOjPj/q0pIhxJ16PQO/x0iyvL3g3dg1OvzakTH+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
> Ming Lei has reported [1] a performance regression due to replacing cpu
> (partial) slabs with sheaves. With slub stats enabled, a large amount of
> slowpath allocations were observed. The affected system has 8 online
> NUMA nodes but only 2 have memory.
> 
> For sheaves to work effectively on given cpu, its NUMA node has to have
> struct node_barn allocated. Those are currently only allocated on nodes
> with memory (N_MEMORY) where kmem_cache_node also exist as the goal is
> to cache only node-local objects. But in order to have good performance
> on a memoryless node, we need its barn to exist and use sheaves to cache
> non-local objects (as no local objects can exist anyway).
> 
> Therefore change the implementation to allocate barns on all online
> nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
> callback as that's when a memoryless node can become online.
> 
> Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
> the barn of the local cpu's (potentially memoryless) node, and not to
> the nearest node with memory anymore.
> 
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 609a183f8533..d8496b37e364 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
[...]
>  
>  	/*
> @@ -7597,7 +7648,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>  	if (slab_state == DOWN || !cache_has_sheaves(s))
>  		return 1;
>  
> -	for_each_node_mask(node, slab_nodes) {
> +	for_each_node_mask(node, slab_barn_nodes) {
>  		struct node_barn *barn;
>  
>  		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
> @@ -8250,6 +8301,7 @@ static int slab_mem_going_online_callback(int nid)
>  	 * and barn initialized for the new node.
>  	 */
>  	node_set(nid, slab_nodes);
> +	node_set(nid, slab_barn_nodes);

I had a somewhat related question here.

During memory hotplug, we call node_set() on slab_nodes when memory is brought
online, but we do not seem to call node_clear() when memory is taken offline. I
was wondering what the reasoning behind this is.

That also made me wonder about a related case. If I am understanding this
correctly, even if all memory of a node has been offlined, slab_nodes would
still make it appear that the node has memory, even though in reality it no
longer does. If so, then in patch 3, the condition
"if (unlikely(!node_isset(numa_node, slab_nodes)))" in can_free_to_pcs() seems
would cause the object free path to skip sheaves.

-- 
Thanks,
Hao

