Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50C9C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9486B0088; Fri, 25 Sep 2026 11:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869396B008A; Fri, 25 Sep 2026 11:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731EF6B008C; Fri, 25 Sep 2026 11:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4241D6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:27:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1AC7A6C73
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:27:51 +0000 (UTC)
X-FDA: 85252664742.15.5C4BA67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C6D14000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:27:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRpDPLm9;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790350070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IhNTnSowkvoPqsv59kmEwhamP/kmFP819XmCUN0LR4=;
	b=DzA9U7/CqLWXuQqU2zrU4dF1ufAQ6ixTCQlHMFmP2K8TwlUUCiNlChCvPVLeXlcG0j/Xvg
	tvHvBfT2cUDNQgtBMz347WJ/SzHDGPz5HuUnxPC9kq99oO8gEE3D0XuQrGJakydaAptrKo
	a5POGqGW8Mm08lbb/RKmxcjksu1q+so=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRpDPLm9;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790350070;
	b=LKcySwfISjWtFQUzKgbVwT96bsfHghBO5pe5SYfQFHS4i44KrlwlfW8CaMTwRWfdK0RMbP
	OX3il1D8yzV/27nCLauif2inxMPVjDFxDInYC5u6XJ+HBCeKJqAii9lICHuDfVfq4AXsZH
	GIAUr79cJy0/CV/4vVSVq47nNqrhCjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A09C41175;
	Fri, 25 Sep 2026 15:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E151F000FF;
	Fri, 25 Sep 2026 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790350069;
	bh=8IhNTnSowkvoPqsv59kmEwhamP/kmFP819XmCUN0LR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iRpDPLm9lEfcTsdQw2zGOzaMxNQLWbNpple/UcbkgQZUtwxdAyIFGxc8SWOJIWQjd
	 RagltJrIiQfVMf18yVko4L4gnwiX+1mVbTAcZLSGumka2CVgYoA6bCdV4SGymIejC9
	 4qkIxLehFRAjOtWvz8B0LHN/LcSetBZH6SjWTzdQPT5c0z6+LkgobnjFfNK0nhrC0I
	 5eyFATRv8h9F8n+L9JmQEWEZfIfnJsm54vcHibe7FD4IZo4rDxrgP4jtwbXlHT6E/d
	 FC47Opijfmjcgee9oCLrjzavCEVPzyNwebeOdslQs5XggGi5oJwit1lyqhkpRqbELk
	 mTRswlpFOLN6Q==
Date: Fri, 25 Sep 2026 16:27:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pan Deng <pan.deng@intel.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tianyou Li <tianyou.li@intel.com>, 
	Wangyang Guo <wangyang.guo@intel.com>, Zhiguo Zhou <zhiguo.zhou@intel.com>, 
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Message-ID: <araI4WsI0XMXOR10@gremlin>
References: <20260924054301.2330822-1-pan.deng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924054301.2330822-1-pan.deng@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C6D14000B
X-Stat-Signature: iezooi9eaf5q1cwp4zfw6ifox935ecan
X-Rspam-User: 
X-HE-Tag: 1790350070-887613
X-HE-Meta: U2FsdGVkX19FyaE9LVU3Yovcf2e/2mrU96+GDsuwfjH7CDYRX/iO0mbvqW/nI6TEg2XbcOh6uovuM8lZbzstAI6Q0wptk9EXZfBaZNZt21IhkyyrcG+C81KwGoKCFrGFtAe0F/HJZyYP3iqeNIjqnci2xWROkdYCaqiSUaXHQxII4J9X1sfaxhR90b9Q9gU+EY9cASmfSFSHDvDIN6RYDyKYtDAizukgyv+HnIcaPNz6YDyuFHVWJ1o7w7H18JwzBBbTw2KiqUy9l8KDhsOVC4PY/yyzG5jizqQ209Jz29/9BGg0LgD7KVB7kOi6YJQPhHGqCvs7UrWwOqPk5mLtociTHOynL91YvAtyKJcsGJJ7aY157uHgzp3tgWpufphef0NrmM4Q67y9dplbl+wW3yKrDzzTthP8vVt+lOJEu6azPV7r3Mz6o+KvtYnc6LXkMW8II55agsfR/lC2LuemdRppxFM3hZzndaPAx/E+nclPJ2yHv8xeeGGIsfuSE5Pf1cNqSCf0mYKzBE90hpECx8uK2No+57F3ft1Ckq7QAZ1E2/4NwIVUYzbfqHAkzHynM8v7gaItfifSjZ4ZWKZXSh9kJn+CLvix/SZmgTL+XtJ4vMV+J0imei6HZFKqnIVP8jiDfc0aqp8Dg8djvzyb7jSjnv8ScJuDIOyep/MDxHNvEyOBngbCxHwtvGssRh4LoJw+OwHJN/18jRaydshxs1goSfXrrsaYv3qPsCHdp/I7pgjMaM4Ng1zYKsPAXvj1IfJUp8wEiT4LoflvNcr0q7AGlraY2SQ1g51e5F820V7cQMy0spFqymz39W9bxplxb0Z8aAN7JqIdg9FadEaZKsb+rFnIsu/sM7cVm/sp9n4W8mwE4KZPlJAeBy8OioUMPdXvH6sNKxSYrBhT0/v9LCsOpGzDETlQfEYe3bK4wFB0BKIoodXyr2QqoXpj5OyocPTectMBK/mc7dPFAd7
 inMQwC0v
 JGg8cIpQuuyeKjvpBskWt9y1FmqOBwb/lJWJI9fGJKTr0B7l7cLyESPG3CSCY9IRDUZ9yjYdukj+lJLJasJl66kfyC8ursgYlTX1L4lMaJX6L77lRMsK5XC6pXSCvCxtbRamKm+RcXfQPHhyf5Y3NLup5LBxHQ+ZV+TcqnexdVkfeKIBY2oJSUXUoSVslKLhx3gl/xTM/gETt31vK7yYOPYFTvsIgrN5aIJiGde5eSlTKHPQphJSGDFqtpayGqapuWzZgcTMq+nubfRKBzBolwGmieMCnSwp4+jFUC9EB7DAMEhDdeVghRpXLjDMJBDHfqviJTKPoSZ32glRb1KKK4YnAsrCMJeOoEQDNTnbmz265gixycSccWZQYkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry this patch feels like AI schlopp.

