Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFC6CCA471
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 02:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7C98E0006; Mon,  6 Oct 2025 22:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FA38E0002; Mon,  6 Oct 2025 22:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC6E8E0006; Mon,  6 Oct 2025 22:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF808E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 22:07:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C97971607B6
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:07:49 +0000 (UTC)
X-FDA: 83969682258.15.9A2981A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77067180007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:07:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZpMvRr7h
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759802868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuPt71NmMidGtdlQykkoZsTnnRr+qx1jmb+5gKzLx+E=;
	b=s3ceOb4up8jiGjnyjb9eJMuCDSxP+ZlI9kX8NagyitiXA79j9BVrXtplvHWm2kzKsr/EQ4
	VKcWSNMv47kLxL1NVY2nDoltsq34LZP5nk1m5Z+DRh0gbUoK6d6D5YWaxzPRyx6iTFaOCb
	3GwATGEzZnZ2Ada9Lz4Te9/mYBs2Sxg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZpMvRr7h;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759802868; a=rsa-sha256;
	cv=none;
	b=RxjB9OwO29T5hbp25Lq6vJ17BjtSPN25TnOlPGGcGUOt8KAkhQvOP5VkeD3M+OGIZE8mvd
	84d8mW4CeK/od6z6cOiAZTzGWrxs0WU18BPN9mZxXT2HOUzriuCuhtASP8CqzLsh0hJ5t+
	LoSszsLB/E3iV2sgGCs12jTCyOHI1gI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OuPt71NmMidGtdlQykkoZsTnnRr+qx1jmb+5gKzLx+E=; b=ZpMvRr7hgj3fyfMUpCnXiyu4/D
	x8r4JH14RaG1qEJLKdCABLMvvriTI+vQZvT5ij04S8iZT3GXt0L+XG651Fx7LpsVASxDcivvVTbP8
	YX9Cd1yMkPPdqfzGKv90q2waA3MdXdYYC2ATriV8XHbSuvclbebqTngcLex2LHUHWOHy6CSmvUOFm
	0d/crWkbRhEPGKh5fDOkBr2JTAlMceA6torGF2cCLlbXjYDen9/ou0pjW7rN0ak8yjCPBMeH/Dtx1
	iEE2mcdzJN+h5wq3kqEUV6aW5JT77oyVCeSSdkyH9qvkLNn7oSK9yxanWKz6teiXupLlwMdiwh00B
	cKrtDQKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5x6z-000000064Za-34GJ;
	Tue, 07 Oct 2025 02:07:34 +0000
Date: Tue, 7 Oct 2025 03:07:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <kees@kernel.org>
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
Message-ID: <aOR15Xb6DfolYM0z@casper.infradead.org>
References: <20250315025852.it.568-kees@kernel.org>
 <20250315031550.473587-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315031550.473587-2-kees@kernel.org>
