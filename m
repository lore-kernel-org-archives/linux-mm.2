Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B9DC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8F46B0095; Tue, 14 Jul 2026 15:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1B06B009B; Tue, 14 Jul 2026 15:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7136B009D; Tue, 14 Jul 2026 15:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9AD6B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:20:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D1A31604B2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:20:12 +0000 (UTC)
X-FDA: 84988347864.28.29184F7
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48BFF4000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:20:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WEOpvaJw;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784056810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpEjCH9LBPCggUHvnEgL+T6kr5Wgb5W3kwCbUpos+tg=;
	b=XmnZ2FVAmx1o9aG7JPoukjrck9AoX4cPVL5Ge5FcMBMyOLLXPgY+QCBn4xD+ZK0wB7GhJV
	hRjl+zOWjuKt5orinoSp2Q+KatiQpCGALJuc6N6ytvErxHjUEDMjHuw4mXHy029/5tW6Ws
	s9FDXyckmGQ9HefLD+8W7OVdp/qVSA8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WEOpvaJw;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784056810;
	b=L8oM40l69KXCYTH/x3TyMPGCpnt4OWOlayD8H2QTnBGQKLOTyT44hhelHU2ruwJBwwozjW
	u0fQHJqJx2noVC6QtVno7+JOMjf6yUKbmim5pKbb8tNeOB0XnjbFgZOCY0ARWO1jtKmChp
	kWkqFX1zbFCFDgJwSDm4c5z7nce/LMk=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4a45b3f0becso1497236b6e.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784056809; x=1784661609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kpEjCH9LBPCggUHvnEgL+T6kr5Wgb5W3kwCbUpos+tg=;
        b=WEOpvaJwz7GT6luMBBrk6rm7R+o7sCf95ODMZVJVD4j2cYIrzC7MCqXUDZRZ9baZGa
         V8tOlfZWtk7q+YSNDuNp+osQFh71hoejKfd4Y8PeX+ADroet5WUBACYCme4Y7uXG942n
         91a8VIK/rYsCjkrEyJAiAMuWxee7jCNBqt1hUQjPqjTiTEGPSBA18Lou/SX58NW/Ivju
         HxptTWNcnFxXdt76Cx3o+vDIwjde1w+/rJ4ziE6vGWZ+M0tePuTfzGP+V6ze2mgwQ3GE
         hh7ofucvC229tvXj1E7fKr9gw2ie1KmCqPDRy5+RKtGNVLzAhGoJT7VC8GXsEnca50UG
         rUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784056809; x=1784661609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kpEjCH9LBPCggUHvnEgL+T6kr5Wgb5W3kwCbUpos+tg=;
        b=LHPXgjazEXNfFGURfenUmvk104JWlH7ljtNQuY0TF7oskcqfDfJKN/O+wkQ7r8kwQ0
         haG5qRhY/7X7W+bZQnd6iQ+2Y+uRUprQNBL7EsOIIGHtGNwGbT7lMIahzKHQ8Qbq6cux
         ddxM/EfdfX/1DtgIE7LWfij8WmfDNOVCCT3t6NjDmTChxSHtN2ZE3LN0Wwpa2PoRQsMN
         WApD0kWscOsUmOy2FgPl1/qgTDBZXNnFDrx1uiB1CpWWSoEahp9AAb0GhiKqCW0L0JZ9
         9xT1LAFUgY9OIoF/HzCZeUaSVrCSkecnubCZcVQ5AN+nz6yuMsEIvVmp2ioGYg8hCG/V
         nWTg==
X-Gm-Message-State: AOJu0Yz+OJV/rM1hMZLcllqFlJIBdSlysp5jYrANXQR7gogq5ap6hWYF
	d3+FbZXulhNxwfQGk5A7QWPvXdFwivq3v+tLtonnJ9ARpBJ6NK8894f+
X-Gm-Gg: AfdE7ck8zuNqdbkmk+RYCzOxhaS4Xv87xNpM9IO7rI7pi00wJ8/u9/MPf99K8kYo77l
	fqduLX/QZHy6xSwGw6YpozPXeMOEkSUYoclQeygGO6ylNc/Zac+i0j8Ubf8QGTBzGPe4C03ezca
	SiUSOOD0kx7rb8Q+w/g2j/nOPipmptMYJRquF3ASUtbMAefMjBHaj4Dt7zkVJSEyn2gCY/jrUhs
	K3MZg1IyILuMfnMwFVNmiZMr3Uu3aPP4bYpZAz1srtCUqbCpKMRG7S6HvILcLjylTeZsSeXwM7j
	bwC4Uws5tlJBBh+laEsn6ST0zHrpq5e73c9Kd13P6KBIxUkP8I4dNea7NLpPx6UmeXhXvNDkXBr
	dchWa7Zx3hkq4yLfWQOconbFHCVRs0V/i9a2nMKpy1OhotQBDui1nSy12UGaIoa7AHTvzgTch6m
	mWhxjGdtq1yXXRe6FCoFer4JXLaIDDNwzwBXSMuYgEMMvxeOMwtlcd4w==
