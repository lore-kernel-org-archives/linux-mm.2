Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8358ECD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 21:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512A76B00BF; Thu,  7 May 2026 17:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2D36B00C1; Thu,  7 May 2026 17:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8806B00C3; Thu,  7 May 2026 17:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA126B00BF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:49:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBA961A0627
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:49:42 +0000 (UTC)
X-FDA: 84741966204.05.F464581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1245740008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:49:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jwqqpn26;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778190581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3BqRlYJUpwQ11CbgdcI0YiUNvd12YBuwWCEhZvN2w8=;
	b=ztM6J4G3FwcJn9xbLwFclslDtpBDJIwtjcpN/NMG45MySe83Evu1RjxcAONDSNAKltOwlX
	k4MNPUSS/umV5qAhnZ/rLv5OeaF0uUl63W8uDzZEdJ7Dfnx0tOsEyKTnaX9yG7kNZ5o7Cm
	IHKrGUKdXd/kS9XLf+Cs8/eJmUqj18Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jwqqpn26;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778190581; a=rsa-sha256;
	cv=none;
	b=dtBMvxD/wqnFo9Ax6INwxlHV2esX57qv1QskrCql+z+FjqzNLBaK87mrUrWb6x4nulOPls
	OuB9uxrNcqb9UmApPA88KWeitfPxLwK0HyjzHQpYHU2sccfovMxJuCpkfeCRp/MIllea6x
	GYo34byqOgNotJwxXWyJQM/CJr0tkSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D43AD442E8;
	Thu,  7 May 2026 21:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16F9C2BCB2;
	Thu,  7 May 2026 21:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778190579;
	bh=vDhx+qTlEIGongxfTbCi7izCbN5cvEC0zYIQ5cbMuOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jwqqpn26rDsSqSQ6iSY7WfIk8u1SsmwHBzioFfRMvR4e9N6oP0FBidey1y2T+Lzxi
	 O6rdnRlS24/l9Q7ZH/qS9m9frAolUlZBJs+LQp2AHV42DQS5hI3PQU/zs5tC44FF4s
	 MI5GYeR+oxtqLILIScpQQjcmFsykVrvqH6P/4+AMmOssMqiHNk626tOQ1rUgJd5JnJ
	 ubNV1WnfwHzwmSPIZ+ktI1V+E6asZCmNNF4lKVnYxzX/EIAgbCNNqPdWYgqfwbU/7U
	 xyaqLgvGNw1n0oR4CiJ1jyRQpVIisSYe+NJBD03tsVHW2DsiqukQdCz2TH4yBbi07k
	 +G3+tqU2LJypw==
Date: Thu, 7 May 2026 23:49:20 +0200
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
Message-ID: <afz7pZADZPD4mKJr@MacBook-Air.tail10959e.ts.net>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
 <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1245740008
X-Rspam-User: 
X-Stat-Signature: drcticq6itbjwfj1gypyweqwwwo76dm5
X-HE-Tag: 1778190580-921380
X-HE-Meta: U2FsdGVkX1//TslQ+BDXt0I30ED4OQIxqdSYL+KnATHNeh6ub56FD19IZwsIwMwliiuHeeRZh/YSHXXv60Bzu2UiA3mY0o/u/BGDnQxtpUm7aJg2Q+fGtW0FDZKw8o2CWBBKD7QuddpJW0vIGcluNsHhF7pL80I5MWDGKc4jk+BMxlVX/ltkEcZpAL8FLGKLAgSlzHlGTzheUQ55US2DI5praF6sSf/CSjj5GJXTUhysl7rfuWQyFYeWggPa6g5aKE2MOGaQKqB8w/qyC49aKYcY6a0S+CNEhoTqAYDipujYuEEYAxltOkxp9f8DT8hZxLhpa+ua8sKt4rjPu2IRx2URyZfYxSASrQ6KrsuJysoKkY8gDY+GpwTGVza++xtWmFa3gTWGjfgyNBlCVwbie+RGyPZSwkgzGrXif4alis+0eyiDTwBeAm5TZp/U+1wcOqiaFF11g3o9BFKS3MxPCUJkK9D27Ta79axT/ax0E+gBqU4bLMNvy2jkgPp09HVa+MEAwlUUQ2xi0aLniVoC2JvU6+yA19G2JmL414z4hj2YLf4ZacN5G/lGGGvFZ+48mFvQxAZlc/6yvudkhbcF3a1CexZ+DJ+OHNf5NgjE4EGH0eMiz3PJExjec5X7Pn/YjUpbS/w3mW91sMxe9kygoZgXWwSCJsoaLmeQFzDztV57YjDpNlQdzTzMMgOHUaO1JzMuXUgXMt6Nrjlsb0e4zG8nGj2dqYeEKy8GgzNKKZvZM6AfLJXVMWCVOEm2QtfFGIc7dHcSEidIgqSfoyosMcRNZ+PCZlGfkIJM/jgkvqw00iYTfEoF8ysA3RzLYq3X4o58bY74wrAe6UQv4Cb8J31mPBPkkN2wGqb5OzRmVjdZCgg+JKNDQB8JDDLXPTv5YwNxapeTqLFcN4mDzwBgX7FrZsmrXRQhrpmzpl1fC1jg/KAjKdpIp0azb3ifkfKvMD0aYXhrkqcU1fx4wyf
 rS+CXmf3
 Ap32fe5jEHbvO32woRVkK3YMaKIy30ljbQLyJcIV6uYutgbAE7k3wYSVzaAFtr7LGsv9bs7nE0VDN/ddVTFGzLDvGGMesgGY5MR3edKsl7bMdkJfr1U3VFXcUBlZGexR+EPxHXiEBDl8hfOLSAp/Z/K5GJpbqUEgkQyC4Zqp6z8CQgI2c3hEReULSsEm7EG6Vf6MeulkmdZgtD9dEYK92TQ3E+1PN/grdmcCm/HufvfHttFLbGQn/Z3jMLpdM5BrqHeJJCantjbe6hzJD6a+dS19bI+L77qbwG4Cb6R0s/QSzeWhofSxwF1EyTrFtQnggkdCQcy8gsXx5b+QKRZ7B4NJmUXCJuMoes+a7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 03:03:27PM +0100, Marco Elver wrote:
> On Mon, 4 May 2026 at 23:23, Marco Elver <elver@google.com> wrote:
> > On Thu, Apr 30, 2026 at 03:03PM +0200, Vlastimil Babka (SUSE) wrote:
> > > On 4/24/26 15:24, Marco Elver wrote:
> > > > @@ -948,14 +978,16 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
> > > >
> > > >             index = kmalloc_index(size);
> > > >             return __kmalloc_cache_noprof(
> > > > -                           kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
> > > > +                           kmalloc_caches[kmalloc_type(flags, token)][index],
> > >
> > > While reviewing this, it occured to me we might have been using _RET_IP_
> > > here in a suboptimal way ever since this was introduced. Since this is all
> > > inlined, shouldn't have we been using _THIS_IP_ to really randomize using
> > > the kmalloc() callsite, and not its parent?
> > >
> > > And after this patch, we get the token passed to _kmalloc_noprof()...
> > >
> > > >                             flags, size);
> > > >     }
> > > > -   return __kmalloc_noprof(size, flags);
> > > > +   return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
> > >
> > > ... and used also here for the non-constant-size, where previously
> > > __kmalloc_noprof() (not inline function) would correctly use _RET_IP_ on its
> > > own ...
> > >
> > > >  }
> > > > +#define kmalloc_noprof(...)                        _kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
> > >
> > > ... and the token comes from here. With random partitioning that's
> > > #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> > >
> > > so that AFAIK makes the situation worse as now the cases without constant
> > > size also start randomizing by the parent callsite and not the kmalloc callsite.
> > >
> > > But there are many users of __kmalloc_token() and maybe some are corrent in
> > > using _RET_IP_, I haven't checked, maybe we'll need two variants, or further
> > > change things around.
> >
> > Good catch. I don't think we need multiple variants (otherwise the TYPED
> > variant would be broken) - we're moving token generation to the callers
> > (not even inlined anymore) with all this macro magic.
> >
> > I think this is all we need:
> >
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
> >  typedef struct { unsigned long v; } kmalloc_token_t;
> >  #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
> >  extern unsigned long random_kmalloc_seed;
> > -#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> > +#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
> >  #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
> >  #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
> >  #endif
> >
> > Plus a paragraph in the commit message.  Let me add that.

Err, I was like "yes, this is the way to go!"

and then...

> Bah, this is why it doesn't work:
> 
> >> drivers/gpu/drm/msm/msm_gpu.c:272:4: error: cannot jump from this indirect goto statement to one of its possible targets
>      272 |                         drm_exec_retry_on_contention(&exec);
>          |                         ^
>    include/drm/drm_exec.h:123:4: note: expanded from macro
> 'drm_exec_retry_on_contention'
>      123 |                         goto *__drm_exec_retry_ptr;             \
>          |                         ^
>    drivers/gpu/drm/msm/msm_gpu.c:304:16: note: possible target of
> indirect goto statement
>      304 |                 state->bos = kcalloc(submit->nr_bos,
>          |                              ^
>    include/linux/slab.h:1173:34: note: expanded from macro 'kcalloc'
>     1173 | #define kcalloc(n, size, flags)         kmalloc_array(n,
> size, (flags) | __GFP_ZERO)
>          |                                         ^
>    include/linux/slab.h:1133:42: note: expanded from macro 'kmalloc_array'
>     1133 | #define kmalloc_array(...)
> alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
>          |                                                             ^
>    include/linux/slab.h:1132:71: note: expanded from macro
> 'kmalloc_array_noprof'
>     1132 | #define kmalloc_array_noprof(...)
> _kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
>          |
>                        ^
>    include/linux/slab.h:506:55: note: expanded from macro '__kmalloc_token'
>      506 | #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
>          |                                                       ^
>    include/linux/instruction_pointer.h:10:41: note: expanded from
> macro '_THIS_IP_'
>       10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>          |                                         ^
>    drivers/gpu/drm/msm/msm_gpu.c:304:16: note: jump enters a statement
> expression
> 
> Apparently using _THIS_IP_ creates a possible indirect jump target,

Didn't even realize people use indirect gotos, heh :)

> but because it's in a statement expression, it's invalid, so the
> compiler complains. This is obviously nonsense, because the actual
> indirect jump in this gpu driver code would never jump to the
> _THIS_IP_ __here label, but that's what it is.

Yeah, I guess it's quite tricky to handle when you don't know where
it'd jump to as it's an indirect one, and there's an invalid jump
label...

> Given this pre-existing issue, we probably need to continue using
> _RET_IP_, as before.

Agreed!

-- 
Cheers,
Harry / Hyeonggon

