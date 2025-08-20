Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C762CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 12:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0876B00C8; Wed, 20 Aug 2025 08:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77C26B00CA; Wed, 20 Aug 2025 08:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DE76B00CB; Wed, 20 Aug 2025 08:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9AD36B00C8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:58:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 785861A04B4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:58:23 +0000 (UTC)
X-FDA: 83797139286.10.2CAF9C8
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6AA0E1A000C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:58:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l T0lBpY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ghRXDfDR;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755694701; a=rsa-sha256;
	cv=none;
	b=bjCKWq6l79+8z4iJHYICgBKZATcZqUAAZND7u296zRSCW196ymBUMfbH/bp6dBk3bnSPd3
	ga2Px7xPwLG0dz+Enmg3MHBA/dGLp+zT7U63DhAYIScXrsvlPeU8c2dTuIHUFGCRMT2B+q
	rfBQGwftjBKwoQCsvRvsENnwULAol80=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l T0lBpY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ghRXDfDR;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755694701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wsGx0mAlZVoMlqY3YzRKD0yjauwkX1n/YWAvB+PZcA=;
	b=Q5h8zy+lKAWkMk69VctaFxdDUDhnDgjqqo2IihutTiHNojLWck7i9mgWc8ilqIig8Qwyet
	erE0+QsjLuvEnjff3EsmQwRnLVKprxXRS72HGBJ4Yh2vdE5otnLqN0WDHj9f/mXk6lWtOt
	TIbVNwWX6twLCbqSLQ8UvVK/EhsbcKY=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 9BB76EC08CA;
	Wed, 20 Aug 2025 08:58:20 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 20 Aug 2025 08:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1755694700; x=
	1755781100; bh=0wsGx0mAlZVoMlqY3YzRKD0yjauwkX1n/YWAvB+PZcA=; b=l
	T0lBpYfanUhN9GxgC5VP7dA3SFHzSpFOxvKxKVPNyW85QOaYSCAcEhdJ5ndmDwzM
	mQ2vRxIT212ZPeGogVoiujTXPhWjFSFOHwXfoe5iXbhDmjUpCC6wUj5Ohel2tEpw
	9SsikI3ltYXtSMRxoSxlqC3vAFKOKDSs+95ReOoaUwEaIBhb8D0/Tm7QZZdMP1Rs
	B4xv3P02KaybnlZbv6+2NJJu9LSE5/Bjp9FKZpWFtFn1gAiHXreLVGKXUYwP05uq
	ancKxTKw8jtNq7H2QfgoW1juLVqEVYf4YOxXIjq1CCfQA/mcKwXTIdwJ4yVBWLk5
	1mVNYZF9rfpX2vjmrNPtw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755694700; x=1755781100; bh=0wsGx0mAlZVoMlqY3YzRKD0yjauwkX1n/YW
	AvB+PZcA=; b=ghRXDfDR6cq4ZaBhAqZTkfK91U5D2lmmmQCOwhvTr1gFm39pSkv
	Mob3O9d+wqkBskkxXQP2HvHGZJhMAOkLDIzcK+M0p6CsinFIa80FrcBgRZxx9hrk
	UnBpXgPNIK7v3hacqwyYuCksNmrykR6W0IpWJmy7SI9xp59GQ9QhGvAZ2RVqEAuf
	+BJUZz62xzplL6bCMoRy/CS41I1Fx+RN2LD5XkfShQlzFyeH1gyjO8o5ubvMhV7j
	GGOISeZiLBevWcN2uLVc28psZQgEV6/x7gtRdbaa+92erBmaSrCISy+FUiSOr37u
	o3gacTzobQcoxkhgprzcO+zQBoqnBIvsKLg==
X-ME-Sender: <xms:a8alaO7m6bzlkI-e5GAgu826TdPmhkSO3oSjDw8YwlGYIfauW6VT-w>
    <xme:a8alaD_Yd9nsUiXAt1SUa2u1ACqAx0BuTYqIL2xeP73e0o4tcppx4aNlvy-svqW6B
    XF20NyTb3pKpTXS9sI>
