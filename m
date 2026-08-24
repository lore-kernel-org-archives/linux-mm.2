Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DF9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76216B008C; Mon, 24 Aug 2026 11:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C270C6B0092; Mon, 24 Aug 2026 11:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEECD6B0095; Mon, 24 Aug 2026 11:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8181F6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:09:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C2841C0223
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:09:43 +0000 (UTC)
X-FDA: 85136497446.27.147FF0B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21C7140007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:09:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWb1zcl1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCITwuJY/5I+fZvxebAJG0MATII2H/0d6uwBA3oASW8=;
	b=IHW3/3TSwd+dAo2SyzHfhAkslatBPs4goRfMGnzEXYUDyG3gK6gQdaTeSPa/br/JgeDlbK
	hOfUmQce9wxvZw/tKNS1ESmPRJXJxnn+FrN5P27nlyyYT/8dEyT8tBVol8ISHD+WCU7u9M
	lMNBg9YYPO1QUsd0z0cLm1Oj+jRjwjI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWb1zcl1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787584181;
	b=dQ8RQpiNpG9/vFS86BwP+NZHbp74FNKKanmYZIr3FVES82jtcMAgSpYrEgG08nCEYYrbgy
	O4S3Vu1jr+Z4HZpu1d6RULYDz7B9RUtlVhq89I9xNtyQYVZC2Za92SbfwmrT3X55qn0XFJ
	WQRdNrbWlzqOyU1mMxb0z2tKHZ3eHmU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4980dc26022so24919445e9.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787584179; cv=none;
        d=google.com; s=arc-20260327;
        b=brnpruYxXeBG2v0IjgIUgEr5qFw+tT/JrbxgA/MqVlbHEIhzqg+39b4iUQZ7vpgLsz
         ipXgv0t/jY8Sv2ZONq5C2Hv18XVleBHFhpYPip/cdo1W2HXYnybnHzFODTsmN3hLvDYc
         hqitRqTrgvUbWFTpuMGTvM4QaMJpZT+MZMASnhx2wWOcxMPmT53VJzsoqdyJRPk7HkrR
         OEZtraK+I2YMQqeB7Snxg5o5wMkP4OVdpzSHx80o1EGo959tMjWy91q2liVBw7vEANz6
         S30gyL9UTLNc9lLc/5HuJcdYch7YZmVWS6Jx5YG6Q5C4jbxbxM187ER2jbcLrFbFNH8z
         3PnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xCITwuJY/5I+fZvxebAJG0MATII2H/0d6uwBA3oASW8=;
        fh=KYUKJ7BhPwsc7nrmOLIty4AdK/oZNhRHG/WYJK/QswY=;
        b=WZuzWSmcnHdcHDkZ5WAubIGqx8PrHSnc1THX1e0RRu62nggOC7RCXVmyiMzvxqTOnU
         srCaWfR8UaorwXm0RUoPI3xRfgk5bYEYUWrQnnFSc1ZJRMaQwrijYXhPTsnC/Tp8vV2D
         g0iL8TGmCyWxwaVxVkQFipzWFuA3sS2mO0YH8IJ1oDdBZOeP5n2uacOMoe1sqQYH72zs
         P20982s/CMe8F16123JpOg3weHiR4WVVggUomrcgw07EdoTJlBQyZBK2koL1eCUZ0Vqt
         irwfOhd4jy8c5N8+e96RqqipBcQcfM+yEUC9y9blasFSAyznZdqLltLlYYmwYc0FC5xq
         dvQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787584179; x=1788188979; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xCITwuJY/5I+fZvxebAJG0MATII2H/0d6uwBA3oASW8=;
        b=NWb1zcl1CdxsUyLQ8RS/wkGbpkvKGWbbiA6ai04ylBwcEMVcN2Q430/48a3dfUoW6r
         2K5NgoZNLJNdW+5ZcY8CPWFL1MIxeYFobft0NLTsDMqeK8Lm9UlhcQtQzQtctAyL2jK+
         Sh+890jYvcrmOU3ypxMKyA/CJSW700Wztgms1CuEqiZP+XO0EuXfVcWKCTabwpJMR0c8
         rZWMv4nUgLUENfVJtuMJVRa58JEteeYT8+OCidgBQm/8pGk53JjBHkUgdIx4ktWP5iZn
         0SfFhGXLqlWRpkjf4CGDpdWWm4Yip3RB9fkW+NO4x7M97ohLl2yo8mkFUwCq7Atiwpdt
         UD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787584179; x=1788188979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xCITwuJY/5I+fZvxebAJG0MATII2H/0d6uwBA3oASW8=;
        b=XJ9GgLzdphRKqBTapnLMOXHVIzTyG1rpSrGsgtIt23+V+5Kj9KEBsQ9lSGMDCXTy6l
         hoi5sAIEBpXpIQic7CdExyT6ZwO42FiwgEyChiOkOSElAmjor1hTRG7lxbD3ye+YISbh
         u7tyhGIig2/bhmAfKTSHZeuA+4bVyPIqG3SlFdQd08EbUeB/DVVgH8uf6dMqBSpDQx0o
         /iLMtxmJRYFiFkk/O5T1pdaUaQh/ZuuAXv6f2OyME/kSPkYuqISNL3WSSSOO5O0cnwUH
         jNJZ+Jsi+SGXv0En+pz8HChyDVnBjzuty+K++UfhvuH39VXqBR6MmiFx0IME0vYJXNHx
         kalA==