X-Received: by 2002:a05:6808:1b21:b0:489:a387:1e29 with SMTP id 5614622812f47-4a47a5e2f3fmr2017784b6e.20.1784056809226;
        Tue, 14 Jul 2026 12:20:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a1acc82489sm15100591b6e.1.2026.07.14.12.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 12:20:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Donet Tom <donettom@linux.ibm.com>
Subject: Re: [PATCH] mm/memory-tiers: cache top tier nodes
Date: Tue, 14 Jul 2026 12:20:07 -0700
Message-ID: <20260714192007.919161-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ech6uqij.ritesh.list@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48BFF4000B
X-Stat-Signature: 3fgkku9bi5admg5kjbche733msgn6api
X-HE-Tag: 1784056810-442880
X-HE-Meta: U2FsdGVkX1+ldatmYhAurbBU7HB5LscAZQG2Ls1yN8v+QfFKbbqnAOjjYKMEKOyyXpyuhJcXFBood68oTUY9Mpfz7XM2F4MmbpNmFVuSbYORDHzarL5O/hIdhsgbq1MZwzmiX5FfFfKkMpMG8Niz7/oSdl7/DsKQG17pLpl3PuhtwIt39DYhnUBDzE2sEIuwChA3RDUA/OOSmofy+7aJ0jD3uqgp0BwlJP0/WKeMKA6qBqhJWvViHBk5xKnlbnDna6/OAcuzG6VBUBjAUoiw0FAu4cye1t0Pws3ZMDzUNO6sjVlSnrpW0iuBbxru5CqgV2y65PTbmEyZRirWeNlkfJJzWOjOAYdj15vWJTZK3v1LWvyrGMVS2SPju7xP1Zeo+8jPOZtWIXKSVEjXLcDk9WPd24EJs6pcNXdXh7eVa0GqqAzEEOGJ+JJzuIkc2OqghNKEtn541NpR6pe0xv6EKasE/d3z0FlnrH8tKXSzNrsVyCYPYlFph1cGvA45edcCOs3L32rL2lR1HxRAXHrb2xyIYXyLSOjO0MwdfwqVoKPRCm/bmIBRV16/ikM+XRrq9OOcymY24T3T+Fk4wvjaYu2bnd2PS7zKRxJJNNpde9iqza2WuXWUg3eF4CvVELocPfHVuTZG68RpXiZ/7b6ME9Laf15ZNOjB00YQOr5h0lM94gxs1QVRMdyQ49yMkNDRErJoH15j6y6xDpR4euYcw/o/yagm2LvmG6mDxWSVb7H9VvM+liACBWrOFQQoQXIXaFyikGGDw6ulOTGBxNLi495Br6rdr9KFTazywMSFzHVE3qtGyzFYFMTm6NZChzBOelFA41MYjOOl8VaE8bBlt9QFNQo+fmJ12WA1S42lGir0ZRgiwFsqD19suYTHmJ5M18docEUfwtmW+LmJA5gi57HZAaScCgR9RDNVSPq9auvYkSUW8woPQE8NLgybA4jjbP7oGtwb4+Isq7ldhbX
 br111YUS
 rusIgUk/MMQiNGaYqURCXg9yL7dinxTo/c6SGRG+pBfnF7vBgUFHWx7OkUpsIXUWDJmltVXrQiDd2fN4Px7i45GNfYp7ao/4/7a4kdkhLeVuIhvoMlZtAxRamT1rl2Ykl5OUvEfMNOTxxlEYkSBxB5DFSQ50hsy2ZAPDZiy30wSOz8VwdhZDfnk5qFadIsspXmsxspMU3LQF6VfwWlEfqpYnyTX3iF6KOA7Ij5OsgQIWXVybn+m8/KvPZq3ekq/uZGQNUJaY2W7Vc9qfdR+79sSTwtCWw07i9EfJD/vz56baXm+h+LUWN5C+se7c9XrnzKMy58iGU0QOUIoil98epmJRGByhEaYlXfoeCNb2gc6v6uO8W3kfHJiZ4EXS+flggFS0F4MxtFCzp6zUKOS9eDvlU6Shf1oHE7JzeoudRjVpPSvo7osPYsuGk3tFvk81gomOS2EpK4tRMGacaLqO/vontBaUZhP+h1YalAZRdcuyNkUYBWxzt2xWFerlpoEOmq6Zn7IE7mF0KBqCVOuDbZRgjxkjYMrQNbLHd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 10:17:00 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > node_is_toptier() is called in a few hot paths: task_numa_fault(),
