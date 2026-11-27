Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E17606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VcP8S6t8
Received: by kanga.kvack.org (Postfix)
	id 92C206B05B5; Fri, 27 Nov 2026 07:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6916B05B6; Fri, 27 Nov 2026 07:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2D26B05B7; Fri, 27 Nov 2026 07:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F54B6B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:26:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6EFA1402CC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:00 +0000 (UTC)
X-FDA: 85480820880.19.FC89E44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13C44100008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcP8S6t8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782359;
	b=bZ5PQjHxiB2BjaacekRY2CTndDD5j1CTKJ9+4EX3H1CrTvnQGzJaDTF4EsXiUTOsLoiUre
	bT5RYHpqc85to/FDYcgNXuinl08mmPd4zZs5Ae8HaF4U6kewKlRfb2/aM08ynX2eRBKOWz
	xPSMvEVNCq+3sFILCcPJrn99xaCZrik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnIqqYjeXqPPSZa+aej0B5CBul0phvtQ8KiVL9/wl4s=;
	b=33XefKimyo1h4j47Ivr/z1+B24tPP2+vlpCUOITBiLbmaGMWRk4YSz4hXgdAJz8uLF7G+6
	0/MlkL2d/+QlF1NvR4WmY8dkJyCLpTPSMRubW2/yvHwOeLh7FvrLSv9UL98QfMclmX/YIg
	OrKvb2pzQZZ7w41qKp7r6Z6gMc55NKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcP8S6t8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AAB8400E6;
	Fri, 27 Nov 2026 12:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2803A1F00893;
	Fri, 27 Nov 2026 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782357;
	bh=lnIqqYjeXqPPSZa+aej0B5CBul0phvtQ8KiVL9/wl4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcP8S6t8a0tp6B00sALT4aIOpWQUglo7wF22WnppBJbF1JOPU0Og4E4JBeBQ+rJzh
	 7S3t8T9X5nLGPtwsHOR0EeziYdCMzlWHDA+b6S8UnlsANAEm+oxm49MyvpEtDx+JI/
	 /baTB10Dj0E3adVrlQNsW99WZ5ucrpy8M5E79pmVCYWfZu1fn6LBr6TR1mqlqIezJJ
	 gUvKF9mkghKAh7lFok0SAnZtPbuZC3V2jYH7Q11YNFN7X+sDjVrINLjUykcrbMzExW
	 F1LAZcVDyonOjZwQkVYNTAl3SlncjPccHD1zMjEF80FiBM/pc0I4JjE4GWIoYGt8os
	 KfHjKaGkeqmtw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 3/6] kho: move kho_{block,radix_tree}.h into include/linux/kho/
Date: Fri, 27 Nov 2026 12:25:29 +0000
Message-ID: <20261127122536.3708770-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13C44100008
X-Stat-Signature: 4rpdw1xxwh3gbmezaekyk979nk1x8yme
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795782358-850473
X-HE-Meta: U2FsdGVkX1/Jgytn6gl7WRJ77GYRmN6zu9kHh1aomHOxsHIQm4boLStRRqePVswYLe4o/CCKgHg/NaAndx3tNJt+LBEmS1XbkYYCsabu7uIQ2ixLIN3QeYL/gyloF6L4ITKWhH3qaehBbUVW9emhvtDfaxz7Cjd2GUhiMKwFFOnfHB9jBSMbbRkmxwzoTLlPzRDF/php6j08OP9wZgsPboI0sh2/ix9A/obTH40XLSPPshVbmloZeigAnKpjIKUC9apHWLDDwv6OEXa1AutZqIv9vl9D93EjdOxq3goFs/RDoPO8a1/Vgdslv9uWEkpZeMWHeSrn9QSDa192rkV4jA7+GRyW0mQoHS43ZNipZyQio0s6KFBSD5eST2NICnYmnFj+oISX4bJ+fuYa42sw4HmgGPH+Knq7VWa5OkUC3/h59/wmimYn7SuPq9abs3VR1WJlu/Vu89qnO1K2rEPNkilDVlh9wINoZAd5jPfkIrjF5aruKtfJjI+bMjDsfSl8GwBzt85U77B0U5PMAksIHXuIVLxHOmehY3ieC7435EtXYZBSD6ujHKBH05KPUYJ68enSly3L7a8pehc1vvE1iliG4e6to+rOrY5ysOolktArLGKlal6zcSDDpvJCxUurePTFpQaxAyVc+usPm+69wEcUhcSCpeCY5YdMUKg33ZVNdryDMvMSfk+V7un4la8ChVE+QKV4LJIGmQ6B8RrOcdHzeJLvGPgpObwVMUP6RzoNUCZJwBkelBbhMrqGmCB6Uf/4m6TiaX46D2VgYueDIvd6UGpwSq+aXau8hQ2fAHPPlqXFkSnfR0b9fo8127teGzHfOnoNZXM7vXFv1umvvgNqmJpMIFyn2V/c7EuXdlq7HnYVj8yJUm8sVb9NxSR2WXiYSuEBjTn0ZGHdzUfRtFpNSFjSo+VJAM/udFx8r2uhtJpK02Snwj7IbnXUX4Ln/vDk3xXMv5um/Z+wDRZ
 oKL5F94R
 CbCVxT6R6qCPrGHQzU3dR1WktMAEuzhP8S0EQuaEmzg7BhGrHAt8ZuCR4VU8SngFX25TfYkD9EbmJzu7xN+ETdi6yTWYd7HJDJUq9e9mkMr7nxPNPq5+oFVXE9sIRZQJMfuneLG1A6TPHwE5MUCHdv5Yc5P706Yelcf49uQOMSeNo/E+6UIFRFl7AQff9NQSYNDsKk/gcRdWLL0CNQYwnKgqWGipdaDdMMt71/nOumx6p0oMH11U2AymIUUE/pNambscy1roEfmPXXeACa8u2njYBLUvTY0+Ux10+UfReu3SBSwVFn8R4RTMKDwCVviFsUwBDXxUacO8J1kPbJWFzxYJIFfVNsRdU6bgrPnWUgCpNW7umlwTP2c67dUHMP+lC4s4L7zESXQ9nLUF8wDG2ZbR46A6DyYQkCZ23eg0T3By1OQcfbFm/4oFLBOM38RskD8RPqthCI99AyMgct7NsEKxpjIcc8gcBVkcM3NwWLQ3PR83NkYb4c9yxKhHJShWNJMOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hierarchical file systems have been around for a while now. Let's use
