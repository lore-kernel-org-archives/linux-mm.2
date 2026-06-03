Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F519CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02EF76B0099; Wed,  3 Jun 2026 09:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F212A6B009D; Wed,  3 Jun 2026 09:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74036B009B; Wed,  3 Jun 2026 09:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C12EF6B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:06:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C2FCC188E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:18 +0000 (UTC)
X-FDA: 84838624836.22.E4166D6
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 50B1C40013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Oxfgazlu;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491976;
	b=gpffM0K8orFofJ6RL2PVha0l3eOwrNYTpvwXEm365mxkwvtRe2wIHSGr4z3V/62q4xuTsF
	rMiKlTnsYHYnmtcTL/Hmty9RuoPZq03JQRBYoMr8OtGGsxKG9FvDXoW3fL+lQiUc1REQMY
	ysO6sBj6k+L0CJEyzZ877LKbJKQ8pYc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Oxfgazlu;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iV51OI5GB1SwhOBsu/JVwt8SKq7L6n2Bh6/sNMVT8To=;
	b=7pKayhLnzsKai2VjAbhx4Zs1bt6In7efMXwBtB4YC4sJNF2j6NCFkEaNjJOv1HR75Gt7Iw
	yaLtdqTnDbb7OL65AigUS60K+OL+aogE0qgiDR/VpeUZwgIyjtU9j8n0OilxlxBw/7chjp
	k/wm0AlRoga9nJtTLsAnql4TR1Wyt7g=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e66f966d01so4389467a34.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780491975; x=1781096775; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iV51OI5GB1SwhOBsu/JVwt8SKq7L6n2Bh6/sNMVT8To=;
        b=Oxfgazluh8pSQhxFeqO+wph7WVOcBjjRYHzkV0FbB63C/JKzYenLMX350Y5OHG3e61
         xhL4szpSIAiOSfOIcwbAiyV5Wyoca896ecngRDwbJQSSEuD1yBvoOP/8q/Sv8d28xKH4
         0xVRCsES4Y/ncsgJAI4s57JaHeJbtNF/cMT8rARX8D9v9wrqDOw3WPOtcyQj1g9H1PFa
         j/PUyLHRY7e9fT77I7z7G3t+slUIDe5f+c/pz8Ll/5/7J6/0k3VDQyzLwSCHWy3aqIDi
         K5PL9igWic4VMunsIY2dIebBh3map8C7+0dNO3Tp5AIpx4NtUR0AiHIkp24Muy0Jyfin
         HGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491975; x=1781096775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iV51OI5GB1SwhOBsu/JVwt8SKq7L6n2Bh6/sNMVT8To=;
        b=nUA9RMGHhk/tZMEstCOK+lZIfG2OevHQDdlwqCTotUX60KcoIWBDpW8G/Iy2Ku0M6o
         wLA/8AHwYHFEC0i56FxkyUHYtqceJOz05t600K+hK9UJCtDk8ILrrRuZLJcAOHDp8t7b
         zB1dTAcSYV3z8cT773EBjy78z9fhXSEbuAZ5ZdZPV3kBQrgdTT13Wrm85a4nI+chM+5J
         YwPttdF6DLjCO9FlyJ72unc8rRJKEtJZdmDwVDe+1IRR047QQlGR5khZYmPNx18ei6M6
         31Es/bMb+I9RbXO5DkepTGHr3QGKGzoyS5Fj2vUOUV8Hq7hJ5y4b0bfFsF24FtNSM1Fo
         9MnA==
X-Forwarded-Encrypted: i=1; AFNElJ+7KhwvwqAsZA2NLvk++2F6MzUGQMDji4OuEvjRuCa7UM6XtIUCCcOn2kNm9lSeAXTAUjl7dg1EVg==@kvack.org
X-Gm-Message-State: AOJu0YxF/3kjOhcuvGjRdsoCBZDMOUSgE/6as8wtpYEIe3m8itIr9lSF
	QI9HmgXySjH3S/MY3hj3x9eiT8CitELxQ7SBB66SKfrEQB9oF1xUssPldVmSjs0ofwY=
X-Gm-Gg: Acq92OHZbPX2+Jy8j97aa0haLrHg0ZRTcpj73fHETxKDf/PF5/QuKAnaZYFheoJbHtn
	8I7dKaaB+t9d0bDiurNzVG4SxATBk/h5ZvTDAeDR0vmxmcNRT+gr3C5taHywBlt2mA8mElwebR9
	zwIY1MiCb4rKcEC7paoCiuZJ6kgApsep/v167K3AWwNUCbqv0b+lw1N0PHcJqYBArkq31yFX3rh
	p+I0juWZrF20+eAEFgwHFA4lIro+ycbbtbn87tVHDUXZQUXqLODKtOh/QKDpoUSCcHL51RK1ZJU
	vN80AsYoVvpjPq6o0LYK2WCNHD7AsCNk7OBAfyCAT2rbmrGWW95Stp1AN8+mrORzxpWKQbEPOrp
	AmTQbEC4wNiAEIZGFCGPMaUpTHlylwUYJscxD3UKqVoRh7pG9OoF7DLc2SfSWRc1advzHwrXC0u
	BX06kHZ6wHMC0egODG/sM6s8qgLDI/hJvJO4RVzaT1tkNqqZLlai4dif6OMMfDMw==
X-Received: by 2002:a05:6808:50a2:b0:47c:be93:9214 with SMTP id 5614622812f47-4865a97f66cmr1774141b6e.20.1780491974661;
        Wed, 03 Jun 2026 06:06:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd07629dsm19450276d6.39.2026.06.03.06.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:06:14 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v6.1 07/13] kho: add support for linked-block serialization
Date: Wed,  3 Jun 2026 13:06:12 +0000
Message-ID: <20260603130612.397948-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aiAgHTbleCL60SYm@plex>
References: <aiAgHTbleCL60SYm@plex>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50B1C40013
X-Rspam-User: 
X-Stat-Signature: azforc8j1pjegje4ygsi7xm1x64o6u5t
X-HE-Tag: 1780491976-281357
X-HE-Meta: U2FsdGVkX1/X/pq4PQOolC+NptYogOwGjxEWTDZ03+h4qQDM8JJFb3AH7xzYvOMdrAuNeCYPbl4iNkdBHIV2vI1koC5lSi0w1XPEQMegiN0SjzX1Blm2iY/oKvjQHQj6EpBod4RAg4EnqazwaszwUhLoGChUTBSEWFghIwwYvhiRJByC4z3Se0EhlkmcpjYVQ75rlHglv6fFi8lTHCLDdjykC7hKa9+Ba2ms7catehaS++Tjyoma7RmkHRCPRdb4h7xchoOI0gMZ4zObnSIhsKMJx9FE0rKrhrHdsNVgCYokrPGr976tc4wy5jcBiAYOYDGPZLQIHbzlWUZKwBcs+//QvUu9lRZWzRaFiLkw1B1xPsNkVTCXLoOWQ6UXtiRmKRVaC+Swle7u0v13Aod4SK21R+sKnl7ObEVNfh2ZX2KYpDz3q0Kj5aX4EZtxfTIILnrkWbuvS+lg/Zvswh8aze388ONeoILWPMg0LFkfRE3dpS89rKtsvEr+rdC9pbacGFW81fABSVK8LG6ULA2h6CwYrXlqQzVePOBq+7vZvq2+a3C3R+e42Cv9NnqHZVcft/lYn0X6pY/4xq/naWe2SxSlKM/Vr2u+UUKLFyned4EWEh7+UmvXmQQbEhkoJWE8GanI4/CIz/2P1y2x2gPU9D3/7g9UAmx0ZrhU0rKyo8MwmPo6T1xJvTj/JwFvQLBkFWLl93rdEuHRY5I1l0OvamEEXUH45JgnftnhGrU1h8IXFugNR46a6upF9SniZ0Jl/N1/TmYDjI5rIcqE3xszoSmMCHilK8BqENiN3q57rB9DaGaE1MeHOe/qkGqT/srFroYHz9G9xxcJUIGu1Y0q7aw2nTXpCuWWZz9mncEvcdqCMY2dPWjI7wTFbKf5qds0fgy1jIJqJy5CI0KfhyeB/cAEscf0orPE2hs5lE4IV+yNSmQrH2evVjKMlNiR23qliiN5nZzdxRF5gduJLef
 BYfDhETP
 aR4FOmFXuInneYkWKcVht/TCWo9y/k4epjRvxjgXID6HBT99Qgt1kDFBmw/HGDcQcN1Mpat2QZVFXVLpd1ZqutZXauS+QjxSip+pRzP/TmN08m7lytvbam1IqTrx9t5HwKrgPpF6o8YNyIUhdgSIHa6bBZRSymJQ22wF+C/2HzmBEimTXRkXHb2qy8DiEOZWx3LwK7C+MaoaLX766s3FeymNHcev8n4RecJ3SBMZBO4SeY7OQH6lZiI2DYP9AQgoNmHXAbdQDkQHZPO43gzrWZwvZXZ9I/7dY7U0N
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
 kernel/liveupdate/kho_block.c        | 416 +++++++++++++++++++++++++++
 7 files changed, 596 insertions(+)
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


