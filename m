Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A777F606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=KYMUCbYC
Received: by kanga.kvack.org (Postfix)
	id C16936B096D; Thu, 22 Oct 2026 11:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5E86B096E; Thu, 22 Oct 2026 11:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC906B096F; Thu, 22 Oct 2026 11:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 850E26B096D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:25:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC4C240180
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:25:30 +0000 (UTC)
X-FDA: 85350636420.05.B0BB166
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05A354000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:25:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KYMUCbYC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL+EtjTbu4/GOHMbznDDh7H7gtgLjQGYAVh/r05cQNw=;
	b=inJZiVTztQP+WoDexmmGBXYLqLqpEb+fzmsFGlPmVuCh/ZFYFrllYvlUdRhBsPUxt+1N36
	dx5uTJ4jEpkd5oR8t7Va03A8xZEJCPecPl6n3WMfq4giz9zH44rrKwi6LQ5QVLo2+w5xps
	IShliTwTxJBETqAeF3pDwU5lV9yKD8s=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KYMUCbYC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792682729;
	b=rKf5sPJrpbSKMMeDtPNZjte5uETo83Vl8UO5gwFs8k/x3d9fChRBVH5TeibRV3jrh+CvnR
	bO5ztKf8P6F6IzZNJeJBIdSwPA3Ue2vMmi8Pcra8kgxDJj9cMTDTcVtLqBFS2hlQAh1PT6
	yM36OLl32s/lYf8gXJpoltMPo/Ixs8Y=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-533202fe429so433481cf.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792682728; cv=none;
        d=google.com; s=arc-20260327;
        b=MfgrqxEboB9KbdMAPyufdHZazisDdLP1iToVYoqqNdBl+pyh09xAejjGA721dlYOjn
         DXt+SB/jHYsYzFdqQKuxd5JT+ljFW1ct7KVEU4WERFaLZ1x9d/79e7DsZU8Q1QfHJdED
         /+Qk5x0oo00X7thCh79v+BmJVKwSZkqgC11ttqMu7tZPI5vv9TIVEjMOs7VQuNVovorO
         txhh9FfQphJoJa7EKe1QhpHxVlfedREIgk0f47YUDI8rkevZQEJ+8/VAhkzOj5qs826G
         XCqVF79kn1xRi8R1ojVNZCcUSYt1RTGab7Doufrf4b3rteUvmlcAgY8vpPjGBOPdFIi2
         6aHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JL+EtjTbu4/GOHMbznDDh7H7gtgLjQGYAVh/r05cQNw=;
        fh=uzoNWgxdtiuoh6ZUaVqUJotqopWh2prZ2eOmE/Q29/g=;
        b=mJpBdEdhpAKlGFPTaLibGSOgHldaZOdMZYfGaKWLXyau7N1R7s9ijhiioSBVpIa2tW
         tOa3wQuEPdKS+zEJATpNh2FDiqb6yX48u8OeKdcGne8S2Qmi5FtuXNxh80AKKl2tMMF+
         SsGvexKrVfqAJ73dDKC101i716jLGrm+iubsXEE7c2PwBV3Ae0uiz03hZ8SwRcb4JjeN
         4GW8MO8Eg/+yC4sEuNwx0o600VAoDTd56el6NRET5Bjsn35b8KxI4M3y3xMXTEaZReLG
         7QdwdxiLW3KJVFPmDmmkEqD6McrpCkjtVoqagybugUqf9GPA4aOjSRmJvrs5SlwrC2hI
         3k1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792682728; x=1793287528; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JL+EtjTbu4/GOHMbznDDh7H7gtgLjQGYAVh/r05cQNw=;
        b=KYMUCbYC4wQbI5cs5I+l9hvBPZ1kNmqPnubDpYgCfiz6erDPBak8CNBGxTnKWhfhsb
         +Jf0ibhiKoowlwIbQmIbwGXmqlRxGTEqlHmIf1x+viQjnOf1nlwWf3aJ4zFyZMR/hA+F
         yUFVylAmkqPQPA3ZpAWksBcxj+4EIRKunS0pDMgsARuKb2tU8f4POYnLopkiGlfWuzT0
         2ruiYIt9upMKRhLiTH7d997kcpdWVi+s9KPY4nVa/VYZj3CiW4JwMUnBU+lMNznq7uEF
         OWh6O+Bsyb4PFZ862FBUjJYKa+ueY/OHOEtYkFo/ZU71u6vz6zppOrerpi/pHhBlpxQa
         s3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792682728; x=1793287528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JL+EtjTbu4/GOHMbznDDh7H7gtgLjQGYAVh/r05cQNw=;
        b=odvxEQEZlqOS882lezJBPm9uwdiPp3stXAiyK0WJUTOzABVyafILKq6u2yIiXQunzV
         /sobTEmwFGG1hQkjxH3rIllM0yhgXZz860v/SC7Lrp8d1UJzDXXhPeYPeYBpbPKqcrn7
         9UCOEwny67ePIG7dxHQcXKpCnMr0L1WRCJeApHmef2a3m180NVMnBH+ICEn38LL9AD9H
         wfeyhHxrqKiskS84MG+YLZTj8mx0rncOvCMwMmcSCU+Ub101yonsj4XjcbWg5nzkmcin
         aDW5DTe/GuI64C31EMxqnvQCOumxlg0dPvbS1ZXWBwLwMuxJKxdDfirMjokTA5XsbBA2
         rhlQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+suV2ZBGPJ99nSiA1agidvS/K19C17QeXAeEAAIVwLz0kYOc0YXx04dScHLreAGCWTLNm2HXzDw==@kvack.org
