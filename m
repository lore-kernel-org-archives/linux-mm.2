Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A77D116F6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823576B0011; Sun, 30 Nov 2025 06:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACA06B0012; Sun, 30 Nov 2025 06:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E1F6B0022; Sun, 30 Nov 2025 06:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE356B0011
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:18:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E58C3132541
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:40 +0000 (UTC)
X-FDA: 84167025600.29.1B03EEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3577614000F
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTEOZ3Eu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501519; a=rsa-sha256;
	cv=none;
	b=BBczRQyaIJpBiLQHA0Grg9Y1yb0Xl0T8OYKB1T3SJq8D3K2aKRzAiiAQeM0nOwmbWSrphq
	bC7CTe5BiOTtpHvqB/rdRi0QRqMO2V+UxzzM7IBQTxAAsPKAyunWUuW2nX3PCB37S54jVo
	noZANV5E9uaAEhWXe+vmL+IxzEIKYlo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTEOZ3Eu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luA8w64UTnP7jsE/Fp6ukORsax4OgFVbVD1J93HbfUs=;
	b=lUIiBU8m652DIdg+v6aY6bMotCCR4PuE8HDSL/v54Q0YIoAdtyX5mKdD9DcOA5Sj8AH/TB
	4CoWXm0jUCnQtrbsnZm7Hzyt9y7OtRVT7iUlN32bvmT85ja4133XiDVMa3HZNV8edm3kTu
	NaY7vAQx1OEOiHAueqU3oBhG45nDelM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B99442E17;
	Sun, 30 Nov 2025 11:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FF8C4CEF8;
	Sun, 30 Nov 2025 11:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764501518;
	bh=kn1TtLxUvl6eK2HP+wAu3G67BEAmX/GRyBo9yQ844/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTEOZ3Eu7EhOOpw0QceVSQ+bNm50XMZUIp8tcd4Zgvs0pWvWMI60KTlM1/2qOsjs8
	 0QNc7mcCdeh+ZYHJdpxS3KVSQ/SnooeWvfX+xjVwFwOh4Ayxh+9nNH2/z4SVTQ2tru
	 XyufTc0QVGWP4mrQ1s+rWBm3P5+VvAxusEBYIHg43KX0tY4wWgDncOlh2ocwiBSqYe
	 Gj8ZzBLL92wwmYW1GSIbx7rQtkZp+Ed1rAhaF7XuAsqylo7q5xqWa9fqzLfpNrRXho
	 f84MYsqTzz/pbvZL+4dlHYdlYCUFxPVyZXIS9nNk422W47CGVnoXf9AyAZRUfhrIhP
	 +UKoQejLcsRGg==
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
Subject: [PATCH v3 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Date: Sun, 30 Nov 2025 13:18:10 +0200
Message-ID: <20251130111812.699259-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251130111812.699259-1-rppt@kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3577614000F
X-Stat-Signature: z36me7c6tseej8ysswah66o5cjowac6d
X-Rspam-User: 
X-HE-Tag: 1764501519-536308
X-HE-Meta: U2FsdGVkX1+/refFHCzDDakCJM8eQW2PNfBfShfKyzwaK50AB1JtmuHZn5t1rkvrtBne9cChjP2dafOKG8VmFnMAtr+RIw9WrQTW66hnruv7QzW9+LhnDZ+FJcu2uSebPHNM16lRZfG1gGe5Z0LVJ7S6vrbBpVGI5RzOjCfmFvC5UtXgo45U085H4TOYjKGJihFTWrbWWPUf5+Yayl4l76689ZnZ3wXeym13YReenaH1j4CnwS3XFaF9CPERpcGbrCctjFBhnUZEIvme3qqye5cRxETNckgPiulTJBsV3Kq4lM33trWm45URhJNa3wJJzu/Qe4HntDLUbOfrQmq9jarH3up7ZdmVrkofw1tcVABe1K6caFXbbX5Wg5xPr4qShN4MZbo37ODgfh24Lf7VCQULOR5qTKP8n9UyHifLWci4v58QQVCvHdAnqk7ty/bl32NzJ8uKRsfQ8ABM27yD3S1C3dOkTYv+h6dRUS5NwrFvzxU2zcrX/TexhDdUa2Oxa+Wq8U3zRBrYzxRiM0IPfJk8bTYNYy2uPSLrLD6nT2O6BwQ95OvSoO8U8mWNLaSHL1jXzHAIy2rMMqcFkiMz8YglPiOT0QiSp9SoCMSsGAV0wYgDt7ywHCscNvT33ILx6Ms8+IktJ0+QHHmMM5jNwCpkL9BDcD//S9tos1AYeUPSf/HO3Fp2kAA+abLpNxiNLD6AfGIoh4BVc6eXSJD/KQ8B8dh8x9PCTdLvZQmUkzmWUKfUxaMBQEPRsyrKm+pfdK1wohjSfZkvzaQcpFXNTGZyP72ZJUE187ewbszKU40dYCwwtZoCs08gtUFZW8f8jduTnk2tX6fdoYkE7+LUCMHNBb4a2CpuhcCkZfG4byhre/5/UqBWaa8mcqBuATOfHKqRVV2oeYktzH6E0DTSo/+kWrnxH5XOusUfA8zT9e8qRo4wFCHYSmqGclPVRApDf5UOXuE6K2VU++O7Y2F
 nLoWxY+F
 26L7lLHUDV3nfW7SLYeGNMZNIpeCkZqwmaenCDmvW25Ta5RLQdtcvoMve5ccmTXSroD9TCu7toqdz3t2pudpQoeRm9MB0KnPF7SweNNvA6jYTfx0DaCE1WC0MgGabEq+MjUULXrAuBGsSRWAfrob41eSwfBPIkDC6K6Sbaw35OhE9eGJjnJNA1dXEZtfe42bPvBSMLhJd3DOhY4+V1h+3m98E1C/hj7zkDYowZLcRfHtlYbG883OYWCFRbwT5G3Py9+6X71JB7uEfXvnBMma7/Av45v78IDMHDdf9WAJgNGUoLxUXNLlktqHsXk8DSXoaGxTX
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
->fault() should call handle_userfault(VM_UFFD_MINOR).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MINOR) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MINOR) in shmem and use the
new VM_FAULT_UFFD_MINOR there instead.

For configurations that don't enable CONFIG_USERFAULTFD,
VM_FAULT_UFFD_MINOR is set to 0.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 10 +++++++++-
 mm/memory.c              |  5 ++++-
 mm/shmem.c               |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..c92a52c572c3 100644
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
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }	\
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..8d2180ec6933 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5280,8 +5280,11 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW)))
+			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
+		if (ret & VM_FAULT_UFFD_MINOR)
+			return handle_userfault(vmf, VM_UFFD_MINOR);
 		return ret;
+	}
 
 	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
diff --git a/mm/shmem.c b/mm/shmem.c
index 9f8c54ad0e32..2c32e2398e99 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2460,7 +2460,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		*fault_type = VM_FAULT_UFFD_MINOR;
 		return 0;
 	}
 
-- 
2.51.0


