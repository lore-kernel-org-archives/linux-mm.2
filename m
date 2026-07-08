Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADFCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D650D6B008C; Wed,  8 Jul 2026 07:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CD16B0092; Wed,  8 Jul 2026 07:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51E96B0093; Wed,  8 Jul 2026 07:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96B716B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C42C1A06E5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:28 +0000 (UTC)
X-FDA: 84965351016.18.18EE2F0
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2572340006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b TPHum9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LW1kxO1Z;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509266;
	b=mo9b16BYwHEWeNy3CTtNmkkyqD5whoEg1gqsWvcGWtVKZ3Afy5ejSFDUohlKxghR4J3CxD
	YBtE/qu95rzuQaGZC4rRXaFMlmcHC2utU4MOJPb+Jf06i6bExjRQP0mgNoU5KYTXWtoLTB
	A8+GrHFO6BO8JRKTqD1B1G2eExUpK8E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b TPHum9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LW1kxO1Z;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GV0wPGtF7+6beB9UWbH5/HRYkNB0tL5nqdvToF2JsDI=;
	b=mL6eM1uIsisH2znHiy6V167engzHPW2zIFSotNKVyZcHSNfwXNjdGz6HtD2rzUX7xWns4v
	MBFbQfE/eKxy70nsxcoQHoIia8d98aMHYHLFaJE520NJ+984S3aIsZUHa/tNZYxs33WVeA
	jNG+xRBhKaJwfh6oFpw23LNd9whMfjw=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E8D9F7A012C;
	Wed,  8 Jul 2026 07:14:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 08 Jul 2026 07:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509264; x=
	1783595664; bh=GV0wPGtF7+6beB9UWbH5/HRYkNB0tL5nqdvToF2JsDI=; b=b
	TPHum9cI8t4TWTbd6KcfCSV052wQ/jYMINTATTgxOUihJWSTBz77DZ8pT4TTSWKP
	lXlyaYqNVqkgquBUlXtfhN0DEn7VspJ0qfFsCP6mU67ZZw3VMUI7ekx8dO1Cup1+
	jzQj32Bx+fjF2KUXp/ldgRijtTPGTfZMqanTyx7pu+XfHWkN55l3/qOLUp0EgB12
	yebSi4jUriU2VeAYDIbT7dVVjgD79pNvdDAnBinZjzFDwbH3CyKASajipnJzI9/m
	Dt/JM4pTRRHpXH18D6dnc326MB/fb+y0ZPg8zqxTba5vGsqMhD02V5v0gbRxq7At
	U/J5oXdP1236ZepMowO/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509264; x=1783595664; bh=G
	V0wPGtF7+6beB9UWbH5/HRYkNB0tL5nqdvToF2JsDI=; b=LW1kxO1ZehVUYygQ6
	i6yP76Fd5LxIImiqgqpxv/18x/Yg7mTD/f8DSp1mfiEIH+bweOxQeNIxWc7Glo4j
	sSGC84SMRi4Hn4G2FMp2EqRcIB6r5FYJk76PKrSPdSTTW48awh2wQCGYDMso4uYE
	/jrOyuUE/wkHTDkNGyhB/IFtjMAUd59bYQ17leGuWt0L5Odh9nvOIGKkezyXpM+a
	sEQTjbxE/EhY0vLX+obdM+mLh2d1ro7/UzaOrG5pTACAeU31g00p9pratcicZ5kT
	AVwxwLPWxzO7cAFs9ZXwG6Nium/r5tHhRy3ry62BKN7/9Tcx7KyemibXYmHUs9ur
	+YArw==
X-ME-Sender: <xms:EDFOaj6WdWV8s2cvO-9N4810QPORumBNeb-LgjCE_t3Ybh7G7XCQFA>
    <xme:EDFOas3zXus5n30kHQWRKHpBxSiNsSqBZ2jw9ROQm7HCVT-IPhN8veY4daOruzp_P
    2M2rChK6eqxd0HSRrE75L6HiZ3EIKdWOESGzomRKq1srAd4UGbQzNNy>
X-ME-Received: <xmr:EDFOai88MVaGdeUNnAJPvWZCqDfMj1YQ-dkRVMpP7Tt-1ThdJ4Ttazb3T3fpOA>
X-ME-Proxy-Cause: dmFkZTGp+lp1jxge+zfWWQDOmFev1Aj93weD2lzg4uPZWx+Z3SZe1CWKpSY34hOQnXWdCH
    X3J4fIJFgTBESvc4xWiwx5/MD14dlgPgF9nEAAA62nAEEbDoeWJIotrsSVP/3RfCG4AL69
    GWjO5h6ISMv13p/WrSnOtYbJToRcDYMu+oxe1Md/9ogUnUkXvzdGTImpAvqmGUHyhNQHgM
    9EFSvv/v+Vr6S4j4lzrtAd/spoCmUPXwfzSzofPeR7pTVQTh2KO7mHNCViFZXuf2LlCk37
    tL6Z2TITbN4EPiDlJfbqtg+HqWMejqgZ48pmgyHt4ULCT1Smmr1CePpfQyTeBk4h4LlJic
    iFdDQrnzIvGA1kYvtFa8KWoHJOC2mF63NDuba2N0pX1cdj1fwbzbCsJdzcmi8oRSBYfxRW
    90JsGs0K6Ov8m9Osr+YolhP8+N3LXHIzHYlstFAUaig0RxupCNrwscAvSaP9baem1ngYp/
    GHtyUOPbhl2VVnWxCBLNDUhh3NKXtYieYvOxEn/EpJn7UYFv1GQChiomaf5eR4314qCNXz
    1UV0Sy6AlSMkPodjEdss7f7emS2RbqtQlbuWxqTgbnKoZ3PA+KQpTPC1L+7gEiATKVDSyB
    EpGGfGIcROg0S0TW8w/AoSLPPJitqeVA0pGPCdtd9cQ419u57e7AcGac0ouA
