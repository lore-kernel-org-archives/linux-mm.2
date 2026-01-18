Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422DBCA5FE9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 00:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D4C6B0005; Sat, 17 Jan 2026 19:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610A16B0089; Sat, 17 Jan 2026 19:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C616B008A; Sat, 17 Jan 2026 19:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF096B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:44:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E07531404A3
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:44:21 +0000 (UTC)
X-FDA: 84343238322.14.A7FCAD6
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id E73A91C0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:44:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CKnyZNNY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768697060; a=rsa-sha256;
	cv=none;
	b=OJS9n5qCB9narERkejvVzEkSqyc+82DRWJHFjdm0Bv6xyjv4mmBUxqnZwzNhTdFUmbzb7V
	3pdZUL4Tvohx+HIKQVZexJ2mq07mwuFdqxQkzxj01QpTrV0/dCBSVP4d0kzUUDvEQpxIsZ
	sDREa0xt9d504GEgl8wgkQW2XJy1JKw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CKnyZNNY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768697060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whDjQXmdHM3VZOKRc3lRTlarxS+fL0vnszLAxxSW1CU=;
	b=gwGarOBZffVd7sQdztp2IVFYmVNEYSYkNp3QVbWCX5/CvLPmCXFemfSvsJ3/XR1DbALUTK
	ZM2QBdUiHM3e7P5rK8//kG/kHOdrDz346U01dG0xy10mNUYD2sAgNJQL9BdGGwQv/ikk7f
	pVLHzPzMcLaZBJsha3Ais9KzVDbUyVI=
Date: Sat, 17 Jan 2026 16:44:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768697057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whDjQXmdHM3VZOKRc3lRTlarxS+fL0vnszLAxxSW1CU=;
	b=CKnyZNNY5eppfAzVkVuovTh7vEsjr9K/+rcO7VbAKsE0nuooPJo16edeoGWCBjUXZ448/U
	PeXDlEqXCNE5OLGzngEmMum6SnXKkmshNt1SuhH5LIrCmwlI16UUJaRf6mAszrdvBLNGrL
	dDuAehSs9u/Ix+BLjYwM6CrfvMmqEPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, hannes@cmpxchg.org, 
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <ncg4ibcrecdutsizzwdu4buw2fvqc57yji4rx3hsdwv4mgobkz@krdjtokzz4xg>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
 <4a1b69d2-df29-4204-91fd-bb00b52350db@linux.dev>
 <e7aa1221-040e-4806-a259-56718844897f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7aa1221-040e-4806-a259-56718844897f@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E73A91C0005
X-Stat-Signature: io5fpoer7yogbmhd4jh81sc6ibifjgpj
X-Rspam-User: 
X-HE-Tag: 1768697059-710785
X-HE-Meta: U2FsdGVkX1+HobC7KatLkOkTGwnTj8ka26HfT5cQczcmgVI+rfhaVY9XwgxNKZclA36q+J4wOFNLY5H6iKExFM1V2KGfQDFBks+GE4zMGjTwCxJAuMuEilt50NAL3lJghbKx72HNiQ3GjKQcAdGDuZCeVlR+kc/lOe9l/g2efu/+U6vRQqhE0c/p1f+Cm7d6cmyfTK0bvv25unl0hZ7Fd4e54EjehCOw1P95e7/ZI+rJW+kKZ6o9Kbjwb+Ze0aa+0nYbwSmxsyAjjhUlOJhOQTm/hFCe47QDiy0DiediVCng/la347p7iShwHENDaFEF+/vY4Tr/JzgqNFn+UL11UMGT3ZcjSe2TpTKrZ87SCvaP/J7QC8WKic4Ik1DjAMuKAbkxE45TDXQyQNKDXJfIJU9URu3WsdI7OR5Vsn9YdV4675ktYCa3hp2A9/aDtVkHH5fmSzPlw3fxsae08sf8Tgs4mV6z6vem2e0HFq3zSBZ1l+9EsUcSX30c9JnD7HAipEV+ATRKHRsMf73CUSVsDos51xQMBk5c1z6KP3HmlvbZjkZW18siCLgS8IYarmB4MQPiUlrodXhlWwVR8O7OUmMgxWIpN8hwcfPQJdRJgrbJrw0d1F5ZXKscOk7Vo1SatiBH81i+WFqhNfxGDEhWR+sbQU1IM0YVhojcbFV3CwIMoL3ZNr17sqvtS5zBXMPtNoFL86JdijuYJtsTmTvFIPkK8EP8HOS1KmMTmLpIuMnuDXRdNnwvlKYjfMXoVlA4W/hH0Pf7av+Zs9EkgwlERJjwgKEicwBjFX4/B6ATk7h3Y6Vr9POWXd56m2ZO48VMvvQ6cA0dmJzImPCPfJ+gJckWnF2rnU5uoE6gT9fZrQeG6emc6NaO1nsOGLyGnjj2J4q/CdjS4j5E8gJX60WY9u9k64SaNfAiKWbaQ5/xJXpk7cfJw0TTGJC3gasBIyqqljnCpvV52d/z22fJepk
 BSGaX77K
 eDCrRYJlkIxHOanEZMjkb7dIBc+X1AYH6Rb9UIMeTsKUMYMNSRYy8EtMqQZfmdVFWKdH/AfjKiVwAdfeRXTuLNDc++h3kMNkZZMRQBRz7bD/GF3UgQWUQPNcMtZ8NWS8Q/v0C5Y7a0mdK6w31uqXEQbh+49dcCQOS69uaqX0AK104pB3iZ5dFr9yQKHisJ4ppqcoL7Lp8+Tym1gftxn+r/PWD+I3IXDqMXe1eX2jaHJfqzMr6pI7Qj+Zs3VGX3320rTTUiuguGHUkR/yyZXiLQ07Uy5l87tF3RsgByn9sOwXJ49gBolLZn6UYJZoKzMlRy1qWcIdFVnkIAghjhaJ/hRgP2PlCOempQrDx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 05:50:22PM +0800, Qi Zheng wrote:
> 
> 
> On 1/16/26 5:43 PM, Muchun Song wrote:
> > 
> > 
> > On 2026/1/14 19:32, Qi Zheng wrote:
> > > From: Muchun Song <songmuchun@bytedance.com>
> > > 
> > > The following diagram illustrates how to ensure the safety of the folio
> > > lruvec lock when LRU folios undergo reparenting.
> > > 
> > > In the folio_lruvec_lock(folio) function:
> > > ```
> > >      rcu_read_lock();
> > > retry:
> > >      lruvec = folio_lruvec(folio);
> > >      /* There is a possibility of folio reparenting at this point. */
> > >      spin_lock(&lruvec->lru_lock);
> > >      if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
> > >          /*
> > >           * The wrong lruvec lock was acquired, and a retry is required.
> > >           * This is because the folio resides on the parent memcg lruvec
> > >           * list.
> > >           */
> > >          spin_unlock(&lruvec->lru_lock);
> > >          goto retry;
> > >      }
> > > 
> > >      /* Reaching here indicates that folio_memcg() is stable. */
> > > ```
> > > 
> > > In the memcg_reparent_objcgs(memcg) function:
> > > ```
> > >      spin_lock(&lruvec->lru_lock);
> > >      spin_lock(&lruvec_parent->lru_lock);
> > >      /* Transfer folios from the lruvec list to the parent's. */
> > >      spin_unlock(&lruvec_parent->lru_lock);
> > >      spin_unlock(&lruvec->lru_lock);
> > > ```
> > > 
> > > After acquiring the lruvec lock, it is necessary to verify whether
> > > the folio has been reparented. If reparenting has occurred, the new
> > > lruvec lock must be reacquired. During the LRU folio reparenting
> > > process, the lruvec lock will also be acquired (this will be
> > > implemented in a subsequent patch). Therefore, folio_memcg() remains
> > > unchanged while the lruvec lock is held.
> > > 
> > > Given that lruvec_memcg(lruvec) is always equal to folio_memcg(folio)
> > > after the lruvec lock is acquired, the lruvec_memcg_debug() check is
> > > redundant. Hence, it is removed.
> > > 
> > > This patch serves as a preparation for the reparenting of LRU folios.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > >   include/linux/memcontrol.h | 45 +++++++++++++++++++----------
> > >   include/linux/swap.h       |  1 +
> > >   mm/compaction.c            | 29 +++++++++++++++----
> > >   mm/memcontrol.c            | 59 +++++++++++++++++++++-----------------
> > >   mm/swap.c                  |  4 +++
> > >   5 files changed, 91 insertions(+), 47 deletions(-)
> > > 
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 4b6f20dc694ba..26c3c0e375f58 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -742,7 +742,15 @@ static inline struct lruvec
> > > *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> > >    * folio_lruvec - return lruvec for isolating/putting an LRU folio
> > >    * @folio: Pointer to the folio.
> > >    *
> > > - * This function relies on folio->mem_cgroup being stable.
> > > + * Call with rcu_read_lock() held to ensure the lifetime of the
> > > returned lruvec.
> > > + * Note that this alone will NOT guarantee the stability of the
> > > folio->lruvec
> > > + * association; the folio can be reparented to an ancestor if this
> > > races with
> > > + * cgroup deletion.
> > > + *
> > > + * Use folio_lruvec_lock() to ensure both lifetime and stability of
> > > the binding.
> > > + * Once a lruvec is locked, folio_lruvec() can be called on other
> > > folios, and
> > > + * their binding is stable if the returned lruvec matches the one
> > > the caller has
> > > + * locked. Useful for lock batching.
> > >    */
> > >   static inline struct lruvec *folio_lruvec(struct folio *folio)
> > >   {
> > > @@ -761,18 +769,15 @@ struct mem_cgroup
> > > *get_mem_cgroup_from_current(void);
> > >   struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
> > >   struct lruvec *folio_lruvec_lock(struct folio *folio);
> > > +    __acquires(&lruvec->lru_lock)
> > > +    __acquires(rcu)
> > >   struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
> > > +    __acquires(&lruvec->lru_lock)
> > > +    __acquires(rcu)
> > >   struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
> > >                           unsigned long *flags);
> > > -
> > > -#ifdef CONFIG_DEBUG_VM
> > > -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
> > > -#else
> > > -static inline
> > > -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
> > > -{
> > > -}
> > > -#endif
> > > +    __acquires(&lruvec->lru_lock)
> > > +    __acquires(rcu)
> > >   static inline
> > >   struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state
> > > *css){
> > > @@ -1199,11 +1204,6 @@ static inline struct lruvec
> > > *folio_lruvec(struct folio *folio)
> > >       return &pgdat->__lruvec;
> > >   }
> > > -static inline
> > > -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
> > > -{
> > > -}
> > > -
> > >   static inline struct mem_cgroup *parent_mem_cgroup(struct
> > > mem_cgroup *memcg)
> > >   {
> > >       return NULL;
> > > @@ -1262,6 +1262,7 @@ static inline struct lruvec
> > > *folio_lruvec_lock(struct folio *folio)
> > >   {
> > >       struct pglist_data *pgdat = folio_pgdat(folio);
> > > +    rcu_read_lock();
> > >       spin_lock(&pgdat->__lruvec.lru_lock);
> > >       return &pgdat->__lruvec;
> > >   }
> > > @@ -1270,6 +1271,7 @@ static inline struct lruvec
> > > *folio_lruvec_lock_irq(struct folio *folio)
> > >   {
> > >       struct pglist_data *pgdat = folio_pgdat(folio);
> > > +    rcu_read_lock();
> > >       spin_lock_irq(&pgdat->__lruvec.lru_lock);
> > >       return &pgdat->__lruvec;
> > >   }
> > > @@ -1279,6 +1281,7 @@ static inline struct lruvec
> > > *folio_lruvec_lock_irqsave(struct folio *folio,
> > >   {
> > >       struct pglist_data *pgdat = folio_pgdat(folio);
> > > +    rcu_read_lock();
> > >       spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
> > >       return &pgdat->__lruvec;
> > >   }
> > > @@ -1500,24 +1503,36 @@ static inline struct lruvec
> > > *parent_lruvec(struct lruvec *lruvec)
> > >   }
> > >   static inline void lruvec_lock_irq(struct lruvec *lruvec)
> > > +    __acquires(&lruvec->lru_lock)
> > > +    __acquires(rcu)
> > 
> > It seems that functions marked as `inline` cannot be decorated with
> > `__acquires`? We’ve had to move these little helpers into `memcontrol.c`
> > and declare them as extern, but they’re so short that it hardly feels
> 
> Right, I received a compilation error reported LKP:
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from crypto/ahash.c:26:
>    In file included from include/net/netlink.h:6:
>    In file included from include/linux/netlink.h:9:
>    In file included from include/net/scm.h:9:
>    In file included from include/linux/security.h:35:
>    In file included from include/linux/bpf.h:32:
> >> include/linux/memcontrol.h:772:14: error: use of undeclared identifier
> 'lruvec'
>      772 |         __acquires(&lruvec->lru_lock)
>          |                     ^~~~~~
>    include/linux/memcontrol.h:773:13: error: use of undeclared identifier
> 'rcu'
>      773 |         __acquires(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:775:14: error: use of undeclared identifier
> 'lruvec'
>      775 |         __acquires(&lruvec->lru_lock)
>          |                     ^~~~~~
>    include/linux/memcontrol.h:776:13: error: use of undeclared identifier
> 'rcu'
>      776 |         __acquires(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:779:14: error: use of undeclared identifier
> 'lruvec'
>      779 |         __acquires(&lruvec->lru_lock)
>          |                     ^~~~~~
>    include/linux/memcontrol.h:780:13: error: use of undeclared identifier
> 'rcu'
>      780 |         __acquires(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:1507:13: error: use of undeclared identifier
> 'rcu'
>     1507 |         __acquires(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:1515:13: error: use of undeclared identifier
> 'rcu'
>     1515 |         __releases(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:1523:13: error: use of undeclared identifier
> 'rcu'
>     1523 |         __releases(rcu)
>          |                    ^~~
>    include/linux/memcontrol.h:1532:13: error: use of undeclared identifier
> 'rcu'
>     1532 |         __releases(rcu)
> 
> And I reproduced this error with the following configuration:
> 
> 1. enable CONFIG_WARN_CONTEXT_ANALYSIS_ALL
> 2. make CC=clang bzImage (clang version >= 22)
> 
> > worth the trouble. My own inclination is to drop the `__acquires`
> > annotations—mainly for performance reasons.
> 
> If no one else objects, I will drop __acquires/__releases in the next
> version.
> 

If you drop these annotations from header file and keep in the C file,
do you still get the compilation error?


