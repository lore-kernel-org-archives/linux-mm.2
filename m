Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27964C5DF7E
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB09F6B02D2; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87DB6B0180; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50A86B02D5; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9AB6B0180
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 141101A07E8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
X-FDA: 85111430628.08.98BCAFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2983140002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q620JxrM;
	spf=pass (imf23.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987352;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCcY37nteAChu9TICNIRlPWx0WLFkpORLkkk3F3M+nQ=;
	b=KPbGNay1TOk9YKCSk049n9tyRWr37jPZvNU4aOxzSCf8DHYc+7MLZuC5b3bjlVxfHhKfKJ
	JofdrLxROiJsEnpJFDWz8EzDdOc7WjKaZGVyFV07F1nmwu85Np3XbLCDBMVela+rXyt+OH
	U9pFKQUkWzHC3iX3gJJvvyhZUEaxIMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987352;
	b=4PGmgFz50Yn9NetVyi0awrgq+77C5n1CR3Crd7aIy3WzhcSTGJM/P0p95xuU2+lGRn/DjK
	Z5RyHXzmRFR1y9xGgyz9CXPS8FUiqwQA1iEDcAgHIivG92AEps2elLRqYHrQY4/fdLQEiA
	WCvoZiGubX71sMgn1bvlBlR1Nf+E3RA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q620JxrM;
	spf=pass (imf23.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D502A43F86;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F8ABC2BCB3;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987350;
	bh=m3qa2xQ4xwcvD1fDZXUiS94fWshTWD6ejTy6CIxuQKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Q620JxrMoGuxLjCxQAp/aFmvBYliiIkH7Cpv+wAoj+8mOBy3iNnxrxBn8+CUVl3lC
	 3is3g5auRwISwzCaGwps0P1pfe8BqokjrMcuy9hiIv3m66NP0/nRKpvaucdPIwNmXe
	 Dly5K8rcG5QAFOOGpuT3kD4+S+Z4lJHMeRDS0E/i+IAC+fjhGhNCL47OsIy45b9pW5
	 kB79+I56AhV9A7cxiacC+iT/PHyOYpdMTQn4IBb3hGojY8z1u8moCYrgeXqFpLlOyr
	 rVItVt0u/zcOAw2ck832dZWfbKiG53erFAsd/zM5Th1iMpxLyQFe7NE3vmWfsH3228
	 241pJLvNQGZSA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5B3C5DF70;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:15 -0600
Subject: [PATCH 1/9] lib/folio_pool: Introduce Direct-Map Large Folio Pool
 & Scratchpad bump allocators
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-1-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=19494;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=nrrM8TV2HmVRyLmhBBM4gC5vfTcsUgcNCixNwcQaO+w=;
 b=AgzP8IN34onsbqWhmtQA2F0lltpEwSQlOSrcCbqyzeydq0czxs/3FPE/BhCrLXWVY4KWiqtBG
 O6nW6+TWQFTC322uezL1+CSbWHXMWxWr6oUILuiHHF0eRN4IlPW+kx5
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspam-User: 
X-Stat-Signature: sq9j3jisw9djwb1ad9tjtffbcuudfaw5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F2983140002
X-HE-Tag: 1786987351-991673
X-HE-Meta: U2FsdGVkX1/zd7rBc9GgPetlyVtAaeGIqBj47sJoSrxHgYP3va8T4XSDtvOrq4nLAj8PGFMb7Tlr3cp9fEjJuDaimQiVgcqEDyF4J68cJ2PiZ7HNPK+kh8sHzNPmDd+DZfDXEXsEWkuGqLOIjQZUbEGTqFmAUDukCn7OgXwVai6Rc3RxuACb/3VebpsN9FB6Zf3tX4RpdB1/2EpNPea/S3JGtqdyENx3JpiRhDsX1no3RaD95jd+NVBWXC9jE5Re7DOCWjK+Wc/y1wkMEE12GH7DHd2fCQstXhNrwEula35f2SyWQ8GHZkG813CGx3r9Tpw5A5UlbFfAYUSNonUUBgafIWvdUNJU6WT3aroGeJ9EMFPmTrOA90HY5BULUFpb8/kpnk5U3Qtyhmil5s6HuI2J8iBmTBpn9PyG6ljtyco9Qa7H9rPD09cxlGAsBoNjUA5gRWORNrpaqxL9MESGqEp/YD/nzUsisR/Vr1WNdVpxDvDRyGxMd26BvvqOR/nFhYFba6ce+O8anO5jTJDoUNfXVjofWoLCN9VbzUyesUikmWWoTHhlgJJ1GYgH5TEMMwbLn6njQThcr6Btt+ql9qlT01zTAcwpPDFsiiRg37EsR3t9qbNo7jkl9wsvHJL0+P3YbQ8dPMYLYiAwgZ81J+XdP/PEH2bLUc+8xcGg5wGDwApZQleAos03dEWbsgbVveiS/nuvdWQSt4YYAAKxSlOdprOeBUhKKxYST69SjpnQsZUD2ElMZoT1nmEDwcW7ph7MAUmPr1cQq6VnaY5+j9i65ixNZjEP9Mw5kAXuYOebizjp6EkNqvv7lbKpY/WEJzfkSf1gKqeJQAyLGX143VhLoTeOaet9PEOQmiABrPh+IvYWpqzPyQ4ZFoUPQBvIZlsdDrDL3B2Cr8uuFY2uCEapH61Hlx8TxVLbur5Dit+/sjUCae6ncZzANYDmmT8zhPBq4WQzq68wGRK+Pc9
 OjR2UCyq
 /bgvj8Gyduv4p2bs67fE+HoSCHneIVcqx/AQO1zRrwI6h3i0F1vjdtFyyFIBmVMNy5Q/RM1IcDn7Y4oWDXqmtzbHNAJnUlJKm5JTc6aCGwVjk3Cbbq0NViyfiXzz+QeWA3lGdGd7OHYSGf+duPqypaV6r22u4YPFqbY/pEYG6X5Z33SLIbGKAaFy9hWs1vDOOLiZBI4yDFXj/XNoYErZoFyeWo89vSta4bqu7I1TFVsiG3HnpnCTxQYVka9Q2Fj40hrb0vdWe6/byjDiQHV/d7JUtNVTSQtybfobphgrr1jhPL2xePZm0q6kkWs/Y25sQeUY9gTEznL0r0qVSzObwqnIec1Ym3QuX0WuWsLsc3hIld00/BAgDADGmMnv9oPvH0RfKKjxnsh7u3JB8YKa9O5ZA2tH44JXY/KFz48vtjRTJ41d30v7mSm3E/fFP8zZfcLEPsWXZs2vcs4XLJsnBR8iRXSMl9yqJX1S+EFj5n+UqLRncLPI0JUXaY7jJsVsXYviQc+QpdzCyYfpLqmuBbSD6cETpwAV9BWsk6eysMHUfpWJ94XdmRWq/wOLVmAtIc+orwKODEwAvUiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Introduce region-based linear bump allocators backed by Direct-Map Large
Folios (order-N compound pages via folio_alloc()), bringing O(1) bulk
teardown and SLUB bypass to batch-oriented kernel subsystems.

The implementation provides one core engine and one thin wrapper:

  - struct folio_scratchpad: Core variable-sized bump allocator. Accepts
    arbitrary size and alignment per allocation (alloc_bytes / alloc_obj).
    Used for Netlink batches, Netfilter transactions, and BPF syscalls.

  - struct folio_pool: Thin wrapper around folio_scratchpad that binds a
    fixed element size and alignment at init time (alloc / alloc_type).
    Used for homogeneous objects like Lockdep dependency edges and BPF
    verifier frames.

Subsystem Autonomy & Runtime Static-Key Control:
Both allocators support fine-grained, per-subsystem policy control via
DEFINE_FOLIO_POOL_STATIC_KEY_PARAM() alongside a global master switch
(folio_pool.enabled):

  - Independent Maintainer Policy: Subsystem maintainers choose their
    own default enablement policy (DECLARE_STATIC_KEY_TRUE or FALSE)
    and expose dedicated module/boot parameters (e.g. lockdep.folio_pool,
    nf_tables.trans_scratchpad, drm_gpuvm.scratchpad) to control adoption
    and rollout independently without cross-subsystem coupling.

  - Granular In-Situ Triage & A/B Benchmarking: Allows toggling between
    folio bump allocation and baseline SLUB at runtime on the same
    booted kernel, isolating regressions and capturing precise ftrace
    and PMU instruction deltas without rebooting.

  - Zero Instruction Overhead: Evaluated via static_branch_likely()
    to compile to direct fallthrough execution with static NOP patching.

Mark folio_scratchpad_alloc and folio_scratchpad_free noinline to enable
precise ftrace and hardware performance counter instrumentation.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/folio_pool.h | 279 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile               |   2 +-
 lib/folio_pool.c           | 230 +++++++++++++++++++++++++++++++++++++
 3 files changed, 510 insertions(+), 1 deletion(-)

diff --git a/include/linux/folio_pool.h b/include/linux/folio_pool.h
new file mode 100644
index 000000000000..5bbca8818877
--- /dev/null
+++ b/include/linux/folio_pool.h
@@ -0,0 +1,279 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _LINUX_FOLIO_POOL_H
+#define _LINUX_FOLIO_POOL_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/page-flags.h>
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <linux/jump_label.h>
+#include <linux/moduleparam.h>
+#include <linux/cleanup.h>
+
+DECLARE_STATIC_KEY_TRUE(folio_pool_enabled_key);
+
+#define DEFINE_FOLIO_POOL_STATIC_KEY_PARAM(key_name, param_name, desc)		\
+	DEFINE_STATIC_KEY_TRUE(key_name);					\
+	static int key_name##_set(const char *val, const struct kernel_param *kp) \
+	{									\
+		bool enable;							\
+		int ret = kstrtobool(val, &enable);				\
+		if (ret)							\
+			return ret;						\
+		if (enable)							\
+			static_branch_enable(&key_name);			\
+		else								\
+			static_branch_disable(&key_name);			\
+		return 0;							\
+	}									\
+	static int key_name##_get(char *buffer, const struct kernel_param *kp)	\
+	{									\
+		return sprintf(buffer, "%c\n",					\
+			       static_branch_likely(&key_name) ? 'Y' : 'N');	\
+	}									\
+	static const struct kernel_param_ops key_name##_ops = {			\
+		.set = key_name##_set,						\
+		.get = key_name##_get,						\
+	};									\
+	module_param_cb(param_name, &key_name##_ops, NULL, 0644);		\
+	MODULE_PARM_DESC(param_name, desc)
+
+#define DEFINE_FOLIO_POOL_STATIC_KEY_PARAM_FALSE(key_name, param_name, desc)	\
+	DEFINE_STATIC_KEY_FALSE(key_name);					\
+	static int key_name##_set(const char *val, const struct kernel_param *kp) \
+	{									\
+		bool enable;							\
+		int ret = kstrtobool(val, &enable);				\
+		if (ret)							\
+			return ret;						\
+		if (enable)							\
+			static_branch_enable(&key_name);			\
+		else								\
+			static_branch_disable(&key_name);			\
+		return 0;							\
+	}									\
+	static int key_name##_get(char *buffer, const struct kernel_param *kp)	\
+	{									\
+		return sprintf(buffer, "%c\n",					\
+			       static_branch_unlikely(&key_name) ? 'Y' : 'N');	\
+	}									\
+	static const struct kernel_param_ops key_name##_ops = {			\
+		.set = key_name##_set,						\
+		.get = key_name##_get,						\
+	};									\
+	module_param_cb(param_name, &key_name##_ops, NULL, 0644);		\
+	MODULE_PARM_DESC(param_name, desc)
+
+#define FOLIO_POOL_64K_ORDER (PAGE_SHIFT < 16 ? 16 - PAGE_SHIFT : 0)
+
+struct folio_pool_chunk {
+	struct list_head link;
+	struct folio *folio;
+};
+
+/*
+ * 1. Variable-Sized Scratchpad (Core Bump Allocator Engine)
+ */
+struct folio_scratchpad {
+	struct list_head chunks;
+	void *free_ptr;
+	size_t remaining;
+	unsigned int chunk_order;
+	struct static_key *key;
+	spinlock_t lock;
+};
+
+#define FOLIO_SCRATCHPAD_INIT(name, _order) {				\
+	.chunks = LIST_HEAD_INIT((name).chunks),			\
+	.chunk_order = (_order),					\
+	.key = NULL,							\
+	.lock = __SPIN_LOCK_UNLOCKED((name).lock),			\
+}
+
+#define FOLIO_SCRATCHPAD_INIT_KEY(name, _order, _key) {			\
+	.chunks = LIST_HEAD_INIT((name).chunks),			\
+	.chunk_order = (_order),					\
+	.key = (struct static_key *)(_key),				\
+	.lock = __SPIN_LOCK_UNLOCKED((name).lock),			\
+}
+
+void folio_scratchpad_init(struct folio_scratchpad *sp, unsigned int order);
+void folio_scratchpad_init_key(struct folio_scratchpad *sp, unsigned int order,
+			       struct static_key *key);
+void *folio_scratchpad_alloc(struct folio_scratchpad *sp, size_t size,
+			     size_t align, gfp_t gfp);
+void folio_scratchpad_reset(struct folio_scratchpad *sp);
+void folio_scratchpad_free(struct folio_scratchpad *sp);
+void folio_scratchpad_stats(struct folio_scratchpad *sp, unsigned int *nr_chunks,
+			    size_t *chunk_size, size_t *tail_used);
+
+DEFINE_FREE(folio_scratchpad, struct folio_scratchpad *, if (_T) folio_scratchpad_free(_T))
+
+/**
+ * is_folio_pool_ptr - Check whether an address resides in a folio pool/scratchpad
+ * @ptr: Object pointer to test
+ *
+ * Direct-map large folios allocated via folio_alloc() are not slab pages,
+ * unlike objects returned by kmalloc/kzalloc.
+ */
+static inline bool is_folio_pool_ptr(const void *ptr)
+{
+	return ptr && !is_vmalloc_addr(ptr) && !folio_test_slab(virt_to_folio(ptr));
+}
+
+/**
+ * folio_pool_free_elem - Safely release a pool object or SLUB fallback element
+ * @ptr: Object pointer to release
+ *
+ * If @ptr belongs to a direct-map large folio, individual deallocation is a safe
+ * no-op (reclaimed in bulk by folio_scratchpad_free/reset). If @ptr was allocated
+ * via SLUB/vmalloc fallback, releases it immediately.
+ */
+static inline void folio_pool_free_elem(const void *ptr)
+{
+	if (!ptr || is_folio_pool_ptr(ptr))
+		return;
+	kvfree(ptr);
+}
+
+static inline void folio_scratchpad_free_elem(const void *ptr)
+{
+	folio_pool_free_elem(ptr);
+}
+
+/**
+ * folio_pool_realloc - Reallocate memory for an object, handling pool vs slab backing
+ * @ptr: Existing object pointer (may be from folio_pool/scratchpad or SLUB)
+ * @old_size: Size of original object
+ * @new_size: Desired new size
+ * @gfp: Allocation flags
+ *
+ * If @ptr is SLUB-backed, delegates directly to krealloc(). If @ptr resides
+ * in a direct-map large folio, allocates a fresh @new_size buffer from SLUB
+ * and copies @old_size bytes; the original scratchpad slot remains abandoned
+ * until the entire scratchpad is released or reset at batch boundary.
+ */
+static inline void *folio_pool_realloc(void *ptr, size_t old_size,
+				       size_t new_size, gfp_t gfp)
+{
+	void *new_ptr;
+
+	if (!ptr)
+		return kmalloc(new_size, gfp);
+
+	if (!is_folio_pool_ptr(ptr))
+		return krealloc(ptr, new_size, gfp);
+
+	new_ptr = kmalloc(new_size, gfp);
+	if (new_ptr)
+		memcpy(new_ptr, ptr, min(old_size, new_size));
+	return new_ptr;
+}
+
+static inline void *folio_scratchpad_realloc(void *ptr, size_t old_size,
+					     size_t new_size, gfp_t gfp)
+{
+	return folio_pool_realloc(ptr, old_size, new_size, gfp);
+}
+
+/**
+ * folio_scratchpad_alloc_obj - Allocate a typed object from an embedded scratchpad
+ * @ptr: Pointer to container struct (e.g. nft_net)
+ * @member: Name of the struct folio_scratchpad field (e.g. trans_scratchpad)
+ * @type: Type of object being allocated
+ * @gfp: Allocation flags
+ */
+#define folio_scratchpad_alloc_obj(ptr, member, type, gfp)			\
+	((type *)folio_scratchpad_alloc(&(ptr)->member,				\
+					sizeof(type),				\
+					__alignof__(type),			\
+					gfp))
+
+/**
+ * folio_scratchpad_alloc_bytes - Allocate variable-sized bytes from an embedded scratchpad
+ * @ptr: Pointer to container struct (e.g. nft_net)
+ * @member: Name of the struct folio_scratchpad field (e.g. trans_scratchpad)
+ * @size: Size of memory to allocate
+ * @align: Alignment requirement
+ * @gfp: Allocation flags
+ */
+#define folio_scratchpad_alloc_bytes(ptr, member, size, align, gfp)		\
+	folio_scratchpad_alloc(&(ptr)->member, size, align, gfp)
+
+/**
+ * folio_scratchpad_alloc_type - Allocate a typed object from a scratchpad pointer
+ * @sp: Pointer to struct folio_scratchpad
+ * @type: Type of object being allocated
+ * @gfp: Allocation flags
+ */
+#define folio_scratchpad_alloc_type(sp, type, gfp)				\
+	((type *)folio_scratchpad_alloc(sp,					\
+					sizeof(type),				\
+					__alignof__(type),			\
+					gfp))
+
+/*
+ * 2. Fixed-Slot Uniform Pool (Specialized Thin Wrapper on Scratchpad)
+ */
+struct folio_pool {
+	struct folio_scratchpad base;
+	size_t elem_size;
+	size_t elem_align;
+};
+
+#define FOLIO_POOL_INIT(name, _elem_size, _order) {			\
+	.base = FOLIO_SCRATCHPAD_INIT((name).base, _order),		\
+	.elem_size = (_elem_size),					\
+	.elem_align = ((_elem_size) > sizeof(void *) ? (_elem_size) : sizeof(void *)), \
+}
+
+#define FOLIO_POOL_INIT_KEY(name, _elem_size, _order, _key) {		\
+	.base = FOLIO_SCRATCHPAD_INIT_KEY((name).base, _order, _key),	\
+	.elem_size = (_elem_size),					\
+	.elem_align = ((_elem_size) > sizeof(void *) ? (_elem_size) : sizeof(void *)), \
+}
+
+void folio_pool_init(struct folio_pool *fp, size_t elem_size, unsigned int order);
+void folio_pool_init_key(struct folio_pool *fp, size_t elem_size, unsigned int order,
+			 struct static_key *key);
+void folio_pool_init_align(struct folio_pool *fp, size_t elem_size,
+			   size_t elem_align, unsigned int order);
+
+static inline void *folio_pool_alloc(struct folio_pool *fp, gfp_t gfp)
+{
+	return folio_scratchpad_alloc(&fp->base, fp->elem_size, fp->elem_align, gfp);
+}
+
+static inline void folio_pool_free(struct folio_pool *fp)
+{
+	folio_scratchpad_free(&fp->base);
+}
+
+static inline void folio_pool_stats(struct folio_pool *fp, unsigned int *nr_chunks,
+				    size_t *chunk_size, size_t *tail_used)
+{
+	folio_scratchpad_stats(&fp->base, nr_chunks, chunk_size, tail_used);
+}
+
+/**
+ * folio_pool_alloc_obj - Allocate a typed object from a container's embedded folio_pool
+ * @ptr: Pointer to container struct (e.g. env)
+ * @member: Name of the struct folio_pool field (e.g. state_pool)
+ * @type: Type of object being allocated (e.g. struct bpf_verifier_stack_elem)
+ * @gfp: Allocation flags
+ */
+#define folio_pool_alloc_obj(ptr, member, type, gfp)				\
+	((type *)folio_pool_alloc(&(ptr)->member, gfp))
+
+/**
+ * folio_pool_alloc_type - Allocate a typed object from a struct folio_pool pointer
+ * @fp: Pointer to struct folio_pool
+ * @type: Type of object being allocated
+ * @gfp: Allocation flags
+ */
+#define folio_pool_alloc_type(fp, type, gfp)					\
+	((type *)folio_pool_alloc(fp, gfp))
+
+#endif /* _LINUX_FOLIO_POOL_H */
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94..b5f2f41f96fb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -58,7 +58,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bsearch.o find_bit.o llist.o lwq.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o base64.o \
 	 once.o refcount.o rcuref.o usercopy.o errseq.o bucket_locks.o \
