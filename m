Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D2FDCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E608E0019; Tue,  9 Sep 2025 05:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B426B00B3; Tue,  9 Sep 2025 05:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3EE8E0019; Tue,  9 Sep 2025 05:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B71096B00B2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BC7414042E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:12 +0000 (UTC)
X-FDA: 83869258704.19.FA07FFB
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B924C000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnkSifx7hJeAOWVYoqeJzirQNFS0EBZQRFdV/2oNYzI=;
	b=VP+QMxXv14ibB8545oRXq3Gj7E9/QVb6+QGEkAO1RC6esjYP00FTVB26BjNT67u067GjuS
	gUJAP6nO2QRwKpcSr9HyOlQd1VAYV/bSezfgo7pK7YS1lmr3JwV3CI9j8UyO2nEpLwar7D
	EtOVoTNDBqajiSEbY4khfPopoKFvLGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411830; a=rsa-sha256;
	cv=none;
	b=hvDJRZCot3fyUYYnBkye6R1Pwzy3lmi0CEE50QHSi8fiznE6DMdTmH9bLYEFUuJCUsFqLW
	xkLlrxV9FPnuZEQ8m7wsJDvpU4hIHA2Cb1YVHQ8fQUmaikGahmMPey8kb0fgxLk9RKjiet
	pSzVTrsN2CO7viAt9R/bhuO2kL3UbYk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADHHqHO+b9oWh7qAQ--.61766S7;
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
Subject: [PATCH V10 5/5] riscv: mm: Add uffd write-protect support
Date: Tue,  9 Sep 2025 17:56:11 +0800
Message-Id: <20250909095611.803898-6-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHHqHO+b9oWh7qAQ--.61766S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4UZw1rtw17Kr1DuF4kJFb_yoWruFWfpr
	s5GayrurWDJFn2yayftr4FgrWrZw4fWa4DWr93Ca1kJFy7K3yDXr95Kry3try8XFWvv347
	WFWrKr1rCw47JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQjb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
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
	xVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j93kZUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAcAB2i-53NJfAAAs6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B924C000D
X-Stat-Signature: 46kqjswtks998a319mg65dntkew17q8g
X-Rspam-User: 
X-HE-Tag: 1757411829-846160
X-HE-Meta: U2FsdGVkX18BkyLUm+pd4eflaF533GQ13q0qvzYfaeFhRApflvq6fAQ3Hl7AshmRLw45zwPyxO/Vlui6ulODPZwpqUAVbBgTC/LS/S2Ij1whAOBy0pHCFgE9g1kaXsE9AqqEL+I/tn4gOE1TteHHh8HIZMI5GvdeE5PAOys3V4ildRNJy7DDvFRrOvyaqzhTm3ZJkTDY9hzbtm9cZa+WV/VwZQj7MNAqRzt3GuK4Tc0QsIDzcZUWSdXP92Wd70dteGIdys+RuYKXZ7XStc59DCYqjj0Q4DdUJ+wUHZw+/K1T7EvDgE4p/d/r25LE8rJOP8EcqPRWX2iOLHQF8Spfvh7JLhGQDsQVHgf6A9d0cM9epsQQ5UPz+zEDlfBNtMt36rqpNJDQHwafcRQEootwV5El+e9uQiTuGucRtzT1uWo5F2h/3tZNfctkbfHd9YjzGMhecN9mcX2Htj0LOV8ouNv3r61FqGic6vLu6h9wbb9lMGKEdOXloawrEmoEwX12uyU0VbOlYjUAT/4LMolG6rvI91Rvga7pGpBMJn1WPikjdLVcvaJKR4GASz7tPjdjHP0JNeWafhOE31mIrGXA/peXfLQMQr4QVOpzY6rH2kEMRBBvWiePFVesLx2EO707EHNbRhfmCE7kntIR+85pHaocUbaOy6MtLU8rszxYFI+LfsXZWIw0LR5vXHBo/uHX3JfxVrzv205yEvK73Ugo7xghTb1T8UA2Zgdno3kpD7U1fC/YCpDgLMAFFb4E23ue8KMa19YZRys19F6/vFY5y4UfMh+FuDLUOXFutAJy8NqmBhjQD3MXgmQtfcoz5DVow8CJGZSPi+9dRUGTt0BZNn9ieg7rMcPSfgT5p9SFNoaxkGYrG8CYvnuOzopG31RvnbG3S5W/JSAG6ooR8hihC6e+PYnEPErptcvXTiihYQK7Ijehb9iBfIkHyDDOxodPlBHxGOONjwcmpKoxQE2
 s5KL2icR
 9Qm1+M6VURrV6+mtFqHcSD3lztJ/POpiM4jfTwuyrEbkQ39RJW5J4BJRcaOit/Xn4bTzYbd3na7KDvx3+iLrt1+iAfDpw3XHbZ1LIff298MXVpOA+oxPNwqrcRMHhX+AQ83BS0gqKOEwKWpkIcVPdibQjCI4kbxa0kIUuCobtjeWziYVW67OQkhQZ+cdbk9jX91aE
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


