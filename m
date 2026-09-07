Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393EDC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AA86B0096; Mon,  7 Sep 2026 09:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBC76B0098; Mon,  7 Sep 2026 09:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA896B0099; Mon,  7 Sep 2026 09:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED52F6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:53:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80C25160188
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:53:01 +0000 (UTC)
X-FDA: 85187107362.20.AA61AB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D70EFC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:52:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDBzCLAi;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789180;
	b=Qg0J55x4CmEWju3cCqRvdTQUBb1PQVa4lNnegH2Qc60SWMw/A13WqMDcubGKE+gcLBjrUv
	kjPMsog96HdoKgvExPiX2cKuEFA0tYDophmcRF2FTf6WBvQZWVWLMR3RBjBDk0pGqVySDt
	eYMbeNaIe1AmLpsADDybkt3qIzv5B24=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDBzCLAi;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AT6+S9iTHVa+rI+62Z2IdD4rNbMRLrTmmumicT/HG8=;
	b=hFC7GdMc78WS4kcksLUR/zf7HqrrTWUWuHYKn1NRXZ7BnvKVy0lsr8lZtmVVnScQzsFVa+
	tVg80rqvTrF2eXy22MF1UpCIOenLB7f+E9PwUuIEVJ1xIAmkbaBc06RfQIzd7Jj2sEKwD4
	dfgLbmFCr51Qk+nxxXIzfdROyafJ3BI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0671F42A2D;
	Mon,  7 Sep 2026 13:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F211F00A3A;
	Mon,  7 Sep 2026 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789178;
	bh=8AT6+S9iTHVa+rI+62Z2IdD4rNbMRLrTmmumicT/HG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eDBzCLAiJnUkt9L6IL4S0XQb86abqk8jAQ9dMaCVj2S7D2gd7e08Dg8wCbwJqED/i
	 wJcygbaSpdbrQVy3JHW2E93j12cU6AfNroFMWE3tOo3kR70N1PGl7V5RBaeXpEvw8s
	 p5mT805cYSyWgoSQaZeBynrlYFHWKeSiOHnvy/g5HZIzPZPOWpEMG2MovO9/O/2ZC6
	 VgWtKYddrdUXpllMLYoRIcg/oAUR+QJATNndOysltVNNqtwkaJAnGdQGHXeklQKyTx
	 2S5NboYVaU4UPlbP3HIpKM60wp1k/RPqbUuqUbXE8k4ofPWd0vnq+lYbvUUQsXzqjU
	 UrP8M9opAgLow==
Date: Mon, 7 Sep 2026 14:52:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, minchan.kim@gmail.com, lwoodman@redhat.com, 
	kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, linux-mm@kvack.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
