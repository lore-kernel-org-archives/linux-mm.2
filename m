Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49087D1CDAD
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C98F6B002F; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0E86B0030; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767DE6B0031; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68D366B002F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D15713BB2B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
X-FDA: 84179756640.03.052B932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C9BF140020
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9nAj91d;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCfGGacAogoVMN4Sou56HjfcvUYFVNuDcZXKBf05dTI=;
	b=PXkkLWaDCHagFJSQpuAmfufKdee96G18Fywyv6k3QG4TLph8oBEVuV3Cl79EK0O3Yv5zXO
	W0V8QuQ80Ro0jgLH2AdQfKL6ggmpbh8wFXHygSLhHz09VyfxzopSn40aUgpjA4rIBDhEIV
	NozdYAmHt5dSODgbOKnTRy5TrYnYstk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9nAj91d;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804638; a=rsa-sha256;
	cv=none;
	b=M/PEHucQ6lWzPm25hGpjE1eZej9fcu63FfYZj7aOLF2+8QGqUGYLdZy4fdmKpe2oBCtGr/
	S6KLAJn/HmXxyYWaRFgql/PJKbpqLuT/u1Cjcz3JOobTfFMPunTby9uPvg7KO7xxBpJ3mU
	XnN9CBpMCiEyrdIC8YOmTrGpf3ZpLE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F60C4089E;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DF8C4CEF5;
	Wed,  3 Dec 2025 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=b70/KGt4+G3yUdizOvICLD5U1fsug4s3g9xHogw1SUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9nAj91dfGyTnOUBJPoJPhGYAxKJ7ud8/GAvnlEj5Knst1Ffx8Vp/swNMKMPimAO0
	 tXzYYuXUhMqkCZAf1yheWhyqYmdW76P8q/UF1g/ZWOsSKr+Fo5UhjRv6GzxvBj4YL/
	 DDISbhgsZWTUnQ7MBsxYC4gGatObZQy3JuDkqbh5NdOLhf/XBh5mBm2BUYET34g5Rr
	 BiFt53ElbYC4DNWYdAz5tkzZc6AykXlQyLWEo5/sB8XA2XmAruOFn72oF0VwkxIx/X
	 LwRmSKJcalRuK4HTTHLGIBHKNq+IWQuV7zFlrwG+gWnSLf+5PCpDop6HfDnbw9g6ZA
	 S8GMyd7419nVg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Date: Wed,  3 Dec 2025 15:30:31 -0800
Message-Id: <20251203233036.3212363-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6780; i=kees@kernel.org; h=from:subject; bh=b70/KGt4+G3yUdizOvICLD5U1fsug4s3g9xHogw1SUE=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJyRdT0dZKVzbqX/13sW8G0Y9t5792Lj74ccHToeWy B41mzt9b0cpC4MYF4OsmCJLkJ17nIvH2/Zw97mKMHNYmUCGMHBxCsBEMjUYGX61330w888Snyjf LI2QN2cnCX7Wilml9/iFq3CKymy1+2uBKjQWzX5stLx/dUvRkUuCvyed2H75z43s/c4ftt65Z36 FjQ0A
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C9BF140020
X-Stat-Signature: 5t56nhbbwwiswnjm4pg5spzn6tw7nnta
X-Rspam-User: 
X-HE-Tag: 1764804638-592897
X-HE-Meta: U2FsdGVkX1+m5OIDCt+7fuR2awCt0fyFYgVljOGFo/uyAaume4uD6VbLAchvE2JFwqmKQckO26mjRQB7GtB8a3v6LUeUeRUJ/CRuXvvuzPib/2BnFM45B0yDstnstkKOVyzMTLIOqfJxGxfyXDQHwuvqO359OVFDWXIJypGppSlmweABM2gon2Lic197irUbIAerU7qWa0yMCredegPSBAEqWwoxJwdhG9nQktmCR7qhxEsojzOr8sQpu0CxiTvt1kuu3BaXu0riXoT67wASVfY6dCnc5jHzGMrBxTXET44doVxg4Wxy4s2H/mfaHEiKlq2qvdwWqYjQpCCgJw+PmO9ORIN+sg2i0OUBLQarNZyqUCutszKtVbt58bQM2p9hpUcsrXydilEm/kEmHR4/QCTZxzKqJh+pl/UKZaIZB9YIbGlP9rRXB2SRLNsYtFjBKJ3CbfxM70vbnpyG19dLuxJa1tXSIWHqTSJx1Uot+QlBJZJeFnVjxxbrBEChnnggcS5qpZrmXI/cmyaV2e3IYpEuJplV6vZ3CMJRfpjYqQQh7lrVkK2zhT7522YYoP0FPWAxXgyE0nDcGNfH9/gnS7Xx0tGYDUx9le7woGAXuAW4JJpQCTN3d9LDKXyQwhhhCUcxp/PUuh1fpz71R1qitOxTNlMKPMAPeMihjjB1DPUdpWPH13xD5gkLYSVvyJR5/kSog0j5lneJdxensNu/609onh9A73xlz/hfv4XYUisDFePKwBV3cs0TsQ2jLTtS15mT4uo4tfSUloFgnK1wcTQl1Z056M/i3XGl4syKBs3d/M31oDPx8laGyF+Y7xs2bj5UiB5fqWt/5vibV5I+nbdZOLPEh2TB0VRuSelos1HnKJPD40c6Q7Tj03IONp8oiiWfxd5dsqjQGFCfSgsXMi31W+x6Ptv7Z0zhf4rlIKu7YG30HKpH+1/brY4ZEcuw2vObj1ZmwGlcZbHWkYc
 nEZ/bEF+
 r25OUMopTbb1B3fTHm+GPACStMyoxpUL3Hs2a3BXvJMG7i2HgOhfPy1ea6IOynkVYnKLJj0i1xOyso1tP7DJwnFy2jYL+oAwnimWCom9B45nHtu4XruDk1BxTP3UoAj4ApfnH4HkCSgAyYMbSjtq9MqvjAV+REBTsRDZejHbuAMuQvQwT60GefhdaQZ2h81NIM7UmmhuO4kEt7S7lWEMsqvXi1W7mOZ3pY6PauApvqji/brrZspm3YkaAX85ljO0+qZQoZI7ErIj3MBfv6BfC5MDN0iFoyO352CDMYsWbrX2VyWA2Vp+rb5FAN3JiRdDsJI3cqvv7L86JDv+6YimsUHADHmf/93CutSqIy1YQO15Nv/KaGiXQmFM2vBdGm3P/lZ/XbucRO0xFgqy6Pwexl+oCCH/SVgxHdYAZgJy+TnMBzqVbR/YhHiqsQaaS9TXDTkDvwodFBPKHneMEvmnnPPhDa/ybgybJagtOHEIl7qHCh1BZdaOJEspyuTuRJm5gzkgBdGWJPu/JzoT4obrDw0IhIC1DXsGEm6NgNiI3v7Je4fWuOX73uZFsmr7oNd/wj2YL956HJYYRKP6T5jcVvkILbHmpUWZwu5UK9ZcfrLG85R2yt91tQGl/DahYDg53SZZs6+uAy+VhdwLWvqPXPC1GvA/JV+jFWJAP3msyHUCmfAi2gkr3uSkS6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce type-aware kmalloc-family helpers to replace the common
idioms for single object and arrays of objects allocation:

	ptr = kmalloc(sizeof(*ptr), gfp);
	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
	ptr = kzalloc(sizeof(*ptr), gfp);
	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
	ptr = kcalloc(count, sizeof(*ptr), gfp);

These become, respectively:

	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kzalloc_obj(*ptr, gfp);
	ptr = kmalloc_objs(*ptr, count, gfp);
	ptr = kzalloc_objs(*ptr, count, gfp);

