Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5AE5CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2AE6B0096; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE7E6B009E; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2FB6B009D; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4126B0092
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4C95A02DF
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.16.D294C75
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14956C0004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eEUfbi+C;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAFIfxuSCGXbqOFSe4BmaPoZkUH2BztV4wD/Fo26Jzk=;
	b=7ljfL3E4mcK2+mklc9todowcASe/vRMItS7XS73SCXHPJ4S0nyJPUnTp0Ud+kuSi8Q739G
	T/YfcDC3x7bPCYrp4qVI6Y90Xn97ULmWg0pJv4gsvJnBrNrN5j7OpEn96nkhluOz/TWwjm
	oa8oNDNmfznxo2vh6cLM60SocZuIi6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eEUfbi+C;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=IBGtBZ6oUkrUdB/cqt94fmOUZBqr/+udm100WJGj6tk1i/N3fi+d0hkudxkfA9kXU7YAby
	UUgb2iRDHBAyN/1dhztjVi8ILAM3EkiF3xW1v9urPnSbQXurO2fXbTRzd4uo+qULgIVlw8
	aDDvruyXIoUXKT5LdDG18AaUdUctuZ4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HAFIfxuSCGXbqOFSe4BmaPoZkUH2BztV4wD/Fo26Jzk=; b=eEUfbi+C0OqJpcI5jCkVeTLdCz
	kNmjCZWk25dQfls6lP9Zy0xGckD07nz7+gBFJTzha/Q/hkb/WIRQ0atARk1pvCx8xbTfGTeP0wXv5
	a1nH0mLSZLfhCRGDZUHa74ZjVO4vnPjR7PP2Xl11PQgNKXF+hI0Z1VhUr3UP4H6PG0U2RWlG48jzL
	dm3rKxPLWROIFeqr0LpTjTfvC0dSzuPOJa8aZHUCPJzv6nndaCseaM0cvRBZlj8tFixjUUW5RJkJ3
	ShYHOJiqkN/6Qe02uOkBbhrjO5D+Bya9L73l41DBIBVNum6J1CsS3l8SgzZan7HvbQafSoHhuWvJb
	lSfrfuow==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aSu-0WiF;
	Sat, 13 Jun 2026 05:09:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 02/10] static kmem_cache instances for core caches: setup primitives
Date: Sat, 13 Jun 2026 06:09:43 +0100
Message-ID: <20260613050951.855141-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14956C0004
X-Stat-Signature: 6pd9gwr9cbh7n7mqxwiu3mnpb6mwmrgf
X-Rspam-User: 
X-HE-Tag: 1781327396-461009
X-HE-Meta: U2FsdGVkX18SdQqMWavy1bNz2HvWThQH8LgmYYrlHLDYIjFfhy6gF5oun2J2UxjeqCnjOjElCo7R0xz0WJTUpyuWbNy6FR4TZs/JVYCti8bstdC41NzEVyQKoGPSAvNF8Bzolux8QtM2YGc5LEOO5cA4joVMy98vRq1YMynvg8jXjUWX76IL7Bd3OF0UT7rJ6dRK5A5KIVlUeFQRYf6VVQQrGCWNuvpgIoE+eBWmg3/iKgjja7JES5B6imxKbKWa2t7F3nFPkIgEuvPUED6LzAXFGMsoYaFTiqmETGtcpqjy3zPWDjyv6FQNSzJ+o/uKkVlFzs/eDcfB8ceO4m0GVB0Hda1zIZz5hJ/GYezxiR1FFTSncclxsCw1X6xaqVKQY5gp6qepfRCB/DU8OP/eCBGtbSEtpyZ5sVVJw9rvgolG6tPiaAHgzM0BDV4Xzz8wYvFMkGmNvRfHvHXQNZf5CkfvRWxajIDbDg8vNba4l1qMk4BjUEfk06PTFWXvLOgwl0OUNJf76j8SpEswJWL/tep31X3igzR8sB61n8TNXyoDhrVz2cL+WhwhK7qvRNJVNxjbUj5KGY2fIfeWQM1VDte75SPXnzOJryi28mrrRRCgLE1d4cPmxo/13w9qb4sBHRdIGekrtRUFNy2oR0N+oUC5ZUoVgEcaZw0nDaKWcFO5liM85Dth93NHsbLMNQmcGXE52yvIrAjC39oFG7LFpi62KbElldnSNoUwv2KpifEu8ZP3NJxjSbykXoARIBbAmBSStByFEkqGgjINTc+sZd2FP518mVhckvo1tFrkumuM38ua0ODBLiJ7jeIbTGvb/+8fl8Yp87eFty+QVYkWvDGGykwLGsvA7+1J9htsTkrX92lmIF7rAg0EGJkzpRRn6nRkams2ViMOTMruqZnqF1I9Xvmbf+Qr2wBQ2ZkvhkT5UCQiWLfoo9f/Be4jUcnA79bb8qPyjA94zoPn2fj
 qbexTn83
 1NdJCOuHs233NXGFEa0NAZaDO2gKQs833cgsWK/fyJUjQnRyGtyhqv+FoR1RG8tRAeH77Q30LhJzhaNzNIzuKAK7Wez3JpHE8ryIykI90QCyVIkqdzgO/f521krcT2cdJwLXwoHuGNWKIYh5DG/rrRRN4LkN4Py/x+hK6lUgKlaPeTIV7efvPASZgf4BoisaD7TjrcX+VkK0IyV0lIdCVr6Mguq8GhbhgtU7RI+oXis68uVVYOkHdBqKaN88qB77dZEktqnymY473EqRSF6QXRjpUfYdzELk+qU9P64rMR/iKFQYFKgAwyi2YIdEvV1XL1/9JwVHMCKtYZaKAy9tR8CfRMelO+hJLGE8OkQIFq70w5tz42k9S2SFvZzL9OwXQynERXFDDkH7nU6VZvpXXQC3FvyZEsg8ZjuqCs2ISqUL+deCg3i5i3toWxNSt6LX02FeJ9u3drKXvdMboQDw2+VeEhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach the real constructor of kmem_cache needs to deal with preallocated
