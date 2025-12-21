Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C90D68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 11:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1A26B00C4; Sun, 21 Dec 2025 06:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C22D6B00C5; Sun, 21 Dec 2025 06:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8596B00C6; Sun, 21 Dec 2025 06:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8B26B00C4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 06:04:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D50801333D
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:04:37 +0000 (UTC)
X-FDA: 84243194994.27.3C3B390
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19AD316000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:04:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I5J8GwAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766315076; a=rsa-sha256;
	cv=none;
	b=mczB/o8CTnzoJqVDaAtFPS6UY/6sEDiVfe2D0urxS8e6BDQ7vwRLPhMK1LOn6fQRi/AlEn
	d1gim2u9Mw6Tc1wR+JNbDQcZ2UWjqafBwIi/qpks+TxaOw7iBoyFO/WpGOzCljq+HCYGzE
	p67m9N+WC/B0xMp4aai9XDfEivnt9Ag=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I5J8GwAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766315076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSwYcxorWh4XDBwCG+RMDN991xiQ2HYSQWjQd/bUtbA=;
	b=bXySe8uPNCzBWGssAgdo8mCRgFttBxtcVi/SjoK9e1HkwgIbhM30Pn89BPmRJf9lTIfC5F
	UX2Za73rYxue70owMVNcmSariNo5yM5GA9GOJv88IRRmOjMnsSRt24eJMY0qjP57sCz0Hz
	TFpaOvhd9lI1G60K2BVLchwtfs6NwFk=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7881b67da53so25242287b3.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766315075; x=1766919875; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HSwYcxorWh4XDBwCG+RMDN991xiQ2HYSQWjQd/bUtbA=;
        b=I5J8GwAfHBT0JQwrGzG40qWFyeMYCSzSaFrD4Cks8kyiFxvBMN+DpR08JdvmLGa+uh
         r/xz5FX7ZkAXSyjjZmYsOUdbA2twnuN7X6qk4F/tNsBddASkOk4qY7oFCnD4xZESDyPX
         VnX1addbqFlxkSx0yDhIqtshQ1n3UK6Slvy5eCDfRJKxSVyMxFLdYhOd7dPMm+Kqomar
         n7mCToHl7qmI39TR5YQgx4aaKajfjqpG80/O3wmN7yc1l3rx14vYyb8VNhqkJQszOVTN
         eDR24pLp0Ut5cYDxkWfROR8I+2ybpuyO5A/xu9jLfTAwHiKUaS7YU2ekfFvavjEOy8Tg
         aPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766315075; x=1766919875;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSwYcxorWh4XDBwCG+RMDN991xiQ2HYSQWjQd/bUtbA=;
        b=LmW03tZpACsl9WVjqEqhxjPI8mosb5wHcn4y6JZBqLyXt/oP8J3iZ1jFpPfOEnhLcd
         eiaVvIq1Ac3yvRZMcVbxkkvUemEWO21cp7XyEBmvymaTLXbkaD+yYdszE7/6fdz9xv9i
         luiRCEc8nXTaqLKwYZAexaoFux9+ysEMfkZr8gYQ98pAKkX7hO3Ur3kaiJTw6eyj6ikg
         QJ68d3+VsF9dANCvYQLHUGEx1w1Ii/9VxjUXr/N0WN1fZuexy1bwAxveKrQEn722+vrZ
         czAwVyEgl8OZ64Ef3H8ESKm3WYT5fXqTiKfEdwtLDSuuU5zFluxr9ehcglsyCT8DdmTV
         W8xA==
X-Forwarded-Encrypted: i=1; AJvYcCVg33OpTMuB600PzJphka9QxWZ8jRYK4sq9WEro4WmivdasfW/qZK7agCi3KqAVFMbV/JImLc/hcw==@kvack.org
X-Gm-Message-State: AOJu0YyJHsDv3HtI89QCHGCHs+zL+DuXQcxvLB2WYGF5WBWJQRxuvKEM
	fhxLhezVMeVG77rhKZUwKgSAG+s6JMxzQZ6xf5Ey5puj1wCSQ8+3mudDP8FlDPQiGIaqlZFTddE
	uyuCq4M3GfaRUKucdr9UzE4/uMEVUg2w=
X-Gm-Gg: AY/fxX7I2Le8Z5LdhI/Vz+5zrakxYtqaMvh9ogd1NUJlJ4OGZF8nx9qjSA9MLFLKXFy
	Jk68I7sXv2rWTudrPamWyxAO6ZU7r6WshGTF05dwdkp5HIF7sOAcdoS924dTZ3eqJnHO8c2Rx80
	0HnM3DVaC6eAgeawqnlAkrsoj5XlAPG2D7ixq4kyF5d6bLsfhKmE3PMTZU7wmZKO0ijzL5u4LLT
	dSoskjcJfRUkIK/OzGhUHy1+jHklIoh+Ly//YVRT/TWe4E8bXTgvnbRLI3JCgpmzftStpm1Gy8r
	MKupsXs=
