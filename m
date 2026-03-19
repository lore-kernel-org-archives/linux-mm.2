Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AD01075264
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637276B0406; Thu, 19 Mar 2026 03:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F2F6B0408; Thu, 19 Mar 2026 03:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525306B0409; Thu, 19 Mar 2026 03:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E12D6B0406
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:01:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECA7A58B95
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:01:30 +0000 (UTC)
X-FDA: 84561916740.07.5E47885
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11969A000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:01:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tlmZ5xiQ;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773903689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/U78KrKZVBIu5ehpuQ4/fZRhBDoWKv6D9gIIE+dCgM=;
	b=Jsnkjp4dXvQ1dLOGMhm1AiH9kfL5NQ9l6Lfw0BnX96gmlMdDxKCUG+/sAPtCy7aM/8PjGv
	Z2NjsX5pmDi4lDPNd4xS2CUF8EBX/C3wylIcba4nTwxaZ/V0sy1E0cdBMNym7jH98uEx08
	qOgW70Zt7Clkwmob7EqV+o1HoB3qF10=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tlmZ5xiQ;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773903689; a=rsa-sha256;
	cv=none;
	b=lKt7JQfEuZ3N2pkCLkZskaRgHfkqPQRAV2IWCEBA2ZK/vRiJbDohTrXIighSbIUIbPuzQc
	A/rvklx2kRNtySrZKRgzL3BrGUKEt/qn++yL1yZXKAb0bl2+RsAvwYEE6qIn6ioLp6VtrG
	FY29vgticJGjlAYJkPYOi/a0LkzTiak=
Date: Thu, 19 Mar 2026 15:01:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773903685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t/U78KrKZVBIu5ehpuQ4/fZRhBDoWKv6D9gIIE+dCgM=;
	b=tlmZ5xiQ6ub1GOaKYMeZwLenoSdiiF2PhmVqr80Ar9LkIACfIMbH4S64r4nI84t3ARixkY
	EQobgKRxsj3vrwfERp/lHG7PCkRux1VVjvHufWsZ1X1Ssls3pTrJtFezdVQXm3agl09v0W
	sP80E1+/kdn/+Gkm4nW/N/rubaGKd8Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Message-ID: <jwlqiygxlch5gq6g3vkwynrpndjwcoxwice2hmvim3tvdfubp4@je5ldr7pa5f6>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
 <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
 <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 11969A000D
X-Stat-Signature: h6febdud445y5e654rspygc65qicbym4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773903688-816242
X-HE-Meta: U2FsdGVkX19Saj+vwdZkSPo2XAFNUAYP9n3x3EDwzhtzn3OeuEbVz15uO6JipE7gJwSven1KGkjyP+C45N79KW3rrotoAVEzGoEEBGKr5oHWJzhLVCa6jydx5PUzwvBlyojJ9sRiTMetoZ7C7FIcTnrIwn0YIS7LDF2xovm+tlV7srdvbiD/vD9ZhKDPRbTM4hOcAZjFOWH2OjyAbjhQGFAJRZYsOopaQzBfkoFaSxXc3dxC/7eFRN9Gb5WrW8K0O4kTyv+NxvtxKC8V5klpJdOrfulbVgOssww/bhNJSm6Mj0EvkRdqZJBgvgm/SJ9CL7DjWfv2o2O9DFlwx552gvzTeGCK0UwXJrZgF5N40fBhWCZgticmQxLvXALtBDqi4jjxpAm36Oac2zZv8Ao9nCdcBI4GRyGQ7njeRBgnXP311//H2Y/h91twP2w2ct0pOCCsPrm+UWJ4QovCTPkIM3v0hRrh8nfLquf535s+0odG95HT9u8ZqoGDUNkPznojD2vkVZTAftrf1jH/t9w2TAkXXzYi1mE5dd19RHKdqq+Ap0/TNfO86nATothBxNbW0NQuTw08vpcJ9hJo26HoAOxzWf8HLvFKUtKU1kE79IHinRDtf9dSMVlp3hrRC3EifwHvIAJhEq60d0jJ16tXZ8B8bPsJxawuP0oaxF6se60Wq3/qR+1wuLsl+KPOq7a3U9bYIkud/HBa49SmDkX5PY7Jtn6hWyc6kpLlFyyMWaWVY2cRL5clDW7GgrIvDb6g1PZsni0j426uhz4z0y2yE/xHZ8MgtbFrxLr0fOPvV53BF3bVyPEf+yB1BbPdX7qXnFU05tFhLJvgeVifwc/yWMjYOFyF7lDqFOMRJK39NOHkrkOxTGFIJ8PKCz9MUYbLAabxuxgulk69l/KrWM4dtpZDWHKp+dIVSmBN4gI1V7wUu3mRRoZjr1OxBphGxYXKghmWLjjpvO2x9TIXIxK
 Ugc662bQ
 xFthrod49BuvbQkQu9+CO9C+ZHqoxuwcmz07acO1B85J1l4LCGEamSNw3+gpgyWoVSh71Fv+/BJlFcm2SCqK9Y63YkycCpdhzcQD96fW2g3HgCfCtMOankXaUCBfOj8VY+IS+57D5LsSZzymNolPI6ciXgQeOY/Vi3rhbIq5kyrYrXo1Z8ZatRBVPYIrrvgM06vDiZbjVZl9Zys+ISjjcDxk5iaZRE/2+ORmhkFysRx4ToaIVv6l5RO/b/ifNl6jl2oUYJxyvyb4x9w60o+xtIAKqqTbi8iwlamAR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:11:58PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/18/26 10:27, Hao Li wrote:
> > On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
> >> Ming Lei has reported [1] a performance regression due to replacing cpu
> >> (partial) slabs with sheaves. With slub stats enabled, a large amount of
> >> slowpath allocations were observed. The affected system has 8 online
> >> NUMA nodes but only 2 have memory.
> >> 
> >> For sheaves to work effectively on given cpu, its NUMA node has to have
> >> struct node_barn allocated. Those are currently only allocated on nodes
> >> with memory (N_MEMORY) where kmem_cache_node also exist as the goal is
> >> to cache only node-local objects. But in order to have good performance
> >> on a memoryless node, we need its barn to exist and use sheaves to cache
> >> non-local objects (as no local objects can exist anyway).
> >> 
> >> Therefore change the implementation to allocate barns on all online
> >> nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
> >> callback as that's when a memoryless node can become online.
> >> 
> >> Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
> >> the barn of the local cpu's (potentially memoryless) node, and not to
> >> the nearest node with memory anymore.
> >> 
> >> Reported-by: Ming Lei <ming.lei@redhat.com>
> >> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >>  1 file changed, 59 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 609a183f8533..d8496b37e364 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> > [...]
> >>  
> >>  	/*
> >> @@ -7597,7 +7648,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
> >>  	if (slab_state == DOWN || !cache_has_sheaves(s))
> >>  		return 1;
> >>  
> >> -	for_each_node_mask(node, slab_nodes) {
> >> +	for_each_node_mask(node, slab_barn_nodes) {
> >>  		struct node_barn *barn;
> >>  
> >>  		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
> >> @@ -8250,6 +8301,7 @@ static int slab_mem_going_online_callback(int nid)
> >>  	 * and barn initialized for the new node.
> >>  	 */
> >>  	node_set(nid, slab_nodes);
> >> +	node_set(nid, slab_barn_nodes);
> > 
> > I had a somewhat related question here.
> > 
> > During memory hotplug, we call node_set() on slab_nodes when memory is brought
> > online, but we do not seem to call node_clear() when memory is taken offline. I
> > was wondering what the reasoning behind this is.
> 
> Probably nobody took the task the implement the necessary teardown.
> 
> > That also made me wonder about a related case. If I am understanding this
> > correctly, even if all memory of a node has been offlined, slab_nodes would
> > still make it appear that the node has memory, even though in reality it no
> > longer does. If so, then in patch 3, the condition
> > "if (unlikely(!node_isset(numa_node, slab_nodes)))" in can_free_to_pcs() seems
> > would cause the object free path to skip sheaves.
> 
> Maybe the condition should be looking at N_MEMORY then?

Yes, that's what I was thinking too.
I feel that, at least for the current patchset, this is probably a reasonable
approach.

> 
> Also ideally we should be using N_NORMAL_MEMORY everywhere for slab_nodes.
> Oh we actually did, but give that up in commit 1bf47d4195e45.

Thanks, I hadn't realized that node_clear had actually existed before.

> 
> Note in practice full memory offline of a node can only be achieved if it
> was all ZONE_MOVABLE and thus no slab allocations ever happened on it. But
> if it has only movable memory, it's practically memoryless for slab
> purposes.

That's a good point! I just realized that too.

> Maybe the condition should be looking at N_NORMAL_MEMORY then.
> That would cover the case when it became offline and also the case when it's
> online but with only movable memory?

Exactly, conceptually, N_NORMAL_MEMORY seems more precise than N_MEMORY. I took
a quick look through the code, though, and it seems that N_NORMAL_MEMORY hasn't
been fully handled in the hotplug code.

Given that, I think it makes sense to use N_MEMORY for now, and then switch to
N_NORMAL_MEMORY later once the handling there is improved.

> 
> I don't know if with CONFIG_HAVE_MEMORYLESS_NODES it's possible that
> numa_mem_id() (the closest node with memory) would be ZONE_MOVABLE only.
> Maybe let's hope not, and not adjust that part?
> 

I think that, in the CONFIG_HAVE_MEMORYLESS_NODES=y case, numa_mem_id() ends up
calling local_memory_node(), and the NUMA node it returns should be one that
can allocate slab memory. So the slab_node == numa_node check seems reasonable
to me.

So it seems that the issue being discussed here may only be specific to the
CONFIG_HAVE_MEMORYLESS_NODES=n case.

-- 
Thanks,
Hao

