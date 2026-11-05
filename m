Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01F2606D831
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAAW3W8z
Received: by kanga.kvack.org (Postfix)
	id 25B7B6B05B4; Thu,  5 Nov 2026 07:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BDB6B05B5; Thu,  5 Nov 2026 07:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA416B05B9; Thu,  5 Nov 2026 07:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E16816B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:09:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78B191409B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:09:52 +0000 (UTC)
X-FDA: 85400946624.30.33F2919
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5F0AC0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:09:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAAW3W8z;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880590;
	b=l2Jr9juo9l/z/MTPBrEERRnsy0t7zSNRS4ShnF5oQkxXrhtv1uso+43Va2DpGNZcSf7D3V
	rHw9/tJ+AKDJr8+a1y5xkF05XkGywg+sk7x3U8+JgrSVbBnMPtSG+S6CjPCDBvhazfVvsL
	Q8ENfTTxa3MXQ+kiNWolWYRWStvmmww=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAAW3W8z;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gukOYmvYDHX2QKSOGio7z+vsfvmKRfuVGQNVt9yzjww=;
	b=zLdpSiKvDgftqfAVaqcTNrK84H7FtQ5rL2DT+OqjBqCDyGQLo7itncYvbTcf4vSz9b4zSH
	c/ZMHGahhCtyrBS+9l9Wf0q3+0fwKo+9J+A4HXrSa3ILoEF3nZYthrY2cdvfsl7HGYhI6X
	aIFUPTLEWwOj9XmTso9/wvskQ6/AuLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B128360F42;
	Thu,  5 Nov 2026 12:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38CE1F0093A;
	Thu,  5 Nov 2026 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880589;
	bh=gukOYmvYDHX2QKSOGio7z+vsfvmKRfuVGQNVt9yzjww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aAAW3W8zrqhI1GlZKqclxuzopsOsI5eRflWVb+u4vb5PXFTYkgJ0rp9Kj8p5k/PnJ
	 dz9x5vflTBj+DeSq6KDVaKKWH4IO1ANMazHhA8U7XpsUFlwUQv3pPtBE5apiquXHF8
	 VIijSfbzJWIZ0u8nFhus81QZCpCdrEIkdEEVT9qcVLTnlF9X7DDYJUpALeqULAdBUk
	 gG3qH+UW1A7HkPJle0v+Ro9VJBDQIiBephkzM1sYS8P/gd5M72p1JtRoV4TPOtMTPm
	 lTV9zl9RBf9VsgqSb5pKIdsUflUPUNRZjRUAYJW6CA56tI1pSDaFNGwOyrBwhQLiSh
	 TJOgN9lfoSL8g==
Date: Thu, 5 Nov 2026 12:09:47 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH for-next-fixes v2 2/5] mm/slab: handle allow_spin in
 slab_free_hook() instead of open coding
Message-ID: <auxxnr3iVYNOOoci@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-2-19167cfe4779@kernel.org>
 <f31885cd-57c2-428d-9760-a76a0137f989@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f31885cd-57c2-428d-9760-a76a0137f989@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5F0AC0004
X-Stat-Signature: f4jgutn9iyfisy5t1r44x93s8afuzj9r
X-Rspam-User: 
X-HE-Tag: 1793880590-857582
X-HE-Meta: U2FsdGVkX18nqbgJH69qSwaO37MXkETJmMSfNdy3lgqckx0NglDaTdEzMRqd8eGWcwvYt5hXArb/yk/qSuDtgRnzA4GIVZgoC+bRiWVgBg7ppgli67nqQBXE2gmuxE+nFXfiwk/nyiox1zd7lhOAejpzPZTffWQ6ZL6MufYluEVORMht38zBqF78iM98mdNE6SDUSeCAjV/YcTdTxlUafqLTJoABMpAIX29WeanVQXUv1WyZtYIOnYK9SYt4DQwa4h9xMaVhAuffv4JRWX2xBVIvYkTXNrUBsYpnhRrkBgbPEid/Bxpbh7OLwiX1gy86GW2JnvCQ9hJmt4aurJNJYamcfiX0Hc3WHJY6ZBUrpdHWepmZOlCsF5NSDrqTH1fj1AWGgBX8yv7bZN0Vq5WR+gUZg5D12146Hn5qt8I6p7xtkDhCYEt1o26oi5UnCn00JT+72kD5uKuLeFSjRuZY0OcK4MBapWEmIVw0qThbK1UTq5AthfE9EpdgpbfkV236pSWYh8gZ6jfdjNFjZ9ncCgrJaumyiUnLTGF5Ru09YNZ6hGpELR4CHIbJqzB6OuVMZnhT7Fj97nv/GOunTj382gfDWA69zaBuy7Is8aHg5mqtRWo6sJw1iqwzhrHLb8JQTqcGH/EX768ehtL5sifQOoZw+foGJ5kKTyUcL4X6S4A4OfFb+Q3DvsrS3CuIjslmxhFw8Vw1KTGn7iDhKPIw3on3czBT7RXJWVu9xEOD5/FjEG8vOYUufU2CQRMkllIcyijIW5IVwHpVkxsoEoQa0hEYPZcs+T1yQqsA4yxZUyJEOFvzN3duvUp9zOhIiufVGzTby8r6IUrxMTcnXFb2yglnkqsk93lDH5e5M/M7Skg7faQ2QRzoixbeqDneZpSY+GtIWWrMf9b/9k0QMbd9U8qjuUISDXFIfuMTXijTj/7PbWfk6LdtR/1ZkgWPUnDfzYYLaSmyRbJYIGE3GHM
 +eyG/QWg
 h1oI9LGg7NJ7OUxT95gSBs7zvDp0YconW+9/yjZ8+CRzADlBzgJwEhVjPe4xyxe5diYe5H75mzCmM/qWvdvEsjvUGUhlEW/G94Bqb+tMI0gfE7bTNKiVuyXwQG6RJllfGZ7O2FpULxqvdI7XLR5ngz9rZPOCktlExaQ3xE3v2jslCzy8XMuls3EX9YFnk+xYvOj/FptvmcBJeAudSKtbjnabAihudHxPZXnlBCu7dpKDPiEcOUcGTN8JNIagYTfs1dmjvIYq9RZfTQg+9f8zV0ZG06207NHruL+GyDYhfBGjT0YXEIH7G0RJAYsRAFJtVvCMF0T3HOdbHKA2ZG0OsasPwuFMksW0VQYZz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 02:54:13PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> > kfree_nolock() deliberately skips slab free hooks that should not be
> > called in unknown context. However, there is one more place that
> > needs the same thing: memcg_alloc_abort_single().
> > 
> > Instead of open coding slab_free_hook(), let it handle the allow_spin
> > parameter. This is required to correctly handle allocation failures due
> > to memcg charging.
> > 
> > There are two functional changes from this.
> > 
> > First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
> > calls free hooks that acquire spinlocks if !allow_spin.
> 
> Hm, since this is only changed by patch 4, I don't think it needs mentioning
> here, as it's not any functional change yet.

Good point, will adjust.

> > Second, kfree_nolock() now follows init_on_free which has been ignored.
> > 
> > Besides that, no functional change intended.
> > 
> > Closes: https://lore.kernel.org/asiSUpAYYU8Od4HM@gmail.com
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> > ---
> >  mm/slub.c | 104 +++++++++++++++++++++++++++++++++-----------------------------
> >  1 file changed, 56 insertions(+), 48 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 45e077c7526c..36e7bb93418a 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2686,41 +2686,54 @@ struct rcu_delayed_free {
> >   * - memcg_slab_post_alloc_hook()
> >   * - alloc_tagging_slab_alloc_hook()
> >   *
> > + * slab_free_hook() assumes that memcg_slab_free_hook() and
> > + * alloc_tagging_slab_free_hook() are already invoked.
> > + *
> >   * Free hooks that must handle missing corresponding alloc hooks:
> >   * - kmemleak_free_recursive()
> >   * - kfence_free()
> >   *
> > - * Free hooks that have no alloc hook counterpart, and thus safe to call:
> > + * Free hooks that have no alloc hook counterpart:
> >   * - debug_check_no_locks_freed()
> >   * - debug_check_no_obj_freed()
> >   * - __kcsan_check_access()
> >   */
> >  static __always_inline
> >  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> > -		    bool after_rcu_delay)
> > +		    bool after_rcu_delay, bool allow_spin)
> 
> Hm 3 bools. Could we bite the bullet and try doing free_flags (extended to
> cover init and after_rcu_delay) here already? :) Given it's not intended for
> a stable backport.

Ack, will try to bite the bullet.

> > @@ -2776,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> >  		set_orig_size(s, x, orig_size);
> >  
> >  	}
> > -	/* KASAN might put x into memory quarantine, delaying its reuse. */
> > -	return !kasan_slab_free(s, x, init, still_accessible, false);
> > +	/*
> > +	 * KASAN might put x into memory quarantine, delaying its reuse.
> > +	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
> > +	 */
> > +	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
> >  }
> >  
> >  static __fastpath_inline
> > @@ -2789,9 +2806,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
> >  	void *next = *head;
> >  	void *old_tail = *tail;
> >  	bool init;
> > +	bool allow_spin = true;
> 
> Then we wouldn't need tricks like this I guess?

Right.

-- 
Cheers,
Harry / Hyeonggon

