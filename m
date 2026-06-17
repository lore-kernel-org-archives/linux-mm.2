Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2648ECD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00CE6B0088; Wed, 17 Jun 2026 16:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED94C6B008A; Wed, 17 Jun 2026 16:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBB16B008C; Wed, 17 Jun 2026 16:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0E4F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:40:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3350CC267A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:40:39 +0000 (UTC)
X-FDA: 84890572998.28.7DA7A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 66A1B40004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:40:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gylbkn5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=nOb4=EN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=nOb4=EN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781728837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvEnwrbAPa/pJg7QIpc03r+TzOKPlfQjHrFj1uoaMwc=;
	b=BGD0RNGgkn08SFdZeBTPYPS3m8KLuiMw9SlA396GEUdvvsaemEzmqVvtrR7zKbVBSmcDWa
	S4meUHW0ZDJlGHU2uPdE1PLZRqy1ADI5MGaC+qHZApuKkgtk72Z5T/iSUFKO3T3TUpcplN
	Ar09N0fv+ZsPpzD4l+uE3/ditP2kQOg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gylbkn5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=nOb4=EN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=nOb4=EN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781728837;
	b=e5bkDnWur0CXzv9zSkU3t0zcEODnldxoMDaXLVBUz2ae5ewUYybj7Y2Yo2kkcGSalwWz+g
	YNAA3ZW1QnaGfERFqMA2do6QxLrkdMfdRg6mQaJa1BDhiDAVUJ0RXguZQaLbhwx7dlJhO1
	IZHCMl3j4Ku3R0uX3M8EKkxKXOxtUj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F6F544140;
	Wed, 17 Jun 2026 20:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DF81F000E9;
	Wed, 17 Jun 2026 20:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781728836;
	bh=VvEnwrbAPa/pJg7QIpc03r+TzOKPlfQjHrFj1uoaMwc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=gylbkn5PU4X+qaVT2pQyl74j/WSjRQWrKsuURN7hn4ompKgYAjbhUzMRoBi+GSCUO
	 cLIDzdgF692xY3/wUsGWcMxF2jPcw7Zg6qPxMDMEUYJgMjEh5ZDQt+uEg+lC2hlvsa
	 0elmDj41ytZWORBXtwvwLGcZWnfpS1xHQ/hCQQNsoYdu8MdSJj1OUoi7zWh925Z+1/
	 ydwZ7ia3625Hjxq0keojNKHc/pMJHyNlL3Bp2/jJjx6LLaQ9HUGfHl+gdIW5qFBEdw
	 Z/oJtM6GAU0Dko3RbCVsKcX+gako9fxvDVuxF4mqMLGKEFq7vQHwv7WEmTs8GHBY5d
	 Lyczkdkin9Y7Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E9DC2CE1113; Wed, 17 Jun 2026 13:40:35 -0700 (PDT)
Date: Wed, 17 Jun 2026 13:40:35 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	rcu@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
Message-ID: <03da8742-3790-4428-84b8-11911bf44c9e@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
 <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
 <9d8ca1ed-bc53-417f-944b-d78eecd1e6a5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d8ca1ed-bc53-417f-944b-d78eecd1e6a5@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66A1B40004
