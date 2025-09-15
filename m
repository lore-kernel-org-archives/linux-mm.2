Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E4DCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F073F8E0005; Sun, 14 Sep 2025 23:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFC78E0001; Sun, 14 Sep 2025 23:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7878E0005; Sun, 14 Sep 2025 23:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C350F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:30:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91394119E28
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:22 +0000 (UTC)
X-FDA: 83890056684.04.A8174D6
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id 561051C0009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wk3j2myo;
	spf=pass (imf21.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757907021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV55o1PrOMi1ewOa19IO6mFfTMCoyqv5bAgN6SrTF+U=;
	b=lMV7D6STsT1ptA7sWMproUNuv2BZHiwLfVAJdXGy5H7D6XzskF3jz8ziEYipfYbkRzgsml
	HcXjoEYZ9e4uZpGzihSkq4HKuj1mKFtjPA3qayuZ1BT45SE6KsQR+yIex0ed0G6w+MsOF9
	kbWYi8XFyKHk+SOhV8ZTsg5vobvbSe4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wk3j2myo;
	spf=pass (imf21.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757907021; a=rsa-sha256;
	cv=none;
	b=dhOSTW9ajJgWyp4DDyQpMMS8s0JKF+J6lhX0/7TWoOCYGcmfFhB1BjRGztBMCh53K3IhyN
	qKSduJtgkcHA/oXRbRAI6v6lS/lWAIJ7ca8ommfwyQcpDL6bYXg7vEHDGSZcAWs6i/tiEp
	JsNmBmi8g6VjYuLilcOE0y9r5+SSFWY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757907016; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=aV55o1PrOMi1ewOa19IO6mFfTMCoyqv5bAgN6SrTF+U=;
	b=wk3j2myo9GH5+xDPmX2vOWpcBIvXaxtopOu7O9ADgunYTN+v/Z1XQtg4zmnNk67hZek2QZCuop1CrWnBACGQIymo93Aa1Ep7a3cUAC/dAynb8D3Z2JaEi328x/oNvS2rPzKkiQV58WoGoflUNwMWWh9OjDrQ1cKxcYfQy43lS4g=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wnx2CMj_1757907014 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Sep 2025 11:30:15 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Mon, 15 Sep 2025 11:29:46 +0800
Message-Id: <20250915032946.33203-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xgqsxtm9h9b3dw886kwkr9u349my8aa5
X-Rspam-User: 
X-Rspamd-Queue-Id: 561051C0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757907019-631326
X-HE-Meta: U2FsdGVkX1/DjpUAD094dJHnrUQNM2/8yRdcT5m0yH4Novz5Xe44oG5uyOnxjONovV+9aqPZ+tGaLki+bzhFcvCkjd26hZGP6QZqpmS7UcJ/DBbH9ZqVrLw5PFicbiFgR70MP7AFY8sbs9cs5yf6VtDB8zG5th/ry7HjOYExo/t4l/30Ba2lnbxqx4l9x80RIjun75FFV1G08uH1D5rZm4LqQno8FBE/0JR6Yc+XbWBEbdIDC0bp6RwMctQcPSN5eq1eCq1TDbktRiOrwDtLhuPECYUjuZMyACRGrumi5ELvyGrenklXBkqlrYKoeiV1YSpOy6MFbUs4jX4FgIwwB14r1RJ0FsIiY37rQeqFisCG0OeibPM2SfXIM7PbSISSxMEGI0JA96doINn+5LtKAvqXiqolpk7rwmDJvPdu1u28hvGrxA651ZGBFr1cDXAaxpKcfCl/+JjdajXdiThpwY9vfNUcA4ngc9RrGbrQR17SWPnBY1saeePB9/WYyuHxPh/HhxHiEJFA60ybi3PqOeGwPujJdgZRFy2Mrp5u7SLIMA1vMZzIHUTmceFnqAMw+PiLvRm6HlLZr32TNQ/3o9dej5tpH8+Fvlg+gNsHX/pG9Dc2FKklHdTp/UQSrOit75J/DEASgmBfHYlxCEQuUFmpz73l7qogSD+6EfOeYuHV2trXF7k/LNpPSZzAMiC1e1IlkGQxUFQXi/OuMLN6S8dkNmp8294ysUyjphtYKbN/TbRIX9GwrkDOPME0mPkSS/xRFsaMS43GWiDOF1cnImTgE2iBdjRtyayudiZsGXQWynw8O8+/uuXDsswM4rSFHHSdWBHpxicrF7z4BhqH6cjhGvgQUIXsEXSwEco7SGu5xkg6j4z1bjhU6pBVy8pUXw0Rs9nMhpwZ0J73RMuIuDjIeajtJvEfRfaHepSDJ8PO6PSgYqdAtCI9Ph3KKNxJT60putx1z+VIgRYPm5D
 /cTF7weX
 YwdvuGrjuIWWj3s5FQSRKzzKYP7NGhNgcvsurssX+bd+LVZ4TvDijHKFCrDaQhj8sI0JRBfitQGL/O6Aylln1x5kq/swdlyBMjWdjkaJHunHSgrw9lnyRsz99wjv6w1/el0geuJ9k4zuqdy4IroAy1/gE6Xn48klZlBMOV3bJm0+/LeyAeImBUnVRdiOD1KFOaKZI8/Da8CxX604TcxGY8MEi3Ka7XApZ5uS13IaXipaqb7nOKIJui1wVqSWBuBAiJYl1W1MGAhEl1rNYQrpgWHW4Jczl5x0QrxNLuQGH0HiOO4KyuZBnVQOmZwXTYpxuGTsh7NtmHY624ABalu9NvoIYZExKazN44LEl8Ynl5cZkdfExuzdVpEVm4RmFun0vChIcSg8Cgd5l8stJUAYZ5R3oNE22/oKSSsUW86nkRDw/GQ/fAc5liuixGo59s+RtpflKBdZRO6qB0Ti7IaFvAvm42RgsLIHSEHl/aq8X4iLeUN9FMGgt2j8F2EQ5HWXroU8oCSK2xXkQCb/wdh6l8MjRHNLNGmdM2jKcjCoYymJIZI4Ukeq1vSB8rOhNsZV3q1v5S7PYP0r39i/ZvALyTqNHXEiU8QvOGmJyG0tWydc39OxKCL0st0CjxXuiRTVYA8h/3cH46iQLfqxq4nI32vxxX0yHws4DEtRZFBjdKqzxGLFr+OSw/dEz1qKAYjqJIXXu9IDoHPjZrwdOxsNqJUMj+lT3RLm/RKOkgYDnpv4lAdH+gzs/Sh4p8ZsIHYcnzZV9Wfy4INajgIY/MOsykR1yrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A multi-thread customer workload with large memory footprint uses
fork()/exec() to run some external programs every tens seconds.  When
running the workload on an arm64 server machine, it's observed that
quite some CPU cycles are spent in the TLB flushing functions.  While
running the workload on the x86_64 server machine, it's not.  This
causes the performance on arm64 to be much worse than that on x86_64.

During the workload running, after fork()/exec() write-protects all
pages in the parent process, memory writing in the parent process
will cause a write protection fault.  Then the page fault handler
will make the PTE/PDE writable if the page can be reused, which is
almost always true in the workload.  On arm64, to avoid the write
protection fault on other CPUs, the page fault handler flushes the TLB
globally with TLBI broadcast after changing the PTE/PDE.  However, this
isn't always necessary.  Firstly, it's safe to leave some stall
read-only TLB entries as long as they will be flushed finally.
Secondly, it's quite possible that the original read-only PTE/PDEs
aren't cached in remote TLB at all if the memory footprint is large.
In fact, on x86_64, the page fault handler doesn't flush the remote
TLB in this situation, which benefits the performance a lot.

To improve the performance on arm64, make the write protection fault
handler flush the TLB locally instead of globally via TLBI broadcast
after making the PTE/PDE writable.  If there are stall read-only TLB
entries in the remote CPUs, the page fault handler on these CPUs will
regard the page fault as spurious and flush the stall TLB entries.

To test the patchset, make the usemem.c from
vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
support calling fork()/exec() periodically.  To mimic the behavior of
the customer workload, run usemem with 4 threads, access 100GB memory,
and call fork()/exec() every 40 seconds.  Test results show that with
the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
flush functions reduces from ~50.5% to ~0.3% in perf profile.

Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 arch/arm64/include/asm/pgtable.h  | 14 ++++++++-----
 arch/arm64/include/asm/tlbflush.h | 33 +++++++++++++++++++++++++++++++
 arch/arm64/mm/fault.c             |  2 +-
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..a9ed8c9d2c33 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
- * Outside of a few very special situations (e.g. hibernation), we always
- * use broadcast TLB invalidation instructions, therefore a spurious page
- * fault on one CPU which has been handled concurrently by another CPU
- * does not need to perform additional invalidation.
+ * We use local TLB invalidation instruction when reusing page in
+ * write protection fault handler to avoid TLBI broadcast in the hot
+ * path.  This will cause spurious page faults if stall read-only TLB
+ * entries exist.
  */
-#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
+#define flush_tlb_fix_spurious_fault(vma, address, ptep)	\
+	local_flush_tlb_page_nonotify(vma, address)
+
+#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
+	local_flush_tlb_page_nonotify(vma, address)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 18a5dc0c9a54..607b67d8f61b 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -282,6 +282,39 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
 
+static inline void __local_flush_tlb_page_nonotify_nosync(
+	struct mm_struct *mm, unsigned long uaddr)
+{
+	unsigned long addr;
+
+	dsb(nshst);
+	addr = __TLBI_VADDR(uaddr, ASID(mm));
+	__tlbi(vale1, addr);
+	__tlbi_user(vale1, addr);
+}
+
+static inline void local_flush_tlb_page_nonotify(
+	struct vm_area_struct *vma, unsigned long uaddr)
+{
+	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
+	dsb(nsh);
+}
+
+static inline void __local_flush_tlb_page_nosync(
+	struct mm_struct *mm, unsigned long uaddr)
+{
+	__local_flush_tlb_page_nonotify_nosync(mm, uaddr);
+	mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
+						(uaddr & PAGE_MASK) + PAGE_SIZE);
+}
+
+static inline void local_flush_tlb_page(struct vm_area_struct *vma,
+					unsigned long uaddr)
+{
+	__local_flush_tlb_page_nosync(vma->vm_mm, uaddr);
+	dsb(nsh);
+}
+
 static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
 					   unsigned long uaddr)
 {
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d816ff44faff..22f54f5afe3f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 
 	/* Invalidate a stale read-only entry */
 	if (dirty)
-		flush_tlb_page(vma, address);
+		local_flush_tlb_page(vma, address);
 	return 1;
 }
 
-- 
2.39.5


