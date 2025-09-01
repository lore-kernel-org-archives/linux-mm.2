Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6A3CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B038E0039; Mon,  1 Sep 2025 07:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303888E000B; Mon,  1 Sep 2025 07:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219478E0039; Mon,  1 Sep 2025 07:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC3B8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A96F785EF5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:06 +0000 (UTC)
X-FDA: 83840409492.30.EAA5CE4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 55ECB40008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PVZniRDU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mNw4yh6E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PVZniRDU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mNw4yh6E;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5j5fQlGn0LPWPBdKT0pIiyIhFFb2vklTM3tMRG9lg9Q=;
	b=YF8qp7c4rXufZbGrJa29+O0QiSHM5DtkCF4kybH59WExTIgcxo2y4AHRvGROEiPsJE5vzz
	u8KH+aXT8ds7kyjL8K3H432OBnuzyPjuPOB9FjQNFumk/EoHYOTm89/ers2DdBI3uhh9hC
	pMKCj3oKJpsnDE5aIw3zZK7qRtxotYo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PVZniRDU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mNw4yh6E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PVZniRDU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mNw4yh6E;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724944; a=rsa-sha256;
	cv=none;
	b=7Ezme4S8DB820+6avrVoyqW0PhO1HiCvLOtfK0YGs7w9XjDITKzcSthhW6Nf1E1n5H75Kx
	qy9u7D5elfgBkvYM0gdo2hyzXFPtypAzgAMbyYMZcawRoA3TeuvZGQu+7Xy/3/ALFh8flj
	zPzy8H4XeGy5DVRDbq7LesfjHhkGTww=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 513AE1F388;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j5fQlGn0LPWPBdKT0pIiyIhFFb2vklTM3tMRG9lg9Q=;
	b=PVZniRDU9YIsk3d628yJbZaolIEDlI0jypXglbbnmSBtZjPlSL5XPliyTp5GOh/N90t9rj
	my1TMACjoFK3dxKTPUO72yo3ulVeWw0AuBXuPcXOqT8RrIzFi0jpBbFB5cDjBVSIkdY0lh
	Kmg25I+7cDxrUWhd7+3RoFzvvVUyir8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j5fQlGn0LPWPBdKT0pIiyIhFFb2vklTM3tMRG9lg9Q=;
	b=mNw4yh6EqE8Pv3Svnai5eEjVI3q6e4GghUize9gqB3v2thZp+HqgWCO7j3tzUDpxHBidlO
	jgQGcOtvGdHfn4Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j5fQlGn0LPWPBdKT0pIiyIhFFb2vklTM3tMRG9lg9Q=;
	b=PVZniRDU9YIsk3d628yJbZaolIEDlI0jypXglbbnmSBtZjPlSL5XPliyTp5GOh/N90t9rj
	my1TMACjoFK3dxKTPUO72yo3ulVeWw0AuBXuPcXOqT8RrIzFi0jpBbFB5cDjBVSIkdY0lh
	Kmg25I+7cDxrUWhd7+3RoFzvvVUyir8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j5fQlGn0LPWPBdKT0pIiyIhFFb2vklTM3tMRG9lg9Q=;
	b=mNw4yh6EqE8Pv3Svnai5eEjVI3q6e4GghUize9gqB3v2thZp+HqgWCO7j3tzUDpxHBidlO
	jgQGcOtvGdHfn4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 334E113A3E;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mC43DMV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:52 +0200
Subject: [PATCH 02/12] tools: Add testing support for changes to slab for
 sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-2-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 55ECB40008
