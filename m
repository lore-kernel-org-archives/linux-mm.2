Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85A5CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67386B0088; Mon,  8 Dec 2025 01:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E172B6B0095; Mon,  8 Dec 2025 01:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEFD6B0099; Mon,  8 Dec 2025 01:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9CBC6B0088
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:35:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66E951609BA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:31 +0000 (UTC)
X-FDA: 84195342462.29.1A17173
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7798940013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Oeiu8wHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3r3E2aQgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3r3E2aQgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175729; a=rsa-sha256;
	cv=none;
	b=xx4rzPuFANJOGhis3WTwMvdY5DfQEjbPbJdgYfh+9xOg5YyOuLMj3Lp/eKPhYZTIXr2KDN
	U0YozZbYKby+dbSx5f4WnBsUIBGC1hLLRRXkg6oj4PPzFKMRJo2eW9MU4G6nSuSr0s599G
	gRNn/CgDEfB+hfepMwAdurp3YJHCXYU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Oeiu8wHb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3r3E2aQgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3r3E2aQgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUJ3puPGgI0Ir8TsJOp6fZysorER2Bx+GIwpBX+UBQE=;
	b=g5SnANc+9P0ziooQaj7y3RL13ScP3dKdW+tsQEVk8FKKgoJVF/ofooGbEvjpCRAHfIZy3I
	6M9yks+DV13k+gVs9QHqDm1efc/r52BjpANwr+hKXri1bKR5LxqQqgyNIvahp//PaQy+Mu
	ibHjpe0ugwfKVeWzDssS3et8VCk45uQ=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-ba265ee0e34so4169884a12.2
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765175728; x=1765780528; darn=kvack.org;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XUJ3puPGgI0Ir8TsJOp6fZysorER2Bx+GIwpBX+UBQE=;
        b=Oeiu8wHbnvT0vYSv6iy+9PhGpxDlZZ5cRu0oA0eLHMf0jkewrAQPkkof930S6Dyqmm
         HVeD+2LSFWS/8zewpg2JWJx/gEChtX6XV6s1igoE4DhtSXT4CBaUiGXUc/SYnp3y6yie
         7ZVwx08swY+vIUSbEUhVZ4VSxQ2Tcz2iZkKhWjCinnjJaiBHcj10ypwsx9RUvJW9ifld
         ccSDCxYwxqdRxkLwkWlnTILcnAXmoFpgDR6+JbkvterZS0t0J1w/xeE8KOV5u9HFGXDi
         yDqrfyesmgu69TZljA1eqsSVzTZn01OHbN7OPeg5OIXcQm/dVgUAwu7v8+oaPUqzMOh0
         7Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765175728; x=1765780528;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XUJ3puPGgI0Ir8TsJOp6fZysorER2Bx+GIwpBX+UBQE=;
        b=IsmcbUTYMVT5p1ev0ASe3PKLtCeBCyDFqNCT9SA/vn/8P4wDzrjdnHgKuhsMwKF2gC
         vxfqEGBu+YGFWDCAPWShZN/gnKYSCyCpYdznyu04+y32gHY2Xor8DdgNx4h+pA2+uf23
         l2yGSuKEfG3k7m3tXGSmn4vcMd6eQtwXr0gCwO44ejcCTpArBFtbH7o4ZWEae5dnCcH2
         4fiGWZNgmDy+L4uQRmnCqqX+f10zXTl4s/tfABOBpn2UKmYpnq5kVge/AQmwZaaLt+bw
         TVsHSd9UUQoUzPJG1z6/WO5wzbxi97ZhmmrGynAnCt5DmxhV6bQRi3EWwlFTrvkQvy8L
         ksPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7HEPT+507uXQbQ2elFAtSFBXSjB+uFOepeSwsOfVgR5SxnWcVF9meSEm/vr86Gk0ruuSYxI3PIg==@kvack.org
X-Gm-Message-State: AOJu0Yw7pqkJm5WyDEbpyKUMXm+5w6taVtAZeWQLmfeoIZ6fzm8cwzX9
	6rlbmeDGA1wae8c1PsLNJq5s2uUfKMH8GG6auxc6jIkOtb6X2TDebbVw98Y+Hwv6asbQdPeNtbi
	/y4GPvUDpaTThVA==
X-Google-Smtp-Source: AGHT+IGvgsG5KXHwaPn0T/9PsuVa7rIEIlsferSBfmPbJpApXjbhYW394RKn+Hn/TPysCrYMk/lmc3RGo7Ze3A==
X-Received: from dybmk41.prod.google.com ([2002:a05:7301:ea9:b0:2a4:61a6:6c])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:a2d:b0:2a4:5ce8:44d0 with SMTP id 5a478bee46e88-2abc721658cmr3090766eec.38.1765175727992;
 Sun, 07 Dec 2025 22:35:27 -0800 (PST)
