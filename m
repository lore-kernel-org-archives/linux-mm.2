Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4856ECD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E206B00B9; Wed,  3 Jun 2026 12:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EA56B00BA; Wed,  3 Jun 2026 12:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616096B00BB; Wed,  3 Jun 2026 12:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4F16B00B9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:55:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D8C3C1A0B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:55:12 +0000 (UTC)
X-FDA: 84839201664.03.19DDED4
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E05F180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:55:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ki5Ksfjk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780505710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TiXju5uSM/8yEnyikqWAM9PCljKBLrQy9eHTWzx3P8=;
	b=vDiP9uuugRgS+wifA8VcMrOJWtJjAZBLEMI4FEIslcal3U6WAdcDFmWwoS/eW+q1xh9b51
	DrlG27qjM8KH+rlLw4oo9Qjw4Jw4NFdMvVqzkCaMzspAkZRCJBaGDBoo9lcPechi1Qq1Qv
	wUPE8MmcG1YOx3cexD5S4vQk8bwKD8k=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ki5Ksfjk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780505710;
	b=C/8SrfDyL/pSco2aKybpMM3v3Br6zLYr1E9T89FohDvJ5H8hISpxeCAjpfSh+O+Wtmqrvo
	7S1irxGQ+9Ar4OIZwP2FU4V249s8FhCPth/C9EWuL7cu6mLHuQfNlf38yjOW4LrP1m6leO
	2WKRT+eKHcG0nOcn85oYT0ZffK+rRoU=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51765331535so7981cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 09:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780505709; cv=none;
        d=google.com; s=arc-20240605;
        b=HseoF0Bt/Xvnuk8jxbo9ub7nMeXZIFcT9gyVoKXSwQ0OgbCkOrI9N1KlKIZ1Pnd0nv
         tYfO1WSR7qxE0D655WEYx8IBZWpTPNO2agIxzfj2zJNBEwSO3viKtFrB/eST9YxilYKO
         x1OvKJDnFQs8UpmGl9n+TOVJqwzE2LhrG9/Ym2Gm06U9XsN6YNLLGPXavusRfL14IqUI
         oLuJQX2BmBSeJ2hrT+aexXa4WzZ+DVgDlz/hURDAcHCJ1YuU/Nuop+PEXGY6oFTTfpNh
         B0cUO/k2pGgW2mXznTSYyUuXKAvUeq5Y5Mzn8XN2YKF12WD6N8XUG3CA3e8deA2gTgVn
         5pQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6TiXju5uSM/8yEnyikqWAM9PCljKBLrQy9eHTWzx3P8=;
        fh=ldXriDspQYtH41ft1wntF+kmPax1Sq+Y5vQvfrjWCZ0=;
        b=E4/edRUy2VOgRbldvxUF1A8PfUnP7kG1ZyTLFPdyDxbBS6cz98dSheHD+Z4SjEsOUT
         GdkqIxAlwo6W/Yk7vbztRKGa6HUMimxANsBrsRGtLeEHM5DFb+jmJjTa32Bbh6y7NxC0
         dnl4Z+4TEml0Mx/mIHr84yaKD7ktEdxq2+X4hZWifiD4/aouhKNTlZJQ2C0T65jxjf2F
         ZeEL+wyxEs/yHzBn2FE0UJsNkN1IbW6gRtmaL8XY5NirBqr1lTwrihusC3rqZr2Dkb7I
         46L9Ju52OW9W9IqCS5uhsOkoobdZvDSgwHChnWLZVSi1gpPiYmaA7qa258AYtCTGnoUe
         O/Pw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780505709; x=1781110509; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TiXju5uSM/8yEnyikqWAM9PCljKBLrQy9eHTWzx3P8=;
        b=Ki5KsfjkZ4nulhCB55Ue4PRSEG4e8J5k44Ul6O2VucVW6kug2UpWik8NzzzmP8Xzjz
         c3UbIJz64fYcUc3R7GK1guc+643+vYTw/UuHS0yO72KdyAo4Yn3Hd0kAIT3nyRzIPcAE
         Y74C7yWgvxqAggOY1L2jHhUj6TP2160UL0/rg19yYrFOa0laiFsCkSThwASGQrLy4PMj
         /fSKNPvptEwr7JARsKNUmR/4UcnRxXzvb3JAQqXDtWww7CKHbmlz77FklEMSmzojPUq+
         TUPNnDVPf6wcL9JDyYIPtHQIm5uWx48RIajfstsXOQSDM56Kgh4rF4y7ZcrquDw11iam
         Wwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780505709; x=1781110509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6TiXju5uSM/8yEnyikqWAM9PCljKBLrQy9eHTWzx3P8=;
        b=tDK2ePY/uMRA0d3VkeMwkoOXAswqLz/nq71kfnaqWi1UKekTiIxad0PzpWa6SetpKq
         Nbddq8zbCSi+8OST2ZwsgoEki4uBSm8PSkXO6OyiAId6sOW6eO1ac2vgoZ2WC7HHVJd8
         NNCQS83/ARFb0hnB11hLP2bxKOXwd2Tg2Ju55AuiiyIIDjSFmxO1XwTGcH82xTOEUf8S
         cZCMKgXS39ChLBbzX8tW3Wmrk8cWN0oa2msko/Xz1ZfBneM3aNGm32z4ClulLGJe/u4J
         j8JpgvX/Ry24GP9Z7xSfvyYOYDHKuuHqdrDMc1DYKoKjkggoY1D3JScmcbYNKq/aLaPZ
         2WNw==
