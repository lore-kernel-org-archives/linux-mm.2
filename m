Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DC6CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925296B0171; Fri,  8 May 2026 11:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC296B0173; Fri,  8 May 2026 11:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAFB6B0174; Fri,  8 May 2026 11:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB6D6B0171
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:01:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11DE088C4C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:34 +0000 (UTC)
X-FDA: 84744566508.25.537A989
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A50840023
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XS7u0zHY;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsM3MZHPJG4jSqIS5oTV4ZYkVaqZoomzaAcAboB87ak=;
	b=mELkeQj8YBmZPY/UVjpCXPmhlro8Br0C//XI8wB6gpQ+BC4VZ2LRMrp4D65cZwz+8tLQBT
	ka9yKovxFzLizaX9r2BUnTMr0817WEyY+2aczzeESsiaKWZzILvcjbzKTJQI2xr5wegGkC
	g5TrItvwZOTfvfA1xdYdXJ1JCINuqe8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XS7u0zHY;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252492; a=rsa-sha256;
	cv=none;
	b=8pFUsy5DMq+yQuORDLEeWJpO+ba1ODJrN0xJe9aqaQrX0UJlxALowSWgWCbSaQ+V8lDlZU
	TWtDsJ0Bvesl0tJnHFgtK8Xdvh0MhRRgCWUpOMN5z8sZwv158x9L64+kWoNX2+MfTjAVjP
	trcP+OJN9lfn0MBQADFJZo90xXqiHJw=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82fa8d6425bso1047117b3a.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778252491; x=1778857291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsM3MZHPJG4jSqIS5oTV4ZYkVaqZoomzaAcAboB87ak=;
        b=XS7u0zHYzzQb/bS6/ox/oijhDStz4FpWCWMAraSpK3cdNBDPImbfFTlqF2sycdpq3c
         19LccM8eHB69IquUW8GFIX02cEfr8u6DhDEVPAWm4USqpmR2AafUqEJyVjAFoejD4vIJ
         09u4WLOtRx2Ydaa2NrKO3APp3pX8jINdkW1J7I/NVrKalLXjqbt0ggj9fRjeYx8ZFe6K
         kZdQ7IMu5+b4uolsFOrcwYaDUUmS2LIQh4Dt1+AGOa+aa/dOggZL3ct1g6X6TWBNBqa2
         gUHE/uWg0EmzHfI9vvlOvAnNrVLa9oco5+ajJ3DEHctL8HE9AX27/6/lxVVS24qudzZa
         TSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778252491; x=1778857291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dsM3MZHPJG4jSqIS5oTV4ZYkVaqZoomzaAcAboB87ak=;
        b=KBYF/FyuPjukmUSmy1LRhz9e/rT4cGGatALbVyzPUEL05/kbAtB8zlfXaHJxHd645j
         VwsGoDqGIW5OFBiiTs+plWUPUmO0/VTgDoMllUhGhT1qC8w+FneuiGFJYvj+PBFl+5UP
         oXOcGB+xvT8yiFtVoYxHwjJyeVQ49n+ZUjZ2lroqKoFoocARII5MqLov9+emB1md1MIO
         KWSlookRy3E6xmpH5vMI1xcfO2TfJTrLvnUgFEmilIw8J6RXaLXjM/KalMyexI71rxOb
         6S51C98UccSZ2miRVC+L+4BUz98fKrcP2C3AhR8gKwMWcMpkRJAY5gUXl1zZi+yRHPlQ
         0Dug==
X-Forwarded-Encrypted: i=1; AFNElJ+Tp1FAt2NP63pDXqmXIWwsO5lw9V49t9oX56QuPMlz1QsNEEig4y5pzwwZk/hWCqZCDqK+7DoS7A==@kvack.org
X-Gm-Message-State: AOJu0YyKd2YJt/TdjJPqo4RmsfpI+Cn1qGzRicS0R3dzScOjZqZ8mSzy
	P9bK+RRVU8FGPND4loovv2r4pbH+plvTcJYhNVSo5xcL4NcTOKrISkaH
