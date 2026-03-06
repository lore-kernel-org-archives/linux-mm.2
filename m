Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC67FCC04D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CAC6B00B4; Fri,  6 Mar 2026 12:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DF16B00B7; Fri,  6 Mar 2026 12:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D486B00B8; Fri,  6 Mar 2026 12:19:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03BA16B00B4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C566D8C0AE
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:18 +0000 (UTC)
X-FDA: 84516299196.14.C5CC780
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08AFA1C0007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muO0cZ9r;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtffwH0lS3IAKMv4Vt6FSD4IitP/Z7NlvAnyaQSDaB0=;
	b=OBXgDJsadQT/wxIyPWPOyLPSSncP0CPda91uhWjAFC1VDG690XP3ZvMOzsjXtQSzfyaPFb
	+FFizBJi6tZ5Z94LkDjmVWBBerx+hWeuaLmZ1BNmIEIOv8MwMMDoIFPx2zfBDMHoNIeTfi
	Pv2TGFNebJ9T1Op17kRZ0yBij3MuB4U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muO0cZ9r;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817557; a=rsa-sha256;
	cv=none;
	b=ldMAZ5WWyqsF5srn8pbgQ82cCzqamEEWmkGwLcfdP8uiIvUN43GuG1Ihedi7x2f/Mpz91L
	lzINUbdrtmUgvjvAgJd2T86ioG9OqUMUL9EfcMPDjt2tzcdqYVVZ7U8oHyDN2841RgE4b6
	Ow2s+hTGYaoufBBpG9PlufjXqPQnwOc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F91944333;
	Fri,  6 Mar 2026 17:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C953C19425;
	Fri,  6 Mar 2026 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817556;
	bh=/0oNlg7fiYv022nxhnrVEoCU64mvQSwuS01zGUwLSsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muO0cZ9r+JBiL14XaQg5yw9LiQxGht59+apEgASJ2jR3LGxBAL2DsQtktz4uqSNqJ
	 PkXHY04N+jL5v3G1MiqgSB6TbYGHqdBDSNAWY/aNjQxFtJSBEK0S22O0Y9wGNaJP17
	 In19HrRalevmDmNv5JBdAdSrm7ZCxnFnlXDD6srzq008AVs4fRuyfSBrSnPz+RHps5
	 1lQ+eH6EvtYxUo4N0NJqRwDFaYVUx8J7UuASQtNTGCIpna7WU5kGuspoZHDKNb5Pl7
	 dHZou2u+P4ijg57yiLXnqs07Bf41RlHmXBQ2PWIXWVKS2bD7DRkDLEXTYWCMpSCDpW
	 ThUH3wtwpnBqA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 08/15] shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
Date: Fri,  6 Mar 2026 19:18:08 +0200
Message-ID: <20260306171815.3160826-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08AFA1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: bs6nji6kfk11jncnqcgg7aunksabfo76
X-Rspam-User: 
X-HE-Tag: 1772817556-147027
X-HE-Meta: U2FsdGVkX193k20TgLqZHjslrpfY4aCZPIJe/+FIfOF+oSRwsdwv7wvMUxSZeKy+fnmzWhyAeqMUCsu9yiF653VQwQU/lN+Aj0eLFH2cHDKPmrHVauhXIIZ17KUKP0P/hHhC5IpJONzHNQYICzOa71Yz+Coc8xYduFsT2YDA1uJYetdCIgvbMDIVOIWBoTofdi3Sp8Mo6DkuGW6hK2qsZo6ZpoVutV577TTEMZjnPHuAKph2YiarAehNY46jQt8joPKYUNsx7ebxrwZ3ZXt6wekmyvu+Xi8a/WSMQTMCT7hb+0j31ll2ZFPscS9DPPGFRrEWAXivYe5fpelUHvtpPFvlpl8FXrKgXpIVMDynXw9cobTHvTZ4+8hsp8UHY/Nor2LsmXX9y1Vz0110zHo/xJ30iHXDdPLx7MRVDajjDxAgufWUX8rPVQrsA4Xs2/BVH98uaQl1St3gyVfVUbw4eHj2BF5ihVafQaAd5ai9iTFx60U3u3uH3XZo5ym2Z2M26/9BE8wwLrM5syToJnPVZbxJZ70dh2YXOzWga+WaOanfQuuqt3EvmhYk9sE1am5+JoMr39qQFkJqe9zkH55uXVy45KpqK23VCc/qotG+45yNh70Nuf+MrdTyT/IrwW6YTMDdY5+F6e8FnaxBJKARjhjfBCH7Q4qIX95Zt2T9sLroRRqpd22j4jm3rgAh556zoUKOMpH0592frw1ZK3Txv924vRcqI2LJ4TSN0KZMC9/aocm9AsxgYT+D67vuyOL81RyChO1x9yFbHqrj3SKvRqaGClV2IHdikf3bz280+Tm+IzxW/CGJS4GGUGVuG4Uuz/1v2lvOpMzS4E3naKuOWO9yxWbINrGf+JzPTx4GM4L/5TO/B7cN2e+ZNSRcHAIzZpH4REIFt7Kb4VaB7ylzg4SAKiT1rmWqhcpFS2HTZTvdMDMDQmpqU1gsFq4mxww5CJONplmYh0bwtKmpfxJ
 09RrZuCR
 gfI3ZBMzX4BpnHF5HoOIvEB2heRxdvV5g7Y/rK16EPERqJXLJ4fJJp5nMb6iq4fG6nHUFglQQ1qbTL06kVfQ+iwaApdVEzpaJVgxcTy+EgJ+r2XyrauPav2WyfKC3kZWiqnS7T4YtyNMVB3PpxifHfNMv9AptgMGvFE7sgqmNzwEManlSCv6RmA0WVa/nvbrAD4fuJWfCkaXery17xO4tP/xNWBwBeQSnV/s1ZW07W9a1LHVCSBvgCEe6su3FFhElhyV822B1ha1Ys9e7CtT7ChTMGA==
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
index b55d4a8d88cc..98ade14eaa5b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -191,6 +191,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -231,10 +232,12 @@ static int mfill_get_vma(struct mfill_state *state)
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
@@ -577,6 +580,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -586,16 +590,13 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
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
@@ -609,13 +610,12 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
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


