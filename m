Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09531109C022
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C376B008A; Wed, 25 Mar 2026 10:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703D96B0095; Wed, 25 Mar 2026 10:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640F26B0096; Wed, 25 Mar 2026 10:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5558A6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:37:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED1BABB59A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:37:14 +0000 (UTC)
X-FDA: 84584837988.02.70016E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7D48F180014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:37:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYB0tzi9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4TOZMFuclEYtcl2PbYKZ0d5Gx1Sb0KFaFIq8VmuWZM=;
	b=GyMcmXh9c9x23RZBZ1nBAGXGyzcplT09+2DsVXbwryQ+5VyNf2nc9rG1XgkbftAkKcU7Yl
	nLwIHa7eis6RwNVCTU3uHRmf1rGXCSYepKhlcJSn0zlrDcOoSBUFs/HBLSnxgWswzNtpdT
	zFYtwcTG9cdI9zQQs4qf3rIfa437iuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449433; a=rsa-sha256;
	cv=none;
	b=Kfj/Mzjqrl1Y95h5p4QheCTqz5PfpOqbB7Rb9fSgwXn2o80st+veGpJzZHivFrKV5UmgOk
	UjsgT5GrxL6XQj7+iCwr+NmJsnBHsthomzHccv6KLNco++70ipQ1RJqORM1Sz8+H0k/Qbm
	o9gQz64uWJGqU9BX0m0cYU8W0IrVhJo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYB0tzi9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E994F600C4;
	Wed, 25 Mar 2026 14:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E8DC19423;
	Wed, 25 Mar 2026 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774449432;
	bh=kzxr6iziOgx3cpwmvkHK71eb5tyyGmHmzoyABIfFnL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYB0tzi9A9EK0nHYa8snPTfbcS2M4dvd/Ebaes8OjbTE8Va/XhL6aWUGDlKKtyMc5
	 jf/N2QSDbliXmUy/uvlQ/VtHICjCcxMk7ON4IuZRuvNW2oq7Ai9m0wQFPiCNXxmMFH
	 PjwgaGdMrgYgaDVcyLyhd/ihWHECpfIhUN3XPuUSqc8Fj1d2PX2kASOqQ5DUrB9B9x
	 x/WDCdAmfsfDPV/inMhkqZ606+ml67MGvyq6wjTAMyqZ/cK+nCda6xSUObxA7jNgqV
	 AUDUrQDzKZpftNi7pEMhA2uXAYW5j1/zXF93MU3h6i2rOllPwnfvORg9Mlf3/3dSS1
	 9BEiH58rt0hcA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 07:37:02 -0700
Message-ID: <20260325143703.87583-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325073034.140353-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D48F180014
X-Stat-Signature: asqkmeop5ba9s4nt6us8ebozwo6e3jww
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774449433-374166
X-HE-Meta: U2FsdGVkX18YDNcnQjTyiTlB+laBF7FoEa5bzUxql4ooJgN1nTDl81Q15ydF/6aC51nCQsB5HTyIhf2Mzs7dJ9L6xGFjJ46/80OFd1cnvA9FJsM78t9oMI+b43HtBtGQAwj9+PL+C2uVNitaOaeyEJIMTCMekoS26D22fKOLGx5GELrGV7bmmdRHuyjilc0FpRImsgR77CboUOaxVKnC5O5aWFnK8nAu4RzaKrPhPY9UVVHr6/OAnekYLrsZWnAduLw+Y/uSHU8KVK06AAO9mvMF8rxMbVhloPoP+EnPwYeFsh1AoJPEBp9Mm82/TCusY/AQlfURylrpL4VhD+6Z0U2k/EmWICpC2sZ3OQ96zdWNsdM2mU21YRuEXLhxZoz5bz0tbdtDHL5AN/SB+qdzAVWC6PAg/yUjOVHTRlJ0cf8ZIAQVB3upGwfVmqX/0tK+ndrOQnIGpUWpgUswf/4sOZYhOLsbqLLTwLNA5ZP/XKJHVorg6t4r/lgyrUuu2Nmq4WzyQ4eItGai18Q+8B5Xib2RiPUf4Q4gV0Xg3aYsqP90ABUfB4A7UxBbytDAd9gNNKwPxuUPNHr0+jH0X+Xjw8oB7M1PvHPHE3SlPz1qgjRgfvtUh1UxEJLeSejxPYdNfW1zpIiKQKNDp6EMBBlg+FLk1URQJoB/+lVeoSIch0ZMrNKFumvzibfLAGYXtjSzndp4poFjPa4MbzIiPlzCgtc7aiYgk/4sEW1Bm6RF5b5yAFrnxZM7hsqd+9lfflqUU5K4yM4apmuCO4kGW54HVTVCAPZJK8rk3q0RfqY4gddLpRkop/4+Rd8/0lp0DY/msZXTVRZm91p553C29M0r1nxVc8CsHdhu5RvZgJAOm+DeOBLu+B8YmUxVOT+0qrSHCLj8l581qffiQrYdufTpNZU9eNQW08dade8onQHlHzpHBS1bKlHsMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 07:30:34 +0000 Josh Law <objecting@objecting.org> wrote:

> damos_get_node_mem_bp() and damos_get_node_memcg_used_bp() pass
> goal->nid directly to si_meminfo_node() and NODE_DATA() without
> checking that it refers to a valid, online NUMA node.  Since
> goal->nid is set from userspace via sysfs with no validation, a
> negative or out-of-range value causes an out-of-bounds access in
> NODE_DATA(), and a valid but offline node gives undefined results.

Nice catch!

> 
> Add bounds and node_online() checks before using the nid.
> 
> Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")

Let's add Cc: stable.

> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  mm/damon/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 59b709f04975..6ee421141996 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2227,6 +2227,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_online(goal->nid))

Like damon_migrate_pages(), how about using node_state(goal->nid, N_MEMORY)
insted of node_online()?

> +		return 0;
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
> @@ -2243,6 +2247,10 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_online(goal->nid))

Ditto.

> +		return 0;
> +
>  	memcg = mem_cgroup_get_from_id(goal->memcg_id);
>  	if (!memcg) {
>  		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> -- 
> 2.34.1


Thanks,
SJ

