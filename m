Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE186D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD136B008A; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299726B00A5; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD7D6B00A3; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 712516B0093
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 121B11AB67E
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.04.39A11C1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59FFD180002
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HSRxtOhp;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Alv7P4uLpxdxMD2oNaydKzkEIOwEPgrlWZHJemiwZ9Q=;
	b=Vp+8aiuyi6l36/YYe6NBfpkXaW4DswF7rhvz4AjtD9rhzMlfgCiDEsP0nCu3RByU4WJ7Hf
	vdTCSbVzNnaAzsr171rALJmye5bESzSlz5+XubOTQkZ+BQAJn6EjEWNcOlGDvLEic6cGKb
	3401WO+1V+KMzeJRjcOrGqaJukI+zGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=MRxaJrjkeBXH7YXl6q8+Wl02xwd2p0m1DwWjM4PclEgf/xha5Hrcwy0ZuRKHHKLfOVaG/c
	Cg8oL8NTs0Fbe2mw3vJChQEp1F8ERN2HFehE2tup3iWqgOU7Ibm7M+nRyWWi7PX0r/G8Yn
	0yXhbK+OenwyhKu1ky+8q7yZ87HxKu8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HSRxtOhp;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Alv7P4uLpxdxMD2oNaydKzkEIOwEPgrlWZHJemiwZ9Q=; b=HSRxtOhpMmaEouMQr/0/lYOM/I
	qgQUuo0j8DPxV4mM+vI3CLx7moN8FzGu/b9+Lm039eQa0I4Zcm2bKlGuejHfqZP+UghkZEL+g8B41
	tKO7jjHY32xsn88QfbgW2QCe//hF3o/ckmKNn0QYjqG/DBvegOWChUgqDNMKsRXIIzpJPSNv2LU6I
	xQ0wFbMvXF2ABC5l4RB3QfxPGcuF0p6kxppzBCMeDe/J22kflfNl5x7j2Blv19cnr/vZjPqz3CZc0
	cGdexsOCdNtgPIp+4aD5j4Kt0/wkXDfUq5wMgcGAKW3bP5DtuP11QFxUIqrZ/+H3k3IwdheUoJzSR
	xgCg4lYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085Z6-0p2j;
	Sat, 10 Jan 2026 04:02:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/15] static kmem_cache instances for core caches
Date: Sat, 10 Jan 2026 04:02:03 +0000
Message-ID: <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59FFD180002
X-Rspam-User: 
X-Stat-Signature: fxyoq8isydi5j1rt1rqtkcab4n9jx8fe
X-HE-Tag: 1768017660-780737
X-HE-Meta: U2FsdGVkX1+0soTEAvc0obgv4s3UXSTVkEopUhiSlYnpfzAUk20atSNKVGr/hxgNkW4m3s4W+CYhUcSucCMtEeh8mbSB6s0/Ao/zaaU2a4MY2dnEgun89K8SF+oanf2FM9Ha6TWNPBtz5L5mKRqKhmG2kC50dR06jl1MDL3MS9p4FkHRnIpXtwpcel8XOYSMBRfiLLjX6zpTXjRTo5j2NZu2qQEAA1n6n0jVF+ILfTPRaXbNFv/8uF+jo0QMKvECzBGmZMRfMjTD1DrkcG5rO7jieDiPheT4L2Q+dUUc9WakddfIxGdhZHuMBNnRhT7Hgabg/toy4ftZAxRcGo1ziIUiZL/3i0feGplphjtC3ny4sgwa+iH756buBXRnAJY8G9YEK0VSNPhekne2UvzT/qn3WB2v2S+k9pvLZ8KZyNK7+jOPx742ZuKzQwxiXmf9Yitc/GCfTAZHAB31gNtlrhbnNsSeG1blhn482s14PBulEy5DlaMoZ9R/pXtkErGGbgiMFxdxQBo48tfXpS2sptKzQWYWZ1wl7SVJhFDw7D27qOpZMA3euYiKx6LLeNlzNQKNPZgTwwUjoCRLSJvzlOKzw83ewIVvkYbnX2l7MTED5QtU4P8yenRjCdqKkQdfeLEtLkzm0kubezAQn8jgpP6jWmzfAT8sV9JhHzgQwQqbt1MFIwEAI08QLK8MXzly6KQ51za0fJekl2Te3AUHYkky6qJvxkks3LZ7nVyMxCt0UJqC8E8Eugxbsxyy18bx1yl3SRuZPNlVb4EZrFknJz+62O1hMUo9bcj4oxzrYaKYV5TklCF0YEuvZB4y0wP2gwsu6H8adnFXH4repo5f24LyOndL6C14EcSzhOt8npDt3wkwrCXrZhtCHWWmxr71QgMt8FDCaHZ6WBBuZc8D9mVImfuJNzWvopRjfzhJWBDQX5k4T+6VcuzunMVgwn9Fz9hRuDDcVAgRT0grNn2
 OiP40ysV
 fU9cPqKWNS8FyYCO024XJp9m/Nq+GtDVuz4JuzjNuLeaQ3RmU3Zirun3XCShOodHcsdyiN7DoGH2IByIr7XPSwnqOl5nuRIwstRt0vFwFW7njMb/KM2ljsgExFg1yfRbW0EOYEsjQSmyGS/OjZewHciNX6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

        kmem_cache_create() and friends create new instances of
