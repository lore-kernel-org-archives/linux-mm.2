Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 780A2CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD85A6B00AF; Wed,  3 Jun 2026 15:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B618E6B00B0; Wed,  3 Jun 2026 15:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A546B6B00B1; Wed,  3 Jun 2026 15:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 913E46B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:50:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A1D4120415
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:50:01 +0000 (UTC)
X-FDA: 84839642202.30.61C5D0A
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D26E20003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:49:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iIOBJAGM;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780516199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Wm9+xx3S7bwmxXSWwexU50eaBO95emwKPo2CvJTqv8=;
	b=DiUNUm8Z4w3DVPlbKsD+5kzZAu36xT1MNd37oGjn0lmbnpIk2XMI/Xt4ALs/iCxCtcIXe+
	lv2IYMLvMubZH4XA4OMTxci2FW/lrnJkhm9UdwQdft6GFHue0Bpxhg1ReZ3+hjHes/cUFV
	0C4W9vuFXiIVghkDesTj5n2LC1ZEJpk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780516199;
	b=flgVUlw4RBDdkt10wplvPFV2Q49mBHTPok7nucO2f2A+vUSUYIAqsIWYMkH4jsS3TF+CcO
	I7RllBSnuto3HegWnYJjoRDZFOG31Xd1Zn/n/bbjcDVSE5qdVj4oQwGsKZvjKCCZiHsnWe
	QPdifSwgqELV3BscCQDGPG+wpV1EEkg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iIOBJAGM;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765531803so149201cf.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:49:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780516198; cv=none;
        d=google.com; s=arc-20240605;
        b=jcmE/VFrLT5Gc1QkS6+uV54iH6g+2M0Ccj8s9nsIEoSbXELgnEwsPhner+WGlsMWfa
         1WN3Fa1r4pN+NsQNrBRcHY5H7CwY9hYgGRktE94k1m2zikkJeNSdOHUw7vO0AlI0/Icg
         3adxlK1yFWaXZjfn29mOBdYrbx5czKGjDaKW3NYfVCgwccW/Wm6y6msaLfbRd5bSbuiD
         Vjo6qgpkI9pDd444raFEvqact7I/RUBQzuS0UbwbngxiWM5dH2OG6V5FdDaBLx5Dsn0O
         9Gnr/NSVUln+wq87i05NbUDeANV2gXkyUB8fkj3MOoOof2zZ7vlsiTTzCG12CurqjnXj
         ROkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Wm9+xx3S7bwmxXSWwexU50eaBO95emwKPo2CvJTqv8=;
        fh=8GsLghJMH0d6OTU1bTA7c9nxU8VDKkBPQINZRsyJUWA=;
        b=fu9vbDhXx4AI9y/VlBFhmY0CIt2skQ3k+y4F6lloK2VaNrBU1fQ7SlmZalEbZzo6gg
         qr3anhP9vKHLhP05Kv7ANR1FoRn7Ww5Lj1ZamfyZDbo28GZXYO4/A4a97xFnTsUdlVpV
         aH9yQE+YI0Fl8PqhTaTVF885WDUbfqwyPvebsyb9DKnr2D9NEBrwxoBYVxFeo08NyPf2
         wL4HxFdzYzrL8UqWgpVxgL+M72L7TNxy/sXK5sB/Ej91YKz9Au8XfTlnwr0C/EACDQaS
         grgrd+NnynH4vRqYpe2+Unu9wfe7OaWy225SmNFOJ0hV68MbWQeENJnu2yLc7mKAPkEa
         4XfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780516198; x=1781120998; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Wm9+xx3S7bwmxXSWwexU50eaBO95emwKPo2CvJTqv8=;
        b=iIOBJAGMnLc9HabWePOR4mf/reNftDYUBj2CNvOV/3mofG1C5dmAkR8Xvgl4t20zrY
         arDNftiXW9gy3s7ktIQXGhijMX2Z9Mo1d3uQqK93d1CkxchIGEg+A9XDLeep/vyBIA98
         Ec08x5rF8nHSjNi6efksyXLaHrjqzT3c3Tm89X7fQs98g2LflVy7VxLzka91cKwxWrgB
         Jc9EewQmpdgJYqmDC0cgdTcJMVJg7KeyEvu5+HTiCrNaQLiesJR6GdUjXG0NNO9UMXFo
         W+81uO7Vh/tve5vDGXexqpg9rsbsUZSfvorFxXkcjWQ45slwQdvRnfmsxiiUtl5hcaXj
         4BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516198; x=1781120998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Wm9+xx3S7bwmxXSWwexU50eaBO95emwKPo2CvJTqv8=;
        b=owYKhkwLCzCM8jxiuFNZB/ph9xXLoSAp5X7y7ez6jbjdgZhOvqNKG2j4OEkZbAUDIy
         kniukT+BzTDllPUoD5ulq6lV9Os40eczCRqILtEH36X/d9qKBfzrSiWYPwPkYBLBezub
         CK3IcAAOhUdvbm+F6Yfqt1Up4YYGehXpbgznTQyzJPvJyZ/OjqfEhBhRWjuADfCT3fW/
         HUr++E+cKtCebLoVL0yeSftFhQ860Y7Tz5t4wZwkNrg2NtwTAjh4oY9d2bz5ZPpyj0xE
         FAa44vT7MwCegD/P6HdjTLg9BG6nI79WOLDfksrTsVacUUbsKblk2l5iBsctRrroYqio
         8uEQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JaJ9mIQF+uzAJe3cd4Sde/MCtt0cx4u7dva94r9AFuBBmR6NyTT5sXvorTDRphXZsk/rgip6HBQ==@kvack.org
X-Gm-Message-State: AOJu0YxS7fwmD/K0DfVI+E8IAwQLjVCKrfFGGpSJ6vLzbnWqqF0HQjn5
	OLwhCD2k08A7D+tKgWDC7ymBG87Lhci+ZnQmcksTgYkpnhIYw+zfPZ9zOPwMgtjvDg3UTUn6Kwx
	ngDKwjDFseaiLe+W+qOjHjzIGH4TvmoLC/q9qhSqe
X-Gm-Gg: Acq92OEaOGG63rtYRH4U6VO4I2Tr0hyPLo9Xc+h89Iyvl2dIzpnUVl4RSVBof28zLUT
	tTfLx+qYAGrIEd177oP0QcEIpJj6w8EIXNOh8F3O/8EkaqZ6NgpYMYH3P3eiynqjSTuRuCupVMp
	Z1mzosRDHUT284OFmME9GOBXcfzMHi8mRZ0jdlOcWMrvhksG87jdatkgvg+dP+GUqXyWkUdVwd5
	x6uU4cTnqrdzmdTmMv8DODGyOwEpHqy+SKS9x38TUzCuxx6U76rsp7QlYalsq4X6Aba7dU++k2A
	2neJ7fuCkE39MgGIHwP42vFalHHlnEdaGGoVFiggT9yHAeQl
X-Received: by 2002:a05:622a:30e:b0:517:6488:904a with SMTP id
 d75a77b69052e-5178789c190mr519281cf.20.1780516197590; Wed, 03 Jun 2026
 12:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com> <20260522131108.f972659717367c67082f3766@linux-foundation.org>
In-Reply-To: <20260522131108.f972659717367c67082f3766@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 12:49:46 -0700
X-Gm-Features: AVHnY4JK2eGu6vAIyV7j2iWie90EfZmLlPJI578QpZKL8AELxwAYPqn3IE5wdxA
Message-ID: <CAJuCfpH+DQePnCFy5Ro-yKMYQsizQHPuY25m1tWgzGGg05xm6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D26E20003
X-Stat-Signature: aqn1inogfshqocp4pszs1intdgfxcto6
X-HE-Tag: 1780516199-95515
X-HE-Meta: U2FsdGVkX1+rjRMzhbCAtYzO4He+RCVU4qEJA0keMjwMfSkfIFpfHHPHXV8DBQYPw5DaP/wrrXxYAfCLJTndhSiiN2wlirrDVV+NEEDCzhgV4vzd02xHGs7SM8dkoou4Ki/BH12omdAGc9fIkcYbHIQDthf+PSVG7VZVm2xBnMyRwihOdsvL6a+MHMQbn/4COYzEvjRm9/MdfK/Z2aatq/xvu2VX0rhklr9mm12YyGAMS/cIC3RnEL1IVfKTBjXk7f8aFwsjAxjg5K8wAekOqRyCpsSuUFYNziug2QJXbLknKk+hi38UuoLdB4F6+XUJ4xEyZGfCHLj1NjKvjPRJrgKv7dHTu4Hxkxvc5K7Pn4EgwxvFaer22HT7Eg/qE3HGtCvtzV3KEqexbXHEh3oyWxkEtwcbCx+VObiK9A2SoY/bvUfrtgsrXP4LptsBI1gaqRCCnz1/7oPEs77t/0CN/WGqED2HM0GzRoPhFIllmhVpRouckA9M/Zh8RmxcHeK5Jm5iKaZsRP+QSBrQRRAuOVh4J1Ckd06HY12SOpY9QnCLfa1w4UpDmUSlN0KlKSab5n6APffyGqLOcJ36k9bZO0GfVmEU3jfSov53S/eQEZBZmORblQY9MpiV6eoccTtFxFMdT9qaZ1OZPKqFFkgp/pFjsNNSNYJwFr73LA+QcQL6Gs2hvyJU0Y1vrNQ3YmaWutFE3rWghhppOk++rYyWlbq9fVA30GV8iVjfw91NGn3MJ0e+Ppwt+ETv5L+hD20LFgQZycJIsXjgZ7QeDgcxiZ+L8e7qkP7ZtrAzx6z/6MzXzxhjZ0TmzhpLthtXm+gEJhHj8s6r4CHvE+YeIN75i6mqgooHx2xCP8t1St0EISBSc+YKRsJdJYt44WVKzi2WcUzX7sEfJRtB7Fq6Uo68z610Z9un/Z5fJuUZKhzU7eOnv5IEel43wFWlpx+mI6Es5HP3HSwdqrY0LvXGMCm
 wev05sri
 a6cuKgO1nVwTCbYfjyHSCfNxAqIYV/hwWcdvcf539/1fkdz1PJwmkYVr6JHzOO7cnddN/BbeW5V6Lu9T4sEfvAq8LzNzNBxH0EhSJIU75xDxu0GF9o2XEQpENpcr4b4LIK8gfWOarle4dcLwXhKK7DyrrFb1sNdhLg0WLVmXxyRTmH5TVDnMdSTI+9i882cKWl4s0jgQPyDKSdgmPGygmRqVek1VCE7sb3UJEpOGmaMHvcv17/Gle91CNZY1LchJwTACV/vO4Bfptjp9KOoq+ElwV800mBGE2hdZWdpm/oFIr/ZctSY+cGtIS6x2vND5mEPC54+hjOJcrOGyv8D4fK3wY8vO0cQfY8fe/do9nnZkJJkCIL28PbcSRN09ZEdhnzXi/bhWsPML/KdEirLoVSmreGZa9CVt4Y162WEPoEZ8rG8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 1:11=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 22 May 2026 17:45:32 +0000 Abhishek Bapat <abhishekbapat@google.c=
om> wrote:
>
> > Currently, memory allocation profiling data is primarily exposed throug=
h
> > /proc/allocinfo. While useful for manual inspection, this text-based
> > interface poses challenges for production monitoring and large-scale
> > analysis:
> >
> > 1. Userspace must parse large amounts of text to extract specific
> > fields.
> > 2. To find specific tags, userspace must read the entire dataset,
> > requiring many context switches and high data copying.
> > 3. The kernel currently aggregates per-CPU counters for every allocatio=
n
> > size, even those the user intends to filter out immediately.
> >
> > This series introduces a new IOCTL-based binary interface for allocinfo
> > that supports kernel-side filtering. By allowing the user to specify a
> > filter mask, we significantly reduce the work performed in-kernel and
> > the amount of data transferred to userspace.
> >
> > Performance measurements were conducted on an Intel Xeon Platinum 8481C
> > (224 CPUs) with caches dropped before each run.
> >
> > The IOCTL mechanism shows a ~20x performance improvement for
> > filtered queries. The kernel avoids the expensive per-CPU counter
> > aggregation (alloc_tag_read) for any tags that fail the initial string
> > or location filters.
> >
> > Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> > 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> > 2. IOCTL Interface: 1ms (sys)
> >
> > Scenario 2: Compound Filtering (Filename + Size)
> > 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> > 2. IOCTL Interface: 1ms (sys)
> >
> > Scenario 3: Size-Based Filtering (min_size =3D 1MB)
> > 1. Traditional: (cat ... | awk): 21ms (sys)
> > 2. IOCTL Interface: 14ms (sys)
>
> Yup, textual interfaces aren't fast.
>
> And ioctl-baed interfaces aren't popular.  One would prefer to see an
> interface which uses read()/lseek(), pread(), etc.  It would be
> appropriate for this [0/N] to have a discussion of why that approach
> was not chosen.

We chose ioctl because it allows us to filter data without aggregating
the per-CPU counters, which is the main overhead when reading this
file. That's why we can achieve 20x performance improvement, provided
we do not filter based on the allocation size.
Aside from that, I plan on introducing an additional ioctl command to
enable context capture for specific allocations.

>
> >  .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >  MAINTAINERS                                   |   2 +
> >  include/linux/codetag.h                       |   1 +
> >  include/uapi/linux/alloc_tag.h                |  87 +++
> >  lib/alloc_tag.c                               | 303 ++++++++++-
> >  lib/codetag.c                                 |  11 +
> >  tools/testing/selftests/alloc_tag/Makefile    |   9 +
> >  .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++++
> >  8 files changed, 918 insertions(+), 2 deletions(-)
> >  create mode 100644 include/uapi/linux/alloc_tag.h
> >  create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> >  create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_t=
est.c
>
> At some point this should grow user-facing documentation, please.
>
> And the right time for that is now, because such documentation is
> useful for code review - it makes that review both easier and more
> useful.

Ack. I believe Abhishek is working on that.

>
> Sashiko had a few things to say:
>
>         https://sashiko.dev/#/patchset/cover.1779471082.git.abhishekbapat=
@google.com

Ack.

