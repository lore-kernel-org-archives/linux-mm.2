Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D910F606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUT5wQXu
Received: by kanga.kvack.org (Postfix)
	id 61ED56B05B4; Fri, 27 Nov 2026 07:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9106B05B5; Fri, 27 Nov 2026 07:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF126B05B6; Fri, 27 Nov 2026 07:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B65A76B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:25:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A9A0C02A0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:57 +0000 (UTC)
X-FDA: 85480820754.02.35C8935
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FEC88000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUT5wQXu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782355;
	b=Bt+QjSwe6yL0nsz6X+HapARM7vOap1V0uufnv6LFaf+gD2FWKgfAMP9uDX7I+iduq9UG4U
	yV+HOkENexKcZT+oU8K0XaNGh88rZZgoyD99WtatQ+Xxy5zVZOxiGmxA4rGZsICxJJt3Qu
	MXA8BN35oN9oXxkgnlTkJxtsHuLPzv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3hHPVqXQnPXwpisRritcflbPwRRd0Bc6Ld600N+Z20=;
	b=aOLzp1SP7DMGaARaNUaNIC3FX1b+ZC+F+Ngio5MCBxj2Hg0BArXy3MbcCAizTYaKwZlnQ0
	JrLu3brtG+weuo0cIxQNMeERaSL2H19DWGHVPdLsIiT3f8IqHyww8I3JquGQKH7ouPn9Ei
	bVgEwiovIDp5EXMWc/iGs8xgK5N1ymE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUT5wQXu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59A3943E81;
	Fri, 27 Nov 2026 12:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544A81F00893;
	Fri, 27 Nov 2026 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782354;
	bh=W3hHPVqXQnPXwpisRritcflbPwRRd0Bc6Ld600N+Z20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUT5wQXuJLFF/rapm0BbPsLoSB/rzTcBEjV7Z9IrXf3u2vP1cVKN/8V4Dao8lX2cE
	 dQMTnYjaGi9+oBqRna07DX+7a2tcXGuQ5JmcNErlfKJwoBo9xsljPeEqkXzmv42pXB
	 +aSB3MQGp/OZrjDF3uZ/6HUaXMCRx+tHvDHFOmopfsqMGGh953Y4pfC+TKPyGvFSCZ
	 g7h30mPpbZ70DUUhPvtsFkqMQSIA0dltk6fFeDWUZmwjG6g7KnULViokkGykYijrjE
	 GxIX+z4/0Qkbp3hEGcgwj5V0jNVUaQcEtNu53UpU89C3ZEr1rAQhmf44Wnf6q8Rdx5
	 DDFyTbXw4OqUQ==
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
Subject: [PATCH 2/6] kho: use acronym for KHO .c files
Date: Fri, 27 Nov 2026 12:25:28 +0000
Message-ID: <20261127122536.3708770-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 1o7sqe9ogtja4jjoczm3ru75bfd18du5
X-Rspamd-Queue-Id: 7FEC88000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795782355-166693
X-HE-Meta: U2FsdGVkX18vbu5d/K9zADc7vqOBgsNC3thNUDc/cjf/CWyhuyhLE5ZqgloxLPmsWNATbHkK3s60B5HreVkkCwwNh3koj7t6YLbSNmYbe8eQkFP2JsJkRsQ7GEDIx5tVKpbR2tltBy8XxkL9BsC7s56LWkJH//nL2soIfumMh2NwzyOlEQV9gt12n0uOAbA8ruNq8jWtLjFOq3zRHldyu3Atq+d3CfUcdpa1mXSLMFVjnYqLEx6LsgL+ATlpLfG3B7+iJLisX58SrpWqqBOHBRHTGzIgQnaYGtHX2r22GPTXl9WRlsYWIEtJVo5/qdbVxqSWA0edUFDwkrHfh2iAhuU59ZcWMJ5LnAHDQ9AWr7IwLyKPBtEXdMh+a3ilbORz/5g7l2zFLwebKBZqZ5lf0l2eU0hY2p6U2FhJQPs9A9wTD36XIfReYr43N1ogNJ8yfZBv5HUeUWfRAdnD/bIfxaVvE9wfHrKb2349lqdnkZJ84EjctbQrJy/sslzBWaiQGAHkU1zq4UE2G0LRd++Vfas+tuVbXCZMrHIKwP4MgeSdKDTlxGBZf2MTGu7yy6XJwG/sE7ec5O+oMiSSZLG57isDZywBXYcuDLkujP4qCfPCC1Gk8Tp3jl3BBjwTUxqukYr3kopbyeANJT6iSJrwU/HNdA2YC1iVtLNMGfEEPKTbC+M5l1AfyLnEvC1kM340xldSL+2sH+3XlzV/48P1lU39h1r3PWxza6DvyKPnkd/RHsTYc3saN2UMgh+hmYdu6HrDmFzGLJyLqYLJ2ztKcFkN3llj3vEa5jg99D9/pHGW6zxfBmKzMCor5TMl3yzVVuqJjSt8j2jOs69YfJgMul03y4giTGVkKzspWNrFVjB0rZ2BYIe9upxEdvtkz9Joi5Fnvub/ZkoovPtv9ChpjJEKaifeZFtO6nxcKzlRXA1VBqgpJM2046CHggiCn980aVP1aymABXjAS2j/Fp7
 tFoWLzoc
 Z+W62EvW96i2YJgzp4yPZ700SloQdzVqHKdiMQ1E3C1O0ra/X0DyE58iY9JkJ3FRXX7GMHT6zs9nGSKtigyH7bIaCKJhgtDx1IZo/UqYjqGvYOjTvxGjoIYAW9cKL5FjjGEj+HQeShluLtoi6pXSRmHpiBXUZHyatxy9EDIwIbtKjxGkOe8Wj0tLb4hO59GlUFuSNU7eaWJMvInBQWmfxcOhNI4+2N//eOiG4OxsrnRquOl4xfgagZWDtjt6GJCCsxStVPO+3c9pBVKNvPgv7ZXEsXzwKSeQHsPQrpxtKPG5w7Y1MITpSystgf3fcxjEe4UsJKFVuLlVplpA8WUjPtk4cEUQNEmeZkt3brdG1Q/mdUkV6wN22HPEHmarjtUT4iylGnjngoQNLL9ZrtaNuQ3v90DDvwdvNbSZGcxov/7AzRnrmOlLi4IbHJjP9QoF8iSszHh4G+8/pGch3xSbkVp7eKDFy33n/Y+1LuZRPfgIpyKUBMEB/84nBEXLlhMhW3Ugb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

