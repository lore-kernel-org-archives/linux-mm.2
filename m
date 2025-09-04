Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88465CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C218E0018; Thu,  4 Sep 2025 08:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B248E0013; Thu,  4 Sep 2025 08:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1F18E0018; Thu,  4 Sep 2025 08:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B99258E0013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82DE3117B99
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:52 +0000 (UTC)
X-FDA: 83851572504.21.0475D29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id EBDD11A0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWLhIfYPiP+dXnnlv2JP5/iNtaUNDnuC0/GRhQaMOhs=;
	b=2eegaAL6HFCLadj7QrlDdLSQSHbxT74Sep0axsPZcQ0Egf2D5oQJF4iFHzGsXjGa5DuugL
	54/y/xnTI6oqgW/w5qL9K4h+aetvy54hE+XNT/nqDfvw9UYPtkBwe22nZ+o/5RSoXDEzwb
	TcLI/wr9QMLJN0lMgOgPVJUPyk2C/6Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990731; a=rsa-sha256;
	cv=none;
	b=ac45YzAFfpEkDOeOkQPy4/lADYfJbLpL/8i0THfvRqpfpllGdqsJ1Y6/1lCg/5SCZaAvst
	yLpKPr98+XDaPZHtjmS71gf/dMofK9m7YMqwYS3RZ0VK6rMwR5SRkpW0k8TbcSjzvRBXx/
	VwORnlntu9lMrb/e99U6gWZCda393oU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD01C2F27;
	Thu,  4 Sep 2025 05:58:41 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C1D63F6A8;
	Thu,  4 Sep 2025 05:58:45 -0700 (PDT)
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
Subject: [PATCH 6/7] sparc/mm: support nested lazy_mmu sections
Date: Thu,  4 Sep 2025 13:57:35 +0100
Message-ID: <20250904125736.3918646-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBDD11A0006
X-Stat-Signature: u8wm8cocd3epjsz41udjyakyp94mmme8
X-Rspam-User: 
X-HE-Tag: 1756990730-292587
X-HE-Meta: U2FsdGVkX1/MipATxeqsbDmsBk2b0XbO7js+f/HBOuHnr6DmwQNzU1+s6VpRzfQDbvpmtf8Y7NOGqIZoglqpibBkc77NLY9mf82JfJIIWDTJqi/ykXPkz7fCyWSPaaQGLicdchQzjjRd1xc89/tRAhJgOSBYqMdv4qfhC1RcT+lv7HGyfCFr/sf1SBgMV+dsVmOcWJ1DHVyErdGFLVLyxmCEJhMt4xIOC19yV0gywyUyHrwPCWn0c6EQFzmpuVREaue86C+bwURNejc2ZWFH0i3vRUieMYEcIGaz2exr8P04GwfEMbFpNY7i1o1cjfEWaHWnWRbevlTvXX1ihE+qNxSHnev9bl3QxFDcBoKzl0d2AfNFhVU+nevoknN1UHSgZqxKKsNCjb/YlIIo3bv6+dAN0xgX/rQnWpmaUaWYMOPeskrvnDVnb0TRTuzXIhU3wE+rkVKl0COMzoK+SxH+q62Y1eXveTj9GIgT2k8GOPCveH1G+AID/kgkAGF/2+g7QwIFx3lDa8lz2MV+x95kSbE00184cVfZc6Yymv/rDNKuZ7B6TjKkIdcCr9e7tbmpw+MQnNhskY8USS+hs/N3ONtZjtLylTMGZNYTtszqHbnFV0Fy4vUUAFynklpY012lFV2mj15R+8m100uWZq5WLgyPmDQ4ReVuGo0GSZChMbeFjxDr0pseDvJoHqfoT+ona+YSPRw2zUk73beSKNnavkdpiPycL7t8jHAb+m8AfbjuKc8jGagR6up/gZge2omM5NA0p6MMT/PSJkHwWdmJrxNXfqORvT2c+QpuVXyJx0cicYSPbkKXG2VR0oq5u2QJj3ZaiX+N+Ip6/qu/UpDmTT+loElrdKSWnDyHyudDuyEsievXy/53ECv6JDrRMxR6Hlh1EFBHMvs+9EhEEjr0GoOnjOh8pZbH7d+QBjCHjNkM3wAwNGr7+5Dc+DWqPS6bZPtalVTqvZh0DEaUQQf
 WkhsLFbP
 OOS9faoPTSY9rpxI9qGHb9b5A8Av5Ax53eEHxOFxj/COm3MuRczQk7tk1hrsRs37iho9iW+Z56WT769EXbKM3CE36/sS7KXngmh2qiMijq/Ut4culswqWNaBhidJrURX626o3VrlUYmsxJLcr8N2p3I2UFUQjTSzg1qK+Zxyt74/0+vr2FdiEvKrycQMBno1JHqaavkmanj2Ykxo=
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

This patch implements that new logic for sparc: if there is an
active batch, then enter() returns LAZY_MMU_NESTED and the matching
leave() leaves batch->active set. The preempt_{enable,disable} calls
are left untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting
level, as the caller may rely on it whether nesting is occurring or
not.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/mm/tlb.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index bf5094b770af..42de93d74d0e 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -53,12 +53,18 @@ void flush_tlb_pending(void)
 lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
 	struct tlb_batch *tb;
+	int lazy_mmu_nested;
 
 	preempt_disable();
 	tb = this_cpu_ptr(&tlb_batch);
-	tb->active = 1;
+	lazy_mmu_nested = tb->active;
 
-	return LAZY_MMU_DEFAULT;
+	if (!lazy_mmu_nested) {
+		tb->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -67,7 +73,10 @@ void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
-	tb->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		tb->active = 0;
+
 	preempt_enable();
 }
 
-- 
2.47.0