-	 generic-radix-tree.o bitmap-str.o
+	 generic-radix-tree.o bitmap-str.o folio_pool.o
 obj-y += string_helpers.o
 obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
diff --git a/lib/folio_pool.c b/lib/folio_pool.c
new file mode 100644
index 000000000000..07a290db6c50
--- /dev/null
+++ b/lib/folio_pool.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Direct-Map Large Folio Scratchpad & Pool bump allocators.
+ */
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/moduleparam.h>
+#include <linux/folio_pool.h>
+
+DEFINE_STATIC_KEY_TRUE(folio_pool_enabled_key);
+EXPORT_SYMBOL_GPL(folio_pool_enabled_key);
+
+static int folio_pool_enabled_set(const char *val, const struct kernel_param *kp)
+{
+	bool enable;
+	int ret = kstrtobool(val, &enable);
+
+	if (ret)
+		return ret;
+
+	if (enable)
+		static_branch_enable(&folio_pool_enabled_key);
+	else
+		static_branch_disable(&folio_pool_enabled_key);
+
+	return 0;
+}
+
+static int folio_pool_enabled_get(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", static_branch_likely(&folio_pool_enabled_key) ? 'Y' : 'N');
+}
+
+static const struct kernel_param_ops folio_pool_enabled_ops = {
+	.set = folio_pool_enabled_set,
+	.get = folio_pool_enabled_get,
+};
+
+module_param_cb(enabled, &folio_pool_enabled_ops, NULL, 0644);
+MODULE_PARM_DESC(enabled, "Toggle folio_pool/scratchpad bump allocator (0 = fallback to SLUB)");
+
+/*
+ * 1. Variable-Sized Scratchpad (Core Engine)
+ */
+void folio_scratchpad_init_key(struct folio_scratchpad *sp, unsigned int order,
+			       struct static_key *key)
+{
+	INIT_LIST_HEAD(&sp->chunks);
+	sp->free_ptr = NULL;
+	sp->remaining = 0;
+	sp->chunk_order = order;
+	sp->key = key;
+	spin_lock_init(&sp->lock);
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_init_key);
+
+void folio_scratchpad_init(struct folio_scratchpad *sp, unsigned int order)
+{
+	folio_scratchpad_init_key(sp, order, NULL);
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_init);
+
+static inline bool folio_scratchpad_is_enabled(const struct folio_scratchpad *sp)
+{
+	if (sp->key)
+		return static_key_enabled(sp->key);
+	return static_branch_likely(&folio_pool_enabled_key);
+}
+
+noinline void *folio_scratchpad_alloc(struct folio_scratchpad *sp, size_t size,
+				     size_t align, gfp_t gfp)
+{
+	struct folio_pool_chunk *chunk;
+	struct folio *folio;
+	void *elem, *base;
+	size_t chunk_size, aligned_size, pad, header_offset;
+	unsigned long flags;
+
+	if (!folio_scratchpad_is_enabled(sp))
+		return kvzalloc(size, gfp);
+
+	if (unlikely(!size))
+		return NULL;
+
+	align = max_t(size_t, sizeof(void *), align ? align : sizeof(void *));
+
+	spin_lock_irqsave(&sp->lock, flags);
+	pad = (uintptr_t)sp->free_ptr & (align - 1);
+	if (pad)
+		pad = align - pad;
+	aligned_size = size + pad;
+
+	if (sp->remaining < aligned_size) {
+		spin_unlock_irqrestore(&sp->lock, flags);
+
+		folio = folio_alloc(gfp, sp->chunk_order);
+		if (!folio && sp->chunk_order > 0)
+			folio = folio_alloc(gfp, 0);
+		if (!folio)
+			return NULL;
+
+		base = folio_address(folio);
+		chunk = (struct folio_pool_chunk *)base;
+		chunk->folio = folio;
+		chunk_size = folio_size(folio);
+		header_offset = ALIGN(sizeof(*chunk), max_t(size_t, sizeof(void *), align));
+
+		spin_lock_irqsave(&sp->lock, flags);
+		list_add(&chunk->link, &sp->chunks);
+		sp->free_ptr = base + header_offset;
+		sp->remaining = chunk_size - header_offset;
+
+		pad = (uintptr_t)sp->free_ptr & (align - 1);
+		if (pad)
+			pad = align - pad;
+		aligned_size = size + pad;
+	}
+
+	if (sp->remaining < aligned_size) {
+		spin_unlock_irqrestore(&sp->lock, flags);
+		return NULL;
+	}
+
+	elem = sp->free_ptr + pad;
+	sp->free_ptr += aligned_size;
+	sp->remaining -= aligned_size;
+	spin_unlock_irqrestore(&sp->lock, flags);
+
+	memset(elem, 0, size);
+	return elem;
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_alloc);
+
+noinline void folio_scratchpad_reset(struct folio_scratchpad *sp)
+{
+	struct folio_pool_chunk *head, *chunk, *tmp;
+	size_t header_offset;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sp->lock, flags);
+	if (list_empty(&sp->chunks)) {
+		sp->free_ptr = NULL;
+		sp->remaining = 0;
+		spin_unlock_irqrestore(&sp->lock, flags);
+		return;
+	}
+
+	/* Retain primary head chunk; free overflow chunks */
+	head = list_first_entry(&sp->chunks, struct folio_pool_chunk, link);
+	list_for_each_entry_safe(chunk, tmp, &sp->chunks, link) {
+		if (chunk == head)
+			continue;
+		list_del(&chunk->link);
+		folio_put(chunk->folio);
+	}
+
+	header_offset = ALIGN(sizeof(*head), sizeof(void *));
+	sp->free_ptr = folio_address(head->folio) + header_offset;
+	sp->remaining = folio_size(head->folio) - header_offset;
+	spin_unlock_irqrestore(&sp->lock, flags);
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_reset);
+
+noinline void folio_scratchpad_free(struct folio_scratchpad *sp)
+{
+	struct folio_pool_chunk *chunk, *tmp;
+	struct folio *folio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sp->lock, flags);
+	sp->free_ptr = NULL;
+	sp->remaining = 0;
+	list_for_each_entry_safe(chunk, tmp, &sp->chunks, link) {
+		folio = chunk->folio;
+		list_del(&chunk->link);
+		folio_put(folio);
+	}
+	spin_unlock_irqrestore(&sp->lock, flags);
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_free);
+
+/*
+ * 2. Fixed-Slot Uniform Pool (Specialized Thin Wrapper on Scratchpad)
+ */
+void folio_pool_init_align(struct folio_pool *fp, size_t elem_size,
+			   size_t elem_align, unsigned int order)
+{
+	folio_scratchpad_init(&fp->base, order);
+	fp->elem_size = elem_size;
+	fp->elem_align = max_t(size_t, sizeof(void *), elem_align ? elem_align : sizeof(void *));
+}
+EXPORT_SYMBOL_GPL(folio_pool_init_align);
+
+void folio_pool_init_key(struct folio_pool *fp, size_t elem_size, unsigned int order,
+			 struct static_key *key)
+{
+	size_t align = sizeof(void *);
+
+	if (elem_size && is_power_of_2(elem_size))
+		align = max_t(size_t, sizeof(void *), elem_size);
+	folio_scratchpad_init_key(&fp->base, order, key);
+	fp->elem_size = elem_size;
+	fp->elem_align = align;
+}
+EXPORT_SYMBOL_GPL(folio_pool_init_key);
+
+void folio_pool_init(struct folio_pool *fp, size_t elem_size, unsigned int order)
+{
+	folio_pool_init_key(fp, elem_size, order, NULL);
+}
+EXPORT_SYMBOL_GPL(folio_pool_init);
+
+void folio_scratchpad_stats(struct folio_scratchpad *sp, unsigned int *nr_chunks,
+			    size_t *chunk_size, size_t *tail_used)
+{
+	unsigned long flags;
+	size_t csz;
+
+	csz = (PAGE_SIZE << sp->chunk_order);
+	if (chunk_size)
+		*chunk_size = csz;
+
+	spin_lock_irqsave(&sp->lock, flags);
+	if (nr_chunks)
+		*nr_chunks = list_count_nodes(&sp->chunks);
+	if (tail_used)
+		*tail_used = csz > sp->remaining ? csz - sp->remaining : 0;
+	spin_unlock_irqrestore(&sp->lock, flags);
+}
+EXPORT_SYMBOL_GPL(folio_scratchpad_stats);

-- 
2.55.0



