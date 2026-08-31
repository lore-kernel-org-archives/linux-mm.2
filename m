Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD6EC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1888A6B00A0; Mon, 31 Aug 2026 05:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139956B00A2; Mon, 31 Aug 2026 05:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075FB6B00A3; Mon, 31 Aug 2026 05:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3C46B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:01:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50C2314044D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:50 +0000 (UTC)
X-FDA: 85160971980.23.3D438CE
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4899B1A0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CIiH08Du;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166908;
	b=Xnm2XhJB8cqXvnxhtoWTvG74tzzR5hh5rFGFjBx9LfW3v3q9tD17nyKkRcT6zN32kJJPf+
	x0KvuzrwKuN+WQt/X5G43tFCeZ0dY1D9fOBLsWz8Xi2t0XcPF/LoDNib3bRH8839U0VQO0
	G2b7ti3TpBus4ArcE/rDse6S55k+Egg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CIiH08Du;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCYQqB2eNarvGe42PQFfyuGN0zW33B5LTLJOlRAO2Qk=;
	b=G3t135RB33TShvbexzt/4oGDDBy40YT0yxld5kboBBYW7sLv0keTWkjOAsP+QJSxZr10Bw
	J6i/4e3h4jstT40kh2fQE5cJv5ZTvQmPYKjBZ0UlYaezYVF2oeKH6GIW+4gwTr5bjTwg3y
	9rACnPuGO7c9mWcTE39sviDcdpbyl3k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D1aQ86jIVbMkJKLx7nT1bV+FUZb9BZSNSzliGFp7PO0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788166906; v=1; x=1788771706;
 b=CIiH08DuLIoyGa6j9TaEUbXzk9HgqHsSmYeSBs0iKur5PUOaxlraN2LbdZotflHXXv5Bd7Z0
 yxN7Xq9KoMg6CIVJU3F/gW9RXJ2lJFrAJVToPGLGVDfASNG5IOTVpvSIleGOurXcR5URM2k3VjA
 5KTwmOwULMNm8H1uzSf48uDY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fe6321a115680fb0;
	Mon, 31 Aug 2026 09:01:46 +0000
X-Mizu-Trace-ID: fe6321a115680fb0
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 17:01:33 +0800
From: Hao Li <hao.li@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, harry@kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apVAn6o1AVzWM8jB@fedora>
References: <20260827091813.22327-1-hao.li@linux.dev>
 <apAnveXHmeQlKJnU@tiehlicka>
 <apDZV9nKW69ZbIj1@fedora>
 <apGT74PpkVvkUkY4@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGT74PpkVvkUkY4@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4899B1A0008
