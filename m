Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE34C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 06:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACC26B008C; Mon, 27 Jul 2026 02:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F2C6B0093; Mon, 27 Jul 2026 02:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F886B0095; Mon, 27 Jul 2026 02:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9890A6B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:21:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1195E1A065F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:21:28 +0000 (UTC)
X-FDA: 85033559856.01.5B16A7F
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id 012CBC0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:21:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paWi0RpD;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785133286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fgIomM+t2T3cQpKKoj4SNC1imJIcl8wBpZBAKlnU9I=;
	b=GnCH6SOSl1y+m7YjDNGKgj1isReHwxOCvmhCzN4k5MHnaVA+rj7j0bXb7Ed2CvKyYB+6Nw
	ye4rCmAgiTDsAKRvUTXA1hPgkb4u17FdqX6gIV5zh4t5JjaR4TyLchb7Y5jUvw3/WDiMfg
	CcGf65LaKRTcVAJ6Yx0E1dofbumIJMM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paWi0RpD;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785133286;
	b=v+Sx8qVUC/vp+3+e1ygeaZjlITWjWnGc4OAQu0+db5r2OqwcVcrU95yNTXhbj8wiKyUMox
	7uwxO/X49teBbnpW4jfmG5CNd+vM6TdY4NYebUs3IGjFKpfOgz7iP6vbAg9jVk6FkDvXAK
	7+dMPaDKjx8YNSwCzU02wyhtJzCBY/o=
Date: Mon, 27 Jul 2026 14:21:12 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fgIomM+t2T3cQpKKoj4SNC1imJIcl8wBpZBAKlnU9I=;
	b=paWi0RpDJlvEn9JWEzhmuu1dzQj5I0SoPhXg10lFhGyhsZ6JfGv4JgmP//o//Y9g8URFoE
	ypLyygwDMPj6xYquuYt5ZQLa/sm43KrJLofswsr+LVr4z5ZgWcbmEo1uOIGzwnXldxQbkt
	1YeUDEMzwEnyeu74CAbGekuNrK3tDiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Message-ID: <amb4KFF6nYyToYNC@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <amC6frE3LoWYjTMh@fedora>
 <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 012CBC0006
X-Rspam-User: 
X-Stat-Signature: b6ed8w5oqgf75tsniffh978hoheker7j
X-Rspamd-Server: rspam04
X-HE-Tag: 1785133285-764827
X-HE-Meta: U2FsdGVkX1/2mPDN7BT6rd1m80oB52Y+94sQTb3gsMHFzMZFCF11DffapERZetTSBCZDTw2FUpCDgEuQQPQoTVGWno8a3QKMfVvFHfHqBD7D45wfltMuz/iRF9XVFCA++BjMSXch0JYSyPqxpNtZ1CTa3/DNjX7i0tiXV7i6pz0clNsLjyEQ/FCS6l8WJOr5LTVRmK1MgpEABz2fGQimZb4xoI1Hdn+qbNAUI4zVwTJVv72fVK/KXEe1g52ghmV1HvnA44Pt9qb/YJdLxfZQls8n7saxej2YvXvuPaNNh0aWvLAbfRUhj4fbvdviz6hOWbBfC1C+LY5uWMrpo0x4kFXMpMFK85YXIluF7fgX7nHCrMEDnkN3vZEktbyoQrjG2YaLo/jh0qvbEZCXSGYHISEBUIFE2xpIPzWML3VR4yNIAHwiIpVDqS2Wf+8eoF00L9Nq0W+BgQZhAmx26Drh/5bqay8TpTk77U9oESvTxd8u2r7hwqnLC45jC9/hNs8yEfizWj6QCMvhUJvKDw8cMlwMH6mhk7LpBjuVhd9Zmd9Lh7z4LYJ3ulCnW+1h0QRMJqcv2PvUzX1BlK9tHPi8SFTk1OTkWlhsA1c1h70ESXlpMrQFq3Hhqrb2PLPw1n5UwZlA+ZY6EwUo/dypK5wRuirzKE1HB/HTcBdbL0OgnqX0hJGxACPwb5PlIUu+QjVrB+ZSH10Tg595WWqKvWRpNHZH1ga9VoiTFFrs1AMhi5QQiI4OGJGqGPW+WB2gRtS3FIxFsi1CEQ+FE2NNFEf4/R1FEF0C/avzgu6RbeZfoGqEa+T9FFYHpLYf+TuD3NJZAYLUgyPj4h0yarSL0F9s6FLWbzx/fzywQCClSHwN24xj4qKm2oue5umTwSLxXhRxCKa4vysHsm2Mil35qEdFm5FGqHaQwKqXOEZgb4apV28g4P6Tc6vfNP6GR/4preY8lZ6g3RfmOO0+UbYrQdv
 EhZ9BSTb
 Mrsm3REiWvLwDs3F77HZFATcnhvkDZRx5i9bVb/+xG04YeHWLAR4YmnufRB+gUYWr1VGePp8YgBekP89eh7LcUc/Ll9C8n25pyI3eCrLO9YRN60BrT8XYBpeBWDEgpgVgMsKBkWJyk3lmI5H6N8ntkNOKn0thYngkxBT00xgUOFfU4pMYZzMDeWz6qtaPh0LkNTA77Y46MoXAB8C4H2cgWwJb3qzl0HKLrN0JWgGp1aeVhOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 05:58:36PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/22/26 14:47, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
