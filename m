Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E530AC79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9956B01A7; Mon,  5 Jan 2026 11:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479FC6B01A8; Mon,  5 Jan 2026 11:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3793C6B01A9; Mon,  5 Jan 2026 11:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDD06B01A7
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:59:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D423A1A00E8
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:59:01 +0000 (UTC)
X-FDA: 84298520082.25.018ADDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19E3A1C000C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZf+Ccg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632340; a=rsa-sha256;
	cv=none;
	b=zHXiStAWVw6LFwGRbfkbtZEElfrvamebxwKxlT709AOGxocAGLm9TaP4TCWRBPlS9o6XJb
	CpXt5wqSDKs2bi/TKXsJf6JD70NN7Uvz40h5Y4BXYdz+VtL4M4Utc+8vmjZaK4wLKalp/z
	nPCdQF1w80E20f3msD+HSg/vIWDkTVo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZf+Ccg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lR9lFcIUfiEDDf8UfNlF6cjIxyN0XuD9PmMnRXMtipQ=;
	b=O4AYuf+oqeN35YqbcnzSXdLM/l9XrRFVGPZ8rskdK69jQi97aF5G68Y9DTFE6SGSI9G0Fb
	MVeEPwCzFjUo2mBbW+ReYogug/UK4ZxhyzB0kR4Wr5z4p5pMYpnFaCLLqgDNr+d8EAiU+8
	zFJnWtBl4VoAuWwVwV0PKCFW4sqj968=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43185442B3;
	Mon,  5 Jan 2026 16:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B1C19425;
	Mon,  5 Jan 2026 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632339;
	bh=bIQMAPcxuOsBaF4PLdQVGqVPD+HPraAAKSr5Z/xpgSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZf+Ccg1cxHKgvmEg2TsaZWOyPTIKLAzhhOxzQ7x3/0bXveleD2q6oS/d99TnAKTV
	 M9fSV5IWfHD5oYAgKe6UAAP5xZAFZSk3Pswd9bQhCGWYHjPiYZ6nk8p0Ul+XKcEnet
	 g0nOsBO6N/5MDILPqfPOkbXgBSvYKRWQDbxjQa4+8QQwIH86ezhq9HySwSOWKSKBjB
	 pJ9DQH7UOmQegFikwjem58P+ek22ZZZP01S3kdyIR+PnNSalwLGa+w3KK0Qwytyyll
	 LaPpRL9PfPoQpdLQ2ZNAyt1yYMihipZ6DEIGnkUTNs1pOpMn0yq1cu/V+9ttyQag5n
	 NsnCNRFwFF3Qg==
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
Subject: [PATCH 4/6] kho: Introduce KHO FDT ABI header
Date: Mon,  5 Jan 2026 18:58:37 +0200
Message-ID: <20260105165839.285270-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19E3A1C000C
X-Stat-Signature: 4fpi9jx78mxe9oocsjkxdw1csibb8rx6
X-Rspam-User: 
X-HE-Tag: 1767632339-749063
X-HE-Meta: U2FsdGVkX18gaNzXfkVLMpEFKAEUp7nEmszqP/uexF1fQayW6H4J4iEtXL0FtafZO7x0MQ9L0/P1AORIZ6wRtC3jNMHEGr8EMUsCMeLBMZDA2m5PwyWZQ8DDm3mXkiHROLMoihzCGHRodZGE0iyo3QvqjmEvU+Lnfx67rrtu5yV0ajhiiF+mIOHg1FloH8rYPJmj81b43Ct8M/nmMWdVoOgI1Y/3O9j0FKip6TkvYIbJ7CHGpLZmnKmtu5fDkSslgH0hq2/svzJOCIxBelkNoGOPWNFEpgsewcIrYjsOU+b42QLUtFjfaI2y5BWPM9qdJslhZcLI++SCf33sP1HSMWYSrG4T93q9VZ4TKZoOfuhGXmx4Rbd25HMkXrIyB6bbuuNgIngGA5sbjhi8x8VdA1VqWz39AbCB5dpkEh7EPQEreR976bt6SfEzwdEt0Hmx0ifUGaPSmKEL69STzNDzpWqIUF6JVFltuuMAMe71jnj9DV7mwukLwps/lpinYnxEboEsoa2fn6kuB9WoOdn5x2Av5hxSOzZ+dAUODhN29u38B5Wd6O3KCjiOxQDERRmsPE1GCBgV/hDAhL0xySZ6L4yCKgI6uP1r/CYRMQOUoJVZgteS2ccH6/zwerjcppbfGfmEYLqLDHVdussrflEIPocLhGgql/yfoty3+a4L3S1W7TQAaACH4vvrkWnTEsAQZ2ZTlFJVjPqzeYH40sIXLyNNkVQWMGTdVCUMQRxQR6uy3jEX/qHbE+1hYr7NTplP8co12X+o5h4AzlxrSb315rzLq7+reKCsdHmDAY94iw7SazPFJm5sz6EuOXW9LsIfLw2Zc7w2C7isOhK6A/nlwz+uvjtFhs06cvdkz8iT1iIwR8I3o8PwFrTz3X+DIlgpjHeddyj4zN2vrPtDMt6EyO8//zHIEZGVDCyOB3BnX2XhzsjGgk1cYhYy1sq2VchPEz24w9zXmThCIQlSfEP
 Sq69p7RM
 6fV1k1ZZ6CxN92ePPdi5Um1Mbfid+seVqguil5gFbFKD+jK9tsBGECC1DVz5vKZabI2RKmm8SQKBFRFHHGLCHGKFYTAmH466RYenC3sieBXTW0k8PKTTRGmn61blgPCdr86Xua2XheFzJg3H5eI3C6cSvK/ROoEPK3hOiFwAp3ZcjOxRbF/+tsjTvqW2JuJzjcfimoYRXzFyvI20ACuux60DDjPmYcnQVMBeJ45S85eJkUNk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Miu <jasonmiu@google.com>

