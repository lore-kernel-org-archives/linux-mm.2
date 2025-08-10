Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2643C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 05:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6696B0095; Sun, 10 Aug 2025 01:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376F36B0098; Sun, 10 Aug 2025 01:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265A66B0099; Sun, 10 Aug 2025 01:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 163D96B0095
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 01:50:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8723DB7A26
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:50:57 +0000 (UTC)
X-FDA: 83759774154.12.4DCD388
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC249A0004
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:50:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FaIMItc8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754805055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RplhLYKRbowPs0ffqGClhSE7xF+vOLgbG7MzNAT9Ds=;
	b=2b0PqiE8dBi7fpnAMKttu7JLwhAU7FQ/V1lv1fLnAHDuELlcpKZUZp3juChC0u78J5jIiZ
	3KqNodv8fYTojHHCHYvfX1q9HK9G0kzr34GPPgHdm7gXVgKrnbAIaZucMOH++f7dXb+9SR
	bJvpfgEjqyw0+QKaKSl/o4Ahn+qw2P0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754805055; a=rsa-sha256;
	cv=none;
	b=32gB9/oZIghASH7s6TfZPcgwSTb+pkeyvBz7lpre3NZ2kMqKX+Z7k3t3F2lu7ba3oIyAFm
	ZQurOAb7ODIfEfdvHmiZhBe3l8lswMNcjKZpp7oTZvO/11D3fWPGD7PrDaGWVrXqq38dhf
	dJlQ02Kxemq952y8bEiepAzgVy8Edok=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FaIMItc8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-433f681befbso1223616b6e.3
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 22:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754805055; x=1755409855; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RplhLYKRbowPs0ffqGClhSE7xF+vOLgbG7MzNAT9Ds=;
        b=FaIMItc8UEdZDdoGngbCqbDfwUnBrfnBxmvzTFs6EoKfABj4bAAxoxeA4wQUfSFvVf
         ELOGPucGIWIWebErS13hBNJv9r89T7LNn7ZiCix89pIRphM0a5qnFgh/cBF+lTU1Lf11
         wVUtta4XSAn5As1PxAqpTkowjv20hkRonxzGGwvaOxLx0JsR9WkSL5c8SEJH5S3MJERX
         aA/Agd+/vEEDPzeqReA6V7Zhv8yJk4yQE+zEbKqG9Yc7Fm7vdF73ISmc2uUBb1J4Xynj
         o4kmbhiBUQ6XtHRBjB7VDy/hbPlDUH+ojVcEYS4x/sRaY1K9hFYDuzL5Rjf43F8EW3mb
         SrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754805055; x=1755409855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+RplhLYKRbowPs0ffqGClhSE7xF+vOLgbG7MzNAT9Ds=;
        b=SccCYCtmEoWXD8vj5z20y7k14ppVQ9KjtnkpgXi2DzTFJRyI1VJhS/JYa1qF+qme7G
         dhzbXVTdBgLk3GBfrII3HMN5dt381MT2LYsK54DTzxys7xYQGj5js62eUt3Y0pHyEA5H
         GIlI8O5AVIuR4AbU6NU47sDiunWT4wl0o6pG+gTgYbK6g6t6zweV6vTkjNbDgcQqs2bs
         huPfYmEIpB1XhURgj/dAvmxRF0SKajJwbvQ6NTmhkzVpNVIJyax88jfIDwoXnnJbmz/b
         v28KaFKFg6V5nyhrUzc7D3Qwh999gU273fD5m7fd0iH/DU6Z8oStMAPYhfLem4F1s7m5
         Svhg==
