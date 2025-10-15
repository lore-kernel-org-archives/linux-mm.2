Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F194ECCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58EAB8E0027; Wed, 15 Oct 2025 08:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566298E0020; Wed, 15 Oct 2025 08:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455618E0027; Wed, 15 Oct 2025 08:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30D7C8E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:37:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECA6B16016C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:37:05 +0000 (UTC)
X-FDA: 84000298410.14.611DE93
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8EB2100009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:37:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MZCuBdEy;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8E+MJevdLFCHBwF7mS7GoEuKQlVbSLU5v6n96OsPT4=;
	b=BCcIW6DL5y3IX4GGzg/074Eo/HXMq+ZKCaKTljn8QwI1ct62tKfu+sIT33y6lhmAKtW6zv
	Y09GT79RlIH/evXatzH+B1x6wG77lsm7vDlbzbZyjlxOsh7X96i9lJGPfBl2KpfrViTibn
	0uzFejLOl7hABIzgrhpZbueZ4TNFVrM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MZCuBdEy;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531824; a=rsa-sha256;
	cv=none;
	b=0RE3c05VBpx6KWZfPILTeUsJiNvIw8MpOHCuKTk0FoRi4aEuwYHbdDQeuTkQtqeVEiXa5O
	CaL8bbIAD6WcpBv1Zy430S4b38hjg9s6O4u/sKPmZL8nkDHIiuVHCnvmmXCRgKP8wThGaW
	GaAKOp6WaHwOr9D9BLlRIlE8nRDVH5E=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b4539dddd99so419974766b.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760531822; x=1761136622; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b8E+MJevdLFCHBwF7mS7GoEuKQlVbSLU5v6n96OsPT4=;
        b=MZCuBdEyuK5bUeGIu4zaKO0nJV8Iu5ZZcEihdWnRfvLUhFoYdb8QZHTO/nwuqevEFj
         0YghPt+kfyTW2gkLfOXNMno2UdKK3SlJ1lBKUjp1VbPEeDwrvFiUNi6fQIqwWvECtSmM
         8Ocl3MPjhs3aJJv5VOU4DjsUySOZifSac9EpjnB/vkFqyyL8HJQ4IBy/RxjuWUI5NvSP
         THA+IOOhLXlhmRI2O/xYwHFavsiHghuPIyOtlHbOgiOl5sqF+rAEnLZAGGMk5ljddmiI
         2cG2V1VgeIo3wu/uTD6dz/1SAWwbDQEvnvMzgHxpu+vbGyhyS6VI8uBeA2Pub2dpB3GN
         FeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760531822; x=1761136622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8E+MJevdLFCHBwF7mS7GoEuKQlVbSLU5v6n96OsPT4=;
        b=e7/owFeKjTv1fxZc+cvNf6Yy3Yypwc9jM1eitmOx9PMGk9AMw2Iz8zGVgHxmD/sf6x
         qV8KkqehDPOd6mNShE6SsxqIvjX7su1N2xZHhEH1hmWBGysPAuF5Dszts/0KLoCdjqrW
         txCTLFM0ol7H+qIVPEPXM9hULzluOlVRkLCmTpg1mMCSvouedYuGEKrZo+qhG6kG6dj6
         L9dfm4UE3/DVHAG3uoC+l+4XXrglo/aKPtLhqsV9dLkB6FKLu3pLzzbRPTmshSiKE+9G
         kuCoYkIgPjhLBVPQy2+gAE4PxzU5GBk/bpVRVNWXTBfWbUovfrMgfLbuSQ6rg02zqMyO
         XT/g==
X-Forwarded-Encrypted: i=1; AJvYcCWdUN1byO+LuxyIhITrlQYqB4uGjne//p+F+p91v4QBpcIGGFYDhOCLHocdLpi2zc8QCugKcnnSEg==@kvack.org
X-Gm-Message-State: AOJu0YyL0JIvbJZZuRob8ejMwANltSD+QwqeSMZ0xP17NZ0A4TS5kI+Q
	GMUzRWiLlTSXR3IIHzESeVyCHarC6q3s0svLpFg2rlpbhJRr8RGwRhYGGE1D0eVwNMiadicsv3+
	sQrcnhSTBG1WtTAWXhg+VHNOdoLdBxI3i9xrWLHjqnQ==
X-Gm-Gg: ASbGncsQ5UWpzvMfTcNnKhsYpHACUvmMiMH/mS68jP0xmczT0BBjYpJGXDQWyHBvFV3
	sAwXD7/NuyVO4K/0QTxYKocLRRDCY+NXp0hk0CfkaE/szEH+7S9cO5HDRngdpJTOpAfgJH7vKtI
	hgXs/OD+YKrsce+7wQMqQFKlKp49r4kf50bvHhNs5Ioa86Hr7TZw0wr+SnXMiL3Xf4SXu++2x/s
	BkMsQISfvrEBz6vYZenP8A=
