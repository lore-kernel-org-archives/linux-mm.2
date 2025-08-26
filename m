Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F198CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57D16B01F1; Tue, 26 Aug 2025 07:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08DA6B01F2; Tue, 26 Aug 2025 07:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7916B01F3; Tue, 26 Aug 2025 07:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B826B01F1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:32:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D4F31A0795
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:32:09 +0000 (UTC)
X-FDA: 83818694778.22.8C1B4CB
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 58E7780004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:32:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W/ln3ogt";
	spf=pass (imf30.hostedemail.com: domain of revest@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=revest@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756207927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgjl982rkJtQB6+NNyAU1pdVTWqd4G+6D2+THSotuPo=;
	b=WPqwrMDugbS+61b84gJUGG/uhnvnKjtPKX2f2CVctewbhBZAR4PSHWlVIgvEC5Jstlj02I
	4Vztdl6ZQIZoNmnZjt7O432pcXI7/n9bNNoh6h2IIO7f1n7Eg9F0H5ZHf0yW4N1wRbrvMv
	tTe+JLiJ6jIFOAexCz3k319mx5t2aJM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W/ln3ogt";
	spf=pass (imf30.hostedemail.com: domain of revest@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=revest@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756207927; a=rsa-sha256;
	cv=none;
	b=iN4L/VDWQNYHwHWTrAckZpkfNVibJ4c7xB+iugapDqBCOsMmNAv+HhiIAjkxtIpskdr91j
	ZwA6ltKbZJH8D8ikbtE1r1bQMAzLkRnHbxRXBCUYV+F+Dm83GtYllwiJy8y6BMPA4nzr8l
	dfaaqa3kUW2Zi91LTDvzsBCIOizpEqk=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b29b714f8cso283341cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756207926; x=1756812726; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgjl982rkJtQB6+NNyAU1pdVTWqd4G+6D2+THSotuPo=;
        b=W/ln3ogtfKT+HQei8yoLPEBV0rd0NfjzdXNSLtjK+zFuAWIorWOduXw9I5UFF5GcSC
         bRem91MzHn+iNLxGofN7C5+FbgHJSCF8x/vlmuHKKluj19ikiRf07AUEnFq8VSnuKORt
         1ZMDIL5UtXlC5QzeGmzSFt4ZPpL0rP5cm4wBXqTtBoiAfqRYrCcqOIQABtQjp6KOP8Gv
         XjkSgz8mWvCW/BjZtdoYL+Ao6H2vFDhQCl1bj8xKwUnHD4ahZBre7v4inteeMOYht4o/
         pmUU+E20dCG3Sp4xcbP3EXz2kFUxxBxm15hukw6cTGM32HLyXDfvLzLETAZ5UYf0bfMP
         NhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756207926; x=1756812726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgjl982rkJtQB6+NNyAU1pdVTWqd4G+6D2+THSotuPo=;
        b=NP4tSLzNiZfgrfDUNJPn5Ad0FIUy5mMpRdSUAusrx2qgxNYRDxcVmJOEdth3dqbbz9
         NVGgJ815zgIZphSS3aCa7iiUqijG/z3ZWMVIvEiCUoFShwOK9HZ34oLyAgIshQnnCXPc
         9cBV4wm5L7rGZpDAygCn2CNqwV1TNvGLeJAV3hH1deZ74OOzrhiBYFRK4qA4u9ajE6Hx
         eUq7I3FrstroG0AJZcLG1ZcLDmRFDoIc5UTQWi51lhx1tk2uur/7jMlO36FNnN0gcq/1
         x0L6VDVW03oN1MIh48M6krUH4jB+IxN7vqjMnx7TR443QBlgs8Bg9FHg7JIfGhpDajZQ
         Gm2g==
X-Forwarded-Encrypted: i=1; AJvYcCXtraCVwl6oDnqbx/fUhXAz2lQnpYJUltkUf1mEvbVWrSNTVVhN1g6+bcLqWDnsRuWGHs4n1dOD3w==@kvack.org
X-Gm-Message-State: AOJu0YwPjX3NtZwqjPULrQNXlnGA/nVLFTI28PKjgMayaUf/USm1fM2A
	Snwf+BzzKHFGd7ZY6d2ERpet6O3BRE75jKLiODzBN8TGBEiqLU4AeXeYRcsBxH8dZYxSy+fTnAU
	IEtq8gFwt5S5gtB6LQtMXOSgBBvzz9RVN5gkBxu+J
X-Gm-Gg: ASbGncvi//gStibVt7zK/5obG1GgfHaxkcPULqhOeYx29YRg0Q19FKTspfZNVCkTokH
	EayBakWg8XQue05Y7w07rLTz1imAM33M+Obd2r8J2N+LgZqdiMBGh4QA3pTEcr7HbII48TzrQhJ
	CXEm5Wo3bfFzm6Z4Qo6YzkoA0USRaiysWbs4gGjzFXm1x3UbGGesxvVD/YtZSOmynfljBB4mhKG
	c9QpGVDX/D69RVH3JS5K707sqFhiqH4qtsuDNptc7gzIdyq0Itm
X-Google-Smtp-Source: AGHT+IGIz0mfW/fdkVWrjqbaGzyt0+u7lbrcXJ+ddXu1DMsEf+ZPQnDOwsfrPc/mjKQ0Duj1yOEjprGa5se2wOTyim8=
X-Received: by 2002:a05:622a:148b:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4b2e2c1e0cdmr4401241cf.7.1756207925975; Tue, 26 Aug 2025
 04:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250825154505.1558444-1-elver@google.com> <97dca868-dc8a-422a-aa47-ce2bb739e640@huawei.com>
 <CANpmjNMkU1gaKEa_QAb0Zc+h3P=Yviwr7j0vSuZgv8NHfDbw_A@mail.gmail.com>
In-Reply-To: <CANpmjNMkU1gaKEa_QAb0Zc+h3P=Yviwr7j0vSuZgv8NHfDbw_A@mail.gmail.com>
From: Florent Revest <revest@google.com>
Date: Tue, 26 Aug 2025 13:31:54 +0200
X-Gm-Features: Ac12FXzALeR2tDEEna1F4OrekZEDGHVi9TgPcdxl6W-rTLz9deGbqXZWqVvOe9c
Message-ID: <CALGbS4U6fox7SwmdHfDuawmOWfQeQsxtA1X_VqRxTHpSs-sBYw@mail.gmail.com>
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Marco Elver <elver@google.com>
Cc: GONG Ruiqi <gongruiqi1@huawei.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrey Konovalov <andreyknvl@gmail.com>, 
	David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xsuo4h5xxf4r6r3bimi1budysw1hwwno
X-Rspam-User: 
X-Rspamd-Queue-Id: 58E7780004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756207927-74764
X-HE-Meta: U2FsdGVkX19k3Z6JlE17sFhoK1H74bB3g7C/3/yQsL0zaRsOmyicmlHX1KR4q0slugExDopw/X9FW8EIM7YU+y5JNlQoXaqgka+XMngC/Y/xgSIEe6QBKmdbAAL5na2Vopak69oohVDhRB7PN3DoWsandrQ+rdH2MRwPuGgrRUcg7LFhyvC8JUEIw3pUtA41sTgraq0i30o2Gryw3ENPPdkJbzQQUf3csbrl9y7VQixJ4yxENLC5sNjxBOMm/WyAWSWMNPphrUB4GUHX+G6BxvqRbbrboqc9zixfUf1JC0QMT7p6aZ94hujjuZ+whxtf4MEWNrXgqlNswLBqZ93RhARHsJ2p01WF2EPaW/C6QmQeXvuP3rU0a96RbO3xBB3hFOLMTGdxRmispuB/N7+99jRD6310CbWNSshmB9IxmOsq3cogDnqpLKqSrODzv8OjWZ/zJNvaO/wBvOomRX3ucbptythoftu9iG8GZsLIx+AF2PCzDK16rfTRn6SmxORW5gse/pftaw1N9IY7nBEA/dIdOCvH+m271w6v8+7l9iruwvoT+hsYxZK4TskZMJbR+LJwYZsrxCzSnJGoqMpJ8DoTOb3GrhdD/l2TkxHSRkD2TyAwjAe9+woE29JlaArJ7tSun0KtUkIeeEmgdzbYUbEONijXMwBOmvTlE20UcXRVO3F3xyTnjBvdbJ70pGYJZgxAGioLZ28BClmG6EbKYdA5FxLBrnQvBO5WwFVygYvO/ARxmsswbPSsU4vvfSe6D8Wec6sx28N/JNotTp2ZFrbtmro3hucJoUJfwbjNP0XlLyyyGBWUgbIVm2/nkZFpzmWkd1XCdeCypDmi/gunIwgPgiCxsXVeXifteVZlC1rUciQ3ERiU32E9kCmQ2OjRplfeRx9rzKqiPTP5thXJmbAh9d/SD9SXE0tpEzmiG2O8Ttts12qlU9x9jf7b91Fc4GFdu+BsLxjLeJbzlh7
 zYZ8cEBY
 /HFSc1ObdptJBuL+lcUEQh+Ti9urvzg4F1oXzfB4sK9f9vkMS1l67rGkx+2azmbRXt235Bg53R9QryBGYCJqkdPxTl3sg8F4Yw+cPdkstz2bQq2vYdR7FNSAJOEHrXuYCBvlZ91c21F0SEy6fuvJs04eUr7iarokxgcsjPAhBd9WMZhogDNYoCF1/jmqowhkJ51vuIS6edJh/wWY8Nv+UpQTgbAfPUz5Axk5Cd09EOPKB9SaqHPyGJMUqgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 1:01=E2=80=AFPM Marco Elver <elver@google.com> wrot=
e:
>
> On Tue, 26 Aug 2025 at 06:59, GONG Ruiqi <gongruiqi1@huawei.com> wrote:
> > On 8/25/2025 11:44 PM, Marco Elver wrote:
> > > ...
> > >
> > > Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
> > > "allocation tokens" via __builtin_alloc_token_infer [1].
> > >
> > > This mechanism allows the compiler to pass a token ID derived from th=
e
> > > allocation's type to the allocator. The compiler performs best-effort
> > > type inference, and recognizes idioms such as kmalloc(sizeof(T), ...)=
.
> > > Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a s=
lab
> > > cache to an allocation of type T, regardless of allocation site.
> > >
> > > Clang's default token ID calculation is described as [1]:
> > >
> > >    TypeHashPointerSplit: This mode assigns a token ID based on the ha=
sh
> > >    of the allocated type's name, where the top half ID-space is reser=
ved
> > >    for types that contain pointers and the bottom half for types that=
 do
> > >    not contain pointers.
> >
> > Is a type's token id always the same across different builds? Or someho=
w
> > predictable? If so, the attacker could probably find out all types that
> > end up with the same id, and use some of them to exploit the buggy one.
>
> Yes, it's meant to be deterministic and predictable. I guess this is
> the same question regarding randomness, for which it's unclear if it
> strengthens or weakens the mitigation. As I wrote elsewhere:
>
> > Irrespective of the top/bottom split, one of the key properties to
> > retain is that allocations of type T are predictably assigned a slab
> > cache. This means that even if a pointer-containing object of type T
> > is vulnerable, yet the pointer within T is useless for exploitation,
> > the difficulty of getting to a sensitive object S is still increased
> > by the fact that S is unlikely to be co-located. If we were to
> > introduce more randomness, we increase the probability that S will be
> > co-located with T, which is counter-intuitive to me.
>
> I think we can reason either way, and I grant you this is rather ambiguou=
s.
>
> But the definitive point that was made to me from various security
> researchers that inspired this technique is that the most useful thing
> we can do is separate pointer-containing objects from
> non-pointer-containing objects (in absence of slab per type, which is
> likely too costly in the common case).

One more perspective on this: in a data center environment, attackers
typically get a first foothold by compromising a userspace network
service. If they can do that once, they can do that a bunch of times,
and gain code execution on different machines every time.

Before trying to exploit a kernel memory corruption to elevate
privileges on a machine, they can test the SLAB properties of the
running kernel to make sure it's as they wish (eg: with timing side
channels like in the SLUBStick paper). So with RANDOM_KMALLOC_CACHES,
attackers can just keep retrying their attacks until they land on a
machine where the types T and S are collocated and only then proceed
with their exploit.

With TYPED_KMALLOC_CACHES (and with SLAB_VIRTUAL hopefully someday),
they are simply never able to cross the "objects without pointers" to
"objects with pointers" boundary which really gets in the way of many
exploitation techniques and feels at least to me like a much stronger
security boundary.

This limit of RANDOM_KMALLOC_CACHES may not be as relevant in other
deployments (eg: on a smartphone) but it makes me strongly prefer
TYPED_KMALLOC_CACHES for server use cases at least.

