Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2F3CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD038E0003; Fri, 26 Sep 2025 13:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866F58E0001; Fri, 26 Sep 2025 13:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C7D8E0003; Fri, 26 Sep 2025 13:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60C028E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:33:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A60F160722
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:33:58 +0000 (UTC)
X-FDA: 83932099356.16.0C72859
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 289954000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:33:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m557uW9t;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758908036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tIyjN68caZZj15yGUoQsD17H0Ww8dCvVPZYwpO6gf4=;
	b=hcIHYrwGKYVms/ed1y73NwoYI+DOXiasmpSai0xqAean01L0/OI3+1m1o1XFIM5qxH3t7z
	sCpSDfvly5kTHDjiAdVrUsFnFIocxsclasgWUaRhStJ7+cImWYw8F5+I4VTxH1qJlQStM4
	jRkJ1NZFi38I7M6yCsqmIFcXW2JXI3U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m557uW9t;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758908036; a=rsa-sha256;
	cv=none;
	b=T+R3KXiTic1gGy+Jx+jThuDPbaTj9JZmZjzDCdTEd0SkeYAfxOieWJGIDX6nnAeWcK1RWM
	65ukBv4fBfbiQqnbdwbxTYFJTzb8Xa2oUmcRNXenvrNTuEDsuuZ/E1ioQPPir3TR0ulKt2
	YLNq/U1mu3x0fc62r8VXGJGrpA74UnU=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d60110772so23050467b3.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758908035; x=1759512835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tIyjN68caZZj15yGUoQsD17H0Ww8dCvVPZYwpO6gf4=;
        b=m557uW9ttXGkjtPbBiCBH3RSfqJKjadyAcNBaszH7/7bCyealdOq+T3W0Qw+KgajSt
         XRHBeURsv2cISKQ4wnWHCRqF91hYDQxYTMpg/PkBFRw7XJXH0pXrfL+FM8pohwemBAVH
         RWLMhvksg+dtocdwJM8yMlnm5CIId8w4cNytpxy97dQu9EzfypT9Y3OzATiOjVevUFfa
         vgtyLu0VBS5nXArJHRfO4CVM+r6kH6uHAno88Tj5xivc1JXlz0yJNX9FV8tC2Uer7Y2l
         5zOyo1D9BsfHF5l3iCG9bvVQSTEJpVpS2oqYzYQPd7UpnwSQAgt0Axt6UfnbeKmkt0R9
         nA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758908035; x=1759512835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tIyjN68caZZj15yGUoQsD17H0Ww8dCvVPZYwpO6gf4=;
        b=tnQlHjOiNHeze8e6r4QeBUxHc4aO0I53XrxDhjLC+W00d9ouZtgWwKWrN263MCifky
         wtUpy/s/+keKbW94BETBBenPyVFHkNksXVuNLvEFv+Plg/LK2NjYJJQSwkHCC6i7/5lA
         ixmLfFl7bFXDqe9qo74mHJgFjMSQEKlQoJIRIYPu3wSzTBsdIRpPL6ZiQlH8JAREFp4D
         gmUt+PcxY4YhrADs+Rbnz5tAFH9zuoXwad3hoNt+zcnozYhIfFcojvYEPYMIkkKh6Gty
         2wsgmIs8y0vrRS0SL+L0AWEb6mFHgQOta5FY5lrQnYXzgUvl8Hi5lEzllhZvwiUjhdhH
         SnzA==
X-Forwarded-Encrypted: i=1; AJvYcCXsAXehTcz8H+OWPQJA9Fi+qhdegl65qudc/UQoO3vkBvFsPcP/0t0QLfwiH6dkJ3WDXD734EP1Fg==@kvack.org
X-Gm-Message-State: AOJu0Yy9E1G67TjeSY0J15i2lk0GQhMEfuU3yHUbfOqkxLPSFqnBOYnw
	4uGpw4GHtyi52uQmGOm2oMNnYYF1SwpNcRdz5muFpnBKDm317E+lOSEg
X-Gm-Gg: ASbGncuAlpKqNEAByJ6lnuNGiJa6mjWabc4L8dbvLWioHUCmFxn/iOHWLHWjhZgU/l9
	2++GT4i/P3GLwHerqvMSQ3UJJuTVTMJwUurCsquBd8YZ+Ck/HGeDcWfRxxU4hlf338vW2WhLk26
	aizy+WE8yZuvyUeGKRpJRztB0wNPgOuUN3X+HPrbvMF8CLKO4ZtUtUmw+1ePz67e4BzUcdEjkWT
	hUx442lqz3Ufp9dDxyvS3EhMYAdcri9dO3g8Z6BVfWyTXDoZ/TtTd8Zx/yZOd9sV6xaKXWr5SMQ
	pdQYYSjyib1TVDz5DFNpkpfdH6LYKY/ceIOqpChIhqtf1BvbA6LP16pwXypk+m9Xq9+Et3rPLJO
	TlSVFGC8MHEUY+wgNCN4XAaeN6TMyCv3MnHSBwSyHfmrW+sfNkriGDw==
