Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4A6EE6428
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694446B0088; Wed, 31 Dec 2025 10:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641C36B0089; Wed, 31 Dec 2025 10:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524186B008A; Wed, 31 Dec 2025 10:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 428D36B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:53:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E71D48BDE9
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:53:09 +0000 (UTC)
X-FDA: 84280210098.22.4E5522D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 281554000E
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:53:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxDab8BY;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767196388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCjFp+pDGdRxDrsKK6M4AzYjr8nKeM2d1aD4T1BGjPU=;
	b=161bJFoyxXeTk1MvO34PNz0V/uVAOV1jb7TBG4H1URAcZg1l9agTPfa56eMcn7LLl4WUqA
	upl3lEFX5vHL+iBf06K9YeBMnBBV9SSJw5qSfeWTj3fnDa1HNHsFtsmp5gFbN3iPGh69ws
	XYabVZKhfd1Dcz0l26O3LMZBclsk9o4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxDab8BY;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767196388; a=rsa-sha256;
	cv=none;
	b=GaRpYPivfBSJBHW58EtltRIZx3DSW3VIPT588FtfeMyrqRPB0OiZJqI9NRTt7MRo9XyF1k
	OS+zn/Q92fosaSwTNfVoSVvQ2zup78f9RZ3pHRncoOLPS4skX/4/90TX/TVuuQZWYPWsrz
	xzA8ig9DibqEMo2Ch9tN+cH9u0YWxVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA2EF405A3;
	Wed, 31 Dec 2025 15:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961DC113D0;
	Wed, 31 Dec 2025 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767196386;
	bh=WuZtOdVS5pt77HE6C/4UqSC04WxBcGthdWDuudQRYgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VxDab8BYNIAerqtNV5zwvbjoskp/SPlehgZo8EmzUsqwfpTjb+PHLvjB3/Qja0h31
	 UULkJOtXQH1SfmAb7vyAh6oIHb0OjR053QxyQL9jp1E2EPXisgst2fDkb6Pwm1biyT
	 VWmvvozz2gG6CzWs1cAr3cftru801On2WHgnh2PLITLRtRFg3votB3ExybxAyD/TCc
	 E9pfkXScaZOYlT/k3gRfSRJG9ofOzMXgcL5MwRQUb7FcyRsFHUs49yU5OMxzP78nXN
	 a9Vs6QnYfGFU1BHGsY59xWhfGdN5QneBF7NTvxT2/ddwqD5zYUeX9DP8WxIh0e0M9/
	 Gody5xZN6Kx0w==
Date: Wed, 31 Dec 2025 16:53:03 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Subject: Re: [PATCH 19/33] cpuset: Propagate cpuset isolation update to
 timers through housekeeping
Message-ID: <aVVG3-NBYIhJmVsk@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-20-frederic@kernel.org>
 <a8262eaf-169d-415d-949e-70f1a17b1e38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8262eaf-169d-415d-949e-70f1a17b1e38@redhat.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: we9c6o3kp3gfoo9udqtpkq8mj1xc8auc
