Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BB3F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424146B0005; Mon,  9 Mar 2026 12:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB3D6B0089; Mon,  9 Mar 2026 12:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB576B008A; Mon,  9 Mar 2026 12:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9576B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:45:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7FF8C142D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:45:27 +0000 (UTC)
X-FDA: 84527100294.29.58F2697
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5B29A40016
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:45:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m1KXYnaD;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773074726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGBF7wFouxKA/d6vbapd75R2GfrIL9xJFz5HzcQWUt0=;
	b=LVKR8e5frgLg3DDzLP8co1OxqsNSf6yu8N582N+0v3ogqFHkCMhQ4SMo4gSxyEFa7qJk9g
	5yfBV0XxajibeMkI145nKkrmSM2GRN7RobuewqCfxclF+965ma7GOMNNefdJ3SALLiU2X6
	3s6lUsRtebAmKe2FQkCU3N1+5VL6J2c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m1KXYnaD;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773074726; a=rsa-sha256;
	cv=none;
	b=6NLi/W9hrqNXDuKgkhDbaiMRLK5ftkXps9gmPQplxIBbp9epHFOKfDl36EdquIvWhMBUXk
	Pyk8MHBz7UC9Hqw9C80W+PLq5yiwxDdjZvFPsCHzyNfizdC38ZXnoRnbU2SrQ8hE0pFiQI
	5Mu29burRu3cJ93bSD3JJrQTm9OrQBc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HGBF7wFouxKA/d6vbapd75R2GfrIL9xJFz5HzcQWUt0=; b=m1KXYnaDk34n2jyYu4ojmJsL5+
	BFHYp5hjMExE6XjdYxqLoHMgkI5Mx/cR/A0K9CPQPBAK0JUKM9MrgqNvcUw/MV9L9YYMU4iUpYbLa
	kBns7OVUbr7jlEonYRJi8RLwq2pJm/uN0iZcALaVtOeLB7nAhYRFozekvokxhAOuNJ2XEtrIQDxeM
	fCaL87SoLqjsCGGgrGPitsOyzN3zN3I6IVP77yk1Dxf53B3uzO7ftd3b85iagn0p++6s2gjg/ntNv
	uel4avF2HFox1BFFwXUVIn0+CfAgTHo5mKivkzTl5/pLFXjzd8ZcvnoJQcAO2TlhGROX3F8gbupzX
	oscl07Tw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzdjK-00000006FgQ-1LlN;
	Mon, 09 Mar 2026 16:45:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8F770300385; Mon, 09 Mar 2026 17:45:16 +0100 (CET)
