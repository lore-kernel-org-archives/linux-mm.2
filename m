Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DA0C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671206B0092; Tue, 15 Sep 2026 03:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622366B0093; Tue, 15 Sep 2026 03:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5115B6B0095; Tue, 15 Sep 2026 03:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A44F6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:46:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AD5F1A030A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:46:25 +0000 (UTC)
X-FDA: 85215213930.01.36AA114
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id ACD83A0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:46:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1NJ20WB;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789458383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Pps+EUxIPat2MFd8djCKE6ufuBL96D4CSyfKuoMsCc=;
	b=jtmSu+PAl56/9pld+y+WkynqaBVLO4oHma64PnHHm11W0gHhDGjPQEX1cvxLfxMZzK2Nzo
	NA/QJW5mi1/isr/MLM0eXf/t1fqpWMg7BmXgUazTsSl1D805WqlKiNCy5pj+TZhwu7OZi3
	9tmc3Ixe9inMQf4l6UM6mqylq9vZXqI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789458383;
	b=2o+khUrrybHL50IlAsNa2Ewv0TCsXY6OkPyfNkIejKczYEf+LrrIc7Ds6iq0yQ1phuJhkO
	ooFNTpKibNkA7ZhsplMBowBEY+A8KTR0h0fz8mZSk2IBzXTwzdOmKzEM0Xra3N+g6I5AAP
	3vRSyN/SNJ7bgCd6mHJRPOKXwOcLdmU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1NJ20WB;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab201ecso2644358d50.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:46:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789458383; cv=none;
        d=google.com; s=arc-20260327;
        b=AzHB0nxFDCGWAgLOBAJ82WSYtJXvo9d+CE1oLbbwy3heub/TGmI6Y3tydJZleVl+uP
         29wfhhGjiLTm+Y7x3brfNxis7/dMqcMlKvUlUAY/Mq+mEyHqbcYSUiEukmaWTwUmOUlZ
         9+PN8x8GSQ50+/pSnqlgtD7yXDrs5nPiqPv0uxGrnVOEtQow9UpkR0M2D8QXaLmmChGX
         7KBm7Ca5c6oyNyYY75xMiWbGLniwP16zSzGOUHjC5rmJEz+3oY7psDgoUUScmTR1W5Q2
         11Sdpa8dMGZ9OoWLFk0l1k6l1G18yqpz7E170bo5JK0q7qtEgb4UCQgJg5mpvlcWnXwC
         BiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Pps+EUxIPat2MFd8djCKE6ufuBL96D4CSyfKuoMsCc=;
        fh=FlEM9aqfJ/nAWUm57hDQ7q6IrHXRZLStt73idsPJ44Y=;
        b=icBoXHqGVKP2pXdkUJ4lVvtvOBApJE8gsWAnCWKbs4YzIeim5WSdF83hzo+jxzC93w
         uqfhPNnTOJWj9KfmY2inJy+Ob2c5wKd+doPNfSsk4mmpMxGdqCvHfmhv1dn6gonWdJf9
         19UEWSqO45sWXsrDrJeS4jNzujM4BCa+ETFORLXGDEZggeRHClkbgeRFBemuMu2ybL9u
         AGAQbsE+oft3Mr/DeVcpeUb1AhI95urRHdCHxXGKm3HQYzS/zUvEku7GHo8Vrd6g10VD
         SGk6yvO04yGDsD1Ba7ObPegNyTGKEJzZaENXjRGwQIWr0J8Thp91fuMUrMaNTUAYfnve
         HWyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789458383; x=1790063183; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7Pps+EUxIPat2MFd8djCKE6ufuBL96D4CSyfKuoMsCc=;
        b=K1NJ20WBf6gj8yPCbTTGksOB3IsIsEFY9zWMEjmiVe4qFy1+UBJ4wgH5J8OCiHrH+U
         LcsgZpvT3wnx9O3iBOVsaOxa+OGPEyudSyqvA/cxPFLv2XMtijDyno7l4GdeL64OSx9U
         ViwNI7BFZSlBVW31KdKTvPoG1JayHsw7CFIHOTh1F+vUGmappk6Y2OmQHJBHHytuKQK3
         BXRUjaupzj48NzZOd1cezqSusgD7ioAp00jrpHzXhGc+Ao1RQCPeUcc8Xd3qbKh/P16H
         b4kOXpYEpp8Ug8xBG6kvr1+XM56liI2vmUbZ+A+NWs5Tmls+RbIJruVocTO0KpqOfq8I
         Nc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789458383; x=1790063183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Pps+EUxIPat2MFd8djCKE6ufuBL96D4CSyfKuoMsCc=;
        b=ZX6a6cWQX9uItwW9RfCLyc/6yRl+y7tI3cCkC0QFnQY85XipU4HpDgrmxLGy8huhXK
         3MxAHkhD7eMATC5VzArGwooBjaKPABdRrJW5fVTS9XDLa6FQc9Cma2Vw1V4jjzzRXJ8L
         DVzC8Hiu4quM5UjSIuh6mB6aKhvvUYVmHwmGYeAXVayfqQT+TjH9dnulawMCd0pXTiSq
         jf3RrcMxOBrmx5H3Wf9aDDs9Mp3sq7SwgSjGY/1eUpWASSiGfFjlI/RQcSzYA6/tNHFP
         HzQqNYY0VZEyA4B2+2w9If/1E2wmNR16AiRanKMdTn04+bpcRp86ed2ENZuGvGE3F8Sd
         0b1Q==
