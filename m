Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A3D1094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 16:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D5C6B00D8; Sat, 21 Mar 2026 12:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65996B00D9; Sat, 21 Mar 2026 12:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AEF6B00DA; Sat, 21 Mar 2026 12:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4F7F6B00D8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:54:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD291B80A7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:54:37 +0000 (UTC)
X-FDA: 84570668994.19.3D11CA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5857214000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:54:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGjjhQLW;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774112076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1jsCEEXRest0jpeDYUJXGAmqDk+2uNCSLvPm7yb6XM=;
	b=hJL6EM3emEbhTg0U7+gNfKOcKEiyOE0OhhAkrlfnTI7CGvuHofVX/E3dpqIYNydChubOnR
	M2zYBCDoehYSsV/7hdgmgowdloOxUly4gKL7e4kUDJSmsaMirJZnaqgCdTLXRFp90f+os3
	UedIMc7cswM2j7luIx6U1wArRe2hIag=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGjjhQLW;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774112076; a=rsa-sha256;
	cv=none;
	b=r0U308QuErWip7x1Nps5YZWJo75vcJf9U+i9k5gPgghzvkOBftM1CxcIpZMSgj07W/OM4K
	mmQzd2zUtpNFBObr+8D3exkzNivIYi9WF3+2UmI3BPc9SKx8V1sKM4h/wlrJY0WGGCssRf
	znwDcM+TlvxfDZGo7y5m993rJ7Aey6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3A8560097;
	Sat, 21 Mar 2026 16:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207CAC19421;
	Sat, 21 Mar 2026 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774112075;
	bh=/hnN+ozliJ6Px8FWlVuRJLimEx5AIwMdAryf0AjKiDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGjjhQLWv2jKyxOybLUqwjFrv00W1DecnyBesVTCvLkNokyXcUxyVVKxtKZC1p5fF
	 1wVSSBOPq1fX9VOjAdncIH4151+mqt3hUbEdpgP1xGRxvNuvALcnSjhL2BKQ4mLTRs
	 2YGhrvQnqUenHb2g+IjRqQJBvNJMec/L9ia9jvcuuJz6ZEWucBVYgvLUVblQGOEC2q
	 p6UrKrumJvs+I2tcfOC3QDQOEMwWSB2Zw0IVqpFqNPecAv4iVu0KXeNpIAOHoI1RE9
	 qtXc2uB2IZ7bLzpe0knYZJLx9sBlNeG7P3Fh2K4GYvTmDnH+yvoKHuZ542QfD0YaJY
	 TS6HRbt3hjsSw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sat, 21 Mar 2026 09:54:24 -0700
