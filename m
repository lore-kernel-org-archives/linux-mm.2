Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5E4CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 19:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116796B0005; Sun, 17 May 2026 15:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0816B0088; Sun, 17 May 2026 15:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB466B008C; Sun, 17 May 2026 15:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4A6F6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B28916117C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:39:02 +0000 (UTC)
X-FDA: 84777924924.07.4EBF348
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AA27C0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:39:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KvufxR/3";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779046740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkkU2txQqya1KzbYt5PMEvI3vCZlClG1M28QDAsLkFw=;
	b=v5eYQFoI3YG05B7iAwuISjPrClAOvV/g2Nuo4oFxvJfwJ/HmWEdq7V0nI1VGSUamUPlmYb
	aESP/V0USgVkwK669TuHGiwzDSVlsGAypzinv9Xn2KdgyD/Vm1iUlCXEgsRA6bZ7KfSBdJ
	wnCEcDRSNKpV7944lt+zzlFcFqDd3Q0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KvufxR/3";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779046740; a=rsa-sha256;
	cv=none;
	b=LlTuw9wfPH/7FNGQD6Z92e8QKlTPI1CWBWjrKsf+UYIAtA+uoxHSgBhtdHWKlHnGmdCiRv
	FZ6HyRlTSOOJAlSf5zwPvIFOcSiofEVjgQnIvZ6bbMccqn3TlKspTw2mx4hfgi21r310Jg
	VGsMY7/f0Kq8g+u+2I381aqRaqZOEA0=
Date: Sun, 17 May 2026 12:38:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779046737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vkkU2txQqya1KzbYt5PMEvI3vCZlClG1M28QDAsLkFw=;
	b=KvufxR/304uZuZv6UxWYGC+8bRKN236iAvZRN9h4jixNisdBoosVkl6EOB9hUTACy4mz7q
	rPUaLmVozzx7+BvKWCNjmAJqyih51pF+mIvC23rNvHO4gq+cnSOG416J1cpCWIVuB1rv5H
	owXLIB+F8rXR3/xK/mu0a08FPaTuc4I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Allen Pais <apais@linux.microsoft.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chen Ridong <chenridong@huawei.com>, 
	David Hildenbrand <david@kernel.org>, Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	Imran Khan <imran.f.khan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kamalesh Babulal <kamalesh.babulal@oracle.com>, Lance Yang <lance.yang@linux.dev>, 
	Liam Howlett <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
Message-ID: <agoYp1zW9afZ6uQz@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
 <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
 <agSAT4ldp3dzKWPl@linux.dev>
 <agSJ4ulNDZ17ah8H@linux.dev>
 <46e9f5cf-34cb-466d-a53a-5778768af4d9@linux.dev>
 <93b7c3f206f158e7387cbb5f0bf5845b59b93053@linux.dev>
 <19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev>
 <agdS5rIhcjIBVSog@linux.dev>
 <agm61hMv08XnV8sI@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agm61hMv08XnV8sI@xsang-OptiPlex-9020>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ceeyrg4idf6e7d1rtyhf8ba3hdxgau8w
X-Rspamd-Queue-Id: 3AA27C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779046739-967940
X-HE-Meta: U2FsdGVkX1/8o3Vj5j/ESpR5EzCmbf9rYagDrfA4oDvKbfbfItZ7/UBkzBlAqlUCe7uv4TqBkezRSTqX+o5PDaYf/tWCjEC0ulcfnUH8BqR370jn7eqVznY5UFkK/MGSRPTkHDRKbq+JFyBRk/YkRr82fVof6KxWPJDUwkNUiGch01APGabOXfRYsLsyVPQ6ZWPU+dIjG/OwoqxUr/1D+SO2gNY8i0kfwHilv5/8r1fz5zvxFT9sSnOOI8BUlEW7aIPc8MpNKaES2l8A+BrmMIl4uOkdlkBl4cPQx+AktS/4ZR8UYIisiXl70XqkPNBC8Ca9D1k+Cm3sBRr0Bid/7hlTFGhXBGhSekr5JaZlAE05zEkUT7HQSkYJwQSK4BDR4UUrKPrlCf/OScXpPJAOM/22mbtpThC8lpC3gi9JEd/pR1MjDMEXkJA+eR42DjG8b2FBthDpbn4T/inkNYAxe3Y+4Tfd5Prybh/TLa6Oow7d9v+ld0yl/j8hHVSUIR1JBE4qPVXptLBRI+FtZzQO1H6ftQMFC1Xp0xs8hnX6oqcrPQbdvPOKHnj8k7aYj960inRdjgQ6kkpFgfCGnmd56zuEiDFP0MJ7X1viMcdUmTgKMKY0lE+xw/eIAaVe/FwxzaIRui6vFc2U/kfRTMQeuh1Oh03Zs2TYtKn4KV6ut+JLLO7knwdXtxbvuU5cqzKIFN8fjcbIhayr5I7pVg5FhMrM9l4jhhTfhUBASl5S48xQ6BHgYkhpLTE53dx7oxRMetGmnhTQ9Ir9+moPvkbPTvWD16u9FiE+cjUUeqhUPCT5MirOO+QFHPZOflHZgsARhjjZnXgqATsl+0JUyuIDZXBDuGZ29wB5J33+11+TKcbS0qm5gqnpGyIxlxegYBTPUnwyRDudRHB9v5cR/Z4HoxGp+aX84cmpoYOC04KylocCdUW5O7zuOSu/OyAlVUBRouw9Pvv9yOd+Rfl0NVQ
 LHydUzUe
 H7YJ0rTbRK9SnA0FqvNZZAdN2ARccV/4UbxCqp2e13C0huMInWePM54bKu9Q/I2SOey7nMGwx/fRZVVdSYdsGYvdgQyvKLNsObWiNxbQJ9t59GcXiiZregi4kepOXCyLxESnls6TGSVIBzNJbmkQRmDkPK3oKn2TjKhUyM7o2U95m+ZTpZpuiUDrxVz0ovkp21Hk/sQZbdMy5ONoB+V/UPJZ1L+gmDBNoIu6Thzt2Ebs+PK8Y+fHuugSApUIW4sYZxGHXahOa9d+HtIhLAoYfPX+ubvm9bLCxejdk7trciA/RTeNrg12LgdlWlGvcOi9ipdUHDdsOYb2ZtrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 08:55:50PM +0800, Oliver Sang wrote:
> hi, Shakeel, hi, Qi,
> 
> On Fri, May 15, 2026 at 10:09:06AM -0700, Shakeel Butt wrote:
> > On Fri, May 15, 2026 at 03:37:22PM +0800, Qi Zheng wrote:
> > > Hi Shakeel,
> > > 
> > > On 5/14/26 9:40 PM, Shakeel Butt wrote:
> > > > May 14, 2026 at 12:46 AM, "Qi Zheng" <qi.zheng@linux.dev mailto:qi.zheng@linux.dev?to=%22Qi%20Zheng%22%20%3Cqi.zheng%40linux.dev%3E > wrote:
> > > > 
> > > > 
> > > > > 
> > > > > On 5/13/26 10:27 PM, Shakeel Butt wrote:
> > > > > 
> > > > > > 
> > > > > > On Wed, May 13, 2026 at 06:49:45AM -0700, Shakeel Butt wrote:
> > > > > > 
> > > > > > > 
> > > > > > > On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
> > > > > > > 
> > > > > >   On 5/13/26 12:03 AM, Shakeel Butt wrote:
> > > > > >   On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> > > > > > 
> > > > > >   Hello,
> > > > > > 
> > > > > >   kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
> > > > > > 
> > > > > >   commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > > > > >   https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > > > 
> > > > > >   This is most probably due to shuffling of struct mem_cgroup and struct
> > > > > >   mem_cgroup_per_node members.
> > > > > > 
> > > > > >   Another possibility is that after objcg was split into per-node, the
> > > > > >   slab accounting fast path is still designed assuming only one current
> > > > > >   objcg per CPU:
> > > > > > 
> > > > > >   struct obj_stock_pcp {
> > > > > >   struct obj_cgroup *cached_objcg;
> > > > > >   };
> > > > > > 
> > > > > >   So it's may cause the following thrashing:
> > > > > > 
> > > > > >   CPU stock cached = memcg/node0 objcg
> > > > > >   free object tagged = memcg/node1 objcg
> > > > > >   => __refill_obj_stock --> objcg mismatch
> > > > > >   => drain_obj_stock()
> > > > > >   => cache switches to node1 objcg
> > > > > > 
> > > > > >   next local allocation tagged = node0 objcg
> > > > > >   => mismatch again
> > > > > >   => drain_obj_stock()
> > > > > > 
> > > > > > > 
> > > > > > > Actually I think this is the issue, we have ping pong threads running on
> > > > > > >   different nodes where though theu are in same cgroup but their current->obcg is
> > > > > > >   for local node and thus this ping pong is thrashing the per-cpu objcg stock.
> > > > > > > 
> > > > > > >   The easier fix would be to compare objcg->memcg instead of just objcg during
> > > > > > >   draining and caching. In addition we can add support for multiple objcg per-cpu
> > > > > > >   stock caching.
> > > > > > > 
> > > > > >   Something like the following:
> > > > > >   From d756abe831a905d6fe32bad9a984fc619dafb7e0 Mon Sep 17 00:00:00 2001
> > > > > >   From: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > >   Date: Wed, 13 May 2026 07:24:55 -0700
> > > > > >   Subject: [PATCH] mm/memcontrol: skip obj_stock drain when refilled objcg
> > > > > >   shares memcg
> > > > > >   Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > >   ---
> > > > > >   mm/memcontrol.c | 14 +++++++++++++-
> > > > > >   1 file changed, 13 insertions(+), 1 deletion(-)
> > > > > >   diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > >   index d978e18b9b2d..01ed7a8e18ac 100644
> > > > > >   --- a/mm/memcontrol.c
> > > > > >   +++ b/mm/memcontrol.c
> > > > > >   @@ -3318,6 +3318,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > > > >   unsigned int nr_bytes,
> > > > > >   bool allow_uncharge)
> > > > > >   {
> > > > > >   + struct obj_cgroup *cached;
> > > > > >   unsigned int nr_pages = 0;
> > > > > >   > if (!stock) {
> > > > > >   @@ -3327,7 +3328,18 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > > > >   goto out;
> > > > > >   }
> > > > > >   > - if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > > > > >   + cached = READ_ONCE(stock->cached_objcg);
> > > > > >   + if (cached != objcg &&
> > > > > >   + (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
> > > > > >   drain_obj_stock(stock);
> > > > > >   obj_cgroup_get(objcg);
> > > > > >   stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> > > > > > 
> > > > > This change looks like it should be able to fix the ping-pong issue, but
> > > > > I stiil haven't reproduced the performance regression locally. I'll
> > > > > continue testing it.
> > > > 
> > > > Same here, couldn't reproduce locally. It seems like we had to craft a scenario
> > > > where the pair pingpong threads get their current->objcg from different nodes.
> > > > I will try that.
> > > 
> > > I still haven't been able to reproduce the LKP results locally, but I
> > > used an AI bot to generate a pingpong test case (pasted at the end) and
> > > automatically ran the test on a physical machine. The results are as
> > > follows:
> > > 
> > >   parent: 8285917d6f
> > >   bad:    01b9da291c
> > >   fix:    01b9da291c + stock patch
> > > 
> > >   | kernel | mq_ops/sec mean | vs parent | drain_obj_stock / round |
> > >   |--------|-----------------|-----------|-------------------------|
> > >   | parent |     9.743M      |  baseline |          ~0             |
> > >   | bad    |     7.821M      |  -19.73%  |          ~11.16M        |
> > >   | fix    |     9.274M      |  -4.81%   |          ~0             |
> > > 
> > > Probing the drain_obj_stock() calls confirms that the fix restores the
> > > frequency to the parent's baseline.
> > > 
> > > And it seems that besides __refill_obj_stock(), we should also modify
> > > __consume_obj_stock()?
> > > 
> > 
> > Thanks a lot Qi. I will send the formal patch and will add your Debugged-by if
> > you don't mind.
> > 
> 
> Tested-by: kernel test robot <oliver.sang@intel.com>
> 
> we tested above patch, and it recovers the regression:
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/method/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/mq/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/switch/stress-ng/60s
> 
> commit:
>   8285917d6f ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
>   01b9da291c ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>   682fd4e9ff  <--- above patch from Shakeel
> 
> 8285917d6f383aef 01b9da291c4969354807b52956f 682fd4e9ffd4009805f81dd25ed
> ---------------- --------------------------- ---------------------------
>          %stddev     %change         %stddev     %change         %stddev
>              \          |                \          |                \
>       5849          +210.2%      18145 ±  3%      +1.5%       5935        stress-ng.switch.nanosecs_per_context_switch_mq_method
>  2.296e+09           -67.7%  7.408e+08 ±  3%      -1.4%  2.263e+09        stress-ng.switch.ops
>   38288993           -67.7%   12355813 ±  3%      -1.4%   37739220        stress-ng.switch.ops_per_sec
> 
> 
> full compasison is as below [3]
> 
> but there are two notes. 
> 
> #1 is that we noticed there is a fomal patch later from Shakeel in [1] which has
> more changes. not sure if this test is enough? do you want us to test [1]
> further?

Thanks Oliver, I will send a v2 soon, please test v2.

> 
> #2: when we test above patch, we found the server easy to crash while running
> tests. we try to run up to 20 times, only 2 of them run successfully (above
> 37739220 is just the average data from these 2 runs, since the data is stable,
> we think maybe it's ok to report to you with this data).
> we also noticed for [1] there is a [syzbot ci] report in [2]. since we don't
> have serial output for our test server in this report which is for performance
> tests, we cannot say if other 18 runs failed due to similar reason. just FYI.
> 

The syzbot report is simply a rcu warning which will be fixed in v2. Do you
have more details on the crash you are seeing? Is it page counter underflow
warning?

Thanks again for the help.