Message-ID: <ap6ybQeSg_rrmC95@gremlin>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905061820.642437-1-tujinjiang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D70EFC0003
X-Stat-Signature: idjr99w3fwhzg6gaq7mz9u3nz4em491o
X-HE-Tag: 1788789179-780302
X-HE-Meta: U2FsdGVkX18l+FC8RErvbg0s+8gG9mIMNinWkyNGaBPf64+gJi6vKHO+pMdOXESVnPAy2auHGFSj/XOJXfmOc83KQ7psu9x50L79dSMcdHG4Ray9jT0tvNVxaIVLR2BvKgB8XNPtM2jM+xTzrtTEL4K7eFk6NAPMuXEFW/3r2JyjQe2k2Qmz6J6PSXCadu85gWd/grICRZMl76awpONCeRJIygpS8xDFsIbQA1Zf4+5FwrDpI8LKeulZcdVPm4k/39O7bnbY1Yslng4nE8qOlDwrrrMUgYlnYxn+jSQwTufWdZ0NJB0PI1gcoLMxJoqxgDyfQNN5QFw3egTM+DXxtjdW7qRfJNbEeO+KfvWFnYsEN7KArKXFX6lM3fVB0GMBWpBv1gfbCU17bB/lUolvDMRLBDmvRk29ypp8QJZljuFjJ82LwhOL4vMrKtdVxoHfc9TAu7pTy8tTbsLtrwUMQPod9B+JIi9fI2Zum7VNhgjlGdlx/VKtAJ/2IM8dTIIR6mcWDI+ZfngYfiKqE9eYFVj7XWN12FHG6neQ040W9cNmeNNfm2SEIAUWgbe71AjxGUpaGl6aDesNhz57uyvkeoe9FjuCpGmYDQwjK5Y8uI1ArrfFGG9JfKTErjCxSy82UPuHm6PpRjGJa3elmPxnaTN93aIdWPw2r0uAkNkDBLJtNa3931yxvZEv9/veyLoAZME7khm4sXR6GpVaHtYLBcRpknflKIwmS6dSNgjh0sIgolnMRuq3Gl0+adiY+Hb+5N4LdnRoMnZYZe1HJSZxk1JBn+vGx58A3iiAkdqoL9WyWr6+YS6Gokc9z2ldeKiEFYSSzkupAbyHF/j6fR1NJs3Bqu4xvIdyshe6u6FXuJFRh0FeXm4WewWdHT+ncA8lwgJgEcuLWH/46YvW4PFtDiIcX99lfoTb/VBzdTZb6jbzmMm/HPgGVnBJ+KFNbiLfwqFlfCVttCv917SorR2
 /OjVE+vh
 1jhLt6vKRb1FrWGeAvQBJr1wk8EV6O5N2eToC7PWRDaZIvVU/7fN/nWi1g8CB0kAsupba96c2/K4fNYxw66TXk28KCbbkXYURPSvgSYU6taifCpz81YDOIKm+ZXFFb5Iig9/CqzBYAMvfDfU15bv1q2tY4STpAILYlEFNI1AOHyPCfwnNE5S+MX2jtQcgtcxkJVZqSljGiWkejTAamq+lIz7z76NsztzTQ9KBbai69UnigXTebMErijK0Y3WRTNEz05d+zh/io5lW7j2Gk9k49KuWSIDzGDhbsHbpoHPI0eNb0IFHGJaMihbnIdEvl7rVpYHuYLMzrISSQ1OvVio9DhVEkqMkvqy0rbtQtAJONSo/rmiUgwYlJaehCJKeGpoZq5AHG4EL6fGPefKlQ5y0DtwPD6zOEmRXCwOCRj4kDJ/sy2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, I looked at this on the weekend, then thought 'I should really not read
kernel mail on the weekend' and abandoned my reply. :)

On Sat, Sep 05, 2026 at 02:18:19PM +0800, Jinjiang Tu wrote:
> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
> anon_vma->root is stale due to missing memory barrier, leading to
> lock and unlock two different anon_vma->root, thus leading to a anon_vma
> will never be unlocked, and another anon_vma couldn't be locked anymore.
>
> The race is as follows:
>
>     THREAD A                             THREAD B
> __anon_vma_prepare                __anon_vma_prepare
>  anon_vma = anon_vma_alloc();
>  // writes may out of order here

-> may be.

>  vma->anon_vma = anon_vma;
>                                    anon_vma = find_mergeable_anon_vma(vma);
>                                    anon_vma_lock_write(anon_vma);
>                                      // may still see the old root
>                                      down_write(&anon_vma->root->rwsem);
>                                    anon_vma_unlock_write(anon_vma);
>                                      // see the new root, never unlock old
>                                      up_write(&anon_vma->root->rwsem);

The left column is missing a lot of stuff I feel.

I think you need to make it clearer that what's happening is that you have:

	|-----------||-----------|
	|   VMA A   ||   VMA B   |
	|-----------||-----------|

Where VMA A and VMA B are merge compatible _except_ for a property that can
be modified by mprotect() (i.e. fulfills criteria of
anon_vma_compatible()).

There are racing faults on each.

Now VMA A has already tried calling find_mergeable_anon_vma(), which
checked VMA B for merge compatbility and found it was not, yet, faulted in.

Since:

static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
					  struct vm_area_struct *a,
					  struct vm_area_struct *b)
{
	if (anon_vma_compatible(a, b)) {
		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);

		if (anon_vma && list_is_singular(&old->anon_vma_chain))
			return anon_vma; <---- Other VMA MUST have anon_vma.
	}
	return NULL;
}

So, __anon_vma_prepare() for VMA A goes ahead and allocates the anon VMA:

int __anon_vma_prepare(struct vm_area_struct *vma)
{
	...

	anon_vma = find_mergeable_anon_vma(vma);
	allocated = NULL;
	if (!anon_vma) {
		anon_vma = anon_vma_alloc();
		...
	}
	...
}

And sets its fields in anon_vma_alloc:

static inline struct anon_vma *anon_vma_alloc(void)
{
	struct anon_vma *anon_vma;

	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
	if (anon_vma) {
		...
		anon_vma->root = anon_vma;
	}

	return anon_vma;
}

Then it assigns vma->anon_vma and observe the classic gotcha with
acquire/release semantics:

int __anon_vma_prepare(struct vm_area_struct *vma)
{
	...

	<inlined>
	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
	if (anon_vma) {
		...
		anon_vma->root = anon_vma; ----------| Nothing stops this
	}                                            | being reordered
                                                     | to crit sect
                                                     |
	anon_vma_lock_write(anon_vma); --------------|------------
	spin_lock(&mm->page_table_lock);  -----------|------------ Acquire x2
                                                     |           |
	if (likely(!vma->anon_vma)) {                |           v
		vma->anon_vma = anon_vma;            |           ^
		...                                  v           |
	}                                                        |
	spin_unlock(&mm->page_table_lock); -----------------------
	anon_vma_unlock_write(anon_vma); ------------------------- Release x2

	...
}

And so you can end up in the verse situation of a weakly ordered arch
doing:

	vma->anon_vma = anon_vma;
	anon_vma->root = anon_vma;

And this the problem observed is that Thread/VMA B finds this VMA (it now
has vma->anon_vma assigned! So reusable_anon_vma() returns fine) and then:

int __anon_vma_prepare(struct vm_area_struct *vma)
{
	...

	anon_vma = find_mergeable_anon_vma(vma); <--- finds A!

	...
	anon_vma_lock_write(anon_vma); <-- goes to lock vma->anon_vma->root->rwsem
					   but... it's not assigned yet.
}

And guess what:

void __init anon_vma_init(void)
{
	anon_vma_cachep = kmem_cache_create("anon_vma", sizeof(struct anon_vma),
			0, SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
			anon_vma_ctor); ^----------------  It's
	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain,    our friend...
			SLAB_PANIC|SLAB_ACCOUNT);          SLAB_TYPESAFE_BY_RCU!
}							   so _very_ easy to UAF.
							   Not so much 'stale' just
							   a UAF that might still work.
							   Or the root might still exist...

How hideous all round.

>
> thread A triggers page fault and calls __anon_vma_prepare() to prepare
> anon_vma for the faulting vma. __anon_vma_prepare() allocates and
> initializes a new anon_vma, and then publishes it to the vma with a plain
> store. anon_vma_prepare() only requires the mmap_lock to be held for
> reading, so two threads can fault on adjacent VMAs at the same time. While
> thread A publishes a new anon_vma, thread B could finds the anon_vma via
> find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.
>
> However, due to missing barrier, thread B can observe the published pointer
> but a stale anon_vma->root because the stores from anon_vma_alloc() aren't

Less so stale, more UAF but you might get away with it...

> yet visible. What's the value of the stale anon_vma->root? __put_anon_vma()
> doesn't clear anon_vma->root, so the root of the new allocated anon_vma
> may point to a valid anon_vma.
>
> As a result, thread B can call anon_vma_lock_write() with the old root,
> and call anon_vma_unlock_write() with the new root, leading to a anon_vma
> will never be unlocked, and another anon_vma couldn't be locked anymore
> (it's count is dropped from 0 to -1 due to wrong unlock).
>
> To fix it, change the plain store `vma->anon_vma = anon_vma` to store
> release, so that the fields of anon_vma are visible before anon_vma is
> published to vma->anon_vma.
>
> We don't need a read barrier at read side for thread B. The load of

Well you _have_ to have a barrier of some kind for this to work...

> anon_vma and anon_vma->root have address-dependency. According to
> Documentation/memory-barriers.txt and some investigations, only Alpha
> needs address-dependency barriers and it has been handled by READ_ONCE().

...yup, because you have an address dependency :)

That works because, revising the memory barrier docs, the address
dependency works on the LOAD side only, because it has to deref to knoww
hat it's looking at whereas on the store side things can just live in the
store buffer.

>
> This issue needs two adjacent VMAs aren't merged but are compatible for
> anon_vma. We reproduced this issue in v5.10 with KSM enabled. The kernel
> doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
> merging for new VMAs"), so there are many adjacent VMAs that aren't merged
> but are compatible for anon_vma.

