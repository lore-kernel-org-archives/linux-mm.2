Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BF4D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155E56B00A2; Tue, 27 Jan 2026 14:30:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A356B00A4; Tue, 27 Jan 2026 14:30:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02CB36B00A5; Tue, 27 Jan 2026 14:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E38606B00A2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8E85140333
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:46 +0000 (UTC)
X-FDA: 84378736092.22.F6CEDA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E378F40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXykKUde;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYWnDfrq/9PY7HmG0axOW9m1ZGPsUgbr2glsbaixZ7Y=;
	b=eHcVIw92lnrZP4C+IKZCJA90W0heVsCYB4ZMLxSXRSropYrknykcHbDq0XkxMGP7c3+0tI
	stU9ozK6UmVKx5NuT0elkhW5VSnh/wMAhnP9UVZbDOV771TfhqWSRDMTjYHJog3o+466GU
	NjqMywYNv5LkFq5Alz/iqL8adPnQmj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXykKUde;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542245; a=rsa-sha256;
	cv=none;
	b=2j16jG1HZlZfQRW7WIcrJ8ZCXvPeNOEdIJmfZ8CULcx1Jfmq/CYNwFjygBQHXbpRM4CuHF
	qvuuwtvqGYs82r54Qlk3rO79rDMjWEaswdquqwT7JLEgw/Gi9mTJBLTS3ZOCTN5UAfe2yC
	IZM2PbibBZyu+6CeNXaaFxWR/xzspl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13C5041E4C;
	Tue, 27 Jan 2026 19:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349FFC19425;
	Tue, 27 Jan 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542243;
	bh=gOZGYyaN4+ceUz7X3a7wO7Gkwgg3l4aHlNGikBmh8yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXykKUdeTd2HBkgc2hP7eZb73bNLFL1p0lWi1DNQnLh1pAQdYs0qjNCWjTFQ2H8cL
	 uO+5GwnBXEAb1JdsiscE81/F86rJ7Pqwk2ZTSAq5LiCkZslorgwa4m/PTS+/V1f4Uv
	 F9WDlZuJMsfFFhXd3YkOKnwd36NqNyu1sSKWDujHgEB9BrSVcQk01TWF0KbFP2IiDZ
	 pMau7AKFfeexKFeL1N4B0sigcjJgBDW8IsZ5Qoxmgeg34o3B3zU+ucLgnnhPLz70Po
	 opITgJ5F1yXFHFlDeTepWkBXBq/3bO8HJ0yRKsRKlyu3ozcqqcqoCoDFe5BFq8pQRc
	 7I9O2ABBq9LFw==
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
Subject: [PATCH RFC 09/17] userfaultfd: introduce vm_uffd_ops->alloc_folio()
Date: Tue, 27 Jan 2026 21:29:28 +0200
Message-ID: <20260127192936.1250096-10-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qb5nagjqccdn7zs1kjafbomgx78cnd7o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E378F40006
X-HE-Tag: 1769542244-110551
X-HE-Meta: U2FsdGVkX1//P5UNvJuH5qDUe4gDCFHHKRIvNMNB0DUirjNRGAvh12131/dGKZg4r2/eFsuYhkGZiTzQMcuw6W+KZrEaTca7YOC9K8PJIoMR8IlDhxyzwsEPWa0K5SfxNkR7a9mv+gB43pxflt6g2+8fx/ohOd3eU0P6BX07rWwSI+iQ3zl/eC9CEfH2OOMBNP7tFMfTK8iAelnvRdnsg2t9b/ecnh11gIDLKqi89k+e4iKounj5i47tOjsbYirICkutAJJ6coK+tqq66Hb0ACklZ9436/yhVHekfNo48iloZ4htJvfWdWBKmMhNfLHl0JpiyKeu1Gn52a7ZAPELOCuwlucbCejZGQloH29HCtQ15xtJdPAe7k0E58BdBmwmArF2NZj5n8Zdyl/N9eEd7CJ8gZTWkFSa+H4LM/YFE+NqgRUIbBjDj9qo8RT9/OZSUXliUMkXhdIKJQli2y8brR8okNFrnzmKX4z0aq7js2c38iUoQ1Xdwr+tUQctXXof65x0X6Z8DXO6XjrE/aQdpNZY79HR2VoL0+2qgmjpHxszYHK8jNen6VeC7eTlhHzQG1gjnW+gcsLvqSUexHjp+BZeOe6U1GaBD4GLCDaFGE2jG6XfvXX8YUYYJDVyzRtNXzif8kH+ubKCZ4t0EcBwc9iN4PY89eRe6nNCHnydp774J4n0srPBJJUL4VidvC9+pvECNjYAwqtkscvcICaPsUAZJlUlWERFBXh9nIGec78PlIP2r6GTIQ8IC+UxHvTKBe5fZ8r7BQ0WdZsCheA5p37sEUGr0Y9fTzG4gQNOsQr3F1bFfjMNTFWqjFPYo4cOw33nVAIaSzUcxtPNOoVjrfONQ8qfO14Syl5UQu6Sv2HmfbmXLPWHC3gfyrw2L7a5z2YMkqhpQ29U6rhudZqSqv6RPCoRHWaUwq8iQVfEN3O2K4G78RXQnpocggtMYuG1I7qCR69rDxMds5gf4Qh
 +8otq66+
 eqLZlsKdfOZ3mxqjA/ecG9C5XDWbSWFKkwo7lr2XAv17aQyo5ghwiSpV8YYMCepjx/kJCgsHWkn6FfJbuO2X7uaAtLprp1EXD5G+tCcURNz0tRsdea8pk9q1/wfnbH6Nvh2J+p16o+kEyyf7Xpnexgei3W7DLmDSou+HnzzTYXCebuzwzSa9ea4Qvj5aDIrzk26TnlWgkOvr3jWYhqvOBu+ydrz14wj8gDqHMu0iLTlo+tNtSRuJqILlapeJ29zfVhkMiqT5l52SaCLDSSJzqigQcNKaPIOlTTfuq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

