Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3A3CAC596
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B776900003; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A74F940009; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E01900003; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1768E0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:56:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39DA4118E66
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:50 +0000 (UTC)
X-FDA: 83876515380.16.4449F7E
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf20.hostedemail.com (Postfix) with ESMTP id E21E31C000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757584608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xv2c4R+QZismnxUgCZWlzQXiZaxNcj/FRPLDAGConSA=;
	b=5oup8vLa+NSPBk7j4WsG3YtttPremq4auZvotRWtxuITaN9T/jXbHhvYTFR0WV+wtZASix
	ezCN0KDkdZL+davI1tbCR5UH7wdQA+RFV28VTWFHb5ePcNw1r1zM29B2nuTez4lE1tMdpx
	1YhtS+R7UOTcn2A8EV1to0sO9wnkD1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757584608; a=rsa-sha256;
	cv=none;
	b=16e7xPFreldiemIhDOQs0qFBUQhoUT7NbPW7CEHIh3jxqhYjZl26jqQDuAXUOfHbQIou0D
	l4pqLEStsLOl6WauzBo5tY3J4ulELLzNrY6vPsfdEO+r/n4FjboI8fInDkm/luiqpkOy8t
	a03iM3g4KlfT8+HB2//jEWme4ZGO/Sk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACH2IK5nMJoo6pCAg--.44660S4;
	Thu, 11 Sep 2025 17:56:12 +0800 (CST)
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
Subject: [PATCH v11 2/5] mm: userfaultfd: Add pgtable_uffd_wp_supported()
Date: Thu, 11 Sep 2025 17:55:59 +0800
Message-Id: <20250911095602.1130290-3-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
References: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACH2IK5nMJoo6pCAg--.44660S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1DGFWrJry3KryfWF17ZFb_yoWxuFyfpF
	47Gw45Xrs7JF97Ga93Aa10k3s8Zw4fKrykWryF93W8A3W3t390vryFkFWFyF93Jr4kWryx
	tF17trWkur42vwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
	YxBIdaVFxhVjvjDU0xZFpf9x07jPID7UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgCB2jCjVc9QgAAsO
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E21E31C000D
X-Stat-Signature: e3adh48crmbcxxuf7mb9jhdi5s119na4
X-Rspam-User: 
X-HE-Tag: 1757584606-700378
X-HE-Meta: U2FsdGVkX1/w4NKQsUE31G6mihftb6RIt6F/znYWIwgjRnJ4eqw86e23vo9eQf5eMtsiV+5uI25YpKiX6ovqcIFlkCNCm+tFPrYj3i9v1G3OR1Wwfl9aMGos57/uQWyBGdQSVmeHt9B3Xe6uAOKjkdnpmha9uaQOEF0ccpE+fAILHUZF5GDt0EwAuyXq7fPSTJTHt0Ko0dToOwzLRgwv0GP26gxXUojkjdMpKCrxqRz942ddL9FVqp5kUFqD+BZsV8xj5sZCR9nSg8+B0VmLSK8V/sCCy3tb0+vUjL1/1IPWsfj9xbi31/wUqHo27StnlrsDZNf+1OAPhUtErG8ybYTV7uitmOjuMXVQXxAeuBk7pc0UYUTaLvOE+fDyFyZLZ8S6qI03jizvTbyTmAvzWncfsQfSjovqLpk0gel0V1VNg8KSueENw087qwilhO/kBwye3biGOvn6DRpsU2GfdjUouL2HgLLIC6a8v7X03FKh/VXihtJt28pI49C6mfrSS69bmVri3LSO2cIFx1vkT0Ja5I4SysNdZLNAIzKRkbaWyYI739dUdFtgffShU+/GI/bAC8kWieKHksMrVTwQLD6mpdRjhFgmv/mq0Hg51F1nLqh9YiGgDbZZRSjYTFzKEUvXm5YDKWjPbBXMtzpEY25Jq1z5EoWA4LnQCGhdVKvhShkmtPcbn8DxvQ1cuL6JCUj7X9uOYVmqLhRAZPW37UVN0DXOMhe2AwkrWOGQll+Dt5OFUgRxG8tfhGANhfZS5JwV/xZPLj1FZD5qW802m5R0vkcoEAgqEvoTKis185/G53N32RXmEX3MPDB9S0lKMLZSp8iv2/7fd7zjVXTX9sVm6vLWdac0tYRBdCb2ORV6D9P8ZXtfjHHEV7p08Yfjh8r1Mgo+HS+01LMmgxB6XA2Xm8/9T4LXP+xd0fP3MrkkCXZRnE8Kn8ioU8F4y29vXGXVh7JghUIXljRPtnn
 og0lQ4QX
 lgPq+UfMAB6vtfVFJCcXHhxzwU+wuNafZcWpZ1p/7aoEyobD+mWLEUKGYppx56uvdpXmoeS5PTitv+AG6eHqRSSd/jfA6kdeeFHsHz0U63qLFTL1Cb46FMXCOPArdRHND1HDi6qUnXzgFmp/zj8vgDr85PSR1c1UHz1DVa4n9sQpFxOEty7wEp0vKhwHw0a2NKbJCThFcu+bkW3MZwiW625QK21nuw9QJyYp6P1g8YdOU/BpR6FPeq3X+pgEUAc8fC7mR6W1iJYJ6Tz9O6mixAeuvbjfsgIy/ky8cAWVeY9vae3BgcTcJh7KfhRLDWzcS099M
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
 fs/userfaultfd.c                   | 23 ++++++++--------
 include/asm-generic/pgtable_uffd.h | 11 ++++++++
 include/linux/mm_inline.h          |  7 +++++
 include/linux/userfaultfd_k.h      | 44 +++++++++++++++++++-----------
 mm/memory.c                        |  6 ++--
 5 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c6..b549c327d7ad 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1270,9 +1270,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-		goto out;
-#endif
+		if (!pgtable_uffd_wp_supported())
+			goto out;
+
 		vm_flags |= VM_UFFD_WP;
 	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
@@ -1980,14 +1980,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
+	if (!pgtable_uffd_wp_supported())
+		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) ||
+	    !pgtable_uffd_wp_supported()) {
+		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
+		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
+	}
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
diff --git a/include/asm-generic/pgtable_uffd.h b/include/asm-generic/pgtable_uffd.h
index 828966d4c281..895d68ece0e7 100644
--- a/include/asm-generic/pgtable_uffd.h
+++ b/include/asm-generic/pgtable_uffd.h
@@ -1,6 +1,17 @@
 #ifndef _ASM_GENERIC_PGTABLE_UFFD_H
 #define _ASM_GENERIC_PGTABLE_UFFD_H
 
+/*
+ * Some platforms can customize the uffd-wp bit, making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overiding it, please make sure the
+ * CONFIG_HAVE_ARCH_USERFAULTFD_WP is part of this macro.
+ */
+#ifndef pgtable_uffd_wp_supported
+#define pgtable_uffd_wp_supported()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
+#endif
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static __always_inline int pte_uffd_wp(pte_t pte)
 {
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..38845b8b79ff 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -571,6 +571,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
 #ifdef CONFIG_PTE_MARKER_UFFD_WP
+	/*
+	 * Some platforms can customize the PTE uffd-wp bit, making it unavailable
+	 * even if the architecture allows providing the PTE resource.
+	 */
+	if (!pgtable_uffd_wp_supported())
+		return false;
+
 	bool arm_uffd_pte = false;
 
 	/* The current status of the pte should be "cleared" before calling */
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..6264b56ae961 100644
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
+	     !pgtable_uffd_wp_supported()) &&
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
+	if (pgtable_uffd_wp_supported())
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
+	if (pgtable_uffd_wp_supported()) {
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
+	if (pgtable_uffd_wp_supported()) {
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
index 0ba4f6b71847..4eb05c5f487b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1465,7 +1465,9 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pgtable_uffd_wp_supported())
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


