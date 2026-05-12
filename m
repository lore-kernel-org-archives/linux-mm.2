Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088BFCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8416B009B; Tue, 12 May 2026 03:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FEF6B009D; Tue, 12 May 2026 03:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC536B009E; Tue, 12 May 2026 03:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4616B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:49:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10BC3403F8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:09 +0000 (UTC)
X-FDA: 84757992018.06.AB76D9B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B3DB40007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=e76ZAj6c;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572147; a=rsa-sha256;
	cv=none;
	b=lEJ3YQk9/Y9PbV2PBVngkXKde47GEm3ZBl6DU0b/0eQMdMyzSUM63LLIzMlVFUMT9blg2F
	miUqu0mM4Q9ljwct7o/7jmr6Ag6Sp65Pj/xrlPYX2QFB3oOk3y4avBCZmD39HNx5WXMHif
	ePWu3qoUtdu5IoNGRRpVE5phKt6WCC8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=e76ZAj6c;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9Je9p6iKz0LhJs2B2OBOVnKx7GVs/d3t4vLkYEhSok=;
	b=V2EaFEiEa4YSuTOhy8c8Soy8kEPm7uG6V5TZoQiE86VqJgND6S3694uGmcTkmoz1URV+Dp
	rllS48+sFAeWtZQhzLgQheyYIic1voNllPT3C1TpKrjbOcFqXfHRIj1loDosUuUUULlM36
	UjWiMqHFQUAz4p4je7LDe4anydvLR2g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L9Je9p6iKz0LhJs2B2OBOVnKx7GVs/d3t4vLkYEhSok=; b=e76ZAj6cq9wK8LolMqLtOiipXB
	N0kHt9swwcOBhSpr0VVJrOWwxxqVm7oztBxdbf5Dyl2AFH547HkdGDAGZCPc3J30LVvCj08AZ7QBs
	KlqhGZwml1BBrGa/JaEsnm0D0MVsH+wh7W+kiW8E+O1mUQ1W1wwj40xAvCRQJTbQBF3QLKXxrpgym
	Mj3VB02DVvDanDw11w9pDBKvlqTCdeNlZ6T8KBTyrQST1YypIKh6zJA3g9DKZOsQMEUkSml0D7g/v
	0QKsdOFS3rwVMNXRnL3auGlrkBeSRarMwPSAb1CsgHW8eVZ12SYOIpo93dOFdDVrKGbjGuI6sJZ/i
	S0N3VYIg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMhrD-002E10-01;
	Tue, 12 May 2026 07:48:47 +0000
Date: Tue, 12 May 2026 00:48:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Gustavo Luiz Duarte <gustavold@gmail.com>
Cc: Joel Fernandes <joelagnelf@nvidia.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 0/2] rcu: Add debugfs interface for pending callback
 monitoring
Message-ID: <agLaaBslalzcWhhH@gmail.com>
References: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
 <fd8b4470-930b-4688-b423-2e349f8c883f@nvidia.com>
 <CAGSyskW6T4cbX53gSRZSGeiTct9zHLBo9vsE9OH3Yw_sB1Frfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGSyskW6T4cbX53gSRZSGeiTct9zHLBo9vsE9OH3Yw_sB1Frfg@mail.gmail.com>
X-Debian-User: leitao
X-Stat-Signature: az7t4bwmi3ip1wa6fdj13xqh1jxana3t
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B3DB40007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778572146-127521
X-HE-Meta: U2FsdGVkX1+ZQQ//SBOxV5QS5NgeThb5qaId8jjFehk5qrqDg1l9gsNLqVIDRUzggmtvw+iTt01Z9eX/CFCI21GMWZdRxNBQeU/hiZfFgWWaRSfu9EGW1sYuEFZUUAr0nwF1ClcsPehrioY20I7lO6ShqCti1SW+HLVmPWcxK7qcqhiFXu+DHiHoS7Votl+IU9bPWZgIWGiTTCwQt+BhabdKf6s+pGzRJpAplkJcTAUb9sSF4fOab/E3C7X7YFbUSYoyPHTi6ETBA7JA3UJ9NwaO4hnEwpEyksJ4qNNtOu60ge3IYSUY8NSre0CFXavsrpRugsz2Q/XR54Tw+jQt3mVwS2R0zzpDO515CwmfiA1S3gAB9XZPjWoSidKtNdOwCG25JSs6rEA58gk2fcRn7P/XVwyhk8XKIQ5q2S2Paxfas+S1SbO+xpIzZ1beSgt7kF32MuqRS0r0CVv/e7KO3F/pceqRPPg5kaE56+udg8KTdQttYbh1U2IjTLlS/Ek6/4ot1qTYYnV9OM/kRpznx7ENE1Nn+MxjCGblBmE0EVvqgqBuiUSeKEGvnBiSvU0guf4MYQnEWR2C5xXmCJCAorXkbf+RHqPZJhjxrhFKdDYiz/IqcLTRa2GM2zFeNSVznrOGomQyNCsJxwNj6wAEyqvfDJ4hfPcocUZ7HRQLoSRnjkjGKIiWhKLHjdSiYTP7Awd0EfMl21DUz2SC9EMLpoWp0m7sV8mt9CejKGjA1bT2hmrQhDgKq9VB3tB3ple0iE1SuE4xgbEaqCqjAf+J/Na6Oy37j5sL4u1uVQO3LKRLJLkzQAmsZ++xJ1iB8qu2gp/1KRZSnHYrdpZNT5UxmzpLO5ueLTvlWG7DMMG3Qlb4lkktLBpwUbn7POclt5xlRnZBWP1hmlzBd8DbeG6oxfPbKWHBZQkqka6zpM5RhDYQIb2LIVYYvzTuWKAO9vMr2RWqqKu0wpzD29Gqshd
 xrSkRgIi
 tY2yVJj3dmBvQCADvwK9Sjs9aLpwOtTDgNC+TiduKMUN2oRAo7cJbZBK2DCqVHhHZq0dpCl/5L7QlXEZ7SWQabicKopKP0ZTEkwqkzkVDydnFgie9xRM5ZYhKK/BUcrPDURumPQZyTyiDA8WUBh2FrOYdNA9Dxnijs0xfQaEjSI+q3bu6pBixd6oViHsTHq+gHw8b4K8Fqt3aDfG3kUSeg8agQ2Ev9V1tZNSxPVxaM25++2RI+kN/9dOeRwAtxtA5Qrzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:08:53PM +0100, Gustavo Luiz Duarte wrote:
> > You actually don't need debugfs for this. You can just use bpftrace and
> > instrument trace_rcu_ (with other RCU tracing Kconfig options enabled?). I had
> > something like that working sometime ago.
>
> My initial attempt to do this using tracepoints was probing
> trace_rcu_segcb_stats, but this would add significant overhead to
> every callback enqueue/dequeue event which is too expensive for a
> production environment

An additional benefit of this debugfs-based approach is that it eliminates
the dependency on bpftrace and custom scripts. While instrumenting tracepoints
with bpftrace is certainly feasible for a limited number of servers, deploying
it fleet-wide becomes problematic. It requires distributing and maintaining
additional binaries on every host, just to collect metrics that a few lines
of kernel code can expose more efficiently.

So while bpftrace can technically accomplish this, it may not be the
most appropriate solution for this particular use case.

