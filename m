Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBDECCD1AA
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECF98E000F; Sun, 19 Oct 2025 02:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BBF8E0002; Sun, 19 Oct 2025 02:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5A68E000F; Sun, 19 Oct 2025 02:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0531B8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B69ED13B341
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:09 +0000 (UTC)
X-FDA: 84013856178.06.5CDB74D
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 998E1180007
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SUabCg3w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcLnqOPlWR9OpiQ1Thj+gdu5lPJw5SKOpmEUCeAVZH8=;
	b=gouUw/LgnWeck3imvO4txexHCFJziSeh+BPzV9k37tgfAwZOSiemMx1nw/dt2CuNP56Pgn
	Rvz/4zv74O/Vb542vwyxPv/Tldahv4jEJNMKmuHOwHUnuvNWfP1kAoqvfp5XV+/GEotPfb
	st9ZlwUC7hC3fBnpYVaqhpLjSuNEUvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854627; a=rsa-sha256;
	cv=none;
	b=3BSWSViLR5pYIVwTfhEWPQjuMXnQN+GjklASm2QzPM/XyW4aZHHHyReRsbUmV5mfvqsVHc
	nlpItg5P6aLP935b1aN22WTEVSUAOQzMDRBoDV+jb/JGoNSTECurXj8xvZaDawoSGJEv2B
	yoQYp7ki5UTw6ERMNeFARW5BsWLlB0M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SUabCg3w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7930132f59aso4540603b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854626; x=1761459426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcLnqOPlWR9OpiQ1Thj+gdu5lPJw5SKOpmEUCeAVZH8=;
        b=SUabCg3wFeVsnElSm8psPLq/6eM6yjpd09kRAGABrzeDHTZ8P+TlrFRUpPL/I4aJmC
         tL9yXtNKs9GEH2dSEjDjmvi73JgfWclxgdKZfTmR+ifWmyvHuqBRa/wbmxnIPdpOvbJ5
         y6bGD/GpCsEtVxIjorZPbx9twmIcpybsKssLSdzpDMWW4E4/7NaOcMbRcpHQlnrF7WJs
         jNKddPnx4fF4fIA371sAHt5unTK3HM1UZ628v+gtinc0c+sqLFuLUjcTykAz119bqH4a
         9gMpMfWHTyzA22DXI11mTyb4v8NQdO4kS4DwCwSN+G9wU/XLA9VGze1mtlkqBuYETAMs
         BXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854626; x=1761459426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcLnqOPlWR9OpiQ1Thj+gdu5lPJw5SKOpmEUCeAVZH8=;
        b=h3IcG4TynyELIBhFZtfJ1znzuB3GSlEcntSg3Kb5eQcung1vT+T60CQXqCmn3QJMt8
         yTTeB11T8UTNS3kdlORQap9wwHWOmsS0IDvhLo1xeVuAw2bk7PAo2UafTJ4QgR9Qf/aT
         +qxdhO+XUJuqJ9qkOAFnivViTVDeoiQ+wW9hBTsNnMUMCFnQ4K4YoKGafGGhZzijFHhx
         2ycNCHOIbidhUAq4V2I5VSDApBcZCbmK+1PM2R4+u0TjZIDH4B38uap6gj6ln0NPlzxm
         UjWPxYDkOIE5mGLGM17wfG6Hv7t7mKnbtQ70Uk+5rex5ldfcVOC0uLJvE5XegxQf8QXQ
         X/1A==
X-Forwarded-Encrypted: i=1; AJvYcCV4c6DIxga8xkdG6yMI9R1ynTTsAnkjpQwH2yo05prxlMfJ7Slbrvc00ODI3+Z1S/m/4/Wi0KyqEQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3sqncNdtO9IABXNmUNCfxfsDTp1KHpcK8w+/t3nnzJxz47Z7e
	lsf+e8JgC8zz/YjRTbwcCgqxW8dHBiTCvw+NlxyopD66ZPW2Q0O4QUPx
X-Gm-Gg: ASbGnctvvofG0/+97nXWDEpfe1Q0lQRx9uEv1Hy+0ZEphLHhI8rR13xtxq2FFrgZlwJ
	6DV2N/+lDg2ebPz+PJLgT9cY8ABI4PDf5XRK84t2LFasmJEwgliJ1df5REq2Cj3KpSqsS6Soz8I
	4VhhgPiRMA6PseVr3WsUOdza4o1ILCGzveRE3+Zd9kNhqqqId2MiDmPNm8TPbCHNJMsJKrylGoh
	l8bfmk0ORFNSCi3yPrh4JqOfGjeVVOyBCHk86bIFaZAY7dSMxJr7aKBHse0H4Wrx6PgwDcTNTUH
	R864Jq/dSCY5DSnSDds+UmDDhZe88Mhzv/xuvkEf2Wxcv6BTN7ML3648yp11hCQUrUqZpdEGDrO
	VY4VxlCyPQymZe4PT6dmaKsLZ1Qim8PJNch763zMdQ3MgY6SyjqBPqRvMaAycwJn2IQWoxtg3QK
	G3RgA/rhvEGTl6blo=
X-Google-Smtp-Source: AGHT+IFB3wCz/PfenfYiDErzdxw7PoGNBPRIekKDlWrvqGvVuXzZUuWNybzRZ6Z3gwbFwhStf29Bug==
X-Received: by 2002:a05:6a20:939d:b0:2fc:660a:23f0 with SMTP id adf61e73a8af0-334a85bb1e6mr12453160637.46.1760854626146;
        Sat, 18 Oct 2025 23:17:06 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:05 -0700 (PDT)
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
Subject: [RFC Patch v2 08/16] multikernel: Introduce device-tree based kernfs interface
Date: Sat, 18 Oct 2025 23:16:22 -0700
Message-Id: <20251019061631.2235405-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 998E1180007
X-Rspamd-Server: rspam02
X-Stat-Signature: c38sk8xhbuanj1abi8ijigzedxrsi33w
X-HE-Tag: 1760854627-523342
X-HE-Meta: U2FsdGVkX1/kGkSGr5urNc3WW8BMQhF54OcrJrIaXt3KGGhJ5yNggNRKpk7JYs9BUvz4lOM2dqRFviYK0GA0KMHxaW2HUKGQ3Lxg1sjmy4KlC8OMEiHD2e3NjcX0i1rbajG7rh9eVcydabBvNsrWlFkhn9uuQxZYWzQRreDPFUoxNE0ThYP07+WuM1xnrrQWj4MecoQmP4mem2C9sC1FdZhN8mChP/7qwzKv+nRG5om4oYDlhE8aVl5t+umwZ/0kdpwE/vbbhEVcVXLiPEHaE8oSua6PXJEaIb9QaXUDhyoHYirkUDYT4ACUE93ISJlC59b98WnimhZgkr24LSMmY2jHOuJ4GtCtnEG01IYSyVSKmOOvAVhNpVSWh6hJWqXSFwonDgMpPGkZKXmD8uoKlvNJCP1VQ+BoTw9VGVbJFto182wNsIVdR94rmm/iTxrNnV8PJ8KSAyND+rR7WW069Ai2rDzWclXL8YVYywV4RMu/6JeIoJvYR1eHJJ9eJQci3UIoTXVEJ6oj3BuN/hd0VmQLrsF2FQw/j82OSF7f/ebP7x5hyFjQL04yu2eghR1QECT08ojaL1crdXycLJMEsNplap7Vr/40G6Umsoyt2YQbtDi1Jm85WDx5h/quE2Aui6MVQ44FJ4sqEPYuE0F+qKLq1k2BpbLL8N0MNXgfSgL4VP40m8XVTBK+I9CDh1OmhBeq5d3YM5ydDBOglrNo9xhHTlcZxLYJ1m/KBCJHAQZJoQbu8UUAzagS2S6/axZUzJXjYFXWoS7/u8ECPJim6DvPDK1BBcrD1qe/6EqfCr+oOM+sHgWAQ2+48cL6A5asRrinqQcFC0AWs6dMpQkO0F9IU1QbHFHsIqubk1yg744QVF5ZFTCz926UPXgCSaTZBGKz5WEocxndVn6cEWvd7pR3gd35kFHOLqN2CHIfPCenpb7vLns9EBHCT2r+HbRci4PZLjHqCr+3VyZ3oPX
 Mwnqafue
 LBfwsKIEIHBSCYh8hwVMNsvETLxsgJo8L0dFbHD85gZmNAJrrEtVHj5UsSPmzOq8u4+9t78Vv/m5Yl/+jf1ftAyP6EyWGhMHFjjWhwpv2Z3NypF+fzZiDkb7Yis9B8hFiuGGS11mGZRsGkBEjnqiLDiRz4BjmqaZ+NV5d6Gn7mcVsh7Ps937In3f9F622o5g6FBqCZrHo2j9FgK6Ka5kBMUG6rkhY+eQyOGQqAWrT3YoUBDG/Di9wo6IcRqnu0YI6lYybK2Lh0ZVURVOros19/QnlWPXo/sWU/uVGx3gF3HEDwOagX5o/8AlSzZ2ZKfQgg6DKKFSoB6prj146VAv3YdVrzkTYZt1FCqvPcP3wsyFBja9mFbuXVtsfFZSqvQZ9kFoCPy/sPcHqgKv0R2uE9nwXr9NITwHWHHaDbjQI0a1tIqrKGTMx2RS+MIGtiku6DiGZzU5/5uKkLTRaWjWHELlXRp1ujZ+jhzeMp419MfVr2E4i0oofdpf2MxsBtZoNuHfbDMvmyH3gbaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This commit introduces:

* Device tree parsing infrastructure (kernel/multikernel/dts.c) that
  supports parsing multikernel-specific device tree blobs with resource
  specifications including memory size requirements and CPU assignments.
  Provides validation, configuration management, and resource availability
  checking with extensible property parsing for future enhancements.

