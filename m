Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8BF606A334
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mqeR3tq8
Received: by kanga.kvack.org (Postfix)
	id D6FDA6B0284; Thu, 22 Oct 2026 13:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20B86B0296; Thu, 22 Oct 2026 13:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FDE6B02A5; Thu, 22 Oct 2026 13:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9515A6B0284
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:45:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D3081C27B2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:45:30 +0000 (UTC)
X-FDA: 85350989220.07.259A778
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38271180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:45:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mqeR3tq8;
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792691128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/kJZkRDh+A2dbcPNuvHi4UCiR28b887/rQN2752RCM=;
	b=gmqeQiBVSnLIFTuFW45r6E624lF9zNbi5q8HZknNTpjy9gj74kdt7SsPLVtYhtKQPrPKxj
	9IZem9lKlGtn7rigrgEoSKi6OTFo2q7wsXBG8Hbjb2caCGcdkajnWzymHC4dyWNkd+5JGz
	ePvgYam9iH4Zw43370jOsAHTpOzKEiQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792691128;
	b=B80f4qlCaHHtBIFmRZqCgHyaBNVLTVJYmOgc8kT4PzUyQIRXNiN8J/C2CgxZiN0EDJDxJo
	EH/OKzTBca0MYsrgeBIDQLo9O2HBDBrkF9Z7IKRMv3ZAESw/qbGqg5Tnm6eHSE+RDx7YH6
	SB2fRvwk7rxMT9oezuB8/Sq6BknCsjQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mqeR3tq8;
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c468bd799ecso10008666b.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:45:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792691127; cv=none;
        d=google.com; s=arc-20260327;
        b=K2nkSZyNeig1o4+5iDz8shT8gDxLxqejUKfS2sWguW0+pMlN79o4hUv0kPobsIUgGi
         DA7Pf6F7go7T55/tDCy0b2HUtbdAT+VmAWLRFBLL0I1QnGr1lq7E0z0KiEeRpvp8PwEz
         xOkeuOuczxtYoNeprGoRALHCE+JoIQ3wD06mN8180dfQeMaRXiZiiG6tIplrIR3blDrx
         rcdYZaEQQnH+bl/MKfJ2P7S/NeaTa2sbRywIR58NF9zcTA2ywz0jBZrDuN+LFNZ5e8p3
         kIFeibKAJH8+axXlBaMfHEZZSf1u8uBaJqFBhxXw7S3pteAMqooUju0HReBidcddUTTC
         R6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/kJZkRDh+A2dbcPNuvHi4UCiR28b887/rQN2752RCM=;
        fh=1ko4W8RwZw4bk8Xy8u0THVJ1fv84s8ZANy+k1gwD1yI=;
        b=hn80aoXW2xrO74F/bpmY7oJLDy8BVqqtR2jnNfXHjWU/GqgO+YYMRA/CdZVPIv/r0x
         zOsfVjPvNpOKMAwdXizs6j+qlDyYcoEVyS7lpoAhM2m1mw3wrRQChlv2f3xwVTs4FanK
         XGcmR1Vhti2GejDl/2jkQhwB+JkykmglaOPkM1RiZQllBuJOKaWJKFp6aZjQqd0r9tkA
         xJd/f2JxRMQ+k1IBeej0vNDevuMspisq69oN8Zs7Kshy0mvelfoT1GjaxaX1YIZrUtOT
         XCTS+fqf0ULX8mNgj2mxfO0+F82OQ7lQXEMdVe+g9/38PbAQnjKYCQ8fzXTDOKZVsGIT
         5A7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691127; x=1793295927; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/kJZkRDh+A2dbcPNuvHi4UCiR28b887/rQN2752RCM=;
        b=mqeR3tq8tOWwLNtjiTWBgwf70hQBZvOEUt/8Vpe6ljKE7n3CRZDfWHGCMZ/APfNg5l
         /zSlEw0zIgJFLah58mjIAOa5cxE3bDU9qSsoDP4TA2+5Vr6s9oJnPeEm29w50kgRpSe1
         Yop/kh9xZQehVkP50TLZuF720TFrsw7LNTYP3X74Q28SGK3y8LPjVuw4/Kht5SceaiAd
         IB1RSISlNbRO+ANRZS+NCoTdHAQ3mxYHa7oDg6yG1SK6BKb3rL0GFIBBL8vWilsFhGA7
         0sI/DMG5cRZPmNeZ1fnv+SWTYozAcDsjHZRcjvDU8DTTnmLim6obV6ruJ/HZr/Asv25s
         YHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691127; x=1793295927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/kJZkRDh+A2dbcPNuvHi4UCiR28b887/rQN2752RCM=;
        b=JVyXhxajY2mKm2tK4GALzmZDSdfXb+aCcpNCjNoJxFWsua4B9DG3GVbfg+OJM0vxv1
         sMJcqiuccaoJTEyjYvbwI4G0qvcssMFJUpRSofGfZs2QToLT+ikBDIJg+WXfpqJT/eVO
         cRk/RaGRvdHoeETYE3Iz2wE4KuZs4eJSIVo60LLlQ6fMkSIgyzuGUpClPWB9PmGwve1B
         Q+FL3SeydlPkWiegcdtyHuihdhWUJkn8N3gr5bLlIWw6HqKuHvqt0DIKzYtxq914IkV3
         2fnYCQWmJWsRBCb6fSmShgdvEXBylW+zRVKbO7pNlj9V54TuEeDWnfSXlhAjllaJ2ikt
         RFmQ==
X-Forwarded-Encrypted: i=1; AKwUvBz//W9sOepCx9MUS3F0uK7Vm6SvNAkOxxs+69Xfzj0A1v4RKAgzbBeQIF5m0iGF66oTEIyC1p6aSQ==@kvack.org
X-Gm-Message-State: AFq9FYKnuBvJdPQ7FReCzDfAveJVIPqJM0V4+CuCdJ3pkH1Vx1fMeFR/
	fmNhPaP75h94e6i1+8pyF5Sge6Y42Ukv0gEuRV5iN1/fq9WJSm3pM8jXOgwY+XkuyDw2DhKODqI
	8k5HNg6TX3YEygG1EwlVFLxvVpQgtg5eABV4t6Q/F
X-Gm-Gg: AYBFou3NvysEjkbYJD5UXWfuWTjdydj1m32laFnH8/GfBcm8yJhrqZn4QJ6cPerfsbS
	/BEwdmFcBK0NA53ZxIWyvI55UmVGtTlKI7Eq/9hFhJQYAevOhXXPw1sW7IMC65loIQKoLAUWCbT
	X3zi9kPfE7Qxr5bxRVw0aMjwfxObeEb4CfEGUBReKtUSfOApdcKhxrkm0tOyz8fh0D4Hquk8wDB
	HEp1RVO61LhSLHTRT9eSuhvdgkSci/6tuHvctHV8BD856j7uQoFhI4gApjAanS2MOiVYAYCwD1N
	CAXGljZEUSukh3S1ndSE3hiG8gtOIGBBOUhzfyUoSWBolHSj9u2BdDqYN5gi6u0+aOhudB1HfXQ
	WDfwVLA3Ruhj5t4iRUvoFIBqX9J0YrCKGFg9qxKalyPKyq/9ZCxA6FCST4jyFSh7zQsPLDwVnFr
	sbmWMTqjXidnz/qixjpE8F4YbAjkSJ+LBKSwPFyVMh/jLrVI2OkbeOkGeG4301V8U4fpck1FIiW
	UQcIDcN
X-Received: by 2002:a17:906:d553:b0:c26:1649:47ad with SMTP id
 a640c23a62f3a-c467976e841mr649670766b.35.1792691126016; Thu, 22 Oct 2026
 10:45:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-4-jthoughton@google.com> <B8A44041-1516-4405-976D-534AA2412A49@linux.dev>
 <CADrL8HUOJwEgjUzefxSUa=AZHj4JO7koonj2_-WYhcL8QcXPZA@mail.gmail.com> <440A9FCF-2B5D-43A9-9B02-C32F5955AC82@linux.dev>
