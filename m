Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3167CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F6A6B0088; Wed, 14 Oct 2026 19:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC00C6B008A; Wed, 14 Oct 2026 19:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD61A6B008C; Wed, 14 Oct 2026 19:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8311A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:02:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 689CE160867
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:02:39 +0000 (UTC)
X-FDA: 85322758038.24.73F1537
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A58072000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:02:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LnrpcqLe;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792018957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTYVPdLowER/NQgZmE9HNR8wYFSGQx166uFE24iaws0=;
	b=CsIZ5HpRv80BgSCG2Rugvtix66G/8rVi7Sd3edc3KCIC/6Qk8PToTLPN2swzSYr3b7AZk4
	ydpmGgEVHrAerV7yDrmkRM5g5JYVrK14WJFMLLVIs0Ga5TJr7qVfLNWM9W3n5HEUkEi9LA
	xH6N4txVbi/+pDxlVFoY4MQ0MhRw1ug=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LnrpcqLe;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792018957;
	b=58af+RuNjWR8GZ019EyKE2T/GFeWNJr3YrFDyOovUMw8bT3dBjxIdl5n3VxkNKNhQV9iw3
	8BoVgYr/+b2/H3f2qeALXhyodunUP3B8Aro5u/u/0qOTZWN8mipvWxOEy3Gp5+jZ+mYjtY
	uPhCdWwfpGbjXaQ5fjO95/kDr5/FbCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5B556020C;
	Wed, 14 Oct 2026 23:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056E61F000C4;
	Wed, 14 Oct 2026 23:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792018956;
	bh=VTYVPdLowER/NQgZmE9HNR8wYFSGQx166uFE24iaws0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LnrpcqLeaK0nM1SbvKYcBzXTJ+TDkRmuP6vCDXSWYXn//ALtRIgR3sE8MbveW3f4j
	 6Ah4qakD/AvwXZYVvE1fcVzU5UWkG078qXZG8c30VJpfMe/OC38Vq5uIvFhMbSRjDZ
	 ou7Bf0ZR+acfkST/qWTa27TOurrsOE5dNhmRwYq0=
Date: Wed, 14 Oct 2026 16:02:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path
 gave up on
Message-Id: <20261014160235.29a39f19ccd19aec47b63008@linux-foundation.org>
In-Reply-To: <20261014090821.227366-1-jiayuan.chen@linux.dev>
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A58072000C
X-Rspam-User: 
X-Stat-Signature: psyn3okihxdnmotm8tzciw6hseezen5b
X-HE-Tag: 1792018957-237665
X-HE-Meta: U2FsdGVkX1/eLQyqjIWe9lfWAt2JtPOC44IbCt6O5o28gQ8Iqc9hcuPgUWSanwTG0vbhr8LlFAAd+fHlKGXatKTLuETFQNzmN5JeXuNN7ztAh8U2d81PL/iERkSFQZMJcbkH6+b1cmPAgxhiDcxDCXIv3xq7QZQ/mDpOjwqfURcZ6+cST503BI7B7q/pE3b423tdZwT8w0aYDrlvkc4DUWWuVJATm1ZFqUdTZfC7+kkI7WHcL8jrxbG8FFGicMi9wSawM1l2tsl0MR02r6LfG7B6eQ0iPYpRuIsQ8JLLW43HWZak/JONlZmKDbgQifQf/aq3LuLGm3mMsgV025vqUt/igdqz62LpZuL2zRhnAiDysIKWHpIIriPi/eaQ1tZhML/LR1BcBjZfWG2NTZ+joe2ZA/I5mUvH8m4O1yIppNCPZiNcmy6tTu3K5WMlWrKce9lpIWeHbyuLa4FvtW2XNuGFO46CWf9eIKFuByuinEjxHgxdV/sBknuJbISztcc/uC6iOncX2M0JhiUlJKYClTrTKTlr0IF2FWT77/ckTc39VpAW2qa6Rb8XRnUg8RHl/viamNXdleQaMSqPyX6H80slqbXqIvVVxljAVQodXfmlIjuXWG60DPpFxMo9fpGGNNlYFNOke16BzY+PFR/FIYYrIa7TKd8x3fcY4ycQZdowegcAKnJc3hhzQ0mPoJfX7o76AB1HVqrtJjjadcsaWM1tOIDLjrAcXLF9VXkA4A0e9St0ss7ufqLTDjBVKcHaRebCvehlM5BS9kPjEc7vTmchmSiTRrtfvMOfXcDl4DiZCevt8eE3sqY6N2FJYvG7g3BZMTC8yyiER/I+AN2U8a2yavnIS8Q8xL4rAbfM3AY8T1N+RaKi8ce4jPNK8s7XRs23ByPkd9Gf0Z1kXoe+opq4JZ/ljR7bZcWjZ0/dqipeF2KTXk5VNNE2hqxREPjifQiWKWN9wDwksbPtzK2
 SfjkUnlv
 hYppFIiHYyllYBFpMhrfeX8NwQH5TGWO8TsOVKdZjJkHJTnK0mUQ4H0o9OWjYBkh5OAq4+LQWDLOPTNMvIaNeU4W61fjUKHNFgqHarE96D6hNftzTWSbRDS/oCNpdEwifZiB2jFoJjOcxXGgpzKCUnTkTMuVJXB1ulGOWa/Jw0XCl7fYIL/CcAyXwliM/FTJ+f53ILIGfcNv/eL+mXBXhoXh54zRPaQ41mW3Yzso2QQ298mJBV5932di2Mcsg87YOdbmsb5zmnjwypt0woHhBCUmHW3PgT0fxV4w+Y6Zk0LY/ztCW16C+UIbKE/hu4g51ZTSdvppGDdOrOpGGpbxnYl2yWIEOjDw98n5Zc2iwsvlLFOyymi41b5JOfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 17:08:19 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> On our production hosts we saw swap cache only pages keep growing for days:
> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> swap slots were held by folios that no process mapped any more, charged
> to cgroups whose workloads had long exited. The only way to get them
> back was swapoff, and with other services actively swapping on the
> same host that is not an option.
> 
> Such a slot has swap count 0 and an unmapped folio pinned in the swap
> cache, left there after a process exited or did MADV_DONTNEED. No page
> table holds its swap entry any more, so nothing comes back for the
> slot; LRU reclaim drops it eventually, and the allocator only reclaims
> such slots once swap is half full. The growth stopped exactly there:
> at 50% of the device, where vm_swap_full() becomes true.

That's a pretty nasty problem - thanks for working on it.

> Options considered:
> 
> 1. Fix it on the readahead side: after the read, check the swap count
>    and free the slot. Covers the lock, not writeback, and the
>    asynchronous read path unlocks in the bio completion where the slot
>    cannot be freed. Two places to patch, neither clean.
> 2. swapoff/swapon clears it, as does memory.reclaim on the right cgroup.
>    That is a workaround, not a fix.
> 3. Have the side that gives up come back later. This patch.
> 
> The zap runs under the PTL and the fault path takes the folio lock
> before the PTL, so waiting there is out; a worker has to do it. On a
> lost trylock or a writeback refusal under TTRS_UNMAPPED,
> __try_to_reclaim_swap() schedules si->sweep_work. The worker walks the
> in-use clusters and, for every slot with swap count 0 whose folio is
> unmapped, calls __try_to_reclaim_swap() with TTRS_WAIT, which takes the
> folio lock and waits for writeback instead of giving up.
> free_swap_cache() now calls __try_to_reclaim_swap() as well, so both
> paths give up, and wake the worker, in the same place.
> 
> For now the worker scans every in-use cluster of the device; marking
> the clusters that need it can reduce that later.

It's a substantial patch.  There's no quick-n-dirty fixup we can
prepare for backporting into older kernels?

>  include/linux/swap.h |   1 +
>  mm/swap.h            |   1 +
>  mm/swap_state.c      |   9 ++--
>  mm/swapfile.c        | 101 ++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 104 insertions(+), 8 deletions(-)

Sashiko had a few things to say:
	https://sashiko.dev/#/patchset/20261014090821.227366-1-jiayuan.chen@linux.dev
	


