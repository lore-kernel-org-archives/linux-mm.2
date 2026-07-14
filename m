Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BF0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55EA36B0093; Tue, 14 Jul 2026 16:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8B96B0095; Tue, 14 Jul 2026 16:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2DA6B0096; Tue, 14 Jul 2026 16:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0815D6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:52:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 905711A051E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:52:29 +0000 (UTC)
X-FDA: 84988580418.24.83AEA16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B8C062000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:52:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LojGFe5a;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784062347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTqi3alAZsmClmkp2BKQHhwiYigUfhN2a2XtbcHcncw=;
	b=5dVtA6hxVa2CjptkwKM4oi6kFe+Be9W+l3wWcMmyUka2J5WoR+3W/ddomkrg33OwaW6o5a
	LvsIVkDOc55AlS/ycJ2Kr+YSbnxiDkG/cUJoSs0vcRfoc6q14quhCk0wJjvE4SaV5InDcZ
	bVz+xzddsjsDRPOsnZedmeE1+FWKgYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784062347;
	b=aituVmA943IfzgU2OAhfWYd/EL7qqKAl7cNUoi+6bQt32+TVtFMYFEs/0mHM4c+3nj1jnz
	OuK43t4oqns6g6s0Ns9kAGcYWXTBZEXV8BotoQ/LQyEFvC8T6VQCQ++001I2/ZbarVWSrT
	YfFmSFW7i7q+AC3Zd2+bhDWR/ADzQKg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LojGFe5a;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27F32601D9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53811F00A3A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784062346;
	bh=iTqi3alAZsmClmkp2BKQHhwiYigUfhN2a2XtbcHcncw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LojGFe5aBgMbCn0entPMrDRIK+MvJJ1bB33pHkwkvWHhC2Nphio6l2ttvWlScTOmb
	 LxaHkMHcUGpLGi0sTicdWt0B1Bx/H7zlW0JdKgI3DXuXjaHkhq0Xy9pCmLiZ63Oti2
	 ARjvDUBvsLTAgz2GKWJp6nSLErYQqejnt2QmlJsgToBWImM6vLOfKGI+Wjo2YzqtSM
	 mJXM0UUxDjrtnZNsFjVs/5GOI+TJrswQirIbl4E/WtCFczL3aPbUmCRwb5meUO0xbO
	 BuTPRafv5bsDr0SZAYJ6LmTbX3ezoeZs3aboSxmbX0jtNJsthvZ1X0ofwuR1EeBSBy
	 R1/FC6i7DLTmg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-698beff7178so8070412a12.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpBAnYE2Qb/zSTkjZS+Igf8GMaepA9MG5cDV3eMOv5f/iE5syF6iYwHHFcTpnNPVNCc74KmPchlpw==@kvack.org
X-Gm-Message-State: AOJu0YxJ2kuompifOYS3/pHvnuOVdUK408X0uMFZjQh+/bEANK9o939A
	yXWrrBn+pmEAm5OqVWWzbYnOjGe5ond0hVmVouIZmDpEKEmFuVmnXOh+MHdqmxDQKJ0L3nf3PdR
	dASxsdf8Fwy0v/9/sLIA8JJzR5PD/jww=
X-Received: by 2002:a17:906:9fce:b0:c12:34ec:ad1c with SMTP id
 a640c23a62f3a-c1679367183mr21088566b.56.1784062345755; Tue, 14 Jul 2026
 13:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
