Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E6D8C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9478F6B0095; Fri, 25 Sep 2026 02:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883E66B0096; Fri, 25 Sep 2026 02:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723B86B0098; Fri, 25 Sep 2026 02:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1256B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:19:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D01A51C3206
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:19:00 +0000 (UTC)
X-FDA: 85251281640.15.967A9AB
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id D655740004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:18:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9zF2FUr;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790317138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz9tB2z3S3sCyejswcJCnUBTJ7VXWxVMWAfpYTY4kkk=;
	b=lCLCw9TxPnH7jGz0zFMcFoG/XCJc+B03ja43XyO8nX0KbbfdN+XDJWYem+yRo3v/bsr1Zt
	TaUyGkAwav5dQGFoH9atTjFGGLUn8yfl+vce0GEkz+WZ3hv60CXWZ08zkk31J6xLRDL+PG
	LM/G+gx5hGvfXEuXW5IsuOkJu1OiMjA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790317138;
	b=UD86fjuAd2pEyc8nhJ+OCWcoxKVXsmGnGklEVh71d2F83BC79ipSlJd4iwhTazSwZ6H99m
	Wxnwf33A+8tvxyfcN6pMACk8ySw/joxpsxXBPwLn03CGYABLP9A/8P9+Jfn9nhr3RNKZrS
	3G6B0Cu4IFB8utZtkofzjzFhTA4/ykg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9zF2FUr;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-530e8c6fb80so124081cf.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790317138; cv=none;
        d=google.com; s=arc-20260327;
        b=BNoIXTHAUrgh5wcSJM/46589jAdPmgGYpcKML2P47ldr1MY+RPoydjlafzOwVPtA9N
         gOJpqWzLZfSSwpoidNJjqFbcaW9IeDO+xla3Y767jXpZyqxlTc6GrU3BBJ7XRY/2aF2R
         DD8WKEgkk17gdkTM0lA2z4G1dGwQA5nhgtBK+rJvgw84TmBdC/kx6iSMczoBF9U0Jps2
         wqSiEhxN9BDuVjId0fbTdAgWrs+ZuIZ145RmXFtip05rvDPNSkw6q2RiBryxFnAENIZF
         VgxcJV1keAevWeQ++Cnxgi+io4Sz1XU9oSzWR74vM3S6695uy/sIFtuldw5Q5BDzBeTW
         5Ijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kz9tB2z3S3sCyejswcJCnUBTJ7VXWxVMWAfpYTY4kkk=;
        fh=owoRPTVQdUVYYmnvDk+x5u7FPqLsEL2qbdF91C0vQ4g=;
        b=khkkmzJEd8Vx8V9/ZaK/gUfGV5I0YyJhY8uvu2c7lNWcZZErExStH+FOogt7MvvfNs
         7EDbYEm4yNE369UdVkKcwdZKljlGzV0k5Y+lS/IB/WiB3NiztDY1piS+WLxKwsmb+eMy
         C9le/AeVkObu2br3CvQ5ivZz2+3e2/WV3mj+MkNhIm6F4GlwdUHwLmaM0RQw55uCNRHU
         CulE1X/+vILBK/3WFooBdimGSWzwDSoO1Pmtu/OJcCxaxEHcWQ9Jt1ujtH4jD3Lh1VDK
         vZYM6cnDQqHGnLFeu8iH1CrllButBKeji6G6XfZyMpk9d3uz4o1GImods82bWa9DuwrE
         oy+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790317138; x=1790921938; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kz9tB2z3S3sCyejswcJCnUBTJ7VXWxVMWAfpYTY4kkk=;
        b=j9zF2FUrsdv66elc1xV8xOBp3XEWNh5Y82WjZVl7eP1yxDzrpHXmcCjMdjWePgjTy3
         FAB85fZ+ogoX399EYEyiRZeF+KyA2RQePkpDkf5fyiQhhDnV1eYJIhTEyYzr5uo1tgl8
         8FwzlAksjPr4UJ8+XxRBdZQijQqWhQ02WjGoWL8X7HRwazcfX87KCz3RMiTbz87ON5eF
         XH+KvjB34u5t0I3bjSziUx7Oska5T45pl7zNjTRd65JQeSvA6qUjVH2rDHWDkwFIUCJI
         b/N9gXDk6FRtYF65oJgdQslXcANcLrJKGKGXbG+V9BPy/E5XDIO0wyjbNQUJDrmhZwHg
         pgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790317138; x=1790921938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kz9tB2z3S3sCyejswcJCnUBTJ7VXWxVMWAfpYTY4kkk=;
        b=GGRmKCZ6oAd8BB/ZfJNjKW61w97bIcmMCw8Re+UAfdufFyBLFccH6FSYm4snARrrRZ
         O03G86zvIdE7nRbdnhxJLsSqxipy+XnSl7t/A+LN+4ifRsDdpdd+MR3Ce+Vs73sHWWAe
         HEKcheu2TSY92fRSE1sJvCty5BzFPka5lcBcWOsLTKK/xpL6lpb6RMUyA1nCBVfXyzRU
         bmsTddI1HWpAc6kTZIdfKzcjWajQQg4bfTEc6q6blguMe99K02CSFzAwgdrytGnaGg1k
         ZjE/iyayOOin+08Nj/riVJivh5O58rTKlk4mp8WDT+UHNSco/n4rWdzBxamQr61sZYWl
         tf9Q==
