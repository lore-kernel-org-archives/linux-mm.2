Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAB7CEFD15
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 22:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EAC6B008A; Tue,  6 Jan 2026 17:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC8D6B0092; Tue,  6 Jan 2026 17:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F086B0093; Tue,  6 Jan 2026 17:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 484696B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:06:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9ED013C344
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:06:54 +0000 (UTC)
X-FDA: 84302924748.10.EEC92FB
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18A051C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:06:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oCzLRuwi;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767737213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3c1lMUlB9cNQxKpptyug2XMgjZvECYwlcrOtmUyfSw=;
	b=TCR/O1LilDerD2eUG5dGKdDoCQzHWmohroT3GzRgr5NtdcmYNIUmvwDWWLmHVc8PUnJUqP
	+VjJr2Ki058Zpzpz+sp18bZOZZvxaExNZlyLAQrdCbYJXRYn/iH3eIDyoGM/6kfohfGgVR
	gitXJrXQu0zaWfKFHPWjLsV1/kIcMPY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oCzLRuwi;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767737213; a=rsa-sha256;
	cv=none;
	b=kD6cZs4ncZF7T2HhUxX8lceQoD2cBPgCIhVS2vllqwEMQb3kr3yMfOqAsBsN3ClbfL+Zi6
	Tk4BLVjN3D1llnJNFDiKOQvaSTp65Z3+goj7k2LL7ALqNF+1TL9GEsS6+2/kmeeUgARV6S
	CV3KFORiRyBgEYhy100doNsYqoBiM1U=
Date: Tue, 6 Jan 2026 14:06:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767737211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M3c1lMUlB9cNQxKpptyug2XMgjZvECYwlcrOtmUyfSw=;
	b=oCzLRuwi0BoDJ10FmMpN54xdHFkQ5wWlNCvKynWEhu3DXXKtR/CKtjCKgt2vPJNooOFaF/
	mDKTYfa2uLS1MUB2N0z0VnraXAMRJjGojDdUjnWw7baLf90GMMamhtSxgc8muu06+B74QC
	8EEBzyzwlFLRddL0Cneo7g9A3LJbSCY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <gxrh27cynibsmexsb6gahs2gd2wkicoiumzfyljbxt5mdleium@5rmx6bljxj3c>
References: <20251226080042.291657-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251226080042.291657-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 7j75yrdw1k9sc564t5zy7jy5u7kxc91n
X-Rspam-User: 
X-Rspamd-Queue-Id: 18A051C0005
X-HE-Tag: 1767737212-861733
X-HE-Meta: U2FsdGVkX18oVJ7sRDin7PwCm5pIxjarquZ8kE8et4u9J325Z7PJkGhOcwVlQ7wehUZhjBARoP6xFdDs8BHr0vQjFB0il959vazmCQ78RM1X5AG33PZnIwh2BdaQG173ocjtBuHtFI5F92z6SGm/zgyAc+/G2FsSOLkSqPpehX9RM6o2Tu44SduCiAMCIJ0BMIYu03EI6lmOrXrTU39Lmj9K1PX9NFIi5bvirNUbizFP2NJm/186jqhHiQIj3uGY9X/iIkfRc5Q83yXDhSzaJ5z+oUWl0Hjokb3z4mKvz+ixQ2wbDTKDyEnPhlQDdSegPTUOJ4G4nydEZxfQlTOhXLU4y1YFanytr7DRgGY0xb9QLrB16f4bCA0Gg4udaqMnwzv9IV/kXYkfodhFHHxaA2XsGd/lZydBGoIgNVAdjBz8gdsuiQHTkOGvlOvUPMXWQjmIOrQ4hqMn6IG+7B0QQbwqkrACjzSr4Mmirz+aJnfsdNBCXwmMVCkLkbGRl8505hOhMjEXEPltY4AUgs5GCt6Pni4g4HyWnn1k+VE3r8IvAIFSavyd6dSm03iBifPg9VACbM6s2J8hHnnqTAhojzUXTsUqsxAK2ONl9F7LWLg0jZb0R+J+aIF3TBYeLZPjMWfINA6sgABT7THm0mQb3mSp+wHy8VL0/KBzSP6OzanZxAT61jrCgcHodGsrnf/gSqOdiSWNzmZ6C9M4J0x4X87CW6rp2QLBdbFThjh2RrrAGUMfHaP1l62Do39iX8FyxpNIxqQMBEUcKHrtVFZTXek+C+8vRFh1XN0LqIwzRPlAcD222NMiT3O4xd0A+QLqzPRrC9YBTD0Z9QGjJrIdqSPPh/RxleQ9tlzIqF1PlDeWtS7nRNKbu5A9eWzN9DGgLjIe5kCIPaMqfCbPxG/vv5s7orOqOykRpj/r+2vp7XHu7AwRg1krOu9lWNi/zmgP/lgRVyrEMkPY5AIt9ui
 xeChmVGD
 Wb/rxYFG/hhTASyF2jXcCHiTTAJfY/MOCWuJqtuOQfrxG8JrdLLD2n/ZR822xFc8iJ+TfW8zJ1jnHz9ourmf5jNkkZk0xdSHCqtrlcEYIZMnhxkc8WnWJAUzaQpqW+9xn2H4o68ZRLkZMIfFWhXpz+ttUiC4MWYiYrjg7zkcPQV562Y5lbghI6sMynHns0oLaouImVs/1iEBDNAwUxiyG9TzeUnyL4D+UdXLbSmv7mPpLfohRTS76SsLCu5ffXzDUBKqsLrJomGBrvQRV+47xoomIYOE7fYKLmZk3WG6v0o4c7gb/2EaX7O5t9nY1LWrpX+NnoVjo9oNGSt+nEEoB9eEoqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 04:00:42PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> This is v2 of this patch series. For v1, see [1].
