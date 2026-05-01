Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F9ECD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF936B008A; Thu, 30 Apr 2026 21:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0D56B008C; Thu, 30 Apr 2026 21:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F776B0092; Thu, 30 Apr 2026 21:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7689F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:42:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BF3212042C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:42:41 +0000 (UTC)
X-FDA: 84717151722.02.C641741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84BAEC0002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:42:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DeR2BoTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777599759; a=rsa-sha256;
	cv=none;
	b=gJYXoa00itOIBVMac5Z5UrGqbe8UzTTq+9LwRYhHGpN0Om+KtWPyFgSNy15JQ36gYFkZir
	ShwWvlOotwA7Ojzk1gcj3w99REiA3VgqHAyO+POQO0R9aN0AiFHDmECtj41gbdczP77v2r
	Ab7zWB0Ab+svNqkBdV27fveOQVPRPsw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DeR2BoTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777599759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAVqYTzv6j7ppdSOvzRQKpmE1Wq/uAr1hxm4IPcrdJA=;
	b=2D4hie9foJOZgpZ3PiBpjfrIGfzRSpqmewwI7VYcCmVIVDSKbgapgsQUG6lBxdsZxUnodC
	gf7nPX1oAyWxLRsnkavrrC+gKgzrzQiQsYihGNm/WngEK4ltIOYhsoDhzmwqYV/v265168
	BUXciwvW5wagIX9esaB1t8DEJPsXk/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD4DF6015B;
	Fri,  1 May 2026 01:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC5FC2BCB3;
	Fri,  1 May 2026 01:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777599758;
	bh=s5Avm2OmpzdNLOwnBT2sIFLcF3ONT0lruv1PFQd8FBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DeR2BoTwVYKieU0M5pjmAwUb/bVDgXlJr4hntEgrSPcBlfF+LITJrVSOc2N9+VRmS
	 ekYnQf+bCmDnsULRliNU29pq8gypvns0TPs06Vh5mnnkUcrtfzxhA8GcBhJV4pIxIC
	 bGC/E4sOA9Rmf3sALlgnTRrMM79+cnjJuhiotZxPE53FEvdyHycwOGPwMAW9sHzdKq
	 88GinW/iJhP6YB6ZFqZQudA6uurILRnAf++59hKcxbNcWrGMQnXTRWbZQQigi4/DAC
	 vZwW2RSR6Pv/Y/1Ct1hJooxdh69EwpD1d9gzzaEy9r08P8mMJm/Wq6hzhqGDyQIaKt
	 gQEkmpv574rQw==
Date: Fri, 1 May 2026 11:42:19 +1000
From: Dave Chinner <dgc@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Daniel Colascione <dancol@dancol.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afQE-2JOzfOm8enM@dread>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260430191809.2142544-1-matthew.brost@intel.com>
X-Stat-Signature: 1zr8r1gmn9iybg1jzqcmy9eu4yiqkc5d
X-Rspam-User: 
X-Rspamd-Queue-Id: 84BAEC0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777599759-283549
X-HE-Meta: U2FsdGVkX18r7o39DN7m4XHrTNnXzKjvBSIcN1OiwGSfq4Z1v/nGj8nGlkDT+IwS1PG1z4OH9Ib/l5w2DLXvO3PHJWM1T7ILGlVDc3qgQ2JQMWB1KcPfmkGBz2nNKe7XRpYBcaccvuUb256yAtsQ/HC9Op5B/IsfQ9iV4Vt98Lg7AXp7CRFIZmk3Zn84Mf5P8bZQN1wqDfnRby38r3VNGd7kixiHXcsJl1WW8s+vPC7EUMCBPreqS1WPTtdwUIXEpuGvgEBm64HOVolhBW+LuOeujA1H7ZyzRqVdezoquKNxbBLiJeyfweAQv0PGWAYXds1La52wIm/dZNnBjLz/5IIRraN79WpaBgBjx69yBUm7h5ZWSwHY94iTQSIFtrXtjAVPbdzV9QqQ+y4Z0NGHHJ9Fz0iNqOeRqNkrHoWyB6qKEfM7sgyzSUFDw28b2IbNL+yyrq8t9paSzgHSnhduGjifudxWp7iTnxn8dId0eZ4KHAOqb4rH1jqEwTw73+LsYydDmF0vv6wJveK519otgsH12N73JJRdz7yGnfii3ZqvVxA0YSjq4lZFfqh5mPofMe98Dn1Simqo++LKQDl5WNvwc7XVjMmwlnGRQh4T9Yo1Zzzn5A+51BjELSFpNZZ3XUETMmYmnfn63pNGHm/Ag6sltTO6RMiMF7jcRWQ1kpOuTWor1Sl8C/ojsVOQ4fv1wDusxytdgLMudMi15quLRDZrXRivy4DYirGXwz/t7EqnVUuH00OaxHmfJG0lxCv4Y/8mr0SW7tglYG22orohVlaYamCjuUf/GLQDyWFUqvcqlHJV1w98tnawOVSVJkVAscEzjYdA/F5/Hb9uKv5hZhdlAff6P+A0GxQSbDRWG9JwSN7DzRAd2E4yrql1NLCIF8Xvc8aDk1tpLj2PcNnuAl0UWt7EnrhPW+l9VdO9UKN4R1OuBe2FLPl4V8rOR7mfxqx/ufNeWO1dnCgqznJ
 rYcDROPq
 wRDHBnf4VLr7o7z4p/sstS26QONvJXC6uQD8KlBSxus5CERtcNBWrD5rPkIqbxR3Y5+xCWg/jot/IcVii4EptBPlDM+fwpGqe4eCRrI6lSZSpZsNvWoNf30PqVs7fCE8cplcaQ6RmzNsVyenIqZQ7YFjdKS1LoA97n3AGKVj7BK+9wxFddg5XOj5QAlgCfM+4JV/9wN3MKf7kGRLdC+cVGqsNgVTvahTlIAMHXUM1K3Wt1Mzs/hvHV+ajo26U8TMH2Z8+/85snA8CZvyuu1AFe0lgbPhZfcmzEEQ37Hr8i1Unab8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 12:18:03PM -0700, Matthew Brost wrote:
