Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006FDCA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3EC8E001A; Fri,  5 Sep 2025 06:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461B08E0019; Fri,  5 Sep 2025 06:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8438E001A; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFBE8E0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6357011ABF5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:37 +0000 (UTC)
X-FDA: 83854845354.16.0F379F9
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AAD78000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnkSifx7hJeAOWVYoqeJzirQNFS0EBZQRFdV/2oNYzI=;
	b=fdoDxvyrW9uYAjwkAtN+egGnNLMqmubbpop2a42wEy/ie1LlITszxxxtRTuIaBThCnzbAC
	DN1Bfed5F65xdmkVH7T6kcU+ieaLgKIWRmEEPZsRiKcNJ3RwDeJI/enAOyCfE5S6OYmfuI
	X6UjVk/aMukSnoSmhYfBaY+dilmEhN8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068655; a=rsa-sha256;
	cv=none;
	b=ZY/Oq4sPj/08UhVtjeXMWbT09VMk2LDNIbJlxx3n5M5G44mfa35tWS/RBxMvwns/VlGrTy
	AQvt8y2/Z6B+wcHRyljON6l7pHnmq0rezYHCYILc1VJY2WEEX6u1DdljYWeJ6NOOogDVFd
	tLi4ZYwZIEsqbvyZ37NhJlnkyUYLDXs=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowABnwaNMvbpoocLNAA--.50311S7;
	Fri, 05 Sep 2025 18:37:02 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Kara <jack@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH v9 5/5] riscv: mm: Add uffd write-protect support
Date: Fri,  5 Sep 2025 18:36:51 +0800
Message-Id: <20250905103651.489197-6-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
References: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABnwaNMvbpoocLNAA--.50311S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4UZw1rtw17Kr1DuF4kJFb_yoWruFWfpr
	s5GayrurWDJFn2yayftr4FgrWrZw4fWa4DWr93Ca1kJFy7K3yDXr95Kry3try8XFWvv347
	WFWrKr1rCw47JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmYb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIev
	Ja73UjIFyTuYvjxU-0PfDUUUU
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwkQB2i6oq1plwABs7
X-Rspamd-Queue-Id: 8AAD78000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: oia4hgnoxtdk1dakr8z3jgs9i1844crc
X-HE-Tag: 1757068654-958594
X-HE-Meta: U2FsdGVkX18FAdOT1G4S3bjaukNkZxgCXStoI5zEzYNiU4jVdEnVN86ozzvhzdg0JQBq/96rKy/cbymv/KLtTlMgTb7sRxaxZ5Y63UEPy8Ln0Jhl5RjStblwbGFTOFuEn+9whAOifc5uetbffZwcz84aCNHhPDqURT9i1WA+yCSJ5v7CUoZar0z4ufpsj2orPmnPOzjro+VkWnkEWJrlFTf6f0D/pSrMc2nBBkBhHA7T+GA/3g2GbmcsYOjZjSwIb8X7EnmF33AfSxrnrg1XoBeFL9Rtb2gBcy5Fp1lFFi674p1HUg3Q5YgHGYGIRgc3G/caEemInfcSxuKBKSsdjrVmTUcRHGCaA0/0yT4O+4FaZEpJqKelGDpVkRC9CGI/4bXLxKpwSvK4wz5W8YgJfs/iL9MbcWWi3oeevhKe3SjY8a7auwZZ3395beJpWhs8ioJIi6UGaAZDxbUEVao4j8pgpVHvxcpneiBqWQJbDvCd98BfR9/xAXW7qE1Xhyc2XGb4VOnrI5oc3X68MXt+AxQTu7fsdfEYW5AMpkK8BFf7JWhI1POuOgB46iPTNggpWLqbKABSVv1XNR4jKMmlFUwCrNmOA1yr7Wc5bNZBM6hdlhQjNSQaPqZCzCVnyYqKohQzviEkhMeUwFKSS9RJDX3XaYPuX3atX0TNmvj550nFm6QG019DfapuM5wf16WioCPK42crI6wI6K53D5VEi7r6tohGMM/3MWcGqyEm2xbZLggPIdFKsC9qNea4USQg+VQfA0nC+iYcHDhAODG2ltx2wp2CnMH5ZY3nhuxoy6vBKhL6QZ5SbWzKliPYUhnyJ6gqVyAFZaCiDGQQG2qzwbt4FFMvKe9AIhx7TjPheYtdrNU0IiwmuWut9DMtu1kAEsLDRMIkZaQIzeMeRUU6m4URbj253uqcc83MViwSOdQc19QJgq247IrEvyOpEkSpROwuLXRAmgnMU9L3Yt9
 +HQAhrWW
 SpIDzdjtMskht3cA4GhLu9QxOQfiOCmTdSWYgos7wlXg533TZvX466hPs5xXdJcTgNX+o2x/affZXdecG7uwsX9hO6SsAK0s9bhtoQj4q6n/diB8PaLlSqbRYElF+QlT7jXlxPhoEDlRIZ05xf7jD62OYP4Mog4OqPEv3D5pQmWFWCAt7NqWl1Mb6M6zj9DyY0NG/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Svrsw60t59b extension allows to free the PTE reserved bits 60 and 59
