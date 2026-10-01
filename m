Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FF8CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67996B0096; Thu,  1 Oct 2026 06:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E946B0098; Thu,  1 Oct 2026 06:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C5B6B0099; Thu,  1 Oct 2026 06:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84C296B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:54:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 114DD12020B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:54:41 +0000 (UTC)
X-FDA: 85273749162.21.71B7D80
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id B446280009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:54:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=la9C++oV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790852079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMQi3pfWB0wiaCHgvp5eiKUKLsxkaOq5Mv0PAKIuKqE=;
	b=f1kuknOzFcfTMcCh9pkQZNa7YzsGETl7sH1ZfWIGlkLukF/dN3dkkRhcs9laO/XjOcVdnk
	81T35vGNTFO02ZwSj8OKB+cNfgZ5gvXfyKvYyF67rfgDdKTwqAujcXFncW2vnROHcnbZnb
	BOgW5teVP7n6GIIsg/mfe0kMGYmrlAI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=la9C++oV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790852079;
	b=U6tJaoOxNt3EaSA4r7uCDnxNoGQo3DodpvWPFNNbLuKUXMDiOwdAzcTmwBrn6um0uVOLWI
	lVuQLT825wa2A1UKQIxS8G/pm7Ey98u3X0Eo2MBJDn86iErOEWnk1VBMfrkhvmTl9GklgR
	/2aqU31kCyffY7e899cgMo/Gs4ePIxA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QMQi3pfWB0wiaCHgvp5eiKUKLsxkaOq5Mv0PAKIuKqE=; b=la9C++oVmy91EssZzyrMx0EQyi
	2Z2A4CAKhpig2EEh/JoYbzxfMSZdRpsk75dwabdgBm56msfF9NGMtsXwNLbBo5Je5P38DpMMQVbCS
	vPOQF2ukfYIISDmrJWMkKKLolN2Ksu2QsR4MXoql+tu63gXEHZcDYh8ym3Urr+98GbbbFciqI3JN7
	V22+O8+OfAj/JqLQj40+ts5CdvGafHKZUpHuWcPStSH2DJ5+dNhaCr+MU881mU5yPCtF3H1Kuq50A
	Ikj+NcN24Kdhfox9zWY/yzhIdsxCiCjFFP8rJVG/sMqP2K89HbjXcxOeLBcG28E4ZBuBTFpInoyq4
	khXNRqow==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xCEQk-00000004rjo-0GEu;
	Thu, 01 Oct 2026 10:54:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B11FD3001FD; Thu, 01 Oct 2026 12:54:24 +0200 (CEST)
Date: Thu, 1 Oct 2026 12:54:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <20261001105424.GK4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: B446280009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o9xscpeet7hzy8qsxndcqwret9kuezuq
X-HE-Tag: 1790852077-70712
X-HE-Meta: U2FsdGVkX19OTFdbMbfGbX5a7UcdS0sd1fuovrpg+QWDxF8OKKkKtlOnIqscFsd8jJq0Kl2Xa0IKOwgnhqo9+kXqcE0ySsG5ChvJ+d9hXWbQE988LLB1ySSuzeuF9vw19B0/RssNB5njWB5gFAtHcW0uIP8ZfeoPxaWJxPUsSRq9y45Lo4020avm8R636sP6mHTRMUbLl80rAjjWMH+P24lAaYSDQXSE5s2uPV0/KM38+OZU87p0m+p/pGXOa/5OADM3nw++VpoJtyiQbDvexeZqN+sIU5I+EsHE/dTfU7z4zlg3kfjoOw5LvFd25//11v9jQbQ0iCWeduB810/myLlxg56xToGCTX0+QW2i0w9WJy/7rlG3cqYdcsTKSxRmyMbyEVJ+Ml5cY6uK2DnlBtckVo1+41r+g2iqJSH4v501SCB972iKWe9F3kFWyP+Eu63UY0WK4AGWQDrkhHk1Cyy/XHrbG5IPQlaJ04uclfrwcJ+WKzBXG9YvVzirrv61WJygTOQD67jEQNJxJFXjN51LRTHRliKeHrGMxUxkqx93CtxFwXeGhLiXKoFlhwBiBZTvOao4FJUJYt+kwQ7pYJs/m/S3CLoELfrcn2+s1lqlEFGykI8yMen9STrxTmf/9yvjAXHlFtvfiQBQl4KFnrD91SfC865N44mTVXCsyKEkpegnNY0W7rys6AxNl7yxm+O+T/LzwfGuCtqnHs/0ig44yiPZHfR98anaLpM+6ObreNGyLQc7KnQbAEyx/PzCvIlk9yEbz+mWCNDjLVnX1dhoqK50v+s+wJJKMe8TXE3E/ii/9T6YnKP0KJDxfjQmmkhFf4dEx3WhXVmEcp+k7cbaEvvcxv3qJPVZfWFWYNQTqczHaJhubgEdh8IT+dAMkN6Y+u4CXhAYs7PGXTcd8/uIz+5Uz8P4az+JZOi6hC2A+fh/39e0a3iN3Vsk/onM0NdesaXSbzxzvN68hnX
 77/xbvzM
 a7w+5AD7Oz8dyCJMbfx126XHNla/LIuB1h6plbW8J8Dhzc5SzuaZinmk4dAbJ+vhGkbaHM/PCg/j2rP89rZEZy0lwt5OTPiCsTCWOt7IpcAyOSgbXqHuRKk4DjK9fuUj8l/R4PrOZ8AZpFF4KKLNExMc6hhVIuG4hs9u1gL0BdOrQAh5kEMnr3itv0w1GNr/Qg7JEzqhX1o+dKUQrrIjaWB59ya519FZA5CIkhx5VombklOAWvS5qacDFJSXcfUHHlB54fRzXD3ULa6pr83Tp622Frqk9SB4HRH4+mvvFTzG5gIZ7eyNZYCKlxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:

> Options we looked at
> ====================
> 
> A. Keep the shared kworker, and only charge the cgroup.
> 
>   A1. Measure how long the reclaim ran, then charge that time to the
>       memcg's cgroup.
> 
>   A2. Let the kworker say "charge this cgroup" while it works, the
>       same way set_active_memcg() works for memory.
> 
> B. Also make the cgroup's CPU limits apply.
> 
>   B1. Run the kworker in the cgroup's scheduling group while it works,
>       so cpu.weight and cpu.max apply to it.
> 
>   B2. Run the reclaim at full speed, then take its CPU time out of the
>       cgroup's cpu.max quota afterwards (back-charging).
> 
> C. Do the reclaim inside the cgroup.
> 
>   C1. Record the overage as a debt on the memcg, and let the memcg's
>       own tasks pay it the next time they charge memory or return to
>       user space.
> 
>   C2. Give each memcg its own reclaim thread that lives in the cgroup.
> 
>   C3. Use a cgroup-aware workqueue, as in [1], or per-cgroup worker
>       pools.

> What we chose and why
> =====================
> 
> We chose A2, together with B2 for cpu.max.
> 
> We do not throttle the reclaim itself. Adding limits to it is more
> complicated and most probably unneeded, as we envision that we will
> need concurrent background reclaimers instead of throttling in a
> real-world environment. We are working on developing a system to
> balance the rate of allocations/charges with the rate of reclaim, to
> keep the system always running effectively.
> 
> In addition, reclaim takes sleeping locks, like i_mmap_rwsem and the
> anon_vma lock in rmap walks, and fs locks in shrinkers. With a low
> cgroup weight, the kworker can be preempted while it holds them, and
> then tasks in other cgroups wait on it. It also hurts the workqueue. A
> kworker that is runnable but not running still counts as running, and
> the workqueue only spots CPU hogs by the CPU time they use. So other
> work queued on that CPU's system_wq waits too.

With proxy execution, this should be alleviated. Then all tasks waiting
on a lock acquisition will contribute to the runnability of the lock
holder.

> Still, the reclaim should not be free CPU time on top of the cgroup's
> limit. With A2 alone, the reclaim shows up in cpu.stat, but the
> cgroup's own tasks still get their full cpu.max quota. B2 fixes that
> without slowing the reclaim down. The kworker runs at full speed, and
> afterwards its time is taken out of the cgroup's cpu.max quota, so the
> cgroup's own tasks get less CPU time instead. This is the
> back-charging Tejun described [2]. It only covers cpu.max.
> Back-charging cpu.weight is future work.

Fiddling with weight sounds like horrible garbage. If you find you need
that, I would really rather you went C[23].

> We did not take C2 or C3. A high_work run asks for only 64 pages,
> which is far too little to pay for moving a thread into a cgroup
> through the global cgroup locks. A thread per memcg means thousands of
> threads. cgroup v2 does not allow tasks in a non-leaf domain cgroup.
> And a kernel thread in a cgroup shows up in cgroup.procs and blocks
> rmdir.

You don't move the threads, you spawn them on group creation and leave
them there. I'm sure you can fudge the rmdir thing with less ugly than
you're proposing here and in the other series.



