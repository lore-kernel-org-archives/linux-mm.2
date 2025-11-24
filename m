Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C07CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21466B0026; Mon, 24 Nov 2025 07:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9086B0027; Mon, 24 Nov 2025 07:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D367E6B0028; Mon, 24 Nov 2025 07:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C14716B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:45:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F9FC88D33
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:45:20 +0000 (UTC)
X-FDA: 84145471200.25.510B601
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81E98140013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:45:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YHe1A4Uy;
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763988318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VWcEmhan/BNwTvurxtnj0t4NznWYHYqF0Rq1JXc1mQ=;
	b=j85VcYUy6k/ulS/XaXw2pr+r4ZePRI4AO3Xi8LL4f764sljlMHIOYWy03nEB206ycsG6BV
	+RfgKAIPL81WDRUwFewmapctQdmtYQ0EDn0QNu/e5UzZ/uNCJZPNrOmpI+vHCx9056YRBP
	BTV3O6SvQ2AVX2pYOxoqD+x7SAR1Os4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763988318; a=rsa-sha256;
	cv=none;
	b=hnx6w8nDCutUv/tf5EbE9VNzvbHvZuFV1mU2Fg52CEiYGJuzb4nkb5pMsR3LI7GsfKnbgE
	3zueR0q5vPXCS9Hpih86euToMa2v2m98X2VqlOcQ4hAwx1m+uQzJ3hgocRIcyvtS3Y1rJy
	r4qowfW8ElufcldeM+qEbl1tNAD55jU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YHe1A4Uy;
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee243b98caso479561cf.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763988317; x=1764593117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VWcEmhan/BNwTvurxtnj0t4NznWYHYqF0Rq1JXc1mQ=;
        b=YHe1A4UyhPs8aA7F+Ep5JrV9QI40QjlQpmVy4PD5//l+ZYvQQvqcu3NCeDy/DfhWog
         EJVkB881EEbNnQ1SQSeoXxenL/iCERDy2v7PREjIuFwLLW1xYd9DNfpyOL9Af6jgcErH
         tcLmWkg4PfBtdj3+x0YEEp0Rmq4rDc1y7+U0DyzjAHIX8b/ehuULeKeVBe9tNiwm3NCk
         il19nUcTggXU0VN41OYTWAUZGZ0ipDbFfmM1TaQdN8js3wGMSsXjKX1PCDtW5585LSm3
         AHuCVSafQ1+dR1hKlt1i1L8n5Uu/rbd7SXOyUFqcN1YiRSoHCWQPY4wgkjKbfiIYPQaI
         Q9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763988317; x=1764593117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6VWcEmhan/BNwTvurxtnj0t4NznWYHYqF0Rq1JXc1mQ=;
        b=Niv78LI1LyERXiZVHBQDNU/f9gu9wX4Jo1AoTamS+g64JpMBBCvVN4sdqwmTjmdg9D
         lsX40J4sje4zN3DkKchQIy+Voa4ssAlFfs29fw/dTOVe9EdwjXB1GvtPEhMYegQ+1w6y
         nvgQRbi+EurJy+lLfgXgUyekLOB4hdudllBrh5kQrkJFP4/GmxKleQZBn32vGEtCgUuL
         qU8ndRT0TPgcH4XLIxIgDeAMI/xThcnuskSq03+hUE1XLIORAD8zODJJ8ILUFbA1RZWb
         ncNX1fHQx/SESrnfs0BZ/LBuGirfMwf9tTohv2F1zzpIrCpOHRADk7GsRcN3+G2W8lAM
         devg==
X-Gm-Message-State: AOJu0YypP1tobmkwVzfwfU3kQPkGJ+SP7/J5J32y4ZWpoUtu64FxzVyF
	Rsutex7Acli8Rd2San6Y5zgRX0V3/28P9Yh5vvtNisG5o8A3QIv58wJGdQttR3mkrzK45epdZRp
	PhL6B2WBlnBlELLFXRx1ffoqAZXecJEa1csVwTG3t
X-Gm-Gg: ASbGnctJ9LDBOviNoU44AvVC5JT7USun1iKxemWD99YW3yX1mE4qLetA/ieUut1Cbfq
	FbvYri4GPiqHWyhAA4ThtB3OZtgCKkt7ojsvOJQi8gdyJetlavfRecgEJThgfAyfWOKpzRa1KSM
	3HBdxuDD86KZkjCcMInGd7JAJ+EmUadP/9Gnb86O51FXsV8Lp4iHRVt3CkJey4WzBGHpXJRazG7
	ur1fiPzQyTBETK1d0CHAsb2DcTgJegM/f0ASXXlPNWfp+pwRj6EfccOTi8cmYBl1vdO8SKGJm/8
	kSNY6fCTwaN7S1fAxZIhguY=
