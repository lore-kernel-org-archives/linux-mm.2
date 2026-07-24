Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC6CC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C4E6B008A; Thu, 23 Jul 2026 23:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D456B008C; Thu, 23 Jul 2026 23:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD4C6B0092; Thu, 23 Jul 2026 23:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65E556B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:32:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE8151A0200
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:32:18 +0000 (UTC)
X-FDA: 85022247156.19.8F63B81
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id A0C6920005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:32:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7Xj4WFg;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784863937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJz7+UH1Fz2MbDbCCcGFwiqZ9h8iEUeKp5pLXvubZFQ=;
	b=Ju72ZzypXWD+jp5YkpLroJmbYvs8PBN02CgymkP20HEYH5x6YJxvg8TPfCgXPGdCPXx7YK
	npb7J0ENJRvuea1qTWGLIuDE/+WdQA2Y1jAUmWVj5aOFR8XbBRLCI/31DeXCp+5mLZ2r+E
	T6yJpNyZU3V1m0XsQitGa23XiefK4Tw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7Xj4WFg;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784863937;
	b=8OnD5a6TUmKTiX2tYsAkZoyOG2Bm5/cW+EeXHDa4PK2idqWkk12TBQiIYghzi3zCWu9f5f
	ju7D5euuS6m1Pw92LhUz7Wi6lPd7Qwy7ZoX7rqGlBNAu8QAQfDVTyMBx17ZPydVMoYeqiY
	l3BMnwVmirodHKByDD6LdRHUZsk/CAU=
Message-ID: <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784863934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJz7+UH1Fz2MbDbCCcGFwiqZ9h8iEUeKp5pLXvubZFQ=;
	b=H7Xj4WFg3XVQ2HVQeDopq5K/8g6Jnhl+OisjXzcj7wbiAiyRNKo0PQCt4o1zg8gOzjdi3+
	utl/Btr/6z1DSHxu82iotWQdzFefduQ6X4HEgyW21M0yNDS5uXIDDOq4bK1jPqjs+jRbQq
	YNtWcXNfgJMFj0Zu4+oQMrHwNmJpS0E=
Date: Fri, 24 Jul 2026 11:32:07 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A0C6920005
X-Rspam-User: 
X-Stat-Signature: 3jtefwwqmsgh6dtwijuwk8fuj56e634x
X-Rspamd-Server: rspam04
X-HE-Tag: 1784863936-916816
X-HE-Meta: U2FsdGVkX19dgWqJke3X08KbgRGLLqbb9NuIl1GqZ04z+dSrNkZilwJltcehjn9a/eys0VR+zDiO7RvAiRao3bNOVH8WgGP/zkCO5KUHiPAJLpN6bYnuVrqgTEOI3mVHeUD5uNMBb+wn5B5mrj7tjJhPOXTzvqZxeHgLq90IgTm2/7itapdBrFas/Hv1Drk68FbKpylh/dUFv5GpFCYaMBAGE/DRDHNfIdBWCiMKkVdyKzHJCt1nGE/BHNFdWBghfdXXj+V079XnK+3X8INUFUxaDjQ3XGfEBkff6WDO6t81p3VqEWmGEJX5+YtmCWoAYZ01H/vWx/VXW8lRJfJmANqeG14pm4ANMGWm5VTeROMZL/Cr1DbN5zlTev9S0D4Nyvgv/dmMS48/JkPveLR8cD0DdRX7UEjxzsxUCn1qM3JMNq641gND76zbnjC6f8tLD1ImF9GVrwnyxK6wH+DpnUzfSkHRwi6fDjMWJxCzIKt1YiuDgM8s1UrK8/+LHCazy/QeQ4cUrcBLTuNpXASWYeXZDH907MkdrfL/tRvWTvSnUtBCpvDL1LjWOtf0JYvT4BaEeMCmq5FTWOUjw6K8Fkntjxza4nCzEgA/5mQo4lF8q0HMprY9duLckIp4PNVVc0de3XUsnqt3WsT9AvAriG76DRxsE//P7SAgr3forMhLXs4iA4+GoJnayQ/CiU4d8rtQKuFHgG8LeCyscCAucMQoSkmjsGs8l307x0lqLQT3rKaHXVtHV9GgTD48uoIJdEhrRkItz18ETv+WlIRchcXDzn0sJ/eAICQnHR7Xvv41pKZo4M7g3sveK4sbEYAc1GIk1ZAFv/0yjCJplDdowFIQ0mInjkZ7CyROjTC3lLZasTW+8N9TDpzD18KD1eiWqLZQIzfYOWo9uf6JijYwbSj41g6Q6SLsplq3YsiHk1BgE2fO4YToR+CTVJ/i/dR4W4QQcJrWiSqBdmPUZKM
 fSRTgsRz
 aHPMi3aF6yRkPQ12sXWx3zQbUIckznO8C2uHDqudARg8gME6XARz/gcL9GqsmTT3PiDWcUQ/CBl5mVOnPJKtIkH9mHiE51LOWWJpomvOFEuIUca36EHWIOSSR8bMk5OuC8V92uq65TvUjGBBRgkf7y2VW+1499KItIelaOWrY7nHEml8K6eaaWziqsSEBA4lBSYq5xXgxpgUWXr8DER09qbcn5D9WpSziajlhH7PYL6XwReQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/24 10:18, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.
> 
> Check the current limit at the start of each reclaim iteration and stop
> if it no longer matches the writer's target.
> 

Fix looks correct to me.

Acked-by: Tao Cui <cuitao@kylinos.cn>

Nit: the message lumps both paths together, but only memory.max loops
indefinitely. memory.high has no OOM path, so it just spins
MAX_RECLAIM_RETRIES times and breaks on its own. Worth a line to avoid
conflating the severity.

> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping. Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter. With the patch, it returns normally.
> 
>  mm/memcontrol.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..638bdc766616 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>  		unsigned long reclaimed;
>  
> +		if (high != READ_ONCE(memcg->memory.high))
> +			break;
> +
>  		if (nr_pages <= high)
>  			break;
>  
> @@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  	for (;;) {
>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>  
> +		if (max != READ_ONCE(memcg->memory.max))
> +			break;
> +
>  		if (nr_pages <= max)
>  			break;
>  


