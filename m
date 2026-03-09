Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C44F4180B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D026B008A; Mon,  9 Mar 2026 11:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FE86B008C; Mon,  9 Mar 2026 11:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E306B0092; Mon,  9 Mar 2026 11:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB40F6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:19:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CE951B70B4
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:21 +0000 (UTC)
X-FDA: 84526883322.11.C296368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E94A44000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DyLp+xOG;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn71YFrkqU6H+7eHvAMGxn11P+MzRxt3VLN1navmGlk=;
	b=f6Yiwr66mQxhWEHfcyXoj4MCwg35/O2ZUDeTFyjGz7ZBSty/7tK553gVhBoi2keI5kAPkC
	ZdRrH+dfoxwtdHQWC5WeywKdyviAYL5/h4n9tduH2jsbi09l6GCP4KFWg6N4tzA6p2zv48
	sRFjpY3Bbp5UM8iBoE4+IoJ0njUTKOw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DyLp+xOG;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069560; a=rsa-sha256;
	cv=none;
	b=47X9qgH7ReLw+FQrOsufVw3eCOUhuEPU8WBTkRwKf3yaGV9ZMM6Q5bHbH+SbkZikTPDWe4
	NlZTl8sjU3M7am5EjxxJWNN488YP7SxqnYaOWky9lkrAV1UlGE+WJINSusGNuKjl6o7HtI
	j2nx6g1HWZP0hvLWcn3CuypSQRuIzI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FE6660054;
	Mon,  9 Mar 2026 15:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDCBC2BC86;
	Mon,  9 Mar 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069559;
	bh=xyQnOW2UDFd5jAArw1nWS6MsXbZdktoGFPRukmSWN9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyLp+xOG03I6mJo4gcMfc/+Ifnd6+9mr3SmRZReS3gUB59IJtxRzKYh6uCwGbf35n
	 mA09i4Y9TZaDcXjdoHWgA9psr/HHQ5Vmw9UjHOgORc2dtCFhdHH5c+CdCLVoerUQFA
	 zgKYCWWMophRIJapyS/x9VRx1zzA0Xl85X4CYI0S9IAgmoqmrYHrU3vnG/8QmmjRBI
	 /AYEcixMmT7fSlKbi01wP+sn/Qc3LMxUelwYIpPHcDiAOR1UoJYubJtfp78jUFZvi4
	 Jiu1hH7v7CekQmhFXZdscglWKrkGWSFQfoHbqKVI0WCvwVybBq7Bcl+7wsK7dsJ0kU
	 Eq70tr05k+ywA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 1/4] mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Mon,  9 Mar 2026 16:18:58 +0100
Message-ID: <20260309151901.123947-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E94A44000D
X-Stat-Signature: 3rbud4ztgusy5hfraepencu45mz38s7k
X-Rspam-User: 
X-HE-Tag: 1773069559-673745
X-HE-Meta: U2FsdGVkX1/cXTz50bg+uGm7nLLJ1Q00S4aS8V/OZmPUu4XIJ3zHp8jO+C2Xy5FK9kXTF2s87ml6DAz3CdoHBBrArW8U53p4qAF2ZQleqmRRdxenXBQmjdbCSPGs7ogC3kOr3+RRdHQRM5my/Mu2o/6z7n/Alk6IAeLQeUJ/fxc/tIMG5+qsrcvgZVDy8ad057DLeEB/nkaFKZ4DYDTc1jhBlEWOWPRdDB2Rgiq70m7e+TihFvX+Bzio0Fnz4ZPHUtxjt+vtZVsjsykL6Ik4SJiZetuYNi5tVtLNFh7FZyhWGV7Y7popoTo3ST1MZtqq2Kg/zBPqHDrIJui0ZP7TXjiq23t7dQyqAhQFEoLLmEqvUxVy+ui2hr5kKXxCEKRd1V1cfDcbAQINcKdEfHwFy4ROzPtUkGQzvucFA5RnJJs5PguVdSDW9z47qkr4gt3TZHR5xKFtFGgvtiN8qEdmy+Fi7y2aCc9tA/C0YUOTyIlVzB7rTG4SsS+he+4av4VIvTbKZ3q56Y0KCPDGYtti6+a9QF7hKDSLuF0yplz4cj413kygWvy+F9rZMvAV3Yz6CVysTVdhkSM/mP5OeHz+ZJ4G/wyAkC3n83kdINrsxNpxYoS9SWq7IaBvIY6YXtNwZXZjEJsoefyQTFjAzFxG390AFt84JIVew5uvPruC/PbvKGi8sQtBWTnoGm0jWGWPAQn9FnQd1I06VSg8no+nJjangUmqTlZULTqeopEsWQl7y40CcMZ+LhS0CBNiw0CYgDb+j0jyizkZQ/87CcyKO1Brko2NF6CMrVDGF3IV6ActxMgHYRq9/4OzLc8C1rZked6QRh/c3hKlicemoyiffbmRYsBC9yZ7sk6ZnWO+kdI5kCkMvsAXhnO53GEVkL912phz6aPWd9Bz1wpCO6qa0vCVoGWUmmADZ/dmpmdL2OfRnI5dTrep/jD6aZlUGRsPFEnWT4UkQrYZJrChb40
 xAR3+elp
 4izYw3pcE3BSlt1BsuGkln1Uu1cHBT+kDewTduBFsX7Xs6bVWdTaSiGx3sp8laJC8X51jDrzY5QM66/ex5SGZaapnkvm1b9NijQ5H7pu7R1Bc9/ZzNebmHLA77APhK/Q6m5ZSc7spdR6c5qiqmFZj+DCKhdRSS6ePrJKvyM/Gs0tCpy7kFFfXaPC2JtaNoxf1axWw1YA3ywgiGb9hBnKQQ77vAOH+B95X+i1hwHGNx6koAc+lViFySHrYRyeKyR2c10K7H4WJZoIibf5zzrK1EGSsgUDp07G7SxKnfj9TrZUBiC/1PoxvoGAi4uRUHkio5uV+VUwl6JDY909cocUmWKntzg==
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
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


