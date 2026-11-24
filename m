Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E74606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RIXpG4xO
Received: by kanga.kvack.org (Postfix)
	id 3043F6B07BD; Tue, 24 Nov 2026 11:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D91E6B07BF; Tue, 24 Nov 2026 11:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF706B07C0; Tue, 24 Nov 2026 11:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFA4D6B07BD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:38:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86A7880BC9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:38:01 +0000 (UTC)
X-FDA: 85470569562.09.06266B3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 885D9180012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:37:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RIXpG4xO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795538279;
	b=FAplyEVtJiPpsZDeUU39lfxZ6IcWBV9fMensXtVCHDQUygfb5j8SPqWbeWP1kYO6YfVrw5
	17+36k4TsxDn05ozon5H3vwR+SgTHBOrTBIGI4sNeKezsWJGTr7AZu6776cxDNqCcTtRgg
	hFhiZdAFGagHrpuSEEjRbkEqS2AX/+4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lrjCyd3ylni+VlZA6CzA7gna3TSOAbXroD0aGLUJ3s=;
	b=Oj7nGT0PVKRtFnPeh+GZW+eI1RLRUDSAc9QQpkRPNzl4kFlwaqQpHdKKZTONlRxB3zVVvW
	n1Y2BzRtRWJLBj5ndnNgg08CMCxL0BVlUMbImgvdsp/D3ys0u5cXij17ntLmBOt9at29BU
	28eG2YUL5XQAieB2MUSyZMIG/iYQx+M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RIXpG4xO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d21051042so767737966b.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:37:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795538278; cv=none;
        d=google.com; s=arc-20260327;
        b=nWtpAoEezBJ1PpiAVsYYY/ejYuOMIL5oc5nR1vBd0faEWEFM6yC2XuCbKDUjsK/kIj
         PWrsNfFDMYVkaLEN/BvDPO/5/1Tcp8X+CIOhi5nj1wfsK5CMeRXvcX5I2DQNLc11MIgD
         7MugaJ3pj6SI+tP6gl6x27yabPq9nRIXHE7Tz7v64uvfVHy6YsI9M1DAVOd8wxWK509Q
         5Nd5dwIalDXDhZroMdOJyZ1jQrpEudQm5ZOW6YH8dxEYi0hQjppgUTI8k7Wdw8C476cn
         Nc981DLp1SSoIHK4pWGE/HPtPa3bO5a1pGs81k5x+5yIo7UmaQI3lTt4GEkM07e5lbCE
         T65g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3lrjCyd3ylni+VlZA6CzA7gna3TSOAbXroD0aGLUJ3s=;
        fh=RHaav3uuI8t39Vc3snuMqHXGV6AQySCGb+jksEerTTc=;
        b=M8Jxb0imoNLyV+c1bRtBo5znx/nVDx+hnrIifMeo7Et09eCSjtjKPlNjKq7UuQwiFR
         Ob2j7SAInyXLhMiE0Jltj/zxl5cu7QtWkeJ5PrwXwe8B76GMeH28p1kv8e/qRPfeIvzN
         qZpONCde2MGHMR8sunQhflKoRBx7XhTGa9kCoM1nZRvdsNL64MxFQd+EttZ9I9J/aEW2
         BITaOCT/ZMod4DNrseY03ljYHgyp+9b5Ji4LMkp/themZwG4zrRYyNJsQEuiBhtVp8p/
         xOdcDoae5/HBmPkEoI71CRyyYSeO5ZMGtdvDwu5l0Sqstz8QCOkOrez5P+yLcJ0hAiUb
         FQcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795538278; x=1796143078; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3lrjCyd3ylni+VlZA6CzA7gna3TSOAbXroD0aGLUJ3s=;
        b=RIXpG4xOi1Po+1RnGkli3VZFBUIV6be2lzre59llEkWAKtAncQAuxQAy3DzAvP9Rns
         DwZ9U+htK6VnAeRXrpVVXi36bQJc81xAeuvlSHh4vX1TNh1SP5x/3lI+S6ks3sXwJVYf
         TNbFqDwcb/5s0kLdna8NeAVkxoDRvVC7pE9h5Z/ZeiI5SCv4uW7/uiMR0aBmwZuBTYlf
         QKCW/QJKsli+kMM59b0ke8PlPY6vw7YYj4a6fADexibHTg4UvM9su7ONurpdXVnhL7rH
         2VgX+nkl8MkHsklynXoZpS9nUnTUHh+Wrw8fFDE7DiCAM+TRndvwY2hIjtMYzK7sS8mT
         u/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538278; x=1796143078;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lrjCyd3ylni+VlZA6CzA7gna3TSOAbXroD0aGLUJ3s=;
        b=DiA9kSP0qG8RrTL78AXChMsYKc5bGrWTISNmlJ1mbondm31bHmQVZxdvgBqMsaAiUH
         zACUnF8nxA7vS3ZupV6ATBgIey+2Jwdv5L+VuU30wGBN0hL4TPtfPUIXqovHkoFAOz2X
         fI/VEq3Bg2ui0qwMOCz/U0RJPIYz5PSfBVXbW8msjuPHsQldrYf99u2wGDXNCIJD9N+R
         RCICB8Mj0NlRVHFjcv/wH4iPgGWjMgCssaWHh2OsMbx2khzqjhbZByBf6cVkDY2fm3ar
         DoSiWBnKl/9fLlzWv+0Kvu+vFOm8n/YozNihZ4JpPPPKKrFOnKh7jtTCvMTR35zDv67Z
         A+/w==
