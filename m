Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9E4CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31746B0088; Sun, 18 Oct 2026 00:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1896B008C; Sun, 18 Oct 2026 00:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7796B0092; Sun, 18 Oct 2026 00:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88CA46B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:49:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 064E6A7E9A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:49:26 +0000 (UTC)
X-FDA: 85334518332.29.DC20E14
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00883180002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:49:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzZW6EXt;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792298964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbA6yEaZjrf3fffhOQxM5ImzQvm0SaTSnQV8IjXbQzQ=;
	b=AO/PAk6WC6WGnui9Ub+GM8IU7HMJzV8APVZjVFQMF/K0txQyuDg0rgcf1eQOQTxTFB1jPg
	8knJshSGV6Cnhl+EZghLCq47uDKdZIemxiWg9+vQhk3sYJlUWGDNjUB2SzaYwp4VNyqw7p
	djTfCpGeeH3q6HFRMZfYeporjXYEVIg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792298964;
	b=foALIN6dtsHhx+YuF0r8EH5mKwXuD2fVHnuBNJhX/eiAf6n707rAnIagn+ygGN5ybKEANe
	Xb1CSiY92jJwBhtiM4JUCLb7RoHXZya5kIkWrWEOe2B6ngtd6qc3sLZFTG2EqB6R8nLe+T
	lvV1kRpY0bcNIF9kRbcrY9Xk0XiMp2A=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzZW6EXt;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535f598d126so153391cf.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:49:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792298963; cv=none;
        d=google.com; s=arc-20260327;
        b=K94gV0akPspNnpARiDRhMJDxMeQmw8JZlfogOvOgvdZ0WRXCjpnYkbkufybfZpvx3/
         wUT2xEV74PyK62HwBhHzSVTGJbqi4W5aMOxj1LWNy70BcWJyyi1+yxL2P26615h8QW5D
         50vxioIsv/YL8UM/NUkMVdcnCnj3vfuW4dLYhIqp6/qZR83/OBC1bwXaYnrvx6vx0GtT
         dhxTphZIZrJTbxWVSr6ofVngzWNAxS+tM5Z/3Gk9AC3+Opr58zwZ1h0+7mJQ6BcaPuZr
         qfkYSJNsQVUdPKHTIY0jQfIuCarKHmPZeWsoX3+FsCCPJufmrXa6ht+VZQJDEfIFHhFR
         fDEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DbA6yEaZjrf3fffhOQxM5ImzQvm0SaTSnQV8IjXbQzQ=;
        fh=1hgo9A9otDc83I44H72lSB4Ql/24d7nuDftqhrnsUaQ=;
        b=O9uncTPMOFC/FGa99FaKCXnJ8bJg7BDGpHIr7puTacB/3H1SOdUB3U5GdjE9GX8iDR
         ICGG9Ze0dMYHWXZfYGjTvPMXlBTqLOZauIBHhpVX5qk6Mvzy9h99x2FNMuZ39piK2JM0
         MQPJfRqw6pt0SYZEsr+9G476Tu945sfjYsqJXoq8kXl1wYln8q4x39DUsaRL8IlQJisO
         csltl3t9zefFrefgjsjMMnH8283b72qdsy4FxHIUq6dESLULqbX6eJTkSurPiqToGuSy
         gSNfVDfe+Xgp/qQHkurnTdIZNfSVg8t+W/URfCsJeAlDn2qee4ApLwxpKfBG2us1gZRS
         iH2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792298963; x=1792903763; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DbA6yEaZjrf3fffhOQxM5ImzQvm0SaTSnQV8IjXbQzQ=;
        b=EzZW6EXtaZCwX3SomPfNjzUto4VWBJqBZqYo3DttXjIOrSdxxGZtzFkgW8LRlUqRiG
         VbM2ZTLzSI8FJRgyOC4TuclP3X5ZZfXsG+IsdiRHY5VQbbsHRVGBb9UJdXzp97yMLZTD
         KTSX+oVisJ2eC5hG7AeQXcvdDKkP1My9nZmgcdIGjtn7fyYwlD2cT+gmLZse7Dsyj1gD
         91LEIvzGh2hBkYPi8Ndut+Rw5QhNq+lzpG4HeBh23eVkws8vhVk8aybD9FWMhE/vB+2Y
         d+332/AZNTOJtgOd95SPp6w9E+L31n0VIDf6Nhd7exxEytzpRj0qjIe4/PzrTEy+781d
         /mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792298963; x=1792903763;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DbA6yEaZjrf3fffhOQxM5ImzQvm0SaTSnQV8IjXbQzQ=;
        b=CJbpX9YJNT5CkHrvnYOPTdWgLSHX/ITAVGOj/InSh+jJUsTiCcdrlLO0NNmWWIBCdk
         fsh/Ogh8ZgSqCwwQlUlMTyc+UsoaicEVOmIryoKwz4OxnbKhmB26/R1ngg0l5oOfmejv
         GS4m87M+9pLuvXaJoEwST7raM7bS244lXM9AvXn+njRUXYP4lR+sijun6GBC0ni/omxg
         vqPXxBnFvXXbFfezB8zBjE/06PsEUqL3OjOdt04ibI4bo4bU3Szlesdn8M+FOxJHjsXq
         Csvy8ibnJsxNXAKoWmYZrI/nRxBHD8x66GyNrb//PbGqFhh/NJU9coj7M8uczYqlT4aO
         CvCQ==
X-Forwarded-Encrypted: i=1; AKwUvBxX2IaOpoZrYyGkJXEl37ZAxIO6VJclZoJYHuDCNhiRn7Vhi6dXBvVW1i5y6AD9NgUze1C653jpRA==@kvack.org
X-Gm-Message-State: AFq9FYL1nNZ5/cYuSwgyVyUbNaJ0pkIPWUfZcQU45i4NADxCUKlB1fTK
	tiDFutdkA3RTOZvCexKxJFb9SXQ8aDKNe7P3IIbqOg1JSx2yT8s343XS8HVIaOlOKzNe7b69KTJ
	RXH6OfynlCBwZMTPhM70GkJN/X59H1393CIhgGEfp
X-Gm-Gg: AYBFou1pl1O7q5e9tpNuKjEnp7jORhNpc9S3XvAwOA/a4nU2vQB59+WSl/FrGxwL5tT
	2kt4dtG+mECpfYc3Fo3zMEoToCGtOJGNJdxEc8C+jweR23dzgTcO2XI08v8BS4YaWGqg+TNqxue
	wcbNUIwXaYW44CERvfkUlSzkPtlj0TW66TzCI1RzZuDqGHEDtWkI8n/4/Jb4JE5JN0NX6Aw7VAB
	8ksQ2BJpuzFqDS0P0R16O6UVxWUS90xdx8lidvdXP3LVSJYP8k45dLC7cDH1ldoUFdGiY7hqobs
	tVccdxeiEMAQPB/YzCo9Dj0UGgMs1Zwe7TIbG7cl5cT8ufHLhOhnJweWPSVwKKjQRa+d2o3w/eZ
	rXxjiv1yqsnlmTy7TxwaG8zZd7TWhmBDLeFrEFQ==
X-Received: by 2002:a05:622a:5a17:b0:532:9003:35b1 with SMTP id
 d75a77b69052e-53649abbe44mr16409831cf.2.1792298962267; Sat, 17 Oct 2026
 21:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
 <1f77364a04d0ae20cf07efaca779756f92ec39f6.1791410886.git.abhishekbapat@google.com>
 <ed833aa7-90fa-4c44-a423-c5b689ede379@linux.dev> <CAL41Mv6Kp9qLtPum36WaMpOtrmTG3LZoEXyD=s78DH+9ruKO7g@mail.gmail.com>
 <7473d6e6-cbcd-40f5-9b48-e2cac9c926f1@linux.dev>
In-Reply-To: <7473d6e6-cbcd-40f5-9b48-e2cac9c926f1@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 18 Oct 2026 08:49:09 +0400
X-Gm-Features: AclHuK8Bgw5pdULwObzqzfnyRpCU37dJNp3J_a4l9O7nErF5gZdd0YKnivN-Yrs
Message-ID: <CAJuCfpFN6YuBjFA+YzyEujs1G7Vn-BHG8jJ6_ffx9vKOPUr4qw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 00883180002
X-Stat-Signature: eyef7574awghpo3b81y1end8gqx813ra
X-Rspamd-Server: rspam05
X-HE-Tag: 1792298963-479853
X-HE-Meta: U2FsdGVkX1+yznxd/xK47dhmanNiYQU1DymGMFDfOX2/NbEvEILoW3Muz050BWESGdPDWBt+Qb3gFBHhIqAJiBXlRjOcWmmHuN94fAALCSp2EybNLnbgiKItuHze7u1Osg/8+wfFuTIhfiE0j0KqA5dMO0ek6vuxZGOrW4iV+U7aoeES7TAa21agSuoCaO3zJTk2reTaOtTd35Mjg6Lg8k+tUUW4k1u4cS6Olj/Jt1fcZjnaZu5BBLwo66yTzKPDDrMVdPTsNg/PfTtkJ9cujgH8jywBVGjImhAnu+SrsJabPQ2Izb0uqdon4pcE4cD3JiGiJhBgaYxT45O4a4OIDcNxympekJ5pOp1SDol2mCfxppC5SRX7lTvmaY3RrFxxFKoPkaVfSucYAA+MNibX+Vzuo91v85tFYuXVK6BOmydO+AFR1ssQg6B/v6QFILeG6KCL4gbu6zDlc1w14mt3Vxycbw3CmJpoi2IZts6BNTogax0xw4qZ9U04bsQfbipXzLHkvyUAd5R7pya9bRCM19gLN4MRkEjqEev0NXDFFfWaTlJGXwpZps9XzJ9JKDnFL6t27SZaSpuwaOxr32kFQJpOEpblN/FBu9q57SrZZ8EE3sak7ts8NlVuot1+tY4WUP7iDNw9vIY4l1bv18HW5iG8suEeB8aL423Z4vDemx1N5Ft3uxWjT6FFtcfxcrqE0TB13dMDY2FioXbZdniWrJJ3S1owwUjWTUgGUlr5nR2XZzrJfbj3T2Pyo1+4BPhTJpjNmoK/GPwD6CCUd9YlNMbKuA0jFzqAZm9IpDx8QLhnXC4G9ulvHJADYUhbQh10tRNjm0O/yuZ8seeNpkNuv9SGuhyphlJgqdDPTA47gFjcYnUZgLCSxLdznIADEHEWQYyYgg7TaDUJZIqQFDiCGRfLIRauutdYU960345CvxkCxv8CYOabFzxB3nd8UtlB4q9fgAhIFCa/NYsvV4l
 8h+/36+Y
 /Dohtv5eGZuVJ8wLzhvAhB+H6UNXiYxz/z7CUIGqH32SRHrIjEpWZSbNygMj8QZuHVVCDLE88+FuK9MBn5jEQKGZm4YuO1TLUsFAzwhVMzEt1YJoYtnG4Px2kjU7DK/nf24T4UzytJkECkCxXTCGY1t8XyTEYSS7AJPRet8N8YGT8LpcW+h7dwJCMUEvEdqdqajpBK6mjFekv1v3eJJs+Dqk7v+ZCK/RlNA+k0sx7N7RjC2+XF2PeE0zFkyi+sFeUR38aH4qIwBvtmJX8sgC5TzbjJN8Bmm9bpiqV42biQqgF6nwKcm8ZALRP6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 7:54=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 10/15/26 01:18, Abhishek Bapat wrote:
> > On Tue, Oct 13, 2026 at 12:41=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >> Hi Abhishek
> >>
> >>
> >> On 2026/10/8 06:40, Abhishek Bapat wrote:
> >>> Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> >>> toggle tracing on allocation call sites. Userspace tools can use the
> >>> existing filtering mechanism to specify the set of tags to toggle
> >>> tracing for.
> >>>
> >>> To facilitate low overhead execution for non-targeted call sites, add=
 a
> >>> new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-sit=
e
> >>> activation. Protect these conditional branch evaluations using the gl=
obal
> >>> `alloc_tag_trace_key` static branch and an inline static key check
> >>> pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc=
).
> >>> This ensures that the trace events are entirely skipped when no
> >>> allocation call sites are being actively traced, leaving only a NOP o=
n
> >>> the allocation fast path.
> >>>
> >>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >>> ---
> >>>   Documentation/mm/allocation-profiling.rst |  20 ++++
> >>>   include/linux/alloc_tag.h                 |  47 +++++---
> >>>   include/linux/codetag.h                   |   5 +-
> >>>   include/uapi/linux/alloc_tag.h            |  13 +++
> >>>   mm/alloc_tag.c                            | 128 +++++++++++++++++++=
+--
> >>>   5 files changed, 187 insertions(+), 26 deletions(-)
> >>>
> >>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentatio=
n/mm/allocation-profiling.rst
> >>> index b241450394df..63b668466342 100644
> >>> --- a/Documentation/mm/allocation-profiling.rst
> >>> +++ b/Documentation/mm/allocation-profiling.rst
> >>> @@ -149,6 +149,26 @@ expose the full call stack and the lifetime of i=
ndividual allocations:
> >>>   - slab and percpu: the address of the object's `codetag_ref`
> >>>   - page allocator: the `struct page` pointer of the head page
> >>>
> >>> +Events are only emitted for tags that have tracing turned on and whi=
le profiling
> >>> +is enabled. When no tag is traced, the hooks are behind a static bra=
nch.
> >>> +
> >>> +Enabling Tracing
> >>> +----------------
> >>> +
> >>> +Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE=
_TRACE`
> >>> +ioctl on `/proc/allocinfo`. It takes the same filter as used by
> >>> +`ALLOCINFO_IOC_GET_AT`; an empty mask selects all tags. Size limits =
in the
> >>> +filter are checked once, against the tag's size at the time of the c=
all. Tags
> >>> +already in the requested state are skipped and a -ENOENT is returned=
 if no
> >>> +tag matched.
> >>> +
> >>> +Tracing is turned off for a module's tags when the module is unloade=
d.
> >>> +
> >>> +Memory allocated before a tag was enabled has no alloc event but wil=
l still
> >>> +produce a free event. Likewise, memory alive when tag is disabled wi=
ll not
> >>> +produce a free event. Tools should expect unmatched frees after enab=
ling and
> >>> +missing frees after disabling.
> >>> +
> >>>   Correlating the events
> >>>   ----------------------
> >>>
> >>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >>> index 49825177d8c8..94697b28053a 100644
> >>> --- a/include/linux/alloc_tag.h
> >>> +++ b/include/linux/alloc_tag.h
> >>> @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(v=
oid)
> >>>                                   &mem_alloc_profiling_key);
> >>>   }
> >>>
> >>> -static inline bool alloc_tag_trace_enabled(void)
> >>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> >>>   {
> >>> -     return static_branch_unlikely(&alloc_tag_trace_key);
> >>> +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> >>> +}
> >>> +
> >>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> >>> +{
> >>> +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE=
);
> >>> +}
> >>> +
> >>> +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> >>> +{
> >>> +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> >>> +}
> >>> +
> >>> +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> >>> +{
> >>> +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> >>> +}
> >>> +
> >>> +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
> >>> +{
> >>> +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
> >>> +}
> >>> +
> >>> +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *t=
ag)
> >>> +{
> >>> +     if (static_branch_unlikely(&alloc_tag_trace_key))
> >>> +             return tag && alloc_tag_is_traced(tag);
> >>> +     return false;
> >>>   }
> >>>
> >>>   void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *t=
ag,
> >>> @@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_tag *tag)=
;
> >>>
> >>>   static __always_inline void alloc_tag_trace_hit(struct alloc_tag *t=
ag)
> >>>   {
> >>> -     if (alloc_tag_trace_enabled())
> >>> +     if (alloc_tag_trace_enabled(tag))
> >>>                __alloc_tag_trace_hit(tag);
> >>>   }
> >>>
> >>> @@ -225,7 +252,7 @@ static inline void alloc_tag_add(union codetag_re=
f *ref, struct alloc_tag *tag,
> >>>        if (likely(alloc_tag_ref_set(ref, tag))) {
> >>>                this_cpu_add(tag->counters->bytes, bytes);
> >>>
> >>> -             if (alloc_tag_trace_enabled())
> >>> +             if (alloc_tag_trace_enabled(tag))
> >>>                        /* Trace successful allocs with their unique p=
tr */
> >>>                        alloc_tag_trace_mem_alloc(ptr, tag, bytes);
> >>>        }
> >>> @@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union codetag_=
ref *ref, size_t bytes, const voi
> >>>        this_cpu_sub(tag->counters->bytes, bytes);
> >>>        this_cpu_dec(tag->counters->calls);
> >>>
> >>> -     if (alloc_tag_trace_enabled())
> >>> +     if (alloc_tag_trace_enabled(tag))
> >>>                /* Trace frees with their unique ptr */
> >>>                alloc_tag_trace_mem_free(ptr, tag, bytes);
> >>>
> >>>        ref->ct =3D NULL;
> >>>   }
> >>>
> >>> -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> >>> -{
> >>> -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> >>> -}
> >>> -
> >>> -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> >>> -{
> >>> -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> >>> -}
> >>> -
> >>>   #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> >>>
> >>>   #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> >>> index a25a085c2df1..f728295d50c0 100644
> >>> --- a/include/linux/codetag.h
> >>> +++ b/include/linux/codetag.h
> >>> @@ -18,6 +18,7 @@ struct module;
> >>>
> >>>   /* codetag flags */
> >>>   #define CODETAG_FLAG_INACCURATE      (1 << 0)
> >>> +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> >>>
> >>>   /*
> >>>    * An instance of this structure is created in a special ELF sectio=
n at every
> >>> @@ -25,7 +26,7 @@ struct module;
> >>>    * an array of these.
> >>>    */
> >>>   struct codetag {
> >>> -     unsigned int flags;
> >>> +     atomic_t flags;
> >>>        unsigned int lineno;
> >>>        const char *modname;
> >>>        const char *function;
> >>> @@ -71,7 +72,7 @@ struct codetag_iterator {
> >>>        .function       =3D __func__,                     \
> >>>        .filename       =3D __FILE__,                     \
> >>>        .lineno         =3D __LINE__,                     \
> >>> -     .flags          =3D 0,                            \
> >>> +     .flags          =3D ATOMIC_INIT(0),               \
> >>>   }
> >>>
> >>>   void codetag_lock_module_list(struct codetag_type *cttype);
> >>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/allo=
c_tag.h
> >>> index 7d4618bea043..dafcba2f7e2c 100644
> >>> --- a/include/uapi/linux/alloc_tag.h
> >>> +++ b/include/uapi/linux/alloc_tag.h
> >>> @@ -85,9 +85,20 @@ struct allocinfo_get_at {
> >>>        struct allocinfo_tag_data data;
> >>>   };
> >>>
> >>> +struct allocinfo_toggle_traces {
> >>> +     /* inputs */
> >>> +     /*
> >>> +      * Tags matching the filter are toggled; an empty mask selects =
all tags.
> >>> +      * Size criteria are checked once, against the tag's size at ca=
ll time.
> >>> +      */
> >>> +     struct allocinfo_filter filter;
> >>> +     __u64 enable;
> >>> +};
> >>> +
> >>>   #define _ALLOCINFO_IOC_CONTENT_ID    0
> >>>   #define _ALLOCINFO_IOC_GET_AT                1
> >>>   #define _ALLOCINFO_IOC_GET_NEXT              2
> >>> +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> >>>
> >>>   #define ALLOCINFO_IOC_BASE           0xA6
> >>>   #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLO=
CINFO_IOC_CONTENT_ID,     \
> >>> @@ -96,5 +107,7 @@ struct allocinfo_get_at {
> >>>                                              struct allocinfo_get_at)
> >>>   #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BAS=
E, _ALLOCINFO_IOC_GET_NEXT,       \
> >>>                                             struct allocinfo_tag_data=
)
> >>> +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _ALLOC=
INFO_IOC_TOGGLE_TRACE,   \
> >>> +                                         struct allocinfo_toggle_tra=
ces)
> >>>
> >>>   #endif /* _UAPI_ALLOC_TAG_H */
> >>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >>> index ca2412a67312..262f00f2bba9 100644
> >>> --- a/mm/alloc_tag.c
> >>> +++ b/mm/alloc_tag.c
> >>> @@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> >>>   DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> >>>   EXPORT_SYMBOL(alloc_tag_trace_key);
> >>>
> >>> +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> >>> +
> >>> +/*
> >>> + * As `codetag_lock_module_list` is a read lock, we need an addition=
al mutex
> >>> + * to protect against the race conditions involved in the alloc tag =
trace
> >>> + * toggle path.
> >>> + */
> >>> +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> >>> +
> >>>   struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> >>>   unsigned long alloc_tag_ref_mask;
> >>>   int alloc_tag_ref_offs;
> >>> @@ -296,7 +305,7 @@ static bool matches_filter(struct codetag *ct, st=
ruct allocinfo_filter *filter,
> >>>                return false;
> >>>
> >>>        if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> >>> -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> >>> +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_tag(=
ct));
> >>>                if (inaccurate !=3D !!(filter->inaccurate))
> >>>                        return false;
> >>>        }
> >>> @@ -317,6 +326,23 @@ static bool matches_filter(struct codetag *ct, s=
truct allocinfo_filter *filter,
> >>>        return true;
> >>>   }
> >>>
> >>> +/*
> >>> + * Checks that a user supplied filter only uses known fields and tha=
t its size
> >>> + * range, if any, is not inverted.
> >>> + */
> >>> +static bool allocinfo_filter_valid(const struct allocinfo_filter *fi=
lter)
> >>> +{
> >>> +     if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
> >>> +             return false;
> >>> +
> >>> +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> >>> +         (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> >>> +         filter->min_size > filter->max_size)
> >>> +             return false;
> >>> +
> >>> +     return true;
> >>> +}
> >>> +
> >>>   /*
> >>>    * Seeks the ioctl iterator to the specified 0-indexed tag position=
, reads its
> >>>    * profiling data and returns it to userspace.
> >>> @@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct seq_fil=
e *m, void __user *arg)
> >>>        if (copy_from_user(&params, arg, sizeof(params)))
> >>>                return -EFAULT;
> >>>
> >>> -     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> >>> -             return -EINVAL;
> >>> -
> >>> -     if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> >>> -         (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> >>> -         params.filter.min_size > params.filter.max_size)
> >>> +     if (!allocinfo_filter_valid(&params.filter))
> >>>                return -EINVAL;
> >>>
> >>>        priv =3D m->private;
> >>> @@ -443,6 +464,75 @@ static int allocinfo_ioctl_get_next(struct seq_f=
ile *m, void __user *arg)
> >>>        return ret;
> >>>   }
> >>>
> >>> +static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enabl=
e)
> >>> +{
> >>> +     if (enable) {
> >>> +             if (alloc_tag_is_traced(tag))
> >>> +                     return;
> >>> +
> >>> +             alloc_tag_set_traced(tag);
> >>> +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> >>> +                     static_branch_enable(&alloc_tag_trace_key);
> >>> +     } else {
> >>> +             if (!alloc_tag_is_traced(tag))
> >>> +                     return;
> >>> +
> >>> +             alloc_tag_clear_traced(tag);
> >>> +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> >>> +                     static_branch_disable(&alloc_tag_trace_key);
> >>> +     }
> >>> +}
> >>> +
> >>> +/*
> >>> + * Toggles tracing on every allocation tag that matches the user sup=
plied
> >>> + * filter. An empty filter mask selects all tags, same as for
> >>> + * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not=
 an error.
> >>> + */
> >>> +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __u=
ser *arg)
> >>> +{
> >>> +     struct allocinfo_toggle_traces params;
> >>> +     struct codetag_iterator iter;
> >>> +     struct codetag *ct;
> >>> +     struct alloc_tag_counters counters;
> >>> +     bool fetched_counters;
> >>> +     int matches =3D 0, ret;

One variable definition per line please.

> >>> +
> >>> +     if (!capable(CAP_SYS_ADMIN))

This CAP_SYS_ADMIN requirement should be documented.

> >>> +             return -EPERM;
> >>> +
> >>> +     if (copy_from_user(&params, arg, sizeof(params)))
> >>> +             return -EFAULT;
> >>> +
> >>> +     if (!allocinfo_filter_valid(&params.filter))
> >>> +             return -EINVAL;
> >>> +
> >>> +     codetag_lock_module_list(alloc_tag_cttype);
> >>> +
> >>> +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >>> +
> >>> +     /* Toggle tracing on all codetags that match */
> >>> +     while ((ct =3D codetag_next_ct(&iter))) {
> >>> +             fetched_counters =3D false;
> >>> +             if (matches_filter(ct, &params.filter, &counters, &fetc=
hed_counters)) {
> >>> +                     matches++;
> >>> +
> >>> +                     mutex_lock(&alloc_tag_trace_mutex);
> >> Could we grab and drop alloc_tag_trace_mutex outside the loop?
> > Well, that is possible. But I did it this way to minimize the critical =
section.
> >
> > Since this mutex is specific to the trace ioctl, I'm comfortable doing
> > what you recommended too. It would just mean that one thread would be
> > blocked until another thread fully finishes its loop, which is not too
> > bad. I'll let Suren comment on this as well.
>
>
> Hmm, sorry, I misread this part of the code. (sorry for this) . Putting
> |mutex_lock| outside the loop is not a good idea.
>
> It greatly increases the critical section.
>
> My original concern was that we need to mutex_lock and mutex_unlock
> every time we get a match.
>
> As the function comment states, An empty filter mask selects all tags,
> that means we need a
>
> mutex_lock / mutex_unlock for every alloc_tag.
>
> Let's see what Suren thinks.

I think doing mutex_lock / mutex_unlock outside of this loop would
yield more predictable results. If you consider two threads executing
this operation concurrently with different filters (one enabling
tracing and another one disabling it) and preempting each other, the
final result might be non-deterministic (will depend on how these
threads preempt each other while they execute this loop). Locking
outside of the loop makes this case more deterministic. It will run
one of the operations completely and then the other one without
interleaving them.


>
>
> Thanks
>
> Best Regards
>
> Hao
>
> >>
> >>> +                     alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!p=
arams.enable);
> >>> +                     mutex_unlock(&alloc_tag_trace_mutex);
> >>> +             }
> >>> +     }
> >>> +
> >>> +     if (matches =3D=3D 0)
> >>> +             /* Nothing matched the filter */
> >>> +             ret =3D -ENOENT;
> >>> +     else
> >>> +             ret =3D 0;
> >>> +
> >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>>   /*
> >>>    * Entry point ioctl function for /proc/allocinfo routing requests =
to fetch the
> >>>    * layout content ID, seek to a specific tag, or read sequential ta=
gs.
> >>> @@ -463,6 +553,9 @@ static long allocinfo_ioctl(struct file *file, un=
signed int cmd,
> >>>        case ALLOCINFO_IOC_GET_NEXT:
> >>>                ret =3D allocinfo_ioctl_get_next(file->private_data, a=
rg);
> >>>                break;
> >>> +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> >>> +             ret =3D allocinfo_ioctl_toggle_trace(file->private_data=
, arg);
> >>> +             break;
> >>>        default:
> >>>                ret =3D -ENOIOCTLCMD;
> >>>                break;
> >>> @@ -492,8 +585,6 @@ static const struct proc_ops allocinfo_proc_ops =
=3D {
> >>>
> >>>   void __alloc_tag_trace_hit(struct alloc_tag *tag)
> >>>   {
> >>> -     if (unlikely(!tag))
> >>> -             return;
> >>>        trace_alloc_tag_hit(tag);
> >>>   }
> >>>   EXPORT_SYMBOL(__alloc_tag_trace_hit);
> >>> @@ -1031,6 +1122,24 @@ static int load_module(struct module *mod, str=
uct codetag *start, struct codetag
> >>>        return 0;
> >>>   }
> >>>
> >>> +static void unload_module(struct module *mod, struct codetag *start,=
 struct codetag *stop)
> >>> +{
> >>> +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> >>> +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> >>> +     struct alloc_tag *tag;
> >>> +
> >>> +     /*
> >>> +      * Turn tracing off for the tags of the module being unloaded. =
Without
> >>> +      * this, `alloc_tag_trace_cnt` would never reach zero and traci=
ng would
> >>> +      * stay enabled forever.
> >>> +      *
> >>> +      * `alloc_tag_trace_mutex` is not needed here as this code path=
 is
> >>> +      * protected by a `down_write(&cttype->mod_lock)`.
> >>> +      */
> >>> +     for (tag =3D start_tag; tag < stop_tag; tag++)
> >>> +             alloc_tag_trace_toggle(tag, false);
> >>> +}
> >>> +
> >>>   static void replace_module(struct module *mod, struct module *new_m=
od)
> >>>   {
> >>>        MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> >>> @@ -1357,6 +1466,7 @@ static int __init alloc_tag_init(void)
> >>>                .alloc_section_mem      =3D reserve_module_tags,
> >>>                .free_section_mem       =3D release_module_tags,
> >>>                .module_load            =3D load_module,
> >>> +             .module_unload          =3D unload_module,
> >>>                .module_replaced        =3D replace_module,
> >>>   #endif
> >>>        };

