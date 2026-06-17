Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E03CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFAC6B0005; Wed, 17 Jun 2026 11:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0A46B0088; Wed, 17 Jun 2026 11:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FC56B008C; Wed, 17 Jun 2026 11:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDE126B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:50:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72B301C28C0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:50:41 +0000 (UTC)
X-FDA: 84889842282.17.1FCD8D2
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6157940004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:50:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SBA/NUXz";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781711439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2XlCYjewXLXohjTYJgQoPMKwrnL1SAoj3hukwrmx54=;
	b=J4LOCrew9oF8zsu2nMr+bIJBy3jEXij34KZPIIjXkXbV7bR4GZDZ6rE1bRBeIzUloYQV90
	dS1BkMFxVnMZU0bpDaiSg+XuGhTO6ZcuMtlc/kOYAURKMxSdJ+pXt0rgKywHM8VOqyFPqd
	dg+xeW0WfNdmqCdOcgzGSP8VY4OD5KM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SBA/NUXz";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781711439;
	b=qwUY8shdR/uN733F+AGA8kJOQnGKM4lIvTueH57kRxmTJnClfFD2N/T8idaxa20jRlSI0E
	t9AwpxsxnKzY4bTGLqLNkOIzbe31PFtDkjP/EVP/29JhIXIx05YVftWo0pAgAorQFFpRBn
	KhPLx3E+1cLlKWjHGlj2aPhA2GG9Mho=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765331535so296241cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:50:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781711438; cv=none;
        d=google.com; s=arc-20240605;
        b=UMNNS1fGZYbnihKZEXIRMjx97Cj/fMk5QVebxBWujvRTuIuWRUokwIfMOIrNd1zAF2
         D9scprs7qzs6fROjgsdPuRoVyaQ+ZhS8K+BOjv5DndsViIXnm/yBhMkFTsFcLvFCsWJy
         dX6t+i6T6OpWSOg4uqhF33J0qp/6wLYeKnRN8YlB47/XnYbL9O6fcH6RZcFnyTiE58Gp
         Ou8lEv24SSXRhM6DqeBPJnN3xtrK/gbG6MxHZbybEkyD/7H8aX3+O7VQ7ZCSWvi3KZg7
         QSgGGE6A1s+kv5GZkpL49H71tWbiOH31EV+NVw6EtkAbSbwySwCI673GBboPGKtL6Emi
         +Nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T2XlCYjewXLXohjTYJgQoPMKwrnL1SAoj3hukwrmx54=;
        fh=3nGIuVSSLEO0qWcdDos5z3u0R2DO8wl+9lLjFjvbtlk=;
        b=kzrbyWSRxDMJYwT0G/Qe5uvvY/QWkdStFLxVHgkdE8mO3PZzQpTptdJP3UYWqZkhwl
         0opWN3yn0D5PoG4kM71n64Ari/x14Ac9g5rNoOc+gatrMLPfYfN1Kab4LTphRbPo7EGs
         4P0Gcs6D/hcEc4b1D/cOqOrY8rt92W4g81CRezzUukeaNLMvwD0C1KppAerGy42iT4b9
         QPE3aMN8FNFJoesgtKE0HiD2hLlCo/MqbDPkJ+OqnVfusL7CXoDRQp2JKDDzmp9uQLRM
         o0h/p6U8hE/ltHHrq/LZWeIbmQnm3An86JXWUzaS8iJG7GI0WjLeaElJF/vCHAMvQF3/
         StCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781711438; x=1782316238; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T2XlCYjewXLXohjTYJgQoPMKwrnL1SAoj3hukwrmx54=;
        b=SBA/NUXzJO+GNdi8kqMNRLEQocvz2bkxRy+u0IxzVeunAf4bDp31ybhSim6EomN9tb
         O068qjUheoFFehfIJCzxIrn+g45nDjdXGcrghrCsysYxyzMgsjQFnVYmoQ6RqCJm0WvX
         UMu6J/9D/z6Me2MJt5A0CZJUN1uPO/5tglLlT0egKKOH0a40YA0WmSdB6PKKNkQCo3+f
         pfEhqlipVd3qW55cZxOvP3Ro48pR81rkr+ZF9u8y9/5Q3oM5E028sP1B9lLd1+m+yoRL
         tbM31Qu72hlxXMc7xplRJUlv5kuccg5ia6RMtCe6qTpqLXl6SpBcrA22z0BAlhyXQOgl
         gvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711438; x=1782316238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T2XlCYjewXLXohjTYJgQoPMKwrnL1SAoj3hukwrmx54=;
        b=REvBNcXCtYdduAJyYTi63NaICuBe4oFVgplJWEbqMHocGkGis6WqB7DPHO/TDVzKQA
         YAdE3PJC2WiCNP1dwNn3nktXapZtxiR00iOeFxEZGOFazrK1WUBLCixHk8Kk91mlgUgX
         s7mjlS+oSFuJCy000bMokBVOvXSs+aHH3X6pfMokEJ9CyB1P0n68l1AI3HT/X+V2tSbV
         Fj/gw04pqVkGoAoUeiCiLV9hndKL8Gb/73ru+jvxMhzO3MgNrcz9ZHnMYde4l7TmktbX
         d590r6HgiBV9MZR05qwP0ZtzXC+JhvwdNnn1jj6nyg2Pn2Nyct+UQgAP+7o+CH6j1Tky
         4JxQ==