X-Google-Smtp-Source: AGHT+IEDF7iyIXNjv4yFMv0Mll29DePR8hod/9dF7gMGC5HJnD9K/nVXAKiAd5Z8GOd414WiFCTkFSP/++NSmqR2Z5Y=
X-Received: by 2002:a17:907:7e88:b0:b3f:9e3d:daa4 with SMTP id
 a640c23a62f3a-b50ac9f3424mr2775434166b.65.1760531822098; Wed, 15 Oct 2025
 05:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com> <aO9ZiERHff7vQiBL@kernel.org>
In-Reply-To: <aO9ZiERHff7vQiBL@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 08:36:25 -0400
X-Gm-Features: AS18NWCPb-lo4AJ85wFH4W7tNY7wonucvX9sAJrCA5Y6CElFA6kZge8K_GeLICU
Message-ID: <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8EB2100009
X-Stat-Signature: 3rm3rn98uty9cs9cxby7goywuscroomu
X-Rspam-User: 
X-HE-Tag: 1760531823-90364
X-HE-Meta: U2FsdGVkX18VYpEC2rpigTYnGVAuuCWSnADflYdl4XVuZoGekbPmK4HlmcdevxsQq1HPMLhFPUGmG7RfGNjCATJwFcCIcDd/N6x9FbNYzRhbA23RGRlZKiLaf0xo2taHXrN4S1FShq4s3ZdwQ1v9i7EeBY7SaogPBW6DrIhgE17wvEOokI/foBDmTmtI6XGweb3Je9L4zMKrL2c3vB26PJp40wYyQ19dtDDI6tPidZsVB+kzySGAZGgqLlVXJC5oSa5MVP2MN0ibxxGHmIogMKnLPlwssKjzC02LyYvxPAzsYFqdI5FW0cSgmyNLXcXlyGgSKOsCPajBzpK5BGi9tvkM7KJJmxubBO+Damxv6v+NASlVkOX/2Y+2V1dfjBDeEjSHXsOyvwnHnf8G5DrZBhQWAVWsY0EyPqdyxAwGOFFFHIo6nXk/F1muzMFw+YwepIK7RVGdEFg4gkWJ6csg3aVTGV+WKAVh746O4fTqrpyyCQwcT7tdQPI9vSQ+hFZPgY6qBKxN9igty+2ZuiLQEk9rqC8ZoRsZ0or8Bxd/pPrj+qA38i2XDXtoCr7rEUTUIaIPLxZshzgOhV10BRo417WGZpqpPHoyx8niOp0sc+QAFjtchSydJAfb+lco1S4V6h8hYfbqYlDKxwrxzsVQVYPgL7aKn4tUz3gj2ll/3C5hTHkMLo2Mk9m8ugqPsY5ZlLc1GW0cuvQknitHb7AYjw0PZaxzT06LXlk+bDcQ2w39ixe4zIyPxwZjasMXlLAKH+RroS+IZ963eQFYKouxvczbUxIOHyY7juPG80W2eLeUdkD5qHS/TCGE4W5LLOi77g1e+T0cj53L49/iPMc35YA++GSLSSOdBzNCsagDdO+pjTZGNzljHwHk3eEknvKtKNME+OH+3AALsHLJZjaR9UeqTgf2qUoImLt3SmBrsu4bTyufWpXE8+upGw1gdUmEFJcZYn44+C3WJZ/47Ip
 vUCBscIY
 Bua+Nq6sSyk+D0MAiUgV2ljtvrb9cH1whBOgjNzpmJW+mCGPLPpbI4isgQ9i4zVbPd8U3dIEP0wSuHEmMObCcmJ4kak8x4gPVySQZxzJb6jAPKoEoZFHYqR1mOrVQAog+l6D2mF0atKzt40Z0lEcFPymiFsPIAZQS/y9TFg0H+nz/5MT6N71K3Tiq//if1f/fKsADbkixaC1hCAq31GQUx2KCJEbwN9W9rGf7wQuCK4HbQSnZKkq+n1+jPtmzeDgdBgEO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/Kconfig                   | 15 ++++++++++
>
> Feels like kernel/liveupdate/Makefile change is missing

It's not, we already have KEXEC_HANDOVER_DEBUGFS that pulls in
kexec_handover_debug.c

That debug file contains KHO debugfs and debug code. The debug code
adds KEXEC_HANDOVER_DEBUGFS as a dependency, which I think is
appropriate for a debug build.

