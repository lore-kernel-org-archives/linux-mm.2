Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D518D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814A16B0088; Mon, 22 Dec 2025 01:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0416B0089; Mon, 22 Dec 2025 01:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE7F6B008A; Mon, 22 Dec 2025 01:28:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2966B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:28:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEA881A0A2F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:28:20 +0000 (UTC)
X-FDA: 84246127560.08.96A63CB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 119961C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:28:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LbWXYEih;
	spf=pass (imf21.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766384899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EKpn0ruXbR1ixKSQLE2aTtzbC9UbYbxiiPAEQF07BY=;
	b=3ocmX/LjX1PeR+fSJXaoQOtJqb52ds6rsC5+wmZistpyS70uqHco38oQRixZpVdDqrKpVS
	iBbOXSDbFV9d0tch0TRRrVDvYR5tGN71XhRADk7q+FlO2Ja7vNhLInTIOM706kcW56LDyV
	z639CyjKMJAdeewoDKzFBY5IqJ5Gpfc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LbWXYEih;
	spf=pass (imf21.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766384899; a=rsa-sha256;
	cv=none;
	b=xNE33XlNWtD06Wx74HjHAggEEKcQu/MAgI1RCOi/5OVJl1+eMt4soWu4WTdffSLHXCPuTT
	QvKp+9e2H4sKJhd2cqUJEBDRzdiutDtsqGoOhvy64Jz3KT+ymT6NkKNYpzf1vFEbWk0MUH
	KnNnKqbLpACN5gSEhoQn/Uz1B4XOFJM=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0d06cfa93so421035ad.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766384898; x=1766989698; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6EKpn0ruXbR1ixKSQLE2aTtzbC9UbYbxiiPAEQF07BY=;
        b=LbWXYEih/O9khgsj8is3cG6ApSVj7OiGIRC0JIL9Y9dAH+VE+R7MPfPvGPiTZX/UD0
         5nnmms1EqDbOuTgSPCkuQ4S3hL3mgK67Fb/qBvHoZzTbbhJJT6/vOHGnSkSey4oDPy98
         NA6Phap+JjYKSJU9IvutZTBN1sVjVLrAAvlvOZ3J5jsiR5lgqW4S+yH3107GkpJ7Y4Pe
         2t8NM+ckFQllAHQPBwmAOesMngp5pkfn1BlE1wQ/bAngC3cIm8y/1mc/B54/S+tWqOxK
         A0M1cEhjO+k5mG1FbOkYlrpUCB6sR94w2BvsD7llCoxBIP+Yc49wtf2IhHIP5hMK2g5q
         mVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766384898; x=1766989698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EKpn0ruXbR1ixKSQLE2aTtzbC9UbYbxiiPAEQF07BY=;
        b=pMTA1Fr4/Spo7atWwzmlc89PLegk7/bkrDXwFDZEQSJZ5RyhrRw6nUmOjtYNwkhdt+
         jOM205PrmMnHtQQzv1kCtqxaPJ2VzOJrgEIu2Y2j6VUIK7I2HhUdiMTPSdrycLZ3mO1d
         t4WnEjLBpWLR8/lLkgmSnphDm1RcHS7I6/edlVcgsUMHRs9oKuTnZ6lk2KAsRmppkzxu
         GDfvFt3R4OMTTXkJ8fiFRlTPnHjQekF6quqEa1Z+ak05hCe3ePZYarJ/ity7BDfkhkln
         70LXCMClY6UfZzC8nPcjl6J2hYH99Qa9cYcdFR9V/IbrbV2w66tqAM5WG5scdgTmgkfi
         rOhA==
X-Gm-Message-State: AOJu0YyU8LjG1otukuss56WbM8t1Ze1/GRkBGltbowq90AZa9dyHZDxU
	jIw045AaYSm2rKEXnSCi0o9+P/IaF1riaFK+0u+ZeKeZhnmozDg2JZBCztaxeKXhJg==
X-Gm-Gg: AY/fxX4g/kz8y08LnbHoO90ejwqVwxhra7fqwi9l+WdbJbbebVrCjKgSYOEFQgi4QcY
	bQT5Zj55H2/obNGeyoq+scwW07YOsLp54g/a9wR8lbSw+/SExxWhoJ4tFfU+0CxseoceEG9ZUxu
	8N+kU8HAgtOvw3nKbNQu+z9uoL1RVZGA2JdBLkGgiD1Y0T8iDSrVMwlATBLn/BnXJgXEL9Rp7jc
	CvOVu8nzdTQL95woZI23urZCethLg79C4o/wxXvT27J320ohYgFv6itjslKJt58j/0QN9QHdLFV
	chHD90hRgNFdhN7KEQ28D83/8S7TsmHKh3wBc+LARVsl3e/ozG5H7hsXk7/AynNafKU+2RrmDlS
	Ln0bBxUaqDbu0ZF2aRyWPp1Rz7vxPjpeIz1pWHY7KMYJljP/qHrXD6XwDA5J0COMYiFJYx9BpVm
	S7AE3Y+tRv/Zgilto2KSO/4wMw6NXySrjgpwroBb1nXY/xd/X+eoja
X-Google-Smtp-Source: AGHT+IFzv/vr/XRa0szzJkljXT5iZKXsyKh/D3x+u69v9tdyxLoWzWyh+4/PEsydGYsKr59SAc9kkQ==
X-Received: by 2002:a17:903:144f:b0:2a0:867c:60e2 with SMTP id d9443c01a7336-2a3142c9dd6mr3031535ad.19.1766384897424;
        Sun, 21 Dec 2025 22:28:17 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d428sm85337225ad.73.2025.12.21.22.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 22:28:16 -0800 (PST)
Date: Mon, 22 Dec 2025 06:28:11 +0000
From: Bing Jiao <bingjiao@google.com>
To: Gregory Price <gourry@gourry.net>
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
Message-ID: <aUjk-yVw8ddRgZyN@google.com>
References: <20251220061022.2726028-1-bingjiao@google.com>
 <aUfi9gn5HS4u4ShU@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUfi9gn5HS4u4ShU@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 119961C000A
X-Stat-Signature: 7k9uxzh3wisneu9zgnj6f74ukfe7e19n
X-Rspam-User: 
X-HE-Tag: 1766384898-843791
X-HE-Meta: U2FsdGVkX18C2tRDrjRSW4GfsGzn3OoC/jMn5iGryRLfzpRdcjguPkpLeflF2PuzaaCTU7lYCkyIsTciM8jOya8IfuJcmEaTMzcQocjBn/DCwC2NlAg5gGy3xua8v0fn3W6DX3rBRXBcx5Dv+ZrUv3IZCTuNR97eFEK4oR26N4fTJ2KNZxLgfMvvOV2fSyr/i+6YtRvFh2kNxc4AnKkd1dzRwZeXuwEuHcqPBMn7EMa6rwiq9eiC7ijnMjmsElEIkNK0hyM7eJD+0aD+OZlnRgStIRTi1Aj4ZSMGJnzC2ZfTfyP+hm7IXPXJSbLluTHW6XGlFQsD08Ts0QgfEXRXyfjOed4zCNS4Y7JyPyNpATsAoFAURXspz4xBYLSe376dvIkB+G1O8LMbOsPRoT20zN8S9fXhvjR/7bKJ2ZNxazwsh+TTNDSPZY7eIZ6j9oOJh7xW0HxxcHoaRIgXOfdq32tCglQX/kBL3B+sAHtJ0p5+gK2TShWgVBq0PpbYGKNZDLoEQqUn0haL7hvALX/nB/tG499HJYcLs/fq4+aRQqfMoYb+WU/ImW1VgIh7GoSCP3/T2fJuh2uDyDiy/ish04gzaSA/rbKIC1sZWFdHPuB+hTCJok4GMMBTGhU5n8E10OEX+VHGpYBrW9LSqFeVfF0eotwXLqlIg8z5umVrXTjfe+7YlVxD18cc3cs2fCmWvf/Cz9F7ByC2T9bYAk13VaeYrzDHMm/rbKP3MuCVMro8RaokTRBTvbksonjtLNBI3nnLyXjzyJ7kG+QyvrRCqWB3hw0R60hLIYm7UFnXOxzIMR+4IKDIl5n7/yWTkAva3TFJWyQqep2gsDVRxLtO5z4I41QLBJTpOgp4JIgrYo6gDMYIPz6wS/tTne4Hho52hbbwJ28k0uMdn+7vgczKpfNBtKzi0zNHPHTv6I37NcYyqyxiFgxGzrFzGZX5v/DiEFvfRqNnoua6lFh8kMw
 m0joFEcQ
 cJorTanLz/0mvAb8ve+TI7G5NVlU5PyGP+Cz2XyhqgB3KRqC7+ntwFT3ViU/e91SBagUmvdFp9Z6/gv9eNYlpFQSvQJ6j+JbJ4qzFaoZNNB5+0SNkDJ0vS6k6lnZ1Pgt0GCKLG7ndmh4aeUY/RuJlD+niEkNPuWr5xIxkKM9qBg+ye8MkpcB3yyfXZmKBjWQeg5/UWPZ+ybIiOPTMOb7yKfr9F2A4RUPPDneWK0bUbWaLFvAUtz/s817HqVQF8CrHvjH+5Ul86qfQzgxcwnCSCeUhrgDrtMwTnlSfk0OstncRqFBdAMaEK8SAY+6UxL78VYt5Sj0jFNLFIZYEhCqn3VmCUIav8J48i237CViErp5CXp9rRdU54WoN283zgPnrjpj9Yb8j9Ji/D1ilYjf1bZe0O480jniYIo/N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 07:07:18AM -0500, Gregory Price wrote:
>
> I think this patch can be done without as many changes as proposed here.
>
> > -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
> > +void mem_cgroup_node_allowed(struct mem_cgroup *memcg, nodemask_t *nodes);
>
> > -static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> > +static inline void mem_cgroup_node_allowed(struct mem_cgroup *memcg,
>
> > -int next_demotion_node(int node);
> > +int next_demotion_node(int node, nodemask_t *mask);
>
> > -bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> > +void cpuset_node_allowed(struct cgroup *cgroup, nodemask_t *nodes)
>
> These are some fairly major contract changes, and the names don't make
> much sense as a result.
>
> Would be better to just make something like
>
> /* Filter the given nmask based on cpuset.mems.allowed */
> mem_cgroup_filter_mems_allowed(memg, nmask);
>
> (or some other, better name)
>
> separate of the existing interfaces, and operate on one scratch-mask if
> possible.
>

Hi Gregory, thank you for the review and suggestions.

I have divided these changes into 2 patches based on your suggestions.
Since mem_cgroup_node_allowed() and cpuset_node_allowed() are dangling,
they are removed in v2 2/2.

> > +static int get_demotion_targets(nodemask_t *targets, struct pglist_data *pgdat,
> > +				struct mem_cgroup *memcg)
> > +{
> > +	nodemask_t allowed_mask;
> > +	nodemask_t preferred_mask;
> > +	int preferred_node;
> > +
> > +	if (!pgdat)
> > +		return NUMA_NO_NODE;
> > +
> > +	preferred_node = next_demotion_node(pgdat->node_id, &preferred_mask);
> > +	if (preferred_node == NUMA_NO_NODE)
> > +		return NUMA_NO_NODE;
> > +
> > +	node_get_allowed_targets(pgdat, &allowed_mask);
> > +	mem_cgroup_node_allowed(memcg, &allowed_mask);
> > +	if (nodes_empty(allowed_mask))
> > +		return NUMA_NO_NODE;
> > +
> > +	if (targets)
> > +		nodes_copy(*targets, allowed_mask);
> > +
> > +	do {
> > +		if (node_isset(preferred_node, allowed_mask))
> > +			return preferred_node;
> > +
> > +		nodes_and(preferred_mask, preferred_mask, allowed_mask);
> > +		if (!nodes_empty(preferred_mask))
> > +			return node_random(&preferred_mask);
> > +
> > +		/*
> > +		 * Hop to the next tier of preferred nodes. Even if
> > +		 * preferred_node is not set in allowed_mask, still can use it
> > +		 * to query the nest-best demotion nodes.
> > +		 */
> > +		preferred_node = next_demotion_node(preferred_node,
> > +						    &preferred_mask);
> > +	} while (preferred_node != NUMA_NO_NODE);
> > +
>
> What you're implementing here is effectively a new feature - allowing
> demotion to jump nodes rather than just target the next demotion node.
>
> This is nice, but it should be a separate patch proposal (I think Andrew
> said something as much already) - not as part of a fix.
>

Thanks for the suggestion.

I sent a v2 patch series for fixes and backport. This function (jump
node) will be sent in another thread for distinguishing between fixes
and features.

> > +	/*
> > +	 * Should not reach here, as a non-empty allowed_mask ensures
> > +	 * there must have a target node for demotion.
>
> Does it? What if preferred_node is online when calling
> next_demotion_node(), but then is offline when
> node_get_allowed_targets() is called?
>
>
> > +	 * Otherwise, it suggests something wrong in node_demotion[]->preferred,
> > +	 * where the same-tier nodes have different preferred targets.
> > +	 * E.g., if node 0 identifies both nodes 2 and 3 as preferred targets,
> > +	 * but nodes 2 and 3 themselves have different preferred nodes.
> > +	 */
> > +	WARN_ON_ONCE(1);
> > +	return node_random(&allowed_mask);
>
> Just returning a random allowed node seems like an objectively poor
> result and we should just not demote if we reach this condition. It
> likesly means hotplug was happening and node states changed.
>
> > @@ -1041,10 +1090,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
> >  	if (list_empty(demote_folios))
> >  		return 0;
> >
> > +	target_nid = get_demotion_targets(&allowed_mask, pgdat, memcg);
> >  	if (target_nid == NUMA_NO_NODE)
> >  		return 0;
> > -
> > -	node_get_allowed_targets(pgdat, &allowed_mask);
>
> in the immediate fixup patch, it seems more expedient to just add the
> function i described above
>
> /* Filter the given nmask based on cpuset.mems.allowed */
> mem_cgroup_filter_mems_allowed(memg, nmask);
>
> and then add that immediate after the node_get_allowed_targets() call.
>
> Then come back around afterwards to add the tier/node-skip functionality
> from above in a separate feature patch.
>
> ~Gregory
>

Thanks for the hit. I had never considered hot-swapping before.

> ---
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..1971a8d9475b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1046,6 +1046,11 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>
>         node_get_allowed_targets(pgdat, &allowed_mask);
>
> +       /* Filter based on mems_allowed, fail if the result is empty */
> +       mem_cgroup_filter_nodemask(memcg, &allowed_mask);
> +       if (nodes_empty(allowed_mask))
> +               return 0;
> +
>         /* Demotion ignores all cpuset and mempolicy settings */
>         migrate_pages(demote_folios, alloc_demote_folio, NULL,
>                       (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
>
>

Thanks for the code. My v2 1/2 is based on your suggestion with
some changes.

Best,
Bing

