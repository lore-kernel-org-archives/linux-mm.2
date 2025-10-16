Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94755CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44A68E0020; Thu, 16 Oct 2025 07:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5558E0003; Thu, 16 Oct 2025 07:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0AFE8E0020; Thu, 16 Oct 2025 07:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE3DD8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:48:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76C5DC027B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:48:17 +0000 (UTC)
X-FDA: 84003804234.23.08ED587
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76DFD20003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:48:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZUVNTOY;
	spf=pass (imf03.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760615295; a=rsa-sha256;
	cv=none;
	b=L+lA6nshLOzIdmUmkNpJHsIhhHpPc9OWjwf99H33LyB0IiVD7s8oqiEWfFKl2JMpJuCvYe
	YXYY8C2av4YHaq3fKjVrtXkoDO8L6KxrRVYh+4XbFzwIbGXi7f27H95swYBXtdk/WnKwDW
	ukoxnVh47XylpPhCOUARGjE7LeizgwY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZUVNTOY;
	spf=pass (imf03.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760615295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbfblspUf1NHvFa8rqaPO/OBh7bIieHqwYUbGcwqhUY=;
	b=mjTrJoT7+K1/YjtS7hoErQP0dNEZxhDlpjO40poJ1QNZbuxAoxZklWraq87oslZAwHuEbK
	cbRDlCUuDF9+ojeU7czgGdvGiAUh3Y+Gozbje3mClposMR1SVJBJFzl7BiBJAEl3HMGl7V
	JnR3ltQCOJk01CBdcqLws8zGBBhcSHo=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b00a9989633so122886566b.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760615294; x=1761220094; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbfblspUf1NHvFa8rqaPO/OBh7bIieHqwYUbGcwqhUY=;
        b=RZUVNTOYRQlejJ+i5nNfugWbAIVQDMoUjVKDEv6ZcnKwv0oda9SkyZySzi1/7pWi8J
         oxQgkadYkV6EDFb70KQR4fvkl5J//S36fQj+4RsBYAuPQL7Q6KCifowvv3cnzKpMf6mS
         5a9oLH3m+YrBueKurMIgKNIiEPMfWyZ5hjfiSTUW+oR5YW2IPF21qtMG9ahM2bi7q646
         ByysOc0xdjreNVPqIyb+tYr6z61o9dDVUBA/rr8K0qUZXvVv8AQGUlCfniT1xnxYKAVX
         2OwckUwPOD27T7v6MImFCSWDcOw+wq9EawFYTLL8DtNidmQS9l4NfIiNbbiVyAP02j7e
         HfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615294; x=1761220094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbfblspUf1NHvFa8rqaPO/OBh7bIieHqwYUbGcwqhUY=;
        b=rh3b9Us6zZ3V3go9ULUZcP1gA/ZAbk0rvTRQSkj4gJMjcRFKjO6AEPC8V8rl6gy3FY
         RX6177qKhLNP4sgP6csmv6wvGmWuk9wHM/hhcIM0bnDx2Tbde/0bh9s7oOA2who6nLNo
         mJjLvxSs7FCXeUsedr7CFf7EUlaHY8lZruiDHDn/doVwSkB/26E/cCxCH9o4ftJoz+Ez
         9gkittnLn2rElEYPOn30yfnehL28bKw6m337MJVLgvhvaC+9DPx4PLipnz3BsPL92DVH
         Hze8wMKsIBhJCr8hVnSkLag+ARPI27I5D0QxMh0hLR3z2CIkeloqbkfPm+7x1sXU8nfe
         HwEg==
X-Forwarded-Encrypted: i=1; AJvYcCXCbzN5HlNKAfYHFkx6BygKT2ztw+QM7rKtw6HY5ZSsNtyO55/hFh8YxZqpljcLz3pslu/ccT6OGA==@kvack.org
X-Gm-Message-State: AOJu0YyFN4rDpDKU2naP5fSaBMAv7LyBFOQ5RY2u8lOwHvwfQYyOx+Q1
	BipdyYsozAYub8tjr0aZUYXoa09bgRkFoLS49UcYokZhCCEhgDaM4MuQqx9470Qx08ocwwjVEuC
	SRFEZ53ZnYE2mpRhGWAinQZnPYIB05J8=
X-Gm-Gg: ASbGncsHdaNAXxPgHHwhpvqJvuPQRzBWXq5388Ab3uyL3AdvrscPLRyQ4BVabkGN7z+
	Ubb7EGHcy/b7PHrA2rN9e1Yf4wqJh2XbQKJMppo4w02HHX/BlNeFs9wl7HLrFjf4VTkGbZkq2tJ
	gjFF5hD4zS06jEFRmKuI7aOBraA6WMgJP1YQOvXK0dahzcbewi0dYz/Ba7ya2hZ4uMeVOTgEZzW
	a+NgBRfqMwGui0Gn627dShydGpwkxD+ejZyCaawPOrCmwJOvBMzgp9VpSRsWJuczL6Hqki+hpGj
	fXaWc49e
X-Google-Smtp-Source: AGHT+IGcC+rv81VWhZTcZBUgRu0dX8VfUzA2nML1FlKIlGwDvZnd5mmYfiM+F+OaoWEvfM+30LqIrY79KpIOMbvrCOM=
X-Received: by 2002:a17:906:ba85:b0:b3d:d30b:39c0 with SMTP id
 a640c23a62f3a-b605430adffmr404516466b.21.1760615293429; Thu, 16 Oct 2025
 04:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250910144653.212066-1-bharata@amd.com> <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F> <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com> <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <aNVUj0s30rrXEh4C@gourry-fedora-PF4VCD3F>
In-Reply-To: <aNVUj0s30rrXEh4C@gourry-fedora-PF4VCD3F>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 16 Oct 2025 13:48:00 +0200
X-Gm-Features: AS18NWDJVaOLg3sD89oqQ0S3zxcwWAIbzuo4fkT0WRZGgszNkjVK1a-hVthyEu8
Message-ID: <CAOi6=wTXSTgTB+KUpn+LOUGvXg4UeEz-DN0mh-LjChn3g8YiHA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
To: Gregory Price <gourry@gourry.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, Wei Xu <weixugc@google.com>, 
	David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@techsingularity.net, 
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com, 
	riel@surriel.com, sj@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com, 
	Adam Manzanares <a.manzanares@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: thy7j5oi7nee75qx1q5h66x53ded3sui
X-Rspamd-Queue-Id: 76DFD20003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760615295-718163
X-HE-Meta: U2FsdGVkX19CrhU0hc1ADooxQu+ykqNC5ZAYhthdf35JXkzCZSsLc+qS2boeTZf9YZOzdWNA7GPYHSI5GsWYGmPdMJLCshPHgeLHMK3HzY6HU+JgsMK2yfK6Pw8OylLEZjWky014cx0053FbSldbGLbGXhlTNKLGnJ+bW78T67zweCZRUBsZn25xvIIKtVdp1nd87EYz3MFz9jWrAzeld2KKch3t6KfpnqcQlUsy3jP4y/T/zWGuE66QTQsg98qLYSkX/DSp6VjcuoCRRZR2relfHfBHrk+j5nLAHzeEXxteCPSs8PbkNxSwlV7rwkNHf59aBsL1p/wxAuYcPnCZboo/AI8yczgUNU1q+DUdtYEcyVsuau5CaYp62dt2c7zjaGZOnceTE4D1HbLJz0YVjsif0U8YLWVFcdOGOSp8VMTasRpRsOG7wjWrwydzVexVYE7qUzATCShVyWDmWMTYD/OEGnubgMh/L0lerdO5JoM2wPx1jlQ0RAXG7A2or0VOARsG965p/rDnmTmIkIuF6zdvKeoXY2Xj3kakcwxG6srlJL/KA377b7OJ7/tnnNCzEC12pnlrlHx4DOasf8+N7f8PZe3cDHVaeaRsInXE1yg5umdOy8VpTQpTr0yiG+Dk1/2RcH6EluLVa5qX9aWp8A4kOLQwYH1TRfi7ooibCn+7NDPB6Rf6bD0IVBSOkmwsuUEg4iSyY/iRLNL2JdfkobqATTpwFXbSBlqXm8042ltAJyVObMki/I8aoSqfRSVRqdq7toK4sHIgwsuQurofMjhuJ3G8IsdqE5/yL4oy9U0ANxTFlJbeCj75Q4A+/bh7uWwm3OznSCvsq5fw3hGsxl6et5QceKY8Zh1XEy/1dGf5tGc9elYCArIOYOxhmYmjZKDOiX3leVMgfOajm6F0cI7PIcXg/yL0YMPVm1Rf3mZUnx49ZKQ4A/SloThYIiS6A0tJUKBo4UV54Y1surN
 Uy8YC3Z8
 f61Z4Z0DzXtbGFFHsFapdeGwEdADQth7qtmjKA4ue+bIz2yqDKb6vAfNMMPc2K9x02Tz0QQKIzNmRtik8hRjqT1+KTG1vTbAdjGZtojbvdhQio9SCTIrFDD90y7KYBC5FoJBlSFblCKhLz3uxglI2xElodgtNTnnqwQe8YBZvZJqYOO1f7C5oZGk7ZfNp+3pg2OVcWbh5vyUsOVSe79fsTWQ2gy35/j4aggbYw+lbVOI2/wS81Jd/CkJ+IY+syM/SaBs6eIXwze/5CTNCZx7Vi9fb7GHa+sUCt+kS2o9L6YlqAeZxbdIcDZRc3DtVmlzz8/lBpqafHgOcCQMB4Yz6UlOoNLT3VnL+cmn26pF/wIEwiH69ue1l4eBsyO8E9RWkROuV88iQYGhf4j8LpxrzwaH5crLurQayU4TzVrvuSVo5SlGUEJwWBUWbC0wQyrahsnVM9sGYmNO+2YPubS0bud4hXMkKQDzdmG3MxSd2m9QSd0jd1udsJWLAuxNKwuKDN3e9/KYMHvRBK+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,

Thanks for all the feedback. I am finally getting some time to come
back to this.

On Thu, Sep 25, 2025 at 4:41=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Thu, Sep 25, 2025 at 04:03:46PM +0200, Yiannis Nikolakopoulos wrote:
> > >
> > > For the hardware compression devices how are you dealing with capacit=
y variation
> > > / overcommit?
> ...
> > What is different from standard tiering is that the control plane is
> > checked on demotion to make sure there is still capacity left. If not, =
the
> > demotion fails. While this seems stable so far, a missing piece is to
> > ensure that this tier is mainly written by demotions and not arbitrary =
kernel
> > allocations (at least as a starting point). I want to explore how mempo=
licies
> > can help there, or something of the sort that Gregory described.
> >
>
> Writing back the description as i understand it:
>
> 1) The intent is to only have this memory allocable via demotion
>    (i.e. no fault or direct allocation from userland possible)
Yes that is what looks to me like the "safe" way to begin with. In
theory you could have userland apps/middleware that is aware of this
memory and its quirks and are ok to use it but I guess we can leave
that for later and it feels like it could be provided by a separate
driver.
>
> 2) The intent is to still have this memory accessible directly (DMA),
>    while compressed, not trigger a fault/promotion on access
>    (i.e. no zswap faults)
Correct. One of the big advantages of CXL.mem is the cache-line access
granularity and our customers don't want to lose that.
>
> 3) The intent is to have an external monitoring software handle
>    outrunning run-away decompression/hotness by promoting that data.
External is not strictly necessary. E.g. it could be an additional
source of input to the kpromote/kmigrate solution.
>
> So basically we want a zswap-like interface for allocation, but to
If by "zswap-like interface" you mean something that can reject the
demote (or store according to the zswap semantics) then yes.
I just want to be careful when comparing with zswap.
> retain the `struct page` in page tables such that no faults are incurred
> on access.  Then if the page becomes hot, depend on some kind of HMU
> tiering system to get it off the device.
Correct.
>
> I think we all understand there's some bear we have to outrun to deal
> with problem #3 - and many of us are skeptical that the bear won't catch
> up with our pants down.  Let's ignore this for the moment.
Agreed.
>
> If such a device's memory is added to the default page allocator, then
> the question becomes one of *isolation* - such that the kernel will
> provide some "Capital-G Guarantee" that certain NUMA nodes will NEVER
> be used except under very explicit scenarios.
>
> There are only 3 mechanisms with which to restrict this (presently):
>
> 1) ZONE membership (to disallow GFP_KERNEL)
> 2) cgroups->cpusets->mems_allowed
> 3) task/vma mempolicy
> (obvious #4: Don't put it in the default page allocator)
>
> cpusets and mempolicy are not sufficient to provide full isolation
> - cgroups have the opposite hierarchical relationship than desired.
>   The parent cgroup will lock out all children cgroups from using nodes
>   not present in the parent mems_allowed. e.g. if you lock out access
>   from the root cgroup, no cgroup on the entire system is eligible to
>   allocate the memory.  If you don't lock out the root cgroup - any root
>   cgroup task is eligible.  This isn't tractible.
>
> - task/vma mempolicy gets ignored in many cases and is closer to a
>   suggestion than enforcible.  It's also subject to rebinding as a
>   task's cgroups.cpuset.mems_allowed changes.
>
> I haven't read up enough on ZONE_DEVICE to understand the implications
> of membership there, but have you explored this as an option?  I don't
> see the work i'm doing intersecting well with your efforts - except
> maybe on the vmscan.c work around allocation on demotion.
Thanks for the very helpful breakdown. Your take on #2 & #3 seems
reasonable. About #1, I've skimmed through the rest of the thread and
I'll continue addressing your responses there.

Yiannis
>
> The work i'm doing is more aligned with - hey, filesystems are a global
> resource, why are we using cgroup/task/vma policies to dictate whether a
> filesystem's cache is eligible to land in remote nodes? i.e. drawing
> better boundaries and controls around what can land in some set of
> remote nodes "by default".  You're looking for *strong isolation*
> controls, which implies a different kind of allocator interface.
>
> ~Gregory

