Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C9BCD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 23:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B2F6B0088; Wed, 17 Jun 2026 19:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B7A6B008A; Wed, 17 Jun 2026 19:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25426B008C; Wed, 17 Jun 2026 19:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B95796B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:01:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43C701205C5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:01:46 +0000 (UTC)
X-FDA: 84890928612.08.970B34C
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3DAF81C0015
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:01:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iPYncY34;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781737304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chYNIvg2aQfolPl8R3U0BIa/xTg9uDRD2CbTMiTfKAQ=;
	b=SxUAjt4Gg0EpA/SjFNMwrtXZ6PTCSzf2Lscn6H78nbxn/WtOFEKhz9lvWi0Wdmjwys50rf
	dEWETEby1kmqrQwMs0BkaabjdeEyzTvFBcYtYE0HTpkjaMyqVqYpwKfce9InD/vSeGl9Th
	w9SD2N51Q54XqZMBkqSWmB49DMzjI0U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iPYncY34;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781737304;
	b=GMnqaPn4E1tKnlnyKuo1DvXLZzqafoin/uciK7ZzmP5mQMvhi68+i70dwuHaFpelOHWpVa
	HqVEyyF5ySypAova4eY4s+GWZwrPrdilsyMlqQ3HV4jJTi3xzgql2M5gdtOiiCfr/9Q33i
	PRV3ynRKG7+Qa70VkHJzMbVMbdd0FhY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5175d339e8bso100211cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781737303; cv=none;
        d=google.com; s=arc-20260327;
        b=XMcii9ZODnN1B/bnznOstQcrJo7xxN5my2rKhOuq8DCbf/+WxhA30LWmn1loadtbzv
         bGCMyqH0QOOqreKg1yIwRcBkgrZnkVVV2OnHD9R+GeDFrkXRxb10oLeOOOxwCnnzBkwj
         Om6FLrtGroxozmqBWpk/fCJcgO2lciaCi6q2ciOtHfegG/sVw/yEbpwYEJl5w+ayk1T5
         mK7BZ39PjaSL/2xzDlDHs9iXvFFxhRmSUKaTt90IZIEYMGMbPu28/ZCyHAFcUj8Eieqb
         6ICH2el6Bygyj69GGcgDc3cEQJ79pWKp9VNGA+CS4WZuFB81wCQa8B4ZlgQUgLWLgRUI
         LTbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=chYNIvg2aQfolPl8R3U0BIa/xTg9uDRD2CbTMiTfKAQ=;
        fh=3tM8mKpFK2PcX1w0ThQyYglHc9D6BY7vqVpxbQhvw90=;
        b=MulHstIEUDqhWzbQh5NEqAlSGGbr3/XVQE1VAEQsemLuTgj8/W/Ts2aR16Mt2glCgG
         lZRTM/gmtSlGFzgc+BQ3DWZSjUHzjr6BLHe3b10Aul2y4b49iPbE472AxXRkkbzS+j3X
         Jh8ZxMawpgy4LL8VLLYtNbHWEGP/t0c+iAb1aKJu+MafXeRVaUqkLNS33oQVpRmJj5qj
         m6vdSohpiT/RI1r9RSHnXfh2z2XY+1HTEZret40l9vbuy7qvr7CWo/LJb7NHl4TK/JrQ
         uTplcE0my9DTxKeAhWalFyx899Wh/ATRiZmODI+Z7FW15j1tbp8AcObIGfwn9+XPFZLx
         vjyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781737303; x=1782342103; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=chYNIvg2aQfolPl8R3U0BIa/xTg9uDRD2CbTMiTfKAQ=;
        b=iPYncY34WQb5Juj5bISNVmSBO+Dcdx7xbPEHKEo2F5zANCjC4GNrDoj26b7srCx+8q
         fOtrbtOnMKKxW8PWI0lf9U0QL4lGIbYEW2scXqklsNPJgnk7X1B3waf5OfbJ1/NMpIJn
         reAatoS1aTe/tXJik4UVdM26iUhlfy9WlzYJK9bLsm6UVB2tlL3KPOqKElrU8BJhG9qH
         XSn3O2P0C3dTcEfnVaJY+gur8SveB0n/03374pMES57UXb5Ptz70mt4anFA3nsi14EVI
         sYyR/Q9JlWTXW6MaKYHCxRu7u4On9MbVDawqJ/984Bqki/DLMBPKjBjQGzVFmCkRLplE
         0TiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781737303; x=1782342103;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=chYNIvg2aQfolPl8R3U0BIa/xTg9uDRD2CbTMiTfKAQ=;
        b=Q95pct7szwUmRFVFvEYwKQoPm+ppxIdBZ8NlQGQ16iqiQPuKaS+CDhDWUar8JoC0e2
         JzVcmoy77jKntLYlu8+wmgetGMY7CciZIq7eZclSOAp+LAEbpaEMdfnc4aI1TXsbxFBZ
         0QdAdLUzfrsTSkEY4ETngykAblkgcDljfaXQltN+64Fdo7iJX92IsOOpHJoLhYzbnEzp
         4qnYsuYLp48AluOb3V2CyD/gdBS5CKic/6IU9W1/EGB0w9SIB+bZQjqwMTzDGHcgOGDJ
         AlSh1DfSRXeO3juFSx+u3Vm21v6sK2at8VQDdk/YzxVt8Rm9Nuhuhr+JdA2/7eM+Z0fi
         KnOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9QAUC04LifbUvUZ7d5EqdMEj6oU+h5vMqyybniVVQb7LZq5Ww6Ujwg7yK6/5qKMhID9faOnITXog==@kvack.org
