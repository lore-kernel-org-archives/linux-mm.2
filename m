Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F821C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83FA6B01AA; Mon,  5 Jan 2026 11:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D566B01AE; Mon,  5 Jan 2026 11:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5636B01B1; Mon,  5 Jan 2026 11:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCB46B01AA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:59:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66F911A8B08
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:59:08 +0000 (UTC)
X-FDA: 84298520376.15.8E1505C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E44C100011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:59:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTXXkEaS;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgLz2wb6YzYAtKdul4NZXCNshaZWhEAbs1WVt1GJJA8=;
	b=8PIP2IWAf0mWhN3ZVlRsgqrbxMmdqvAylDw+3emEkjei2cAKKR9YsnzY5qMJk4ienxL8Gz
	6Q+1G7M6LghatjQrihQ+R3jRc0YeLCxbf18Dikdefso/S2y8c9t6poNxRm2KEwVeKrWR27
	FPLQRdOWPapt6Q04EEbnnTsrDJIu3yA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTXXkEaS;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632346; a=rsa-sha256;
	cv=none;
	b=G1zI7UtYNSzkUOZm96NRhUv5n1R4Nu1I0diM+GApWEIscq5Vd2X2JSVymaZ3/nDC2aBkh7
	K1NUsxFy+mQTz+Hgo0HFq/vsElkasL9Ah72Ki2O3B3MdGEFDB86sC2IQ6V8q3lyuWCsZVe
	DN/0LeWdVYOJQxi2AdiAVIQ7NpBe4Fg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFA1541522;
	Mon,  5 Jan 2026 16:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1201C116D0;
	Mon,  5 Jan 2026 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632345;
	bh=C6eql9p/ad94rcfI0wx8v7YVZgYVcqqRLJPOYgSXxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTXXkEaSn1qSxmg3X/H4hpPTj0ClyfZ0VysM8X/evDibdhBNIEqIpqRTQiHLfPSjQ
	 O7cxUL8dwnJPNV259iK2NZZUMClYbezs/R9K+JVV2srthxxDylExf3BuBp+3F3/GgF
	 OSIAlUaW5DCi2dZ4sAijlXSrA6oEVkWVQAq/MQZwjsMjjrtQ+hMCrFbqca/GnfLPpN
	 MfJicZnI0UTrfyEtipvhHGOkYeOLG1rGZTYXneZMG8ubqf6oFNYu1ZSZmlMYraCajg
	 44v/uE4G6GkGajG4xib9kC19CZgwZSBUyC41Y8ZY1WYAtWUZYmgfHtbHep7r9zOmDt
	 L+LgHDoV0hiDg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/6] kho/abi: add memblock ABI header
Date: Mon,  5 Jan 2026 18:58:39 +0200
Message-ID: <20260105165839.285270-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E44C100011
X-Stat-Signature: eiic51cm8nb5u4g6371xfwekpcoreawi
X-HE-Tag: 1767632346-874747
X-HE-Meta: U2FsdGVkX1+THaCXVb3+Pg5HBNJA2Ag73Zk4sh1Mztcm0zPgjZx/cV9VYNRRf50A7Khgc/Coq6yuFbuy1KJqbOvX7kibYlQN2BkEM9yUEinT4JjFvxWmFcfaDoKPghkbJkyfuVEf3IRCfXinbT7wgL3FETJCiWXs8tJeIlhXyMg4vujKUPFrfSJzGiL53aBy5YDxVkMM/vfY1/VMrFvvsVmp8h+t+bPOPltIgwEbTsdB9GXXHpG5MSVFibW5YvZBKTjhKUMRPT/6G+xya3FQOftJTYxjc1azSqeWM1QfZcIVRin0GRFCPkzXdKUrl/2hujnKeXzHxY2d62YF/ctN9mLd53aWixKeve4f0FuFxFwk5BKmhUu4pYfy3h2UrE5+nJyzRhvTort634n0g+3rPr472GFmtEfexVt60EPYj2JfjNHIq9JAU/zjKeuGzDAbvjniKTfQf4PA/e9aOZ7y6eDA8mI91yTvy43A5AbQ4qjrYwQfA1ovOMlcHYiCN0jYzWdCYhZkIOyTAOcaWktJ8yrto7B56wFB/B4ES/gge/AG/LnR6Wjl7qMM1V6OXRtSd9qqVTYsF1Djq1i85L2jiyhqHyGD/20qPPiHw5Id+mhHMKR3oimZjuZ7iT29EhWXaoBQ4Wsi0RwBH8cr+piOcxS0vcaUlrjhTX+E5RQnRVe74yztVuCM1UtuXLHK5gB9dqRFPVDEfe9bNPIABL+EUNXZRL2Ju6BDzLmbAuG0trFw1SzA7YhJs3laFCaqWEKIM4i1q/phCGMb72jvDRzCevA7+5YrSCi46uG0HABQ9rHFRexklzsq1dFp23t5VfSf/2PoHc/rzzlyrMmu6Od75HvRdDL8LkwmRyL7WYqdvir5/u0Mmryw+Koee09te/glCrRinGPdRlS4SP8Z7r8mQclYBo8a+yl3GcKeaR+G/V8yqyjjMQJ3lUk8AnfluTfl80ExguOdsEWXB87pTSZ
 ekvbrveG
 gNUJKGn5/7L6GUL//Dq5PPi4yOC8kh5j4e6TuLodbO/9INYO6YBcSNq30HJdFsyqjeeOe6k6yw/WvvuF7Gdq7vq9bjStXGcpFcUKQaTQSro+904yF0mrp4kQtDMb9DZ7pg6R706iME16CJqFE/Z9xzDsz1OuX7xhojS0KZL5g7+JmDmDvdyweoslgWIwv7aBvnzPIxIk/39o+KK1rnHG1w57bFsvwE5HMMuKMk8ecRxsHHog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Introduce KHO ABI header describing preservation ABI for memblock's
reserve_mem regions and link the relevant documentation to KHO docs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/kho/abi.rst            |  6 ++
 .../kho/bindings/memblock/memblock.yaml       | 39 ----------
 .../kho/bindings/memblock/reserve-mem.yaml    | 40 -----------
 include/linux/kho/abi/memblock.h              | 72 +++++++++++++++++++
 mm/memblock.c                                 |  4 +-
 5 files changed, 79 insertions(+), 82 deletions(-)
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/memblock.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
 create mode 100644 include/linux/kho/abi/memblock.h

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index 1d9916adee23..2e63be3486cf 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -16,6 +16,12 @@ vmalloc preservation ABI
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI for vmalloc Preservation
 
+memblock preservation ABI
+=========================
+
+.. kernel-doc:: include/linux/kho/abi/memblock.h
+   :doc: memblock kexec handover ABI
+
 See Also
 ========
 
diff --git a/Documentation/core-api/kho/bindings/memblock/memblock.yaml b/Documentation/core-api/kho/bindings/memblock/memblock.yaml
deleted file mode 100644
index d388c28eb91d..000000000000
--- a/Documentation/core-api/kho/bindings/memblock/memblock.yaml
+++ /dev/null
@@ -1,39 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Memblock reserved memory
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-
-description: |
-  Memblock can serialize its current memory reservations created with
-  reserve_mem command line option across kexec through KHO.
-  The post-KHO kernel can then consume these reservations and they are
-  guaranteed to have the same physical address.
-
-properties:
-  compatible:
-    enum:
-      - reserve-mem-v1
-
-patternProperties:
-  "$[0-9a-f_]+^":
-    $ref: reserve-mem.yaml#
-    description: reserved memory regions
-
-required:
-  - compatible
-
-additionalProperties: false
-
-examples:
-  - |
-    memblock {
-      compatible = "memblock-v1";
-      n1 {
-        compatible = "reserve-mem-v1";
-        start = <0xc06b 0x4000000>;
-        size = <0x04 0x00>;
-      };
-    };
diff --git a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml b/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
deleted file mode 100644
index 10282d3d1bcd..000000000000
--- a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
+++ /dev/null
@@ -1,40 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Memblock reserved memory regions
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-
-description: |
-  Memblock can serialize its current memory reservations created with
-  reserve_mem command line option across kexec through KHO.
-  This object describes each such region.
-
-properties:
-  compatible:
-    enum:
-      - reserve-mem-v1
-
-  start:
-    description: |
-      physical address (u64) of the reserved memory region.
-
-  size:
-    description: |
-      size (u64) of the reserved memory region.
-
-required:
-  - compatible
-  - start
-  - size
-
-additionalProperties: false
-
-examples:
-  - |
-    n1 {
-      compatible = "reserve-mem-v1";
-      start = <0xc06b 0x4000000>;
-      size = <0x04 0x00>;
-    };
diff --git a/include/linux/kho/abi/memblock.h b/include/linux/kho/abi/memblock.h
new file mode 100644
index 000000000000..fbfb2eb1b1cf
--- /dev/null
+++ b/include/linux/kho/abi/memblock.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_KHO_ABI_MEMBLOCK_H
+#define _LINUX_KHO_ABI_MEMBLOCK_H
+
+/**
+ * DOC: memblock kexec handover ABI
+ *
+ * Memblock can serialize its current memory reservations created with
+ * reserve_mem command line option across kexec through KHO.
+ * The post-KHO kernel can then consume these reservations and they are
+ * guaranteed to have the same physical address.
+ *
+ * The state is serialized using Flattened Device Tree (FDT) format. Any
+ * modification to the FDT structure, node properties, or the compatible
+ * strings constitutes a breaking change. Such changes require incrementing the
+ * version number in the relevant `_COMPATIBLE` string to prevent a new kernel
+ * from misinterpreting data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is incremented.
+ * However, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
+ *
+ * FDT Structure Overview:
+ *   The entire memblock state is encapsulated within a single KHO entry named
+ *   "memblock".
+ *   This entry contains an FDT with the following layout:
+ *
+ *   .. code-block:: none
+ *
+ *	/ {
+ *		compatible = "memblock-v1";
+ *
+ *		n1 {
+ *			compatible = "reserve-mem-v1";
+ *			start = <0xc06b 0x4000000>;
+ *			size = <0x04 0x00>;
+ *		};
+ *	};
+ *
+ * Main memblock node (/):
+ *
+ *   - compatible: "memblock-v1"
+
+ *     Identifies the overall memblock ABI version.
+ *
+ * reserved_mem node:
+ *   These nodes describe all reserve_mem regions.
+ *
+ *   - compatible: "reserve-mem-v1"
+ *
+ *     Identifies the ABI version of reserve_mem descriptions
+ *
+ *   - start: u64
+ *
+ *     Physical address of the reserved memory region.
+ *
+ *   - size: u64
+ *
+ *     size in bytes of the reserved memory region.
+ */
+
+/* Top level memblock FDT node name. */
+#define MEMBLOCK_KHO_FDT "memblock"
+
+/* The compatible string for the memblock FDT root node. */
+#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
+
+/* The compatible string for the reserve_mem FDT nodes. */
+#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
+
+#endif /* _LINUX_KHO_ABI_MEMBLOCK_H */
diff --git a/mm/memblock.c b/mm/memblock.c
index 905d06b16348..6cff515d82f4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -21,6 +21,7 @@
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/memblock.h>
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #include <asm/sections.h>
@@ -2442,9 +2443,6 @@ int reserve_mem_release_by_name(const char *name)
 }
 
 #ifdef CONFIG_KEXEC_HANDOVER
-#define MEMBLOCK_KHO_FDT "memblock"
-#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
-#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 
 static int __init reserved_mem_preserve(void)
 {
-- 
2.51.0