X-Gm-Gg: Acq92OGH27YBuFlWr7TsnkOsXJdjLtS/zO0zvzhbAL9m/1M8NSroX1KiBu22x7NHz2b
	8Huq+ic4Y8k1V2fht+AVldY0KKe5kDMRNZIHGp9cCAg3k3D38Nva8QYGk9mOBaphfenUtLk6jvw
	5rdwosAYtvVJshkY+dZYBp4PHUDSs8a9hMx5jVw29gKh76h96U1Bdc5IpfcQTGFTaFvMRvQgImn
	t5R4T+aHJN3aeU88LDlzRLg5kUUckwPCwFhbY94G4IdG8AbgKRYGHt/LxOJreMAJ2TaH5PXxcm+
	xZAo3DdSJRqo/LGDF06+6DvZBUY1gH6KVLfwW7FO7vPlTeOrLsrRLft5zhNmnuMp49/7j5TjyMu
	Q8pphyUndVg6UxJ7RmPyUb851+n/2cPCF6czF8Qcv8Wpwmu5Rl3FrZV3uTBO8T/dAPGmPbrKsde
	NFx02ymCcu4+V/5oRhf2klIO154fC2boqwmE52rJDHBobYyyU=
X-Received: by 2002:a05:6a00:39a5:b0:82c:2205:507d with SMTP id d2e1a72fcca58-83a5dd5bc34mr12224188b3a.36.1778252490591;
        Fri, 08 May 2026 08:01:30 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965945c1bsm13110064b3a.15.2026.05.08.08.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 08:01:29 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	surenb@google.com
Cc: tz2294@columbia.edu,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	laoar.shao@gmail.com,
	gutierrez.asier@huawei-partners.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 3/4] mm: introduce bpf_mthp_ops struct ops
Date: Fri,  8 May 2026 23:00:54 +0800
Message-ID: <20260508150055.680136-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260508150055.680136-1-vernon2gm@gmail.com>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A50840023
X-Rspamd-Server: rspam06
X-Stat-Signature: 16es9zhsfq74zhjhjeu1a7ncs7kce9gn
X-HE-Tag: 1778252491-547207
X-HE-Meta: U2FsdGVkX1+oHqjgR544wAdyCQFpH/UT9JlSroEStTDzkk2UgcSamPHG7XrZPRKHmPhe/3sY6TDMilfsRp3tLDbp5OP84SCBL+xNAbh8TZR1voA9zFQ+zFu3mhkbF1dotSbNm4FgWu2TdXHC/QlSYlOsQ3VXqywHsr92e2qDToEHCjptkRmF8xdnFzkAjlsTzcIjJGaoz6Gh4mHwyE044vtVGM+eqnDqL79yV4+WP+ItRCtuKK0lDzgycgv4nj+n3B1PGZv4hjFSlnANQd0JuFYZBLothBWe3cZY+YBKVLQKwUhjsM1Svq9LJPn7CdRLGOTD5XRKJR6N1V59Q4o3vzJOf3k2m7EhpQ6Bv5oMBKn4boeZ9VsdrdKaKvoocLVIWK/ycovmQUSjRNjGdWPz1/mVSb/Wau9+lxy2zehIJ11x0KJJBXMuAOzm9xJ0INFeRT6MRsmaEomg4vFrLfnVprDV6iUDLj+gOq5idgOfrzW6nC8DfCzLzQEh1dNJ3lerc/hnYjR5/17vr15wRA7lBFWXIojsVUN7nDpEJAaBiLt1arin2pVMhtq42jyMK2tf+WbRQsSlP7+K2PtkAEr1FERrDnYJ9jHlM+TGFSyaDcBPFR/NRqLp+TRbPCdk3XOPeiMkmoNbXSn3+ARBGMTbHxTt2fl1DLpVvuXQk8vgm43PePl5/nexUCBJWv50caqId8oAbsq/RThZjjryrLTvN0hlZ6mVcdpHn0P2aoH2cgy4JUfW5+qLYgC71n8p7L9tHIRTX5ctiGiF0EbUD0sqQOX2yTNf9qldZHrMgZjGA7kIpjNs+bUCzWZ/TH7KQ3Zr1iJC/KV7TYXlTlYt3h3yVb5XvLc/vASakbl0GlWuNTXdCuar3OnBCV6bjuqNtCPc5VcxlnuQfTr7HUzdge9yfNfBgQMyU09CV9epJ07qySe4NHhDM93XciW+GrdCuJdLIUbyRSbQAa0kjF5vn92
 8IngJXHL
 lHCYjMHGl+1fmoUmuGaGBjVRs9iasBFVTBdAyMyE0MsAZQVXV34aQVvNMf0/22teQV2SrH1uEqKL2OV743wGRVoIoTNzHb1bBIzd305KZ31I7Ffnw9HaCk/X4aH8iZBR5GxRJHtfZ27U9UTySHZxOb7Hh43ALkxK1eZKWidMB6bc2ytKFcz47t29MBQY9u/x3EcqPyDNNLsjHAzG/wTiAy623ywv6efSiWJMaMCxT7utqgSU7B/gMl5hAyV20bS/kSdnMjY3aVE848ZPzU82/fQHmGL/yRCV8pKWRO5TDuSNjJSc8zZFbXIn73KP8HGtJE7nfk7aWs+m+7cI5fupyfS6RMTXTpexws1Qmx6fQb0hdefzr4yAQQhpaaOmyySEoXFxIojAPfE3d/K3J4u/iF+8GQ1t+z7vxb/Avy1Beycm1wfBVOvlch9FJle+Lw9HPh1FVZUfo97cpnVxCy0b+RRdivovWabKfQYYdhBRbgmwTOeeVB73hdXu5D/eReV9v2doG70vJTuJ+bZ8P+QO24jBz6dFTXBzLyZuj13u4JKOW+mcuQ2WkRuRr2ubzPd/8pjCQ9n9v/IeAxTeN0MVeRxC4+TSrzmWV0PK8nnTjlqwRF8CYFldZ+Mj08lcV4J2+LDcKSHHfwA7I6tQZkau+ylZPRivOoXK0GGQo/OWNVRhY76srsnqirSLd7Zu0qgni+4xgkQKrCregnzg1rtmgg0FjQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Introducing bpf_mthp_ops enables eBPF programs to register the
