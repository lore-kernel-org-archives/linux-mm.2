Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD416C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 20:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B300E6B00B5; Fri,  3 Jul 2026 16:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0456B00B6; Fri,  3 Jul 2026 16:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6FE6B00B7; Fri,  3 Jul 2026 16:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717626B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:06:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4DDE1C75B0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:06:17 +0000 (UTC)
X-FDA: 84948547194.12.9CA5F0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3885620002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:06:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1bchi5A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783109176;
	b=r5hq+HC70pekm0+P2iPYGDPfecerbr3USUkUyZ1dwVKbhqrNkMR1ll6zIzJ6EHmPN1TNJr
	KTaW9wFOBcsMBTZqqh6gt+btSkslnxSEorXqBZCT49g2uk9X5Nj/db0KLP+EkKaHii2NMX
	Wx0FEz178yUuLy7vyF7XgQARfKM0zQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783109176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8zf2oenIzK/5sv6TzeAsiMNLr4snDxOKcCQpjzACiw=;
	b=Jl9EZng6lODQw8rrZa7YGvAh2bMYsTASCI89ZgkkW/9l31Q1Odd13jpmFRLMMTjUWxV9rn
	hKaE3DiSuMP5mFSVZrhfctikhm3vVuF8wTLXCiq0fnryYiA07ZQIGPLHlHd+1+s6ctHvn6
	uRlrEJ7uoyKgUeb8TN2OuwPEUytRhPU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1bchi5A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D58242B8B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018071F000E9;
	Fri,  3 Jul 2026 20:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783109175;
	bh=C8zf2oenIzK/5sv6TzeAsiMNLr4snDxOKcCQpjzACiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1bchi5AKR8Omb4EfoMSbv/1fj1Z+Oq8IzB1W6NVyGeehPhOvUPd/fhXjiC9u9FpF
	 cuy0JSYbuvt2qYlHR5iG09086X2oUJ/jMr7fEXACQ1e/MIBPpXDvNTFITTohK/lKrH
	 IsH6EcGeFPiEcxV8MFUF6ikINsDzt9sQhbuOxjJVjSmnZa6cQfcXtUbulKxYhPTPvf
	 NTJWVQSuuVrUY4sa72suD1cA05Svu13wrDCVaxjnlFPKP9H2BlBq6uwtBneEVVKatN
	 3VLhZcnaHBC4oewLz+CEG5mMB22tGVPCn/A+bEwGjKi5JP+XshqxDPytWPJF5XkQ06
	 GYqzFrWbbVwWg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: DAMON Release Newsletter for v7.2-rc1
