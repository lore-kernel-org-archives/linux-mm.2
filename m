Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10633606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DLHNpL8P
Received: by kanga.kvack.org (Postfix)
	id 8E8756B05B7; Wed, 11 Nov 2026 06:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899856B05B8; Wed, 11 Nov 2026 06:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762066B05B9; Wed, 11 Nov 2026 06:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53C886B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:31:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0EBAA0249
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:05 +0000 (UTC)
X-FDA: 85422621690.25.08C102A
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F9A716000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DLHNpL8P;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAKrZB3/nEAmJyFWyGs5ZFnmqEiXBaXUDR5gWbLNc64=;
	b=0yqR9ndb7+qLWz9RjmeEHDTDvH6M5kU+3fpal1MMS7/eWtNmVe6RaQauHJGqlOtK2B9RbE
	oWX+OQK5uMCdto/s7Dt2ib3KY+kl14IBTHq5798W9L29cPiD2rrQE+Hxa3mSjEz+2X8nl3
	Gdm5uhclDK3Oe+2BJp2xPD4WxszjjFw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DLHNpL8P;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396663;
	b=B0FrDz51i+OUZ6zTVPrWVnlkOW7wjMwUR12rljyqOq1vEv+cDJz2qxEwBDTA6s8MrSIFys
	DBWhppEA8V5IuMrU4adya70FvoMILaf5J9nh7RQgKkh7yUlyJ9k/NY9/b7UuoUQymfVFNz
	E8E4UVjHcpFKZB1YCNFRKZzjH0IOcIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794396663; x=1825932663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FAKrZB3/nEAmJyFWyGs5ZFnmqEiXBaXUDR5gWbLNc64=;
  b=DLHNpL8PUG4jDezvO7fMIJ+GJwFreN2szDxmDzGZsmdXhJN5pZt67lDm
   +pTiR5lb5x6SbWjrJrXCs78k7EFioSSg8uHdj7lL579/My2ylK29a5k52
   JF/wDlDIuaMISJXOfMZJKNeZWJSyJmp4CiFvYqZb/zeYm2GkqZ4oItyAf
   GUXUar0Tat/rCi+qhdVsAKN2C67MAApSw4kp5eWcH66yi7dfBJYWimppx
   CxFWcSr2hXylmsqd2Mk2DNDXf21Iqxe6UHKBzAxIG9xXGN6x7TeE5/lUZ
   TWKj97/YhmoK5gfwIIGEaolV725oQ0twnaTAxLAbQyt02FKytfQqWE5e5
   w==;
