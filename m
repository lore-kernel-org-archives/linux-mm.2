Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0B4FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0140B6B0099; Sun,  3 May 2026 12:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E056B009B; Sun,  3 May 2026 12:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DA16B009D; Sun,  3 May 2026 12:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBD4F6B0099
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:51:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68ADD1A099F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:32 +0000 (UTC)
X-FDA: 84726699624.19.DD67B79
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5215D100003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=edo4UM4i;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kdu5+fSnVWCGaHSDNy5Sqn0Y2MXs1Uyb3JHpXbPoVvc=;
	b=JPthBtmczsBR2jDp/KrCmmULVKfFKpVKpjmXv1oHZHFQB080FBEzoRmhoZrw0Hmqn7KFmR
	UmDiL5IK5PYaZyyDp3+i3n2Fqe91Y0Qk1GRHN/8v4v/ho/6VkgYzZN+YzRdUvFSBnV6I9e
	XG44je+Bm8wJ0lyq6FAnMVHcWeTPV3A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=edo4UM4i;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827090; a=rsa-sha256;
	cv=none;
	b=eqWohYSM6B0MI6Yn3Y1KSaURnP53raYddZZwZs5Pz8FLGSr2Fb38HTRsbx4jozhicQUsVW
	YftE4zNdjbxuYYmHMsBaJ9JuTBlx8nBAzX4Si+QBMha0vHYb3vjDOd4D372UnRywibNIRq
	OUtRf/FJ9/5Q6h28Em5Aq7qzORxj56Y=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8379e010b01so38184b3a.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777827089; x=1778431889; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kdu5+fSnVWCGaHSDNy5Sqn0Y2MXs1Uyb3JHpXbPoVvc=;
        b=edo4UM4i6boqrJPEHXzbYU4Vsds2cnD6MsllPG6c8/lZGj1quOuH9I1aQNXQP/Zs1+
         HgnQRdJICXx9O66YsMD/gFtVICDiDmtosgxlwkM2fqxnnksS3enGhHKT9maztaSmO/cO
         bgF5aRENhl+CMDILgwwYiLKE6upmBY7jtMayg7GM22y4+8d2OZTdhI7+P8S8qrA69tUn
         OWHE9Uw59XELI3+EWrtm5bs3dQUY9RbcBEgi3Agg+R5cq9MnzvChVZWCyCkm5G/jtwTH
         AG1SsCblBDWKAvOGbz+UbRQrioibn+SJJGL2wlFHRl1kdKAsbJXO2JptLi1HhTzedVwC
         luUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827089; x=1778431889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kdu5+fSnVWCGaHSDNy5Sqn0Y2MXs1Uyb3JHpXbPoVvc=;
        b=Jst3GZMsXhLAB2fwTyoqvTklqV1UlAzsw+/5lgO5kaT6YiEWW/1nezpmTP9XcHl1QE
         NnjDX3nEYY1EN1nXG/9IUhP6vUOkJDnipkQHDZpLu4wNbo/obyx2XN0puHPfXMoqtb5W
         SSAaXe+Bh5PsFAd8zvUGKhlGXODE05RW/6sUdw2fKClI0t9h52DYG8NZzm0k/Ztna5Qa
         Oz7Bu95te7ALNuspb+/B334k70oh4V1toWPH3WtEAtTOVNDslZ4UeKT4wAhocFiW1R0n
         S6SwLNY3QgKEoisYzOg02csTkfQ/2XBY7Nk1u9uqNFAPQXbJgrkojIpwqHCSnUezbWHV
         sJkA==
X-Forwarded-Encrypted: i=1; AFNElJ/uB+rwA5YTQ1rzDFrZWo6IgZdB0kqwZhppkn2PYkIXFP/OG7S1pSfzVxGgBqrViEml3jS6NlXzIg==@kvack.org
X-Gm-Message-State: AOJu0YzSbjVgxaCakwmkylC/t/7kv2RHSFUSXBvVD9G36CR0L8z4g5QU
	W8HfK1MBwqhR36DM0Rn1SMi4TKvp7fqJ7Q6jSiGRn+zUhCZTgorDAbac
