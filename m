Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D4AF4BB93
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 22:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A436B0005; Tue, 24 Feb 2026 17:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7CC6B0089; Tue, 24 Feb 2026 17:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2736B008A; Tue, 24 Feb 2026 17:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCE696B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:16:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E9BC1B6BCE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:16:24 +0000 (UTC)
X-FDA: 84480759888.22.883F3A1
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 85A8D80014
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:16:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4HU6WJrH;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771971382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48FXZFJTw+6x79fJ7a6Jy6tjuNMBhw39wfTzGL1KEH0=;
	b=uCbD0RWLQ7oCSFSPb1yH+B2wMxY3B4gJrjavGkxd6W45J++FY0oUrhpXMM7HE4TWOrVVpC
	y/aZgUoYFVIDwRhvrgw9jwISrJfYWpK1qeVxyRe9OimN1IyQ9mKyylscN6FcIv56xSFu8R
	+33xe1A+x+yzRvzpmnRqHbkkJE1259Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4HU6WJrH;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771971382; a=rsa-sha256;
	cv=pass;
	b=ymfepbam/F5gyCnPkFVieWLbmwJfSD1ivi4gHsNepJyH7371AVR1u3ytyJDwO/b8zlBA44
	SrYDGsgr9b1FDZc3qe84hOS/mUrIvKKvt97Q7NOPvxXCYkI5+gmwGSrM0EnDdc1P9Ppwo6
	PbRLq2fax9Cxa5yGFf3a83/6d+cxieU=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506a355aedfso136881cf.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:16:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771971381; cv=none;
        d=google.com; s=arc-20240605;
        b=ixF9WO9loYoY9SbkHz9NtuTglYgOuzl4rJjG39hbKGLfVRA8B2aVt5iCRFxeEhmWNY
         w06MboQ8B1H5sYSm/+XRPjWrGOfjWtlM3PZvXeszte0Pzfu8lydiUfpXaLyYkrUWdPKK
         WRTZJZlj4PVHwwGAuRHQgoVTITAPxv+j+1AyY5bYGRXr9UhY8cZEPhzyKwTk+vLXlOhH
         MDyMCmBmdzXQGwHla6TqjipufEiFjg26tjMXIua/6pRFb7MxUUz+l5PZ/pzM0zdYjKTH
         w6QPHVfgO82bzzEMCYf1mJvTVJ4u/3uzdJYnBreuuiVz7iQ8WEmKjOnE5Fb9l+AQ+8Zc
         6r7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=48FXZFJTw+6x79fJ7a6Jy6tjuNMBhw39wfTzGL1KEH0=;
        fh=W54bSFivdlZE9ZxHnvAiJz4Cpv2jZFbxMcrOV1okEJA=;
        b=JHLwR1ZBPe+n2eU+0OyVBRpioJBX3H0dDxF62We3In74YPPpFpbcZWqWvHxZjkYao6
         0kAZwXNHc5Xf5J2TDyPRsF/oX8SZcH+F16dR7aOUrGUipNt7Xhky1GUOdgkuKHCS6IpO
         2OpY5SB2mjOxfsl/sufKWnTGl4sQuuvCKd0PVlz1sBWYx82jefd1nSDE8yP9t8YU8NUf
         JE0jTLrsQrFcQK5yGFFxLCa1huQWTvLVbsmEAUKrAjWfP6IxuO0soCUiB716jCqZrJw2
         pEaohc0dxs7WRUN1+9bVPbFeTa7+ZKhbUQuXpP9GxMUO4G8bIW/bNgU3kOVdbfAGxPpS
         Zncg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771971381; x=1772576181; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48FXZFJTw+6x79fJ7a6Jy6tjuNMBhw39wfTzGL1KEH0=;
        b=4HU6WJrHG3DiAawFoEp2drnNAKwmWSBIxemtQGlSmlEKH7ErD4180NUHCoL5V5tUNZ
         cRLvvKdyO1TQs+XLdQq63G1Ggg6KYUzsjwlc09322ZYQgpM9reW4itwhYjoo8+Cq10j1
         UJZBDtzopSw6u9d1sLYtETrYBGj+A1CKJdPUXdDWftbcdUCoc9lRe+aiDnxmSg0qDY3C
         RlC7/aOpgvgqnJp08GJsMm8BwZgR7f96tYx0WjIuveP/bVi9psMby7RFUxtu/M2y1Ekx
         yg0Drumg93p13cemDJNuxqY9+Y8RG7igG7YoDHwoo7cJeOhUxhcqjZMr9ObK2nN17Rx8
         I+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771971381; x=1772576181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=48FXZFJTw+6x79fJ7a6Jy6tjuNMBhw39wfTzGL1KEH0=;
        b=Naux9jUY3052fuXVOz8cgwpBcm3igYOGdsvoSZ665f0RVweyK9ZtX0+LEzYWDKUFei
         S0fwX403Fe0MpJPpzgAzij7NVLPBT6VbnDAHJyVLbGDKAl2KcNWsppTLr+oEBLLdLiqT
         U3SH+it0qvlboS3ejQ7hLmc2Ric3AcmcDNU3LFx3WNsMsixioFA55AnkBHcbrQQUxwZG
         QA/ZGSHOaNui6USIrYciBuqncXCLoW1h83GvgdPKGPXgc1gECTzoHz4B3WGKXqZckCUP
         u7l1Af1GUCjiWLjnQs85dHZ47wkCuQ+py9GCJ7guuim642CfMmr/riGnpD6/zNIznqtU
         9Xeg==
