Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50196E93817
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 05:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B962C6B008A; Mon, 13 Apr 2026 01:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D906B0092; Mon, 13 Apr 2026 01:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83BC6B0093; Mon, 13 Apr 2026 01:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 958DE6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:14:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27E08BBF89
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:14:37 +0000 (UTC)
X-FDA: 84652367394.10.B9A8CBA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D94C40002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:14:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776057275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50D2IRvOBbdDkahOXo+KjfX9DjodPGp/ooe6cw3ewpA=;
	b=gk2GeHjBZqu5nuP4LBjHp+VWxeOH2YZ9enhyBsF/s8k1vlY+j5xbo9RkOV/MrO+objFuLz
	/ssjN675KODDTbEhEXn8Oz7Q1LBppeQZsjYoDvmN1Qc+aWflnQwTD6MMo58xNQdpI6IJ8L
	+Rax6f0OrNkvYD0wkN48BtDFmA8vB0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776057275; a=rsa-sha256;
	cv=none;
	b=2iM7zDSCMeJ6Ss1NJ3V0hQ3qRCYTzgu4F0lBtev0Gm10eGy3tTcrOZ+HWh5TXTnenAvLXw
	H+7erHc5HzMtfauX0U1YleJc4asyihb69/meFwnkMHa8l0Ns4Ix6GgKi6P4amznOoX8zd0
	XPctGYOLK8k6M003Pr0D4WP9UUf7T0E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fvFvT2gzFz8Xs6q;
	Mon, 13 Apr 2026 13:14:29 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 63D5ELSC007422;
	Mon, 13 Apr 2026 13:14:21 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Apr 2026 13:14:23 +0800 (CST)
X-Zmail-TransId: 2afb69dc7baf7a3-31d12
X-Mailer: Zmail v1.0
Message-ID: <20260413131423382u868NVr2RkcvDe0Ii3ERj@zte.com.cn>
In-Reply-To: <adxm5az9EfHr2aYg@hyeyoo>
References: 20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn,adxm5az9EfHr2aYg@hyeyoo
Date: Mon, 13 Apr 2026 13:14:23 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NV0gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63D5ELSC007422
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 13 Apr 2026 13:14:29 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DC7BB5.000/4fvFvT2gzFz8Xs6q
X-Rspamd-Server: rspam12
X-Stat-Signature: 4nw437j5kn5i7647hbkz7u47sw4zkdx8
X-Rspamd-Queue-Id: 3D94C40002
X-Rspam-User: 
X-HE-Tag: 1776057273-649948
X-HE-Meta: U2FsdGVkX1+miMdejumP4vpmXn+EmD3pDi7V0uwl0upQLkQyx29Y8tCjAHyVPsMO9JoBUno1ABrivIP8GDcBuAnJ3Y/RVCQ0AAWxTUa2BxXK6zIlv4Za4GPDVUe0kUcnbqs/q/4N/HDnD/4GAxt3bi0DvyoI8m+jbddTDSvJNy7dEy0UXTYVXme2Ooy5Pa2YZWutmcPE9K/ozw0gqKg736xmwiAilNveydcdJrKwE2dxSX/7xVhVrlQztLQehjnVIF3Tg5mEDsdmTjaN0AZkbr1oIDkObYx8vqLq0dWTrJU58xdzEf5+60nmvWMC4kMYBJSmrdE4nButANC35Ju2Jc77k/cjjdLVpsoVUT600BudK4WvU1wGh6R0/X0xM3BshqKdog7isfFDDS5Rnda/ITfenhUz97DK8WQ2W+0NceFTFjFG2kpQxDjG1rWN8D31AB+vsiszmcTjz4UJzHlGZ/pWmaFY14ps9rmNwjf8xsB5f9YDuI4/gDdOKMukzc5QfnhWSQWLp+zAJQCdN/JikS8GkcfrL7TxBhqq6htIdNysBIaqxlAKKNtyNZwWq4nz7ogK9pfdRlTqP9JbXA+TuWfTPeESbqFT7UqMZ8ZW7dGIr/yp7c5k8nIGSI7x9aCx8KC2WU8UqAa1vKKZ2ezZfVULAxnuQ+qFN40IJlgWybv0GjnKzaZP/7jheerIN4/Ehyg7kvaLC2j8lnWKzksHt/2n2wujDyHK70Iopmnbhur8+GxTnqzwDbpT4mt1G5GQCg/OYFatMz9vMHkj/cfNGJeTkRhM+ru99LP5y68vWEZoc6uzF7007wDhZfr8ExXSkPlXMiijfyuXZXR+8yoQLvBpPptz3S5RDHOdopppJk+vI+Bu35sr+CaufnV+YHuRodOg+3aJjmUtArSXXdPS5gLkJrgWceG8GsallUudsvJaRGbZayj4kL5iyYouK4XR5G6YboW2ZZ3AJ0C3oWK
 kUG1koRS
 XH52D0xckM4jkE/a1G62r37d6hTck4/a+AnHn2eNf7qfXiWm66e022O+YCc8kQFLfve2CzxpwUep/kNrF3Iftp4BtKPmkrYivU4NLn3XQv7AywwreEzefFywHF76Ce5UUUCW90vI68kCB4KY+3bjVHd195r4i1uJtOe2IZx1jgqV53/uWMRnNGRngj6Vt13o/pm9D5y0fDMcgbR8eJhcwtpUPGFX8EU7XDZyV9ZsNsvmU44m/k4EyXEOgVJ6PRBe1Oyw0gBi6OI8CNBkNCDv6o8YR7TuQrcD54esyAaoG0t40huCEenEdcPbLHJqJGd8jixV1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On Thu, Apr 09, 2026 at 08:43:52PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Allocations from a fresh slab can consume all of its objects, and the
