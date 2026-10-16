Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED19CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092166B0096; Fri, 16 Oct 2026 11:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045306B0098; Fri, 16 Oct 2026 11:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75B56B0099; Fri, 16 Oct 2026 11:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE0886B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:46:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28583A04CD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:46:21 +0000 (UTC)
X-FDA: 85328916162.30.FADF0CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 799A8140009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:46:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVx9EcwD;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792165579;
	b=l4R1iRCkJVlVm07jdrOSZzchPAK6yaCb9hw/Q6YzjPBzAbEHQL7Tn/Fl0e7sWDenRVVz17
	jnwaiQuOf/GBZbBRhbPL3na4AvStK41pKOItxPdhgcDfvlxh2SaBh6kV2uZGOsl0QUi6Kq
	8f28IxmoORvomvxmej6Ww2YNYfAzFmQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVx9EcwD;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792165579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOMjyU7CzLbJbrCap44c243pX9ytDZamFQgQxTNQj6o=;
	b=Z/rDhLuIC6MqXgB9qfcOIk3YL28dTe4BNC97/zZoNdhMcstcjGt6o/zgCX1apSz+7MIhHU
	kkyyTLNPhwNNOeYzzab6kUlnmZRmF7CeSaa/J+fCA0Yx5oQPzLqX0uEp/MHQRgwUR15Rme
	/HuainfhpENIHhuNGMnt06gD2kZrzfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B855360008;
	Fri, 16 Oct 2026 15:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072DA1F000C4;
	Fri, 16 Oct 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792165578;
	bh=fOMjyU7CzLbJbrCap44c243pX9ytDZamFQgQxTNQj6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iVx9EcwDbQvJp23ILFFq2HZCwgXzZHcIy0UKZgg4oGXtCd85a4qcPZjkUVgYSBLtA
	 e9mu58EHFYY9UU3H7dsBpgA2meOv66XkOBrciW4bAOJeda5E3clShcTG8h6L7WB8zf
	 UUYFbWBzif4NGJEiVuhnpCRPBrqcLMSsw9itZrd+ZTPtbnhhPDTC2dmquB5L92xOiW
	 V1VZ3y+AxSYW87drIyMHaXbSX/tc5KtiZHqh2HqbOMyWTkX+AY8CYo0rQkEh5hc14p
	 2Fc7kmhQQmXfJgA1PbfTbHuueg1++87CbNNz/Rx0EZXVncC5FM9DXhmr/YPe2Cs5Iu
	 deA2WG6tvfi4g==
Date: Fri, 16 Oct 2026 16:46:16 +0100
From: Harry Yoo <harry@kernel.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, Vitaly Vul <vitaly.vul@partner.samsung.com>
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <atJBK6hWYh2AqXwK@thinkstation>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016132510.789715-1-nickolai@csail.mit.edu>
X-Stat-Signature: mo1ucmrkg5katz84ekg755kro8eqju3p
X-Rspamd-Queue-Id: 799A8140009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792165579-477619
X-HE-Meta: U2FsdGVkX18qxzIXawsrbp3UQzZepZuQmGLJr6cOachpwH4hseNN6IaCP1n4ynQgNbDZn4T3RD8pzk34u1acEd9pSTziU7j7YOFM0QYLCdPYXgtrsNaCovhLehcwqT327YHBPmYNFyZdCiHqG8kW54YdaPmv+EdwBNmo68az8NxgnZ37cIFFRQqMSaWBQJSYG9PswbG+lFyjCV2UvBKquUJZ2Ngcvu4pVWEe0Q+tGxuLxrlw3Q2KXTHKl2WMmPS261KinE5zNEKnXrli26h0auY23C/2RezMkiqLgFS88//5Jgyq1kIdt+9k4C2+FAzfvZQ4LG3XqrGqkraRSKWaHTd/42Sl2hsagqlOsjcUKcCUw4IIXMvc/8WjELSKK5Oh1mxTgQYBQSJqJQrVpOxknuzc+3z38J9ZdS4O6wepPyCVnMlLgMotkky1csGLFQXvpJqI4sUAHehmtxjqBsE1zfhiSwvk+haR3zkLtX0YH6QHA1ELKJtXZ4hIWtZxqSTmYgeS+msG6slQZYzsyH6nmINYQ/qbMKkBGhcOhM88MV7F3m/7sFlZ8gaTP7UyborsvRe80BH+i7nF+dllmUB2jvsNBrejDXR4hIZqGp80LAIyDBQTHinFa2kWoYQl5fWt7qBpxiv7X+Gb1DejYqPLrCvis5S5EUTS2gORmZ8+lFns0lHwsVujYeRoiRpMLo+OrQoJIl0jN4PUZ/RxQjBb1pRRXNWDXfW3cPs2TxonBPdq1sMhaX/M7G2CRym8nO/DplvfOC9KdpFYfTXoF29FK/2YCf6dmtWXsL/lHSVdVTZYji8pJ9zOJwjliPBchZFGhS/AC0rMhe5MuqsIU36JNiCygnNH5uyV4UGnzwforTcSy3SIzm78y2XMFjVCaQ6h1ADjOVUXiii60BkjjMzZxw2hqxku61toaPkcPt8F6NnspaPaaomMO+HllX4G7zakvUvFF0eU5N9gyRvjxeZ
 IwjWGg+5
 jJYse7VfMoYqHVw6G2VTNLvwi7MVZGTPO0YXDChr1Kew23hacm1sMvbULHNasJi16hjchQ33t8x130QcsVkBx9X/lbsJJ1r5K8A+d4Dnk5g64x6458Kt/ULw+pjEyhfuRMo+FFXY+AZjuT14+mN7YbbHCv1WXFjAqYRvgXz0mOG1UeWEb471icU9k2tb4qwSH+95LbdX9m7k8oMiCEQmq33gLfqdJLNYV7VGe4SzV1KCmYpwNXftA3ZBj2/5ac506E1h76r7kH515jxDa1Y+77Tt1QIg7WILByyKPfQ5JHa7ox+LSxeJgPSRiupb1ILOzA86+MnmDhJz6tX2jU5Wt9IwiGvKfB7AMpoqrtyFDOXId/xA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc Christoph Hellwig and Vitaly Wool ]

