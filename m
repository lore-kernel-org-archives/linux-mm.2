Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514F3CD5BB5
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB496B0099; Fri, 22 May 2026 09:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A646B009B; Fri, 22 May 2026 09:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0ADB6B009D; Fri, 22 May 2026 09:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1646B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53F241208C9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:19 +0000 (UTC)
X-FDA: 84795162438.20.69BF694
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6480EC0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h C82Nue";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=B01aBVPO;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457157; a=rsa-sha256;
	cv=none;
	b=VXoBjtHODeAAtloL4BmMABfhkHP0Kf6n0iy8LpUbOP2xRVqiI/ZGrQwPVX7zg1ujVdQd4o
	W/IiB3VfoWgsSjWPqwvPi8YtUhRCWYJBc1AFpOnKKylzIt90PjNRhGNdLMjW/6XyxPubHC
	qQwVA+/ZIcHirQA7kHf+Trj5KwEP5Oc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h C82Nue";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=B01aBVPO;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElgLTz6VTfB5I9DvFSGb9HgYoqQwYVCAuKS8x03tgn8=;
	b=Z3myVd087CSGtXcKAhFdgIdW6vPnAUqFvWVhi2HE3oc0oB79a2N8f6UuNd0BpVHVcgEFrY
	8PLd4JVybFjzqwqauZCdwkuMSpOhRLX1tk2dDTY22CrO3hkXReTHA/hM0a8L1cvl+aw2t7
	t4zLpsoz10DfMSJTM6UnBVP3x3DujL8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 3BE361D000D2;
	Fri, 22 May 2026 09:39:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 09:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779457156; x=
	1779543556; bh=ElgLTz6VTfB5I9DvFSGb9HgYoqQwYVCAuKS8x03tgn8=; b=h
	C82Nue4T7i6zzbBTKyEmdK7Bcucf7TkTFPdi29v9fshD6PPp77Tid+A+rNoVq4QS
	Iw9lXwdDP6CkLHQBzbGT1yjyvWJdmCLDdrn1k7dTrvCT7Ylk2yoynLDgRFU1VdTt
	Cg87bhNQei11yWdF3281FqGcIv5WZwmW1F1NfUOtnyQZ96/REmL8B7kdJ8uyltWv
	WsoeYoYUurM8sHYfi9Ddocf3+momSoH2iFC4XtxB7KqFWLhDl7uSBfyaZXi9Pg2Z
	hZ5jejXvoujAG3zM3adElNlpVJ+CifNMTq7UjnyK1yuLZZYhMM261Sdu1k116OOf
	tfpSPo0UkFr6UCxLUN38w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779457156; x=1779543556; bh=E
	lgLTz6VTfB5I9DvFSGb9HgYoqQwYVCAuKS8x03tgn8=; b=B01aBVPOU+RauqBKo
	lS+X7FmmIeEqVKSq01RsUrah/HAMzKb8HRJd7Iw89HJoB5i2iBZO5J7NT13thh0V
	Y+PeLtPEsVZM1yvRsfDRwqplEe7qUWd1gLlWNuruQCLuVkG7zIfHTdcLAJqkMl3g
	4+ygWRQ78+jUrZR4blAVM5e2O0a59izR9AL3hPcDmMkVVIJcKPZnqBO7UTvWgfwf
	27rE3sNrGbI0fODY4X0DvQ/fZDnPbP5idmm3hIYxQW9l9MxAuSNWU6lBHzC1frsO
	IoF6xpnBCHuFCoJCe4JB1PzFpLjNwzlVf2veCsp81IxRNiTJ9F9x4F+nJfTuMBTh
	ht7SQ==
X-ME-Sender: <xms:g1wQamLrnlVjssXom7A1L_VhqFvdkb8oLy4AJkLbXnp31xTheB8QmA>
    <xme:g1wQavP7LB7k29_Z8fXmfRTT2sCMJrME3HYbancY3X697kn8ygUTIxzkAUIQv-cXJ
    B4SC38qJDRqiZZmxCCKrjGBZk7TkDTS44TmMmqAiAYvu0OhlaADU_g>
X-ME-Received: <xmr:g1wQapptD3hCuwNbm_UvAoorguKGzr6IYd0nzXfkbVP02v1twljujRlZwrO6cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeegveehtdfgvdfhudegff
    euuddvgeevjefhveevgefhvdevieevteeivdehjefhjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:g1wQapFM3OMKeMBUu6E7YM6joI8KJEJFAK4bLlItRv8JCX5_AYF6LA>
    <xmx:g1wQamKbk2NBCmLPsbEsvt4r6hkMd7giYsTIY05dFHhToNnrKvHEhQ>
    <xmx:g1wQamjND6jcBvZqBk9iNdQTlvU2iLJkP64fUq_eKPnwTtr7aKwrWg>
    <xmx:g1wQao496nflxJMIZgp5tynDmI9g-4YDxifDNEbiBzdiWUWtd5gxWg>
    <xmx:hFwQajFd7U1MDrrZfnLepPE6_6ND5a8i53jsGpx02kADVJMnYF0jGnAP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 02/16] mm: rename uffd-wp PTE bit macros to uffd
