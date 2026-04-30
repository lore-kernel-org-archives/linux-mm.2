Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A73FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A2F6B0093; Thu, 30 Apr 2026 09:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A7A6B0095; Thu, 30 Apr 2026 09:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78506B0096; Thu, 30 Apr 2026 09:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75B46B0093
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:08:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DFB7A0A46
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:03:51 +0000 (UTC)
X-FDA: 84715239462.13.722CB2D
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id D83FB40047
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:03:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d4Y47WcK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554213; a=rsa-sha256;
	cv=none;
	b=ulVlYFWzrWy0Cn8ihclIv1X0exJ05svYX9hsbnadKAvPki80VFBxjp+B95LraMOAxGPWhA
	zRH77pkowB8zXSB1U8TjLKbTC8fD9Jerhxc1y57JasKs/3fUb81vbD9QqzNqki132r3IwM
	q/YriYNaTrxYrszeGxrqX2he88hEbIg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d4Y47WcK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48UFhuUrS/5CKzCRf6cET806F55RZ+asmMEzp5H3pjE=;
	b=zeZOqU/PG/QYGfPzA1kwDYrErijf3czFtcc6GdMQ3f214gKt0XNXlJpx3NFmdIm/btoRmZ
	WOeQqBPcY3nX7V352i24WGOlD+3rfHTuirvwa8NliNALcGR7W2blI75cJwnPND33+lwUL4
	dy5WE9hkCvgh9EdHLaXTzRAz8E3fe5s=
Date: Thu, 30 Apr 2026 06:03:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777554206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=48UFhuUrS/5CKzCRf6cET806F55RZ+asmMEzp5H3pjE=;
	b=d4Y47WcK8SMHjZKcK3wFwqSykiALyGWunDOn09eKb4GbUzLB16aNBXWrZMhduas8+OIEU+
	ZnxP+j7MHVjXm/IM3DX9xWvDzVivMWgdLOawhDgFj8pFGL576eU+SVq1uyB3h5hxe83qnl
	/uHiv5pWfjQT0+cVFvR/jK/XVLcZU10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU
 loop
Message-ID: <afNS6UJjUl_zQIHS@linux.dev>
References: <20260429084216.186238-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429084216.186238-1-hui.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e7tjegos5j1ttr9u6a3cg6o3jwpiedtw
X-Rspam-User: 
X-Rspamd-Queue-Id: D83FB40047
X-Rspamd-Server: rspam07
X-HE-Tag: 1777554212-998
X-HE-Meta: U2FsdGVkX1+/T9KJ5uQCH1A+Y58HthA1q/xocNA7gpBE9UKPvuFjiMDLOoxBRyQQpXy6wZd5eDR2I1eh1jMQZPDb9CS4oqvD3po45/Tw9HeNr/UQAvGKvqTFXvnYfeBQAKgwd6lMdHmV8xcCZsG6LcNNZUCSSnBe3JLnCx/FrFL3bQQR/+zFLuON/J48Qbs3/G+mOlsBvTqRW1FJ9CNfk0n1OS84g2KGX/Btvj3rWf5sOizzgECWf/ywZQ60vXREC9eJ2Udta+77iubPvKRHYHj32eJlGCyqw9i+lG8fYN0YnnDc1rgzSm24apG6EgaSa1rmwGpcuLV8wKxWxvwIu3rw7cObtEuojCPOqOj41qrsl7bGHVd86x6x4FtIhtZjKYo829EVt3LrusgEEaHSCJjTuU034alSXwVs+7cCNAhgIQP8d6OyBlfYTCTcqeMu4OaD8wDPJI85/k1B1zyjbTD7LtwmCN4yl7Mm9pmkS+TcBc/nXvz9EoL6MwUPUqhGj6DmTw+N1SUeHc7h4ET4I+q3TulOm0HEHFfKmP22A1z4i6OKX21BaK4X745SxQroDi4WKxGzyWBT8OxI/9E/WuBdDHGpYu6ABf8uYjbzn5f1BH/b+DUErSPWcnMFPUhvtQsrWTjikYqlcRtOs30/8B0mf0vxW1fNXqk1PidgE/dCVaY6lTCuK1pBOmm6adusQlx8oueCmRPu+7aV+nXHjYz1iYO9oYOsFUZoNuQkvkDX2EPZ+lKsFrl3FL3fze/lXwXDtsv/rPEwsY8CFr3juaNqa4FSZ0QyuyZptv5Fa8pA/uahhIDiF9aKvCW3bS+EnVEFKrsdTFm2Lz9eBS2oU8cb9edr5XA8EkPlniiKtZH5qeBI3jhzGSmF3ysyOnphYVGd2T1sH3wThsQZJ0vYK8/xFV9CNpR2klYCCFK37r3I10U2FUUf6DEHwlGYxdGBizlYbUtkofmvD3/rGvd
 5mzsuW6G
 0eKyEHcgVTWfFQLOaoXvNR9wWWVOS0yU4REFR5RJMJTPgzJ5I0jI4S/QiSZPmfh2eSfkSpPmDm+0k3xzILjzZo5JsSl7kCfnHPKjfHgW5wi9neaUE/kSdExBxbc4eLSHBteLMOlF7GiY4aPfXPyia5/1OEZIoPn7g5U3qIOYV07nNPECSIr28+qKZ+rN98XYecf6NycrTZxkKlI06lDDhPIKtEpBYuZaIlIlLv+p9yr26vxr+jeMgZlzGWfckwiyhunlP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 04:42:16PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
> with respect to the for_each_possible_cpu() loop: both the 'parent'
> pointer and 'parent->vmstats_percpu' remain constant throughout all
> iterations.
> 
> The original code redundantly re-evaluated the 'if (parent)'
> condition and reassigned pstatc_pcpu on every CPU iteration, then
> repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
> storing into statc->parent_pcpu.
> 
> Move the single conditional assignment of pstatc_pcpu to before the
> loop, resolving both the loop-invariant placement issue and the
> duplicated null check. On systems with a large number of possible
> CPUs, this eliminates repeated branch evaluation with no functional
> change.
> 
> No functional change intended.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