X-Google-Smtp-Source: AGHT+IGPjVCxfR9SKFA3FQOdCOVgD7/O9AanhIhyNvazavihPLZPPKf8lSGLvPhLVXD4pGKivK0LrnCUCoWz3BbimD8=
X-Received: by 2002:ac8:5d14:0:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4ee60ecb032mr9555211cf.8.1763988317334; Mon, 24 Nov 2025
 04:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20251106163953.1971067-1-smostafa@google.com> <20251106163953.1971067-2-smostafa@google.com>
 <aRWtX3n2I7El4Ykv@willie-the-truck> <aSQ9DsR0nAAvc4Pd@google.com>
In-Reply-To: <aSQ9DsR0nAAvc4Pd@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 24 Nov 2025 12:45:06 +0000
X-Gm-Features: AWmQ_blA1bdjlFzoBd-B3IlCTsIeP9e4yZgrlAzqOFd_qVOZm4_QtkdjmvxtkT8
Message-ID: <CAFgf54p1T_Vsx_QLX1XOJJz6v6K337G5T0Gw=V=9LL4h_CWZHQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i8qfpaf733pmcacnj8yotp7za68cebd5
X-Rspam-User: 
X-Rspamd-Queue-Id: 81E98140013
X-Rspamd-Server: rspam01
X-HE-Tag: 1763988318-856524
X-HE-Meta: U2FsdGVkX1+ICrAWMVTSZPiqG9Vlc9Esx/783MmlimdlWHaC2A0gjXTol27lhV8/FbBR22jRyPjtqoL86ZnJZIr2we1CH4RSFPOZikuA42ol4dPY4hGUkUEUapdmPsfg+FZ9g4lGyt5+JzMMs4EIyamFZaKFtYUcII+EZE2xKvPkrFTsqHeYLr181ToYqEW8aUnPxL88H1/vuz13hTNxnSgxy3iGENl7ne8vVgXz5vH5YMKoG6z5W5qwdbX41FHxzjiprWP9u0wU+/tp7ypqcWLoSjmr6IuNFDVsJ49kZ65kaKYeCbWG/qJFD6IE8B4Pct5Ao/4Z5GWatVW2u6/u0FtDbquxnseidUW/NwnxSmyPa58PI4aRyty6oEDoCXI4N7cKEJuvOH/TjJAC/GCpdKIkvYvJdRDGPYhc3nLDBMsMWDX0hs7+CFiHdqFk+V6zOcE+P8f48az/aIznvpKVdWm4BUEomnVAk2uYWEyZHYbDMrHNrv7Xzx2pM/hwNJdJMjFt37BOB00RrPjbQPChKd/yp/hh+f85zzLhLlDbTeS+oIIb8XWVdRHHEfwqXu5V5KijxWXdarTRz4pDJA72lsLn4Hz8QGFL82RwTbGljeHap3weNkUqQWgLmGoL/kKaT+xUHdFGeMDQYb3ETX5Nlm1UqljnFI7YFTakFXUWn8/DrcflcoE4J+wmR2JhdzwWKM97qy1ZuzeNzA3PJFGnfKeu+XFUUwUdQcyeN29kl4OKknImEveky7uVb54hKrmkSxcr9q00tZfPA3Omey0TncVg9FY9kkLTHZ44yPgHWUqPGaqRHwS0Qjjk7fR2Nj5gQl2O9v7zlvTYL6e+1cBrOCca2MtHTL3o2JlU8zlic52CUqS05ixaCN+OyQXzP7yfsHDhEfeFLrI4PiJxxuk86BcfKNjVETRzCuzkujKcNEhrxW97cT7zvqJLDgnAwWF6A7KUFit4hn3zyziWK3k
 f2SLsoTJ
 7850BiS/Q2ccvAji3Ghi1VpQHdL+GA/050guCSdowpI6mNaGHERi2ZWQtLUyU/yiKKEkNTL2Ww+TpCupzCr7zXj549dNwhnXygdOb37Q+iXlVf4INdDPstRXSPHC1CSu/oaRHjciaG6z5VpnYh5qMSCxk44AVgrDnRIvtkH5Go/yMesu6oZUC2OGzwnMQHiOAeEy4dlTSvUbKyVwwwTIAriy+pLzfgqVnXYjC1p5ovORLHtWRd8+SKC7hPRs+hH66de9mdhW56uKpXH+LUr3q7HhhBrxzLcJsYCAo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:10=E2=80=AFAM Mostafa Saleh <smostafa@google.com=
