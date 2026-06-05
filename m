Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C6ACD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E725A6B0093; Thu,  4 Jun 2026 23:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E236C6B0095; Thu,  4 Jun 2026 23:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39A46B0096; Thu,  4 Jun 2026 23:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFF1F6B0093
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:33:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8231E9263F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:03 +0000 (UTC)
X-FDA: 84844437846.09.ADE5820
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB7CC1C0003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BVtn3ZvW;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGemO6oM+fzlXtG0xc8ivWmdV7Y8sG7GsOK7Le1P9V4=;
	b=vKvOOy7UeWCX53YMUoCx+PAzN2OcnDElJD044XAKXzITKBQboMQPvfvjIEZgFKNXz08TV2
	B/ggGm0BZzoqzuE6p/NcYiSRzZoEqDb2cE+OUHEkaPbNyMZ6vXptTmQIytWsB5+6czRVNU
	5608n5JpGPU0fLXF/bnBC/fKudKdamg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BVtn3ZvW;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630381;
	b=52w9MoA4r7oVMCaDf6ACzpILkWQtc4dZA5muBv7hXbZgA5qp36iIambgJzO5aFPW6yETL/
	Qu/khaoj2BIWIk0VuYAL4KIjrswbPgq1apS0pATCy7ALsVwbpzFEguKNIlpmUtM3oWa63U
	qcm1SDEFhsf66VeBUbP1ukhKZ6sazYE=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-91574384cc2so172499885a.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630381; x=1781235181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGemO6oM+fzlXtG0xc8ivWmdV7Y8sG7GsOK7Le1P9V4=;
        b=BVtn3ZvWyQ/QzX1ypx+fHSRX+wyrzqRfahY3key+p0yCQYwx339e6PhtTgAFjrGe7X
         1bmvR8hXrxOKtZpj/E6xREvFO5WjRh3yntFwFB3Ywd5RFgYTrXgwO5pKKwMCirSGonBO
         yYzhbL1+77Kq9vhnzoBrKx68XHLZ1OFODi8afqVOHvt2aVdGYkRR4lBSDc0Yceyj7U25
         uivgFvFLWfcCci1u2jSHdBRJvvCZagSoplDqlvaqd2A3WWfI5FB2nkSDeTj1Gf1Q4jOz
         n6v0BdRNY/HmdY2SHz2eVrE+Q4fCiBbtDHFVKsBxX89Y5kZGhdfrED0J43ccdukO8xO7
         Ez+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630381; x=1781235181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CGemO6oM+fzlXtG0xc8ivWmdV7Y8sG7GsOK7Le1P9V4=;
        b=s7g6bdyfjodNn9OxPFLCuyT7Ovppx4SKPk2CEmLN7zU3yysyb5X0IUsEgnO9PGVUY9
         VmBxirj0rQ/PV/0XPjda/iDlvCDv28Q2sXalF2PmchG95Er4XqdYACIpy6j0Se7IjUPw
         Hkjq4fb5HOeUrfNUlqOJERW/v2lUnUYTwi6HRIz6qWlpwLjRc4pqpJMP0+NSfqs2Jd0j
         t/HnDiOJG4nk2IbMo8QRGk7/Z9ESxoWYhOrXLWo604/uOhta0OqHeFGqo5B85iIL28d4
         XXz0aiu8M0yIhSCiBZrlULcgwvCTmMwwsPH22EXW5C88U0wIjLV4WK1PAmuUqns2OUJq
         uNaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gE/5GbegHGw05GrTaZUVntddJEe1YZ9jfThhmApccajffdB833hh6ZqsD8/IzSXEHjU71VUoz6Q==@kvack.org
X-Gm-Message-State: AOJu0YzEEHrV63ZdeVa5e66QfWp6fZ4K25CdJATJJnefpU5Iw5u7HkTn
	AxabBwCnC6TRkAfytRgq65mTkvSheo96BqZgtj4EcSW4uMae/clUAn5Xo46gj14SSV4=
