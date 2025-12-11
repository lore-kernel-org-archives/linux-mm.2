Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2BBD43352
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 21:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34DB6B0005; Thu, 11 Dec 2025 16:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3A36B0006; Thu, 11 Dec 2025 16:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9416B0007; Thu, 11 Dec 2025 16:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9196B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:01:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EF50134B37
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:01:35 +0000 (UTC)
X-FDA: 84208411350.13.84006E6
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37AB44000F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:01:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZoQ6zpKc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765486893; a=rsa-sha256;
	cv=none;
	b=x/sRdAr3kq+qZfvMzcCzCfGlu+eAxJdo4CisAKliohgPoVGTuwK5Hj2nBT4BNYPYp1RwRj
	tnzvd89xws0oWSwzIo7b6lXNrtWbsrWNCFs6Gwg7i301Qkl0oADTl/ZjRHiFDcjlJ0YC5Z
	uQdNL9wqIbT/J37rzJq/antuJ0+1jH8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZoQ6zpKc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765486893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chMTHbvRE6nLkCq/6jCK1ETnrgqh+xahaOOHqQQgZfQ=;
	b=XbWaJ6b0SnQMGKmrA3CSHNSGvj1E3VG+w1TfF18CVEy6LMinbaecgJzrrTAIMrRaltOXqD
	Fstx4TMjqPzlH4xM5NfoiyE+FpxcNJfe2l9r4dJBsdT19hztG4WOfUcXT3kE+Tz1FU0zMg
	ko/06GfIMiWGqCh9Te1WzXkVCtCM/jU=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c075ec1a58aso350399a12.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765486892; x=1766091692; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=chMTHbvRE6nLkCq/6jCK1ETnrgqh+xahaOOHqQQgZfQ=;
        b=ZoQ6zpKcR2ltNvY0VDdFchhuc6huzLOc0wj7mg9J4ZvFv9TAX7m+3VL9yMRgd+D8oY
         AKSIbzTHaCNDjmdZ/++fFKpyVqFA6Jd1cx1XMb114qb5fatcs5gB0a6fxmZsY7Imdewv
         g2CnFTMRqHdVvLv5IJEib+9osHUdiDq2Yf2m5QjKtOUzzU/RDcydUxLrpchOWHEqhGuQ
         KCxCO0Mh+yPTW2RRTaN5lb5HSLyFCjRT9WUX989ewwt+iJR5KxvXmJRPBz7z/eQyHjuM
         XNo0QYtKGpyFAb6k/ODgshmf1D1w7ihrn8VJc9wEmTo7srmgUyr3gdbaQjSnJbsgQPfd
         w2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765486892; x=1766091692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chMTHbvRE6nLkCq/6jCK1ETnrgqh+xahaOOHqQQgZfQ=;
        b=uuVtH8TldHJYmgK2tdf51r356pdxlb79PUz+7Ph9+7I+/twVGSS82JxCUmI68mZv02
         Hp5OamppHPIDAMEfHG0JubEL/0b9LOozbvCcNrWNUCWMglqcSpzK3RYhduPCD5fZnLeh
         VTp0/02rClq6MOSE4J4wp3qxXpI/rpBYxCJKrjB0No0Ih8VZqsChY+RkOMWlcoNUlrDN
         7qA5w9JQJ+i2gTHxffwI6b7Wf/JVJ7IhsxVSRFeCaRjfOv1qVv7Z0I7Bz75eE06ALxed
         iwz1eLcyUa3jPxtrMwEtDJTy66lN3gk2EEtA/zrI/vmV1qWGcSnk2SSGnnpH6qfMWrPh
         NFiA==
X-Forwarded-Encrypted: i=1; AJvYcCUk2wTyD5EHYR9GG2AnAd4syhdewZdx1Qy86IOJz+ImMEUtUxPX6Tj52oMH3hVazjpccu3XFswUUw==@kvack.org
X-Gm-Message-State: AOJu0YyCxYIfAQs51u8XK7U4S91Yhf71q+vg0FSVjsPqWnnPtGTaJ36P
	ZQe9IksjKoh2hebN/2kySvCnZFBj4V3dB3aLNiJ0JymWzna4bquHv0WN
X-Gm-Gg: AY/fxX7/Y3E8KgrhhqpERLZTMXpBsRos0XqIra5KSx0GGr+py/esVQZnnXYk2EXDxUp
	N0Jjha5fTk8kLPt4rjZjeYIYGvGa68D6QR2zp2EYV5+q6Lez6j3tPHym7UR2m3+deuigSyywWJr
	BBaTqv1MCzTezOVxLCqAdraL3nj4Jun7898fWgBBPlV/VB6em5v01Jgx2fKTt3yumkJyicyKXef
	nUdSQHdPx+wtt7neQt+92X3UOLMd/L3yuKXYSrIOwUhktFiQGUsxkPwwqRFkwxpu3k1J/ePKChG
	j/hcDCmEJUNxd7xg1LfrCdePT+o8HdHYwlP+qrDoVV+8T05OySGVSvAKU4lFoDxbj6/G2JNZGFs
	gK4JDS/+Q0yHPeviIgSsAO9jm+X+L9cmjB8cG9oEFKSlBwaebcaPRQiih80ks+dHG7Byyit88LX
	+gbdcTqazjlCxjwtOgnVi3CRZmdtOop8h/m9hBiMy39lw=
X-Google-Smtp-Source: AGHT+IFkQdIZ9eZRU65+BDOqZAYEMxG9QS8hVGWPfFJnB7mk9iNwrFL2LjOTkvfEyyT67cFXYiiI7Q==
X-Received: by 2002:a05:693c:608a:b0:2a4:4f86:822a with SMTP id 5a478bee46e88-2ac055977demr4018753eec.33.1765486891606;
        Thu, 11 Dec 2025 13:01:31 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac1923a917sm7992056eec.6.2025.12.11.13.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 13:01:31 -0800 (PST)
Date: Thu, 11 Dec 2025 13:01:28 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aTsxKDBxelyF0G7Q@fedora>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aToCq6XBybxAFopN@fedora>
 <20251211124710.f1a04ebb7d8b57abb2de6baa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211124710.f1a04ebb7d8b57abb2de6baa@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37AB44000F
X-Stat-Signature: 5w8tfzea1onzs5gzfhpxqx8bk4iq6ddz
X-HE-Tag: 1765486892-474030
X-HE-Meta: U2FsdGVkX19RSKvBTR2ztvtQniRrurKnTyUE3zcZ/30km4pVU+nAHWTzdHnpKKLHaZJNjWjvZq2ifj4iozpUaRE8Iw90F2gB1pq9MbB2vmaoE6qkM1DSGe1JLqNR5DGbyhTE4+guSQ/q7krHZ7s8uGOkFISC2KBvF9Wqjs/FhL+YCpmghPws4lODq24sBTZmL5T4eE3PGyeX4b9rTAOS1Sy/+WpbSmehwJvCoMHaEADwcryQyiMk1SGPFGOvrUqbfvs2JfY3y6L5L8GBkU4iw8fLVaC5Mcr/uC1JKThAR6gLobKCDQxekMGEL755/2nHETweguOuDyHkMRJYwDq9uuVRoJ7hpFgY4INgsJVo3iG2VD7TYI1mIhAHA35SsX1SdfvSpvDphhURSvV8nfyE+xif0C2WhZWKxTtBYK4B90uUK4i2svSqXvHj/kOklwOgn9H6GyPGHhMeS3C8rKImIxiO7KmzNCM52mGOX/fpBWvWImcJNi3TAO1Msjz3CLtigGyVGSSxcwlnDpN0yHm6amjn6jlo0BrXsja8u0+arrcUfxZ+wJOOdqtKSF9wqCwEeUmBpG6CeoaAxSEXPBiiFU3fzWP88IvhKu1GaTXzMyWyrcab5S3V9mHIs6KS/s/iZeRD1LWizuTJbdZkAt0wKEh1Osm1JGt6VrnlKM3/hPkHeXVFAc3KAq8N2ZydRRoervoPPCgY6o+U4tDAUTJadUx6pJNf9JbCz89DaaFp6yx87fthsX7AeUL9XDyYOmGDq0s6JQ9AQ8QmnJggNPp17/VuUxG8uAiQa0wuOf+HEacdm3tR3Qj28+kDH3YNRZDYLuD2aHJJuok6DzfwGbNVsBI3rB55PfeS9YOaXbBbyg5EIBYrtvOQ/ZS1obgF4hPcxhI6JxCrgFlhrqWlSF72K1xxknqWfqqNPMyi3u2vJR0pPIzVIXhet3Od8s9rpa9aNOcdhrUUR/3IV0XZC9g
 /AUu9+jz
 zWsL0iEIYYC9inMnX2WUxqirFpjgsg6OYBXPFhaPdaO1jkK1BXxTSoaBoxHt+ys2h/HDyiD5/sdIZRbp8YBqU6537mqal/TbfwXLoFkZcIuFVJQiG8f3Wy+kuAHGgHSoqmY21N2j8LJt37LjT/OM6AupsqrVch2NnSl33RCh8ao6wP9EAyXhjVs7pv2nb6zhKMWufJC0j5D1rOkEiDBkYsx3HCnpqPYhlOsTLp+/s2oB+OR3llMnCtk/0Wy0yHmFZN0ua+uOK3Lah2JSeMlJVjDV50Yed4SN9klc4ZX6OUDd7Yv6v/yBWmn6hwMoIzpbUpoQ6hmFLstLvxA2MI5W3uiJLTuYbL8GSUQI8Qrr29VGFHs3vCGLxAXd6DYCyq5Cu4HhtER5UQh5k+VRqyxMq5HbDN0LTA9GiS7vd4Mtcjnkir1XJV4uL3K30O6Hkdv7HQlW6pcfaGCBBkRSAdayK6LAJAFkpvXQiPv3OSUa/ctLdUhEhz6qn1q+gv9CdqpVmiX6bTD8JMCh/1DHAQKfk5q4RJce8hOTDySHNxQMsalDLJ+lNY1rTiNfiixUB/kCQuooiANQ1BspiYOLHcxvhr7BUop/fbcyt1o5WUYacO0EUWLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 12:47:10PM -0800, Andrew Morton wrote:
> On Wed, 10 Dec 2025 15:30:51 -0800 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:
> 
> > > The kernel config and materials to reproduce are available at:
> > > https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> > > 
> > 
> > Hmmm. This looks like a race condition tied to reclaim. I'm assuming
> > we fail to allocate a page and kick off kswapd. Then when we fall back
> > to the bulk allocator which tries to remove a pcp page at the same time as
> > kswapd tries to reclaim it. Maybe?
> > 
> > Does something like this fix it?
> 
> Concerned.  If pcp page removal is racing with kswapd reclaim then
> that's a problem.  Altering a caller so it doesn't tickle this bug
> doesn't fix the bug?

Agreed. I'll look into it. 

> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..0d1480723ddc 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	struct page *page;
> >  	int i;
> >  	unsigned int large_order = ilog2(nr_remaining);
> > -	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
> > +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
> >  
> >  	large_order = min(max_attempt_order, large_order);

