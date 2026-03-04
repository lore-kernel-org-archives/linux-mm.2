Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7976EEDEBFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 00:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC526B0088; Tue,  3 Mar 2026 19:38:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789A76B0089; Tue,  3 Mar 2026 19:38:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BCD6B008A; Tue,  3 Mar 2026 19:38:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56FDB6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:38:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E57381C360
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:38:32 +0000 (UTC)
X-FDA: 84506519664.26.A5A80A0
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D0A880004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:38:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HQXeg3jA;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772584711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuOjJb0QLX0PUZAbW78/fXsQ37xDNTOQP0GeAROixpg=;
	b=QGj/ssU5KXTIrnENe9N6gwFRG5lxbJv7MgSa9koGJI4Qxfind/0zvqZEHmdhyx/PBzaN33
	1MNLy0gf0QW+P2q5gZKiv5u2Tzu+mkFQpqLnFSwdLcfZg5737na341E3eMkGOXSCj7C9Pf
	C5KWLSUgilSg7uDOAoaRQRH1QcEbo7g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HQXeg3jA;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772584711; a=rsa-sha256;
	cv=none;
	b=Puaeo4PzjXc4PeOiYDCUzO/NXug5eBuVgrRws26VHaOYag43Xj7dVxqgfHm+F9F8bygIUZ
	UL9vdO+cjfnW7nZbcLAIqgkTCGV6CubHx2l4K27iJdmBxDErr0LlrMXBT1y3O9ARm72pqy
	Gr0rKTtsOh6Kx4AAtvY/ZsjkQD/6XjQ=
Date: Wed, 4 Mar 2026 08:38:16 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772584707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TuOjJb0QLX0PUZAbW78/fXsQ37xDNTOQP0GeAROixpg=;
	b=HQXeg3jA5M2DlYI5TaOZoKc4YNVf6oCl+zTv2vwriNIb8jpFfo6QewVUO8T/BNxCj0BaSf
	2TFJKFFW/F1EI0AwcMb2c/VD6A/vg26MYXq53MP8VrpHkeduuVxvvPIcCoyyrv0KgbP9wA
	EO4JPclNHQC/BgIaup/7iyLkO/wvGAo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <6sjgaoxzbipxpza4pjnwpm57yx4d662gpjtuuzv66bvl3fazjt@4repfcgybk5t>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
 <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
 <aablae2eFl9ne5fW@linux.dev>
 <aacBoazC21TAi-Q2@cmpxchg.org>
 <aacLODh5BY45Zp9s@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacLODh5BY45Zp9s@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D0A880004
X-Stat-Signature: dbwggce4rexc9quyi8uxtntucm767at6
X-Rspam-User: 
X-HE-Tag: 1772584710-50164
X-HE-Meta: U2FsdGVkX1+QY9332a7NugomvUwL/aJNx+jtoCegf3FzEU/DfuHhP+euqnnjgxDjn/SvlbkzFue9nlBQCderTMTJ9ZKhcdRUn7vW3dWew770KmqX+I0qGqwV+regHCtNkP2jBE7OSk6ZfVJMfQn5/Skqp3bM7e4fOPQx+l2/+wBUTn0lLLU8EHWhk17oz2HNZNEFB2E8ef7dxTrJlPv8YKQnodvihVYRWVc+VodCd3Q1ZFSHMXQBAf890F2+cgAvU2P38vv1dOPgVqud+V2cTz8bNk+mUE+TY6kUpcP8+2PTYVPUWKclHcQDYoqG1qSKqJB5Y2N8JsgMvgbGccVHLAEF/IQ1yqzbwRrkUe/Wu0FI10bqrMnyFxbfoqLD9xiP45hwgyVUqwkClv553/3oSFfmKS3jhGd/+McI6mvsyCN7LTR5ge7BcnJ989wcPs3Te+keU/cZ82w2UMGb7lidBdr8Edpr5d08O28fiTU1EVQa3yn2EFA31YHtYGxPDmefzUjIV/+6yXJyTFWWXl1Vf+Z2Sd/q3+8JdwRzuU42+c2o3Z2GGN3hvkb2WFf/tuemwtBdKG3ZnvEJR+K4Ekp7V6ULv7+vOKrMpcORUENXnl3tQe5r+GZYpbFhhm7tu5DLlHuzVBe4bJBvGn1OgShty6BWBl/XRdohcvzgJkPxCwPd9gh7GdXyLzDpuQiYkF802tR9Wd6eSRAepDLaEP7HjJmg4yY9Fb51bslfXP2JfqKKxu02AiG5LxobKikI/tWEsgXZ/90lw9csj/g5CeOslRwkqiw2fBxxAjOdi/W+1IvEizS2X+BCVHrzufdt8pt8h+8O+fiE4722F1vv2y3oVTHfW0ayAeudJQBC7+zPBJ1K4SQDaAp/5MGK3KcCHmM6FKUv6UV8Ua1nWbwLsUNcCDDkhKye8fjimL5l4oaq0+awoRsQMoJXb1hIAd0sqAdn/4h10HOik3265rSW3N3
 aycpFo2d
 4ZR7Xv9oBwPe2z3r5zwTxziUegS9qOEqXuCFQfAHCjDfd5PZGyjEoeLlb5qjl2iHjy/c8Slmvt+309uqxdARVBNqtaTWwlAEC7S390Paf+oQbrcHKBA6Ifo4m+SzRKdxi4J5puV8Tv8bjxAisj1ao1WZF0IL9+RGK1b1Ca4eRzuDJJ/fRJsCwKVxmyMw7dUgCjeqLh5X0d+h5Ypc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 08:26:31AM -0800, Shakeel Butt wrote:
> On Tue, Mar 03, 2026 at 10:43:29AM -0500, Johannes Weiner wrote:
> > On Tue, Mar 03, 2026 at 05:45:18AM -0800, Shakeel Butt wrote:
> > > On Tue, Mar 03, 2026 at 11:42:31AM +0100, Vlastimil Babka (SUSE) wrote:
> > > > On 3/3/26 09:54, Hao Li wrote:
> > > > > On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> > > > >>  
> > > > >> +static void refill_obj_stock(struct obj_cgroup *objcg,
> > > > >> +			     unsigned int nr_bytes,
> > > > >> +			     bool allow_uncharge)
> > > > >> +{
> > > > >> +	struct obj_stock_pcp *stock = trylock_stock();
> > > > >> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> > > > >> +	unlock_stock(stock);
> > > > > 
> > > > > Hi Johannes,
> > > > > 
> > > > > I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> > > > > the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> > > > > refill_stock(), which seems non-trivial, this might increase the lock hold time.
> > > > > In particular, could that lead to more failed trylocks for IRQ handlers on
> > > > > non-RT kernel (or for tasks that preempt others on RT kernel)?
> > 
> > Good catch. I did ponder this, but forgot by the time I wrote the
> > changelog.
> > 
> > > > Yes, it also seems a bit self-defeating? (at least in theory)
> > > > 
> > > > refill_obj_stock()
> > > >   trylock_stock()
> > > >   __refill_obj_stock()
> > > >     obj_cgroup_uncharge_pages()
> > > >       refill_stock()
> > > >         local_trylock() -> nested, will fail
> > > 
> > > Not really as the local_locks are different i.e. memcg_stock.lock in
> > > refill_stock() and obj_stock.lock in refill_obj_stock().
> > 
> > Right, refilling the *byte* stock could produce enough excess that we
> > refill the *page* stock. Which in turn could produce enough excess
> > that we drain that back to the page counters (shared atomics).
> > 
> > > However Hao's concern is valid and I think it can be easily fixed by
> > > moving obj_cgroup_uncharge_pages() out of obj_stock.lock.
> > 
> > Note that we now have multiple callsites of __refill_obj_stock(). Do
> > we care enough to move this to the caller?
> > 
> > There are a few other places with a similar pattern:
> > 
> > - drain_obj_stock(): calls memcg_uncharge() under the lock
> > - drain_stock(): calls memcg_uncharge() under the lock
> > - refill_stock(): still does full drain_stock()
> > 
> > All of these could be more intentional about only updating the per-cpu
> > data under the lock and the page counters outside of it.
> > 
> > Given that IRQ allocations/frees are rare, nested ones even rarer, and
> > the "slowpath" is a few extra atomics, I'm not sure it's worth the
> > code complication. At least until proven otherwise.
> > 
> > What do you think?
> 
> Yes this makes sense. We already have at least one evidence (bug Hao fixed) that
> these are very rare, so optimizing for such cases will just increase complexity
> without real benefit.

Yes, make sense to me too. Thanks for taking a look.

Reviewed-by: Hao Li <hao.li@linux.dev>

