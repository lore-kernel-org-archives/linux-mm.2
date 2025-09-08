Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54418CAC585
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66CF8E0014; Mon,  8 Sep 2025 03:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0918E0001; Mon,  8 Sep 2025 03:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFBE8E0014; Mon,  8 Sep 2025 03:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 738B08E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:41:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37F8FC0A52
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:41:11 +0000 (UTC)
X-FDA: 83865287142.06.8CAED7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD5852000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:41:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46V8/3D4h6GmtbNpT0VfZMpez9sqUl6d0gc+rk27e8Y=;
	b=JmLuk1md/fiOcmVn4PVxW14Ol8T+3s9iTujsDPbGOopl8u0WUfvRBTLLi2rHA0JBOFx6d2
	ERBFUtIEnMc8RuR7EDD3mpyZU1J7CmsLgcOH0UjSlZT6uRtbZOtN+jsNzSnh77sikdl13G
	+fN6JWR+EzW4ac6Foxr+/vljBBWxoe4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317269; a=rsa-sha256;
	cv=none;
	b=Sp7B4rM6lkFkF6OsJEijgHgy0Ni7TkAl+z3I/6AoOU5Sz/W9spFCmFZZHri7Fva0wqrEAG
	fJiAq8m2GteY3cmyS6bOK7Xo4k/c6d4jGDIqWUowt9ptylBsflnD3ZrKYmEKv/snRHVkkv
	ggOGFKJ22/GSox4u/AuCST0fvDkN55c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A58261692;
	Mon,  8 Sep 2025 00:41:00 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5128D3F63F;
	Mon,  8 Sep 2025 00:41:04 -0700 (PDT)
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
Subject: [PATCH v2 7/7] mm: update lazy_mmu documentation
Date: Mon,  8 Sep 2025 08:39:31 +0100
Message-ID: <20250908073931.4159362-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD5852000B
X-Stat-Signature: agsbgr1stjskgcxz99z7kiadtx9b571u
X-Rspam-User: 
X-HE-Tag: 1757317269-631475
X-HE-Meta: U2FsdGVkX19BiTbHRFe7dvmMTh5WO2ChSau2sL4m+0OCngXa3w9D7afnFOVarqFlP27ZnjdWi4hiBpC5iz/CxlGAzFzyCG4OIdnDHyEDti7agYc8vh59O+zLnRLSm7iZTGOrBR2OnpmRKxe3a0TSqs9OLbkXktXe1volWd7Sa8x7+SnRRvDRXsKcSBi+Z/ZnRnPAyWXc0fwrtiYXlrBuFrec9cn2OCwbCobagYePqXNYM/zDEXcOt96wuorBsUCYRuoMC5FiwdeqxRYdErQfNeso/jgujRzq4TLfDCx81GshPwP0CaKoEuRRz1EjjNax43oKQZhUv8qBU44HaLUBvTzDSD4PelqKuvu792T/plXeZfthewxHO3p2Tzg5mNdHgjbCUYBjk/C41VTIaInOUwdtw03qC+BFiPd1QaXmQ+c4qqg+V8Qxwb9tnMjN7ECZ0XyX4jOiAWSCbhEyERQwkRQ7owrB+7Lh+5Fpth1Z7aoZLn/HlA9XdKTemRCS8e/i09zrqmj/ccppYWyxe1aPsCe2KgaerzlV/b5q1VRVheQLMoa8WEPDKdMwdLb2E33BHDkqLpLkE+genmxvFRgoi1KoqURXiLIXAmbX7Hs/zgeD2NanJktTQgHaFMA4fZsdORWXN32EREEW/8m8DOng+5Z04V5VRRvaSqOsZCkVGO+mEUsS5M7tsNQ5DSFCt7se5ReqZ6Hto+CyS5V6VOgoRWQCXW0xIvXzeReovC/iNRBao82zWUivadAwi/Jbbgp6RDhxBqSeCKki3hfT0mtgCYVxY2HJLZuk7dUVglW8Vfkj7RAgHC26MMYiRaBgkewWxe4m5a2j+Ml9eP9k8U9mSsKxnK5YTmWVJsydiWUP3EYZ3PS15z3YGFOyX48/D6ns2DjLEy+7aB1SgX97JSP8PJjkWcAJoBboZ5vPbWw0wkEjzlSE72mwWJDqlzOEEiuER8mjidHMgwY1K4t4ew3
 228a9HVy
 7aF/V0mEg8fPsS+Vd6AmTBKNnhsbjDpIpzMUGaL3vZkD0x/P5Scigq0qN3WTtU8Cr8nx64roZpp3rBbMF8Dmitgl/J2qk78XeI6/luVYT3FwYq2jMJR41XxM1NdTx0JWCk/JiPzRNxoL/vE21sI7r2Q3q6gh1Gt/yzq/07Rccen7tRG4lyFZ20TMFN/pYTXDqkN/2ku/5YFvaj6LP7LU1+wpmnAnFQgQKXs33dBZYsP5wMwITIdn1lx6mj9qo2olSLe1r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now support nested lazy_mmu sections on all architectures
implementing the API. Update the API comment accordingly.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/pgtable.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index df0eb898b3fc..85cd1fdb914f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -228,8 +228,18 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode cannot be used
+ * in interrupt context.
+ *
+ * Calls may be nested: an arch_{enter,leave}_lazy_mmu_mode() pair may be called
+ * while the lazy MMU mode has already been enabled. An implementation should
+ * handle this using the state returned by enter() and taken by the matching
+ * leave() call; the LAZY_MMU_{DEFAULT,NESTED} flags can be used to indicate
+ * whether this enter/leave pair is nested inside another or not. (It is up to
+ * the implementation to track whether the lazy MMU mode is enabled at any point
+ * in time.) The expectation is that leave() will flush any batched state
+ * unconditionally, but only leave the lazy MMU mode if the passed state is not
+ * LAZY_MMU_NESTED.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 typedef int lazy_mmu_state_t;
-- 
2.47.0


