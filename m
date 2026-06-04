Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775EACD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 18:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD1D6B0005; Thu,  4 Jun 2026 14:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A50B6B0088; Thu,  4 Jun 2026 14:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793F26B008A; Thu,  4 Jun 2026 14:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68FB46B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:24:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D523B1C087C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 18:24:52 +0000 (UTC)
X-FDA: 84843056424.22.08CD297
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9894180006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 18:24:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NLxzxL9v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780597490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz1GvkDFt3r+PPi/7RT2S9SEefp8yaIm3TzzC0PikKw=;
	b=fce4h0YdUqBwbPWDrOO3u6tTaD1ZEawl/UW1RgTP1XuwaRXqjBeyrE3mjDrzEO8uJowx8h
	nu6ik9D5yNZEdTWp9WHmrJubaEIvRc1gEvbJdktt2cLpAb2sO7/1sJ7yY3gLEPDXCAdzvZ
	uL18viohKt/iinHEKJZEiw6f+tnxyKQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NLxzxL9v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780597490;
	b=U/N/yN2YFfyV4NJkNnAZDEt7FPYgK7w4LQviRyw1beADUu5KOI0C4beHLW/mhMOEcSB3ii
	n97cFMcIGymXi6gxBUGuXQ2Kz7zX6Q98LHY5dchQksT33WDl/AV6R0gOael10w+7eDwRN6
	UK9L+wYupR2NtitAx1tdjjGHpmFvRRA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0b1a48855so21355ad.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 11:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780597490; cv=none;
        d=google.com; s=arc-20240605;
        b=UUoSTp5c1t57h4yY+y6bUFLn+Dpf2KBXy63sbCAZ/+DF72agVBOKlKf9oe/O6RvAgO
         Wg0vsgcGQLpsVlxSAMUrlxv+I3w/iyIHv6xCUnxtRG27plqt/nICNEHmZ5isbOdH4wRT
         tVaD43tDYCEWTnBxVdhYrBcInJjlHGJb87nNqaz4EABiXHauEf47DzmfFIG0X757nKEU
         gp40rFkDhu6xLpK02CQNxsGszuSdh9i4ZPG9hOJy7xSkCz5vKHX8Fv89sdgcAtqZWq/C
         wEqi7GdM/D/Cl2yFfFuXHBJFfiDU6AdC7XSP07U2LSg5K/wlSeVyDgLG4k5oLs4MT4bI
         iv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mz1GvkDFt3r+PPi/7RT2S9SEefp8yaIm3TzzC0PikKw=;
        fh=kJj9S/KTL5Xm4Pk3ULickNL7D2f0iRMRvzvj0ADARx8=;
        b=fv/j1exCUNeEb7q9EJBGoK+mHicZGv3UDTLPdeHJx5aiVUEeFCLnOEBEQiy3f8BcXc
         0djt/JxLFOLPqH/fNkVml7m2Yhpc2E/kVzFFu3s6UpcV4J4SbJ645obexymP8vchTc/I
         SJce1Py5yrTw3jJu1IhWFTHrMXyEMeeHny7KJwet9TQL8DQ0Pfe6rGgJG09fDk2wRudB
         uOFxNeAFGNW4T2VSpQhvqKhGDHXI89FZI/VIj6Vd68YBdCyIsYwVp54ThnNn036xKY7k
         8nd98i2HfSIsj/GLy9AJUYtfxrNtgnFYk41B790DntlUv7rYPbTEFZUVCs0BLhpnsz1J
         rDDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780597490; x=1781202290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mz1GvkDFt3r+PPi/7RT2S9SEefp8yaIm3TzzC0PikKw=;
        b=NLxzxL9vXw/4RVtx5/4vWCuCTncROYJXBD1MLa7PlBch8Z4JJ1Gaa/UH7Y4YNmkfRH
         lwoutaSgaRAzkHgYkKGUgxwPX/FHZ/TFtA55JlG4FPGJNe8uQfJzpUbf5luGWQWuXI/j
         YyZiHGEb2zOHQQNS2Kni/wZNjcbEOy0p1rPzbB+Hfrqw7+y48OzBbQmuDpwbTOmT3soX
         GZLWN3MCZJQfrd6HlpHRrWYij1Qma4Gvr0e/ICxg3yZxf8+jx451pqwRZh33Bfzx15aQ
         ZpmgEai15e20FJ1uwWMMnK9gRkbKHOSKCsOziQfMfQYHt2I+tqzZuYQIpedll6Xq24JM
         hQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780597490; x=1781202290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mz1GvkDFt3r+PPi/7RT2S9SEefp8yaIm3TzzC0PikKw=;
        b=lVk2on//MLR+njX4tyN8rpBWuBgJaGQ6cN4GLiYBIcVp4NgO+CuY38oDAFR1RgtDyM
         7OZBfW0CnkxVu+r6Ak4IK2qch12f8x0HgPO8nPdub837Cm2ovWsFO3hsiunepIABcCBW
         0vt++ZhOBvP43ZFEz/K7qR8r7eZG3nP73SmJ0LL30V/LYnIB6IWtZazbgY2hoRJDuz1c
         +KdsPLd6nQTCjeQ91to0WxUVLKdS/nzWiblIkvMlCM1rix0aUUjRv5iorUis6FBiHJgy
         cLZDVfW8BAh1ND6eUYPrlmuNtjrJNwBEKmRc+ir1Zh4RPUaiHBgvZCC8TSt9N3H2OKWK
         RecA==
