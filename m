Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C1E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZxSMeh47
Received: by kanga.kvack.org (Postfix)
	id 36A736B05B6; Wed, 11 Nov 2026 06:31:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDBD6B05B7; Wed, 11 Nov 2026 06:31:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E33B6B05B8; Wed, 11 Nov 2026 06:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECF296B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:31:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8685412027F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:04 +0000 (UTC)
X-FDA: 85422621648.25.3F4FC50
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4E4E640005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZxSMeh47;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396662;
	b=Nai6y1wDWTjzLeYwzUTyj11QZEDL13eDcz3KFrEJBbIsWjhRXyDV05zvHQkU+GdxDeLkOK
	ylPrWaPaMW1j+Tjt7nS89T5wsLBpbMoLFSYAstx/iEVPWHAxF4zqtSPG34aEkwaNaV9QiD
	UM4odWaDkwCftMWYrjUR+gNwl+74mYY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZxSMeh47;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX6eALrtU03nkowWrLRijmxpjqh1OdeIRAColfbvybg=;
	b=TOauGdyuNgyoyT8tdyns3OecWtKrOBu9LieGpZNvJDZMsKLPoojJxvFucwR00q/r19Mc77
	Gpq07SgA0GqV2kuXO3LHds8YGYWRnAJth+9Ci9cz4Ujp+Ol786RhwMyNdfo8WM2NLkY5df
	hinMC7LEXb0uEYh6sg+W0ZEmwTmaLwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794396662; x=1825932662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sX6eALrtU03nkowWrLRijmxpjqh1OdeIRAColfbvybg=;
  b=ZxSMeh47t9cTmKy+IcnBWpFjU52CyZfVHX9If1DYjOXwTl4A1XV6+f5s
   q7qIniRmRtHydVtke/qNwQVYbaS2+N4Mmi/R7NV0sZCPZUOWMo7BG7VSb
   qyc2yrFEPKwClcPLKgbTWxUDs4KVhzt8mla/wP9dKqbm8k8JWmbNDyMeX
   OzteZobM1M1sN6T26hM9oHvNua1QjAlFA5WQkoRDoVp+JRXlCTPxsMGoX
   VuxqGUYCDweIZFmS+oUwoMG/2x3f9zdtyWxH3HJP5DksUk/kbdbMc8abq
   JanmMknHL3fFvi/E/zsKJBQJM0yc7iol7jlfuSymI6vfGjqWAQK6UylH3
   w==;
