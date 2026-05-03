Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4E1CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544D66B0096; Sun,  3 May 2026 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5226B0098; Sun,  3 May 2026 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B546B0099; Sun,  3 May 2026 12:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 301FE6B0096
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:51:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC0A540703
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:22 +0000 (UTC)
X-FDA: 84726699204.30.051E717
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AADD4000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="M/VkuJKn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/G70uBdUm2gD1KEfqVpMXmzdSE5Aaw6QQY+7czX4maU=;
	b=kq3CSW5wm/Ee/Jy3FtZho6kAU2f94PLr49FHIsBbdp3M2FJXGSZvTBWDIE58NFOXCnZ8De
	IAJzwnrvfS6GDJCoYiSMhxF/D/yQO0Cao1EZFQyb4NWOuYRXV/O9AhA9ylYLknRysVnwxN
	gyWwySk9eRqr+qJ00CS4nfp1pmPzhr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827081; a=rsa-sha256;
	cv=none;
	b=OgflTuGIZLHrd4wBQg9wwP+ebZUSkX9CwclITpd/6xSBfVf1gm+KUstDB6eFA7PT6QMiCI
	nOwK9ycLqfRDJ3u4maZWFpkSm4OKz8FwccZ3905jBfQfvBTMeqDLhJxLoTsOud/F/57PRc
	nMh9bhtBtZEPf45hw6iR45DEDV7OBhw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="M/VkuJKn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82748257f5fso3072759b3a.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777827080; x=1778431880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/G70uBdUm2gD1KEfqVpMXmzdSE5Aaw6QQY+7czX4maU=;
        b=M/VkuJKnZ8CN9qW9EQCVv8sxd+FQIQsJvuqSI+1LR/nFA2GUTBEm7uzwna9QDkWdsE
         f2biJqT8CQF901sx5uDxOAPcKR//AUJ2zfaQikcuKEiVya9iZihymvRuHovky3Qm3VwE
         oOnLSA/yPVO8m0AJ5DViG6hfsx2+0T9870fekjhvtl4vkQvW/yrZTIskCOc4lRpYtMrU
         K3RkCjFHDxVhgd9d9+qs7ORjYb6wDEB4pgsHqWLDtwPSUng3dACIQuNsBsmZqlv+vHLi
         9xWnL3JLDdYCtJHYEt7r1Ch5/MucJWljj847/6euq/PI/KUzituy+UgLMKerZGnB494g
         AHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827080; x=1778431880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/G70uBdUm2gD1KEfqVpMXmzdSE5Aaw6QQY+7czX4maU=;
        b=Os2c7EiZ0V0JyXf2O4D7dSdkvoC8fptj0ThNc1Hnv07ClbKwVZxM1P2ko8xlQoj3sf
         eIM6j1pu2/tWdAQTEtcTPavcfa3FdAe+wQJIE3QGuq6b2/6q4BkS94cJ6GMrPXA5p1WE
         9rx8R7lyh96A34mPoa+0IhwS8MUoAsJDO76tJwC6nO/mQCw9+vXMg0WfKtmgcIETpm3t
         LspnvXlXCAE/eEA3uggyV8i7B4X1KynyQQk20vRX3kDbgp5H7PwNIniw7C6hufIQKmJG
         Qg4ozK/BHzwxZ1TlDTxQbni11PuAzO+q8rgGdT/veH4e4lLTDJbI0yazN8b4Rj1aLu2n
         qWHg==
X-Forwarded-Encrypted: i=1; AFNElJ9S6jJlqYCXCWaUgwKljN2P7xocATLQQgFkX8ZC9CqIKYulDEHTDJm7R6HtgRbxH/sQTIO2swWEFQ==@kvack.org
X-Gm-Message-State: AOJu0YyAPu18A9VivaVVpoxDqoa++gTUmSzHEsFu2QvVH0SPoeryBzfq
	dS5DHhQHaMwAj35uRJkO0Bc9B0huSugLJb4Xm4jLu+j2VhGANvh6x23V
X-Gm-Gg: AeBDievmQOKsAEvy9xDexo2rFLr8L+hRvssQNdYy5Q3XB4EsOZjPfVUS6Ws3qe7mw+a
	zqEPGdGSAfJu6hEnBWx3O4zevKl3fcQrdSmlP1AFssLmPfxi7uqlPIuFD4oSBvvRq4z0cqx9iik
	ZzroLJE6m8I5wxEEreJ5dmGxlXUMDHynIFnYGVBI1fh4WOAUB+aRaKagqUwfwm45tLxcCgqSWQs
	kJc1zt7Kk9T9Yk0LwXY0oafKmhxgsU5elpUcicui/e9/iflBjML98umntijW/HpRqOluRm2iDej
	jCENm5GxU7dXk/JdwjTKoVjxOJds9qHKbU81w0YMRyEy7E4I5OKqJg8jP8f6Dg0Ty/FSwx0MTTo
	Z5tiWauucxpfTmeIbf0mDnWoVkDEMEb3vDMUC/zEK6vpyXZT+/2SIFs8OnepES9K2W5Ei3jO970
	/R+88XiGCHiL5QvXRBbvXZokFttnlUH/adzDdTamfOZoukFMo=
X-Received: by 2002:a05:6a20:4311:b0:35d:cc9a:8bc1 with SMTP id adf61e73a8af0-3a7f041ebf8mr5417275637.27.1777827079789;
        Sun, 03 May 2026 09:51:19 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83707fab756sm1494277b3a.44.2026.05.03.09.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:51:17 -0700 (PDT)
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
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 3/4] mm: introduce bpf_mthp_ops struct ops
Date: Mon,  4 May 2026 00:50:23 +0800
Message-ID: <20260503165024.1526680-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503165024.1526680-1-vernon2gm@gmail.com>
References: <20260503165024.1526680-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1AADD4000A
X-Stat-Signature: ccxr7wa8zbudwc8cg7xq7mh3eqt87yq1
X-Rspam-User: 
X-HE-Tag: 1777827080-909303
X-HE-Meta: U2FsdGVkX19dUo8UC/QNE3EzrBuqWcPi5h0yojBACKjdqFniU1ePzf++H7efQGT/idYEbIVldsMZnRKBwLbuVjFXhOhQJ5/dDfKPTJ9yBkVq5BIUqRg/oQc9WSSGL9R8ejR6OdyqfFWpyRKiXA7STWFz1DEtjGQ+F2xF1y09SmE3wAeVQLVA2AKKBrA3Iz3V68qctHVczDmyGNnMvP4cLdW8Vd0za0/gACRUgmvfC8GQaniibGOVCs8XS0P1g9TWCX8udWAGgbsyYVLay9/C+/cIymw12a98DW8/o7aXBgq6mpHu6S4FNEK92QEBUtyNsSED5rqXGcb7NqDDpgfTEjyWV+icJqfmv5UTBWCusH9eF3TDTZ2mckJxFd7WH997ZFAjlqpxZgauHeF5Xwur5alDeD1NhBbD+G3R9enacI7cKRrMpgRvRy0Y/nDLkPdMWd2GYTdadAJBxBgO4JeiQY87MsCs54MggEuAGR24r70kLbidrBm5B4Kd9EYU0bFVbnJpb0o+iw+r0SoZEwymouZnC860KHn4sBqsXwDb/fU10UWUHgqw11aNNaeNpSDz7y9bq74RnbdUn67g41n70IfkWG84gEJULkblmGv+3ybSLRZCH1NOQiSebdndjOHvH5sLFFk6AOUF/PogkkIn0JubfIhKnnELHdIp6g2IqxiPetubw4V1htXZom+oqfHSMXHYSRnEmdFKXueVIv5KHD4kI8PoA5CwDfwRjr9H0ADBPyXDwof7MUxNZercL0Chy7a1LFMpb1u/6cnv8z1EpePim3vk/ldZlglt3M+8jTj5Va8Ds+bn2tAeMO1CNs3iJfQsA1zLiHqxxq/HLe7fFsuFq2LbulDZc2fVI59pzd/FogeULGIZ+ZJhOB87mvjSw+H+ItbeNI/RxDWHaWjPE3im3CI2IVsd5g8Cwn3lhjasMiaw7eTAWxivGsNpqDduny6yzQspcjIXT4HeFcL
 /cRO7AkJ
 0Yk23BMfCClqi3w2KN1GlfVz0eEVPsHdQSfpyPbZkstxKw73M43BUqLG7fK06HhSuP8qAJQT8oNZTXSNND6cT/zAloOnAn91aFGPijXxTm5vWk+1uRefrnHaB9+yFrvIsMn+A8U1Y5kwYnuRK0SlvtOX30HtdrF2tVxNjPeQaEQh0E/iAhXa54WqWkq4B9gRXkKWHBMmHidR7qH8cKMSya0qT4nq3ugagghHWOhwjgPbSO9KGpAB5lCx38QpUsl7pL9QgvT36qzEqK1gXWcBNqidGMthtT6Q2ea6VbSk/gtD70C54KLSRl6KTdMr2on02n0uHxRBKs7Uov7QDOxZFUN8d5cek5eAm93Lftq4d272vgDANvZ9vjJMsSAFj8geXM+0vP7iPwpfzebk2AhMJd5E9UHYf/xhDhv5PCq3E/sZM4YU7hRdE/JoOV6bTLpvV1+wVHODr7Y+N2gImu1HJggYvEbw5icrJ3w7ZmJXO8atbgB1Z9P4+zYOyzSojao4vC/Qns5oF27t6dl0eKR1JqEmKMJC3E5cGPZoTJxuTnE8QEY2Yn2/9ehfn/ct5Z0TwUuh2U0e/6gfh+mk99OcvtcnwDw==
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
 include/linux/bpf_huge_memory.h |  35 +++++++
 include/linux/cgroup-defs.h     |   1 +
 include/linux/huge_mm.h         |   6 ++
 mm/Kconfig                      |  14 +++
 mm/Makefile                     |   1 +
 mm/bpf_huge_memory.c            | 169 ++++++++++++++++++++++++++++++++
 7 files changed, 229 insertions(+)
 create mode 100644 include/linux/bpf_huge_memory.h
 create mode 100644 mm/bpf_huge_memory.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 27a073f53cea..39f00676eeb7 100644
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
index 000000000000..1c8a6f7ad8f1
--- /dev/null
+++ b/include/linux/bpf_huge_memory.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __BPF_HUGE_MEMORY_H
+#define __BPF_HUGE_MEMORY_H
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
+#if defined(CONFIG_BPF_TRANSPARENT_HUGEPAGE) && defined(CONFIG_BPF_SYSCALL)
+/**
+ * bpf_mthp_choose: Choose the custom mTHP orders using bpf
+ * @mm: task mm_struct
+ * @orders: original orders
+ *
+ * Return suited mTHP orders.
+ */
+unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orders);
+#else
+static inline unsigned long bpf_mthp_choose(struct mm_struct *mm,
+					    unsigned long orders)
+{
+	return orders;
+}
+#endif /* CONFIG_BPF_SYSCALL */
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
index 2949e5acff35..80ec622213df 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -3,6 +3,7 @@
 #define _LINUX_HUGE_MM_H
 
 #include <linux/mm_types.h>
+#include <linux/bpf_huge_memory.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 #include <linux/kobject.h>
@@ -291,6 +292,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
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
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..12382431ddc7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -963,6 +963,20 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config BPF_TRANSPARENT_HUGEPAGE
+	bool "BPF-based transparent hugepage (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE
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
index 000000000000..e34e0a35edac
--- /dev/null
+++ b/mm/bpf_huge_memory.c
@@ -0,0 +1,169 @@
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
+	ops = READ_ONCE(cgrp->mthp_ops);
+	if (unlikely(ops)) {
+		idx = srcu_read_lock(&mthp_bpf_srcu);
+		if (ops->mthp_choose)
+			orders = ops->mthp_choose(cgrp, orders);
+		srcu_read_unlock(&mthp_bpf_srcu, idx);
+	}
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
+	struct cgroup *cgrp = st_link->cgroup;
+	struct cgroup_subsys_state *pos;
+
+	/* The link is not yet fully initialized, but cgroup should be set */
+	if (!link)
+		return -EOPNOTSUPP;
+
+	cgroup_lock();
+	css_for_each_descendant_pre(pos, &cgrp->self) {
+		struct cgroup *child = pos->cgroup;
+
+		if (READ_ONCE(child->mthp_ops)) {
+			/* TODO
+			 * Do not destroy the cgroup hierarchy property.
+			 * If an eBPF program already exists in the sub-cgroup,
+			 * trigger an error and clear the already set
+			 * bpf_mthp_ops data.
+			 */
+			continue;
+		}
+		WRITE_ONCE(child->mthp_ops, ops);
+	}
+	cgroup_unlock();
+
+	return 0;
+}
+
+static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
+	struct bpf_mthp_ops *ops = kdata;
+	struct cgroup *cgrp = st_link->cgroup;
+	struct cgroup_subsys_state *pos;
+
+	cgroup_lock();
+	css_for_each_descendant_pre(pos, &cgrp->self) {
+		struct cgroup *child = pos->cgroup;
+
+		if (READ_ONCE(child->mthp_ops) == ops)
+			WRITE_ONCE(child->mthp_ops, NULL);
+	}
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


