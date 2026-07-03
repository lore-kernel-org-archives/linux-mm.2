Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885EBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FC46B00B9; Fri,  3 Jul 2026 09:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816FE6B00BA; Fri,  3 Jul 2026 09:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0216B00BB; Fri,  3 Jul 2026 09:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF3F6B00B9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B58E3A0108
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:25 +0000 (UTC)
X-FDA: 84947564730.22.0B88CA9
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2BAD4000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Z Vi3JCv";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rNIM06Zt;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085783;
	b=E8dTFF8SbMkQvBj6VuFpaoSnbdOJCpl1sY4V0H3euo8Y1K/1PHo7xBspJTRmZ6L5dhv52J
	1ceN5hKyg4GHBoEqaTCpIQ6n1bZjySCe4O0GMJuSLtxuA4O1WqeN81fABJJdvybhIGY+Fq
	9diF/tBNz6lFB9kLUqEJTE2rr5+NNuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=;
	b=fKoSwTyhEnh9MREyfBv7+FxbC/FeRBLYE5YYh7htB+QDCeWjTR1jLBYGJRG3pW3Dn/7nop
	b+wEuVvcxqKknZ/T0a3spS3mTXu1sIU5Q9Zf4fZ2F405h15xZKcbaHmdYtvAv2vernFgLx
	HpeBAxbnjCPFyZrV5wm6kGQ5qxhKmME=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Z Vi3JCv";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rNIM06Zt;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9AC6D7A00D0;
	Fri,  3 Jul 2026 09:36:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 03 Jul 2026 09:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085782; x=
	1783172182; bh=hAw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=; b=Z
	Vi3JCvIZIalhjFFNnz5G5z+ogL6R/Mb743QaNkxFab4zWiRaznbFiavxzHfG0q+7
	tGUOB4FBOC8ZukpZrGlLRM+Y25IvR/NeTbciJZdOM31HxgpDxyjPdb7Hcj2lqxlS
	jWQ+vDJxsTYAYms5n8FEzMGGA+0CzeC4/07AUDS0KIXgZb/wX/NO5ZZ3GfbVJdfv
	1MhboW7n8LdyXro2QZ1vzCfvN2iCY+CZnl4/7cWrsr0TMf7svrvrU4pxGJ7RtcZl
	886gI3+gsCDs2Zg+6mg3IFR5y1oYzvk6dlsDBWRPzJZrgrOf6LmbwyaRESrrNjHo
	rqYFB/EIDqb5NG5bp93eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085782; x=1783172182; bh=h
	Aw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=; b=rNIM06ZtOdHyx6Ibb
	Dpnn32YIS6xWj2s0aNB2IqYrxpHSHjnNyw1qEvnN0A17fDVv6jd9Bbv9DgihvQrS
	H4PEot12SPyouDmnB+70JI+bTF6kIicvrtCL9FBEGkHOXeOzpMDptBLStiZrz0hI
	9PF6LMEFsHJSQF1nRlUwxjgenSZlVu1PyFJ5CqFkCUeoAAaFQYnf5B2WOYrndsoq
	s2wER42Oc19A/gHoq76L7WPO1qAE96cSERVIixVNu44S8K9/rw0bqvjcHISEW5mL
	uHo3e3YhrRAhVWKZ9Q9oFyCq6ydKJAlyF/o8J8jnZX+2rKdO/+KXR9RprtY6G7Kl
	VITDg==
X-ME-Sender: <xms:1rpHas51FpoUj3lPug609TrNhAaEJtFGdrK7EXwhY3hP3SN4miOAvw>
    <xme:1rpHah2EedVaR_18ws5mQ77G2RwGzpqPflHvDnjk9IAn6WO3A0huAwMBL-iZeFVf7
    qUfyRXMAYBMRB4s30q_nzDX1VH2vvntEDOwy-Ro9arVH1dCKACwnQ>
X-ME-Received: <xmr:1rpHaj-O6EpoJou1ZNDWMneWx-u8aIqj1cfOdV0f-vgWArBVnfFxak_uJFOjQg>
X-ME-Proxy-Cause: dmFkZTFugVRxFdH0dMt22KIYT6S26SSG98N0sz+ys09Hlr+AnmeajYF1RN40hpGypUpqlJ
    Zy5d5jLGARuczyZO1OdMXn8vTiUEU5e041N3yfZtKjqAJ2fvSnwYTcPKrlQ8VpRdJVBZzT
    zWez++VZ8twwgwYUntmWOLuiz+JddIPneaaJpHaGxbGUweQl93yRdt1mLP1v11JzYxL0TR
    PjwvC7VHBsh+pFBwV52NT5Wi2gI/nElrIms2Df5C0iyrzcKgELK3rpQpBE9FsReh7PU8JH
    HSiQWhouKdXxBitqX30HTHdkATiOG+IvrpxSrzooOF/Wd6aJR6SYeTFYyzuXA81DmL1FSY
    sZOipQ7NbBzjbu8zCzzndjs+3f0BZNNTxsD62dBJJ57xqD0bTvpRBxp0j7XQ/CpZXRZMot
    ydJaETOB76ERUF7xvb+y+TjuAjW/ToZxxZR2RgLLeJAfY1bXX6rnM0sKwdAGCDznkjDVAo
    aIIySAJXOIYvKexZgECcyIq/Zy+NddrrQEpphVo+pfqubFnziB1A8d5YirL5eh2eRH5cfR
    uosiVLEKkbxgVuMLFmssTw+yX4bY+ccWu+Av9YEdB62X5v80kcknr2J4ftjNszjr4zX5tk
    6ihhk5hwgE+vUQjqX9TwQ3hTd9bQQ2fDn2HBUxWMht48PWNVYpnNgGdmT09Q
X-ME-Proxy: <xmx:1rpHaqs7wQrKYqwC1xi7scBO8hikW3dl5I6z3bWsyNmR1kKmIUMxjA>
    <xmx:1rpHanpcTkqsGn2X8xvT2DJwqSr6BwlzEL2G2hLuDcdiQzls2g_wdA>
    <xmx:1rpHatENNBZHqilUW2iz88xoIfe-zVPXtUPzeFnnJEuaOoVCY9XbfA>
    <xmx:1rpHai7OMINVoJy_QqkoPWOn2fOUernfB2pqgzXglhwbNqrzBJ1_Pg>
    <xmx:1rpHan5rJ3UcNOy00loyrHYREMm8zsxQHuFHDfbGA6VWt1C1GWYMr_xL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:21 -0400 (EDT)
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
Subject: [PATCH v8 02/15] mm: rename uffd-wp PTE bit macros to uffd
Date: Fri,  3 Jul 2026 14:36:01 +0100
Message-ID: <20260703133615.1039465-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yksqf85igtphdjornjh1gjazw4uamtxu
X-Rspam-User: 
X-Rspamd-Queue-Id: C2BAD4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1783085783-165698
X-HE-Meta: U2FsdGVkX1+En24e9XOly+hVGiy71uLeWsSXdL7ElO3pgyW4rCpyUFyNyRALSxZZS3+yj6Zz7V60qta103+7pbmN8Sl3EtjqOtJnuNPg6QgaKWjLD7dU0E7Lpbb1YmE+Z6LvrchzLGuGqr/lYz9roMTkUIK1xukHpGUGwtut1TKPt3todtj7fKV0XLamZYlzr8cDoXkWmN3yrnhonCPsd2J9ej6biV9URyXxs7Nj2zxelDZJuKtnlP7mejq5zmmt+4zu21kdr8Rn8YG/u9yJ868EvmZPHEIYAOLOKsIXDenPVsHP5qgrI9wW0j5h/3932aVPfe0H8rOnHds2DWMsCfjspgaVSs65Szh3WtU2Gg3hD1nw0PHV6LOnAuZQuZTkxBhZtaVFoj7zL3xUHe1aErHCnu/gbsnc40Ep1/DLH6VpU6sG+z730i57NR4GrQ1j2X/s3Yge2w0MIpQkgDv/fIezjWRwIsERIw/XaTD8GH1MBU112jXe8xtrgO8QQw8+NmLD+6zo18YAPfyOyjFZQ05hJcJw4uVPTARuT8GpfeAq1PIQlcYENHPD7xgmNpVtzCDpPu4KXe0UVr56ZHms4JRqD97C2dAgXZJYClgzZYEpXVhGbLeyGVBfCm8tnEB8Eaa+dC18Yy3h/4xsA6ufmm6w16QTY0wr7Q29SC8N7+vtgxDbqdyLX5SMPn8Jvl5E8A3esWQ5KcLahH8kv2Fc9IHTB5283gFQErKuURwaKfelX8rNpdKkHemLzt3uyTMZw309BCIBGFI0CbLEs+GSnJpsJI46ZBmxfgXlgYcYVZ4Dc+rsEwkGyMN6VNPzzkOfcOVAZ1ar/WOYjAMvf0NKa4oPMhwDyoj1zWku9fAa0OySSCPiFozv8C6Lg+nuvG6ZUTtSXa2oBkfmxZ0HkwBGGANS6FEYnNj7jD1SuDLL67eRgScik/qhbcQe88DFzuuMcLe26zFRStTZRnzK/cr
 1laPZuac
 nX5zHHahRqhBRwb8IxhQz5jBwCmQm5RcXj36JYx2PtZ7IrP8NePoJvVmBo2hLUK+cs51GE3K3DoSh4eTR4yJol9uClQVX8waTGh3igYjPdwqX3DcHCTzDBkLOnjAbz0lmMFXcfCxtgd6K5aSWcD7SVAX22xgduZ3DujLD2kJb48XDip2mmywitu1NVG94NwYw1foRfvmVdH+OKSuRhxbiyyoM9JxRsk/Xtz9Z2oULmV7ooAw6qaPanW4OgEDotDbmzFpWp0vaZw1KwF4cuTJrgq9u6dRs6GyaMEGWnq+dOTLDFMkb1wIcsr+FoIP+kfga1KYHLo8eSlXZMey8hoSjxPLXJz5XQ5EjRLDHglDYKSC0tNjypx54/DYkDeK3chlvPXmXCDK8fj75decBEzl1xSG5uaYtJS+UkHiZcqF4LsmtDD9v+IFJi9tW1+OPco9Wpe5xCPxvT2nFfJQ=
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
index 83eb707508cc..6f6d0fd7d62a 100644
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
index 8139e0b2f008..00ae4cd7f0dd 100644
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
index 36c44350f843..0633bc0f6f1b 100644
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