X-Forwarded-Encrypted: i=1; AKwUvBym3a++O0EAZPSqtiWWCgYHCLz20W8ASXQoclNseTg7JqAOwRqYlAYXFsG6wpXoQ9ntoWGwtJUTXg==@kvack.org
X-Gm-Message-State: AFuF++n/kRIbPaISh8liaMcoeVCQcZwOEh101W9zwPpQ18utQPbn/Ifp
	rd0eejoZ3911Nn4cb0FszK8chQO2CVuQmCZxS6OuJCZ+EelB7Cg2OgtaWuuDEoQDlCcn9stSZj1
	+nUhJlWXLX8wiH5ujiKpx8ijauvfgOtC4d06L1BIoXuB4imy6pjQ9W6q2
X-Gm-Gg: AYBFou0n/9DuLBBGSGg5KVa3wxrhjMS5h4ZSCo+vAE+5xR4hpTxqAO1pD8Zp1qD5gs8
	wQZEpiVDjTMXbxSclZklb9svmRHP4DCXKaw8HgHrLVqWzsovxzSCDLe85QYvuCtrW8hYsxKZAw+
	CaWXBWSnJLdV5P0gYJBrLRg2dSwXtbFR7Q+fz809owRvBEjKBLXqyNQRxUPL6p4c4CXXXKXKvYY
	Ty5PIXs9VdoVVjEtK1gCrGYV4nNFNUe7lOldxiL6nMMAcs3XVNpRYJoDJrS9EhF23yA8uFK0/ES
	pHkInM6bmwtzGcHwnquDCWrJgdJGz74U5lfZ+TZoIcMGS0jrfBZwVA==
X-Received: by 2002:a05:622a:d3:b0:532:c8ca:5ae9 with SMTP id
 d75a77b69052e-5330e14c38bmr7182801cf.11.1790317137111; Thu, 24 Sep 2026
 23:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
 <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev>
