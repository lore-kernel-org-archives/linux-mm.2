Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C93DCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB756B00E2; Wed, 13 May 2026 10:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C156B00E3; Wed, 13 May 2026 10:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BB56B00E7; Wed, 13 May 2026 10:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 634F56B00E2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:27:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13207160126
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:27:35 +0000 (UTC)
X-FDA: 84762624870.20.257CB5A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33AF04000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:27:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSK6UKwk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778682453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT6KxnKuDG1JfLVVwS36wJ8yrLhF0nn4rcZS0tX7pQM=;
	b=N8E9vdDykoYPD40LKicsqSpgVp11zq96jhymJB00UKuWGJZRSLxN7J2qwl1w++49bcpXMb
	5CmNjLM5cz0ggl8kwZZbXvnvxtHGnRCHoBOzU4NHTUlpvIF+/1wkfGSJasjP4b8JQDdSZX
	+zeQf7HCbJG+9EbuNabV4+0ocGVb2Zk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778682453; a=rsa-sha256;
	cv=none;
	b=7+/YrK/640joLPbM5wbX77A/RilGeiQBWIAnHl8EfNKjCp2qjYpRCwzNbYlCn39J0Nk6uT
	KXmSFexB+yiPp69zQHI8E0nQeIWHkdswtr4Amtbg/SfrbtLpm2WNpW+iQ4giThFSZTKsOt
	2Qa04l0OMa7IulmdO15h+pTCDdn3CV0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSK6UKwk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 13 May 2026 07:27:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778682450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OT6KxnKuDG1JfLVVwS36wJ8yrLhF0nn4rcZS0tX7pQM=;
	b=kSK6UKwkJV4guHYiDnTwdaxVuAQy0iSI+VE0KvC0Z6NJkwMmxZ6zjNSsPG1BsjELGVPtHU
	YQGGEQ04qJDqNky7sxs1usfZXIDNVbmVO/b7z1G1H1VxySwk/FeVpk1Nv5Wk4hWp3wivo0
	9618ELZQyQLdm6EPn9e588IlFeaCEkw=
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
Message-ID: <agSJ4ulNDZ17ah8H@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
 <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
 <agSAT4ldp3dzKWPl@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agSAT4ldp3dzKWPl@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33AF04000A
X-Stat-Signature: 8ekuk5qjhgpcy7jyni6uwmhk9icfxjrp
X-Rspam-User: 
X-HE-Tag: 1778682452-597671
X-HE-Meta: U2FsdGVkX18U+t6bCT/llowj52JB8vJCEvNTKL4LrMSjoJVYuy7plCMVwIqXykYzSpOdvhov/MHs9orD/fbeGLIE9SU9HIty64+5RadcPy8ikJ5mfJUPXGRdeOrFQJpUlYUzA1g2aMGHzip365jOzYImVbmmQXngSVHwvEicFoY2p2FOgo+KyWIbzMLDrgj46BGVH3q23t8V5PypWzZzJXm0jSecQEuM8HEyLgbgoF0w2Rt7kibs0qA2U4TaFSbMKPa6IvFvDaPTO4QVkpxNNzl0uohcYG9Xe4K7rFWzXfqmI89kSDfqihPwgBgF+kOpf8vHRiseUnpkThHzRSTN3DtDE3VwiR9rftAkDPNOdD/VUaQPzN+NZaU2Dgo3gyk5KiU4siAsSSdQ6nkD4MfR9wQ3tGLkcmNTpGkERYCTqUNA5WMGKhzYtS54mz900MOxaSiqN8BRqUaWoWTGDIhImv7EvIct8157RTAwp/Fu/7Tebd6h6JPU5IuAyPwV3hFwOg8MM+Nq7M8nnX+4kZmkvVO71QwRmXas9M5awzzRP3Zt/StFshUAvcdoIm9cMJUjgwQq5+T2tmoV+K71QAQvioJDPlxe6dqVGPILxrvqXX7711dPj9rSVy9BEZ5HRsuEcFJte/RH9LxqcOfUOfvKJMItctuFvNqIDK7KzJ3au28zwGUbOXbptZSXo0uLyZ0Pn+pwIDiqYqli1VuB1Y5Fj0N+7CNhWIPrBRFRMno+pQdtpqJ65SY4pHAujkzh5aTSq0+aP4cuIXyxafAQjXh8rup2wQJx1J75TEkrXWc7KmQDF2ezbhYQgV8f3JO61Liwb0wdy9ja/Ga4p1u8LpruzlF8fZKfZ4aAt8bRCpvc1dDYQ8j8PEkgCyH3vOUaoTIM6a5ouW3TMo92NdmVDjCKjjnE4W9kbRJYpU/s8pEn18bRnuyEnpI/NnYvPT0lhQMhAsSwcP1RLi4hMsCNakF
 cSQ3Wiwa
 dHXnRV/HgQXI1k3MwFi7/4zYtinxnsND207VkHnJijdnrudAgjMmFa3DxAZbZ2Qu+di7te4CtjwPu49NdekC7dpN3Y+zzfCduYQYIwZRtKwhC9us1/fcEBH0G26u9tOskFvUavV2qxNDnRawxRug99cXvxwq3cpBlDlqJXnfrWsKsxTeqXdB9xuLWCW6St2Mk+OZe84HYtonH/TqwKUb7iwpNvit6IA0EX+TjSSl1QMuSLscjus8asPa+tVD3z5tHFJVEWzHHA4e7znuNv6rxpi5WDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 06:49:45AM -0700, Shakeel Butt wrote:
> On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
> > 
> > 
> > On 5/13/26 12:03 AM, Shakeel Butt wrote:
> > > On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> > > > 
> > > > 
> > > > Hello,
> > > > 
> > > > kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
> > > > 
> > > > 
> > > > commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > This is most probably due to shuffling of struct mem_cgroup and struct
> > > mem_cgroup_per_node members.
> > 
> > Another possibility is that after objcg was split into per-node, the
> > slab accounting fast path is still designed assuming only one current
> > objcg per CPU:
> > 
> > struct obj_stock_pcp {
> >     struct obj_cgroup *cached_objcg;
> > };
> > 
> > So it's may cause the following thrashing:
> > 
> >  CPU stock cached = memcg/node0 objcg
> >  free object tagged = memcg/node1 objcg
> >  => __refill_obj_stock --> objcg mismatch
> >      => drain_obj_stock()
> >      => cache switches to node1 objcg
> > 
> >  next local allocation tagged = node0 objcg
> >  => mismatch again
> >      => drain_obj_stock()
> 
> Actually I think this is the issue, we have ping pong threads running on
> different nodes where though theu are in same cgroup but their current->obcg is
> for local node and thus this ping pong is thrashing the per-cpu objcg stock.
> 
> The easier fix would be to compare objcg->memcg instead of just objcg during
> draining and caching. In addition we can add support for multiple objcg per-cpu
> stock caching.

Something like the following:

From d756abe831a905d6fe32bad9a984fc619dafb7e0 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Wed, 13 May 2026 07:24:55 -0700
Subject: [PATCH] mm/memcontrol: skip obj_stock drain when refilled objcg
 shares memcg

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..01ed7a8e18ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3318,6 +3318,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3328,18 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	if (cached != objcg &&
+	    (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-- 
2.53.0-Meta