Date: Fri, 22 May 2026 14:38:43 +0100
Message-ID: <20260522133857.552279-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6480EC0007
X-Rspamd-Server: rspam03
X-Stat-Signature: ro4agztnm7bqo8b9cra1h6kynubdfrey
X-HE-Tag: 1779457157-123955
X-HE-Meta: U2FsdGVkX1+sWxDqomSuRrDXxunYna/XEhOcv2x3NUdCeMheKR7nKM6ifq3a+g+fV3EwMIO3OmjErcq+SbqKaMOG27Cv3cU2eXujgV5BkpSicj/hA5+fvKDVEWEWZSpvDLr2kdF3r9Weg7zvYjNWJJvmMPK++Tx5VK13CJD1FZwvKcswVAt1yautYp+cPD6fD1kjzo5jZGy3kNkJ6h4Trh1zspEOg+nD1T8N08MpTG0/QUJV/V++kLVr4xaUnj4NU7Y4JblXilfpIcN5zM5sS2jb1L3kyXToXYy3j5Fxk/jz4E/n7FiarjG/dfzAMMpVbnJ0C5kwCzku+DyNZpOHwoontobBcaEQAKaU2e2+Sm6Ayqqq1gVLRI0RGgk0V3FcYd9HkMnDArvq3VtlIT6SGSof10KaSunNtg5YbzzLcPfHj9UAeFKhrMnsDLXlc1JkArxoG5ZigxcxWs8cGAinm7UdfStN6csflQsehHaLOhPECGu7yNteSX+HsEfGluq3qne7HixueY26rMlWDOPU5p5NTvdqjaQjpT2Hw79vw3zOH6557Y5aKfVR6XZG8AuZbUigi/tB5Yb2JHja++IgK2MmhaeOorbHZ+LUW0R9GwItwAUiW3Zcc22iTMp6Jg2CSdHLV215saTE66dSd/e8o23HVveOs4L6f4MDvZgjtYJwxRL+6R/cspOPQ6Bpg+jheeR8j/fhGdlMgBZqvtZse2ZaCKJz7X/JYxHE0govGY7bopdqZde8cwk+MF9V/0M8pZzgsu9728mdI8nhz5tDDlsUd0xchaZuXjRuW+7UGlIhnWYigyzk3k0W4EDqpJWA3IWizMh/DpoaUkYyna7BoV6OTsSj/NeRkoF2M/0KS0gcD/v5710Ai0VVmhxA2cWQEUSJI8ydz0BHBKKpgH8q7uuR9TQzpg1tXrnl06VAy7aHxPBAHAVqpDMeddh1srlUQ6sDjpmMNFtVYhqkERB
 i4FBmFm/
 BTkW64ey8JljJRJf1h4LiYyjWQhYOSdSG4bTAYISVg72rvk3bm/PmEO49vs5a2NzcPmTZ8MSuesiC5vSSpXVJfW7wkW2xQ37twdQRup9y2/jtGfTRnO9BvORF56RbRCcG085JcZB/bRfTunwalVk7xpM+Jf1neCraBOfWOw3XS7oqOS/8QEDnIWFZ7RdVg7WXhwRBKqffd2aE9l2XAYByDO9FMkU21IhdnzwUT+o+UKtdEQyVOO2zb2abpBsxFyUUdmLrL+Ed6dsnWded7NLeAXzcuPqxJtHYlPoh4WApCZ9atULVEfzF5YONcCZw+/PxHjyWcYlrpE2PwQm/RXWAr59JZqXdbHXSYMc+sKOYbjac177FFx5XC1p/8+IQlGw8pTqu+9JryqzVTbP7CmMiMoTIMrbFIRZ4Crjnl59lnUNVM2DF3L8TE31xmdKRVBOw4avZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The uffd-wp PTE bit is about to gain a second consumer: userfaultfd