X-Forwarded-Encrypted: i=1; AFNElJ9cRARPIFbQ3SeLJ6U56FZV6+A8mSvgFHj/O0pXt3F5TyICWyndXHXPM/twT0/MwDcUMkML9/+8WQ==@kvack.org
X-Gm-Message-State: AOJu0YwlWDMRPm4Zo9w4RNQ4CJBy3HEJknxAbG8uY9GW2Vor/JitpboE
	QCDMqCzl2AIgnStBl4Y3fBY6Ov/LlLbNUO2lGifu6/HtEfdy9qroQw5drqJdx1pripXEVk2+7+7
	kGvV/Z/YWlFkPKy8v1tlcu3VigADGEjDOQQsxo0eN
X-Gm-Gg: Acq92OEC3KhUQI++H7fBAkNCFqm3u9LRdb927wIXrZ1SV+tPw2ClZjawPEG9EVssGYb
	IcIspZNi5SIVT1Z7CAZxnpISmjIKcac/j7YEjyJ0xL8BPfAnNGnlXWSUfpsflqC+qsZOy7zpPVg
	5IfyeBYJ5Y7Gtjin/I1Nxg7oYDoRWaqMxkhDOMYrDdZmzWBsTzmfBRFdw6DdsbNTTn+vbPPo8ix
	53X2rjoWOiyiZ2JgTrP6EXzmQqtW9ytTs1n47fA/vAoiKoaEu2mcBQN7ZvrpjSf4UB9ruo2YAXu
	a4+wtzJfLQgmsfqHzg0xZ2gFtxqn9NdhKIy3Bu903NgYyBTO
X-Received: by 2002:a17:903:fb0:b0:2bd:6dad:7ccd with SMTP id
 d9443c01a7336-2c1e3acbc73mr290345ad.25.1780597488867; Thu, 04 Jun 2026
 11:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
 <20260522131108.f972659717367c67082f3766@linux-foundation.org>
 <4ae038f0-cc33-4a60-b59b-ae86bb541735@linux.dev> <CAJuCfpFdbq-0SMVg0i5Fg+gQONQEKTL-N7QC4cyCr1e9oVimSg@mail.gmail.com>
