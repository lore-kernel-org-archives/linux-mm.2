Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD894CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260A86B03E7; Mon,  1 Jun 2026 10:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211626B03E9; Mon,  1 Jun 2026 10:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1014E6B03EA; Mon,  1 Jun 2026 10:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3F6B6B03E7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:49:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DD27C063F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:49:04 +0000 (UTC)
X-FDA: 84831626208.20.A90329A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDA1AA000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:49:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhqzhbG7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=webwvWS3uC+3jTV/t/V+76+xE1lIdSdSz7O7qkKhHkw=;
	b=GYXu1qL4XpbjhPbzDlxtf31OhwH7fTkXQHpuy4n2RBrkSQD0eeb1okOqRa00URhPAvQpS3
	YrLhAgTtCwomrWUAOxBRKWzmswSF9GG976xEcsalhiP4F6TYL57rQlsWysuZeIbGhi09EX
	V1gsnXPobMvuLwK7zrmXoiDFuQt7UFs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhqzhbG7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325342;
	b=wk81qArn+iTEG2zxGXeW9P1yzIygUiT/nhWbr6sntZrd/hM98pWNGduzWjuXKMWdFMCgYO
	oLvFgkUS5dIuXn4FPjccFtJqrqVRrk85fNAvCrenQVw6SAT0XwAyuiMxf+4cy79woDaLNL
	nWbNd/LoWB1YcFiojVgYiHk2bm1eNAo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F6E0601DF;
	Mon,  1 Jun 2026 14:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28011F00893;
	Mon,  1 Jun 2026 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780325341;
	bh=webwvWS3uC+3jTV/t/V+76+xE1lIdSdSz7O7qkKhHkw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dhqzhbG7t2yEs1YiYNXrWG25HJ2BQUEMyDCFa08X5ooeNz7WxG09Gxd7RF9L9iWxw
	 QDVl6MVvpTqXgJIdOay7GoBj98Dmm/VDm2T2c1PTO65+noV+eO6bpPeQmJwx/APFvg
	 ihk6mG1BKxivzUtNtx9SYqmtquXKwVOOf4HE5KAFGbED2sGNNdJrMaSw9eKKpANNcb
	 t+yhH3rQIFgmTQxfrAFnBUhexskkY75eK4oDl0fxxVk9tOprU/ig4h5rNa0GDVzySv
	 0rl5d1MIodrehT+ikfzP9zECSs0eBK/UdsQHUxzzDnM2F2awmZDRR/9MdbqxMX+Dec
	 P2D8pLBLbqfsA==
Message-ID: <f49466ea-61c1-4546-861b-e3b518710042@kernel.org>
Date: Mon, 1 Jun 2026 16:48:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: move folio LRU code out of swap
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
 <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-2-1b9a4ac255b4@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-2-1b9a4ac255b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDA1AA000C
X-Stat-Signature: 7be1gimoqpd1s7mt117izmgx9w654tue
X-Rspam-User: 
X-HE-Tag: 1780325342-156283
X-HE-Meta: U2FsdGVkX19UXGNQ65oaho2tEkf9URiKTwYBhJTfdWHRYQbTTTqv3uFkQN70UTv66zMZkobLo6wHugIBBF+tCH88KrqWQpP9OusHlu31mtObgEEEGdEuiDoBM+MbbdBm9Oa7YNvgzFVt7Y7N13Eq3QW1ORciwypNf1HnGFKsH+JGT7MPXRboJps31UXUXvmlzqxZBTLpk2NSuy4LtyVu9oaRVLXPy8li/KImk0oJ6z0RMU6dVF1CYPcZujVZ2QyzpnpD2iHxtAoNcAQHoxRvWs0D5KtjvjDDCq4nAAbh0diU0OJZRlF66zb5hCEpX3s42umszTkO5cMlZRovqaY2Gelcytns9XbyZ5VxGIdw+JfKA7aHjuRVgsmAQiFzPnQj0lBEGDjRlhIdMdgmqQGb7DP0R1mZzd8vYPYdAOIjkYR3jbV1iBqRyVivcR0VsvCuXeFq0ng3+UNghyVL91gd/hbGVIEf0Ly/S1GeEV3+JE0Sx59yErf1mB6YDJks9KguoYH/7sH9dqBydvdRSICHoHF7YKenVQC+DU5QV7bIjKljRmTcYZ0444YTC8X2gs66lMUy4/rpbZV53FDt0EGcOOvWhlUN1lAiEYtW4bXPVmSh3ok3jyP01geyF5LGGdq3ZLN+2nPGzE6BMp1u8eU0pbM6iaq/2PctoTy6u0fcsIMzxvX8cLr4FSdk3WudtZjxWU3WdPblDLmTo0QI7LlmRGcKWtDLvxZbRJzHFZLeP+4Sg1H4Gcsiq6zAjCn9d8kOcv6EilGYikpkPFCQpXA3BzwJJXre47H7jIqmJTWOwRNIYaVeut6mPc1JNBuP0ZNHuwPPYOMS+6drU/BDfQfehVRwt9r8b0+9ZqyL0tlTsrV5wC7+RaRbcLTGH4ADohgiDkdsW3VVHk+C6f81sI9DGcYUElzgfVtU6SU9aRcBXCKW/tb8tvpuvgc+u23JEciHGlPpBEtSQI6EwbbKKWK
 0V8a/sRn
 jLsO/+WMxz9iI1X+2FLBGcIIiKouBGrt57I6olzy1CHc48Bw2yn6rGPP/fNnLvasq/0VHK2w6FNYkrXVC9W+IzCNgBlQv5AF2SlUU0yWWzQsvKLt0FBfdzfP4GHhmvvhJx8AmIw1N6sSDkl/Vq3MrzZ+TFDx68QV5e/475NLTrKP0w3uNeVMZO79wbUNE42yVml95ex6UrIMtsAchsb9hOQ0fWZHFpHWsdGN6zANZgYQ72mShQ8GelEZMZogQRqMp7J+cjc2ahhVLB81hefGGOhl8qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 11:50, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.

I agree that this is cleaner than "swap.c" ...

> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
> 
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/Makefile                | 2 +-
>  mm/{swap.c => folio_lru.c} | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061..5f712f9bbe73 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,7 +50,7 @@ endif
>  
>  obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>  			   maccess.o page-writeback.o folio-compat.o \
> -			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
> +			   readahead.o folio_lru.o truncate.o vmscan.o shrinker.o \
>  			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
>  			   mm_init.o percpu.o slab_common.o \
>  			   compaction.o show_mem.o \
> diff --git a/mm/swap.c b/mm/folio_lru.c
> similarity index 99%
> rename from mm/swap.c
> rename to mm/folio_lru.c
> index e4b3dadaa6dc..7dab6a544d94 100644
> --- a/mm/swap.c
> +++ b/mm/folio_lru.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - *  linux/mm/swap.c
> + *  linux/mm/folio_lru.c
>   *
>   *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
>   */
> 

This likely needs a MAINTAINER update?

-- 
Cheers,

David

