Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70705CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 14:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75CC8E000A; Sun, 16 Nov 2025 09:57:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25EF8E0005; Sun, 16 Nov 2025 09:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15648E000A; Sun, 16 Nov 2025 09:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96CE08E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 09:57:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ECE55BE3D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 14:57:46 +0000 (UTC)
X-FDA: 84116774532.11.15864A8
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F1B7180010
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 14:57:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h5hJzOIO;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763305064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/Y2Up6627+KSz5a+6vTFY7dxyvWIBUQP6LhDWx3ZbY=;
	b=it5x2TxNp98nuFTj8MlKZ82ElVNrPHgqo4uhHwy8ijXLpr4Oy+7LHv5fxqFzpmjF/LHEiL
	zmrq5INCcQgxsEwUJDlY6EirFL1InO8YkUJq2di+JI3d5Z6kVqRAEUXtMPAQQ+TAjozXoy
	9SXf//u8P5qqcb1z9nBcsN4/D0pGakk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h5hJzOIO;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763305064; a=rsa-sha256;
	cv=none;
	b=tJSLohzu1KsUf7GS5MACRb+JXmm57vBcPxPvlDdKjkfjx7uvD0b6b0lsQF82bK9sdSE1/M
	7fLs8sZxA1IljZ/Rr4ZRo/Z4EBQpUQFq0UO89SV6PNlKLQfsJrKCHC9V+ZFsKLzcpOWDIk
	jvwJy2jjBrRtuGP8UBnnM/cLgK+/nyY=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso1613829a12.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763305063; x=1763909863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/Y2Up6627+KSz5a+6vTFY7dxyvWIBUQP6LhDWx3ZbY=;
        b=h5hJzOIOfXr/IP2FpBBVnKogU58uZDd85g2OdC8i7dXBf3HwdH3ikJOKvHq227+9LY
         5NGXS94FdSPrqrvpzwNozaGizc+FAssTh94irrrqn/IbJqqzFUbE0jvZk8FDUsFdcALO
         ULK3gzlwVk2fUaKk0PmLUNYfSo3lCyl/FXiIpJf9ZdYN8x5kgHUQOB7CNVzl4/5p3HDe
         M0Ygvd4vgJq5LHW0KJ4DFuK3UdPbMwkwQ+0HQ4m0VijIJ3LYU9GCp5QagVsPhO6LdhEy
         1ZLDcPBJ6HjWXJLlIgDIdom0nRe6AtBq5/yvQglHs6W9fgWp/IghAgLoPPJ9uy/FcG1X
         IFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763305063; x=1763909863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E/Y2Up6627+KSz5a+6vTFY7dxyvWIBUQP6LhDWx3ZbY=;
        b=vV0NPfKJIcJa/ataQ/ARAxONxcGgqMfWkDDELDwWMZ0mKuyOCNIXkM1unD0wpqRUrk
         4hD8wJjFMf4h0rIkGM3vj6L0ujl92twp6xH7EGXIJvwrTarj+B3WPWiLYBhOl46pyHv0
         3CiDbFMcrB3FbFQsydxjOByWe2QfXUyrCySQPAt/h0/BWSYN0Be/U77o87D0YyCvPUVO
         221wnJ11Wf5qduSwjKfMKbO3cEeJVUBvLSVao66yiWHt932nWDeqynAtSyRb8VQHyVhE
         tpZT8m8MXBIRnf0zKbGLa7yDfgSq7RrV2Nlaq1YN/G+wgVvreE7id0Aa/BSkoYok2xX8
         tQDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCs0x0pj5x11qoXea3CiVU0FLhzV+FVDzpH4OjL8vzpjAeJPgAbKfFybGbWDzHUdfxpkZszHaoRQ==@kvack.org
X-Gm-Message-State: AOJu0YwDrsrVZ10AMCepk7dNSbcYAXfeT8U4GIUUGHMWvzoRafL4+4/n
	j9VpNgmUnRa1JHiPPCDpX4gPQQGD03nnaHve9gW1+lKonA1fk5dOTKrMBseMJmBXr6Cz2okLMPW
	PNaVNHn56/q0jeCZeId/ab14cdUv5aul0/41nS/IcgA==
