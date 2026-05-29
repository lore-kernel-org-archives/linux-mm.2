Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EFCCD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60366B0095; Thu, 28 May 2026 23:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E109C6B0098; Thu, 28 May 2026 23:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62CC6B0099; Thu, 28 May 2026 23:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A72EB6B0095
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45122C46D5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:17 +0000 (UTC)
X-FDA: 84819006594.27.FF8FCBB
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72D5C1C0004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ELRckKbK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVSXk0/56skBmRqrLRSaTWUlJtVH0b3/3ym1O9cV9BM=;
	b=6/6uUM9ThhfH/N21bKs/HLj6P8DqlkK9NoMTot5ZvivZZPPr5BCtLMkwv0K+egAUkg7wAf
	2ST2GuS0V8jbGeIlEYQMVkyzrgMCMZdK7zv3sy82sK9+58RUA2IwurJ8VLI/PsVUq9KbSZ
	e1dEvMrGW4qoxSF1uk7K868h+unur0s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ELRckKbK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024875; a=rsa-sha256;
	cv=none;
	b=iGllHsEuVCT7+zCKD9NGrxM4BTqDUo9cNfWRIwSFRz/804s91YvvzsF9feaxnEgx4fxHiN
	Zh0V64cegByZtxS4aL7YihRBZNy/3/eH6mnCZq8Ci+Y7z8IBOxwUwtOE0qvW8xzrKAkdnD
	zidmAZ5vxmNC5hBER4+fUuHTP1PLPoc=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ccd2c0fa7aso15105196d6.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024874; x=1780629674; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVSXk0/56skBmRqrLRSaTWUlJtVH0b3/3ym1O9cV9BM=;
        b=ELRckKbKUhd03VhLScrMZ3Dfx6QT3gBsaZxH/XEpYqSLkSo16+bwY0M8iP9EyRtR36
         rXAbTthejGEGWOj8/KPutFvCkNE2WZTCpq4vx3gZg3pV3kVZ13EUaRLMk9L//3r505wG
         67UnoHsIcyjv89POCGwf+sun8CbKie4M4B17DoMEUpHt+YLMgArHbzmqUthEmDwDNF6Q
         7FXJ4Ypn3/aZD9xOxPpWDarrSAEG7AQvNTxQbHaYJZQ7MFFArsHBAOgxEK1YgEdu+Yk5
         r1Q/k4hte3MT+poBrY15SzRe/F2JaGJURc+KhfWzV9vjL7WKUs6xqe8CBG4iADzjg6rM
         2Bhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024874; x=1780629674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IVSXk0/56skBmRqrLRSaTWUlJtVH0b3/3ym1O9cV9BM=;
        b=DLdrMSs425+TNuRnZJo8DhuveJheFYygPjhW+f8G/NXrq0SZLbtSoPjD33GjrYkL/9
         j8Wd0hSIwg64hMj4MktIHR9/6rLfvATXeAP4sj5R8JfLqsasi+l+2XSw0Mchaq2axoHQ
         CH45EyLimb9QNHKcmDP8NHXw2nowyPrr5FH0GYuifEowjMMaBUJy4mxGm1qTAffW+s+G
         eCbS8EFciuQ5SCk9LvKVxn1kSOVQJb3hprJtwHTJlIAu3iysOFU8Ui/7Ulk+MPGuSxIL
         glFsCEf5Zwi0Y32m0kFc3FdzGRdzfr2LqfW81dKogdgqLztS7dVCXqEHYt461yBGkNeT
         cOTg==
X-Forwarded-Encrypted: i=1; AFNElJ81y19cJI/EEcfZvc1EnIoA8JiWpXnscQ1J1KR/KXllrCZPyAyW9P+Z9Mvw/OuaUQsfwgs0m4LJmA==@kvack.org
X-Gm-Message-State: AOJu0YwHqAsZxyE97w536kHNPHUpt0Pwj4Th0lwnSqe2KlcRn9SuFXqr
	eT3ObE3Ggjh6Mho7GNS+PNQLgJFGhA3eGDupcDR7ZMVsUpRqEsS0gh+nYy+xsDRC/ZE=
X-Gm-Gg: Acq92OFxF7kGDH3Ti5y6uYtaS2LCvPVRtW6ojpWlfeebIdSTFdOqPXcOE1JnBrVcmWK
	Hbyvj5TPvWpwhRKAlCp9948Tcf1DvIS872x2l8Q/aGqRu2DkkQ8W4GyVSK2Wf4zXpd8b/tLYYPa
	B2uhJObZQ39wPsiZ0pHnPaYmMoaDTdVOWLFl1h+fA1d3TRr1otZ8+/YuLjEh5H/+jb8jBX+kr4o
	pJJlHCrSOXnKzyUpxf5kD7j55qFBijYKX9XD36jyFst63fyP1erTwQxh8akaqBFdozjj74y22iP
	TdL2IZ7dYRuC/ntc5/Ct39BlWh5oIa7qJQM/2hU5UKFw1xv3s50gR2uf6MILKK+LbuzVgRx6D8s
	jCnFiAUt2WfHFGvpZGXB1QUPj3IF/jlopk5842XFLFEEIMlnY949iGmJ3AkOb9+KlM9yXKJp+Jr
	l2poeKyqdr4XKxm8tyA3aezAoDDRiqoU+bnPFgv0lw06s1oQ63HsscJadTWvNQEz+V7XYyT5WY
X-Received: by 2002:a05:6214:4347:b0:8c3:f47f:50f8 with SMTP id 6a1803df08f44-8cce7a1f616mr15839496d6.0.1780024874311;
        Thu, 28 May 2026 20:21:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:13 -0700 (PDT)
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
Subject: [PATCH v3 05/11] kho: add support for linked-block serialization
Date: Fri, 29 May 2026 03:21:00 +0000
Message-ID: <20260529032106.1505796-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 72D5C1C0004
X-Stat-Signature: ce4bnnot1ao3z47c8asoyt4wggg9qyig
X-Rspam-User: 
X-HE-Tag: 1780024875-971341
X-HE-Meta: U2FsdGVkX1+tb95CEQaIbcaJUrp1h17IpOWCmH116QlAGyCkb51Kpo94YVCpTm26uXQU/mivSjZfe3HiFsYxwqYKdC89mi0Qc9RUnOfSgIsJCV3kSZeBZ2lHjKM6AppSdxJzaFOQvGPpdRZ8UPX55lvfQHj2v5DrvPyU2Bw8I7rH1YFfyLQBhv04C+a2glOQsYtsbEepjhX3gwRRkqLe0OBpCrDn2X0CjYRl5otQr/vQuhPrSWyPMdhFINFucrEMXqOdnUd0CIpmjwh7dMaXMk3ojkKG2nDwr6zXK/EJW8jT6RhfLaoJWM0hhyQ95YdnxuyCPTnzTx+aXa2NyOwmE+8CbN3SC9Ad6qjeN13SQdDxt3deCuAGh0iL2w2zDHWBW4sdS8FG8q1LkJQ7ljOW09ql+dluHFeYrJiERl8dKdmb8+kK6FtZDhL3p/xB2Cnh9f8rGjtzp/nbFcLbd1Z/F5ClwTpObKrUOSZw4jE0VobQx4QiO0+Liu8oLzYbLbh1dHSAloFSusGtRbGcd4ZweS0saHQHAIkm07ZoouTYaX0Oh/TwV74TwH9F2Ms/ha7qADoW3xiT4+ZvVUMjtPJ5+VkuVkIVr2z4N6w+cjKLByxuj+xY1aQ4jQQXE5rsUQ9WtphPKdqot63bcH+OrpHqJ3sF4Z9AON7nvMpAVpN0qRFE6CizHRzuV9E3C5WvpHjeQi9DzkAzHp3uvVuNZLf7C9Au3OMMp0SFxxq1FVa4OLoElbqPQOrWw3jRffydG6CrLufBgUb9W+T4QSknT4LTrs7+X1HAg2fmx5ULfVsLPYUhTrsfdtBMrb4d6XZ1pgbEVDLDEqN+g8Kikw9G/f5FS9kID5JrzJGwM5RW53dHJ3eyZ2N9gBIj2d/Z32zLJR0wtwrWPN57sHCceWCw8H2UJIg27x1d70TNdsDm8xNHlM/r+Z0s9SqKnuq2PLO4WYU1d26Y5mNfoUumpr+he/f
 Yu9jzEM6
 rdUI3nFeBHVlPK49pt/gKjSySTPy34I2JapRTv4DDlQUFEJrUV4L5vVK3j2n1TBKbnfSB819Ib93rxbI7FK9SCbxlMBuJlNvT4LDBW6JkHopKZB9ftXmxa/T43NHLMjxg1+47cRDfHUuikP0zq+9x8sMutoH5a9y5e7F2yVbpd5BJwLwHHY0XB/LacBIHQhUbTUNqCYPH7GVMUcPnX4acgKnXO76u9oL3UjpwANByxsOXJZafI2ugTc/nwEZsLRXjQUFQjiVaTNFho2S0dXEs6qML4VrusWdEulhskTcKbjm1U9fOvVfWX+IlwAehc5qvYQXEjtz1FFoaMuw=
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
 kernel/liveupdate/kho_block.c        | 382 +++++++++++++++++++++++++++
 7 files changed, 535 insertions(+)
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
index 2fb1c75afd16..fd119b343e99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14194,6 +14194,7 @@ F:	Documentation/admin-guide/mm/kho.rst
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
index 000000000000..5e6b87b1befa
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
+int kho_block_restore(struct kho_block_set *bs, u64 head_pa);
+void kho_block_destroy(struct kho_block_set *bs);
+void kho_block_set_clear(struct kho_block_set *bs);
+
+void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
+void *kho_block_it_next(struct kho_block_it *it);
+void *kho_block_it_read(struct kho_block_it *it);
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
index 000000000000..c781c1e36056
--- /dev/null
+++ b/kernel/liveupdate/kho_block.c
@@ -0,0 +1,382 @@
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
+		WARN_ON(!bs->count_per_block);
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
+	WARN_ON(bs->incoming);
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
+	if (WARN_ON(bs->incoming))
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
+ * kho_block_restore - Restore a block set from a physical address.
+ * @bs:      The block set to restore.
+ * @head_pa: Physical address of the first block header.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_block_restore(struct kho_block_set *bs, u64 head_pa)
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
+	if (!kho_cyclic_blocks_check(bs))
+		return -EINVAL;
+
+	while (next_pa) {
+		ser = phys_to_virt(next_pa);
+		if (ser->count > kho_block_count_per_block(bs)) {
+			pr_warn("Block contains too many entries: %llu\n",
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
+	kho_block_destroy(bs);
+	return err;
+}
+
+/**
+ * kho_block_destroy - Destroy all blocks in a block set.
+ * @bs:          The block set.
+ */
+void kho_block_destroy(struct kho_block_set *bs)
+{
+	u64 head_pa = bs->head_pa;
+	struct kho_block *block;
+
+	while (!list_empty(&bs->blocks)) {
+		block = list_first_entry(&bs->blocks, struct kho_block, list);
+		list_del(&block->list);
+		kfree(block);
+	}
+	bs->nblocks = 0;
+	bs->head_pa = 0;
+
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
+ * kho_block_it_next - Return the next entry slot in the block set.
+ * @it: The block iterator.
+ *
+ * If the current block is full, it automatically advances to the next block
+ * in the set.
+ *
+ * Return: A pointer to the next entry slot, or NULL if no more slots are
+ * available.
+ */
+void *kho_block_it_next(struct kho_block_it *it)
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
+ * kho_block_it_read - Return the next entry slot for reading.
+ * @it: The block iterator.
+ *
+ * This function iterates through entries that were previously serialized,
+ * respecting the count stored in each block's header.
+ *
+ * Return: A pointer to the next entry slot, or NULL if no more entries are
+ * available.
+ */
+void *kho_block_it_read(struct kho_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	while (it->i == it->block->ser->count) {
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


