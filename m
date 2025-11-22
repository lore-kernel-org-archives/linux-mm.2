Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901ECCFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D157D6B0012; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECB96B0023; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29D46B0026; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAFE86B0012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:43:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 612A24F228
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84136544856.07.53E8783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4D8712000D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bf1Lrxck;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xez0ILCDjGjovJMqblUCb7oWOEPPLTl9RQsRHOAq81E=;
	b=vS7H1c/i0ohvhoN4cuAROYlBetagd4ELgcuDeOLZrncwSsz59gxIHQaeKt7ZrHxizxNrbn
	5LPpd6oe55quui849OdJf/4qOSAo8H3aiDa8BG+JY2/DDaUxErjV7CmBJaCDlRGg/7PahV
	Cs95OqSU4qbWoU+Th/ZPUBxeOaYPYKo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bf1Lrxck;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775786; a=rsa-sha256;
	cv=none;
	b=1eZEpaOVz0MOcPgOtWkuNUBZAlaoP6LHeD3p4xIWJs9OVNqxSv3PEnfGnKBOyVxoERNLrr
	6018jBB0E1hkQ32OfKvMRfNDCGJpmtYLCqVl17yulepg8oh6FpaecMa4Ukvfdv3lM0UVrI
	ko6TJbkGfBn9e3k/1G36ycHarwA/2Dk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76DB341923;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A2DC4AF0B;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763775785;
	bh=FcVar3XxCqm2ZJVsBh/RSi2lBnjq1avyQFtaa1b+fYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf1LrxckvPXcFurZMJJlnfu5zjFswMMQGWAbumWk6UsfZ7OboCY4EhE7R+istWA1w
	 TwcO39KJQSeOW+SvaWN0fgn6tHYgCC/Aete+PJ6RXDDOcJTUpefAfZAJa613DUJMMl
	 ON4T9HItaqB1mnLwkCDphaEPucYYhzkV8wzII+OTARGClOijkyT/OgkqeZJ5ilwfOd
	 y3uX+NjjYr/IKCtAV+v4+RyvU+WanfP3OL5wDsWQwMSY26I7/NcuLZ0OMsvHyZ+8PU
	 rhSkmOk7hSp2azZSQKRQnxWn/im2hpmyJgHJ8rfeNa9uCqIRTn08JY7aWG/2MwDeyJ
	 +JpVQ5+s8vTng==
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
Subject: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Date: Fri, 21 Nov 2025 17:42:58 -0800
Message-Id: <20251122014304.3417954-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251122014258.do.018-kees@kernel.org>
References: <20251122014258.do.018-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17532; i=kees@kernel.org; h=from:subject; bh=FcVar3XxCqm2ZJVsBh/RSi2lBnjq1avyQFtaa1b+fYo=; b=owGbwMvMwCVmps19z/KJym7G02pJDJmKosq6MQ6SGdx72BP2qcurX1wkcPfhmZaMClUOLr9ak 89PIhd2lLIwiHExyIopsgTZuce5eLxtD3efqwgzh5UJZAgDF6cATOTnC0aG7VutnYSzSi1unp5p bv2z6+2Ovamt87Zd3b+47onLN/XLExkZNrT3Tp4cvsuyOU/bd/WshX7vQwLU2Sblb18afmK5jvJ WNgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4D8712000D
X-Stat-Signature: oz7ainfwhfeho3jy6kk7p37i4diq5uoe
X-Rspam-User: 
X-HE-Tag: 1763775786-344628
X-HE-Meta: U2FsdGVkX19s5ym7aHswAYq+vvWCS9TUrEZf5ncSXCxzqKxi1XWypAyQMgtB5ezMlqEJabp7fZYcT3WuDzFm8nQJHYLJklEqJ8AMx5gP1bkxhpBgbKXA0N72RMzBKpASahD6iSU7KUMBfaCceLSV5oY+Bk93JP4kebbRN6XiZVW023UAsc5QyLPLkMpLxULxNTiZJN8Ob7iwOzEr2ZZ7Tsh1euzR2FqKP+lkKqTiqjWyQGvEPVLwzgmX5D52dlze0EUWESeJcu/Vvl8IUJKjlTKe8CptfScdVSz8bSmVzsmBJMaNX7Tv3qAtHVtTxV9SIEamEbn3DahElflJyCFSHcAJyks4XkIyNEJmsv1rQU7nrwpKzpRf071mNRbkx6BnBO4vnDkanjxsVe+lyUBZg3vg9OJQXapbxtH12AdyVYP6LJHAMiwe2VxZIOr2WjaII6udyTvJ/XfNUTcsFUmO0rgSQIwBMDLHXxRjWsUIfTF5EnhxzmuB4IDhKsUZwwkLU2HyI9uOZnIzOQ7YIJpLbNbq+UH+EPTb5B6RtCXvgBeIXTLiujrToVhk0Aui4blSBAPFiDrlcGcXrHbsBfnf889PHomy0AswXfFItrekT8sBUvyOY6X++NXps/buWqga4TZ9Ck76QEOXoAzW7KPx8XEG+mkdA0HCdQu4fSiBXc6X5qF5eghCGwIIJq/D9jg6nYGSrTdSW4pe6G5JO3QdMG9ez1xa0pDMKJp+0lMmWyTLIPezYkK8ljw9ilZgvDs0hT4rsEHJhsFw4tm1cQl+2QXZhFJpUzaPOcEOx8TD8dT6ii6Az77DoQb3dDCMGZTMYQaOMvPnB3rPpriVCyfMxpP1PMvuuVF8rlVxcDcXtwvEhdnulDPOOlMgudF7tzsoBed1OWlndgQXlMPyD9Y6dBwqqiUH9eRZJw7LP/78fLqfCWGb6pSIY/muA8O/OD9goh2eHtcxV6GyO5UdTd0
 vZQ2jKyz
 loRfFDn0p79qYi8JfceX+4mbUAnT9+sW9eP9X0UTQBeMRqB+rAMQdzzOvzKITgXDKATp8rP2mngrTsRnzlMxZTOlFhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce type-aware kmalloc-family helpers to replace the common
