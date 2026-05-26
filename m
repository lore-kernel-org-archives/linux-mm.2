Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD4ACD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 00:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E386B0005; Mon, 25 May 2026 20:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F606B008A; Mon, 25 May 2026 20:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50226B008C; Mon, 25 May 2026 20:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF2C26B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 20:05:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0251CC077A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 00:05:20 +0000 (UTC)
X-FDA: 84807626442.21.45BDFC0
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf29.hostedemail.com (Postfix) with ESMTP id E436A120008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 00:05:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZlMOirYX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779753919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NincQHHUkFRFpZCpbw98WAPBg+k0sO/KWp+Cuwbg5yQ=;
	b=4EYJP2ieQG8rZHz2zh1kRscGGoM4Xaxtv+AWXTpPd3vl9a7M5NR+vRhgkYin09c1lCRmqk
	yfasfgsAkqT6Z+asACXxUzsA5iy/3q+vk4AL14jXk5pf7zdQ2rIL/UCJuLYQN4JHK/K3Iv
	WDMg4uDjYNSt5TwtNxoqN8T0RBEmqFA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZlMOirYX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779753919; a=rsa-sha256;
	cv=pass;
	b=WkErpAp7q+bfd4h1l4OWWcGu0YMovmHnyKN7+Fd9Oy6oLxlCkK/f5pkqOu0JN2VQ4rwQky
	h3ypBfdz3N+jWSAAl0X0zvFKDu+bIgU5XRDSLmWKjXaFsJixfKGGQknivPbXUyLqv1Fig5
	UurzHWx/+jFmFvDe/shDph9q8Ke7gVU=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-135e7f4a295so3745365c88.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 17:05:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779753918; cv=none;
        d=google.com; s=arc-20240605;
        b=OBeYTsDOSAQh4G6CzFTbEAl382ReKzSq9sgwdYCBLLn04ZFqwVC20GgbKAURgzkjyu
         bJJvxwj5iFVNsUzaIz6/Fr4Mt4xKv06/KuQ8ZzOOP2SFqeQc6V5GkNKXqBslz2tza5XS
         0VDd6BnVdCjALS4B3I+eDnhGXwLOWB2R9ODb6i56y72BJAWMkrCI6iBbewMJJ2MxM6oJ
         CaVBWkqc2zuua2TGmMc2fO5JbfK8haa2GjdrSFAWo8u8BdS489x/zu8SsPFSHgwcUNDl
         NF+eS48Z/MkU576Dc5nN6kcPwyuKma2XEDGRQWD1zzzXs9jMfnrNM0pg0GXZEVWsnpAv
         yx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NincQHHUkFRFpZCpbw98WAPBg+k0sO/KWp+Cuwbg5yQ=;
        fh=CF6fH9n7pMhSI5O3cIT0gErBvCWqhVgkytsj9MCdeJQ=;
        b=E+551YiPCCN76Teq5HuNCdKaZBjQGOSImZ7Jb4zcs7JGPADvB7i2dYVIFpNgTp06il
         4O9svdsYmxSjxC3JEnP95+teF9Q/VCSYoc/bF8eN/qZ0eoypqCRNU70qjQlUhxet16Yz
         4IcFWn8a8mWPgfHtAy69c9CZIHQk5rwFde2/iqd8h6I4qlfrOwvnDiKEj1z8hQiWhu7B
         6zLpBnzzvXuTKsSEBNzoDXeQL4Q+srvYm/BZjZnj4wyukL0CGdqBeJel/mxALIOPF9bo
         /xseckt1KlOrc9pf1fbim32FHJ8NisBsbYrpBNKp37oRhXuY3vuZAVyGrszPpQITAsLq
         A5uQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779753918; x=1780358718; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NincQHHUkFRFpZCpbw98WAPBg+k0sO/KWp+Cuwbg5yQ=;
        b=ZlMOirYXJ11ABcMllcW/tQBjCNaAN/AoW7TtSyrlj0P8W8NOzV66WAFgR/FIZEvld1
         A/l+cNJ6nMA0dz33Xhnkg7zZT52Xjfs+n+VlpEaxveltIIHhD5HYOlkMWfxhZXNOt5Eq
         TEXH6KZom1stmCQZ2ZswXNV+J1OnD7HVc449QamRh7XyFwmjZwOumGKDsB/3ePCgQdXq
         bde0bZyZzPPqVvMzfJTAf9dnbiPGzzsIbbbjCzt56ogp3JDkl+aDfaxG5TsQzbJ39upj
         MGHzDJoBVg8MoA+0YebYT/5FIrGpD8xR7HKH5SwKAmEduoi4jlT2Yc6ujrVIJofv07o4
         svBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779753918; x=1780358718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NincQHHUkFRFpZCpbw98WAPBg+k0sO/KWp+Cuwbg5yQ=;
        b=KR4brQUTylvGcUqXVouePjg5LxN7lxuO+V64cquGMk2koZfijArZhm96e8DrR60XF8
         lyOZMYkUvbU7U5TBkn0IPlw1egQQlKuYy5sI6d330jLNbFoAn36e9ZXIyCdguCqXkPu5
         7gk89ZFqe9KpVQtIvQRsvCXlq0U8MdvYBavYUTeSXb2Z4x6gVn5yZ/+V9ery8RBcnFrk
         032HG92i18/+3wbCiIPmnDkG3iRkf0InQhzeNcV2hVKlyLuelRDzBv3JxFX7gFpx74Gm
         X0S2LuT5+pQhG5sZaomwWxH/TUVO7bKKYNzEwfAv3/h7GCUzBgNIFzMCSKEFoeYA5CFc
         cMoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Ttn9wPPmNbAklcwpd4mZr5WwyAE1iDjuWPp9jDFz9WucGGQynoEXuE0rls51vpV077S1OBhFJlA==@kvack.org