Date: Sun,  7 Dec 2025 22:35:12 -0800
In-Reply-To: <20251208063513.3633942-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251208063513.3633942-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208063513.3633942-4-jasonmiu@google.com>
Subject: [PATCH 3/4] kho: Adopt radix tree for preserved memory tracking
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cfw9qdse4wunagwk48dzyroud3pe1fxa
X-Rspam-User: 
X-Rspamd-Queue-Id: 7798940013
X-Rspamd-Server: rspam01
X-HE-Tag: 1765175729-813550
X-HE-Meta: U2FsdGVkX19AFw4sUb771vNKHzFG4ZEXvm/wIF9fFD8qLKneh4spBTDiP3MXYErgDNl3n5FkZZab9tOLk8XqCgZz9i7C+fTCkI2ZagYQa6RTv0ikoJawBHZA8gY3a39kw4/WayNns8XSKuqVIeQSyVlaIDLq4J9kMieypLBTA5mG5eLq6AUkO37y4yP/W63HlStLtP+kAXuOffTQm1wQRnIfcDc93ca5roIHNMUaQCOwUOo/9BtfxRGae2637NxCqHTjLDSxhsk5xU4CCLtYURSuMvG+B7JEq1fqiaAKr92bQnj993I2ubDMSYPPYLCEC9gR+GnAZP2Vc1jDiMXPTOhzOc8+KNz6XS+/CAtn0F/cKjziE2e3EMjAdqwOVa0WYphgF+DrRZ1d8dg3H6rPSUJ1ijS2vPoB7tFNim41fQEvy0I4MDXu6n2tuVHtb7s+LuK/vfTaMHr8sP9T+2fWpj8lONafbBAFXlimeCuZf3fkHypwdq6PZNtzXtHTy0sVe3ssEDGZKOgxbH66H4fMbRi/IB9jvFNiDYp2P+qjWbPuvpujMJ8IHZruHAjl5+nbwYM/aB1AqRb52X9QBusokPRTPh2o9ijtIkzGPiVSQ7znO4B6mrDI/TaTICJQ8TWYpTFcAd/LyH3APJPONd45cm3jIIT0lHyDtJT+OQHMXabKtFfWoRZ1W0tmXbiMVDdOaHd6gGC8TahoBGnKG8oU73ZHOVcLRW4x/Fw9NQ7ZFeeGBcptdjtECugQIx/0e1LTSkiGNVGrmd8UYchhyYU+kI1HrQzaVzBgJhIHEPLnGelipVhbetfFIfVivLAffGc0kRFXo2U2Ubr0XiLRgiyXjalr4Qxj197r0aWsUTYyIf1N7VzAr1M/qAT0SqqXvOi04LwsbFAhV7eKy+55NS86kfu+3RRU78Xur5dwH4+l4zLUprKcWv4pxWY8U7iSs2PsN+gCQ7cWImZzTRCwYoW
 6bONDfnB
 zB9jzCFhGcZdolR3zo9vjWbgvIZbWOMlp97HiTGKcH51Lrq3H3AgvFtlT8POqFPeC0DBWySQ3xdSu57tAWhfcoZUP2CKRmjo1ecZNk4u8C/54uU1NyHYCMbll3qF54cNwjkgtcQeZz/aeB+/4kFr+wFYDPFnGS2Qh32qIm/llN6C0QqZNUCbIjlRhciAGwaHGoDVT9xb4B7L0yDmbLmsE5VlcG5iR0nUnzrxbqEmLEvUmWO0aLfI6ON9VKIRqcIPUaQabh8JhOZpQ/jaOobTCNkuAGDJSK9HNugpu/rM53qrhQR+Wawwc34ADPzoPd88Di448PbjDrvj5P//kNyNwKcAJ6BuFDGgQNaA4FPvqdTjRqzOdhHHWgl2/zEfrDlWh+lSnuMJx9VOA3CHU8Tp9H7ntNkGWR47dILinGzIatCU22zr4Pp+/gBcsTWeufL9Kppqu43pNZcL4q7K7U8XCTG3BdQqea3ZVZuezrYUShBHLgQ+G4ZKr+BkVGw5+duPXG7gKb8V4XG27H/0ZSXpVWoOCrWoY/LDOUpI6LnTNanbepROkQF2fGNylDSA97U1D9V77ZDTJxUDQGaio7lSd6xuDLMNqAP30d/o/u586rFYpF5Nfikjh/s1frZ9ksO6hXEc04XIhg/YTiX8KPyKG9hs+nxC+uNsvR2Dwkbv1tRBbIVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a radix tree implementation for tracking preserved memory pages
and switch the KHO memory tracking mechanism to use it. This lays the
groundwork for a stateless KHO implementation that eliminates the need for
serialization and the associated "finalize" state.

This patch introduces the core radix tree data structures and constants to
the KHO ABI. It adds the radix tree node and leaf structures, along with
documentation for the radix tree key encoding scheme that combines a page's
physical address and order.

To support broader use by other kernel subsystems, such as hugetlb
preservation, the core radix tree manipulation functions are exported as
a public API.

The xarray-based memory tracking is replaced with this new radix tree
implementation. The core KHO preservation and unpreservation functions are
wired up to use the radix tree helpers. On boot, the second kernel restores
the preserved memory map by walking the radix tree whose root physical
address is passed via the FDT.

The ABI `compatible` version is bumped to "kho-v2" to reflect the
structural changes in the preserved memory map and sub-FDT property
names.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 Documentation/core-api/kho/concepts.rst   |   2 +-
 Documentation/core-api/kho/fdt.rst        |   7 +
 Documentation/core-api/kho/index.rst      |   1 +
 Documentation/core-api/kho/radix_tree.rst |  17 +
 include/linux/kho/abi/kexec_handover.h    | 124 +++-
 include/linux/kho_radix_tree.h            |  81 +++
 kernel/liveupdate/kexec_handover.c        | 658 ++++++++++++----------
 7 files changed, 568 insertions(+), 322 deletions(-)
 create mode 100644 Documentation/core-api/kho/radix_tree.rst
 create mode 100644 include/linux/kho_radix_tree.h

diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-a=
pi/kho/concepts.rst
index e96893937286..d38bcaa951e4 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ b/Documentation/core-api/kho/concepts.rst
@@ -71,7 +71,7 @@ in the FDT. That state is called the KHO finalization pha=
se.
 Public API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 .. kernel-doc:: kernel/liveupdate/kexec_handover.c
-   :export:
+   :identifiers: kho_is_enabled kho_restore_folio kho_restore_pages kho_ad=
d_subtree kho_remove_subtree kho_preserve_folio kho_unpreserve_folio kho_pr=
eserve_pages kho_unpreserve_pages kho_preserve_vmalloc kho_unpreserve_vmall=
oc kho_restore_vmalloc kho_alloc_preserve kho_unpreserve_free kho_restore_f=
ree is_kho_boot kho_retrieve_subtree
=20
 Internal API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/core-api/kho/fdt.rst b/Documentation/core-api/kh=
o/fdt.rst
index 4202b67fcdf9..56993d091b32 100644
--- a/Documentation/core-api/kho/fdt.rst
+++ b/Documentation/core-api/kho/fdt.rst
@@ -20,8 +20,15 @@ Kexec Handover ABI for vmalloc Preservation
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI for vmalloc Preservation
=20
+Keep track of memory that is to be preserved across KHO
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Keep track of memory that is to be preserved across KHO.
+
 See Also
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
 - :doc:`/admin-guide/mm/kho`
 - :doc:`/core-api/kho/concepts`