Date: Mon, 9 Mar 2026 17:45:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>, dan.j.williams@intel.com
Cc: Vlastimil Babka <vbabka@kernel.org>,
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
Message-ID: <20260309164516.GE606826@noisy.programming.kicks-ass.net>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
X-Rspamd-Queue-Id: 5B29A40016
X-Stat-Signature: wfg7g557eq11mrspsytixpnx9qefqa83
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773074725-865642
X-HE-Meta: U2FsdGVkX19gQZvn3TIWXpDzkRM3fHCNAFJ3H6StgVL7UiEJr/aU3lR5myqHhEeFAM5ecHOHn+T90cUacK+4YsmmmxECYhsUM4qgek4hG66SX+yPNUhW74/lIoS1XG638EQ7jOsPZ4EG70aoViipWI7TVBEYLi0H+EvJ+vyOjyZ+5oivaTLpQg3sC7jE0mbzHz7eWmd8Jksm6C3nXYRGj4frQuHjybarzMhwcIcZMutu6PuPPx/Dtnihee+3G0ih0y5Ev6FHSzI8ayeVvBk2uSC4TiMTaCkiytpdQCCHfBMnwKLgiIxgAsgCTOY4i5CdH4Z80lvI5yJLpx7y/jyiG9/UadtFX9AcfnXZBVe0moBGEGdasucniHkOV3Gs/gil4z4uCJsMBClcBIe+Mx+bYk7AIBGUdxBTJ1LfKogSb25oSEbCeB/MBt58Ob3wHS8nDKb4gqc7LIS94mT9bL3f3KdcAva+xzRngxyR3ys9Lo1EFzrnIf6RQ9H1aDs2dogG+bfI8ahjjuVoetJxcYGNVcOZrT6Ek3WXvpIbGslRdnPWGA3nPexisQhhHgcz+QZa6nsxCGjTKDhn28VGZibwojblAntquV2S9hdozrpEILtMy45UKc5gpAfK3ZY8qcxVdkYfvnZSXgm7+CH5QTzQXCaoRMpPKtqS68UNPm52zWSXgd9pV8sdd9OGy7MlY8Sn7bnuTR8NVf0AIn1HWCGV9OOlz4oDukkcFY9Eq3/07kYgPswq7HG9bJMEPIYA8MpK6umJTDDhhk4L+qQ3MQsyXTnJLpj2yzkBlCNVJAmoIopZb742YIKXOapJk5xuyEm8NXB5jNS3UiCR2UJa9SN3U3MiPwHyCSGPnUCYM6fO8MBU/V78YWmvH2daCUxCDv0meTWiaLektQJvM3Exaws+Nd4HCyB9ApdUQrXOpOiQVS0EYHjovdTOIGsB6a8U8qHfxblvhi4dkA/Hdl9ph6T
 ATJGjQlf
 s1bIYq5cJIEZ0SZI6P8KHqlWFsn1ICq7tiFbIklZUNIsp3yZ1spgBvUONATaDFi7qFOKslQ8TOu4vQRHpMOEZta8+EwAJYH8sGZpXYTdcb3IFepVVeXuWjCGBfEckh4aQpVCIRsoUNBZhgA66FfTcCGSZwgO4cPM3RznXotzRjBlWHy9xWoQr1TK4zsMTQ7rV9tuA1bDURgm+rtraON6FUoqV6Y7JcF+nyV/GPlXMqaYZFSdhO0JwtyN9yxpAaI7MLt3+IAznURRVE81W+or4fyqDj6SOXokvgxlCFdcP3TtwZMZzKaCTveNH9i3HFhpk/kuJnN1pKNEAedSB4QOV15gKeHFAzCWx230NROwrYF3SjVjvdnuMJNJcbyIRYf2TiZuAL2whUALerEbizC0S8nZLoDq0t1k12SS0gOKsqp79h33D5hVr4N63Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 02:09:41PM +0000, Dmitry Ilvokhin wrote:
> On Sat, Mar 07, 2026 at 02:16:41PM +0100, Peter Zijlstra wrote:
> > On Fri, Mar 06, 2026 at 07:24:56PM +0100, Vlastimil Babka wrote:
> > 
> > > Yeah I don't think the guard construct in this case should be doing anything
> > > here that wouldn't allow the compiler to compile to the exactly same result
> > > as before? Either there's some problem with the infra, or we're just victim
> > > of compiler heuristics. In both cases imho worth looking into rather than
> > > rejecting the construct.
> > 
> > I'd love to look into it, but I can't seem to apply these patches to
> > anything.
> > 
> > By virtue of not actually having the patches, I had to resort to b4, and
> > I think the incantation is something like:
> > 
> >   b4 shazam cover.1772811429.git.d@ilvokhin.com
> > 
> > but it doesn't want to apply to anything I have at hand. Specifically, I
> > tried Linus' tree and tip, which is most of what I have at hand.
> 
> Thanks for taking a look, Peter.
> 
> This series is based on mm-new and depends on my earlier patchset:
> 
> https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/
> 
> Those patches are currently only in Andrew's mm-new tree, so this series
> won't apply cleanly on Linus' tree or tip.
> 
> It should apply on top of mm-new from:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

OK, so the big problem is __GUARD_IS_ERR(), and that came up before, but
while Linus told me how to fix it, he didn't actually like it very much:

  https://lore.kernel.org/all/20250513085001.GC25891@noisy.programming.kicks-ass.net/

However it does help with this:

$ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc-post-gcc-16.o | grep -v __UNIQUE
add/remove: 24/24 grow/shrink: 3/2 up/down: 296/-224 (72)
Function                                     old     new   delta
get_page_from_freelist                      6158    6198     +40
free_pcppages_bulk                           678     714     +36
unreserve_highatomic_pageblock               708     736     +28
make_alloc_exact                             280     264     -16
alloc_pages_bulk_noprof                     1415    1399     -16
Total: Before=45299, After=45371, chg +0.16%

$ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc.o | grep -v __UNIQUE
add/remove: 24/24 grow/shrink: 3/15 up/down: 277/-363 (-86)
Function                                     old     new   delta
unreserve_highatomic_pageblock               708     757     +49
free_pcppages_bulk                           678     707     +29
get_page_from_freelist                      6158    6165      +7
try_to_claim_block                          1729    1726      -3
setup_per_zone_wmarks                        656     653      -3
free_pages_prepare                           924     921      -3
calculate_totalreserve_pages                 282     279      -3
alloc_frozen_pages_nolock_noprof             622     619      -3
__free_pages_prepare                         924     921      -3
__free_pages_ok                             1197    1194      -3
__free_one_page                             1330    1327      -3
__free_frozen_pages                         1303    1300      -3
__rmqueue_pcplist                           2786    2777      -9
free_unref_folios                           1905    1894     -11
setup_per_zone_lowmem_reserve                388     374     -14
make_alloc_exact                             280     264     -16
__alloc_frozen_pages_noprof                 5411    5368     -43
nr_free_zone_pages                           189     138     -51
Total: Before=45299, After=45213, chg -0.19%



However, looking at things again, I think we can get rid of that
unconditional __GUARD_IS_ERR(), something like the below, Dan?

This then gives:

$ ./scripts/bloat-o-meter defconfig-build/mm/page_alloc-pre-gcc-16.o defconfig-build/mm/page_alloc.o | grep -v __UNIQUE
add/remove: 24/24 grow/shrink: 1/16 up/down: 213/-486 (-273)
Function                                     old     new   delta
free_pcppages_bulk                           678     699     +21
try_to_claim_block                          1729    1723      -6
setup_per_zone_wmarks                        656     650      -6
free_pages_prepare                           924     918      -6
calculate_totalreserve_pages                 282     276      -6
alloc_frozen_pages_nolock_noprof             622     616      -6
__free_pages_prepare                         924     918      -6
__free_pages_ok                             1197    1191      -6
__free_one_page                             1330    1324      -6
__free_frozen_pages                         1303    1297      -6
free_pages_exact                             199     183     -16
setup_per_zone_lowmem_reserve                388     371     -17
free_unref_folios                           1905    1888     -17
__rmqueue_pcplist                           2786    2768     -18
nr_free_zone_pages                           189     138     -51
__alloc_frozen_pages_noprof                 5411    5359     -52
get_page_from_freelist                      6158    6089     -69
Total: Before=45299, After=45026, chg -0.60%


Anyway, if you all care about the size of things -- those tracepoints
consume *WAAY* more bytes than any of this.


---
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -286,15 +286,18 @@ static __always_inline _type class_##_na
 	__no_context_analysis						\
 { _type t = _init; return t; }
 
-#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
-typedef lock_##_name##_t lock_##_name##ext##_t;			\
+#define EXTEND_CLASS_COND(_name, ext, _cond, _init, _init_args...)	\
+typedef lock_##_name##_t lock_##_name##ext##_t;				\
 typedef class_##_name##_t class_##_name##ext##_t;			\
-static __always_inline void class_##_name##ext##_destructor(class_##_name##_t *p) \
-{ class_##_name##_destructor(p); }					\
+static __always_inline void class_##_name##ext##_destructor(class_##_name##_t *_T) \
+{ if (_cond) return; class_##_name##_destructor(_T); }			\
 static __always_inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 	__no_context_analysis \
 { class_##_name##_t t = _init; return t; }
 
+#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+	EXTEND_CLASS_COND(_name, ext, 0, _init, _init_args)
+
 #define CLASS(_name, var)						\
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
@@ -394,12 +397,12 @@ static __maybe_unused const bool class_#
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
-	DEFINE_CLASS(_name, _type, if (!__GUARD_IS_ERR(_T)) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
-	EXTEND_CLASS(_name, _ext, \
+	EXTEND_CLASS_COND(_name, _ext, __GUARD_IS_ERR(*_T), \
 		     ({ void *_t = _T; int _RET = (_lock); if (_T && !(_cond)) _t = ERR_PTR(_RET); _t; }), \
 		     class_##_name##_t _T) \
 	static __always_inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
@@ -488,7 +491,7 @@ typedef struct {							\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 	__no_context_analysis						\
 {									\
-	if (!__GUARD_IS_ERR(_T->lock)) { _unlock; }			\
+	if (_T->lock) { _unlock; }					\
 }									\
 									\
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
@@ -565,7 +568,7 @@ __DEFINE_LOCK_GUARD_0(_name, _lock)
 
 #define DEFINE_LOCK_GUARD_1_COND_4(_name, _ext, _lock, _cond)		\
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true);		\
-	EXTEND_CLASS(_name, _ext,					\
+	EXTEND_CLASS_COND(_name, _ext, __GUARD_IS_ERR(_T->lock),	\
 		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
 		        int _RET = (_lock);                             \
 		        if (_T->lock && !(_cond)) _T->lock = ERR_PTR(_RET);\

