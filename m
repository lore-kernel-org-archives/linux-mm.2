Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0443CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0346B0093; Mon, 24 Nov 2025 08:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260236B0099; Mon, 24 Nov 2025 08:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150686B009B; Mon, 24 Nov 2025 08:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 015E36B0093
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD4A088CF7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:45 +0000 (UTC)
X-FDA: 84145568010.20.6DA2D5C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0445D140018
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990624; a=rsa-sha256;
	cv=none;
	b=c5g+1NGcTk5H0xfg2tsU2Ps84qnDdstVjweO7Nj7xiwVdyl6eplslZ+Mev2NX6Do/1uMz9
	3xl807NfIqx9ou18hLvMsOnFgKyAClfFGfyHNB6EEDckUCdIFFNYI3h5875/9mxBkIlo5o
	me0mHptQauzPecjaF65MVydOoH56pvY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jExZlEjEWlKDII8zVlhggMN9oCUYrJUhrXeHp3m+zJo=;
	b=coTMpasPxSq4mhLdklIobdiSRZt9opkBmzBAHyibU//PJUncOMrpa2yRqfZCkFo89n3Rgl
	AB2Y7DjYlImUnv/7VWDIUZibpO1yd+0vGpydYwzPbSx0HSebcLl941OP3+fYMb4xIdREnr
	QDnGOhwcv8bfWDvhB8lfXtdmh3/lJfE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B13981692;
	Mon, 24 Nov 2025 05:23:35 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E23013F73B;
	Mon, 24 Nov 2025 05:23:37 -0800 (PST)
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
	x86@kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v5 11/12] sparc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Mon, 24 Nov 2025 13:22:27 +0000
Message-ID: <20251124132228.622678-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0445D140018
X-Stat-Signature: 8r5woum3pe1dq1qzx9xr7g3o4xt9tq1k
X-HE-Tag: 1763990623-130814
X-HE-Meta: U2FsdGVkX1+/NoFtEz+VTQD0M8Cq2x8YxKlGiBS6ZEnfrtSUWzPYGbF/ZGVWXiO30Lwjlzp1gcYbmIr1Fmc7kq1WJ3x3K07VmCVh6qxo+x8k/LCPyo2FMiy5u9ULYtsmmkt82veXJSC6Ml9waaZroc17WuRQ2EsRwBUFmqsKrK+7wpVhZ87sCb++gaUkTfj6/7iiZrgzTA0tS2Te1f5zDepiQNNREeLh3DWIyuVAV5hFP5r4Ox1lWoVaUlSe86FR4+t7qNGs0T7kYWOrhTr2IRetZKVL7HLbkaxLjmOjShisEVFCHAlgGQueviJkAq53VdCcpqjf6taXAmOard3f2ILUfK0dyChL++0WoxhdpoCt7G0Gr3ypAgOKXiD2uUAkVB/OoktuVp3KrSR+T8zm+/iy2p4gvcs2Us07KRmzzqykKIjfLcdomXxEi9SYP11loFnE91dLoyJYpxizW51MtaRtVkDlVEO3mMAF9y+L2yg8lEJ8W3gLzt55bkLq4kwMDLEzsaryWxFWSdEZq2sFXejw58H/3eX2j6QmPiANoJLZNI1brYFxEPm6afce2SJLOERZSMcV8hAfnnGG4o187B9or2PpeV5jhLQzpwbqyRpE5aSvcOgtWO/vC2AU20blI+9rBarO328B/v2y3U+3pfHfOTAs334cWOgtszRIXS2ThN82TuT75vsIjD49w0gYDGQrXJonRdIJB9Sw/8V4Inw11ZeiGQw42Cyz+I6tnH4m4168iqf2qNUdXxI1SCTfahFpWGzL7lQHZtnTz+su6fK229aLfsp+vi5bRTJvXHsmiITELyiGLVQiWzpvr0zAr6q6G4bRHYmo8i0mzFNNt0iIwD9FcWcdZoOsmn08/qAwxkXJl6NiMAVVdXLxghtM9aAhtaXo9UuhR89cZTbWkSz/vtBjdKDPvUQwuflWQBBMeH+k6+B/wLUe06ziKw+elMedM6bg2WqoE+zvjEG
 RQyv2xo8
 G6N/x5RgvRd9Rzk8T5WGQKErXFEtiBxnnMt1eWgAIgSXTs1/LrE6wJJoyARTJiwBTUBnKDl+E76BxkVDEoIuoZgqNuqJKzIzeueKdCtihOh9AGEGWbHTM8JF2dIpyhdN6h+ps4USdfQEEQd8czxaE58MrbBPysaRM7i+PTw161zqgdD6aVjI8rILLSR3BwnFHxcUtzHlYBJrsaWBupETwAOphzLmF4b3Xz5rkYgjEuy4JbLh2EC4G6CzrW5KpZz3rVaPWaR9NblmOuo5JcJFMs1RviluHr0Gll2IeAHnpRM5NJ3Xokm/6V0qgF72B7Wvo+Vc8G1aRra9+uZU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-CPU batch struct is activated when entering lazy MMU mode; its
lifetime is the same as the lazy MMU section (it is deactivated when
leaving the mode). Preemption is disabled in that interval to ensure
that the per-CPU reference remains valid.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. We can therefore use the generic helper in_lazy_mmu_mode()
to tell whether a batch struct is active instead of tracking it
explicitly.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/tlbflush_64.h | 1 -
 arch/sparc/mm/tlb.c                  | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 4e1036728e2f..6133306ba59a 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -12,7 +12,6 @@ struct tlb_batch {
 	unsigned int hugepage_shift;
 	struct mm_struct *mm;
 	unsigned long tlb_nr;
-	unsigned long active;
 	unsigned long vaddrs[TLB_BATCH_NR];
 };
 
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 7b5dfcdb1243..879e22c86e5c 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -52,11 +52,7 @@ void flush_tlb_pending(void)
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb;
-
 	preempt_disable();
-	tb = this_cpu_ptr(&tlb_batch);
-	tb->active = 1;
 }
 
 void arch_flush_lazy_mmu_mode(void)
@@ -69,10 +65,7 @@ void arch_flush_lazy_mmu_mode(void)
 
 void arch_leave_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
-
 	arch_flush_lazy_mmu_mode();
-	tb->active = 0;
 	preempt_enable();
 }
 
@@ -93,7 +86,7 @@ static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
 		nr = 0;
 	}
 
-	if (!tb->active) {
+	if (!in_lazy_mmu_mode()) {
 		flush_tsb_user_page(mm, vaddr, hugepage_shift);
 		global_flush_tlb_page(mm, vaddr);
 		goto out;
-- 
2.51.2


