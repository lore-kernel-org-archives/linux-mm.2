Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3CDCD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C16F6B04BD; Mon,  1 Jun 2026 23:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F516B04C3; Mon,  1 Jun 2026 23:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339C46B04BD; Mon,  1 Jun 2026 23:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06DC46B04BD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3704A07E9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:31 +0000 (UTC)
X-FDA: 84833512302.15.0212852
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1DF716000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I2XnleQ5;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370249;
	b=xkOdNY94eSOpsn6UWAfB4b8GwSscN8fsKQoYXwuOPTK7dq/oyVcdqfyLetbd94FhJjWZ1q
	3c6mV3NuY1ZVhDCInvUMjMk1iz+Bvtm9pZURtaWyz9zMafJax84Kdq7l3bOFMs4PlrJNGQ
	ybSW2XnQ3kuKmZ6qZAKCp15UGBcgArM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I2XnleQ5;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYtHtE3IYORaL8afiuLPXAkdFo8+/KWc7V9lbELdbJ8=;
	b=6C5+tJPuKizvjhjGQxknz+tKJ99aqFkvyzmtsdAy5VOh7D1LaV26PLZcRdtBaZrQr+C/5A
	fXnKB1IvPZhTGpUP9asOpcvj1uB6DOo3MSGIzrV+4Fl8rfoDDFbH1K+pLTzu29FNKd98Ak
	aIe2zJ9cBg5woZfMnvfItn3WUww6LeI=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51749ff0a97so17964601cf.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370249; x=1780975049; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYtHtE3IYORaL8afiuLPXAkdFo8+/KWc7V9lbELdbJ8=;
        b=I2XnleQ5qfFd9Eb0NnsTwcFvmfsvsI0a9ZCj0+BykuLP3y8gqMi6pX0gmCRCND7C3H
         laN5au2o5sElV96PW6tlD1SCGWNF7HUiNzd2EITw01F4foi5EbBXRB/98sljcg5vz6UJ
         MyB+oAgHSdjUUZRXxnVqAM2X9dWdOVsOL6iu6ErZEQWkWSTnIYhfYY1FWVAS3YgsJ7MQ
         IeUfRCjEKUc21NMWXDty+C1/4GKUF9VBQ8KYoe93mlEJljHlgQoUpApznieESN7lABmK
         HB+LF7+ToBOpyL2XHbxxbYvxkxqTMLyPLQ2a/5B+gdCKQAGJeqXiOOk1FpnyfsQ556iM
         m9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370249; x=1780975049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XYtHtE3IYORaL8afiuLPXAkdFo8+/KWc7V9lbELdbJ8=;
        b=Ia5gUFtsGz3NoOB4+QbuWmzH2Il/q0+Sk0iTIT/L+bhAP4eWEcu9zUbDLbWHmdiMjR
         GIf32Tft8F1yikwoQ/w9oWmQouVBqqMcD/OJ+4wrXHYMCSYiV7Fk8+y/ZD4xA1PubAGA
         LyYuq/DtevHvzZbGc0NqiVTiMUGg83yCtmzRqqi3DpktAOIWh5evlKmWpWeKIx2+KrDa
         oawgqj5PQE2sFdAD7RvAUoiYZl7UYPzf16NP31YvQdT8P+7DfVM8H3ovpR01lhMl3xAR
         jo+ZibtvliBVug5CKr69Z60+tFPiInxJT98yMOloBJOkN4EbbWuMaj9PljQ3si8XWyBT
         wDOg==
X-Forwarded-Encrypted: i=1; AFNElJ/4m9+r0aF/gpv7o3J1JypEkjuFA132Z81Mismtmc/gJbO/QDUp7suhH53PfwhAEP59iAyopOuVJg==@kvack.org
X-Gm-Message-State: AOJu0YyImHO9XOVyijJSV5VyW0C5/BiPfK6ZRl/aNL0s1pFeZPmAPn8j
	sSKZKQfeqVqAl3dPmXPl1ScbK/du3J3cMeVcVgauMKpoEgCYQVXxdIW+P8XwOYQAAvnvqSEut8w
	i6Pi3
X-Gm-Gg: Acq92OErYyOLD2l2scg5c/YpGM2eCf+rhnMpXi8fRA/KoWR1ZZl5ZpjgqveSzYCvuwx
	LvjduOXI5D+wo1fpY0bnYm0pe4bZQGTNFZUpVd4VlcN6pYadfP/XNKQAsGpIkKx31yv2pz1gopf
	9YNkSco+NFvZnS+8MFN4mcptgAzZs+LUPfQ/7R/SBw/933my3tWjgZGdb8po1S7jVrtXA0Csr96
	9jLvSCfAYYPpy0YbGNlXUV0jT1nc5mLHChqKTfqIwbzHV77g59t8bQf7NE+VfgnlXk3k742uwgE
	/XlKowKfWvEx9pwyefIY22QL55LSyOIOzrSBu2XZWRBJBaNuEKRcJsInPkG980Wl/o/S7ohWED1
	3NLeeCLcEbxoXdM8SYNtELk1DUe21Sml0oNPOWSc3q71nohqht/pq7eMFz9tFThCQg54CAtKD0V
	fCWhPDHUsZBbvxZBy4+yeG9bBmYTsMr79Djg/hzehXKiI8RGafDFqS82FKUo6y5g==
X-Received: by 2002:a05:622a:5917:b0:517:5a80:18f3 with SMTP id d75a77b69052e-5175a8047f6mr75712401cf.1.1780370248725;
        Mon, 01 Jun 2026 20:17:28 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:28 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v5 07/13] kho: add support for linked-block serialization
Date: Tue,  2 Jun 2026 03:17:11 +0000
Message-ID: <20260602031717.197696-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1DF716000C
X-Rspam-User: 
X-Stat-Signature: 7b9y859u1knyb6f1gpdyjiixhergt56h
X-HE-Tag: 1780370249-351722
X-HE-Meta: U2FsdGVkX1+skWs4JUM/G26loxm0W9D6MNnLIfgI9woVXajvKX1zSDFjFbl4HpGzFHKPMNhVxKhHGocBNw2VhT0iy0+ZkgQHhhOgrqvczcawQiZQmvdjIrKdopFZMAMfLX++TFFPfl5MOFpYZOEM6hv8jQw8YJ1E7Rk3VR6X6sVikgcs98D9XzLm+ZfNg1Z8sqNkOzxHYUb/ptaLyK+BlaiMx4c/x5nEtYldSxK1An7aFzOQQhOtNtdeWj+m6NXCMHcH+5+X4cim36+pU9cTgqu2Vd+iKPdVNllRo8gTvCj/slUf/imOQk1vdzey0xD0SpAUcPnCel/rgNjktIKirN2UjAglfgic6s2MFDVGQrKVtwdVlnzr4nNFvBibhZm8WbB2yQjpu2cAyL+8wy/UCbBF3zlbnhUIDfWnZ1lBQbdQ3RQiwirfHIpuVu8yCJDmrpuPlWO3IM2nK1vrP3JH2b9n5W5xmOIvW9x7lHhdn8oBpdUu+PMcEsQiB+BtcOSxEly53C9/sEL/03XaNGUnHPbq5amxV+5NVhr9Dgp96MMQvKGxNZs6Nwv1U8JB0ohBhSfXCz5p7UUxNLwEv9a4YipAm9vOSy+By+O3/0n8eFL6gIeEZOSf+jteGlXyAMQbK5Y8rmEkl0+FgOyfzOIKOTNPsZnyiTXKNwPOxvKe6TQzsFxAFKf/n2o4jL+jF05hR0OIdakAkzb5gND+s8STQapWitjxzazEmS0EhqoUd9WKyh+cJdmhszL1irTAW2t1dEXtrPeogpQcc4dxiLSlp/qc0ikyv4kdXhE8p5nSHVjj82E4EG5qYgzWNiSEpnrHa5Ly2ERhxkYF0dqajWLXh7OKhi4Uj3lsCAgGFBFY3+7PPHJW0X8wIoB8SeR5bCTr1Uicuw/gSs8c40CC4b3AsoWjb1An7JQ5fqfZ93OGc6QHO+WPmScoaWpw724Rn8evx6MbG8jxbdtN3SHBuX+
 C4oIQN0L
 3tOwaydalx1B7K/3j/pimvZhgShQdsijJM7nxCv/4ZFdJTNXS+YKNqswnETgi/4MUs+GFOG3KvOKUb8a2ZaBfoPeiTCI96s8SOFT+2dQabEDmT5X3EjaRrxBQVn0mmeP46ZmsDydLTHCGYTRMphit9ampnpw5gA9LnKhVCy8SwvqrepYATXjZxhvxpq5Du9Penuty/nxkKbAmkGhrM0iSMnyfx9V3bJQdCQljofgYIVD61MgpHl9efU5oGMStZCnmKDnePbkCn4nhu/r3ZZZqADbnTcYhv34QEdr0S5s5HznTUt2taXJ9CwTuqPWQWo21x+N3j5WKHzXYo5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a linked-block serialization mechanism for state handover.

Previously, LUO used contiguous memory blocks for serializing sessions
and files, which imposed limits on the total number of items that could
be preserved across a live update.

This commit adds the infrastructure for a more flexible, block-based
approach where serialized data is stored in a chain of linked blocks.
This is a generic KHO serialization block infrastructure that can be
used by multiple subsystems.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/abi.rst   |   5 +
 Documentation/core-api/kho/index.rst |  11 +
 MAINTAINERS                          |   1 +
 include/linux/kho/abi/block.h        |  56 ++++
 include/linux/kho_block.h            |  79 ++++++
 kernel/liveupdate/Makefile           |   1 +
 kernel/liveupdate/kho_block.c        | 390 +++++++++++++++++++++++++++
 7 files changed, 543 insertions(+)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index 799d743105a6..edeb5b311963 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -28,6 +28,11 @@ KHO persistent memory tracker ABI
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
   :doc: KHO persistent memory tracker
 
+KHO serialization block ABI
+===========================
+
+.. kernel-doc:: include/linux/kho/abi/block.h
+
 See Also
 ========
 
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 0a2dee4f8e7d..320914a42178 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -83,6 +83,17 @@ Public API
 .. kernel-doc:: kernel/liveupdate/kexec_handover.c
   :export:
 
+KHO Serialization Blocks API
+============================
+
+.. kernel-doc:: kernel/liveupdate/kho_block.c
+  :doc: KHO Serialization Blocks
+
+.. kernel-doc:: include/linux/kho_block.h
+
+.. kernel-doc:: kernel/liveupdate/kho_block.c
+  :internal:
+
 See Also
 ========
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 9ec290e38b44..920ba7622afa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14208,6 +14208,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
+F:	include/linux/kho_block.h
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
new file mode 100644
index 000000000000..8641c20b379b
--- /dev/null
+++ b/include/linux/kho/abi/block.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: KHO Serialization Blocks ABI
+ *
+ * Subsystems using the KHO Serialization Blocks framework rely on the stable
+ * Application Binary Interface defined below to pass serialized state from a
+ * pre-update kernel to a post-update kernel.
+ *
+ * This interface is a contract. Any modification to the structure fields,
+ * compatible strings, or the layout of the `__packed` serialization
+ * structures defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the `KHO_BLOCK_ABI_COMPATIBLE` string to
+ * prevent a new kernel from misinterpreting data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is incremented;
+ * however, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
+ */
+
+#ifndef _LINUX_KHO_ABI_BLOCK_H
+#define _LINUX_KHO_ABI_BLOCK_H
+
+#include <asm/page.h>
+#include <linux/types.h>
+
+#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
+
+/**
+ * KHO_BLOCK_SIZE - The size of each serialization block.
+ *
+ * This is defined as PAGE_SIZE. PAGE_SIZE is ABI compliant because live
+ * update between kernels with different page sizes is not supported by KHO.
+ */
+#define KHO_BLOCK_SIZE			PAGE_SIZE
+
+/**
+ * struct kho_block_header_ser - Header for the serialized data block.
+ * @next:  Physical address of the next struct kho_block_header_ser.
+ * @count: The number of entries that immediately follow this header in the
+ *         memory block.
+ *
+ * This structure is located at the beginning of a block of physical memory
+ * preserved across a kexec. It provides the necessary metadata to interpret
+ * the array of entries that follow.
+ */
+struct kho_block_header_ser {
+	u64 next;
+	u64 count;
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_BLOCK_H */
diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
new file mode 100644
index 000000000000..505bf78409f2
--- /dev/null
+++ b/include/linux/kho_block.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_KHO_BLOCK_H
+#define _LINUX_KHO_BLOCK_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/kho/abi/block.h>
+
+/**
+ * struct kho_block - Internal representation of a serialization block.
+ * @list: List head for linking blocks in memory.
+ * @ser:  Pointer to the serialized header in preserved memory.
+ */
+struct kho_block {
+	struct list_head list;
+	struct kho_block_header_ser *ser;
+};
+
+/**
+ * struct kho_block_set - A set of blocks that belong to the same object.
+ * @blocks:          The list of serialization blocks (struct kho_block).
+ * @nblocks:         The number of allocated serialization blocks.
+ * @head_pa:         Physical address of the first block header.
+ * @entry_size:      The size of each entry in the blocks.
+ * @count_per_block: The maximum number of entries each block can hold.
+ * @incoming:        True if this block set was restored from the previous kernel.
+ */
+struct kho_block_set {
+	struct list_head blocks;
+	long nblocks;
+	u64 head_pa;
+	size_t entry_size;
+	u64 count_per_block;
+	bool incoming;
+};
+
+/**
+ * struct kho_block_it - Iterator for serializing entries into blocks.
+ * @bs:         The block set being iterated.
+ * @block:      The current block.
+ * @i:          The current entry index within @block.
+ */
+struct kho_block_it {
+	struct kho_block_set *bs;
+	struct kho_block *block;
+	u64 i;
+};
+
+/**
+ * KHO_BLOCK_SET_INIT - Initialize a static kho_block_set.
+ * @_name:       Name of the kho_block_set variable.
+ * @_entry_size: The size of each entry in the block set.
+ */
+#define KHO_BLOCK_SET_INIT(_name, _entry_size) {                        \
+	.blocks = LIST_HEAD_INIT((_name).blocks),                       \
+	.entry_size = _entry_size,                                      \
+}
+
+void kho_block_set_init(struct kho_block_set *bs, size_t entry_size);
+
+int kho_block_grow(struct kho_block_set *bs, u64 count);
+void kho_block_shrink(struct kho_block_set *bs, u64 count);
+
+int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa);
+void kho_block_set_destroy(struct kho_block_set *bs);
+void kho_block_set_clear(struct kho_block_set *bs);
+
+void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
+void *kho_block_it_reserve_entry(struct kho_block_it *it);
+void *kho_block_it_read_entry(struct kho_block_it *it);
+void *kho_block_it_prev(struct kho_block_it *it);
+void kho_block_it_finalize(struct kho_block_it *it);
+
+#endif /* _LINUX_KHO_BLOCK_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d2f779cbe279..eec9d3ae07eb 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 luo-y :=								\
+		kho_block.o						\
 		luo_core.o						\
 		luo_file.o						\
 		luo_flb.o						\
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
new file mode 100644
index 000000000000..01978c6aea1a
--- /dev/null
+++ b/kernel/liveupdate/kho_block.c
@@ -0,0 +1,390 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: KHO Serialization Blocks
+ *
+ * KHO provides a mechanism to preserve stateful data across a kexec handover
+ * by serializing it into memory blocks. This file provides the common
+ * infrastructure for managing these blocks.
+ *
+ * Each block consists of a header (struct kho_block_header_ser) followed by an
+ * array of serialized entries. Multiple blocks are linked together via a
+ * physical pointer in the header, forming a linked list that can be easily
+ * traversed in both the current and the next kernel.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/block.h>
+#include <linux/kho_block.h>
+#include <linux/slab.h>
+
+/*
+ * Safeguard limit for the number of serialization blocks. This is used to
+ * prevent infinite loops and excessive memory allocation in case of memory
+ * corruption in the preserved state.
+ */
+#define KHO_MAX_BLOCKS 10000
+
+/**
+ * kho_block_set_init - Initialize a block set.
+ * @bs:         The block set to initialize.
+ * @entry_size: The size of each entry in the blocks.
+ */
+void kho_block_set_init(struct kho_block_set *bs, size_t entry_size)
+{
+	*bs = (struct kho_block_set)KHO_BLOCK_SET_INIT(*bs, entry_size);
+}
+
+static inline u64 kho_block_count_per_block(struct kho_block_set *bs)
+{
+	if (unlikely(!bs->count_per_block)) {
+		bs->count_per_block = (KHO_BLOCK_SIZE -
+				       sizeof(struct kho_block_header_ser)) /
+				      bs->entry_size;
+		WARN_ON_ONCE(!bs->count_per_block);
+	}
+	return bs->count_per_block;
+}
+
+/* Free serialized data */
+static void kho_block_free_ser(struct kho_block_set *bs,
+			       struct kho_block_header_ser *ser)
+{
+	if (bs->incoming)
+		kho_restore_free(ser);
+	else
+		kho_unpreserve_free(ser);
+}
+
+static struct kho_block_header_ser *kho_block_alloc_ser(struct kho_block_set *bs)
+{
+	WARN_ON_ONCE(bs->incoming);
+	return kho_alloc_preserve(KHO_BLOCK_SIZE);
+}
+
+static int kho_block_add(struct kho_block_set *bs,
+			 struct kho_block_header_ser *ser)
+{
+	struct kho_block *block, *last;
+
+	if (bs->nblocks >= KHO_MAX_BLOCKS)
+		return -ENOSPC;
+
+	block = kzalloc_obj(*block);
+	if (!block)
+		return -ENOMEM;
+
+	block->ser = ser;
+	last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
+	list_add_tail(&block->list, &bs->blocks);
+	bs->nblocks++;
+
+	if (last)
+		last->ser->next = virt_to_phys(ser);
+	else
+		bs->head_pa = virt_to_phys(ser);
+
+	return 0;
+}
+
+/**
+ * kho_block_grow - Create a new block if the current capacity is reached.
+ * @bs:    The block set.
+ * @count: The current number of entries.
+ *
+ * This function handles the dynamic expansion of a block set. It allocates
+ * and links a new serialization block if the provided entry count matches
+ * the current total capacity of the set.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_block_grow(struct kho_block_set *bs, u64 count)
+{
+	struct kho_block_header_ser *ser;
+	int err;
+
+	if (WARN_ON_ONCE(bs->incoming))
+		return -EINVAL;
+
+	if (count != bs->nblocks * kho_block_count_per_block(bs))
+		return 0;
+
+	ser = kho_block_alloc_ser(bs);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	err = kho_block_add(bs, ser);
+	if (err) {
+		kho_block_free_ser(bs, ser);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * kho_block_shrink - Conditionally destroy the last block in a block set.
+ * @bs:              The block set.
+ * @count:           The current number of entries across all blocks.
+ *
+ * This function checks if the last block in the set is redundant based on the
+ * total entry count and the capacity of the preceding blocks. If the entry
+ * count can be accommodated by the blocks that come before the last one, the
+ * last block is destroyed and removed from the set.
+ */
+void kho_block_shrink(struct kho_block_set *bs, u64 count)
+{
+	struct kho_block *last, *new_last;
+
+	if (count > (bs->nblocks - 1) * kho_block_count_per_block(bs))
+		return;
+
+	if (list_empty(&bs->blocks))
+		return;
+
+	last = list_last_entry(&bs->blocks, struct kho_block, list);
+	list_del(&last->list);
+	bs->nblocks--;
+	kho_block_free_ser(bs, last->ser);
+	kfree(last);
+
+	new_last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
+	if (new_last)
+		new_last->ser->next = 0;
+	else
+		bs->head_pa = 0;
+}
+
+/*
+ * kho_cyclic_blocks_check - Check for cycles in a linked list of blocks.
+ * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
+ */
+static bool kho_cyclic_blocks_check(struct kho_block_set *bs)
+{
+	struct kho_block_header_ser *fast;
+	struct kho_block_header_ser *slow;
+	int count = 0;
+
+	fast = phys_to_virt(bs->head_pa);
+	slow = fast;
+
+	while (fast) {
+		if (count++ >= KHO_MAX_BLOCKS) {
+			pr_err("Linked list too long\n");
+			return false;
+		}
+
+		if (!fast->next)
+			break;
+
+		fast = phys_to_virt(fast->next);
+		if (!fast->next)
+			break;
+
+		fast = phys_to_virt(fast->next);
+		slow = phys_to_virt(slow->next);
+
+		if (slow == fast) {
+			pr_err("Cyclic list detected\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/**
+ * kho_block_set_restore - Restore a block set from a physical address.
+ * @bs:      The block set to restore.
+ * @head_pa: Physical address of the first block header.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
+{
+	struct kho_block_header_ser *ser;
+	u64 next_pa = head_pa;
+	int err;
+
+	/* Restored block sets use size from the previous kernel */
+	bs->incoming = true;
+	if (!head_pa)
+		return 0;
+
+	bs->head_pa = head_pa;
+	if (!kho_cyclic_blocks_check(bs)) {
+		bs->head_pa = 0;
+		return -EINVAL;
+	}
+
+	while (next_pa) {
+		ser = phys_to_virt(next_pa);
+		if (!ser->count || ser->count > kho_block_count_per_block(bs)) {
+			pr_warn("Block contains invalid entry count: %llu\n",
+				ser->count);
+			err = -EINVAL;
+			goto err_destroy;
+		}
+		err = kho_block_add(bs, ser);
+		if (err)
+			goto err_destroy;
+		next_pa = ser->next;
+	}
+
+	return 0;
+
+err_destroy:
+	kho_block_set_destroy(bs);
+	return err;
+}
+
+/**
+ * kho_block_set_destroy - Destroy all blocks in a block set.
+ * @bs:          The block set.
+ */
+void kho_block_set_destroy(struct kho_block_set *bs)
+{
+	struct kho_block *block, *tmp;
+	u64 head_pa = bs->head_pa;
+
+	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
+		list_del(&block->list);
+		kfree(block);
+	}
+	bs->nblocks = 0;
+	bs->head_pa = 0;
+
+	/*
+	 * bs->blocks may only contain partially restored blocks, but head_pa
+	 * still points to the entire chain.
+	 */
+	while (head_pa) {
+		struct kho_block_header_ser *ser = phys_to_virt(head_pa);
+
+		head_pa = ser->next;
+		kho_block_free_ser(bs, ser);
+	}
+}
+
+/**
+ * kho_block_set_clear - Clear all serialized data in a block set.
+ * @bs: The block set to clear.
+ */
+void kho_block_set_clear(struct kho_block_set *bs)
+{
+	struct kho_block *block;
+
+	list_for_each_entry(block, &bs->blocks, list) {
+		block->ser->count = 0;
+		memset(block->ser + 1, 0, KHO_BLOCK_SIZE - sizeof(*block->ser));
+	}
+}
+
+/**
+ * kho_block_it_init - Initialize a block set iterator.
+ * @it:         The iterator to initialize.
+ * @bs:         The block set to iterate over.
+ */
+void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs)
+{
+	it->bs = bs;
+	it->block = list_first_entry_or_null(&bs->blocks, struct kho_block, list);
+	it->i = 0;
+}
+
+/**
+ * kho_block_it_reserve_entry - Reserve and return the next available slot for writing.
+ * @it: The block iterator.
+ *
+ * This function is used during state serialization to add a new entry.
+ * It reserves a slot in the current block, advancing the internal index.
+ * If the current block is full, it automatically moves to the next block
+ * in the set.
+ *
+ * Return: A pointer to the reserved entry slot, or NULL if the block set's
+ * capacity is fully exhausted.
+ */
+void *kho_block_it_reserve_entry(struct kho_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == kho_block_count_per_block(it->bs)) {
+		it->block->ser->count = it->i;
+		if (list_is_last(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_next_entry(it->block, list);
+		it->i = 0;
+	}
+
+	return (void *)(it->block->ser + 1) + (it->i++ * it->bs->entry_size);
+}
+
+/**
+ * kho_block_it_read_entry - Read the next serialized entry from the block set.
+ * @it: The block iterator.
+ *
+ * This function is used during state deserialization. It iterates through
+ * entries that were previously written, respecting the actual count stored
+ * in each block's header.
+ *
+ * Return: A pointer to the next serialized entry, or NULL if all serialized
+ * entries have been read.
+ */
+void *kho_block_it_read_entry(struct kho_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == it->block->ser->count) {
+		if (list_is_last(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_next_entry(it->block, list);
+		it->i = 0;
+	}
+
+	return (void *)(it->block->ser + 1) + (it->i++ * it->bs->entry_size);
+}
+
+/**
+ * kho_block_it_prev - Return the previous entry slot in the block set.
+ * @it: The block iterator.
+ *
+ * If the current index is at the start of a block, it automatically moves to
+ * the end of the previous block.
+ *
+ * Return: A pointer to the previous entry slot, or NULL if at the very
+ * beginning of the block set.
+ */
+void *kho_block_it_prev(struct kho_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == 0) {
+		if (list_is_first(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_prev_entry(it->block, list);
+		it->i = kho_block_count_per_block(it->bs);
+	}
+
+	return (void *)(it->block->ser + 1) + (--it->i * it->bs->entry_size);
+}
+
+/**
+ * kho_block_it_finalize - Finalize the current block by setting its entry count.
+ * @it: The block iterator.
+ */
+void kho_block_it_finalize(struct kho_block_it *it)
+{
+	if (it->block)
+		it->block->ser->count = it->i;
+}
-- 
2.53.0


