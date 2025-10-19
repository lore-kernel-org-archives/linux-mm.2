Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C91FCCD1AA
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC40F8E000D; Sun, 19 Oct 2025 02:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D4F8E0002; Sun, 19 Oct 2025 02:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF838E000D; Sun, 19 Oct 2025 02:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A63078E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C6451A057F
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:04 +0000 (UTC)
X-FDA: 84013855968.20.8F99FAD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id A05CB40003
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkK9vSDI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854622; a=rsa-sha256;
	cv=none;
	b=SGYR+eGo02ZgBjkTd6cYT3JJhjjRF0Qy42FvUuHBdcAivmIlsI1EJsPdbgSs9lqwRPO76V
	M38QNDnjbzPhDioN1ElxsrO9a/dFxaTnvTKfs9eC2s8lxbbCHfd1xZHn2rJkzsNbEj29Bb
	dmqUODms7IMJzaONbJPFElejjfppzZA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkK9vSDI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEjKGsTmvd23141367z0CjoZIhmw08kqxNdluMxTHIQ=;
	b=ZBDAI5tBlEyCCUNkaxhtSmpQXnOcoycPj89/YxvGvkcVRaAGuPnJKOfQhv/Ttl1qvn0MiR
	aodvHd/BI9rpU6/D6KnlcUzazY3KWbBlfFBcutTDXs4fIvlkxvASveqBssjbT4fdmu+MWG
	zGgOjSDet4nteMHOIYEp0bJr4ihvxWI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-781206cce18so3353012b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854621; x=1761459421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEjKGsTmvd23141367z0CjoZIhmw08kqxNdluMxTHIQ=;
        b=MkK9vSDIUDIUi/udfE62aK6ZxqjMg/yOEspsHXei3hu0u/UVSYxdLMnVGKojiMk1rY
         rTNp+ho5lDarJloFdhH0dSRZDMh3ajWWs1k5rCbLLCRFrNxj8v5WZXTuqC1v8WNuee+C
         i2/J+FQWvfYfhAh9k1rlI7EQFgH1xXZvF8pSyb2SGkkAXIwXFIT6ZwibfKLLAVoPDHXN
         7tvbfRdQi//gJFCsG5F8hbRTjw3O8T1B+2t18eyvQcHFUTtg1NR6603glvJ2APeB3smU
         VDPx522VSrUwPw/q6mNHEz6C0G2ljUlgRmBMoZb04+DgIu5DzzhUuBnz1ba0lvIklkKH
         BFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854621; x=1761459421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEjKGsTmvd23141367z0CjoZIhmw08kqxNdluMxTHIQ=;
        b=bvHhwvgmqlSqxUlaaguPYrLH8JlBlWT6Itj+UgDJxTc+yare7u7kPlp/mUXeKiMiij
         qHP4mrK9l/EMOVUv+ACZyMdCaQoRltmo+MytgyYHBcGkV9fTYiSXNYX1HL5rZ1NPC9W1
         cBVun5d4oDE8ncaZCi1kV+/TQjphM2B0gESCmKJ9+3SiULJsSp9Lg/S37NqZh1673HGe
         kpEGHaHZyH5vwSa9yi21Ou6uVRjzesC4GdYaV2T02qA1NkHnrV1oQ09C7oxVXQoji7lt
         PKKEJ3TwJrHg8gGrFeuHqI/n73Yk73BFCip3VAYqDJEx/pUbNb47UZkXyXQtmbIjiRhZ
         r7gw==
X-Forwarded-Encrypted: i=1; AJvYcCXqc9H5witbYCfRy+W+x2ffk8gQjNCAlUYxU5yg5IJ8M212L1tcOCF4FNCKgvtCuMP4MKWbNaMhDw==@kvack.org
X-Gm-Message-State: AOJu0Yx60qmR5cmX8vu8EBfaB71Yup+q/PeMH4pL5gpHlGqax5HdA43/
	tKqYq/VOxeiyzTFy18/IUpfAF95K9MaR6AiLW/wSJk+WVmnHARjWTBVD
