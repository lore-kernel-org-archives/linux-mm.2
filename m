Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54292CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F6A6B00DC; Mon, 18 May 2026 19:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EB86B00DE; Mon, 18 May 2026 19:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DDC6B00DF; Mon, 18 May 2026 19:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC3B6B00DC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:44:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B67A1A0A5E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:44:13 +0000 (UTC)
X-FDA: 84782171586.22.5AB7ECA
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EB7F1C0008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:44:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLedGTEm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vjjrnb0zzLCqFpCp1zPFpzNxaHxcXt90nJobkRgJJ64=;
	b=G6dFTRuvdTCu03vpa6zM1tVYzPVYXERfazRjIdH6CIAiV1sO6echWjV0V46rdpYeIl1/of
	aABNyhD1INx1zYhd0QRbewooYSwv5elxFeUfw/Wx42LkVaF+sca6voZj9sQfYfRyZAW4Iu
	56dXMOQV8Jl0eC+f8pLUepP98Z1wayE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147851; a=rsa-sha256;
	cv=pass;
	b=YOZmlZqox2yAX+XUEInDhCnXAGvaYHtLyx/wHklM6jKTKMvmfIX+DPLocLvATPhdXYdKsI
	onD3O1wdBK64dvhWROmFdDMkXGVL4Kpz1BlDJ4H/sAqw5nIHGLNg69n8sgNloeI2HTrxO8
	gbgGs7+Q1MCGhxifAum2aBxYTdPWMaQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLedGTEm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b46da8c48eso205ad.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147850; cv=none;
        d=google.com; s=arc-20240605;
        b=Ak+34igTF1jtnb7bb5uVA9SzrmfCNaYG9HeFyxK3fJMGBVFqFV7ZDw+eQRzZ5NVIYM
         CSiFbAzEvkqxw8OZk5tsqCsYDEu6oDPgIsKvKSyZCbrWCH+V+Jtq2qupCxjZumiB2Qol
         uaJ+XC+8XxPTMYXjZ8pei3hnzNlMpHZ0/y2gAY0RUlShoNaCMRHNDU/cj7CPH6ia9oBg
         xlEohbmZUXtzQXmkCgZgAa1g83X4Yl6L7iethfNQcXiVEPGhtfCcNJk+qoI/5bb6OD/l
         yOh80dZnedLNA+s+pRIY1BILG6yxzbVV97yXppEYg+ncOH0FIJn006GotySL/jSirj1M
         hQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vjjrnb0zzLCqFpCp1zPFpzNxaHxcXt90nJobkRgJJ64=;
        fh=h9m9Ur41u+NOhyqXsP8PXYkl5/dKnvUxJ1KADBwB0vE=;
        b=j9mOFrrFMGNizYPeLylchNFVLmyYUa27rDmfVRW/nXUsF8OBM0b+q01Sv3sznJBguu
         rTo9cqHg5VXemqOBPlYDEOI7dHPo4eJyR/kqAU/2qBfDVAzAqb6LZOk0LZftXjVAej1y
         fxEEdZAOX+JA1FMO4rY7rHzNKRnsrFm0GB6+IipCPkhf8XZu763ecfIl7x7R2rk0t9Ya
         QhgWF+KWYns+y+9Qaj8kewvmDBEEx8O5mXD4KCO0Ld7Nzq45beJeU/kJ0yUPXuAVfuHR
         vE8mgs4vY6y93EUN2Y2AxyiDP/SML5wciQMvdvGsQkzoUAfThs2bErU1ahWUy6H3bvX3
         7WuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147850; x=1779752650; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vjjrnb0zzLCqFpCp1zPFpzNxaHxcXt90nJobkRgJJ64=;
        b=JLedGTEmB7ucNcqEgMmbU/ea+/oHfIatee7+Co88a0LrpsRKfDbFCHIg+VOdFH7KC3
         t1HlPxjNKlL2HWPH0Bnqu8HofW4vvgxPFnmtMvpv1zm2/9b+6gZn0zhC+fnoBsODWK3f
         R/LnmgasC66j5NiBWJXJDtt+b0BCR54uN51l5ZLs711+1g1G67jfX9L0z4txnMmK1qj5
         9tMxzGKq0rqf8ECAGyGQigSZ3FSWN3okXMb2XXkK7q7gCEPp/BUR0o7KYAOpj92qItIF
         EQ4Mj2M6zJk1OiU51kf/jMr7WZyqK+rY7+9wzD99EMQeBvy5Jw60aWpo2LevF+HQDqkJ
         uBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147850; x=1779752650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vjjrnb0zzLCqFpCp1zPFpzNxaHxcXt90nJobkRgJJ64=;
        b=Z+Qp8Xm7rhHFbBZ5/8jL7YnVX/BbkuBiFonfWOY65Nob2FYPOZ0sm23+YYTjyMwHoy
         quMAA8rtojBNmQAh60A5w0i98RMhkDk7mO1MD71DNEAluPJyg123flYVR/TOg5hF1Qhb
         dI6+g1sy9qvsHCZ3NQHAYWZNBy/UuRoR3TRTHbsVENMR7FktRIsfZvIEF6fdA8gDTJvg
         xiATqF0PN1x349dOPGQZ8XjEjpajU+/mLRMwR7ajWAW4WwW7GerQlsGsi0GLeAxjbeWS
         bKeElUZ0TnGGkZjHT0lp0e2Afx4OvELmJT7AgEvR2F2MLSi1hlLZwXnpbwVEF79zUaPB
         ZWxg==