In-Reply-To: <alae-LIRwEFUjgs1@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 14 Jul 2026 13:52:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
X-Gm-Features: AUfX_mzvYPO0I-kzUXbogAiHLzr_xtUWxhzL5KSspLm9Ule6jCBXezY4eupVLjk
Message-ID: <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8C062000B
X-Stat-Signature: rirc9j66sebejy11rcwbxxtjrf718wmp
X-HE-Tag: 1784062347-279330
X-HE-Meta: U2FsdGVkX1/Pmlb1+mF3GEPIA/egJxsXV+HsEQBKNRbJJ1+2LES7fpXNNQmC5AZyVf5iqnhv7G8M7E1NEZy2bfLd5ZoBnaDlYc52ReALBTvP77Re8s4bDetz1GKpfyEY6Nft9l57JHnxDvIYBOBXy5pFbo++N3sJpmVabN8B1vi+tD5vWcdtoxaRNSkwWgtpNBhprHqq6ARCrGoxAtZa7YunFjNwdm2miaEnKpNvN3KH5p1kUjbJwtRe2uI+p/s7ROXxjl6oGYkvsCcwMJq0u1c83vboh2oiqDwPZTkTB/my+I00x5Zen8u+5958nCL1xhXqrtXJ361BVvS4XLNyDYSFLoS3jIMSOufbXREqB1s8rVbcKmes536nmhf+KNaH+AYvvzr17c9lAqfFaGIQ/UosYxRlI4r/Fx+d2IxHg19aNL69qCNiK+SkOskDo7HClvY8SxfPgkhDK69uZ832AVYSRAyBdjSUKA+5YrAeYSH6gLvHnws4YZRYJJ5hCA5qOrdcPP5q8ghzfyFjXXHoROD11hdrgoW78cE78txAvVdPDaSW4BBbD6UZBZtAytsIszcMcxMyqJmulSlMAZl2jd+6+T55TKdA8+/9Z/MQxMyLn9CJUCjXn2ywiHxO4rIdvuQKW8iKD97wRqe0O12zVjv9lA03MOBUuY04gwHBc2ZNKK3KvBBJUI2mClQHIW+ihFuQ5zPPqCrwBTeCUBUIo2+6UK1zJA1tCdMp1PlWSSJmwP6dmwdgmpEUU8GdOQypiFtx6QwiQtGHO1mzD9RAB3uDjx2T0PzsqwEV2iHzg8UHEryDRIqOn6mG7w6i/PHyFz55hl1R6ncTCd7jp4IDqZLzrF9BpJHtABaxhLe4cOWpPrjkSbnwPckfzAhJSL+rNFDgjjhHz3gfTFr0PQ8Hu6haEz38vmtpUC9i4A+gOFPwLkqg+WPeNB23+DpMplkVQs+H2VyUT6fZ06SylIF
 8SsPiKxR
 antZbirfTMqHu75ro5dwEcY04monaqdS0U1RzD1CyD/hipyTLFK4UEetp2TGGx8VQI84csYWRXilq9/tvbCeLq4tvqYP79t7c2t83/IObKaiXFq/wkZ2i9Ij0zlKRDEAbN2w9iE1ATYOly64TtG55OzKslR8jnRq7zyn1sVFb9hU89TGYKmIow50bWfQkvWsGpq4EIV8/cS0ohkBR8gtAP/OTISzlJEQTosatfunznu6+dEk1XSpclWJtVHLmat0jXCwrTB4UGGOSK1DWiU/o0F2IgHd9LrjctA4P+NeVzLa/Il3DhmSnTUUtv/XkkzcTC6OOaavhS1J9tCN1nbQBcTVORUykwXM7SDyqlzB6YfsymlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > >
> > > > Hello Yosry!
> > > >
> > > > This series does not cover zswap as a tier yet.
> > > >
> > > > My plan is to land the swap tier infrastructure together with the
> > > > first use case (cgroup-based swap control) first, and then follow
> > > > up with zswap tier support in a subsequent series, continuing the
> > > > discussions we've had above.
> > > > (I mentioned on cover letter, right above the overview section)
> > > >
> > > > Does that approach sound reasonable to you?
> > >
> > > How does swap tiering work with zswap in the current series? I assume
> > > zswap is just enabled for all devices in all tiers?
> >
> > Yes, that's correct.
> >
> > > I wonder if introducing zswap as a tier after the fact changes user-visible
> > > behavior. I guess if zswap will be introduced with a default "max"
> > > value it will more-or-less be the same behavior,
> >
> > Right, that's the plan.
> >
> > > but I would check all
> > > user-visible behaviors related to zswap (e.g. interaction with other
> > > zswap interfaces) to make sure nothing breaks or changes in a
> > > meaningful way when zswap is introduced as a tier later.
> >
> > Fair point. Let me review this more and get back to you!
>
> Please do report back what you find.
>
> Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> requirements for that?

From zswap's perspective, we just need to skip zswap is zswap as a
tier is disallowed. Could just be a check in zswap_store() similar to
the check if zswap is enabled. I am assuming that if a swap tier is
disabled, nothing happens to the existing swapped out pages in this
tier, but new pages do not get swapped out to it. This is the same
behavior that happens if zswap is disabled at runtime.

From the tiering perspective, we need to accept "zswap" as a possible
tier, or maybe creating it as a tier by default if zswap is configured
would be better to avoid handling the case where the user doesn't
create a tier for zswap. We also need to disallow zswap being the only
tier as that combination cannot work without vswap.

I think this should be enough to support "zswap" as a tier and allow
disabling/enabling zswap per-memcg (or globally?) through tiering.

In the future, if/when swap demotion is added, we need to figure out
how that would work with zswap. For example, if pages should go to
swap device A then swap device B, then an entry in zswap using a swap
slot in device B should not skip device A and be written back directly
to B. vswap would naturally give us a solution for this problem.

> If that is not too much, we can make that part of this series.

Yeah I think it's better if we agree on the design and zswap support
before landing partial support.

