Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD925E8B387
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3066C6B009D; Tue,  3 Feb 2026 19:45:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9216B009E; Tue,  3 Feb 2026 19:45:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A4E6B009F; Tue,  3 Feb 2026 19:45:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8266B009D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:45:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB0A4D5413
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:34 +0000 (UTC)
X-FDA: 84404930988.28.4A0796F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8CBF40007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:45:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VKhPWgyq;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4h/YYZWHTFrsi5rw36w716dLeWijGWDgsTOzdwbmuA=;
	b=6nmQKXiZ+2mCN+G55LC4wlsuh1AFtRTLDLTXK04kGivvfd9McocKGOcEhCNsw1FUq4IO6w
	gJy1Q3QRPzqLXEvcIFCoXfUcY5hRagNzHhI5keu9+lfTC73exhXHf/zK2HUOtsgwmbgzdF
	mGusMJ48Iq5ssC7naRozG8PxOWcY7g0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VKhPWgyq;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165933; a=rsa-sha256;
	cv=none;
	b=Zxx/WF/pq5Pq28gEiBYC73+Cd6v1aUorG+nQOBoOKaTFKMArbE2+b6RymrTJQRivb5QNBC
	1j7e28jaUi9OtQXIAbExTqUSoIq97HYfdOsmud40YeweyeFLNi+FwVQKVVNnYnQOQz6zYa
	WEhospWaHikMMduuh8w0Tj0iCsGsW/g=
Date: Wed, 4 Feb 2026 08:45:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770165930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4h/YYZWHTFrsi5rw36w716dLeWijGWDgsTOzdwbmuA=;
	b=VKhPWgyq2lxi7QT4fzjcVWoZldoMTUJToSdgv3ry8xKYXwL2VExAROqKywuCAxF8qlUA0U
	Lujf4nhM4CIz4INfYtJYQ0Eg5JBDXWyEMd8RLxl27/N5IUX8Ml5CSy538eo/sgpSNhQ9UF
	s8oZaaTfba2cxrJ3H+h/tyPLEqH4+zk=
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
Message-ID: <ed7hyqa62mp3mqc67eezfccw4bk6hrxzfulz7pwr4inzyikveb@2hlvbjvvi2ax>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-3-harry.yoo@oracle.com>
 <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
 <aYHqxs2bkSEFOqZZ@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYHqxs2bkSEFOqZZ@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ztf486dx5xtwizodschggddx9s3hdmhp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8CBF40007
X-HE-Tag: 1770165932-329035
X-HE-Meta: U2FsdGVkX18ncVFWp9PhyEv7xo1LyY/1KT1Ha4fUvRmtE/U8/lEHDktITUPISccv1/fgoKGp9pTMs15BTJnIvVrvJY65AGmkV9UgW98jUBgSkpW54FzvKDnHH3tMNOi2t2m9If2eR4UR+lbapIol/uxT2HuL5UkbCXZxAjL0G2k/9GO4SB2txiGQx7vah4ioK8vcPoAv5POqSa9oZ9L18S1jcbB9Ak5ol2D2YA7Bcdo2/xJhX/nizzxsDv9k+73LzXWf4+4RIjcwtS5psfzPgG/OCSMBF/LEVzqsLVDuIHsxdGFSrPfGKXfsDoMBW2gbgc4ID8JGJZHPcMTE1Pl9WjfkrHEljLJghyj1ZJt+oEooYJ881n9S1bkQEOh69qqJjHSG/lnHpt7nk0SmmnoKBSEgf0i+C+pHx7YN1wjtX5BjxsHexJiZmAzIE3RUa9hVauEoFch1ufp3rjFN2qfVv4yzTtysWBpWLFm5U8HZsyJ627gEIkr1WHiF2lU97BWCBYtMjh4m2CdTVPUv6lWtF5GzikW8BKcVcb4T1pqcopH2D/IGHHoqKxpzNZxmBJWs4xBShm7AgupwdiZy9CwYvKQn1ICwZyI+MFnb8nx8qAicKAuI1eczcwvYOWGs/KbUZ3NyP4Nvy868pk3RCnQ3tJEcBXZ9Xb8iJl6ew6AZPGD7BdFsoJbDDBlMBMkaIovmLcN/mmV5juF05lSDCXLoxDVrpgxmHnsBSspNskPvTn4D9b4quvUMs52vXvR1+GJAOxBeot9A+MlkIjGKct9aZ46Y/AtENveq6Mhw+fIjdsV3nLTfNeHau1XbZuGQjXrDB3NrBcdXLOVUMap1I/+L9Xy0CCRgZsT+GxPBpUcBNzgRFO2Z5m4ODS1a0THeAf03vr3DAGbhG3mpvaleEaOQBk/YJTZ4CTPhNrxIehtIY3jdvhBf3neCy91Qo+b6F6uIq1hINTKrcf/obuh2t4A
 IPAN/ULA
 cNjoaga8ZAD/fIaZuOvp18dosnsncn7AZEEWxmv7ZUGO9TWeD7iVTrpSDNkYpv1FRjkxvAB1oMDgSKghThVDnuGLCPd3JcW6p5HzoNM389QU5hCmIDEw64fWTvWv/enhL5ezmxeHRPD2wiu4BBS+53gsQNgi4h0x41ZANnSQ0iDTDxr+W95x4DqnSKjvcjAdsogG8Zyvt3OZCpAkrHyFgrE7E/1jYINiyGAvFQfczL1fHiPiX06R5iXXSPh8e/cZHOymj/RRwHkVHO2koTy5LXFV7rIEuG5PFJCqRCMayYlS1WCKZdl8d2yUpwj819zNqyIGf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 09:32:06PM +0900, Harry Yoo wrote:
> On Tue, Feb 03, 2026 at 07:56:16PM +0800, Hao Li wrote:
> > On Tue, Jan 27, 2026 at 07:31:51PM +0900, Harry Yoo wrote:
> > > While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> > > slab objects, it prevents slab merging because merging can change
> > > the metadata layout.
> > > 
> > > As pointed out Vlastimil Babka, disabling merging solely for this memory
> > > optimization may not be a net win, because disabling slab merging tends
> > > to increase overall memory usage.
> > > 
> > > Restrict SLAB_OBJ_EXT_IN_OBJ to caches that are already unmergeable for
> > > other reasons (e.g., those with constructors or SLAB_TYPESAFE_BY_RCU).
> > > 
> > > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/slab.h        | 1 +
> > >  mm/slab_common.c | 3 +--
> > >  mm/slub.c        | 3 ++-
> > >  3 files changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/mm/slab.h b/mm/slab.h
> > > index 8593c506cbf1..a5c4f981ee8b 100644
> > > --- a/mm/slab.h
> > > +++ b/mm/slab.h
> > > @@ -388,6 +388,7 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
> > >  			unsigned int useroffset, unsigned int usersize);
> > >  
> > >  int slab_unmergeable(struct kmem_cache *s);
> > > +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags);
> > >  
> > >  slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
> > >  
> > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > index 904414c3ebb8..d5a70a831a2a 100644
> > > --- a/mm/slab_common.c
> > > +++ b/mm/slab_common.c
> > > @@ -174,8 +174,7 @@ int slab_unmergeable(struct kmem_cache *s)
> > >  	return 0;
> > >  }
> > >  
> > > -static bool slab_args_unmergeable(struct kmem_cache_args *args,
> > > -				  slab_flags_t flags)
> > > +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
> > >  {
> > >  	if (slab_nomerge)
> > >  		return true;
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index ae9af184a18b..0581847e7dac 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
> > >  	 */
> > >  	aligned_size = ALIGN(size, s->align);
> > >  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> > > -	if (aligned_size - size >= sizeof(struct slabobj_ext))
> > > +	if (slab_args_unmergeable(args, s->flags) &&
> > > +			(aligned_size - size >= sizeof(struct slabobj_ext)))
> > >  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
> > 
> > Hi Harry,
> > 
> > This patch looks reasonable to me. I just noticed a minor point that I
> > wanted to bring up:
> > 
> > It seems a bit self-referential that SLAB_NEVER_MERGE already includes
> > SLAB_OBJ_EXT_IN_OBJ, but we're using SLAB_NEVER_MERGE to decide whether to set
> > SLAB_OBJ_EXT_IN_OBJ.
> 
> Hi Hao, thanks for bringing it up!
>  
> > Do you think it might be helpful to add a comment here for better clarity?
> 
> Hmm but I'm not sure what should be clarified here.
> (perhaps because I wrote it).
> 
> Checking SLAB_OBJ_EXT_IN_OBJ (as part of SLAB_NEVER_MERGE) before
> setting SLAB_OBJ_EXT_IN_OBJ should be fine (because it's not set before
> we set it), and once you set it, it should prevent merging.

Yeah, s->flags currently doesn't have SLAB_OBJ_EXT_IN_OBJ, and the functionality
here is totally fine. I just happened to notice this while reading through the
code, and from a semantic perspective, it made me pause for a moment. It looks
like we're checking if s->flags contains SLAB_OBJ_EXT_IN_OBJ (among other flags)
to decide whether we can set SLAB_OBJ_EXT_IN_OBJ. Maybe we could add a small
comment like: "SLAB_OBJ_EXT_IN_OBJ hasn't been set yet here; this is just
checking for other unmergeable reasons."

Of course, this is just a small thought, it's perfectly fine to leave it as is-I
just thought it might help slightly.

-- 
Thanks,
Hao

> 
> -- 
> Cheers,
> Harry / Hyeonggon