X-Forwarded-Encrypted: i=1; AJvYcCUR48IFOKrID2gsYC1ifPCy0wCwBCDUcsGLeN1m/+PCxElrYQTLVIkhI5vCKex7Ls0D/PBBSsLQtA==@kvack.org
X-Gm-Message-State: AOJu0Yy9yCSed6D6BfXEp261cpK4mdeGqWIsvgRCG5/qVz2/H1CxDRnn
	6qb46/E75Nli8Gi7qJUzn1POGz7OYGJKj4DAYBZdcFRHoLbIRcV+AxSTJLPKn9bTbjSTAKqWJIe
	MzQ1kp0ULAfl/qeS/zFq46FXOTar0VNg=
X-Gm-Gg: ASbGnctxZdtMchLP2pPtWI5h9whWhS6PngfdkImH8S1ZO6v3WKfvqNU/AqjSyUOPA/C
	kWXOkvVVtsbmL3TSz9VGVG8UT+hWR6NjIqD+xm8dQXvL9KaWkD0DnXkhmQAkIe3efrmdQghxa7U
	I0xe5Omp3JF0QPr06YjNKa3hdDXD7PznoYL09gG3kKBwb+vMBc3L/dGfszkX140bq+aAn+XWTne
	4LuER0=
X-Google-Smtp-Source: AGHT+IEDLol32kwZanNgYwxdv2mlzock6ARZkJaYvaJ+31EKV4GmrEL64Zokee7BM+3DiafITMb2/+OAXFUxEFMYvpw=
X-Received: by 2002:a05:6870:55c6:b0:2c6:72d3:fc93 with SMTP id
 586e51a60fabf-30c20f1de91mr4817604fac.12.1754805054636; Sat, 09 Aug 2025
 22:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250809130756.637304-1-ekffu200098@gmail.com> <20250809174838.71485-1-sj@kernel.org>
In-Reply-To: <20250809174838.71485-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 10 Aug 2025 14:50:43 +0900
X-Gm-Features: Ac12FXxV2eNezNgvc_e4rqGAi29JIh7FFDT5Kj18LpEB1lM6Giec7lzpKEQ6NF4
Message-ID: <CABFDxMFzWyN-edgiEeWufZLOsHM4BWe6kU5x7erJYV79kJOztw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: fix commit_ops_filters by using correct
 nth function
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4b3181ddcepkhnqsjnaco4hsorhh8gwa
X-Rspamd-Queue-Id: AC249A0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754805055-618409
X-HE-Meta: U2FsdGVkX1/orIWq6gnEDVA9TMupX1Srf86a79r8qwRtPoFuzY5vxK1fCyqXfTp92Nh3F62I3tsWHJpARHSRAVzKNnnF1zww/hLHeQHVIRJCNvJdwcN5ctHM+yxzCqpqa9rfozbL42ItaKj4MxN/2bKJnKpnGy61+ov9y7fK4Uupmr1E7SH0FGSV0dfB1eXXXaR7Vf2S7DXuR8MI/NzwgZoUTDyZQ0bxPQbo5uykoLlpOuzr1YvAQkuCSxSuco0gGXYiiK9+spe+UREnR9FQgoqcU4KuUHNaeH6C6q70i5Gwl64JQnE7Z1j1xGxiuIQPq60UVx45Y5N7a1I3rYgv4GlzrLRb3siTQKVT5HFqrhvZTlkh8Dzgx934xGo4G/6X3HfAREv65k1MO7qW/E6dUMKsblpfNm41W1abMquX+Ig+PcJL9xakdvKWsokSwcoAqnt8Z5Yh3IYIx8CnechTWzYqy44UyA6k91VmfLH+xg49sjhIBDwDky4wfmDDFq//HHAO+azDyz3CGsi3ve9iA1b1WjMKqZYBkrwEDiDu0fEk+H3ZU8bkDS6j6WmNvAGqVvJQhd4VJmdHR0SqBrEDErZ16EBKi04to0uQdG/x+9EE6Ffddtz9uGPkQaSlW+w8x1YGFZna8poAZ9hN+v2McEhIvPLk6TqDc0fzMyrGdiupTFVIU6Hs5XQ6K1XcQjPsE4jhpDfnCWfeRtONjRkF1whuzlUj+BvKeVSFbo4Ofk4R2T0AtOZOW23AaEGx985XKZImsfWoBtFDy6I5o0pG5jaOBvWYp5yORDBg2ZyVTT4/McfsrYnfwr9ZEPGXOSPoRBeTawNmxj+IaXyRuh4f8T9uJ6Q2zSsq6vMG6X97x01+v7L4ZbLdOu+njwciQIpL++zfouoMUr+hBewEXI7rwPF3TjcIYxnGzS4ykqNAfEnrkuMtkr47bkuCNwROQl9oJT7Lh+bDoGnf4PbbbWC
 m5XcEnjZ
 IYPktNforYLPX12Wd64loVxLWfgEJ5WRh9MLiK9K/9UU1EMIQhQrhCZO7gYmmDzIKApEcLTg98XKBKybq3GiOaboKEmZhEr7A7YoL3EQG616Jb3VBP1zcbFf3gmfM2B1kU7UOLJgJkR8+MdNr1VnLx7mCHyJPYgONtgLvYOwhcxGmhvpLVXF7lgc4kD1P7fnVGemzfZrHRlzCOiOX3d4xpFEb6jNksWaCjpxTOaIp63sX+I3owzUaUuX45h8UQ/R8HT8kwXSHABsBLvsciVPEolg6YWBnMynvfnwYduhTei0CVmIhkkpTrheGkDMdF7G2kxf13YQBpfJEmcRz3+dJB9lsIIoR+m0SLtYpJLxBFkXNMcVsL6nqSv5zNkQ0vqfdlPIJzNvAT9lrD7n4d21uKPPe1d1VlakaTBZtTgy5TsuyNk2gqLU8Rikzh5gFYFEtY0uW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae

On Sun, Aug 10, 2025 at 2:48=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sat,  9 Aug 2025 22:07:56 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
> > iterates core_filters. As a result, performing a commit unintentionally
> > corrupts ops_filters.
> >
> > Add damos_nth_ops_filter() which iterates ops_filters. Use this functio=
n
> > to fix issues caused by wrong iteration.
> >
> > Also, add test to verify that modification is right way.
>
> As I mentioned on v1 thread, please drop the test part, for ease of
> backporting.

As I mentioned on the v1 thread as well, I'll separate them back.

> >
> > Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") #=
 6.15.x
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > Changes from v1 [1]:
> > 1. Fix code and commit message style.
> > 2. Merge patch set into one patch.
> > 3. Add fixes and cc section for backporting.
> >
> > [1] https://lore.kernel.org/damon/20250808195518.563053-1-ekffu200098@g=
mail.com/
> >
> > ---
> > I tried to fix your all comments, but maybe i miss something. Then
> > please let me know; I'll fix it as soon as possible.
> >
> > ---
> >  mm/damon/core.c                               | 14 +++-
> >  tools/testing/selftests/damon/Makefile        |  1 +
> >  .../damon/sysfs_no_op_commit_break.py         | 72 +++++++++++++++++++
> >  3 files changed, 86 insertions(+), 1 deletion(-)
> >  create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_br=
eak.py
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 883d791a10e5..19c8f01fc81a 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n=
, struct damos *s)
> >       return NULL;
> >  }
> >
> > +static struct damos_filter *damos_nth_ops_filter(int n, struct damos *=
s)
> > +{
> > +     struct damos_filter *filter;
> > +     int i =3D 0;
> > +
> > +     damos_for_each_ops_filter(filter, s) {
> > +             if (i++ =3D=3D n)
> > +                     return filter;
> > +     }
> > +     return NULL;
> > +}
> > +
> >  static void damos_commit_filter_arg(
> >               struct damos_filter *dst, struct damos_filter *src)
> >  {
> > @@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *d=
st, struct damos *src)
> >       int i =3D 0, j =3D 0;
> >
> >       damos_for_each_ops_filter_safe(dst_filter, next, dst) {
> > -             src_filter =3D damos_nth_filter(i++, src);
> > +             src_filter =3D damos_nth_ops_filter(i++, src);
> >               if (src_filter)
> >                       damos_commit_filter(dst_filter, src_filter);
> >               else
> > diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/sel=
ftests/damon/Makefile
> > index 5b230deb19e8..44a4a819df55 100644
> > --- a/tools/testing/selftests/damon/Makefile
> > +++ b/tools/testing/selftests/damon/Makefile
> > @@ -17,6 +17,7 @@ TEST_PROGS +=3D reclaim.sh lru_sort.sh
> >  TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh
> >  TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py
> >  TEST_PROGS +=3D sysfs_memcg_path_leak.sh
> > +TEST_PROGS +=3D sysfs_no_op_commit_break.py
> >
> >  EXTRA_CLEAN =3D __pycache__
> >
> > diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py =
b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> > new file mode 100755
> > index 000000000000..fbefb1c83045
> > --- /dev/null
> > +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> > @@ -0,0 +1,72 @@
> > +#!/usr/bin/env python3
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +import json
> > +import os
> > +import subprocess
> > +import sys
> > +
> > +import _damon_sysfs
> > +
> > +def dump_damon_status_dict(pid):
> > +    try:
> > +        subprocess.check_output(['which', 'drgn'], stderr=3Dsubprocess=
.DEVNULL)
> > +    except:
> > +        return None, 'drgn not found'
> > +    file_dir =3D os.path.dirname(os.path.abspath(__file__))
> > +    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py'=
)
> > +    rc =3D subprocess.call(['drgn', dump_script, pid, 'damon_dump_outp=
ut'],
> > +        stderr=3Dsubprocess.DEVNULL)
> > +
> > +    if rc !=3D 0:
> > +        return None, f'drgn fail: return code({rc})'
> > +    try:
> > +        with open('damon_dump_output', 'r') as f:
> > +            return json.load(f), None
> > +    except Exception as e:
> > +        return None, 'json.load fail (%s)' % e
> > +
> > +def main():
> > +    kdamonds =3D _damon_sysfs.Kdamonds(
> > +        [_damon_sysfs.Kdamond(
> > +            contexts=3D[_damon_sysfs.DamonCtx(
> > +                schemes=3D[_damon_sysfs.Damos(
> > +                    ops_filters=3D[
> > +                        _damon_sysfs.DamosFilter(
> > +                            type_=3D'anon',
> > +                            matching=3DTrue,
> > +                            allow=3DTrue,
> > +                        )
> > +                    ]
> > +                )],
> > +            )])]
> > +    )
> > +
> > +    err =3D kdamonds.start()
> > +    if err is not None:
> > +        print('kdamond start failed: %s' % err)
> > +        exit(1)
> > +
> > +    before_commit_status, err =3D \
> > +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> > +    if err is not None:
> > +        print(err)
>
> Adding more context would be nice, e.g.,
>
>     print('before-commit status dump failed: %s' % err)

Sure, I'll add that to v3 patch.

> > +        exit(1)
> > +
> > +    kdamonds.kdamonds[0].commit()
> > +
> > +    after_commit_status, err =3D \
> > +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> > +    if err is not None:
> > +        print(err)
>
> Adding more context would be nice, e.g.,
>
>     print('after-commit status dump failed: %s' % err)

ditto.

> > +        exit(1)
> > +
> > +    if before_commit_status !=3D after_commit_status:
> > +        print(f'before: {json.dump(before_commit_status, indent=3D2)}'=
)
> > +        print(f'after: {json.dump(after_commit_status, indent=3D2)}')
> > +        exit(1)
> > +
> > +    kdamonds.stop()
> > +
> > +if __name__ =3D=3D '__main__':
> > +    main()
> > --
> > 2.43.0
>
> Other than above two trivial comments, nothing stands out to me.
>

Sounds great!

> Thanks,
> SJ

Best Regards.
Sang-Heon Jeon.