> > freelist built during slab allocation is discarded immediately as a result.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from a fresh slab.
> > new_slab() now only allocates the slab and initializes its metadata.
> > refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> > emit objects directly, building a freelist only for the objects left
> > unallocated; the same change is applied to alloc_single_from_new_slab().
> > 
> > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > small iterator abstraction for walking free objects in allocation order.
> > The iterator is used both for filling the sheaf and for building the
> > freelist of the remaining objects.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead when allocating from a fresh slab.
> > The most direct benefit is in the paths that allocate objects first and
> > only build a freelist for the remainder afterward: bulk allocation from
> > a new slab in refill_objects(), single-object allocation from a new slab
> > in ___slab_alloc(), and the corresponding early-boot paths that now use
> > the same deferred-freelist scheme. Since refill_objects() is also used to
> > refill sheaves, the optimization is not limited to the small set of
> > kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> > workloads may benefit as well when they refill from a fresh slab.
> > 
> > In slub_bulk_bench, the time per object drops by about 32% to 71% with
> > CONFIG_SLAB_FREELIST_RANDOM=n, and by about 52% to 70% with
> > CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> > cost removed by this change: each iteration allocates exactly
> > slab->objects from a fresh slab. That makes it a near best-case scenario
> > for deferred freelist construction, because the old path still built a
> > full freelist even when no objects remained, while the new path avoids
> > that work. Realistic workloads may see smaller end-to-end gains depending
> > on how often allocations reach this fresh-slab refill path.
> > 
> > Benchmark results (slub_bulk_bench):
> > Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> > Kernel: Linux 7.0.0-rc7-next-20260407
> > Config: x86_64_defconfig
> > Cpu: 0
> > Rounds: 20
> > Total: 256MB
> 
> [...]
> 
> Hi Shengming, it's been great to see how this patch has been improved
> since v1 to where it is now. Thanks for taking the feedback and steadily
> improving things along the way.
> 

Hi Harry,

Thank you very much for your helpful reviews and suggestions from v1 through v5.
I really appreciate your patience and professionalism throughout the review process,
and I have learned a lot from your feedback.

