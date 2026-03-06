Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F533FCC046
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A306B00A6; Fri,  6 Mar 2026 12:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4556B00B7; Fri,  6 Mar 2026 12:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3A86B00B9; Fri,  6 Mar 2026 12:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C963D6B00A6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 932A6BA5D1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:24 +0000 (UTC)
X-FDA: 84516299448.14.06009BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 00B182000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uG7uATZ5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+/JJD6szHlucDGmeEEd5/2gx+MQ+OLm1xs2AchaAjo=;
	b=RCuZkso1hpqcr0u5MpoI0nuXFurwB68PhagJJ+u+6//nrjeWOVxm9z1017Yv5fVEFt8Ryb
	0uJ+woWO7ua8qrS1XgThtLrBFAfnrUARAbSuE0v23qLuA7PQ5kS21SMcBcNY6sHEtINWyJ
	lAS4P0T3MrE9d5Gu04fb1efImvb8DME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817563; a=rsa-sha256;
	cv=none;
	b=oBT9zI5UL6WLgN/fNJLVWJf27E5mfN7pj8EyZcGjWCFQJu3Fx6jqKyH/XE23m5MEOwebMt
	1szT4BHGqLU4+W+3ojkvHvmKrahWJzkpAlfAmREFBPa2MB2l5+M4du7W29vroCvZMVyHuG
	T62RuD+r2kJtYlG6KwjunJtcvF9tx2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uG7uATZ5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E0F060053;
	Fri,  6 Mar 2026 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD11C4CEF7;
	Fri,  6 Mar 2026 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817562;
	bh=gidwe1JDFVRvjF4HHZQP+Up45bV0zxpQn7GX5nnMwuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG7uATZ5bBIgEOK0p125XokCc9P2sskQdk5BkZ/aYHwXO5FcYeCCVi370RwcFDozA
	 8ioSXRz1nLl7+49RynTI5/DazMkdsyku6wbfT5VRvIblvYeh2TVXUqLpKeNbbNHk5b
	 0hclBvWDAxLWj4uHKksnB+9SCahwhy7HXf0kT5qNxaeEPyHD3bYSwOtaAGVa1UisF4
	 s9sS2ZLiw++pf8MQE2EEub9QOqfl5Wd7BejU/H6PHnKpgpQZuVaZ+Aj3lKNMBfO/jw
	 F3dmC2FIaDhzjTqG3tnqz6poh5ppJoXRSn1Lnw/in8UNYZruk1QqlOt9QG4kRcXh+p
	 TOZ4kGajFXh1A==
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
Subject: [PATCH v2 09/15] userfaultfd: introduce vm_uffd_ops->alloc_folio()
Date: Fri,  6 Mar 2026 19:18:09 +0200
Message-ID: <20260306171815.3160826-10-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nks9rc4c5isoe8519ir1yu81sqasnrmy
X-Rspam-User: 
X-Rspamd-Queue-Id: 00B182000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772817562-844380
X-HE-Meta: U2FsdGVkX19JPaoZWO+EHGdMnT9591QrXzH0WwuadRzA6rZ4maWJqcRSQBUOZsBQUYQI0OK6J1s6y7qPAycbjrjTMLnMKWX4VnCcyvT96VkNjk7UAs0VYbpfDaBgTsgexRPJAfg3V2AOAMO59L4KB4XLBnu3zYKEWqJw4qR9V7y0YezthCrqI+V8SyqnLd37mdgi9jaBZ+48Q47nnE2vWxIES28ba+PczwZbHVCb4aufks9ZffxixENpfxcftyxHlKaNdYNfLiKGsfUjl2vH1iEcLycdaO4rMFh7tXuo7GCUvN2OFyh/Fk5EBAjRSzlQr/oa2ESywZhSN6VsDLRV/4sWSHvU4CA9nuTRESdTPX76O8QD9VQ6l8fkqyInFk6cThkLac5XqQgGC3sj8Jrxt/pa27PZqJqmk7A37QxYUqK+iatoo2BhWQJiL1YXn9a9V8OZIK36+i0gEGX75+7OrRSeexi5l+fvfFktrsUYQMYNrzxS5t1J6JZ8Vg67TkvAIHmjFo3CGlz3YZdBsGCCxmBGH4zVOkm72+Ag4eJ7w2uHdA4kitqEAZOBIpjFDC292uWQYMwTTGbKCZ25q3UCXiWTOkKLbHpIDc/o8jr5i3gKPibNJ87KU/TILXuLZTO2pG7hBKOEJFJbna4nH7/kXd/vmw22ZOYOPK45GVzJcPp8m2fo7T+1/A4S+1gJqzEPoJP6Wxf8TrhigXlHxVJu/I64BUmzAdaDwfkxXXDkzUTa2d4vA8sREaSzWlruhTQR3MHS12S/fAZNf0oz/ipY2ANis02U54SZpfogGmisKlztDKEOugNIgq+42uHrJ5iu4rxxcSAz1wTlhaozIt1+XfNh1yJ7wYob9/V+veSM4LZhsQryfFfSeCWgQJj+32SDbUl2RLh8XbV+CgPyXUSkmH0tfVr7shUVUAMq4LWDVsxdNtJsC0Lsha4/t/PXAMSMFGtdKOraA1y+jTKVmtu
 0UVu5o0l
 gb1QAtcO/W1vNsBXoGkuZPOHm2hjxJedn5lgVXaWUTIVn5KMAVzHDj7v5Lz9SDDjzN7PMziEhCO3CfiSv5C6btLKmKOTIxrn8w+DARMW/xCRHyx0DPbtgLydjvaD4OVqgBy+LkFufwqL+FwNxC0eGRVHMLLUar6kVXRnfIgCrnORTQv/bZq7XwIl+kFJJCbW5lY7hLdfRkiuwe80WrtzIwcfp2g61gHI0dXdeKxA6w/tKbGonUq/5XcRBbkr9dPKCds6l740S17g98IGBK0/EjezqUg==
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
index 98ade14eaa5b..31f3ab6a73e2 100644
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
@@ -458,7 +476,8 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	return 0;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
+static int __mfill_atomic_pte(struct mfill_state *state,
+			      const struct vm_uffd_ops *ops)
 {
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
@@ -466,16 +485,12 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
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
 		/*
 		 * Fallback to copy_from_user outside mmap_lock.
 		 * If retry is successful, mfill_copy_folio_locked() returns
@@ -483,9 +498,15 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 		 * If there was an error, we must mfill_put_vma() anyway and it
 		 * will take care of unlocking if needed.
 		 */
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
@@ -498,47 +519,30 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
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
@@ -551,7 +555,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	int ret;
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
-		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
-- 
2.51.0