X-CSE-ConnectionGUID: fd9JRxnOQvyRoj4X60JWDQ==
X-CSE-MsgGUID: EgL3/TeyR02TNbdQfWGHBg==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33495673"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 11:30:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:20906]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 4ef01655-fd56-435f-8286-fd73de2bff4f; Wed, 11 Nov 2026 11:30:59 +0000 (UTC)
X-Farcaster-Flow-ID: 4ef01655-fd56-435f-8286-fd73de2bff4f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 11:30:59 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 11:30:56 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 3/4] mm/char-mem: implement huge_fault support for /dev/mem
Date: Wed, 11 Nov 2026 11:30:44 +0000
Message-ID: <20261111113045.35368-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111113045.35368-1-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F9A716000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5z3zafeudt8u8rwebuuz5it9stmnouj3
X-HE-Tag: 1794396663-700787
X-HE-Meta: U2FsdGVkX18SuaLEWJQXh1MerIlg5HhbkhPdxv5RQeLM+mNiA/+B3Mo/PF/HD85X3GrS2vNUnUkkd7LD83JHoyUw7P8wevjzl5pxX/bzOv3JRzyPb7OI6K5WBnGdJG7qwPZjoxMg9nuz8hwJ0FUiw/OJL18g5cChDncgSgdpSqHI5XTXPMRPZRdoYClR4W90m7ZR24w7ZBmaSDgYe8lqg6mBSsrm0kagbsUyax15+oEHvNNZTDmz2AucPYVKgPI+LgDM5geokMnHp6GBBPY0weq4bBfVsvZ4r9Ofowkfk3df5LMEaYfkqp7NRyNwPJBgUgtY+npwPhC2ZQhltjY2yhKAnrag+dcWsu2Oo+hAsV42kGhi7/D6rjvM/DhwRWXiMwyI5FQHER2R5r6rsVe4EGci+sViBghnbXTf/8epKw8bVSO3zUHnxHtYh8nS6c77Q1IrbvZeqi4202eG7ggPeJm4aMNH5oCO5+yyiCWnouAawtBYU6cAe/aYMXBf7RW1Owhd9xkk8d5NJSK4dATKosbqeWndzjTjFLDhSfXNbcyPnd9LCvT+3NjYGpT4iiklx4cl/WsGuJ1e2V0x8+RTk22nUVUhtIxduAAKn+9EFWgdVAyjCWKl+5NN69seCgSXcgajB86asejlASTGb3gx6pYGp8cebvIdyGmBm2Ezn0ETe19gPu8qAETgNJ7kWamEgTmSFccMfvunBIckSgGYs9Mxm9ky6MB94zBdtFH5lXI+0ziWJnzADfw5p0c/v+UY/TWnFCUJb7W0WnpS0dGclHvb2m+12M9hZR5CFKRNhiDbzVCnmSVjFKDBOCvtM+SHu+8FvjWi1QM/zyFHdmK/j1XSQIGv3xeOBsRdMXCgBgu4jJgJdLhPB4vC5s4x4RwlvrJVje6b75v5G8b9KQFZPwKfuPwkfHVp+7HnaEOtClO8rJMDRkHl5e+YHMVP0+Q/JqNIw8dz+P4BvHaHJi1
 q1cjzQtr
 9RGLZxkTU6v7hE/8PAO3d1MoV1lVFWdhDmwTqjtfv/7rbgyt+bKaJ1cXjeka2YQsqx8W4RTHvkwgjf73sbigOU44Sn65suY+aRDNZv133+UiJ1Bhr2K2PTVn1rC6PiMRksO3xHRZztkk3gH0DTNzrsBIL2TLtXVGvqhq7DJuoDktw/RVmQYWJq8CELaXhhh6+OOMFvux7g3+NiqWJ64ONcHwpAwXRgYJ/ZmnpRbICPwvYqyPg7qEEm9trO3GkIOZQgFil2DeYGYj3l89IBgM0ymaaWUbsL2MO8vwBLIa6pnwWUqVHSYXANWqfNJCCfTKfXUfRVsIfURoUkCY2t0VoQwjN8rHRl2AscQ3K899Bwubz0CHjxQqtfy8dr2KKug/TrFJ2GKJKU+UloOc19jl/E96zsAbMPbzHN5KCHjOoELUgRRQc9ezFGxKgjXqd+QsRCA724ueqjLguEsJBo1J/XBx3Jhg7T6hpyPKhXpB6I7skR00inUl4ngifIcc6k2U60m7zk1ozQ+P3hkvcfavpM42zsRteV5ysorCurdqi7xKqk79wNUMQPWUoKw721LnJq8p1WGdUcYqcBnGvqGr6zWK7dRHNdHB3o0xzm3rcl8I75g8CHEEvTMox+5tr6FiYX69KzadM6tPBq5L50ymhlwqvLiPjilVNx2EH2cUEAK2TN+5h9wQSra1ViDlF2vpTDOqLb/ayXgtBVZzdK7XTbfz7OwsgzHiljdvfyq+RFTmKVaXeerOApfpoTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/dev/mem is commonly used to map large physical regions (reserved
memory, device memory) into userspace. mmap_mem_prepare() maps the whole
range at mmap() time with 4K PTEs, however large and well aligned it is,
which costs many page-table entries and TLB misses.

Map non-COW mappings on fault instead, as vfio-pci does since commit
f9e54c3a2f5b ("vfio/pci: implement huge_fault support"): request
MMAP_PFN_TRACK rather than an eager remap, so the VMA is set up and its
memory type tracked as before, and add ->fault/->huge_fault handlers
that map the faulting window with vmf_insert_pfn_order(), using a PMD or
PUD where alignment allows. COW mappings cannot be populated by
vmf_insert_pfn*() and stay eager; if revoke_iomem() zaps them, the fault
handler refuses them with SIGBUS, as before.

The handler re-checks range_is_allowed(): with CONFIG_IO_STRICT_DEVMEM,
revoke_iomem() zaps a range once a driver claims it, and a fault must
not map it back in. With CONFIG_STRICT_DEVMEM this costs one
devmem_is_allowed() call per page of the faulting window.
Unlike the eager mapping, a revoke is not permanent: once the driver
releases the range, a fault repopulates the mapping, as a fresh mmap()
of it would.

generic_access_phys() only follows present PTEs, so .access now faults
the page in first; otherwise remote access (ptrace, /proc/pid/mem) to an
untouched page would fail. A mapping that does not permit the fault,
PROT_NONE for example, keeps that gap: fixup_user_fault() refuses it,
where the eager mapping left a present PTE.

Validation at mmap() time is unchanged, except for the L1TF pfn check:
the eager mapping rejected a disallowed pfn with -EAGAIN from mmap(),
where the fault handler now raises SIGBUS on first touch.

