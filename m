Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A82CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445C58E0052; Wed, 29 Oct 2025 06:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D588E0045; Wed, 29 Oct 2025 06:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B588E0052; Wed, 29 Oct 2025 06:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 243758E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDE8B88F54
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:09 +0000 (UTC)
X-FDA: 84050731338.10.5DE146B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2573B40017
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvvX36phAp+peVOlxruWBCxwtzwfFIHoLx/bWBK6XQw=;
	b=vnP8TX+bofNyV63QdTy6Vp19e3IfiTda+v94rIgGUGqtHMIodgw1we1in/Vfu++JDMxxim
	QspzrLoyR/V7Wla/4bdi86sZDRmMpiYbz4j3Vs/cjzIOpaA4gqWjPDeBbjO6+X2dNvgK5b
	bxTpuQ/eUZqBzjFNjEsXXXIZMqzv5UY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732608; a=rsa-sha256;
	cv=none;
	b=mj2s/ngdBmeL+/PJWsuPNApKQCwrjD89AogFS1haRJ3yqvzd4fAnN/oMVQgeb0qpAy26bX
	+KVy8Yv9V5rV9I/fCcfkA+qONBZWfAy1Lw8DVnTzWQ7x9cw4VRGsn4jAtMfvvSz/gARNuY
	CFJH4y6LwkiWqU9X825y6i0yVBJYvQc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 809B12BCC;
	Wed, 29 Oct 2025 03:09:59 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BA203F66E;
	Wed, 29 Oct 2025 03:10:02 -0700 (PDT)
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
Subject: [PATCH v4 03/12] powerpc/mm: implement arch_flush_lazy_mmu_mode()
Date: Wed, 29 Oct 2025 10:09:00 +0000
Message-ID: <20251029100909.3381140-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2573B40017
X-Rspamd-Server: rspam02
X-Stat-Signature: 1gsbc78ykpnasgq5png6jqjwfgrreby8
X-HE-Tag: 1761732607-142303
X-HE-Meta: U2FsdGVkX18+/PJ6mKkFy56GMno3yqIrelV/88eyGVJH1huQoxLJGMqONs0dY9vIprSmD48jCEtUrhKcE0SDxz8H+sADehw0XP0e0lOyvQH3EG9j3Hzly8Z6FpKm2h28/pFe1QpOpLBKN6MuVi3xIigl+UjeEyAQZTi7GQQXK98npYk7hO+ymCnpvCqhHaJuCkhiQrtXo0hi9Objg3Tc+Kiksn/0WlTcu9U9rA5rfgEtOIicXsVgejI5/1PePqAIpaj22hj2dTZU9x9opKYchPGNy762W/JcUk7cc1rUQVeGiP70wEp/UwRYAHc5SIMp5nEYu6RmSIJVtCypwTq9u0xYa/gCBxQv6q6MmYUr+A+UPtCUGwEjXD4s/QGZjVGN0gXw14KSpnKfP5mm6j1at9Zubm7f8BQArcWVwOL44CN8t5lPmC3O3MpyHIzK+R0CgFzjbLvrXiMx/qh0dhwdEVMOyH9gkFZeK2i38BfDXXuphoPu9w58sArJ5p8W8PMbSKQNDC1l6frePwdNk2Kbx8QkcPK5cPX0SNqiLp1CtKCm8kUZDGC7NgNky1VdtevGNH+HbeePs905VhQaprmb2EggAHlPTRjQUORtMh5JFW0Xugfjyy1BYbL0ytM2lr6WuiGlZftiS2RvbHiklUul9zBD1PYs9CWgkFA75VCfUeKGJNRaZ5zKvEtft4viVIkGa1M6HX4k1emir27XOUcoLyigj+htY+hvxwa96NgLcgLHQYSh9yQwKsR0tlmaeKtyWVq8Ec4w4gR4gFou8V8ahFVVD2QXiCTOFG85b7IiJRcy/SnKjKIxTzzQPAkPY45+Fw1K2X5VeeZ/eCMFnfgwld1ygvO90BMEMpe9AqyE73gVI5KRDf5D/rar6K09rgBftbzEcl/txdXMg0Fx+45IfqydcNBes6+Oh3LuQ/5sO8vxPtUyuuyxRKcm/Equ6rOQgiCn76Amu8PnMnvfAF+
 jt7piU14
 ZK9q8L/qNWHKhmoqIUMXwC6SHU8lcPeneV8AemImYEPs35SNrGG/Di8C30NJT1FDsNMKLGiIMmNh5ZcHAwWKDab4/xaOjmjcU3s2R7Sf9yf5OTIkefi79q2ySLHXjrFSaYtlftnznmxCwg20yWdQjt9+HDlmu4CWRPYtoUxDcfF+C+NDwtaW5y6qTjee4L7gGC36FfetlrHMKiFU/EG3AH3sM09ZtxkreLGp0u2cOsYcHPJg=
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
 .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 146287d9580f..7704dbe8e88d 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	batch->active = 1;
 }
 
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	struct ppc64_tlb_batch *batch;
+
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
+
+	if (batch->index)
+		__flush_tlb_pending(batch);
+}
+
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
@@ -49,14 +59,11 @@ static inline void arch_leave_lazy_mmu_mode(void)
 		return;
 	batch = this_cpu_ptr(&ppc64_tlb_batch);
 
-	if (batch->index)
-		__flush_tlb_pending(batch);
+	arch_flush_lazy_mmu_mode();
 	batch->active = 0;
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
-- 
2.47.0


