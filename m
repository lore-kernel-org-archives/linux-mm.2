Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19B6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2423E6B0150; Mon, 13 Jul 2026 12:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2188C6B0153; Mon, 13 Jul 2026 12:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107026B0154; Mon, 13 Jul 2026 12:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D64D76B0150
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:43:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71D051C001F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:43:36 +0000 (UTC)
X-FDA: 84984324432.06.9D44FA5
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84F0180008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:43:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bj8rpjhU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
	b=BlokV6Gv+HLgEthvAySPIBd4cUrHRAG2u6lJ0RmtOApCcl7lGDGgT11hYDTmdeKTX5h/ie
	WhEe5amdZvlaoEPnC1H8eXSL3F3d6QJhvk/upgGIJu0i5i3Jla+Swl8hWMQeXWN3c6rR32
	2QQ8CxHUtDfmbbZjHGChNZ4jOMRrCi0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bj8rpjhU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783961014;
	b=WbKKeaFoQ4tQ51lH0jXsjH90U6e/zrj4SNQ76ZUiyO++7TsH2ZDrTts2saCnLG9K8f/F/a
	1BGw6NEQmviKyXjphCIyKDAKEhc20PwkH3McwKYNmBzh9VF4fi2nS466dCEShUEs7wcas4
	dzA5e1If4L9rU7kaEBJsDDy5QhY3V3E=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cacef7d299so192285ad.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783961013; cv=none;
        d=google.com; s=arc-20260327;
        b=GmKvZx1LLfzRiMgdHH1YkzpwUqyHSH6WdiRS01xcRLoYgzLv6l4QH7+FB7QUZsEvWF
         6K+7P8pJvXtzCa6YIwkCqULVxFFi7AvCsBrzSrN2Uz0TLK1D6CHx16WKmMVlgbnVYR2+
         +msVFgrp4JtN7GRAEh+r/C3yQhAMbu5IluAS6W7pja413/xixJq/vTRs/y4sJGFxz19v
         BD9cgHk5Fc2TLeRhKwA6DQ/rMSwMFOpXXu/f92B1j9sZSFV58yPZ2HHXs/KypEOLxwhZ
         We2SYCsCSW/Bnwuv9KlS5l5jOGk+ACZ5AJVF8GiPWn4pcMFHBBzAysvrkSdZftKOnv8F
         3Obw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        fh=FcS8ahLiHClVs3bdG3EDjBb20PodD8THD0nbCM+z1Ms=;
        b=XMRLgT7iSNf59RmeFXV2JPStJUSboV/hIjdmstcHBchm4kHer0Hr8XNtgsPKHWIjPi
         zd2tTcfSIMuGxReuteZBUT/P33CtbSdTCtV4NbaInMlDp3LwGcg2xe0Cc/i/lFQYa2hz
         GDViWJPn3gTd69ASE9006NbOVHRqNzQC6i1lWmcDwVdXrTSRvZDcqIYNMUAajqTV9LfF
         wqzjF603qJIIk4avLyxDaoWrRQUpjzVaMH3ioeHMp9EM9roDRqy35Z4tY5aUmE/v0tul
         Cihv/Nc0PM8npgfUOQphPF/m8HB3yromVHaAAwWK6I7EC3/m2oqK2HLNdgTfSlB7CUa5
         Rcew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783961013; x=1784565813; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        b=Bj8rpjhU7MPAlHRgYZypmCRg7Pzl+4nvtKx8F+GKfxuszSzAxDv12Fr+XNI8pmacz3
         ZLOMJduT2ghaeQ17STLGjZ3zfWvH6wk7Mop++XjtnfMKmxnkvR2HuQLTXt1lasbRQJIC
         T7H5X0aen6CnIIBQh7BdgXR5tgY/8mZrQjsJfH5Er8MK9pLALxbBNfSXmeWe6G6hcuf2
         WuZ2l0aUrbRYMyu2qQNpd3yK5TlqCjKsoGIPjbhLGhcPJwaiIMDjpJn/5ktTjgTt640V
         3W3oKF60fDjNx2vm52dig+drQthmkn+/idGTasmYM0MbCeVEHoyItGiDpnKyP3Xjpbpb
         893g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783961013; x=1784565813;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g7RBjI+3c4wbCLyC30m5N44VxvHGqMYoVlsOrdbCo2A=;
        b=ZQJwXovC8jOzh3fX31+BQsPnX/j9JzBK3DP5tMsq8eJkm5sOf85sjHn/3nJHO6JFX8
         6QeHcHydOg742X4s6BBSDf5hgvHE0v1tFbmOvnKL6md9Rv+nx1q4GcTStIjaC3VG/lCu
         eVGfhHN5nWp0PGNyPqWcbPV1xNAXSKPStSMzKFZtJNVxB8sS78YImNdbX93jJJRfPdJv
         loIr8dAgL0B7DLThEcTMKzdTHI3ZzYY58gagf5tA+CJ6OWavcGA70JDCaFlzYI4p0Tn7
         ZPz132Rv14oDMjUPtR29q8buj++QMyJ7hejmSTumgURCqfQqFGbFhZ6aBwY3lFKwQoYH
         A46g==
