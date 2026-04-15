Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 388C0F41987
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A24A6B0099; Wed, 15 Apr 2026 05:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679F56B009D; Wed, 15 Apr 2026 05:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F746B009E; Wed, 15 Apr 2026 05:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 462DE6B0099
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:57:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8E74C1566
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:57:39 +0000 (UTC)
X-FDA: 84660338238.23.9E7C2D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3ABC3100003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0BiKNWp;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776247058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuUefnK41iiL6Ev8W4THUyYzIHISyfxmJXZVSAwDo1M=;
	b=1RbAMg3OEsgAxUePOMMnE9D/qWlclM+UGVNhqGt1zFI29wiiJj3I4qhuQYG+AalXlSMiK9
	/s+faxcx1LqASAnVZaodrmY7xbDeu9ZaoS2InC21G3BYxRaKWbY+kGcIccsc16rm04WROb
	mPpeupjnB98Cb2z/mJQVuTEuMIrzHoc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776247058; a=rsa-sha256;
	cv=none;
	b=6JbivRGWYzZ/E/yQMCz9hnvQqrTH1kr9HBsUBM+rNysS0BYYzyj+lNGrx39e6TY618u6qP
	b9SIGZOQoqNz+t4suELtbfESXW3uNimLYNKczH3qSOkS2yZ0vmy6+1ur5bc0QUpRPQLr7L
	NznrSV+g5ghXtgGtHsk17ywCdyAGnqk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0BiKNWp;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A3DF600AD;
	Wed, 15 Apr 2026 09:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44FDC19424;
	Wed, 15 Apr 2026 09:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776247057;
	bh=fPenWH6QfvusBtCg4QCwgZJ+BbZLJ1RStl3A1w+9t4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0BiKNWpnWLV2d6FuFaeFx+ttM7qFSFSsv/h2mz0KBBk0rmD/kEGJSxeiK+bs+K+c
	 p2ITQDCzJdU66sqqMRhGRlnKDOOkVW/fiRH7CR/faB9kJMF8eScY0j/hfB05koRTlE
	 NylTzG1gS17InNCBSQ/aurFJZB0NT8WzjqfmAFRkF/RgGFkn4MvK1PAaK7kvRa0koW
	 B5IsIRJrzUw64u5u9nf533r8n1IyMTFBIvTQQSKeuZ77sI9AXuqGN5ytjGgJyh/ILG
	 UD5XuZ0zuf0A/BK20SeIdeW3pEmTPyN3iwrPA1HO8ruVFPqqcnoQTcm6iAAZNCWWlx
	 LMDZo65fxlc9g==
Date: Wed, 15 Apr 2026 11:57:34 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 09/12] cgroup/cpuset: Introduce CPUSet-driven dynamic
 housekeeping (DHM)
Message-ID: <ad9hDvLyswZCokDH@localhost.localdomain>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-9-06df21caba5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-wujing-dhm-v2-9-06df21caba5d@gmail.com>
X-Rspamd-Queue-Id: 3ABC3100003
X-Stat-Signature: mr1wzb139jqiezorpecxu7smxfb4apg3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776247058-673311
X-HE-Meta: U2FsdGVkX19POZ7egF3tzePo0ysFMKf0mDsGSO6ggxWL66RAb8LF9Z/I42F4uUWii0lvHjuJ6berqvbU87n3l61XJFuKKRaj8sqRxf1Bm+gh28ulMZwr8wvyh8wyE/eOvpqg28Z2ifX2c+Wh4nBvtRNLTe4pe8+A/kaE180y3c4y/R12nfVroy+0WErFXUYL0P0bO5k7lCLKf9aSdT4tlzBMo4HUaSfDNgwMV+ovnFSimy15uG5CTx+GGYqQfIQWu/piXLbOsUxqFO07JW67rh6MXxOmYutTNnQ1PlEMyFyGlhj3BMaR6LLhHp9uoCEpUFdx3BFX3spz/BuXTVIn0q0ni/kIVnUd7xENcEYP9aKBzziT+px3mI3rNA8Dusv7NLpSHNnpr/8pqUHSlRlEmyGtdX29G8pLG522Nf2u+vp2DBN+rKLMaaaw5twQlujFe5RscW8IO/H9g0kntXVCclOQZCeojTdMBGEd1Axf7RaeoMcbN5wON1zsqy5wBirL+wbdEp/rL/D+3/R1u+276+plJ/HDrzdq/gYDmckVal1/4tRPnWHLTrdr2OK+3NgzJF+Z38FrxHvlLAZtsZS3Ivn72kI5/FytNDp2FSsrvWIJtSbMZ03hanY2ue/vT28itaLhrfWcLf5xQdQw+GGkOyan0+UJ9mo0cMCb3n4Y8wfh/qmmmr7ABypRoYrxxQYVl6Ltr7h16nBnFuN8t8U4s4LpQqsnzeoaT3II/AyDt1pNwdlK7uka/oi9Fjawcs/RVoqFzwy3g/NMGymZYxUfqwWvqa32IL7dh2YpRR3qSiE0ThpRKtrYtFcPibIJb+Wazeunahh2P6FHq5bNTHN/Z0uILj6ohKRyCVJe6oqXjM4jDOVOfNnj9eqT0HFHnbiZ6s92PjaeQ+2NxZTKstLipwU9jZMVnE9h2PCjfGK12FvQBS5g+oQ7Y39sJGagdO/RUsnG92LNmwY01oSiG1l
 bOvs1LVq
 O+rWDBfWfKJbH6cxzOlpqaLWazWalGxzOmAUIyrMlkVJ1fggazHT8U2PiqtfzvzKhtx6O9zPfUiQzB641pSy5UBtSTgHQy0qpWzkBUjGzhVZ0YoN1qCGtqAMCyGFcbM4OpZY/kE6dYnxrOmInwL0NdIC0bUKq9ycqr2wgW1Hni8dNSOSvaGffGsPqJvx/px5Sc+WgQsKL5+aszrnQs7m6QQ9qavtcwQd/mSZDl27CkfvcQZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Apr 13, 2026 at 03:43:15PM +0800, Qiliang Yuan a écrit :
> Currently, subsystem housekeeping masks are generally static and can
> only be configured via boot-time parameters (e.g., isolcpus, nohz_full).
> This inflexible approach forces a system reboot whenever an orchestrator
> needs to change workload isolation boundaries.
> 
> This patch introduces CPUSet-driven Dynamic Housekeeping Management (DHM)
> by exposing the `cpuset.housekeeping.cpus` control file on the root cgroup.
> Writing a new cpumask to this file dynamically updates the housekeeping
> masks of all registered subsystems (scheduler, RCU, timers, tick, workqueues,
> and managed IRQs) simultaneously, without restarting the node.

There is already the "isolated" partition type which does scheduler, timers
and workqueues isolation. Shouldn't we extend that to dynamically apply nohz_full
instead of adding a new unrelated file?

I don't know which form that should take. Perhaps reuse the "isolated" partition
but add some sort of parameter to define if we want only domain isolation or
also full isolation (that is nohz_full). Waiman should have a better idea for an
interface here.

> 
> At the cpuset and isolation core level, this change implements:
> 1. `housekeeping_update_all_types(const struct cpumask *new_mask)` API inside
>    `isolation.c` to safely allocate, update, and replace all enabled hk_type
> masks.

HK_TYPE_DOMAIN is handled by "isolated" partitions. What remains to handle
is HK_TYPE_KERNEL_NOISE.

As for managed IRQs this will require more thinking but we should include that
into "full isolation" in the future.

> +int housekeeping_update_all_types(const struct cpumask *new_mask)

Please reuse housekeeping_update().

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

