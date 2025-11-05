Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AB8CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D908E0005; Wed,  5 Nov 2025 11:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9051C8E0002; Wed,  5 Nov 2025 11:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A5D8E0005; Wed,  5 Nov 2025 11:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2658E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:36:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DA731401B3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:36:15 +0000 (UTC)
X-FDA: 84077105910.13.636EFCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 42E9180012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:36:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJvV3Gcj;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaW+IVAcw8V4+SUDNPsZ0jxs1KkpufLm07oO+WJVOBk=;
	b=hLmv3BOc97fiN+IS49FI9ofdJBmbIJE/Pxmv6GC4rGJ7p8hf/vwXUNd2e4zHQieKHjdy8x
	a+6YpvpFGZ2Ze7mhEjRVNXQh8yqEtwYtRMOAWViwKy2A3yloEgEqajHJSdnzJbCs3p4oSp
	Lw6ItLeHLXCbFvoVVj5+sbIxzA41Sf0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJvV3Gcj;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762360573; a=rsa-sha256;
	cv=none;
	b=cMVKSE7mvTPqd10yJYNhYt10Mn18IMzY1ARQOASxilZAXkgysr21LP89A+Z2yBF0lnM6oD
	u+AeXLu0BTfhW7MmgIXZp3lo8hl5/Yw5KomGtgNH3HEx0alnek647gl2kGEppihcOPoH4F
	d77GtAo5IOQ+NK5gBd2xdOVd00M1RZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DE23446A9;
	Wed,  5 Nov 2025 16:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E76C116D0;
	Wed,  5 Nov 2025 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762360572;
	bh=6TrJvUK9Bi4MtE396O6mjFvQ4XSVRdM4jTat1mqDJ+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bJvV3GcjxVMkbPp2/HPHTvVQ3suklWsEfheD+VTVjPqA9H4nzGbxr2Z/oMCnFchhM
	 hx0phKZelWW3iUoT74SWOR0eAm/GMDUMSFZuJwRx3xLLzarjdMxhpnjROdsmqC1Bz9
	 MmxSP1G8Pm7sZ6X9Aw3/6NWdF7ILo/dLtzKjptrZcQKyjuY5ue+jqOiVpPmYroetzt
	 pSWR0IX5HMGCyAHJeRFyG1+DMWcS1izzqvM9K89t6srVDOjWc2wPYOBV+rjwy9RPKh
	 A6Jk4/1Jh9oT6si2+yJ2cfyT73UhwGEh/7aY2SdorDojoRR9eU1sKBBAVl6FGvx5cd
	 7YvIKTyAlo22A==
Date: Wed, 5 Nov 2025 17:36:09 +0100
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
Subject: Re: [PATCH 18/33] cpuset: Remove cpuset_cpu_is_isolated()
Message-ID: <aQt8-dzr4Ac3l3bt@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-19-frederic@kernel.org>
 <7821fb40-5082-4d11-b539-4c5abc2e572c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7821fb40-5082-4d11-b539-4c5abc2e572c@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42E9180012