X-Forwarded-Encrypted: i=1; AHgh+Rqj9hH9m24kN+Wr/vyk+kDUcutZ6tP6+y0bij0XLCT/3U7+gmZBIo0sgA0Sg/hlJcXxETrtzP0aUg==@kvack.org
X-Gm-Message-State: AFuF++m+ffRKolZEoH2nqhNdY0emMQCIu8RfXL4eY6o6HdxprrZ61atY
	R+1YKnpeTZAoM1Wsq23jQLq3iE5uPSDwc8kpkeatncl7jRMR1ptLwgKndqII81PgzNjM0Ttzp2y
	Pm06svQsruL5YQEnFuT23ptLjApbTEzA=
X-Gm-Gg: AR+sD12FEdZE/B0Wf5L5sYnJtJTepdM//KQ3++ZhoD1splcPKMt2zsyzjY1vr/XDcL4
	z3Aa2640tyIKzUFizz3NhuO4PjQK++DOGQow3GST+MAi7U0XC/chvEYkOj7MdGAoquF/IvTCUdS
	usni10Tj6OkuvDDJrMUNAXZIUFdw3Vi7p3hywrKOUxjruITi1ufbVjPTYhVOrA1RdihE5jH9ka3
	sj1xTrD7941Ao2vF31VGZe9vcDkl8bXAzm8StwZcl6m2Pt42mWi01NgYzfu43Kc1Ww2cTzZIlfb
	SNvs36O+U1wBYwNjazPzIj+lDG5SSwmN4tJIVk/rcFn0dw==
X-Received: by 2002:a05:600c:4ece:b0:499:484a:81d0 with SMTP id
 5b1f17b1804b1-499c19e973fmr212050255e9.9.1787584178832; Mon, 24 Aug 2026
 08:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260818073546.832476-1-kunwu.chan@linux.dev>
 <CALa+Y16xODsaFZDfh7ZeP3gWbycK92gvP5N8_NFpOvW=R2BWbg@mail.gmail.com>
 <CAN_Opa_h2W1hRimy2YXPC4EgueCi2UNwnZ5gSYV=cr8M7yfCmA@mail.gmail.com> <CALa+Y15zNhpubyH5GQgu_BHesrwRdH0B8k5cqT3o_U0h5A2e-w@mail.gmail.com>
