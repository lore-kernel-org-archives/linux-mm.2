Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B74C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1675B6B0096; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126A66B009F; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E956B0096; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB576B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9AD412011A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.17.014D902
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C748C0007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EywF5R3E;
	spf=pass (imf28.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=mKwt/jJcr/JgLgBfAx8Sy26Eyzgp0KlnKa6+T3sVgmwCsSP6fKqwac9YyxEP3Oc1z0/iSw
	ewnTr8GcMAI3/n75ghlDtd2uwKRR3W9L3ZDqEA5HjWg4Pyxdz/54HE2WVu2Pf2CRi0Hagg
	Yktu1PLkIVFXse2XHPPEXef5pRGkGR4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EywF5R3E;
	spf=pass (imf28.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEcX3HXLMzVOuLicTphBIj/R1Bu+Rm00Soec5tDKcys=;
	b=sp5hljJIeaaHeAx5GtjiTOX3G9BrantdNerpc6u1wxjsId7aPq+L4BOznNiduY50/L1THC
	TWHVRMYfrdhQdu/pQIBHoiM6Qn3HIHMmn0lR7FAqSLJY/fbUVuiXRYu9ZZ2vSYfL3KHbZY
	9zjMDacQHy+s7Oz3+uDw4sTvx6KUAiA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CEcX3HXLMzVOuLicTphBIj/R1Bu+Rm00Soec5tDKcys=;
	b=EywF5R3EdvPAq5zPDcW+XuVFbk1/bBUity+jgaldkQtH15J6yMmiQLRhCnW/+p3b8uDcX0TO1
	Ax6VCwo0moAgqjpzspUqI4gkuwNmyv2ejH8HJreRveH306WGRUQxS41RlGX/9zjTKTQij6rPkqD
	t9bp17Vo0C1A4fOiICCfyes=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KD2c0vzHnH3v;
	Fri, 28 Aug 2026 00:24:00 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EC9B40570;
	Fri, 28 Aug 2026 00:24:36 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:35 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 04/18] arm64: add arch callbacks for kernel replication
Date: Fri, 28 Aug 2026 00:11:44 +0800
Message-ID: <20260827161158.3618409-5-panov.nikita@huawei.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C748C0007
X-Stat-Signature: t1ykisq3cp5kgaosmkw157snqfmrorfu
X-Rspam-User: 
X-HE-Tag: 1787847880-347048
X-HE-Meta: U2FsdGVkX1+fXtD6Nctyv6SAx3m3Lj13B9NU3YBXGIkhB6K9tzoP6fYn0sPD6Ur5vkOs7E49NzTfLqcNXWvnfTKo2XGReqU8wJEjxFXSKX0voB04gPGG76nBlUXyBaz6ATpkcFTDJYRnbiWUMZDw72kHVfUpHxM+r02O4qAK2sIZpheYzHeV9rSP3qsc53XerzztPtBx3xhN7Cic0Uba246BI1cw7CNbJUi9S5zu/fuZARcUbINHv/9Ti/PQ4aHHI9wMB3s0FLtkq4sLMn3z0ajJPw3pAtzZHu8H3+nLsVPmnhLS+dZTE8+GqmUf3ll1itAIin3C6KBgc3TPpGD3DEO7iNGJ7H5hG6LK/jtO6cOJY/q9tse/47BMUXcbYx8g5hDRVdqs4kvEzOCaLT0OBXMp4PWFkBjkZeK+owKvAnbdO0ESngeQiAodLM6N5SmlqvEy2cSCvLc5pFTUZcocW30BBxLuIfZs/DeePBK5SQtdAN1HrzLIe1R1YHXu8eHu0oRlOYga1wtHr05tZ2zQVn/Mc4JzvzHBeqGV89ZUQnEC7+VylqZuSjVfxegX9qjBrYUH6dvBTpN71yuKiJSjrUppm5RTxB0tYYdSf7TYSASyv4DycUJ332O9oZhmTq0eq0Q9ODYXcAPnspIPivneBBBPhxEZRSK/u/o9c/5JvusGkQATfIj6DYzLE7FAyNCdkAsW5ywZXJWKTik8ZBvPxQT8m5EXj5SP9PpNa70XW4BIy/ZKwJR2S3DIbKAMCKGzQJxDI9Nz4YBiffCsPpVD/J6tnZFzUuzFyN99Bzt1zDuq6Vqhn9If67Uf9WSjhD0XO0jaom4SZtdyuea9jva3TntjbARhUWmetyhTjfyf/yrYiGWoOgJp2ejeDOI8hGzbDA6Fe0NLkdE+iH6Etj90tNeUXbayJ1mTy8K6YDKhdkm3mP10OARE2ngLgoU+chxc7FwuNDpceEE4ElC167+
 saiLEIJs
 IT+WDoK45ypAnikRaOK1+9eYDHr7TSO2f0ppA4+eMYWi/UTdQCgrOfFcVcT9Ph0aHmF/9mfmK4GA7JK9N/mMZ/BcbqSc7DVHPejXcyvTMjKJBw4ErDb3GZAo5UIuCCEtOPacQhFmnUhI2zNpMkWn8Esy2htYgZQ0+JN7UCaT6VvP+s3sSImWXyJlM5zEt+fIpm/XqfbPliwmj9NXzcuy+9skVwC9/zaMi58SvNZKOQaz72HZO/AAsiWCIAzJY/g74XlYQDyRuRKXV7zFNOwDVEw7ZzgquwIYdymH1V8dIuCBWy2GUKScvioWLxXd1XloN/nWsk395WRxXs16cOnr5rVKsydTVgvdX54iBo98ISo/scKNzaQLjOrB2LQDnayVrTfdOUAsyAPFYiVknRjPALmPzWkd8bX3Q1ShUJJgM6QNI7EmV/WdvWXcWT6EBjG+3BkJDIreOtYYwWunDK436AnAV4OMtxv23nY8upNCVN1WuGnwhd9huSVmiSQ==
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
 arch/arm64/include/asm/numa_replication.h | 54 +++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 arch/arm64/include/asm/numa_replication.h

diff --git a/arch/arm64/include/asm/numa_replication.h b/arch/arm64/include/asm/numa_replication.h
new file mode 100644
index 000000000000..441a399f9c51
--- /dev/null
+++ b/arch/arm64/include/asm/numa_replication.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_NUMA_REPLICATION_H
+#define __ASM_NUMA_REPLICATION_H
+
+#ifdef CONFIG_KERNEL_REPLICATION
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+#include <asm/memory.h>
+#include <asm/mmu_context.h>
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+
+#define PAGE_TABLE_REPLICATION_LEFT  ((max((u64)_end - SZ_2G, (u64)MODULES_VADDR)) & PGDIR_MASK)
+#define PAGE_TABLE_REPLICATION_RIGHT ((((u64)_end + SZ_2G) & PGDIR_MASK) + PGDIR_SIZE - 1)
+
+static inline pgd_t *numa_replicate_pgt_pgd(int nid)
+{
+	pgd_t *new_pgd;
+	struct page *pgd_page;
+
+	pgd_page = alloc_pages_node_noprof(nid, GFP_PGTABLE_KERNEL, 2);
+	BUG_ON(pgd_page == NULL);
+
+	new_pgd = (pgd_t *)page_address(pgd_page);
+	new_pgd += (PAGE_SIZE * 2 / sizeof(pgd_t)); //Extra pages for KPTI
+	copy_page(new_pgd, swapper_pg_dir);
+
+	return new_pgd;
+}
+
+static inline void numa_load_replicated_pgd(pgd_t *pgd)
+{
+	cpu_replace_ttbr1(pgd);
+	local_flush_tlb_all();
+}
+
+static inline ssize_t numa_cpu_dump(struct seq_file *m)
+{
+	seq_printf(m, "NODE: #%02d, CPU: #%04d, ttbr1_el1: 0x%p, COMM: %s\n",
+		numa_node_id(),
+		smp_processor_id(),
+		(void *)read_sysreg(ttbr1_el1),
+		current->group_leader->comm);
+	return 0;
+}
+
+static inline void numa_sync_text_replicas(unsigned long start, unsigned long end)
+{
+	caches_clean_inval_pou(start, end);
+	icache_inval_all_pou();
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+#endif /* __ASM_NUMA_REPLICATION_H */
-- 
2.34.1


