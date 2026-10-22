Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EFE60A6F4B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DORc+YRC
Received: by kanga.kvack.org (Postfix)
	id D32B56B0967; Thu, 22 Oct 2026 11:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3A56B0968; Thu, 22 Oct 2026 11:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC506B0969; Thu, 22 Oct 2026 11:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 919F96B0967
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:10:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16FB6C0176
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:10:57 +0000 (UTC)
X-FDA: 85350599754.15.AFFE58E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF597C0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:10:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DORc+YRC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792681855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2B5vza+jbwkGAZonP3DChsQgZkW/jPoj7zNLZG98cpg=;
	b=4T6YfsC+67KFVsu4/DwzoNI8AeMKkIUiE2cBgeZDOZcZZnMvF5+GltpvrZUMpAx2/b7JPU
	YefBDG4e24cwWjkxv7WhX8MO0rW4KX+3JbfGSmkgSRuuuAwvw8Rf4nnY6hAxW8hq2wvM8t
	iMerQy1EOwi01Zo1jBFk8gjAEDO4x2w=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DORc+YRC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792681855;
	b=6DSTXnxov7VStD8rOk/7czOQFFtQoD3ufzKLfTxzmypsJDrvD1Z8q/43oxAriRIdpep1tk
	S0M0bWIO4k5aBKFSmu1zDO2vmGc31JjmYcrzOHOwmLAe6SP3qhb/bavzU5CiIR94CetTsF
	+QuPdxUavDYoncquE7l6K8hiW3Pvbns=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5337fa12431so320341cf.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:10:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792681854; cv=none;
        d=google.com; s=arc-20260327;
        b=FNWvZoh2/NpbzfPpYKOnsYxbkyGsVIjvaTbyptG0rgNnxhM0F4VQ8UYeO0EaR+CQXs
         Wri847TC7J+WuaDoSmPdnp1BUqLZRpz0cXab1b8cjuiRl0yoq4OZB+D1XpP+91tZ+GCi
         CdtqEadwaysX+BxB4Np2IjbkVe5iKAIrKou/mt3oy9fWe/PZG+7CoGOuwiHedxI6oybN
         UI6wnM8QYG/T/md/jUBaSptMa61g9gRo3Q3DCr7cAbP0WVtmlSlgyGlP3UKbV9lpVoLx
         IBRYHkRAtUt6t1xo4vsCw/epuY3DRd8haJIsxtaI6JxokyBgMXh42ovzBpb4dU3SMz3u
         u5lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2B5vza+jbwkGAZonP3DChsQgZkW/jPoj7zNLZG98cpg=;
        fh=UOCZTIcb6xO/h69Y5cNQc8mPXc2hYBkqlNqM27Taf/I=;
        b=Vgpfwq2BpuAajQzzLHmSGU+c7COiSw1QSJ1Jl3N6X9KeuuKSIe+fjWMRZ9ZYLOCFAp
         W4DFrAMuIkx6YqVkCHw1VJvRPrYXnoqjvNgok8dALUsSgkqLFylVUFhCIbmnYGnh5nW2
         DDFEtydxwt4ikbFCy4Ga7doR5A2OssJagJqiwALO2gshCUUOFjBm+XjpejT5LUpZzZZy
         Ri4k/nHC81oLVz5JtqcaSsmmwViOKjHD4PxeqzL3cjGHVhHHezpNpyZb6fGMwV8rVj79
         9wrIgpzlIdrWXUMtXhQTw2YV+nWl5BM5puiUZy7ZFXolrz9NurMpyMV52xLSh7ijjOxC
         DPOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792681854; x=1793286654; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2B5vza+jbwkGAZonP3DChsQgZkW/jPoj7zNLZG98cpg=;
        b=DORc+YRCqykBRAEWeZXN30kKBFN0Q2AgwS7ZPqfabwujl3TEtCL7h0Q+ShqaZRfoMF
         kLNNobJWrRvUc+rDHYX3jt/T20XjkeZYxA7V6CMzu7r5Q+d1VwTSRa8UMa8LZvn5FMKV
         wKrXyKrq8KvfW2KGLxFMPrth14suEzh99xz5Dp6wOUiPFHjdrdiOluBpBxT2RxrJaTsA
         yjQu1XClOhcEvubtd3fVJsk+xhIv/0GqUWGGnneP/ykDSa/eIDdSJrewQGoF7RhgSSnE
         8PMIKIO3P0/ilYHWD6+aB/79YQAwsozt6LrGmHJ9CnujsCuGSnMNDGSc9iQOWpiClhVK
         TmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792681854; x=1793286654;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2B5vza+jbwkGAZonP3DChsQgZkW/jPoj7zNLZG98cpg=;
        b=RQhAUnd9aaPyjMZ4TZ1ovSZgAUsVmyCjbAGDinqK0LGOsYRMME1C1yplKakHbcTw1z
         wd45X3GgJoPslqPi5BY0MLC2SiIBady2UZyeRIW1xMupEr0QawJOsiV6xFo3LvRYZstz
         KsAZ7Z0MAyrJN+3D10UYS81DUhZvxfcMdB6XYEQScE2hXtMwsh97bPmXbHscXYK5pTtb
         wOOhGyt1RpbkGkHvcqYyOMxWme32zzMuzbZORxfswU+9sG4uUbWJqmJLeS22q2qO7S7D
         r/cYSgJh1Jzmll3ANAXaG2niQkOJM9qigWwOj7dLjjDaLbyWQWXAbDVd9WHOFjcbBd6g
         82Zg==
X-Forwarded-Encrypted: i=1; AKwUvBxoJQjeqa452IoetUfu/M73IAgsODTbmqWXbF7ANG0j/nt21UUW6Q1uvnkcjYedjTzS7HMlsKFteg==@kvack.org
X-Gm-Message-State: AFq9FYJ8gF4Pa0BWj+Qr1pu9TOHHQeov2XkQjRhJCJt2V6TPtJBL7+Um
	ysczszfXiEdbRocwV6j81YPkkArFKCbBhQiIbdk2OAihl0q+6NvqvjY0J8QJ3xlPwzKr7GYf483
	efwAwa144VnSfp4WYNd5UCRufWiB1XvlllZ5+9Jiu
X-Gm-Gg: AYBFou2ptgkrlBD4eW0NGdpt+aePrPlifKMn2u5botvgfKVX3957Er2uZX053UItsg1
	HoTcXgJEJ0xMQAfAFOn3HuzYLERLbiDry1uCAS4i8ulGvMProo1NktZ3GBdwF4NRDz8MUUX9SXx
	1IhUfu46dkySjIfeQ1B7l2y7bZjWbJHXNuxzKXenYWPHrMMoN5DCNliCnFUEi9zscB/Xf9CHVvW
	NXzuxcivrqr6kfCPnaMY4GfUoxL1kpAVhkvZeEcw/2QPFs/JA3Cza7DjRlonRolJKrMLeiVguqb
	Bss6CEeZHSwMlMzHk4NwDDUkqaf7OsZOMinuM+V1Qj8OVuM+GF8AT7bqjUShxPNI780okSlpaRg
	FJJE2L8Ns9iR60zszEopp39eKqeszmmjwVjqCg6gOPQgRdBA9/zYOvgC7brbRoBNF
X-Received: by 2002:ac8:5d8e:0:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-536b062b3damr17529581cf.10.1792681852565; Thu, 22 Oct 2026
 08:10:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
 <323077f96bca23b512a86a6781ebc9dfe6ae9ec1.1792439751.git.abhishekbapat@google.com>
 <79568d55-705d-466c-8a3a-c2ec3143e5c2@linux.dev>
In-Reply-To: <79568d55-705d-466c-8a3a-c2ec3143e5c2@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Oct 2026 15:10:39 +0000
X-Gm-Features: AclHuK_Rmc-NbWkeOVT6nTn4JWdc32YtkiptWfkY5rv6RBPXlNIz1Wu8Ig0EHk0
Message-ID: <CAJuCfpFtqM+kvt+N7Ou4BJ+hR6qb3R8GC3_FxdJKHboQyBFWgg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] alloc_tag: Add trace events for tracing allocations
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF597C0007
X-Stat-Signature: ytb37cfcotgt4jggx57anodncqym85ph
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792681854-4740
X-HE-Meta: U2FsdGVkX189CXG5cxEqzQC+2/NBJY9HBMCo2k2n7GFXkMHUaVzipsq/aaOx0hidYwGIvSKRNpBlkRwmkY/LlD5dCAmzIE3uoGmrF4ZbhVx+/R8Y0rypVap8NoTj1yhK60ETvdJ1ykraA2c0CjB0FmJGc6n0l4ebEG0Zx40FTILgpY8e2jKS8PWVFBR6ghH38ZLgJ3wDUotFF8rFbSsu8zeFmK8goKPuRCZs6n2CNov/LF6YA2fUlJXzlu2WP0sqedMIIbwztSNbTt/JFW4Xwn5GrZcYdWDvNk/sQPv0scar1gcDK6lVA8iFIRSZNSgS21KMqIWvRejiA/jhfs2eBtxwyCfzLihXStaOAeGDAYQo/7OU7udG5KRKfjhakR59UssmnqdcUDG8eRompvkEipi5cJR5qA+V9tKAwIwWw1lhfaBm33Rhow6qIEtq1MnY7Ab0+efQeJKyxqgDFr1+b5bCF80fFoMWDk1og3xkxP6CLDIqLCTJU0xGvTFJ1wrf6Cct/48nIp9o5lCm/5ZJiUJLDBXhXC1M6YGIUxbNx/f1Y7LKPg4oSxsgmzYPP6IzlYWWXF0O4eynTCzpuLj9asJ2/+/WOHWWv4nwU55nmCBpXAecH+Y5dnyNHzWN16oIKCgguheTvkSHe0R/WKKMCxrPOr5lIWpbCxOTIzIZsKUP/kxqp8CLbxyPQMj2NihUsmgd3lX034SRJFRdcVjYiKmQ1rBXgzf8B9+VoEpdSuHN9TGy0DEl8y4ZFi26zq6KUI5Bb5RcbAVjrDoKB7nckDk8G0ZNEjiZ4FSsBV2OBZzbt8ZD6Wl4Wn3Jaz4UIC0fpkeXEoinw/jN5VNGp37Y88CG4cB+YM8DzzlSdznQl/nKdMEjQjPuf9KPKpD0niKxcJQg7x4A0P89p/HpIjO68wz71U6mqRliyfPquX3GNBo0rjr4wdnfZ5mJaqvtwOeILs8v5xpho8wJkpe5pqf
 jdRx8m6w
 51j74NlmRTS5gN86+5ES4XZVflo4MJ+xVFvktK3rn01rYgT4LHDprcHge7rpEMjiVzR/Wpu0g5n1KF/x8EAitKFsmBc3Yc5/y9VAbLCQmed8rGV7VvhOthDIUHI8vT8TXdoNVfav58buwWO31Lcgjq3BrZpR7LM2lJj5GFonXf2n6FkEph0bxfIPJXddMDEpv4nc5JaIW3ndfbBn33jyXyFZPG14vjZgbpb2TORANrFK2USRfs36qhqiysDMTw/8Iu6w03h4Mhs2rQgPpLEKPBzcd7KVcwvyKH0RSk2utjCj3S7nyqhhJHhdDfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:35=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
>
> On 2026/10/20 04:00, Abhishek Bapat wrote:
> > The memory allocation profiling framework intercepts allocations across
> > the core subsystems, but currently lacks runtime tracing hooks for
> > standard observability tools to dynamically track the context (stack
> > traces and lifecycles of the individual memory chunks) of the
> > allocations made.
> >
> > Introduce three standard trace events to allow this tracking:
> >
> > 1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
> >    tools to trigger and capture a call stack.
> > 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
> >    allocation. It records the allocated size, the tag, and the uniquely
> >    generated `ptr` value which is `codetag_ref` for slab and percpu
> >    allocators and the pointer to the head `struct page` for the page
> >    allocator.
> > 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
> >    freed, yielding the same `ptr` value to allow tracing tools to find
> >    the corresponding allocation.
> >
> > Because the introduced trace events occur at different stages in the
> > call stack, userspace tracing tools must stitch them together to form a
> > complete picture of a buffer's lifetime. Here's an example of how
> > userspace correlates these three events:
> >
> > 1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
> >    keyed by the combination of the current thread's PID and the `tag`.
> > 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
> >    the event and looks up the stack trace cached in step 1. It creates =
a
> >    new active allocation record, mapping the new provided `ptr` value
> >    to this cached stack trace and the newly returned allocation size.
> > 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
> >    the same `ptr` value. The tool uses this reference to look up the
> >    original allocation record, correlates the free, and safely retires
> >    the tracking entry.
> >
> > Modify `alloc_tag_add()` and `alloc_tag_sub()` with a `ptr` argument to
> > map frees to allocations in the trace events. Slab and percpu pass the
> > address of the object's `codetag_ref`. The page allocator passes the
> > head `struct page` because its `codetag_ref` is a temporary copy on the
> > stack.
> >
> > Also, introduce `alloc_tag_trace_key` static key to minimize the
> > overhead when no tags are being traced (the usual case). Once tracing
> > for any tag is requested, the key is set, opening the path to check
> > whether tracing is enabled for the current tag.
> > Note that the mechanism to enable tag tracing is implemented in the nex=
t
> > patch, therefore for now, `alloc_tag_trace_key` stays always unset.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > Acked-by: Hao Ge <hao.ge@linux.dev>
> > Acked-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  Documentation/mm/allocation-profiling.rst |  53 ++++++++++
> >  MAINTAINERS                               |   1 +
> >  include/linux/alloc_tag.h                 |  67 +++++++++---
> >  include/trace/events/alloc_tag.h          | 122 ++++++++++++++++++++++
> >  mm/alloc_tag.c                            |  28 +++++
> >  mm/page_alloc.c                           |   4 +-
> >  mm/percpu.c                               |  13 ++-
> >  mm/slub.c                                 |   6 +-
> >  8 files changed, 269 insertions(+), 25 deletions(-)
> >  create mode 100644 include/trace/events/alloc_tag.h
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index b11ea77c0673..b241450394df 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -129,6 +129,59 @@ To do so:
> >  - Then, use the following form for your allocations:
> >    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> >
> > +Tracing
> > +=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Three trace events are available under `/sys/kernel/tracing/events/all=
oc_tag` to
> > +expose the full call stack and the lifetime of individual allocations:
> > +
> > +- `alloc_tag_hit`: Fired at the exact call site, before the allocation=
 happens.
> > +  Can be used to capture the call stack of the caller.
> > +
> > +- `alloc_tag_mem_alloced`: Fired once the allocation succeeds. Carries=
 the `ptr`,
> > +  `tag` and `bytes` for each allocation.
> > +
> > +- `alloc_tag_mem_freed`: Fired before memory is freed. Carries the sam=
e
> > +  `ptr`, `tag` and `bytes` as the matching alloc event.
> > +
> > +`ptr` identifies the allocation, and its meaning depends on the alloca=
tor:
> > +
> > +- slab and percpu: the address of the object's `codetag_ref`
> > +- page allocator: the `struct page` pointer of the head page
> > +
> > +Correlating the events
> > +----------------------
> > +
> > +`alloc_tag_hit` and `alloc_tag_mem_alloced` come from different points=
 in the
> > +call stack, so they have to be stitched together by the user consuming=
 the
> > +events. Here's a typical flow:
> > +
> > +1. On `alloc_tag_hit`: Capture the stack trace and cache it keyed by `=
(pid, tag)`.
> > +
> > +2. On `alloc_tag_mem_alloced`: Look up the cached stack trace by `(pid=
, tag)`,
> > +   then create an active allocation record keyed by `ptr` that holds t=
he stack
> > +   trace and `bytes`.
> > +
> > +3. On `alloc_tag_mem_freed`: Look up the record by `ptr` and retire it=
.
> > +
> > +Limitations
> > +-----------
> > +
> > +- For the page allocator, events are generated for the original alloca=
tion and
> > +  the free only. If the tag reference is split or moved to another fol=
io in
> > +  between, no event is generated for that. As a result:
> > +
> > +  - a free event may carry a `ptr` that never appeared in an alloc eve=
nt;
> > +  - `bytes` in a free event may be smaller than in the matching alloc =
event.
> > +
> > +  Tools should correlate on `ptr` but must not assume that freed bytes=
 equal
> > +  allocated bytes, or that every free has a matching alloc.
> > +
> > +- Freeing a non-compound high-order page with `__free_pages()` while a=
nother CPU
> > +  holds a reference frees the tail pages immediately and the head page=
 later when
> > +  the reference is dropped. The free event is emitted at the second po=
int and
> > +  reports `PAGE_SIZE` rather than the full size.
> > +
> >  Notes
> >  =3D=3D=3D=3D=3D
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6f1f35a017a6..fb2df7b8e9ee 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17100,6 +17100,7 @@ S:    Maintained
> >  F:   Documentation/mm/allocation-profiling.rst
> >  F:   include/linux/alloc_tag.h
> >  F:   include/linux/pgalloc_tag.h
> > +F:   include/trace/events/alloc_tag.h
> >  F:   include/uapi/linux/alloc_tag.h
> >  F:   mm/alloc_tag.c
> >  F:   tools/testing/selftests/alloc_tag/
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 7f2d80a59792..0319c2f1e4e2 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _share=
d_alloc_tag);
> >  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=
,
> >                       mem_alloc_profiling_key);
> >
> > +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > +
> >  static inline bool mem_alloc_profiling_enabled(void)
> >  {
> >       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_=
DEFAULT,
> >                                  &mem_alloc_profiling_key);
> >  }
> >
> > +static inline bool alloc_tag_trace_enabled(void)
> > +{
> > +     return static_branch_unlikely(&alloc_tag_trace_key);
> > +}
> > +
> > +void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
> > +                            size_t bytes);
> > +
> > +void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
> > +                           size_t bytes);
> > +
> > +void __alloc_tag_trace_hit(struct alloc_tag *tag);
> > +
> > +static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> > +{
> > +     if (alloc_tag_trace_enabled())
> > +             __alloc_tag_trace_hit(tag);
> > +}
> > +
> >  bool mem_alloc_profiling_permanently_disabled(void);
> >
> >  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_ta=
g *tag)
> > @@ -198,13 +219,19 @@ static inline bool alloc_tag_ref_set(union codeta=
g_ref *ref, struct alloc_tag *t
> >       return true;
> >  }
> >
> > -static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_=
tag *tag, size_t bytes)
> > +static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_=
tag *tag, size_t bytes,
> > +                              const void *ptr)
> >  {
> > -     if (likely(alloc_tag_ref_set(ref, tag)))
> > +     if (likely(alloc_tag_ref_set(ref, tag))) {
> >               this_cpu_add(tag->counters->bytes, bytes);
> > +
> > +             if (alloc_tag_trace_enabled())
> > +                     /* Trace successful allocs with their unique ptr =
*/
> > +                     alloc_tag_trace_mem_alloc(ptr, tag, bytes);
> > +     }
> >  }
> >
> > -static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
> > +static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes,=
 const void *ptr)
> >  {
> >       struct alloc_tag *tag;
> >
> > @@ -222,6 +249,10 @@ static inline void alloc_tag_sub(union codetag_ref=
 *ref, size_t bytes)
> >       this_cpu_sub(tag->counters->bytes, bytes);
> >       this_cpu_dec(tag->counters->calls);
> >
> > +     if (alloc_tag_trace_enabled())
> > +             /* Trace frees with their unique ptr */
> > +             alloc_tag_trace_mem_free(ptr, tag, bytes);
> > +
> >       ref->ct =3D NULL;
> >  }
> >
> > @@ -243,25 +274,29 @@ static inline bool alloc_tag_is_inaccurate(struct=
 alloc_tag *tag)
> >  static inline bool mem_alloc_profiling_enabled(void) { return false; }
> >  static inline bool mem_alloc_profiling_permanently_disabled(void) { re=
turn true; }
> >  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_=
tag *tag,
> > -                              size_t bytes) {}
> > -static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)=
 {}
> > +                              size_t bytes, const void *ptr) {}
> > +static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes,
> > +                              const void *ptr) {}
> >  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
> >  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { re=
turn false; }
> > +#define alloc_tag_trace_hit(_tag)    /* NOOP */
>
> I'd rather this follow the code style below.

Yes please. Both alloc_tag_record() and alloc_tag_restore() use "do {}
while (0)" construct. Let's keep this one consistent.

>
> >  #define alloc_tag_record(p)  do {} while (0)
> >
> >  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >
> > -#define alloc_hooks_tag(_tag, _do_alloc)                             \
> > -({                                                                   \
> > -     typeof(_do_alloc) _res;                                         \
> > -     if (mem_alloc_profiling_enabled()) {                            \
> > -             struct alloc_tag * __maybe_unused _old;                 \
> > -             _old =3D alloc_tag_save(_tag);                           =
 \
> > -             _res =3D _do_alloc;                                      =
 \
> > -             alloc_tag_restore(_tag, _old);                          \
> > -     } else                                                          \
> > -             _res =3D _do_alloc;                                      =
 \
> > -     _res;                                                           \
> > +#define alloc_hooks_tag(_tag, _do_alloc)                              =
       \
> > +({                                                                    =
       \
> > +     typeof(_do_alloc) _res;                                          =
       \
> > +     if (mem_alloc_profiling_enabled()) {                             =
       \
> > +             struct alloc_tag * __maybe_unused _old;                  =
       \
> > +             /* Fired here to capture the caller's stack trace */    \
> > +             alloc_tag_trace_hit(_tag);                               =
       \
> > +             _old =3D alloc_tag_save(_tag);                           =
         \
> > +             _res =3D _do_alloc;                                      =
         \
> > +             alloc_tag_restore(_tag, _old);                           =
       \
> > +     } else                                                           =
       \
> > +             _res =3D _do_alloc;                                      =
         \
> > +     _res;                                                            =
       \
> >  })
> >
> >  #define alloc_hooks(_do_alloc)                                        =
       \
> > diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/al=
loc_tag.h
> > new file mode 100644
> > index 000000000000..58d420e64516
> > --- /dev/null
> > +++ b/include/trace/events/alloc_tag.h
> > @@ -0,0 +1,122 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM alloc_tag
> > +
> > +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_ALLOC_TAG_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +/*
> > + * alloc_tag_hit is generated at the exact allocation call site and ca=
n be
> > + * used to capture a stack trace.
> > + *
> > + * To link this stack trace to the actual allocated memory chunk, tool=
s must
> > + * correlate this event with the resulting alloc_tag_mem_alloced event=
. Since
> > + * multiple threads can hit the same tag simultaneously, tools must ma=
tch BOTH
> > + * the `tag` field and the implicitly recorded PID provided by the cor=
e
> > + * tracing subsystem.
> > + */
> > +TRACE_EVENT(alloc_tag_hit,
> > +     TP_PROTO(struct alloc_tag *tag),
> > +
> > +     TP_ARGS(tag),
> > +
> > +     TP_STRUCT__entry(__field(struct alloc_tag *, tag)
> > +                      __string(modname, tag->ct.modname ? tag->ct.modn=
ame : "NONE")
> > +                      __string(filename, tag->ct.filename)
> > +                      __string(function, tag->ct.function)
> > +                      __field(unsigned int, lineno)
> > +     ),
> > +
> > +     TP_fast_assign(__entry->tag =3D tag;
> > +                    __assign_str(modname);
> > +                    __assign_str(filename);
> > +                    __assign_str(function);
> > +                    __entry->lineno =3D tag->ct.lineno;
> > +     ),
> > +
> > +     TP_printk("tag %p, module: %s, filename: %s, function %s, lineno =
%u",
> > +               __entry->tag,
> > +               __get_str(modname),
> > +               __get_str(filename),
> > +               __get_str(function),
> > +               __entry->lineno
> > +     )
> > +);
> > +
> > +/*
> > + * alloc_tag_mem_alloced is generated after memory is successfully all=
ocated.
> > + * It captures the exact byte size.
> > + *
> > + * The `ptr` value identifies the memory chunk for tracking its lifecy=
cle
> > + * (e.g., matching it with alloc_tag_mem_freed).
> > + * - slab and percpu allocators: address of the object's codetag_ref
> > + * - page allocator: the head struct page of the allocation
> > + *
> > + * Because the kernel isolates active allocations within the task stru=
ct
> > + * (current->alloc_tag), this event will always share the same implici=
t PID as
> > + * its corresponding alloc_tag_hit event. Tools should use the combina=
tion
> > + * PID + `tag` to correlate them.
> > + */
> > +TRACE_EVENT(alloc_tag_mem_alloced,
> > +     TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
> > +
> > +     TP_ARGS(ptr, tag, bytes),
> > +
> > +     TP_STRUCT__entry(__field(const void *, ptr)
> > +                      __field(struct alloc_tag *, tag)
> > +                      __field(size_t, bytes)
> > +     ),
> > +
> > +     TP_fast_assign(__entry->ptr =3D ptr;
> > +                    __entry->tag =3D tag;
> > +                    __entry->bytes =3D bytes;
> > +     ),
> > +
> > +     TP_printk("ptr %p, tag %p, bytes %zu",
> > +               __entry->ptr,
> > +               __entry->tag,
> > +               __entry->bytes
> > +     )
> > +);
> > +
> > +/*
> > + * alloc_tag_mem_freed event is generated immediately before memory is
> > + * freed. The `ptr` value matches the one emitted during allocation,
> > + * allowing tools to match it to its corresponding allocation and
> > + * call stack.
> > + *
> > + * Page allocator caveat: Pages can be split or moved to another folio
> > + * after the alloc event with no new events generated for that. As a
> > + * result, a free event may carry a `ptr` that never appeared in an
> > + * alloc event, and the `bytes` may be smaller than in the matching
> > + * alloc event. Tools must not assume alloc bytes =3D=3D free bytes, n=
or
> > + * that every free has a matching alloc.
> > + */
> > +TRACE_EVENT(alloc_tag_mem_freed,
> > +     TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
> > +
> > +     TP_ARGS(ptr, tag, bytes),
> > +
> > +     TP_STRUCT__entry(__field(const void *, ptr)
> > +                      __field(struct alloc_tag *, tag)
> > +                      __field(size_t, bytes)
> > +     ),
> > +
> > +     TP_fast_assign(__entry->ptr =3D ptr;
> > +                    __entry->tag =3D tag;
> > +                    __entry->bytes =3D bytes;
> > +     ),
> > +
> > +     TP_printk("ptr %p, tag %p, bytes %zu",
> > +               __entry->ptr,
> > +               __entry->tag,
> > +               __entry->bytes
> > +     )
> > +);
> > +
> > +#endif /* _TRACE_ALLOC_TAG_H */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 82e2c3448dcf..ca2412a67312 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -18,6 +18,9 @@
> >  #include <linux/kmemleak.h>
> >  #include <uapi/linux/alloc_tag.h>
> >
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/alloc_tag.h>
> > +
> >  #include "internal.h"
> >  #include "page_alloc.h"
> >
> > @@ -54,6 +57,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
> >
> >  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> >
> > +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > +EXPORT_SYMBOL(alloc_tag_trace_key);
> > +
> >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> >  unsigned long alloc_tag_ref_mask;
> >  int alloc_tag_ref_offs;
> > @@ -484,6 +490,28 @@ static const struct proc_ops allocinfo_proc_ops =
=3D {
> >  #endif
> >  };
> >
> > +void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > +{
> > +     if (unlikely(!tag))
> > +             return;
> > +     trace_alloc_tag_hit(tag);
> > +}
> > +EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > +
> > +void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
> > +                            size_t bytes)
> > +{
> > +     trace_alloc_tag_mem_alloced(ptr, tag, bytes);
> > +}
> > +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
> > +
> > +void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
> > +                           size_t bytes)
> > +{
> > +     trace_alloc_tag_mem_freed(ptr, tag, bytes);
> > +}
> > +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
> > +
> >  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, b=
ool can_sleep)
> >  {
> >       struct codetag_iterator iter;
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2daf358269ae..e8bb12a6a721 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1241,7 +1241,7 @@ void __pgalloc_tag_add(struct page *page, struct =
task_struct *task,
> >       union codetag_ref ref;
> >
> >       if (likely(get_page_tag_ref(page, &ref, &handle))) {
> > -             alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> > +             alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr, page=
);
> >               update_page_tag_ref(handle, &ref);
> >               put_page_tag_ref(handle);
> >       } else {
> > @@ -1270,7 +1270,7 @@ void __pgalloc_tag_sub(struct page *page, unsigne=
d int nr)
> >       union codetag_ref ref;
> >
> >       if (get_page_tag_ref(page, &ref, &handle)) {
> > -             alloc_tag_sub(&ref, PAGE_SIZE * nr);
> > +             alloc_tag_sub(&ref, PAGE_SIZE * nr, page);
> >               update_page_tag_ref(handle, &ref);
> >               put_page_tag_ref(handle);
> >       }
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index d7883507dc15..16f29020bcad 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -1695,16 +1695,19 @@ static void pcpu_alloc_tag_alloc_hook(struct pc=
pu_chunk *chunk, int off,
> >                                     size_t size)
> >  {
> >       if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
> > -             alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIF=
T].tag,
> > -                           current->alloc_tag, pcpu_obj_full_size(size=
));
> > +             union codetag_ref *ref =3D &chunk->obj_exts[off >> PCPU_M=
IN_ALLOC_SHIFT].tag;
> > +
> > +             alloc_tag_add(ref, current->alloc_tag, pcpu_obj_full_size=
(size), ref);
> >       }
> >  }
> >
> >  static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off=
, size_t size)
> >  {
> > -     if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
> > -             alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIF=
T].tag,
> > -                           pcpu_obj_full_size(size));
> > +     if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
> > +             union codetag_ref *ref =3D &chunk->obj_exts[off >> PCPU_M=
IN_ALLOC_SHIFT].tag;
> > +
> > +             alloc_tag_sub(ref, pcpu_obj_full_size(size), ref);
> > +     }
> >  }
> >  #else
> >  static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int of=
f,
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 544cff39762c..a866576ccb98 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2404,7 +2404,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache=
 *s, void *object, gfp_t flags,
> >               obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
> >               ref =3D slab_obj_ext_codetag_ref(slab, obj_ext);
> >
> > -             alloc_tag_add(ref, current->alloc_tag, s->size);
> > +             alloc_tag_add(ref, current->alloc_tag, s->size, ref);
> >
> >               put_slab_obj_exts(obj_exts);
> >       } else {
> > @@ -2444,9 +2444,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache=
 *s, struct slab *slab, void **p
> >       get_slab_obj_exts(obj_exts);
> >       for (int i =3D 0; i < objects; i++) {
> >               struct slabobj_ext *ext;
> > +             union codetag_ref *ref;
> >
> >               ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> > -             alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->siz=
e);
> > +             ref =3D slab_obj_ext_codetag_ref(slab, ext);
> > +             alloc_tag_sub(ref, s->size, ref);
> >       }
> >       put_slab_obj_exts(obj_exts);
> >  }