> > should_numa_migrate_memory(), folio_migrate_flags(), etc. Each call
> > takes an RCU read section and performs the tier distance check again.
> >
> > Tieredness for all nodes only changes on memory node hotplugs. Instead
> > of recomputing toptier nodes inside each of the hot paths above, compute
> > it only on memory node hotplug events and cache the results.
> >
> 
> Did we observe this function "node_is_toptier()" in any of the perf
> reports? How much perf benefit we see with this, if at all?
> It will be worth adding that info to the commit msg.
> 
> 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/memory-tiers.c | 36 ++++++++++--------------------------
> >  1 file changed, 10 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 54851d8a195b0..2e6e02ec1fce4 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
> > @@ -71,6 +71,7 @@ bool folio_use_access_time(struct folio *folio)
> >  
> >  #ifdef CONFIG_NUMA_MIGRATION
> >  static int top_tier_adistance;
> > +static nodemask_t toptier_nodes __read_mostly = NODE_MASK_ALL;
> >  /*
> >   * node_demotion[] examples:
> >   *
> > @@ -276,27 +277,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
> >  #ifdef CONFIG_NUMA_MIGRATION
> >  bool node_is_toptier(int node)
> >  {
> > -	bool toptier;
> > -	pg_data_t *pgdat;
> > -	struct memory_tier *memtier;
> > -
> > -	pgdat = NODE_DATA(node);
> > -	if (!pgdat)
> > -		return false;
> > -
> > -	rcu_read_lock();
> > -	memtier = rcu_dereference(pgdat->memtier);
> > -	if (!memtier) {
> > -		toptier = true;
> > -		goto out;
> > -	}
> > -	if (memtier->adistance_start <= top_tier_adistance)
> > -		toptier = true;
> > -	else
> > -		toptier = false;
> > -out:
> > -	rcu_read_unlock();
> > -	return toptier;
> > +	return node_isset(node, toptier_nodes);
> >  }
> >  
> >  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> > @@ -497,19 +478,22 @@ static void establish_demotion_targets(void)
> >  		}
> >  	}
> >  	/*
> > -	 * Now build the lower_tier mask for each node collecting node mask from
> > -	 * all memory tier below it. This allows us to fallback demotion page
> > -	 * allocation to a set of nodes that is closer the above selected
> > -	 * preferred node.
> > +	 * A node stays toptier unless it belongs to a tier below
> > +	 * top_tier_adistance, while each tier's lower_tier_mask collects the
> > +	 * nodes of every tier below it so demotion page allocation can fall
> > +	 * back to nodes closer to the selected preferred node.
> >  	 */
> > +	toptier_nodes = node_states[N_MEMORY];
> >  	lower_tier = node_states[N_MEMORY];
> >  	list_for_each_entry(memtier, &memory_tiers, list) {
> > +		tier_nodes = get_memtier_nodemask(memtier);
> > +		if (memtier->adistance_start > top_tier_adistance)
> > +			nodes_andnot(toptier_nodes, toptier_nodes, tier_nodes);

Hello Ritesh,

Thank you very much for your review!

> I looked into this and I don't see any major issue with this patch.
> 
> However few things worth checking are:
> 1. From what I understood say if we add a pmem node as system ram, then
> due to the above logic, it will go through these transition states..
>     0 -> 1 -> 0
> This is because we update toptier_nodes to nodes_state[N_MEMORY], which
> means, pmem's nid becomes top tier and then we quickly transition that
> back to lower tier by clearing the mask.
> Instead maybe updating toptier_nodes in one shot at the end would avoid
> this intermediate state.

Yes, this is true. One thing that I think could be a problem for that is
there is not a really good way to make the transition, since nodemask_t
can be wider than a single word and I think that would make the
transitions have to happen in word chunks, which could leave the nodemask
in a partially torn state. data_race() works but it does not capture
the nuance that node_is_toptier will always only check one bit at a time
so I'm actually not entirely sure what the best approach is.

> 2. Also IIRC, after the nid is online, numa balancing for tiered memory
> can always work. And we store different values (I guess in
> folio->flags), depending upon whether the nid is toptier v/s lower tier.
> (_last_cpupid v/s folio last access time). It's worth checking that path
> once.
> ...So, I looked at it and I think the same transient discripancy (of
> whether the node is toptier or lower tier) is true even with the
> original code. So I don't think that it should be an issue.

Thank you for checking! I think I'll need to think about the above concern
for a bit more. I'll also profile whether this is really even a performance
concern or not. I just thought it would be good to cache this
calculation since it's such a rare operation to update which node is
toptier or not, and it tends not to happen when there is much happening
on the system anyways.

Thank you again for the review, have a great day!
Joshua