instances and provide wrappers parallel to kmem_cache_create() and friends.

That turns out to be easy - we already pass an obscene amount of optional
arguments via struct kmem_cache_args, so we can stash the pointer to
preallocated instance in there.

* add struct kmem_cache_args.preallocated - a pointer to preallocated
struct kmem_cache instance into kmem_cache_args.  If it's non-NULL,
__kmem_cache_create_args() will set the supplied instance up instead
of allocating a new one.

* new struct kmem_cache.flags bit - SLAB_PREALLOCATED.  Set by
__kmem_cache_create_args() when it's asked to use a preallocated instance.

* create_cache(): do allocation (and, in case of failure, freeing) of
struct kmem_cache instance only if no preallocated one has been supplied.

* __kmem_cache_alias(): don't bother with aliases when setting a preallocated
instance up - we want this one and no other, TYVM...  Note that such instance
may very well be mergeable - later kmem_cache_create() might decide to return
an alias for it.

* sysfs_slab_add() should treat all preallocated instances as self-named -
no "unique" (== size-and-flags-derived) names for those, any symlinks
from possible future aliases will use the cache's name as target.  Think
what happens if two preallocated kmem_cache instances are set up to have
identical sizes and flags - "unique" names will be anything but.  Since
the preallocated instance won't go away before possible future aliases,
there's no problem with using its proper name.

* add new wrappers for __kmem_cache_create_args(): kmem_cache_setup(),
kmem_cache_setup_usercopy(), KMEM_CACHE_SETUP(), KMEM_CACHE_SETUP_USERCOPY(),
corresponding to kmem_cache_create(), kmem_cache_create_usercopy(),
KMEM_CACHE() and KMEM_CACHE_USERCOPY() resp.  A pointer to preallocated
instance is passed as the first argument, followed by the arguments
one would pass to corresponding kmem_cache constructor.

That covers the instances that never get destroyed.  Quite a few
fall into that category, but there's a major exception - anything in
modules must be destroyed before the module gets removed.  For example,
filesystems that have their inodes allocated from a private kmem_cache
can't make use of that technics for their inode allocations, etc.

It's not that hard to deal with, but for now let's just ban
including slab-static.h from modules.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/slab-static.h | 53 +++++++++++++++++++++++++++++++++++++
 include/linux/slab.h        |  4 +++
 mm/slab_common.c            | 33 ++++++++++++-----------
 mm/slub.c                   | 20 +++++++-------
 4 files changed, 84 insertions(+), 26 deletions(-)

diff --git a/include/linux/slab-static.h b/include/linux/slab-static.h
index 07aca67facee..007fc0bd4e8c 100644
--- a/include/linux/slab-static.h
+++ b/include/linux/slab-static.h
@@ -5,9 +5,62 @@
 #include <linux/init.h>
 #include <generated/kmem_cache_size.h>
 
+#ifdef MODULE
+#error "can't use that in modules"
+#endif
+
 /* same size and alignment as struct kmem_cache: */
 struct kmem_cache_opaque {
 	unsigned char opaque[KMEM_CACHE_SIZE];
 } __aligned(KMEM_CACHE_ALIGN);
 