X-Stat-Signature: 4naum8piwk7617x3wm5qeagabnig8gjr
X-Rspamd-Queue-Id: 77067180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759802867-558532
X-HE-Meta: U2FsdGVkX1+qYYVPqdTlxRI6RtXWMpxVJAiEcPfAI1vsptPceiSOHF89L2S0uIm62XjDXAylNk9vcVN07d9uqVt6BG3OyExsSrWZ6p4x+a+AiButwEcb8WLa+VSCAXWpBchDcWKUKC2BGJMxZcLWz6TOplfuQqUCg5uc3kPHnj8Q0qoYhnHAvQlckiQ9DmiRzXQB5lqWeCB6axoPi1zRi2H2HstQiO9lfFb9xnNRJ++U9yPu37/0VqJnj0p2piaVE+wAO7vgVZim7XFCbH/MP3iPQzG3qetoxheXpeXZnXSg1CTsBAddnXVUDF0mmRm1gZkgW59HmMFvr9zfGEVEXomQeXzYVKv/0ayKZHb2pspXYBGxsZ4NQQ4AY2FETzdto/COK5fvoUqNb+yvJdOboHKMqyg5XZoZhNcwpgJI6hydDzvXFBEcFtJzji6RypTn12fyziWD+i0/LNqRj6tSphsOhtCl9vPQ3rOVotr4/3TdoBCfx+rEOxcR3/Ja3YkNuWRiKvNFofl+eMpfi+2b8IyhMbFLGUUEO4/GQdhnJ5asDcz12xHKfbp7fAWIe2XFFw3mULWInlWP3Tqxs6sOBvIaeLAZgdYB21k+PcKqrg8wvHrnO34WlvhwBJ96Q7rFzMR1iTyjtNRn19n6H11MCa5LUm7hchRs3iCOoZMU1gY3kFy6+wgm8DDirV+Y4S1LPM4iRsTFSzVubfw14PGXODGR1QsVRTnGb1h95mc55jPnwQ0jl6kOdufZPUV5xHMnavhoYatq0Gbd5PceUMK+nUtt4KgT83NHmxznOQI9Gz9F6KXpMsbjXRxka7wZ8XzSE3wyNYg5rMnVf1SSM3MNCgEH92iT5ud38v/d1/K/YC4SW0M0FTf4IVFgnWtsQwOaQq5dqyOCElHSCoRmzx7A2IVY1tiYTMwX0yu3kRaNbiAL6N5D/0yNsY+Cs+R9wEW2wKZu955fJhRqzese5Fu
 F+fjVK/0
 qHs1woUm+XhzhAh7ZXCAW8Br0WW7LOoU4H0yNql//iSTXEIaPpXALQSFdmWuOcHXQpwgufakjTdFV7hPVUvxt9bKJ8t3w52o/Jsq9pkb/eRl6I3K6A0kmIvH+xeIOwCmLO4clHP3xFLpDpcjJ6utt0+mkqnraQw5uGpVndgYMVpGn4Y1qJ9vYy13uGH4HhVUmZX7Mxkv2gK/jKaF4YPBVgUAWyiIrvr0DHjDmijmwjjnRMlwAqTlDaJj8I7sYxs+SO9kSiKJJRGsszJ/MxzdDB3OaLKij+CRB0akfJL7atiQX5rM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 14, 2025 at 08:15:45PM -0700, Kees Cook wrote:
> +Performing open-coded kmalloc()-family allocation assignments prevents
> +the kernel (and compiler) from being able to examine the type of the
> +variable being assigned, which limits any related introspection that
> +may help with alignment, wrap-around, or additional hardening. The
> +kmalloc_obj()-family of macros provide this introspection, which can be
> +used for the common code patterns for single, array, and flexible object
> +allocations. For example, these open coded assignments::
> +
> +	ptr = kmalloc(sizeof(*ptr), gfp);
> +	ptr = kmalloc(sizeof(struct the_type_of_ptr_obj), gfp);
> +	ptr = kzalloc(sizeof(*ptr), gfp);
> +	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> +	ptr = kcalloc(count, sizeof(*ptr), gfp);
> +	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
> +
> +become, respectively::
> +
> +	kmalloc_obj(ptr, gfp);
> +	kzalloc_obj(ptr, gfp);
> +	kmalloc_objs(ptr, count, gfp);
> +	kzalloc_objs(ptr, count, gfp);
> +	kmalloc_flex(ptr, flex_member, count, gfp);

I'd like to propose a different approach for consideration.

The first two are obvious.  If we now believe that object type is the
important thing, well we have an API for that:

struct buffer_head { ... };

	bh_cache = KMEM_CACHE(buffer_head, SLAB_RECLAIM_ACCOUNT);
...
	ptr = kmem_cache_alloc(bh_cache, GFP_KERNEL);

It's a little more verbose than what you're suggesting, but it does give
us the chance to specify SLAB_ flags.  It already does the alignment
optimisation you're suggesting.  Maybe we can use some macro sugar to
simplify this.

The array ones are a little tougher.  Let's set them aside for the
moment and tackle the really hard one; kmalloc_flex.

Slab is fundamentally built on all objects in the slab being the same
size.  But maybe someone sufficiently enterprising could build a
"variable sized" slab variant?  If we're saying that object type is
more important a discriminator than object size, then perhaps grouping
objects of the same size together isn't nearly as useful as grouping
objects of the same type together, even if they're different sizes.

Might be a good GSoC/outreachy project?