struct kmem_cache and return pointers to those.  Quite a few things in
core kernel are allocated from such caches; each allocation involves
dereferencing an assign-once pointer and for sufficiently hot ones that
dereferencing does show in profiles.

        There had been patches floating around switching some of those
to runtime_const infrastructure.  Unfortunately, it's arch-specific
and most of the architectures lack it.

        There's an alternative approach applicable at least to the caches
that are never destroyed, which covers a lot of them.  No matter what,
runtime_const for pointers is not going to be faster than plain &,
so if we had struct kmem_cache instances with static storage duration, we
would be at least no worse off than we are with runtime_const variants.

        There are obstacles to doing that, but they turn out to be easy
to deal with.

1) as it is, struct kmem_cache is opaque for anything outside of a few
files in mm/*; that avoids serious headache with header dependencies,
etc., and it's not something we want to lose.  Solution: struct
kmem_cache_opaque, with the size and alignment identical to struct
kmem_cache.  Calculation of size and alignment can be done via the same
mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
check for mismatches.  With that done, we get an opaque type defined in
linux/slab-static.h that can be used for declaring those caches.
In linux/slab.h we add a forward declaration of kmem_cache_opaque +
helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
into pointer to kmem_cache.

2) real constructor of kmem_cache needs to be taught to deal with
preallocated instances.  That turns out to be easy - we already pass an
obscene amount of optional arguments via struct kmem_cache_args, so we
can stash the pointer to preallocated instance in there.  Changes in
mm/slab_common.c are very minor - we should treat preallocated caches
as unmergable, use the instance passed to us instead of allocating a
new one and we should not free them.  That's it.

	Note that slab-static.h is needed only in places that create
such instances; all users need only slab.h (and they can be modular,
unlike runtime_const-based approach).

	That covers the instances that never get destroyed.  Quite a few
fall into that category, but there's a major exception - anything in
modules must be destroyed before the module gets removed.  For example,
filesystems that have their inodes allocated from a private kmem_cache
can't make use of that technics for their inode allocations, etc.

	It's not that hard to deal with, but for now let's just ban
including slab-static.h from modules.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Kbuild                      | 13 +++++++-
 include/linux/slab-static.h | 65 +++++++++++++++++++++++++++++++++++++
 include/linux/slab.h        |  7 ++++
 mm/kmem_cache_size.c        | 20 ++++++++++++
 mm/slab_common.c            | 30 ++++++++---------
 mm/slub.c                   |  7 ++++
 6 files changed, 126 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/slab-static.h
 create mode 100644 mm/kmem_cache_size.c

diff --git a/Kbuild b/Kbuild
index 13324b4bbe23..eb985a6614eb 100644
--- a/Kbuild
+++ b/Kbuild
@@ -45,13 +45,24 @@ kernel/sched/rq-offsets.s: $(offsets-file)
 $(rq-offsets-file): kernel/sched/rq-offsets.s FORCE
 	$(call filechk,offsets,__RQ_OFFSETS_H__)
 
+# generate kmem_cache_size.h
+
+kmem_cache_size-file := include/generated/kmem_cache_size.h
+
+targets += mm/kmem_cache_size.s
+
+mm/kmem_cache_size.s: $(rq-offsets-file)
+
+$(kmem_cache_size-file): mm/kmem_cache_size.s FORCE
+	$(call filechk,offsets,__KMEM_CACHE_SIZE_H__)
+
 # Check for missing system calls
 
 quiet_cmd_syscalls = CALL    $<
       cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags) $(missing_syscalls_flags)
 
 PHONY += missing-syscalls
-missing-syscalls: scripts/checksyscalls.sh $(rq-offsets-file)
+missing-syscalls: scripts/checksyscalls.sh $(kmem_cache_size-file)
 	$(call cmd,syscalls)
 
 # Check the manual modification of atomic headers
diff --git a/include/linux/slab-static.h b/include/linux/slab-static.h
new file mode 100644
index 000000000000..47b2220b4988
--- /dev/null
+++ b/include/linux/slab-static.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SLAB_STATIC_H
+#define _LINUX_SLAB_STATIC_H
+
+#ifdef MODULE
+#error "can't use that in modules"
+#endif
+
+#include <generated/kmem_cache_size.h>
+
+/* same size and alignment as struct kmem_cache: */
+struct kmem_cache_opaque {
+	unsigned char opaque[KMEM_CACHE_SIZE];
+} __aligned(KMEM_CACHE_ALIGN);
+
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
+#endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2482992248dc..f16c784148b4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -261,11 +261,17 @@ enum _slab_flag_bits {
 
 struct list_lru;
 struct mem_cgroup;
