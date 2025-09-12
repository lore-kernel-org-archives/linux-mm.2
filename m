Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5070CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09448E0007; Fri, 12 Sep 2025 17:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9168E0002; Fri, 12 Sep 2025 17:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81408E0007; Fri, 12 Sep 2025 17:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28898E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:03:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39D1887398
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:03:18 +0000 (UTC)
X-FDA: 83881823676.13.D966E2E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3510F10000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:03:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Ghc3h/On";
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757710996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVJ20harXnfzHnDKK1hOVgN5G5NhgZps321C9eNzyC8=;
	b=OeGvqJ9ZyQ2/T2buUqq9LmJc/tTQtHq11vxpSKBvm5mAkpM52NKd9WvDErIAnH8Avm/mp4
	4kFmXMbOW2N/dhCFc/9oRJpzc964rKkaUjLafPgd2A1UdTSUThuWMkJX4POU4z+dlVUvtW
	QSyAseT8KT2D0BjHP74PwZDT4/ZVpiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757710996; a=rsa-sha256;
	cv=none;
	b=uwB5IHHU+qyPJyHupB5zAqHclTmtvrcXuesUAZbuXBi7QQtC+qJtTXkAkPxh00MfuiuA5e
	Oyg2yyzFEV7aeOxcfwufCYGXLzPWgXS80P7sbySkDQIw2QYF0rTq50HPq7IkfQEgvTEBZV
	JzcJtS39le77RQbvfpiKekbTT99Izes=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Ghc3h/On";
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b48fc1d998so23511cf.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757710995; x=1758315795; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVJ20harXnfzHnDKK1hOVgN5G5NhgZps321C9eNzyC8=;
        b=Ghc3h/OnHcUsQbMegMHB/VCB9gPFKymWZmdl+4p3qXnGQQro9ZeKPS1gU2N+xJOeDS
         tz7iXIaSvYS6LsvwiZbYjRwPDkNDPJJGVZthOAqBNQWOcmTiR5bw2oj8SwcWMUgPQiWL
         Wl47caB7gLtB2CKFqywEX5MMG4+stsHNv66uwJhAaGHwcA4/7iNDv+R3nxTIznKc/uv/
         RqSH/q9xUb/D8AOWZcTPx2s1J8pcNPKEuD/pOPWVFv1K0EhuaeD5pZL9qJaJaqTDDRFz
         Z2kqmxUzeP5uV8IBZn7uphoxjN4BGGufTi+fghAoKQvjL4/FMb74Z5Gh7w8jRqm73+xH
         yHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757710995; x=1758315795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVJ20harXnfzHnDKK1hOVgN5G5NhgZps321C9eNzyC8=;
        b=XDcbhKpzYuRnJ/q2YQx0lgQMaf49x5/ubDex4WzKyml6Zr0LQ4U0qkYJ1JfTLBrrTp
         aJevv4su5PgU+e1qG9/I10FvNIyBqtXOh28DXyzkUiw16JFehL04T0F9zVSsSqRfqz9C
         EwyBDP/2iwDsTJuDr1va6lK6xKk29/XJ81R8GG2ZuJIC6Y81IVGjC/xVKJP40KNqyiIy
         n5vFIe5qzuN8PlRngxS0yPoYoy5sjliC1FdBD8jlRmw24iWlZovhzHgLOveihljxat45
         gmV+3G8XSCmfAxGr2Ze281ddLoMah+xBx+rWJNe5tYBS2zDDG67PZ8Fk5t8QCBfYwTFA
         x53g==
X-Forwarded-Encrypted: i=1; AJvYcCUMpbz2ekIEvNug4EyqLGI1M6AU1KFIUvSCh0OYC8ZUKxR4imSqkE2HObwj3oC35BRbRZMfnLjKAA==@kvack.org
X-Gm-Message-State: AOJu0YwuQbY7x+bXQoTyjZPB2oBaYBVBIpe5VOkQoA9M6qLlaLVnN/C7
	JW36Xz/qt+PD1PyV671iMjyIP1KakLzGBmFzhuOok1jImdCZYjPdASWB0mM5EcE/dzytGV26ImE
	BEusw/pQk0yVDe3TUAv2rND8X4k+wXhXW0pxBsIeV
X-Gm-Gg: ASbGncsaCg6GDuQWhAG2W/Jr0mp6tfihXjIydnXoO29KuyVGr6UH1FdyANVmrEHGQvE
	byw9qYp7eEPlyND00DvyH5+TYq3KwZz9DHCfr064RvwEbv3yk2eEOl1OkY0bedhAg+PWrGPmO3N
	NCfsD2nXGm7Go+Ism74uqBbyJKiDjKi4jdNYP5dJc/86IraLI52e182G+5HAWT4g1rX3qNEq00j
	+XsU6aVqIo1c9Ys/H9GKHHvrbQlbR3exA==
X-Google-Smtp-Source: AGHT+IHseG9PtEuPE49/9tbUbIRhif36dOcTKh3RESUYQ0Xj0YcJ9huxjsg7Lumt1ghFNmsQrsmKynduT/0KDy32sIQ=
X-Received: by 2002:a05:622a:1a08:b0:4b3:19b2:d22 with SMTP id
 d75a77b69052e-4b78baee828mr1134171cf.13.1757710994465; Fri, 12 Sep 2025
 14:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
In-Reply-To: <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Sep 2025 14:03:03 -0700
X-Gm-Features: AS18NWBlwC6GnqxcNf8gN0VWwblEoVKW3TIWvmUUYGCzInpHnPoKF5oCvFK5EWQ
Message-ID: <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	vbabka@suse.cz, harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, 
	andrii@kernel.org, memxor@gmail.com, akpm@linux-foundation.org, 
	peterz@infradead.org, rostedt@goodmis.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3510F10000A
X-Stat-Signature: easyecezm6wai978mjt5dhxw6x1mk8k8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757710996-981766
X-HE-Meta: U2FsdGVkX1/9/jC6llIMONwjx02k25mnOLflEYFVI4s3uKyrw4jByUoSnBL0RbjwV1v4ViHSYzVRUadrgpyqwTbd1LdeIFeth3Y9K0g/MqgEO0VdyeXbZ1IzbSQlwr5vhPmfjp+TcEGcfQ7/1ryxzOAm+XYnI7+8GvlVL+NHKlgJfqhR/qfL31QFAuhGdxk16GsLs6Cl+sBW/AAJJYPOBKc/2gbY/pewpCwU0MiAvd9OxgNk+p2s3t75zsCYvOwcKkl6SnRtDYpJ5UxBkrbchkjncUt12ayr/p9BEMTJJ1htR4k0skPuWQz7H/xnxrLFvtQLXnM+YKiNsEQhzHxwglZwE0LE0TFP+gxpYUxD/l+jcScmMnwsrxo9/5WA9qThc8d+v+9gS2zAqkdYthtMM2GcWZVk4Vqpa22H7t/pZWdFf8TDB6Xzcz89xVsWnO/D5j6eoQoBN0eic/FJteaeOpkZ8EY8A/BHpgO5no3CihF9h1YlKk4tBSkufSItbVxBU4CSHxqegHHZIca1JfMNQyLIusSQCQyjpfiVzSIb4wBtlyJm50/EqmxJO44h57EKHKwTgTz4FuCY5izaJ5rV4blCBwaAHo8uP48f/1Qe6vSvWIbc0rqUYu0HMenPS4kW6K2XaWjUJHMVbrwl+kxn5TuoABtpG4nqic6ZEhVjn1/VdwO1z03UUKCGRIklboKWxJR7cBiEFa3WXhu21az32fs3ymWLQ1i49uVLVWDBjy5O9FhrSzEahFF5kGnIfQJVEtAkID9Mj41SirgXCrHKDYD7tUxh0Lht7f8dnu2B6tom75vPLXWXvvl4wLGJz9K9FWivT4B8HPYTVKcC/N1yFM6M2zRKWfiJWcagKeMTYiyG2fOu9wh+vO3m5NZPFuqfIoF6YFkHzrnYy/gdHpSHF6+IyXcBilvsgAFWmB9S9m9w0GVSSE7caeD4pdZmsgoyr5hLNbO2iT2O46+9oAX
 nhGBjrMg
 t4n0qzbeXOFUvdFhoxsQWiSVvsk3p1ksufX6QPonB7hPz5Aa30ASl5NQEPBAbKzebflkgf5MHjbETVL3OzfAT8mb3Oe+8CzRzDVmMGulkeu/FBDEqrgt/DhaDaRZAtCjKd7liA2x8mF27/ERTJgTbcbnFEmj+PJCDuLc22vtxF3eesFifKVLfoL+RrYZAkMK9VandAJt0iREqT8khroNjVQxeJ3Xka1KhPZJr3NYUzNqplyrdU/fOYR49HcqY5D4VY8qiOrWyqMLSYlxF7hhX0+yjhcqkpI+2hxareKjf7CDuvgHD9w4uHGiHPnJjcLYIUGl6YvAsS4/9GudaXNRdupH5ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> +Suren, Roman
>
> On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Since the combination of valid upper bits in slab->obj_exts with
> > OBJEXTS_ALLOC_FAIL bit can never happen,
> > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic sentinel
> > instead of (1ull << 2) to free up bit 2.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Are we low on bits that we need to do this or is this good to have
> optimization but not required?

That's a good question. After this change MEMCG_DATA_OBJEXTS and
OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
same field (page->memcg_data and slab->obj_exts are aliases). Even if
page_memcg_data_flags can never be used for slab pages I think
overlapping these bits is not a good idea and creates additional
risks. Unless there is a good reason to do this I would advise against
it.