> >> struct kfence_metadata only contains struct slabobj_ext with
> >> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> >> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> >> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> >> enabled, it will end up allocating its obj_exts via
> >> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
> >> These will probably then never be freed.
> >> 
> >> So things sorta work, but not always in the intended and optimal way.
> >> The upcoming changes to slabobj_ext layout would additionally need a
> >> proper refactoring to keep working.
> >> 
> >> However, there's little benefit in accounting KFENCE objects. KFENCE
> >> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> >> (default to 255) outstanding ones at any time. For any callsite
> >> prominent enough in the memory allocation profiling stats, allocations
> >> served from KFENCE will be lost in the noise.
> >> 
> >> Thus let's not complicate things and simply stop accounting KFENCE
> >> objects in allocation profiling and skip them in the related slab hooks.
> >> 
> >> We also need to skip kfence objects in mark_obj_codetag_empty() in case
> >> a sheaf is allocated from kfence, per earlier sashiko review.
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  Documentation/mm/allocation-profiling.rst |  7 +++++++
> >>  mm/slub.c                                 | 11 +++++++++++
> >>  2 files changed, 18 insertions(+)
> >> 
> >> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> >> index 5389d241176a..d02eb54ee8f2 100644
> >> --- a/Documentation/mm/allocation-profiling.rst
> >> +++ b/Documentation/mm/allocation-profiling.rst
> >> @@ -112,3 +112,10 @@ break it out by rhashtable type.
> >>  
> >>  - Then, use the following form for your allocations:
> >>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> >> +
> >> +Notes
> >> +=====
> >> +
> >> +- When a slab object is allocated from KFENCE, its accounting is skipped.
> >> +  KFENCE allocations are rare and limited to a small number, so this omission
> >> +  is negligible.
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0337e60db5ac..76acb78f2655 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
> >>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
> >>  						       slab_exts, offs);
> >>  
> >> +		if (is_kfence_address(obj)) {
> >> +			put_slab_obj_exts(slab_exts);
> >> +			return;
> >> +		}
> >> +
> >>  		if (unlikely(is_codetag_empty(&ext->ref))) {
> >>  			put_slab_obj_exts(slab_exts);
> >>  			return;
> >> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
> >>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
> >>  		return;
> >>  
> >> +	if (is_kfence_address(object))
> >> +		return;
> >> +
> >>  	slab = virt_to_slab(object);
> >>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
> >>  	/*
> >> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
> >>  	for (i = 0; i < objects; i++) {
> >>  		unsigned int off = obj_to_index(s, slab, p[i]);
> > 
> > I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
> > maybe we could use:
> > 
> > if (is_kfence_address(p[i]))
> > 	continue;
> > off = __obj_to_index(cache, slab_address(slab), obj);
> 
> Hm it would work, but go away after patch 5/13 anyway, so will leave as is.

make sense!

> Thanks!
> 
> >>  
> >> +		if (is_kfence_address(p[i]))
> >> +			continue;
> >> +
> >>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
> >>  	}
> >>  	put_slab_obj_exts(obj_exts);
> >> 
> >> -- 
> >> 2.55.0
> >> 
> > 
> 

-- 
Thanks,
Hao

