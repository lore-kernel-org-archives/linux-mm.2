Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE71ACD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD1B6B0088; Wed, 17 Jun 2026 18:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E906B008A; Wed, 17 Jun 2026 18:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DFE6B008C; Wed, 17 Jun 2026 18:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 568B16B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:35:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1BA38F5E4
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:35:02 +0000 (UTC)
X-FDA: 84890861244.29.A9C98FD
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id C776B140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:35:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDdIqq6A;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781735700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTVuAvURpFFqS1aELb7lH98BL2WHu/TfJPzOuY03hDY=;
	b=sAV3/cEy718SnQy8uEFLWMa/r7mk1NyVD5yA2d2RhdAXxr2d+iZF/FyolHXrFf9rD2sVoK
	qAKIObIWU654VwfNC1Lpb05o26tRPLbEJqQI/osh6yI7nd1ZSRQVmS/O/uf1d88NqA0RK6
	y/eX4RSn6RFxKKMnIH7uCVubuD2rt34=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDdIqq6A;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781735700;
	b=i3LOSVRbAf16lFJX8vY1tMXbhu5cKCd1z3WOrcIOeqsuMYWOnU6gqWgbl4uY91v3PYSo2M
	QnmFSWwBnsI2PCgrQT8DNMlmtAZSoR8kACwPwOGj7ok7KoW3I+I+Mkk6uBp4ZBFuA4URzU
	/+3uUJR2v2O36AysH0QlTu5CAiOBy0Q=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765331535so52181cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781735700; cv=none;
        d=google.com; s=arc-20260327;
        b=KUjpgVwRkE7kv46y17MarbF8fQVE1EkXN0vpHa7A/LbjGI6FsxIpzhvUjNKYcvDSAx
         Ttjr9IheAgGOPmeGis9DOYOLO6L7DJUbDko5GjikDUpr7AKpviGjBzpL5o72FPB39nNA
         eOnQeBuM0CmvD95sw2vyCiloSJphHWTnBRnegzo1wJZmbXAV62wo11d63NVnzpJbIVTO
         W2xKlMgNYcq14dDOg3SiIzCambdmqXQECasH/f7ZXqA8zXpFc/i0mhh7pOh1/4kzaKQI
         lJeKi7mQpIoPSTAobL6YVvT0Kut7e9JaN7O/GjermQNfn3rz0/VDB6BEHJlkoxszQpLQ
         a6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pTVuAvURpFFqS1aELb7lH98BL2WHu/TfJPzOuY03hDY=;
        fh=H+flNQ7z31DbD0c8l10YUYToCt1py0IIdI3OnxEXB5o=;
        b=azjSFUlcQ1faibBDYftctJb4OFZkh6dsaC4ezWDMqa9LvbVAslQZuxn1pkD5CgPJVk
         duY0l+J13mPBtwow3jV4uVzuVPApROdRV9fX2eZa2hk0KH9lz7nvZlGUF8/SYfFhIgA0
         HrY7ZFZBsmxaRoAOhy048TB8grC3YmfDFS2j5I78Ei04iPWrFQM1uOim4caxQUlIaNuj
         TkbydCbd8CLXZ5FmbW42Q+DiLfTtwQ2QRUacZkRi4dF00RbGxyBdQpsA/l9o+D401XqJ
         4RbvmE/NgIy4f1OYM91ghdmzv/chM1tPV57j6anyacaQpKkxeJk7d5PNh/uSHPUo7Xf7
         fgAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781735700; x=1782340500; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pTVuAvURpFFqS1aELb7lH98BL2WHu/TfJPzOuY03hDY=;
        b=eDdIqq6AmPYHjSMsk4ZoXjBP/+ZihalF4jujOoKYePpHQp15NRfZk2B7MnGUSN/kAV
         4oXmWtLLCTiIKXKXkZ/evzHfe63VbFw2kS+u1eHKQBuK8LSK7moNm9LLqf+2gp5bbIlD
         kGDATQgoy5q7umF2tGH6Tk5MNp0uvmkoyIJSnh6ISJRJoEaAwOX+qyjPItzRTR/Qtaea
         uQDMJ/K8GsHH6th4niI92pqNsGUzys2BVYd6B4Sv+gyafhzch6hB5llXjA6qCdoMutuh
         CqQasD9C7tC8Ahha/IjjvUFmXyuFB4f3sPtEYZKTDo+qvCO5vHCBDJSN9VKKRWlKIOf/
         Q+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781735700; x=1782340500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pTVuAvURpFFqS1aELb7lH98BL2WHu/TfJPzOuY03hDY=;
        b=e3hAUHzD1ktVwBYxLAMry+H14uwcvRq/8j9TwcBnTkalGBdPQ6pqHwzPb2lBUajC0e
         jDvk45LaeisZ7txEzYWWtGJrbPCLAMgzwzQsV4f1wM6JHjbX771ux2WJFvkuHw8pP2mn
         LZ2h6pg+aaR2L7oGR8FJTTJZ3uwOQ6sKCjf/is8L4YiHLhk8EGS5W1z1FPgJfPLOqW1c
         FUIihIhP6gJ50comZ4AM8x3AqKLUuPOk2LAfSBPLz9pAL1dzT88c6WRU2e0rJFH1xAH5
         n/ElO/JwXl3362mEb5Mu74qeZgxxoMIyIiHOizuF4L1n3uSeDmY4bhsAwNm8mUs/y+rm
         Njig==