X-Gm-Message-State: AOJu0YwBifMEUm9KSIlw9cM9k555sjB32ynhsomnMI0fvsKebCHPvvG6
	dyHd7wVT4J/vup90P/4ufDoTTpSPJyN5L7pq5xOBfqgvOohVaR0T1VNJCH7v4OXdDDCa0Vjspfq
	dJ0wPlepy+RsVg3/wsRcwVKb5i2RxTg==
X-Gm-Gg: Acq92OFicYqDbr4FoymByv3nR91wSpu7V/LjQ3b5sTLjGMJT4phVidj7IXYCZtL3TcM
	b+15dGS/8SlAE13HVzcCuxMs6Cu9sCjaILP2DMsS+Cx04yCh2Nzs8V0MASBxWkUZJ9xd42vU+kh
	JT52udP6DiDLy0T8ZdxDFI4Rc8wios6FrazbPtVFSLBW66wTDGcGNo81vgm8Si9eVFB4B56lbC3
	y9nUpbMZWk+bUSc9Lvvt/54w/a7baRuF8vBYLSxts8U8vMfklAxQlpXf8BUxnyQ1laowh/P51q2
	wiSObug=
X-Received: by 2002:a05:7022:610:b0:136:c2fa:32d6 with SMTP id
 a92af1059eb24-136c2fa37e7mr2419192c88.7.1779753917284; Mon, 25 May 2026
 17:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <CALa+Y15fsgb1SU1xBq6BHsgk9QSJr39L5CZSCahpRu7udGuwKw@mail.gmail.com>
 <20260521003247.84337-1-sj@kernel.org>
