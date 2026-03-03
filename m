Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5E1EC142C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429396B00DE; Tue,  3 Mar 2026 06:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400CF6B0113; Tue,  3 Mar 2026 06:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337606B0173; Tue,  3 Mar 2026 06:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB5A6B00DE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:16:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B55431604A0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:15:59 +0000 (UTC)
X-FDA: 84504497238.14.25C1663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1356100012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:15:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PmoSSr0H;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zg7qG+n7lZp9Xx7IjMXO+8u2Rxf37O0/QIQinWbsark=;
	b=QjX/MaqHHidnU9AHbgWOxHnPKUn0FdQnBZJ0h8gf24jO3tdG12S+u1Gy1AElQio0xQGRLI
	2D/fLgbzrqtAuZBuwrMNdPShDO3pdQsF8how81p3crbCfOJyC3uSVPdNOEYSjKqLHPGPDm
	snZrwIXgT+NJDHXPMzmKTon2XJtdHBY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PmoSSr0H;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772536558; a=rsa-sha256;
	cv=none;
	b=OsiKZkiMyaBJvUTMvhVCjcZt0iX1IrgLhLK3QDOUcDWxbyqLu6gfS2k5JEKOi+w+DM7dyx
	fQV2gIeXy4bGRWVGkeoE7sFyW2Guvd/+lhEmAkBYWXBfmqaELuIhhsKPf44XjG/ch+ez7H
	VGyrJvld+OBDgjhmgEkxwIXY7DM6rs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 087D8434AA;
	Tue,  3 Mar 2026 11:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6731AC116C6;
	Tue,  3 Mar 2026 11:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772536556;
	bh=gbUkpufRLcpwq/o5TVZcY0FyRdTGZbA7Wnl6cxmAkZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmoSSr0Hgwi2wrBltXy7/VTBHV8HFr4yFmpxWEkATPt9ilT4W04Mi2Au4IB1pozT8
	 GTZc5GsnXNzpywgbw2CBbL0bAUE+9BmNkEXH4BR+ZVRzaffm8wYTZqsu8P2eCbVfwE
	 C4Xb4wCJrrB4AiiU3YEGd+SiPY9VFnXpxtjAst5C9h5POzqoxbORLCN+ybT/ak6lgS
	 6guLr6cCAfzFQgkPIYjFSrj9llZmzkL82/whirciqsfvviiOXPoysaOBuGEL0Hlir7
	 Q0/QfZVDrcNdfeCG4PK+oDbS51clAwL0mR4EdIikEoo9SKZnvWfgbfCGKiUO5xeReW
	 oFpDLwoF30nQQ==
Date: Tue, 3 Mar 2026 12:15:53 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Message-ID: <aabC6ScPN2_PyPY_@pavilion.home>
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302154945.143996316@redhat.com>
X-Rspamd-Queue-Id: F1356100012
X-Stat-Signature: ggqz3s3swyyop8e1e3j3o71wa5mc4xnw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772536557-222202
X-HE-Meta: U2FsdGVkX18My+JXAIrjPZJuAwCKMTH1JNsbGJEgWfzU5jxo7yCtQWNdRM7KUsPPw8JNSXU1DWem0TnhC+o4jUKFCS+Qgv0jPyGUITRDkUR5Cz9sT2/SGst8kz/7ABK0Bljjgm3DRZfjWgiSDQJ+gSS5sYQEcTmL82dd/FVzWHiJxmcn+sh45UXpBusuI6x0H+DbkmsujkcoP+p+mFHxtJVCVpIjZZOtPnvI6PbS4MVlYPostEVTPgaps5lFjyQ6SR6wEANu2xfw89addXKf7Nh6sZGt1o2FMBZ1Gjf4o82Q88F+Ge6FKRgkOwO9vjq/em/bPHd/W5pKMWaPD0bY7iRqxCXxWxvkHRDItd8WT8fIlF9lpULxE3NpBXc90f5VPM4MiVr2+KCeGiDuVEK52sbIyxOaHqC9HdefwrJ8hYWItyFUapnDZHAIT3Wm3byWeIEekaN7HiIgwV+TOonHyHnGz6x1s9HaqF7lZn/dG8c/F8kSfC5G18S6Vw2SAYQ9KZ4KS5HF5Lk8vdAZ756TeL0e48UM5PFXrh23FvRiyfuJbL5A2+O25XHdRHDKXj68bFeDA1XXFJ9rVJxZb1fhDOw8XFku8mlukGRkH7istDU5jfynvfr7olukALyQmsi1bmelHMMnYgXsYbfJ50nYIkoPu3unYA1/5r6qklqMvZ2kUS4Z8Iywq6mydcDfdNJa2L2t+dgBlxBftdVMHgnc79Z+r78TFcW5oNju5aK+swhlhGdBTou++BR4f/WyY1xAkAsOXZS4PWhlfIHVBg82sRKqdhD2/eZ1TWUFmxGzEQQHDQZhse5Shb5RDY4kLj4hCXqRhSsCP+syTd9ZjLaPr0AmmyruL5mdS+uoKZUc7Orbf4z3CYNMUmBTZ4tDSyGuHiJCJB/uoSuI1FSuCdssZ/i/q0ndDkAF8Y/OogOQzLFv+ScKADB/RUd/qWUhyc2QkKGO8cAL7YOqINFrG8E
 SlVXz7Wc
 qlkaUJR+cbq/Zi1W3SzU8hzP/K4vhSN1QmvaEPMN2JbWM2nkzPWfTMnpZnHO+pmpbTPyYSp4T173Ba6T4z/ckbdxw7jleDSoLXsn52xts6O8y1L0o/ip+Xz05KaQZmv4b2ztMjlwwbmb/QaekqkFXIbYPI4g8KujnmjQ0OCJuHO/q4CpcmiAhu0suuCa1wymbnRGbW1vSlB8SxYsgmBjuijI8MkE8H/7RpUaJWLshdL3BTioYoAYJjgdaXko2veS0PzNUVxH8DJHDY12/smF6rlmCigozog0zILSWLx2nGHOMgft9kHOIZMQZuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 02, 2026 at 12:49:45PM -0300, Marcelo Tosatti a écrit :
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.
> 
> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 
> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If CONFIG_QPW=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If CONFIG_QPW=y, and qpw kernel boot option =1, 
> queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> and perform work on it locally. This is possible because on 
> functions that can be used for performing remote work on remote 
> per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the per_cpu spinlock() for the cpu passed as parameter.

Ok I'm slowly considering this as a more comfortable solution than the
flush before userspace. Despite it being perhaps a bit more complicated,
remote handling of housekeeping work is more surprise-free against all
the possible nohz_full usecases that we are having a hard time to envision.

Reviewing this more in details now.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