+- :doc:`/core-api/kho/radix_tree`
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/=
kho/index.rst
index 0c63b0c5c143..68cdf332076e 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -9,5 +9,6 @@ Kexec Handover Subsystem
=20
    concepts
    fdt
+   radix_tree
=20
 .. only::  subproject and html
diff --git a/Documentation/core-api/kho/radix_tree.rst b/Documentation/core=
-api/kho/radix_tree.rst
new file mode 100644
index 000000000000..9523ade75d9c
--- /dev/null
+++ b/Documentation/core-api/kho/radix_tree.rst
@@ -0,0 +1,17 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+KHO Radix Tree
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Description
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. kernel-doc:: include/linux/kho_radix_tree.h
+   :doc: Kexec Handover Radix Tree
+
+Public API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. kernel-doc:: kernel/liveupdate/kexec_handover.c
+   :identifiers: kho_radix_encode_key kho_radix_decode_key kho_radix_add_p=
age kho_radix_del_page kho_radix_walk_tree
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi=
/kexec_handover.h
index 74f4fa67e458..bdda2fe67353 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -10,6 +10,8 @@
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
=20
+#include <linux/bits.h>
+#include <linux/log2.h>
 #include <linux/types.h>
=20
 /**
@@ -35,25 +37,25 @@
  *   parses this FDT to locate and restore the preserved data.::
  *
  *     / {
- *         compatible =3D "kho-v1";
+ *         compatible =3D "kho-v2";
  *
  *         preserved-memory-map =3D <0x...>;
  *
  *         <subnode-name-1> {
- *             fdt =3D <0x...>;
+ *             preserved-data =3D <0x...>;
  *         };
  *
  *         <subnode-name-2> {
- *             fdt =3D <0x...>;
+ *             preserved-data =3D <0x...>;
  *         };
  *               ... ...
  *         <subnode-name-N> {
- *             fdt =3D <0x...>;
+ *             preserved-data =3D <0x...>;
  *         };
  *     };
  *
  *   Root KHO Node (/):
- *     - compatible: "kho-v1"
+ *     - compatible: "kho-v2"
  *
  *       Indentifies the overall KHO ABI version.
  *
@@ -68,20 +70,20 @@
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
=20
 /* The compatible string for the KHO FDT root node. */
-#define KHO_FDT_COMPATIBLE "kho-v1"
+#define KHO_FDT_COMPATIBLE "kho-v2"
=20
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
=20
 /* The FDT property for sub-FDTs. */
-#define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
+#define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
=20
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
@@ -159,4 +161,108 @@ struct kho_vmalloc {
 	unsigned short order;
 };
=20
+/**
+ * DOC: Keep track of memory that is to be preserved across KHO.
+ *
+ * KHO tracks preserved memory using a radix tree data structure. Each nod=
e of
+ * the tree is PAGE_SIZE. The leaf nodes are bitmaps where each set bit
+ * represents a single preserved page. The intermediate nodes are tables o=
f
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
+ * This is achieved by encoding the page's physical address (pa) and its o=
rder
+ * into a single unsigned long value. This value is a key then used to tra=
verse
+ * the tree. The encoded key value is composed of two parts: the 'order bi=
t' in
+ * the upper part and the 'page offset' in the lower part.::
+ *
+ *   +------------+-----------------------------+-------------------------=
-+
+ *   | Page Order | Order Bit                   | Page Offset             =
 |
+ *   +------------+-----------------------------+-------------------------=
-+
+ *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)  =
 |
+ *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)  =
 |
+ *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)  =
 |
+ *   | ...        | ...                         | ...                     =
 |
+ *   +------------+-----------------------------+-------------------------=
-+
+ *
+ * Page Offset:
+ * The 'page offset' is the physical address normalized for its order. It
+ * effectively represents the page offset for the given order.
+ *
+ * Order Bit:
+ * The 'order bit' encodes the page order by setting a single bit at a
+ * specific position. The position of this bit itself represents the order=
.
+ *
+ * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT =3D 12), th=
e
+ * maximum range for a page offset (for order 0) is 52 bits (64 - 12). Thi=
s
+ * offset occupies bits [0-51]. For order 0, the order bit is set at
+ * position 52.
+ *
+ * The following diagram illustrates how the encoded key value is split in=
to
+ * indices for the tree levels, with PAGE_SIZE of 4KB::
+ *
+ *        63:60   59:51    50:42    41:33    32:24    23:15         14:0
+ *   +---------+--------+--------+--------+--------+--------+-------------=
----+
+ *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitma=
p)  |
+ *   +---------+--------+--------+--------+--------+--------+-------------=
----+
+ *
+ * This design stores pages of all sizes (orders) in a single 6-level tabl=
e.
+ * It efficiently shares lower table levels, especially due to common zero=
 top
+ * address bits, allowing a single, efficient algorithm to manage all page=
s.
+ * This bitmap approach also offers memory efficiency; for example, a 512K=
B
+ * bitmap can cover a 16GB memory range for 0-order pages with PAGE_SIZE =
=3D 4KB.
+ *
+ * The data structures defined here are part of the KHO ABI. Any modificat=
ion
+ * to these structures that breaks backward compatibility must be accompan=
ied by
+ * an update to the "compatible" string. This ensures that a newer kernel =
can
+ * correctly interpret the data passed by an older kernel.
+ */
+
+/*
+ * Defines constants for the KHO radix tree structure, used to track prese=
rved
+ * memory. These constants govern the indexing, sizing, and depth of the t=
ree.
+ */
+enum kho_radix_consts {
+	/* The bit position of a 0-order page */
+	KHO_ORDER_0_LG2 =3D 64 - PAGE_SHIFT,
+
+	/* Size of the table in kho_mem_radix_tree, in lg2 */
+	KHO_TABLE_SIZE_LG2 =3D const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
+
+	/* Number of bits in the kho_bitmap, in lg2 */
+	KHO_BITMAP_SIZE_LG2 =3D PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
+
+	/*
+	 * The total tree depth is the number of intermediate levels
+	 * and 1 bitmap level.
+	 */
+	KHO_TREE_MAX_DEPTH =3D DIV_ROUND_UP(KHO_ORDER_0_LG2 - KHO_BITMAP_SIZE_LG2=
,
+					  KHO_TABLE_SIZE_LG2) + 1,
+};
+
+struct kho_radix_node {
+	u64 table[1 << KHO_TABLE_SIZE_LG2];
+};
+
+struct kho_radix_leaf {
+	DECLARE_BITMAP(bitmap, 1 << KHO_BITMAP_SIZE_LG2);
+};
+
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.=
h
new file mode 100644
index 000000000000..5101a04f6ae6
--- /dev/null
+++ b/include/linux/kho_radix_tree.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LIVEUPDATE_KEXEC_HANDOVER_RADIX_TREE_H
+#define _LIVEUPDATE_KEXEC_HANDOVER_RADIX_TREE_H
+
+#include <linux/err.h>
+#include <linux/errno.h>
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
+ * representing individual pages. To allow pages of different sizes (order=
s)
+ * to be stored efficiently in a single tree, it uses a unique key encodin=
g
+ * scheme. Each key is an unsigned long that combines a page's physical
+ * address and its order.
+ *
+ * Client code is responsible for allocating the root node of the tree and
+ * managing its lifecycle, and must use the tree data structures defined i=
n
+ * the KHO ABI, `include/linux/kho/abi/kexec_handover.h`.
+ */
+
+struct kho_radix_node;
+
+typedef int (*kho_radix_tree_walk_callback_t)(unsigned long radix_key);
+
+#ifdef CONFIG_KEXEC_HANDOVER
+
+unsigned long kho_radix_encode_key(phys_addr_t pa, unsigned int order);
+
+phys_addr_t kho_radix_decode_key(unsigned long radix_key,
+				 unsigned int *order);
+
+int kho_radix_add_page(struct kho_radix_node *root, unsigned long pfn,
+		       unsigned int order);
+
+void kho_radix_del_page(struct kho_radix_node *root, unsigned long pfn,
+			unsigned int order);
+
+int kho_radix_walk_tree(struct kho_radix_node *root, unsigned int level,
+			unsigned long start, kho_radix_tree_walk_callback_t cb);
+
+#else  /* #ifdef CONFIG_KEXEC_HANDOVER */
+
+static inline unsigned long kho_radix_encode_key(phys_addr_t pa,
+						 unsigned int order)
+{
+	return 0;
+}
+
+static inline phys_addr_t kho_radix_decode_key(unsigned long radix_key,
+					       unsigned int *order)
+{
+	return 0;
+};
+
+static inline int kho_radix_add_page(struct kho_radix_node *root, long pfn=
,
+				     unsigned int order)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void kho_radix_del_page(struct kho_radix_node *root,
+				      unsigned long pfn, unsigned int order) { }
+
+static inline int kho_radix_walk_tree(struct kho_radix_node *root,
+				      unsigned int level,
+				      unsigned long start,
+				      kho_radix_tree_walk_callback_t cb)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* #ifdef CONFIG_KEXEC_HANDOVER */
+
+#endif	/* _LIVEUPDATE_KEXEC_HANDOVER_RADIX_TREE_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_h=
andover.c
index a180b3367e8f..81bac82c8672 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.or=
g>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
  * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
+ * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>
  */
=20
 #define pr_fmt(fmt) "KHO: " fmt
@@ -15,6 +16,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho_radix_tree.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -66,155 +68,302 @@ static int __init kho_parse_enable(char *p)
 early_param("kho", kho_parse_enable);
=20
 /*
- * Keep track of memory that is to be preserved across KHO.
- *
- * The serializing side uses two levels of xarrays to manage chunks of per=
-order
- * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE =3D 4096, the entire =
1G order
- * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
- * allocations each bitmap will cover 128M of address space. Thus, for 16G=
 of
- * memory at most 512K of bitmap memory will be needed for order 0.
- *
- * This approach is fully incremental, as the serialization progresses fol=
ios
- * can continue be aggregated to the tracker. The final step, immediately =
prior
- * to kexec would serialize the xarray information into a linked list for =
the
- * successor kernel to parse.
+ * `root` points to a page that serves as the root of the
+ * KHO radix tree. This page is allocated during KHO module initialization=
.
+ * Its physical address is written to the FDT and passed to the next kerne=
l
+ * during kexec.
  */
-
-#define PRESERVE_BITS (PAGE_SIZE * 8)
-
-struct kho_mem_phys_bits {
-	DECLARE_BITMAP(preserve, PRESERVE_BITS);
-};
-
-static_assert(sizeof(struct kho_mem_phys_bits) =3D=3D PAGE_SIZE);
-
-struct kho_mem_phys {
-	/*
-	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
-	 * to order.
-	 */
-	struct xarray phys_bits;
-};
-
 struct kho_mem_track {
-	/* Points to kho_mem_phys, each order gets its own bitmap tree */
-	struct xarray orders;
+	struct kho_radix_node *root;
+	struct rw_semaphore sem;
 };
=20
-struct khoser_mem_chunk;
-
 struct kho_out {
-	void *fdt;
-	bool finalized;
-	struct mutex lock; /* protects KHO FDT finalization */
-
 	struct kho_mem_track track;
+	void *fdt;
+	struct mutex lock; /* protects KHO FDT */
 	struct kho_debugfs dbg;
 };
=20
 static struct kho_out kho_out =3D {
-	.lock =3D __MUTEX_INITIALIZER(kho_out.lock),
 	.track =3D {
-		.orders =3D XARRAY_INIT(kho_out.track.orders, 0),
+		.sem =3D __RWSEM_INITIALIZER(kho_out.track.sem),
 	},
-	.finalized =3D false,
+	.lock =3D __MUTEX_INITIALIZER(kho_out.lock),
 };
