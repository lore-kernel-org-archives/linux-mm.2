Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED11CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D0E6B0088; Wed, 17 Jun 2026 18:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E3B6B008A; Wed, 17 Jun 2026 18:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C926B008C; Wed, 17 Jun 2026 18:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7435C6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:41:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3DA7C2757
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:41:14 +0000 (UTC)
X-FDA: 84890876868.29.DBD58B2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD7CE20005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:41:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p5nMVYpe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781736072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gH4dbwYpQtVmkxDqEyULaiA0pAkeR8kFfXWefeo0Joc=;
	b=uwztOGndwRDoiCwx22rAz2j9cqHg3fXDmgue9p2+S/zTDTjOp8iUDIxsYU43kJl7Jaj++j
	ftNrFex+5ZuG9ZHfm75Sgt/k/q04arep7ACsKIcWJYsLNQRMD6uctzy8XN3uW8/kgUQ26L
	Ik8Zagurq6i+TuA+AyfqktkwJuLiyW4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p5nMVYpe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781736072;
	b=2jX3u+B5aPNcNDESHFaEne9SBuCwtlOkSxrK5SjL4zovvYbhJwz3vmOSqkdUhnhIBy21W5
	1DYItDsYKPfcyNJjFhF6up6h3qp7Mq8BkDRTNbMoQOQ2bMk8FtON7hp5ZMuCB08EJdKEeM
	K7Urv7Hy8Pi9KKbUv54Qw2ASCUC8/Oo=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c69fa0b1f8so19575ad.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781736072; cv=none;
        d=google.com; s=arc-20260327;
        b=lxWee4lKRJt3G9mDwCbYVOVKS4wSpZ8yDkeomJseL/2GNsbSZRAwxfkkazB/BoNa/w
         S7yMvpn+2zy2jqRnJObQ7ukQexVnDibKJqXsYKMof7INAhZwsuQHmGOH348nazpX+Ew7
         ON9TnI2FmXPQSo0owdnBDef86gIC1Uw/6buik6JVrukS1YccUZN1+acnYUDhk6yFJbal
         K8cvEi2fZmGiSWdoepH6FMVKePIXlBvrhfcgFqTYkf3ajSBZ28ZOI0iWrolekx3Ua8g3
         AUqPD31GamYLeP0SkWJqGmRCblsv8ovJtLztgWMxqLeGmfWED3s3dIbrpJGE1iTlB2Zj
         hqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gH4dbwYpQtVmkxDqEyULaiA0pAkeR8kFfXWefeo0Joc=;
        fh=uA9/NCHXTCvLpk1HyEL9i6h++RY0cVr/4rHLHNiKeKs=;
        b=Dcu2jfanYEufeYZmBZy73S3wQAeX0srEjnlQaqPulR0Vzy2MaJCOgGyqCiJZaIJcT/
         8wWl+fsxChndE4/kVPJkvHUv/y17CM1Kqxx1HiPAoj6jh6B7ymp7eIsO/ZgQ6WZUehxf
         yjaEY/wfe4mUf/IikwWfk9W910K8RdSEq6AVphLkU+Ta1SjxduyeldqJm7KNkMpBwseI
         4bvfFDH/T9XyCKCJR1tVgE3sqPJUJVj2Gm+lbrMgTOCbopQKQrX+d3aIFas1kORcsJko
         FBicn9bB24kvgv+BXBlv0smTJpO5zvHeUZ+GqhoOi8CsdIANUMefj6lJGchTxhRZ3Om7
         Hfeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781736072; x=1782340872; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gH4dbwYpQtVmkxDqEyULaiA0pAkeR8kFfXWefeo0Joc=;
        b=p5nMVYpe6j4A5e50q4WVnclNETe3F5J9JTqneiU+qCdtd+rMuD0cojHxvh9M60g8Jm
         9gagnkcM60v+dUgAgNairgjGxJoieujvijAcgpy+G+Ttx+yI4uLaM2t2qtGSHtWmLlY3
         A8p64Wh6JDTzRtmUiLJiIFak+Zbtm7QNJRduezlwNMDehweWGL/jnM1Q9C5moJVHuWGK
         3FSY9BYsg40y4mrfUTxWEEQ2sy8jSTwPcQgqgJYuiHzLNrJl5hsfahkw0ATbWiHLgJbL
         8vVdOz3auwD5iVAYBxAmj9XnoAXvI0IySKAEhPLGSXQVtYOyKrLCTbcIzLCHRY6eS2gQ
         z4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781736072; x=1782340872;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gH4dbwYpQtVmkxDqEyULaiA0pAkeR8kFfXWefeo0Joc=;
        b=lW6IR+m58ID7lrASQf2lgBd+p//FFxTMxC0NsPldmHnNXhngpYfKv74YaDf1Hw32cC
         akwUyAz1JIhNeS7AAuGhB8ieGVrA1/lMXQOE681wAQ0MkuUATZHRy5LxEMOdvWLPeag4
         rJeavIJctZ+sJZV0Zh3t4jMfBvUPR/jZ6dQ+7r8VdTKGbZHREiaRalNv4/9iMinA5Evu
         2cmPIgB82W/3toFs11owojHVRK3RjHd3LUFtzM0wjfI1GZyUEb4dzZ5Pqhz2KpCZlvft
         GDl1GW138CFBz+wd2SZjEYx1xd5+3idyyP0I4nY3cANb7DfpTPYj6HRDEOYro2Cw/37q
         HR4A==
X-Forwarded-Encrypted: i=1; AFNElJ/9l3aaOXDeyP4jwg7Zr2qd9lrVYeVo8Df4BECAopjpA2NRC97LF4BUI09f2QPndJyBic2zgm1Mnw==@kvack.org
X-Gm-Message-State: AOJu0YzyEFWS9zvf9VkfgEzzvRap5ocG9CZPocPUftSzYPOCtvlAvSBE
	8U7VrTijcD62J5q8wlQJ8xKgo9JRYuiEdW9VFnNJl786Mu5w0RsvT/4AvRkf0oc22+/Npq/pIpW
	3uvL7NnP3ntLqHaUJVhwcED+sRuEszeWV5YX+5C4g
X-Gm-Gg: AfdE7ckcdecF+Ha6brTiEyDpTFR6HDv3PYKD+fArTeeOJAv0RtxgzVydSR1lyTMuMgl
	FD/p8v9DUxyBEV2RIZ+oXALH88esZj7ky6oWqB1dNfm85zOiCWuemBOxVFphdtiXzW1OCjCXbIP
	RsojbVncKwz8q/4BhIRhIFDw4NFIKnilbLvTxmHZDTW9EzQIsXBngTFMKXkIvkKLN+Av04zK1kb
	i96ODE7f4yztHsZHqQ8WKRfOtzIZg5Ho2eh/hcgsaBGGFrKJaMog4coj1qCxPgWiEg0r0WV+w8O
	qbeLG3MDow3kbGOjD/APiI2kqWQ=
X-Received: by 2002:a17:902:da8b:b0:2bd:7bec:f0e6 with SMTP id
 d9443c01a7336-2c6e85ea5b1mr478005ad.1.1781736071082; Wed, 17 Jun 2026
 15:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
 <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com> <CAJuCfpGOrtk+3hvUVE7-6wpnsa3Nbr6kGq5CfHVdCzX+DYyjFQ@mail.gmail.com>
In-Reply-To: <CAJuCfpGOrtk+3hvUVE7-6wpnsa3Nbr6kGq5CfHVdCzX+DYyjFQ@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 17 Jun 2026 15:40:59 -0700
X-Gm-Features: AVVi8Cc05jQrK4Vkogw4VRzZQLXEYGsCqHDLSwcfG_aywCHd2_HMuPrbZCdRc9E
Message-ID: <CAL41Mv6FZU5As+yKiM52axUMsR_FDrYQCK5STjUp-aG+xMD-EQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD7CE20005
X-Stat-Signature: on3thj5jyu8i8u5gn38tgfwmm48ra1yo
X-HE-Tag: 1781736072-517367
X-HE-Meta: U2FsdGVkX1+R8O3RQ8UeqXYTg5T45ggJnEBU1ZU2AaMBEw7710/uK7HtQAzLqyANAygXxxe3zHhLCAQoipdw4vdUAl6c7usuvGa4Ooat/VSPZD7CvrjQiJERj7kEoD8bubQAta3Id/6tGiJlNAarz84Z+Fv0Vr7wBuZZHgn4uz836aeho0DwGNEHyw8Ks174EAG9XJW6XWewigO2vzcD1t6CoToRhvg59yAm/ogVOiBr8lSAilC8C9nCegAJxKkLThXQZBGvi4Jfm1D1YaiZtq7koAV7vIop8GvUFbepNdV+M6FEimMstqLI3TIu9sA3BVzRZhKVBY3N33dfSPtZxTWN2SWE7D23S+J6KW9lfadJqm23hHXbnc2IAvhtGn56cdaSarUZWP7tllkqqCLkBB6hX8juYPYXLHSNklu2J+Wi+7BS+inweiUbn2S/4lTGQgg6ml7Wc8Z5XKJ+WJ5HVU8u7QS/0e926k4cdKNBPmy9aM/qP71MN0cBrz1oYJIkXoB4bv/GC1HPqKuM6WlD4Wb46sa0uwYZhKfgGYaBvi2U+xiceSygtTBqzTUIPWqS2is/mr7ENU1UcbsAkBiDLu6PCLZtFNiymPg2qZSg6QmHIkpLItyMLAH+P9rP6N7yZhT/D5fZAnKmr3j6TyQrJU+uGApbRylvyOCS6PBRKnYlBFrevYVIhv5kqupjQtR8kCj3b+O5MOlmwNRHWfulJqZjmAkylHR/esMAUHmeMUFhicDX3L0915AIMo8U2x+IJMNcZotSqxQN00mewu8efpl40DqQpOY2cK/ZY2OU3rexiF7ypUtCSFZYuo0QjHCVbxzUYYhTh9JCAB3sUm6s23U3utmIrfiFdjPzTZCQfyUcd0VBbu0MXHx4pNB5LxdUnmVk9EKO5XZ85cb45kFCA3meGy9z75EgCxiY8u1nEGHHQPFZLWQKbJVbVSeX03vOC6BAoW22j4adWUwrcb7
 vb9FBbPC
 b5oJXFPj3v6V57WDH8fZCWxDht3/esosUJpkdZ/gpWXt6nLeQUv2kk81fol72e0g69/kKx1x8M4PDWWSeG84YCZyYh7Y1PQ70EMBNSb1TpZFrYA0Y0DRuNaH8jbprYEKb2g/nTcRJQH42KYrSNfBiZdTMMAzBrXG7FNumRBmmjc87S0NeobQGjQ52EzuhVgYXAXxJFdxfuvqayGWS0eybyzZgAp2vHvgvfhaa2cKctn1JwunThfxiuAjemZHUxH7TtcsK62fqJn+165gCS45DEK2ikAIaxYjnZUwdEhYiBNE2bj/qAmvhrah8wwIi13c8Qc2wA8oKMOYDnvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 3:35=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Jun 17, 2026 at 1:55=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat=
@google.com> wrote:
> > > >
> > > > Extend the allocinfo filtering mechanism to allow users to filter t=
ags
> > > > based on the total number of bytes allocated [min_size, max_size]. =
The
> > > > size range is inclusive.
> > > >
> > > > Filtering by size involves retrieving allocinfo per-CPU counters, w=
hich
> > > > is an expensive operation. Hence, the performance of size-based
> > > > filtering will be worse than other filters.
> > > >
> > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > Acked-by: Hao Ge <hao.ge@linux.dev>
> > > > ---
> > > >  include/uapi/linux/alloc_tag.h |  8 ++++-
> > > >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++--=
----
> > > >  2 files changed, 59 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/al=
loc_tag.h
> > > > index 3b11877955b9..7f5acbb44c14 100644
> > > > --- a/include/uapi/linux/alloc_tag.h
> > > > +++ b/include/uapi/linux/alloc_tag.h
> > > > @@ -45,13 +45,17 @@ enum {
> > > >         ALLOCINFO_FILTER_FUNCTION,
> > > >         ALLOCINFO_FILTER_FILENAME,
> > > >         ALLOCINFO_FILTER_LINENO,
> > > > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > > > +       ALLOCINFO_FILTER_MIN_SIZE,
> > > > +       ALLOCINFO_FILTER_MAX_SIZE,
> > > > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > > >  };
> > > >
> > > >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FIL=
TER_MODNAME)
> > > >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FIL=
TER_FUNCTION)
> > > >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FIL=
TER_FILENAME)
> > > >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FIL=
TER_LINENO)
> > > > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FIL=
TER_MIN_SIZE)
> > > > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FIL=
TER_MAX_SIZE)
> > > >
> > > >  #define ALLOCINFO_FILTER_MASKS \
> > > >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > > > @@ -59,6 +63,8 @@ enum {
> > > >  struct allocinfo_filter {
> > > >         __u64 mask; /* bitmask of the filter fields used */
> > > >         struct allocinfo_tag fields;
> > > > +       __u64 min_size;
> > > > +       __u64 max_size;
> > > >  };
> > > >
> > > >  struct allocinfo_get_at {
> > > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > > index 5feb61d9fb92..b3d21834b61e 100644
> > > > --- a/lib/alloc_tag.c
> > > > +++ b/lib/alloc_tag.c
> > > > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str,=
 const char *template)
> > > >         return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_=
SIZE);
> > > >  }
> > > >
> > > > +/* Fetch the per-CPU counters */
> > > > +static inline struct alloc_tag_counters allocinfo_prefetch_counter=
s(struct codetag *ct)
> > > > +{
> > > > +       return alloc_tag_read(ct_to_alloc_tag(ct));
> > > > +}
> > > > +
> > > >  /*
> > > >   * Populates the UAPI allocinfo_tag_data structure with active run=
time
> > > >   * profiling counters extracted from the given kernel codetag.
> > > >   */
> > > >  static void allocinfo_to_params(struct codetag *ct,
> > > > -                               struct allocinfo_tag_data *data)
> > > > +                               struct allocinfo_tag_data *data,
> > > > +                               struct alloc_tag_counters *counters=
)
> > > >  {
> > > > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > > > -       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > > > +       struct alloc_tag_counters local_counters;
> > > > +
> > > > +       if (!counters) {
> > > > +               local_counters =3D allocinfo_prefetch_counters(ct);
> > > > +               counters =3D &local_counters;
> > > > +       }
> > > >
> > > >         if (ct->modname)
> > > >                 allocinfo_copy_str(data->tag.modname, ct->modname);
> > > > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag =
*ct,
> > > >         allocinfo_copy_str(data->tag.function, ct->function);
> > > >         allocinfo_copy_str(data->tag.filename, ct->filename);
> > > >         data->tag.lineno =3D ct->lineno;
> > > > -       data->counter.bytes =3D counter.bytes;
> > > > -       data->counter.calls =3D counter.calls;
> > > > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > > > +       data->counter.bytes =3D counters->bytes;
> > > > +       data->counter.calls =3D counters->calls;
> > > > +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_a=
lloc_tag(ct));
> > > >  }
> > > >
> > > >  /*
> > > > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struc=
t seq_file *m, void __user *arg)
> > > >   * Verifies whether a given codetag satisfies the active filtering=
 criteria by
> > > >   * matching its characteristics against the specified filter.
> > > >   */
> > > > -static bool matches_filter(struct codetag *ct, struct allocinfo_fi=
lter *filter)
> > > > +static bool matches_filter(struct codetag *ct, struct allocinfo_fi=
lter *filter,
> > > > +                          struct alloc_tag_counters *counters,
> > > > +                          bool *fetched_counters)
> > > >  {
> > > >         if (!filter || !filter->mask)
> > > >                 return true;
> > > > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct,=
 struct allocinfo_filter *filter)
> > > >             ct->lineno !=3D filter->fields.lineno)
> > > >                 return false;
> > > >
> > > > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCI=
NFO_FILTER_MASK_MAX_SIZE)) {
> > > > +               if (!*fetched_counters) {
> > > > +                       *counters =3D allocinfo_prefetch_counters(c=
t);
> > > > +                       *fetched_counters =3D true;
> > > > +               }
> > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE)=
 &&
> > > > +                   counters->bytes < filter->min_size)
> > > > +                       return false;
> > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)=
 &&
> > > > +                   counters->bytes > filter->max_size)
> > > > +                       return false;
> > > > +       }
> > > > +
> > > >         return true;
> > > >  }
> > > >
> > > > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_fi=
le *m, void __user *arg)
> > > >         struct codetag *ct;
> > > >         struct allocinfo_get_at params =3D {0};
> > > >         __u64 skip_count;
> > > > +       struct alloc_tag_counters counters;
> > > > +       bool fetched_counters;
> > > >
> > > >         if (copy_from_user(&params, arg, sizeof(params)))
> > > >                 return -EFAULT;
> > > > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_f=
ile *m, void __user *arg)
> > > >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > > >                 return -EINVAL;
> > > >
> > > > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &=
&
> > > > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &=
&
> > > > +           params.filter.min_size > params.filter.max_size)
> > > > +               return -EINVAL;
> > > > +
> > > >         priv =3D m->private;
> > > >
> > > >         mutex_lock(&priv->ioctl_lock);
> > > > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_fi=
le *m, void __user *arg)
> > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > >
> > > >         while (ct) {
> > > > -               if (matches_filter(ct, &priv->filter)) {
> > > > +               fetched_counters =3D false;
> > > > +               if (matches_filter(ct, &priv->filter, &counters, &f=
etched_counters)) {
> > >
> > > Do we really need this "fetched_counters" parameter? Here are the
> > > possible cases:
> > > 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > > ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
> > > 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > > ALLOCINFO_FILTER_MASK_MAX_SIZE and
> > > 2.1. matches_filter() returns true then we know counters were fetched
> > > because they had to be validated.
> > > 2.2. matches_filter() returns false then we don't care if the counter=
s
> > > were fetched. We do not report that tag anyway.
> > >
> > > So, instead of passing fetched_counters to matches_filter() we could =
do this:
> > >
> > > bool filter_by_size =3D (params.filter.mask &
> > > (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=
=3D
> > > 0;
> > > while (ct) {
> > >            if (matches_filter(ct, &priv->filter, &counters)) {
> > > ...
> > > }
> > > if (ct) {
> > >            allocinfo_to_params(ct, &params.data, filter_by_size ?
> > > &counters : NULL);
> > > ...
> > > }
> > >
> > > Wouldn't that work?
> > >
> >
> > While we can deduce whether counters were fetched outside the
> > matches_filter function, I think the current implementation is more
> > intuitive from a readability perspective. I believe it  should be kept
> > as is for that reason. If we extract the logic, we'll first have to
> > replicate the boolean logic at two places. Second, we'd need to add a
> > comment explaining the boolean calculation, and the reader might have
> > a higher cognitive load trying to determine which function populates
> > the counters. The current implementation makes it easy for the reader
> > to deduce the original intention. Let me know what you think.
>
> Ok, I guess you have a point.
>
> I was also thinking why we are passing NULL to allocinfo_to_params()
> to fetch the counters into a local variable? Why can't we simply call
> allocinfo_prefetch_counters() before calling allocinfo_to_params()
> when fetched_counters=3D=3Dfalse? Basically:
>
> if (!fetched_counters)
>     counters =3D allocinfo_prefetch_counters(ct);
> allocinfo_to_params(ct, &params.data, &counters);
>
> This would simplify allocinfo_to_params() because counter will never
> be NULL and it would not need local counters.
>

The only reason I did it that way was to avoid repeating the code at
two places i.e. allocinfo_ioctl_get_at and allocinfo_ioctl_get_next.
Either way, the per-CPU counters are assimilated only once. I can
include this change if you still want me to, but personally I like the
way it currently is implemented.

> >
> > > >                         if (skip_count =3D=3D 0)
> > > >                                 break;
> > > >                         skip_count--;
> > > > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_fi=
le *m, void __user *arg)
> > > >         }
> > > >
> > > >         if (ct) {
> > > > -               allocinfo_to_params(ct, &params.data);
> > > > +               allocinfo_to_params(ct, &params.data, fetched_count=
ers ? &counters : NULL);
> > > >                 priv->positioned =3D true;
> > > >         }
> > > >
> > > > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_=
file *m, void __user *arg)
> > > >         struct codetag *ct;
> > > >         struct allocinfo_tag_data params;
> > > >         int ret =3D 0;
> > > > +       struct alloc_tag_counters counters;
> > > > +       bool fetched_counters;
> > > >
> > > >         memset(&params, 0, sizeof(params));
> > > >         priv =3D m->private;
> > > > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct se=
q_file *m, void __user *arg)
> > > >         }
> > > >
> > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > -       while (ct && !matches_filter(ct, &priv->filter))
> > > > +       while (ct) {
> > > > +               fetched_counters =3D false;
> > > > +               if (matches_filter(ct, &priv->filter, &counters, &f=
etched_counters))
> > > > +                       break;
> > > >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > +       }
> > > > +
> > > >         if (ct)
> > > > -               allocinfo_to_params(ct, &params);
> > > > +               allocinfo_to_params(ct, &params, fetched_counters ?=
 &counters : NULL);
> > > >
> > > >         if (!ct) {
> > > >                 priv->positioned =3D false;
> > > > --
> > > > 2.54.0.1136.gdb2ca164c4-goog
> > > >

