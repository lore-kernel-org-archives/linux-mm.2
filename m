Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDDFF36B97
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 02:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945E36B0005; Thu,  9 Apr 2026 22:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6DA6B0089; Thu,  9 Apr 2026 22:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5D06B008A; Thu,  9 Apr 2026 22:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C55D6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:10:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F064AB8D54
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:10:54 +0000 (UTC)
X-FDA: 84641018028.13.136EC76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F97814000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:10:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4tLeQJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775787053; a=rsa-sha256;
	cv=none;
	b=2IyhyTH3T53HgtUXGukyuBPEgQfBdK/hYh77+iQJ5HzpX9J91BCCqGwl5LsKJtkHlEYVHI
	2lSsFXFe9N3vCKgNNOhlnMoR8b2t/G0szaLpHUgQbvuwqmkt4RTA9uW7v8Bj2kwHKIfzQf
	rA5ko2xohgE2GVs/QcUXZ3FCy773V9k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4tLeQJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775787053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQrbV7E2nNTbKhjCg4S0RpCcE5EUHsb8bBXmDT8MFV0=;
	b=1mHaXUz8IKjTXCh7gJgSUIFTvR0LvsdnGGwygB+9PUPu1u1XcZpj2iRytLIaiRTesTWB6e
	tEelP00lTorHbx2m6VbyRHeYJaBIfTGUo167hKsQLppAEF78hlpvktDV54QDAHFoFSautl
	kYVCY1UHKN7jWdbSa55yF4yFxQeACDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 055514445B;
	Fri, 10 Apr 2026 02:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799ACC4CEF7;
	Fri, 10 Apr 2026 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775787051;
	bh=sYEJlC+80a5TUPCyGZHLWRArwG8vmKPmnR+IrEgx5A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4tLeQJfd+vN9qPkw7uJDjgl7R1cWD7iGKz3zMVvIUlierwn/u/iPnlSeDHMZHxwP
	 F/bz5k3nRbvK5s3c3ZL/V4w8iYT/lZ4nouO/LlhquLbR8R9xz5YCAfnhy5gaWGZYHy
	 CLhOTZ2JjllHI3lQDgvAzZgMHzRc8M5d9I0eN0ggS8SyDhnBHiR6Sx4ijxq8YDKLXh
	 qEHnTm45l/RcSxwgCIDoSjB+Y4ZNA43eGpD4V8pwxyIRDNVBGtPLacCzOYsmYz6Qyp
	 WmlO4XdncK7IPKPYCuqglYMgN3oYZuS96duJOS0SMh9xqWhYmMezOOt9TnZV1eC7iE
	 CNjvptAiRAk5g==
Date: Fri, 10 Apr 2026 11:10:49 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <adhcKZGytWdaLxJu@hyeyoo>
References: <20260331111240.153913-1-elver@google.com>
 <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org>
 <adM2XVZf1DekahlY@hyeyoo>
 <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com>
 <adT-gkVmVDDXR1h_@hyeyoo>
 <CANpmjNO1aNm3mKphDGWasK_NUfVY8q4K9GCjyREZFqrOu9WLcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNO1aNm3mKphDGWasK_NUfVY8q4K9GCjyREZFqrOu9WLcw@mail.gmail.com>
