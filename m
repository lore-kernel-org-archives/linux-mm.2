Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC142CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F728E0034; Wed, 12 Nov 2025 20:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679A98E002F; Wed, 12 Nov 2025 20:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A92B8E0034; Wed, 12 Nov 2025 20:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEA48E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E692C1405F1
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:30 +0000 (UTC)
X-FDA: 84103896660.19.F592159
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE11410000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QJlieWyc;
	spf=pass (imf14.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKST6UqYk+QaqGuOiC3PtA1F5GA6hglNlMJ+dkxeIto=;
	b=GOFUdxJStjEFrSKP1unN7pv0cduDQrXBx4Fr4NlpRfAlZNiHtb51KFuxVcCBviLmGW2Jsj
	6CBpdMMaWHOFz7vrs6zz+shGf+FlQ4PKrbWFW+AC6VkwBfxpH143+YDecFnVhCg762kyDi
	dGXey2Gp9DKXk7WIxndgodcPLLi2D+c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QJlieWyc;
	spf=pass (imf14.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998449; a=rsa-sha256;
	cv=none;
	b=VfhfaEFA0nctlVkd4J7wXclf+p32FvERNdEcpiLdZuga3hDsrbrWRqIvxNUpm4eC8oSyhF
	vazGHbDih1bcbz1ZeSNK36mrzcJNc7FM4prkfLhT+SBdMbglUr6eUoLdNmburQFJ4xJV0+
	/7o61/Ii9I6OzeFgdnkGsvEz0MYecX8=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so224854b3a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998448; x=1763603248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKST6UqYk+QaqGuOiC3PtA1F5GA6hglNlMJ+dkxeIto=;
        b=QJlieWycy2Nc91lCx17GgZKPrd82kU9fzxekonpkj4nGNEM1LMx0I5FEvaN8s2iEyB
         WhRNNoGKUaye+ADiwBEm1i5WJwOsrCTOtoB0Yi1KemOdWu8OzjgL7AZMa9sVTWT8jdQn
         X9jhdu3Lr8Ibf3tL74hiTR66dbmYJ5wPMwwa7HE0EvP3F+py661fm3ocs3OO1iSXQ1OT
         JPInnBNLhm/AM6sDJUtp3odA+8FZ9G/T6kxGXMmiw0nNXIKHkiCHpwOpU9gtgLwZewTY
         96xEmX83sb9ZdesGOcgPBZEfFuqu5osqMDeFiipBdXwI4HyI4yLjvY8WMyQqsYNISfrT
         DJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998448; x=1763603248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jKST6UqYk+QaqGuOiC3PtA1F5GA6hglNlMJ+dkxeIto=;
        b=MtfDLdkVfMQHjQlW7c/nTJtbcRUilCNOMNazL2GiVjpmn5q9ApSOaG/hOxyyw4cdnY
         FAFhp/qQL97zyvBPOQdRDhpImJJqQmUV8OxS4P7/CLz0yndALiwH9e+HylA6stQVkprs
         eX8OWAI/hKasHR/HxQpnNGMQfxftt7rZ7iMJXf+Wrf2v7ZDbcRyOdW9Y1wB50F2r4gnu
         fYy/Sb8H37rWYVR3OY6jMhwbVeEFYU94ClFs3FO5RCl1VAbTQkx1agv1EvXDagMFU6qq
         BI9j5kUr9427jFj+7eena4WcKRsjGLo1cpKKnplfi48kWOxfoNa/CMLADW81Apn1nmFB
         i4rw==
X-Forwarded-Encrypted: i=1; AJvYcCVkUpHadC6jO8fCJcsn+ZvEpX5b2BzHmCDzQ6L4nKmMTVNYQveuITm0e9+w48b5VvOPXimv86AVQw==@kvack.org
X-Gm-Message-State: AOJu0YwqUrx1taTtdKI+Xmx0LDbWoNh0hXN01W5HstuEiN/s9mo4+9Jz
	13ozCfGTytFtarb9F5Dqtl/w3DiLkmVCCBDLWH+DYFiQWinOWf5szuOG27wJFt/8aEA=
X-Gm-Gg: ASbGncupX3B+KUlvzrXhfy9qmg/W/Ei63AgmvXbjdxJHlnPgjp/p5t2CIqyPm1bw1eP
	XvkW1efmfKFLGc3BcNNKUbB08eOhQCz5FMUktErU43yvSz7+3f5nQzjoJHgsvFX1cw2i6ZzXZm5
	HJpdVHaDfDBg1RPcfjdNo5aMCGuClBkYQYJXm6G5iBT+19uBHkHh38wD86mfAoEJ1Lk/hAkZHvX
	Nr0jOtwzeGp8KO7PKDl68Xnf5GhUzQIZk9StyphluyWY9ctGaJCB65p6U1qE8DGLbAewnsoX/9G
	RueHkOE9qVl4DavFplDfW+duLXybhr8nO+STghYG7q3hijYgQxjpZm7WiHLehFvgadMu8Ke5sWm
	2YVEfhV4RtpZO70bbIH2FjYVqFy0bvZgY3BQ4048dimAhjtYaaV9U9Fvn/c3rwknf08ESuPOUKu
	NbuPwFiO1mEpYSFepn+b4YKg==
X-Google-Smtp-Source: AGHT+IHEN2CLBCBQn7bcySaSxAzHnvyn3lSrJ3SkfwuCWTMT+513mFJW8h5K2OPvmFqqAe8aAa+xIw==
X-Received: by 2002:a17:902:cf05:b0:295:59ef:df96 with SMTP id d9443c01a7336-2984ed923femr62192415ad.13.1762998447807;
        Wed, 12 Nov 2025 17:47:27 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:27 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 19/22] dt-bindings: riscv: Describe physical memory regions
Date: Wed, 12 Nov 2025 17:45:32 -0800
Message-ID: <20251113014656.2605447-20-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE11410000B
X-Stat-Signature: toae67frgrphwaxtffsmgndy1zecbi98
X-Rspam-User: 
X-HE-Tag: 1762998448-49683
X-HE-Meta: U2FsdGVkX19dt3ys0lLgdte+QBQYa9JXH+/WEbtF7NlhEp9tdw9OoqiiXeba4FApxKwqZCfoQNN2m3vCP7cWBF+XjrHgqzmujZlNiBIbWzGGXqvAvmUB9VUkURPpyWrLu477tK4C/lBGudQpK/h5Qnn/O6z0hCP4gjgWqj+cN6td2TyIQeZE6TyZ44oKjNMo0SAfXuoEumRjyJ+4zemqOV+PRlAPz1jQQntpXAO2X63IX5J9aWQoeh3aDKKecJA/7A179ssvxmXP69VarFmCJOLQNI6tflEi/WT94xVazxGLGjEsHzJri1uu8pqibFV7wReDVSNRKnSGDMrAe4U+9YTyqhSs5zsEw5hX1dAzdjVnn2wk0q+/f9gotFPUdAKTBBhMPftf7zlCKu6uhkfeQWjkpiCMSj9f1eSLdwiuu6ApvBm95Tz4iWDZaHQh4LUlAlkUQ4XC5DTwyfAMOujcEWf+XEHdFAtdlrO4/OAqiWh+bGCxQbp1/fRHdNgGkMyy9D+x39DvfVzAEEtcMXvE3987fzUH5AbTysAjkv7ITcXZjIbepQ/Ur25EwaBA51QVCDSOrNT5Q32eFG1MGSm3R7C8RlfwIxEXiOaqeHdvlOOByuIYaVmmdMF+lwgVGW9qa+kBdAs3ECqPRTrmxuLHcqfmCtuDZ8Ykxjak8zt78B3Uzf5Wni16MGlCWkw4P1aHalAlrreMaf8mYQ2FZ3oOZ2Ha0IqTJwb6kZUhku2oL6awGMt87x0yYdFaYGdEtMLa1Ka6dqCKRfdXr+I7F9S3Qov1smqbqU5fc2LhkQ+MAXiqrz21crz7BnSktHN61KMa/MRxSAZoGn9G997Y0BnRD7kNelRxs6069RqFdKGT19R3a+4qrMVooshLOMpv8h2PGr3kivL/vTvnOFn5nVGJC4jNeHV3ysliALGWoAHIQsFKjpG5pjBNLqz4yuVXqSS2WM627gq79L+ZUvAsoak
 7CDBgNUL
 cfHw86rfGEhKuAHqMOTvdGhqT5Vi3602d+rq0PxWUEp3BN7YakGfGGPWuB+/dT8G/VuELK9765bSf7MjSt3Ce5U9x9uvnHGLY8xXXFaxT0Cip9UJ1uo4L+IIoHZVitnrmQZvGuaQKbDSDovDbYIrWvCcnVOQhprVnW1t+euI0HoTiSnCBaXnuH6I0kJmplfRhy55xmPfzVSqiiLj//eVCVNS8wgojEKcUIY5CUunOEs7vbnmOS6pgcTp9nAntUur/vIvKhj6A2iBRDCDro12ZyDbMLfZADfjp8/Ra3e6nk9gDph4WxoZ51e4sCq4sAto7RjmvGKZKz/8cmFOz1d+WCLqPPSNAnu3rNxcKaDphhn28ttLmGt9NO1e9RCsORwoTln8Tz7iHrJg6gjriKBA9281oJ/vvte3+o43T8k+RTnY4qU8oOEEI9tJAwwgBruTsarbO9++AvksoiqTXglmXFVxOPw==
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

Changes in v3:
 - Split PMR_IS_ALIAS flag from PMR_ALIAS_MASK number
 - Add "model" property to DT binding example to fix validation

Changes in v2:
 - Remove references to Physical Address Width (no longer part of Smmpt)
 - Remove special first entry from the list of physical memory regions
 - Fix compatible string in DT binding example

 .../bindings/riscv/physical-memory.yaml       | 92 +++++++++++++++++++
 include/dt-bindings/riscv/physical-memory.h   | 45 +++++++++
 2 files changed, 137 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/riscv/physical-memory.yaml
 create mode 100644 include/dt-bindings/riscv/physical-memory.h

diff --git a/Documentation/devicetree/bindings/riscv/physical-memory.yaml b/Documentation/devicetree/bindings/riscv/physical-memory.yaml
new file mode 100644
index 000000000000..8beaa588c71c
--- /dev/null
+++ b/Documentation/devicetree/bindings/riscv/physical-memory.yaml
@@ -0,0 +1,92 @@
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
+      model = "BeagleV Starlight Beta";
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
index 000000000000..d6ed8015c535
--- /dev/null
+++ b/include/dt-bindings/riscv/physical-memory.h
@@ -0,0 +1,45 @@
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
+#define PMR_ALIAS_MASK			(0x7f << 24)
+#define PMR_IS_ALIAS			(0x80 << 24)
+#define PMR_ALIAS(n)			(PMR_IS_ALIAS | ((n) << 24))
+
+#endif /* _DT_BINDINGS_RISCV_PHYSICAL_MEMORY_H */
-- 
2.47.2


