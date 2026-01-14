Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EC0D38FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16416B008C; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F456B0092; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7606B0093; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDB6E6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85DFF1A0587
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:35 +0000 (UTC)
X-FDA: 84331140390.24.F951E5C
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id B593B4000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GStNzUqz;
	spf=pass (imf11.hostedemail.com: domain of 3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B7vkHmo1gB7yzDxYR9VV+0wyuHcnCvbFYocb2WwDHM=;
	b=CtAeXt6pTnHgZLAw4sN2dhhIXQaSKK3gggTya2TmttGAOvx6wZ91K8dW5O7sxKEQVayqzO
	XRQslT4rQ/blAD4Lfg1X1i592U7IdAeZKV557wvC0wlVb3prZYZbzVfPWN0U5NjS5/QNJm
	+MSviC1xJEw5UHPnKbGZapUUvTUjrV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409013; a=rsa-sha256;
	cv=none;
	b=vAn6f6QyhOdoWiMXOmFwsnCAAZSRRgsuuXAibk+ucx2m20037pI6FqFcetcUgNfKxW/w/b
	/fnL4CUqihkYBz+NvuECqcMXv3orinmapJsvlmVP1d3xCpZ7Xah+677B5Xuew98LlM0lBI
	R3o4mGBQMuAqOInJEIDjQZLchULkBSU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GStNzUqz;
	spf=pass (imf11.hostedemail.com: domain of 3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b870f354682so4075666b.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409012; x=1769013812; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7B7vkHmo1gB7yzDxYR9VV+0wyuHcnCvbFYocb2WwDHM=;
        b=GStNzUqzhT2++2ytK8RykJT3Ias9uJJOelYXOWnLtM1sysO0SMxtj46xonOqPQ/imk
         qWoseEaj73/IJzbpcf7H68siOHoZZ9mGdqz7rWNgxKCypyw8aEqw86nDrIVRv8AhZbKA
         kK2+SPGEUFZtexroXAmZXQDNuhLyq4zL8ieoQdzFFk10sMCs9LL0Nq2/wXNtvf94ATC3
         1ZnfVXWfmgLKEly+MKWs+8XBEfoxWArE2Bji1h/r7Ag4C2yWrfeIXoeq4fVDyejqQew4
         17dI+MSzjeFCaGjEl/fdNDBNzS5uib/+4iwNHSVoIkKaEROsMAcW52joBC6QHYlRPPkY
         Ik5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409012; x=1769013812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7B7vkHmo1gB7yzDxYR9VV+0wyuHcnCvbFYocb2WwDHM=;
        b=UYVmayZwnJEIiZjFoWBhEULjwfL+MEuzkq6c5QQ6ESmWJcGZxaFAWC1aLqXfRgZp13
         VF7yTK7sk7MIE45pKVdrRJXzZutLC9MXdtPnhplfCKU3u4LGZNlpSzvrHHM/ERaVTO3e
         r4hj59O7ozk18EBUTZLxNR2XEZsWVIl202jNrN4xIuH08nqXMTo3ccK9M6F0Fb4Jy97T
         oTN0ab/XGYPwL4d9fIR9TByh4helz43s7sLo7iEGlvc+ev+W2dYaZJjQ/ms+obVQggIH
         ge+CAwr4konsa+e41gd3LmwqHrXJdqzxD+QtBo9/u4KEr+1QhwnxpIg3afimLb6+4pRz
         tpzg==
X-Gm-Message-State: AOJu0Ywi2LE59ag2kHGrPXlIFC2Z8XoLXwinz6KD72dnzpWMOcT0i4lH
	Jo+1iImIN1toWzRlO3vjLe/EifCzKoDW+FefLhn8qOffQZs2D03+pYSTj/87xw0QwVpF7sEthRR
	9AwwdWzRowIQBrfsDwLcgF0tYvOrJk5IosMW+2q0EREw8eekLgXPEBWrZfmj0GZrOZqR9/E/Gmp
	5OZrvYkjSXaQIra7yQLS4UvfzDD4Mg/C/rSM0P2CNhCg==
X-Received: from ejcfj22.prod.google.com ([2002:a17:906:9c96:b0:b83:23f7:8971])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6a1c:b0:b80:149b:badd with SMTP id a640c23a62f3a-b87612a48a9mr267326266b.37.1768409011939;
 Wed, 14 Jan 2026 08:43:31 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:19 +0000
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-3-smostafa@google.com>
Subject: [PATCH v7 2/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B593B4000D
X-Rspam-User: 
X-Stat-Signature: 8qm7qt183c5cf3kdm4sw9ogp4673fm9u
X-HE-Tag: 1768409013-880759
X-HE-Meta: U2FsdGVkX188+/Ka4my3lkLhcA3OyCquzmZXg7/y4atVJcMaMIv8f4vQgEkmoEE1Xz2uoStpMSoabuRV5t6zmYf3lPGwn8N9PGfpeCvLey5zgHfM9HtPXnEgALuiDmbNoopiSLU1mRn2/Bs4fjncoaLZbEW5hfdwj0aK6+gx4WEnv2ELDx3dLPhtxcO2tfiUf+9aI7880e+5CFA7+ediqx4tFxnSL7YEEVi0XMm6p1VEvmxyq8BEwqEShbaN3mjQ7CUZ/ofI8anYth/CJ1gna73f4pWEVJ7Hvpi1ZKidrazYvJCqGWHqqxE2kg2eHY0/XvzqIDPP5JTweUU8ugy+CkUU/sjkPlxUwY8U3BwGVs0ws+TVNPE7Q6RFedKPEMz+PvVHpvY6EmAvlYhHtth73O/mTdGyeNrrcwZIcGwTyTJTauCPbIJxbLCc4ZGI2npvojbkIWmJn+XLMlb/r3YTf2eohPcyYzhf8ZOo3lYMiohYyAFtF7NlB59BT3cLGylXkEGLHDc+0QPamGAqOviAT25Q53jZwGE6qDLHmwZTEC++Pl7GOS+SDhN7Qf4HODvD1Kb3qRZa40T9WP5qPz37iO5xjhRhh4/5aeqr1tRMUg/cKSMJ4QI+psWNGQflMC0bY2YoJsO6tM3vQsPwaiHsujBIZM+QdfeliuocXvNwMKQLv0UlcjAvQ5fH8bfuhtjJXzRjCej9gyCViyCMlqhCNJMF/c1yJdNekdMrZyrOcYp3dSYUk4+nZv+HSz6RKjYQ6BTqG5inQG1nVtXUwh1XNdaYipZkJcp+rbVKPjGKZjY6BcuwpQQ30Li3tsPHYF6dclhtzNNaHS+praG2jpGmdeT9ZZ3N97ANXDS1KtxDUBVYptNGEiZtcD8eMBFkorxLbu9e/z3Tu9b3nOgjoIJuXPklhqGbkjwppQ+U92Y65+1rtIv1WicKMD5RJamvfhH0LSNN+XijJ1jezmzo2Mz
 0pgCnb+o
 D/rz+3HuLwKJH37BpAMxEDiHAp4L5EQJA0zxQAvDG6Y29NpHEFXEk9IOI6FI9qRr76VVRZ/WqE8gxpO2O5RJeE6ZV0LJllxY9kgiVTdm0KWS+nSD7TOTYuj8kQueVa5McMaELCGVaXaQOE0CwIO0coMSFtV4clqXkivJIQIm2wJ0lWiSOCci/efR8Dz4oRWjNchJXn4/5sT6hJFMgNB88evO/pmkoAssZCbjG2Fxzb1X30PdiMYRQ2CdhI/KxT4DCHpyUEnz9Aa/UCICBgriTrXsLORAgjERnIzUr1yGgT6JF1RXQmJ11Y82/br1t+h/i2YEjUTEumiIjEopytrupM9BjNMmlMGtnjVVKDWIU0Q2hJNA6K0SC5T+o10OniB9JNmak5LNeQ87VNgrovL2DwYFFcdohfim/WIO6PDR9Z48k85BB9M4S2CHHFlSBU+juSMRNB2AkKQZ2AxoJrBrAsDtGUcP+66GFGDMXAJOoISRj3TwLp1vD8FiNX0l6L67yzABwM9+/fEEIWN6itil/gP1lnTLunE5PlkGjwH8szQuCnG4NQ3mE+TaMlUnHiUi8s/4lQUayBu1hpwMc1rtSkN3XJrJLfUvTS3RWLhkrTa5vVYZrV5HY8ayYqWFT0hSD7D1ulgEthAHTHELiT6DNLzOyEX51136soGno/w+o/JKxsV1az+/mOajwV3zYa1MAfvHn9ZM0xl3H9b5amCtQAFC4JzYknv6lKnesPeO3SglQRps=
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

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  9 ++++++
 drivers/iommu/Kconfig                         | 19 +++++++++++
 drivers/iommu/Makefile                        |  1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
 mm/page_ext.c                                 |  4 +++
 6 files changed, 82 insertions(+)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..d484d9d8d0a4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2675,6 +2675,15 @@ Kernel parameters
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	iommu.debug_pagealloc=
+			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. By default, it
+			is disabled and the system behaves the same way as a kernel
+			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
+			Format: { "0" | "1" }
+			0 - Sanitizer disabled.
+			1 - Sanitizer enabled, expect runtime overhead.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 99095645134f..f86262b11416 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -384,6 +384,25 @@ config SPRD_IOMMU
 
 	  Say Y here if you want to use the multimedia devices listed above.
 
+config IOMMU_DEBUG_PAGEALLOC
+	bool "Debug IOMMU mappings against page allocations"
+	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
+	help
+	  This enables a consistency check between the kernel page allocator and
+	  the IOMMU subsystem. It verifies that pages being allocated or freed
+	  are not currently mapped in any IOMMU domain.
+
+	  This helps detect DMA use-after-free bugs where a driver frees a page
+	  but forgets to unmap it from the IOMMU, potentially allowing a device
+	  to overwrite memory that the kernel has repurposed.
+
+	  These checks are best-effort and may not detect all problems.
+
+	  Due to performance overhead, this feature is disabled by default.
+	  You must enable "iommu.debug_pagealloc" from the kernel command
+	  line to activate the runtime checks.
+
+	  If unsure, say N.
 endif # IOMMU_SUPPORT
 
 source "drivers/iommu/generic_pt/Kconfig"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 8e8843316c4b..0275821f4ef9 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
 obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
 obj-$(CONFIG_APPLE_DART) += apple-dart.o
+obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) += iommu-debug-pagealloc.o
diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
new file mode 100644
index 000000000000..4022e9af7f27
--- /dev/null
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API debug page alloc sanitizer
+ */
+#include <linux/atomic.h>
+#include <linux/iommu-debug-pagealloc.h>
+#include <linux/kernel.h>
+#include <linux/page_ext.h>
+
+static bool needed;
+
+struct iommu_debug_metadata {
+	atomic_t ref;
+};
+
+static __init bool need_iommu_debug(void)
+{
+	return needed;
+}
+
+struct page_ext_operations page_iommu_debug_ops = {
+	.size = sizeof(struct iommu_debug_metadata),
+	.need = need_iommu_debug,
+};
+
+static int __init iommu_debug_pagealloc(char *str)
+{
+	return kstrtobool(str, &needed);
+}
+early_param("iommu.debug_pagealloc", iommu_debug_pagealloc);
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
new file mode 100644
index 000000000000..83e64d70bf6c
--- /dev/null
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API debug page alloc sanitizer
+ */
+
+#ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
+#define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
+
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+
+extern struct page_ext_operations page_iommu_debug_ops;
+
+#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
+
+#endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 95e8c40131b7..5fe65a0ac4f3 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -11,6 +11,7 @@
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/iommu-debug-pagealloc.h>
 
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
2.52.0.457.g6b5491de43-goog


