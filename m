Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CBECD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C78D6B00AF; Wed,  3 Jun 2026 16:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6776E6B00B0; Wed,  3 Jun 2026 16:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F7C6B00B1; Wed,  3 Jun 2026 16:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1156B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:09:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D49361632C6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:09:38 +0000 (UTC)
X-FDA: 84839691636.11.64E65A2
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id C5083C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:09:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jchv42uG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780517376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UXz52IyptNhzUMFPSnoxyMNWSpG1/iGAkBQWmQCJm4=;
	b=xp7KciMnEVAel9SkJL98Ban48a50iISPDK2n9ONsItGqfjCH3J38J0gYZGSHit5I0cE+bI
	GYTqUxZcNtBzmecB2zHYFDxt3CbXDtFRb3cKxPXKYmTz8p6R05Eigw0ByA9X2vy1dScxs2
	HI75TH6WTcelqWq5uGZ9zG0Rc76vQnU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jchv42uG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780517376;
	b=52UxI8xlZBYVWUGJPUnnpZ6TskMzsyj02GdXV36w3RIIRRoHKC+0BFd6g3nfxCxB2etC+g
	LvZo6uWEvcndT3dRMmGvmhEN3FzZ3x8dhhfJKOioVzmeDahHqRkI18GFAkk13VN1gp0nbm
	EuU5B8PijfQGxbE28QavLFgjhIsQp+8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso31492225e9.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 13:09:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780517375; cv=none;
        d=google.com; s=arc-20240605;
        b=WujiXwcy0Z5OTjdfWQmp8KKVwJgg9tJPOtbm1Yr4v/RXOp2qTF2IEdX7XmUpdetdIA
         8EwXwFU57rXrGSsMDvKxEt4ZaQLpQuLfWniqtt9x+9pAZj47GZ++0VwGXr/kTKt6WXzN
         PkxohIntOy1PeFV+VS93yOj37CXoJzp4ChrBebGF0INRKgnCma1mJu4TS70tJAWv8aUX
         nHpWMpEtB1pbLsOasRweZ/D6gDWSxxij6iFtckRid8s3ixKZCn8Bcm3ds+UB2TWZ0rsq
         Ik9DIeWqlTKlC+wPOF7jMp8wdIS6hxO26tIkyeqepxnziu0zbbfLb7pMDKqBi7qD846Y
         U08w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5UXz52IyptNhzUMFPSnoxyMNWSpG1/iGAkBQWmQCJm4=;
        fh=MjSOws/GzmoIwzQoSMVudHHCyWh8PSIZSCq6ouPYiJM=;
        b=FTgiVz+CEoexHHMm2ZepOfukNuxRTgg1nAUKGBykUpX+1LMZ9cBUCwE0ofSGxPdoId
         KpkeQ2RqI2bZFQHzTYA2Szbbf+N7Nn4x5sMI3iSgN9GRZlveYn7xFr++Z2wktX4M0V3A
         vYm7KYbVqADLSQ0+Wepk9scHTep4wOJ4HnF/KoEl+cU38PLxGGRxGBb1ybsRRpZdjT5F
         OjalqQRN2pNpSRuP3B4pjpx9L/1O+WpIIuoeGiX9lkcRng0uaR/miuLvSoT1veWQXXas
         psQVwc7zNkSPI8i5QqUCH/UvY50tzGS7z2m1f+rQ+0xgRQ0wxLdtTruCKBQDEgSInN0v
         yisA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780517375; x=1781122175; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UXz52IyptNhzUMFPSnoxyMNWSpG1/iGAkBQWmQCJm4=;
        b=jchv42uG3rd+1+OqB8rTy/rGSwlDr7Gp22OJUBTuWOtSjuG4lZzR3RLokZrGXoXIMM
         KnUPxxieFEkWGi31FwGFPr66I604JJ1ZyG99W7G5eFHOEckMqRvPlGR9L9kK2xRKqCAA
         IjsQIzZWYxARe7+XTKkGeg/S0Wx2cX5XIFM1lQBDXCUKddNtf4qATH0xzoriVfTg1bMw
         2MCsuHXhd7onCYG65opkR1wmNp8T1YZ9arhXGQ5xqNbLpqICJ2V/hjr/2IdfM7Ub6rYr
         Ro7fjjG/vCZM9wDAzXcs902aWgaoqXVZEGAE7RYR1jC3xHb4lIfbzbb0CKsMAzExEsSz
         zyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780517375; x=1781122175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5UXz52IyptNhzUMFPSnoxyMNWSpG1/iGAkBQWmQCJm4=;
        b=fjJrFs80VcU8gpcYv3aXAh28b4nAIMAY2CO50sp1cX1fqxPeoafbFElc7LnlEdgai5
         Cdgy259zS+EGBb79SSp6jdLHV1bP/kxrc8UHWxSLXXZfn51FXTsWt5Pa5MOz1kGq/igt
         DOIwRUyO61zyKvraZBD/7MGh839Rj2yDXLlB/6rtFSe8sx+HqpAajKd+EYYFJJibcALM
         7xcmdMneSVtJMagTpnV/KuKrGW1fCWlZi3XaZlmU2QSG6kkVTknuXPCwNMbVKXlUcWvE
         GK983DbdT8LRQZHRHWQoHenj/Yteu7PaUPDt7k55P7EqWQufSWzfFDVYv6mJn9Du6heX
         HMbg==