X-Forwarded-Encrypted: i=1; AFNElJ+f9HrIWqlTzvAxjr7CCkemmzuwvBosnpI/AkHEQ3B4s7eKrharVcg/xM1yVsc3NxBMYz6HpDZWkA==@kvack.org
X-Gm-Message-State: AOJu0YzTPQvXJdeQZt76rWpNt7W2/67iLTfN8ifUAOHcPZqmy1ornAI2
	CClou/+uVr4wb/I057FEZBQYpuYanS6mt9mr24L5J9x2WKI+EAPJqWnd+1LC7OCi0/qPi7WUUYB
	Fj9+mKHG8VKCJ+FCQmQDpBgx9pU0/vlUyHZTheOz/T4q5S2YMCWeuwyjh950=
X-Gm-Gg: Acq92OGQo6bT6+hAt1w+rbrDTsTNSCZrkKycR1MCVArqHXLem3o5gCUolFFgsGsRy6t
	l8bTbTHyoe++0sda/5JSDGFk48ipi0tY5SljW26cd2aBEU2mEEGEU/EUleppQDkiLVzrFhTLh5c
	tbtkr/djUx796sACEThCmP8ItwgZt8tMvjblBB+bJ3K3p2Ayo3H4Mz6+vdUzct+W/X1+1yznyfY
	u4C6AvZnr2b6MdRb3qOHuyDGPW7WxtcgXr/WFZFX4GRolrCe/Qy+f4TtBJTiVvzqKJUVbzPEsZv
	VLIQDfhYyoLMKRTolVbqwXrTGmd4x9J8dOpubrC6HVZE08Gk
X-Received: by 2002:a17:902:db0b:b0:2bd:6dad:3df8 with SMTP id
 d9443c01a7336-2bdb0410748mr4322435ad.22.1779147849409; Mon, 18 May 2026
 16:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
 <06b4fc2457fb4b75eb1ef18320a8722ddb5a850f.1777936301.git.abhishekbapat@google.com>
 <b681fad1-1a27-47fa-b58a-1f639eb3f3d9@linux.dev>