X-Forwarded-Encrypted: i=1; AKwUvBxbQOF/zWhO74Jmke6WYzJxkTHfx7+VnYzyxueF+gMWdeYEbH7tnNZIKsf0gQWZjRZiSs553G0bzg==@kvack.org
X-Gm-Message-State: AFuF++ldy2I/i65hbRGCn00JbrdCj4KxkslP/uziBFS/W6nqzb9aq0zr
	mCeuxTomcC7mbFyoeizirOhR2cNIOlkk0JIS5VYOERGhd+b1/YnQwnuRcbPbxq9PcYmLFPTR75c
	AsTy/QdRg5IDfzysE3yDgDdSFxna/kNk=
X-Gm-Gg: AYBFou0eWCk6PtsD3Yn9VBjK1E3QbUDbgus61XViZBPJ9dgXjBqB7RBAYNqHyWYWV0S
	4Cb7XwgQwZlrLfj4gVhiZHASfQCrR9m90IZ9m8pJTquenwgKKUmW0gKCthwREdQhYXF6aQbJRxb
	hZQ6x5ScfMCWl0RfaSi/e477VyEWbuDY0vYaSvhcdcYL4uvuDCt12aWLdZIQD9XMjKx3TyhkXX4
	k4opK3LviMg3vSbpBxerdwtYITq/1nkbas2uzSNeeu+PqSA+Ya6rPT4lTaU+jfmj1Yp5l+PGBFS
	KDYdOD+pnfsUDbZ93WfXO4P2SN2yYGE6C+uhJjENkOgJqi2ku5+m
X-Received: by 2002:a05:690e:e8e:b0:671:4b50:4628 with SMTP id
 956f58d0204a3-6714e1bbd88mr1640636d50.97.1789458382556; Tue, 15 Sep 2026
 00:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
 <178903430147.1489479.2162515570306846533.b4-ty@b4> <178903518466.2710705.16546329711992780120.b4-reply@b4>
 <CABFDxMEAkqGhXc93crUKjP9bKs2xh1gb0Nt32jzC08qSADJjRQ@mail.gmail.com>
 <CABFDxMGHwUrssk09-2j0yoQh9AVHTqoJDmJw3o8k10astr+bsg@mail.gmail.com> <aqeuQZwr3flydCRk@kernel.org>
