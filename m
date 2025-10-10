Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6612FCCD187
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 22:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919EF8E0043; Fri, 10 Oct 2025 18:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF808E0002; Fri, 10 Oct 2025 18:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805618E0043; Fri, 10 Oct 2025 18:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 686508E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:05:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17ADE11A33C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:05:41 +0000 (UTC)
X-FDA: 83983587282.12.4E7F317
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id F185B14000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:05:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bqJCn1ey;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760133939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmnSUvmSdY4ZiZ6tEp0Ci04V3l//Wrt4QcDb6RPwaK4=;
	b=gfbuRrFGelpwnPRJ7ko9+TK8HK807vtkQfUXWcmUwHuBY2Nq+y4g1RnfqgXyGSMfvF8Q5R
	0SG15yHc1LJTRbmwdO/f7IVPsqFXAfs2QeXt/da5h/BAqJvzeoxIhLKVc2jmGmgldT2iB+
	wxHK4txsIX4/+6XnR94qb8HtIfH33wI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bqJCn1ey;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760133939; a=rsa-sha256;
	cv=none;
	b=Pb7we2bn/D7Z+71i54r7/HoF5En2UlT5wcb2WRLX90FmtrHgapEthLArxA0HNAFnCXh5p8
	eQAV0pWizvCP7ids0aTNT25O4rnKo7Hs8/He0XQzCYOo7pS9GEbdbRXMFt6CLfIRM+uZNX
	GuRyPByhrH8KlNU4IzZ2CiPRhPcPjzI=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-42f8e736ecaso185985ab.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760133938; x=1760738738; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmnSUvmSdY4ZiZ6tEp0Ci04V3l//Wrt4QcDb6RPwaK4=;
        b=bqJCn1ey77yc5In5uhjIKs+ADRy20r+SYufNKMMSuGzER1lDLkFY4GUoU1sIsRoyCN
         flEJersQrYIFESdlgxJEd/sWuSi0pQdRpqsESUF9hkMu3Pb2ScCdDA7I/Y/ijZ6nmOEc
         v3giuDsq3g/hNVARsIxLbFuE3wEjMKk43f2dVrRDykFjoONyyrwfCRCf0MtxYRoF1BmV
         PJs8agez5IrFnzp66hdCjFvuHZ76r++qrIjdM8jUyLOIIwQS3fEBf0Oj9/JBFSlI368O
         EmjQELEx/mgEmhlCsbRFf6UbIgHC3eOK3a2Gxn85uPIa2Db8ePMU3GK2QG1F9OtBu9fM
         wnyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760133938; x=1760738738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmnSUvmSdY4ZiZ6tEp0Ci04V3l//Wrt4QcDb6RPwaK4=;
        b=J6xuu9ahmUNsNSuccZyZk43T7om0UKZdwdqKM5QTtb0Gy1ZHk32qsDrMnrfZaM0Gzz
         cbYYjekqUnl84psHyUDEGV+YO6Ce8gjJcuKaG8lxKEBW/WpkKkh0GHyHAPtrfdjMQ0US
         BbJdNnFF6A95qqpeXDfAsjU/PR6tom6uKFvY2pDihHYmKDp37ohkTO/J8ro9zCmW11NQ
         BAZCp1BWW51CFz2aZ0QkhwkcJcVFgetjPaByz5uZ6TkL5xlxS9xDhRJTV9OXOHJzDwmn
         rxCtw/PttGu+btPadmJXZoIxcoKx+aRZJ+NRcN2q+ZpMooKGBBUNm706gg9qCzojZR0S
         UxGg==
X-Forwarded-Encrypted: i=1; AJvYcCXx9O+tkcC/qZ00mUrobLtZVQffPQJ7cS3Y22TfarQZAU84QSwHCSxgz92mwmgRHiketXcTweK3tg==@kvack.org
X-Gm-Message-State: AOJu0Yxuk8iUrSgepG9gEmiK/6F81IIrDg395h/NAbRoXvDVN9tIHtDa
	6uw/fD52bW0uTXbVkianicMHdYa2Ka0py0HnjmxY0GnpWwWfgeqcA7oJjt9Dk/cUzO9uu7N9aYA
	PzH3s/p09uOnnZZInTFhjIAQupGo/2C3MF7xqEw/e