Introduce the `include/linux/kho/abi/kexec_handover.h` header file,
which defines the stable ABI for the KHO mechanism. This header specifies
how preserved data is passed between kernels using an FDT.

The ABI contract includes the FDT structure, node properties, and the
"kho-v1" compatible string. By centralizing these definitions, this
header serves as the foundational agreement for inter-kernel
communication of preserved states, ensuring forward compatibility and
preventing misinterpretation of data across kexec transitions.

Since the ABI definitions are now centralized in the header files, the
YAML files that previously described the FDT interfaces are
redundant. These redundant files have therefore been removed.

Signed-off-by: Jason Miu <jasonmiu@google.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/kho/abi.rst            | 16 ++++
 Documentation/core-api/kho/bindings/kho.yaml  | 43 ----------
 .../core-api/kho/bindings/sub-fdt.yaml        | 27 ------
 Documentation/core-api/kho/index.rst          |  9 ++
 MAINTAINERS                                   |  1 +
 include/linux/kho/abi/kexec_handover.h        | 85 +++++++++++++++++++
 kernel/liveupdate/kexec_handover.c            | 19 ++---
 7 files changed, 120 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/core-api/kho/abi.rst
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 create mode 100644 include/linux/kho/abi/kexec_handover.h

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
new file mode 100644
index 000000000000..a1ee0f481727
--- /dev/null
+++ b/Documentation/core-api/kho/abi.rst
@@ -0,0 +1,16 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==================
+Kexec Handover ABI
+==================
+
+Core Kexec Handover ABI
+========================
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Kexec Handover ABI
+
+See Also
+========
+
+- :doc:`/admin-guide/mm/kho`
diff --git a/Documentation/core-api/kho/bindings/kho.yaml b/Documentation/core-api/kho/bindings/kho.yaml
deleted file mode 100644
index 11e8ab7b219d..000000000000
--- a/Documentation/core-api/kho/bindings/kho.yaml
+++ /dev/null
@@ -1,43 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: Kexec HandOver (KHO) root tree
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-  - Changyuan Lyu <changyuanl@google.com>
-
-description: |
-  System memory preserved by KHO across kexec.
-
-properties:
-  compatible:
-    enum:
-      - kho-v1
-
-  preserved-memory-map:
-    description: |
-      physical address (u64) of an in-memory structure describing all preserved
-      folios and memory ranges.
-
-patternProperties:
-  "$[0-9a-f_]+^":
-    $ref: sub-fdt.yaml#
-    description: physical address of a KHO user's own FDT.
-
-required:
-  - compatible
-  - preserved-memory-map
-
-additionalProperties: false
-
-examples:
-  - |
-    kho {
-        compatible = "kho-v1";
-        preserved-memory-map = <0xf0be16 0x1000000>;
-
-        memblock {
-                fdt = <0x80cc16 0x1000000>;
-        };
-    };
diff --git a/Documentation/core-api/kho/bindings/sub-fdt.yaml b/Documentation/core-api/kho/bindings/sub-fdt.yaml
deleted file mode 100644
index b9a3d2d24850..000000000000
--- a/Documentation/core-api/kho/bindings/sub-fdt.yaml
+++ /dev/null
@@ -1,27 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-%YAML 1.2
----
-title: KHO users' FDT address
-
-maintainers:
-  - Mike Rapoport <rppt@kernel.org>
-  - Changyuan Lyu <changyuanl@google.com>
-
-description: |
-  Physical address of an FDT blob registered by a KHO user.
-
-properties:
-  fdt:
-    description: |
-      physical address (u64) of an FDT blob.
-
-required:
-  - fdt
-
-additionalProperties: false
-
-examples:
-  - |
-    memblock {
-            fdt = <0x80cc16 0x1000000>;
-    };
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 03cd9afbdb2e..f56579b5c351 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -29,6 +29,15 @@ can retrieve and restore the preserved state from KHO FDT.
 Subsystems participating in KHO can define their own format for state
 serialization and preservation.
 
+KHO FDT and structures defined by the subsystems form an ABI between pre-kexec
+and post-kexec kernels. This ABI is defined by header files in
+``include/linux/kho/abi`` directory.
+
+.. toctree::
+   :maxdepth: 1
+
+   abi.rst
+
 .. _kho_scratch:
 
 Scratch Regions
diff --git a/MAINTAINERS b/MAINTAINERS
index 12f49de7fe03..cadaa9270346 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13959,6 +13959,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
+F:	include/linux/kho/abi/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
new file mode 100644
index 000000000000..af9fa8c134c7
--- /dev/null
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/*
+ * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
+#define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
+
+/**
+ * DOC: Kexec Handover ABI
+ *
+ * Kexec Handover uses the ABI defined below for passing preserved data from
+ * one kernel to the next.
+ * The ABI uses Flattened Device Tree (FDT) format. The first kernel creates an
+ * FDT which is then passed to the next kernel during a kexec handover.
+ *
+ * This interface is a contract. Any modification to the FDT structure, node
+ * properties, compatible string, or the layout of the data structures
+ * referenced here constitutes a breaking change. Such changes require
+ * incrementing the version number in KHO_FDT_COMPATIBLE to prevent a new kernel
+ * from misinterpreting data from an older kernel. Changes are allowed provided
+ * the compatibility version is incremented. However, backward/forward
+ * compatibility is only guaranteed for kernels supporting the same ABI version.
+ *
+ * FDT Structure Overview:
+ *   The FDT serves as a central registry for physical
+ *   addresses of preserved data structures and sub-FDTs. The first kernel
+ *   populates this FDT with references to memory regions and other FDTs that
+ *   need to persist across the kexec transition. The subsequent kernel then
+ *   parses this FDT to locate and restore the preserved data.::
+ *
+ *     / {
+ *         compatible = "kho-v1";
+ *
+ *         preserved-memory-map = <0x...>;
+ *
+ *         <subnode-name-1> {
+ *             fdt = <0x...>;
+ *         };
+ *
+ *         <subnode-name-2> {
+ *             fdt = <0x...>;
+ *         };
+ *               ... ...
+ *         <subnode-name-N> {
+ *             fdt = <0x...>;
+ *         };
+ *     };
+ *
+ *   Root KHO Node (/):
+ *     - compatible: "kho-v1"
+ *
+ *       Indentifies the overall KHO ABI version.
+ *
+ *     - preserved-memory-map: u64
+ *
+ *       Physical memory address pointing to the root of the
+ *       preserved memory map data structure.
+ *
+ *   Subnodes (<subnode-name-N>):
+ *     Subnodes can also be added to the root node to
+ *     describe other preserved data blobs. The <subnode-name-N>
+ *     is provided by the subsystem that uses KHO for preserving its
+ *     data.
+ *
+ *     - fdt: u64
+ *
+ *       Physical address pointing to a subnode FDT blob that is also
+ *       being preserved.
+ */
+
+/* The compatible string for the KHO FDT root node. */
+#define KHO_FDT_COMPATIBLE "kho-v1"
+
+/* The FDT property for the preserved memory map. */
+#define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
+
+/* The FDT property for sub-FDTs. */
+#define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
+
+#endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..d3d02a9ea391 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
@@ -33,10 +34,7 @@
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
-#define KHO_FDT_COMPATIBLE "kho-v1"
-#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
-#define PROP_SUB_FDT "fdt"
-
+/* The magic token for preserved pages */
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
 /*
@@ -378,7 +376,7 @@ static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
 	void *ptr;
 	u64 phys;
 
-	ptr = fdt_getprop_w(kho_out.fdt, 0, PROP_PRESERVED_MEMORY_MAP, NULL);
+	ptr = fdt_getprop_w(kho_out.fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, NULL);
 
 	/* Check and discard previous memory map */
 	phys = get_unaligned((u64 *)ptr);
@@ -468,7 +466,7 @@ static bool __init kho_mem_deserialize(const void *fdt)
 	u64 mem;
 	int len;
 
-	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
 		return false;
@@ -733,7 +731,8 @@ int kho_add_subtree(const char *name, void *fdt)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
+	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
+			  &phys, sizeof(phys));
 	if (err < 0)
 		goto out_pack;
 
@@ -764,7 +763,7 @@ void kho_remove_subtree(void *fdt)
 		const u64 *val;
 		int len;
 
-		val = fdt_getprop(root_fdt, off, PROP_SUB_FDT, &len);
+		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!val || len != sizeof(phys_addr_t))
 			continue;
 
@@ -1310,7 +1309,7 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	if (offset < 0)
 		return -ENOENT;
 
-	val = fdt_getprop(fdt, offset, PROP_SUB_FDT, &len);
+	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 	if (!val || len != sizeof(*val))
 		return -EINVAL;
 
@@ -1330,7 +1329,7 @@ static __init int kho_out_fdt_setup(void)
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
 			    sizeof(empty_mem_map));
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
-- 
2.51.0


