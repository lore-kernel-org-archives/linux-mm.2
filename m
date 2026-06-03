Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907C6CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0694F6B00AF; Wed,  3 Jun 2026 15:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019C36B00B0; Wed,  3 Jun 2026 15:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4AEE6B00B1; Wed,  3 Jun 2026 15:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0EE56B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:51:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 900C6404A7
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:51:16 +0000 (UTC)
X-FDA: 84839645352.23.3CD9ED1
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C3A640002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:51:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G95l0/Jm";
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780516274;
	b=0NOvzYuVIQMMQVtHQSbAfPuK2GCFP21i8YbqTWoLAk6oyTav6MCrXUXOxo1wYCEYKJyq1T
	Cb9iKhM8VGL6pDCpEWE/tUAQ6fUs7GP6n65tMF3yUTlaJFy6l2gWl9gnvD8nzLIPiLSpmj
	HL+88HjY4QYehBgQLrN5vb+xqFntCE4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G95l0/Jm";
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780516274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mydSJ6eCREv5J83WgrREA+4y0Y5cOb58d9V1q4tnNnw=;
	b=Nb5rzn/UPO+ASGyvDyPTaU+tz7+GLgZXjmNH+ovn5nUV1dZvLlh9FcghXuVq/si9VNBWYV
	TIxqdpLkwr/r/9PraC49cWE3cU0Jv1H/VDmb9NC4M9hewiB5sAvB2YOuf+F4LcltVQlS0N
	4VgR/Kn5Ey0paRqoU+nLKd138QevKwY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so5341cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780516273; cv=none;
        d=google.com; s=arc-20240605;
        b=W+TkqWGBCArJTwM8Hy5hXsLuz0gxrZyKsqT+eeoxFugp3OiSAmVLfnkPUD4X4n2YDE
         ktj2eX4ihOUnZ+UMF1gWDdL7cF+fs+CjtAKHDY9YHBqlHyLCizpFiJOXOREOdbPfLbe3
         Lpf9AZGGYf4dYsm8uxXP0J8epSSxpKMW7nnlV+wzQqSWDCZxinpcTCuhrjRl4zpJ5Nez
         pBaQgJKm4e8ksholjs13DK/Y5PE1U76rm+NbI617z+/l4succ+fbPtfCz9v/v8A73mGP
         0xbk436BycvxI41MSdp7vQnTB+5PrIbfo+HcYOF1ui+v6qs1KpYzAssqQ6nhTY5x3z4G
         hgMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mydSJ6eCREv5J83WgrREA+4y0Y5cOb58d9V1q4tnNnw=;
        fh=Q0eA3VRqRn4ABG4zHniD0797maI+s/wiNBkXBqB64s4=;
        b=UNTZ8XGrHvhW7zSDqcDUUf2tFEN9rPJ+VlGBKQXTHrCYimED/JR748y6YT9t3P6Fti
         RAPGmX26/CcuVbw4tTvM4GXjbGnpx8xhv8MBRIwukzNNZuLb5cL43a2fO3Vzs5pHYTec
         ETGSAZ1Dj/fefA67uC1bmoI/5JoRF4Z9rsLrZRxJKbM4HcLFm0JTlCXBcs57dujJ+Jeu
         HYI6sADWDW8JK4RWd7kPg02qzsVPi6OUcYuqMIkYIYH+sSkN5Ot2cNmQMZ4cZpJl38u8
         /5n5UVa3ZdQlABOzBpCs7gUQYt96vpkKJt+lz3xoRx+x3qHTvOYoy2JPyQvUKIwZbgat
         gqdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780516273; x=1781121073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mydSJ6eCREv5J83WgrREA+4y0Y5cOb58d9V1q4tnNnw=;
        b=G95l0/JmzsMVNztXJzzKuWqdEvF/WAls1a8RojZyeypbbAH92nSSTflJ2ghsUZsJTs
         hoI8JqntbcGgirwQFkFSF4UZ3wOJ3C4ChvFdBF1p0pK8399JiY6mUQu4CpoPTxZxCFr0
         /EpS4XZbod5cmElcyAkt658MgiLdxl7vT15t0GhNLMZGZZngdYL80K+lwsJgxFAWkv/8
         MyxT9Y5wgEDc1YVhCfGaCV+GoZywZI1X4aXIE85B/O9oFuUtZc31rFx74SGAOwL9Eeth
         tUZRd/HL/bV4pxWjx/h0cF82cO2Q9VTgRJVOST86+wmM4VAbmQeWKqL8lSsQbbWnwJ4I
         G8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516273; x=1781121073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mydSJ6eCREv5J83WgrREA+4y0Y5cOb58d9V1q4tnNnw=;
        b=Rtlpd6ThYN1UHGuOVwaLzeR/kySGyy/EjKsPTUHAsRgrnXRPWN8yUsalgAEQOSlu2d
         pKBDAIpk/cii2DygK+IYrdSy1VFitYB81X+bVTALsacMreu0GOdEcIbXEKvI20DZgZCA
         NcJPsUFGD0lrWNg7yEsw7NRgOlacQGuc2eM4beuoU4xBV1TrBStEtrkx1SIoX9LHRZ21
         BgTKDnJdIpHYQe6Wp8nLWOyubII6v2WlwtTXbDshBdkF6CkTz36PyxV+Ag8+KlcrUbbf
         mCcrkoKtiVS6jzHuigtZipbPIf3NbFrbPdZDxSpkPGlQhT9X2vxVs5rJDKwGj+gCLNKt
         d8kw==
X-Forwarded-Encrypted: i=1; AFNElJ99D+dMZxeTNgiYi3UdOXT1QG0coGvNGUHty4vJjrpVJWNiuYQbcB2ypYEizPTXza2RxAN95P011A==@kvack.org
X-Gm-Message-State: AOJu0Ywv5DQlrYdfUsqyOcp91LP3oRy2PVNM3BcVHEykcLw75wxqc/wL
	v2ZHwbNfGRbjETJH4WlJKMBO+gcDpVHcJvBeemBsEjRbEt+e5+IDKGEWCV4+//guZ6apuPfvmdn
	R6970SHlNLc9jwcP+NIbsFPF53poBn99MqOZG453a
X-Gm-Gg: Acq92OFVSXIG9e/yBs27Z3czCnzApd6enXOuPGglW9ns4kOWti7WM53EElB0oa96NI1
	DSBwLqT6quC7ZO0kAB/IKOkRkfvF7sYk6ZuIB7afVvU/pPWgEhI8zXeoF/ZiKNwWcsmVZJZNM7j
	EdS3RMqKGatCOliIz6Cit3Isx3QkvTxCSzSE+nrg77C/1FZVYNmq5Z1ThAklzQW3I0P5/lrMqD/
	jSUeytba4RiD+Vh5rMJF5SHeRTdXS4Jf/rf0u3DrOkYhenehkSLnW1/U4qMJLcEGEZAZm5GbgT1
	r05dEjpWSt+HPC9LJDnMvgH3gO/3M/2ZnAsFEX0Zc9HbINIi
X-Received: by 2002:a05:622a:1911:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-51787a7423cmr531751cf.13.1780516273058; Wed, 03 Jun 2026
 12:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
 <20260522131108.f972659717367c67082f3766@linux-foundation.org> <4ae038f0-cc33-4a60-b59b-ae86bb541735@linux.dev>
In-Reply-To: <4ae038f0-cc33-4a60-b59b-ae86bb541735@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 12:51:01 -0700
X-Gm-Features: AVHnY4IYfNFfNCUBiZmze5PFD-G7KhptyH4lRMaqQ5BQm2joDQxcOESI7al8bZY
Message-ID: <CAJuCfpFdbq-0SMVg0i5Fg+gQONQEKTL-N7QC4cyCr1e9oVimSg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C3A640002
X-Stat-Signature: 5obxm4dq3oak5xyk4zp1cuj4hhkc7sj6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780516274-503440
X-HE-Meta: U2FsdGVkX18AKUvKmH/JdQuMkiWNEVDzws1f8kvDw0hzS0PYzTZL8r6RaDrtB5gQ1L0XJnucNX7SHN4rEqi0V85bwZ1BXBsh+77yebShL5gPxvqINSPNJTigzeUvVBwNG0rseINLEPHx3A8F5WIc1gkEfkgmQoVNMrEiP+10c81xP1OdVofZcO3wLp8rGsr3YtIxGk5uzNaYhqmyERgD+fUtn+UhYKyXhblrkOe9lqIhrWd6BYReKrlqaVjyV8md1Sq5umemnjyVQHEcxadqygiGn1EpPgrWOg6JOfNeycFdmmYwmL0nZ/IMx4WCbbgsC3WqNqNmYLGHBg4H49DLEklhS+6T+/1lak702T14hdZ2xu11UG/7ZGFnLyGe5k1fr6eXL7FLl6bWHts21Kmq4UDxvSqBsK0ITjWellKqaVYOihnIMe+DxgRkJ/0LQFfcSSvXdfzwGJhz0AQFs6MkQEZqw45I6u6sqH/oGFuZgba5X6ibZ2fqTCQV6RhBWu9liOsZZlZikojP04koKsPeJndrQgYdNaXNPBd+PcVunbrJOBEQvwDoAe0/rg3HkXkHMrAZomAkjrHxFZBosdOsX4zAEMPnY4/xGFTWvLhlHIL8xhc0jVnk0Dv/qx1YplfMJTrYpOsI4DiabR+6bxKpBa2O0muymwi/wPF0Yc0GUQbdewzz0JkSx3o5dPZ3gLht83YUKL5LxWcuRTO0BsitaMl0uORT39XMG7q3OsM4MaJkU/8gtDTDZnypt05a+pfl0Y+FLGbyKpH8efn1fDv7JZ2vfIYlUDGxNrhiD7xLBNHC8HVuZ0ejTLHEoMPA1mJy8BQ8djNNKW2Kvsvij0HD2y+zk/648EpVYBY5hunB8cBw3CKvyGWmDspDt9OPr3cwGQkw1Uw+UcP5xWIb26kwQ/q/s80P0kpBMhb+YOtSh+FEq4i+3t+HiDCqnkNUgyqUKHPbyVgkrLG1u4IzQvH
 w8lWdU2f
 /1UT9TtZ6Q2TLG/td66X3GALktbeTulPsNVHCWgaLFyo1pGkOufs5zZoDj69CzleUJWgablu26QTs6JdtbD+EgE73TYxwN79ow5Cm4spmSn87qYS2OhVVWyw0cAYi0Cd37OjtQ9vZ0v6KNpc9JCbvAUIioOrZUnp4rZR+Ud4aggdxhl7I95+9F5mXddvUjqgtOUB0edULEKYLoKW0jdf6PfkoyWPSZJOCEHG5pK0CsSMwRSjk0aZx/3WXep+4wNs/36A3rmvqLnQTJgmkmK28pkYKg1qXGf7pLtKhn8miK9jk8m4tSzi8rUsSYuXXN5IFxvwBQOAem7rm0vhEIzGS5WGV9J7RXL90Kn1PyDBwizdIZh4y298WWwuMzddeCrwFTFuhJGJKhVip1fE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:33=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Andrew and Suren
>
>
> On 2026/5/23 04:11, Andrew Morton wrote:
> > On Fri, 22 May 2026 17:45:32 +0000 Abhishek Bapat <abhishekbapat@google=
.com> wrote:
> >
> >> Currently, memory allocation profiling data is primarily exposed throu=
gh
> >> /proc/allocinfo. While useful for manual inspection, this text-based
> >> interface poses challenges for production monitoring and large-scale
> >> analysis:
> >>
> >> 1. Userspace must parse large amounts of text to extract specific
> >> fields.
> >> 2. To find specific tags, userspace must read the entire dataset,
> >> requiring many context switches and high data copying.
> >> 3. The kernel currently aggregates per-CPU counters for every allocati=
on
> >> size, even those the user intends to filter out immediately.
> >>
> >> This series introduces a new IOCTL-based binary interface for allocinf=
o
> >> that supports kernel-side filtering. By allowing the user to specify a
> >> filter mask, we significantly reduce the work performed in-kernel and
> >> the amount of data transferred to userspace.
> >>
> >> Performance measurements were conducted on an Intel Xeon Platinum 8481=
C
> >> (224 CPUs) with caches dropped before each run.
> >>
> >> The IOCTL mechanism shows a ~20x performance improvement for
> >> filtered queries. The kernel avoids the expensive per-CPU counter
> >> aggregation (alloc_tag_read) for any tags that fail the initial string
> >> or location filters.
> >>
> >> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> >> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> >> 2. IOCTL Interface: 1ms (sys)
> >>
> >> Scenario 2: Compound Filtering (Filename + Size)
> >> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> >> 2. IOCTL Interface: 1ms (sys)
> >>
> >> Scenario 3: Size-Based Filtering (min_size =3D 1MB)
> >> 1. Traditional: (cat ... | awk): 21ms (sys)
> >> 2. IOCTL Interface: 14ms (sys)
> > Yup, textual interfaces aren't fast.
> >
> > And ioctl-baed interfaces aren't popular.  One would prefer to see an
> > interface which uses read()/lseek(), pread(), etc.  It would be
> > appropriate for this [0/N] to have a discussion of why that approach
> > was not chosen.
> >
> >>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >>   MAINTAINERS                                   |   2 +
> >>   include/linux/codetag.h                       |   1 +
> >>   include/uapi/linux/alloc_tag.h                |  87 +++
> >>   lib/alloc_tag.c                               | 303 ++++++++++-
> >>   lib/codetag.c                                 |  11 +
> >>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
> >>   .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++=
++
> >>   8 files changed, 918 insertions(+), 2 deletions(-)
> >>   create mode 100644 include/uapi/linux/alloc_tag.h
> >>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> >>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl=
_test.c
> > At some point this should grow user-facing documentation, please.
> >
> > And the right time for that is now, because such documentation is
> > useful for code review - it makes that review both easier and more
> > useful.
> >
> > Sashiko had a few things to say:
> >
> >       https://sashiko.dev/#/patchset/cover.1779471082.git.abhishekbapat=
@google.com
>
> I notice that Sashiko has reported a pre-existing issue, as described bel=
ow:
>
>
>  >  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> This is a pre-existing issue, but can resuming a sequential read on
> /proc/allocinfo cause a use-after-free if a kernel module is unloaded
> between read() system calls?
> The seq_file read operation updates priv->iter.ct during allocinfo_next()=
,
> stops iteration, and returns to userspace. If the module containing
> priv->iter.ct is unloaded while the lock is dropped, the module's codetag
> memory is freed.
> On the next read() system call, allocinfo_start() with pos > 0 reacquires
> the lock but returns priv without validating if priv->iter.ct still belon=
gs
> to a valid module. Does allocinfo_show() then dereference this dangling
> pointer?
> [ ... ]
>
> This issue is unrelated to the current patch series and can be resolved
>
> by reverting commit 9f44df50fee4.
>
> Therefore, I have submitted a separate patch addressing this issue,
>
> which is available at the link below:
>
> https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@linux.dev/

Thanks Hao! I commented on your patch, please take a look. I think
there is a better fix.

>
> Thanks
>
> Best Regards
>
> Hao
>