X-Forwarded-Encrypted: i=1; AFNElJ+VgDlyzAz4EI7bMbeOCrfzOpbGR9Padd0yxVEQ6tpIZedXEFgWwQTrcPsaomcRdXZA/4OR0lTZ0w==@kvack.org
X-Gm-Message-State: AOJu0YyjTKkroFCzaCP550DPrs9lxsYomnepz88c0QPcMnE80ujLYDjH
	hz/bNXDWie4FxarM4maX0rtabVV25dfuuC358D8NXOa1Q1IpxRjmB3mcmPlQpcEDdiK+AorHw7U
	eAKChBSenMdc6MCwIGTQLR/5bjlT1bZE=
X-Gm-Gg: Acq92OFDfi4k+ccWzPlE/G99I/5EWyZN4cgTducRYNkqROqFjPMWQKIdh1k9/vJyj5Q
	+YOdpDTzrpRe+653ULQxL8fnneKjtxkyRdmtsHjcEcyWLj7x2VTnDLzs6PB3nPRvZDOp4/CsN7L
	EtKmSn3byI2+C1wGc7uLMboyvsUjiIM6Egj/CjxxEx8Hl6ooABkFjhaorm4cuz46oacyGyPd70g
	8CUPQZJJPGshrXHHCgOExPsl5JHBF68sSncyoQGtjpq34tLLH7nzHQPaPO5jRQEJ5frhvYAXlxL
	uf9q1mqlYoX6nQtii1ga/iM5fj4j6j+Nasne9covQ49O11jhOQ==
X-Received: by 2002:a05:600c:4fcc:b0:490:59cc:999f with SMTP id
 5b1f17b1804b1-490b5ea1016mr84902405e9.4.1780517375148; Wed, 03 Jun 2026
 13:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
 <aiB2sHqxcBAJrTkP@google.com> <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
 <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
In-Reply-To: <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 13:09:23 -0700
X-Gm-Features: AVHnY4JWxeOICXM6CH91NR0yRjpkfQjVY9j65WnUJqukjOXglYl_lhKm7GRZ5q4
Message-ID: <CAKEwX=M7zH=+83xeOnZcrHKt4jCo6hCB3qVLqWpfLquMcRbyUQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Yosry Ahmed <yosry@kernel.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5083C000E
X-Stat-Signature: 1yw7bdeu3dewrrrdh3prhxaihnmrha8d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780517376-64741
X-HE-Meta: U2FsdGVkX18xnSxAwIcdbHJjLUGgkUkdoc5uGu0n0o1v3+naaE68lqRmm/d4Naag/rSrNhl+RR/TVGcGMEjtk7TZ1PnW/o6C+Hi/BAxqT9ELWD9xjz2o+N4u3KST575HLiNsWs+CMul9Da8O62AF+Ilm1OTEhYeQjdpuG5fZpdokMmLUq8s9fi4GVvhk4MWM5v01Ap04/bPLWug/iJI7D2ThULItkGf4P5UsiuPmVf3j1afT9V7c/C1xeSK0SrvqSwuFKg9BgzCO+NRVso0zVp4n9+EwPEkz/7fezhGt4WMp2UyH+bYi1MiKJ6G6NsUsI7wadvseFfvD1eXJbjxsylm4acE9M7nssy/ylMpC4tUg9QcK/3LzOzLZ6J/ZYi1iUeMK5IK64BeG91YexXyK8JuMsNpxUqDZQoitgLyvxu8D8JI5EKCf7gphKk07UcoUG/k2HiIdpxz/Q+CFYAI6F9ACUZnl1AGdklh3kMqRajy13mm/MBACDWAqFYYujGOesw+FsPLiY3uWZ4foZL4qPp2mIV0TUVF15u177qwMsLysO/zcqgd86MwKpY0l3rRijxgUbfrVTRkEJvKTSvjotmckzfQEdBb5ecZrZCYQgW/5yc3Z0F1w187F0GbvSp0hjrjK/Zzk3kJlQE0ND5Z/gioxgNwWDSaGvo4FVRXydxm0VGWBnCTRlj0zdVtPzabf3wU15YiA9eF7E2DX+T63EtTlxWhobBk5jkjDkvSbzVdFm8LE4vYwUUyKtzmgD+vvcK8HHAf161CAYsEBv7Jxv4JbnNJb1y2tUJ8KFKt961XpqotLXeg6T/U29LYLUoJWDf+PFqJlX8ezGfRGgZ08sWWrXBtshdED5SQTqtzGjxpe/fnWTlTYEwwqaE7ak17/8UstuHjsN/I7TOk0fsHRzj5zFQvPW31pFOuglbbgK3gCyZAq3cVUdajkvaDS11XXxCR7y3eMIlGfkMvHquf
 9zAw+fWY
 SpAMtvjW+aJ3d+Gm3IChYgrKw62rc1Jto3dmn0RJ7oROaJ5mjMRKWzJKl/yRRqfOtGnx7VdV07I9yep5pJWxi8K4VlyPp/t8gSk+a0A4z3pskzuCRvVVPZuJmhHgMH6bqnOZCG5zc1WSlfI5Wk1aXrVnyMErJHRYsXfBHj/+6fyqSnmfqf8p5Bf+a0iXzudPIFea0ClOkB672HPHxTEWABzQHLiARWpN2zLWChGlmpjmhlTJYvSWQK3kzRw6IH/Lrqsvjzv/9fsN/u9dB1OXdGCbGldXwl9gNBEM/ORYqxEF2sY3vVrQcI57k86a4j3rfcilug36zkAwYWjoVNgUBGVDL4MMOCxwkIKI73GK+tijkRy7DXCRrOTOvRyuHcoOYd17EDlQKToKCGbqAXAYYUdkxT2xYVLatrT+98Q98qKmjDIeFZ1zPQnyLvgD0YVKZ7pJtCtMu3Ef7LszVBTZ+ZDQzR2Uh4YQwzCZoWesYSVMRtl4Io1qDb2ahP7eTYsXJI5eGqXi1PkGTanQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 12:35=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > All that being said, perhaps I am too out of touch with the code =
