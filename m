Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFC5CE7AE5
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A778E0013; Fri, 14 Nov 2025 06:14:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351F68E0002; Fri, 14 Nov 2025 06:14:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28EFD8E0013; Fri, 14 Nov 2025 06:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 182688E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:14:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A60AB13A9B0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:02 +0000 (UTC)
X-FDA: 84108953124.09.80003DA
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00C16A0013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MJ9Mpinl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118841; a=rsa-sha256;
	cv=none;
	b=IMBv5i5btx2ZmUhF4SO2pJ0uAGf8Yk9PEzfBeGNorZuRKaKwgm9YFB+u/22AI/u9hxnFlh
	CUJVNwBbVKu6zzogsvOVCzYkipGWepUywaogQWHUZerEwO/ks/q1zJd6Xk+tFzkmG1JqhE
	HzjN0ZAFHSyBJEiB7LmCIzCvVhFaNRU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MJ9Mpinl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sax8A8PA6ZHc/cVS+xTeKKlG8M0r3mfGW440vNjJZdg=;
	b=N3GS2l2ZXfzH65oB51OfjBFfnr/9fOZa70Wt6vo6hIjx9oL3ofOpWO2zK8AC6Ueqo2Y7ff
	zPAmJn3XQIq/T+qZZzLNm+ThklzXTjnaLVa6K6NRcmVC6QAvTkeDeLwOCYtq6rNtM8zC2Y
	BsaMXz4/vaPEQhw7zaoL+pDuNFRtaZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sax8A8PA6ZHc/cVS+xTeKKlG8M0r3mfGW440vNjJZdg=;
	b=MJ9MpinllxQ4TveK74NmYHIrtnuWysqMuo3kH1WtaJPOEfUFraWTOjeuO+qSEwJDbXunL4
	KzCwC7WMF3bErXcULhl6Hmst/RWmFUWC5WUQqMmKuZtOwbb3VyxdEl/g2hEf0Oms7Jx9kQ
	EAMJFMUorbF1pVdhYWTD7Kr5yAkEd64=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5/7] parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:19 +0800
Message-ID: <3a88790a662c2b84066c77772d20bd1f5f687f8b.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 00C16A0013
X-Rspamd-Server: rspam07
X-Stat-Signature: iyaw5uji1fquh4uhwwzw7y9mzb5gjdmt
X-Rspam-User: 
X-HE-Tag: 1763118840-362661
X-HE-Meta: U2FsdGVkX1+EfSKcKnxSmHNkwC/osesUETDR+SQq5bAUE/b3fojamV3se1wvtuyTV+LIOKSz0F9ViMiPf/m/5ocosgjXxZXSWEsa4Ol/cLwQQ6PHU4FA9G0AjXXVgf53g4xgU32KmYO10MMfcs21/gBRXoiixUey4CHYKVgyUo/kPr17xc1bZTSdN8jlEY29N+ZW3l/Zues4/Jxgn2gZct0JmrwkRJ8wDqhdt3ZB3O4e1Mbate2DlF3yi1Tk82AWsn7oesGYZ3yZU2siStxLE6b+01pdJLEqofJO9m4PxprGVz5PZF7UvYbCbLqxhJIddeCpiIJ2D6g8d6y7RB9Azhhk98sBJ6sRF/l3HuwH7iRq5ijM43Sc+PO3eN47t8cAe4OYFHVjR9CfkbQkNfVnG2kUoyk8KYaBfUPRIc3kvMdRkNGp7iT2YZKyM1dOC5lZUcrHhMt/FMOQUwkyLqu8ODW84cFGx8FuPRAy/qZoclAdZV1XUFH3AYXGeMtx/cywaeyIxwVwkIQ4dariz4Aj2gtIxoFvXXVv+jRi052khO01TdPGinvdkqcPtz7z8eUQM/KcIme08N5lIooxndf56DFVkBcQplzhkPExBF5JSWcF8Cvs/Ofal7wZ0iPt4JZsHmkpw9RB39AdpDCPYartnnDXEVIcrh+v7ex4Ommx3FCjBbW66abBKbzV8b6AIhoWpBEw4CvBMFt/63rGVeTJXGcPaq3CwWg6pXdvGV6rjVNrGLD+lzcfzWFB+MasN7R21/8enKi1OBYmvjAwwbfBmvmL7a/KzqWnFEkBVwUsMJbSiGB+KLNJWvZ5mvCdLZDVQhsqt7dDvkB0KW2+cfs+vMBw60AsOUSsoimm/TOw9t6dAhl4HbHnnagMlCLem/Vi/c7HAFYT3UEzpmIstUQg2EUse1NV7FDFsgj8t1I96cDeup3Xp4NU6aNgXChjw4ouqVWzCZ6G/L2htdUKaHk
 iEOwPKR0
 D7pdY2UbkzS7LtXHWeKJlKo23cDkWQWgf4Ik+GFqrslL9q32Y0F2DaZmiwcfDjj3IbDBzPJ95oKQ0nHjgH4FmTG8/hQMQTXqKJAqBt5X9PGb2GNGur4aTWD04stCYswVkEz9yJA04xWUCIdFoWdAGnQdYrzYgcYF1VvPSW/wzOh5/XsAWzdC9VkeupN8B+6w4/fLbFkBsbSvigBBRM1BrxyW99W3WkXCrbSkfGPKa+K1HVdvLezTdA4gIEhLTWszVOtJbsfb8UbU5nV3axVXXxViqhQPF7FA610Fy
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
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/Kconfig           | 1 +
 arch/parisc/include/asm/tlb.h | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 47fd9662d8005..946cbe21a4118 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -92,6 +92,7 @@ config PARISC
 	select TRACE_IRQFLAGS_SUPPORT
 	select HAVE_FUNCTION_DESCRIPTORS if 64BIT
 	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
+	select MMU_GATHER_RCU_TABLE_FREE
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/parisc/include/asm/tlb.h b/arch/parisc/include/asm/tlb.h
index 44235f367674d..ab7d4113df61a 100644
--- a/arch/parisc/include/asm/tlb.h
+++ b/arch/parisc/include/asm/tlb.h
@@ -5,8 +5,10 @@
 #include <asm-generic/tlb.h>
 
 #if CONFIG_PGTABLE_LEVELS == 3
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 #endif
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
-- 
2.20.1


