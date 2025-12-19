Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D6AD711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08966B0088; Thu, 18 Dec 2025 21:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5776B0089; Thu, 18 Dec 2025 21:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2DA6B008A; Thu, 18 Dec 2025 21:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD9A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:10:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 422CC1364C1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:10:10 +0000 (UTC)
X-FDA: 84234590580.28.4D53BA4
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88406C0008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:10:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bomkr5sk;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU/sltETz4db1d6NIyN/LIXo1b6za3STnrY0+ajqCb8=;
	b=62MdvYvTiHqMorlNS7dpYTArbNxNsQzU52V4JJjW/rIrsgsZY7aJedAZ5NSefA2fdmixWk
	yGsqwTs/sdqIRZ0TOWF89CxgxH8kRO468Uhg7/8GvZBStBTWXTezVarPnx+DR4pgxOWvXs
	E4x5Q6H9QXfQZcdO3andcCdN+STWfDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110208; a=rsa-sha256;
	cv=none;
	b=QNRX4xjytGbjWHmeIcekOh+RWIrhtF3PCXsB3lYXOm5wuu60eX3YGJLB9bns4NcHc5aASU
	7PJmK3V4JeP9pQ9reA5iDXCqaHxDQHT4JCG4YDqnU7FvsEL2lMCHViaJ5u0AtUS3gXqik9
	i2wCzKP2IFx6ZdB/qMBomweR/wbZwis=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bomkr5sk;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 18 Dec 2025 18:09:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766110199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XU/sltETz4db1d6NIyN/LIXo1b6za3STnrY0+ajqCb8=;
	b=bomkr5ske46dcXHXoPOJ77r8YbOhDox6UbCohl7xofxLl3s2EIboOt1KronjtFal1wVRXR
	01z5ic3jRvUzKY6eJNDlVojgMovkW02GkCCudTHFvM+j1kduHbwCF8oHNdIysmtOW5bfV7
	3zE1pyON8/35o35q8rr774DIdHh4IfU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <ot5kji77yk6sqsjhe3fm4hufryovs7in4bivwu6xplqc4btar3@ngl5r7clogkr>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMkYlK1KhtD5ky6@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUMkYlK1KhtD5ky6@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bk16j3fmtdjkpj9bu4gd165d1agkeomq
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88406C0008
X-Rspam-User: 
X-HE-Tag: 1766110208-506332
X-HE-Meta: U2FsdGVkX1+Olgqjn0fs3gssepYoo3a1PsQjbQWRq3Ofciu18Gnl1NmCOapImYfpQKucTxxgFuu7f/Nm285/MR8Q+a9yWBzgC+tyKxlXZ8dPV4kP2NRazx+yOEjf9HSfZRrru5s0ido4xblVAL3+gSVQvbofHvDN9lC9m5apTWZt/IOngCiyLZ5FvzMOoe3daVLzv053t8BI9QkTs0VA5RUpABUlavXXnItbQ8sAAoZu3vKu5AxnLedMJeughZoTFQZs6hhYHNueHna+QkGSKK12bzK6TSqD7h1TDdtzIOZph4GDBbIAKass8hXcbwg0+Oh/mVfEY40e5HvhOHg/8S8Di0dHD9v7eU92Cu7who2N1UeSl4y2yJ6IvsVsVAxXTfYvD1CiUkbrMkweT0n2LtuEFsPg5VcuMI55ia3da85b741zU5FKveYR8/fYDsYfxPCxiEDq4863ucfZnYnZNVz4OaXBDkqG266iE+B1RNKNVVetC/eO7IxZKkpei+RyHlQnp0mlmlBxneJJR5ZlOpt69Ukjz9vwd6/ANCXuBxBkijTLuo7IbKcHCpE7CSWl1W0pIfXX/pWbOZ9/na7v+jRAW2yvKiZ2WhcPemzX08gwfQ3Wp505oZZS8CTdxmZW/cZdc9+lhFtCmnxgXKg7pAyH/saYD9H90inJQiqLkYxRgMQ4MW4hkc2S3MCCWM/Fcly2U13PQlzvjusZDWPkxK5Klp3LQLKeMXagf+OhNWRjxNM9HSMqGOUjk90PsIZMF2lvdgkOwip9eNV/hWqcTJ3exoTyroRUqCPS26FXnJ+ZvBkEaMp/N1TE3JB4DAH9BMcW3050vJSl3ELb30vyvqnbnRz2Ew3IJKiHWCt94duzxhdZW89f5QuJjTnRRq9MNvDphmadkcjU4hw+JeUFcvjh6CcMobFIoaoIIfp23DmPtxvFJvf0ZlcMpsF3yQeSLUSgNNUj5VH3DuCuIwz
 ySvG4SOa
 YmTjmt7TAKjPRnbuFOLaHfX3qA1XPw0G5bcZrWdMnofHSwkcF2JoEJ3+b1UdbooweaTQRSD4NaJbKqJK7exkx5iCbcy9cg3VlElJ8zbDrNyZHv9Xu33inXytbQuAXbN23qXpo36VgMn8I0r6S1P35usaBkoARsCHNPBEjiIcJPFkcwg3C7zbcqcQluTum2fFNvJMp1uRieUR+z3iiAzeszo2DbJcoRspeZJpXbTs4GYEtjQ1kKqMwp3cw0BjT3qeXjhC3zrf06eFUub/GdffiP4VV3euVmp+hXKFjGiUIfQC8Nwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 04:45:06PM -0500, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:32PM +0800, Qi Zheng wrote:
> > From: Muchun Song <songmuchun@bytedance.com>
> > 
> > In the near future, a folio will no longer pin its corresponding
> > memory cgroup. To ensure safety, it will only be appropriate to
> > hold the rcu read lock or acquire a reference to the memory cgroup
> > returned by folio_memcg(), thereby preventing it from being released.
> > 
> > In the current patch, the rcu read lock is employed to safeguard
> > against the release of the memory cgroup in get_mem_cgroup_from_folio().
> > 
> > This serves as a preparatory measure for the reparenting of the
> > LRU pages.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/memcontrol.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 21b5aad34cae7..431b3154c70c5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
> >   */
> >  struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
> >  {
> > -	struct mem_cgroup *memcg = folio_memcg(folio);
> > +	struct mem_cgroup *memcg;
> >  
> >  	if (mem_cgroup_disabled())
> >  		return NULL;
> >  
> > +	if (!folio_memcg_charged(folio))
> > +		return root_mem_cgroup;
> > +
> >  	rcu_read_lock();
> > -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> > -		memcg = root_mem_cgroup;
> > +retry:
> > +	memcg = folio_memcg(folio);
> > +	if (unlikely(!css_tryget(&memcg->css)))
> > +		goto retry;
> 
> So starting in patch 27, the tryget can fail if the memcg is offlined,

offlined or on its way to free? It is css_tryget() without online.

> and the folio's objcg is reparented concurrently. We'll retry until we
> find a memcg that isn't dead yet. There's always root_mem_cgroup.
> 
> It makes sense, but a loop like this begs the question of how it is
> bounded. I pieced it together looking ahead. Since this is a small
> diff, it would be nicer to fold it into 27. I didn't see anything in
> between depending on it, but correct me if I'm wrong.

I agree to fold it in the patch where it is needed. Currently at this
point in series I don't see how css_tryget() can fail here.

> 
> Minor style preference:
> 
> 	/* Comment explaining the above */
> 	do {
> 		memcg = folio_memcg(folio);
> 	} while (!css_tryget(&memcg->css));