X-Forwarded-Encrypted: i=1; AFNElJ912chPdDylnM2aXbJpeMt1Yzcaqbjfqjr7mBuscTIMf1IgRmruokeOdX4J5ajGR8h77mJKr7U6Ng==@kvack.org
X-Gm-Message-State: AOJu0YwYXF4RzwWtQNx6gOJD1iuPbZj+Glme4JLFk9OaiuMP2DR+1w9h
	bq8Hu8p8wLqZA+AwEDJV20YFfLSnYBLUnqeYbt2UgAauP49bU0sxVkycCuVOfWYOLXsB7NcGnes
	dHBpCORdrU7uZOibOm+d5lRCYYh8q1rqPiakCkOol
X-Gm-Gg: Acq92OE8a9PH5w2Dvp5MWC69qitYEAluG4ZyU44JyuZ1uANbKZCSyAV5/mwdcrI+unl
	IUpTMzPnOxT6PPLP3H8pUkmALhDC91rSrzR+S0Ua868dVWEWJjZP5NQDYnd5IBGWCd61yUf1MFZ
	mFLEPcGCrmzJHpAXMYBJYb8QTiLvJsMj4H0lwnDGX90yoqFFNlsYtjJM3V3lRdR7xnhGsgMQp2/
	G3pHckbujIY8uV4aMaRlPKAhCydnauiRfuorcfPvVenTnaA2G+a4gjOKgXj0CvKkU4edzj1w0wb
	GE8xMw==
X-Received: by 2002:a05:622a:2cb:b0:516:4f62:85ed with SMTP id
 d75a77b69052e-519c67370aemr3232591cf.18.1781735699254; Wed, 17 Jun 2026
 15:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com> <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com>