In-Reply-To: <440A9FCF-2B5D-43A9-9B02-C32F5955AC82@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 22 Oct 2026 10:44:49 -0700
X-Gm-Features: AclHuK8OCQjsmkJ8ztkh2B9wQVyT8iKcOFLwut_LnlB7__hy8ym6E5QTYBptOqc
Message-ID: <CADrL8HWNaurYHGnpvC9qwr6bVU74YhhucCuhoVYcvqmSX+R6+Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
To: Muchun Song <muchun.song@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38271180002
X-Stat-Signature: 1izpz1ue6fnw9tgjogxzdgyrapmaai4a
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792691128-36832
X-HE-Meta: U2FsdGVkX19XTmia5bo0yAOcEg7/s20VzyjV4KTpI/tUstzdJXd0SOlBuy2Y28B0h/aQVXIMqWRDhKqwXPAHWgv/WTx2afCm3kO3T1rbviDL+r2Pzh+gS3BUuoC4alWwulcoIYNJYJGaSk38NMT4xJNkABiO6XG832lhrtn3u0SLoWscwhxwKyB8QW+GVafHrLdfR8Ti5oM0Ne/RWcBI5VXiOxDwLhQcZLRF5/0fojKoLVrqKCr7aKUBqqgVgjIBM9hej3Q9uZ73gE5BjUUxnNQcp8453xX+YHCRz3HFUGnaOGktuKTQH42iKMQTsR+1vNJoRZD39OvnMDB1ArjwqXvoXfyYLTOmHCcKK8bpyXJdFym7BRxsnQhkfceksciTEiX+vZyzu7mOS9Ml3SaEr4Syfb5kHRTNurJq/YG2OMFQW9s4RgRQI1XXgMZUshq5m9DihnapnVC2V3U/P9VdjAohRIwsJ3LVCa8Tuo5qInYW9bwP3v+fH4nmegwRwSOVtXWOEAE4upHHTALQKIzQ0BE9pv46pBFEx4od7sR104EcdB24GeelwkyNbCHz5SAwgo0wZnQPPF5Qbhy9vgC3nFlKlF9jiyJE/GdEXWbAJ+EJcTihoCRjydlT+qM+60colrDDZocofLKZEGfWvUQgRTnJc3pBbSW2sXdqSe92BtmDO4fPfHejdGH6LaL2YVmOcFa2cFfSvAEc+UT31Thh0L+n5gljVtiKEOZDVhwzGIbA6PT+QpYwH8IJwN+4ev4t9pHDyalHwxb91jav5/xTThHF+xl2/LrPXWNrCyg1qtlFhZvP0ylFn7V16JPKmVXECXTC2Kez4K8qXqBxgF9AREqF1QXssueA6+HS0iAloLEkBLCVMSf79UiMhSchNjmdOGYWdXHOI9f48O22em4odYRAGS/4/uHbTRVAla6SfAQWb82Ma3q/PznRFYzKTw0oXuHudJHLa0c1X7/1j8K
 AqWYm+CI
 GhkeMP9wlpW4cb+veiKFvqMdQT7SZw6FCJE1gCrUSuxZgp8uGOnuYMDMDPnskZlzzAZaqznolp8SGhD2vOlTPCG8qOJii3sJnwPnNExuSH/hEE4nR88LZop0Z9L2ePYMkigFiAaXr4G5XxknjvnjpSulUTgz/o4ZBq7HER6iJwwpuJy1Use7Wj86ebp2GFYG1MHn0lKzrdlUALSm5kKyezRuns8ZF2/LKX1Cq23W1kMGSARs1NmJgaSYNsdTN+N88WET+2wTv1f2uex4/WIBOV+85H8gWWX9JWrDq2Hh4REV/ifyqqoZrfU9YNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 2:18=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> > On Oct 22, 2026, at 05:59, James Houghton <jthoughton@google.com> wrote=
