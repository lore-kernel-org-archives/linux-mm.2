Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28E9C9832A
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 21:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35916B0088; Fri, 25 Sep 2026 17:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF3E6B008A; Fri, 25 Sep 2026 17:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961366B008C; Fri, 25 Sep 2026 17:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD8C6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:25:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED38F1C352D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:25:53 +0000 (UTC)
X-FDA: 85253566986.24.829C14D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id E55F416000F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:25:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZxYa7Uc9;
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790371551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoNZO0aDUfkzxaVvIvd0LTu0xEPlhvL2HKoxngaxH14=;
	b=vSfPCe6i4GIoio3m3vy5EIM3ZtwQRXCBphGPI087fc4aap3L4kw661Z4UzQncLbdnD1+bl
	X9tU6jai25d6aMY5Qv1cTKrYkwZLQJo7pWYdcxkEe/j/dpVqA8ByN8vYt/xn2M6rcqdFTc
	outaDdh/wFD08LAtl57TzcaLfkndzDw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790371551;
	b=NVeCYdR7Jxekd5aNnxGVQPLz0E/OShI2I6eMer/vmnc3L0HNsrNk5ilqEtaTr3LUKLYuJK
	ugL4KLTszdJNIz47O+ToTMiLX9wN7crpSfmDSnQ9JKm7u1VZL9t2UL1u1lD2Q6l3yJoMPo
	TwMUQXTHC++gs783SLR/tfUlCAjwraA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZxYa7Uc9;
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d8facae850so19755ad.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790371551; cv=none;
        d=google.com; s=arc-20260327;
        b=Xd1jEdTxYUL6RGIcZjLwM+5d8I33b5L8N9iAtFG8/dmE92F9cZYs08Aa4xz+wuvf/q
         ENxB19/m8yktShTeMGVGgCUfMZOlBoR1P+/mYWls8ZvFnfWFCKnEnswP7EaiI0+jTNUH
         FrzLWRNteb3eiJS2YolhxyFASjC/bXPX6JjCL1xIADowqiAGYe9B9pvmYz1o7zVhYY8Q
         8rzzSnqToS1FIAe3lZr4JLHsHn+eIurajqjGkQRlf3Ff/xPJSanDPYzSMyE6AydslU43
         BLofFDTkujaijNfMLBm2dS4fGbVblhnnB5z0xlD0CvxNHTOzpSxkRr41QNCBN4VoVwy2
         Eifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DoNZO0aDUfkzxaVvIvd0LTu0xEPlhvL2HKoxngaxH14=;
        fh=PcEW6n1QKm9e2IV25LQSipoZm3H0hB4cMoTCOMo5DmQ=;
        b=lzD3D4KXVmWO+fBCsLFVZxz4oPrmHLqcsgnyKR2JuwwA4DvboRW9Gxd6yv4nOJPGry
         DGxQQXXZKzcJuU3ywa/ewjuGMGDIJ0/BefFe5X6ROTW168BEvLEhRyegRRAN4348479u
         wfM4NoD2zLonk5m3Q2i34PDOTXLBX61qBnVP5RzLBXsSkCvVN0rM9YHySwSbPeLOuGoq
         d8N/5RgqCLHAtyRTJzIySpSEV8pq9AxjAdZPt9bKpBD0ZWSe5EvxcupjwER97INucrec
         dvjAdYeogOIu5nMSKxjsFQDzQQMRS4u9cwLiQJsB9LydiGRCFFJSJIqkUiYTFk+GJGBZ
         Sk3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790371551; x=1790976351; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DoNZO0aDUfkzxaVvIvd0LTu0xEPlhvL2HKoxngaxH14=;
        b=ZxYa7Uc9OdEC8nTnwIaPxxzWNxUXGhId5kSmpwrnuqSPemjboyz8sJu9DDksEqlSPB
         TyKNCFASjw/ynKe7ZSiy0cAFUJigOFiq0MAfi4V8yVakXUraqHHCEiPa4xF5igh1g7Dc
         tQdBLhW7aZg6cKIdxl2BniqPZKYCSxGEbVSKkWbO02gQfLhagvuHtD9wCeqnVhnBwBPp
         lbmlYqhIVmz++mYsnC1crdAMDRkasnuQvOwNPGbnjmIT8V1PDjkYNcrVUrqqkWdlgoWI
         tnf/MTF1KOoGkZFE0mPE/DEMWuVcaepdfYN1jwuSqEq/s9UVtQhZO4yv7swLt9+8F0Xi
         Pf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790371551; x=1790976351;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DoNZO0aDUfkzxaVvIvd0LTu0xEPlhvL2HKoxngaxH14=;
        b=os6kMfTFW5WzsPSyxm4Ab8LwLSCn6gNUh+uyux/uKxOjRbgvbwjvgzgV1twEL9WEku
         TUjfHrCjnzYki8l728+plPPdzJKdoy90soKlwM3SYoOeel45ckXFJ/afb+ObER7VPTT/
         YaDb4fb2ladvkwK1aH3gyMGHA3ozwxHuH2a+clp/YQFBtn+G1s60UTR3ERSTfZkMys3a
         rl3tCGqeaRB9guTU6e+7nDeVsJjlyaQE4SL6r8Wkj1O4WslFFuLVF7MgJSK+vMps2YJF
         kXx6fQRIP952reFfFcCoYSBcVLEY2ibls6I1TUqxFoFF5ihRB6SgILPRXo+ZnkVjEnRR
         /K3A==
X-Forwarded-Encrypted: i=1; AKwUvBwB2u+M6LJDRaQPvX8oGL44qgBK1Evf7e+zK8VPxkl5jqv7jFaKbef2tzAE9nm/cVEb+RiKdk+75Q==@kvack.org
X-Gm-Message-State: AFuF++l37sFJXulrE7X/AwKBKVqQ+w05neI9PX7SDpSmegunS/h5SGfr
	pjK+W4wdTRkHWClZja4EE+RkMCXkH9/09r7/V9dVVWdy73/0xzZayi0NLZO/V0C/kDeNaY9Uga7
	VcNGakmFIMNawfboMMeEQc+GdAib5aJ2jOCs/7zlv
X-Gm-Gg: AYBFou0WBpa6tDXDjf3QovwNPB6tQYlDCBDNVJk9g31rYp5oTaV9mD4uoT1yBk7Y1Zc
	n7jbA9ouPGlIKNFrxpbg839tlKomhbKuolsH5it6+HS8wuj3mwPV/RHkhou6HC+gxxV666+JnqI
	+GYIiwFdNLeuxA+hJT9kVQQDrEzp+GfPOzGvumTTTfRzcCSAkRHvEXLjBFPqnm9mwe8uIiXzCNE
	c/Pox3iJmYuq3phokj0mrdoOVGppAcmWXSruXDiiXKlrBpjPNKvk/Bdk5ELBcFfRUhhyjqP6OyD
	MvNuyUJphw++vatrW85o7grhTtFdARBs7VEj1aF0nvLJ6zE/RtaePRp/HSmsQgQQayi7qim2Cv7
	Af1PBX48yrQ==
X-Received: by 2002:a17:902:f691:b0:2d7:2a35:d14 with SMTP id
 d9443c01a7336-2dfa97778bfmr385335ad.11.1790371549788; Fri, 25 Sep 2026
 14:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
 <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev> <CAJuCfpFXky7Rj5ghPXGuL59PtG-cmXQywK3ttOHWx_v-pSSN9w@mail.gmail.com>
