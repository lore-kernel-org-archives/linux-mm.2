Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C2ED232C7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 00:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA576B008A; Thu,  8 Jan 2026 19:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91836B0092; Thu,  8 Jan 2026 19:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94C26B0093; Thu,  8 Jan 2026 19:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C626B6B008A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:11:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 962ABC18BB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:36 +0000 (UTC)
X-FDA: 84310496592.14.CABFA49
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id A21CA1C0004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cH7PeDdf;
	spf=pass (imf20.hostedemail.com: domain of 3tUdgaQgKCBg7yGCBA6I4CC492.0CA96BIL-AA8Jy08.CF4@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3tUdgaQgKCBg7yGCBA6I4CC492.0CA96BIL-AA8Jy08.CF4@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767917494; a=rsa-sha256;
	cv=none;
	b=L8u9VbGTdlhzrwsi/Kc9sRQRNf8IoKLxmBi2sqcvSPEChzm9gvTj0+YhEH5dCqdzQ0uc4W
	KoQPAU1x+23AlpJz69Sb5yBThC9AhOJMDOwHJNK1mwAC/fXgfhq8oY2e+fPkwj6vpx+SnB
	vbBhJAgjRT6Cs2ArhIp20WrgY3cZq9Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cH7PeDdf;
	spf=pass (imf20.hostedemail.com: domain of 3tUdgaQgKCBg7yGCBA6I4CC492.0CA96BIL-AA8Jy08.CF4@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3tUdgaQgKCBg7yGCBA6I4CC492.0CA96BIL-AA8Jy08.CF4@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767917494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWLyCZ/AfdZpAgAsiHnyUKG0P8QmXPBkf7+qJJ/50+E=;
	b=gRIajoZ//vKH2wHHWTIXVgfXmxw3DWH2Z9U8mNpCKhV7yiso9w0FXoYo8fPCfAjrR3/oz3
	zwYyRUTMFdouSlEqu1/8tkwp10vecvwYBrQP4pBHhonP4oQJ6kejXrNmgxohrqoB4qSvMV
	9CaE6AozCfrsFqAcZGexVc+J+D+efoQ=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b04f8c5e84so3498273eec.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 16:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767917493; x=1768522293; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AWLyCZ/AfdZpAgAsiHnyUKG0P8QmXPBkf7+qJJ/50+E=;
        b=cH7PeDdfZH0NzJCXeV66XT0pb8xHvFWEqyB8jwC2kIj2ozwsCvZlpPXRHkJn7LQUtl
         snqUDpMfJmc9JsbpDTq0TQaBgxtL47BBcqstbUgEegi9uZnni0H1EksDgfUGprtazvcY
         +PeVT/twkrCZrRO2LWbnYmRTjvQPbtmP/3aujwM0YxMN9Xglx+ME4GO6l9sKkflUvYTd
         kQjS6jR+xieY1Wz+zzAShc0CMbZR462sv9qyK/9MeFYW+vOH8jGLLwfxafh+5GDmo0Q9
         RzCHiUcD6sGoadsNBcQwaT2FPHN3Fz+XvUBnuPU8ZAQZrhPX31Wj6s+qOPZBPOWo8fqQ
         2/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767917493; x=1768522293;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AWLyCZ/AfdZpAgAsiHnyUKG0P8QmXPBkf7+qJJ/50+E=;
        b=dfN73mHitJ6nMrOD2qYjuuBo+Kw4AfQP9MiR9+UeaYHAoORDTziMwxOQ/PExKQca4v
         oX+bAjw2sabbT+I8UPiAHa/XIdsQ75ZtRhpZwQJInQnfVTog/4LKmL/QtqGiTsMcfeW3
         tcQKk6ZphKybRWV1kTIHQkw1HGNjy8HYtYwpC5udk+OPYfykUJzmS8dC7Nuq21QVOLov
         JKTY3maTkRcFbicWXE+ZhVl55eba7UF4EbdUku+3gxcY8cq8AMcMUk3h5JvtEgsybe+v
         ++02Lto1jUyDwXdxxHq85b4lf2TKZ8EGeVtAXZ8uHcaZkjeu9I9YuCDDYfCR/Amxcv0B
         LJeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXUE+LFWREPkZBwA20CZrrEjjOkG2Y0gCzHkMpI/uy6/ISgnpXlT4RTAIBQEJw7zrDD1KwwPBbIQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9X1wE6tS7vgeRF7YsWEMtoE5B4aGGV5tFzQ0Qeuqq1pt05Udl
	H5EJ1Svs+QsiDq8iIL7gWRjOa/vi9uX133HXo2/GQpOcNQly1zCn/Fd8e0X3uC4Tf6t/H5Q42Fv
	xC17ACwJNak4llA==
X-Google-Smtp-Source: AGHT+IFA7Yv4goEDmpR+z1yXPW3hKABa9rYuxzfsiraoD1u+yOiW/5xG4UE2dBbIVr3LcwJ0oAUlK+FXxTwpMQ==
X-Received: from dlbrf6.prod.google.com ([2002:a05:7022:f206:b0:11d:ccc4:4c98])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:6993:b0:11b:9b9f:4283 with SMTP id a92af1059eb24-121f8b46117mr6883880c88.24.1767917493315;
 Thu, 08 Jan 2026 16:11:33 -0800 (PST)
Date: Thu,  8 Jan 2026 16:11:26 -0800
In-Reply-To: <20260109001127.2596222-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260109001127.2596222-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109001127.2596222-2-jasonmiu@google.com>
Subject: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory tracking
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: a6mhwc1gh5yg6tynprjg6a8sb9szqrzt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A21CA1C0004
X-Rspam-User: 
X-HE-Tag: 1767917494-498581
X-HE-Meta: U2FsdGVkX18On1gQUI03t0WFROoRvfF8dXuI600+B9xySnkLdYhTNWKGOAEmhCw72aolgBTPSpfQfSb/+eV0aWUh5BkUdyiQTKny+hQMYLYsh5rTJGSiHhiBpKADprZdFSw8eZjKiAQ96HTJVjvdLKos2P582UQhZzsS34OQnOAM42wMnmY1UkjViwsCjRjWnPFuc0mmJKSk/JF1tH5DlaTrBJWIeC1X6CN0bCgII0cZ2moJwnzzNlkbXFCHRlxuGSVwalHtD2GnritUiiWNplsL41lef4dMZXZHh23bECxa2zZviEQvu+kjcrkAOfnWaqpzsMwi/l3mQE8PrvBv7ZBl4oRsiJAUe5i0+9T2FwIWRlHZDSrYaj6A1CxmvYUrcgXoN6BapXMoGTK2+dnl0CGbFgFqOg/BhPtzTcVp9//KL17HZTbsHRnL/4cEy+STx3V3cJYFJm61idwS4odgRzRPbwbOidXS4wzFltX4VIp8NSkw35DePdpDygOotfSXZ6jHEKFm/NaChB04tSHN3Y259Ga1LXdY4PROLIqZOqzVNCVeiorgGORi+yAnwa65vAgkU5IqLxoox9IekkSFeU0THdR6bT+UwJPZNFFo7g/mHr2CHCfg9uPx3zgsHh2W7DI3ah3Xlf6kkbvFEIJfO0eGgTQeCkZ/yUQhtR53GUEiN39NWcp6aU8c6fgO6rHkSyXGEqFPhb6f6zW0ML/kUxjSAv5/RQMhBqI2udXpPGO6RVaIxp7xXOL0sBOTJG4PAucqqpcGXg2SvCAtayFL7mVZ8Ijl/gwdgkSLm3hiqy5LgHgzQSFMyKdVdLEp/9OJYk76dGf4O3IS8G9IibAZ+3ibu77+KoOZUecAtoSL3C9u7f4Sb1ygRxbWCLWl3tJT9pPH63VPyOe+/sG4JUzS2wASLat44eJbavMXOnyfAhJHXZAREmpDgyqoVcgMot4C7uD3+A0UGlOj9bSLtR5
 kA4e+ZRE
 1ll2fxmLh5vQuzIEl7vnsPH20Plpw40lBcUr8qTE+P0uJLlIcghZwtExjfB9qKL1IXohEOwQBGqqjNJy1uU8s4JpxBWCQSCpZ+5cbShfJHal0m9hn1nKW8aOiTG2fwF0mqwNVDNNSu9qOyh5eYfqyIpn3cBAIyOuT7aNOFCk1Q4GomFKeFvoZVX1QYBdhlrTBcb5Ol7CbX5xSUK2Wca7AtDHrOQ0IDnbmOKNhnrPOlLikR0TYQmZMm90lH3Nlwfv7cghAnrGnZJnIoL10InWAoyE+Bts9DeayXuJNm04AFZxst45l6/FlUVgPqL4dJi6pOeDjv9EaWc9xCTvd9xCKMay1t1Ilr3jVNzTCeXvxkg2MR3lenLYzRsy8mN/wNO9LtPJRfjmNgMuu+ZtJUv/PRMgbsK3bG4XIkCJo3EAbMDQFk8aRarYzHthxoIOeVpNqIg8+GC0jOx86FBe+Q93hkc+B10lOhwQs1S9CV2xsBldyj/4HxYDCTqPIv2tJSs2sRc9q/eRowuWdK+2fq8nR8wA4COYi1E9eJjuy9jobYomFuGAihEwPsPjRkC8mYZka+pHm1INkpVrTcy2Vy3xhaLynbQuiNfQxhjkuZrmBKVeJp1SSXlmLI+xYgYRkoAxYFgXe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a radix tree implementation for tracking preserved memory
pages and switch the KHO memory tracking mechanism to use it. This
lays the groundwork for a stateless KHO implementation that eliminates
the need for serialization and the associated "finalize" state.

This patch introduces the core radix tree data structures and
constants to the KHO ABI. It adds the radix tree node and leaf
structures, along with documentation for the radix tree key encoding
scheme that combines a page's physical address and order.

To support broader use by other kernel subsystems, such as hugetlb
preservation, the core radix tree manipulation functions are exported
as a public API.

The xarray-based memory tracking is replaced with this new radix tree
implementation. The core KHO preservation and unpreservation functions
are wired up to use the radix tree helpers. On boot, the second kernel
restores the preserved memory map by walking the radix tree whose root
physical address is passed via the FDT.

The ABI `compatible` version is bumped to "kho-v2" to reflect the
structural changes in the preserved memory map and sub-FDT property
names. This includes renaming "fdt" to "preserved-data" to better
reflect that preserved state may use formats other than FDT.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 Documentation/core-api/kho/abi.rst     |   6 +
 Documentation/core-api/kho/index.rst   |  16 +
 include/linux/kho/abi/kexec_handover.h | 141 ++++-
 include/linux/kho_radix_tree.h         |  72 +++
 kernel/liveupdate/kexec_handover.c     | 722 +++++++++++++------------
 5 files changed, 583 insertions(+), 374 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index 2e63be3486cf..799d743105a6 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -22,6 +22,12 @@ memblock preservation ABI
 .. kernel-doc:: include/linux/kho/abi/memblock.h
    :doc: memblock kexec handover ABI
 
+KHO persistent memory tracker ABI
+=================================
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+  :doc: KHO persistent memory tracker
+
 See Also
 ========
 
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index f56579b5c351..7ddc4d3ecac5 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -4,6 +4,8 @@
 Kexec Handover Subsystem
 ========================
 
+.. _kho-concepts:
+
 Overview
 ========
 
@@ -72,6 +74,8 @@ the next KHO, because kexec can overwrite even the original kernel.
 KHO finalization phase
 ======================
 
+.. _kho-finalization-phase:
+
 To enable user space based kexec file loader, the kernel needs to be able to
 provide the FDT that describes the current kernel's state before
 performing the actual kexec. The process of generating that FDT is
@@ -79,6 +83,18 @@ called serialization. When the FDT is generated, some properties
 of the system may become immutable because they are already written down
 in the FDT. That state is called the KHO finalization phase.
 
+Kexec Handover Radix Tree
+=========================
+
+.. kernel-doc:: include/linux/kho_radix_tree.h
+  :doc: Kexec Handover Radix Tree
+
+Public API
+==========
+
+.. kernel-doc:: kernel/liveupdate/kexec_handover.c
+  :export:
+
 See Also
 ========
 
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 285eda8a36e4..06836edb14f0 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -10,6 +10,8 @@
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
+#include <linux/bits.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 
 /**
@@ -29,32 +31,32 @@
  * compatibility is only guaranteed for kernels supporting the same ABI version.
  *
  * FDT Structure Overview:
- *   The FDT serves as a central registry for physical
- *   addresses of preserved data structures and sub-FDTs. The first kernel
- *   populates this FDT with references to memory regions and other FDTs that
- *   need to persist across the kexec transition. The subsequent kernel then
- *   parses this FDT to locate and restore the preserved data.::
+ *   The FDT serves as a central registry for physical addresses of preserved
+ *   data structures. The first kernel populates this FDT with references to
+ *   memory regions and other metadata that need to persist across the kexec
+ *   transition. The subsequent kernel then parses this FDT to locate and
+ *   restore the preserved data.::
  *
  *     / {
- *         compatible = "kho-v1";
+ *         compatible = "kho-v2";
  *
  *         preserved-memory-map = <0x...>;
  *
  *         <subnode-name-1> {
- *             fdt = <0x...>;
+ *             preserved-data = <0x...>;
  *         };
  *
  *         <subnode-name-2> {
- *             fdt = <0x...>;
+ *             preserved-data = <0x...>;
  *         };
  *               ... ...
  *         <subnode-name-N> {
- *             fdt = <0x...>;
+ *             preserved-data = <0x...>;
  *         };
  *     };
  *
  *   Root KHO Node (/):
- *     - compatible: "kho-v1"
+ *     - compatible: "kho-v2"
  *
  *       Indentifies the overall KHO ABI version.
  *
@@ -69,20 +71,20 @@
  *     is provided by the subsystem that uses KHO for preserving its
  *     data.
  *
- *     - fdt: u64
+ *     - preserved-data: u64
  *
- *       Physical address pointing to a subnode FDT blob that is also
+ *       Physical address pointing to a subnode data blob that is also
  *       being preserved.
  */
 
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v1"
+#define KHO_FDT_COMPATIBLE "kho-v2"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
 
-/* The FDT property for sub-FDTs. */
-#define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
+/* The FDT property for preserved data blobs. */
+#define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
 
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
@@ -160,4 +162,113 @@ struct kho_vmalloc {
 	unsigned short order;
 };
 
+/**
+ * DOC: KHO persistent memory tracker
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
+ * is composed of two parts: the 'order bit' in the upper part and the 'page
+ * offset' in the lower part.::
+ *
+ *   +------------+-----------------------------+--------------------------+
+ *   | Page Order | Order Bit                   | Page Offset              |
+ *   +------------+-----------------------------+--------------------------+
+ *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
+ *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
+ *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
+ *   | ...        | ...                         | ...                      |
+ *   +------------+-----------------------------+--------------------------+
+ *
+ * Page Offset:
+ * The 'page offset' is the physical address normalized for its order. It
+ * effectively represents the page offset for the given order.
+ *
+ * Order Bit:
+ * The 'order bit' encodes the page order by setting a single bit at a
+ * specific position. The position of this bit itself represents the order.
+ *
+ * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT = 12), the
+ * maximum range for a page offset (for order 0) is 52 bits (64 - 12). This
+ * offset occupies bits [0-51]. For order 0, the order bit is set at
+ * position 52.
+ *
+ * The following diagram illustrates how the encoded key value is split into
+ * indices for the tree levels, with PAGE_SIZE of 4KB::
+ *
+ *        63:60   59:51    50:42    41:33    32:24    23:15         14:0
+ *   +---------+--------+--------+--------+--------+--------+-----------------+
+ *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitmap)  |
+ *   +---------+--------+--------+--------+--------+--------+-----------------+
+ *
+ * The radix tree stores pages of all sizes (orders) in a single 6-level
+ * hierarchy. It efficiently shares lower table levels, especially due to
+ * common zero top address bits, allowing a single, efficient algorithm to
+ * manage all pages. This bitmap approach also offers memory efficiency; for
+ * example, a 512KB bitmap can cover a 16GB memory range for 0-order pages with
+ * PAGE_SIZE = 4KB.
+ *
+ * The data structures defined here are part of the KHO ABI. Any modification
+ * to these structures that breaks backward compatibility must be accompanied by
+ * an update to the "compatible" string. This ensures that a newer kernel can
+ * correctly interpret the data passed by an older kernel.
+ */
+
+/*
+ * Defines constants for the KHO radix tree structure, used to track preserved
+ * memory. These constants govern the indexing, sizing, and depth of the tree.
+ */
+enum kho_radix_consts {
+	/*
+	 * The bit position of the order bit (and also the length of the
+	 * page offset) for an order-0 page.
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
+	DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
+		     KHO_TABLE_SIZE_LOG2) + 1,
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
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
new file mode 100644
index 000000000000..8f03dd226dd9
--- /dev/null
+++ b/include/linux/kho_radix_tree.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_KHO_ABI_RADIX_TREE_H
+#define _LINUX_KHO_ABI_RADIX_TREE_H
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/mutex_types.h>
+#include <linux/types.h>
+
+/**
+ * DOC: Kexec Handover Radix Tree
+ *
+ * This is a radix tree implementation for tracking physical memory pages
+ * across kexec transitions. It was developed for the KHO mechanism but is
+ * designed for broader use by any subsystem that needs to preserve pages.
+ *
+ * The radix tree is a multi-level tree where leaf nodes are bitmaps
+ * representing individual pages. To allow pages of different sizes (orders)
+ * to be stored efficiently in a single tree, it uses a unique key encoding
+ * scheme. Each key is an unsigned long that combines a page's physical
+ * address and its order.
+ *
+ * Client code is responsible for allocating the root node of the tree,
+ * initializing the mutex lock, and managing its lifecycle. It must use the
+ * tree data structures defined in the KHO ABI,
+ * `include/linux/kho/abi/kexec_handover.h`.
+ */
+
+struct kho_radix_node;
+
+struct kho_radix_tree {
+	struct kho_radix_node *root;
+	struct mutex lock; /* protects the tree's structure and root pointer */
+};
+
+typedef int (*kho_radix_tree_walk_callback_t)(phys_addr_t phys,
+					      unsigned int order);
+
+#ifdef CONFIG_KEXEC_HANDOVER
+
+int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
+		       unsigned int order);
+
+void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
+			unsigned int order);
+
+int kho_radix_walk_tree(struct kho_radix_tree *tree, unsigned int level,
+			unsigned long start, kho_radix_tree_walk_callback_t cb);
+
+#else  /* #ifdef CONFIG_KEXEC_HANDOVER */
+
+static inline int kho_radix_add_page(struct kho_radix_tree *tree, long pfn,
+				     unsigned int order)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void kho_radix_del_page(struct kho_radix_tree *tree,
+				      unsigned long pfn, unsigned int order) { }
+
+static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
+				      unsigned int level,
+				      unsigned long start,
+				      kho_radix_tree_walk_callback_t cb)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* #ifdef CONFIG_KEXEC_HANDOVER */
+
+#endif	/* _LINUX_KHO_ABI_RADIX_TREE_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 271d90198a08..440f6de65eb2 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
  * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
+ * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
  */
 
 #define pr_fmt(fmt) "KHO: " fmt
@@ -15,6 +16,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho_radix_tree.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -65,194 +67,320 @@ static int __init kho_parse_enable(char *p)
 }
 early_param("kho", kho_parse_enable);
 
-/*
- * Keep track of memory that is to be preserved across KHO.
- *
- * The serializing side uses two levels of xarrays to manage chunks of per-order
- * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
- * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
- * allocations each bitmap will cover 128M of address space. Thus, for 16G of
- * memory at most 512K of bitmap memory will be needed for order 0.
- *
- * This approach is fully incremental, as the serialization progresses folios
- * can continue be aggregated to the tracker. The final step, immediately prior
- * to kexec would serialize the xarray information into a linked list for the
- * successor kernel to parse.
- */
-
-#define PRESERVE_BITS (PAGE_SIZE * 8)
-
-struct kho_mem_phys_bits {
-	DECLARE_BITMAP(preserve, PRESERVE_BITS);
-};
-
-static_assert(sizeof(struct kho_mem_phys_bits) == PAGE_SIZE);
-
-struct kho_mem_phys {
-	/*
-	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
-	 * to order.
-	 */
-	struct xarray phys_bits;
-};
-
-struct kho_mem_track {
-	/* Points to kho_mem_phys, each order gets its own bitmap tree */
-	struct xarray orders;
-};
-
-struct khoser_mem_chunk;
-
 struct kho_out {
 	void *fdt;
 	bool finalized;
 	struct mutex lock; /* protects KHO FDT finalization */
 
-	struct kho_mem_track track;
+	struct kho_radix_tree radix_tree;
 	struct kho_debugfs dbg;
 };
 
 static struct kho_out kho_out = {
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.track = {
-		.orders = XARRAY_INIT(kho_out.track.orders, 0),
+	.radix_tree = {
+		.lock = __MUTEX_INITIALIZER(kho_out.radix_tree.lock),
 	},
 	.finalized = false,
 };
 
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
+/**
+ * kho_radix_encode_key - Encodes a physical address and order into a radix key.
+ * @phys: The physical address of the page.
+ * @order: The order of the page.
+ *
+ * This function combines a page's physical address and its order into a
+ * single unsigned long, which is used as a key for all radix tree
+ * operations.
+ *
+ * Return: The encoded unsigned long radix key.
+ */
+static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
 {
-	void *res = xa_load(xa, index);
+	/* Order bits part */
+	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
+	/* Page offset part */
+	unsigned long l = phys >> (PAGE_SHIFT + order);
 
-	if (res)
-		return res;
-
-	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
-
-	if (!elm)
-		return ERR_PTR(-ENOMEM);
-
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
-		return ERR_PTR(-EINVAL);
-
-	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
-	if (xa_is_err(res))
-		return ERR_PTR(xa_err(res));
-	else if (res)
-		return res;
-
-	return no_free_ptr(elm);
+	return h | l;
 }
 
-static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
-				   unsigned int order)
+/**
+ * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
+ * @key: The unsigned long key to decode.
+ * @order: An output parameter, a pointer to an unsigned int where the decoded
+ *         page order will be stored.
+ *
+ * This function reverses the encoding performed by kho_radix_encode_key(),
+ * extracting the original physical address and page order from a given key.
+ *
+ * Return: The decoded physical address.
+ */
+static phys_addr_t kho_radix_decode_key(unsigned long key,
+					unsigned int *order)
 {
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
-	const unsigned long pfn_high = pfn >> order;
+	unsigned int order_bit = fls64(key);
+	phys_addr_t phys;
 
-	physxa = xa_load(&track->orders, order);
-	if (WARN_ON_ONCE(!physxa))
-		return;
+	/* order_bit is numbered starting at 1 from fls64 */
+	*order = KHO_ORDER_0_LOG2 - order_bit + 1;
+	/* The order is discarded by the shift */
+	phys = key << (PAGE_SHIFT + *order);
 
-	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-	if (WARN_ON_ONCE(!bits))
-		return;
-
-	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+	return phys;
 }
 
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
-			     unsigned long end_pfn)
+static unsigned long kho_radix_get_bitmap_index(unsigned long key)
+{
+	return key % (1 << KHO_BITMAP_SIZE_LOG2);
+}
+
+static unsigned long kho_radix_get_index(unsigned long key,
+					 unsigned int level)
+{
+	int s;
+
+	if (level == 0)
+		return kho_radix_get_bitmap_index(key);
+
+	s = ((level - 1) * KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZE_LOG2;
+	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
+}
+
+/**
+ * kho_radix_add_page - Marks a page as preserved in the radix tree.
+ * @tree: The KHO radix tree.
+ * @pfn: The page frame number of the page to preserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree based on the key derived from @pfn
+ * and @order. It sets the corresponding bit in the leaf bitmap to mark the
+ * page for preservation. If intermediate nodes do not exist along the path,
+ * they are allocated and added to the tree.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kho_radix_add_page(struct kho_radix_tree *tree,
+		       unsigned long pfn, unsigned int order)
+{
+	/* Newly allocated nodes for error cleanup */
+	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *node = tree->root;
+	struct kho_radix_node *new_node;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+	int err = 0;
+
+	if (WARN_ON_ONCE(!tree->root))
+		return -EINVAL;
+
+	might_sleep();
+
+	guard(mutex)(&tree->lock);
+
+	/* Go from high levels to low levels */
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx = kho_radix_get_index(key, i);
+
+		if (node->table[idx]) {
+			node = phys_to_virt(node->table[idx]);
+			continue;
+		}
+
+		/* Next node is empty, create a new node for it */
+		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		if (!new_node) {
+			err = -ENOMEM;
+			goto err_free_nodes;
+		}
+
+		node->table[idx] = virt_to_phys(new_node);
+		node = new_node;
+
+		intermediate_nodes[i] = new_node;
+	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	idx = kho_radix_get_index(key, 0);
+	leaf = (struct kho_radix_leaf *)node;
+	__set_bit(idx, leaf->bitmap);
+
+	return 0;
+
+err_free_nodes:
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		if (intermediate_nodes[i])
+			free_page((unsigned long)intermediate_nodes[i]);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_radix_add_page);
+
+/**
+ * kho_radix_del_page - Removes a page's preservation status from the radix tree.
+ * @tree: The KHO radix tree.
+ * @pfn: The page frame number of the page to unpreserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree and clears the bit corresponding to
+ * the page, effectively removing its "preserved" status. It does not free
+ * the tree's intermediate nodes, even if they become empty.
+ */
+void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
+			unsigned int order)
+{
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *node = tree->root;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+
+	if (WARN_ON_ONCE(!tree->root))
+		return;
+
+	might_sleep();
+
+	guard(mutex)(&tree->lock);
+
+	/* Go from high levels to low levels */
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx = kho_radix_get_index(key, i);
+
+		/*
+		 * Attempting to delete a page that has not been preserved,
+		 * return with a warning.
+		 */
+		if (WARN_ON(!node->table[idx]))
+			return;
+
+		if (node->table[idx])
+			node = phys_to_virt((phys_addr_t)node->table[idx]);
+	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	leaf = (struct kho_radix_leaf *)node;
+	idx = kho_radix_get_index(key, 0);
+	__clear_bit(idx, leaf->bitmap);
+}
+EXPORT_SYMBOL_GPL(kho_radix_del_page);
+
+static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
+			       unsigned long key,
+			       kho_radix_tree_walk_callback_t cb)
+{
+	unsigned long *bitmap = (unsigned long *)leaf;
+	unsigned int order;
+	phys_addr_t phys;
+	unsigned int i;
+	int err;
+
+	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
+		phys = kho_radix_decode_key(key | i, &order);
+		err = cb(phys, order);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int __kho_radix_walk_tree(struct kho_radix_node *root,
+				 unsigned int level, unsigned long start,
+				 kho_radix_tree_walk_callback_t cb)
+{
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned long key, i;
+	unsigned int shift;
+	int err;
+
+	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
+		if (!root->table[i])
+			continue;
+
+		shift = ((level - 1) * KHO_TABLE_SIZE_LOG2) +
+			KHO_BITMAP_SIZE_LOG2;
+		key = start | (i << shift);
+
+		node = phys_to_virt((phys_addr_t)root->table[i]);
+
+		if (level == 1) {
+			/*
+			 * we are at level 1,
+			 * node is pointing to the level 0 bitmap.
+			 */
+			leaf = (struct kho_radix_leaf *)node;
+			return kho_radix_walk_leaf(leaf, key, cb);
+		}
+
+		err  = __kho_radix_walk_tree(node, level - 1,
+					     key, cb);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
+ * @tree: A pointer to the KHO radix tree to walk.
+ * @level: The starting level for the walk (typically KHO_TREE_MAX_DEPTH - 1).
+ * @start: The initial key prefix for the walk (typically 0).
+ * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
+ *      invoked for each preserved page found in the tree. The callback receives
+ *      the physical address and order of the preserved page.
+ *
+ * This function walks the radix tree, searching from the specified top level
+ * (@level) down to the lowest level (level 0). For each preserved page found,
+ * it invokes the provided callback, passing the page's physical address and
+ * order.
+ *
+ * Return: 0 if the walk completed the specified tree, or the non-zero return
+ *         value from the callback that stopped the walk.
+ */
+int kho_radix_walk_tree(struct kho_radix_tree *tree, unsigned int level,
+			unsigned long start, kho_radix_tree_walk_callback_t cb)
+{
+	if (WARN_ON_ONCE(!tree->root))
+		return -EINVAL;
+
+	guard(mutex)(&tree->lock);
+
+	return __kho_radix_walk_tree(tree->root, level, start, cb);
+}
+EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
+
+static void __kho_unpreserve(struct kho_radix_tree *tree,
+			     unsigned long pfn, unsigned long end_pfn)
 {
 	unsigned int order;
 
 	while (pfn < end_pfn) {
 		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		__kho_unpreserve_order(track, pfn, order);
+		kho_radix_del_page(tree, pfn, order);
 
 		pfn += 1 << order;
 	}
 }
 
-static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
-				unsigned int order)
-{
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa, *new_physxa;
-	const unsigned long pfn_high = pfn >> order;
-
-	might_sleep();
-	physxa = xa_load(&track->orders, order);
-	if (!physxa) {
-		int err;
-
-		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
-		if (!new_physxa)
-			return -ENOMEM;
-
-		xa_init(&new_physxa->phys_bits);
-		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
-				    GFP_KERNEL);
-
-		err = xa_err(physxa);
-		if (err || physxa) {
-			xa_destroy(&new_physxa->phys_bits);
-			kfree(new_physxa);
-
-			if (err)
-				return err;
-		} else {
-			physxa = new_physxa;
-		}
-	}
-
-	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-	if (IS_ERR(bits))
-		return PTR_ERR(bits);
-
-	set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
-
-	return 0;
-}
-
-/* For physically contiguous 0-order pages. */
-static void kho_init_pages(struct page *page, unsigned int nr_pages)
-{
-	for (unsigned int i = 0; i < nr_pages; i++)
-		set_page_count(page + i, 1);
-}
-
-static void kho_init_folio(struct page *page, unsigned int order)
-{
-	unsigned int nr_pages = (1 << order);
-
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-
-	/* For higher order folios, tail pages get a page count of zero. */
-	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
-
-	if (order > 0)
-		prep_compound_page(page, order);
-}
-
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
-	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
 
 	info.page_private = page->private;
 	/*
-	 * deserialize_bitmap() only sets the magic on the head page. This magic
-	 * check also implicitly makes sure phys is order-aligned since for
-	 * non-order-aligned phys addresses, magic will never be set.
+	 * kho_radix_memblock_reserve() only sets the magic on the
+	 * head page. This magic check also implicitly makes sure phys is
+	 * order-aligned since for non-order-aligned phys addresses, magic will
+	 * never be set.
 	 */
 	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
 		return NULL;
@@ -260,11 +388,20 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
 
-	if (is_folio)
-		kho_init_folio(page, info.order);
-	else
-		kho_init_pages(page, nr_pages);
+	/*
+	 * For higher order folios, tail pages get a page count of zero.
+	 * For physically contiguous order-0 pages every pages gets a page
+	 * count of 1
+	 */
+	ref_cnt = is_folio ? 0 : 1;
+	for (unsigned int i = 1; i < nr_pages; i++)
+		set_page_count(page + i, ref_cnt);
+
+	if (is_folio && info.order)
+		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
@@ -314,188 +451,24 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_restore_pages);
 
-/* Serialize and deserialize struct kho_mem_phys across kexec
- *
- * Record all the bitmaps in a linked list of pages for the next kernel to
- * process. Each chunk holds bitmaps of the same order and each block of bitmaps
- * starts at a given physical address. This allows the bitmaps to be sparse. The
- * xarray is used to store them in a tree while building up the data structure,
- * but the KHO successor kernel only needs to process them once in order.
- *
- * All of this memory is normal kmalloc() memory and is not marked for
- * preservation. The successor kernel will remain isolated to the scratch space
- * until it completes processing this list. Once processed all the memory
- * storing these ranges will be marked as free.
- */
-
-struct khoser_mem_bitmap_ptr {
-	phys_addr_t phys_start;
-	DECLARE_KHOSER_PTR(bitmap, struct kho_mem_phys_bits *);
-};
-
-struct khoser_mem_chunk_hdr {
-	DECLARE_KHOSER_PTR(next, struct khoser_mem_chunk *);
-	unsigned int order;
-	unsigned int num_elms;
-};
-
-#define KHOSER_BITMAP_SIZE                                   \
-	((PAGE_SIZE - sizeof(struct khoser_mem_chunk_hdr)) / \
-	 sizeof(struct khoser_mem_bitmap_ptr))
-
-struct khoser_mem_chunk {
-	struct khoser_mem_chunk_hdr hdr;
-	struct khoser_mem_bitmap_ptr bitmaps[KHOSER_BITMAP_SIZE];
-};
-
-static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
-
-static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
-					  unsigned long order)
+static int __init kho_radix_memblock_reserve(phys_addr_t phys,
+					     unsigned int order)
 {
-	struct khoser_mem_chunk *chunk __free(free_page) = NULL;
+	union kho_page_info info;
+	struct page *page;
+	int sz;
 
-	chunk = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!chunk)
-		return ERR_PTR(-ENOMEM);
+	sz = 1 << (order + PAGE_SHIFT);
+	page = phys_to_page(phys);
 
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
-		return ERR_PTR(-EINVAL);
-
-	chunk->hdr.order = order;
-	if (cur_chunk)
-		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return no_free_ptr(chunk);
-}
-
-static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
-{
-	struct khoser_mem_chunk *chunk = first_chunk;
-
-	while (chunk) {
-		struct khoser_mem_chunk *tmp = chunk;
-
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
-	}
-}
-
-/*
- *  Update memory map property, if old one is found discard it via
- *  kho_mem_ser_free().
- */
-static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
-{
-	void *ptr;
-	u64 phys;
-
-	ptr = fdt_getprop_w(kho_out.fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, NULL);
-
-	/* Check and discard previous memory map */
-	phys = get_unaligned((u64 *)ptr);
-	if (phys)
-		kho_mem_ser_free((struct khoser_mem_chunk *)phys_to_virt(phys));
-
-	/* Update with the new value */
-	phys = first_chunk ? (u64)virt_to_phys(first_chunk) : 0;
-	put_unaligned(phys, (u64 *)ptr);
-}
-
-static int kho_mem_serialize(struct kho_out *kho_out)
-{
-	struct khoser_mem_chunk *first_chunk = NULL;
-	struct khoser_mem_chunk *chunk = NULL;
-	struct kho_mem_phys *physxa;
-	unsigned long order;
-	int err = -ENOMEM;
-
-	xa_for_each(&kho_out->track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		chunk = new_chunk(chunk, order);
-		if (IS_ERR(chunk)) {
-			err = PTR_ERR(chunk);
-			goto err_free;
-		}
-
-		if (!first_chunk)
-			first_chunk = chunk;
-
-		xa_for_each(&physxa->phys_bits, phys, bits) {
-			struct khoser_mem_bitmap_ptr *elm;
-
-			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
-				chunk = new_chunk(chunk, order);
-				if (IS_ERR(chunk)) {
-					err = PTR_ERR(chunk);
-					goto err_free;
-				}
-			}
-
-			elm = &chunk->bitmaps[chunk->hdr.num_elms];
-			chunk->hdr.num_elms++;
-			elm->phys_start = (phys * PRESERVE_BITS)
-					  << (order + PAGE_SHIFT);
-			KHOSER_STORE_PTR(elm->bitmap, bits);
-		}
-	}
-
-	kho_update_memory_map(first_chunk);
+	/* Reserve the memory preserved in KHO radix tree in memblock */
+	memblock_reserve(phys, sz);
+	memblock_reserved_mark_noinit(phys, sz);
+	info.magic = KHO_PAGE_MAGIC;
+	info.order = order;
+	page->private = info.page_private;
 
 	return 0;
-
-err_free:
-	kho_mem_ser_free(first_chunk);
-	return err;
-}
-
-static void __init deserialize_bitmap(unsigned int order,
-				      struct khoser_mem_bitmap_ptr *elm)
-{
-	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
-	unsigned long bit;
-
-	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz = 1 << (order + PAGE_SHIFT);
-		phys_addr_t phys =
-			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
-		union kho_page_info info;
-
-		memblock_reserve(phys, sz);
-		memblock_reserved_mark_noinit(phys, sz);
-		info.magic = KHO_PAGE_MAGIC;
-		info.order = order;
-		page->private = info.page_private;
-	}
-}
-
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
-{
-	const void *mem_ptr;
-	int len;
-
-	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-	if (!mem_ptr || len != sizeof(u64)) {
-		pr_err("failed to get preserved memory bitmaps\n");
-		return 0;
-	}
-
-	return get_unaligned((const u64 *)mem_ptr);
-}
-
-static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
-{
-	while (chunk) {
-		unsigned int i;
-
-		for (i = 0; i != chunk->hdr.num_elms; i++)
-			deserialize_bitmap(chunk->hdr.order,
-					   &chunk->bitmaps[i]);
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-	}
 }
 
 /*
@@ -796,14 +769,14 @@ EXPORT_SYMBOL_GPL(kho_remove_subtree);
  */
 int kho_preserve_folio(struct folio *folio)
 {
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.track;
 
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
-	return __kho_preserve_order(track, pfn, order);
+	return kho_radix_add_page(tree, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -817,11 +790,11 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  */
 void kho_unpreserve_folio(struct folio *folio)
 {
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.track;
 
-	__kho_unpreserve_order(track, pfn, order);
+	kho_radix_del_page(tree, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -837,7 +810,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
  */
 int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	struct kho_mem_track *track = &kho_out.track;
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn = start_pfn;
@@ -853,7 +826,7 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		err = __kho_preserve_order(track, pfn, order);
+		err = kho_radix_add_page(tree, pfn, order);
 		if (err) {
 			failed_pfn = pfn;
 			break;
@@ -863,7 +836,7 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 	}
 
 	if (err)
-		__kho_unpreserve(track, start_pfn, failed_pfn);
+		__kho_unpreserve(tree, start_pfn, failed_pfn);
 
 	return err;
 }
@@ -881,11 +854,11 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  */
 void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 {
-	struct kho_mem_track *track = &kho_out.track;
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 
-	__kho_unpreserve(track, start_pfn, end_pfn);
+	__kho_unpreserve(tree, start_pfn, end_pfn);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
@@ -944,14 +917,14 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
 					 unsigned short order)
 {
-	struct kho_mem_track *track = &kho_out.track;
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
 
-	__kho_unpreserve(track, pfn, pfn + 1);
+	__kho_unpreserve(tree, pfn, pfn + 1);
 
 	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
-		__kho_unpreserve(track, pfn, pfn + (1 << order));
+		__kho_unpreserve(tree, pfn, pfn + (1 << order));
 	}
 }
 
@@ -1220,16 +1193,10 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
 
 int kho_finalize(void)
 {
-	int ret;
-
 	if (!kho_enable)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	ret = kho_mem_serialize(&kho_out);
-	if (ret)
-		return ret;
-
 	kho_out.finalized = true;
 
 	return 0;
@@ -1244,7 +1211,6 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
-	phys_addr_t mem_map_phys;
 	struct kho_debugfs dbg;
 };
 
@@ -1312,18 +1278,49 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+static int __init kho_mem_retrieve(const void *fdt)
+{
+	struct kho_radix_tree tree;
+	const phys_addr_t *mem;
+	int len;
+
+	/* Retrieve the KHO radix tree from passed-in FDT. */
+	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
+
+	if (!mem || len != sizeof(*mem)) {
+		pr_err("failed to get preserved KHO memory tree\n");
+		return -ENOENT;
+	}
+
+	if (!*mem)
+		return -EINVAL;
+
+	tree.root = phys_to_virt(*mem);
+	mutex_init(&tree.lock);
+	return kho_radix_walk_tree(&tree, KHO_TREE_MAX_DEPTH - 1,
+				   0, kho_radix_memblock_reserve);
+}
+
 static __init int kho_out_fdt_setup(void)
 {
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	void *root = kho_out.fdt;
-	u64 empty_mem_map = 0;
+	u64 preserved_mem_tree_pa;
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
-			    sizeof(empty_mem_map));
+
+	scoped_guard(mutex, &tree->lock) {
+		preserved_mem_tree_pa = (u64)virt_to_phys(tree->root);
+	}
+
+	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
+			    &preserved_mem_tree_pa,
+			    sizeof(preserved_mem_tree_pa));
+
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
 
@@ -1332,16 +1329,26 @@ static __init int kho_out_fdt_setup(void)
 
 static __init int kho_init(void)
 {
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
 	const void *fdt = kho_get_fdt();
 	int err = 0;
 
 	if (!kho_enable)
 		return 0;
 
+	scoped_guard(mutex, &tree->lock) {
+		tree->root = (struct kho_radix_node *)
+			kzalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!tree->root) {
+			err = -ENOMEM;
+			goto err_free_scratch;
+		}
+	}
+
 	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
 	if (IS_ERR(kho_out.fdt)) {
 		err = PTR_ERR(kho_out.fdt);
-		goto err_free_scratch;
+		goto err_free_kho_radix_tree_root;
 	}
 
 	err = kho_debugfs_init();
@@ -1387,6 +1394,9 @@ static __init int kho_init(void)
 
 err_free_fdt:
 	kho_unpreserve_free(kho_out.fdt);
+err_free_kho_radix_tree_root:
+	kfree(tree->root);
+	tree->root = NULL;
 err_free_scratch:
 	kho_out.fdt = NULL;
 	for (int i = 0; i < kho_scratch_cnt; i++) {
@@ -1426,10 +1436,12 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.mem_map_phys) {
+	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
+
+		if (kho_mem_retrieve(kho_get_fdt()))
+			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
 	}
@@ -1438,11 +1450,10 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
 	int err = 0;
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
@@ -1466,12 +1477,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys) {
-		err = -ENOENT;
-		goto out;
-	}
-
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1512,7 +1517,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
-	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
-- 
2.52.0.457.g6b5491de43-goog