In-Reply-To: <20260521003247.84337-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 25 May 2026 17:05:06 -0700
X-Gm-Features: AVHnY4JrstSX8sPAVPbrXAIWWUvcSJkyLCkHpYdCefAqgqndyn1dXmWz0xR_I-A
Message-ID: <CALa+Y167W9Cs0zFh6rnbDgk91cMvtofSxuAu_-M3dWwiSkbTKQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] mm/damon: hardware-sampled access reports + AMD
 IBS Op example
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com, bharata@amd.com, Akinobu Mita <akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fga81uiygwmyja6wuryzwyfbc1d5nap9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E436A120008
X-HE-Tag: 1779753918-558824
X-HE-Meta: U2FsdGVkX19uwg74EQ6u3QCwBjNLagF/aBdlGf+tW3hyG4qIYVLj6MQZt+JrhHLchYpHWo7JxGh2K1DkCfkpE04sQynN8ISD92ctzc8YjlbfhpAsn3n1KBxiL+67HYxgb8f6O4/erfdS2C1vcEgudW83Qxu1+pEDLtWFRDfMDVbM0LMCZj+/1Trjl4oFJNrgQNrNZuU/lOG2P3PDa+jLVceASJv1uxOb9EZHSGxeefUv1YTJqKPUQL2ElWKCnxIDRuRWvqDw8uGAizaVDbB2lNCW8WvA3ppipwT61cLHoiZ38YhG2220eNusAi9Zq9Rae5zQH1GQUr66VlM2PYp3v4wF+Sfi3ueuXDJNe6RkV5wrNYNC75Vs5Q3KCZujflhlsskxSYz5VXzBl82EDJ2Z4vVZOzHnxP9Pb+duK0do+JJWzQE4D0qefWLNkyh1hZeaNKnSU0L05W5HK9PX7m/T5YKKaqXMzxrrfkeLv3Pc12CRuMIp0+Iqf/xt2x8O9uDO52OUhN5ETMMpbhCusTcrw7KT/GwUCXr3eIe+ghjjRO3DHZszEmR0qirlDsh21S9tGpNVn3wuzkilVcHCAnkofpGMu9pju5vOOqXS0/h26Ekdw4RgKzUWfezVawoQEi829njvuArU1X9lK+MN91hPVYuvKkFtPpck+syuNx0sDtsEOFj5a0nRLwtZRRppXdrBvaq9tNN6zvFM3emQUYPulvcci2iZpmd2/fDIMtEAMYotsWo3F10fwkqdWXLY9JS5CbmZvCIOHjoArGx5S/ag9z/ycSdoyS/LHPshKVzIA+hkEoQ4b6dUdFPvDrJSHH1Kh5uMcdYpWZ1H7lpj4ZfdMpHm8MoJsBP4NQG8QPLLWKnbhd4fBx86L5vfkakO1bA1CX7+f9vNzIw16PG+nf3evuaPwWLwlm+6v61MCy/+/kisGREqEVfBt5d5WPSVg3KsOAjAc9oqp9WVknHQRhX
 PnBSxiqx
 5yIjwcSJD0WwGPVtKlhpV38xM168Zb1o0dTYI+lhP/fsCsF6ZVaMmAwBoxrvHuyuJnywCOHGHsCrhv6+KaBs7hcnPH5WEUwNX5IjSdXYaVw3urQ8rqsVQpzBjOzlU3n93SUyNj6ecHspNlR94X6QfAIpFFDN7ddnXy6RBq0SQ+mmg//BC+LRXiHbxafUTPFso7wOB+aMZ4QgY4IQFnHCGMiKdnx4a24w1Q/6O6CZJWQKsGIHf287V/m88I8pkB/FoaGtURDStL7eqWiqnwBAo3Gsxi4716alY4xIXznM5AsIUFoXG3YHwPwyMO2X0NDdgdlk4D8ONfzvdii3hY6//1MxV7FlY0/FO3oprJJL4aqXayEnuhJuq8S+mJjYYIobQAALOO2WNpREQp8tCnLiQ8dR6gR7gd+v76lDmzYRlFkmea/m0krImV1EeqLuXwAlN8LvX0niWbQ0Np/t1/N4tM+NXltlgrKdm7oegc4uCvEmcB5rEUlCngBFj1XC5oLWAPJaFN9TyVpEbi79VlP3c7IviKWXH9BFFDyp24AxIxDs8BN/aRZ2HqxPNHizKVfGm7Gy24UfMcrMRhy4/lSBzMiGEqrJKC+M++drLFp85igBrbvyRs0KKRWgO4aLUmbZJ9xrZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 5:32=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 20 May 2026 12:01:43 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > On Mon, May 18, 2026 at 11:19=E2=80=AFPM SeongJae Park <sj@kernel.org> =