X-Gm-Gg: ASbGnctLKaYP6rrwlipM31Cf3RfIA0iOY0FInv2EVztC1PGogRbzX9PpRUEs4+lmiJv
	sp4a1yvPoiQcmimt40mTQs7GPK8BtsrHUQExBmVQJ6Ed7dg+BnuOFut90layBGXLRL/Y6GrbR4B
	JK90oMiWj/Im5TNFlJaG64QF9gL1zGOqdvqtzERYgimtHZQEcBcXM/NjzbSdrI8HpCQTWsDKdv1
	wDBYGAH57sE3Qp7tmK31ps0JJVRvSOPAze2i2oepg==
X-Google-Smtp-Source: AGHT+IHCgMkdadEhJ/jLB5zDZaBKV4+r/ra7hoXzHWxkTC/o79Mi8mibHtRi6YFL7dAUvHxtQsbnMdQktOK3DWxK4l0=
X-Received: by 2002:a05:622a:215:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4e6eab925c3mr22771281cf.8.1760133937208; Fri, 10 Oct 2025
 15:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-8-surenb@google.com> <20251010211101.59275-1-sj@kernel.org>
In-Reply-To: <20251010211101.59275-1-sj@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 15:05:26 -0700
X-Gm-Features: AS18NWApOnI13PqYYNoCkBzZIV6oPMv1-Ts98EufkX_D7igi4FK4fCru8Io3ADs
Message-ID: <CAJuCfpG_aA7Fw+4=1Twh-EhQ1BshyH_aTj_99R400s2UY+yfTw@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm: introduce GCMA
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	hch@infradead.org, jack@suse.cz, willy@infradead.org, 
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: F185B14000E
X-Rspamd-Server: rspam03
X-Stat-Signature: o1jej8jmap1i31a7hf51t4jch313sgjh
X-HE-Tag: 1760133938-813544
X-HE-Meta: U2FsdGVkX18ObCjF1oOxRf0NaG9PCs6ZX07B7Q7ercCyADAEB2UuzNHZ2CZ9enhTT3fbuIJktrqqp+2bGb1VhAwGqE2d52IHdc3++NgWNOQWF/izJLAGG/eJ9pKjmdq7FW6+xsHQeMDvT3aLtwjpAfvks9/+z+GNzKjLgDCBTncxlPOzFNLbyomfOl1KRhENy2gbNPxkQoVs/RBITK9i3i8oMRCZgwlLl5e5NcNe/dWG7uRuBZs/8xrCF1CcWIaS+j+7nRqczt3f+fFQuczrZPpLh4JGYw0Lj9fFgVYhfho/TsMDNNyvs0syT2bqB51WNaZdtR+vR5txUBlWRRmrIdqG5iuBVPx/i8mQzgUxkfusUEOdSIDrpSnKSf3GhB8fgvIiPcYMVS3GYc3OKadm+ft2/obMpAmMfQ75RVQILDrA86uNTj60JpgR1wPxZGxiW9qVrQ8LhYC0tfp0LHYQufTPTLulVODAITvLP2adgDSQ2vMYBRolJHpsVPnBm7eBj1EkNKtWlWWVnExuic5JUwhvHMWhf9R5awWVK6coP+jmy+9SIPFjm51PLrYsuNGW3fC/vIbuvH3UyIOR/GAZTFgggZ7tkzQsOmxy68LSPEdFxWrrT+i6Zn5XM+shTIT268eJwGDd9esS3RlK3ToHp072E0yj/fXUIXRn+BisBmtrHP9XBcnHhR2buvMlLnYbXA6M0U47kyxrpbnVGGER22slWi6pLIvf0OoZ4KwpW6pAz9asTGtpWMIpUN39OeFDuQN7e+929SG3pk6ZY+CSh6KSF2ynv5LthKT2dZd2cZblhEx4T4cca4G83RNs9YvjqX6XSkEwG2O8BKJSKMzubtyxbPmogEOrZTeFMJpLGhWmTCVrTu/MxQucJ72CmGhWwfRQC8IEJa2vzFvOxa72ygC9L/2YKrwxkGR3M4VsUWh4P+nzW2hFwms6ThtwRKLbUMXjrCloRwdvcGfcTUp
 WWhsHHcy
 71PIclPjXCEQPHhWEai5BjXgQgXVJWugVeZ9leRY80jL5lzDXFoXkDRQqLvPUb7Ot8zktJ6L+th7sd+RYI87BXzKAKxk812i9I6V9FDvTvxDMt9uk5Y/1ZcGKSa8q7Ok8YPaEpOMsFojHX4LiUGtfplRCBk3fy+cSRmDw700FPGRLECwPMbskWAQgwL74xaWU89ThlSOSaPC5kxA3ZN3vXf/tYEU3L/43DWByCsMCqpR2Ua7eG9v5CIT3X9IaPOyzWNIj0ej+4spjAZmly4oE01/5YVPLgTnVQ9QsQhItyk6+HjjsbaUpRcFdP7fCxDCms37ilQqxHRcwDgE9Pkj2EZmneoVJTmSnlZo+r5s3ga974Xm+QI3UBzNgXaf5BR/TkrMPfAaGb2AmHyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 2:11=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Suren,
