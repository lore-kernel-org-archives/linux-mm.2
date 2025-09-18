Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E201CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498938E00D5; Thu, 18 Sep 2025 04:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444DA8E0093; Thu, 18 Sep 2025 04:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3347C8E00D5; Thu, 18 Sep 2025 04:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F39A8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:38:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C747C11AF14
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:14 +0000 (UTC)
X-FDA: 83901718908.23.3E6980C
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id 792DD2000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhP7WVa7RDhaDyA5+29RLr6cjKqGUn3ATlAHQhT16LU=;
	b=sWAKl4YN059AzCufS/lAa5N5I46jOC3AG65fQ4kEdKtbZ8lc7xPrWUbvYgtKiSITy97uUB
	obuwBr1MI1YF8LpnCB0nKX7kH+jqet8cSMyx6D4O+lmj3sCijfejdO6finfyA7+1vuh4kA
	r5o9olDPHtSFIBfQJoS9LYVFFImMaoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184693; a=rsa-sha256;
	cv=none;
	b=X+9pnn5U+yQyEW7qlzprJ1AfTLcp0jZSipAOSm+55ECDE2tx4ZICP719VFWb+jcgiU+BVN
	zTnnEHZ5mPrt9SpfxoisrfkM5s5SHktBsAGZaBNIT5lRPGlv16ehCgz1/G+FD1ZbE8HWYK
	keiFIzsmbFJ2vZ0l5Ysg6uMuOboKTEA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACnu4XjxMtolHKCAw--.43062S6;
	Thu, 18 Sep 2025 16:38:02 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
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
Subject: [PATCH V14 4/6] riscv: mm: Add soft-dirty page tracking support
Date: Thu, 18 Sep 2025 16:37:29 +0800
Message-Id: <20250918083731.1820327-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnu4XjxMtolHKCAw--.43062S6
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw15XrWrCrW8WF1xWF4kWFg_yoW7XF1kpF
	Z5GFyrZ39YyFn3KayftrsIgrWYvws3Way5Wry3Ca1kJFWUG3yUXF90grW3Ar98JFWkZayf
	urZ3tr45C3y7Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmFb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
	z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7IUnq-e5UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwoJB2jLv3UZdwAAsE
X-Stat-Signature: jpzmn16c4n8nnzpwx5rxy55iiaw8a8p4
X-Rspamd-Queue-Id: 792DD2000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758184692-390954
X-HE-Meta: U2FsdGVkX185h9BX2xwDT2Zs2N8uOmJxbYvrWlzwsj0U7b+3Y3ldWR5OAdVP1A0upARx7pd/3sETVXDPfkVDDtH6jTGtUyfIwkeIdXHx6sOrLlEG3bb+iKFJh8h9PPzCkZeavMN73Qfm6X0a7KDTpbcDWxLeSAstqKrnsCLf3XPgmXhUdq8wTZ9aTXg+J5XCaJWSyFNDce9hDHGf/GmuhpN0hOG8vQDSc/V+A8s7vtx0X/S2PlA9Lj+Qaxjp8Qc+xEcZ6LxxXuPQ1JuyQoqRZ4jkh9DN2JIPJGpL5/GJyfpcdY0bXe9Yfg6LLEtEXyfrT3Oj66T2yMoM5kaw17xSiIlEKIdfzqX14GZe5aQuHnIH/LxfeKs/rMbw7kcANReW6Cjci6F6CFwsadtPpsx4xcDtZ+bE9M3EEKk1v2+FiNEjH/1CZblepxdzyIqCJoa0e7AUnNvrVhc7B9nUHRf9NlTb6yOP/XK+IUAZfN9Qm+6vSEpxM8a60UlMDw6AHi63WqsnMWK3LUPpGwE4k+vr5Vzzt/765hE0NHb5cS1f59VSosIbuTQlDMxUMOyUg8bXnPT7gOfTzrToaVLm+mceUNog7qSTWIK2NZX07oljHpdPR1h+IOY+1acohO4FDugd3AFHZQxAzoZZ4hx4urIVpAiNcKnBAutco0EL7H8ogdJaky2/uLS7KESTEpMCQaAVt3PHgapkXpS4msRlhLcruoZJZj2T0wcrbzBt9PR/2livjJirh2vvqFEAVg4AAHHCRRDeIUetI/dily5xBiYQYAjjRHt6CD2wrapyvHEtDdS9Rx8nKv2EJDfbef5OQSfbgFh+TvGFZrW5y+6P0srwQOPDx7JZDDQmseOm9Mywl12277S0+B3SPTn/Fr3q8vQIr6xtDRtknclvuHzjb3C9pZSiZayU6vCKdPhiYMYmQsMpGD4e/aN2Xt4cwBygWZjFZ7kD0S/mVY6FwhQAaH2
 e3+ZOg8B
 xaBC6YD7fFI7xsb8mUkkr34oEXvj773qs5y0hdTkOQbjasBvEmsAYkj4OUD323HhDsLJo1v4wIfeJDLQR9sZL/1dVCW0lCeZ1x3DYh3pgLMFDUDqFgxv+Q3T+/haVo2mU8dUqrzdDqVYu/xhLa/uB8oAWGHYSwwNzDGUzARfgcKA4VP9Eq5zWnSKTkS9ixkirHRuxSMluQSSHYrki2ft9VVgFw9+8e0k0i6iSkAD8EOuu5184J3+HK94xLOvHOX15iboUqdqIDQvpb+n7SA+Cm0Z45UsRWx7iTnLKw5ougalbMZNaq+qXVcU3ZZJ5iccTiM/WBvVOh9fB1bI=
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


