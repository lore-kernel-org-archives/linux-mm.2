Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC9CCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DBC6B0088; Fri, 15 May 2026 13:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4F26B008C; Fri, 15 May 2026 13:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B227B6B0092; Fri, 15 May 2026 13:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F06D6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:09:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74572A01F7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:09:29 +0000 (UTC)
X-FDA: 84770290458.23.7EB9EE8
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4681B1C000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:09:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JgSAS10i;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778864967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4UL7gdJHu2wJk4N7LvRYzG8TK4uSgIT2pJ8INY3wtc=;
	b=LoUiHZA92v8l3qKI1ce7bpMzZNkYWN+Mw1001tmOXucieSUYJq5sRXU0O8/7mSi7SXbUOl
	DqrJq95yR15Za/GMt1HgWJQvkIVhweP2NHsfqu+TXTkPRmq2x2QWmcLWlKhTX/C3wPrRqG
	Csd4qYX1me6776hUYp6cf7C9ckAkLV8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JgSAS10i;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778864967; a=rsa-sha256;
	cv=none;
	b=NTXtu5PsiWq6VlhZHTj8BHlaOtyVKH3wgsbuQsX6MBH8UPjU9IJ2r9fRUFehOdJcUxLMC6
	RjddCaukw80wGZZU4FiiSPenrzBTJbV4Rfj0TUJzQffba++FASOnbBQ5weYQLXGTfTRqsB
	sDI+xCR4xdDovXx2jAb1DNQpKphMqAA=
Date: Fri, 15 May 2026 10:09:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778864964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4UL7gdJHu2wJk4N7LvRYzG8TK4uSgIT2pJ8INY3wtc=;
	b=JgSAS10iDi9/vbFjbI3BcdtTFV8xXmKFuN5EPhpm/zJSF7th/Gr0MlMMnryJlKYM2DZp/n
	ju01KenC4gL4rqqhYTRO/ftIa9Rl5C5lLsTnH5hBMU2XrKOoOcaahvfmfosnSlmeZ4RBL2
	QZsLjsv8VFyP9Erf/uba2NKD+Q/iTEo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Allen Pais <apais@linux.microsoft.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baoquan He <bhe@redhat.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chen Ridong <chenridong@huawei.com>, David Hildenbrand <david@kernel.org>, 
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Imran Khan <imran.f.khan@oracle.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kamalesh Babulal <kamalesh.babulal@oracle.com>, 
	Lance Yang <lance.yang@linux.dev>, Liam Howlett <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
Message-ID: <agdS5rIhcjIBVSog@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
 <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
 <agSAT4ldp3dzKWPl@linux.dev>
 <agSJ4ulNDZ17ah8H@linux.dev>
 <46e9f5cf-34cb-466d-a53a-5778768af4d9@linux.dev>
 <93b7c3f206f158e7387cbb5f0bf5845b59b93053@linux.dev>
 <19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4681B1C000A
X-Rspam-User: 
X-Stat-Signature: tyaxz4buz5boibbjka38g9mh6ixrd7pw
X-HE-Tag: 1778864967-357701
X-HE-Meta: U2FsdGVkX18p0TZsSdosmaH3nbMPx3nyXQR0Ynd5Mx3tJRGa0PuHRpXRqy/DpX0UELpomwbX2sETfXRGK36ZIXyqOgZ17jboM1Hh2e6vrAXBB70Z4VMw/GL2ZMPk3rm1rooMqOSKfl1okZQAWEj/Lo0Lwcnz+yishihlnmSMnmiYAH1Dc2kb1Anl7q/Nbfm31XRUm4DWv/NAODaqwKf6gvZMnVU7iCBJ3wZKFgl6zOJBY5/wKlhmM/NHTYMEYIlh/1Ktnb4T+kWKd2QqZNyE6DDCBZohxjNQxHEmIF/Z70EbZMJ8J6A+hNzx1h4P1jfN6XmIXgYf6MHPmuS4yOmyR3b/aKyG+TCvQ26Cp8c10k3wny2Y9COnKYnFYD4BysMs7HuyBnWg1C/tN+PytyGiC243BVOJwsW+57eIfl+u6Ti5Awku8Z5I9sFlXt0X2zcD74byQyWwpr4ZQF79qYmlmZ7E6Ju8oB9CwhRAA0sheadyp6fkYUWzQfungNW/hLF4kBACrluDuuBxEO/80XeRw7RWTgzRlNay2qZxrBFEJJeZV+VZ12ddhvPBrF8fvVq2KMu8R96qJZR5WSNWNCARRcO2tYp6ACAhb8FfJ51CX39JouevDCgxHhNXjrw13wW4s1Onz+2tu/BbiTLJdXmXwtYVxsHTh8wlp3f5iZkT6OONtz/HpNwR9bYDiGtq/ePaiemPQ8MrccClq1fBs/hQFyTYHYb5xDQONK59ZTXXv4u+eLQqJrGYm+p6guDSasDWLjzwdx/b32YhT9Xs+xDJW2XbqasSqmOt/1hjJpyVNPLdqIYElFEudpsHiRL6DnN+sNWl7+Bekb8PXMvrOD/T/K2VK5B43oSpfTnB8pS6NJ8rQTAqpycGp9IrasKpj9PSuE9H9OkxbxbhherqXhH3AlXEE+v0qq/bEICJQ93q8czHoIQfOVDlWGmZUzRuEakiYT3tQio0GPVVr1GKWH9
 g8p5KF9Q
 3O+7LWj3WRZcxtm2FECvozCLyp0sCFCVsT2GPCfB5qQLF1V7tUQw5NB0GFUWk5DtPo0Mx4KO10YwnNCbFaeuY7OSmDZkw55vh7xKNFNoWtaHq/FB2tab8pxjBJJfX4dVOwzR7c+Mjwq2YLHvI0hFsFMZFP346Ju9nNcyuhgvKcDf0GFRUtEQ2zSeiBGPi0Je2jbUlQndEtGcIOaVlr6OI6MYxwo8LwYcpUBzOu40HtaLGErqSo0RZZU6DYxDHbbt4oJR5RaoVSELhcDP2muWvTzsRIPSG3+2bTq6qj1rB+PtIMZEGEHjM9SK0sfnz9/TQKC58
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 03:37:22PM +0800, Qi Zheng wrote:
> Hi Shakeel,
> 
> On 5/14/26 9:40 PM, Shakeel Butt wrote:
> > May 14, 2026 at 12:46 AM, "Qi Zheng" <qi.zheng@linux.dev mailto:qi.zheng@linux.dev?to=%22Qi%20Zheng%22%20%3Cqi.zheng%40linux.dev%3E > wrote:
> > 
> > 
> > > 
> > > On 5/13/26 10:27 PM, Shakeel Butt wrote:
> > > 
> > > > 
> > > > On Wed, May 13, 2026 at 06:49:45AM -0700, Shakeel Butt wrote:
> > > > 
> > > > > 
> > > > > On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
> > > > > 
> > > >   On 5/13/26 12:03 AM, Shakeel Butt wrote:
> > > >   On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> > > > 
> > > >   Hello,
> > > > 
> > > >   kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
> > > > 
> > > >   commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > > >   https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > 
> > > >   This is most probably due to shuffling of struct mem_cgroup and struct
> > > >   mem_cgroup_per_node members.
> > > > 
> > > >   Another possibility is that after objcg was split into per-node, the
> > > >   slab accounting fast path is still designed assuming only one current
> > > >   objcg per CPU:
> > > > 
> > > >   struct obj_stock_pcp {
> > > >   struct obj_cgroup *cached_objcg;
> > > >   };
> > > > 
> > > >   So it's may cause the following thrashing:
> > > > 
> > > >   CPU stock cached = memcg/node0 objcg
> > > >   free object tagged = memcg/node1 objcg
> > > >   => __refill_obj_stock --> objcg mismatch
> > > >   => drain_obj_stock()
> > > >   => cache switches to node1 objcg
> > > > 
> > > >   next local allocation tagged = node0 objcg
> > > >   => mismatch again
> > > >   => drain_obj_stock()
> > > > 
> > > > > 
> > > > > Actually I think this is the issue, we have ping pong threads running on
> > > > >   different nodes where though theu are in same cgroup but their current->obcg is
> > > > >   for local node and thus this ping pong is thrashing the per-cpu objcg stock.
> > > > > 
> > > > >   The easier fix would be to compare objcg->memcg instead of just objcg during
> > > > >   draining and caching. In addition we can add support for multiple objcg per-cpu
> > > > >   stock caching.
> > > > > 
> > > >   Something like the following:
> > > >   From d756abe831a905d6fe32bad9a984fc619dafb7e0 Mon Sep 17 00:00:00 2001
> > > >   From: Shakeel Butt <shakeel.butt@linux.dev>
> > > >   Date: Wed, 13 May 2026 07:24:55 -0700
> > > >   Subject: [PATCH] mm/memcontrol: skip obj_stock drain when refilled objcg
> > > >   shares memcg
> > > >   Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > >   ---
> > > >   mm/memcontrol.c | 14 +++++++++++++-
> > > >   1 file changed, 13 insertions(+), 1 deletion(-)
> > > >   diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > >   index d978e18b9b2d..01ed7a8e18ac 100644
> > > >   --- a/mm/memcontrol.c
> > > >   +++ b/mm/memcontrol.c
> > > >   @@ -3318,6 +3318,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > >   unsigned int nr_bytes,
> > > >   bool allow_uncharge)
> > > >   {
> > > >   + struct obj_cgroup *cached;
> > > >   unsigned int nr_pages = 0;
> > > >   > if (!stock) {
> > > >   @@ -3327,7 +3328,18 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > >   goto out;
> > > >   }
> > > >   > - if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > > >   + cached = READ_ONCE(stock->cached_objcg);
> > > >   + if (cached != objcg &&
> > > >   + (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
> > > >   drain_obj_stock(stock);
> > > >   obj_cgroup_get(objcg);
> > > >   stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> > > > 
> > > This change looks like it should be able to fix the ping-pong issue, but
> > > I stiil haven't reproduced the performance regression locally. I'll
> > > continue testing it.
> > 
> > Same here, couldn't reproduce locally. It seems like we had to craft a scenario
> > where the pair pingpong threads get their current->objcg from different nodes.
> > I will try that.
> 
> I still haven't been able to reproduce the LKP results locally, but I
> used an AI bot to generate a pingpong test case (pasted at the end) and
> automatically ran the test on a physical machine. The results are as
> follows:
> 
>   parent: 8285917d6f
>   bad:    01b9da291c
>   fix:    01b9da291c + stock patch
> 
>   | kernel | mq_ops/sec mean | vs parent | drain_obj_stock / round |
>   |--------|-----------------|-----------|-------------------------|
>   | parent |     9.743M      |  baseline |          ~0             |
>   | bad    |     7.821M      |  -19.73%  |          ~11.16M        |
>   | fix    |     9.274M      |  -4.81%   |          ~0             |
> 
> Probing the drain_obj_stock() calls confirms that the fix restores the
> frequency to the parent's baseline.
> 
> And it seems that besides __refill_obj_stock(), we should also modify
> __consume_obj_stock()?
> 

Thanks a lot Qi. I will send the formal patch and will add your Debugged-by if
you don't mind.


