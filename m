Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC705CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173908E00C9; Tue, 14 Oct 2025 17:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBAD8E0090; Tue, 14 Oct 2025 17:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF478E00C9; Tue, 14 Oct 2025 17:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D69B08E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:33:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8540C88917
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:33:20 +0000 (UTC)
X-FDA: 83998020960.30.FB1D109
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id A454E80002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:33:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dkgdBYlf;
	spf=pass (imf30.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760477598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRskKZpnIRIllGR+ESE73jq8/mOCylC4thtJYDQxpyE=;
	b=HJ1EVV7gJXFJvYzOJbOEXSkonhoRE88auR86Z7E32xjjw6urVOToWv0WW+F2w4TSeG5Zbx
	m+B64mcsnfmh/KSzh8olmjGryeWJp1iCyIDkhZEYCWoBkiUrakK9LedRzFmpX1BchvX0xs
	kDXGSFGUbfMVlBRRTgtnssr4mvt2VLo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dkgdBYlf;
	spf=pass (imf30.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760477598; a=rsa-sha256;
	cv=none;
	b=D1iLtzQYMKfknwHN1C+1x026SeNemScotGhLUBI5oWa3Ma5bIBEqXQdwZmr7ruVWVFNNnQ
	zELRcaItm6eYn/OSomkKom0U+4miSOyghOqwJ3v97IEq0wJwm+Wdblahif480WjEnP7duT
	zjyE0Fa9Ntr+QOEN+PWRpR16SCJqAvU=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27eeafd4882so74315ad.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760477597; x=1761082397; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DRskKZpnIRIllGR+ESE73jq8/mOCylC4thtJYDQxpyE=;
        b=dkgdBYlfSoiMBN8wZuYizRYPtSkijBEd306zZJ3gAx+wHNER7bXGhtUMND8ed56ary
         bP8giNyBFF7EDSu1oAbslsQ+3Q88OV+01+DHZicoktOrM8vj8VwiF0Li5GexCyQ11glq
         EZpMDuy2ldWItzmGntulRpxC6EDLQzLto6++N7cIuTWBwx/y80zRt9ze8DZDjgpTy+JD
         MBBIzBRqhKWwL6iveE8lnVneToaDRk4aecn11zjMcmmnlBRJ6l2CbyqnBdSLKv9Wevos
         d+X42SDM/S+/Jtdzs7i5BErVVf4DNn2CIBCAOrdo9vcbBS1ZZag/u2qFdzowpLmBWy8M
         iTkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760477597; x=1761082397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DRskKZpnIRIllGR+ESE73jq8/mOCylC4thtJYDQxpyE=;
        b=HM5229VtkEomZvpTNlm1gs6EuIpHUEWyzqgDtMF9bZ++vL12wkGLBo1ENPj4Clqshx
         xqPjGeIkVl2d+ySFbvTSrM5Ev9gkyIr31ys2KLOz9Os6GyTfvU0NZQ7DUJAlG7hMUuHs
         5A5atBp1he8w+YzGMzz9PDUsjgQt4N++90rf2iunCokCT/7yrvcv0vFM93xC3F/O8WAR
         ZqytEmUpYDuWVZRlEMUQkUFlAGyr2/brcNDRxMga2qKU2SlZehtPPF88kBsGcO+OfQH8
         +Va2Ps0Y+59HsR5PTIq8+vC+/d29SltRAr9oTvL6P+n735og7OxZ2mVZ6omkniWGtGaB
         Klzg==
X-Forwarded-Encrypted: i=1; AJvYcCWk1le92QccvPbYRGKXtP8zFwRP2MAupV1VVLl1cQfJCs4iLRjcUQg+vKfLr4QBhJi/WNnvwDbDcg==@kvack.org
X-Gm-Message-State: AOJu0YxIY4by47BdzLdrV+4mwrTmploWmYlviRkhedzdrNb1W/RSSuWT
	HMZyrTk0wuNQMBJaSubqlJFBtG3+xAgTgjox+P66mdLeyv7ppy9A1CfGEUYX70fqb0D/oH/seCd
	wjwXeSp8XoN521M8TeffC9LgYCE+OReKhSNvL/pQA
X-Gm-Gg: ASbGncv9p5JLUw4KxqNrjkqZ4Cvmwx74pxKw3uh/qkRHgkahYb1FdVRGPtoyap7ZDuX
	9WIZZrzlfEFQP+x8AvsTYZM2wg9P+3rjWw3H9nG0CfEwvJup5No9SV8dkmnRRoUVuDVrHQirOFP
	UUoJJWbAq2gOTUA3ErdPWsxIh9JVW7jsOrV9B5qN4GIlvInynoM+974S9fO54LqrntyrIfllRhY
	8SzpAOrVVAsA3MJJYlicX/96e+8uOGtwj5IC8ZqJEeeKhNbI/xB3K0yM86aig==
X-Google-Smtp-Source: AGHT+IEHrs850EG3XMez/7ngys4coZSDbG9AXxNVFTWtUr9iNSb9QVL8mjJjo5KQMcuY6Vt1JkM1o+A/H66y4AjU968=
X-Received: by 2002:a17:903:3d06:b0:274:1a09:9553 with SMTP id
 d9443c01a7336-29087a16a7fmr1160785ad.6.1760477597088; Tue, 14 Oct 2025
 14:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com> <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
In-Reply-To: <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 14 Oct 2025 14:33:05 -0700
X-Gm-Features: AS18NWDEXIzf0W_8NyXmtodW3cUhtebQNJZvZW7z0zEtzur244eg_ScikaZgMeo
Message-ID: <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
	SeongJae Park <sj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A454E80002
X-Stat-Signature: otaxgynyjgxeu9uapnsmyc597gmgdehq
X-Rspam-User: 
X-HE-Tag: 1760477598-845744
X-HE-Meta: U2FsdGVkX18QK08HyHwZ+JRc5FQ1c5TbpO1bXQvQWomjDMlHlWMxv6Vg64hZIC0BSVV9X+GLcgOdhBZ6WM6aQUrtmKvbBqzWWCzvkoG+QWYqLmmXAG6wskcIrhjeb/ES0jEE+/7YbyiPv39lbkoKRBJZrDTJnWbeNv5HjBpxQf5fOsnmCp8fHFUJ3BoLhE9MvwAj0jDDC5xQ6uiGmF9VKLV2SPNn6WtK/G13ZNA2DZiGsFddkG22th0eMSDUw0PYie72+6HEFh+g7AasUon5HHG1+u+nKXpGMYSyhBYxH2hWzQjzLpj54jFHP5ktQNZvVgGU7uNfSGXAT1ayX68G59dE1ggMZbAWtFufd09peAnJsJX04NPo2vQOdRvHsws9U94peq6lGbb39WpGm0l4A6jESYMu4qn3aYaAFyOk3kz1zfisaN238UajJlUzkw8HgJdtH06M1WCiIWLxaqAXwDsBmiDLh4P++G2g/5TJ6ca+FloKSTmvUM7YdDn5NHhExqsKS1CotB24c18TrZrKGG7LNgJb1uaJmrkhvl8lGVj9c3uO51/KhxxdEz2yZPuxcYWtAzFRZWj4ZINiT25WblBTU2mcfOufX6ULrw0/ZLNeKFf3P1OvQGsbWbDpx18FbsfKHWDOkmGUDvnBJhEpEcpxFWZoFl6FwCAQSZztMt3ZAsWbT76+ncybKTVVRa5TSofK/HLwaHGY79bmHkMLnku2xhkFZ6QRqm86SfPOahNeW4sUs2iTcl3FjuYRK9/guIKS62lnoDXlG7hNKSj0qVj5rhUzs1sR6ma7wRN/Y+aIEhcuIjp+v2Az5c76DIIF31BVSg0uqei7SsncOf58l4ku2e+trp3VDdwfqRzJk1a/pDi8gV8Q/JpHKLVgUJAy1mY+baN3+gARZ8vN9swmLePEQKd8237J4X82o2JTh20+0/2ytdRzeM4wtzN7iAKwYdruaLup0r+VhpI92mx
 RrLfQMrg
 fE1842xaJ1lFID39OBch1cv+Y98ZxuKOy7NJlnoXjFhG5fb+YQ2d0O/IZ5tlOZsUKABmnjzEXgFOiPpJwJGT46cpBvGagTJp2eVsaZksxhpfUDAzg4jgF7iWzEeyAYqLDXJ7SssHv9vTg4DEovKHBF5WNglOWEY1EqgeY9vV2hZP4fdvYohvCH26/XJfa60BwsbZt9YnP9oIbr5aEQDUQIIG1ezFe0aPT5BWsbVtLHwuAM5IBCG/XBBOFfZdCKjCKdZgVi5FX43UDAsjER6q1LAL4Ux+kjrqv5BYKSvHEnpGuPpJq403mko6E/tW0VLAp79lFA0bWXM3X9enHjBxrHqLAQ94R/aFyIhdQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 11:28=E2=80=AFPM Hugh Dickins <hughd@google.com> wr=
ote:
>
> On Mon, 13 Oct 2025, Kalesh Singh wrote:
>
> > The VMA count limit check in do_mmap() and do_brk_flags() uses a
> > strict inequality (>), which allows a process's VMA count to exceed
> > the configured sysctl_max_map_count limit by one.
> >
> > A process with mm->map_count =3D=3D sysctl_max_map_count will incorrect=
ly
> > pass this check and then exceed the limit upon allocation of a new VMA
> > when its map_count is incremented.
> >
> > Other VMA allocation paths, such as split_vma(), already use the
> > correct, inclusive (>=3D) comparison.
> >
> > Fix this bug by changing the comparison to be inclusive in do_mmap()
> > and do_brk_flags(), bringing them in line with the correct behavior
> > of other allocation paths.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: <stable@vger.kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Acked-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v3:
> >  - Collect Reviewed-by and Acked-by tags.
> >
> > Changes in v2:
> >  - Fix mmap check, per Pedro
> >
> >  mm/mmap.c | 2 +-
> >  mm/vma.c  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 644f02071a41..da2cbdc0f87b 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned l=
ong addr,
> >               return -EOVERFLOW;
> >
> >       /* Too many mappings? */
> > -     if (mm->map_count > sysctl_max_map_count)
> > +     if (mm->map_count >=3D sysctl_max_map_count)
> >               return -ENOMEM;
> >
> >       /*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index a2e1ae954662..fba68f13e628 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
> >               return -ENOMEM;
> >
> > -     if (mm->map_count > sysctl_max_map_count)
> > +     if (mm->map_count >=3D sysctl_max_map_count)
> >               return -ENOMEM;
> >
> >       if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> > --
> > 2.51.0.760.g7b8bcc2412-goog
>
> Sorry for letting you go so far before speaking up (I had to test what
> I believed to be true, and had hoped that meanwhile one of your many
> illustrious reviewers would say so first, but no): it's a NAK from me.
>
> These are not off-by-ones: at the point of these checks, it is not
> known whether an additional map/vma will have to be added, or the
> addition will be merged into an existing map/vma.  So the checks
> err on the lenient side, letting you get perhaps one more than the
> sysctl said, but not allowing any more than that.
>
> Which is all that matters, isn't it? Limiting unrestrained growth.
>
> In this patch you're proposing to change it from erring on the
> lenient side to erring on the strict side - prohibiting merges
> at the limit which have been allowed for many years.
>
> Whatever one thinks about the merits of erring on the lenient versus
> erring on the strict side, I see no reason to make this change now,
> and most certainly not with a Fixes Cc: stable. There is no danger
> in the current behaviour; there is danger in prohibiting what was
> allowed before.
>
> As to the remainder of your series: I have to commend you for doing
> a thorough and well-presented job, but I cannot myself see the point in
> changing 21 files for what almost amounts to a max_map_count subsystem.
> I call it misdirected effort, not at all to my taste, which prefers the
> straightforward checks already there; but accept that my taste may be
> out of fashion, so won't stand in the way if others think it worthwhile.

Hi Hugh,

Thanks for the detailed review and for taking the time to test the behavior=
.

You've raised a valid point. I wasn't aware of the history behind the
lenient check for merges. The lack of a comment, like the one that
exists for exceeding the limit in munmap(), led me to misinterpret
this as an off-by-one bug. The convention makes sense if we consider
potential merges.

If it was in-fact the intended behavior, then I agree we should keep
it lenient. It would mean though, that munmap() being able to free a
VMA if a split is required (by permitting exceeding the limit by 1)
would not work in the case where we have already exceeded the limit. I
find this to be inconsistent but this is also the current behavior ...

I will drop this patch and the patch that introduces the
vma_count_remaining() helper, as I see your point about it potentially
being unnecessary overhead.

Regarding your feedback on the rest of the series, I believe the 3
remaining patches are still valuable on their own.

 - The selftest adds a comprehensive tests for VMA operations at the
sysctl_max_map_count limit. This will self-document the exact behavior
expected, including the leniency for potential merges that you
highlighted, preventing the kind of misunderstanding that led to my
initial patch.

 - The rename of mm_struct->map_count to vma_count, is a
straightforward cleanup for code clarity that makes the purpose of the
field more explicit.

 - The tracepoint adds needed observability for telemetry, allowing us
to see when processes are failing in the field due to VMA count limit.

The  selftest, is what  makes up a large portion of the diff you
sited, and with vma_count_remaining() gone the series will not touch
nearly as many files.

Would this be an acceptable path forward?

Thanks,
Kalesh

>
> Hugh

