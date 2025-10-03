Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F62ACCA472
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBC48E0008; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B7E8E0005; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EB48E0008; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E39488E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99C555B93A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:49 +0000 (UTC)
X-FDA: 83957498058.23.A4BD181
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id CEFED120007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fZIWWSSK;
	spf=pass (imf29.hostedemail.com: domain of 3vgjgaAgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vgjgaAgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH+wdcZ5EVKOe0qHDw87x4CzKKpCZFkdrN8PVNJB6b4=;
	b=EbLSv6SPOb0pFppgxLqhLqfuF4dYT1kuyciG5bYoZzcYuQ4DDuonQ1ox7CHCVGEqDl3z5+
	yizLBRQ0mhYgdLTo47G+y6bL8ux7tBwwh9ZeNx3bIQxsVYL7AvhhRM/IfMlrLSH98sz+bx
	XUNK2qn8j5LbDwpl/JRBJ0BpY/0xxQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512767; a=rsa-sha256;
	cv=none;
	b=nHlzPuOmtWYGEhvktvl0pmHhk5Cm5BiyF7YgDFNuUNqi6boG7KqI4M33HbnyY2gQRRsMKG
	5tWgAwt+B2RO2fWsuvCX6RZ//FGbjL3bfmaXTbzq+IMtBiY8IQCN/URbgNuOFukqX2eZW1
	N5ZEGcqhLZ2ndpwGQ4d4GRJQq18lSe8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fZIWWSSK;
	spf=pass (imf29.hostedemail.com: domain of 3vgjgaAgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vgjgaAgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e39567579so13862875e9.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759512766; x=1760117566; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zH+wdcZ5EVKOe0qHDw87x4CzKKpCZFkdrN8PVNJB6b4=;
        b=fZIWWSSKMW0bwG2HF3vcA7255vetoU8y2JQyqsKMZhQCAsY6BnFa+A0Y3RnkfBlWsh
         y28WRLRU0+Tg7HdI1D8zElEwC/5nEZU6oQOIhaJcYfYXQN1Aoh7hBuySpt01bj2+gqOD
         FcXv3m5b57ajhWcNctm74VXtnFFpJl1xmRNd0jcr7MAMM3Fh2K2lI92L/cpb+2Q28gKv
         BMP4fyV8tNdBxhq00h3HmuKddkZ+hJVI9XVhalcY+GwY1rlhHEonFHxrQBOii1WJ6uiy
         gqjgqwD6eYC9PPOvasTtTgHJc4OEubQ0I1XbPJj3pXqne+rVdwZmP+Qv8ssBi9fQP5E7
         Ogkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512766; x=1760117566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zH+wdcZ5EVKOe0qHDw87x4CzKKpCZFkdrN8PVNJB6b4=;
        b=ZUR5o95PkY+PKRgOC+uh4KhsThOiJtY6qA7mnhR+POZt8/CgVFmP0NTUIvM0zN6sAF
         JRGhDmCQa9mPf8N2wFHfENQA5bpqFgSnQucGORs3vagAxgm9aY6RelPr4YyeApXOUkmD
         gT3t1nB35GtWvMrkCcvjCAShGc5Q1TsM+vaU7nKMrxmCLeDjSvNw3QdolKEJ31AEJ0Tm
         sF88MaFFwu7euexKc4ewHn0v4ZDQRNWKFXXqDKiiqdFlXCIGEEzl+4XmEuMqKDTJNTvH
         jw2f8sUpXKgRU8Aletj/uFDUb8WMeHGoqoosVcD944C8xbM1mEWylZ8FFN0n/TufIw4Q
         PEOw==
X-Gm-Message-State: AOJu0YyJ11D3uV9Z7M9U9NxVJDs2zkb2SLozQUcFV1NWQt/af24M7JEz
	MkjrBI91a6KoZSYEe44lC49GMLlQcNGosoTeBVWBEhT2ouKS88uWbrn6htyeEeIPfpvJWXXQMrl
	fQnNqAOuflYYp+O299Yd7eeQsdvQVizcBUUC7AR13jvXnr0MoFesPej3K7t7WJZmgcYv5D3d3IG
	fKMI3kkX+/O/3bXgyTRjhLottckb+yMXXpEpMl6PWUcA==
X-Google-Smtp-Source: AGHT+IGYvWG9xmF2kfRie55mVv+1GfRjdSpkjQnJcV3+O9KPqIxqc19jwTdv3Ui/FR4E11nQtZ5ZDpq1J3nuCg==
X-Received: from wmbz22.prod.google.com ([2002:a05:600c:c096:b0:46e:6a75:2910])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a343:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e71144103mr28980925e9.24.1759512766152;
 Fri, 03 Oct 2025 10:32:46 -0700 (PDT)
Date: Fri,  3 Oct 2025 17:32:26 +0000
In-Reply-To: <20251003173229.1533640-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251003173229.1533640-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003173229.1533640-2-smostafa@google.com>
Subject: [RFC PATCH 1/4] drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: z453f5nm3h74i81wqdm5194r9zhefg3h
X-Rspam-User: 
X-Rspamd-Queue-Id: CEFED120007
X-Rspamd-Server: rspam10
X-HE-Tag: 1759512767-787377
X-HE-Meta: U2FsdGVkX1+oBgPrt+bAbJlQ3SeIKEut2d8yjVjZQkm1hKmDqHHNcPxw/Dc69i8SNVRUp2A0P9Nzi7iHsv556l/d30mOjPEp+2hnxFgKBsVelCAZkGQqN0wkTvKmHFIkAlYZR1/vnh4GauQXXxQv8yH+qw7N7371s5Z1DIRQY66CPhiROeSVAuaEnCJ9KHEV56fOuLCcxorqEnoJTfaODCISqGb+rS+zNJY7TmCwL5CaV2g/SoQ5b5CLtBnw1oNaO/yBdSeQK8YX/r8zsyWwTQ+N6jlKAnbzJId0h3Ar/Czx+y9bMhhSHRPdCCoRHMi+mBFqu81RP6S+oust7TnVuPrZgjSNhArghWh7TyNQHuM8RzUR772vcdtiIy8ud+MdkLzZjblf1fQqR304O5gCPTCpBtZO3rkbC3fqt4WiXIw/FKgXAsEquXlNaYpSfbsZX7+PeHajE5oHdUso30ZiWXeUjDpNOVrpxHft/ZcQT+xvfddVOi3kGxvadgiZfkNj7CTTUfjc5l3oskcus5/KFNwNj2SNjBBJUCNRzO33XlT5x4fz9ysBpdWV8mj+1mkm0uEApRuJOXU+VW6ni55rki9L4/R8lURAl3L/NM7USu5hKoCbMtPN1tnop0tOZLWsdvMqw/uyYbMGyiyMRRHbbx3ST105aOre6k1AHCEk4floWi8G+DOTE+ut0c76xskPcK3DUGJaRMdKGQ9/18Bn/1wO8BclMJNO0vmThUPiiJt6JOVulaiXAHu4eR0Eoomn3ScNXP7GEZwAiM9VPYpl7TcEQaYiiALPE0/gsBHiEgRvKpM7ih9fIwdIpxd+J2Ons8jsXE/gm7uRs44dWvSvtbfsmbmDuNO7rmrc1Q61t6iF6xUYMEgRrGAxnPweObZJWQpY1h29w8Ill7oRIRH+/9dfqN/tMaak+Z8xGcTkVdr3MEWBJ5dauRYB1T6XwtDosaMtNpeW5bozus/ZSW8
 OFHUhRZv
 6qfxMAu/3ub8OYFh18WlLKTMGEqn94dvWsFlx9dkKvTznL4IRU+BycafwjM3zzSkRonysl8sGKKfESjbMVELLzoW1g/DBL8Qq4R51z1Fft0ubBsXirmSRnm+0ANUpSn2Sym1sbwIRwU6TopyJqhV4WWccy+Bj1B1f3nbFUpmS327fHCliv7Q4xVP/EsoaPGzNap/jdpg9ScSlTqZKrFQO/vAyYW5PMBdmgqNjxKeLeb9+yuypoEl4fAf+zmqeIpRLD7Zha3toYXUuG2i2csv01D4qGSKnwrSndbkXccmHh6+gprXASP6WD4KkUDsrz4YEXoNFr6m5szj47G+XbRNLwUS5EnSAxIxNtEaEi2mlR74OvEQz+GLmmeVu+EHy86HYBc0Q+SNKmZkadWNiPQM7RAT3KOUsPn+hNZx8Hl7tt869c5dSbHBW8OyySqoyxV8CZoudKVrVxn1Fp+hUTZJtNe++0SNHSe82WUuMWSfRTq4XtE1Nx9jWJRWrJfHPxKQWzE9EUUKeRIu2hv2NsHp7SRoW5DT3ltEundhOeVkrlRudPsrHg1S7DfIsPUB44w3N6U66eGbo3wIj9ZpioD7EkJpnG/sP5YvrtfUYI/7UuhPRwFU+Phnb6t9xAgmgiBZ2TplHdO+Pspnd/HRnKpQwBCf+XhTznmbUQS1DbZzehFUAXlDzulJvPz2GBWMavcLmfCCLFJRJZE5167v2rkqC0w+iuIc7pofRoKgvtgQicRRDjI+9wj7SRHUN71xggsCjiqOP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
page_ext.
This config will be used by the IOMMU API to track pages mapped in
the IOMMU to catch drivers trying to free kernel memory that they
still map in their domains, causing all types of memory corruption.
This behaviour is disabled by default and can be enabled using
kernel cmdline iommu.debug_pagealloc.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 ++++
 drivers/iommu/Kconfig                         | 14 ++++++++
 drivers/iommu/Makefile                        |  1 +
 drivers/iommu/iommu-debug.c                   | 32 +++++++++++++++++++
 include/linux/iommu-debug.h                   | 17 ++++++++++
 mm/page_ext.c                                 |  4 +++
 6 files changed, 74 insertions(+)
 create mode 100644 drivers/iommu/iommu-debug.c
 create mode 100644 include/linux/iommu-debug.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 74ca438d2d6d..b2691a5527dd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2539,6 +2539,12 @@
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	iommu.debug_pagealloc=
+			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. By default, it
+			is disabled and the system will work mostly the same as a
+			kernel built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 70d29b14d851..5b40ec9b6e04 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -383,4 +383,18 @@ config SPRD_IOMMU
 
 	  Say Y here if you want to use the multimedia devices listed above.
 
+config IOMMU_DEBUG_PAGEALLOC
+	bool "Debug page memory allocations against IOMMU"
+	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
+	help
+		This config checks when a page is freed by the kernel
+		it's not mapped in any IOMMU domain. It can help with
+		debugging use-after-free from driver doing DMA.
+		This santaizer can have false-negative cases where some
+		problems won't be detected.
+		Expect overhead when enabling this + enabling the kernel
+		command line iommu.debug_pagealloc.
+
+		If unsure, say N here.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 355294fa9033..c834d3f70dfc 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
 obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
 obj-$(CONFIG_APPLE_DART) += apple-dart.o
+obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) += iommu-debug.o
\ No newline at end of file
diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
new file mode 100644
index 000000000000..297a35137b38
--- /dev/null
+++ b/drivers/iommu/iommu-debug.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API santaizers and debug
+ */
+#include <linux/atomic.h>
+#include <linux/iommu-debug.h>
+#include <linux/kernel.h>
+#include <linux/page_ext.h>
+
+static bool needed;
+
+struct iommu_debug_metadate {
+	atomic_t ref;
+};
+
+static __init bool need_iommu_debug(void)
+{
+	return needed;
+}
+
+struct page_ext_operations page_iommu_debug_ops = {
+	.size = sizeof(struct iommu_debug_metadate),
+	.need = need_iommu_debug,
+};
+
+static int __init iommu_debug_pagealloc(char *str)
+{
+	return kstrtobool(str, &needed);
+}
+early_param("iommu.debug_pagealloc", iommu_debug_pagealloc);
diff --git a/include/linux/iommu-debug.h b/include/linux/iommu-debug.h
new file mode 100644
index 000000000000..a9c11855c4ed
--- /dev/null
+++ b/include/linux/iommu-debug.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API santaizers and debug
+ */
+
+#ifndef __LINUX_IOMMU_DEBUG_H
+#define __LINUX_IOMMU_DEBUG_H
+
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+
+extern struct page_ext_operations page_iommu_debug_ops;
+
+#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
+
+#endif /* __LINUX_IOMMU_DEBUG_H */
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d7396a8970e5..37c764a55a0f 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -11,6 +11,7 @@
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/iommu-debug.h>
 
 /*
  * struct page extension
@@ -89,6 +90,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	&page_iommu_debug_ops,
+#endif
 };
 
 unsigned long page_ext_size;
-- 
2.51.0.618.g983fd99d29-goog