> wrote:
>
> On Thu, Nov 13, 2025 at 10:05:19AM +0000, Will Deacon wrote:
> > Hi Mostafa,
> >
> > On Thu, Nov 06, 2025 at 04:39:50PM +0000, Mostafa Saleh wrote:
> > > Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> > > page_ext.
> > > This config will be used by the IOMMU API to track pages mapped in
> > > the IOMMU to catch drivers trying to free kernel memory that they
> > > still map in their domains, causing all types of memory corruption.
> > > This behaviour is disabled by default and can be enabled using
> > > kernel cmdline iommu.debug_pagealloc.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > > ---
> > >  .../admin-guide/kernel-parameters.txt         |  6 ++++
> > >  drivers/iommu/Kconfig                         | 15 +++++++++
> > >  drivers/iommu/Makefile                        |  1 +
> > >  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++=
++
> > >  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> > >  mm/page_ext.c                                 |  4 +++
> > >  6 files changed, 75 insertions(+)
> > >  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> > >  create mode 100644 include/linux/iommu-debug-pagealloc.h
> >
> > This looks like a pretty handy feature to me, but I have some nits belo=
w.
>
> Thanks for taking the time to review the patches!
>
> >
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Docume=
ntation/admin-guide/kernel-parameters.txt
> > > index 6c42061ca20e..9a1c4ac8ba96 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -2557,6 +2557,12 @@
> > >                     1 - Bypass the IOMMU for DMA.
> > >                     unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHR=
OUGH.
> > >
> > > +   iommu.debug_pagealloc=3D
> > > +                   [KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is =
set, this
> > > +                   parameter enables the feature at boot time. By de=
fault, it
> > > +                   is disabled and the system will work mostly the s=
ame as a
> > > +                   kernel built without CONFIG_IOMMU_DEBUG_PAGEALLOC=
.
> >
> > Can you be more specific about "mostly the same"?
>
> The only difference is that the static key to gate the calls, I was not s=
ure if
> saying =E2=80=9Cexactly the same=E2=80=9D is correct, but I think it=E2=
=80=99s better avoid =E2=80=9Cmostly=E2=80=9D as
> it might be confusing and as the data in the cover letter shows no overhe=
ad,
> I will re-write the whole help anyway.
>

Ah, I think I copied the base of this from the documenation of
"debug_pagealloc=3D"
which actually slightly changes system behviour by not using THP on some ar=
chs,
which is not relevant in our case, I will drop it then.

Thanks,
Mostafa

> >
> > > +
> > >     io7=3D            [HW] IO7 for Marvel-based Alpha systems
> > >                     See comment before marvel_specify_io7 in
> > >                     arch/alpha/kernel/core_marvel.c.
> > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > index 70d29b14d851..6b5e9a2d936a 100644
> > > --- a/drivers/iommu/Kconfig
> > > +++ b/drivers/iommu/Kconfig
> > > @@ -383,4 +383,19 @@ config SPRD_IOMMU
> > >
> > >       Say Y here if you want to use the multimedia devices listed abo=
ve.
> > >
> > > +config IOMMU_DEBUG_PAGEALLOC
> > > +   bool "Debug page memory allocations against IOMMU"
> >
> > Perhaps "IOMMU mappings" would make this a little clearer?
>
> Will do.
>
> >
> > > +   depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> > > +   help
> > > +     This config checks that a page is freed(unmapped) or mapped by =
the
> > > +     kernel is not mapped in any IOMMU domain.
> >
> > I can't really parse this sentence :/
>
> I will re-write it.
>
> >
> > > It can help with debugging
> > > +     use-after-free or out-of-bound maps from drivers doing DMA thro=
ugh
> > > +     the IOMMU API.
> > > +     This santaizer can have false-negative cases where some problem=
s
> > > +     won't be detected.
> >
> > Maybe just say "The sanitizer is best-effort and can fail to detect pro=
blems
> > in the case that ...".
>
> Makes sense, will do.
>
> >
> > > +     Expect overhead when enabling this and enabling the kernel comm=
and
> > > +     line iommu.debug_pagealloc.
> >
> > I'd reword this to say something like "Due to the overhead of the sanit=
iser,
> > iommu.debug_pagealloc must also be passed on the kernel command-line to
> > enable this feature".
>
> Will do.
>
> >
> > > +
> > > +     If unsure, say N here.
> > > +
> > >  endif # IOMMU_SUPPORT
> > > diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> > > index 355294fa9033..8f5130b6a671 100644
> > > --- a/drivers/iommu/Makefile
> > > +++ b/drivers/iommu/Makefile
> > > @@ -34,3 +34,4 @@ obj-$(CONFIG_IOMMU_SVA) +=3D iommu-sva.o
> > >  obj-$(CONFIG_IOMMU_IOPF) +=3D io-pgfault.o
> > >  obj-$(CONFIG_SPRD_IOMMU) +=3D sprd-iommu.o
> > >  obj-$(CONFIG_APPLE_DART) +=3D apple-dart.o
> > > +obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) +=3D iommu-debug-pagealloc.o
> > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/io=
mmu-debug-pagealloc.c
> > > new file mode 100644
> > > index 000000000000..385c8bfae02b
> > > --- /dev/null
> > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > @@ -0,0 +1,32 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (C) 2025 - Google Inc
> > > + * Author: Mostafa Saleh <smostafa@google.com>
> > > + * IOMMU API debug page alloc sanitizer
> > > + */
> > > +#include <linux/atomic.h>
> > > +#include <linux/iommu-debug-pagealloc.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/page_ext.h>
> > > +
> > > +static bool needed;
> > > +
> > > +struct iommu_debug_metadate {
> > > +   atomic_t ref;
> > > +};
> >
> > s/metadate/metadata/
>
> Ah, that's embarrassing, I will fix it.
>
> Thanks,
> Mostafa
>
> >
> > Will