X-Forwarded-Encrypted: i=1; AFNElJ8wrN4XZt5cxbMkEJyjoeO2n5KT/BCb9Hz96dNzWBCbpHCIcaP3W4FQr0W1io5K4iGOo4mSPHn9CA==@kvack.org
X-Gm-Message-State: AOJu0YwWn7uu2buIzjqF4hTfJavwoObQBh3BNvaYP4T6C74Ra7RHAzWv
	7wwKX0Dqqdnn6PsDcx3Uu8CzsVHTZlBQQYSMj9ox1FaqGTc7nGkw3Ft8BEmi0fYeLRCWR51BQdI
	egSGgwpfj7Siu3yzvWi5grC21cEMJ5/yppqOcNdUCRiaNrns3XsVi29+E
X-Gm-Gg: Acq92OGKgoIuURtcLtLlZ/8wI/nMsqxI0zpeAKoTNrL0O9NCNrsix8awFIL1Aq4H58c
	KF+VOGo01bsNSg7KxyoSic8bvEXo8geI+cxl3leCygzKGsPOvSRY8PxZN+kbZY8/RZ0uPTnerMM
	sR5y8178yLbterxqoxJPFrDksIRWvuQVvoYcFhm7Q6HVSdBoxTy7sVGlCDEzWhB0MtMwnzWuDBH
	twKBcin9KIEfir9iN5btX42EcNju1rGn3nnf2s/d08ucxT79svFRrRXTpv+6trs4nJH/XqnymiS
	KhVj0hXXCjdCvEC3oX64QHR0XEGRzbcjpgTi+gPOw3katMDU
X-Received: by 2002:a05:622a:120c:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-5177e5b4eaemr9377091cf.1.1780505708235; Wed, 03 Jun 2026
 09:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260506022256.32664-1-hao.ge@linux.dev> <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
 <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org> <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
