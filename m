Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16294FD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4731A6B008A; Thu, 26 Feb 2026 00:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6386B008C; Thu, 26 Feb 2026 00:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB316B0092; Thu, 26 Feb 2026 00:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 162A66B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:54:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B919314098B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:54:15 +0000 (UTC)
X-FDA: 84485542470.26.6DE737F
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9223140007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:54:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="bkJYy///";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772085253; a=rsa-sha256;
	cv=none;
	b=rbbQL/CbbMeMgzvMoLsjtY6Pm5SRAP1qIIkF5BgtZTkto/BCny4/G0uI7w4F6QI8Sjz4ok
	Kr8bbseh3a92nWMHRs3+eUhEAqOX2+G4ogXGu0v/TrVGeSHsXKqpUKp9VZHRdntXIoht3G
	lMVH9YMf2kWF85uKZR0s7zO2KB3koG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="bkJYy///";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772085253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI0pTJ34/6sVzsoFrrk7qColB3pOoTYylL8enXM9wuE=;
	b=NepQFy0dm51Sy2qIPQwmgbhNYRE+m9QnKc7uqrCZIcf7MVWe6DR1ykANwWCBcTC+o9zO87
	GUnbofKY/vu3HSvwXUYkZlfMGryFtHAxPwGZPAm3bBc0USIFHfrArEsizftbmgsrMQGOgG
	TYd0YEGqts5xHqNJgEG06iZo1jbpaIg=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb3b3e643dso25596085a.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772085253; x=1772690053; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fI0pTJ34/6sVzsoFrrk7qColB3pOoTYylL8enXM9wuE=;
        b=bkJYy///3C5nt0gY6S0kKv5p7m+hxcIUxBlnNtMBz8bmJw2x+oQdUhtT3SduCrWmIY
         HYBZyd+xhKR/2wu7sK4shpjIWRKuEaVkHLSJrPiH/QYY7yGX7d2BL//3VWvAlOROG3XN
         XcA1rPc7LAEC8vkg0BcLcYGeZrzSyO5igrICx3Cz993PEKlAIdS3Z5X5IdRr9VCuAtup
         83YU+uIFGLdJhfmJV4kLPh5a7jMfmxd01+NWJoBraf6Tct8fYCNXP1wu1l+CCaRMDho8
         EcnsmuK19l5ca19Xrh2KLL0j5cRCQ9Cbxc3b4y61pojODltJgQapz4+H1SrwDbJI1+Vi
         z1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772085253; x=1772690053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fI0pTJ34/6sVzsoFrrk7qColB3pOoTYylL8enXM9wuE=;
        b=K9zbrSTaftYq2vikkkN0uw3YUftjm2R8PbfFq56rLYrw3QEWp8wAP1pdYWVFQdtxM6
         bmLx8wDzYxw/D0kdFNAGFIw5O6B6KyhpmqhQcFIlZbQ5gUK/BYl78NmACdqYPxsr4OaP
         RvePjufCjANP7nbXAxC/gtFkjiLGujArjN/w3IixKmWpOwCoRTReHPk+yfbJIsZlprwh
         0VDND7Cj7Xr+BYMyvtRiv+aa6vGlw0uc2u2RRyB1KRl2R2XMwWSSom0ImVAe4YUk6lH8
         Nonh5ThaHgTYaD8gL30TK58S4jOvgl6JhYrbhk7IIf8mU74acTk+T3o1a7W4wjnAP1ID
         T9bA==
X-Forwarded-Encrypted: i=1; AJvYcCXGNMYraqCXJtA/NctUep4PzNUDXB/X4Y9Iekz8DpXWbfYyB86T5i9PHvE5A6dMY5hrsZsJ2t4I6Q==@kvack.org
X-Gm-Message-State: AOJu0Yyinewnne1Ipn97xCwZokKtTo5bM87ddmJYL/cnVxv3LEHgYjJv
	67yQ6TXB6x5lIwLChkcYxsyPbia+ZQmlHyX9Mj+v4muK8Uu7UbGe6o46tlAyGfKeJ/w=
X-Gm-Gg: ATEYQzy1IV/Wnb0Sf5bSdqHkGpYqVP3N+fVB9GQXq96jx7SNU/wvCxGqIbUabeKRczB
	CMoa0cEgBM+ud3gmGiMXiz1DRQH4sEqLutJIoF1iTdIyafQGPg+NOy0CuNe0CV/oY6Hn5c1LjJz
	jR20+a7y/CGp3hsU1CeEAhmF/mlaotPohomJWwBWIhqEw3Tlmxne9k91VOv9DcsZVoPDQwWLImM
	HfArVoEg4tKW23MTeWBixgREGGia/jvg2mWu7wloAntRBv1gPud/Px5LHJ5FBg7B+saYHu2NYrt
	QKPwom8Lvd2u4H/jBMTgiPUc2/UsPO/TPzgUDbcrECRYBfRRdFpe0SOI8spJcFhWe9Ta24ZQbXY
	HXJz7t55itW9nfU6si68cqCaEHj+9sooMEhtbh8sWG9XywljcjQ7lIRA06CWpqttq0cPFTl9dj+
	tktUgSTCSMcwI7Iu5J3NsubQqKfMDRwL2+PQB+zD/OmFbpGD0Mp7vOAlS8uTBjKtiSCECpLI1r5
	SbfLfGH6Q==
