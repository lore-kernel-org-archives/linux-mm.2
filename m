Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1FF606A888
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8bPOIyn
Received: by kanga.kvack.org (Postfix)
	id 5F5D86B05BA; Mon, 16 Nov 2026 08:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6866B05BB; Mon, 16 Nov 2026 08:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449236B05BC; Mon, 16 Nov 2026 08:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD886B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:40:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86D051A023B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:35 +0000 (UTC)
X-FDA: 85441092030.09.024EEFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E2C8F12000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8bPOIyn;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836434;
	b=LVZh7lf47aoCIIkpf92i9cQlOd8XafIhypjpVkGObNnetnOrNstktDLK4xD/P/vipdcn6J
	vtldC5vbWL63AhMAAsu0DeZc94g2gv3bdTuCVbMPQ5F/ZOVBV31GtTg0XnEpotnVclDmBM
	6vwYlJsCVhRjXU8jZXG2vatRGHvg0lg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8bPOIyn;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYgyn8LtgNjiMHX6eD/gxD1UgRPSmvQedUS/F8jkVfg=;
	b=OHkz1OL8/0tI9RH5tH4bArJ1PqNMyMyRyyrqbrkZoSDTTleRZjmdePpwidXFhXijoK0XaG
	CaCD2k3Lx/CHXkeJao9mzpPx1F6BraGtYw26zhKniOvgIVpVRv4W+G0uhUSKqrMbpNa2L2
	WuRFxPFyzgqV20XZLIo0x4MNJtX4Db4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 766E362C03;
	Mon, 16 Nov 2026 13:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC641F000D2;
	Mon, 16 Nov 2026 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836433;
	bh=TYgyn8LtgNjiMHX6eD/gxD1UgRPSmvQedUS/F8jkVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8bPOIynPx5X4vqJOxzL1I6VibrPdbImiPBbXUnNvBJrw013sMDWS+x2u7qhMMlbq
	 NCq7GZZpF8HNfV+g1L55QeUobd8W01VN7iA4SuX9O0xQcTzHk9ev9jiEC2NbeThsyu
	 WCDeceAapp6l0pC4UzW7QC8A0ujfZ8XIJz9WVtLrQP1Ee4CXnk1UBsoaC1WUKJbzn2
	 MrD0W5FTC1K3/+eMlSoyxaKiBtpY1RQDv57NJ4KGjtxZBjo0RdNANN3UrcTJTZd6Kp
	 iSRC4BfloP4QEdNHA+cpfE6QmwxQeElS+eQulwAHWRROnW6ULtSXsodNAoeNIoIS4O
	 LDXhyVOQXZ40A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 3/5] kho: add KHO map