X-Forwarded-Encrypted: i=1; AJvYcCWDpD08WtWxgaFN7xzrYTRrVHFdqBm0Pw43PvvcjBr31wcR84O5bsMngAklGnv2FEim+j+lH3uYfw==@kvack.org
X-Gm-Message-State: AOJu0YyjJj5Q90usYbRuH23QBpd+9t/8p+N5szqep13MW5urAnT3Ybt5
	OszPVg7QH99v9g5qPBdIr/q8zvxYfLQqJyDstYkM/z+C1ES6LKg2otfatTRZG1jnB10K/9Cdv1U
	T1fYWplPDk+QOlw/hPa2R46OEtZ35a1Nil2689eQs
X-Gm-Gg: ATEYQzxhfV5/8U/iCI/u7y4oun5nXtYNrV7t7H3cjUjUwzp3Ayo/t3GRJ82en5DqVaw
	rzO3f2G0tInVNVP7PmYURFbqpkeaaLTrnWlEQ3MJsyNCAACH8eB9XtX7w4/h8Uv8td7X1RE0A3u
	9Cj7TDibit00F9HF/XjokXTCvBFHEBY/OfLz0bKvuq8H1UkEG/f20KtHTdqcEt6R0plkltsabhR
	7i3eIifVtqfOmjC1UAaMMf55vr0PiB3SEXekjsazEb/WDFs8HZ0gvZk4jVrhFvvW/Qk70z04hxu
	XLl8ROwhTRYBGxNIDryTBB78vumQltBEunKq0Q==
X-Received: by 2002:ac8:5903:0:b0:505:e719:3b49 with SMTP id
 d75a77b69052e-5073a331544mr1246501cf.11.1771971380858; Tue, 24 Feb 2026
 14:16:20 -0800 (PST)
MIME-Version: 1.0
References: <20260224165250.1322946-1-surenb@google.com> <202602250250.n38q74JK-lkp@intel.com>
 <CAJuCfpGcA7YmxzmJuEzjJyLAQrV-uGS1LH=B1eX50MSh09z21w@mail.gmail.com>