X-Rspam-User: 
X-Stat-Signature: r4sck5p8u1ri1u4t8p967wajrgcswikt
X-Rspamd-Server: rspam09
X-HE-Tag: 1756724944-864773
X-HE-Meta: U2FsdGVkX19jfQaa+lJMsMsM6kdLF0J9Q9tRxQs9ee9Fy9G0tlel6vKiCYJWKBoy40VkXtZP8Y8F1/Jk8H2LKUSbuCyqeI9fR1RHqIUlz/1Xyq5evq3iYnpJi+n41Lck3tHKpBzGWA83ItAhbMu2sNR1w+HKbGnSKFGcuDmn7ALjuhU/In6vZXoLhzONXIQZ268pnT9/Eyw0glH3+IqHKygaN5AGaeSv6dT8ypDL1UjFUGOCGFOhrs4m+2OegGNIkVKqictPoGcr2rtvOHr6X03OzuYk+OFSjuLHhjIbyw163cZCvtZMGMM2EGq3T9zomruCtVb2Q+tz3K6AEXf5wRg3zm08hBQtDiTKyjcGak+51m2+vZiIHLXDHKFgZD9XEjVdLiFNbYxiJ1BCwa79aa14QPS1KeKAbdiRrvwE6S7Ypx1gLVUH7ZQILcgaARldGcyqAJQRYuFdyc33ZIn12IfMJuJYxpSdAKpM1/3F3siEaYiUGB5J7jTLUzUW52f9AxBoEskvBeoiWqHc58xoWrdD6UuUxQNITbRU0FptRmhTlpMxDlcsB/XkQKkfxUubZsLgQ0gCKc2nZ7UDbNBl2FWW1PT/P8J8vSeqeBDexOOm3BhkNfDRTBIRcCt1+2dLFZ4oc0BsLpxwzIue67coBaNoOj2cktIpgfUtGop2dNjW2RgTjJwpedSAXYdIP0y/iSE/03jlB8/WL7YvRGT8VuN324KDn9h1tqSwd8YfMLdQbQw7qIT1EFwNBWWgafKQxg37t59SWAFJ63ixHIXfoxmsywikfrQ3D7JbioYk2ZhXFOv6Zw4cDzOYdYtjUplPUPnsQiT74U4lTl4aeC9xPWRuOWyZK3uGadGp8Zqous5+b7fCyGZNnk9hufkgRIqgMr66r4uaO8EBFJpYetwutCfeJKRVhXYNlcsTSP6+dFmBg9IWChe/6G33k2iyAp19bbgcR9SHdNJoOGdVXmH
 7DR0XDVz
 XJiTxc1z0pCTmmy6etFOL1vkkB6KP9acrfmVrG6mchFnrlo+hUNUN143D5X1HXeTqA2mrBUpFIL7EAUmDu+C4QuAroMFHM8cX4wO9thXpw5d3HQ/ReyC3lO/ZwDnyw2W/cAEebIMs1V3UMoyaNo1alH9g+48mHDApE+ZvRTMl5l3NzUNEQ1tE1DtWae78q+GNkJrfb+W9evHA52VUqDPkrRpuyZ4hAhD6lSZID8HbVeLEYtv90st+fpZGw8nd3guZS2wfJroFKpH5sObKnI6mazan1oXvWXobM5G3pDihsVco2V0H2B3u/zteMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The slab changes for sheaves requires more effort in the testing code.
Unite all the kmem_cache work into the tools/include slab header for
both the vma and maple tree testing.

The vma test code also requires importing more #defines to allow for
seamless use of the shared kmem_cache code.

This adds the pthread header to the slab header in the tools directory
to allow for the pthread_mutex in linux.c.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h        | 137 ++++++++++++++++++++++++++++++++++++--
 tools/testing/shared/linux.c      |  26 ++------
 tools/testing/shared/maple-shim.c |   1 +
 tools/testing/vma/vma_internal.h  |  94 +-------------------------
 4 files changed, 142 insertions(+), 116 deletions(-)

diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index c87051e2b26f5a7fee0362697fae067076b8e84d..c5c5cc6db5668be2cc94c29065ccfa7ca7b4bb08 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -4,11 +4,31 @@
 
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <pthread.h>
 
-#define SLAB_PANIC 2
 #define SLAB_RECLAIM_ACCOUNT    0x00020000UL            /* Objects are reclaimable */
 
 #define kzalloc_node(size, flags, node) kmalloc(size, flags)
+enum _slab_flag_bits {
+	_SLAB_KMALLOC,
+	_SLAB_HWCACHE_ALIGN,
+	_SLAB_PANIC,
+	_SLAB_TYPESAFE_BY_RCU,
+	_SLAB_ACCOUNT,
+	_SLAB_FLAGS_LAST_BIT
+};
+
+#define __SLAB_FLAG_BIT(nr)	((unsigned int __force)(1U << (nr)))
+#define __SLAB_FLAG_UNUSED	((unsigned int __force)(0U))
+
+#define SLAB_HWCACHE_ALIGN	__SLAB_FLAG_BIT(_SLAB_HWCACHE_ALIGN)
+#define SLAB_PANIC		__SLAB_FLAG_BIT(_SLAB_PANIC)
+#define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
+#ifdef CONFIG_MEMCG
+# define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
+#else
+# define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
+#endif
 
 void *kmalloc(size_t size, gfp_t gfp);
 void kfree(void *p);
@@ -23,6 +43,86 @@ enum slab_state {
 	FULL
 };
 
+struct kmem_cache {
+	pthread_mutex_t lock;
+	unsigned int size;
+	unsigned int align;
+	unsigned int sheaf_capacity;
+	int nr_objs;
+	void *objs;
+	void (*ctor)(void *);
+	bool non_kernel_enabled;
+	unsigned int non_kernel;
+	unsigned long nr_allocated;
+	unsigned long nr_tallocated;
+	bool exec_callback;
+	void (*callback)(void *);
+	void *private;
+};
+
+struct kmem_cache_args {
+	/**
+	 * @align: The required alignment for the objects.
+	 *
+	 * %0 means no specific alignment is requested.
+	 */
+	unsigned int align;
+	/**
+	 * @sheaf_capacity: The maximum size of the sheaf.
+	 */
+	unsigned int sheaf_capacity;
+	/**
+	 * @useroffset: Usercopy region offset.
+	 *
+	 * %0 is a valid offset, when @usersize is non-%0
+	 */
+	unsigned int useroffset;
+	/**
+	 * @usersize: Usercopy region size.
+	 *
+	 * %0 means no usercopy region is specified.
+	 */
+	unsigned int usersize;
+	/**
+	 * @freeptr_offset: Custom offset for the free pointer
+	 * in &SLAB_TYPESAFE_BY_RCU caches
+	 *
+	 * By default &SLAB_TYPESAFE_BY_RCU caches place the free pointer
+	 * outside of the object. This might cause the object to grow in size.
+	 * Cache creators that have a reason to avoid this can specify a custom
+	 * free pointer offset in their struct where the free pointer will be
+	 * placed.
+	 *
+	 * Note that placing the free pointer inside the object requires the
+	 * caller to ensure that no fields are invalidated that are required to
+	 * guard against object recycling (See &SLAB_TYPESAFE_BY_RCU for
+	 * details).
+	 *
+	 * Using %0 as a value for @freeptr_offset is valid. If @freeptr_offset
+	 * is specified, %use_freeptr_offset must be set %true.
+	 *
+	 * Note that @ctor currently isn't supported with custom free pointers
+	 * as a @ctor requires an external free pointer.
+	 */
+	unsigned int freeptr_offset;
+	/**
+	 * @use_freeptr_offset: Whether a @freeptr_offset is used.
+	 */
+	bool use_freeptr_offset;
+	/**
+	 * @ctor: A constructor for the objects.
+	 *
+	 * The constructor is invoked for each object in a newly allocated slab
+	 * page. It is the cache user's responsibility to free object in the
+	 * same state as after calling the constructor, or deal appropriately
+	 * with any differences between a freshly constructed and a reallocated
+	 * object.
+	 *
+	 * %NULL means no constructor.
+	 */
+	void (*ctor)(void *);
+};
+
 static inline void *kzalloc(size_t size, gfp_t gfp)
 {
 	return kmalloc(size, gfp | __GFP_ZERO);
@@ -37,9 +137,38 @@ static inline void *kmem_cache_alloc(struct kmem_cache *cachep, int flags)
 }
 void kmem_cache_free(struct kmem_cache *cachep, void *objp);
 
-struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
-			unsigned int align, unsigned int flags,
-			void (*ctor)(void *));
+
+struct kmem_cache *
+__kmem_cache_create_args(const char *name, unsigned int size,
+		struct kmem_cache_args *args, unsigned int flags);
+
+/* If NULL is passed for @args, use this variant with default arguments. */
+static inline struct kmem_cache *
+__kmem_cache_default_args(const char *name, unsigned int size,
+		struct kmem_cache_args *args, unsigned int flags)
+{
+	struct kmem_cache_args kmem_default_args = {};
+
+	return __kmem_cache_create_args(name, size, &kmem_default_args, flags);
+}
+
+static inline struct kmem_cache *
+__kmem_cache_create(const char *name, unsigned int size, unsigned int align,
+		unsigned int flags, void (*ctor)(void *))
+{
+	struct kmem_cache_args kmem_args = {
+		.align	= align,
+		.ctor	= ctor,
+	};
+
+	return __kmem_cache_create_args(name, size, &kmem_args, flags);
+}
+
+#define kmem_cache_create(__name, __object_size, __args, ...)           \
+	_Generic((__args),                                              \
+		struct kmem_cache_args *: __kmem_cache_create_args,	\
+		void *: __kmem_cache_default_args,			\
+		default: __kmem_cache_create)(__name, __object_size, __args, __VA_ARGS__)
 
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
 int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 0f97fb0d19e19c327aa4843a35b45cc086f4f366..97b8412ccbb6d222604c7b397c53c65618d8d51b 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -16,21 +16,6 @@ int nr_allocated;
 int preempt_count;
 int test_verbose;
 
-struct kmem_cache {
-	pthread_mutex_t lock;
-	unsigned int size;
-	unsigned int align;
-	int nr_objs;
-	void *objs;
-	void (*ctor)(void *);
-	unsigned int non_kernel;
-	unsigned long nr_allocated;
-	unsigned long nr_tallocated;
-	bool exec_callback;
-	void (*callback)(void *);
-	void *private;
-};
-
 void kmem_cache_set_callback(struct kmem_cache *cachep, void (*callback)(void *))
 {
 	cachep->callback = callback;
@@ -234,23 +219,26 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 }
 
 struct kmem_cache *
-kmem_cache_create(const char *name, unsigned int size, unsigned int align,
-		unsigned int flags, void (*ctor)(void *))
+__kmem_cache_create_args(const char *name, unsigned int size,
+			  struct kmem_cache_args *args,
+			  unsigned int flags)
 {
 	struct kmem_cache *ret = malloc(sizeof(*ret));
 
 	pthread_mutex_init(&ret->lock, NULL);
 	ret->size = size;
-	ret->align = align;
+	ret->align = args->align;
+	ret->sheaf_capacity = args->sheaf_capacity;
 	ret->nr_objs = 0;
 	ret->nr_allocated = 0;
 	ret->nr_tallocated = 0;
 	ret->objs = NULL;
-	ret->ctor = ctor;
+	ret->ctor = args->ctor;
 	ret->non_kernel = 0;
 	ret->exec_callback = false;
 	ret->callback = NULL;
 	ret->private = NULL;
+
 	return ret;
 }
 
diff --git a/tools/testing/shared/maple-shim.c b/tools/testing/shared/maple-shim.c
index 640df76f483e09f3b6f85612786060dd273e2362..9d7b743415660305416e972fa75b56824211b0eb 100644
--- a/tools/testing/shared/maple-shim.c
+++ b/tools/testing/shared/maple-shim.c
@@ -3,5 +3,6 @@
 /* Very simple shim around the maple tree. */
 
 #include "maple-shared.h"
+#include <linux/slab.h>
 
 #include "../../../lib/maple_tree.c"
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3639aa8dd2b06ebe5b9cfcfe6669994fd38c482d..09732eff8dd84555563b3d485805ebab7b204584 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
+#include <linux/slab.h>
 
 extern unsigned long stack_guard_gap;
 #ifdef CONFIG_MMU
@@ -509,65 +510,6 @@ struct pagetable_move_control {
 		.len_in = len_,						\
 	}
 
-struct kmem_cache_args {
-	/**
-	 * @align: The required alignment for the objects.
-	 *
-	 * %0 means no specific alignment is requested.
-	 */
-	unsigned int align;
-	/**
-	 * @useroffset: Usercopy region offset.
-	 *
-	 * %0 is a valid offset, when @usersize is non-%0
-	 */
-	unsigned int useroffset;
-	/**
-	 * @usersize: Usercopy region size.
-	 *
-	 * %0 means no usercopy region is specified.
-	 */
-	unsigned int usersize;
-	/**
-	 * @freeptr_offset: Custom offset for the free pointer
-	 * in &SLAB_TYPESAFE_BY_RCU caches
-	 *
-	 * By default &SLAB_TYPESAFE_BY_RCU caches place the free pointer
-	 * outside of the object. This might cause the object to grow in size.
-	 * Cache creators that have a reason to avoid this can specify a custom
-	 * free pointer offset in their struct where the free pointer will be
-	 * placed.
-	 *
-	 * Note that placing the free pointer inside the object requires the
-	 * caller to ensure that no fields are invalidated that are required to
-	 * guard against object recycling (See &SLAB_TYPESAFE_BY_RCU for
-	 * details).
-	 *
-	 * Using %0 as a value for @freeptr_offset is valid. If @freeptr_offset
-	 * is specified, %use_freeptr_offset must be set %true.
-	 *
-	 * Note that @ctor currently isn't supported with custom free pointers
-	 * as a @ctor requires an external free pointer.
-	 */
-	unsigned int freeptr_offset;
-	/**
-	 * @use_freeptr_offset: Whether a @freeptr_offset is used.
-	 */
-	bool use_freeptr_offset;
-	/**
-	 * @ctor: A constructor for the objects.
-	 *
-	 * The constructor is invoked for each object in a newly allocated slab
-	 * page. It is the cache user's responsibility to free object in the
-	 * same state as after calling the constructor, or deal appropriately
-	 * with any differences between a freshly constructed and a reallocated
-	 * object.
-	 *
-	 * %NULL means no constructor.
-	 */
-	void (*ctor)(void *);
-};
-
 static inline void vma_iter_invalidate(struct vma_iterator *vmi)
 {
 	mas_pause(&vmi->mas);
@@ -652,40 +594,6 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 	vma->vm_lock_seq = UINT_MAX;
 }
 
-struct kmem_cache {
-	const char *name;
-	size_t object_size;
-	struct kmem_cache_args *args;
-};
-
-static inline struct kmem_cache *__kmem_cache_create(const char *name,
-						     size_t object_size,
-						     struct kmem_cache_args *args)
-{
-	struct kmem_cache *ret = malloc(sizeof(struct kmem_cache));
-
-	ret->name = name;
-	ret->object_size = object_size;
-	ret->args = args;
-
-	return ret;
-}
-
-#define kmem_cache_create(__name, __object_size, __args, ...)           \
-	__kmem_cache_create((__name), (__object_size), (__args))
-
-static inline void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
-{
-	(void)gfpflags;
-
-	return calloc(s->object_size, 1);
-}
-
-static inline void kmem_cache_free(struct kmem_cache *s, void *x)
-{
-	free(x);
-}
-
 /*
  * These are defined in vma.h, but sadly vm_stat_account() is referenced by
  * kernel/fork.c, so we have to these broadly available there, and temporarily

-- 
2.51.0