X-Forwarded-Encrypted: i=1; AHgh+RoHN0UBMSTc9n6BsTLHNbgVOw07ceDtWCd1+M2T6GRCBb9K6tW/oFnjMSLyJr7PIricwKgHwf2EjQ==@kvack.org
X-Gm-Message-State: AOJu0YySQ9RHjMgQGhQezWdlxuwDMOdkCAuKfSWap6co3oGaj/eI2tc7
	GGH8He2gPIWltiO56si6nLIGM4qf+foDcDuPC41F4ZGgN5hkllznY+JROmgQBXUoOWSyEUVHD5p
	38FEtH9ribywJd3lOpO0Rgsqt8i5NkKdjIFzOZR8LgE3+k1jm1kFzN8Vu
X-Gm-Gg: AfdE7cl34LD6WacBcFumZWTPA/3pfejhBUgyz1Hn1fQH34rkq8fmGwyk5aSRpsVJo06
	6I4GxuCWD7l27eV8NHGS7UJXQfm/YZr694G8MfJNNtOj/X7kYFz8qW6kx5uILlepG/oMls1BDs6
	elks57+zsTdiA4MBS9eoSUHxAsTa3l1Fo5KEhGqB4u0G0Os6Tab1EXW4JzMryNtc3bH3DWvprXo
	M6+bs9hYeHVg2/2vLF0edD0IFVMfVHUBtn2zYUnouYQUdYSzK326Taw7eNmRpaFa7mAk8kqdmsY
	jQpdBZAKMzWiRuwOO3iaoyNlz26FrzLp3Q5jzQ==
X-Received: by 2002:a17:903:3884:b0:2c7:df7a:859a with SMTP id
 d9443c01a7336-2cee1c0873emr1602925ad.15.1783961012878; Mon, 13 Jul 2026
 09:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
