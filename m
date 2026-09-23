Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8610C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B0D6B008A; Tue, 22 Sep 2026 21:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21CA6B008C; Tue, 22 Sep 2026 21:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11C06B0092; Tue, 22 Sep 2026 21:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB896B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:35:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70A8CC0526
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:35:51 +0000 (UTC)
X-FDA: 85243310502.03.56A2249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2488C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:35:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VrtS+bkq;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790127349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngMEIbTaabSp9OnaFNAXRZtKwgGuZEQbttwH5KAHvBk=;
	b=60q/3Vn/NCS3aDJhOe0e7xP/Cv5Ncf3hOQJy4kn/Wg4biPLGouobwLVSLdJBIJhpxrweHt
	eLqjbVa6YOBh13lT7Z8CDNoh/kj6vzFIPQ22SvcZC/nbIzF2cLeW0MfxF3EpYzeMVlFwzh
	OwlAmzWuagUSaivsKCXeFFqvTxxbi7I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VrtS+bkq;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790127349;
	b=7nOWLPD8LICTDqdvEBjap8LHGl1RTrjHmc4m2N45I24r/j9bKvAocAY5lC4Kp5ggR8rpJa
	VVVoAHBAMVUuyD4oLjJtTMtKXpmSbqRwxQcZNCZuU0J8CNljh7TpIradg0rjlW2ICjPIV1
	HKGAWmCzcPz9YCjF5yRS0+7CHpJONus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3211601F0;
	Wed, 23 Sep 2026 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB94F1F000FF;
	Wed, 23 Sep 2026 01:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127348;
	bh=ngMEIbTaabSp9OnaFNAXRZtKwgGuZEQbttwH5KAHvBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VrtS+bkq7nbM/bIMJ1aDsy5TOCMtXDAWqmICbzzFXOyzo+Xl/TnMj9cikpTsEP2Fs
	 Vi4hqUuSxKGP8/51jriiXvpx+EcM3Ip1RQ9t4PioTGwo+tIqpk1JSEnnTb6OJXCdnv
	 byODjXSdYQxzfu/bygzI/sweUUKWhpkN9ktqYMQI=
Date: Tue, 22 Sep 2026 18:35:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed
 <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ejuj6sqe7trp8q5m3wnqjiirt1crrgyi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2488C0002
X-HE-Tag: 1790127349-402147
X-HE-Meta: U2FsdGVkX1+i5gMnphikw11iL0/7z7cbbNUX1NLjmK2CTsIudSGdvz0ST6FmJqsZ7eHAh7VJZfoUkahDG45Ncd9QPcfcvqkeN5LURpPwZ2Jl81Q4RzSpGhvf4df/PLS2294UhCHpUngBa/2/0wzlSTzcqsyiMwX0Hu+O7+OFG8Bp0VJtzkv2+LPcmaaz5BKrZSnSKgjBPlp9aX8nz+E9YV3RYMSoC+JMhbGl0buqvOUIygxxViwcmQvwy91WJN5CfNXagnOqKjTwiGxdl/eP5bqepjPlV/bHTY1gy8JiEWJLvH/ochTMKHFF1iXFN0EPXtG0tT7F3VKcuLoz1BHyroUPaB+CNw9AJcP3NGG6Q3S0KsTuBlqUkvjv80N0YrypfK22huJ9jxHJyBHGLG+Tcxvk28Vfniaf0L0FCz35bkr/Wa1c4RPvAuZ6jZMQhhuFqW27+LOZAP+fmeBxN0NHVPIPSnAwCHyngcSpqTE+7bk+o+RlkXG47AwHFBKl4CkYqOGqG1XUBKoBE24qXQbKjb3k9QK/Igqj6ZlipUK/ZRxIfh1wVgClyoRrB97LWf5S0PzEnAIF1vg64ehIu0V/sWU+hVhxsuj16hBwij08hHAwZw6j3D33tMAQTMCM7MO+NC3KaOBobyZRkoLL1tK5HnjCDZvD+9yaHTKjBu+h6cNgyhZq8Dk+JNF/4CpJWYrucGSDjc8n4jDcdYptQhs7gV8PEcvGzPKNsKEloOXOT529lgx2r6iaryg6wR3HfN7U21bf4uUGgijP1jRGvzVc4hxoCbnJPwO0dOH30ULSaUVhBE1PEBVcCQWUAvekPdmI8nNjuMXaVGjfdxNQNTlBrByUUZ4kMk1zB8RSvJCpjkGjKhe2BL0KfrnH5R4ACtenvnBqZ6srmVZSWHn526nc1B2uNGqzmqtM6g0jp+K3yVlCmuu1MlPnndHhxmuTw5iZKenI5SZUW8kLR9HN7F2
 zCJxGhXH
 XSLBDT2f4wu2ciDnASf68bMPuXYM5E1Ed5W256PEPLBNYq/vxgwm5bYXe1wxUanLyiW2qa7I+HCrUoGxOWMmD5kbZ8RHdUWffw/dT+xIzYgYkJUFdqIECoyaRvGUoHXr2YrPuegAosA21EZXILgT8Hrt2s9wZNsc7wOFlWD1GBD+55iPcIyBPZk+Nu8DE6PQ2cQx7+3zA/6MRQNMysQBGg8g1E1od1d7S4mLWxOJ+JnVMAQIs/RJzLVI1qLyiLVh/WAR6TOr6YuBaB43D1jxvcQm1J1xXiW7dTKch4SiShXf1vZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.

Obvious question which may have recently been addressed:

Why are we keeping nokmem around?  How useful are its memory savings
and is anyone actually using it?

Clearly it isn't well tested and it increases our testing space (beyond
out testing resources, apparently).

If the right answer here is "kill it" then this patchset is introducing
risk into the main codepaths in order to fix codepaths which shouldn't
be there anyway, yes?


