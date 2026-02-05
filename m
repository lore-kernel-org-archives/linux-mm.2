Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FB1E91260
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E306B0005; Thu,  5 Feb 2026 01:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711AB6B0088; Thu,  5 Feb 2026 01:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610616B0089; Thu,  5 Feb 2026 01:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3BE6B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:27:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60DC513ABCD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:27:43 +0000 (UTC)
X-FDA: 84409422006.25.6376A3E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDAA5140002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:27:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsikP7Zi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770272861; a=rsa-sha256;
	cv=none;
	b=6nKlcfXUNs+USBSTdv8nQhsQ2G8zazb4p8NWA+yp3yscKi9t5MJZVM0jNT69g7wlzlWvLt
	zy832jOYV/W2Jvz6GsWC2KfuD8E9S18U6ftenwtWXVbwQ+c/gP+yMs+oTDc81FpXsSXx4u
	0/BtRxXmMIbwecwa155bRmFQInsM8i4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsikP7Zi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770272861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5OhQXk+94HmpHUw68dY4HtfSY/PojPPrLNFXkDkRLs=;
	b=B0kgtsQQ7IFqq7jbi8h2c/DmyW9UGzAZWTfQUowgfmp6/9zVZqTvitgRwqXhqve9Jfu45k
	YodWuvXBZ7vKThHcOgZB1vBTuUrsaY/+/aL/OhM6v03cSm7zNwvrAFIkxAsXoTnGUKo21d
	Ytjs7sPVKtr6X+fXRjpcLbHFJdo9Zyw=
Date: Thu, 5 Feb 2026 14:27:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770272856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l5OhQXk+94HmpHUw68dY4HtfSY/PojPPrLNFXkDkRLs=;
	b=TsikP7ZiEnJW/y4ttAd7jLOF8JGr2bTNf8VQULR9LI0uz0q8gqm2QgmDHU8hVojiBDUMQp
	3GLHIK8RCVTV/kH7J+5OZsqZtanZ4FUgfzfXLxbRbN+Qe9yyXaK50UH2cPlkEGQTUjvAoe
	kNdBb0nYWPS/xiqOQNKaMQa11olRTPQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for
 unmergeable caches
Message-ID: <pjy643v7gh6migxdnmeo7bxtltlfay2pdai7lwzhyf2svk23ix@qgrtxjhutmkg>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-3-harry.yoo@oracle.com>
 <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
 <aYHqxs2bkSEFOqZZ@hyeyoo>
 <ed7hyqa62mp3mqc67eezfccw4bk6hrxzfulz7pwr4inzyikveb@2hlvbjvvi2ax>
 <aYQm8_hnN9JYD0xM@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYQm8_hnN9JYD0xM@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EDAA5140002
X-Stat-Signature: 8tbxtw7najky9us6s8iuw3onbr8mpfy6
X-HE-Tag: 1770272859-218958
X-HE-Meta: U2FsdGVkX1+xXQfmUnPLIu+GgdDDgW52uymut/PYFyusDa3rohkZLrJk1KNpvZP5puNb0dQ+H+UuQoW1NXFZmMBJlg/17KzjV+W9nI/CwnBSTTNdqdkIMeJWCQzWq5GZmIpECGZq1dhfch1/CXtArL8948qs5qr+Eocj7jLmUK4ANUeY/rWDuaGsUrNwxw0qxgdCFFVE+A9tuVug5F2SWX9h+bGhGarF0gODwl3Y1o6vUvqrAQqma1D531UB5Lfo0YTzdqQGWuJdFHkcD6I8zpG1oycoJkvTpJ+jfXKCT9A17G3IzOI0SZ+ZICVwq7L3h67zO3p7TlmRTz0cA3K0Mwf17stbcSka7c3ziEn6y1txcCT+PQ7xp5qPlpU7wR/ztmIbQyII72DkF4J7M5j7pjkzHvccxc86L2D4exwZ3h66jP6uD8ciYVIC2DRZ5CyQ5Gt0GMayXbPx4O10Q42A2nNiDZLmOn7M/UihbxEdgoapFMvbJ4wRX+fuuO6DaalmEd9H6jwvwzV15lVnOfxOcBqnSNyxVMWJNtimTYd2AVNWJkrKS54PkcAXRCJgZDDTlsYJflJElz/hv8j5DV/1L+XzJMcIH5YS0Q0CIAV5eOH2Q9PiWODmasnuWcyMkEm30dpcKjY9ZVifMG3IvocqJ4LusfJoXYok6eFX0OHmcyOrokedwDgBs75j1tSuotf2b/QarOrR0SQqqQMNGXYLoLnwFDJO33YXF1jhOfvPtikAK+vo91xvlDZt33Y7tJm0ODRhfy52pysYf+G5rtUvQB0huhtownN0U29mPvWOLOdYfsrwjonQg2Uq7GQN3P2Uuvyp3bQnTS6zgxPW71krFJgEuPPRqJOAwZhoxjfFzuMCR3/xq0cnVOky/pT3YZw+QHz64mvvWToTwkcyOmUBNjeEEtFO+8tXJeqYvQS8EtUwFQx/ioPlkN0Dk63mzTi9Y5cAtyjmZ9BjL3dox1N
 SqlJZj/M
 EZuVoP6JUoa5jUeUB/SBe5vTT1uhQGTpti5MJHbJrgEkAFtfkj35ga3HolZLqQuD5vYbnGqs6TpvNlEB28BhdI+3bhJe6lVLtLW5lBBB3uLONyE7pjwthnXn7/vn8BjvJ4G+8Aa4zcFPI2xTi71LHrwNhP7qfkvQQsrmruSrSi2Q7u9ZBEfUojxZn5JtBCOyxzxkcfajiXpQYgJb8ePvlEuVFm6XRxp5A/CPrqL+Vxk/V65VprPCWzyr35HVoICyrPRzz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 02:13:23PM +0900, Harry Yoo wrote:
> On Wed, Feb 04, 2026 at 08:45:19AM +0800, Hao Li wrote:
> > On Tue, Feb 03, 2026 at 09:32:06PM +0900, Harry Yoo wrote:
> > > On Tue, Feb 03, 2026 at 07:56:16PM +0800, Hao Li wrote:
> > > > On Tue, Jan 27, 2026 at 07:31:51PM +0900, Harry Yoo wrote:
> > > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > > index ae9af184a18b..0581847e7dac 100644
> > > > > --- a/mm/slub.c
> > > > > +++ b/mm/slub.c
> > > > > @@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
> > > > >  	 */
> > > > >  	aligned_size = ALIGN(size, s->align);
> > > > >  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> > > > > -	if (aligned_size - size >= sizeof(struct slabobj_ext))
> > > > > +	if (slab_args_unmergeable(args, s->flags) &&
> > > > > +			(aligned_size - size >= sizeof(struct slabobj_ext)))
> > > > >  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
> > > > 
> > > > Hi Harry,
> > > > 
> > > > This patch looks reasonable to me. I just noticed a minor point that I
> > > > wanted to bring up:
> > > > 
> > > > It seems a bit self-referential that SLAB_NEVER_MERGE already includes
> > > > SLAB_OBJ_EXT_IN_OBJ, but we're using SLAB_NEVER_MERGE to decide whether to set
> > > > SLAB_OBJ_EXT_IN_OBJ.
> > > 
> > > Hi Hao, thanks for bringing it up!
> > >  
> > > > Do you think it might be helpful to add a comment here for better clarity?
> > > 
> > > Hmm but I'm not sure what should be clarified here.
> > > (perhaps because I wrote it).
> > > 
> > > Checking SLAB_OBJ_EXT_IN_OBJ (as part of SLAB_NEVER_MERGE) before
> > > setting SLAB_OBJ_EXT_IN_OBJ should be fine (because it's not set before
> > > we set it), and once you set it, it should prevent merging.
> > 
> > Yeah, s->flags currently doesn't have SLAB_OBJ_EXT_IN_OBJ, and the functionality
> > here is totally fine. I just happened to notice this while reading through the
> > code, and from a semantic perspective, it made me pause for a moment. It looks
> > like we're checking if s->flags contains SLAB_OBJ_EXT_IN_OBJ (among other flags)
> > to decide whether we can set SLAB_OBJ_EXT_IN_OBJ. Maybe we could add a small
> > comment like: "SLAB_OBJ_EXT_IN_OBJ hasn't been set yet here; this is just
> > checking for other unmergeable reasons."
> > 
> > Of course, this is just a small thought, it's perfectly fine to leave it as is-I
> > just thought it might help slightly.
> 
> I think it's probably okay to leave it as-is for now.
> But thanks for bringing this up!
> 

Ah, no problem, thanks!

-- 
Thanks,
Hao