wrote:
> > >
> > > + Akinobu
> > >
> > > Hello Ravi,
> > >
> > > On Sat, 16 May 2026 15:34:25 -0700 Ravi Jonnalagadda <ravis.opensrc@g=
mail.com> wrote:
> > >
> > > > Hi all,
> > > >
> > > > This is an RFC, not for merge.  The series exercises and validates
> > > > damon_report_access() -- the consumer API SeongJae introduced in [1=
]
> > > > -- as a substrate for ingesting access reports from hardware-sampli=
ng
> > > > sources.  The series includes one worked-example backend, an AMD IB=
S
> > > > Op module (damon_ibs.ko), that runs on Zen 3+ silicon via the
> > > > existing perf event subsystem.
> > >
> > > Thank you for sharing this great RFC series!
> > >
> > > [...]
> > > > Why a hardware-source primitive complements existing primitives
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [...]
> > > > Both primitives produce a view of hotness that converges to the
> > > > true distribution over the aggregation interval.  For systems where
> > > > the address space is small relative to the aggregation rate, this i=
s
> > > > the right tool.  On large heterogeneous-memory systems with goal-
> > > > driven schemes asking the closed-loop tuner to converge on a target
> > > > distribution, a complementary lower-latency view of accesses can
> > > > tighten the loop -- reducing the time DAMON's nr_accesses takes to
> > > > reflect the workload's actual access distribution, which in turn
> > > > reduces ramp duration and oscillation amplitude during convergence
> > > > of goal-driven schemes.
> > > >
> > > > A hardware-sampling primitive provides this complementary view:
> > > > hardware retirement records each access at its natural event rate,
> > > > with a physical address per sample, independent of TLB state and
> > > > independent of the unmap/fault path.
> > >
> > > Yes, I fully agree.  Different multiple access check primitives have =
different
> > > characteristics.
> > >
> > > [...]
> > >
> > > > Demonstration
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [...]
> > > > In both regimes, convergence to target is quick, and the workload's
> > > > measured DRAM share then holds within 1.3 percentage points of
> > > > target with standard deviation under 1.3 percentage points, sustain=
ed
> > > > over runs of 15-30 minutes per target.
> > >
> > > I understand this demonstration shows your AMD IBS-based version of D=
AMON is
> > > functioning as expected.  Thank you for sharing this!
> > >
> > > [...]
> > > > What's in this series
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > >   Patch 1.  mm/damon/core: refcount ops owner module to prevent
> > > >             rmmod UAF
> > > >   Patch 2.  mm/damon/paddr: export damon_pa_* ops for IBS module
> > > >   Patch 3.  mm/damon/core: replace mutex-protected report buffer
> > > >             with per-CPU lockless ring
> > > >   Patch 4.  mm/damon/core: flat-array snapshot + bsearch in ring-
> > > >             drain loop
> > > >   Patch 5.  mm/damon: add sysfs binding and dispatch hookup for
> > > >             paddr_ibs operations
> > > >   Patch 6.  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp
> > > >             ops check
> > > >   Patch 7.  mm/damon/damon_ibs: add AMD IBS-based access sampling
> > > >             backend
> > > >
> > > > Patches 1, 3, and 4 are general infrastructure that benefits any
> > > > consumer of damon_report_access().  Patches 2, 5, 6, and 7 are the
> > > > worked-example backend (paddr_ibs ops, sysfs binding, IBS module).
> > >
> > > I didn't read the detailed code of each patch.  But my high level und=
erstanding
> > > is as below.
> > >
> > > Patches 1 and 2 are needed for supporting loadable module-based DAMON=
 operation
