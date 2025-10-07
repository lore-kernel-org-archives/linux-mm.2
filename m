Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC87CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 17:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE818E0011; Tue,  7 Oct 2025 13:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6328E0003; Tue,  7 Oct 2025 13:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBE38E0011; Tue,  7 Oct 2025 13:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3828E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:17:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00B87855FD
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:17:41 +0000 (UTC)
X-FDA: 83971975122.20.3EFAE35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49058A0010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:17:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSh73hti;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759857460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gncSHVZbOxW7cGW0zl/Ex3XVdSueFUalY3IUjdhuFc=;
	b=ka0gNSgz1sSnGscVuRcCroplD4RVrEiUbw0uEjQrr5kOBNeHVnLOg1q8hoOoToGBWtutNg
	dZ/IiGQplKUDP1LA0SMzvOUIfXcNRPHAkb5z+NRCBJ7bPuZPYMpH5hz3QFgt+lqTrN1WU+
	5pdZnvOmyu9izaNJQh5KuAZ8kuX6JQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759857460; a=rsa-sha256;
	cv=none;
	b=dJtTKYxJDxG48k35IqtWaOCqvCg+qY32I4q0OFQ2rDifA/8EpCec6gcL0bpAttTR0Namr8
	Bn+JNTUNEjxyS+RupyQatUqu0vmRNaOFovcMK4JB6ol+tCx/3jSCE36L/y9xqjJoM9p5jZ
	691H0qLvOAk0m63ElOGu4obIgk6fsO4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSh73hti;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4179261D4E;
	Tue,  7 Oct 2025 17:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C66C4CEF1;
	Tue,  7 Oct 2025 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759857458;
	bh=DAFgXC6SxWdL/cD7ojk7LsHsHwahqWWObauM/TTqz9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iSh73htibwbHo797aqyy0ATyVZ1v0pN8Yur3u3gy/4KFT7w4a+bkPaNjov2hdmA0/
	 u8CaPUMV/QxXXeGWwUV2+RjmJzTxT1z20lKVtPGj7hrKe7mJpxepagf5Wfec89hrwe
	 fv21GZ9GJR409dSph3W9pQDUIuGm2A0JeFHeyQrG9k6VfubpS+5BtMRf89QoBUT/mi
	 mzCSAfdpcXMAKf2It86JU6JFMb43A7tMMcpqxBhe1SS0lYsdHswS/uy07jr27NmEuc
	 PL0/ciQMuav2n19IxbfFAWo6vTud4fAd4veAji50d4My7Rh0N1pgu4fAIB0oqVBn0D
	 PS8Ayw2IHr7Rw==
Date: Tue, 7 Oct 2025 10:17:38 -0700
From: Kees Cook <kees@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
Message-ID: <202510071001.11497F6708@keescook>
References: <20250315025852.it.568-kees@kernel.org>
 <20250315031550.473587-2-kees@kernel.org>
 <aOR15Xb6DfolYM0z@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOR15Xb6DfolYM0z@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 49058A0010
X-Rspamd-Server: rspam02
X-Stat-Signature: z644tqa5p36x9yai1haujbdsmsbktaz6
X-HE-Tag: 1759857460-993157
X-HE-Meta: U2FsdGVkX1+tthSfd7zqZYFwcBKESiwsZT+2NViRob/RBwVkcPOc/UwbcmriS7FSuAgrIxrC1s0aw4V5bqs85okZ5hnlVuCfSePJXM0ohg0D2479zz/8e+VCMnjY5Mexv/OYMzPedFvXy/PIrq8Lj4T8d7CAMV7iOWGcc98ki+DfgGKrTKDsNhAp0ZpwvLkeH6PzdM+ymPhw6JogiKbN7WxL5MVTBXuQ9rpwx3DRVd1fthc7JpNaip0+cChw712OlteWNnTz+/Na1w3P/fw7/2vlHQLW5S58Q9Ld/fOx2e5gnkyv41or3b8cQvuI57A3tkU1Ifi0p2WvD1BL16VqSpMjLD+SXupoflhz6/ynlWBMQ/HQ6M0lAJFwZ/asGQc+tTkdxWnYxU0igMk0pEYtvPNhMNge0IFQqE6lS/yOB/7KVpWgEO2ncw6TJCm42OBpIkwZwdGj1Gyy9u77yFlZi/yID/Hd+uADVZsa6wCUxXjSDpBbp2L5xePI6UnxZm0LoFzTfbco2oUu8WlLZ8qMpNBJr5EJc2mmwR1TBWWJHgiD+JYu7Lmq5qY3HPO64qv4uxNIeukXuNaMjRmXAw0h/OFIesw88XyB9EgMhz2+U/F+p5tsVUtW2n8dsiJNHDxwxUaMIF8rZS4HaFIFabpJtnevfKuTJDsZB/unDmzuLrM8wLOLZK68VqL5RlLjmuB4Df6ddynjct836PiOVp9TXI2kP2NtD2wc2+5a3OSQgd9Ov8wcdX9tIj8ePSxNIBDYugvAqWTMtUp5Ctk7PPaqXP3OceKPEXmh0d3+vKdrDCw1hgHop3jfPCs6Meh/PCjUZ8JKRorgX23+/z2sqIww0o9G659mXHo+4YqjimuRTtM3e+I48Jgfqh4HXjqPtG7mcMCUP/ElWqH7NbC+17fHUlkZtIY1KOwMf/6C+ryGSjweE9rBL71D3pMv6pNfQL4wWG1r9qLSV+FYj/X8mXy
 s7j+kLAm
 nA/hI3pQ7lCG4QorJR4+Um/Kh0d8VVQJtIS+YfaJSFhdpFGolfshIwijVPp/JJBS6CSzx2vm4iJGiqRzXyBBHv7WwJPqRSqqmyCiZ2UTykHDx7M49MQUlvPHPaJ8N9v3xymnzrtymSvJYtmvvUF7Xh2fxgmYnuFhBis/4BdLN/dSpfr5GzzrsTLK9wy4FqSULF8+OS378D7FnAd+ruhm6CKx6qkywcNwjHU3Lq5xgNgHtAA5M9oWxqMVlolorVEZhBK0SROfW7/1xTNZYoXn+/k9W9/1su3e3WV1mH8TvIdT2tkRggQLDTX5dSQ672WtyIjI3kHkWZuDDIrViguiVCFZbeDgwaY9bQRUrvNePBga1928AeFWm7f+0MWJxiITyiGx1PeCnitW3fXwB4KI0vTngKSK6fDKjzO4xKNbTC5hK+Xs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 03:07:33AM +0100, Matthew Wilcox wrote:
> On Fri, Mar 14, 2025 at 08:15:45PM -0700, Kees Cook wrote:
> > +Performing open-coded kmalloc()-family allocation assignments prevents
> > +the kernel (and compiler) from being able to examine the type of the
> > +variable being assigned, which limits any related introspection that
> > +may help with alignment, wrap-around, or additional hardening. The
> > +kmalloc_obj()-family of macros provide this introspection, which can be
> > +used for the common code patterns for single, array, and flexible object
> > +allocations. For example, these open coded assignments::
> > +
> > +	ptr = kmalloc(sizeof(*ptr), gfp);
> > +	ptr = kmalloc(sizeof(struct the_type_of_ptr_obj), gfp);
> > +	ptr = kzalloc(sizeof(*ptr), gfp);
> > +	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> > +	ptr = kcalloc(count, sizeof(*ptr), gfp);
> > +	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
> > +
> > +become, respectively::
> > +
> > +	kmalloc_obj(ptr, gfp);
> > +	kzalloc_obj(ptr, gfp);
> > +	kmalloc_objs(ptr, count, gfp);
> > +	kzalloc_objs(ptr, count, gfp);
> > +	kmalloc_flex(ptr, flex_member, count, gfp);
> 
> I'd like to propose a different approach for consideration.
> 
> The first two are obvious.  If we now believe that object type is the
> important thing, well we have an API for that:
> 
> struct buffer_head { ... };
> 
> 	bh_cache = KMEM_CACHE(buffer_head, SLAB_RECLAIM_ACCOUNT);
> ...
> 	ptr = kmem_cache_alloc(bh_cache, GFP_KERNEL);
> 
> It's a little more verbose than what you're suggesting, but it does give
> us the chance to specify SLAB_ flags.  It already does the alignment
> optimisation you're suggesting.  Maybe we can use some macro sugar to
> simplify this.

I just don't think this is remotely feasible. We have tens of thousands
of kmalloc callers in the kernel and that's just not going to work. Also
it's wildly redundant given that the type info is present already in
the proposed series -- the point is ot make this something the allocator
can use (if it wants to) and not depend on the user to do it.
kmem_cache_alloc is just too inflexible.

Doing the mechanical transformation of these callsites is also largely
done already via a Coccinelle script I mentioned in earlier threads:
https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/kmalloc_objs.cocci

https://web.git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.14-rc2/alloc_obj/v4-treewide&id=106fd376feea1699868859e82416d5b7c50866ee
7568 files changed, 16342 insertions, 18580 deletions

> The array ones are a little tougher.  Let's set them aside for the
> moment and tackle the really hard one; kmalloc_flex.
> 
> Slab is fundamentally built on all objects in the slab being the same
> size.  But maybe someone sufficiently enterprising could build a
> "variable sized" slab variant?  If we're saying that object type is
> more important a discriminator than object size, then perhaps grouping
> objects of the same size together isn't nearly as useful as grouping
> objects of the same type together, even if they're different sizes.
> 
> Might be a good GSoC/outreachy project?

I already did this (see kmem_buckets_create()) and expanded on it
with the per-call-site series I proposed:
https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/
https://lore.kernel.org/all/20240809073309.2134488-5-kees@kernel.org/

But all of that is orthogonal to just _having_ the type info available.

-Kees

-- 
Kees Cook