mthp_choose callback function via cgroup-ebpf.

Using cgroup-bpf to customize mTHP size for different scenarios，
automatically select different mTHP sizes for different cgroups,
let's focus on making them truly transparent.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 MAINTAINERS                     |   3 +
 include/linux/bpf_huge_memory.h |  52 ++++++++++
 include/linux/cgroup-defs.h     |   1 +
 include/linux/huge_mm.h         |   6 ++
 kernel/cgroup/cgroup.c          |   2 +
 mm/Kconfig                      |  14 +++
 mm/Makefile                     |   1 +
 mm/bpf_huge_memory.c            | 168 ++++++++++++++++++++++++++++++++
 8 files changed, 247 insertions(+)
 create mode 100644 include/linux/bpf_huge_memory.h
 create mode 100644 mm/bpf_huge_memory.c

diff --git a/MAINTAINERS b/MAINTAINERS
index caaa0d6e6056..f1113eaa1193 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4887,7 +4887,10 @@ M:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/bpf_huge_memory.h
+F:	mm/bpf_huge_memory.c
 F:	mm/bpf_memcontrol.c
+F:	samples/bpf/mthp_ext.*
 
 BPF [MISC]
 L:	bpf@vger.kernel.org
diff --git a/include/linux/bpf_huge_memory.h b/include/linux/bpf_huge_memory.h
new file mode 100644
index 000000000000..ffda445c9572
--- /dev/null
+++ b/include/linux/bpf_huge_memory.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __BPF_HUGE_MEMORY_H
+#define __BPF_HUGE_MEMORY_H
+
+#include <linux/cgroup-defs.h>
+
+/**
+ * struct bpf_mthp_ops - BPF callbacks for mTHP operations
+ * @mthp_choose: Choose the custom mTHP orders
+ *
+ * This structure defines the interface for BPF programs to customize
+ * mTHP behavior through struct_ops programs.
+ */
+struct bpf_mthp_ops {
+	unsigned long (*mthp_choose)(struct cgroup *cgrp, unsigned long orders);
+};
+
+#ifdef CONFIG_BPF_TRANSPARENT_HUGEPAGE
+/**
+ * bpf_mthp_choose - Choose the custom mTHP orders using bpf
+ * @mm: task mm_struct
+ * @orders: original orders
+ *
+ * Return suited mTHP orders.
+ */
+unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orders);
+
+/**
+ * cgroup_bpf_set_mthp_ops - Set sub-cgroup mthp_ops to parent cgroup
+ * @cgrp: want to set mthp_ops of sub-cgroup
+ * @parent: parent cgroup
+ */
+static inline void cgroup_bpf_set_mthp_ops(struct cgroup *cgrp,
+					   struct cgroup *parent)
+{
+	WRITE_ONCE(cgrp->mthp_ops, parent->mthp_ops);
+}
+#else
+static inline unsigned long bpf_mthp_choose(struct mm_struct *mm,
+					    unsigned long orders)
+{
+	return orders;
+}
+static inline void cgroup_bpf_set_mthp_ops(struct cgroup *cgrp,
+					   struct cgroup *parent)
+{
+}
+#endif /* CONFIG_BPF_TRANSPARENT_HUGEPAGE */
+
+#endif /* __BPF_HUGE_MEMORY_H */
+
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f42563739d2e..78854d0e06ab 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -628,6 +628,7 @@ struct cgroup {
 
 #ifdef CONFIG_BPF_SYSCALL
 	struct bpf_local_storage __rcu  *bpf_cgrp_storage;
+	struct bpf_mthp_ops *mthp_ops;
 #endif
 #ifdef CONFIG_EXT_SUB_SCHED
 	struct scx_sched __rcu *scx_sched;
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 127f9e1e7604..65da35fb0980 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -3,6 +3,7 @@
 #define _LINUX_HUGE_MM_H
 
 #include <linux/mm_types.h>
+#include <linux/bpf_huge_memory.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 #include <linux/kobject.h>
@@ -296,6 +297,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       enum tva_type type,
 				       unsigned long orders)
 {
+	/* The eBPF-specified orders overrides which order is selected. */
+	orders &= bpf_mthp_choose(vma->vm_mm, orders);
+	if (!orders)
+		return 0;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 43adc96c7f1a..1dbef3e8b179 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5836,6 +5836,8 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 	if (ret)
 		goto out_stat_exit;
 
+	cgroup_bpf_set_mthp_ops(cgrp, parent);
+
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp))
 		cgrp->ancestors[tcgrp->level] = tcgrp;
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 27dc5b0139ba..be49bde783a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -949,6 +949,20 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config BPF_TRANSPARENT_HUGEPAGE
+	bool "BPF-based transparent hugepage (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && CGROUP_BPF
+	help
+	  Using cgroup-bpf to customize mTHP size for different scenarios,
+	  automatically select different mTHP sizes for different cgroups,
+	  let's focus on making them truly transparent.
+
+	  This is an experimental feature, that might go away at any time,
+	  Please do not rely any production environment.
+
+	  EXPERIMENTAL because the BPF interface is unstable and may be removed
+	  at any time.
+
 endif # TRANSPARENT_HUGEPAGE
 
 # simple helper to make the code a bit easier to read
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..b474c21c3253 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -108,6 +108,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
 ifdef CONFIG_BPF_SYSCALL
 obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
