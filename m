Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BC1CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DFE6B0011; Mon, 24 Nov 2025 08:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3983A6B002B; Mon, 24 Nov 2025 08:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FB46B002C; Mon, 24 Nov 2025 08:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 157206B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7765130326
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:06 +0000 (UTC)
X-FDA: 84145566372.20.AD091F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A4EF8000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxflffJTh0pyYZvyWMeVPJtd+lYqkq24w2n0H8YxAm8=;
	b=CI4QeFJEmPs7SqyGnEQdhsqmmsv6vT0r7wMW3qyhCzeeJyNbvLOQHW9rrzcVsqt6Ddg6QJ
	n8y5MFJLexRsr7ZwhRf09fOeGjYx647QKzXYX7YZZXO/KaIzOn4cVy6zun2qoue7FAL5X7
	xu3i7/InhJUvS03QBb6yp9fJiCeFTO0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990585; a=rsa-sha256;
	cv=none;
	b=qTw1JA2/+mFySO+hlhM+LF1nq+xLrsqnDplDYpFSDCOWz1r819YJUFu4VjVLcdYG0Nn+lx
	ha764npJOeuuxOLzkil+CumqO8a/7/Pn0xPbzaZExWDa8R+stta37MIpP4Ooxpsi1RAcWv
	3zzpjUp0PV/zWR9mjQ18v3fZl2YRlQw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 282AA1595;
	Mon, 24 Nov 2025 05:22:57 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 787003F73B;
	Mon, 24 Nov 2025 05:22:59 -0800 (PST)
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
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v5 04/12] sparc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 24 Nov 2025 13:22:20 +0000
Message-ID: <20251124132228.622678-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A4EF8000D
X-Stat-Signature: 46i9dsuuyoqct55gd166fouqnad13ish
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763990585-860471
X-HE-Meta: U2FsdGVkX19CPfuHdUcfhKdX6AqLIxXgW93Xu3D53KuYMwKvRktJ7FRbhnEhvnyGT2yVV71tgT1n04DI9G1mne/5urGoBZ62rTEpY7BMBEW7AAw5kIyGr9kyi1EW90n2aTjZraGZJPW2J9uY/6apVhTu1+UOofBufEYeef7Ay5KI0UCT8qAgEOWfpUynx7trxHvk3608owrGApBkwqp4jq8sVLNvzA4W3ztGMTaEhCW62A7VREO3bhLl/JcoGignCajLSS9lksN/0C2N5KBvCW8vbOvEW01yaFhGlACl5A742MtiS6HRGmEQVILHzQTfGi1TP/0MKqkwteFJfCfmkbBc8jJefDgAiXQ1c+WtURf7qxvV0H508qsivfPlrW5M4uKc9QWh1oNMNBS+q/0JBVYJO5w0lJoL4C6vP3aFgsGxIuYqVt7btByyrr4CbfEY91xvg6rm8M4Nctu1v0mqcaNIanPacbP785T0bN4o8o8IosnD+hru/RjXBTrSvYwwR9YXZcHVKVaX2YKEz/l72sYR3BE97vJhn3DkbZwDboCavd6tBK/4128b3dzk9b/ZBx9D9n/lpAmnvnJYHD88SKWe8e2psUOCl5I08aYBxHtuG6QuWmSRMoJ3pJiKGsUbviOtv8LfJt1ibMAIQoix8iYkOSoGdEhzEUFnM47rpEKf7QC0Y1f47fw+dQQa408aTbVyUXQV/5rMD5ZQcQULRfEwW9+9SwoA/OGXYXavKGC49Si8avIAeTRLfsPqzxfR02RN9IYeAsvhGWQBfS4FRu6SASE8lOoNWCe30Iq/prtPzmqzEwyUgZbbP07SePHcgyqYpfRuhVBBzkkGSbru8DkBu5TPdmSgBoCZvxjtyzx/yDHq9drTALxxKIR/ZJwKNAMMo+u2lRfVUDsU7CxNHxuXSVe/L5eznUXJjWfqlbxP0ODBRML5qI51CM6r0yBbxx/rtfdQqrdPDiNpK1V
 Dqw==
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

Note: the additional this_cpu_ptr() call on the
arch_leave_lazy_mmu_mode() path will be removed in a subsequent
patch.

Acked-by: David Hildenbrand <david@redhat.com>
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
2.51.2


