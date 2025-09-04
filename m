Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11980CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8D98E0017; Thu,  4 Sep 2025 08:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669FA8E0013; Thu,  4 Sep 2025 08:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5314C8E0017; Thu,  4 Sep 2025 08:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B6B8E0013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01D19139D20
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:47 +0000 (UTC)
X-FDA: 83851572336.04.0883763
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 362EF180012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990726; a=rsa-sha256;
	cv=none;
	b=cPV7W0Hqln6m0S4zmXDvijf0wkc/a95Y9+mR+ZwFZSIyJYTHyrFMLBMjq+UGPNiYJFw0ID
	b9OBnN3X6AicVUmf4lJTl+Kz7NknhiNCbsHIVzkTMNrDj/2tzMzwI5CY0dW042eouZnfQq
	1qTijNICLX9l73bjZKdshMONeJ9Gf7U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0BUJXONwqTBSysHPr42gCRrrCMl1Y1aaFX8/rMouS8A=;
	b=v1tOjTSlvjWyjF/5rn+VUMTGKCFABXZfdwNSvoF0S8CKAfGlZ2EoD9Tvzl97SP/w919wqS
	M7goNh70sqB6qa3U+3Kz3uQpqD8zhMnf8h8TlAt7XWzoHUftjA/ZNP2Ip6z6mWfvm8Cbdq
	Pc0VnSBJuPN+BAkNC0Dl8cYm7qmcsBM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00A6F2ED2;
	Thu,  4 Sep 2025 05:58:37 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0CAA3F6A8;
	Thu,  4 Sep 2025 05:58:40 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 5/7] powerpc/mm: support nested lazy_mmu sections
Date: Thu,  4 Sep 2025 13:57:34 +0100
Message-ID: <20250904125736.3918646-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 362EF180012
X-Stat-Signature: kh4sm3hckrh5tteiqp11k71n7iu55c1g
X-HE-Tag: 1756990725-585707
X-HE-Meta: U2FsdGVkX18HCeyQR2yLsa5xKd9L6A9cY4L0yxUAqeRayLeYzIH5k1LfsI23e+oSFpngVoh5/qEDdXPD8NTApfMk0E7bAC3Su16BSwU9vojzRkfniL1Q5Blc3O+kHEk9k86TN531DX476+7m8PHhhvCgGtLnssetYAvAuEeTJs4EIlFhP0H8v2HnRHpxl1OyeBVxkG2nrgM2bW+gkOJF4XQUQH0zP1529WZNOz/imaI2LILNxGqSUCRRzCnE7jouc7k8az3ykkaqUQDNyBonHSs39oGcFFE+Bk+03frHGHNt5s22Sxmg22R+9cSnQyVops8hWOvXPf3WKFycvc6DkLRzKchPMJAfLtJ8kedldFdDzCHzgGfN9BoyePnQFULEzQgsNfMkH9TNIo2G/htC2GXfVf6TA1iLeIcitVFuwGJ7cHILNJf32NL+vBpjPHebCBY9kcPyOVtlLcBBGAi77qjOCz3wSN/XejAmkdS7R7z8UIQx1M/GhV3HHRdEwew5TT/fatrWK+ZQ4d+PRLfvMFrwE/kekyUi6xfY6F9CIBLTvshLKgQYvZF3+jCU1XiP+Z/BgX7rImqkelVeibQf0mREEYLtEnB+xVbSgUkmTIoKK1HCUNy8IEOOp/+kP2w1jZX1gTaIIx3D46nLAoTxFNnTcccrfGFRCcSjGa4cC1tBLUS1vHVq8WcB4tTPiABYnjkPfAUunvb/HvJf2MNocJ2zbVh2VORPYf/ND6oT6F9M5qpPOaqGfWDmk6qSD4oRoyw265bYhI7VaL9J+MEgOHyQIcyizEEGQXBuwjQJL2R1BvnqMG2dOLjAl/SU8Wal1aT83VDE2RH+1s/6yK9+vWV759KM6p2eji4Wrn5aHtKtFDuNoMTygxkp+4qwZ/VdV+gbgXmorP8Rq4EiONvPcAziUhc/MvMHXJCbdVZU6Q341OAEciCsoDp1hJC9Rwrr+0cO+i37tiK3KWMa+bu
 qri8IjAZ
 GVHQPst6fODCiA/gsVNNbde4j8qtsyru3kfDE+lshSfR3XVd+feaqKA/DPcAAxwvgQuqfq3iNfB1P44UTsninlsiwDk8/sRPkMrYyjuR4AkYsO3XVhLnMojQzl1oqKgNJaGE38IDyaj3kMNX98ff/kXypOx2fb82f1ygSsaO05byYI1souAINC8Z5qutgnB8i/FY/qqWBxMw70uQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy_mmu API now allows nested sections to be handled by arch
code: enter() can return a flag if called inside another lazy_mmu
section, so that the matching call to leave() leaves any
optimisation enabled.

This patch implements that new logic for powerpc: if there is an
active batch, then enter() returns LAZY_MMU_NESTED and the matching
leave() leaves batch->active set. The preempt_{enable,disable} calls
are left untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting
level, as the caller may rely on it whether nesting is occurring or
not.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index c9f1e819e567..001c474da1fe 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -30,6 +30,7 @@ typedef int lazy_mmu_state_t;
 static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
+	int lazy_mmu_nested;
 
 	if (radix_enabled())
 		return LAZY_MMU_DEFAULT;
@@ -39,9 +40,14 @@ static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 	 */
 	preempt_disable();
 	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
+	lazy_mmu_nested = batch->active;
 
-	return LAZY_MMU_DEFAULT;
+	if (!lazy_mmu_nested) {
+		batch->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -54,7 +60,10 @@ static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
-	batch->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		batch->active = 0;
+
 	preempt_enable();
 }
 
-- 
2.47.0