+obj-$(CONFIG_BPF_TRANSPARENT_HUGEPAGE) += bpf_huge_memory.o
 endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
diff --git a/mm/bpf_huge_memory.c b/mm/bpf_huge_memory.c
new file mode 100644
index 000000000000..851c6ebe2933
--- /dev/null
+++ b/mm/bpf_huge_memory.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Huge memory related BPF code
+ *
+ * Author: Vernon Yang <yanglincheng@kylinos.cn>
+ */
+
+#include <linux/bpf.h>
+#include <linux/srcu.h>
+
+/* Protects cgrp->mthp_ops pointer for read and write. */
+DEFINE_SRCU(mthp_bpf_srcu);
+
+unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orders)
+{
+	struct cgroup *cgrp;
+	struct mem_cgroup *memcg;
+	struct bpf_mthp_ops *ops;
+	int idx;
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	if (!memcg)
+		return orders;
+
+	cgrp = memcg->css.cgroup;
+
+	idx = srcu_read_lock(&mthp_bpf_srcu);
+	ops = READ_ONCE(cgrp->mthp_ops);
+	if (unlikely(ops && ops->mthp_choose))
+		orders = ops->mthp_choose(cgrp, orders);
+	srcu_read_unlock(&mthp_bpf_srcu, idx);
+
+	mem_cgroup_put(memcg);
+
+	return orders;
+}
+
+static int bpf_mthp_ops_btf_struct_access(struct bpf_verifier_log *log,
+		const struct bpf_reg_state *reg, int off, int size)
+{
+	return -EACCES;
+}
+
+static bool bpf_mthp_ops_is_valid_access(int off, int size, enum bpf_access_type type,
+		const struct bpf_prog *prog, struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+const struct bpf_verifier_ops bpf_mthp_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.btf_struct_access = bpf_mthp_ops_btf_struct_access,
+	.is_valid_access = bpf_mthp_ops_is_valid_access,
+};
+
+static int bpf_mthp_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
+	struct bpf_mthp_ops *ops = kdata;
+	struct cgroup_subsys_state *child;
+	struct cgroup *cgrp;
+
+	if (!link)
+		return -EOPNOTSUPP;
+
+	cgrp = st_link->cgroup;
+	if (!cgrp)
+		return -EINVAL;
+
+	cgroup_lock();
+	css_for_each_descendant_pre(child, &cgrp->self) {
+		if (READ_ONCE(child->cgroup->mthp_ops)) {
+			pr_warn("sub-cgroup has already registered.\n");
+			cgroup_unlock();
+			return -EBUSY;
+		}
+	}
+	css_for_each_descendant_pre(child, &cgrp->self)
+		WRITE_ONCE(child->cgroup->mthp_ops, ops);
+	cgroup_unlock();
+
+	return 0;
+}
+
+static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
+	struct cgroup_subsys_state *child;
+	struct cgroup *cgrp;
+
+	if (!link)
+		return;
+
+	cgrp = st_link->cgroup;
+	if (!cgrp)
+		return;
+
+	cgroup_lock();
+	css_for_each_descendant_pre(child, &cgrp->self)
+		WRITE_ONCE(child->cgroup->mthp_ops, NULL);
+	cgroup_unlock();
+
+	synchronize_srcu(&mthp_bpf_srcu);
+}
+
+static int bpf_mthp_ops_check_member(const struct btf_type *t,
+				     const struct btf_member *member,
+				     const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct bpf_mthp_ops, mthp_choose):
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int bpf_mthp_ops_init_member(const struct btf_type *t,
+				    const struct btf_member *member,
+				    void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_mthp_ops_init(struct btf *btf)
+{
+	return 0;
+}
+
+static unsigned long cfi_mthp_choose(struct cgroup *cgrp, unsigned long orders)
+{
+	return 0;
+}
+
+static struct bpf_mthp_ops cfi_bpf_mthp_ops = {
+	.mthp_choose = cfi_mthp_choose,
+};
+
+static struct bpf_struct_ops bso_bpf_mthp_ops = {
+	.verifier_ops = &bpf_mthp_verifier_ops,
+	.reg = bpf_mthp_ops_reg,
+	.unreg = bpf_mthp_ops_unreg,
+	.check_member = bpf_mthp_ops_check_member,
+	.init_member = bpf_mthp_ops_init_member,
+	.init = bpf_mthp_ops_init,
+	.name = "bpf_mthp_ops",
+	.owner = THIS_MODULE,
+	.cfi_stubs = &cfi_bpf_mthp_ops,
+};
+
+static int __init bpf_huge_memory_init(void)
+{
+	int err;
+
+	err = register_bpf_struct_ops(&bso_bpf_mthp_ops, bpf_mthp_ops);
+	if (err)
+		pr_warn("Registration of bpf_mthp_ops failed, err %d\n", err);
+
+	return err;
+}
+late_initcall(bpf_huge_memory_init);
-- 
2.53.0