Please read https://docs.kernel.org/process/generated-content.html
especially:

	If tools permit you to generate a contribution automatically,
	expect additional scrutiny in proportion to how much of it was
	generated.

	As with the output of any tooling, the result may be incorrect or
	inappropriate. You are expected to understand and to be able to
	defend everything you submit. If you are unable to do so, then do
	not submit the resulting changes.

	If you do so anyway, maintainers are entitled to reject your series
	without detailed review.

You are changing a very subtle and fragile part of the kernel, and you seem
to be an absolute newcomer to mm.

In general we expect newcomers to mm to do smaller work and gradually work
their way up towards larger changes.

I think it's best to treat this as a report rather than a patch, and for a
member of the core team to take this over. I'll take a look.

Thanks!

(Review for below as reference only).

On Thu, Sep 24, 2026 at 01:43:01PM +0800, Pan Deng wrote:
> Splitting a file-backed VMA removes it from the mapping's i_mmap interval
> tree and re-inserts it, two O(log n) walks with rebalancing, all inside
> the i_mmap_rwsem write-side critical section.  For a file mapped by many
> processes that lock is a single serialization point, so the cost translates
> into reduced exec throughput.
>
> While the re-insert is needed whenever the sort key changes, it is not for
> a new_below=0 split: there the new VMA takes the upper half and only the
> original VMA's vm_end shrinks, so vma_start_pgoff(), the sort key of the
> interval tree, stays constant and the VMA is already in the correct
> position.
>
> This change skips the re-insert for that case.  vma_prepare() no longer
> removes vp->vma from the tree; instead vma_complete() detects that case and
> only recomputes shared.rb_subtree_last up the ancestor chain.  Everything
> else keeps the remove + re-insert path.

This could really do with a diagram and a simple explanation.

In general you should rewrite the entire commit message yourself and not
use the LLM output at all.

>
> The case is detected by comparing vma_start_pgoff(vp->insert) against
> vma_start_pgoff(vp->vma): only a new_below=0 split leaves the former
> greater.  __split_vma() adjusts pgoff via vma_add_pgoff(new,
> linear_page_delta(vma, addr)), and linear_page_delta() is
> (addr - vm_start) >> PAGE_SHIFT with addr strictly inside the VMA, so the
> delta is at least one page and the new VMA's pgoff is strictly greater.
> For new_below=1 the two are initially equal and vp->vma's pgoff then
> increases, so the comparison is false both before and after the caller's
> endpoint updates, and the original path is taken.

