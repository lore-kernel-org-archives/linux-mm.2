Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4528CF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504946B009B; Mon, 12 Jan 2026 17:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBA46B009D; Mon, 12 Jan 2026 17:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407C06B009E; Mon, 12 Jan 2026 17:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D57B6B009B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:09:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B81A513C573
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:09:47 +0000 (UTC)
X-FDA: 84324704814.07.3C8D83D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F114914000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:09:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHVmYw6N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768255786; a=rsa-sha256;
	cv=none;
	b=CnC8FYXAbcFp2rwU2XbnGT1qoq29/VSSStCVAPjOOUG3bkdjeS6UE8JuEmc5xBuVjsZ6qs
	en1BzEvxVnzt5dvc4Z9YWY+a3r8kAL5qZV45faubvFjNyKOJTxm7hUWw0MBNW0fSOKgasz
	AXvYeAjYtQNnCfUL7GimCnjfqwvJtOY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHVmYw6N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768255786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iy8b6zJ4U4jEyrr5B3EF3LqIeY/TXDL9SqDPhwFS69w=;
	b=7A0vVW+xDtE5EJyVWnTVTjgdVGXUJqEGWAWpCViNJFtF/dQCna9806K+FSWz+xaYFyNsRd
	QoYEr/xZYmaDJJaATiGx8VmfafhqvAaWzADGKjAQ/ex6DMY1XilIf8vCxoPYPvLh+WMQRL
	EKbfwuWcoNTdUIIw1XM1nzeA/Er7l9Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E12ED44224;
	Mon, 12 Jan 2026 22:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A22C116D0;
	Mon, 12 Jan 2026 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768255784;
	bh=JxVAg6/16D5kLpXJf8cK2rWDDZ/WNlKo8ozqkYTbqEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHVmYw6NZl/tZREwk9G9Iv5iR5Xne4iGKYto91hcu1bIgTvjlMqP9uaM6ySc0IvWD
	 GzwQTYft18Psn6A+Bm+D4w/vKek/yVT7FaibTOHAAloagBn8qak1jjX/wEEcoStPGc
	 OYKkWxAsSAceDzk8dx6fDIlAkg1ncsKO1kqC//f2u6pXkij7dIRCKwde18QYO1M7HP
	 wSyLeSrhK9sEZBOJAHFDO/0Eq+iYPd3s5/bzuXEuFpnApHEnp75LGhg+uc0YNsFytZ
	 rnA2gOsmzObCazuI/eA9GURbG8a1plnKfvXG+Ae88LjklzVw+RPhIIFkqBmQ3LHNw+
	 Wt1qBmrEKBjEg==
Date: Mon, 12 Jan 2026 23:09:41 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
	Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michal Koutny <mkoutny@suse.com>, netdev@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-block@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Eric Dumazet <edumazet@google.com>, Michal Hocko <mhocko@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
	Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S . Miller" <davem@davemloft.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Simon Horman <horms@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	Jakub Kicinski <kuba@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Gabriele Monaco <gmonaco@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, Will Deacon <will@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>
Subject: Re: [PATCH 00/33 v6] cpuset/isolation: Honour kthreads preferred
 affinity
Message-ID: <aWVxJVQYEWQiyO8Q@pavilion.home>
References: <20260101221359.22298-1-frederic@kernel.org>
 <437ccd7a-e839-4b40-840c-7c40d22f8166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <437ccd7a-e839-4b40-840c-7c40d22f8166@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F114914000E