X-Gm-Message-State: AFq9FYLQAf8EbooqndvxG6ei1GYTMDSneLcGXup92GdtosvmN0SYUB9e
	MGUlK0gQEHmxivoaplNOsQS8CRZm2fwcvKmqFcXow0N2OlHb0x6++emqFlSZ1VRg6NJWjrQh3K1
	H3cbG5mIobYsMJrayqZih0GEfrRqDFJlT6vqR3BlWABSDHMw6kqA6bKGwE7w=
X-Gm-Gg: AYBFou3mf7YslLjEJ74DFs/qASfjFGGNojAQcyY51YnqcuG46izqV/XPFZzbOjeaGlM
	BBqMrR3fcYVGyv/Nfew8hdu3hkw9QoALE7M2xQ08iN2q5O5bJPBkqlerXVmCpcXTGY+bZhTAe/4
	yIPk0Fl0q9lWrR6t56qypJlodp6uQ/H/OL6VDM/qH4pEOl7Acza0jMy2Ds9fq7/noJs6ovQ1LGV
	IbCYoNsWQEcO/dDnT8n3lmgxfZ8QtnddGR9JkQo1UQyqrtkOsmTrd2QlHlMCQgEiIJHuxYzdOGM
	o3w4GBoAnLXRR/gEZar3cR5VZrSL4kaAwVgnLKsuVDjK0sYnHKTZrR2MC6ePajTiwkqOUB947xn
	Et1x2JNhih4wws/lqIrO3c578K6Z+Bqonn4xTqY9nsVxeouLOAJG1THXKQXJKbnBG
X-Received: by 2002:a05:622a:4c05:b0:536:3d22:fb83 with SMTP id
 d75a77b69052e-536b0673ed7mr17924741cf.13.1792682726982; Thu, 22 Oct 2026
 08:25:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
 <6f243b0d48e541b35e31a49841ea02cb9a328d99.1792439751.git.abhishekbapat@google.com>
 <3df6f0ee-c6ef-4fa4-90d4-bb251cae3e2e@linux.dev>
