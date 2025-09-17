Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8817ACAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB288E000E; Tue, 16 Sep 2025 23:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A8A8E0001; Tue, 16 Sep 2025 23:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C795E8E000E; Tue, 16 Sep 2025 23:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3BFA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:37:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62FBE58BAC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:45 +0000 (UTC)
X-FDA: 83897332890.30.948DEFC
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf05.hostedemail.com (Postfix) with ESMTP id EFC3F10000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhP7WVa7RDhaDyA5+29RLr6cjKqGUn3ATlAHQhT16LU=;
	b=j6DSBfdtPuU2iHwE4JY5iyHRGjwbpYRYbhlitZxSfn27JAU6mJBTfKFYI/dPDmfZVmi4r7
	Fz21i1XRh0Kj9zTwb3s5r814BZez2hWdyWe8NyrxsLUYijZUpnuat6SK3SAQYnopXQujQr
	oGBdBSdUX6U94/H2XYIJyjTc19FIyk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080263; a=rsa-sha256;
	cv=none;
	b=XlmurvAmuaguXtuDn2rtSYzZ2DzVZyxn2SmtyEejMf7kffnNSgCq47XsuR5YGlfQJW7R7A
	Aez7DpZx2LwUVX8yOVH9R1K5yOJgEVxmyWCPizV6bgMiGBXgtogVaZgH5iuwhnqfeGkM8n
	KplPVFvjMwIIXR5uJnvtdKpyeDwrwrY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S6;
	Wed, 17 Sep 2025 11:37:30 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Conor Dooley <conor@kernel.org>,
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
Subject: [PATCH V13 4/6] riscv: mm: Add soft-dirty page tracking support
Date: Wed, 17 Sep 2025 11:37:01 +0800
Message-Id: <20250917033703.1695933-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S6
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw15XrWrCrW8WF1xWF4kWFg_yoW7XF1kpF
	Z5GFyrZ39YyFn3KayftrsIgrWYvws3Way5Wry3Ca1kJFWUG3yUXF90grW3Ar98JFWkZayf
	urZ3tr45C3y7Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQjb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
	z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j9Z2-UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAUIB2jJ8PfwbwAAs-
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EFC3F10000F
X-Stat-Signature: jzgyh38fase6jukhk8xbbaxatma8wxzk
X-Rspam-User: 
X-HE-Tag: 1758080262-705743
X-HE-Meta: U2FsdGVkX1+teEPFt7XKyb33QBE0sopZYTMw8kZ3kIh+FXHTXTCaJMcdL6H/Hw2mM35FdHKzl5Dd9mrjQEfd1pna30HmAef0TG0PkJdM0o4LLdDTzY3d7AKI1wLG/lQWvC8r8Z/KnokjJtUzVffDtR1vb8PzYMqdnU4nDtuY0I426T7uMUIb0tcJ4rLTIU7afD7o5aD5Onc64eLGayWw1NcbWinB4ac7YVHGB45Nzd4nymHn257/It3LnLz+gcKdv5c2cw1xWqE7QZ3UfhMre8xgwbUir6EkEa/s5lSfz+6GooJy3JoTR9bE0cvRTjA6Hisf2Wj4UC7PEONSVEsr+v7wqIi6fslehmOZ4q++A7YLv4Nv/YearqZ0wayfuxIwMgAyY/9Lg4PGzj3IiEc8fRDABDA5Z/LX5x3CYUI7pQVuh/7JL1OPSaGCMyPfMWtRVltQHR9voUhVSUfnJdubPKgQLkggjzeVDaNZdZrKkVmlxPP8yCHqNQ56dhDArdrrDTdjAUzBMKmEjEMna/+PFLHVfRPpKHN56mGjZfB17e+fCYE2lfjO6UlgrlHur566ggnN96Rx/AD6sgw+dZi4oxzLAJTS/aX6VoEnp1OSzoo/m67bxKzPzyK9qy7pCT7nn6Xe4b8gahhjnJ/msbUVRu44UYd3/tbfb8xwRRM1AKPcdN55BVRhLbi+DkwnURoanyn/3CI2Wox9Gqt613ZPmh9QZwNtUSBaCbuQqA4w59y2qKQ5BRGyt5O/nCSSBBDBpdDmszBLi0MkzcKtJrcIBut5U1omAmfUziqA2P4ef2zqZemNl92paLNaIffGJC+5zwVmP3VDH7MNqu7+gLaaJxVJgjzaMETIm51YPlCbDN+LRhGLl/uy5AnlfFBkPYCpZee70Rg3zz/cCjgnEtUdDJ6DSNY8HkEdrLDBHsLzG1Ml1gxuaVhz4GyIJCJWbuR6SyiBNeJMVeIKQQmSrne
 VP7o/vjJ
 ku1nsgXMszGhjfNLnR4fsWNZmim0fR1ygl7F6BtdZ6SU37v8QUaakQIBMG2IIX6j2ScfHMFjiWKIDWdyEQbCqFF7gL3yp74LO3qYHXnpekS/6M+EjBpJ8vrUp8A3SOCM/OLcJyu3oKJUplDtCjEGMviPCx8YINB+BzFHpZ17KO2DZWzmGct+G3VrgqVugyzRz0Y3C4MZuhZrbR7CKoyNhmpKytKlr1wLKwI/WguFumBV2ps4QpLRW+MtIzntsALaKMYMf0B64QxRJRYByEfOd+Y2xjh/CmuJ7ivu2ABjJLWO7K8Z5vy9LW96XHqC3zhA0pmvFvmival04Vhw=
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

Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 arch/riscv/Kconfig                    |  1 +
 arch/riscv/include/asm/pgtable-bits.h | 19 +++++++
 arch/riscv/include/asm/pgtable.h      | 75 ++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 2 deletions(-)

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
index 179bd4afece4..f3bac2bbc157 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -19,6 +19,25 @@
 #define _PAGE_SOFT      (3 << 8)    /* Reserved for software */
 
 #define _PAGE_SPECIAL   (1 << 8)    /* RSW: 0x1 */
+
+#ifdef CONFIG_MEM_SOFT_DIRTY
+
+/* ext_svrsw60t59b: bit 59 for soft-dirty tracking */
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
index e69346307e78..d7fe0f78107b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -427,7 +427,7 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_DIRTY);
+	return __pte(pte_val(pte) | _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
 static inline pte_t pte_mkclean(pte_t pte)
@@ -455,6 +455,42 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#define pgtable_supports_soft_dirty()				\
+	(IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) &&			\
+	 riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B))
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
@@ -802,6 +838,40 @@ static inline pud_t pud_mkspecial(pud_t pud)
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
@@ -994,7 +1064,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
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


