Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE07606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=IMPfWe/G
Received: by kanga.kvack.org (Postfix)
	id DB3C46B05C0; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D639D6B05C2; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B1D6B05C1; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97B0E6B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1744CC0575
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:59 +0000 (UTC)
X-FDA: 85426466958.21.60148D5
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id E09B9180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="IMPfWe/G";
	spf=pass (imf24.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHCZgy5CRTPHvK8BqsQtFsJ376YRfs3ZCftnvP8cvm4=;
	b=LjNL6AoaBUttUIIQSWuLbPEP2dTdv8AgnJ8DKBwJ4Z3kgDyQA90dJgoP+Ziddeir9N/Arw
	Vk6UCKalaMksSQGKolllV2mQjvgrFM81ZnJVED7p6EOySYize+GZHcAv92ar32Ct5NyAi8
	yOdk8mgYP8NExYFI7Fl0ecmlqDLVIC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488217;
	b=g/tweHp7EAykroH/6wTwfRzZVuTNmIiQffiGG+VcalVhiBYzZAnPuuMEKjbGehYFArMAxP
	u5zBFYZDpQstkYvWN8LUsjDO5CBLe7+LYjcvyHXuLd32lqf4d1d2GUM8y8c1cG1IgIPmrD
	MOvRySLbLh15TkdFyQtOKPQj1+q6/mA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="IMPfWe/G";
	spf=pass (imf24.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488217; x=1826024217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BHCZgy5CRTPHvK8BqsQtFsJ376YRfs3ZCftnvP8cvm4=;
  b=IMPfWe/GkvRsLxi/xBjc+jmDJ3UKoZSemrZ1JaF8j+vXrv//bwolaCv/
   tZ4gLmmQdC02gw8a29HMhvhvdKYGvMPFjjbDtdLJJn7Ue2MG0DjKXvnz1
   AjGHIMK0zopx9KogIKWSH3AcAzJp8NsiqUySXDvzhjjKadDynN/flrCHP
   hUqcSAKdyldi4o3jFYpqySc3r2iKr+VlmpvhFc1g0Yxl2ljQddZ3LcMJ9
   VjAhjXNRn44Ek+AXVWzAqtE6igDaAALVd6bcSvllYIweM/j8MJKyGYUX5
   XOH2t0YGVlT0o7YMtngrZQ8pW10DQ8BFrekvNKgaqG1Qka8HL40yHyAIH
   w==;
X-CSE-ConnectionGUID: AtKDJ2DOR8abEGQziXIkcQ==
X-CSE-MsgGUID: Tkd/Vo62QM6lGtcrLabdig==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33728096"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:56:55 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:18634]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 1b3fcdea-2d1b-4f10-9575-dcf019735ad2; Thu, 12 Nov 2026 12:56:54 +0000 (UTC)
X-Farcaster-Flow-ID: 1b3fcdea-2d1b-4f10-9575-dcf019735ad2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:56:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 12:56:52 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Eliav Farber <farbere@amazon.com>
Subject: [PATCH v2 4/4] uio: implement huge_fault support for physical mappings
Date: Thu, 12 Nov 2026 12:56:38 +0000
Message-ID: <20261112125638.12209-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112125638.12209-1-farbere@amazon.com>
References: <20261112125638.12209-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E09B9180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1dfftpqtkfed78z43pwr9imrn3pjjsde
X-Rspam-User: 
X-HE-Tag: 1794488216-639893
X-HE-Meta: U2FsdGVkX18RwIgzNY+SYIXXIG3FdhUCnxZsUP4+mvNvJLTgvUSDOCKWXxxPDMRYBIpdnBXXVWSRy5AxrL5iiFuywVFavvnpRxSWn3BRN7az6kGEzul2+c1LtnUes0KCO7W2eGSZTTF5YDcPUntmD8G95ZRqwgV9aR7m+ZEpEpOSlB4ZU62V1APWxzjPp6fVhgJ6PjbGgLOa97c//QE+d4jwLMHfwrLei9nLFOordiNeA9M/7nAs1X9TqquHg58pU6pxglsSweHl5q8UNaAgl84zIJ0jEKTTVHrvcRphj9ZRjQ/8Ax8y/1p6ykLXZIBsSz3plBRrYoAjeqfjqkGvmGm8/siQ2gi3j7Wk1ECOyLzllEMy3Tr2JRttxmtEMS7LLtPc5tcNDHAaJ6TZA0jlZqD416ecQJRSmAqVht88egJZMm3T3Naqw0rjV9xh2X/XiB+xQQYJ2Z21EEsMsgpUMPb7ni4MD1Yr/G+zIUSrlviZ55QpamoIqlDl6ryMjZnvk8sRWs/iSRn4hq39N8qXXQux2xL0D6Ax9+CSWNNnNe+u5oC8DP0Wk2/d6c3rBRVBYCiR7V0hP/JAP7eaWwDFbWqIBteWyLAUSnYr0FDLcoG5eK6BEhH8FqDSBYW4lZeXJxReMIPiX7svKPh043QN4Zo6diIFy5Shn19WtSd/RPOLUpJ2exwD03H5w69Y+MnaeIu0yLorDDz1YzNL0vmJUUq4V/LvjYKIrcKiHfHL+7fv10cAQygSAuuilQn5CxckCjwECxEifOJoa9O2sDASdzngiZgorP9Ts17Kh1k8VtTYD00tuQKKSoty/0zt1Y7cuwKTZ0D3GXfdqc63WWRMj4C/w7S9Cq2p6OsuqK/0DGB9Mm7owwANqSCuZaR7UqQLQmD/TZo/l7j3rnHrNxbF6uNNS5x03jodx6UtI+abwujTVUfiWfyBPK792hDaTRz6gYWKe8nf94UuPgGOnUc
 AC/+ZFex
 UvW8QtAbCNi40FV3vDU+UydLA5KnsedPSmsKxSnzcxCdjhVDLoJEVC8pslCtLoHRYSQoRToZoRN7vBVG2DahwzdfqFCkBSwqT+SsY8oi2o6jzxYaZh1DhTCfvefl10eb+4/dG5HoSO0ApteYGzvkHaeyh7TuMUByyX9VFgFWk/LspplogP0Q8JJ0fJiRK/fyNt+Hzi8sywU8ega9HjtHSCaza5p+dVIdIZnY4qNy5/GSepvv8MBaok9DKo+6sOXS23RSpC9Z2pzXHWPpxx6jukm8PcC+6Qpw4FOkn+8KdzAhXoB4ELNLAu2h5ISg7pLHQWxW298QngoPpNsiyexEn8afBP+oyGhzdluYyd4908zBjbKWU5bPwc3lIPU+J/4WhMJDmUZv3QuOIMNmX9zOUHiSIag2RYTOg6PObiIQTgw7sajo2CLJh1ciDHOBMP953rn50MW+adtDbKkYM8YAWNON3ESfgR1IYbPPuTlZOEgNDN7T6yecEDhunoevxirZtzqnGl1eLxWSHnVIBbDoP5VdXh492BoQDmJIqm97jN5jUXzK6EIj3XFwws+oWqZGb6R3Vg+iZQdwn/+fGGzcv35sD0wmiNF2pvAw/QAp8dNbXkM/SrV0kuMG1x88LiP5aPYbiUAHveL1tIMatFHWXAWzvXTeuh25GO8Lg9vmvaMvTa4l28dfm7dNyyhzO9TTHQuur2sux87dUzK9OFdVMC5Wa0YGqTWI0D58PPPPuIf6oTSS/PJa7kRNcPtdSJxlCvKQ+
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
take idev->info_lock and fail with SIGBUS once the device is gone.

COW mappings cannot be populated by vmf_insert_pfn*(), which BUG_ON()s
a COW VM_PFNMAP vma, so they stay eager and keep a vm_ops without
fault handlers. do_fault() then rechecks a pte it found cleared under
the page table lock, which is what a transient clearing by
wp_page_copy() needs; a PMD-aligned COW mapping is also not reported
as THP eligible in smaps.

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

Validation at mmap() time is unchanged, except for the L1TF pfn check.
remap_pfn_range() rejected a disallowed pfn with -EACCES from mmap(),
so an unprivileged mmap(PROT_NONE) of a pfn above l1tf_pfn_limit()
failed. It now succeeds. Nothing fails later instead:
pfn_modify_allowed() only denies a prot that needs PTE inversion, i.e.
a non-present one, and no pte is installed for an inaccessible vma.

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
v2:
COW mappings get their own vm_operations_struct defining only .access; with
->fault installed, a COW vma could reach the BUG_ON in vmf_insert_pfn*(),
reproduced as a kernel BUG at mm/memory.c:2989. Corrected the L1TF claim in
the commit message: mmap(PROT_NONE) above l1tf_pfn_limit() now succeeds,
and nothing fails later. Reported by sashiko-bot.

 drivers/uio/uio.c | 118 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 111 insertions(+), 7 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f8fa20522660..7c038e3b107c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -733,12 +733,94 @@ static int uio_mmap_logical(struct vm_area_struct *vma)
 	return 0;
 }
 
-static const struct vm_operations_struct uio_physical_vm_ops = {
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
+	 * With unlocked == NULL, fixup_user_fault() keeps the mmap lock held
+	 * and the vma valid.
+	 */
+	fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
+
+	return generic_access_phys(vma, addr, buf, len, write);
+}
+#endif
+
+/*
+ * COW mappings are mapped eagerly by remap_pfn_range() and cannot be populated
+ * on fault: vmf_insert_pfn*() BUG_ON() a COW VM_PFNMAP vma. Leave them without
+ * fault handlers, so that do_fault() rechecks a pte it found cleared under the
+ * page table lock, and fails only once the pte is really gone, and so that they
+ * are not reported as THP eligible in smaps.
+ */
+static const struct vm_operations_struct uio_physical_cow_vm_ops = {
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys,
 #endif
 };
 
+static const struct vm_operations_struct uio_physical_vm_ops = {
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = uio_physical_access,
+#endif
+	.fault = uio_physical_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = uio_physical_huge_fault,
+#endif
+};
+
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -754,7 +836,6 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start > mem->size)
 		return -EINVAL;
 
-	vma->vm_ops = &uio_physical_vm_ops;
 	if (idev->info->mem[mi].memtype == UIO_MEM_PHYS)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
@@ -767,11 +848,34 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
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
+		vma->vm_ops = &uio_physical_cow_vm_ops;
+
+		return remap_pfn_range(vma,
+				       vma->vm_start,
+				       mem->addr >> PAGE_SHIFT,
+				       vma->vm_end - vma->vm_start,
+				       vma->vm_page_prot);
+	}
+
+	vma->vm_ops = &uio_physical_vm_ops;
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


