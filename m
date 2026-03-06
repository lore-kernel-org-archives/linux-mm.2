Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48231FCC062
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 19:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FA96B0005; Fri,  6 Mar 2026 14:35:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D126B0088; Fri,  6 Mar 2026 14:35:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E456B0089; Fri,  6 Mar 2026 14:35:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F32D6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:35:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF9771B86CF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:35:10 +0000 (UTC)
X-FDA: 84516641580.13.EFC5589
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A318140010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:35:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772825709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GxypWmVpYpVuttdZa2oWZ3CvwQ9hX7LB7kQQ7oXcnvI=;
	b=dgKKxiNH+inoe+u4m4McJsGwYHdobWKPenkdf8UALm4vcQBw0O3sCvgiXOsYnTWdqVe32s
	W9oC35T8ZZzUvVllqxnBlBbOozRDBjni7MJsiUIeza8D0ImueNWRW0LpwkxGIqbl97G+Qd
	H7+Yv7yVbZ7t6e6eMMXOxKoeIDIeOX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772825709; a=rsa-sha256;
	cv=none;
	b=6iyTS3c7XJn5FZDFGaNA6/fr1B0Qp1mXxcGhIhyvHe5KHNaGRdnRl9dLU+oA0H6IVYrxED
	/XKohq3wLS43GSgNCWeoX210J+pBl81zB0mvAtYHKZaQS4Z+a0AjFu702J63QS03+nTvAD
	+hsYv+/y5ref40WVovjBqb40wbXDrfQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3658D497;
	Fri,  6 Mar 2026 11:35:01 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F9B83F836;
	Fri,  6 Mar 2026 11:35:04 -0800 (PST)
Date: Fri, 6 Mar 2026 19:35:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Qing Wang <wangqing7171@gmail.com>,
	syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
	jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de,
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz, Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aassZV5PjgFx8dSI@arm.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
X-Rspamd-Queue-Id: A318140010
X-Stat-Signature: ttnpyub7o6kmaufjk8qqd991t8nbihcd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772825708-949670
X-HE-Meta: U2FsdGVkX1/3EI85N/TNKsYiVIgpxnDaa3RtTI3GDni2LOW/j6UyK7qpbZ8wqy5USokIPg6Qd3od3gb2waUJTWmroJrtvYQniHeUtMCbp7X+b27j2+x56LP3NnOgSLaNO4amUnGnAXIAT+gKYc0ATXM7RGBtLoxE51aek6PxuB6Sd0ed+eX2VoWlnvI3lbRMMvCYOo71rcAFrwEEHJFlbx62g4KL2jsagzuLXaAfVTi2jZoLhm+8qJsvLzllQLRv71B2u8IP6Sda2cmvjpfb5pG1rWZcWisO04LCyTTmbOYnfDUyzeXknhsIedW9KPDDv7XyupfV7WF9HmGgc8nc/RwEk1qyzq18qwpe9AVdNI3PYtZuHSUoECF4hRYJvc4Jg6tVSEl30xndNrYIZmgLV1AxVtlO+Q709jU6NrCOTgZZ/pj+vWr1qApTUxKP4zVUlRWmpB3IqagJ204/K9ThSLhXKZ+E+4LLyalX2Bu8P699ZJZ+af1z9R75Hk4F4q7ndAHS/45t3WsW7t1wvHzYyLrSjCZzzMbByUVlz6Ovd+jewdXM78diinWjX0ghcEXD5gQG9gKS7flhdPBQbeVUmtItJz8XgHWKI/2YQ26jh5Pm5FQVFlUSZrnkqUX73nAigxiY/mLkfi4GJ0VvI7re/x7nQh7YgrhmG4zq7SWSSto0mVuB9a42hmmb5xBldDumFUE3vtkZXE6WlGthwhY7MUbJcN+OJhyA6KmqYfi9Eo+8pkp4bD7fNf9zpGYoUksmiF5LJX6qQ01z3YKrHmVV782t8bJyEHdyFYiGlDu+szQMjLN6U1usOmi4nFh3Ef90vkGU6QmAn3kTmAr6kOA5S2nqUKHyGTam5EjIeXYB/1m/CnsXKD5ZON6gS8BM+1G1SZWbCk4oFnjHJPkG7Z35CVM/p65vOzZj1Pag8JBh1PBgO+e8RyuymiuVjvUCbTCZmgWCUaH5VC2lcFQqmDA
 tpVv3Aam
 Ba5UfFk8+QpjZTrChnN9c38G1vPIRmJpAprc0LDVlINId1ct71baaOe6O7OLjYMb9cPcEEKLXskm9YzBKJ+haQ7zagUXBS25WRRt5CBeDf4jEtD4XEZyhJH9TCTEJYC+MdIhY+J7wjTvV09VE2OjL8VVN7idScmPCpakeM1yuru6mw09tF9oxe936WqSEjjMoIuATLWkgY3CLgcwuqkdaOarJOedDTaRiWQDcr+dZ7ZK4jN3YBWwcx0svVSpzxQ4YVWsy+a/Hzs3VAXrcS3Fh3QwZNB7MVT5eVJ2uCdFN7wkNinxxabxe7x4gbZz/RvE/mtAPUCdF/Hma5Og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:39:47PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/4/26 2:30 AM, Harry Yoo wrote:
> > [+Cc adding Catalin for kmemleak bits]
> > On Mon, Mar 02, 2026 at 09:39:48AM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 3/2/26 04:41, Qing Wang wrote:
> >>> #syz test
> >>>
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index cdc1e652ec52..387979b89120 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -6307,15 +6307,21 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> >>>  			goto fail;
> >>>  
> >>>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
> >>> -			barn_put_empty_sheaf(barn, empty);
> >>> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> >>> +				barn_put_empty_sheaf(barn, empty);
> >>> +			else
> >>> +				free_empty_sheaf(s, empty);
> >>>  			goto fail;
> >>>  		}
> >>>  
> >>>  		pcs = this_cpu_ptr(s->cpu_sheaves);
> >>>  
> >>> -		if (unlikely(pcs->rcu_free))
> >>> -			barn_put_empty_sheaf(barn, empty);
> >>> -		else
> >>> +		if (unlikely(pcs->rcu_free)) {
> >>> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> >>> +				barn_put_empty_sheaf(barn, empty);
> >>> +			else
> >>> +				free_empty_sheaf(s, empty);
> >>> +		} else
> >>>  			pcs->rcu_free = empty;
> >>>  	}
> >>
> >> I don't think this would fix any leak, and syzbot agrees. It would limit the
> >> empty sheaves in barn more strictly, but they are not leaked.
> >> Hm I don't see any leak in __kfree_rcu_sheaf() or rcu_free_sheaf(). Wonder
> >> if kmemleak lacks visibility into barns or pcs's as roots for searching what
> >> objects are considered referenced, or something?
> > 
> > Objects that are allocated from slab and percpu allocator should be
> > properly tracked by kmemleak. But those allocated with
> > gfpflags_allow_spinning() == false are not tracked by kmemleak.
> > 
> > When barns and sheaves are allocated early (!gfpflags_allow_spinning()
> > due to gfp_allowed_mask) and it skips kmemleak_alloc_recursive(), 
> > it could produce false positives because from kmemleak's point of view,
> > the objects are not reachable from the root set (data section, stack,
> > etc.).
> 
> Good point.
> 
> > To me it seems kmemleak should gain allow_spin == false support
> > sooner or later.
> 
> Or we figure out how to deal with the false allow_spin == false during
> boot. Here I'm a bit confused how exactly it happens because AFAICS in
> slub we apply gfp_allowed_mask only when allocating a new slab, and in
> slab_post_alloc_hook() we apply it to init_mask. That is indeed passed
> to kmemleak_alloc_recursive() but not used for the
> gfpflags_allow_spinning() decision. kmemleak_alloc_recursive() should
> succeed because nobody should be holding any locks that would require
> spinning.

I don't fully understand what goes on. If kmemleak_alloc_recursive()
failed to allocate for some reason (other than SLAB_NOLEAKTRACE), it
would loudly disable kmemleak altogether and stop reporting leaks. Also
kmemleak doesn't care about allow_spin, it's only the slub code which
avoids calling kmemleak if spinning not allowed (as it takes some locks,
may call back into the slab allocator).

I wonder whether some early kmem_cache_node allocations like the ones in
early_kmem_cache_node_alloc() are not tracked and then kmemleak cannot
find n->barn. I got lost in the slub code, but something like this:

-----------8<-----------------------------------
diff --git a/mm/slub.c b/mm/slub.c
index 0c906fefc31b..401557ff5487 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7513,6 +7513,7 @@ static void early_kmem_cache_node_alloc(int node)
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->node[node] = n;
+	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);
 
-------------8<----------------------------------------

Another thing I noticed, not sure it's related but we should probably
ignore an object once it has been passed to kvfree_call_rcu(), similar
to what we do on the main path in this function. Also see commit
5f98fd034ca6 ("rcu: kmemleak: Ignore kmemleak false positives when
RCU-freeing objects") when we added this kmemleak_ignore().

---------8<-----------------------------------
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}
 
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
----------------8<-----------------------------------

-- 
Catalin

