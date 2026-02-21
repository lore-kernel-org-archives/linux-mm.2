Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEF4E9A049
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 03:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B106B0005; Fri, 20 Feb 2026 22:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9556B0089; Fri, 20 Feb 2026 22:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD56B6B008A; Fri, 20 Feb 2026 22:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95EE86B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:47:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF9051B4903
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:47:38 +0000 (UTC)
X-FDA: 84467079396.28.D868C04
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 33FF6140008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:47:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IsdIOkHD;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771645657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuMmWrrU7DN9Q7XpFeBJRP8IQvD5uyT25oReQrsl0WM=;
	b=6YgkSFShqbN7iJaiRQ0o7+3hFttBYGOvdSZ7wtUFZpP4HfjT/fCvTSkMmBJTqHgQB2/t6f
	N4RzLixPL4IXvcQgOKPl3Dr7+BwX+3ZHjDhkibBTzuPLlqeY7pbha6ijjFx7vZuv0k+Ykl
	l7EtJmb6tErZ1elQObHPtrnX5hnKPMQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IsdIOkHD;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771645657; a=rsa-sha256;
	cv=none;
	b=03hX2XItgz8wmrYuNV9iS7nKMJuSCJ8ikCZ+APQEgRl2vo19YhoOV6E5czAPGiQvjSnsNQ
	tBINYQ3W9ZZSNtIXh1u5+TOcFsKD1wISRjG+M/rqyJTgXGKC1jx0tyZuiwTwyphJelevJO
	WZUMXtc5jI/oem54E6f3GnIQd0irdyc=
Date: Fri, 20 Feb 2026 19:47:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771645654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QuMmWrrU7DN9Q7XpFeBJRP8IQvD5uyT25oReQrsl0WM=;
	b=IsdIOkHDo8HzkM6jXCgBc6Ei5v4OSdc7ABSoVSieDcAFIsr1B2dKMB0H77YXVaUNmcHrOZ
	vjtDANbX4DIvLndFtjh5Te+FxP+Wq51HQoyFkCcOUBXe40FZos52KmVgX+JkbHxBGovLwF
	ZPRmvmQwTTrWmfWr5P9iWHTTfWUqQMk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aZjxP2sTavBRGC1l@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 33FF6140008
X-Stat-Signature: oasssy4rurbbx1jhyozfc7noccpuuows
X-HE-Tag: 1771645656-628532
X-HE-Meta: U2FsdGVkX1/Fa34AlkfnUoAQS8vFm3sw+Ey85LfdldEL4A4jhpOdSesw2W0KvN2Sp0QOR+bcO4fATNmMpjZWKQ4bzXR/l0WoxoxDxYvh0RnNVuPu0EVBBfBCZHa8LrDMRP9Q9cHtZ6W1lr9elMEmuX0gmzsQQ59RXS/XI6gYFtYuZBlvZDDaIdvSl3k8jDsJN05e6CY/VqHh68162R9704rWJlHMEkr2BgUPcgolnOBqWfM0lmXzvBzLIsaedj2VCX1SkVvFWooDh8T2j6uy5pI3DFAsJRHh/UpRILrDETVjct1qXZ063+vcIZ1zFQFM2rlIUADNw2op1pphvBNy76uvELk511Kt0T9G9IfmvRv/MS1cVWjaVkfNbKvHEQJKgGcLNibeeHQpNPowb4ZsAnS3QfyfGFWScta0eOs4WT1JQUhWO0tzlH6TkOsWVjnfijGdXDtELPfOv880KKwI7m6ha5MWMI9TF8xoVETvB19n+ai9JsF8jDxlVjENV+YguE9B8AENVg+XgPH0pLVKqxM/SoZ14wM1I/SsZyWKcfTzlaRTwwWw+c8zvi6cGnOtXMWeug4h9yUNsROgfArW8ATSq1q1JOSeqEZ9OftykmnmB8X9IdDOXOqMl59lkZRa1krK/3SeSdz0OcDxarhxm3BqSPVZBtQjXsi5eQuia04XgdtMcRwAahWDebzQr3c1FzqnF/JwnlA7Qc29+wYaMafpnPtUsy4azWcfVpENUclV9HtaEa6U7/2xN+u73Vw5I2cD7pYFh9qbkgA1/szvf11h7D5lN0y/ZkahHSvDIUr76P3Z1mR56QgH0Nz6ER4/tQHMYO7Ojxy1C6XQDWJccEs5QxnLN7DNR+GZGGdxQcfQTkDWwSGilg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please don't send a new version of the series before concluding the discussion
on the previous one.

On Fri, Feb 13, 2026 at 12:58:40PM +0900, YoungJun Park wrote:
> > 
> > One of the LPC feedback you missed is to not add memcg interface for
> > this functionality and explore BPF way instead.
> > 
> > We are normally very conservative to add new interfaces to cgroup.
> > However I am not even convinced that memcg interface is the right way to
> > expose this functionality. Swap is currently global and the idea to
> > limit or assign specific swap devices to specific cgroups makes sense
> > but that is the decision for the job orchestator or node controller.
> > Allowing workloads to pick and choose swap devices do not make sense to
> > me.
> 
> Apologies for overlooking the feedback regarding the BPF approach. Thank you
> for the suggestion.

No need for apologies. These things take time and multiple iterations.

> 
> I agree that using BPF would provide greater flexibility, allowing control not
> just at the memcg level, but also per-process or for complex workloads.
> (As like orchestrator and node controller)

Yes it provides the flexibility but that is not the main reason I am pushing for
it. The reason I want you to first try the BPF approach without introducing any
stable interfaces. Show how swap tiers will be used and configured in production
environment and then we can talk if a stable interface is needed. I am still not
convinced that swap tiers need to be controlled hierarchically and the non-root
should be able to control it.

> 
> However, I am concerned that this level of freedom might introduce logical
> contradictions, particularly regarding cgroup hierarchy semantics.
> 
> For example, BPF might allow a topology that violates hierarchical constraints
> (a concern that was also touched upon during LPC)

Yes BPF provides more power but it is controlled by admin and admin can shoot
their foot in multiple ways.

> 
>   - Group A (Parent): Assigned to SSD1
>   - Group B (Child of A): Assigned to SSD2
> 
> If Group A has a `memory.swap.max` limit, and Group B swaps out to SSD2, it
> creates a consistency issue. Group B consumes Group A's swap quota, but it is
> utilizing a device (SSD2) that is distinct from the Parent's assignment. This
> could lead to situations where the Parent's limit is exhausted by usage on a
> device it effectively doesn't "own" or shouldn't be using.
> 
> One might suggest restricting BPF to strictly adhere to these hierarchical
> constraints.

No need to constraint anything.

Taking a step back, can you describe your use-case a bit more and share
requirements?

You have multiple swap devices of different properties and you want to assign
those swap devices to different workloads. Now couple of questions:

1. If more than one device is assign to a workload, do you want to have
   some kind of ordering between them for the worklod or do you want option to
   have round robin kind of policy?

2. What's the reason to use 'tiers' in the name? Is it similar to memory tiers
   and you want promotion/demotion among the tiers?

3. If a workload has multiple swap devices assigned, can you describe the
   scenario where such workloads need to partition/divide given devices to their
   sub-workloads?

Let's start with these questions. Please note that I want us to not just look at
the current use-case but brainstorm more future use-cases and then come up with
the solution which is more future proof.

thanks,
Shakeel

