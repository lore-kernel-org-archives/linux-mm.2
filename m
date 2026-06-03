Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1875ACD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5326B00AD; Wed,  3 Jun 2026 11:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7863F6B00AE; Wed,  3 Jun 2026 11:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626C36B00AF; Wed,  3 Jun 2026 11:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C95F6B00AD
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:45:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E47540438
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:30 +0000 (UTC)
X-FDA: 84839026020.08.9F4C589
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36E10A0002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=T41jtDRI;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4aSCoL41048YLbu/Ppdp+fUB4uFMSQf0r9BjBD04lw=;
	b=WyxbuVy9klvgjrco4bEpdR6vJeD4uyYKhdiahFcWclxKSG9Iq3enc3heeiPDSrRfyoS6IE
	HJIzzHTb9BSyHfhQSJxjG2AwqO3J0CQbb24u8r5Ccp24cjBAKB/6eNsm8kJY1R1LOVG4LZ
	GuqO0ZnxBLT0Zqynrox7S90jSt8OBY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501528;
	b=gzW70d4Z+Y/zYPDFC1SZjH4dMqWn1w6X4j96p1GAnwPwU8BjvhoyL+ns3RG+Z55nbj/C42
	tnQ8iyG52VYU0+uB60HYHxdvxTVudPlCiT5TV4j6gNaNzGYUYWVZynwt5Lto4dysplzFaf
	xsv6zn/AI5BKhXUFG88ETGyjrUMoigo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=T41jtDRI;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ccedaf0b54so31413246d6.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501527; x=1781106327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d4aSCoL41048YLbu/Ppdp+fUB4uFMSQf0r9BjBD04lw=;
        b=T41jtDRIXhzh4VHITzQWnMQVluGT51RvAssSOry0cdEBRXczDfxd4KiU3N1nNLFMpW
         wMawVNU/4vv7Xb9Xj0KuLEZwEqzjYa8oYxDn+hc0o5syIXfaiqoiC/P2WR0OJyyqUAcj
         o4W4Fn5gESS8NNUMWZqpdqfGBhToWYw3auSKRr+PZdxR2Q6QrFP/Q+E+6BFq1fQdNwfB
         4zbU633EZHJf6igmn0pGC9WJAMFq9kDxsaROorrgn42IzDJkj92Wc13RSicq3C8uR/4y
         +GUz7p8knDITVjkcE/CZVh5P+i9JatOEkcwyI9bwPiEutCWYXDSXqRkYHL36zHXd/gto
         xihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501527; x=1781106327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d4aSCoL41048YLbu/Ppdp+fUB4uFMSQf0r9BjBD04lw=;
        b=e7HkKy3LLcgYQSBohcCqNyrx8g6FfOlL4samH9qZDzO3miQqoXxHiY7dXp7HCNhDH0
         VbWjNXCQFQlmgmEUWjlmY169fdLbzP/1HR85Hu4i+cx49aVZbHo+pUZu2KV0tA0kKQtR
         7BtDaQMFLgcQngAXj3agUO4ANTboaY/YxHOvNYUnFF+QefmVIXbcoqsy6WVzU79jR30l
         hBZz6RPeT8vfVrZpE6c7MqXoGQbRrCUTiv8+JET/lGkUFPgmiqUs/GMdmbhYf+hUlr8F
         MTWaZHD3ConhUp9hyq2voqHS9FgICl4ydugZt+gd9GkCTP/jFr+nZqsmOwLkT5fHcNzS
         ycfQ==
X-Forwarded-Encrypted: i=1; AFNElJ99ucd11zsH6RBAIZMaDazh2KxQBC8DrLZqAHTHoZ+b5DR09e9XCZyqcT2KMglNxZSVg/KKxsENHQ==@kvack.org
X-Gm-Message-State: AOJu0YyJb1CIU2cv97xrlzwotcFW/68LBsy7t+Xd+rFx8I+d4qGigkvh
	Bh04qMAyFvTrty0NlzwRpwe/Dhyx938/N29ZwCyvMuCGlsJX8OtwYQeMJJ+yI4WWpIM=
X-Gm-Gg: Acq92OGSLy+oydo9IMRjk0WycH8lQveZQitNDMa77ILjneq4vBu9om2uGWH8JXuznk0
	JbCAP4hD6DMvFvPshiFH3u9VbSRwI3ZD9O5KTwSPpPttEwM6tm7j+eOZu/PBsn0KXfsKKwMTdu/
	dtY31e+7q8qfJGBKciL16UN9pBie5RzdX6qKA1Yl2L42cLgC+V1RgUxk3SHg5r8RwCDe3V7fB3S
	TY+JkFbMeRF4oLOe07T9kP99QZB5yXg0WBHlt/ezPacssIIJMOrdSrGYNOGOV7ttgfJFH4trzWl
	GCPVQL1Z9kWk5lGJzs1d+otHdxchzXfP/WvKzsgZ1O4IruaDuJfhUPEh2TYNWRdYRQZ0nvfcLR3
	e/f5FlxivNBSOTTUz8EgoyCYYb/lP8EyHRXNh8+P/oy12p653lp4EVlSenzYKlSb0/UZMAhAJfZ
	tQvEVxLL6SxJX0nP44r0fCQ1oIwihPN7meZ988GHfEMniSPGoks7FD1cT1wbhdMg==
X-Received: by 2002:a05:6214:488b:b0:8b3:f911:c1df with SMTP id 6a1803df08f44-8cecdea195cmr39593016d6.21.1780501526838;
        Wed, 03 Jun 2026 08:45:26 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fc7dsm23519496d6.5.2026.06.03.08.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:45:26 -0700 (PDT)
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
Subject: [PATCH v7 07/13] kho: add support for linked-block serialization
Date: Wed,  3 Jun 2026 15:43:56 +0000
Message-ID: <20260603154402.468928-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36E10A0002
X-Rspam-User: 
X-Stat-Signature: fomymrjdm8qb8qnck59nce1gyjtue5e6
X-Rspamd-Server: rspam08
X-HE-Tag: 1780501528-29598
X-HE-Meta: U2FsdGVkX1979OGHviKO7n/O4lxmnNSOxTTFwtqIdfOaFjI4R9x9XFn1jWa2hKxFSMQfH9OZ7ePwuO/z3rvJSvlisLvb7WBf2hq2awMfPDbR6LPgvKNP/AsCrIcyHBFdVlecWJY4UqG6qbl/FENFwiyyZDx4H+lM+JSGrkKaCG3PvafR6ROF1acLj4BCpW9vJIoDrie6QcERZVS/IbKiXM5Qer6JMPVYQdZC/wQgzkM+1R5oqpur10fNFynShbJyfhWZoOuPOjnSNJwTCfxWiaAHdRtWY5p1GyqJBne8vDeQ789fF8oWVFmgWUsLuhKaVOwbVxVUX2SjWDPo5Pg6uWq49EIIlkVSP3j3UoNZzkt4JgrCvLJaCjv/T1GFJ4/5i1pBP8xnxqxTVT2ZLSXbU6eTHgFOTDgyeOpash6LKUzExc/57ZkRaGQ8f+rZHCuZjA/Si6Qjr1GyR9Oh2mMM8+W7l70N2u3llIjyY/WIkVEeOFbJkJq3nwL0LhKmogEMJWv119/l+Z4TC4g5tk7b+pr5H1xmjYbbArZxcqs8NunBisyQd6bI14yhMrNgtK9LyZ3ccxsqy4YeG2KM5GbbTkD6O2JdscA/prXHC5UpqWPA3Ba1DFiVlV9eu9B1PNxdkgMaCoQj/mmM1kWOLXkC3S3m7fOXPt+tTSc0tZbM7UL5aGe1uF1UNWPKNq5R6N2jlI90pUX2lL61xUefP3HZV25dfFQ0Jazd6sKDPobigssVDw5L/ZN7bJ75SRXj3lu0wzwbz/UjAxbw9eo/J6Jz5h+Gg4ayBXW8VOCoFk9oXCEEkakny3B+t03hUXjB8znTNar3A3RkhYksQt8evTxV/MZ0GYBX5l0jm21Gkf9DEospGB37rPaABUuCHAjiKxKBAcQ+rDX+NQcSUSa3iRYGeCNU8NihYC0jKYYTG7rpY2dJibl7AKMkS86oeL9OVKA9wN00FzcfOCKSsURX5S8
 +4nIbp+G
 5QLOrpi0pcZ6wN1slBzf9kBfrEoR9SNuvIhOboMuDgGKUMDrDjnRWM/6IXZaoVGJUgpdNhZnZdl+vrIeKu4VANFW4WWDS/21azNMEgxnqIKYcPSAU+GGyUPkC0CNwILYwdMz7F6rQdfEOUJJUExOznMJRK/7UFwkuwCvfU1Pl/eYvXg1qeBABVOQy0xluxsAFkg0ljzd6ZXiILoXEx3uNBY8N0U3/P2681Yr3KjGy4/t57UhRSfLT42MdHqwom7jIeFYkI/tdgq/CuHy8knxVpViovVEJdZcClp+K4hz+0lEr4yIPdT+tn8kiKL6Oo1Mrb6MRRIydQxZ0Ky8=
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
 Documentation/core-api/kho/abi.rst     |   5 +
 Documentation/core-api/kho/index.rst   |  11 +
 MAINTAINERS                            |   1 +
 include/linux/kho/abi/block.h          |  54 ++++
 include/linux/kho/abi/kexec_handover.h |   2 +-
 include/linux/kho_block.h              | 106 +++++++
 kernel/liveupdate/Makefile             |   1 +
 kernel/liveupdate/kho_block.c          | 416 +++++++++++++++++++++++++
 8 files changed, 595 insertions(+), 1 deletion(-)
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
index 000000000000..d06d64b963be
--- /dev/null
+++ b/include/linux/kho/abi/block.h
@@ -0,0 +1,54 @@
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
+ * incrementing the version number in the `KHO_FDT_COMPATIBLE` string to
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
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index fb2d37417ad9..5e2eb8519bda 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -90,7 +90,7 @@
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v3"
+#define KHO_FDT_COMPATIBLE "kho-v4"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
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
index 000000000000..0d2a342ef422
--- /dev/null
+++ b/kernel/liveupdate/kho_block.c
@@ -0,0 +1,416 @@
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
+ * kho_block_set_grow - Expand the block set to accommodate the target count.
+ * @bs:    The block set.
+ * @count: The target number of valid entries to accommodate.
+ *
+ * Dynamically preallocates and links preserved memory blocks if the target
+ * entry count exceeds the current total capacity of the set, ensuring they
+ * are available during serialization/deserialization.
+ *
+ * Context: Caller must hold a lock protecting the block set.
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_block_set_grow(struct kho_block_set *bs, u64 count)
+{
+	long orig_nblocks = bs->nblocks;
+	int err;
+
+	if (WARN_ON_ONCE(bs->incoming))
+		return -EINVAL;
+
+	while (count > bs->nblocks * bs->count_per_block) {
+		err = kho_block_set_grow_one(bs);
+		if (err)
+			goto err_shrink;
+	}
+
+	return 0;
+
+err_shrink:
+	while (bs->nblocks > orig_nblocks)
+		kho_block_set_shrink_one(bs);
+	return err;
+}
+
+/**
+ * kho_block_set_shrink - Shrink the block set to accommodate the target count.
+ * @bs:              The block set.
+ * @count:           The target number of valid entries to accommodate.
+ *
+ * Releases and unallocates redundant preserved memory blocks. Checks if the
+ * last block in the set can be removed because the remaining entry count is
+ * fully accommodated by the preceding blocks.
+ *
+ * Note: It is the caller's responsibility to ensure that entries are removed
+ * in the reverse order of their insertion. Because shrinking destroys the last
+ * block in the set, removing entries in any other order would corrupt active
+ * data.
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


