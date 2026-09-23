Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4B2C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46C46B0088; Wed, 23 Sep 2026 16:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0ED6B0093; Wed, 23 Sep 2026 16:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71516B0095; Wed, 23 Sep 2026 16:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79B2B6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:13:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F21DEA0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:13:01 +0000 (UTC)
X-FDA: 85246125762.09.8B17E8F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC2F020002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:12:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sc72U0cP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790194380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/Qf9KIEloyGlc9WNysMiio4j06l4Rvqcqlp89ks3rI=;
	b=Kx7OiMCjMphcZ5vhsNy6ucXSNYF44FOaOOGOl5MQi/abcL8775YyLLNg1xcPClSh4frFdl
	wrV1SJGCAUo/nhTWZjz8m5jfBRRRp3YsVCtN2d8L7cYsEDFam1T0YJ1mmKR5z4N2BsBi5A
	0B1GWLBHBveRywS8SZfbmrhtxOzR7vc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sc72U0cP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790194380;
	b=TFgS0b0eN5ApLac7paeD2KK4zTNhjEGPZ9Fv/5avs7Cd7C4CPek9weCTCMdCEYJ8wRAZ0J
	h/86y+FBv1sBWZoT+EpkZe1moYRm6jrPMDA/EXDRaL347rpIBRFD+w04M9tCj6YQg8gNqN
	2i6unzvvO9xB5rJrMAhos/LX4gBDtqo=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so3415ad.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790194379; cv=none;
        d=google.com; s=arc-20260327;
        b=Y9bpjbNSz/XcqO1Y++V17b/kjVNqJljTvmxQO0EmrH0YokGn0kWixkK7LHEvIRpRyb
         UM0tZ7h4i6We6AJix/z9EFKCBZ9aRA/zU11HvhgC8J7V/S9LKyF3xXuYnEttJ1ycz46x
         qbXK0Q4CaiLpR7rXEL+8DCf7q8No4BKds1lpp9R8lwAgBRgbztJg/t0hk0QAo3U98yGo
         g88DTVbOGhRSRGBvkK3aAaMyO/VqVY2ahy3fs4zNlNlUOcOh+6SVbc0sk6KuUqasMiBQ
         vVUJRY7dJ9JaBrlua73eGobFenZ3UV5EpBznW3zcrkPtfMGIuPBPX/JnBHek5c0u0KzS
         FE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/Qf9KIEloyGlc9WNysMiio4j06l4Rvqcqlp89ks3rI=;
        fh=G9V48ANeFMzbnVSWkiDfFxVHdcR2YgkILUbH4ZTqctc=;
        b=hr3+ROgy6Jlh1vuyiFO/TkZco7sCwZNp95sA1lZtrQCMGR+due9MEDHkNr3s/wyJuX
         NFPoGj1vOAz14SP9fBCNlmgIOlFwna91zUao/b106HU+Yzd4KEidTgyX+/g9DKBvoaZA
         4zVTZ/kNjdhzdbCx35UXBEp4dF3rKybyDYPKaUTU8Jbb+899Zk3X02hz2HCfMS9PqnOj
         L1g1hV7jDG5VieOf/GUzwESO8f0nIOKhuNNy40uv3+2Gn+khJvdT9zJeI2mSxq0E1xXv
         9IYwk+XdO/GW2Et7a/7YpbaBRar4tr3ed4tpRVmPkP6sxwdbEPE5KIWe9ZnyrxSztLK9
         K4CQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790194379; x=1790799179; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/Qf9KIEloyGlc9WNysMiio4j06l4Rvqcqlp89ks3rI=;
        b=Sc72U0cPNIpt8Uqh75+rSaV8SkgUhn2mARt79Woy5cZliEXX1oa3H6/7621eZ6yHPX
         tSCEdykg72IwYzSkJ4YxNdBZbBqXQx2yBSwEp0+G7CsutTp6E734Ruwy4VVIMTCqZV49
         cwBJMBvivCcRa2NAjqKXv+vIWa3jZfZKu+/lmAgaJqHKxylnsOeP9PM5a9qjnpaayZyG
         I4KENx/qcf7qxcAr/ejNBTvipJ8BRCh1viSAD6WG7YYPsNbF3UGya7ykmK87JuH/YAlb
         gnixaNultaf6bCl4EOsu+E8wa0vXoM3qQLX0l3yd5oO8+sy7EWMjnRJ4nTTHG0Ezxto2
         DX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790194379; x=1790799179;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/Qf9KIEloyGlc9WNysMiio4j06l4Rvqcqlp89ks3rI=;
        b=A4OsZZtCLW1dBHbhqQubivq8BRwA3ZS4OLiaW2A7Y02LpjMF+zGDzk0KBLicSLuP9a
         umIPU1Iz9QzhldMgxhFvIxbwPOB7wOSIwx0hgPhaIYL/D4wBx4kDMf3c+P21qXQMfTb2
         AjkU/nSN2pi9CgVUfj2oKfQ2F9WuyuSjC+q2qntfp7IoyqtEFBLTdoxg/izW95L54CdZ
         GJPJJ5xKNwyEiHThGRuznmnoy8duE1lTpakxRz0+tqLVfhwrCZSE9irWE7gLBeT9Ska2
         5UQZsXoo20TBMRsGMVCx+XH1yQOGR1Xdypzn/PvFyGJr8jhkUzjn4HPBLJ2FKiGgkP/s
         k0lQ==
