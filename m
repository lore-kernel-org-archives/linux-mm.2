Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B05CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCA68E0023; Wed, 10 Sep 2025 10:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E098E0022; Wed, 10 Sep 2025 10:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335098E0023; Wed, 10 Sep 2025 10:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 200E48E0022
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:50:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8FE011B0A1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:49 +0000 (UTC)
X-FDA: 83873627418.21.CEDC8B0
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 19E1E140002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZIfV+1ce;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NYbNPMAmwuCrSGeuZHG4yC+dRkmjVH7KJw04/A85tY=;
	b=PnZkp4B7DvCnko1KiaSoHZyof1QCg0pPS0AbWStjf0lW6cxuRRKzdQ/haZWkPxtX3ahdYg
	NafcO2jPyOhSPElwn9bwRGZyofg71PFQKB4pC902ivnJN2ieYkh8K5qvvm25Fl63nNC64y
	GxPYs8JRmuQ8k0HVvswoBgYG8e6u7R4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515848; a=rsa-sha256;
	cv=none;
	b=l9+UJzwO7r8iS20ucWu7ITe/ZGH1wAMnfwtQM8KcW78FWkueZFDVFNLwg6BTm1E/Dfmlm4
	MH+6TAKHsqMII1fzcHox2oIgmd6JUI3CJNpO81ntPIyUFq2Ifhtp9D9QT1rXStWuatPKyI
	VkiXYho+06NYLKaod6PP9mMiuAI8IV4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZIfV+1ce;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b350971a2eso145831cf.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757515847; x=1758120647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NYbNPMAmwuCrSGeuZHG4yC+dRkmjVH7KJw04/A85tY=;
        b=ZIfV+1ceniKLx732VE4bXrpNVOZL3MuPpJsRJL2A5sw7ZXgSFerKlL092kxun/JWKE
         tigyLHSxqpS4qUKYD+pWokxtBl14eFk/DGgtCLD5fR1CZERTA662njlVv0K0IqshH3zz
         0cGE9nP/1dMD4Z+DVZSww5o+G5rQfy453K+lW+0Qlbcg+/AkXQaQ5dlETnJiZAN5zTyk
         grGa1pUyPBbR91GT1tGTnws5nVzT1JCdonzux+caN6sfUHiQA5/HnrEJxHfQhcVdMY+O
         W+M8MYySTonJmp4t8nhkbrpRKY/B9jH1sO4L9hi19/1wmFNwSEOeJL4k9yWoAb+F44WJ
         dcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757515847; x=1758120647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NYbNPMAmwuCrSGeuZHG4yC+dRkmjVH7KJw04/A85tY=;
        b=u34fwggCFOguQLlzAHccULeI9mX1BzRh7eQFB6qt1X257I//DBTkT6rKo54em43tss
         IgZzreuvbjMwqhwkBd+5QaPGDksuF/XK65Fbeo3vGUd67yyc7CBBnLAi0yVjj9rV3sQC
         e6g8mxRRYKs+ynKAohvy429OZAXkCyKqVr3n9A6K8CQj1tUdgHZtOpvOGJyOapcd/HBq
         amVXbrfN67MOQr4QuH9Al9mscnm0gehQhMoI866SWFb3WX+TunB193NB8esa3xz4i5Y2
         QivbhUUvVjBIrxB6SP+Pn8zNN/Q1jyXQAod1weZfYHEBy0GBSVXERjESSKg8Orp25Rk4
         wGQA==
X-Forwarded-Encrypted: i=1; AJvYcCU+o5SRVAmm3JpVos4XR4yJPUk05KuzMxgfzFLaxiIRzZdKKSGQYCj3kSIR8pQZl/nSdI/p92Yf2w==@kvack.org
X-Gm-Message-State: AOJu0Yy28+77aw5jTATwYOAu4rJcMJYvF+i0uqJqmZl5AnvJFVcqVo6L
	eqzZ9VbPVfGL10oOIVWC2lj8/HCPGEUIwaiSvTLjHrj5o9dGv7/Z8q/UDeIT/sbs2mz3IZ2AeD9
	vB5SpyNhIECDZutSILe0iPpDkFA3lLWscG2BhjSX2
X-Gm-Gg: ASbGncudFgyFXJqMR8qD+0DFyNTqlOP495haTD2d8NsBB5dxdhbmYTdUgW4KYfa9hpV
	HVWGwnzkpaSTFG4QiSH3QrSIE3ixEoiqs/3u/omKomJujOAOJIjGOraZo9BTi4HkV1qTqnyGzZP
	KTs5Yk8mpXEXHejKJl1VoiWhJg8A9/Vx0GFoMCVmKS+0QkfbxucMCHIciaM2ABM66K18ir7qcNe
	6kdTMhHpYvAfZ3EfVzf43YWQirUJIwLGD+vgha197ZrG/X4XrKVKQ==
