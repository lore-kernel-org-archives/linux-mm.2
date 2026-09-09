Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75865C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBDF6B00AF; Wed,  9 Sep 2026 12:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3286B00B0; Wed,  9 Sep 2026 12:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA0B6B00B1; Wed,  9 Sep 2026 12:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB1C6B00AF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:08:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B194A0293
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:08:22 +0000 (UTC)
X-FDA: 85194706044.02.35F9D59
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE6C44000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:08:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970100;
	b=RTS9zyTOpQW7ikH+7qdDXKEto1Ia6h7OYngow2o1n+eB35CQQYHCdMOjsa3VnfDXpGskww
	hxv0NzTLoLTpw22AuRyw/NC+gw9GpevGJzWlkA9ZgNxMzRSb43O1MQFniEkiJYfbIoKIET
	a7wD5oB7FEgr8AV4qi47EKT8P98UeXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I71CIheSuIDueqiu5rSWBUTO1zgH8vNXvV3i4L+T3M=;
	b=WCvXKVg0C5kPQ3aqQJ9n6OlQ9ZwrFsIM3pnjVU6kkZUA158Pw6IT2ZLhYFhuMjw/+K7jNj
	kvnKZCb4OJSTGTiyTVrZ/7sNX9vp5a7YuxA4W0rty5KeA54Zi5lIEw/DSUM9GGPaLgwzng
	obUuIGDlds+RxhkSP5NowHGMRM92s3M=
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C18B3A02B0;
	Wed,  9 Sep 2026 16:08:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id A212520028;
	Wed,  9 Sep 2026 16:07:54 +0000 (UTC)
Date: Wed, 9 Sep 2026 12:09:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Frederic
 Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko
 <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com, david@kernel.org,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com,
 ljs@kernel.org, sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, tony.luck@intel.com,
 reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
 lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
 mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
 babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <20260909120911.39032d13@gandalf.local.home>
In-Reply-To: <20260908074228.GW4120091@noisy.programming.kicks-ass.net>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
	<20260907081334.1152889-6-ye.liu@linux.dev>
	<20260908074228.GW4120091@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19AMuTGL3VW5jagbOlwR+u7MA3F7VHnB+E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=/I71CIheSuIDueqiu5rSWBUTO1zgH8vNXvV3i4L+T3M=; b=Ew4HNQfBJAW3QvJxL4xhoiz9d8D5iKxdsh10iXdMiDWG2dDq7BMF05gGgIe33e3EURTU9qshCUIWRI2S0eUCvA/2rIUrCApBNkGcwACOZpOkimIjHL8b/x7tJjeaE7wl5Zs/j2u4aimfyEbEUcr1qeLykOSGUaC1FUfmTB//jiU=
X-HE-Meta: U2FsdGVkX1/sjgIjUTzuszHX70bniX8/y4F8byAYJr5L4Kwf+Pq6SiK2LPgzAD5EmFKiynkAadzXM3x4qLo75WXhyZS59ULjI1qQoL45xrhI1eeT5MQRMQD7bu70iZsc+CglwGOHs01oUY4ZjM52NNgq0CB+kCQa2KO+APJ8kTcl3nqnjNjAlc1JFqBxU4lZ2fyci3LxkzioFG2oL8BkseTKqCeVBDEpzStaNBdD1+0SXhinobD7JBj25O6ZQ2QRX+9EcAaF97Hp+dwm4LQdc9C3AJjaDSrgcaZVEvOum5vPIdIBDcRSXlr1hiTDhVZmnQlEKNFFcUytxpY2d+6lRgiyopEE0T/P2K/3KnRoNxkqh992zUZis1LjkJPZxbAg
X-Rspam-User: 
X-Rspamd-Queue-Id: BE6C44000F
X-Stat-Signature: 9bhr8mrf9jecgksswrur9snxt487op5c
X-Rspamd-Server: rspam01
X-HE-Tag-Orig: 1788970074-992515
X-HE-Tag: 1788970100-298939
X-HE-Meta: U2FsdGVkX19C+53MmGZytiByFbvzUjMMIUXVF6h1+2PItW3lXYnsUY+UngtO6hbprNUobh3OBADop3JiMjN7yKtMZwQqOFCg9VzpvqOgi9dUYOvK2DSFAvHyqMTvCaIdbsK3BJMXJQ3m2j8zk0/JvGKwNIeU9mgwEwnTlOISC+w96reLsc0cizkcTL0kSS9wqb23G8pUX6xuzymQO2bjP4QR0bXeScC0gkiXHufdZVxXvAd7Tyw1sEhz9Us1F3vI4B+dxBxIxBYEHyVYBgNnyAX8cAyHs/dEuKVNFHcWacmvt/WRp4I23hwbVNb6MiJYbeWUM7JzbYGCSmD3ce/vI+Kigneb01SLT30uWn6wb8ptBu0il7UIcBOUCno21wOCI00hH5JbTefEcjFChcdi8gHTo2XUUwRhF784c89YMIeJ9aVrHxm25vogg1lo6XxzOfq99WrsJdWIWRv6FpLAgQqfX5xLHUhxNEhuVgXnp3EUMCUDXH/Avx9CvcC0hiW9cxCfLzxaS9F5UHiQgL7RB/s2GWEzfv/Wrl/c4jRBZECEmkq6FN3uUSLu2YB8oTPEE+w7cgE4t+BDsv4/WCxwRLd8wcZ4YPowAlnOKU2C1wkWiA+lqZjof7IVYCFl6inItWJXupUEjGyZXDxoOM73dEtAf7rH8uHJUjnopCma+AgvRRepy+dsRme7PBbY16+G+v8nL0HNcBoB+n7zCWfNyQDoNKguDt/if50WRWdqsDHbf206fc4p3FxrF5dJuKyf5l8iIBkQqxGaz4da1XTXgURvh+a0zJtZjUElX//xlcdbDhjbhT/6q6KK4h31qJDcI7Wq7SXd9jY8znGQIV4vfxVvqBZKKVigsPS1ld8y6GuX5EurKfqPShbWFUW6KuWjR/jAIZspsGcbcHbCE/oDuQI4dJJAsdggIVoMQ80Fo4Pgm04A9RxxwHgxYIhmSKYtRRaZPjOgb3kxPgNbJUS
 gZ2mpB8O
 ta7k/osa5ZcpNUdcguK0cRwv4IqFGjI9eicWFNr5/6cYCca9uI8UUSmIwXSOCyizMhLup1lNvef42MGyo5zCRtADHsn2XrxKbHaXKf68kHxtgTtU7brAEEjXbX27dHhZNkzpyFHq/j+zeB7+t9qZFeNsSglf1l2uwS0Vey8Sa2oGIgatPh+fZb/pREEYXpcrm6THNKZjpA9ePGzL6NJ+zJcoZGc6/CoZck47y+GPc04KYcXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 8 Sep 2026 09:42:28 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> >  kernel/cpu.c             |  4 +---
> >  kernel/freezer.c         |  4 +---
> >  kernel/hung_task.c       | 11 ++++-------
> >  kernel/locking/lockdep.c |  4 +---
> >  kernel/rcu/update.c      |  4 +---
> >  kernel/sched/core.c      |  3 +--
> >  kernel/sched/debug.c     |  4 +---
> >  kernel/trace/fgraph.c    |  8 ++------
> >  kernel/unwind/deferred.c |  3 +--
> >  9 files changed, 13 insertions(+), 32 deletions(-)  
> 
> This is not something that can be applied.

I believe you mean to break it up into individual subsystems. kernel/ is
not its own subsystem, it contains many different ones.

-- Steve

