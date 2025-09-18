Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5754ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48DDA8E0068; Thu, 18 Sep 2025 18:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA7F8E013E; Thu, 18 Sep 2025 18:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267318E0068; Thu, 18 Sep 2025 18:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEA28E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7F5786D0F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:30 +0000 (UTC)
X-FDA: 83903806140.24.6A1D0B0
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id C3A4D80002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UgboTrKr;
	spf=pass (imf02.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzZPK+tD8ua9mkD8VwlX20r11BOjtw6Um42qZGE0OrE=;
	b=xjzJjly5STv2VM44+RiWXdHUQ/SrTo1AS9LbrimkkJt4EMrLxM8I23Ep3ED4gehAj9ldD4
	4AUixen2+qbFz1qQB9yjDChllKyccwC2RizN4g9mtawG+7/tV5FKngJKjbrnEFLHglJiso
	7VzIROdVFx/Tjujl/aL/TFyQkViy05s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234388; a=rsa-sha256;
	cv=none;
	b=eomNuYzQ9ikuSZ6UyTdtcnpUGbQ7w5vGpyqILP/Yby/3yvzfsPk5ZdE9dPbS0245doUOVe
	uQ3K0TvE3Eb2PQz4icAiC/MTOj2fzpxnZXMzXqz2a1K9AWQ/1FJOYkgkNFQUuNex3y3kus
	NKIfYaa2ArYO1OKz+14/eEVtoS9Ckmo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UgboTrKr;
	spf=pass (imf02.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7761a8a1dbcso1458924b3a.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234388; x=1758839188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzZPK+tD8ua9mkD8VwlX20r11BOjtw6Um42qZGE0OrE=;
        b=UgboTrKr7JEeq/WFm8/ixS6Go4thyCBuCXon72dGNmRYOEYN9DRNStEuG2F5CPN/BO
         gikq4cvFrYC8L1KQgthKaox3o/eAAbpa4iAbSPe3D5Yse8uO05RCL2uUwSBRiB4dD2cN
         Rj6VOjz38EhzgRkcZv0idovTeWU/X1dY67jQZhufKjlKK/Z+PcDobA2KpJEs9gxCH7B3
         cHPw21Z/JBREl6XiqsA2njSxJ7O+NZe8unJNGV+ndagGnxvDA6xXCM1cwfbvlQ/XZ5Ye
         atofvAi/I3r5f4gJZNAgN8PPxG+394K3D0jGWLkfcBqxPuVDSSZ5V79vnlArpQUknd4Z
         z96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234388; x=1758839188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tzZPK+tD8ua9mkD8VwlX20r11BOjtw6Um42qZGE0OrE=;
        b=qMd5oQd5Gn81xsiMGWLYBSvW5LY59+FKSMyUHMA4ByTuJ0W3pcVaudAP4ZF4UPXiMS
         5K3wcRcv1z+R3HkrZExTzz0W3lsNOQRfY105iSq2S1xw/4UfrEG5LQoBTr8ieNlL1vK0
         3LZdV/O34p+23A6KmDqhilyHxyjBeYM2brKTkkgWt+I72OOJ56hENSEnfwV5jWmgctsq
         h2jwX38mHUtQjzHsAVPs4IvOidUSJN5nRDhXZbRUbLNy6v0b1/torOgYIcOO62Gs0JyS
         mX7V24/u68zEFh0rs3kpXqMPe0xtI8pmqMjtSWaB9lx5aTL86kQU9Svndxg7zC9Fw7NU
         RymA==
X-Forwarded-Encrypted: i=1; AJvYcCXsBMHsVam4FuD6KoQhYWcGn5kXLlibKe/YAAGP5hWiAUi9VoZ1/1j/poUUFn8hrWkYQq8eKl6oKg==@kvack.org
X-Gm-Message-State: AOJu0YxfAZsJkJVa6dm2oRUcxFTcVPM3/CIrwbfpfrZNgtAlmmj7qOen
	kjF7YVBKI57C7haSrr7fRyVfTwsjrudEjX3EPP45SJNe8H09XVROhPgc
X-Gm-Gg: ASbGncuk9DhB38Ht9S8/lkZ6V08KC2MGV2C2LPloipuGyJMHpaq4yxZPYKm8V4au2vq
	pbf11dCbj4T9OMjTYpm0B6Jw+jslT+7l3KJ8FAEfeeQGWNKuS4jBgHBWs4drb0MqiK4F518KVaJ
	vS3objKqG5FooL7K59JYmJDngDRkp9tUmDxv1fGQefIdMlzMm1PpmlWRJ0avqcV+2jmc22L/ud6
	WvgOj9mya5oiEZ76zENYWqSuU045fpF3RXF9S5LIg6kvp0jVPH+14AQ1vz0Kc+tkFQQ+/qbe90g
	VIG3ZkjRJSjimOE7o9tgRY5k5E+LfNbAX3iMBoaM6yT1/Z8B355qoh/B4gOPInDzmbkS3kedhJT
	WTqVr9osUpXQLV9I9vImgJkQGQe8hlrhiw+lzENxRIJJiQkI=
X-Google-Smtp-Source: AGHT+IEcmBpKgxWK65kqL+t4N9tpvg/YpMV9lF9NLfIoi4A5w/Hpr9vbHnSl2Ql5oJ01WR0BGA3tRA==
X-Received: by 2002:a05:6a00:cc7:b0:776:1804:6fe with SMTP id d2e1a72fcca58-77e4cc3c5e1mr1115624b3a.7.1758234387508;
        Thu, 18 Sep 2025 15:26:27 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:26 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 4/7] kernel: Introduce generic multikernel IPI communication framework
Date: Thu, 18 Sep 2025 15:26:03 -0700
Message-Id: <20250918222607.186488-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3A4D80002
X-Stat-Signature: e1eyrj6xf99n4sujkwh8joni7djxp97n
X-Rspam-User: 
X-HE-Tag: 1758234388-609608
X-HE-Meta: U2FsdGVkX1864p7W3e2NsRAjeTCZFeDe6H5O8xfU01nkqHxlbkzjONNWzmSEJiM4OCB0Dxj/7L70N5M7W7C4KQoeEu3GyRSV2qhubnMxSk7hZ6QFbWuBudc29VejdTKjwj6wFrxjPGCoM4HfTibO7q/3LeUH/lJBpEEc56I0KhAQNMnKWY1w8Bmd81o8seIoDA7leTiOb3Q1OlAA0g55s/9hwVaanRzvLh7ygSKtavkKFQ6wIa8NdBc4UEIYGXDfJwN2/RfPIj5jg8lFiNEbWJAXFj9sLxrutLa1BH2e+MnUY0qfwkL2QnngxFEnXxzNhxTH1jPKEF6KF7lD2dFeTCyyjvraK88sxDjVWQX35qtg7GNw8GX1guZBUtjPynEF4vWXf2BWDHV+PzTwRiJqkEKLKRFPccYlweHWgTYbZ4PgdGBreI50shAUvw9ud0O0+vkOYxA0ZGyXnizoQHllcJjhL47KYg7DXa8vIYhGBUvwjO35++qc7i5FeZUqeVNYRsUbOSJEeUehpfkeBbTjeDB+VXQ3VhgPNZUh9PP5uvuqai0mMZmlMAyqz86JEdC+eR/SdnZWXES2/V9A3eCef5wUcQDFHYYNaQRicbFtyAgzdMmCKO68Obt+0TI0IlXa6hbsdT6Xq2M4igJ/HLIv8tIf0lWYxUFPJdWHbuQc+eMVNEmSahGKy2fevDShZvMAZRqLKpCPOhHfCqDCnmkzdtSG+8KB6jj61AHKmgQ8Ba0R/jZv5d7E2BDLmbYDVV3h+djvKbM+RMT4KsKPHLep+wOkpbnh2PHsXjMce9ArlEvipLnPq4YHw4dMtNzjiOj9NLxcgiuanTsTl8x+6d+wrQdLPAIT+UyRfWCS9+hjOInpn8/nniM/6AJIqCDxWCfrTtbN1j/dhIUx2lI9mQUjDJj72w+0Dnvt8LbE5e/+rv2S7s7daz4SFZonuiDxw6TjEFwMUNqn4bwx2USJIGQ
 yj09o0Hg
 jvYvhPGanwY7/P68Y84KmlJQ8w+Iv1b2ujTVofZusg7fAeMWfB+EJOZH75drtzYJ+l5AnyPiR/YELa1HnMLnZ0q6GKMekwUTTIhmg4ASdMot3bVEFG6ABtgv9a9xZl9tMwLY2TGeaEMdaDhGdwuFz4c8sXSuNANL0kgxXANgiZ/7CmJjqRbMNMq71mBcLil/CxEugxV0+gG2wb38pTPEE7nwlYxnG9eQbK2x/9+mzAHP79wxN2HuwC0o4ORrrBfmdWpIzf9UJjtYTjNuxp8TW+zu9MswprcOCCE40Kh7NbuUybrjahHB3qjRCiyu8MYiRDvv/JEGnGx1sd5gN57ncVsD4PIYFFNzj0eBlS2+ZGv+nKLHFi4I2jMKXg8GIq+JmwU/k2hU2Cmt191eG2x0Dur1f4T7ec86Y/Qll19PJQFJb5tBdxD+CX06U5YRtc0IljrxPiZIxZ7ii2TNFx8mRw3FwxaQtOlTUXD5a0vmaqJebrWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This patch implements a comprehensive IPI-based communication system
for multikernel environments, enabling data exchange between different
kernel instances running on separate CPUs.

Key features include:

- Generic IPI handler registration and callback mechanism allowing
  modules to register for multikernel communication events
- Shared memory infrastructure using either boot parameter-specified
  or dynamically allocated physical memory regions
- Per-CPU data buffers in shared memory for efficient IPI payload
  transfer up to 256 bytes per message
- IRQ work integration for safe callback execution in interrupt context
- PFN-based flexible shared memory APIs for page-level data sharing
- Resource tracking integration for /proc/iomem visibility

The implementation provides multikernel_send_ipi_data() for sending
typed data to target CPUs and multikernel_register_handler() for
receiving notifications. Shared memory is established during early
boot and mapped using memremap() for cache-coherent access.

This infrastructure enables heterogeneous computing scenarios where
multikernel instances can coordinate and share data while maintaining
isolation on their respective CPU cores.

Note, as a proof-of-concept, we have only implemented the x86 part.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/kernel/smp.c       |   5 +-
 include/linux/multikernel.h |  81 ++++++++++
 init/main.c                 |   2 +
 kernel/Makefile             |   2 +-
 kernel/multikernel.c        | 313 ++++++++++++++++++++++++++++++++++++
 5 files changed, 398 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/multikernel.h
 create mode 100644 kernel/multikernel.c

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 028cc423a772..3ee515e32383 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -272,10 +272,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_call_function_single)
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-static void generic_multikernel_interrupt(void)
-{
-	pr_info("Multikernel interrupt\n");
-}
+void generic_multikernel_interrupt(void);
 
 DEFINE_IDTENTRY_SYSVEC(sysvec_multikernel)
 {
diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
new file mode 100644
index 000000000000..12ed5e03f92e
--- /dev/null
+++ b/include/linux/multikernel.h
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ */
+#ifndef _LINUX_MULTIKERNEL_H
+#define _LINUX_MULTIKERNEL_H
+
+#include <linux/types.h>
+#include <linux/irq_work.h>
+
+/**
+ * Multikernel IPI interface
+ *
+ * This header provides declarations for the multikernel IPI interface,
+ * allowing modules to register callbacks for IPI events and pass data
+ * between CPUs.
+ */
+
+/* Maximum data size that can be transferred via IPI */
+#define MK_MAX_DATA_SIZE 256
+
+/* Data structure for passing parameters via IPI */
+struct mk_ipi_data {
+	int sender_cpu;          /* Which CPU sent this IPI */
+	unsigned int type;      /* User-defined type identifier */
+	size_t data_size;        /* Size of the data */
+	char buffer[MK_MAX_DATA_SIZE]; /* Actual data buffer */
+};
+
+/* Function pointer type for IPI callbacks */
+typedef void (*mk_ipi_callback_t)(struct mk_ipi_data *data, void *ctx);
+
+struct mk_ipi_handler {
+	mk_ipi_callback_t callback;
+	void *context;
+	struct mk_ipi_handler *next;
+	struct mk_ipi_data *saved_data;
+	struct irq_work work;
+};
+
+/**
+ * multikernel_register_handler - Register a callback for multikernel IPI
+ * @callback: Function to call when IPI is received
+ * @ctx: Context pointer passed to the callback
+ *
+ * Returns pointer to handler on success, NULL on failure
+ */
+struct mk_ipi_handler *multikernel_register_handler(mk_ipi_callback_t callback, void *ctx);
+
+/**
+ * multikernel_unregister_handler - Unregister a multikernel IPI callback
+ * @handler: Handler pointer returned from multikernel_register_handler
+ */
+void multikernel_unregister_handler(struct mk_ipi_handler *handler);
+
+/**
+ * multikernel_send_ipi_data - Send data to another CPU via IPI
+ * @cpu: Target CPU
+ * @data: Pointer to data to send
+ * @data_size: Size of data
+ * @type: User-defined type identifier
+ *
+ * This function copies the data to per-CPU storage and sends an IPI
+ * to the target CPU.
+ *
+ * Returns 0 on success, negative error code on failure
+ */
+int multikernel_send_ipi_data(int cpu, void *data, size_t data_size, unsigned long type);
+
+void generic_multikernel_interrupt(void);
+
+int __init multikernel_init(void);
+
+/* Flexible shared memory APIs (PFN-based) */
+int mk_send_pfn(int target_cpu, unsigned long pfn);
+int mk_receive_pfn(struct mk_ipi_data *data, unsigned long *out_pfn);
+void *mk_receive_map_page(struct mk_ipi_data *data);
+
+#define mk_receive_unmap_page(p) memunmap(p)
+
+#endif /* _LINUX_MULTIKERNEL_H */
diff --git a/init/main.c b/init/main.c
index 5753e9539ae6..46a199bcb389 100644
--- a/init/main.c
+++ b/init/main.c
@@ -103,6 +103,7 @@
 #include <linux/randomize_kstack.h>
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
+#include <linux/multikernel.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -955,6 +956,7 @@ void start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
+	multikernel_init();
 	mm_core_init();
 	maple_tree_init();
 	poking_init();
diff --git a/kernel/Makefile b/kernel/Makefile
index c60623448235..e5216610a4e7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o
+	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o multikernel.o
 
 obj-$(CONFIG_MULTIUSER) += groups.o
 obj-$(CONFIG_VHOST_TASK) += vhost_task.o
diff --git a/kernel/multikernel.c b/kernel/multikernel.c
new file mode 100644
index 000000000000..74e2f84b7914
--- /dev/null
+++ b/kernel/multikernel.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/multikernel.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <asm/apic.h>
+#include <linux/memblock.h>
+
+/* Memory parameters for shared region */
+#define MK_IPI_DATA_SIZE  (sizeof(struct mk_ipi_data) * NR_CPUS)
+#define MK_MEM_BASE_SIZE  (sizeof(struct mk_shared_data))
+#define MK_MEM_SIZE       (MK_MEM_BASE_SIZE + PAGE_SIZE)
+
+/* Boot parameter for physical address */
+static unsigned long mk_phys_addr_param;
+
+/* Parse multikernel physical address from kernel command line */
+static int __init multikernel_phys_addr_setup(char *str)
+{
+	return kstrtoul(str, 0, &mk_phys_addr_param);
+}
+early_param("mk_shared_memory", multikernel_phys_addr_setup);
+
+/* Allocated/assigned physical address for shared memory */
+static phys_addr_t mk_phys_addr_base;
+
+/* Resource structure for tracking the memory in /proc/iomem */
+static struct resource mk_mem_res __ro_after_init = {
+	.name = "Multikernel Shared Memory",
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+};
+
+/* Shared memory structures */
+struct mk_shared_data {
+	struct mk_ipi_data cpu_data[NR_CPUS];  /* Data area for each CPU */
+};
+
+/* Pointer to the shared memory area (remapped virtual address) */
+static struct mk_shared_data *mk_shared_mem;
+
+/* Callback management */
+static struct mk_ipi_handler *mk_handlers;
+static raw_spinlock_t mk_handlers_lock = __RAW_SPIN_LOCK_UNLOCKED(mk_handlers_lock);
+
+static void handler_work(struct irq_work *work)
+{
+    struct mk_ipi_handler *handler = container_of(work, struct mk_ipi_handler, work);
+    if (handler->callback)
+        handler->callback(handler->saved_data, handler->context);
+}
+
+/**
+ * multikernel_register_handler - Register a callback for multikernel IPI
+ * @callback: Function to call when IPI is received
+ * @ctx: Context pointer passed to the callback
+ *
+ * Returns pointer to handler on success, NULL on failure
+ */
+struct mk_ipi_handler *multikernel_register_handler(mk_ipi_callback_t callback, void *ctx)
+{
+	struct mk_ipi_handler *handler;
+	unsigned long flags;
+
+	if (!callback)
+		return NULL;
+
+	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
+	if (!handler)
+		return NULL;
+
+	handler->callback = callback;
+	handler->context = ctx;
+
+	init_irq_work(&handler->work, handler_work);
+
+	raw_spin_lock_irqsave(&mk_handlers_lock, flags);
+	handler->next = mk_handlers;
+	mk_handlers = handler;
+	raw_spin_unlock_irqrestore(&mk_handlers_lock, flags);
+
+	return handler;
+}
+EXPORT_SYMBOL(multikernel_register_handler);
+
+/**
+ * multikernel_unregister_handler - Unregister a multikernel IPI callback
+ * @handler: Handler pointer returned from multikernel_register_handler
+ */
+void multikernel_unregister_handler(struct mk_ipi_handler *handler)
+{
+	struct mk_ipi_handler **pp, *p;
+	unsigned long flags;
+
+	if (!handler)
+		return;
+
+	raw_spin_lock_irqsave(&mk_handlers_lock, flags);
+	pp = &mk_handlers;
+	while ((p = *pp) != NULL) {
+		if (p == handler) {
+			*pp = p->next;
+			break;
+		}
+		pp = &p->next;
+	}
+	raw_spin_unlock_irqrestore(&mk_handlers_lock, flags);
+
+    /* Wait for pending work to complete */
+    irq_work_sync(&handler->work);
+    kfree(p);
+}
+EXPORT_SYMBOL(multikernel_unregister_handler);
+
+/**
+ * multikernel_send_ipi_data - Send data to another CPU via IPI
+ * @cpu: Target CPU
+ * @data: Pointer to data to send
+ * @data_size: Size of data
+ * @type: User-defined type identifier
+ *
+ * This function copies the data to per-CPU storage and sends an IPI
+ * to the target CPU.
+ *
+ * Returns 0 on success, negative error code on failure
+ */
+int multikernel_send_ipi_data(int cpu, void *data, size_t data_size, unsigned long type)
+{
+	struct mk_ipi_data *target;
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	if (data_size > MK_MAX_DATA_SIZE)
+		return -EINVAL;  /* Data too large for buffer */
+
+	/* Ensure shared memory is initialized */
+	if (!mk_shared_mem)
+		return -ENOMEM;
+
+	/* Get target CPU's data area from shared memory */
+	target = &mk_shared_mem->cpu_data[cpu];
+
+	/* Set header information */
+	target->data_size = data_size;
+	target->sender_cpu = smp_processor_id();
+	target->type = type;
+
+	/* Copy the actual data into the buffer */
+	if (data && data_size > 0)
+		memcpy(target->buffer, data, data_size);
+
+	/* Send IPI to target CPU */
+	__apic_send_IPI(cpu, MULTIKERNEL_VECTOR);
+
+	return 0;
+}
+EXPORT_SYMBOL(multikernel_send_ipi_data);
+
+/**
+ * multikernel_interrupt_handler - Handle the multikernel IPI
+ *
+ * This function is called when a multikernel IPI is received.
+ * It invokes all registered callbacks with the per-CPU data.
+ */
+static void multikernel_interrupt_handler(void)
+{
+	struct mk_ipi_data *data;
+	struct mk_ipi_handler *handler;
+	int current_cpu = smp_processor_id();
+
+	/* Ensure shared memory is initialized */
+	if (!mk_shared_mem) {
+		pr_err("Multikernel IPI received but shared memory not initialized\n");
+		return;
+	}
+
+	/* Get this CPU's data area from shared memory */
+	data = &mk_shared_mem->cpu_data[current_cpu];
+
+	pr_debug("Multikernel IPI received on CPU %d from CPU %d, type=%u\n",
+		 current_cpu, data->sender_cpu, data->type);
+
+    raw_spin_lock(&mk_handlers_lock);
+    for (handler = mk_handlers; handler; handler = handler->next) {
+        handler->saved_data = data;
+        irq_work_queue(&handler->work);
+    }
+    raw_spin_unlock(&mk_handlers_lock);
+}
+
+/**
+ * Generic multikernel interrupt handler - called by the IPI vector
+ *
+ * This is the function that gets called by the IPI vector handler.
+ */
+void generic_multikernel_interrupt(void)
+{
+	multikernel_interrupt_handler();
+}
+
+/**
+ * setup_shared_memory - Initialize shared memory for inter-kernel communication
+ *
+ * Maps a fixed physical memory region for sharing IPI data between kernels
+ * Returns 0 on success, negative error code on failure
+ */
+static int __init setup_shared_memory(void)
+{
+	/* Check if a fixed physical address was provided via parameter */
+	if (mk_phys_addr_param) {
+		/* Use the provided physical address */
+		mk_phys_addr_base = (phys_addr_t)mk_phys_addr_param;
+		pr_info("Using specified physical address 0x%llx for multikernel shared memory\n",
+		       (unsigned long long)mk_phys_addr_base);
+	} else {
+		/* Dynamically allocate contiguous physical memory using memblock */
+		mk_phys_addr_base = memblock_phys_alloc(MK_MEM_SIZE, PAGE_SIZE);
+		if (!mk_phys_addr_base) {
+			pr_err("Failed to allocate physical memory for multikernel IPI data\n");
+			return -ENOMEM;
+		}
+	}
+
+	/* Map the physical memory region to virtual address space */
+	mk_shared_mem = memremap(mk_phys_addr_base, MK_MEM_SIZE, MEMREMAP_WB);
+	if (!mk_shared_mem) {
+		pr_err("Failed to map shared memory at 0x%llx for multikernel IPI data\n",
+		       (unsigned long long)mk_phys_addr_base);
+
+		/* Only free the memory if we allocated it dynamically */
+		if (!mk_phys_addr_param)
+			memblock_phys_free(mk_phys_addr_base, MK_MEM_SIZE);
+		return -ENOMEM;
+	}
+
+	/* Initialize the memory to zero */
+	memset(mk_shared_mem, 0, sizeof(struct mk_shared_data));
+
+	pr_info("Allocated and mapped multikernel shared memory: phys=0x%llx, virt=%px, size=%lu bytes\n",
+		(unsigned long long)mk_phys_addr_base, mk_shared_mem, MK_MEM_SIZE);
+
+	return 0;
+}
+
+int __init multikernel_init(void)
+{
+	int ret;
+
+	ret = setup_shared_memory();
+	if (ret < 0)
+		return ret;
+
+	pr_info("Multikernel IPI support initialized\n");
+	return 0;
+}
+
+static int __init init_shared_memory(void)
+{
+	/* Set up resource structure for /proc/iomem visibility */
+	mk_mem_res.start = mk_phys_addr_base;
+	mk_mem_res.end = mk_phys_addr_base + MK_MEM_SIZE - 1;
+
+	/* Register the resource in the global resource tree */
+	if (insert_resource(&iomem_resource, &mk_mem_res)) {
+		pr_warn("Could not register multikernel shared memory region in resource tracking\n");
+		/* Continue anyway as this is not fatal */
+		return -1;
+	}
+
+	pr_info("Registered multikernel shared memory in resource tree: 0x%llx-0x%llx\n",
+		(unsigned long long)mk_mem_res.start, (unsigned long long)mk_mem_res.end);
+	return 0;
+}
+core_initcall(init_shared_memory);
+
+/* ---- Flexible shared memory APIs (PFN-based) ---- */
+#define MK_PFN_IPI_TYPE 0x80000001U
+
+/* Send a PFN to another kernel via mk_ipi_data */
+int mk_send_pfn(int target_cpu, unsigned long pfn)
+{
+	return multikernel_send_ipi_data(target_cpu, &pfn, sizeof(pfn), MK_PFN_IPI_TYPE);
+}
+
+/* Receive a PFN from mk_ipi_data. Caller must check type. */
+int mk_receive_pfn(struct mk_ipi_data *data, unsigned long *out_pfn)
+{
+	if (!data || !out_pfn)
+		return -EINVAL;
+	if (data->type != MK_PFN_IPI_TYPE || data->data_size != sizeof(unsigned long))
+		return -EINVAL;
+	*out_pfn = *(unsigned long *)data->buffer;
+	return 0;
+}
+
+void *mk_receive_map_page(struct mk_ipi_data *data)
+{
+	unsigned long pfn;
+	int ret;
+
+	ret = mk_receive_pfn(data, &pfn);
+	if (ret < 0)
+		return NULL;
+	return memremap(pfn << PAGE_SHIFT, PAGE_SIZE, MEMREMAP_WB);
+}
-- 
2.34.1


