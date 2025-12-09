Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF52D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0996B0007; Mon,  8 Dec 2025 21:53:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153C66B0008; Mon,  8 Dec 2025 21:53:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE82A6B000A; Mon,  8 Dec 2025 21:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAD076B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:53:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56B21B904D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:27 +0000 (UTC)
X-FDA: 84198411654.23.0D4422E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93D7214000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SBOJ42YX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JI83aQgKCHEYPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3JI83aQgKCHEYPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765248805; a=rsa-sha256;
	cv=none;
	b=27nx9OqtN/evoLphT6g3slQ0IqrJZr84BoaWNIG7S5lou/tKU90WV1f4+t0xgNo2ZFZvBb
	sMbZOdxVCCcqpy6cHDItJg8hA8nFjccnKY44bMp78BMgXERLymkLpEI6XNukHSHHwlK3lb
	5Ok/K4OvyxLAkI99sAkGMxTJbdN3g/8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SBOJ42YX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JI83aQgKCHEYPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3JI83aQgKCHEYPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765248805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
	b=m2DB/nT41VsDIQE5p6CsJqmLuR5h/TMEhqdKYr9M1WkgzP3ByXoT5b2STmC3D9i3nMioZI
	R3/XSTAJUNK2QH0SJe7EJ79Bn9tPxKoeZH5EXsIaXUQ17ynpzUV034H0oZA4oDCGc8ALCc
	cIs1qj5EH836XVKzzVo/d1uU23QLols=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b99763210e5so10264104a12.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 18:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765248804; x=1765853604; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
        b=SBOJ42YXR+/IwxiUGZhDKtOqhjCJ5TUUi5JM7EpTK55eqFTZUop5ohmWEIjfdrCHZw
         0kKPiXN9bTL2oLeeWDhq/s9DF8vR7JNo7JAdYwuY/6cocRNLEwMYOlrRTnk6S24Mgwce
         XMJilNSyqo9m+TI+6bbucTdqnMu8EBw/k8z0BTmLKD8Gm7XhVE3P51PfZKLLPZYTv87h
         M+dfAvooL1EnONYvLpHtVCN/4TkRxlaAw2uHqCB28Zre7Z5vGiUe4K+5sJrGktbgfvrn
         r/7hMzlUEtOAN1A0HkEdeGE13YR4ZdAGzeTeBcHTdGCB1F7FlHo6m0dnlDJ5TQ9MnZP+
         RVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765248804; x=1765853604;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWGLthrm17VZY/kZ1kLIqDTWzrsbdUmIFsSZPiZHtvE=;
        b=FP+wFsSW6QU7oSpotfoPe9ZjG+P+GCtq+yGgzjNFEAB6ycx1f8hDa0oMbHK3aHJIY9
         lKcobivIXNnYJgcHRm9tawLqmr8LXRraq1Vj0uXq/VIM1u+H7PQD7z6GOYcKIwSoO7GU
         FBOTIVQbIaKxYK44/+BFkqHD99yxks/sCbXO3InTbldAoD3kaltrG+AkXTnMp98gUD8u
         BfpeSdZNVmR20th4FEagGnjJmfRLmTrrm7zFEjuq9unxHiB7nRc0QAgUNMYyAyPJreXn
         HSpaM24S119gzVfrerZHBHiuCM8L/zQW9iFZTtoJ4X3y1z6UFM+rJIVZofq7QRNdjYNu
         MTIg==
X-Forwarded-Encrypted: i=1; AJvYcCW3ysDoFZNNPQUBzj4czmsyf2WAqYXNsQV1c7xi1ffXNQXWrE5EPvKgfa16kspawhMFR9Y1NbWebg==@kvack.org
X-Gm-Message-State: AOJu0YxfS5FVPbw2z7+mYYeLiU6lSR366EHT7eLTOrQprZCkNy6RLnsQ
	1pb5SOSU6cxfe13PWcRqcZDvj6GeBOo2iZlRiDrzrIxji+lS8j9jKNf6DGUQoi6DXymEAQ8TLci
	u88G26yDFGQzRsw==
X-Google-Smtp-Source: AGHT+IHyxGM7ePub6HtjfYLSj9a32LyEArxp8bNWTTEEpgKO73sIN1+lLEyaFKDD5eGgrDeN43lBdlTkHO7++g==
X-Received: from dlbui24.prod.google.com ([2002:a05:7022:3d18:b0:11d:cdd1:432c])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:689c:b0:119:e56b:9582 with SMTP id a92af1059eb24-11e0315e218mr6523139c88.7.1765248804236;
 Mon, 08 Dec 2025 18:53:24 -0800 (PST)
