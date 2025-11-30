Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD30CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0A66B000E; Sun, 30 Nov 2025 06:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A4A6B0010; Sun, 30 Nov 2025 06:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849636B0011; Sun, 30 Nov 2025 06:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4076B000E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:18:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12FC41A0C0C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:35 +0000 (UTC)
X-FDA: 84167025390.29.082E1AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 60E5320006
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YeR77mac;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzWGSFyt0W/LS4w2Vu9AywP6exVhBuqR+qbaRna77J4=;
	b=yceLXNi50JfWrp/lRg5UZwGX/c62qasnwyxcFixJ0V9pLzdRpWHTaKGQSMd8E7fozvbsMR
	QzxxugbxsoI2NGqzFEGeQnnFAPPnACEiEzH5Ng2oXNrSkTuKzACdtRF4p+RMEOF/dUXEfW
	oQoMsuIIbK1PX+tRCJYZh+qQzs2WA20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501513; a=rsa-sha256;
	cv=none;
	b=N9FGvZs3G2Y/czM2ASO3670tcwnQ6L0Dusf5ygJcOztiMEmXrHx5WktlHDyw3UVqNTtsri
	Y75bvwhqrAvCWp7AA8RBChPMbjHr9qLtkzyMesxSdELqSbNAzeyWSufLqqCdFsDdKVb65X
	uGLh+dpZtvnNQ6VOMIrWydviIUaN9Ko=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YeR77mac;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BD5A42E17;
	Sun, 30 Nov 2025 11:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353A8C116D0;
	Sun, 30 Nov 2025 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764501512;
	bh=No4OV/v0jQLoJl8PKO7GG/i2wSSVo7iZmz3MRUSzNrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeR77mac03xw5SwBGRtzdZ/H+sOjspFJtYv8n6QV1GoUAtA5YBQtzB6KvA1McmoCj
	 KG9n1DxTyB8f5KX+wIv7kufbSzy9gESul7fy+1PQlps2ZbpuCHnm//qNHYAl6rdb0g
	 ppVz3ebKn5ThslvEpG/WIw0IQHAldkujMXFaHsjXgP69Fz5mFFnoaSO+M6Q/scZEFb
	 zXrX8iNB+/84yNGOQcJwEYDy8DWE2tSsHnhfkHwtFBe/HSjUf9gGvwuYyXcHM6oz0c
	 ORCVRYxO9icX1iVxjlcEPlwN8P+xjOcnQy4RUFOe38vEVO47X8Lwl16TMsJn4Sb/KE
	 aPvK0vIq3++yA==
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
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v3 2/5] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Sun, 30 Nov 2025 13:18:09 +0200
Message-ID: <20251130111812.699259-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251130111812.699259-1-rppt@kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60E5320006
X-Stat-Signature: tdmmnefek4ahrbjkpw4fojncgsmtu9bk
X-HE-Tag: 1764501513-43947
X-HE-Meta: U2FsdGVkX1+SRjb99sqcDXLyM3hQHzdh9r44BZnxlsCIqLLwGvzBHwFASjsKCx35gBRrMoSYwjINJjeTVj6NOwB/ZQ4iFPyABP3gDnAIAFFYhv+Jidgi73sKmQEwO3gR/B8pZnbcLq3yXJkk4CTT4FDd0pcwOrujeIfdk0Nw1mNGgDAnsHDmF00UGPOJp53fgQDW9dsh5iM99eNhHD/upapAuBvUPvmZmXm9aDSzLb7QiSc0crLWUzbp0Ww8a/+B18EHTDEtiD165M/euvcv0mQMi7040FZPKMz+1u3xXZaK2E1bLEaeDS1qOIjOQtAiWiNMiOhUhkqDWN4J73QFJSBrhmp8tpQN5b16mrs/lsFH/mtxt5x66s05lZs2318P5Nh52WG0kAycvhzBt3JsQprELse0e+lgKE3S6z3q5+rykW/cOA8tEGggt7KcBsjtwOWjq4Dhk6XsAzQ/N2XZkgNbtzVEJoW2VZFoHE6hWjGVTcw5jeI3NM3lcwsNrdT5FC3N7MU8CWHuhWbXKOiFBWRVZZ8IdDJQmC4BG2R8OekguS0EIVFTnVjFomMcr9OcPhjSyqGLkQH1CylVvkuRGHT/5d6uxZdkmxau+MLLNF6BOjPTFWlGhAcZlHSV7mTcKz2xMoMNRARwgrZO2nYGB+a/5HWac7SjOclt5M0Khi45ghDbpqJRQ1qbeu6dHuqnfwI6mwxKhUDHUri6VR2fe4mtcRHgKZ6wTB2uJqZGcpCtkZnWWvKwUU7WP9i/Az5mTLuVoIZ7HnZgqppM8DWru0jc6T4wRp+cufUzKsruebvzH3uYv7MSg7XXipISRifST1VQtjYHQSNum7Y8jSUQUstYUVplvmfYl/NoyWgcBQD0IpTXqW0oi0F19cqDIUCR9vG8oIUJW7BsqsEkzHzavi+PxSGQsIrjB0SDpyu3gCKIgkTWhjSFZs6KfTL4U+DWfdg73HPirkATG5EXpxp
 7EU6FlKS
 6ciSprVkcp5Hp9aPfLODro+AI4MeO5d2hCbkuTc1qjvrnHKxI5qZdTj/E1kOTYFE2/5d9coqPLYtIpFEVtb8gckcaRgRj0Er/o3kHN8KHTqweUbSm/dwem0BYXptSAUXuTb9g480DKqehQZZlbR8x2iXGtlef0J2Sp1LfnDCklAlhN+ssarP9UkVWF2njxLhmV/++YawSJYlkqJUST80hih7YVJOTjpGX1g23Gj/xuFLRap7a0dTRkf6Qw6fsyjTneOZiiYyysjE+uKPbSNxKHWW9NbsbFHv1qYy28kPZEpnB7BMUpM4LcXBG5rScfRecud3TEhGrifvYur6LBw2zbqlK0g==
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

Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
method to 'struct vm_operations_struct' that will return a folio if it
exists in the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
this new API.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  9 ++++++++
 mm/shmem.c         | 18 ++++++++++++++++
 mm/userfaultfd.c   | 52 +++++++++++++++++++++++++++++-----------------
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..6351a9cde360 100644
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
+	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/shmem.c b/mm/shmem.c
index 5a3f0f754dc0..9f8c54ad0e32 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3262,6 +3262,18 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
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
@@ -5294,6 +5306,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5303,6 +5318,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8dc964389b0d..5610f29dac73 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -388,15 +388,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	folio = dst_vma->vm_ops->get_folio_noalloc(inode, pgoff);
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
+		return vma->vm_ops && vma->vm_ops->get_folio_noalloc;
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
+		    vma->vm_ops->get_folio_noalloc)
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
2.51.0


