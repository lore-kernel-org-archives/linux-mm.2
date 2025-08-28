Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06208CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3524D6B0025; Wed, 27 Aug 2025 22:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329EA6B0026; Wed, 27 Aug 2025 22:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FD46B0028; Wed, 27 Aug 2025 22:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 109686B0025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:59:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8829578AB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:59:37 +0000 (UTC)
X-FDA: 83824660794.02.1637ACF
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id C053A180007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:59:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QnOR0hQJ;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t35FyPKwwdQ8g4j+/LU2AEGoNi4QA0Yjv85YIy0KfQQ=;
	b=6B+zRPH9NVzPqUUJ22AC0lriukm/3uGRd+vUxqzofMb703zrnCqK5Oiu/t8M1l+WL+S6K7
	1KWR6FjrvyFdRl39ove2yJF15JgdiXoHokeItM8KZv8PBebkZB05wrZhLKH0QqN2hTYCAm
	0kEULzEApRLFMUQcEJl7gwgdlAwukVQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QnOR0hQJ;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349975; a=rsa-sha256;
	cv=none;
	b=6WGB1301cxCF4FXKYOeSvtSa1J+ZVr8zR68YCn1JHqUdIEXI9z2UU+AiEKOS8KGcbamW2X
	MfSyw2rx70zHLobgYQ1BZZD+zntLVpXh/klp1Wl0ST9byy+9R0elMPfP8I1K1Tyf3he7cB
	pGBpcc6TS8r95SdPfo5qRNAhDnlpSIY=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70bb007a821so7507596d6.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756349975; x=1756954775; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t35FyPKwwdQ8g4j+/LU2AEGoNi4QA0Yjv85YIy0KfQQ=;
        b=QnOR0hQJ2wnBWz+6fcMNY2svfLN8SSZ9NK15Tlb/rdR+tLrhmaqLSRT/CpqguZKivr
         xt3Lg2WNBeNxMGmBi/z9ntfF56MBNdF7YP8qerVwOTnEz2TNlr1v5Ut6YSbtwht/vvV5
         0NwTEGlifYVtMzqRZinY3TJFc5y4dul0zli5K5nKGSXIUDSlwe0MMFDRkiWzOhoxBMiv
         BL1IDY29GC1BDYhwmG0o/OnRF5vnJFMsLSsO3aBbs7097hI2Y7NBzXc+3dlBxPpF9x/E
         xXcu4PXHok65ODVhV79Ju9vWd0EF3LcYNkyac2LSd/FUzW4ZiLcIKKb6tE0nP2M/exDy
         KDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756349975; x=1756954775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t35FyPKwwdQ8g4j+/LU2AEGoNi4QA0Yjv85YIy0KfQQ=;
        b=NP7ne2TNK5x1WdMWnjfBs9FMSGT8qu0N9Kifqb+2TiyxYoUjBD2WJbcAaIjEz+P30q
         yBMOtlysEeeV5HdLQOheSfJn0yOgwMrPULGSZuHYNf7A4p757Wx/16C+wqKPLL/VtyJb
         8DPAnFK5WBds3utCFsCvZB3CDa6iJhBphqI2z2ncn5s9h1tsEI5IS5/gX2ZcPKR/nuPa
         0tnQ7zBOg78ID2kKwGlvekkGAZ8F0w+BUY7WGQR/1RcqhVW4CHCgKSdHUqjtNgKgHFqp
         wg2SFKh2CXqd9rmJnXdAH17atyP9c87tSX078ECgyYHyqZLvxVUBmDcB8zbu/UkAN9Or
         2Rqw==
X-Forwarded-Encrypted: i=1; AJvYcCU7r0Y0jaKt1yE/RwUWQLvsD+g36Xb6sGwr28f2wnxr+0UIi7cUjkTjOFUXNLKgZAlfcIamFgDlBA==@kvack.org
X-Gm-Message-State: AOJu0YzbxAL8dAgxRuVs8dWHdLAXONUO3UxbcmU46X9CfXHeuG7+vfNz
	HeOW2kLgZmF61bOUa556WKYTOIWLFOnNrFK55sSULbxg3W4UTmPXsVythvUPkWIF++5esUmaXVY
	qwUuTnyUS6h4KrKl4em1H6XZCqXKKC30=
X-Gm-Gg: ASbGncuT6sdE9ETOlbXu6VXTl13nS9CyYyLjUYKdfJkrh43+R3hyrRwBcH/+tGWYt+w
	sufVO8X18Ti9rMDdPe+t+FlxVm9FCRQl3PF9nv0U/nhu+0izHpOXfpkjdRs2UAYh7afNgQQWy0h
	o8VVE1itO/dhp5TLUnQnfVXj7MdYRpvmDhbzaF815SKyygu7CJV1jOuqmu+IrylLnNyZ3heCGgx
	jKTos1sPaehLmhX1x7Nv97pawh7kg/dWIRE+K+36hhMc0e/REA=
X-Google-Smtp-Source: AGHT+IEy259srY+vu9FkWq6fUb184mC2kXtFB+ag+8ue7OGFzMwwHBeCZoroAVcUSsARAL1Fs9+m1BXRcIe+kdv66g0=
X-Received: by 2002:ad4:4ee9:0:b0:70d:bf1a:4703 with SMTP id
 6a1803df08f44-70dbf1a4950mr143947036d6.65.1756349974647; Wed, 27 Aug 2025
 19:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <06d7bde9-e3f8-45fd-9674-2451b980ef13@lucifer.local>
In-Reply-To: <06d7bde9-e3f8-45fd-9674-2451b980ef13@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 10:58:57 +0800
X-Gm-Features: Ac12FXytGU973HTwPFg_ZVzsdimnNmtB76eHLAUwx50b3G9QPYiVt4FHmqmoTK0
Message-ID: <CALOAHbA7wT_LF0Sr2jGWxKU52d-tmHt1sBBjM1koja64t1vi2Q@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C053A180007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u5ggx31uarta5odwk9tor4y4kcdkc8uf
X-HE-Tag: 1756349975-672740
X-HE-Meta: U2FsdGVkX1/kIsIc4UC8fdPrjYSoecE0aVrS+hxjIfXPdEH1sJjYQEVFLmGxNDCDInuCu9lK0GgNM82a6i6/z3hJ0fVLDbC3vbYRLGDsAJTyq5Ch38na6xI85JNXKACjtuiZ4PjS3zxLv6pKlLLmUYew+I4taF1lwk5wDcrYEsOE+vFr1V3Bb6W3yL/Ya/bIGMBw1oGIwJr1wQwsDBiNShMpFq3gD2UstiE14skGVIY/CkrqiUqsibj1TUZqnVLF+oWxIkjOJZkhSSYIR/a2Ox7ubEIXEsYrp7iX/Y7vKlWq1adoTlCXTyuEAk65g8v26YmbMBsg2BFwqw6Gl3dTiJPPY/9AovxTZmFGkdVthFMOHhESe40nZsYpKSNim1dTIGAImmOInryye5OxCAUQlMh3Ft3tkWwqeNw0L57kv9UZOjffccYt/0IZqDMZTZSLGTSWvBqfCJSIKOYLgySAfjTvrGfvlv6Utzlh8vrvytQUFFqJvozdpbX9lA+mI+2mRGbNNZQx/MiiS0EoBwK67Cn+pTSkDt0OyYUTBiHZI9o4XELPhacSCSHqW9m5cgZ8ceMRaYcmBSDBxkHWCxHy+0HrviHJJplgCXfNlfEj+IWLNuoOzTcsAAktsqERtmJRF4K2hP+fl2QI9GsmYCSlp+7thD7AbuxP5T7haBJK/pZc7v3s85djPa2O1IJ+fohYL3B56mYLd0EOshzStIEoQdKpq0kqfJ0TlVe7gw8GQjctVojE8Mmo88wVXzqM6+F838qbgIlhiGYW/ILPmpwaW69GwH7pUsAVUIYZa3+dA8wVgxRMwifGt9Qod0yyCoGdpuiMJCMlSutmCghGgGesSnHIxC5fwxTaSJoCD7J+oM9B636rLfOgYGKY6XWz/mj2bzUuvbr9X7SWZuB6lyqIN7XGY1i6gjAJzD3V5GXvd0ZrsCKgXNn66pctkRdNxIdBz9J8oOa0LiSerJGEioW
 J4GUciqm
 ShOA2Qy77wSTuLxr80Pwamb2YHZ4WYoHO6ARLxR1wBtBRrAA/nmQGXKeYhIDUYptJW0wzbTG6bF7qyPUlANGC+7uGwVr6NX0mBJmEHFJwKul79Sc4UvWpnX+Y+lbbKIp/W82AY91KynAviGcGdk/mNjR1bRPnFO1wBaT232dgrfFLTPDUC31EI9U3VCBmZ+G3/U9UcXtFFCbivXsOfce07uYhHng2HwjJ0rpr7CQphnMvntkmG9jzrE9MYjC2po1XUyBWyt7ra/0IQ7vLjA5Ui+7P8gQYigyD3RzAhj6sDwrVgQahOvhso0YdQ4wgKAb3DLnrvnnbK5Qb3iQwKfa5opLDBUGHlkTZf8+fKRUKeYQSw8Fb7Xs1lm/BHcyaRx/ACAonUZHi17RU2g3XL0M7akkZXWJk9TWQZsCczASxLPpqP6ewpUIV11IIPsKXMRmF5hyQ0VSFlPqQMs1PB7g2RNIkj9tZ+eR+eO7CudqwOHUBrqvD2Kd2pVrVcdA0yz4TN/Pa94CgIrJXOmmOO7yVETW8ZUaO0ItxclTCE+gLv682xFlo1hRjK3CTmfNP2NWgz8vK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 9:14=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:38PM +0800, Yafang Shao wrote:
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Our production servers consistently configure THP to "never" due to
> > historical incidents caused by its behavior. Key issues include:
> > - Increased Memory Consumption
> >   THP significantly raises overall memory usage, reducing available mem=
ory
> >   for workloads.
> >
> > - Latency Spikes
> >   Random latency spikes occur due to frequent memory compaction trigger=
ed
> >   by THP.
> >
> > - Lack of Fine-Grained Control
> >   THP tuning is globally configured, making it unsuitable for container=
ized
> >   environments. When multiple workloads share a host, enabling THP with=
out
> >   per-workload control leads to unpredictable behavior.
> >
> > Due to these issues, administrators avoid switching to madvise or alway=
s
> > modes=E2=80=94unless per-workload THP control is implemented.
> >
> > To address this, we propose BPF-based THP policy for flexible adjustmen=
t.
> > Additionally, as David mentioned [0], this mechanism can also serve as =
a
> > policy prototyping tool (test policies via BPF before upstreaming them)=
.
>

Thank you for providing so many comments.  I'll take some time to go
through it carefully and will reply afterward.

> I think it's important to highlight here that we are exploring an _experi=
mental_
> implementation.

I will add it.

>
> >
> > Proposed Solution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > As suggested by David [0], we introduce a new BPF interface:
>
> I do agree, to be clear, with this broad approach - that is, to provide t=
he
> minimum information that a reasonable decision can be made upon and to ke=
ep
> things as simple as we can.
>
> As per the THP cabal (I think? :) the general consensus was in line with
> this.

My testing in both test and production indicates the following
parameters are essential:
- mm_struct (associated with the THP allocation)
- vma_flags (VM_HUGEPAGE, VM_NOHUGEPAGE, or N/A)
- tva_type
- The requested THP orders bitmask

I will retain these four and remove @vma__nullable.

>
>
> >
> > /**
> >  * @get_suggested_order: Get the suggested THP orders for allocation
> >  * @mm: mm_struct associated with the THP allocation
> >  * @vma__nullable: vm_area_struct associated with the THP allocation (m=
ay be NULL)
> >  *                 When NULL, the decision should be based on @mm (i.e.=
, when
> >  *                 triggered from an mm-scope hook rather than a VMA-sp=
ecific
> >  *                 context).
>
> I'm a little wary of handing a VMA to BPF, under what locking would it be
> provided?

We cannot arbitrarily use members of the struct vm_area_struct because
they are untrusted pointers. The only trusted pointer is vma->vm_mm,
which can be accessed without holding any additional locks. For the
VMA itself, the caller at the callsite has already taken the necessary
locks, so we do not need to acquire them again.

My testing shows the @vma parameter is not needed. I will remove it in
the next update.

>
> >  *                 Must belong to @mm (guaranteed by the caller).
> >  * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma =
is NULL)
>
> Hmm this one is also a bit odd - why would these flags differ? Note that =
I will
> be changing the VMA flags to a bitmap relatively soon which may be larger=
 than
> the system word size.
>
> So 'handing around all the flags' is something we probably want to avoid.

Good suggestion. Since we specifically need to identify VM_HUGEPAGE or
VM_NOHUGEPAGE, I will add a new enum for clarity, bpf_thp_vma_type:

+enum bpf_thp_vma_type {
+       BPF_VM_NONE =3D 0,
+       BPF_VM_HUGEPAGE,        /* VM_HUGEPAGE */
+       BPF_VM_NOHUGEPAGE,      /* VM_NOHUGEPAGE */
+};

The enum can be extended in the future to support file-backed THP by
adding new types.

>
> For the f_op->mmap_prepare stuff I provided an abstraction
>
> >  * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
> >  * @orders: Bitmask of requested THP orders for this allocation
> >  *          - PMD-mapped allocation if PMD_ORDER is set
> >  *          - mTHP allocation otherwise
> >  *
> >  * Rerurn: Bitmask of suggested THP orders for allocation. The highest
>
> Obv. a cover letter thing but typo her :P rerurn -> return.

will change it.

>
> >  *         suggested order will not exceed the highest requested order
> >  *         in @orders.
>
> In what sense are they 'suggested'? Is this a product of sysfs settings o=
r? I
> think this needs to be clearer.

The order is suggested by a BPF program. I will clarify it in the next vers=
ion.

>
> >  */
> >  int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct=
 *vma__nullable,
> >                             u64 vma_flags, enum tva_type tva_flags, int=
 orders) __rcu;
>
> Also here in what sense is this suggested? :)

Agreed. I'll rename it to bpf_hook_thp_get_order() as suggested for clarity=
.

>
> >
> > This interface:
> > - Supports both use cases (per-workload tuning + policy prototyping).
> > - Can be extended with BPF helpers (e.g., for memory pressure awareness=
).
>
> Hm how would extensions like this work?

To optimize THP allocation, we should consult the PSI  data
beforehand. If memory pressure is already high=E2=80=94indicating difficult=
y
in allocating high-order pages=E2=80=94the system should default to allocat=
ing
4K pages instead. This could be implemented by checking the PSI data
of the relevant cgroup:

  struct cgroup *cgrp =3D task_dfl_cgroup(mm->owner);
  struct psi_group *psi =3D cgroup_psi(cgrp);  // or psi_system
  u64 psi_data =3D psi->total[PSI_AVGS][PSI_MEM];

The allocation strategy would then branch based on the value of
psi_data. This may require new BPF helpers to access PSI data
efficiently.

>
> >
> > This is an experimental feature. To use it, you must enable
> > CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION.
>
> Yes! Thanks. I am glad we are putting this behind a config flag.
>
> >
> > Warning:
> > - The interface may change
> > - Behavior may differ in future kernel versions
> > - We might remove it in the future
> >
> >
> > Selftests
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > BPF selftests
> > -------------
> >
> > Patch #5: Implements a basic BPF THP policy that restricts THP allocati=
on
> >           via khugepaged to tasks within a specified memory cgroup.
> > Patch #6: Contains test cases validating the khugepaged fork behavior.
> > Patch #7: Provides tests for dynamic BPF program updates and replacemen=
t.
> > Patch #8: Includes negative tests for invalid BPF helper usage, verifyi=
ng
> >           proper verification by the BPF verifier.
> >
> > Currently, several dependency patches reside in mm-new but haven't been
> > merged into bpf-next:
> >   mm: add bitmap mm->flags field
> >   mm/huge_memory: convert "tva_flags" to "enum tva_type"
> >   mm: convert core mm to mm_flags_*() accessors
> >
> > To enable BPF CI testing, these dependencies were manually applied to
> > bpf-next [1]. All selftests in this series pass successfully. The obser=
ved
> > CI failures are unrelated to these changes.
>
> Cool, glad at least my mm changes were ok :)
>
> >
> > Performance Evaluation
> > ----------------------
> >
> > As suggested by Usama [2], performance impact was measured given the pa=
ge
> > fault handler modifications. The standard `perf bench mem memset` bench=
mark
> > was employed to assess page fault performance.
> >
> > Testing was conducted on an AMD EPYC 7W83 64-Core Processor (single NUM=
A
> > node). Due to variance between individual test runs, a script executed
> > 10000 iterations to calculate meaningful averages and standard deviatio=
ns.
> >
> > The results across three configurations show negligible performance imp=
act:
> > - Baseline (without this patch series)
> > - With patch series but no BPF program attached
> > - With patch series and BPF program attached
> >
> > The result are as follows,
> >
> >   Number of runs: 10,000
> >   Average throughput: 40-41 GB/sec
> >   Standard deviation: 7-8 GB/sec
>
> You're not giving data comparing the 3? Could you do so? Thanks.

I tested all three cases. The results from the three test cases were
similar, so I aggregated the data.

>
> >
> > Production verification
> > -----------------------
> >
> > We have successfully deployed a variant of this approach across numerou=
s
> > Kubernetes production servers. The implementation enables THP for speci=
fic
> > workloads (such as applications utilizing ZGC [3]) while disabling it f=
or
> > others. This selective deployment has operated flawlessly, with no
> > regression reports to date.
> >
> > For ZGC-based applications, our verification demonstrates that shmem TH=
P
> > delivers significant improvements:
> > - Reduced CPU utilization
> > - Lower average latencies
>
> Obviously it's _really key_ to point out that this feature is intendend t=
o
> be _absolutely_ ephemeral - we may or may not implement something like th=
is
> - it's really about both exploring how such an interface might look and
> also helping to determine how an 'automagic' future might look.

Our users can benefit from this feature, which is why we have already
deployed it on our production servers. We are now extending it to more
workloads, such as RDMA applications, where THP provides significant
performance gains. Given the complexity of our production environment,
we have found that manual control is a necessary practice. I am
presenting this case solely to demonstrate the feature's stability and
that it does not introduce regressions. However, I understand this use
case is not recommended by the maintainers and will clarify this in
the next version.

>
> >
> > Future work
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Based on our validation with production workloads, we observed mixed
> > results with XFS large folios (also known as File THP):
> >
> > - Performance Benefits
> >   Some workloads demonstrated significant improvements with XFS large
> >   folios enabled
> > - Performance Regression
> >   Some workloads experienced degradation when using XFS large folios
> >
> > These results demonstrate that File THP, similar to anonymous THP, requ=
ires
> > a more granular approach instead of a uniform implementation.
> >
> > We will extend the BPF-based order selection mechanism to support File =
THP
> > allocation policies.
> >
> > Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redha=
t.com/ [0]
> > Link: https://github.com/kernel-patches/bpf/pull/9561 [1]
> > Link: https://lwn.net/ml/all/a24d632d-4b11-4c88-9ed0-26fa12a0fce4@gmail=
.com/ [2]
> > Link: https://wiki.openjdk.org/display/zgc/Main#Main-EnablingTransparen=
tHugePagesOnLinux [3]
> >
> > Changes:
> > =3D=3D=3D=3D=3D=3D=3D
> >
> > RFC v5-> v6:
> > - Code improvement around the RCU usage (Usama)
> > - Add selftests for khugepaged fork (Usama)
> > - Add performance data for page fault (Usama)
> > - Remove the RFC tag
> >
>
> Sorry I haven't been involved in the RFC reviews, always intended to but
> workload etc.
>
> Will be looking through this series as very interested in exploring this
> approach.

Thanks a lot for your reviews.

--=20
Regards
Yafang

