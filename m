Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F5FC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED5F6B008A; Fri, 25 Sep 2026 02:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5016B0092; Fri, 25 Sep 2026 02:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DABC6B0093; Fri, 25 Sep 2026 02:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 785E56B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:14:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D76CF14057F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:14:38 +0000 (UTC)
X-FDA: 85251270636.25.66F1FF8
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3568140009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:14:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XPqv/agh";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790316876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB9h9+O7xaQzApg35xo4jfP6YMn41G4cQ0NtyV8KjtE=;
	b=5XPxnU0C9LueaGKpwGi7yKytZQqz7pY1BXqaoEQci1HjQrNWlOgKWaJfuHtdT5toeRxbIq
	jSZLs4wcrD4OTRGZoa2Y9wqnwPpvnX0Ad5UR3pJqSJiKiUekPEsRavpZowyKB4ssIjVpIg
	EwaPMP495ne8WqM2TmvDgkhRiPCwHNg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790316876;
	b=USS21txKawFJNqqpGrXCF6CgP5hcW7UNAXHdCcxAq6NCSvkH3CVZZGbBPVIqpRIJVGchBy
	YNreleq+yh6a57ne8wBR0qtq+cckgUvXnJidP61dRMrH75DDKfiRkkWHW9V+zIho5F6fAA
	JR9587NgxALgLtwmoCEJouAl2RvpbyE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XPqv/agh";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52faa58bff5so179381cf.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:14:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790316876; cv=none;
        d=google.com; s=arc-20260327;
        b=kvwt81AYFj9A7RtAdgRvmEtRCq8lJAfYCSftSlaqwa9YkGQnxVrzUs3CjCoiJtHRj8
         jgaiB22P3NzQ8FEH69Nm+9UcmYlYMckrSSPbAljZeTyLvNwhVnF9fdXq4mu2NYyq+vGi
         Yulf/MWiuba8+6b7fcFDNz/uCvizXi/n4Qh1S3MZzBKCvWTh2+vphLwpmzlOTkhJ5M8L
         rFg5cmdJtLIFm6gnnj/YMq4CJH30xfF0iz5Uz70MmVWdOwh1xX7NO7GRYoEg+mf8ttpf
         iqs8p9Y8EwJ7/INwuwlx1lkgM077aieIm5K3DoxBGdICPGkeIq22yYnRuU+u5uQIyACc
         vnlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dB9h9+O7xaQzApg35xo4jfP6YMn41G4cQ0NtyV8KjtE=;
        fh=dFhRj6eAKo5xo5L0K4Ojow0PW5g5FCZdRlJ966EjFL4=;
        b=Yf70U5AWCQ6Gz+Xvk0KzxAjLaAIo0woejes26bE60XOKjIylVGIxGAqyuQbZFXnRZY
         LbcNgyOEkezydZK5ColbpQD5zhaqMUaRCSL+9PWlwi3LOGRJ5J9khZgohvb7KR3Qlk7W
         WAAFaEBCr3dsMaQQPCD63wji62cusbQQOc7VFjSdWu8vxIr2JZLEZPvTxyLVCtHYi4sD
         1FbvSyIXke9+nv7iUmMn6vtej7lYGfqduIRe6Q/LdMBE31OMoPvWuj2hk7THsc2oc0JU
         oZ6Cl58bSUjaLP+1inMZP4wl5jFVudFitw8MQ0ZnYdbM8kJfDbq3WZkKWPs2ReGWguCU
         16uA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790316876; x=1790921676; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dB9h9+O7xaQzApg35xo4jfP6YMn41G4cQ0NtyV8KjtE=;
        b=XPqv/aghHxYSlTTm275xhZWFLMA8vnremcIlmja85iw6jhbdqaw8Np4K7M54RzoKWp
         0I6gSHoiYHECrm0EqpTtqna2HY45iX8YP7DCvke3NTIw+0lID9+pN2W+TRGiWBZPx704
         ercb1H2Wo1DxN7bZ0eGkDrYPT/hvwrEN4Ct6PEkZUuhem8eEgaugkjdNTl4vWS8Rh0u3
         HR//+1zB0jhZEv+JPDhnr6q0xLu3gjLbN9MOIOZayEwQpjVbauYZKHuJX3zajl6GbbK4
         7bztunFWZq7XRjJ4lV4v75HP6WqSvR5TLmLrEyeMgIvQRpREGYZ2xTK9FK1SLQbBEzLy
         CReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790316876; x=1790921676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dB9h9+O7xaQzApg35xo4jfP6YMn41G4cQ0NtyV8KjtE=;
        b=VAAoSN9c3oifz436xMMgGc/t+IlMJifQYP2ikJpYd+tDVjkteMRk/M9Bov0TuP0J/0
         Nki8juYBSZJrFAbXo4ACx8TT1tx4xhiqPuZtJ/8GvvfXsaWN6R3QWXz0Jfa9ry64Zyxf
         ghSXjO3TK9gmgWkiblmmX/V3YDhYj6IJwg0dIEKuwlVsi0xmdWxSXsUOx1XGceA+kxJI
         zF509vwrZESM2I7Z0uqYmsLlyXuA5iTE4Za8/VXmGnE+3Bn7DhgyKk+0I+Kp5QvW0FL/
         3di/N0/w8KFWcegSf3JhEs3PnuSn9yiBkiM0SeP0yb1yPOwTmjcZdNc/pJGur91xMERQ
         dZVg==
