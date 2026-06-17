Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18E4CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD9D6B0088; Wed, 17 Jun 2026 16:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF486B008A; Wed, 17 Jun 2026 16:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875F26B008C; Wed, 17 Jun 2026 16:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E5C6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:43:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A70DC1C4985
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:43:30 +0000 (UTC)
X-FDA: 84890580180.15.78163C3
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id A28ABC0008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:43:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NO+/mesP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781729008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6ifopdlqgIxgw2B9IIAgJNzgxL9tW7aCswkc9fIqqs=;
	b=xPyqZV6hUDE1TL20r88Xc7IRVqfzNhShHBsAZXkml2cRqcuWdJBxFYe3e12Yq67ECaQwi1
	qXL+rfbM9c5BZhZgRujLjLoMGbdUUPyHAucs0e3vrMFwFTKcbvMe7VI/56NWv6WhKL7vc0
	R3fSpnIPnbKQ4o+BNdr3B2/psnXYP2E=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NO+/mesP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781729008;
	b=zzean/XBIk4SCGWP8CWDG6dz6YTYj/y+coRVzjtBWM1inWQkEM6wIGQDiC1a0gv/iTQkws
	59DBj1UDMVpmR8QDslEcradpbEiAGb20SP25dRt/NjmqqFZOEk9UCuedo4f5Dn/pwbjkup
	g9OMmOaaXTp1iHZ8XueLZhVrzEAzsn0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6d3851e0aso5255ad.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781729007; cv=none;
        d=google.com; s=arc-20260327;
        b=e0EJafkD66PtMV09E3wsNXT/RmSof2+AZbuXiwufDN4GQOTR+r5k4k7oCtKZO7HIQV
         xIjdK+X5tbcCrJs22xz0FCE+dtu/TUHk8j1TNaaFeXYpzMImgRuWsSiivSPHSQHdAAbA
         q0sGdshl7wRSUp5tZyx1z582jpv2dSR+6O7tmCNlNS8tnobXicASzdL13XmmK3RXVmL2
         V+YsQWPTjQkyf/K350tKEAR3qmJ4BlptY1biWaAHuuqAiCoPA/bHyOS3VtwYLi1avakP
         FDb99LGnrY2O+uH1VuBkveiAI9LTIXwGrDuuFEkXqAkT8oR5B8PyVaHeUf21hrFFCOcI
         NKDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+6ifopdlqgIxgw2B9IIAgJNzgxL9tW7aCswkc9fIqqs=;
        fh=Pa6JQhQioUla2ZAD0RPCgMr82MX0x83IlvZxTjUfo9Q=;
        b=RsNMqeWtKm/vXHlunV8LOY5zNIV9hs8PiE5h2+JUc8A88M0CXPAuRWW6vbp4ZrvB3G
         6wZWynPtK7KtZBQvy4skcLXBf6QMQWH45OsEI36ga1URJf+0B4b8kIjq/jlXPYPMA+Y9
         LDzuuhkjtBN7CMywzAXL/Y5zkfiJQagNX0E482WMwp0HSpRmaNJ4IoBN2pH8ankAmQw5
         ThPrmfndjdzpIR5twHmm569azQydylXocVDKRdEpy8KUpbzrvbmrrFNBVo0sWO1STuFt
         zJzfgo9b/JNqFRyAa/9wUAZ4vWg8ZWo0YmvB7LjKTn/i/aqpXlzaSxi/BqynFUSy3HMy
         s0lw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781729007; x=1782333807; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+6ifopdlqgIxgw2B9IIAgJNzgxL9tW7aCswkc9fIqqs=;
        b=NO+/mesPMX/NFmgUhrtsLBLHh9i/yJKQoUKP0XBTiqBXsb/Hau7dckHpIF8ARyIS4J
         DrqkWRpa5G3B2D/+VNtz0KguLCXBNVRhRHDQaR8MnpLQSDBADr6CaUYajfcoO5SwrqyW
         daDYb80hwZI30XrCjJuWyS56+fhXUgbzupet5iy4DQ4v1lAabLk86w04Z1SBSemAnmOt
         AynPi4qcqeadA1UaGYRzdSjYXv9cOPpN5IyLOtzCoBVE1Z9WKVTn92IWbESg2DioDSzF
         VbZalCL+v6UtySufbIFvjNmYtuqS3hWeDVjKiiskszq+PdUeA6xgOTgvxxD8Zl025Okz
         ybog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781729007; x=1782333807;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+6ifopdlqgIxgw2B9IIAgJNzgxL9tW7aCswkc9fIqqs=;
        b=HtCtPch8qJxJyEwnrssjbeqm8Q0DmahIPHBILkhn7jQOJfKlVDux/ScGlxHZsvQMQS
         Xqv8SEkqixd0GGpfP+SpMpeQ7VzchJGB7Y9hA2PQTp7OrPV4yLU9u3u6oJoNVpNjwEcS
         dZC7ttf6wPU5DXUsotcnCISY5QIyJhAFI3ltJXpRZN4dxwPKOC1gHfV1XjQ+G7wQ/pbm
         vmftXvomCeLkmg9hFsrKAnGzzUSFzRRtjaax0nl+DXtvolGqSRj9kkWZ47UFYDr9Ss7k
         KFVLvEJLZ4yTe4qMjYTpB6tY1qlFvCClAPokUIMdBXX8vcd5eU98RwVCkm21rvO0j9Kr
         JfaA==
