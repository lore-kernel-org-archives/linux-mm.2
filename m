Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C73C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 18:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544296B0092; Thu, 16 Jul 2026 14:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C296B00A6; Thu, 16 Jul 2026 14:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7E56B00F1; Thu, 16 Jul 2026 14:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A33B6B0092
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:19:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 880311C0226
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:19:01 +0000 (UTC)
X-FDA: 84995451282.27.489462D
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9501A40002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:18:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L3YbmIne;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784225939;
	b=rNRi0u72w957plPGVOnXWKmB7wm+vbX+CmmYYTRr7jf5o8QF6dWLvWy3jQ9oSaYtwJ9Re5
	JVQ0HZai1TneY62xOxWCbUtC4hGLmS8wjpHvcszv2mVtGQCftQy1029Sq1+8VMktbJ8Q8z
	x+Lk/M3hbFCEQe9HA06ceOG2drUbrgw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L3YbmIne;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784225939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCJWw44Yt9QfTMjmF/5pzznV1wMqLVnfAfzAdUp6RWc=;
	b=1bNyT75ZaPPUFIiXYdJHODtRAY39WTV9vQk/We11gTK4Ik3wN/dKikEioBRwHDkYdf/wzj
	TGz7JrifrJa24nOXETbuQaKmcFd4pm7P3LrkPYehpLpGpEoasVGub/+NCGV1AOVcVe7+oR
	rs7wH4bczaJaS7NQoQ7T+gleGAOmvs0=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4728c12ba97so3327011f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784225938; cv=none;
        d=google.com; s=arc-20260327;
        b=Xtal1WsLO/QR3iP+tscIXAk7NRZ+1LD5W8uRxUqCs/WMP0f56+eUHVcAwyXR6mFky6
         Mt5EgmfmmNDxDKQauUvKqQV9PpLaSNGmgEKOY0TAYbn9d9BXQgtoAg7OWs1VaP5S+lTi
         vH5Ztf22EB4mGoBeltcs/PkZ6bdXYkldZSzC1/iFTN/UV7pbPpK/ojeV8LoGQa9TqMJS
         FcmFYa4jJswW9AnuFJQG11cH3J30h2dlrAGWgEVCjN7gtRaBqRyBcwmrEZsX8sBMkTUN
         ySr6vBUiPbW7mjVyHcp3qbrAJwNjCMCwjYG5ku9/7d2q4jsrGF99bptxIvuBEjqqdbwJ
         reJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RCJWw44Yt9QfTMjmF/5pzznV1wMqLVnfAfzAdUp6RWc=;
        fh=obN9tHy8GTBVxbfGQbhskyhcnqPH0EbrTQhbdnp4wRo=;
        b=JzxAY3UheS+04vnCgmg/Ey1awO4Ic+xPuWzODGD84HJTI0Hd//FLDTFxHOP1RhU8k2
         oeC4Uk255WFra/N7GiF2QRc7VmEwEC6cjQU+KFtHfg+GZSn1RZubWUOB8ybNVevhqGfM
         pNWMEzG/Dt8Fmxd+kQmjtEyD/bwrkUo911AhV0CvNBTTzzn+Ky4gI2kbRozykFdrr+01
         sYwL1Gqbx37UNxZQIyHI/dyNOpMLwpA50xK5QEGNfWMSKWUfOjR3KAV+tkvsXOZcEnzY
         pI990W+QRRTLOHyGd0ydCRe9v7cnrEYlWXWwPkKEYfUODbVhiL4JEnyCdNOEn4hnjms8
         orFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784225938; x=1784830738; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RCJWw44Yt9QfTMjmF/5pzznV1wMqLVnfAfzAdUp6RWc=;
        b=L3YbmIneyHAv10LuXFLHJ9d7uyAKS1+3CrEDjQgcyOWlPUV2ZNtfwLRXh2As2dmaus
         QlnkL/3kJqNcRfOrbcGrtFFK5Ez9Y8DdhZN1dg0UtHeHoEekWaxPrZ93hZ+/3n2VbBul
         2IfO1B4ePNkFNV9jCYu1u+NBfh8H5BZOes/2i55B5ZZIwzC8QKa6zVPm0TG/nAe2RA5c
         keKB89M8Su5+QyvV/KiWYLIEl6CZYohiL0RWfxyvSm/9KflezvI3Lcfo+g3KwqScxYGI
         7zvGRpzCvX1s6xtXBo2TBCCy7L7BhVzht5v32gI/Vlvs3+j5qFQlUbpAmnR2+bmZS74z
         3nlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784225938; x=1784830738;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RCJWw44Yt9QfTMjmF/5pzznV1wMqLVnfAfzAdUp6RWc=;
        b=ILnEzaa93+C0vvYaMLGUGq1U/q+M5QDZal1aXFr1AaWNJtblKXWSqxoowUXHbUr1At
         n30XTeUrEJx96LEZ8feKuAyDKbPJw4di5XdVvyyUZkKqzv0C5lK/flLoi0qqVhWt0vom
         GqC+5W9d5w44DX920ynlRYWoV8m3V7P84cefrz9WjMWymUkmPcaUx2hM3oO0tU3asoIr
         a3ODWbzSBKvjmwFZcQgeCU7ynMoGBi/9NwuMXBoqo6gUmmJ6SJgHzcKAMOQcLNqxPrd0
         yJ0kj43Yp7sqbEJi8w8ZmDnzEJ0Fo+wsxN0PHi7xdHlx+b/J645HA2CXPT4RKrAqmLHE
         dvlA==