On Fri, Oct 16, 2026 at 09:25:10AM -0400, Nickolai Zeldovich wrote:
> mempool_resize() shrinks a pool by dropping pool->lock around every
> free_fn() call and, once the pool holds no more than new_min_nr
> elements, stores new_min_nr into pool->min_nr.  new_min_nr was only
> compared against pool->min_nr before the lock was first dropped, so that
> store assumes nothing changed meanwhile.  The kernel-doc allows
> mempool_alloc()/mempool_free() to run while a resize is in progress and
> the grow path also copes with concurrent resizes ("Raced, other resize
> will do our work"), but the shrink path does not: while its lock is
> dropped another resize may shrink the pool below new_min_nr and a third
> one may grow it again to a size between the two, replacing
> pool->elements with an array of exactly that size.  Storing the stale
> new_min_nr afterwards leaves pool->min_nr larger than the elements
> array.
> 
> Interleaving on a pool with min_nr = curr_nr = 10:
> 
>   CPU A: mempool_resize(pool, 8)
>     takes the lock, 8 <= 10 so it shrinks: remove_element(), drops the
>     lock, calls free_fn() and is preempted there
>   CPU B: mempool_resize(pool, 3)
>     completes: curr_nr = 3, min_nr = 3, elements still has 10 slots
>   CPU B: mempool_resize(pool, 5)
>     completes: elements = kmalloc_objs(5), min_nr = 5, curr_nr = 5
>   CPU A: retakes the lock, 8 < curr_nr (5) is false, stores min_nr = 8
>     while elements has 5 slots
> 
> Every later mempool_free() sees curr_nr < min_nr and add_element()
> stores the returned element at elements[5], [6] and [7], past the end
> of the 5-slot kmalloc allocation: a heap out-of-bounds write, i.e. slab
> corruption, a KASAN report, or a crash in whichever unrelated object
> sits next to the array.  The invariant that breaks is that pool->min_nr
> never exceeds the size of pool->elements; every other path that changes
> min_nr or elements keeps it.
> 
> An in-tree caller can hit this: fs/smb/client resizes the global
> cifs_req_poolp from cifs_demultiplex_thread() (grow, when a TCP session
> is created) and from clean_demultiplex_info() (shrink, when one goes
> away).  The two are coordinated only through the atomic
> tcpSesAllocCount, so mounts and unmounts racing on one client run the
> resizes above concurrently; pool->free is kmem_cache_free() there and
> the window is a preemption inside it.  The other callers
> (block/blk-zoned.c, drivers/s390/scsi/zfcp_erp.c) serialise their
> resizes.

The bug looks valid in theory, not sure if how easily it can be
reproduced in practice as resizing should be quite rare.

(A bug is a bug and should be fixed, but no need to hurry in this case)

> The shrink path has stored new_min_nr unconditionally since
> mempool_resize() was introduced, while the grow path has always
> re-checked pool->min_nr after reacquiring the lock.

So it's Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") ? 

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=6892188b54d484098b79b0c9813c20e543124e2d

...from a historical commit before git era, 1da177e4c3f4.

> Re-check new_min_nr against pool->min_nr under the lock before storing
> it.  If a concurrent resize has shrunk the pool below new_min_nr in the
> meantime, keep that resize's min_nr (and whatever array it installed),
> as the grow path already does; otherwise the store is unchanged.  The
> elements the loop has already freed stay freed, which is right either
> way because the pool's limit is now below new_min_nr.
> 
> Found by formal verification of mm/mempool.c against the kernel binary.
> Reproduced with a userspace build of the affected functions in which the
> free_fn() callback drives the interleaving above: before the fix min_nr
> ends at 8 with a 5-slot array and the next mempool_free() writes past it
> (AddressSanitizer heap-buffer-overflow); after the fix min_nr stays at 5
> and the element is handed to free_fn().  Not reproduced on a running
> kernel, where the window is a single preemption inside free_fn().
> 
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>
>  mm/mempool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index cb74e718b2c6..95533e2975ce 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -378,7 +378,9 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>  			pool->free(element, pool->pool_data);
>  			spin_lock_irqsave(&pool->lock, flags);
>  		}
> -		pool->min_nr = new_min_nr;
> +		/* Raced, the array may now be smaller than new_min_nr */
> +		if (new_min_nr <= pool->min_nr)
> +			pool->min_nr = new_min_nr;
>  		goto out_unlock;
>  	}
>  	spin_unlock_irqrestore(&pool->lock, flags);
> 
> base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
> -- 
> 2.53.0
> 

-- 
Cheers,
Harry / Hyeonggon

