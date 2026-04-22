Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4EFF94CB8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348D16B0005; Tue, 21 Apr 2026 20:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F95D6B0088; Tue, 21 Apr 2026 20:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F6A6B0089; Tue, 21 Apr 2026 20:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD056B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:26:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABCFFE6783
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:26:25 +0000 (UTC)
X-FDA: 84684300330.25.54D72CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 190F7A0006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:26:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfWfAYVV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776817584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXgVxfD/6AUQQ5mE9Z24VsUOMQFaFyEdWv4n29/wpGA=;
	b=GP4oT3BM33z6pnN9q6vOr35pkZ0K4rNKeut2Ybps+XnUWVOqB2qUHnK7CVwhgeuyIlQRf9
	VJjDvZX80in2YydCmmruth96P8QlIJU14JjV/9VBXHS/EXmRHWDHbWJNo2ybs4AkJGKdYP
	hgL08AqxvbB4aBe3bNY1XWkoySmufrU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfWfAYVV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776817584; a=rsa-sha256;
	cv=none;
	b=HjLR4k10pe0cbW3HR0jkg+/8zMMvvOUOAWaf22juKWRDxf6AnxquPIWvwHPSuePEwX9Ymo
	S6PjzfWjsE42kX2rwC4TCAaD8+jVozbCM0KWpxMscSCsYqAxe8qgzPj+FVV1b4EKN+Aeux
	s+vbB9F7Le+zM9nYPyOiKstyG6c4VXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F7176001A;
	Wed, 22 Apr 2026 00:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DE9C2BCB0;
	Wed, 22 Apr 2026 00:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776817583;
	bh=jqBAEzAIAkAs5KK0c26HBfL5HhvElj7G2+7Aq7pEawY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfWfAYVV308wNpkitQfHp/i3Vv5ItGGWY2XqHA/y9idxCYm3dPzbSK+1q5SSNH6QK
	 DsOwfy745VLjMiMxHcKCq6uTftlyufiRX44wgFujFSOigdKnuHKMyIYbWJW0dnCZry
	 gJJe6OSYz8y79D39pR0T8X0/y2Zqr0TkD8jmzC2m9WHa2+j0bD/tngildZbAJ4zUlK
	 eM2Hg0B3R5Uch2WC4xDPUI0ZVJS+OwSVimBYSur8g0v7HEu7AFTJMa8N7db6oAY7EC
	 0T/KpkGxdNkaUTu2q/8Lam6bV19HUx2qf8ZYxfd1xFvzAcrzqClGURW5mWc/w1v7Oq
	 DJ/3mdtpqSKhw==
Date: Wed, 22 Apr 2026 00:26:19 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <aegUoOiUbjUAH5aT@google.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 190F7A0006
X-Stat-Signature: beggysxmx6j678f8s4adc5bmfjzhmana
X-HE-Tag: 1776817583-936475
X-HE-Meta: U2FsdGVkX19fWbBdvBEtMT3YKiL/bxpOIFGUgWfxWxgeCiHt0knAa08pX0AeFNJRA2xqFHQV3R6RXHyAt1K3ujdh2twJ5xB/z8ZK9nNal0n9Y8TvUfeeYT2jI++cdg4+moAhz83u8j2AmN/L74te6zMfXJwdXo1/OhxSvXbtbYXaEpA5Kxcv/ZAbSTf9MJ4WtXxDQQOu8S8+P47RK2v0xiCG/axe3Lj3eU2sf4NTM5YKa+Hdl8qF9ufK9XzjTEYFjkmmmW9UXcCO4lzQhtXcQGo9yS1DACstLmI1GFP1crvpKnmNMYlxYWSHD8AqP/GeqMPAG8L+FBkGmDYZWsP4ge9NY9lM2uOl0WS79tKoBTdy17y2sm5Yit4w6s3LTdERgz6rBv9A4u0dbS6YdS/0RKMScUz9vm1gborynczAR5QaaU4uaQjntu/tMEyETxZfG+//gOtyIOE24T1zu/ovWsdNey+5g3q7xVAHuCcXv7yPqRIJ8FDxbH3NjJyRFbSgBg2oVPmHh/E6rCmV0+Sx0BeK+0EXznWAHwSBtV5L7hqsXHKsj3nB7K02IaZAznG5H3ocQG38ZYJXxZ93djpC3A5LDdyq7FTkZEVyd5igamPzS6jm2nUwd3LIizMP9ceP/yR+ZBClj6XIbBtS6CQF+y8omS5Z0vkPNXaBVStUjmGLrX9OSyKI5Ax7KtBQO3TzFw9YqHv1OQyrzunjRQlhdeF96Q1LLjnPBIWbCA263CqPnXQv+plkTtWRQ4bpxDIb/F8SISL3HvXtTPng2pTNFOg8WOrGmUzZlxgF/OFS7308bYmAlsztYIkgJfmI7x4syp+Y1RXOBq2y8eBVHcf2n3LelRmxJhQL6sJzyfGC4/IUbxdznVXVh6kHXM728IwFP818+Y5MpWEU50OXoePdj8pwGm8OFyiEwXFWxP0Fsju3t6RI65b9DsYlakm/zLCr4yvsNNHk+WauZ66k9FO
 mTjozwMv
 GwW4A1ryhDmvJ77eBT9R3rzAKC6CTgWbqNCxrQofbIHlq/pmuDPN6Mws9/W/VVjjEA91KoCCpKNB9L+l6lp51O7wF9ufu0b/q5eJiQrQrv2W5JIMax0Ss8p9W6ytYLkyPik0fHw7LKBd2FWx2AhKcM9L3SeD+lOTXQ/9iUqjnFqAVMubvExKuCt4pVhoEn4HcWhXRs8VWfxvf7+E9nZuQ1ljyiLKcX3ZHOBWuUhDolfTQQksF9r7Ak5eSbToABUxc4WYxwlzamSG8QIL/8o+SInOcvsNY9hxdpBAaBoUW4m++uxnsPOpSo0dHUvaRFDBENmSAegHVu+g17UUvp6YMwgVSr8Z9HBMl55cdejkfnVYBDiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> 
> This patch series is based on 6.19. There are a couple more
> swap-related changes in mainline that I would need to coordinate
> with, but I still want to send this out as an update for the
> regressions reported by Kairui Song in [15]. It's probably easier
> to just build this thing rather than dig through that series of
> emails to get the fix patch :)
> 
> Changelog:
> * v4 -> v5:
>     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
>     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_held(),
>       and use guard(rcu) in vswap_cpu_dead
>       (reported by Peter Zijlstra [17]).
> * v3 -> v4:
>     * Fix poor swap free batching behavior to alleviate a regression
>       (reported by Kairui Song).
>     * Fix assorted kernel build errors reported by kernel test robots
>       in the case of CONFIG_SWAP=n.
> * RFC v2 -> v3:
>     * Implement a cluster-based allocation algorithm for virtual swap
>       slots, inspired by Kairui Song and Chris Li's implementation, as
>       well as Johannes Weiner's suggestions. This eliminates the lock
> 	  contention issues on the virtual swap layer.
>     * Re-use swap table for the reverse mapping.
>     * Remove CONFIG_VIRTUAL_SWAP.
>     * Reducing the size of the swap descriptor from 48 bytes to 24
>       bytes, i.e another 50% reduction in memory overhead from v2.
>     * Remove swap cache and zswap tree and use the swap descriptor
>       for this.
>     * Remove zeromap, and replace the swap_map bytemap with 2 bitmaps
>       (one for allocated slots, and one for bad slots).
>     * Rebase on top of 6.19 (7d0a66e4bb9081d75c82ec4957c50034cb0ea449)
> 	* Update cover letter to include new benchmark results and discussion
> 	  on overhead in various cases.
> * RFC v1 -> RFC v2:
>     * Use a single atomic type (swap_refs) for reference counting
>       purpose. This brings the size of the swap descriptor from 64 B
>       down to 48 B (25% reduction). Suggested by Yosry Ahmed.
>     * Zeromap bitmap is removed in the virtual swap implementation.
>       This saves one bit per physical swapfile slot.
>     * Rearrange the patches and the code change to make things more
>       reviewable. Suggested by Johannes Weiner.
>     * Update the cover letter a bit.
> 
> This patch series implements the virtual swap space idea, based on Yosry's
> proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> inputs from Johannes Weiner. The same idea (with different
> implementation details) has been floated by Rik van Riel since at least
> 2011 (see [8]).

Unfortuantely, I haven't been able to keep up with virtual swap and swap
table development, as my time is mostly being spent elsewhere these
days. I do have a question tho, which might have already been answered
or is too naive/stupid -- so apologies in advance.

Given the recent advancements in the swap table and that most metadata
and the swap cache are already being pulled into it, is it possible to
use the swap table in the virtual swap layer instead of the xarray?

Basically pull the swap table one layer higher, and have it point to
either a zswap entry or a physical swap slot (or others in the future)?
If my understanding is correct, we kinda get the best of both worlds and
reuse the integration already done by the swap table with the swap
cache, as well as the lock paritioning.

In this world, the clusters would be in the virtual swap space, and we'd
create the clusters on-demand as needed.

Does this even work or make the least amount of sense (I guess the
question is for both Nhat and Kairui)?