* Kernfs-based filesystem interface (kernel/multikernel/kernfs.c) that
  creates a dedicated multikernel filesystem mountable at
  /sys/fs/multikernel/ with full instance lifecycle management through
  device tree uploads rather than manual directory creation.

* Instance management infrastructure with comprehensive state tracking
  (empty, ready, loading, active, failed), reference counting, resource
  reservation, and integration with the kexec multikernel system for
  seamless kernel loading operations.

Key features of the interface:

- Device tree upload via /device_tree file that automatically parses
  multikernel DTBs and creates instance directories with proper resource
  allocation and CPU assignment including CPU hotplug operations.

- Per-instance attribute files (id, status, device_tree_source) that
  provide read-only access to instance information and configuration
  with human-readable device tree source reconstruction.

- Resource management integration that reserves memory from multikernel
  pools, creates proper resource hierarchy entries, and handles CPU
  offline operations for dedicated CPU assignment.

- State synchronization with kexec operations through mk_instance_find(),
  mk_instance_set_kexec_active(), and mk_instance_set_kexec_loading()
  functions for proper lifecycle tracking.

The device tree format supports /instances/<name> nodes with resources
subnodes containing memory-bytes and cpus properties, providing a
structured approach to multikernel configuration with proper validation
and resource conflict detection.

See also the user-space kerf project for more details about device-tree
specification: https://github.com/multikernel/kerf

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/multikernel.h   | 328 +++++++++++++++
 kernel/multikernel/Kconfig    |   1 +
 kernel/multikernel/Makefile   |   5 +-
 kernel/multikernel/core.c     | 404 ++++++++++++++++++
 kernel/multikernel/dts.c      | 466 ++++++++++++++++++++
 kernel/multikernel/internal.h |   4 +
 kernel/multikernel/kernfs.c   | 772 ++++++++++++++++++++++++++++++++++
 7 files changed, 1979 insertions(+), 1 deletion(-)
 create mode 100644 kernel/multikernel/dts.c
 create mode 100644 kernel/multikernel/internal.h
 create mode 100644 kernel/multikernel/kernfs.c

diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
index 51c989139a75..75cbb316d565 100644
--- a/include/linux/multikernel.h
+++ b/include/linux/multikernel.h
@@ -5,6 +5,15 @@
 #ifndef _LINUX_MULTIKERNEL_H
 #define _LINUX_MULTIKERNEL_H
 
+#include <linux/types.h>
+#include <linux/irq_work.h>
+#include <linux/kobject.h>
+#include <linux/kernfs.h>
+#include <linux/ioport.h>
+#include <linux/of.h>
+#include <linux/cpumask.h>
+#include <linux/genalloc.h>
+
 struct resource;
 
 extern phys_addr_t multikernel_alloc(size_t size);
