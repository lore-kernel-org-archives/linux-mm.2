Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22E5CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D5D8E0018; Tue, 21 Oct 2025 13:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324CA8E0002; Tue, 21 Oct 2025 13:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261678E0018; Tue, 21 Oct 2025 13:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13AD98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:25:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A67FC8859A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:25:24 +0000 (UTC)
X-FDA: 84022797768.28.34CC00C
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC478140011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:25:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxWFb4yw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761067522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXi6CRB3+931Kx2XZXckBgFrdC+g3QWN9I9coq5d304=;
	b=wshSOi3KJC2O6UJLx1GafjLihimddg5XcHyczlMftVazXLprC8JF+j78ftySPQ14dkLYlR
	q/HK1+9tp1AFS6ErY3COLA7Y1L6rLKZAkDVifVK0mLcThuCrTgapVAAt3WXLp7FFFUewzx
	iY6/I6J6d3bIZxGDbsz4SP1ftRnHDdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761067522; a=rsa-sha256;
	cv=none;
	b=bZJel3L0HWDs15PWVXv/emfJDpclQNLg/9OO/+PSf+mb6Tj0O2wLH/Ywfk+vpmrmt3TJWJ
	fPvtcIdDEhw8YnUzFRJEOgeT6ch6ZR+suttF6T5kgH6u5GuMbR0L/BXZNCxy8S3tkkoqgg
	DjYHwadLIFm+yI0S088omW8/GxGp8Lo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxWFb4yw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63e0cec110eso1018744a12.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761067521; x=1761672321; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXi6CRB3+931Kx2XZXckBgFrdC+g3QWN9I9coq5d304=;
        b=SxWFb4ywF3bcLCJHy3PQ/vm9O6GJeIf/xPhn7TZUjcBQYMbtnBlN2bc9lJcd9ZKgnQ
         Y5t4912qOQGy+Zmn21k+wPTRaNU98PvVBkGf65FHp9N/okqTiRWqAmd7q8eTAU+0m9GL
         VQnXUFu4wMpGqW1vrAOATZuSRhB4B9OkO1v84EPwL7k0uaMMvsv+YAmX0gMVW6iDFtJr
         Xm2V7TzUupfKhhN+GgEuWMcFIrMRqLGj8qAnlDAJgsi7IG80x6WCTxUWo1vuRbqQ9h9C
         Hqk6mekvOGRCsudkm7lHmqBP1Yw1Mw7S1RxFMsqARbGFghwUIjfGbLad7XMfp7aBbj/7
         F2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761067521; x=1761672321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXi6CRB3+931Kx2XZXckBgFrdC+g3QWN9I9coq5d304=;
        b=D2FHvkrv9kNY6M/FHljtrMW6MzkE0WdU2AyJGicbi03UPPhqV3NRueNhBGxhA9JWvY
         lDNd5pC81ZdVYfI1o4R9tPpd7WROtOB4yq9LYxbFpFweWIh3qFn6QIa16oqhrBjkEzB3
         698rXr6j0tWJys9tRWVdG8G7U3455FAeiXEoueejMjtvHVVvTmNtPOvNnqeWeIer0QrW
         MPyA79z55mV5R+xYclDVr8+ZnuL1JjUfgmJ9a8K/IK/AV5OJCJhuxa78qDhEMCU/ohMf
         BlPuM25SNqnk8zIRuX+FnEjX6W5IO5ajTBry1yR+e0mgG37bGvibd5jWVnIfH8NI9ly8
         mjxg==
X-Forwarded-Encrypted: i=1; AJvYcCVNGuejfO/KjfY4dOfzekj6WivjEFA9SYytazj5OKdg3AZoYY44hz8EUnXoCoApdtnZK4eH8zU3Gw==@kvack.org
X-Gm-Message-State: AOJu0YwagT4Dn17A5aXqw4GboxKhIG8TRqogCAyzQO6WJSVdJdA37608
	QeYdjsnFbMGVepdDYuRvSZrT5cCFhG41M7taIwTxRv+3+3QOOg0a+WPq+y8Vzy6GdoUyFNfMeUY
	j4BjrnUbLOXjJRSkBVXVSv43Vp+6oDiE=