In-Reply-To: <CAJuCfpGcA7YmxzmJuEzjJyLAQrV-uGS1LH=B1eX50MSh09z21w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 14:16:09 -0800
X-Gm-Features: AaiRm533kGl5au_lU-qDQs1zUoFTWbklJ0-4014AJth8cYkZ1yJ6e5gdW0m9ejI
Message-ID: <CAJuCfpFKS7urCogZu5bAzmOaLUmAXTp9ftuxfLwy+7G01HSr5A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated
 with __GFP_NO_OBJ_EXT
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	00107082@163.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 85A8D80014
X-Stat-Signature: wy693tfjcsa7g1jxyktdsgj378grodmi
X-HE-Tag: 1771971382-596948
X-HE-Meta: U2FsdGVkX19bqBMpIlrXJSqeoBYtBdg97OSxJd6QbgsIcG2zOJy/T7BC57Cz8GHGhNzRUpW+QruzQtdR3NnT9vqfsSa7EObgsnWQfQXXpDmKg2TFS6gsMRbjMLJwKHgd4rZK1haW5wTObI0VSVTFUhAWbcOosWfjqnq1GKDbXmi4aNtagfuQnIxmhjPCMBZU8/eU7YZyQ0pLQujdJoe0CdUVTIZsth0acDPgYIxHZCEFz8v3yJNhW95FO9GVxmPH4yGv9z8pSVbLs+4nZ/Z+BO74zMKNAecB+IKobAuJin1i1APCc8XbRwyAbjih0/KN0Q7qAF+fzzQ35R4TbAcXb0Zifve+P4nq+nTNEzYlH60LCG9JUH9u9OmhmpYaYWPV102FypP5GQe5mzfX5Ky5VwBynUvxSuCul9vDXIs1pKUA3XJjlL4DKas0l0/rxRtthbcK1SURokUxO35V+6cIeapAxD2tAstkPMm5U39DG7VIWvAkola347eydwmSd2U0g3PYhVppFKet4FT05V+5AEqmRaTzrE9RIoHH46Rw0nWthdz737OqEOBRET3w8e2S7I402UBucE4y7ehASbo7d6NvrQq+EdygnQ5dvRACjDtaQRBvCHE7gfs6HKC7NZxOnb0pukqfM9bmNI4kzsXm8rBUGuFg0bkBj8cl7LyDJ6ZZEXcECjM5vSbhzWy/DFb0AVnz+UxCFLek5sBFfsNMJPX/KnxAVjhTs7yo4Xsf2IQZjnERQcxEckQVfKoweLm9d95cZMp7VW8+hu8Ve06F5Dxl+Zb2+BBem8t6+nWY+C8f/HaMs5vrnkM/QHVpWtoqfDBULyxwC6j5cphmob4XSssUlWG+dX9IYaJqutgiD7Rjnsfaw1NVz3T6CLO4XcXlBJ9F5AoFsyaoo8rT+TBXzjuqHroOMe0CDb/SZiIervqafb3Cl+eMsG5Oo+RCOSFI13UMXlQ5qjC0ohqDGyh
 i2LHau6m
 L29rY0TyjRmGT1pvk5KJBC54tYAJw8V91p0uNGqKccTGyi6auPZjSIKOm1/FFRf6RDiqmMUeND9zPjwhlqKAfEc8+Ly/Cf3cA7vuhZeXiJ+hvqW8Y4dCtr77hgR7xtrOxnpHGi3qyfY8j633fDae59TmYocKuxonYDZ9e+vLlHJRFL5OtrSy0GaN4+dqprBMicSJkLMmQWIaqxlULVaM3ivGMBUU1eWTNyl4imr/nMLBSnaCdl3B3Jki2d9udF5hTa2uUYY0W2yduNBu01GIzkXGrnIXFSmq2oVg/fJmge6wAj9fzi5Ze0rjtIBWtuhSYtAzXpmIjfRhyk8ZFm/PIILCcFv6VZP6GSr9Rx+L14dSbCMR8KHrlcH2DuFqDbxgSuaYky8nU9bkWLPHE7xYIMk63x6N/jrnq/LxMAlgVtTKJIFkE5EA/V85Uhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:14=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Feb 24, 2026 at 10:54=E2=80=AFAM kernel test robot <lkp@intel.com=
> wrote:
> >
> > Hi Suren,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on 7dff99b354601dd01829e1511711846e04340a69]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasary=
an/mm-slab-mark-alloc-tags-empty-for-sheafs-allocated-with-__GFP_NO_OBJ_EXT=
/20260225-005422
> > base:   7dff99b354601dd01829e1511711846e04340a69
> > patch link:    https://lore.kernel.org/r/20260224165250.1322946-1-suren=
b%40google.com
> > patch subject: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs al=
located with __GFP_NO_OBJ_EXT
> > config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/202=
60225/202602250250.n38q74JK-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260225/202602250250.n38q74JK-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202602250250.n38q74JK-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> > >> mm/slub.c:2787:3: error: call to undeclared function 'mark_objexts_e=
mpty'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
> >     2787 |                 mark_objexts_empty(sheaf);
> >          |                 ^
> >    1 error generated.
>
> Thanks! In a hurry to post the fix I forgot to update the
> mark_objexts_empty() definition for !CONFIG_MEM_ALLOC_PROFILING_DEBUG.
> I'll post a fixed version shortly.

Fixed version is posted at
https://lore.kernel.org/all/20260224221132.1702713-1-surenb@google.com/

>
> >
> >
> > vim +/mark_objexts_empty +2787 mm/slub.c
> >
> >   2783
> >   2784  static void free_empty_sheaf(struct kmem_cache *s, struct slab_=
sheaf *sheaf)
> >   2785  {
> >   2786          if (s->flags & SLAB_KMALLOC)
> > > 2787                  mark_objexts_empty(sheaf);
> >   2788
> >   2789          kfree(sheaf);
> >   2790
> >   2791          stat(s, SHEAF_FREE);
> >   2792  }
> >   2793
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki

