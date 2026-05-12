Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25798CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7456B008C; Mon, 11 May 2026 23:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E376B0092; Mon, 11 May 2026 23:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB0B6B0093; Mon, 11 May 2026 23:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCA56B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:37:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06659A0342
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:37:32 +0000 (UTC)
X-FDA: 84757357944.11.EB8300F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 569411C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:37:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFnyuxLx;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778557050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhpZoyTJkR6+/JP8EnEKFH42CwkQneqjGA9711mBLlY=;
	b=SNW75SuLWwDTqokX6v0UiPea5n/fMqC9m/3koXoFM964EWrGtWSwhocHY0vldZASgqpBaQ
	VfG3ksPC8LPUCCFAwvkWGODxJHGBIHWXojQvD2zf8l+v/WqWNDvJ2ilCoqegbFwy9XBryF
	73uBPVmQhQ0KT4rtmuMCrbOhEe8JKTU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFnyuxLx;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778557050; a=rsa-sha256;
	cv=none;
	b=M1wNiIaeDdNqNJY7gIdNYS5fyikSRx832WUI8jOf4nZltcVaDv6npPloopOE8lZ70wSwWQ
	oNizZPpt7Czp1sjBcd/+rIOt86WDSlY4wlY7qClQ/5p1VauC/Tl8YRkG2ACFcjhuCdIFfc
	PmwVNmzsYeMCgFzyw678z5Oqmos7ZrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3742743C4A;
	Tue, 12 May 2026 03:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95198C2BCB0;
	Tue, 12 May 2026 03:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778557049;
	bh=pwneY8tqOMXV/Za/BC8NmNmIjbTm6BzCxeG9cSc4u/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CFnyuxLxWLewCmqP9tCc5Fky1tBtI6M2DzFY+XCXdM055KYVpjAXEhrZFv12K9rSX
	 vvebPC5LSDOHGqH9Ou8b7C8Re4H9WoEDHi/9t8KFdGi3S+xG3TObCkdsIhBN93Dagk
	 pwdDcXB86/Q5KOh7qMV4KCNaU2JbMgP3GPxs1mnKzGFYbR140Fzdqsm9N3KL0eIRNC
	 +eB5zuc9zgC942F+V+GICImCZ2T6vEWOC4LjMO+ur9mQ6u5ksQioBSm+cK9J4iDlfZ
	 7goNZYbpZCB18QSHEuII/i3YlMN4MzmlGxI5Fb6qXncgscqXxAqPt+lz3sGbL2NoOY
	 ojNJE6cC7UQDw==
Date: Tue, 12 May 2026 12:37:26 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <jnfrygcxgl6zbs3fifgsxh6233fr2ou7vyfs7n44xa5cf3dqqt@rhjdx5ifkdur>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
 <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
 <afz7pZADZPD4mKJr@MacBook-Air.tail10959e.ts.net>
 <af3xcFjrZSZFG846@elver.google.com>
 <rz7dt4wghum6beghfgm6suqje6jeivrensojjalfis5zeuyen7@6bj7kfpqb4q5>
 <CANpmjNNevjTo0uwo3DJdDc=PpQpyzj301kFT39OBoCNLW0A8VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNevjTo0uwo3DJdDc=PpQpyzj301kFT39OBoCNLW0A8VQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 569411C000B
