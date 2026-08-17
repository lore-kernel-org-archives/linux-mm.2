Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F6AC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CEC6B00CE; Mon, 17 Aug 2026 08:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB86D6B00CF; Mon, 17 Aug 2026 08:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58E06B00D0; Mon, 17 Aug 2026 08:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 995576B00CE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2466412068B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:11 +0000 (UTC)
X-FDA: 85110726582.16.F12E572
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4775920004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bjyeb0cF;
	spf=pass (imf31.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970589;
	b=BQfs5PdiSrJVAjsshJL1VogW/OJOy7gMeEjRYyXuQjNV5axZjvFqmz09FCXL+y/uYPBVi+
	N5Kkp0MGJd2hp1uLwwX7bsbQizrbMIgKjwN8HVh5QVf80WA9LSe8VAG3jbgVQuoUV1gItj
	osGqR92066CGxTtNPABdjaCyCNXqvEw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bjyeb0cF;
	spf=pass (imf31.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTB1+FCNUBbtk/wxJTJyqubMSGpfxVMNiUg/WWAjSjU=;
	b=WLUbFgHOC+TSlJPIPlurM6dekKmY9bcKOMH1/YAeURVSBcO2y/hx+WopLV7zbcMvg2mgtM
	kL0BGGgC26nbXpeH0lxlO2RVkSdjfgB8c2dO4l27nxOEzYlOUGd+aKKCsUKMFFNvo0uHmM
	mDqoLwZKTHQy0+KS7tyko2pERJb+zKo=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c167aa9500dso469447766b.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970588; x=1787575388; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MTB1+FCNUBbtk/wxJTJyqubMSGpfxVMNiUg/WWAjSjU=;
        b=Bjyeb0cF4pgxSBaeBCPsBKwRWEzNQQ4avYNHKwCl8JNw+rwCj5CY9w6t68Ve5V6AJV
         UI1Nf/n0f3fk4uMGqA8puK4WDlMsWpEuaiOJbgSGuL0eW2tYIup4jtA60j4pDcSk/tel
         aZrNJnpyyDiUPM6MVx6BBui2XX6U+6oPlB2yAIEGVaL8mh0B4Fmab+D+qeZbqCCbvmp2
         qpLwYgH9ol6O93+W2IdZ1dNBv0oP1HRubILtwgMwYwXF/h1MqLj37N5Wt7znMVQck7Dt
         xhqRtlq572knKrCGV1VX9rJY0ndiPNvftb6AdF/oBkZf2jeki3+ppertelxZ1kT2yTf8
         VMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970588; x=1787575388;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MTB1+FCNUBbtk/wxJTJyqubMSGpfxVMNiUg/WWAjSjU=;
        b=oRnS3WCwaRQ6RWBAj01HaItJLDfmvclSrbWelYVqnS1sVqse3qXkJPZSxE+RsrpvcJ
         QuSsF0S9nVkbrOkBqATwN3cazs1G/z7fpP5e3O+5seib/2wjZ+L+0XxPNF13Q2uDZebB
         KbNDF47HXZUsgquRNOEDM5rgXP8LJ5PchuHtcb1SQHrGyo3x2k8Pj6rLXcFn3daeUBi7
         IGuENxMG1UQURJmBqWxU9nRA/gjs4eQlbzVWLHeIqXa9/F3210kimIthg/P7gTh/VTeY
         0viM2FyNOI8iBJKqrfxTdGCWqGqnrolEKYKNxQwKxQzhk328x+v7+hijLnjKX43+okUl
         c9NQ==
X-Gm-Message-State: AOJu0YyOQQd/t0oyY5+LdTD1IRKzLvvKUtroxk+bN1Pb766GHVIOM0lU
	rMjkf30muXrmiPatkLqaWzV5JzJx+u6J++FrQZ4fGjsDGsTsdQ6pxoZA
X-Gm-Gg: AR+sD10jB1myDMlioZrqbX0ZjxKMSqKT5SCgGyRAfLMXqALaIoOn+bVOfcbE1yT7yW6
	ygvrsiNCFJ+Am+UgatUkFjp52i2QtvVCl5QXXC+eFWmWqtZVConx6t7oZr0dm686AgrCjkRNs7I
	c8g2vlw+od9+amiAa2L15elwjNlaQdcf/Ro7caWlamNypDkjX2ei39OYhcQO4ORd/xLLHCIViFz
	tvTTuSkJY5oozsgFxei7R3B21EqDCb7HmUgHqM4t5PdOzv2N+5BMRsVAQN3XiVylONHN+8TbPbU
	mO48b/XJTIlQdr0ZQcsfohyaIWFFNHagrSsgo8BmZEctOralrvRF+yOJvLGV+6VVuLgHWqTZ0xW
	t4rywmVI0hj34BVzsQlIIjn1ufVHkU9+/eiWNcVc1czd5E9Tr0kWZ2u/C9F6cPZcfdMDWvwYoap
	/tlEaZsgNSS3aGbBx01t5bANbwzP3hosjQublv6lNEKFg6MG43aQ==
X-Received: by 2002:a17:907:c788:b0:c15:d0b6:495c with SMTP id a640c23a62f3a-c212a2452admr1247772466b.29.1786970587948;
        Mon, 17 Aug 2026 05:43:07 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:07 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:49 +0100
Subject: [PATCH RFC 9/9] stackdepot: add boot-time activation for trie
 storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-9-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 4775920004
X-Rspam-User: 
X-Stat-Signature: rfn3onn1gwpdd8qnwdxpq1pc7ddruog3
X-Rspamd-Server: rspam06
X-HE-Tag: 1786970589-662338
X-HE-Meta: U2FsdGVkX19t23+i6BqYYBKSdZQ0OkWQi77nrZGfmAlNfytmoEucxI8MQ4pIvfzfG4v3hn9wFHm43ZJNb359heP4Tuy8loViN6E2TfWo1BCp+kvYtMdIPHv3/YG0dSgovFwBVoW08KMtTvghSKWqoxnlheplKO+Jv1HntwdSTe45BH+vaPj/4uBsk9+h0zrTWgDv5FA0yJcV0f6K7YJ4y3Gbfx8ah0X9Zk5uyzz4NlsXEeEZVWbtXUhh1xsu754tsihqX4rDQt+xlVqfPBlumC+M43HjZG50Si8Cz9YdHI0+tU53JD+h1niFqZ/3mSW4xQyKFH+aKlXkpRkeC1QOrHRTm8y+vuVM/za/DetVlB55IFHq/Cdn4msQtD3jeMBTTd423w/5eN11lqvyA6w5SscXi2EVGLnuI6MqKG3U0Kcq3FxNoEdHKSTHNsr8JZW1/NDXHBP+LSa5viC4iwRlwhUBuXd4nzLcRMjtH6GHET+Xy2qNspZeHstX+AZPppNC+VnNEKrgeqKfyiTVlkvDZrtFd3R18FSoguL/3fbGer68V9GdPH1pYM1AQXp9BE/jZYMb+0vTSktokg914+ZUsde5YUAv9YHQyBO28UOlM7RiKPUHkI3sJ0b8phqtIbhDFT/mvvBFfUcljYXV7Ujl8EYd/lHwqSOyTTx/HhIL4knhLkumMrD8VlM1H790I8CTWwEa0Ymb+3s3bBTYo1wGhsspw8nGcQJUQfwfKdwClEB/kcJ6N1QIoARBjAIADGE3fOlGtx0BYugW2W1pbVLRF7DLpoKI57gfYSZY/rksl5EytbgjsH6DiKDTtOaEXn+s5I8iPbHibJGzNwIbNGCp0ssJ9NGVrZfYIzGNwc6uJgolEC23DyhEtb1121iXLy2EWj+REm+RVUu43pUiZ0Zucumu/XVPjbKq9Mt4AshnkrrcWdohmPoEqr8nzZtL/fSfydg7Sder9xQqAnBqTak
 ndSPsd/y
 2JEx/Y82BAjX03oleAs7y5cfIhbmTz2VE17uYpxdua4NdUQvrdOvgI8oz8zLPvTAm3Coqy0Xd9BC/YeyTojKOxA3OKZ4RAZq2lMIBIA7b12aAknBbW1Hipd5kq0MdGcaTxuGMIqxmAMRIbSfA4I6/mpJd7qp6AxIcrqSaclfEeOt7I/ZPmntW+sxBrZJ6Mng+kFt3+/TEAfOCSrLjsYvV/CSy6uENKkyS/EwWoJRaHBdwDSoD9JweDi0n4NP6+ewFRUrCqYxZbTwHwOkWmRJZZ5CrS0CtVw8MbrSalSFDeTNQKLsU9Zwb/B+ep8NuRFAXz7m90o3t/4/1lbCQuPTI8C7JzBhXur+lB9tE4Q+SVg2sJjavu9bzD/pMtNqX4N393mWXVN0fyeZDJvnJvA5Jsg3XQ0BQvUB+yd+QLHeGJK7KDnJkO13kKBDgOM5Xvv3U3mUYTMEJvKW+uAubVqniQEtD7qviDMMPlsMA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

Trie storage cannot be activated while persistent stack depot consumers
can pass trie-backed handles to hash-only access paths. The preceding
patches make those paths backend-independent, keep the corresponding saves
explicitly hash-backed, or make the GDB helper reject trie-backed handles.
The trie can now be activated without exposing incompatible handles.

Add the boot-only stackdepot.trie_enabled parameter. Keep it disabled by
default because lookup-only constrained misses can lose traces and the GDB
helper does not decode trie handles. Guard backend selection with a static
key so the existing hash-only path does not take a normal runtime branch
when the parameter is absent. Document the parameter and its
handle-namespace requirements.

The available trie ID space depends on stack_depot_max_pools because hash
and trie handles share the pool-index field. Configurations that consume
the entire field cannot enable the backend. In particular, a 64 KiB page
configuration using the default maximum of 8,191 pools must lower
stack_depot_max_pools to leave trie ID space.

For early stack depot initialization, allocate the trie side-table root,
first directory, and first chunk through memblock. For later
initialization, allocate the root with kvzalloc and grow directory and
chunk pages lazily. Enable the static key only after initialization
succeeds.

Treat trie initialization as optional. If the handle namespace is empty or
metadata allocation fails, warn, clear the request, and continue using the
initialized hash backend at its configured capacity.

Hash and trie storage continue to share stack_pools and the configured
physical pool limit. Pools consumed by trie slots are therefore unavailable
to refcounted and countable hash records.

Once enabled, saves without STACK_DEPOT_FLAG_GET or
STACK_DEPOT_FLAG_COUNTABLE use the trie. GET and COUNTABLE saves remain
hash-backed; trie-eligible saves that cannot allocate perform a single
lockless lookup, and per-save trie insertion failures do not fall back to
hash storage.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 Documentation/admin-guide/kernel-parameters.txt |   7 ++
 lib/stackdepot.c                                | 100 ++++++++++++++++++++++--
 2 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1af62cd16c9d..ebb7b7e1867f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7387,6 +7387,13 @@ Kernel parameters
 			stack traces. Pools are allocated on-demand up to this
 			limit. Default value is 8191 pools.
 
+	stackdepot.trie_enabled= [KNL]
+			Format: <bool>
+			Enable trie storage for persistent, non-refcounted
+			stack depot records at boot. Disabled by default.
+			stack_depot_max_pools must leave unused pool-index
+			values for trie handles.
+
 	stacktrace	[FTRACE]
 			Enable the stack tracer on boot up.
 
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 1e5b9fc44618..1a002063a948 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -28,6 +28,7 @@
 #include <linux/kmsan.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/poison.h>
 #include <linux/printk.h>
@@ -100,8 +101,8 @@ static const char *const counter_names[] = {
 	[DEPOT_COUNTER_REFD_FREES]	= "refcounted_frees",
 	[DEPOT_COUNTER_REFD_INUSE]	= "refcounted_in_use",
 	[DEPOT_COUNTER_FREELIST_SIZE]	= "freelist_size",
-	[DEPOT_COUNTER_PERSIST_COUNT]	= "persistent_count",
-	[DEPOT_COUNTER_PERSIST_BYTES]	= "persistent_bytes",
+	[DEPOT_COUNTER_PERSIST_COUNT]	= "hash_persistent_count",
+	[DEPOT_COUNTER_PERSIST_BYTES]	= "hash_persistent_bytes",
 };
 static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
 
@@ -180,6 +181,10 @@ static_assert(STACK_DEPOT_TRIE_POOL_FIRST_SLOT < STACK_DEPOT_TRIE_POOL_SLOTS);
 static DEFINE_STATIC_KEY_FALSE(stack_depot_trie_enabled);
 static const struct stack_depot_trie_children __rcu *stack_depot_trie_root;
 static DEFINE_RAW_SPINLOCK(stack_depot_trie_writer_lock);
+static bool stack_depot_trie_requested;
+
+module_param_named(trie_enabled, stack_depot_trie_requested, bool, 0);
+MODULE_PARM_DESC(trie_enabled, "Enable stack depot trie storage at boot");
 
 #define DEPOT_POOL_INDEX_MASK ((1U << DEPOT_POOL_INDEX_BITS) - 1)
 #define DEPOT_OFFSET_MASK ((1U << DEPOT_OFFSET_BITS) - 1)
@@ -236,8 +241,9 @@ static u32 trie_stack_id(depot_stack_handle_t handle)
 /*
  * Trie handles encode a dense stack ID. The side table maps that ID to a node
  * pointer for lockless fetch and print paths, which can run from diagnostic
- * contexts where taking a lock would be unsafe. Additional directories and
- * chunks are published lazily as stack IDs grow.
+ * contexts where taking a lock would be unsafe. Initialization installs the
+ * root; early initialization also installs the first directory and chunk.
+ * Additional directories and chunks are published lazily as stack IDs grow.
  */
 #define STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE \
 	(PAGE_SIZE / sizeof(struct stack_depot_trie_node *))
@@ -375,6 +381,75 @@ trie_side_table_prepare_stack_slot(struct stack_depot_trie_side_prealloc *preall
 	return id;
 }
 
+static inline unsigned int trie_side_table_root_size_for_max_id(u32 max_stack_id)
+{
+	unsigned int top_size;
+
+	top_size = DIV_ROUND_UP(max_stack_id,
+				STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE);
+	return DIV_ROUND_UP(top_size, STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE);
+}
+
+static int __init stack_depot_trie_init_memblock(void)
+{
+	struct stack_depot_trie_side_root *root_vec;
+	struct stack_depot_trie_side_dir *first_dir;
+	const struct stack_depot_trie_node __rcu **first_chunk;
+	size_t root_bytes;
+	u32 max_stack_id;
+	unsigned int root_size;
+
+	max_stack_id = trie_max_stack_id();
+	if (!max_stack_id)
+		return -EINVAL;
+	root_size = trie_side_table_root_size_for_max_id(max_stack_id);
+	root_bytes = struct_size_t(struct stack_depot_trie_side_root, dirs,
+				   root_size);
+
+	root_vec = memblock_alloc(root_bytes, __alignof__(*root_vec));
+	if (!root_vec)
+		return -ENOMEM;
+	first_dir = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!first_dir) {
+		memblock_free(root_vec, root_bytes);
+		return -ENOMEM;
+	}
+	first_chunk = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!first_chunk) {
+		memblock_free(first_dir, PAGE_SIZE);
+		memblock_free(root_vec, root_bytes);
+		return -ENOMEM;
+	}
+
+	root_vec->dir_capacity = root_size;
+	RCU_INIT_POINTER(root_vec->dirs[0], first_dir);
+	RCU_INIT_POINTER(first_dir->chunks[0], first_chunk);
+	trie_side_table_root = root_vec;
+	static_branch_enable(&stack_depot_trie_enabled);
+	return 0;
+}
+
+static int stack_depot_trie_init(void)
+{
+	struct stack_depot_trie_side_root *root_vec;
+	unsigned int root_size;
+	u32 max_stack_id;
+
+	max_stack_id = trie_max_stack_id();
+	if (!max_stack_id)
+		return -EINVAL;
+
+	root_size = trie_side_table_root_size_for_max_id(max_stack_id);
+	root_vec = kvzalloc_flex(*root_vec, dirs, root_size);
+	if (!root_vec)
+		return -ENOMEM;
+
+	root_vec->dir_capacity = root_size;
+	trie_side_table_root = root_vec;
+	static_branch_enable(&stack_depot_trie_enabled);
+	return 0;
+}
+
 static int trie_side_table_get_prealloc(gfp_t gfp_flags,
 					struct stack_depot_trie_side_prealloc *prealloc)
 {
@@ -702,7 +777,7 @@ static void init_stack_table(unsigned long entries)
 		INIT_LIST_HEAD(&stack_table[i]);
 }
 
