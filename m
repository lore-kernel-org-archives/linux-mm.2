Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46912CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A136B0005; Wed, 17 Jun 2026 14:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AE66B0088; Wed, 17 Jun 2026 14:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FE96B008C; Wed, 17 Jun 2026 14:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE6306B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:34:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E44CA054C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:34:14 +0000 (UTC)
X-FDA: 84890254428.27.8D1B3E7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id D9C0A10000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:34:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rLMLw3YE;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781721252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2GzHzkNl51kx/TX95UyoFQNPNRSdhNZlHgf3FbcUJc=;
	b=JARNnj7qO23u2GVili78G5gOiqiG3x1rZ9e+cHitnCK7E1JzSRA72n1iZKTmf7fY3NjpB4
	7tlXDD+Ij/ux4NnZ7EwUPUDb5S8GX25/GYgPocM8JVLlE/FT2n0exxDMJNJDK32XqZ32Bq
	0jaerq5InU8QT9ywnrNQ/CCGrmP8INk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781721252;
	b=T7OC1iTvWVtpTz+odq5CIVx4VsyWkkigx665Qwt3CXaERwf2/OUB4QJKF2oOdXeqlWS5Ur
	knJbAEE9vLfKEo4LMtN3b1ddM8pUNzTF3v9R0t5usfyJcSjoGEN69VJQlmaH1PXWvIv810
	bprTC4qKGCG3RkVzMkFSAMfZc7/Q3P0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rLMLw3YE;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k2GzHzkNl51kx/TX95UyoFQNPNRSdhNZlHgf3FbcUJc=; b=rLMLw3YEoEOEr4GC3HjqsVN3af
	ogDDH3MXIW5LxCe18UNZxkZbGgFXjecx3HxK5Ce7kp75qLNsTleOWoIkQsuIcQxL0BshPFQfLIBfP
	RQS6aJelEiko5Deu5BohD05WYoQyhnBegQGWhcc+FgEmGOOBAPgx+dsj1TtwFIm3LrHTYOdonbRPa
	pon9W6r06R2BzJB4L6Euv3bMJZBkTGKQebWT/h+23YSJoxkVHil433iE4OuTE9ptbcld4/f3eUzys
	raN3Ro3ag4Q7zuazH0AHrYBQpuN8lC39+9ZaCK1zTkeOkLbXZ7dCVZ0rk75B+ZAs0Rn8Os7y2Emhd
	UWr2TBYQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZv5T-0000000D6IK-05Yq;
	Wed, 17 Jun 2026 18:34:07 +0000
Date: Wed, 17 Jun 2026 19:34:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajLontmFa1oRXeoK@casper.infradead.org>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajKtdCN0AlbmBnAj@x1.local>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9C0A10000E
X-Stat-Signature: xn4cdzj46he3r3dhbsg5xcysek33y456
X-HE-Tag: 1781721251-979806
X-HE-Meta: U2FsdGVkX1+qpvXymdp1mHQlq+p9bkFmjGMQhzlQ6PSuDRFyAnVZQjoq1O6satWlVmSoFVr3CWY0Oyof4ABKwI0xb0xzmgvn+7rOSa7WmhYWoC9M5kBuGTgTSPmS2+KLGx6RxbAnK2JnKW0lYwtKZd8T4pP20Q/3OsaXdsJ2IXqezGj4Hv9jwiYqcX0+igAVLZlekHY7EgvPCz3l52+WtmsdZaDbvHtQPB9U6fa9iDvxPHfuBUVVdgu7H5Vm5NuBtEkXrHUmQ2ZxBVXOfMmNEKZuX12aWT1bsPEwqSKYy3lunuRYwH+vi81OTKMOqKpdZv5R4Aq4hBzUAhAzzAJM5VLGmbjm7C2Ak3SFFcv52mo/GcNucNhE7ahXiJMi0/6EYabb+OlDs0k6tCTOo1tzf4swoPsN3PvTQmK1703XE/9uS2LY9BpLgTN8VFmObHoZ+Sa8/ULeeMZRRWJdz8LtpL3yvSi7C/NttBtq3R9l9OueqYqE+9oVlb1oS8xD0kFWIovyyce6QqMsjQTYlstu6zLCBA6A0daY3cSavpAVd8GC/JpmyPwbRgQjys/oATIRdUmtOKId8pHx0I0cfiH2Qn/Ash2KWxQ2EdTeb3Mwk3CbWbrNRux3MR1IgwctX3e9iGB89oLVwMEBO+t5NjaWmwyWdXws2+geKRbulS2qUxH5krQFPrEnoHUWPYzDh77bhGexGX/ULNXOg6zHv5XORwMLNWNNpJkQKhgXf5ndDbQ/W/cKvQQ3Jb7lrSoU02/NRMZPJmF3PxXbDwxB+/Yc2NDEhe2zt2db83dkfnNoFaZBdU+6DfLDshKTsg8VCUg/CRquXPOpjXBzMjzyF6gu2uXUqyeP5S8T5l4XSmfQaT/OzbS82EuCZbpbKpFxjE9DKaAMRMOY9SHCQeo6IUIBfeKS1GEbbubo30B09Ot14Kejxsxfh/dSsmAJanIVc2t3f8Bquegp0fMyRr37DAu
 oi+V1+Rl
 K8K9DIcWox9VSTEimbAIWQNrcWXTf47zsDYVhQZYW/wfFH4d0auircKyXJx8VkP5wT1HQJ839vtYTj1EnqDLhjLGtbj/lq529tsM6Ea+78TmDL9X+ZVhB0BK/XqVeGrtw7595o4dVpa1abjwMg0vH5y/q35TRT/d2G+Vsqvz0gUTxmtd9NoxWAhY09n4jblp01fCtzuY918aFR3TMe76iDjy5mUtz0kMQVQwSKnc/G4n+VMOcpg40QXSqeaSZAps6/WZ+QXWj6tmSZ5mZKksGHvm93nDuaru773FU3o/MuwgWHQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[why on earth was stable@ cc'd?  adding/removing various other email
addresses]

