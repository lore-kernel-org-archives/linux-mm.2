Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6820BE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B232D6B00CE; Sun, 21 Dec 2025 07:07:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA7E6B00CF; Sun, 21 Dec 2025 07:07:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992276B00D0; Sun, 21 Dec 2025 07:07:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 854C76B00CE
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:07:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2845C607A2
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:07:59 +0000 (UTC)
X-FDA: 84243354678.02.7F9DFE9
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 592D3140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:07:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vMwsjcOu;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766318877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImyYpBYHczXKmZOJ0nv2yp1b5vTgB4LNV5Y2WhaumNQ=;
	b=lRCYb21+gVZ0qDHe+PJPd5ucqahWKRQPyeg/fvBxGEUoRHphnPRNxHtUmoaFwMn00ATVVq
	a6HF5aAjpUAtVs9iJkjyIVWeuAlYiQKX6lgyDdD3tssEJWmEX+vyPpXHpRPqmv774l4VqM
	eeGzPT/IaRcEbaT4sQlJuvOmczTXrfE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vMwsjcOu;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766318877; a=rsa-sha256;
	cv=none;
	b=qe1CVIqHniBUabeTNuR2MQZkA5tng8fU4y403S+xHBY/F4r/B7evcGz/+lWEJSWJ44Magb
	bNV60zKOkwQdWq1do87d9szLxKxteEqLL82XTQae841JWo5PEu5Qg11aJE2hgkWJn1aA3j
	sKnMCbrHLo4AEyRMGvsLRupMs5q1uiY=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88267973e5cso20780856d6.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766318876; x=1766923676; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ImyYpBYHczXKmZOJ0nv2yp1b5vTgB4LNV5Y2WhaumNQ=;
        b=vMwsjcOuGnET52lWuZIQJnKnI0z+xNMAUgG8nA946s7irAzv+0TcJYV4sgIBUpww90
         nPd68HVH+9Pqr7u7F6LpoI7jc+tiKW72FzSp4kMPY1ubYjVt1P/jU3qub7I1LP7bhJRT
         6EIX9jieK5hm64N0HH3PIIfJJI1Lp7GrtEnXA59gQUP4zoZ6cvVGYRDEBb6M3kP2nVmr
         exrCDYZUdDpiNBKh4T7jXFrUMBwxrXnw2rW3bXJNtvnF7d88TOoAEvqizqDZmqyVaEJO
         S2sWS98KwAk9TYsy43W/aA8Nz/CKUmI8HWZxaqI31NNaWfQeNiw0+kDR1uNBKlHu6Jhb
         URYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766318876; x=1766923676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImyYpBYHczXKmZOJ0nv2yp1b5vTgB4LNV5Y2WhaumNQ=;
        b=CbaG2M4DHeHW4lVYOUBm7vM8IA8hyEQTkHN5zmk3ifbB4tVUHIo5CP72jVHCiJEGPW
         7x3joQfb1lrVq6TeW0BP6reRRHN5llgypJSatprAmPz04zPBltgk2Cux+JmcC872ntUj
         I54tK+ZGahwbpapDN92Egtsi/dryFoPwfS7+3TzuXUZDIjdgk0uea6WSU/8Kkf5y3PO9
         BMW3Zsf0DS5Mox+tm1ElGqoySZnoH5MVPnw0sg9L0dWBFmU57Hzovt/6H5DJ+TqUIPqa
         8BOyYblJAY4NazKbNhqHf39r0vsMZrcTeCHveD8tpufS93WQr72oRIQE99TLlbK2Kfid
         +Ujw==
X-Gm-Message-State: AOJu0YzzczJa1/8sinYLATUr7FKIs1aLBCOwyga+pN8M6kyYBJ+oirw6
	5KDjPEMwhSprPZDSfch+6KshyjXzw24mMgqvStShK7pJaW2MbA6N2a3zoLd64rC7YBE8BhRE9uk
	mdqsY
X-Gm-Gg: AY/fxX4eJCQ782JkGagAvmrCwIKBjehhRBgL5/vrhok3r300HffIzOBib5juUe+bLDa
	+znCFFO6kDTmTP24ZexbMbBODAABV4zAYty5HsKQR709l9eXS4YifbNboYh5DzC7jWGdIIePhc5
	1HhlNYbk66Jsu28xXjph5GVbTIANhgCS+Hj784HeMzK2sezfcf5XbpF0L4pfrTRcGOXJlz4NMCX
	yfQ2fyPpEEeBv/1kvYlpq66Eo31TNF6nEYT5h8bKVPirc41KsBJp+05gw8YNo3pd7Yv0NO6rZ08
	VlGkyuL+LrwAXJVHDEfhSG846/63ddBpR4wEI5N30v93IFFWtMo4b6hbLFvt2x7I1+r4U4HgS18
	8WW2cW6Dqo6fngpSXCDfJg4E9IxIA+hnuc0staf6/iozpp3aoql3XYDtpEo3zNP1BRLibbQihHb
	ASI5754IU2agZd20g9/G246EUnVeioRgUwmRozXBCPx3sw+3WosIScNeC3wqaKUPwytn38FA==
X-Google-Smtp-Source: AGHT+IFGNtL1aIwg3HtHmwchYyREfgUlw6VeYgEwe39zkib/ur8gNePpkMwSQGbagQRqT8PUrwoLJw==
X-Received: by 2002:a05:622a:1b29:b0:4ed:8264:91ba with SMTP id d75a77b69052e-4f4abd86bcamr105538801cf.58.1766318876084;
        Sun, 21 Dec 2025 04:07:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973ee011sm610870285a.38.2025.12.21.04.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:07:55 -0800 (PST)
Date: Sun, 21 Dec 2025 07:07:18 -0500
From: Gregory Price <gourry@gourry.net>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, Waiman Long <longman@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: respect mems_effective in demote_folio_list()
Message-ID: <aUfi9gn5HS4u4ShU@gourry-fedora-PF4VCD3F>
References: <20251220061022.2726028-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220061022.2726028-1-bingjiao@google.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: z57xcoaqctg3ejx369ufbeb9tggku9yo
X-Rspam-User: 
X-Rspamd-Queue-Id: 592D3140003
X-HE-Tag: 1766318877-982390
X-HE-Meta: U2FsdGVkX1/uTMheUwmuNHB6l078ZTfXzhCgXVKn+SnkXUcjoOmjIRMSzM3ztVdK1QTKNzOb31/vtFMtQLVmfDvg5wtlbhutLRBw+xvkXtn8kh6ptL27+YiPQ+dtKKggIs/LDaoKJTP55RGSnPkrcnp6e8XBZWKojVdVjHh8RzKwyF+kfSomGjy6GwsJ3mqcvJx90edRfQbyLKoWk62pAWNojKC0GsuqA00ekwFoPJbUtYnx4+iuWIEaIOwZna2vAWjiY84QElQ+a9tQb5/qzI9YolM+kj1+XDwnuQfc6PHR4Tejui3vNZ8pCrirSRlwDQI4x9htwgjNeVABduDr9MtV9H1nvj+PfMnIbPVae3Ww7I9ZuWrlmU0GlWTDdlqUY2iGtBRUNgxn8mRFtS/vrcua+GPuTn6GUtoM+R/Ua6mJZHpcJyfr2sObx01JHa80wCAfn4a8yIdcgP8g6BTaBjY/fMKEwm69LVVwzr+ABUXMLsuJShKG2ApjDpkJIakLu3refHzCLoFO8U1Ug83li3KVSmeb67LDcNaVH+oS7Iz4VHq53yUblkRddQqG9zRQ/NNy9k0PBaIlMJ9KIqxvgzbEpARiwmoZbrGH5qAv4fCvQpdcC343AtlKVTfQ5zSx7WjCryHvFfoGbCeritvp9Nd561vCZJ6N+rkpXh6wzOzRZ7RjKpianMfpJKeJ7lE6RkexixAu0N8y90DeW15pApr1Z3NcAYAGPLmkvYuEgDb70T9gyjeiEeTs8YVp+1ynfympMtAsWSBQvzmB7vcXWHb2WaGEECq3jAhzJex5w7/dFKgVLpadSkWulj8hE1SjvfHl5T1Tcmkegm2pFN8kXQaZvey9cZHyl5Hz/39SHhGB7S8Uuez77/dbjgkV2mDXXj5oS3idUJKKOHf3a5puhBQuR2V0hhvZpv0x0xY6XcT82+QuJ8ZciTQE65kH/ioXNs92QZPnsMNrVCRS0Pi
 2XalzyJc
 uxQuiSgiRRJrc7A+CDUsa02ZRxfkeaV3DtwSL99+zTUGBdKD7wSFJyNPaH7B3MavS7i1kEnjmhtSg/Ytrh1ylFMHZr+DXJGY0Q92sqV9dDkgLLoN+SF5APjMKZwVV1K37e9OZlBpnFLIEhrWeUEsSlY5hkZXNUEOXujUTmda8QdGMiiNE2VBfaofWV1RbZqbuoeME9ltM8t54YxfYxNguFPCXSfTlMVAjCfTIUgAjwseqINTSKWSkc07zwb4/InihhWLdWA97pU9BLM0rNJSKdNmpQfnkbMYCS9YsfQKwbJ/4D7aJC+rK6h6SONliIJTMSgP4oqmvaQBVakN9Z1iOtJ4eHdexUT0388Kjl+D7nsGJg//qSbgmzXT77g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I think this patch can be done without as many changes as proposed here.

> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
> +void mem_cgroup_node_allowed(struct mem_cgroup *memcg, nodemask_t *nodes);

> -static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +static inline void mem_cgroup_node_allowed(struct mem_cgroup *memcg,

> -int next_demotion_node(int node);
> +int next_demotion_node(int node, nodemask_t *mask);

> -bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +void cpuset_node_allowed(struct cgroup *cgroup, nodemask_t *nodes)

These are some fairly major contract changes, and the names don't make
much sense as a result.

Would be better to just make something like

/* Filter the given nmask based on cpuset.mems.allowed */
mem_cgroup_filter_mems_allowed(memg, nmask);

(or some other, better name)

separate of the existing interfaces, and operate on one scratch-mask if
possible.

> +static int get_demotion_targets(nodemask_t *targets, struct pglist_data *pgdat,
> +				struct mem_cgroup *memcg)
> +{
> +	nodemask_t allowed_mask;
> +	nodemask_t preferred_mask;
> +	int preferred_node;
> +
> +	if (!pgdat)
> +		return NUMA_NO_NODE;
> +
> +	preferred_node = next_demotion_node(pgdat->node_id, &preferred_mask);
> +	if (preferred_node == NUMA_NO_NODE)
> +		return NUMA_NO_NODE;
> +
> +	node_get_allowed_targets(pgdat, &allowed_mask);
> +	mem_cgroup_node_allowed(memcg, &allowed_mask);
> +	if (nodes_empty(allowed_mask))
> +		return NUMA_NO_NODE;
> +
> +	if (targets)
> +		nodes_copy(*targets, allowed_mask);
> +
> +	do {
> +		if (node_isset(preferred_node, allowed_mask))
> +			return preferred_node;
> +
> +		nodes_and(preferred_mask, preferred_mask, allowed_mask);
> +		if (!nodes_empty(preferred_mask))
> +			return node_random(&preferred_mask);
> +
> +		/*
> +		 * Hop to the next tier of preferred nodes. Even if
> +		 * preferred_node is not set in allowed_mask, still can use it
> +		 * to query the nest-best demotion nodes.
> +		 */
> +		preferred_node = next_demotion_node(preferred_node,
> +						    &preferred_mask);
> +	} while (preferred_node != NUMA_NO_NODE);
> +

What you're implementing here is effectively a new feature - allowing
demotion to jump nodes rather than just target the next demotion node.

This is nice, but it should be a separate patch proposal (I think Andrew
said something as much already) - not as part of a fix.

> +	/*
> +	 * Should not reach here, as a non-empty allowed_mask ensures
> +	 * there must have a target node for demotion.

Does it? What if preferred_node is online when calling
next_demotion_node(), but then is offline when
node_get_allowed_targets() is called?


> +	 * Otherwise, it suggests something wrong in node_demotion[]->preferred,
> +	 * where the same-tier nodes have different preferred targets.
> +	 * E.g., if node 0 identifies both nodes 2 and 3 as preferred targets,
> +	 * but nodes 2 and 3 themselves have different preferred nodes.
> +	 */
> +	WARN_ON_ONCE(1);
> +	return node_random(&allowed_mask);

Just returning a random allowed node seems like an objectively poor
result and we should just not demote if we reach this condition. It
likesly means hotplug was happening and node states changed.

> @@ -1041,10 +1090,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  	if (list_empty(demote_folios))
>  		return 0;
> 
> +	target_nid = get_demotion_targets(&allowed_mask, pgdat, memcg);
>  	if (target_nid == NUMA_NO_NODE)
>  		return 0;
> -
> -	node_get_allowed_targets(pgdat, &allowed_mask);

in the immediate fixup patch, it seems more expedient to just add the
function i described above

/* Filter the given nmask based on cpuset.mems.allowed */
mem_cgroup_filter_mems_allowed(memg, nmask);

and then add that immediate after the node_get_allowed_targets() call.

Then come back around afterwards to add the tier/node-skip functionality
from above in a separate feature patch.

~Gregory

---

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..1971a8d9475b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1046,6 +1046,11 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 
        node_get_allowed_targets(pgdat, &allowed_mask);
 
+       /* Filter based on mems_allowed, fail if the result is empty */
+       mem_cgroup_filter_nodemask(memcg, &allowed_mask);
+       if (nodes_empty(allowed_mask))
+               return 0;
+
        /* Demotion ignores all cpuset and mempolicy settings */
        migrate_pages(demote_folios, alloc_demote_folio, NULL,
                      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,