Date: Fri,  3 Jul 2026 13:06:11 -0700
Message-ID: <20260703200612.102544-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628211904.94361-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3885620002
X-Stat-Signature: 5rp19qai7gp6thzsa4azhpfyin6ewiza
X-Rspam-User: 
X-HE-Tag: 1783109176-897409
X-HE-Meta: U2FsdGVkX18HAxGvNe6M3ZDLIilWJWHdgNZig2Md3xIkcLykbryLDQLcIvaIQ/JkeHJyYzR/FAqJ629ojJqizuk2oRP5Rhgu5txHD/Qh/Bhh0wWu58tdtDJ3JiHUomfk9UW3NLYvUhRHVay42Vt8B7kJMjyPqJQX2QAr7OFxmoCIEGFzMqNHS0AgcJ1mLek6T+lHBser2pdmzdHcddjfOUGhfT/d4T942ztbfff94rgGaFuw/DDGcnGpi58rswqpFHDHGnZh9e6ToQWlLz2qVbQrsupRRC0o5z7//f9l5qcIScvj7cR0Ztzmslfdv10gW/y7/lxc0oQNYpQMs2SORNTVy7X2pboT4NGZeiBTB3/AjzhpqFRe/yAJ69KkT7eOIeF5jeRpxxlyxGaRVvZBJvLhJUUaExiLuQJ0w1SmhKuZ9IagpDTsw8iJB/KhszHXPdSYkDC02xWvETIJfWHdstd/ue7jtvyl8MTXjccXrZurbvUBc//LCwEY15UquGM87y/smKNMA0IW7sreYF+XFKP2SyLl1UVIwOk9nFP4lenm1MV8egcq3L7mrjjDBRzqwSO2a/AXhaCvhg068cFKxN+a8P5RA6bicC9ZzM3ko8pgikkfX3qyJh7C6Xb+Ig+qmaD7nW6ZIU73uGouQ17VRCz6/gJL4pUMpsS3eb1G3XjxXZKbI3+hTcpCsTWcb4I8bFXDXn712a/071dCDi6vLTq0JJuNL6SfP+VkDid4Pmc/nVg3YqFx6QxMLQn2ELMf4LsCqb0wf7BjwU4eTaOJDYrYdobawqQmgUwH6Kj6Ac4hCnrpMH87PnXuhkGPTCKxxN5DBrtrmlR+MM0WuyZSUF0exBv3Ke8m+YiKf4kRiMw7PAmeDwsFQ50vHw+bZbzcz+Ph7vugrGQGJ7Wpapxkv6vqse4CSNd5r5J0xhuvxW1FZnejO8DMQmp9VavyORjnZuupIhvpkykJxyF7LyD
 8gMn4elA
 wV9GWyWquIGd4NBlmvwAVodc/81T1mSRELEWxhVUNkG6emjs8DVEqtS+Qu0ZObol347j9ny30YExUYYPtI9QOPyY2Bv+5rBw3LTeIBk+LfHJr5pKnx+mM8SXis5pEcZauH1+iOYQ7CxXrNsklt1gY/RPt+UvMc4QVsAcvz7UFPYkmCokVdLQtRGbQ9lJ6qW0pUjl06Md/sAWnn/Zm10Zxyy5vmx6GUDWLENUqv0XFDSlSjL4wgB7cSLakMr8/gMOau0M5umGg5lVZufLTsyyMslcA3gIsNKKnv60qdBhCRGSNq04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 14:19:03 -0700 SJ Park <sj@kernel.org> wrote:

> Hello community,
> 
> 
> This newsletter covers DAMON features that landed on the mainline, queued for
> the mainline, development statistics and misc events that were interesting to
> me that happened in v7.1-rc1..v7.2-rc1 time period (2026-04-26..2026-06-28).
> 
> The newsletter covering the previous release cycle (v7.0-rc1..v7.1-rc1) is
> also available [1].
[...]
> Chanegs Landed for 7.2
> ======================
> 
> During the 7.2-rc1 merge window, 95 DAMON patches have landed via the MM pull
> requests [2,3].  Introducing a few of changes that could introduce non-trivial
> user impacts.
> 
> New Features
> ------------
> 
> In the merge window, below user-visible new features are added.
> 
> 1. Commit 9138e27a3bc38: "mm/damon: add node_eligible_mem_bp goal metric"
> 2. Commit c7ec7d5f6b3d1 "mm/damon: introduce DAMOS failed region quota charge
>    ratio"
> 3. Commit 3b9e3cc0405b4 "mm/damon: let DAMON be paused and resumed"
> 4. Commit 70d8797c15d64 "mm/damon/reclaim,lru_sort: monitor all system rams by
>    default"
> 5. Commit 0453f857eb32c "mm/damon/reclaim: support monitoring intervals
>    auto-tuning"
> 6. Commit 3a0bc9568c354 "mm/damon/stat: add kdamond_pid parameter".
> 7. Commit 45c49d9fd6089 "mm/damon: introduce data attributes monitoring".
> 
> Feature 1 is developed by Ravi at Micron, for their auto-tuned dynamic
> DRAM/CXL memory interleaving for memory bandwidth optimization.
> 
> Features 2 and 3 make DAMOS be more deterministically controllable.
> 
> Features 4-6 improves DAMON modules for easier control and more reliable
> operations.
> 
> Feature 7 introduces the data attributes monitoring, which enables light-weight
> page level (e.g., cgroup-aware) access monitoring.  It will also be the
> foundation of the ongoing collaboration project.

Sorry, I forgot mentioning one more important new feature.

Commit 58996503b631 ("mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme
action") is also merged into 7.2-rc1.  It is developed by Asier from Huawei,
for DAMON-based THP collapsing.


Thanks,
SJ

[...]