In-Reply-To: <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 15:34:47 -0700
X-Gm-Features: AVVi8CcP352oaIub18lo0sw7Ja9sgom3LLOMahFEujS6dbTA61BAY_UC5ngYnGM
Message-ID: <CAJuCfpGOrtk+3hvUVE7-6wpnsa3Nbr6kGq5CfHVdCzX+DYyjFQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f4pdbtt79bmq4b4j7gq5otoyr4mk48je
X-Rspamd-Queue-Id: C776B140002
X-HE-Tag: 1781735700-624943
X-HE-Meta: U2FsdGVkX19tJO9ZL93fgn4djZEKd7uNXs5hEwdpkpeibWhvpGIJ/IIlc8uO/bQKw6UBkJK34Hw/TCmmHMyffAb6jeU4KYl2XuDJ3yc8t2OQIaYWSejT22PvrssnH4lmUcRvMa+6IbL0MnBdOhaCpvaYBPhxd4dAg4I0R30zBjIzvop1lWZSVsD1cF7kaUxzrYPguE0VU3IO+kQCLWN7F6hZEYHPUw81pdt1xBTAT8yfPxdSZZMlWIy5S2i7EAHlnpvZJIITGQePgI4l28v9jFC3/ZMWdzv+BGltTefaiZ40LxH3p6OTL6rBKLHW6nkmJj0dqB3mVv+PWZ2JY+I9iM4tq7fAGVA/3Vmp/I1sU6bqkTPKcrOL2sbkfdfqoEMUHdyq48rBZ9yOVM2Mn91nkC8T4+Bn/uxeerRg15JSY5Iy+jppWExfpyhu4jzaaBrY85JAoXUx+G62DaaaPyVWM8Z3FopWr0QLXrxnCmNXCIK/SpVBvUWY3TBGZUny4bZvFLshr2Vhcz4FB3Zx3EzovoVk2xLcp5kKrH9/BYIDVfNNGRwDwOs98Edv5wGkxE3eBQ0FP5YvC/d3wssCn6cGs71hl+TYQ8/Iwbw4NxzcKZWImTPS5s/tABYCq8MmxFJialYv9RxehCyIt31lmdhm5izIQ0a8gblgy/yq9GQ3IMjPmhDxZy/A3+bI7+0pc3yO+BqSlNuPw9R8x1Z/eiwCAWAC0VUFOgQrKGTIwJdrINJJkCSeoO0zv5NF345Obmlm5J7Bd/zujZkfiEOFWt+TVu9gU1L/9ceLP5IkDSW2QrkSMhEDVpCk84WMZ69RaHkldZHzhK8U+J4OeYR2mHLaILRS1JfhfMlkxh+TL6PWDAfPYporcDRqY91MlhKhQuBpdscXnIHaaI8H8S4CBFtvvkgN+K9u2jAFFeOUPQshjFtFnrRrJu6SEtR+gTyHNFwclwujKbOAnYR/98DDAZP
 NTuBckbO
 K+e4mPADqPRpG8g8SBUEf6v0VgD+bpD+Cddtsr36Z50OqKznXLmXq0YMvMZ5uY5E0ClwJWaGL25RZ/H4KFVNyb9APnWgzHqLEbzptNTqtFmTQHpe6zCXOH8qfF8aFdKRADzeuJeB9xfi0tjgqWdhBLlnm/i7x88ldMkDgfPdWQuQh8VbngXbnCoYnShSHb8Ew5cu4NA5vQUhJdmvx5rx+HHMm1bMElI84OPLiC8X4JGvPzAOZz+v3gNZG+qkuf1uAt+rSILodOg1tJlnRJgC2sq8/0P6Ujzwm3RoWXWkBZsRp3aVkx17RDkS17/Ih6W6/rqCstY4VuQY3JRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 1:55=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@g=
