Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCDAD0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9E36B00AA; Tue, 25 Nov 2025 13:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42FC6B00B6; Tue, 25 Nov 2025 13:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A806B6B00B7; Tue, 25 Nov 2025 13:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 966C76B00AA
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:39:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28C26160396
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:10 +0000 (UTC)
X-FDA: 84149991660.13.94F901C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BE0FA000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+rjAQwX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095948; a=rsa-sha256;
	cv=none;
	b=ygZsM8N+zS1AE4LcG+3fGu6rumtfDKJb8f6Y8AXU65fratl4UWgCgLsnvo+Yx/YAMltAnI
	15U/Hm3a0wGF77byDToLoHrslZyAN/wP9mNu8SXgUGtHVtVY9u04ovSvGbmeq8kyAszt2/
	jXNpJykrUi1Ws7wyc0askI4/SCBWQnY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+rjAQwX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ws77kLN5WtsBEeQFN8jqfnnTDH3q/qyhmVOzeaEJjTc=;
	b=JRq9UX+ekKZva3AV3pfKgakjouzof1gEb1qPfoleY0IdtmWNq34ZWRhPib2zdhMNnXP+95
	IFPt2mKDOCDgTjGDrT8yV3f+rJHAmocqvlRSwXbq/NVje/upDK4hAHz4QTNBINE+iQN98S
	oOmjv9nGZryh/ji7fpopf48vGWXiRho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EA896013D;
	Tue, 25 Nov 2025 18:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E139DC19422;
	Tue, 25 Nov 2025 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095947;
	bh=OMs5feUckVCg3jntuqU22gZ/ufy0V9GaFPtJ4+nCsbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+rjAQwX+9oyD23In9ooJMuiZlgSjVe7F3a6uIEgz1GZ4RWJmAVwRq1A3GX0F11g8
	 WpbUvXAxGYRUz92F99Q31i/6oM4ExJUMNRmsybLKQme98QngVmtlLHeXJ8Td9Av+WA
	 lR1AWyV+or429S5CqW7LTi+L5VVrghZlv+Hv9eOyXNrWjN4+Jv6fllrLCy+6dK4hXc
	 J7LSRDv/TDGREvUaiVhFkFF6O5aSi9KW8pDWeVgykB4wU5N6LDOWfpObOmg2NG3s+h
	 4HxcYX0LT2C8ThnZbwWmQvS81JGFvtbFBrzs9A8Or9xTaLwr1yR1MLPG9UB8ZBlWMc
	 qhMk5fLNWc7mw==
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
Subject: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Date: Tue, 25 Nov 2025 20:38:38 +0200
Message-ID: <20251125183840.2368510-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125183840.2368510-1-rppt@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BE0FA000F
X-Stat-Signature: cj5cj4z8h1ramg9io7x6umhzsj13rug5
X-Rspam-User: 
X-HE-Tag: 1764095948-910269
X-HE-Meta: U2FsdGVkX19A3pp8Myud0OKinr3sDzRxOhofU9AS6lJPJLJQaGNOmCeqz7/5gxAequzy7QQJlCrpaPzatI9p4hu9Ul4Anq+Z7F7OV84C+tPsBedz6i+bYBBPpLi/P0Zf4F331BZ8bxIEZdkzwvbpSFisipQ1lqEyKdgsoSZXYVQ45gMMAEHGvi6td48lQFPZOkiTf3WK8tvU/lkDUhmfQExxj+4EEwZyI6pg6UcMVkOnEgZ1Bx3mIbMk4SzRqA/ekKzrfgH5/h7UzwLeEoNBqu96JKbRYF39QzK8y5DUB8m1oidlYEt3qL0AdrN706iQbPCee04229B3FI7tIJ/De3dj7eMVTehsU8Utm9pM2eVMXkg60aWgUdcfcuesnQ/mcbTMk2GpLtK5FqY/qlJq7iE17jqQRyaNW1eP9G2wsAux4edY9AlydAUBDXhnQvCiRTagrtdEsjGeXZPh0vazFGn7vKqdx8YaKojMHjgwVwyFJLBeDSwnNY4dRGAm+Pb/le4VCrGmreYdkzqLGI8ouiZnsy3Epe26wVdQYKooU3r56A2hv+u+r1pFE5XZvSzXPJtlGbxkfRO6D6FuPZsm+oljDINEX4OMPss3lNY0S4FtdOWQ4IMca4lkn4RPK1fqg8tqLdzFxW0RI9buCB1psD0Z7T1tmcs+HxOyot8t5IMhvdr/9GehgYzOE0h4gIwTdiim9tubw7FCb30PBt58AIyjwbxLPTD0MYbGSKdmMuL7Qk86UbADk9bVdaJYT09LHd3dy/9OjFGmjze+Pkkxeg4kRjDCdfJOjYDiV9sf6a3/IrshN5PCtBEExxKny+pgeL7sOwo4+fWLLMuoCgVco6/DFdsCs34OxZWLcBLg2Q8k288S7031WiuITPqmE8FCCAmp/HbzDqyDqjRQ6r/EI7JBD4dJR7xlhEvw/qHxf7O+L+jfi88u167SSzkgUiAU6un6ga5EJOvo5aTy3Q6
 wGpoZyEN
 CHNKxS+kxxp5OSQe0SjbrT7XFGWD7bikAFn2ronsUb8D1sdkIUPr/+rYjZPYfk+c5lknIqmzZaZ72Xy6W7FXBqpdAKvKfOy+Q/cTev6cpD9mwtWomBRmxWrTcreAwXQnAVRkdCUZoVmRE7gZZ6xCHnXVmdvcEy1/lDQp+8+/i8pNS9l7KLe3WNKMZbe7WfhNbqdMUFv8anpPOaIIFfuk2yUwYkHpbX8c0wccxwlt2Q/o2CMhU/YAtlUpMAIE7rrLo6y0zXcJ5WIHrY/VgZBKcJhu/KCigWtjVWfKxnV5UcaH36b4EpEtPVFOX57pj3sGHADYo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When a VMA is registered with userfaulfd in minor mode, its ->fault()
method should check if a folio exists in the page cache and if yes
->fault() should call handle_userfault(VM_UFFD_MISSING).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
new VM_FAULT_UFFD_MINOR there instead.

For configurations that don't enable CONFIG_USERFAULTFD,
VM_FAULT_UFFD_MINOR is set to 0.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 10 +++++++++-
 mm/memory.c              |  2 ++
 mm/shmem.c               |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..df71b057111b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1523,6 +1523,8 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
+ * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MINOR) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1540,6 +1542,11 @@ enum vm_fault_reason {
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+#ifdef CONFIG_USERFAULTFD
+	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
+#else
+	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
+#endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
@@ -1564,7 +1571,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
+	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" },	\
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..94acbac8cefb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	}
 
 	ret = vma->vm_ops->fault(vmf);
+	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
+		return handle_userfault(vmf, VM_UFFD_MINOR);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
 		return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index e16c7c8c3e1e..a9a31c0b5979 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2461,7 +2461,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		*fault_type = VM_FAULT_UFFD_MINOR;
 		return 0;
 	}
 
-- 
2.50.1