In-Reply-To: <CAJuCfpFdbq-0SMVg0i5Fg+gQONQEKTL-N7QC4cyCr1e9oVimSg@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 4 Jun 2026 11:24:36 -0700
X-Gm-Features: AVHnY4KsU8yEoJgCLNo_jZOZ1ytTBNw47Zvt-iCaZSiHNSip0BLl0JGiQwhbc_w
Message-ID: <CAL41Mv6=cRMnRz5Lqa0nz2H9EGw0mW1GZAByba8sD8kVvCj-3Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D9894180006
X-Rspam-User: 
X-Stat-Signature: fzwf5tmkkux95w8sms4jaoj4gh1hjpxw
X-Rspamd-Server: rspam09
X-HE-Tag: 1780597490-171413
X-HE-Meta: U2FsdGVkX19LBPzS2Bcw0ixiFQWemcOThQ229OgymoGbcftgP7fzbltLWbEgipLVMwL20so0kBMMo3EFN/WzIHktYOWt0kXF38o0J1ucN4K2s81dx+tMV6WLHs8BasTHIjKa7x5yR/wYhAysEr5Foc24l06l9+RrO4KY3VW6rF0LsoB5pldncXWLg4u5dxcpAfDrHRlrtFrGvqPXYEjkmDiEXlPAcSRoey7q5A4FwxUyvreJ4Eug5DbA1gRmS2xJ+ZFtZjVMkktFPT0sR8/ZDC+E+5LUB19lUUousNUqZL355i080iqDyr+06wUEeZtIRQt+UnjKRRuTZMYw/7444lm6s8ueAyyH3mh8cKLoXIyTinHDa1Nr+6Qlcx5gXzgixHOhpFsdv7jJKhnbthc8zkJTO406dvCNpbEzj2v9n5wEuHWzl/SdDKPkbcoLsv5yhjmPaKlq8o2B7j2Japxe2GxBL9RKtPEafEk8tQBoDqddnOab7RjDl63wXzGdXdFggRGuZLuAH3qPHyRQ8TyyXSCgsW5oGwC4g4BKft4bNuTk6G6WXNyJ49dc3kQOaHNxG6S0OjGVVl9ixTenvKS/Rkqef53O7kHH0OTj+Tfjr3cqqrzREbVmQofbRbox6fQxQsyIUhphizOpJw/vpQAnvTuCOUtDWmLRYahmgei3GiWIzYx7hnmnlKBJ0cWBVQI5KnD/eYNnLS6tAF12wagh4jvfxbCkwmnYFryfPxUmPL4Ujfj1u+LXABA6FWiJoT9UBOxWbhBqrwNq3SE9Gran1rlzAAMQHq5+2gQ0n7wQhYoFKylFUImNE9VCn1Wz/6qNrVLAMy1nEfHY1Bpjm2o71UxT82vxnz+8ngFf7yhBhJjKjRNLsVNbCMJCYAwqorNTRGjjOswRze/YhGWqotivO6fK2+BUdwTLkAf3JNsrz9XZa7O55eBOib2N7LoyyXd0VBrhMvqKeL+j84v54Q0
 C7HWlbZO
 5Kfig4qQ8u24nJ4LSi8dVm1Vxp73+ALGtgRUrSeqjX+4oDGZ8bMyJ/ajnbD7ZdC/Ava/jS3mRbCPi00KoDntiLylG37M3CY5BnFFhCSwwnjUJosrwYpuPaWpt8oBZJFKR7Iibfj7e7+NnV9uSvsa0NRGTqSGz/qhoaNSCV/mtVXXrkgXFheMdS8VlX8LG0uoo9Zy8IJljPSaVxXWP0oeQ9zZnUriVscl3RsNvdhYe8mBLCrCTqgtgRaSCFuKNHhQMiMNEzFIx09yYJ3mMe64aDKOid7UfWSonrrDj9c3bAVQ8jucu3SY7PyiPqBJRjaSREtmluBuUGDvgPQ1B6nMH80aAkx6HQm9GycMjMl1zLnjo0UfKlv8s47JOhq60TO36vm37UQWKyAzhhPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 12:51=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, May 25, 2026 at 12:33=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Andrew and Suren
