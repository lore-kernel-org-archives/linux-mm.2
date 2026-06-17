Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EBCCD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C1F6B008C; Wed, 17 Jun 2026 16:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BD66B0092; Wed, 17 Jun 2026 16:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FAD36B0093; Wed, 17 Jun 2026 16:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 135586B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:55:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99CD01C49D4
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:55:23 +0000 (UTC)
X-FDA: 84890610126.28.4CF09C9
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D96AA0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:55:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UrQ1idNX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781729721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh2PNt9Pk27TkoiAgCtWpGVeAzV02e+UeQ70XJQO/Nk=;
	b=0rOQ91jFC1STG8Akoh8wK1yYoPNacny3baZCib1xZbf5D+JfNxEJMvuoyXcG9W9ORISSiO
	qGri8vAVKpvHbPvzBO6CuFF6IWV63V23CT6JGD+PB7WkJzHpFYHCWTRUr+bMGlmKHFamn1
	a6aZ9DPispZrL/rY4fmWMo503Jj2sEU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UrQ1idNX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781729721;
	b=ueBh9x1n+iG3BTEQtTAkDkLUSuE8CstwRqvAldRae+GDo9MtwEO2dXfDBgBnyUm7Ld0GxC
	rwr3TfgTvrqG9xMWylMLo6o0s3KZSKRlXF/m5UAVfqf5JkGU7wqC4PZrZKZYhQlM+7++y9
	0FquSXiAZxzTLJJF8Fn9SfyJCtGEbhQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c6d3851e0aso5985ad.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:55:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781729720; cv=none;
        d=google.com; s=arc-20260327;
        b=QeeMA6Ihy6WR9nlAE9tuxKqQPa1sXJSmk3bTG0e7or2LVlbc+brzialDzWrvtlt7Fn
         iySkbK/mpSyhBQGRmLK2+K9EBOlk6xtYI2I7SnWHCfhdSKwtp/q6UAqPHJejWzQMd296
         QJ/1tFveRexW8lZ5AqCxt7k1Skec4NM16h+prB5Yx0CaPwiS6te9NP5GUJchLQpVq2fK
         XBXfaFyidLA0K2G6u5i6lksuA4c7q+Duu+xmqTygYy3RxgJhiKf2X5GC1ywdWGmlcEDk
         BEKowF1XHiU52YG8q+eLQ6X/AQfpD1Lp7fZHrratbqqWBaAXE4fCKda/2LxNZjaVermK
         qiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dh2PNt9Pk27TkoiAgCtWpGVeAzV02e+UeQ70XJQO/Nk=;
        fh=4P1Z3aIEQf7+Pje7VjK1zYZR9+YCVa9ERgo/VjY5BTA=;
        b=pSKcsXSM++HuQlZ7sSZrr4y1O2DqzVQA2PbRTjgvhQb5fjjbzkNQIGuwXm6Wwdrg8T
         yvC/Az1Jx4KNBO9clfHTDIh5DknBVMKdEPfiBRJd6CAR6+61mwoM35dW4YkRJZGdxc3U
         jqrwMHTLL1R/suWvY3DpGFo/TIkyfvCSYQwut/l9mJb5Ils8UBDOHQY/eS0x4JGZ6uf3
         0kJClXbhsYJ4jlAwalSvt+pVqpwV6IV3FPZ7IpfXWP7iyp5Rgyh4xFkuvpDI7mUrSEFQ
         hj0jNyrNwCkNQzW8FDBFxkwhk/O6MswSbjujB+ferevPEOzkt/XEiSRo5iYX3Q55L6VE
         1qAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781729720; x=1782334520; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dh2PNt9Pk27TkoiAgCtWpGVeAzV02e+UeQ70XJQO/Nk=;
        b=UrQ1idNX9G8p4crbxYtVrezMDXz+n6ADsPJP0lBS0uC8kgiqg4FnOMGQIaESIzCNl+
         XQMIDN1N3bvRm/hWcIn2BR4rI/BP1WhMY37DyrqBfRlBPekcuVep3kv6/D8im6zvNoOS
         TEJG3iONImE6ydgnolBXDg+WZsKeB9WWNTChsmcNZhH+eUt8XoVUZrz8NV7KbAbEu6Aa
         S4MT3hyuxTGG1414yiTF5MMiWCLBhQK63jM4aZCHGo5RDNGE8SRvRrKLlmzlqQtL/WAH
         uKxRM13pbNGH24w8z/qLMhK/zTRBDoJGvKsBMGBX4A9bIJYNvX1Gi6+imvrsrYaWNbPP
         6X4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781729720; x=1782334520;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dh2PNt9Pk27TkoiAgCtWpGVeAzV02e+UeQ70XJQO/Nk=;
        b=ZsWaXRKrn3uRKdfshLVAE81OesFRYBwBu9iMFF0zcAglzgEVfAD1sJxK4q7d+ti3x/
         1tMv8QyVT8jLcXjWlApXUY9kaN2q4LIsuG17epCRc5Ogc3fsKE/pyY7bfTuKgCHoBmzi
         SuQxXuzgmBXvt7McvEngdWFHwZm/d+cUIvzgMlADpBO7TKdZXZziSwKzxUb9uxlh6+Ob
         +VO7sjZI1ud+11zt1XWzge+L9T05+bjRTeKgeyQnOX9rnAJXP8i5m/x0+0TPqeFqMMvt
         +sN99T7x09RexGVfQc4VKgYSkNuRlgYuHwhNwf3ng8Jpamu2gHInBgCpqK4oFRtH+GEh
         R3TA==