In-Reply-To: <CALa+Y15zNhpubyH5GQgu_BHesrwRdH0B8k5cqT3o_U0h5A2e-w@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 24 Aug 2026 23:09:26 +0800
X-Gm-Features: AcwNN1Un4mBIKrUBo5pV6pSoeblVjDHYRZMA2eMa4t47pkuOoxnZ-4altPzxyQc
Message-ID: <CAN_Opa_JorKoVcyhPPLOnFOOGOMCd0r4Lr-eU1e1OraRq-FAMg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, sj@kernel.org, akinobu.mita@gmail.com, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 21C7140007
X-Stat-Signature: 6nrg9ggfan6aiab9hgr33ff159r7c7yp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787584180-827977
X-HE-Meta: U2FsdGVkX1/w97ZZFZyTEJKjsOdr4yFmPeZvf98n2u/CbvbxZrKOD+JsMHGvH6+I97n9pbqPj3BQLQvUBOPXb0jTrFZWNp+p9WPykSvEj3fcOzQKltPAoV5CrBSQ/ipBhr8dOtLprPR9J0IXNIIK6SIPKBvP/T3vTCAFP9frDd5SPkHoJtuBELWm/4T8tFhR/W8+yzYeANN7eRRbVTr4UDOHw+pC28EfZhJdQbw7iAMGZrZuvQDyz89wUWRHsF1vJNbxP0Kdl8yQ9MB0nuWJYmP2UBgGoG/gl70LrO76OhcsEhU9RJ/MAwWldzMDpLAyWV0XqLNb0mHukN2CAcvCENR2W1IIFkLcYElmy7WRZIv75QXxxCWhzbBXhxvN7lW2SbxPToATTWz+A5iUzsAmaY8fVA5WaakKVaHTpVwQbcceLy9C7zaTRfGypV3mGnR9e2gwS+rz0FkM7tG9LhvQlV8VbNDLBeBewRAWjEQC8x3cCekurch/iqLFv6a/DEEFAI3AWwYEDMFbbTdXHvCSZ9yOciW6glyzvArEQjb0I1AaIDrOoPAkFCdXsyj66HlVU4U0679qtIdLb1Y3rBtgbgMoukgVwpp0FfwfytVObiTtZst84xRbsiGvuNR4YAQw10naKc4ZXlUgzqdBDMpJyGSKK1l25HDFrhwS5sZ75zWBsYN3i30piRkqIZimpqL2c9BPe0l02a+ZtUEsBt14pFfk3uhFpacR2z4Rc73yx2yyBuX+HRN8zwlI3PIto6VXKiH4RVB+2af0w8JdvgPs2aEd1v7Viupch5f7qyTlE1yCisxaB1KLsvsyl9iIvD13io7pEieskAqoXneulpP/9YfCGLk1q3PnvVFGqMotkblT1JX0+t4HNnrUReDGNeB6Hh17IzSuCbWNhmQVaaAx2N9PDjnJdGwFB38crKoQi85YmQAWECcmiSyeoSqeonOQK2NoaH/Hhp5wTQWv7Hj
 2gJsIsRf
 infiRWxglplAdiGUVa16S16tZA9MZ/N3Oa6SjjNAYPBww4bVyVpFaGqIt1ywUoCYB6egw9voVTrhg/64CVKOozDYr7GDmEpPbBE6o1/lBObkGeN7fgqn9zUdHWNCfd7/t4ZJcH17F5CAbh+PjVyzfpIG2FF6P+m5I+aa0NOf7fNgmwX4pEusH5IYItKovNpjz4nnnKAGR2SPfm0FrqWMJ35u2TRxTjga/jaGit95VP0RwIGVarexfrkX796Y2MHHMhcK8QCOVZk6/0RHhAPdIBruF0iy+10+/fZ5IugUDou4+T0u7engvg0RWh9bQn0OfA3KM0bd8E7iuGCad6zuI3gGg0NSpzyMCelieQ24U5EBG0s4LiOBGCwM9PeMR1msvyct7yOpYHn/qLvCZS8ty8rfBzqb+eAmqlMAcuA86PKs7IA+Hk3NYZJ++gDWoFVy8ESOiy9i9howOlBxrPsE/4flKwCJv5gefanpgj+4IwYrO40nQUJmZ57CdibXJJZCnuWxBt/IaC6AAJje7ddDO0ZvL4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 12:32=E2=80=AFAM Ravi Jonnalagadda
