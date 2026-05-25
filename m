Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB603CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160876B008A; Mon, 25 May 2026 07:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137F86B008C; Mon, 25 May 2026 07:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E456B0093; Mon, 25 May 2026 07:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E89D16B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:38:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B17051401F9
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:09 +0000 (UTC)
X-FDA: 84805743498.21.5098A28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6581C0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4+khLBv;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTy85+CBbgePeScVZ3smE24qgHSrvtQVk5MU+uCFfm4=;
	b=wk6CohBahw8M6EloXexvoDAkVJcQzJrJD4EvO1LdqXhdMrNyuwZ3YcfViXX4U9jIR4nt81
	ITRLh/AvtgMhqF2JHj02K4j/cnc9qOILttGFon+M8zLoIXu+oM2npuUtyYgv7HKQfca/i6
	nfymPaOH9SbKPQbDovRMeLGE6okf45c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709087; a=rsa-sha256;
	cv=none;
	b=4veBdPVJ3rbWZ9J2RzHVB6OzBnFJMGRnHx0SpJnBjUZesJ4cBBomwby3U/94tJs5MgfzIP
	qFE/xpQe0XcfnBAghEZXCPBJ7nA8RsHwRO2Yu+hhwQVaNPQt7M4xD2azhIIuugb3Wjrct9
	BRH4qzaRdoWkwYVayfii6LWSZKrx+JA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4+khLBv;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA80143C92;
	Mon, 25 May 2026 11:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E001F00A3A;
	Mon, 25 May 2026 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709086;
	bh=hTy85+CBbgePeScVZ3smE24qgHSrvtQVk5MU+uCFfm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4+khLBvGS6a2SSpk3CKPWG036AQ5aCYvcx5yXFGNAuZcHB6WltW4lt6nNxmJtMTa
	 XoSt0CWScZzhB4Zof6uGrDs5xNuzCrtQD+knrvBKR3Qw2anF2Bhfn4Pw4zLVkomCIa
	 6AtcWcL1rxIoC/d+M1UqmwtsQYg1rnoROkeM7DR5lIZlfJpJowvvfuF6tdt89NxG9R
	 vjjwatPPYL7b9nfIduvKTSauiC92cm7j4vpHiplcxrik/9NmJ5He+ZdrD9PnXvp1s0
	 XAUF8RRFe2ZZK5H9bW8do40UOSBSmKqE+q8+rj4TWy4qaxX/f5/xtJFEVsbQhmHK0e
	 6i/LuodrwRr6g==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 47EC8F40082;
	Mon, 25 May 2026 07:38:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 07:38:05 -0400
X-ME-Sender: <xms:nTQUamiVDncZHY_NPpvYg3VD9jrJV8aefX9X4CsBh5O3Zdhr-I2tbg>
    <xme:nTQUaiAeLSnuSDs8KZpXOrvfd-R2zPdL93DHE1uOK7EP4CLhA8Gq1THJ1cSCAQQhY
    jWkeuL8_b3zR6lUq-VwbJBYNcoWw_RvTGMBy220iPEFH_0A2Ez_Yvk>
X-ME-Received: <xmr:nTQUakvmjmWtmC2NCgpCQp8nRPUAEhN1TkHzFAZ7bC1whGmne7iZKeAcmu3cBg>
X-ME-Proxy-Cause: dmFkZTE8BdsnOcJoKEIc8nWENdzZ3IJcc78XaZb937JZptTbBfsj35uOLLco64YanRFUy/
    vxRRXxJncUkkFhQ6Fw9JoTXNpIBZaIk7PJKSogIAKlou1fnKpK60SVEE9wIdCSKeJSiEmd
    jMYcCTSecv2wdbvACcZ3jQHh2R35wiBKAXeBalxbQ8obtaPzZg26qqKn3eo1ycSESHvZEY
    8vksW44pxFuJVzxfC4xrmaM24Xz/fIt3AP98RkQGIoAMYfpB8FzSca86T9jBGlmKI9r1LK
    Ip3BvhMbIznxq4KZmZ20/tINtDmxtvyOkjCcERfRzx2DQnK/TIBWkODYKxc/0O8u9p7eSt
    KFgukp6v1F9HEViT8ifxiH8dlFlgTM5s5IV+CjnhW4c4ElNCbgr135F1gUug81L3nolDoR
    9XhpWtFH66WifRfhgOdTzLZ9S2axM51tpSNmKvB9C0upXvCSOOz7/BjAgpRe5iUvG2ydUL
    LMNzjeP65hpq0JZ+dkROBr4zaj06D2avRKNy9HKyMAzk/dDmFUzwTlT1MjwylUeacsUqkk
    FanTkahN9bq1OozI4h6TYlA1Ppim9JFQ7/0/iZXg+PyRps3ZuypdlirDEmKHY3aJqyco8V
    Aso7u7qUonm9bJWMgJwg31bPZmTu6cQqeXSNd/CCUGKPDo1xxPXHGLYWNgTA
X-ME-Proxy: <xmx:nTQUas6BLPcG8mcDoBFc1pSHJQQ96rU9fQMjI2ca9Qo1rHCcGigw2g>
    <xmx:nTQUaud-a9jj1AU_hLPCmKd6tRck2MJ-TgsLj2JTMbN_XaBIADtQeQ>
    <xmx:nTQUakXBXmFBs4W9kjjQ0EqRckH3b2o6Nrp-8X8Xpbt29iMfTPMCFg>
    <xmx:nTQUarWU4sAvm9uGPkkedXUZaFJkfh92uM-Lx_0U0iNEOikcgEQYDg>
    <xmx:nTQUalSKTFLr3H2fd2tQpTMp5D25YgxQw5iVO-lJAq1GyweA7WhY-epX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:38:01 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v4 02/14] mm: rename uffd-wp PTE bit macros to uffd
Date: Mon, 25 May 2026 12:37:16 +0100
Message-ID: <20260525113737.1942478-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: yszx3b9ma7qtc4zqsimwxyf1pqw918b4
X-Rspamd-Queue-Id: A6581C0002
X-Rspam-User: 
X-HE-Tag: 1779709087-289885
X-HE-Meta: U2FsdGVkX1/+ToGw+Z8oG7bx7i5hvBlqjcwOEi8QfWe0eML35WTyuDmObCybTSWCINbge1jbgHW/5C24OztGdsnfexPndHcjzWQqOZcNPMfYebbtKi3YZ+3nRFBbi972pQljOfn8ZVZpqp1951GY+I/EEgD9ppytVqd6uHVxx8klA0h0gfmCm/xnMIEvIJ5TlfHAJMRVFZdF5PQFDLt+6L9rviKNNnu41EYJYw4whqmkL14mAXIybhy5Yo5IvgsLoqilOuS/3GfIU4J5/ADlHlgpvF2m2MRJ+BXk4HeJMNhMVr1WN0SHWLebKVz9DXBLAZNkdCld1pz/b3BbzZ2+ZtxIxJeLN5sdvMxbBurR90Ms/HdmPMJ6tYcEgadxoIzlEHm/BKJeTFQhM26gdGbyKGawwEyIi1aRbE2kM7x89Ku+GPLBoU7HWtGZq+ourDuQo+62vJHK6VLDoh5paNUVDZ7GUG/TW7MC+UCUIFW2hVxHOPrAvLI/eeWk2TZCRZlM2o7NtF26CR9AwjWbADdD9A53BNd6L2fMGodK90nWEVDrWEHSgvOfYMeOBkyyoPAf6wb964Fx0HynwVdnlu3i1g42rXG39wj/sSGYblfC6X0OnJWLERd2CCPn/4THg2iMQc1j9Yui7O7wDwjX5YodGf/1cYmqQBfmuje3lWg5L7BEx5oc+6xtYXpOOdQTmdjh9BPA9pdSFRJfUCgrXDxilHR7GBfLGhAcGpPaa1S5cJ02Wko510bQ3a1Tdeu16TwkS8+u55ssgvQ88opRcKDbe4MNZrxQmbHpeKfISSSd2raPTcETwmLk8JflmFnktfwTZ8VA/RhXi3+LTVzMFVZsdabcpRRlWctABK2SI0vDAifmIzk7j0pfBW1jU/wmPZuKWYbXSANi2QLyzZaV/hoAOqgRnRF5WyX6ZfscQ8bu7z/9WidgfTClLkg91pOLoXzkP0IAkKLnp6OxQJUXKEU
 xCUq/0Yv
 7yYvuyOnmNPrTWmv3o4+GpNd2r/5+I86lgIDjSET9iPjG94USTTRbkxMpLtXf4tNSfU4QqG4+MAvSn+DtsmkwPFno1+cHUg9l7T70C51b9gUoe8qczNPr//9GeksE5jb4k/J9jPGsw+pYVDeAK6R7Gd17E6Ybc5ZTus4RNVNVrGAvvMr16oOGfF2nolqbKu+oHDeLcNbnu+l49yHuQx7XNjBN5EGmDL28uPUduChoQdinUs3JGwt2NrdFRzOpUBGjTkC127kDBknFr9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.54.0