In-Reply-To: <aqeuQZwr3flydCRk@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 15 Sep 2026 16:46:11 +0900
X-Gm-Features: AcwNN1WHQOHYoBZTJKWBlIXibVOhiyPE4nxIcJthlZi_i25g6xNjx2Vxrr1mACo
Message-ID: <CABFDxMEavG7zHDo07_RBzMPJxV_CjQhMcKVoot0WEBtFQnxPyQ@mail.gmail.com>
Subject: Re: [PATCH] memblock: use for_each_zone() in reset_all_zones_managed_pages()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACD83A0006
X-Stat-Signature: cjqga4njmyno8bi8w4ew6jrqdfutof9k
X-Rspam-User: 
X-HE-Tag: 1789458383-2043
X-HE-Meta: U2FsdGVkX19IGW4E/kVWVPNtQxGM5goZpaEdPHh3AVMghQpus78zf5efhHMfqVn1xr+tPWnLj9KLrXEngMXpKV7mE/50wRXIdMQD48SNLIAss9vTGg12CmDkSCFwys1RpcOD8Vkl2i6JtZ+7daEH8jxljV96ha4y/VFh2wD718mEf8fEL8hrfVIUE4QW8elwnemM+VVb7DAHV9cWUz0oPJ6VXHP0rs7ZllabyiFloB0QoriPiuUpPZsv+KcSxcXnBG2Q//UEzigpgu1QSYH1eNEKmff/X5O+MtyuukUD9POzbR6dt2N7E8R0OpjEunt6Gj4rcEHAUOIOK4qRWIurvjikuRzNptV8THTjKzWYJzqJ+TuwRwhafL7FUMFYNIlQ7or87kti0LJgtykJH4/PnN0dI92Bxcj/gkoBCv8avZxJUqHpm2CD8D3+2NA/DBqXu4SRQ3SFPkO4Lrvt1yaEsxDSFEIAoIXZTON/0L2RCEIe4z9J2M9L2z9ZnaX2Sygn79PNJPPWjoOnYa103BCFV7YxQaCXpkTrwLfTQrHdXUfKtQtPMf0DUfXrbTuBaBIYJp9k8dUFHAjpU0WZQrE22cLWZuodggSGK6unChI/AqS4oHuWOxdrbbLh1NPpPXVHuu8wFHAZZMQkMbiAywXdpn26bzvlaM6IerpY9iUPV2nGj6J4ZStG7rx7oEcj03Js7ulVz7ytUi66XLTgGXXxbde+JvLI0Fkxf5bgfUZapiVcnusruT52RyAbcvi190+BV8aJiSon5KB8bn+OK1CvZVRpmvGShkuIkhK+8W/VMhIwqaNtsgrDUxYRRb4xQOMkxVmek8CvdGCdUVs8NEkNrLyidxAQqjYniSpquyRp5ZCJ8krps/4efME8NvnD3xf1sZ/MqAEfByDljXVQaX16pNcBH4dXWjxmDrZTFMewBHvVUo4mQ7MSaDz9yOSyarH8kVeqzVyXA5v2CDNNlhf
 b6M+IORa
 MkUkansO9aFh2rILQk7sdvN40LUccD7gVoq2dNV8joLBzAOkZvS8et/V3dnouRHIFceKTzBdjJ3NWO++hBieLb4WqZrUhx4Oy1kolcmw6dcdXzDzpOjNcGBF7UPRq0N2IrKlaXfyvUcvqp+2dUUEjOhScKIkTVENA9oV1e15V3L+nSmv9oFb61rgX7cH2yzqrXJ/0o7QJ8z9ZoFPS3gBDgPiJkz3eFrZF3nhIQiqqm5JvKdmhEyPAJ8ENS7DjKjWlR3ry7zIys/Ig/VZZkAETGz+TIcljGduSl5zn6KIbiIB2sKx8zY3kySaol0n04VND9394LCWFVCxTFqLwlDTA1jzRVGpedhGPEZFNDVY0BKSXqrs9FmPNiJKZPGmFQ9G2Xsict22cW3ZSwGMctf5WtOcGU7w2LXfvfxq2VBKrRidCq+6hFYwMidBqcdb6SXYOLrlTKT5hFCFp9LQv1D3B0CqMqeU9t6wqPcQd8i/0G5+k8fM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 5:20=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Sep 10, 2026 at 11:35:41PM +0900, Sang-Heon Jeon wrote:
> > On Thu, Sep 10, 2026 at 9:19=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gma=
il.com> wrote:
> > >
> > > On Thu, Sep 10, 2026 at 7:13=E2=80=AFPM Mike Rapoport <rppt@kernel.or=
g> wrote:
> > > >
> > > > On 2026-09-10 12:58 +0300, Mike Rapoport wrote:
> > > > > On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> > > > > > memblock: use for_each_zone() in reset_all_zones_managed_pages(=
)
> > > > >
> > > > > Applied to for-next branch of memblock.git tree, thanks!
> > > > >
> > > > > [1/1] memblock: use for_each_zone() in reset_all_zones_managed_pa=
ges()
> > > > >       commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95
> > > > >
> > > > > tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblo=
ck
> > > > > branch: for-next
> > > >
> > > > Hmm, I was too hasty.
> > > > This breaks mmemblock tests, so I dropped it for now.
> > >
> > > Sorry for the noise. I missed it. I will keep it in mind next time.
> > > Just give me a second to check.
> >
> > With the below fixes, tests will be fine again. Is it okay to send the
> > v2 patchset with below fixes?
>
> memblock tests do not cover late parts of mm initialization, I believe it
> would be fine to just define for_each_zone() to a nop.

Thanks for the review, Mike. I'll send a v2 soon.

> > diff --git a/tools/testing/memblock/linux/mmzone.h
> > b/tools/testing/memblock/linux/mmzone.h
> > index 8d934ff5b080..631fe07923e7 100644
> > --- a/tools/testing/memblock/linux/mmzone.h
> > +++ b/tools/testing/memblock/linux/mmzone.h
> > @@ -7,13 +7,20 @@
> >
> >  struct pglist_data *first_online_pgdat(void);
> >  struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
> > +struct zone *next_zone(struct zone *zone);
> >
> >  #define for_each_online_pgdat(pgdat)                   \
> >         for (pgdat =3D first_online_pgdat();              \
> >              pgdat;                                     \
> >              pgdat =3D next_online_pgdat(pgdat))
> >
> > +#define for_each_zone(zone)                            \
> > +       for (zone =3D (first_online_pgdat())->node_zones; \
> > +            zone;                                      \
> > +            zone =3D next_zone(zone))
> > +
> >  enum zone_type {
> > +       ZONE_NORMAL,
> >         __MAX_NR_ZONES
> >  };
> >
> > @@ -27,6 +34,7 @@ enum zone_type {
> >  #define pageblock_start_pfn(pfn)       ALIGN_DOWN((pfn), pageblock_nr_=
pages)
> >
> >  struct zone {
> > +       struct pglist_data      *zone_pgdat;
> >         atomic_long_t           managed_pages;
> >  };
> >
> > diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/m=
mzone.c
> > index e719450f81cb..e73848bdc8d6 100644
> > --- a/tools/testing/memblock/mmzone.c
> > +++ b/tools/testing/memblock/mmzone.c
> > @@ -1,9 +1,15 @@
> >  // SPDX-License-Identifier: GPL-2.0-or-later
> >  #include <linux/mmzone.h>
> >
> > +static pg_data_t dummy_pgdat =3D {
> > +       .node_zones =3D {
> > +               [0 ... MAX_NR_ZONES - 1] =3D { .zone_pgdat =3D &dummy_p=
gdat },
> > +       },
> > +};
> > +
> >  struct pglist_data *first_online_pgdat(void)
> >  {
> > -       return NULL;
> > +       return &dummy_pgdat;
> >  }
> >
> >  struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
> > @@ -11,6 +17,22 @@ struct pglist_data *next_online_pgdat(struct
> > pglist_data *pgdat)
> >         return NULL;
> >  }
> >
> > +struct zone *next_zone(struct zone *zone)
> > +{
> > +       pg_data_t *pgdat =3D zone->zone_pgdat;
> > +
> > +       if (zone < pgdat->node_zones + MAX_NR_ZONES - 1)
> > +               zone++;
> > +       else {
> > +               pgdat =3D next_online_pgdat(pgdat);
> > +               if (pgdat)
> > +                       zone =3D pgdat->node_zones;
> > +               else
> > +                       zone =3D NULL;
> > +       }
> > +       return zone;
> > +}
> > +
> >  void atomic_long_set(atomic_long_t *v, long i)
> >  {
> >  }
> >
> > > > > --
> > > > > Sincerely yours,
> > > > > Mike.
> > > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > >
> > > >
> > >
> > > Best regards
> > > Sang-Heon Jeon
> >
> > Best regards,
> > Sang-Heon Jeon
>
> --
> Sincerely yours,
> Mike.

Best regards,
Sang-Heon Jeon