In-Reply-To: <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 09:54:56 -0700
X-Gm-Features: AVHnY4Jxu-ZHL17CCuSySD4v_fveqQ4fDeKU5zho4xpJ_4vX3l50HVqh0S7m0XQ
Message-ID: <CAJuCfpGjPFbd+Fw52_cz-HSQZndUDDiGTXH38y8U-6sZF4=YwA@mail.gmail.com>
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0E05F180006
X-Stat-Signature: a6a5hgzjqwsg6yruyanzwz1367bi73hf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780505709-70238
X-HE-Meta: U2FsdGVkX1+xwxCi8znHf6DPwK44TaSsDFHekkX5xd5gx9DARl0reJn0m7WAScEc/3wJ7F2Afimda4cGTvOu5EnJhmhAxRVwqnpjASNZ6kWhQmMboN5MQSJtANdzyljMMT+IfEKIpeG4fLLKJnWJgAmp3V55Qv0Cr0tqxBi/9VUpiwjkG+dBv6AIErb1Gt0UnjgFCYjjCiVNLvLZnlpz0rhR8/k0STjYyc79O1+c+YlvWCoktyvQKKUahYBOm3hmlQeyY4xF0tDW11CIHL4CXQOsE1qtFJt1w79IqVRLvHswBAWmpq/d2xoDgI1B0XxUSCKlvaZmzO6a5cqz8QHk0HYqO5CRUjWERz9J3ARnnun9tQeWvNzp9HHGgnxpxXrgy8Uj1/KgtbasiAndG8K6F+cOVGDrLaVKO0atrkZTMftHmTfMRQ7CZxxjPpa2Snfxx85hkz0JljSD4ABxjrO/YuSq+9Ll+xhYSrvEqiZNglwpZmSFVtGowskM2ak9gKcf7iKvjxrj9y5noBoo3xVD97oPKr4S7hDu/SGkkSS16mIDSxF5ZxHhcugI5Ch/2oti+t/wP/Ylfp+NfENf0pdrmWP+Kxe0jQAwKw/sWubOmmRhonbV85ph2UoBKUpJ/hujnXgKKBm0WGkVzCv8+FU2GrfToEDM/QEQQvStNrJ8oQPv9z+87c7M6wTncxP8dMPGqmXc/2AEWaRTr785rbPRmr5ORj0ZlPt5ZEP/ec8OL/hGAp6y5j5VY/jiZ00VDVAiHgC7IzD2bduJjQADmdp+PaOXkmkYRCfj6eQDPOnjqsz4Y+8r4DACQIJvdn5YB/VnvADWzqp8oeCeGTS2Rhm9DZuP+KPPIbvuEAdDQuthpGKcK4PXfTLYYtZe0jUFKa1x1WwA8y9yAai0YpqgJ6jehBmcWRARcamCl8wcO/qJkomZar6ZIcEYws0H/7WbBWE5XPi45yGYGo9157UjW7c
 spFBxMAC
 gcKTeQhe0oN/BQJhzuegBWEc93lIOQOzseR7kfnGjReXCFa0e/PWfNIM+RhejWsDPjrCmi2cCMZOHtRO0zGz98BFadz14dHJSH92bLpPC2qk7YMFMtFBZ3TjtJqE8TgbhVGlGOTbHtYNVuboOG0DTJLHGfSNBlOH5WOfaVgXIEshA6WhSpItONUCVgRIpd2dhV5EXS8v8BQTj53X/p2RWcymROJqCMPKI7xzgZl+7FIgwub0mSedfVom//JyTvTM4xuaGqCshghgeNwji+P6twntp0pOJ+ZEzLT8k3x50z6M0A7oWZzAGf/32tGLWwzevFd6U1y5eMYXsC9rqXrxsWycKz6RJx384GKiKMJvJCjK6x1M3lyX7S+pK3kbmwmPbhJreBGEiZ8BGX4gqCjx5g353BmuT3RTUONEWmb2mOLqiolZk+KfSEVwHuqaYZsvLdvSFpbefzaT8iaCJCFURD62t3RMCB2PV8SbXBnN4+NFQ4La+P48+bicbl3IB/2UFP0+O76VJ63AKFChMfVXCD+00w0gX5zLq9EA14iYcwpMxetuRpFc25C2qdqBp7dO6QAs79WPGPv6lYtdKBhL8Z2Cc6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 10:22=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/5/27 10:00, Andrew Morton wrote:
> > On Fri, 8 May 2026 17:12:51 -0700 Andrew Morton <akpm@linux-foundation.=
org> wrote:
> >
> >> On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> Pages allocated before page_ext is available have their codetag left
> >>> uninitialized. Track these early PFNs and clear their codetag in
> >>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> >>> warnings when they are freed later.
> >>>
> >>> Currently a fixed-size array of 8192 entries is used, with a warning =
if
> >>> the limit is exceeded. However, the number of early allocations depen=
ds
> >>> on the number of CPUs and can be larger than 8192.
> >>>
> >>> Replace the fixed-size array with a dynamically allocated linked list
> >>> of pfn_pool structs. Each node is allocated via alloc_page() and mapp=
ed
> >>> to a pfn_pool containing a next pointer, an atomic slot counter, and =
a
> >>> PFN array that fills the remainder of the page.
> >>>
> >>> The tracking pages themselves are allocated via alloc_page(), which
> >>> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> >>> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> >>> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> >>> so that the early path can skip recording allocations that carry this
> >>> flag.
> >> AI review asked a couple of things.  I have a feeling we saw at least
> >> one of these, so probably already dealt with.
> >>      https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@linu=
x.dev
>
> Hi Andrew
>
> My apologies. I'm also waiting for Suren's review. He may have been tied
> up lately
>
> and might not have time to get to this.
>
>
> Sashiko raised two issues this time. I've already responded to the first
> one.
>
> See the link below:
>
> https://lore.kernel.org/all/0b9969e2-b208-46c2-a9a5-bf620239275a@linux.de=
v/
>
> If I haven't missed any details, it should be a false positive.

That seems to be the case. I wonder why Sashiko did not consider
that... CC'ing Roman to see if Sashiko can be improved (unless we both
are missing something).

>
>
> As for the second point, let me address it.
>
> The early PFN tracking window is entirely within mm_core_init(),
>
> which is called from start_kernel():
>
> start_kernel()
>
>      mm_core_init()
>
>          memblock_free_all();
>
>          mem_init() //start early PFN tracking
>
>          kmem_cache_init()                           // SLUB bootstrap +
> kmalloc caches
> ...
>          page_ext_init()                                   // clears
> alloc_tag_add_early_pfn_ptr
>
>      ...
>
>      rest_init() //spawns kernel_init thread
>
>
> kernel_init() =E2=86=92 kernel_init_freeable()            // separate thr=
ead, later
>
>      smp_init()                                    // secondary CPUs
> come online here
>
> Within the early PFN window (mem_init() to page_ext_init()):
>
>   1. We are still in start_kernel(), single CPU. The buddy allocator
>
> was just initialized from memblock and should have plenty of free
>
> pages, so alloc_page() would likely be satisfied from the fast
>
> path. If so, the __GFP_NOFAIL without __GFP_DIRECT_RECLAIM
>
> check in the slowpath would not be reached.
>
> 2. Since only the boot CPU is running, alloc_page() targets the
>
> boot node, which has memory. So even if __GFP_THISNODE were
>
> inherited, it would not fail on the boot node during this window.
>
>
> So Sashiko's analysis applies to the general case, and indeed the issues
>
> he raised could occur there.
>
> However, in the early boot scenario, I believe the current patch is safe,
>
> even though it is not fully generic (after all, no one can predict
> future use cases).
>
> Therefore, I agree with his suggestion that using a clean mask like
> GFP_NOWAIT | __GFP_NOWARN.