X-Forwarded-Encrypted: i=1; AL+hErEVsHTYeLhIYT8bEJgHa7C8P7640f/z9cFX3eIDHzCX6xkNaQtX4HJvp/jHwHDVopWps5LSBYti/g==@kvack.org
X-Gm-Message-State: APuU4Z+0mO+UGdAKftq92RwK481uml8PUSt9iG4dOEOcVcDy5cmfSc9g
	hXx8G2UVNn0+CLuqZyETkuieAe1GC1ODETwY7nU46JYVT3SwlOjRTdKjMEe4kGn1995H4LN8fBS
	R5wyDFq6FifHDaZ9qc6XfzzdMKK5AvlEkm4lyVBEV
X-Gm-Gg: AZFdTZeZTI4/vwBJbmVMvRP4cijWD2a0zhMkfqgsjrV0STVfoJsil/Zvn8vCiMFtVjw
	wbImdyWQbQYe0Wvcl6X56YLtlkQ8MGNpH8gQoe7/Un6dQmAyiGBTU7IazfhrwIqwTboh6Tj1agT
	MNrOJlmBNP8qmdj2JW+lBSG4xJnfSqJCkL69P58+fq49rVt/i5NVEZi6QDP8p6jkonUC1V470lX
	rWBR0m2+hp0PXZCgnDUzL1ARILWROlZUTac9pIcCZ2BFNEFwRvJZLb20nTYWc/IlOHe3D/4an5J
	vzwfHR0lFtr1xImivrV4fA/Av6tXwb6iO9IZ6Zn+6MjfMdaz9QVA14jUqTfDeRXvpx2eQFZAPcT
	C0Y77K4VSqoKhnE3v+tsryAx5qa57DII1uD7e4gKPgX2g53fxRfaJn8tkx5rdUx6ErfNbjZCvfi
	eN+NK3Knc/IhAhIjBuTmYYgqA02p5gSvILoebpjmoiYC0Jf07KcJQ=
X-Received: by 2002:a17:906:da0e:b0:c50:5186:6dc2 with SMTP id
 a640c23a62f3a-c513a84a4b7mr889148966b.24.1795538277335; Tue, 24 Nov 2026
 08:37:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-3-jthoughton@google.com> <sashiko-outbox-228631@kernel.org>