> > > sets (access sampling backend).
> > >
> > > Patch 3 is needed for supporting access check primitives that can pro=
vide the
> > > access information in only nmi context.  It can also speedup the acce=
ss
> > > reporting in general, though.
> > >
> > > Patch 4 makes DAMON's internal reported access information retrieval =
faster, so
> > > will help any reporting-based DAMON operation set use case.
> > >
> > > Patches 5-7 are required for only the IBS-based DAMON operations set
> > > (paddr_ibs).
> > >
> > > So I agree patch 4 is a general infrastructure improvement that benef=
its
> > > multiple use cases.
> > >
> > > Patch 3 is also arguably general infrastructure improvement, as it wi=
ll make
> > > the reporting faster in general.
> > >
> > > Patch 1 is not technically coupled with paddr_ibs, and will be needed=
 for
> > > general loadable module based access check primitives.  But, should w=
e support
> > > lodable modules?  If so, why?
> > >
> > > Patch 2 is also not technically coupled with paddr_ibs, to my underst=
anding, so
> > > should be categorized together with patch 1?  In other words, if we a=
gree we
> > > should support lodable modules based DAMON operation sets, this shoul=
d be
> > > useful for not only paddr_ibs but more general cases.
> > >
> > > Correct me if I'm wrong.
> > >
> > > >
> > > >
> > > > Patches worth folding into damon/next
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > Patches 1, 3, and 4 are not specific to IBS or to this RFC's
> > > > backend.  Each is preparatory infrastructure that any consumer of
> > > > damon_report_access() will need:
> > > >
> > > >   - Patch 1 (refcount ops owner) -- any modular ops set, including
> > > >     out-of-tree backends, needs clean module unload to avoid UAF
> > > >     on damon_unregister_ops.
> > > >   - Patch 3 (per-CPU lockless ring) -- damon_report_access() cannot
> > > >     be called from NMI context with the current mutex-protected
> > > >     buffer.  Hardware samplers all need NMI-safe submission.
> > > >   - Patch 4 (flat-array snapshot + bsearch drain) -- the linear-
> > > >     scan drain is O(reports x regions) and exceeds the sample
> > > >     interval at high-CPU x large-region products.  Bsearch brings
> > > >     it to O(reports x log regions).
> > > >
> > > > If these belong directly on damon/next as preparatory patches for
> > > > damon_report_access() rather than living inside an IBS-specific
> > > > track, we are happy to rebase and resend them that way.
> > >
> > > So I'm bit unsure about patch 1.  If we don't have a plan to support =
lodable
> > > modules based DAMON operations set, we might not need it for now.
> > >
> > > For patches 3 and 4, I agree those will be useful in general.  Noneth=
eless, I'd
> > > slightly prefer to do that optimizations at the later part of the lon=
g term
> > > project.
> > >
> > > >
> > > >
> > > > Relation to prior and ongoing work
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > The IBS sampling pattern in patch 7 -- attr.config=3D0 to use IBS O=
p
> > > > default config, dc_phy_addr_valid filter, NMI-safe sample submissio=
n
> > > > -- is derived from concepts in Bharata B Rao's pghot RFC v5 [3].
> > > > The attribution header is in mm/damon/damon_ibs.c and the patch
> > > > carries a Suggested-by: trailer.
> > > >
> > > > Bharata's pghot v7 [4] introduces a different IBS driver targeting
> > > > the new IBS Memory Profiler (IBS-MProf) facility, which Bharata
> > > > describes as a facility "that will be present in future AMD
> > > > processors" -- a separate IBS instance from the one this RFC's
> > > > backend uses. This version of driver based out of v5 [3] is an
> > > > example of how DAMON can be benefited from AMD IBS Hardware
> > > > source and validates importance of IBS information indepedently.
> > > > It is not meant to be merged in the current form.
> > > > @Bharata if you see a path where IBS samples can be consumed
> > > > by DAMON at some point, will be happy to collaborate.
> > > >
> > > > Akinobu Mita's perf-event-based access-check RFC [5] explores a
> > > > configurable perf-event-driven access source for DAMON.  IBS has
> > > > vendor-specific MSR setup beyond what perf_event_attr alone
> > > > expresses (e.g. dc_phy_addr_valid filtering on the produced sample,
> > > > not on the perf attr), so the IBS path here appears complementary
> > > > to [5] -- operators choose based on whether their hardware sampler
> > > > fits stock perf or needs additional kernel-side setup.
> > >
> > > So apparently there are multiple approaches to develop and use h/w-ba=
sed access
> > > monitoring.  Akinobu and you are trying to do that using DAMON as the=
 frontend,