X-Forwarded-Encrypted: i=1; AKwUvBykol7zcvxgM47ic0By4dci82QTym8Hh/SPYAW2LbXbbaljurbyKOFoXcDKE3DRyK8pOIuO8iXjHw==@kvack.org
X-Gm-Message-State: AFuF++mHu6aPxV9gvwB4CpMKBhrLPTdbwxN0i4a+9WUDbPs8PzIlk4FS
	gvXh5XAab9iDuTWsaw/a5KHVSnCd+qcofoPN36leRxAARueAh2aWHmOdN9ckeMUG56YJTOcvAZJ
	yYf8QbptlZHLhaWgFi1PYa+TY+Buruzu/LQA6kHO0
X-Gm-Gg: AYBFou1hb0dLystLbMjLVoNgT9HAgBM26qeCqmpbMTUNoFkOj5QDhEdL8SnSXS2dMEi
	J1svSyawHStg23V4So4qJtGkvND2prnrFAq6JCjdOBwPIuMGLdsSrmj+0TnBcNaccLA1rlSguiI
	LRLdsgEhIEFwyt+XRv9q0ugLgrc0XINKcmNqQDDUZM7INBg9bqTkssmj/eJxdCGN6YsQDfXUEv3
	akkd1JNcIvHfn2OO9Gaxfg2e0qvwuQKguufcrwqxE1ahCmLhT1rqWRyghvXnhmladctx+vgQnI9
	RyVphriUpkOUVMPt+ggHfMYcaynkscGM8b2rfVnIY8bW0x6FEGmsCirf4cUaqJ7Twb48TQNRtWA
	oqv6oqZeS
X-Received: by 2002:a17:903:90d:b0:2ca:4bb4:4bd with SMTP id
 d9443c01a7336-2df7bbd799fmr1410675ad.5.1790194377700; Wed, 23 Sep 2026
 13:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
 <e8f65e6d-440b-418d-b7ba-e05ca2b0d712@linux.dev>
