Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8792310A62DA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85516B0005; Thu, 26 Mar 2026 10:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35686B0088; Thu, 26 Mar 2026 10:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B576B0089; Thu, 26 Mar 2026 10:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB1B6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:05:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FD9D8CFAB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:05:01 +0000 (UTC)
X-FDA: 84588385602.28.9D8F384
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id 043EA14001C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774533899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzVz9UhisR6vGSyYO7FUeszn7lVZ7MuoiICh/abxE64=;
	b=SJ8cT88oqJvXcf6Nv7vJ/g7PM0SlwetbUVeF5WzfvtwG69lTthMTHg5gC4vOFyNqNpbtkS
	Ail+Ry4Trzvdj6JBz2rRFEL9UEMgQ9YtVnDJvK+ZdMqWloJU+Onawkk5cArtrJZYU0oHJu
	PW3ktwvUyVN6xVsi9KQzxQsS4lqIQSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774533899; a=rsa-sha256;
	cv=none;
	b=r5bIaWHTkY1NNcWcozPnwpgxGZrG20mrocE00Mr1ZY3AUJuuJrdUfoCUImsjxTbRKVdcUy
	UVNkNPJi5o3HjaaS5hZVxVTAqwhU12khpZ2XVzTAQW2hx/5Egfr292HfjZj9RCk8SDj6+L
	rQROZ2fl6FLk6loQTkPbR+nJzgEOAgk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 23:04:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 26 Mar 2026 23:04:54 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <acU9BjGRgGDRWQ4X@yjaykim-PowerEdge-T330>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
 <20260325162003.136dc86796eb124d3c7210ac@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325162003.136dc86796eb124d3c7210ac@linux-foundation.org>
X-Rspamd-Queue-Id: 043EA14001C
X-Stat-Signature: oyyzdwxshptwwzuga6tpjgn8edxh5sb8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774533897-543335
X-HE-Meta: U2FsdGVkX19jU0kVunqXoKnN/jNVD3mAKcqJpIR66TCP+T9v4ygnm6dxezbMbBQ30qmg5+v5JqUKSJ5aVQhWE2WaFaCJnk7+W3zt4cNbRq+zWpnAKS2hx1Pu2OR89qkc08+mJLvExnIxv12k1NG0+5JUpWVjy6MWdYfsFvjYTnUkwGMtWeU+IRlGUjsPDd3AasdXyCQhBbGzEC1nGjj5esUiHXS59C/vtrP97jWBhJPqAdcs4pwtHrGLUuNZcOrMcnAyQDp9DslmMEYLMYAApnq2KpXEPCWgDUByg74RnADnWhClvDg6CHNvf9Ydah39QXIfPccdsXArv26ypRCA0xl9/mozYGPwwW2B07xdYKwJEvc0vdcCdmDrkAIlICpaHsK+EwMtdoIk086Vc+t1dqTpKCo30F/dT+M5In/9Yjm/2NqkS5gnYzLZgtEO5zYDOJpIguEs0X6ozUJFrUNBHeApDKEsqlVqwIRhBfEiPc/nfBFIAxTDDcfvdTJvFXrLRQFvnMegAlejzuQXS8mv3nM1SG+PuIjxdd/f/F389VPDtEygWn3nreie0l3Qr8bqa7eqyVpQddn1lqUsOZjCe3UveiPIqagyWy6MYYqZ9LLrPW1G8WaTpCtRXFkYU86tv0decCHfjYRBGigsXpIAyqLSUBq4UhieILcZv73WeiIOAbmG4y0MnV45Gb89YsiRpHI9GzR7qqqcpbTWlwrcvVwQlrUWjNRoCEF+XwV2NLIbBWhTAfcCH1zzoA8kHF0UzynkfKuvoA3xYKQMeH771EuO8I85XnKFcYtA1wjDDXhZm+DvgSlzX077vlsjXeFgHsjHnrhTXKVVBGG+BViZ1S0b5x+xx1ih0/z/XNJdjGJCnKV7IApfOJ7+SZGxXa9WSjWQG6E9563XHi7brwpTk4PiqCwPpJHqJI0Ti+3biNiZIZPyYS6t3utxJphhY5RUjTwiH5X3gOqxf1ORq8S
 fqHpr8jj
 Q2h89RZBmJz6P7a1hsEviFUzxXtOAe9dEY7XdDCE6zaB3KVgBqTEDIjmeEaGz1iFBHZYe2A0kLVR9PCjwI5ks6qzYaUkFotEApWGydNsq0vQLC/BqJdbY7zuChaQADQDsaDVigK0MIADuXyC5NvuprQcBdEjzfCj9m/tOIhswNFGTtxX6QYx3h1GLI43oOgA7sZoOkC4Brh2gAKda6u4KsKQeZ630Wzb5l7S6IroeIBZ9TanIdPRazOJK+It/cnmH5xxvBdYQMkXmGgvtLcYsW5AZrH5VALDE4MEoKaIN+wqzHaX7xc2STPpBACo87Z9YPTnntz99krymYa4s1gqMK/FfYULzqpDwHPUchoVK0vJY0mk0f0Y5HzU2mvx6cvXHbys70Bt4dyNZVpOWGT2YztaOAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 04:20:03PM -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2026 02:54:49 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > This is v5 of the "Swap Tiers" series.
> 
> Thanks.  I'd prefer to hold off until the next cycle, please.  As I
> mentioned in 
> 
> https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org
> 
> Also, AI review had a lot to say, Please take a look.  Should you do
> so, I'm interested in learning how much of that material was useful. 
> Thanks.
> 
> https://sashiko.dev/#/patchset/20260325175453.2523280-1-youngjun.park%40lge.com

Hi Andrew, Understood. 
I'll address the AI review comments and run syzbot CI, 
then resubmit for the next cycle.

Thanks,
Youngjun Park

