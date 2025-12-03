Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D84D1CDAA
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102876B0062; Wed,  3 Dec 2025 18:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041226B008A; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA626B007B; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 945D26B007B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B95251EC1
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
X-FDA: 84179756640.21.099D110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3470120002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdDp1s8C;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p191RT8y5rYSNGCgveWZG1TfKKeOW3wKH8Js/IyTGI4=;
	b=f9VfSIJ0ZoGpdlLwTNkpLLIvzW72pCpZT2UQyBAarvPfxUueLPDnYuz71rluePzRpy1yZq
	iyIw6qEFCx4KNynKjy3Osyt8RJWZHqeIHN2xAd91EApbW7SXdTdjVcb08yw/hWD08I6JMy
	McehbPyDTzsa3qmIq7V3XIGtXTZGUdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804639; a=rsa-sha256;
	cv=none;
	b=BoScwU9wLfVHDKaPNRizN2GtwfcPe7aLfUUI2tSKKXQN3niPUGvq/+GpEwDr7YpMUHgm/H
	D5STj2UjGdtQNAkX3cmAbGWUgm6nvv+hF+r+AvVBtguI3O4bTqrTcdmxO6CWMStDlJMwX7
	YiIywvg2PoCXRDjkpsjG6zar+3Swku0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdDp1s8C;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9242A443FF;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DBEC2BCB2;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=/3oEfKp5bU/+SWlxMLCCWi/qv6HDY8MmV0RMn5cIJmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdDp1s8CleK4hn41r/2RClG5pRP24c3+GUC2GorVnlaRiJkA+OO5i3A0z+CAyKZ0Q
	 dG0gZzAzwJFADJPJ53r65BfarPkFk1HJq9+WX8GHmuhrmPtZZ70HSbAKWlCrWqd+tK
	 A8eJdl9ouGG1RD2Plye9Fj4BbMJNDMFIWDJ+U/vyWcG0RErdZ1/uj6bfAoEQ+uzVHZ
	 qv3xUYM8tlNoRM7f3sZ29ueuvPbH+lxrzBPFV9RsRea/n/9+V3EYFbOWRz1Wk0jyRL
	 A52Og2BDbN7t/zU1B4M8VCbaxeTVh7D5TtyXtNScg0JKvYKGhHi5Y3d+OMF/D4lgeO
	 5hUSu6sPYr1GA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>,
	Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Date: Wed,  3 Dec 2025 15:30:34 -0800