Date: Mon, 16 Nov 2026 14:40:08 +0100
Message-ID: <20261116134013.1636689-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E2C8F12000D
X-Stat-Signature: 3us6gysr475xg9a4ow3t3dj861rx5pps
X-Rspam-User: 
X-HE-Tag: 1794836433-504046
X-HE-Meta: U2FsdGVkX18COeYUUAVBnBseTbSMPg/0/fZtz3Ql3gd2GMPu+sChFgDGPTYtBI/IDUmPLpzxEPaJP3tg5/L66jtcDYgDL5dsVR8hmOr5ma9USH9Db3IJM0DtB3nyt84qp6TXMyxN3kqbw1xGXi90vIQwbEmwy+Lam3QEoIMui5/QwTFvJnWdZd7D7+UcnO1zVT72fWmNWlRxi/flpiB2Dmb5AHzPyayqTaAQm/upoNhLy7s2qwsAzs1E6R04qscf3ovlswOx6T9C3xecnoKjjq1/0bOxW85W38d/KBS7Dm/rxlS562lBwJQ2uNYE9DmtSuK5Pl6o4RG2bix6qGhx6WC8/HYaSAvpEFCBZ2Hxix8cmW5KEAvpZlwx8R/2+Ly7MVG9OuD2NvYMAQ49CtLsdXoHAy2QZZ4r6/WUmgIRnHX5CbhM0jial1uich6ha282D2zB9BAjlykJYyz2KojGrKhYOM2Qbm699bytL6brF5OCE1asUbKIu09aAL7l1lzT5+QdwCEP8ENeEOaGiodFn1E8MLsFHBoKMzHUgS4RkSRlViFEgDdA+sz1/ocxmr7Msq4dK7xmvMsuc/NUoV0UEn/Lpdc66Y1D0gwZusQZmOTE7xUfZy5M+e3HP2DlHGZ4tISxcOJGk+xiqi48r/Fb0uKuysAYyBn++PJRbzmnArm8bf04vF/wls40rzff6vxspU+3C1d09BjOZGSZhlNIy+Qw6pY1Jh9PHei8uxB+DevbRrN3UcCaWgavQt1uk1oDEZtw7k/oedailxKp2L5aHf62d3T2hv+SPHBdsc9MfF9TtiFwSNeuywBfgvCCrQZ6NwSL4lAlZNKacT90jgDx0+3SLnfhLANZcf4F7zfbLqM1IW7MUWRvPrGdyl+VCsdtzJH0kph47FUrVj7bfurcRicqorYMzWI7NWyn7JrKIxyG0IMv8dcgd5t79whdBWETZedhPMyiUH2e+6fjDFa
 sGbFkLzc
 7XXg9MjhPQfGvIyLj38DaEQIkGE2Gqd4CWZZm1drk4oIwxfa1ey0MgyEASAGgDDPorSmDs5pgbdmiS11OCIKXehhgI88hf3cLzH6ubwv6huAcMrOKcIeFZsGrOvcFS0MI/Gz/ybB6AMEDGiuTVNT0iyOZAjCxiT+8qEQj0TJJNi9ZpHUKR8uBce2J1URwYeF7Zipcb/BcjOvqPxrF00jAfBlYqVf/Amq6xJwrELxmdrlmVylkyKPSbmHvSUf81dCyn6L73tbWDU8+QG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO map is a sparse map from integer keys to u64 values that can be
preserved via KHO. Internally, it is a radix tree of fixed depth with
one page per node. The tree has a depth of 6 nodes, so it can support
keys up to 54 bits wide. Each node points to a lower node, with the
lowest node, the leaf, holds the value.

The map can be used to preserve a sparse key-value map. One example is
the index -> folio map in a memfd.

The map is initialized via kho_map_init(), and cleaned up via
kho_map_destroy(). kho_map_{get,set,clear}() are used to set the entries
in the map, and kho_map_for_each() and kho_map_for_each_from() are used
for traversal.

kho_map_{preserve,restore}() are used for KHO preservation and
restoration. The map is unpreserved at the start. Once it is preserved,
a subsequent kho_map_set() that needs a new node will auto-preserve the
node. kho_map_restore() returns a unpreserved map.

The map does not currently free unused nodes. Nodes are freed (and
unpreserved) upon kho_map_destroy().

The map does not have any locks, so accesses must be serialized by
callers.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/core-api/kho/abi.rst   |   5 +
 Documentation/core-api/kho/index.rst |  12 +
 include/linux/kho/abi/map.h          |  94 +++++
 include/linux/kho_map.h              |  77 ++++
 kernel/liveupdate/Makefile           |   3 +-
 kernel/liveupdate/kho_map.c          | 514 +++++++++++++++++++++++++++
 6 files changed, 704 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kho/abi/map.h
 create mode 100644 include/linux/kho_map.h
 create mode 100644 kernel/liveupdate/kho_map.c

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index edeb5b3119638..2d56d3089d65b 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -33,6 +33,11 @@ KHO serialization block ABI
 
 .. kernel-doc:: include/linux/kho/abi/block.h
 
+KHO map ABI
+===========
+
+.. kernel-doc:: include/linux/kho/abi/map.h
+
 See Also
 ========
 
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index e78a2bbe2be1d..36cbfd3656306 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -94,6 +94,18 @@ KHO Serialization Blocks API
 .. kernel-doc:: kernel/liveupdate/kho_block.c
   :internal:
 
+KHO map
+=======
+
+.. kernel-doc:: kernel/liveupdate/kho_map.c
+  :doc: KHO map
+
+.. kernel-doc:: include/linux/kho_map.h
+  :identifiers: kho_map kho_map_clear kho_map_for_each_from kho_map_for_each
+
+.. kernel-doc:: kernel/liveupdate/kho_map.c
+  :internal:
+
 See Also
 ========
 
diff --git a/include/linux/kho/abi/map.h b/include/linux/kho/abi/map.h
new file mode 100644
index 0000000000000..ebcedaf94b6f5
--- /dev/null
+++ b/include/linux/kho/abi/map.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pratyush Yadav <pratyush@kernel.org>
+ */
+
+#ifndef _LINUX_KHO_ABI_MAP_H
+#define _LINUX_KHO_ABI_MAP_H
+
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/log2.h>
+#include <linux/math.h>
+
+#include <asm/page.h>
+
+/**
+ * DOC: KHO map ABI
+ *
+ * The ABI defined below is used for passing a KHO map from one kernel to the
+ * next.
+ *
+ * - ``struct kho_map_ser`` holds the physical address of the root node, or
+ *   0 for an empty tree.
+ * - The tree always has %KHO_MAP_DEPTH levels. Level
+ *   ``KHO_MAP_DEPTH - 1`` is the root and level 0 holds the leaves.
+ * - Every node and leaf is a single page, preserved as an order 0 folio.
+ * - A key is at most %KHO_MAP_KEY_WIDTH bits wide. It is split into
+ *   %KHO_MAP_TBL_SHIFT bit indices, one per level, with the most
+ *   significant bits indexing the root and the least significant bits
+ *   indexing the leaf.
+ * - Intermediate nodes (``struct kho_map_node_ser``) hold the physical
+ *   addresses of the nodes one level below, or 0 for none.
+ * - Leaves (&struct kho_map_leaf_ser) hold the values, where 0 means there
+ *   is no entry.
+ *
+ * The KHO map has no version of its own. Any change to this layout,
+ * including to %KHO_MAP_KEY_WIDTH, is a breaking change for every user that
+ * hands over a KHO map, and requires bumping their ABI versions.
+ */
+
+/**
+ * enum kho_map_consts - Constants describing the KHO map layout.
+ * @KHO_MAP_KEY_WIDTH: Maximum width of a key, in bits.
+ * @KHO_MAP_TBL_ENTRIES: Number of entries in a node or leaf.
+ * @KHO_MAP_TBL_SHIFT: Number of key bits used as the index at each level.
+ * @KHO_MAP_TBL_MASK: Mask for the index at each level.
+ * @KHO_MAP_DEPTH: Number of levels in the tree.
+ */
+enum kho_map_consts {
+	/* TODO: support dynamic width? */
+	/* Adds up to a depth of 6. */
+	KHO_MAP_KEY_WIDTH = 54,
+
+	KHO_MAP_TBL_ENTRIES = PAGE_SIZE / sizeof(u64),
+	KHO_MAP_TBL_SHIFT = const_ilog2(KHO_MAP_TBL_ENTRIES),
+	/* KHO_MAP_TBL_ENTRIES is a power of 2. */
+	KHO_MAP_TBL_MASK = KHO_MAP_TBL_ENTRIES - 1,
+
+	KHO_MAP_DEPTH = DIV_ROUND_UP(KHO_MAP_KEY_WIDTH, KHO_MAP_TBL_SHIFT),
+};
+
+/*
+ * An intermediate node of a KHO map. @table holds the physical addresses of
+ * the nodes one level below, or 0 for none, indexed by the bits of the key for
+ * this level.
+ *
+ * Not kernel-doc, since kernel-doc can't parse DECLARE_KHOSER_PTR() members.
+ */
+struct kho_map_node_ser {
+	DECLARE_KHOSER_PTR(table, struct kho_map_node_ser *)[1 << KHO_MAP_TBL_SHIFT];
+};
+
+/**
+ * struct kho_map_leaf_ser - A leaf of a KHO map.
+ * @values: Values of the entries, or 0 for no entry. Indexed by the lowest
+ *          %KHO_MAP_TBL_SHIFT bits of the key.
+ */
+struct kho_map_leaf_ser {
+	u64 values[KHO_MAP_TBL_ENTRIES];
+};
+
+/*
+ * The serialized form of a KHO map. @root holds the physical address of the
+ * root node, or 0 for an empty tree. Users embed this in their own serialized
+ * state to hand the tree over.
+ *
+ * Not kernel-doc, since kernel-doc can't parse DECLARE_KHOSER_PTR() members.
+ */
+struct kho_map_ser {
+	/* TODO: capability flag header */
+	DECLARE_KHOSER_PTR(root, struct kho_map_node_ser *);
+};
+
+#endif /* _LINUX_KHO_ABI_MAP_H */
diff --git a/include/linux/kho_map.h b/include/linux/kho_map.h
new file mode 100644
index 0000000000000..a61fb6a054341
--- /dev/null
+++ b/include/linux/kho_map.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pratyush Yadav <pratyush@kernel.org>
+ */
+
+#ifndef _LINUX_KHO_MAP_H
+#define _LINUX_KHO_MAP_H
+
+#include <linux/kho/abi/map.h>
+#include <linux/mutex_types.h>
+
+/**
+ * struct kho_map - A KHO map.
+ * @ser: The serialized form of the tree. This is what gets handed over.
+ * @preserved: The nodes of the tree are preserved with KHO. Set by
+ *             kho_map_preserve().
+ *
+ * Runtime handle of a KHO map. It is not handed over, only @ser is. This is
+ * what all the kho_map_*() functions operate on.
+ */
+struct kho_map {
+	struct kho_map_ser *ser;
+	bool preserved;
+};
+
+void kho_map_init(struct kho_map *map, struct kho_map_ser *ser);
+void kho_map_destroy(struct kho_map *map);
+int kho_map_restore(struct kho_map *map, struct kho_map_ser *ser);
+int kho_map_preserve(struct kho_map *map);
+
+int kho_map_set(struct kho_map *map, u64 key, u64 value);
+u64 kho_map_get(struct kho_map *map, u64 key);
+
+/**
+ * kho_map_clear() - Remove an entry from a KHO map.
+ * @map: The KHO map.
+ * @key: Key of the entry to remove.
+ *
+ * Same as storing 0 with kho_map_set(). Never allocates memory and can't fail.
+ * Keys that are out of range, or not present, are ignored. Nodes that become
+ * empty are freed.
+ */
+static inline void kho_map_clear(struct kho_map *map, u64 key)
+{
+	/* Storing 0 never allocates and can't fail. */
+	kho_map_set(map, key, 0);
+}
+
+u64 kho_map_next(struct kho_map *map, u64 key, u64 *value);
+
+/**
+ * kho_map_for_each_from() - Iterate over entries of a KHO map from a key.
+ * @map: The KHO map.
+ * @key: u64 variable that holds the key of the current entry.
+ * @value: u64 variable that holds the value of the current entry.
+ * @start: Key to start iterating from.
+ *
+ * Visits the entries with keys greater than or equal to @start, in increasing
+ * order of keys.
+ */
+#define kho_map_for_each_from(map, key, value, start)				\
+	for ((key) = kho_map_next(map, start, &(value)); (key) != U64_MAX;	\
+	     (key) = kho_map_next(map, (key) + 1, &(value)))
+
+/**
+ * kho_map_for_each() - Iterate over all entries of a KHO map.
+ * @map: The KHO map.
+ * @key: u64 variable that holds the key of the current entry.
+ * @value: u64 variable that holds the value of the current entry.
+ *
+ * Visits the entries in increasing order of keys.
+ */
+#define kho_map_for_each(map, key, value)					\
+	kho_map_for_each_from(map, key, value, 0)
+
+#endif /* _LINUX_KHO_MAP_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index bc679905ce3f2..95fee902f9360 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -2,7 +2,8 @@
 
 kho-y :=								\
 		kexec_handover.o				\