vmf_insert_pfn() refuses the zero pfn, where remap_pfn_range() mapped
it, so a page of RAM that happens to be the zero page now SIGBUSes.
That needs /dev/mem access to RAM, i.e. a kernel without
CONFIG_STRICT_DEVMEM.

Without huge PFN mappings, or for small or unaligned mappings, the
range is populated one page per fault, paid only for pages that are
actually touched.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 mm/char-mem.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 4 deletions(-)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index c5761ddedbd7..b9ed8473baeb 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -318,9 +318,92 @@ static inline int private_mapping_ok(struct vm_area_desc *desc)
 }
 #endif
 
+#ifdef CONFIG_MMU
+/*
+ * Populate /dev/mem mappings on fault, using a PMD or PUD mapping where the
+ * architecture, the fault address and the pfn allow it.
+ */
+static vm_fault_t mmap_mem_huge_fault(struct vm_fault *vmf, unsigned int order)
+{
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long pfn;
+
+	/*
+	 * COW mappings are mapped eagerly at mmap() time and only lose their
+	 * pages to revoke_iomem(); keep them unmapped, as without a fault
+	 * handler. vmf_insert_pfn*() would also BUG_ON them.
+	 */
+	if (vma_is_cow_mapping(vma))
+		return VM_FAULT_SIGBUS;
+
+	/*
+	 * vm_pgoff is the base pfn of the mapping. vmf_pfn_order_ok() ignores
+	 * pfn if the window starts below vm_start.
+	 */
+	pfn = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	if (!vmf_pfn_order_ok(vmf, pfn, order))
+		return VM_FAULT_FALLBACK;
+
+	/*
+	 * Access was checked at mmap() time, but with CONFIG_IO_STRICT_DEVMEM
+	 * revoke_iomem() zaps the mapping once a driver claims part of the
+	 * range. Re-check here so a revoked page is not faulted back in. Like
+	 * the mmap()-time check, it is not serialised against revoke_iomem(),
+	 * so a fault that passed it can still install a page revoked right
+	 * after.
+	 */
+	if (!range_is_allowed(pfn, PAGE_SIZE << order))
+		return order ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
+
+	return vmf_insert_pfn_order(vmf, pfn, order);
+}
+
+static vm_fault_t mmap_mem_fault(struct vm_fault *vmf)
+{
+	return mmap_mem_huge_fault(vmf, 0);
+}
+#endif /* CONFIG_MMU */
+
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+/*
+ * generic_access_phys() only follows present PTEs, and a lazily populated
+ * mapping has none for pages the target has not touched yet. Fault the page in
+ * first, so that remote access (ptrace, /proc/pid/mem) keeps working.
+ *
+ * fixup_user_fault() refuses a fault the vma does not permit, so an untouched
+ * page of a mapping without VM_READ stays unreadable, where the eager mapping
+ * left a present PTE.
+ */
+static int mmap_mem_access(struct vm_area_struct *vma, unsigned long addr,
+			   void *buf, int len, int write)
+{
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+
+	if (write)
+		fault_flags |= FAULT_FLAG_WRITE;
+
+	/*
+	 * COW mappings are populated at mmap() time, and a write fault would
+	 * copy the page instead. With unlocked == NULL, fixup_user_fault()
+	 * keeps the mmap lock held and the vma valid.
+	 */
+	if (!vma_is_cow_mapping(vma))
+		fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
+
+	return generic_access_phys(vma, addr, buf, len, write);
+}
+#endif
+
 static const struct vm_operations_struct mmap_mem_ops = {
+#ifdef CONFIG_MMU
+	.fault = mmap_mem_fault,
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = mmap_mem_huge_fault,
+#endif
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-	.access = generic_access_phys
+	.access = mmap_mem_access,
 #endif
 };
 
@@ -356,11 +439,23 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
 					       desc->page_prot);
 
 	desc->vm_ops = &mmap_mem_ops;
-
-	/* Remap-pfn-range will mark the range with the I/O flag. */
-	mmap_action_remap_full(desc, desc->pgoff);
 	desc->action.error_override = -EAGAIN;
 
+	if (vma_desc_is_cow_mapping(desc)) {
+		/*
+		 * vmf_insert_pfn*() cannot populate COW mappings: map them now.
+		 * Remap-pfn-range will mark the range with the I/O flag.
+		 */
+		mmap_action_remap_full(desc, desc->pgoff);
+		return 0;
+	}
+
+	/*
+	 * Populate on fault (see mmap_mem_huge_fault()). Tracking the PFN range
+	 * keeps its memory type reserved, for PAT conflict detection.
+	 */
+	mmap_action_pfn_track(desc, desc->pgoff);
+
 	return 0;
 }
 
-- 
2.47.3