X-Gm-Gg: ASbGncv6a8r7K2aDlzO+OvpREyU4+Xl7io+ywNXnvab7wGz3wQm0DKKkuDK2bk059GA
	WAqfTZhgIH27LHWjwCdh3Xe3lYrUqYN1NoA2wUTEdk51Qw8+pEfCNLieYfHUxrFpUbI/HYNSsQE
	LLFCv50QtHQ8Aucv1Mh6wQt7F8nHgc4OVBaItVEbV2twAuowChVLE1Q63nLzqC+JiX5oFow2S3r
	NkSd+Grou/EJq130oJwHozomZgLCyIelUKqYUV4FW+9rS200LVL71+OIZIAk0/DZ/+mlQxPscU0
	GM2IsD7TeH+O7pjvzj9vscYpWU5f
X-Google-Smtp-Source: AGHT+IFzCTKe+4oomiSL3/XUvnLJJ+h9FkIHFHoxYiYbAnr5wXaa8WsvkSSDNZQRrZhaV59Tuhi0aL3GyuwkRYUtKTg=
X-Received: by 2002:a05:6402:1656:b0:641:1cbe:a5bf with SMTP id
 4fb4d7f45d1cf-64334cf0fd6mr8966314a12.9.1763305062361; Sun, 16 Nov 2025
 06:57:42 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-4-pasha.tatashin@soleen.com> <20251116064918.35549-1-ioworker0@gmail.com>
In-Reply-To: <20251116064918.35549-1-ioworker0@gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 16 Nov 2025 09:57:05 -0500
X-Gm-Features: AWmQ_bknMK8U4gd8bjwM0cRGJKpRjLCOKKOLfwahMDCMf_AdWWN6xXq3RI7dyNo
Message-ID: <CA+CK2bAK6V3iaUr_vRmXiU=7c2HFdBc7Cybj_H7ZDQez-WSSsw@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] kho: Introduce high-level memory allocation API
To: Lance Yang <ioworker0@gmail.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bhe@redhat.com, coxu@redhat.com, 
	dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com, jasonmiu@google.com, 
	kees@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rppt@kernel.org, Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F1B7180010
X-Stat-Signature: 9y1wmcnbhqjhps8bhp3ts9eh5tg6seu7
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763305063-379562
X-HE-Meta: U2FsdGVkX1+ytqvw1Tg5XEkzGNtfzgyYVlAa2mLN+njG6vwWZ2WvOYBihG317nO9tBZUxY8gC0yf3GGDKrj/3M8eusonuOiLsyJ6Cv2QoFCnJLJLNMD2hKD+AyBmk/sktoSZIsd9hDkQlCc3oWYzs7RQGmI4HsLAO5UBNqB3dsadyLZEpwEXsKaCxXIG5/XTbo2WdDLIekDDbUpGJ1QsDXP8zZBoh4Qwaxtq5WACUTMT6xVvutEQ4n6MjHAWkCO1ODa9Ke8eYOOW31Z3UeVFjSFAVoYpqkHYK1XMVPAXBLH01XNlYH0MCiDG2+S1MRe3F4dIKFSvbaSB65WXDkvKRVH7oVy3i04sADpWPXz+Xd6qX8vuUxUcFalPChgQsQR02xG6IGqopgivz7UMpzaUTyjYTBPizxct5jbiC+2kTROIIHNqGiZj5w7pyKR/wkSBPrRJqr9rvuJ1aOShYqggfats3fZ5FpjWg/UJ73uQmNAdwCpR3rLMCfi2H6FQqSjHf0D5BR2kmOtX04KRCIy8Imh9gqyCvD0BbYvgDbxaScoEgOx2Amk5RLzxyCNFZdAtdKVuyT3TlYTs2nsor3zesRouk6mMa2v7HD4JFlOrvfjeCX4fpOHE0X393Q18uUV/1iFsj5ea7lz8ouboZ2zr3PhXZL1LgDwvaO+qXteskybjB6gyIrFoSmZhUr32oSCaKFb1W/RdXjBYtiESbCDvgIyyAeex8cledaNaj5YjO05PO6ufRwdkRbUF6lx4A/cTsTQR0wq3aHCnjaTAU9bTmhpnKZPjFTH3hKIk3d/1XTNMCyUrdBj77gZZt+aom505JaDq/rqh5paoZ8p6x8jt/t/D7Kn+/q4Zj+e/W0KTFMscAXwBB8lgNCJTyH8Hjs1aDx18XpmPcov2HO5O2T9eYCY3uGCnL3ali+lQ6mk0PXyy+oeumXJQKPuqeo92idIydJxoTavSKYG0ZdqtE1y
 YOJ/LTFa
 /GlagxDybNDCbQRGw762Se0t/C2t7XiGun+KyhPzWv194QRkAk5+19BTlkCN7xRdYGE6t4mWQYtW6d6SYwIEOj4k+89n6mcJUk7pvnW6h3ZE2i50M934s64UPXJNpYRnVUBqRAJ7WBYdBmxAd3IwGQUZn9hRGy6A3qwVUftyeuSlMS6kreKfzm5WXEtcVvBq5iuffUbEUHNkEMWKh7p7GrWQMhx4U8MGLKr9feJgozAUD4PQcn0lVdrsi7oWWoo3u/+8spCsDIczugIr1mnixYqxciqf3OOqfvuC8j6UrXv41V+WlIy34rMCgbyMJsK0L7ZIZLI91gAO9nClTWQJZQmqopmbxPaFLIUw5t0FEI4bFpV4Y1zlSjx/sLDbEm3XPBWkB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 1:49=E2=80=AFAM Lance Yang <ioworker0@gmail.com> wr=
ote:
>
> From: Lance Yang <lance.yang@linux.dev>
>
>
> On Fri, 14 Nov 2025 13:59:52 -0500, Pasha Tatashin wrote:
> > Currently, clients of KHO must manually allocate memory (e.g., via
> > alloc_pages), calculate the page order, and explicitly call
> > kho_preserve_folio(). Similarly, cleanup requires separate calls to
> > unpreserve and free the memory.
> >
> > Introduce a high-level API to streamline this common pattern:
> >
> > - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
> >   memory and immediately marks it for preservation.
> > - kho_unpreserve_free(ptr): Unpreserves and frees the memory
> >   in the current kernel.
> > - kho_restore_free(ptr): Restores the struct page state of
> >   preserved memory in the new kernel and immediately frees it to the
> >   page allocator.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/kexec_handover.h     | 22 +++++---
> >  kernel/liveupdate/kexec_handover.c | 87 ++++++++++++++++++++++++++++++
> >  2 files changed, 102 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_hando=
ver.h
> > index 80ece4232617..38a9487a1a00 100644
> > --- a/include/linux/kexec_handover.h
> > +++ b/include/linux/kexec_handover.h
> > @@ -2,8 +2,9 @@
> >  #ifndef LINUX_KEXEC_HANDOVER_H
> >  #define LINUX_KEXEC_HANDOVER_H
> >
> > -#include <linux/types.h>
> > +#include <linux/err.h>
> >  #include <linux/errno.h>
> > +#include <linux/types.h>
> >
> >  struct kho_scratch {
> >       phys_addr_t addr;
> > @@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page, unsigned in=
t nr_pages);
> >  int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
> >  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
> >  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
> > +void *kho_alloc_preserve(size_t size);
> > +void kho_unpreserve_free(void *mem);
> > +void kho_restore_free(void *mem);
> >  struct folio *kho_restore_folio(phys_addr_t phys);
> >  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages=
);
> >  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> > @@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc(struct kh=
o_vmalloc *preservation)
> >       return -EOPNOTSUPP;
> >  }
> >
> > +void *kho_alloc_preserve(size_t size)
> > +{
> > +     return ERR_PTR(-EOPNOTSUPP);
> > +}
> > +
> > +void kho_unpreserve_free(void *mem) { }
> > +void kho_restore_free(void *mem) { }
>
> The compile is unhapply here when CONFIG_KEXEC_HANDOVER is not set ...