> 
> When kswapd fails to reclaim memory, kswapd_failures is incremented.
> Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
> futile reclaim attempts. However, any successful direct reclaim
> unconditionally resets kswapd_failures to 0, which can cause problems.
> 
> We observed an issue in production on a multi-NUMA system where a
> process allocated large amounts of anonymous pages on a single NUMA
> node, causing its watermark to drop below high and evicting most file
> pages:
> 
> $ numastat -m
> Per-node system memory usage (in MBs):
>                           Node 0          Node 1           Total
>                  --------------- --------------- ---------------
> MemTotal               128222.19       127983.91       256206.11
> MemFree                  1414.48         1432.80         2847.29
> MemUsed                126807.71       126551.11       252358.82
> SwapCached                  0.00            0.00            0.00
> Active                  29017.91        25554.57        54572.48
> Inactive                92749.06        95377.00       188126.06
> Active(anon)            28998.96        23356.47        52355.43
> Inactive(anon)          92685.27        87466.11       180151.39
> Active(file)               18.95         2198.10         2217.05
> Inactive(file)             63.79         7910.89         7974.68
> 
> With swap disabled, only file pages can be reclaimed. When kswapd is
> woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
> raise free memory above the high watermark since reclaimable file pages
> are insufficient. Normally, kswapd would eventually stop after
> kswapd_failures reaches MAX_RECLAIM_RETRIES.
> 
> However, containers on this machine have memory.high set in their
> cgroup. Business processes continuously trigger the high limit, causing
> frequent direct reclaim that keeps resetting kswapd_failures to 0. This
> prevents kswapd from ever stopping.
> 
> The key insight is that direct reclaim triggered by cgroup memory.high
> performs aggressive scanning to throttle the allocating process. With
> sufficiently aggressive scanning, even hot pages will eventually be
> reclaimed, making direct reclaim "successful" at freeing some memory.
> However, this success does not mean the node has reached a balanced
> state - the freed memory may still be insufficient to bring free pages
> above the high watermark. Unconditionally resetting kswapd_failures in
> this case keeps kswapd alive indefinitely.
> 
> The result is that kswapd runs endlessly. Unlike direct reclaim which
> only reclaims from the allocating cgroup, kswapd scans the entire node's
> memory. This causes hot file pages from all workloads on the node to be
> evicted, not just those from the cgroup triggering memory.high. These
> pages constantly refault, generating sustained heavy IO READ pressure
> across the entire system.
> 
> Fix this by only resetting kswapd_failures when the node is actually
> balanced. This allows both kswapd and direct reclaim to clear
> kswapd_failures upon successful reclaim, but only when the reclaim
> actually resolves the memory pressure (i.e., the node becomes balanced).
> 
> [1] https://lore.kernel.org/all/20251222122022.254268-1-jiayuan.chen@linux.dev/
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Hi Jiayuan, can you please send v3 of this patch with the following
additional information:

1. Impact of the patch on your production jobs i.e. does it really
solves the issue?

2. Memory reclaim stats or cpu usage of kswapd with and without patch.

thanks,
Shakeel


