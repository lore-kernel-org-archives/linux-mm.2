Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C455FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B4A6B00AC; Mon, 30 Mar 2026 06:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5486B00AE; Mon, 30 Mar 2026 06:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3FF6B00AF; Mon, 30 Mar 2026 06:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48B2C6B00AC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E752513BB0B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:49 +0000 (UTC)
X-FDA: 84602315658.10.1376535
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CE9F180002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgyyW8q8;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kVLa9bkdoOqQHYs0byU1qjm3B7ErtfKu+ZTKSii6VE=;
	b=eevFoYgrXV/2x36E1iDQsi97J8MsLpepWblzVCs0o/Qrn0KSYjvz61tyr5V0GAgsd1tkBg
	Wo9uDPnhX6ddMkcmbC55xtiKDwPQXP+5dBTJt15hc43lDj2VSVEAH5P+k454cjiXI3goDa
	WDWeDzMzAr19c9ymUSpHQSFrts/4vuQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgyyW8q8;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865568; a=rsa-sha256;
	cv=none;
	b=gs+AUN4gJSKG/JjVcVvAhIaCMK+2DSeoe6oacgmWDHWn3hhwyMKXyOodVS239/y3S8IiHZ
	2w9WCF8XK5eFooZJG2qS1PGU27r7XelXjDv7sfMJE2iomA1Hfoh5T2+C2ZzGYltaf+GpLb
	9e8Qm/va1HZijFWddHkmjlSAT//jM9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE151600CB;
	Mon, 30 Mar 2026 10:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5F6C4CEF7;
	Mon, 30 Mar 2026 10:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865567;
	bh=OBbhkJ8YK27hN9vtg3QQXqgXyuXTuw2IdpJE89KAMWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgyyW8q8iYNIvZzvOQWoy03Lk7pJYY5Q3wOADiHx+O/Cemi7Y4kfbemX9edKP+Ipn
	 SYJmjqhLXwWRpxKtGf8hWgXRI2CsPYArsol3/ezvJcWpv3Ql27Nddo827jppV5PNLa
	 WHWG44EhUI/PgzreVTi/vguFrEesMAyqg6/oEqTwuMLQ2fykrIT1Yw13pSeBHDPJIt
	 sKJf4ah6p9X9s/ypsiSK+oa4nQW+iKKa1L1vfd891+vuzaVF2CT7VNaE/PiMKdkrvm
	 hg+f9cwpSE8m9qDQWFSiQOzSN5skxuMOkUyE1rhucWBqDyTFlRhBYkqDNIcVGulYCJ
	 KumxlfCmzJ/5Q==
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
Subject: [PATCH v3 12/15] mm: generalize handling of userfaults in __do_fault()
Date: Mon, 30 Mar 2026 13:11:13 +0300
Message-ID: <20260330101116.1117699-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7CE9F180002
X-Stat-Signature: k78xde3xo1e7bpb7jincnsjag6t4uoeu
X-Rspam-User: 
X-HE-Tag: 1774865568-411404
X-HE-Meta: U2FsdGVkX1+sFYh8A9rwaOxU6Gg7g2KvkBWwVGulTzoeEJFJfSyotcJ4mDkGPX7S4nKQPZ0/CFqZ3HNQ1vpybg7AP7wFSrt2BExwU24nKyhneMqpTS7PMg4vfsYrpkzwzU1vAr1JqAWkws0trVcZQd9RnK9MNLbZI42ztQVW2GzRcuP2u6rWGUO+b1soZi3bHgoNGASHo8VGtRduqPRSEqz0O+UAw+YqcxTjyTped+b5z6GYJMgosLBXRcDIf1HOEOCVouCOIxxQo21Y8riUCAfkEqXzSwvyll1YKjxihCA9m6xbAQIjp2OA+EA/klrcD8GwtYEuWnb1K0xxF1y9LxoSkZPWaEH/+PacX0K+k3myFN2jz+7JVW48HmvVz6S18bBh1H1N/FAitE5RDDCmTpAmCK+XYd0nbyH/5ZLO+R6qrbdTV+Ein8BH492gkhDoWQHu7VRaB199WBMV6Kfh45owUXSTlyS/EpdTN5al4I6OM53cxqEZm6+psz9P0sx59Knpwd3WnFnI4dMuUn5ReZdHpKH02RgZDh5FjKpd4rmazguVQRz7kFYPb73s4kaSZADU/9pxMWsArzFFjAA3TlHzfqhYGQLoMT/faCisCw2D3zY0TD/JcXEKkvmK+n296zypJeJ1mFkMntxSrR7miP0uhuUD6yptP6hbeSquVJVO0Wk0FRchCXTEzD2URetTZz/ZR0xM9qg6h4ZIfSMeEC9yaeSvoAv6T+wwscjdjZZsnPfgR+AUvI8SZT+3VYYzLxIoxq5d6ssdyeTCKh8SjHJGFCg64HUxySNkeLI3bFLI+gTmi6J3125LV0NA1MpGgTaYfSJkLp65G/em2wqYtuYeZJVQP6p0gt2ivrwznYf5wzLeNpE6quYKbJG5hxnixKWL4jcj56uNYTBm/7WpeAY2ohBi6oKjZOr0OeEtHCNtQfgBFfyh8LHp0FMxtvKl8wr5rMBLM9DGVuJ5XIa
 ubXcqhqg
 fjA/kC/LYBWrbuOmfPs990Ot556VIOjjRCNG4DMgsNDpDgBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peter Xu <peterx@redhat.com>