How I hate the 'mergeable but not merged' terminology around this
particular part of anon_vma.

Well in any case I am replacing it all (eventually :) but in the meantime
it's irksome :)

>
> Without this fix, our production environment could reproduce this issue
> about 2-5 times each month. After adding a smp_mb() before
> anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
> to this patch, this issue hasn't be reproduced for one month.

I don't see how the smp_mb() would make any difference there, I wonder if
you just reduced the race window?

>
> Cc: stable@vger.kernel.org
> Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")

I do wonder if something more recent made this at least more possible.

A decade and a half without it being caught before seems... unlikely :)

I wonder if the VMA locks made this more possible by (significantly)
increasing the ability for racing faults to occur (no mmap read lock
required).

Either that or something increased the race window or this was somehow
accidentally mitigated somehow.

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Very good spot thanks!

I feel the commit message should be reworked a bit to really clarify the
problem, feel free to steal my
explain-to-myself-because-memory-barriers-break-my-brain stuff above :)
also add the stack trace from the subthread.

I also want some changes in comments etc. but broadly I think your solution
is correct.

See attached patch for what I suggest for fixing that all up.

With everything addressed feel free to add:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/rmap.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..a868e835eadb 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		/*
> +		 * The fields of anon_vma must be visible before anon_vma
> +		 * is published to vma->anon_vma.
> +		 */

_Everything_ like this needs a 'paired with'.

In this case, paired with the READ_ONCE() in reusable_anon_vma() (and a
similar comment there please).

Also over there the comment:

 * NOTE! This runs with mmap_lock held for reading, so it is possible that
 * the anon_vma of 'old' is concurrently in the process of being set up
 * by another page fault trying to merge _that_. But that's ok: if it
 * is being set up, that automatically means that it will be a singleton
 * acceptable for merging, so we can do all of this optimistically. But
 * we do that READ_ONCE() to make sure that we never re-load the pointe

Will need updating.

Actually, see below, I provide a patch showing what edits I think make
sense here.

BTW I actually wondered about doing this with a lock instead.

Like:

  scoped_guard(spinlock, &mm->page_table_lock)
      anon_vma = find_mergeable_anon_vma(vma);

I think that should work across the board as you get the right
acquire/release semantics in both cases (you should then delete that
comment above, remove the READ_ONCE() in reusable_anon_vma() etc.)

BUT.

You are then in a weird situation where it's kinda lockless but we get away
with it because nobody else who touches anon_vma touches fields that might
exhibit this kind of behaviour.

So the barrier is probably still best.

Anyway, adjust the patch as below on respin and update the commit message
as requested above and think this is the right way to go.


> +		smp_store_release(&vma->anon_vma, anon_vma);
>  		anon_vma_chain_assign(vma, avc, anon_vma);
>  		anon_rmap_tree_insert(avc, anon_vma);
>  		anon_vma->num_active_vmas++;
> --
> 2.43.0
>

Cheers, Lorenzo

----8<----
diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd69938..f3b21aaa34ee 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		/*
+		 * Make anon_vma fields visible before anon_vma is published.
+		 * Paired with an address dependency in reusable_anon_vma().
+		 */
+		smp_store_release(&vma->anon_vma, anon_vma);
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
diff --git a/mm/vma.c b/mm/vma.c
index 35e7a64855fa..ec4101250d71 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2094,6 +2094,13 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * acceptable for merging, so we can do all of this optimistically. But
  * we do that READ_ONCE() to make sure that we never re-load the pointer.
  *
+ * The READ_ONCE() establishes an address dependency between anon_vma and
+ * any access to its fields, which pairs with the assignment to
+ * vma->anon_vma performed with release semantics in __anon_vma_prepare().
+ *
+ * This is especially important as anon_vma's are SLAB_TYPESAFE_BY_RCU so
+ * accessing an uninitialised anon_vma's fields may result in a UAF.
+ *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
  * matters for the 'stable anon_vma' case (ie the thing we want to avoid
  * is to return an anon_vma that is "complex" due to having gone through
@@ -2108,6 +2115,7 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
 					  struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
+		/* Paired with a memory barrier in __anon_vma_prepare(). */
 		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);

 		if (anon_vma && list_is_singular(&old->anon_vma_chain))

