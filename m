Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAB9CD98D9
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFDC6B009D; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C206B009B; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC5B6B008A; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501A46B0098
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9A0940302
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.28.F656A6D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07790100007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aRvaNWfA;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etwwk+UBNIMopirHMNGCuTJ8WFzK9o2sDlIbkCU/y/E=;
	b=G7OxqlXLpZ0MRA+/tlai+QU5UN8oShD19o3l4MR2t8og9pjLKNMKWYgxP+zxA0BjghpPe/
	XKt3qtj/YIMLs0qyxVeOhm+BPzs/Z5eIJvbYlinRQmigYC9HU/kiDT8Sy0w8vO1E9fmwxp
	J7wlkZEAmUUCV23GdM7uARxT8EEx6n0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aRvaNWfA;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=qS15bePbIV1Aq7AlTbPZ4bB4LXB+rL5UhF2vo5bnBI5SEe90wg8mw2JaAPGGg1F8Luz3Y8
	HJS1CKzB3+14tYG8junIlqOOdEpuUuGFOBOqZVP/kbMmnlRSUt9GFYEDPlHNnw6S09J454
	H0yoeOZWT4i4rTgFk4cSIm4rlRybAlc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=etwwk+UBNIMopirHMNGCuTJ8WFzK9o2sDlIbkCU/y/E=; b=aRvaNWfAS6g+gDAu0XKjGNB84n
	YQ7IMDvOKksVJWTEAv76k8pTrA4D156NGn11ZgheSAgqSLPwSDwCbGi5obQxZGjJXY9Jp4i9zZQLl
	ghTZNGVjsmvNK5OWdJlivo4zTyQc+8thOQhStor56IpK/fc5XKmWVE1JXbVhTsTYw59LuR5i5aQmj
	IBvRDL0FJVgoEToceNPxDPeUOgrw+bh2PrByHPYwRO+t/e4mD43ia4CKWtDtRFaAxx2X4oaGSTbU6
	zwWMtzUYp1gWNxy/Bv9IS29m1Ff9KfJ9AqniJw/eVfEVwhuZQl6CKOCK87xE48Cs+urvrpz3cEqhe
	ak9Ps3Vg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcx-00000003aSr-3soc;
	Sat, 13 Jun 2026 05:09:51 +0000
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
Subject: [RFC PATCH v3 01/10] static kmem_cache instances for core caches: infrastructure
Date: Sat, 13 Jun 2026 06:09:42 +0100
Message-ID: <20260613050951.855141-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 98o7n7ua8fcb3xuj4qi1rwf8bzqtonct
X-Rspamd-Queue-Id: 07790100007
X-HE-Tag: 1781327396-383364
X-HE-Meta: U2FsdGVkX1/pnngfMAdfuAqOMhAkg04vKaHXtWNkebpaCSiIG53c5qUU/MJz2wrPhNXGw+jbj+6OoDNUhb6QdBo0DajOoHvExbiKe1MP2Exuz0Zcfib1TVfKF3qL6hO7GdOpfGCnlPhq/eU8ktF0nYVder/Kzf3HAVPbc2eQuXM3nspXROXxcRX3sivVPLCOzt3GYAVsJjOV2Vz/74CCLyLTAyo5hBB5Mfs9mXv0bNUT+Xl6LCe9KPWfrzGhUC9qLP+D/7hr2GaOKQUZQxFTOlvXxH4Y0bgHzI7SI+YJ8V0kI31w1D3TlyjnpDds4fhyHWm3X++jQfMAU+sgMbQ9hU7fPhV5zx1IacVpbQk0DZDDTURXbRMq1gwrTQEOM3nL/cuhuwLotuY+cnJ5WVxVLw0gQ6+DEClRBs6Ilt2xHOAomjNe+NHgaexUr+nBqvBjeNIv+5hLUB+zGwEvpDeLYW84H5+Cg1+ukHHZCF//b7BpzInHY4nvle0NxnKutr4xO8y+aACq2fC/eE43kaHwCcapPrQk/mwk1ekkriDWsro4FLJSCzdftLJyP6nKqRBf61fiHv8snsYYNt4rvhdJ8ABK4CDr60ZpunIiGANmNXU1SPWvFozvJfLBrvAh+gNPdvF8PCpTa57FsKlMCZGjTcAnQAhkY7YfPLlnLSwMmyJSiAgFO3uu2P7dmNoXpmUcQXTDtGkueGNeuNj4Zy3fF+RI6LMLRKbPqNJmYGgQenYwrVUSXt0F1WciZr/fzcH5qLPY2DuqZt3nx56NCjUu1fDk6ks91U5mIv0L1X99alZqUecgux7mHKaIteWSL/3eICKSAxEwpr1YuwW4qbRrEufyR7kOkZRk3pSQ8kzPtptmcghPKh6dwb7CI8UVr4n2BT3PImqCaDZqdk6oiV+4ju6Cgk71pjbSv8ZoHtCv0GwMSYu8Dk7w2U3a0XWP5PqLndMhlkOJDFNnyef/q4n
 +6GKgmdj
 AEL2/cqhC5XY8J2FIB2zYc0YsHvdzlfLATqwiG3rw4ysLibfkpg1/YVISh0QBjuKzX/PgWBJ5ASGgsEg8Ch9SyITJHTGYhRrJPthq5aNNlKnG/sPI5gTKh+HZ0QmOosLt0uVlxlh7PtmkjyXr2AQcYdfJ4H6Q5BfsWm2ED1CsTC68AMXXKM4FdiXvjkNzBIvOyLM8SehAR7r6ecOPABgxvvAhh24xQNoaXXWSX2kZvrJglh1tL1oI/LfO/XGnB5YrQp6EunbChTaC53P0GbDnZ95ifi1beuZPAU6HOn/A+zNNfMJL9ymmUO0JUePYRtk3K9TIrVJ9EH6espqmUdzkfQzk9vgoSYxpBhH/Ugmr8ozTWZy68JQaWChNoWK9CnX6XHsiY2FTj5mLGoxS/V0IILLNoXIBgbvPgi3ZSi81YT47SCzkzrtdG1dewDZVtLPQTd6xOV2nQke3ccPLkma28f82/OWueOM3VrqYg7JNWVMjT4CaO+lSA4bm3Q==
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

	First of all, struct kmem_cache is opaque for anything outside
