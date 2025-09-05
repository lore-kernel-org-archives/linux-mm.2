Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F433CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3C08E0019; Fri,  5 Sep 2025 06:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684038E0016; Fri,  5 Sep 2025 06:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525668E0019; Fri,  5 Sep 2025 06:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 344758E0016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:37:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D62C5140697
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:40 +0000 (UTC)
X-FDA: 83854845480.19.5F8B4C3
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C99B40018
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+xu8g7dfTdUHxUuH99GDzQUwiorvhew40N8gk5Sw1As=;
	b=QXb6DX5ntiTjHzkYbmlOUqRyyKRJkpWLHUqekfV42v566bwOHP5tEXI3gCe2QQnKEkSMkR
	lbPpvYE1UoHapk/MFkZWgMiU6q6EDRTmkiBMNjHjcgPE05TUyYeK5Q/7dCyfXEgwk0Y6+K
	nl0PYQPtSF8sm7nexGPtNo8rr8JOY04=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068659; a=rsa-sha256;
	cv=none;
	b=CrG/2bVNvrUIK8rQqltswb+9l9vdEtl8PYGB0Wxf5LlVJAqF9jg1hIuIl0/ZAWqPw3f2Pr
	6k+kdEWW+Xc5uFZzqGl81ZJVuUPNs1GyGGUt8bKVfWPioRQgiiwXWdk7p3Ff0DY1lGn7Jy
	kx5qy+q+c9HSQaMJovdKMlrzf+5Qn04=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowABnwaNMvbpoocLNAA--.50311S4;
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
Subject: [PATCH v9 2/5] mm: uffd_wp: Add pte_uffd_wp_available()
Date: Fri,  5 Sep 2025 18:36:48 +0800
Message-Id: <20250905103651.489197-3-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
References: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABnwaNMvbpoocLNAA--.50311S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtF1kWrWUtry5KFyrCFy3Jwb_yoW3GFW3pF
	47Gw4Yqw1vvFykJa93JF4rA3s5Zw4xWFykWryF93W8Aa13t390vryFkr1FyF97Jr4kWa4a
	vF12qrZ5ur42vwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPGb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE
	c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCF
	s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x
	0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC2
	0s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI
	0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv2
	0xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
	Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
	yTuYvjxUaf-BDUUUU
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgQB2i6oeFs+gAAsX
X-Rspamd-Queue-Id: 3C99B40018
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f66ej4zfnpfgqse6mxjon75yq5fosc1p
X-HE-Tag: 1757068657-293878
X-HE-Meta: U2FsdGVkX18b2zwZHV/DKYUa4nooSywa4HW26She7Dcd0H/O4ABrJ7UNuKMDDQ2A7yowX+DCwm/IG46iXaq2apWjA4ZNw7UmKl6rAoCNuXmq4LgAFxmK6jXdmPEnsxa8oqmtvAkjYj+wdw+WAMdGU0ZpWEjTGNFFNxSy2RVHTDHMey3Rdqa9xIYlpI0Z+jbJzmte//yxc2laIuumxVgSX9O+9QgIimdavt9/P6KC0V0wVlzLywcR0d9jV7bMI2UplxbzvFbdr9LN1ozBo6hk6FnC9Ss4yjBagLAfP5dzreaYHr1BE9DASvPHI1qpaMKmmq4N28t7lZU+X1xyJ2lCNYtzcvJaBEmo2pPJm6bSaWmXUrKL1NUK38iLkKzZNhn9GVors7JKSB8B6jZuhCu4QSFHc7xLe+ZoqZMBXfZVdex8B+bKc2Z7w3Ae8azDoELB0EiOBI995YHRjJZe8FEf+oN9Fg8Ks/peB8Ph3UnFYRIiau0fm3wAtapfT6d163bOe5p14tDysCUZaBL1Nhk2kbYR6By9OhE+7ZMFC1JyYG/gCfCaNO774yra6jlI+H1TCftINuoBT7le3ON5dlVGzv6b/GxmtcjZ2Jn7a+B2ejUvo1FEiuUewMwvmhC5CciK5WSatQd5crifH0/1lMA7d4Vv383IGaCmGH9eoixAiZtS714k0tZOCQHBmunqu3sRzTuYXY7JVw7znpq6aOzkC2evMoXV4Yn0U0G2kb/TTMCCAuf76FVGOnE9WWWvqgBp3O3+/qzjutXebIc/ClxvunT8dsNJbsDx/r1PQOO4RgyDdIo3DvRu+CILCglrKFNCLmtieWnes/STLDFXC3DmLdaYWLGxyYaE4Dg1dHBMjFX/2u2VQzEsG5hJp02oEbEYupM4K9RNTVQCpFVl8bhyUGGMNnfeI/N3zP0Dh9vnh1ImiB512PbwZHUOKARnrNWOyX8QSkvqxG6jtZ1Y8vo
 9Tv5+bjT
 yQav4fGubbU6l8rWNyrJRqYXh/5ECp3Nf0s8KVXsUDW8FC1od+nK4zIQFq9LDP2HpMst5zulCasP7qcUJGiucNyL/CR8u3PeNA8Aewpqje0/EJe6aTRUgNOprVdfVN+t/t4/p02SpfkXNt0X0qcSgrHzHH798s76Gbqyi90z2M2n20Im0lI8Uj5ttilT1W3ijcGa9LTmAzzZUfnYeNyAoZa/WaQmVQG7JZUJD2BFA2Ql/EyxcLZroNJzZJrqx2U0bCm3QH20juoaMUwe+eKuacy09dTdWaWDjl3kAv6k4TjMrP4O98pvr3ymLvn0axP7ncMAR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms can customize the PTE uffd_wp bit and make it unavailable
