Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C28CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 16:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5CE8E010F; Fri, 31 Oct 2025 12:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D864E8E006C; Fri, 31 Oct 2025 12:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C753B8E010F; Fri, 31 Oct 2025 12:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B15FD8E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:08:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62E0CC0289
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:08:15 +0000 (UTC)
X-FDA: 84058891350.04.6A35E18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92C8E40005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:08:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNm3q3Fx;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761926893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gd1NRlaG7p73EaWZZGtzoqnB/qnKqpG/Nvm6jBDd4iY=;
	b=YRC3MUKuOQ8wBbYRc1EMafotYiMov7jPoB0o61RgwiB1Z+72AdRqrv5Wc3o7vpohJF5vTS
	G7ppsK1Bq/lWjmggKBmrC2AqFK2bmLd9RdtLDj2d+KWXoqiMg0e/WVG8ynwFL5kp228Xe0
	oMGuM00RwGoIn6RMPIzSj3QsJFahTO8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNm3q3Fx;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761926893; a=rsa-sha256;
	cv=none;
	b=yRLjf6LNpNa1IrjXtfC0wDup8q2OyOyZAI3RO9OUROMMr9sL0KNdaMaGRrUzKdBhreKpLn
	SXFM7na92oAvH05gBACfMQRdbZg7+u5+AkL7ytBE8VvXIRld2w8Vh/yvcafQYsY10UxKwt
	Z+8WrC1IEWlelMiF3Fi/lkZAQcxKaiQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7307C43AD6;
	Fri, 31 Oct 2025 16:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA40C4CEE7;
	Fri, 31 Oct 2025 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761926892;
	bh=DBnRWCc9yOikTyJAePQMQXl8JnrzRu+fPN1hD2Ld8qU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lNm3q3FxkqsL5QWMXLypsadCbVDHoS7srbuL3umgOILAgP2CmodbUjbmVgoYLqLve
	 gqW5tz1EPBizlAZk5MqElD4DQfIHAxzmtN19JFglozpQKcQGBxYMl7yLPgL06f0Alc
	 Wmr5T7iw805pUJEirQ0gG/+y+Tb8PrWnxbGm6rEfbp7xc7L8cnr1zQFwXjAnhR1hBH
	 leAVv9GH6W28+5E2FEe+8vxpWiPWLa7dvgRWsbm9oHb0ZrOKO2qaDT1p5UMDci9pYi
	 2qfoSEzL1lmFVYHaphzP0WGPUKmYmpipLpz2ALLuOYx0tXFwTP1Ngxt7pTzWQPBIkK
	 d4ltC1wGy9Gzg==
Date: Fri, 31 Oct 2025 17:08:09 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 11/33] cpuset: Provide lockdep check for cpuset lock held
Message-ID: <aQTe6X5XXSp8_3z5@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-12-frederic@kernel.org>
 <b94f6159-a280-4890-a02a-f19ff808de5b@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b94f6159-a280-4890-a02a-f19ff808de5b@huaweicloud.com>