+struct kmem_cache_opaque;
 /*
  * struct kmem_cache related prototypes
  */
 bool slab_is_available(void);
 
+static inline struct kmem_cache *to_kmem_cache(struct kmem_cache_opaque *p)
+{
+	return (struct kmem_cache *)p;
+}
+
 /**
  * struct kmem_cache_args - Less common arguments for kmem_cache_create()
  *
@@ -366,6 +372,7 @@ struct kmem_cache_args {
 	 * %0 means no sheaves will be created.
 	 */
 	unsigned int sheaf_capacity;
+	struct kmem_cache *preallocated;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
diff --git a/mm/kmem_cache_size.c b/mm/kmem_cache_size.c
new file mode 100644
index 000000000000..1ddbfa41a507
--- /dev/null
+++ b/mm/kmem_cache_size.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generate definitions needed by the preprocessor.
+ * This code generates raw asm output which is post-processed
+ * to extract and format the required data.
+ */
+
+#define COMPILE_OFFSETS
+#include <linux/kbuild.h>
+#include "slab.h"
+
+int main(void)
+{
+	/* The constants to put into include/generated/kmem_cache_size.h */
+	DEFINE(KMEM_CACHE_SIZE, sizeof(struct kmem_cache));
+	DEFINE(KMEM_CACHE_ALIGN, __alignof(struct kmem_cache));
+	/* End of constants */
+
+	return 0;
+}
diff --git a/mm/slab_common.c b/mm/slab_common.c
index eed7ea556cb1..81a413b44afb 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -224,33 +224,30 @@ static struct kmem_cache *create_cache(const char *name,
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
 	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
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
 
 /**
@@ -324,6 +321,9 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
+	if (args->preallocated)
+		flags |= SLAB_NO_MERGE;
+
 	if (!args->usersize && !args->sheaf_capacity)
 		s = __kmem_cache_alias(name, object_size, args->align, flags,
 				       args->ctor);
diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..41fe79b3f055 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -47,6 +47,7 @@
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/slab-static.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -8491,6 +8492,12 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	/* verify that kmem_cache_opaque is correct */
+	BUILD_BUG_ON(sizeof(struct kmem_cache) !=
+		     sizeof(struct kmem_cache_opaque));
+	BUILD_BUG_ON(__alignof(struct kmem_cache) !=
+		     __alignof(struct kmem_cache_opaque));
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
-- 
2.47.3