In-Reply-To: <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Sep 2026 23:18:45 -0700
X-Gm-Features: AclHuK_ZMIjs94XXM1H9Vt6cVAryVPQqpcapIKbaCuH8lPzF3a3BVfOmnnxKix8
Message-ID: <CAJuCfpFXky7Rj5ghPXGuL59PtG-cmXQywK3ttOHWx_v-pSSN9w@mail.gmail.com>
Subject: Re: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D655740004
X-Stat-Signature: 8m1gg16jotwajn6sf315ezpfntkbf5k1
X-HE-Tag: 1790317138-839122
X-HE-Meta: U2FsdGVkX1/ZbOj5mjTua5UXe9mOIWtnpZJHmSfg7woBiPWWgDZkUvMhz3Te0y4OOT54Rp3+/yrFMp3vJDUdoi8Zza3z4TFjzXcMDUMBoyuPN/zy3E8xt3FucJ9fUdP86wUw5RuUurtCtu6VQazCZvbhLzStNWZlUjR0z0z1OG3N6qYbari8T7+/aupkaPwXrZ9GAbhXheSeRiBzFhKpJWPMVKI/MrRZI+PDs1PrQwK3okK2TsvadJcAF7WDJorv/ksB73K+HzLrtbLdxes5BIn/WNyS5znrhtGmgJ9CeArFox+nuKq10xFcsGMzvmAnqi567pHbbA2xDcqE1tZYHsjTK2t4ddGNSgWmQ7XW3E58tOcqnNDsuSCkXAbvoUX19ssAOM12gHYSKWrRgN9Bj0HN4zOBNSmKXurYl9n0SIPPP4gr1s6TOBKkWHY60avEkXK0XUFj4HBdLjjUaup2SyDL7V/WxSO+KWqPr5XbF+h2d1+h/iBCJJphQ7qxIHxiHUQZ2//fUOf2LPIZNmuAWOJt4IZI8PDfKkEIfoXQVaMV+4ZmAu9QLptPtBBm8YzGu8gKLhCh7c4RcxLiqdfiwHc+o8wy4W1DhX85XxbOrLwdcDWZhvmYfs9341EFn7BaXV9coZV6tM4IrzgZ+3gHK1kCxII8eC5mZpiQTwSk+fPxH0thG9XubRzaLfcCCjmpVX8CnxBykOJRt5MYzKVt5P67EMo9YW6wxOQnURHhXuCmT3I/YyI7wYXCd1eVcCzq0Nr8IIoFELijxUQ+kETsg/AI70LiI6jLijX+4obQHUvg6S34D0r1s3PXeANRpuo9291fiCpFcYcKqU0ZbDjia8ul1Zhjzhi8FJjPL0NpsCUcPYy4GP73vldd7GowQPjJIvDeZFn0fyT3XVpSw4c6nWGi5GkmwBt3ZNeqB9Q00ppxaIKToguyfWgGRxCsbCDCiQMGaj0kYaouyVlilo/
 AodI1HMe
 XIY1ZgOmnQ79bCy1ElEdXxnVw2n9unQ4VVgzlpHHABsnKs9v+i5iGyMePYTz5A/649NU4u2KSGwL69n7G2ro7xgA/ZlmGku+aI2Z3ESVlsF6vezu56a/8Rh742rQhMQ6u0tdwnPai3+nzOasdQb0Z5M1aDoyeJVFSLXlQOx1zq7MrRG/3qeURBrzdSqMIWPydPe0gx2AlJTScxLuPh6/iv8SEZ6hoVdwM++SV/BdFS7XjKZaNCK8IfJ6ynlcdge0gjxYluR7FKFZ+QdRt6Ly24HW1Ynqm8qo1A0Y1/p0o/8GGo36iUcKDOPDJ5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 1:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
> On 2026/9/22 05:26, Abhishek Bapat wrote:
> > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> > toggle tracing on exact allocation call sites. Userspace tools can
> > use the existing filtering mechanism to specify the set of tags to
> > toggle tracing for.
> >
> > To facilitate low overhead execution for non-targeted call sites, add a
> > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
> > activation. Protect these conditional branch evaluations using a global
> > `alloc_tag_trace_key` static branch and an inline static key check
> > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
> > This ensures that the trace events are entirely skipped when no
> > allocation call sites are being actively traced, leaving only a NOP on
> > the allocation fast path.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >  include/linux/alloc_tag.h      |  39 ++++++++----
> >  include/linux/codetag.h        |   5 +-
> >  include/uapi/linux/alloc_tag.h |   9 +++
> >  mm/alloc_tag.c                 | 110 ++++++++++++++++++++++++++++++++-
> >  4 files changed, 147 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 2994934cf44a..dc86f8997476 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(voi=
d)
> >                                  &mem_alloc_profiling_key);
> >  }
> >
> > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > +{
> > +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> > +}
> > +
> > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > +{
> > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE);
> > +}
> > +
> > +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> > +{
> > +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > +}
> > +
> > +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> > +{
> > +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > +}
> > +
> > +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
> > +{
> > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
> > +}
> > +
> >  static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag=
)
> >  {
> > -     return static_branch_unlikely(&alloc_tag_trace_key);
> > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > +             return tag && alloc_tag_is_traced(tag);
> > +     return false;
> >  }
> >
> >  void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_ta=
g *tag,
> > @@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codetag_ref=
 *ref, size_t bytes)
