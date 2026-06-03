Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4EACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4433A6B0099; Tue,  2 Jun 2026 23:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4536B009B; Tue,  2 Jun 2026 23:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245896B009D; Tue,  2 Jun 2026 23:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11CA06B0099
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE0F11615B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:19 +0000 (UTC)
X-FDA: 84837170838.04.E860C18
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id EA9DF120002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BTxugS0e;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+goXyLuH/FqZHKbCrnKG3Jp0DPoER679XEYr9/CPoc=;
	b=XK65LA+RAhLwOy7EvrI1fSIOxCASBU+jvgmgYZYd9QQdnJwIb+8ajcQsPSAvwQcqUQu/qE
	z4R4E6Un87ozsRqdo+DFo/FinQfXAvO+Qe4oAn9FMxjsn2giM0++6vgu8nsLi/c/rWNM7g
	4dPU9ayRCumZQm4DpBWDqKier9Yax2A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BTxugS0e;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457358;
	b=sg6OCDfb8ESph6C4nqmRrsvGSSnEv3bHIFhdJ49Ib8GSSgyTY22ZpCgKnENflgQKGXZED3
	ndGHwrAH5er2iur2hq8vU3TKfWk5k0h9FxdRlkfv39PPz3MdaD1HUIc9CwKz7joK3B8VBT
	kH51UgcPl8qIB6eE+xiA+XN+oCC1XU8=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ce3876a50cso35156246d6.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457357; x=1781062157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+goXyLuH/FqZHKbCrnKG3Jp0DPoER679XEYr9/CPoc=;
        b=BTxugS0eNKgW+pk2hRyDkJVZaxKuKE7RvBCvH9e78tXhD7u8ArcbiaLnKhluqPcTtV
         4DuiUODgXQjKA364Q0yY+1Cnx+R+tf/VvqkTgyS3C8RyjbpJ21Q3+gO/nDFeCItpYd4v
         XHf1csl8oPSmvMwnbfCiven5Pgw5SjSxYF6t4JCL9MB9ph2ELQs0IU8fsUdati8o8kZJ
         rL6IOjE9gr52Y54pgrAVJWS0sYz6q0HB7Z514koKQkwNT7ApSIiNSu1HoKJUNJWS1M8K
         lZTdbMQV539ugU3seefqK6Rmn3ivrWAxkDH0oHmH8lY8CpBitwb5FYEwpZ77bly4tdcU
         u7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457357; x=1781062157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/+goXyLuH/FqZHKbCrnKG3Jp0DPoER679XEYr9/CPoc=;
        b=ejvC2u7p6B/ZQetuzwmwJqPmyHfseM+KtlEpYKEfncrPfRtZAAy1bYmVu0/ezsulFl
         CdxYmeUoibND0rZ+tby4Z2wj2alne+shYSnju0uLrVcRaRY3Dks0GNefGdIDWr/AG1SQ
         eP90+6f0domaea1huE+7FqLZSOvmVI8HBQL/XXnYHEMMfSPsvM8EHqMs3A+Ve1x3GAqV
         /GWM2V0KJtjYqKgLZkckouHJhwk4Y6A/wkNVcdMfh9vYh/tQ60gWcndD9eoN3pg66lqN
         qfuR4mDl+t5ylUsKsl96vG6XFAw8vSjDy83b0Usv+3fotke+iVpVXi2fiYBdOlKcqXch
         nArw==
X-Forwarded-Encrypted: i=1; AFNElJ9zC/NhMdGCaPiK4/FT/XzGVJdCXXRbygLuovh86zV0ZaCAglYbqrR3/jbT0AHfydZ2JtUR5Tc4/g==@kvack.org
X-Gm-Message-State: AOJu0YyQOc3QFoEbutpD1evnzvmuqxWwyDVUZmlAAgRQi0R2KqW/FM2y
	GWVroUrjNupvnmqh3RyozDEEKSXbqycLzz3fCBxqTM6kek08E26NyUu/fTOibGjaSME=
X-Gm-Gg: Acq92OGTEKO0FGQWzw/IeQ9FIVIqH+Ux9K9XA2thf4V6ZWhBVWZ8RLeWF3TDvf0sBwd
	UB1vF61ZR7ROQ2z4KP5s2hX3LmwlPmaHx8J1qo9bF9DCKNct51hOWg9RzSC07QWjGhiq0Jzm1so
	v4liCoaE1fVTcP00SKB5O278SSggZiFKjav5ljtnnG8kW1EVOVp8rP52kuTQr7oG90gGikhavX+
	Qd4T+wNQeh3nTEBjXG49nN+i0IoXfqEfrsSExqFNGw+rC18hABLsTf3XZl+l5Qaj43uhVkgqlTD
	98OhynB+DHOC0zAtSCJSU5rdXNvzuF2sBwGEIY8zInOJlc50eLn4HRoGodhfcdfMF8ju3DZi4JT
	DM7W7IDLneYIjbujqi29Gm584gnoErab7LP8I/NJj3AQ1cqqN+/Ium7rLYGqTkH6cUC0OS5niBP
	/Ugn2Zn6HotwH4koW3SDtcCTejt50ziErywTSyC+fQPYW0yQmC35ECPZ4xH4/VNA==
X-Received: by 2002:a05:6214:5708:b0:8cc:ed49:bdd0 with SMTP id 6a1803df08f44-8cecdcd11c4mr25000596d6.22.1780457356873;
        Tue, 02 Jun 2026 20:29:16 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:16 -0700 (PDT)
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
Subject: [PATCH v6 07/13] kho: add support for linked-block serialization
Date: Wed,  3 Jun 2026 03:28:58 +0000
Message-ID: <20260603032905.344462-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA9DF120002
X-Stat-Signature: ndtxipct7ujzqpzm9qc6bmjyknrwn8dx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780457357-400366
X-HE-Meta: U2FsdGVkX182x5DkFtNpylNCbrk046rmCqEEEiRwtWwnD5G/9E2qIckpg7h1znvc3cpAAFfYpg7VGhDG1AzCrNAnjgvBVjSovuuB4Jok3zZfIbrKcLvBSx6e68dVycddQoYV1ZVVWKRG7ov7nEEUA0alWXSOEYv97diot9l8hjrG7G9WIOhY+LJGmQMtmbA6raJaooyyKmY3aoEbpJx64UgFzsOIs8Hp3k06Mq1GhqHuKv5ZVrd4Ux5kKdFc5yK0E0dqTFxAuHgaGO97wIh5RubESW46CBl27d89RkkrYbEpcEIoec/JVvinvWkSteRiBgxXCOYrww11VnMYYI13NLR2oTf0rEXfhPsSIsK2MenOBj/3Hq1aeuaV0h20yx7G7+Y6S9ndaK0DYHMXWcZ79dcQGTb7hlEoYx0C5vkM/ou79ebwftvaSGkepIbeRD2MaOy2xEX+bZKK0UlFMYdARQkm2XZbHrSVZhExeNA0JZnuAnkG+4e4foqmdHy4cbOB8klctyo4eeYbWnFvzFzjWK23YVSPXUNmT+UqrTD1MenHR5bi/fqnP23oe0zvaSe+QZl/1ZR1v+c8WhhS4uYdLNd5PgLVSa2gokcx7Zsu/S7zasM3qn9MrkfM/IEPYu0QKzvE3BsK74eTYwG1kS7MUsTT6ltZ1RTjnv8eaLYF1GxClYnVeRk5A7gkSuXi0eQEg1B9I3NVeREQOeiNwJkHKyqqhsFvTK8Jyvb9vpN2LnndBtS7yqarhoJI8W9g/kHx3pZEJR1G/Z4E7Qf9KnXa+e03C5hzfAmqaGiE0hI9dASh88fozS8iehZAj3vX89KqLXhymv3LfOiGAzwkyL6595FLAlbDxL/qSTr21az1M74Vaf2Atk/tQl2f8j5HLqOK87XBQEI+mkAp3StyAUvoqHE4VvjvC1o81neHxjSfwqcxTejDrRYM5cxg8sHjOqksCfdM24DMk5c/K+JguVE
 lMwl34wO
 tWAionMeuZ99L3bqCp8OPX6gMjSV3uHeB5MtgqvPRScdMUthOJsH0DuUIMX5RreRiIeZtHfz/Ga+3ux1RizDdXUJ9CgDGljZmvBczt0xqXZrci6dSDfsQUKVxyhVP/nbrRnseOvnAaF7RD3qD/+ZhQHJY6FN/VQXyNDLtu9ExON8TobEMRY+fVUnt4RHAGhjRG/jzRhQPXsDLtLZjr5ZLCKdAPePmTby3Aq8S3eTrPvZmMhTXrDGvXMpSB4ewRl97Ccoxf3AjLkmwGyFwR394oWNRCEdSZd/2xC/52xe4ZPwnm23SjMQIpE0oVq+hhXxbW2GFZ+z5fdXeyizi3wsPdv9SQ9KVITiSOdV3aUNMPX7NWoQnJTQt/63WMoseheUNm06LLONk2flMT+XssOLHP2uZDQdrGc3OWZmf
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
 include/linux/kho_block.h            | 106 +++++++
 kernel/liveupdate/Makefile           |   1 +
 kernel/liveupdate/kho_block.c        | 411 +++++++++++++++++++++++++++
 7 files changed, 591 insertions(+)
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
index 000000000000..93a7cc2be5f5
--- /dev/null
+++ b/include/linux/kho_block.h
@@ -0,0 +1,106 @@
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
+ * struct kho_block_set - A set of blocks containing serialized entries of the same type.
+ * @blocks:          The list of serialization blocks (struct kho_block).
+ * @nblocks:         The number of allocated serialization blocks.
+ * @head_pa:         Physical address of the first block header.
+ * @entry_size:      The size of each entry in the blocks.
+ * @count_per_block: The maximum number of entries each block can hold.
+ * @incoming:        True if this block set was restored from the previous kernel.
+ *
+ * Note: Synchronization and locking are the responsibility of the caller.
+ * The block set structure itself is not internally synchronized.
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
+ * struct kho_block_set_it - Iterator for serializing entries into blocks.
+ * @bs:         The block set being iterated.
+ * @block:      The current block.
+ * @i:          The current entry index within @block.
+ */
+struct kho_block_set_it {
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
+#define KHO_BLOCK_SET_INIT(_name, _entry_size) {			\
+	.blocks = LIST_HEAD_INIT((_name).blocks),			\
+	.entry_size = _entry_size,					\
+	.count_per_block = (KHO_BLOCK_SIZE -				\
+			    sizeof(struct kho_block_header_ser)) /	\
+			   (_entry_size),				\
+}
+
+void kho_block_set_init(struct kho_block_set *bs, size_t entry_size);
+
+int kho_block_set_grow(struct kho_block_set *bs, u64 count);
+void kho_block_set_shrink(struct kho_block_set *bs, u64 count);
+
+int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa);
+void kho_block_set_destroy(struct kho_block_set *bs);
+void kho_block_set_clear(struct kho_block_set *bs);
+
+/**
+ * kho_block_set_head_pa - Get the physical address of the first block header.
+ * @bs: The block set.
+ *
+ * Return: The physical address of the first block header, or 0 if empty.
+ */
+static inline u64 kho_block_set_head_pa(struct kho_block_set *bs)
+{
+	return bs->head_pa;
+}
+
+/**
+ * kho_block_set_is_empty - Check if the block set has no allocated blocks.
+ * @bs: The block set.
+ *
+ * Return: True if there are no blocks in the set, false otherwise.
+ */
+static inline bool kho_block_set_is_empty(struct kho_block_set *bs)
+{
+	return list_empty(&bs->blocks);
+}
+
+void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs);
+void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it);
+void *kho_block_set_it_read_entry(struct kho_block_set_it *it);
+void *kho_block_set_it_prev(struct kho_block_set_it *it);
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
index 000000000000..4f147c308e6b
--- /dev/null
+++ b/kernel/liveupdate/kho_block.c
@@ -0,0 +1,411 @@
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
+ * by serializing it into memory blocks, and provides the common
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
+ *
+ * With a 4KB page size, 10k blocks is about 40MB. For 32-byte entries
+ * (e.g. 4 u64s), each block holds up to 127 entries (accounting for the
+ * 16-byte header), allowing the block set to hold up to 1.27M entries.
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
+	WARN_ON_ONCE(!bs->count_per_block);
+}
+
+/* Serialized entries start immediately after the block header */
+static void *kho_block_entries(struct kho_block *block)
+{
+	return (void *)(block->ser + 1);
+}
+
+/* Get the address of the serialized entry at the specified index */
+static void *kho_block_entry(struct kho_block_set_it *it, u64 index)
+{
+	return kho_block_entries(it->block) + (index * it->bs->entry_size);
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
+static int kho_block_set_grow_one(struct kho_block_set *bs)
+{
+	struct kho_block_header_ser *ser;
+	int err;
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
+ * kho_block_set_grow - Expand the block set to accommodate the target count.
+ * @bs:    The block set.
+ * @count: The target number of valid entries to accommodate.
+ *
+ * Acts as a runtime notifier when new resources (such as files or sessions)
+ * are registered. Dynamically preallocates and links preserved memory blocks
+ * if the target entry count exceeds the current total capacity of the set,
+ * ensuring they are available during serialization/deserialization.
+ *
+ * Context: Caller must hold a lock protecting the block set.
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_block_set_grow(struct kho_block_set *bs, u64 count)
+{
+	if (WARN_ON_ONCE(bs->incoming))
+		return -EINVAL;
+
+	while (count > bs->nblocks * bs->count_per_block) {
+		int err = kho_block_set_grow_one(bs);
+
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void kho_block_set_shrink_one(struct kho_block_set *bs)
+{
+	struct kho_block *last, *new_last;
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
+/**
+ * kho_block_set_shrink - Shrink the block set to accommodate the target count.
+ * @bs:              The block set.
+ * @count:           The target number of valid entries to accommodate.
+ *
+ * Acts as a runtime notifier when resources (such as files or sessions) are
+ * unregistered, allowing the block set to release and unallocate redundant
+ * preserved memory blocks. Checks if the last block in the set can be removed
+ * because the remaining entry count is fully accommodated by the preceding blocks.
+ *
+ * Note: It is the caller's responsibility to ensure that entries are removed
+ * in LIFO (last-in, first-out) order (the reverse order of their insertion).
+ * Because shrinking destroys the last block in the set, removing entries in
+ * any other order would corrupt active data.
+ *
+ * Context: Caller must hold a lock protecting the block set.
+ */
+void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
+{
+	while (bs->nblocks > 0 && count <= (bs->nblocks - 1) * bs->count_per_block)
+		kho_block_set_shrink_one(bs);
+}
+
+/*
+ * kho_block_set_is_cyclic - Check for cycles in a linked list of blocks.
+ * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
+ *
+ * Return: true if a cycle or corruption is detected, false otherwise.
+ */
+static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
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
+			pr_err("Block set is corrupted\n");
+			return true;
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
+			pr_err("Block set is corrupted\n");
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * kho_block_set_restore - Restore a block set from a physical address.
+ * @bs:      The block set to restore.
+ * @head_pa: Physical address of the first block header.
+ *
+ * Restores a serialized block set from a given physical address. The caller is
+ * responsible for ensuring that the block set @bs has been allocated and
+ * initialized prior to calling this function.
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
+	if (kho_block_set_is_cyclic(bs)) {
+		bs->head_pa = 0;
+		return -EINVAL;
+	}
+
+	while (next_pa) {
+		ser = phys_to_virt(next_pa);
+		if (!ser->count || ser->count > bs->count_per_block) {
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
+
+	/* Free the remaining un-restored blocks in the physical chain */
+	while (next_pa) {
+		struct kho_block_header_ser *next_ser = phys_to_virt(next_pa);
+
+		next_pa = next_ser->next;
+		kho_block_free_ser(bs, next_ser);
+	}
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
+
+	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
+		list_del(&block->list);
+		kho_block_free_ser(bs, block->ser);
+		kfree(block);
+	}
+	bs->nblocks = 0;
+	bs->head_pa = 0;
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
+ * kho_block_set_it_init - Initialize a block set iterator.
+ * @it:         The iterator to initialize.
+ * @bs:         The block set to iterate over.
+ */
+void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs)
+{
+	it->bs = bs;
+	it->block = list_first_entry_or_null(&bs->blocks, struct kho_block, list);
+	it->i = 0;
+}
+
+/**
+ * kho_block_set_it_reserve_entry - Reserve and return the next available slot for writing.
+ * @it: The block iterator.
+ *
+ * Reserves a slot in the current block during state serialization to add a new
+ * entry, advancing the internal index. If the current block is full, it
+ * automatically moves to the next block in the set.
+ *
+ * Return: A pointer to the reserved entry slot, or NULL if the block set's
+ * capacity is fully exhausted.
+ */
+void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
+{
+	void *entry;
+
+	if (!it->block)
+		return NULL;
+
+	if (it->i == it->bs->count_per_block) {
+		if (list_is_last(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_next_entry(it->block, list);
+		it->i = 0;
+	}
+
+	entry = kho_block_entry(it, it->i++);
+	it->block->ser->count = it->i;
+	return entry;
+}
+
+/**
+ * kho_block_set_it_read_entry - Read the next serialized entry from the block set.
+ * @it: The block iterator.
+ *
+ * Iterates through previously written entries during state deserialization,
+ * respecting the actual count stored in each block's header.
+ *
+ * Return: A pointer to the next serialized entry, or NULL if all serialized
+ * entries have been read.
+ */
+void *kho_block_set_it_read_entry(struct kho_block_set_it *it)
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
+	return kho_block_entry(it, it->i++);
+}
+
+/**
+ * kho_block_set_it_prev - Return the previous entry slot in the block set.
+ * @it: The block iterator.
+ *
+ * If the current index is at the start of a block, it automatically moves to
+ * the end of the previous block.
+ *
+ * Return: A pointer to the previous entry slot, or NULL if at the very
+ * beginning of the block set.
+ */
+void *kho_block_set_it_prev(struct kho_block_set_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == 0) {
+		if (list_is_first(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_prev_entry(it->block, list);
+		it->i = it->bs->count_per_block;
+	}
+
+	return kho_block_entry(it, --it->i);
+}
-- 
2.53.0