X-Stat-Signature: w9hzqgfq7b1q4m6ecqtepb9g9zidgnwb
X-Rspam-User: 
X-HE-Tag: 1768255785-742334
X-HE-Meta: U2FsdGVkX1/1hZN1n29S/j8HqBHmjv/KOjXM/495GQQgCFIz7XVO5d0K7qYGfq7IuJjJdb4KEr7e2ASlPtV8GB+LdUbJ+jBeYx8XDhh0j3zV9AO4TKPJJcBh54O7i5A76dXQM8oiSIzJdQQmTeQSGj9mAlcFyDcJRKMZMIB9nb/3B7H46dNTjQIO7b6IvNocBfPUl38fcquouWor8WPlowHAMGE498MET763ae6p4HM2a97zN6PyLTn6lu8qsch6KLJ/H71WlzQUN46FdAJJGlMDlGRPfGGfXv2xde9gqKoK58co2AJ4kFjmrR7P4G99uFgkr8H41kkrLakL9BRHTnzmdptWJDlkCBRpVFr2JFAXJPzHwG8QxwawEaK859/A/psK8fRL6RnLthNQU4SkcF0mrSy+NpuNcZJ2reU3QAPXzX9I1e5rvN3QGvsxxxs0Lu/8jf/NJqq+Wic73Hx/QTCTggviSF6pYpb/Bu5iyS+vynduU6s2pQt5d+Xc21x3RPxWJ5QsWEXgr0Kp19trp84fFqnaDGXZPT3/W2seYOsvee7wN6qE55tBIN3lW1fLZzCgZvArvfBXiF8rmSCE3C5L3xYmFQlPFZv1894OLT/iMW9IhDESXhGVZicm48M8a+MGpvIqDkW+Ry1BXfvOOE6TVkNd7j6l/QS0nWL6Fd6AqCjuGyrql9ttCQIaYmJPm4Ka/1VwogJo6xBkpTxeFZkDv5tJPkh6//OR5reRprjcaWyJQqqFZdnKoXRvahk2hSqHCL2QYpMpPM3EMdURbvsGuqI8XOUCMq0dDUU7Tnhdc3QuN+yJIM1Gv2Lky7HpN+5tlIge5wE7lP+c3jmFP8GqWHlb10d17g78OhiG+cfbuSuauzuD4+ttqez1+h9JAiYtzd4R7oaBV0N3dIaVT01tzDw15Z4N5oHN6aT2uMLuYnMekHdsLLHVBnsmce7tNSD/WCyX/G30nQCAc1t
 0CgpsibT
 bwxXd0RuNYDAW6UpnxPjaqFYC961KXJnA2sQCEqgLWpOxXaIPwq/K9O8Gr/7gbWmnPe3LtZBqxWQj91GWTsWfh6uJfHeUInUXmtYqz7RKpQYtlhXjqgc9kEK2YMQnu3nU4QGUZL/9mELi2lmFmHeH8t74q68+f4mo5h9rk7fUv0K34jHMzV+APX2kkNs24Qh8AhnDO0U6wazJMw8cvGz9GVc3dvO6G8gl7zUJBVaOMCYAqUwzWYh7Frt7OlF8QqL9MWojhWF7MaDCEMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Jan 12, 2026 at 01:23:40PM -0500, Waiman Long a écrit :
> On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
> > Hi,
> > 
> > The kthread code was enhanced lately to provide an infrastructure which
> > manages the preferred affinity of unbound kthreads (node or custom
> > cpumask) against housekeeping constraints and CPU hotplug events.
> > 
> > One crucial missing piece is cpuset: when an isolated partition is
> > created, deleted, or its CPUs updated, all the unbound kthreads in the
> > top cpuset are affine to _all_ the non-isolated CPUs, possibly breaking
> > their preferred affinity along the way
> > 
> > Solve this with performing the kthreads affinity update from cpuset to
> > the kthreads consolidated relevant code instead so that preferred
> > affinities are honoured.
> > 
> > The dispatch of the new cpumasks to workqueues and kthreads is performed
> > by housekeeping, as per the nice Tejun's suggestion.
> > 
> > As a welcome side effect, HK_TYPE_DOMAIN then integrates both the set
> > from isolcpus= and cpuset isolated partitions. Housekeeping cpumasks are
> > now modifyable with specific synchronization. A big step toward making
> > nohz_full= also mutable through cpuset in the future.
> > 
> > Changes since v5:
> > 
> > * Add more tags
> > 
> > * Fix leaked destroy_work_on_stack() (Zhang Qiao, Waiman Long)
> > 
> > * Comment schedule_drain_work() synchronization requirement (Tejun)
> > 
> > * s/Revert of/Inverse of (Waiman Long)
> > 
> > * Remove housekeeping_update() needless (for now) parameter (Chen Ridong)
> > 
> > * Don't propagate housekeeping_update() failures beyond allocations (Waiman Long)
> > 
> > * Whitespace cleanup (Waiman Long)
> > 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	kthread/core-v6
> > 
> > HEAD: 811e87ca8a0a1e54eb5f23e71896cb97436cccdc
> > 
> > Happy new year,
> > 	Frederic
> 
> I don't see any major issue with this v6 version. There may be some minor
> issues that can be cleaned up later. Now the issue is which tree should this
> series go to as it touches a number of different subsystems with different
> maintainers.

It indeed crosses many subsystems. I would be fine if anybody takes it but
nobody volunteered so far.

The main purpose is to fix kthreads affinity (HK_TYPE_DOMAIN handling cpuset is
a bonus). And since I made the pull request myself to Linus when I introduced
kthreads managed affinity, I guess I could reiterate with this patchset. I
already pushed it to linux-next.

But if anybody wants to pull that to another tree, that's fine, just tell me
so that we synchronize to avoid duplication on linux-next.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

