Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40224106B53D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636366B008C; Wed, 25 Mar 2026 10:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7996B0092; Wed, 25 Mar 2026 10:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD2F6B0093; Wed, 25 Mar 2026 10:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BECD6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:03:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D33958C679
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:03:35 +0000 (UTC)
X-FDA: 84584753190.27.087EEC4
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13B94A001A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:03:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ktgIYLtY;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7t76lq+4DYdf4zt4uMNUzUlaUKfu3wh5rJDihRxgOs=;
	b=HXiReZ0xhFhLeAxe8qx/BwDO7Zlg4r+HvuDa3NPCxDqp7qQRkoe3/yTz4Up/JlETOEEZ7j
	egwRPQdgFWv+thZjeevtY6Ra4Qx+JvVG3m6RWMmC/G+QMvzvBzc1CuS9kKrKNrpzlHwKpq
	asf3S6O1smvaRaJDyvmAO/B9NdUCax0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ktgIYLtY;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447414; a=rsa-sha256;
	cv=none;
	b=cFmxtwoK6gnPxfkzW2oY8FSMS4dL23gojLuY796O2GKZYc9OgB4x3LAyAXnu7hxeVUUQZd
	M8/OjRlqvSe8QlcVhqgR0jZlgsrbFCUZtWBt2cHvJPQy0zUloGdz7bEZ+MZ5zt1Eir70Cy
	buJsqG4wfI6NdFNVNcfgr+zhT6ZKKmc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N7t76lq+4DYdf4zt4uMNUzUlaUKfu3wh5rJDihRxgOs=; b=ktgIYLtYWVkXoXspxfWbJV4wRe
	w1LMcNyCticYILZiWuJQ9mr+llxlxHngNu9/EEoOH/LXlYsZRKCUmkJyLjRqRXtmEE532TZh5hy6P
	5lilkJG8QTR0exsg5AwyoSBmSOT6gM+TJw6+7jYJHCIiSeFQfNz5asWHYB908Ev4EwHYI8DV5/dLf
	vWAq70aQdw6clbvzx55rTMLoVu3sqdqofRuOZYlESwojZL7I6grKeClz53M48ll3V7Upf1TTfAOYx
	42MSx6EUo0CY5aglNAUDqUqVedvo+7SXq8dgM7QUbOggEZVLp0hxw4RHyhyPHAVTsek5YOkbLMO3N
	YhVVy9ow==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5OpR-00000006Ijg-1rCM;
	Wed, 25 Mar 2026 14:03:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EE5FB300400; Wed, 25 Mar 2026 15:03:24 +0100 (CET)
Date: Wed, 25 Mar 2026 15:03:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 07/15] watchdog: Allow runtime toggle of lockup detector
 affinity
Message-ID: <20260325140324.GD3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-7-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-7-919cca23cadf@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13B94A001A
X-Stat-Signature: t91b41mjt46j9tucu6of57jq9z5f4oyf
X-Rspam-User: 
X-HE-Tag: 1774447413-30713
X-HE-Meta: U2FsdGVkX1+lxta72/vzmkSdovqUaMf8D3hfL4cUDzEJXGRnCEpPiYp/dkXCkRqYF23eu4z9NSHLRPirR3yKhXpRt1TwuQPIgJPoA5TuMkLdNjuqXpOH4QFbN1q3W3fze/tH3e205OEIKE/6LKszb2jinN0jvZ3Ws6VfpBToLfprUT2qoMbbgQQ05rAXOFeG56dTW+Rj1qcrB6Nmiej+JVqDzTINuyb3apYOJr9yZ9lYHcW70/kDIFc38qRlOZCpmUSj9kS0GFMmvPoi3hKX40UHzdK52sEiq9ywvR4GjkbyXHPBECZ4CqO1ceWFzK+C8LVqgd6VxkEklu+0XHbOwMNn/7r01lIM6EJCHX1kYRPeDCBIFctgbWAJ8HnrfWHqTAsf5sVRViuYK4tKLGsGRxjckSIB9PX2KO3R/3mKhGHIpNpe61gV8Kq50MRBQezeHJVLg4KZ5oO0Nyfgojmkt+1r79dIBkuvw69wzASLzR8BOfw4TL6Pp2SYC2DlMo5+MtM46VMnJtv55hTAr25DSVJKgplI2K02wDd6L551htAgSPeFWNm2CRx6hBW5MxQRqsCpvAAhhAwMJ35wXK4wUp5wWQuHcE4BzL3qTtoxJJNVfmF20jY2Vocnnnqrz+spk6MYQyCePo2e7cn8H+6+wXnh/VLxNj5prdBsxglWraCzWzKctEIdueJ9WohY00NQoltwcJ/3PZTRMZPOjtAHtoXv5baEJiyipzpZau4I42dc1+5mkAzWdgWMMwlTMjgyXBZPkPKb5K9LnZ370j/grMwmPU6LIza6+JI7+vKkIKTz67qezbgbrpllSbKwiNe12+hdEHKYCJMEKxt1Fdn6cPgRd3eVQ8P9Uo7tDt7MYUWr1bIkFgVmXlq2l251Wgxe0/vG5RinOIQOe5WCnk6+Qt8L8l0EyisEDpgsxpawgFKnEk2hDZX9wasf5fwug86jAebbh8z+PWl7aO1MzuE
 4Rv8dpqE
 c2G8EZeOl20OCoc5qwF9cvDAhr3RHf436p2YxX0MsNkh3dvJIp8HD1djPb/jLjuZ7eeg651pYizaPu9aB2Z4Vs0nk8+DA4lzd/S+T/UlXfqCbx6n55wd0AFoZHakPie9pJvTq6tnosnBm6Xv1xOmhyJ63LWwyCdqMXZvBB9LcKK8CIJ1ssSjSD+h9DeLr18NYKVmN9ZdxhEYb4mW+1faM2nO200VCG8J82WLvfFvSrw6clz56D4UDgYaZVTFYHiB8+G8KAK8ZQZIWyk33+6jhIw6cE/m5y1sY8d65
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:38PM +0800, Qiliang Yuan wrote:
> The hardlockup detector threads are affined to CPUs based on the
> HK_TYPE_TIMER housekeeping mask at boot. If this mask is updated at
> runtime, these threads remain on their original CPUs, potentially
> running on isolated cores.
> 
> Synchronize watchdog thread affinity with HK_TYPE_TIMER updates.

Doesn't the normal watchdog run off of perf, using NMIs? How is that
TIMER?

And again, why do you think you need more than _ONE_ mask?

In the end, NOHZ_FULL needs all the masks to be the same anyway. There
is absolutely no sane reason to have this much configuration space.