X-Received: by 2002:a05:620a:288e:b0:8cb:4128:ec3c with SMTP id af79cd13be357-8cbc11f57bdmr90671085a.64.1772085252472;
        Wed, 25 Feb 2026 21:54:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f940fsm122507885a.23.2026.02.25.21.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 21:54:11 -0800 (PST)
Date: Thu, 26 Feb 2026 00:54:08 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZ_gALm7aE3d4IcP@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
 <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
 <a6izpi2wlqro72erhbvxhlx2lwdnae7my3ghfs6t33ivtixo4h@bi2u4x6qv7ul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6izpi2wlqro72erhbvxhlx2lwdnae7my3ghfs6t33ivtixo4h@bi2u4x6qv7ul>
X-Stat-Signature: s8b56qaa36w6jmo7eepkgywpqcjytu1h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9223140007
X-HE-Tag: 1772085253-490636
X-HE-Meta: U2FsdGVkX1/C1vCbYibYREs389sQ2xLjSQD1OeIBxm3zXsecOSnwaCwB43ASAWNK9zxUmTN/X+i5MVDuz7e3a6QFi1B/vdGIpxk/AJ3SiqwZr+WywyK17UEay4sMQyGNGKcjEoHB7Q2/pPy1iRH+ZZaLPjzsO76vX/JFhsAPzm7hJGtDnslFZysoGzEMOJ+5mhMofWiAaxeUbzloB5IPEwuJWubMMQMUfuYT55rOiL6i1cviqGGXZIsHl8NhUWLdxWP8/meBnsRQOZWd6qHtAEOfnerlEtMhTJGxwes6/ZDY86pTOgNdtNjmX8q6HIguzI+OvWP0GKgfNzMXK1XuQ9UFCFYS75k3GfqLZVeeWzkDThYUT+SH/FKH9ZRBbbk7VGABj9vokpuKM+Gp4f5+snU9VdmsaDBXpH+2ex5DE8VfmaNccDQqYqhpYsyNJ47CfU3H2fRRnZ0fmZXrY0E9E+LiuxA75U4UHqpt0g+S2ceDelzN2WUKJvizbz8m9WB+ypWJPQXw5RG2HTL/zPqz7bb6WefgVZk50FAJFpvnJ1gop+g/asYQPPOkcPWyBPLqGcFm+O/FVCMuCd9b369psZHpCwF73EzDXwhWXoXfgPgotC6ZiRQPrhjSdgK1lVDtsc+MqqgIsWHPlQIA5fZYq7VxHkTXOgR2NSleQKtEV59/Mya9yD7yKgEroY8PrBzvTVjXwDpcdk2J2H1UnW9S5LEZqrDrvlB2eqcAGiJEwrX8zbk/xl+tFWLP/a+BNGus2jOuYeOZdMxnXz03/ry4CnbuQ/FcD1nkrBomHvTWU5epQc9VNOxLOjWY/75lZUZ5b4ZCZ4sLoW+93nN0i/TAYk5b6gvwaiFpif5oGrmWzqOjbDaV/voYFvFsxYsMIiqybOlwKQR376MEEwX/fXG44kCM9luO7sK5sK8cUngS7jKMXhLLfiyOUhNad+9odHJ2cxfn+M65D2+CqkznQKw
 Eij5C7v5
 0lTP+Ke47Z8W8gnzIFyfHXO0hshkJF2//9ujJpK6vRtfIYdqagaZ7XpToG6Hp+7hw/lJnADlnJec94+PIgzx8EImLhQhYo7NI7Usp/X2zu0m2vClK1Q15rSFYDDA5Ow7S9ph0+WOY6WnuXshVif1PC6YTCe7Za8HYa4ZwgMyp5TYiPjmlJxElAowh5KS0F5mFv9IMk7AkNwE+r/OhKaa1y14f1zQzt6UzyRvAvTQ995nucEm95hZKGXVy5/xWD8jS1aijBKPtI8jGkfQaBob5bIhtFIaUCecmDWg8L5VywQDp+Joyd5yUcF14zWecEAKVOqIInT0oyKANupnyvlneWywNzOaciAFqMsiAPYx++Wne0TLAY4qKbm8E7MUlQrPilmGsmpXNgiY+H0lWbV07q5gP2snx3FU1uJqMs4N1vjRMNbu/WJOvyEizfEtJ90u/sJjPyFRExtrx/7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 02:27:24PM +1100, Alistair Popple wrote:
> On 2026-02-25 at 02:17 +1100, Gregory Price <gourry@gourry.net> wrote...
> > 
> > DEVICE_COHERENT is the odd-man out among ZONE_DEVICE modes. The others
> > use softleaf entries and don't allow direct mappings.
> 
> I think you have this around the wrong way - DEVICE_PRIVATE is the odd one out as
> it is the one ZONE_DEVICE page type that uses softleaf entries and doesn't
> allow direct mappings. Every other type of ZONE_DEVICE page allows for direct
> mappings.
> 

Sorry, you are correct.  I have trouble keeping the ZONE_DEVICE modes
straight sometimes, and all the hook sites have different reasons for why
all the different ZONE_DEVICE modes and it mucks with my head :[

Device Coherent is the one that doesn't allow pinning, but still comes
with all the baggage of not being on the lru.

Spoke a bit too bluntly here, apologies.

> Don't you still have to add code to hook every operation you care about for your
> private managed nodes?
> 
... snip ... below
> > I don't think that's needed if we just recognize ZONE is the wrong
> > abstraction to be operating on.
> > 
... snip ... below
> > If your service only allocates movable pages - your ZONE_NORMAL is
> > effectively ZONE_MOVABLE.  
> 
> This is interesting - it sounds like the conclusion of this is ZONE_* is just a
> bad abstraction and should be replaced with something else maybe some like this?
> 

Yeah i'm not totally married to this being a node, but it makes far more
sense to me than a zone.

ZONE_DEVICE sorta kinda really *wants* to be its own node, but it seems
that "what constitutes a node" was largely informed by ACPI Proximity
Domains.  Nothing in the rules say that has to remain the case.

To answer your question above - yea you still need to add code to hook
the operations - but this is essentially already true of ZONE_DEVICE
(except you have to contend with other weird ZONE_DEVICE situations).

Some of the hooks here are an experimentation in what's possible, not
what I think is reasonable (mempolicy is a good example - i don't think
userland should really be doing this anyway... but neat, it works :P)

> And FWIW I'm not tied to the ZONE_DEVICE as being a good abstraction, it's just
> what we seem to have today for determing page types. It almost sounds like what
> we want is just a bunch of hooks that can be associated with a range of pages,
> and then you just get rid of ZONE_DEVICE and instead install hooks appropriate
> for each page a driver manages. I have to think more about that though, this
> is just what popped into my head when you start saying ZONE_MOVABLE could also
> disappear :-)

Yup! Basically ZONE_MOVABLE and CMA and ZONE_DEVICE/COHERENT all try to
do similar things for different reasons.

Zones manage to somehow be both too-broad AND too-narrow.

In my head, we should just be able to just plop these things "into the
buddy" and provide hooks that say what's allow "for those pages".

That sounds like Non-Uniform Memory Access *cough* :P

Heck, I was even playing with adding these nodes *back into* the
fallback lists for some situations.

NP_OPS_DIRECT / NP_OPS_FALLBACK
	don't require __GFP_PRIVATE, but give me the hooks I want :V 

> > Where there are new injection sites, it's because ZONE_DEVICE opts
> > out of ever touching that code in some other silently implied way.
> 
> Yeah, I hate that aspect of ZONE_DEVICE. There are far too many places where we
> "prove" you can't have a ZONE_DEVICE page because of ad-hoc "reasons". Usually
> they take the form of it's not on the LRU, or it's not an anonymous page and
> this isn't DAX, etc.
>

It's kinda the opposite of how operating systems do everything else.

Generally we start from a basis of isolation and then poke deliberate
holes, as opposed to try to patch things up after the fact.

> > If NUMA is the interface we want, then NODE_DATA is the right direction
> > regardless of struct page's future or what zone it lives in.
> > 
> > There's no reason to keep per-page pgmap w/ device-to-node mappings.
> 
> In reality I suspect that's already the case today. I'm not sure we need
> per-page pgmap.
>

Probably, and maybe there's a good argument for stealing 80-90% of the
common surface here, shunting ZONE_DEVICE to use this instead of pgmap
before we go all the way to private nodes.

cough cough maybe i'll have looked into this by LSFMM cough cough

> > On (1): ZONE_DEVICE NUMA UAPI is harder than it looks from the surface
> 
> Ok, I will admit I've only been hovering on the surface so need to give this
> some more thought. Everything you've written below makes sense and is definitely
> food for thought. Thanks.
> 

cheers! thanks for reading :)

~Gregory

