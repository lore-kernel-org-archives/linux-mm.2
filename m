Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18D9F0181C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C82E6B0089; Fri,  6 Mar 2026 05:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E616B008A; Fri,  6 Mar 2026 05:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A206B008C; Fri,  6 Mar 2026 05:16:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5FB36B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:16:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AB401A04F7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
X-FDA: 84515233740.29.F9D5110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC3B118000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kU39nsPR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbrFa9bU212XLxnE6Ld1YOCTHoFWytuOTtuzGGl9GOs=;
	b=FwlpN/3kk++p6lqbKQdz+NHa5tKfUfSyXrA5QHc4XUWBbV1h1ThEv8M8+vPGEa51QPemXE
	LVIlIAwOe7M1iESn5LLAPuWJtuYkSDt7YGUmkezqeBi5pmvCPrSO19laybi/4qgYD6ZBcd
	nuZoRZJID/jHyy3NjSlJAklVuGD2k2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792189; a=rsa-sha256;
	cv=none;
	b=OgfXW4pt6l5pRzCEm1lljov7kCpTHUd+7pcb8VADSpsTdNHAs9/BqEe9CI3PWpNt3o8vke
	vv4pfBc6JaTkoFSHNujn846e+v3JoDb9Y04GmHi5+NBMjUb6ycWaBGK+vp16OSZimZKhXL
	VQW9GhFWpkbcMOy2PHw091HWqKBOeSs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kU39nsPR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A495A40940;
	Fri,  6 Mar 2026 10:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365D2C19422;
	Fri,  6 Mar 2026 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792187;
	bh=wXe+RSv0ZEZP5PzCGaEji2iLfOC9MuiizNczqfoD3ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kU39nsPRVeuy80Xot7u6yG6vMyTyS6h997P73CrnD4Uyqpy624AKPN+ubADcvkfjP
	 a9iQwyewJuuytTvKDcC/8rOKLTG+an15rRuwx+T+iSmhFomRVzbckAYuOcC2XpFSfW
	 VJQPEroBKqE353sSdphB/CJ63WiHqv/e3xNlbCxcDuNrYeksB/HvFo1KsposSbh8Sl
	 PI28L4pG8bvlXORzyDFf9BS12DIJAg4ARA2xLpvXN7ZI6dl/T25TwCjGcuIUXAqM0S
	 xf0xFt+3UQAMKk0VL72N2I+xwG9I0cY3dWhbq9dS0zjPmHnC7FnkAFx/4kfoe9mtCY
	 hIfrH0bn+WFaA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Fri,  6 Mar 2026 11:15:57 +0100
