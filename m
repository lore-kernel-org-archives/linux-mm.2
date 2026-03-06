Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6BFFCC04A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8246D6B00B1; Fri,  6 Mar 2026 12:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806186B00B2; Fri,  6 Mar 2026 12:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711876B00B3; Fri,  6 Mar 2026 12:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60BE06B00B1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 113181C8F3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:06 +0000 (UTC)
X-FDA: 84516298692.25.BAFC195
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A6AC40018
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/BNV5xO";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4G0JivG69Rdw3mu8lHZ+By+FjyrWtYOEZ96ZPkiVhWw=;
	b=a3fOSX/3bTEVXa6MoORD1L6j1Ildq/colP9kWMff9znM96tNYjkhbAwbnRTauX3zIxDBZF
	/zUrBQPPmC9FWkABbTjqKjPs/7WPSU654XUEIshMINKuTSKUIgVIZbrRluG6kxUhZg+scJ
	184RMcoz5/CmgEVCM3IUkGfVyvIIwnY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/BNV5xO";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817544; a=rsa-sha256;
	cv=none;
	b=2w50TXAE2Serwq7sn8Gpo0NdXeMwVXRjU6fwltOOYjCurKcy4H11KmyBqZ9iXUM/3q0Ez1
	cPrGqIXpffFKzyPRGcV+o0RZfxf67AP+Gs1u+jxagMHh2/xCx1975d7/ItaAzABcyARvSh
	nofeipDlsRzWa2jhaVCzLfVmTlElS50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5214439AE;
	Fri,  6 Mar 2026 17:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC7EC19425;
	Fri,  6 Mar 2026 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817543;
	bh=KhFLfhIIhTESC6O2RDaPZDKOqdegXjeqD7hvwXb+zdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/BNV5xOySZe9AKNX1wOkj19WGVBZ/w7VUrNUpRUPaYN0KQTyarx88sHxhJkUKW/8
	 qD0XMYwEbQIRYEOw/eHp8h+dBHiedCpzvYwmViPZsUcCh36dZ1ZjcDGrCerpcEdYnO
	 AXsvyyfyU+rU/4f7LoZHuEdlWUVbgUqsTwh7XDJVw54FE9PL1bAWKeYrN+JhOz6TfJ
	 LG91bv+zMC7XU8/4RM5dqgSBzWGeFr80Bkm5bUqGSDK6/sRr4wabNWW8hLyMsuBe8y
	 kLTLsSveYxV9hSjv8pR9zDXlO7a6NqjUkkhwyKq1vHcsq55LqiMAE2oIV5z3K+dD7F
	 2uobBzL8OhZLA==
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
Subject: [PATCH v2 06/15] userfaultfd: move vma_can_userfault out of line
Date: Fri,  6 Mar 2026 19:18:06 +0200
Message-ID: <20260306171815.3160826-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A6AC40018
X-Stat-Signature: ebap5kqy1ezo7n5b4gfbh4ohg8z5rjeh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772817544-217372
X-HE-Meta: U2FsdGVkX18b4ndO3XH4Q6lJwppqCBYQvcFKAbv59nuZbhpB5NfHPfyohuUQnNf5wjPqECY+D21iTDqsw1ne4Ugx8A+HFQNGt8w1NxJbTa7aUBLw2iPLZEY/RQ/2dqrua4vx7RiRE2R6uLBycXD4xCatAXbADw0XqME+hTm9WMcvrxvjcgdFqgc0NiIsnJoU319ILWKcYFNOsD1a55GmneX9/PjX1au38IA7PVXOW0A6uED+3l3uTtzS9uthRC4q/Rjh+b1ftZnuwGVi/FzbxopGXtiQSRBYH1g66oYOGzOUmIkVHbE3rDjnJJNrVQ8n5J7PNTFu9bHHxCyXfKZn1ckwSch347xRAta1EXQs3AxQJbJeSQCKFyXDYJObqoGOB9uRVsOfrtVnE6zJ4PEe8kyyOsTKxGaA5X+hzFj+m8cKB4MqXA5C7dQ4saE6d5K6mCQyqW+sVJEbihGzInb6mAbyBEkCAU2X05AUAiX5y93/psEj4fVxhtdcpcJhwkPZPRLjIWMtdCpwkscLZJU5ypzwakfCSOpXT5saQbpgQosPIJM2rz37mz2BpJzazp1KD17hL6scdxDs/t6u+4F467rjQVHNp8ukzRvLOhVqytdHVoDuNzVKE7nvwTzt+5cjRmj9oV9LoNUSey8yNcMoGJB5rT0akuo4xhGy97tG82WFT+qog0l2/wVinZUrZv5CiF/Pciq4qhrrsyLej3ztDVF3hHEEeNcczSESjmjaE/bCgRzXyaeNqD6cxOchWDGzkwyoVo+5PC2bgqzagvAnsTJkLHw5J+ZrDuNzGgeAPaQb3EccdIww2t/VOmhnoG5LYGzyLV9zZFFU2hhLEs4eFAcSHm/Mkb7KEDQ3oRHftVtbg/QkSAZugYg4t4qfCBOrR+8CpmM4AqJis3xF16iBxQGIFqwSC3sXnn+E2jF+Wf8fKjdvQMYERO93PtFMDSkdsAuUhC95PpuuklU9TSK
 pQyq38zw
 5sEXJ5Xv6UfP9gLg=
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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 35 ++---------------------------------
 mm/userfaultfd.c              | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index fd5f42765497..a49cf750e803 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -208,39 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
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
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
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
index 828f252c720c..c5fd1e5c67b3 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2020,6 +2020,39 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
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
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
+		return false;
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
2.51.0


