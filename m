Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E213ECD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CA36B009B; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD74E6B00AB; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3916B009B; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4064A6B009E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DCC81657C5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.25.8A23376
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14E8F100004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Q4IFSYQa;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmpJtUEAqlwQwbtPYTmBbdoKP0Zgf9vvtoZ+D2BcZB8=;
	b=cqaYz40HMKA/ARjaX+xfnl+Ae+YngAJkTHO+Yepeev6ewCkVxP+BIaVB0U07t0sNPSL5N/
	J0GYyDPThhrD6LjFfwWdNMzZyAuBbOaE7ghXFE8PD3s+qfkDom+Ukrz+oR/0nAaWH0IEJE
	aCbb+Kv8dF4MUJdBhmWhUH4ADGjA9ss=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Q4IFSYQa;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=ubmSGVfHJHspdpraua4r8rAVKeG0Em/4KgFNkpzdIcQZj8//3Mc2TLO/ukmwz9XBp74KGT
	s1bWDlPiA0otzUdy4Ml3SIkems32oFQYBJAG+QZK9ULKd9EM9YE03888nsbiXUUaAiwMDh
	FjoIk8aq/hTruj7PTrBmUn0B3OcFJyQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gmpJtUEAqlwQwbtPYTmBbdoKP0Zgf9vvtoZ+D2BcZB8=; b=Q4IFSYQauDkmF+xqLkMxFj0NOV
	5aNpqssLsGDb9dyDG+RZF20LKdio4t3JJP4EjXlstvsG//OgPreuNgzilpp3F4TpOHHuqqahdDOJ3
	TXs+46tF0B6cMay0f6Ouvfa3dcgJIhKDQmSVAxAT8yQBDP0hYQX0MvLOzfvsciZSWSamnpn+f+llA
	HRNKG/GQjnfRE7a8DIHI9bxyF1iKjTVhZ9TDybZlQWrX+3thoabS32qOsbzoqhfgkNqRscjWco7Jb
	PFCVq2CUOoRk2haooKKHrt5Y99oWTqIEWvQiEoaucjIEogCbcRs2Zq+qm6UPpR4IrU6ffKDr8s/Dl
	NvzPdoqQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz3-000000070m4-2dDv;
	Thu, 11 Jun 2026 17:14:25 +0000
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
Subject: [PATCH v2 1/9] static kmem_cache instances for core caches
Date: Thu, 11 Jun 2026 18:14:16 +0100
Message-ID: <20260611171425.1671254-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14E8F100004
X-Stat-Signature: e5keebmfdu4dzwr733hawekhy735ooxi
X-HE-Tag: 1781198066-314788
X-HE-Meta: U2FsdGVkX185uZ5PUHt4hC1541ihOPwZXANY0z4xctPv+TymVhooRr7AQBe9CxgLk5yjyatLt6zykHwkjEOgFXaY3WfwXwZ7nlW9Kw08LPclaLI+Xb7mNk9XVAd6KfCpDXnp2yRiMUYnx+uU8oB3+kk+/kYr06ForbDTD7nj56N9J9DOeRdavZ5QmFuLfQpI5k37JCNCVA/tdqN7vltE9l14Ksjxn11rbEMFRY2ruaRjTEjy6NV/nuHzgIX4mRuMnN8KlhNrpZgMIJZh+OjomwEdMbiH9azQq3i8rpck/jB4STGWvDxn+XAIh+JFYhg1hp+rPLQnWdHGTkFSJBsQen6CfNBgHPHXihAe3g/OPQAdcg7p2cGD320Z8n8D3OwNxYsb48HDiw9s4WnsxAYaAqZC4uE2BbfkGaFC7d7jGg0rYZopdkR1CbpjgBcwbrZ5ENvenz0LjHPF9s6zV/Ww4ptyuEPPKYM9Nrv4s+hWDE34ftxtCVD0eKa2IZPAFIlO3a6SOj28NAKyDHIYd4ZXa9KJaGFHIMNd0BCxmtCZdwRK0Oh9/Z3JmZHlWbKduJvEWNHzg7DgrgbR0YttVhqp3LZ3h6CjwXsqMyaU/jphRfrQnir51PnSxgjNl8zMTObTvisoTp7RaxSogOW1N8Wmqa6RSg9rYHyIhWn6P9o1utwtKTIK4/kqaXsJRYjKW3iyrT/bn2n452rf2tEFJuQvGrE36GSVLI/QrOHRRFdFFmmFtLcUztcLE84AhqIGjmgQ+24o2FBypKZd0jrUeNslY7OGpDCQ8RRlgcdi+UH3mPyWLPC1ey7PjikC2VoFV++cbUo1WABZT5QDqeS8fMxKv/mK8Kcfa98lUCKO6lh3udESPtL42H+55yfwgXZWHBNYhL1hXHjdNFon46s6t/VnxBhWQOtZV+FJsO+L/tSZn2JEoSNUFRzHCX/4tcViTDVC7RztrIYdMefXFWxg32Z
 sGx+SY/U
 Toj818BDFtm6LuOIGQfifrV1xhUO7aQz3lJ14GXEkK/EuOoy7Lvx9n5D5EmlTCRBiWsEVcz+8M5dut6sTfFTbqHn7SURqiDF3bxNkDAppsy2B0PwQGoXcWTQsy2ck5uIX5eC5MVH3wKewNsWwC9A+7nQczthhBnY7mxCggjnjHwfZzmMV/XG2k1bh7JhKClsv5Q6OXq24b0zl66l5OEyr1d+BkF4haitGnEGuQMRSQhqvNhy/9UFuerYSpOqaWjkg+vtgd3au/SpFyhx98pv5ee7T5/6izlURerH0zN54muNjDpZDt+mG68CA+2KrxgCS0vlnWKP7oCmzATpVenNjBYVTaUMEotUiiUSxkZdhpZJnR+xkY0gsX13sJ6u8sCwqkDCTSz2yVtmK5QZSTDCS9aq0gx75/GsyT+/T36JsZ/SnmChUrMspm7npDMhqUnFWM+xdd4lUqknNdjoJ0HCljIh4Zw==
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
mm/slab_common.c are very minor - we should not merge preallocated caches
with anything already created, use the instance passed to us instead of
allocating a new one and we should not free them.  That's it.

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
 Kbuild                      | 14 +++++++-
 include/linux/slab-static.h | 65 +++++++++++++++++++++++++++++++++++++
 include/linux/slab.h        |  7 ++++
 mm/kmem_cache_size.c        | 20 ++++++++++++
 mm/slab_common.c            | 30 ++++++++---------
 mm/slub.c                   |  7 ++++
 6 files changed, 127 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/slab-static.h
 create mode 100644 mm/kmem_cache_size.c

