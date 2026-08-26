Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FC0C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BC66B0088; Tue, 25 Aug 2026 22:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3976B008A; Tue, 25 Aug 2026 22:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8300C6B008C; Tue, 25 Aug 2026 22:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6264C6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:56:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C998FA327F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:56:29 +0000 (UTC)
X-FDA: 85141907298.18.20DD43C
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	by imf10.hostedemail.com (Postfix) with ESMTP id A01EDC0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:56:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mspJlBhs;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787712987;
	b=tqrYHdAJjkJFvl3FUOdkI7JEhaBDgkqjenY7c4ZPqAqZ9s5xyUZxYh8i3xmG3hbOqwBG/G
	2qkwIj6fzZEGe5ZvZUZv2WB3ktuoH2xpin5mKYK80a+5l/87XtzWjbXXruyR2371+FYfaS
	qayhRMdlDoJ8SwMU5jeBPZqA078W6Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787712987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fC2U3YgAD19U4Scc2MHVlUMHPhwt1k2+ss1/vnbj3Q0=;
	b=MTwv/gRlpOyY9TvR19B8D79j3PkqnteAl2TmYqHR3fj4GGnkNSLB0TGVANztxCXK+xlBRS
	dArTirQGQgw+JAE5GD1PfgUdDkU2WNWRg1tTwvKBS6nhQovbnQ4nlEtVo2ebzCUD9NcpIy
	SCFeaSdu41QwH29qQhRmAVJtlsuwg3k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mspJlBhs;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HZYjrb8/ZziX4qSQKv1N6qCU+IzCO6UVMJye9TdsnNw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787712985; v=1; x=1788317785;
 b=mspJlBhs3O4GXBuUiQbdcs+HRPkqfFlec1tIs0S229OjhCtWtpAAnA8ph2a0nGPirKWp74r1
 aMcTb3O+U77mACn4aNhUio1ZNyauaKe62WWPcpNXGDHvpwhrHohQgaEp2l9lCuThp6ThePFwUiE
 fsKf5wZrakL6MfYfe3AtPL9E=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id c7d4d76eb3de895d;
	Wed, 26 Aug 2026 02:56:25 +0000
X-Mizu-Trace-ID: c7d4d76eb3de895d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 10:56:19 +0800
From: Hao Li <hao.li@linux.dev>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org, 
	rcu@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
Message-ID: <ao5UqBL4iPh8zlpG@fedora>
References: <20260824091838.1692153-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824091838.1692153-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A01EDC0002
X-Stat-Signature: kgqu78yss77znkketrwetju4zek7yk34
X-HE-Tag: 1787712986-763871
X-HE-Meta: U2FsdGVkX18ijqJCODtPfc4tgTYr/rrRM60Jhmy9Avtlqz7h9QJ/ssQqeATwlEvkdP4TgBtBlhHzN/M6kAAPBk8eNGq2MZbm2IpTms1ZXTXdP5JaVrOBA7n+r2Apabn6ApW9HAq3H0fVmy2G1JE5aihULZ3McbrBj+sjuu4zwgHHqfXZFBTUyGRpThUfzcMPWRJbajn6xPH6X0+jNGUJdmFi9dNuXa91a7fV0v70IWkJEuuJZfomHWZH2hyl9abCoaWLz4rOH7GqF87P9SlzWf1U8mMeFxBA9b8VtPERsOtIIUZGowPw0tsVE7YQ8tEfRETFivUDrnQld0TGeIrWtK3lGsu+ueclFakh5ZmKZYBQzuZloRV28B4N9b0NdCfRNle30dvGRT0fYRcJY1qui8249Ra/7xvSdEUvUqyCTujNrN0+w7cITlgA6ctsKkw0+RaPSExAKe28PHidLxxJs0+I73TfAKHJIihIiyg+kVFKVMsFLEtfne6by3ETbwo1GtRNyxSmPw3FbWLZG9sCtEQ3bB3xmFx4X/urKMFCJpOP8OgPqfSySCUN3ZtI5GwWZJaCnONcPAsHj7ydFDv0sAMt91PuQMDfeIpnxLN67DOD7krKHGO95AxGMp7ZPTbF2n3zd6UY3VhZjx/oXrRCGJIS1vD2eOon73zQVvl9eHMb4PRWZG8z8p2USHvcYESApc4/4Zy/KICaoTjJFTqjh9lgW+lUez+G3WTRf6HLJ5n/1Tl2py1tSfyzEgO2W7QmpF+gzW5mMhHCPLlbzCnm2Heq5BoQ2HJszic0QhqiTkhAgVcivcDc5j1aAfGxO0idPuceuwgPJHqDHivUaJ/bY6aS+XZhSvOsyAcEoaHJEK2hoOIDugjZwpe+fEC2W+pwTctI57ZYQZWI5rB84XRZYWpKwdJ2UYSqmJdJqj91n7VMI9xEQHDsMFdyOR0wFdD9lT8zihguakkKd9HEybp
 aA/JEiqd
 XFAZmzH8t3goiBlCu2/QnO1U9jrD9Oxqi7yS40N8trZoYmA0tQML11LehS+oVq+tDLcB2T6V1iyRt5csaBEWdZcdmX9oFzsePjiZpCCnkA+FSO5Rjn/JBH3iQKA3XAjHEycntoKF3cDDHhPRqpZE3JGMSdFPltvFiq8+FhiWVPVq6n9OnI8db+g162nXOI0z22gfUQ/hYWy6Z5mvbo5tDXUvq0Ka63xJrZua1Ca2kYDvFd8CNFdUIOLVaGN1mRcmE1aNYxqUWyx3Yzwl2M7GYrbVx0MOP9H8Vt/vLaVhuRHdYZX6A7l1960vI9FR0z7Y+WCnp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:18:38PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
> and then tested the result with <= 0. When a single CPU's object
> count exceeds the remaining budget, the subtraction wraps to a large
> positive value and the <= 0 comparison, which is equivalent to == 0
> for an unsigned type, never fires again. The scan loop then iterates
> through every possible CPU instead of honouring the reclaim budget.
> 
> Reorder the logic to compare count against nr_to_scan before
> subtracting, so the loop exits as soon as the budget is met.
> 
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/slab_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 657fd75776ea..95ddbab290d4 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2172,11 +2172,11 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  		count += drain_page_cache(krcp);
>  		kfree_rcu_monitor(&krcp->monitor_work.work);
>  
> -		sc->nr_to_scan -= count;
>  		freed += count;
>  
> -		if (sc->nr_to_scan <= 0)
> +		if (count >= sc->nr_to_scan)
>  			break;
> +		sc->nr_to_scan -= count;

thanks, this is indeed a problem.
I think we could make the code more better, for example:

1. remove `count` variable
2. add count to freed directly (also change type to unsigned)
3. check `if (freed >= sc->nr_to_scan)` then break.

How does this sound to you?

-- 
Thanks,
Hao

