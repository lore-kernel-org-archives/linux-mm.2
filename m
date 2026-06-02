Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DACCCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 23:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400296B0088; Tue,  2 Jun 2026 19:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7BD6B008A; Tue,  2 Jun 2026 19:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6F26B008C; Tue,  2 Jun 2026 19:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1913E6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:41:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACA1FC0680
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:41:12 +0000 (UTC)
X-FDA: 84836595984.30.33AB61F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id B26CC20004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:41:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOiKLCF7;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780443670;
	b=dUDmyADVzYrvcc48Z/kqvA+81pEh1sUjIwlrI6oNfu0ccBZS/4Ihetl6cnZAkKq7UZaKOJ
	1hbdpJn2DhRG/yod4aW88NMpmUvLbawG0YVJCzUrGMH3Kaqu15mqBH1eVT3GFLw6U0SPgG
	BIU+cgPBsPLGCELPZlH1JZzwktvQl9Y=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOiKLCF7;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780443670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QujtcZN6XIzjTF/pw3EqcgAhHTYMwUTz8Hlbxyn4zvw=;
	b=e3bqG1LU+7oXnNBu7Pa1T1IlPzt2Thq1MF3UQ1HV4h14b8UEpjzSl94HOYOEXo0z+tQQwL
	GSAg1zDLarC5iDY53V6TAm3k6zw5qiM1Fjx+jlnRIxMxdYvjIEnQvJDTjUymyxcg03tEaV
	8KbDggloolpjvwFtOXn1VvlxT3nkFBs=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50e61648f10so1391cf.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 16:41:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780443670; cv=none;
        d=google.com; s=arc-20240605;
        b=BBqa96Y0xligKfQttlm4RIkSv6GU57yOVkJbZ2KMU99l/XdiwI2zk/qfcsQjm21EmK
         QeFjh2YMyAoMPt/673zjyT365t05r2A7I2r6/sxXS5aWGInKaKBoGHM6JIguxz8UzC4M
         Jjp8Q9VjZEwLwCVTbf2m/jcjUYsyOfJNmRGrL+vdkWHFAIw2e7+FVxlGg9EbcJBfml3Z
         +9/R2XJH4Ex+jO1BefHTFtE2s+7GRC/TwiNMwbfGkiBzcSSh6PGIkX5W5BnRSQBvNVU3
         rgjUjGI6KhMG9yajeEO0V/rr9KbZcq3rfBO+c11aS1qdCQgIwGGQ6p97Kvmv097pMXxN
         H95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QujtcZN6XIzjTF/pw3EqcgAhHTYMwUTz8Hlbxyn4zvw=;
        fh=/3StEHXAjq2guTVMU3JRALYX1xqRfOPAQ/rQRE53JXM=;
        b=hjz5pEK2MvNCZcq932FjpB0AfXWWWxIySkEkLiiOkZMYtAOgVawl2QxzSnFdVpIRUG
         KyNwMQ/SKvXPGxU/mQ8FJwxoFMI1E6FkgPzHbRaLxYK/d0rfrrYCtzoazIdHEEI7t3ga
         KzLNqCz4w9d1Dl+0rCw4feyosjRzx7+7ySKbi0w8lEzaXsgVbuvVzCGD20CfucldZSIM
         ZKlXSu9sWxy+bKapTjjYhGvnDEioTGTH7tllJHkAsUvliuH/CqGwOrxaUQxzdjcBKzUd
         zQSQOuYrL0OIsr26WPfFeVCmQiyWNBXTbzqJJGTIwLGJZUbX3UD9mmX9HXkP/YoA7iDi
         ijAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780443670; x=1781048470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QujtcZN6XIzjTF/pw3EqcgAhHTYMwUTz8Hlbxyn4zvw=;
        b=KOiKLCF7fBWzFmi6IXG4GX3GwfwDOwg/HsY/PhjIAq7sqnN4R19ww4gwdeWLNjjZUh
         /RXiwPsc988+10izbOuDhsQvqccB2JQF59TMQu+rrXbo+IcnMIbcZ4pPG48t2u8XGHy4
         f3e0cDpZZpFabwTAjM4qMj/qtXmDwmSRI5+EwkzXMt76+slqE4GvVJlmJWV5xiJRTMbO
         6yiJCAut4a5l2r/YWXntyYJ/M+tcRLoBlnVkdWmYBfr1yq61DeSUfMEeBxvog1uQW0sL
         nCX4gnFen0Os1C6sOPTnM9Bs0gUeZ/715hVdok57azM3MipksmXREEpKN3OAZws7vp90
         GDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780443670; x=1781048470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QujtcZN6XIzjTF/pw3EqcgAhHTYMwUTz8Hlbxyn4zvw=;
        b=SYLO7jyd/QL9RlRf+I2Ux8qCZIj2+WhbnMJmkDDGibVreq7VG+d4tS98eUkolXIHbJ
         95p5LxbIkDLLrA1gPz+rzGgCxLvdUPQRjvD8gLb7gpB9mXsNAlrzC5Rpfd4DHccvrPYm
         etoCsnvMuk9CK0nh+YdtLaARF6X+CWp1KKNh1XU2EVIEh0EvGDn6w+ovdZx0KKaWhVyn
         DoXmYwCyBNGB/Rqzu/Ck40In/EbcuYbjmv7VmPeDObM1WWPoNHpYVEP5oSnux/2WJbYC
         OxeTboffg7lN2kInn+qF7epR6Ne/XsPPmtJqdPYwe4BI07L8Qppq9Y6SE+R6kiup/LrA
         RNkw==
