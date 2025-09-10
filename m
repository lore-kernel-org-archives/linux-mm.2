Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25340CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560338E0019; Wed, 10 Sep 2025 04:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2078E0002; Wed, 10 Sep 2025 04:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3635D8E0019; Wed, 10 Sep 2025 04:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5C08E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8C5F1A0788
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:48 +0000 (UTC)
X-FDA: 83872596696.08.A333601
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id A15974000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pm/ZH8ui";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39y++7wt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pm/ZH8ui";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39y++7wt;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svSQV11Yo8FARaPQKORg7oH4qaytNWNITJXkEtgw9mY=;
	b=faB8VxmynxnU5XpjbUK5u+Ib6SwAFBc97uzLrOu8tWDa5o+IZHF/IaMPB+u3+lDsdWu8Hv
	K4D8WiOyTbD/Q+SPe9m9GdvevKbsF7qUg8OB74wXVnIr1QGfv+bNTW3MeTQFKsudz1lQEL
	spFMy2hzwo57ixqB8nWZ738grnvMP28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491306; a=rsa-sha256;
	cv=none;
	b=tt1uJr9xhzfYFHwS5XSgP20r2qt/asSysYwK0wDz0txtrttQkR3RRSz6O3o0AiC67QlG5F
	knLxAWOs+djdRmjqem8Y+ngJZ7Hl+iQS/DsUoVFUYn8XB861Sp41WzVfca80FXHezqNwjS
	j3JUykBh5gAJ6SYTIPfHmppyU7qKDj0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pm/ZH8ui";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39y++7wt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pm/ZH8ui";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39y++7wt;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4491134C4C;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svSQV11Yo8FARaPQKORg7oH4qaytNWNITJXkEtgw9mY=;
	b=pm/ZH8uikXCX3oNciw6mLvEfYz3eXVMZkk0o3oj36hkG6+TJDhwQ9GUbRNwLctIeWsexjz
	1U1B14wupcf1KhBG+Or+1p6PRHQdP3VUsVt+1X0pFmw/7TBApQLUAZnvAD4LcOgQxgSfjj
	1mmkcditv/002iyOZkGavHiYoQS54oQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svSQV11Yo8FARaPQKORg7oH4qaytNWNITJXkEtgw9mY=;
	b=39y++7wtiRDAmGju397ZjgvNgru4MbxLvr7tiW+mKsihSPL+BSoc5Xms2tVazFPF9+0EGG
	WG7plpUVmedNWQBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svSQV11Yo8FARaPQKORg7oH4qaytNWNITJXkEtgw9mY=;
	b=pm/ZH8uikXCX3oNciw6mLvEfYz3eXVMZkk0o3oj36hkG6+TJDhwQ9GUbRNwLctIeWsexjz
	1U1B14wupcf1KhBG+Or+1p6PRHQdP3VUsVt+1X0pFmw/7TBApQLUAZnvAD4LcOgQxgSfjj
	1mmkcditv/002iyOZkGavHiYoQS54oQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svSQV11Yo8FARaPQKORg7oH4qaytNWNITJXkEtgw9mY=;
	b=39y++7wtiRDAmGju397ZjgvNgru4MbxLvr7tiW+mKsihSPL+BSoc5Xms2tVazFPF9+0EGG
	WG7plpUVmedNWQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C247613B03;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iOAmL0IwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:15 +0200
Subject: [PATCH v8 13/23] tools/testing: Add support for changes to slab
 for sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-13-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Stat-Signature: x4m9k94j5jf5y9pxp7c93ca8x3ickx8z
X-Rspam-User: 
X-Rspamd-Queue-Id: A15974000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757491306-797598
X-HE-Meta: U2FsdGVkX19Sev516qiUSzLlyk75R9OG9L3+EqOoDLgv0YoBWpckDYwTcat35+h5PAeJkBehD76s+KyJJ7DhLuKsV0B+89wAvizKkwC4GxN3/O+a/gr7HMNiXdXU0mLfU3KHqJPNtXAEw/7XeABYRyGvB5UtPQ8cMz1QliWS9M13Aboz6KK0pQtPrYTm3DuV+w9JID5gcxGohbeUroVy3juiehBezw0NmPvjK4mPv4E6L0n6e4wSGOBPku0+0iFY9wg2rDyluSxlMj3iLZqLgaHWB4YPQhk2ksXHH+V4vEvgBI7XDoFVy2KSvUImw0AlqaKTal+61yqj2PVO04nCKG30EdG29B8scf2Jdcu13MDTA2GSRBOo5mP9V4qYjJPPQ8hA7GhIXspope8KW63ZTsnGLs2opvC7Oyil3+8skPRh0Cm4hullCnDuj3GjK8SkDaoEBEomnrEGGHmdDV0hM1LLM8uej5DmaigXyHWwbmGbs3E+ufFOoWalflBty/pkJuZhiaek2y9O1Er+2eBIaMd6Wg5HIqHn2ccaUXOjqpDa+vwAAjrg7JOMdq6sirX8yHqVG0aw4M8FiLspjQUofmuLQV/RgHKkngzRMDFK97UUzxLxt3V+Pnfo/Lx+2sF+ZKT7nr9GgseZbYyyIrCZL8uZoQJIJ/trrNA+S6SR+y/Cru51dJix588RLGhn5R8vA/FwZ4/3N3BJJuqLik3+Hbcpak9CCHUL8Ev9+Vl1JUETnejvMCfwbk+9xgpeuxwkxPOD3MX7X8qRjGt6pOZll4w5WSvAuJjYZZ6H31TA4TpW+5bckc3AWOESwfcNODVa0wLWnkxVDGWvuhCqVGvJkftnSOMTdmHqTNM1wWP6718P98Yxvp84FUAxijpz/LpTOTZ0WsDe/+ylaFU7Fg6Hb8xnaAyiFw32QRgRN8h5FjUunb8Bqt5c4A3rs6uRvNXYnjToEyQquElb//95KOf
 QvKgmr9E
 MldzISIe7zg0XADM/f7IwXkXazqGRYEv4tSY2bEqXbvUY1VEo69vcW1n+b4jntztJsZp9GLeIFcVF+AKwguQ72C/3OUuzJMaF7x901VTdjWB+ejC5p+MzKV4f4of+Iwy72HUBpHGES446ANGPNwWdu/t1qcSq2cLNcHSNGNB+C3IWw4ZFbRlepjWSDut0Mk9t41FDiUXux9tiaHjLuUSCH+z0wc/el8txob99EZN5+VHl8ihdoa+xC0mBzB2gDdYjZd5iB4EpQZBOF3lvVbDSrjUI6Kib1IDGgKHneUDYZHmvbrewk/HYweYLRw==
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
 tools/testing/vma/vma_internal.h  |  92 +------------------------
 4 files changed, 142 insertions(+), 114 deletions(-)

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
index 6b6e2b05918c9f95b537f26e20a943b34082825a..d5b87fa6a133f6d676488de2538c509e0f0e1d54 100644
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
@@ -652,38 +594,6 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
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
-	return calloc(1, s->object_size);
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