In-Reply-To: <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 13 Jul 2026 09:43:18 -0700
X-Gm-Features: AVVi8Cdf0fJO40B3Qj_RdzqPZ1-qc6aBPc0lKEpRA9NJUP0hxR9kO-yh2KYqMwk
Message-ID: <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Suren Baghdasaryan <surenb@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84F0180008
X-Stat-Signature: xnno8jza7qc9ymopxqbypkjkiwoo4i6e
X-HE-Tag: 1783961014-984466
X-HE-Meta: U2FsdGVkX1+iY8EaJuOM9di2/oGU4ZioX2W7Cyc8jt6do2uPaSb4LSiwbeXUtgBvOyJwVU+vrLtJm1ZTqszQ2ycMhedIWXvwqrFNgXVWdmfEaC8jtjHcCkiKpM1Odo6FMY2WXpgUA7pnZJJ33mZe64IV6xSNFHNd+Mt4brmxh4LvK6RHpN2gvsc9cu8AoOP5OIG76FHUjyagM+PZONoTL84FiqDLmreiO0ZcxMWR/LHfj+y1/C170o2IS7y13eJVi1SLZSkSzCd7uCRUToV9KL4I7eBzrtBm+xFLvpOEuG0WsuCfMG05qdxRdYKNblhGTWW3PYWi+RLzz2KYXFwZzDvKbGFM+8LUzT73JiLCMwdzG1d+lVg0mObY7FJpdUtLzk/T2Lrfb0BWONy7JPRGLsQxkL5qrKNMEZSM1+45cLTjmwNrmqpody2dTphm58HrTQyedzrIhAROavfRO3fUd20JP75quPHJGJ/on8e4d2mHFFJgFkjd7zZJJJo4MdAoB90oFjmbKJVDgKtkBEv+poMFbhBXylsh8W/DQaa7l/7uGarknH43RlRopXICAL24Q+KjkrH1NPGtBb5TKLjB0RrCosl/GPnk01nMyLcwM5IokDpsB8YUpzLp22Y9eYKe8pb8A3groo/+YFELE5iKvRX970J9tzwfQzUIIonAm8cVpQlFq40AG8wtY6IwRl+/KyRd1cjyP2XeE8OSAVUvEZDlvFQzrLGCUkqxEiw3ogQaQc9WxSx3985+5hVdsDbfLP38RDoFwBo4iiNQtnzTGlgZAgqYdc+ielxqVtKLWRbTHk2RN19wIaPTIx81O8D4LYQkP+5zVjBxvm4LN2I3uDeT7LwcAm6gutvsmu/FP9RXsR50/rmUC0FLrLs9m5MaUMRLRN2B+bh/TuFBRGFecqyaHDJEKOAQ6hlZJSgLC5IkfSnsYLXDt6mYvDcbxjmIoxwPMIvxSXUFKWwGc1m
 7OvsCYKe
 IkIrdJlcCzHAde+nePJ8ANAAGWIjviC1A71q4biEEJJfFK29vOfGm96cPFJ9i9JWam383WpPXwu4JgpABRQ5ipBhrpH3j4yIr3YlwB5oayhDJk4aRTiEMQm/0uKFaD3tYGD/OodPTO6G6CwV/Fi02MfJk7D2oeOJFJFgGnxFVzmEQlNmfi7GdMkUdkg2C53pAcpRtQriKks3iGLfAMMS4aBWl9f2tyA+UY3+DphNg28CG/0acythXmexCDhNsvFRkhcMu+LyP8E/IgzKwC1G5M00RK8MEvjAbe7jXnOpBzxRl7ufJchtdZ86e5R0/n79LbRV3X6qSF42DdyBsfAUK1wFGb6roMI7hzTX2X1zSh13+BayXNRYLVLvinpjnDavDJAViVR6VjVCothOWCizLvPSnQYHCy1BwK0bZQH3e1mS0LyxLZS2W+JOHtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

I can send a fixup patch for this error if needed. Could someone guide
me on whether I should amend the original patch-set and send a v9
patchset or if there's another way to handle this without sending a v9
patchset?

Thanks,
Abhishek.

On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   59e34180e138a293260301c139cf7ee800978533
> > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: a=
dd ioctl to /proc/allocinfo
> > config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-c=
i/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'comp=
at_ptr' [-Wimplicit-function-declaration]
> >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)com=
pat_ptr(arg));
> >          |                                                          ^~~=
~~~~~~~
> >
> >
> > vim +/compat_ptr +356 mm/alloc_tag.c
>
> Missing #include <linux/compat.h>
> After adding it the error goes away.
>
> >
> >    351
> >    352  #ifdef CONFIG_COMPAT
> >    353  static long allocinfo_compat_ioctl(struct file *file, unsigned =
int cmd,
> >    354                                     unsigned long arg)
> >    355  {
> >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)compat=
_ptr(arg));
> >    357  }
> >    358  #endif
> >    359
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki

