Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFF1C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718BE6B008A; Fri, 18 Sep 2026 16:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0096B008C; Fri, 18 Sep 2026 16:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DD56B00A2; Fri, 18 Sep 2026 16:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41A546B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:24:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE9B8807D4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:24:07 +0000 (UTC)
X-FDA: 85228009734.10.4B3484B
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C6531C000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:24:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LKxEZyKC;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789763046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wuXubIIGSeWyvFFf022/3pANKLlXHUdxL8eUxbVbPY=;
	b=TDZjCCNjx2Ind8NGyBVJ8ee/ZvG7U/61l87B9SWqkBpwykZwzxgVCZ01zlGbZ7gFfU6n7X
	YzfLFlgWbL17W5+ZNp1S40e97HFyPMzGGBbsIgMS0g0UnoV1BtFMiLA8M45TuL0WuOsvbi
	O8AZ//FzbeYJHsdJ5dqtSGfUT7V8MII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789763046;
	b=JdOUq+RBnfsKhJKSdXDO0FtH38xEXkHR5c5aXJyNShFDp8NxiZ90cqbrhDTTGcPv9vhksj
	OV9ZFHnBEoq0niiHf15LOBANgYQPBBQ75VdVRNKK7idkgvO0VUJJs0W0ZI02K75yhdvfLG
	6eHXsDYFRxRj981gaezw4YU8y/USYig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LKxEZyKC;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eT66H6iANzWDoxgeBfogAllHhpEDQptXi80Z7mxNldQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789763044; v=1; x=1790367844;
 b=LKxEZyKCj+P+NQJ3YggNKSwHcQ4kkGKVl0EHrOOnZow5edCGHpAfIXqAVI0s3Y7zD4OC+qbj
 7zEk7CEe0Rh6cFauNgTgXtdJuf5Lt08oib7ms4cTox6MrFv2X96OwcCuWUF9bab/WPgzcH+fvgY
 +Ts9YSSRsRoiTja/6Zg3GKps=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5e90c63acb495c08;
	Fri, 18 Sep 2026 20:24:03 +0000
X-Mizu-Trace-ID: 5e90c63acb495c08
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 13:24:01 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bingfang Guo <bfguo@icloud.com>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq2dkhBuFktQYvTB@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev>
 <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
X-Stat-Signature: auzkmy63xb4ds76kpcrnf6ec8nt6ypq4
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C6531C000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789763045-640964
X-HE-Meta: U2FsdGVkX1+Sv/Imjd1kjtMRIjBTXINmU5opx9E850qEgL7t4z5sGVy4Fpf9OtN9LXpWnEGddTWcEwDNojRaXEn83sIf43Lr5nOIOfV5j48GOM8ZNAW35BWHmQRettZi/Lmpy0lvuE5QMOCliwgZcbMwkbQVgO5bQdfUXzMSM0yFKdyCeV/GIf4YCIVGxRup4iaWAdB+xye1eviGNf8OkKiVVj11nEfn+PrX4YBPc/LPCQTOWvOMamAD0k5umAr8WHTY7fU8LQOrvuVu8hW4YO6IY84oZvDC9v8i/0DkBsEpS06RUv35cDPa1h6qROtx62SS4kYn+5gRJVmY4ncL+ojk9YuG+KcCblMkt+bVjPDOSDd8+xbBsKYlwctAxsL3e9/BzCFXl+cQ9Y9ikijkBSRkBHG91/ApSYB4LErbgYxsX7OGTYhJ20/BS4n2KLYnDc8+eHLHK6zZ1Gdi0CnExh3t59BgjKRZOtw7Cy+oNTlPbZNYzHKem3IbC0EGOe+UjplHld6FAqzmevjmCj+k9JwQRzwSpvZrM8JuU2bds/hsj9L/R2Irag33EuUpjriM0N//CRYMeH90AhkRKNmJ0ofRZDYLJnb6t+uZte0ry5F7WhBNO4Ah/gCHmMSUyk44CP3jEhzQ16Z6CV6zcKEG4Pz3gB56m8ZabbCNvHNACSTVR3DDAtEMOQMCW5FG2olFHuL5WaefDfyDjOsJiM/w3eTl4i3Y8Sl9Pqf9mmJeEG15Orj3RNsmcGvIOQNifU8oLnpWXzoFhVQZp6xcVv7sXd17qufL+BldYIwT31gQvtr3q61pqbSBEOUsWjiaLK/3yuk4zkTho/lRlDqmWXlwxir+ojdnXMviPX5Axx7uQ7WUkEdhV9bxVzGEVFnxNvlBFwyM9fB//v+S6nJ8pCtiVrUg2CIJuZ2rFGwhpkqnwt/2ConMHdOtRzHd46sbt5QZxCKwcG2YVykdQhGEtKh
 ZGEp0UlV
 cSb2Kl4J1Y8SQzRWtCKq3XwOByk2Xka1PBoRSFryT+un8deCLh9qX3mCHPm4F5ORqHIcBpQSa9mtV7WwXJZ1gXVER8hq/BbfHojawv9iOPAPThdrXPcVi1Yqlvax6oEdUAH4UOVnQBwq42EfD33c6oMmHJ8wE33d2HM4wlfh8uW3tisoGZ9WL3Ywi+xYB9cpRc9R6VgzihnrCRs8T9TwuG7lEu4y7LImYgegF2x3Ia4N3Egmf7UiOcqMfNeGeJwY3YVRS99ZoMCy6N0dJz5m0vn3ffgENj+oaHYKQC+6JnPjD/Oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 02:46:52AM +0800, Bingfang Guo wrote:
> On Fri, Sep 18, 2026 at 11:14:03AM +0800, Shakeel Butt wrote:
> > On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> > > From: Bingfang Guo <bingfangguo@tencent.com>
> > > 
> > > This is a preparatory work for moving memcgid from memcg to objcg.
> > > 
> > > Swap entries retain a private ID rather than a memcg pointer. Once
> > > private ID references are moved to objcgs, the ID can also outlive the
> > > memcg to which it was originally assigned.  So it's better to make the
> > > get and put functions accept the ID itself instead of the memcg.
> > > 
> > > Rename mem_cgroup_private_id_get_online() to
> > > mem_cgroup_private_id_get(), and make it return the ID only.  If the
> > > memcg is already dying, the dying memcg will still be used for charging
> > > and stats accounting in v2 swap charging path. But they are hierarchical
> > > and will be reparented after offlining so it doesn't matter.
> > > 
> > > Make mem_cgroup_private_id_put() take the ID and resolve the reference
> > > holder internally. Convert swap uncharge and charge rollback to release
> > > the reference using that ID.  This introduces an extra xarray lookup for
> > > now, which will be removed in the final patch.
> > > 
> > > Separate the online-state reference release into
> > > mem_cgroup_private_id_kill(). The offline path already has the memcg
> > > pointer and can call the underlying put helper directly.
> > > 
> > > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > > ---
> > >  mm/memcontrol-v1.c |  7 +++----
> > >  mm/memcontrol-v1.h |  3 +--
> > >  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
> > >  3 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > > index ed015fdd95123..b7f2868885071 100644
> > > --- a/mm/memcontrol-v1.c
> > > +++ b/mm/memcontrol-v1.c
> > > @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> > >   */
> > >  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> > >  {
> > > -	struct mem_cgroup *memcg, *swap_memcg;
> > > +	struct mem_cgroup *memcg;
> > >  	struct obj_cgroup *objcg;
> > >  	unsigned int nr_entries;
> > >  	unsigned short private_id;
> > > @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> > >  	 * if the ID refers to the root memcg.
> > >  	 */
> > >  	nr_entries = folio_nr_pages(folio);
> > > -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> > > -	private_id = mem_cgroup_private_id(swap_memcg);
> > > -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> > > +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> > > +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> > >  
> > >  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
> > >  
> > > diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> > > index 23be2512702dc..281425273ea97 100644
> > > --- a/mm/memcontrol-v1.h
> > > +++ b/mm/memcontrol-v1.h
> > > @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
> > >  	return id == mem_cgroup_private_id(root_mem_cgroup);
> > >  }
> > >  
> > > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> > > -						    unsigned int n);
> > > +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
> > >  
> > >  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > >  				       struct mem_cgroup *parent, int idx);
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index bfe53e4392f09..ed44b3e7ac938 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> > >  	}
> > >  }
> > >  
> > > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > >  {
> > >  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
> > >  		mem_cgroup_private_id_remove(memcg);
> > > @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> > >  	}
> > >  }
> > >  
> > > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > > +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > > +{
> > > +	struct mem_cgroup *memcg;
> > > +
> > > +	rcu_read_lock();
> > 
> > Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
> > already taking rcu read lock.
> > 
> 
> Thanks for pointing out this.
> 
> Agreed.  Both two callers are already holding the rcu lock so
> taking the lock here is unnecessary. So I will drop the
> rcu_read_lock() and use that in the next version!
> 
> My concern is that: mem_cgroup_private_id_put() looks like a
> universal put function, requiring rcu held (which is true today)
> is not that obvious to the users.  So I think adding a short kdoc
> comment to make it clear later might be a good idea.

This function is internal to memcg code, so whoever is going to call it better
know to call it with rcu held because of lockdep assert. No need to have a
comment.