X-Gm-Message-State: AOJu0YwItqWkWbYXRquIz4FiM+fswGygeSle+/snKdrmsKnTrpF3fa+1
	trCHrBWOVXAnFcWlpAqmoUy+QX3mpDdIhNyN2FIrO8xvBiPS7moOkV6YtWO1D55UuQqdGSoPMVp
	CjXyI4Cpu6TbMCUgKQvB7DvIjLwB1m2BvUd9hytbR
X-Gm-Gg: Acq92OF93OjbhwzTHkUlAQzjXvx94FdZDpaYqEzg2HaiSGtq2lGe3k/flhxyK1/J9q+
	nu9XMeSIr/XsQ4JgThToxsXoYC9UMeQRdCJsvCkF/ngXYiooYCN3RzoGrB7lB9FVoZoFrim8SEG
	AaL8XnYiKuqWHz7izH5MEYQf8iytHmSJ556FTBHLFDzE5bIHifS6lnmlqUG6qRsm3H/Ul0jzYZj
	RivFv+2DA/jpdEsxcQLekvgPQMbZ6ir/qvktkMOZ9wXLMayBp/LpcguggysTAxQ0ZRv4Ps=
X-Received: by 2002:a05:622a:1a9e:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-519c973f6b0mr1597741cf.13.1781737302279; Wed, 17 Jun 2026
 16:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
 <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com>
 <CAJuCfpGOrtk+3hvUVE7-6wpnsa3Nbr6kGq5CfHVdCzX+DYyjFQ@mail.gmail.com> <CAL41Mv6FZU5As+yKiM52axUMsR_FDrYQCK5STjUp-aG+xMD-EQ@mail.gmail.com>
