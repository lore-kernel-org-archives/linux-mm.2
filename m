Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF154CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7AD8E002B; Mon, 17 Nov 2025 06:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEFD8E0003; Mon, 17 Nov 2025 06:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC848E002B; Mon, 17 Nov 2025 06:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4758E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:46:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AACCBC0C82
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:53 +0000 (UTC)
X-FDA: 84119922306.18.132CB05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 254231A000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ASNjqE6N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380012; a=rsa-sha256;
	cv=none;
	b=Mt5nto3I/WBNCk3leSRXeMHkiimCfuAv6Qd/E1IlRjqJD87Sn+5Yth9HFRmwEms+kvikO0
	BnbtBDrGD9mwNz/3X/ztS6Hol+HzisF7VbY5aiZUhfkilJ22YUVVdJBQ97/wdNWYnj/+OO
	nmwOTt+4wMfT5+zUV2OPApmHMcA3NME=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ASNjqE6N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gceY7UMaRK+5DHUbELSle7qQ240+gxoxoB0HQTBsdyg=;
	b=wPSn7MK3erhGAySSVMNlNMhbNMmMJebPXCP2PKr1St2AytGjAVE3UMWbDgBOPAfQfQwYOU
	o+DJWlt0pBg3F/QGR2B6poDtzuTvQs9untOfC33F+CTpeShnU5sU1IGhjyVgAIzIjuCVC2
	0gOCesnYisEpjOG+HFvyW/u2c91Hh2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1F6C601FF;
	Mon, 17 Nov 2025 11:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72761C4CEF1;
	Mon, 17 Nov 2025 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380011;
	bh=8/+DCxIp/1x96wp7dFSji3YJsLxqOklYakr89V1mdJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASNjqE6NCAO95VKAaSFpgbdylkHEuDccnhTR+4XMMjtopn9NNlmICMwZupXLHvZy6
	 Qn/AezNBaLpynFAZBL1DDCFPWtOn2e42k08YQ12GzYdooD9h+NdNTSo3qUUr9GeUNR
	 O2LWdo7TOCrKKpGIy6F2ZZmHdG9MjYO/KC3JRz3bk+PxeMZIYSitWgECxXX1m42jeq
	 H+t2rSeKR90Nt9VS01rdCwAxdvTqPqzF40ysWM27GX8pZYVQHQ/m6+zGPAeTh9GbRD
	 /m3oTXdYnqgy+1X1Eh5aMpf7yzBGPvXIXfMw38JOXNYGvUhgxpDhq74QyPBQSyej2c
	 Q4hTMa4Kk6rug==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 2/4] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Mon, 17 Nov 2025 13:46:29 +0200
Message-ID: <20251117114631.2029447-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251117114631.2029447-1-rppt@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 254231A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 4wocq1j8ansdjzjc16kjwtb6tkfnytqj
X-Rspam-User: 
X-HE-Tag: 1763380012-619566
X-HE-Meta: U2FsdGVkX1+QARY8fLWB9xbdGFUzVOXdc8WH9KvMgOHSgerTkKxZWzyBwnpC8OUE0eb1Z87lTALIu66twKJP4WTxiMX9bkH3LO0XyHrSDNd38vTwrA04U5TdteHSDBcCuz6XMnQcXT8mI563dPTdWsAAwIePq2ywpzPsS1iJuWUEkjsaaIM0FgzFwLmW0U3C2kPmGrFO4DClVhPExrk0j6ZN8+QEgIaIkFpnUWVBdg+RmRLhAKEr7Zl81WU2ZU2XQm0IAuUqjXrZhdVMdsweg/6sVdxjHJnEReYXW5H7CRC3Nxg3Y9Yyz2oQ3Nr3bG8H2DxxhCAaG1OOPTDi6pF9Astl86GjYmGu5EWrYMZqB1/TScLA6+1MN6uaetR1x33nUSGOqAthMifnrac5abDCXaPrwiTy0Ah7UMyp4Bd+kYGgoET+4i2OPIQW/ZAl41m0zZEo79esHQ9ZZXEaIGeop7jQqg6OKXY7bvv5f7GfRHaPkHQpWKwW8eKP9vYriwI1YA8+dEw0X7TLNHBqfgLa3KqbULz66+vLlHLCaj4XWgNlMreC4fXyphAVBux10e+DfyOlZQKGrX2LE63z5+YMTgtUP77XW5+DHq7MZ+KZoCeeipS/atS8DSY/w/1TZlglDIsWmL1jQmTmjkFZZpnn4kL58nZEKxOOv+LfoZM7bYgs3v5oC31UDCmPblD2E/zHkd7iTSmLmCqx7tIy0VRpAyBRv7kqKsqpJhLYxYx5tcfr58jGHCtiOyV238y07VqdEln5mk27J93lt5PnU0fhSfu2tgjTSJKbRK/ZCI9LO/9fWlt2GAcphhRMb0mc0EqR3H00MNguqXZwK7X0RZBcBdgOCpsDLtMMnH6ET/fSgXqHjepRBZYfu7CQaLzwHzbCICP0T0Wj8Y9RO+zU+Jk7q943LEOXyn79iilEOv6oagRPX+XmpdAQZbtrLTnAn0cRjIKiH4Tdk4XAD2iMlqf
 URouJgwX
 1A+TLVAqMaMuVYkHZp594pAuqdvsc4vpcwjSgLy6+I0jpwC7RFvT0FYQ388eQAxDOTTRvq0hZorm7QniPkYH2zFzGhq5DJpyemX2xhPK7u9e0ULGFhiapCZpMQ4+bZwS8xpb4Ya45ahhLDAi0sUDQjRAZCfyD8l9SwLu/rQV6YbcgAps5dlW1Ye4PMh/+D2GMaJJxTe49Mn3PKNBhsuIygM3kS6iKEZxD6owVoyt/cGBUOv1Pymh+1Qia7sQctlfWIrlv7w2FLtnfdKPcnDUPOMH9MBwwjTyGa+zupjWqJu1LNniOzSyuoTVKHlnFPeHVlsI4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing
that VMA.

Instead of using shmem_get_folio() for that, add a get_pagecache_folio()
method to 'struct vm_operations_struct' that will return a folio if it
exists in the VMA's pagecache at given pgoff.

Implement get_pagecache_folio() method for shmem and slightly refactor
userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  9 +++++++
 mm/shmem.c         | 20 ++++++++++++++++
 mm/userfaultfd.c   | 60 ++++++++++++++++++++++++++++++----------------
 3 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..c35c1e1ac4dd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -690,6 +690,15 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	/*
+	 * Called by userfault to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 */
+	struct folio *(*get_pagecache_folio)(struct vm_area_struct *vma,
+					     pgoff_t pgoff);
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..4ac122284bff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3260,6 +3260,20 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static struct folio *shmem_get_pagecache_folio(struct vm_area_struct *vma,
+					       pgoff_t pgoff)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct folio *folio;
+	int err;
+
+	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (err)
+		return ERR_PTR(err);
+
+	return folio;
+}
 #endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
@@ -5292,6 +5306,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_pagecache_folio	= shmem_get_pagecache_folio,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5301,6 +5318,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_pagecache_folio	= shmem_get_pagecache_folio,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8dc964389b0d..60b3183a72c0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -382,21 +382,17 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 				     unsigned long dst_addr,
 				     uffd_flags_t flags)
 {
-	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct folio *folio;
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	folio = dst_vma->vm_ops->get_pagecache_folio(dst_vma, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
+	if (IS_ERR_OR_NULL(folio)) {
+		if (PTR_ERR(folio) == -ENOENT || !folio)
+			return -EFAULT;
+		return PTR_ERR(folio);
 	}
 
 	page = folio_file_page(folio, pgoff);
@@ -411,13 +407,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 		goto out_release;
 
 	folio_unlock(folio);
-	ret = 0;
-out:
-	return ret;
+	return 0;
+
 out_release:
 	folio_unlock(folio);
 	folio_put(folio);
-	goto out;
+	return ret;
 }
 
 /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
@@ -694,6 +689,22 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	return err;
 }
 
+static __always_inline bool vma_can_mfill_atomic(struct vm_area_struct *vma,
+						 uffd_flags_t flags)
+{
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
+		if (vma->vm_ops && vma->vm_ops->get_pagecache_folio)
+			return true;
+		else
+			return false;
+	}
+
+	if (vma_is_anonymous(vma) || vma_is_shmem(vma))
+		return true;
+
+	return false;
+}
+
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long dst_start,
 					    unsigned long src_start,
@@ -766,10 +777,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+	if (!vma_can_mfill_atomic(dst_vma, flags))
 		goto out_unlock;
 
 	while (src_addr < src_start + len) {
@@ -1985,9 +1993,21 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
+	if (vm_flags & VM_UFFD_MINOR) {
+		/*
+		 * If only MINOR mode is requested and we can request an
+		 * existing folio from VMA's page cache, allow it
+		 */
+		if (vm_flags == VM_UFFD_MINOR && vma->vm_ops &&
+		    vma->vm_ops->get_pagecache_folio)
+			return true;
+		/*
+		 * Only hugetlb and shmem can support MINOR mode in combination
+		 * with other modes
+		 */
+		if (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma))
+			return false;
+	}
 
 	/*
 	 * If wp async enabled, and WP is the only mode enabled, allow any
-- 
2.50.1