X-Forwarded-Encrypted: i=1; AKwUvBxv8L8SU5PU+CVBEpjvkm6vQhXdLfA8DDSKMUR2WCH7E9+KJ6p8fd12Wwt8K585tQpHqeEfi016pw==@kvack.org
X-Gm-Message-State: AFuF++k7j4eaabtaCFeDwttuABnFxMIhMKFyYCjZhOJQOqKqdBbRu8qW
	bktRPxmwoKr0G0JXj1d+W6hDA4USfyejB5GEF4A/YIXX+1VscamS3pvb/pPMZKGoFU/yVji6NqP
	2rrLVtzP33tP97RjwC3bT0SydVVXIMtB72kSxPQYxR/EUoVgU1EjxpCyW84A=
X-Gm-Gg: AYBFou2YZc2Fck9fuBQGWQyfzh1hc/MCM0QdRQxQv3qGcEXplW4h5WyHToa3pWI+gAW
	6/KAA4hYfn05IQXEdY/TBgc7+YSm9AGLjNXJFgVhLTaiCY0tGkuhM6RvonAbh2af46PRUgSS2FL
	z8Olssc4DBfhOIAsxiX3lYuZ0+6BpIh4S5sa8SQL6rfgw2cESB+nL/uAlxu1VDpXlYx6nuZMPR3
	SoQileIcG/CNtd7tOH8/DD2C1ILIVt18nBFrL/fCScNRK4NSOWZAFedR0n+Cz7+yabEK1a6t37b
	ut8wCPCC9O4GQ5eYpcWJWptRIDrXmTS7emVbM/Zua3m1cIH/p2/2LQ==
X-Received: by 2002:a05:622a:53c5:b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-5330c02f3fcmr4183701cf.14.1790316875026; Thu, 24 Sep 2026
 23:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
 <cb229e38-3e52-4309-9594-0d3947c1a81c@linux.dev>
In-Reply-To: <cb229e38-3e52-4309-9594-0d3947c1a81c@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Sep 2026 23:14:23 -0700
X-Gm-Features: AclHuK_XhdtkT9XgGzeMyyHdkxgqp0XCio74QHugzN47Ep5XxbzMjuhNMUijqKE
Message-ID: <CAJuCfpGZf+HDj8B2vV2WB68P2JMyqctF5CPvV0R6x=WU7+nwvQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3568140009
X-Stat-Signature: bxhzmjwesctqidamoqpdwptipzmfs1u4
X-Rspam-User: 
X-HE-Tag: 1790316876-52120
X-HE-Meta: U2FsdGVkX1/pvHVnjRRGP6W5m5V373eqvJP6RHi2omPu+7lTUzGseGjjyxpup4pkDCRUrKs0fIfapsJbZru8iagT+XrV/ms4P6nVyPk5g74xdwfrzv22PcZNlVHpYjTTOyWfuW3dv/TwafLfxJf1LsxKVo9rZBta1AClPH0SZM19LaowW+v4RGbfumsyLEUjX9V73qt72rCgY8jlSbGabq7NjkYQ4+AEBSpPIk2d1zyDJppJxN0JgTIuFYk1AIkEWTBuvbfyuln0Qm3I6ye1nKmppgQiwdyNvE8bG2Vn2J4a6xCaIYQ0h2Gmt8qCKKkhOl4hscvBFMy0y+DrzPfi7UjOeuFzQ17r+3+5qiI7n+5Eee7L7k5f6nx8E6S60pPxnIeiAPtaJk2xdowhbXkU8c+990PcqiR6rSoIs5r80ZOK5oGgk/e61f7P6JUaUsL6AyNA7TkqUzavOEFE9amwpSsT8txVuno1hiYO562l4Sn3uvsgQvnDiqTkt1v58FAqgZYXjVCTsN91+OSib8m4cfXm+PDN1kfoG6NfEoDrK78+86wcq1dL5rdV/m4iNSyDyu/yJwQjN4NHE0szUn4kJSgDjPlFh+GzHlJl+8eb9fB9lQ7qdtsIP7UtA3OPUjrpmab8BhXA3t9D/qchDX20qti9bFUC3L36fKuWc3BCFkXpNhksJKLzE7CAUSdeZJY01KyBCPf6z9Ntr8dUeuYxXlpUBlKQYZOKWflZ0IJRObjL2NEeaQnru7MsGAljBEEERZfk6z7NqEGza75MTwZ8rm0o8ADqLEECFb21z4lazWj7nDkst6UTBceWHH+geow2xxBqDQcPzrmHQOKmdaDRnsJjeVD9JqmvbP6ru81amD941ZYJaN1YLcuKrUNetWpCOGYSbAmxlrIZCfIcuy9Sg6IO2JZRLO+FtV5WSpf0057u9QgQqgrVFHcBf63miNTsHQ9rB/Oe+BM2rBVvkSw
 RANHH5AW
 hOmg0qtUiiEes2TP5zdyie4G6+67hun8Tac5QOPhLh4yOkUqFpyagUdJb8febA5pLPQR0lYYDQRQMT2VwnZnrLHkdjSLCZJ/ThZT8wP6r1+9sICYfhEZ9OM9XRh3EkkwyaKbWL6KcRfO/BmT+v2I0bw+wPSj4iSvN8MKudnh74Yf6mgAmdRlVDBLV3bd8Pz5y/0BUdkl28sOEXihJxxl01qUOSWhqLXONEAWu9OwVwPw5jWmuszt6CXzUdsC9V8JGoklIMLnsEE8OA18mDKUfC19lYtLvd90f60cn8BxbGksZHxCSKvz69x00AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:21=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