X-Stat-Signature: fxaf9bj7rp9hdt69gajdy19yk7hat5w1
X-Rspamd-Queue-Id: 3F97814000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775787053-115155
X-HE-Meta: U2FsdGVkX18TuGKSVFmikls6+BWBjp8RU9weq4gZHO3lTZpHIuVMXDEmq6UnuX/SZd+czJWVZqe/ZUMXVMOt6ou2G++0Kyufxl+yOmdOW9meAgsZv6djtTS4/OmFxrs5vEi2oxknb9wPFzn0141XQIu0CzpNGlQoueCoKbjjsM6+i4HamNlxKRMuv4aO98ETI5tgxLLyKGl+9xzdffX5Rr+DegrD7I+cgi0GdayVFtS9U3MWCZ+04B7uLXd5ZNhHjh0bmBE6+HgfKUtuofemEH6fr7n/aCUABefuEyFaQBPnotg4zMmPJZ2fZRLZ8ZrveAyNue/+aVuM8NEcoYQx267Ug22kvDJitRsk8OCNyRzEgV979KTIytcnnA/2txv1VkEu4uAQP5iw5JawNRj+30Gc5d9GR+okXx9o7d3dx+WT6nCPsxfle8LCfbfqhU26nLr7ATDErlEAStLuOnuL4rlqlHJ1EYXQPTGRgDyDtuEU1FCfWce4lElgpIbav8qW/WzB8QgDObq4GSN7S8hzPAvwZbGkhWdsHgW3fc0B21DJVLFxLsdcaT5m9jRcA/Qq0O4xXBV7o/gXAkZ723Z5zDBxC3HfGJpjAIFQqFvFltvArr6AbTgDpEs+DdAhsfvICs8m1ap1hiH+xHfj05GSe/eqc9IHnA3Doxww0i6VKSgAY/DZm3aDzv5OXcqVNPaJx9jrWzQIC+C3r4fZjgZFZejxtYvMNDB152Zo4kpDCOBT4YJO2w3svjYCqfvq8cY2SxquKEOg0Nl53eb9tKiaLf4DV2zoTKUsJ0IF+R7xc1xUaX2PoUAa4kNPkyxyZJY/1/HjrhXzu56HspIPkP4Op9RWVGWLoiE6hTX8txPP2FQCjVszdx42dkwG+/LKAZtfuI34MEhvyx6cmV5sjpk5hzrOwu+a2Fl29DgeKy5JS2ENTzH+cuqLRWq6zFNc79KrE7/myHuyShtWwhJCgx7
 W0XVHxjY
 iSgUBwd8FepfZrV2mGH+c/VNB44zQbbPkh7pmOWWLqY5En4O16VrcuMOj5n9lacHFcdA0UHeOVytAiwcf5qzwLi3AG/lQp/Q5f7PKGC19Lw0lSlYmQeGrdRyj8KKaBdZ12lX5cu+RaSGfsI5P53e04hiLXvcZ24fGzUG/2TP5+/pCT5saHAUwl0NzW+TRgO2i8TnrwwcOMa8JgoC36aKD/SlI+74jrdjqLP7aVoNckMfqTvziqc+fhhJTD8H3jNaxhbUXHlLpH4OL13bRtSKV2SsA34M4duHW2wjqSDtZNqJcpYz/mbBUR73q/pTy23auKOpGxfHMLuGIdGJkf+XwLvE/VvMp6aieC84G5yDDf25dqKkFqo7L9huEG8zN/rujpp8H4sbhiHvqNyyjqiqI6j9yynSWQbPH4RSS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 10:19:09PM +0200, Marco Elver wrote:
> On Tue, 7 Apr 2026 at 14:54, 'Harry Yoo (Oracle)' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > On Tue, Apr 07, 2026 at 01:17:14PM +0200, Marco Elver wrote:
> > > On Mon, 6 Apr 2026 at 06:28, 'Harry Yoo (Oracle)' via kasan-dev
> > > <kasan-dev@googlegroups.com> wrote:
> > > > On Fri, Apr 03, 2026 at 08:29:22PM +0200, Vlastimil Babka (SUSE) wrote:
> > > > > On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
> > > > > >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> > > > > >> index 15a60b501b95..c0bf00ee6025 100644
> > > > > >> --- a/include/linux/slab.h
> > > > > >> +++ b/include/linux/slab.h
> > > > > >> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
> > > > > >>   * with the exception of kunit tests
> > > > > >>   */
> > > > > >>
> > > > > >> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> > > > > >> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> > > > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > > > >>
> > > > > >> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > > > > >> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
> > > > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > > > >
> > > > > > So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> > > > > > disabled but still increases the kernel size by a few kilobytes...
> > > > > > but yeah I'm not sure if we can get avoid it without hurting readability.
> > > > > >
> > > > > > Just saying. (does anybody care?)
> > > > >
> > > > > Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
> > > > > using DECL_BUCKET_PARAMS(),
> > > >
> > > > Hmm yeah.
> > > >
> > > > I wasn't sure if we could do this without hurting readability,
> > > > but perhaps we could...
> > > >
> > > > > so maybe extend that idea?
> > > > > I think it's not just kernel size, but increased register pressure etc.
> > >
> > > I'll take a closer look at generated code.
> >
> > > In some cases the compiler ought to omit zero-sized arguments,
> >
> > Oh, didn't know that was a thing.
> 
> So I checked with Clang and GCC. Looks like Clang does omit the
> zero-sized struct argument, i.e. generated code is identical to
> before. Whereas GCC wastes a few bytes of stack space at callsites.

Thanks for confirming that.

> Which is sad, because that means we need the macro workaround.
> 
> Do you want to be credited with Co-authored-by

I'd appreciate that. (I guess you meant Co-developed-by)

> - in which case I need your Signed-off-by.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

> > Not sure if it's safe to do that for exported functions though (since
> > modules can be built w/ a different compiler).
> 
> Kernel modules built with a different config (implicit if different
> compiler) are not supported, and never have been. If it works, it's
> just luck (I know people do this, but it's just a disaster waiting to
> happen).

And if GCC folks somehow fix this at some point, even kernel modules
built with a different version of GCC might not be supported?

-- 
Cheers,
Harry / Hyeonggon