X-Forwarded-Encrypted: i=1; AFNElJ96kjG5YCC0MHoUmpTLNWgdzWvr81lEh/zUiyYGqHt+csHeiIUHayi/0QYwfa5nyYGEf3E/LjNPDQ==@kvack.org
X-Gm-Message-State: AOJu0YwV0RHVjZSswRLw7+IYEka8qSvyX2s+1j7qWo/de5X9pul0Enm+
	Cwo2oPc4B1mYLa8XEWQ0x7BN+hMqmgh4Z1y1W2TgogwLw+/PUAdOblZdeeD7M/Xiu4pup/mXzHT
	e2ejCUebLpwskYYFrEUZlPwe0CDCIKZsPePpnjPum
X-Gm-Gg: Acq92OH/6NsQfXcTndNu8DeT4olQr04eJD6EAa+gFayNC/wKLvLNZP8GMrdh6NIPcnZ
	OxHviYUKvC1cAfGZi1xz0+8nxtZPJgxNxxK8nZ+Q1cbUdmt4NZOoFS1v8ZfpYVQ31BxRK8ovNbF
	gVlKrWjbxeCfBXD5VOuhFFGvsPr39kJWDsFl0OHH1CF9lgE+f+XL0UdoVfxl92c9VVUISGCOVDJ
	95Fqvdy3SCamaL8B1qoVpqM/eeOTin/bbCb+M9YEbX5aOTQPLZqEOy6kkQ9DPdymBh7Qt4/UBKE
	gcPiNlBrghMvtPx7e/tcSTSy+SqwSFnLSYJupg==
X-Received: by 2002:ac8:5916:0:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-519aa976740mr10689931cf.2.1781711437488; Wed, 17 Jun 2026
 08:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <fa1fe7d869e2ff45907b271ac4066aa0339d037c.1781564384.git.abhishekbapat@google.com>
 <f23682fb-6107-4dad-bc60-b8816fba23d6@linux.dev>
