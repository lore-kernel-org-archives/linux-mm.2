Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1F7108E1F0
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22816B047D; Thu, 19 Mar 2026 07:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2DE6B047E; Thu, 19 Mar 2026 07:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FB36B047F; Thu, 19 Mar 2026 07:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3646B047D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:27:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DFFCB99D2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:27:59 +0000 (UTC)
X-FDA: 84562588278.07.1D83E84
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4B9D41C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:27:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f/0gIRDK";
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773919677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHg6oeL1L67eEN+OOTKjMfILFxz6m+HpynbYij4jWJY=;
	b=6oaUqfs4l0YpeHeZkSdFVSOYB53ZAY89cbeDdzJZYIpMs+s8cntlPR3VtCk0/UaSvj+ZSy
	Pzw0IaE9Vcv9bNVJvf6refsc3WMVatzTnIK70x8FaKenC15Tbj318HU8sBt7yq9G9bHy0t
	nwXy82fHhhrGcEXKyq/dzs5yINMsULs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f/0gIRDK";
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773919677; a=rsa-sha256;
	cv=none;
	b=qnpoyGZPwlFfEOKG0o2QvFXKYnOrowDHrsU9LzPV2yC28wSCeOFwS4dZAlWuAl37BnhSN2
	ntWkKsDANeyQDGev9M9aBx8YHrJHrkI4wzVmjnhfG8GOoEdmg1zz6YU/QMJwde+nB1Yar0
	zRnR0gPa3T/CePXjtqqCo9NeqOWeBzc=
Date: Thu, 19 Mar 2026 19:27:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773919675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zHg6oeL1L67eEN+OOTKjMfILFxz6m+HpynbYij4jWJY=;
	b=f/0gIRDKYIGFjoBCyhy9k0oBAyFKXTaiP0YEzB/zChPb3R854LS9eegHRQMTKGFBH3W/Wv
	mjiOYqZcGbCQUM6Ra99kfUaXyacjfh2gDQx59QvZYwacby400FXkJg76LSl0pWvbmwY8Cr
	4HOKkfVt2ow6W/LSiCNlIsAjXsSup6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Message-ID: <7uyhaxzup5b4qslhf4wnbv4qlafulvlpbn5mpalvurxrlaolvf@2tltqo2qmrsj>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
 <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
 <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
 <jwlqiygxlch5gq6g3vkwynrpndjwcoxwice2hmvim3tvdfubp4@je5ldr7pa5f6>
 <5d10a43f-15d0-4af5-bacb-9924629066a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d10a43f-15d0-4af5-bacb-9924629066a0@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4B9D41C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: fquqxmqmffc8gap8w7trkou41rijff57
X-Rspam-User: 
X-HE-Tag: 1773919677-873444
X-HE-Meta: U2FsdGVkX19xJYCHKjxOBZF5gJpSvM6u7xgusCAsEVLXuh1h9mD6uMlsEOB9AwrjW5fkVcR+ZwWVSwpSu84QsZqXI1TchmXEn0hMNCBhx5IwD5Of/yS+am6u7eMYMhW64CIXqWGmc9QsRDZaZ34Q8jK3+O3C1rZg5h2klUGuoNAnM752bQX+Hz50Sze7BGYkNQNuY5zlffx2VJWNNQbmy28Ciz0z9xKBwntB7LjCMjpiirvUmsRbIozn26ki4aRmqH9fRXjli5/7gA1QuYyCei2ZlGgg0M/jfSZR9s3QdCB8lru60oi9jMjG0iYuYbnK0whAnrX5Fn+UoKHJljz0/s7EARuslVJqxfYjF/rbr4yNFDVKk4+egMeAuIsAuNTWJ4vran1vgddf5uJ8LlSLxTj8F/LyMUNTynmtZyqkVYlb7LPYpZ7njAwJPMAMcB1c0qLwNOLeqOl9zIdUHg3CI7u4obMOEU2XIXdvS6GYko/WUCoQ4YSY0SB268zvRjUZhWbsWtoMACrrwLXXj10ZkRMQiVlJnmdIOAPkaO/EXlU4aaSev1bWmZPtHtFSAo807b+IcCRu/2iWA5JI1ZB3LPx4WGrs1Tpw3pT1JDuPDcWxHQ/d4knag1Vt4bV4N3q+o+ICes+Qm5I9Yuz70y/cfIuMjuIBHmQuMEPyHi9/DNF2Uf4m4MIxHNqQ5tluJMpu2NMH6cdlGb+HxJrQCTmaYrnvtttjk/Lx/3ldlqApZh3C3e3ijapaVZJa3m+KBX2S05O0M0LABMAIw5C5tcxb80mrKMzDb7nlK7P2gvTsgex3lNbF0kuabnI9lva5EX17BSwEyUK/ltMbZ8cTxGsam6/mfZMPy8BDLBWTQs1+E+kfHhTiEu2bMYPGxnFXcz2EYyALTxGxnTENXRv/an/wU2UabPinWh0msybF/Dk9nhoNMOW45n9hFMU4PelBUlvqgGKPqT38aNK/PxcmqKT
 2hBD5rt1
 TWOgba+zTlXKnVX54H5zTMSgHMkQapgcUDAGDrzi60Kj09M40SbsJiTkPPZZMtHdBsLieHd/Kl4kPpEMFGC4YDspUpxaukmiTqpgW9M78Z+d2hsJW3Ib6utrUb3Lv29+XbkHE+F3ekZ+ydq5373Rjz8Lm1En7DjK4FJmW1yZPKgoLgRqqyVUn5zsmGTvLZ51md6ktMto4dt+rZHZg68JftgehLvxPEHnExxphixUt/SiyQOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:56:09AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/19/26 08:01, Hao Li wrote:
> > On Wed, Mar 18, 2026 at 01:11:58PM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 3/18/26 10:27, Hao Li wrote:
> >> > On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
> >> > 
> >> > I had a somewhat related question here.
> >> > 
> >> > During memory hotplug, we call node_set() on slab_nodes when memory is brought
> >> > online, but we do not seem to call node_clear() when memory is taken offline. I
> >> > was wondering what the reasoning behind this is.
> >> 
> >> Probably nobody took the task the implement the necessary teardown.
> >> 
> >> > That also made me wonder about a related case. If I am understanding this
> >> > correctly, even if all memory of a node has been offlined, slab_nodes would
> >> > still make it appear that the node has memory, even though in reality it no
> >> > longer does. If so, then in patch 3, the condition
> >> > "if (unlikely(!node_isset(numa_node, slab_nodes)))" in can_free_to_pcs() seems
> >> > would cause the object free path to skip sheaves.
> >> 
> >> Maybe the condition should be looking at N_MEMORY then?
> > 
> > Yes, that's what I was thinking too.
> > I feel that, at least for the current patchset, this is probably a reasonable
> > approach.
> 
> Ack.
> 
> >> 
> >> Also ideally we should be using N_NORMAL_MEMORY everywhere for slab_nodes.
> >> Oh we actually did, but give that up in commit 1bf47d4195e45.
> > 
> > Thanks, I hadn't realized that node_clear had actually existed before.
> > 
> >> 
> >> Note in practice full memory offline of a node can only be achieved if it
> >> was all ZONE_MOVABLE and thus no slab allocations ever happened on it. But
> >> if it has only movable memory, it's practically memoryless for slab
> >> purposes.
> > 
> > That's a good point! I just realized that too.
> > 
> >> Maybe the condition should be looking at N_NORMAL_MEMORY then.
> >> That would cover the case when it became offline and also the case when it's
> >> online but with only movable memory?
> > 
> > Exactly, conceptually, N_NORMAL_MEMORY seems more precise than N_MEMORY. I took
> > a quick look through the code, though, and it seems that N_NORMAL_MEMORY hasn't
> > been fully handled in the hotplug code.
> 
> Huh you're right, the hotplug code doesn't seem to set it. How much code
> that we have is broken by that?

This probably needs a bit more digging.

> It seems hotplug doesn't handle it since 2007 in commit 37b07e4163f7
> ("memoryless nodes: fixup uses of node_online_map in generic code"),
> although the initial support in 7ea1530ab3fd ("Memoryless nodes: introduce
> mask of nodes with memory") did set it from hotplug.

Yes, this really is quite an old issue. It looks like we may need to dig
through the git history a bit more carefully.

I'd be happy to dig into it further.

> 
> > Given that, I think it makes sense to use N_MEMORY for now, and then switch to
> > N_NORMAL_MEMORY later once the handling there is improved.
> 
> So I'll do this:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 01ab90bb4622..fb2c5c57bc4e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6029,7 +6029,7 @@ static __always_inline bool can_free_to_pcs(struct
> slab *slab)
>          * point to the closest node as we would on a proper memoryless node
>          * setup.
>          */
> -       if (unlikely(!node_isset(numa_node, slab_nodes)))
> +       if (unlikely(!node_state(numa_node, N_MEMORY)))

Looks good to me.

I've gone through the full series, including the range-diff updates, and the
rest looks good to me.
Feel free to add my rb-tag to three updated patches. Thanks!

Reviewed-by: Hao Li <hao.li@linux.dev>

>                 goto check_pfmemalloc;
>  #endif
> 
> 
> >> 
> >> I don't know if with CONFIG_HAVE_MEMORYLESS_NODES it's possible that
> >> numa_mem_id() (the closest node with memory) would be ZONE_MOVABLE only.
> >> Maybe let's hope not, and not adjust that part?
> >> 
> > 
> > I think that, in the CONFIG_HAVE_MEMORYLESS_NODES=y case, numa_mem_id() ends up
> > calling local_memory_node(), and the NUMA node it returns should be one that
> > can allocate slab memory. So the slab_node == numa_node check seems reasonable
> > to me.
> > 
> > So it seems that the issue being discussed here may only be specific to the
> > CONFIG_HAVE_MEMORYLESS_NODES=n case.
> 
> Great. Thanks!
> 