In-Reply-To: <CAJuCfpFXky7Rj5ghPXGuL59PtG-cmXQywK3ttOHWx_v-pSSN9w@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Fri, 25 Sep 2026 14:25:38 -0700
X-Gm-Features: AclHuK9aRfjh29Ivs7dP2LmFKlpdkfzrBFVOfllhvMysTuwZjBqFr7QwPJ-WxeI
Message-ID: <CAL41Mv5REKRLUwSZ9ViTKpBwtEEaE-A3VOK-A0pDTORVNQjeVg@mail.gmail.com>
Subject: Re: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7ze3ym8ajz4c74nnumu3sb36r7gmtofg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E55F416000F
X-HE-Tag: 1790371551-601957
X-HE-Meta: U2FsdGVkX1/XknYbiD7c6/JlaPz9XNU4x9789iW8ViGBGOs6AvUjW/RkXZGRMlaZjVwy1dQfzmAmT1QDX85t7iMgg/8+xqw0WOIKH/zX8bVzfNb/EyJLfGKmBgm/srHXB+e50SbGRR0O8SnjctjsxqS6Zz7KNfp89uINs02JhsSfkfQP4qKJNVI7rOwOPRvEdvRLBKx9RM6ONEryoh+HyDb9ANDQPSH15UUwYw+IJBj9nnEvr239rDUf/tpdXsQGziMIAYB1Vhz60yXKDt7aYvS+paV8vjs9CmoXO+X7lyXtWxwdMwCF0W9M0DoykYfndMIOIIxcqLubPC1tAL9H0B8A03l+U8FDjONQWFnEo+QtrONQKnDo3vI/W9/gp7ES5EK17+dvBg4dWhXzpdntDzeQsdzZ8ca8XfZiA420tRY2YMReKZSM8SSvxJKCw9Mh1ev564pxYqF40fQzQCaHnRQv/aa2q2djyocEi5F/HUz99mqYIZvZZnKHkULgA2h6ObtnnYGvwVGmpLr8wLZ5wWgIjN/I8BDMjXYAUH9895bC5U9WNrjl/5T821U2kDfSIP7PiGKtrumCIseYyE4pQxVTIJjVIKiOdPasl0D9egfksvqCeitxUx/iz1kFDuYuXrR2yAAEzcsC4sxBqnLKCP/c5aLrbEPC9tvMKZDP36s9QRGJO8yjBshnDYGfXbMLuoXDjowTdP74c8vdunb4zynqhYwpgbvf/JcnXhst2oWx5QoAml+W4/oZ49He83Zwd0J3O7yqEVTi2gM9oF6fpFyDDIKUJMXn1IXhUwVk0JuqC8h06EEdb1NwMuB3njKQF7rTLiotEwmC+37icxgcoj1TaFfqtLzv2L6n7z3VXxvZME9/A9Bc0FGv54LrYtZ4v7L0gXT2J0mdM/ClbDDVpzLGED3MIjhuzzi8TYSx3P4A1OL0i6aUApjVGmfR/bE9Hi+pibQnI3kAUMVviwh
 aMjjb4DG
 cNsjKJvkFUAzI7Lson5TsvOr4bXVY55SXK3yQ/tO863mUNbofIMxyeKRfFfgkxsJSmtEQdCWOtTtJYyKuS+ogqq8j4kJXPHzzuqYQGjZfUkX7n/agLahN64E0GNL/F3cWdds0ij8/ymsCPFSrjdJK0+kEmlyug5bXV35WG4QCf/Rzx7gOZhrZpZC+2Ih7yaHLq/XqBzSfYpF6izzd48qUz87vQD2930vSvglK86wlhMKGA8puDbXDL9eTQ0xYShCBSuUlfMJzNqoPhF8ao3FVlRUPxqanUfOjS4cOmeOSY9fFhx7Hf9D2NVUbMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:18=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Sep 24, 2026 at 1:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Abhishek
> >
> > On 2026/9/22 05:26, Abhishek Bapat wrote:
> > > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> > > toggle tracing on exact allocation call sites. Userspace tools can
> > > use the existing filtering mechanism to specify the set of tags to
> > > toggle tracing for.
> > >
> > > To facilitate low overhead execution for non-targeted call sites, add=
 a
> > > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-sit=
e
> > > activation. Protect these conditional branch evaluations using a glob=
al
> > > `alloc_tag_trace_key` static branch and an inline static key check
> > > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc=
).
> > > This ensures that the trace events are entirely skipped when no
> > > allocation call sites are being actively traced, leaving only a NOP o=
n
> > > the allocation fast path.
> > >
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > ---
> > >  include/linux/alloc_tag.h      |  39 ++++++++----
> > >  include/linux/codetag.h        |   5 +-
> > >  include/uapi/linux/alloc_tag.h |   9 +++
> > >  mm/alloc_tag.c                 | 110 +++++++++++++++++++++++++++++++=
+-
> > >  4 files changed, 147 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > > index 2994934cf44a..dc86f8997476 100644
> > > --- a/include/linux/alloc_tag.h
> > > +++ b/include/linux/alloc_tag.h
> > > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(v=
oid)
> > >                                  &mem_alloc_profiling_key);
> > >  }
> > >
> > > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > > +{
> > > +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> > > +}
> > > +
> > > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > > +{
> > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE=
);
> > > +}
> > > +
> > > +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> > > +{
> > > +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > +}
> > > +
> > > +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> > > +{
> > > +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > +}
> > > +
> > > +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
> > > +{
> > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
> > > +}
> > > +
> > >  static inline bool alloc_tag_trace_enabled(const struct alloc_tag *t=
ag)
> > >  {
> > > -     return static_branch_unlikely(&alloc_tag_trace_key);
> > > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > > +             return tag && alloc_tag_is_traced(tag);
> > > +     return false;
> > >  }
> > >
> > >  void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_=
tag *tag,
> > > @@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codetag_r=
ef *ref, size_t bytes)
> > >       ref->ct =3D NULL;
> > >  }
> > >
> > > -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > > -{
> > > -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > > -}
> > > -
> > > -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > > -{
> > > -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > > -}
> > > -
> > >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> > >
> > >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > > index a25a085c2df1..f728295d50c0 100644
> > > --- a/include/linux/codetag.h
> > > +++ b/include/linux/codetag.h
> > > @@ -18,6 +18,7 @@ struct module;
> > >
> > >  /* codetag flags */
> > >  #define CODETAG_FLAG_INACCURATE      (1 << 0)
> > > +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> > >
> > >  /*
> > >   * An instance of this structure is created in a special ELF section=
 at every
> > > @@ -25,7 +26,7 @@ struct module;
> > >   * an array of these.
> > >   */
> > >  struct codetag {
> > > -     unsigned int flags;
> > > +     atomic_t flags;
> > >       unsigned int lineno;
> > >       const char *modname;
> > >       const char *function;
> > > @@ -71,7 +72,7 @@ struct codetag_iterator {
> > >       .function       =3D __func__,                     \
> > >       .filename       =3D __FILE__,                     \
> > >       .lineno         =3D __LINE__,                     \
> > > -     .flags          =3D 0,                            \
> > > +     .flags          =3D ATOMIC_INIT(0),               \
> > >  }
> > >
> > >  void codetag_lock_module_list(struct codetag_type *cttype);
> > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/allo=
c_tag.h
> > > index 7d4618bea043..069ab8341e87 100644
> > > --- a/include/uapi/linux/alloc_tag.h
> > > +++ b/include/uapi/linux/alloc_tag.h
> > > @@ -85,9 +85,16 @@ struct allocinfo_get_at {
> > >       struct allocinfo_tag_data data;
> > >  };
> > >
> > > +struct allocinfo_toggle_traces {
> > > +     /* inputs */
> > > +     struct allocinfo_tag fields;
> > > +     __u64 enable;
> > > +};
> > > +
> > >  #define _ALLOCINFO_IOC_CONTENT_ID    0
> > >  #define _ALLOCINFO_IOC_GET_AT                1
> > >  #define _ALLOCINFO_IOC_GET_NEXT              2
> > > +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> > >
> > >  #define ALLOCINFO_IOC_BASE           0xA6
> > >  #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOC=
INFO_IOC_CONTENT_ID,     \
> > > @@ -96,5 +103,7 @@ struct allocinfo_get_at {
> > >                                             struct allocinfo_get_at)
> > >  #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE=
, _ALLOCINFO_IOC_GET_NEXT,       \
> > >                                            struct allocinfo_tag_data)
> > > +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _ALLOC=
INFO_IOC_TOGGLE_TRACE,   \
> > > +                                         struct allocinfo_toggle_tra=
ces)
> > >
> > >  #endif /* _UAPI_ALLOC_TAG_H */
> > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > index a5339767efd5..fb179321a2a1 100644
> > > --- a/mm/alloc_tag.c
> > > +++ b/mm/alloc_tag.c
> > > @@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> > >  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > >  EXPORT_SYMBOL(alloc_tag_trace_key);
> > >
> > > +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> > > +
> > > +/*
> > > + * As `codetag_lock_module_list` is a read lock, we need an addition=
al mutex
> > > + * to protect against the race conditions involved in the alloc tag =
trace
> > > + * toggle path.
> > > + */
> > > +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> > > +
> > >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> > >  unsigned long alloc_tag_ref_mask;
> > >  int alloc_tag_ref_offs;
> > > @@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct, st=
ruct allocinfo_filter *filter,
> > >               return false;
> > >
> > >       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > > -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > > +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_tag(=
ct));
> > >               if (inaccurate !=3D !!(filter->inaccurate))
> > >                       return false;
> > >       }
> > > @@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct seq_f=
ile *m, void __user *arg)
> > >       return ret;
> > >  }
> > >
> > > +static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool enabl=
e)
> > > +{
> > > +     if (enable) {
> > > +             if (alloc_tag_is_traced(tag))
> > > +                     return false;
> > > +
> > > +             alloc_tag_set_traced(tag);
> > > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> > > +                     static_branch_enable(&alloc_tag_trace_key);
> > > +     } else {
> > > +             if (!alloc_tag_is_traced(tag))
> > > +                     return false;
> > > +
> > > +             alloc_tag_clear_traced(tag);
> > > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > > +                     static_branch_disable(&alloc_tag_trace_key);
> > > +     }
> > > +
> > > +     return true;
> > > +}
> > > +
> > > +/*
> > > + * Toggles context capture for a specified allocation.
> > > + */
> > > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __u=
ser *arg)
> > > +{
> > > +     struct allocinfo_toggle_traces params;
> > > +     struct codetag_iterator iter;
> > > +     struct codetag *ct;
> > > +     int matches =3D 0, successes =3D 0, ret;
> > > +
> > > +     if (!capable(CAP_SYS_ADMIN))
> > > +             return -EPERM;
> > > +
> > > +     if (copy_from_user(&params, arg, sizeof(params)))
> > > +             return -EFAULT;
> > > +
> > > +     codetag_lock_module_list(alloc_tag_cttype);
> > > +
> > > +     struct allocinfo_filter filter =3D {
> > > +             .mask =3D ALLOCINFO_FILTER_MASK_MODNAME |
> > > +                    ALLOCINFO_FILTER_MASK_FUNCTION |
> > > +                    ALLOCINFO_FILTER_MASK_FILENAME |
> > > +                    ALLOCINFO_FILTER_MASK_LINENO,
> > > +             .fields =3D params.fields,
> > > +     };
> > > +
> > > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > > +
> > > +     /* Toggle tracing on all codetags that match */
> > > +     while ((ct =3D codetag_next_ct(&iter))) {
> > > +             if (matches_filter(ct, &filter, NULL, NULL)) {
> > > +                     matches++;
> > > +
> > > +                     mutex_lock(&alloc_tag_trace_mutex);
> > > +                     if (alloc_tag_trace_toggle(ct_to_alloc_tag(ct),=
 !!params.enable))
> > > +                             successes++;
> > > +                     mutex_unlock(&alloc_tag_trace_mutex);
> > > +             }
> > > +     }
> > > +
> > > +     if (matches =3D=3D 0)
> > > +             /* Nothing matched the filter */
> > > +             ret =3D -ENOENT;
> > > +     else if (successes =3D=3D 0)
> > > +             /* Items matched, but were already in the requested sta=
te */
> > > +             ret =3D -EINVAL;
> >
> > Why do we return -EINVAL in this path?
> > -EINVAL can mislead users into thinking their arguments are wrong.
> > That's not the case; the trace request they want is already active.
> > Maybe -EEXIST ?
>
> Or even 0 since the configuration already matches what the user requested=
.
>
Ack, will modify in v2.
> >
> > Thanks
> > Best Regards
> > Hao
> >
> > > +     else
> > > +             ret =3D 0;
> > > +
> > > +     codetag_unlock_module_list(alloc_tag_cttype);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >  /*
> > >   * Entry point ioctl function for /proc/allocinfo routing requests t=
o fetch the
> > >   * layout content ID, seek to a specific tag, or read sequential tag=
s.
> > > @@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file, un=
signed int cmd,
> > >       case ALLOCINFO_IOC_GET_NEXT:
> > >               ret =3D allocinfo_ioctl_get_next(file->private_data, ar=
g);
> > >               break;
> > > +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> > > +             ret =3D allocinfo_ioctl_toggle_trace(file->private_data=
, arg);
> > > +             break;
> > >       default:
> > >               ret =3D -ENOIOCTLCMD;
> > >               break;
> > > @@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_ops =
=3D {
> > >
> > >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > >  {
> > > -     if (unlikely(!tag))
> > > -             return;
> > >       trace_alloc_tag_hit(tag);
> > >  }
> > >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > > @@ -1043,6 +1128,24 @@ static int load_module(struct module *mod, str=
uct codetag *start, struct codetag
> > >       return 0;
> > >  }
> > >
> > > +static void unload_module(struct module *mod, struct codetag *start,=
 struct codetag *stop)
> > > +{
> > > +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> > > +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> > > +     struct alloc_tag *tag;
> > > +
> > > +     /*
> > > +      * Turn tracing off for the tags of the module being unloaded. =
Without
> > > +      * this, `alloc_tag_trace_cnt` would never reach zero and traci=
ng would
> > > +      * stay enabled forever.
> > > +      *
> > > +      * `alloc_tag_trace_mutex` is not needed here as this code path=
 is
> > > +      * protected by a `down_write(&cttype->mod_lock)`.
> > > +      */
> > > +     for (tag =3D start_tag; tag < stop_tag; tag++)
> > > +             alloc_tag_trace_toggle(tag, false);
> > > +}
> > > +
> > >  static void replace_module(struct module *mod, struct module *new_mo=
d)
> > >  {
> > >       MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> > > @@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
> > >               .alloc_section_mem      =3D reserve_module_tags,
> > >               .free_section_mem       =3D release_module_tags,
> > >               .module_load            =3D load_module,
> > > +             .module_unload          =3D unload_module,
> > >               .module_replaced        =3D replace_module,
> > >  #endif
> > >       };

