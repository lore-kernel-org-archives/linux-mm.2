Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79372FD4F04
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4B86B0092; Tue, 10 Mar 2026 13:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2876B0093; Tue, 10 Mar 2026 13:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77ABA6B0095; Tue, 10 Mar 2026 13:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 656686B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:02:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08C9C1602CA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:02:21 +0000 (UTC)
X-FDA: 84530771682.30.49D8E20
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id A79FEC000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:02:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E5bgoUQu;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773162139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LKshKUK3KitIMjNACXgO7TTkRiyZPtXq9EyeTBs6so=;
	b=nGJqxG4ElGZ+G+UxkFJSPCq+bdghwUwP/EINNIPv6W02GGUKK7PzY5UEnWU4QFXOMzXDRA
	csNs4gdD6jCDs480oDi+e6rEg8/U/21EXTvrWAm+28tNufMthQ/DVb6a9tTuRPGBE1TZfz
	Y5198S2jVwaRlPgtlFirmounn0KTPN8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E5bgoUQu;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773162139; a=rsa-sha256;
	cv=none;
	b=k3qMeDYXU9SQZwKiddty2lF4lQUzHz6vRFDRpQmNfKXSZJZOo/eAUlEFuO0jQm/95Rz5TG
	z8OW+zKNg8TazH3Gv+F/hO5MRsLhgQQgdErbw1AOl23nEV17aanBqONbR37Eqw6GamQt+X
	RLQJ6GC4HnfWtQOxRjGbvfv+06+oHks=
Message-ID: <35272f7a-4c1e-48f8-8e99-82bf3baffab3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773162135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LKshKUK3KitIMjNACXgO7TTkRiyZPtXq9EyeTBs6so=;
	b=E5bgoUQuw0+On5E2PJ89wAn5VJKu0l4SF5t/wicRslH5R9CgJYBndevL6URwlolo5gSWRA
	Rc/KugVqwjM2d90Y46q784Bkmf8xfQ3zQpYtXtd6nTtBR9SZPM+vh4LPJc3yEA8/OJ97D/
	64B0uIZzJgoLagIttfjTn+QWj07uYtA=
Date: Tue, 10 Mar 2026 10:01:53 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <aa9aDGwk8YteaEob@linux.dev> <dcf2e654-ad2f-4390-9b62-078e664158de@linux.dev>
 <abAmMjkZZLN9LXXM@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <abAmMjkZZLN9LXXM@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A79FEC000A
X-Stat-Signature: qaphrjghntmtrxy384bejbatypxb97dp
X-Rspam-User: 
X-HE-Tag: 1773162138-43882
X-HE-Meta: U2FsdGVkX18mqGbP0ZN94edru4aVPjqe+7EpRUIZandeWsxoO5+JDF2upWDEjLiYEd1MieADAAEUhkWP8rDxWp5UdH9mvE66LCs1cWfuXScCEUflxP+qf/nxBPbqqeNEI/Rxe/sDyEu+509u1D3fvmtx9IY+ZS33YD4chtYnprS7KyvyyRkc8McQP148RxixklI1i7Y/PnG0Bgv8TtHrzh8cf7+2EHvDkvbG3Fdj+coENv4KYkEMKcFD38S8XywHr34vhKxk8SThaFVWs4/rSzHehx7n4Xja0OCYQ/AKf6FuPqwvZM5YOA8OyOSZS88os5Bb5i06H0Zk55fMeFup/E074qB7EDcTvaTUc9kYCpYjlXGPvMY9BKYuCr+LscS2DgGK0udLuyFBYcdOMRKPIeZMvm2XFOBu9h+6Hg89l2nmqbjJDW15R+f0aaF0SFlGR28sikqndbKT4OprA1CsWaPl7oynwnrVjpZvbxAmdmijpLLrsCYfhm1jWewvBp+Zx4H0eg0NWRp76Snlx/5CrMLHfTtA6yhtIOZas0geGBDLwW9q/bXiJsJ9t1qGcIxdiGx/64oppqENZAkdVgdfEgQg1F1/y3leJ6dgOzMkWc+P70Mh0uPRha5L3/+IUZQ8CETeHHmPnuaceN+KIZzHtHle6Ws0/NZi6WLdYmRpsOrg6T/3GwvdV53SK/cZcA91xD4YNDQZEtdpVooZfBi6LPuQJT7AE0lssNTtbE9bWsGEg3zG4JmiXM+jh7AI7VoeFo/NTPb5iPG7UVmpgeYzl8bxg3tBZLmX2zHeOdcDo9PmVTQrQvINXXwawEQMbkTXI+bZCViAa2dRju1GtdYHCfcPxuNuO41XKoJvH/nvxzeYq//rA4Dfaw+T/aCv5wuvFo/YnedrzcUxcUjccaE3IRMBlZNLaiRgK2x56JEOf2SdsMJegcUtUbh3LRXIJ6jnIkkpyONL5a5Pmj5skAf
 UOuV90j0
 q5Un2dUORzThzW14yVLAJYS+o5NngoJqO3V4KXy78BTyStZJq8/ezvrkc73IT9pqPp5blHKB1c0DsTHqj/lEzDYlg0F+eW74IytQMHVDpg2sdnXczWHtT2HrBlo67z/FJxMkO2rtNC/9q1I2Ia0VtFRbNL8/iy3oCpn1q7tIehG9Z2ehqvSSP7hvNZoFCnmnqSTrBwoodIGjITdImL41e/DD31BuZC/14IA6WArT+Z736C0oxuMx5XKzriEthSKpbzjEnrS+10uQnwOPCw0zxf+en9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 7:53 AM, Shakeel Butt wrote:
> On Mon, Mar 09, 2026 at 09:17:43PM -0700, JP Kobryn (Meta) wrote:
>> On 3/9/26 4:43 PM, Shakeel Butt wrote:
>>> On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
> [...]
>>>
>>> This seems like monotonic increasing metrics and I think you don't care about
>>> their absolute value but rather rate of change. Any reason this can not be
>>> achieved through tracepoints and BPF combination?
>>
>> We have the per-node reclaim stats (pg{steal,scan,refill}) in
>> nodeN/vmstat and memory.numa_stat now. The new stats in this patch would
>> be collected from the same source. They were meant to be used together,
>> so it seemed like a reasonable location. I think the advantage over
>> tracepoints is we get the observability on from the start and it would
>> be simple to extend existing programs that already read stats from the
>> cgroup dir files.
> 
> Convenience is not really justifying the cost of adding 18 counters,
> particularly in memcg. We can argue about adding just in system level metrics
> but not for memcg.
> 
> counter_cost = nr_cpus * nr_nodes * nr_memcg * 16 (struct lruvec_stats_percpu)
> 
> On a typical prod machine, we can see 1000s of memcg, 100s of cpus and couple of
> numa nodes. So, a single counter's cost can range from 200KiB to MiBs. This does
> not seem like a cost we should force everyone to pay.
> 
> If you really want these per-memcg and assuming these metrics are updated in
> non-performance critical path, we can try to decouple these and other reclaim
> related stats from rstat infra. That would at least reduce nr_cpus factor in the
> above equation to 1. Though we will need to actually evaluate the performance
> for the change before committing to it.

I could trade off the per-cgroup granularity and change these stats to
become global per-node stats.