> I think this is getting pretty close to being ready for mainline,
> with just one little thing to fix in the code.
> 
> Other reviewers/maintainers may also take a look and leave comments
> when they get a chance.
> 

I am also looking forward to any further comments or suggestions from
other reviewers and maintainers.

> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> 
> If you think it's appropriate, please feel free to add:
> Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> 

Sure, I will add:

  Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks again for your continued review and guidance.

> In case this was assisted by AI or other tools, please disclose that
> according to the process document:
> 
>   https://docs.kernel.org/process/generated-content.html
>   https://docs.kernel.org/process/coding-assistants.html
> 
> Not that I think this was assisted by AI, just mentioning because
> sometimes people using tools to develop the kernel are not aware that
> they need to disclose the fact. It wouldn't hurt to remind people :-)
> 

Regarding AI disclosure: I only used an AI tool to polish the English wording
of the commit message, since I am not fully confident in my English writing. :-)

As I understand it, the documentation says that "spelling and grammar fix ups,
like rephrasing to imperative voice" are out of scope, so I believe an
Assisted-by tag is not needed in this case. Please let me know if you think otherwise.

> > Changes in v5:
> > - Call build_slab_freelist() unconditionally, and remove the redundant "slab->freelist = NULL" initialization in allocate_slab().
> > - Check the return value of alloc_from_new_slab() to prevent a potential use-after-free bug.
> > - Refine the commit message with more precise test coverage descriptions.
> > - Link to v4: https://lore.kernel.org/all/2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn/
> > 
> > ---
> >  mm/slab.h |  10 ++
> >  mm/slub.c | 279 +++++++++++++++++++++++++++---------------------------
> >  2 files changed, 147 insertions(+), 142 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 4927407c9699..9ff8af8c2f73 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3696,22 +3686,30 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >           * corruption in theory could cause that.
> >           * Leak memory of allocated slab.
> >           */
> > -        if (!allow_spin)
> > -            spin_unlock_irqrestore(&n->list_lock, flags);
> >          return NULL;
> >      }
> >  
> > -    if (allow_spin)
> > +    n = get_node(s, slab_nid(slab));
> > +    if (allow_spin) {
> >          spin_lock_irqsave(&n->list_lock, flags);
> > +    } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > +        /*
> > +         * Unlucky, discard newly allocated slab.
> > +         * The slab is not fully free, but it's fine as
> > +         * objects are not allocated to users.
> > +         */
> > +        free_new_slab_nolock(s, slab);
> > +        return NULL;
> > +    }
> >  
> > -    if (slab->inuse == slab->objects)
> > -        add_full(s, n, slab);
> > -    else
> > +    if (needs_add_partial)
> >          add_partial(n, slab, ADD_TO_HEAD);
> > +    else
> > +        add_full(s, n, slab);
> >  
> > -    inc_slabs_node(s, nid, slab->objects);
> >      spin_unlock_irqrestore(&n->list_lock, flags);
> >  
> > +    inc_slabs_node(s, slab_nid(slab), slab->objects);
> 
> Ouch, I didn't catch this when it was added in v4. When slab debugging
> feature is enabled for the cache, inc_slabs_node() should be done within
> the spinlock to avoid race conditions with slab validation.
> 
> Perhaps it's worth adding a comment mentioning this :)
> 
> See commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
> caches and make it safe") for more details.
> 
> With this fixed, please feel free to add:
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 

You are right about the inc_slabs_node() placement. I missed that change when
it was introduced in v4. Thank you very much for catching it.

After reading commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
caches and make it safe"), my understanding is that inc_slabs_node() should
remain under n->list_lock for debug caches, so that validation cannot observe
inconsistent state during list transitions. I will fix that in the next revision
and add a comment along these lines.

Would a comment like the following look good? :-)

/*
 * Debug caches require nr_slabs updates under n->list_lock so validation
 * cannot race with list transitions and observe inconsistent state.
 */

Thank you again for the careful review.

-- 
Cheers,
Shengming

> -- 
> Cheers,
> Harry / Hyeonggon