Beyond the other benefits outlined below, the primary ergonomic benefit
is the elimination of needing "sizeof" nor the type name, and the
enforcement of assignment types (they do not return "void *", but rather
a pointer to the type of the first argument). The type name _can_ be
used, though, in the case where an assignment is indirect (e.g. via
"return"). This additionally allows[1] variables to be declared via
__auto_type:

	__auto_type ptr = kmalloc_obj(struct foo, gfp);

Internal introspection of the allocated type now becomes possible,
allowing for future alignment-aware choices to be made by the allocator
and future hardening work that can be type sensitive. For example,
adding __alignof(*ptr) as an argument to the internal allocators so that
appropriate/efficient alignment choices can be made, or being able to
correctly choose per-allocation offset randomization within a bucket
that does not break alignment requirements.

Link: https://lore.kernel.org/all/CAHk-=wiCOTW5UftUrAnvJkr6769D29tF7Of79gUjdQHS_TkF5A@mail.gmail.com/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: linux-mm@kvack.org
---
 Documentation/process/deprecated.rst | 24 ++++++++++++
 include/linux/slab.h                 | 58 ++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 1f7f3e6c9cda..91c628fa2d59 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -372,3 +372,27 @@ The helper must be used::
 			DECLARE_FLEX_ARRAY(struct type2, two);
 		};
 	};
+
+Open-coded kmalloc assignments for struct objects
+-------------------------------------------------
+Performing open-coded kmalloc()-family allocation assignments prevents
+the kernel (and compiler) from being able to examine the type of the
+variable being assigned, which limits any related introspection that
+may help with alignment, wrap-around, or additional hardening. The
+kmalloc_obj()-family of macros provide this introspection, which can be
+used for the common code patterns for single, array, and flexible object
+allocations. For example, these open coded assignments::
+
+	ptr = kmalloc(sizeof(*ptr), gfp);
+	ptr = kzalloc(sizeof(*ptr), gfp);
+	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
+	ptr = kcalloc(count, sizeof(*ptr), gfp);
+	ptr = kmalloc(sizeof(struct foo, gfp);
+
+become, respectively::
+
+	ptr = kmalloc_obj(*ptr, gfp);
+	ptr = kzalloc_obj(*ptr, gfp);
+	ptr = kmalloc_objs(*ptr, count, gfp);
+	ptr = kzalloc_objs(*ptr, count, gfp);
+	__auto_type ptr = kmalloc_obj(struct foo, gfp);
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cf443f064a66..726457daedbd 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
+#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/gfp.h>
 #include <linux/overflow.h>
@@ -965,6 +966,63 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
 
+/**
+ * __alloc_objs - Allocate objects of a given type using
+ * @KMALLOC: which size-based kmalloc wrapper to allocate with.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type to allocate space for.
+ * @COUNT: how many @TYPE objects to allocate.
+ *
+ * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
+ * allocated @TYPE objects, or NULL on failure.
+ */
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+/**
+ * kmalloc_obj - Allocate a single instance of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate.
+ * @GFP: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
+ * on failure.
+ */
+#define kmalloc_obj(VAR_OR_TYPE, GFP)			\
+	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), 1)
+
+/**
+ * kmalloc_objs - Allocate an array of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @FLAGS: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
+ * or NULL on failure.
+ */
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
+	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
+
+/* All kzalloc aliases for kmalloc_(obj|objs|flex). */
+#define kzalloc_obj(P, GFP)				\
+	__alloc_objs(kzalloc, GFP, typeof(P), 1)
+#define kzalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
+
+/* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
+#define kvmalloc_obj(P, GFP)				\
+	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
+#define kvmalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
+
+/* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
+#define kvzalloc_obj(P, GFP)				\
+	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
+#define kvzalloc_objs(P, COUNT, GFP)			\
+	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
+
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
 
-- 
2.34.1