=20
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
+/**
+ * kho_radix_encode_key - Encodes a physical address and order into a radi=
x key.
+ * @pa: The physical address of the page.
+ * @order: The order of the page.
+ *
+ * This function combines a page's physical address and its order into a
+ * single unsigned long, which is used as a key for all radix tree
+ * operations.
+ *
+ * Return: The encoded unsigned long key.
+ */
+unsigned long kho_radix_encode_key(phys_addr_t pa, unsigned int order)
 {
-	void *res =3D xa_load(xa, index);
+	/* Order bits part */
+	unsigned long h =3D 1UL << (KHO_ORDER_0_LG2 - order);
+	/* Page offset part */
+	unsigned long l =3D pa >> (PAGE_SHIFT + order);
=20
-	if (res)
-		return res;
+	return h | l;
+}
+EXPORT_SYMBOL_GPL(kho_radix_encode_key);
=20
-	void *elm __free(free_page) =3D (void *)get_zeroed_page(GFP_KERNEL);
+/**
+ * kho_radix_decode_key - Decodes a radix key back into a physical address=
 and order.
+ * @radix_key: The unsigned long key to decode.
+ * @order: An output parameter, a pointer to an unsigned int where the dec=
oded
+ *         page order will be stored.
+ *
+ * This function reverses the encoding performed by kho_radix_encode_key()=
,
+ * extracting the original physical address and page order from a given ke=
y.
+ *
+ * Return: The decoded physical address.
+ */
+phys_addr_t kho_radix_decode_key(unsigned long radix_key,
+				 unsigned int *order)
+{
+	unsigned int order_bit =3D fls64(radix_key);
+	phys_addr_t pa;
=20
-	if (!elm)
-		return ERR_PTR(-ENOMEM);
+	/* order_bit is numbered starting at 1 from fls64 */
+	*order =3D KHO_ORDER_0_LG2 - order_bit + 1;
+	/* The order is discarded by the shift */
+	pa =3D radix_key << (PAGE_SHIFT + *order);
=20
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
-		return ERR_PTR(-EINVAL);
+	return pa;
+}
+EXPORT_SYMBOL_GPL(kho_radix_decode_key);
+
+static unsigned long kho_radix_get_index(unsigned long radix_key,
+					 unsigned int level)
+{
+	int s;
=20
-	res =3D xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
-	if (xa_is_err(res))
-		return ERR_PTR(xa_err(res));
-	else if (res)
-		return res;
+	if (level =3D=3D 0)
+		return radix_key % (1 << KHO_BITMAP_SIZE_LG2);
=20
-	return no_free_ptr(elm);
+	s =3D ((level - 1) * KHO_TABLE_SIZE_LG2) + KHO_BITMAP_SIZE_LG2;
+	return (radix_key >> s) % (1 << KHO_TABLE_SIZE_LG2);
 }