-		kho_block.o
+		kho_block.o						\
+		kho_map.o
 
 kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
 
diff --git a/kernel/liveupdate/kho_map.c b/kernel/liveupdate/kho_map.c
new file mode 100644
index 0000000000000..947dad2a04ddb
--- /dev/null
+++ b/kernel/liveupdate/kho_map.c
@@ -0,0 +1,514 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pratyush Yadav <pratyush@kernel.org>
+ */
+
+/**
+ * DOC: KHO map
+ *
+ * A KHO map is a sparse mapping from integer keys (at most %KHO_MAP_KEY_WIDTH
+ * wide) to non-zero u64 values, kept in memory that can be preserved with KHO.
+ *
+ * Internally it is a radix tree of fixed depth, with one page per node.
+ *
+ * A tree has two parts. ``struct kho_map_ser`` is its serialized form,
+ * which points to the root node. To hand a tree over, embed its
+ * ``struct kho_map_ser`` in the serialized payload. ``struct kho_map`` is
+ * the runtime handle of the tree. It points to the ``struct kho_map_ser``
+ * and is what all kho_map_*() functions operate on.
+ *
+ * A tree starts out unpreserved. kho_map_preserve() preserves every node of the
+ * tree with KHO. From then on, nodes are preserved as soon as they are
+ * allocated, so the tree is ready to be handed over at any point.
+ * kho_map_destroy() frees the nodes, and unpreserves them if needed. A tree is
+ * restored with kho_map_restore(), and comes out unpreserved.
+ *
+ * There is no internal locking. Callers must serialize all accesses to the map.
+ */
+
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/map.h>
+#include <linux/kho_map.h>
+
+/**
+ * kho_map_init() - Initialize an empty KHO map.
+ * @map: The KHO map.
+ * @ser: The serialized form of the tree. Can be handed over to the next kernel
+ *       once the tree is populated.
+ *
+ * Any previous contents of @ser are discarded. @ser must stay around for as
+ * long as @map is used.
+ */
+void kho_map_init(struct kho_map *map, struct kho_map_ser *ser)
+{
+	map->ser = ser;
+	map->preserved = false;
+	KHOSER_CLEAR_PTR(ser->root);
+}
+
+static unsigned int kho_map_node_idx(u64 key, unsigned int level)
+{
+	return (key >> (level * KHO_MAP_TBL_SHIFT)) & KHO_MAP_TBL_MASK;
+}
+
+static struct kho_map_node_ser *kho_map_alloc_node(struct kho_map *map)
+{
+	struct folio *folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!folio)
+		return NULL;
+
+	if (map->preserved && kho_preserve_folio(folio)) {
+		folio_put(folio);
+		return NULL;
+	}
+
+	return folio_address(folio);
+}
+
+static void kho_map_free_node(struct kho_map *map, void *node)
+{
+	struct folio *folio = virt_to_folio(node);
+
+	if (map->preserved)
+		kho_unpreserve_folio(folio);
+	folio_put(folio);
+}
+
+static int kho_map_restore_folio(void *node)
+{
+	struct folio *folio = kho_restore_folio(virt_to_phys(node));
+
+	if (!folio)
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(folio_order(folio))) {
+		folio_put(folio);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __kho_map_destroy_node(struct kho_map *map,
+				   struct kho_map_node_ser *node,
+				   unsigned int level)
+{
+	unsigned int i;
+
+	/* Level 0 nodes are leaves and hold values, not pointers. */
+	if (level == 0) {
+		kho_map_free_node(map, node);
+		return;
+	}
+
+	for (i = 0; i < KHO_MAP_TBL_ENTRIES; i++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[i]);
+
+		if (next)
+			__kho_map_destroy_node(map, next, level - 1);
+	}
+
+	kho_map_free_node(map, node);
+}
+
+/**
+ * kho_map_destroy() - Free all nodes of a KHO map.
+ * @map: The KHO map.
+ *
+ * Frees every node, leaving an empty tree behind that can be used again. If
+ * the tree is preserved, the nodes are unpreserved first.
+ *
+ * Post-KHO, this can only be called after kho_map_restore().
+ */
+void kho_map_destroy(struct kho_map *map)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(map->ser->root);
+
+	if (!root)
+		return;
+
+	__kho_map_destroy_node(map, root, KHO_MAP_DEPTH - 1);
+	KHOSER_CLEAR_PTR(map->ser->root);
+}
+
+/* Unpreserve @node and everything below it. */
+static void __kho_map_unpreserve_node(struct kho_map_node_ser *node,
+				      unsigned int level)
+{
+	unsigned int i;
+
+	/* Level 0 nodes are leaves and hold values, not pointers. */
+	for (i = 0; level && i < KHO_MAP_TBL_ENTRIES; i++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[i]);
+
+		if (next)
+			__kho_map_unpreserve_node(next, level - 1);
+	}
+
+	kho_unpreserve_folio(virt_to_folio(node));
+}
+
+/*
+ * Preserve @node and everything below it. On failure, everything that was
+ * preserved is unpreserved again.
+ */
+static int __kho_map_preserve_node(struct kho_map_node_ser *node,
+				   unsigned int level)
+{
+	unsigned int i, j;
+	int err;
+
+	err = kho_preserve_folio(virt_to_folio(node));
+	if (err)
+		return err;
+
+	/* Level 0 nodes are leaves and hold values, not pointers. */
+	if (level == 0)
+		return 0;
+
+	for (i = 0; i < KHO_MAP_TBL_ENTRIES; i++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[i]);
+
+		if (!next)
+			continue;
+
+		err = __kho_map_preserve_node(next, level - 1);
+		if (err)
+			goto err_unpreserve;
+	}
+
+	return 0;
+
+err_unpreserve:
+	/* next has already unpreserved itself, undo the entries before it. */
+	for (j = 0; j < i; j++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[j]);
+
+		if (next)
+			__kho_map_unpreserve_node(next, level - 1);
+	}
+	kho_unpreserve_folio(virt_to_folio(node));
+	return err;
+}
+
+/**
+ * kho_map_preserve() - Preserve a KHO map.
+ * @map: The KHO map.
+ *
+ * Preserves every node of the tree with KHO, and marks the tree as preserved,
+ * so that nodes allocated from now on are preserved as well. Afterwards the
+ * tree can be handed over to the next kernel at any point, by handing over its
+ * &struct kho_map_ser. Preserving a tree that is already preserved does
+ * nothing.
+ *
+ * There is no way to unpreserve the tree short of kho_map_destroy().
+ *
+ * Context: Can sleep.
+ * Return: 0 on success, -errno on failure. On failure the tree is left
+ * unpreserved.
+ */
+int kho_map_preserve(struct kho_map *map)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(map->ser->root);
+	int err;
+
+	if (map->preserved)
+		return 0;
+
+	if (root) {
+		err = __kho_map_preserve_node(root, KHO_MAP_DEPTH - 1);
+		if (err)
+			return err;
+	}
+
+	map->preserved = true;
+	return 0;
+}
+
+/*
+ * Restore @node and everything below it.
+ *
+ * On failure, everything that was restored is freed again and the caller must
+ * drop its reference to @node. Nodes that could not be restored are leaked.
+ */
+static int __kho_map_restore_node(struct kho_map *map,
+				  struct kho_map_node_ser *node,
+				  unsigned int level)
+{
+	unsigned int i, j;
+	int err;
+
+	err = kho_map_restore_folio(node);
+	if (err)
+		return err;
+
+	/* Level 0 nodes are leaves and hold values, not pointers. */
+	if (level == 0)
+		return 0;
+
+	for (i = 0; i < KHO_MAP_TBL_ENTRIES; i++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[i]);
+
+		if (!next)
+			continue;
+
+		err = __kho_map_restore_node(map, next, level - 1);
+		if (err)
+			goto err_destroy;
+	}
+
+	return 0;
+
+err_destroy:
+	/*
+	 * next has already freed itself, and the entries after it were never
+	 * restored. Cut them all off, then free what is left.
+	 */
+	for (j = i; j < KHO_MAP_TBL_ENTRIES; j++)
+		KHOSER_CLEAR_PTR(node->table[j]);
+	__kho_map_destroy_node(map, node, level);
+	return err;
+}
+
+/**
+ * kho_map_restore() - Restore KHO map.
+ * @map: The KHO map to set up.
+ * @ser: The serialized form of the tree, handed over by the previous kernel.
+ *
+ * Restores every node of the tree in @ser, and sets up @map to refer to it.
+ * Afterwards @map can be used with all other kho_map_*() functions, exactly
+ * like a tree built in this kernel. @ser must stay around for as long as @map
+ * is used.
+ *
+ * The restored tree is unpreserved, so it is not handed over to the next kernel
+ * again unless kho_map_preserve() is called on it.
+ *
+ * Return: 0 on success, or -errno on failure. On failure the tree is destroyed,
+ * and nodes that could not be restored are leaked. @map is still set up and
+ * refers to an empty tree.
+ */
+int kho_map_restore(struct kho_map *map, struct kho_map_ser *ser)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(ser->root);
+	int err;
+
+	map->ser = ser;
+	map->preserved = false;
+
+	if (!root)
+		return 0;
+
+	err = __kho_map_restore_node(map, root, KHO_MAP_DEPTH - 1);
+	if (err)
+		KHOSER_CLEAR_PTR(map->ser->root);
+
+	return err;
+}
+
+/*
+ * Free the empty nodes on the path to @key, going up from @level. @path[i] is
+ * the node at level i on the path. Stops at the first node that is not empty,
+ * since the nodes above it then aren't empty either.
+ */
+static void kho_map_prune(struct kho_map *map,
+			  struct kho_map_node_ser *path[KHO_MAP_DEPTH],
+			  u64 key, unsigned int level)
+{
+	for (unsigned int i = level; i < KHO_MAP_DEPTH; i++) {
+		if (memchr_inv(path[i], 0, PAGE_SIZE))
+			return;
+
+		/* Unlink the node before freeing it. */
+		if (i == KHO_MAP_DEPTH - 1)
+			KHOSER_CLEAR_PTR(map->ser->root);
+		else
+			KHOSER_CLEAR_PTR(path[i + 1]->table[kho_map_node_idx(key, i + 1)]);
+
+		kho_map_free_node(map, path[i]);
+	}
+}
+
+/**
+ * kho_map_set() - Store a value in a KHO map.
+ * @map: The KHO map.
+ * @key: Key of the entry. At most %KHO_MAP_KEY_WIDTH bits wide.
+ * @value: Value to store.
+ *
+ * Adds an entry, or replaces the value of an existing one.
+ *
+ * A value of 0 means the entry is not present, so storing 0 removes the entry.
+ * Removing never allocates nodes and can't fail for keys in range. Nodes that
+ * become empty are freed.
+ *
+ * Context: Can sleep when @value is not 0.
+ * Return: 0 on success, -errno on failure.
+ */
+int kho_map_set(struct kho_map *map, u64 key, u64 value)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(map->ser->root), *node;
+	struct kho_map_node_ser *path[KHO_MAP_DEPTH] = {};
+	struct kho_map_leaf_ser *leaf;
+	unsigned int i, idx;
+
+	if (unlikely(fls64(key) > KHO_MAP_KEY_WIDTH))
+		return -ERANGE;
+
+	if (!root) {
+		/* No tree, so the entry is already clear. */
+		if (!value)
+			return 0;
+
+		root = kho_map_alloc_node(map);
+		if (!root)
+			return -ENOMEM;
+
+		KHOSER_STORE_PTR(map->ser->root, root);
+	}
+
+	node = root;
+
+	for (i = KHO_MAP_DEPTH - 1; i > 0; i--) {
+		struct kho_map_node_ser *next;
+
+		path[i] = node;
+		idx = kho_map_node_idx(key, i);
+
+		next = KHOSER_LOAD_PTR(node->table[idx]);
+		/* Node already exists, go down to the next level. */
+		if (next) {
+			node = next;
+			continue;
+		}
+
+		/* No node on the path, so the entry is already clear. */
+		if (!value)
+			return 0;
+
+		next = kho_map_alloc_node(map);
+		if (!next) {
+			kho_map_prune(map, path, key, i);
+			return -ENOMEM;
+		}
+
+		KHOSER_STORE_PTR(node->table[idx], next);
+		node = next;
+	}
+
+	/* node now points to the leaf node. */
+	path[0] = node;
+	leaf = (struct kho_map_leaf_ser *)node;
+	idx = kho_map_node_idx(key, 0);
+	leaf->values[idx] = value;
+
+	/* If clearing the key made the leaf empty, prune it. */
+	if (!value)
+		kho_map_prune(map, path, key, 0);
+
+	return 0;
+}
+
+/**
+ * kho_map_get() - Look up a value in a KHO map.
+ * @map: The KHO map.
+ * @key: Key of the entry.
+ *
+ * Return: The value of the entry, or 0 if there is no entry for @key or it is
+ * out of range.
+ */
+u64 kho_map_get(struct kho_map *map, u64 key)
+{
+	struct kho_map_node_ser *node = KHOSER_LOAD_PTR(map->ser->root);
+	struct kho_map_leaf_ser *leaf;
+	unsigned int i;
+
+	if (unlikely(fls64(key) > KHO_MAP_KEY_WIDTH))
+		return 0;
+
+	for (i = KHO_MAP_DEPTH - 1; node && i > 0; i--)
+		node = KHOSER_LOAD_PTR(node->table[kho_map_node_idx(key, i)]);
+
+	if (!node)
+		return 0;
+
+	leaf = (struct kho_map_leaf_ser *)node;
+	return leaf->values[kho_map_node_idx(key, 0)];
+}
+
+static u64 __kho_map_next_leaf(struct kho_map_leaf_ser *leaf, u64 key, u64 *value)
+{
+	unsigned int i, idx;
+
+	idx = kho_map_node_idx(key, 0);
+
+	for (i = idx; i < KHO_MAP_TBL_ENTRIES; i++) {
+		if (!leaf->values[i])
+			continue;
+
+		key = (key & ~KHO_MAP_TBL_MASK) | i;
+		*value = leaf->values[i];
+		return key;
+	}
+
+	return U64_MAX;
+}
+
+static u64 __kho_map_next_node(struct kho_map_node_ser *node, u64 key, u64 *value,
+			       unsigned int level)
+{
+	/* Number of keys covered by a single entry at this level. */
+	u64 span = 1UL << (level * KHO_MAP_TBL_SHIFT);
+	unsigned int i;
+	u64 found;
+
+	/*
+	 * The first entry is searched starting from key. Every following
+	 * entry is searched from the first key of the subnode.
+	 */
+	for (i = kho_map_node_idx(key, level); i < KHO_MAP_TBL_ENTRIES;
+	     i++, key = round_down(key, span) + span) {
+		struct kho_map_node_ser *next;
+
+		next = KHOSER_LOAD_PTR(node->table[i]);
+		if (!next)
+			continue;
+
+		if (level == 1)
+			found = __kho_map_next_leaf((struct kho_map_leaf_ser *)next, key, value);
+		else
+			found = __kho_map_next_node(next, key, value, level - 1);
+
+		if (found != U64_MAX)
+			return found;
+	}
+
+	return U64_MAX;
+}
+
+/**
+ * kho_map_next() - Find the next entry in a KHO map.
+ * @map: The KHO map.
+ * @key: Key to start searching from.
+ * @value: Set to the value of the entry found. Left alone if none is found.
+ *
+ * Finds the entry with the smallest key that is greater than or equal to @key.
+ *
+ * Return: The key of the entry found, or %U64_MAX if there is none. %U64_MAX
+ * is never a valid key, since it is wider than %KHO_MAP_KEY_WIDTH.
+ */
+u64 kho_map_next(struct kho_map *map, u64 key, u64 *value)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(map->ser->root);
+
+	if (unlikely(!root))
+		return U64_MAX;
+
+	if (unlikely(fls64(key) > KHO_MAP_KEY_WIDTH))
+		return U64_MAX;
+
+	return __kho_map_next_node(root, key, value, KHO_MAP_DEPTH - 1);
+}
-- 
2.56.0.611.g1030f0b940-goog


