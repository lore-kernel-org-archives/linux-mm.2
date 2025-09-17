Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6D8CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D28E8E000B; Tue, 16 Sep 2025 23:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BAE8E0001; Tue, 16 Sep 2025 23:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6866B8E000B; Tue, 16 Sep 2025 23:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD858E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:37:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1436E119C53
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:41 +0000 (UTC)
X-FDA: 83897332722.01.5B68E37
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7100A1C0008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A96dRcfq7nhdZSNcgaUp9pLGPcMfRIrLE7s9HLWFxyk=;
	b=Pp8venTYp5XDy891HDh88T3gDOUV3dT1vlPTVZ3P8SB4Y01cMFmrkccrk4r+8nSTvg4ack
	wbM6hvjfdYCnr4iGN82Pg4M47MaTd7oJ0paLyVuCzv1vcjzslc5BDUg+PFzDOyTbXddsB1
	kbJ5Wsk2rl8/7UfSd/twP2UVl2LNAyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080259; a=rsa-sha256;
	cv=none;
	b=ET89XGpxi1KOAb3WVVSEL5JO/Zd/aMhSZSYyZzupMv/YIyZmDmSXLiKB89oD2U9WIogEDV
	VnZ68XfGuH80IxwLCXYHP5nEGYnRlhze7vh01aDg72tk3wghUOLgnjFhnjVi/8YspXngBY
	pZh7w1bauvjbMrbACl9ubml0YglKvAE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S4;
	Wed, 17 Sep 2025 11:37:24 +0800 (CST)
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
Subject: [PATCH V13 2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
Date: Wed, 17 Sep 2025 11:36:59 +0800
Message-Id: <20250917033703.1695933-3-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1DGFWDXr1kZF4UCr1rZwb_yoWfKryxpF
	4rGw4UXw4ktFy8Ja97AF48A3s5Zw4SgryDGryF93WkAa13t390vryFkF4rKr93Jr48Wry7
	tF4UtrZ5ur42yFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
	YxBIdaVFxhVjvjDU0xZFpf9x07bVkuxUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCQ8IB2jJ8TDyAgAAsZ
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7100A1C0008
X-Stat-Signature: w6z56ptoewh4okpcy4h8qg9uea41sffn
X-Rspam-User: 
X-HE-Tag: 1758080258-229897
X-HE-Meta: U2FsdGVkX1+qhPC5RxhcKH8LByMWHu3HRRsAGNnQmh8Hs3F6oQhjWoe2oXWf/BySudv3tsHTub1TvvuJv90Y6DFSYiemfAislSqeNvfSbhTetifMFAr2s6su5OmX83U8yu72gPLiCmyTXx+uVvOxu4p026eTD4Mpxlg6LcJPOd9O+p9AxDoO7cJ29sBFPqRbR5VJ5P+PaKz36/BNdSGQXzbHp6InEf+cRmPHTa/BA21VWWWKBeIpUK08TypCP/hNIslHkQZfby8IAhDk8b88i1O/yGytGv0hJ+TlP0rqmf5Ny/irVNrH87KP/JQOQlMicVZYKfs5rGmuEeB9EsCQaD5oUyQtBmysxwJznLrQgTC88tNKLQ5toYz16MnWwyroZOEn7rgEfUZt56IyKyC7cgscOZ49qMCqy71K0CceTZGcnPvbpsx5DtCd6mr5APdXufYfBpeDtJcCmkgcy5N9+LbmNuYLLu2rfUIg8EWMDYgvUWNxfzyABAm5ahop9cpbMkVoNt5sclzSnZO9Jz74F+0gUVRhNf9BSsHtrCioQrKkEx4NMW9CuOmWshcWNiBWx6C7hPtt08r4M0CllWjQVj1HzukYFH1ouGLVGWYyHVIewp5N+Rqsx+3gz3lnbvpLY3PQIQRSxaoLGkeLvWvD8HZUVxz4vwX3WPntzDOzImJOFuv5WcKy8gVpGzW94a/bjCPXX8IkxsR++maFN5XrS68S43G3/NXafwiEpo8TRaItr+kiQF46tDGPNLOY6qmhJzYJKa5JcDiAnO8pkMgVipPfEbZmGAoybIzqbC+I8k05DF8MRI1gJzGhTEwznKdKxRCqwoUaBzHscFEW58ChidwnxcWbpyfMNgRlh+H2bBNCcYmLJ0w79VqXdF/MGaVgi73FuieecqKAG/xnXVQ+KQLtz5zWwPjaSA92Fl254ujN2dsGs7KS9SoOD5P7hGJVlDrdva2PdH+TeAwU9mt
 HSL41MwJ
 u2Jg+87i5STQnH8We6XFoWhefEDSS5mhzxbt2yn0XlE5J7XaVf6fSbrF/zYN3rhWKDqZ2WD+HNISVbjBIv6KR7O0qwUKuTHE48QpFFINHGV5f/E9EApbxbnvigy282BgK49VCtAyHGEToC4B98m2hN8ID3NWbi+oafSQCwnZsl8RAQVM9UO3WRuifFMYhTCdKYKDYdSwfKgo4rrU87Z1gyz49gJj8IstTRU6yPu3GjmYNtyNXcfkrN4iY4CiOjjyJGeFtXRbjVHvXdbrRbmWpeBG5SY1Ax6zhcP+DZSXyXBzRiOLndIkAjPz/4YoLDOk8qRCZBXpXXbY5IJPb2enWrGKO2w==
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

Also this patch is removing "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
"ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of pgtable_supports_uffd_wp()
and uffd_supports_wp_marker() checks respectively that default to
IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) and
"IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP)"
if not overridden by the architecture, no change in behavior is expected.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/userfaultfd.c                   |  22 +++---
 include/asm-generic/pgtable_uffd.h |  17 +++++
 include/linux/mm_inline.h          |  12 ++-
 include/linux/userfaultfd_k.h      | 114 ++++++++++++++++-------------
 mm/memory.c                        |   6 +-
 5 files changed, 106 insertions(+), 65 deletions(-)

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
index 828966d4c281..0d85791efdf7 100644
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
+static inline bool uffd_supports_wp_marker(void)
+{
+	return pgtable_supports_uffd_wp() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
+}
+
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static __always_inline int pte_uffd_wp(pte_t pte)
 {
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index d6c1011b38f2..c69162812ba6 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -553,7 +553,6 @@ static inline pte_marker copy_pte_marker(
 
 	return dstm;
 }
-#endif
 
 /*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
@@ -571,9 +570,15 @@ static inline bool
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
 
@@ -602,7 +607,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
-#endif
+
 	return false;
 }
 
@@ -616,5 +621,6 @@ static inline bool vma_has_recency(const struct vm_area_struct *vma)
 
 	return true;
 }
+#endif
 
 #endif
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..4ccc79b5731e 100644
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
@@ -291,6 +290,67 @@ void userfaultfd_release_new(struct userfaultfd_ctx *ctx);
 void userfaultfd_release_all(struct mm_struct *mm,
 			     struct userfaultfd_ctx *ctx);
 
+static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
+{
+	/* Only wr-protect mode uses pte markers */
+	if (!userfaultfd_wp(vma))
+		return false;
+
+	/* File-based uffd-wp always need markers */
+	if (!vma_is_anonymous(vma))
+		return true;
+
+	/*
+	 * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
+	 * enabled (to apply markers on zero pages).
+	 */
+	return userfaultfd_wp_unpopulated(vma);
+}
+
+static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
+{
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	return is_pte_marker_entry(entry) &&
+	       (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
+}
+
+static inline bool pte_marker_uffd_wp(pte_t pte)
+{
+	swp_entry_t entry;
+
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	if (!is_swap_pte(pte))
+		return false;
+
+	entry = pte_to_swp_entry(pte);
+
+	return pte_marker_entry_uffd_wp(entry);
+}
+
+/*
+ * Returns true if this is a swap pte and was uffd-wp wr-protected in either
+ * forms (pte marker or a normal swap pte), false otherwise.
+ */
+static inline bool pte_swp_uffd_wp_any(pte_t pte)
+{
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	if (!is_swap_pte(pte))
+		return false;
+
+	if (pte_swp_uffd_wp(pte))
+		return true;
+
+	if (pte_marker_uffd_wp(pte))
+		return true;
+
+	return false;
+}
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -415,68 +475,24 @@ static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 	return false;
 }
 
