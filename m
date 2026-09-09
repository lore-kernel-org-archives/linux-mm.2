Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1855AC79F82
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB21B6B008A; Tue,  8 Sep 2026 22:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63C46B008C; Tue,  8 Sep 2026 22:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78C16B0092; Tue,  8 Sep 2026 22:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9086B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:11:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E0E3A083B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:11:05 +0000 (UTC)
X-FDA: 85192596090.14.E13AA32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5749B1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:11:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TBWXfbMP;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788919863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMSpRkJWb1wgpS9PsxD2TN7ZwnY7QPSvbK47zQ4NDI8=;
	b=Od2MxNuxhvEZldyr8GxEU/BqHoSXojFZ8t1hRENn3PaKnCKYTNPmayvYI0RqBEV8NBcjzK
	1tKGCJYva+1uYz2gz64rb+LKMJ7Dh831/MsLC0gg8VbQ4XzOYozVKK0QJmLpythsqHrc+u
	BNTCuq2X9bUcTV1vlXmwo8sUHnxWxG8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TBWXfbMP;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788919863;
	b=f75otDu2mq4/LDD+ZAh7zlqaKP/JJx2kEJtBowR5OTS6+Vkhwp3NTrNkc6bGcrvcHWYW9s
	I95lMVOKhN2PxGg9JiFDSAZTIZi25Lug7n789NfFnwtrbYlesAvODYat+RSQmrpDbG+FzJ
	s48T71otobsLn0Fvmppauh8O5Ml5/3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B6FD4403D;
	Wed,  9 Sep 2026 02:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDF11F00A3D;
	Wed,  9 Sep 2026 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788919862;
	bh=mMSpRkJWb1wgpS9PsxD2TN7ZwnY7QPSvbK47zQ4NDI8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TBWXfbMPLS8g9kkKXMOlBKV+f849NpEd6kXPivu1/gkzm8jPDUILHgCBopFXMKiZ2
	 EpnaYznFF14lACVkxuVV7nM96DplBqn+hHv2GvofhRmktc7O+1noxxv520ErN7Nj++
	 O3+ttNW9LEyNWFW+BmXcMy05uaDkupzbjsydxpCk=
Date: Tue, 8 Sep 2026 19:11:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john <love_goo@163.com>
Cc: liuye@kylinos.cn, hannes@cmpxchg.org, mhocko@kernel.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com,
 mgorman@techsingularity.net, yang@os.amperecomputing.com,
 zhangqiuhao@huawei.com, wangkefeng.wang@huawei.com, mawupeng1@huwei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wupeng Ma
 <mawupeng1@huawei.com>
Subject: Re: [PATCH resend 0/2] mm: vmscan: fix scan overshoot and
 ineligible folio scanning
