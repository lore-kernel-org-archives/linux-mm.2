Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3A9C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D7E6B008A; Tue,  8 Sep 2026 03:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114BF6B0099; Tue,  8 Sep 2026 03:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053526B009B; Tue,  8 Sep 2026 03:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAF576B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:42:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72A2C16041E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:42:54 +0000 (UTC)
X-FDA: 85189803468.29.C19A459
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34B04140008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:42:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eh4sqniW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITKIR/SP3MZPnGUhR4LXjkgAnNpOrsRWnH2rgnYP3QY=;
	b=kqOf2CjT9R/OZaOPoY9BvHunqEaUrPfgrg0ohiIxlAdk79pgH/lNkHERlxqFvLW0sIAWD6
	M911A/GQiYWRFmYvYV8OmwjKcY3l0M0/1/qp7noUMy6axjakltNJVEI5ngoywDe3fAsj6Y
	Z6xWeNmlQ/8mOZXnS83woRDwbHq9VX0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eh4sqniW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853372;
	b=RmES9PWqUsBu4gWdTgc533QbeghCsWS9jigK6RM/p+DVUo6xhEzkK54Wf1chglLoBVHLKV
	MRslE3qndxywIwRfsF/x56XRAMW1bDe+1XhACtYLHJEEuYZBM2e/+l24gedXGR2tqAFtU3
	aWa2mqDv2vDsmeibP2AZJVGKTfy5aPw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ITKIR/SP3MZPnGUhR4LXjkgAnNpOrsRWnH2rgnYP3QY=; b=eh4sqniWZeE3YRU+SJi9F0y7YD
	05mJTtjzX+NgbqCMm5O18Sw7waDe3W9pVUUBKaCioirTGvApWjZH8r4G1la+EFB5wFi5fHv6PLXdT
	fkih5RQnAfldrNhepI2xLlxDYzzoc9V+v8GrY4UPiwauhFtbT/BcxeMt6oXH8y0cNY8p/0uJaS0Rx
	s2ZAtsfPTTE+J+Me8AaG/g520HOB+z+CaGSf7cAY5VXpXjGcrW7D+dVxRVLSojGMpIuLzMgwrvbsF
	y/zn6jpykbQGRlvz3LKeDXk8ca9BdoD5mKMiPzM0xBdaLMnUySbaPaf2Zyf5p0S/31zd5pKfkS+Up
	K6TURICA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3qTN-00000006lik-3KGR;
	Tue, 08 Sep 2026 07:42:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CE6E33005AF; Tue, 08 Sep 2026 09:42:28 +0200 (CEST)
Date: Tue, 8 Sep 2026 09:42:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com,
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <20260908074228.GW4120091@noisy.programming.kicks-ass.net>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907081334.1152889-6-ye.liu@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34B04140008
X-Stat-Signature: 8x7x8o6grz87u4rs1hgaj3qsdg7zf9wz
X-Rspam-User: 
X-HE-Tag: 1788853372-797710
X-HE-Meta: U2FsdGVkX18JA7dQfa3DhK3RjYEJeIwMVkCKLKd+BhZhBsiVqfN4Y93r6sy7DLmz0AyI9yoKRliiGeal8O/RSR30ygd1weNzoJh++t+CsYmeJUFtj8/34DFPZSFs5hXxfK3PGrJjV3XrJOq6QMxn+1JdVUxTaUhLzlqTNaIgv+LjK2La0PIdoy5E090yQH/WLyUs3MPj6Am3oJYCN000yBMgTsWr2x4Dh4Q9vik+hvErOEvef/jqh0rZC2kFRastWCINfGa0xBw/4H/mPLKr155uOm/WgliSEunNBsMTU45Ejb5TonxwUdenf2iH4K4zEQK7GNiux8wj9V7P72tRsDZEx0XTNIoi+J40A6AoNS3dGXSJ5/U1WejsJ7GXsPJ6Ag3Wxo9mp/QHjK7458b2WaM721iHqIKaE+COQUoEirrEXM7bH1H41UD4TuIF1OhCf0hKFK5z9G6wRzFYoQOz6ner2Uqvn/aeW/Pc12A/rlpSLnhPKAelHbUkI7Zke2LyApx1qosMpLSz66ApBpbb3y+3klxMFFkrZgYxPj2Yj8MW23Oq8s9wZwuElSk8rSJsa1O5gnS98Gwl2vOnO000tYecPTa+wXqZjVbqWm+gMKp+G1IJFa3Yb0EA+C7kuV1cOkFR8OkcI29doC1c83jQdIkExpgWDhLSeYCl6wGIm5oobE+DURkqqRxVcltJPbgQDOgG3IBT8kWgKAfD2WgpAhxHJ+5keIwQdUl/EiHKoJkG3uF2/fqePTj/8HSzWJvFgD3qacqq3xGZElEdGIUC1SV1tal6eVX4LCOVHquiYengT3jsfKFgYOe2qhnuf5gzELbg7Dk+/w0l0SJ0BmXEquk8FvLWHF5HB01Oeuvlh9mhUSQz8ZLsq7Eof8xrWWI9ssvK9FPLeKAH/qKCxOoulDOADnpuNtzQqDqrzgGq9Gmf3BRQa0yr6cP4JHrA+zmV0/Ch8UA++73d7NyUKd0
 V7MRJaAM
 /nXguQPgIWYCKK18F9O0nvB+7ZCsXnoJn2g9CscfPaDgS4Xagcf1IBazmvf824OE/T0+1C2lEvZ5FmFUFz5Z5Sw2t+fmmgpM+YBROt0eGhxKoD0r2p1CqXqXaWsNOUhsY2e+Ab6NtZxH9t792pkTCvKOyqgOFRxReNLfd0onwVqmTqEjkHfEEyaEG+D+tlCYYVXqyDISawuRLKw5aERK//mMHzGCmj0v8H4XTqOkntxpcni7eJP6tGBYGBdSSd7VyfAxO/L7uZv60zYy4Aozjhk36SiRTJvNm24Pc8HOMbJOiHLbHenSFi4bPoTPVS1amILiX2APciTVZP9N5OWIInfYAhom6ajPnNWhZy7KtuxLdZCaYdgWaQFhk8msEHbmXCvd/bgfVhVWBVhK2rmKfcLjvEw4Dbo/FOL5j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> pairs combined with for_each_process(), for_each_thread() and
> for_each_process_thread() loops across kernel/ with the
> for_each_*_rculock() macros, which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>   - Rename stale 'unlock:' label to 'out:' in hung_task.c (Günther Noack)
>  kernel/cpu.c             |  4 +---
>  kernel/freezer.c         |  4 +---
>  kernel/hung_task.c       | 11 ++++-------
>  kernel/locking/lockdep.c |  4 +---
>  kernel/rcu/update.c      |  4 +---
>  kernel/sched/core.c      |  3 +--
>  kernel/sched/debug.c     |  4 +---
>  kernel/trace/fgraph.c    |  8 ++------
>  kernel/unwind/deferred.c |  3 +--
>  9 files changed, 13 insertions(+), 32 deletions(-)

This is not something that can be applied.