Message-Id: <20251203233036.3212363-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7374; i=kees@kernel.org; h=from:subject; bh=/3oEfKp5bU/+SWlxMLCCWi/qv6HDY8MmV0RMn5cIJmw=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJ6TKdwfPPHTuSsniQ00Mj6pWurkzsn85a/0uzETQn uPgkx1hHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABOJU2Jk+KHcPLc3LHhHPr+l vjW/yYcIiz9m39hdXxyZNddfTuV9NCPD0vlfvwUqCsoHBT15EVrWv8Lyz9ulQnNSdlxrfZh8qdG IHQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3470120002
X-Stat-Signature: cpihzjw6z8cu8fm6cxbrqqu1w9z3tdq5
X-Rspam-User: 
X-HE-Tag: 1764804638-850144
X-HE-Meta: U2FsdGVkX19WtDwGhuNFunY4+d8tZLNRSyd/E/zogAYMglhueoxtk4qFqGVb/qeWNmNztifMDQxlqv2kV5GcN9/Pg0XK2MqRU5omot1O/LJRE6nakutL+4vgc+plzBWgmHUKYo9S377KpJsbDJXNHiUsq8Ubxx4yi9aI2UheYpSYGREWmkeTT7Uc0cqMipux3btbOXECboLrtwviHSdBh8hjWVHGtzqV11ugl1K7d+7/XnffSPHxgyVWxF1Wg0kARBDogdxyXZjGAvlEz84xnYGXL1Eo/20STREMjsSfnXfhv4xy9zPn1uiZiaF/i6EWxl2F9QUZHZrXwiKWhY3fU11ofKXgDqxYullY8PN4YO1M5wrZCW2k779ZjoAv42wMCH8Ir9x515RJRYGQtIx9neRL/Vfbvg2DOq+bSsznw8Ar37DFVQ5+rZ+TQoaKT0ffzve9qp4qjZwTqbpj7Jxb9wiWz6NL8xOBwUKuMi1BUZb3X50e3cpEiamgSmp8JqI1OKqJCWDJiYxSHqJhssO9p27oiu3bWUaL0vKgs+KWlNiKhA7rhyJhU4jhkR44tMd8k1kcPa5oF0mJZ+opoqVUAOt4fH0RFCdq5/VSB1k1kGHli7QgKoQ+gwvjgJZ3Dgh2pZPEQtEYbwjl6XghBhRl3o47Nd09qGfzKe0beYIMJJaSJQBuWZ5iGSGokww0UeAEsDcSZ5rx9/bXKvzgAdfXyRC4q+fQF6JzTn371U7sI4gZRiZKrWaPn+08BlKl3aOXQA7RJIePR3cGWQWEMyO5hQtIpp7NydKdlWk8mzuqu9ZX5ULKhz13/3h43wP4t0cJfOzFvkkIIw0TCkiRXlWLkWfbGUxYv14Kb/HR0hurMU1nTXmvInt5gbjKQREhfH+HyEGecrajVdH5TWNFsRcyWNeAXHY8SJ18F8gS7yCfBB6b0iiqN0bxoH7at4NwSKMcnomd239daxMSC2RjgTB
 8m6qkTzb
 RD2JTi7J9ukYR2OuSUCsKbRlF6Wl09Nnl5I/YxVaL2t8+MrjPgqYISTbe4Ro/PoDyn6fGfb5omJXYMLCJ9SP2s0TuPXH1CukHpBbvr5DJby1chkblaw8ecCf413UzGmlR2W4Xn6QJ+xymoZGE8yvcm26VpWZ1vVojy2VbKqn4vo3QTCC84Up/XYcdTw3qkXjBPz94L+dnfpcqGIuZWgqBYfzbSMvX68iuGgNzW4BE3iU6zWGylvQLhevyW6G6p96xNJEYaX8FK4TopoYDo44ClWmP/b7f8zce79IIeNQ5CeQVXQu6cAn/DbVGelWOVhMi/msn3lyxJJ8AKhDpa+YJf2DApDedhtGAQLpynoTyTMYSB48Yq6onSoHK0clMIQV9a6IV/igD8uLeNLTx5NYJqPFYZVonjPnVRI04AtV3potGgXArGdjM9eeggkxFuwDJcAYLV8PfrZxXZulkmnkVVd+O08AaFq9Q1eMmtWXRkcVc6f/irYTqcLJi3qVNxmFGmN7AfjM0XfUA6PIokOJKlIxHHA2PZb3OWerjyLYXSk0lxMpcr0cyMvopksHGMD5UQ3+G2s8LIXUTquTqu8B0DTuWbny2DR7IM+jnlatPYa/rtE0CZeNYXjdmK5yj90u9/5jVYR2uguZfSA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
arrays, which may also have "counted_by" annotations:

	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);

becomes:

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);

The internal use of __flex_counter() allows for automatically setting
the counter member of a struct's flexible array member when it has
been annotated with __counted_by(), avoiding any missed early size
initializations while __counted_by() annotations are added to the
kernel. Additionally, this also checks for "too large" allocations based
on the type size of the counter variable. For example:

	if (count > type_max(ptr->flex_counter))
		fail...;
	size = struct_size(ptr, flex_member, count);
	ptr = kmalloc(size, gfp);
	ptr->flex_counter = count;

becomes (n.b. unchanged from earlier example):

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
	ptr->flex_count = count;

Note that manual initialization of the flexible array counter is still
required (at some point) after allocation as not all compiler versions
support the __counted_by annotation yet. But doing it internally makes
sure they cannot be missed when __counted_by _is_ available, meaning
that the bounds checker will not trip due to the lack of "early enough"
initializations that used to work before enabling the stricter bounds
checking. For example:

	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
	fill(ptr->flex, count);
	ptr->flex_count = count;

