Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFD4CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728986B00A0; Tue, 26 Aug 2025 07:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAC96B00A1; Tue, 26 Aug 2025 07:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572436B00A2; Tue, 26 Aug 2025 07:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F95B6B00A0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:01:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8C355B186
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:01:43 +0000 (UTC)
X-FDA: 83818618086.05.DE188F0
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18AD9A0004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:01:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2jDTKlLl;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756206102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7NeKTyWKueL+wvA2d/ehbUAGIe9IQuhF4UrqPvxaVg=;
	b=dI0ra8BdT7gbB1lkFePgg1b1uz025jSSmN55MwJyozDKSgfGB7DPaD0tFmu6tPxSzfGAPS
	KE+k5U1Hc8bLwcit5/sSvYdbohBMdVcpWtdUWD+Vuds4Lot81pN3XItweT07iV4JAD+dl1
	IYbop4QYZHnA3VQcrzmhGzQU3IyQ6S4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756206102; a=rsa-sha256;
	cv=none;
	b=ML3GlEeSLmvJ4F9x+BBoM5JaeVXgsnZc3aKpGKcERRdaMN764UeS2MGsuTjEwulqo5nuBY
	r+tfUMKa95vKV2C5Dzr0onm9bVLvXjXGcieVxpzzHmuorQuEeRZFmnImSZNBrILohj3r2l
	DQ2Zz3J8Z0j1Q2+nPo6bp0BDX9cxtlk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2jDTKlLl;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-246aef91e57so31467075ad.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756206101; x=1756810901; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O7NeKTyWKueL+wvA2d/ehbUAGIe9IQuhF4UrqPvxaVg=;
        b=2jDTKlLlKgLbUQyJA/J05QLIk24qVnK+LB3azYhix7GR/UySTCcYiyTxcJcJzq8MgZ
         S1gBfQW1tzr0iAt127Mf1FQRLnKAJXjN5fOpP9fmtbV2c2GtYH6oWZ/RcEsCJwN5rgN7
         8n0+0VsqmGRJFswbKy4cvBgmoeLS6sROCqoZ/eSUxB9D6yhwDZVFlATKcHxPicUTv1QK
         aeaisIQPAOyyM9Z0LHMaCxhyWDjcyBWbAHE3qS6PaC8pgv7fsKQxp9tVEv9iDNBN+WuJ
         SHMKiXv2aG9J5XLAkmrEw8BRWty8Hr1tZ44uwpNUE1muBZbw5PAa67pEHLsTDI4+cxO/
         ZhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756206101; x=1756810901;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O7NeKTyWKueL+wvA2d/ehbUAGIe9IQuhF4UrqPvxaVg=;
        b=qTO3MJj3tScwM4tljL2ITiqj9SFbtC6Tyg5Q+3d9ZsLJbDJSKrJWboO97RP2KP3kwx
         kTkOAVNP2rsShY50dRnGBtfFrV7dGHsuM273S6hW8QibsKJxmI+WA08meoOcca0mEp5M
         SkdlNzyxdHPGo+G5DOKX5XR8IToWKKv3hsRAj+meap9+1v7Fg5N/8qgZn+oRj1BtJPjm
         8P4FuMKOIydSopFvpnhIQ/9Op2VXb2hS48kSa9kko9Oai3GCDh7eLgqC3rE84Fsrepjx
         UtqesVD7zpu/wPv6I/Wnr+rkh5ZWM+YpECSEaOt9XAMaxBDszNG5OgexqRa1W8YrPtK4
         gsUA==
X-Forwarded-Encrypted: i=1; AJvYcCXdEt3pqwzQ05ozso7tXVjXmw9jzOjX5m/f0t5NMKC5pHTUc86rKZyjUkYM2oWNr9Du6VYTMCyA5g==@kvack.org
X-Gm-Message-State: AOJu0YyFXLrMc3v3CXTfATEK1cC6pW5ubttuzkym6u56QVfQ62Dh7UMN
	29/ZaMYJxOaaVX80TloLCGwIxtEIHjlwPjPUGUwGZ9gH6M8Hl4ULmLA1uJjNBaApHtU8MVedo5n
	vTPE/Ej0z0g/4ybbGtvcTTjlu6dQmyvBXA+XlmbSU
X-Gm-Gg: ASbGncv1XN2TbC4D3tTbpXMDWGVguv/bc/5b6ynWej1tGnswqj8Rf8GL1qFg1CWz3Uc
	3DN45Bi7wk4CXngof33/C9YaFWEPXDx/APRfSl4c5GcgjRd5msJXNqCfDSIiKFcWwbgYW8rH5fB
	Kd/UPbL8AN7B0rrEetQoZbTqighKv+WpZRe8epGpPBFQXWS4JS98OBSXXF2gEvvI0MiWwmG0rfy
	yLdqIPQLGdOYqMK
X-Google-Smtp-Source: AGHT+IEbRYts5Q2lruIn6/nB+O/HdMCkYF/AkmdpLyFbfgBNrhZYvvCShyGMbpT48VX2Q32imRPFKl5g6OIxfhSyNvg=
X-Received: by 2002:a17:903:240c:b0:246:cb50:f42f with SMTP id
 d9443c01a7336-246cb50fe74mr114988865ad.19.1756206100525; Tue, 26 Aug 2025
 04:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250825154505.1558444-1-elver@google.com> <97dca868-dc8a-422a-aa47-ce2bb739e640@huawei.com>