X-Gm-Gg: ASbGnctlK2zXiMeJKWACvWluNHeaobVw3v7fSRIHvl5KA43T6MZE0KS8PDjAKKfrrz9
	2rJtqzHZdBKsq0IDRwkaSNi0VVHoiGk2yJ1dFha8pTbuDvILTR2wus/CMiXLs+NGJUD8eCphSBF
	6I9OmQWf/5NdW7HwKq/EKMRwdNuK51reyAxV8E9Ynw4nG8UI/aWUrqoDWl2FgMeZNaywTGJjLLV
	gl4KrpVt46fvBeaIymqN1OaWgnQEh2mrP7Jh1AxpqI6BdH7sa4WtTomoyFHKzXkzT0Ia+Bq9A1E
	NlJjS8/10yO5wY86Z3uDD+iNN7Y1EBNv7ICej8WTLXicoCPqZCwDjb6Eb4ldmIevHq0UAyutSeT
	PM1KXcZuocI8UXC6wW8d28nugGWdsbVPB6NIvT4+sPIufnO5JrnVnkxymEYwrWR3iapAIo78xtv
	YfNPru
X-Google-Smtp-Source: AGHT+IHf14U5kr7DRzJIvBShGlqM8/wQgU0U9x9J8KNGOpp87VKg9nS0DPkEWU9jUZjsdkrR9fUmoA==
X-Received: by 2002:a05:6a20:548d:b0:2da:3fe0:3299 with SMTP id adf61e73a8af0-33495c4836amr21778442637.7.1760854621509;
        Sat, 18 Oct 2025 23:17:01 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:00 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 06/16] multikernel: Introduce physical memory reservation and allocation
Date: Sat, 18 Oct 2025 23:16:20 -0700
Message-Id: <20251019061631.2235405-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A05CB40003
X-Stat-Signature: 8zjctyqeat4ihpbcoa8rwf9dyxmpatey
X-HE-Tag: 1760854622-320852
X-HE-Meta: U2FsdGVkX1+38v43lttQoxUIzinmbeLWivZmBe4iddgSJM0XRv0jZkrXBvRA1pPn/TlgwUtd2s+LvHsFJnBEx8ls06KdCL77CEb4LTbHbg39jvLHJOtTQ/lJji0WFyqQe6jrqesvOISYRmne8ETbnsFpNFSR04fAZB+YODy0rbRfkzWjajnY+3njkjc+GituE4x/MZROs8vEc4WUdSmoXfyjxcTyQob07xKRPrL6GliC7DYcFGd2HboByzk3HzTCyfj5fLfT3/b7dmXgaBa4itU2OiCuPUInp7o+XpTLfVMSWtfiyMgKT7qfnr6Q9K8CG7bX76roFbQZpYcXWEt8mzo+xiIGE6pQ4JggMq1Z6OwxO/HdeI9aCxpHjgPObo/LC9Q0KIs2OlchOQVSrgnPlfNRspmmZwzTKSd/Z0rOnTSUkt4U0XcFl5dzVCkrwkSZDokwzFZ989lGVjRgOAv8A3HYU436mYnlfhBZbEFfYiM6GldOwEh+mSQ/jMuGK6kblJ7bkjBFLKasK7P1f2sa9kbM+QjCj2PSYpTAuaOZv32Xlvq4Cbcg/tU/0mWUQv/lmKs9VfrljbGT1vpS6NpQ5pAr/PYQYdDgzZdHPoaKRT5VUAaJiXaxSbp6Lm9S4mLfmmr21NMQcwUZma2hu/3v2yQcrYvXo98JiTRDukjb/bGqlY6VUddn9FzWOMyivjl7lZlMAjGVeZDoCpKIePwQLQK8Tp4zEayyAoEjRFQg8lBtz9S+mnaehCxUaznI/go46fi4p5aLDV0+RrRSupHb26qcfF70tTqWJFjv9B/WAz9uzHmV95s+WWEt3LKgbCOe20yV9c531SCy9hOnDqGJLEmPKUMqK6ZA7UYInrl+SlQLLY7Qqp3qJ2e4j9JmhjpQ+Rb2FIn6QugK4MIYdiDVNuggCE0kryV1dZKte+kN1nlW4uBOZ6EFpQe+zdJPUp9fAWuM8dv1tw8Mc30Ut+c
 u6kAo20b
 8URgBtIg1cZM/Y3o4UfXL7xtZm4S+1m7JCSNdDWd17c/VWvSR4MKCG9oSCE68+Apo41BrbjFsQXZdHwGlZZ56YKZe6C8aylUYzaK7X/I4rA7xQlDkdJjOhcBp+27K8twZRJAeyoR5e+AjH78sabtti0JaXd9hAJDEOQ4ZgzzScmDSw713qPlf28p8UeMuRYzvr6Ya+QQ6pYj2i+VPfaWv7PUOxd/rRGpAPl72DqqsjYYWmn/9I9yEe+i7nTX/rQsUESWDKtixb0kfino3fNCzpct1QQnek5Kj+3gQKHymBFNEOpuHrn5sah0qCfV+WizwsqgDhwo+/2YiLPJWWRjuweYzktp78cVfjpUzIkAvuN4TjpJw+OItQzTH6RRhWq3j3B7c5/31ynW2IQdrSWBgC3i9VT0a2OHAn0Cmom2tXzMvF8kN3NJa04x6Npn1usDQKriIe0uUK8HX4mQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This commit introduces:

* Memory pool reservation via mkkernel_pool= kernel parameter that
  supports both fixed address reservation (mkkernel_pool=size@addr) and
  dynamic allocation (mkkernel_pool=size). Uses memblock reservation
  during early boot to ensure memory availability.

* Global memory pool management using gen_pool for runtime allocation
  and deallocation of physical memory chunks from the reserved pool.
  Provides thread-safe operations with mutex protection.

* Per-instance memory pool management that allows creating dedicated
  memory pools for individual kernel instances. Each instance pool is
  carved out from the main multikernel pool and provides fine-grained
  allocation capabilities for IPI data, buffers, and other per-instance
  resources.

* Integration with /proc/iomem resource hierarchy to provide visibility
  into multikernel memory usage and prevent conflicts with other kernel
  subsystems.

This memory management system uses a two-tier approach: a main pool
reserved during boot handles large allocations and spawning operations,
while per-instance pools provide efficient small allocation services
for runtime inter-kernel communication and instance-specific data
structures such as kernel image and initramfs.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/multikernel.h |  22 +++
 kernel/multikernel/Makefile |   2 +-
 kernel/multikernel/mem.c    | 376 ++++++++++++++++++++++++++++++++++++
 3 files changed, 399 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/multikernel.h
 create mode 100644 kernel/multikernel/mem.c

diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
new file mode 100644
index 000000000000..51c989139a75
--- /dev/null
+++ b/include/linux/multikernel.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ */
+#ifndef _LINUX_MULTIKERNEL_H
+#define _LINUX_MULTIKERNEL_H
+
+struct resource;
+
+extern phys_addr_t multikernel_alloc(size_t size);
+extern void multikernel_free(phys_addr_t addr, size_t size);
+extern struct resource *multikernel_get_pool_resource(void);
+extern bool multikernel_pool_available(void);
+
+/* Per-instance memory pool management */
+extern void *multikernel_create_instance_pool(int instance_id, size_t pool_size, int min_alloc_order);
+extern void multikernel_destroy_instance_pool(void *pool_handle);
+extern phys_addr_t multikernel_instance_alloc(void *pool_handle, size_t size, size_t align);
+extern void multikernel_instance_free(void *pool_handle, phys_addr_t addr, size_t size);
+extern size_t multikernel_instance_pool_avail(void *pool_handle);
+
+#endif /* _LINUX_MULTIKERNEL_H */
diff --git a/kernel/multikernel/Makefile b/kernel/multikernel/Makefile
index 950bace927a0..0dad7f2267f9 100644
--- a/kernel/multikernel/Makefile
+++ b/kernel/multikernel/Makefile
@@ -3,4 +3,4 @@
 # Makefile for multikernel support
 #
 