X-Gm-Gg: Acq92OGHigbsDeszQ+Ce1yuWBV0imLAtF54wFgdVehBcqeEKgka1LUGj63b/YzLqwal
	ByngwRpq9RRBPrQSTjvsw4FjyhLP8S7lAboU0485PHBQ+jFF5f0F2XU8oTeErNC5M4MnDS7ZQHr
	4NVUEmhVGENnitv/6RIFPAcf7y+O9PWYIjpgerkchvoRW2l94hr+LQB/Qee9cwcMU6cxVSF5Qqo
	CENKCpw/B2fuXuaHKjDvVxV6SuGntz0ueY42cB3nt/B+nF4NrG0NaJhJCZDXVf8kNB4w0fP7KFV
	Licv88kUaGzw9uWI33kGqPn7x1kpBAJceYtTbqOek1NTomlJwPV83RVU84kJNmzOgT0079PK0A4
	4P5F1QjTWsW1HveGOiILIB0NIKjjdPdzYH18XZzt2goOQJxSKsEfF29olpaFO6aXL66WOvs/AZY
	Ik07eaKh5A/de6eoIOgxC0QlIoqD04XI8fGNWRHJzLNhmJTS51uR/5pY1EXCDbKg==
X-Received: by 2002:a05:620a:1709:b0:914:cc9d:e29 with SMTP id af79cd13be357-915a9cadf6fmr346442685a.21.1780630380676;
        Thu, 04 Jun 2026 20:33:00 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdb915csm70807166d6.14.2026.06.04.20.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:00 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 2/9] kho: split radix tree headers out of kexec_handover.h
Date: Fri,  5 Jun 2026 03:32:28 +0000
Message-ID: <20260605033235.717351-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB7CC1C0003
X-Stat-Signature: tc5tz55kabuioyg8faa6n6yw9r8mbt58
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780630381-19395
X-HE-Meta: U2FsdGVkX18/lLfqob8RBObldP5e52olMU8h6CmFHjW3icNyCgIk4IKrrfGmosCEh5MyC2kSMkylDSyzBPNJQQQz1D2NZH9bWgT/dJefTL4upl8rA8YwCiISb3iOf+cEMsD6HAPUAHe5XvE3mpvw7V10a0O7Nol/qxVeDSAAITfSbon0k4ugydh8yxLHBbCxeG2tX6a+JgUOo1iRjgYkmD+Vwm290yf9A6QiqNsdDcsZMkTMAB0/uVmOMHLEVyo9txD0n85KgBMUkzbzrZxpoqbYEiG0pNbeUOhI/GSrjEIRqXHkCw+e5PssUO3b20Ad2bIAu2Gy5b2PMfJBKVU5i8shZe5bbHz8WxA5UVa2Jyy04ZQdkRPofu/3dS+tZVKkHNcLhSx6F8m9iCoVZIJvUMG28YJg9lk665s9Sj26enJh4N2AQegpUVE4zu/PSXoVGwOs3RsNcrwdL+7evjaFwOUBtk8BdQJdhe0MM/CAP9T+nwhHtrTWvn+zqf8+Bzn57vKl/gt1qvJYjY0EBzIlBaXOuFaIwEftzXTJgNhKmDp+ZoYDyclIV0/oRdcH/yJsWAaGRuq1iu8AtSqLbR3MmO9NKdGrzTw7YGmdF94FQPfPSUB+OTY9bqDd2yBcfNvBuFxz5nKfFXRlP7ldH2g7BEke/n5DDwjTc79uKqUvhbj78pyMR0Z5W9K/szOP9xuveEPbUVtl1Jr3FmpQ9wxd9wCVT9d580NvjGIw+P9ly7c5mnUmEXSCs7lRlIwExRl4Sd0Cnf7VxsxF/2V1n4MYbfL9KGDj+LLXslS1t8KmTKNcyQ5VwkYoRY4vzQ3G+Brrx0wdm5ooobfgbS5SAn6PsD3IHOLEqNwRf3eDd7wcaapJMBzfg4CUwLNb28/8d+pzR6BVRiNFYiRfPlpAxwcys5LqRnU/g3dPxldFeoN+TzfAIubwZU2sWeczDV0YrBFgh9+tZmo1a1/agnLoob3
 obGNCqzl
 Ru4qN+q/NxMdkk6+BpAwbudosiP56Hgn/LsSuMHGHojZxrTEjaARkFZeyvhzSuyu6kujUZH5824jW3YFgArojX1mfBUuGGAQmxWduUqkP1yROUqCoxZT6qnaj6usVIKuYeYsmNlu7HlGGkdZnggiBAnmA7XBL82Tni4VvXkAC5SS9C2yq4BvaiwsN80VwnQgcgmwnJARYD0yjqQqswiqWWeO6VH09+9VZCdm0DAlcwTho0CRp0FRAOL++7tPjuqVU4JhuITWuJgGHJ853EvB/7b8FvJUwFyOQVYWnq1gNDCQuT6sUbRn1ID2Ma2/nkOyFPCWfmz2MnnLNVCmERYvWjq2Cs6TzQJISDloTKCQY7tmZNSvOhXcxscSeiFvjJpIHKMRKdJGErKXCgQ8+Yy1e1xfxHzSLPTMe9HSl/2X1Ldr7y8gBLXY8UqxB/JuD7Hwg8qwu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the radix tree tracker-related ABI definitions and header
