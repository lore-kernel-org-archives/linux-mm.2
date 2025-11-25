Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D43ED0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1C16B00B4; Tue, 25 Nov 2025 13:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9916B00B5; Tue, 25 Nov 2025 13:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFA86B00B6; Tue, 25 Nov 2025 13:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA9BF6B00B4
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:38:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51E8588CCF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:38:58 +0000 (UTC)
X-FDA: 84149991156.22.716DF41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99A0C80003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:38:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q61Gs1EA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095936; a=rsa-sha256;
	cv=none;
	b=yinfAAdgp+RliFTaWiChMObc3jWYJWTJJC2wEvh5em0Prelo1MKrfIy1ocl+YZUkBG7Cd0
	6ttjqlUeVj9Ek+OvOVHo3WLYa2OLgb0VP0HDsyFw713OpuEO7DqQx97ZlDevHq+PyHddBJ
	8wr91IkO9Jj3npdkDO+MXMwPJFm96Ug=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q61Gs1EA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VA0pvSz7aljo4H8EOhEeYnm1pxpxxtMILjlDV6dqzzY=;
	b=ehDO/h3TimG8pc+VduRhW1Vu6qNy85LN+gexSbPn/GVIl7y6fSf1VH07vHvA/o5OdEx/lE
	Izfm57tevndonF4ysXRjzc6DdV9wGlalfx+MI2A3hW6sUtcVV+BdcopymXMtesIRSlY2m9
	CsKLz/FKRd2l67a6MHPC06LfNz9r3IQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE8CE4405D;
	Tue, 25 Nov 2025 18:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2C6C116B1;
	Tue, 25 Nov 2025 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095935;
	bh=WZL3dOi9JF12AwW63UbE2JZ210f4aDb9qSF2OCoPSt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q61Gs1EAVRvIBvIG7INuS6659atLrZ3mrAdYqaIQP9T9mulZuDwUaEDa6KxihCImK
	 3zkNoVetvUYBLQHvkH6Su1aRjeR+rG2rIV3O+dtxWmXfj0fHqYVYAs7x42M4jxGJ41
	 xdgTe+RwZtde+woZwmlY+uxbGpHPIOMLmhDwpiBVgMD1uNiDoGD1w92TrbWuwztTl8
	 BdT8zFGja/53Y3N9tJEA+E6oz6xYc3j7rsiKEW+MGSxZbnmHTtUiooOaiJXwgtdJDN
	 P9dnSk8/p4aEkjeRj2n4YMQ4i7GWOclY/dcBy/rnHgtU5L3Ey8DoqRS6kitc+ohHGv
	 DOAFSCTnuI40A==
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
Subject: [PATCH v2 1/5] userfaultfd: move vma_can_userfault out of line
Date: Tue, 25 Nov 2025 20:38:36 +0200
Message-ID: <20251125183840.2368510-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125183840.2368510-1-rppt@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99A0C80003
X-Stat-Signature: 9qerm5hhrpkq8z156gjwg3trymoo1jhg
X-Rspam-User: 
X-HE-Tag: 1764095936-616298
X-HE-Meta: U2FsdGVkX1/dL3RU3gHXaI6dR0mw6Lyh5AIGBI4KbHPu3EuDDnVzLckT3IQ44Fk4y+A3QemDtn84znFCCk1HhsuINtniOP4fCOccA3flbngXfpiefyD35q6BQ0ffduZawlyuZ3eHX/FBH2WhWZe1K/5FDmJUF2zOrfnexMcwedp0VCuIsZ+W6WIpP9QxkaPFQk3E4fDvNzjAk1IIXcV37LsM9HMmBMDbkRtfhT59AhqMXdl0U7abeOK3y4IHOfzlXrraA1ro7B04pv+HXPoq3jzgkkImt6kESRDg68V8RJqA4px+8LYKJ1ylCmCDjAVnxzIeX5MzSVF+mNfHTOMUaFfj/H/y+YNITCMnjrtUjNKx2OYcfWfb29aKGtgkR+01xS4Leeu3N/+ZE1ysoHcTxyaICC4rvnyK7PDXGcWwJ35WPBFVvG3Q9fTE2QArR3BdxCrULzxyqLqEK6IIDaL0gFh0eDt0uGre2NmyhhQg2hYRrpm2dY7P+nhyKwXvQGVFMp48rtEm/dUNnpIGwIuLfsvkR1JBrA+49OWuxl+cPYkSyEmCYekSFaE4LXXzdxdNRSO4Zw2OOex3Ad4Q/Uru6bSz73xqvMYw43nkAIGFSqeomOZWt7uKRquvqQLT0sjR3yArm+fH1jcRddD829yb3PwjKt/T5yU643FC3lXtytthDyUqM9XUHvA06rElNZ0tGsv4U0U0KNfoNNzqKHVJY7120g4exqygPPkNrpPsglDtZ4yO9ZUn6OtbnbDF2ZBHcQ/lOaYNsb1iED3i0JHWN+TOjZU6/xIjfpBeSDR4QXfWSlZLIJdqQcTYZlJso6MHGMRO0FEVeAEvzTlsh7dQ2Ug4hwFKJnWptjj5jYAOwTR9UDphKhACirkOv60J2SjOtepMmScIktZHQWKKTb1RbA2zJlFY3/uf3rlrJ8sIDWhMKDAaGAJ8nyxXRxlRjooIiwfR9ZQLpLVcR5wqf0I
 WLCkjAXf
 ZE92hbRhNUDzQVoprhVDZ8N9iFWPyXrC5UChiWuM0xaO1fn0CAL4kNYPdJslkZhQfZpSZO1JO+Bwlgm4VHxxhE2RKwTe0JL/CdWp7r9W8naQyCXlhkpBkeli08Le2d7FoI7tzNgoeujGzRk8XaidzbomCG0qXOZXA6PDaz43nSRLUP0gL0/sVX0e6Xc3JaewX3FfSvnkGG7SrgJ8/OG43TIzuJvShsvfMjtEapk+YpR1dZQwSaCtF3yxeaPVLH5NYrmwT7WP8MX93SdQatRw0kxBzoAVJA9likdtUo2KaJQkFrcllwOcvlTYBIz401X3juO04
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

vma_can_userfault() has grown pretty big and it's not called on
performance critical path.

Move it out of line.

No functional changes.

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 36 ++---------------------------------
 mm/userfaultfd.c              | 34 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..e4f43e7b063f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -208,40 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
-{
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
-		return false;
-#endif
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
-}
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async);
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4..8dc964389b0d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1977,6 +1977,40 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
+
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+#ifndef CONFIG_PTE_MARKER_UFFD_WP
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+		return false;
+#endif
+
+	/* By default, allow any of anon|shmem|hugetlb */
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	    vma_is_shmem(vma);
+}
+
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 				     vm_flags_t vm_flags)
 {
-- 
2.50.1


