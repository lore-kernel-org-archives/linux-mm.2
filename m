Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AD0D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5B16B00A0; Tue, 27 Jan 2026 14:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D3A6B00A2; Tue, 27 Jan 2026 14:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572D56B00A3; Tue, 27 Jan 2026 14:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43A6B6B00A0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0605BD28F7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:40 +0000 (UTC)
X-FDA: 84378735840.15.F0B8EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DDB1140019
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIFX02kq;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5j74OqnLPSMva04fTJBqd+4qMSsouCx68nOPevvUXbQ=;
	b=nsq2HN2U7ePU0BgU43Yf7e8A06iNBnyYTy91j38Q0Zfpli8YliLiak2iDLATvWs+zySfsN
	FBN0hs+i6srTNE0uupX1CJ739ypzqs3BhfkJjuH/9F+X9m5r1bJQMVm/ixWkwNjoZjBRTm
	Z0je2zWwSmF7+ADGReprpgkeSqQi05k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZIFX02kq;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542238; a=rsa-sha256;
	cv=none;
	b=QJW0klnAnHKDqRlIkXG0C/VQ+5OVFISNKh6vwQ49Sr+PNJsQlwXUH01Cf6tmEzpdCBFzRP
	+/S8c7gpLQrnpLIzmGXqX0QbFp/N5mQuzW3YfsRJ9dXJyLOxdevfDO0Aseq5OWmhnqQJK1
	jPp3mYY5CntWP4AtwiZlN4PRp15Ejfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE650601E9;
	Tue, 27 Jan 2026 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9613C19422;
	Tue, 27 Jan 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542237;
	bh=dEjTs4g7Ldzs6VFuT/arDcgalMO2GCfU8tcBpfF3p8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIFX02kq/eb3tdlUyK3+ux/FsIlLOYCqnviY6Ie7P/JoMu0xpvH0YAzid+JPgh/wf
	 ZeqTvHI90vv1ymfJ5mKlTSi7ENxzGNs0eiDNpe7SKCKi9YBeblG/mupcmyOBTb5lfi
	 Du+zzNcONbAQnPXllF3puU5zkWcn3oJA5C6i24cg0xb6cyKMIBRz1sxJDbetb+GomZ
	 ebsMHkfKrgYOtfle3aDrqX/AIg7yiUZwWzJrbevM5HsVJ7crsBY9sWOs1mGJLRC+4t
	 QtQE0BT8W2UM4lZNTM8NJDoKhmUDX5AtUDIRlY1FGik8uzBb19PN6zjwHOtAQvIeoq
	 e5OQTmT8pAcFQ==
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
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 08/17] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Tue, 27 Jan 2026 21:29:27 +0200
Message-ID: <20260127192936.1250096-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DDB1140019
X-Stat-Signature: z1s5f5wjhwp1drqtz8ucw14ne7ixfcat
X-Rspam-User: 
X-HE-Tag: 1769542238-290337
X-HE-Meta: U2FsdGVkX19QYgPrzvoVPgXDt52oS9B9rZ2ZFlGqEhnngL82LD8j+yBTkUoA+AB834ZoJea7uqsxABCy8KDQcelY5vnBli5/ZtUfvzKnGxSoL7nhhWrl7AIOHMRu5aFWiEs4zv73ghu/ewuFuMCNz7fyR0y1mnYkGsmZtKRs9at+7YlDZsM8dMbTKxXgJJ3jlAxy+NjBZszyb4bgalvwkSWK7RvQQlwWUp3HKTxdXFdAXRznuJ4eVUWdPr+UW9qZwKE/HCa2fwS7QKRwECyF1v8pxSvV00AAsfspicIINXVbDFCFvmR5lEcH86doVp81+hpkwxgL5FmfoLxk6dkplngjhXM6Hvbtk6IAuQodI2AvDx6te5yoog/tKQI1VQyo4OKwT77DGocwnUgiOH+qpzlNMSLol39069Sbc9t4mkowmj1m2L9gZ05+bNg0zUe+hJBnvSV9gZZOttA/81dC1DpaaMpZRTNk4+3zLPIGJnM6/DC67InP3lRgqHeXFm4uTM2voPv7liW1sT7EKUN2eqkhMAxpB8XBC6hP6dDgtE0QzXIbCouRMyUhUp299FyVm3y5MS4DmEktr2yTnUfmTcf28JmmHOp0TsYmAMoalJyWpyHN7nj3Oy31H7040eJ7dQgZhBqS1n5fn4BOQHpopx+dXZUxaphmMdEtstMj6VfJRPTeOZU7cKCGnSAV5LjHrTm57X/+wNAG3NXxQphAMox4YG8pVJp5OaO1uj4gj7Ew8DPuJvomJSeXzAaa/hOcxDkQsa+ouOtDvaNVTTkxgoLN22MSbzggLyJe5CDY7BkEJSgnkTm+u+FzH6Ezb98n/5cQ3RyarjYdpU8O+1DfUQqJ9x5FERfZV1+mWkM9CB9u0B1/X5zvgm4+0QD8nAap+bTwjn3rYJEtr3Pbwqg8YNKfIhbP6t400x1oBfg1aFUDR2QGx74k4zePWPgX8NWaJFQ12Kxjx/UQS1nC+GF
 lJCmXdY4
 UegJFLfk3dYp7JIZEY3gS/58BGU59ptoWaYaakjYu0GY89Z8VRropWBB4PPBmL10O+fJzLRs2OKtW/bJ73gQ1Ga0hoIrBEPU/i5eAC6J/qzepTRH1CA5WXeewYKDFa5LhMtRu12ejvKEWajT+OGKNJmIScqUQTBDC4sUxIiLho1GNJVdWxOZQ2J9LaRIp8Z+EJKtdclhI3WvdMFDvvkEO9eslrPG58g5r8eh7dQt3gWVujo6DuYuz+0s2riH7lXfyOQUoyHgges7kwil6SYTDUwjsjYFCw6hOSv7C
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
method to 'struct vm_uffd_ops' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h |  7 +++++++
 mm/shmem.c                    | 15 ++++++++++++++-
 mm/userfaultfd.c              | 32 ++++++++++++++++----------------
 3 files changed, 37 insertions(+), 17 deletions(-)

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
index 9b82cda271c4..87cd8d2fdb97 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5291,6 +5291,18 @@ static const struct super_operations shmem_ops = {
 };
 
 #ifdef CONFIG_USERFAULTFD
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
 	/*
@@ -5303,7 +5315,8 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 }
 
 static const struct vm_uffd_ops shmem_uffd_ops = {
-	.can_userfault	= shmem_can_userfault,
+	.can_userfault		= shmem_can_userfault,
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
 };
 #endif
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d035f5e17f07..f0e6336015f1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -188,6 +188,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -228,10 +229,12 @@ static int mfill_get_vma(struct mfill_state *state)
 	if (is_vm_hugetlb_page(dst_vma))
 		goto out;
 
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
 
 out:
@@ -568,6 +571,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -577,16 +581,13 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	folio = ops->get_folio_noalloc(inode, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
-	}
+	if (IS_ERR_OR_NULL(folio))
+		return -EFAULT;
 
 	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
@@ -600,13 +601,12 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
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
2.51.0