even if the architecture allows providing the PTE resource.
This patch adds a macro API which allows architectures to define
their specific one for checking if the PTE uffd_wp bit is available.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/userfaultfd.c                   | 25 +++++++++--------
 include/asm-generic/pgtable_uffd.h | 12 ++++++++
 include/linux/mm_inline.h          |  6 ++--
 include/linux/pgtable.h            |  1 +
 include/linux/userfaultfd_k.h      | 44 +++++++++++++++++++-----------
 mm/memory.c                        |  6 ++--
 6 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c6..68e5006e5158 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1270,9 +1270,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-		goto out;
-#endif
+		if (!IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) ||
+		    !pte_uffd_wp_available())
+			goto out;
+
 		vm_flags |= VM_UFFD_WP;
 	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
@@ -1980,14 +1981,16 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	uffdio_api.features &=
 		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
 #endif
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
-#endif
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
-	uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
-	uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
-#endif
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) ||
+	    !pte_uffd_wp_available())
+		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) ||
+	    !pte_uffd_wp_available()) {
+		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
+	}
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
diff --git a/include/asm-generic/pgtable_uffd.h b/include/asm-generic/pgtable_uffd.h
index 828966d4c281..b86a5ff447da 100644
--- a/include/asm-generic/pgtable_uffd.h
+++ b/include/asm-generic/pgtable_uffd.h
@@ -61,6 +61,18 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 {
 	return pmd;
 }
+#define pte_uffd_wp_available()	(false)
+#else
+/*
+ * Some platforms can customize the PTE uffd_wp bit and make it unavailable
+ * even if the architecture allows providing the PTE resource.
+ * This allows architectures to define their own API for checking if
+ * the PTE uffd_wp bit is available.
+ */
+#ifndef pte_uffd_wp_available
+#define pte_uffd_wp_available()	(true)
+#endif
+
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #endif /* _ASM_GENERIC_PGTABLE_UFFD_H */
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..a81055bb3f87 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -570,7 +570,9 @@ static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pte_uffd_wp_available())
+		return false;
+
 	bool arm_uffd_pte = false;
 
 	/* The current status of the pte should be "cleared" before calling */
@@ -601,7 +603,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
-#endif
+
 	return false;
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2a489647ac96..51f5b610c5ec 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1564,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
+#define	pte_soft_dirty_available()	(false)
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return 0;
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..ec4a815286c8 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -228,15 +228,15 @@ static inline bool vma_can_userfault(struct vm_area_struct *vma,
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then shmem & hugetlbfs are not supported but only
 	 * anonymous.
 	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+	if ((!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) ||
+	     !pte_uffd_wp_available()) &&
+	    (vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
 		return false;
-#endif
 
 	/* By default, allow any of anon|shmem|hugetlb */
 	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
@@ -437,8 +437,11 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
 {
 #ifdef CONFIG_PTE_MARKER_UFFD_WP
-	return is_pte_marker_entry(entry) &&
-	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+	if (pte_uffd_wp_available())
+		return is_pte_marker_entry(entry) &&
+			(pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+	else
+		return false;
 #else
 	return false;
 #endif
@@ -447,14 +450,19 @@ static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
 static inline bool pte_marker_uffd_wp(pte_t pte)
 {
 #ifdef CONFIG_PTE_MARKER_UFFD_WP
-	swp_entry_t entry;
+	if (pte_uffd_wp_available()) {
+		swp_entry_t entry;
 
-	if (!is_swap_pte(pte))
-		return false;
+		if (!is_swap_pte(pte))
+			return false;
 
-	entry = pte_to_swp_entry(pte);
+		entry = pte_to_swp_entry(pte);
+
+		return pte_marker_entry_uffd_wp(entry);
+	} else {
+		return false;
+	}
 
-	return pte_marker_entry_uffd_wp(entry);
 #else
 	return false;
 #endif
@@ -467,14 +475,18 @@ static inline bool pte_marker_uffd_wp(pte_t pte)
 static inline bool pte_swp_uffd_wp_any(pte_t pte)
 {
 #ifdef CONFIG_PTE_MARKER_UFFD_WP
-	if (!is_swap_pte(pte))
-		return false;
+	if (pte_uffd_wp_available()) {
+		if (!is_swap_pte(pte))
+			return false;
 
-	if (pte_swp_uffd_wp(pte))
-		return true;
+		if (pte_swp_uffd_wp(pte))
+			return true;
 
-	if (pte_marker_uffd_wp(pte))
-		return true;
+		if (pte_marker_uffd_wp(pte))
+			return true;
+	} else {
+		return false;
+	}
 #endif
 	return false;
 }
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..1c61b2d7bd4d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1465,7 +1465,9 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pte_uffd_wp_available())
+		return was_installed;
+
 	/* Zap on anonymous always means dropping everything */
 	if (vma_is_anonymous(vma))
 		return false;
@@ -1482,7 +1484,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 		pte++;
 		addr += PAGE_SIZE;
 	}
-#endif
+
 	return was_installed;
 }
 
-- 
2.34.1