> TTM allocations at higher orders can drive Xe into a pathological
> reclaim loop when memory is fragmented:
> 
> kswapd → shrinker → eviction → rebind (exec ioctl) → repeat
> 
> In this state, reclaim is triggered despite substantial free memory,
> but fails to produce contiguous higher-order pages. The Xe shrinker then
> evicts active buffer objects, increasing faulting and rebind activity
> and further feeding the loop. The result is high CPU overhead and poor
> GPU forward progress.
> 
> This issue was first reported in [1] and independently observed
> internally and by Google.
> 
> A simple reproducer is:
> 
> - Boot an iGPU system with mem=8G
> - Launch 10 Chrome tabs running the WebGL aquarium demo
> - Configure each tab with ~5k fish
> 
> Under this workload, ftrace shows a continuous loop of:
> 
> xe_shrinker_scan (kswapd)
> xe_vma_rebind_exec
> 
> Performance degrades significantly, with each tab dropping to ~2 FPS on
> PTL (Ubuntu 24.04).
> 
> At the same time, /proc/buddyinfo shows substantial free memory but no
> higher-order availability. For example, the Normal zone:
> 
> Count: 4063 4595 3455 3400 3139 2762 2293 1655 643 0 0
> 
> This corresponds to ~2.8GB free memory, but no order-9 (2MB) blocks,
> indicating severe fragmentation.
> 
> This series addresses the issue in two ways:
> 
> TTM: Restrict direct reclaim to beneficial_order. Larger allocations
> use __GFP_NORETRY to fail quickly rather than triggering reclaim.

NACK.

As I have said to the people trying to hack around direct reclaim
for high order allocations being costly for the page cache, fix the
problem with direct reclaim. (e.g.
https://lore.kernel.org/linux-xfs/adLlrSZ5oRAa_Hfd@dread/)

We should not be hacking around a problem in the mm infrastructure
by changing allocation context flags every high order allocation 
call site that needs high order allocations. Understand and fix the
infrastructure problem once and for all.

> Xe: Introduce a heuristic in the shrinker to avoid eviction when
> running under kswapd and the system appears memory-rich but
> fragmented.

NACK on architectural grounds.

Custom heuristics in individual shrinkers to decide whether the
should do what the mm subsystem has asked them to do has -always-
been a mistake to allow. The mm subsystem makes the decision on how
much cache shrinkage needs to occur, the shrinkers just do what they
are told to do.

If we have a problem where a workload causes excessive shrinker
reclaim, then we need to address the problem in the infrastructure
because excessive reclaim affects the performance of -all-
subsystems with shrinkable caches, not just the TTM subsystem.

As it is, I can't review what you've actually implemented because
you only cc'd me on a single patch in the series. In future, please
cc me on the whole patchset because shrinkers need to work as a
coherent whole, not just in isolation....

-Dave.
-- 
Dave Chinner
dgc@kernel.org