-obj-y += core.o
+obj-y += core.o mem.o
diff --git a/kernel/multikernel/mem.c b/kernel/multikernel/mem.c
new file mode 100644
index 000000000000..dbc3363764d7
--- /dev/null
+++ b/kernel/multikernel/mem.c
@@ -0,0 +1,376 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Multikernel memory management
+ *
+ * Memory pool management for multikernel spawn kernels using gen_pool
+ * with mkkernel_pool= command line parameter
+ */
+
+#include <linux/memblock.h>
+#include <linux/ioport.h>
+#include <linux/kexec.h>
+#include <linux/mutex.h>
+#include <linux/genalloc.h>
+#include <linux/io.h>
+#include <asm/e820/api.h>
+#include <linux/multikernel.h>
+
+/* Global multikernel memory pool resource */
+struct resource multikernel_res = {
+	.name  = "Multikernel Memory Pool",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
+	.desc  = IORES_DESC_RESERVED
+};
+
+/* Generic pool for runtime memory allocation */
+static struct gen_pool *multikernel_pool;
+
+static DEFINE_MUTEX(multikernel_mem_mutex);
+
+/**
+ * multikernel_alloc() - Allocate memory from multikernel pool
+ * @size: size to allocate
+ *
+ * Returns physical address of allocated memory, or 0 on failure
+ */
+phys_addr_t multikernel_alloc(size_t size)
+{
+	unsigned long addr;
+
+	if (!multikernel_pool)
+		return 0;
+
+	mutex_lock(&multikernel_mem_mutex);
+	addr = gen_pool_alloc(multikernel_pool, size);
+	mutex_unlock(&multikernel_mem_mutex);
+
+	return (phys_addr_t)addr;
+}
+
+/**
+ * multikernel_free() - Free memory back to multikernel pool
+ * @addr: physical address to free
+ * @size: size to free
+ */
+void multikernel_free(phys_addr_t addr, size_t size)
+{
+	if (!multikernel_pool || !addr)
+		return;
+
+	mutex_lock(&multikernel_mem_mutex);
+	gen_pool_free(multikernel_pool, (unsigned long)addr, size);
+	mutex_unlock(&multikernel_mem_mutex);
+
+	pr_debug("Multikernel freed %zu bytes at %pa\n", size, &addr);
+}
+
+/**
+ * multikernel_get_pool_resource() - Get the multikernel pool resource
+ *
+ * Returns pointer to the multikernel pool resource for memory walking
+ */
+struct resource *multikernel_get_pool_resource(void)
+{
+	if (!multikernel_res.start)
+		return NULL;
+
+	return &multikernel_res;
+}
+
+/**
+ * multikernel_pool_available() - Check if multikernel pool is available
+ *
+ * Returns true if multikernel pool is configured and available
+ */
+bool multikernel_pool_available(void)
+{
+	return multikernel_pool != NULL;
+}
+
+/**
+ * Per-instance memory pool management
+ *
+ * Each kernel instance gets its own gen_pool for fine-grained allocations
+ * (IPI data, small buffers, etc.) carved out from the main multikernel pool.
+ */
+
+/**
+ * multikernel_create_instance_pool() - Create a memory pool for a kernel instance
+ * @instance_id: Unique identifier for the instance
+ * @pool_size: Total size of memory to allocate for this instance's pool
+ * @min_alloc_order: Minimum allocation order (at least PAGE_SHIFT)
+ *
+ * Allocates multiple chunks from the main multikernel pool to reach the target
+ * pool_size and creates a gen_pool for the instance to manage smaller allocations.
+ *
+ * Returns opaque handle to the instance pool, or NULL on failure
+ */
+void *multikernel_create_instance_pool(int instance_id, size_t pool_size, int min_alloc_order)
+{
+	struct gen_pool *instance_pool;
+	size_t remaining_size = pool_size;
+	size_t chunk_size;
+	phys_addr_t chunk_base;
+	int chunks_added = 0;
+
+	if (!multikernel_pool_available()) {
+		pr_err("Multikernel main pool not available for instance %d\n", instance_id);
+		return NULL;
+	}
+
+	if (min_alloc_order < PAGE_SHIFT) {
+		pr_err("Invalid min_alloc_order %d for instance %d (must be >= PAGE_SHIFT %d)\n",
+		       min_alloc_order, instance_id, PAGE_SHIFT);
+		return NULL;
+	}
+
+	instance_pool = gen_pool_create(min_alloc_order, -1);
+	if (!instance_pool) {
+		pr_err("Failed to create gen_pool for instance %d\n", instance_id);
+		return NULL;
+	}
+
+	/* Allocate memory in chunks and add to the pool */
+	while (remaining_size > 0) {
+		/* Try to allocate the remaining size, but be flexible */
+		chunk_size = remaining_size;
+		chunk_base = multikernel_alloc(chunk_size);
+
+		if (!chunk_base) {
+			/* If we can't get the full remaining size, try smaller chunks */
+			if (chunk_size > (1024 * 1024)) {
+				/* Try 1MB chunks */
+				chunk_size = 1024 * 1024;
+				chunk_base = multikernel_alloc(chunk_size);
+			}
+
+			if (!chunk_base && chunk_size > (256 * 1024)) {
+				/* Try 256KB chunks */
+				chunk_size = 256 * 1024;
+				chunk_base = multikernel_alloc(chunk_size);
+			}
+
+			if (!chunk_base && chunk_size > (1 << min_alloc_order)) {
+				/* Try minimum allocation size */
+				chunk_size = 1 << min_alloc_order;
+				chunk_base = multikernel_alloc(chunk_size);
+			}
+
+			if (!chunk_base) {
+				pr_err("Failed to allocate chunk %d for instance %d (remaining: %zu bytes)\n",
+				       chunks_added + 1, instance_id, remaining_size);
+				goto cleanup;
+			}
+		}
+
+		/* Add the allocated chunk to the instance pool */
+		if (gen_pool_add(instance_pool, chunk_base, chunk_size, -1)) {
+			pr_err("Failed to add chunk %d to instance pool %d\n",
+			       chunks_added + 1, instance_id);
+			multikernel_free(chunk_base, chunk_size);
+			goto cleanup;
+		}
+
+		chunks_added++;
+		remaining_size -= chunk_size;
+
+		pr_debug("Added chunk %d to instance pool %d: base=0x%llx, size=%zu bytes (remaining: %zu)\n",
+			 chunks_added, instance_id, (unsigned long long)chunk_base,
+			 chunk_size, remaining_size);
+	}
+
+	pr_info("Created instance pool %d: %d chunks, total size=%zu bytes\n",
+		instance_id, chunks_added, pool_size);
+
+	return instance_pool;
+
+cleanup:
+	/* Free all chunks that were successfully added */
+	multikernel_destroy_instance_pool(instance_pool);
+	return NULL;
+}
+
+/**
+ * multikernel_destroy_instance_pool() - Destroy an instance memory pool
+ * @pool_handle: Handle returned by multikernel_create_instance_pool()
+ *
+ * Frees all memory associated with the instance pool back to the main pool
+ */
+void multikernel_destroy_instance_pool(void *pool_handle)
+{
+	struct gen_pool *instance_pool = (struct gen_pool *)pool_handle;
+	struct gen_pool_chunk *chunk;
+
+	if (!instance_pool)
+		return;
+
+	/* Free all chunks back to main pool */
+	list_for_each_entry(chunk, &instance_pool->chunks, next_chunk) {
+		multikernel_free(chunk->start_addr, chunk->end_addr - chunk->start_addr + 1);
+		pr_debug("Freed instance pool chunk: 0x%lx-0x%lx\n",
+			 chunk->start_addr, chunk->end_addr);
+	}
+
+	gen_pool_destroy(instance_pool);
+}
+
+/**
+ * multikernel_instance_alloc() - Allocate from an instance pool
+ * @pool_handle: Handle returned by multikernel_create_instance_pool()
+ * @size: Size to allocate
+ * @align: Alignment requirement (must be power of 2)
+ *
+ * Returns physical address of allocated memory, or 0 on failure
+ */
+phys_addr_t multikernel_instance_alloc(void *pool_handle, size_t size, size_t align)
+{
+	struct gen_pool *instance_pool = (struct gen_pool *)pool_handle;
+	unsigned long addr;
+
+	if (!instance_pool)
+		return 0;
+
+	if (align <= 1) {
+		addr = gen_pool_alloc(instance_pool, size);
+	} else {
+		/* Ensure alignment is at least the pool's minimum allocation order */
+		size_t a = max_t(size_t, align, BIT(instance_pool->min_alloc_order));
+		struct genpool_data_align data = { .align = a };
+		addr = gen_pool_alloc_algo(instance_pool, size, gen_pool_first_fit_align, &data);
+	}
+
+	return (phys_addr_t)addr;
+}
+
+/**
+ * multikernel_instance_free() - Free memory back to instance pool
+ * @pool_handle: Handle returned by multikernel_create_instance_pool()
+ * @addr: Physical address to free
+ * @size: Size to free
+ */
+void multikernel_instance_free(void *pool_handle, phys_addr_t addr, size_t size)
+{
+	struct gen_pool *instance_pool = (struct gen_pool *)pool_handle;
+
+	if (!instance_pool || !addr)
+		return;
+
+	gen_pool_free(instance_pool, (unsigned long)addr, size);
+	pr_debug("Instance pool freed %zu bytes at 0x%llx\n", size, (unsigned long long)addr);
+}
+
+/**
+ * multikernel_instance_pool_avail() - Get available space in instance pool
+ * @pool_handle: Handle returned by multikernel_create_instance_pool()
+ *
+ * Returns available bytes in the instance pool
+ */
+size_t multikernel_instance_pool_avail(void *pool_handle)
+{
+	struct gen_pool *instance_pool = (struct gen_pool *)pool_handle;
+
+	if (!instance_pool)
+		return 0;
+
+	return gen_pool_avail(instance_pool);
+}
+
+static int __init mkkernel_pool_setup(char *str)
+{
+	char *cur = str;
+	unsigned long long size, start;
+
+	if (!str)
+		return -EINVAL;
+
+	size = memparse(cur, &cur);
+	if (size == 0) {
+		pr_err("mkkernel_pool: invalid size\n");
+		return -EINVAL;
+	}
+
+	/* Expect '@' separator, or end of string for dynamic allocation */
+	if (*cur == '@') {
+		cur++;
+		/* Parse start address */
+		start = memparse(cur, &cur);
+		if (start == 0) {
+			pr_err("mkkernel_pool: invalid start address\n");
+			return -EINVAL;
+		}
+	} else if (*cur == '\0') {
+		/* No address specified, use dynamic allocation */
+		start = 0;
+	} else {
+		pr_err("mkkernel_pool: expected '@' or end of string after size\n");
+		return -EINVAL;
+	}
+
+	/* Reserve the memory using the proper memblock reservation approach */
+	phys_addr_t reserved_addr;
+	if (start != 0) {
+		/* Reserve at the user-specified address */
+		pr_info("mkkernel_pool: trying to reserve at specific address %llx\n", start);
+		if (memblock_reserve(start, size)) {
+			pr_err("mkkernel_pool: failed to reserve at specified address %llx\n", start);
+			return -ENOMEM;
+		}
+		reserved_addr = start;
+		pr_info("mkkernel_pool: successfully reserved at requested address %llx\n", start);
+	} else {
+		/* Dynamic allocation */
+		pr_info("mkkernel_pool: trying dynamic allocation\n");
+		reserved_addr = memblock_phys_alloc(size, PAGE_SIZE);
+		if (!reserved_addr) {
+			pr_err("mkkernel_pool: failed to allocate %llu bytes\n", size);
+			return -ENOMEM;
+		}
+		pr_info("mkkernel_pool: dynamic allocation succeeded at %pa\n", &reserved_addr);
+	}
+
+	multikernel_res.start = reserved_addr;
+	multikernel_res.end = reserved_addr + size - 1;
+
+	pr_info("Multikernel pool: %pa-%pa (%lluMB) allocated\n",
+		    &multikernel_res.start, &multikernel_res.end, (unsigned long long)size >> 20);
+
+	return 0;
+}
+early_param("mkkernel_pool", mkkernel_pool_setup);
+
+static int __init multikernel_mem_init(void)
+{
+	if (multikernel_res.start) {
+		/* Create the generic pool */
+		multikernel_pool = gen_pool_create(PAGE_SHIFT, -1);
+		if (!multikernel_pool) {
+			pr_err("Failed to create multikernel memory pool\n");
+			return -ENOMEM;
+		}
+
+		/* Add the reserved memory to the pool */
+		if (gen_pool_add(multikernel_pool, multikernel_res.start,
+				 multikernel_res.end - multikernel_res.start + 1, -1)) {
+			pr_err("Failed to add memory to multikernel pool\n");
+			gen_pool_destroy(multikernel_pool);
+			multikernel_pool = NULL;
+			return -ENOMEM;
+		}
+
+		if (insert_resource(&iomem_resource, &multikernel_res)) {
+			pr_warn("mkkernel_pool: failed to register in /proc/iomem\n");
+		} else {
+			pr_info("mkkernel_pool: successfully registered in /proc/iomem\n");
+		}
+
+		pr_info("Multikernel memory pool initialized: %pa-%pa\n",
+			&multikernel_res.start, &multikernel_res.end);
+	} else {
+		pr_info("No multikernel pool found - multikernel support disabled\n");
+	}
+
+	return 0;
+}
+core_initcall(multikernel_mem_init);
-- 
2.34.1