X-Forwarded-Encrypted: i=1; AFNElJ+GO68IIq+LeGEpkVZPOlHZHzCz0HBhxjIK7xGCBh1aGJK1YYujrfBLfmlCtRvnl+Al1awLVtTcjA==@kvack.org
X-Gm-Message-State: AOJu0YyBEsA9bA8dGdg691+BW3hzTYZiazRkjfi/rT7VKK7mvvPlkJ2X
	j6GQ8+i9q0j+zWAzkhIiYT2ypgCAek1/RCIVY/uai9bw1vZlidZqo6NOcKE79A57m3XTTxZkQxH
	TIW14g7aQOdpWL7MgKK8q0EYShUp1wgI/CFcjs480
X-Gm-Gg: AfdE7ck6iP6krYKn5im5x5UTdwkNoJ7WcnP8qH6LcXlciT0IwcvdbST4kcGGEpbNbiX
	MUayW0X+5NAq1p2gHHofTqWnfACBXWz7YYUINzBHL28XihG1ibeLSvBJtyr269co19wpgKyAk7S
	dgGRJdoTV++6b1+TEPo1kDx/ENEWUHlgrhvz7jEJ+vL+uOeIbBMJure+BJo4A9k3E+PgYaQUOar
	JvXN4ct2UKnCZnBPFAV1UqBr9AJwLzMEPMIS2FX7Elz/N33EXQqdgC78f0k7dnYyd2YJd7Oa+jR
	hvoF8FqbkE2OWih+fNg6aPOyLgk=
X-Received: by 2002:a17:903:19e7:b0:2c1:ee6e:be1c with SMTP id
 d9443c01a7336-2c6e23ac948mr640025ad.26.1781729006148; Wed, 17 Jun 2026
 13:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