them.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/core-api/kho/index.rst                 | 4 ++--
 MAINTAINERS                                          | 1 -
 drivers/pci/liveupdate.c                             | 2 +-
 include/linux/{kho_block.h => kho/block.h}           | 0
 include/linux/{kho_radix_tree.h => kho/radix_tree.h} | 0
 kernel/liveupdate/kho_block.c                        | 2 +-
 kernel/liveupdate/kho_core.c                         | 2 +-
 kernel/liveupdate/luo_internal.h                     | 2 +-
 kernel/liveupdate/luo_session.c                      | 2 +-
 9 files changed, 7 insertions(+), 8 deletions(-)
 rename include/linux/{kho_block.h => kho/block.h} (100%)
 rename include/linux/{kho_radix_tree.h => kho/radix_tree.h} (100%)

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index fc759213ddb9..b09547e10ba2 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -83,7 +83,7 @@ the next KHO, because kexec can overwrite even the original kernel.
 Kexec Handover Radix Tree
 =========================
 
-.. kernel-doc:: include/linux/kho_radix_tree.h
+.. kernel-doc:: include/linux/kho/radix_tree.h
   :doc: Kexec Handover Radix Tree
 
 Public API
@@ -98,7 +98,7 @@ KHO Serialization Blocks API
 .. kernel-doc:: kernel/liveupdate/kho_block.c
   :doc: KHO Serialization Blocks
 
-.. kernel-doc:: include/linux/kho_block.h
+.. kernel-doc:: include/linux/kho/block.h
 
 .. kernel-doc:: kernel/liveupdate/kho_block.c
   :internal:
diff --git a/MAINTAINERS b/MAINTAINERS
index fa9ee8051139..4469f9978ecd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14784,7 +14784,6 @@ F:	Documentation/core-api/kho/*
 F:	include/asm-generic/kexec_handover.h
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
-F:	include/linux/kho_block.h
 F:	kernel/liveupdate/kho_*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 76e939ea52eb..d99d2eb4e2ad 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -207,7 +207,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/pci.h>
-#include <linux/kho_block.h>
+#include <linux/kho/block.h>
 #include <linux/liveupdate.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
diff --git a/include/linux/kho_block.h b/include/linux/kho/block.h
similarity index 100%
rename from include/linux/kho_block.h
rename to include/linux/kho/block.h
diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho/radix_tree.h
similarity index 100%
rename from include/linux/kho_radix_tree.h
rename to include/linux/kho/radix_tree.h
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..6cedcd36bfd2 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -23,7 +23,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/block.h>
-#include <linux/kho_block.h>
+#include <linux/kho/block.h>
 #include <linux/slab.h>
 
 /*
diff --git a/kernel/liveupdate/kho_core.c b/kernel/liveupdate/kho_core.c
index 7544bc0b99e5..3f9d408b9d29 100644
--- a/kernel/liveupdate/kho_core.c
+++ b/kernel/liveupdate/kho_core.c
@@ -18,7 +18,7 @@
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
-#include <linux/kho_radix_tree.h>
+#include <linux/kho/radix_tree.h>
 #include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/kho/abi/kexec_metadata.h>
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..6c034be2d390 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -10,7 +10,7 @@
 
 #include <linux/liveupdate.h>
 #include <linux/uaccess.h>
-#include <linux/kho_block.h>
+#include <linux/kho/block.h>
 
 struct luo_ucmd {
 	void __user *ubuffer;
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f1b86f701238..1ed914db513d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -90,7 +90,7 @@
 #include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
-#include <linux/kho_block.h>
+#include <linux/kho/block.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
-- 
2.56.1.839.g22a8290db9-goog


