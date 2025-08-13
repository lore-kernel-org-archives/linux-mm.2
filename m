Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242B0C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA12990007D; Wed, 13 Aug 2025 09:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7868900044; Wed, 13 Aug 2025 09:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EFB90007D; Wed, 13 Aug 2025 09:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99DCF900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:49:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68308116D8E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:49:48 +0000 (UTC)
X-FDA: 83771867256.25.DA0A7FE
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8549A160010
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:49:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hcX0c321;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5COPJ1bhIrlUBdoMgcmCT1dlQIxGjY3lpdJsY0vxHvo=;
	b=8qFtYTcvdtXhxT9bUaxoviKBYnpL1443dKGRdUluaz+zpgmQKihOFSGVX+J3LBA7EUwxsd
	qVCG+qFwc6DflNy5eRF3W4/TxDep9g6PkMNhQ+YmeJkEOvtto2PKnFzkIVcB+Q3hQN0uZc
	lh2S30W9pWO29O6R6m9BtuiX7jhwQNg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hcX0c321;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092986; a=rsa-sha256;
	cv=none;
	b=LkxHS+nUKojfr5fPrV9LE7NeE58aL1I2+1X9oAm7W9xvOCuayyUXzzxDql2asoS7ieUR5Y
	Ua+hkTvb4YTu9nNDU/RA7OMBeXZeS6lNI2/Un2yUUeKnuoZdCeqSXFGx+gh0wgsHz4uwo/
	cwuOpHSatu7HYzvhBOUov4fJZTH0+Cs=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b1008221dcso3369601cf.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1755092985; x=1755697785; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5COPJ1bhIrlUBdoMgcmCT1dlQIxGjY3lpdJsY0vxHvo=;
        b=hcX0c321o4UaSBrmhDuWjTaDv6ftfIFW6FMthPB7ClbfbD5I+LCJV+feNIniWhcKpQ
         TbUlKuCOK0jjzeyGsw2BnPKTOb5n3phkSiO7DkawITgV8O9spW+TuAcCVOTaXAp+nHzQ
         JwKu+KLUAWXYqc0uqKGGOjH4w9O/QbszSkY1bnYUFZ5gmXQXolfVBwf/NltUbM3vIubn
         Wrnq0VCZDeg6JMIGzPNbzzBCGIttbn6gEONyzy2rjerIvW4dv8PhVGA7cHqAk77QzkqK
         /W/QBpo0J3g2pw2jIq//mobriqCAdAt1riiVuRdP9mgdn/4ogFIBUmWxAWAd1jDOjb02
         Wpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092985; x=1755697785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5COPJ1bhIrlUBdoMgcmCT1dlQIxGjY3lpdJsY0vxHvo=;
        b=G4pgDpQPi/8mq0YtbllMq4m3MYKiiPFBUshLP9mMATtUY2LOL/RIYW0tB//7SxmT31
         Fbo2zW7yz1LNoDF7DluVRNMpoVJUYD/zMdRcZw0M0Ks5kyyxi8ny38y+F/oUTcHdrLHo
         zHUtRrl+piFAmJMEaTQYmvUwkjvDk2B0OImH3syt4SN4wLRQ9JmPMel/wicp1DSPTyvT
         eaK8gsaBiIboOAln0XWV/h3+j+8UvLxRNL9IuNy0vueJI5cE9gVkOZdVKAHTDrBpeUPp
         Swo3RtaMRJw1k/Tf6X2LrHFjJA7IqQytenttQB5KaLpojV9KIdtjOwJP7Bp+H+iZ0aKW
         d7sg==
X-Forwarded-Encrypted: i=1; AJvYcCWwbvihrScWUgK6spk6jZlgJC9ooJcBpN7Wj6Zw9UA2od2eeCo7Fn7INrU27IKZI+arezpoEljn5Q==@kvack.org
X-Gm-Message-State: AOJu0YwNK232BN/QeBP43LDXZ+LsTUDsyXEX4m5e/qlbQJGB+t45swQl
	OgbCkCV07HGhkirkehnsVcts0w3e7+k9SzJHa4I5rP8mVOnASlwBRLyqeiLEzBOuozDq77KmRtW
	wjyVUJ5dMSeiVtLpGevjNqk9XuK5QQmR4soGPz8sK5g==
X-Gm-Gg: ASbGncvUbTff4BY0bJE8Yb9JHeUJutcwebLrBmziivs8VNerEBsSZVLDZGXh+yghAW0
	45i6/xWJltr0zIOr64KirrInuR4hZgy3EhNUGR19kCSDOX6Z9TD0OcsV5gcE6Te1p5EYih++VO3
	EjtxI8PeQzQ6AHAYXq6WUkUpLECUwEeBB2bSWqMTdH3/o4UCf8qY8wRY7GrQRNiu806afwUjkya
	Wrc
X-Google-Smtp-Source: AGHT+IGct8ZeidsnGi/YbFJu4oMvwbFYwPG2diux+p27hnjphdKkPPw2dpGSZ3mXdM1D29x0JXCw0Y4/KsFGm7KlPlM=
X-Received: by 2002:ac8:5d55:0:b0:4af:4bac:e539 with SMTP id
 d75a77b69052e-4b0fdfdb678mr31989691cf.3.1755092985396; Wed, 13 Aug 2025
 06:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250813063407.GA3182745.vipinsh@google.com>
 <mafs0wm77wgjx.fsf@kernel.org>
In-Reply-To: <mafs0wm77wgjx.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 13 Aug 2025 13:49:09 +0000
X-Gm-Features: Ac12FXyj1CElzNmOfajT8FxAkTu6tjsBaL5e4YwqAjZVvEs1xx2b7a4U9Pkl3Fk
Message-ID: <CA+CK2bCmQ3hY+ACnLrVZ1qwiTiVvxEBCDNFmAHn_uVRagvshhw@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pdazmykyf4dkrp69wquc7a4ewtcxjtw8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8549A160010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755092986-150028
X-HE-Meta: U2FsdGVkX18OO2LVYy4BWDsTMhm5Qi/rlU63QlR1xP9LivO6lRFsRbQWECey3JqFjQKiY3acXQtI/J1ffR6fEAHIz8qY0n7cW4EvIcfbmqydp7GUbHcK0G6McHTOrb1SgT5rSsKb7cwG1wo44qkPOjwnix6BuJYAi/u9CVJYsAuIiLwBfZL/ZstGgKC3Oz49vhpSfIBVrJo6Q7jSTBlWlxPv2bVnz17aMb0S6NRFLT9WddLUGj3v7EufbgKvc0gZvSD8smoCMJnn7l6DARsDY22jLNkXGKE7f/Ekjvx29Q3AfcNe0lAI7+CrPeW4o+wNSihUl2im2gwRWch3fD7/YGiUk8EQnOqpT6pqxaX9eLVJggqRYL5W2lD6SYuXz4612RorHvk8psNk8AnP0XJywMZ9ClPxQZba6YfidWbiLogxXh43jyRFsScAhWZnfsYfwn+DKRZOtVHg0MElccxqtKXGubBP5bwKRyur4vhwCi+oHOtBpDtB0/zRc3iIr6XEXp8PZPgk6w1hWBRI2S+StQoHydERhccc2wgQie3QyRyCNCjXfHr+SwjUvuFgw/c2YwHh52UiCpvLR4qFgfNweNk30thMehm6Jp/bM9IJeOBfbx7dsXG+61qjCR9HSGAHzSOmUSsPVw2KYFon3NpH6GlEywvl087bESi8ssr5ds3NJ/GjzHuGbbSLfSauE0rpknoJQ1wDzuT72TrWbU8eV9y4R7jgFuMMRSRyeC8OA7ew+bOrJE18URJrf6rN0rIcwCPU2tSjEr1hDLOD+qPytkdQ/OJfQUXcPIEYszRxwBpDELkN/cKNCSJDU2vFk5LXVss9ZJiVYUqGdoUOxryhH8LKPX0YN2h4sxKrSUSyZpLA2ysOPtXCsx/NaumfA12K1juJ0Vs9h6xD6PjBRLCH7ITx1BoTienvMPdTpvT4flpvdY90Tj6iRJV8IkS/uiM6nxSu0TVvsae4wKWoTQf
 Ob20Gsg0
 p7l8qa8eTvpOQsybC1L3XosfyS3NPgBUYwC8yIIw2r9vHeyHEJM752VUqzDCoYUaTKHuizYHcwiCya9iXl53NVaM3fJ/R1ogrs3PWAv5M47KewlrE87VnwSu2l2dpv61qACVyYZ6v73AzEqXGbaHJmhW+apgIw+Ns36/Cv3wp3lX64y34iaRbYMQN6v/fwxfRVecOdVesNYxWwOR2URwG6tWwGt695L8GEE4CeFbdJBgSMhWT81e/L9zeOhelD9r7c67++uzh0fa6tIuAuI1oAC7KiBFRcgaQrPSC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:29=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> Hi Vipin,
>
> Thanks for the review.
>
> On Tue, Aug 12 2025, Vipin Sharma wrote:
>
> > On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> >> From: Pratyush Yadav <ptyadav@amazon.de>
> >> +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preser=
ved_folio *pfolios,
> >> +                                    unsigned int nr_folios)
> >> +{
> >> +    unsigned int i;
> >> +
> >> +    for (i =3D 0; i < nr_folios; i++) {
> >> +            const struct memfd_luo_preserved_folio *pfolio =3D &pfoli=
os[i];
> >> +            struct folio *folio;
> >> +
> >> +            if (!pfolio->foliodesc)
> >> +                    continue;
> >> +
> >> +            folio =3D pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc=
));
> >> +
> >> +            kho_unpreserve_folio(folio);
> >
> > This one is missing WARN_ON_ONCE() similar to the one in
> > memfd_luo_preserve_folios().
>
> Right, will add.
>
> >
> >> +            unpin_folio(folio);
>
> Looking at this code caught my eye. This can also be called from LUO's
> finish callback if no one claimed the memfd after live update. In that
> case, unpin_folio() is going to underflow the pincount or refcount on
> the folio since after the kexec, the folio is no longer pinned. We
> should only be doing folio_put().
>
> I think this function should take a argument to specify which of these
> cases it is dealing with.
>
> >> +    }
> >> +}
> >> +
> >> +static void *memfd_luo_create_fdt(unsigned long size)
> >> +{
> >> +    unsigned int order =3D get_order(size);
> >> +    struct folio *fdt_folio;
> >> +    int err =3D 0;
> >> +    void *fdt;
> >> +
> >> +    if (order > MAX_PAGE_ORDER)
> >> +            return NULL;
> >> +
> >> +    fdt_folio =3D folio_alloc(GFP_KERNEL, order);
> >
> > __GFP_ZERO should also be used here. Otherwise this can lead to
> > unintentional passing of old kernel memory.
>
> fdt_create() zeroes out the buffer so this should not be a problem.

You are right, fdt_create() zeroes the whole buffer, however, I wonder
if it could be `optimized` to only clear only the header part of FDT,
not the rest and this could potentially lead us to send an FDT buffer
that contains both a valid FDT and the trailing bits contain data from
old kernel.

Pasha