+#define __KMEM_CACHE_SETUP(cache, name, size, flags, ...)	\
+		__kmem_cache_create_args((name), (size),	\
+			&(struct kmem_cache_args) {		\
+				.preallocated = (cache),	\
+				__VA_ARGS__}, (flags))
+
+static inline int
+kmem_cache_setup_usercopy(struct kmem_cache *s,
+			  const char *name, unsigned int size,
+			  unsigned int align, slab_flags_t flags,
+			  unsigned int useroffset, unsigned int usersize,
+			  void (*ctor)(void *))
+{
+	struct kmem_cache *res;
+	res = __KMEM_CACHE_SETUP(s, name, size, flags,
+				.align		= align,
+				.ctor		= ctor,
+				.useroffset	= useroffset,
+				.usersize	= usersize);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+	return 0;
+}
+
+static inline int
+kmem_cache_setup(struct kmem_cache *s,
+		 const char *name, unsigned int size,
+		 unsigned int align, slab_flags_t flags,
+		 void (*ctor)(void *))
+{
+	struct kmem_cache *res;
+	res = __KMEM_CACHE_SETUP(s, name, size, flags,
+				.align		= align,
+				.ctor		= ctor);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+	return 0;
+}
+
+#define KMEM_CACHE_SETUP(s, __struct, __flags)                          	\
+	__KMEM_CACHE_SETUP((s), #__struct, sizeof(struct __struct), (__flags),	\
+			.align	= __alignof__(struct __struct))
+
+#define KMEM_CACHE_SETUP_USERCOPY(s, __struct, __flags, __field)		\
+	__KMEM_CACHE_SETUP((s), #__struct, sizeof(struct __struct), (__flags),	\
+			.align	= __alignof__(struct __struct),			\
+			.useroffset = offsetof(struct __struct, __field),	\
+			.usersize = sizeof_field(struct __struct, __field))
+
 #endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index a43d31eec06c..ec68aabf98df 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -62,6 +62,7 @@ enum _slab_flag_bits {
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
+	_SLAB_PREALLOCATED,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -248,6 +249,8 @@ enum _slab_flag_bits {
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
+#define SLAB_PREALLOCATED	__SLAB_FLAG_BIT(_SLAB_PREALLOCATED)
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -378,6 +381,7 @@ struct kmem_cache_args {
 	 * %0 means no sheaves will be created.
 	 */
 	unsigned int sheaf_capacity;
+	struct kmem_cache *preallocated;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8b661fff5eed..5b6aaa96d68d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -234,33 +234,30 @@ static struct kmem_cache *create_cache(const char *name,
 				       struct kmem_cache_args *args,
 				       slab_flags_t flags)
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s = args->preallocated;
 	int err;
 
 	/* If a custom freelist pointer is requested make sure it's sane. */
-	err = -EINVAL;
 	if (args->use_freeptr_offset &&
 	    (args->freeptr_offset >= object_size ||
 	     (!(flags & SLAB_TYPESAFE_BY_RCU) && !args->ctor) ||
 	     !IS_ALIGNED(args->freeptr_offset, __alignof__(freeptr_t))))
-		goto out;
+		return ERR_PTR(-EINVAL);
 
-	err = -ENOMEM;
-	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
-	if (!s)
-		goto out;
+	if (!s) {
+		s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
+		if (!s)
+			return ERR_PTR(-ENOMEM);
+	}
 	err = do_kmem_cache_create(s, name, object_size, args, flags);
-	if (err)
-		goto out_free_cache;
-
+	if (unlikely(err)) {
+		if (!args->preallocated)
+			kmem_cache_free(kmem_cache, s);
+		return ERR_PTR(err);
+	}
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
 	return s;
-
-out_free_cache:
-	kmem_cache_free(kmem_cache, s);
-out:
-	return ERR_PTR(err);
 }
 
 static struct kmem_cache *
@@ -269,6 +266,9 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
 {
 	struct kmem_cache *s;
 
+	if (flags & SLAB_PREALLOCATED)	// no aliases - we are using this one
+		return NULL;
+
 	s = find_mergeable(size, flags, name, args);
 	if (s) {
 		if (sysfs_slab_alias(s, name))
@@ -366,6 +366,9 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
+	if (args->preallocated)
+		flags |= SLAB_PREALLOCATED;
+
 	s = __kmem_cache_alias(name, object_size, flags, args);
 	if (s)
 		goto out_unlock;
diff --git a/mm/slub.c b/mm/slub.c
index c0765173911d..eee68e0ad7ed 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9593,18 +9593,16 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	int err;
 	const char *name;
 	struct kset *kset = cache_kset(s);
-	int unmergeable = slab_unmergeable(s);
+	bool no_symlink = slab_unmergeable(s);
 
-	if (!unmergeable && disable_higher_order_debug &&
+	if (s->flags & SLAB_PREALLOCATED)
+		no_symlink = true;
+
+	if (!no_symlink && disable_higher_order_debug &&
 			(slub_debug & DEBUG_METADATA_FLAGS))
-		unmergeable = 1;
+		no_symlink = true;
 
-	if (unmergeable) {
-		/*
-		 * Slabcache can never be merged so we can use the name proper.
-		 * This is typically the case for debug situations. In that
-		 * case we can catch duplicate names easily.
-		 */
+	if (no_symlink) {
 		sysfs_remove_link(&slab_kset->kobj, s->name);
 		name = s->name;
 	} else {
@@ -9622,12 +9620,12 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	if (err)
 		goto out;
 
-	if (!unmergeable) {
+	if (!no_symlink) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
 	}
 out:
-	if (!unmergeable)
+	if (!no_symlink)
 		kfree(name);
 	return err;
 }
-- 
2.47.3


