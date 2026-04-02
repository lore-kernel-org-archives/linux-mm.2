Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A379FCC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122606B009F; Thu,  2 Apr 2026 00:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9F66B00A1; Thu,  2 Apr 2026 00:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036BC6B00A2; Thu,  2 Apr 2026 00:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E92FC6B009F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B16B18B7B8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:03 +0000 (UTC)
X-FDA: 84612295446.30.5616D8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 084B520007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIZNqIdp;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103182; a=rsa-sha256;
	cv=none;
	b=OouN+MSmmiA92nLjdnjXsefPwZJHcotZohAr5pg8m9hZaSKpk5aTbkaOeIJrV0SCgBXzVB
	6dXk5zbmvi9ycDuvn2eeJEGathL1D2qH2aKTmfP7ij7hq5hyeZk2vaeSi89R44xhbeuEKm
	MG9iz7jWTOGh2neLy/cCWZE0rE7Tbtw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3O3nTbzGihVtxjjI/2f4S+asSKC/YGLteudu0vZgmM=;
	b=BNptT+P61bPwrpdHVNrhHTUSbUs5nvyuHTWpzAipHtog87wHJO5uYTDllcft2X1/9EWFkg
	ssi34LdIJPnzVsC6OzsUuO2MbL3YNQg47QROsYnXTrxX73+t01/F6RxxtqshHWVVqSyIAJ
	mkLHMRaNOoAmKuTszV/2Lwm0Ssh6LEU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIZNqIdp;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23E9B437D5;
	Thu,  2 Apr 2026 04:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74D5C19423;
	Thu,  2 Apr 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103181;
	bh=lxXvlQh8xQ0EBf3to4Jw9wikE7NXPrSIjYbQ7Uoyt4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIZNqIdpzm6+W6HPk4rUKciovxte+Ir8R8/epNSPXK4ip3mfFRx//HB3VsV4IcxxY
	 grhk26iS3k+sEk5UN3RQPGXSmhhMYLSeaXHgHVluotjZ6QucMngudS0xvMQNTYyXnd
	 fPX67hTxkQB0+QkM0QhDxLlU5z8oq1o45ObGQwWRFVtkvVRHiPuW5c45f/knY49Lxo
	 bz+Svo6RhYvPkYQaPWYDCZy5cAXqxiuCP3BS1sV6yFr0lF3y+Fv8D/EX7kM03kDhdP
	 d6LWFm8CkHHdTroVD7ewqX5/jlazhuinnayqlFjpEcdv3LiuGb8upVQNvMeIAdvlqF
	 nsIyaZ2SbjyKg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 08/15] shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