> >
> >
> > On 2026/5/23 04:11, Andrew Morton wrote:
> > > On Fri, 22 May 2026 17:45:32 +0000 Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> > >
> > >> Currently, memory allocation profiling data is primarily exposed thr=
ough
> > >> /proc/allocinfo. While useful for manual inspection, this text-based
> > >> interface poses challenges for production monitoring and large-scale
> > >> analysis:
> > >>
> > >> 1. Userspace must parse large amounts of text to extract specific
> > >> fields.
> > >> 2. To find specific tags, userspace must read the entire dataset,
> > >> requiring many context switches and high data copying.
> > >> 3. The kernel currently aggregates per-CPU counters for every alloca=
tion
> > >> size, even those the user intends to filter out immediately.
> > >>
> > >> This series introduces a new IOCTL-based binary interface for alloci=
nfo
> > >> that supports kernel-side filtering. By allowing the user to specify=
 a
> > >> filter mask, we significantly reduce the work performed in-kernel an=
d
> > >> the amount of data transferred to userspace.
> > >>
> > >> Performance measurements were conducted on an Intel Xeon Platinum 84=
81C
> > >> (224 CPUs) with caches dropped before each run.
> > >>
> > >> The IOCTL mechanism shows a ~20x performance improvement for
> > >> filtered queries. The kernel avoids the expensive per-CPU counter
> > >> aggregation (alloc_tag_read) for any tags that fail the initial stri=
ng
> > >> or location filters.
> > >>
> > >> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> > >> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> > >> 2. IOCTL Interface: 1ms (sys)
> > >>
> > >> Scenario 2: Compound Filtering (Filename + Size)
> > >> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> > >> 2. IOCTL Interface: 1ms (sys)
> > >>
> > >> Scenario 3: Size-Based Filtering (min_size =3D 1MB)
> > >> 1. Traditional: (cat ... | awk): 21ms (sys)
> > >> 2. IOCTL Interface: 14ms (sys)
> > > Yup, textual interfaces aren't fast.
> > >
> > > And ioctl-baed interfaces aren't popular.  One would prefer to see an
> > > interface which uses read()/lseek(), pread(), etc.  It would be
> > > appropriate for this [0/N] to have a discussion of why that approach
> > > was not chosen.
> > >
> > >>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> > >>   MAINTAINERS                                   |   2 +
> > >>   include/linux/codetag.h                       |   1 +
> > >>   include/uapi/linux/alloc_tag.h                |  87 +++
> > >>   lib/alloc_tag.c                               | 303 ++++++++++-
> > >>   lib/codetag.c                                 |  11 +
> > >>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
> > >>   .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++=
++++
> > >>   8 files changed, 918 insertions(+), 2 deletions(-)
> > >>   create mode 100644 include/uapi/linux/alloc_tag.h
> > >>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> > >>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioc=
tl_test.c
> > > At some point this should grow user-facing documentation, please.
> > >
> > > And the right time for that is now, because such documentation is
> > > useful for code review - it makes that review both easier and more
> > > useful.
> > >
> > > Sashiko had a few things to say:
> > >
> > >       https://sashiko.dev/#/patchset/cover.1779471082.git.abhishekbap=
at@google.com
> >
> > I notice that Sashiko has reported a pre-existing issue, as described b=
elow:
> >
> >
> >  >  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > This is a pre-existing issue, but can resuming a sequential read on
> > /proc/allocinfo cause a use-after-free if a kernel module is unloaded
> > between read() system calls?
> > The seq_file read operation updates priv->iter.ct during allocinfo_next=
(),
> > stops iteration, and returns to userspace. If the module containing
> > priv->iter.ct is unloaded while the lock is dropped, the module's codet=
ag
> > memory is freed.
> > On the next read() system call, allocinfo_start() with pos > 0 reacquir=
es
> > the lock but returns priv without validating if priv->iter.ct still bel=
ongs
> > to a valid module. Does allocinfo_show() then dereference this dangling
> > pointer?
> > [ ... ]
> >
> > This issue is unrelated to the current patch series and can be resolved
> >
> > by reverting commit 9f44df50fee4.
> >
> > Therefore, I have submitted a separate patch addressing this issue,
> >
> > which is available at the link below:
> >
> > https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@linux.dev/
>
> Thanks Hao! I commented on your patch, please take a look. I think
> there is a better fix.
>
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >

All, just wanted to acknowledge that I've gone through the comments
and will be sending out a v3 patchset addressing them. Thanks for the
reviews!

