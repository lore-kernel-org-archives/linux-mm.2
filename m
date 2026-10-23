Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB75606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=kMkUSEcD
Received: by kanga.kvack.org (Postfix)
	id 7DC646B0B81; Fri, 23 Oct 2026 10:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CA96B0B82; Fri, 23 Oct 2026 10:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1EF6B0B83; Fri, 23 Oct 2026 10:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 496E26B0B81
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:46:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5BFE140120
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:46:01 +0000 (UTC)
X-FDA: 85354165722.11.1D8D377
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 31E09100005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:45:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kMkUSEcD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792766760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fiO3+QdsE/BfanTbW7upLzdgUQUluHoCjZtUMQ3uBk=;
	b=RWDCJlF/tTppC/TuBGlXYOZBcRsK//ChVvrKKeUY0WTz5VbNj59c0iBr/Gx8AMX2UusxMD
	S8U27/iw84FkN7evPqb1t5fuXkCBvOXioqsWZ7/T/agmZ+aQ2C2Yz9W5gmgoDEy3TgN+pB
	15Xsp3ZzxJgG8Dsta7klnekdrseYyRo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kMkUSEcD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792766760;
	b=WoaKZJuJQkqzJEyqo+scBrPI+FHUDQaOt5x8AKUkxXA4CuDdcz9CZQPuRIf0pOXFifr3Q3
	GksvjhdhJNc+4p9pYrEZbY4RPAJwrViIhx2ctTGcZQst86dJP2Turk6inx2GXChcxXS8wN
	5jFxeLzcXdx7aHCSGwQSzQYrjh8pbag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/fiO3+QdsE/BfanTbW7upLzdgUQUluHoCjZtUMQ3uBk=; b=kMkUSEcD/LSfqTU7gNyl/t4tZF
	zdvV22g3LYXk8cowEg4+mfo+xrqqvN48gAscXUOli6NUPVPGIk3knPM8cFUNCVB3ISM9a6F+t5f/k
	9vKDliaAhsHfqVaJqWcH4TIl25cesWtdJtXyG+3/Rtcug72SVWSsUJKfJuqVP6oS0TquTIkAz+dD5
	FDQWoMgjvTAxG5ar2cABmn/NW1JprWWG7txkNiQP3pBwABKI8wk4PAbRpa7xi5YCAQjg92aYp22G6
	9DHf3VZZgnYUxt4hEaDnpqA42SLa4Gk2HH+L5/NKY1RwnwyB+G+I8uWmnJLJRZ3RiYF1aSUi2gCm4
	KlBsWx1A==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xKGWq-0000000CF1Z-05ce;
	Fri, 23 Oct 2026 14:45:56 +0000
Date: Fri, 23 Oct 2026 15:45:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] xarray: clear the new head's parent before freeing
 the old head
