Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8535C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1144B6B00C1; Mon, 13 Jul 2026 13:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB706B0119; Mon, 13 Jul 2026 13:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C136B011A; Mon, 13 Jul 2026 13:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC4D26B00C1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:20:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BA344013E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:20:58 +0000 (UTC)
X-FDA: 84984418596.19.72238C8
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EFD1A0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:20:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX29kEnf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
	b=iKEpTPVqrB05svKjpwvbdofkLWsFCFkm9/QmAE496pFqS5LlfAIYRz+YYxi2lSF15YuQVl
	6AZq2XLiBHvYy1roVFGptS5d+cdln61sSxvkhMFlzjH21ZROanI80DiWgUOMS/D9xzjUF1
	NwnzM4XMMLO+jz3tNTLIS/TkQt7sYM8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX29kEnf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783963256;
	b=C1uwgh55uKGydmFG0igkWCsfGOVeAepih8cQ520rr1Wr9VowXDslw6wlbypoLK8Mp2FhbF
	tFAgcaoHuEnXI9w2WvJdWXOzF4dD1vnejtjSVe/VqTfE2segfe4BJ2zY+LPlnx+MAhzeXA
	dJe7xhxVnTumtjLvh+eIcUPAY4tvwsc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cede6375caso9595ad.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783963255; cv=none;
        d=google.com; s=arc-20260327;
        b=o1ozfV+l3ho+mX0bf4REHFk+2zNx6vBItJUX7J+qKnfm4Zt7iD82Wu30lYVtI3ALPS
         kv9V7bQuYhKOgcIzDd8uNKoa1LGd9sgpzqyweDZCCXIJUMHxirBZLu1Knx/S4Bca3b23
         SWxiZcw96Eo8Rmk9Jc8NTboipyyc114b6DYtsK8aqnDe+EcH6DbD22vVU6+gNIIaYBMU
         lYwJSmMDYKzld7+y01+/qkn8GuYwpoEFOVMCeVR5uYCJsITHlBKxpiYc0m+w/q7c1X02
         RGRoFhw4Tkuudq8yPBtEgUVgbH2tu0Ve0Jzt5bjN8CwOqc5kfWp8tfWY6cbJ9cTUKD3T
         KY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        fh=jalEhwSng3xVKBlLzP0dWqrBlGl+JUF35ZArHRt2Kp4=;
        b=kcgDr7jsJLc6Z6qP9+10z9gAq5TvQIibavoGxjjKCMAm+MbwsoONAG5hmOONtwxnEx
         Q6aD0w/vFzszAqO1TU2WRKa8yG7NI80QeTHt7wG3b8XbpBAYzkS4LAvJ4bLiOslZeGy4
         xfTNyXGCYogHvgC2iskhnZEZe3sMLh/KpOotoMC5r257LzMB14ZNXiaWYfU3vmhilgLB
         LtbX4nxe9vAGO/UhgsH3SGHdIWXC/c9lTcgwSpX5xBLXR3pThzs/tGDoEO1G7pUpZ/C5
         v7PMCtr7h6ledVdP4ZQQKRHxMh2FgeQqEQeJlbOwN/Uz3WqkX4L/ZIZDvXErFH7wiCfZ
         9Xdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783963255; x=1784568055; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        b=uX29kEnfIQmIQfZwGx2pNFS3ZOL5LhzOFIduarZFEuIc0twFi7yKdXcVkxx+a6ZlAK
         VRz4sFhoyH/fxYimte3eUURcrJAd2qBDC4Oszv0rP2MHqYrUlNR3soyh7Jbo/VIxuE4E
         p3JvisRD1J4WjlRywi5PB9xXELY/dgZMBXv8CCv2pnckfWEjrWZ93QiSqnaDCqXn7cUE
         NEAYBQ1FJ8chn6RMy+5VkQL8Am5D5CrnjIeNMyW6e9fsi+R8wf5nuivGjVvGVtbh0acJ
         ktCulMA+ECdqWJkyawZE0MYXSikwkvxSKOqrQBTUdUKGsxcCytedvry8UeK6FDHwKB/7
         0NUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783963255; x=1784568055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Up4enbVP5XhzSIUsHA2kSerHZ2dcsLiJ/grrTWqZXk=;
        b=i/H1tfpcTbvb5qmaSWdR4VrbrQlLZ5SvS/Thl9nSdFqTD+EvnOguYtJBi9LyqZHLYW
         5jQaXl9UQgb1A+6ATV757jIMY3EnCLFicYDZe6xRkej/YIa82tJAQmJZ5faAdVyREQit
         J/Xe6rgd2dTxrvbDA290ioXPgEO/8ox2GQQce1/yycINF7FizssEXXotTOXVJPBDAY2K
         K053uHEscAcPUU0xg7QDXXs5kwpGepwFQW6wfOisEY88JHynKF1OrTbmUJYuP/XAuzSa
         zptZileflGwvFUTpqKJwOCakw0g4epQ7v/c+E88mojgo4bb7GmS81uIroVTyMHXNmocY
         Nv9g==