:
> >
> > On Wed, Oct 21, 2026 at 2:54=E2=80=AFAM Muchun Song <muchun.song@linux.=
dev> wrote:
> >>
> >> Hi James,
> >>
> >>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrot=
e:
> >>>
> >>> vmemmap_remap_range() can potentially leave the vmemmap in a partiall=
y
> >>> optimized state. In this case, a TLB flush should be done if the walk
> >>> caller asked for it, even if the optimization was not fully applied.
> >>>
> >>> A follow-up patch will more completely deal with partially-optimized
> >>> folios.
> >>
> >> Why are we dealing with partial optimization cases right from
> >> the start?
> >>
> >> I know that in patch 12, you try cmpxchg 16 times, and if it
> >> fails, it leads to the partial optimization state. What I want
> >> to ask is, why do we limit the maximum number of attempts? Is
> >> it because during testing you found that this kind of failure
> >> is very common? If we did not limit the number of attempts,
> >> was it because during testing you found that the scheduling
> >> latency caused here is very large? Or is this just defensive
> >> programming? In my view, scenarios with such intense
> >> concurrent access to these struct page structures should be
> >> very rare.
> >
> > This was done defensively, yes. With 16 retries, I never hit this
> > without fault injection. (Perhaps I should try with no retries...)
> >
> >> If your testing did not find any problems, my suggestion is
> >> not to set an upper limit on the number of cmpxchg attempts.
> >> This should be able to simplify the design of the initial
> >> version of the code to a certain extent. If we want to
> >> determine whether an upper limit should be added in the
> >> future, I think we can add timing monitoring in the arm64
> >> try_update_vmemmap_pte function and trigger a warning when
> >> the measured time exceeds a certain threshold. If someone
> >> reports this kind of warning to the community in the future,
> >> then I think we can improve it at that time.
> >>
> >> What do you think?
> >
> > From userspace, you could use kpageflags or page_idle to continuously
> > access a single struct page over and over again. I think that's a
>
> page_idle does not support HugeTLB pages, right? We should only consider
> /proc/kpageflags; reading this file requires privilege =E2=80=94 unless a=
 privileged
> user intentionally creates malicious software.

Oh yeah, page_idle only uses LRU pages (which HugeTLB pages are not),
that's right.

For kpageflags (and kpagecount and kpagecgroup), I still think it is
"bad" to provide a mechanism that allows userspace, even privileged
userspace, to permanently freeze a CPU. Fuzzers could find it, for
example.

I wonder what Catalin thinks about my reasoning. :)

> > pretty good reason to have a bound. Also, the AF can be set even
> > without an architectural memory access (so a mispredicted branch can
> > still set AF, for example); that also makes me want to have a bound.
>
> However, I don't think this scenario would cause a significant amount of
> concurrent reads.

The fact that AF can be set without an architectural access means we
can't really reason about what may or may not set the AF. It
definitely seems implausible for the microarchitecture to continuously
attempt to set the AF for a generally-unused but valid PTE many times
in a row, but it isn't forbidden (as far as I can tell).

> >
> > Catalin also said wanted a bound here. See the bottom of this reply at =
[1].
>
> I see, but I'd still like to explain my reasoning and see what everyone
> thinks.

Thanks, yeah I'm curious what others think too. I can go either way really.

> >
> > So I think we should leave it in. The extra complexity is pretty much
> > entirely in patch #4[2], and I don't think it's too large of a change.
> > I hope you agree. :)
>
> Because I personally feel that having only part of the vmemmap optimized
> is a somewhat awkward intermediate state =E2=80=94 the all-or-nothing sem=
antics
> seems more natural to me. At least until a clear problem actually arises,
> I'd prefer not to consider it. At the same time, we can also keep the des=
ign
> simple.

Yeah that's fair. Thanks for your feedback, Muchun.

