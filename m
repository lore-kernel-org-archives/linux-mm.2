Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D2EC79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460C56B00B9; Mon,  5 Jan 2026 11:58:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FB36B00D7; Mon,  5 Jan 2026 11:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2966B00E7; Mon,  5 Jan 2026 11:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16CE56B00B9
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:58:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0282B6A78
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:58 +0000 (UTC)
X-FDA: 84298519956.21.200164C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DCDB740009
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n37oW5x1;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96ZVS4gPaDk5eMzZGMpmnaAYVEuV2kbwUBdzUG7AkYk=;
	b=x49u2RCrXvmziBOJyx+M4M6YJJS4dcpWv4jsRjryLZjyOgpSqokRLpdhml2wPP36QSflSX
	4i1uKPd0YqSKch2zu0WPHgxHGdTlf9EsfjShcf3l21zYBu4YuNtf30Vj3EwQvWrxmBb/rj
	hz5XJ1JoahRW4MqtLJoX7St9Q6odP2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632337; a=rsa-sha256;
	cv=none;
	b=jFLn/Np1LRwyZulRvT1JBg/EAl0sMpCFWfewt3MTfMLaTmv/VlsH8l2aGYROxoTCEA1kuI
	fm/qXpCN6lhXcwazo/GMO3msEgpUt7YHcORw6efug1jQxdYy0UFFOLa7WMNLjyaSwW9PnM
	J/LIbe4YzVSuknqqGkCpvbxre0Ap6tc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n37oW5x1;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0852840BEA;
	Mon,  5 Jan 2026 16:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29563C19421;
	Mon,  5 Jan 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632335;
	bh=zxh2YPOKqizJjGe+Ap+jtqn7sHfKPE2mtySzfuL7KxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n37oW5x1mJdnPr/2tkPCC4SAFIMlmlpQ30yFoHCuZ5jEaBh/A37wRI4JIACj/DIOF
	 6EOFDxjttRbkjriHhclNIPhHxlAnMIoyycuQ02kfvNbXI+U6FU6KF7yrZfel6SbESo
	 iJY2ijYDGVzh5pvDWkd+Zbd40xkyb9Bqi9BRKL1Z98pXg/uGUohCCMMV1w8MlgSonG
	 0QywLe79udHa/Y5WnFYtXjG+pGtTsmaByII4PYl9ZK9fIakh7fGM9YBTRspFYuqaxr
	 kbXDhVCY8j6BXl+867DsT8RTvgmJZr/mXfEj5pQenu5RIsgFwMMz6/EClNwC9CmsQP
	 bwLQAd8kCHiFQ==
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
Subject: [PATCH 3/6] kho: docs: combine concepts and FDT documentation
Date: Mon,  5 Jan 2026 18:58:36 +0200
Message-ID: <20260105165839.285270-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5w4xq9tcxrizninph4sakek75qc6re3m
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCDB740009
X-Rspam-User: 
X-HE-Tag: 1767632336-789485
X-HE-Meta: U2FsdGVkX1/ZAEMikxCV30eGK0rDhzJ8N81mkEW/hZ831SbpEbwBJMEzC7g4e4kB6uy3+NoP2UgWYuVzJW1tmXk/sFKE4CWA8gtdeZPHqWnnfBc/8bwo0Dup5p3xPRaNm0HpF4jMFIRKHVCl96WeqjtrthER09RUMdbfP027epczP2kwcCNsVjS0DulpLiGHZxFDi/qyD9rt6GgrX41RqRT39ootu+Dl14IP9vQXjS7wHvZr08jh/NRU9DdWM1FlKvGQmrhNh5o1ytAPECcmygy7nZD41Mds8VcYBx3jqCRNFskAk/KMnlOgrJ8xbR8+q/FlXQ31KDaoK1jcpSGPbSybYNwtJWREAfbtPTx9RHjhbFRsr2UX5rVoH1ZncVfoZ/xnraf0kX2i9g4tFLLhWD+Ywl6wuQe+u1nYXa53p9J+8pweafHqRlUsDSyAvG7+R4aJEOYZ1cady1p/R8Q9oCh09lHla7sSnvAqlWp8Eo19RTZiLl6OxprXgs8KX4qnkUWGD/NsxHe+I7LY0Twi7swPf4Xv+BeS6Pf/EI3EPuTFL8SjBanQMo8Epkcwp9Dg9ZtnkyrDzME4CEo/+ALWhlN58RJ60Idl7wZXXp8kaiZyWdKjscEBgT6C4UHQeYFCwKSrXle53d6SEJqrNu9YQcA7nwgmZkfG1AhFvpnaw1GYkcOUfiLIEbnNBvTCuQ101LccN9nvzyDP/SxKMS9kdn+PW2U/yzPwLXDOcurvmkDZL2JEFpY8XIy0afkt6CDIdzSlX2N5q67zZ4YdUVRf6XWQIQQiCUMLlWW4PpApX6BbfcftvokbCONoCuFaLc3kfTwvLUV64XcuA+/JUuF964omLtDNvTiPhxvXDkVR8/lMaiEKcuMHSIjV0DcJ0hmeKOdwdTEjUSw32sJ0JJQtZpafo2agYjhVEGhXfLtTZO2egpdAS25cwZBq3NDMnY6COPkHDzK2B3aM8LZ17le
 k/bu33H5
 e74VjVY88l2NUGYMPUF54WkZVvqt3kzpsPBDqh03KiKHSMvNM81SISkyADWsJfy7/JlqqxUxv4WNpEPKt+bTSy5ZpTaAjYsEZbyRUQcWEEB1LgpbodXQcKmVE2Q3rAZ4kDbpcQabD3QswHbPUkXJ3LnMLsgWQBX5itPb4Ya8T4nCHS5+ZU772X5WpwP9VuIBT5JkUMGW70zC//Kj/LHjk/C9r7QhYM6S3iar5JMfpVxWEZNE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Currently index.rst in KHO documentation looks empty and sad as it only
contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.

Inline contents of these chapters into index.rst to provide a single
coherent chapter describing KHO.

While on it, drop parts of the KHO FDT description that will be superseded
by addition of KHO ABI documentation.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/kho/concepts.rst | 74 -----------------------
 Documentation/core-api/kho/fdt.rst      | 80 -------------------------
 Documentation/core-api/kho/index.rst    | 73 ++++++++++++++++++++--
 Documentation/core-api/liveupdate.rst   |  2 +-
 Documentation/mm/memfd_preservation.rst |  2 +-
 5 files changed, 70 insertions(+), 161 deletions(-)
 delete mode 100644 Documentation/core-api/kho/concepts.rst
 delete mode 100644 Documentation/core-api/kho/fdt.rst

diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
deleted file mode 100644
index d626d1dbd678..000000000000
--- a/Documentation/core-api/kho/concepts.rst
+++ /dev/null
@@ -1,74 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0-or-later
-.. _kho-concepts:
-
-=======================
-Kexec Handover Concepts
-=======================
-
-Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
-regions, which could contain serialized system states, across kexec.
-
-It introduces multiple concepts:
-
-KHO FDT
-=======
-
-Every KHO kexec carries a KHO specific flattened device tree (FDT) blob
-that describes preserved memory regions. These regions contain either
-serialized subsystem states, or in-memory data that shall not be touched
-across kexec. After KHO, subsystems can retrieve and restore preserved
-memory regions from KHO FDT.
-
-KHO only uses the FDT container format and libfdt library, but does not
-adhere to the same property semantics that normal device trees do: Properties
-are passed in native endianness and standardized properties like ``regs`` and
-``ranges`` do not exist, hence there are no ``#...-cells`` properties.
-
-KHO is still under development. The FDT schema is unstable and would change
-in the future.
-
-Scratch Regions
-===============
-
-To boot into kexec, we need to have a physically contiguous memory range that
-contains no handed over memory. Kexec then places the target kernel and initrd
-into that region. The new kernel exclusively uses this region for memory
-allocations before during boot up to the initialization of the page allocator.
-
-We guarantee that we always have such regions through the scratch regions: On
-first boot KHO allocates several physically contiguous memory regions. Since
-after kexec these regions will be used by early memory allocations, there is a
-scratch region per NUMA node plus a scratch region to satisfy allocations
-requests that do not require particular NUMA node assignment.
-By default, size of the scratch region is calculated based on amount of memory
-allocated during boot. The ``kho_scratch`` kernel command line option may be
-used to explicitly define size of the scratch regions.
-The scratch regions are declared as CMA when page allocator is initialized so
-that their memory can be used during system lifetime. CMA gives us the
-guarantee that no handover pages land in that region, because handover pages
-must be at a static physical memory location and CMA enforces that only
-movable pages can be located inside.
-
-After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
-instead reuse the exact same region that was originally allocated. This allows
-us to recursively execute any amount of KHO kexecs. Because we used this region
-for boot memory allocations and as target memory for kexec blobs, some parts
-of that memory region may be reserved. These reservations are irrelevant for
-the next KHO, because kexec can overwrite even the original kernel.
-
-.. _kho-finalization-phase:
-
-KHO finalization phase
-======================
-
-To enable user space based kexec file loader, the kernel needs to be able to
-provide the FDT that describes the current kernel's state before
-performing the actual kexec. The process of generating that FDT is
-called serialization. When the FDT is generated, some properties
-of the system may become immutable because they are already written down
-in the FDT. That state is called the KHO finalization phase.
-
-Public API
-==========
-.. kernel-doc:: kernel/liveupdate/kexec_handover.c
-   :export:
diff --git a/Documentation/core-api/kho/fdt.rst b/Documentation/core-api/kho/fdt.rst
deleted file mode 100644
index 62505285d60d..000000000000
--- a/Documentation/core-api/kho/fdt.rst
+++ /dev/null
@@ -1,80 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0-or-later
-
-=======
-KHO FDT
-=======
-
-KHO uses the flattened device tree (FDT) container format and libfdt
-library to create and parse the data that is passed between the
-kernels. The properties in KHO FDT are stored in native format.
-It includes the physical address of an in-memory structure describing
-all preserved memory regions, as well as physical addresses of KHO users'
-own FDTs. Interpreting those sub FDTs is the responsibility of KHO users.
-
-KHO nodes and properties
-========================
-
-Property ``preserved-memory-map``
----------------------------------
-
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
-========
-
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
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 0c63b0c5c143..03cd9afbdb2e 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -4,10 +4,73 @@
 Kexec Handover Subsystem
 ========================
 