Message-ID: <attzI4sj2Pagmvkd@casper.infradead.org>
References: <20261012202549.772887-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012202549.772887-1-nickolai@csail.mit.edu>
X-Rspamd-Queue-Id: 31E09100005
X-Stat-Signature: r8zii9drg97aiaukcccigzow7iiuxcit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792766759-107713
X-HE-Meta: U2FsdGVkX1/EgxoyoQwqMCAz9JSA1jn4e1/BiBk1wLXZaMQOXrF96IfzPGBSDbyc2w4vBDi5kaFvyg0N25ajcljBigqpOOnpcj6OdOpuQMN/wV2waAB5gxYUmloBH9NECOPew2J2Udez9Cu1H/rntkWQ0RLeKBqZPUBoE7qXKn9A9IjYSaqifUxinAYyFW6eVNTKP31+8Uj+lbfYOKcUVhFqEX30192WWZvZ3DDJGXWwqjtu9AtcuVy9W5EZHxaF+m6q1vJ+8K6TQFnqQ2XFK5AINyzbja84RoOD9Kxf5r/sJwWVAUHtjOyOEtQ/HDQlOTdjr8St1KrvvHvZqsJihOtkrKkcvge2vPh+9XlBEy3pGUMLAp1E4C2Q1OXHzq7HIJXTaKhcuKYIOT36giWVrXWvNEnn9g+BGgTwKzoqfxJH7Xjm8klUcW1GcUAttJIugw0yO28U9ZtpAr7HvdEAwfl4u+A77FPepPHkb0BwkSpDJvbRlnWSrtL4RudasiuXvZ8TGR57CRd5u6QWtAfrUZWbszo0wegwDwVn9PrJlZgdMOGOoziEsj9GvaBj0lBylmqEWdvhIFzpZJCF0KnBYVxKQhoqRhq9dKIrbVXxPuGFsoEsuDlkj2QruZGEWeVObiJmZXXWtYU+c8yV579Mdn/B0vCaKSdx65qLuJYIXkrc+DPZCFOfel2y7bQHYRxqXMQTUu1N4HZs/9G/oQFJYzVaX5go7pVyINbF8OLwrj15NhNALWBuu69N6CfnRfermRhrHG6xrZrrlOo4H7soCrxQX7IuzuchUvkWsDzKNNv0nTYVb7XEd2podP+37r0FYbtkBEYSh6Fw6mzlbhB7SaX2QYFNQD/+zwmsn6a8wvqgyDQwHdrt8vBhAJPz6HBKYml26QXK5Z+Qz2CxtyvV8v3L20aNsR8s9WgFgkYsczYrDX4R2kWk0LBXQhSBEE5ujbtRqSN5F0MBHuXX2xB
 5xNOX/G0
 omT//BKzsy5smZ9OwET3eIXLnJOHqw5l7yP0PUm1oz+q0hSi6oJL3bnppSyB9lHLeI7TZyLcpBwUMvVrz6LE4sa6WPLNpvDsBIuH8xFKE4XMSN0x09hgrhapVlu5f7lMfBEIErpOoZEB1yy0Pqdn9j6Zr8x+P/k+7njgKrEjPouVy8eeyRkaEpC7fja9Fx85wrByIfrFdYeevjv4vVhlrmq81dprz7T9coTQnJA8Hnx+R/dDbqx4IWxYuTA0AGfFrJWQEVcERBpNx9RobV2x9CkCGElG4nYQdw+ckUwruH13eshQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


If you must have your AI write the commit message, please tell it to
be less verbose.  I start losing the will to live after about three
paragraphs of this.

