Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F775CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7201E8E0019; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8758E0001; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541F78E0016; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7028E0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D7191DF310
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:33 +0000 (UTC)
X-FDA: 83891075226.23.E6500B3
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8DD9C0011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931271; a=rsa-sha256;
	cv=none;
	b=IdG7UQtM5OWCWorbcpQBNPXGbDS5v/BWqLkAO9GFg/D0o5NXh1dQW5u9gBZEXTvKY++ccM
	rOHV3wh8hwsCAdbwUtGEeN+wAJOWoBraH31uCPVr5B6BpH/9yR002qhzGZ1kT2F+s/Z69+
	/LOSJZz9SjV34vyxQfG5Ifa/INUuMXU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3BR9xXbAEaDCNetFz9rtxVEYF4lmxeDOE4KGlVyJeQ=;
	b=oey9LaEiOpM3g7LzMbLKjPAZi7Mmk0p6gfztiT06P+8VCm5m/Phz7YF3RpCJ4BF+mchqPG
	skZCJxCerOXqSUdYosTR4RMZp7ZYNbV6xG1nIXQR3ikiWrYLEB2xEdPuIU1O1s4d88Om+I
	e2kVZ4UQfN04mkOHnhV98Jv9lzV/9hA=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAD3lxHf5sdoHWn3Ag--.53429S6;
	Mon, 15 Sep 2025 18:13:57 +0800 (CST)
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
Subject: [PATCH V12 4/5] riscv: mm: Add soft-dirty page tracking support
Date: Mon, 15 Sep 2025 18:13:42 +0800
Message-Id: <20250915101343.1449546-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3lxHf5sdoHWn3Ag--.53429S6
X-Coremail-Antispam: 1UD129KBjvJXoW3WFW5WFyUWryDXr1rGrW3Jrb_yoW7Xr13pF
	Z5GFyrZ3yFyFn3KayftrsIgrWYvws3Way5Wry3Ca1kJFWUG3yUXF90grW3Ary5JFykZayf
	urZ3tr45CrW7Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmEb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcI
	k0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4U
	JVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUn3GYJUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgGB2jHtULAQwAAse
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8DD9C0011
X-Stat-Signature: 1paispk3nnxzbux6a6mhujnyxqjy51bg
X-Rspam-User: 
X-HE-Tag: 1757931269-69137
X-HE-Meta: U2FsdGVkX1/tDrd2OfiOwPJUoBbCzkYbertvt3uPZGeC3NDSgpQOwwr2KzjpNhA7OLenn+/afkseDeDSnyqL/4l0nynxprdCGLmdai6qkRr1nkqdr2L37Y72LG+dUpmyjizxA/dIhDi9LUamag2nSsJWyW6Tp3HVrNUND4SmdISWxJbIBcGBnWbQEkXQwq0oJTkveWalZXVS1fKsbYV/Ovpll8zJIVIB0uHOeNXmvZkvTFIi6oeBvAjUGbUS7xOJEVfjV60nzlcH90XcsSU30vMzTFyHzRo2Zyhu4YFFum0t5R6a16gpdjWwbCAEfocCiq3HwVtZUgbh02frLGtx03YBrtmxlqrgA8IoEts5RgqxSQ4KN8eAfYVr6DdjMznSBz1Y5azHwbePovZGM47cci0VN5c4cPIK+nF6cOC2SNKIm3QNxjCMuMGNOStQEgj2CTxOcx+S0YYgkLewK2eLSEGc1ZBssE9ebEGvY3zd/qTwX1I2h7F79X/2pbeM/jVexBeYJ15EeFZcyeTS4w0K8g2vM2mZHJYkFUuXcY+OOUEaH+dDyAo6yJ8UcXJ9cS6cglIGdpf6JoghhccZnzxfvow4pNPDXUZmm+vYGW/svp7S2ReTRhZrfzmysjLTQLkvMPBDje3rtW7EoozWKLGZ+XERT77AAMZ+PkmO4BTg/DZCpiC7/tbTm7Gc1KOF5Az7wf2fJhx6kZCUfxDZKVGja9UzJzLfRsJIDwkTYML20ThwV3wRSVGhZGdF2J1+YlRDB5L24xzlriIiCdXjAcNEw/2mCO6DsvIMbfQqUPjvynSNTO3gpHPbvr9bTSR6HnwMPptu8Lib2FQD8wD6YVP1vD5WyyKD695tPEhNvO7yIWtWC7B9JASsZprDpELxv5SkPPP2fjaskLR0C9dR8PCabeExDmiwWQ7jf1wYw5tAaTiekeArKoqs8h7CRl6uUusaoZibApBm6PJOTtJZXet
 kJLPd65D
 tmabbqyfPndbfw+REwxtLQ8W/baxfvnzFVHRVzCfkibHkTlEMB8CZwcDXgxd1tKYe8gAail+qXNQQW3utgT4k3ry0QXS8EMacMJEmexM8xmfbWXPGlTVOmJQ1gRWYNKg0do40bbbygYitMzf57hAvFli6HjqFNbkDj6Yk15ePlGjDPSvxGMZ63r8I8fKXFozu05uPFZwQb8sv27QdrQDkkSCLbGwUTYwfyRvbkOy9lyeJwkw=
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
 arch/riscv/include/asm/pgtable.h      | 75 ++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e1b6a95952c4..db3337300c4c 100644
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
index 91697fbf1f90..28057afaee33 100644
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
@@ -983,7 +1053,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
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