This is useless description of the code in English, it's not telling me
anything useful at all. Human beings don't have a large 'stack' with which
to hold things in our minds.

Write with humans in mind please :)

>
> Inferring the case this way keeps the change small: struct vma_prepare
> gains no field and no caller changes.

I don't understand what inferring the case means? I think this can be
dropped.

>
> Moving the remove() out of vma_prepare() leaves vp->vma in the tree with a
> possibly stale sort key across the caller's endpoint updates, so

I mean what?

What does a 'possibly stale sort key' mean? And what does 'across the
caller's endpoint updates' mean? Which caller? What's an endpoint? What
updates?

> vma_complete() re-keys it *before* inserting vp->adj_next: otherwise that
> key-driven descent could place adj_next in the wrong subtree.

Re-keys what? WHat does re-key mean?

What you're saying here really makes me nervous. You're changing a very
sensitive part of the kernel and talking about intentionally leaving stale
state around.

This patch cannot possibly be considered for upstream until I fully
understand exactly what this means and that you understand what you're
doing.

>
> Measured on v7.3-rc4, on a 2-socket 192C/384T system running UnixBench
> execl (384 concurrent execve of the same binary), dropping the redundant
> remove + re-insert yields ~14% higher throughput by shortening the
> i_mmap_rwsem write-side critical section during the file VMA splits that
> execve performs on the shared libraries.

This is really unconvincing I'm sorry. Real numbers please with statistical
evidence to back them.

Additionally I notice you have not made one comment referring to locking
anywhere.

This part of the kernel has VERY subtle and sensitive locking
requirements. I am not convinced you understand this, either.

>
> Signed-off-by: Pan Deng <pan.deng@intel.com>

This patch feels like a hack. You are creating a whole new set of very
fragile assumptions that have to be maintained throughout.

Again as above, a member of the core team should take this over.

> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
> Reviewed-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>

Please don't do this.

Upstream is not interested in private reviews. Review tags upstream are
based on review done in _public_.

> Assisted-by: LLM

Thank you for acking.

> ---
>  include/linux/mm.h                |  1 +
>  mm/interval_tree.c                | 13 ++++++++
>  mm/vma.c                          | 54 +++++++++++++++++++++++++++++--
>  mm/vma.h                          |  1 +
>  tools/testing/vma/include/stubs.h |  4 +++
>  5 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..baf489343f86 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4181,6 +4181,7 @@ void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
>  				    struct address_space *mapping);
>  void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  			      struct address_space *mapping);
> +void mapping_rmap_tree_propagate(struct vm_area_struct *vma);
>  struct vm_area_struct *
>  mapping_rmap_tree_iter_first(struct address_space *mapping,
>  			     pgoff_t pgoff_start, pgoff_t pgoff_last);
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 7bbbf15cfbf0..3b81c990aab2 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -64,6 +64,19 @@ void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
>  }
>
> +/*
> + * Recompute shared.rb_subtree_last for vma and its ancestors, for a vma whose
> + * interval changed but whose vma_start_pgoff() (the tree's sort key) did not.
> + * The NULL stop node makes the walk run up to the root, though it ends early
> + * once the recomputed value stops changing.

Again this is a bunch of unnecesary text that is explaining implementation
details and very typical of LLM comments.

> + *
> + * Wrapper because INTERVAL_TREE_DEFINE() above declares the callbacks static.

This is completely useless. Don't write comments like this please.

Having written a lot of LLM-assisted code now in my build speedup series I
understand that responsible use of an LLM involves a _lot_ of human work
checking and auditing and ensuring understanding.

Please do make sure you do this part, it is not optional.

> + */
> +void mapping_rmap_tree_propagate(struct vm_area_struct *vma)
> +{
> +	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);

Is it safe to arbitrarily perform a 'propagate' at any time within the
interval tree?

I didn't notice any comment about locks or when this can or cannot be done?

