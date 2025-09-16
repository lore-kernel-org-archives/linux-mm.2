Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD0ACAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE238E0002; Tue, 16 Sep 2025 11:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F018E0001; Tue, 16 Sep 2025 11:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DBC8E0002; Tue, 16 Sep 2025 11:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFD08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:52:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4129F1601FF
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:06 +0000 (UTC)
X-FDA: 83895554652.01.EB69609
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 593301C000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x6xFVGAC;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758037924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+oASOLPx95oNqK0F5924YvyG+WYdsyr2luDMG22ugY=;
	b=eEVy11Iise+d4Wm30pct3+CwXx2fX8XSyNkE9g+tAS5A9xEJOG4wAUFwOaK+KHlz4iT8Do
	llRrjoKnVY16XxGVPvJeeOak/a7pqfIJMhHenOB+tz4rDHjRNO+LlfYntc7NDoioKaXPXu
	Fa+Z9hNCvNDPGyGIpRdV7bxZCrwUh0o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x6xFVGAC;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758037924; a=rsa-sha256;
	cv=none;
	b=M9cJSGv5smONgul2m9Ql1zVhw4MvpHVHW48PA6zxp5DSA0TJB5Ox/V+Pc/6KjjsDwhMUPA
	waSbS8kVAMsFv4mQU3bAGoYE+HKmnZ+pK6Da+KSEu2f/8WmwMb11iJhhMb/fBWcMZfuVOP
	yD8ZUdU8V+378QqAlOlHzj0P1tPFtdc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b4bcb9638aso531211cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758037923; x=1758642723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+oASOLPx95oNqK0F5924YvyG+WYdsyr2luDMG22ugY=;
        b=x6xFVGACwOijY/Irsv7JjmxWPIQPM7huBpC0uHzeyc5SceLXuqRX6knAP2eAWRIw2w
         gpRVHPFXuvf/2WZ+xW/pUOhyUc2KBrAAM9Qic83nToCHJ6S143dwA49OtM3RFXDTiTel
         tpC+oGeJy0wreM3QqGgipETJBrxEDKiLjedVEEhGOFDK4Fo6qut4DjVhKNf2KhBHrF7f
         G7nQoWHzRCv7zpxjAPGPeFNgtyk2msVNFS6QNR0h3fDMwvXfsZA1f73qFYMTHj3o6Jk6
         yVpCFzk4xgOisl3EZO5vHxOsfeh2WzByJ2vgT/v/WqTAPDN9r4+jUS9sVpdSZgCgeAx4
         +Tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758037923; x=1758642723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+oASOLPx95oNqK0F5924YvyG+WYdsyr2luDMG22ugY=;
        b=cmVG0xuQnB7vYpU1g0hKXqMSoRfVhalh/XTTmhWgJ1AgRhRRqhe9j0tHSFkrrt+8NZ
         3pDi7XjiV3FBNiePT01LwnKmZTjN5H04L3Wshdip1RDUssNjlOCHXP+hM6W1CQGBgzua
         mYrd/IA2HDZSMbpAytCIEBdsdkuHCF6DQOxaGsgScXffOxZhbtO3Hrjjoo5YE96w3UKM
         XoISq6/OoO/SDlK5P3IFzhORGxeHP7YiWeF9oAO2zsEprbLi5RnHIKsDwbyFmh+s2yvo
         S9nlXoU4cIbOfC9gS2Kya/ywiYPExZo+SScogPIUv6YRz/0AeWs20ESZltWaHmzWMA0i
         W8FA==
X-Forwarded-Encrypted: i=1; AJvYcCXUrbNBWEnDC9WXPquUfIlUW0XRCSHmoLZ7leHROg+64LSQWX1ZsTGPv93HXTb0tYkIvYkqGnHhrA==@kvack.org
X-Gm-Message-State: AOJu0Yyv5EMgNCmxZncm+pUfajM7jIiM7tsewIWRas5BJZ36fuLfKtzc
	Vn80ThEJazBPqt3NDW1OWIKq7c1hwkv5STel7amsFQ8TAJFAB4zoQvSc7jLQmadzf/xj0EMZMA2
	DqiCRCjKl3xJnfLLAuRcgeWJ7mCsVZr1dZ82uZ5OE