Date: Thu,  2 Apr 2026 07:11:49 +0300
Message-ID: <20260402041156.1377214-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 084B520007
X-Stat-Signature: pe1cmuig9b4de3u49p1zehwuudhii7fk
X-HE-Tag: 1775103181-487897
X-HE-Meta: U2FsdGVkX1962jPzqTHPB2sfKY5oD35eWe+TTUwxRlgpte1KAE2gOX792RpZFXDgiBvfAqLHDZDakyrlI1V2P7/g5Ck3ae2IkzOcDKvLmROktgylYFfI0ROMnpuLjkc7GjWtrGOiI3IXYbYI4U7VDYotZrPNUP6TzaS2R3sfvhx8qH3liyLmERTL5xoQ0uVTwZ9YRgpGQfkRo5YpAFVzI9C0/gTkuODXPmOeSThdikFpS5uYQqTK6MtCd6ek4K1udwhYdxj/uJentCoj9Ar3U2A9B5+3rm8KtClFq2wwJ8ymHHh2PcP73YourvxX2/HTXU5De+9TEOGdjZ32Of76LEFFGMDZvyJ9t2TwrgX9HCmBySNbfVrqr5ZWguOiYRk0M56OZ5mRszENda6G6fjt9l76mSNFesdr0S3mopl20JeodFDtG2dfkVMrVBjwbhdNbQ+gxn5gedEhhl8h5IEq472+/seGzKRl7eKIFN78Yezy2e3nlT6cR6rAemc5bO0SToC5GQJ5rZSZpcIcfkvlZ1qZ4NbT1gBTbXLO3oFYOQacSm3gUW3tSaJY/qQKfWjks8TKuosznYuM/I2ATqoakvGMWsqkGNHTDax2gygmQx7uJdEfbqsA6luvDdaycVZu875N9McwWUMeL7XrTIeBsfEk6WgdMNCtfpGCaVSoi+n9tQZgetxg2Zr0ikPLM06+ycnmoCAWQlNH7UlyXnXfRHj8EjnLrLj3yCSGyL5FPrkS9khstA2jLgjLxz+FdDRRfGutyjX1j/PUZFg0riRC0vZgpiemm9b62a7KSPJK1zLj9Kl8iKqa6VP1L73pXN7/kan85ZH8wFwem2FtRksmZXnFv5i/7qH+oMwyUWbtTuDWF8/Lsp/u8WK60KtCeYcJ0ZGDF7dYJC9m/oVQ/3QEAPB2POeLeRCprM7i9AU5jzFTn9ngZaILAdaWEHm3iSohA03BOpCmbuObrxX18cT
 jGXuEB8B
 OzWR0X0/O4m/5W6RWkkA15kSnuyaC9so+rGTENQStVw6iq3JLfNgBCEG5GFTGuE5NZy50SSg+/bhPTgjtg/rWK6FAEX9dZDS6gKCLVHLkDmK1MYoUX676aBrTIycXCXAvcky5W00K6mIrgCREpL4wnTEc49Zztl0avIheJ6rVcEcrckIzA4Tr+xyEhb0mH2MBwKzuJP/NaXqcMEA3VUsNtSKUrTTOgCNyc+vRacgsLdwsL1GphDT8/9DCnwjGrjr8AJRpvoN+9Lee6zcLx/t67EaWOOXBvNO4k7Ah0LMrKa/JKel2xC4EFpYe7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing that
VMA.

Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
method to 'struct vm_uffd_ops' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 include/linux/userfaultfd_k.h |  7 +++++++
 mm/shmem.c                    | 15 ++++++++++++++-
 mm/userfaultfd.c              | 34 ++++++++++++++++++----------------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 56e85ab166c7..66dfc3c164e6 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -84,6 +84,13 @@ extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+	/*
+	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/shmem.c b/mm/shmem.c
index f2a25805b9bf..7bd887b64f62 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3295,13 +3295,26 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	return ret;
 }
 
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
+
 static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 {
 	return true;
 }
 
 static const struct vm_uffd_ops shmem_uffd_ops = {
-	.can_userfault	= shmem_can_userfault,
+	.can_userfault		= shmem_can_userfault,
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
 };
 #endif /* CONFIG_USERFAULTFD */
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e3024a39c19d..832dbdde5868 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -191,6 +191,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -232,10 +233,12 @@ static int mfill_get_vma(struct mfill_state *state)
 	if (is_vm_hugetlb_page(dst_vma))
 		return 0;
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+	ops = vma_uffd_ops(dst_vma);
+	if (!ops)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+	    !ops->get_folio_noalloc)
 		goto out_unlock;
 
 	return 0;
@@ -575,6 +578,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -584,17 +588,16 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
-	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
+	if (!ops) {
+		VM_WARN_ONCE(1, "UFFDIO_CONTINUE for unsupported VMA");
+		return -EOPNOTSUPP;
 	}
 
+	folio = ops->get_folio_noalloc(inode, pgoff);
+	/* Our caller expects us to return -EFAULT if we failed to find folio */
+	if (IS_ERR_OR_NULL(folio))
+		return -EFAULT;
+
 	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
 		ret = -EIO;
@@ -607,13 +610,12 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
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
-- 
2.53.0