This sounds good to me. With that change feel free to add:

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
>
> In any case, I will wait for your and Suren's feedback. You may have
> different opinions on this matter.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
> > Please?
> >
> > Also, this patch has no evidence of human review.
> >
> >
> > From: Hao Ge <hao.ge@linux.dev>
> > Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic =
linked list
> > Date: Wed, 6 May 2026 10:22:56 +0800
> >
> > Pages allocated before page_ext is available have their codetag left
> > uninitialized.  Track these early PFNs and clear their codetag in
> > clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" warni=
ngs
> > when they are freed later.
> >
> > Currently a fixed-size array of 8192 entries is used, with a warning if
> > the limit is exceeded.  However, the number of early allocations depend=
s
> > on the number of CPUs and can be larger than 8192.
> >
> > Replace the fixed-size array with a dynamically allocated linked list o=
f
> > pfn_pool structs.  Each node is allocated via alloc_page() and mapped t=
o a
> > pfn_pool containing a next pointer, an atomic slot counter, and a PFN
> > array that fills the remainder of the page.
> >
> > The tracking pages themselves are allocated via alloc_page(), which wou=
ld
> > trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> > indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
> > bit) and pass gfp_flags through pgalloc_tag_add() so that the early pat=
h
> > can skip recording allocations that carry this flag.
> >
> > Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Brendan Jackman <jackmanb@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >   include/linux/alloc_tag.h |    4
> >   lib/alloc_tag.c           |  145 +++++++++++++++++++++++-------------
> >   mm/page_alloc.c           |   12 +-
> >   3 files changed, 102 insertions(+), 59 deletions(-)
> >
> > --- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early-p=
fn-array-with-dynamic-linked-list
> > +++ a/include/linux/alloc_tag.h
> > @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
> >   {
> >       WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >   }
> > -void alloc_tag_add_early_pfn(unsigned long pfn);
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >   #else
> >   static inline void alloc_tag_add_check(union codetag_ref *ref, struct=
 alloc_tag *tag) {}
