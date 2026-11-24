Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF27606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Jbpt0Pia
Received: by kanga.kvack.org (Postfix)
	id B976F6B06D5; Tue, 24 Nov 2026 08:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B700A6B06D7; Tue, 24 Nov 2026 08:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87176B06D8; Tue, 24 Nov 2026 08:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 859916B06D5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:16:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 176F6120B60
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:16:15 +0000 (UTC)
X-FDA: 85470061110.12.0821187
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id C887C40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:16:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Jbpt0Pia;
	spf=pass (imf07.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526173;
	b=RYEEKlkMvfLbCCxUrqnTVo0Da+tKFg5vyvXa5QZ0OCHZa7A6qgGCZsOzpukAR4j7pIjgsR
	1BfdW3YcvAlO8/g3a1O68dwxdBzVD1CMgARqpHjAubSFJNyQEGy3izWeeG8yzH1eYNQgIT
	A3VkW7Jp0rr872Ktxnct8VKcuFk38z4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E71K9DAZXuBW6FMEeF8MHMH1GEx0nXMOaIwtkSO4oO4=;
	b=zPWdPs2bR3yXfFkIcLYKNIIBAPVxIyKGSE4ikedubUdwWhzY89D0synxXJgglHr8I2cVJS
	eFxgioO4WxC6VGhg2fx/U7ae7dk/A5Y8nV3pMHX75y54IQDy+KVEaSUBWRLKGoyh3GlxKQ
	2MqFTBFOjIHshJzDvoKJGfxNdELJifA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Jbpt0Pia;
	spf=pass (imf07.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526172; x=1827062172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E71K9DAZXuBW6FMEeF8MHMH1GEx0nXMOaIwtkSO4oO4=;
  b=Jbpt0PiaYS1yqxsTxXSguE6wuyQv53jsutws1B8U7b1mXKYZL3EKu010
   kZgW23MAW7N5EDvbFtG3fOwdtDobsomkscl4O2NtSvWmxmKrSXrw0MnSh
   DFjrccCRd4jlZuvrDRivA+UNjQm0H+/u8u2HnEHVU9devz5t3zjR7undd
   sHrLD2QCkMzwccoMCo1JGgsH82/7MWCsjBC4zhMZISw62Sr2U9Vy7XFdb
   lWZwM+ZaCXQvpsqwtL9z5VsruDp4kDO4BlHrizWn18YJDL0ubTNl16VQW
   l40fmMd7G6f2+xGbf0l5XCY1H8giMyEPipjM+a6urIvU+tf1gfCL0gWAH
   g==;
X-CSE-ConnectionGUID: O1fAtBCZTdGajmGIvDFTPg==
X-CSE-MsgGUID: jsTgNV2RTlmvzzgACpj7Mg==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="34918374"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:16:09 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:12528]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.116:2525] with esmtp (Farcaster)
 id 0700fbb8-9e13-474a-a14d-0a1c8bebf46f; Tue, 24 Nov 2026 13:16:09 +0000 (UTC)
X-Farcaster-Flow-ID: 0700fbb8-9e13-474a-a14d-0a1c8bebf46f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:16:09 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:16:05 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 5/5] uio: implement huge_fault support for physical mappings
Date: Tue, 24 Nov 2026 13:15:10 +0000
Message-ID: <20261124131510.38745-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C887C40006
X-Stat-Signature: 1ctwnz7tuq3eoby197jg7d4idsmih4oa
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795526172-367426
X-HE-Meta: U2FsdGVkX1+T6ieBdLGG3hwukL7tMOnYbzirdVbEOGZjTVqE3PhCxXZo+VW/q1yDDWe9UKwGjmvgpZ+0t+u+wn5AQQ16x5ty1xlyFZ096+71fQJFL6XXDr6eyI4R+1mtj0VZ2tcVVPoaV9aqLjbGu3BKNmdxVOn5TLqq9H5vaoYxk6lzVoEKBOmRzLL5UDleZXyH4PH7qBC5dPDY60e9rf+f5qIzX7KNtBT/7+Nf9kElTNfG/Yur4sUZU9SJpP9DvXFR+C089+JB7HpE+pmoJzRz+0EWTijyhGVsVmY2xTuDHOpOpBQGLdgVwLavUEDr8N+jgNdc/ruZvHYcIJIjSIRErIln7ZHZt0QAKKGa4EfhQhI/Sqc6pQItqZGI3wRIoMGHf6oYPpUZkyVGDSNipIHMQwauTreujQXynEhs01fYs4dJsPZi6zRbEDmuZu+ZlJrXfmCuAn379EsD1nuuE4/ABlD2PXaUnafLhDTYlQeNQpC/QGIoD7eBEDSgMI4rpfRG3xpE1j8AFQ2Do8Y9uHNCW5wDrlPW9rssTWH2e0p5etrj6vbv8louiSwWddvuNrPGparnq/2PpDSZZLaB/Hc0j+yhqxAYgQ+ESvx35BnP01OnzB9CTzEg1ka2mjIHeqVSRQBOkCu4fN0+Z6ieGT6PeVyUhxqj7L5YEgqZXEyfMeVBfw5oUOYCxNrJTl9JGHFXx7tjfH/jkJC85GWuqwUdnTCCqEvuOpPfhwBFghJPqcJlxEtkbdgPcC0yCJy455TXuw79ttlsZZdtpaMbeFEWjSwtV0UgrRBpjhilYAtfi8CwETfoNO0oFhZwala60kJpTp2h9dSwZ++QuHxdBHyzNcxDkHAiXCKLQf3jiUuXEGQxl80DudcGkIllwK8tXJCVTSlDW7nMDomSHsC4PxMNVfGP+57Wjv6vnNM0JqKy7S9/nse6R0bLq0pq+EhrbdPfcg4BciKckmNK6K4
 2SlRdMwg
 Ggv3k9B91m/YYxMiJhz0c+iJQ1E0Jvy3Pl6qVSnL1rVbUqjlMGUJQJBWRotYO86fCKX/apeu4Q3cuB1yZghp2kRhrWN8PE91WqU5Rf0Ui7RMbSebk9w3r/4o1CA5TIbxqKWw1E8GTeDBzibwrO6Eu2eK5kGVFjaLNeBjn39esBkASLUEGHtKSDK0Xee0zWaBrTbQvgxEgGtXNSonu+xIMVYvx57CLLnGFF4nN+LiaSXhsqY9h/QDT7pLhONcn2Boq1QGHW+YOsEnK7BNz1Y8sbt1kbhH2E6KSwgcGL6Cmg44nT93CG6LqsKAjVCyQgnKoJgVe5AIfW64QOk+0bYQnCDD2veZyNPO6s3wXArxTxIYU599S+jdvpYjZzgV1U6ZEyLpnWaqVglOtsqCailBeaNtZ2qWs/GKfstkf61ID9AEI8lKhCcBkxFwaYmqTklxRt3wmrGzwDDsi8xJX0e2Udt//rEaOtu+4OBweMTVRtXVtbEH9wfJ44LOx4qGbx4eHxF8m9oh/BUWC6XZCMSXaNig6dy7Dl4DmH9UrcQmuWfiUUsPelX0VaAV5Hg7dtsbx5t1OgIYEldr7j63gMBy8BowBmf8eY4sWPs9zM9i0DHO0jrVB6NXC91zpOmUUnr6cQXkvgybq47QudryZ0yJV6o3SW4CVdCpnnt/putz9D3i17q91C+81dQGuG7B6CSntrezPnJ2tNcfAYv0A6y0iXu00MlAO5w70HbtEGKo9eQoElXbzt+ZzJ7ni+N5KS2rXHupfCb0dbESi6zSufu7NfNqwOLEZrL4PEO6bjNiOS4/Dxg2s5C3HQk4R8uys9/pkSvqshFEhivvxG8BYe8QrPWn1Gg5eF2pyunuSkxKBJgrdQQhGC/mfyGQIQSn+qlpkiUE/OpQwVnUvKlMAZGR87Bg0Teg/juHdI3Rr1dNtETtJu9PjLskROh0Qr5wwruZQVUnMmtD119PqbcJuAl08zhR68b8L
 E1Xudays
 2MUwICZmnGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

uio_mmap_physical() maps UIO_MEM_PHYS and UIO_MEM_IOVA regions at mmap()
time with 4KiB PTEs, however large and aligned they are. Populate on
fault instead, as vfio-pci does since commit f9e54c3a2f5b ("vfio/pci:
implement huge_fault support"): call track_pfn_range() rather than
remap_pfn_range(), and add ->fault and ->huge_fault handlers using
vmf_insert_pfn_order(). A large enough aligned region is then mapped with
PMD or PUD entries.

Like uio_vma_fault(), both handlers take idev->info_lock and fail with
SIGBUS once the device is gone. COW mappings keep the eager remap.

The fault handler needs the base pfn, so vm_pgoff now holds that instead
of the map index, as remap_pfn_range() does for COW mappings.
/proc/pid/maps reports it as the offset of these mappings.

Once the device is unregistered, an untouched page gets SIGBUS. The
eager remap used to keep it mapped. A remote read through ptrace or
/proc/pid/mem of a mapping with no VM_READ now fails too, where the
eager remap used to leave a present pte.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---

Changes in v3:
- Follow track_pfn_range()'s new signature.
- Return fixup_user_fault()'s error from .access instead of ignoring it.

Changes in v2:
- Give COW mappings their own vm_operations_struct, rather than test for
  COW inside the fault handler.
- Corrected the L1TF claim in the commit message.

 drivers/uio/uio.c | 99 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 9 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f8fa20522660..00f58b68d504 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -733,12 +733,78 @@ static int uio_mmap_logical(struct vm_area_struct *vma)
 	return 0;
 }
 
-static const struct vm_operations_struct uio_physical_vm_ops = {
+/* Populate UIO maps on fault, huge where the arch and alignment allow */
+static vm_fault_t uio_physical_huge_fault(struct vm_fault *vmf,
+					  unsigned int order)
+{
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	struct vm_area_struct *vma = vmf->vma;
+	struct uio_device *idev = vma->vm_private_data;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	unsigned long pfn;
+
+	/* An order-aligned addr below the VMA would wrap the subtraction */
+	if (addr < vma->vm_start)
+		return VM_FAULT_FALLBACK;
+
+	/* vm_pgoff is the base pfn, not the map index (uio_mmap_physical()) */
+	pfn = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
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
+/* generic_access_phys() needs a present PTE; a lazy mapping may have none */
+static int uio_physical_access(struct vm_area_struct *vma, unsigned long addr,
+			       void *buf, int len, int write)
+{
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	int ret;
+
+	if (write)
+		fault_flags |= FAULT_FLAG_WRITE;
+
+	/* unlocked == NULL keeps the mmap lock held and the vma valid */
+	ret = fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
+	if (ret)
+		return ret;
+
+	return generic_access_phys(vma, addr, buf, len, write);
+}
+#endif
+
+/*
+ * vm_ops for a COW mapping, which vmf_insert_pfn*() cannot populate. Must
+ * exist even when empty: a NULL vm_ops would make the VMA anonymous.
+ */
+static const struct vm_operations_struct uio_physical_cow_vm_ops = {
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys,
 #endif
 };
 
+static const struct vm_operations_struct uio_physical_vm_ops = {
+	.fault = uio_physical_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = uio_physical_huge_fault,
+#endif
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = uio_physical_access,
+#endif
+};
+
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -754,7 +820,6 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start > mem->size)
 		return -EINVAL;
 
-	vma->vm_ops = &uio_physical_vm_ops;
 	if (idev->info->mem[mi].memtype == UIO_MEM_PHYS)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
@@ -764,14 +829,30 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	 * up above in uio_find_mem_index(), rather than an
 	 * actual page offset into the mmap.
 	 *
-	 * So we just do the physical mmap without a page
-	 * offset.
+	 * So a COW mapping is remapped below without a page
+	 * offset, and the lazy path overwrites vm_pgoff.
 	 */
-	return remap_pfn_range(vma,
-			       vma->vm_start,
-			       mem->addr >> PAGE_SHIFT,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot);
+	if (vma_is_cow_mapping(vma)) {
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
+	 * A VMA split adds the split offset to vm_pgoff, so the map index
+	 * stored there would no longer find the map. Store the base pfn
+	 * instead, as remap_pfn_range() does for COW mappings.
+	 */
+	vma->vm_pgoff = mem->addr >> PAGE_SHIFT;
+
+	/* Tracking reserves the memory type, for PAT conflict detection */
+	return track_pfn_range(vma, mem->addr >> PAGE_SHIFT);
 }
 
 static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
-- 
2.47.3