<ravis.opensrc@gmail.com> wrote:
>
> On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM KunWu Chan <kunwu.chan@gmail.com>=
 wrote:
> >
> > Hi Ravi,
> >
> > Thanks for the detailed reply.  The fan-in diagnosis makes perfect sens=
e.
> >
> > > Your series is based on the v1 substrate, and the way an event is
> > > configured is the part that moves most.
> > >
> > > [...]
> >
> > Glad to hear v2 is on the way.  The probe-based model is actually
> > something I encountered while building the AUX backend. When multiple
> > sources can feed the same region (e.g. PTE scanning + SPE/IBS), the
> > question of how to combine their reports becomes interesting.
> >
> > For example, CXL tiering may care about physical-address locality, whil=
e
> > per-process monitoring may need virtual-address attribution.  How do yo=
u
> > see probe weights being determined =E2=80=94 is that expected to be
> > scenario-specific, or is there a more general principle behind the
> > weighting?
>
> Hello KunWu,
>
> SJ can answer that authoritatively -- the probe and weight interface
> is his. Here is my understanding which SJ can confirm later:
>

Hi Ravi,

Thanks for your detailed reply and for sharing your understanding.
The probe-weight framing clears up the part I had backwards.

> Weights are relative, and only among probes. A context can hold up to fou=
r;
> each report carries its probe index and credits that probe's own hit coun=
t,
> so two PMU-based probes in one context are scored in proportion to their
> weights, and that is where a scenario-specific choice belongs.
>

This makes sense. I had initially been thinking about using the weights to
tune SPE against PTE scanning within the same context. I now understand tha=
t
the weights are for combining multiple PMU probes within a context, rather
than blending PMU reports with the existing PTE-based access checking.

> What does not mix is a weighted probe with the other two sources. Any
> nonzero weight switches the whole context to probe-weighted scoring, whic=
h
> turns page-table access checking off -- so SPE cannot be blended with PTE
> scanning, it replaces it. Page-fault reports carry no probe index; they
> credit the region's access rate but have no hit count, so under weighted
> scoring they are not part of the score either. Both coexist with a probe
> only at weight zero, where everything feeds the same access rate and is
> indistinguishable afterwards.
>

The "replace, not blend" distinction was the key correction for me.
For PA locality versus VA attribution, using separate contexts therefore
makes more sense.

> So for your case I would read it as: PA locality and VA attribution are
> different targets and different address kinds, which points at separate
> contexts rather than one context with tuned weights.
>
> >
> > > 2. The 67.9% drop rate is fan-in, not sizing
> > >
> > > ---
> > >
> > > [...]
> >
> > I completely missed this.  The observability framework showed the
> > symptom (67.9% drop) but got the root cause wrong =E2=80=94 it's not a =
ring
> > sizing issue, it's a fan-in problem.  With a single kdamond thread
> > draining the per-CPU sources, the samples effectively get funneled
> > into a single ring, which explains the numbers.
> >
> > The per-CPU drain approach using `system_percpu_wq` and `queue_work_on(=
)`
> > looks like the right fix.  Our AUX backend already carries a CPU argume=
nt
> > through the ops, so adapting it should be straightforward.  I'll take a
> > look at your v2 branch and re-test with the per-CPU drain.
> >
> > Two questions:
> > 1. Is `damon/perf-rfc-v2-08-20-26` ready for me to rebase the
> >    AUX backend and observability framework on top of it?  I'd like to
> >    validate the per-CPU drain fix with real SPE hardware.
> >
>
> Yes:
>
>   https://github.com/ravis-opensrc/linux.git
>   branch damon/perf-rfc-v2-08-20-26, tip 9c0410564596
>
> That is the branch I used to exercise the AUX path. It carries all five o=
f
> your AUX kernel-consumer API patches unmodified, and from the SPE series,
> patch 1/4 plus the generic half of 2/4. 2/4's SPE backend and parser, and
> 3/4 and 4/4 which test them, are SPE-specific and I used an x86 box
> with virtual PMU.
>

