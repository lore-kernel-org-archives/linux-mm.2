Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70CCC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8226B00A2; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71356B00AA; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A273F6B00AC; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560336B00AA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9C8AA01E2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.26.D2A8DF2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB958C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xLmUHxdt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAGNWJtbQb3AJ1HJQX61n/LHCCEcBpCaICJCBWpxqGI=;
	b=aicPv+4NtBjCbUsK0IWookg/gQmTAWjcF1TBvpnrW+7giGHExnwVXlwzfwQpQtbIiUki+y
	4Sy19uAbbJudj4QrGZPOQPimL1s4QTb19O3xYh7bBLfcjEuJq83ivotBsQCfGYlTq2atQJ
	RZ6u7jXQZgWyCugkWu5bnkMrNKgKHFw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xLmUHxdt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847884;
	b=MaGHpR4uAYIvpRTA1LHCPO6z29ZDSmrGQVgEHF/mknjO8iqjP1JYjgHD3/12pJN+Rv81Vm
	u8qxQJHzjtSseatb29izwJQlVvdLg7SZjNWn34JrYQh3KUpPFLhl1JdYyCDv/C35PAvdm4
	Ry7J6GIb3Tw2p1uNRT4yDPbzIufwcKg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xAGNWJtbQb3AJ1HJQX61n/LHCCEcBpCaICJCBWpxqGI=;
	b=xLmUHxdtznvn14bKKb3Ae8Py9BGbsGZqW/mdynm2ysF18alkLLyUC/mTjbs9FM+IA4EMsY9Eg
	zCsPR8FkLdAC+gJ2+MTxLuwMlQQc1uJIXoR8zHE4WD/zGUWFsZXsiVf3Rr2lo/hmf4hDucR9LZt
	dUOIyHkNGI1TeXQ0Xw9IW6M=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KF4jbczHnH3h;
	Fri, 28 Aug 2026 00:24:01 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id A74DA40572;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 13/18] arm64: make kernel text patching aware about replicas
Date: Fri, 28 Aug 2026 00:11:53 +0800
Message-ID: <20260827161158.3618409-14-panov.nikita@huawei.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB958C0009
X-Stat-Signature: g9rq67dadtq6trmri1kh1jgaq63mcjg7
X-Rspam-User: 
X-HE-Tag: 1787847883-441823
X-HE-Meta: U2FsdGVkX1+vTAqHTS2722KT1sxuESk9jmkjA8OsfwC2NADzz2pqdT2IZu6m0mqO//gUb9SizWC2adXU+Lv0cgCF+SqIyjXy76d9jkigd4lK3TICH9vLkril/he2/A1vZ/YGXb5WmGsCaaOEPpb41IQzWQB4WI2UuSn+eJe81ZjolXFsVIOwp6vqhPQWLqq6NfnX6W7Id/6D73Yg052fsPuKXbXpBxNN9XIkHJbTWk47sXptMjmfMeZDlEfrkEr0/Hcvw+IYd5dVJgiGSXwn1l9qrLrTzt+XUlLVnzEXdkLgCSEdXyDG2LvoOhRRpyJyE6bYTfSrq2Lj+jqOh1ilUAXelP/WgRY6S1+XEA8fTrNUtN7xFqxUfp0yS+qfkM8SK4NivlR940fO1aLwudZKC65MUXE0zrQ7eCsDQO5n2BHY+atxg07G1CgJm7kh2rxlyjjl//mn2fENSQxU2mScUhunrqg7zoGMoOoTaDCJ2z0tm3GEEjsifdMKA0vVcddq4BVWw9ZDWgsoqrC1RdW60c1oeV+qpDqG+gXMVmmq6xzaGl7039/9KFt0yRw+yw5FrSXOmU9Jeub75om63Uji93lN117YyP6s5pCm10NaSIeCZEsn9JAujnnul9gtz3B/g4P+ORVkujzcRVQA8C9U/QFA2b1n6Z69/tfp2QpdfcOiotc5OrTMun76xLWvu6mdb/iIB+XOhN5Y/ZQGo1PJAi/EJDn/6JifZmvl2BI0XbfgHjg1Ap1P2Z5HTP9MhJSWgl7PpshfHlSh6c+QWVkA11Trf4maVnqMgBpL2Nwy3+5S5cPZGLuICxMUN5G+djliSDqBBqJtUNTDcKcp+gi+8itixwH0RsEYXaNgUzGmhxs/j243nyQ/30jiMnqhNVD8Oqk0h6A3sgmULDGsUJlU9tzvrxm24gHq/YyWRnwnU9yIAjC2OmPcCjXmPM/+2a2BZ3b615qVrPZ/8C+HNes
 +QHyjULM
 ZUMf0D3NqV71SKim7iAMvBE3J9GvlJWuIFGn3fetVQ/WrQqJUvt2RQ2FvfmkguQzmm28miPodsyQnWnib7m4SV/CkWMk90YqiquNjrP5tOhX+etKMMyMQ4G9RSxR+IsSAj/W5ZBdbakSF6bOzwCHxlpNvurJFWmwixVlGGPlkryZx6sdxBCxfpFXvH1O+P+gHlC7nHM/c3HBbY0zthd36vvMVl0SYP+5vTx5Fbue2eME9dxxBYYfWESknTFunh8TQOHf8AVpMfnhpnn74/O9BDhNamZFTdYdaMmwxZt3O8yl7vH5C/gKWMGNX0RHmWMTsF3LpAJZIU6Dwb3Wj6xSFZ2M6BxlRM28CAAYeNWawA4sryNrCjAzUW+T0wx4N++5w8+5lePeBudj09SdoyAr4qkqK4T/Mv5MCE0XW5cQiKJyknlciq7bHhnzBBF0s18ydsoklO63clBwRhAxJA6exT77v0kFvvzqFSt8rmqmZ+1T0t8JR5tvqaR+FqA==
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
 arch/arm64/kernel/alternative.c | 33 +++++++++++-
 arch/arm64/kernel/patching.c    | 96 +++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index f5ec7e7c1d3f..e85644d64bbd 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/cpu.h>