>
> I do have some questions on the state of slab->obj_exts even before this
> patch for Suren, Roman, Vlastimil and others:
>
> Suppose we newly allocate struct slab for a SLAB_ACCOUNT cache and tried
> to allocate obj_exts for it which failed. The kernel will set
> OBJEXTS_ALLOC_FAIL in slab->obj_exts (Note that this can only be set for
> new slab allocation and only for SLAB_ACCOUNT caches i.e. vec allocation
> failure for memory profiling does not set this flag).
>
> Now in the post alloc hook, either through memory profiling or through
> memcg charging, we will try again to allocate the vec and before that we
> will call slab_obj_exts() on the slab which has:
>
>         unsigned long obj_exts =3D READ_ONCE(slab->obj_exts);
>
>         VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS), slab=
_page(slab));
>
> It seems like the above VM_BUG_ON_PAGE() will trigger because obj_exts
> will have OBJEXTS_ALLOC_FAIL but it should not, right? Or am I missing
> something? After the following patch we will aliasing be MEMCG_DATA_OBJEX=
TS
> and OBJEXTS_ALLOC_FAIL and will avoid this trigger though which also
> seems unintended.

You are correct. Current VM_BUG_ON_PAGE() will trigger if
OBJEXTS_ALLOC_FAIL is set and that is wrong. When
alloc_slab_obj_exts() fails to allocate the vector it does
mark_failed_objexts_alloc() and exits without setting
MEMCG_DATA_OBJEXTS (which it would have done if the allocation
succeeded). So, any further calls to slab_obj_exts() will generate a
warning because MEMCG_DATA_OBJEXTS is not set. I believe the proper
fix would not be to set MEMCG_DATA_OBJEXTS along with
OBJEXTS_ALLOC_FAIL because the pointer does not point to a valid
vector but to modify the warning to:

VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
OBJEXTS_ALLOC_FAIL)), slab_page(slab));

IOW, we expect the obj_ext to be either NULL or have either
MEMCG_DATA_OBJEXTS or OBJEXTS_ALLOC_FAIL set.
>
> Next question: OBJEXTS_ALLOC_FAIL is for memory profiling and we never
> set it when memcg is disabled and memory profiling is enabled or even
> with both memcg and memory profiling are enabled but cache does not have
> SLAB_ACCOUNT. This seems unintentional as well, right?

I'm not sure why you think OBJEXTS_ALLOC_FAIL is not set by memory
profiling (independent of CONFIG_MEMCG state).
__alloc_tagging_slab_alloc_hook()->prepare_slab_obj_exts_hook()->alloc_slab=
_obj_exts()
will attempt to allocate the vector and set OBJEXTS_ALLOC_FAIL if that
fails.

>
> Also I think slab_obj_exts() needs to handle OBJEXTS_ALLOC_FAIL explicitl=
y.

Agree, so is my proposal to update the warning sounds right to you?

>
>
> > ---
> >  include/linux/memcontrol.h | 10 ++++++++--
> >  mm/slub.c                  |  2 +-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 785173aa0739..d254c0b96d0d 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -341,17 +341,23 @@ enum page_memcg_data_flags {
> >       __NR_MEMCG_DATA_FLAGS  =3D (1UL << 2),
> >  };
> >
> > +#define __OBJEXTS_ALLOC_FAIL MEMCG_DATA_OBJEXTS
> >  #define __FIRST_OBJEXT_FLAG  __NR_MEMCG_DATA_FLAGS
> >
> >  #else /* CONFIG_MEMCG */
> >
> > +#define __OBJEXTS_ALLOC_FAIL (1UL << 0)
> >  #define __FIRST_OBJEXT_FLAG  (1UL << 0)
> >
> >  #endif /* CONFIG_MEMCG */
> >
> >  enum objext_flags {
> > -     /* slabobj_ext vector failed to allocate */
> > -     OBJEXTS_ALLOC_FAIL =3D __FIRST_OBJEXT_FLAG,
> > +     /*
> > +      * Use bit 0 with zero other bits to signal that slabobj_ext vect=
or
> > +      * failed to allocate. The same bit 0 with valid upper bits means
> > +      * MEMCG_DATA_OBJEXTS.
> > +      */
> > +     OBJEXTS_ALLOC_FAIL =3D __OBJEXTS_ALLOC_FAIL,
> >       /* the next bit after the last actual flag */
> >       __NR_OBJEXTS_FLAGS  =3D (__FIRST_OBJEXT_FLAG << 1),
> >  };
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 212161dc0f29..61841ba72120 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2051,7 +2051,7 @@ static inline void handle_failed_objexts_alloc(un=
signed long obj_exts,
> >        * objects with no tag reference. Mark all references in this
> >        * vector as empty to avoid warnings later on.
> >        */
> > -     if (obj_exts & OBJEXTS_ALLOC_FAIL) {
> > +     if (obj_exts =3D=3D OBJEXTS_ALLOC_FAIL) {
> >               unsigned int i;
> >
> >               for (i =3D 0; i < objects; i++)
> > --
> > 2.47.3
> >