In-Reply-To: <CAL41Mv6FZU5As+yKiM52axUMsR_FDrYQCK5STjUp-aG+xMD-EQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 16:01:30 -0700
X-Gm-Features: AVVi8CdE35jTyLSitGqA0jYruECl2C0Lv-1lfszf7nB8jdkFfyY7E1mYiqZtbxo
Message-ID: <CAJuCfpFrgKBGFWoca=XuKh1p22vdfE_uSz_nt2Kj4UvnjvSUJQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3DAF81C0015
X-Rspam-User: 
X-Stat-Signature: bjzz5acc5nf1mgsjdaybw5c8gn8dknmf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781737304-136138
X-HE-Meta: U2FsdGVkX1/dctjmUexE15S8NH4thslOPqg5hxcjAW6arxGJiwLo4RkQEKxw3nUpRc0FBoeGl3rHA4380e+tSz9UAdYMN8oAyCUzrVZcGFHvMoizl10HyFlJMen5bqG/ZYdBY5bMoyTbszoSaGbqSiTb7J3sPpD796bjCyDWKLkuR4QlfAzN6RiuUDAIfIs51aGaSpSYpx/UO6AOCINlLuryvuosvC6nHtn/VdiDURDD97Nr/gWQoJMh5uYctbq5a/MVuhVrSGdaaS4YwJ767zjhZYk+Hr310v9q9GmkKXOriPQDaYbOqh+EY1gTVHG9vVHoVzC/xldheJqDhOVQxDGNiWFyaGbhr+TxxC3rE1if21DWsgcwu+O9923cTOgSkwvScVJyEsb3EGTV7TnhD3GGQvTTaGIqQGFQD8zsu64nydj7vJXuH0dGzCv6/waDZx6Lam8xIJUrImPWOECUFneApRTCSkT2tmuPo1SK7tom1ygfhhCVbSAFS/U+C0n4/dWLl0g8fCDDW7mHfAcsGsx0IdK/GCttdaqKvZ8N37Yu3AkBRxMv2PGSJ6LoY5ukofscQ1oB5ExkjmH0j06u3jrFa6jlWYzpbELCHBY6t8Bqh6eIKAIbjRJIo3EV9sx6lVSA/hK+RKZ8YXpp2rVhKyY2CbtxFT64yHAgUItFMN1hbyWh0lNa219rhsqW2TIDuXWNl39JBFlyPonkvE5CWH0BzMU+6mXe53AkfMozfpSmiBo9jSw2pF96UumXbfX4zWka8/T9yFzzZX+giZUllm/42IQUqYjRYvtW9yA62mdJ/cdBwIRKuNbkno2CyfiZBxJlz36GOtAxpKrpUlCjrVG70JUB8Xgt8PkrCfGtKUHe6UMUBNmuRZyTnUJR1jY9m+ZoA/30HPKe7U5VbLh1RsPDWtVrL+yQmNkbhmk24qdd06iC5hQUhiQQ0bu0R0ux88MnCLCk1CxwT+4IFZ2
 WZi/kKT+
 /ODT5NF2KeTSn61TGtPt0/rkcfRixSQHjdWwigFOglIVoWSF5xoi67/DJ5bEtg4fiVTkFFK0On8oTAzuqJijtIZTIC/K0Tgnp8+zEXCTyse3bgNqi2ppPPQ7YVjASvmwfqmjZU2Q6ZQ12lT8Erb5rONHDOyaqPJAdKS8vK26WFNKfpAP6RpGj9sqcPqJWCo5H5/ZJl73Jk8wwodQEYSEMJFTpO3t++8af3utdy1P8ZXbwhuoUhJmKRRsLMDSyb6/y2MdalG5cy2tbny9K4Nn/t+ONciGxfsNbcn5jPOVyDPsmJQLzW2pjpn+OBuZtM7wZ0qObq4zBqUszGcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 3:41=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Wed, Jun 17, 2026 at 3:35=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Wed, Jun 17, 2026 at 1:55=E2=80=AFPM Abhishek Bapat <abhishekbapat@g=
oogle.com> wrote:
> > >
> > > On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbap=
at@google.com> wrote:
> > > > >
> > > > > Extend the allocinfo filtering mechanism to allow users to filter=
 tags
> > > > > based on the total number of bytes allocated [min_size, max_size]=
. The
> > > > > size range is inclusive.
> > > > >
> > > > > Filtering by size involves retrieving allocinfo per-CPU counters,=
 which