of a few files in mm/*; that avoids serious headache with header dependencies,
etc., and it's not something we want to lose.

	Solution: struct kmem_cache_opaque, with the size and alignment
identical to struct kmem_cache.  Calculation of size and alignment can be
done via the same mechanism we use for asm-offsets.h and rq-offsets.h,
with build-time check for mismatches.  With that done, we get an opaque type
defined in linux/slab-static.h that can be used for declaring those caches.
In linux/slab.h we add a forward declaration of kmem_cache_opaque +
helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
into the corresponding pointer to kmem_cache.

	At that point we can't actually *do* anything with those statically
allocated instances - the primitives for setting them up are going to be
added in the next commits.  Declarations of those primitives will also go
into linux/slab-static.h.

	Note that this header is needed only in places that define and
initialize statically allocated kmem_cache instances; users of such
instances need only slab.h.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Kbuild                      | 14 +++++++++++++-
 include/linux/slab-static.h | 13 +++++++++++++
 include/linux/slab.h        |  6 ++++++
 mm/kmem_cache_size.c        | 20 ++++++++++++++++++++
 mm/slub.c                   |  7 +++++++
 5 files changed, 59 insertions(+), 1 deletion(-)
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
index 000000000000..07aca67facee
--- /dev/null
+++ b/include/linux/slab-static.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SLAB_STATIC_H
+#define _LINUX_SLAB_STATIC_H
+
+#include <linux/init.h>
+#include <generated/kmem_cache_size.h>
+
+/* same size and alignment as struct kmem_cache: */
+struct kmem_cache_opaque {
+	unsigned char opaque[KMEM_CACHE_SIZE];
+} __aligned(KMEM_CACHE_ALIGN);
+
+#endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..a43d31eec06c 100644
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