X-Forwarded-Encrypted: i=1; AHgh+RqQwqRU1OL4xwA0HYraO8eL3SP48KmFXxslmwhCHkaryhz63wyzwaD7XNEkCN3W+vBXFluYkgOd3g==@kvack.org
X-Gm-Message-State: AOJu0YxiTO8Mh2Xlv7D0iBPj55DnA1oZnmnXb0G33edOCA7rCCjd08Tr
	w7DLxNA7Jlr0f2txmbG5Nrivg5uzy8or6sHXUBH0TjvRc18M5s/QIaHbGHEDfeFSIw5W52Zjnxd
	eBJASmRuiTGmKq8LYvhsU86eWmbo6grrUeFsi1jgI
X-Gm-Gg: AfdE7cl3UCgZTN2MnCbIdCwWuN0uzYt9yWeLhpAec4F2aSjnYy841xgD77q/xorezY7
	m3TqT0TBNVROaBbRpfLtN8Tjnbn05ZqoNXd2NQvjG+4UvuXaGqAwkEAuctfbERWAnLvjiDguUHG
	hugiuFCRdrn00Y2ilmY6XoooHNMqqqX5b8leYlSV75rN294N7YxKDE3S+DwvGOsxV9YjQroMka2
	Hnudx39P6TEU5A7rfRzedw99owZtC2eT/ReYG9efrMdVkumxgk6q7fNAujrPO5Gu+7IDyT+SdYo
	MI1fKLVYjQoowPDNXfugYQFk
X-Received: by 2002:a17:903:3850:b0:2c7:a13a:7fe6 with SMTP id
 d9443c01a7336-2cee1be4f23mr1770825ad.10.1783963254512; Mon, 13 Jul 2026
 10:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
 <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com> <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