> > > > > is an expensive operation. Hence, the performance of size-based
> > > > > filtering will be worse than other filters.
> > > > >
> > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > Acked-by: Hao Ge <hao.ge@linux.dev>
> > > > > ---
> > > > >  include/uapi/linux/alloc_tag.h |  8 ++++-
> > > > >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++=
------
> > > > >  2 files changed, 59 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/=
alloc_tag.h
> > > > > index 3b11877955b9..7f5acbb44c14 100644
> > > > > --- a/include/uapi/linux/alloc_tag.h
> > > > > +++ b/include/uapi/linux/alloc_tag.h
> > > > > @@ -45,13 +45,17 @@ enum {
> > > > >         ALLOCINFO_FILTER_FUNCTION,
> > > > >         ALLOCINFO_FILTER_FILENAME,
> > > > >         ALLOCINFO_FILTER_LINENO,
> > > > > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > > > > +       ALLOCINFO_FILTER_MIN_SIZE,
> > > > > +       ALLOCINFO_FILTER_MAX_SIZE,
> > > > > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > > > >  };
> > > > >
> > > > >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_F=
ILTER_MODNAME)
> > > > >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_F=
ILTER_FUNCTION)
> > > > >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_F=
ILTER_FILENAME)
> > > > >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_F=
ILTER_LINENO)
> > > > > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_F=
ILTER_MIN_SIZE)
> > > > > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_F=
ILTER_MAX_SIZE)
> > > > >
> > > > >  #define ALLOCINFO_FILTER_MASKS \
> > > > >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > > > > @@ -59,6 +63,8 @@ enum {
> > > > >  struct allocinfo_filter {
> > > > >         __u64 mask; /* bitmask of the filter fields used */
> > > > >         struct allocinfo_tag fields;
> > > > > +       __u64 min_size;
> > > > > +       __u64 max_size;
> > > > >  };
> > > > >
> > > > >  struct allocinfo_get_at {
> > > > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > > > index 5feb61d9fb92..b3d21834b61e 100644
> > > > > --- a/lib/alloc_tag.c
> > > > > +++ b/lib/alloc_tag.c
> > > > > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *st=
r, const char *template)
> > > > >         return strncmp(allocinfo_str(str), template, ALLOCINFO_ST=
R_SIZE);
> > > > >  }
> > > > >
> > > > > +/* Fetch the per-CPU counters */
> > > > > +static inline struct alloc_tag_counters allocinfo_prefetch_count=
ers(struct codetag *ct)
> > > > > +{
> > > > > +       return alloc_tag_read(ct_to_alloc_tag(ct));
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * Populates the UAPI allocinfo_tag_data structure with active r=
untime
> > > > >   * profiling counters extracted from the given kernel codetag.
> > > > >   */
> > > > >  static void allocinfo_to_params(struct codetag *ct,
> > > > > -                               struct allocinfo_tag_data *data)
> > > > > +                               struct allocinfo_tag_data *data,
> > > > > +                               struct alloc_tag_counters *counte=
rs)
> > > > >  {
> > > > > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > > > > -       struct alloc_tag_counters counter =3D alloc_tag_read(tag)=
;
> > > > > +       struct alloc_tag_counters local_counters;
> > > > > +
> > > > > +       if (!counters) {
> > > > > +               local_counters =3D allocinfo_prefetch_counters(ct=
);
> > > > > +               counters =3D &local_counters;
> > > > > +       }
> > > > >
> > > > >         if (ct->modname)
> > > > >                 allocinfo_copy_str(data->tag.modname, ct->modname=
);
> > > > > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codeta=
g *ct,
> > > > >         allocinfo_copy_str(data->tag.function, ct->function);
> > > > >         allocinfo_copy_str(data->tag.filename, ct->filename);
> > > > >         data->tag.lineno =3D ct->lineno;
> > > > > -       data->counter.bytes =3D counter.bytes;
> > > > > -       data->counter.calls =3D counter.calls;
> > > > > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > > > > +       data->counter.bytes =3D counters->bytes;
> > > > > +       data->counter.calls =3D counters->calls;
> > > > > +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to=
_alloc_tag(ct));
> > > > >  }
> > > > >
> > > > >  /*
> > > > > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(str=
uct seq_file *m, void __user *arg)
> > > > >   * Verifies whether a given codetag satisfies the active filteri=
ng criteria by
> > > > >   * matching its characteristics against the specified filter.
> > > > >   */
> > > > > -static bool matches_filter(struct codetag *ct, struct allocinfo_=
filter *filter)
> > > > > +static bool matches_filter(struct codetag *ct, struct allocinfo_=
filter *filter,
> > > > > +                          struct alloc_tag_counters *counters,
> > > > > +                          bool *fetched_counters)
> > > > >  {
> > > > >         if (!filter || !filter->mask)
> > > > >                 return true;
> > > > > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *c=
t, struct allocinfo_filter *filter)
> > > > >             ct->lineno !=3D filter->fields.lineno)
> > > > >                 return false;
> > > > >
> > > > > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLO=
CINFO_FILTER_MASK_MAX_SIZE)) {
> > > > > +               if (!*fetched_counters) {
> > > > > +                       *counters =3D allocinfo_prefetch_counters=
(ct);
> > > > > +                       *fetched_counters =3D true;
> > > > > +               }
> > > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZ=
E) &&
> > > > > +                   counters->bytes < filter->min_size)
> > > > > +                       return false;
> > > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZ=
E) &&
> > > > > +                   counters->bytes > filter->max_size)
> > > > > +                       return false;
> > > > > +       }
> > > > > +
> > > > >         return true;
> > > > >  }
> > > > >
> > > > > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_=
file *m, void __user *arg)
> > > > >         struct codetag *ct;
> > > > >         struct allocinfo_get_at params =3D {0};
> > > > >         __u64 skip_count;
> > > > > +       struct alloc_tag_counters counters;
> > > > > +       bool fetched_counters;
> > > > >
> > > > >         if (copy_from_user(&params, arg, sizeof(params)))
> > > > >                 return -EFAULT;
> > > > > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq=
_file *m, void __user *arg)
> > > > >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > > > >                 return -EINVAL;
> > > > >
> > > > > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE)=
 &&
> > > > > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)=
 &&