X-Stat-Signature: 9nuipbcns3mb4445ubtmxnbh7ggwhrig
X-Rspam-User: 
X-HE-Tag: 1781728837-617516
X-HE-Meta: U2FsdGVkX1/spwHEGqoITC6DkRGlFEyq+dkETblppU1lSrttpjmu3kql7osaa7o7OKl2XVAs+LbpJEO1WrUO2zSqmZGUn5i19zOOlqtVsL/CywyTAbbiOuxDzoiskaJ0Xz7SGJaL/nCaUmqc1BiQgK2m6umsL/cfB+wJZprkJxmgFSUxhQRm+egPU80iJ5Q+BFd6aa+LFhn3rert1RkFaKyd1dYkU7dcMV+B8QxJYbsja1dKZe08zEpSJ8ugcYVPQKxJqkeEiM7fW5r8N6CgvDyKR72RKm70bLXrT3oYvQyBcmhAyScOdbd1BSnGDmlnKzE88fnHpxpTGpnfyhkPmoOLpXPjrcv5VpD8XfZ629fw0Ld/JAAXnPuCzwQkil2Gou5FOljYAxu9Kx5Rk4Nu1FAbehxW91WWFjVWzpU3Iq6rdRSBMwSkfELIVIJh33G3H72aDzGalUSbkGwmYCMO5Qz4WiR1e4fLN7eFP06KAQk6KxwHJt+Ugre2aEF3bq9BTqE8VdoIAg0GtfTiQa1tLDk47oHnjukaRr3Dea8RXXb7sLnAJ8DrCMEc+xG57IR7UPxeWYYK/xK89tef5ZP9OzKpountzMrt4uIbSN12aqIdCi97jyPUzltqS4M8G3Ft9l6IP53WmaD5KAy8q99y/xfbfv2Pzncn8XEBHSt8b6WOUmVMj1H7D/eXjYaLmZAWgh6iasLMyjIPPbQJRZQeqZlKdIuhYanLQ22sbabxwnBY3505z9zVbt65b4LFBjWwff2HEIRLA6ze4FbtQIi7Bn9/O/fHRV0onlTUx3FSqGT9QJdr6KT/o0BwxZah3J1Oa31hW6nTKjevXJ7JsSGq3aqi7XiKrAsuGpAyiN405labeSt+HIYn8iE5K2Xw5ey67KaP6/Tij35jWL6syXh6HYeczNMC+vEuLqTEaQ6FtnXMzSwmgVM/CviJkRhuXEY+0M9cRGBF0i75bYb/axD
 Qj4LJFlF
 GnhBBeJ0QGMcJqlb7SM1sGSe3YTVsjQtUdnPVhIj+q88XEaBQKGzWquyeTL03V6VR+I64HXGxaDw6W6PfmNnsVBkfYVReJ2vK/yxfLeXOy9Hb5gfeIvTH2v+uW+/Dm/qlIWtDi2rRckuu6Pi1PmJrerVVc5hRC0i6bGfteA1QWURhnMFdelrYvXGgyo6XFfuRG2ciarJlNzCgafi3XCncdYCdvMjy72DslpoQAra3dwp/KjGCiFVBsUf3JwNtuXscbx4c+0LfAcAboYtUIZiGKmpvoNK2Q10dY9k8nkkgWWDhIp6nW51oeD3+y2gq460wQ6O7lYuzbpIama5dLCjC2vMOvWwfCbwXKlvIlFfvJEquYvjQxZGBPbHx8iifpgg9KwJ9oO/pPC/QfTc1Gngqr/cnRt9oWervZ+DI3MA9Z1FrKqlWGM7RL8rz0+QSWpGtcmjfTeCqkJ6EvRN99EWplZj/PSvXO8TCOPd31wOyD1B0gEiM7WetZSERSe8/dCu7RtUxS3VnJFIXjnwvujsLKFVGpX+YIGOiK8lweO8WhiHXLR6mYJT9VdP0DWQ78FOJ5OU/Awrf/zZr984kJIhgCnnwfBbqpn/JFWIzsUDH7JhOMBZaOkRqWKl/KrnzBU7ly5WmnS1Wj2n6nBGStI0rUP4PqpN3lSoFK5tyf4qj7cRskWI0gyIf+1HwvM8VXAQoCSVg5oMv/V/wNuwolB9jPFTqZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 07:38:16AM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 07:14, Harry Yoo wrote:
> > 
> > 
> > On 6/17/26 2:24 AM, Vlastimil Babka (SUSE) wrote:
> >> On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
> >>> As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
> >>> on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
> >>> This is because local_trylock and spinlock_t are safe to use with
> >>> trylock variant as long as the kernel does not spin and the context is
> >>> not NMI and not hardirq.
> >>>
> >>> Now that __kfree_rcu_sheaf() knows how to handle allow_spin = false,
> >>> relax the limitation and try the sheaves path on PREEMPT_RT as well.
> >>>
> >>> Keep the lockdep map on non RT kernels. However, do not use the lockdep
> >>> map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
> >>>
> >>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org
> >>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> >> 
> >> LGTM, but maybe unnecessary pessimistic wrt call_rcu() on PREEMPT_RT?
> >> I thought (in the Link: above) we'd only need to downgrade allow_spin to
> >> false on PREEMPT_RT for handling sheaves movement from/to barn and
> >> alloc_empty_sheaf(), but call_rcu() would be safe from kfree_rcu() even on
> >> RT?
> > 
> > Indeed. Good point, thanks!
> > 
> > Hmm, but I'm not sure that it's worth the complexity given that
> > PREEMPT_RT tries very hard to avoid disabling IRQs...
> > 
> >> Or is the irqs_disabled() condition rare enough so we don't care?
> > 
> > Given that most users don't call kfree_rcu() under raw spinlock or
> > IRQs-disabled section on PREEMPT_RT, I think it's okay to keep it as is
> > (it's not making things worse, at least) and wait for call_rcu_nolock()?
> 
> Sounds good.
> 
> > On a side note, I don't have much idea on what needs to call kfree_rcu()
> > under a raw spinlock, other than set_cpus_allowed_force(), which should
> > really be using kfree_nolock() instead of kfree_rcu() once we support
> > kmalloc() -> kfree_nolock():
> 
> Looks like the case. Well if the fallback path of kfree_nolock() that is
> irq_work_queue() is indeed safe here.
> 
> >> 	/*
> >> 	 * Because this is called with p->pi_lock held, it is not possible
> >> 	 * to use kfree() here (when PREEMPT_RT=y), therefore punt to using
> >> 	 * kfree_rcu().
> >> 	 */
> >> 	kfree_rcu((union cpumask_rcuhead *)ac.user_mask, rcu);
> > 
> > Any thoughts, RCU/RT folks?

For the call_rcu*() counterparts, I am currently considering making the
existing functions check for interrupts disabled, using irq_work_queue()
in that case.  I suppose that I could use raise_softirq() in the
use_softirq=1 case when in_hardirq().  Either way, the check should be
cheap compared to rest of the processing.  The additional rcu_barrier()
work required is of course way down in the noise compared to acquiring
a global mutex.

In your case, kfree_rcu() can be quite a bit lighter weight, though.
So the extra checks might not be lost in the noise.

Thoughts?

								Thanx, Paul

