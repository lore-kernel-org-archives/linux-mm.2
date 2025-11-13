Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613CECD4F34
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEAD8E0003; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163BC8E0011; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82908E0003; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBB008E0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C79F1A0857
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:36 +0000 (UTC)
X-FDA: 84104756232.28.15E3DD9
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf27.hostedemail.com (Postfix) with ESMTP id E188F40009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018914; a=rsa-sha256;
	cv=none;
	b=ETfOEUvT0YU46TFZMMjZjsdIdsP8RTVVspTclLoUPQrR7U6tUDMl52So5EHD0WnsHj3kUZ
	7SAfFcRrHwZvGzgVrO5ngm3r3lr0oZ2FO42yIGHCRl3kVH88d031nleSrRLXrxYeBQusfv
	NjnzzSnwAjkq/cUZLscgLRWcJJD0U6I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n+ecqTJpJ7219ujfth+L4voUK/J/g1HiZY1obEIy35E=;
	b=s9oZRovQg4AOsRiqNY6eWc1qXWNwtsOhM37cw8rWT/KGbDamFxc2f0o6Sw2QllEv2t68Xi
	HM8dvNXwdPbveuIdg4e+JoTtHW/TJLwtWMWqjYIXGowibcygWLHazfti8XpHbkbtzfFweq
	MsaUf+8PTR6nR4XGp8F3kIKJg/TFh+k=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowABnbG2RiBVpVTOWAA--.33691S4;
	Thu, 13 Nov 2025 15:28:23 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org,
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
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V15 2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
Date: Thu, 13 Nov 2025 15:28:02 +0800
Message-Id: <20251113072806.795029-3-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnbG2RiBVpVTOWAA--.33691S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1DGFWDXr1kZF4UZw1UWrg_yoWfJrWxpF
	W8Gw45Xw4ktFy8Ga93JF48C3s5Xw4fKFyDGryF93WkAa13t390vFyFkF1Fkr93Jr48Wry7
	tF4UtrZ3ur42vFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjxU93EfDUUUU
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAUFB2kVaThz2QAAsM
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E188F40009
X-Stat-Signature: uhqu14noy7bxjpkouunku9m8i91off44
X-HE-Tag: 1763018913-575802
X-HE-Meta: U2FsdGVkX1+dKFbObBkIte6akgM7+R4/yjPQBn3Rz50tXv5O9mZZ+zbicnb1G5kEABYI3VknmUcUJTv2wvAHIIrY2AMZTFzxCGGBKeJVaPLCz3GAoITOjkN2NM2v/9uRxmTNVQNY20/5FC7zC4SjIMJgudMXCx63/3WhEYE+487mW+8tU5mfYgh25qrumMtWM1wVuGm7Po5ji5eQ0vmHHr2ugxO2Cs5xuppW18otsmcj9tpnAynJ6tdMFWV8hCLEnK59x+82QNtHfQPiAAMYY4CFMcBDxDXTxldpLcHrBRu4wiYl1hpeO7cxl5yYxtkIOb2WgDUDLVqNciLdDPOmzuEaYZKWNp5fDkua2GVKAwmfpQJVhf1wPbdVjMgJMnVa1vWlb9V91ToAhoCeThlDt84X5waef7L1Qqw1dg8UJvnWDlLcYyc7AgnvAQ429R0yV95FuK4H8LmUIqfg6n6w0mZ48MO9RQoP4DLSDrV7ri3HgbhMam+/IImTA/Q/YlE529SohgqlS6w1qt7z2yglhdqx86atQKsPJDv13gokv9JSaFNXJnEVSsQx0hYw1/WbXGIS0e9VQ/jpVPuFn1G8zT22HuXlRQH5feh2RHSiok46bbONBW8bv7Ibzj+I5ASu/Q1g5+xMj2hWXxbMWeMN3CIfvCHf6JbUFg2kcwCx2kJkT5gfjxS+e7Mi2W5yedraDvNqzKfNnw82jQUVkwHPYuAW8Rp7bng5jlS9gWke1uwkV1r8YbhUI5t1J+CAVsArWPlMRCEYvp9T8zmCI2hm3EGysNYEz5W70rVqzgfAw49H/e+hHCHP9ujFbigW+OCkP6eExYe0Ug9OqWTAuHNd6zD9GZfELGWqpq6SbO7IZuZrwzFKDFtwJSscw+9BaayLSC/TKhvkQwqBoTU3yrn2aco2FzWfgUXc3oBnvhzrUjVQyCpxwfz5oblwsVYPwTnCpxcGT/DC20lTlimxWhi
 ZZyvkI5c
 fL/SBj20d92IYnEPTC47aAL5PqWnCG2cXraSaTYklei0BBzNUZOTQIR9ZXJaLx/C7gQ2OkUxxfgKbWKqZUg3ALrkgcIQLYJe1k4xpnAuzKtP3d4VEwMbNmLRdfQcXU+UobtLS5qDMT6SCHjSe4HmMPZ1mew1qPiz2oe03UT6BMWw4g3dAQfUlW6IGmh5dyJ/ytt2BZC9bVCN3b9S3miH+vMp9he5u/Bz50af9E1vWLktj0WiZwABEkq9/eheiFL78C5vbaZeFa0aMxZqZGplcrO3offjGpAOFFK4my9gEGJBtgkDsGZXFuSNcj32lytlC9UKmT5cNUXCJ7V3tZ8dHlXr6Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms can customize the PTE/PMD entry uffd-wp bit making