and use it to refactor mfill_atomic_pte_zeroed_folio() and
mfill_atomic_pte_copy().

mfill_atomic_pte_zeroed_folio() and mfill_atomic_pte_copy() perform
almost identical actions:
* allocate a folio
* update folio contents (either copy from userspace of fill with zeros)
* update page tables with the new folio

Split a __mfill_atomic_pte() helper that handles both cases and uses
newly introduced vm_uffd_ops->alloc_folio() to allocate the folio.

Pass the ops structure from the callers to __mfill_atomic_pte() to later
allow using anon_uffd_ops for MAP_PRIVATE mappings of file-backed VMAs.

Note, that the new ops method is called alloc_folio() rather than
folio_alloc() to avoid clash with alloc_tag macro folio_alloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h |  6 +++
 mm/userfaultfd.c              | 92 ++++++++++++++++++-----------------
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 66dfc3c164e6..4d8b879eed91 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -91,6 +91,12 @@ struct vm_uffd_ops {
 	 * The returned folio is locked and with reference held.
 	 */
 	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should return allocate a and return folio or NULL if allocation fails.
+	 */
+	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
+				     unsigned long addr);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f0e6336015f1..b3c12630769c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -42,8 +42,26 @@ static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 	return true;
 }
 
+static struct folio *anon_alloc_folio(struct vm_area_struct *vma,
+				      unsigned long addr)
+{
+	struct folio *folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					      addr);
+
+	if (!folio)
+		return NULL;
+
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(folio);
+		return NULL;
+	}
+
+	return folio;
+}
+
 static const struct vm_uffd_ops anon_uffd_ops = {
 	.can_userfault	= anon_can_userfault,
+	.alloc_folio	= anon_alloc_folio,
 };
 
 static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
@@ -455,7 +473,8 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	return 0;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
+static int __mfill_atomic_pte(struct mfill_state *state,
+			      const struct vm_uffd_ops *ops)
 {
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
@@ -463,20 +482,22 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	struct folio *folio;
 	int ret;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	folio = ops->alloc_folio(state->vma, state->dst_addr);
 	if (!folio)
 		return -ENOMEM;
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_copy_folio_locked(folio, src_addr);
-	if (unlikely(ret)) {
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
+		ret = mfill_copy_folio_locked(folio, src_addr);
 		/* fallback to copy_from_user outside mmap_lock */
-		ret = mfill_copy_folio_retry(state, folio);
-		if (ret)
-			goto out_release;
+		if (unlikely(ret)) {
+			ret = mfill_copy_folio_retry(state, folio);
+			if (ret)
+				goto err_folio_put;
+		}
+	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
+		clear_user_highpage(&folio->page, state->dst_addr);
+	} else {
+		VM_WARN_ONCE(1, "unknown UFFDIO operation");
 	}
 
 	/*
@@ -489,47 +510,30 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
-		goto out_release;
-out:
-	return ret;
-out_release:
+		goto err_folio_put;
+
+	return 0;
+
+err_folio_put:
+	folio_put(folio);
 	/* Don't return -ENOENT so that our caller won't retry */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
-	folio_put(folio);
-	goto out;
+	return ret;
 }
 
-static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
-					 struct vm_area_struct *dst_vma,
-					 unsigned long dst_addr)
+static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct folio *folio;
-	int ret = -ENOMEM;
-
-	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
-	if (!folio)
-		return ret;
-
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_put;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	/*
-	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * zeroing out the folio become visible before mapping the page
-	 * using set_pte_at(). See do_anonymous_page().
-	 */
-	__folio_mark_uptodate(folio);
+	return __mfill_atomic_pte(state, ops);
+}
 
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       &folio->page, true, 0);
-	if (ret)
-		goto out_put;
+static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	return 0;
-out_put:
-	folio_put(folio);
-	return ret;
+	return __mfill_atomic_pte(state, ops);
 }
 
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
@@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	int ret;
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
-		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
-- 
2.51.0


