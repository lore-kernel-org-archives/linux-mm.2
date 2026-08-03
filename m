Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4930CC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267126B007B; Mon,  3 Aug 2026 13:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218BC6B0088; Mon,  3 Aug 2026 13:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1082E6B008A; Mon,  3 Aug 2026 13:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E012B6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:41:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F08A40764
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:41:45 +0000 (UTC)
X-FDA: 85060675770.04.346909A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 78EE4140002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:41:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Esam6oyi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785778903;
	b=VmYNG8VyANTPFNs6EO38dtdWciV/AVM4y+hE3+VMH+IHGt72oL0EWlLmZXxvSH6ZtGTLsz
	CfqQAOQCv83PCg5/rH1Axr85Cvf8WDaQ7rpXNd00d4xalI6Qil0Ldo7fGf7nkondORu8GQ
	7hfAqpkVxBxZBqfnN/8uMgCX8Zk6Ve8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Esam6oyi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785778903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+s/NpsJ2vxd6nQf9mYbVKAEJ7bH7qIbDORr9taCqPo=;
	b=ElF8nH9VmPGFbA3ckK1vF1LWPlXpZhDwW3tBDK8TsObwVlrNW3GwHvJXqp0fhL+nQOzyE7
	QxHV0BYWdXqc8nBTVeEXfQISgXHFf8BmiBgyWAxrdxGFMmKQISv8i5j1hEAUopuFnXhWYm
	ZDaqhHB0C3CsjSkZoFrS/v417PrlBsQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c15a5b265so15631cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785778902; cv=none;
        d=google.com; s=arc-20260327;
        b=GpgSHKys5AOp5jX5lBs7YYLPKRwkzURQ91YK8CL9BpfLyR4CbRLBnBmtEUgloXrKLj
         bZI/LdzsN+YNao3NAsBJDpQpM6OFeyJelal/o+LN1WZEST5A5+2XUHxC9ZIuSLQJsH8A
         Zk3gsVtMD9OMzDL9lnMERDrEQhxwY5W7iEFnaYVIQnb4F2228f4SYEsf2XPDazEUycqJ
         +O4dCiT1UotSz7TPwG2dqA/vIMNnmwwtVpaGAJfiVu36+BupzX5iUluhF8FdnknVXfEY
         gdb0ij3D2vlrg3k8H6FzH9dhmEN6cP5gKt6SzEupejGQRl29JhUxUAo1pGkXbxPL2pcw
         NWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m+s/NpsJ2vxd6nQf9mYbVKAEJ7bH7qIbDORr9taCqPo=;
        fh=roDlx8Q+Ng+TvpdGid5Od+qq+OPQudT1DUrh79BkTlA=;
        b=D/Ars7KXfmFq2MH7oINgDuzPNI0RtKukZ1MDtrtVR3SKNo2izuoVLMxJWE1Yteymfs
         5aqzkreZsmyTVRRPMD3CRqTObgH15zMhDdU1hBcph82xGOV13ag50yelf5Gksmq80W73
         DjQrg6h/gowFMHkgbsDB9OlTUmrxg3D1b9+xZS3SNzsuvCHVLByDZo3B6ISwXp2jJZOl
         1L/TYC0G1g5o5ZKtRWJn54bpuOjyK8l0O6LyhmysNoW9gfhIjIDNqjwI1TwjQM0oPIrd
         ffx+TVl2I9TRAQK4/radolD+36bDvZDeEN5yH/SKRkN3jO559OMmDo53uBA0Xrt8xH9Z
         i0Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785778902; x=1786383702; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m+s/NpsJ2vxd6nQf9mYbVKAEJ7bH7qIbDORr9taCqPo=;
        b=Esam6oyi8ZDyUiInH7lLeyx5xFkmRHXnlQE7YQGpWrkU4PH5xHozE1LiPL5MOeAdsC
         0iG4p6dTEoFaD1TB0JilvR94ABJsy8GZpB0EcML5t0DdcWrAvk9vZ62HnA+cVsGupwcA
         6zzbKOUMKB7Xs/AwH5gZvzZsWdkJOrC3mfIh6UtfLqIF3NHL+BKuq6vCqYtq2o9j1mzI
         IUDRgJnOi7ZAXZjyn5C5b0nWSqODZ9th3k9HQodF0Oxd/zR4B2golWMvFHyWIhM0ruSs
         a1eYSvwth+9fWhjxirXsYjXDakhnqQO4AQLLCDnb+N+ePsyk//xcrezLqgtXm2ziUrab
         PugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785778902; x=1786383702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m+s/NpsJ2vxd6nQf9mYbVKAEJ7bH7qIbDORr9taCqPo=;
        b=R7+N3LmuLEKw6nf6eyL3ziIa89TffgTMSTKOXBOrGcxGY3idGYzIrdcXGkH2rDHu8B
         Phgn0NuIp+0MvvEiW4bFoqSKd+FCvJAA51Oo81WpCScg3sjOnXwzKXjE45DR1UR/2RS0
         8bhryoxG6Mb8fj7PlnZ5uM5b8wDI6GYghmp3XAqVBlRezR4fb352prJomBFoeW77xGOR
         EFN2jU/tnCLpVgzeX46OqJ9bf97YsDmUYwDM6jBOvhFbW1BqoDQrEPWj+QZ0Y+oiz6qF
         sOTMt48iVY1xar4zyoYr6plApoZWAeSFpA4wDQVtY4F0G4213HgaeKcqBanDUw0jXMOd
         yQKg==