In-Reply-To: <f23682fb-6107-4dad-bc60-b8816fba23d6@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 08:50:26 -0700
X-Gm-Features: AVVi8CcRTe1GsOuzmxRS9stYVTr4hzVkumKn_SvvRtSxmxqbtmqO9NMrk177F6c
Message-ID: <CAJuCfpHW3zOV7iiwzVNZbMu2tPGom98oJO9AStxzeizyGfGHrg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6157940004
X-Stat-Signature: i4p9k8xkw18bws3r3pz1cg4n8poup435
X-Rspam-User: 
X-HE-Tag: 1781711439-951547
X-HE-Meta: U2FsdGVkX18DRIhlVGZdmwHPxZ3EoRoPHF86bb/3/OzyA+K8ljVesdAC1/YwTWNC038U1Wvk21EPLp6GQ5Z+cggNj0iFeoQUcxd+byfl4DPaDPqvQ67Y7PzF1UOS/wONj5SHh8UTqrcU+0mPdTeVFxLt9+tUKRVSyrsVNmaM3mdV6qwOR9ByYjYjIJrAo41zbqQ+hiIlQmiyfI8poU28JDNyA5smvnqXXE5J9Gu3OXV/DUet9XNT6KZChe0rXDpXlPnXi1bOi/ZnTK6Sbkysr16SP+JLmUevQlPUmH+yHc0Fyp4FMWvDOBQ44/A1/cGSjUCa9eB4zYX2R0gNSejuj8P+cZVfIeaCpxOKcsc4u3XcnRm2RLJmj1zDu8AmXqEHhX5NWMV5ZoX2uZnfq91+VuP+KCXrSVJ5DOe6keQ2JWBzkJH2ZCDH/dv41QQYZr8yr5J1s83uEeVJcI67vxmoknUhKOgG+0JD0SUs9jRJDfXgpiEg/BnS1fk1H/4DUh/YhhcKztSOIguAholi9zzMoHd0F52KCIymkW7hU+jBwhgt+OxxnonSza3i8ILl0Ytbxv7dO1qmwFp9BcYk2NT+OCTacamvytnAN+Q4Vfk3eCtuVfUruEwBLU3GuDUYe/+rN83hE7WF47atlDhwxX1OgJy9Hf6lSXLB2LtomCDDr8/fyOP7nb3KRlvyzKEFKyJ77ZiqhRpPpzFzDJevaU/4XbYBbfCraD+vU5rs+PmN+/5LYSAII4HfeIOktzPtaliYkf6XHurY6YmrxxUPmGg5HJmKXmZTJTOgy3HzMXi5553q/Evwl8gMDajeN0EI2MIJPX7ZPjnIF85I4RDs76p/mmHb2Pd8Txob2/GW2f58l5LG2C+WatvB64cbm3KLex15QDnDiCnFNQdwYogJtEmsNMIBzoP669QOTMO8PC/zkEkfcmuv6oj2cPt/7PFvgVnQlwZpzPcjzEyrqZmeVmV
 mPdB23aN
 /VzaaMFLy32t10Q/krzxOm63ymRznmQIHZlve9nGreTEAyoHtbA8l+YR6IeHGZQaWa4QF1oTRMDjktCOjKwbIYe4IxjdfQ2+B/K2THIRSAtMRIEz8YVN/tBlY+tOidKGF9qHlZsJjFGOqERLkhsX8lcsy3QSAGwp7y+bApgpHlXsepa/Mb2gYR0BDhr+1ayZqskPhQYslZK0lgyO2qoW+hjEO+AOJFqR+da57R3SvwnWj2ezlKR9x9bKTblyWrVdrqpg58cG7v+KK4rmHEYGlPjcftavtvmweJmAAAbn79zcI6BPaMdDdebKMf7ScJiJuKmsEpkKLpgD6EYwH1WJnQJd81amQ3ccKwejgw3zsXqx5eZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 6:40=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/6/16 07:04, Abhishek Bapat wrote:
> > From: Suren Baghdasaryan <surenb@google.com>
> >
> > Add the following ioctl commands for /proc/allocinfo file:
> >
> > ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
> > to check whether the file content has changed specifically due to modul=
e
> > load/unload. Every time a module is loaded / unloaded, the returned
> > value will be different. By comparing the identifier value at the
> > beginning and at the end of the content retrieval operation, users can
> > validate retrieved information for consistency.
> >
> > ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
> > is the position of a record in /proc/allocinfo.
> >
> > ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> > one. If no records were previously retrieved, returns the first
> > record.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>
>
> Thanks for updating the patch, LGTM.
>
> Acked-by: Hao Ge <hao.ge@linux.dev>
>
>
> > ---
> >   Documentation/mm/allocation-profiling.rst     |   5 +
> >   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >   MAINTAINERS                                   |   1 +
> >   include/linux/codetag.h                       |   2 +
> >   include/uapi/linux/alloc_tag.h                |  60 +++++
> >   lib/alloc_tag.c                               | 235 +++++++++++++++++=
-
> >   lib/codetag.c                                 |  18 ++
> >   7 files changed, 321 insertions(+), 2 deletions(-)
> >   create mode 100644 include/uapi/linux/alloc_tag.h
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index 5389d241176a..c3a28467955f 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -46,6 +46,11 @@ sysctl:
> >   Runtime info:
> >     /proc/allocinfo
> >
> > +  Profiling data can be retrieved either by reading `/proc/allocinfo` =
directly as
> > +  text or programmatically via `ioctl()` calls defined in `<uapi/linux=
/alloc_tag.h>`.
> > +  The ioctl interface supports structured binary data extraction as we=
ll as filtering
> > +  by module name, function, file, line number, accuracy, or allocation=
 size limits.
> > +
> >   Example output::
> >
> >     root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=3Diec
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docum=
entation/userspace-api/ioctl/ioctl-number.rst
> > index 331223761fff..84f6808a8578 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -349,6 +349,8 @@ Code  Seq#    Include File                         =
                    Comments
> >                                                                        =
  <mailto:luzmaximilian@gmail.com>
> >   0xA5  20-2F  linux/surface_aggregator/dtx.h                          =
  Microsoft Surface DTX driver
> >                                                                        =
  <mailto:luzmaximilian@gmail.com>
> > +0xA6  00-0F  uapi/linux/alloc_tag.h                                   =
 Memory allocation profiling
> > +                                                                      =
 <mailto:surenb@google.com>
> >   0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >   0xAB  00-1F  linux/nbd.h
> >   0xAC  00-1F  linux/raw.h
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 65bd4328fe05..019cc4c285a3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16713,6 +16713,7 @@ S:    Maintained
> >   F:  Documentation/mm/allocation-profiling.rst
> >   F:  include/linux/alloc_tag.h
> >   F:  include/linux/pgalloc_tag.h
> > +F:   include/uapi/linux/alloc_tag.h
> >   F:  lib/alloc_tag.c
> >
> >   MEMORY CONTROLLER DRIVERS
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index ddae7484ca45..a25a085c2df1 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -77,6 +77,8 @@ struct codetag_iterator {
> >   void codetag_lock_module_list(struct codetag_type *cttype);
> >   bool codetag_trylock_module_list(struct codetag_type *cttype);
> >   void codetag_unlock_module_list(struct codetag_type *cttype);
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> > +unsigned int codetag_get_count(struct codetag_type *cttype);
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe);
> >   struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > new file mode 100644
> > index 000000000000..0928e1a48d49
> > --- /dev/null
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -0,0 +1,60 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + * alloc_tag IOCTL API definition
> > + *
> > + * Copyright (C) 2026 Google, LLC.  All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modif=
y
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef _UAPI_ALLOC_TAG_H
> > +#define _UAPI_ALLOC_TAG_H
> > +
> > +#include <linux/types.h>
> > +
> > +#define ALLOCINFO_STR_SIZE   64

The fact that we use the last 64 characters when comparing strings
should be better documented.
I suggest adding a comment before  ALLOCINFO_STR_SIZE definition and
before allocinfo_str(), highlighting this fact. The changelog should
also mention this and explain the reason:

Function, file and module names often have same prefixes, therefore
when filtering by these criterias and if the name is longer than 64
characters, we compare the last 64 characters to minimize the chances
of a name collision.
Otherwise LGTM.