> > > and already made the working prototypes.  There were more people who =
showed
> > > interest and will to contribute to this project other than you, too. =
 I 100%
> > > agree h/w-based access monitoring can be useful, and I of course thin=
king using
> > > DAMON as the fronend is the right approach.  I'm all for making this
> > > upstreamed.
> > >
> > > I was therefore spending time on thinking about in what long-term mai=
ntainable
> > > shape this capability can successfully be upstreamed.  I suggested
> > > damon_report_access() as the internal interface between DAMON and the=
 h/w-based
> > > access check primitives, and apparently we all (I, Ravi and Akinobu i=
n this
> > > context) agreed.  Akinobu thankfully revisioned his implementation ba=
sed on
> > > damon_report_access() interface.  Ravi also implemented this RFC base=
d on the
> > > interface.
> > >
> > > After making the consensus with Akinobu, I was taking time on the use=
r space
> > > interface.  When I was discussing with Akinobu, my idea was extending=
 the user
> > > interface for the page faults based monitoring v3 [1].  But, recently=
 I decided
> > > to make this more general, so proposed data attributes monitoring ext=
ension [2]
> > > at LSFMMBPF.  The patch series for the initial change [3] is merged i=
nto mm-new
> > > for more testing, today.  The cover letter of the patch series is als=
o sharing
> > > how it will be extended for h/w based access monitoring in long term.
> > >
> > > I of course want us to go in this direction.  I believe you already h=
ad chances
> > > to take a look on the long term plan and didn't make some voice becau=
se you
> > > don't strongly disagree about the plan.  If not, please make a voice.
> > >
> > Hi SJ,
> >
> > One layering question I'd like to flag before the plan is written,
> > since it affects how this RFC's substrate slots in:
>
> To my understanding, this RFC reuses the damon_report_access() infrastruc=
ture
> that shared with the per-CPUs/threds/writes/reads monitoring series [1]. =
 My
> plan at the moment is to keep using it.  So from high level view, I think=
 the
> final picture would be not really different from this RFC.
>

Hi SJ,

   Sorry for the delayed reply. Was away for a couple of days.
This resolves the layering question for me.

> >
> >   In [3], .apply_probes is a periodic per-region classifier driven
> >   from kdamond_fn after .check_accesses, in process context, that
> >   applies a (folio -> bool) predicate to each region's sampling_addr
> >   and accounts the results in r->probe_hits[].  damon_report_access()
> >   on the other hand is a per-event delivery callback into a per-CPU
> >   buffer, called from the access source (NMI for IBS / PEBS / SPE,
> >   process context for page-fault-based sources).  These appear to
> >   me to sit at different layers - delivery vs. classification.
> >
> >   The reason I want to confirm this: NMI context for HW samplers
> >   precludes the operations .apply_probes can do today (no mutex, no
> >   kmalloc, no sleep, no folio lookup that touches pte_lock).  And
> >   the data shape is inverted - .apply_probes asks "does region R's
> >   sampling_addr have attribute A?", evaluated on the kdamond-chosen
> >   address; an HW sample announces "PA Y was accessed at retirement
> >   time T", arriving asynchronously and needing to find the region
> >   it falls into.  If access events end up routed through
> >   .apply_probes in the long-term plan, the IBS / PEBS / SPE
> >   backends would each need a deferral path under it (per-CPU ring
> >   for NMI-safe submission, region mapping at drain time).
>
> It will not routed through .apply_probes, but work in a way similar to th=
e
> damon_report_access() based design.  That is, each (sampled) access event=
 will