X-Forwarded-Encrypted: i=1; AFNElJ9c4az3KcaNpiyJBIuR2sYMPbkzxk3D+AC9BpMJ2ovVAzEjVo+w+PPmHAxB0rXpCwirr5dDW5ShxA==@kvack.org
X-Gm-Message-State: AOJu0YzrB+I2flmfW/33tQ/rkvgxcSvnZdtsykRk/gwn/nNWy0RzoZwf
	Tzuasvo35zWWoaykVgzw37a2Az/sfxbYWFh2B74RQOttTkyKIlE7/nWDTPhz0cUGLnsBVo52rk8
	oe9H3/uE5PvUljfxa/X3Z8miQgIPpRofHftzXnroF
X-Gm-Gg: AfdE7cmbdqBQLsQXjSdt2qdp/EtRDZTVa1XreetttXDKV7fXnS3mMZmGP63ryLVUX1C
	KtFJ4LrqBFVWiujEC2R8lZMAGNxuLol6xXSim1UhIS5KubG78juXtrPHsvzxPqP+LfQMP1vR13D
	mZ/UqugooCP0NG2FelLPi1e/XB2wf+rLCX5iowB01UQ2WGAu0Rkfng+uJ47CZvE2xeyXys4jejc
	0MchGq59/LH0Hpro3Y2g79KrGfMH+HBaw091zIAFVneqPVHrk8Bm3UvoHWo1mt0lfbsFovST8RA
	CR9H0IZrnBUHIjuhyzKjZ8cT7aQ=
X-Received: by 2002:a17:903:1d0:b0:2bf:139c:dcf3 with SMTP id
 d9443c01a7336-2c6e8699658mr193785ad.19.1781729719924; Wed, 17 Jun 2026
 13:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
In-Reply-To: <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 17 Jun 2026 13:55:07 -0700
X-Gm-Features: AVVi8CfV0wfWYHPqAXkDdgLI2ySTrpqCpBwT5CcxwbykM434wWzYvUfUKrVD1-M
Message-ID: <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D96AA0003
X-Stat-Signature: 58um356eikqo6b9m567pxc1r1erekkcn
X-Rspam-User: 
X-HE-Tag: 1781729721-162432
X-HE-Meta: U2FsdGVkX1+D1z188YGxp9RTqbEO3s6OqI6yey0TMgMiCkoEqCm0r+sFWCaJ4c2T8iEde1q+m/KuoWxrJ7H/p6sC6StMM4Jcsdnm04f4OP8v7xcNoSd/8NZwJrAi0EbTnFP5oNhgA0iJdbyvCT52dJU0gAUMaNLvjaNhBnKdzO7KsiO6AKVxAgcV5s3N6gW+iXOJF/qLwDTx0ySwacJ1NtF77BsORWET8lk0al4qXWamAv/avVRaOAsMcMWG2+GAi++wwagN189GuemEfXVh6SpE5md7cvMgSjxj+S+oe1gK+zR3CsiomEhT9IXF/GRYEaWiP+nlP4PlPPgoekiRlLxR22a7Z3Cjkaycy3cbmQH5MsHPeMI6rLG3ZX6pz6fRH8XK6/gRpjeLTzjVLk24amOdxE7JgCA6zN0DVQ0/n3VUrsCmi4DBfhlHankt2FOcwqNGXFgBua6d7iZ+TXbdTzj+1Hdgn3Jlxg/Cg7Rif3bOZMF4+vTr2KnfOvMtPoqTCnxA/9JLjUaKe4geo6S3UNhDmFlFHHO7nnn/WxfXKIEub6m/3r8MMkJGzrnj0fhVVW9ZQjpOasvfHAmaYw/rDchRagATmKFNkiIDVu4Cq3WfOS6J1+A/3RkZHZ5xDUurHwvj+7047ZFn8GxpmJKH4Pwvv1b7B5oqK3rGw3G3+8u0hV8FZt77SuW/gAWB1iKUBV8QByXTxTVEKU8RfnZDCQulR+nmXWw9Z+f8EoPPmu4drdVWfwySd1e2mH/xHrbq7ZPzIUc6igu5ebKKofNKskRqgcFK1qe82ZOo2CZPfU1SfBadVGuDCHJv/dWoWhTIyvcO5OiKNibML4rxTXTTloQ6Y1ncnbyXCgQ15656xfqxwikN/Je1DVW48gu1SYFTS+x+0/0mCHtWB4HaD9hs+M/aik1Fc9GAm5gv6yne28uCqlNbdEwYDhwOeANx+I7xS7hABSlC6bjHMvPyORI
 JD7MeRgg
 iGyu+6qhOU+1phoGNgkzzdX7tBgpzCPsPG7uvU0nGlJCsoLUuRqs98l7NaU9JVZoK2pXECHiaCju94cDxeKfJbyuOpmJWC7Uems8zGhHDW9901IYHimndpE0daSv61RNBxBHdStjT5Gyd/ZdCEVZBhO+aoi5SdBSnjK+QcZ3USzeVqDds4u24eYJ+uxR3wGLuT+MIm4vf2zMVVGY+yW22Jnt+lurYlbOGzynlSsvIQi21z/ANapwTJYg7i7IRaIn0PZIeByoqXV8g7rDhxCYTra78FGpwlB8xY3rgbfrbilKbFi3COIB53Ambhj7xqOPH72vxxBWiDbtDyZJqaB7kA/scusEVG0MSOz5XNtEIuP28YCbY/kuPEV8bST1AXLz+pIbzyAJT6p5ETikrf1FCab1W6C9rrpEj7CI0RwwziDAhiOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > Extend the allocinfo filtering mechanism to allow users to filter tags