X-Gm-Gg: ASbGnctQu983ibdsS5ejrKgckrTBID8URrXfv+LzA4bGlq0kSOCyBdgRp/J+jhkqtKG
	55okKQo6VrWG3NtqNDVeG1LmC3D5a7A6S+CxN58SN759S/0Qk/038hcmaMB0aNksb/F7d6bvfNm
	/jljBdTtxxgn0eTZ8epH+zCCdqnVaSSar9qPEWR0dmBh9/gaMd/BhtV7DkY9JcxXdD9Uk4K8EJg
	/egCOZ3YwP7xonjwsKiJtKYdUDhR87I1KtHvvkvGU2dQhmYNSqO0c1SJF/Wz34Z7aanHLk=
X-Google-Smtp-Source: AGHT+IHFTFFLc8SGslhJN9Wcay9cG8tXSMifwIHJtttGuFS4CWix+uKRWQgP5Ud3SpMMmQW5vq10q8hPaDNaqszw2i0=
X-Received: by 2002:a05:6402:13ca:b0:637:f07d:e80f with SMTP id
 4fb4d7f45d1cf-63c1f58c0d3mr17646406a12.0.1761067520747; Tue, 21 Oct 2025
 10:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <10e7ac6cebe6535c137c064d5c5a235643eebb4a.1756888965.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <10e7ac6cebe6535c137c064d5c5a235643eebb4a.1756888965.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Oct 2025 01:24:43 +0800
X-Gm-Features: AS18NWD0g9OMCk8OjX7Ue4MmhAY_mpmnguPj7-qsu-gFqHtjguKPTiKDRTKElcI
Message-ID: <CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: fix the strategy for the tmpfs 'huge=' options
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: ip3q4rq9y7hgnkwsu8s5th7787hkk477
X-Rspam-User: 
X-Rspamd-Queue-Id: AC478140011
X-HE-Tag: 1761067522-124621
X-HE-Meta: U2FsdGVkX19cEeLUkqtx116iUhCUsfrc0ropz8KJQbI0Qi5AGxhW73fGjIsvTLHqyyHvder4deDxgjy1IIK+1n5AzRXWbYvFzeXaZUd57b3ObjkeFu+JPcqceorsMFEIPRWP575VCb93vdhSUy5wKnOU726qPi1JKgUnbJrhKOdBAuS4KAurUpzux9O+1TA4BVZtO1faUJCIljvvqvp3cWv/HrXXkHi7A9hIIUxrEO5dHJgaHdob3Tns6IkSEvfeBsLXuLVyej8T3zoS/0/+noyvlaUDjiHi1C2/hHwkHOQKvhOIuBsF4uQ9ipNHIE7zx++g7dxb67VdxUuS3PB4cdlcEbLSZ+/pQBbYjEDD9/kSuPIChAjTZtO1Ghh/G5u4eW7plpDpZraYK8Im0pgIAXqdTImpDhDje4if+SalShNHI+PtzfR5U9ONGpK8oy/tKYNUTHfOhA3ei9GdnxpW30sIgT4JerB2AM1ywOH+mocuUtYkRjwzidY1ow7PmDrEunDuiv1V2TPfNiHoOp/KSxkLr2AOMUu9RuMb2ETGN+hEDoFKMt1p7LbM3wUHw3msQfolH1DinuheUPGLlrO/41otrB1Xt0Jr+HZND6y0SzJLhmeAFlqeGwZcpcRX5OrxKv0p2AUZO0F08xwDMxNFkHQwuEhMqb4CJMyYjUGhVNEy5D31lQAnoF7qw8sGzVTA/5bZ5ZSfxeKrEQGKK0jOZ4GhZgQQOFiRMcoHA36/XEYMa11Yuv22XsOSV/dV7lYIkWH0mE+4/TRJe//FfK/2hV4jo4+0yCj3UapEA5PUeyHp62xo725RAcTFY85pz5+ifeJTiwDUMx3AqWBESX5/EBFj+HYaHGcTtucUZIoXgEV+XvoOla9PlvKU1Lo+i6x2pphtrrTo2M2WvPEbzJ5ZJWENlzukkAjxo0ySyWiHP4RbtxkjwVGw0Zo3r59lRHPHLU0YQaqihWuWqSwLA8V
 eCH9d0ox
 T2i95NdroM6nsTb4DtMb8r2AuTCRklw5+Kehic/n+QY3MEftK5rPF0N5Zqrp+XpUnI7XT0BU0LpyKsg3dyUV4iyhuVjYubOMyawuwBdYl0iwyIzL30l3RTxvx0Wxw9UGccRG68j5SerX9GHqDOZ0PAOfRUw+xHbRXEDqxaUBlv2us8UfCFHI5uW5Ng82PWwh5gzHG5rhkXtAJOy+o2T236YTW5hpXqpKcjhPYJvU16nvW10nbJA5eITjWJQzAmrUEn62T0o1+b6ug4I39LRdhAHeviuHHOL0ZAgypjdIY8F771A9/8l3Z+4rF9LepRMBKf61e0G3E/nW8qyvr5vmkFl6uo41diot4jBqAZxUV+1+getUh2SCliLBI/zm36HxMO6Yt/HUXIeedEtxzSwmhTTcipg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 4:59=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"=
),
> we have extended tmpfs to allow any sized large folios, rather than just
> PMD-sized large folios.
>
> The strategy discussed previously was:
> "
> Considering that tmpfs already has the 'huge=3D' option to control the
> PMD-sized large folios allocation, we can extend the 'huge=3D' option to
> allow any sized large folios.  The semantics of the 'huge=3D' mount optio=
n
> are:
>
>     huge=3Dnever: no any sized large folios
>     huge=3Dalways: any sized large folios
>     huge=3Dwithin_size: like 'always' but respect the i_size
>     huge=3Dadvise: like 'always' if requested with madvise()
>
> Note: for tmpfs mmap() faults, due to the lack of a write size hint, stil=
l
> allocate the PMD-sized huge folios if huge=3Dalways/within_size/advise is
> set.
>
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the sam=
e
> semantics.  The 'deny' can disable any sized large folios for tmpfs, whil=
e
> the 'force' can enable PMD sized large folios for tmpfs.
> "
>
> This means that when tmpfs is mounted with 'huge=3Dalways' or 'huge=3Dwit=
hin_size',
> tmpfs will allow getting a highest order hint based on the size of write(=
) and
> fallocate() paths. It will then try each allowable large order, rather th=
an
> continually attempting to allocate PMD-sized large folios as before.
>
> However, this might break some user scenarios for those who want to use
> PMD-sized large folios, such as the i915 driver which did not supply a wr=
ite
> size hint when allocating shmem [1].
>
> Moreover, Hugh also complained that this will cause a regression in users=
pace
> with 'huge=3Dalways' or 'huge=3Dwithin_size'.
>
> So, let's revisit the strategy for tmpfs large page allocation. A simple =
fix
> would be to always try PMD-sized large folios first, and if that fails, f=
all
> back to smaller large folios. This approach differs from the strategy for
> large folio allocation used by other file systems, however, tmpfs is some=
what
> different from other file systems, as quoted from David's opinion:
> "
> There were opinions in the past that tmpfs should just behave like any ot=
her fs,
> and I think that's what we tried to satisfy here: use the write size as a=
n
> indication.
>
> I assume there will be workloads where either approach will be beneficial=
. I also
> assume that workloads that use ordinary fs'es could benefit from the same=
 strategy