When a VMA is registered with userfaulfd, its ->fault() method should
check if a folio exists in the page cache and call handle_userfault() with
appropriate mode:

- VM_UFFD_MINOR if VMA is registered in minor mode and the folio exists
- VM_UFFD_MISSING if VMA is registered in missing mode and the folio
  does not exist

Instead of calling handle_userfault() directly from a specific ->fault()
handler, call __do_userfault() helper from the generic __do_fault().

For VMAs registered with userfaultfd the new __do_userfault() helper will
check if the folio is found in the page cache using
vm_uffd_ops->get_folio_noalloc() and call handle_userfault() with the
appropriate mode.

Make vm_uffd_ops->get_folio_noalloc() required method for non-anonymous
VMAs mapped at PTE level.

Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c       | 12 ------------
 mm/userfaultfd.c |  9 +++++++++
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d924..79c5328b26e3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5329,6 +5329,41 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode;
+	struct folio *folio;
+
+	if (!(userfaultfd_missing(vma) || userfaultfd_minor(vma)))
+		return 0;
+
+	inode = file_inode(vma->vm_file);
+	folio = vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
+	if (!IS_ERR_OR_NULL(folio)) {
+		/*
+		 * TODO: provide a flag for get_folio_noalloc() to avoid
+		 * locking (or even the extra reference?)
+		 */
+		folio_unlock(folio);
+		folio_put(folio);
+		if (userfaultfd_minor(vma))
+			return handle_userfault(vmf, VM_UFFD_MINOR);
+	} else {
+		if (userfaultfd_missing(vma))
+			return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
+
+	return 0;
+}
+#else
+static inline vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	return 0;
+}
+#endif
+
 /*
  * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
@@ -5361,6 +5396,14 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * If this is a userfault trap, process it in advance before
+	 * triggering the genuine fault handler.
+	 */
+	ret = __do_userfault(vmf);
+	if (ret)
+		return ret;
+
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
diff --git a/mm/shmem.c b/mm/shmem.c
index 68620caaf75f..239545352cd2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2489,13 +2489,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio))
-			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
-		return 0;
-	}
-
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
 					   sgp, gfp, vma, fault_type);
@@ -2540,11 +2533,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
-	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
-		return 0;
-	}
-
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
 	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
 	if (orders > 0) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 935a3f6ebeed..9ba6ec8c0781 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2046,6 +2046,15 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	    !vma_is_anonymous(vma))
 		return false;
 
+	/*
+	 * File backed VMAs (except HugeTLB) must implement
+	 * ops->get_folio_noalloc() because it's required by __do_userfault()
+	 * in page fault handling.
+	 */
+	if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
+	    !ops->get_folio_noalloc)
+		return false;
+
 	return ops->can_userfault(vma, vm_flags);
 }
 
-- 
2.53.0


