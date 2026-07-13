Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FBEC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399396B00AC; Mon, 13 Jul 2026 13:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AD16B00AF; Mon, 13 Jul 2026 13:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A046B00C5; Mon, 13 Jul 2026 13:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF3A16B00AC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:13:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 420B212011A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:13:56 +0000 (UTC)
X-FDA: 84984400872.23.B6C01B7
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 557FB140007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:13:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DFTRN7Uj;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783962834;
	b=k1QOslkaDFKTe5J2tCMWRZbCY4y8nMw57gmsSQP25fn1Kh6CsETwUWEkkgfEs0iXniKOsH
	mNlMvkOokWp15/ObmcWFC6yg89WoVCf4QirGmAEL7rvgB1u6J/l77B8YQpcSoAL8ZkZyz4
	hBhgC0U/ur48T9J+/Vp/KuWhBgmMDzE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DFTRN7Uj;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
	b=eXDS3z6nbOB75W45Oxd4oigN+/kqWmM7dMEay7Js6WefYYPusDz1chtHuE4rADLxSar3VU
	T2s6sKLmdfKJenxq/EM7gFC0lLSpGM34A4Ey9hp10XulGfK2yPr9bEgjM5nUBVOH3DUR6D
	GIbuqcq9JKf9ImEgHt3ZLEToaQBBERc=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10e86e52so9981cf.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783962833; cv=none;
        d=google.com; s=arc-20260327;
        b=drgvdCgeM9uR8eprWO21BSB2gObGdvKpU46sEeZuzXwX9s87na9K5g9rMZQ5blbwfV
         ySycOCggfEoewvYLDVou6ylEJMSdWCzR5PVu+bptKZjJStJM4KWzClrQbG7VMdaBl+dZ
         nNeTR0q48VOTXkgg0+NBJ3F9yygKnLo+MRW85gA3Ctd9kiCC373XQ7bCc0TmvS6sJ3ud
         JzO7I+/kcxAPVrC1bgr5PO3GgVhyPqtIAZ2YevPQtiAHwNUcTNBs2axnZARjMdgnQ8LK
         EA7kQhmGJ2BEXa12gEuobiHizRwvufuu8Ln+mGP/XkzDdfRzh2ohZmZ/wqqzpMilmIhC
         kaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        fh=OpPOThAGuYmN+/0GVV3BiPdiQr7Tsz+SO6GV05ZvN2c=;
        b=mq/LBcUMf1Q6kbqE21hHTa41s1cpvhoSReNVLrM2kcdLBjNaJMmng0Wff2Rhn8sBl4
         qDbvY88yjsS5ZVTCMj8ZczajRAVN2OADdlgkvLtCdCwc+WlKSya4PQ+8uGVJOk2gzmas
         qoDEJPon7xbEX/xEisSNcSss5BA0+/Wt/jBXn7/cNja1az03Lv7NdzOnNO9r++8oGDuu
         6hqg1yhj80Kz81/UUYuelgbXdjv0P8RgicsI8nuBfcgsXswj3YFSdlwWrjyTC0TNUFNy
         MxK42iXEvfzpyKUT4ZfVgT9a/cEEk8LqZBtJPGai6zuvEQyHkxnSuQvrioysrnMhOmm7
         beRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962833; x=1784567633; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        b=DFTRN7UjE/i9uL2Hd772kucL7NTcyWu3eI0AkDorAJfevozhWIWuGMDy7W6vnrHpbo
         b44jw41s3UvEwaDxOgqUNGK1v2hyk+Z8EjjgyfHRm+Ch0RsZP7Slie6rTB0AzkrBUDDf
         QMVq39U7O1uhDzvVjs3AZvvy4szemVox1ZAY3HXZvyg5EhTKMAr1gEjsBcBNWmCapUZp
         pLWwzx575wYmjuMP6aaVfBeOGFD5iFstcOToMxEX5PQLroF54n0iAsCNRn9gm+UAgP/W
         Fk+mEMXLbNI+L0kllvOwRorTKozZBUCotopV4X8mw9t5uDcpshl/OAYfAVa9t3UMb225
         oHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962833; x=1784567633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DD5wqd94WlUPEbfxha2Dsl5QwxgMVxPOf/Hd4g6KPFg=;
        b=FJDm7Oky42ZUHDxTrqIqLzVBbTF2FMT7aKBK5pcChaTr3IAgGdvJjZBdvOhcINQNR+
         P8+cPX1RMTrZvj+X8g7SA2doEXy52hxR8oJm2CD8uaVfu7uv3n7n7LuXPh3kkD3y2tGV
         eVtpQ6SkrBKkzAm+E1XrN2kWf8ogcBUf6QXNraoByxjf6OvVTc8IG4wwOYMNlqsdX45H
         CL6QgPqwnteXKb6uGtLFLUlws/CQx2x9vyFdrFpTUx5AE+jM6PwkKw04MoVxAquaLDfm
         qxDOrCK7t6/KCl3VCvmkdnbOYupMNRmHrlGirqZbQycboRsVi98cVVOSC7Mood2lmIHQ
         XUJg==
