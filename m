Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1623CCC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3196B00A7; Thu,  2 Apr 2026 00:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A206B00A9; Thu,  2 Apr 2026 00:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7A46B00AA; Thu,  2 Apr 2026 00:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D52D6B00A7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28B741A0408
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:31 +0000 (UTC)
X-FDA: 84612296622.25.D5A8B05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4DAC61C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ge0jvZgB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kVLa9bkdoOqQHYs0byU1qjm3B7ErtfKu+ZTKSii6VE=;
	b=ldJtz0EiB+HNKVBPzlk4CC6LH2R2I8zbL4ZzFEbu+6Aj5kSUdqyy0jtAsl3UGYKu7SofTE
	CQP5kljqsCTI7LauICKIiykjOufVelG3AJpn6bLhNQXePwEKweKc6CcVokf0duzTPrf1gb
	73s606NE0TslidDsIuFdkewuVVxcfJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103209; a=rsa-sha256;
	cv=none;
	b=AX1koTatHQ2d0jHYyjsBbnD/nDpN8NSXxHlnAWWjuGTqgOZ92Yb3356h/l4v77/icJQfnQ
	sP6Txs6PcSDPNcliMxGVCZ/XCtdSy9nblElO6ZjCFJ598yvBV9ZqinOvIThbSunotaXnTB
	1nT2jGM2FqDDleXPd8EOOX/7nsJY6Kg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ge0jvZgB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4375943A31;
	Thu,  2 Apr 2026 04:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6102C19423;
	Thu,  2 Apr 2026 04:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103208;
	bh=OBbhkJ8YK27hN9vtg3QQXqgXyuXTuw2IdpJE89KAMWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge0jvZgBcHS7QaHra70M9H/IHpYJ7VUA9VKvtPTYNwTO/xeQXcKnk3PAeYNSBHr2z
	 medpk7MIbsJYBNEskrIJ4bLwOMUpfLK3BTdB2vfr0iFRoyui9pgQEyMHQqfDg4cxtF
	 jRxm6GbtgmRifrhluyNeOpy91Kkpj94G2MdbcryqrzzWNfAFbaUbE5w6rXQANE86wM
	 6RbTCyAXJyF5kh1EFw9ZYwUegCDNKfg5/s4jBRwriyC03hVnT4NLg7G9Kby5PiDL/z
	 un6LWEMqYAE/T7GnGXKRT6B3WUAcI7kPvpwE+6rpUKMvRngKZ3lpyQlpmRaGnDnr2B
	 Y1C5iy4iwJA4w==
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
Subject: [PATCH v4 12/15] mm: generalize handling of userfaults in __do_fault()
Date: Thu,  2 Apr 2026 07:11:53 +0300
Message-ID: <20260402041156.1377214-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DAC61C0005
X-Stat-Signature: mmzh4rfjrses9qc3c419uq1ph4fw9scd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775103209-101164
X-HE-Meta: U2FsdGVkX1+9UWHluq14d47NkGsVAzpI0dVVMMD5pZLCUMGPXEFsHKF7H6SSlKIl66B8JXe4Q/CFrv8WnN26fEeulDOSDGZ7DsarLf2k7Gdj5tUJRFzBtaIA5ftD4FFCheD7ExoTfj41MK5CwEqSkQE1NeMOiJJu6IyxlB07ZiOiH4z4+3UF2RGZBoxVSbmOG8JhH5kX3wFgyjY4yPNcYId5aRTwGK1oA40nTVeJWiUcQUQFC9n/A9dg7mSRkrOOcOO91ywEBkcwNqG9Hs2CBXady7OFQhmR4+GVNPYnduElCCBIjzxI7I5AzF8nEcbbHDMbgbl7Z0cvJPZCdDEudda5+QP5tL584UXwpG2AAE/sZ1lYNjIzutS0AT3r1WLuenSUKYrkQNNzA4/w2JfHomLbI8QXxUUp6gWbVufYa/7ijv8PdqQdIpjlgRlHzpG8gbleybh5NR2O3Ov+trTm29TfyZXR6Qp0y9z8C9qH8O9tl3Vn3tMZhNreXisdc3wJQI7jNCCoP3xgFmmoOi97n911S+Y6V5qRul34qhtSapuZmDot4J/DVtiXD3b3Ct3eojR2z5Ik2tX1ubpPoWWbIH4NCEWUZY3FUPCwpk9KULMOa7L6xPfc8Rx+oHw+bgn96c37MjSzfzkWmCx3LYqvrH6puc8DT6rnPk/ohcaXKrppRZbDJsOzeuK/IQs6+Ok6MJmc7ozyEYIz1EcJrWaC3ZSnRSwsvxiZT+nikPEJXU5navHIySIB/KkrGrA2erkW+H7Es8r4VgELmU5VlPgkR+/2kwrdeF8NZf3a7BEV2U8a+O+VKjeXnsGPkEGV6rc8d1algBX1/gC0KDXwE0vMWDznDWnHhyZz/ifDU6p/teCX8ZLJAMG3gUvj+0FUJAWR+FUEsc1VNfTwZ2VFBAfA48k4l8zQImSzxIVKtvSZ/kNB07twHB26wJ1yPQNEfOUlPl4UsKG+yNSrBdOdIKj
 ktbIgnre
 1mHWk105hK2GkTpt2efo/qEyPzo/Xc7L52H/FHfmbvkRbGCbgTJdUBf4Mnoe5GBAVe1wYfw3DaRx0hQPIFCa6kdbjs+3djxIcttT1ksrIxdfKBmtq3A9+uksRc3WWwm6OuKZujBCM1fhWImFOL8xRn23Czm7dMXW+KmH5fvAeDWxK/Z/mU2CFfhRqZM+JDRZTzyA5/ky13Mn+7kx1tUHkHwDx0b7IffTjNK0gSLhbLW1JRRfWWHdFWrySE/doC7xxzPif17o4hMR8nLk9phAHWeC5QDZZHpPZgEBq6iSUJK3yPK6+wzVTgSvt62FzMNULQ+KEThhF+XZpsGm7iTUw1slqpQ==
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


