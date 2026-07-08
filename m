Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8ACC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF516B008A; Wed,  8 Jul 2026 14:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FDB6B0092; Wed,  8 Jul 2026 14:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90C06B0095; Wed,  8 Jul 2026 14:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 959A56B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:19:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E91C12019D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:19:32 +0000 (UTC)
X-FDA: 84966422184.16.25E1D05
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DE4E20002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:19:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRlaibLf;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783534770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvE59M0ndf/4fDcKEHd9w+IMj7KO84feOQeZ7SzNxqM=;
	b=6HykfZh0/9MuVk9utkFnVMS/BkIO7U48Y8EDJ+mZXO7OurxFhl30kUHnK8hYs1Ec0opNUL
	NkI0kOmRRYKDHbxwywDvblQ+wS8ofNYw+N/eB2FpzQXalteCnCBLRP4ldbhT/uoRPPHB/4
	GP814NNABSGPIs8kpLbJ+CvlgRy1f18=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRlaibLf;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783534770;
	b=4EYrURRW5gM/ltGm9hYpO4BJb9/e1I9u6ii/NuWZkuirtf1gZm0N/wrDSkTIP8fK33lzA9
	MdlwloknI/LEpxT+IBr+OxmACrPtLsTpanylanRnJC74KALeGr7/vlFp9rnOLslun0Pe8Q
	jma59ROK2RnwKmex8nQkDMftuIQi1cw=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so6247955e9.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783534769; cv=none;
        d=google.com; s=arc-20260327;
        b=QLKdJUlvFi+9xMvgncwA+UXvejqxMS+aqGwVHNl/Qy/D7aEIcxq34IDRJYw58t/3Gr
         Wm+YE3qJ2W/kNklXR6Fc943OrKicUr06xQ/5Eh1qE7fnqbEG0OgxelfUhqFLOttw4wF6
         PfbJ6PNpxsLXf1wnDBgw3KrKhK79VHXxhiFJunjrL552h6BisvJVjloQTI6uNWcA/nL4
         vTEP/yvKIMZV1VJVH312rkLy/EYtwXAL1AjOEFnlqPCWsLHXqixIFHcWt4XJX1ZHmt4G
         7cbSieYtIBO8/r0bMau79QmZNLiTmRZtU7XYKUHPrhsLrgjUHDiumS7fTy+UWKCsbFW9
         rI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zvE59M0ndf/4fDcKEHd9w+IMj7KO84feOQeZ7SzNxqM=;
        fh=mN0/fNuRqA5ceneqWM//CvFfUWb2zbrWhroQhjtPb2A=;
        b=ZU5gE8OycJYxlrTkh+WDmaE+set2fQHKL06vwmR3wkL9U7lN7CZbr49Gcm4PnYnc/O
         AqiYTE9V69vO3QQXZkqjkuvdyzsnQuhCPs6+vQa4wK81O9rs+KSVF4Vy4GrMuqTttKIT
         U+0oXhjcyH1boMrcN3CiW35HIM0uOc5K/YZYsTcKUdLmlbtlCk13dHh64SQ0k9iJW19/
         PywfxfnBOWlkjfCYfvYSVlibtFJCC9yKalqYHipYgb/p6sLflXly7BwNEg1HRFefwYbc
         zcaBU6mn8jqk4S5M2fpDcesS6Ggf1NOgAJdOS9QJciqOqOO05+XxI8eH/s8mq2cATGVv
         l0TA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783534769; x=1784139569; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zvE59M0ndf/4fDcKEHd9w+IMj7KO84feOQeZ7SzNxqM=;
        b=DRlaibLfv59AdbjdHVOTyBLveEje/jcY8gYFfdZi8Md8K+UCt0cQ+sRcGM/HLC+Dcn
         yVcVI20zMvnGYyZYIt0E8fW9OmBIGtVDtw9mn6ek9y0RvSFhxrviVihJQ9Coq1jh1ycC
         Gv+uDP0eyusmVyPEhJv3qoSAxCTfzt9TIoGzpP3SBZeCQ13pi3AcCdKoWUiTxL8kvmwg
         S5DmlzBZJSNpej96q+1/CdYaza5pFMXSWnVb46AwMq4oYZEIlCBZa6Wg+kGevhvEih/K
         SPdK15adSEATwJX10M21WRkyI9kvhNEa5Da/BBDWCdqs1x6HLRgAxrG4XZ7DlKR9DG6i
         x5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783534769; x=1784139569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zvE59M0ndf/4fDcKEHd9w+IMj7KO84feOQeZ7SzNxqM=;
        b=icaEzIthdD5nV1sDi/yb0Rqqr3G2cq4G9gvejcyMzureqCQz04oC7YSKtB+69bu4VU
         22q6KRjl6NpOKMhtBz7o+HHdn5jN4CDq0Z19+urAJneN45MLIvmYUsoeflphr+NC6agF
         EhEj/VmwQekucLSDuW+gAmynX+575rH6NarVbn3PNaFQ4JFtPBVMY0XUNkd4w3Otlhe2
         lplidpIBAoluKWLs9H24HS2+klJUuVRInVqm7zGH336KaZkabDmk6g+33S2tVIouCqw+
         B9JomXap7N3/Ku2F7Wicdsd+6rBMZ9hztKYyl7isLL9ik7Z+mkuMwBilSy/VEVTrALmc
         HZUw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5+1vQBaJ3cIY6WnJNAde2hkkMiyXPCqp0Gpv7BfGGaorYtnSSzOWs1ASWSZBmUuEUsWAcAxv45Q==@kvack.org