In-Reply-To: <sashiko-outbox-228631@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 11:37:20 -0500
X-Gm-Features: Aa3M54perRENbQqBcvqMB0T0l__zpVfhY9WhyMOK84YMmPr-DpW-cRt3dY1naHw
Message-ID: <CADrL8HV0artLopXqsRyEfxRd5FrAKKXnSotwrTYV+7Wcd=D9mg@mail.gmail.com>
Subject: Re: [PATCH v3 02/19] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: rmigzmnb1wxt9ex6cbrhz5oaugdngtfh
X-Rspamd-Queue-Id: 885D9180012
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795538279-494190
X-HE-Meta: U2FsdGVkX1+02r6OlbMDx4UTs8IPNaErtJyWAhqC8sX9ZQHXBz+0LBhAuMZJxvYa7n76eVUln5KX3EXr1cusziHfyzXPbfEGwMSJpcdzCORhtY5nAOTrOYkeDyRIPaZuE0XD2zjeMSM5VyeaazpOwylCCorKp1YcsAgiSGozLTKFVwzwLc3RaJHk4VT6UE1VttOD33Xvoht/93r3BMJKe9LfOld7IDYMu729a8XzKIeWyUkmNeko097hiAgcEg5OAea+vGAZT8qsi0X5eOqAo/DACjAM6+vNCa3XYmN6/bUCDZCk4890QdOZ9gwqCDnDGTDZQ6VnmbIHM+6eFF9ynFTVJ0h7Ki9Iw8CQ7a//hYb//tnW6t959drOPWD0BKO5E/Dnv9M11FI9kZG1yQnh5zVa5WI3vSglJCOks/AouUKa4yayTJMdqmil6xe/GS4SBeC0J2bui3dh6AfSGFYytdX9CF0UKpZCjT8UmW6BeLXt7FIT0SbwDNG7/tjm85fvL85rXkC/hoxK7AiRh4vQ/fdw/4Vi2ZPuw/zU6UxUn3L5u+J8HQS7wcE51iK8e43ZEdZEC3CjENqOkwk9i+hUa9UhnKCsWFiajzl2h8P6lW19VU32EEB7JEITjlC/++pE3OMSgJ50tkKlSE3bWdBev/9rNfPisycgIriaSodLZKfuYLH7bFCHCgL8B7O/1c2E9QGpcEWjI5LLp1QqTt/QtMnDwj1UwDQDIc/fDBbXc2uX2/bnXYeyUk5nlcm+5fmWt3YYudOL3tb5tDlHPExqNltVGz2Iz8IclZXcdlaxwh3taz+uoy4CQTZIk8J5/jJOA53Og6JqJFMTBOhYoPPAMWQuTJMWieU7YVCu81jL3nsAfxjqtlk6HfwlL7iC3sbRM9lewskpq75+bYAPkLaXQD/e3QizhUdvos5y3nIdgYXO5GK8Z56PEFOs1+FkAb3lcJP/hFjim5ILPw+qe7p
 PRwWM1Ub
 dQ5tUKfZrQja2UAlz54y8Hywu0Wc6WW7Z/hCVxtRIYgaSAp+upMlKbuRd/9PkwiTmnEJcsUWw9qhd3TPW+eegFmq5sItvJX1aGPywLFiwIHi8CJhFc2n/BU4BGeo6A4n/jiQGyEF4TqZwuMhlKdG98K+kCe/GDauvFIH1dUiHdTNxq4VoePWDYQCAvW1REX1eFl7q1RrdFMtwl7BWbszZAzyG0yguzvdYXbIVHc8pvklFPzIvL7We90m2ELwEJ/JT7zVxkWoypUQc+OGKVRKZtYt3od7PAWiYNE0RbjqKx71NtCqE/3+Kn83Idj0GgKMIlfqgEKOevs6CqK7aC7XwDjZhP5w5XoebQ9hRF1girBX1rY4DtMV6rj7t7J4hPVP9iNfnbDQZM6vlj79oMKdMClbOoeFo2kFoddyTTxdD5cr+TTTGkwoxTuz8nT1mPBles6URygD3wp8TnQLzda8P/Lks82RcRHjVwb0uPZE/+qwZ3eNpSpRVe5YsVrOPkiHBayG7Knpr8edx2a0vH3nPRSkJvETRk206FOvRP9bs+F37ZGgeGwrTlk+MZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] mm/hugetlb_vmemmap: unnecessary TLB flush in
>   vmemmap_remap_range() on error
> - [Medium] mm/hugetlb_vmemmap: partial HVO state retained in
>   vmemmap_remap_range()
> --
>
> commit ec5d75eb023f87eb7c8518a7fd62d721c52bb9db
> Author: James Houghton <jthoughton@google.com>
>
> hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
>
> This commit removes the early return on error in vmemmap_remap_range() so
> that flush_tlb_kernel_range() still runs when walk_kernel_page_table_rang=
e_lockless()
> returns a non-zero error code.
>
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 09b9fd83c1985..7be08c68c2f18 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long star=
t, unsigned long end,
> >
> >       ret =3D walk_kernel_page_table_range_lockless(start, end, &vmemma=
p_remap_ops,
> >                                                   NULL, walk);
> > -     if (ret)
> > -             return ret;
> >
> >       if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
> >               flush_tlb_kernel_range(start, end);
> >
> > -     return 0;
> > +     return ret;
> >  }
>
> [Severity: Medium]
> Does this issue an unnecessary broadcast TLB flush across [start, end)
> when walk_kernel_page_table_range_lockless() fails with walk->nr_walked =
=3D=3D 0?
>
> With memory_hotplug.memmap_on_memory enabled, every runtime single-folio
> allocation via alloc_fresh_hugetlb_folio() -> hugetlb_vmemmap_optimize_fo=
lio()
> hits PageVmemmapSelfHosted() in vmemmap_pmd_entry() and returns -ENOTSUPP
> on the first PMD with walk.nr_walked =3D=3D 0, triggering a full
> flush_tlb_kernel_range(start, end) despite modifying no PTEs.  When a wal=
k
> fails partway through with walk->nr_walked > 0, this also flushes the ful=
l
> [start, end) range rather than [start, start + walk->nr_walked * PAGE_SIZ=
E),
> and vmemmap_optimize_folio() immediately flushes that prefix a second tim=
e
> via vmemmap_restore_range().
>
> Should the flush be gated on walk->nr_walked > 0 and bounded to
> start + walk->nr_walked * PAGE_SIZE?

Yes, I will do this in v4. Thanks!

>
> [Severity: Medium]
> As reported by Muchun Song on v2 [1], does this change and the follow-up
> patches in the series still retain partially optimized vmemmap states
> instead of preserving all-or-nothing HVO semantics?

Yes, this is intended.

