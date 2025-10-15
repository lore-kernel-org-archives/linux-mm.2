Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A414CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B008E001A; Wed, 15 Oct 2025 04:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812C98E0002; Wed, 15 Oct 2025 04:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FC88E001A; Wed, 15 Oct 2025 04:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6436C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3102C88BAD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:55 +0000 (UTC)
X-FDA: 83999673030.30.DC55EFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81357A0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Oc2Kn+68+9BJj/EDaEdJiag5mR/bu1km+1hhaHUolU=;
	b=CuZCmfJ9su0TA0Ecj6YjIjWgV/kmpZW7fc2aNeqR0IoJZlNCWiLpKZ1QJIDCeSMBd5XOgS
	n70KPc6EIpwp21RLmTyyxA/rh2/quBujCaS8m867yjQvgsIC1icVed6HLyDvTCzopvZW73
	nkOcD44EELyADToTrtky0StMPeCdu10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516933; a=rsa-sha256;
	cv=none;
	b=Cdxj9YQIVtaanB+CQZScIQzqSo7uUT3cVT9MiqDfJTKSiA+DmOtf0HYOeNbXd5NUXD3O+a
	jOQth6160/5QvmwSYAqa/EmUFzWPXa6tHrp0zma8PIXKew2qGPJEbOESE7kILnmrKUC2QQ
	c9mNeuNmNkg47iK2srSrtqqpQe5Qckk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3A1E2379;
	Wed, 15 Oct 2025 01:28:44 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF2653F66E;
	Wed, 15 Oct 2025 01:28:47 -0700 (PDT)
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
Subject: [PATCH v3 13/13] mm: introduce arch_wants_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:27 +0100
Message-ID: <20251015082727.2395128-14-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 4gzo7jjjsacagtpwi4dpjdjfxnpg8gtt
X-Rspam-User: 
X-Rspamd-Queue-Id: 81357A0007
X-HE-Tag: 1760516933-925719
X-HE-Meta: U2FsdGVkX1+pJEaRVl6ahKbhDJFA7XNqNq/w+O2W9B0kBamWF1SAiERPu6cdo3zWZWE+lS4oNhjjstHM0swBcbBmD313F/DvENI1W8gqEVfSI71cIrZEF2NO8K+MpCqoD3imwMj05q18ActnhGjNrXBX83yxrjyncZXH7xY+QXQvqoWtVpxEVAkxTBwaOZsQKeJk6FH5yxsw5nkUx4CSo1EMm4VpvWwB8O2tGJ1cQTbQspfnXUXN3LI10tB3XYHK/GICi5b2SVObgQy7tYSzZ58/sugRQ07n+boZMfPEDdqxKhktsUoDRFwZk4dl62rfSqd4a9wExWvHPxJeN8gpkKWeI+lk5JqbqQ5wPXA1CfHEH0Ml1d+m11Mea+FLK1M/TxMQl5BHeR8MlVEhRWZCfgRX3VLXbb8d/o09wIMJd8LwpVc0uxOdyCogoanV+s4tCw4xZ6fF/dnrHncV2JudAVudNhcObYY4nTN/pba8RYdKXaoZKwtvIkbRS+0eurzDdvQNVwcgh2zhKZRBc5QVvtMQnKsL8zI7NcnE+v3f/zjYKXgi5GlXXsHyKKWFYcnFlrDNDOGZLVaQTdAz4bZlUS7fgief6QGOpjDU+oVCos9Ll+RPnu0ZNK/3K55qAV/W0ey5B3SMz2LGDvbYcfyrBmWWoN5vSNkPSW7hU1NxSdL1cYo6tZ7+2e2V/Lt+Wa8oyqcAn6i0y5ZmELNEe5hgQ69lfTSX6PBtJ9sdI3s1o+BY6UfBzCUB2GBXsUMUDOVpb3e6vAZ7t7F7hOMHoBuDODvlcqfORbIc5nuDRE9rc8bgN5k4Lt3yoRMQgc2mUMdl2FinR6yxxtD4EXd5k36bwz1nwM+SUTyYPgkpAGVd6pdVrAd89iWjnW0kDHSswytDWNO3jKVpPLxR8RDHcLk+DzygdqOl4Baiyk7M03QcYGshI5NtdW2N7jCSwT9owBFVj756gKdekr8qZqw1/6S
 q6b5HyDg
 OhunNJmyax0DatSWT1BVOiayroR9lGD66xjMtBSmKFNKyjQN0y5j8kTyEQfAUBJ+ZBX6zsaA0NlXpCByLg6Un+uNAYi0dQIvTUFM7kcsm/WJc4YcoPWByRMcpdzaiaqhJ9f7DQdl/xdjsPCx2MBI1xPCwUmUm2rHJ6pchggYw2kOaiitdEDoTvDthgs7zG06ETM9PY9rWCkCVFqx+2TmJrdJd3uLEqW3Q8K9S0gRy49BGyNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

