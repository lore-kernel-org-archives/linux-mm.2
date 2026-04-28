Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B386FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397D46B0088; Tue, 28 Apr 2026 06:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349116B008A; Tue, 28 Apr 2026 06:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E736B008C; Tue, 28 Apr 2026 06:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 157F56B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:58:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DACE1207EE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:58:49 +0000 (UTC)
X-FDA: 84707666778.24.E84A5F1
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id 61F29C0002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:58:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MUayeyGk;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777373927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIO9Z6eCCgsu+TbVbco8MmNWF3wPidcpQDa9ZnLSo4g=;
	b=qOFVVYbK20abhfg597MbVyrEAm5T5nUKN8vVHAmWgriIs7MZlMmNJWjy5VAs6yqD5P8+vd
	fJbtEKbvFtW8f4oOKl+Tn8fu5jtM7oT7jJaMNoiI5xYwDVJemnyJ0uFdWW1WopxQFYHOoB
	KJcMqPKZcOjfSSii8THQVGuJ9O7NBQA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MUayeyGk;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777373927; a=rsa-sha256;
	cv=none;
	b=idkqjfPnvVbt35dlLKeJLmNnW1QXpTho7xJ2/Vb2lHbtw5M7T74F2opG+WYzId1kUtN9AI
	sOkyi9JPqO+SpfDhgZhwEhKOHbezWTHNlS/ubFzg+hIMeXMNKITYmd1jzfAYWGsrGaegch
	57jTNx/usUtziNMmZcxMNSFP3njaWOA=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 554F7C79BE;
	Tue, 28 Apr 2026 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777373925;
	bh=zIO9Z6eCCgsu+TbVbco8MmNWF3wPidcpQDa9ZnLSo4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUayeyGkeosTrf5GoC1Az5Guj7bmnpCNjX2ArIoYI/IyvY7Gndh4PmSifuHFLFOi7
	 lxJf6mElp2LUh+7jxUA4X3dnuCnLT2hf9FpJj+N4HxGnzm7IO5mrBfEMo3zQHHRxIE
	 Seq2I3A7dly9h4vQVHkLl6mhpzls8CsBAtByTI8M=
Date: Tue, 28 Apr 2026 10:58:41 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dan.j.williams@intel.com, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <afCS4d4YccQFtvpi@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309164516.GE606826@noisy.programming.kicks-ass.net>
X-Stat-Signature: hu7r6r6bypp4bgr5mqgtbr8oo8yjt113
X-Rspamd-Queue-Id: 61F29C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777373927-138278
X-HE-Meta: U2FsdGVkX1/zRNMydV9uKdWchmp5rstFMQp+i0dvXh/ZDdiLU+zIuSPSQnoQNLdiIA6ONinFXL0qK4w2/I8XtaoB+wcRUDMMDsOWjno0Eg89RpH/DUWC49ju+xcFodgq1SXeYi+JocUYBHIyNb8ak4bXGJ2Mjpyz6Lkp3FUVDCCEddCVgZLuAcL+2aBhWP5iftWpiE5rzJARMbyevcqE5D1SsH47lCi1Wz5edHTvfZ5MnfJzYpGUp8a2Mz35hwvnu1ZngCFbu7fQafNuzsGMRfm6t6w3FEy/W4qGdiBgFiWyrB6VFgBq6ks7JzTEAKoR4U3H0BDHvjpPcqjBB9UPsNNfiT1hY+jn686GTZaKccn8SEwz5ptFmPetVRnl9qJOd89gB80UkAg7u0BmG5DGmdV4KpKKy1v0Dd+e2SG1u7mHaTLxwH3hwgm/3FFK940iYeJibtw5LyUuzKP9yLHatqyzyhrHtHL39jKHrh7racun0lChbEUv0nOzymgQRS9Us2jTVeh+WG7wr3e33Hf2mUsLVfN3Mg5zjrrkvFeJlycPMiLctzlsmfFBd/sVvCRQQrhOx1A2U+2GOdxou4EWHB+ve2RJFolaJeKwZN/3Ja23M+wCeMjOR8yqxjx7aiu0+fxlmaBimwcCbwvw/80kTbnhbiG1w+q8VSuxGK+iyaJvyemraxXPmGJY/M8dVNK+ChQxXY6vGyAnhJvvgkTYcwBAQ1TWMLuw9OR4SpzwEtGriG4VLu97OZpC15KwNgHQHbETelLK4wSyL68LuVdscWakvBdcMYco5MsMxRZpTmIxmOvx1kmJFHOVVtyIp2EqvF9ZwsIEzY+VJtb1baAdaEG1qIX2ho+D4syhvzLA9ZMRvIGPMR4cVyES6v3DH5lP2rkx2hFjrEmvnTVKGD3Q0iaUDC9RQok4XtrCa/ro3k1BeGud+Kvj2lQxxDNz8oPJVRzFZeB7Coz4v6wmZoy
 gwTsP1et
 XUznq9ADYuB2OUT2CIzckZ0QnaXeCjAzZbleaQrz7FaV9dydANqEjuzFVT6IFH3X4i/mESllJoRzibkoCA2/SgX0fSYvseAtTbAFdTdt/wSoDhU8/JBN+WJYQK0WxOw6fNqEv8Teq1YYunBVX+pGgflBiopBbDHWjgCjaA1alaxZMRuHSBsdpMepjopqK6yQAAGMPF6jOSbNfnvba7XvLhVOs3xmgFFOghX3YGuuYDrUAmEGTesfHy7ToPmkUAaoKyA9AoDDQ52w1a7wE0rtGYIBFgHCvVyuEEbB1xebN+0F+uX7zLX4GatEy3lDlGu4He5GEKXKAgg+aQE+KRSYAXkEO+DmmiJ03c3z06iucGiM1w4IEA6xhz34NSJJoz3TeG4ooiApjEP3EGpsr7dYAS2fnuhwRVP1CzDVXLWveV1BYfqWBirNtcoXhwgTtQl+B9eBSmQcsuVNePq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:45:16PM +0100, Peter Zijlstra wrote:
> On Sat, Mar 07, 2026 at 02:09:41PM +0000, Dmitry Ilvokhin wrote:
> > On Sat, Mar 07, 2026 at 02:16:41PM +0100, Peter Zijlstra wrote:
> > > On Fri, Mar 06, 2026 at 07:24:56PM +0100, Vlastimil Babka wrote:
> > > 
> > > > Yeah I don't think the guard construct in this case should be doing anything
> > > > here that wouldn't allow the compiler to compile to the exactly same result
> > > > as before? Either there's some problem with the infra, or we're just victim
> > > > of compiler heuristics. In both cases imho worth looking into rather than
> > > > rejecting the construct.
> > > 
> > > I'd love to look into it, but I can't seem to apply these patches to
> > > anything.
> > > 
> > > By virtue of not actually having the patches, I had to resort to b4, and
> > > I think the incantation is something like:
> > > 
> > >   b4 shazam cover.1772811429.git.d@ilvokhin.com
> > > 
> > > but it doesn't want to apply to anything I have at hand. Specifically, I
> > > tried Linus' tree and tip, which is most of what I have at hand.
> > 
> > Thanks for taking a look, Peter.
> > 
> > This series is based on mm-new and depends on my earlier patchset:
> > 
> > https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/
> > 
> > Those patches are currently only in Andrew's mm-new tree, so this series
> > won't apply cleanly on Linus' tree or tip.
> > 
> > It should apply on top of mm-new from:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> OK, so the big problem is __GUARD_IS_ERR(), and that came up before, but
> while Linus told me how to fix it, he didn't actually like it very much:
> 
>   https://lore.kernel.org/all/20250513085001.GC25891@noisy.programming.kicks-ass.net/
> 
> However it does help with this:
> 
> $ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc-post-gcc-16.o | grep -v __UNIQUE
> add/remove: 24/24 grow/shrink: 3/2 up/down: 296/-224 (72)
> Function                                     old     new   delta
> get_page_from_freelist                      6158    6198     +40
> free_pcppages_bulk                           678     714     +36
> unreserve_highatomic_pageblock               708     736     +28
> make_alloc_exact                             280     264     -16
> alloc_pages_bulk_noprof                     1415    1399     -16
> Total: Before=45299, After=45371, chg +0.16%
> 
> $ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc.o | grep -v __UNIQUE
> add/remove: 24/24 grow/shrink: 3/15 up/down: 277/-363 (-86)
> Function                                     old     new   delta
> unreserve_highatomic_pageblock               708     757     +49
> free_pcppages_bulk                           678     707     +29
> get_page_from_freelist                      6158    6165      +7
> try_to_claim_block                          1729    1726      -3
> setup_per_zone_wmarks                        656     653      -3
> free_pages_prepare                           924     921      -3
> calculate_totalreserve_pages                 282     279      -3
> alloc_frozen_pages_nolock_noprof             622     619      -3
> __free_pages_prepare                         924     921      -3
> __free_pages_ok                             1197    1194      -3
> __free_one_page                             1330    1327      -3
> __free_frozen_pages                         1303    1300      -3
> __rmqueue_pcplist                           2786    2777      -9
> free_unref_folios                           1905    1894     -11
> setup_per_zone_lowmem_reserve                388     374     -14
> make_alloc_exact                             280     264     -16
> __alloc_frozen_pages_noprof                 5411    5368     -43
> nr_free_zone_pages                           189     138     -51
> Total: Before=45299, After=45213, chg -0.19%
> 
> 
> 
> However, looking at things again, I think we can get rid of that
> unconditional __GUARD_IS_ERR(), something like the below, Dan?
> 
> This then gives:
> 
> $ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc.o | grep -v __UNIQUE
> add/remove: 24/24 grow/shrink: 1/16 up/down: 213/-486 (-273)
> Function                                     old     new   delta
> free_pcppages_bulk                           678     699     +21
> try_to_claim_block                          1729    1723      -6
> setup_per_zone_wmarks                        656     650      -6
> free_pages_prepare                           924     918      -6
> calculate_totalreserve_pages                 282     276      -6
> alloc_frozen_pages_nolock_noprof             622     616      -6
> __free_pages_prepare                         924     918      -6
> __free_pages_ok                             1197    1191      -6
> __free_one_page                             1330    1324      -6
> __free_frozen_pages                         1303    1297      -6
> free_pages_exact                             199     183     -16
> setup_per_zone_lowmem_reserve                388     371     -17
> free_unref_folios                           1905    1888     -17
> __rmqueue_pcplist                           2786    2768     -18
> nr_free_zone_pages                           189     138     -51
> __alloc_frozen_pages_noprof                 5411    5359     -52
> get_page_from_freelist                      6158    6089     -69
> Total: Before=45299, After=45026, chg -0.60%
> 
> 
> Anyway, if you all care about the size of things -- those tracepoints
> consume *WAAY* more bytes than any of this.
> 
> 
> ---
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
> @@ -286,15 +286,18 @@ static __always_inline _type class_##_na
>  	__no_context_analysis						\
>  { _type t = _init; return t; }
>  
> -#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
> -typedef lock_##_name##_t lock_##_name##ext##_t;			\
> +#define EXTEND_CLASS_COND(_name, ext, _cond, _init, _init_args...)	\
> +typedef lock_##_name##_t lock_##_name##ext##_t;				\
>  typedef class_##_name##_t class_##_name##ext##_t;			\
> -static __always_inline void class_##_name##ext##_destructor(class_##_name##_t *p) \
> -{ class_##_name##_destructor(p); }					\
> +static __always_inline void class_##_name##ext##_destructor(class_##_name##_t *_T) \
> +{ if (_cond) return; class_##_name##_destructor(_T); }			\
>  static __always_inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
>  	__no_context_analysis \
>  { class_##_name##_t t = _init; return t; }
>  
> +#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
> +	EXTEND_CLASS_COND(_name, ext, 0, _init, _init_args)
> +
>  #define CLASS(_name, var)						\
>  	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
>  		class_##_name##_constructor
> @@ -394,12 +397,12 @@ static __maybe_unused const bool class_#
>  	__DEFINE_GUARD_LOCK_PTR(_name, _T)
>  
>  #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
> -	DEFINE_CLASS(_name, _type, if (!__GUARD_IS_ERR(_T)) { _unlock; }, ({ _lock; _T; }), _type _T); \
> +	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
>  	DEFINE_CLASS_IS_GUARD(_name)
>  
>  #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
>  	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
> -	EXTEND_CLASS(_name, _ext, \
> +	EXTEND_CLASS_COND(_name, _ext, __GUARD_IS_ERR(*_T), \
>  		     ({ void *_t = _T; int _RET = (_lock); if (_T && !(_cond)) _t = ERR_PTR(_RET); _t; }), \
>  		     class_##_name##_t _T) \
>  	static __always_inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
> @@ -488,7 +491,7 @@ typedef struct {							\
>  static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
>  	__no_context_analysis						\
>  {									\
> -	if (!__GUARD_IS_ERR(_T->lock)) { _unlock; }			\
> +	if (_T->lock) { _unlock; }					\
>  }									\
>  									\
>  __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
> @@ -565,7 +568,7 @@ __DEFINE_LOCK_GUARD_0(_name, _lock)
>  
>  #define DEFINE_LOCK_GUARD_1_COND_4(_name, _ext, _lock, _cond)		\
>  	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true);		\
> -	EXTEND_CLASS(_name, _ext,					\
> +	EXTEND_CLASS_COND(_name, _ext, __GUARD_IS_ERR(_T->lock),	\
>  		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
>  		        int _RET = (_lock);                             \
>  		        if (_T->lock && !(_cond)) _T->lock = ERR_PTR(_RET);\

I re-tested my original patchset after rebasing and can still reproduce
the regression (though smaller). It appears to depend on compiler
inlining decisions: in some cases the compiler is able to deduplicate
the cleanup path across multiple return sites, while in others it is
not.

Given that, I think we can go further than just removing
__GUARD_IS_ERR(). It should be possible to eliminate this branch
entirely and simplify the cleanup flow.

    https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

Reposting here to increase visibility, as several people involved in
this code have participated in this thread already.

Any feedback would be appreciated.