Date: Mon,  8 Dec 2025 18:53:13 -0800
In-Reply-To: <20251209025317.3846938-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251209025317.3846938-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251209025317.3846938-2-jasonmiu@google.com>
Subject: [PATCH v3 1/4] kho: Introduce KHO FDT ABI header
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dtm5cj5aaznxk5nkonfh3p71jacn17nc
X-Rspam-User: 
X-Rspamd-Queue-Id: 93D7214000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1765248805-819675
X-HE-Meta: U2FsdGVkX18GVuXrghh0RVES7C2YDkYhST1GitMzonhc3+dy/i5ANEWBNnEkreJcG+GqoXCdwB7ZMMJmmMtPnTY/MyiUEK+OCX38wUyd5CrZ95QAJdd4tNbCVgtkXNH18v8lEkV4gUAG84Iqsv7r3sIZgJISFQtKlm7IQyCnFhjTS69oaaIvxPeY4Qx4MXUn2FiBGZuTeMKui9Zd4RZLNTuexuM+RwjO3gTTJf52yxv3s+4nwy7EyPJZYWnLvqCAZyqvOJxVXMR7TQ+Eto48zTM4mvleQWhJWCF1QGXebhxr6NapfO7ywSl5sBfbj9LrXgCum/i1Syo2ydMySaMPMVrUv+7mXoaQuiK/tMkUCUNli/Aj1en8fEnKBIw6mzFiW81wPVXXOJew9ut8XC6/P5XfVTBHz4XxltobGz/z4zDAr3Jc/tAWEcdDP2PHnLjIaRB86iy4s+IgVHZL0TFFx2Ehl9pbrUcReoBOE7LGQQ9gkrCOmLFbcxeWH5LUYBMXlD/bh/9RxaYTkKP8Owj+awmtDwWgHLtLqpU3aTvXFP9t4sg9eu0yQw7FBSTc7KR2KHwxRAkWB9nbNPIDwpsJ9x28c4+s7vHuhUTkJS38GYNRciwU5J+MkzwguFGj5tF0qvMY8QBsINJEGDld0DhjiAqkscP6QAtWKomrp+dVowhmr6cHabah9Quz3H+dK4cKbBgv2+JkgLuAx0y9vJyxdPL5TlNSj4mIERZQx3cMvVEzq0WZI6pMTxsBYgQYJr9dkb34WAEOHHOKh58vsKUx5JhTzOyF55TRKejpv5wT3jsd/+0mAG0yMbPy1h6tzG60fxUPQWDltYHvzHY2HFPWubhTxzWfm9KzaWapf8yw+ThU2+03rhd79LIq3KhXG6maC4TZeSid1MvEQ2i460B0XJFf463X+IzgwBGIRYUZMbtuHGOdkZaERVBSJXFbncHr5ZjgQA8OnwDc4cyQsDM
 m7AuvPkE
 doTs3vvF/9SHvoKA4bwCMnWZ5ShJ9hWy6L1gDhDV3gWXVJmdLlFKpcxFouVbMI/nPht6VQtNY7oyliF6fknHt0FbiDTI29nQH8wxi/QUKpU0glx1bVz1uTo6RCVfxC4N3ttFQyVJHIvWfrnaPZI+LQcrfds0ubTdPz8XT0m3AfRDaxpMD03i0KslK5XMHCVBMAXphvmAzrKfSKlIsyBq5Siq6kOXX9GheGBkC9mzFt/ExCH/W7M3D/ByytMC34ZmXcb/0ehg7p9phF2jUj8+sOPJka8N+vjEChcf1EC2esSF4NLy53CwA7QNJRqWJY50EvPIcituD6QBvCX1/QbIjnm4ocuoIrNNwO2N3mH1SRj3OZK1lzPlRue3JyohDZguyH5jmddvJPTtoV3w3XKKF902KtyTGz+YOpqPLPXro6yaP4GJu4tSYiw7/tYyGO9bFdVWYG2+cvt836GC0+jdHkP+5MqhWDwu3bilnEvK2SkP3qZTDOfUCyGJn10pMAfvdo8rSNSAMQDCKIdem34USAuRTtdgT1IHHwDYzj+czGGZij/4Nfg6f2az+YqTmj0zhd7N7huTJehLThdThrmOy5E538A/2qyxtmYXB
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