In-Reply-To: <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 17 Jun 2026 13:43:14 -0700
X-Gm-Features: AVVi8CdHuB4m_1dxu5hpB40zda7iOBIdXs7upxa3RQeoqyO83JJfpZIbOIWNQH4
Message-ID: <CAL41Mv7+t9_Ohz2313AM_CgCoFGkt6xd0VnCw+zQZd4pKrr8Ww@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: multipart/alternative; boundary="000000000000806db90654791c40"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A28ABC0008
X-Stat-Signature: ssuh648iyhkxjsi96n868yeg7rm1d9no
X-HE-Tag: 1781729008-374844
X-HE-Meta: U2FsdGVkX1/TnawHUYDlxcE0NbRNFXOfACcVc7Uu1qIArsC/F/z85/bUWvTyXkt18kefGglBEwLBhpIMR2jazMbJDy8gSurM7jfpKSNgxHASmXMAPP3UmtNuHrp5UOYdJxIpbr1y1gsod5G/E6ZvaCCZqmhPuTuzoTxdp+blxcdJMyTnqIyLEvKlCoZ061TB6Sjajb5Q//dUZCX5ERAvxKEUT9TWxvg6gKNyqAkJWF/UibWLjgn4e5Utqy94rWpuLjPizxjwMxtuCE2qwSdb5ImSOw3UOKj0KyjxikjTj5jPe1HrE1Ekr2spVQcW9EuX9Dn+eRfHhnTEX4ozXwxBr72GJHStcDNhaIHy3rD7CeVk5glak6bRHK1H1sQiuxNmGM+Tk08n398fmMXvm/23VRlsALyznTQNE+1tgSjTnI59OW9Ev4FZZYKhHyombKOh2X+WcudUfaCiFmiHj3w7kxiS39tqXnm/1sAcVVx8dqCsD+Vk2n4ssXq5p0nUrnwJVEi6I5wf0lgKOlVSi/XgZeQQkelmwmcvXVfRfNwA7MUpW25UrMRcvryTnnAIxAVD/zPXoSfOrThPUjoH0ncnSIpoc4xk3LG92MX6eaYCKS8ewRrrXbXWHTqzDp3EcLfzxEerhQLeCPYVY9zCwMv2/zFThgcGC4EEz9wwMnxO7Fa0q0YMtV+HYIuZbK4VUFfP7ADPC45evVkDTGbdZ2hDbKnozC3+9AhiqTF4Icg3DC0TjSyuTBzEbXDSvNlBN8yOAqoqWE2cqSQRo4naWpazQg3NANfEa03SFCcZno+f6mqbtTcSmJTfzW+EEbfqLGoCQEhKHAgX7/Is2P/DRbEk0PPqwKs+bRAtO7mz2RTvgGTODQ1RoDPN0HWE3SyRQljDWvpRlmpFkUWmCdrXPRWQ2FxOdVUvrCK6O3um7/JTOZ1P3kIG632KvIjf7MjQKg05stRPuHNq0qaWUAdiuic
 E7mv5BV+
 QBra/GPdhNgk3Foy96rqTGi5Sgbqu+FbMsNqDPMW8jBuN3mjBGb2YgX3rNUiJWeR/L3JBYIRxMLNxLu8PFJX1lcx25Jb8THpttVY+aCPwXYM/GCXKC7X5q6c2bHBfHhLeeKYwzxPLuxD5VxSawzZy4jHYXOPPXn1SCHCIqEftepIklzSiSGsLod3630TJHU2p0uF5avD+mvfkYvPiusiWxJnV3XAB5qBF16p3azzHmK1UPiSmImI5kr6Cy4qJtfBSn7EqY32NItG2BWaq22w6UlQE0sKDbL6afyxdBaiptJcge5i/igKt+x+3CyQndJ9yXrtjEjIqV4TEKA3dJdVyOeZtgthY4cWoaI5k3xXfKoc4baqde3gXz2FMqWoGJxGDayvFIfdR/QnCFM3qWEUGPOu2t6vczxGQ7Ljrdu8M3Hnxe+ySO1OtrU7YUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000806db90654791c40
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om>
wrote:

> On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com>
> wrote:
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
> > diff --git a/include/uapi/linux/alloc_tag.h
> b/include/uapi/linux/alloc_tag.h
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
> >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 <<
> ALLOCINFO_FILTER_MODNAME)
> >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 <<
> ALLOCINFO_FILTER_FUNCTION)
> >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 <<
> ALLOCINFO_FILTER_FILENAME)
> >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 <<
> ALLOCINFO_FILTER_LINENO)
> > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 <<
> ALLOCINFO_FILTER_MIN_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 <<
> ALLOCINFO_FILTER_MAX_SIZE)
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
> > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str,
> const char *template)
> >         return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE=
);
> >  }
> >
> > +/* Fetch the per-CPU counters */
> > +static inline struct alloc_tag_counters
> allocinfo_prefetch_counters(struct codetag *ct)
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
> > +       data->counter.accurate =3D
> !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
> >  }
> >
> >  /*
> > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct
> seq_file *m, void __user *arg)
> >   * Verifies whether a given codetag satisfies the active filtering
> criteria by
> >   * matching its characteristics against the specified filter.
> >   */
> > -static bool matches_filter(struct codetag *ct, struct allocinfo_filter
> *filter)
> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filter
> *filter,
> > +                          struct alloc_tag_counters *counters,
> > +                          bool *fetched_counters)
> >  {
> >         if (!filter || !filter->mask)
> >                 return true;
> > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct,
> struct allocinfo_filter *filter)
> >             ct->lineno !=3D filter->fields.lineno)
> >                 return false;
> >
> > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
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
> > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file
> *m, void __user *arg)
> >         struct codetag *ct;
> >         struct allocinfo_get_at params =3D {0};
> >         __u64 skip_count;
> > +       struct alloc_tag_counters counters;
> > +       bool fetched_counters;
> >
> >         if (copy_from_user(&params, arg, sizeof(params)))
> >                 return -EFAULT;
> > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file
> *m, void __user *arg)
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
> > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file
> *m, void __user *arg)
> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> >
> >         while (ct) {
> > -               if (matches_filter(ct, &priv->filter)) {
> > +               fetched_counters =3D false;
> > +               if (matches_filter(ct, &priv->filter, &counters,
> &fetched_counters)) {
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
> So, instead of passing fetched_counters to matches_filter() we could do
> this:
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
> Ack, yeah this logic works and obviates the need for fetched_counters.
I'll include this in the next version.


> >                         if (skip_count =3D=3D 0)
> >                                 break;
> >                         skip_count--;
> > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file
> *m, void __user *arg)
> >         }
> >
> >         if (ct) {
> > -               allocinfo_to_params(ct, &params.data);
> > +               allocinfo_to_params(ct, &params.data, fetched_counters =
?
> &counters : NULL);
> >                 priv->positioned =3D true;
> >         }
> >
> > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_file
> *m, void __user *arg)
> >         struct codetag *ct;
> >         struct allocinfo_tag_data params;
> >         int ret =3D 0;
> > +       struct alloc_tag_counters counters;
> > +       bool fetched_counters;
> >
> >         memset(&params, 0, sizeof(params));
> >         priv =3D m->private;
> > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct
> seq_file *m, void __user *arg)
> >         }
> >
> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > -       while (ct && !matches_filter(ct, &priv->filter))
> > +       while (ct) {
> > +               fetched_counters =3D false;
> > +               if (matches_filter(ct, &priv->filter, &counters,
> &fetched_counters))
> > +                       break;
> >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +       }
> > +
> >         if (ct)
> > -               allocinfo_to_params(ct, &params);
> > +               allocinfo_to_params(ct, &params, fetched_counters ?
> &counters : NULL);
> >
> >         if (!ct) {
> >                 priv->positioned =3D false;
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
>

--000000000000806db90654791c40
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Jun 17,=
 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan &lt;<a href=3D"mailto:surenb@go=
ogle.com">surenb@google.com</a>&gt; wrote:<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek=
 Bapat &lt;<a href=3D"mailto:abhishekbapat@google.com" target=3D"_blank">ab=
hishekbapat@google.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Extend the allocinfo filtering mechanism to allow users to filter tags=
<br>
&gt; based on the total number of bytes allocated [min_size, max_size]. The=
<br>
&gt; size range is inclusive.<br>
&gt;<br>
&gt; Filtering by size involves retrieving allocinfo per-CPU counters, whic=
h<br>
&gt; is an expensive operation. Hence, the performance of size-based<br>
&gt; filtering will be worse than other filters.<br>
&gt;<br>
&gt; Signed-off-by: Abhishek Bapat &lt;<a href=3D"mailto:abhishekbapat@goog=
le.com" target=3D"_blank">abhishekbapat@google.com</a>&gt;<br>
&gt; Acked-by: Hao Ge &lt;<a href=3D"mailto:hao.ge@linux.dev" target=3D"_bl=
ank">hao.ge@linux.dev</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/uapi/linux/alloc_tag.h |=C2=A0 8 ++++-<br>
&gt;=C2=A0 lib/alloc_tag.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 63 ++++++++++++++++++++++++++++------<br>
&gt;=C2=A0 2 files changed, 59 insertions(+), 12 deletions(-)<br>
&gt;<br>
&gt; diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc=
_tag.h<br>
&gt; index 3b11877955b9..7f5acbb44c14 100644<br>
&gt; --- a/include/uapi/linux/alloc_tag.h<br>
&gt; +++ b/include/uapi/linux/alloc_tag.h<br>
&gt; @@ -45,13 +45,17 @@ enum {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_FUNCTION,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_FILENAME,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_LINENO,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILT=
ER_LINENO<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_MIN_SIZE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_MAX_SIZE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILT=
ER_MAX_SIZE<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_MODNAME=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (1 &lt;&lt; ALLOCINFO_FILTER_MODNAME)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_FUNCTION=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_FUNCTION)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_FILENAME=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_FILENAME)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_LINENO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_LINENO)<br>
&gt; +#define ALLOCINFO_FILTER_MASK_MIN_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(1 &lt;&lt; ALLOCINFO_FILTER_MIN_SIZE)<br>
&gt; +#define ALLOCINFO_FILTER_MASK_MAX_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(1 &lt;&lt; ALLOCINFO_FILTER_MAX_SIZE)<br>
&gt;<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASKS \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((1 &lt;&lt; (__ALLOCINFO_FILTER_LAST=
 + 1)) - 1)<br>