On Wed, Jun 17, 2026 at 10:21:40AM -0400, Peter Xu wrote:
> On Tue, Jun 16, 2026 at 04:30:54PM -0600, Alex Williamson wrote:
> > On Tue, 16 Jun 2026 14:01:29 -0400
> > Anthony Pighin <anthony.pighin@nokia.com> wrote:
> > 
> > > VFIO PCI devices support PMD-sized page table entries for BAR mappings
> > > via their huge_fault handler (vfio_pci_mmap_huge_fault).  However, the
> > > VFIO device file_operations never provided a get_unmapped_area callback
> > > to request PMD-aligned virtual address placement from the mmap address
> > > allocator.
> > > 
> > > Before commit 34d7cf637c43 ("mm: don't try THP alignment for FS without
> > > get_unmapped_area"), this was masked by a bug introduced in commit
> > > ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()") which
> > > inadvertently applied THP alignment to all file-backed mappings,
> > > regardless of whether they provided a get_unmapped_area callback.
> > > 
> > > When commit 34d7cf637c43 ("mm: don't try THP alignment for FS without
> > > get_unmapped_area") correctly restricted THP alignment to anonymous
> > > mappings and files that explicitly opt in via get_unmapped_area, VFIO BAR
> > > mappings lost their PMD-aligned placement.  Since the huge_fault handler
> > > requires both the VMA start address and the physical PFN to be
> > > PMD-aligned, unaligned VMAs force a fallback to 4KB page faults.
> > > 
> > > For example, a 2GiB BAR results in 524,288 individual page faults
> > > instead of 1,024 PMD-sized faults, increasing the VFIO_IOMMU_MAP_DMA
> > > pinning time by orders of magnitude -- a regression directly visible to
> > > KVM guests during PCI device initialization.
> > > 
> > > Fix this by providing a get_unmapped_area callback in vfio_device_fops,
> > > following the same pattern used by ext4, xfs, btrfs, fuse, and other
> > > subsystems that benefit from THP-aligned placement.
> > 
> > The trouble is that PMD alignment isn't right either, your 1024 PMD
> > faults on a 2GiB BAR would be 2 faults on x86_64 with PUD mappings.
> > QEMU has forced the alignment to make it optimal for some time[1], so
> > there are userspace VMM options.  Seems like you were previously
> > getting lucky.
> > 
> > Peter Xu was working on a more comprehensive solution[2] late last
> > year, but it seems there was an objection to the
> > file_operations.get_mapping_order() proposal before Plumbers and the
> > thread hasn't rekindled.
> > 
> > Gentle bump to Peter and Willy that maybe we could resurrect that
> > effort.  Thanks,
> 
> Yes, since QEMU doesn't need it, it was low priority on my list (also due
> to much more downstream works recently, and a lot of things happened).
> 
> I can definitely try again.

I don't see this as being something that drivers should be involved with
at all.  The MM should be able to get this right without any hints from
the file-provider.  Yes, that means I also want to get rid of the setting
of get_unmapped_area in ext4/xfs/other filesystems.

Looking at generic_get_unmapped_area_topdown(), I think we can do this by
making an additional call to vm_unmapped_area() before the existing two,
setting info.align_mask and info.align_offset appropriately.

Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
then >= PUD_SIZE), but we should also take CONTPTE architectures into
account.  And maybe there's a CONTPMD architecture we should also consider?

Anyway, that's my initial thoughts.  Perhaps others have feedback.

