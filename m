Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE0FC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 01:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8D46B007B; Wed, 22 Jul 2026 21:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D425C6B0088; Wed, 22 Jul 2026 21:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CE36B008C; Wed, 22 Jul 2026 21:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91A426B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:13:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D8388010E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:13:55 +0000 (UTC)
X-FDA: 85018269630.01.CF93B92
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BFED140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:13:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bskeKuKG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784769233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqNPZ++8/uzCmzQsC8MgE2wyP7W/2GXyiU7cXbmcOW8=;
	b=Pe/zhKr5XW/DPMH5ZcP9UdIuETRVAmQly8PtqacwF5UmskuHMr1tIXzf+mmAcPYqK7ks61
	uW9cRCWfwzYw/co0lqF038em0MPcefZeUaw3B46Zn3M4waPvfy9W2mx8ng2GrOQwRS2G0a
	uI1ESFJ77zE/u7UuzfSSBfSs5slXIxQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bskeKuKG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784769233;
	b=EWXfpL7a6iiEiQY3y05eQyIGtpCt/Dkv+/y4oxtJRweyGZ0IreBqRgNgEqL389U2GxJlUn
	X04zM88exmvqQ2bfGJMEL96+VIVyrOX/HU7ni1ke9ubvTE4Y/jY6UKBn8iVlJiKylnGCXb
	pwY9RZOp9C24qR68qiGLlPThtlS1qhc=
Message-ID: <56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784769230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqNPZ++8/uzCmzQsC8MgE2wyP7W/2GXyiU7cXbmcOW8=;
	b=bskeKuKGJ4kcPI7CmZVDz7xoLlSOlfro5IKUZ0uYqemob74+vxEpG74CfrmuOOzhzNzPy4
	juNUddmSm5vkdzykw3SlkghDJXoO1nNLFGTGj7K+aXQmOuFA6vJLA3D/94cz/J2qbZe6c7
	djI04q3D8QwLcg9LqtnW90Y4dcTir1Q=
Date: Thu, 23 Jul 2026 09:13:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/2] mm: fix node reclaim swappiness handling
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong <chenridong@xiaomi.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260716031729.1064007-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BFED140004
X-Rspam-User: 
X-Stat-Signature: bs3ssa4ue85d6gpizypwf9z738o5k83o
X-HE-Tag: 1784769233-833585
X-HE-Meta: U2FsdGVkX1/j8dW6G2inArFlW/jdJoZfsV4IFCB5A9zxVxGp0vKKDrWyqWLfGBl6xUNtGerDsLf+iG3bYxqw9xRZZ4MdvXA+ICDPD9DnGXrN6YaluFIolICMEurLbS4NnkZPqyOuNA1wtdI/r7DHlp8KwznW+UDdG7hZEf6uwpVotGqiD2IrSQr2U5WDwkUagQ5OVE4LVJGn0LhoqI4zESFHMo3AHSJFVycVWG0268E5Zkz8r/4xhwmF8oQQ22/xHchI3vfWyeFz895/7ZB3DpgHgNQk0MK5K1frnGOJEpmxE9swS8vT41U0cQViHFIgMQ6NZPFyyNyjrdFzcwwdIvB8xJNfOoXqx8O7ehY8QMlCJzMV62/e67riddyEV4Eo1OihsMKRfI4h6g7EomFq2V1ZR/bCPd3jxexjHd1g7JEp6Liz4zTXk6IMDYvPHK5+kRsRbw4rc/+EjlOsiBR7rkM+u8gHfYFv6pYmQZf0ZxLFcY3fcG85VEbFGg/bcduHQwa9tNTiVOgXJsrFLi81AMC5c9wrcfo4HhfTruGn1WASnNfpNfXHC3na33qDmyXVVsvoEo25TaHhxYK2vYN2e24rbGwDJoNYoGOWPwXz9+ZDBeqVm8FV3TU0fxKRWixHIuWqx7v44Tvf/vgekXhni+Hj0bGTaB5UmeDa0/sOfPDYyos8FqPJBQB5oWML0g1R3l+IBD/c8IoA4xcXKhMJAwlhwIDrRLNiXM6coXaGjslIRKd4hr2JXBNrlI9hZZnJjTMoXs346LmiJIT6xzSiSK3Xwxws0Yk+AOk1FkSAqc1xsrUpZ+fvk8pydhjLnqA4/Qvk+sAC6CWMaqAso2szUZn9dQFOT53gi/F8TyqQ19uiuZoPv1xTK4Rbq8a159xJap356flcqR6NvdolLwGy5+nMhpTgqUyM1TreZMNj872IqO8LA4K+8ZCECJaGJgUi1y4FItjQ1ySR+PyqFJX
 BA+yIxGd
 T6AW0h7XuRz4gRcRToEmUrvqRTvGjTOgAN/akJA37zAt0vvHQzVSzOzZHPFWL6FB6U9Vq7FaxUOkrG4heLa8yITBvjSTTE5NGoQ6svUx8j0x9K9wPwTFb0bh3DyCgwDQiyXwjP3WZ9zTVHkeOjrdCH7Yb88qt4dGmDJQuyTiBJl7dvjanQKNKNUbUGEWEyKmeKOy1xlvjaQLna3kjuOYtnJXt3FFgUmSjSAZtpTB5ekplTgTJVC3848qLbCWVxay4rXLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/2026 11:17 AM, Ridong wrote:
> From: Ridong <chenridong@xiaomi.com>
> 
> The per-node proactive reclaim interface
> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
> 
> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
> This is a prerequisite for unifying sc_swappiness().
> 
> Patch 2 consolidates sc_swappiness() into a single definition that works
> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.
> 
> ---
> 
> v1 -> v2:
>   - Move mem_cgroup_swappiness() and vm_swappiness to mm/swap.h instead of
>     include/linux/memcontrol.h. Suggested by Barry Song.
>   - Correct fix tag for patch 2.
> 
> v1: https://lore.kernel.org/all/20260711091157.306070-1-ridong.chen@linux.dev/
> 
> Ridong Chen (2):
>    memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
>    mm: vmscan: fix node reclaim ignoring swappiness parameter
> 
>   include/linux/memcontrol.h |  4 ++--
>   include/linux/swap.h       | 19 -------------------
>   mm/memcontrol.c            |  4 ++--
>   mm/swap.h                  | 20 ++++++++++++++++++++
>   mm/vmscan.c                | 19 +++++++------------
>   5 files changed, 31 insertions(+), 35 deletions(-)
> 

Hello all,

Can this series be applied?

Just a reminder in case this gets buried.

-- 
Best regards
Ridong


