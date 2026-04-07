Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3013FFEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA8D6B00A2; Tue,  7 Apr 2026 08:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B476B00A3; Tue,  7 Apr 2026 08:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180F06B00A4; Tue,  7 Apr 2026 08:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0922C6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:54:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9920FC27AC
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:54:31 +0000 (UTC)
X-FDA: 84631753542.03.4B465C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4DF4A0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:54:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnI3bSt3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566470; a=rsa-sha256;
	cv=none;
	b=tuIHX7E6vSVO342ANCo6H6G6TT7StzqSixVIACVsEP2ZVBKgMefbTYzo1mvt0kbRkrJ8su
	/v1OMz0D6Tc9Yf4uetS+w2xjmeKjPH4IOX/iWW+Bl2RyCkCqH6uM3It6V6YtD3MsIQ5iEB
	d1JmbqfZsLVhskTjxlBg9nkYAsIctLo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnI3bSt3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuptwnxHxslf4FSWeaO29e3IxNSZgipPERwOWi11pFg=;
	b=GUW2rxfVkg2ovCjWBf93HcC22LFC8jopO4RquwV3uQF06FcQn8AyoKq8H/ZCV/iPBVUuYJ
	Iy7h77YxhTbyBUySAARizXjgGYh0Xjq2/6Y8/5N1QVz6t5kUCULksah3byID5UgC/CgEhh
	aJevxx3vUFFAeWuo4e9tumA5uk4TM5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D609340606;
	Tue,  7 Apr 2026 12:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590FEC116C6;
	Tue,  7 Apr 2026 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775566468;
	bh=8Ji12lgxQFeQ0eoD/lANGRdEYLLrVV374G+C+Ni88gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnI3bSt3HjVWVA4CO18XQVLGmXmaHI/PKaj09L7MapKBTgBF4+vYcp9Jpow9HVjs2
	 DG92KMxitrIZCZARQetbo8EnLBE8T2X2FbWU3JaKcFRK1K+r0XZYT74/NJ5ANEVIFg
	 Cfngzxlk4UBRGAtHCHgM4ThECBTQUK0GyDMnh1ey7StBxjuCP9RRuqr8n/Km2uGIgW
	 Awb9Nc0AulMbQvJX+oqeIbriKr28hBesaYc99msxR90dQKzhvjDluT8Z8v1qg1aKq9
	 0lsRYCmM+tu+6LJJQm1s/c+MCVcn38JhjgrtMndZoni8FzQZHzjdWPlixpx30YRqHJ
	 8mwjy8KvYS6Tw==
Date: Tue, 7 Apr 2026 21:54:26 +0900
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
Message-ID: <adT-gkVmVDDXR1h_@hyeyoo>
References: <20260331111240.153913-1-elver@google.com>
 <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org>
 <adM2XVZf1DekahlY@hyeyoo>
 <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com>
X-Stat-Signature: 6wzehjne9trifkos8ps7znafy7zw45gi
X-Rspamd-Queue-Id: D4DF4A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775566469-380007
X-HE-Meta: U2FsdGVkX1+TMxAxmunX+3Kl7NKSgGUSqHX0Z2ipHPtokgEak0eAycLw74cHRy2vF5B2JRegKRfp5mTPp6cfGW1DzuRJgEJs9vrfjcyJu1o8t9tMUIWvEq53iyKHAHIDFt2fdkz10t6bXXFwxmQj5l1ppanV6VRxi8vzjDFLSTy0Q7inil4xseKrv0ccVm4pp+uaBhnklTn04NUm8pLsFjaRzBDEbwTTgF4PaENvS9FnPddvpRulE8OimNHFXO485S2aB4sJDU1ZGFJKcTDAoHvfG6YNjsdBaZTtB4xXzN0CjT/9X/eRQ/UwzZsNfZ/TT1uXuJs4MJjGVrLpOsA/oC8oBPI2WmIA3K/0bX4zygPifj38bcKJpkqu0AdYDWmBt4MUPfja9QVF0abZa/u7b3RU55x89ApjOXieh6NuMVe4QJWSD53QICiocMs42fwY02bdiz04KaMfeXVO1yyNV3If0fDyr+50AjdfCoO0ex4jaoWFO+tZwXJxdOty7dMQnvhMDL6TL02XsoYse8RnkL0kGnSpiurwYRkPNkC2+RkwGLk3Lteufxnz2vSULuiLrJh3oKxKZX7INkiWsS7rrHnIprn/xottkOqoEDpGjBBwJdXuoVc+sGTHdU/lF2gwGlyIzydWtcMoXMSU54BWvppEFSDb4SjE8bR8jc5VssbCTwSF3bjcbt9qsNw4Rex7KdaJKuJpYILp7oaQXnp4p2Ji+CBMeCayQ+QOov6pMnnDtG0ScWggC2jR8jJSwD0vafZuvQBDkkBkShxcw+SGxwb6pvJ4yduyaNFh6IspoT5eMLH8kpsGBD//p2tsVxi+3TI1DaSIljOgLPlCzprZUW3OPkgN9yOuaVx5efSE7si1ssry3l4BKh8+BpzsBLii6cTfdqSw29O+nuAFJdXcuP0UmmTak7HW3VvG4Z9VTSIugZ/2e9IfYn7odayFQKjI6i239LDlLUtS16CX2u/
 i+4vPQO2
 C9oUejs3mijRoyIbzdg/rXWaCDmsNbuvq2xVx9qib2yPOKR8lHDi3XnLTa9qTjzBslORNPt/VWvYfqqYs5nloeIbaBcsmX3ryjJUxT5w3pEOblRXSVspahecckc/62t1loSZ5FCrQTy86K2wQ4SCji8h9pp/IxHWRYkTqPGhQWBWBs6EqfLk0oawXIm6QZznlBWILrmTfuHkihNznVED5aCcUaBgtrfcQ0Pw0Zbwo4fvDTnSEwfz7wJe/Z4a9/L3oWEBlZaYgNgqivfpfpCAdDyh0FCLqtoVmJyKB1zdtmjphVGPdrHETunUEMM9T8VQ3F0dD8mMlp+x1ysB6KYc7NU9NgOb71ytIK8NWOmY8uHDJkvkCN0/KmLPmDn7QibOscRe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 01:17:14PM +0200, Marco Elver wrote:
> On Mon, 6 Apr 2026 at 06:28, 'Harry Yoo (Oracle)' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> > On Fri, Apr 03, 2026 at 08:29:22PM +0200, Vlastimil Babka (SUSE) wrote:
> > > On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
> > > >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> > > >> index 15a60b501b95..c0bf00ee6025 100644
> > > >> --- a/include/linux/slab.h
> > > >> +++ b/include/linux/slab.h
> > > >> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
> > > >>   * with the exception of kunit tests
> > > >>   */
> > > >>
> > > >> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> > > >> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > >>
> > > >> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > > >> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
> > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > >
> > > > So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> > > > disabled but still increases the kernel size by a few kilobytes...
> > > > but yeah I'm not sure if we can get avoid it without hurting readability.
> > > >
> > > > Just saying. (does anybody care?)
> > >
> > > Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
> > > using DECL_BUCKET_PARAMS(),
> >
> > Hmm yeah.
> >
> > I wasn't sure if we could do this without hurting readability,
> > but perhaps we could...
> >
> > > so maybe extend that idea?
> > > I think it's not just kernel size, but increased register pressure etc.
> 
> I'll take a closer look at generated code.

> In some cases the compiler ought to omit zero-sized arguments,

Oh, didn't know that was a thing.

Not sure if it's safe to do that for exported functions though (since
modules can be built w/ a different compiler).

> so I want to be sure we're not
> prematurely optimizing and the size increase is not some other effect.

Great, thanks for looking into it.

> > Something like this should work? (diff on top of this patch)
> 
> Thanks, I'll consider it.

Thanks.

> Re your other comments:
> 
> > Assuming not all people building the kernel are security experts...
> > (including myself) could you please add some insights/guidance on how to
> > decide between RANDOM_KMALLOC_CACHES and TYPED_KMALLOC_CACHES?
> 
> You can find different arguments for either, and in the original RFC
> that was part of the discussion.

Yeah, I had fun time following the discussions :)

> However, my biased view is that type-based partitioning in general
> is the stronger security boundary.
> Because it creates a deterministic separation; specifically isolating
> pointer-containing objects from pointerless ones: it effectively kills
> certain classes of exploit techniques that probabilistic defenses
> (like randomization) only delay, especially in environments where
> attackers can retry or use side-channels.

That's a fair argument.

Could we possibly put some of those arguments (in a neutral/technical
sense) in help text to make people's lives easier?

Err, trying to provide unbiased (tm) help text...
Something like:

config RANDOM_KMALLOC_CACHES
	bool "Randomize slab caches for normal kmalloc"
	help
	  Randomly pick a slab cache based on code address and a per-boot
	  random seed.

	  This makes it harder for attackers to predict object co-location.
	  The placement is random: while attackers don't know which kmalloc
	  cache an object will be allocated from, they might circumvent
	  the randomization by retrying attacks across multiple machines until
	  the target objects are co-located.

config TYPED_KMALLOC_CACHES
	bool "Type based slab cache selection for normal kmalloc"
	depends on $(cc-option,-falloc-token-max=123)
	help
	  Rely on Clang's allocation tokens to choose a slab cache, where token
	  IDs are derived from the allocated type.

	  Unlike RANDOM_KMALLOC_CACHES, the cache assignment is deterministic
	  and based on type, which guarantees that objects of certain types
	  are not placed in the same cache. This effectively mitigates
	  certain classes of exploits that probabilistic defenses like
	  RANDOM_KMALLOC_CACHES only make harder but not impossible.
	  However, this also means the cache assignment is predictable.

	  For example, a token ID scheme might separate pointer-containing
	  objects and pointerless objects to prevent buffer overflows on
	  primitive buffers from directly corrupting pointer-containing objects.

	  The current effectiveness of Clang's type inference can be judged by
	  -Rpass=alloc-token, which provides diagnostics where (after dead-code
	  elimination) type inference failed.

	  Requires Clang 22 or later.

endchoice

> The current pointer/non-pointer scheme is relatively intuitive with
> well-understood properties, and a good start.
>
> However, an open research question is if better alloc-token ID schemes exist:
> one that is tailored to kernel data structures that would meaningfully
> increase exploitation difficulty further without increasing the number of
> partitions.

Haha, that's too adventurous research question for me :P

> Since an improved scheme could simply be activated with a
> compiler flag, having the baseline infrastructure available and
> maintained is the first step.

Agreed.

> > Now somewhat out-of-scope (or at least pre-existing) review comments
> > from Sashiko that I think are still worth mentioning...
> 
> Indeed, these are pre-existing issues with RANDOM_KMALLOC_CACHES.
> Worth follow-up patches, but this patch here wants to just get the
> TYPED_KMALLOC_CACHES infrastructure in place so we can build on top of
> it.

Yeah, that's totally fine!

-- 
Cheers,
Harry / Hyeonggon

