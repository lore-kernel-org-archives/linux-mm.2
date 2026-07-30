Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0316C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AA76B008A; Thu, 30 Jul 2026 13:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D625C6B0093; Thu, 30 Jul 2026 13:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79E56B0095; Thu, 30 Jul 2026 13:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18F46B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:37:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F1561401E9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:37:56 +0000 (UTC)
X-FDA: 85046150952.10.66520DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7143160003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:37:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxe0DBcy;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785433074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cxssjRLb23/bY3cD0Rs2QlWjP9nYvCg2nWJJctLs5k=;
	b=8doRsAIs2xvddlIk+jTq9EulqqxLitsE3BotTLYRUWr/3EeQKG950Yenl7QiM1JyvMeieU
	vJVayPWijoLLGXIOetHG1Wni0Gzdr381cBr2Bts//lBO5vuVtyco9uLvZafrBftU2Xt8q0
	7t1Iz3xKH0Vk9njNtdMDRJ0LAlFW1pM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785433074;
	b=6UiZG9U/kUJm8JB/fepuqQZpPwagqwFsRQkuw+npyo0/kq8b2PLujvYkHMWZe98iqV8Iz+
	PRDPXR/V9RTqWcwtkBQa068P1PScL1iaiSu6Q9X2mxfbWkZOZFTNSTF6QtP2EXZScftfYC
	xs1UKPbBwi8KSzccZ1tqMY0Cl6tN3Gc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxe0DBcy;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA63460204;
	Thu, 30 Jul 2026 17:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8231F000E9;
	Thu, 30 Jul 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785433073;
	bh=2cxssjRLb23/bY3cD0Rs2QlWjP9nYvCg2nWJJctLs5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zxe0DBcyjPydTViWdxQVA/Cr2fEdmUPMvtJYgDhv1r7zeluN5doeuwsa8xvYD6ATy
	 WKEmX3/1v01b2o5qUvoisYxGZvNIk1V6l45eSC51bcVduaQHpXSiXF9CO3Hq7ZflNL
	 znUzPTf/MeCzy1KjV1cam3N0VZTLybEMV4LOb6tvVHpjtf7R6FNRZat/RahnOJ5AuI
	 x5Pc1rvWkZnpiUChK6xY9D7Lxoj6/Rsta7VuN4s0v2JBRltortpb/YrrlX1Op2DuhV
	 N4IauSOjf23mMIdAI+0FWRVbnGA8dYuiUBPCcdwrYv7QZr2LQHDPX9Y41qK/E3bZoT
	 Z9jvCEFY/mbjw==
Date: Thu, 30 Jul 2026 18:37:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Baoquan He <baoquan.he@linux.dev>, Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, kexec@lists.infradead.org, 
	driver-core@lists.linux.dev
Subject: Re: [PATCH v2 0/3] mm,kernfs,proc: Unmap mmaps of removed files via
 file->f_mapping
Message-ID: <amuAupu-w664Ubfc@lucifer>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725210549.3716546-1-kwilczynski@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7143160003
X-Stat-Signature: udcrap61zwubk1f63omeyhohu3j8jaz6
X-Rspam-User: 
X-HE-Tag: 1785433074-404625
X-HE-Meta: U2FsdGVkX19Jhm4upR66pf2io2L5aa3pJOwpDkmaXVkAM1lxnV1WNrrWnmEghNur5Uvvlf0g6W6zb/EQXiAwXeqWdQqverhSuv3L6wX79uUBK3luKlkPRckz9VxAhYJehRljMW+OFpxEFCrlIfcsjJcE3+N108QwrUNyxlEzexP5zudsVXaxkERZIIbCTSdE/LWYbFOqoaAjE3BbKyQBLq3pPFyXiL43nWM+PNUbpu7IJ6jLCZa79ZowObVZD8R5QlNDwnjefQ2oZE1nnYA/RpuLLBnF8wuUonhre5rN0JYKQJC5qjf+XubOuNYOmEU+Gb7TZc5JyCi70RWrbL2FDHxCphlBch+LydpAcTx2s2P/M41Ya5NGynykQpKIBn2ol6sq0FTLyrZ7uLz1sKFn1ogfMcmCwCB0xmTfaO7oDUIJ002hL7jqVpfMvWSYmi4WD+VlkKMLC+uRamJJqYD7rgY5d54PWfaYGB7sE5U5EL+kksI/rf7OJAA7uWXonGRN4z7jIV2w4sPGaWPCpef6dTIPsCCJPhgi5Goqvm3qtEiX4R4azXR5GDAU/yolgIpZdafyU+bwj8nGgbB+rpJHq37eMbrZyfDqNQjQx1Ii9BBHibv1YcqffxhweJss+//w70/JOKC4hXZP0pYeKA0bh5nWjB9HcMd7zTMQW+CP1od2o8iELG2+HYitoU7nKQg5tz6wO9KF5GWx1CiHd1VOn1ZWisTSVWvXvnqBnfu7HpB+Wo1zLwNoaPIAY3ohas8I46173Yec8kpLKW/+NNA972u+BIIq7cfkM1E57/qz82cSi9MhArmWnTOPIOn2ClcnS3/dxhTb/XOQDJ7nMN0uJMXeU6wshl1K5ojppiSs7HUi4JqwPj8/oEQJ9kWj8tK1HO93qL4wXtQbofJD+eg+GeISeskj8rey9dlkI7lmgt0CrZVSPHyVFTpAYsRvJpzVxaWTANXLSsP+AOlAKyO
 s/yR1ccO
 hjr/rV/Zl5sUUO3E00yOisSDv7OxmtvGNg+w+OeC00xKf0z9BnHqzjsU+N3vvNmODK+QBLEoavyA+unlxr7qK3orFfNxYNmJUVT+AjqeZawF8dI0+8/hI6MwE58hU40o7U4+bIuuDVnXioYsS6V6kxMR4M3pLvcltCfu06DAuqKjxUpW6Kb3ETeIXrVmiq2XZfI2KcdgYpx6ANJWE9xVWVbZ/3SPsSArwbzvYQPPWDEIl0/L/jbyWo2tbe6ziFEGXISUmKzSUkUN6s61FQDjDQmWgbjRMyDPM1o8yjN5G8kiXnm8BQePmWfiF+dVjohmYTmvV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed off-list I think this is fundamentally broken.

struct file is not a universal - multiple opens can map the same thing. And
'these VMAs can only be selected by the struct file they were created through'
is not so.

So you're not going to get every /dev/mem or /proc/bus/pci or whatever by
checking against an arbitrary file.

The shared f_mapping already gives you the shared space in which the actual
iomem range resides.

The way things are mapped through the file rmap is via (mapping, pgoff).

Really the 'swapping' is telling you that what is a shared resource whose range
needs to be removed.

So what you need is to, at the point of the BAR being removed, unmap the correct
range.

So something like:

unmap_mapping_range(iomem_get_mapping(), ... pfn range ..., 1);

It also seems revoke_iomem() is very conditional, only if
CONFIG_IO_STRICT_DEVMEM and iomem!=relaxed.

So the file thing just doesn't work + what you really need is to:

- Revoke at the right time
- Revoke the physical range that is actually revoked
- Revoke this everywhere

So. I apologise. But. Father forgive me for I have slopped :)

This isn't my area of the kernel so I got the AI to generate something, which I
enclose.

I left all the gigantic horrible comments in to help.

It includes a fix up on the pci_iobar_pfn() thing you mentioned off-list which
sets the wrong vma->vm_pgoff for removal (ugh).

The pci_mmap_legacy_page_range() stuff probably just needs converting somehow
(and if it's broken there today it'll just have to stay broken, the range needs
to be shared somehow).

Anyway it at least gives an outline of a different road. So treat it as a 'here
are some thoughts' thing.

Cheers, Lorenzo

----8<----

From 525ce7631fa69aa9297e9fff6289e13316376e01 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 30 Jul 2026 18:15:20 +0100
Subject: [PATCH] PCI: Revoke BAR mappings on device removal and BAR resize

Userspace mappings of a PCI BAR survive removal of the device and resizing
of the BAR.  Nothing faults afterwards, so the process cannot tell that the
device has gone: removal clears Bus Master but leaves Memory Space Enable
set, so the device still decodes its BARs and reads keep returning register
contents, and writes are still accepted.  The addresses are released on
removal, and explicitly reassigned by a resize, after which the mapping
reaches whatever now occupies them.

These mappings are established through three interfaces, all of which
attach their VMAs to the shared iomem address space:

 - the sysfs resourceN and resourceN_wc files, whose bin_attribute sets
   .f_mapping = iomem_get_mapping,
 - /proc/bus/pci/BB/DD.F, whose ->open() does the same, and
 - /dev/mem.

On the sysfs side this is a regression.  kernfs_drain_open_files() unmaps
file_inode(of->file)->i_mapping, which held these VMAs until commit
636b21b50152 ("PCI: Revoke mappings like devmem") swapped f_mapping to the
iomem address space, after which the drain unmaps an address space that
contains none of them.  procfs never unmapped anything at all, and /dev/mem
mappings are only revoked by revoke_iomem() when a driver claims the
region, which is compiled out unless CONFIG_IO_STRICT_DEVMEM, returns early
under iomem=relaxed, and in any case need not happen before the address is
handed to another device.

There is no need to reach these VMAs through the struct file they were
created through.  The iomem address space is indexed by PFN:
pci_mmap_resource_range() adds the BAR's physical start to vm_pgoff, which
is precisely how revoke_iomem() already finds every mapper of a physical
range with a plain unmap_mapping_range().

So factor that out as iomem_revoke_range(), without the
CONFIG_IO_STRICT_DEVMEM and devmem_is_allowed() gates - those express the
iomem= policy on whether /dev/mem may map busy regions, which has no
bearing on a device going away - and call it for each BAR from
pci_destroy_dev() and from the BAR resize path.  All three interfaces are
covered at once, and a read through a stale mapping now raises SIGBUS
instead of returning stale data.

pci_destroy_dev() revokes after device_del() has drained the sysfs
attributes and pci_proc_detach_device() has removed the procfs entry, so no
new mapping can be established, and before pci_free_resources() releases
the addresses, so dev->resource[] still describes what userspace was given.

I/O BARs are mapped at an arch-specific PFN rather than at the resource
address, so pci_iobar_pfn() now returns that PFN instead of adding it to a
VMA's vm_pgoff, which lets the revoke path use it as well.  All three
implementations already derived it from the pci_dev and the BAR number
alone, so this is mechanical.  Only powerpc, sparc and xtensa set
arch_can_pci_mmap_io(); elsewhere pci_iobar_pfn() remains a stub returning
-EINVAL, now a static inline rather than a macro so that it type-checks its
arguments.

Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM # all of it...
---
 arch/powerpc/kernel/pci-common.c |  4 +--
 arch/sparc/kernel/pci.c          |  4 +--
 arch/xtensa/kernel/pci.c         |  4 +--
 drivers/pci/mmap.c               | 50 ++++++++++++++++++++++++++++++--
 drivers/pci/pci-sysfs.c          |  3 ++
 drivers/pci/pci.h                |  1 +
 drivers/pci/remove.c             |  9 ++++++
 include/linux/ioport.h           |  1 +
 include/linux/pci.h              | 13 +++++++--
 kernel/resource.c                | 33 ++++++++++++++++-----
 10 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 3c4ca90e2ab7..e983280c7248 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -501,7 +501,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
  * Platform support for /proc/bus/pci/X/Y mmap()s.
  *  -- paulus.
  */
-int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
+int pci_iobar_pfn(struct pci_dev *pdev, int bar, unsigned long *pfn)
 {
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	resource_size_t ioaddr = pci_resource_start(pdev, bar);
@@ -512,7 +512,7 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
 	/* Convert to an offset within this PCI controller */
 	ioaddr -= (unsigned long)hose->io_base_virt - _IO_BASE;

-	vma->vm_pgoff += (ioaddr + hose->io_base_phys) >> PAGE_SHIFT;
+	*pfn = (ioaddr + hose->io_base_phys) >> PAGE_SHIFT;
 	return 0;
 }

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1603d50fdcad..8e4eedfd3ecb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -753,7 +753,7 @@ struct pci_bus *pci_scan_one_pbm(struct pci_pbm_info *pbm,
 }

 /* Platform support for /proc/bus/pci/X/Y mmap()s. */
-int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
+int pci_iobar_pfn(struct pci_dev *pdev, int bar, unsigned long *pfn)
 {
 	struct pci_pbm_info *pbm = pdev->dev.archdata.host_controller;
 	resource_size_t ioaddr = pci_resource_start(pdev, bar);
@@ -761,7 +761,7 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
 	if (!pbm)
 		return -EINVAL;

-	vma->vm_pgoff += (ioaddr + pbm->io_space.start) >> PAGE_SHIFT;
+	*pfn = (ioaddr + pbm->io_space.start) >> PAGE_SHIFT;

 	return 0;
 }
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 305031551136..ea9cf832362d 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -74,7 +74,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
  *  -- paulus.
  */

-int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
+int pci_iobar_pfn(struct pci_dev *pdev, int bar, unsigned long *pfn)
 {
 	struct pci_controller *pci_ctrl = (struct pci_controller*) pdev->sysdata;
 	resource_size_t ioaddr = pci_resource_start(pdev, bar);
@@ -85,6 +85,6 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma)
 	/* Convert to an offset within this PCI controller */
 	ioaddr -= (unsigned long)pci_ctrl->io_space.base;

-	vma->vm_pgoff += (ioaddr + pci_ctrl->io_space.start) >> PAGE_SHIFT;
+	*pfn = (ioaddr + pci_ctrl->io_space.start) >> PAGE_SHIFT;
 	return 0;
 }
diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
index 8da3347a95c4..1969a93f64e6 100644
--- a/drivers/pci/mmap.c
+++ b/drivers/pci/mmap.c
@@ -38,11 +38,16 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 		vma->vm_page_prot = pgprot_device(vma->vm_page_prot);

 	if (mmap_state == pci_mmap_io) {
-		ret = pci_iobar_pfn(pdev, bar, vma);
+		unsigned long pfn;
+
+		ret = pci_iobar_pfn(pdev, bar, &pfn);
 		if (ret)
 			return ret;
-	} else
+
+		vma->vm_pgoff += pfn;
+	} else {
 		vma->vm_pgoff += (pci_resource_start(pdev, bar) >> PAGE_SHIFT);
+	}

 	vma->vm_ops = &pci_phys_vm_ops;

@@ -79,3 +84,44 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
 }

 #endif
+
+/**
+ * pci_revoke_bar_mappings - revoke userspace mappings of a device's BARs
+ * @dev: Device whose BAR mappings are to be revoked.
+ *
+ * Unmap every userspace mapping of @dev's BARs, whichever interface
+ * established it: the sysfs resource files, /proc/bus/pci or /dev/mem.  All of
+ * these map through the shared iomem address space at the page offset the BAR
+ * is mapped at, so unmapping that range reaches them all.  Subsequent accesses
+ * raise SIGBUS.
+ *
+ * The caller must have made new mappings impossible, and must call this while
+ * @dev's resources still describe the addresses handed out to userspace.
+ */
+void pci_revoke_bar_mappings(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		struct resource *res = pci_resource_n(dev, i);
+		resource_size_t len = pci_resource_len(dev, i);
+		unsigned long pfn;
+
+		/*
+		 * An unassigned BAR is sized but starts at zero, so revoking
+		 * it would unmap unrelated mappings of low physical memory.
+		 */
+		if (!len || (res->flags & IORESOURCE_UNSET))
+			continue;
+
+		if (res->flags & IORESOURCE_MEM) {
+			iomem_revoke_range(res->start, len);
+		} else if (res->flags & IORESOURCE_IO) {
+			/* Fails unless the arch can mmap I/O BARs at all. */
+			if (pci_iobar_pfn(dev, i, &pfn))
+				continue;
+
+			iomem_revoke_range(PFN_PHYS(pfn), len);
+		}
+	}
+}
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5ec0b245a69b..b4d138a484dc 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1714,6 +1714,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,

 	sysfs_remove_groups(&pdev->dev.kobj, pci_dev_resource_attr_groups);

+	/* The BAR addresses below are about to be reassigned. */
+	pci_revoke_bar_mappings(pdev);
+
 	ret = pci_resize_resource(pdev, n, size, 0);
 	if (ret)
 		pci_warn(pdev, "Failed to resize BAR %d: %pe\n",
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c..266b41e95e02 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -229,6 +229,7 @@ enum pci_mmap_api {
 };
 int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vmai,
 		  enum pci_mmap_api mmap_api);
+void pci_revoke_bar_mappings(struct pci_dev *dev);

 bool pci_reset_supported(struct pci_dev *dev);
 void pci_init_reset_methods(struct pci_dev *dev);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index d8bffa21498a..a9414c4ad593 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -45,6 +45,15 @@ static void pci_destroy_dev(struct pci_dev *dev)

 	device_del(&dev->dev);

+	/*
+	 * The sysfs resource files are gone, drained by device_del(), and so is
+	 * the /proc/bus/pci entry, removed by pci_proc_detach_device(), so no
+	 * new mapping can be established.  Revoke the ones that remain before
+	 * the addresses are released below and possibly handed to another
+	 * device.
+	 */
+	pci_revoke_bar_mappings(dev);
+
 	down_write(&pci_bus_sem);
 	list_del(&dev->bus_list);
 	up_write(&pci_bus_sem);
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index f7930b3dfd0a..ec1b2d08556e 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -460,6 +460,7 @@ static inline void irqresource_disabled(struct resource *res, u32 irq)
 }

 extern struct address_space *iomem_get_mapping(void);
+void iomem_revoke_range(resource_size_t start, resource_size_t size);

 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 64b308b6e61c..df426d054faa 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2274,11 +2274,20 @@ int pci_mmap_resource_range(struct pci_dev *dev, int bar,
 #define arch_can_pci_mmap_wc()		0
 #endif

+/*
+ * pci_iobar_pfn() yields the PFN at which an I/O BAR is mapped in the shared
+ * iomem address space, which is where both the mmap paths and the revocation
+ * of those mappings need it.
+ */
 #ifndef arch_can_pci_mmap_io
 #define arch_can_pci_mmap_io()		0
-#define pci_iobar_pfn(pdev, bar, vma) (-EINVAL)
+static inline int pci_iobar_pfn(struct pci_dev *pdev, int bar,
+				unsigned long *pfn)
+{
+	return -EINVAL;
+}
 #else
-int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma);
+int pci_iobar_pfn(struct pci_dev *pdev, int bar, unsigned long *pfn);
 #endif

 #ifndef pci_root_bus_fwnode
diff --git a/kernel/resource.c b/kernel/resource.c
index 3d17e3196a3e..6cf2a30e1109 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1265,21 +1265,40 @@ static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);

 static struct inode *iomem_inode;

-#ifdef CONFIG_IO_STRICT_DEVMEM
-static void revoke_iomem(struct resource *res)
+/**
+ * iomem_revoke_range - unmap all userspace mappings of a physical range
+ * @start: First byte of the range.
+ * @size: Size of the range in bytes.
+ *
+ * Zap the page tables of every userspace mapping of [@start, @start + @size),
+ * however it was established: /dev/mem, the PCI sysfs resource files or
+ * /proc/bus/pci.  All of these attach their VMAs to the shared iomem address
+ * space, whose page offsets are PFNs, so a single range unmap reaches every
+ * mapper regardless of the file it came in through.
+ *
+ * The caller is responsible for ensuring that no new mapping of the range can
+ * be established.  These are VM_PFNMAP mappings with no fault handler, so
+ * userspace touching the range afterwards takes SIGBUS.
+ */
+void iomem_revoke_range(resource_size_t start, resource_size_t size)
 {
 	/* pairs with smp_store_release() in iomem_init_inode() */
 	struct inode *inode = smp_load_acquire(&iomem_inode);

 	/*
-	 * Check that the initialization has completed. Losing the race
-	 * is ok because it means drivers are claiming resources before
-	 * the fs_initcall level of init and prevent iomem_get_mapping users
-	 * from establishing mappings.
+	 * Check that the initialization has completed.  Losing the race is ok
+	 * because it means no iomem_get_mapping() user can have established a
+	 * mapping yet.
 	 */
 	if (!inode)
 		return;

+	unmap_mapping_range(inode->i_mapping, start, size, 1);
+}
+
+#ifdef CONFIG_IO_STRICT_DEVMEM
+static void revoke_iomem(struct resource *res)
+{
 	/*
 	 * The expectation is that the driver has successfully marked
 	 * the resource busy by this point, so devmem_is_allowed()
@@ -1295,7 +1314,7 @@ static void revoke_iomem(struct resource *res)
 		return;
 	}

-	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1);
+	iomem_revoke_range(res->start, resource_size(res));
 }
 #else
 static void revoke_iomem(struct resource *res) {}
--
2.55.0