X-Stat-Signature: ayxfyaeazhbu5p9mkq7a8mejf9pfau6d
X-HE-Tag: 1788166908-899625
X-HE-Meta: U2FsdGVkX1+IRyo648LzlMXhTgUbeUb8s9K+233nMolFPK0SBLdHeThzRm/gh5lvyEtBnJOuLgOzHYoSHF2w/Qx7CZUkS+VSgG4QaSqu/8Gf9DtTZyd7pLLK09X93IGtKDAZoWJbIRySFYhyfU4c9tnJDpGALbk/POucTuAqExjbgbz8GoNUOSzOW0RemZ9wH61lbjZJLLdfgmQN+qQVGbP0Ryh9Z/alpkTBmFJd3QC5YxSCzEZTS22cMHpMFK6C3tpefKvL1oS+WFWQWoShDozQmLgr4F5tl2pzSEPay7vx5ifN92IpmQNZAQY3t+hZu7OG0Yx/3CfAuXiKVgWxlsklnjd/bLPxCB1eYk3YD+rNU3ov/eUOFYppZ0newGljc2HP1OqD0uvuUuTR0NpYyfcpq4Slfl3Z5AdkEk603FUcWi90Ynu/dbnyldFAMbfSaZGM6Z0Q9h3H8WRAAGJ8slYgM8gOh7eIXZ1FbOtCy2ouRvxPVd3O9WfIqJ3IfLEW4jIL5qgAR4J4HgeUg/qS3HRD728CU8XpNEsEdg2Qf6kQSIVJMJXW4wNlqKRF7Bl/EvXYoOghl1ECrE9SWlz7NhQjoTO1J4lRGIO2x7EiMIJ0jGSj7ul8F8dFY+JEhLT++N7s3B9CkAoohyqXVP8SkeLQ4wMWx0ZGQxtuvtrlXbO3LXm3aTG7NIVI60wznQVQIoU2OheiOxPlFOyQdkk5VekGqGEmiEjvxQiWqMkGjCnNU8DX7wpwtIuZ9a4CkJEv/O8JlwhIZOl2LzEn5t+cqQN6iGgMOtEKlmQb8vGkEZKA6DCBKvT3+fUT6BrSLvTyj8YXeVBrXKf3cfUbt7sfaqFyK62fI83W72br5E4ZU7tAjX8UVZO61WjDI3yQpyhDz5sHdb4MyR4llJCSMl8bXbnZp73BbJgIxu92MIAX9Ee+luAGSshLcoEs52xucVLcXcAmMuBSsii0pkmtkrR
 jCmproJf
 yXKxxY7UBhNxB+ErOE6hGl3Ez/bEAwTOzs5et+fu5XXXPMUtGNHG1rzZfzUb2HGa/s9oMPuvdwVpV7h2Xpz3SIn/n2kQiu3LuqBY6uMcYgrVx9bk7kpPtADD2I+mPSRGXKcQ7ieLtryJehaxjOrPdTK1I3aJHxbQ3VheGoBVRjLV3ZWpdWw1jV5a9dEtzAkza81468xAWiKsHC1F/dXot8j9C5ppATUmeZV/fIT/h+VX1WfwOjxAPNyjdoDf6kGuxSO0+p3Ybm4eqTgK46PJaVbg6+jAvU7bHNuqb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:58:07PM +0200, Michal Hocko wrote:
> On Fri 28-08-26 08:47:54, Hao Li wrote:
> > On Thu, Aug 27, 2026 at 02:04:13PM +0200, Michal Hocko wrote:
> > > On Thu 27-08-26 17:17:50, Hao Li wrote:
> > > > mem_cgroup_kmem_disabled() currently only checks whether the
> > > > "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> > > > also unavailable when memcg itself is disabled.
> > > > 
> > > > Check both conditions to ensure the function accurately reflects the
> > > > kmem accounting state.
> > > 
> > > It would be really great if you could describe how we could end up with
> > > the inconsistent memcg enabled but kmem enabled and what kind of effect
> > > does this have.
> > 
> > Yes, thanks for point out this.
> > 
> > > 
> > > AFAICS the inconsistency is possible and it would lead some wastage but
> > > no functional problems but the changelog should be more descriptive.
> > 
> > Exactly! The most direct benefit is that when memcg is disabled,
> > new_kmalloc_cache() will not need to create a separate `KMALLOC_CGROUP` slub
> > cache, but can simply alias it to `KMALLOC_NORMAL`. This avoids wastage.
> 
> This is definitely important detail to mention in the chagelog. Same as
> the effect on the __list_lru_init and other callers. TBH I am no longer
> 100% sure this is correct. You need to explain more why this is just
> wastage rathe than a subtle side effect that is desirable.


That's a very fair question. Let me walk through the impact of this patch
across the various subsystems in detail below.

In fact, the initial motivation for this patch stemmed from a slab patch
discussion: https://lore.kernel.org/linux-mm/amHldYIo_-Bgm7Ek@fedora/, so also
Cc'ing the slab folks. But in retrospect, its impact on list_lru is somewhat
more subtle.