> Sorry, I merged and tested your patches today and found a few details,
> so I've started a separate mail thread for this review.
>
> On 2026/9/22 05:26, Abhishek Bapat wrote:
> > The memory allocation profiling framework intercepts allocations across
> > the core subsystems, but currently lacks runtime tracing hooks for
> > standard observability tools to dynamically track the context (stack
> > traces and lifecycles of the individual memory chunks) of the
> > allocations made.
> >
> > Introduce three standard trace events to allow this tracking:
> >
> > 1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
> >    tools to trigger and capture a call stack.
> > 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
> >    allocation. It records the allocated size, the tag, and the uniquely
> >    generated codetag_ref metadata pointer.
> > 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
> >    freed, yielding the same codetag_ref to allow tracing tools to find
> >    the corresponding allocation.
> >
> > Because the introduced trace events occur at different stages in the
> > call stack, userspace tracing tools must stitch them together to form a
> > complete picture of a buffer's lifetime. Here's an example of how
> > userspace correlates these three events:
> >
> > 1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
> >    keyed by the combination of the current thread's PID and the `tag`.
> > 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
> >    the event and looks up the stack trace cached in step 1. It creates =
a
> >    new active allocation record, mapping the new provided `codetag_ref`
> >    to this cached stack trace and the newly returned allocation size.
> > 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
> >    the same `codetag_ref`. The tool uses this reference to look up the
> >    original allocation record, correlates the free, and safely retires
> >    the tracking entry.
> >
> > Also, introduce `alloc_tag_trace_key` static key to minimize the
> > overhead when no tags are being traced (the usual case). Once tracing
> > for any tag is requested, the key is set, opening the path to check
> > whether tracing is enabled for the current tag.
> > Nore that the mechanism to enabl tag tracing is implemented in the next
> > patch, therefore for now, `alloc_tag_trace_key` stays always unset.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >  MAINTAINERS                      |   1 +
> >  include/linux/alloc_tag.h        |  57 ++++++++++++---
> >  include/trace/events/alloc_tag.h | 122 +++++++++++++++++++++++++++++++
> >  mm/alloc_tag.c                   |  28 +++++++
> >  4 files changed, 196 insertions(+), 12 deletions(-)
> >  create mode 100644 include/trace/events/alloc_tag.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 24420a8c06d0..29e1f7915cb9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17096,6 +17096,7 @@ S:    Maintained
> >  F:   Documentation/mm/allocation-profiling.rst
> >  F:   include/linux/alloc_tag.h
> >  F:   include/linux/pgalloc_tag.h
> > +F:   include/trace/events/alloc_tag.h
> >  F:   include/uapi/linux/alloc_tag.h
> >  F:   mm/alloc_tag.c
> >  F:   tools/testing/selftests/alloc_tag/
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 7f2d80a59792..2994934cf44a 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _share=
d_alloc_tag);
> >  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=
,
> >                       mem_alloc_profiling_key);
> >
> > +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > +
> >  static inline bool mem_alloc_profiling_enabled(void)
> >  {
> >       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_=
DEFAULT,
> >                                  &mem_alloc_profiling_key);
> >  }
> >
> > +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag=
)
> > +{
> > +     return static_branch_unlikely(&alloc_tag_trace_key);
> > +}
> > +
> > +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_ta=
g *tag,
> > +                           size_t bytes);
> > +
> > +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag=
 *tag,
> > +                          size_t bytes);
> > +
> > +void __alloc_tag_trace_hit(struct alloc_tag *tag);
> > +
> > +static inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> > +{
> > +     if (alloc_tag_trace_enabled(tag))
> > +             __alloc_tag_trace_hit(tag);
> > +}
> > +
> >  bool mem_alloc_profiling_permanently_disabled(void);
> >
> >  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_ta=
g *tag)
> > @@ -200,8 +221,13 @@ static inline bool alloc_tag_ref_set(union codetag=
_ref *ref, struct alloc_tag *t
> >
> >  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_=
tag *tag, size_t bytes)
> >  {
> > -     if (likely(alloc_tag_ref_set(ref, tag)))
> > +     if (likely(alloc_tag_ref_set(ref, tag))) {
> >               this_cpu_add(tag->counters->bytes, bytes);
> > +
> > +             if (alloc_tag_trace_enabled(tag))
> > +                     /* Trace successful allocs with their unique ref =
*/
> > +                     alloc_tag_trace_mem_alloc(ref, tag, bytes);
> > +     }
> >  }
> >
> >  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
> > @@ -222,6 +248,10 @@ static inline void alloc_tag_sub(union codetag_ref=
 *ref, size_t bytes)
> >       this_cpu_sub(tag->counters->bytes, bytes);
> >       this_cpu_dec(tag->counters->calls);
> >
> > +     if (alloc_tag_trace_enabled(tag))
> > +             /* Trace frees with their unique ref */
> > +             alloc_tag_trace_mem_free(ref, tag, bytes);
> > +
> >       ref->ct =3D NULL;
> >  }
> >
> > @@ -247,21 +277,24 @@ static inline void alloc_tag_add(union codetag_re=
f *ref, struct alloc_tag *tag,
> >  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)=
 {}