it unavailable even if the architecture provides the resource.
This patch adds a macro API pgtable_supports_uffd_wp() that allows
architectures to define their specific implementations to check if
the uffd-wp bit is available on which device the kernel is running.

Also this patch is removing "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
"ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of pgtable_supports_uffd_wp()
and uffd_supports_wp_marker() checks respectively that default to
IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) and
"IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP)"
if not overridden by the architecture, no change in behavior is expected.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/userfaultfd.c                   | 22 +++++-----
 include/asm-generic/pgtable_uffd.h | 17 ++++++++
 include/linux/mm_inline.h          |  8 ++--
 include/linux/userfaultfd_k.h      | 69 ++++++++++++++++++------------
 mm/memory.c                        |  6 ++-
 5 files changed, 78 insertions(+), 44 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4e900091849b..1590de993e55 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1289,9 +1289,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -1999,14 +1999,14 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
index ca7a18351797..2ced24fc3beb 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -553,7 +553,6 @@ static inline pte_marker copy_pte_marker(
 
 	return dstm;
 }
-#endif
 
 /*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
@@ -571,9 +570,11 @@ static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			      pte_t *pte, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	bool arm_uffd_pte = false;
 
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* The current status of the pte should be "cleared" before calling */
 	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
 
@@ -602,7 +603,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
-#endif
+
 	return false;
 }
 
@@ -616,6 +617,7 @@ static inline bool vma_has_recency(const struct vm_area_struct *vma)
 
 	return true;
 }
+#endif
 
 /**
  * num_pages_contiguous() - determine the number of contiguous pages
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 96b089dff4ef..fd5f42765497 100644
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
@@ -291,6 +290,43 @@ void userfaultfd_release_new(struct userfaultfd_ctx *ctx);
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
+/*
+ * Returns true if this is a swap pte and was uffd-wp wr-protected in either
+ * forms (pte marker or a normal swap pte), false otherwise.
+ */
+static inline bool pte_swp_uffd_wp_any(pte_t pte)
+{
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	if (pte_present(pte))
+		return false;
+
+	if (pte_swp_uffd_wp(pte))
+		return true;
+
+	if (pte_is_uffd_wp_marker(pte))
+		return true;
+
+	return false;
+}
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -415,23 +451,9 @@ static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 	return false;
 }
 
-#endif /* CONFIG_USERFAULTFD */
-
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
-	/* Only wr-protect mode uses pte markers */
-	if (!userfaultfd_wp(vma))
-		return false;
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
+	return false;
 }
 
 /*
@@ -440,16 +462,7 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
  */
 static inline bool pte_swp_uffd_wp_any(pte_t pte)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
-	if (pte_present(pte))
-		return false;
-	if (pte_swp_uffd_wp(pte))
-		return true;
-
-	if (pte_is_uffd_wp_marker(pte))
-		return true;
-#endif
 	return false;
 }
-
+#endif /* CONFIG_USERFAULTFD */
 #endif /* _LINUX_USERFAULTFD_K_H */
diff --git a/mm/memory.c b/mm/memory.c
index 50b93b45b174..6675e87eb7dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1590,7 +1590,9 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 {
 	bool was_installed = false;
 
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	if (!uffd_supports_wp_marker())
+		return false;
+
 	/* Zap on anonymous always means dropping everything */
 	if (vma_is_anonymous(vma))
 		return false;
@@ -1607,7 +1609,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 		pte++;
 		addr += PAGE_SIZE;
 	}
-#endif
+
 	return was_installed;
 }
 
-- 
2.34.1