1. Impact on list_lru (the most widely affected path)

   a. list_lru_register and list_lru_unregister previously performed pointless
   memcg_list_lrus operations. With this patch, both functions become no-ops.

   b. In list_lru_from_memcg_idx, previously, because memcg was disabled, any
   input idx reaching this function was guaranteed to be -1, so the `if` branch
   was never taken. With this patch, the `if` branch is still not taken, so the
   control flow remains unaffected.

   c. In list_lru_add_obj / list_lru_del_obj, they previously performed some
   unnecessary RCU operations in the if branch, and mem_cgroup_from_virt
   returned NULL, meaning there was essentially no difference between the `if`
   and `else` branches. With this patch, they directly take the else branch.

   d. In list_lru_walk_node, before this patch, because memcg was disabled,
   there were no elements in lru->xa. The function had already completed its
   task once list_lru_walk_one finished, making the subsequent xa_for_each
   inside the `if` block effectively a no-op. With this patch, these pointless
   no-ops are skipped directly at the `if` check.

   e. memcg_destroy_list_lru was previously a no-op as well because lru->xa
   contained no elements. With this patch, the function bails out early,
   causing no functional change.

   f. memcg_list_lru_alloc / folio_memcg_list_lru_alloc were previously
   unreachable because memcg was disabled or objcg was NULL, so applying this
   patch has no impact here either.

   g. memcg_init_list_lru previously initialized lru->xa. With this patch, it
   is no longer initialized. This is safe because all paths attempting to
   access lru->xa are either guarded by list_lru_memcg_aware(), or become
   no-ops due to memcg_list_lrus being empty.

   In summary, the impact of this patch on list_lru either preserves the
   existing execution flow or saves unnecessary operations, introducing no
   adverse side effects.

   Additionally, when shrinker_memcg_alloc detects that memcg is disabled, it
   returns -ENOSYS to let shrinker_alloc clear the SHRINKER_MEMCG_AWARE flag.
   This confirms that the shrinker does not care about memcg list_lru when
   memcg is disabled, further corroborating that this patch aligns with the
   shrinker's design rationale.

2. Impact on slab KMALLOC_CGROUP is aliased to KMALLOC_NORMAL instead of
   getting its own set of caches, and __kmem_cache_create_args no longer sets
   SLAB_MAY_ACCOUNT, eliminating the need to allocate the obj_cgroup vector.

3. Impact on need_pcpuobj_ext and pcpu_obj_full_size When
   CONFIG_MEM_ALLOC_PROFILING=n, there is no longer a need to allocate
   pcpuobj_ext. pcpu_obj_full_size is not affected as objcg no longer exist
   when kmem account is disabled.

4. Impact on memcg_online_kmem / memcg_offline_kmem memcg_offline_kmem is
   unreachable when memcg is disabled, and memcg_online_kmem will bail out at
   mem_cgroup_kmem_disabled, so memcg_kmem_online_key is still not set.

Finally, with CONFIG_MEMCG=n, mem_cgroup_disabled() and
mem_cgroup_kmem_disabled() both return true. Therefore, making
mem_cgroup_kmem_disabled() also return true under CONFIG_MEMCG=y with
cgroup_disable=memory seems reasonable and consistent.

Untangling all the combinations of whether memcg and kmem accounting are
enabled is surprisingly intricate! Please feel free to point it out if I've
missed anything.

> 
> > If this sounds reasonable, I would be happy to explain it in more detail
> > in v2.
> > 
> > > 
> > > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > > ---
> > > >  mm/memcontrol.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 1ebceade4021..b28f6165c354 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
> > > >  
> > > >  bool mem_cgroup_kmem_disabled(void)
> > > >  {
> > > > -	return cgroup_memory_nokmem;
> > > > +	return cgroup_memory_nokmem || mem_cgroup_disabled();
> > > >  }
> > > >  
> > > >  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> > > > -- 
> > > > 2.54.0
> > > 
> > > -- 
> > > Michal Hocko
> > > SUSE Labs
> > 
> > -- 
> > Thanks,
> > Hao
> 
> -- 
> Michal Hocko
> SUSE Labs