X-Rspamd-Queue-Id: 92C8E40005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yx93duoac8k9fq5jx93asqb798xyt4uf
X-HE-Tag: 1761926893-481994
X-HE-Meta: U2FsdGVkX1/GR039JgPZWWZcLWVM3EvVa2xwYFmELGyy+dy+E+SU2uvO014pXBU3SeCqMb+gE1LF9rnCKq76UhfkAwHNvBXvLh8Hw6hzUy7CDe0+cSpFtrvC0s//gFYpUW+UBiG9LYJIsK9vB9f83T9NXLXo+NKgjOwrEacV3jFAd7nM2Vyxz5r5MysxlK2IsnkLVjHwEf1LVNFKnjpCj77vx4gBNjroj8vYe4ZkkmTw2tAe0oiNbXeLPLnejyFH8/k7Jg6egZua63oIB7knaHvhgdhyn+ArUYg/z3reTH+ArZgDg0aV1Jz/Ww5YLvl9iL6rIDaFvzCt6bk1zmC/x44Ox/T3Xzkwl9OtpnS6o0GSF6+pONgox4L1bBV9HTMNL6PbZzCl4mtJMfNR5rc7gAN1rGl89PB31JD6OUj8edGLNV5LNt1d/s2j7400P5v8Bb3Nu78dTEiyu3RsqKokEroeamHN9xev7m872WX7cOllQgQdnqHP1nrX1Ptriu6ohHIy5k49HKbXqakFI8cQBw6UvuWc0MENoxeWiMHJVJ9t+mfFY0a7b4vC81KbIkqpYGARHO9xhIU2gnuRsCsJeI6T0V+wL5VP8Qso85mn9Lj02wTHqg1o7gJjv66lp2j/KP4T6fWilklpTJ5+vR31kTbvB6XfUL2SiGtVOCoMh77lY5etwqTIHF4FRJT43oFeaiA/ivEjpOVnZdZmWynWVe3qugA0JlDOAy7FjJlU7lWI1UTTsjAdKd6NU3eyfYsr561pufXZR1vSTfujdQYa7q9vsrjeqsqTC6SjVSyQEAsJtHPkBxgy3cyA2HBsUYqIWOzkLAKUKSR+F0pHyU7yKBjmpW7dJTcYjE+hFcl+NR2YMhvuNdCeBf/oAAEqErMVD2Iu1otOyTzvVuZtt5dmK2QnrrjsM7aULJ7cnQaAbYT+b2O6IN4mAzKJ5eI/6xguSTdS3AKaiMzeO31pHvi
 Idf6ZAT7
 uNJz7jo5/+1JE4s9bYYzFCkVU+9rnYj4iZTTW4SaiHN31bZOSPbvMoUnwPc//AXEeKtnQIUSvY+3RPeEpnZN2rX1yuPqRELR+l9nX3H/Qt9bGZuu35nai3KsUes6KuNAcbwOnUM7259eGoh6mTolmbKSyQ7z77G9FUObnWcj2dSQ0tAVi3l0ON0ie6XZi1uV6KkS/MtUKt3oLb2GDlk9MpPSrhUvW/iEDjJRUR3s56XQPPJAWyokwG2wq1bpy8Ecojd7dQYL+/fS5VeZ8v+fZlwsNFf4pgcsAR8oaaqAvl3hAXwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 14, 2025 at 09:29:25PM +0800, Chen Ridong a écrit :
> 
> 
> On 2025/10/14 4:31, Frederic Weisbecker wrote:
> > cpuset modifies partitions, including isolated, while holding the cpuset
> > mutex.
> > 
> > This means that holding the cpuset mutex is safe to synchronize against
> > housekeeping cpumask changes.
> > 
> > Provide a lockdep check to validate that.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  include/linux/cpuset.h | 2 ++
> >  kernel/cgroup/cpuset.c | 7 +++++++
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index 2ddb256187b5..051d36fec578 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -18,6 +18,8 @@
> >  #include <linux/mmu_context.h>
> >  #include <linux/jump_label.h>
> >  
> > +extern bool lockdep_is_cpuset_held(void);
> > +
> >  #ifdef CONFIG_CPUSETS
> >  
> >  /*
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index 8595f1eadf23..aa1ac7bcf2ea 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -279,6 +279,13 @@ void cpuset_full_unlock(void)
> >  	cpus_read_unlock();
> >  }
> >  
> > +#ifdef CONFIG_LOCKDEP
> > +bool lockdep_is_cpuset_held(void)
> > +{
> > +	return lockdep_is_held(&cpuset_mutex);
> > +}
> > +#endif
> > +
> >  static DEFINE_SPINLOCK(callback_lock);
> >  
> >  void cpuset_callback_lock_irq(void)
> 
> Is the lockdep_is_cpuset_held function actually being used?
> If CONFIG_LOCKDEP is disabled, compilation would fail with an "undefined reference to
> lockdep_is_cpuset_held" error.

Although counter-intuitive, this is how the lockdep_is_held() functions family
do work.

This allows this kind of trick:

if (IS_ENABLED(CONFIG_LOCKDEP))
   WARN_ON_ONCE(!lockdep_is_held(&some_lock))

This works during the compilation because the prototype of lockdep_is_held()
is declared. And since the IS_ENABLED() is resolved during compilation as well,
the conditional code is wiped out and therefore not linked. As a result the
linker doesn't even look for the definition of lockdep_is_held() and we don't
need to define an off case that would return a wrong assumption.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

