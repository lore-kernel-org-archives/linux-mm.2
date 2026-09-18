Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAEE5C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64826B008A; Fri, 18 Sep 2026 11:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B9F6B008C; Fri, 18 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53596B00A6; Fri, 18 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEA56B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:36:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCA0280736
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:36:29 +0000 (UTC)
X-FDA: 85227284898.14.04A1431
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4D4018000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:36:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fiYfBM1P;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
	b=gFDMlZI4ZLXC1TQ/jh648vP+25x66VAXV8NsWi99p/fSryeTYobXRtiXbMhAwbvSM+oRy1
	mnUSZtogpa2UCGJ3XKL0Fhlmcbg0YiKyeMtb1mhXQ2rtVFwJ62XLqonGueC+Ny/5Lacdqs
	Y8g3yoXOiUgBytWfjJXf4hoGPBu9cNs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789745787;
	b=Uya9Gd0omP6UKcl/iUF26uNThHH2rtbn61pyGmlXTKFOH7CssSQo2cGqa+0R/qpcQ1NjYv
	/d9jtduQBmKeJ71+2FGbIIRIHfG6vBqKPhl2NgtteCXwTIN4o0aT7BSUdbBs2btgvEz++Q
	pSUHz/VNGq8FjlIBicizT13cBHcdVac=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fiYfBM1P;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a5f95a879cso10552a12.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:36:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789745786; cv=none;
        d=google.com; s=arc-20260327;
        b=okJp2J9HFP8DkYJpdJ3y2ss4jCKPGYWvJra0FIg60/j6LOyUW1Srdmi045KZwO2DWg
         LvnstoQZJ5UPNfVUJkUvRI0ihPjYOn5Tl59ZLhVpcTARMhwOIp/Ipce9G1I3oTtXxwQK
         pEas2jtkW/AjM7JQ8lE4F1ACPRMEVzi3GgbD2O5nZdb3jKgliWKUzuTqpPO/nTkKdC9e
         aMRqMvwSKOhgBhS91lnS2BCwfN9cPwp0NPFr3FC1nyZSnJ+VXXLwZv5R6r/aFbnBgvfl
         7afe331umJPZQ5c8raiqnWqAX4ft1ALpvpDrsY5st7aIjjpU53R3BLefF4RaqhmF72DO
         TlKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        fh=xQJH9fDq4J1cNRJfaMJ9cq/N2piDP4roO8mXagSg6gM=;
        b=VtkmYavslPFlDupQ6YZQB+A7NFYVmC1hcDKwnTlfnTtLkH3PPZTNnPexaedTxlsGDx
         3/4tJwK4Yqf5HUkNaD/+EveyqL6SBYjZF4beSUGLVKHOG8jC1Y+6Hacur5aMlwl7efRw
         kvwFJmrQq3buh1ZWfLxmCmGGQpXU2uaFVaQ0NaEuLkUJ3VGEtI2wOtLHqwqnDOyLnmBm
         ZdouzHv327GQA7fWjBrl10dO/HkK0x952OHVQLYHdZ1bvWak8Q5vms+HKerdtPDPOcVq
         Av27fjb03IqDUtk/TzdxNJQueJAWas5b3Fkn6yksm3zPkUr+TvbpUCfjD1jNK/aP+Qhf
         CZzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745786; x=1790350586; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        b=fiYfBM1PQqUhqGqdFBVO1usGniULeJk1Vj2vU54hfm9DKyZ6DGwmJBhoHNN4DRCnVr
         cjiiLqQNbTQhjebQifcZnrdI3DvHAJ6+S3dVjJnd8LqTcr2vFpLVMzrDZBfQ1D282SSR
         8PevzHnnjfQJ5qe8lSTxowJ+D9q5FmN/9P/5LIJLN4gRuiVz1FmatOFSKlDJRVXiCYgY
         PYo2C/gZaOyTka9CBERPIAmr37wniMduMMnuARF/voLgaouxiMKK6FXLXbR6PwtfAbyq
         a5CWAaiz1ZgKyP02HODBLbEifmD6yTCNcDWlK394jOHkhP7p3UET4IcLxbVaT7liRGrV
         W3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745786; x=1790350586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        b=oRHzLei1XLDyYZU9DSkHxt6N2Pu5vh/+ECYrXRi6OrTETwjVsmOcgCzEpbGBXmyEpN
         i7sgOccRzvmMvdAVJ5Rq0z/G7UfPhbVQbEVes82ABDBMbHCpBFfme8c9mydjMmgk/Shp
         LoQUB9AtjWGBGLixT9przZoAixKhITI9AYeWwmED3G6Qil/I+tPC9+htNlLBHGVtlNGv
         Vo4x3/u8KvN3LlX0E1u82uUqZtHXvg7G44yXDbji45XokoJBXEj1+GBUwrIsRFiI4FRn
         NSIKTWcS6Dguru4jCZ4f7/aXfuhTLgDhIKEtTcMMqr9QBLMbTcelxRSjtJMyvQ68+Kr9
         eGBQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZ+dWEg4T+Wrom+I2GGB6AxNeth37t8FZxtEOQNJGM5yU2Wco1iSfT/VIRC5wGknI5Ly8kGEo7GA==@kvack.org