X-Forwarded-Encrypted: i=1; AHgh+RquVPsP8zEYvoeLn9HPENgN6BHxPqd8+26qs56dA98VBt3S/K+kdLc16dWJC8HoBwWoiZifrLWhNw==@kvack.org
X-Gm-Message-State: AOJu0YwHoQygMa7k3rQF7/jVgLKXE6nOw9SNEeRA9cG2Ykx9unghiQPB
	vhKMmYNT87zxvCGnO+YP00VOv8bE5Zlfo8yEI9SpeB5naWfjFSczQScO1qgzKGCgrv2+3Kggkjl
	sKyovz3Uk3k36prqER+FwY757lhGlaQ4=
X-Gm-Gg: AfdE7cmGqX5uV4X8+7zEvBPfpAQ0i2WTMP9D99Kgo7pYoRSy0BY8hW5041ifmK1BJRK
	VUlkMBjPyllfGSkLR06uYaOQxve9MwnAEcyyh0n6mrgDRMOSLnh7x+tpSB07hFU+sr81WD6Pvu1
	AsfMIdvATz+6V3V602pzrSR/IiunWdLrPYezqoYQsQzUSSKKC8CFVwkNSuHQG2zTmaS6xe6038o
	z3/D/BzsovSfC4b/a6GrlsiuW/wPM8UjP4iaoDGDYwFaxtUtg2Xn87hS8LjaiVclus0AUzzwQ7N
	znxEkABHn/dW/EnI9ySRUjqapTQtROU0qw==
X-Received: by 2002:a05:6000:490d:b0:47d:ec60:657e with SMTP id
 ffacd0b85a97d-47f4fcd91c0mr9789980f8f.39.1784225937975; Thu, 16 Jul 2026
 11:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-2-jiahao.kernel@gmail.com> <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
 <20260714193129.f81711f516504b659d544741@linux-foundation.org>
 <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com> <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
 <7b35fd4e-7662-10ae-159b-303350e4e59c@gmail.com>