Thanks for making the testing branch available. I'll use it as the base
for the rebase and testing below.

> The branch is force-updated post fixing two trailers please re-fetch
> if necessary.
>
> None of it is meant for my v2 posting.
> This branch is only the vehicle for testing the AUX report path.
>
> The SHAs you will care about:
>
>   808519650a7a  the per-CPU report side
>   e3323a3bdc75  your AUX interface, ported to the probe model
>   1c347519c626  parse each CPU's AUX buffer on that CPU
>   9c0410564596  perf/core: balance the AUX buffer reference on kernel
>                 release
>

Thanks for this detailed information.

> 1c347519c626 drains with one work item per CPU in the event's cpumask, vi=
a
> queue_work_on() on system_percpu_wq -- system_wq would not do, being
> unbound it silently ignores the CPU targeting.
>

Understood. This also matches the fan-in issue you pointed out earlier.
I'll keep the CPU-local drain model when reworking the AUX backend.

> Two things came out of a quick test in a VM:
>
> - spe_backend_init() calls perf_event_setup_aux(), but I could not find a=
ny
>   path calling perf_event_release_aux() -- spe_backend_cleanup() frees on=
ly
>   st->win, and your kerneldoc says the release must happen before
>   perf_event_release_kernel(). Left alone on my branch.
>

Thanks for catching this. I'll trace the cleanup path and make sure the
missing `perf_event_release_aux()` is called at the appropriate point befor=
e
`perf_event_release_kernel()`, then re-test the lifetime path.

> - 9c0410564596: the explicit ring_buffer_put() in perf_event_release_aux(=
)
>   is one too many, since ring_buffer_attach(event, NULL) just above alrea=
dy
>   drops the event's reference.
>

Thanks for catching this as well. I'll keep `9c0410564596` when
rebasing the AUX work.

> > 2. For the probe-based configuration, does the `prep_action =3D "perf_e=
vent"`
> >    model preserve the same event lifecycle?  Our AUX path needs to crea=
te
> >    and bind the event during apply, keep it disabled initially, and ena=
ble
> >    it when kdamond starts.
> >
>
> Yes -- created disabled during apply, bound, then enabled. Per CPU, on th=
e
> kdamond turn-on path:
>
>   perf_event_create_kernel_counter()   attr has .pinned =3D 1, .disabled =
=3D 1,
>                                        so the counter is installed but no=
t
>                                        yet schedulable
>   ops->init(event, cpu, perf_event)    your backend attaches the AUX buff=
er
>                                        here, via perf_event_setup_aux()
>   perf_event_enable()                  only now can the PMU be scheduled =
in
>
> So the buffer is always attached before the counter starts. If ops->init(=
)
> fails the counter is released without ever being enabled.
> kernel/watchdog_perf.c uses the same pinned + disabled-then-enable pairin=
g.
>

This lifecycle is exactly what the AUX path needs: the AUX buffer is
attached during `ops->init()` while the event is still disabled, and
the event is only enabled after successful initialization.

> Sanity-tested both report paths in a VM.
>
> Best Regards,
> Ravi.
>

I'm looking forward to the formal v2 as well. I'll continue working on
the perf-side changes so that the new model can be exercised with
hardware-sampled access reports in practice.

My next steps are:

1. Re-fetch `damon/perf-rfc-v2-08-20-26` and rebase my AUX backend and
   observability framework onto the probe model, including the SPE-specific
   backend/parser and tests.

2. Integrate the per-CPU AUX drain from `1c347519c626`, using
   `queue_work_on()` on `system_percpu_wq`, and validate that the fan-in
   problem is gone.

3. Fix the AUX lifetime path by making sure `perf_event_release_aux()`
   is called at the appropriate point before `perf_event_release_kernel()`.
   I'll also keep `9c0410564596` for the `ring_buffer_put()` fix.

4. Re-test the complete lifecycle and the per-CPU drain on real ARM SPE,
   including stop/restart, CPU hotplug, and failure paths, and compare the
   observability counters with the previous 67.9% drop result.

I'll report back with the results.

Thanks,
KunWu