X-Gm-Message-State: AFuF++n1nKcBDtxI8JiTm2LMnDbA2e2t4vkTdRziI4B6dyiW4K2ye5e8
	NrVMbVKXoOrhDMNigmGnFV5cxizP19avLq8ewY+ld8jF9bT6X0x6+onp7UWIBZQ/1iZ3ok47+Eg
	zmbNWU9eBt00iCZgvgUCjb8BkcBqoCBKLA42D30RJ
X-Gm-Gg: AYBFou3OhCKy2gOdcxf08IVkAqEEXaePqHn0BOJhnCszoGMLC/kvAMKIheXU55fyO5Y
	4N3ULqai6cGVl6YY0UgXeGHjwbF5Q75FBNBxpPBCprAWUYoCIh2U6kY484vkyl+k+wjCwUAJmdD
	fE4T/j4IrzhcSm4I6kpz9v5MxHe3Hval79wai3Kmf8uW2ZG3H6ypHUS9YusJReSODixdfEQMpIz
	tEQXUQacZMLlyyhtgHtVlBSooaCGs9zgH1ACLtS2SJs9A+93oZRD0T3opdchUYP9DN4IS26XH0Q
	O1Vm9cDgAFDqBEEoBlfWrXFbPQZcR7qoBc63T+bAt0BjRetT4pK+9x6iE7QhPJfuh7tafrn4RYo
	dqFSPKYPW
X-Received: by 2002:a05:6402:3449:b0:6aa:128c:36ad with SMTP id
 4fb4d7f45d1cf-6aa4e1d7573mr50813a12.10.1789745785854; Fri, 18 Sep 2026
 08:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <202609171758.049ApqPm-lkp@intel.com> <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
 <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
