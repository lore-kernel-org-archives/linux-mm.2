Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C55F606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8gG2FyS
Received: by kanga.kvack.org (Postfix)
	id 4D9A46B05B1; Tue,  3 Nov 2026 09:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0FF6B05B2; Tue,  3 Nov 2026 09:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6FD6B05B3; Tue,  3 Nov 2026 09:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 178096B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:10:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D15DA0445
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:10:28 +0000 (UTC)
X-FDA: 85393992936.09.EC6D40D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F369C000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:10:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8gG2FyS;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793715026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hcT28SYX76z1COvWorzxu+1gkA4oj6GNwI2cd7zGC4=;
	b=fl5X1sOrgJsMGbZ/NBM6qh8mVCCnE7ckPBqGQVMkTrPietbbqXZp9FBsIDfp0ZcQ2MEeXy
	jWq9bhU/qLFTR+lPeVrfQbIqR0SxrBvQCVIs8z9Zh0hEEmYEwRsl4HXT62Yp968EW5EeYd
	2I7dxCrCE/xv+Xjo70E78S16rdPvkEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793715026;
	b=1RU+CQliPG53m2TC+2gONdIHRKsJuOdGvDw3UDGpEz2HAD9S1AEqWcZplWh2wp1CHAhUH2
	vBs7seCB3UHk1Gpb771VOOXI6BUruTobmIgPFtgq7Z5BfaB6S4wJtHUM/C0Us0DtveOIS2
	8Mq6oxpcEskxVD0vQezsd2LWK9ECQvU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8gG2FyS;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45BB56020A;
	Tue,  3 Nov 2026 14:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C32D1F000C1;
	Tue,  3 Nov 2026 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715025;
	bh=9hcT28SYX76z1COvWorzxu+1gkA4oj6GNwI2cd7zGC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A8gG2FySIrvGccJDt9QVUN41xO71+6Rpf7aiyxt8Vsopa/Ys8hBvt1hDZeBlS/PGw
	 MOt8BcnF/W4r1s15z+9Q6nzud+DWuRPuIHnctKYism3LQZOnWs3vU+zGKDYcGAak9v
	 i1JqUhBvQ5kbpMtFLU6xUwyGov9lzqLdMvTVOsorWieMgO07vFjRnAf8TphXqmT54a
	 fGU5gWTkE4FlbUGGSThdSpyyACGOdEcur0TIARvk+d+UVbVw5+sbat1Ht0raY6TNIJ
	 eZtyJEUng8T8aAiarrufke9huCyGceFpE9bK2kxHfRy5JVsGTTX+UrBQ3G6s7LkukY
	 Bnv6IKVnB5Lwg==
Date: Tue, 3 Nov 2026 15:10:22 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Leonardo Bras <leobras.c@gmail.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs
 become isolated
Message-ID: <aunrTtH00__Xi7PW@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-5-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103075940.110308-5-matthew.ruffell@canonical.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: dpg9s8m5p3yc76wmn6wckwapbx6d6atz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9F369C000C
X-Rspam-User: 
X-HE-Tag: 1793715026-874252
X-HE-Meta: U2FsdGVkX1+vKnWXF4Tarhzqshf7rlxlOp9Gw/GhvCTowWdz0OipiRXSW0yFxVip0NZ27kFmsVJizmaOrJQUHvej7akWa33XgBStVFX6Yw0Np8Ad8bombQF3To1Qh1s7TxaJtX+k5vtkLF5UxdQIi8Jbnbx3IOsRepLrtmAcshp3u1GkIc+ZtropILRCnJs/q9/ms7kqjZU05X0+kier+oQNZPb7qyvhd6ht5M1rusKu5FkZs6Oq8oR0USBsgQMoQn572DFU6ejPv12EA8zqrdexXi/Ul9dtRA3ROk72/T/RZpd/TeJbBXX9adWYvvUxvMXD+VlAcTR2DknHVS1NYMvLTY01/1tFDJ1x0MrbLv3FpW52b6qTKlKhJqumXh1BK6CCqgwFgVMeLWr1CHjZFLVg0VtmL6aBUp0bkV0DZBMUMHZjG/eTAHvni5CqS5FGRp69dntktGp9NrgaU45hWcJGAoKwbfxZRVwB2ZOmjyL/mnsNGscgiqqg6JuH/qH/+igDA7HsqI3nkEbPbns1EKqGa9Cs5LQH6zuAsC13yQFjDdBqWmeVnfElBLVnNJQM2D9oXU6VDTxU55RQ45m1QtK6K/9azXGJIMbiNhdcjxaSvlE4ujAvHN9LOejrMK9kIBMYcr90dM4d6TZt18vAakH4RHO2WYTp9YI1SsVP6ho3JJxJCKFQfWjN7bxTOWMygFevEZ1hu6MdWqQlPROLH/e4fteEQRKk9fB1w4y0oJVgbnaCzs8yTqBY8ZtB8rfesMQ5BQn/XO4MN9gHvQAi0zUTykWAEUR/gk92a8AncvzxlHWMSfOEoXeA27pFK1+aQSZCRLmDMU9LkX8TIMzzUlLqstaQ/rSpDIXYAcFbZZhuyIIinLaszUoaF6dEs0RdhGqlxuBTm0rO9A0afpFk1gSz6So3sFbUW00ZrevuipR4O0R4azFIe0g5kknMuRfSDbRFv/6pwtgDUOZA3Z3
 T3kdUrLO
 7yNumK2OJWRiSmHaHmwJPDM+88xN7RjLROrRJCUZleTPCOT3cM3SGgFuBJXcqO6oT/Tlt4BVxV5K0HaScdRHkqKjpDcQwEDue/R0jkAlmj7nEluSSdZ1PrKemlJvGda3Xw59dPso6t3OUUzov/fqnUXx0+LgwBp7VOpaCnFC7v7zbh4TG0+wpiGzpvFmakzTvLnXdMfEcl/+TA1nSH/7a4npRCd42Cdj+2RYaF59jbBMFurcPWQiY3DU6WonCnCeX1HG5hb/A0BK2N5GZsP6NLQeg3S1LK/pyfa7gQwuvIAfUuOpgJILKpvKl8iw2LYgzgmCiOFJe16C0DRUX8nAWfuJHgJXWmnvUH+xAH4uzDwScXnB3H8Dxa7IdEP45bPcb/ooHYsYGMrXiorNajnvRtzYOOm0APig7N1oxxj4ScRQaKmyILSN52AthY5kHnJr+O43YMoKAabftL9wS2W4ZWX1/VhtVH+GXImIJE0NxUsCiljkaYe5GuiXg1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Le Tue, Nov 03, 2026 at 08:59:38PM +1300, Matthew Ruffell a écrit :
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
> that __lru_add_drain_all() never has to queue work on them. Boot time
> isolation (isolcpus=, nohz_full=) takes effect before any folio is
> batched, but a cpuset isolated partition can be created at runtime and
> the affected CPUs may still hold folios in their batches from before.
> Those would linger until the CPU happens to drain locally, and the next
> lru_add_drain_all() would fall back to queueing work on the now isolated
> CPU, which is exactly what must be avoided.
> 
> Drain all batches once from housekeeping_update(), right after the
> HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
> workqueue flushes that exist for the same reason, so that newly isolated
> CPUs start out with empty batches.
> 
> Link: https://bugs.launchpad.net/bugs/2165410
> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>

There was this patchset:
https://lore.kernel.org/lkml/20260519012754.240804-1-leobras.c@gmail.com/

Leonardo, do you plan a v5?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

