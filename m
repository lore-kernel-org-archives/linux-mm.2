Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06469D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B4D6B0088; Tue, 25 Nov 2025 13:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBD56B00B5; Tue, 25 Nov 2025 13:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528F66B00B6; Tue, 25 Nov 2025 13:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401356B0088
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:39:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E14C41A02C5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:03 +0000 (UTC)
X-FDA: 84149991366.20.EDC1CF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63216160011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wj8qoYDS;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nflb2ngRLvWlCSVeEWKtj0oUTcIhfiOv/MIi6Auq4jw=;
	b=ZZkexNfj2utEN+Ifn4cQkNIL6ynke3tSZ2yDKFPoP0TP6FIWb6Z0qJ7bVoHQU3Vyg4d10y
	QDnYSCYz4qwz6jCfi1d/Elk4YJfJzr3cYVWT9J2ryPUOtWBAlj7pJ3g50FjTRZX8uyQubk
	4rY8aikL1OTsw+Xkki0Ja94pvj3pk8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095942; a=rsa-sha256;
	cv=none;
	b=YFGCcXdpuOiwqTimFifGzUEoY+q53YLyE4y/uka3NdHGKcz+W8WqTBqVeA5o9pW025UlxH
	4YO9s4QbBYD4TNs5uYP/Ox976xon2vPmg+ruy64azyPr22cIBNh6YmTRCKzl4Y2r0mey8I
	49omRDdawFo/X0ZwmkyveQL68yDG6B4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wj8qoYDS;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 828A043F0F;
	Tue, 25 Nov 2025 18:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB6CC4CEF1;
	Tue, 25 Nov 2025 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095941;
	bh=GTL6sv3jyIqIOuXK1RoAg0jEqGilBxxcWC1OuTsqpJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wj8qoYDSVEZkraSreusP/ttnZ7MQjwFUL2yW9diO422dfOoQS9l4Xzt4GquO2r/lT
	 AaipoLvHX0Tz95B9SkGDNWdeqKtimfjXVTrDQQtUtcLHnIVZbB8KWK4cYaa23iEeVQ
	 rYpJc1K4TxxjqXnOMxxdgR1N99oHfMfzKQx4DO3vxouLiSzI/AldWhqY3A9iX6aDo1
	 ElbqLJVSHAnj/ZJ0vIFuuYmkPrTi9/3F1gTOWAj9hfiwpcfZnTuLmvvf3I0fYNZ5UT
	 4+A9Qy74pyCPC335g0abMSxG7t436jM7X47pwBwdvF539tT4SGKP/8axtN0HOEoQhp
	 6daXkv8vB8eyg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
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
Subject: [PATCH v2 2/5] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Tue, 25 Nov 2025 20:38:37 +0200
Message-ID: <20251125183840.2368510-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125183840.2368510-1-rppt@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63216160011
X-Stat-Signature: 8f3ee4bgwq9zox539nynukx1u9upe6hp
X-Rspam-User: 
X-HE-Tag: 1764095942-586957
X-HE-Meta: U2FsdGVkX19sY9fy/Q6KwgdIKZz0AzSDjo8tUfsy1dFAZ93si4DQw3eqErAkdwmjVf0dybWxENXUXax1xjih0zqR/UNtTIhmBjr2E3WvHDiVcgJkvAWWMYfdupkiNtubItSPR2JGgjAI/+PKiVI4wJ4jNyt0enfaylmh3os6bhkfCo8XreJ3L/lLVurNs/C5BCvbtvHa/d2TEQ04RPMZVzw7KrMke3BaTTh03tifha46txcjGpZD1ACftTBBfqBvyclFyL+k7bEPOyaP6APJ7z9T93thhCNs2PRJX7tw6t9MSDRFnaqX9/gEyLt1fRipcKpKaI227xUCh6Q3Lw98Mjqt7pfsK4LN9zjovs7GEcXEzWQrXXOuSccNVpKw0BW7MqCM5DYDs6V0m/VpD5jNn2R3Z4A44PE5SEV4kyuNLJ5b8UkTUaeEL3SV+d/t6Ve9dQySPq6hTcd93P4AEsFc/b4VPN4Fyp+MrUfCD2y+gW947TMp3f3loV9geZdo+Kr2COkZairH5TysLoaqBcqLVUvxJ87BwB0vEQT9PneBe2kR8T5g9g4TDvCiSnKBn4WTKSaVKXDs9jXIMzO28UEYnwJnmldvD78uMmKDnCoZh1RZoxApgbUuAYHJiAZxgbxf2jlLg1skEvYiSPa5ZZiRQoFws36Y3oJVMpVyR/DhkGj2JAaGz/XXvp7OWvVH5Z2rUwKqmWIyqNm/tapgbzwTVlOazBslb/ifNFjn6x07uLycu9cjy4s95lBy+vrU2j3FbOed6GdeRucUAwDkNpVN2mi4DjyanSr6XKP/zeNrIWrZzYjwpT4u2p7j/GDHF5rNCTV8nfUeAsOObWqHEehMyTrFpqo7lPWOytWKwiYUtD/pSfafU5znzKYs4Fab4jjWkjWHHuwV8ntHM7YrR46OF9X6g1RWhFYMLL1Lm799HfEANbX1P89pyntqsaTIatJp2bdpqzPOBBroW66enXl
 wVap/+BW
 deTqOIYdCP7YyQ/qwXqyFB5XzUcMyRHZh06CKZGxsh12Gql8=
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

Instead of using shmem_get_folio() for that, add a get_folio() method to
'struct vm_operations_struct' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio() method for shmem and slightly refactor
userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  9 ++++++++
 mm/shmem.c         | 18 ++++++++++++++++
 mm/userfaultfd.c   | 52 +++++++++++++++++++++++++++++-----------------
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..c8647707d75b 100644
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
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_folio)(struct inode *inode, pgoff_t pgoff);
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/shmem.c b/mm/shmem.c
index 58701d14dd96..e16c7c8c3e1e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3263,6 +3263,18 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
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
@@ -5295,6 +5307,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_folio	= shmem_get_folio_noalloc,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5304,6 +5319,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_folio	= shmem_get_folio_noalloc,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8dc964389b0d..9f0f879b603a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -388,15 +388,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	folio = dst_vma->vm_ops->get_folio(inode, pgoff);
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
@@ -411,13 +408,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
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
@@ -694,6 +690,15 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	return err;
 }
 
+static __always_inline bool vma_can_mfill_atomic(struct vm_area_struct *vma,
+						 uffd_flags_t flags)
+{
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		return vma->vm_ops && vma->vm_ops->get_folio;
+
+	return vma_is_anonymous(vma) || vma_is_shmem(vma);
+}
+
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long dst_start,
 					    unsigned long src_start,
@@ -766,10 +771,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+	if (!vma_can_mfill_atomic(dst_vma, flags))
 		goto out_unlock;
 
 	while (src_addr < src_start + len) {
@@ -1985,9 +1987,21 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
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
+		    vma->vm_ops->get_folio)
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