RWP will use the same bit to mark access-tracking PTEs, distinct
from mprotect(PROT_NONE) or NUMA-hinting PTEs. WP vs RWP semantics
come from the VMA flag; the bit is just "uffd has claimed this
entry." Drop the "_wp" suffix from the arch-private bit macros so
they reflect that.

  x86:   _PAGE_BIT_UFFD_WP  -> _PAGE_BIT_UFFD
         _PAGE_UFFD_WP      -> _PAGE_UFFD
         _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
  arm64: PTE_UFFD_WP        -> PTE_UFFD
         PTE_SWP_UFFD_WP    -> PTE_SWP_UFFD
  riscv: _PAGE_UFFD_WP      -> _PAGE_UFFD
         _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD

Pure mechanical rename -- no behavior change.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h |  8 ++++----
 arch/arm64/include/asm/pgtable.h      | 12 ++++++------
 arch/riscv/include/asm/pgtable-bits.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h      | 14 +++++++-------
 arch/x86/include/asm/pgtable.h        | 24 ++++++++++++------------
 arch/x86/include/asm/pgtable_types.h  | 16 ++++++++--------
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..09d7c00cf405 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -28,11 +28,11 @@
 #define PTE_PRESENT_VALID_KERNEL (PTE_VALID | PTE_MAYBE_NG)
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define PTE_UFFD_WP		(_AT(pteval_t, 1) << 58) /* uffd-wp tracking */
-#define PTE_SWP_UFFD_WP		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
+#define PTE_UFFD		(_AT(pteval_t, 1) << 58) /* userfaultfd tracking */
+#define PTE_SWP_UFFD		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
 #else
-#define PTE_UFFD_WP		(_AT(pteval_t, 0))
-#define PTE_SWP_UFFD_WP		(_AT(pteval_t, 0))
+#define PTE_UFFD		(_AT(pteval_t, 0))
+#define PTE_SWP_UFFD		(_AT(pteval_t, 0))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #define _PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 873f4ea2e288..3eecb2c17711 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -343,17 +343,17 @@ static inline pmd_t pmd_mknoncont(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & PTE_UFFD_WP);
+	return !!(pte_val(pte) & PTE_UFFD);
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(set_pte_bit(pte, __pgprot(PTE_UFFD_WP)));
+	return pte_wrprotect(set_pte_bit(pte, __pgprot(PTE_UFFD)));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return clear_pte_bit(pte, __pgprot(PTE_UFFD_WP));
+	return clear_pte_bit(pte, __pgprot(PTE_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -539,17 +539,17 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return set_pte_bit(pte, __pgprot(PTE_SWP_UFFD_WP));
+	return set_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
 
 static inline int pte_swp_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & PTE_SWP_UFFD_WP);
+	return !!(pte_val(pte) & PTE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return clear_pte_bit(pte, __pgprot(PTE_SWP_UFFD_WP));
+	return clear_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index b422d9691e60..d5a86b4df3ce 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -40,20 +40,20 @@
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 
-/* ext_svrsw60t59b: Bit(60) for uffd-wp tracking */
-#define _PAGE_UFFD_WP							\
+/* ext_svrsw60t59b: Bit(60) for userfaultfd tracking */
+#define _PAGE_UFFD							\
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
 	 (1UL << 60) : 0)
 /*
  * Bit 4 is not involved into swap entry computation, so we
- * can borrow it for swap page uffd-wp tracking.
+ * can borrow it for swap page userfaultfd tracking.
  */
-#define _PAGE_SWP_UFFD_WP						\
+#define _PAGE_SWP_UFFD						\
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
 	 _PAGE_USER : 0)
 #else
-#define _PAGE_UFFD_WP		0
-#define _PAGE_SWP_UFFD_WP	0
+#define _PAGE_UFFD		0
+#define _PAGE_SWP_UFFD		0
 #endif
 
 #define _PAGE_TABLE     _PAGE_PRESENT
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 48a127323b21..ca69948b3ed8 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -405,32 +405,32 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 static inline bool pte_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & _PAGE_UFFD_WP);
+	return !!(pte_val(pte) & _PAGE_UFFD);
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD_WP));
+	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_UFFD_WP));
+	return __pte(pte_val(pte) & ~(_PAGE_UFFD));
 }
 
 static inline bool pte_swp_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & _PAGE_SWP_UFFD_WP);