This works correctly before adding a __counted_by annotation (since
nothing is checking ptr->flex accesses against ptr->flex_count). After
adding the annotation, the bounds sanitizer would trip during fill()
because ptr->flex_count wasn't set yet. But with kmalloc_flex() setting
ptr->flex_count internally at allocation time, the existing code works
without needing to move the ptr->flex_count assignment before the call
to fill(). (This has been a stumbling block for __counted_by adoption.)

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: <workflows@vger.kernel.org>
Cc: <linux-doc@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-hardening@vger.kernel.org>
---
 Documentation/process/deprecated.rst |  7 ++++
 include/linux/slab.h                 | 48 ++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 91c628fa2d59..fed56864d036 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -387,6 +387,7 @@ allocations. For example, these open coded assignments::
 	ptr = kzalloc(sizeof(*ptr), gfp);
 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
 	ptr = kcalloc(count, sizeof(*ptr), gfp);
+	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
 	ptr = kmalloc(sizeof(struct foo, gfp);
 
 become, respectively::
@@ -395,4 +396,10 @@ become, respectively::
 	ptr = kzalloc_obj(*ptr, gfp);
 	ptr = kmalloc_objs(*ptr, count, gfp);
 	ptr = kzalloc_objs(*ptr, count, gfp);
+	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
 	__auto_type ptr = kmalloc_obj(struct foo, gfp);
+
+If `ptr->flex_member` is annotated with __counted_by(), the allocation
+will automatically fail if `count` is larger than the maximum
+representable value that can be stored in the counter member associated
+with `flex_member`.
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 726457daedbd..2656ea610b68 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -982,6 +982,33 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 	(TYPE *)KMALLOC(__obj_size, GFP);				\
 })
 
+/**
+ * __alloc_flex - Allocate an object that has a trailing flexible array
+ * @KMALLOC: kmalloc wrapper function to use for allocation.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type of structure to allocate space for.
+ * @FAM: The name of the flexible array member of @TYPE structure.
+ * @COUNT: how many @FAM elements to allocate space for.
+ *
+ * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
+ * @FAM elements, or NULL on failure or if @COUNT cannot be represented
+ * by the member of @TYPE that counts the @FAM elements (annotated via
+ * __counted_by()).
+ */
+#define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
+({									\
+	const size_t __count = (COUNT);					\
+	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
+	TYPE *__obj_ptr;						\
+	if (WARN_ON_ONCE(overflows_flex_counter_type(TYPE, FAM,	__count))) \
+		__obj_ptr = NULL;					\
+	else								\
+		__obj_ptr = KMALLOC(__obj_size, GFP);			\
+	if (__obj_ptr)							\
+		__set_flex_counter(__obj_ptr->FAM, __count);		\
+	__obj_ptr;							\
+})
+
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
@@ -1005,23 +1032,44 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 #define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
 	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
 
+/**
+ * kmalloc_flex - Allocate a single instance of the given flexible structure
+ * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
+ * @FAM: The name of the flexible array member of the structure.
+ * @COUNT: How many flexible array member elements are desired.
+ * @GFP: GFP flags for the allocation.
+ *
+ * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
+ * failure. If @FAM has been annotated with __counted_by(), the allocation
+ * will immediately fail if @COUNT is larger than what the type of the
+ * struct's counter variable can represent.
+ */
+#define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, GFP)	\
+	__alloc_flex(kmalloc, GFP, typeof(VAR_OR_TYPE),	FAM, COUNT)
+
 /* All kzalloc aliases for kmalloc_(obj|objs|flex). */
 #define kzalloc_obj(P, GFP)				\
 	__alloc_objs(kzalloc, GFP, typeof(P), 1)
 #define kzalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
+#define kzalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kzalloc, GFP, typeof(P), FAM, COUNT)
 
 /* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
 #define kvmalloc_obj(P, GFP)				\
 	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
 #define kvmalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
+#define kvmalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kvmalloc, GFP, typeof(P), FAM, COUNT)
 
 /* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
 #define kvzalloc_obj(P, GFP)				\
 	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
 #define kvzalloc_objs(P, COUNT, GFP)			\
 	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
+#define kvzalloc_flex(P, FAM, COUNT, GFP)		\
+	__alloc_flex(kvzalloc, GFP, typeof(P), FAM, COUNT)
 
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
-- 
2.34.1