In-Reply-To: <97dca868-dc8a-422a-aa47-ce2bb739e640@huawei.com>
From: Marco Elver <elver@google.com>
Date: Tue, 26 Aug 2025 13:01:03 +0200
X-Gm-Features: Ac12FXxae71NaV6L-XhwcBeMdDL6EXr8UiNrPYGSHEYHL3QrAfVUO23SnPsEAGQ
Message-ID: <CANpmjNMkU1gaKEa_QAb0Zc+h3P=Yviwr7j0vSuZgv8NHfDbw_A@mail.gmail.com>
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: GONG Ruiqi <gongruiqi1@huawei.com>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@redhat.com>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Florent Revest <revest@google.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18AD9A0004
X-Stat-Signature: keqf3gospt1ti4mtkatj3uou9ar96nsp
X-Rspam-User: 
X-HE-Tag: 1756206101-376293
X-HE-Meta: U2FsdGVkX1+ZcRQCnlESboTaUoxME5AUZYcOrT8XEBT5At174ixA/Fm41dfu7/Dmpd7dr1BTtyADylV1987rCfK39AHWpgPaMoJh5aLz4lOivR6EhoVE86R8L/nk+cM5diuRbz1Nph9H9qYLaoNoNFBoZG3crfublJMEETrMA/L8lz/+zO0pQebo+F2ZC6Qbm8A2uGPKwFroCrMYisNw3j5JjJxBipVz6T/7KpHOra0oggVZGPDL6cl+LEp94KKbo33iJIjfzKYk3l1fdEy96t2ZYKGqNM9HBCeEUQMSJM6322bE7jB3NEXKEDnp4KPbmXbvRoXCD3peNWetSWKMdnt5tZAm/YqWNqUf76CelWQX/jXLO8kf/6R5K5SNvPcNH37LlP8ZuPytptk69BmzMzMFKFzclun0A0UI0tsOq99dn/A5JtZFB91g0/cj/iQBGGeFsPhXKGpQ+6fM+gZjJ78IiQr1J8VH573qHiGJjLqkHM/Delr2dNgsWC01NE36rxWAGI1CnQdxL+wU/5px4xzO8iIS6+bTe6xpMzorWN2rL5RddZMvdodNEksaxRsZp/xVYqZlXFRjKkBNpm+9ukxDAe1r2P7EunAKVHhER8YSg8MPKB8ceF7+RAHjLrNIg/sjovUdGQxLZY9fNWCuciD9/YWTaTC0ht9jfxvQzjzRRvnBJ6t8VZd6FNnZFxPjjNMBArGRWLDIm/QgVVTIMwcyyGjl5AYJuZP6d7oE8nCGEntS+OrXZI4LQtMvj+h7ESMucLwFTHjmpIScJFqyWWkELHFSmAfEajjjdb8bNvacIioUBCBs/4FCkMpGfo2DgShg3am4SEsP1znLUqLMgUWHMKMPcxOtnzObLiAWF1WeEk4EuY+ksgEkKku5zBJGnlMOujWieTP+OxKly2evONeptnAvt05yO1AaApOhbtK1yxx7/QLPeuHXsYa2fY5a20IbWmWaPWVfk+EZLlR
 d3OqH6/7
 pHjWRjjDsF+RHvOEOMHhcdKLZmdw8fB3WYBNS1wJ599Zr59gxu/QwqqOgi56fBy7ud6hLOY8D/XQ6slNCgWxSAxNFgb5EYdEbtuO+uek9QWXexgatNjpJG+LMsbrMrOUMtPPe9N2WDZkDFYlRmZYXAt83WRudwQYXzm2tjxUypK15mivkDNatK76kRB2E+YgZAIvA9Zby8eBDr602ZjXPzD9OaenfHeT8un/T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 at 06:59, GONG Ruiqi <gongruiqi1@huawei.com> wrote:
> On 8/25/2025 11:44 PM, Marco Elver wrote:
> > ...
> >
> > Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
> > "allocation tokens" via __builtin_alloc_token_infer [1].
> >
> > This mechanism allows the compiler to pass a token ID derived from the
> > allocation's type to the allocator. The compiler performs best-effort
> > type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
> > Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
> > cache to an allocation of type T, regardless of allocation site.
> >
> > Clang's default token ID calculation is described as [1]:
> >
> >    TypeHashPointerSplit: This mode assigns a token ID based on the hash
> >    of the allocated type's name, where the top half ID-space is reserved
> >    for types that contain pointers and the bottom half for types that do
> >    not contain pointers.
>
> Is a type's token id always the same across different builds? Or somehow
> predictable? If so, the attacker could probably find out all types that
> end up with the same id, and use some of them to exploit the buggy one.

Yes, it's meant to be deterministic and predictable. I guess this is
the same question regarding randomness, for which it's unclear if it
strengthens or weakens the mitigation. As I wrote elsewhere:

> Irrespective of the top/bottom split, one of the key properties to
> retain is that allocations of type T are predictably assigned a slab
> cache. This means that even if a pointer-containing object of type T
> is vulnerable, yet the pointer within T is useless for exploitation,
> the difficulty of getting to a sensitive object S is still increased
> by the fact that S is unlikely to be co-located. If we were to
> introduce more randomness, we increase the probability that S will be
> co-located with T, which is counter-intuitive to me.

I think we can reason either way, and I grant you this is rather ambiguous.

But the definitive point that was made to me from various security
researchers that inspired this technique is that the most useful thing
we can do is separate pointer-containing objects from
non-pointer-containing objects (in absence of slab per type, which is
likely too costly in the common case).