X-Forwarded-Encrypted: i=1; AHgh+RqlYrvFNyPWmMC4W1Cub/swMsSGZscgtOaBHejljDEA128RLL/DKN/n9QEdK7d4WMiYDYFkBm4e+w==@kvack.org
X-Gm-Message-State: AOJu0YzjZDgy7MgCJqTuUBvJ7hU7IeFio8PlItbo0vSIhWaODW67nMl/
	pL23plqPXZTfMyV4+Lt4Gun/72clNLljmuaLsCZ13yJcTJ/ar/HX70Ui8hcfL+lGfYbqtlzx6ik
	ss0J/hCHE6f/TecRjL97B2kSgoLpBZ3EsD2bvGPGI
X-Gm-Gg: AR+sD13+tpYkaZtgI6pU1cjjzh4gBgmL+a1AzYqAmhDuwxQ5Cn2Io+MXL0M0PSZoVNP
	bjnhCO5oTsm1cs5myMiJXBnbKR1iIpicOtyNkj6GT45MEtUCqBpcOG88nUeZ4vdsEJISJHr5tD0
	QyWMvIYB6y3bozYvHkNlZllqOXqgeoMU4Q40anAUCcTOPd1yHcZzh2QaH8MG/kCzke9/ia7b5N/
	QBMJQhxkIR3N/Z0YVgP8q8M9qztHDEGBygJVhO2nanci+dP3X7ME8gAfy73PhjyZVJQmr1mV6w/
	jAfH9nM7cakj8BXib4pLA4PPDL/y5fsVMDD/dMJrZnVmvP22DhgXUw==
X-Received: by 2002:ac8:5907:0:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-52cd52bfef5mr290051cf.13.1785778901815; Mon, 03 Aug 2026
 10:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com> <anC1iE21eonDK06n@lucifer>
In-Reply-To: <anC1iE21eonDK06n@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 10:41:28 -0700
X-Gm-Features: AUfX_mz51-1HJtZcwW0CSKHbqGIW5hvrnHOcHh2u8Z-lL_RgDncrj5lYR4-cybc
Message-ID: <CAJuCfpHNMHKgmP=JLPKY65e6gO6MRpGE5MjUtjd_-2+LHr2Gpg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wb7fk7xmpxt7gtfkc5ueco634tmixi4j
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78EE4140002
X-Rspam-User: 
X-HE-Tag: 1785778903-672842
X-HE-Meta: U2FsdGVkX18hwbRdfrplZhQZjzNt25eeyZUYewgqMXQKXKRwyc7IfBE/df2zzGZLFuhE8gdLO02sRiWbohGph8a6fYSjEWYIjbgyymFE5tzdT8YpuaigrJi6LcaAai2+8Cag+fnE/h/VF5t+gR9jLHewW0MAwnBGFS/eTccOiXfSops9GYwL7xwIES6dHWkIQ7x6jaZtyESbY4laEu1bT93KdQUjYNCOlu7P845WrfXoJBC9KO+sqhDeDl1odBM6v1hT5Gz093ru/vv2mHFiFUjvtmjSGfkASONPQzT1QrSF97Yb9ckUXBRROt1bkwyEM0dn5BhszcA9X6SGN1GCYU8e/j6eEYUhWsyqYxbKlozluGC2vxwc3OQoLHfZpQattGB+XeHWy4kyTjS3kOknAxCxqOS/mJYdPSYqjkjIez5eElhu5QuWD1S8RAFA7NK+iEZqlIxx6dCkSlmHCZfKmlCOzJ1mqbOcpN2jxiU9DfPOfjV97fh2hO5Q+kZXEC9d1rZL/u2Ml+EeVLpb4kAMb4ytZNKJonWmTa0q8cOseDGflFnY9qIqH/wznN2h+rzO/uojzJE16nertGub6W1sa94X7otcnJXfZk9sfN3YxnpkYLroxKF1NRuuWj2+lS2ebBjIPak/KChiV0aWit6RSQ4f3ez7kfKmPfcPUwC0H49fKl867mqoDT8GFuyzw73Yb38QUzalzid88NlgNZ26TVq4rczcFY4V68GIGgWyQzIoEZZp4AQUV3akyi+E781cLiob9Wu6RFyK17Rax6+w0jvPxdCLNZGKDAZf/Y30IP/kFoW9CUEfo9HfNfFJtz8KGX5eCI7edNIe+3XXE7FHT73JQ43NX9sS7XR0D6Le/jMD3jPIK6mqRdsV4o3cQ+AHO/mrgPcxXiqUPERXCIrIJSvPMDW6w2Zs/2zpr58m8lQQkDyheEcxYKg9PszH8SiJPtX0AkRZMrTlBzju7vj
 tDB9X5O3
 tO7rCvyYxRAXVzwsp38U292nsAZd7/Iw/lrexYNsObKmuR1T7lbGH4P25mLJLnUfLF3LRUxSuvDcAXP2IDbszA97lfJnx0MJp2eNIGhX10FVXU3u9S5MD6ngPYEfSZPKbvhFY5yyJOsx+OyaWU4W116HtCM6uNuA7fTwyyU0Mt87o5nqzT4yVwz9esSc8H6SyYQd0P77XOkwWZAHv2OXb4aKIKv/3Njg4gx6Fog6c1DG1NZft+BTohrdz+bpaE+pT1w1J2mKxtkaGLqMl2uREGPBWtiQ0kEM1ijeKW/OJPPpaPgTH4UAi9fRbHOgNC5C9eJzL0IHEi3prsmVVxyx0M3FqagJFfoQB0A0y2F0U/tiEb9oCXMuWEqQ6rAUv43/HgjG+yB2wk9+bCqyz/cH2yVxUFQMmIutjrzxgz7SL5pfe/jPBl7Nrf/KEali9lYTAp0UV2PQLNtYFn8kJ/7ZEbptyNo81erRzeLaXlyRWJ65HZpPeTS3S5wJiy7TM88SHCqy4h/75tWEbVZTcdcPUs9hxX0HfThJThGxWovTj5Slxf5CJsszRrqx8tQk4M3PxZ78wCJWzdjcoq6x1AfT6rHFRKZv2cxHRMXRo5czckV/zs+IWIrWPLEWptUtKeFG35LqUwEEwiTGknI4TqiikMkDEIeFeQefhB+ja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 9:08=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 03, 2026 at 08:24:44AM -0700, Suren Baghdasaryan wrote:
> > On Sun, Aug 2, 2026 at 2:55=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > >
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >
> > > The per-VMA locks have been around for several years. They've had som=
e
> > > bugs worked out of them and have seen quite wide use. However, they
> > > are still only available when architectures explicitly enable them.
> > > Remove the conditional compilation around the per-VMA locks, making
> > > them available on all architectures and configs.
> > >
> > > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > > when the architecture started using per-VMA locks in the fault
> > > handler. But, contrary to the naming, the Kconfig option does not
> > > really indicate whether the architecture supports per-VMA locks or
> > > not. It is more of a marker for whether the architecture is likely to
> > > benefit from per-VMA locks.
> > >
> > > To me, the most important thing side-effect of universal availability
> > > is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> > > per-VMA locking in all x86 code without fallbacks.
> > >
> > > Overall, this just generally makes the kernel simpler. Just look at
> > > the diffstat. It also opens the door to users that want to use the
> > > per-VMA locks in common code. Doing *that* brings additional
> > > simplifications.
> > >
> > > The downside of this is adding some fields to vm_area_struct and
> > > mm_struct. There are likely ways to optimize this, especially for
> > > things like SMP=3Dn configs. For now, do the simplest thing: use the
> > > same implementation everywhere.
> > >
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > Cc: linux-mm@kvack.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > > Cc: Todd Kjos <tkjos@android.com>
> > > Cc: Christian Brauner <christian@brauner.io>
> > > Cc: Carlos Llamas <cmllamas@google.com>
> > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: David Ahern <dsahern@kernel.org>
> > > Cc: netdev@vger.kernel.org
> > > ---
>
> <snip>
>
> > > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> > Now that I'm looking closer into this, I think we would break NOMMU
> > case because nommu.c does not take VMA write locks at all. So,
> > lock_vma_under_rcu() for example would always succeed.
>
> I don't think anything's broken actually.
>
> Per-VMA locks was gated on CONFIG_MMU so nothing there assumes per-VMA fl=
ags,
> but now you have stuff that happens that didn't before but:
>
> * vm_area_free() -> vma_assert_detached() - fine - it's always detached i=
n nommu.
> * vm_area_dup() -> vma_lock_init() - no asserts, just sets refcount to 0 =
(correct).
>
> AFAICT nothing else.
>
> So seems fine to me?

One place that needs fixing is in BPF iterators. They use
lock_vma_under_rcu() which would always succeeds even if the VMA is
being modified. Instead of removing !IS_ENABLED(CONFIG_PER_VMA_LOCK)
check in bpf_iter_task_vma_new() I'll need to change it to
!IS_ENABLED(CONFIG_MMU).
I'll look into other parts and try to verify they do not affect NOMMU
but ultimately I would like to run some tests with this config, which
is not trivial...

>
> >
> > Extra per_VMA lock-related fields in the vm_area_struct and mm_struct
> > would also inflate NOMMU structure sizes without them being used. I'm
> > not sure if this is an issue we should consider.
>
> As nommu co-maintainer, no it's not :) I won't have that stuff blocking
> important changes for real arches.
>
> Go ahead! :)
>
> --
> Cheers, Lorenzo

