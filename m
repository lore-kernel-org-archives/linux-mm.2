Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535BCCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7028E0009; Wed,  5 Nov 2025 10:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EC58E0005; Wed,  5 Nov 2025 10:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4458E0009; Wed,  5 Nov 2025 10:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44DFD8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:42:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F355313ACD0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:42:42 +0000 (UTC)
X-FDA: 84076970964.27.714A2D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62316140010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:42:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qW/SfRcZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762357361; a=rsa-sha256;
	cv=none;
	b=n1Mf7c3ALhzF7Km5L0rpbmuVx2777synM97g40IfW+NzoOOnr85S+mKJflyABYn+mu83g2
	wSAYWhp9pFVCf74wqyw1Z137awrCjC+CkjB/THkBu4ZnWm6B778tbE4PiUSM2un8Mh1u9X
	RNF1+aC08GW4ZhrwwBc61xy8saff4Y0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qW/SfRcZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762357361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69Av0KmPY+24sP5NTMN6vf2Kt/djTSytmW8AbmQUrVg=;
	b=FUFAF3XUHfSsmuHB58B02SS2eYdD0yx+RdSxgo+2/NZaHXXhXmuv2vsptLGAANP84i7+Cb
	hCW5Yn2gXmEpGvM9NR+4h90qauAaCkBT0/g9a336jtQeU6lJAOTWcSALw/SfKoPuxHcjUT
	Q2JskCGpiWiuPJiIb+aFP82wVcRb+b0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9999E6021E;
	Wed,  5 Nov 2025 15:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C476DC4CEF5;
	Wed,  5 Nov 2025 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762357360;
	bh=boPYeqvdKW7/3CnEhFVgNn0FsAC8XrMy6K95gzM+WjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qW/SfRcZancAa0hsqKFnQRd29sYyNjQPo/6bgXUIdWQkQrCQ8SrjNfLEv2gd6QIbJ
	 KNvHuiS8u4kGDpix1rUv2FrtZNIpRj8+YRbgkYtOcqokgdP5Lelomta91mDjj2utK2
	 pJNN+t5ySqiy5B4IWOvfB+wUu7vtmplfUpxRFlJl/ItWWlSKTIKtO8NPw3lyVBm6hy
	 PX81LQiCi7jb6e0lest8AkXP8Ttp7CHR2CEtZJBks+yM2bue/m166kiurBIXHdyHQN
	 xXNTc0DdAqJPwKz19FVfa5KCbSwDOT4ZdNrwR2USJYY4x2nd++Gx+PqPUsZ/tGWHsn
	 0JuvFbPfX+vtQ==
Date: Wed, 5 Nov 2025 16:42:37 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
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
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Message-ID: <aQtwbRrFBCUoQ2Yj@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-14-frederic@kernel.org>
 <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62316140010
X-Stat-Signature: phshc678usj9rdk3ryykcbdrnhkxo44g
X-Rspam-User: 
X-HE-Tag: 1762357361-427992
X-HE-Meta: U2FsdGVkX1+SLoZA+baxVvXfycxB52utfuZ7/WQn1kSm/qGYNroNQ9ik1DERB6L5kxuw1SR35AafCcm0uZCa5nficIB+L1/zD/2/yqEXwH6qMbFU+PvYGr+eEHrSxxoTFNmcLeTHeSWDgk+aUQwKDS+tM3RUnijThUvjilbR/HeCZ9fhQXAi+snfQ2kIInYixBlqP2IjghbKo9MGmX1fbDB7rsneDFmjJK+hK3PbDkkF9KLvN5xT2eBjmU6O2SwYuM451SL7nwE8u39hNJ1h5cTpNiY7Fw900cPIqu1P7roCv7fKMe9Az0PjtoPtNsGHY8twAMSuppJJMyGFM4HCPhcOGbHLhQi2ZbUe/rxYCzAMPhs+oLJrjLBghm2KwPtj5i/PvAuq10p9vVrJLK8TTjWFBOM1lqzyOXKGOmngoYiiVBSKi+vYEXmsrf/6zu7YvS9FJzXDtz2kaNeaMRVw+WUaGfX5jftfXzKUxGOS1pBxA6JrxO9ltlsbAezPiL7LGWlvvGOylnEICdkuYpL5qk5WhNdCN3EC/EeFSUO0aE1t2fxv4Ir94g8K7RhyZ2kcfplpls6kjXZyzrTADM5t2T0KNloND9MrS9VPL9iEuUBIA9kqDLtvXXGi8rXjQbwMV776wywlJGMlSxaxXYJEjfOP//0eurKrp4xf+kX9y15KEF1D0Uc8h9fB0464yBxKHnpLfGFbwdcU1qDttjaMBM8gU+5xSfZGg95QC408EORkyMy15U41wZeBGcL6eZqdf4pLu8Q/8WsqxEYY9GPKuv4L3G3L9VLDtv+N/EiQUJ7BOGiAExcvHWrHHc7rNpYS/AE26AeElDvXBSwrGstylfX5gahabsnEObIwI9DUSng5f38aEm2ZMFQajtO6SguU4wLRHcs+ogPWCLaJj2vejAJ88lS09z5rwhhD8yLKEi3a+yuQTPKqcKvA6UOybioz6Tzovk1XPHr7odX+1ql
 /EqozsBQ
 pqKc3d7WOfOp16tHSv34VmozeW8AKfKv6rv8/vCmTtuj+vNlgFRhOG+Qrjan0otAtwu6CGW4S8DN6H25ylfHzp+zHsuvFAf+klmllBE4GzW3dy3DG0yaZkbzYY98B6Vq/NG/NPF6clTmM/PQPht2K0iGM4AH85NiGcCuglLLyQMSiNHLJ1ZCEl9X0GSGO5I3hQyv5ORBX4Tc9dCM1tSDM+wjVtohg13Zlp44FRyof5v2sWFcCbNsSwYzs7QAyOlM5bPaDvFHVDvjkqTdg6w6FL4/M1+osqWJHp96wvwESeCb/VH/XgzXeShvvVpBZkOy8IV8QO9igHuM5tpFovlQ0Q7WoNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 21, 2025 at 12:10:16AM -0400, Waiman Long a écrit :
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> > Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
> > CPUs passed through isolcpus= boot option. Users interested in also
> > knowing the runtime defined isolated CPUs through cpuset must use
> > different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
> > 
> > There are many drawbacks to that approach:
> > 
> > 1) Most interested subsystems want to know about all isolated CPUs, not
> >    just those defined on boot time.
> > 
> > 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
> >    concurrent cpuset changes.
> > 
> > 3) Further cpuset modifications are not propagated to subsystems
> > 
> > Solve 1) and 2) and centralize all isolated CPUs within the
> > HK_TYPE_DOMAIN housekeeping cpumask.
> > 
> > Subsystems can rely on RCU to synchronize against concurrent changes.
> > 
> > The propagation mentioned in 3) will be handled in further patches.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >   include/linux/sched/isolation.h |  2 +
> >   kernel/cgroup/cpuset.c          |  2 +
> >   kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
> >   kernel/sched/sched.h            |  1 +
> >   4 files changed, 74 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> > index da22b038942a..94d5c835121b 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -32,6 +32,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
> >   extern bool housekeeping_enabled(enum hk_type type);
> >   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
> >   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> > +extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
> >   extern void __init housekeeping_init(void);
> >   #else
> > @@ -59,6 +60,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
> >   	return true;
> >   }
> > +static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
> >   static inline void housekeeping_init(void) { }
> >   #endif /* CONFIG_CPU_ISOLATION */
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index aa1ac7bcf2ea..b04a4242f2fa 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
> >   	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
> >   	WARN_ON_ONCE(ret < 0);
> > +	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> > +	WARN_ON_ONCE(ret < 0);
> >   }
> >   /**
> > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > index b46c20b5437f..95d69c2102f6 100644
> > --- a/kernel/sched/isolation.c
> > +++ b/kernel/sched/isolation.c
> > @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
> >   bool housekeeping_enabled(enum hk_type type)
> >   {
> > -	return !!(housekeeping.flags & BIT(type));
> > +	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
> >   }
> >   EXPORT_SYMBOL_GPL(housekeeping_enabled);
> > +static bool housekeeping_dereference_check(enum hk_type type)
> > +{
> > +	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
> > +		/* Cpuset isn't even writable yet? */
> > +		if (system_state <= SYSTEM_SCHEDULING)
> > +			return true;
> > +
> > +		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
> > +		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
> > +			return true;
> > +
> > +		/* Cpuset lock held, partitions not writable */
> > +		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
> > +			return true;
> 
> I have some doubt about this condition as the cpuset_mutex may be held in
> the process of making changes to an isolated partition that will impact
> HK_TYPE_DOMAIN cpumask.

Indeed and therefore if the current process is holding the cpuset mutex,
it is guaranteed that no other process will update the housekeeping cpumask
concurrently.

So the housekeeping mask is guaranteed to be stable, right? Of course
the current task may be changing it but while it is changing it, it is
not reading it.

Thanks.

> 
> Cheers,
> Longman
> 

-- 
Frederic Weisbecker
SUSE Labs

