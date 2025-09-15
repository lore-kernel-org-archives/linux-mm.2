Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E27DCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B9F8E0014; Mon, 15 Sep 2025 06:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF438E0015; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE78F8E0018; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 628BB8E0017
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1242211A5B4
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:33 +0000 (UTC)
X-FDA: 83891075226.19.82F4142
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf28.hostedemail.com (Postfix) with ESMTP id BAE92C0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLuuFp06WURzUBfulwpd7KS014cbAelogi3ljOJAQl8=;
	b=dYmXYuUxyySN11cVCfcbkHviBsMH1rjvxSDyI2Jah5uTMXb5EBb5DpoL6n2Pjiu/s4s+03
	SLj87UYtjScICHjyGD4WMUqrAIv8EwXIaW52jgaSDmugksUQZy9+WSK3ZJsPeZ6TgEvQQw
	mXbPYGh/UgFwkD0INYO0hw1IDrW7AF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931271; a=rsa-sha256;
	cv=none;
	b=s7+ARRfrjCWx5YM4uNVaHvV65tEecooMMFZrA0Xv9hAouorAlWcvQxNHTKk/MQ0P5ov3CH
	z/Q2bxTdbKKIwbOHWvF6U2raumWSoGEpixGne4ds6X/RYCIuloeEcsh2jqz0AOpUTKbQ2v
	JpTLo25zfMdcNjB0DlrwzW7Esy79k94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAD3lxHf5sdoHWn3Ag--.53429S4;
	Mon, 15 Sep 2025 18:13:55 +0800 (CST)
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
Subject: [PATCH V12 2/5] mm: userfaultfd: Add pgtable_supports_uffd_wp()
Date: Mon, 15 Sep 2025 18:13:40 +0800
Message-Id: <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3lxHf5sdoHWn3Ag--.53429S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1DGFWrJr1DWr15Xw15XFb_yoWxZFyUpF
	4rGw43Xw4ktF97Ga93JF48C3s8Zw4xGFyDGryF9a18A3W3t39YvFyFkF1rKr97Jr4kWry3
	tF17trZ3Cr42vF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE
	c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCF
	s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x
	0262kKe7AKxVW8ZVWrXwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7IUnaXdUUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCRAGB2jHtda7WAAAs3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAE92C0010
X-Stat-Signature: x5jb9n8eqt336p4dt6sbd9pe96r5xadq
X-Rspam-User: 
X-HE-Tag: 1757931269-184524
X-HE-Meta: U2FsdGVkX18+DrrwGniEtOg2vDeLyIqvAsgUPbmVOm5xYMCgjanLOzWyyRxTCtkT8cflTc8sYc8IVuEHcb88VxwxDXxX7ay57jAYWPAALuwwme23CA73UYY5lnTZtjtX4S2msCH/0HvCO8QB55E5B7ju5vEs5DZhAkN2TeIAv5leaBJqTzf8VJzuVMKrJI/ZgQW1195/hMwK6O1ojTvjLavOFl9uDFOFxvUZXhvp1bgPH5WYHOWhwLC26urhtzlkYVLVJICNAPCuk63hLebl6KpJZ7UeF/7viYx4T1Nr55HDk2JM+p45qo6bq7iWAhxuanZPer8T4fSqOEXkGlWuFB5y6tFyp1CkWuBZ3ysREKSv9glYWdhtRHJD/GLlZrrQ19o1VQRpBCvCOlSv21Z4I+kcZq1ESTYcMWDmduBuxGfHL3CgrPBQnwZGYc8g69OlWB+dQubKi76hSHG1GIk0NO85Av9WB/GC+E/jU0p/ZNBMl1z7GhePBhaIJsAmjn0+Lu5SCzo6mVHUumOEnWRIlUJFwKXS2s4znxVUtOIrR5cwb48sreT8tmOxNIBvNEOmurYF0q21MHrRw2rnGVqjPXqrhoaOpY7Lm+OId1KnXPxTmrNjCiNIEhooPBMExa6KPGk9qmchgzncBdU/c3lub2IBkxgvyLvwdA15qbXuIkXX+8PUDt5RAQORZQP0jYF+kl50iOkX3X1yWHvuTz5CsHLqzFu2gEOUEQtb01w/hgPiJJWZYILdZix3qu/PZX2pkNuo8RfvDf5ILlE1OWlA6QSx+zoB2xiGPDlffC+CsxGzy5wh73J5alT3EUO7LCUHzY/yVrL/OmNnga7K+ruNx9obAPUdzvAm6Sc62hxGK8Qt48Mt1+m30p4Gldo1ajFryb4BEe7q1jRf0GyfIxhiueUN1trx372OGVagQDuwM3VTsAPs+CaNnOtKu3rrAQO9EhMAp8a4xwexFfNAjHr
 zv+RFPo3
 icpC/eQCeDzWpcZvZKEA35ElbA0TR4DKJ/rbJhWigiJttrOME8CFwr9aAIH/7DhZJWbgGDVIWIqHt24+y0jXGwMj2/s/bYW1MFArOasUDEcD1HtBC3GAz9+mHGNLs3ExQkKVVaMzF4mjzczR5Koxs+DFh1EYYrxuYCztn7CtLs1wlxVlvVy3Bl/QZttQeqWfEkgblS9efJzSTwpcU07UhzeMos4AabBr5iVdMY+qCy5J5aPyofaw/sJeZs9V4jKcO/HNTUlFbCSYEVSZnq/1StDZWgPSlrtBeAYNXGyXwzhdSwmQnrqqohzh6WW7idrtPLn7T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms can customize the PTE/PMD entry uffd-wp bit making