In-Reply-To: <e8f65e6d-440b-418d-b7ba-e05ca2b0d712@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 23 Sep 2026 13:12:46 -0700
X-Gm-Features: AclHuK90u3QKMhLOPT-K2l4GMYlhS4sfA0uEIsFHML1VSEDfbP-0xqaYfivaip4
Message-ID: <CAL41Mv7P3xDAvTGtdSHEG3Cvu70W6uhZ9mThm-OD3PcGDDU17w@mail.gmail.com>
Subject: Re: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ktuwfnfw9d95mutduc4o44zb3ifn98y6
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC2F020002
X-HE-Tag: 1790194379-147078
X-HE-Meta: U2FsdGVkX1/QHFH0+QMiZRz/M5qDNFGCjbn+jJZ2SGWF5YZ95G6xxaZokLdHca/3Ia39J7PBEUqi8qckq0eITw0rVn/a52EBv6fHoHV0OddjPVKES1HLR+IEk1yO8NFeDedJPS1zIH6l1pGlQqu+LC3+4FmPYG5eH17zvYKiKp5VeVayl24PZG3xachp6jCAB13/vFXXBFoQaZLj3mojNJhVwytjBn4iYeu7GRtA593F0CKFeaXJGio8LalYRozaa+wmqm77CKBeSv0bPl4Qick1eve9u8SoNBveD9h7p7d3dnINt7Kp9zSNUryeD3hpyMUUnF+X0Y4nZtHW8eWh9ztHKlpioJk+WDmB03omdyhok5L7kQ/0G8gBT8AzbOpYKkDCTDEeSbuwseCSy8Q3W3D9AkNXixOpdFcgLhXq6Diy7gQlxw2+U5D53/TiKlIQlis50Io9tqOX6b5MrkIErvAIKNaPNNxNg9iW1Whz3Jaen+LK+cGpIizb52ZPLIiR1QBt0liNGf2XRkjIqoB+wCu13TylU6jU/R3aNkDuSIbIN4Z/HAo/nzuINZxbPeYVMZlhd/R9LOvwVTZfQa5ItBsWECw/E/uf+2LjmWR7g1GKN9L/KzCAb2UHQMjUI9cW0pLOV9k1lKxUxR8KchClJqU/IhvUYXl5/9HigVKc2JTZAXTbLtPeSyJiolInokJi7yj5iXQfKDT9IY1s6f3/HW/X6kcd0oXPQFyUD9o6fhvZyCFJ0qzjbLPVCJhAkK4uFJgs+fsQ05U4qYC+mU1jTENpJwPBtl54uLNF9dOy3oxEBWT3dhDgYRvUsmxBLJ6EWsYyFSr3nMcX0Uo4ELiHQPiWYnelxX8u2VAXqDWWD+0ewPv4mVq22u2kZ4QBKxQJmj34jkwaqB93grM9ig3zBT9F3f8GgRXfHUPMgdvT2xWtlQzDVtfnfoIh1C+ymVkH3TfsbPyCpBg1Z40F1d0
 IIlfj/0y
 7UEOjUXB4t+a4Ahca7TzIZEutBEKWmCVVlVK3fLx3pKfLVdm5SQcKBdU8Ojlp32lS+3VJaeS8b20HaMrEAvEvSjaFHoQqvAwgXwQXBoyiVZT9hiX3dqmTLIYDPumkddlBRhjc5YXSzIrYzJ+Xl5tWY19HVkZ9hLjr9ucJMC1NhqL+t4UV1MuntYEfd/bDh7N/ihU/QjkR+uQ9l8YBsI9QNpi87qYnZ5JNetda6ATRW7Vn6Q9Pw6PDZ7MjKkxvtYc+9KB+1iFSnmzGG9lPsJzxDutT1DucUd5JeDwjsnOWE+uG4lY0XTpNwPhU7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:55=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
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
>
> nit: s/Nore/Note/ s/enabl/enable
>
Ack.
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
>
> The tag parameter is unused here. Let's remove it for now and add it back=
 when needed,
> to avoid the -Wno=E2=80=91unused=E2=80=91parameter warning.
> Some CI bots go through each patch one=E2=80=91by=E2=80=91one, so we can'=
t leave warnings in
> intermediate commits.
>
Ack.
> One other thought: what about adding a sysctl knob here?
> It would let users grab all alloc=E2=80=91tag tracked allocations within =
a time window?
>
You mean to enable the static key? With the following patches, it
would mean that the state of the static key would change by writing to
sysctl and through IOCTLs. I am not sure if letting the static key be
controlled by two mechanism is a good idea. I'd like to get Suren's
thoughts on this.

> Thanks
> Best Regards
> Hao
>
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
> > +
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