+#include <linux/numa_kernel_replication.h>
 #include <linux/elf.h>
 #include <asm/cacheflush.h>
 #include <asm/alternative.h>
@@ -139,6 +140,36 @@ static noinstr void clean_dcache_range_nopatch(u64 start, u64 end)
 	} while (cur += d_size, cur < end);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void __write_alternatives(struct alt_instr *alt,
+					 alternative_cb_t alt_cb,
+					 __le32 *origptr, __le32 *updptr,
+					 int nr_inst)
+{
+	if (is_text_replicated() && is_kernel_text((unsigned long)origptr)) {
+		int nid;
+
+		for_each_memory_node(nid) {
+			__le32 *ptr = numa_get_replica(origptr, nid);
+
+			alt_cb(alt, origptr, ptr, nr_inst);
+			clean_dcache_range_nopatch((u64)ptr,
+						   (u64)(ptr + nr_inst));
+		}
+	} else {
+		alt_cb(alt, origptr, updptr, nr_inst);
+	}
+}
+#else
+static void __write_alternatives(struct alt_instr *alt,
+					 alternative_cb_t alt_cb,
+					 __le32 *origptr, __le32 *updptr,
+					 int nr_inst)
+{
+	alt_cb(alt, origptr, updptr, nr_inst);
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static int __apply_alternatives(const struct alt_region *region,
 				bool is_module,
 				unsigned long *cpucap_mask)
@@ -174,7 +205,7 @@ static int __apply_alternatives(const struct alt_region *region,
 			alt_cb = patch_alternative;
 		}
 
-		alt_cb(alt, origptr, updptr, nr_inst);
+		__write_alternatives(alt, alt_cb, origptr, updptr, nr_inst);
 
 		if (!is_module) {
 			clean_dcache_range_nopatch((u64)origptr,
diff --git a/arch/arm64/kernel/patching.c b/arch/arm64/kernel/patching.c
index 09f019c6547a..8bac14198459 100644
--- a/arch/arm64/kernel/patching.c
+++ b/arch/arm64/kernel/patching.c
@@ -5,6 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 #include <linux/uaccess.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
@@ -15,6 +16,7 @@
 
 static DEFINE_RAW_SPINLOCK(patch_lock);
 
+#ifndef CONFIG_KERNEL_REPLICATION
 static bool is_exit_text(unsigned long addr)
 {
 	/* discarded with init text/data */
@@ -42,6 +44,17 @@ static void __kprobes *patch_map(void *addr, int fixmap)
 
 	return (void *)set_fixmap_offset(fixmap, phys);
 }
+#else
+static void __kprobes *patch_map(void *addr, int fixmap, int nid)
+{
+	struct page *page;
+
+	page = walk_to_page_node(nid, addr);
+	BUG_ON(!page);
+
+	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) + offset_in_page(addr));
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
 
 static void __kprobes patch_unmap(int fixmap)
 {
@@ -63,6 +76,28 @@ int __kprobes aarch64_insn_read(void *addr, u32 *insnp)
 	return ret;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static int __kprobes __aarch64_insn_write(void *addr, __le32 insn)
+{
+	int nid;
+	void *waddr = addr;
+	unsigned long flags = 0;
+	int ret;
+
+	raw_spin_lock_irqsave(&patch_lock, flags);
+	for_each_memory_node(nid) {
+		waddr = patch_map(addr, FIX_TEXT_POKE0, nid);
+		ret = copy_to_kernel_nofault(waddr, &insn, AARCH64_INSN_SIZE);
+		patch_unmap(FIX_TEXT_POKE0);
+
+		if (ret || !is_text_replicated())
+			break;
+	}
+	raw_spin_unlock_irqrestore(&patch_lock, flags);
+
+	return ret;
+}
+#else
 static int __kprobes __aarch64_insn_write(void *addr, __le32 insn)
 {
 	void *waddr = addr;
@@ -79,12 +114,37 @@ static int __kprobes __aarch64_insn_write(void *addr, __le32 insn)
 
 	return ret;
 }
+#endif /* CONFIG_KERNEL_REPLICATION */
 
 int __kprobes aarch64_insn_write(void *addr, u32 insn)
 {
 	return __aarch64_insn_write(addr, cpu_to_le32(insn));
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+noinstr int aarch64_insn_write_literal_u64(void *addr, u64 val)
+{
+	int nid;
+	u64 *waddr;
+	unsigned long flags;
+	int ret;
+
+	raw_spin_lock_irqsave(&patch_lock, flags);
+	for_each_memory_node(nid) {
+		waddr = patch_map(addr, FIX_TEXT_POKE0, nid);
+
+		ret = copy_to_kernel_nofault(waddr, &val, sizeof(val));
+
+		patch_unmap(FIX_TEXT_POKE0);
+
+		if (ret || !is_text_replicated())
+			break;
+	}
+	raw_spin_unlock_irqrestore(&patch_lock, flags);
+
+	return ret;
+}
+#else
 noinstr int aarch64_insn_write_literal_u64(void *addr, u64 val)
 {
 	u64 *waddr;
@@ -101,9 +161,44 @@ noinstr int aarch64_insn_write_literal_u64(void *addr, u64 val)
 
 	return ret;
 }
+#endif /* CONFIG_KERNEL_REPLICATION */
 
 typedef void text_poke_f(void *dst, void *src, size_t patched, size_t len);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void *__text_poke(text_poke_f func, void *addr, void *src, size_t len)
+{
+	unsigned long flags;
+	size_t patched = 0;
+	size_t size;
+	void *waddr;
+	void *ptr;
+
+	raw_spin_lock_irqsave(&patch_lock, flags);
+
+	while (patched < len) {
+		int nid;
+
+		ptr = addr + patched;
+		size = min(PAGE_SIZE - offset_in_page(ptr), len - patched);
+
+		for_each_memory_node(nid) {
+			waddr = patch_map(ptr, FIX_TEXT_POKE0, nid);
+			func(waddr, src, patched, size);
+			patch_unmap(FIX_TEXT_POKE0);
+
+			if (!is_text_replicated())
+				break;
+		}
+		patched += size;
+	}
+	raw_spin_unlock_irqrestore(&patch_lock, flags);
+
+	flush_icache_range((uintptr_t)addr, (uintptr_t)addr + len);
+
+	return addr;
+}
+#else
 static void *__text_poke(text_poke_f func, void *addr, void *src, size_t len)
 {
 	unsigned long flags;
@@ -130,6 +225,7 @@ static void *__text_poke(text_poke_f func, void *addr, void *src, size_t len)
 
 	return addr;
 }
+#endif
 
 static void text_poke_memcpy(void *dst, void *src, size_t patched, size_t len)
 {
-- 
2.34.1


