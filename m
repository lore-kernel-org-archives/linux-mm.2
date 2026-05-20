Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE20CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57806B009B; Wed, 20 May 2026 15:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08E66B009E; Wed, 20 May 2026 15:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1556B009F; Wed, 20 May 2026 15:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73E526B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32D021C02E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:01:59 +0000 (UTC)
X-FDA: 84788717958.08.3288F6D
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id E6151180012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:01:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hGC1ARE4;
	spf=pass (imf16.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779303717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8wskmWgOJnbiOMNtnNeRCHNxmIGzn47RNTbCEm3fjg=;
	b=yQM2HnmEivLkwaehLsBKeIH/aMav9m6c2ciwqxUeUqOpthD8m7tBGVnw/Ky71Uw1SYf2t9
	mtESd12OWpGi2zt8rVKEEHOBRhnNdV3njxXsrQQWUkl5dckSrNYWh+NT5yj26o5NgU04Xi
	fmhtG8xAjYMb8uKYIUYMa5d6tpBZMy0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hGC1ARE4;
	spf=pass (imf16.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779303717; a=rsa-sha256;
	cv=pass;
	b=akUqe3L1f0aMVrndsJYnzJKyBfd7QSXoAPtF8o2WlcKZjFglRmyCRUb9fa8wxkAApuFecs
	LzTWQ/Rk7AiFFP80fan+bB4kTyp+RPm/Jmy7kDhc2N/3Gvla67b4TY3m0Vpn2NMQceUXMR
	eF71h8XGtYFQZhX99qVtLO5fPVoyfr4=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-1357c851a48so5785176c88.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 12:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779303716; cv=none;
        d=google.com; s=arc-20240605;
        b=cWZnMJft2qBOXvQrB9XwaUudNEf1NwG2BLs/gEYkdyUZ0D3IR1ah/9HnfKngJtODMx
         WiEulkL5Sqyq6PIl28IicraVGy0L9oNwR4Jd3vA1Y8oM6S5gpldwIKnWtkas5NlFJoEh
         1OZr3+fc5MbpfIsSE1M4uVTYyjHR9N1+JCIpGmK5yrfd65DbO9dqq506sCAVQqWojOIu
         lBvDqmC+P+4XUJ5BES63PQ289Z1NMIwunNwSxiQ2aWigeCdbWfyjAIbUVwJCRIz9+OFu
         rczUVFgugWWvQ9ypUOsBtfwlINH7ZswRyTusELiDz151Ai8Zcqv04m4xzagRJnMXEXF2
         h9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g8wskmWgOJnbiOMNtnNeRCHNxmIGzn47RNTbCEm3fjg=;
        fh=ZZBporWhvm18UOUVw5v38OqeQPgp8VrwByznf+Zsa/Q=;
        b=gOSge8jat3fjC896sJU88Dgs41xBmQ6Ulw2sS89zEttE1MwyviPcAXNY3humjvmeSb
         5pvkU35RjmwzH0D+EcMhH5zMHLJpukQt4ZxLzvfGxEI29QgcmYq7DufPK7P5asdkJIx/
         +D3+y//9eR201SWpr5dSqaQlAOIOqWyjv4mnopPOUNaQ589lecCSPm/3rt6KuCKawJkh
         SXEi6n43pF1DIBaFddlgj9bkvQ94GahzWOt8WBUKAD3azmfQ/DG6xBhHxzfWIhSrdsax
         Dy8HyG/w8jGpr8r80SCvknUopCFTdt2Np3FP8A11jdgh5n1zwG7//eOgvama8xvjAWX/
         kQMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779303716; x=1779908516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8wskmWgOJnbiOMNtnNeRCHNxmIGzn47RNTbCEm3fjg=;
        b=hGC1ARE4V3z2KBMvJMt1B3mVcPUxYPeeJt2EGBKMviWCdRy+xCFdmIRh4Rte6G7Dvs
         kTdDEI31oLxTWlYzE3KgrRAkO3dIh7Sw5tTeieOhqoFU06UxE2YCV609dIgK0UvsXU1V
         CEuVcupAn8ahB1Te9tgcMHUj+scPhTWT/46o2PouIc5u2pyzGnrWeR7cdK3YcJ/at48P
         EZUCLkRIl8pWBpZSyt75ujiguGufX84Ng5IlZdg8JMSYo4v7U6vwXFPUdWd9XygvA8rz
         I/A05yK4PF6Z0mNvFXkwqH8aYMGpzSm5QCUF5s4MM7Qr6hnYpiEh7KLTJ4Z2bfUZO8Kg
         TVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779303716; x=1779908516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g8wskmWgOJnbiOMNtnNeRCHNxmIGzn47RNTbCEm3fjg=;
        b=MznOZ5NAb30rOaFTdm+c6VImLybgkEjs2cbcDY0cgzxKPaTnb680h/e4U+mgTcbUYU
         3Jxxr+rcuW7lPeK8Xq9XNhproyF/QOauAYmUopbJ6Jkl3hhwtTZW/2BSwE7VwqqSuJ0y
         4IOLBcICRuTQ+UqZfRCYfNjTDlpsrK59VRab8ZDVuJ1cdYUjccocWNJljSIn6q4bsHJ6
         gL/KqQQYVhFjqW1esUIauu0eRPjq0OD6+Cge/UVWAlzioqiIbqTogqewoMp/NbAWw9p8
         ovlkAzfY/yNnyaaGZfFSReV3iO9/kptMbSTTakcYs6boS5o1JpvpH4O/p/GC862QdUsq
         n/tA==
X-Forwarded-Encrypted: i=1; AFNElJ/khLDp/JkjMXYPStbv90qxZcBLSYG9CTjNQdyn9ar1ggP4inTyRjSJs53ktVplzdMvJPIyw5fw8A==@kvack.org
X-Gm-Message-State: AOJu0YyXXh6wS1+NyEpXSmNSdkbEO4HNzZN30KpC3gDNcP/zhCCFtyuV
	BF7cDnCb23BGRRwQUbUxZLdGcdTPBQVWEOyim+NNkSiYniBm5f5fSRPyTPju8B6FbNKIWN1sAU9
	I+A6huqyViXPuuYRVYJEEzZghg9W61g==
X-Gm-Gg: Acq92OEhcX1+UJwuZvSNo1hLbce+hh9D561T7kepV2aOp9fgXCVtyWYC74y58IGtdAP
	yLfSwfQcVidpJl+jQmmeWLyPHcmV77jJCjvm5RxtEwGLnimGwWADj7IXBjxmxY28Md0soXZCnbp
	nwMReTfqodRGVZPafokz8LH6MUF3DfmfSapnuwCDh3bIURD52VzGfWgCpxjuj9wJZz2vZn2Vl9z
	xzsa16KuUYhXfTdAj/pHZN2+44O5ITOjZ9t+Oc0/o1man7pndxLML/FVejMuajyiXnK1PfMpTPk
	HnO8Mw==
X-Received: by 2002:a05:7022:31a:b0:128:e693:b61c with SMTP id
 a92af1059eb24-13504744146mr10445535c88.27.1779303715384; Wed, 20 May 2026
 12:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260516223439.4033-1-ravis.opensrc@gmail.com> <20260519061905.89681-1-sj@kernel.org>
In-Reply-To: <20260519061905.89681-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 20 May 2026 12:01:43 -0700
X-Gm-Features: AVHnY4IOAntwzQmGBj7zdfoy8PMwhjo75QeGCZqsNAY09ZN3ZddyxNlObQG4nQ0
Message-ID: <CALa+Y15fsgb1SU1xBq6BHsgk9QSJr39L5CZSCahpRu7udGuwKw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] mm/damon: hardware-sampled access reports + AMD
 IBS Op example
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com, bharata@amd.com, Akinobu Mita <akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E6151180012
X-Rspamd-Server: rspam06
X-Stat-Signature: jnno6kxu4y6tmtmfj367zqjzdxhwesux
X-HE-Tag: 1779303716-99899
X-HE-Meta: U2FsdGVkX19TnZyzYkNI3RLhhbqyEL5NZxftSliSMXyguGazZuGKDw3mD3SmU2hd+kDnOhwCZ+a9jiWelCDZStvZbK0EC7OQCbQ8VXm4Trr/71hBeQUmTUZV7wl0nEZhJyTPZqH4saIyycvpeMcVARzJJpadmxqUb0zuL1xi219Afiq5EZRRvV+E41G4MrsLF3rXv1yoGor78T3U0KSKN0wxfozt/NKDXjn0eQ02NMiisBvCXNbqluubWfnrOOUqYq4gYZPpInuBuvDwKRhlWzR2CltxU6a1a+YlQrtokLIgNX14JwQKP2JrtkvtcAZfiZy1FYpbOyuqNm4ZHqtoccy+65GE1rx++o5jM0r5HCgTHByoQ7uLV8S0F7kkNff81pQLXhEQpSWC7vrRDxQt/lZEpk6RcFvxxuPtSEj2cx7lWO9X9tE1qzZ8K6kh7Uq+4YWdmC2Ye0TBkLpj0VxglJMR4m0tZ50+eYkKs8KA0r64u+Q2OsSU7iJXwhHHHr7T+Gizq70iy4m2fY721mpOynDJC7GqyBjcaqqOVS2jhqh/3HrP4EFqLaZZHXYYbRPkKA7IHVdJjEjMWUConlokHhQPkrWQdh0h7FKT8cz3xkVdlFz5O5uPVsTZ7T9+i30jt+99hzbXozDWhiAF5/tGS/TkNAM+HtXrcV3Po5FBeEmVauwahz1Y4hYb6ZVR9SJSmuG1W/lOucMIggY/ftgIO/XaxL2Bo5JOsT44plormWUPUnusTvJQ/NDGZ8WdpoygRmiadgNHqSnQRpCJzVzGDsxygeRx11P4/PAZz4+/y/a+JAWiL3nQe4Y9mofgQAewkdWiLokfF2kjLgFMg9mLYKq7wPBHuswkWw5KOE4ZBX5eoGdDncHYxdyofoRyTGnMJpyg98VDjnePYZSk1fWK8UnapZ44BHO/WPT/koi4FCtX+E+vEBUrfkNGRSGV6BmkeBvrND15T41uTROuPly
 pSvcWKeT
 Yv2770x6+qPjGb1/An4lwH736hCRryZCGHrq+4lfOtGRq6GU1VCuHFXOEC4erQHWyOq3JoAfh6JkWBWeKXFEGDoX5z0OkQkfupLu7PMEt4OCxSRZBCyCMQomStL4GbjdjrM6of3k2LJKjUdOxj9jkqs9NlnPEVaKiYjmeWuVLux0DtRe54KNYrZ0w2QGulK+5ibRJ3n2uUEpehIMBe01BtQ0CZxeC+9rsC3/1iFVeiz8OGCd5N7XjedZuzWT1rcUMLk10AxU30Ya9287Wmf4xS8hLKeRg3C7m4rCmHLt1FZrA47Gg31YPTDeSG24Oih9rKthdx8D4xWbJYhAmxSHS1RKHNZqosWJzFvSLh6ZdJ8vFieTbEly9xAd3sz5sADLNAQVuvD3TnlULyVDppH++ooYIl2Jcp2ZVYnHbH2nqeisCW9FLjCXl39r/6Tp5xF5EkGhavkzhm7937jzOszrrTIRg1yGtiwPgwTDm2eDTLGhUJgn1IxHZiuxRU0qV7BrwedFOdAGpRibjPJfPUyy7WWc2VNuJz7rBefmSo7af4SE6DOzGuui/m8o3HmpfmLe8+ix4sJxWTR8HYNNsSJ8EFpEM+GM0jmQGr0oJ7WTz+5aGCqK4EJHdRLMmIHifwJe9zoen73UP96wv4EvajwLb9obzyOPS4ybOFKGgiYLcNcZ+Q9tHivL/DKOI9DaoTZLaZlZtpBXCEGiOyB6zWJOmOozRlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 11:19=E2=80=AFPM SeongJae Park <sj@kernel.org> wrot=
e:
>
> + Akinobu
>
> Hello Ravi,
>
> On Sat, 16 May 2026 15:34:25 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Hi all,
> >
> > This is an RFC, not for merge.  The series exercises and validates
> > damon_report_access() -- the consumer API SeongJae introduced in [1]
> > -- as a substrate for ingesting access reports from hardware-sampling
> > sources.  The series includes one worked-example backend, an AMD IBS
> > Op module (damon_ibs.ko), that runs on Zen 3+ silicon via the
> > existing perf event subsystem.
>
> Thank you for sharing this great RFC series!
>
> [...]
> > Why a hardware-source primitive complements existing primitives
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [...]
> > Both primitives produce a view of hotness that converges to the
> > true distribution over the aggregation interval.  For systems where
> > the address space is small relative to the aggregation rate, this is
> > the right tool.  On large heterogeneous-memory systems with goal-
> > driven schemes asking the closed-loop tuner to converge on a target
> > distribution, a complementary lower-latency view of accesses can
> > tighten the loop -- reducing the time DAMON's nr_accesses takes to
> > reflect the workload's actual access distribution, which in turn
> > reduces ramp duration and oscillation amplitude during convergence
> > of goal-driven schemes.
> >
> > A hardware-sampling primitive provides this complementary view:
> > hardware retirement records each access at its natural event rate,
> > with a physical address per sample, independent of TLB state and
> > independent of the unmap/fault path.
>
> Yes, I fully agree.  Different multiple access check primitives have diff=
erent
> characteristics.
>
> [...]
>
> > Demonstration
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [...]
> > In both regimes, convergence to target is quick, and the workload's
> > measured DRAM share then holds within 1.3 percentage points of
> > target with standard deviation under 1.3 percentage points, sustained
> > over runs of 15-30 minutes per target.
>
> I understand this demonstration shows your AMD IBS-based version of DAMON=
 is
> functioning as expected.  Thank you for sharing this!
>
> [...]
> > What's in this series
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >   Patch 1.  mm/damon/core: refcount ops owner module to prevent
> >             rmmod UAF
> >   Patch 2.  mm/damon/paddr: export damon_pa_* ops for IBS module
> >   Patch 3.  mm/damon/core: replace mutex-protected report buffer
> >             with per-CPU lockless ring
> >   Patch 4.  mm/damon/core: flat-array snapshot + bsearch in ring-
> >             drain loop
> >   Patch 5.  mm/damon: add sysfs binding and dispatch hookup for
> >             paddr_ibs operations
> >   Patch 6.  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp
> >             ops check
> >   Patch 7.  mm/damon/damon_ibs: add AMD IBS-based access sampling
> >             backend
> >
> > Patches 1, 3, and 4 are general infrastructure that benefits any
> > consumer of damon_report_access().  Patches 2, 5, 6, and 7 are the
> > worked-example backend (paddr_ibs ops, sysfs binding, IBS module).
>
> I didn't read the detailed code of each patch.  But my high level underst=
anding
> is as below.
>
> Patches 1 and 2 are needed for supporting loadable module-based DAMON ope=
ration
> sets (access sampling backend).
>
> Patch 3 is needed for supporting access check primitives that can provide=
 the
> access information in only nmi context.  It can also speedup the access
> reporting in general, though.
>
> Patch 4 makes DAMON's internal reported access information retrieval fast=
er, so
> will help any reporting-based DAMON operation set use case.
>
> Patches 5-7 are required for only the IBS-based DAMON operations set
> (paddr_ibs).
>
> So I agree patch 4 is a general infrastructure improvement that benefits
> multiple use cases.
>
> Patch 3 is also arguably general infrastructure improvement, as it will m=
ake
> the reporting faster in general.
>
> Patch 1 is not technically coupled with paddr_ibs, and will be needed for
> general loadable module based access check primitives.  But, should we su=
pport
> lodable modules?  If so, why?
>
> Patch 2 is also not technically coupled with paddr_ibs, to my understandi=
ng, so
> should be categorized together with patch 1?  In other words, if we agree=
 we
> should support lodable modules based DAMON operation sets, this should be
> useful for not only paddr_ibs but more general cases.
>
> Correct me if I'm wrong.
>
> >
> >
> > Patches worth folding into damon/next
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Patches 1, 3, and 4 are not specific to IBS or to this RFC's
> > backend.  Each is preparatory infrastructure that any consumer of
> > damon_report_access() will need:
> >
> >   - Patch 1 (refcount ops owner) -- any modular ops set, including
> >     out-of-tree backends, needs clean module unload to avoid UAF
> >     on damon_unregister_ops.
> >   - Patch 3 (per-CPU lockless ring) -- damon_report_access() cannot
> >     be called from NMI context with the current mutex-protected
> >     buffer.  Hardware samplers all need NMI-safe submission.
> >   - Patch 4 (flat-array snapshot + bsearch drain) -- the linear-
> >     scan drain is O(reports x regions) and exceeds the sample
> >     interval at high-CPU x large-region products.  Bsearch brings
> >     it to O(reports x log regions).
> >
> > If these belong directly on damon/next as preparatory patches for
> > damon_report_access() rather than living inside an IBS-specific
> > track, we are happy to rebase and resend them that way.
>
> So I'm bit unsure about patch 1.  If we don't have a plan to support loda=
ble
> modules based DAMON operations set, we might not need it for now.
>
> For patches 3 and 4, I agree those will be useful in general.  Nonetheles=
s, I'd
> slightly prefer to do that optimizations at the later part of the long te=
rm
> project.
>
> >
> >
> > Relation to prior and ongoing work
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The IBS sampling pattern in patch 7 -- attr.config=3D0 to use IBS Op
> > default config, dc_phy_addr_valid filter, NMI-safe sample submission
> > -- is derived from concepts in Bharata B Rao's pghot RFC v5 [3].
> > The attribution header is in mm/damon/damon_ibs.c and the patch
> > carries a Suggested-by: trailer.
> >
> > Bharata's pghot v7 [4] introduces a different IBS driver targeting
> > the new IBS Memory Profiler (IBS-MProf) facility, which Bharata
> > describes as a facility "that will be present in future AMD
> > processors" -- a separate IBS instance from the one this RFC's
> > backend uses. This version of driver based out of v5 [3] is an
> > example of how DAMON can be benefited from AMD IBS Hardware
> > source and validates importance of IBS information indepedently.
> > It is not meant to be merged in the current form.
> > @Bharata if you see a path where IBS samples can be consumed
> > by DAMON at some point, will be happy to collaborate.
> >
> > Akinobu Mita's perf-event-based access-check RFC [5] explores a
> > configurable perf-event-driven access source for DAMON.  IBS has
> > vendor-specific MSR setup beyond what perf_event_attr alone
> > expresses (e.g. dc_phy_addr_valid filtering on the produced sample,
> > not on the perf attr), so the IBS path here appears complementary
> > to [5] -- operators choose based on whether their hardware sampler
> > fits stock perf or needs additional kernel-side setup.
>
> So apparently there are multiple approaches to develop and use h/w-based =
access
> monitoring.  Akinobu and you are trying to do that using DAMON as the fro=
ntend,
> and already made the working prototypes.  There were more people who show=
ed
> interest and will to contribute to this project other than you, too.  I 1=
00%
> agree h/w-based access monitoring can be useful, and I of course thinking=
 using
> DAMON as the fronend is the right approach.  I'm all for making this
> upstreamed.
>
> I was therefore spending time on thinking about in what long-term maintai=
nable
> shape this capability can successfully be upstreamed.  I suggested
> damon_report_access() as the internal interface between DAMON and the h/w=
-based
> access check primitives, and apparently we all (I, Ravi and Akinobu in th=
is
> context) agreed.  Akinobu thankfully revisioned his implementation based =
on
> damon_report_access() interface.  Ravi also implemented this RFC based on=
 the
> interface.
>
> After making the consensus with Akinobu, I was taking time on the user sp=
ace
> interface.  When I was discussing with Akinobu, my idea was extending the=
 user
> interface for the page faults based monitoring v3 [1].  But, recently I d=
ecided
> to make this more general, so proposed data attributes monitoring extensi=
on [2]
> at LSFMMBPF.  The patch series for the initial change [3] is merged into =
mm-new
> for more testing, today.  The cover letter of the patch series is also sh=
aring
> how it will be extended for h/w based access monitoring in long term.
>
> I of course want us to go in this direction.  I believe you already had c=
hances
> to take a look on the long term plan and didn't make some voice because y=
ou
> don't strongly disagree about the plan.  If not, please make a voice.
>
Hi SJ,

One layering question I'd like to flag before the plan is written,
since it affects how this RFC's substrate slots in:

  In [3], .apply_probes is a periodic per-region classifier driven
  from kdamond_fn after .check_accesses, in process context, that
  applies a (folio -> bool) predicate to each region's sampling_addr
  and accounts the results in r->probe_hits[].  damon_report_access()
  on the other hand is a per-event delivery callback into a per-CPU
  buffer, called from the access source (NMI for IBS / PEBS / SPE,
  process context for page-fault-based sources).  These appear to
  me to sit at different layers - delivery vs. classification.

  The reason I want to confirm this: NMI context for HW samplers
  precludes the operations .apply_probes can do today (no mutex, no
  kmalloc, no sleep, no folio lookup that touches pte_lock).  And
  the data shape is inverted - .apply_probes asks "does region R's
  sampling_addr have attribute A?", evaluated on the kdamond-chosen
  address; an HW sample announces "PA Y was accessed at retirement
  time T", arriving asynchronously and needing to find the region
  it falls into.  If access events end up routed through
  .apply_probes in the long-term plan, the IBS / PEBS / SPE
  backends would each need a deferral path under it (per-CPU ring
  for NMI-safe submission, region mapping at drain time).

  Happy to be wrong here if you see a unified shape that handles
  both - just want to surface the constraint before the plan is
  written.

On the loadable-module question for patches 1 and 2: agreed it's a
genuinely open architectural call, not just a paddr_ibs convenience.

  - paddr_ibs (this RFC) targets the existing IBS Op facility on
    Zen 3+ silicon via the perf event subsystem and uses a
vendor-specific
    overflow-handler filter that perf_event_attr cannot express
    (dc_phy_addr_valid in IBS_OP_DATA3).  Bharata's pghot v7
    [pghot-v7] introduces a separate IBS driver targeting the new
IBS-MProf
    facility on future AMD silicon via direct MSR programming -
    not perf at all.  These are two AMD-specific HW samplers with
    non-overlapping silicon coverage and non-overlapping kernel
    paths.  A distro shipping a single kernel image to a fleet
    with mixed silicon needs runtime-selectable backends, which
    obj=3Dy can't do across exclusive `depends on` chains.
  - Akinobu's perf-event RFC v3 [akinobu-v3] is a useful contrast:
    it stays builtin because it's a generic configurable
    perf_event_attr passthrough, no vendor-specific code in the
    overflow handler.  The tristate case is specifically for the
    backends that need vendor logic outside perf_event_attr
    (IBS dc_phy_addr_valid, future ARM SPE record-format
    handling, future Intel PEBS DLA quirks if they need
    kernel-side filtering beyond what perf delivers).

Bharata, would value your perspective on two related questions: in
your long-term plan for pghot, do you see the legacy IBS Op path
(this RFC) staying as a DAMON-side backend, while the new IBS-MProf
path lands under pghot?  Or do you envision both IBS facilities
eventually feeding through a common HW-sampler primitive (pghot or
DAMON), with frontend selectable by user config?  And on existing
Zen 3+ silicon: is the legacy IBS Op driver in this RFC the right
home for those processors going forward.

Thanks,
Ravi

> Assuming you don't have concern on the long term plan yet, I will take ti=
me to
> write down more formal and detailed plan.  It will explain the overall ro=
admap,
> timeline and how we could collaborate.  On top of that, we could further
> discuss.
>
> >
> >
> > Specific asks
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > To SeongJae:
> >
> >   1. Patches 1, 3, and 4 are infrastructure that benefits any consumer
> >      of damon_report_access(), not just the IBS backend in this RFC.
> >      Would these belong directly on damon/next as preparatory patches
> >      for damon_report_access(), rather than living inside an
> >      IBS-specific track?  Happy to rebase and resend them that way if
> >      you'd prefer that shape.  Tested-by: tags can come along.
>
> I'm still thinking about how we can collaborate well.  The answer for the=
 above
> question would be a part of that.  In other words, I have no good answer =
right
> now, sorry.  Could you please give me more time to think more and share t=
he
> plan?  I will share the plan as another mail.  On the thread, we could fu=
rther
> discuss.  Of course, we could have DAMON beer/coffee/tea chats [4] like
> additional discussions before/after/during the plan discussion.
>
> So, long story short, we agreed this project (h/w-based data access monit=
oring)
> should be upstreamed.  But give me little more time on thinking about how=
 we
> will do it and collaborate.  It will take some time.  Please bear in mind=
.
> Sorry for making you wait, but I pretty sure and promise that we will
> eventually make it.
>
> [1] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org
> [2] https://lwn.net/Articles/1071256/
> [3] https://lore.kernel.org/20260518234119.97569-1-sj@kernel.org
> [4] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGb=
ZAH3mi2vpM/edit?usp=3Dsharing
>
>
> Thanks,
> SJ
>
> [...]