X-Forwarded-Encrypted: i=1; AHgh+RrmDDXEBbQ3Nawe3vgvjfoEh+G9QzqBEWlcgZnvIQmxL7ws5ygzZF+smLMuZKOCwgGDiwDSFqkvYQ==@kvack.org
X-Gm-Message-State: AOJu0YydqBYTmiBag7t9h+449tau6l5nDBMhTtQPmHf1VsK94MPCoAhH
	x+KlkuajuaNIqJz+w6YNcYIu5e+fhBg1xrksx2ILa3kHaeV7/TwrOU1QmWB8jmp+tkxfgd8jJfr
	VB7bEZu/UAY0KLh1+xP+2ht9stCGbTfF8JthTKePE
X-Gm-Gg: AfdE7cmmBKK77dm2QR5eutRyMm6z+xJv+Oxuvaasv11Gclj9D+QKK9ULaf65m4O+zAJ
	HjB8jqhpijbFOl0OJDRLvZoybtDuIFemZ3Z1eM3U37OMIZ71m+TVb69lyKcPyV9FvJy7bgicsi1
	HFL4imUyt/Rwh9ledR/XGBptIYj2pUh1YT/3oBUptpBnDPfSXfIW4EUmAZJwb4k1HO2vsPt7aDB
	RF2YQZTStrvyfBSHc32hgz+rx7k6tLF5P1AnPtSC9S9BiNjoNIdBpDdNnzLRDv8GQIf97M=
X-Received: by 2002:a05:622a:5811:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-51d7bcdc629mr5265721cf.10.1783962832725; Mon, 13 Jul 2026
 10:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