In-Reply-To: <3df6f0ee-c6ef-4fa4-90d4-bb251cae3e2e@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Oct 2026 15:25:15 +0000
X-Gm-Features: AclHuK9TU-oFOeQlMdOiEny3JKxyZH7hb4P4gGTTA_u83VN8K4GPlXjRLath230
Message-ID: <CAJuCfpFfnGem4ewqzD1XAi07DVOJVe4nDr5_G-sf6Bk2-hArEw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05A354000E
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: afw5ddpq7srm57ffkceewsi1xrhawgk3
X-HE-Tag: 1792682728-106891
X-HE-Meta: U2FsdGVkX19YX9bFcjNmUiAViXDTzg6QoDEdCvTmWyzNxPuia2EO3VhgRRoCvZ7yI04y82HcJ7twCqfTGcm1BqXd4xU9i+U7ZQ3AUuOjziRN2o+0Zb1Yd3r3y5HJ2QMPmaG0XskIYsB0YBxf75HFIwW3kNY4WSej0Pblqu9i5eW6+piqcHp5LDeJprbCcWCU3nAKXlfNKvBr2SiL65a4+tzY9p5+g7eFAlO43HE6gQ5j0kYL8YGyaznhOVVrQqt4d4KSsHxGHwi6ppxntCzznZveboB0wJcVszJrx1cOMQKDPzzWr7RW/BztW8fiwZ/wtnOhqX2sk1wRROWqbqQU084OmmSaIjXJq7qzUdsWME4NVMDkp/XthvTCGStuXTON0ASh+tbbN50HgC5q9x8xIYuXWSuUfGiJMvJLBILERVmaEkk6rt+n1jPcUBPn7ggvMw+AoFZuXVyx0zqiT1uvNbd7g98vmHPTS83Ft+nVfCh4WfpXDujznPrmeORYumEYPx7vgOYE0ZJRKyckzQRWrM515tSEvBE7bGi1676bRhG9s7nT2RsbqYoKslr0woW+9fUIj/XScj8MLYjZQ0ZVha87E8M9jfEKC3BvPRYywojXYsQ42ikYhu44CiD1YgRz16NNpX7o9xZXlSlZrKZ3x21J/5xIBcFvfuZNnC8RO60g3aDB5QsOgKNrkQbqW0kTZ6Gd3mnMTVow1s4mQL6UAwsDvF2XkXMuk9nJJiXh0dMWUODu5MDgQGzcJ/8Dlb5kQL6YfQRbNdTEidTTBSrfQWyNMslOW10w1hNC2UMwgDcrhfXNECgK1KBcbJp+kx2/qS0LkGfHV6iZbBMe2eeQeMGd1R80oluqDBBlKVmzbaI3aJUQz9GX36s8Z9esJjSDDFl6uIx44Fvuv8KRa/8HSwyDLxo6x6dsmDWFWYt6ZvZ0yaLwNj5vcGnhNJDDGI/2T99Du7MQ0GBjfHVkDiE
 4gPWNAvq
 cH5DlkUADvaxIicF7VnendXdyRjsYAwoekgPcMbCbbqeXhxHZq0E/UNFOvx8SOTg/sv4AHQYPXpstsTyE3XFXsWAbofg6emQcPQfDpw6wr72pVpRv4B53nkBORPUc668xLCy8FC4eSDlvsiMrQpBVBYno+keYWBYiNACQ/4l/FQmhjGZbWPcKb+kQ96LQv//dKWFPAutUByLp+klAtqEOliw01g8+6JHS/5LtqrkPsMkGYWgkaQskoTGp+h1bawJ5ssvK9xc+Tm09650XXXZAjFiGZvA3cXRgbmbG0HfG4BzrBt+eyLSgd0anbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:35=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
>
> On 2026/10/20 04:00, Abhishek Bapat wrote:
> > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> > toggle tracing on allocation call sites. Userspace tools can use the
> > existing filtering mechanism to specify the set of tags to toggle
> > tracing for.
> >
> > To facilitate low overhead execution for non-targeted call sites, add a
> > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
> > activation. Protect these conditional branch evaluations using the glob=
al
> > `alloc_tag_trace_key` static branch and an inline static key check
> > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
> > This ensures that the trace events are entirely skipped when no
> > allocation call sites are being actively traced, leaving only a NOP on
> > the allocation fast path.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>
> Acked-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> >  Documentation/mm/allocation-profiling.rst |  20 ++++
> >  include/linux/alloc_tag.h                 |  47 +++++---
> >  include/linux/codetag.h                   |   5 +-
> >  include/uapi/linux/alloc_tag.h            |  13 +++
> >  mm/alloc_tag.c                            | 127 ++++++++++++++++++++--
> >  5 files changed, 186 insertions(+), 26 deletions(-)
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index b241450394df..b855f8ac87fd 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -149,6 +149,26 @@ expose the full call stack and the lifetime of ind=
ividual allocations:
> >  - slab and percpu: the address of the object's `codetag_ref`
> >  - page allocator: the `struct page` pointer of the head page
> >
> > +Events are only emitted for tags that have tracing turned on and while=
 profiling