to
> > > > > realize it's simply not possible.
> > > > >
> > > > > Honestly, if the main reason we can't have a single swap table fo=
r vswap
> > > > > is saving 8 bytes on the reverse mapping, it sounds like a weak-i=
sh
> > > > > argument, even if we can't optimize the reverse mapping away. But=
 maybe
> > > > > I am also out of touch with RAM prices :)
> > > >
> > > > In terms of the space overhead I do agree, FWIW :)
> > > >
> > > > I think the other concern is the indirection overhead with going
> > > > through the xarray for every swap operation, hence the per-CPU vswa=
p
> > > > cluster lookup caching idea:
> > > >
> > > > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail=
.com/
> > >
> > > Right, but we should already avoid the xarray with the swap table
> > > design, right? We just have one swap table pointing to another
> > > essentially?
> >
> > Hmmm, I don't quite follow your suggestion here.
> >
> > For normal swap devices, we organize the space into clusters, and
> > maintain them in various lists (free, nonfull, full etc.). The only
> > difference with a vswap device is we do not have a free list, and have
> > the clusters themselves dynamically allocated.
> >
> > If we're using vswap, we will incur the xarray overhead. There's no
> > avoiding that if we want a dynamic indirection layer. We can of course
> > revisit this data structure design later.
> >
> > So yes, it will be one swap table (vswap cluster) pointing to another
> > swap table (pswap cluster). But to get to the first swap table, you
> > will have to go through xarray still.
>
> Why the xarray? Don't page tables (and shmem page cache) just point
> directly to the vswap entry the same way they point to swap entries
> today?
>
> *looks at the code*
>
> Oh, it's to find the actual cluster because the vswap file can be
> sparse? Hmm yeah I guess we can revisit the data structure here later,

Less sparsity, and more dynamicity :) It might be dense for all we
know - we just don't really know (or want to figure out) the size
statically.

> but IIRC xarrays aren't particularly good for sparse data. Maybe it's
> usually not sprase in practice.
>
> Maybe a maple tree? :)

Maybe :)

>
> > > > If folks like it, what I can do is have CONFIG_ZSWAP depends on
> > > > CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :=
)
> > > > Then, on the swap allocation side, if vswap allocation fail and zsw=
ap
> > > > writeback is disabled, we can error out early.
> > >
> > > Hmm maybe we can keep it around for now and do that after vswap
> > > stabilizes? It ultimately depend on how much complexity we maintain b=
y
> > > allowing both.
> > >
> > > I think another problem is 32-bit, technically zswap can be used on
> > > 32-bit now, right? So vswap not supporitng 32-bit is a problem.
> >
> > Ah shoot I forgot about that. Hmmm.
> >
> > It's not impossible to make vswap support 32-bit. I did that for v6
> > after all. It just needs extra fields because we have fewer bits to
> > leverage in pointers etc., complicating the logic a bit. Follow-up
> > work? :)
>
> Yeah we can do that, but it's a blocker for zswap only using vswap.

Yeah we can table that. FWIW, if you enable vswap, then zswap should
go through vswap already. It's just code complexity (hopefully for a
short while).

>
> > > General question (for both zswap and general swap code), would a boot
> > > param make implementation simpler? Right now we seem to key off the s=
wap
> > > device having the "vswap" flag, would it help if it was a runtime
> > > constant?
> >
> > Hmmm, even if it's a runtime constant, both branches still have to be
> > there, no? Does the boot param simplify it somehow?
>
> Maybe it doesn't simplify the code, but if the branching causes
> performance overhead we can use static keys. I guess we can still use
> static keys per-swapfile, but it would be more complicated.
>
> Anyway, not super important now.

Ahhh I see what you mean. Yeah we can optimize this later.

