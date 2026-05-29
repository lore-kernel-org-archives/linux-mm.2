Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB717CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798CC6B00A3; Fri, 29 May 2026 08:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7235A6B00A4; Fri, 29 May 2026 08:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC1C6B00A5; Fri, 29 May 2026 08:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45DD26B00A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1590B1A0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:50 +0000 (UTC)
X-FDA: 84820363740.12.046AEA7
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58AA3140017
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="ByB/4PuR";
	spf=pass (imf09.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGeZMeV+6Toy2BfwU50kHDN1vTufg8/wOGuq0DvP3ZE=;
	b=c1kA7yW3GCEAc2DkM5RSANdN/20Six2wkns9ayODbIa4Pn5TDwHcX6LyjlPcIFV0VTxLzl
	UF8w5yhLkZSSQjLsVIShytlcQUrVUW/DTrynp0pJInM73q4dkgDbKAT+tYp3xgY0KOv/Gf
	DWYMLjoAMuxI2/nTRlxo49khdsSDQrk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="ByB/4PuR";
	spf=pass (imf09.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057188; a=rsa-sha256;
	cv=none;
	b=PaoXTOj9VNKxw5OtBR9UV29wMfDN+KxN5uio5Mh6fJ1xL2c5fp+j7U1dmAMTuyRd1TzTAZ
	RwL30Fd2h/zvK42cocnTaxFN4m8XHnYwbwwgrrVJDs4Bg6pdn+owUbsfO5jt+PrAwnCCBk
	3aMa4MB3ug5gsUkpmhqLWFo55MhYN+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057184; bh=cGeZMeV+6Toy2BfwU50kHDN1vTufg8/wOGuq0DvP3ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByB/4PuRcDjKit48/Z+8HZbE49AkAq5DYuzffYFSxAIbxsPdxjlsaETNd3iXV+sEv
	 59ojVQbTqz3AR8ssy29SlEwMxZGf4S8Ms79tbxeMXQfawAkjCzDvg4co4XFu+8g54p
	 O4Aqb5rr45e1Pq1PzD06Dk1zhxi+Poak9/5ToObM=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057180tkgo7kc1y
Message-ID: <tencent_A2335C92CF3C8A7EF3121E4A23D437531608@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+XlrNUl1Lxurg2YUpupTBj+94wLieCfHcv0JrqBr9ojPlIzbJqI
	 x386pIbILgiph0fcnAAdez/p4vVKlgRXojF+wmEB5ZY7a9m7zElx+jUi6NEpdq6D3+uxyqpjhCgI
	 WNrxNLKhLIMM9915NjPrml5pw1rOJY8NCxptsD4LYTdTSYiiD37GDyqa/WqfyaLXgvxG81S3Sq+j
	 34xI8IlJCZwsAJZQLhFsggR804KMeWER3l8eCo6GtrHle981IvR7mB5qhwZKuuPdvO9tWf5oXue8
	 db5F+5LlCb7ky0SqFz/8ECb0Y63scxgKvddp6HcPFWDgHyou2diJp6RC4ZrjAELeyxxfEKv3HFoJ
	 cJ0rcz5XrTl9wW+KmFXTN3mweDxeQFy4etXz2AnnkEUx16bAupA1NCObm/e6+gTlcq6nfLqiqYSg
	 +PqQX+Fc8dih2wIvYxFVOzpAwA31J4vNHE1CUwMqH2pIRs1rElumI5dVpRQbuBAB75+wQt0ZyYIt
	 qN4GSCu6hSJVqlaZ19mY1v1W+w1wLCoW89IkL85LEIkFW6w+Efc1ma99G564fOJ4B/JYooxYU0Si
	 EjbwIsmrIH4aNqdb9X2pp7pex4NVVnkKQvCiLUqIXkykzmDCAHv979boLO5y4uToWSBBa+5C9kqO
	 dKLJtNHIgVec+bMDneMhz1TVr06qjmuK7H2noH3umPYqRaOTgQpcui2/4QXFksVJr9dLliSHXANw
	 y3K8cdC9BjfNSptWmOivQUcTwHKzofvSVMA2YGCyCsu9Rm3qZg2L6h4okkpZ4/p2jdqnfVtz3Fq+
	 Wie6Aq60x60wATTWD6tVXEPFC1/OEx3AiS6brGN7SbnoKkYQT5+pdyyHuVB3t0i4Ct4gGqAwPn+E
	 99jccLH7PL2dm8BAKZLBKV08PWyYaNmwOS2dS/yDQ2SUK1IGBuVHrRSdY5Vfx9hxVmJR7gFpEKyZ
	 +B2cIwX+8LA3JHi560XBMpBYR9X4boC0KHiTSRkVoQ4fCpuq5BRyrT105Y8erdJqT7na3WhGN04t
	 uaEx0vLH6nnB/agzx/qqna9bL5n5IdOKqN4k+GWQ==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 7/9] mm/shmem: provide VMA-hint locality for zswap large swapin
Date: Fri, 29 May 2026 12:19:26 +0000
X-OQ-MSGID: <20260529121928.4115683-7-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohtc1jhq73xy63mf9uyunugdqywju939
X-Rspamd-Queue-Id: 58AA3140017
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780057186-675303
X-HE-Meta: U2FsdGVkX18Jcf7ZqtQM0fJksrm6qoEVOulhss8EQ659UT+KvraEWomq2G+Zo2tjm6xXSUSDDMTUX5CMOyuiXx1sR5yAL2WDY/GN7VFuT253x4IqGTFS1JEqfIxOQUEjiIFylKIEbBwWwdY9x0TRD117tXqUBOuazTkILY8Bublj2LOI9rBzaWMJZu9Cb44qrLLozIDFSf04sjN4t2lUcCELCKgrhSa2/CX3Jmbq3FaYY+ubo550icS9AR9mxIMI/RDLYf8MJILDb0wOyUqWV1R62YGdXZ6ic+H5llpUPuKmYBIXoA9qSmRW9vWpMphPZOogxJxJgtL0AFWLTYZ3T3nalgiLPor+prlVy3nYNvlRLXv9jyPDRMcbtMH06mawvsmtss6oaXYBmbXIkwWzon84/acEYQf7j6bggmrTpgpIvOVGNfkGKuD14+FnPLda+6Yb4i6gPosiaXmCEVI2oTCisFViZq7GG1T2eEDLVEK5l9TIZU+J/lzOCl2nXVhFp/mGRN7JF8+bdLOxH6jzHoWNacCdW6MgO1bntW4V7i1bQag0uclj4jKoaFTKVdmVJRhiKjtoF6+hQIuUhwuYauAMnkFwdbxK0j2d+ORA/NjUMWQKi1pSP8nQ41ePblBMbjhH9ke+1MQnWaPz3gDbH1sHu3/Plh2otzqL5T2jCWRIFHmg5rc2ELRW6Yt4/IGwWFpWUkCzh090UoXHHlgGY63za4EpDLJrbLpU3zd8thX2JNY8VPFjS0YzMjr6VHXEhs0ZVpZDVHNKfFJXRk0p332Z566ZGdNq2dPB5mRvv9TepAL+yYKlYiGrRukzgv7Gm5w5WyLPwR1/QVV4B4AH+/FvOhKgK9XG0rW0OCHLwK2EEUFIHyju+toX+lV37OFAq6B+/Sx3uL2JxoCcyYv0PqHZ4GT4f4hRstEHTNfu4kOpC7Rvk789kyK9tOhCAdTYCgXe4gjFACB2eIhkn+E
 WW54xDRx
 trbE6ztw+07R38Z/aVP5UjNBmpHGA6IHHAq9D50KEk1La27/FyxVhP1tm49FsA+LxnCY6IXLun3cPAVNR2Uxn6qDu57JrysbD5HZSer8BOqPBh1A8o+XeCVm6MZHUEKEW6NzBGfX8wZdnLEEadlzM+bCJxxda1mQMlo0synGLgTWZuqTxBrK3N1YkMppa3qVJ1EWQ8eEOpaDW/MTGw7rQu6HWBv1/9ukRiqviFZpYGXlFYZ0QUaeqGNmYjXSLKi3tI8viG5TnQHGWjylcyDMZIqlmVFcL/bazmrRvEYGWSSxIhIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let the shmem swap fault path pass locality evidence into the common
zswap large-swapin policy. Shmem does not have anon PTE-young density
evidence, so this first step only treats explicit VM_SEQ_READ as
positive evidence and VM_RAND_READ as a veto.

The non-fault shmem readahead path remains unchanged. This keeps large
zswap swapin limited to synchronous shmem faults where the caller
supplies a VMA and the common policy can still fall back to order-0.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/shmem.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fa99b48ed62b..a5ac35ac85fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/fileattr.h>
 #include <linux/filelock.h>
 #include <linux/mm.h>
+#include <linux/memcontrol.h>
 #include <linux/random.h>
 #include <linux/sched/signal.h>
 #include <linux/export.h>
@@ -1791,6 +1792,29 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
+static unsigned long shmem_swapin_locality_orders(struct vm_fault *vmf,
+						  unsigned long orders)
+{
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	unsigned long candidates = orders & ~BIT(0);
+
+	/*
+	 * Shmem does not have anon-style PTE young density evidence. Start with
+	 * explicit VMA access hints; future shmem/page-cache readahead evidence
+	 * can be folded into this producer without changing common swapin policy.
+	 */
+	if (!vma)
+		return 0;
+
+	if (vma->vm_flags & VM_RAND_READ)
+		return 0;
+
+	if (vma->vm_flags & VM_SEQ_READ)
+		return candidates;
+
+	return 0;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2020,18 +2044,22 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		struct vm_fault *vmf, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
+	unsigned long locality_orders;
+	unsigned long orders;
 	pgoff_t ilx;
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
-	     !zswap_never_enabled())
+	if (vmf && unlikely(userfaultfd_armed(vmf->vma)))
 		order = 0;
 
 again:
+	orders = BIT(order);
+	locality_orders = shmem_swapin_locality_orders(vmf, orders);
 	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
-	folio = swapin_sync(entry, gfp, BIT(order), 0, vmf, mpol, ilx);
+	folio = swapin_sync(entry, gfp, orders, locality_orders, vmf, mpol,
+			    ilx);
 	mpol_cond_put(mpol);
 
 	if (!IS_ERR(folio))
@@ -2339,7 +2367,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (!folio_matches_swap_entry(folio, swap) ||
 	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
-		goto unlock;
+		goto failed_swapcache;
 	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
@@ -2369,6 +2397,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
+	if (folio_test_large(folio))
+		memcg1_swapin(folio);
 	folio_put_swap(folio, NULL);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
@@ -2379,9 +2409,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 failed:
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
+failed_swapcache:
+	if (folio && folio_test_large(folio) && folio_test_swapcache(folio))
+		memcg1_swapin(folio);
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);
-unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-- 
2.34.1


