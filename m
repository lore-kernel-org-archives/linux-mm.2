Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B59D49C97
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 23:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2447E6B0088; Fri, 30 Jan 2026 18:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F21E6B0089; Fri, 30 Jan 2026 18:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D45C6B008A; Fri, 30 Jan 2026 18:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDF7F6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:35:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84383140378
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:35:40 +0000 (UTC)
X-FDA: 84390239640.28.9E05F27
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C643120003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:35:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1Dza28U;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769816137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gn7Q0rUz55te6YHyK/yjpPJr74GIFvZD19IJz+ORIro=;
	b=R/sF+ZC4oxdV31A4zq7o9fp1EGqnydIVYIJIQ935MdmRSJbMNfNRFfBZCx2jVWxBOyzrG8
	HRR5CjKV9P5o/i7SKhsTx9eb+lIn3+864AN76+3X0d/g0gPvhkXxcInL60uMkHoSp6keZE
	R9vMyiUIcrlLa6/sx4TAvFBkljs/4es=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1Dza28U;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769816137; a=rsa-sha256;
	cv=none;
	b=sbMCDzUm/rBhtNakSxnAzEQM0DfYRwDGT7JC8TVIcwOxVfAZ/ooShWlcau/bvYLGIOwbYa
	fCUA2OSsb/wrGFWaOzwcqWxuyZd6hlVIxXQEazmpMFfkJZ/KLedHzoL+sWkcn7JN7RofS5
	l7RKrUAhNyt91NqKdQCPo8fq3E1KZ/I=
Date: Fri, 30 Jan 2026 15:35:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769816133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gn7Q0rUz55te6YHyK/yjpPJr74GIFvZD19IJz+ORIro=;
	b=X1Dza28UzfqXP3kwVJyhdYf7rx3FSQwEP5EJ+43zoCMDzSJ1HCpq+x7n5srwyelv8lfCto
	ntgFhpg7JnzNF1DVpw0iGJdTat+m796ZdymJ8gjZE87xPHnv9d//tiyBdqYpRoARez2MHt
	l0EhKVp6CM1XGbRezlroUnePeH13fM8=
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
Subject: Re: [PATCH v9 0/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aXlY04m0FuX-9LRE@linux.dev>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114205305.2869796-1-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C643120003
X-Stat-Signature: 5asgghcbcqx9ayw7463ue3z9mcimcefd
X-Rspam-User: 
X-HE-Tag: 1769816136-108078
X-HE-Meta: U2FsdGVkX1+Qmsn0A5m0fq2J/QJmQIMJpFCiMxDbJ+skSbnoX1e2pmtSNHiDRA4xRWFaoJiZ7vQ69Qc5VdI18QzeFheINOQg7d4m5kLhF7wH3Mw4IdZk0JzRMzNebzBsx3sraN05DweoVKkzOwXGwRA126d7yG2Hd05gmBWVycyOS4anBWCwcGk56OQ/7BSG9tF4LDdXg+gK8Pys3GBrj1i8mslO0xDVq2dYTihxfqPMFWjPqVbeoUAWR2Fk8iJAhaLFD7858igTycKS5sCZIpg+63esb5Qc48QUQnflLRSeVnxA8OX1VwT+Gkq9ZLoxcMLVnz2SQQY+n14YFhE4UXDOzCy3fHRRwFQFZCM3XHULg6hYv/gS2xR3sla8s93RD7hfXAUdbjWk7FngVh8FzZFO1/xPKYWutrumLHY+tAtmHMFcyAVHY1JlNoXWEc2XkK6ebutKRhVvKBsiLTG6IGvcTVKb8jxXnkPFB4DN6Jkes1T/rguwc6AnPI2puIzAY5XD8jwI8Q57lYsmo1+C6u9ppSSt3F9weI/See4ns8ZFT+N60Aao+SvX84iX6hWsBRWMiTEDpqhJ7ZklKjtQPy9+DUZEbh6YyKRp9itHgwKuPe0CUpKEl+M+FU3IyGMYsa5IrrWyxHIIIjbwrw5DD2UhxxOC/o4i0vyYSmPAsjXJJhCMDDdCPaAv94MRXHRbPuoYM4COKTsNA+K8dxJ2D+M005k2UIv6XyjFiLmhKNegU1RayZ3itw9+ux8bAergRoCRJQtNNqCIG0cUn9OQ45U0Y1A2HRlNJGZ07b7Nj53XeS0vt60TKmN1shtl/RR3me1F7mjSKbOBnhx1/Si1nE7aFQHyEv07bs1j1P26zg5Y8Fr1a6g6Stuk1kxldpbvwUKQGyqY/FOVaeCqw39GcmBJGV+66uPYWT9dSSMjke+ATC6IvKGBGO5N7RYTY0eM7UQiG75UZmwCDRPuQu0
 EJlKVUUv
 9bbD7x3D5JiPfQSelTtfWYxpKbOJvZNlogqVWCQjJPspI1Fk8pl3+MqkBYQXfSLScrYBAHxvWqEhuYQbpf+aXdHXdMRXMMMV/wDF4H2qZvc/WUmlQcpJPU06Tw+LPLpXmQnXmJ8q02Ftlu8OlA4+nBmMIXsapRC/WP0cKMmNYqcx4PAPFsipD7liZmHANtvbd+EbJnJLs1RLP4VrTWGMFRhh17ETkHU7mg0IQyHHpO45AFZmUOXKPXEOtwUOlIdjS/hwTREVn6kTcZYG28A1FqFh6lNSQF84FlB1N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bing,

Please don't reply (i.e. use In-Reply-To) to older revision of your
series. Send each revision independently.

On Wed, Jan 14, 2026 at 08:53:01PM +0000, Bing Jiao wrote:
> This patch series addresses two issues in demote_folio_list(),
> can_demote(), and next_demotion_node() in reclaim/demotion.
> 
> 1. demote_folio_list() and can_demote() do not correctly check demotion
>    target against cpuset.mems_effective, which will cause (a) pages are
>    demoted

pages to be demoted

> to not-allowed nodes and (b) pages are failed to demote

page fail to demote

> even
>    if the system still have allowed demotion nodes.
> 
>    Patch 1 fixes this bug by update 

updating

> cpuset_node_allowed() and
>    mem_cgroup_node_allowed() to return effective_mems, allowing directly
>    logic-and operation against demotion targets.
> 
> 2. next_demotion_node() returns a preferred demotion target, but it does

does or does not?

>    check the node against allowed nodes.
> 
>    Patch 2 ensures that next_demotion_node() filters against the allowed
>    node mask and selects the closest demotion target to the source node.
> 

