Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BCFD5B17D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C75A6B000A; Mon, 15 Dec 2025 10:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450656B000C; Mon, 15 Dec 2025 10:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAAD6B000D; Mon, 15 Dec 2025 10:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9786B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:03:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE4DA1402AD
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:56 +0000 (UTC)
X-FDA: 84222025272.14.ECD5B9B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12786180016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811035; a=rsa-sha256;
	cv=none;
	b=BvAc6uyz+qejrKgiNyIn2kyh93+Y0RalNdH/eQlvWlUoYoCtrH8L9cLACKmQ/h7Ca+7Yw4
	jYsofI8pW1RBBiSiqtS0gEnrfmsogFQx/k4jxMWMVkrfjtSg+OydDHeD3Ji/44q4jHe1kV
	/wt99KzCkHHZ92YHdTdn2RnWCdAumPk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rF0AsidLeOMu7qD5PDF0s/XHOeU6WMx+Baq4lCM4i8=;
	b=C/rG8lvywnmRTBvlvJqA5q7UmJ68iUGtK7u+/DKtV2Du77qb6hCVlclNxD5yZZv+13/Ev6
	27MYTBBNdRdo98N9GMoUQFHOtH+taAtWYiZQJ2WYSILxpm1mIvKYSOn1WL1Mx1zb7APXbC
	iBIzIb50Uyt43JjkHWzQmqBb/uz+Ee4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DD31165C;
	Mon, 15 Dec 2025 07:03:47 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F099A3F73B;
	Mon, 15 Dec 2025 07:03:48 -0800 (PST)
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
	x86@kernel.org
Subject: [PATCH v6 03/14] powerpc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 15 Dec 2025 15:03:12 +0000
Message-ID: <20251215150323.2218608-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 12786180016
X-Rspamd-Server: rspam10
X-Stat-Signature: 3bo5kjdg4e4wdfpttrpnsa4qk83srwq1
X-HE-Tag: 1765811034-245213
X-HE-Meta: U2FsdGVkX18ZzWGRE4HpXvQvctjExkotvC4rolNj+btO4AMbA2FMK478iT19791mnOgCGc7fCoyBb4MCxO9Lc//1eyzHAY7nTM1d5DDXcd2Gw7a9sufDmxZT4Q/glifTbPy9O9Sro9YyKtRh0xLS1cuBqL2+T4CIAHHLPIqHn939Jj2GuRR6zd4k/ArIrJ3GDrMnWov5KwJCFYpUb3ynakO7n3+IstFzTmt0ve9TVIaqWqihnecEUOMgex2XUlpNPnMGRndSvexnX4g9H9zvpWVhv+6RCcanRfEgP7S7wG59VkX6sW7fL/yF49PBln90P92mFghvEjjVIS+Zq1FgwZK8Ww8/tvauAd/f8oJOhFULOwjPJGzdh4cbdrYbCUGLFV21Cmq0NycUtgyfrruSeBvC0y2p/9L73+zhPOn89+hhafKZzcr91Rv7ouokp5JagOpYob/ceE7DQDHVKxo/cjZ5Vv2IS/T+0YPJkZWoNfdZOxEFhEDb6thKbML84Tql9Wlnd8bFzL8pRl8XTDTS5nwE9ER/p7+Eqr2LFs4/eb+ex7COAi98wRDYr5RcI3K/iun/2tSpV+p0bsC0RpKIIp+eurqjvDXNALl/IbdwkdvvB6MwTji0Kdse6z0VN4QIkWpVIYVfAyeZTJFzGvUW6mDI4iJjEx4P0IPFpxOYPBLbfrOr20lE9cqC2PptiepBzclGakVvPbngLmyTqApzwzwhGeJGRoCTMmYeQmYzOvFnfR3F/jh/9cfCnPkFEKevlH5jBDjpQ6vfJMVEwC9dJ0lriVPduVIdBMge2fbqtgoKCBuFS1wFHPGH9xYhfpsHk68NY6NrZ5dSkYkUC/eB+P/p9vntnaP+L0cN+B/7zujoCQoRMqrtKuHhUqv141kUW2bmyZEYrX90Ut6YbifcmY9bio75mPyUnjoYBkfNrxS0AfXGRXA1zKfbb99M54zdvpoDR8pJ+oSoXGeTZQm
 uzBbeFCS
 tExtstt7uC/IfAEkdHBDWRfrVvw==
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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


