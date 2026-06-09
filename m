Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC208CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009CF6B008A; Tue,  9 Jun 2026 09:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCC66B008C; Tue,  9 Jun 2026 09:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB796B0092; Tue,  9 Jun 2026 09:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAF326B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:35:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 696B2164B8B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:35:50 +0000 (UTC)
X-FDA: 84860472060.24.821C651
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3BCD980014
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:35:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzMh49Ds;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781012148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fac/qHX5WhfF08NyL9azVrutmt3ga+s6RNOocK4YyzE=;
	b=JBXpxMjM8Ymfj5S86Owv+2zzL6otRjGgHZN+SdENe3M6fm9/FH7LOWK0Ozj++dumDaTY5O
	4SX255fk/Tp0u4gI88pkHgU5W4vifAWagU4Q5WofCApmsf9YQDY14/YTkc9sGpSiedVF6z
	vec1/0/dmc75IpC30VRfCyZ5gYwOgik=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzMh49Ds;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781012148;
	b=puGYQIsvDvqey2+EVWv6M6YMUQmO8Kaku2GKIDMnyDH6SgEpwri2ASA5dA/0FADqBU5/qK
	Lm9galvZoAUOUeR5XDH2Qvd5JjVquxJbhegVCUDeRhT/kyt4wNWoP059jirdbmoptVj9e0
	k5LtdYZlqRhWVLneitl2reszN5on13g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781012144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fac/qHX5WhfF08NyL9azVrutmt3ga+s6RNOocK4YyzE=;
	b=QzMh49DsK+rj/HXv5ZB23N3Vey836AfUWpRWeQB+4uJpkIFKUHr/nYKDkrrc3u9axP/w6+
	G8LnrLfGwv5PmvjS5plSoaMlSixod6mR3J7+nv+mIwdPz2OS4IGGsXKprqsCyP4tQInw82
	IWHwXtMn288yweMaFWfxY47HQQDv6/g=
From: Usama Arif <usama.arif@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	hao.ge@linux.dev,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and slab_alloc_context
Date: Tue,  9 Jun 2026 06:35:33 -0700
Message-ID: <20260609133534.3548059-1-usama.arif@linux.dev>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BCD980014
X-Stat-Signature: ueiw49g4qs5j1ea3hp15sycxp76z7dey
X-Rspam-User: 
X-HE-Tag: 1781012148-777891
X-HE-Meta: U2FsdGVkX1+7PdOq83M2xhHkmJgNnrVTTr7+SK1cnMuxMjVSfCYpouAw3Um26RjLRVgQRP14wOVW2jNd75vkOe5Zlmy0HB1j7gGtfuikxNvFDcGR9EfS1uMAqFSy/khSycyjilAYUbuuZGaXN5kpKsukvmqyNl0u+nyrLXCNDBfTAxxt8c/XaJXS+Dilc07I2SKtuMOLzbDomcMj2igRJiUFtVCskAiGXq4l+YMgT/tmdLZvMxh0B+HAns5mU/8kP009UsWg4hBamQ/HB9LzeHa1sZn1vNRwzmmG4FVsdkz5MWHi5Tf+kzYwJPEMXLd0Nxjrt0bf5ABPU5jfHuuSxDJb8BOrvbYBZI4wyUWFBhfXbZYq6FNNOXsgJMpdcO3OaFyWiIztO9mQrrsp448f4lkKUdr8vRXe1wgfqNsxj/E1dMcZc/iQjd8OyubbPN4In0jOMWV90Z4n83RfrE40UFZtnEP4jGd87Rx7qRmyATB3ElpVizClNB3LOBzYE6VhYe+o52zQQS4mXEZy2DM+rKQT7hD+djr5UcB6ABAc1q/+6nUURrif/1bH6Wrm2SX9yE46d1rAz9BeD3emUaDEOCLR//Kxyt4rVQqDL8P7RB3AglJomLpiWjptgYmGzyKaAecPHh7R/W13dAohS1f+79RoAjJTzGRj8OnLmjZw4KFPY1d2phoWQ0cGQcvpovJr1Io2WNaxSxtJP2aI9zKHtVOPv+RJGVQOZhlLQdDF9/v70qZbg5vLv6hGN2PAydAdULEZDP8YUig5fE+yQOgsifKwFcZdjH/+wTvHxHhnf/wthUZpG60HieH549f1FHoDKtKvuxbHOOg3jAoVhPr6QpnEeKMzMPAy5Q4URTfkCq0r/MZ32/3kWZIK4dI42OWhtHHWXnM6H15VjWSgI3ljgKJm81DUACXJNOYNE2TDZdoqWub0L9wj3UPvbF/0IY3zLORaIn/HD8qXQv9hvEQ
 oIoXtvS6
 sRCTPiy7ClL8/nFwMOqj4VAd/B5qbJHyutJlEVm9F/M242Szwj3HoD82gnaFf/Z9a51lHa6nkHMWdwW6zWVni/93l2wgDcii5fPhkY4pQzS+QYHpxUbCzXgb/HUH2PalJgqu8i+oQBGVX6xksV0TzGeepkn3VSYj4f9wuI7mIF4Q0EIS6Xm4sJTmlb+xYRGiD4RPg+JzC0IMMmXOvZhMQ9T2IZK9LJSECkDVPJVIhjG7N6HDs3XRbiGM7uCz3yR6jc0O2rgDI0hUxhgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 09 Jun 2026 11:17:45 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> This series is based on slab/for-next. If all goes well, it would