X-Gm-Gg: ASbGnctRlANU9VSHae3WmEOUhD+kcgA6dE+prgeGWKlhxXe/nuPTHXVqMUZlNswYT9W
	smTU4uc4fqNtl7CqwHB/EEq4q1Jeywfmmur0Wqg0zgcsN7bolgijumGOZsslRKYUgmDGez3HDgb
	aANQdq6pKKT8QIRBeGa40W6+cYzJKKkGxGl5eeENYMn/vWTbIpf/5XXPc/IpCnRgWFf56+iPv9+
	KWMo2yQ1JBNadbXFnDtUNP5zt7iEk7KGxMJP2QpboTk
X-Google-Smtp-Source: AGHT+IGQjGkUGRtAuf74uHX8AQBwF11GPpY2256/5dvWRpDeCbKTt5r9xOaAnclS0s+qrjOTODrM7eRbOWkwcSu0DaY=
X-Received: by 2002:a05:622a:1882:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4b7b1cc603emr7225521cf.8.1758037922864; Tue, 16 Sep 2025
 08:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
In-Reply-To: <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 08:51:51 -0700
X-Gm-Features: AS18NWA1aMQcro0nHI_awSa8XDDhwp0fYBTaz-bm5DsoeJH_N8UZACj67AWvxw0
Message-ID: <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 593301C000E
X-Stat-Signature: 5phjmqi33j4en8wzegq9pikdofpf3zx1
X-HE-Tag: 1758037924-191538
X-HE-Meta: U2FsdGVkX18tTlUcoPppTiMP4W0V4Rbz3/X/Fc8G0nxAASI7kd67PGHDX5DlweUqyACOBL9yDnp8Y7bFGnqB/hsVcIH/LeZ+F6QNjTqo5B6a8hhJ8FpphnpKwFgSmBTxsZbvU/pDO+BdZI+A/tnYLkdKpm4kaZ8cXC9lAMx1GXzaadcyybM3V5siEvp90rzuIBY5wMFRQsQFERsRn80s9NfhBcNoSNDOBOqYrdeUDXQlmUHfTSIfYEBQfm2IY3YDBaJqx1UM92/Cj8/md2rH4HK5LZqMGLNpetwGlde4sPGRDO6eBwB0I1kQgjZwZtL3vsYYPR0jwCTZiUTNFAR3MovUGym1VOTxlTWItH/wOu2KERSzTBTS0CGSygWPIn5z4NdswgyY8103kBg10zZgGwSGXpHiipHCZB8GqMAwjRhw5NWFoExw/kz5uGiIWS0EBSF16iKRdazhlCkDSotJlUh+OE9xCIThLHjQNlnywhIZCDK6VfNryjhBQ2Q8Ju2bIsNp0gLEDrLa21pC2iROAPWNu740alVIO6ttSF/zqQqB4kSb+/pAwqMVTDD+SxggahttoL1TMo47vuUnh9feDe1iPQJDXBqaKGhmTvW1mOWYziNRohhv59IVHhXaPk2bPqdIKsTfZWMQNBBQU4PvAm3kpbJqXNRNHylmLKe+LOOBAi2fhAbceGj6QwKtjlgIxushWzf9kTpl5NQC5PYQB4C2PIu4DBMdEHHTDqMnyrGNNeYN7XwmBces6K21s7mPNweSf+iXHCsmHoaAbDnB3ulZNthIk58Oc4ox3BVNYjrKhFUFcMjdXS3VQsyOHG7GVbmUJGz06+ZXSj5vFZyG9vUx4Qn35jYzCfN36psoQgEAEBUMBmJo1FuzChTn2dpfsCI/BvGgWM01WuJkyfUaL/sguvOLx6F3fUuMyTCLsWilG46W9KfDh4UcEMMY1DhC3Wh5IwJ/vuD811pw/QQ
 fDeViAhA
 Rp6U9R2IoainMy5YwqSzUCi5kE48FaRLo8XldLdpJ1762/IgvoOpZ6Jdwn8VVIGS5x3gR7BadzJ7OZi7D8BswfsQd/1u8HBpp1nICZ6PmgU57dj/0FqwZC4okpx3RZB6alYVK6rSexwSFpJhRTQKaOKzNRvjSkDqfizXnsedSgSa2UFc7OHdl1aF2s32GFFNI3OlEbrm9Neb+YUcowotWVW4/lz/TZI9yTulBwVdLhCF6oNjAI5GqKXAbpdpUQSctfpZpb+wYr7pcAahmFMgzaRtvuj3lmfMTyd8HTw7B4J9hbCzADRGn5P6kINTU12J8ODgiR0xSXDMN/nYgJpFFLOGzWt+HWqrv8xIbvdghS+tC5MZBeMn8qDFukg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 5:57=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/16/25 01:02, Suren Baghdasaryan wrote:
> > While rare, memory allocation profiling can contain inaccurate counters
> > if slab object extension vector allocation fails. That allocation might
> > succeed later but prior to that, slab allocations that would have used
> > that object extension vector will not be accounted for. To indicate
> > incorrect counters, "accurate:no" marker is appended to the call site
> > line in the /proc/allocinfo output.
> > Bump up /proc/allocinfo version to reflect the change in the file forma=
t
> > and update documentation.
> >
> > Example output with invalid counters:
> > allocinfo - version: 2.0
> >            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_=
data_nodes
> >            0        0 arch/x86/kernel/alternative.c:2090 func:alternati=
ves_smp_module_add
> >            0        0 arch/x86/kernel/alternative.c:127 func:__its_allo=
c accurate:no
> >            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_=
set
> >            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_re=
alloc
> >            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_en=
able_hybrid_capacity_scale
> >            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:=
init_amd_l3_attrs
> >        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_devi=
ce_create accurate:no
> >        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_ge=
n_pool_create
> >            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thres=
hold_create_device
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: Usama Arif <usamaarif642@gmail.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> With this format you could instead print the accumulated size of allocati=
ons
> that could not allocate their objext (for the given tag). It should be th=
en
> an upper bound of the actual error, because obviously we cannot recognize
> moments where these allocations are freed - so we don't know for which ta=
g
> to decrement. Maybe it could be more useful output than the yes/no
> information, although of course require more storage in struct codetag, s=
o I
> don't know if it's worth it.

Yeah, I'm reluctant to add more fields to the codetag and increase the
overhead until we have a usecases. If that happens and with the new
format we can add something like error_size:<value> to indicate the
amount of the error.

>
> Maybe a global counter of sum size for all these missed objexts could be
> also maintained, and that wouldn't be an upper bound but an actual curren=
t
> error, that is if we can precisely determine that when freeing an object,=
 we
> don't have a tag to decrement because objext allocation had failed on it =
and
> thus that allocation had incremented this global error counter and it's
> correct to decrement it.

That's a good idea and should be doable without too much overhead. Thanks!
For the UAPI... I think for this case IOCTL would work and the use
scenario would be that the user sees the "accurate:no" mark and issues
ioctl command to retrieve this global counter value.
Usama, since you initiated this feature request, do you think such a
counter would be useful?

>
> > ---
> > Changes since v1[1]:
> > - Changed the marker from asterisk to accurate:no pair, per Andrew Mort=
on
> > - Documented /proc/allocinfo v2 format
> > - Update the changelog
> > - Added Acked-by from v2 since the functionality is the same,
> > per Shakeel Butt, Usama Arif and Johannes Weiner
> >
> > [1] https://lore.kernel.org/all/20250909234942.1104356-1-surenb@google.=
com/
> >
> >  Documentation/filesystems/proc.rst |  4 ++++
> >  include/linux/alloc_tag.h          | 12 ++++++++++++
> >  include/linux/codetag.h            |  5 ++++-
> >  lib/alloc_tag.c                    |  4 +++-
> >  mm/slub.c                          |  2 ++
> >  5 files changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesys=
tems/proc.rst
> > index 915a3e44bc12..1776a06571c2 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable mo=
dule) and the function calling
> >  the allocation. The number of bytes allocated and number of calls at e=
ach
> >  location are reported. The first line indicates the version of the fil=
e, the
> >  second line is the header listing fields in the file.
> > +If file version is 2.0 or higher then each line may contain additional
> > +<key>:<value> pairs representing extra information about the call site=
.
> > +For example if the counters are not accurate, the line will be appende=
d with
> > +"accurate:no" pair.
> >
> >  Example output.
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
> > index 79891528e7b6..12ff80bbbd22 100644
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
> > @@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq_buf *out, st=
ruct codetag *ct)
> >
> >       seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
> >       codetag_to_text(out, ct);
> > +     if (unlikely(alloc_tag_is_inaccurate(tag)))
> > +             seq_buf_printf(out, " accurate:no");
> >       seq_buf_putc(out, ' ');
> >       seq_buf_putc(out, '\n');
> >  }
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
>

