Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0584FC61DD9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 14:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA116B008C; Sat, 29 Aug 2026 10:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BB66B0092; Sat, 29 Aug 2026 10:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5AAB6B0095; Sat, 29 Aug 2026 10:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 902CD6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:49:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A051120173
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:49:52 +0000 (UTC)
X-FDA: 85154591424.24.B11C2E7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id C0A8940006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:49:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OvozmjiX;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788014990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX1FLvOIFSHuqgjqZXoyvcWzn59rRJ4yAy3cPilBPfs=;
	b=a69VSAIh0cPbKg8YHBie7X3xTSJWB5qed7xzKWXEeMyj8uOsIl3mU4CHezJjOdjDTSnneb
	YhVWKQ3GagYUyC8/SCVIClZNeHHeWj/nqHYOV6TXFu4qBu4uNVMU9KIR2gZ85dFhoGD/y3
	V3raTqs3j5SdyluNGr44Ugxis0wvZOI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788014990;
	b=LPtzt+I74YFeSLYWIUZjYjdia6j4EI1hD5ODAVXHvjnClilR/9oI/VMy6lX8JiKE+wRuPR
	x2orw/Kv/fbsKlpGaPPZmdK1ww+yL4i3iy2cXaqWYXMS+A6pwyQUlOsMku+X9km0qGIjI8
	xookIj3TFm6qDqOjkeW68rbT6NhRKq0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OvozmjiX;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SX1FLvOIFSHuqgjqZXoyvcWzn59rRJ4yAy3cPilBPfs=; b=OvozmjiX5mFbDoB4jSgTxkNxJ5
	Zfhj7AJNCi2u1p2S6ieZ3nMrvkj151vzofRuiFEtBNVz43gfPB5P7/Oa1vbTIskKCIYUXSrO07ppN
	OiKsyqHdyBhlVSw78tpf1rYf+g1rT66QEZeH0x/zWKX8tst6RBW1U+4WyQFQlRjQUUXCwlnsbDBbb
	idHkygyLw05rNiH0LzWDD+blm0X/hIK6DUYdKm2oQJZAulbAmC5fFqheRJehMiJxsOO7Cqd8ORGIs
	3YicaqqUsyNU956MFxLwfQJ5/3Eq5JxZwq3wNIO2WvwMUIvUjQMWbQkYm4ij7TR9l6nMPYkOb0OOF
	7lzqn0VA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0KN1-0000000Gbyg-0k1Y;
	Sat, 29 Aug 2026 14:49:23 +0000
Date: Sat, 29 Aug 2026 15:49:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Stevens <stevensd@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <apLxcg3Lgy0-nXA4@casper.infradead.org>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
 <20260829084901.GA776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829084901.GA776954@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0A8940006
X-Stat-Signature: mti5xapa4wwiritx49kszoechze77m5c
X-HE-Tag: 1788014989-947496
X-HE-Meta: U2FsdGVkX18jkgeDUIb+JSSmjahCOvcskclJ5+lEWTqCsxWW35IT5Adm79Kj0ou5ZZymOWmKfDrdvhoi9sQ9GH+TZfBs4DjK6ThE9q5TBSY9Ash7mxYvJpqGk3zemJpSF4NDYmyOU4IUdjrQ3PWyVCX9h6rOI8HJX2U25nizgJVnPED9PRikBvfCVT0WQPUDvaSpbJVUNoWV8vVCmDWq5Vrutwd9mtsOv2+vsOfhcsxCcYAJHOFzdt6rgfWKyeLXfGD9fsqMTQY2RXW+MafP6voRme64T8vWlNznDd8BY6JCJ+ac8hLaU/eg7TovxuULAD24ZkTz95h3HMjDKzNC6N8GWoYXUzY/j2E15njeuZpXn6PSQE+Zpt3KbZFiJgTHIZsvOMG5VkUYRHvIdQe0VSoyj50svrmdULNag50PshEgXiArI95wa/uCb/Gyk0tyONx67P7E88kfjWuAtG9sAJWy0N7xdtnNShJSJf3ehnxA+k62VhN5nudzusUNZRIYXy4g1yBTcn/Qz+XlFv4NtrEOg7dLYHVhnaRnpl3CMzKVY3mYAbZ/rwOm6LH/VkLLEAFgVfTmqNRDspuwFNMYDZlRbpgFyswcZmJKl8Qo1YcHZ0xB9yZha0eLGu21z/4Gp2rVkEw42aEZFB9Ihm4xqPv9ENaJeXQmgurJdUPsCg56mGK13a2QRTvaErwAxi0vxpNH8tEwJFsX1RyQr9sUaUE6D7ixKkHxuJ9EWGUwEaWeNxiF2MLvMprk1qlKj6enye/ak5YZeAgta+Kvw0XAbQXqxfjYOW8wzUmYhrgyjzAKJXcIjFmgKvkequQoN3tQCyOMV3u0vpGeDDkJef2YPiR6KiPqGnyTSpnIwSCcgIXB2HzvqyeDRJDvwlB1vNAxYfgsQcprKn4WNBOM2Im+V0eGWD+rNIWyG1HZ6+Vx29Kbb9A2bZTJEEjR+LLxA8CLH9khZhb4broicqMqkuW
 hXG4IKpj
 cYb7wPE8G+pI2y5OMROPqwu/N2yvM1eLyEoaYMNb8s+7WhzlmM4OhgZsPTli0gx0AxQMMTseg0PPjev1EvpJkCvHE91Xst9B2yYZq6g2godNnntZqJBVMRGkveEk3hCj2JSmWbg6kMJU0f2HIzyuB0zIm5M0jcbA6LWyy16Lngz72r5FYhnK/s1yyRowCRxmEfRpajShcMPC4pS6sZmoDLtSnVO2FRTrwQ1WNOA0Ta8gWHQvURl1NQ7CjQKHcmixX4XY2JGS7pC6OeuQUWP2wOpFOJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> > On PREEMPT_RT, it is necessary to skip the call to
> > alloc_pages_nolock_noprof() from under pi_lock, since with that
> > configuration spin_trylock can end up needing to take pi_lock. But at
> > least on !PREEMPT_RT, there is no risk of deadlock.
> 
> Yeah, which puts the lie to that horrific hack Alexei did. We should
> probably teach lockdep about spin_trylock() not being safe and see the
> house of cards crumble.

Why is spin_trylock() unsafe on PREEMPT_RT?  It's not intuitive since
one can mutex_trylock() in interrupt context or under spinlock.

