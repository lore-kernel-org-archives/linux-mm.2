Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1CD606A8A1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jxEyQBdG
Received: by kanga.kvack.org (Postfix)
	id 8AB466B05B0; Thu, 12 Nov 2026 09:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85C0A6B05B1; Thu, 12 Nov 2026 09:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B376B05B2; Thu, 12 Nov 2026 09:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5B76B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:24:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2268805AD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:24:02 +0000 (UTC)
X-FDA: 85426686324.10.E96BAF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FB0A180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:24:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxEyQBdG;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493441;
	b=agjR5VPt0k+j5jvBBynfKQz4q2CRYKTqpRxQmX7EjMbdptbBjwT/DCbcevwUR0YVT3UyU4
	pySR/mDCEzmCB5XI4Pavyrn9raoeGnNbK0L2wAKcugDjzH4qTPkLDqzTBSuUVdgjmvPswo
	bQkPMpA3yudy8v7drY5DSOVpsKtrhDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxEyQBdG;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493441;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qq0qQsc09tKzoOEHPnAid02X0RdpqTosY6bBuXXrAMs=;
	b=H0fcs4Jd5SKKJrWwkngii/ZQ16DcakwYIRrsZ93RT9tv3ZiXkOh3v4bbAeN8JM/5H2JR6L
	sd2CIa/YQDuXvH5kUwoizd9Gkr8oImXvBS6kxORzLEea/Dy2Y/wjmWEH0d+5FqHevy4mBQ
	FHqtjKdNekgOuMmqIpRDfLmxB7zmogY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ABDB6025F;
	Thu, 12 Nov 2026 14:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3EC1F00A05;
	Thu, 12 Nov 2026 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493440;
	bh=qq0qQsc09tKzoOEHPnAid02X0RdpqTosY6bBuXXrAMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jxEyQBdGmd/IriPjgsUDITfqy5v4kaMKpQ2XLrQ56tVDcFKNU3x8c5w8CkQ2sJ7sc
	 8whk9kYK0g3SPvLfftvfP+e75f0cUitcE3ER7n3ddHzocUtSG06ZF+QWcQPhYMKyk/
	 gutaD0MV+UlbKIvfOH1rdIfhbND28RqVjxfGIiBrRZvhn+l6KIK2z2OO2Bv7MFLjBG
	 YUQS2B60f5Nv7EUjGQXAOpcmGoDXJOKaeVUG+dnKKXdrw2rmzA56q+rleZjvlA6Vsi
	 LTLhEWaC3UJYekA3SHYrf32Fyl2RnOTcpasXjAc+vfM7jr4iVVQLKEHo0QMjaU1tWL
	 m7bLkvpxvjOeA==