> >       ref->ct =3D NULL;
> >  }
> >
> > -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > -{
> > -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > -}
> > -
> > -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > -{
> > -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > -}
> > -
> >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> >
> >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index a25a085c2df1..f728295d50c0 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -18,6 +18,7 @@ struct module;
> >
> >  /* codetag flags */
> >  #define CODETAG_FLAG_INACCURATE      (1 << 0)
> > +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> >
> >  /*
> >   * An instance of this structure is created in a special ELF section a=
t every
> > @@ -25,7 +26,7 @@ struct module;
> >   * an array of these.
> >   */
> >  struct codetag {
> > -     unsigned int flags;
> > +     atomic_t flags;
> >       unsigned int lineno;
> >       const char *modname;
> >       const char *function;
> > @@ -71,7 +72,7 @@ struct codetag_iterator {
> >       .function       =3D __func__,                     \
> >       .filename       =3D __FILE__,                     \
> >       .lineno         =3D __LINE__,                     \
> > -     .flags          =3D 0,                            \
> > +     .flags          =3D ATOMIC_INIT(0),               \
> >  }
> >
> >  void codetag_lock_module_list(struct codetag_type *cttype);
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index 7d4618bea043..069ab8341e87 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -85,9 +85,16 @@ struct allocinfo_get_at {
> >       struct allocinfo_tag_data data;
> >  };
> >
> > +struct allocinfo_toggle_traces {
> > +     /* inputs */
> > +     struct allocinfo_tag fields;
> > +     __u64 enable;
> > +};
> > +
> >  #define _ALLOCINFO_IOC_CONTENT_ID    0
> >  #define _ALLOCINFO_IOC_GET_AT                1
> >  #define _ALLOCINFO_IOC_GET_NEXT              2
> > +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> >
> >  #define ALLOCINFO_IOC_BASE           0xA6
> >  #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_CONTENT_ID,     \
> > @@ -96,5 +103,7 @@ struct allocinfo_get_at {
> >                                             struct allocinfo_get_at)
> >  #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, =
_ALLOCINFO_IOC_GET_NEXT,       \
> >                                            struct allocinfo_tag_data)
> > +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_TOGGLE_TRACE,   \
> > +                                         struct allocinfo_toggle_trace=
s)
> >
> >  #endif /* _UAPI_ALLOC_TAG_H */
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index a5339767efd5..fb179321a2a1 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> >  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> >  EXPORT_SYMBOL(alloc_tag_trace_key);
> >
> > +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> > +
> > +/*
> > + * As `codetag_lock_module_list` is a read lock, we need an additional=
 mutex
> > + * to protect against the race conditions involved in the alloc tag tr=
ace
> > + * toggle path.
> > + */
> > +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> > +
> >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> >  unsigned long alloc_tag_ref_mask;
> >  int alloc_tag_ref_offs;
> > @@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct, stru=
ct allocinfo_filter *filter,
> >               return false;
> >
> >       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_tag(ct=
));
> >               if (inaccurate !=3D !!(filter->inaccurate))
> >                       return false;
> >       }
> > @@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)
> >       return ret;
> >  }
> >
> > +static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
> > +{
> > +     if (enable) {
> > +             if (alloc_tag_is_traced(tag))
> > +                     return false;
> > +
> > +             alloc_tag_set_traced(tag);
> > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> > +                     static_branch_enable(&alloc_tag_trace_key);
> > +     } else {
> > +             if (!alloc_tag_is_traced(tag))
> > +                     return false;
> > +
> > +             alloc_tag_clear_traced(tag);
> > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > +                     static_branch_disable(&alloc_tag_trace_key);
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +/*
> > + * Toggles context capture for a specified allocation.
> > + */
> > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __use=
r *arg)
> > +{
> > +     struct allocinfo_toggle_traces params;
> > +     struct codetag_iterator iter;
> > +     struct codetag *ct;
> > +     int matches =3D 0, successes =3D 0, ret;
> > +
> > +     if (!capable(CAP_SYS_ADMIN))
> > +             return -EPERM;
> > +
> > +     if (copy_from_user(&params, arg, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     struct allocinfo_filter filter =3D {
> > +             .mask =3D ALLOCINFO_FILTER_MASK_MODNAME |
> > +                    ALLOCINFO_FILTER_MASK_FUNCTION |
> > +                    ALLOCINFO_FILTER_MASK_FILENAME |
> > +                    ALLOCINFO_FILTER_MASK_LINENO,
> > +             .fields =3D params.fields,
> > +     };
> > +
> > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +
> > +     /* Toggle tracing on all codetags that match */
> > +     while ((ct =3D codetag_next_ct(&iter))) {
> > +             if (matches_filter(ct, &filter, NULL, NULL)) {
> > +                     matches++;
> > +
> > +                     mutex_lock(&alloc_tag_trace_mutex);
> > +                     if (alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !=
!params.enable))
> > +                             successes++;
> > +                     mutex_unlock(&alloc_tag_trace_mutex);
> > +             }
> > +     }
> > +
> > +     if (matches =3D=3D 0)
> > +             /* Nothing matched the filter */
> > +             ret =3D -ENOENT;
> > +     else if (successes =3D=3D 0)
> > +             /* Items matched, but were already in the requested state=
 */
> > +             ret =3D -EINVAL;
>
> Why do we return -EINVAL in this path?
> -EINVAL can mislead users into thinking their arguments are wrong.
> That's not the case; the trace request they want is already active.
> Maybe -EEXIST ?

Or even 0 since the configuration already matches what the user requested.

>
> Thanks
> Best Regards
> Hao
>
> > +     else
> > +             ret =3D 0;
> > +
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +
> > +     return ret;
> > +}
> > +
> >  /*
> >   * Entry point ioctl function for /proc/allocinfo routing requests to =
fetch the
> >   * layout content ID, seek to a specific tag, or read sequential tags.
> > @@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file, unsi=
gned int cmd,
> >       case ALLOCINFO_IOC_GET_NEXT:
> >               ret =3D allocinfo_ioctl_get_next(file->private_data, arg)=
;
> >               break;
> > +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> > +             ret =3D allocinfo_ioctl_toggle_trace(file->private_data, =
arg);
> > +             break;
> >       default:
> >               ret =3D -ENOIOCTLCMD;
> >               break;
> > @@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_ops =3D=
 {
> >
> >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> >  {
> > -     if (unlikely(!tag))
> > -             return;
> >       trace_alloc_tag_hit(tag);
> >  }
> >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > @@ -1043,6 +1128,24 @@ static int load_module(struct module *mod, struc=
t codetag *start, struct codetag
> >       return 0;
> >  }
> >
> > +static void unload_module(struct module *mod, struct codetag *start, s=
truct codetag *stop)
> > +{
> > +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> > +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> > +     struct alloc_tag *tag;
> > +
> > +     /*
> > +      * Turn tracing off for the tags of the module being unloaded. Wi=
thout
> > +      * this, `alloc_tag_trace_cnt` would never reach zero and tracing=
 would
> > +      * stay enabled forever.
> > +      *
> > +      * `alloc_tag_trace_mutex` is not needed here as this code path i=
s
> > +      * protected by a `down_write(&cttype->mod_lock)`.
> > +      */
> > +     for (tag =3D start_tag; tag < stop_tag; tag++)
> > +             alloc_tag_trace_toggle(tag, false);
> > +}
> > +
> >  static void replace_module(struct module *mod, struct module *new_mod)
> >  {
> >       MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> > @@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
> >               .alloc_section_mem      =3D reserve_module_tags,
> >               .free_section_mem       =3D release_module_tags,
> >               .module_load            =3D load_module,
> > +             .module_unload          =3D unload_module,
> >               .module_replaced        =3D replace_module,
> >  #endif
> >       };

