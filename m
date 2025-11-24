Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E39CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9866B0029; Mon, 24 Nov 2025 08:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9A36B002B; Mon, 24 Nov 2025 08:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98B26B002C; Mon, 24 Nov 2025 08:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2E9F6B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86B3013032D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:01 +0000 (UTC)
X-FDA: 84145566162.13.D272D48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id DCFF34000E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:22:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990580; a=rsa-sha256;
	cv=none;
	b=1CXQZS/NrI5QZAAJ15R09aoNvMjTybeN/5kYT7hEp3Ux14wfXIiX9yL2bOuJOLf2wknh/a
	5u8zW8kYzUeyZ9WvE/JpjU/3bbWGDICBqe68u4EmmDt3pLGOJ10oxNzr63/6zmDgnfqvav
	PlgUNuPeURcYd47cNGvsweBzYJMIoMo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVgyfR//D2q7JroeMxNIl2TxTXsGcGIa5UzeM8XuVb4=;
	b=FP+SCkk3wh9EQ6fyhg+gXhm0UJYR6vFDc0+6fStr+CgE2zdbb93kOLB70lrJrSdEsJT/QI
	7M3N8CuiRvyeF6Vg1Z4jMPYatrJN4iS4lGvgAFstQ7ExvWEYnrSQGv+Gl2h6L0C0wqq0Gl
	APDQbNvdSAHlOsyTmO+n3MmDdPDpF10=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A86B71516;
	Mon, 24 Nov 2025 05:22:51 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0518D3F73B;
	Mon, 24 Nov 2025 05:22:53 -0800 (PST)
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
Subject: [PATCH v5 03/12] powerpc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 24 Nov 2025 13:22:19 +0000
Message-ID: <20251124132228.622678-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DCFF34000E
X-Stat-Signature: ixiy11dxinnij1hq5649tyc6uojhzu51
X-Rspam-User: 
X-HE-Tag: 1763990579-862570
X-HE-Meta: U2FsdGVkX19JuW617lrEIE6znuEyK/ne4r+0rfbGvb6yBScm2EapTZ6LsOBPzlL1PBM7smxGLZZ+ktVsDQNG6uXqX2zy/jtwdGKinGNtSEttlI2in5PzeQ3j1abErMwRtSx3aRsDLkiyMm3A6CcmsBFNlQtGB9hHRrsY7YCcRjTEaH7yLq4eFlP50dQ04v26b4PSjlvNxHosQmaPjLoGZbH416XELsattQ4xeOwYjaJBHwP23oRohoIj7TT8cZ8GaJe1wG1Q58d3FIQ3l7Am0pnOd1dxr5LklokhOmCEPWRg4ICLIziC+Uyz4+zgCj7dSVT7sUE239nS91OGoAfKJrs77fexgOJbxaxunk9L/c1R53RIO+OOqlXnP0ekibU46RbpqKYeNBdAIPxRInWZ8SQI4hH0rtHQHsazyESkzkrP/8al27FncgnCJAXOdWgGSnRU9r7KNoaebIxE9V5HjwBCvyPpbtXfHJSK6Wqp77sH2eJmJ14KwDPXJwjhaDT5XTE2uIt/V+N/3d1cp/t17QA4bFzOKo+Xe1VlIOgtCBWrOl59HhLkHL9+DmdWp0sfsAprYW7VZE3xAZWWhaE/rCQVB+fYEdtnfVPh05E9pS6eJtHfWgicdHQ3Y1BMojp7oituhfavDh2imZHA1lomBbEH6WeibK8PreuVZMdocw8Z+2tS/+9fKvB7xga0U5sSdgf9k5bIiNLcrsadsxRM72eE5AYT7I4zuWK4THjfA+SV6QLrxBZJ014bBkynPfSERHXnz+znvXtZBxejmHgZ7NuKruViS+d/728veHvlzRsDson40FyfRs4lgZQxE9vaZVyCfWKYKdhkAxScBJR1+VadND7Quv5UP5ZTBsAbeAIk71OJg5JKK9LX4dKILcFpzLaAZdxYvfDIsSm2WSkn2tBPiv2YtInK4y2ffiZYecrL2diXcB+QeFVdqdFolj1RArR+xtGuwdx5TFn1CUJ
 R+GQELFs
 PhzSHJTFVW66mYrRH8qEZ/flv8YA9MsWK5MdbsngheJHQxx7v3YVJp26nEWCkRK04KZy8TCtSIeznc+Skmfld5IycqMXXZewj3ocRRuOo6P9BUp2DzGqksmKo5cDfhfmXfIPEO5SkbSaZiMlAVmkBvFWLVm6/OZuTs2SwBe4JKJVzNz27IBNMHGg/thoq+Kvo04vmnOO/f1XtgQPCn+LkGCtjTrCEcci5OrvMb1Ptywyxz4eiiJd695pvM91u7YkK8VFOBToHMBtNhAwsdU2MNcPxkN9i73AmsgZY7bFoES7XWen+hzB1XV+vXcIeIHEz3IYQlWPTr4dV0nU=
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
arch_flush_lazy_mmu_mode() and have the former call the latter. The
radix_enabled() check is required in both as
arch_flush_lazy_mmu_mode() will be called directly from the generic
layer in a subsequent patch.

Note: the additional this_cpu_ptr() and radix_enabled() calls on the
arch_leave_lazy_mmu_mode() path will be removed in a subsequent
patch.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 146287d9580f..2d45f57df169 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -41,7 +41,7 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	batch->active = 1;
 }
 
-static inline void arch_leave_lazy_mmu_mode(void)
+static inline void arch_flush_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
 
@@ -51,12 +51,21 @@ static inline void arch_leave_lazy_mmu_mode(void)
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
+}
+
+static inline void arch_leave_lazy_mmu_mode(void)
+{
+	struct ppc64_tlb_batch *batch;
+
+	if (radix_enabled())
+		return;
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	batch->active = 0;
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
-- 
2.51.2


