Received: from smtp.lore.kernel.org (ip-10-30-226-214.us-west-2.compute.internal [10.30.226.214])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044AC606A324
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CytbvJKg
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2458CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7E46B0290; Mon, 19 Oct 2026 10:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90926B0292; Mon, 19 Oct 2026 10:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBC66B0293; Mon, 19 Oct 2026 10:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 793C56B0290
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:51:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 762AA1A0776
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:51:57 +0000 (UTC)
X-FDA: 85339665474.14.5BA8160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CC6701C0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:51:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CytbvJKg;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEuKHXnppdYbcLdn+ZpMOWRZpyj22L+OaDWKsVYJBU0=;
	b=n9dTywEbBKWYZnz6rKYgbWEm9eBRlD9a//e8Lj5uHzty/LAw9nXd0i6Zc+/YXFF6Rp7iFq
	CQh800OjGAH/4rxV0PyerDrLoOapmWxr5b8CaUT4SXP7N1x3qYGOgYnjoLzTcl1EzdCOKC
	z3xmgfRIEJOeeCR/CpGC3a2mb7U84iY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CytbvJKg;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421515;
	b=IFF9oiFLIorXpZRWJeIRoiKc7PKYOQc0XlJiIrAD2bzdO410yAfw3wdsRpGLf5UeLcptzo
	33vY3oVd/c1QcQpOnwinUTeqJvVu1XTnvQ23hHQtNaQQ1T2HN9cjDhaKvAKxxdJadVymFw
	+/SUDodtAfvYscMHNWjWvrdqMyMgWq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AA89601FD;
	Mon, 19 Oct 2026 14:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C11F000C4;
	Mon, 19 Oct 2026 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421514;
	bh=IEuKHXnppdYbcLdn+ZpMOWRZpyj22L+OaDWKsVYJBU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CytbvJKgpdduswBwk1KzlfJSnpKOX7ypQXzLh7ah9RHTacFvwlL0K9eu+Xt5w8eS9
	 5yEze4BmXOXsrukOsydZtO2HZK+HD9K8r6f34WpmEAColF8mZQR4TAQ7pisWqDLakM
	 jCx7a6dbOPMec+ZyLbiAkRvRtkMhdP8kQaJpvOVBDrwmi9ff4npyXzVToSZ9r6OX5a
	 mDmwePbsqtTbIX8Pykf7QvN48xBhV51ByiKkLXgWGOz8ZOYGaqTlPdUnB9WfjqqZ4i
	 mysUbn+eqHr6lc2ERj3DgEyYW1UfLSsZVon1Ht0CKOH4rTDb1G4RTgePzgSDmbu4cV
	 +jA1W37dt0AsQ==
Date: Mon, 19 Oct 2026 15:51:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
	ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, mhocko@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 1/2] mm: add source selector to memory.reclaim
Message-ID: <atYsvc9gIejcuwew@gremlin>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <20261019141401.11927-2-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019141401.11927-2-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC6701C0007
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qkj1wtppr3pr1ypbs7aozrh4cwb35gs6
X-HE-Tag: 1792421515-217568
X-HE-Meta: U2FsdGVkX19HlH5u+EVr6+K3hUNGNB54HGbIfM8FBr88bT4mh139sNB5gpznrg0YLpR5HxrqwOqC6go8+wfwZNwUaB9HghS8+JqVamVpb3k/v7pASe2SQzHtWKIboDLEX/iMWzqqfFErrDeBtADee9KELIS2nzcbshe8bTGSC1tf/rauXWA6tkyK+FrJeEM/Q1UcGMcn1eDXsR3Tl2PEWYieC5WFJjhYOF5evNkFEWkj4k7ZWlf91NPa66BeORpF+YFlV9Valf3wc5CahUvAUZA9IumjpmF7zvcMOITeBtsbXADDpSjMvl1b9u373oFKp/N9qhS2IlIW9NsYYmNAKOahwk0Ft16Duf/2DbVaFD4AFOxSkT7g2D+VoJdOBtiYjKNQxiPO+bMvQQ14H0AMzItP3rQtx+OeKUvEchSnP9dyI+NP7ZuPhHJGlH06ncKpFx9f8Tr9cB/t4sRv5E46ZbOLoBfbckJ5F5l0A6ujPkiYM514dANdDw+3lAQFu/MLZZbv9XveJXTcbAy1zM0jJ7bsIxjYWWpsBoTKHoc2RaWywogh37sWZqaWjn4YsKMLwqGNPUdOyfUQfqFq5LtYVeSPQQOQoNO3zCWbnF4U4Ga6yXkjbeJq7DDejK60xGMClqmxV+xWYo1YQDwWuVDBrkfuRa7G7HUI4I6NrXOlvsWKUopiAmWSm2ueTEhEQhIP7XspwKdHzCpBgMM0w0T5zzcRK23ycuv2KbQUUQpd8XHqtCHKsD9OxN9j7ir6ELRxSWZoSqRfb0G6OiPLje3XbCnF41kJoKjOZALi3RrCayxJs/N7PNFE8+GtvU+iibdtRQeLrsmbM9t8Ci5K+wNCVdakIOVpIk7QEGIes0S9JmUAyAZBAdJv9GB1f8knGYjrSuWske3Sljtu5PsslFH5C9xFnP0FFvyxEdLw2VyxmGC4mwXMq6ns2vgpg8DM7+S2w/CCKvAslSre1oycq46
 /B3J3Hs5
 ENHO9h0Ws+oReEmaF3dAYkIemKZAHuxVFopOtdQCSe/4lzxdfqtxcg/4/ZcOlVYIYfnrDPFV4QPAU8oHH9cePZgSAChpsv+ZdiitmNsQrIk3alMbP5Yzer1QwJYzrO1UF4omN8EvpZuz2+UYZEfcK+qjwq7t8VMtALY+e1Snc9V2XSKN7zX3dMiZz7brsvaquhgSxnLA1q9PibqwMJ+KaIqBgZTFve4Odyky4wYHLA0PHWm3qA9rSZuq6W/xDSimRIn8lctcyhsU1KBMM0ofI1le1j4FsBES1eLq4Q6b3QD3mA8Tize71KC2eCbPchCM69O+QSHZcwm56ggE8PvXIDh1fQMJ3wwsVXYhtMLpvPjiik5puAgPMHpJ+YYt38aJhp2JS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 10:14:00PM +0800, Li Zhe wrote:
> memory.reclaim was added as a generic proactive reclaim
> interface for memcgs, but memory tiering makes its practical
...
> The source= key is intentionally typed so future selectors can be
> added without reinterpreting the nodes form. For example, later
> patches may add source=tier:<selector> or other source types while
> keeping source=nodes:<nodelist> as the NUMA-node source selector.

Similar comment for the commit message as below re: simplicity.

>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 23 ++++++++++++
>  mm/internal.h                           |  3 +-
>  mm/memcontrol-v1.c                      |  6 ++--
>  mm/memcontrol.c                         | 11 +++---
>  mm/vmscan.c                             | 48 +++++++++++++++++++++++--
>  5 files changed, 81 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 86a2a0099178..a016575010ba 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1454,6 +1454,7 @@ The following nested keys are defined.
>
>  	  ==========            ================================
>  	  swappiness            Swappiness value to reclaim with
> +	  source                Source to apply reclaim pressure to
>  	  ==========            ================================
>
>  	Specifying a swappiness value instructs the kernel to perform
> @@ -1464,6 +1465,28 @@ The following nested keys are defined.
>  	The valid range for swappiness is [0-200, max], setting
>  	swappiness=max exclusively reclaims anonymous memory.
>
> +	The source key declares where the normal reclaim aging pipeline is
> +	applied. It is a typed selector in the form source=<type>:<selector>.
> +	Currently only source=nodes:<nodelist> is supported. For example::
> +
> +	  echo "1G source=nodes:0-1" > memory.reclaim
> +
> +	This instructs the kernel to apply reclaim pressure to memory of target
> +	cgroup that are currently resident on nodes 0 and 1. Reclaim then
> +	follows the normal reclaim path for selected folios. The source
> +	selector does not choose a demotion or eviction policy. On tiered
> +	memory systems, a source node in a non-terminal tier will usually make
> +	progress through demotion when an allowed demotion target exists. A
> +	source node in the terminal tier has no demotion target, so successful
> +	reclaim progress from that source is eviction.
> +
> +	The source selector is a source constraint only. It does not select or
> +	limit demotion targets; those are still chosen by the kernel's memory
> +	tier demotion policy. Specifying source does not change reclaim
> +	completion accounting. On tiered memory systems, completion may include
> +	demotion progress that moves folios away from the selected source nodes
> +	without reducing memory.current.
> +

I'm no cgroup expert so I can't really comment on the concept overall, but can I
ask please that you try to make this documentation FAR simpler and clearer?

I have no idea what an 'aging pipeline' is, then the paragraphs dive into
significant detail and I don't see why you would want this or what it's useful
for?

You should lead with that, and keep things simple, only introducing detail
later.

Right now it's 'types:selector' (only 1 trivial example given) -> reclaim
follows 'normal' path (what is 'normal'?) -> for selected folios (who selects
them? How is it relevant to _an admin_?) -> source selector (what?) does NOT
choose a demotion/eviction policy (neither defined in document) -> source node
in non-terminal etc. etc.

It's very typical of LLM-generated text - it treats the reader as a computer
with a large mental 'stack' for storing this information.

Humans don't work that way.

The document targets _admins_ and this text strikes me as very very confusing
for kernel developers, let alone admins.

It also seems to assume a lot of knowledge.

--
Cheers, Lorenzo