> >  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
> >  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { re=
turn false; }
> > +#define alloc_tag_trace_hit(_tag)    /* NOOP */
>
> I'd prefer we use `do {} while (0)` here, following the same pattern
> as alloc_tag_record.
>
> >  #define alloc_tag_record(p)  do {} while (0)
> >
> >  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >
> > -#define alloc_hooks_tag(_tag, _do_alloc)                             \
> > -({                                                                   \
> > -     typeof(_do_alloc) _res;                                         \
> > -     if (mem_alloc_profiling_enabled()) {                            \
> > -             struct alloc_tag * __maybe_unused _old;                 \
> > -             _old =3D alloc_tag_save(_tag);                           =
 \
> > -             _res =3D _do_alloc;                                      =
 \
> > -             alloc_tag_restore(_tag, _old);                          \
> > -     } else                                                          \
> > -             _res =3D _do_alloc;                                      =
 \
> > -     _res;                                                           \
> > +#define alloc_hooks_tag(_tag, _do_alloc)                              =
       \
> > +({                                                                    =
       \
> > +     typeof(_do_alloc) _res;                                          =
       \
> > +     if (mem_alloc_profiling_enabled()) {                             =
       \
> > +             struct alloc_tag * __maybe_unused _old;                  =
       \
> > +             /* Fired here to cleanly capture the caller's stack trace=
 */    \
> > +             alloc_tag_trace_hit(_tag);                               =
       \
> > +             _old =3D alloc_tag_save(_tag);                           =
         \
> > +             _res =3D _do_alloc;                                      =
         \
> > +             alloc_tag_restore(_tag, _old);                           =
       \
> > +     } else                                                           =
       \
> > +             _res =3D _do_alloc;                                      =
         \
> > +     _res;                                                            =
       \
> >  })
> >
> >  #define alloc_hooks(_do_alloc)                                        =
       \
> > diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/al=
loc_tag.h
> > new file mode 100644
> > index 000000000000..af2182501864
> > --- /dev/null
> > +++ b/include/trace/events/alloc_tag.h
> > @@ -0,0 +1,122 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM alloc_tag
> > +
> > +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_ALLOC_TAG_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +/*
> > + * alloc_tag_hit is generated at the exact allocation call site and ca=
n be
> > + * used to capture a clean stack trace.
> > + *
> > + * To link this stack trace to the actual allocated memory chunk, tool=
s must
> > + * correlate this event with the resulting alloc_tag_mem_alloced event=
. Since
> > + * multiple threads can hit the same tag simultaneously, tools must ma=
tch BOTH
> > + * the `tag` field and the implicitly recorded PID provided by the cor=
e
> > + * tracing subsystem.
> > + */
> > +TRACE_EVENT(alloc_tag_hit,
> > +
> > +     TP_PROTO(struct alloc_tag *tag),
> > +
> > +     TP_ARGS(tag),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(struct alloc_tag *, tag)
> > +             __string(modname, tag->ct.modname ? tag->ct.modname : "NO=
NE")
> > +             __string(filename, tag->ct.filename)
> > +             __string(function, tag->ct.function)
> > +             __field(unsigned int, lineno)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->tag =3D tag;
> > +             __assign_str(modname);
> > +             __assign_str(filename);
> > +             __assign_str(function);
> > +             __entry->lineno =3D tag->ct.lineno;
> > +     ),
> > +
> > +     TP_printk("tag %p, module: %s, filename: %s, function %s, lineno =
%u",
> > +             __entry->tag,
> > +             __get_str(modname),
> > +             __get_str(filename),
> > +             __get_str(function),
> > +             __entry->lineno
> > +     )
> > +);
> >
>
> When I trace an interface provided by a kernel build-in such as shmem,
> this is what I see in the trace:
>
> trig-6838    [004] .....  1309.321906: alloc_tag_hit: tag 000000007874a2c=
9, module: NONE, filename: mm/shmem.c, function shmem_alloc_folio, lineno 2=
138
>
> The module field shows NONE, which looks a bit odd.
>
> > +/*
> > + * alloc_tag_mem_alloced is generated after memory is successfully all=
ocated.
> > + * It captures the exact byte size.
> > + *
> > + * The `ref` pointer identifies the memory chunk for tracking its life=
cycle
> > + * (e.g., matching it with alloc_tag_mem_freed).
> > + *
> > + * Because the kernel isolates active allocations within the task stru=
ct
> > + * (current->alloc_tag), this even will always share the same implicit=
 PID as
> > + * its corresponding alloc_tag_hit event. Tools should use the combina=
tion
> > + * PID + `tag` to correlate them.
> > + */
> > +TRACE_EVENT(alloc_tag_mem_alloced,
> > +
> > +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t by=
tes),
> > +
> > +     TP_ARGS(ref, tag, bytes),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(union codetag_ref *, ref)
> > +             __field(struct alloc_tag *, tag)
> > +             __field(size_t, bytes)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->ref =3D ref;
> > +             __entry->tag =3D tag;
> > +             __entry->bytes =3D bytes;
> > +     ),
> > +
> > +     TP_printk("reference %p, tag %p, bytes %zu",
> > +             __entry->ref,
> > +             __entry->tag,
> > +             __entry->bytes
> > +     )
> > +);
> > +
> > +/*
> > + * alloc_tag_mem_freed event is generated immediately before memory is
> > + * freed. The `ref` pointer matches the one emitted during allocation,
> > + * allowing tools to match it to it's corresponding allocation and
> > + * call stack.
> > + */
>
> But the thread for allocation and free may not be the same.
> For example, memory allocated in thread A could be freed by kswapd.
> In this case, would the ref fail to match and falsely report a memory lea=
k?

