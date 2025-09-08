Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16E0CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FE28E0010; Mon,  8 Sep 2025 03:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9208E0001; Mon,  8 Sep 2025 03:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1048E0010; Mon,  8 Sep 2025 03:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAE218E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:40:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90D15C0A47
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:51 +0000 (UTC)
X-FDA: 83865286302.26.D0CED27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D43951A0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317250; a=rsa-sha256;
	cv=none;
	b=6TmGxms1ci3nRwx6SplZiT0IMXdw/lVORZfjwYOG/8mPzXRGwd+3i5+YCJ/wwchOMIPOUx
	quwhzWTCSxOcZdgfAmcpgEqSdgoioLdk3XmIElbzwG218HTen+trvQxHmigAja6R3IP+k0
	yO2T5el/sxYZ66oke7O5FfrY12AGtSU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CcBj7SkfGcRisUp144Doi/BeLUzFNWGgepHeyPHMYvQ=;
	b=aYjUWXf87/0whFJO2Zp8W6St8kP9yu1+z2fRI5JVOOOAq94sQhzNqcrYkUeRyEUrkJSfus
	A6wCLpJTXGX7q8JBtvjynrum3/ZZbHD/hviGtUVsCT/RFLifR/49L5ePA1aoKOVkou/ACG
	WKIi6b6t2eZUd1phd+vkTo+YDku8big=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEDB91764;
	Mon,  8 Sep 2025 00:40:40 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A6C13F63F;
	Mon,  8 Sep 2025 00:40:44 -0700 (PDT)
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
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 3/7] arm64: mm: fully support nested lazy_mmu sections
Date: Mon,  8 Sep 2025 08:39:27 +0100
Message-ID: <20250908073931.4159362-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D43951A0006
X-Stat-Signature: ub48oiywr9eobksu6q8kdp8a1dha3dpq
X-Rspam-User: 
X-HE-Tag: 1757317249-481732
X-HE-Meta: U2FsdGVkX18+S7CLF3WQPFacatSPQhWrCM2g++elBeOjED+z0NBA6GIYsM/XZQuBUXFVkh0a5TfHDphsD8hHRo2/OIbX/4dM1qDp/LfAqSEK1i+6lMHGVvNYUW/fAFSfHq9scpVIJHFJpUhqroXpgS/+V2GgIZN1IpuC5vQmsOWUF3EKnERjj2EuulexJdwu2PQwFZ9sCeAGVSuAdSrQogbo/Bu50V+VRNwLQMMwkAFvazkmDhk2TRwLZHmiAu+GdziEFciFU2oUHw+ZvuDjpnOCxN/g0tc7LhYXlBS/svf8H37eTDv4OU+PZTv7fNsKgFxNj9YK/o/351h9L4dGYx3k9CBqGx1Sym40JjYEfYpG4gtCfr4XvQyLNUqlNozLSy5vI0/UDNUz2NzJktN18w6Ql+6xgpkK4LUnh5mfRwrKB2awGkFZhuParrsHqPKxt7nRUbhsrhT+npo44ISyxOVh3AW/O9/1y8uTC7uz04UepP4yNsQ9Q+9zOoerhnc/QGPM1OkKodd/KfARQVjLxm7ZXHF8BrKcA8/mLIh1J0DEFx33MiyZuSb78hmgbq3/YxVE9Ka+gln3LUcAbPV587HwSBFGu2oOm8iahOtHwePfxnVFuMXbO4CqvAcHEFNq94pDqvrA24rV4Zw+wipgFk5cwLu/jH1viZHhEmZWADoBPAgfwuEx3O8ClYIl7tIl5hzqDMizalJs4QQ9NzWeJxGdjr9mJc9idyUS44HSINawzYJ4G5Xwgic4R/aexPU/jFnvRXZibCmS5jksIbWTvaYBA/1jcTdbOGmzWGLW57JtnoUcInKVRRAf5MALzRHJB2bE8XgFM42TfLMSvloak/mIgjZLSvoVqHuBN0sU8bPfoQ7xPDIy+lVSm06ZmpLkAOvkGtJutD5/yfakbQt9yKOcIbzpG/pnHXlGY9XlYmqEryGfSqyHcADI/NnHF41APydbpb6iHrJRgTICeJU
 g2z13BNH
 sdUuX6LBc2LfBhRMnOAstwWlrLmGWvQD89LeEAKHZdem1ozu7IO/cKp9/ptRLu+tOEDuHNQvsx/11HpQ17qSlLwaNSJTzY3kObzDp+Drfg72G+UOBLpabwS5hrJ2m+5P+gh6LmfchlMkEKPL3cj06jALtEZuLw3bfOHfGwdjLi2bPqVd73jzHXzmePZvQMtRM9RC+4K3A3BWOR00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite recent efforts to prevent lazy_mmu sections from nesting, it
remains difficult to ensure that it never occurs - and in fact it
does occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).
Commit 1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested")
made nesting tolerable on arm64, but without truly supporting it:
the inner leave() call clears TIF_LAZY_MMU, disabling the batching
optimisation before the outer section ends.

Now that the lazy_mmu API allows enter() to pass through a state to
the matching leave() call, we can actually support nesting. If
enter() is called inside an active lazy_mmu section, TIF_LAZY_MMU
will already be set, and we can then return LAZY_MMU_NESTED to
instruct the matching leave() call not to clear TIF_LAZY_MMU.

The only effect of this patch is to ensure that TIF_LAZY_MMU (and
therefore the batching optimisation) remains set until the outermost
lazy_mmu section ends. leave() still emits barriers if needed,
regardless of the nesting level, as the caller may expect any
page table changes to become visible when leave() returns.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 816197d08165..602feda97dc4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,24 +85,14 @@ typedef int lazy_mmu_state_t;
 
 static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
-	/*
-	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
-	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
-	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
-	 * permissions on the linear map with apply_to_page_range(), which
-	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
-	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
-	 * flush and clear the flag such that the remainder of the work in the
-	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
-	 * keeps tracking simple.
-	 */
+	int lazy_mmu_nested;
 
 	if (in_interrupt())
 		return LAZY_MMU_DEFAULT;
 
-	set_thread_flag(TIF_LAZY_MMU);
+	lazy_mmu_nested = test_and_set_thread_flag(TIF_LAZY_MMU);
 
-	return LAZY_MMU_DEFAULT;
+	return lazy_mmu_nested ? LAZY_MMU_NESTED : LAZY_MMU_DEFAULT;
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -113,7 +103,8 @@ static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
 
-	clear_thread_flag(TIF_LAZY_MMU);
+	if (state != LAZY_MMU_NESTED)
+		clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.47.0


