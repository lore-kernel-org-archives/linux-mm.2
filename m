Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF09CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760CD8E0005; Wed,  5 Nov 2025 11:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA208E0002; Wed,  5 Nov 2025 11:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2758E0005; Wed,  5 Nov 2025 11:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46E038E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:57:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA1BA140207
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:57:05 +0000 (UTC)
X-FDA: 84077158410.28.3E4822C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1A1021C0007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:57:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkrNSQmV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762361824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKgmFp8nWO8h1GDsmGQ0ELe9pnrWzbP46AUHBVd32Bk=;
	b=nFOGH97rj/mDkKZtsSKM7bDfovnlCxbO7nvG4mkPEuug0OqM2lGg1qqg7Vv4oKXSiYOs1l
	R0cEbnhuP/GCKHHM4+V8TM94VDaQeFK0gyNIvDckz9MbRA+2icnOY+oatr32Ow4uSOq+E0
	UVC2/ysJhNgV5Dvd1LquEgF0XifBAP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762361824; a=rsa-sha256;
	cv=none;
	b=AwbFhHUpMhldgJXmhVSOhyMa0g2ZnkNpSsXNApBbl+F4upr5+aoC7xdhwZdoc6U71c3nz9
	xAZSINJcCWk9qpZH+bD48gXdjjvLB1KNJzaM1CFlLPz+wJ5QuZ4IB3DyGsoZwMuL1R3ei8
	SSAySXzNDMoFR7uroCpRBuJnfjyvU2o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkrNSQmV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 224DB43FDE;
	Wed,  5 Nov 2025 16:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FC2C4CEF5;
	Wed,  5 Nov 2025 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762361823;
	bh=nhM7jbKOW56d3hh/niEe2UapYbSyWoAGZQptKDlqI44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XkrNSQmVRGDQ0lt4n06gp9o429LO1OThSwSo+tIIP2EJBJlS8ww/ro7sMmGiVdhrM
	 t1rgH6uGlaXnjmVa+q0tT6T/wHZzevQNMI/p1TJa24pvFPEM/3OqPC7DF47OIz9o9m
	 rS7nbd/l2kvzZuGV09bu3MD4TN55uh1avGCcK3xopWmiC5ZLktsFp0az7HaETHuJoY
	 Vh1Stje19/PGgTlt9Jb499Vr+Bcz3Vt9T3rYp8qWR+6Y0CAW4VMy94J4OlikA0BiAP
	 dy2pVF6eF1/01q9zF36JMleysXGqAX5oXg57tsMBxZrtmIJQPGP9L3s7oIbUpsJ6fD
	 yvwf0f0RHi11g==
Date: Wed, 5 Nov 2025 17:57:00 +0100
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
Subject: Re: [PATCH 22/33] kthread: Include unbound kthreads in the managed
 affinity list
Message-ID: <aQuB3Oy7i6Z0SJlA@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-23-frederic@kernel.org>
 <ba437129-062a-4a2f-a753-64945e9a13ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba437129-062a-4a2f-a753-64945e9a13ff@redhat.com>
X-Stat-Signature: hqhe88q3fg91ksapi6hwgqe9b1rgqo7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A1021C0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762361823-763081
X-HE-Meta: U2FsdGVkX1+qqjijuFlwy7kdCySsDFVQga+WjGNI65Yq5zwfEhfl/BkQvXw4l28XnLxc3Jhlwp1NqtlqlBl482Q2Mz6dEOMHOSYlV8HoOqQyKhAYAAgEzsgp6VP5OfhE3hza0f2rSSGdwKeDC2U1Xuy+0MmiWnkxrsynLJd413kTWTM1RzWVnsiNevXI+On4yYw1zZCd6EC/vZAaAJEYBzDP2PM8x0rELmotr0byGr9MTImifzDWZQu2IPqwVmNDjCZmCRq+iqB7mB2ZaVMuUFffTqcWCVQF9+POvHQURmb4OHS1i1/WpYftavZzSuZIEYXjA3x1yT9aDfRjFSnD0SXH+mClRqXJxd/hqd+zmfm4E49ySYnR/NtuUI77P6I4gR4Uvhl+ElVw3wsqUoeilJSIApwC0ldeFBHbZCTzP4ZDsbAOU3KRB6QgQtolvXc/keiVRTDeCRZh+OaXVqcpUZN+htNFIxwPqgNR/QgECeGRNPbxEriSzTEo5UFUlFxzaeUMMZ8ZGDsP9R/r76DpVzpL90ZFd1VKnGhBRYfNHY0+bGfwo7TZKNCk3D7y/lsyR/uOaY1c9jqPBQADUvH9XAN4wc7WdRtMy+zyFq7ylnwybigjLB3NumkhQsMnvOKE2UaUmPjmX7ufaP9uJNgpBG/ILN6ggBNYhorWeFg5oFxSlmWKwRTvclu+89Bpzn6cNkKZbsJzOA1oJHegg5zvgbIvcKB7L1BrwALE+P4PStrvnOD6gBB5z2Kh/e5fJPs8cYKsxwaHoeMoNQMk2sdjtApoMvkCQo9xlGX1A5ZQ7h8j9VfQy572/yVbMzOyAFjYTDLnbxV/tmdLiAidtKtJnojtsGpKPDxMcKgpHNHn1ynWDPTtDfJR9dCcTVK5nDhEOisf+Sk5kRl+NStW/WmY15gnqYmUZ+VnKJU3yXOpRLGEzdLE9SfY9DQWS5HO+br/VPyRw73NNZLBoPZJeGS
 1oxTN3IH
 Z6VasKuAigE5YGV1t5FGH7XE7VFrznSJhE4wZpRzofnBchWcF7Tf5LrSFAsuN8FNmpZ/pd8puhxYxEylFCv9jKW8Mjkusd/CjtzxhSZL5WZ28o1KCv71FKsFkOh5dQ4wLJckSAtEG7WBNfqU/boaPq6p84blG0hSj4uPU9cqZZTEOkhpaCL8VS/BFiwZhB5GCq96zYgssy9Wo958kIrAl29gtsp8vUF5T1ZMeWi9iqH5KavIJI1kwVSFwE5Ap0/eKYy/dvaLDvEMT7mQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 21, 2025 at 06:42:59PM -0400, Waiman Long a écrit :
