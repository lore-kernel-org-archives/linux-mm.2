Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2614CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB948E0053; Wed, 29 Oct 2025 06:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492EE8E0045; Wed, 29 Oct 2025 06:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF888E0053; Wed, 29 Oct 2025 06:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 267CA8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7B1788F70
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:14 +0000 (UTC)
X-FDA: 84050731548.17.35FD5B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48DEA40005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzAmB3+ul/4CB3IEehlTd1PyNa8/CZkGLN+5p5/HgHs=;
	b=tMkozjFRfbj2E/XVxcZ0AUQ/XFZWSQvPiHvC/J13Qp2QbDJex+5FMbXPosvGM7ZS0KjPzU
	/ALRuZzH9MYdf9xMXdMUUzvzvPloANrbryLTmtXc9YKJl/k8q9nPRHIfo2CypbDQ2Ai9Kz
	XQH1B82+xnRM1DQ2VM1kcZucTCKhqxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732613; a=rsa-sha256;
	cv=none;
	b=QDTyrHp5RM1Sg9MfjSu4/VpnuM4Hfq6W/jTr72flSyTI0dEpzARVdt5FCbbiSos3m3C7QH
	ZY6xw3prwkE1VJlXDxAYUrXJ9c5szxTFR9/mt4blXaauIG3acUhbYYROBwMcGHYjn6TKG9
	RmMRUkD0ikHZxdTaOdzKtoJD2VCDnrg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6C832BCD;
	Wed, 29 Oct 2025 03:10:04 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A153E3F66E;
	Wed, 29 Oct 2025 03:10:07 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v4 04/12] sparc/mm: implement arch_flush_lazy_mmu_mode()
Date: Wed, 29 Oct 2025 10:09:01 +0000
Message-ID: <20251029100909.3381140-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 48DEA40005
X-Rspamd-Server: rspam02
X-Stat-Signature: 5r38r4rbf7qhsi5rzmp3t9q3rpdycrr5
X-HE-Tag: 1761732613-677770
X-HE-Meta: U2FsdGVkX19fJcAHa4qpuOgmRCIS7h+qJIx587tUiWk6duo+4ybqrPPjuzyadZTJuTMTJuU384S5qbDU9yiRVC32K1qULsOlD/71jEtkb4fzfWxiVkXJLMphlTItNKjJtQI0cxQir/d/2G7QNK3LE47deM1lszux3krmSccBufFAUyXV1LpMHQkE7b1umDeVl0gj1J4jWHc7Oj6cQZQQMt3W9lbPppxHvT4BAbvOo/OyCWD7X1azEiSIS3B6GKcgpY+bfXMQ5S53DnAU+tk78yJU6R0xXUuxnfLox4Nx6stKl9gh95sfpZJxw5JRMqVEkpGBbmXxgApIg2BLSAikxpyinlITSbG3Pv6YuB9NaOZRyZZcqav9tDRqWfM83NEwmuulL2Y895l+5oHObng19a7jL+2VheIoCO9GtqP9KV5kP0H+WDzIdyFmXucUhoYDjHDb1B1CCLi7LWo5fHtLcuiVayJ8+pp5StMNulqcvBASyj7uh8c4h8vLkJrk+a6Uxpi3VaUKZVic2mNwLmYHwgu/HIU4PfCbZjXgR3Jo1ne+fPaWWm1AN3pz86KqL08m5aX3dTV1cBeNQOFm+Go7WtQG0wjnNJ8TUpuMIVLl5rAAyW53+dxPkl8j/+B6va8eLqBvKht08m9ndM2UvA76efSBA27Zhgqgy5PI103vqxM+/w1Xg38gTMyf1yse7i9QH2A4mQ/nfangbJFqwaRHhdYzfdnZh2R7qBWEarkLo4ueXssa6gEqb9rW87dcJ6EmEdbwDNv8bqmg34fBGsAvy57t5WLeEGRjtt7kn9cDA092nJRXd8cKauyObegQfHjFllIbXYXzAuSzazPcQSJjeuTZpdGUgSoJ9ssYhu34H85SDtbT/i2pPPAPpHinzkl3yA4bBcbq84pkzFSXptWoprfWbnKk/i+CLV8oZDmFdbkWZ4hRPpcr8S+qVG7KcuaTmMFwVOF2wh51Db+wWBZ
 o6QxzLGL
 iPn108zA1CMQ38ZvEeZSEH788qREzEs1/UuhVcJjJpvTOD5YYKao8XXqSHQzOVXtQd553+AAEXtC/mFTYt/47V5NHhyPiWUBrCI6AlHDho3a/NTy3jl8Rhc0SMhnjPUvaVxeUJG260wHG7cFAmLFzDiohcmZHW+61x8Y/O3O6Wye/16d/DaL/nLBXBmvBO3EpFFnBNpcPfXXcSGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming changes to the lazy_mmu API will cause
arch_flush_lazy_mmu_mode() to be called when leaving a nested
lazy_mmu section.

Move the relevant logic from arch_leave_lazy_mmu_mode() to
arch_flush_lazy_mmu_mode() and have the former call the latter.

Note: the additional this_cpu_ptr() on the
arch_leave_lazy_mmu_mode() path will be removed in a subsequent
patch.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/tlbflush_64.h | 2 +-
 arch/sparc/mm/tlb.c                  | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 8b8cdaa69272..925bb5d7a4e1 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
+void arch_flush_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index a35ddcca5e76..7b5dfcdb1243 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
 	tb->active = 1;
 }
 
-void arch_leave_lazy_mmu_mode(void)
+void arch_flush_lazy_mmu_mode(void)
 {
 	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
+}
+
+void arch_leave_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	tb->active = 0;
 	preempt_enable();
 }
-- 
2.47.0