In-Reply-To: <b681fad1-1a27-47fa-b58a-1f639eb3f3d9@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 18 May 2026 16:43:58 -0700
X-Gm-Features: AVHnY4Jpj1TOqBWxRSpppDVQiGaaapy1D4FbzylwALObYIpRvFGN07LLS_hQngc
Message-ID: <CAL41Mv65WwzdYsehUn9Ciu5PBKrMF6Wyun+BiqdTez9d7c6SRA@mail.gmail.com>
Subject: Re: [PATCH 3/6] alloc_tag: add size-based filtering to ioctl
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EB7F1C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: w9r47gq9w6q7gw8xbyt4jinjo9cupi7m
X-HE-Tag: 1779147851-380672
X-HE-Meta: U2FsdGVkX1+5P8Nfc4nQTw+z1wwAehiWb6WTr20gAH25reyno1kdumSt/DtBnSGCDdxsw8DuMr69SL1V0LGkp8Qka7Y9I93/mAvO6srTo1owE8YnR/Tsy7TJyRu4Ntn5UrsrUlFu5q9uGFqiZRi//qNnf2NnrKxGRn3rRpY71c7a6cvh+m+1/sMb51GmsOkuObt0ec+MkKisGUefo41w4zUyS0mMpSLkA7oe45xb3wgY3+ZjGy1ueIzd9pRRLEircaXIoocW86wCye3AhBiqHhraIKOYpPL4spLEWNO6clDCdN82yUEWnngJFvJ3aN49Me8j834cjB6Z93kiMV1Qt2uDDOJzkyxTzBqg9hdMIPfNt3hbeQM7E15fEQXguHwPQ0v0+7yGTtomvPTq9Xc6/paG2Jet0/R9PdD7nWxbY5mU+W7bgCNqLLRRMA5hQNlB0hfarVzm2mNmlkVZIfdSqZYturuh1881+q4bbs5mzu907QjYj6GbWa74dbuS7x6n7weQEyS75r4H2OGoR21ka4tTxidjElrAVLWPMr8bK47NrIg0ZmkRumySQD7NV7SHh/pXol0EIE5h59aeRJWT0pe/nkHJlMrWusKfJcH1X5WQuF06bwTHnuwya80gPdGZNukTbw73arx5qnxM7FaIt1nECBkZa0QBNful+cOjwrX4Uv72gG66YQ+MS9yERVcB/sVEV9GimA2p7o8xr25QoythhvATsPkkJSiUcAYZ8opL1jk4/u7g2xDuB8iqZedYynRtiT3NKa7Fd3JSspdQxhARo9EXqrpIw+6oFntbPolruBZpJzyW2fUE5nBufSgmucbUBRgSoqLZdj2YHaV6YiIm4ZWxz3rgHtbavx6T6O5tLTrCVUIDzSN4P+dGCe7TqDYTGR4XKJFgHc1P2yxA7kRYv1vRj/4el7JkzdTTAHosph4rGa8qQGCoREFPTjoaswzY99uvplpxeYydhfj
 O5ntZYNI
 UE/bWDWQUzpgb2CN7lwV7Rwe8SQgKfpIy3GoafBzX9BDdtBgZraM1COtwkoxpvMWXN7xOE8dxUUI9FOL6J/K2OadD4L/PTDdRwwAjAwChdzNcnD4IRFft00iUerEpYYKZ4dPHiPSWL4Euqs3+sW4P6HAN3as5S6CNgKN6azWe/q1CsyokX1Yj22Xho+yndyVCHBJH2Qh03TvR3im/WU2Qm9IbiEBetGLQAQkc+Qk6I0wgEHeOatVk3FPQYQUtK3M5NaAhp4D6S6c3yTKVzQkbTUB8vmhBWCjs+v6a9BR2MWmDfWuqZfoZc+kV+NUONncXS1jilwjDL40c+A0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:54=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/5/5 07:36, Abhishek Bapat wrote:
> > Extend the allocinfo filtering mechanism to allow users to filter tags
> > based on the total number of bytes allocated [min_size, max_size]. The
> > size range is inclusive.
> >
> > Filtering by size involves retrieving allocinfo per-CPU counters, which
> > is an expensive operation. Hence, the performance of size-based
> > filtering will be worse than other filters.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   include/uapi/linux/alloc_tag.h |  8 +++++++-
> >   lib/alloc_tag.c                | 15 +++++++++++++++
> >   2 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index 0cc9db5298c6..229068efd24c 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -20,6 +20,8 @@ struct allocinfo_tag {
> >       char function[ALLOCINFO_STR_SIZE];
> >       char filename[ALLOCINFO_STR_SIZE];
> >       __u64 lineno;
> > +     __u64 min_size;
> > +     __u64 max_size;
> >   };
>
> allocinfo_tag is used both as a tag identifier in the output data
>
> (allocinfo_tag_data.tag) and as filter criteria
>
> (allocinfo_filter.fields). min_size and max_size are filter
>
> parameters, not tag identity. Also, allocinfo_to_params() does not
>
> fill these fields, so userspace gets zeros in the output, which is
>
> a bit confusing. Might be cleaner to separate filter parameters
>
> from tag identity.
>
> >   struct allocinfo_counter {
> > @@ -39,13 +41,17 @@ enum {
> >       ALLOCINFO_FILTER_FUNCTION,
> >       ALLOCINFO_FILTER_FILENAME,
> >       ALLOCINFO_FILTER_LINENO,
> > -     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > +     ALLOCINFO_FILTER_MIN_SIZE,
> > +     ALLOCINFO_FILTER_MAX_SIZE,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >   };
> >
> >   #define ALLOCINFO_FILTER_MASK_MODNAME               (1 << ALLOCINFO_F=
ILTER_MODNAME)
> >   #define ALLOCINFO_FILTER_MASK_FUNCTION              (1 << ALLOCINFO_F=
ILTER_FUNCTION)
> >   #define ALLOCINFO_FILTER_MASK_FILENAME              (1 << ALLOCINFO_F=
ILTER_FILENAME)
> >   #define ALLOCINFO_FILTER_MASK_LINENO                (1 << ALLOCINFO_F=
ILTER_LINENO)
> > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE               (1 << ALLOCINFO_F=
ILTER_MIN_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE               (1 << ALLOCINFO_F=
ILTER_MAX_SIZE)
> >
> >   #define ALLOCINFO_FILTER_MASKS \
> >       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 7ff936e15e97..98a27c302928 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -195,6 +195,9 @@ static int allocinfo_ioctl_get_content_id(struct se=
q_file *m, void __user *arg)
> >
> >   static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r *filter)
> >   {
> > +     struct alloc_tag *tag;
> > +     struct alloc_tag_counters counters;
> > +
> >       if (!ct || !filter || !filter->mask)
> >               return true;
> >
> > @@ -214,6 +217,18 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter)
> >           ct->lineno !=3D filter->fields.lineno)
> >               return false;
> >
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
> > +         (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > +             tag =3D ct_to_alloc_tag(ct);
> > +             counters =3D alloc_tag_read(tag);
>
> alloc_tag_read() is called twice for matching tags
>
> When size filtering is enabled, matches_filter() calls alloc_tag_read()
>
> to check the size, and then allocinfo_to_params() calls it again to
>
> fill the output data:
>
> matches_filter():
>
>      counters =3D alloc_tag_read(tag);        // 1st read
>
>      if (counters.bytes < min_size)
>
>          return false;
>
> allocinfo_to_params():
>
>      counter =3D alloc_tag_read(tag);         // 2nd read (same tag)
>
>      data->counter.bytes =3D counter.bytes;
>
> For matching tags, the same per-CPU counter aggregation is done twice.
>
> On large machines this is not trivial. Would it make sense to cache
>
> the counters from matches_filter() and reuse them in allocinfo_to_params(=
)?
>
>
> > +             if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +                 counters.bytes < filter->fields.min_size)
> > +                     return false;
> > +             if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +                 counters.bytes > filter->fields.max_size)
> > +                     return false;
> > +     }
> > +
>
> No validation for min_size > max_size.
>
> If both MIN_SIZE and MAX_SIZE are set but min_size > max_size,
>
> no records will match and the user gets no indication of the
>
> invalid input. This could be checked alongside the existing
>
> mask validation in allocinfo_ioctl_get_at():
>
>      if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>
>          return -EINVAL;
>
>      +   if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
>
>      +       (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
>
>      +       params.filter.fields.min_size > params.filter.fields.max_siz=
e)
>
>      +            return -EINVAL;
>
> Thanks
>
> Best Regards
>
> Hao
>
Ack, will include in v2.
> >       return true;
> >   }
> >

