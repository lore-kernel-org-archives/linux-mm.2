Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8F7CF45CB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13046B0005; Mon, 12 Jan 2026 20:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0B66B0088; Mon, 12 Jan 2026 20:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC9E6B008A; Mon, 12 Jan 2026 20:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89FEC6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:52:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A824C7970
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:52:53 +0000 (UTC)
X-FDA: 84325267026.23.70DF1D4
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C6721C0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:52:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BaA+5CcS;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768269171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8vR8IcWOe3U+SwbVugZ3tUgy7ynIn4XZQvhPHfLxr0=;
	b=xomSswGQk1DGoIM48Jldj6Yf8suPYo2pq2zlgpJqvtEVPCkhuPYv1OnXad7QXBY+vSvv2d
	fmvXwnLCe30BRieR+7/N+YbhCt9pepgGj1eC9nJL9IsoVOMK2ztYlHCwRSk3P8X78TlpoZ
	7H8J0wwC2hsJxFpzw6NK0A8YPV8RCYs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BaA+5CcS;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768269171; a=rsa-sha256;
	cv=none;
	b=RmCES/LO15UjuozShTq4gbkSeJxTu5b/E1UC3YKskLFkXnOstvLIpfOMtWNdumlE+GpvUu
	j3GkVGo+RS/GlCVv70HlweN0niJS3BmDPTuuDI/sF4Uqx/eJepHrE/qTJCuXk9BxhvEybQ
	dMj/GG+GT8Pdvy/0bjLXtEMN++ZjxzU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l8vR8IcWOe3U+SwbVugZ3tUgy7ynIn4XZQvhPHfLxr0=;
	b=BaA+5CcSE7QmBkS0fDj4pdt/1MJLxUy9o2/mlw654+109oWNTZnKIJgJoPmdqhF8Wumcog9uG
	6UQ7tobIkE0MBZ+dDIRDybhk+KtQCobcfwOJmfxXApjmzQt8BiCMI9yp1bZMoLhpq3aUHKLxUY0
	qLaWVTiw/B9oslYwwA/qax8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqsc91SHRzpTPL;
	Tue, 13 Jan 2026 09:49:13 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B07E40363;
	Tue, 13 Jan 2026 09:52:44 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 09:52:43 +0800
Message-ID: <25e3d755-4d4d-48c5-b1ac-ff62d37694dd@huawei.com>
Date: Tue, 13 Jan 2026 09:52:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20251223110523.1161421-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C6721C0005
X-Stat-Signature: 1cemijyq9kj7ikfngybrk3i7q1ecma6m
X-HE-Tag: 1768269170-342810
X-HE-Meta: U2FsdGVkX1/Hyf2Gp51j6TLdkvA6Q3Ug2G3we1DdQ3VjHNyyuOOWAQxoFDegoUM32MEhVXJCu3yI119Oh8GMFDMzKCQexOYn7xMlY/TzLwxYbKy+UN03WlrzlNwG0yerOM5OhMCUbXeFfZ9/pv/GgybI/8FYj+AQJIRbnjYBiW3RHccN70K7ORV7noxmbLVjq/IeuPZrCX6qEREr0C1gc/Hlg9936e3mlyfouyL+wUM9Vc55lLOV0rga9Smpr4ZvEBhjuGP5t3KpJ+Mw2PltUeBqM1qYuGFcPrF4/Cs+NsDhO4k4LJaxN/G3mDCAcZxkSRfl0AourT5OfkQ8OD1jit1cFbzMuchDtvC4DsRa3LTCCqyFdcnKYqLmcUTsWIlWGBviCwVxwNTWDFUJvlDBD72nAAoqxlVteO1hn22M0j6eVT8XCH6WPu4iPzwKrWPxF7+daUZ4wmqdOuYkn/AYE2xCAf2u8AoSKBCnaxtvDjdBuxD2IC1E4rzAAEdZpmfYK6hFnAewVkIx42lCjApz+SZpNq2OMZHPjb8uETNrH4+Kx3TYcy/0soP8bzyfz0fIPUx1MkUY+kBQFB5hSiQ4APx7zL/crUZ0Bupb4Bb8qjWyD96NvrZ1WNo1qTPFR2o3AiH9XXsFehP8SJIBe8NjjIeSRfQQx2uti08hBbqJk0GFqeYwM3U7FiepFIwQCAjcGKnVGb7oxDphhcoo50TEsKuZcwV5UhqZdHktC0azlvrZ0kcCyzS1HsZdNd9Z7OsPdrAFwV35jtnitfVtAHOREdVZD7A35tfkFfC4XNi9O21cOFGim4i5m3rmmPdXsYj3TQHiaWRZeTYySju6R/XOExdbR3v04MEzWgrRzq1r6nVqNPGdxzKHtXXO0dioYHM0NwTFzEMCcOTafaM85U2PEOqvX42lDZWoes4I0pNA5751P50faeT2hjv9Tfqf6gW11vNu2IZGe6QpmQc2j9T
 fmveStHL
 YH+yR7IEANkwz3pcfDYbx83FmZAzf1WZBvr3WZZM2kHUBWEfDqb6q4yvcYC9EZ8pbj4O0Soolg9CBLv2xb0aTn95JQNlLm8+yRomx50kU8CxVNt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/23 19:05, Jinjiang Tu 写道:
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND memory policy.
>
> When the cpuset of tasks changes, the mempolicy of the task is rebound by
> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
> are both not set, the behaviour of rebinding should be same whenever
> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
> be set to cpuset_current_mems_allowed nodemask. However, in current
> implementation, mpol_store_user_nodemask() wrongly returns true, causing
> mempolicy->w.user_nodemask to be incorrectly set to the user-specified
> nodemask. Later, when the cpuset of the application changes,
> mpol_rebind_nodemask() ends up rebinding based on the user-specified
> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>
> To fix this, only set mempolicy->w.user_nodemask to the user-specified
> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
>
> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Change in v3:
>   * update changelog
>   * collect RB from Huang Ying

Hi, Andrew

This patch has been reviewed, could you queue this patch into mm branch?

>   include/uapi/linux/mempolicy.h | 3 +++
>   mm/mempolicy.c                 | 2 +-
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 8fbbe613611a..6c962d866e86 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -39,6 +39,9 @@ enum {
>   #define MPOL_MODE_FLAGS							\
>   	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
>   
> +/* Whether the nodemask is specified by users */
> +#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
> +
>   /* Flags for get_mempolicy */
>   #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
>   #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..76da50425712 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -365,7 +365,7 @@ static const struct mempolicy_operations {
>   
>   static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>   {
> -	return pol->flags & MPOL_MODE_FLAGS;
> +	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
>   }
>   
>   static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,