for software, this patch uses bit 60 for uffd-wp tracking

Additionally for tracking the uffd-wp state as a PTE swap bit, we borrow
bit 4 which is not involved into swap entry computation.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 arch/riscv/Kconfig                    |  1 +
 arch/riscv/include/asm/pgtable-bits.h | 18 +++++++
 arch/riscv/include/asm/pgtable.h      | 67 +++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 53b73e4bdf3f..f928768bb14a 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -147,6 +147,7 @@ config RISCV
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT && MMU
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if 64BIT && MMU
 	select HAVE_ARCH_USERFAULTFD_MINOR if 64BIT && USERFAULTFD
+	select HAVE_ARCH_USERFAULTFD_WP if 64BIT && MMU && USERFAULTFD && RISCV_ISA_SVRSW60T59B
 	select HAVE_ARCH_VMAP_STACK if MMU && 64BIT
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CONTEXT_TRACKING_USER
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 8ffe81bf66d2..894b2a24fc49 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -38,6 +38,24 @@
 #define _PAGE_SWP_SOFT_DIRTY	0
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+
+/* ext_svrsw60t59b: Bit(60) for uffd-wp tracking */
+#define _PAGE_UFFD_WP							\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 (1UL << 60) : 0)
+/*
+ * Bit 4 is not involved into swap entry computation, so we
+ * can borrow it for swap page uffd-wp tracking.
+ */
+#define _PAGE_SWP_UFFD_WP						\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 _PAGE_USER : 0)
+#else
+#define _PAGE_UFFD_WP		0
+#define _PAGE_SWP_UFFD_WP	0
+#endif
+
 #define _PAGE_TABLE     _PAGE_PRESENT
 
 /*
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b2d00d129d81..94cc97d3dbff 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -416,6 +416,40 @@ static inline pte_t pte_wrprotect(pte_t pte)
 	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
 }
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+#define pte_uffd_wp_available()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)
+
+static inline bool pte_uffd_wp(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_UFFD_WP);
+}
+
+static inline pte_t pte_mkuffd_wp(pte_t pte)
+{
+	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD_WP));
+}
+
+static inline pte_t pte_clear_uffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_UFFD_WP));
+}
+
+static inline bool pte_swp_uffd_wp(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_SWP_UFFD_WP);
+}
+
+static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SWP_UFFD_WP);
+}
+
+static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD_WP));
+}
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+
 /* static inline pte_t pte_mkread(pte_t pte) */
 
 static inline pte_t pte_mkwrite_novma(pte_t pte)
@@ -836,6 +870,38 @@ static inline pud_t pud_mkspecial(pud_t pud)
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+static inline bool pmd_uffd_wp(pmd_t pmd)
+{
+	return pte_uffd_wp(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_mkuffd_wp(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_clear_uffd_wp(pmd_pte(pmd)));
+}
+
+static inline bool pmd_swp_uffd_wp(pmd_t pmd)
+{
+	return pte_swp_uffd_wp(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkuffd_wp(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_uffd_wp(pmd_pte(pmd)));
+}
+#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline bool pmd_soft_dirty(pmd_t pmd)
 {
@@ -1053,6 +1119,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
+ *	bit            4:	_PAGE_SWP_UFFD_WP
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
-- 
2.34.1


