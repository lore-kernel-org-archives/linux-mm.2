Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3615C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EABD6B009B; Wed, 26 Aug 2026 17:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B746B009D; Wed, 26 Aug 2026 17:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889F36B009E; Wed, 26 Aug 2026 17:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66D2C6B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:46:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDE7E4024F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:45:59 +0000 (UTC)
X-FDA: 85144753638.09.F78D42B
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf17.hostedemail.com (Postfix) with ESMTP id C0ED440003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:45:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jtxGFWwL;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787780758;
	b=4fJDV/ZNGW999cpDhCzYq8VfU1VMlmyg0YPczbgJ+pgGYvgZmyqDPW4pGBcTqKI7GXerC5
	2BcHtoX3W3ADy7Awg5AnlreZJlQKwUASsYavLCFzPNdteUHRJYENYW1H4BNK4R0wR5us50
	krAbeOOUGPtlIlPQ8kafKJSWdK04kKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787780758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Epo1wAqKkMzzBea6gWzXROU1bNa3mA9pf6TzsPxhLY=;
	b=F2kC3IPmNgfNPKigzJlqg13ZST13VDlNXC71H46BwRNb19w3E+hEafoZXVfIYIip8KXJV6
	mHhu2Q5EuikA4XLt5ps2WOfuB/2ukusWt2Yjf+jlkW6Xw9TgJ71nsIg7Vi8wD2f9MZ+0DO
	+Fc0YP9jGLWVVmXb6cdMSsO5GbmfLhg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jtxGFWwL;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=im1e6ev29SXlYnnNiPx27R6n+npPS4nBwC4ipXAS5IE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787780756; v=1; x=1788385556;
 b=jtxGFWwLlLdnV9VOVSCx7zF6ZU4EzNXUFWB9UzvLJEMI7oyKysVM4PvRdfhxq7yfnM9ClIuZ
 +ak0djNo3e34We5TMtGsCsLi4QDPpwQ/HsyzFdKi5LxcIUrmYVHCjgn8VQqmiLvOV/3AuHz0D4a
 m7mZ2bU244UtnKoK1wfjlIuo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:42::)
	by smtp.migadu.com with ESMTPS id f36f976b6e63a41b;
	Wed, 26 Aug 2026 21:45:56 +0000
X-Mizu-Trace-ID: f36f976b6e63a41b
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 14:45:54 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, akpm@linux-foundation.org, mhocko@suse.com, 
	mhocko@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] docs: cgroup: document empty-write behavior of memory
 limit knobs
Message-ID: <ao9eZmOucnSWS9ID@linux.dev>
References: <20260826021753.197871-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826021753.197871-1-cui.tao@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0ED440003
X-Stat-Signature: x7ecuy9fr9ckjym9rpz3zaanh3sp565t
X-HE-Tag: 1787780757-733529
X-HE-Meta: U2FsdGVkX180VtB23uWt0d/HfoeZlIWmyarRLhX22fxjISdziy++xoRW0EjtLuy1dXYykvRN3WTfQ9yVknJKqnXMn0alrH7qpXkCpuf/bwoXcDu69Xxm7nmhIxhPVjRlTAr9IPthu8OjscgUdDONp8kY04wO2ZLeLHYQ2WB9Uw7WWbnLTd/IwR3IcfqBPHOxMb9PjQo0uf/4gCEQ/6i/nFHlWLsNwB4dwO5PuJRSA2Gd1pR8mxdXxTYe0Sm88tlluYAgf4/TksCGhiT9pscN/goDUYVdinCrmdJ1XpY33UDrYY1NqHL1zhybg+G0NE0gG75J+w7GN8qr44v4yY1J2NSA1Dfuy+LlZy9hcn36P0N2xK19171ALMW0z1Cyls4CYDiuODmir48fU7pSqM+dYuJrg/Z+t7a0VcZEQGiry1ZKTt4sGrckhp/CSWRiIf3uB/9bnTnzL5DurmBP0c+n0SfHt3H44TUSgs8VoIF0X0ITNLjTbzYLX2pcPTK4tKXbRFF8K/uqI14NNlpqum6cSmCPrLm1z0lPTawvUHYAOtamgxfBZ/E1NC7+9ua6WfBjsYQY/ZuzeqtQhXCWhzhR0fkZ7YNIWX1aWdRQ/fEmWJ+GERjtKSQ/c+iKpP2QOlDiEE6NwXtQCt5eZnPjMqYsSzVeGOIEGeWbGPfJBNBv8V8JQNsDbG78GQ/GIZ6f40RX1W+krrxiwKMU0n277CjoRWq8VURnkfJnbyKGVIApvCkvkymjnktpbSzCI60NQkBanML79UnXU/4Nprr3nteQ2SHOQvnxrlq+P4klt5RZzwfiSt2nGouL/HuIbFSrJoH+XSZMnCywxQlfIj/pI277iQRBs4i8Vrz50BbVRTGqaOR46ggBlxWBxuywY+ui9WyKo9+vuDpyHjAtvpS8QxIrv/9tSQdX78uQJrvN8Df/O5Fy5HMY2hDunXGNQ2I6MMigaTAnJYTZ5e03wbj+Hu5
 G/Drrpvd
 drfzuNkkP392vPmtFfuF/YXfNO1HwIAKxGn2R7gZsl7j0PgH2OhhGUPquQ5RO3W1qCNMncyMEkU3uUAe2f5Yr7v590w20lgEeoI0OjTMpy9ch2VmIumazga1dMjBhyFIdWYbWH+09qMfAB95Yvmqk0ZIHo4bWr9ov/MhSTbdZ9InDavvOg1qpN7on0kWmDqWnaKMTuVMY3oNkuQw+4dFUGN03mFhn5vWbMx4M1SPvxleV1MPJG0Kbglnh+/f3qBpoV6sJQmalMYSU8XS7IP5e3k0lHYcT0O2O4FQluEyh8D4jG4gh6V/a7LqKzCQ3L4f4k1g/2zKAYXJNUQIbJRrpXpL8Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:17:53AM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> A maintenance script on a cluster wrote an unset variable into
> memory.max of a workload cgroup; the variable expanded to an empty
> string, the write succeeded, and the workload in the cgroup was
> OOM-killed.  Nothing pointed back at the write, so it took quite
> some time to trace the OOM kills to that script.
> 
> The memory controller documentation does not say what an empty
> write does; the cpuset controller documents its empty-value
> semantics.  The actual behavior is that the empty string is
> accepted as 0.  Reproduced on a k8s cluster (v1.29, cgroup v2,
> two-container pod, 384M limit):
> 
>   # LIMIT=
>   # echo "$LIMIT" > $CG/memory.max
>   # echo $?
>   0
> 
>   m6demo   0/2     OOMKilled   0
> 
>   Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB
> 
> State it where the interface files are introduced, alongside the
> existing notes on units and page rounding.
> 
> Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