> >   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> > -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> > +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags) {}
> >   #endif
> >
> >   /* Caller should verify both ref and tag to be valid */
> > --- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-w=
ith-dynamic-linked-list
> > +++ a/lib/alloc_tag.c
> > @@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
> >    * their codetag uninitialized. Track these early PFNs so we can clea=
r
> >    * their codetag refs later to avoid warnings when they are freed.
> >    *
> > - * Early allocations include:
> > - *   - Base allocations independent of CPU count
> > - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_ini=
t,
> > - *     such as trace ring buffers, scheduler per-cpu data)
> > - *
> > - * For simplicity, we fix the size to 8192.
> > - * If insufficient, a warning will be triggered to alert the user.
> > + * Each page is cast to a pfn_pool: the first few bytes hold metadata
> > + * (next pointer and slot count), the remainder stores PFNs.
> > + */
> > +struct pfn_pool {
> > +     struct pfn_pool *next;
> > +     atomic_t count;
> > +     unsigned long pfns[];
> > +};
> > +
> > +#define PFN_POOL_SIZE                        ((PAGE_SIZE - offsetof(st=
ruct pfn_pool, pfns)) / \
> > +                                      sizeof(unsigned long))
> > +
> > +/*
> > + * Skip early PFN recording for a page allocation.  Reuses the
> > + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoi=
d
> > + * recursion when allocating pages for the early PFN tracking list
> > + * itself.
> >    *
> > - * TODO: Replace fixed-size array with dynamic allocation using
> > - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> > + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> > + * cleared (via clear_page_tag_ref()) before freeing the pages to prev=
ent
> > + * alloc_tag_sub_check() from triggering a warning.
> >    */
> > -#define EARLY_ALLOC_PFN_MAX          8192
> > +#define __GFP_NO_CODETAG             __GFP_NO_OBJ_EXT
> >
> > -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> > -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> > +static struct pfn_pool *current_pfn_pool __initdata;
> >
> > -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> > +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t =
gfp_flags)
> >   {
> > -     int old_idx, new_idx;
> > +     struct pfn_pool *pool;
> > +     int idx;
> >
> >       do {
> > -             old_idx =3D atomic_read(&early_pfn_count);
> > -             if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> > -                     pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> > -                                   EARLY_ALLOC_PFN_MAX);
> > -                     return;
> > +             pool =3D READ_ONCE(current_pfn_pool);
> > +             if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SIZE=
) {
> > +                     gfp_t gfp =3D gfp_flags & ~(__GFP_DIRECT_RECLAIM =
| GFP_ZONEMASK);
> > +                     struct page *new_page =3D alloc_page(gfp | __GFP_=
NO_CODETAG);
> > +                     struct pfn_pool *new;
> > +
> > +                     if (!new_page) {
> > +                             pr_warn_once("early PFN tracking page all=
ocation failed\n");
> > +                             return;
> > +                     }
> > +                     new =3D page_address(new_page);
> > +                     new->next =3D pool;
> > +                     atomic_set(&new->count, 0);
> > +                     if (cmpxchg(&current_pfn_pool, pool, new) !=3D po=
ol) {
> > +                             clear_page_tag_ref(new_page);
> > +                             __free_page(new_page);
> > +                             continue;
> > +                     }
> > +                     pool =3D new;
> >               }
> > -             new_idx =3D old_idx + 1;
> > -     } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> > +             idx =3D atomic_read(&pool->count);
> > +             if (idx >=3D PFN_POOL_SIZE)
> > +                     continue;
> > +             if (atomic_cmpxchg(&pool->count, idx, idx + 1) =3D=3D idx=
)
> > +                     break;
> > +     } while (1);
> >
> > -     early_pfns[old_idx] =3D pfn;
> > +     pool->pfns[idx] =3D pfn;
> >   }
> >
> > -typedef void alloc_tag_add_func(unsigned long pfn);
> > +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
> >   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdat=
a =3D
> >       RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >
> > -void alloc_tag_add_early_pfn(unsigned long pfn)
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >   {
> >       alloc_tag_add_func *alloc_tag_add;
> >
> >       if (static_key_enabled(&mem_profiling_compressed))
> >               return;
> >
> > +     /* Skip allocations for the tracking list itself to avoid recursi=
on. */
> > +     if (gfp_flags & __GFP_NO_CODETAG)
> > +             return;
> > +
> >       rcu_read_lock();
> >       alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
> >       if (alloc_tag_add)
> > -             alloc_tag_add(pfn);
> > +             alloc_tag_add(pfn, gfp_flags);
> >       rcu_read_unlock();
> >   }
> >
> >   static void __init clear_early_alloc_pfn_tag_refs(void)
> >   {
> > -     unsigned int i;
> > +     struct pfn_pool *pool, *next;
> > +     struct page *page;
> > +     int i;
> >
> >       if (static_key_enabled(&mem_profiling_compressed))
> >               return;
> > @@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
> >       /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
> >       synchronize_rcu();
> >
> > -     for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> > -             unsigned long pfn =3D early_pfns[i];
> > +     for (pool =3D current_pfn_pool; pool; pool =3D next) {
> > +             int nr_pfns =3D atomic_read(&pool->count);
> > +
> > +             for (i =3D 0; i < nr_pfns; i++) {
> > +                     unsigned long pfn =3D pool->pfns[i];
> >
> > -             if (pfn_valid(pfn)) {
> > -                     struct page *page =3D pfn_to_page(pfn);
> > -                     union pgtag_ref_handle handle;
> > -                     union codetag_ref ref;
> > -
> > -                     if (get_page_tag_ref(page, &ref, &handle)) {
> > -                             /*
> > -                              * An early-allocated page could be freed=
 and reallocated
> > -                              * after its page_ext is initialized but =
before we clear it.
> > -                              * In that case, it already has a valid t=
ag set.
> > -                              * We should not overwrite that valid tag=
 with CODETAG_EMPTY.
> > -                              *
> > -                              * Note: there is still a small race wind=
ow between checking
> > -                              * ref.ct and calling set_codetag_empty()=
. We accept this
> > -                              * race as it's unlikely and the extra co=
mplexity of atomic
> > -                              * cmpxchg is not worth it for this debug=
-only code path.
> > -                              */
> > -                             if (ref.ct) {
> > +                     if (pfn_valid(pfn)) {
> > +                             union pgtag_ref_handle handle;
> > +                             union codetag_ref ref;
> > +
> > +                             if (get_page_tag_ref(pfn_to_page(pfn), &r=
ef, &handle)) {
> > +                                     /*
> > +                                      * An early-allocated page could =
be freed and reallocated
> > +                                      * after its page_ext is initiali=
zed but before we clear it.
> > +                                      * In that case, it already has a=
 valid tag set.
> > +                                      * We should not overwrite that v=
alid tag
> > +                                      * with CODETAG_EMPTY.
> > +                                      *
> > +                                      * Note: there is still a small r=
ace window between checking
> > +                                      * ref.ct and calling set_codetag=
_empty(). We accept this
> > +                                      * race as it's unlikely and the =
extra complexity of atomic
> > +                                      * cmpxchg is not worth it for th=
is debug-only code path.
> > +                                      */
> > +                                     if (ref.ct) {
> > +                                             put_page_tag_ref(handle);
> > +                                             continue;
> > +                                     }
> > +
> > +                                     set_codetag_empty(&ref);
> > +                                     update_page_tag_ref(handle, &ref)=
;
> >                                       put_page_tag_ref(handle);
> > -                                     continue;
> >                               }
> > -
> > -                             set_codetag_empty(&ref);
> > -                             update_page_tag_ref(handle, &ref);
> > -                             put_page_tag_ref(handle);
> >                       }
> >               }
> >
> > +             next =3D pool->next;
> > +             page =3D virt_to_page(pool);
> > +             clear_page_tag_ref(page);
> > +             __free_page(page);
> >       }
> >   }
> >   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> > --- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-w=
ith-dynamic-linked-list
> > +++ a/mm/page_alloc.c
> > @@ -1255,7 +1255,7 @@ void __clear_page_tag_ref(struct page *p
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> >   static noinline
> >   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> > -                    unsigned int nr)
> > +                    unsigned int nr, gfp_t gfp_flags)
> >   {
> >       union pgtag_ref_handle handle;
> >       union codetag_ref ref;
> > @@ -1269,17 +1269,17 @@ void __pgalloc_tag_add(struct page *page
> >                * page_ext is not available yet, record the pfn so we ca=
n
> >                * clear the tag ref later when page_ext is initialized.
> >                */
> > -             alloc_tag_add_early_pfn(page_to_pfn(page));
> > +             alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> >               if (task->alloc_tag)
> >                       alloc_tag_set_inaccurate(task->alloc_tag);
> >       }
> >   }
> >
> >   static inline void pgalloc_tag_add(struct page *page, struct task_str=
uct *task,
> > -                                unsigned int nr)
> > +                                unsigned int nr, gfp_t gfp_flags)
> >   {
> >       if (mem_alloc_profiling_enabled())
> > -             __pgalloc_tag_add(page, task, nr);
> > +             __pgalloc_tag_add(page, task, nr, gfp_flags);
> >   }
> >
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> > @@ -1312,7 +1312,7 @@ static inline void pgalloc_tag_sub_pages
> >   #else /* CONFIG_MEM_ALLOC_PROFILING */
> >
> >   static inline void pgalloc_tag_add(struct page *page, struct task_str=
uct *task,
> > -                                unsigned int nr) {}
> > +                                unsigned int nr, gfp_t gfp_flags) {}
> >   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr=
) {}
> >   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsig=
ned int nr) {}
> >
> > @@ -1867,7 +1867,7 @@ inline void post_alloc_hook(struct page
> >
> >       set_page_owner(page, order, gfp_flags);
> >       page_table_check_alloc(page, order);
> > -     pgalloc_tag_add(page, current, 1 << order);
> > +     pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >   }
> >
> >   static void prep_new_page(struct page *page, unsigned int order, gfp_=
t gfp_flags,
> > _
> >