declarations out of the monolithic kexec_handover.h header into a
dedicated header file (radix_tree.h).

Additionally, rename kho_radix_tree.h to kho/radix_tree.h, organizing it
within the existing kho directory structure as more KHO data structures
are introduced.

This is a pure code movement patch; no logic or functional changes are
introduced.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/abi.rst            |   3 +-
 Documentation/core-api/kho/index.rst          |   2 +-
 include/linux/kho/abi/kexec_handover.h        | 114 ---------------
 include/linux/kho/abi/radix_tree.h            | 131 ++++++++++++++++++
 .../{kho_radix_tree.h => kho/radix_tree.h}    |   5 +-
 kernel/liveupdate/kexec_handover.c            |   2 +-
 kernel/liveupdate/kho_radix.c                 |   2 +-
 7 files changed, 137 insertions(+), 122 deletions(-)
 create mode 100644 include/linux/kho/abi/radix_tree.h
 rename include/linux/{kho_radix_tree.h => kho/radix_tree.h} (96%)

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index edeb5b311963..da5c6636bb17 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -25,8 +25,7 @@ memblock preservation ABI
 KHO persistent memory tracker ABI
 =================================
 
-.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
-  :doc: KHO persistent memory tracker
+.. kernel-doc:: include/linux/kho/abi/radix_tree.h
 
 KHO serialization block ABI
 ===========================
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index a9892c671ec3..f69367d217cf 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -74,7 +74,7 @@ the next KHO, because kexec can overwrite even the original kernel.
 Kexec Handover Radix Tree
 =========================
 
-.. kernel-doc:: include/linux/kho_radix_tree.h
+.. kernel-doc:: include/linux/kho/radix_tree.h
   :doc: Kexec Handover Radix Tree
 
 Public API
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..99e4a53d4e35 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -4,15 +4,10 @@
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
- * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
  */
 
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
-
-#include <linux/bits.h>
-#include <linux/log2.h>
-#include <linux/math.h>
 #include <linux/types.h>
 
 #include <asm/page.h>
@@ -177,113 +172,4 @@ struct kho_vmalloc {
 	unsigned short order;
 };
 
