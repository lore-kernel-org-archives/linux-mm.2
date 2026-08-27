Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C81DC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965B76B009F; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9151B6B00A1; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803066B00A2; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40A7F6B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF300140114
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
X-FDA: 85147572846.13.CBC5DE6
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id B884A180005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JLBHyYAH;
	spf=pass (imf16.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=QAv/DdD9Xxve1Pxd95hinQnG4cpMV9c7lZsEhn/l6GhJek9bZJ6jRtLw7LhWYdpb/Bc45B
	XjjM/a2l07O/2JK3JCwA4tLdb3UvrJ5QHw5uoXtyOhPjAMUs3rlXs5pmkHn/KWv40XZ/wc
	vxnwfAikPC6Fl5Gdsh+KijnzPjkiaho=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JLBHyYAH;
	spf=pass (imf16.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNCReT8Lzve2ehkzvtK73NbFcLcN4IwvjOltd7sg6Kg=;
	b=ygkqMP3UbH2TwoG2xqCid13oQpwfjSWNsIHKTImR0QtuxnArjctM4XDZrpr4BahtXwBJgJ
	mFk52laohyqxLRrkxvlIPfiwOHypZ5iFSBKZj7yzl3AbTa2tybo8MEsP+46dBcR+6UQx0q
	y29vpJ5en8q+P4XOJqYGkDjkorro5rQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oNCReT8Lzve2ehkzvtK73NbFcLcN4IwvjOltd7sg6Kg=;
	b=JLBHyYAHtKjETVOWSQdRRaXKVmJlMrZo/0ndCMHzFlXt3vDgP2gdxYdssFZ4wAwCG6dV9MMtb
	JQbMX6trjFE7wWXqdyI1ynnBZ6QPKRw865Tiqf/uYnhHJiska3VMxXEcATghutitWDhxgKETTer
	pJol0tV+AUj0F9LOFfq2Oww=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KW2znVzJ469r;
	Fri, 28 Aug 2026 00:24:15 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id F01ED4058D;
	Fri, 28 Aug 2026 00:24:36 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:36 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 08/18] mm: set memory permissions for BPF handlers replicas
Date: Fri, 28 Aug 2026 00:11:48 +0800
Message-ID: <20260827161158.3618409-9-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Stat-Signature: 8hujqr5q4a65we777rbxn6or71uu9i3o
X-Rspamd-Queue-Id: B884A180005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787847881-587284
X-HE-Meta: U2FsdGVkX1/srYGmr90CnsCXK1JI1DwdM8dC94mIZwyvc69TuayUoCiDuZsBfZM+0xGtz38/z0v/xMcwiRWID3WQ5xdttf2sJyqBqPC4GY4xFsIks/71ioJYgnc9XhZTe2/qjFMLbbC2W4BCnb4Qnv95gvHBTuM6zuFziHkCvy8Q9C2VoIa01VuK6YO9cm2vd9tEOfufUmU+En1HdOuBZBLtJwHtCkjmZT0B9BmLGev2UKJ+G8VZSgHWqOp+eTkNuVMca+a9yJC3VRXCmLa8ZMqZRLo1VWnJBwHKbGiXclBzJGvrHBNFg8OyCTS6tNfrSZOa1zNON/pdvEBg+DuQj/lOli3KftDYy1uvXCQkvCh3uxrBwNIMQ3NzkvRTIRyVKjR/sq2QwXrLmFZoBr/4mKykyW5xvvlVSgFfZq60OJ6/qtc9TDVeSmPQXNaWjcagfL7dWJO3+kI6sYUDFlcKtS5qOOX3Gbk9Y3n7pNvT+ewFIc1lEL/LXbKqEh9SpuxSQt5EQ5jBFsVlvtKF6HatRanLpJussAWqmplzfU/qA6gd2Asvg61pM3IezMdVJDjOy8/Dv41jrHvKS6Yp2z3HQ+J8K9KrHReNzcGQPibh4EzYQ6eaYVUxbDqyOCuTlyA+2F9oKh61S2ab6uq1NX0bt9SvjkusUshrtFWjtORuh60nwTOpDio1I7sYX9wP2tVE4x/2HHQz+DNwi6AEM8pei9ByNIdiaQ1GCjR/BKgiQ9ASOABu0VRAGnZrbPR/gxA661BD73K7htHENU63XYJn/XDlhH73XRLT8GIv+DZbcIBLCJP45Kocz/Tg65++cVFuqr3SwdrB3YzC1L1n1FclSvWHf3foBK0WfZ6fA+zeyagx82exvJyAhaNhG9mBh7d/EYJNrWNfAJazct0lrtehNumOtk2eZBKpKW92xiHY1uM0kFh+t94nhnQ4uGsS2gBphZ6G/fuFRxKqYC7dNBl
 wRJFkX7i
 bbCi8fbYxzfD0Evf0kAVobsj3MBOqDBILhFahJ/4iJ1SBqVt0KTcu8vBRj+Q62k3oaRNYkOKU1wR6mHFwDATBckROo0osEtZ6+ARODy009J/kJzhHiOeo6AGz69XJKjQDy3bGMMbtRYvvYQ/xLjRuMIK1V1fKDHt/l+uIFpXYBtBD4RnhlSBKrn+KpJaS2pXF0XCs6ufRv1UIHkidEwOV7JjCbPCFBSaOLypchZc/aoAEGd752oNfKSUL9R1g2Z3Wepp3jvJY6Cb3ud7rVS310m5TW/9pA3vQaaqVcVogbxt/vryvoYfgCtGOn0xWj5gZRLxusRc83CTjtLmx2TFqLG0KFJ5qv+wTcX/LcrlKDRGHu+bl+lyAedKCSJ3GFZB0NgfykrNVxkrPuhM5M/QLqgl9F3ZOJhIWi1rBg86GuZ6ZWpypimc08NqUSMeUPz26ufZmbAQBWnxc6WXo9kOumx9xRijLnRnNx5W5nqKIceWmAgmSLzsUF8nVnlPptk9Fn7iuA24lRTPCmz4StuM4SkGA4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/net/bpf_jit_comp.c    |  4 ++--
 include/asm-generic/set_memory.h | 14 ++++++++++++++
 include/linux/set_memory.h       | 14 --------------
 kernel/bpf/core.c                |  4 ++--
 kernel/bpf/trampoline.c          |  2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index c18e005a41db..588d1b2a2753 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -3236,10 +3236,10 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
 		/* non-zero plt_target indicates we're patching a bpf prog,
 		 * which is read only.
 		 */
-		if (set_memory_rw(PAGE_MASK & ((uintptr_t)&plt->target), 1))
+		if (numa_set_memory_rw(PAGE_MASK & ((uintptr_t)&plt->target), 1))
 			return -EFAULT;
 		WRITE_ONCE(plt->target, plt_target);
-		set_memory_ro(PAGE_MASK & ((uintptr_t)&plt->target), 1);
+		numa_set_memory_ro(PAGE_MASK & ((uintptr_t)&plt->target), 1);
 		/* since plt target points to either the new trampoline
 		 * or dummy_tramp, even if another CPU reads the old plt
 		 * target value before fetching the bl instruction to plt,
diff --git a/include/asm-generic/set_memory.h b/include/asm-generic/set_memory.h
index c86abf6bc7ba..4c97978d2bfb 100644
--- a/include/asm-generic/set_memory.h
+++ b/include/asm-generic/set_memory.h
@@ -10,4 +10,18 @@ int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+int numa_set_memory_ro(unsigned long addr, int numpages);
+int numa_set_memory_rw(unsigned long addr, int numpages);
+int numa_set_memory_x(unsigned long addr, int numpages);
+int numa_set_memory_nx(unsigned long addr, int numpages);
+#else
+
+#define numa_set_memory_ro set_memory_ro
+#define numa_set_memory_rw set_memory_rw
+#define numa_set_memory_x  set_memory_x
+#define numa_set_memory_nx set_memory_nx
+
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #endif
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 03fccacef037..00b21d1c4331 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -8,20 +8,6 @@
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
 
-#ifdef CONFIG_KERNEL_REPLICATION
-int numa_set_memory_ro(unsigned long addr, int numpages);
-int numa_set_memory_rw(unsigned long addr, int numpages);
-int numa_set_memory_x(unsigned long addr, int numpages);
-int numa_set_memory_nx(unsigned long addr, int numpages);
-#else
-
-#define numa_set_memory_ro set_memory_ro
-#define numa_set_memory_rw set_memory_rw
-#define numa_set_memory_x  set_memory_x
-#define numa_set_memory_nx set_memory_nx
-
-#endif /* CONFIG_KERNEL_REPLICATION */
-
 #else
 static inline int __must_check set_memory_ro(unsigned long addr, int numpages) { return 0; }
 static inline int __must_check set_memory_rw(unsigned long addr, int numpages) { return 0; }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8b294dfc1ad4..854db8e9dcf7 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -939,7 +939,7 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 	if (!bpf_jit_mem_is_rox()) {
 		bpf_fill_ill_insns(pack->ptr, BPF_PROG_PACK_SIZE);
 		set_vm_flush_reset_perms(pack->ptr);
-		err = set_memory_rox((unsigned long)pack->ptr,
+		err = numa_set_memory_rox((unsigned long)pack->ptr,
 				     BPF_PROG_PACK_SIZE / PAGE_SIZE);
 		if (err)
 			goto out;
@@ -977,7 +977,7 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
 
 			bpf_fill_ill_insns(ptr, size);
 			set_vm_flush_reset_perms(ptr);
-			err = set_memory_rox((unsigned long)ptr,
+			err = numa_set_memory_rox((unsigned long)ptr,
 					     size / PAGE_SIZE);
 			if (err) {
 				bpf_jit_free_exec(ptr);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 90b70ea0d370..66656eb4714a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -1508,7 +1508,7 @@ void __weak arch_free_bpf_trampoline(void *image, unsigned int size)
 int __weak arch_protect_bpf_trampoline(void *image, unsigned int size)
 {
 	WARN_ON_ONCE(size > PAGE_SIZE);
-	return set_memory_rox((long)image, 1);
+	return numa_set_memory_rox((long)image, 1);
 }
 
 int __weak arch_bpf_trampoline_size(const struct btf_func_model *m, u32 flags,
-- 
2.34.1