>
> On Thu,  9 Oct 2025 18:19:50 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > From: Minchan Kim <minchan@google.com>
> >
> > This patch introduces GCMA (Guaranteed Contiguous Memory Allocator)
> > cleacache backend which reserves some amount of memory at the boot
> > and then donates it to store clean file-backed pages in the cleancache.
> > GCMA aims to guarantee contiguous memory allocation success as well as
> > low and deterministic allocation latency.
> >
> > Notes:
> > Originally, the idea was posted by SeongJae Park and Minchan Kim [1].
> > Later Minchan reworked it to be used in Android as a reference for
> > Android vendors to use [2].
> >
> > [1] https://lwn.net/Articles/619865/
> > [2] https://android-review.googlesource.com/q/topic:%22gcma_6.12%22
> >
> > Signed-off-by: Minchan Kim <minchan@google.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  MAINTAINERS          |   2 +
> >  include/linux/gcma.h |  36 +++++++
> >  mm/Kconfig           |  15 +++
> >  mm/Makefile          |   1 +
> >  mm/gcma.c            | 231 +++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 285 insertions(+)
> >  create mode 100644 include/linux/gcma.h
> >  create mode 100644 mm/gcma.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 441e68c94177..95b5ad26ec11 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16361,6 +16361,7 @@ F:    Documentation/admin-guide/mm/
> >  F:   Documentation/mm/
> >  F:   include/linux/cma.h
> >  F:   include/linux/dmapool.h
> > +F:   include/linux/gcma.h
> >  F:   include/linux/ioremap.h
> >  F:   include/linux/memory-tiers.h
> >  F:   include/linux/page_idle.h
> > @@ -16372,6 +16373,7 @@ F:    mm/dmapool.c
> >  F:   mm/dmapool_test.c
> >  F:   mm/early_ioremap.c
> >  F:   mm/fadvise.c
> > +F:   mm/gcma.c
> >  F:   mm/ioremap.c
> >  F:   mm/mapping_dirty_helpers.c
> >  F:   mm/memory-tiers.c
> > diff --git a/include/linux/gcma.h b/include/linux/gcma.h
> > new file mode 100644
> > index 000000000000..20b2c85de87b
> > --- /dev/null
> > +++ b/include/linux/gcma.h
> > @@ -0,0 +1,36 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __GCMA_H__
> > +#define __GCMA_H__
> > +
> > +#include <linux/types.h>
> > +
> > +#ifdef CONFIG_GCMA
> > +
> > +int gcma_register_area(const char *name,
> > +                    unsigned long start_pfn, unsigned long count);
> > +
> > +/*
> > + * NOTE: allocated pages are still marked reserved and when freeing th=
em
> > + * the caller should ensure they are isolated and not referenced by an=
yone
> > + * other than the caller.
> > + */
> > +int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp=
_t gfp);
> > +int gcma_free_range(unsigned long start_pfn, unsigned long count);
> > +
> > +#else /* CONFIG_GCMA */
> > +
> > +static inline int gcma_register_area(const char *name,
> > +                                  unsigned long start_pfn,
> > +                                  unsigned long count)
> > +             { return -EOPNOTSUPP; }
> > +static inline int gcma_alloc_range(unsigned long start_pfn,
> > +                                unsigned long count, gfp_t gfp)
> > +             { return -EOPNOTSUPP; }
> > +
> > +static inline int gcma_free_range(unsigned long start_pfn,
> > +                                unsigned long count)
> > +             { return -EOPNOTSUPP; }
> > +
> > +#endif /* CONFIG_GCMA */
> > +
> > +#endif /* __GCMA_H__ */
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 9f4da8a848f4..41ce5ef8db55 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1013,6 +1013,21 @@ config CMA_AREAS
> >
> >         If unsure, leave the default value "8" in UMA and "20" in NUMA.
> >
> > +config GCMA
> > +       bool "GCMA (Guaranteed Contiguous Memory Allocator)"
> > +       depends on CLEANCACHE
> > +     help
> > +       This enables the Guaranteed Contiguous Memory Allocator to allo=
w
> > +       low latency guaranteed contiguous memory allocations. Memory
> > +       reserved by GCMA is donated to cleancache to be used as pagecac=
he
> > +       extension. Once GCMA allocation is requested, necessary pages a=
re
> > +       taken back from the cleancache and used to satisfy the request.
> > +       Cleancache guarantees low latency successful allocation as long
> > +       as the total size of GCMA allocations does not exceed the size =
of
> > +       the memory donated to the cleancache.
> > +
> > +       If unsure, say "N".
> > +
> >  #
> >  # Select this config option from the architecture Kconfig, if availabl=
e, to set
> >  # the max page order for physically contiguous allocations.
> > diff --git a/mm/Makefile b/mm/Makefile
> > index 845841a140e3..05aee66a8b07 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -149,3 +149,4 @@ obj-$(CONFIG_TMPFS_QUOTA) +=3D shmem_quota.o
> >  obj-$(CONFIG_PT_RECLAIM) +=3D pt_reclaim.o
> >  obj-$(CONFIG_CLEANCACHE) +=3D cleancache.o
> >  obj-$(CONFIG_CLEANCACHE_SYSFS)       +=3D cleancache_sysfs.o
> > +obj-$(CONFIG_GCMA)   +=3D gcma.o
> > diff --git a/mm/gcma.c b/mm/gcma.c
> > new file mode 100644
> > index 000000000000..3ee0e1340db3
> > --- /dev/null
> > +++ b/mm/gcma.c
> > @@ -0,0 +1,231 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * GCMA (Guaranteed Contiguous Memory Allocator)
> > + *
> > + */
> > +
> > +#define pr_fmt(fmt) "gcma: " fmt
> > +
> > +#include <linux/cleancache.h>
> > +#include <linux/gcma.h>
> > +#include <linux/hashtable.h>
> > +#include <linux/highmem.h>
> > +#include <linux/idr.h>
> > +#include <linux/slab.h>
> > +#include <linux/xarray.h>
> > +#include "internal.h"
> > +
> > +#define MAX_GCMA_AREAS               64
> > +#define GCMA_AREA_NAME_MAX_LEN       32
> > +
> > +struct gcma_area {
> > +     int pool_id;
> > +     unsigned long start_pfn;
> > +     unsigned long end_pfn;
> > +     char name[GCMA_AREA_NAME_MAX_LEN];
> > +};
> > +
> > +static struct gcma_area areas[MAX_GCMA_AREAS];
> > +static atomic_t nr_gcma_area =3D ATOMIC_INIT(0);
> > +static DEFINE_SPINLOCK(gcma_area_lock);
> > +
> > +static int free_folio_range(struct gcma_area *area,
> > +                          unsigned long start_pfn, unsigned long end_p=
fn)
> > +{
> > +     unsigned long scanned =3D 0;
> > +     struct folio *folio;
> > +     unsigned long pfn;
> > +
> > +     for (pfn =3D start_pfn; pfn < end_pfn; pfn++) {
> > +             int err;
> > +
> > +             if (!(++scanned % XA_CHECK_SCHED))
> > +                     cond_resched();
> > +
> > +             folio =3D pfn_folio(pfn);
> > +             err =3D cleancache_backend_put_folio(area->pool_id, folio=
);
>
> Why don't you use pfn_folio() directly, like alloc_folio_range() does?

Yes, that would be better. Will change.

>
> > +             if (WARN(err, "PFN %lu: folio is still in use\n", pfn))
> > +                     return -EINVAL;
>
> Why don't you return err, like alloc_folio_range() does?

Ack. In my earlier version cleancache_backend_put_folio() was
returning bool, so I had to convert it to int here. But now we can
return err directly. Will change.

>
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int alloc_folio_range(struct gcma_area *area,
> > +                           unsigned long start_pfn, unsigned long end_=
pfn,
> > +                           gfp_t gfp)
> > +{
> > +     unsigned long scanned =3D 0;
> > +     unsigned long pfn;
> > +
> > +     for (pfn =3D start_pfn; pfn < end_pfn; pfn++) {
> > +             int err;
> > +
> > +             if (!(++scanned % XA_CHECK_SCHED))
> > +                     cond_resched();
> > +
> > +             err =3D cleancache_backend_get_folio(area->pool_id, pfn_f=
olio(pfn));
> > +             if (err) {
> > +                     free_folio_range(area, start_pfn, pfn);
> > +                     return err;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static struct gcma_area *find_area(unsigned long start_pfn, unsigned l=
ong end_pfn)
> > +{
> > +     int nr_area =3D atomic_read_acquire(&nr_gcma_area);
> > +     int i;
> > +
> > +     for (i =3D 0; i < nr_area; i++) {
> > +             struct gcma_area *area =3D &areas[i];
> > +
> > +             if (area->end_pfn <=3D start_pfn)
> > +                     continue;
> > +
> > +             if (area->start_pfn > end_pfn)
> > +                     continue;
> > +
> > +             /* The entire range should belong to a single area */
> > +             if (start_pfn < area->start_pfn || end_pfn > area->end_pf=
n)
> > +                     break;
> > +
> > +             /* Found the area containing the entire range */
> > +             return area;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +int gcma_register_area(const char *name,
> > +                    unsigned long start_pfn, unsigned long count)
> > +{
> > +     LIST_HEAD(folios);
> > +     int i, pool_id;
> > +     int nr_area;
> > +     int ret =3D 0;
> > +
> > +     pool_id =3D cleancache_backend_register_pool(name);
> > +     if (pool_id < 0)
> > +             return pool_id;
> > +
> > +     for (i =3D 0; i < count; i++) {
> > +             struct folio *folio;
> > +
> > +             folio =3D pfn_folio(start_pfn + i);
> > +             folio_clear_reserved(folio);
> > +             folio_set_count(folio, 0);
> > +             list_add(&folio->lru, &folios);
> > +     }
> > +
> > +     cleancache_backend_put_folios(pool_id, &folios);
> > +
> > +     spin_lock(&gcma_area_lock);
> > +
> > +     nr_area =3D atomic_read(&nr_gcma_area);
> > +     if (nr_area < MAX_GCMA_AREAS) {
> > +             struct gcma_area *area =3D &areas[nr_area];
> > +
> > +             area->pool_id =3D pool_id;
> > +             area->start_pfn =3D start_pfn;
> > +             area->end_pfn =3D start_pfn + count;
> > +             strscpy(area->name, name);
> > +             /* Ensure above stores complete before we increase the co=
unt */
> > +             atomic_set_release(&nr_gcma_area, nr_area + 1);
> > +     } else {
> > +             ret =3D -ENOMEM;
> > +     }
> > +
> > +     spin_unlock(&gcma_area_lock);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(gcma_register_area);
> > +
> > +int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp=
_t gfp)
> > +{
> > +     unsigned long end_pfn =3D start_pfn + count;
> > +     struct gcma_area *area;
> > +     struct folio *folio;
> > +     int err, order =3D 0;
> > +
> > +     gfp =3D current_gfp_context(gfp);
> > +     if (gfp & __GFP_COMP) {
> > +             if (!is_power_of_2(count))
> > +                     return -EINVAL;
> > +
> > +             order =3D ilog2(count);
> > +             if (order >=3D MAX_PAGE_ORDER)
> > +                     return -EINVAL;
> > +     }
> > +
> > +     area =3D find_area(start_pfn, end_pfn);
> > +     if (!area)
> > +             return -EINVAL;
> > +
> > +     err =3D alloc_folio_range(area, start_pfn, end_pfn, gfp);
> > +     if (err)
> > +             return err;
> > +
> > +     /*
> > +      * GCMA returns pages with refcount 1 and expects them to have
> > +      * the same refcount 1 when they are freed.
> > +      */
> > +     if (order) {
> > +             folio =3D pfn_folio(start_pfn);
> > +             set_page_count(&folio->page, 1);
> > +             prep_compound_page(&folio->page, order);
> > +     } else {
> > +             for (unsigned long pfn =3D start_pfn; pfn < end_pfn; pfn+=
+) {
> > +                     folio =3D pfn_folio(pfn);
> > +                     set_page_count(&folio->page, 1);
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(gcma_alloc_range);
>
> I'm wondering if the rule of exporting symbols only for in-tree modules t=
hat
> use the symbols should be applied here or not, and why.

In Android we use gcma_alloc_range() in vendor-defined dmabuf-heap
modules. That's why I need this API to be exported.

>
> > +
> > +int gcma_free_range(unsigned long start_pfn, unsigned long count)
> > +{
> > +     unsigned long end_pfn =3D start_pfn + count;
> > +     struct gcma_area *area;
> > +     struct folio *folio;
> > +
> > +     area =3D find_area(start_pfn, end_pfn);
> > +     if (!area)
> > +             return -EINVAL;
> > +
> > +     folio =3D pfn_folio(start_pfn);
> > +     if (folio_test_large(folio)) {
> > +             int expected =3D folio_nr_pages(folio);
>
> folio_nr_pages() return 'unsigned long'.  Would it be better to match the=
 type?

Yes! Ack.

>
> > +
> > +             if (WARN(count !=3D expected, "PFN %lu: count %lu !=3D ex=
pected %d\n",
> > +                       start_pfn, count, expected))
> > +                     return -EINVAL;
> > +
> > +             if (WARN(!folio_ref_dec_and_test(folio),
> > +                      "PFN %lu: invalid folio refcount when freeing\n"=
, start_pfn))
> > +                     return -EINVAL;
> > +
> > +             free_pages_prepare(&folio->page, folio_order(folio));
> > +     } else {
> > +             for (unsigned long pfn =3D start_pfn; pfn < end_pfn; pfn+=
+) {
> > +                     folio =3D pfn_folio(pfn);
> > +                     if (folio_nr_pages(folio) =3D=3D 1)
> > +                             count--;
> > +
> > +                     if (WARN(!folio_ref_dec_and_test(folio),
> > +                              "PFN %lu: invalid folio refcount when fr=
eeing\n", pfn))
> > +                             return -EINVAL;
>
> Don't we need to increase the previously decreased folio refcounts?

Yes, you are right. If any folio refcount is incorrect here (folio is
still in use), we should restore the refcount for all folios that we
have already processed. I think I'll also need to do 2 passes here:
first drop and check the refcount on all folios, then call
free_pages_prepare() if all folios are unused.

And also need to remove all these WARN()'s which I had for
debugging... Will remove in the next version.

>
> > +
> > +                     free_pages_prepare(&folio->page, 0);
> > +             }
> > +             WARN(count !=3D 0, "%lu pages are still in use!\n", count=
);
>
> Is WARN() but not returning error here ok?

No. I'll rework this loop to perform 2 passes as I mentioned before
and if the first pass detects any mistake, it will restore previous
refcounts and return an error.

>
> Also, why don't you warn earlier above if 'folio_nr_pages(folio) !=3D 1' =
?

I'll remove all these warnings and change the code to fail and restore
folios if any folio in the range does not meet our expectations.

>
> > +     }
> > +
> > +     return free_folio_range(area, start_pfn, end_pfn);
> > +}
> > +EXPORT_SYMBOL_GPL(gcma_free_range);
>
> Like the gcma_alloc_range() case, I'm curious if this symbol exporting is
> somewhat intended and the intention is explained.

Same reasons. Vendor-provided dmabuf heap modules might use it.

Thanks,
Suren.

>
> > --
> > 2.51.0.740.g6adb054d12-goog
>
>
> Thanks,
> SJ

