Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F295CAC599
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52248E0001; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0ED48E001A; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA2F8E0014; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50C328E0015
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EFE81405AD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:33 +0000 (UTC)
X-FDA: 83891075226.21.06E8618
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AEF21C0016
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zYhe0k63M+///2lqLVRsXelBZxrEyxRJwO9ZPqGvNQo=;
	b=BnR8Sj9FPuuq0xKhzbw+6lUWvx/LMIn7rGw1TqnoQd+eBhtUcV0dsyqy1PnDqw1pxHmFvr
	ohdPEhrswU94JfIf3n6ZA7RwVwrhYbgJKYGa36CQbRW8bUUvkboGkrzv1jya7rpacz7+Uf
	jjE5iNJscxz2m9IwqNcF7ahiiF28CTw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931271; a=rsa-sha256;
	cv=none;
	b=km2BTaW6XRJSUzaf8MHgQYWWoefGX9CC4JjMoBEABWIq7HgSe1xpcfFtPhiAz7DvUVqF0J
	a9XIi07z7iQNWct1BMEFRXHGb1/Gf4ll+YkLR342xMh/cfoOWv8HNAJtyip9U10CQre9Qj
	aozXrwywekd/H2N5P41FI5fCwpl+g3I=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAD3lxHf5sdoHWn3Ag--.53429S7;
	Mon, 15 Sep 2025 18:13:58 +0800 (CST)
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
Subject: [PATCH V12 5/5] riscv: mm: Add userfaultfd write-protect support
Date: Mon, 15 Sep 2025 18:13:43 +0800
Message-Id: <20250915101343.1449546-6-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3lxHf5sdoHWn3Ag--.53429S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZF48ZF4kKF4xKFW5urWrAFb_yoWruw15pr
	s5Ga95urWDJF97tayftr4YgrWrZw4fWa4DWr9xCa1kJFy7K3yDXr95Kry3try8JFWvv347
	WFWrKr1rCw47JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmEb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
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
	6r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcI
	k0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4U
	JVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUnqNt7UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgGB2jHtULAQwABsf
X-Stat-Signature: j6gj6z4uf7g4ibsgoopjr1kyhejspbax
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AEF21C0016
X-Rspamd-Server: rspam04
X-HE-Tag: 1757931269-472837
X-HE-Meta: U2FsdGVkX19TrlsoSTI7GurslR1hIaIplKFZqVZs7V4izuN3fnSK9w3X1IzwbgJ3NMtXnGstyNlRb1x7Vd1kX4gaUJpQJFbOvZuaDcpB3b2+CdPlJfyikHaov5R0dhPvP7z4PGWAPka2VvbM7f/ZsovXzMldhrkAeqnszs4SlSp739iFmpXPa4qiO2/PPcoksi8pn0yJfihBWDACTNfKHk44d2CiOTQryrOsVBpsP2XEjo/T2Kt9jBp4USSuj/x/1sSR3OdAhjwqjUQuc21P94lsptPnmwks8oNn7zhFLVuyZkcpArC8irzUgJBzlOFbszuK+1XaZUYIj78C0JvejSHM3q2tfnItttIIxjbXt23TAcAQ6HYZVEtsiCzeWZPIvneSLEbAFbmRqaruepSlg5Ln4RY9PXHNNTOPGyqAuBUyheWBePd0GPFqQI4nZiz8O7YzJ5F4U2thVwIT5HsEy0MWUToU+y39JCeSR8FzBtK7cbyO8LGow+zTduJWF+8Awgz0PlmJ/btZFfREM3TdPb9/7ZCnnXzKVldZBmTLfXO8u/8WSy/236Ze7/WDvyy0mFTNWOATZmcVGsqZhHut3KDNFA6uyMQfgE90LJbfOi6QuhG2xV0oM1ERmLDbyaZp7Zh8jqCzZIedPTo8u3touX+cx5p77nRxbndXwzG8doflHzFLKwva1Q2TaJEaqKBp5NhpzVLtTwbvqFpGpZ6PyzEe5usEWvUo9+dLE1w7VpqqjxeUomwarly5ocMmITvddV8upvap6sDknITO1T3xBAj6ncmBkoJXnNU5iIiwHDBUWEwpsVSrRYxza0jFGFS//4R3xSxLneBI7/TWGkWPa9bqxREhkmvpNUEmv46Yh2vtNPcoGk5xLXUzOFRmCvZ3mw21bH4nK9kSpLehMlk6eOjBQdnOm9r6QEmsYwdMZch4lbu6SvrcEFFX1ciNmwzX6WUS5FNazCLCzWNc11I
 DdK/FbJd
 10pri7rrY1aVDPIft1RtUWBMRRk+ae6D3AyhLOrjpXE+8k2sIArlMoULnltL63W7NiiRJzeJO/qvd0VZRzuXTOT590uMuVCD1lbXb97g0ooDQVFMn3XfaqBAmowwXaUex4uiHIY3SBf4ZLHCRJzReDmtQG6C0xbu/x2iKLeJ+S/sX1G/EDXo3e2w/fgLmHWTZMINs
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
index db3337300c4c..637edec03b2d 100644
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
index 28057afaee33..0d9ae32ae29e 100644
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
@@ -1055,6 +1122,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
+ *	bit            4:	_PAGE_SWP_UFFD_WP
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
-- 
2.34.1