-#endif /* CONFIG_USERFAULTFD */
-
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
-	/* Only wr-protect mode uses pte markers */
-	if (!userfaultfd_wp(vma))
 		return false;
-
-	/* File-based uffd-wp always need markers */
-	if (!vma_is_anonymous(vma))
-		return true;
-
-	/*
-	 * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
-	 * enabled (to apply markers on zero pages).
-	 */
-	return userfaultfd_wp_unpopulated(vma);
 }
 
 static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
-	return is_pte_marker_entry(entry) &&
-	    (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
-#else
-	return false;
-#endif
+		return false;
 }
 
 static inline bool pte_marker_uffd_wp(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
-	swp_entry_t entry;
-
-	if (!is_swap_pte(pte))
 		return false;
-
-	entry = pte_to_swp_entry(pte);
-
-	return pte_marker_entry_uffd_wp(entry);
-#else
-	return false;
-#endif
 }
 
-/*
- * Returns true if this is a swap pte and was uffd-wp wr-protected in either
- * forms (pte marker or a normal swap pte), false otherwise.
- */
 static inline bool pte_swp_uffd_wp_any(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
-	if (!is_swap_pte(pte))
 		return false;
-
-	if (pte_swp_uffd_wp(pte))
-		return true;
-
-	if (pte_marker_uffd_wp(pte))
-		return true;
-#endif
-	return false;
 }
-
+#endif /* CONFIG_USERFAULTFD */
 #endif /* _LINUX_USERFAULTFD_K_H */
diff --git a/mm/memory.c b/mm/memory.c
index 39ed698dfc37..a47621b35194 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1593,7 +1593,9 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* Zap on anonymous always means dropping everything */
 	if (vma_is_anonymous(vma))
 		return false;
@@ -1610,7 +1612,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 		pte++;
 		addr += PAGE_SIZE;
 	}
-#endif
+
 	return was_installed;
 }
 
-- 
2.34.1