+	return !!(pte_val(pte) & _PAGE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_SWP_UFFD_WP);
+	return __pte(pte_val(pte) | _PAGE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD_WP));
+	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -1157,7 +1157,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
- *	bit            4:	_PAGE_SWP_UFFD_WP
+ *	bit            4:	_PAGE_SWP_UFFD
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index c7f014cbf0a9..038c806b50a2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -413,17 +413,17 @@ static inline pte_t pte_wrprotect(pte_t pte)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_UFFD_WP;
+	return pte_flags(pte) & _PAGE_UFFD;
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD_WP));
+	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return pte_clear_flags(pte, _PAGE_UFFD_WP);
+	return pte_clear_flags(pte, _PAGE_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -528,17 +528,17 @@ static inline pmd_t pmd_wrprotect(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pmd_uffd_wp(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_UFFD_WP;
+	return pmd_flags(pmd) & _PAGE_UFFD;
 }
 
 static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
 {
-	return pmd_wrprotect(pmd_set_flags(pmd, _PAGE_UFFD_WP));
+	return pmd_wrprotect(pmd_set_flags(pmd, _PAGE_UFFD));
 }
 
 static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
 {
-	return pmd_clear_flags(pmd, _PAGE_UFFD_WP);
+	return pmd_clear_flags(pmd, _PAGE_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -1550,32 +1550,32 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return pte_set_flags(pte, _PAGE_SWP_UFFD_WP);
+	return pte_set_flags(pte, _PAGE_SWP_UFFD);
 }
 
 static inline int pte_swp_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_SWP_UFFD_WP;
+	return pte_flags(pte) & _PAGE_SWP_UFFD;
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return pte_clear_flags(pte, _PAGE_SWP_UFFD_WP);
+	return pte_clear_flags(pte, _PAGE_SWP_UFFD);
 }
 
 static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
 {
-	return pmd_set_flags(pmd, _PAGE_SWP_UFFD_WP);
+	return pmd_set_flags(pmd, _PAGE_SWP_UFFD);
 }
 
 static inline int pmd_swp_uffd_wp(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_SWP_UFFD_WP;
+	return pmd_flags(pmd) & _PAGE_SWP_UFFD;
 }
 
 static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 {
-	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD_WP);
+	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e..af08d98be930 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -31,7 +31,7 @@
 
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
-#define _PAGE_BIT_UFFD_WP	_PAGE_BIT_SOFTW2 /* userfaultfd wrprotected */
+#define _PAGE_BIT_UFFD		_PAGE_BIT_SOFTW2 /* userfaultfd tracking */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_KERNEL_4K	_PAGE_BIT_SOFTW3 /* page must not be converted to large */
 
@@ -39,7 +39,7 @@
 #define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW5 /* Saved Dirty bit (leaf) */
 #define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW5 /* No PTI shadow (root PGD) */
 #else
-/* Shared with _PAGE_BIT_UFFD_WP which is not supported on 32 bit */
+/* Shared with _PAGE_BIT_UFFD which is not supported on 32 bit */
 #define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW2 /* Saved Dirty bit (leaf) */
 #define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW2 /* No PTI shadow (root PGD) */
 #endif
@@ -111,11 +111,11 @@
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define _PAGE_UFFD_WP		(_AT(pteval_t, 1) << _PAGE_BIT_UFFD_WP)
-#define _PAGE_SWP_UFFD_WP	_PAGE_USER
+#define _PAGE_UFFD		(_AT(pteval_t, 1) << _PAGE_BIT_UFFD)
+#define _PAGE_SWP_UFFD		_PAGE_USER
 #else
-#define _PAGE_UFFD_WP		(_AT(pteval_t, 0))
-#define _PAGE_SWP_UFFD_WP	(_AT(pteval_t, 0))
+#define _PAGE_UFFD		(_AT(pteval_t, 0))
+#define _PAGE_SWP_UFFD		(_AT(pteval_t, 0))
 #endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
@@ -129,7 +129,7 @@
 /*
  * The hardware requires shadow stack to be Write=0,Dirty=1. However,
  * there are valid cases where the kernel might create read-only PTEs that
- * are dirty (e.g., fork(), mprotect(), uffd-wp(), soft-dirty tracking). In
+ * are dirty (e.g., fork(), mprotect(), userfaultfd, soft-dirty tracking). In
  * this case, the _PAGE_SAVED_DIRTY bit is used instead of the HW-dirty bit,
  * to avoid creating a wrong "shadow stack" PTEs. Such PTEs have
  * (Write=0,SavedDirty=1,Dirty=0) set.
@@ -151,7 +151,7 @@
 #define _COMMON_PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	\
 				 _PAGE_SPECIAL | _PAGE_ACCESSED |	\
 				 _PAGE_DIRTY_BITS | _PAGE_SOFT_DIRTY |	\
-				 _PAGE_CC | _PAGE_UFFD_WP)
+				 _PAGE_CC | _PAGE_UFFD)
 #define _PAGE_CHG_MASK	(_COMMON_PAGE_CHG_MASK | _PAGE_PAT)
 #define _HPAGE_CHG_MASK (_COMMON_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_PAT_LARGE)
 
-- 
2.51.2