@@ -19,4 +28,323 @@ extern phys_addr_t multikernel_instance_alloc(void *pool_handle, size_t size, si
 extern void multikernel_instance_free(void *pool_handle, phys_addr_t addr, size_t size);
 extern size_t multikernel_instance_pool_avail(void *pool_handle);
 
+/**
+ * Multikernel Instance States
+ */
+enum mk_instance_state {
+	MK_STATE_EMPTY = 0,     /* Instance directory exists but no DTB */
+	MK_STATE_READY,         /* DTB loaded, resources reserved */
+	MK_STATE_LOADING,       /* Kernel being loaded */
+	MK_STATE_ACTIVE,        /* Kernel running */
+	MK_STATE_FAILED,        /* Error occurred */
+};
+
+/**
+ * Memory region wrapper
+ *
+ * This wraps a struct resource with gen_pool_chunk for memory pool management.
+ * Used by instance management to track both resource hierarchy and pool chunks.
+ */
+struct mk_memory_region {
+	struct resource res;            /* The actual resource */
+	struct gen_pool_chunk *chunk;   /* Associated gen_pool chunk */
+	struct list_head list;          /* List entry for management */
+};
+
+/**
+ * Complete multikernel device tree configuration
+ *
+ * This structure handles memory size requirements and CPU assignment
+ * parsed from device tree blobs.
+ */
+struct mk_dt_config {
+	/* Version for compatibility checking */
+	u32 version;
+
+	/* Memory requirements */
+	size_t memory_size;              /* Total memory size required */
+
+	/* CPU resources */
+	cpumask_var_t cpus;              /* Assigned CPU mask */
+	bool cpus_valid;                 /* Whether CPU assignment is valid */
+
+	/* Extensibility: Reserved fields for future use */
+	u32 reserved[12];                /* Increased due to removed fields */
+
+	/* Raw device tree data */
+	void *dtb_data;
+	size_t dtb_size;
+};
+
+/**
+ * Multikernel Instance Structure
+ *
+ * Each instance represents a potential or active multikernel with
+ * its own resource allocation and state management.
+ */
+struct mk_instance {
+	int id;                         /* Kernel-assigned instance ID */
+	char *name;                     /* User-provided instance name */
+	enum mk_instance_state state;   /* Current state */
+
+	/* Resource management - list of reserved memory regions */
+	struct list_head memory_regions;  /* List of struct mk_memory_region */
+	int region_count;                  /* Number of memory regions */
+	/* Memory pool for this instance */
+	void *instance_pool;            /* Handle for instance-specific memory pool */
+	size_t pool_size;               /* Size of the instance pool */
+
+	/* CPU resources */
+	cpumask_var_t cpus;              /* Assigned CPU mask */
+	bool cpus_valid;                 /* Whether CPU assignment is valid */
+
+	/* Device tree information */
+	void *dtb_data;                 /* Device tree blob data */
+	size_t dtb_size;                /* Size of DTB */
+
+	/* Sysfs representation */
+	struct kernfs_node *kn;            /* Kernfs node for this instance */
+
+	/* List management */
+	struct list_head list;          /* Link to global instance list */
+
+	/* Reference counting */
+	struct kref refcount;           /* Reference count for cleanup */
+};
+
+/**
+ * Device Tree Parsing Functions
+ */
+
+/**
+ * mk_dt_parse() - Parse multikernel device tree blob
+ * @dtb_data: Device tree blob data
+ * @dtb_size: Size of DTB data
+ * @config: Output configuration structure
+ *
+ * Parses a device tree blob and extracts multikernel-specific
+ * memory region properties. Supports multiple memory regions
+ * specified as:
+ * - linux,multikernel-memory = <start1 size1 start2 size2 ...>;
+ *
+ * Each memory region becomes a struct resource that will be
+ * inserted as a child of the main multikernel_res.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_dt_parse(const void *dtb_data, size_t dtb_size,
+		struct mk_dt_config *config);
+
+/**
+ * mk_dt_validate() - Validate parsed device tree configuration
+ * @config: Configuration to validate
+ *
+ * Validates that the parsed memory regions are reasonable and
+ * compatible with the current system state. Checks for:
+ * - Region alignment
+ * - Availability in multikernel pool
+ * - No overlaps between regions
+ *
+ * Returns 0 if valid, negative error code on validation failure.
+ */
+int mk_dt_validate(const struct mk_dt_config *config);
+
+/**
+ * mk_dt_config_init() - Initialize a device tree configuration
+ * @config: Configuration structure to initialize
+ *
+ * Initializes all fields to safe defaults.
+ */
+void mk_dt_config_init(struct mk_dt_config *config);
+
+/**
+ * mk_dt_config_free() - Free device tree configuration resources
+ * @config: Configuration to free
+ *
+ * Frees any dynamically allocated resources in the configuration.
+ */
+void mk_dt_config_free(struct mk_dt_config *config);
+
+/**
+ * mk_dt_resources_available() - Check if memory and CPU resources are available
+ * @config: Configuration with resources to check
+ *
+ * Checks if the specified memory size is available in the
+ * multikernel memory pool and all CPUs are possible on the system.
+ *
+ * Returns true if all resources are available, false otherwise.
+ */
+bool mk_dt_resources_available(const struct mk_dt_config *config);
+
+/**
+ * mk_dt_get_property_size() - Get size of a specific property
+ * @dtb_data: Device tree blob
+ * @dtb_size: Size of DTB
+ * @property: Property name (e.g., "linux,multikernel-memory")
+ *
+ * Helper function to determine the size of a property before parsing.
+ * Useful for validation and memory allocation.
+ *
+ * Returns property size in bytes, or -ENOENT if not found.
+ */
+int mk_dt_get_property_size(const void *dtb_data, size_t dtb_size,
+			    const char *property);
+
+/**
+ * mk_dt_print_config() - Print configuration for debugging
+ * @config: Configuration to print
+ *
+ * Prints the parsed configuration in a human-readable format
+ * for debugging purposes.
+ */
+void mk_dt_print_config(const struct mk_dt_config *config);
+
+/**
+ * Sysfs Interface Functions
+ */
+
+/**
+ * mk_kernfs_init() - Initialize multikernel kernfs interface
+ *
+ * Creates /sys/kernel/multikernel/ directory and sets up
+ * the kernfs infrastructure for multikernel instances.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_kernfs_init(void);
+
+/**
+ * mk_kernfs_cleanup() - Cleanup multikernel kernfs interface
+ *
+ * Removes all kernfs entries and cleans up resources.
+ */
+void mk_kernfs_cleanup(void);
+
+/**
+ * mk_instance_find_by_name() - Find an existing instance by name
+ * @name: Instance name to find
+ *
+ * Returns pointer to mk_instance if found, NULL otherwise.
+ * Caller must hold appropriate locks.
+ */
+struct mk_instance *mk_instance_find_by_name(const char *name);
+
+/**
+ * mk_instance_get() - Increment reference count
+ * @instance: Instance to reference
+ *
+ * Returns the instance pointer for convenience.
+ */
+struct mk_instance *mk_instance_get(struct mk_instance *instance);
+
+/**
+ * mk_instance_put() - Decrement reference count
+ * @instance: Instance to dereference
+ *
+ * May free the instance if reference count reaches zero.
+ */
+void mk_instance_put(struct mk_instance *instance);
+
+/**
+ * mk_instance_set_state() - Update instance state
+ * @instance: Instance to update
+ * @state: New state
+ *
+ * Updates the instance state and notifies sysfs.
+ */
+void mk_instance_set_state(struct mk_instance *instance,
+			   enum mk_instance_state state);
+
+/**
+ * mk_instance_reserve_resources() - Reserve CPU and memory resources for instance
+ * @instance: Instance to reserve resources for
+ * @config: Device tree configuration with memory size and CPU assignment
+ *
+ * Allocates the specified memory size from the multikernel pool, creates
+ * memory regions, and copies CPU assignment.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_instance_reserve_resources(struct mk_instance *instance,
+				  const struct mk_dt_config *config);
+
+/**
+ * mk_instance_free_memory() - Free all reserved memory regions
+ * @instance: Instance to free memory for
+ *
+ * Returns all reserved memory regions back to the multikernel pool
+ * and removes them from the resource hierarchy.
+ */
+void mk_instance_free_memory(struct mk_instance *instance);
+
+/**
+ * String conversion helpers
+ */
+const char *mk_state_to_string(enum mk_instance_state state);
+enum mk_instance_state mk_string_to_state(const char *str);
+
+/**
+ * Kexec Integration Functions
+ *
+ * These functions bridge the gap between the sysfs instance management
+ * and the kexec multikernel system.
+ */
+
+/**
+ * mk_instance_find() - Find instance by a multikernel instance ID
+ * @mk_id: Multikernel instance ID
+ *
+ * Returns pointer to mk_instance if found, NULL otherwise.
+ */
+struct mk_instance *mk_instance_find(int mk_id);
+
+/**
+ * mk_instance_set_kexec_active() - Mark instance as active for kexec
+ * @mk_id: Multikernel ID from kexec system
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_instance_set_kexec_active(int mk_id);
+
+/**
+ * mk_instance_set_kexec_loading() - Mark instance as loading for kexec
+ * @mk_id: Multikernel ID from kexec system
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_instance_set_kexec_loading(int mk_id);
+
+/**
+ * Version and Compatibility
+ */
+#define MK_DT_CONFIG_VERSION_1  1
+#define MK_DT_CONFIG_CURRENT    MK_DT_CONFIG_VERSION_1
+#define MK_FDT_COMPATIBLE "multikernel-v1"
+
+/**
+ * Property Names
+ */
+#define MK_DT_RESOURCE_MEMORY   "memory-bytes"
+#define MK_DT_RESOURCE_CPUS     "cpus"
+
+static const char * const mk_resource_properties[] = {
+	MK_DT_RESOURCE_MEMORY,
+	MK_DT_RESOURCE_CPUS,
+	NULL  /* Sentinel */
+};
+
+static inline bool mk_is_resource_property(const char *prop_name)
+{
+	const char * const *prop;
+
+	if (!prop_name)
+		return false;
+
+	for (prop = mk_resource_properties; *prop; prop++) {
+		if (strcmp(prop_name, *prop) == 0)
+			return true;
+	}
+	return false;
+}
+
 #endif /* _LINUX_MULTIKERNEL_H */
diff --git a/kernel/multikernel/Kconfig b/kernel/multikernel/Kconfig
index 0e61fd2e505a..a9582a4d0c54 100644
--- a/kernel/multikernel/Kconfig
+++ b/kernel/multikernel/Kconfig
@@ -6,6 +6,7 @@
 config MULTIKERNEL
 	bool "Multikernel support"
 	depends on KEXEC_CORE
+	select LIBFDT
 	help
 	  Enable multikernel support, which allows running multiple kernel
 	  instances simultaneously with resource isolation and inter-kernel
diff --git a/kernel/multikernel/Makefile b/kernel/multikernel/Makefile
index 0dad7f2267f9..d004c577f13d 100644
--- a/kernel/multikernel/Makefile
+++ b/kernel/multikernel/Makefile
@@ -3,4 +3,7 @@
 # Makefile for multikernel support
 #
 
-obj-y += core.o mem.o
+obj-y += core.o mem.o kernfs.o dts.o
+
+# Add libfdt include path for device tree parsing
+CFLAGS_dts.o = -I $(srctree)/scripts/dtc/libfdt
diff --git a/kernel/multikernel/core.c b/kernel/multikernel/core.c
index 218424d59cc3..52bf8e38206a 100644
--- a/kernel/multikernel/core.c
+++ b/kernel/multikernel/core.c
@@ -5,10 +5,414 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/cpumask.h>
+#include <linux/cpu.h>
 #include <linux/multikernel.h>
+#include "internal.h"
+
+/**
+ * Instance reference counting
+ */
+static void mk_instance_release(struct kref *kref)
+{
+	struct mk_instance *instance = container_of(kref, struct mk_instance, refcount);
+
+	pr_debug("Releasing multikernel instance %d (%s)\n", instance->id, instance->name);
+
+	mk_instance_free_memory(instance);
+
+	/* Free CPU mask */
+	if (instance->cpus_valid) {
+		free_cpumask_var(instance->cpus);
+		instance->cpus_valid = false;
+	}
+
+	kfree(instance->dtb_data);
+	kfree(instance->name);
+	kfree(instance);
+}
+
+struct mk_instance *mk_instance_get(struct mk_instance *instance)
+{
+	if (instance)
+		kref_get(&instance->refcount);
+	return instance;
+}
+
+void mk_instance_put(struct mk_instance *instance)
+{
+	if (instance)
+		kref_put(&instance->refcount, mk_instance_release);
+}
+
+/**
+ * Instance state management
+ */
+void mk_instance_set_state(struct mk_instance *instance,
+			   enum mk_instance_state state)
+{
+	enum mk_instance_state old_state = instance->state;
+
+	if (old_state == state)
+		return;
+
+	instance->state = state;
+	pr_debug("Instance %d (%s) state: %s -> %s\n",
+		 instance->id, instance->name,
+		 mk_state_to_string(old_state),
+		 mk_state_to_string(state));
+
+	/* TODO: Notify status file of state change
+	 * We should store a reference to the status file's kernfs node
+	 * and call kernfs_notify() on that specific file, not the directory.
+	 */
+}
+
+struct mk_instance *mk_instance_find_by_name(const char *name)
+{
+	struct mk_instance *instance;
+
+	lockdep_assert_held(&mk_instance_mutex);
+
+	if (!name)
+		return NULL;
+
+	list_for_each_entry(instance, &mk_instance_list, list) {
+		if (instance->name && strcmp(instance->name, name) == 0)
+			return instance;
+	}
+
+	return NULL;
+}
+
+struct mk_instance *mk_instance_find(int mk_id)
+{
+	struct mk_instance *instance;
+
+	mutex_lock(&mk_instance_mutex);
+	instance = idr_find(&mk_instance_idr, mk_id);
+	if (instance)
+		mk_instance_get(instance);
+	mutex_unlock(&mk_instance_mutex);
+
+	return instance;
+}
+
+int mk_instance_set_kexec_active(int mk_id)
+{
+	struct mk_instance *instance;
+
+	instance = mk_instance_find(mk_id);
+	if (!instance) {
+		pr_err("No sysfs instance found for multikernel ID %d\n", mk_id);
+		return -ENOENT;
+	}
+
+	mk_instance_set_state(instance, MK_STATE_ACTIVE);
+	mk_instance_put(instance);
+	pr_info("Multikernel instance %d is now active\n", mk_id);
+
+	return 0;
+}
+
+int mk_instance_set_kexec_loading(int mk_id)
+{
+	struct mk_instance *instance;
+
+	instance = mk_instance_find(mk_id);
+	if (!instance) {
+		pr_err("No sysfs instance found for multikernel ID %d\n", mk_id);
+		return -ENOENT;
+	}
+
+	mk_instance_set_state(instance, MK_STATE_LOADING);
+	mk_instance_put(instance);
+	pr_info("Multikernel instance %d is now loading\n", mk_id);
+
+	return 0;
+}
+
+
+/**
+ * CPU management functions for instances
+ */
+
+static int mk_instance_offline_cpus(struct mk_instance *instance)
+{
+	int cpu, ret = 0, failed_count = 0;
+
+	pr_info("Bringing CPUs offline for multikernel instance %d (%s): %*pbl\n",
+		instance->id, instance->name, cpumask_pr_args(instance->cpus));
+
+	for_each_cpu(cpu, instance->cpus) {
+		if (!cpu_online(cpu)) {
+			pr_debug("CPU %d already offline for instance %d\n", cpu, instance->id);
+			continue;
+		}
+
+		pr_info("Taking CPU %d offline for multikernel instance %d\n", cpu, instance->id);
+
+		ret = remove_cpu(cpu);
+		if (ret) {
+			pr_err("Failed to take CPU %d offline for instance %d: %d\n",
+				cpu, instance->id, ret);
+			failed_count++;
+		} else {
+			pr_info("Successfully took CPU %d offline for instance %d\n",
+				cpu, instance->id);
+		}
+	}
+
+	if (failed_count > 0) {
+		pr_warn("Failed to take %d CPUs offline for instance %d (%s)\n",
+			 failed_count, instance->id, instance->name);
+		return -EBUSY;
+	}
+
+	pr_info("Successfully took all assigned CPUs offline for instance %d (%s)\n",
+		instance->id, instance->name);
+	return 0;
+}
+
+/**
+ * mk_instance_reserve_cpus() - Assign CPU resources to an instance
+ * @instance: Instance to assign CPU resources to
+ * @config: Device tree configuration with CPU assignment
+ *
+ * Copies CPU assignment from config to instance. This is the actual
+ * "reservation" function that assigns CPUs to the instance.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int mk_instance_reserve_cpus(struct mk_instance *instance,
+				    const struct mk_dt_config *config)
+{
+	int ret;
+
+	if (config->cpus_valid && instance->cpus_valid) {
+		cpumask_copy(instance->cpus, config->cpus);
+
+		pr_info("CPU assignment for instance %d (%s): %*pbl (%d CPUs)\n",
+			instance->id, instance->name,
+			cpumask_pr_args(instance->cpus), cpumask_weight(instance->cpus));
+
+		ret = mk_instance_offline_cpus(instance);
+		if (ret) {
+			pr_warn("Failed to bring some CPUs offline for instance %d (%s): %d\n",
+				instance->id, instance->name, ret);
+			return ret;
+		}
+	} else {
+		pr_warn("Cannot reserve CPU resources to instance %d (%s) - instance CPU mask not available\n",
+			instance->id, instance->name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * Memory management functions for instances
+ */
+
+/**
+ * mk_instance_reserve_memory() - Reserve memory regions for an instance
+ * @instance: Instance to reserve memory for
+ * @config: Device tree configuration with memory size
+ *
+ * Creates an instance pool from the specified memory size and creates
+ * memory regions from the pool chunks for resource hierarchy management.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int mk_instance_reserve_memory(struct mk_instance *instance,
+				      const struct mk_dt_config *config)
+{
+	struct gen_pool *pool;
+	struct gen_pool_chunk *chunk;
+	struct mk_memory_region *region;
+	int ret = 0;
+	int region_num = 0;
+
+	/* Handle case where no memory size is specified */
+	if (config->memory_size == 0) {
+		pr_info("No memory size specified for instance %d (%s)\n",
+		       instance->id, instance->name);
+		return 0;
+	}
+
+	/* Create instance memory pool */
+	instance->instance_pool = multikernel_create_instance_pool(instance->id,
+								   config->memory_size,
+								   PAGE_SHIFT);
+	if (!instance->instance_pool) {
+		pr_err("Failed to create instance pool for instance %d (%s)\n",
+		       instance->id, instance->name);
+		return -ENOMEM;
+	}
+
+	instance->pool_size = config->memory_size;
+	pool = (struct gen_pool *)instance->instance_pool;
+
+	/* Create memory regions from pool chunks for resource hierarchy */
+	list_for_each_entry(chunk, &pool->chunks, next_chunk) {
+		resource_size_t size = chunk->end_addr - chunk->start_addr + 1;
+
+		/* Allocate a new region structure for the instance */
+		region = kzalloc(sizeof(*region), GFP_KERNEL);
+		if (!region) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		/* Set up the resource structure from chunk */
+		region->res.start = chunk->start_addr;
+		region->res.end = chunk->end_addr;
+		region->res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		region->res.name = kasprintf(GFP_KERNEL, "mk-instance-%d-%s-region-%d",
+					     instance->id, instance->name, region_num);
+		if (!region->res.name) {
+			kfree(region);
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		/* Link region to its chunk */
+		region->chunk = chunk;
+
+		/* Insert as child of multikernel_res */
+		ret = insert_resource(&multikernel_res, &region->res);
+		if (ret) {
+			pr_err("Failed to insert memory region as child resource: %d\n", ret);
+			kfree(region->res.name);
+			kfree(region);
+			goto cleanup;
+		}
+
+		/* Add to instance's memory region list */
+		INIT_LIST_HEAD(&region->list);
+		list_add_tail(&region->list, &instance->memory_regions);
+		instance->region_count++;
+		region_num++;
+
+		pr_debug("Created memory region for instance %d (%s): 0x%llx-0x%llx (%llu bytes)\n",
+			 instance->id, instance->name,
+			 (unsigned long long)region->res.start,
+			 (unsigned long long)region->res.end,
+			 (unsigned long long)size);
+	}
+
+	pr_info("Successfully created %d memory regions from pool for instance %d (%s), total %zu bytes\n",
+		instance->region_count, instance->id, instance->name, config->memory_size);
+	return 0;
+
+cleanup:
+	/* Clean up any regions we managed to allocate */
+	mk_instance_free_memory(instance);
+
+	if (instance->instance_pool) {
+		multikernel_destroy_instance_pool(instance->instance_pool);
+		instance->instance_pool = NULL;
+		instance->pool_size = 0;
+	}
+	return ret;
+}
+
+/**
+ * mk_instance_free_memory() - Free all reserved memory regions
+ * @instance: Instance to free memory for
+ *
+ * Returns all reserved memory regions back to the multikernel pool
+ * and removes them from the resource hierarchy.
+ */
+void mk_instance_free_memory(struct mk_instance *instance)
+{
+	struct mk_memory_region *region, *tmp;
+
+	if (!instance)
+		return;
+
+	list_for_each_entry_safe(region, tmp, &instance->memory_regions, list) {
+		pr_debug("Freeing memory region for instance %d (%s): 0x%llx-0x%llx\n",
+			 instance->id, instance->name,
+			 (unsigned long long)region->res.start,
+			 (unsigned long long)region->res.end);
+
+		/* Remove from instance list */
+		list_del(&region->list);
+
+		/* Remove from resource hierarchy */
+		remove_resource(&region->res);
+
+		/* Free the resource name and region structure */
+		kfree(region->res.name);
+		kfree(region);
+	}
+
+	instance->region_count = 0;
+	if (instance->instance_pool) {
+		multikernel_destroy_instance_pool(instance->instance_pool);
+		instance->instance_pool = NULL;
+		instance->pool_size = 0;
+	}
+
+	pr_debug("Freed all memory regions and pool for instance %d (%s)\n",
+		 instance->id, instance->name);
+}
+
+/**
+ * mk_instance_reserve_resources() - Reserve memory and CPU resources for an instance
+ * @instance: Instance to reserve resources for
+ * @config: Device tree configuration with memory regions and CPU assignment
+ *
+ * Reserves all memory regions specified in the device tree configuration,
+ * makes them children of the main multikernel_res, and copies CPU assignment.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int mk_instance_reserve_resources(struct mk_instance *instance,
+			       const struct mk_dt_config *config)
+{
+	int ret;
+
+	if (!config || !instance) {
+		pr_err("Invalid parameters to mk_instance_reserve_resources\n");
+		return -EINVAL;
+	}
+
+	/* Free any existing memory regions first */
+	mk_instance_free_memory(instance);
+
+	/* Reserve memory regions */
+	ret = mk_instance_reserve_memory(instance, config);
+	if (ret) {
+		pr_err("Failed to reserve memory regions for instance %d (%s): %d\n",
+		       instance->id, instance->name, ret);
+		return ret;
+	}
+
+	/* Reserve CPU resources */
+	ret = mk_instance_reserve_cpus(instance, config);
+	if (ret) {
+		pr_err("Failed to reserve CPU resources for instance %d (%s): %d\n",
+		       instance->id, instance->name, ret);
+		/* Don't fail the whole operation for CPU reservation failure */
+		pr_warn("Continuing without CPU assignment\n");
+	}
+
+	return 0;
+}
 
 static int __init multikernel_init(void)
 {
+	int ret;
+
+	ret = mk_kernfs_init();
+	if (ret < 0) {
+		pr_err("Failed to initialize multikernel sysfs interface: %d\n", ret);
+		return ret;
+	}
+
 	pr_info("Multikernel support initialized\n");
 	return 0;
 }
