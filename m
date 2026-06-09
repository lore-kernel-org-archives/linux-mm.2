Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BADECD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633506B0005; Mon,  8 Jun 2026 20:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B6F6B0088; Mon,  8 Jun 2026 20:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520A56B008A; Mon,  8 Jun 2026 20:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4134E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:52:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1D214037C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:52:13 +0000 (UTC)
X-FDA: 84858547746.14.FF8114A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id C040040004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:52:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yh+tBFGz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780966331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyMGW1i2m9k5e6Z/c+aGhXUK2zO1xCZ6B7u/QeKxqvw=;
	b=r0HhTuEw5P78B9Xw+HmJewy/ErjcFH8PlQ3Xu8GtEZOcAf1owxCCCDuJMZqB22kuSn5Dkv
	cC+1V0C0SyI/xzgGpaJJqlEe1IjY2qr7Oq8AFvtQ6cUBtQiEtoO8c3XPGR6i4zAf7HFa8r
	AvsApOJvq+tCgimZvxz65yrZAfNXg0Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yh+tBFGz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780966331;
	b=aMIZqtpTkruKD/0pU4fNWXH9YIMcphkqjhR0HcKdM6MLrM77u98ncQlBO9/TjnH5IeA02i
	EfDaDKY8b2iTqQSNXfDCx3wfdyp99lsvlWhs5XcUOeOUIb6FkqbIGo3I/mG9qXFLla9mz4
	wTF2wNhKOF/RMaI95qOLw4rn61KJjaU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bf22c18ad3so459055ad.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780966331; cv=none;
        d=google.com; s=arc-20240605;
        b=d388Jc7URUwI7/wkdpN5DFhYAmFj6j8oBhj0zggV5QWWX8QaxwPYqEuoanuZ/6U7cU
         Wn8jFleRR/74JEL8iT1rUKdusj3FejKdzfZ+qA7mMesCjbzhYD2MFMpHqEsG/ESN2Kmm
         RT1jGBRBzmrZB6Z468Voj6ybvRc9i9iXOqiQa3Z/kQ3c5HAaeM0VZcTW7cb1zC9qeviJ
         QsK/UrFfYgApTLlpzsbLOTgVph6CtOOIjNzNoUpoiquuQL3hPgunk4NByqpWBowXOF1E
         3X3cYe/B/pGdHzj9JOf92o9tZ7mB0PZJmMVgDMkuzw0sL8Id7OCDHxbBtnTwKtWCIQw3
         mVpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yyMGW1i2m9k5e6Z/c+aGhXUK2zO1xCZ6B7u/QeKxqvw=;
        fh=FkxJoqQATf+ujFcHk0np3++coicpPTUcyFnaCWstgtw=;
        b=cBuaAV3cuJaq4n4/O5/wOHylH0Z+GZXIE4qSWpiCL3N07wruW0vG2i5EAXqExXquYA
         mQqMm8ZyPXWe2Ri/0TQQxIZFNGSgTv2uQLXLldDdL5AWwHnXc9N91K9C4rZsvdlSr6Vq
         QB2Q703VqT1nv9A34M2WAV/wMaGSLljQDDDgkc+Ek/DjGG5Ncu0Xy09Sb+PAW6AHL1RS
         Mslkk/rMCMT97eXk4SwYSuR4RYeSXzmoNgEpGZ9kFr+x+KYwIiqQe11CXndsTc6Kk14J
         Fz09RB2XusqG5Y5eD2b9ZNYCRJKT0FHRLHEcwVQDf1wdLAuSGyTDrhIOuOAzE5tuTbo1
         LmKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780966331; x=1781571131; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyMGW1i2m9k5e6Z/c+aGhXUK2zO1xCZ6B7u/QeKxqvw=;
        b=Yh+tBFGzYQHbw9iyffRmrI9pUDVhwzmDvLzIxwDmyoxQWnk5543b2mod6UkMnKirEk
         M8AFqAkHneGvAf1v/BxU/oPoJnCyHZMByCaF99WiBuX3G5gP7mQ4UnmIS/U/RDMhmnSA
         Jt4Wfrrpti6Bz1jPl8pZQ+KqejS/2J9JZzitskpGYxrlGuAG94luMHAZWdpt7WO+aIr3
         gQ9dZxzfQMbVFaqIiGmd4EXB3j3Yn9Vf0W9dG5dxA48qv0rUYX8w8FhQfKwvdWuJvBSp
         sOtVEE+wKMotpcmyFkntmL6yPCH8I3L9hVHKjY3S2LHitdTzJgOtveeoZ1kXH7qJLT1f
         BtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780966331; x=1781571131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yyMGW1i2m9k5e6Z/c+aGhXUK2zO1xCZ6B7u/QeKxqvw=;
        b=HU5Sn2GT75y45AK7Chg/nvgFmIw+LCLfvhmIx8UwJ+c5Z16VsFWw5qxj0M1DzqjRxv
         TQAo5vEr2TdWmDFUlk3jUSf3bo84CSzsvZ1NJv6Lw0eM7ejNTObaUvpPuAySQPJdeUKv
         p1ON4uingx/+3UjBprVpSEqHuZ9c3TvpNXd/M49RdmBmlUmJGHy5LdDgI21ZdsK536po
         EKO3BwIblw/HjbUJR6+L4emAelt+L6offDE0YkWdVe1UxAl+3gajdRzf2+Wx8+IMwQ/x
         F4gwm4XjiPnFj0vON29DyLsG2XJKCFtDLh1o8EnvjCXAPkY4ykcKvIyX+VdiCwc01sdl
         si0A==