oogle.com> wrote:
> > >
> > > Extend the allocinfo filtering mechanism to allow users to filter tag=
s
> > > based on the total number of bytes allocated [min_size, max_size]. Th=
e
> > > size range is inclusive.
> > >
> > > Filtering by size involves retrieving allocinfo per-CPU counters, whi=
ch
> > > is an expensive operation. Hence, the performance of size-based
> > > filtering will be worse than other filters.
> > >
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > Acked-by: Hao Ge <hao.ge@linux.dev>
> > > ---
> > >  include/uapi/linux/alloc_tag.h |  8 ++++-
> > >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++----=
--
> > >  2 files changed, 59 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/allo=
c_tag.h
> > > index 3b11877955b9..7f5acbb44c14 100644
> > > --- a/include/uapi/linux/alloc_tag.h
> > > +++ b/include/uapi/linux/alloc_tag.h
> > > @@ -45,13 +45,17 @@ enum {
> > >         ALLOCINFO_FILTER_FUNCTION,
> > >         ALLOCINFO_FILTER_FILENAME,
> > >         ALLOCINFO_FILTER_LINENO,
> > > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > > +       ALLOCINFO_FILTER_MIN_SIZE,
> > > +       ALLOCINFO_FILTER_MAX_SIZE,
> > > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > >  };
> > >
> > >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTE=
R_MODNAME)
> > >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FILTE=
R_FUNCTION)
> > >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FILTE=
R_FILENAME)
> > >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FILTE=
R_LINENO)
> > > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTE=
R_MIN_SIZE)
> > > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTE=
R_MAX_SIZE)
> > >
> > >  #define ALLOCINFO_FILTER_MASKS \
> > >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > > @@ -59,6 +63,8 @@ enum {
> > >  struct allocinfo_filter {
> > >         __u64 mask; /* bitmask of the filter fields used */
> > >         struct allocinfo_tag fields;
> > > +       __u64 min_size;
> > > +       __u64 max_size;
> > >  };
> > >
> > >  struct allocinfo_get_at {
> > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > index 5feb61d9fb92..b3d21834b61e 100644
> > > --- a/lib/alloc_tag.c
> > > +++ b/lib/alloc_tag.c
> > > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str, c=
onst char *template)
> > >         return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SI=
ZE);
> > >  }
> > >
> > > +/* Fetch the per-CPU counters */
> > > +static inline struct alloc_tag_counters allocinfo_prefetch_counters(=
struct codetag *ct)
> > > +{
> > > +       return alloc_tag_read(ct_to_alloc_tag(ct));
> > > +}
> > > +
> > >  /*
> > >   * Populates the UAPI allocinfo_tag_data structure with active runti=
me
> > >   * profiling counters extracted from the given kernel codetag.
> > >   */
> > >  static void allocinfo_to_params(struct codetag *ct,
> > > -                               struct allocinfo_tag_data *data)
> > > +                               struct allocinfo_tag_data *data,
> > > +                               struct alloc_tag_counters *counters)
> > >  {
> > > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > > -       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > > +       struct alloc_tag_counters local_counters;
> > > +
> > > +       if (!counters) {
> > > +               local_counters =3D allocinfo_prefetch_counters(ct);
> > > +               counters =3D &local_counters;
> > > +       }
> > >
> > >         if (ct->modname)
> > >                 allocinfo_copy_str(data->tag.modname, ct->modname);
> > > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *c=
t,
> > >         allocinfo_copy_str(data->tag.function, ct->function);
> > >         allocinfo_copy_str(data->tag.filename, ct->filename);
> > >         data->tag.lineno =3D ct->lineno;
> > > -       data->counter.bytes =3D counter.bytes;
> > > -       data->counter.calls =3D counter.calls;
> > > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > > +       data->counter.bytes =3D counters->bytes;
> > > +       data->counter.calls =3D counters->calls;
> > > +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_all=
oc_tag(ct));
> > >  }
> > >
> > >  /*
> > > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct =
seq_file *m, void __user *arg)
> > >   * Verifies whether a given codetag satisfies the active filtering c=
riteria by
> > >   * matching its characteristics against the specified filter.
> > >   */
> > > -static bool matches_filter(struct codetag *ct, struct allocinfo_filt=
er *filter)
> > > +static bool matches_filter(struct codetag *ct, struct allocinfo_filt=
er *filter,
> > > +                          struct alloc_tag_counters *counters,
> > > +                          bool *fetched_counters)
> > >  {
> > >         if (!filter || !filter->mask)
> > >                 return true;
> > > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct, s=
truct allocinfo_filter *filter)
> > >             ct->lineno !=3D filter->fields.lineno)
> > >                 return false;
> > >
> > > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINF=
O_FILTER_MASK_MAX_SIZE)) {
> > > +               if (!*fetched_counters) {
> > > +                       *counters =3D allocinfo_prefetch_counters(ct)=
;
> > > +                       *fetched_counters =3D true;
> > > +               }
> > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &=
&
> > > +                   counters->bytes < filter->min_size)
> > > +                       return false;
> > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &=
&
> > > +                   counters->bytes > filter->max_size)
> > > +                       return false;
> > > +       }
> > > +
> > >         return true;
> > >  }
> > >
> > > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file=
 *m, void __user *arg)