X-Rspam-User: 
X-Rspamd-Queue-Id: 281554000E
X-HE-Tag: 1767196387-526123
X-HE-Meta: U2FsdGVkX1+CLPHI97RPNHjs9q/knHj4SgrS5nIyUFz9KBQ7s7bazn11b9028DDeDfGhmXNOoHzbnWNwLsqJEbhBmhuUY6VkuxyTN/r/wl1mSbojgd4AxxEWMmAH8EOgfBGRafTMpEKGgTglBxXOvNe/ofxAlbB99wMGmY65N8wJwR3tGq1U4GjSYKJbB6VJOGSAlFHINiTvjuIsMr4mdhmhfK7x6japqXVymnP+ngqxfOjKWDbSoQIf/XZHjY9VrsGOk4rg71ur2tFBX26xxf9VyG7X87i5sY2uEu8YAqIsBx6NBhAwtAg2aau0SI4q7/ejwesC1AUWkUfFz2kSlH7SnTYQqBaE+bC5SnRwMwvWUPf+GwhpOywYBoe1heUCxER3o/8EFs1DMm1873G4888KvdTZxasXe8d+skQpUl8k2OYNM45Nco12ee9x8TtYeN0Es+24rLjoSQTmA93etOziJ/poTQlB9dlL4D8Pxg34NKpwbZrSpsUA+q7ebKNQJHUBVlTbNtbM+3B4jqDKd+6mzaSrQtRZAUwr0Kogilz4vM2m6/1mrZyVEq34YKFWDZyDIVoNk+54+ZW2UnafFybHVQhCnIZF0TOwMFXKa+dnX29U7BRS+rmSPO4UMNW83DNWh7Y53kPft1L8JXKrmtiz946Tmu3Z3c8rhBoI24wHzqGI4bCBgG4eEEttZgGT6iTNiI+20voD7h/ByvK5fGtEV+19o+VcBKBWxzfSYRcvdyYRxLEO5U4Xlh9KKL5GS+e44NNTAhAKCFbA2yUgVAuv+z1iGfGDRS66dbvbNCBbDwyN1qFOi8kQYweK5fLqoqhOAXvjELmxCTd1yQr/A8JNSajOMR0xYeTkJRW/L5Wgg2qEwMqYhwM7gvvR7VlzKjObj+lDY12W9hoZd78h1i3IUcIa/VmWtwdCWRWfq4x9LjZjLy+RJhZuqgpMTbKg5C5ECaJeoVoQZYpApxw
 FbOCzM9E
 ZjomcBeqDTMabDlpImQNKN79pig90JiRaRzhsTYFZ/uQmSZqJNgVxam5Jeu5fsfZxblfckYll+eHvBdhx6RpnF0n1gIxRQHYlXO9BTVkHAmquXBv/RynCLi8+bxh9aisOy/yebqBcxH3rYkoHl43ghOn8RuTGSPatSEVF+WhTNf0TjsKcryboLyJk+0eGmA+4CO6S7Mcxmp/p3DYdjySKPd7w1Sbmoq2NlLDs70F2pBfgOrMr1rVffSQqjBmVpbbqbjXaeFNlNR/wwGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Dec 26, 2025 at 03:40:25PM -0500, Waiman Long a écrit :
> On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> > Until now, cpuset would propagate isolated partition changes to
> > timer migration so that unbound timers don't get migrated to isolated
> > CPUs.
> > 
> > Since housekeeping now centralizes, synchronize and propagates isolation
> > cpumask changes, perform the work from that subsystem for consolidation
> > and consistency purposes.
> > 
> > Signed-off-by: Frederic Weisbecker<frederic@kernel.org>
> > ---
> >   kernel/cgroup/cpuset.c   | 3 ---
> >   kernel/sched/isolation.c | 5 +++++
> >   2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index a492d23dd622..25ac6c98113c 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -1487,9 +1487,6 @@ static void update_isolation_cpumasks(void)
> >   	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> >   	WARN_ON_ONCE(ret < 0);
> > -	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
> > -	WARN_ON_ONCE(ret < 0);
> > -
> >   	isolated_cpus_updating = false;
> >   }
> > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > index d224bca299ed..84a257d05918 100644
> > --- a/kernel/sched/isolation.c
> > +++ b/kernel/sched/isolation.c
> > @@ -150,7 +150,12 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
> >   	pci_probe_flush_workqueue();
> >   	mem_cgroup_flush_workqueue();
> >   	vmstat_flush_workqueue();
> > +
> >   	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
> > +	WARN_ON_ONCE(err < 0);
> > +
> > +	err = tmigr_isolated_exclude_cpumask(isol_mask);
> > +	WARN_ON_ONCE(err < 0);
> >   	kfree(old);
> 
> If you are doing "WARN_ON_ONCE() in housekeeping_update(), you don't need to
> do it in update_isolation_cpumask() to avoid double warnings. Actually, you
> don't need to return an error code from housekeeping_update() at all.
> 
> Cheers, Longman

Ok, I'm keeping the error return for allocation failures at the beginning of
housekeeping_update() but the rest will only warn in place.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