&gt; @@ -59,6 +63,8 @@ enum {<br>
&gt;=C2=A0 struct allocinfo_filter {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 mask; /* bitmask of the filter =
fields used */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag fields;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 min_size;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 max_size;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 struct allocinfo_get_at {<br>
&gt; diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c<br>
&gt; index 5feb61d9fb92..b3d21834b61e 100644<br>
&gt; --- a/lib/alloc_tag.c<br>
&gt; +++ b/lib/alloc_tag.c<br>
&gt; @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str, co=
nst char *template)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return strncmp(allocinfo_str(str), te=
mplate, ALLOCINFO_STR_SIZE);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +/* Fetch the per-CPU counters */<br>
&gt; +static inline struct alloc_tag_counters allocinfo_prefetch_counters(s=
truct codetag *ct)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return alloc_tag_read(ct_to_alloc_tag(ct))=
;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 /*<br>
&gt;=C2=A0 =C2=A0* Populates the UAPI allocinfo_tag_data structure with act=
ive runtime<br>
&gt;=C2=A0 =C2=A0* profiling counters extracted from the given kernel codet=
ag.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 static void allocinfo_to_params(struct codetag *ct,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data *data)<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data *data,<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters *counte=
rs)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag *tag =3D ct_to_alloc_tag(=
ct);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counter =3D allo=
c_tag_read(tag);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters local_counters;<=
br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!counters) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0local_counters=
 =3D allocinfo_prefetch_counters(ct);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0counters =3D &=
amp;local_counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct-&gt;modname)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo=
_copy_str(data-&gt;tag.modname, ct-&gt;modname);<br>
&gt; @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *ct=
,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_copy_str(data-&gt;tag.funct=
ion, ct-&gt;function);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_copy_str(data-&gt;tag.filen=
ame, ct-&gt;filename);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;tag.lineno =3D ct-&gt;lineno=
;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.bytes =3D counter.bytes;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.calls =3D counter.calls;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.accurate =3D !alloc_tag_i=
s_inaccurate(tag);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.bytes =3D counters-&gt;by=
tes;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.calls =3D counters-&gt;ca=
lls;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.accurate =3D !alloc_tag_i=
s_inaccurate(ct_to_alloc_tag(ct));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 /*<br>
&gt; @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct s=
eq_file *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0* Verifies whether a given codetag satisfies the active fi=
ltering criteria by<br>
&gt;=C2=A0 =C2=A0* matching its characteristics against the specified filte=
r.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt; -static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r *filter)<br>
&gt; +static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r *filter,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 struct alloc_tag_counters *counters,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 bool *fetched_counters)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!filter || !filter-&gt;mask)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return tr=
ue;<br>
&gt; @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct, st=
ruct allocinfo_filter *filter)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct-&gt;lineno !=3D filt=
er-&gt;fields.lineno)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return fa=
lse;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (filter-&gt;mask &amp; (ALLOCINFO_FILTE=
R_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!*fetched_=
counters) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*counters =3D allocinfo_prefetch_counters(ct);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*fetched_counters =3D true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((filter-&g=
t;mask &amp; ALLOCINFO_FILTER_MASK_MIN_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
counters-&gt;bytes &lt; filter-&gt;min_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((filter-&g=
t;mask &amp; ALLOCINFO_FILTER_MASK_MAX_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
counters-&gt;bytes &gt; filter-&gt;max_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct codetag *ct;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_get_at params =3D {0=
};<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 skip_count;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fetched_counters;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (copy_from_user(&amp;params, arg, =
sizeof(params)))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
FAULT;<br>
&gt; @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file=
 *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (params.filter.mask &amp; ~ALLOCIN=
FO_FILTER_MASKS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
INVAL;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((params.filter.mask &amp; ALLOCINFO_FI=
LTER_MASK_MIN_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(params.filter.mask &amp; AL=
LOCINFO_FILTER_MASK_MAX_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0params.filter.min_size &gt; =
params.filter.max_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL=
;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv =3D m-&gt;private;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;priv-&gt;ioctl_lock);=
<br>
&gt; @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D codetag_next_ct(&amp;priv-&gt;=
ioctl_iter);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fetched_counte=
rs =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter, &amp;counters, &amp;fetched_counters)) {<br>
<br>
Do we really need this &quot;fetched_counters&quot; parameter? Here are the=
<br>
possible cases:<br>
1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |<br>
ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.<br>
2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |<br>
ALLOCINFO_FILTER_MASK_MAX_SIZE and<br>
2.1. matches_filter() returns true then we know counters were fetched<br>
because they had to be validated.<br>
2.2. matches_filter() returns false then we don&#39;t care if the counters<=
br>
were fetched. We do not report that tag anyway.<br>
<br>
So, instead of passing fetched_counters to matches_filter() we could do thi=
s:<br>
<br>
bool filter_by_size =3D (params.filter.mask &amp;<br>
(ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D<br>
0;<br>
while (ct) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_filter(ct, &amp;priv-&=
gt;filter, &amp;counters)) {<br>
...<br>
}<br>
if (ct) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_params(ct, &amp;param=
s.data, filter_by_size ?<br>
&amp;counters : NULL);<br>
...<br>
}<br>
<br>
Wouldn&#39;t that work?<br>
<br></blockquote><div>Ack, yeah this logic works and obviates the need for =
fetched_counters. I&#39;ll include this in the next version.</div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (skip_count =3D=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0skip_count--;<br>
&gt; @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params.data);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params.data, fetched_counters ? &amp;counters : NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;=
positioned =3D true;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct codetag *ct;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data params;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fetched_counters;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&amp;params, 0, sizeof(params)=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv =3D m-&gt;private;<br>
&gt; @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct seq_f=
ile *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D codetag_next_ct(&amp;priv-&gt;=
ioctl_iter);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct &amp;&amp; !matches_filter(ct, &=
amp;priv-&gt;filter))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fetched_counte=
rs =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter, &amp;counters, &amp;fetched_counters))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D co=
detag_next_ct(&amp;priv-&gt;ioctl_iter);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params, fetched_counters ? &amp;counters : NULL);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ct) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;=
positioned =3D false;<br>
&gt; --<br>
&gt; 2.54.0.1136.gdb2ca164c4-goog<br>
&gt;<br>
</blockquote></div></div>

--000000000000806db90654791c40--

