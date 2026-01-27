Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDE3D2F005
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65D66B008C; Tue, 27 Jan 2026 07:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26A46B0092; Tue, 27 Jan 2026 07:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D796B0093; Tue, 27 Jan 2026 07:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C795C6B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87412BD4D7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:31 +0000 (UTC)
X-FDA: 84377641782.26.82533AF
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9ADDD40005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xO2ohnEJ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjvVUE6PLFuQKn8iudCm/UQAhzXxbds5MAnD30p0biw=;
	b=41JnXlCBc7mnGgu5/CwmZOzJ79fXSxRadFLfz0k/Q2hccr49CLdLdU2/MSBmz27b9Pj44V
	Zx6VVik4jXH4bQ5wDDKy62TlnLkPImkcK3geAGVpjlWV0EywK7HeUWgGiNkFbdjnvuxVL5
	6sKVlbsTCtyWsHNGo9x0lLlWE14/JPg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xO2ohnEJ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516189; a=rsa-sha256;
	cv=none;
	b=glogQoRYECLYevY6Bk4/CqnGfvUzfeqtbG/NnkOGgbHvqZ3aewFb/kYhP8NZhBNWjbdjpx
	m59308OpQo9gze2H0uDV2FEb0JbO2Q+oBn9VzGjFF3XwShX3HgiytOOX2veZnoGQkDAR7g
	KRVaaFna2Vt2ba1OqN/EffRuUBGeijo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjvVUE6PLFuQKn8iudCm/UQAhzXxbds5MAnD30p0biw=;
	b=xO2ohnEJgOKRyNkG4Cwbt6Lp5Pd3P0WQhApWwjUgIK9wbWMLtrc5Kj+Sv2UwYxk+CDb3Ad
	KWmqiGgfLYLHLuqZQ8nKUidTKDgFbIO+JI75wDJ6MO926YTSF3yH8RoAp0rLN3hGVlvVlD
	FKkbFSoSRhVTR41853D/W5ny0Ls+MK4=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v4 3/8] LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:56 +0800
Message-ID: <bd1b11bc1a13686aeba81a40194f87b369d62661.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9ADDD40005
X-Stat-Signature: 83r5t4w6qjcicwnk3ujto6jc3p4fkwu4
X-Rspam-User: 
X-HE-Tag: 1769516189-53643
X-HE-Meta: U2FsdGVkX182AHskGBBI0KQlcX+LV/+wGEkZV/8ffBVEmtY0I4BLuziUtB5EP20FTBD3ki4KTHjG3mTBVLLYDsQlwl2YhJlbpzSNE9nPNirVJn50CkwBX/B/ME2NbMRQBi7jCmeSSix9ZzlNT2taghilQnDmwqXEL1J7RK6j3hrnTfd0OauUqhgBvqMi6+7IKWx83YSqvtumoPinQBEbpFIu+V/GfzPimo3K1vQOzj2T2+htJEtTfUKvTs7HfIvIwnnIvVxOMQ63wA4CQgYRR7jQj4wTyib4o8zNc8sLtOBQp5xZnwtMceN5ga7H/enpFc73bW6cfYx0Yh0Mj/+XMyZlk+z/FtdfreTZKjzNXUxtc1SDq0pg4xWdsf0Q2NOfQJ2c9pCHGvUT2ocVFU53XIx2Oi5vfySlmBYNyj2h6TcEyYs7fjoxju1FhNLEuf5ZLVIjgHt5zmq0boMZvYuXHBDss1B2AhwCET3Q9gtF2mHCsS43fNyfxD/it/1NlF6CnGlu3QyxGGYYcGn+7UjT6vkTywHrsebUgfMLV4cZ3IzUqPlefcCLbvnjX7/mKKrIhYqiF2dkthQosdn0YlkVlXlsXpjgFNGnLwNZ0sGKxJnFig2FB3yTY4kgvXMtRT1w+w3hFA6RRqzp7H1ereePmhP6ofes5wqgiI9uw5KOCmFNzfUJzM3Md6USE/gNLuXAfFb/VDrYCtaUkjBtyWRePdY+tqNtqT/0r+q5WED2NV1HG+uZHZo83xxAqQOm0UaEKzTY8narTuIrTUAI5iMYQcPqmOkk8yeAQrmzsFOhBzZ8OyftAqC31B56enD19Ts6LyNuhLujzYVvEhZ6Fy0Fc6xfQ0nfT1m72276zPqEaCLahsXUh+WH3Etx1NFZ15oJ0Q/4DbNXXbdvmfWxi3xRxL6yrbztgboJnN4glOeXt36Z0JUSop7bFsaCtj6VQmL94RPH9RkFRRQlCHol7Rz
 sJvCcFG2
 naqQweLT85whTLnBevjgbFajCQGgwd0/kdrk/M/jmrGOwYautqinkonCZzBZL65rUpqIenwQgq+UR+PSb4M1vG7t0X06UXyZxvO6NtKc9asmT7HXtFUmzcTruiNKBhu9ktCQ/02k3KuDQ1Af8xT0/O4AzWLhumHNL5/F7OCnkB2YrMi7MpO4HzsMsrHHvoB/SvfgDyaX3WGQfEInCzyDhM2xXGq5MTdtEsgKUdP6OERY+j2u3Z4Xt43phr2FV/Hhk3nbPe5j5cDwpIgNmu4bh4nXwre+FvAR+b25AD9j0TW49ECjwewVNJKFvftTQC28YTF4l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 730f342145197..43d5b863e1fb2 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -187,6 +187,7 @@ config LOONGARCH
 	select IRQ_LOONGARCH_CPU
 	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_MERGE_VMAS if MMU
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA if MODULES
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 08dcc698ec184..248f62d0b590e 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -55,8 +55,7 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 	return pte;
 }
 
-#define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
@@ -79,7 +78,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -99,7 +98,7 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pud;
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


