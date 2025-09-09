Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2224DCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755648E0001; Tue,  9 Sep 2025 05:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706386B00AF; Tue,  9 Sep 2025 05:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5088E0001; Tue,  9 Sep 2025 05:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2FE6B00AE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBBB91A03C2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:06 +0000 (UTC)
X-FDA: 83869258452.08.F49E3DF
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DFE2120006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+VFnZvBAHHp+QQjU5fot5yfrjobnA/q46yQssQMvQY=;
	b=M/T/iTb0CWghHTerd5O3RduY66Qmwkxo5hd5G1IIOuKNlfceYq3dpzxbqKKyHw4qsKpL92
	Qw3emLTWhjeE3BA3LW5RL6Uwz8QQYrEbwdPY1ki+rS+wdLSiCMpxWjQJFGBcDIFF/ri/e9
	Yd1V5symGUbdyhgInoxEgGlXjkx/NNw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411825; a=rsa-sha256;
	cv=none;
	b=FRRHYrOCdj14Nk3oybnARz4AtTEK+8gwqWGzxLunaS0aaRPHRb+rDdmyMO+plesW1/IORW
	OFNoqZxyKbOTYlVptQovG5x751SF6M+P8Ec7xbgrLAkzIbRbvdgC8F7CJFLmUt5eO3eY9/
	YMOpPq4C+HjNCG8sLL1JKoK2I5LaJZQ=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADHHqHO+b9oWh7qAQ--.61766S6;
	Tue, 09 Sep 2025 17:56:33 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V10 4/5] riscv: mm: Add soft-dirty page tracking support
Date: Tue,  9 Sep 2025 17:56:10 +0800
Message-Id: <20250909095611.803898-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHHqHO+b9oWh7qAQ--.61766S6
X-Coremail-Antispam: 1UD129KBjvJXoW3WFW5WFyUWry8tryfuw4rKrg_yoW7GFyxpF
	Z5GFyrZ390yFn3KayftrsIgrWYvws3WayUWr9xCa1kJFWUG3yUXr90grW3AryrJFWkAa4f
	urZ3tr45CrW7Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQjb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
	z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jQVyxUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCREAB2i-5zJK+gAAst
X-Rspamd-Queue-Id: 9DFE2120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gyf5xdg8z3fsygs4e7hgi35x7w4dnyqr
X-HE-Tag: 1757411823-642082
X-HE-Meta: U2FsdGVkX1+4dk85wPwjhp+VH/qo9/DnRpXJMHQOYaTbJSS12pEbSIUA+VjHOzSiR7FPU7bm3Bg9AxRHedQpWbGLEOkOjZK76R/kd0/DEDwbOGiukGYdy3s5Pbfm9VZE9HUkNdU0yMNbbCX9NEpq52ALmJ0y6aYf7wZMF+xp/96BsgkuhAjfJr/0TAAcnjo3f2cUasfPKjORUTZSvZkCz4fzBiWrLsbrobBpJogh1Tvbbnw/VDoySmdkBlfIW0VgVUd375+2za61hw1J3N3wWI80ue2zm3TmA7gO6yDX+4ZYNK/VVFNsDQtIRzYZYrdGsmnfSAbiZViRlpq6iVzniPA3AF8Jj8VTkuoB1lWg5SBlzrH3hOSM/oVBf8mgElkucf9QNmmiK4FrPQQttuVvDTuzA9hOD+l8aklDMYj/5xshZnAKfixIvxHNo5gCEUISPFIMifxgTBrsNalNfLMOGJvFUnkCClITU+ksIk2u2Qw7frcnlVe7teoG6mUhkgoi0ZEJ5MPlSVVgYeYXdwGY/96cP0cySX4dmqBX8dj2W63hqepv2sYBSHhdMPCbnDorG1TlY7hDMSSt3zpT6hG9Men36E+tqErebnkkQXx+vNs1/nWK4gofUHjBCvWg6jLj7bDkitJwKGkpAPpEk0RQql72YUin5uWWj3f4DuFzlS5ujL2z8wep/jHikTeosAArI8zAaIzaOMJ5ssbcEzaD7uloy1jYIa3KE8LXZN1+GxDwGPZwMN0ScoQIvjnGz5K7UINAR8Mrx4DK4WJBh7VO9jtzFDq6WJrnDSg5DbNHHQwxIc+elGNchGa5NWPAGU8nspyyfB637SPepHajkwTHcxcU5Bzj7t+OzsIcLAT4GevLz+cW/mF0D8F4jqKeWDtaiDuFI9ObfjAUjXJ9e+HI/9yuF8CR/Sqh2zMv87NB6a1oUTI1fEkCA0a3MxMNJnukjvKBNK8yXEf7R6gjkJp
 qSmhGOWR
 EJZx+cPSd8yN+m6Gz4hEhftJ1+i85zOhxJn/WGXN+ratjs6/MgTwji4ahmqVEB2w87OULFDpv7cwhNV5Nf6rnZv2kpNboV1BGHxzy6XagOj6As3eyUCyfmUjyAjgIf94bWBgGIXNF1HEO7bnvmAzHpMbIMCGX4M6kf79Dd2zY15t33nXTHEDndkuN1I3c+km0Bcdi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Svrsw60t59b extension allows to free the PTE reserved bits 60 and 59
