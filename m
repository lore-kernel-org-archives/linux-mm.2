Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0FCC9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 05:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30D16B0005; Sun, 18 Jan 2026 00:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF16B6B0089; Sun, 18 Jan 2026 00:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F38D6B008A; Sun, 18 Jan 2026 00:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C27D6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:04:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E28CCD1E92
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:04:54 +0000 (UTC)
X-FDA: 84343894908.17.8B186EF
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18C77180002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:04:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjB8ndGY;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768712693; a=rsa-sha256;
	cv=none;
	b=aCVU5QOh92EPf5QTO49At3G75iU6kNL7nX8MbCJsfBI9uOvbH+xHhKCmClwrkl6rco9p8Y
	+NhdukWjRBIWxOIpoe0hjco8yGzcXxNfHNO3He29HJAgvUMe3Oh3m9wIi/lZzolB+btZpk
	cBV+A5361UO2b4Ryb0AiC1hI8Wz6MNw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjB8ndGY;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768712693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ilj6/dtjZjTchAVyTXVluY1eXFhY21oaAp6+lqrc9g=;
	b=hUji3MUToiSlFmu4LUOGARt1BmWdu8pL4o5rsZu35O/Ij48psnXkzcUWAtiA0Q1bf36xZo
	KbyVbZ8hRJfgVrVYkqVVF038vh2sFu0RDPPZYIZULM5lU4FWjfF8GVa/l33yE11Qs4V0/w
	lpIaqALOBNFf+0QTveyRn/VaxAX5iy4=
Date: Sat, 17 Jan 2026 21:04:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768712690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ilj6/dtjZjTchAVyTXVluY1eXFhY21oaAp6+lqrc9g=;
	b=YjB8ndGYK5rdvz8Mvf8c4GHNQMj5zqOZHoWFeP84IUyTs7MKnhS3pxBoha7BuYTFrltE7g
	tPKkzRj/cW8fYHyoHVMukDaYs8pYXwCMQQW+5lUNcksI+5XagrKUJNGqZPPsVW3TOg198H
	VfgI5Qvj6xX5iD83saMZHDzjNEdKrs4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/vmscan: mitigate spurious kswapd_failures
 reset from direct reclaim
Message-ID: <55m7lphwqp3nywapjutkdzajehvhhulig5v4zsu2lafsxqmwkf@qmwqjgk6z3ke>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
 <20260114074049.229935-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114074049.229935-2-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jcxxfxsi94aoat8exq5tp95b5xsmu1sd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 18C77180002
X-Rspam-User: 
X-HE-Tag: 1768712692-877860
X-HE-Meta: U2FsdGVkX1/+WCV05mssMaOA+b7fDsfA8htzZyYJJf8CBafUNSJskkCC0Opwkfi0Dq5ibjOlctbV9B2pjMlXoerQGUgDk8f1nQkoDloh3CQFnt0CU6/eAAK9EbizFfN9nLzO7MBGU6dkQbj0+hUDe73MzpchFKnlmNCpbnKL4kLoEfOkwAe5SwY7PBfOukSo61Am5QXQIkssr78vAjKIkIqK6E1vyKvmdP/Iz49aMYPR3Jy3VupBHzqK1kDRscLzGn5/41cEKzVA2qKUb95qVXZQV3qTnnFglphXY2qFIXCvL+em7I6lrou0Olhj4qxM4ZWjndAo/1I5YJafYS7IOoRfX0JTDDcRv8dQaGHnPdI58084nLqNJk7mkXdmV94m23yVDWOOmIRnkJvZLYXQnrJlZ3L4J7E00x6YVI6wx4rxMI8QBxj3/NVKpHQQ+TwadBCdJjAyU+B9QAcLDdAmirBUJ82P7lEKkgO3ZgDY7iHTsX3MWKXrNSRAxvkhlBmHYffyYY+7PDGFTpw91zHqdWk9lAHDI3yQwWMHzcp0Kxy8AAefGbvbmxNsUHsTgoAf2uIQt4myaz2z0BOiRzWktC2YWChTnAmaDrWInYvKlow1h59kTTXVTbK+t8AK6p6XvcvxQ7ttPnzxlFSWvxa0kEYDDPk1Xfn5Fmvz2KSQO6BzpCaSp2XOlZL8Udg73oggYQFpaCa/MSVggD8evAUSAKcLK+30wEoaxFfXw5l+5hyF9QTFsM4BsITvDPF4dbfxKlrN5HLosIIzyVptzpE6cC6Y2DZGGXeh1hZN90uEgXZCS+z5rqsvPhiYDF2ruOCutZfLG66G5n8+l/TkZSwh+4isq72uw9lrZuGnwpgwK20HePcaIV66jwFjSZmW2lYdvJGKH6cHbqW+HU8GvRMUnUVEPK0/BZ3M/xkx8AvhNwSlF21mnf9hNmQldAEN8qDsNJNKMF2xmoQsrJtMrPX
 9f4nfyBE
 pnIbBDWvh0JjM+gg2WWwyClG7YDXsD14x2dbJK95jwyqpCnI9PHUcFgEPzSPIO6E3FggCWqzygjUj8dY8OBwA9C31P4GWdPTLQTfgqOPcXLTvAYkc/QVd6cl8qMW1GBCI6I/sre+lCHTM/ZbW/TtF7OszlEDkW64sDOKG+FHx8bKNeGRKhr2SF+sjYfMZLHY/B4+JYMIoJUKr7ciK9yDsKMaw+qhlL79bgRGCy4qFYCIgPIP4KAEL4yZHHJBUx0msB4mCy8Bl2NY9AvICYX8TDLl1K1JiRQdVbOvavkLc6rYyYsGtoMMsyNl/lxgTnarLgsUj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 03:40:35PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
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
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

After incorporating suggestions from Johannes, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