> > +is enabled. When no tag is traced, the hooks are behind a static branc=
h.
> > +
> > +Enabling Tracing
> > +----------------
> > +
> > +Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE_T=
RACE`
> > +ioctl on `/proc/allocinfo` (requires `CAP_SYS_ADMIN`, returns `-EPERM`
> > +otherwise). It takes the same filter as used by `ALLOCINFO_IOC_GET_AT`=
; an
> > +empty mask selects all tags. Size limits in the filter are checked onc=
e,
> > +against the tag's size at the time of the call. Tags already in the re=
quested
> > +state are skipped and a -ENOENT is returned if no tag matched.
> > +
> > +Tracing is turned off for a module's tags when the module is unloaded.
> > +
> > +Memory allocated before a tag was enabled has no alloc event but will =
still
> > +produce a free event. Likewise, memory alive when tag is disabled will=
 not
> > +produce a free event. Tools should expect unmatched frees after enabli=
ng and
> > +missing frees after disabling.
> > +
> >  Correlating the events
> >  ----------------------
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 0319c2f1e4e2..4e72c96f31ea 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(voi=
d)
> >                                  &mem_alloc_profiling_key);
> >  }
> >
> > -static inline bool alloc_tag_trace_enabled(void)
> > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> >  {
> > -     return static_branch_unlikely(&alloc_tag_trace_key);
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
> > +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag=
)
> > +{
> > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > +             return tag && alloc_tag_is_traced(tag);
> > +     return false;
> >  }
> >
> >  void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
> > @@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_tag *tag);
> >
> >  static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> >  {
> > -     if (alloc_tag_trace_enabled())
> > +     if (alloc_tag_trace_enabled(tag))
> >               __alloc_tag_trace_hit(tag);
> >  }
> >
> > @@ -225,7 +252,7 @@ static inline void alloc_tag_add(union codetag_ref =
*ref, struct alloc_tag *tag,
> >       if (likely(alloc_tag_ref_set(ref, tag))) {
> >               this_cpu_add(tag->counters->bytes, bytes);
> >
> > -             if (alloc_tag_trace_enabled())
> > +             if (alloc_tag_trace_enabled(tag))
> >                       /* Trace successful allocs with their unique ptr =
*/
> >                       alloc_tag_trace_mem_alloc(ptr, tag, bytes);
> >       }
> > @@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union codetag_re=
f *ref, size_t bytes, const voi
> >       this_cpu_sub(tag->counters->bytes, bytes);
> >       this_cpu_dec(tag->counters->calls);
> >
> > -     if (alloc_tag_trace_enabled())
> > +     if (alloc_tag_trace_enabled(tag))
> >               /* Trace frees with their unique ptr */
> >               alloc_tag_trace_mem_free(ptr, tag, bytes);
> >
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
> > index 7d4618bea043..dafcba2f7e2c 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -85,9 +85,20 @@ struct allocinfo_get_at {
> >       struct allocinfo_tag_data data;
> >  };
> >
> > +struct allocinfo_toggle_traces {
> > +     /* inputs */
> > +     /*
> > +      * Tags matching the filter are toggled; an empty mask selects al=
l tags.
> > +      * Size criteria are checked once, against the tag's size at call=
 time.
> > +      */
> > +     struct allocinfo_filter filter;
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
> > @@ -96,5 +107,7 @@ struct allocinfo_get_at {
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
> > index ca2412a67312..9ff9dd04d692 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
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
> > @@ -296,7 +305,7 @@ static bool matches_filter(struct codetag *ct, stru=
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
> > @@ -317,6 +326,23 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter,
> >       return true;
> >  }
> >
> > +/*
> > + * Checks that a user supplied filter only uses known fields and that =
its size
> > + * range, if any, is not inverted.
> > + */
> > +static bool allocinfo_filter_valid(const struct allocinfo_filter *filt=
er)
> > +{
> > +     if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +         (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +         filter->min_size > filter->max_size)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> >  /*
> >   * Seeks the ioctl iterator to the specified 0-indexed tag position, r=
eads its
> >   * profiling data and returns it to userspace.
> > @@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)
> >       if (copy_from_user(&params, arg, sizeof(params)))
> >               return -EFAULT;
> >
> > -     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > -             return -EINVAL;
> > -
> > -     if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > -         (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > -         params.filter.min_size > params.filter.max_size)
> > +     if (!allocinfo_filter_valid(&params.filter))
> >               return -EINVAL;
> >
> >       priv =3D m->private;
> > @@ -443,6 +464,74 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)
> >       return ret;
> >  }
> >
> > +static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
> > +{
> > +     if (enable) {
> > +             if (alloc_tag_is_traced(tag))
> > +                     return;
> > +
> > +             alloc_tag_set_traced(tag);
> > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> > +                     static_branch_enable(&alloc_tag_trace_key);
> > +     } else {
> > +             if (!alloc_tag_is_traced(tag))
> > +                     return;
> > +
> > +             alloc_tag_clear_traced(tag);
> > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > +                     static_branch_disable(&alloc_tag_trace_key);
> > +     }
> > +}
> > +
> > +/*
> > + * Toggles tracing on every allocation tag that matches the user suppl=
ied
> > + * filter. An empty filter mask selects all tags, same as for
> > + * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not a=
n error.
> > + * Requires CAP_SYS_ADMIN.
> > + */
> > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __use=
r *arg)
> > +{
> > +     struct allocinfo_toggle_traces params;
> > +     struct codetag_iterator iter;
> > +     struct codetag *ct;
> > +     struct alloc_tag_counters counters;
> > +     bool fetched_counters;
> > +     int ret =3D 0;
> > +     int matches =3D 0;
> > +
> > +     if (!capable(CAP_SYS_ADMIN))
> > +             return -EPERM;
> > +
> > +     if (copy_from_user(&params, arg, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     if (!allocinfo_filter_valid(&params.filter))
> > +             return -EINVAL;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +
> > +     mutex_lock(&alloc_tag_trace_mutex);
> > +     /* Toggle tracing on all codetags that match */
> > +     while ((ct =3D codetag_next_ct(&iter))) {
> > +             fetched_counters =3D false;
> > +             if (matches_filter(ct, &params.filter, &counters, &fetche=
d_counters)) {
> > +                     matches++;
> > +                     alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!par=
ams.enable);
> > +             }
> > +     }
> > +     mutex_unlock(&alloc_tag_trace_mutex);
> > +
> > +     if (matches =3D=3D 0)
> > +             /* Nothing matched the filter */
> > +             ret =3D -ENOENT;
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
> > @@ -463,6 +552,9 @@ static long allocinfo_ioctl(struct file *file, unsi=
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
> > @@ -492,8 +584,6 @@ static const struct proc_ops allocinfo_proc_ops =3D=
 {
> >
> >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> >  {
> > -     if (unlikely(!tag))
> > -             return;
> >       trace_alloc_tag_hit(tag);
> >  }
> >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > @@ -1031,6 +1121,24 @@ static int load_module(struct module *mod, struc=
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
> > @@ -1357,6 +1465,7 @@ static int __init alloc_tag_init(void)
> >               .alloc_section_mem      =3D reserve_module_tags,
> >               .free_section_mem       =3D release_module_tags,
> >               .module_load            =3D load_module,
> > +             .module_unload          =3D unload_module,
> >               .module_replaced        =3D replace_module,
> >  #endif
> >       };