Message-ID: <sashiko-outbox-211310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm/slub: barn sheaf counts can exceed their limit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junseo Lim" <zirajs7@gmail.com>, vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, linux-mm@kvack.org
In-Reply-To: <20261111142337.748120-1-zirajs7@gmail.com>
References: <20261111142337.748120-1-zirajs7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:23:59 +0000
X-Stat-Signature: 5u7weir8yac1jmfhd5morqn3bbn7rgr9
X-Rspamd-Queue-Id: 3FB0A180009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794493441-292575
X-HE-Meta: U2FsdGVkX19SRZbU+oounE7Dvn2yaifJWUpTP56/lsffgqPQ7ijT6UtAHw5EV5PB/9o5xOYC3AzRsoWgxkEa2CbGCd+pBCONW/+MgZ6WDMaRcDI75WsvE2flM5QUfuwUxRhDsVajKX9z4MCo7+wpm/kqpF5A0WUkrgBnyHsFC/2W73G1+W+fuHi36ieesdlZHMCk4J/f7F3pWF+rmMjz94b3SM1xofKpSGDkOSlrqm9wVYAG/QvD4m0io3g9Y8NrLWB/YtK45nM+JZk1BJzdnWIAP6oVGZpyPsiwOskoGgvOkUGAeEo5wtpACA7u4qmZ85Fpw2XlktBsI8Qpe/MhQd05CRxz9vDlADGSFqlBFzhtXymFDDKsCC2mjvJZAqFCUSbqC5q5aPw9Ol4KI71r4exUPiJZ1K754ek4k+3K7bK6pPEEMjRrIGkJG6C+A3gN/zQHMM7pNZmiBm1b+T2oS250iztMUHco+nwsnG7ywl68qk1ArdNqsMp1uqzhfOpgnwdC/q3AnAFChWOyOXvaZJWkUi6y/i8vFiqC9Nmw6LCWgJ8lduA54SbWUkomgNL/BFFncsT+XXQJSmRZ+HxJYfreuNEfc5YijbU8G9SnzdHpbn+zwJCzkPMkulZeD56SOBxp8hRd2YoZ+VQwbl2usDevmQplkZ1bHOGg4fAK+O4ZhxeRmCx0jSbpUOiTScWwceaYhcI7JCDXm4s5ZJQiKxhySdKnMVIr429WKre8zu6k28QtmwVObbvrN3cnAFQx6B+n9ugFluy1slsDttKnvniiUzrz35ZIFz9WRKvll3VryDgu5s4dkjXVkh5IugyGa4txtwfBT8f3U7TAsWN3uyXiNT1v4KSyAZGAPIoqykoNMWm83EMY2E2+Hm7dbAxLABpQxZ2FQHXN1oSNuQ7ATzdbJckpEjgMBal50m79SrV0Hqpq+YroRoQzdKmwtBr+Etqzy4josPBAsmcgkzv
 4MRyPGWA
 RJEhza9ttv+TkCDDWrLI/KuPC9iAO6WazlHaqAAD7N1ChfIVuEjxLS7BKM0vKedNv/yN2J/b33k0Dhn7R7I5kTjGinKojLAKqXMNIvmwZhnZKHqZ6RBxMsRk9pjMCDHLRxHuZD4ArmaHjB3d464uJX5QT/SnUY7KxeHEr8QL2D5CdrWffJCIwZMSkVEFHae7SQez5kLSrxBr+IMxoY119ciIZHugxfuJCDzdI46L30Xy6ltZvCX9TOxJodUIkvDNXVv7HXMPu5xE9CZKPOUGMasnmW51XN/v5p0+DgfHi8uJXmdKr1iBw8NiFr5azAE5wahMEPFQmPvwhwck97Sz9/omVddhw82qFwNO397r1dtgeQzxu8qsdqMOmIU0/aEg9uAyzPeC4B+k+E/z/8WVE6ec8U3T23oEO4PUOXgxTFe2tITViA7yTVGRdQKltMSwksmvdG5B0GJORVGssxCBjfEz3R6y6jTMYxpOUgpUeG1J6nD+/nU/IrV+x/dIc4nNcY2EEBIdNNN31UHGHCt9LrEbngl9uwFdZKfoNpOgaNE8+mUQ4BdCw+rMqWgVJMLixahdbxRVOnrdIIYVlJ0djNC8dfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] mm/slub: missing Signed-off-by trailer and RFC email body in
  commit message
- [Medium] mm/slub: unbounded barn sheaf growth across refill waves in
  __pcs_replace_empty_main()
- [Low] mm/slub: off-by-one and unlocked check on barn->nr_alloc in
  __pcs_replace_empty_main()
- [Low] mm/slub: redundant back-to-back barn->lock acquisitions in
  __pcs_replace_empty_main()
- [Low] mm/slub: missing Fixes trailer for commit 2d517aa09bbc in commit
  message
--

commit 4002c32d0ca36a2bf13b1261531aaa78aeae34dc
Author: Junseo Lim <zirajs7@gmail.com>

> mm/slub: barn sheaf counts can exceed their limit
>
> Hello,
>
> Following the suggestion to discuss this publicly, I would like to
> report a repeatable overshoot of the SLUB barn limits. Although
> MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES are both 10, a userspace workload
> can repeatedly trigger the refill recovery path. In one run, I observed
> states like nr_full=3D91.
>
> I would appreciate feedback on the appropriate way to enforce these
> limits.
>
> Description
> -----------
>
> While the sheaf layer provides a simple array structure for
> amortization, the edge cases that involve refills and allocating
> structures are inherently complex when combined with multiple threads.
> One problematic case occurs in the allocation path. Consider a state
> where every object is drained and TH1 on CPU1 is running:
>
>   CPU1
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   TH1                    TH2                    TH3
>   ---------------------  ---------------------  --------------------- ...
>   pcs->main->size=3D0      not entered            not entered
>   pcs->spare->size=3D0
>   nr_full=3D0 nr_empty=3D10
>
>     <observed states>      <observed states>      <observed states>
>
> If an allocation request hits this state, __pcs_replace_empty_main is
> called to retrieve a full sheaf and swap it with main. However, no full
> sheaf is available in the barn, so TH1 removes pcs->spare, sets it to
> NULL, and refills the removed sheaf through the slow path. Here, the
> per-CPU sheaf lock is released during refill and reacquired afterward.
> If preemption occurs during this period, a subsequent thread (TH2) sees
> pcs->spare=3DNULL and tries to get a remaining sheaf from the barn's empty
> list and refill it. Likewise, this part is not protected by the lock.
> Chaining this results in a state where new threads keep draining the
> sheaf and ultimately consume all the empty sheaves in the barn and start
> to allocate new sheaves.
>
>   CPU1
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   TH1 (preempted)        TH2 (preempted)        TH3
>   ---------------------  ---------------------  --------------------- ...
>   pcs->main->size=3D0      pcs->main->size=3D0      pcs->main->size=3D0
>   pcs->spare->size=3D0     pcs->spare=3DNULL        pcs->spare=3DNULL
>   nr_full=3D0 nr_empty=3D10  nr_full=3D0 nr_empty=3D10  nr_full=3D0 nr_em=
pty=3D9
>
>     <observed states>      <observed states>      <observed states>
>
> The construction of the sheaf layer allows such racy scenarios, as
> mentioned in the comments. Nevertheless, this overshoot is much larger
> than what we would expect, and the fact that this state can be recreated
> with moderate effort implies that a fix would be appropriate.
>
> Impact
> ------
>
> This itself does not pose a direct threat or system failure. But, in a
> security sense, this behavior can be leveraged for heap grooming that
> targets the underlying slab_sheaf.
>
> Design considerations and Question
> ----------------------------------
>
> One way to limit barn overshoot is to constrain the racy allocations.
> Simply using the current nr_full and nr_empty values does not help in
> detecting excessive allocation. What I came up with is adding an
> nr_alloc counter that keeps track of allocations during the unlocked
> path. From what I've tested, this restricted the targeted workload that
> induces the excessive allocation. Before this patch, nr_full reached 60
> to 90. After the patch, it remained at 22 under the adversarial
> workload.
>
> I haven't checked every possible interleaving yet, but I would like to
> know whether you think this is the right direction. The possible
> regressions are that it requires an additional field just to track the
> adversarial input and that, in a highly contended scenario, every
> allocation after hitting the nr_alloc limit will go to the slow path
> until the preempted task returns and continues the allocation.
>
> Is tracking in-flight sheaf allocations per barn, and falling back when
> too many are in progress, the right way to limit this refill race?
>
> Note: This is only an implementation on the allocation side and is still
> a prototype.

[Severity: High]
This commit is missing a Signed-off-by: trailer, and the commit message is
formatted as a mailing-list question rather than a changelog entry (any
discussion or prototype notes belong below the --- line).

[Severity: Low]
Should this commit include a Fixes: tag for the commit that introduced
per-CPU sheaves and __pcs_replace_empty_main()?

  Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")

> diff --git a/mm/slub.c b/mm/slub.c
> index a151268b97263..7076902509ed3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -4798,6 +4802,19 @@ __pcs_replace_empty_main(struct kmem_cache *s, str=
uct slub_percpu_sheaves *pcs,
>  		}
>  	}
> =20
> +	if (allow_spin && !empty) {
> +		/* The limit is advisory; concurrent reservations may exceed it. */
> +		if (data_race(barn->nr_alloc) > MAX_EMPTY_SHEAVES) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			return NULL;
> +		}
> +
> +		spin_lock_irqsave(&barn->lock, flags);
> +		barn->nr_alloc++;
> +		spin_unlock_irqrestore(&barn->lock, flags);
> +		alloc_new =3D true;
> +	}

[Severity: Low]
Should this check be >=3D MAX_EMPTY_SHEAVES, and rechecked after acquiring
barn->lock?  Starting from barn->nr_alloc =3D=3D 0, checking > MAX_EMPTY_SH=
EAVES
allows MAX_EMPTY_SHEAVES + 1 (11) concurrent allocations rather than
MAX_EMPTY_SHEAVES (10), and threads on other CPUs that pass the unlocked
check before taking barn->lock will still increment barn->nr_alloc past the
limit.

[ ... ]

> @@ -4841,24 +4858,31 @@ __pcs_replace_empty_main(struct kmem_cache *s, st=
ruct slub_percpu_sheaves *pcs,
>  		else
>  			barn_put_empty_sheaf(barn, pcs->main);
>  		pcs->main =3D full;
> -		return pcs;
> +		goto out;
>  	}
> =20
>  	if (!pcs->spare) {
>  		pcs->spare =3D full;
> -		return pcs;
> +		goto out;
>  	}
> =20
>  	if (pcs->spare->size =3D=3D 0) {
>  		barn_put_empty_sheaf(barn, pcs->spare);
>  		pcs->spare =3D full;
> -		return pcs;
> +		goto out;
>  	}
> =20
>  barn_put:
>  	barn_put_full_sheaf(barn, full);
>  	stat(s, BARN_PUT);
> =20
> +out:
> +	if (alloc_new) {
> +		spin_lock_irqsave(&barn->lock, flags);
> +		barn->nr_alloc--;
> +		spin_unlock_irqrestore(&barn->lock, flags);
> +	}
> +
>  	return pcs;
>  }

[Severity: Medium]
Can barn->nr_full and barn->nr_empty still grow without bound across
repeated drain-and-refill waves?

barn->nr_alloc is only checked and incremented when !empty (after
pcs->spare and barn->sheaves_empty are already exhausted), and is
decremented back to 0 at out: as soon as __pcs_replace_empty_main()
finishes.  When a wave of threads allocates new sheaves via
alloc_empty_sheaf(), any excess sheaves are placed into the barn by
barn_put_full_sheaf() or barn_put_empty_sheaf() without checking
MAX_FULL_SHEAVES or MAX_EMPTY_SHEAVES, while barn->nr_alloc returns to 0.
As subsequent allocations consume those full sheaves via
barn_replace_empty_sheaf(), they are swapped onto barn->sheaves_empty
without checking MAX_EMPTY_SHEAVES:

mm/slub.c:barn_replace_empty_sheaf() {
    ...
	if (likely(barn->nr_full)) {
		full =3D list_first_entry(&barn->sheaves_full, struct slab_sheaf,
					barn_list);
		list_del(&full->barn_list);
		list_add(&empty->barn_list, &barn->sheaves_empty);
		barn->nr_full--;
		barn->nr_empty++;
	}
    ...
}

In the next preemption wave, threads pull all of those accumulated empty
sheaves via barn_get_empty_sheaf() with empty !=3D NULL (leaving
barn->nr_alloc at 0 while preempted in refill_sheaf()), and once
barn->nr_empty hits 0 again, another wave sees empty =3D=3D NULL and
barn->nr_alloc =3D=3D 0 and allocates another batch of MAX_EMPTY_SHEAVES + 1
sheaves.  Meanwhile, on a NUMA node with more than 11 CPUs warming up a
cold cache, capping per-node in-flight allocations at MAX_EMPTY_SHEAVES
forces concurrent allocations on other CPUs onto the ___slab_alloc()
slowpath even when no preemption race occurs.  Enforcing MAX_FULL_SHEAVES
and MAX_EMPTY_SHEAVES when returning excess sheaves to the barn (and
flushing and freeing any excess via sheaf_flush_unused() and
free_empty_sheaf(), as rcu_free_sheaf() and kmem_cache_return_sheaf() do)
would bound the barn directly without throttling cold-cache allocations.

[Severity: Low]
Does this acquire and release barn->lock back-to-back on the recovery
paths?  When alloc_new is true and __pcs_replace_empty_main() calls
barn_put_empty_sheaf() or barn_put_full_sheaf(), those helpers take and
drop barn->lock, and the out: label immediately takes and drops barn->lock
again under s->cpu_sheaves->lock just to decrement barn->nr_alloc (which is
only ever read via data_race()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111142337.7481=
20-1-zirajs7@gmail.com?part=3D1

