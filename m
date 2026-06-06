Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48610CD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 20:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326946B0088; Sat,  6 Jun 2026 16:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7996B008A; Sat,  6 Jun 2026 16:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDDB6B008C; Sat,  6 Jun 2026 16:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1024A6B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:19:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CBBC8F1E1
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:19:13 +0000 (UTC)
X-FDA: 84850602186.29.AF02873
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46561180003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:19:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LKiw7YU7;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780777152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qn/GwpLQrIFJP6RrB5tk+eCxp+XsTc6Qi46I9/Pk/bg=;
	b=0eC6pE5RTEBI8m+romHWXoT7QjrrupPzkR9ijh2CnZ1rzHIs1Ne+jplwkmQ7Wyo/hOIJcq
	rFvGPlJyo5WReX5UXWm1PbfFoHqRCSQqfWsx0Z3xhRsXjJU2LLa141WeJmG7lTsVt1Q6VG
	bQj83WhISau1HHInXhWp6IyWygOKoyc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LKiw7YU7;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780777152;
	b=1ijw37VE2hgBtZpMlNvvah9qw7YSEILNoyy+Ibcd7gIRVsxAs2QTd9spBV2d9I5z+/6yAL
	TywVqnjfcX79+aq0QGQ6U5mh+dYzGs7q+50mqOw+DzZtSaPzMeh+1nLRWQ4If1NfqsMLUu
	OMkyk+ftEXzyXwtdPHlGCQfkzdZvYy0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qn/GwpLQrIFJP6RrB5tk+eCxp+XsTc6Qi46I9/Pk/bg=; b=LKiw7YU7YB5iPci7joQBn8opCX
	QPc4PL+SnIhhQ3mi23T/jG60gOhikMnbAGJW6eqbnMZKNGy2ei/X/uRgLrWL7puLUSdZUwsgu/6EJ
	ktBNNPXlQR8OYKMHom7a1UajkkvcgYUAzx2ONDX5DCPBeYJFltj3ogCxfH15i0cdA2+Ewk//R70ya
	Qy+Bkid7+kqgOrOUEZ++1Lk91q3rLOHxw0jpFf690VV6h3Prb8ZNRldrGiSwY1DnboVUtGXfdP+F7
	iVWhHot6bDPX3Aej+0kdQue9LTn6F43cxhWGwUG9oJayhPCgyI1Hepdr/X7XIGquTs9XzwyuScixg
	xHD6eaoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVxU0-0000000ApOr-3385;
	Sat, 06 Jun 2026 20:19:04 +0000
Date: Sat, 6 Jun 2026 21:19:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
Message-ID: <aiSAuP-qEhH_RoCn@casper.infradead.org>
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606155856.15548-1-med08elkadiri@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46561180003
X-Stat-Signature: hc3ws1xzn5c9o3j3ho85htq1hc3cgch9
X-Rspam-User: 
X-HE-Tag: 1780777151-900418
X-HE-Meta: U2FsdGVkX1+9gMG0AJrOpAU6af8oLO/G1x3e74ifZ1F4+Q3Fjf15o1OvaerbsYvkUhyIZC0kpAgxjX4qahgcc/EZwEYakrzvjW8eU+V+pRyPYZqH0/wDPDJwihB1gVlcd25D6ZfD5NAwaCJI1ZYIud+dQ010iOhWvPo6frJYX+U0Mq65aM8iVTA7eZPmBlA8nhWha/IT/yvQ4X0dq/NvDSn+Alm3mzI8ZpEuxZJInxu7ynLV0SeZko6EPIiUWu33pThQrwotHlB9Z9XYnOzzzwsaivZOQDPX/k68XuhXmfqtA7/Q7Z7qIYincVBCDbJZJWeJjeabeYWYwENFgSGwclxkCth28dNRFuZYyljQRsltYAClPDeMLO6tzk/74nRv6FHete5jFCkhQcn4fnR+T34F1SP7J81ohoryR8YJbtlx1EBFM3gRb+A2sirFQzgVHf9+p17TQswSNkIIUfiGqYTdjuZGp20m4Kh+XXRwgB/ZtF0Rnqodlhm+ZvhZREF1rrmWRwf/zaQ40FVemT0b0jMPG0JExZ3rxzsbsrOswuCmmPJNwXdrgBFb6Dj/w/3lwqUmUVlyKQYFiuX/J76+PLJVADRfwtUR6dE1X4H6TnNpHGQYPY6dm5wtQQ897DqzMbrjOfU/FwDmWSo/7cOvej/ofgjK+aiOqORsxpn43yfRV28UY2DBpaRL27qNTI7F9QmQOKEb5qAf1iwsWvWTCOLB4lBf8VxaHPX6W7odcaaLqL5GwFBbWbKZMTh7WvEJQ2/kKopFcXTbhfWXo1KOfC9bLamCnH838QHv/xuKiYL8S90TWpoxOluLqL/yldN6jFjhtwYQIUeydgW46qt/FV4yxgC3WkI3rMxLNLViiR4CJ40adRqlhkrAm0R4dyLnd4hD6erRVrdolQDCISQcgTCrIMvZRvZYdLQM4VvogPOIZM5syG/i1IzRXgsUgKwJhw62yCX/kZqG67Rvq1k
 SRLppT4d
 LfnTtvWcKcl69nFEdTJncv3cUXHZFUVg8EODVB/2ZN1KyxfQ4AwJpZnMSJfdYvdNr6tdaj01uGnEZqeAqf1ITh8/+LciSiI/FuxT6Mi2FH1JDL7c4NQsb1ydEFv9YMsM06402nyy7KVydNCS4y0mJ96MSLlhU6X2qf9S5PPak5qHMkdOI/eNi/4BzPMcb3OBFDX0fvSwEm7jFTfS2lfsdQ5T5lI0Y2uCbxbnRpE/wZ/Li67Fstil47vmm1iMUJwxLbO37Ru2PQt/ZYvW493lSq9gU9qjjKPc3E/jc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 06, 2026 at 04:58:55PM +0100, Mohammed EL Kadiri wrote:
> +The SLUB allocator merges slab caches with compatible size, alignment, and

More of a question for Vlastimil ... do we want to continue to
distinguish between slab (the API) and SLUB (the implementation)?
I don't think we ever want to go back to a situation where we have
multiple competing implementations of the slab API in the kernel.
So shouldn't we deprecate uses of SLUB, particularly in the
documentation?

> +flags to reduce memory fragmentation. While this improves memory efficiency,
> +it allows objects of different types to share the same slab pages. This

s/ pages//

> +enables cross-cache heap exploitation, where a use-after-free in one object
> +type can be leveraged to corrupt an unrelated type.
> +
> +The `SLAB_NO_MERGE` flag prevents a cache from being merged, ensuring it
> +receives dedicated slab pages.

s/slab pages/a dedicated slab/

> +2. *Actually mergeable*: The cache must not already be unmergeable.
> +   A cache is already unmergeable if any of the following is true:
> +
> +   - It has a constructor (`ctor` argument is non-NULL).
> +   - It has a non-zero `usersize` (with `CONFIG_HARDENED_USERCOPY`).
> +   - It already has `SLAB_NO_MERGE` or another `SLAB_NEVER_MERGE` flag.

I don't know if this is good advice for users of the API.  It's true
that the slab will already be unmergable for these other reasons, but
it's harmless to specify SLAB_NO_MERGE in that case.  And it
communicates intent.  And in case somebody removes the ctor in the
future, or we decide to change which flags are in SLAB_NEVER_MERGE,
the slab will still be unmergable.

> +3. *Bounded allocation volume*: The cache has a predictable number of
> +   active objects, so the memory cost of dedicated slab pages is
> +   acceptable.

I don't understand why this is a criteria.

> +How merging works
> +=================
> +
> +When `kmem_cache_create()` is called:
> +
> +1. If `usersize` is non-zero, the merge path is skipped entirely.
> +
> +2. Otherwise, `find_mergeable()` in `mm/slab_common.c` searches for a
> +   compatible existing cache. A merge is prevented if:
> +
> +   - The `slab_nomerge` boot parameter is set
> +   - The new cache has a constructor
> +   - The new cache's flags include `SLAB_NO_MERGE`
> +   - No existing cache has compatible size and flags
> +
> +3. If a compatible cache is found, the new cache becomes an alias. Both
> +   share the same slab pages.

This feels like documenting internals rather than documenting how to use
the flag.  I'd drop it entirely.

> +The cross-cache attack class
> +=============================
> +
> +Cross-cache attacks exploit slab merging to achieve type confusion:
> +
> +1. Attacker triggers a use-after-free in object type A.
> +2. Type A's cache is merged with type B (they share slab pages).
> +3. The freed type A slot is reallocated as type B.
> +4. Attacker uses the dangling pointer to corrupt type B.
> +5. Privilege escalation.
> +
> +CVE-2022-29582 demonstrates this technique: an io_uring use-after-free is
> +exploited via cross-cache page-level reallocation to achieve root.
> +
> +`SLAB_NO_MERGE` prevents step 2: dedicated pages mean a freed slot of
> +one type cannot be reallocated as a different type.

Not sure this section adds anything to what was already described.

> +Tradeoffs
> +=========
> +
> +*Memory*: Isolated caches may have partially-filled slab pages that
> +cannot be used by other types. For caches with bounded allocation counts,
> +this is typically a few extra pages.
> +
> +*Performance*: Zero impact on `kmem_cache_alloc()` and
> +`kmem_cache_free()`. The only effect is at boot when the cache is
> +created.
> +
> +Relationship to other mitigations
> +==================================
> +
> +`CONFIG_RANDOM_KMALLOC_CACHES`
> +    Creates 16 copies of each `kmalloc` size class and randomly assigns
> +    allocations among them. Only affects `kmalloc()` users. Does not
> +    affect named caches created with `kmem_cache_create()`.
> +
> +`SLAB_TYPESAFE_BY_RCU`
> +    Delays freeing the slab page by an RCU grace period. Does not delay
> +    object slot reuse. Does not prevent cross-cache merging. Solves a
> +    different problem: safe lockless access to freed-and-reallocated
> +    objects of the same type.
> +
> +`slab_nomerge` boot parameter
> +    Disables merging for all caches globally. `SLAB_NO_MERGE` provides
> +    the same protection selectively for individual caches without the
> +    global memory cost.

These two sections also feel unnecessary.

