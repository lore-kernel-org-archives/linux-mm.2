Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9DCC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 18:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAFC6B007B; Sat, 25 Jul 2026 14:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474236B0088; Sat, 25 Jul 2026 14:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3151E6B008A; Sat, 25 Jul 2026 14:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEA0D6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:18:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72988A137D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:18:13 +0000 (UTC)
X-FDA: 85028108466.19.53A18BC
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7E251C000A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:18:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4IYunfC;
	spf=pass (imf10.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785003491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixVLAHRCO1Q0YANd6J3Qvx5KyOmIXzLJW15kkmWqcs4=;
	b=wB5OsPb1KfYokgSkWPGDInS/oVivm8vQy1UatMWsU0juH97se/l+LZb9Orwb8rcGSiiuDS
	XJM+IRtE3+ptGWB7O8CQqFctyiOpPSlkRDCblPnYH8dK2LAgZHgX7jKqM38/+rnDkW8yme
	XfWBjGjybEnF2wDYSlgqf+n80Wv8+V0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785003491;
	b=OpWXloplf+O6zKsD/vSA3oYuqE8jM4519qmzYOukRXWMvIqvS56bIUY94Y55H/gjh/+l/w
	a3OEKXSkNZhUnEeP94IdWPv3C24ZhdInFD4VE7hVXYKiS3/Ld8DFSCAq7Bj6FK3o7R+evH
	ehtwuG1W/bLUHcAeoyo1HBPOSh3HJjE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4IYunfC;
	spf=pass (imf10.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c15a5b265so178851cf.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785003490; cv=none;
        d=google.com; s=arc-20260327;
        b=b/JvZzvkaElklCPbZJPhkPxSFS/cXNFdjZLhRMheRG92IWPo18EZ4h8PJZei2obgdN
         0dJvTi2YJgZ1WSfTLljMoWLEJbjfx1JhczzLilEXlieS75BXEEE9/kVZq9p8UGdLQ5Uc
         6toiwPwEL6DwKdITPYyO5Q2vhHrHFpFI2NdA/y+WB8zpsN9dtNZC4kAuZ36dZZgg8WWy
         Mb8EQ4+4rWdKc+nzYJQFRYX4KI7YHT8v68vYMlzhd83iHUKjaZWx1VMpOged9RjFnMp0
         LgjZEViHvB5IhVwsMm5T6aEkhFAI2H9UHR97eWQdNbyygSNegH9jzu4KGeCc4pTHCwcb
         z2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ixVLAHRCO1Q0YANd6J3Qvx5KyOmIXzLJW15kkmWqcs4=;
        fh=hMUzpCOmVeRTr3QCrNDLCscBE7I+NVFKKqnt5vnGxwo=;
        b=m/mz+XhQ3H5P5XcYT3Zw20tMvo4alu9svtw/rDOkFbAI+ydT0P/5Hlost1dpRfkxUY
         fpiLORr8gR6BrzSJW+/38qj60hvSgRS2NMVh/6/gI2/902OV4lAZ1ewQLbIN85JYZbHm
         IIoHmDp94mBJfitASqnAHCjFMOKEgylw+ls1YhtvdP1CkheK5goCahqPA/94fwX36CHH
         Ag7nqmfP5MYWdxtlgn01GLkRqfqYufHbIgP8CNDUyBe7mgzIXmrq0Qut8wFf8kOwwG/U
         jLDlimyvHBQ7/2qbPAw8UgM8jze7FgxvFVO6GmyTd7DC6pr9FiKrLkdz5Vk8GdRiuOmw
         5zbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785003490; x=1785608290; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ixVLAHRCO1Q0YANd6J3Qvx5KyOmIXzLJW15kkmWqcs4=;
        b=Y4IYunfCefmVuyglCcMsjvA4Lm+zHbEYxA20wBilpsnttuZjI/3pERKHhU5F7Zw58r
         7pdsRSwTOAlCzY8B5JFqBz2u9oyjumsSruueMZQ+ommqAYfn+nl1/NpXgT0ozH6E3adu
         pk/wFU6lybiOsBkKsDCM6ZqRkIi7IxPo6KedJDzMcRc0OOIcgiok79GPwVTWZgGr4HGn
         2BZwrssO9LoHMLOf5z/Ea3EqCYCBoQ3XxbopWddHLhfu9pqJPOYVLplPu+Rroz+xewwH
         wqwAi4wISizMe2vi4e8btBL2bWyN2pr6GqFrZAAuhVPk6b5rpl71Du1fprE7F+tSNd6x
         YS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003490; x=1785608290;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixVLAHRCO1Q0YANd6J3Qvx5KyOmIXzLJW15kkmWqcs4=;
        b=DZOUWWkxHeKVu1HJbluTgWRf2jeNx3+n7NM/BQwdpokH2hGyYxBPxvUz9ABSs85U32
         M7SWK8GA5yVUcxhFDgj57wtelwtt1rRd2vTuI1aw7FNGQxCiqJcVlbess7dcBasG2r2a
         5ojV1kP11InXcKrLsVO/xgdiBH+9YRR+wVDvJnTSvCiDCmXcOVlBjLmwLSZy4NaBk2WU
         HcmHeJEuKLLDMP5k2AWuThx7z09tWCmc2w2fT+sAUE524s3LjXn9d7fltm6uZtXPByWL
         9iP3YYiwQj5VT84knY7Vzbf9RPE28CPk1x1PTs+Fvqn2+6mVgOb9Y2Tp77nEPnUUvVsC
         k9Dw==
X-Forwarded-Encrypted: i=1; AHgh+RrIp6w9D5+tvaKiFSGgshhGCUT9OFFd9y/gtm2Se9ZZr6AVX5bOFqdNOXbhMl3gaA0weGvsZEV4mw==@kvack.org
X-Gm-Message-State: AOJu0YylvUp+EjO7ntPVODlsiNcDwpD6sPehvkgRIfeCXlr3aW2V+CRK
	4FD/dIvEif0qwuaWHh8BBNZKyadgt+pxkxnN5Wp0LHYx5EnNRNCHKUMqd6rFrtal21MevpYV2F2
	Lql0LQDioQqBxXdjY4L5w1rPdR3RALjaFsNS0Gm1y
X-Gm-Gg: AR+sD11bbCjm6mWo/xtl0nHFLzkSoMfWo8losvkBahPfonKx9PIsaoSiLmZiXemDnke
	dQfRNkE0YwSASTV5XcRtZW+i1FjcmHPYKTkO+Yvxu9nU3HlUFbpkfg29yZbZ+kH0yoU+46DJXIY
	fcaSDfSIqanwho2uAYKUYpd4iptX7GCs6yWZp5oC3OqNGN+cFlN5lg5kuAkzuMhty1SfAH3O78j
	6zU5mrPrMOqehEE5nFO+hwW2wjph9SGEiV1F7X+NuqY80sKtcuWwKJUCgoAvkDzh6XRlpTwlsdY
	z9KNB53cMTr+nMspTxo=
X-Received: by 2002:a05:622a:8c03:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-529a5db7b6dmr14935361cf.4.1785003489862; Sat, 25 Jul 2026
 11:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260722211517.1898228-1-pratmal@google.com> <20260723000609.95657-1-sj@kernel.org>
In-Reply-To: <20260723000609.95657-1-sj@kernel.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Sat, 25 Jul 2026 11:17:58 -0700
X-Gm-Features: AUfX_mx7laTIppjMuRwceZdhrzpXvPvGAkkLzCUREO5VEIVPMUl2xSPjO0AbX2U
Message-ID: <CALHaPKd_Ytknjg7GFBXeQK8kXvE7DhbyX_een7k5Fti-ahxL0A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms sysctl
To: SJ Park <sj@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: faxgsw57dub8tdpzq987yfacz9ipjc6w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E251C000A
X-HE-Tag: 1785003491-223503
X-HE-Meta: U2FsdGVkX1/bqA9lnu1RG6lf0NrIundpEsg0Mondiu7J16JTNwvreHc6rFz7j8uDiC5EvsvVGJ+gST+UFaFs55PzMrYUyjszFPJNw5owQmDpchRwaEfdxy4DdRVaMZEdBQrlqI3dcHWbg2LY8EC3/eDsu8Lt57pQKin49ADw4yt7mTShUtNubzzBuzGBMReIbU3PlDjFsfLO9o+ibcZR0BJYi1OWy4gR/P5m0Oo1OUK/ENV2zyPiJpe6uxn4tJzCqDuK8HCqKZXVWPZNux78TE1N2QLRtaCoN0AUou98QsmvnnRopAcDC7D6Mgq5WVLMoB3qPUqSUuVJXE+nK19fOAwDiaJmI15IE+L5EzAEJDPjMGq4VrVx4YINrLU9u0RqHIiuCP7dSE+9JXzo20O2thmAVEGmgMEsb+Blc2kLJ0zEjVlToXoxuQ6L7+kQHumN8qubWyo4m7rgM2LlmWGwAkpw7W2pWo3B8eQ0Z4m6bu98hQdqR4c25xMcHqigqXeLPkuS2t/HAgnscDrzdCX5F1Tx6QzLVQRT8DRGEnXa510jxoayatPSbTiLeEUO/qPjrJedMPT+mEwK1MTRYgXk4FqecQEWVs8YEGDoO6e9+BsG3X9U1QRrfTYEPeE8XxlYwdCmMyPIWje7BLn4uKCJzknnIGQFZmAs3yl1ysO8K7PfSP2j6hgDsaO73U1m9tkPja5xyYRU6tiH61G+e76XzHdyzstNBtdB5uuY5rWdRpDgakEtwcHmPprIR5wwMsVSzTjJGBnEJoZFKZ9KMwkITjYMVeJ6v+h/c6saMRNeQMMkC2zmxtFUdSfDE+MH/m4kXePJS3Lwp/iKBv3DqvbfL3pTyCejIaAkx4Zddh9b4gz8bf5Q3u5805ChRbpzfzkDjmuJHGGTONe/xd/ZiDyi0S0irCN5glivHNCslHiRTbts6qqIeiqKheeRC7dL2OBW6FyZwgUP/oHX/5571bg
 jUbqqG81
 T7nR9u1TOLVSJCucG7SCwNVmqOEc/VnoWuA8qQSONlaWx1OnEBOzfTAqsKGMEmUqpet3YnhRksMMVVGfoZW5/EJLnAElKOhE9nu72cC4mZuqbZ9Da3vrwSlx7f3GEieRpdlPXsYjBWr3YVg06uyPsR8+XCVxQpQM8x7qB59iHXR4R0+wWbmjBm0d/h7w0O0RVwSYAIXyR3gv1Ay4cFZBh66lrr2Rja7nyXgxm8TWJDgxoRfsaMrm3H2Yu2I0iPhc2v3Aa6pAtixIzk51bO1D558ytRu++0Ug0VXkoJOgDGA6sII7IJBUBGzJGE1IBg7Bo4U9waEIhU2k2kadjBpVYRa8CbDLdHk1AaWSW9xl3K+5jNl/zwpK9zrCMXkjnFwIgvDkcqumExXmzeqR2r0bZJFqTNBLJmlkyE9mwdv1oiQbbK8zdk4EKjfoz1FTU86vFLKU9bUNqI1qflss4vO69TWYdqeETTpJSe1YtJKQWh1cCLoEpg+kW56hJErzYQx5uavg5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Why don't you make the lengths of the line and the section title same?
Will fix the RST underline length.

> So it is milliseconds. Why don't you add the unit to the name, like
> page_reporting_delay_ms?
Agreed, I'll rename the sysctl to page_reporting_delay_ms.
Also I think it would better to make this a module param to be consistent
with page_reporting_order.

> Also, coule you elaborate why there is 10 seconds maximum limit? What's t=
he
> problem of having no limit, and why 10 seconds is the reasonable one?
I don't have a strong justification for where the maximum limit should be s=
et.
The value is unsigned int, so it's bounded at UINT_MAX ms (~49.7 days)
So at worst the worker just schedules that far out and reporting
is effectively paused for that window.
I'll drop this in V3.

> Too trivial nit, but, why don't you put the sysctl.h at the end of the li=
st?
Apologies. Will fix this.

> A trivial comment again. Why don't you wrap the above line for 80 columns
> limit? [...] seems most lines of this file is still keeping the 80 column=
s limit?
Apologies. I will fix this as well.

Thanks for the feedback.

Thanks,
Pratyush

On Wed, Jul 22, 2026 at 5:06=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> get_maintainer.pl suggests adding below to the recipients list of this pa=
tch.
> Let me add them.  I show you already Cc-ed David, but with his old email
> address.
>
> - David Hildenbrand <david@kernel.org>
> - Lorenzo Stoakes <ljs@kernel.org>
> - "Liam R. Howlett" <liam@infradead.org>
> - Mike Rapoport <rppt@kernel.org>
> - Jonathan Corbet <corbet@lwn.net>
> - Shuah Khan <skhan@linuxfoundation.org>
> - linux-doc@vger.kernel.org
>
> On Wed, 22 Jul 2026 21:15:17 +0000 pratmal@google.com wrote:
>
> > From: Pratyush Mallick <pratmal@google.com>
> >
> > Currently, the free page reporting daemon uses a hardcoded delay of
> > (2 HZ) between reporting intervals. While this is a reasonable
> > default, it lacks the flexibility to adapt to varying guest workloads.
> >
> > A low delay allows aggressive memory reclamation, returning unused
> > pages to the host as quickly as possible. However, during spiky
> > allocation/free churn, this immediate reporting can lead to a severe
> > performance penalty (nested page faults) as the guest re-allocates memo=
ry
> > that the host has just unmapped. In these scenarios, there is benefit
> > from increasing the delay to batch free pages over a longer window,
> > absorbing the churn without hypercall and re-fault overhead.
> >
> > This patch refactors the delay into a dynamically tunable sysctl,
> > /proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The val=
ue
> > defaults to 2000ms to precisely match the original (2 HZ) behavior.
> >
> > Signed-off-by: Pratyush Mallick <pratmal@google.com>
> > ---
> > v2:
> >  - Documented page_reporting_delay_ms in Documentation/admin-guide/sysc=
tl/vm.rst.
> >  - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratma=
l@google.com/T/#u
> > v1: Fixed feedback from RFC.
> >  - Added lower and upper cap to sysctl value.
> >  - Reverted the reordering on page_reporting_delay_ms.
> >  - Dropped the mod_delayed_work() change.
> >  - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratm=
al@google.com/T/#u
> >  Documentation/admin-guide/sysctl/vm.rst | 13 +++++++++++
> >  mm/page_reporting.c                     | 30 ++++++++++++++++++++++---
> >  2 files changed, 40 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/ad=
min-guide/sysctl/vm.rst
> > index b9b0c218bfb4..6efa460b4547 100644
> > --- a/Documentation/admin-guide/sysctl/vm.rst
> > +++ b/Documentation/admin-guide/sysctl/vm.rst
> > @@ -66,6 +66,7 @@ Currently, these files are in /proc/sys/vm:
> >  - overcommit_ratio
> >  - page-cluster
> >  - page_lock_unfairness
> > +- page_reporting_delay
> >  - panic_on_oom
> >  - percpu_pagelist_high_fraction
> >  - stat_interval
> > @@ -896,6 +897,18 @@ stolen from under a waiter. After the lock is stol=
en the number of times
> >  specified in this file (default is 5), the "fair lock handoff" semanti=
cs
> >  will apply, and the waiter will only be awakened if the lock can be ta=
ken.
> >
> > +page_reporting_delay
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Why don't you make the lengths of the line and the section title same?
>
> > +
> > +This value determines the delay in milliseconds between free page
> > +reporting intervals. A lower delay allows aggressive memory
> > +reclamation by returning unused pages to the host quickly, while a
> > +higher delay helps to batch free pages over a longer window, absorbing
> > +allocation/free churn without hypercall and re-fault overhead.
> > +
> > +The default value is 2000 (2 seconds). The minimum allowed value is
> > +0 (immediate reporting) and the maximum allowed value is 10000 (10 sec=
onds).
>
> So it is milliseconds.  Why don't you add the unit to the name, like
> page_reporting_delay_ms?
>
> Also, coule you elaborate why there is 10 seconds maximum limit?  What's =
the
> problem of having no limit, and why 10 seconds is the reasonable one?
>
> > +
> >  panic_on_oom
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> > index 942e84b6908a..805da4bc1101 100644
> > --- a/mm/page_reporting.c
> > +++ b/mm/page_reporting.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/export.h>
> >  #include <linux/module.h>
> >  #include <linux/delay.h>
> > +#include <linux/sysctl.h>
> >  #include <linux/scatterlist.h>
>
> Too trivial nit, but, why don't you put the sysctl.h at the end of the li=
st?
>
> >
> >  #include "page_reporting.h"
> > @@ -47,7 +48,10 @@ MODULE_PARM_DESC(page_reporting_order, "Set page rep=
orting order");
> >   */
> >  EXPORT_SYMBOL_GPL(page_reporting_order);
> >
> > -#define PAGE_REPORTING_DELAY (2 * HZ)
> > +#define PAGE_REPORTING_DELAY_MS_MAX  (10 * MSEC_PER_SEC)
> > +
> > +static unsigned int page_reporting_delay_ms =3D 2 * MSEC_PER_SEC;
> > +static unsigned int page_reporting_delay_ms_max =3D PAGE_REPORTING_DEL=
AY_MS_MAX;
> >  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly=
;
> >
> >  enum {
> > @@ -56,6 +60,19 @@ enum {
> >       PAGE_REPORTING_ACTIVE
> >  };
> >
> > +
> > +static struct ctl_table page_reporting_sysctls[] =3D {
> > +     {
> > +             .procname       =3D "page_reporting_delay",
> > +             .data           =3D &page_reporting_delay_ms,
> > +             .maxlen         =3D sizeof(unsigned int),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_douintvec_minmax,
> > +             .extra1         =3D SYSCTL_ZERO,
> > +             .extra2         =3D &page_reporting_delay_ms_max,
> > +     },
> > +};
> > +
> >  /* request page reporting */
> >  static void
> >  __page_reporting_request(struct page_reporting_dev_info *prdev)
> > @@ -80,7 +97,7 @@ __page_reporting_request(struct page_reporting_dev_in=
fo *prdev)
> >        * now we are limiting this to running no more than once every
> >        * couple of seconds.
> >        */
> > -     schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> > +     schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporti=
ng_delay_ms));
> >  }
>
> A trivial comment again.  Why don't you wrap the above line for 80 column=
s
> limit?  I know that's not a hard limit anymore and I show a few lines of =
this
> file already exceeds 80 columns.  But seems most lines of this file is st=
ill
> keeping the 80 columns limit?
>
> >
> >  /* notify prdev of free page reporting request */
> > @@ -340,7 +357,7 @@ static void page_reporting_process(struct work_stru=
ct *work)
> >        */
> >       state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDL=
E);
> >       if (state =3D=3D PAGE_REPORTING_REQUESTED)
> > -             schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY)=
;
> > +             schedule_delayed_work(&prdev->work, msecs_to_jiffies(page=
_reporting_delay_ms));
>
> Ditto.
>
> >  }
> >
> >  static DEFINE_MUTEX(page_reporting_mutex);
> > @@ -416,3 +433,10 @@ void page_reporting_unregister(struct page_reporti=
ng_dev_info *prdev)
> >       mutex_unlock(&page_reporting_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(page_reporting_unregister);
> > +
> > +static int __init page_reporting_sysctl_init(void)
> > +{
> > +     register_sysctl_init("vm", page_reporting_sysctls);
> > +     return 0;
> > +}
> > +late_initcall(page_reporting_sysctl_init);
> > --
> > 2.55.0.229.g6434b31f56-goog
>
>
> Thanks,
> SJ