X-ME-Received: <xmr:a8alaIyi0pmAb_bpMXJ8a9zVLfH0rUGAga247GmZ_a65t7OB6dRRv9mewVSu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheekgedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepshhhrghkvggvlhdrsghuthhtse
    hlihhnuhigrdguvghvpdhrtghpthhtohepjhhoshhhuhgrrdhhrghhnhhjhiesghhmrghi
    lhdrtghomhdprhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhrghdprhgtph
    htthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhho
    uhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipd
    hrtghpthhtohepshhurhgvnhgssehgohhglhgvrdgtohhmpdhrtghpthhtohepmhhhohgt
    khhosehsuhhsvgdrtghomhdprhgtphhtthhopehjrggtkhhmrghnsgesghhoohhglhgvrd
    gtohhm
X-ME-Proxy: <xmx:a8alaKFaNQIAE1_v9rISkD9ON5DAaeweWQiDe3JYR6YI5fAEtLX-XQ>
    <xmx:a8alaLO7cismCRVmooK_wrIYqEMEUL5Cssc2uzzKFNuFJRW980L-Mg>
    <xmx:a8alaBfEWC6ONWM9Pr6UdWmbS2hTXchelQ7MN2cfadebezcPvHidiw>
    <xmx:a8alaATf3BqwDkC0B5FoahWuxdG3L3puwiqIGM-S-c9NhmyMC8snXQ>
    <xmx:bMalaGpUTqr-rMEyOLbMK1kqqL-_OJ4uc-AAPIDuQrPeuhMRp7o_QRXP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 Aug 2025 08:58:18 -0400 (EDT)
Date: Wed, 20 Aug 2025 13:58:15 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@gogle.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-ID: <wuuz7itgcjb7vu466k6nwxfjiy4ytx7ip3yvauqucwlpqqibri@bpxnpevzermg>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
 <k6fpx5adh45t4jrxgiccq7acubwcgmi746crggxi6e4oihtvpt@thks5zrn53n3>
 <x3xp3cj6wpgxu5mjsd62fzvuzpn2mxpvlk6sau65si7bk6ncu5@dx6jbuacy42i>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x3xp3cj6wpgxu5mjsd62fzvuzpn2mxpvlk6sau65si7bk6ncu5@dx6jbuacy42i>