> > > > > +           params.filter.min_size > params.filter.max_size)
> > > > > +               return -EINVAL;
> > > > > +
> > > > >         priv =3D m->private;
> > > > >
> > > > >         mutex_lock(&priv->ioctl_lock);
> > > > > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_=
file *m, void __user *arg)
> > > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > >
> > > > >         while (ct) {
> > > > > -               if (matches_filter(ct, &priv->filter)) {
> > > > > +               fetched_counters =3D false;
> > > > > +               if (matches_filter(ct, &priv->filter, &counters, =
&fetched_counters)) {
> > > >
> > > > Do we really need this "fetched_counters" parameter? Here are the
> > > > possible cases:
> > > > 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > > > ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
> > > > 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > > > ALLOCINFO_FILTER_MASK_MAX_SIZE and
> > > > 2.1. matches_filter() returns true then we know counters were fetch=
ed
> > > > because they had to be validated.
> > > > 2.2. matches_filter() returns false then we don't care if the count=
ers
> > > > were fetched. We do not report that tag anyway.
> > > >
> > > > So, instead of passing fetched_counters to matches_filter() we coul=
d do this:
> > > >
> > > > bool filter_by_size =3D (params.filter.mask &
> > > > (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) =
!=3D
> > > > 0;
> > > > while (ct) {
> > > >            if (matches_filter(ct, &priv->filter, &counters)) {
> > > > ...
> > > > }
> > > > if (ct) {
> > > >            allocinfo_to_params(ct, &params.data, filter_by_size ?
> > > > &counters : NULL);
> > > > ...
> > > > }
> > > >
> > > > Wouldn't that work?
> > > >
> > >
> > > While we can deduce whether counters were fetched outside the
> > > matches_filter function, I think the current implementation is more
> > > intuitive from a readability perspective. I believe it  should be kep=
t
> > > as is for that reason. If we extract the logic, we'll first have to
> > > replicate the boolean logic at two places. Second, we'd need to add a
> > > comment explaining the boolean calculation, and the reader might have
> > > a higher cognitive load trying to determine which function populates
> > > the counters. The current implementation makes it easy for the reader
> > > to deduce the original intention. Let me know what you think.
> >
> > Ok, I guess you have a point.
> >
> > I was also thinking why we are passing NULL to allocinfo_to_params()
> > to fetch the counters into a local variable? Why can't we simply call
> > allocinfo_prefetch_counters() before calling allocinfo_to_params()
> > when fetched_counters=3D=3Dfalse? Basically:
> >
> > if (!fetched_counters)
> >     counters =3D allocinfo_prefetch_counters(ct);
> > allocinfo_to_params(ct, &params.data, &counters);
> >
> > This would simplify allocinfo_to_params() because counter will never
> > be NULL and it would not need local counters.
> >
>
> The only reason I did it that way was to avoid repeating the code at
> two places i.e. allocinfo_ioctl_get_at and allocinfo_ioctl_get_next.
> Either way, the per-CPU counters are assimilated only once. I can
> include this change if you still want me to, but personally I like the
> way it currently is implemented.

Yeah, I think repeating 2 lines is preferable to passing NULL and
fetching into a local variable. Please include that change.

>
> > >
> > > > >                         if (skip_count =3D=3D 0)
> > > > >                                 break;
> > > > >                         skip_count--;
> > > > > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_=
file *m, void __user *arg)
> > > > >         }
> > > > >
> > > > >         if (ct) {
> > > > > -               allocinfo_to_params(ct, &params.data);
> > > > > +               allocinfo_to_params(ct, &params.data, fetched_cou=
nters ? &counters : NULL);
> > > > >                 priv->positioned =3D true;
> > > > >         }
> > > > >
> > > > > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct se=
q_file *m, void __user *arg)
> > > > >         struct codetag *ct;
> > > > >         struct allocinfo_tag_data params;
> > > > >         int ret =3D 0;
> > > > > +       struct alloc_tag_counters counters;
> > > > > +       bool fetched_counters;
> > > > >
> > > > >         memset(&params, 0, sizeof(params));
> > > > >         priv =3D m->private;
> > > > > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct =
seq_file *m, void __user *arg)
> > > > >         }
> > > > >
> > > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > > -       while (ct && !matches_filter(ct, &priv->filter))
> > > > > +       while (ct) {
> > > > > +               fetched_counters =3D false;
> > > > > +               if (matches_filter(ct, &priv->filter, &counters, =
&fetched_counters))
> > > > > +                       break;
> > > > >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > > +       }
> > > > > +
> > > > >         if (ct)
> > > > > -               allocinfo_to_params(ct, &params);
> > > > > +               allocinfo_to_params(ct, &params, fetched_counters=
 ? &counters : NULL);
> > > > >
> > > > >         if (!ct) {
> > > > >                 priv->positioned =3D false;
> > > > > --
> > > > > 2.54.0.1136.gdb2ca164c4-goog
> > > > >