diff --git a/Kbuild b/Kbuild
index a6a0192dea08..64f29f1f0e71 100644
--- a/Kbuild
+++ b/Kbuild
@@ -45,6 +45,17 @@ kernel/sched/rq-offsets.s: $(offsets-file)
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
 
 missing-syscalls-file := .tmp_missing-syscalls$(missing_syscalls_instance)
@@ -58,7 +69,8 @@ $(missing-syscalls-file): scripts/checksyscalls.sh $(rq-offsets-file) FORCE
 	$(call if_changed_dep,syscalls)
 
 PHONY += missing-syscalls
-missing-syscalls: $(missing-syscalls-file)
+missing-syscalls: $(missing-syscalls-file) $(kmem_cache_size-file)
+	$(call cmd,syscalls)
 
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
index 2b5ab488e96b..f63657d3cf81 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -265,11 +265,17 @@ enum _slab_flag_bits {
 
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
@@ -372,6 +378,7 @@ struct kmem_cache_args {
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
index 8b661fff5eed..57de41c7f1aa 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -182,6 +182,9 @@ bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
 	if (args->ctor)
 		return true;
 
+	if (args->preallocated)
+		return true;
+
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
 		return true;
 
@@ -234,33 +237,30 @@ static struct kmem_cache *create_cache(const char *name,
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
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..c0765173911d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -50,6 +50,7 @@
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/slab-static.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -8484,6 +8485,12 @@ void __init kmem_cache_init(void)
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