idioms for single, array, and flexible object allocations:

	ptr = kmalloc(sizeof(*ptr), gfp);
	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
	ptr = kzalloc(sizeof(*ptr), gfp);
	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
	ptr = kcalloc(count, sizeof(*ptr), gfp);
	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);

These become, respectively:

	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kmalloc_obj(*ptr, gfp);
	ptr = kzalloc_obj(*ptr, gfp);
	ptr = kmalloc_objs(*ptr, count, gfp);
	ptr = kzalloc_objs(*ptr, count, gfp);
	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);

Beyond the other benefits outlined below, the primary ergonomic benefit
is the elimination of needing "sizeof" nor the type name, and the
enforcement of assignment types (they do not return "void *", but rather
a pointer to the type of the first argument). The type name _can_ be
used, though, in the case where an assignment is indirect (e.g. via
"return").

These each return the newly allocated pointer to the type (which may be
NULL on failure). For cases where the total size of the allocation is
needed, the kmalloc_obj_sz(), kmalloc_objs_sz(), and kmalloc_flex_sz()
family of macros can be used. For example:

	size = struct_size(ptr, flex_member, count);
	ptr = kmalloc(size, gfp);

becomes:

	ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &size);

With the *_sz() helpers, it becomes possible to do bounds checking of
the final size to make sure no arithmetic overflow has happened that
exceeds the storage size of the target size variable. E.g. it was possible
before to end up wrapping an allocation size and not noticing, there by
allocating too small a size. (Most of Linux's exposure on that particular
problem is via newly written code as we already did bulk conversions[1],
but we continue to have a steady stream of patches catching additional
cases[2] that would just go away with this API.)

Internal introspection of the allocated type now becomes possible,
allowing for future alignment-aware choices to be made by the allocator
and future hardening work that can be type sensitive. For example,
adding __alignof(*ptr) as an argument to the internal allocators so that
appropriate/efficient alignment choices can be made, or being able to
correctly choose per-allocation offset randomization within a bucket
that does not break alignment requirements.

For the flexible array helpers, the internal use of __flex_counter()
allows for automatically setting the counter member of a struct's flexible
array member when it has been annotated with __counted_by(), avoiding
any missed early size initializations while __counted_by() annotations
are added to the kernel. Additionally, this also checks for "too large"
allocations based on the type size of the counter variable. For example:

	if (count > type_max(ptr->flex_count))
		fail...;
	size = struct_size(ptr, flex_member, count);
	ptr = kmalloc(size, gfp);
	ptr->flex_count = count;

becomes (n.b. unchanged from earlier example):

	ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &size);
	ptr->flex_count = count;

Note that manual initialization of the flexible array counter is still
required (at some point) after allocation as not all compiler versions
support the __counted_by annotation yet. But doing it internally makes
sure they cannot be missed when __counted_by _is_ available, meaning
that the bounds checker will not trip due to the lack of "early enough"
initializations that used to work before enabling the stricter bounds
checking. For example:

	ptr = kmalloc_flex(*ptr, flex_member, count);
	fill(ptr->flex, count);
	ptr->flex_count = count;

