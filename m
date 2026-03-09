Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47980FCA17B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F156B0005; Mon,  9 Mar 2026 16:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF7F6B0089; Mon,  9 Mar 2026 16:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBE06B008A; Mon,  9 Mar 2026 16:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4586B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:31:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0644957266
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:31:12 +0000 (UTC)
X-FDA: 84527669184.06.9A1F93B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id EB8C64000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:31:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773088270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpMe9qAQLVZX21QZGzY8yvBvKTcFga0dy76omWmS/LE=;
	b=Pe4iNnAN5ilK5IwhO7aADrwJ9X2KP553tqyJcGuWlnNX9ezRhfhLw7iqL1LAoQiTllcdyw
	Pj+I1qO7R6icknwbFniwScZr8RlV3/BuXUDSwLtdt3BRJNprYuUfC/TvX/PqZ7aoXnhv5H
	JO8nbsnufqasccuokpipBRAYv6VXQvc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773088270; a=rsa-sha256;
	cv=none;
	b=zXV7CzORV4dQCT7id4uJczpCR6HFYFGTytXwfWNkxi+4ID0Ga+k8utjODvARZwXOgqNZFK
	+mU0Rk9jzqKVk2wQ/7gMk64CLL52g1lzIMYZV5ZftDV6j9i3HK0vXmfjlMfShKfhN0Wg+y
	moHKpHwpiACWuDvI60vbVVP0aa+c5WE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 992821516;
	Mon,  9 Mar 2026 13:31:02 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C777A3F7BD;
	Mon,  9 Mar 2026 13:31:05 -0700 (PDT)
Date: Mon, 9 Mar 2026 20:31:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Qing Wang <wangqing7171@gmail.com>,
	syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
	jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de,
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz, Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa8uByvL9GwsGfnO@arm.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
 <aassZV5PjgFx8dSI@arm.com>
 <aa66XJDX4QfmEbNA@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa66XJDX4QfmEbNA@hyeyoo>
X-Stat-Signature: ffpzih5cwu9xs7x4bhghofya7brjdk7h
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EB8C64000D
X-HE-Tag: 1773088269-161752
X-HE-Meta: U2FsdGVkX18Woi47P0WALzv5kC0i0LA+UiVlGbl1dFG1QLkIZeogC8E0vSNU3jwwgVJS1TqZ/QUkK5X4eib9taxIZcWNO5V/jdcnJaVJ1AyCysTWimGnS2To7rbgcKCSQivHtYhBycN7pHKlhr0NVJfr/uFSlsZU6MJWeVIzX5ovNdtY71K2n3FoxCfKCz8eKVI8wKw6b0iv31rY1zP/YdIiWBMUMahfyEKVDvLK+daZrs4CjsS2uXE3+8PrmLrnGh9iiE5yoxtbG1LaBqV+Mo6OsUjwQJf/JKddtfj78AjtSUBOD1EU39ov8PZCe6O0o3YpWiY1sq/y96HwcTQInL968YRwLb3/COnX9Gjw4hJZp8IjDDWr0B8kjlxp7g4JwItIKOX8NDzcfVicL3FM5WRuRZewA/eo+4NxHCW4wjnDJxe8L4hNFhI+71BiFoMpPacoC4M30/BafiObwpcR1LiTfIP0pw8YM0yYM1g9//J+OhvGToBzMo2w1jWP57ISJomGTfKVIkUItb37qBsF5BeY2opLBcxse2BbpGkLilir2p9EjSCcFnFVk1CJvZnJWemcZq2JaXRTMlVVWnvSKCgTIlRdjqaJE51p+uXya54yPvozUTQAl8KcIpLAmMW0yV0ez79/320T9syfduAhu4SU2oX9ftu2KB83+MosNDvVkR30M3FMvgayCSO4kXCl0Q3hiZIXbs89SmB0sNzMNm/ZQ34r2amMTVLEEq+loOIKE8EfGq+t/S9iKFkKz3HzdCpGiY/ghNKVgckomkl6hazcIFJvo2KGZSYALvhrziS8EMy2rutah8vZNQNVaUDRbXXfekP5jN3JCjb5BxK4Z8Cna8Gu4NnktUKOconjlSlt56B79qJkpdeclmCpNYB/HzzGRAfZwB5O10A5hBz+7Mt1nurdlPW+qesmVd4X0h1yuvXBDcwZYNK+NoJkeWGjMBCe++VS8FnJIdseTmC
 5/WHppty
 IQJZIjKy9og9T477IlIW3qtHv/PQb4Njn+MQDW7tyufLr5+XnhGCoejsZ4m+GRK4f1ezKadaXTaX8Ry9i+ycKpLK85RD44ymo6IGs5Zm8HMHtAhWpXosoC5tfT8OOQiMuxq+axN1OQcpwLt8xRJJoKZZFaZiLDa9Eg4QV20PxBKZ9rFpx8OF+xUsVBLrGIyX8pGPrCsAeLjepP5nj1TCyY9tTannN436xJTVbBgb4GAsjdqxyOP8ZHCvGomrQ+A7RcqOhwdmGmr+p9ZEgFJdcC0PZzDUgYBjuMmWMQCoRrRHxDJBIcCYvwkeMPZ5BiEOn/hdCfAjv4dH3FngfXJW0SjiI5n+FccHTL6M/Tg2VhkzrRyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 09:17:32PM +0900, Harry Yoo wrote:
> On Fri, Mar 06, 2026 at 07:35:01PM +0000, Catalin Marinas wrote:
> 
> [...snip...]
> 
> > I wonder whether some early kmem_cache_node allocations like the ones in
> > early_kmem_cache_node_alloc() are not tracked and then kmemleak cannot
> > find n->barn. I got lost in the slub code, but something like this:
> 
> This sounds plausible. Before sheaves, kmem_cache_node just maintained
> a list of slabs. Because struct page (and struct slab overlaying on it)
> is not tracked by kmemleak (as Vlastimil pointed out off-list),
> not calling kmemleak_alloc() for kmem_cache_node was not a problem.
> 
> But now it maintains barns and sheaves,
> and they are tracked by kmemleak...

We could simply add kmemleak_ignore(), especially as we don't need the
data in these structures to be scanned. We can assume the slab allocator
doesn't leak it's own data structures. But I couldn't figure out why
kmemleak couldn't track down the pointer in the first place and any
random kmemleak_alloc() I added did not solve it.

> > -----------8<-----------------------------------
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0c906fefc31b..401557ff5487 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7513,6 +7513,7 @@ static void early_kmem_cache_node_alloc(int node)
> >  	slab->freelist = get_freepointer(kmem_cache_node, n);
> >  	slab->inuse = 1;
> >  	kmem_cache_node->node[node] = n;
> > +	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
> >  	init_kmem_cache_node(n, NULL);
> >  	inc_slabs_node(kmem_cache_node, node, slab->objects);
> 
> But this function is called for kmem_cache_node cache
> (in kmem_cache_init()), even before kmemleak_init()?

That's fine, kmemleak starts as enabled by default and tracks early
allocations in a local mem_pool[] array. kmemleak_init() just
initialises its kmem_caches for the long run.

> kmem_cache and kmalloc caches should call kmemleak_alloc() when
> allocating kmem_cache_node structures, but as they are also created
> before kmemleak_init(), I doubt that's actually doing its job...

It does. I just added a kmemleak_alloc() in create_kmalloc_cache() and
kmemleak complained that the object from the kmem_cache_zalloc() is
already registered. Of course, no stack trace saved for these early
allocations but it does track them.

> > -------------8<----------------------------------------
> > 
> > Another thing I noticed, not sure it's related but we should probably
> > ignore an object once it has been passed to kvfree_call_rcu(), similar
> > to what we do on the main path in this function. Also see commit
> > 5f98fd034ca6 ("rcu: kmemleak: Ignore kmemleak false positives when
> > RCU-freeing objects") when we added this kmemleak_ignore().
> > 
> > ---------8<-----------------------------------
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index d5a70a831a2a..73f4668d870d 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
> >  	if (!head)
> >  		might_sleep();
> >  
> > -	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
> > +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
> > +		/*
> > +		 * The object is now queued for deferred freeing via an RCU
> > +		 * sheaf. Tell kmemleak to ignore it.
> > +		 */
> > +		kmemleak_ignore(ptr);
> 
> As Vlastimil pointed out off-list, we need to let kmemleak ignore
> sheaves when they are submitted to call_rcu() and ideally undo
> kmemleak_ignore() in __kfree_rcu_sheaf() when they are going to be reused.
> 
> But looking at mm/kmemleak.c, undoing kmemleak_ignore() doesn't seem to
> be a thing.

If that's needed, something like below:

----------------------8<---------------------------------
diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index 7d784e03f3f9..da2c849d4735 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -163,6 +163,7 @@ See the include/linux/kmemleak.h header for the functions prototype.
 - ``kmemleak_not_leak``	 - mark an object as not a leak
 - ``kmemleak_transient_leak``	 - mark an object as a transient leak
 - ``kmemleak_ignore``		 - do not scan or report an object as leak
+- ``kmemleak_unignore``		 - undo a previous kmemleak_ignore()
 - ``kmemleak_scan_area``	 - add scan areas inside a memory block
 - ``kmemleak_no_scan``	 - do not scan a memory block
 - ``kmemleak_erase``		 - erase an old value in a pointer variable
diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index fbd424b2abb1..4eec0560be09 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -28,6 +28,7 @@ extern void kmemleak_update_trace(const void *ptr) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
+extern void kmemleak_unignore(const void *ptr, int min_count) __ref;
 extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
@@ -104,6 +105,10 @@ static inline void kmemleak_ignore_percpu(const void __percpu *ptr)
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
+
+static inline void kmemleak_unignore(const void *ptr, int min_count)
+{
+}
 static inline void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 }
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c5100..99b7ebd03737 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1292,6 +1292,24 @@ void __ref kmemleak_ignore(const void *ptr)
 }
 EXPORT_SYMBOL(kmemleak_ignore);
 
+/**
+ * kmemleak_unignore - undo a previous kmemleak_ignore() on an object
+ * @ptr:	pointer to beginning of the object
+ * @min_count:	minimum number of references the object must have to be
+ *		considered a non-leak (see kmemleak_alloc() for details)
+ *
+ * Calling this function undoes a prior kmemleak_ignore() by restoring the
+ * given min_count, making the object visible to kmemleak again.
+ */
+void __ref kmemleak_unignore(const void *ptr, int min_count)
+{
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+		paint_ptr((unsigned long)ptr, min_count, 0);
+}
+EXPORT_SYMBOL(kmemleak_unignore);
+
 /**
  * kmemleak_scan_area - limit the range to be scanned in an allocated object
  * @ptr:	pointer to beginning or inside the object. This also
----------------------8<---------------------------------

-- 
Catalin

