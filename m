Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937F4CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B928E0057; Wed,  8 Oct 2025 21:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DA48E0002; Wed,  8 Oct 2025 21:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C818E0057; Wed,  8 Oct 2025 21:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D86E18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BE955B990
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:02 +0000 (UTC)
X-FDA: 83976917724.27.2F70C84
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2EFD180008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dMBpMVDM;
	spf=pass (imf06.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRBm+Pg8TyGJGYp2jCQm+1zXWV7khrVi/kELEVhXf6I=;
	b=WuO+jOmEYzjAhGLvvzyqYoFovTJrZlwCLUccQGiXvga/KVkDOOBPEF+oTIRMMep5hPb5LO
	mcm05XLHewj5RHatrVbBWBH01tGCMWrBH/WjjFKQjSnzTylqkx9fpcQDkJfqgoYAklbomU
	OcIf4Qn2a4UgAZ/WFW1QQTCXoFAUyGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975140; a=rsa-sha256;
	cv=none;
	b=blAuMmWvFF5bn4zso4lGOeEZeOZuRVzJdWbNhpwkF0z8RRgji+Lr+ZBZEV23Am82x9nKND
	YqMvfIZaAzLssGETL2a4cqjF71ESsircG2r2zkyEj9xdmeIH/qwyNs+NvvKeHU8rv0V6ZG
	cwnEdxDMBX7jxjLI6bvrT4llq8aUt8U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dMBpMVDM;
	spf=pass (imf06.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26e68904f0eso4471235ad.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975139; x=1760579939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRBm+Pg8TyGJGYp2jCQm+1zXWV7khrVi/kELEVhXf6I=;
        b=dMBpMVDMKzVd9BTzM4ichxfkEnICRHBrGNSDzklBIiwySmtONYDpJ8oebzjiY5/EfC
         6rdPIkrLyve6/bseI09xfiBhGo+EWMUD4E0Uk02r9Ys60axg0sHBuDxMlcO0VZHwcWnj
         7YJ/5XkZA+6Hky7Jfcw3ERk5TNBsId5qUR6wu5ive0lcZfaWfPp7kp4xZimH+GBXa2RL
         UZNjoDG//G7PYSbjACd2G+1y/bXgC7xXVlfE8mFCWgJalcdaHa5Dmz/xflWLG7XEbFv9
         CZkd5Ois3vV6HNsDqobccN5nnRUL6ZAdQlIHA1mWbzmxBaM3DF96KlfqgI7d014UpfKf
         MgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975139; x=1760579939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRBm+Pg8TyGJGYp2jCQm+1zXWV7khrVi/kELEVhXf6I=;
        b=vIFA8ra31Kj92kRgj6e2CruFuAj2pZ+FOAbMlnOJkdfjYAdvVWGOfYBgE97h9YwX89
         7U5KBrD2P6nt5dgZhWI7HrzyzLGgwe9M0xfsmxYNLCk4oAKYBjxWfGw/kcfXBwP6za3k
         6mKph98y8vL5cetDGlAlUK0ksGpqSJpa6/Tg3GFnabbLrqvT1jwU3SujvprB2KuKJw/i
         QH022O75nZ/vUnqxke0zzqNTKiGMynNIvZZbc6s9TUza9ecngHqOILCI09qmoPE2cXIv
         ZkcfCFk0gz4rGx441unDRlacKa+XorY5XDyTz3TbsFOa53ASGnJbhqN6OHYeMdF3IEAA
         Ujgw==
X-Forwarded-Encrypted: i=1; AJvYcCUinWF3cSNurVxNz0ldtLXS2BHy/Hpx1HDEDAZ6lhvOvBwMYf+ZHI0Vx8SK97hbd+1ViNyn6UkL1A==@kvack.org
X-Gm-Message-State: AOJu0YzN9heJOU50MDdpD7G7CeDlqWZ/bOR86HBRsb4OQlg4SyYw7aEY
	i5eN/Zf+iiKFe2S8eSSVPwTQbeWt36f4hF8w6iRqjIssn8wNICnRzGlPRSTh/AOvdeA=
X-Gm-Gg: ASbGncvjQpuXJ5W9p3txW8htJv6WRDj7oFaeYfk64qo0x4DgB9Pc6HMTRZ+gmrTrUdg
	wClJZ5npT7d7xJpD2HRskreGvWyeHEv0mpN7Ra2BUVWSuEcxJdIL/PZuHyRXpnVT+9+9CZmq13B
	hUCHDdMR13wHw4umohWlXDYqfshw0L05YM0+v4l8uUTXtCHH6a8icJzh8kVciKXIvv8rgfrrzoN
	qL5vzVDdDVFhkuuxDKl2HUXyWqdlNuWh2INQE7LcbjmNf1JJ6nF+YuBczqDl5E7an2dkJVRG9e7
	8fRQexMElzco5WrPbGiNrobHFZWBVEbTrCk+SGb3NDa0eoW+RRr5bTQ4xui1cN/WFkeUlPWSUxv
	Ol9w8x1m+wjCBSpi7uBdF8/Yyn4as+ch5r7C7hc/V5Hfixj9/GQfPYqq6FUOYtlX4CwIPloNQIe
	VGSgk=
X-Google-Smtp-Source: AGHT+IHnM19QNt+KVU6ihXNJt4W+kfmuE2lNld1taoppLPPH4Aa0tlEl4j47mz2vz9hZfmhsxUhEJQ==
X-Received: by 2002:a17:903:144f:b0:28e:9427:68f6 with SMTP id d9443c01a7336-29027262579mr68191475ad.27.1759975139512;
        Wed, 08 Oct 2025 18:58:59 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:59 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 15/18] dt-bindings: riscv: Describe physical memory regions
Date: Wed,  8 Oct 2025 18:57:51 -0700
Message-ID: <20251009015839.3460231-16-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: c5wusy6bacuktgqezdb6mhpaq8f3gr5w
X-Rspam-User: 
X-Rspamd-Queue-Id: A2EFD180008
X-HE-Tag: 1759975140-852101
X-HE-Meta: U2FsdGVkX18qKaxBp1kN/+qBR48ME2TsEifE3VzhtQsyPxGuHh+DmU5R9SEABBesLjVtZ54lbF8BN3Gi6LxIWm+Qczy4ayI8I/38jfEGge6AnqirbAuk0pp3cSz63XE3ujhEWb63WWr4VfQ+r9aWOpU/YI31WKEf818IkTiKTVIR1coUZQ3lBZs7eL5Sxd+J7nAkW6uqXj+5jZXwfL9m333HV/CKrJpp68gT26S9znmz+7n2SSQiDI1NZF5tTSWIrKohYAoGxC7+rJD1xJ37XIpe7+M6RA5lS+e4nKM7oCNQbzFHwuCCRtTQ7qR6NU2SMqlm1CDJJOgCQ7ozMpq4VjeLNmP4m1nkSQOB0K9eMpwjpuiJyZZIhpZcb6jyCdcx4mg+i114GN+5Ed/S8sI8cY+SshRy2FXMzi6UdWNii6Do2RnkKchAIHi0cVEs5FMMjPoUDK4it2bJxgldwObjyJzlTv+o1L7fluruTG5m0Zu14DK0aZGcudovMActbxGG68StU3pE7OSM3o1TU5Yhg12qrQ9yfMY6N7Bc/p8wNsuj7Y0RIvxTPqJZXAvdQZRbgJi6lOJe2KeF/1JCJedLe51GY5baKoxvyYSH6dRxbHUS1qEvrFxykdktB5h5q9rvLJDrMpZZPrffiE5ogxYszSV4zOcEeUkxGDjSyYDMDhm0wNynEaNnS7Pu9+OqPrEzwkvZiMAkPI34fmE2wxvVkzrl+cvXjgExKm96dxslYeILhTe0aXc5rvysGibTVft8gIAbsnRyAToz/jb0vdsO9VDfWAeZIGBRAVLQxSzTC/rsMtpUlh5koAEcVc6cwr+v15Ruj3Iof8oazOQY0EnjkVV1fahLqeiTCKle784kUZY9qgLUciPDzLuqPkTjtxnXtISMk+dY0LqmAX1g+fMGOqeLhMs80v6Bk32ttoy1Pv7zoCBsj4LQTeXsvAktxnPrAovFqxRQa6TYiFlBS+O
 gi4FySeu
 RyPYfg6pLwu/R1EjPVTWMjeVbiIaE8E/jy7WcJmLShTJic2zVzefRnMjQEb6BePF1ZecmBmqv3zs/E0LvZ2U8gLIxlWNXHfbsItwRdB7yuxzXemkQYE6MZYzCEGMkOtdQzcMZPXVQ00tRREFAsasxGE07uvpy5Z9g3HcrtVKkw6WEHLHk89IG5YuuW58g77mlk/3tD8z2JNRvvlrpQp4WyWwoa39dGzzWIExLj+dUa41TZQ00ag/OA8eG+6g+pkVL7XcD+rHwlTcu7jgm26DU3qESCku+2y1IX8e+TPLjN5cApQSPnPnrkG35U1UBt5n/Dt+Flkq2jcGcOxzzmC+uyBq1lnXXqvaoYDw1tI3AzTAUVDyw0BDK1gouhShGNAHTT6Ck3F5Bzw0anW2WI0tG0gWfW4Juv7vs/2VvGVmexkIYVwbi5rL+um0U7E/Vc2yFLX05WaI179xxkLFKniP9W5Szvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Information about physical memory regions is needed by both the kernel
and M-mode firmware. For example, the kernel needs to know about
noncacheable aliases of cacheable memory in order to allocate coherent
memory pages for DMA. M-mode firmware needs to know about those aliases
so it can protect itself from lower-privileged software.

The RISC-V Privileged Architecture delegates the description of Physical
Memory Attributes (PMAs) to the platform. On DT-based platforms, it
makes sense to put this information in the devicetree.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - Remove references to Physical Address Width (no longer part of Smmpt)
 - Remove special first entry from the list of physical memory regions
 - Fix compatible string in example

 .../bindings/riscv/physical-memory.yaml       | 91 +++++++++++++++++++
 include/dt-bindings/riscv/physical-memory.h   | 44 +++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/riscv/physical-memory.yaml
 create mode 100644 include/dt-bindings/riscv/physical-memory.h

diff --git a/Documentation/devicetree/bindings/riscv/physical-memory.yaml b/Documentation/devicetree/bindings/riscv/physical-memory.yaml
new file mode 100644
index 0000000000000..825b712a9fbae
--- /dev/null
+++ b/Documentation/devicetree/bindings/riscv/physical-memory.yaml
@@ -0,0 +1,91 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/riscv/physical-memory.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: RISC-V Physical Memory Regions
+
+maintainers:
+  - Samuel Holland <samuel.holland@sifive.com>
+
+description:
+  The RISC-V Privileged Architecture defines a number of Physical Memory
+  Attributes (PMAs) which apply to a given region of memory. These include the
+  types of accesses (read, write, execute, LR/SC, and/or AMO) allowed within
+  a region, the supported access widths and alignments, the cacheability and
+  coherence of the region, and whether or not accesses to the region may have
+  side effects.
+
+  Some RISC-V platforms provide multiple physical address mappings for main
+  memory or certain peripherals. Each alias of a region generally has different
+  PMAs (e.g. cacheable vs non-cacheable), which allows software to dynamically
+  select the PMAs for an access by referencing the corresponding alias.
+
+  On DT-based RISC-V platforms, this information is provided by the
+  riscv,physical-memory-regions property of the root node.
+
+properties:
+  $nodename:
+    const: '/'
+
+  riscv,physical-memory-regions:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    description:
+      Each table entry provides PMAs for a specific physical memory region,
+      which must not overlap with any other table entry.
+    minItems: 1
+    maxItems: 256
+    items:
+      minItems: 4
+      maxItems: 6
+      additionalItems: true
+      items:
+        - description: CPU physical address (#address-cells)
+        - description: >
+            Size (#size-cells). For entry 0, if the size is zero, the size is
+            assumed to be 2^(32 * #size-cells).
+        - description: >
+            Flags describing the most restrictive PMAs for any address within
+            the region.
+
+            The least significant byte indicates the types of accesses allowed
+            for this region. Note that a memory region may support a type of
+            access (e.g. AMOs) even if the CPU does not.
+
+            The next byte describes the cacheability, coherence, idempotency,
+            and ordering PMAs for this region. It also includes a flag to
+            indicate that accesses to a region are unsafe and must be
+            prohibited by software (for example using PMPs or Smmpt).
+
+            The third byte is reserved for future PMAs.
+
+            The most significant byte is the index of the lowest-numbered entry
+            which this entry is an alias of, if any. Aliases need not be the
+            same size, for example if a smaller memory region repeats within a
+            larger alias.
+        - description: Reserved for describing future PMAs
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/riscv/physical-memory.h>
+
+    / {
+      compatible = "beagle,beaglev-starlight-jh7100-r0", "starfive,jh7100";
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      riscv,physical-memory-regions =
+          <0x00 0x18000000 0x00 0x00020000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY) 0x0>,
+          <0x00 0x18080000 0x00 0x00020000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY) 0x0>,
+          <0x00 0x41000000 0x00 0x1f000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY) 0x0>,
+          <0x00 0x61000000 0x00 0x1f000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY | PMR_ALIAS(3)) 0x0>,
+          <0x00 0x80000000 0x08 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0x0>,
+          <0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(5)) 0x0>,
+          <0x20 0x00000000 0x10 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY) 0x0>,
+          <0x30 0x00000000 0x10 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY | PMR_ALIAS(7)) 0x0>;
+    };
+
+...
diff --git a/include/dt-bindings/riscv/physical-memory.h b/include/dt-bindings/riscv/physical-memory.h
new file mode 100644
index 0000000000000..7cb2e58fa8c1c
--- /dev/null
+++ b/include/dt-bindings/riscv/physical-memory.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+
+#ifndef _DT_BINDINGS_RISCV_PHYSICAL_MEMORY_H
+#define _DT_BINDINGS_RISCV_PHYSICAL_MEMORY_H
+
+#define PMA_READ			(1 << 0)
+#define PMA_WRITE			(1 << 1)
+#define PMA_EXECUTE			(1 << 2)
+#define PMA_AMO_MASK			(3 << 4)
+#define PMA_AMO_NONE			(0 << 4)
+#define PMA_AMO_SWAP			(1 << 4)
+#define PMA_AMO_LOGICAL			(2 << 4)
+#define PMA_AMO_ARITHMETIC		(3 << 4)
+#define PMA_RSRV_MASK			(3 << 6)
+#define PMA_RSRV_NONE			(0 << 6)
+#define PMA_RSRV_NON_EVENTUAL		(1 << 6)
+#define PMA_RSRV_EVENTUAL		(2 << 6)
+
+#define PMA_RW				(PMA_READ | PMA_WRITE)
+#define PMA_RWA				(PMA_RW | PMA_AMO_ARITHMETIC | PMA_RSRV_EVENTUAL)
+#define PMA_RWX				(PMA_RW | PMA_EXECUTE)
+#define PMA_RWXA			(PMA_RWA | PMA_EXECUTE)
+
+#define PMA_ORDER_MASK			(3 << 8)
+#define PMA_ORDER_IO_RELAXED		(0 << 8)
+#define PMA_ORDER_IO_STRONG		(1 << 8)
+#define PMA_ORDER_MEMORY		(2 << 8)
+#define PMA_READ_IDEMPOTENT		(1 << 10)
+#define PMA_WRITE_IDEMPOTENT		(1 << 11)
+#define PMA_CACHEABLE			(1 << 12)
+#define PMA_COHERENT			(1 << 13)
+
+#define PMA_UNSAFE			(1 << 15)
+
+#define PMA_IO				(PMA_ORDER_IO_RELAXED)
+#define PMA_NONCACHEABLE_MEMORY		(PMA_ORDER_MEMORY | PMA_READ_IDEMPOTENT | \
+						PMA_WRITE_IDEMPOTENT)
+#define PMA_NONCOHERENT_MEMORY		(PMA_NONCACHEABLE_MEMORY | PMA_CACHEABLE)
+#define PMA_NORMAL_MEMORY		(PMA_NONCOHERENT_MEMORY | PMA_COHERENT)
+
+#define PMR_ALIAS_MASK			(0xff << 24)
+#define PMR_ALIAS(n)			((n) << 24)
+
+#endif /* _DT_BINDINGS_RISCV_PHYSICAL_MEMORY_H */
-- 
2.47.2