KHO started its life in kernel/. At the time, its name matched the
pattern of other kexec files like kexec_core.c or kexec_file.c.

Commit 48a1b2321d76 ("liveupdate: kho: move to kernel/liveupdate") moved
into liveupdate/. Files in liveupdate/ use acronyms like luo_core.c,
mainly because the wider context is already available in the directory
name.

Save some keystrokes and rename the kexec_handover_* files to kho_*.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/core-api/kho/index.rst                        | 2 +-
 MAINTAINERS                                                 | 2 +-
 kernel/liveupdate/Makefile                                  | 4 ++--
 kernel/liveupdate/{kexec_handover.c => kho_core.c}          | 4 ++--
 .../liveupdate/{kexec_handover_debugfs.c => kho_debugfs.c}  | 4 ++--
 .../{kexec_handover_internal.h => kho_internal.h}           | 6 +++---
 kernel/liveupdate/luo_core.c                                | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)
 rename kernel/liveupdate/{kexec_handover.c => kho_core.c} (99%)
 rename kernel/liveupdate/{kexec_handover_debugfs.c => kho_debugfs.c} (97%)
 rename kernel/liveupdate/{kexec_handover_internal.h => kho_internal.h} (91%)

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index ce2bf9cf6651..fc759213ddb9 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -89,7 +89,7 @@ Kexec Handover Radix Tree
 Public API
 ==========
 
-.. kernel-doc:: kernel/liveupdate/kexec_handover.c
+.. kernel-doc:: kernel/liveupdate/kho_core.c
   :export:
 
 KHO Serialization Blocks API
diff --git a/MAINTAINERS b/MAINTAINERS
index a946fbbd74f0..fa9ee8051139 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14785,7 +14785,7 @@ F:	include/asm-generic/kexec_handover.h
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
 F:	include/linux/kho_block.h
-F:	kernel/liveupdate/kexec_handover*
+F:	kernel/liveupdate/kho_*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
 
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index bc679905ce3f..b73e19587f7f 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
 kho-y :=								\
-		kexec_handover.o				\
+		kho_core.o					\
 		kho_block.o
 
-kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
+kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kho_debugfs.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kho_core.c
similarity index 99%
rename from kernel/liveupdate/kexec_handover.c
rename to kernel/liveupdate/kho_core.c
index 38e65d210cb9..7544bc0b99e5 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kho_core.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * kexec_handover.c - kexec handover metadata processing
+ * kho_core.c - kexec handover metadata processing
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
@@ -39,7 +39,7 @@
 #include "../../mm/mm_init.h"
 #include "../../mm/vmalloc.h"
 #include "../kexec_internal.h"
-#include "kexec_handover_internal.h"
+#include "kho_internal.h"
 
 /*
  * This is the minimal alignment required by deferred struct page init.
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kho_debugfs.c
similarity index 97%
rename from kernel/liveupdate/kexec_handover_debugfs.c
rename to kernel/liveupdate/kho_debugfs.c
index 3a91c47ad7a6..8d04368c1978 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kho_debugfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * kexec_handover_debugfs.c - kexec handover debugfs interfaces
+ * kho_debugfs.c - kexec handover debugfs interfaces
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
@@ -13,7 +13,7 @@
 #include <linux/libfdt.h>
 #include <linux/mm.h>
 #include <linux/kho/abi/kexec_handover.h>
-#include "kexec_handover_internal.h"
+#include "kho_internal.h"
 
 static struct dentry *debugfs_root;
 
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kho_internal.h
similarity index 91%
rename from kernel/liveupdate/kexec_handover_internal.h
rename to kernel/liveupdate/kho_internal.h
index e9685e1ef6d7..5b349f451cf6 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kho_internal.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
-#define LINUX_KEXEC_HANDOVER_INTERNAL_H
+#ifndef LINUX_KHO_INTERNAL_H
+#define LINUX_KHO_INTERNAL_H
 
 #include <linux/kexec_handover.h>
 #include <linux/list.h>
@@ -41,4 +41,4 @@ static inline void kho_debugfs_blob_remove(struct kho_debugfs *dbg,
 					   void *blob) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
-#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
+#endif /* LINUX_KHO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..a9215eca9e7e 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -61,7 +61,7 @@
 #include <linux/sizes.h>
 #include <linux/string.h>
 
-#include "kexec_handover_internal.h"
+#include "kho_internal.h"
 #include "luo_internal.h"
 
 static struct {
-- 
2.56.1.839.g22a8290db9-goog


