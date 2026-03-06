Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80485F01823
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8C96B008A; Fri,  6 Mar 2026 05:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99086B008C; Fri,  6 Mar 2026 05:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC69F6B0092; Fri,  6 Mar 2026 05:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADECD6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:16:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 795EB1C5ED
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:32 +0000 (UTC)
X-FDA: 84515233824.08.CCDA25C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D031B180006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYcnWM2P;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSrxtXOfqFJ/zzJV7v+EYECVDPgUeHpXQ1grbZIaXow=;
	b=UoW1bQ2FCEHEllQfMAWN45cH1akZwhmsjBIDYBM2avU7RY3XFgUgmoU1keO+ZpOmRqC1Z5
	zsTcGj7sSeNaByTcm9mEQTIU4/H083RZWrIf519onGTUyzN+saTosL/Hlw/Z+Z2BGe7IcH
	YSoZIEAAQVw07XpKQzDPO+Fhxw0fcoQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYcnWM2P;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792190; a=rsa-sha256;
	cv=none;
	b=EEfhgA8O64rWFrmMuBXIHgnxa+vRMR7TkvW+nTZj8d+ybTSOTBcvfKahXjWFgtDVtV6VuB
	eq5dTf7miYmrN7c9sFBbp6bmS9Y+8c7T+hbgUD64jF/yPL9oiRmOS8wk4HYNU+/J6emiOb
	4+IG8FjsE0UuPY64B2S+rR6G+fG92Ag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 659EA60132;
	Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC97C19422;
	Fri,  6 Mar 2026 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792190;
	bh=KFS0WOpkdK9snEXTKSGUmyIFzfkZVmc/zggsd23+mPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYcnWM2PgaWt6KxKlBcserIDb5ISS2Ic/hH+YyGWSC4Cqq2/USjVGANct3h7BfHt4
	 iW6y0uLP8t4sYT4ySUgqzDyj4hDrff4hHN/PsXcs9QvO7K5FLNGeCyZ/3DVJylLgRe
	 7U2K54YOXWxerIVfnPyqlMMrGP9bFizxosZUiJIyP2Uiw4DHt8jGnRqacwq3A12d7+
	 Skem0a5LGx7Pbjrufkhom/w2uXLP+r0yyLjY7Y8IleoxyTanIrXRvDUGqL2b1vIMsE
	 CWDPWCecGQaqHgSNqdgWeuVPq7Kx30S2PKeKYHQjxvifSKd140d8SVhWR94UrscsZF
	 qLJZBmv+f7EjA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v1 2/4] mm: move vma_mmu_pagesize() from hugetlb to vma.c
Date: Fri,  6 Mar 2026 11:15:58 +0100
Message-ID: <20260306101600.57355-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D031B180006
X-Stat-Signature: k4d4ax5947ee7iyuxhf7bw6ejnzs6hd1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772792190-732071
X-HE-Meta: U2FsdGVkX18iKjKOrSqNzvi3rFEX0Lff5PZJldCe3OYpPp7zABGWY0kLL7ddHmmqoOWtPrM0hRM5JhkGwHExu9cKWG47x36bG4Oi80WoZhLZjNb661HlM2eCXhbHMgd9Pc8BX6xkIstL+IYJrs3aGBbvhavfNyz4hMW6jqTpfrtyRJpJAZXQymVP1RF/8Qkfnd9lcl8j4V8PnX92iIefi4xvFGS+2TaSopoFkifCTo3upTRTPP95plw0o106S6OpJGwzdcAAwnuElGIkOM2D5K3yvSd2lzVoE1pmD855jhldK99HwyDqY5yxKCGtuTuCgRLpkFMPJxCec6m6jCZPKNWrHdLLmYRCN/quPGglJbgI7rLPHRuy/sLpBrJT7TSOQqp7HQL4dwDY0jRLXrcXI4CKXFYyPHjgxeSjIjGObFtwmazbouAMSELRbKUwF4CVGMiKtFRfFbCYZ8jJ0P4Kn+5cR92Gj3DTZFvrpFYLC72X2Zmusv+JwqkrDb5DUCgchAzHq9YFRFA2l6kXE46MzwrkHaYOEfs4nwAZ6G1XVqjopg1xomTMUdE4WMSnguMqixWNPFgyq4YVgcdOVQWsNDTiKsPHJJKfDj5NtANQIp6+NwrkClipDsOaZDvN+/UsZwKtjkdqqvKVTDOlRkAAegctHbQftAutExG9x09ar3eAUkL9cnKybaTZkBDJ+hw3P+D2U+eeGyk3wBlhBgAil3esXG7/QVj5uWP4Wl6nVIS0IHrQLwiqVtlaiqmR/o+9wXbAe0KpzWRM1fbCzqRVWR60ZgPq3EW9cIhxAyOLgvvMSK1HafYBglPKdLkgE4iqXaFFvsxRaKITHx4VYj2uTVsKBLrs6udSD3rqTQf6N2b/KXrSEPlw2VeFMrDTh/YEWQFs/rYOgIZIMn/FLAcHBIteGZG7rbBQj8n+l9/Om5CtASSPabDNM5DN7E4Wit/HkOxcOy34+2TCkuCfL+K
 yJB/GBIV
 LdCDve6veBjdabe/mWnmOPb3yoI2HZiy5WJ4BBMN7/CJBENYe11d/6qOOPb7kf1pMu6HWrZAoVAT50RbqYnE4tWmr7MBhOJqZjLWkCTx+46Nu1Pz7UOQ8MRr8ItACqU3u7+tkosyIdjlsR3bLjRMT9g4+m/NU/3aaxukGoj1T7jCLikFNkxCsEgaoMNlFuWG+pRskCS5Cq/pfI/DR1AMc1mc45p+nhotjhvP1FhcXLFpF0urbXgOQeu+T6PsftJvjoivuKyQ34hC1W4olrr/6Bvdu8ourX15qtYKP/HJaP7W7fNT+webC50e/ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not
really belong into hugetlb.c.

PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a
static inline function.

So let's move it to vma.c and add some proper kerneldoc.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  7 -------
 include/linux/mm.h      |  2 ++
 mm/hugetlb.c            | 11 -----------
 mm/vma.c                | 21 +++++++++++++++++++++
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 44c1848a2c21..aaf3d472e6b5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
-
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -1175,11 +1173,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned int huge_page_order(struct hstate *h)
 {
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 227809790f1a..22d338933c84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1327,6 +1327,8 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 	return PAGE_SIZE;
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 66eadfa9e958..f6ecca9aae01 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,17 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/*
- * Return the page size being used by the MMU to back a VMA. In the majority
- * of cases, the page size used by the kernel matches the MMU size. On
- * architectures where it differs, an architecture-specific 'strong'
- * version of this symbol is required.
- */
-__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return vma_kernel_pagesize(vma);
-}
-
 /*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..e95fd5a5fe5c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3300,3 +3300,24 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 
 	return 0;
 }
+
+/**
+ * vma_mmu_pagesize - Default MMU page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * In the common case, the default page size used by the MMU matches the
+ * default page size used by the kernel (see vma_kernel_pagesize()). On
+ * architectures where it differs, an architecture-specific 'strong' version
+ * of this symbol is required.
+ *
+ * The default MMU page size is not affected by Transparent Huge Pages
+ * being in effect, or any usage of larger MMU page sizes (either through
+ * architectural huge-page mappings or other explicit/implicit coalescing of
+ * virtual ranges performed by the MMU).
+ *
+ * Return: The default MMU page size granularity for this VMA.
+ */
+__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
-- 
2.43.0