> (start with PMD), while others will clearly not.
> "
>
> [1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889=
.1753689802.git.baolin.wang@linux.alibaba.com/
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from RFC:
>  - Update the commit message.

Hi Baolin

I'm seeing userspace errors after this commit. I'm using
"transparent_hugepage_tmpfs=3Dwithin_size/always" and build kernel test
on top of tmpfs with swap on ZRAM, both within_size / always
results in same failure:

The error I'm seeing is when build the kernel gcc always fail with:
ld: kernel/workqueue.o:(.data..read_mostly+0x28): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o:(.data..read_mostly+0x20): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o:(.data..read_mostly+0x18): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o:(.data..read_mostly+0x10): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o:(.data..read_mostly+0x8): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o:(.data..read_mostly+0x0): multiple definition
of `no symbol'; kernel/workqueue.o:(.data..read_mostly+0x30): first
defined here
ld: kernel/workqueue.o: in function `no symbol':
:(.text+0x3760): multiple definition of `no symbol';
kernel/workqueue.o:(.data..read_mostly+0x30): first defined here
ld: kernel/workqueue.o: in function `no symbol':
:(.text+0x38c0): multiple definition of `no symbol';
kernel/workqueue.o:(.data..read_mostly+0x30): first defined here
ld: kernel/workqueue.o: in function `no symbol':

... <hundreds of lines of error like this on different files>...

After reverting this commit, the error is gone. I have a very stable
reproduce rate locally with different cgroup / memory pressure with
this patch applied, error logs are basically the same.

I'm still not sure what is causing this, a kernel bug or some
userspace bug is triggered by this. Changing the compiler to clang
then the problem is also gone. Still investigating.

