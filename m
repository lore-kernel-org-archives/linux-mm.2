Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7E0CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38BB6B0092; Thu, 14 May 2026 18:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9C16B0093; Thu, 14 May 2026 18:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13EE6B0095; Thu, 14 May 2026 18:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF3866B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B7A8120127
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:41 +0000 (UTC)
X-FDA: 84767461002.24.4C539A5
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id A45251C0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LskfoWu4;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNqqwGdiG18Z/AQkO2ZGChCHZOKJcrPhRyXZH73Csio=;
	b=yGb5qpgTweo89t41i07T2UL4evrbBBX/re2Zh1eh8SpYlvKAOEzXksJ1U0gPFt6rmZUusz
	WpZnreG/M5IlP2faXSlF8jGMWpTYxqx+He+2W9X0cjEZROyiMk+WdSgmlu2rpZB/Iaw9HW
	ivg5ZQsHFrWK0Ha1z4XbYVZQugpA9hs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LskfoWu4;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797599; a=rsa-sha256;
	cv=none;
	b=tuucQtBppadFq+meCU6KMBU+G4/gih5Hkoc8mK5Ex+adW/2IfD8JSpQ9zBm1C8ieJZSCme
	qGRPtU7Q4F4y75nU+kUPeQ7gj1j9uyUe48q5uuwR2cJwCMaItpwh0sIKU4S9nKZgj51RY+
	SRlZb+c6/WMY7uAXUOSoxz+pXOB1oNI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51306c9f2e1so86080231cf.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797598; x=1779402398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iNqqwGdiG18Z/AQkO2ZGChCHZOKJcrPhRyXZH73Csio=;
        b=LskfoWu4xtcbg9SbUTF8lGIKWys+SzOcQGPGQjSO4W+ugznmQnX1fOIgmukTYs8sxf
         1XTlOD2cbzJc1bBihXdJP+NELGORou9mw3uZOSKFD6uGaZrySBDxHQcsdkDbJ2VdySxJ
         xeStsZbW7iBa2y+7CYhkA5NQ/6TsWWsNd11CdM6tIfQdpwLTOpVaGO+AKfQoo3uPyeNv
         SMBW5roabuzY8rzGB8rBcbOpBiku2UCVQ+UNBFlRlfZBm8AEAbJcV1zKJQgiCEStklya
         4nAV4MIros317hB/bHGZ3W0XGBxD0JGhEK/5GBAZgcQU0vA8/KhtJCy9iGJm95YIgs+4
         cF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797598; x=1779402398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iNqqwGdiG18Z/AQkO2ZGChCHZOKJcrPhRyXZH73Csio=;
        b=Fy3jD+uQud8cnP0Rt4GHbkLgvoXJQSOieYmxmJATCnhR64zUIINygM33ORmrdYVkFq
         lqKTTq8S6EbQj15YD2ZCETbm+ZPmwATP4AowjprUwraKlci3ji4a3zjw9JmjfUm6ZhUw
         8SuWptMzfUu8JjiLiszDu/QLH9hTXJRJh8f2qJUrt8SzuVNAqad7HVSYYf7O8ULvX4R0
         3qUR5yYY42rofx4MbgRUHORF8DjLwIr27pkQB8dlNo4AGi5t8r+zpihMfuHwVfeLtd2L
         RClJY1GRs6BvBNEIsGsCdWXheW2ptRWScozk0VC/yEtpYJzH+ACpON0oCpTF1LsL6rds
         Ac5g==
X-Forwarded-Encrypted: i=1; AFNElJ+cZb3Dz+c0O0RFMoD4mCJn3xeZhhkSj+UljfDFFJDFUGku7AvYhOZEvHJmQh+Wrd5tIdqbx2txmg==@kvack.org
X-Gm-Message-State: AOJu0YwNsXEt7W7xjMRz36zfvSBQI3b/s5xEya0KcjkOwAkSK5Kq5iBH
	6eA7BpqgWvYJ0k5o0VEZ++N7bWQuh/VEWe8vy04hsHcn9ZSZ19CowCAlmSMfQ/YoOc0=