This works correctly before adding a __counted_by annotation (since
nothing is checking ptr->flex accesses against ptr->flex_count). After
adding the annotation, the bounds sanitizer would trip during fill()
because ptr->flex_count wasn't set yet. But with kmalloc_flex() setting
ptr->flex_count internally at allocation time, the existing code works
without needing to move the ptr->flex_count assignment before the call
to fill(). (This has been a stumbling block for __counted_by adoption.)

Replacing all existing simple code patterns found via Coccinelle[3]
shows what could be replaced immediately (also saving roughly 1000 lines):

 7863 files changed, 19639 insertions(+), 20692 deletions(-)

This would take us from 24085 k*alloc assignments to 7467:

$ git grep ' = kv\?[mzcv]alloc\(\|_array\)(' | wc -l
24085
$ git reset --hard HEAD^
HEAD is now at 8bccc91e6cdf treewide: kmalloc_obj conversion
$ git grep ' = kv\?[mzcv]alloc\(\|_array\)(' | wc -l
7467

This treewide change could be done at the end of the merge window just
before -rc1 is released (as is common for treewide changes). Handling
this API change in backports to -stable should be possible without much
hassle by backporting the __flex_counter() patch and this patch, while
taking conversions as-needed.

The impact on my bootable testing image size (with the treewide patch
applied) is tiny. With both GCC 13 (no __counted_by support) and GCC 15
(with __counted_by) the images are actually very slightly smaller:

$ size -G gcc-boot/vmlinux.gcc*
      text       data        bss      total filename
  29975593   21527689   16601200   68104482 gcc-boot/vmlinux.gcc13-before
  29969263   21528663   16601112   68099038 gcc-boot/vmlinux.gcc13-after
  30555626   21291299   17086620   68933545 gcc-boot/vmlinux.gcc15-before
  30550144   21292039   17086540   68928723 gcc-boot/vmlinux.gcc15-after

Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b08fc5277aaa1d8ea15470d38bf36f19dfb0e125 [1]
Link: https://lore.kernel.org/all/?q=s%3Akcalloc+-s%3ARe%3A [2]
Link: https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/kmalloc_objs.cocci [3]
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
 Documentation/process/deprecated.rst |  42 +++++++
 include/linux/slab.h                 | 172 +++++++++++++++++++++++++++
 2 files changed, 214 insertions(+)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 1f7f3e6c9cda..eb72b75f5419 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -372,3 +372,45 @@ The helper must be used::
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
+	ptr = kmalloc(sizeof(struct the_type_of_ptr_obj), gfp);
+	ptr = kzalloc(sizeof(*ptr), gfp);
+	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
+	ptr = kcalloc(count, sizeof(*ptr), gfp);
+	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
+
+become, respectively::
+
+	ptr = kmalloc_obj(*ptr, gfp);
+	ptr = kzalloc_obj(*ptr, gfp);
+	ptr = kmalloc_objs(*ptr, count, gfp);
+	ptr = kzalloc_objs(*ptr, count, gfp);
+	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
+
+For the cases where the total size of the allocation is also needed,
+the kmalloc_obj_sz(), kmalloc_objs_sz(), and kmalloc_flex_sz() family of
+macros can be used. For example, converting these assignments::
+
+	total_size = struct_size(ptr, flex_member, count);
+	ptr = kmalloc(total_size, gfp);
+
+becomes::
+
+	ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &total_size);
+
+If `ptr->flex_member` is annotated with __counted_by(), the allocation
+will automatically fail if `count` is larger than the maximum
+representable value that can be stored in the counter member associated
+with `flex_member`. Similarly, the allocation will fail if the total
+size of the allocation exceeds the maximum value `*total_size` can hold.
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cf443f064a66..1c5219d79cf1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
+#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/gfp.h>
 #include <linux/overflow.h>
@@ -965,6 +966,177 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
 