X-CSE-ConnectionGUID: BmL0ADR6TV+zsT/8Lm7iXA==
X-CSE-MsgGUID: XwLUbCzCQeiOQ+ztd+vJPg==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33704167"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 11:31:01 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:5402]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 3ece8912-201c-47b5-8fdf-dff386e184c8; Wed, 11 Nov 2026 11:31:01 +0000 (UTC)
X-Farcaster-Flow-ID: 3ece8912-201c-47b5-8fdf-dff386e184c8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 11:31:01 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 11:30:59 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 4/4] uio: implement huge_fault support for physical mappings
Date: Wed, 11 Nov 2026 11:30:45 +0000
Message-ID: <20261111113045.35368-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111113045.35368-1-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: bumomt7xexbuqhzjgy9cancy9ykazs9g
X-Rspamd-Queue-Id: 4E4E640005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794396662-590735
X-HE-Meta: U2FsdGVkX19Tnb6g4aA0KjU20GUIWpkEpN9N+15oDgHlq9GZKI0ZRa5atOtmhJLTRs2JyqwHWp0ZVxHIENiv0wUq4raQVjC6NyNIv3sBsBuG2wOlSWLoNlmenVWTZvn6lfpdG/N+D742quQ4fdhuO7Jk0mtpfGDfvD1phaNMGC+EsHe7KfS+Nop0raohHi5e45cI8TbKXCZ8tzBxr3wNBu16h0iUKP2Pe0uCx4JZuwbCEKQXeVzTr9vdaoj2B1kBtrg8JgYp/ysccK9QcJKE+BVUR3+OzeFYXjvV0ozhWNhhQOsQ/oc1F6d31HffiEJISlgwtlbXzNqHFWBHXz/ga06H4/fN3BKXVSCRxgoerwbp9TrOFzJxCv6XSdzsBgXtUPifM/kZm1gq2bhg8awXBzDgA3doPnZ+lutQhW/VdtKI8TslrhY+Ap5Ox5obhE5MLz0HMBJFoQKpq9mKn5eFFMS/90rUnaez9uExMYc4IqOAJXlhkYynRgueCNJMUMe5XXedwri7aLNu6CoBsi3B0DlAHYqVqjlFCPESDaF9YzKoCA7Fyr4jPJjuAFpzO8w4d5qbb4OfUf+hpz1/clLtyz8RQ95NDRTYAF+4UcWDmPqzfnFc04EoBdXWFKnKCDaxCSLluX/0rvxxJh556ljgJJXXMRkH7jNi90BKwQmqNi5LG6vB02DUB7iUGksHfwIzzAC4XENTp2qMTDvxj2lLGt71JThBJnlPjKcWEgDq6trzz0Gmm96g4dbNL8mVqdItrXzb94cSMAheXOtzbL+xHIACPdD75x8Ru8tI+/4YB5PxzicJ8COXOrmp4DPTTiVaH3rQ7nacyCdNiSDpFK8GeckkZapADRvY3tq+4+uiE+nBbHdSYTrIk2Oi8j8Q7l4LLWYNQv1KlVwn9eguWcWlUndX2u1n8RCFOYmAJz7sD8T1iK2BtlfMNR+FOEwm+afGSe3eyJ5AyIix1bnPIYm
 ms/F77oj
 o85yfZoEQPo8mZUTKMWMygz8O9YMsqCGKYUQ5AXe1SV0rnxTXKndKMaywyFEQsvPXJbdT2TLgP1p8t0R1qBZftr7wVZUvqJEPx5OON2U5eMUblSFtSMAobq4qiwzDbsZJEZkumRQyYEnwkYpKWJ8Rjm3E0go5tkmWbkI7iU0eF9TPUQ8aXlugK5eh+2fmmD3iAfMt9MR8ntew0SnMAmawU6WtrVaC0LIsXI7xVAcg4sMIDcLwFr11sOwa13laIuknEoIrcgfD+61yKUaFYckXHHPfokQaksAsA+kwrJlfWAXQ04KH7Iuc7OFscFoa24i0msQ6z7vFb0buyZ6pTapLlQv0mQOl0g+dI3ukefZwUKUI4jxu7jib/FmusH9oHg+QUrEmXEy6RR40eggUJ33g254x/RU2sdmKDNEsTof0TfsDNxLIoP+L1nRdWaXzPvozwJlkAwDi3ks5TQG87bj3hgMdPXvsKd5abaxw9kZllQzo07A8Hh3makSaFzK1ANJ3R7dy6nrXbhs2olCMpBPGGYVMm2VeBFD6YP0R8H9fhU8TFYNP69abZ4BuXAn/VYK3ffGOZD7HKGOs3TNtFQ2PmbB66f2tlmFliCK1IVTJwX9vqfRZEORyQVkdUK45fZZrj6lL36OEb4ZaQMZYAcKJbKFSj0DP+4Qk67r/W4RrWX3kH4OFn0Fh9PPbEXehPonRfMdxC1KalWiqcsFyimQsCRIMNNz5I42La6YhvuZ5sHYFnE1QIBEUhS4cfURZjO+d0JwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UIO physical mappings (UIO_MEM_PHYS, UIO_MEM_IOVA) often expose large
device memory regions to userspace. uio_mmap_physical() maps them at
mmap() time with remap_pfn_range(), i.e. with 4K PTEs, even when the
region and the user address are aligned for huge mappings.

Map non-COW mappings on fault instead, as vfio-pci does since commit
f9e54c3a2f5b ("vfio/pci: implement huge_fault support"): call
pfn_range_track() rather than remap_pfn_range(), so the VMA is set up
and its memory type tracked as before, and add ->fault/->huge_fault
handlers that map the faulting window with vmf_insert_pfn_order(), using
a PMD or PUD where alignment allows. Like uio_vma_fault(), the handlers
take idev->info_lock and fail with SIGBUS once the device is gone. COW
mappings cannot be populated by vmf_insert_pfn*() and stay eager.

vm_pgoff holds the UIO map index, which a fault handler cannot use: a
VMA split (partial munmap(), mprotect(), ...) adds the split offset to
vm_pgoff of the upper part, so the index no longer identifies the map.
Store the base pfn in vm_pgoff instead, as remap_pfn_range() does for
COW mappings; splits then keep it correct. As a side effect,
/proc/<pid>/maps shows the physical address as the offset of such a
mapping, rather than N * PAGE_SIZE.