Thank you, Andrew already applied a fix:
https://lore.kernel.org/all/CA+CK2bBgXDhrHwTVgxrw7YTQ-0=3DLgW0t66CwPCgG=3DC=
85ftz4zw@mail.gmail.com/T/#u

>
> ```
> ld: arch/x86/realmode/rm/video-mode.o: in function `kho_alloc_preserve':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/real=
mode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./in=
clude/linux/kexec_handover.h:102: first defined here
> ld: arch/x86/realmode/rm/video-mode.o: in function `kho_unpreserve_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/rea=
lmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./i=
nclude/linux/kexec_handover.h:104: first defined here
> ld: arch/x86/realmode/rm/video-mode.o: in function `kho_restore_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmo=
de/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./incl=
ude/linux/kexec_handover.h:105: first defined here
> ld: arch/x86/realmode/rm/regs.o: in function `kho_alloc_preserve':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/=
regs.c:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/=
rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include=
/linux/kexec_handover.h:102: first defined here
> ld: arch/x86/realmode/rm/regs.o: in function `kho_unpreserve_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/=
regs.c:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode=
/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./includ=
e/linux/kexec_handover.h:104: first defined here
> ld: arch/x86/realmode/rm/regs.o: in function `kho_restore_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/=
regs.c:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm=
/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/l=
inux/kexec_handover.h:105: first defined here
> ld: arch/x86/realmode/rm/video-vga.o: in function `kho_alloc_preserve':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/real=
mode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./in=
clude/linux/kexec_handover.h:102: first defined here
> ld: arch/x86/realmode/rm/video-vga.o: in function `kho_unpreserve_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/rea=
lmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./i=
nclude/linux/kexec_handover.h:104: first defined here
> ld: arch/x86/realmode/rm/video-vga.o: in function `kho_restore_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmo=
de/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./incl=
ude/linux/kexec_handover.h:105: first defined here
> ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_alloc_preserve':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/real=
mode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./in=
clude/linux/kexec_handover.h:102: first defined here
> ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_unpreserve_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/rea=
lmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./i=
nclude/linux/kexec_handover.h:104: first defined here
> ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_restore_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmo=
de/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./incl=
ude/linux/kexec_handover.h:105: first defined here
> ld: arch/x86/realmode/rm/video-bios.o: in function `kho_alloc_preserve':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/real=
mode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./in=
clude/linux/kexec_handover.h:102: first defined here
> ld: arch/x86/realmode/rm/video-bios.o: in function `kho_unpreserve_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/rea=
lmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./i=
nclude/linux/kexec_handover.h:104: first defined here
> ld: arch/x86/realmode/rm/video-bios.o: in function `kho_restore_free':
> /home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec=
_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmo=
de/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./incl=
ude/linux/kexec_handover.h:105: first defined here
> make[5]: *** [arch/x86/realmode/rm/Makefile:49: arch/x86/realmode/rm/real=
mode.elf] Error 1
> make[4]: *** [arch/x86/realmode/Makefile:22: arch/x86/realmode/rm/realmod=
e.bin] Error 2
> make[3]: *** [scripts/Makefile.build:556: arch/x86/realmode] Error 2
> ```
>
> Perhaps these stubs should be declared as static inline? That should make
> the compiler happy and resolve the linking errors :)
>
> ----8<----
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handove=
r.h
> index 6dd0dcdf0ec1..5f7b9de97e8d 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -96,13 +96,13 @@ static inline int kho_preserve_vmalloc(void *ptr,
>
>  static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservati=
on) { }
>
> -void *kho_alloc_preserve(size_t size)
> +static inline void *kho_alloc_preserve(size_t size)
>  {
>         return ERR_PTR(-EOPNOTSUPP);
>  }
>
> -void kho_unpreserve_free(void *mem) { }
> -void kho_restore_free(void *mem) { }
> +static inline void kho_unpreserve_free(void *mem) { }
> +static inline void kho_restore_free(void *mem) { }
>
>  static inline struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> ---
>
> [...]
>
> Cheers,
> Lance