X-Rspamd-Queue-Id: 6AA0E1A000C
X-Stat-Signature: pz75rmhycbkymicziyhpi6d1i75aw4uz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755694701-672364
X-HE-Meta: U2FsdGVkX18nVzve1YxGs8/Jtp5Dp08H4Ceur+OpBgFkK8jiZsWyxYaoW1lkE0r+HTWaFq3fL4XK+H3coIsrc1ayNvx+e3wp22sPkOByHzjN9vPU77ZQTu5pjVla/jWY1JCIxwhi9N58viWat/uCtPhVBnsw8gXv8uPbbOb9hbtL7JlUriIKHyjAi+Edw5hOdFLfmk6O2tjyuauyxzuMJX/4VFgf2dEifPFK+gZCGgzO7KLK5dDdQVYXn7TuH4ltdHbFV5i1x47zs7npkm6ECf0WBdfM50TslgVk1KkQQN11e1eUQ+HoSfVPPzGSP2dWKUL5Gbiiav6/OR4+DHTEdFkWbNSON/gTGUD3UzNg9Yb3XYcHS3gB2MZ8D4QpTP/5PNe1lPBLwGGk3Wh8vvjmNP3wDQ7AFJAAP+tYz6t0yBhjkNnMPi3uDxIXx/c88tO14Zz6Wt7Vdmc/WZaZ7A9xib8CSWAk5CxfTHR5gXfkOK08F6BMdSDoM1tmfgNLfm5YiuGH6TftzoAzWsQh4BjHe8saWL6fUZmHtTRuMmdv2mGSOxkZYk3iCTl1bQva6BtI2hfBQBLMoYfkQsAffBUXEMmYQ4BSyLo7sWQ1JRNKdoYOqxA3Lvv2i/sYJz1xb/b07uwrwlI714PLiyPc9jdbVsk6FrLl78La2sVTDLPLxXWN0GWAOdW3ixZyugd0Z0mXypZOIBM1gxtVxeXkEjbtQUFyzStB2jB2lErOTFuRZ+JahrA00NHKqW22PdxmXoauCixTVnUmRfk3+Zb6SM2dP9RFBz6dAPL1VoJUz170JMeZNHiHkjcAD8o12VcLzE1KOw3CsbfGfROTOVAYxyYz2wLusoJgJ/t4F5zHoQs8HGy5cDwXyqnf0Z87BC6BCg5hsvi5pijc0TbW4Xt3TlM3/MUoidZnjXq9KVkCodUVCjrb8/BtzEzZ82J+X2eLP069S0bsBApMuewRVPYCDAT
 ruopQqMC
 hifRhVXz8m0U35eflaYdIERqJ9lqg95i6GTjqWipyQVizVKF5et6/qGMmuQFYg9wtAfdbjjcT2DbgSbH0nOf39XB3+bM3Sf6WiN80LOOL2B8hWSVRO2DePUohs0q+7fjTeP+r3aK3G52doFYnsHpIJpdG91fNFqQHYKSFpxTq88+xtdiigJOh8cz5D63P3yYeeMjZpB70f/ePPxVvq0nq9J8/W0dspPNiHakKTQ7Zm/JIawhHEQ7ecO10bWd460O6w1/Qu9JsYG4Gdv8qJNtHyadaWXTkUBQv4kiufK5439N943cm3og9wRXAHHnzvfAKqdS531jC1CLccnoEpZBiZTWJEH+C/lX7PlYcOMcZJ5+YsLs5j5RBmuZuBvsmMeFYJIs2GqHlHqXRHOTvTLigRvWe/DmiFnZ/ZEr/MpuTVbZaPdADa9ysrceFmgg/s1Mo9OItzx+pn8J6pwi/eMp9eZ3ZdNWBSuaec2ZIJZJ0LvSiaN7luieFo/7hc7PfcRF+gTZ503ADK0NQxw3piPXoyDbwXsFrgsiaLUJFC9CO5dIzdW8ak6Aknfw9TZrgH+KqYT3o2lkZ5ImTsfpHudgWsgBW1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:15:39AM -0700, Shakeel Butt wrote:
> On Tue, Aug 19, 2025 at 10:15:13AM +0100, Kiryl Shutsemau wrote:
> > On Mon, Aug 18, 2025 at 11:58:03AM -0700, Joshua Hahn wrote:
> > > While testing workloads with high sustained memory pressure on large machines
> > > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > > Further investigation showed that the lock in free_pcppages_bulk was being held
> > > for a long time, even being held while 2k+ pages were being freed.
> > > 
> > > Instead of holding the lock for the entirety of the freeing, check to see if
> > > the zone lock is contended every pcp->batch pages. If there is contention,
> > > relinquish the lock so that other processors have a change to grab the lock
> > > and perform critical work.
> > 
> > Hm. It doesn't necessary to be contention on the lock, but just that you
> > holding the lock for too long so the CPU is not available for the scheduler.
> > 
> > > In our fleet, we have seen that performing batched lock freeing has led to
> > > significantly lower rates of softlockups, while incurring relatively small
> > > regressions (relative to the workload and relative to the variation).
> > > 
> > > The following are a few synthetic benchmarks:
> > > 
> > > Test 1: Small machine (30G RAM, 36 CPUs)
> > > 
> > > stress-ng --vm 30 --vm-bytes 1G -M -t 100
> > > +----------------------+---------------+-----------+
> > > |        Metric        | Variation (%) | Delta (%) |
> > > +----------------------+---------------+-----------+
> > > | bogo ops             |        0.0076 |   -0.0183 |
> > > | bogo ops/s (real)    |        0.0064 |   -0.0207 |
> > > | bogo ops/s (usr+sys) |        0.3151 |   +0.4141 |
> > > +----------------------+---------------+-----------+
> > > 
> > > stress-ng --vm 20 --vm-bytes 3G -M -t 100
> > > +----------------------+---------------+-----------+
> > > |        Metric        | Variation (%) | Delta (%) |
> > > +----------------------+---------------+-----------+
> > > | bogo ops             |        0.0295 |   -0.0078 |
> > > | bogo ops/s (real)    |        0.0267 |   -0.0177 |
> > > | bogo ops/s (usr+sys) |        1.7079 |   -0.0096 |
> > > +----------------------+---------------+-----------+
> > > 
> > > Test 2: Big machine (250G RAM, 176 CPUs)
> > > 
> > > stress-ng --vm 50 --vm-bytes 5G -M -t 100
> > > +----------------------+---------------+-----------+
> > > |        Metric        | Variation (%) | Delta (%) |
> > > +----------------------+---------------+-----------+
> > > | bogo ops             |        0.0362 |   -0.0187 |
> > > | bogo ops/s (real)    |        0.0391 |   -0.0220 |
> > > | bogo ops/s (usr+sys) |        2.9603 |   +1.3758 |
> > > +----------------------+---------------+-----------+
> > > 
> > > stress-ng --vm 10 --vm-bytes 30G -M -t 100
> > > +----------------------+---------------+-----------+
> > > |        Metric        | Variation (%) | Delta (%) |
> > > +----------------------+---------------+-----------+
> > > | bogo ops             |        2.3130 |   -0.0754 |
> > > | bogo ops/s (real)    |        3.3069 |   -0.8579 |
> > > | bogo ops/s (usr+sys) |        4.0369 |   -1.1985 |
> > > +----------------------+---------------+-----------+
> > > 
> > > Suggested-by: Chris Mason <clm@fb.com>
> > > Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > 
> > > ---
> > >  mm/page_alloc.c | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index a8a84c3b5fe5..bd7a8da3e159 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1238,6 +1238,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> > >  	 * below while (list_empty(list)) loop.
> > >  	 */
> > >  	count = min(pcp->count, count);
> > > +	if (!count)
> > > +		return;
> > >  
> > >  	/* Ensure requested pindex is drained first. */
> > >  	pindex = pindex - 1;
> > > @@ -1247,6 +1249,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> > >  	while (count > 0) {
> > >  		struct list_head *list;
> > >  		int nr_pages;
> > > +		int batch = min(count, pcp->batch);
> > >  
> > >  		/* Remove pages from lists in a round-robin fashion. */
> > >  		do {
> > > @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> > >  
> > >  			/* must delete to avoid corrupting pcp list */
> > >  			list_del(&page->pcp_list);
> > > +			batch -= nr_pages;
> > >  			count -= nr_pages;
> > >  			pcp->count -= nr_pages;
> > >  
> > >  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
> > >  			trace_mm_page_pcpu_drain(page, order, mt);
> > > -		} while (count > 0 && !list_empty(list));
> > > +		} while (batch > 0 && !list_empty(list));
> > > +
> > > +		/*
> > > +		 * Prevent starving the lock for other users; every pcp->batch
> > > +		 * pages freed, relinquish the zone lock if it is contended.
> > > +		 */
> > > +		if (count && spin_is_contended(&zone->lock)) {
> > 
> > I would rather drop the count thing and do something like this:
> > 
> > 		if (need_resched() || spin_needbreak(&zone->lock) {
> > 			spin_unlock_irqrestore(&zone->lock, flags);
> > 			cond_resched();
> 
> Can this function be called from non-sleepable context?

No, it cannot.

And looking at the locking context -- caller holds pcp->lock -- looks
like my proposal with need_resched()/cond_resched() doesn't work.

We need to either push for wider rework and make cond_resched() happen
upper by the stack or ignore it and have cpu_relax() called on the lock
drop.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