diff --git a/kernel/multikernel/dts.c b/kernel/multikernel/dts.c
new file mode 100644
index 000000000000..9cd7010d3fd8
--- /dev/null
+++ b/kernel/multikernel/dts.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ *
+ * Multikernel device tree support
+ *
+ * Provides device tree parsing and validation for multikernel instances.
+ * Designed to be extensible for future enhancements like CPU affinity,
+ * I/O resource allocation, NUMA topology, etc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/libfdt.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/sizes.h>
+#include <linux/cpumask.h>
+#include <linux/multikernel.h>
+
+/**
+ * Configuration initialization and cleanup
+ */
+void mk_dt_config_init(struct mk_dt_config *config)
+{
+	memset(config, 0, sizeof(*config));
+	config->version = MK_DT_CONFIG_CURRENT;
+	config->memory_size = 0;
+
+	/* Initialize CPU mask */
+	if (!alloc_cpumask_var(&config->cpus, GFP_KERNEL)) {
+		pr_warn("Failed to allocate CPU mask, CPU assignment disabled\n");
+		config->cpus_valid = false;
+	} else {
+		cpumask_clear(config->cpus);
+		config->cpus_valid = true;
+	}
+}
+
+void mk_dt_config_free(struct mk_dt_config *config)
+{
+	if (!config)
+		return;
+
+	/* Free CPU mask */
+	if (config->cpus_valid) {
+		free_cpumask_var(config->cpus);
+		config->cpus_valid = false;
+	}
+
+	/* Reset memory size */
+	config->memory_size = 0;
+
+	/* Note: We don't free dtb_data here as it's managed by the caller */
+}
+
+/**
+ * Function prototypes
+ */
+static int mk_dt_parse_memory(const void *fdt, int chosen_node,
+			      struct mk_dt_config *config);
+static int mk_dt_parse_cpus(const void *fdt, int chosen_node,
+			    struct mk_dt_config *config);
+static int mk_dt_validate_memory(const struct mk_dt_config *config);
+static int mk_dt_validate_cpus(const struct mk_dt_config *config);
+
+/**
+ * Memory region parsing
+ */
+static int mk_dt_parse_memory(const void *fdt, int chosen_node,
+			      struct mk_dt_config *config)
+{
+	const fdt32_t *prop;
+	int len;
+	size_t total_size = 0;
+
+	/* Look for memory-bytes property */
+	prop = fdt_getprop(fdt, chosen_node, MK_DT_RESOURCE_MEMORY, &len);
+	if (!prop) {
+		pr_debug("No %s property found\n", MK_DT_RESOURCE_MEMORY);
+		return 0; /* Not an error - property is optional */
+	}
+
+	if (len != 4) {
+		pr_err("Invalid %s property length: %d (must be 4 bytes for single u32 size)\n",
+		       MK_DT_RESOURCE_MEMORY, len);
+		return -EINVAL;
+	}
+
+	/* Parse single memory size value */
+	total_size = fdt32_to_cpu(prop[0]);
+	if (total_size == 0) {
+		pr_err("Invalid memory size 0 in %s\n", MK_DT_RESOURCE_MEMORY);
+		return -EINVAL;
+	}
+
+	/* Validate size alignment */
+	if (total_size & (PAGE_SIZE - 1)) {
+		pr_err("Memory size 0x%zx not page-aligned\n", total_size);
+		return -EINVAL;
+	}
+
+	config->memory_size = total_size;
+	pr_info("Successfully parsed memory size: %zu bytes (%zu MB)\n",
+		total_size, total_size >> 20);
+	return 0;
+}
+
+/**
+ * CPU resource parsing
+ */
+static int mk_dt_parse_cpus(const void *fdt, int chosen_node,
+			    struct mk_dt_config *config)
+{
+	const fdt32_t *prop;
+	int len, i, cpu_count;
+
+	if (!config->cpus_valid) {
+		pr_debug("CPU mask allocation failed, skipping CPU parsing\n");
+		return 0;
+	}
+
+	/* Look for cpus property */
+	prop = fdt_getprop(fdt, chosen_node, MK_DT_RESOURCE_CPUS, &len);
+	if (!prop) {
+		pr_debug("No %s property found\n", MK_DT_RESOURCE_CPUS);
+		return 0; /* Not an error - property is optional */
+	}
+
+	if (len % 4 != 0) {
+		pr_err("Invalid %s property length: %d (must be multiple of 4)\n",
+		       MK_DT_RESOURCE_CPUS, len);
+		return -EINVAL;
+	}
+
+	cpu_count = len / 4; /* Each CPU is a u32 value */
+	if (cpu_count == 0) {
+		pr_err("Empty CPU list in %s\n", MK_DT_RESOURCE_CPUS);
+		return -EINVAL;
+	}
+
+	pr_debug("Parsing %d CPUs\n", cpu_count);
+
+	/* Clear the CPU mask first */
+	cpumask_clear(config->cpus);
+
+	/* Parse each CPU ID */
+	for (i = 0; i < cpu_count; i++) {
+		u32 cpu_id = fdt32_to_cpu(prop[i]);
+
+		/* Validate CPU ID */
+		if (cpu_id >= nr_cpu_ids) {
+		pr_err("Invalid CPU ID %u (max: %u) in %s\n",
+		       cpu_id, nr_cpu_ids - 1, MK_DT_RESOURCE_CPUS);
+			return -EINVAL;
+		}
+
+		/* Check if CPU is online/possible */
+		if (!cpu_possible(cpu_id)) {
+			pr_err("CPU %u is not possible on this system\n", cpu_id);
+			return -EINVAL;
+		}
+
+		/* Add to CPU mask */
+		cpumask_set_cpu(cpu_id, config->cpus);
+		pr_debug("Added CPU %u to multikernel instance\n", cpu_id);
+	}
+
+	pr_info("Successfully parsed %d CPUs: %*pbl\n",
+		cpu_count, cpumask_pr_args(config->cpus));
+	return 0;
+}
+
+/**
+ * Main device tree parsing function
+ */
+int mk_dt_parse(const void *dtb_data, size_t dtb_size,
+		struct mk_dt_config *config)
+{
+	const void *fdt = dtb_data;
+	int ret;
+
+	if (!dtb_data || !config) {
+		pr_err("Invalid parameters to mk_dt_parse\n");
+		return -EINVAL;
+	}
+
+	/* Validate FDT header */
+	ret = fdt_check_header(fdt);
+	if (ret) {
+		pr_err("Invalid device tree blob: %d\n", ret);
+		return -EINVAL;
+	}
+
+	/* Verify size matches */
+	if (fdt_totalsize(fdt) > dtb_size) {
+		pr_err("DTB size mismatch: header=%u, provided=%zu\n",
+		       fdt_totalsize(fdt), dtb_size);
+		return -EINVAL;
+	}
+
+	/* Find /instances node */
+	int instances_node = fdt_path_offset(fdt, "/instances");
+	if (instances_node < 0) {
+		pr_err("No /instances node found in device tree\n");
+		return -ENOENT;
+	}
+
+	/* Find the first (and should be only) instance */
+	int instance_node = fdt_first_subnode(fdt, instances_node);
+	if (instance_node < 0) {
+		pr_err("No instance found in /instances node\n");
+		return -ENOENT;
+	}
+
+	/* Find the resources subnode */
+	int resources_node = fdt_subnode_offset(fdt, instance_node, "resources");
+	if (resources_node < 0) {
+		pr_err("No resources node found in instance\n");
+		return -ENOENT;
+	}
+
+	/* Store raw DTB reference */
+	config->dtb_data = (void *)dtb_data;
+	config->dtb_size = dtb_size;
+
+	/* Parse memory regions */
+	ret = mk_dt_parse_memory(fdt, resources_node, config);
+	if (ret) {
+		pr_err("Failed to parse memory regions: %d\n", ret);
+		mk_dt_config_free(config);
+		return ret;
+	}
+
+	/* Parse CPU resources */
+	ret = mk_dt_parse_cpus(fdt, resources_node, config);
+	if (ret) {
+		pr_err("Failed to parse CPU resources: %d\n", ret);
+		mk_dt_config_free(config);
+		return ret;
+	}
+
+	pr_info("Successfully parsed multikernel device tree with %zu bytes memory and %d CPUs\n",
+		config->memory_size, config->cpus_valid ? cpumask_weight(config->cpus) : 0);
+	return 0;
+}
+
+/**
+ * Configuration validation
+ */
+int mk_dt_validate(const struct mk_dt_config *config)
+{
+	int ret;
+
+	if (!config) {
+		pr_err("NULL configuration\n");
+		return -EINVAL;
+	}
+
+	if (config->version != MK_DT_CONFIG_CURRENT) {
+		pr_err("Unsupported configuration version: %u\n", config->version);
+		return -ENOTSUPP;
+	}
+
+	/* Validate memory regions */
+	ret = mk_dt_validate_memory(config);
+	if (ret)
+		return ret;
+
+	/* Validate CPU resources */
+	ret = mk_dt_validate_cpus(config);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * Memory region validation
+ */
+static int mk_dt_validate_memory(const struct mk_dt_config *config)
+{
+	struct resource *pool_res;
+
+	/* Get multikernel pool resource for validation */
+	pool_res = multikernel_get_pool_resource();
+	if (!pool_res && config->memory_size > 0) {
+		pr_err("No multikernel pool available for memory allocation\n");
+		return -ENODEV;
+	}
+
+	/* Validate memory size */
+	if (config->memory_size > 0) {
+		/* Basic sanity checks */
+		if (config->memory_size < PAGE_SIZE) {
+			pr_err("Memory size too small: %zu bytes\n", config->memory_size);
+			return -EINVAL;
+		}
+
+		if (config->memory_size > SZ_1G) {
+			pr_warn("Large memory size requested: %zu bytes\n", config->memory_size);
+		}
+
+		/* Check if size fits within multikernel pool */
+		if (pool_res) {
+			resource_size_t pool_size = resource_size(pool_res);
+			if (config->memory_size > pool_size) {
+				pr_err("Requested memory size %zu bytes exceeds pool size %llu bytes\n",
+				       config->memory_size, pool_size);
+				return -ERANGE;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * CPU resource validation
+ */
+static int mk_dt_validate_cpus(const struct mk_dt_config *config)
+{
+	int cpu;
+
+	/* Skip validation if CPU assignment is not valid or empty */
+	if (!config->cpus_valid || cpumask_empty(config->cpus))
+		return 0;
+
+	/* Check that all CPUs are still possible/online */
+	for_each_cpu(cpu, config->cpus) {
+		if (!cpu_possible(cpu)) {
+			pr_err("CPU %d is no longer possible on this system\n", cpu);
+			return -EINVAL;
+		}
+
+		if (!cpu_online(cpu)) {
+			pr_warn("CPU %d is not online, multikernel may fail to start\n", cpu);
+		}
+	}
+
+	/* Check for reasonable CPU count */
+	if (cpumask_weight(config->cpus) > num_online_cpus()) {
+		pr_warn("Requested %d CPUs but only %d are online\n",
+			cpumask_weight(config->cpus), num_online_cpus());
+	}
+
+	/* Ensure we don't assign CPU 0 unless explicitly allowed */
+	if (cpumask_test_cpu(0, config->cpus)) {
+		pr_warn("CPU 0 assigned to multikernel instance - this may affect system stability\n");
+	}
+
+	return 0;
+}
+
+/**
+ * Resource availability checking
+ */
+bool mk_dt_resources_available(const struct mk_dt_config *config)
+{
+	struct resource *pool_res;
+
+	if (!config)
+		return false;
+
+	/* Check if multikernel pool is available */
+	pool_res = multikernel_get_pool_resource();
+	if (!pool_res) {
+		pr_debug("No multikernel pool available\n");
+		return false;
+	}
+
+	/* Check if requested memory size is available */
+	if (config->memory_size > 0) {
+		resource_size_t pool_size = resource_size(pool_res);
+		if (pool_size < config->memory_size) {
+			pr_debug("Pool too small: need %zu, have %llu\n",
+				 config->memory_size, pool_size);
+			return false;
+		}
+	}
+
+	/* Check CPU availability */
+	if (config->cpus_valid && !cpumask_empty(config->cpus)) {
+		int cpu;
+
+		for_each_cpu(cpu, config->cpus) {
+			if (!cpu_possible(cpu)) {
+				pr_debug("CPU %d is not possible\n", cpu);
+				return false;
+			}
+		}
+	}
+
+	/* TODO: More sophisticated checking:
+	 * - Check for fragmentation
+	 * - Honor specific start address requests
+	 * - Check for conflicts with existing allocations
+	 * - Check for CPU conflicts with other instances
+	 */
+
+	return true;
+}
+
+/**
+ * Property size helper
+ */
+int mk_dt_get_property_size(const void *dtb_data, size_t dtb_size,
+			    const char *property)
+{
+	const void *fdt = dtb_data;
+	int chosen_node;
+	const void *prop;
+	int len;
+
+	if (!dtb_data || !property)
+		return -EINVAL;
+
+	if (fdt_check_header(fdt))
+		return -EINVAL;
+
+	chosen_node = fdt_path_offset(fdt, "/chosen");
+	if (chosen_node < 0)
+		return -ENOENT;
+
+	prop = fdt_getprop(fdt, chosen_node, property, &len);
+	if (!prop)
+		return -ENOENT;
+
+	return len;
+}
+
+/**
+ * Debug and information functions
+ */
+void mk_dt_print_config(const struct mk_dt_config *config)
+{
+	if (!config) {
+		pr_info("Multikernel DT config: (null)\n");
+		return;
+	}
+
+	pr_info("Multikernel DT config (version %u):\n", config->version);
+
+	if (config->memory_size > 0) {
+		pr_info("  Memory size: %zu bytes (%zu MB)\n",
+			config->memory_size, config->memory_size >> 20);
+	} else {
+		pr_info("  Memory size: none specified\n");
+	}
+
+	if (config->cpus_valid) {
+		if (cpumask_empty(config->cpus)) {
+			pr_info("  CPU assignment: none specified\n");
+		} else {
+			pr_info("  CPU assignment: %*pbl (%d CPUs)\n",
+				cpumask_pr_args(config->cpus), cpumask_weight(config->cpus));
+		}
+	} else {
+		pr_info("  CPU assignment: unavailable (allocation failed)\n");
+	}
+
+	pr_info("  DTB: %zu bytes\n", config->dtb_size);
+}
diff --git a/kernel/multikernel/internal.h b/kernel/multikernel/internal.h
new file mode 100644
index 000000000000..54253d29b2ce
--- /dev/null
+++ b/kernel/multikernel/internal.h
@@ -0,0 +1,4 @@
+extern struct resource multikernel_res;
+extern struct mutex mk_instance_mutex;
+extern struct idr mk_instance_idr;
+extern struct list_head mk_instance_list;
diff --git a/kernel/multikernel/kernfs.c b/kernel/multikernel/kernfs.c
new file mode 100644
index 000000000000..97f6e087edd8
--- /dev/null
+++ b/kernel/multikernel/kernfs.c
@@ -0,0 +1,772 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ *
+ * Multikernel kernel instance filesystem
+ *
+ * Provides a dedicated filesystem for multikernel instance management.
+ * Mounted at /sys/fs/multikernel/ with full mkdir/rmdir support:
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/kref.h>
+#include <linux/ioport.h>
+#include <linux/idr.h>
+#include <linux/kernfs.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/fs_context.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/cpumask.h>
+#include <linux/multikernel.h>
+#include <linux/libfdt.h>
+
+#define MULTIKERNEL_MAGIC	0x6d6b6673	/* "mkfs" */
+
+/* Global multikernel filesystem state */
+static struct kernfs_root *mk_kernfs_root;        /* Kernfs root for multikernel filesystem */
+static struct kernfs_node *mk_root_kn;            /* Root kernfs node */
+static struct kernfs_node *mk_instances_kn;       /* Instances subdirectory node */
+LIST_HEAD(mk_instance_list);                      /* List of all instances */
+DEFINE_MUTEX(mk_instance_mutex);                  /* Protects instance list */
+DEFINE_IDR(mk_instance_idr);               /* ID allocator for instances */
+
+/* Filesystem context structure */
+struct mk_fs_context {
+	struct kernfs_fs_context kfc;
+};
+
+/* Forward declarations */
+static int mk_kernfs_mkdir(struct kernfs_node *parent, const char *name, umode_t mode);
+static int mk_kernfs_rmdir(struct kernfs_node *kn);
+static int mk_get_tree(struct fs_context *fc);
+static void mk_free_fs_context(struct fs_context *fc);
+static int mk_init_fs_context(struct fs_context *fc);
+static void mk_kill_sb(struct super_block *sb);
+static int mk_create_instance_files(struct mk_instance *instance);
+static int mk_create_instance_from_dtb(const char *name, int id, const void *fdt,
+				        int instance_node, size_t full_dtb_size);
+
+/* Kernfs syscall operations */
+static struct kernfs_syscall_ops mk_kernfs_syscall_ops = {
+	.mkdir = mk_kernfs_mkdir,
+	.rmdir = mk_kernfs_rmdir,
+};
+
+/* Filesystem context operations */
+static const struct fs_context_operations mk_fs_context_ops = {
+	.free		= mk_free_fs_context,
+	.get_tree	= mk_get_tree,
+};
+
+/* Filesystem type */
+static struct file_system_type mk_fs_type = {
+	.name			= "multikernel",
+	.init_fs_context	= mk_init_fs_context,
+	.kill_sb		= mk_kill_sb,
+	.fs_flags		= 0,
+};
+
+/**
+ * State string conversion
+ */
+static const char * const mk_state_strings[] = {
+	[MK_STATE_EMPTY]   = "empty",
+	[MK_STATE_READY]   = "ready",
+	[MK_STATE_LOADING] = "loading",
+	[MK_STATE_ACTIVE]  = "active",
+	[MK_STATE_FAILED]  = "failed",
+};
+
+const char *mk_state_to_string(enum mk_instance_state state)
+{
+	if (state >= 0 && state < ARRAY_SIZE(mk_state_strings))
+		return mk_state_strings[state];
+	return "unknown";
+}
+
+enum mk_instance_state mk_string_to_state(const char *str)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mk_state_strings); i++) {
+		if (sysfs_streq(str, mk_state_strings[i]))
+			return i;
+	}
+	return MK_STATE_FAILED;  /* Invalid input */
+}
+
+/**
+ * Kernfs file operations for instance attributes
+ */
+
+/* id attribute - shows kernel-assigned ID */
+static int id_seq_show(struct seq_file *sf, void *v)
+{
+	struct kernfs_open_file *of = sf->private;
+	struct mk_instance *instance = of->kn->priv;
+	seq_printf(sf, "%d\n", instance->id);
+	return 0;
+}
+
+/* status attribute - shows instance state (read-only, managed by kernel) */
+static int status_seq_show(struct seq_file *sf, void *v)
+{
+	struct kernfs_open_file *of = sf->private;
+	struct mk_instance *instance = of->kn->priv;
+	seq_printf(sf, "%s\n", mk_state_to_string(instance->state));
+	return 0;
+}
+
+/* Root-level device_tree attribute - handles full multikernel DTB upload */
+static int root_device_tree_seq_show(struct seq_file *sf, void *v)
+{
+	seq_printf(sf, "Write multikernel device tree here to propagate to instances\n");
+	return 0;
+}
+
+/* Instance device_tree_source attribute - shows instance-specific DTB (read-only) */
+static int device_tree_source_seq_show(struct seq_file *sf, void *v)
+{
+	struct kernfs_open_file *of = sf->private;
+	struct mk_instance *instance = of->kn->priv;
+
+	if (!instance->dtb_data) {
+		seq_printf(sf, "(no device tree loaded)\n");
+		return 0;
+	}
+
+	/* Parse the instance DTB and show it with the instance as root */
+	const void *fdt = instance->dtb_data;
+	int ret = fdt_check_header(fdt);
+	if (ret) {
+		seq_printf(sf, "/* Invalid device tree blob: %d */\n", ret);
+		return 0;
+	}
+
+	int instances_node = fdt_path_offset(fdt, "/instances");
+	if (instances_node < 0) {
+		seq_printf(sf, "/* No instances node found */\n");
+		return 0;
+	}
+
+	/* Find the first (and should be only) instance in this per-instance DTB */
+	int instance_node = fdt_first_subnode(fdt, instances_node);
+	if (instance_node < 0) {
+		seq_printf(sf, "/* No instance found */\n");
+		return 0;
+	}
+
+	const char *instance_name = fdt_get_name(fdt, instance_node, NULL);
+	if (!instance_name) {
+		seq_printf(sf, "/* Invalid instance name */\n");
+		return 0;
+	}
+
+	/* Show the DTB with instance as root node */
+	seq_printf(sf, "/dts-v1/;\n\n");
+	seq_printf(sf, "/%s {\n", instance_name);
+	seq_printf(sf, "\tcompatible = \"multikernel-v1\";\n");
+
+	/* Display instance properties */
+	int prop_offset = fdt_first_property_offset(fdt, instance_node);
+	while (prop_offset >= 0) {
+		const struct fdt_property *prop = fdt_get_property_by_offset(fdt, prop_offset, NULL);
+		if (prop) {
+			const char *prop_name = fdt_string(fdt, fdt32_to_cpu(prop->nameoff));
+			int prop_len = fdt32_to_cpu(prop->len);
+
+			if (prop_len == 4) {
+				/* Assume it's a u32 */
+				u32 val = fdt32_to_cpu(*(const fdt32_t *)prop->data);
+				seq_printf(sf, "\t%s = <%u>;\n", prop_name, val);
+			} else {
+				/* For other types, show as hex */
+				seq_printf(sf, "\t%s = [", prop_name);
+				const u8 *data = (const u8 *)prop->data;
+				for (int i = 0; i < prop_len; i++) {
+					seq_printf(sf, "%02x", data[i]);
+					if (i < prop_len - 1) seq_printf(sf, " ");
+				}
+				seq_printf(sf, "];\n");
+			}
+		}
+		prop_offset = fdt_next_property_offset(fdt, prop_offset);
+	}
+
+	/* Display subnodes (like resources) */
+	int subnode;
+	fdt_for_each_subnode(subnode, fdt, instance_node) {
+		const char *subnode_name = fdt_get_name(fdt, subnode, NULL);
+		if (subnode_name) {
+			seq_printf(sf, "\t%s {\n", subnode_name);
+
+			/* Display subnode properties */
+			prop_offset = fdt_first_property_offset(fdt, subnode);
+			while (prop_offset >= 0) {
+				const struct fdt_property *prop = fdt_get_property_by_offset(fdt, prop_offset, NULL);
+				if (prop) {
+					const char *prop_name = fdt_string(fdt, fdt32_to_cpu(prop->nameoff));
+					int prop_len = fdt32_to_cpu(prop->len);
+
+					if (prop_len == 4) {
+						/* Assume it's a u32 */
+						u32 val = fdt32_to_cpu(*(const fdt32_t *)prop->data);
+						if (strcmp(prop_name, "memory-bytes") == 0) {
+							seq_printf(sf, "\t\t%s = <0x%x>; // %u MB\n",
+								   prop_name, val, val >> 20);
+						} else {
+							seq_printf(sf, "\t\t%s = <%u>;\n", prop_name, val);
+						}
+					} else {
+						/* For other types, show as hex */
+						seq_printf(sf, "\t\t%s = [", prop_name);
+						const u8 *data = (const u8 *)prop->data;
+						for (int i = 0; i < prop_len; i++) {
+							seq_printf(sf, "%02x", data[i]);
+							if (i < prop_len - 1) seq_printf(sf, " ");
+						}
+						seq_printf(sf, "];\n");
+					}
+				}
+				prop_offset = fdt_next_property_offset(fdt, prop_offset);
+			}
+
+			seq_printf(sf, "\t};\n");
+		}
+	}
+
+	seq_printf(sf, "};\n");
+	return 0;
+}
+
+/* Root-level device_tree write - parses multikernel DTB and creates instances */
+static ssize_t root_device_tree_write(struct kernfs_open_file *of, char *buf, size_t count, loff_t off)
+{
+	const void *fdt = buf;
+	int instances_node, instance_node;
+	const fdt32_t *id_prop;
+	const char *instance_name;
+	struct mk_instance *instance;
+	int ret;
+
+	pr_info("Loading multikernel device tree (%zu bytes)\n", count);
+
+	/* Validate DTB header */
+	ret = fdt_check_header(fdt);
+	if (ret) {
+		pr_err("Invalid device tree header: %d\n", ret);
+		return -EINVAL;
+	}
+
+	/* Find /instances node */
+	instances_node = fdt_path_offset(fdt, "/instances");
+	if (instances_node < 0) {
+		pr_err("No /instances node found in device tree\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&mk_instance_mutex);
+
+	/* Iterate through each instance in the DTB */
+	fdt_for_each_subnode(instance_node, fdt, instances_node) {
+		/* Get instance name */
+		instance_name = fdt_get_name(fdt, instance_node, NULL);
+		if (!instance_name) {
+			pr_err("Failed to get instance name\n");
+			continue;
+		}
+
+		/* Get instance ID */
+		id_prop = fdt_getprop(fdt, instance_node, "id", NULL);
+		if (!id_prop) {
+			pr_err("No 'id' property found in instance '%s'\n", instance_name);
+			continue;
+		}
+
+		/* Check if instance already exists */
+		instance = mk_instance_find_by_name(instance_name);
+		if (instance) {
+			pr_info("Instance '%s' already exists, updating DTB\n", instance_name);
+		} else {
+			/* Create new instance */
+			ret = mk_create_instance_from_dtb(instance_name, fdt32_to_cpu(*id_prop),
+							  fdt, instance_node, count);
+			if (ret) {
+				pr_err("Failed to create instance '%s': %d\n", instance_name, ret);
+				continue;
+			}
+		}
+	}
+
+	mutex_unlock(&mk_instance_mutex);
+
+	pr_info("Successfully processed multikernel device tree\n");
+	return count;
+}
+
+/* Helper function to extract instance DTB from a specific node */
+static int mk_extract_instance_dtb_from_node(const void *fdt, int instance_node,
+					      const char *instance_name,
+					      void **instance_dtb, size_t *instance_size)
+{
+	void *new_fdt;
+	int ret;
+	size_t new_size = PAGE_SIZE;
+
+	/* Create new DTB with just this instance */
+	new_fdt = kmalloc(new_size, GFP_KERNEL);
+	if (!new_fdt)
+		return -ENOMEM;
+
+	ret = fdt_create(new_fdt, new_size);
+	ret |= fdt_finish_reservemap(new_fdt);
+	ret |= fdt_begin_node(new_fdt, "");
+	ret |= fdt_property_string(new_fdt, "compatible", "multikernel-v1");
+	ret |= fdt_begin_node(new_fdt, "instances");
+
+	/* Copy the instance node */
+	ret |= fdt_begin_node(new_fdt, instance_name);
+
+	/* Copy all properties from the instance node */
+	int prop_offset = fdt_first_property_offset(fdt, instance_node);
+	while (prop_offset >= 0) {
+		const struct fdt_property *prop = fdt_get_property_by_offset(fdt, prop_offset, NULL);
+		if (prop) {
+			const char *prop_name = fdt_string(fdt, fdt32_to_cpu(prop->nameoff));
+			ret |= fdt_property(new_fdt, prop_name, prop->data, fdt32_to_cpu(prop->len));
+		}
+		prop_offset = fdt_next_property_offset(fdt, prop_offset);
+	}
+
+	/* Copy all subnodes from the instance node (including resources) */
+	int subnode;
+	fdt_for_each_subnode(subnode, fdt, instance_node) {
+		const char *subnode_name = fdt_get_name(fdt, subnode, NULL);
+		if (!subnode_name)
+			continue;
+
+		ret |= fdt_begin_node(new_fdt, subnode_name);
+
+		/* Copy all properties from the subnode */
+		prop_offset = fdt_first_property_offset(fdt, subnode);
+		while (prop_offset >= 0) {
+			const struct fdt_property *prop = fdt_get_property_by_offset(fdt, prop_offset, NULL);
+			if (prop) {
+				const char *prop_name = fdt_string(fdt, fdt32_to_cpu(prop->nameoff));
+				ret |= fdt_property(new_fdt, prop_name, prop->data, fdt32_to_cpu(prop->len));
+			}
+			prop_offset = fdt_next_property_offset(fdt, prop_offset);
+		}
+
+		ret |= fdt_end_node(new_fdt); /* end subnode */
+	}
+	ret |= fdt_end_node(new_fdt); /* end instance */
+	ret |= fdt_end_node(new_fdt); /* end instances */
+	ret |= fdt_end_node(new_fdt); /* end root */
+	ret |= fdt_finish(new_fdt);
+
+	if (ret) {
+		pr_err("Failed to create instance DTB: %d\n", ret);
+		kfree(new_fdt);
+		return ret;
+	}
+
+	*instance_dtb = new_fdt;
+	*instance_size = fdt_totalsize(new_fdt);
+
+	return 0;
+}
+
+static int mk_create_instance_from_dtb(const char *name, int id, const void *fdt,
+				       int instance_node, size_t full_dtb_size)
+{
+	struct mk_instance *instance;
+	struct kernfs_node *kn;
+	struct mk_dt_config config;
+	void *instance_dtb;
+	size_t instance_dtb_size;
+	int ret;
+
+	ret = mk_extract_instance_dtb_from_node(fdt, instance_node, name,
+						&instance_dtb, &instance_dtb_size);
+	if (ret) {
+		pr_err("Failed to extract DTB for instance '%s': %d\n", name, ret);
+		return ret;
+	}
+
+	instance = kzalloc(sizeof(*instance), GFP_KERNEL);
+	if (!instance) {
+		kfree(instance_dtb);
+		return -ENOMEM;
+	}
+
+	instance->id = id;
+	instance->name = kstrdup(name, GFP_KERNEL);
+	if (!instance->name) {
+		ret = -ENOMEM;
+		goto cleanup_instance;
+	}
+
+	instance->state = MK_STATE_EMPTY;
+	INIT_LIST_HEAD(&instance->list);
+	INIT_LIST_HEAD(&instance->memory_regions);
+	instance->region_count = 0;
+	kref_init(&instance->refcount);
+
+	/* Initialize CPU mask */
+	if (!alloc_cpumask_var(&instance->cpus, GFP_KERNEL)) {
+		pr_warn("Failed to allocate CPU mask for instance '%s'\n", name);
+		instance->cpus_valid = false;
+	} else {
+		cpumask_clear(instance->cpus);
+		instance->cpus_valid = true;
+	}
+
+	/* Create kernfs directory under instances/ */
+	kn = kernfs_create_dir(mk_instances_kn, name, 0755, instance);
+	if (IS_ERR(kn)) {
+		ret = PTR_ERR(kn);
+		pr_err("Failed to create kernfs directory for instance '%s': %d\n", name, ret);
+		goto cleanup_instance_name;
+	}
+
+	instance->kn = kn;
+
+	/* Parse and validate the instance DTB */
+	mk_dt_config_init(&config);
+	ret = mk_dt_parse(instance_dtb, instance_dtb_size, &config);
+	if (ret) {
+		pr_err("Failed to parse DTB for instance '%s': %d\n", name, ret);
+		goto cleanup_kernfs;
+	}
+
+	/* Reserve resources */
+	ret = mk_instance_reserve_resources(instance, &config);
+	if (ret) {
+		pr_err("Failed to reserve resources for instance '%s': %d\n", name, ret);
+		goto cleanup_config;
+	}
+
+	/* Store DTB data in instance */
+	instance->dtb_data = instance_dtb;
+	instance->dtb_size = instance_dtb_size;
+
+	/* Create instance attribute files */
+	ret = mk_create_instance_files(instance);
+	if (ret) {
+		pr_err("Failed to create attribute files for instance '%s': %d\n", name, ret);
+		goto cleanup_config;
+	}
+
+	/* Store in IDR for quick lookup */
+	ret = idr_alloc(&mk_instance_idr, instance, id, id + 1, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("Failed to allocate IDR slot %d for instance '%s': %d\n", id, name, ret);
+		goto cleanup_config;
+	}
+
+	/* Add to global list */
+	list_add_tail(&instance->list, &mk_instance_list);
+
+	/* Update instance state */
+	mk_instance_set_state(instance, MK_STATE_READY);
+
+	/* Activate the kernfs node */
+	kernfs_activate(kn);
+
+	/* Clean up parsed config */
+	mk_dt_config_free(&config);
+
+	pr_info("Created instance '%s' (ID: %d) from multikernel DTB\n", name, id);
+	return 0;
+
+cleanup_config:
+	mk_dt_config_free(&config);
+cleanup_kernfs:
+	kernfs_remove(kn);
+cleanup_instance_name:
+	kfree(instance->name);
+cleanup_instance:
+	kfree(instance);
+	kfree(instance_dtb);
+	return ret;
+}
+
+
+/* Kernfs file operations */
+static const struct kernfs_ops mk_id_ops = {
+	.seq_show = id_seq_show,
+};
+
+static const struct kernfs_ops mk_status_ops = {
+	.seq_show = status_seq_show,
+};
+
+/* Root-level device_tree operations */
+static const struct kernfs_ops mk_root_device_tree_ops = {
+	.seq_show = root_device_tree_seq_show,
+	.write = root_device_tree_write,
+};
+
+/* Instance device_tree_source operations (read-only) */
+static const struct kernfs_ops mk_device_tree_source_ops = {
+	.seq_show = device_tree_source_seq_show,
+};
+
+
+/**
+ * Create instance attributes in kernfs
+ */
+static int mk_create_instance_files(struct mk_instance *instance)
+{
+	struct kernfs_node *kn;
+
+	/* Create id file */
+	kn = __kernfs_create_file(instance->kn, "id", 0444,
+				  GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+				  &mk_id_ops, instance, NULL, NULL);
+	if (IS_ERR(kn)) {
+		pr_err("Failed to create id file for instance %s\n", instance->name);
+		return PTR_ERR(kn);
+	}
+
+	/* Create status file (read-only, managed by kernel) */
+	kn = __kernfs_create_file(instance->kn, "status", 0444,
+				  GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+				  &mk_status_ops, instance, NULL, NULL);
+	if (IS_ERR(kn)) {
+		pr_err("Failed to create status file for instance %s\n", instance->name);
+		return PTR_ERR(kn);
+	}
+
+	/* Create device_tree_source file (read-only) */
+	kn = __kernfs_create_file(instance->kn, "device_tree_source", 0444,
+				  GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+				  &mk_device_tree_source_ops, instance, NULL, NULL);
+	if (IS_ERR(kn)) {
+		pr_err("Failed to create device_tree_source file for instance %s\n", instance->name);
+		return PTR_ERR(kn);
+	}
+
+
+	return 0;
+}
+
+/**
+ * mk_kernfs_mkdir - Handle mkdir operations in multikernel kernfs
+ * @parent: Parent kernfs node
+ * @name: Directory name to create
+ * @mode: Directory mode
+ *
+ * This function is called when user does: mkdir /sys/kernel/multikernel/my-kernel
+ */
+static int mk_kernfs_mkdir(struct kernfs_node *parent, const char *name, umode_t mode)
+{
+	/* Only allow mkdir under instances/ directory */
+	if (parent != mk_instances_kn) {
+		pr_err("Instances can only be created under /instances directory\n");
+		return -EPERM;
+	}
+
+	/* Manual instance creation is now disabled - instances are created via device_tree upload */
+	pr_err("Manual instance creation disabled. Upload multikernel device tree to /device_tree instead.\n");
+	return -EPERM;
+}
+
+/**
+ * mk_kernfs_rmdir - Handle rmdir operations in multikernel kernfs
+ * @kn: Kernfs node to remove
+ */
+static int mk_kernfs_rmdir(struct kernfs_node *kn)
+{
+	struct mk_instance *instance = kn->priv;
+
+	if (!instance) {
+		pr_err("No instance data found for kernfs node\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&mk_instance_mutex);
+
+	/* Check if instance is active - prevent removal of active instances */
+	if (instance->state == MK_STATE_ACTIVE) {
+		mutex_unlock(&mk_instance_mutex);
+		pr_err("Cannot remove active instance '%s' (ID: %d). Instance must be stopped first.\n",
+		       instance->name, instance->id);
+		return -EBUSY;
+	}
+
+	/* Check if instance is currently loading - also prevent removal */
+	if (instance->state == MK_STATE_LOADING) {
+		mutex_unlock(&mk_instance_mutex);
+		pr_err("Cannot remove loading instance '%s' (ID: %d). Wait for loading to complete.\n",
+		       instance->name, instance->id);
+		return -EBUSY;
+	}
+
+	list_del(&instance->list);
+	idr_remove(&mk_instance_idr, instance->id);
+
+	mutex_unlock(&mk_instance_mutex);
+
+	mk_instance_put(instance);
+	kernfs_remove_self(kn);
+	return 0;
+}
+
+/**
+ * Filesystem operations implementation
+ */
+
+static int mk_init_fs_context(struct fs_context *fc)
+{
+	struct mk_fs_context *ctx;
+	struct kernfs_fs_context *kfc;
+
+	ctx = kzalloc(sizeof(struct mk_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	kfc = &ctx->kfc;
+	kfc->root = mk_kernfs_root;
+	kfc->magic = MULTIKERNEL_MAGIC;
+	fc->fs_private = ctx;
+	fc->ops = &mk_fs_context_ops;
+	fc->global = true;
+	return 0;
+}
+
+static int mk_get_tree(struct fs_context *fc)
+{
+	int ret;
+
+	ret = kernfs_get_tree(fc);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void mk_free_fs_context(struct fs_context *fc)
+{
+	struct mk_fs_context *ctx = fc->fs_private;
+
+	if (ctx) {
+		kernfs_free_fs_context(fc);
+		kfree(ctx);
+	}
+	fc->fs_private = NULL;
+}
+
+static void mk_kill_sb(struct super_block *sb)
+{
+	kernfs_kill_sb(sb);
+}
+
+/**
+ * Module initialization and cleanup
+ */
+int mk_kernfs_init(void)
+{
+	int ret;
+
+	/* Create kernfs root with mkdir/rmdir support */
+	mk_kernfs_root = kernfs_create_root(&mk_kernfs_syscall_ops,
+					    KERNFS_ROOT_CREATE_DEACTIVATED,
+					    NULL);
+	if (IS_ERR(mk_kernfs_root)) {
+		ret = PTR_ERR(mk_kernfs_root);
+		pr_err("Failed to create multikernel kernfs root: %d\n", ret);
+		return ret;
+	}
+
+	/* Get the root kernfs node */
+	mk_root_kn = kernfs_root_to_node(mk_kernfs_root);
+
+	/* Create instances subdirectory */
+	mk_instances_kn = kernfs_create_dir(mk_root_kn, "instances", 0755, NULL);
+	if (IS_ERR(mk_instances_kn)) {
+		ret = PTR_ERR(mk_instances_kn);
+		pr_err("Failed to create instances directory: %d\n", ret);
+		kernfs_destroy_root(mk_kernfs_root);
+		return ret;
+	}
+
+	/* Create root-level device_tree file */
+	struct kernfs_node *device_tree_kn = __kernfs_create_file(mk_root_kn, "device_tree", 0644,
+								   GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+								   &mk_root_device_tree_ops, NULL, NULL, NULL);
+	if (IS_ERR(device_tree_kn)) {
+		ret = PTR_ERR(device_tree_kn);
+		pr_err("Failed to create root device_tree file: %d\n", ret);
+		kernfs_destroy_root(mk_kernfs_root);
+		return ret;
+	}
+
+	/* Register the filesystem */
+	ret = register_filesystem(&mk_fs_type);
+	if (ret) {
+		pr_err("Failed to register multikernel filesystem: %d\n", ret);
+		kernfs_destroy_root(mk_kernfs_root);
+		return ret;
+	}
+
+	/* Create a mount point in sysfs */
+	ret = sysfs_create_mount_point(fs_kobj, "multikernel");
+	if (ret) {
+		pr_err("Failed to create multikernel mount point: %d\n", ret);
+		unregister_filesystem(&mk_fs_type);
+		kernfs_destroy_root(mk_kernfs_root);
+		return ret;
+	}
+
+	/* Activate the kernfs root */
+	kernfs_activate(mk_root_kn);
+
+	pr_info("Multikernel filesystem initialized. Mount with: mount -t multikernel none /sys/fs/multikernel\n");
+	return 0;
+}
+
+void mk_kernfs_cleanup(void)
+{
+	struct mk_instance *instance, *tmp;
+
+	/* Remove all instances */
+	mutex_lock(&mk_instance_mutex);
+	list_for_each_entry_safe(instance, tmp, &mk_instance_list, list) {
+		list_del(&instance->list);
+		idr_remove(&mk_instance_idr, instance->id);
+		mk_instance_put(instance);
+	}
+	mutex_unlock(&mk_instance_mutex);
+
+	/* Clean up IDR */
+	idr_destroy(&mk_instance_idr);
+
+	/* Remove sysfs mount point */
+	sysfs_remove_mount_point(fs_kobj, "multikernel");
+
+	/* Unregister filesystem */
+	unregister_filesystem(&mk_fs_type);
+
+	/* Remove kernfs directory */
+	if (mk_root_kn) {
+		kernfs_remove(mk_root_kn);
+		mk_root_kn = NULL;
+	}
+
+	/* Destroy kernfs root */
+	if (mk_kernfs_root) {
+		kernfs_destroy_root(mk_kernfs_root);
+		mk_kernfs_root = NULL;
+	}
+
+	pr_info("Multikernel filesystem cleaned up\n");
+}
-- 
2.34.1