Message-ID: <20260321165425.84273-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320190453.1430-2-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5857214000A
X-Rspamd-Server: rspam08
X-Stat-Signature: de7g7mrh9s68gk8x8atprsz3f5n3pwph
X-HE-Tag: 1774112076-908638
X-HE-Meta: U2FsdGVkX1/wCSfUWZ5t6ZCBeafz6mn/4+wo3HlZfyPAWdEw7rHUOXMUkttcxfsq9Qi4qJy/ak0yo/CgEuHoDGfVFPzksteJI4nfwzl+GhubHlzKt5oYDImwbt0zP+88j7eUsGqn92qgk6Ib4idRHKMKZdTU+c5jJDnEJntwZC1MeM8vLLjkI/YlYG1DBcCKQpv6CzAL2nuLaikE9MJ8KOK92dvRjic0h/0bt9BS6g4LP1KRrQrxPK3UwqGwEwb6JwpxM1HYLApDLkp9xf5f6PDGhmdIetW8zM+VhVXwvn5eepQ+PgiTZ8A6ONYb0HDxs4GZY8y3uMyGwiLrC8vvv3k+Rk6xKMnZosv41YaCmkX4KLAu0mTuE0vZzfKrduLToVV76flEmxZCKBf+G6u64ih7Y2GrNw0kG16LSRUqgSDjbgJE6jEJTOOeTPh5UM0zusnvPGUIbFFjfaMd9VqtU3EailShqb9gBXlLNfiMtxeGCVATD+IZqYumPS8ueyzW5OQXTQv+mCa8embKpLfBiKI7mBvp75jsshOa4CrTG72r1gNggpT8q+Q3beAV20L73pUWyxpG4yIMzdJWln08xaN6TrlMymz7DGC+kMSIdM4stIZVvPFMOig1RbcrIV9tAZNdkTu84xF6Y6ohd/7VJc9K/GXaV2y+DNh3CDgkGAOyg51QTpcaXcakRcJ5Uein7u9tXzrjVRiyBp22Rpx/4zQBmEy70/PPRGKhQyOpvmHHobHe1mmV3ZTPxqcDnki62IfvrNR0i8wLHro4Gvj+RncUR4db2Fv5FCyhF9beKQUIum2bwiPuQu3HsmqbFhCktapE9Ma/CLkYwqwcq0QccJzrKT4xUvJP7FWrIz4Yp+2XonAccW9t9t0vQ7vhSORksx2srjAdCHX5vgGDsb82kfTKYBJGoSpKzMCnPZ+37T2pwTwGJfe3P0DQJWEH3Cda19peTu7QamQgnEG1jc3
 Ye105U1/
 d9b4fcv6bjXwgdZFge62K/iPY5bZLk4Y2D5wN6wvLuJLBwptT+nWntm6mf+9nqVVprIB8SYqdARJuxJLFoRt4n/5ZcozXInHrgPcHDD6BOqT5DIfj906/iieMNlHJchpAy+Lqd/xVQ4S78MoiXyn0JgSr3zxtFzK6/tZapnGxmI6J1sKb77AZwpcGvU/DaV3QJvVCMTPRFiAloUUGP/IImvAnif3Yuov9brU4M96CCcKmngdoAGLq1W3fz57qaDvsNeoyJ9KrKsFF0F9JkCHcTu6PUoLCB3jgNJxQC/FmFD6F5YS/1pH8vO5f57+8iXRA7EG6FZXcXrccuxD2kxmj4a3EIjpfiP7oJn1lTidv6cxPRfUo44N0RWbXhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 12:04:53 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Add new quota goal metrics for memory tiering that track scheme-eligible
> memory distribution across NUMA nodes:
> 
> - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
> - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of eligible memory NOT on
>   a node

The description for the second metric should be "ratio of ineligible memory on
a node".

> 
> These complementary metrics enable push-pull migration schemes that
> maintain a target memory distribution across different NUMA nodes
> representing different memory tiers, based on access patterns defined
> by each scheme.
> 
> The metrics iterate scheme-eligible regions and use damon_get_folio()
> to determine NUMA node placement of each folio, calculating the ratio
> of eligible memory on the specified node versus total eligible memory.
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h    |   6 ++
>  mm/damon/core.c          | 158 ++++++++++++++++++++++++++++++++++++---
>  mm/damon/sysfs-schemes.c |  12 +++
>  3 files changed, 164 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index b1d8fd88a0fc..490918804f85 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -193,6 +193,10 @@ enum damos_action {
>   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
>   * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
>   * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
> + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
> + *					node.
> + * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:	Scheme-ineligible memory ratio of a
> + *					node.
>   * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
>   *
>   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
> @@ -206,6 +210,8 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
> +	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +	DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b9e12865622c..3e0ac65e34a0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -17,6 +17,8 @@
>  #include <linux/string.h>
>  #include <linux/string_choices.h>
>  
> +#include "ops-common.h"
> +

I don't find a reason to include this, and I'd like to avoid including that in
core.c unless it is really necessary.  Could you please remove this?

Below looks all good for RFC level code to move on to the next stage (dropping
RFC tag). :)


Thanks,
SJ

[...]