> > +
> > +struct allocinfo_content_id {
> > +     __u64 id;
> > +};
> > +
> > +struct allocinfo_tag {
> > +     /* Longer names are trimmed */
> > +     char modname[ALLOCINFO_STR_SIZE];
> > +     char function[ALLOCINFO_STR_SIZE];
> > +     char filename[ALLOCINFO_STR_SIZE];
> > +     __u64 lineno;
> > +};
> > +
> > +/* The alignment ensures 32-bit compatible interfaces are not broken *=
/
> > +struct allocinfo_counter {
> > +     __u64 bytes;
> > +     __u64 calls;
> > +     __u8 accurate;
> > +} __attribute__((aligned(8)));
> > +
> > +struct allocinfo_tag_data {
> > +     struct allocinfo_tag tag;
> > +     struct allocinfo_counter counter;
> > +};
> > +
> > +struct allocinfo_get_at {
> > +     __u64 pos;      /* input */
> > +     struct allocinfo_tag_data data;
> > +};
> > +
> > +#define _ALLOCINFO_IOC_CONTENT_ID    0
> > +#define _ALLOCINFO_IOC_GET_AT                1
> > +#define _ALLOCINFO_IOC_GET_NEXT              2
> > +
> > +#define ALLOCINFO_IOC_BASE           0xA6
> > +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_CONTENT_ID,     \
> > +                                          struct allocinfo_content_id)
> > +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _ALLOCI=
NFO_IOC_GET_AT,        \
> > +                                           struct allocinfo_get_at)
> > +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, =
_ALLOCINFO_IOC_GET_NEXT,       \
> > +                                          struct allocinfo_tag_data)
> > +
> > +#endif /* _UAPI_ALLOC_TAG_H */
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index d9be1cf5187d..82e3b5f32dff 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -5,6 +5,7 @@
> >   #include <linux/gfp.h>
> >   #include <linux/kallsyms.h>
> >   #include <linux/module.h>
> > +#include <linux/mutex.h>
> >   #include <linux/page_ext.h>
> >   #include <linux/pgalloc_tag.h>
> >   #include <linux/proc_fs.h>
> > @@ -14,6 +15,7 @@
> >   #include <linux/string_choices.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/kmemleak.h>
> > +#include <uapi/linux/alloc_tag.h>
> >
> >   #define ALLOCINFO_FILE_NAME         "allocinfo"
> >   #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_t=
ag))
> > @@ -47,6 +49,10 @@ struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       struct codetag_iterator reported_iter;
> >       bool print_header;
> > +     /* ioctl uses a separate iterator not to interfere with reads */
> > +     struct codetag_iterator ioctl_iter;
> > +     bool positioned; /* seq_open_private() sets to 0 */
> > +     struct mutex ioctl_lock;
> >   };
> >
> >   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > @@ -130,6 +136,232 @@ static const struct seq_operations allocinfo_seq_=
op =3D {
> >       .show   =3D allocinfo_show,
> >   };
> >
> > +/*
> > + * Initializes seq_file operations and allocates private state when op=
ening
> > + * the /proc/allocinfo procfs entry.
> > + */
> > +static int allocinfo_open(struct inode *inode, struct file *file)
> > +{
> > +     int ret;
> > +
> > +     ret =3D seq_open_private(file, &allocinfo_seq_op,
> > +                            sizeof(struct allocinfo_private));
> > +     if (!ret) {
> > +             struct seq_file *m =3D file->private_data;
> > +             struct allocinfo_private *priv =3D m->private;
> > +
> > +             mutex_init(&priv->ioctl_lock);
> > +     }
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Cleans up the seq_file state and frees up the private state allocat=
ed in
> > + * allocinfo_open() when closing the /proc/allocinfo file descriptor.
> > + */
> > +static int allocinfo_release(struct inode *inode, struct file *file)
> > +{
> > +     struct seq_file *m =3D file->private_data;
> > +     struct allocinfo_private *priv =3D m->private;
> > +
> > +     mutex_destroy(&priv->ioctl_lock);
> > +     return seq_release_private(inode, file);
> > +}
> > +
> > +/*
> > + * Returns a pointer to the suffix of a string so that its length fits=
 within
> > + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
> > + */
> > +static const char *allocinfo_str(const char *str)
> > +{
> > +     size_t len =3D strlen(str);
> > +
> > +     /* Keep an extra space for the trailing NULL. */
> > +     if (len >=3D ALLOCINFO_STR_SIZE)
> > +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> > +     return str;
> > +}
> > +
> > +/* Copy a string and trim from the beginning if it's too long */
> > +static void allocinfo_copy_str(char *dest, const char *src)
> > +{
> > +     strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> > +}
> > +
> > +/*
> > + * Populates the UAPI allocinfo_tag_data structure with active runtime
> > + * profiling counters extracted from the given kernel codetag.
> > + */
> > +static void allocinfo_to_params(struct codetag *ct,
> > +                             struct allocinfo_tag_data *data)
> > +{
> > +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > +
> > +     if (ct->modname)
> > +             allocinfo_copy_str(data->tag.modname, ct->modname);
> > +     else
> > +             data->tag.modname[0] =3D '\0';
> > +     allocinfo_copy_str(data->tag.function, ct->function);
> > +     allocinfo_copy_str(data->tag.filename, ct->filename);
> > +     data->tag.lineno =3D ct->lineno;
> > +     data->counter.bytes =3D counter.bytes;
> > +     data->counter.calls =3D counter.calls;
> > +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > +}
> > +
> > +/*
> > + * Retrieves the unique content ID representing the current allocation=
 tag module
> > + * layout, allowing userspace to detect if modules were loaded / unloa=
ded.
> > + */
> > +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __u=
ser *arg)
> > +{
> > +     struct allocinfo_content_id params;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     if (copy_to_user(arg, &params, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * Seeks the ioctl iterator to the specified 0-indexed tag position, r=
eads its
> > + * profiling data and returns it to userspace.
> > + */
> > +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg=
)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     __u64 pos;
> > +     struct allocinfo_get_at params =3D {0};
> > +
> > +     if (copy_from_user(&params, arg, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     priv =3D m->private;
> > +     pos =3D params.pos;
> > +
> > +     mutex_lock(&priv->ioctl_lock);
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     if (pos >=3D codetag_get_count(alloc_tag_cttype)) {
> > +             codetag_unlock_module_list(alloc_tag_cttype);
> > +             mutex_unlock(&priv->ioctl_lock);
> > +             return -ENOENT;
> > +     }
> > +
> > +     /* Find the codetag */
> > +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     while (ct && pos--)
> > +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     if (ct) {
> > +             allocinfo_to_params(ct, &params.data);
> > +             priv->positioned =3D true;
> > +     }
> > +
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     mutex_unlock(&priv->ioctl_lock);
> > +
> > +     if (!ct)
> > +             return -ENOENT;
> > +
> > +     if (copy_to_user(arg, &params, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * Advances the ioctl iterator to the next allocation tag in the seque=
nce and
> > + * returns its profiling data to userspace.
> > + */
> > +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *a=
rg)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     struct allocinfo_tag_data params;
> > +     int ret =3D 0;
> > +
> > +     memset(&params, 0, sizeof(params));
> > +     priv =3D m->private;
> > +
> > +     mutex_lock(&priv->ioctl_lock);
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     if (!priv->positioned) {
> > +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype=
);
> > +             priv->positioned =3D true;
> > +     }
> > +
> > +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     if (ct)
> > +             allocinfo_to_params(ct, &params);
> > +
> > +     if (!ct) {
> > +             priv->positioned =3D false;
> > +             ret =3D -ENOENT;
> > +     }
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     mutex_unlock(&priv->ioctl_lock);
> > +
> > +     if (ret =3D=3D 0) {
> > +             if (copy_to_user(arg, &params, sizeof(params)))
> > +                     return -EFAULT;
> > +     }
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Entry point ioctl function for /proc/allocinfo routing requests to =
fetch the
> > + * layout content ID, seek to a specific tag, or read sequential tags.
> > + */
> > +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> > +                         unsigned long __arg)
> > +{
> > +     void __user *arg =3D (void __user *)__arg;
> > +     int ret;
> > +
> > +     switch (cmd) {
> > +     case ALLOCINFO_IOC_CONTENT_ID:
> > +             ret =3D allocinfo_ioctl_get_content_id(file->private_data=
, arg);
> > +             break;
> > +     case ALLOCINFO_IOC_GET_AT:
> > +             ret =3D allocinfo_ioctl_get_at(file->private_data, arg);
> > +             break;
> > +     case ALLOCINFO_IOC_GET_NEXT:
> > +             ret =3D allocinfo_ioctl_get_next(file->private_data, arg)=
;
> > +             break;
> > +     default:
> > +             ret =3D -ENOIOCTLCMD;
> > +             break;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +#ifdef CONFIG_COMPAT
> > +static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd=
,
> > +                                unsigned long arg)
> > +{
> > +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg))=
;
> > +}
> > +#endif
> > +
> > +static const struct proc_ops allocinfo_proc_ops =3D {
> > +     .proc_open              =3D allocinfo_open,
> > +     .proc_read_iter         =3D seq_read_iter,
> > +     .proc_lseek             =3D seq_lseek,
> > +     .proc_release           =3D allocinfo_release,
> > +     .proc_ioctl             =3D allocinfo_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> > +#endif
> > +};
> > +
> >   size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, =
bool can_sleep)
> >   {
> >       struct codetag_iterator iter;
> > @@ -993,8 +1225,7 @@ static int __init alloc_tag_init(void)
> >               return 0;
> >       }
> >
> > -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &al=
locinfo_seq_op,
> > -                                  sizeof(struct allocinfo_private), NU=
LL)) {
> > +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> >               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> >               shutdown_mem_profiling(false);
> >               return -ENOMEM;
> > diff --git a/lib/codetag.c b/lib/codetag.c
> > index 4001a7ea6675..a9cda4c962a3 100644
> > --- a/lib/codetag.c
> > +++ b/lib/codetag.c
> > @@ -19,6 +19,8 @@ struct codetag_type {
> >       struct codetag_type_desc desc;
> >       /* generates unique sequence number for module load */
> >       unsigned long next_mod_seq;
> > +     /* bumped on every module load and unload */
> > +     unsigned long content_id;
> >   };
> >
> >   struct codetag_range {
> > @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type =
*cttype)
> >       up_read(&cttype->mod_lock);
> >   }
> >
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> > +{
> > +     lockdep_assert_held(&cttype->mod_lock);
> > +
> > +     return cttype->content_id;
> > +}
> > +
> > +unsigned int codetag_get_count(struct codetag_type *cttype)
> > +{
> > +     lockdep_assert_held(&cttype->mod_lock);
> > +
> > +     return cttype->count;
> > +}
> > +
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe)
> >   {
> >       struct codetag_iterator iter =3D {
> > @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type =
*cttype, struct module *mod)
> >
> >       down_write(&cttype->mod_lock);
> >       cmod->mod_seq =3D ++cttype->next_mod_seq;
> > +     ++cttype->content_id;
> >       mod_id =3D idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
> >       if (mod_id >=3D 0) {
> >               if (cttype->desc.module_load) {
> > @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
> >                       cttype->count -=3D range_size(cttype, &cmod->rang=
e);
> >                       idr_remove(&cttype->mod_idr, mod_id);
> >                       kfree(cmod);
> > +                     ++cttype->content_id;
> >               }
> >               up_write(&cttype->mod_lock);
> >               if (found && cttype->desc.free_section_mem)