X-Forwarded-Encrypted: i=1; AFNElJ+u+oKq+3ZaxdQjL+lvs3b1IMdif6E/HP9kQB14E82D/VelsrnLlS7Rt4EJKKkwXcyi5IXxzM20LQ==@kvack.org
X-Gm-Message-State: AOJu0YwC1eijr3SqG/48LJfdPz1Nj4JwHVFMffqwpf4T7n4y+hY4AJj6
	tr5syZ8wH1UQ4uQVb0RJ+abtPeU4J7YcA+9cPA0jedw1IQ4HRVIuVviJyFr1PPI+IVZPhgdPlcF
	az3IcGolHmhk/HtBsCUQG6Inwxv+5wmgtuMX/lppdCHfZNdAr5dLFXuANpBk=
X-Gm-Gg: Acq92OHsB00KoRHatk5Fvzv5fG4AGoUGSu+iGlg8szBw3cTmBcLHMxYgS1kAmNGuMPB
	xO46XDYU+dDm1g5mqS1DS4gmDAdmNceVPfK4yG0x8p6jJuLjWncZI0UXEUrwDANQNYQn9VBSJOA
	axlY7CUF6bC5RKLB800peZ6jlibcpjv2PA4w/e7woDeJFdxxjqMRpAz5jovLtl+Pvl4kl/wb9Zv
	shctYZHU1ECmZkHZ4dTZTNpoeAK1MWLlOtFFhsWMD/wcM5/dqgiHc9NykwWqaCgWGKW0Z+jZE9t
	CRT6KA4+kfhFcYf7ZQcO+KERq76DBFAZO+1CRsgTSeve3j2BvEU9htLnIyw=
X-Received: by 2002:a17:902:d4d2:b0:2bd:6727:d689 with SMTP id
 d9443c01a7336-2c1eb50745emr6698485ad.12.1780966330130; Mon, 08 Jun 2026
 17:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev> <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
 <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
