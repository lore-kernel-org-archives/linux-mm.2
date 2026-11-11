Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F083606B032
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=MCmAAKPG
Received: by kanga.kvack.org (Postfix)
	id 394DE6B05BC; Wed, 11 Nov 2026 17:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C556B05BD; Wed, 11 Nov 2026 17:43:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282F56B05BE; Wed, 11 Nov 2026 17:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED6006B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:43:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6181A0486
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:38 +0000 (UTC)
X-FDA: 85424316516.27.0C01BDA
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id 557FC20008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MCmAAKPG;
	spf=pass (imf03.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437016;
	b=KvbtAfl8qGks0kyWF7pGMruH3FriNh5hckGqR8dfJS4czciwP/uWbMmLHqcbuVPPL6Z/pG
	0dSBqa1UjVHCqr2NqYXH73tTTey6bmYUzJ2R/WUiyHlyULbogyFO9MceV8PgaU5dgrfKt6
	jrOLxoVINEEVrgfjRuyE/z1F9jf7mMs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MCmAAKPG;
	spf=pass (imf03.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5jblTJKi+wXzEn0XfFHHKjPffBWizNSce06ASHpEv0=;
	b=cYCyOuw7FzGrg8WJ3lWoX7H3aPZNsJfnIy6Mh2wAaM9M1mz97PisSkqU5jT5tI+Vqm9vP9
	SIiMGEy8Kg4eE6LEXHMbtA8tk2tSToDnlnvBs70iJKeyf+8KwmVgkBWDOnq8dIpYVvWdNY
	PzfjzK9vtLBpThUvOBzAwp0KhNtC69Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437016; x=1825973016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I5jblTJKi+wXzEn0XfFHHKjPffBWizNSce06ASHpEv0=;
  b=MCmAAKPGs7K9U6egRM8wY8UGQsSe8FJkxwMbwQPD2H7tHMub11ekKBC+
   CUw9RIdD0iOo3+OUaTS5Uwm9BVU3BgYhIch+ciXmpRAprIZlRBSN0eDDF
   bUqVozeMTUw9iBouZiwoHktMKQ2K3HKj+ZvQjpeBrBiJgKvafA3qmZ0zX
   YW5oWoGfFiwNqJzjCyLAj7pLuK0fzQM9K+q/oyPNcvCspb1sfUXOuZSo1
   DryKJCdDHK3G8n20Rb1pENMZDKtB23JCxk61Rf9PjJuMxHWBnX7ld8bV0
   XyIvLSMMjA+eS7Vlw6u89zQ/KUKobXc9PUec9//VWgSuypmpaU3+BNfr3
   g==;
X-CSE-ConnectionGUID: 10AdERIbSoqUwGgXELCDVA==
X-CSE-MsgGUID: mW09cnduT+qQHFr1LPPPTQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33273315"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:31 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:29377]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 465b19fa-9b9f-4e29-a180-e30b55d7fca4; Wed, 11 Nov 2026 22:43:31 +0000 (UTC)
X-Farcaster-Flow-ID: 465b19fa-9b9f-4e29-a180-e30b55d7fca4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:30 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:28 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 07/40] nitro_enclaves: Add NE_MEMORY_SHARED
Date: Wed, 11 Nov 2026 22:41:52 +0000
Message-ID: <a1aa64fd1053995db2b20419ca6bee73c3a99f03.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: r31ft8tahtnpfh7qhnpfokrucskjarw1
X-Rspamd-Queue-Id: 557FC20008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794437016-942241
X-HE-Meta: U2FsdGVkX1+PrQgyg8L/iJ5uMgW+/9CzZhn2qux9+cDtDo1ak749fRfrt5BfbeCqAwI6XAS0+QQx+JfgTTZIvkLkLiMw3urs06bPbL/UtBr40YeGiCl/fAPl9EQZRY2hjVe0KP9OCbVkvp9Tqg82geWp+lqYB6hWQbK9yz96rYF1WjDM+hfYVfJKcIoAK5G6KE0kUR2ilJo+sw5ThAetV/u/A+IaMybW8D6iERIn6gpipr6uJ0N3BCE2dok7lXBa6H+CmeiugjilRKogfGH6xqkf+7/E8fHas2VX4O3/Lzy+OjfAxuzX5420Pui+HMWfhmMzOni+kfYhZYH44a0cDPIGujfAs+H16H/FMA6BJDO2FqjyQ4QVuAZXKXptSJ0+hSQWFpUfWcdgjn4Y/YO3TwULW5QZ/QiVFk4TSYMRXdiR2EFls74aD7TvAKA5Y+jbGWGRX7MBhJXyloY0kc4Lh1e4moZ4b3d/71CX4Wy3ZtwODZiR0gNEN3w1hJgWNj1WvYvTymoTRgpsTV9+RWlMBDD/66js7YYUQr68gVb7pZK3V8YxQNDiWT3Aaa0Rl0WE4+X5HQ+29sKWxKliTQZqWdQPxr7sO5KBG4OWmqo+Fbq3KEHSOuBjqfIQfXhur4FQcAkL8q5QFG8gB2wZKAdGBGJvd+gB57M+bMdVGchdLCBe/D2SqXNs6QHB+cRQV00bBVyu7976UgsaL67UjbodYagYJyn0uU9chYe1fBdXqOMOny/KoZi6qiCYEab/uc08ETnFCqQ4SZUKDx9LF4SmJH1pR1kYZ7D86nl21Aw7et+rW7j5BUImM3cJ58xcn/IOJ+LA7/J/szYGpMg7FbUIqOtrokm7OV8lmbqx+IbziZnAUokbtfUuJedvvINa7ZGAwPOs06MFiDfqKVC5UVgjGHvw0xYogaKDgOYTpZdq6Vu7gXE9gEXlkW+iVaJLObo3F56fQi2dj4AlxQEe4TT
 PPEyxhXW
 h++Fte8hLH1iJflA/uIx3u7j/XAuEcqWG9Iiwm/3zOM/9NdhHNmA3UsesuPEHjnn2V8+TjwvjZgQvVYCRf4T/YF27p7jnStAiVXXa1Y8JlRu7rKe8hqovA0RiYMlgswdI95Zxqp3OVJmeQPTaR7oQP80+HZ/+yXfjsCjATbRMPgVtGhDXSp/zcCfGUpwWo4ukkrNeQbe0+OkgCE8A9EejwuIe/TVxonHuXf+DHg18HSkpyKQ/lKDK2lP4W/+mTQwdxCtI2uPBFVLoV1Bue9biRBAYR1VVF0D1CqpOF7hODVo88QNjAjLmHyC43YWi2F8lXoNjGM0opmoKwEDh/TCZHZus3gX5M8Ciq7az8YBOew+tTJuoJOCpSnvzbwhY0qWTUY+SE2uQ1ypIJH+9ds7BhsHAngosV4rNjRe+91L2m9KWNVs/cIHRRe3HI7nu8DD7XdA+DVWoahPZI8CrB+Pwds+cajdzAwA2jQlz2s8hyuI8gzNYQqGvW0C676Yrb4RNT/psTkiRbHy3Qm6kTobtxUFzjkZvhucAHAhSgt/PzD+fow4KYN9/ThZcBH0kocXId6cVTZqJh6ip5Zdi0HCUdmBQ783tC7emeyPFRTTbjx/0PdSKtEnYa85I9Eeh1myf+j2sanWlAXQgl+8qN/7vLlXOfB3/KoyZrtFFCwV8OioWHnTaFmCBWAswPbSBH9K9hmnkH6/nVJjmcPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support Nitro Sandboxes, whose parent keeps using some
of the memory it hands over, add NE_MEMORY_SHARED, a flag for
NE_ALLOC_MEMORY that makes an allocation mappable. The parent needs that
to read state the device writes for it, and for virtqueues and buffers
that both the parent and the sandbox access.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 160 +++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |   6 +-
 include/uapi/linux/nitro_enclaves.h       |  36 ++++-
 3 files changed, 190 insertions(+), 12 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 56ca1a9d99d41..55dbeb5b14d29 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -2597,17 +2597,21 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  * serving such a request out of movable memory would take that memory from
  * the rest of the host and leave the reservation bounding nothing.
  *
- * A request larger than one contiguous run is satisfied by several runs, which
- * the driver keeps on a list of its own so that an enclave can be given every
- * one of them.
+ * A request larger than one contiguous run is satisfied by several runs, and
+ * mmap() maps them back to back into one VM_PFNMAP VMA, so user space sees a
+ * single region. The driver keeps the runs on a list of its own, so that an
+ * enclave can be given them without anyone reading them back out of the page
+ * tables.
  *
- * An allocation is never mapped, and the enclave image reaches it through
- * write().
+ * An allocation is either private or shared. A private one is never mapped, and
+ * the enclave image reaches it through write() instead. A shared one can also be
+ * mapped, at an offset and a length its own size bounds.
  *
  * The runs belong to the file the allocation is handed out on. Zeroing a fresh
  * run and a write into an allocation go through ne_walk_run(), so that neither
- * can run for as long as the allocation is large; the release path walks the
- * runs with a preemption point of its own.
+ * can run for as long as the allocation is large. A fault resolves the run its
+ * offset falls in with a binary search instead of walking, and the release path
+ * walks the runs with a preemption point of its own.
  */
 
 /**
@@ -2788,6 +2792,82 @@ static int ne_walk_allocs(struct ne_contig_mem *mem, u64 off, u64 len,
 	return 0;
 }
 
+/**
+ * ne_contig_fault_order() - Install one page table entry for a fault.
+ * @vmf:	The fault.
+ * @order:	Order of the entry to install, zero for a PTE.
+ *
+ * A mapping is populated as it is touched, so a caller that maps a whole
+ * allocation and builds an enclave image at the front of it pays page tables
+ * for the part it touched.
+ *
+ * An entry of @order needs that much of one run behind it, at a matching
+ * physical alignment. A run is a power-of-two multiple of 2 MiB aligned to at
+ * least 2 MiB, so a PMD sized entry fits inside one whenever the address it
+ * lands at is aligned too, and anything that does not fit falls back to the
+ * next order down.
+ *
+ * Return: a VM_FAULT_* value.
+ */
+static vm_fault_t ne_contig_fault_order(struct vm_fault *vmf, unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct ne_contig_mem *mem = vma->vm_file->private_data;
+	unsigned long len = PAGE_SIZE << order;
+	unsigned long addr = ALIGN_DOWN(vmf->address, len);
+	struct ne_contig_alloc *alloc;
+	unsigned long pfn;
+	u64 off;
+
+	if (addr < vma->vm_start || addr + len > vma->vm_end)
+		return VM_FAULT_FALLBACK;
+
+	off = ((u64)vma->vm_pgoff << PAGE_SHIFT) + (addr - vma->vm_start);
+
+	alloc = ne_find_alloc(mem, off);
+	if (!alloc)
+		return VM_FAULT_SIGBUS;
+
+	if (off + len > alloc->off + ((u64)alloc->nr_pages << PAGE_SHIFT))
+		return VM_FAULT_FALLBACK;
+
+	pfn = page_to_pfn(alloc->page) + ((off - alloc->off) >> PAGE_SHIFT);
+	if (!IS_ALIGNED(pfn, len >> PAGE_SHIFT))
+		return VM_FAULT_FALLBACK;
+
+	if (!order)
+		return vmf_insert_pfn(vma, addr, pfn);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
+		return vmf_insert_pfn_pmd(vmf, pfn,
+					  vmf->flags & FAULT_FLAG_WRITE);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
+		return vmf_insert_pfn_pud(vmf, pfn,
+					  vmf->flags & FAULT_FLAG_WRITE);
+
+	return VM_FAULT_FALLBACK;
+}
+
+static vm_fault_t ne_contig_vma_fault(struct vm_fault *vmf)
+{
+	return ne_contig_fault_order(vmf, 0);
+}
+
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+static vm_fault_t ne_contig_huge_fault(struct vm_fault *vmf, unsigned int order)
+{
+	return ne_contig_fault_order(vmf, order);
+}
+#endif
+
+static const struct vm_operations_struct ne_contig_vm_ops = {
+	.fault		= ne_contig_vma_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault	= ne_contig_huge_fault,
+#endif
+};
+
 static struct cma *ne_numa_cma_area(int nid)
 {
 	struct cma *cma = dma_get_numa_cma_area(nid);
@@ -2915,6 +2995,69 @@ struct page *ne_alloc_contig(unsigned long nr_pages, int nid,
 	return page;
 }
 
+/**
+ * ne_contig_supports_mmap() - Whether an allocation may be mapped at all.
+ * @file:	The allocation's file.
+ *
+ * A private allocation is the one an enclave gets to itself, and it is never
+ * mapped. The attribute is fixed when the allocation is made and the file is
+ * not published until it is set, so this reads it without a lock.
+ *
+ * Return: true when the caller may map the allocation.
+ */
+static bool ne_contig_supports_mmap(struct file *file)
+{
+	struct ne_contig_mem *mem = file->private_data;
+
+	return mem->shared;
+}
+
+/**
+ * ne_contig_mmap_prepare() - Set a mapping of part or all of an allocation up.
+ * @desc:	The mapping to set up.
+ *
+ * The offset and the length both have to be multiples of 2 MiB, which is the
+ * unit the allocation itself is made in, and the mapping has to stay inside
+ * the allocation. A caller may map part of an allocation, and may map one
+ * allocation more than once; the runs are not mutated after the file is
+ * published and the file holds them for as long as any mapping exists.
+ *
+ * ne_contig_fault_order() populates the mapping as it is touched. The mapping
+ * asks for VM_HUGEPAGE because a fault on a VM_PFNMAP mapping without it only
+ * reaches ->huge_fault where the transparent_hugepage policy is "always".
+ *
+ * Return: 0 on success, negative return value on failure.
+ */
+static int ne_contig_mmap_prepare(struct vm_area_desc *desc)
+{
+	struct ne_contig_mem *mem = desc->file->private_data;
+	unsigned long size = vma_desc_size(desc);
+	u64 offset = (u64)desc->pgoff << PAGE_SHIFT;
+
+	if (!ne_contig_supports_mmap(desc->file))
+		return -ENODEV;
+
+	/*
+	 * MAP_PRIVATE of an allocation has no meaning: the memory exists to be
+	 * given to an enclave, and a copy that only this process can see never
+	 * reaches one.
+	 */
+	if (!vma_desc_test(desc, VMA_SHARED_BIT))
+		return -EINVAL;
+
+	if ((size | offset) & (NE_MIN_MEM_REGION_SIZE - 1))
+		return -EINVAL;
+
+	if (offset > mem->size || size > mem->size - offset)
+		return -EINVAL;
+
+	desc->vm_ops = &ne_contig_vm_ops;
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+			   VMA_DONTDUMP_BIT, VMA_DONTCOPY_BIT, VMA_HUGEPAGE_BIT);
+
+	return 0;
+}
+
 /**
  * struct ne_write_ctx - Where the write walk has got to.
  * @iter:	Where the bytes come from.
@@ -3030,6 +3173,8 @@ static int ne_contig_release(struct inode *inode, struct file *file)
 static const struct file_operations ne_contig_fops = {
 	.owner			= THIS_MODULE,
 	.llseek			= generic_file_llseek,
+	.mmap_prepare		= ne_contig_mmap_prepare,
+	.get_unmapped_area	= thp_get_unmapped_area,
 	.write_iter		= ne_contig_write_iter,
 	.release		= ne_contig_release,
 };
@@ -3176,6 +3321,7 @@ static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
 	mem->mm = current->mm;
 	mem->nr_pinned = nr_pages;
 	mem->size = args->size;
+	mem->shared = args->flags == NE_MEMORY_SHARED;
 	mem->enclave_id = ne_enclave->id;
 
 	/*
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 1a76c12815298..fcdf457af5800 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -38,6 +38,7 @@ struct ne_contig_alloc {
  * @allocs:	Contiguous runs backing the allocation, ordered by offset.
  * @nr_allocs:	Number of runs in @allocs.
  * @size:	Size of the allocation in bytes, mirrored in i_size.
+ * @shared:	Whether the allocation may be mapped by the caller.
  * @enclave_id:	Id of the enclave the allocation was made for.
  * @mm:		The mm charged for the pinned pages, held via mmgrab().
  * @nr_pinned:	Pages charged to @mm->pinned_vm.
@@ -47,13 +48,14 @@ struct ne_contig_alloc {
  *
  * The array is built before the file is published and not mutated afterwards, so
  * any holder of a reference can read it without a lock of its own, which is what
- * lets a page fault resolve an offset to a run. @size is set in the same place
- * and is read the same way.
+ * lets a page fault resolve an offset to a run. @shared and @size are set in the
+ * same place and are read the same way.
  */
 struct ne_contig_mem {
 	struct ne_contig_alloc	*allocs;
 	unsigned int		nr_allocs;
 	u64			size;
+	bool			shared;
 	u64			enclave_id;
 	struct mm_struct	*mm;
 	unsigned long		nr_pinned;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index a2919565bc883..f1315c9c876de 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -215,7 +215,7 @@ struct ne_add_any_vcpu_args {
  * @size:	Number of bytes to allocate, a multiple of 2 MiB.
  * @nid:	Host NUMA node to allocate from. One node, named; unlike
  *		%NE_ADD_ANY_VCPU it does not take %NE_NUMA_ANY.
- * @flags:	%NE_MEMORY_PRIVATE.
+ * @flags:	%NE_MEMORY_PRIVATE or %NE_MEMORY_SHARED.
  */
 struct ne_alloc_memory_args {
 	__u64	size;
@@ -237,7 +237,16 @@ struct ne_alloc_memory_args {
  *		     goes into one through write() or pwrite() and not through
  *		     a copy into a mapping, and every write is a call the
  *		     kernel handles and can act on or refuse.
- *		     The allocation lives until the descriptor is gone.
+ *		     A %NE_MEMORY_SHARED allocation can also be mapped, at
+ *		     offset 0 or at any other multiple of 2 MiB, for a multiple
+ *		     of 2 MiB, with %MAP_SHARED. A caller maps one to keep an
+ *		     address for memory it goes on using after it has handed the
+ *		     allocation over. Such a mapping is readable too, which is
+ *		     the only way to read allocated memory back. The mapping is
+ *		     not inherited across fork(); a child that needs one maps
+ *		     the descriptor itself.
+ *		     The allocation lives until the last of the descriptor and
+ *		     its mappings is gone.
  *		     The ioctl can be invoked on the enclave fd, before an
  *		     enclave is started.
  *
@@ -276,6 +285,17 @@ struct ne_alloc_memory_args {
  *				  write, so a caller that has to know how far it
  *				  got looks at the return value. A fatal signal
  *				  part way through is reported the same way.
+ *
+ * An mmap() of the descriptor sets errno to:
+ * * ENODEV			- The allocation is %NE_MEMORY_PRIVATE.
+ * * EINVAL			- The mapping is %MAP_PRIVATE, or its offset or
+ *				  length is not a multiple of 2 MiB, or it does
+ *				  not fit inside the allocation.
+ * A mapping is populated as it is touched, so the page tables for a page are
+ * allocated at first touch and not by mmap(). A touch by the process itself
+ * that fails to get them is retried until it succeeds or the process is
+ * killed. A touch the kernel makes for the process, as read() into the
+ * mapping does, reports EFAULT or a short transfer instead.
  */
 #define NE_ALLOC_MEMORY			_IOW(0xAE, 0x2E, struct ne_alloc_memory_args)
 
@@ -472,8 +492,18 @@ struct ne_user_memory_region {
  *		       way to put an enclave image in one.
  */
 #define NE_MEMORY_PRIVATE		(0x00)
+/**
+ * NE_MEMORY_SHARED - An allocation the parent may also map. A mapping is what a
+ *		      caller wants for memory it goes on reading or writing
+ *		      after it has handed the allocation over. It costs page
+ *		      tables for the part of it a caller touches, and it leaves
+ *		      the memory reachable from the parent for as long as it
+ *		      lives, so an allocation that is only being handed over
+ *		      does not ask for one.
+ */
+#define NE_MEMORY_SHARED		(0x01)
 
-#define NE_ALLOC_MEMORY_MAX_FLAG_VAL	(0x01)
+#define NE_ALLOC_MEMORY_MAX_FLAG_VAL	(0x02)
 
 /**
  * DOC: Enclave start info flags
-- 
2.47.1