X-Gm-Message-State: AOJu0YwCVlhsWHO72GlwAzIREl/3DH12E/kw1Ob4TRvjDkKMxI9zNNRN
	P73m+BC1CQvehDLKC+PWXOmtfpj+euThoz0x7oR3HEM8O/OD87kJg4x1HeENdT/yAKLVJtvxwFN
	kiV6Vephx3AsCs4NHAIxLk9qleuvXaA8=
X-Gm-Gg: AfdE7cmniBeWgJMV68PseVzVHoAOv5qSTEQ9r96gs9z+x5+ic//xNMEHoKnoTu3xZE3
	9EpYOP/SuTdYUrrSo5fBXREfnx3L+XfLQRcMM3Z11eaZxv1/obNmqU3m2mzYQlGOi4kyF1+cST6
	7DvgDP1bUma8iWXBs46OpC4vw9H/osao0EsnRSC3I1dB3EG3CLz1a3QLqeBHSxAiiL6hzR3jdpR
	8L7tQTaIeuMwLhpreDiGrGHfallrA7l7+rwh9Hj9fmmyFfkMMvw/weG7wz2iNEE+lt+I/aN6pJ4
	vCKqekqLZY+XAG9PmkDuy7ufzxMsLfBd48tiuHTRRy/hU4newp6y
X-Received: by 2002:a05:600c:8119:b0:490:9d1b:f086 with SMTP id
 5b1f17b1804b1-493e686ad70mr38349425e9.14.1783534768757; Wed, 08 Jul 2026
 11:19:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com> <ad31d36d-ac84-4053-a5d9-e18c346f3908@kernel.org>