> 
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> > The managed affinity list currently contains only unbound kthreads that
> > have affinity preferences. Unbound kthreads globally affine by default
> > are outside of the list because their affinity is automatically managed
> > by the scheduler (through the fallback housekeeping mask) and by cpuset.
> > 
> > However in order to preserve the preferred affinity of kthreads, cpuset
> > will delegate the isolated partition update propagation to the
> > housekeeping and kthread code.
> > 
> > Prepare for that with including all unbound kthreads in the managed
> > affinity list.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >   kernel/kthread.c | 59 ++++++++++++++++++++++++------------------------
> >   1 file changed, 30 insertions(+), 29 deletions(-)
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index c4dd967e9e9c..cba3d297f267 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -365,9 +365,10 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
> >   	if (kthread->preferred_affinity) {
> >   		pref = kthread->preferred_affinity;
> >   	} else {
> > -		if (WARN_ON_ONCE(kthread->node == NUMA_NO_NODE))
> > -			return;
> > -		pref = cpumask_of_node(kthread->node);
> > +		if (kthread->node == NUMA_NO_NODE)
> > +			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
> > +		else
> > +			pref = cpumask_of_node(kthread->node);
> >   	}
> >   	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
> > @@ -380,32 +381,29 @@ static void kthread_affine_node(void)
> >   	struct kthread *kthread = to_kthread(current);
> >   	cpumask_var_t affinity;
> > -	WARN_ON_ONCE(kthread_is_per_cpu(current));
> > +	if (WARN_ON_ONCE(kthread_is_per_cpu(current)))
> > +		return;
> > -	if (kthread->node == NUMA_NO_NODE) {
> > -		housekeeping_affine(current, HK_TYPE_KTHREAD);
> > -	} else {
> > -		if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
> > -			WARN_ON_ONCE(1);
> > -			return;
> > -		}
> > -
> > -		mutex_lock(&kthread_affinity_lock);
> > -		WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> > -		list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
> > -		/*
> > -		 * The node cpumask is racy when read from kthread() but:
> > -		 * - a racing CPU going down will either fail on the subsequent
> > -		 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
> > -		 *   afterwards by the scheduler.
> > -		 * - a racing CPU going up will be handled by kthreads_online_cpu()
> > -		 */
> > -		kthread_fetch_affinity(kthread, affinity);
> > -		set_cpus_allowed_ptr(current, affinity);
> > -		mutex_unlock(&kthread_affinity_lock);
> > -
> > -		free_cpumask_var(affinity);
> > +	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
> > +		WARN_ON_ONCE(1);
> > +		return;
> >   	}
> > +
> > +	mutex_lock(&kthread_affinity_lock);
> > +	WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> > +	list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
> > +	/*
> > +	 * The node cpumask is racy when read from kthread() but:
> > +	 * - a racing CPU going down will either fail on the subsequent
> > +	 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
> > +	 *   afterwards by the scheduler.
> > +	 * - a racing CPU going up will be handled by kthreads_online_cpu()
> > +	 */
> > +	kthread_fetch_affinity(kthread, affinity);
> > +	set_cpus_allowed_ptr(current, affinity);
> > +	mutex_unlock(&kthread_affinity_lock);
> > +
> > +	free_cpumask_var(affinity);
> >   }
> >   static int kthread(void *_create)
> > @@ -924,8 +922,11 @@ static int kthreads_online_cpu(unsigned int cpu)
> >   			ret = -EINVAL;
> >   			continue;
> >   		}
> > -		kthread_fetch_affinity(k, affinity);
> > -		set_cpus_allowed_ptr(k->task, affinity);
> > +
> > +		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
> > +			kthread_fetch_affinity(k, affinity);
> > +			set_cpus_allowed_ptr(k->task, affinity);
> > +		}
> >   	}
> 
> My understanding of kthreads_online_cpu() is that hotplug won't affect the
> affinity returned from kthread_fetch_affinity().

It should. The onlining CPU is considered online at this point and might
be part of the returned kthread_fetch_affinity().

> However, set_cpus_allowed_ptr() will mask out all the offline CPUs. So if the given
> "cpu" to be brought online is in the returned affinity, we should call
> set_cpus_allowed_ptr() to add this cpu into its affinity mask though the
> current code will call it even it is not strictly necessary.

I'm not sure I understand what you mean.

> This change will not do this update to NUMA_NO_NODE kthread with no preferred_affinity,
> is this a problem?

Ah, so unbound kthreads without preferred affinity are already affine to all
possible CPUs (or housekeeping), whether those CPUs are online or not. So we
don't need to add newly online CPUs to them.

kthreads with a preferred affinity or node are different because if none of
their preferred CPUs are online, they must be affine to housekeeping. But as
soon as one of their preferred CPU becomes online, they must be affine to them.

Hence the different treatment. I'm adding a big comment to explain that.

Thanks!

-- 
Frederic Weisbecker
SUSE Labs