powerpc decides at runtime whether the lazy MMU mode should be used.

To avoid the overhead associated with managing
task_struct::lazy_mmu_state if the mode isn't used, introduce
arch_wants_lazy_mmu_mode() and bail out of lazy_mmu_mode_* if it
returns false. Add a default definition returning true, and an
appropriate implementation for powerpc.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
This patch seemed like a good idea to start with, but now I'm not so
sure that the churn added to the generic layer is worth it.

It provides a minor optimisation for just powerpc. x86 with XEN_PV also
chooses at runtime whether to implement lazy_mmu helpers or not, but
it doesn't fit this API so neatly and isn't handled here.
---
 .../include/asm/book3s/64/tlbflush-hash.h        | 11 ++++++-----
 include/linux/pgtable.h                          | 16 ++++++++++++----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index bbc54690d374..a91b354cf87c 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -23,10 +23,14 @@ DECLARE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
 
 extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
 
+#define arch_wants_lazy_mmu_mode arch_wants_lazy_mmu_mode
+static inline bool arch_wants_lazy_mmu_mode(void)
+{
+	return !radix_enabled();
+}
+
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	if (radix_enabled())
-		return;
 	/*
 	 * apply_to_page_range can call us this preempt enabled when
 	 * operating on kernel page tables.
@@ -46,9 +50,6 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	if (radix_enabled())
-		return;
-
 	arch_flush_lazy_mmu_mode();
 	preempt_enable();
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 718c9c788114..db4f388d2a16 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -261,11 +261,19 @@ static inline int pmd_dirty(pmd_t pmd)
  * currently enabled.
  */
 #ifdef CONFIG_ARCH_LAZY_MMU
+
+#ifndef arch_wants_lazy_mmu_mode
+static inline bool arch_wants_lazy_mmu_mode(void)
+{
+	return true;
+}
+#endif
+
 static inline void lazy_mmu_mode_enable(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
-	if (in_interrupt())
+	if (!arch_wants_lazy_mmu_mode() || in_interrupt())
 		return;
 
 	VM_BUG_ON(state->count == U8_MAX);
@@ -283,7 +291,7 @@ static inline void lazy_mmu_mode_disable(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
-	if (in_interrupt())
+	if (!arch_wants_lazy_mmu_mode() || in_interrupt())
 		return;
 
 	VM_BUG_ON(state->count == 0);
@@ -303,7 +311,7 @@ static inline void lazy_mmu_mode_pause(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
-	if (in_interrupt())
+	if (!arch_wants_lazy_mmu_mode() || in_interrupt())
 		return;
 
 	VM_WARN_ON(state->count == 0 || !state->enabled);
@@ -316,7 +324,7 @@ static inline void lazy_mmu_mode_resume(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
-	if (in_interrupt())
+	if (!arch_wants_lazy_mmu_mode() || in_interrupt())
 		return;
 
 	VM_WARN_ON(state->count == 0 || state->enabled);
-- 
2.47.0