> > based on the total number of bytes allocated [min_size, max_size]. The
> > size range is inclusive.
> >
> > Filtering by size involves retrieving allocinfo per-CPU counters, which
> > is an expensive operation. Hence, the performance of size-based
> > filtering will be worse than other filters.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > Acked-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  include/uapi/linux/alloc_tag.h |  8 ++++-
> >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++------
> >  2 files changed, 59 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index 3b11877955b9..7f5acbb44c14 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -45,13 +45,17 @@ enum {
> >         ALLOCINFO_FILTER_FUNCTION,
> >         ALLOCINFO_FILTER_FILENAME,
> >         ALLOCINFO_FILTER_LINENO,
> > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > +       ALLOCINFO_FILTER_MIN_SIZE,
> > +       ALLOCINFO_FILTER_MAX_SIZE,
> > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >  };
> >
> >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTER_=
MODNAME)
> >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FILTER_=
FUNCTION)
> >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FILTER_=
FILENAME)
> >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FILTER_=
LINENO)
> > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTER_=
MIN_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTER_=
MAX_SIZE)
> >
> >  #define ALLOCINFO_FILTER_MASKS \
> >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > @@ -59,6 +63,8 @@ enum {
> >  struct allocinfo_filter {
> >         __u64 mask; /* bitmask of the filter fields used */
> >         struct allocinfo_tag fields;
> > +       __u64 min_size;
> > +       __u64 max_size;
> >  };
> >
> >  struct allocinfo_get_at {
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 5feb61d9fb92..b3d21834b61e 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str, con=
st char *template)
> >         return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE=
);
> >  }
> >
> > +/* Fetch the per-CPU counters */
> > +static inline struct alloc_tag_counters allocinfo_prefetch_counters(st=
ruct codetag *ct)
> > +{
> > +       return alloc_tag_read(ct_to_alloc_tag(ct));
> > +}
> > +
> >  /*
> >   * Populates the UAPI allocinfo_tag_data structure with active runtime
> >   * profiling counters extracted from the given kernel codetag.
> >   */
> >  static void allocinfo_to_params(struct codetag *ct,
> > -                               struct allocinfo_tag_data *data)
> > +                               struct allocinfo_tag_data *data,
> > +                               struct alloc_tag_counters *counters)
> >  {
> > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > -       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > +       struct alloc_tag_counters local_counters;
> > +
> > +       if (!counters) {
> > +               local_counters =3D allocinfo_prefetch_counters(ct);
> > +               counters =3D &local_counters;
> > +       }
> >
> >         if (ct->modname)
> >                 allocinfo_copy_str(data->tag.modname, ct->modname);
> > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *ct,
> >         allocinfo_copy_str(data->tag.function, ct->function);
> >         allocinfo_copy_str(data->tag.filename, ct->filename);
> >         data->tag.lineno =3D ct->lineno;
> > -       data->counter.bytes =3D counter.bytes;
> > -       data->counter.calls =3D counter.calls;
> > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > +       data->counter.bytes =3D counters->bytes;
> > +       data->counter.calls =3D counters->calls;
> > +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc=
_tag(ct));
> >  }
> >
> >  /*
> > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct se=
q_file *m, void __user *arg)
> >   * Verifies whether a given codetag satisfies the active filtering cri=
teria by
> >   * matching its characteristics against the specified filter.
> >   */
> > -static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter)
> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter,
> > +                          struct alloc_tag_counters *counters,
> > +                          bool *fetched_counters)
> >  {
> >         if (!filter || !filter->mask)
> >                 return true;
> > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter)
> >             ct->lineno !=3D filter->fields.lineno)
> >                 return false;
> >
> > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_=
FILTER_MASK_MAX_SIZE)) {
> > +               if (!*fetched_counters) {
> > +                       *counters =3D allocinfo_prefetch_counters(ct);
> > +                       *fetched_counters =3D true;
> > +               }
> > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +                   counters->bytes < filter->min_size)
> > +                       return false;
> > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +                   counters->bytes > filter->max_size)
> > +                       return false;
> > +       }
> > +
> >         return true;
> >  }
> >
> > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
> >         struct codetag *ct;
> >         struct allocinfo_get_at params =3D {0};
> >         __u64 skip_count;
> > +       struct alloc_tag_counters counters;
> > +       bool fetched_counters;
> >
> >         if (copy_from_user(&params, arg, sizeof(params)))
> >                 return -EFAULT;
> > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)
> >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> >                 return -EINVAL;
> >
> > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +           params.filter.min_size > params.filter.max_size)
> > +               return -EINVAL;
> > +
> >         priv =3D m->private;
> >
> >         mutex_lock(&priv->ioctl_lock);
> > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> >
> >         while (ct) {
> > -               if (matches_filter(ct, &priv->filter)) {
> > +               fetched_counters =3D false;
> > +               if (matches_filter(ct, &priv->filter, &counters, &fetch=
ed_counters)) {
>
> Do we really need this "fetched_counters" parameter? Here are the
> possible cases:
> 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
> ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
> 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
> ALLOCINFO_FILTER_MASK_MAX_SIZE and
> 2.1. matches_filter() returns true then we know counters were fetched
> because they had to be validated.
> 2.2. matches_filter() returns false then we don't care if the counters
> were fetched. We do not report that tag anyway.
>
> So, instead of passing fetched_counters to matches_filter() we could do t=
his:
>
> bool filter_by_size =3D (params.filter.mask &
> (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D
> 0;
> while (ct) {
>            if (matches_filter(ct, &priv->filter, &counters)) {
> ...
> }
> if (ct) {
>            allocinfo_to_params(ct, &params.data, filter_by_size ?
> &counters : NULL);
> ...
> }
>
> Wouldn't that work?
>

While we can deduce whether counters were fetched outside the
matches_filter function, I think the current implementation is more
intuitive from a readability perspective. I believe it  should be kept
as is for that reason. If we extract the logic, we'll first have to
replicate the boolean logic at two places. Second, we'd need to add a
comment explaining the boolean calculation, and the reader might have
a higher cognitive load trying to determine which function populates
the counters. The current implementation makes it easy for the reader
to deduce the original intention. Let me know what you think.

> >                         if (skip_count =3D=3D 0)
> >                                 break;
> >                         skip_count--;
> > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
> >         }
> >
> >         if (ct) {
> > -               allocinfo_to_params(ct, &params.data);
> > +               allocinfo_to_params(ct, &params.data, fetched_counters =
? &counters : NULL);
> >                 priv->positioned =3D true;
> >         }
> >
> > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_file=
 *m, void __user *arg)
> >         struct codetag *ct;
> >         struct allocinfo_tag_data params;
> >         int ret =3D 0;
> > +       struct alloc_tag_counters counters;
> > +       bool fetched_counters;
> >
> >         memset(&params, 0, sizeof(params));
> >         priv =3D m->private;
> > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct seq_fi=
le *m, void __user *arg)
> >         }
> >
> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > -       while (ct && !matches_filter(ct, &priv->filter))
> > +       while (ct) {
> > +               fetched_counters =3D false;
> > +               if (matches_filter(ct, &priv->filter, &counters, &fetch=
ed_counters))
> > +                       break;
> >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +       }
> > +
> >         if (ct)
> > -               allocinfo_to_params(ct, &params);
> > +               allocinfo_to_params(ct, &params, fetched_counters ? &co=
unters : NULL);
> >
> >         if (!ct) {
> >                 priv->positioned =3D false;
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >

