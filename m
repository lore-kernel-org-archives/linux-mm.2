Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4512D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2E16B00A7; Tue, 27 Jan 2026 14:31:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77E66B00A9; Tue, 27 Jan 2026 14:31:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97546B00AA; Tue, 27 Jan 2026 14:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C526E6B00A7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BD48C18A1
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:05 +0000 (UTC)
X-FDA: 84378736890.29.2D0DF9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F10A01A0011
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2UsiRPu;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNQNFWvrb8GbRlkZV4SG+Lijf3yLWl1JfogTIgexFRY=;
	b=6G/L2QG3+Qu9j3eJYjsHbrw8mFx5Cea/l6VZXhydjDqKwvHMXMr4hio3fBKoM6UQfjlSlU
	7IL8CDJOp84Tq+GsUe5Xep9nVCNfvD2raf1j3lzCNhBUb6zb3srlitxgmpJDieJbMFgMgL
	JwNLt1KNt0xmMQqM7625qCi/+cNSulc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2UsiRPu;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542264; a=rsa-sha256;
	cv=none;
	b=3phmYTFBhMm8EEdJ5BNnaoXIWHxn+f78XPnnYFSjsYBF/m7JCMyouVTO1YxfG4uu6Nol4R
	rtVAxI2IpttLzopIk19778ugBXnQXgBmpPf9ph0ypR0sPCM5p4PoIrQcS7mEick8RAYDBA
	aQgn4YSby0uTdD1EBrd3+te5tsWaDTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DB2160202;
	Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19B2C116C6;
	Tue, 27 Jan 2026 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542262;
	bh=h+TcgWCVPD30aK45h+wpUIJypZftXhAg5ucXDIazF9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2UsiRPuaj/8L0lU3PZimX+KdU+NnUJ4T6kgHnK7oKJ7dnF20S1Wu60dtz3r+KU1H
	 0T+7qAEjj3JbVgEGy3R0Hx3DRfjX2B6I9PzRs1e6vap8/WGmkswqz84raN0EuooQAV
	 5E4A1pVzNprdPWdgwAmWXAr69bCVgPHlBxziKewff7xctTxCeA2TMO1wQzD8XqEI6f
	 Ed4jSaIIhYNV6/OJpzSKzJ1lZMwUBOT5T1blV/qYiHyC03fgIpcZ1vmjVxxtXEnaon
	 0hSCYpfGeJVTvH9YpHOBZSgxib2aLHu9IQ7ZrqCo73Rgfq3eGnPiCbchrIFCt6eypg
	 1wteWBH/FqJkQ==
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
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH RFC 12/17] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Date: Tue, 27 Jan 2026 21:29:31 +0200
Message-ID: <20260127192936.1250096-13-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9zw8ceykiu6iby6owhc1i4mfdpjad9fp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F10A01A0011
X-HE-Tag: 1769542263-255873
X-HE-Meta: U2FsdGVkX18kMVOawY0qugQFRICEo3WVQLK4O3svO4FTeS2Qjcz9E2tzpGX1b4VCapZqFdeK4M8baheheloy54RiYwBX8i1HUN0uRiToIBFY8wBwT8WH8K6bDEEAq+HCi0PYRO7oq03fjFI9sE0fhgy6s2p0H1SCyi0ICdU8oWtfOWn6INdV5Jl+7ThMEJJLx1bUQ33rStbUCSwim3kzM7Emx4Tf4dWKEqUEMA2N2em5d9IHVD1g6zxw1yop6xzfbDcTL9A1Ux9sntz86fpR8GPg12+rAbHFKdZKhc89Zqp3Cfn4uGbqzyymitD1Q+jdBT5+yWGegE840BrsvwW+AvvIRhAVX57i24pUHPWwXtTocMF2itKnJhmmj3dPYz2HKkK+3Th8/8VXLBT1ADyG9zIMhW1NACJDg9QSivkrc4gQhyydNIaXWegMn3W/t7u6sUCU5KUriWb+QDqswQoKlcuEmjiW4CyrXLwHU0Os34N2+3iLytkDyH/9hU1IyGDL5K1jAEyOScDXynD3Q/SXoCL12/R6HHkS2fwVJal7gRruIzGYLitVi92tb8arhht+tKmXOwhnlkdeTM2Pub27OphWEpROwObeC083QWWOpjGQ63YmEhgFrkhgfcfxdvG8cPePoYgjH8HUT6kF0uW4FwqAqnU4L1fhhq1DJu4lQXQnO0H+fETCHzu7LbpHDpTbLwnxMpuAV4wcAjDXhUQnAwSYpfMTvWed2l2CdeLqw9I9YCN8iOPTewoMZeyw1OVBiTZvCUBGwJe1+rDhnXQlhEcGroZlgNEHzazDF+PF8LiUQDdiR14B79uNlhxYvN+2qcKiUD3ujn+6GetUlLG97GEqe36ezdhTsJ4PLtxj2OzAmlf6Wyhj09ecLX0AT4S5KU3otc3SIQCXtHicPIcskKVgd1l2eyIm0fwYh9kPU/d7vegicg5xiykn/E18NL6C0jqdrkJqOUPSNMAgbtr
 xrLSMNRc
 6ICWGcVgDXfI73SVRz479BEA314I40HjP1j0H3MV72LeS069p7zP9mriC6alFf27WlEYZGU1FC58E8j81mgBr0bFPrcF3PSxuhWZ31Qd673B8a/EWel46seHACtV+hKPpLGlBY+FzYvywJSShkdN7MvlSDBIrstooNXU6UH1yHwpUbqP26GmTqK8236Cs1n5DRUHzNEIXPASwwPciqz//jVO8CXFWglm+iw/M64RMvZ8eI4NCfsyYQSyiF9M6A6fiVvFcFQ2RlNFnrnfsclXADWS7fIvyuVlxlQWdtu3NwxrsSAkmhjXvJrIGv1LpzOLrWfwgnBSnbzEeyMl2pxcXsovedw==
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
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 10 +++++++++-
 mm/memory.c              |  5 ++++-
 mm/shmem.c               |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 42af2292951d..b25ac322bfbf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1555,6 +1555,8 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
+ * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MINOR) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1572,6 +1574,11 @@ enum vm_fault_reason {
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
 
@@ -1596,7 +1603,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
+	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..fcb3e0c3113e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5319,8 +5319,11 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 
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
index 6f0485f76cb8..6aa905147c0c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2481,7 +2481,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		*fault_type = VM_FAULT_UFFD_MINOR;
 		return 0;
 	}
 
-- 
2.51.0