Message-ID: <20260306101600.57355-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC3B118000E
X-Stat-Signature: yt9zoicz74ka83fqo9yzj7hhgxph9scg
X-Rspam-User: 
X-HE-Tag: 1772792188-530463
X-HE-Meta: U2FsdGVkX1+UVnBNL1O6LzwZ7SQSJ8k2zAuVfNc5aDkugruZwSK0a8+XovSeBbwU4OWKa21Jb2TLOy/N/VCogJcKU+qcBnmfLmPKvfCr3wz7EI/WfxC1rzWa91ym0k4gcClzc1QewptsXvkrA4NRCgTQJEga15nuZw8A85BE6fbFV8tsKEl+t8Um0dHlO4v8+iSl62qs1gyQgh/B8nAWgYK9W5kV4kHWvgW3ZM+MQISNnQOQ1m6dnoFt/9jKh7URjuiHYUIUbfjsQREm55oRx42Yd7YRXy2C9wrfcp0an2J9scEZ2RH2tG2dqeXHmtDDjNA57ejwF9LZFcL25jLIpwYd1iN1guJuliT7ecNmDFgtAapd6GXpx4SfT3yDkxzOj04WDq0TY1pIVE1jg7WKNVNaueU4k8dfp6u+faBDAdE2BSoBlRWTP6q1TKWi6WOoh9zloPnqmm/7pzTyAHCUu45aSuer9fVXCTj51mkaVnByrdfJ+2eEXiaj+uyRX96cwoilCBUJDMrnTLu7q5s6wV1lpHaed80vc/lDDScP5F8apZvGlxh5Ly+qyyVe/heLaKZhXDt+RD5NWFeK1U8BohcgSv//IgbAf+VRaOVaAnA97/ZMRE0iwN9+5BO/00K8xw0NX4OyeOvz9Eb1FYp6xeSthde9tA7NjvUjdOTbQyoXH1aelzRU257VbKB+geUDOg2B/ibg/bT8IVW+jje82cZYUs/yCBw/PTDTqjL4ylzEivQk1OezhC4IuOWPJBcgAYj61pHN5vuoQiynr0SQtvp4tc6ot0X5NW62NYtSVLEXKRu4YQ1lpfW/3qntDY8SZ0+6Hk/YWuOICrFU+4ENi5m2UeRrvtffvdTOYSqLEMv95ZJr8P7ad2nW/x/d1kwy0MJZZsqD5p87SBjtp/yVs5RH3Uq/jFpzwxoF7o2TQExFg571oPATXVTd9F3wpfM3RQ9mCOlUYOLxbdZhlhQ
 2xjfBwVz
 CHA/lRCR2FlFW9Un0qzfSilBf2KdIyv8swQtznW0y5dTRKJw9tNXrj3w5Ld+PhA0Rqs/uLcoxKpcARUv9JGmm+mvu1M9ZiXVof3xTBZGBITiets4eErzMdGrSKGd7QqYL9TpAeYBJ4/Ve4C9BUS4DOl8d2U3aCiGXOVEo8+fDGj/Em+om4aRn78isH/KfDDrkcB4SsWswZ2galeauyWtRft0rmZMfFwr5caCNLrvMKdAC6nZKF9XSuZkSGzGU/ttyyoxotOSm8GDo4loco5Avt9TVX+CpXcDcBgccUtmtcg+zC18McXHvHW2+yj8Njf0k1SvOXsCYk+SKCB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, only hugetlb had special "vma_kernel_pagesize()"
requirements, so it provided its own implementation.

In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
vm_operations_struct") we generalized that approach by providing a
vm_ops->pagesize() callback to be used by device-dax.

Once device-dax started using that callback in commit c1d53b92b95c
("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.

So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
would not pick up that value.

Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
implementation. While at it, improve the kerneldoc a bit.

Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
its __weak symbol might be overwritten by a PPC variant in hugetlb code.
So let's leave it in there for now, as it really only matters for some
hugetlb oddities.

This was found by code inspection.

Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  7 -------
 include/linux/mm.h      | 20 ++++++++++++++++++++
 mm/hugetlb.c            | 17 -----------------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..44c1848a2c21 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
 extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
 
 static inline unsigned long huge_page_mask(struct hstate *h)
@@ -1177,11 +1175,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 44e04a42fe77..227809790f1a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1307,6 +1307,26 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_kernel_pagesize - Default page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * The kernel page size specifies in which granularity VMA modifications
+ * can be performed. Folios in this VMA will be aligned to, and at least
+ * the size of the number of bytes returned by this function.
+ *
+ * The default kernel page size is not affected by Transparent Huge Pages
+ * being in effect.
+ *
+ * Return: The default page size granularity for this VMA.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d41fa3dd43e..66eadfa9e958 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,23 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/**
- * vma_kernel_pagesize - Page size granularity for this VMA.
- * @vma: The user mapping.
- *
- * Folios in this VMA will be aligned to, and at least the size of the
- * number of bytes returned by this function.
- *
- * Return: The default size of the folios allocated when backing a VMA.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->pagesize)
-		return vma->vm_ops->pagesize(vma);
-	return PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
  * of cases, the page size used by the kernel matches the MMU size. On
-- 
2.43.0