X-Google-Smtp-Source: AGHT+IG2Toq9qnzszzjdL+98B2Dr0jFCu0YHg3Tjd/aDjfzvUu0GkQ62iWiS7373LlpJYGVJK3BGOt9VJWAkIY+a6BQ=
X-Received: by 2002:a05:690c:c4f6:b0:786:5212:4a7b with SMTP id
 00721157ae682-78fb4084d8dmr69652507b3.58.1766315075027; Sun, 21 Dec 2025
 03:04:35 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC7=t0iHEC-BQPZcF+KiKcc2tVyxNOLMifZQ=JwH2GwFpw@mail.gmail.com>
 <20251221081227.42071-1-sj@kernel.org>
In-Reply-To: <20251221081227.42071-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sun, 21 Dec 2025 20:04:23 +0900
X-Gm-Features: AQt7F2oEjHHI5p4OWYHfOqEy5bd0bgpAsDaewTxzhRqzUDMezd9tbvBE7MH7ytE
Message-ID: <CAHOvCC4opA5kdX0c3RrUL0g9e95JJb5hr=ZaGS7FGoQ-nxgF3Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
To: SeongJae Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>, akpm@linux-foundation.org, damon@lists.linux.dev, 
	linux-mm@kvack.org, enze.li@gmx.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19AD316000E
X-Stat-Signature: dgjo7gczrq91h4w19kj9ufk977ipojqy
X-HE-Tag: 1766315075-14372
X-HE-Meta: U2FsdGVkX1+k/f/jCyIM6F95d1iYkRezXYnnbEJk6ftpK+7DTKB/BOsf1slr6aTiEaOBkAzpF7YpHpZYQqg9fvIQ+7YT3w8yfvDEQBiy83/k/bvJ0Tysi21YA5zEfc8Z/poGdt6Ttgs5owL1CTkSI/dRbrfNqd/46t2jbmOMELwmTUTfwpWRuC8+v9B7lwmm+sdSx9eAPppr32Bds0x+ufLog0DBd8S7SXEdqugXTeubPj4imPMywdjodI7+4u1R2FeIRHspzC+L/svGmFkcxsOCGzTWGckH5KCyfGO5th1I4zBvUZ+yaoHe4xrdImfdSumUzhR8ITGYUB8WxT/TYiuqm4lARusNnKuNFIDA5hmjqLEhCC9o3HO3Gq7fwfKI568ecSMrToLbQZGGJgvdPSbu7FoDfX6Wj7ynJutTwWmOaYgTEsE13bpunTAoei0zrqXIK3KMihhmb/AIuDytnF2cYGf5Dd+UuIpfiJvw+JkiB4KaEXnqZvgbB7qB91MyH15kQZehUvSj9OGkFjc7hzfqM1Y4MWL+lWHfMownxliAsQbncUv+1NEyv983BknzgEiQaYVSDuCCoPqDrA42S1CGQIDSe3dKilcJZlBrIxCq6hdkOgFpBaawcSarylpBZSVNn5I9gOUOLDuQ4bpqpSwRfz/ORs65REKrV2y4LAx1sMsruXMgb3/GcHhvWiijfcdPggLozdycym6alG/to2YecEcKvYRm3DYLl+jmO7r7dr4fbYW7WLU1XtoXsse0Le2Ze0rbio/e2RIGhDgRdbtvRjY0Q8kH9wji8rDGcGAWDb15dgZZpb5o2dGDcpfTGL2g3uKvsLygSaeIP2CZGabyBHRfb4Z6/3Ydh7MVZu+BPDFwwSelQZtE7YyJFZNSx2ipaS1lFJn79mfElqDTm/Kvg6LFdPFwXXKDKKxDFOHDwk8DPePV/7t5STCuQVcccF2XeGaJua5ZXdfTeJj
 fnTMBNd4
 Na5RcCdEctbomk0xzBhXs57KMAlz0Zv4W7V8AXunGBstz41XlQbxNibl5Nf29v17z3Id5Zp6Jn1TQmoSGAI4K2ZNmU/B/an39MGBcEBYIlJWDIVWNy+nB0igZO1o5kITaXnEj6XQlOT4lV4gGAYDA0y8MOCBrfKqtjxOFo1eRkyiYGyIddS1RGKGQGTrq6ABwC6fcRQLIosXb8M0PXrMTFpcmT9A7Uww+OgypONTqZ/0Tnh6eub0rUty0YHtBoHLb+5ibb6+fZsZAzjP8xb43aqNKAOJsR0rPKWTo/CkD+fCkCQIvb/9W6yPBzjqbrQUm23blR4MtPPtDwjQTP1N+ycQKunv0XQ5OTVwneGx6yvqeunqYrM0wSxjexZwhHGIN+lau5Atl+MdZ81AUn0gkI499Qmd9rnzo6XBYJQlHI5aTXiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 at 17:12, SeongJae Park <sj@kernel.org> wrote:
>
> On Sun, 21 Dec 2025 11:42:43 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Fri, 19 Dec 2025 at 21:52, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > >
> > > > On 2025/12/16 07:16, SeongJae Park wrote:
> > > > > Hello Enze,
> > > > >
> > > > > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> [...]
> > > If runtime controls are essential, I think using DAMON sysfs
> > > interface or DAMON user-space tool is a better choice.
> >
> > I also think the current DAMON design structure is suitable for DAMON sysfs
> > and user-space tools.  DAMON sysfs can run multiple nr_ctxs, so I think it
> > would be a good idea to consolidate it into this.  As Enze mentioned, DAMON
> > was originally designed as a kernel loadable module,
>
> I don't recall where Enze mentioned so.  Could you please give me a pointer?

Although Enze did not directly state this, His patch is a loadable module,
which implies that it was "designed as a kernel loadable module."

>
> And I'm not sure based on what you are saying it was originally designed as a
> loadable module.  Maybe you are saying something before DAMON's mainline
> landing, but that's quite long ago and my memory management is not good.  Could
> you please add more contexts?
>
> > but I was curious as to
> > why it wasn't run that way.
>
> Maybe I could give you an answer if you could give me the context that I asked
> above.
>
> > When executing the damon_start(**ctxs,
> > nr_ctxs, exclusive)
> > function, nr_ctxs=1, exclusive=true is passed so that modules are currently
> > executed only one at a time.  Therefore, there is no point in running
> > DAMON
> > as a kernel module, since you are not running multiple modules simultaneously.
>
> I'm not following your point well.  Could you please elaborate your point?

So far in my view, I have analyzed DAMON as follows:

DAMON core  <---------> kernel module   <------> damo(user-space)
mm/damon/core.c         mm/damon/lru_sort.c
mm/damon/vaddr.c        mm/damon/reclaim.c
mm/damon/paddr.c        samples/damon/*.c
mm/damon/sysfs.c

Above, lru_sort and reclaim are DAMON core characteristics, but they have
a kernel module structure because they are executed with module_init().
I personally think this is inappropriate.  Additionally, currently, DAMON is
executed only once at a time according to the exclusive=true condition
when damon_start() is called.  In this structure, I believe that the meaning
of "kernel loadable module"  is non-existent.

>
> > I'm doing some more research into why we run modules with exclusive=true.
>
> Hoplefully commit 8b9b0d335a34 ("mm/damon/core: allow non-exclusive DAMON
> start/stop") will give you more contexts.
>
> To summarize again, the intention is to avoid kdamonds interrupting each
> other's access checks.  For example, suppose the DAMON context for
> DAMON_RECLAIM and another one (could be created by DAMON sysfs interface users
> or other DAMON modules, say, DAMON_STAT) are running concurrently.  And if
> those pick a same page as access check sampling target, their finding of the
> access on the page depend on a race condition.  To avoid such a case, DAMON
> modules call damon_start() with exclusive argument set.
>
> Maybe this is unclearly documented.  I will recheck the documentation and
> improve it to make this more clear.  If you find the rooms to improve and have
> ideas for the improvements, please feel free to send patches.
>
> > One more thing I would like to add is that I think it would be less
> > confusing
> > to move lru_sort and reclaim to the samples/damon/ path.
>
> No, I don't think so.  Those are for real world products, not for samples.
>
> > And it would
> > be
> > a good idea to organize the core sources toward
> > mm/damon/modules-common.c source.
>
> I don't find exactly what kind of reorganization you mean.  But I agree there
> could be rooms to improve in terms of the files and code organization.  Any
> suggestion is welcome.
>
> [...]
> > > > Finally, I would like to add that designing prdm with an extremely
> > > > simple workflow -- load the module, set the target PIDs, and enable the
> > > > switch -- will contribute to the promotion of DAMON, allowing a broader
> > > > user base to benefit from the DAMON system.
> > >
> > > That workflow is definitely much easier than directly using DAMON sysfs
> > > interface.  But, for the reason we have DAMON user-space tool.  Using it, the
> > > workflow can also be as simple as prdm, like below.
> > >
> > >    # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0% 0% --damos_age 2m max
> >
> > Where can I find the damo source or documentation?
>
> You could use https://github.com/damonitor/damo and its README.md file.

Thank you so much for sharing.  I am trying to analyze the related contents
in more detail to improve your DAMON.  I'll try to organize it a bit better
and send you a patch.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