=20
-static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned l=
ong pfn,
-				   unsigned int order)
+/**
+ * kho_radix_add_page - Marks a page as preserved in the radix tree.
+ * @root: The root of the radix tree.
+ * @pfn: The page frame number of the page to preserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree based on the key derived from @p=
fn
+ * and @order. It sets the corresponding bit in the leaf bitmap to mark th=
e
+ * page for preservation. If intermediate nodes do not exist along the pat=
h,
+ * they are allocated and added to the tree.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kho_radix_add_page(struct kho_radix_node *root,
+		       unsigned long pfn, unsigned int order)
 {
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
-	const unsigned long pfn_high =3D pfn >> order;
+	phys_addr_t pa =3D PFN_PHYS(pfn);
+	unsigned long radix_key =3D kho_radix_encode_key(pa, order);
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+	int err =3D 0;
=20
-	physxa =3D xa_load(&track->orders, order);
-	if (WARN_ON_ONCE(!physxa))
-		return;
+	/*
+	 * This array stores pointers to newly allocated intermediate radix tree
+	 * nodes along the insertion path. In case of an error during node
+	 * allocation or insertion, these stored pointers are used to free
+	 * the partially allocated path, preventing memory leaks.
+	 */
+	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] =3D { 0 };
=20
-	bits =3D xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-	if (WARN_ON_ONCE(!bits))
-		return;
+	might_sleep();
=20
-	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+	node =3D root;
+
+	/* Go from high levels to low levels */
+	for (i =3D KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx =3D kho_radix_get_index(radix_key, i);
+
+		if (node->table[idx]) {
+			node =3D phys_to_virt((phys_addr_t)node->table[idx]);
+			continue;
+		}
+
+		/* Next node is empty, create a new node for it */
+		struct kho_radix_node *new_tree;
+
+		new_tree =3D (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		if (!new_tree) {
+			err =3D -ENOMEM;
+			goto err_free_alloc_nodes;
+		}
+
+		node->table[idx] =3D virt_to_phys(new_tree);
+		node =3D new_tree;
+
+		intermediate_nodes[i] =3D new_tree;
+	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	idx =3D kho_radix_get_index(radix_key, 0);
+	leaf =3D (struct kho_radix_leaf *)node;
+	__set_bit(idx, leaf->bitmap);
+
+	return 0;
+
+err_free_alloc_nodes:
+	for (i =3D KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		if (intermediate_nodes[i])
+			free_page((unsigned long)intermediate_nodes[i]);
+	}
+
+	return err;
 }
+EXPORT_SYMBOL_GPL(kho_radix_add_page);
=20
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pf=
n,
-			     unsigned long end_pfn)
+/**
+ * kho_radix_del_page - Removes a page's preservation status from the radi=
x tree.
+ * @root: The root of the radix tree.
+ * @pfn: The page frame number of the page to unpreserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree and clears the bit corresponding=
 to
+ * the page, effectively removing its "preserved" status. It does not free
+ * the tree's intermediate nodes, even if they become empty.
+ */
+void kho_radix_del_page(struct kho_radix_node *root, unsigned long pfn,
+			unsigned int order)
 {
-	unsigned int order;
+	unsigned long radix_key =3D kho_radix_encode_key(PFN_PHYS(pfn), order);
+	unsigned int tree_level =3D KHO_TREE_MAX_DEPTH - 1;
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
=20
-	while (pfn < end_pfn) {
-		order =3D min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+	might_sleep();
=20
-		__kho_unpreserve_order(track, pfn, order);
+	node =3D root;
=20
-		pfn +=3D 1 << order;
+	/* Go from high levels to low levels */
+	for (i =3D tree_level; i > 0; i--) {
+		idx =3D kho_radix_get_index(radix_key, i);
+
+		/*
+		 * Attempting to delete a page that has not been preserved,
+		 * return with a warning.
+		 */
+		if (WARN_ON(!node->table[idx]))
+			return;
+
+		if (node->table[idx])
+			node =3D phys_to_virt((phys_addr_t)node->table[idx]);
 	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	leaf =3D (struct kho_radix_leaf *)node;
+	__clear_bit(idx, leaf->bitmap);
 }
+EXPORT_SYMBOL_GPL(kho_radix_del_page);
=20
-static int __kho_preserve_order(struct kho_mem_track *track, unsigned long=
 pfn,
-				unsigned int order)
+static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
+			       unsigned long radix_key,
+			       kho_radix_tree_walk_callback_t cb)
 {
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa, *new_physxa;
-	const unsigned long pfn_high =3D pfn >> order;
+	unsigned long *bitmap =3D (unsigned long *)leaf;
+	unsigned int i;
+	int err;
=20
-	might_sleep();
-	physxa =3D xa_load(&track->orders, order);
-	if (!physxa) {
-		int err;
+	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
+		err =3D cb(radix_key | i);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * kho_radix_walk_tree - Traverses the radix tree and calls a callback for=
 each preserved page.
+ * @root: A pointer to the root node of the radix tree to walk.
+ * @level: The starting level for the walk (typically KHO_TREE_MAX_DEPTH -=
 1).
+ * @start: The initial key prefix for the walk (typically 0).
+ * @cb: A callback function of type kho_radix_tree_walk_callback_t that wi=
ll be
+ *      invoked for each preserved page found in the tree. The callback re=
ceives
+ *      the full radix key of the preserved page.
+ *
+ * This function walks the radix tree, searching from the specified top le=
vel
+ * (@level) down to the lowest level (level 0). For each preserved page fo=
und,
+ * it invokes the provided callback, passing the page's fully reconstructe=
d
+ * radix key.
+ *
+ * Return: 0 if the walk completed the specified subtree, or the non-zero =
return
+ *         value from the callback that stopped the walk.
+ */
+int kho_radix_walk_tree(struct kho_radix_node *root, unsigned int level,
+			unsigned long start, kho_radix_tree_walk_callback_t cb)
+{
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned long radix_key, i;
+	int err;
=20
-		new_physxa =3D kzalloc(sizeof(*physxa), GFP_KERNEL);
-		if (!new_physxa)
-			return -ENOMEM;
+	for (i =3D 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
+		if (!root->table[i])
+			continue;
+
+		unsigned int shift;
=20
-		xa_init(&new_physxa->phys_bits);
-		physxa =3D xa_cmpxchg(&track->orders, order, NULL, new_physxa,
-				    GFP_KERNEL);
+		shift =3D ((level - 1) * KHO_TABLE_SIZE_LG2) +
+			KHO_BITMAP_SIZE_LG2;
+		radix_key =3D start | (i << shift);
=20
-		err =3D xa_err(physxa);
-		if (err || physxa) {
-			xa_destroy(&new_physxa->phys_bits);
-			kfree(new_physxa);
+		node =3D phys_to_virt((phys_addr_t)root->table[i]);
=20
+		if (level > 1) {
+			err =3D kho_radix_walk_tree(node, level - 1,
+						  radix_key, cb);
 			if (err)
 				return err;
 		} else {
-			physxa =3D new_physxa;
+			/*
+			 * we are at level 1,
+			 * node is pointing to the level 0 bitmap.
+			 */
+			leaf =3D (struct kho_radix_leaf *)node;
+			return kho_radix_walk_leaf(leaf, radix_key, cb);
 		}
 	}
=20
-	bits =3D xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-	if (IS_ERR(bits))
-		return PTR_ERR(bits);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
+
=20
-	set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
=20
-	return 0;
+static void __kho_unpreserve(unsigned long pfn, unsigned long end_pfn)
+{
+	struct kho_mem_track *track =3D &kho_out.track;
+	unsigned int order;
+
+	if (WARN_ON_ONCE(!track->root))
+		return;
+
+	down_write(&track->sem);
+	while (pfn < end_pfn) {
+		order =3D min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+
+		kho_radix_del_page(track->root, pfn, order);
+
+		pfn +=3D 1 << order;
+	}
+	up_write(&track->sem);
 }
=20
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
@@ -228,9 +377,10 @@ static struct page *kho_restore_page(phys_addr_t phys,=
 bool is_folio)
=20
 	info.page_private =3D page->private;
 	/*
-	 * deserialize_bitmap() only sets the magic on the head page. This magic
-	 * check also implicitly makes sure phys is order-aligned since for
-	 * non-order-aligned phys addresses, magic will never be set.
+	 * kho_radix_walk_tree_memblock_callback() only sets the magic on the
+	 * head page. This magic check also implicitly makes sure phys is
+	 * order-aligned since for non-order-aligned phys addresses, magic will
+	 * never be set.
 	 */
 	if (WARN_ON_ONCE(info.magic !=3D KHO_PAGE_MAGIC || info.order > MAX_PAGE_=
ORDER))
 		return NULL;
@@ -301,195 +451,30 @@ struct page *kho_restore_pages(phys_addr_t phys, uns=
igned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_restore_pages);
=20
-/* Serialize and deserialize struct kho_mem_phys across kexec
- *
- * Record all the bitmaps in a linked list of pages for the next kernel to
- * process. Each chunk holds bitmaps of the same order and each block of b=
itmaps
- * starts at a given physical address. This allows the bitmaps to be spars=
e. The
- * xarray is used to store them in a tree while building up the data struc=
ture,
- * but the KHO successor kernel only needs to process them once in order.
- *
- * All of this memory is normal kmalloc() memory and is not marked for
- * preservation. The successor kernel will remain isolated to the scratch =
space
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
-static_assert(sizeof(struct khoser_mem_chunk) =3D=3D PAGE_SIZE);
-
-static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chu=
nk,
-					  unsigned long order)
-{
-	struct khoser_mem_chunk *chunk __free(free_page) =3D NULL;
-
-	chunk =3D (void *)get_zeroed_page(GFP_KERNEL);
-	if (!chunk)
-		return ERR_PTR(-ENOMEM);
-
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
-		return ERR_PTR(-EINVAL);
-
-	chunk->hdr.order =3D order;
-	if (cur_chunk)
-		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return no_free_ptr(chunk);
-}
-
-static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
-{
-	struct khoser_mem_chunk *chunk =3D first_chunk;
-
-	while (chunk) {
-		struct khoser_mem_chunk *tmp =3D chunk;
-
-		chunk =3D KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
-	}
-}
-
-/*
- *  Update memory map property, if old one is found discard it via
- *  kho_mem_ser_free().
- */
-static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
+static int __init kho_radix_walk_tree_memblock_callback(unsigned long radi=
x_key)
 {
-	void *ptr;
-	u64 phys;
-
-	ptr =3D fdt_getprop_w(kho_out.fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, NULL)=
;
-
-	/* Check and discard previous memory map */
-	phys =3D get_unaligned((u64 *)ptr);
-	if (phys)
-		kho_mem_ser_free((struct khoser_mem_chunk *)phys_to_virt(phys));
-
-	/* Update with the new value */
-	phys =3D first_chunk ? (u64)virt_to_phys(first_chunk) : 0;
-	put_unaligned(phys, (u64 *)ptr);
-}
-
-static int kho_mem_serialize(struct kho_out *kho_out)
-{
-	struct khoser_mem_chunk *first_chunk =3D NULL;
-	struct khoser_mem_chunk *chunk =3D NULL;
-	struct kho_mem_phys *physxa;
-	unsigned long order;
-	int err =3D -ENOMEM;
+	union kho_page_info info;
+	unsigned int order;
+	unsigned long pa;
+	struct page *page;
+	int sz;
=20
-	xa_for_each(&kho_out->track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
+	pa =3D kho_radix_decode_key(radix_key, &order);
=20
-		chunk =3D new_chunk(chunk, order);
-		if (IS_ERR(chunk)) {
-			err =3D PTR_ERR(chunk);
-			goto err_free;
-		}
-
-		if (!first_chunk)
-			first_chunk =3D chunk;
-
-		xa_for_each(&physxa->phys_bits, phys, bits) {
-			struct khoser_mem_bitmap_ptr *elm;
-
-			if (chunk->hdr.num_elms =3D=3D ARRAY_SIZE(chunk->bitmaps)) {
-				chunk =3D new_chunk(chunk, order);
-				if (IS_ERR(chunk)) {
-					err =3D PTR_ERR(chunk);
-					goto err_free;
-				}
-			}
-
-			elm =3D &chunk->bitmaps[chunk->hdr.num_elms];
-			chunk->hdr.num_elms++;
-			elm->phys_start =3D (phys * PRESERVE_BITS)
-					  << (order + PAGE_SHIFT);
-			KHOSER_STORE_PTR(elm->bitmap, bits);
-		}
-	}
+	sz =3D 1 << (order + PAGE_SHIFT);
+	page =3D phys_to_page(pa);
=20
-	kho_update_memory_map(first_chunk);
+	/* Reserve the memory preserved in KHO radix tree in memblock */
+	memblock_reserve(pa, sz);
+	memblock_reserved_mark_noinit(pa, sz);
+	info.magic =3D KHO_PAGE_MAGIC;
+	info.order =3D order;
+	page->private =3D info.page_private;
=20
 	return 0;
-
-err_free:
-	kho_mem_ser_free(first_chunk);
-	return err;
 }
=20
-static void __init deserialize_bitmap(unsigned int order,
-				      struct khoser_mem_bitmap_ptr *elm)
-{
-	struct kho_mem_phys_bits *bitmap =3D KHOSER_LOAD_PTR(elm->bitmap);
-	unsigned long bit;
-
-	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz =3D 1 << (order + PAGE_SHIFT);
-		phys_addr_t phys =3D
-			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page =3D phys_to_page(phys);
-		union kho_page_info info;
-
-		memblock_reserve(phys, sz);
-		memblock_reserved_mark_noinit(phys, sz);
-		info.magic =3D KHO_PAGE_MAGIC;
-		info.order =3D order;
-		page->private =3D info.page_private;
-	}
-}
=20
-/* Return true if memory was deserizlied */
-static bool __init kho_mem_deserialize(const void *fdt)
-{
-	struct khoser_mem_chunk *chunk;
-	const void *mem_ptr;
-	u64 mem;
-	int len;
-
-	mem_ptr =3D fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-	if (!mem_ptr || len !=3D sizeof(u64)) {
-		pr_err("failed to get preserved memory bitmaps\n");
-		return false;
-	}
-
-	mem =3D get_unaligned((const u64 *)mem_ptr);
-	chunk =3D mem ? phys_to_virt(mem) : NULL;
-
-	/* No preserved physical pages were passed, no deserialization */
-	if (!chunk)
-		return false;
-
-	while (chunk) {
-		unsigned int i;
-
-		for (i =3D 0; i !=3D chunk->hdr.num_elms; i++)
-			deserialize_bitmap(chunk->hdr.order,
-					   &chunk->bitmaps[i]);
-		chunk =3D KHOSER_LOAD_PTR(chunk->hdr.next);
-	}
-
-	return true;
-}
=20
 /*
  * With KHO enabled, memory can become fragmented because KHO regions may
@@ -789,14 +774,22 @@ EXPORT_SYMBOL_GPL(kho_remove_subtree);
  */
 int kho_preserve_folio(struct folio *folio)
 {
+	struct kho_mem_track *track =3D &kho_out.track;
 	const unsigned long pfn =3D folio_pfn(folio);
 	const unsigned int order =3D folio_order(folio);
-	struct kho_mem_track *track =3D &kho_out.track;
+	int err;
=20
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
=20
-	return __kho_preserve_order(track, pfn, order);
+	if (WARN_ON_ONCE(!track->root))
+		return -EINVAL;
+
+	down_write(&track->sem);
+	err =3D kho_radix_add_page(track->root, pfn, order);
+	up_write(&track->sem);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
=20
@@ -810,11 +803,16 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  */
 void kho_unpreserve_folio(struct folio *folio)
 {
+	struct kho_mem_track *track =3D &kho_out.track;
 	const unsigned long pfn =3D folio_pfn(folio);
 	const unsigned int order =3D folio_order(folio);
-	struct kho_mem_track *track =3D &kho_out.track;
=20
-	__kho_unpreserve_order(track, pfn, order);
+	if (WARN_ON_ONCE(!track->root))
+		return;
+
+	down_write(&track->sem);
+	kho_radix_del_page(track->root, pfn, order);
+	up_write(&track->sem);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
=20
@@ -842,11 +840,15 @@ int kho_preserve_pages(struct page *page, unsigned in=
t nr_pages)
 		return -EINVAL;
 	}
=20
+	if (WARN_ON_ONCE(!track->root))
+		return -EINVAL;
+
+	down_write(&track->sem);
 	while (pfn < end_pfn) {
 		const unsigned int order =3D
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
=20
-		err =3D __kho_preserve_order(track, pfn, order);
+		err =3D kho_radix_add_page(track->root, pfn, order);
 		if (err) {
 			failed_pfn =3D pfn;
 			break;
@@ -854,9 +856,10 @@ int kho_preserve_pages(struct page *page, unsigned int=
 nr_pages)
=20
 		pfn +=3D 1 << order;
 	}
+	up_write(&track->sem);
=20
 	if (err)
-		__kho_unpreserve(track, start_pfn, failed_pfn);
+		__kho_unpreserve(start_pfn, failed_pfn);
=20
 	return err;
 }
@@ -874,11 +877,10 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  */
 void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 {
-	struct kho_mem_track *track =3D &kho_out.track;
 	const unsigned long start_pfn =3D page_to_pfn(page);
 	const unsigned long end_pfn =3D start_pfn + nr_pages;
=20
-	__kho_unpreserve(track, start_pfn, end_pfn);
+	__kho_unpreserve(start_pfn, end_pfn);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
=20
@@ -937,14 +939,13 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(st=
ruct kho_vmalloc_chunk *cur
 static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
 					 unsigned short order)
 {
-	struct kho_mem_track *track =3D &kho_out.track;
 	unsigned long pfn =3D PHYS_PFN(virt_to_phys(chunk));
=20
-	__kho_unpreserve(track, pfn, pfn + 1);
+	__kho_unpreserve(pfn, pfn + 1);
=20
 	for (int i =3D 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn =3D PHYS_PFN(chunk->phys[i]);
-		__kho_unpreserve(track, pfn, pfn + (1 << order));
+		__kho_unpreserve(pfn, pfn + (1 << order));
 	}
 }
=20
@@ -1213,25 +1214,12 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
=20
 int kho_finalize(void)
 {
-	int ret;
-
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	ret =3D kho_mem_serialize(&kho_out);
-	if (ret)
-		return ret;
-
-	kho_out.finalized =3D true;
-
 	return 0;
 }
=20
 bool kho_finalized(void)
 {
-	guard(mutex)(&kho_out.lock);
-	return kho_out.finalized;
+	return false;
 }
=20
 struct kho_in {
@@ -1304,18 +1292,49 @@ int kho_retrieve_subtree(const char *name, phys_add=
r_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
=20
+/* Return non-zero if error */
+static int __init kho_mem_retrieve(const void *fdt)
+{
+	struct kho_radix_node *tree_root;
+	const phys_addr_t *mem;
+	int len;
+
+	/* Retrieve the KHO radix tree from passed-in FDT. */
+	mem =3D fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
+
+	if (!mem || len !=3D sizeof(*mem)) {
+		pr_err("failed to get preserved KHO memory tree\n");
+		return -ENOENT;
+	}
+
+	if (!*mem)
+		return -EINVAL;
+
+	tree_root =3D phys_to_virt(*mem);
+	return kho_radix_walk_tree(tree_root, KHO_TREE_MAX_DEPTH - 1,
+				   0, kho_radix_walk_tree_memblock_callback);
+}
+
 static __init int kho_out_fdt_setup(void)
 {
+	struct kho_mem_track *track =3D &kho_out.track;
 	void *root =3D kho_out.fdt;
-	u64 empty_mem_map =3D 0;
+	u64 preserved_mem_tree_pa;
 	int err;
=20
 	err =3D fdt_create(root, PAGE_SIZE);
 	err |=3D fdt_finish_reservemap(root);
 	err |=3D fdt_begin_node(root, "");
 	err |=3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |=3D fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
-			    sizeof(empty_mem_map));
+
+	down_read(&track->sem);
+	preserved_mem_tree_pa =3D (u64)virt_to_phys(track->root);
+	up_read(&track->sem);
+
+	err |=3D fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
+			    &preserved_mem_tree_pa,
+			    sizeof(preserved_mem_tree_pa));
+
 	err |=3D fdt_end_node(root);
 	err |=3D fdt_finish(root);
=20
@@ -1324,16 +1343,26 @@ static __init int kho_out_fdt_setup(void)
=20
 static __init int kho_init(void)
 {
+	struct kho_mem_track *track =3D &kho_out.track;
 	const void *fdt =3D kho_get_fdt();
 	int err =3D 0;
=20
 	if (!kho_enable)
 		return 0;
=20
+	down_write(&track->sem);
+	track->root =3D (struct kho_radix_node *)
+		kzalloc(PAGE_SIZE, GFP_KERNEL);
+	up_write(&track->sem);
+	if (!track->root) {
+		err =3D -ENOMEM;
+		goto err_free_scratch;
+	}
+
 	kho_out.fdt =3D kho_alloc_preserve(PAGE_SIZE);
 	if (IS_ERR(kho_out.fdt)) {
 		err =3D PTR_ERR(kho_out.fdt);
-		goto err_free_scratch;
+		goto err_free_kho_radix_tree_root;
 	}
=20
 	err =3D kho_debugfs_init();
@@ -1379,6 +1408,11 @@ static __init int kho_init(void)
=20
 err_free_fdt:
 	kho_unpreserve_free(kho_out.fdt);
+
+err_free_kho_radix_tree_root:
+	kfree(track->root);
+	track->root =3D NULL;
+
 err_free_scratch:
 	kho_out.fdt =3D NULL;
 	for (int i =3D 0; i < kho_scratch_cnt; i++) {
@@ -1422,7 +1456,7 @@ void __init kho_memory_init(void)
 		kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
=20
-		if (!kho_mem_deserialize(kho_get_fdt()))
+		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys =3D 0;
 	} else {
 		kho_reserve_scratch();
--=20
2.52.0.223.gf5cc29aaa4-goog