X-ME-Proxy: <xmx:EDFOatvqOJ649A6siR2y0ZQd0DKa_74DHvYiqNWeQykJZbe8V6uwWA>
    <xmx:EDFOauoT6bslBHQmUgGzKCMXTIhUqcS_Nj05O1BV8FUi108cC_0DyQ>
    <xmx:EDFOaoHIIrE7pxHjBVVz0Pj8wGMLP-wZIvo8XP-QLIOaTWmgNgnr1Q>
    <xmx:EDFOah5r0LAwWLHVzyOt_L9cLnm0l0y1LzDoEDryN_2IpXS-h7l0EQ>
    <xmx:EDFOam5YEucU0J15CMrroohuIexqUzQ0UEbrb4xl5AZRmMdcTJ0pOFRQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:24 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v10 02/15] mm: rename uffd-wp PTE bit macros to uffd
Date: Wed,  8 Jul 2026 12:14:03 +0100
Message-ID: <20260708111417.173443-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2572340006
X-Stat-Signature: ziwa9mq5nnqoa81fs1gynzp3befq5aim
X-HE-Tag: 1783509266-587101
X-HE-Meta: U2FsdGVkX18dZU79PueqB0pzu5+TuccjMNvao0rOthpG8sEDKUPFgfzmVCXe8vyYD0DVPZDqyJvmI5KI5vEJ82a5GyI7SV/btk1/exKCe8kh4Ba4KnqtXPQbc8+jXICq0yILOdv2XU4oFm+NN/eY4i32EPVZ9cWxiWQIvSolQHvyoWxkHyQLnSjaQ/UjnOkbmRVCdsLPKWJhUDxuf45jUEJT62dvHq31sArBgqrcdQJ0ZZa5/rBu04BlJsd24av7B3v7q3I2tjoMjSRDTPBP8Umk2BsKehPAjnNMBf5Q2VbgcWmsGYbubNBa2aNchCvLVhFsoOYnaDC6iCRgbqGGgTRce2fc5WIxWBxqxXdZD9zCzi3ORGy/WBC0Lmpcyzxiv/X4Xa5B92eHRhi8z4awxf+hcDEGmdflqy/G3keP3uaHuyosG9k6LJZrYziDtRUczHaI0WE8pRnRDxyy+0uCcDCbx+lRxiVbyMIq3KKRO0ZeABpGr/lMwjZxDJhiDuUMBPZmpnpw2t/oJLRMAauV2GQO5R0aviAH6TcF3Q6GHn/77uBv/RnwQg+IwXDfSv6KR6dj8j25iN/GsIXsWkxL1IvxxQwRsmiJh6I3lAeBaVb2dOq92YdV8BxMuXdFmgM6wDUHqhaDp2fPwhdMAzEcjxCwp6O6JmtSnfSPD8g1Vxk7pSQPGujgmycHlS4gGsq0/6CV4oO0s64dDCJDc8KSixPEyb6zoD7iDmQgFCiiD7PQwS/dt7qxNt1igiQY+cFOJsP1QN/E9UL6FEaEMR5sKjs3G+ouRiRV6jTccIyh/zbLFjMJMtOIDLA5hEBFK3E7syQFVbU3yNUevZiznSTIZHBG7zm/WzAe1oHHrxJqb/VZ2zEBomCG8GY5dmOBaTw2tZPmkecla7HP+oTjx/nZIHY3JkxC1f/9HN6qc+ONJ0/VTLYwWn8ZJiQaXVCi+8RfQnjheLo9UeTKxe5izK6
 EGYl2DK0
 oQv68yUWj0yIIIF6Rd9zd1XN+Qq5ycka4U9QLCfa6umSOv/zS7fGLC+2/RCp2eGwrmUMEKlVXwI6ixRt/CI75niIsBA3RPpsa7e3RayapdlswQZEezNQLYFJ5CnfCfwdXOoV+8Keykff8dder+TL4xZXRdVc+oejBx0SrBVzosUhFzyk/nvL29MFk2oRuoI75UNI9IW7p0hjQ2hLzKsUXSoJsNsdb5bDgoAxj2uCc9vpGNcn/oCDjKfTjLoL1/9lzNxJgTzHWvw0ls67piqY0SQDwYiA8w8OlR4CycnDsprgtnJoIgySq/AJbDwPQPhEmuld3MxlShVHzcdPsSZ50eGSnGCk1gEue8jgg1toyE8Lftq6l77iyRA9pE+yy7YxZcyIEJ7bScPwTMomf6vsio+qRy6YDsUQWAa/gSwHoRlpt4tGk0xpSa5Lb/afg8I/WEIwQBgeEf4UMXlcx8/a1dU7s84e4oVQe8pl4YiLFiL2SBFBq6a1PHkek2dN0icmf4whDJiRkxrn2/Dr6iF2Vq+JI7Q==
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
index 313f75af1207..0e490a2cf665 100644
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
index cbc58ec42752..ae4307cbaed5 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,32 +415,32 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
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
 
@@ -1167,7 +1167,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
- *	bit            4:	_PAGE_SWP_UFFD_WP
+ *	bit            4:	_PAGE_SWP_UFFD
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ef61a75cd98b..54432c308f26 100644
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
 
@@ -1562,32 +1562,32 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
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
2.54.0


