Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC76D5B17F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7156B0031; Mon, 15 Dec 2025 10:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256CB6B0062; Mon, 15 Dec 2025 10:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F86C6B007B; Mon, 15 Dec 2025 10:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE6DE6B0031
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F6CF13A4C8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:53 +0000 (UTC)
X-FDA: 84222027666.15.12633E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C89AB80008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811092; a=rsa-sha256;
	cv=none;
	b=MHWSDeExqUY5OSny2BqecvFCx+6bKDwhVp6x2yVD+LsFGHGcY38AfuJ9cqhFqqtaEBkpb3
	w7vVxLPSVp5cIcaxFb4twRM2cW/CPi+h2TE05sSzBwzMZH7BccQGTFv23BeDB0z6k3koup
	s512V9ErNjQ4EMwUBLowowJCu+HHdAw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xxSLVM+IHWkxynMc81b6HpOJrhDmgKn1o6W8d+VcpvU=;
	b=wAOUKDFABG+4Ogzx11Xnp46loH4oUBFzve1C0VRH5SFhKM1bDvnjKegwCkkSDmSKqcsTv4
	RgbiCSPPqWKlqUEb3NZqXCFyiht+JWsg/FgdkhguqqW9Hdck1jn4y+l/ABPkjDNqOnI4g8
	5hpXL7Rs3wWQYr1v18zR60BTy7qWs/w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3DCB16F3;
	Mon, 15 Dec 2025 07:04:43 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 858633F73B;
	Mon, 15 Dec 2025 07:04:45 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
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
Subject: [PATCH v6 13/14] x86/xen: use lazy_mmu_state when context-switching
Date: Mon, 15 Dec 2025 15:03:22 +0000
Message-ID: <20251215150323.2218608-14-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C89AB80008
X-Stat-Signature: w4mqjrsyfwzqccfcy7zbxsjwazfwwwqd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765811091-693064
X-HE-Meta: U2FsdGVkX1+jANCPuWRHRCQj+/Mhy77c6NQaI1K5F6OSYCI5LTDpY5nqFmv3+ypYIC/YUPbdZdJ/RsD8dbDJrswMz641Mqpnf4/k739ZH3UJWpjcp2ETkyIl3e5n5Paw3ljYHUB0a5K+beinWpbdQ0dh7w+jLR4COhnfoMWlSx700OGjSlS2I2lst1iIwRv4D5QdJtdksIlYNbv50VYfjoQG7DnvYTW+tTL56/JQbVXYJLIty4W2aPTBXhfRM8ZOao2P7hoeOhYuUt0WSwqIWd7tK56txRNCIUHUFq+jS6orcZj70aa69wayWJuwdSYlZrdOEs2rbHuM26g/eKAAr76QQ/cnO4geJb2GsjhGx1evTYZSlGYPbLnhXey15M5kjVZc/A6e4upIu50fyGiiqbQcyIeXmU+EV/T2jyK+V+uPVC3hq7SmDg8WNEjnCgagY1iqsicTi+g/P0M72vb3JldO3TWAZgeRRWa7Q2isfxrMyzDmxzrVqFXyWbX9l4Z659UbxrmIF7RUoNY/BxhMhky52FYfrdZfwLeFuF0AJbyK/rC9w8+xMBvolVnCwbSuKuyhEPPhdkML4d8hm0m8um7cnGp8BrdIEd35bYO6H8k66dlbDytCgGm1CxJL1vjzRuo4r6JUOjjprAHLQdja2uu+P19Ldp5NAchp73HifNT3SI9AWibLkpqbOMCJ91B6vXJYIeUZ5kbIAlgmb4ApNZkEOgCnjUcjOhl+UcJQtms8wMQ8M12Kie5Pv0DSwFPWNkxD3JaL+UDh82Ab0ACZFyEWO38BobajXMs5mqkjX5u2z0XQts7Q+In+sKXZpVDLL/fbdadL4IbCcgDxX3zjLf+5FsURa6Cqv2BP4afo9QNPeBFPf+bCD3BPF/1vwgu/N0SeLZj8j/KGf3r32s6j+h1+/hb7j59aHSzLa3SqXOkneuXkazuqHRDLJQh+NLuEv4NRlBsaxZuOV0Bgih0
 ftM5M0ed
 tgr6usmsS41yC9U+3M9mrR7qDgTgN0II+YpPX/yoCn3C/NpPTDfwJIMThVjr/2dCWcHAqomfCPVictdMB5yQ3wLrN9x+HysZGRdJFDypL15fhxQrMC2ITSu+vs9dI4R2VSkRLp9yqZ4GfzlyuvNlhZdxxbFez4FnfAXuDahDrAP1dMEsDRxSqhIjCrL7gUOjetxndA3BYlEKznR8FC9f5GzL8pUjQclKwcKeAVzzlcYCnDMlaUqgT6Afytsk+SEL/8QQqzOwmtrwJpQiluXXoYiILOK6nfcMapQZLQ6TN1zvfdeWzvNq6i9mc0ULbpm7QNku6u/TX4QvzY5jJuiD1H5G0qkbET6Z2DUPx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently set a TIF flag when scheduling out a task that is in
lazy MMU mode, in order to restore it when the task is scheduled
again.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode in task_struct::lazy_mmu_state. We can therefore check that
state when switching to the new task, instead of using a separate
TIF flag.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/include/asm/thread_info.h | 4 +---
 arch/x86/xen/enlighten_pv.c        | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e71e0e8362ed..0067684afb5b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -100,8 +100,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_SINGLESTEP		25	/* reenable singlestep on user return*/
 #define TIF_BLOCKSTEP		26	/* set when we want DEBUGCTLMSR_BTF */
-#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_ADDR32		28	/* 32-bit address space on 64 bits */
+#define TIF_ADDR32		27	/* 32-bit address space on 64 bits */
 
 #define _TIF_SSBD		BIT(TIF_SSBD)
 #define _TIF_SPEC_IB		BIT(TIF_SPEC_IB)
@@ -114,7 +113,6 @@ struct thread_info {
 #define _TIF_FORCED_TF		BIT(TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		BIT(TIF_BLOCKSTEP)
 #define _TIF_SINGLESTEP		BIT(TIF_SINGLESTEP)
-#define _TIF_LAZY_MMU_UPDATES	BIT(TIF_LAZY_MMU_UPDATES)
 #define _TIF_ADDR32		BIT(TIF_ADDR32)
 
 /* flags to check in __switch_to() */
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4806cc28d7ca..98dbb6a61087 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -426,7 +426,6 @@ static void xen_start_context_switch(struct task_struct *prev)
 
 	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
-		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
 	enter_lazy(XEN_LAZY_CPU);
 }
@@ -437,7 +436,7 @@ static void xen_end_context_switch(struct task_struct *next)
 
 	xen_mc_flush();
 	leave_lazy(XEN_LAZY_CPU);
-	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
+	if (__task_lazy_mmu_mode_active(next))
 		arch_enter_lazy_mmu_mode();
 }
 
-- 
2.51.2