+#define __alloc_objs(ALLOC, VAR, COUNT, SIZE)				\
+({									\
+	size_t __obj_size = size_mul(sizeof(VAR), COUNT);		\
+	const typeof(_Generic(SIZE,					\
+			void *: (size_t *)NULL,				\
+			default: SIZE)) __size_ptr = (SIZE);		\
+	typeof(VAR) *__obj_ptr = NULL;					\
+	/* Does the total size fit in the *SIZE variable? */		\
+	if (!WARN_ON_ONCE(__size_ptr && __obj_size > type_max(*__size_ptr))) \
+		__obj_ptr = ALLOC;					\
+	if (!__obj_ptr)							\
+		__obj_size = 0;						\
+	if (__size_ptr)							\
+		*__size_ptr = __obj_size;				\
+	__obj_ptr;							\
+})
+
+#define __alloc_flex(ALLOC, VAR, FAM, COUNT, SIZE)			\
+({									\
+	const size_t __count = (COUNT);					\
+	size_t __obj_size = struct_size_t(typeof(VAR), FAM, __count);	\
+	/* "*SIZE = ...;" below is unbuildable when SIZE is "NULL" */	\
+	const typeof(_Generic(SIZE,					\
+			void *: (size_t *)NULL,				\
+			default: SIZE)) __size_ptr = (SIZE);		\
+	typeof(VAR) *__obj_ptr = NULL;					\
+	if (!WARN_ON_ONCE(!__can_set_flex_counter(__obj_ptr->FAM, __count)) && \
+	    !WARN_ON_ONCE(__size_ptr && __obj_size > type_max(*__size_ptr))) \
+		__obj_ptr = ALLOC;					\
+	if (__obj_ptr) {						\
+		__set_flex_counter(__obj_ptr->FAM, __count);		\
+	} else {							\
+		__obj_size = 0;						\
+	}								\
+	if (__size_ptr)							\
+		*__size_ptr = __obj_size;				\
+	__obj_ptr;							\
+})
+
+/**
+ * kmalloc_obj - Allocate a single instance of the given structure
+ * @VAR: Variable or type to allocate.
+ * @FLAGS: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to a @VAR on success, NULL on failure.
+ */
+#define kmalloc_obj(VAR, FLAGS)				\
+	__alloc_objs(kmalloc(__obj_size, FLAGS), VAR, 1, NULL)
+
+/**
+ * kmalloc_obj_sz - Allocate a single instance of the given structure and
+ *		 store total size
+ * @VAR: Variable or type to allocate.
+ * @FLAGS: GFP flags for the allocation.
+ * @SIZE: Pointer to variable to hold the total allocation size.
+ *
+ * Returns: newly allocated pointer to @VAR on success, NULL on failure.
+ * If @SIZE is non-NULL, the allocation will immediately fail if the total
+ * allocation size is larger than what the type of *@SIZE can represent.
+ * If @SIZE is non-NULL, *@SIZE is set to either allocation size on success,
+ * or 0 on failure.
+ */
+#define kmalloc_obj_sz(VAR, FLAGS, SIZE)		\
+	__alloc_objs(kmalloc(__obj_size, FLAGS), VAR, 1, SIZE)
+
+/**
+ * kmalloc_objs - Allocate an array of the given structure
+ * @VAR: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @FLAGS: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to array of @VAR on success, NULL on
+ * failure.
+ */
+#define kmalloc_objs(VAR, COUNT, FLAGS)			\
+	__alloc_objs(kmalloc(__obj_size, FLAGS), VAR, COUNT, NULL)
+
+/**
+ * kmalloc_objs_sz - Allocate an array of the given structure and store
+ *		     total size
+ * @VAR: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @FLAGS: GFP flags for the allocation.
+ * @SIZE: Pointer to variable to hold the total allocation size.
+ *
+ * Returns: newly allocated pointer to array of @VAR on success, NULL on
+ * failure. If @SIZE is non-NULL, the allocation will immediately fail if
+ * the total allocation size is larger than what the type of *@SIZE can
+ * represent. If @SIZE is non-NULL, *@SIZE is set to either allocation size
+ * on success, or 0 on failure.
+ */
+#define kmalloc_objs_sz(VAR, COUNT, FLAGS, SIZE)	\
+	__alloc_objs(kmalloc(__obj_size, FLAGS), VAR, COUNT, SIZE)
+
+/**
+ * kmalloc_flex - Allocate a single instance of the given flexible structure
+ * @VAR: Variable or type to allocate, along with its flexible array member.
+ * @FAM: The name of the flexible array member of the structure.
+ * @COUNT: How many flexible array member elements are desired.
+ * @FLAGS: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to @VAR on success, NULL on failure.
+ * If @FAM has been annotated with __counted_by(), the allocation will
+ * immediately fail if @COUNT is larger than what the type of the struct's
+ * counter variable can represent.
+ */
+#define kmalloc_flex(VAR, FAM, COUNT, FLAGS)		\
+	__alloc_flex(kmalloc(__obj_size, FLAGS), VAR, FAM, COUNT, NULL)
+
+/**
+ * kmalloc_flex_sz - Allocate a single instance of the given flexible
+ *		     structure and store total size
+ * @VAR: Variable or type to allocate, along with its flexible array member.
+ * @FAM: The name of the flexible array member of the structure.
+ * @COUNT: How many flexible array member elements are desired.
+ * @FLAGS: GFP flags for the allocation.
+ * @SIZE: Pointer to variable to hold the total allocation size.
+ *
+ * Returns: newly allocated pointer to @VAR on success, NULL on failure.
+ * If @FAM has been annotated with __counted_by(), the allocation will
+ * immediately fail if @COUNT is larger than what the type of the struct's
+ * counter variable can represent. If @SIZE is non-NULL, the allocation
+ * will immediately fail if the total allocation size is larger than what
+ * the type of *@SIZE can represent. If @SIZE is non-NULL, *@SIZE is set
+ * to either allocation size on success, or 0 on failure.
+ */
+#define kmalloc_flex_sz(VAR, FAM, COUNT, FLAGS, SIZE)	\
+	__alloc_flex(kmalloc(__obj_size, FLAGS), VAR, FAM, COUNT, SIZE)
+
+/* All kzalloc aliases for kmalloc_(obj|objs|fam)(|_sz). */
+#define kzalloc_obj(P, FLAGS)				\
+	__alloc_objs(kzalloc(__obj_size, FLAGS), P, 1, NULL)
+#define kzalloc_obj_sz(P, FLAGS, SIZE)			\
+	__alloc_objs(kzalloc(__obj_size, FLAGS), P, 1, SIZE)
+#define kzalloc_objs(P, COUNT, FLAGS)			\
+	__alloc_objs(kzalloc(__obj_size, FLAGS), P, COUNT, NULL)
+#define kzalloc_objs_sz(P, COUNT, FLAGS, SIZE)		\
+	__alloc_objs(kzalloc(__obj_size, FLAGS), P, COUNT, SIZE)
+#define kzalloc_flex(P, FAM, COUNT, FLAGS)		\
+	__alloc_flex(kzalloc(__obj_size, FLAGS), P, FAM, COUNT, NULL)
+#define kzalloc_flex_sz(P, FAM, COUNT, FLAGS, SIZE)	\
+	__alloc_flex(kzalloc(__obj_size, FLAGS), P, FAM, COUNT, SIZE)
+
+/* All kvmalloc aliases for kmalloc_(obj|objs|fam)(|_sz). */
+#define kvmalloc_obj(P, FLAGS)				\
+	__alloc_objs(kvmalloc(__obj_size, FLAGS), P, 1, NULL)
+#define kvmalloc_obj_sz(P, FLAGS, SIZE)			\
+	__alloc_objs(kvmalloc(__obj_size, FLAGS), P, 1, SIZE)
+#define kvmalloc_objs(P, COUNT, FLAGS)			\
+	__alloc_objs(kvmalloc(__obj_size, FLAGS), P, COUNT, NULL)
+#define kvmalloc_objs_sz(P, COUNT, FLAGS, SIZE)		\
+	__alloc_objs(kvmalloc(__obj_size, FLAGS), P, COUNT, SIZE)
+#define kvmalloc_flex(P, FAM, COUNT, FLAGS)		\
+	__alloc_flex(kvmalloc(__obj_size, FLAGS), P, FAM, COUNT, NULL)
+#define kvmalloc_flex_sz(P, FAM, COUNT, FLAGS, SIZE)	\
+	__alloc_flex(kvmalloc(__obj_size, FLAGS), P, FAM, COUNT, SIZE)
+
+/* All kvzalloc aliases for kmalloc_(obj|objs|fam)(|_sz). */
+#define kvzalloc_obj(P, FLAGS)				\
+	__alloc_objs(kvzalloc(__obj_size, FLAGS), P, 1, NULL)
+#define kvzalloc_obj_sz(P, FLAGS, SIZE)			\
+	__alloc_objs(kvzalloc(__obj_size, FLAGS), P, 1, SIZE)
+#define kvzalloc_objs(P, COUNT, FLAGS)			\
+	__alloc_objs(kvzalloc(__obj_size, FLAGS), P, COUNT, NULL)
+#define kvzalloc_objs_sz(P, COUNT, FLAGS, SIZE)		\
+	__alloc_objs(kvzalloc(__obj_size, FLAGS), P, COUNT, SIZE)
+#define kvzalloc_flex(P, FAM, COUNT, FLAGS)		\
+	__alloc_flex(kvzalloc(__obj_size, FLAGS), P, FAM, COUNT, NULL)
+#define kvzalloc_flex_sz(P, FAM, COUNT, FLAGS, SIZE)	\
+	__alloc_flex(kvzalloc(__obj_size, FLAGS), P, FAM, COUNT, SIZE)
+
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
 
-- 
2.34.1