> syncronously call damon_report_access() with the access information.  The
> information is stored in DAMON's internal data structure.  The informatio=
n will
> contain the access destination address, the accessor CPU/thread, whether =
it was
> reads or writes etc, if available.
>
> Then kdamond will read the reports in the data structure once per samplin=
g
> interval and assess if each region got accessed or not since the last sam=
pling
> interval.
>
> So my plan is not to reuse .apply_probes, but in terms of who consumes th=
e
> information, it is not very different.  Accessor will produce the informa=
tion
> (report), and kdamond will consume those.  But this is how
> damon_report_access() based structure is working on, so my understanding =
is
> that your RFC is also not very different.  Am I missing something, or do =
you
> have any concern on this structure?
>
> >
> >   Happy to be wrong here if you see a unified shape that handles
> >   both - just want to surface the constraint before the plan is
> >   written.
> >
> > On the loadable-module question for patches 1 and 2: agreed it's a
> > genuinely open architectural call, not just a paddr_ibs convenience.
> >
> >   - paddr_ibs (this RFC) targets the existing IBS Op facility on
> >     Zen 3+ silicon via the perf event subsystem and uses a
> > vendor-specific
> >     overflow-handler filter that perf_event_attr cannot express
> >     (dc_phy_addr_valid in IBS_OP_DATA3).  Bharata's pghot v7
> >     [pghot-v7] introduces a separate IBS driver targeting the new
> > IBS-MProf
> >     facility on future AMD silicon via direct MSR programming -
> >     not perf at all.  These are two AMD-specific HW samplers with
> >     non-overlapping silicon coverage and non-overlapping kernel
> >     paths.  A distro shipping a single kernel image to a fleet
> >     with mixed silicon needs runtime-selectable backends, which
> >     obj=3Dy can't do across exclusive `depends on` chains.
> >   - Akinobu's perf-event RFC v3 [akinobu-v3] is a useful contrast:
> >     it stays builtin because it's a generic configurable
> >     perf_event_attr passthrough, no vendor-specific code in the
> >     overflow handler.  The tristate case is specifically for the
> >     backends that need vendor logic outside perf_event_attr
> >     (IBS dc_phy_addr_valid, future ARM SPE record-format
> >     handling, future Intel PEBS DLA quirks if they need
> >     kernel-side filtering beyond what perf delivers).
>
> I'm still not familiar with IBS and perf events.  Please bear in mind wit=
h me.
> My understanding is that there are vendor-specific knobs for IBS that per=
f
> event is not supporting.  So far, that makes sense.  And are you saying t=
hat
> you have to write paddr_ibs as a loadable module if you want to support t=
he
> vendor-specific knobs?  If I'm understanding you correctly could you furt=
her
> share why it cannot be done as a builtin module?
>

This RFC's IBS backend does not claim exclusive use of IBS.

The reason patch 7 ships as tristate is precedent and reuse: Bharata's
pghot v5 posted its IBS driver as a module, and I matched that shape
during development so the two consumers could potentially share IBS
plumbing instead of duplicating it.  Patches 1 and 2 exist to support
loadable ops modules generally.

More clarity on the right shape may emerge once Bharata comments on
the questions below.  If pghot ends up being the sole in-tree consumer
of legacy IBS Op, the loadable-ops question can be deferred to whenever
a second primitive actually needs it - patches 1 and 2 dropped, patch 7
made obj=3Dy or folded.  If both pghot and DAMON consume IBS, the
modular shape earns its keep.

Bharata - can you please weigh in on the long-term home for legacy IBS
Op (under pghot alongside IBS-MProf [pghot-v7] vs DAMON-side backend).
Related: any thoughts on the operator-facing knob to pick between
consumers when both are present?  Happy to align.

Thanks,
Ravi

> [1] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org
>
>
> Thanks,
> SJ
>
> [...]