In-Reply-To: <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 10:13:41 -0700
X-Gm-Features: AUfX_mxwf8jEAJ4-Emw6NQ7o3A5xX_dOnGVyXZPm3JwYCxoc_8oz7g9QKalCMCc
Message-ID: <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 557FB140007
X-Stat-Signature: okqgpiwes1sgryme48xz9dt458u3uu14
X-HE-Tag: 1783962834-154273
X-HE-Meta: U2FsdGVkX18YlIHmr+nCKNSgeRAROrCrqcfFvnAK8ecdONc37IIC3TTY7oswUWX6ImE818BwBQ1uI9YEUL9hg6DQdKFPYFgPFKTCvvTuhK3WZv9hJ+WFGNmN2kZlUcWeY8C7txgOScVh/yvi4uJLCARaeIIjRFcBjGtlmXAt4Y/5uepXCJrtAQjohETpZEYuLJly7mNKsOn7oFpXhJUtp0JjacHWRdv2lRZg2ffp7ij9txf6ZPMUJj/3Drsqtvi7pzqanuI6pGRpv6YBoaHfEvkzKAlJTPT3alqMRLjncDPc3jH7RwwAJiIv46Ptud/NkI+kFEt+mYMgKk3siD+2+NGi9tnqSRZcY5AcSVLxjmmXoZolWXjM5vB4iBulhwo/lWR3ENhKsEqXs2/PBBEosWaZwqcX35CE5psyCG6QULeDLJFUUJ8Ij4L9ERJeZI8izUJ6aP/EPX7UdpO+AyYGzOydBn/DMBkx/WD68TYg4jpecmsG6X8JNIk6j4kQD9QDE26714rubIEPog2BZj324GYuB+ScrXWxYVjVwwi/eIwkdMtLo3VlbimzCgA3A6LBDIaKFt6ZkRe9dC09fH9MbYsotg7lGBnSZdPK7MJLCWE0K4FABHrGzof3SE1cH+AxWD/hzC2Ukb4xRMcH7y8ofWlK2LH2npsBI2R+XxjOsy8jXD48EQHDm9H56ebnqbt78QdeRYCa3FXEhbnIncyeWZm8q0kG/u9ryPjULeVoGaKjBqSRr0fe825AO1qI0MNB6Qw/VqFsb5ZJC+D/Uj464Jg0675KEIpq3LtSDSga006fmZ5y37JPjNDynG9tGcRZpSQZ97ud9PcSW7jUk/V6J/eVSA7OPwGlFgfkrJyWgN2edffzYhYO+mmwKqqgbuJpsWmIoafiZ8iu7XKXn4dxZbCZlpSM1MOHQx/WR8rKwmGkKc1K6YyTQLEo2mfImikPZ2r5ckhKa5h/YdalJL2
 AxvCUNmJ
 kRrtKOOd1ysvbpma6LSUK5TOgVV/HHfaUkBQfupBgnBKqNEOIdFRLBxHIQxJ984SAtKlik9s1KkAdGCRmA5Vr8lJz3tl7/s2KkCrhhk2dw3Fa/AJsi2+X7Z4s+36mLefsXG8tIIz6X1VqkApeGwtkHQ9UA7s1eJo6fXzbtqco+V90YRpe9FXVLkWwxViT+RgcSPiQ1SwYPljJTJdYVRo/RcalOpPuGwmwt2qMIb49jZhZ/dMTUQYuQqUOA8Tscp3p4yMB5NXgI199MWTAKtq19M9PHWaVOBae7OfBF+hL5LG/cbCBgQHmvX8XQNdVmUdYgywzTMBZyB/9dBNYDWxLsw7WF9uLD7QYTBFWby6h31TX8ijWyoaaGBdQWoeo2+vw49y94/6NKdeAcN7nR0c+BqQbYPZq89t+whkrFrjG0wEgyVpXDsLxZy98RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Hi everyone,
>
> I can send a fixup patch for this error if needed. Could someone guide
> me on whether I should amend the original patch-set and send a v9
> patchset or if there's another way to handle this without sending a v9
> patchset?

I think Andrew already fixed it up (I saw an email flying by but I'll
double-check).

>
> Thanks,
> Abhishek.
>
> On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
> >
> > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com=
> wrote:
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git m=
m-new
> > > head:   59e34180e138a293260301c139cf7ee800978533
> > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag:=
 add ioctl to /proc/allocinfo
> > > config: sparc64-randconfig-001-20260709 (https://download.01.org/0day=
-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/a=
rchive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK=
-lkp@intel.com/
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'co=
mpat_ptr' [-Wimplicit-function-declaration]
> > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)c=
ompat_ptr(arg));
> > >          |                                                          ^=
~~~~~~~~~
> > >
> > >
> > > vim +/compat_ptr +356 mm/alloc_tag.c
> >
> > Missing #include <linux/compat.h>
> > After adding it the error goes away.
> >
> > >
> > >    351
> > >    352  #ifdef CONFIG_COMPAT
> > >    353  static long allocinfo_compat_ioctl(struct file *file, unsigne=
d int cmd,
> > >    354                                     unsigned long arg)
> > >    355  {
> > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)comp=
at_ptr(arg));
> > >    357  }
> > >    358  #endif
> > >    359
> > >
> > > --
> > > 0-DAY CI Kernel Test Service
> > > https://github.com/intel/lkp-tests/wiki

