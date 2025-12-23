Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF76E6F095
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 15:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780B46B0005; Tue, 23 Dec 2025 10:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C0B6B0089; Tue, 23 Dec 2025 10:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603816B008A; Tue, 23 Dec 2025 10:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6B16B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:18:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF827138087
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:18:01 +0000 (UTC)
X-FDA: 84251091162.25.72EAABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 18663A0009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:17:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWsF7jIJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766503080; a=rsa-sha256;
	cv=none;
	b=pkmtbbXJqxJrBsRDxnSCokFcN2oL/ETPPfDwSv01oWhwi40fbSx9+aEmjVgfFZ0nEAE8JU
	H2G+pxx5c9jSS98buoy4JSxBIgKbXredUG0Q7KUP+hZdidLuuNAgu7LpTAq4YLpQ0MRFDF
	esOPqRit31/DiGArBTClXOASgrG3rjQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWsF7jIJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766503080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTeynD7R3f8TSWusp/I0+MZqGGvggeKphRRbdhM4fhk=;
	b=Fy3BT34kAiTJfI40CRdwzkp3uVCQkFS+gGKlhO5EhiH8WFRKxviCEnR1aze+ML8MCtbuIO
	D17V38ks6zC4gx+pPz+ZqhF9BBLabX+R0SsHlO24Po5qkreKLC65atHckHT60OeqdVlhi/
	3YNkKfZ5hKtp82WIEwbJJoxLZzqxR3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED27943BD0;
	Tue, 23 Dec 2025 15:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C86DC113D0;
	Tue, 23 Dec 2025 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766503078;
	bh=xHMvPjpKyxjB5+zEUkjOy7aEQZr7/WEBY7QJCb1Hs8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qWsF7jIJOslT8s1S7u/8bjnxl+YQ/1ByeQ1ewt/+rY/9WYG7O1ARU2wUEC0MpvUkt
	 nJ29+l60fflZZupPoGJY+iB2n0drXAFhG9mh6pnuMBJb+Q3dWKObeiO7STxE+Fl2lq
	 /KJl7wC7I4QxiKm6M1Zpl1TE/4K8VCzBQpRQArSOLRIrhIRdNuylIsV4o8rCr8jETr
	 eubw6Onv5VRePw33jttvcPvJiaJCMvHFthEnaBXxiGC8xSNdWgKZcgBD+Fs1McLBoa
	 6Zqxp/0BvGVhgeE0KZ5Sh8GsmQJZ+tbuC+UMA/z97aVCaWhHitaOxuz7S+m+nR/Dcu
	 HtgrcvRm/JsRw==
Date: Tue, 23 Dec 2025 16:17:55 +0100
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
Subject: Re: [PATCH 17/31] cpuset: Propagate cpuset isolation update to
 workqueue through housekeeping
Message-ID: <aUqyo58-CDReEm10@localhost.localdomain>
References: <20251105210348.35256-1-frederic@kernel.org>
 <20251105210348.35256-18-frederic@kernel.org>
 <e0b3f050-ef2e-478e-9e22-5f800b86ee42@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0b3f050-ef2e-478e-9e22-5f800b86ee42@huaweicloud.com>
X-Rspamd-Queue-Id: 18663A0009
X-Stat-Signature: j66rmaoj75nf83zyo6ddduscpcc8m1oi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766503079-486235
X-HE-Meta: U2FsdGVkX19QT4fe4xMSM3cefpXt0RqhKRbgRW6e0CFVT9rFyLapvApxgi9QxAmojHeunoex5n2H9eUJ6DNLR/FHQAUKZNwj3H3hoQSIq7W1Ag+imziURdEcnSipfmysaXoU/zXHcAi2PQxGTt4PQt77cPy88h5bxh3JMrh1/jtHiMFARuZCbrpp7xp32K+Vb6ZWrbkf/xNuK+MhVbRxmHvyXCllX2qoh/j/SQZi5HAgHPps2RNWSOo+oWqK4BJY8Yw2nqAXoGtgxXMbjrwx46x/TUR8zqkO+6BABGhKd7A2Nt6UrkoH5P4g1AIEZ3AH4BbnzVMR+Vum/IzrtUW4K8reW+qdTFhF6A1hoMWRqadyPaeJOIUJ3qyqlssKcix9c7Vmwk3fGveWK1l5ZoTPFVdAX1PqaI6Eh6yYbc5/TWMXDjNxd0qB3huLFFk/whNMnOLvlbb5uEm4wZJq3FXc+wTu2t5UZ5De3wvE8cyCRL7e5XqZ1NLwxjcipO4wa2GjgWpNfYAPKxD6Tp/LhPvTNd2s1hdN4fBvW8/QxVCv+4fW8HkgN2t5bpmq97g56TBtHR/oMxwLinGihxELh18trXqRXdYnq/g/nPUt0HYjttFLHENPOIKv2Rg3bRBAlygwzOcSbTjoXnUwMKbC+JjK7DLiazi5WPdIWqQFueEicR7DKCO3EPdvyx0Ufiojn/EvGD2hukYIezso9J5mFEquZ/fqPNnGV9UJyFq2lMRmfSnt0W7qERS41M+Wxt4iY+4JW/LNCSrBk3EJ0xJBMEhu+KS5Gp/hP5MEXEyemyi62vW0qySQw/QS8VjYs4hXv/UJbDgo7snTwj4+8L6AMBZr7hI1RQglkIOibImp4osPqDejrL/1xyKmW+hGOqh03FTfUgAcFbdkCD0p6Br7FQk22p09yzEvSVgrCHJ8xiKZzG+WbbBp4Yj/WGDhRBRKF9edSby+JbNS8xRPL5KYML8
 nLpsug4N
 0Ro1BnwYQzqNTvMCbinJOkMqIXlyG1lSq4NV6NTUO0QcNJWoifpYk2FPXw8C/Tr+uh2iWSbbItYwIJosVj3iTdySz2h9e2X9AOT5rZLv2uZbWkC/ZMhvHHB5/QYiB/pWhsSzeT2I899kStxCltVyE46fj1LBoc+S6Ewm8iKqPihaLCBdjL7v/wVEdvjO7rm62ixh93+OG7P1OSD0ahQtyXP//k1NEJDUxyutg6Z8bcxYMylVKuioLVsm+P1e84imgENy+wWm2EhPpBcotNKeKgKuS1qLgF8wQ/hAZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Nov 06, 2025 at 08:55:42AM +0800, Chen Ridong a écrit :
> 
> 
> On 2025/11/6 5:03, Frederic Weisbecker wrote:
> > Until now, cpuset would propagate isolated partition changes to
> > workqueues so that unbound workers get properly reaffined.
> > 
> > Since housekeeping now centralizes, synchronize and propagates isolation
> > cpumask changes, perform the work from that subsystem for consolidation
> > and consistency purposes.
> > 
> > For simplification purpose, the target function is adapted to take the
> > new housekeeping mask instead of the isolated mask.
> > 
> > Suggested-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  include/linux/workqueue.h |  2 +-
> >  init/Kconfig              |  1 +
> >  kernel/cgroup/cpuset.c    | 14 ++++++--------
> >  kernel/sched/isolation.c  |  4 +++-
> >  kernel/workqueue.c        | 17 ++++++++++-------
> >  5 files changed, 21 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> > index dabc351cc127..a4749f56398f 100644
> > --- a/include/linux/workqueue.h
> > +++ b/include/linux/workqueue.h
> > @@ -588,7 +588,7 @@ struct workqueue_attrs *alloc_workqueue_attrs_noprof(void);
> >  void free_workqueue_attrs(struct workqueue_attrs *attrs);
> >  int apply_workqueue_attrs(struct workqueue_struct *wq,
> >  			  const struct workqueue_attrs *attrs);
> > -extern int workqueue_unbound_exclude_cpumask(cpumask_var_t cpumask);
> > +extern int workqueue_unbound_housekeeping_update(const struct cpumask *hk);
> >  
> >  extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
> >  			struct work_struct *work);
> > diff --git a/init/Kconfig b/init/Kconfig
> > index cab3ad28ca49..a1b3a3b66bfc 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1247,6 +1247,7 @@ config CPUSETS
> >  	bool "Cpuset controller"
> >  	depends on SMP
> >  	select UNION_FIND
> > +	select CPU_ISOLATION
> >  	help
> >  	  This option will let you create and manage CPUSETs which
> >  	  allow dynamically partitioning a system into sets of CPUs and
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index b04a4242f2fa..ea102e4695a5 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -1392,7 +1392,7 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
> >  	return isolcpus_updated;
> >  }
> >  
> > -static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
> > +static void update_housekeeping_cpumask(bool isolcpus_updated)
> >  {
> >  	int ret;
> >  
> > @@ -1401,8 +1401,6 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
> >  	if (!isolcpus_updated)
> >  		return;
> >  
> > -	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
> > -	WARN_ON_ONCE(ret < 0);
> >  	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> >  	WARN_ON_ONCE(ret < 0);
> >  }
> > @@ -1558,7 +1556,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
> >  	list_add(&cs->remote_sibling, &remote_children);
> >  	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
> >  	spin_unlock_irq(&callback_lock);
> > -	update_unbound_workqueue_cpumask(isolcpus_updated);
> > +	update_housekeeping_cpumask(isolcpus_updated);
> >  	cpuset_force_rebuild();
> >  	cs->prs_err = 0;
> >  
> > @@ -1599,7 +1597,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
> >  	compute_excpus(cs, cs->effective_xcpus);
> >  	reset_partition_data(cs);
> >  	spin_unlock_irq(&callback_lock);
> > -	update_unbound_workqueue_cpumask(isolcpus_updated);
> > +	update_housekeeping_cpumask(isolcpus_updated);
> >  	cpuset_force_rebuild();
> >  
> >  	/*
> > @@ -1668,7 +1666,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
> >  	if (xcpus)
> >  		cpumask_copy(cs->exclusive_cpus, xcpus);
> >  	spin_unlock_irq(&callback_lock);
> > -	update_unbound_workqueue_cpumask(isolcpus_updated);
> > +	update_housekeeping_cpumask(isolcpus_updated);
> >  	if (adding || deleting)
> >  		cpuset_force_rebuild();
> >  
> > @@ -2027,7 +2025,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
> >  		WARN_ON_ONCE(parent->nr_subparts < 0);
> >  	}
> >  	spin_unlock_irq(&callback_lock);
> > -	update_unbound_workqueue_cpumask(isolcpus_updated);
> > +	update_housekeeping_cpumask(isolcpus_updated);
> >  
> >  	if ((old_prs != new_prs) && (cmd == partcmd_update))
> >  		update_partition_exclusive_flag(cs, new_prs);
> > @@ -3047,7 +3045,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
> >  	else if (isolcpus_updated)
> >  		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
> >  	spin_unlock_irq(&callback_lock);
> > -	update_unbound_workqueue_cpumask(isolcpus_updated);
> > +	update_housekeeping_cpumask(isolcpus_updated);
> >  
> 
> The patch [1] has been applied to cgroup/for-next, you may have to adapt it.
> 
> [1]:
> https://lore.kernel.org/cgroups/20251105043848.382703-6-longman@redhat.com/T/#u

Right, I just waited for -rc1 to pop-up before doing that.
v5 will follow shortly.

Thanks.

> 
> -- 
> Best regards,
> Ridong
> 

-- 
Frederic Weisbecker
SUSE Labs