X-Gm-Gg: Acq92OGGpeArNVJhOK28QHJTCU2zQ/tBoGZlwF+zol8zs6s3HhKoRK7WZBo2/pIgBJS
	u1H1OIGDPcmTmmrg3moEF24XkN2HXjn7I3rHTuvcLfvsBvHg0Asz67GCbn9tUZzfYCTPTOeFr4D
	3c0BClsd8gm1dsQ+51eYN2Uy74tQ0DQLR7gnD/2JlF8M3owYOzwMefd/jvbmiQOBYM5SAgQdsi+
	gj7PpssXHF4pXZ0Cew3bb9LxpC1Z0bfpmmd+g62NqgDk/Ob75cF0Myo51RICFxYEHuTjNbtOEUm
	dyXLClkwPK/i3CtNxHKXkvC6IZITNXnbMygm8y2ODy8nXMxRKO9O6SNGigTSEUQfFSgchU4dxv1
	Kq1RUEQ+EkrNQ+SlQc7BpFoiOd2H5d1DkszAoKWwT930ZiqP/1zevTTtZaKs6+Msnqsi87k11qw
	9blylRPHUKdQYMArJ/u28G35RrT6rh1jta3dNBTNlLsdfheYmgUG8=
X-Received: by 2002:a05:622a:13cb:b0:509:348f:bc1a with SMTP id d75a77b69052e-5165a07eed4mr19793671cf.26.1778797598409;
        Thu, 14 May 2026 15:26:38 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:37 -0700 (PDT)
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
Subject: [PATCH v2 04/10] liveupdate: add support for linked-block serialization
Date: Thu, 14 May 2026 22:26:22 +0000
Message-ID: <20260514222628.931312-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xorqpe9cq4c4qyaj9gror9k387mqif8
X-Rspamd-Queue-Id: A45251C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778797599-950560
X-HE-Meta: U2FsdGVkX19kuQbr2lvq3WbG403qdjapzUJKfHYUl4TM7BTlye4hs//uXKxOr/uiMvZgoFbflHhY+C18yyqCZ2K/E34uUeZDeX9WjuYMY5ySVVfkEf6Ps4lYzx8E/GWhbfusdA4eMNgJyiUq5HqooH7L9q8GsW0PrDCYWKiD3IZzjoBznzrVYlRwu8rbIkGrf0Kvrtwjny0ux+TXEyTxxMztg2Xb3ih36y4C5QSSQdoN97JVkkB2IW1PTv63gvq13YIrik7vZt6nkaAxDeaFL/VToaozBwxVWIdmB9PsLUIfTb/q7OtThxR3tor9v9eK7hvpK4D2DP+YvcEwgAMMM2XWv7k2ELiTtMGa4bV/PyIu6AAR/h6NiK+ReyR+dSdzO1JQSu2s74gexrxc+qW3ZLaF+jDNJ6GVgERxQ7q+Ue3ZpMYd1UZfykH4JxmctSJV2GcRL7cmOph0Ct8inIWOVx6B5EsWJzD6wVnZuIN0qW18lj/LYWL8HZa9gPEd799m6jHCGF8nlujllqbfnJm6/U8BvR7o63kEFFfoe0Td8EbL8eDz9AfwOWmqabNz16sN8xigyECavvBcqpeDtG2C83MEwE+hs6UT993l1g4hZOKfs9Yx5U9wiwFdJr9o/QhbTc3gPFHZ/cQwcTo8mBH7Yl6SZiYizLHL8OqwZTLba3qsOLT6t4O8Ycqzy7tcMnlXdWtOEqDOYdDcOcRHdWF5qZNUJyhTPDBwLAYZZjm1NvnUIWzo0rUwc8eEip+z6UeV//MrY+01sf3Q8SDzPGQx/oMbahrv+RkVY3pZOGIZaHvbKCWpko/i2QvSatbXKOLLspWxO/l47jM2WFJuqg2cpXNz3ZKKKz5TU/S/LgOu9Pu9bMFHyBt2aznO1E9wLU4K0FqeE4KAk393/qDZsf6l5yH43GHG6eLifFrJPHTYxDFt593JR60e6Mzca77xui0tA7CsIXbIutGalE3tdvT
 J+J/q3Yp
 Eb64U4AFfMIu2pL0CzE7oDlK7/MaMHnNM1+n6+HB1H5hsxPloFO+b5WVLbXtUgXYucHgHVv1i5ZWmKMNF/qR2U2Pjti2Jyk1lPRBJlPd6BabuxiUFwQk4iBKSN/KGv8S1iS6Vc/qX7VsDgrytzUx4iS0zPaEQHooRIYHvLeG79mlLzCumO8z7W8JougqFS+By9UL/mskFtoe/RIE1PF6pEOuOiQ56VjScp/EaNABKj5/UKqaQvsxSos7Wmo+DwjbNi4+qCZwagGmk0qgPCDECNtaLma6R3oKrK92Liy5Ao47PhZ6Qo+CGcublEXq7ofzVsYeWvG2MxefsiXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a linked-block serialization mechanism for LUO state.