In-Reply-To: <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 8 Jun 2026 17:51:58 -0700
X-Gm-Features: AVVi8CelJXzAnAlhAUCNJ9xNtleSAw0y3N4bUAKNwMiH_03MRORRRAxIR0iDOKY
Message-ID: <CAL41Mv4MG6ym7jQcug2LNF_g-28Mr4+7doWxat4qG9by5o+A8w@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C040040004
X-Stat-Signature: c7rkt9yumdu8j3oszxdopemfxoxprnzd
X-Rspam-User: 
X-HE-Tag: 1780966331-303839
X-HE-Meta: U2FsdGVkX1+3iHPBfd7W1MkFfHxWpwU/Yktoe4SWvDG7D/YK1/rvISPyLW4BQ9zjmn8ZF3P4+gh3lV+dPkjulcNgMJV4cYtY3LwoDWMY7TkV1bAxhipKPcPZ8yMz8OSmU2/jRHsDZadJ0B0fB0x+cmLWlMrB2AES+MZxC3ZfV5j78xLCI+FZUNz59iPyjFbmN2W7Et8J+FVCoJtlEQEb1ol6i+B3yjIl7BXUVB9CY/ayhmU/kdbDCGElVCkzjRQrms02snYwn2ds6C8QSrDcIEWsWSz2IFkezeOVrbJNlqBewS0U83ILF1UZCaF+U0pGAxTGqnHhLpEqg4d0OjhN39mmFS+O4ezkhYjfzlC2LJ6Xn5MRAqxsvZ4qCfYN0TO5k/DTz64ecQ05h+QuH1wtwMwgRUghlZsQ81p9rDZl/tHc8RNGtP235y9AS5yKvJZF+NoNhUIcxYqYr0ff4VxdHgorBbxd2f8UfvpPT2Zo07UpBsirG0ILPgpbc63MnELngtgsGlZjqPSeAt0+MywgIlO7Qth6ebyQuyiGnT64rqXWSV8pDSkSxbBT5p+oKkEAo9xVERlHkm7sZFRO6rtLuBIzD/+gJVkzOPw8kfVXc1c9owlMKn2FGAlfDIg91cRd52EBh2T25wmZH9EFCOrW3LOgWnC/FzBBy51UewMRhiGNrgLIeNCCQTOOH5Mx9d//hqnNBwjlRk2OBRE4NpgHZrXpGDSw6lwpRE+zVWczsuql816iNm2dkD6+JmIffEINcNfjc+/kj55+So2dAH//a0kFylS2JXrgIsWEZHe938CH6yDSP7ozO1+OpbzWHlYR72wdhHItfZpKC09Mf3yICfgj1Xkh6KmLq072w4b/eIwy2GrZpZdMuaztElnq4xAnsrac0WARt3xVjKQDAxesKmYWV8j6OxDIUfhlEGxq3IHrxzUluS8aSQPDfjrQy2ulg0jqQ6xfAoR5EnkxVXm
 j5oqi/nr
 3HJfWFrji9i4VIxMZCHM9dHJMHmKtzNuk/7xzYtC1tIihFtGh4KxT5X/ux+gOx7z4TMnuVE1F3z1dDFZN/Ywv/pfetKTwBs1pmXCrY3JRFo0WOuW0jMxfwB1fcdMKo9hD9tygYu19YdOjla5JBjujSV523IDucI1ikAyy8/a8XYOJlh+2a1F5QV8+LvE8LuUZTC388OFS+BStULennuvBdkF2ulVv1gD/9hbIw5z1NwePUcewVAZE55nE+6FtwNWoW/qFwfJPjd1Yzt16dqeOf7EwlnMeOoiyRjgJ66T9lYad4SX8QJHTxQLpy70Oh3856LcLq2uHAVXyb4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Btw, Sashiko left a comment in this patch stating that the value of
"inaccurate" is echoed back to the user. But since it's an input-only
parameter, that is expected. Changing it in the kernel would be
unexpected. Hence, I will ignore that comment.