it unavailable even if the architecture provides the resource.
This patch adds a macro API that allows architectures to define their
specific implementations to check if the uffd-wp bit is available
on which device the kernel is running.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/userfaultfd.c                   | 22 +++++++++++-----------
 include/asm-generic/pgtable_uffd.h | 17 +++++++++++++++++
 include/linux/mm_inline.h          | 10 ++++++++--
 include/linux/userfaultfd_k.h      | 27 +++++++++++++--------------
 mm/memory.c                        |  6 ++++--
 5 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c6..e41736ffa202 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1270,9 +1270,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-		goto out;
-#endif
+		if (!pgtable_supports_uffd_wp())
+			goto out;
+
 		vm_flags |= VM_UFFD_WP;
 	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
@@ -1980,14 +1980,14 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
+	if (!pgtable_supports_uffd_wp())
+		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+
+	if (!uffd_supports_wp_marker()) {
+		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
+	}
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
diff --git a/include/asm-generic/pgtable_uffd.h b/include/asm-generic/pgtable_uffd.h
index 828966d4c281..200da65262a8 100644
--- a/include/asm-generic/pgtable_uffd.h
+++ b/include/asm-generic/pgtable_uffd.h
@@ -1,6 +1,23 @@
 #ifndef _ASM_GENERIC_PGTABLE_UFFD_H
 #define _ASM_GENERIC_PGTABLE_UFFD_H
 
+/*
+ * Some platforms can customize the uffd-wp bit, making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overriding it, please make sure the
+ * CONFIG_HAVE_ARCH_USERFAULTFD_WP is part of this macro.
+ */
+#ifndef pgtable_supports_uffd_wp
+#define pgtable_supports_uffd_wp()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
+#endif
+
+static __always_inline bool uffd_supports_wp_marker(void)
+{
+	return pgtable_supports_uffd_wp() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
+}
+
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static __always_inline int pte_uffd_wp(pte_t pte)
 {
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..d6526a7f034b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -570,9 +570,15 @@ static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	bool arm_uffd_pte = false;
 
+	/*
+	 * Some platforms can customize the PTE uffd-wp bit, making it unavailable
+	 * even if the architecture allows providing the PTE resource.
+	 */
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* The current status of the pte should be "cleared" before calling */
 	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
 
@@ -601,7 +607,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
-#endif
+
 	return false;
 }
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..c19435863076 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -228,15 +228,14 @@ static inline bool vma_can_userfault(struct vm_area_struct *vma,
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then shmem & hugetlbfs are not supported but only
 	 * anonymous.
 	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
 		return false;
-#endif
 
 	/* By default, allow any of anon|shmem|hugetlb */
 	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
@@ -436,28 +435,26 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 
 static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	return is_pte_marker_entry(entry) &&
-	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
-#else
-	return false;
-#endif
+	       (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
 }
 
 static inline bool pte_marker_uffd_wp(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	swp_entry_t entry;
 
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	if (!is_swap_pte(pte))
 		return false;
 
 	entry = pte_to_swp_entry(pte);
 
 	return pte_marker_entry_uffd_wp(entry);
-#else
-	return false;
-#endif
 }
 
 /*
@@ -466,7 +463,9 @@ static inline bool pte_marker_uffd_wp(pte_t pte)
  */
 static inline bool pte_swp_uffd_wp_any(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	if (!is_swap_pte(pte))
 		return false;
 
@@ -475,7 +474,7 @@ static inline bool pte_swp_uffd_wp_any(pte_t pte)
 
 	if (pte_marker_uffd_wp(pte))
 		return true;
-#endif
+
 	return false;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..607e14177412 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1465,7 +1465,9 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
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