> > >         struct codetag *ct;
> > >         struct allocinfo_get_at params =3D {0};
> > >         __u64 skip_count;
> > > +       struct alloc_tag_counters counters;
> > > +       bool fetched_counters;
> > >
> > >         if (copy_from_user(&params, arg, sizeof(params)))
> > >                 return -EFAULT;
> > > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_fil=
e *m, void __user *arg)
> > >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > >                 return -EINVAL;
> > >
> > > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > > +           params.filter.min_size > params.filter.max_size)
> > > +               return -EINVAL;
> > > +
> > >         priv =3D m->private;
> > >
> > >         mutex_lock(&priv->ioctl_lock);
> > > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file=
 *m, void __user *arg)
> > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > >
> > >         while (ct) {
> > > -               if (matches_filter(ct, &priv->filter)) {
> > > +               fetched_counters =3D false;
> > > +               if (matches_filter(ct, &priv->filter, &counters, &fet=
ched_counters)) {
> >
> > Do we really need this "fetched_counters" parameter? Here are the
> > possible cases:
> > 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
> > 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > ALLOCINFO_FILTER_MASK_MAX_SIZE and
> > 2.1. matches_filter() returns true then we know counters were fetched
> > because they had to be validated.
> > 2.2. matches_filter() returns false then we don't care if the counters
> > were fetched. We do not report that tag anyway.
> >
> > So, instead of passing fetched_counters to matches_filter() we could do=
 this:
> >
> > bool filter_by_size =3D (params.filter.mask &
> > (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D
> > 0;
> > while (ct) {
> >            if (matches_filter(ct, &priv->filter, &counters)) {
> > ...
> > }
> > if (ct) {
> >            allocinfo_to_params(ct, &params.data, filter_by_size ?
> > &counters : NULL);
> > ...
> > }
> >
> > Wouldn't that work?
> >
>
> While we can deduce whether counters were fetched outside the
> matches_filter function, I think the current implementation is more
> intuitive from a readability perspective. I believe it  should be kept
> as is for that reason. If we extract the logic, we'll first have to
> replicate the boolean logic at two places. Second, we'd need to add a
> comment explaining the boolean calculation, and the reader might have
> a higher cognitive load trying to determine which function populates
> the counters. The current implementation makes it easy for the reader
> to deduce the original intention. Let me know what you think.

Ok, I guess you have a point.

I was also thinking why we are passing NULL to allocinfo_to_params()
to fetch the counters into a local variable? Why can't we simply call
allocinfo_prefetch_counters() before calling allocinfo_to_params()
when fetched_counters=3D=3Dfalse? Basically:

if (!fetched_counters)
    counters =3D allocinfo_prefetch_counters(ct);
allocinfo_to_params(ct, &params.data, &counters);

This would simplify allocinfo_to_params() because counter will never
be NULL and it would not need local counters.

>
> > >                         if (skip_count =3D=3D 0)
> > >                                 break;
> > >                         skip_count--;
> > > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file=
 *m, void __user *arg)
> > >         }
> > >
> > >         if (ct) {
> > > -               allocinfo_to_params(ct, &params.data);
> > > +               allocinfo_to_params(ct, &params.data, fetched_counter=
s ? &counters : NULL);
> > >                 priv->positioned =3D true;
> > >         }
> > >
> > > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_fi=
le *m, void __user *arg)
> > >         struct codetag *ct;
> > >         struct allocinfo_tag_data params;
> > >         int ret =3D 0;
> > > +       struct alloc_tag_counters counters;
> > > +       bool fetched_counters;
> > >
> > >         memset(&params, 0, sizeof(params));
> > >         priv =3D m->private;
> > > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct seq_=
file *m, void __user *arg)
> > >         }
> > >
> > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > -       while (ct && !matches_filter(ct, &priv->filter))
> > > +       while (ct) {
> > > +               fetched_counters =3D false;
> > > +               if (matches_filter(ct, &priv->filter, &counters, &fet=
ched_counters))
> > > +                       break;
> > >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > +       }
> > > +
> > >         if (ct)
> > > -               allocinfo_to_params(ct, &params);
> > > +               allocinfo_to_params(ct, &params, fetched_counters ? &=
counters : NULL);
> > >
> > >         if (!ct) {
> > >                 priv->positioned =3D false;
> > > --
> > > 2.54.0.1136.gdb2ca164c4-goog
> > >