On Mon, Jun 8, 2026 at 1:55=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Mon, Jun 8, 2026 at 1:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> >
> > On 2026/6/8 14:22, Hao Ge wrote:
> > > Hi Abhishek
> > >
> > >
> > > On 2026/6/6 07:36, Abhishek Bapat wrote:
> > >> Extend the allocinfo filtering mechanism to allow users to filter ta=
gs
> > >> based on their accuracy.
> > >>
> > >> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > >> ---
> > >>   include/uapi/linux/alloc_tag.h | 3 +++
> > >>   lib/alloc_tag.c                | 8 ++++++++
> > >>   2 files changed, 11 insertions(+)
> > >>
> > >> diff --git a/include/uapi/linux/alloc_tag.h
> > >> b/include/uapi/linux/alloc_tag.h
> > >> index 0e648192df4d..42445bdb11c5 100644
> > >> --- a/include/uapi/linux/alloc_tag.h
> > >> +++ b/include/uapi/linux/alloc_tag.h
> > >> @@ -20,6 +20,7 @@ struct allocinfo_tag {
> > >>       char function[ALLOCINFO_STR_SIZE];
> > >>       char filename[ALLOCINFO_STR_SIZE];
> > >>       __u64 lineno;
> > >> +    __u64 inaccurate;
> > >
> > >
> > > I was wondering if it would make sense to define inaccurate as a flag=
s
> > > field
> > >
> > > (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
> > >
> > > so that only bit 0 is used today and the upper bits are reserved for
> > > future use,
> > >
> > > aligning with current kernel codebase.
> > >
> > > This design also allows for better extensibility if we need to
> > >
> > > add new flags for any reason in the future.
> > >
> > > We also need to add flag validity checks if we go this route.
> > >
> > And I've reviewed the issue reported by Sashiko, and I think it's valid=
.
> >
> > When we expand the allocinfo_tag_data structure
> >
> > struct allocinfo_tag_data{
> >
> >      char modname[64];
> >
> >      char function[64];
> >
> >      char filename[64];
> >
> >      __u64 lineno;
> >
> >      __u64 inaccurate;
> >
> >      __u64 bytes;
> >
> >      __u64 calls;
> >
> >      __u8 accurate;
> >    /* padding */
> >
> > }
> >
> > I think user space may see two fields related to inaccuracy.
>
> Yes but one field (inside allocinfo_tag) is the input parameter which
> user provides to specify the filtering criteria and the other is the
> returned tag information. It's similar to any other tag attribute
> which you can be included in the filters.
>
> >
> > How do you like these modifications?
> >
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -20,7 +20,6 @@ struct allocinfo_tag {
> >       char function[ALLOCINFO_STR_SIZE];
> >       char filename[ALLOCINFO_STR_SIZE];
> >       __u64 lineno;
> > -    __u64 inaccurate;
> >   };
> >
> >   /* The alignment ensures 32-bit compatible interfaces are not broken =
*/
> > @@ -40,7 +39,7 @@ enum {
> >       ALLOCINFO_FILTER_FUNCTION,
> >       ALLOCINFO_FILTER_FILENAME,
> >       ALLOCINFO_FILTER_LINENO,
> > -    ALLOCINFO_FILTER_INACCURATE,
> > +    ALLOCINFO_FILTER_FLAGS,
> >       ALLOCINFO_FILTER_MIN_SIZE,
> >       ALLOCINFO_FILTER_MAX_SIZE,
> >       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > @@ -50,16 +49,20 @@ enum {
> >   #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> > ALLOCINFO_FILTER_FUNCTION)
> >   #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> > ALLOCINFO_FILTER_FILENAME)
> >   #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTER_LI=
NENO)
> > -#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> > ALLOCINFO_FILTER_INACCURATE)
> > +#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_FLAG=
S)
> >   #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> > ALLOCINFO_FILTER_MIN_SIZE)
> >   #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> > ALLOCINFO_FILTER_MAX_SIZE)
> >
> >   #define ALLOCINFO_FILTER_MASKS \
> >       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> >
> > +#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
> > +#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
> > +
> >   struct allocinfo_filter {
> >       __u64 mask; /* bitmask of the filter fields used */
> >       struct allocinfo_tag fields;
> > +    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
> >       __u64 min_size;
> >       __u64 max_size;
> >   };
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct,
> > struct allocinfo_filter *filter,
> >                  struct alloc_tag_counters *counters,
> >                  bool *fetched_counters)
> >   {
> > -    bool inaccurate;
> > -
> >       if (!filter || !filter->mask)
> >           return true;
> >
> > @@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct,
> > struct allocinfo_filter *filter,
> >           ct->lineno !=3D filter->fields.lineno)
> >           return false;
> >
> > -    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > -        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > -        if (inaccurate !=3D !!(filter->fields.inaccurate))
> > -            return false;
> > +    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
> > +        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
> > +            if (!(ct->flags & CODETAG_FLAG_INACCURATE))
>
> How would you filter records which have only accurate data?
>
> Overall I would prefer ALLOCINFO_FILTER_MASK_INACCURATE rather than
> ALLOCINFO_FILTER_MASK_FLAGS. The fact that this attribute is a
> single-bit flag is a technical detail. It's still a tag attribuite
> like file and module names and IMO deserves its own filter.
>
>
>
> > +                return false;
> > +        }
> >       }
> >
> >       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > @@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_file
> > *m, void __user *arg)
> >       if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> >           return -EINVAL;
> >
> > +    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
> > +        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
> > +        return -EINVAL;
> > +
> >       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> >           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> >           params.filter.min_size > params.filter.max_size)
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
> > >
> > > Thanks
> > >
> > > Best Regards
> > >
> > > Hao
> > >
> > >
> > >>   };
> > >>     /* The alignment ensures 32-bit compatible interfaces are not
> > >> broken */
> > >> @@ -39,6 +40,7 @@ enum {
> > >>       ALLOCINFO_FILTER_FUNCTION,
> > >>       ALLOCINFO_FILTER_FILENAME,
> > >>       ALLOCINFO_FILTER_LINENO,
> > >> +    ALLOCINFO_FILTER_INACCURATE,
> > >>       ALLOCINFO_FILTER_MIN_SIZE,
> > >>       ALLOCINFO_FILTER_MAX_SIZE,
> > >>       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > >> @@ -48,6 +50,7 @@ enum {
> > >>   #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> > >> ALLOCINFO_FILTER_FUNCTION)
> > >>   #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> > >> ALLOCINFO_FILTER_FILENAME)
> > >>   #define ALLOCINFO_FILTER_MASK_LINENO        (1 <<
> > >> ALLOCINFO_FILTER_LINENO)
> > >> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> > >> ALLOCINFO_FILTER_INACCURATE)
> > >>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> > >> ALLOCINFO_FILTER_MIN_SIZE)
> > >>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> > >> ALLOCINFO_FILTER_MAX_SIZE)
> > >>   diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > >> index ddc6946f56ab..cbcd12c4ef9c 100644
> > >> --- a/lib/alloc_tag.c
> > >> +++ b/lib/alloc_tag.c
> > >> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct,
> > >> struct allocinfo_filter *filter,
> > >>                  struct alloc_tag_counters *counters,
> > >>                  bool *fetched_counters)
> > >>   {
> > >> +    bool inaccurate;
> > >> +
> > >>       if (!filter || !filter->mask)
> > >>           return true;
> > >>   @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct=
,
> > >> struct allocinfo_filter *filter,
> > >>           ct->lineno !=3D filter->fields.lineno)
> > >>           return false;
> > >>   +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > >> +        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > >> +        if (inaccurate !=3D !!(filter->fields.inaccurate))
> > >> +            return false;
> > >> +    }
> > >> +
> > >>       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > >> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > >>           if (!*fetched_counters) {
> > >>               *counters =3D allocinfo_prefetch_counters(ct);