X-Gm-Gg: AeBDievXxPDSS0vH/zYtLaON1FoVB3KmCC8cj8NeQmlU41xP8s+wQD0hUSAMD7A26ru
	kx+/gZi59OiFBsYx8erYGJjrbPklM3FIrr0jmKDfxqwWGnViZePGfydmzV5g/SGhi/t+twQaXj0
	8n8tTxxCVdzuvbu0rzt9jKHk2eZjLJwEYgQ8KRuNcmbKlV3s97yeqhW0ZttlC3ZDA85/RvEfYCD
	24gfu8qAZzyXoS14tdyWraDUaJyoxBlq95165XXiaYpJif9IdsAf3m70C9/DT4D3T6qrRfdIg9Q
	9TQqB572h1clxAlR75VQYC4RX/sv80BjoXCLr2Rht2CGVH0Pqbh2I4GRjmRLXvWaEU6fIFXYaO0
	a0leeZt8fB23PQbfSMVDXQ1e7bGYNm99EeecPKBbRM9VSlsaq+ZjgTF7kVSdLQCSg/i5FVP+Ac7
	DOwEE/Jp1mZUdMiwa10esrY1ELWQSqG1w7rwVr6oCyYqP0704=
X-Received: by 2002:a05:6a00:8188:b0:835:351c:f236 with SMTP id d2e1a72fcca58-835351cf525mr3911226b3a.29.1777827089059;
        Sun, 03 May 2026 09:51:29 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83707fab756sm1494277b3a.44.2026.05.03.09.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:51:28 -0700 (PDT)
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
Subject: [PATCH 4/4] samples: bpf: add mthp_ext
Date: Mon,  4 May 2026 00:50:24 +0800
Message-ID: <20260503165024.1526680-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503165024.1526680-1-vernon2gm@gmail.com>
References: <20260503165024.1526680-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5215D100003
X-Rspam-User: 
X-Stat-Signature: y7htu5u5yo65mkjtz77bwnw9pfhhocqb
X-HE-Tag: 1777827090-346145
X-HE-Meta: U2FsdGVkX1+sCQtaz1yGBT0e+iF/dDGOlC55pSCfxsv7XlJuuZ6mnyNTZTxiYhMLq+vFfH2RI6hfSca4yocCYCXgxtNkP6j2hqwaen+IyVmElsLoSjnK/u0tlvMsTtCInc8WYEquprnuIZDjs0cHabOcwMTYjPcnj3d+OKmu2jytkC9Nt7MGEtnb+7CeXz6H21xxnr3LBg51Qaiu2piJuqE1/0w7Nhq000nxzNoujOhzki+g+h/dY5AwLkiT5hTDSb+YMJeCRui59CvR7MZQdMD3h2B346/9PAdej6lomAZQal7v7xpP4M72K6WTLZ+adgLWYhYb9V/Lnjvd3jRk0GOTi6+XoDUyMeAWHjAaBxo1vpUBzpCJFeoL3aZcdMb1Cg4GBnagDZ3DstTnpxGIB22akeLUiOdv88vRYHrRyxe1F2VOPrZImbunJ/DrnOYRqCrZqSsB9m+tlUMDWJVaevapQ9kuLVoIUVV/370mzVrOdrsEzVBPoIdrT0OjXF5yoOpRx5I/+ktHqEbBdGTv20mQP6ZoboVTxiLPRMGVlsXNHMaNSzdlU0wbyUuZfR5ke8VnMGt7jgawQYNOLjDcnuq6yGz1QHFpQ3eaK1ALXTl1a9Up1Az39hde6EDrCn0KZJP2gXFKR+JP8nEBbQFC5E3pzjhCOpg9+OjihuPQOz8lysDj8vzd7KbJ5qCyJU96tEeOydJ7Er36QRG0ckF8YjGC6s4RnbzsHvN91ii6B6mG99UCydeOql8bwh4/okajisuH03FcFZKq4Sg+z4TwjJR9c7z9RcVPKC73j/slWL7fsZhtFYg/CS63Zq9t3Na/ErdRbQd0JjVXCCM/DPjOyHwqstFczCjcFpkeersIdxF3yzDv81T4uJWREMkPU/ewotfU2LF8+k5JDHCREgbKnfyvOlMj/tcWpJYJ/81QPf2FauiDfMbBUzsZbLg9eWVgg37Uxe9lRTnMPfmht6y
 D1NPz13C
 NrOWEG6FoDaAYDvVngyyWrmT5YlVU5SqBkLcOV/keFmwdFXhnJ3I7uAnrakroTaS4VE+3Dr7bIeupSyXz2uc0NBY/tsEfbQ1EMzHyDmmqmFYYdLzGCMGORMhIoIoO1Jdlv0lO9qEX7J4FyCxj0VR1DHsDvyLRghelT1eSSM+FlbTvLlNFlxReg5h3Y85HbWPBxr3tGb3wVKZ/MvO0YBnXMa/r6r5R7uZwLsaOyLo8M78EOEZOPM5Hdr3mhtnhk0F96SVDynIzZp50v2Dgq9aB9KzV6+r2W+8TbOFs1si3Y0VyB1Qtr7N0scv7d+k4KfCH1Abs1V4otqdcQ4F0RuWQ47D+2pBKyvXYkXe8L3riWjjhU7VIs4oO33CTjAF23Hs4SOIEExP9uLiPfsN+0gvjp+lxGPiDQQITt+ffyN2D1pIdw9PGtse5MAIV/alFL06baic//IiD0yfFS+AnGU6gCikcMo3Gag/w6nIFb43aC/CwyskKRR2LlIc8kGsWshhH325Dq+I8FY4kk0wbMbUmF46FVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Design mthp_ext case to address real workload issues.

The main functions of the mthp_ext are as follows:

- When sub-cgroup is under high memory pressure (default, full 100ms 1s),
  it will automatically fallback to using 4KB.
- When the anon+shmem memory usage of sub-cgroup falls below the minimum
  memory (default 16MB), small-memory processes will automatically
  fallback to using 4KB.
- Under normal conditions, when there is no memory pressure and the
  anon+shmem memory usage exceeds the minimum memory, all mTHP sizes
  shall be utilized by kernel.
- Monitor the root-cgroup (/sys/fs/cgroup) directory by default, with
  support for specifying any cgroup directory.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 samples/bpf/.gitignore     |   1 +
 samples/bpf/Makefile       |   7 +-
 samples/bpf/mthp_ext.bpf.c | 142 ++++++++++++++++
 samples/bpf/mthp_ext.c     | 340 +++++++++++++++++++++++++++++++++++++
 samples/bpf/mthp_ext.h     |  30 ++++
 5 files changed, 519 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/mthp_ext.bpf.c
 create mode 100644 samples/bpf/mthp_ext.c
 create mode 100644 samples/bpf/mthp_ext.h

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0002cd359fb1..2a73581876b4 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -49,3 +49,4 @@ iperf.*
 /vmlinux.h
 /bpftool/
 /libbpf/
+mthp_ext
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 95a4fa1f1e44..357c7d1c45ef 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -37,6 +37,7 @@ tprogs-y += xdp_fwd
 tprogs-y += task_fd_query
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += mthp_ext
 
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
@@ -122,6 +123,7 @@ always-y += task_fd_query_kern.o
 always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
+always-y += mthp_ext.bpf.o
 
 COMMON_CFLAGS = $(TPROGS_USER_CFLAGS)
 TPROGS_LDFLAGS = $(TPROGS_USER_LDFLAGS)
@@ -289,6 +291,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+mthp_ext: $(obj)/mthp_ext.skel.h
+
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
 XDP_SAMPLE_CFLAGS += -Wall -O2 \
@@ -347,10 +351,11 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_router_ipv4.skel.h
+LINKED_SKELS := xdp_router_ipv4.skel.h mthp_ext.skel.h
 clean-files += $(LINKED_SKELS)
 
 xdp_router_ipv4.skel.h-deps := xdp_router_ipv4.bpf.o xdp_sample.bpf.o
+mthp_ext.skel.h-deps := mthp_ext.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/samples/bpf/mthp_ext.bpf.c b/samples/bpf/mthp_ext.bpf.c
new file mode 100644
index 000000000000..bbee3e9f679c
--- /dev/null
+++ b/samples/bpf/mthp_ext.bpf.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include "mthp_ext.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <vdso/bits.h>
+
+struct mem_info {
+	unsigned long stall;
+	unsigned int  order;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CGRP_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct mem_info);
+} cgrp_storage SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 256 * 1024);
+} events SEC(".maps");
+
+struct config_local configs;
+
+/*
+ * mthp_choose_impl: Choose the custom mTHP orders, read order from cgrp_storage,
+ *		     which is Adjustment by the cgroup_scan().
+ * @cgrp: control group
+ * @orders: original orders
+ *
+ * Return suited mTHP orders.
+ */
+SEC("struct_ops/mthp_choose")
+unsigned long BPF_PROG(mthp_choose_impl, struct cgroup *cgrp, unsigned long orders)
+{
+	struct mem_info *info;
+	unsigned int order;
+
+	if (configs.fixed) {
+		order = configs.init_order;
+		goto out;
+	}
+
+	info = bpf_cgrp_storage_get(&cgrp_storage, cgrp, 0, 0);
+	if (!info)
+		return orders;
+
+	order = info->order;
+out:
+	if (!order)
+		return 0;
+
+	orders &= BIT(order + 1) - 1;
+	return orders;
+}
+
+SEC(".struct_ops.link")
+struct bpf_mthp_ops mthp_ops = {
+	.mthp_choose = (void *)mthp_choose_impl,
+};
+
+/* backport from kernel/cgroup/cgroup.c */
+static bool cgroup_has_tasks(struct cgroup *cgrp)
+{
+	return cgrp->nr_populated_csets;
+}
+
+/*
+ * cgroup_scan: scan all descendant cgroups under root cgroup.
+ *
+ * 1. When the memory usage of the sub-cgroup falls below the <min> threshold,
+ *    it will automatically fall back to using 4KB size; otherwise, it will
+ *    use all mTHP sizes.
+ * 2. When memory.pressure stall time of the sub-cgroup exceeds <threshold>,
+ *    it will automatically fall back to using 4KB size; otherwise, it will
+ *    use all mTHP sizes.
+ *
+ * Return 1 indicates termination of the iteration loop, and return 0 indicates
+ * iteration to the next sub-cgroup.
+ */
+SEC("iter.s/cgroup")
+int cgroup_scan(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct mem_cgroup *memcg;
+	struct mem_info *info;
+	struct alert_event *e;
+	unsigned long curr_stall;
+	unsigned long curr_mem;
+	unsigned long delta;
+
+	if (!cgrp)
+		return 1;
+
+	if (!cgroup_has_tasks(cgrp))
+		return 0;
+
+	info = bpf_cgrp_storage_get(&cgrp_storage, cgrp, 0,
+				    BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!info)
+		return 0;
+
+	memcg = bpf_get_mem_cgroup(&cgrp->self);
+	if (!memcg)
+		return 0;
+
+	bpf_cgroup_flush_stats(cgrp);
+	curr_stall = bpf_cgroup_stall(cgrp, PSI_MEM_FULL);
+	delta = curr_stall - info->stall;
+	bpf_mem_cgroup_flush_stats(memcg);
+	curr_mem = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED) +
+		   bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
+	if (curr_mem < FROM_MB(configs.min_mem) || delta >= configs.threshold)
+		info->order = 0;
+	else
+		info->order = PMD_ORDER;
+
+	if (configs.debug) {
+		e = bpf_ringbuf_reserve(&events, sizeof(*e), 0);
+		if (e) {
+			e->prev_stall = info->stall;
+			e->curr_stall = curr_stall;
+			e->delta = delta;
+			e->mem = curr_mem;
+			e->order = info->order;
+			bpf_probe_read_kernel_str(e->name, sizeof(e->name),
+						  cgrp->kn->name);
+			bpf_ringbuf_submit(e, 0);
+		}
+	}
+
+	info->stall = curr_stall;
+	bpf_put_mem_cgroup(memcg);
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/samples/bpf/mthp_ext.c b/samples/bpf/mthp_ext.c
new file mode 100644
index 000000000000..0e064bad136f
--- /dev/null
+++ b/samples/bpf/mthp_ext.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <signal.h>
+#include <time.h>
+#include <stdbool.h>
+#include <getopt.h>
+#include <sys/epoll.h>
+#include <linux/limits.h>
+#include <sys/stat.h>
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include "mthp_ext.h"
+#include "mthp_ext.skel.h"
+
+#define DEFAULT_ROOT		"/sys/fs/cgroup"
+#define DEFAULT_THRESHOLD_MS	100UL
+#define DEFAULT_INTERVAL_MS	1000UL
+#define DEFAULT_ORDER		PMD_ORDER
+#define DEFAULT_MIN_MEM		16
+
+static bool exiting;
+
+static void usage(const char *name)
+{
+	fprintf(stderr,
+		"Usage: %s [OPTIONS]\n\n"
+		"Monitor specified cgroup, adjust mTHP size via cgroup_bpf.\n\n"
+		"Currently supports fixed mTHP size and automatic mTHP size adjustment.\n"
+		"By default, it monitors the entire cgroup and automatically\n"
+		"adjusts mTHP size within the specified time window <interval>.\n"
+		"1. When the memory size of the sub-cgroup falls below\n"
+		"   the <min> threshold, it will automatically fall back to\n"
+		"   using 4KB size; otherwise, it will use all mTHP sizes.\n"
+		"2. When memory.pressure stall time of the sub-cgroup exceeds\n"
+		"   <threshold>, it will automatically fall back to using 4KB\n"
+		"   size; otherwise, it will use all mTHP sizes.\n\n"
+		"Options:\n"
+		"  -r, --root=PATH        Root cgroup path (default: /sys/fs/cgroup)\n"
+		"  -t, --threshold=MS     threshold in ms (default: %lu)\n"
+		"  -i, --interval=MS      interval in ms (default: %lu)\n"
+		"  -o, --order=NR         Initial mthp order (default: %d)\n"
+		"  -m, --min=MB           Minimum memory size for mTHP (default: %d)\n"
+		"  -f, --fixed            Use fixed order, disable auto-adjustment\n"
+		"  -d, --debug            Enable debug output\n"
+		"  -h, --help             Show this help\n",
+		name, DEFAULT_THRESHOLD_MS, DEFAULT_INTERVAL_MS, DEFAULT_ORDER,
+		DEFAULT_MIN_MEM);
+}
+
+static void sig_handler(int sig)
+{
+	exiting = true;
+}
+
+static int setup_psi_trigger(const char *cgroup_path, const char *type,
+			     unsigned long stall_us, unsigned long window_us)
+{
+	char path[PATH_MAX];
+	char trigger[128];
+	int fd, nr;
+
+	snprintf(path, sizeof(path), "%s/memory.pressure", cgroup_path);
+	fd = open(path, O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: open PSI file failed\n");
+		return -errno;
+	}
+
+	nr = snprintf(trigger, sizeof(trigger), "%s %lu %lu",
+		      type, stall_us, window_us);
+	if (write(fd, trigger, nr) < 0) {
+		fprintf(stderr, "ERROR: write PSI trigger failed\n");
+		close(fd);
+		return -errno;
+	}
+
+	return fd;
+}
+
+static int trigger_scan(struct bpf_link *iter_link)
+{
+	char buf[256];
+	int fd;
+
+	fd = bpf_iter_create(bpf_link__fd(iter_link));
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: bpf_iter_create failed: %s\n",
+			strerror(errno));
+		return -1;
+	}
+
+	/* Read to trigger the iter program execution */
+	while (read(fd, buf, sizeof(buf)))
+		;
+
+	close(fd);
+	return 0;
+}
+
+static void *monitor_thread(int psi_fd, struct config_local *configs,
+		struct bpf_link *iter_link, struct ring_buffer *rb)
+{
+	struct epoll_event e;
+	int epoll_fd;
+	int nfds;
+
+	epoll_fd = epoll_create1(0);
+	if (epoll_fd < 0) {
+		fprintf(stderr, "ERROR: epoll_create1 failed\n");
+		return NULL;
+	}
+
+	e.events = EPOLLPRI;
+	e.data.fd = psi_fd;
+	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, psi_fd, &e)) {
+		fprintf(stderr, "ERROR: epoll_ctl failed\n");
+		goto CLOSE;
+	}
+
+	/* First initialization */
+	trigger_scan(iter_link);
+	if (configs->debug)
+		ring_buffer__poll(rb, 0);
+
+	/* Auto adjustment */
+	while (!exiting) {
+		nfds = epoll_wait(epoll_fd, &e, 1, configs->interval);
+		trigger_scan(iter_link);
+
+		if (configs->debug) {
+			printf("PSI: memory pressure %s\n", nfds ? "high" : "low");
+			ring_buffer__poll(rb, 0);
+		}
+	}
+
+CLOSE:
+	close(epoll_fd);
+	return NULL;
+}
+
+static int handle_event(void *ctx, void *data, size_t len)
+{
+	struct alert_event *e = data;
+
+	printf("cgroup %s: stall %lu -> %lu (+%lu), mem %luMB, mthp order=%d\n",
+		e->name[0] ? e->name : "/",
+		e->prev_stall, e->curr_stall, e->delta, TO_MB(e->mem), e->order);
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	const char *root_path = DEFAULT_ROOT;
+	unsigned long threshold = DEFAULT_THRESHOLD_MS;
+	unsigned long interval = DEFAULT_INTERVAL_MS;
+	unsigned int init_order = DEFAULT_ORDER;
+	unsigned int min_mem = DEFAULT_MIN_MEM;
+	bool fixed = false;
+	bool debug = false;
+	struct mthp_ext *skel;
+	struct bpf_link *iter_link;
+	struct bpf_link *ops_link;
+	struct ring_buffer *rb;
+	int root_fd;
+	int psi_fd;
+	int err = 0;
+	int opt;
+
+	static struct option long_options[] = {
+		{"root",       required_argument, 0, 'r'},
+		{"threshold",  required_argument, 0, 't'},
+		{"interval",   required_argument, 0, 'i'},
+		{"order",      required_argument, 0, 'o'},
+		{"min",        required_argument, 0, 'm'},
+		{"fixed",      no_argument,       0, 'f'},
+		{"debug",      no_argument,       0, 'd'},
+		{"help",       no_argument,       0, 'h'},
+		{0, 0, 0, 0}
+	};
+
+	while ((opt = getopt_long(argc, argv, "r:t:i:o:m:fdh",
+				  long_options, NULL)) != -1) {
+		switch (opt) {
+		case 'r':
+			root_path = optarg;
+			break;
+		case 't':
+			threshold = strtoul(optarg, NULL, 10);
+			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 10);
+			break;
+		case 'o':
+			init_order = min(strtoul(optarg, NULL, 10), PMD_ORDER);
+			break;
+		case 'm':
+			min_mem = strtoul(optarg, NULL, 10);
+			break;
+		case 'f':
+			fixed = true;
+			break;
+		case 'd':
+			debug = true;
+			break;
+		case 'h':
+			usage(argv[0]);
+			return 0;
+		default:
+			usage(argv[0]);
+			return -EINVAL;
+		}
+	}
+
+	if (!threshold || !interval) {
+		fprintf(stderr, "ERROR: threshold and interval must be > 0\n");
+		usage(argv[0]);
+		return -EINVAL;
+	}
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	root_fd = open(root_path, O_RDONLY);
+	if (root_fd < 0) {
+		fprintf(stderr, "ERROR: open '%s' failed: %s\n",
+			root_path, strerror(errno));
+		return -errno;
+	}
+
+	skel = mthp_ext__open();
+	if (!skel) {
+		fprintf(stderr, "ERROR: failed to open BPF skeleton\n");
+		err = -ENOMEM;
+		goto open_skel_fail;
+	}
+
+	skel->bss->configs.threshold = threshold;
+	skel->bss->configs.interval = interval;
+	skel->bss->configs.init_order = init_order;
+	skel->bss->configs.min_mem = min_mem;
+	skel->bss->configs.fixed = fixed;
+	skel->bss->configs.debug = debug;
+
+	err = mthp_ext__load(skel);
+	if (err) {
+		fprintf(stderr, "ERROR: failed to load BPF program: %d\n", err);
+		goto load_skel_fail;
+	}
+
+	/* Attach struct_ops to root cgroup for mthp_choose */
+	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
+	opts.flags = BPF_F_CGROUP_FD;
+	opts.target_fd = root_fd;
+	ops_link = bpf_map__attach_struct_ops_opts(skel->maps.mthp_ops, &opts);
+	err = libbpf_get_error(ops_link);
+	if (err) {
+		fprintf(stderr, "ERROR: attach struct_ops failed: %d\n", err);
+		ops_link = NULL;
+		goto attach_opts_fail;
+	}
+
+	printf("Monitoring         : %s\n"
+	       "threshold          : %lums\n"
+	       "Interval           : %lums\n"
+	       "Initial order      : %d%s\n"
+	       "min memory         : %dMB\n"
+	       "Debug              : %s\n"
+	       "Press Ctrl+C to exit.\n\n",
+	       root_path, threshold, interval, init_order,
+	       fixed ? " (fixed)" : " (auto)", min_mem,
+	       debug ? "on" : "off");
+
+	if (fixed) {
+		while (!exiting)
+			usleep(interval * 1000);
+		goto exit_fixed;
+	}
+
+	/* Auto adjustment, attach cgroup iter for scanning root + descendants */
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, iter_opts);
+	union bpf_iter_link_info linfo = {
+		.cgroup.cgroup_fd = root_fd,
+		.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE,
+	};
+	iter_opts.link_info = &linfo;
+	iter_opts.link_info_len = sizeof(linfo);
+	iter_link = bpf_program__attach_iter(skel->progs.cgroup_scan, &iter_opts);
+	err = libbpf_get_error(iter_link);
+	if (err) {
+		fprintf(stderr, "ERROR: attach cgroup iter failed: %d\n", err);
+		iter_link = NULL;
+		goto attach_iter_fail;
+	}
+
+	/* Set up ring buffer for receiving alerts */
+	rb = ring_buffer__new(bpf_map__fd(skel->maps.events),
+			      handle_event, NULL, NULL);
+	if (!rb) {
+		fprintf(stderr, "ERROR: failed to create ring buffer\n");
+		err = -ENOMEM;
+		goto rb_fail;
+	}
+
+
+	psi_fd = setup_psi_trigger(root_path, "some", threshold * 1000,
+				   interval * 1000);
+	if (psi_fd < 0) {
+		fprintf(stderr, "ERROR: PSI trigger setup failed\n");
+		goto psi_setup_fail;
+	}
+
+	monitor_thread(psi_fd, &skel->bss->configs, iter_link, rb);
+
+	close(psi_fd);
+psi_setup_fail:
+	ring_buffer__free(rb);
+rb_fail:
+	bpf_link__destroy(iter_link);
+exit_fixed:
+attach_iter_fail:
+	bpf_link__destroy(ops_link);
+attach_opts_fail:
+load_skel_fail:
+	mthp_ext__destroy(skel);
+open_skel_fail:
+	close(root_fd);
+
+	printf("\nExiting...\n");
+
+	return err;
+}
diff --git a/samples/bpf/mthp_ext.h b/samples/bpf/mthp_ext.h
new file mode 100644
index 000000000000..33dc01bcebd3
--- /dev/null
+++ b/samples/bpf/mthp_ext.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __MTHP_EXT_H__
+#define __MTHP_EXT_H__
+
+#define CGROUP_NAME_LEN 128
+#define PMD_ORDER	9
+#define min(a, b)	((a) < (b) ? a : b)
+#define FROM_MB(s)	(s * 1024 * 1024)
+#define TO_MB(s)	(s / 1024 / 1024)
+
+struct config_local {
+	unsigned long threshold;
+	unsigned long interval;
+	unsigned int  init_order;
+	unsigned int  min_mem;
+	bool fixed;
+	bool debug;
+};
+
+struct alert_event {
+	unsigned long prev_stall;
+	unsigned long curr_stall;
+	unsigned long delta;
+	unsigned long mem;
+	unsigned int  order;
+	char name[CGROUP_NAME_LEN];
+};
+
+#endif /* __MTHP_EXT_H__ */
-- 
2.53.0