-/**
- * DOC: KHO persistent memory tracker
- *
- * KHO tracks preserved memory using a radix tree data structure. Each node of
- * the tree is exactly a single page. The leaf nodes are bitmaps where each set
- * bit is a preserved page of any order. The intermediate nodes are tables of
- * physical addresses that point to a lower level node.
- *
- * The tree hierarchy is shown below::
- *
- *   root
- *   +-------------------+
- *   |     Level 5       | (struct kho_radix_node)
- *   +-------------------+
- *     |
- *     v
- *   +-------------------+
- *   |     Level 4       | (struct kho_radix_node)
- *   +-------------------+
- *     |
- *     | ... (intermediate levels)
- *     |
- *     v
- *   +-------------------+
- *   |      Level 0      | (struct kho_radix_leaf)
- *   +-------------------+
- *
- * The tree is traversed using a key that encodes the page's physical address
- * (pa) and its order into a single unsigned long value. The encoded key value
- * is composed of two parts: the 'order bit' in the upper part and the
- * 'shifted physical address' in the lower part.::
- *
- *   +------------+-----------------------------+--------------------------+
- *   | Page Order | Order Bit                   | Shifted Physical Address |
- *   +------------+-----------------------------+--------------------------+
- *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
- *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
- *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
- *   | ...        | ...                         | ...                      |
- *   +------------+-----------------------------+--------------------------+
- *
- * Shifted Physical Address:
- * The 'shifted physical address' is the physical address normalized for its
- * order. It effectively represents the PFN shifted right by the order.
- *
- * Order Bit:
- * The 'order bit' encodes the page order by setting a single bit at a
- * specific position. The position of this bit itself represents the order.
- *
- * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT = 12), the
- * maximum range for the shifted physical address (for order 0) is 52 bits
- * (64 - 12). This address occupies bits [0-51]. For order 0, the order bit is
- * set at position 52.
- *
- * The following diagram illustrates how the encoded key value is split into
- * indices for the tree levels, with PAGE_SIZE of 4KB::
- *
- *        63:60   59:51    50:42    41:33    32:24    23:15         14:0
- *   +---------+--------+--------+--------+--------+--------+-----------------+
- *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitmap)  |
- *   +---------+--------+--------+--------+--------+--------+-----------------+
- *
- * The radix tree stores pages of all orders in a single 6-level hierarchy. It
- * efficiently shares higher tree levels, especially due to common zero top
- * address bits, allowing a single, efficient algorithm to manage all
- * pages. This bitmap approach also offers memory efficiency; for example, a
- * 512KB bitmap can cover a 16GB memory range for 0-order pages with PAGE_SIZE =
- * 4KB.
- *
- * The data structures defined here are part of the KHO ABI. Any modification
- * to these structures that breaks backward compatibility must be accompanied by
- * an update to the "compatible" string. This ensures that a newer kernel can
- * correctly interpret the data passed by an older kernel.
- */
-
-/*
- * Defines constants for the KHO radix tree structure, used to track preserved
- * memory. These constants govern the indexing, sizing, and depth of the tree.
- */
-enum kho_radix_consts {
-	/*
-	 * The bit position of the order bit (and also the length of the
-	 * shifted physical address) for an order-0 page.
-	 */
-	KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT,
-
-	/* Size of the table in kho_radix_node, in log2 */
-	KHO_TABLE_SIZE_LOG2 = const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
-
-	/* Number of bits in the kho_radix_leaf bitmap, in log2 */
-	KHO_BITMAP_SIZE_LOG2 = PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
-
-	/*
-	 * The total tree depth is the number of intermediate levels
-	 * and 1 bitmap level.
-	 */
-	KHO_TREE_MAX_DEPTH =
-		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1,
-			     KHO_TABLE_SIZE_LOG2) + 1,
-};
-
-struct kho_radix_node {
-	u64 table[1 << KHO_TABLE_SIZE_LOG2];
-};
-
-struct kho_radix_leaf {
-	DECLARE_BITMAP(bitmap, 1 << KHO_BITMAP_SIZE_LOG2);
-};
-
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
diff --git a/include/linux/kho/abi/radix_tree.h b/include/linux/kho/abi/radix_tree.h
new file mode 100644
index 000000000000..f4cc5c02f37a
--- /dev/null
+++ b/include/linux/kho/abi/radix_tree.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
+ * Copyright (C) 2026 Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_RADIX_TREE_H
+#define _LINUX_KHO_ABI_RADIX_TREE_H
+
+#include <linux/types.h>
+#include <asm/page.h>
+
+/**
+ * DOC: KHO persistent memory tracker
+ *
+ * Subsystems using the KHO persistent memory tracker rely on the stable
+ * Application Binary Interface defined below to pass serialized state from a
+ * pre-update kernel to a post-update kernel.
+ *
+ * This interface is a contract. Any modification to the structure fields,
+ * compatible strings, or the layout of the serialization structures defined
+ * here constitutes a breaking change. Such changes require incrementing the
+ * version number in the `KHO_FDT_COMPATIBLE` string to prevent a new kernel
+ * from misinterpreting data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is incremented;
+ * however, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
+ *
+ * KHO tracks preserved memory using a radix tree data structure. Each node of
+ * the tree is exactly a single page. The leaf nodes are bitmaps where each set
+ * bit is a preserved page of any order. The intermediate nodes are tables of
+ * physical addresses that point to a lower level node.
+ *
+ * The tree hierarchy is shown below::
+ *
+ *   root
+ *   +-------------------+
+ *   |     Level 5       | (struct kho_radix_node)
+ *   +-------------------+
+ *     |
+ *     v
+ *   +-------------------+
+ *   |     Level 4       | (struct kho_radix_node)
+ *   +-------------------+
+ *     |
+ *     | ... (intermediate levels)
+ *     |
+ *     v
+ *   +-------------------+
+ *   |      Level 0      | (struct kho_radix_leaf)
+ *   +-------------------+
+ *
+ * The tree is traversed using a key that encodes the page's physical address
+ * (pa) and its order into a single unsigned long value. The encoded key value
+ * is composed of two parts: the 'order bit' in the upper part and the
+ * 'shifted physical address' in the lower part.::
+ *
+ *   +------------+-----------------------------+--------------------------+
+ *   | Page Order | Order Bit                   | Shifted Physical Address |
+ *   +------------+-----------------------------+--------------------------+
+ *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
+ *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
+ *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
+ *   | ...        | ...                         | ...                      |
+ *   +------------+-----------------------------+--------------------------+
+ *
+ * Shifted Physical Address:
+ * The 'shifted physical address' is the physical address normalized for its
+ * order. It effectively represents the PFN shifted right by the order.
+ *
+ * Order Bit:
+ * The 'order bit' encodes the page order by setting a single bit at a
+ * specific position. The position of this bit itself represents the order.
+ *
+ * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT = 12), the
+ * maximum range for the shifted physical address (for order 0) is 52 bits
+ * (64 - 12). This address occupies bits [0-51]. For order 0, the order bit is
+ * set at position 52.
+ *
+ * The following diagram illustrates how the encoded key value is split into
+ * indices for the tree levels, with PAGE_SIZE of 4KB::
+ *
+ *        63:60   59:51    50:42    41:33    32:24    23:15         14:0
+ *   +---------+--------+--------+--------+--------+--------+-----------------+
+ *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitmap)  |
+ *   +---------+--------+--------+--------+--------+--------+-----------------+
+ *
+ * The radix tree stores pages of all orders in a single 6-level hierarchy. It
+ * efficiently shares higher tree levels, especially due to common zero top
+ * address bits, allowing a single, efficient algorithm to manage all
+ * pages. This bitmap approach also offers memory efficiency; for example, a
+ * 512KB bitmap can cover a 16GB memory range for 0-order pages with PAGE_SIZE =
+ * 4KB.
+ */
+
+/*
+ * Defines constants for the KHO radix tree structure, used to track preserved
+ * memory. These constants govern the indexing, sizing, and depth of the tree.
+ */
+enum kho_radix_consts {
+	/*
+	 * The bit position of the order bit (and also the length of the
+	 * shifted physical address) for an order-0 page.
+	 */
+	KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT,
+
+	/* Size of the table in kho_radix_node, in log2 */
+	KHO_TABLE_SIZE_LOG2 = const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
+
+	/* Number of bits in the kho_radix_leaf bitmap, in log2 */
+	KHO_BITMAP_SIZE_LOG2 = PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
+
+	/*
+	 * The total tree depth is the number of intermediate levels
+	 * and 1 bitmap level.
+	 */
+	KHO_TREE_MAX_DEPTH =
+		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1,
+			     KHO_TABLE_SIZE_LOG2) + 1,
+};
+
+struct kho_radix_node {
+	u64 table[1 << KHO_TABLE_SIZE_LOG2];
+};
+
+struct kho_radix_leaf {
+	DECLARE_BITMAP(bitmap, 1 << KHO_BITMAP_SIZE_LOG2);
+};
+
+#endif /* _LINUX_KHO_ABI_RADIX_TREE_H */
diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho/radix_tree.h
similarity index 96%
rename from include/linux/kho_radix_tree.h
rename to include/linux/kho/radix_tree.h
index 84e918b96e53..1e337e73deba 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho/radix_tree.h
@@ -5,6 +5,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/kho/abi/radix_tree.h>
 #include <linux/mutex_types.h>
 #include <linux/types.h>
 
@@ -24,11 +25,9 @@
  * Client code is responsible for allocating the root node of the tree,
  * initializing the mutex lock, and managing its lifecycle. It must use the
  * tree data structures defined in the KHO ABI,
- * `include/linux/kho/abi/kexec_handover.h`.
+ * `include/linux/kho/abi/radix_tree.h`.
  */
 
-struct kho_radix_node;
-
 struct kho_radix_tree {
 	struct kho_radix_node *root;
 	struct mutex lock; /* protects the tree's structure and root pointer */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 041efff7ca11..4a3d6a54a17f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -16,7 +16,7 @@
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
-#include <linux/kho_radix_tree.h>
+#include <linux/kho/radix_tree.h>
 #include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/kho/abi/kexec_metadata.h>
diff --git a/kernel/liveupdate/kho_radix.c b/kernel/liveupdate/kho_radix.c
index c836783a1376..f48088847264 100644
--- a/kernel/liveupdate/kho_radix.c
+++ b/kernel/liveupdate/kho_radix.c
@@ -11,7 +11,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/kho/abi/kexec_handover.h>
-#include <linux/kho_radix_tree.h>
+#include <linux/kho/radix_tree.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
-- 
2.53.0