Previously, LUO used contiguous memory blocks for serializing sessions
and files, which imposed limits on the total number of items that could
be preserved across a live update.

This commit adds the infrastructure for a more flexible, block-based
approach where serialized data is stored in a chain of linked blocks.
This is a preparatory step to allow an unlimited number of
luo_sessions and luo_files to be preserved.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/liveupdate.rst |   8 +
 include/linux/kho/abi/luo.h           |  22 ++
 kernel/liveupdate/Makefile            |   1 +
 kernel/liveupdate/luo_block.c         | 388 ++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h      |  57 ++++
 5 files changed, 476 insertions(+)
 create mode 100644 kernel/liveupdate/luo_block.c

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..978beb02292f 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -23,6 +23,11 @@ LUO File Lifecycle Bound Global Data
 .. kernel-doc:: kernel/liveupdate/luo_flb.c
    :doc: LUO File Lifecycle Bound Global Data
 
+LUO Serialization Blocks
+========================
+.. kernel-doc:: kernel/liveupdate/luo_block.c
+   :doc: LUO Serialization Blocks
+
 Live Update Orchestrator ABI
 ============================
 .. kernel-doc:: include/linux/kho/abi/luo.h
@@ -65,6 +70,9 @@ Internal API
 .. kernel-doc:: kernel/liveupdate/luo_file.c
    :internal:
 
+.. kernel-doc:: kernel/liveupdate/luo_block.c
+   :internal:
+
 See Also
 ========
 
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 1b2f865a771a..2ba447c0c1ba 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -49,6 +49,11 @@
  *     The central ABI structure that contains the overall state of the LUO.
  *     It includes the liveupdate-number and pointers to sessions and FLBs.
  *
+ *   - struct luo_block_header_ser:
+ *     Header for the session or file data block. Contains the physical address
+ *     of the next data block and the number of entries that follow this
+ *     header in the current block.
+ *
  *   - struct luo_session_header_ser:
  *     Header for the session array. Contains the total page count of the
  *     preserved memory block and the number of `struct luo_session_ser`
@@ -105,6 +110,23 @@ struct luo_ser {
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
+/**
+ * struct luo_block_header_ser - Header for the serialized data block.
+ * @next:  Physical address of the next struct luo_block_header_ser.
+ * @count: The number of entries that immediately follow this header in the
+ *         memory block.
+ *
+ * This structure is located at the beginning of a block of
+ * physical memory preserved across the kexec. It provides the necessary
+ * metadata to interpret the array of entries that follow.
+ *
+ * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
+ */
+struct luo_block_header_ser {
+	u64 next;
+	u64 count;
+} __packed;
+
 /**
  * struct luo_file_ser - Represents the serialized preserves files.
  * @compatible:  File handler compatible string.
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d2f779cbe279..9f8f6fb1b8e5 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 luo-y :=								\
+		luo_block.o						\
 		luo_core.o						\
 		luo_file.o						\
 		luo_flb.o						\
diff --git a/kernel/liveupdate/luo_block.c b/kernel/liveupdate/luo_block.c
new file mode 100644
index 000000000000..0be0669b5cac
--- /dev/null
+++ b/kernel/liveupdate/luo_block.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO Serialization Blocks
+ *
+ * LUO provides a mechanism to preserve stateful data across a kexec-based live
+ * update by serializing it into contiguous memory blocks. This file provides
+ * the common infrastructure for managing these blocks.
+ *
+ * Each block consists of a header (struct luo_block_header_ser) followed by an
+ * array of serialized entries. Multiple blocks are linked together via a
+ * physical pointer in the header, forming a linked list that can be easily
+ * traversed in both the current and the next kernel.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/slab.h>
+#include "luo_internal.h"
+
+/* 2 4K pages, give space for 170 sessions or 127 files per block */
+#define LUO_BLOCK_PGCNT		2ul
+#define LUO_BLOCK_SIZE		(LUO_BLOCK_PGCNT << PAGE_SHIFT)
+
+/*
+ * Safeguard limit for the number of serialization blocks. This is used to
+ * prevent infinite loops and excessive memory allocation in case of memory
+ * corruption in the preserved state.
+ *
+ * This limit allows for 1.7 million sessions and 1.27 million files per
+ * session, which is more than enough for all realistic use cases.
+ */
+#define LUO_MAX_BLOCKS 10000
+
+/**
+ * luo_block_set_init - Initialize a block set.
+ * @bs:   The block set to initialize.
+ * @entry_size: The size of each entry in the blocks.
+ */
+void luo_block_set_init(struct luo_block_set *bs, size_t entry_size)
+{
+	*bs = (struct luo_block_set)LUO_BLOCK_SET_INIT(*bs, entry_size);
+}
+
+static inline u64 luo_block_count_per_block(struct luo_block_set *bs)
+{
+	if (unlikely(!bs->count_per_block)) {
+		bs->count_per_block = (LUO_BLOCK_SIZE -
+				       sizeof(struct luo_block_header_ser)) /
+				      bs->entry_size;
+		WARN_ON(!bs->count_per_block);
+	}
+	return bs->count_per_block;
+}
+
+/* Free serialzied data */
+static void luo_block_free_ser(struct luo_block_set *bs,
+			       struct luo_block_header_ser *ser)
+{
+	if (bs->incoming)
+		kho_restore_free(ser);
+	else
+		kho_unpreserve_free(ser);
+}
+
+static struct luo_block_header_ser *luo_block_alloc_ser(struct luo_block_set *bs)
+{
+	WARN_ON(bs->incoming);
+	return kho_alloc_preserve(LUO_BLOCK_SIZE);
+}
+
+static int luo_block_add(struct luo_block_set *bs,
+			 struct luo_block_header_ser *ser)
+{
+	struct luo_block *block, *last;
+
+	if (bs->nblocks >= LUO_MAX_BLOCKS)
+		return -ENOSPC;
+
+	block = kzalloc_obj(*block);
+	if (!block)
+		return -ENOMEM;
+
+	block->ser = ser;
+	last = list_last_entry_or_null(&bs->blocks, struct luo_block, list);
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
+ * luo_block_grow - Create a new block if the current capacity is reached.
+ * @bs:    The block set.
+ * @count: The current number of entries.
+ *
+ * This function handles the dynamic expansion of a block set. It allocates
+ * and links a new serialization block if the provided entry count matches
+ * the current total capacity of the set.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int luo_block_grow(struct luo_block_set *bs, u64 count)
+{
+	struct luo_block_header_ser *ser;
+	int err;
+
+	if (WARN_ON(bs->incoming))
+		return -EINVAL;
+
+	if (count != bs->nblocks * luo_block_count_per_block(bs))
+		return 0;
+
+	ser = luo_block_alloc_ser(bs);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	err = luo_block_add(bs, ser);
+	if (err) {
+		luo_block_free_ser(bs, ser);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * luo_block_shrink - Conditionally destroy the last block in a block set.
+ * @bs:              The block set.
+ * @count:           The current number of entries across all blocks.
+ *
+ * This function checks if the last block in the set is redundant based on the
+ * total entry count and the capacity of the preceding blocks. If the entry
+ * count can be accommodated by the blocks that come before the last one, the
+ * last block is destroyed and removed from the set.
+ */
+void luo_block_shrink(struct luo_block_set *bs, u64 count)
+{
+	struct luo_block *last, *new_last;
+
+	if (count > (bs->nblocks - 1) * luo_block_count_per_block(bs))
+		return;
+
+	if (list_empty(&bs->blocks))
+		return;
+
+	last = list_last_entry(&bs->blocks, struct luo_block, list);
+	list_del(&last->list);
+	bs->nblocks--;
+	luo_block_free_ser(bs, last->ser);
+	kfree(last);
+
+	new_last = list_last_entry_or_null(&bs->blocks, struct luo_block, list);
+	if (new_last)
+		new_last->ser->next = 0;
+	else
+		bs->head_pa = 0;
+}
+
+/*
+ * luo_cyclic_blocks_check - Check for cycles in a linked list of blocks.
+ * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
+ */
+static bool luo_cyclic_blocks_check(struct luo_block_set *bs)
+{
+	struct luo_block_header_ser *fast;
+	struct luo_block_header_ser *slow;
+	int count = 0;
+
+	fast = phys_to_virt(bs->head_pa);
+	slow = fast;
+
+	while (fast) {
+		if (count++ >= LUO_MAX_BLOCKS) {
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
+ * luo_block_restore - Restore a block set from a physical address.
+ * @bs:      The block set to restore.
+ * @head_pa: Physical address of the first block header.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int luo_block_restore(struct luo_block_set *bs, u64 head_pa)
+{
+	struct luo_block_header_ser *ser;
+	u64 next_pa = head_pa;
+	int err;
+
+	/* Restored block sets use size from the previous kernel */
+	bs->incoming = true;
+	if (!head_pa)
+		return 0;
+
+	bs->head_pa = head_pa;
+	if (!luo_cyclic_blocks_check(bs))
+		return -EINVAL;
+
+	while (next_pa) {
+		ser = phys_to_virt(next_pa);
+		if (ser->count > luo_block_count_per_block(bs)) {
+			pr_warn("Block contains too many entries: %llu\n",
+				ser->count);
+			err = -EINVAL;
+			goto err_destroy;
+		}
+		err = luo_block_add(bs, ser);
+		if (err)
+			goto err_destroy;
+		next_pa = ser->next;
+	}
+
+	return 0;
+
+err_destroy:
+	luo_block_destroy(bs);
+	return err;
+}
+
+/**
+ * luo_block_destroy - Destroy all blocks in a block set.
+ * @bs:          The block set.
+ */
+void luo_block_destroy(struct luo_block_set *bs)
+{
+	u64 head_pa = bs->head_pa;
+	struct luo_block *block;
+
+	while (!list_empty(&bs->blocks)) {
+		block = list_first_entry(&bs->blocks, struct luo_block, list);
+		list_del(&block->list);
+		kfree(block);
+	}
+	bs->nblocks = 0;
+	bs->head_pa = 0;
+
+	while (head_pa) {
+		struct luo_block_header_ser *ser = phys_to_virt(head_pa);
+
+		head_pa = ser->next;
+		luo_block_free_ser(bs, ser);
+	}
+}
+
+/**
+ * luo_block_set_clear - Clear all serialized data in a block set.
+ * @bs: The block set to clear.
+ */
+void luo_block_set_clear(struct luo_block_set *bs)
+{
+	struct luo_block *block;
+
+	list_for_each_entry(block, &bs->blocks, list) {
+		block->ser->count = 0;
+		memset(block->ser + 1, 0, LUO_BLOCK_SIZE - sizeof(*block->ser));
+	}
+}
+
+/**
+ * luo_block_it_init - Initialize a block set iterator.
+ * @it:         The iterator to initialize.
+ * @bs:         The block set to iterate over.
+ */
+void luo_block_it_init(struct luo_block_it *it, struct luo_block_set *bs)
+{
+	it->bs = bs;
+	it->block = list_first_entry_or_null(&bs->blocks, struct luo_block, list);
+	it->i = 0;
+}
+
+/**
+ * luo_block_it_next - Return the next entry slot in the block set.
+ * @it: The block iterator.
+ *
+ * If the current block is full, it automatically advances to the next block
+ * in the set.
+ *
+ * Return: A pointer to the next entry slot, or NULL if no more slots are
+ * available.
+ */
+void *luo_block_it_next(struct luo_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == luo_block_count_per_block(it->bs)) {
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
+ * luo_block_it_read - Return the next entry slot for reading.
+ * @it: The block iterator.
+ *
+ * This function iterates through entries that were previously serialized,
+ * respecting the count stored in each block's header.
+ *
+ * Return: A pointer to the next entry slot, or NULL if no more entries are
+ * available.
+ */
+void *luo_block_it_read(struct luo_block_it *it)
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
+ * luo_block_it_prev - Return the previous entry slot in the block set.
+ * @it: The block iterator.
+ *
+ * If the current index is at the start of a block, it automatically moves to
+ * the end of the previous block.
+ *
+ * Return: A pointer to the previous entry slot, or NULL if at the very
+ * beginning of the block set.
+ */
+void *luo_block_it_prev(struct luo_block_it *it)
+{
+	if (!it->block)
+		return NULL;
+
+	if (it->i == 0) {
+		if (list_is_first(&it->block->list, &it->bs->blocks))
+			return NULL;
+		it->block = list_prev_entry(it->block, list);
+		it->i = luo_block_count_per_block(it->bs);
+	}
+
+	return (void *)(it->block->ser + 1) + (--it->i * it->bs->entry_size);
+}
+
+/**
+ * luo_block_it_finalize - Finalize the current block by setting its entry count.
+ * @it: The block iterator.
+ */
+void luo_block_it_finalize(struct luo_block_it *it)
+{
+	if (it->block)
+		it->block->ser->count = it->i;
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 4b6c18348d9b..04f31319ccdf 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -40,6 +40,51 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
  */
 #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
 
+/**
+ * struct luo_block - Internal representation of a serialization block.
+ * @list: List head for linking blocks in memory.
+ * @ser:  Pointer to the serialized header in preserved memory.
+ */
+struct luo_block {
+	struct list_head list;
+	struct luo_block_header_ser *ser;
+};
+
+/**
+ * struct luo_block_set - A set of blocks that belong to the same object.
+ * @blocks:          The list of serialization blocks (struct luo_block).
+ * @nblocks:         The number of allocated serialization blocks.
+ * @head_pa:         Physical address of the first block header.
+ * @entry_size:      The size of each entry in the blocks.
+ * @count_per_block: The maximum number of entries each block can hold.
+ * @incoming:        True if this block set was restored from the previous kernel.
+ */
+struct luo_block_set {
+	struct list_head blocks;
+	long nblocks;
+	u64 head_pa;
+	size_t entry_size;
+	u64 count_per_block;
+	bool incoming;
+};
+
+/**
+ * struct luo_block_it - Iterator for serializing entries into blocks.
+ * @bs:         The block set being iterated.
+ * @block:      The current block.
+ * @i:          The current entry index within @block.
+ */
+struct luo_block_it {
+	struct luo_block_set *bs;
+	struct luo_block *block;
+	u64 i;
+};
+
+#define LUO_BLOCK_SET_INIT(name, _entry_size) {				\
+	.blocks = LIST_HEAD_INIT((name).blocks),			\
+	.entry_size = _entry_size,					\
+}
+
 /**
  * struct luo_file_set - A set of files that belong to the same sessions.
  * @files_list: An ordered list of files associated with this session, it is
@@ -100,6 +145,18 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 void luo_file_set_init(struct luo_file_set *file_set);
 void luo_file_set_destroy(struct luo_file_set *file_set);
 
+void luo_block_set_init(struct luo_block_set *bs, size_t entry_size);
+int luo_block_grow(struct luo_block_set *bs, u64 count);
+void luo_block_shrink(struct luo_block_set *bs, u64 count);
+int luo_block_restore(struct luo_block_set *bs, u64 head_pa);
+void luo_block_destroy(struct luo_block_set *bs);
+void luo_block_set_clear(struct luo_block_set *bs);
+void luo_block_it_init(struct luo_block_it *it, struct luo_block_set *bs);
+void *luo_block_it_next(struct luo_block_it *it);
+void *luo_block_it_read(struct luo_block_it *it);
+void *luo_block_it_prev(struct luo_block_it *it);
+void luo_block_it_finalize(struct luo_block_it *it);
+
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
-- 
2.53.0