X-Forwarded-Encrypted: i=1; AFNElJ8OTEhIB2K6Jlb7vhldzTw7+yA4v30ln7goRDOvqJEuMk6yI8NMpLHeVcqYUR2q1WfclvWcBJkLIw==@kvack.org
X-Gm-Message-State: AOJu0Yz7+IUTm3qrWrPpldhY90hMgzxcLl6WQpfcpH6PlNbXc1+mo769
	5cHlrnSYPx6e3ddEmApvLQ8TNdku8dcGev2HXfg5Os7XTL5k1aJuuO84+MyPOBDtMutRpU7DYmG
	PcoGn4OuJMBfGkrFmr6o9igyRTGYz9nJ0xVpsZ59mEYMIkddjWaeG8Jx1
X-Gm-Gg: Acq92OGo1P+Xsg+zixPVDogPiJb/TObuHmld+16yN5YqI68g01p2+psWUk1++BD5IOg
	bPMEDntIRtWcMhsPMJLOQAyOyf5MKr3kObxSpaGI/0d7O0DDo+nRGcZJoqltPjtABVnYjVhiKhZ
	4dh0kx/w+jkHWTSYhRCVHN/hWzaihUOtx/Q5lvvCnh/mTR56ckX+6Z3EEGLtWdAzex2tphMB0mg
	XotM2mzyTQ7D74ncfT1dVie+R0Y3jdz7HVtdAhiXzR1kSzEJLXlFUMhrF7z/GJ6e4DIVBt9Prph
	OeRTswavjdjjjQt7
X-Received: by 2002:ac8:614b:0:10b0:517:5c70:46bd with SMTP id
 d75a77b69052e-5177bbe4291mr484851cf.11.1780443669151; Tue, 02 Jun 2026
 16:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260506022256.32664-1-hao.ge@linux.dev> <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
 <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org> <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
In-Reply-To: <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 2 Jun 2026 16:40:57 -0700
X-Gm-Features: AVHnY4KwuF0fKuj6PNzWIM231tWFnMinIrtMREFqJzCAkWp9C5d0oVRyp8q3I8E
Message-ID: <CAJuCfpHi3tvMtYoww548scLJtJQ4EHJKOPDF6-5NJLNUZbV13A@mail.gmail.com>
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B26CC20004
X-Rspam-User: 
X-Stat-Signature: w4hexda53w7ectfrjy5pdmeod6n91fny
X-HE-Tag: 1780443670-734560
X-HE-Meta: U2FsdGVkX1++PPfARXBCBzcskcN5HcriuDGM6IQsYhQ6+VNekef9yHGxZvIO+1LNQH2zGeKKN5uKt8twxMEkRv86uFl9ZzlEAp72C6/WL6YTwMC6P8ljxg6ZXs2bYWT0XgCN04oqeFcc/VSZwF6g/P8OJSwZknTtdxXOPRGZ4ye0zfVLqv1sD7/dyEmQd24coxGEg5OM/tXPxDISP4aogZ0JykAqFLI42YuGHq+bIYACjvXMOwlVAoBFhOcs4MkTtZMw48vL5yjMWqX3kph+dazm9M5sI7qYd+Tx15JPkHTKdYgvVvxxFtLSvCxv9VAp2UQgUVyjKOXMrAgaWBCZIRp4/tj8Fo+uiz8rA2LF5tbKmpyNUcBdWPguZqkETY9jgkGEK+71znV172N6I7aqCbeCBUsjXIAJRWcrM+7II/DA3noa0P26Yxmv056BdLyMXxxTq1nlHwLWjb8rsWwdS9CC2EDV+X2jcyCZVepwqzhYEO7d51t1FTN6aOsMmWF79byPgl14HDotS5Myqoxz7NZjh17R+hjL/kQ+DC04QLMKQuwWm/MJ5qi36LWzU+JOLOS9lmV+KRROxzWM9xW6+vA5Rv6jYYNK+e9++5t44ZkvP8RlHqKoigzQlseveoykCk90iAsbJ5sijEYyUGBnTosg7CvRMZsXsrESCcOn6rtMcDmQGWlPC52cvvbA+8BibOLRumebj7DrVVVj8WglySNY3RH31uQini7jFdvZzTX2TaOZVC8zr/oadEKOCUq6lc9r/8UKoaToyhjtJSxDdKrRkrjQbqppgwpsiK+bCHUEVnKjQe8MPcnntrleUT55Q7ha/xcNFv1DiutdKq/SuseC8ciZKr/wIZjua6fXn+dux4149GjULH49dJMHwk8aNpxcxT6Z08tlH4P6hTzy9qMR14yYtN+DEz7SXDdnFUMfsumPXVLdgA8r3fGCeshUtfGljnXgWqybMBQwA8n
 giKwOPXu
 uGys8zwRHKfn0JVPti9HY2GkrlOM0ssagi7yv8XmibB19MT6u9ZsaI77ilXEvWtYO5XbZ4dTyzg83VxTI72/ip/BvSP3ZqsHcDJLyLNSmdOjMosjIpKAYxrziZSqyFzYDqq/U3Nldg6kJFMwCewaT83mx6lopUA8NUv+CD6zeMxZ0De166BdvjYhY1tbQt2+bDUia64SsO2S64+JCCzn9tl/+XwjqRdq8jNpuqq69/CUgri4jLWQvuRGCJYuyYdUFEJULCusfQgZliNYaTbkO4IK/Z9dZGOjUXmzb5cwnoJAPmg7i4fCohKAUaAQokYAdTuAtdRi9I4PDeXHZB5h40CBuR3BRvtuIuTE2Z5JjOKEfPRcfTYuAf2rWeeRJO0SKJ/Gb+ZlJbvSxdYkmoWhSbc5DsDOae7QMANWVMuCQ3yK00KGtVTGiRDwBhGkZdAC77xFDef5tqFk13AKOLNFDqbmI5vZaKC0wOUBK6CnR661Gw+9rjHgk61uKEP8NP6+f/NtQoTGQeyhL4Ie8aDCYo6bC1xwz/tYnH4yK4r6yVlOfxw603qjMKdKtnmMoVpqfnAksDYW5JmwUXjlj4IEPqilDPA==
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

Sorry folks, I was on vacation and will be fully back to work
tomorrow. I'll start on these reviews the first thing once I'm at my
station.


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