> +}
> +
>  struct vm_area_struct *
>  mapping_rmap_tree_iter_first(struct address_space *mapping,
>  			     pgoff_t pgoff_start, pgoff_t pgoff_last)
> diff --git a/mm/vma.c b/mm/vma.c
> index f29abb30956b..e1dbfd5094cd 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -365,11 +365,43 @@ static void vma_prepare(struct vma_prepare *vp)
>
>  	if (vp->file) {
>  		flush_dcache_mmap_lock(vp->mapping);
> -		mapping_rmap_tree_remove(vp->vma, vp->mapping);

vma_prepare() is called before performing the work that actually performs
the underlying operation ON THE ASSUMPTION that the VMA is correctly
removed from the tree.

So this would require some strong set of requirements to establish that it
is safe.


> +		/* vp->vma is re-keyed by vma_complete(), if it needs to be. */

What does re-key me? Please don't invent new terminology :)

>  		if (vp->adj_next)
>  			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
>  	}
> +}
>
> +/*
> + * vma_split_keeps_rmap_key() - Check if vp->vma keeps its file rmap tree key
> + * @vp: The vma_prepare struct
> + *
> + * True only for a new_below=0 __split_vma(): the new VMA takes the upper half,
> + * so its vma_start_pgoff() is strictly greater, while vp->vma's (its key in the
> + * file rmap interval tree) is unchanged and its tree position still correct, so
> + * only shared.rb_subtree_last has to be recomputed.
> + *
> + * Relies on vp->insert being assigned by __split_vma() only; the check below
> + * catches a second assignment site whose VMA does not abut vp->vma.
> + */

Not a kdoc, you're writing implementation details in the comment, this
feels like noise.

> +static bool vma_split_keeps_rmap_key(const struct vma_prepare *vp)

This doesn't seem to be differentiating against file? There's nothing here
about file.

And 'keeps rmap key'? What key? What do you mean?

> +{
> +	if (!vp->insert ||
> +	    vma_start_pgoff(vp->insert) <= vma_start_pgoff(vp->vma))
> +		return false;
> +
> +	/*
> +	 * Today only a new_below=0 __split_vma() reaches here, where the new
> +	 * VMA abuts vp->vma at the split point once the caller has updated

'abuts' :) this is not helpful to non-native speakers and is rather an
obscure turn of phrase for native speakers, even.

> +	 * vp->vma->vm_end.  If a future vp->insert user ever violates that,
> +	 * fall back to the safe remove + re-insert instead of trusting the
> +	 * fast path.
> +	 */

Sorry this is just another horrible LLM-generated comment.

And it's totally unacceptable to write 'rules' into comments like this or
to say 'if a future xxx'.

> +	if (vp->insert->vm_start != vp->vma->vm_end) {
> +		VM_WARN_ON_ONCE(1);
> +		return false;
> +	}

This is not good :) we musn't set traps for ourselves like this.

> +
> +	return true;
>  }
>
>  /*
> @@ -384,9 +416,27 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>  			 struct mm_struct *mm)
>  {
>  	if (vp->file) {
> +		if (vma_split_keeps_rmap_key(vp)) {
> +			/*
> +			 * Split paths go through init_vma_prep(), which
> +			 * passes a NULL vmg, so vp->adj_next is never set.
> +			 */

No, you don't make assumptions like this in the code that can explode
later.

> +			VM_WARN_ON_ONCE(vp->adj_next);
> +			mapping_rmap_tree_propagate(vp->vma);
> +		} else {
> +			/*
> +			 * Re-key vp->vma *before* the insert of vp->adj_next
> +			 * below, so that the latter descends a valid
> +			 * search tree: vp->vma is the only node left in
> +			 * the tree that may carry a stale sort key
> +			 * (vp->adj_next itself was removed in
> +			 * vma_prepare()).
> +			 */

This is not great, it doesn't explain anything.

> +			mapping_rmap_tree_remove(vp->vma, vp->mapping);
> +			mapping_rmap_tree_insert(vp->vma, vp->mapping);

'Re-key'?

> +		}
>  		if (vp->adj_next)
>  			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
> -		mapping_rmap_tree_insert(vp->vma, vp->mapping);
>  		flush_dcache_mmap_unlock(vp->mapping);
>  	}
>
> diff --git a/mm/vma.h b/mm/vma.h
> index 024fabe63560..3f791e4d13f6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -23,6 +23,7 @@ struct vma_prepare {
>  	struct file *file;
>  	struct address_space *mapping;
>  	struct anon_vma *anon_vma;
> +	/* Set by __split_vma() only; see vma_split_keeps_rmap_key(). */
>  	struct vm_area_struct *insert;

Again feels like adding a fragile assumption.

>  	struct vm_area_struct *remove;
>  	struct vm_area_struct *remove2;
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index d6136e19a8af..3b5184aeee54 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -267,6 +267,10 @@ static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  {
>  }
>
> +static inline void mapping_rmap_tree_propagate(struct vm_area_struct *vma)
> +{
> +}
> +
>  static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
>  {
>  }
> --
> 2.43.5
>

--
Cheers, Lorenzo