In-Reply-To: <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Sep 2026 08:36:11 -0700
X-Gm-Features: AcwNN1Xtk4GHei-55Tb0wPB1L8DqKluVg-PFcT9sdhWZc1O1R8UctH5wLSSENOM
Message-ID: <CAJuCfpG2cSnG30gLUauqdCKF6OL0=MD_bBB9gJ4J-XJHMuOHBw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6u4pnnscsbhh1rce5egxru66hm76gs5c
X-Rspam-User: 
X-Rspamd-Queue-Id: D4D4018000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789745787-728241
X-HE-Meta: U2FsdGVkX18zjYK8F+sOm7jYeslOyKlj61+0aX6iYF65NF49Nux9Sly0VLqi9+qsulR5Jv+IvY+MMrXl166Y73615qd/3w0P3E9SQVmJ+ho8DoFJCpw1Nguyls5oI+ko4VfCWhqQxMe8LNOu5l2eWmX42SG7CHjMz5YBjBsk9grqxqqNglxbjNsYZ9Lr2JWaFr3sqphbE9QQTYDd29c3beGy7Iwl1PVpGVHBbeIVuWPivKLTsjxilzXZrFMHsARnyFA+yHrgskWk+/bRMu896Np6ln5Ei67g4qdvSEonWyrwIBgsaKNku3pNDblAJtWBoznIWuPOiFECnJrIsLiXf1siHznHmL8xbPwWhjcH1v/gOtCq1dlhA2aq0NsILGgKJ/cpe4ShDKZoRVUQGriH2jPcAMyJFJoo4MoJRVde5w+SznKBgLe4YHdBHNEIrgMyddXjC7NfnsrqubXMj9qCehHMoso65UZu39qR4DvkR09CpE4Vwv8AqgrV9eRF/q5vWgq5JhaIFBR7JMdJggKCKjlheca/Bpob7pjCpcopuioiqNop7LdVJoWiqESibX4955RzBWD6U74Tmbbk/gYkvPEeUofCoA0kCcCRGmIHjTmmomT1/D4hCjnsq29BnXrXDBfaKgjmVSUzhW9alaluc59VPiH38XmCIAF89EEAN278WzrXah+8+kFBI8Fi74rjD5/ggyLwWOEjxnOiB9Y+x5zNPia75BsiOCQt1f+j1D7HKc00SEVMOd3eW/AAPQWRmDfv+qzxM/8jqdMuWIRfl9XeJNjkXTUjRiwoS5igURopR8HJGEJUfOLE6msFK91i9DegTbcwha0gFEmJkZWNhXoGYkkLELB4DoHppbI9QFphrg02JVQzg/3xShii+Z3L7/KT43tTLHRLGxIMa3n4cLzBYt7D65vrXPym6L4FmnDqbmRDQUgZCHUi14loelvvXHnKOA81oKVqChSNY2h
 A7SGKZjb
 moiGGhtYquVkE7MSJhDd2Ax6ZqNiwvnQaanEcLhl+cLIUB6OShRIEGBEiLu3yyP7goPlXciSBAB3ahJGKuhgVDBGIum21r6sPYXZXBAQvKTedaciYr3iBVH0fFoy64Ca+wmpYsELgchxpD/uZmUFcbliVZ59ICIQGIztlJ39J8hksu22hR8sBvpDgrd4y0/CfsdSOdU3RyQJc6jOU0GnRkCCZr2ahb35abGKUGpbGffr2BhnQFEElP75u3StxEfIrHT/wrrEcK0V36OaPWgE2RV1vUmRBgOKNHwyQKhJ3d9JoND+XpbswffiOoQE2d4THvbvZemXLL6KuC0LE68fs/TwmHTFgqoAM/EW3xS4LAvVsq6mjOOz17FplZtcAo6JZP18Ou14yetsCHOJFYVUCLJmsB8598dR6lXZCjtzQh0VpB6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:57=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 17, 2026 at 9:22=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wr=
ote:
> >
> > > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.=
git mm-new
> > > branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: h=
ibernate: atomically replace hibernation pin
> > >
> > > Error/Warning (recently discovered and may have been fixed):
> > >
> > >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@i=
ntel.com
> > >
> > >     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'dr=
op_rcu'; ISO C99 and later do not support implicit function declarations [-=
Wimplicit-function-declaration]
> > >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 're=
acquire_rcu'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
> >
> > argh, we already fixed this five times.
> >
> > Confirmed with x86_64 and
> > https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-=
lkp@intel.com/config
> >
> > Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
> > defined but not used failure) when preparing the planned respin
>
> Yep, I was planning to send the fixed series today anyway. Thanks!

v5 of the patchset is posted at
https://lore.kernel.org/all/20260918153318.758387-1-surenb@google.com/
It should fix all the warnings including lock_ctx_mm one.
Thanks,
Suren.

>
> >
> >