generic_access_phys() only follows present PTEs, so .access now faults
the page in first; otherwise remote access (ptrace, /proc/pid/mem) to an
untouched page would fail. A mapping that does not permit the fault,
PROT_NONE for example, keeps that gap: fixup_user_fault() refuses it,
where the eager mapping left a present PTE.

Validation at mmap() time is unchanged, except for the L1TF pfn check:
remap_pfn_range() rejected a disallowed pfn with -EACCES from mmap(),
where the fault handler now raises SIGBUS on first touch.

Once the device is unregistered, a page with no present entry gets
SIGBUS, where the eager mapping kept it mapped. Not only untouched
pages: splitting a huge entry with a partial munmap() or mprotect()
zaps it, since __split_huge_pmd_locked() clears a PFN-mapped PMD rather
than converting it to PTEs.

Without huge PFN mappings, or for small or unaligned mappings, the
region is populated one page per fault, paid only for pages that are
actually touched.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 drivers/uio/uio.c | 102 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 96 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f8fa20522660..6b4c79340e5c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -733,9 +733,80 @@ static int uio_mmap_logical(struct vm_area_struct *vma)
 	return 0;
 }
 
+/*
+ * Populate UIO physical mappings on fault, using a PMD or PUD mapping where the
+ * architecture, the fault address and the pfn allow it.
+ */
+static vm_fault_t uio_physical_huge_fault(struct vm_fault *vmf,
+					  unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	struct uio_device *idev = vma->vm_private_data;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	unsigned long pfn;
+
+	/*
+	 * vm_pgoff is the base pfn of the mapping (see uio_mmap_physical()).
+	 * vmf_pfn_order_ok() ignores pfn if the window starts below vm_start.
+	 */
+	pfn = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	if (!vmf_pfn_order_ok(vmf, pfn, order))
+		return VM_FAULT_FALLBACK;
+
+	mutex_lock(&idev->info_lock);
+
+	if (idev->info)
+		ret = vmf_insert_pfn_order(vmf, pfn, order);
+
+	mutex_unlock(&idev->info_lock);
+
+	return ret;
+}
+
+static vm_fault_t uio_physical_fault(struct vm_fault *vmf)
+{
+	return uio_physical_huge_fault(vmf, 0);
+}
+
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+/*
+ * generic_access_phys() only follows present PTEs, and a lazily populated
+ * mapping has none for pages the target has not touched yet. Fault the page in
+ * first (through the handlers above, so info_lock is honoured), so that remote
+ * access (ptrace, /proc/pid/mem) keeps working.
+ *
+ * fixup_user_fault() refuses a fault the vma does not permit, so an untouched
+ * page of a mapping without VM_READ stays unreadable, where the eager mapping
+ * left a present PTE.
+ */
+static int uio_physical_access(struct vm_area_struct *vma, unsigned long addr,
+			       void *buf, int len, int write)
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
 static const struct vm_operations_struct uio_physical_vm_ops = {
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-	.access = generic_access_phys,
+	.access = uio_physical_access,
+#endif
+	.fault = uio_physical_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = uio_physical_huge_fault,
 #endif
 };
 
@@ -767,11 +838,30 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	 * So we just do the physical mmap without a page
 	 * offset.
 	 */
-	return remap_pfn_range(vma,
-			       vma->vm_start,
-			       mem->addr >> PAGE_SHIFT,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot);
+	if (vma_is_cow_mapping(vma)) {
+		/* COW mappings cannot be populated on fault: map them now. */
+		return remap_pfn_range(vma,
+				       vma->vm_start,
+				       mem->addr >> PAGE_SHIFT,
+				       vma->vm_end - vma->vm_start,
+				       vma->vm_page_prot);
+	}
+
+	/*
+	 * Populate on fault (see uio_physical_huge_fault()). Tracking the PFN
+	 * range keeps its memory type reserved, for PAT conflict detection.
+	 *
+	 * vm_pgoff holds the map index, which the fault handler cannot use:
+	 * splitting the VMA adds the page offset of the split to vm_pgoff of
+	 * the upper part, so uio_find_mem_index() then returns the wrong map,
+	 * or none, and the start of that part would be mapped to mem->addr.
+	 * Store the base pfn instead, as remap_pfn_range() does for COW
+	 * mappings; VMA splits then keep vm_pgoff correct for each part.
+	 */
+	vma->vm_pgoff = mem->addr >> PAGE_SHIFT;
+
+	return pfn_range_track(vma, vma->vm_start, mem->addr >> PAGE_SHIFT,
+			       vma->vm_end - vma->vm_start);
 }
 
 static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
-- 
2.47.3