On Mon, Oct 12, 2026 at 04:25:49PM -0400, Nickolai Zeldovich wrote:
> When xas_shrink() replaces the head node of an array with the node in its
> slot 0, it stores the child in xa_head, passes the old head to
> xa_node_free(), which queues it with call_rcu(), and only then clears the
> child's ->parent pointer.  In between, a lockless walker can still reach
> the old head, not from xa_head but upwards from the new head:
> xas_find(), xas_find_marked(), xas_next() and xas_prev() climb through
> xa_parent() when they step past the end of a node.  RCU does not protect
> a walker that gets there: call_rcu() waits only for the read-side
> critical sections that were running when the callback's grace period
> started, and that grace period can start before the parent pointer is
> cleared.
> 
>   CPU 0: xa_erase(), xa_lock held   CPU 1: RCU walker, e.g. xa_find()
> 
>   xas_shrink()
>     xa->xa_head = child
>     xa_node_free(old head)
>       call_rcu()
>                     <grace period starts>
>                                      passes a quiescent state
>                                      rcu_read_lock()
>                                      xas_find(): loads xa_head (child),
>                                      steps past its last slot,
>                                      child->parent is still old head
>     child->parent = NULL
>   xa_unlock()
>   quiescent state
>                     <grace period ends>
>   radix_tree_node_rcu_free(old head)
>                                      reads old head's slots[], shift,
>                                      offset and parent
> 
> The grace period does not wait for CPU 1, which reported its quiescent
> state before its critical section began; holding xa_lock delays the end
> of the grace period, not its start.  The start can fall inside the
> window when an interrupt arrives in it (interrupts are enabled under
> xa_lock(), and RCU core processing may run on interrupt exit), when
> callbacks are offloaded (rcu_nocbs=) and the rcuog kthread on another CPU
> handles the callback, when many callbacks are queued, or while the
> writer is preempted under PREEMPT_RT.  Interrupts, and in a guest a
> preempted vCPU, also stretch the window.
> 
> After the climb, xas_find(), xas_find_marked() and xas_next() resume in
> the old head at the slot after the child and read its slots[] and shift
> (xas_find_marked() also its mark bitmaps); xas_prev(), for which the
> child is the first slot, steps past the old head at once and reads its
> offset and parent, as the others do when they reach its end.  Nothing in
> the walk notices that the node is gone.  The climb takes ->parent as it
> is, no lockless path looks at node->array (XA_RCU_FREE), and
> xas_shrink() stores XA_RETRY_ENTRY in slot 0 of the old head only when
> the head shrinks to a single entry, not to a node; the walker does not
> look at slot 0 anyway.  radix_tree_node_cachep is not
> SLAB_TYPESAFE_BY_RCU, so the walker reads freed memory.  Once the object
> is reused for a node of another array, the walker returns that array's
> entries or descends and climbs into its nodes.
> 
> The order dates from the introduction of xas_shrink() in the commit
> below, which reimplemented radix_tree_shrink().  radix_tree_shrink()
> clears the child's parent pointer before it replaces the head and frees
> the old node, and still does in lib/radix-tree.c.  The commit gives no
> reason for the different order and nothing depends on it: xas_update()
> and xa_node_free() only touch the old head.
> 
> Clear the child's parent pointer before freeing the old head, as
> radix_tree_shrink() does.  The stores are the same, the tree and the
> xa_state the caller sees are the same, and a walker that starts after
> the callback's grace period has begun sees the cleared pointer, like
> every store before call_rcu(), and ends its walk at the new head, which
> covers every index that the old head had an entry for.
> 
> A check in the radix-tree test harness that no node passed to
> xa_node_free() is still the parent of a node reachable from xa_head
> fails in xas_shrink() 4731 times in the XArray tests without this patch
> and never with it.  No test is added: the race is not deterministic and
> the check needs a hook on xa_node_free().  A harness race test (readers
> walking the whole array with the four climbing walkers while a writer
> stores and erases an entry that adds three levels above the leaf) did
> not hit the window in 20 runs of 200000 erases; with a 1 ms sleep
> injected after xa_node_free() in xas_shrink(), every one of 20 runs
> reported a heap-use-after-free in __xas_next() or __xas_prev() under
> AddressSanitizer, and none did with this patch and the same sleep.  On a
> kernel (x86_64 defconfig + KASAN, QEMU), with a 100 ms delay injected at
> the same place, a walk that starts on another CPU 20 ms into the window
> climbs to the old head in each of 20 rounds, and KASAN reports a
> slab-use-after-free of the radix_tree_node freed from rcu_core() when
> the walk takes its next step; with this patch, the walk ends at the new
> head.  The XArray and IDA self-tests pass on x86_64 and riscv64.
> 
> Found while formally verifying xas_store() against the kernel binary.
> 
> Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
> 
> Notes:
>     Reproduction details: the ordering check wraps each xa_node_free(node)
>     call in a copy of lib/xarray.c with a function that walks the tree from
>     xa_head and reports the node if it is still reachable or still the
>     ->parent of a reachable node.  The harness race test links a copy of
>     lib/xarray.c with a hook right after the xa_node_free() in xas_shrink()
>     that sleeps 1 ms in the writer; 32 threads, liburcu-registered readers.
>     Without that sleep, this patch alone still showed a use-after-free in 3
>     of 20 runs; those come from the xas_delete_node() bug (the race test
>     also erases nodes), and with both patches 20 of 20 runs were clean.
>     With only the xas_delete_node() fix, the sleep still gives 20 of 20
>     failures.  The kernel demonstration is a test build with mdelay(100)
>     after xa_node_free() in xas_shrink() for one test array, a writer
>     kthread on CPU 0 doing xa_store()/xa_erase() and a reader kthread on
>     CPU 1 doing xas_load()/xas_next() under rcu_read_lock().  The window
>     has not been hit on an unmodified kernel.  I can send any of these if
>     useful.
> 
>  lib/xarray.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/xarray.c b/lib/xarray.c
> index bfe7bef80f34..ae9d7fc68861 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *xas)
>  		if (!xa_is_node(entry))
>  			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
>  		xas_update(xas, node);
> +		if (xa_is_node(entry))
> +			xa_to_node(entry)->parent = NULL;
>  		xa_node_free(node);
>  		if (!xa_is_node(entry))
>  			break;
>  		node = xa_to_node(entry);
> -		node->parent = NULL;
>  	}
>  }

I think the patch is fine.  I understand the infeasibility of adding
a test into the test suite.  I've had a good think about other ways we
might spot this happening and haven't come up with anything.