X-Stat-Signature: m4nyjtkjh7hyrdip1gdpu6xpabszqghx
X-HE-Tag: 1778557050-642076
X-HE-Meta: U2FsdGVkX1+vWPJy0bGFHK49kF+2NcD8Xz+ne/L3wmUeiffmB5oP9Y2/+owpSwQAjQtXF+RZ1inHzBrDjXKkT56gfV856TnIBcot4NbGAur1SgoeISfWWFYc88R3mW7OJRqy+KrRYjZclVTrtU+T8C/+k7tfJ02gZldZ0Xw19YMmA9v4rCJF1L3pNUB+3oX1HT3eqUwQQ7P+Oh3yGkBu1ZvvRnzwFmmvqe5JyMUYCEqfFmfQMNGxPmMsDrfGR7tbHlZVkXF10FqSP4IctCOSS7w86SzuYXSiFaKJP6BC+rBaXBfPEsV2kldI6Na4yEJEPjHLqJsuRo/TtASBxTPqxb/KxJfre4pAZTyXzAq/QRHdKWE3qBHg2f08TAqf9PXE7UyRvzgdvAKu2aGfIN6Y7FhR1301ygbO53sIm47cT4Za4qPCB+A/ltaN6l3Gf8afzv+slPH9vi0JH2sj4RgMgaoII9ey1U+SZlsmWXinIFnSFTkMPewNoZSq3gsjyXPw630Hvakpv38JNQ7q96Daf+ejqZyIfeZFpa6YMAAnt5ESPDfwmds/Z3e5dSEg16LXeuJ7heG6lDrNhCK0UpJFUEi6y02Di5Z8nMwvWkpFKUxhhmBCQ7jFyA4NlQIYUjx4t+ltfJf2z4ea25syHvS+Yz5M3LPov+GrRBzlKyDfMkbewHeyuNTCab+v+c2Hbr+j03ZdKEgijJtOVUYQb12y51pvPtUM7up0E+PDA91RH05Eiu3KtN4+bDnVHz8PTwbRAA4hn312WyJnvmcuUSEuMn4tiFXs6ALt2RFQfc5NdbOv1cNNDGtqAOqXnoDytHI2YpnBlN6kQT4e/lPppIInv0I0PM6oD2sI/MqCCOWYdwYDkMBK/wNtPVBE9ELwBMFcv+oRyCBjQdWKEdVnbDTGVkavCXySnV2MNSSQ5W69Sxcv3zyP9WrFxgdtyfB3wjrf8IVrZ/ySv4K7k97NnbM
 pEEPZ4Ej
 yQRfoBEHRe8OgxnJI0lYbSZJN8Vt5X6mhsTWljv7qTQI63RfCXQ13zk3W2jvynD+lLwXr7uwWD0HYzAM1g6IvrPezGdscWtUDwyYG+19TzSP1DQ+W6WcytSE+bllgsx/iUgMjd4iQfLFPSrvL/YUp2PbCpqszHlMIpvUVNLY5zMTPMc5qQ5y0qI2cQoX1EfDqpeizCniyQHL9AN/LtjdAUXTGgolGfVfBf54NjevdM5diwRezv4DhJRff4tMD7unLhRu+otWckJk1jajYEOS7JcPOJooZtg2WDW98xoOCwzIQR86LuPr0LnE1y7oyTocpJw9zyqegpoeoGsmB97BjgGrdlZiUE92lOF7kwV9VwQ8WFQszqr8ltczETVI07X/+xCD0IcBOBsbKrwX7K9d3nkWW5BeqaCcVcZa81cmlFIsAlKtvt2w1NY87yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:34:53AM +0200, Marco Elver wrote:
> On Mon, 11 May 2026 at 10:31, 'Harry Yoo (Oracle)' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > On Fri, May 08, 2026 at 04:21:36PM +0200, Marco Elver wrote:
> > > I think I have a solution for this mess, see below.
> > >
> > > I would not send it as 1 series, but only include the slab changes (+
> > > instruction_pointer.h change to introduce _CODE_LOCATION_) as one
> > > series, to go through the slab tree. The rest of the patches would go to
> > > respective arch maintainers.
> >
> > I'm assuming this will be a follow-up and reviewing patch 1
> > (and waiting for Jon's thuoghts on patch 2)
> 
> I'll be sending v4 shortly.

Thanks!

> > > diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> > > index aa0b3ffea935..dfe73aafddb8 100644
> > > --- a/include/linux/instruction_pointer.h
> > > +++ b/include/linux/instruction_pointer.h
> > > @@ -8,6 +8,30 @@
> > >
> > >  #ifndef _THIS_IP_
> > >  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> > > +/*
> > > + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> > > + * and Clang [2]. In particular, the address of a label is only expected to be
> > > + * used with a computed goto.
> > > + *
> > > + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> > > + *   [2] https://github.com/llvm/llvm-project/issues/138272
> > > + *
> > > + * Mark it as broken, so that appropriate fallback options can be implemented
> > > + * for architectures that do not define their won _THIS_IP_.
> > > + */
> > > +#define HAS_BROKEN_THIS_IP
> > > +#endif
> >
> > As long as _THIS_IP_ is broken on some arches, it cannot be used anyway
> > when in a general API that can be used by arbitrary users?
> 
> It more or less works today, and for debugging or tracing it's "good
> enough" in most cases.
> 
> The plan would be to phase out the generic _THIS_IP_ once all
> architectures have a correct _THIS_IP_ implementation.

Ack.

> > Is it something that can be fixed in all arches over time?
> 
> Yes, I have patches for that.
> 
> > > +/*
> > > + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> > > + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> > > + * which guarantees uniqueness and resolves to a constant address at link time,
> > > + * avoiding runtime overhead and compiler optimizations breaking it.
> > > + */
> > > +#ifdef HAS_BROKEN_THIS_IP
> > > +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
> >
> > Nice!
> >
> > Yes, we don't really need the exact code location
> > for partitioning kmalloc caches.
> >
> > IIRC lockdep does a similar thing to define lock classes (unique for
> > each lock init location)
> >
> > > +#else
> > > +#define _CODE_LOCATION_ _THIS_IP_
> > >  #endif
> >
> > Probably we don't need this fallback?
> 
> x86-64 is the only arch that has working fast _THIS_IP_, and adding
> static __here markers to bss is rather wasteful.

Ouch, I see.

> More architectures will be supporting _THIS_IP_ properly once I get to
> send the patches. The mainstream architectures all have a reasonable
> and fast way to get the current IP, so we don't need to waste bss
> space there.

Ack.

-- 
Cheers,
Harry / Hyeonggon