X-Google-Smtp-Source: AGHT+IFFqOWsPNmQquktqZ1ftZycysGTwGe1ZeTs0yi2D9K5qJeAhA84jkWLC1tZNBrc5ivvqPBodH5PnFD25ShGMuc=
X-Received: by 2002:a05:622a:2d4:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4b626da87a5mr4584991cf.1.1757515846235; Wed, 10 Sep 2025
 07:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <ff28f071-f448-4f25-bea0-17db946e0acf@suse.cz>
In-Reply-To: <ff28f071-f448-4f25-bea0-17db946e0acf@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 10 Sep 2025 07:50:35 -0700
X-Gm-Features: AS18NWC9mJuXsavWmAH7PEGfLW6cRsq8rLva9jLniFjBoy0_5OAKF6IjEcnNVRA
Message-ID: <CAJuCfpFf+D1C9esHXpR5WaJ_4=JmvZkYQMWY7KVYf42JLDTFZQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n4xtisg46t85n8bx34ixxcoukdnseomd
X-Rspam-User: 
X-Rspamd-Queue-Id: 19E1E140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757515847-279611
X-HE-Meta: U2FsdGVkX18WcClcfLq0T8cGvxg4FAMtE/HK4vlDwdKjZj/sggOaYgFPBfZxTmGTwimflp5bjofMNV4Nrdv9hAUAk2armvN/dPPC46tBlSJe9wckx3FL87Ov9uQVhNh0z6jUFqIo8trdIe5knZrayZxzUUR5GSsXcfx6VlIpgAx4uF3MTSHbL7/4iygIVoDoWF9o2zwa+jgcqpTbyUd0oLERhVhAn3MnLm7PVeNKvHB3Zct0aE+xW1k+rAZDwAr0JUxIfKq0UdJQ3f/MDCTa5/X8GjlbQDbFK35trNRANX+tAvqLcv9SbYJKo3I0DswbPHYboDDirvNGf2cJrBs7OU2uEE0S7yUVJS+s+dKvcN728iNwY8EKQt8UiRWPUHkKyCN4REZ7CdTzDbOiZokE24knAF/lBpUYjoKmWHd3pZHAH0oR9fpgMHO/sHOq+0pKMJdGm0mdGcFv5bxj/YdSr3nrTcY2eD794YNUCfoluUmlPoBiQDQVJqEg9MaDoiEaYU+D+4swKwdSOXS9BjeK2gZ0tADl6oZl0+ar56NQzJfRxrH8hr6pP4Oz3QrnmKK46wzVPnM3GARvEDQtYGlk7btF8nfD/uvtJsc5b8twA1pD/y/6ZnnTob63bAt+gfF9vCUy0wCKD2T5cNxlMCERCEYfCOjS9SgtKeo9mmhPNYQOukVTjgM7vE5xdjfTJpr40/HmuYn7BDExp32N/+9fWv3z7VRklRh8MGyaT/C4rT3mfeypClw92mdooCslDRvxI8pAamaisYq3uUxr8Mo6Mf6ut20IaxdTPoKSI8l6q9xeaZZiLU+q9EhcDTcfekZ/7OLZkmEdmVYfQHbPvoG/xz3UROgHdfV0ZL6d+TlBHW88jbRClYkwjDste1ALQdbRvD04PkryynJr/FK+vdD5oAu9cSngcFAO5pRLX2FSZbzx44AOkgDCZerfiWVTn21084XMB0ApAZpHwGVYXrD
 qE5ZoWE4
 gTr7IO7rAaadzUnRuBTpARC1MyqNelmsz0YS6TbJfMMzvwXlxZ2jeCrvJvFsHDmXyJQZhuCSoy7VTnTCCoa3MWVqnQf+QL/Arw//6W8LPbJlFBUleUZkJi+7iNlvLldw2y4W15qNV1KtRlPGUrp+yKASJmncPZcg0ivaFd8G5EtRkSlvfs8rw5isJ65Gv95bUYpUH6rLGnGzPQ2+Bu5L/k03Jb1nzLyi9mGlh/e9bqqAzgC1hF8e6Ovzi09+yn2BNFP6qqkXBm63UZwtcrxQKozEnce7rMgvQbuf7ZAnO7Fe7N4zNHA2WdtbYDI7kZcJz/6h8BNW1oM7NSrnU7mMNfC9S6aJeiuHzWR+vHYaVm7nE/3WfqLLaFqJTIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 11:25=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/10/25 01:49, Suren Baghdasaryan wrote:
> > While rare, memory allocation profiling can contain inaccurate counters
> > if slab object extension vector allocation fails. That allocation might
> > succeed later but prior to that, slab allocations that would have used
> > that object extension vector will not be accounted for. To indicate
> > incorrect counters, mark them with an asterisk in the /proc/allocinfo
> > output.
> > Bump up /proc/allocinfo version to reflect change in the file format.
>
> Since it's rare, is it worth the trouble?

Apparently they are seen in Meta's fleet which instigated this thread:
https://lore.kernel.org/all/17fab2d6-5a74-4573-bcc3-b75951508f0a@gmail.com/

>
> > Example output with invalid counters:
> > allocinfo - version: 2.0
> >            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_=
data_nodes
> >            0        0 arch/x86/kernel/alternative.c:2090 func:alternati=
ves_smp_module_add
> >           0*       0* arch/x86/kernel/alternative.c:127 func:__its_allo=
c
> >            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_=
set
> >            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_re=
alloc
> >            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_en=
able_hybrid_capacity_scale
> >            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:=
init_amd_l3_attrs
> >       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_devi=
ce_create
> >        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_ge=
n_pool_create
> >            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thres=
hold_create_device
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Here a link might have been helpful :)

Right, here it is and suggestion is in the last paragraph:
https://lore.kernel.org/all/20250519160846.GA773385@cmpxchg.org/

>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> > Patch is based on mm-new.
> >
> >  include/linux/alloc_tag.h | 12 ++++++++++++
> >  include/linux/codetag.h   |  5 ++++-
> >  lib/alloc_tag.c           |  7 +++++--
> >  mm/slub.c                 |  2 ++
> >  4 files changed, 23 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 9ef2633e2c08..d40ac39bfbe8 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref=
 *ref, size_t bytes)
> >       ref->ct =3D NULL;
> >  }
> >
> > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > +{
> > +     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > +}
> > +
> > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > +{
> > +     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > +}
> > +
> >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> >
> >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void=
) { return false; }
> >  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_=
tag *tag,
> >                                size_t bytes) {}
> >  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)=
 {}
> > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
> > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { re=
turn false; }
> >  #define alloc_tag_record(p)  do {} while (0)
> >
> >  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index 457ed8fd3214..8ea2a5f7c98a 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -16,13 +16,16 @@ struct module;
> >  #define CODETAG_SECTION_START_PREFIX "__start_"
> >  #define CODETAG_SECTION_STOP_PREFIX  "__stop_"
> >
> > +/* codetag flags */
> > +#define CODETAG_FLAG_INACCURATE      (1 << 0)
> > +
> >  /*
> >   * An instance of this structure is created in a special ELF section a=
t every
> >   * code location being tagged.  At runtime, the special section is tre=
ated as
> >   * an array of these.
> >   */
> >  struct codetag {
> > -     unsigned int flags; /* used in later patches */
> > +     unsigned int flags;
> >       unsigned int lineno;
> >       const char *modname;
> >       const char *function;
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index e9b33848700a..a7f15117c759 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *=
arg)
> >  static void print_allocinfo_header(struct seq_buf *buf)
> >  {
> >       /* Output format version, so we can change it. */
> > -     seq_buf_printf(buf, "allocinfo - version: 1.0\n");
> > +     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> >       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> >  }
> >
> > @@ -90,7 +90,10 @@ static void alloc_tag_to_text(struct seq_buf *out, s=
truct codetag *ct)
> >       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> >       s64 bytes =3D counter.bytes;
> >
> > -     seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
> > +     if (unlikely(alloc_tag_is_inaccurate(tag)))
> > +             seq_buf_printf(out, "%11lli* %7llu* ", bytes, counter.cal=
ls);
> > +     else
> > +             seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls=
);
> >       codetag_to_text(out, ct);
> >       seq_buf_putc(out, ' ');
> >       seq_buf_putc(out, '\n');
> > diff --git a/mm/slub.c b/mm/slub.c
> > index af343ca570b5..9c04f29ee8de 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache=
 *s, void *object, gfp_t flags)
> >        */
> >       if (likely(obj_exts))
> >               alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size=
);
> > +     else
> > +             alloc_tag_set_inaccurate(current->alloc_tag);
> >  }
> >
> >  static inline void
> >
> > base-commit: f4e8f46973fe0c0f579944a37e96ba9efbe00cca
>