-.. toctree::
-   :maxdepth: 1
+Overview
+========
 
-   concepts
-   fdt
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
+regions, which could contain serialized system states, across kexec.
 
-.. only::  subproject and html
+KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
+the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
+memory regions <kho_scratch>` to ensure integrity of the preserved memory.
+
+.. _kho_fdt:
+
+KHO FDT
+=======
+Every KHO kexec carries a KHO specific flattened device tree (FDT) blob that
+describes the preserved state. The FDT includes properties describing preserved
+memory regions and nodes that hold subsystem specific state.
+
+The preserved memory regions contain either serialized subsystem states, or
+in-memory data that shall not be touched across kexec. After KHO, subsystems
+can retrieve and restore the preserved state from KHO FDT.
+
+Subsystems participating in KHO can define their own format for state
+serialization and preservation.
+
+.. _kho_scratch:
+
+Scratch Regions
+===============
+
+To boot into kexec, we need to have a physically contiguous memory range that
+contains no handed over memory. Kexec then places the target kernel and initrd
+into that region. The new kernel exclusively uses this region for memory
+allocations before during boot up to the initialization of the page allocator.
+
+We guarantee that we always have such regions through the scratch regions: On
+first boot KHO allocates several physically contiguous memory regions. Since
+after kexec these regions will be used by early memory allocations, there is a
+scratch region per NUMA node plus a scratch region to satisfy allocations
+requests that do not require particular NUMA node assignment.
+By default, size of the scratch region is calculated based on amount of memory
+allocated during boot. The ``kho_scratch`` kernel command line option may be
+used to explicitly define size of the scratch regions.
+The scratch regions are declared as CMA when page allocator is initialized so
+that their memory can be used during system lifetime. CMA gives us the
+guarantee that no handover pages land in that region, because handover pages
+must be at a static physical memory location and CMA enforces that only
+movable pages can be located inside.
+
+After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
+instead reuse the exact same region that was originally allocated. This allows
+us to recursively execute any amount of KHO kexecs. Because we used this region
+for boot memory allocations and as target memory for kexec blobs, some parts
+of that memory region may be reserved. These reservations are irrelevant for
+the next KHO, because kexec can overwrite even the original kernel.
+
+KHO finalization phase
+======================
+
+To enable user space based kexec file loader, the kernel needs to be able to
+provide the FDT that describes the current kernel's state before
+performing the actual kexec. The process of generating that FDT is
+called serialization. When the FDT is generated, some properties
+of the system may become immutable because they are already written down
+in the FDT. That state is called the KHO finalization phase.
+
+See Also
+========
+
+- :doc:`/admin-guide/mm/kho`
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 7960eb15a81f..e2aba13494cf 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -58,4 +58,4 @@ See Also
 ========
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
-- :doc:`/core-api/kho/concepts`
+- :doc:`/core-api/kho/index`
diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
index 66e0fb6d5ef0..a8a5b476afd3 100644
--- a/Documentation/mm/memfd_preservation.rst
+++ b/Documentation/mm/memfd_preservation.rst
@@ -20,4 +20,4 @@ See Also
 ========
 
 - :doc:`/core-api/liveupdate`
-- :doc:`/core-api/kho/concepts`
+- :doc:`/core-api/kho/index`
-- 
2.51.0