No, ref is unique within the system, so even if alloc and free happen
in different threads it still can be used to match them. The
thread+tag is used only when matching alloc_tag_hit with
alloc_tag_mem_alloced because at the time of alloc_tag_hit we don't
yet have the ref.

>
> Thanks
> Best Regards
> Hao
>
> > +TRACE_EVENT(alloc_tag_mem_freed,
> > +
> > +     TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t by=
tes),
> > +
> > +     TP_ARGS(ref, tag, bytes),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(union codetag_ref *, ref)
> > +             __field(struct alloc_tag *, tag)
> > +             __field(size_t, bytes)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->ref =3D ref;
> > +             __entry->tag =3D tag;
> > +             __entry->bytes =3D bytes;
> > +     ),
> > +
> > +     TP_printk("reference %p, tag %p, bytes %zu",
> > +             __entry->ref,
> > +             __entry->tag,
> > +             __entry->bytes
> > +     )
> > +);
> > +
> > +#endif /* _TRACE_ALLOC_TAG_H */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index f30ef8dd24c7..a5339767efd5 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -19,6 +19,9 @@
> >  #include <linux/kmemleak.h>
> >  #include <uapi/linux/alloc_tag.h>
> >
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/alloc_tag.h>
> > +
> >  #include "internal.h"
> >  #include "page_alloc.h"
> >
> > @@ -55,6 +58,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
> >
> >  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> >
> > +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > +EXPORT_SYMBOL(alloc_tag_trace_key);
> > +
> >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> >  unsigned long alloc_tag_ref_mask;
> >  int alloc_tag_ref_offs;
> > @@ -485,6 +491,28 @@ static const struct proc_ops allocinfo_proc_ops =
=3D {
> >  #endif
> >  };
> >
> > +void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > +{
> > +     if (unlikely(!tag))
> > +             return;
> > +     trace_alloc_tag_hit(tag);
> > +}
> > +EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > +
> > +void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_ta=
g *tag,
> > +                           size_t bytes)
> > +{
> > +     trace_alloc_tag_mem_alloced(ref, tag, bytes);
> > +}
> > +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
> > +
> > +void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag=
 *tag,
> > +                          size_t bytes)
> > +{
> > +     trace_alloc_tag_mem_freed(ref, tag, bytes);
> > +}
> > +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
> > +
> >  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, b=
ool can_sleep)
> >  {
> >       struct codetag_iterator iter;