Message-Id: <20260908191101.b6e5a5a52cb8efe8f3883a81@linux-foundation.org>
In-Reply-To: <20260901084706.3784449-1-love_goo@163.com>
References: <20260901084706.3784449-1-love_goo@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5x3nb6ani8wquagfh4rggnex7khoskzq
X-Rspamd-Queue-Id: 5749B1C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788919863-146893
X-HE-Meta: U2FsdGVkX19nZQfNotHyommM2+QmCmlt6ds+Hz4EGjs2532Dn1OIG2aHFjzaZuP1t9tzd5hbsgefbqrC0FSn3DNK8wdKc/5IcsIuBHFQ1W5NwuaLIjSlApXIsJt1FAtTs66L5ao3R42SXN5aQK1Hc+cDiflg5tDDSF3Aq69ql5ZtiMn1VV/Gbo/l0TMX4vU3Av9bocjYW/cKvvTWAFlu5JENkMZruxNhUw9JSlmxy3/F9N35zP/7DO5rTrxbcZrwc6kgAb+KqhH76wI/TCx1uMg4hCqFu6ztnbtMu1VkCQuRqdb6CnCyTPKZ75l/8KvgS3SrPEHPDQlYcxigQ1AOR2j2Iy2txgqUeawO03ZcRoPsw/1EltWezCiTKLsq4iV6YaBpVCmP48/Il9YY6ckNwaJMCEkxWMfsmkOz/lCommvcT+pUsi6OR7FiiLPT8KUuzfC8KC1VsamRKpv0fpFfHaUWdNhuNE+2TM9tylZw8gJqbvkohablc9jiHo9vM2PST0dCwLLRTdNk/jRSqpRtWvgO7LN2y5rOpOkIM9FQqlFwIFShckEScs5sJxPjY/ERE+1JCTcnWOWTHE6tiV0zCIfcTmgQdL+vvj5ZRuP7vqMZMl0lrrhKPxTkGhCjEJY8FPKl57u8/jA8+q/W0CARfkmSxTndBaMVCVCqJzfcrYCvv3CNjz45ftQYXccX1VWZHZ+u4DVrffbXG7IulAO8UhtOZObWsTtEgYrt4yLc2ccOAq3r5LecqCJHvKqHo0TdLNFhbPH3TD3QitFaAvVBQ7UImipIqSd4h+jkXWpjpVRawMg0azCKhWrrzFul/u7R80KP6Ah14b/7rsickhmZBmcyTptqMrxUjwd+oVt8um0prn2Rx2dfbxoyewFmCYIv76spR2YDzp4sJ2Bblgcfuycu997SL5/J8Xqgki5w+hy1VK513lycc8iHffZv5eLSKrUNZOKGZgkfq/cQriA
 Klt/zq8e
 7tR3vRLhZ0gFa+bd6NMRFpueDGWfHkqS+H03+dTP2H6DBWM28ZWVuoaPEji3BCU/OaPDQ//JpEGMy8rWdyZRpDxyzMAv6mYb9NAUcj60JkPWfzEDRRLn1uIrr6mqz4uUyjeOOeDLcbPfCh1/3VvDMjUcBYBLOlx25cyVYwzHh61/z9x/qaNywV+q4NmwKFHjeq9Axf2MC9/C+R4M96PVmLa8uEVe/1mh+czBIDry/+GzgI0SPdABYDKxjTy4eksgu3KirSviJeXtRilWsJm3polETFP5/cNGRhutqRz+GRJ6vzg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 16:47:04 +0800 john <love_goo@163.com> wrote:

> From: Wupeng Ma <mawupeng1@huawei.com>
> 
> Rebase to the latest v7.3-rc-1.
> 
> These problems only surface when reclaim targets a lower zone
> while the LRU holds folios from a higher zone.  Normal userspace
> allocations go to the highest zone.  The zone-skip branch stays
> dead under typical loads.  Lower-zone-pressured configs (DMA32
> module allocations, memory-constrained devices) hit the issues.
> They inflate scan cost and delay the OOM.
> 
> shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
> isolate_lru_folios() may scan far more than that per call on a single
> LRU.  The excess is never charged back, so shrink_lruvec() keeps
> rescanning the same folios round after round.  When reclaim targets a
> lower zone, the same scanner also keeps walking zone-ineligible folios
> that can never satisfy the allocation, inflating nr_reclaimed into a
> false progress that delays the OOM.
> 
> This series fixes both:
> 
>   [1/2] Charge the isolate overshoot against the scan quota so the
>         next round skips already-scanned folios.
>   [2/2] Stop scanning once too many zone-ineligible folios have been
>         skipped, instead of force-isolating them.
> 
> Background
> ==========
> 
> We observed slow, unexpected OOM behavior during extreme stress testing,

OK.  But why should we care?  Don't do extreme stress testing on your
revenue-generating customer-facing computers!

IOW, as long as the stress tests don't crash the kernel or lock up the
box, we can spend our time thinking about kernel behavior which really
matters.

Now, if these changes can be shown to translate into improvement in
real-world workloads then they're useful.

Am I wrong?