> hopefully go to slab/for-next soon after the 7.2 merge window, so any
> other work can be based on it to avoid conflicts, as it touches a lot
> parts of slab.
> 
> Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
> 
> The slab implementation currently relies on gfp flags to convey
> some context information internally:
> 
> - The absence of both __GFP_RECLAIM flags is interpreted as "cannot spin
>   on locks", and intended to be used by kmalloc_nolock(). But false
>   positives are possible e.g. during early boot where gfp_allowed_mask
>   clears __GFP_RECLAIM from all allocations. This leads to unnecessary
>   allocation failures and workarounds such as fd3634312a04 ("debugobject:
>   Make it work with deferred page initialization - again").
> 
> - __GFP_NO_OBJ_EXT exists and takes up valuable bit in the gfp flags
>   space, only to prevent recursive kmalloc() allocations for obj_ext
>   arrays and sheaves.
> 

Hello Valstimil!

I think memory allocation profiling uses __GFP_NO_OBJ_EXT, and I dont see
it being removed in the series (hopefully I didnt miss it).

Adding Hao Ge in CC who did this in the commit:
mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list


> The page allocator uses its internal alloc_flags to convey various
> context information, including ALLOC_TRYLOCK (meaning "cannot spin").
> This series copies that concept for the slab allocator, with its own
> slab-specific internal flags:
> 
> - SLAB_ALLOC_DEFAULT - no extra flags (the value is 0), but explicit
> - SLAB_ALLOC_TRYLOCK - do not spin on locks (used by kmalloc_nolock())
> - SLAB_ALLOC_NEW_SLAB - replacing existing 'bool new_slab' parameter
> 			for allocating obj_ext arrays
> - SLAB_ALLOC_NO_RECURSE - replacing usage of __GFP_NO_OBJ_EXT
> 
> To reduce the amount of parameters in various internal functions, we
> additionally introduce slab_alloc_context (also inspired by page
> allocator's alloc_context) for passing a number of existing arguments
> and the new alloc_flags:
> 
> /* Structure holding extra parameters for slab allocations */
> struct slab_alloc_context {
> 	unsigned long caller_addr;
> 	unsigned long orig_size;
> 	unsigned int alloc_flags;
> 	struct list_lru *lru;
> };
> 
> This also replaces the existing struct partial_context.
> 
> The last necessary piece is kmalloc_flags() which can take the
> alloc_flags in addition to gfp flags and is intended for the recursive
> allocations of sheaves and obj_ext arrays, so that both
> SLAB_ALLOC_TRYLOCK and SLAB_ALLOC_NO_RECURSE can be communicated.
> Internally it decides between kmalloc_nolock() and normal kmalloc()
> depending SLAB_ALLOC_TRYLOCK.
> 
> The rest of the series is gradually expanding the usage of both
> alloc_flags and slab_alloc_context as necessary, with bits of
> refactoring. Then, __GFP_NO_OBJ_EXT is removed completely.
> 
> Note that some usage of gfpflags_allow_spinning() relying on absence of
> __GFP_RECLAIM remains outside of slab (and page allocator) in memcg,
> page_owner and stackdepot code. These can thus yield false-positive
> decisions that spinning is not allowed, but should not result in
> important allocations failing anymore.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (15):
>       mm/slab: always zero only requested size on alloc
>       mm/slab: stop inlining __slab_alloc_node()
>       mm/slab: introduce slab_alloc_context
>       mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
>       mm/slab: add alloc_flags to slab_alloc_context
>       mm/slab: replace struct partial_context with slab_alloc_context
>       mm/slab: pass alloc_flags to new slab allocation
>       mm/slab: pass alloc_flags through slab_post_alloc_hook() chain
>       mm/slab: replace slab_alloc_node() parameters with slab_alloc_context
>       mm/slab: allow kmem_cache_alloc_bulk() with any gfp flags
>       mm/slab: pass slab_alloc_context to __do_kmalloc_node()
>       mm/slab: introduce kmalloc_flags()
>       mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
>       mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for sheaves
>       mm: remove the __GFP_NO_OBJ_EXT flag
> 
>  include/linux/gfp_types.h       |   7 -
>  include/linux/slab.h            |  14 +-
>  include/trace/events/mmflags.h  |  10 +-
>  lib/alloc_tag.c                 |   2 +-
>  mm/kfence/core.c                |   6 +-
>  mm/memcontrol.c                 |   5 +-
>  mm/slab.h                       |  16 +-
>  mm/slub.c                       | 423 ++++++++++++++++++++++++----------------
>  tools/include/linux/gfp_types.h |   7 -
>  9 files changed, 288 insertions(+), 202 deletions(-)
> ---
> base-commit: 500b2c9755301742bdbb61249511ac11a4665dae
> change-id: 20260601-slab_alloc_flags-25c782b0c57c
> 
> Best regards,
> --  
> Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> 