-/* Allocates a hash table via memblock. Can only be used during early boot. */
+/* Initializes hash and optional trie storage during early boot. */
 int __init stack_depot_early_init(void)
 {
 	unsigned long entries = 0;
@@ -776,11 +851,15 @@ int __init stack_depot_early_init(void)
 		stack_depot_disabled = true;
 		return -ENOMEM;
 	}
+	if (stack_depot_trie_requested && stack_depot_trie_init_memblock()) {
+		pr_warn("trie storage initialization failed, disabling trie storage\n");
+		stack_depot_trie_requested = false;
+	}
 
 	return 0;
 }
 
-/* Allocates a hash table via kvcalloc. Can be used after boot. */
+/* Initializes hash and optional trie storage after boot. */
 int stack_depot_init(void)
 {
 	static DEFINE_MUTEX(stack_depot_init_mutex);
@@ -834,6 +913,15 @@ int stack_depot_init(void)
 		kvfree(stack_table);
 		stack_depot_disabled = true;
 		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	if (stack_depot_trie_requested) {
+		ret = stack_depot_trie_init();
+		if (ret) {
+			pr_warn("trie storage initialization failed, disabling trie storage\n");
+			stack_depot_trie_requested = false;
+			ret = 0;
+		}
 	}
 
 out_unlock:

-- 
Git-155)