X-Google-Smtp-Source: AGHT+IEubc4JJpGRwQRxurB+nRlYGoZoQ9jmMPYR0K74KyC8/v0jMkfTY/PqqLCskN8kN7mzuHKHZg==
X-Received: by 2002:a05:690c:6087:b0:734:e6d4:acce with SMTP id 00721157ae682-763f9e75c51mr77045277b3.3.1758908034859;
        Fri, 26 Sep 2025 10:33:54 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765aebc1503sm12538887b3.0.2025.09.26.10.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 10:33:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Fri, 26 Sep 2025 10:33:52 -0700
Message-ID: <20250926173353.2850266-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <DD2W2YFEPC3L.250WBJ4E5EM4K@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 289954000A
X-Stat-Signature: fqtdzrx69unyeyosmix8cspw348zhuq3
X-HE-Tag: 1758908035-981438
X-HE-Meta: U2FsdGVkX1/cKshg4HxwHTNwM/z2AUtj9ETBkeomoRFGT3tbvnADLhc7mFfQ/UQV2alk01+cLLbKwIX+5piOxlkYLeVpeFZyRaDINOhk4DcZM/I1CZ1MxDZFqN3zRqWli6UZdwWpzVnRsiKnmFOQV4XaqGRhSvRpPAhKiuvECC+LuGsm1jCqUWbOB9OuYXKvZTOfrJgvPUTKwRWQIbR/IlvMIZhLye74+oJ6Pg7S4+22bsja53wHkP0Ngnm1xcDrMX9+MqVywsyECOcSKrxfb40qBE1ZQIBXlTLYOOnFS3gRio6A/nK7zu1GICuUHB9Zs1DScmYdh6EQ7XNyw8OFyHHvGO9c4/GLzYlVi5UUBB76V3QtOazXFBp8T5rXfDyfJcumSYwODdRYmdTsinO8v8qpVvWBKU6jqiHhPEttSwzUcX5lrSxsRfl7hYh74MFcwO2dNMeexY0SZoRz4LNubmVJH1+ro6x2AWZPMvIreVi4/yreLwIZnIArt6/wGuGF/iwEUEiSgk6VR+bMTmaxRYLBBgWRmmwHp0F9c9q6EYnyqnq5wehJn0wD49/uvIvZjRXPk1uXd4IB2zOpBZcAlB8a2f9LIGjbxf+HU7Ew3vNCdx6mfRkyjMA2EDGJMmAq3SfRADR5JcF3ottF5WhFKLRDGhqCLK/3dECPhwf9L9Si9HyZYH45ktufucVCn2sPheEC/ieDzLfgVStKRKtIn7mugIQlC/k1DcQ5iAwfuydcLlP5eb4xQQxM91OcRte32lBHIDGuyuPgn2mx6aPP6OyyuSVGYnmY8O+h6gio70F8Rm6fctyg48lv5FbJ5SbEh0I/TxYKfDeEEeffjiAKmGhTsEsaCb4gHoOsf3ilLAeK0mEykXILxyWIQGz4pXjkm/A7ZFTw4hN3o19YtyjxeqwDmWA9ZTJelEcw8untKmESZpKKDClvPDzMMs2IB+gskKqXz7wCJWUSrfdWqw4
 MX+KXj/W
 P7GxwNgxqvzueHXTqyAHu317knNUyWsdvt6LtcsN8TCBxajvcps3TiKejhEEPu7nq6e0Ppn8IZFXC/9IHPYCjm5VwA5k+nQcT3jZlGsRGOr+wBvSiK43DPefyvy0qquvowAfbcwRdEzCSSM6HSv/ODuzgzM7JvmKWN93ERF9QmHWSk9wbHYLGNxeYU5MsjW1YEKTlArnViutqP0k8Js0tYG0AHAkZoYK+7EYWBXH5sxjnoZPL81D52hZvYOwan7rwGxO/HsdcknfVVm0k1RiX/nbCmo5QERCZaacvz3ZT5iqyF1kbkESeDEPu5hZLstgIwQxs3C/Uuo77VESGaPtxrJX/eQcv3EE4jK+8pX0nrCzJsZFQAAr5ldCh0yLWJ14GGaUjkhRFvC8yHrv8gCLGCXnJtD3pYj0pGoN+8S9mIXP5BIcFG91CyH8QMzEArXjNnyI0nunMVmIcCug2g/xdoVtP1TKTIUjfaKngtwM+JJcv5eJlxJAT7tCnmnJX83wRwWHpsT7HXfMEywB+vFMGceOyIGUzMkbHM3sUgiPWpeLgPx73vfcxCNkIwXaiDTRYVCTW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 16:57:16 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> On Fri Sep 26, 2025 at 3:48 PM UTC, Joshua Hahn wrote:
> > On Fri, 26 Sep 2025 14:01:43 +0000 Brendan Jackman <jackmanb@google.com> wrote:
> >> Hey Joshua, do you know why pcp->batch is a factor here at all? Until
> >> now I never really noticed it. I thought that this field was a kinda
> >> dynamic auto-tuning where we try to make the pcplists a more aggressive
> >> cache when they're being used a lot and then shrink them down when the
> >> allocator is under less load. But I don't have a good intuition for why
> >> that's relevant to drain_pages_zone(). Something to do with the amount
> >> of lock contention we expect?
> >
> > From my understanding, pcp->batch is a value that can be used to batch
> > both allocation and freeing operations. For instance, drain_zone_pages
> > uses pcp->batch to ensure that we don't free too many pages at once,
> > which would lead to things like lock contention (I will address the
> > similarity between drain_zone_pages and drain_pages_zone at the end).
> >
> > As for the purpose of batch and how its value is determined, I got my
> > understanding from this comment in zone_batchsize:
> >
> > 	 * ... The batch
> > 	 * size is striking a balance between allocation latency
> > 	 * and zone lock contention.

Hi Brendan, thanks for your feedback!

> > And based on this comment, I think a symmetric argument can be made for
> > freeing by just s/allocation latency/freeing latency above. My understanding
> > was that if we are allocating at a higher factor, we should also be freeing
> > at a higher factor to clean up those allocations faster as well, and it seems
> > like this is reflected in decay_pcp_high, where a higher batch means we
> > lower pcp->high to try and free up more pages.
> 
> Hmm thanks, now I'm reading it again I think I was not clear in my head
> on how ->batch is used. It's more like a kinda static "batchiness"
> parameter that informs the dynamic scaling stuff rather than being an
> output of it, in that context it's less surprising that the drain code
> cares about it.

It also took me a while to understand how all of the pcp high, count,
batch, etc. tuning worked. But yes, from my understanding, batch is used
as the parameter that helps inform things like what value to decay
pcp->high to, as well as how many pages to free, how many pages to leave
remaining in the pcp, among other operations. 

> > Please let me know if my understanding of this area is incorrect here!
> >  
> >> Unless I'm just being stupid here, maybe a chance to add commentary.
> >
> > I can definitely add some more context in the next version for this patch.
> > Actually, you are right -- reading back in my patch description, I've
> > motivated why we want batching, but not why pcp->batch is a good candidate
> > for this value. I'll definitely go back and clean it up!
> >
> >> >
> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> > ---
> >> >  mm/page_alloc.c | 3 +--
> >> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >> >
> >> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> > index 77e7d9a5f149..b861b647f184 100644
> >> > --- a/mm/page_alloc.c
> >> > +++ b/mm/page_alloc.c
> >> > @@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
> >> >  		spin_lock(&pcp->lock);
> >> >  		count = pcp->count;
> >> >  		if (count) {
> >> > -			int to_drain = min(count,
> >> > -				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
> >> > +			int to_drain = min(count, pcp->batch);
> >> 
> >> We actually don't need the min() here as free_pcppages_bulk() does that
> >> anyway. Not really related to the commit but maybe worth tidying that
> >> up.
> >
> > Please correct me if I am missing something, but I think we still need the
> > min() here, since it takes the min of count and pcp->batch, while the
> > min in free_pcppages_bulk takes the min of the above result and pcp->count.
> 
> Hold on, what's the difference between count and pcp->count here?

Hm, sorry. I think I also confused myself here. count is indeed pcp->count.
So what is basically happening here is
	min3(pcp->count, pcp->batch, pcp->count)

... and you are absolutely right that one instance of pcp->count is
unnecessary here. So it seems like the solution is just to pass
pcp->batch to free_pcppages_bulk, and that way we can have only one
instance of pcp->count!

I think I confused myself because I thought you meant we don't need the
pcp->batch portion of this min(), not the pcp->count!

With all of this said, as noted in my conversation with Christoph I think
this patch may be unnecessary since this is not a source of contention
or lock monopoly anyways (in fact, it may even be harmful to batch it
to a lower value here).

> > From what I can understand, the goal of the min() in free_pcppages_bulk
> > is to ensure that we don't try to free more pages than exist in the pcp
> > (hence the min with count), while the goal of my min() is to not free
> > too many pages at once.
> 
> Yeah, I think we're in agreement about the intent, it's just that one of
> us is misreading the code (and I think it might be me, I will probably
> be more certain on Monday!).

It was me : -)

Thank you for taking the time to review this. I hope you have a great day!
Joshua

