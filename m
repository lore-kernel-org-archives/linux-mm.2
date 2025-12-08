Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5303BD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE046B0030; Mon,  8 Dec 2025 01:35:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7EEF6B0032; Mon,  8 Dec 2025 01:35:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F92D6B0088; Mon,  8 Dec 2025 01:35:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 899D06B0030
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:35:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50D1AC09E5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:27 +0000 (UTC)
X-FDA: 84195342294.13.5E4F38D
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CA1012000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M7DLv8ce;
	spf=pass (imf29.hostedemail.com: domain of 3rHE2aQgKCLkiZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3rHE2aQgKCLkiZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
	b=l687M54dWE72fjqHip8G1mKeLtY2INIICouLR9OYGdpJDoefjNsCLBPfAAYCEliK4XCB+R
	+S9zbWDItrFtByBaJuR96YlmBJtx99znycNkJYCtIPh5JKmyWfA2QwqeIaigwvjRq+CP31
	JurU3tkd+cBtH56U3NaWMd+bjtTyH/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175725; a=rsa-sha256;
	cv=none;
	b=32vqlxDbnu9urrRpjpGtPo1XNoj4CWzmhfHv48DCaancTk0YoaGrQjIQLukfs8XzqJsdDP
	gsGLx7uz6pPyObtv2H5OGLPJ068Nu0b0ICX3o+ZkLB/Dc/GKSWa9L2SM0VWERpAGoO84Hh
	5AU4MmhGmSmkg5SG7EmpY6FfotDx/wI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M7DLv8ce;
	spf=pass (imf29.hostedemail.com: domain of 3rHE2aQgKCLkiZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3rHE2aQgKCLkiZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2a45fea6efbso6122309eec.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765175724; x=1765780524; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
        b=M7DLv8ceUniv/nSzkvScRJ7Tgy/BLZV1D8cN60ja+DjEAPB6uJ4wv/75721uqwWAHM
         jOzTB3J2TJgu8zzdGcCMEV8qE2WeXCTlPxNwhHFDwtO3l/PR+WP7g14u+vEUFk3FPNOp
         Pbr0PjG/7+YJEZ/73c24dEUX3s6xt7zwGEn1BMGP+dC6AmQu0/oyqmpcTWxUyCqrpXbG
         o4xlzBINGNnRBEuqRhk83GtV6sgYfdAx16JD3u97ADHYXat6bu+UbQDgfaL2e/9KPk57
         Gtr6QBliC5CyOxYUSN/hGuflLGYwEqx8ebSA+Cr8CgJccn/MNhClJM2oiL+wlHULn1O4
         Rxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765175724; x=1765780524;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
        b=twjemgaLMPLo40VKpewksew8Tlkec9la5Ott8DkOnekY8AM7T3FlKiU8WlxmCIM3Qf
         VZrXbqHmyz+ibwFbl8VMDuvO2thwjZGhlveDBr7IWY22raO87Z9l/NJH3aBP5PF5t/bZ
         VZFTEh3cpNLK1Tap6pR2WfOgkeoevy8f6Rc53iTdpGoKz23ma3tJRuO9iLJ0B1rNReM9
         RiagM05SsurfrCCgjLdxjr9oR/JTqBISJ32yfcckUBIpjD5oP55fT2FUwH7iiYIHBP4h
         YZxw/9oPookbsfN5N1u4QiHNDT9YHnsSfP6o2X+bDHvDLcxYL9rRFOsnTa2y5LJmgsmn
         69hQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLiMJQnALk14vfaeni2q2Tc26Swfz0NXMlW9f8AjzW/EGB5c6yIz4wA6qbkybE5r+rmV1QrcNWQg==@kvack.org
X-Gm-Message-State: AOJu0YxTTw/Xx2BOgS+0OV8Y+X1QlVP3CSCqCoRTAFvGpBx4lBdgaSrP
	2nb0Dm/KOhhvVKeMizzlBRhX60/4l1DhZgSxafKHOkvEcPR95BL+xe91WshuJH8jXkWm7zCCvQD
	EGN1wSPOW+fnLQg==
X-Google-Smtp-Source: AGHT+IE52W/7TLCYcpmlAdIuWyjwOhdTqcu4K+TbfvCAqg+fup4VReiWzpmBimfJipR5TfiJCImuAU4n5P+1rw==
X-Received: from dlbsy3.prod.google.com ([2002:a05:7022:fa03:b0:11b:1966:8735])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:d04:b0:119:e569:f85b with SMTP id a92af1059eb24-11df601cb27mr9499750c88.18.1765175724135;
 Sun, 07 Dec 2025 22:35:24 -0800 (PST)
Date: Sun,  7 Dec 2025 22:35:10 -0800
In-Reply-To: <20251208063513.3633942-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251208063513.3633942-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208063513.3633942-2-jasonmiu@google.com>
Subject: [PATCH 1/4] kho: Introduce KHO FDT ABI header
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7CA1012000C
X-Stat-Signature: kqxpeyzu79xn37ctmjf46tn9soeiy34y
X-Rspam-User: 
X-HE-Tag: 1765175725-815824
X-HE-Meta: U2FsdGVkX1+KLMOmOLDqkwIEU2DxAsHgQM4qd6f1UUFFT7XXIpYn2diQHf0sObG40iyfd3dTvJNfdMZwHIrf0hbb+e1mQeE7hfVq1nCwDAA1rwDYQIrNSyzqmoGpO06dBnhFsh0SFc1ajvyQxTsKlGOV5OuKH0D5fA6Ag76INo+7HYdd+azNzzZ+PpNcyE4gxFcTYP9Xhc3pgrmUuPedyC3xpm1LBEy2s/spfBmMcBFenIUQwuKKhpVvCuRboaVcpGQ8hyqg+BrGK61hoyzcI5v/qEdVj4TQGyCzCRQ9jvG3/AgoqN5HSioQdzEeD9BrpYdnncyZLd3FKyNX5J0C1iLNr6NQJP0lPpEWGO1RHxhOkHnCk8hiqmU/PivlzmXcmvfSL9PCrDJSj8+xczJhY7Z2UwlR1cCj7PKTcWNxG+zgE7oM2qEn1vp8hdxj2AVJt0zbfGg+xi9RHSLeDoJhPPPE3WyYJx6mCH+VMYVMdGfSy1FRsM3g4+U0zshrKtce4rszQ0FU0oHmZ9Qg1pWXkji7wTdxAANZckDQMnK0n//RwcVZaSS2df1twWSspc6O3D3FkcPk0FC/RYTc54cj/GTbS10P3Y+P1RPyE5ssjKc37klTKtWsAI2OM9aMf6IostVwG0955yUpLwyP1DsV7biY8v93BUfNCJxY1uiaR+QW8K6b5YEzHcCZWPvPF7GttcCS81yDLTho9aeCHqo4YvklH7HTFQN8CiHfsHicV3O2kbZNt8uAwhl0vs+NOqTF+YMTu8MHLJN1PktChGmLqFkuxcfGQTMElh7Ckj1E/SV+Zrmf0Md5TnBtVzD68uhMbwOx7IHLCNTykDrTehHOQhZCUM97Rnj8UZ+R3dxoTg7OqV/S7ZuD1JWXwVOX0AKibapwoIFlvFCy/y9WBE7SpngulxvhZC5NmmEWifiHNqDlJ7YsuULftbIQspXG6Yse4lhxN4E9SfHGhbfqZLc
 CCAVcu/o
 vjp7q041KCYeJxwO62NDV/Y0Hpo7UfpcAzw1OaPrJQk409gBDZMOwYTFU1VUAizyA76oD+3aA0ybRQBfrqoQQXdzpXIJFEnHp47FFz5eMvnQM1pOK8mMdCeSDjhYQvwX23puQRNWC32FaynVU5MGpeLBtNQnaQOMwl8wjcvUyFgR4syzcv39a3UptrGYGGwCkO7rt6BKmuzBEUETCjatmxhZ4PfqKDg2rzwMX8cUF9p+I0LhC46v5jVp7m42HAmTu6C/ttj4tOC6CbZuukZ78VLYjR9RSJuPPpY7DFA6wbhUKuLsyY7Z7NZlUlKniUd0zSgk6jiMkRVNGbKoMhJHU7jeLcZPPU4P6JFlwVoc8I1NvVM9hFOJdFqQOjeZHIglYb1xvz4smWCM5HeQGvv9xEoVolTtnA24DetZxm/zgBtZMNpYGEj0eIgTYdMKFRrAUiqTlbsqFCOgaZAumwh2byxKOxroZ36sk/DpWuBDT0P3TC+Ai8un08KCSg7ZbiDMYVBijcvJ/5w1lfEXYx7H2daAa6t/GMgtj1TEJf7c6AF0VHGnrfa0ur6ZG38WuTHAHpK9BHmYMPelXFFrAls88+SLqsQAMFFzi4ojv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 Documentation/core-api/kho/bindings/kho.yaml  | 43 ----------
 .../core-api/kho/bindings/sub-fdt.yaml        | 27 ------
 Documentation/core-api/kho/concepts.rst       | 13 +++
 Documentation/core-api/kho/fdt.rst            | 79 +++--------------
 include/linux/kho/abi/kexec_handover.h        | 84 +++++++++++++++++++
 kernel/liveupdate/kexec_handover.c            | 19 ++---
 6 files changed, 116 insertions(+), 149 deletions(-)
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 create mode 100644 include/linux/kho/abi/kexec_handover.h

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
diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
index d626d1dbd678..e96893937286 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ b/Documentation/core-api/kho/concepts.rst
@@ -72,3 +72,16 @@ Public API
 ==========
 .. kernel-doc:: kernel/liveupdate/kexec_handover.c
    :export:
+
+Internal API
+============
+.. kernel-doc:: kernel/liveupdate/kexec_handover_internal.h
+
+.. kernel-doc:: kernel/liveupdate/kexec_handover.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/kexec_handover_debugfs.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/kexec_handover_debug.c
+   :internal:
diff --git a/Documentation/core-api/kho/fdt.rst b/Documentation/core-api/kho/fdt.rst
index 62505285d60d..4e080ccc420e 100644
--- a/Documentation/core-api/kho/fdt.rst
+++ b/Documentation/core-api/kho/fdt.rst
@@ -4,77 +4,18 @@
 KHO FDT
 =======
 
-KHO uses the flattened device tree (FDT) container format and libfdt
-library to create and parse the data that is passed between the
-kernels. The properties in KHO FDT are stored in native format.
-It includes the physical address of an in-memory structure describing
-all preserved memory regions, as well as physical addresses of KHO users'
-own FDTs. Interpreting those sub FDTs is the responsibility of KHO users.
+Kexec Handover ABI
+==================
 
-KHO nodes and properties
-========================
+KHO uses the FDT to pass data between kernels. The exact structure of
+this FDT is a stable contract between kernels and is documented
+directly in the ABI header file.
 
-Property ``preserved-memory-map``
----------------------------------
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Kexec Handover ABI
 
-KHO saves a special property named ``preserved-memory-map`` under the root node.
-This node contains the physical address of an in-memory structure for KHO to
-preserve memory regions across kexec.
-
-Property ``compatible``
------------------------
-
-The ``compatible`` property determines compatibility between the kernel
-that created the KHO FDT and the kernel that attempts to load it.
-If the kernel that loads the KHO FDT is not compatible with it, the entire
-KHO process will be bypassed.
-
-Property ``fdt``
-----------------
-
-Generally, a KHO user serialize its state into its own FDT and instructs
-KHO to preserve the underlying memory, such that after kexec, the new kernel
-can recover its state from the preserved FDT.
-
-A KHO user thus can create a node in KHO root tree and save the physical address
-of its own FDT in that node's property ``fdt`` .
-
-Examples
+See Also
 ========
 
-The following example demonstrates KHO FDT that preserves two memory
-regions created with ``reserve_mem`` kernel command line parameter::
-
-  /dts-v1/;
-
-  / {
-  	compatible = "kho-v1";
-
-	preserved-memory-map = <0x40be16 0x1000000>;
-
-  	memblock {
-		fdt = <0x1517 0x1000000>;
-  	};
-  };
-
-where the ``memblock`` node contains an FDT that is requested by the
-subsystem memblock for preservation. The FDT contains the following
-serialized data::
-
-  /dts-v1/;
-
-  / {
-  	compatible = "memblock-v1";
-
-  	n1 {
-  		compatible = "reserve-mem-v1";
-  		start = <0xc06b 0x4000000>;
-  		size = <0x04 0x00>;
-  	};
-
-  	n2 {
-  		compatible = "reserve-mem-v1";
-  		start = <0xc067 0x4000000>;
-  		size = <0x04 0x00>;
-  	};
-  };
+- :doc:`/admin-guide/mm/kho`
+- :doc:`/core-api/kho/concepts`
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
new file mode 100644
index 000000000000..d78df2d44cb6
--- /dev/null
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -0,0 +1,84 @@
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
+ * This header defines the stable ABI for passing preserved data from one kernel
+ * to the next using a Flattened Device Tree (FDT). The first kernel creates an
+ * FDT which is then passed to the next kernel during a kexec handover.
+ *
+ * This interface is a contract. Any modification to the FDT structure, node
+ * properties, compatible string, or the layout of the data structures
+ * referenced here constitutes a breaking change. Such changes require
+ * incrementing the version number in KHO_FDT_COMPATIBLE to prevent a new kernel
+ * from misinterpreting data from an older kernel. Changes are allowed provided
+ * the compatibility version is incremented; however, backward/forward
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
2.52.0.223.gf5cc29aaa4-goog