In-Reply-To: <ad31d36d-ac84-4053-a5d9-e18c346f3908@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 11:19:14 -0700
X-Gm-Features: AVVi8CeWpX0QldNi-POQKw8JkEc5fSFnvmAMqbpDv4yyeIwIA8DZ6agkT4NSvag
Message-ID: <CAJnrk1Y-4-_0udtGKeva=f5=xYRCWcyCnBA_1aVQ8oUZRKGkAg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DE4E20002
X-Stat-Signature: b473c1qtmanq4tqx13ezs9hkuy73oiaz
X-Rspam-User: 
X-HE-Tag: 1783534770-553667
X-HE-Meta: U2FsdGVkX18ZCdjwMiyesAEFgxk86pZYMPqDndSLPJAuS7LPVpg7amy+EtKn0BVEsdMBuNvDtsFm/45K/z4BZLgsi82dJZzNcGEsuSPWbmseKTxVg55tMBa6WfcZDqj4jj0+dA6ekZ6ymyH1omO1+ghH9nIqqvPUeg7ZWD3GtbR0r5ryOon9EjMkNR2fIRGhjrP+FtjJx4pWjVPirTgUkmQ/S5c0S8eGds1uRRCB6+6M5J6m7j5isGY9LoSNlnvxthHpOcoLGxFTbpeUUw2hTdtrWGg1VPd4d3n2/DrDFUNQ1uUIZflC0rpMY2QxrbiklLx9SNp1ZaK3H/oTIArCUWnVY5572++RJYoJJII2OkGEKs3sdtoVkmHHHo/Al+bLIfWDPQzdnQvQXvKA+R5b9HxcR9+ijy0/oedpfuANteN+Qhb2WG7GBtk4v4+4TyQNG68rZ4t5XLYcaEz+uwmYSqoVthe2qTddiMPCEdxMLXpCxt268QXB87bQafak50W+Io9nLm6Yw6q4Rk/PgV73jAX1nn6mpcvx+VFFjKX/eSBOsR7DWyThboOguO6mYgqYdgLUF3t9+12AMjwW4M5n7ytNwTwogitAoNfkbLFN7sAmT+a9shzHu2rP0RYDzOspio86dB9RY6say9hzR2x5mNqN4ID4PpmBVN3/ekFL6A0/CleAjflMxyChSsdJtvj9dVS39aPzPKNUo+40cTRxdFsN/M213jRO+z/4Q5+gfoVvrFpZ+K2Hk6DzAQo38XRBahtSe9Fy8GsH+ovmzrrBIUwZscUWc35t2YSxIOshN7VRycFwBHgtFJEDw6u0Qyyb/JU0Kw2SHV1FPvqgnVW+ZxY5dAjcl1bMX0wl4pglZ0EfhMOd6QJ4LfH4v/bR2sRpH/93leZzsIXz2ciL6ElXLfVpZgA63Jk/eWN3nryjlEey7WwL6W98/zQGxRslonGGsBJAEp/QCkzaP96xp05
 56VU88/I
 MijAU+SGwAjySezcJcrKwC7dOV7cHQD2SF/qe1gSIg3vyZAiBrCUSw9DPaobxHixnOeIUZ0pe9gNEcN0OXWCjjZo1MgDAms1v3OE5Yrwxsqkklqn8t63gxf5hLF+BQh2Ir0x4L90qFn4/Rrq44UrEwDILwkrVvJRI0hv7yDyrwGjj+MN8V86mpN+inPM8mwmh4myjoR9sZOalNEhRT0wzn62PchwUaB0urK19b971Sl0BHohte49Ijf/HXibn0EHlrFV69cdqbFRwNq1PE8/FfpNbJ4FPH1tSFzZXWvlAEsWTPcKh3QZdRJI6LP/6+UnqOStc2A26oV9+s+fIFg7pVIdP+mxKFhia34DgA6j20Xo19tfhfP3RjDtHLpwsvCx7+d7ITd8viRR5VNAtQFOFrrjU5wr1sb5i/lC1tqlR3dhpZxgQW4IWT11nhw8yJb1FFBCq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:47=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/7/26 22:17, Joanne Koong wrote:
> > PMD-sized THPs that are mostly zero-filled are reclaimed under memory p=
ressure
> > by the deferred split shrinker, but this is not done for mTHP folios. A=
t Meta,
> > we would like to deploy 2M THP=3Dalways on ARM (with 64k base pages), a=
s 2M
> > provides contpte benefits and 512M is too big. However, 2M THP=3Dalways=
 will
> > result in a memory regression unless the extra unused portions of THPs =
can be
> > broken down and reclaimed.
> >
> > This series has two patches:
> > Patch 1 - makes thp_underused() work for non-PMD-sized folios by scalin=
g
> > khugepaged_max_ptes_none proportionally to the folio size and using tha=
t
> > as the threshold for how many zero-filled pages a folio can contain bef=
ore
> > it's considered underused.
> Did you look at the khugepaged side, and how we handle it there?

I'm not sure if I'm interpreting your suggestion correctly - is your
suggestion about using the khugepaged mTHP collapse threshold in
collapse_max_ptes_none()? I had looked at Nico's patchset in [1] and
my understanding of it was that the mTHP collapse threshold currently
only supports values of 0 and HPAGE_PMD_NR - 1. The patch 1 changes
use khugepaged_max_ptes_none's value as a proportional per-order
threshold for mTHP because 0 and HPAGE_PMD_NR - 1 are too extreme for
our use case where we're trying to find a middle ground that keeps
mostly-populated 2M folios whole but splits mostly zero-filled ones.

Is that what you had in mind or were you pointing at something else on
the khugepaged side?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/20260605161422.213817-1-npache@redhat.=
com/