In-Reply-To: <7b35fd4e-7662-10ae-159b-303350e4e59c@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 16 Jul 2026 11:18:44 -0700
X-Gm-Features: AUfX_mxIpAby5cOyODbdsd_vYnsokVJLS1QcOfP3fFXU1u6G5EgnSr-TbOWYryE
Message-ID: <CAKEwX=Ob9shetuJK4y=NZods3KkT=U_3W4S_ALzxX3EDLomWEA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9501A40002
X-Stat-Signature: 79wt7y6637g14ao9jk4hg1qsshwy1mzu
X-HE-Tag: 1784225939-455854
X-HE-Meta: U2FsdGVkX18f1Zl0PvpgSw32yPCDJqHTsIrPd6SWsHJ6bjCy6HK0vfYQ8gVw8XCwT+6NBZg+BvIb8zLuoPOnCaUO6k98jM0Nq/gYF3aQEmzzOZ2Pm+gU7UFdxlxP4TbOUGtVM8pbMhWozC4LVVzPUldIpd9rbUs2rcH2zzx6YiIsZa3vLYozabl+zctNVwTj26k3gu6iw5/QOIa12j/5ZbHy8BD4gyixvWS1Rtm6a8Z+UzI2fQEEfPmGdIrHGJ3FOfghmVWgLcPI+IUq/LHk5X2IByUHfJP0XYY8MDe6ikbaFpEbQK1bJC51El7emGlcS+ZWLhJZ13HEOK3o0tneKTab+1Pd8oFpdjX4GCiuz7UJDQidZLqnAUF3Dh9lsPPY/wRKAZf+BacJ1kWpzUBqO0/iXQczOi7aGIbIfJEYnGCtbyyxRq84aD+WJjUeMKqqmW0/ugugmIpMnH5sCVOLOObuJqimHSNI03Io/LHK7oeoMaGriytZYNqnjq/1gqMiwKTdL4xgn2B7nUltHYrU1TEnTWU/j3JpoGlYFr0kx7xFDftKjhuDj71DlwxaNhfjY9BVQJTtcmRlDKBIa2dsSYbswMbXnxf7Ug6ks6U4UT/gRNsod10Eme2ec83GpBRc5c1FEWSDDcKswbVgZGVlQlqTA8aFUf+LmUQtKOyOlOOTue+RQDIBhAGzX07jNzjbaoh7j5BtusxNdq2hKOR1le1DgdU0NuzEMeo1X30pNnwl4ZwFha3m1oxnphx2MCZZA24JLWODp6jrowPO+Bhp/5VHaQY4+g+c/kwBUst8kHjN7HUBXNB4t4XIx6hkqCuBcwmNlJZYXTA42vxzEEzsdCBQAPuzUTGXBDxYsEHMUqdvoj1iJEo8IDnY/dffjNpkOY4PwQ5A+sxa6h9i3WOhF8a32Ur/PC2vsxuUIzplS459PiSE2TVuH191l6ET9w37IoHUxmd4vk5BSg3mG7z
 p/TORYot
 GSCPg130eRj1WFG4NOy+Edb0U6W/zoCxf/VUUFjAkw7XZ1+MPS07gEUSCPOnIIwzJrBy3qmQGySMe4IY2w5fYr47wgOZ3xVC3Swdk5PY7du9ULloDb8zzZ6PZk7orfl60kqmNBnB3896AKtVi2c3vtsoy4WHMJtMY+tZppdwVVadgLhQMWSQhpMeTJejTP/8rMtj0nwn36LdfTy9YC52aaZxXdMGw1/WpkWuIA2rC+XER7vHhXZyCyMkxk7dPARem7z6n5r2vlReNpVD2Iz7A62RX8GGrC4nlXBGoisVGFTMOS4akk3/e7JnM/eD7a9dlqf97pkmMMEbJfckkmUuUpHU9d2KFQrQLY4G/rEwc1F/P6sQIRO7oEJYMtsVW10nqxG8WWT1WTTechSyYFP/dIwsLmirnextqke847pceuYC+KC9x9QC1f8pvO/J4MzqG5iwcBgvEyYwIxZ2GncVFFR2s93+05C3qtp56busiYdvltlv12hJKHzUJO036FoTipAAuH3jrvIN9hzvciPhnY8SAtPRjAN0PCU5Ig4m1P0Pt99PBvEJq8IGB0vdeY0Yu3aki0uNQdFjGzzM1fYm+DXiNbwP8zNwZCmJZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 7:21=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/16 00:13, Yosry Ahmed wrote:
> > On Wed, Jul 15, 2026 at 5:31=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.co=
m> wrote:
> >>
> >>
> >>
> >> On 2026/7/15 10:31, Andrew Morton wrote:
> >>> On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> wro=
te:
> >>>
> >>>>> When memory cgroup is disabled, mem_cgroup_iter() always returns NU=
LL.
> >>>>> Therefore, the global shrinker shrink_worker() always takes the !me=
mcg
> >>>>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gi=
ves up,
> >>>>> so it fails to write back anything.
> >>>>>
> >>>>> Therefore, when memory cgroup is disabled, fall through with the !m=
emcg
> >>>>> branch and shrink the root memcg directly.
> >>>>>
> >>>>> With memcg disabled, shrink_memcg() only returns -ENOENT when the r=
oot
> >>>>> LRU is empty, which means the total pages are already below thr. Th=
e
> >>>>> loop then safely bails out via the zswap_total_pages() <=3D thr che=
ck.
> >>>>> For any other return value from shrink_memcg(), the loop is guarant=
eed
> >>>>> to terminate, either after MAX_RECLAIM_RETRIES failures or once the
> >>>>> threshold is met.
> >>>>>
> >>>>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> >>>>> Acked-by: Nhat Pham <nphamcs@gmail.com>
> >>>>> Acked-by: Yosry Ahmed <yosry@kernel.org>
> >>>>> Reported-by: Yosry Ahmed <yosry@kernel.org>
> >>>>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVr=
HiZZeLc=3DeyTPKPVQgX4g@mail.gmail.com
> >>>>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> >>>>
> >>>> Patch 2 doesn't really depend on this one, right?
> >>>>
> >>>> If that's the case I think this can (and should be) picked up
> >>>> separately as a hotfix. Andrew, WDYT?
> >>>
> >>> Please update the changelog to clearly describe the userspace-visible
> >>> effects of the bug, thanks.
> >>
> >> I am not entirely sure if my understanding is correct here, but maybe =
I
> >> should add something like this to the commit message?
> >>
> >> When cgroup_disable=3Dmemory is used (or with CONFIG_MEMCG=3Dn), the g=
lobal
> >> shrinker fails to write back any pages. Consequently, the zswap pool
> >> fills up to its limit and rejects further storage, preventing memory
> >> pressure from being offloaded to the backing swap device.
> >
> > I think you can simply write that zswap writeback when the limit is
> > hit is broken when memcg is disabled.
> Will do. Thanks!
>
> >
> >>
> >>> Also, AI review has flagged several possible issues, all appear to be
> >>> serious:
> >>>        https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao.k=
ernel@gmail.com
> >>
> >> For AI review comments on this patch:
> >> I suspect this scenario might only exist in theory. For zswap LRU to b=
e
> >> empty while zswap_total_pages() > thr holds true, it would require a
> >> prolonged state where there are always more than thr zswap entries on
> >> the zswap LRU whenever zswap_total_pages() > thr is evaluated, yet the
> >> zswap LRU happens to be empty during shrink_memcg(root_memcg).
> >>
> >> If we want to fix this, perhaps we could do something like this?
> >>
> >> Yosry, Nhat, what are your thoughts on this?
> >
> > Do we need to do this? The last paragraph in your changelog explains
> > why this can't happen because zswap_total_pages() should be 0 in this
> > case. Did I miss something?
>
> The loop would require the following sequence to repeat indefinitely:
>
> 1=E3=80=81zswap_total_pages() > thr evaluates to true.
> 2=E3=80=81During shrink_memcg(root_memcg), the zswap LRU is concurrently =
drained
> to empty.
> 3=E3=80=81Before zswap_total_pages() > thr is evaluated again, the zswap =
LRU is
> heavily refilled such that zswap_total_pages() > thr holds true once more=
.
>
> For our case to manifest, it would require zswap_total_pages() and the
> zswap LRU state to repeatedly hit this exact window with perfect
> alignment over a **prolonged period**. Therefore, I suspect this
> scenario might only exist in theory.

Yeah seems very artificial indeed.

If we want to be extra careful here, maybe we can put a cond_resched()
there or replace the continue with goto resched or sth?