X-Stat-Signature: 9k6h4rwqw7cunukjjfdp67ws4fpe6ujt
X-Rspam-User: 
X-HE-Tag: 1762360573-291680
X-HE-Meta: U2FsdGVkX1/RiwjxK/blr6bCLBCTClm3+NGvy2psXq0MRwZn1JV7iHaSwNk4fPe7HwBXpcd6RYrC4kVBTe8B8WDjiNortSyLINqepXt1v+a3uDAfmIknwcDXjAQFPeP2S9XZuJlQ4R4/LuJI3Maa5QTMWRfvPs5fVYq//Uk/wd3+LFk+UgUmt6BNMaHwrBbtImQDE5kQkWwY4V5wfrtKjv7BSkOMz9hGnz6Bp5IL+2J8t75h0TBGaEwfTI56yXPXPtiwPL6OoJp6ZIaSV+U8NsnEHXGoqpn4au5cldfIJWW4oOlLv1elMOxbTvhddeHUE5PabdSGzsJs+w1UTqPm2lpG/2FaIGP177Pk/yuVPKb8ssKJVyUAsbqwCrc6YBYCVa6p8sggfBYXlKO8sIJEB3BJTWT+Evo4LOvOwtRnOBnJN78cBw0Bb8Y8MkIbMJjc1jh65kRxsDUjh4SWCqtc0g3vTRM3ZPpzWYvi5hiUqbHvTBtiIg+mxfBAnAfjjHMpZKCAD7b9NCi3JebrQRNxY82xdlCKHFxHwHRpFTKPz064sQ9aAiDc6qJIz3YIC4YDeWEHvBlp8aOnFOgIHoVHPEzdZzPg9AIztaCHdR5lZtVuKe+g5KCYyGc/syWWBB1tJicy2eMPNhMHHPA3TRgXCB1taO7HT6pz3qHilHLM+xjF7aD+xIoUEM5upbicSTK6j/1T2VCLUGB3Y8WDaDvRtA60wTAC2pZ38EQIyeIJ0/dVl/bK+WPm/xDf3RkbqprGONvKyJaF/GV43jVv/RGZrlLRI8dCh0ERG6BcYvb3Hla+2FW7um5aCA9JZrw1XMb5nl3AI0/+dnZLsbamy+V4nkP+1NDblAKIHl1LRXA5m80FfBqQlyHMwXXxw0KbdbUC/UWomRehWjXScF5JcvUVJoht36TF1hGNiXIOAz2/1iVsriPc4QBB3+KY3+JOQvkXpEYgioccfqrfTMQPdvp
 8jIJa71R
 OJ10Dbq20+FZlwhRNxKtGOGfyDnDa+CZkOBRgPJIYiO66iFmd5KnlUswZq37mJu1RtUZfyIsDUtYgpf3TFXqxKej+3O/nUJ9RffkkSU6MjyRF1TJQCDYZZw1jJlRUSIuSmlHocUGO4JzRr0DIY6F/NmlG1bpal5jpiTKxollqgXFZpJMVghzT7vfMu/Oj7cuGzP+4iXVqm0TMSZlcnQvsMFHEBMq8vaLTAXVr2MlFbthAQeaarflAwSTytVRw1cZbrMYSAH4E+iw0t5xl5axI1HGxkkf/OE0CiIzAw25VqFJbPf7z7z4GLAny22wmfioa7O34ObNfoqS1SpevXUUHS6ozWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Oct 29, 2025 at 02:05:17PM -0400, Waiman Long a écrit :
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> > The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
> > housekeeping cpumask. There is no usecase left interested in just
> > checking what is isolated by cpuset and not by the isolcpus= kernel
> > boot parameter.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >   include/linux/cpuset.h          |  6 ------
> >   include/linux/sched/isolation.h |  3 +--
> >   kernel/cgroup/cpuset.c          | 12 ------------
> >   3 files changed, 1 insertion(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index 051d36fec578..a10775a4f702 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -78,7 +78,6 @@ extern void cpuset_lock(void);
> >   extern void cpuset_unlock(void);
> >   extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
> >   extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
> > -extern bool cpuset_cpu_is_isolated(int cpu);
> >   extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
> >   #define cpuset_current_mems_allowed (current->mems_allowed)
> >   void cpuset_init_current_mems_allowed(void);
> > @@ -208,11 +207,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
> >   	return false;
> >   }
> > -static inline bool cpuset_cpu_is_isolated(int cpu)
> > -{
> > -	return false;
> > -}
> > -
> >   static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
> >   {
> >   	return node_possible_map;
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> > index 94d5c835121b..0f50c152cf68 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -76,8 +76,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
> >   static inline bool cpu_is_isolated(int cpu)
> >   {
> >   	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> > -	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
> > -	       cpuset_cpu_is_isolated(cpu);
> > +	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
> >   }
> 
> You can also remove the "<linux/cpuset.h>" include from isolation.h which
> was added by commit 3232e7aad11e5 ("cgroup/cpuset: Include isolated cpuset
> CPUs in cpu_is_isolated() check") which introduces cpuset_cpu_is_isolated().

Done. Thanks!

-- 
Frederic Weisbecker
SUSE Labs

