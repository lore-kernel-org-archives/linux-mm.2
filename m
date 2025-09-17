Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2073ECAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53F08E0010; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05168E000F; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57078E0010; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBFE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53B9E1A039B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:47 +0000 (UTC)
X-FDA: 83897332974.30.484F7C3
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05F4BC000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe3dGdnLdXHG/zv7BBC8zwyJe6cDbr6ySs0wYxHhjeI=;
	b=Ry64wq4F/9v46RzW8ShODTl6BMj1A53kwByAdoOyOZPaX8VUdiRxSEw+Y97xr6Y3SRgJwl
	/29ZZ6bG1OkNOfe+yTrIsFNxRaSZUIbcQPy4WBTNDQwfiwso+gnBJEChGQk1Q5JMnI8dq5
	NpOyMdZ66+0RV+bXSz3LxTy+42FXUug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080265; a=rsa-sha256;
	cv=none;
	b=mDlDL4t2YdQ1RezH9LKn1bqd9P8tjtBNN7uCzw6/0NB7b1NXMReVEQKn2hDOKjJOqBZYnh
	rj+r/nIsqVtWpVUpNq30qo8lLjdVxJrLNnlugYTOhpeo8m6KihspHs9X9B8ULuRwq4qXuH
	05+mdAjb7auHBH5IjFLsBVxdi8Y11l4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S7;
	Wed, 17 Sep 2025 11:37:32 +0800 (CST)
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
Subject: [PATCH V13 5/6] riscv: mm: Add userfaultfd write-protect support
Date: Wed, 17 Sep 2025 11:37:02 +0800
Message-Id: <20250917033703.1695933-6-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZF48ZF4kKF4xKFW5urWrAFb_yoWruw15pr
	s5GayrurWDJF97tayftr4YgrWrZw4fWa4DWr9xCa1kJFy7K3yDXr95Kry3try8JFWvv347
	WFWrKr1rCw47JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	xVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j9Z2-UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCQ4IB2jJ8TDyHQAAsH
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05F4BC000C
X-Stat-Signature: czoksokdmjg4crrq8jzpjf6n43fg78my
X-Rspam-User: 
X-HE-Tag: 1758080264-389283
X-HE-Meta: U2FsdGVkX1+tmUw0BY0DpLmR+nleqcaFNocmBl+1Gz1nURqyTHA8fb7IplyM0Kjil90z7ouTeSWv46bdXWUCSvN2NFKLG0geD2ig6R6VrbT9RYO6tWuY5u++DYsSzOCqZmCAlxcCd+nbEX77dnhS70LxjYNEi5hiVtzCpga+RTfOfIMWN/o7gralTkb059WourbNoaCR2X4yFxRZzW8ZVWiFkfc8pJYlYgrNb0Xq3TOUo5WFGa8OoVdd1NtnewRR+qzaoCMzbGqIALqjC9JAdOEG80D3YRa7uP4BjN4el7mfqZ3GmxEKEcIbVBNTtoT7IhKReXfL9yTv6ogRXgQ6tD5cbwOSAff/JvC49hPuN2AhFpSi8W0/KCmP+aXCLcGev75jCsPposUdj/O+Q5dt3fR8K3I6nzUNC/SU0mbz/1N3bh973pSRWc9f/TtVfBsY8lUJ9TLTg8J+BT2CFPkaeJ3+/5ABzX9ytkY2So/v5ye/RN18/uas5EmMQ2GUdXg/Nlz/fZ5uKEwTnIPZav4K+2Afe+btWVUx4t8KRwuOcpbiQflWrvd122h1mCPyd084E/17FI1wceKDJKyFg6fLsfPwPVnRkyqe/i2HjpAIKyPHUlKSb2tneozQFvHF+YT7RfqkMn8NTU6Qnj6KZsgeFac4ngU5tZN+bD41hbt/i5fqnjmX9UxRocpT9J1U7sKiIYh5I5da2GGB1TKgEg7lOPr2MJQVFnfA3UdoubOY+C0z2bL1o9naDj/QZm00Nc8hmrd+ybIcwVw5HepjXQrBXMGv6UPwX2oiGHX/1byhlIy5vIVNWo1vFQz3GAdYuSTA+Rzr3vPznTRuTTOQimgoj1MROJecMDTQ7ekO50bMnMNx7d52JPP4OSHpy0VtOS3/wDG3nel1r8zxkzMU/DThWkr54FaWNd5RJBXTxZzswiS6SAEoSDNlIV0hT9+jgBUq7j3B9ydCSzBEuu+EnD8
 q55uOK0y
 iJOVu75liCFYzfpbY35zbKujPbx5v3k0B0oHi2SkN9yZVrG3+SFSVz2mJaNyErOW7TETbDgudwnXOYE++FRaCM6C4dVZxvLoUMPHrqamDl4VN6E2or86tGOfnWcGMPC6GJkkH7jTV8/K5PG5hs8GQ7d7gCDgRcku60eElADnUf7NGx1JnqlyS06iN2M4hHRqKMLHl+4MaDWDlyFc=
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
 arch/riscv/include/asm/pgtable.h      | 68 +++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

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
index f3bac2bbc157..b422d9691e60 100644
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
index d7fe0f78107b..71e84c114dc4 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -416,6 +416,41 @@ static inline pte_t pte_wrprotect(pte_t pte)
 	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
 }
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+#define pgtable_supports_uffd_wp()	\
+	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)
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
@@ -838,6 +873,38 @@ static inline pud_t pud_mkspecial(pud_t pud)
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
@@ -1066,6 +1133,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
+ *	bit            4:	_PAGE_SWP_UFFD_WP
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
-- 
2.34.1