In-Reply-To: <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 13 Jul 2026 10:20:42 -0700
X-Gm-Features: AVVi8CdocdmQKkxGo8IOucf6phPMN-TtFmhTpXYtX5usitAxYi5eJViaBHUqH20
Message-ID: <CAL41Mv5X4tNvRcP1u9kEe6LKMTYpeS93E4oCBE_3N-iUgVLO=Q@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Suren Baghdasaryan <surenb@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4EFD1A0004
X-Stat-Signature: u4dmg9jsriqd8eqhdd987xwcas96urwj
X-HE-Tag: 1783963256-935730
X-HE-Meta: U2FsdGVkX19kFifKmQaqXzYSz6/BaX9oNtLkEpqucDpY5V1J2gjSP0KqHslCjsQIkcdPTDLdnnm+aGgg8EsZqYDJmT43G38kJ7M2Dhod4e2g2BXNENK6r7NTAYmsrz9l+7P8tF4kdN04aaM1DH74Ju0AiU0GVJzQ8eqAf+b0e4zVeVryikleFT3RVnjAmEIDZ7UQpOUGtZdkpc1ywyiBUr4ON+X/mXCQfdOap6GT+CNYvscrxMikNTjHIZMj3OqjzS+EqPIBzF4gD+ZsdGNyrkHEV3wD01/9Z/LP0tGR1q8+1ZWFB52q/brA3gWys2qfjf/sAfqiEX9Pg4ioRfWOv4G0DAM9vtX1VTq8fCsYtz+1fxebeRgGyXTsNpjeiloXecogne3MMO2HDKyN0EwSc+ch6CzIZrIIQEUHHzSTSkzNtak+lHiuRWDnZsOnhrnJ3bjAQJyQrHl8J4ePowlp3/KaoYUaysN+eAb26ybS3gAx5pVVFYm5O5iFC5Ty9FnAS+FaRU7MseTfMuU0my0ehYcQPC7Ss7MIQE7GfRGgCgPoBzah56b2sYCGeYDVzTTOb6K5wy9CFCdp15A+GRbro5LlNnAK8yvJDnPHMa8aMAwF9GurKwKtcOio7glklvvk0jkTUBE/tpUYlA7ydqU7D0e3oMuN82vOwzAKPW4TyGUxkJw07l1erH9nhw7NivN8zTvqsw2M8Sm0v7olpEQ6efZNnoNS6H9LPJyYJdo9rsG5PCCmRL8PG9OKJuPqp1izl35BAlty+rhP34idKGJEppRs4YnTSAKirl/sCp02EnHJsEJJ74UxqG9z9+W70lQWPu2+P8WBKZENnJd42+Id9t9n9B3/PAkwamQqfz7AhO7vxKElpKIVCtIHWV65rjWfJNSa3M7G4aTr3HrRTVXIpyiBCoGhLOq52SReeHuJJTv8gMM7MI2n7VlcJm2mAa9t0dxJw9hLut5cO/TRgOv
 i6khADF9
 ClkM53Hy1KsdOxJiEHiTPCm57ysrx3Jp6mjWI4EjNC7g1dBoRUhYYyju7CTt/hCTxWvHTQeexjJPfdgU4r4Ok1Hd8FBRZrt9zPY7whEuknYZQNtTJzJGT4DYsvAZsE+BepGnG0GHA1ZOn1bT4khrhqD5/uJrwCrdfcwScNXA00oTccLLBFzA5USe/4La7cp2J5+mg+un0nlcCLlmCEXiYHVKRZfGKIRw6gDXVU+ka/u+9C1T7SYA4+H+lVhG6SI2Kc+eoTlWeYFHdWxIPwHpPdUIRdykzD8R8OLr26tGaF6cz2qgJ4nySKzrRb146gTIHMnMR+mj/UX4ecavY6KSumPFej7MvBSTMajNkaGgt+gp9y5uuYxgkLTph8ZHEu+s43G2zii+g00EoBwfu2SorFJWEEl+VusnLG+xT70t5ZAVE+Ckpg4iobW/YKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:15=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Jul 13, 2026 at 10:13=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >
> > On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@g=
oogle.com> wrote:
> > >
> > > Hi everyone,
> > >
> > > I can send a fixup patch for this error if needed. Could someone guid=
e
> > > me on whether I should amend the original patch-set and send a v9
> > > patchset or if there's another way to handle this without sending a v=
9
> > > patchset?
> >
> > I think Andrew already fixed it up (I saw an email flying by but I'll
> > double-check).
>
> Here: https://lore.kernel.org/all/20260709171454.58E851F000E9@smtp.kernel=
.org/
>
Ahh I see. Sounds good, thanks Andrew!
> >
> > >
> > > Thanks,
> > > Abhishek.
> > >
> > > On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > > >
> > > > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel=
.com> wrote:
> > > > >
> > > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.g=
it mm-new
> > > > > head:   59e34180e138a293260301c139cf7ee800978533
> > > > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_=
tag: add ioctl to /proc/allocinfo
> > > > > config: sparc64-randconfig-001-20260709 (https://download.01.org/=
0day-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-=
ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > > > >
> > > > > If you fix the issue in a separate patch/commit (i.e. not just a =
new version of
> > > > > the same patch/commit), kindly add following tags
> > > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjl=
GhKK-lkp@intel.com/
> > > > >
> > > > > All errors (new ones prefixed by >>):
> > > > >
> > > > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function=
 'compat_ptr' [-Wimplicit-function-declaration]
> > > > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned lo=
ng)compat_ptr(arg));
> > > > >          |                                                       =
   ^~~~~~~~~~
> > > > >
> > > > >
> > > > > vim +/compat_ptr +356 mm/alloc_tag.c
> > > >
> > > > Missing #include <linux/compat.h>
> > > > After adding it the error goes away.
> > > >
> > > > >
> > > > >    351
> > > > >    352  #ifdef CONFIG_COMPAT
> > > > >    353  static long allocinfo_compat_ioctl(struct file *file, uns=
igned int cmd,
> > > > >    354                                     unsigned long arg)
> > > > >    355  {
> > > > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)=
compat_ptr(arg));
> > > > >    357  }
> > > > >    358  #endif
> > > > >    359
> > > > >
> > > > > --
> > > > > 0-DAY CI Kernel Test Service
> > > > > https://github.com/intel/lkp-tests/wiki