for software, this patch uses bit 59 for soft-dirty.

To add swap PTE soft-dirty tracking, we borrow bit 3 which is available
for swap PTEs on RISC-V systems.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 arch/riscv/Kconfig                    |  1 +
 arch/riscv/include/asm/pgtable-bits.h | 19 +++++++
 arch/riscv/include/asm/pgtable.h      | 73 ++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d99df67cc7a4..53b73e4bdf3f 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -141,6 +141,7 @@ config RISCV
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_SOFT_DIRTY if 64BIT && MMU && RISCV_ISA_SVRSW60T59B
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT && MMU
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 179bd4afece4..8ffe81bf66d2 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -19,6 +19,25 @@
 #define _PAGE_SOFT      (3 << 8)    /* Reserved for software */
 
 #define _PAGE_SPECIAL   (1 << 8)    /* RSW: 0x1 */
+
+#ifdef CONFIG_MEM_SOFT_DIRTY
+
+/* ext_svrsw60t59b: bit 59 for software dirty tracking */
+#define _PAGE_SOFT_DIRTY						\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 (1UL << 59) : 0)
+/*
+ * Bit 3 is always zero for swap entry computation, so we
+ * can borrow it for swap page soft-dirty tracking.
+ */
+#define _PAGE_SWP_SOFT_DIRTY						\
+	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
+	 _PAGE_EXEC : 0)
+#else
+#define _PAGE_SOFT_DIRTY	0
+#define _PAGE_SWP_SOFT_DIRTY	0
+#endif /* CONFIG_MEM_SOFT_DIRTY */
+
 #define _PAGE_TABLE     _PAGE_PRESENT
 
 /*
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 91697fbf1f90..b2d00d129d81 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -427,7 +427,7 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_DIRTY);
+	return __pte(pte_val(pte) | _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
 static inline pte_t pte_mkclean(pte_t pte)
@@ -455,6 +455,40 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#define pte_soft_dirty_available()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)
+
+static inline bool pte_soft_dirty(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_SOFT_DIRTY);
+}
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SOFT_DIRTY);
+}
+
+static inline pte_t pte_clear_soft_dirty(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_SOFT_DIRTY));
+}
+
+static inline bool pte_swp_soft_dirty(pte_t pte)
+{
+	return !!(pte_val(pte) & _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(_PAGE_SWP_SOFT_DIRTY));
+}
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define pte_leaf_size(pte)	(pte_napot(pte) ?				\
 					napot_cont_size(napot_cont_order(pte)) :\
@@ -802,6 +836,40 @@ static inline pud_t pud_mkspecial(pud_t pud)
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+static inline bool pmd_soft_dirty(pmd_t pmd)
+{
+	return pte_soft_dirty(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	return pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
+{
+	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
+}
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline bool pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return pte_swp_soft_dirty(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)));
+}
+#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
@@ -983,7 +1051,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *
  * Format of swap PTE:
  *	bit            0:	_PAGE_PRESENT (zero)
- *	bit       1 to 3:       _PAGE_LEAF (zero)
+ *	bit       1 to 2:	(zero)
+ *	bit            3:	_PAGE_SWP_SOFT_DIRTY
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
-- 
2.34.1