However, I do not like ugly ifdefs in .c, so perhaps, we should have two files:
kexec_handover_debugfs.c for debugfs and kexec_handover_debug.c ? What
do you think?

> >  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
> >  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
> >  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
> >  4 files changed, 70 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index 522b9f74d605..d119f4f3f4b1 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
> >         Also, enables inspecting the KHO fdt trees with the debugfs binary
> >         blobs.
> >
> > +config KEXEC_HANDOVER_DEBUG
> > +     bool "Enable Kexec Handover debug checks"
> > +     depends on KEXEC_HANDOVER_DEBUGFS
> > +     help
> > +       This option enables extra sanity checks for the Kexec Handover
> > +       subsystem.
> > +
> > +       These checks verify that neither preserved memory regions nor KHO's
> > +       internal metadata are allocated from within a KHO scratch area.
> > +       An overlap can lead to memory corruption during a subsequent kexec
> > +       operation.
> > +
> > +       If an overlap is detected, the kernel will print a warning and the
> > +       offending operation will fail. This should only be enabled for
> > +       debugging purposes due to runtime overhead.
> >  endmenu
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 5da21f1510cc..ef1e6f7a234b 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
> >       if (!elm)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> > +             kfree(elm);
>
> I think __free() cleanup would be better than this.

Sorry, not sure what do you mean. kfree() is already is in this
function in case of failure.

>
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> >       res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> >       if (xa_is_err(res))
> >               res = ERR_PTR(xa_err(res));
> > @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
> >
> >       chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >       if (!chunk)
> > -             return NULL;
> > +             return ERR_PTR(-ENOMEM);
>
> I don't think it's important to return -errno here, it's not that it's
> called from a syscall and we need to set errno for the userspace.
> BTW, the same applies to xa_load_or_alloc() IMO.

HM, but they are very different errors: ENOMEM, the KHO user can try
again after more memory is available, but the new -EINVAL return from
this function tells the caller that there is something broken in the
system, and using KHO is futile until this bug is fixed.

> > +
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE))) {
> > +             kfree(chunk);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> >       chunk->hdr.order = order;
> >       if (cur_chunk)
> >               KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
> > @@ -379,14 +390,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
> >       struct khoser_mem_chunk *chunk = NULL;
> >       struct kho_mem_phys *physxa;
> >       unsigned long order;
> > +     int ret = -ENOMEM;
> >
> >       xa_for_each(&kho_out->track.orders, order, physxa) {
> >               struct kho_mem_phys_bits *bits;
> >               unsigned long phys;
> >
> >               chunk = new_chunk(chunk, order);
> > -             if (!chunk)
> > +             if (IS_ERR(chunk)) {
> > +                     ret = PTR_ERR(chunk);
>
> ... and indeed, -errno from new_chunk() juts makes things more complex :(
>
> >                       goto err_free;
> > +             }
> >
> >               if (!first_chunk)
> >                       first_chunk = chunk;
> > @@ -396,8 +410,10 @@ static int kho_mem_serialize(struct kho_out *kho_out)
> >
> >                       if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
> >                               chunk = new_chunk(chunk, order);
> > -                             if (!chunk)
> > +                             if (IS_ERR(chunk)) {
> > +                                     ret = PTR_ERR(chunk);
> >                                       goto err_free;
> > +                             }
> >                       }
> >
> >                       elm = &chunk->bitmaps[chunk->hdr.num_elms];
> > @@ -414,7 +430,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
> >
> >  err_free:
> >       kho_mem_ser_free(first_chunk);
> > -     return -ENOMEM;
> > +     return ret;
> >  }
> >
> >  static void __init deserialize_bitmap(unsigned int order,
> > @@ -737,6 +753,9 @@ int kho_preserve_folio(struct folio *folio)
> >       const unsigned int order = folio_order(folio);
> >       struct kho_mem_track *track = &kho_out.track;
> >
> > +     if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
> > +             return -EINVAL;
> > +
> >       return __kho_preserve_order(track, pfn, order);
> >  }
> >  EXPORT_SYMBOL_GPL(kho_preserve_folio);
> > @@ -784,6 +803,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
> >       unsigned long failed_pfn = 0;
> >       int err = 0;
> >
> > +     if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> > +                                     nr_pages << PAGE_SHIFT))) {
> > +             return -EINVAL;
> > +     }
>
> Can't we check this in __kho_preseve_order() and not duplicate the code?

Yes, that is possible, I will move it in the next version.

> > +
> >       while (pfn < end_pfn) {
> >               const unsigned int order =
> >                       min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>
> --
> Sincerely yours,
> Mike.

