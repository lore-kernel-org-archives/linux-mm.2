Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838F2E75442
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 09:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965646B0005; Wed, 24 Dec 2025 04:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9130C6B0088; Wed, 24 Dec 2025 04:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811F86B008A; Wed, 24 Dec 2025 04:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA746B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4BFBC14F6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:22:50 +0000 (UTC)
X-FDA: 84253824900.01.F1B8D47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42EE540006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:22:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BCkI51xV;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766568169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU3FU5hJ/uFF75kzgkL1MaSTVaAZHMpcC+UByasmyNs=;
	b=WMYs60zPPc9E+EGMR7BVv2vnyBQGe4c0G/sYVjDReZno5frOhrA45jAdVDVEAO+HoHKdxD
	OIQJVW7WYhoaLIU7O9YW4EHtpmUSy70QWnDYEiYFNAiMzvQ2uJSN0BofzcWUr0/q2C10oT
	52tAehfVeknAKrHj4+f378JR9Oey8Fo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BCkI51xV;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766568169; a=rsa-sha256;
	cv=none;
	b=sFO2p4wLnHIFz6jbPcMoo5Rpv0P58fqaUH1zlLctyrmYJq/8MHjGztp/n4GNd4RteTyqck
	3Z5XhJSVDVyEd7MxM75NOXoGkUDqGBkePIfdphkM5fpPTQ0nsK13764JQ8oKyKXudfHbLr
	zxpJswUGsFeCnJQS4ibKpoHg5aoIiRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 498EE60017;
	Wed, 24 Dec 2025 09:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A6EC4CEFB;
	Wed, 24 Dec 2025 09:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766568167;
	bh=9OEO/JCs0BjLukCm//EkrDbgU9VMrzlMsA88lCY5hGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCkI51xVQCyd338Mh8k6YDydutGxW9LmK1CZQTQOp9ZNqX6dJ8MesvyXVBlPUP5rd
	 UiAtC+tgEIeqZCTuAG9axT7FHxvnsXz1iPbuLahLRMXMSGzdxvZFuTmF8WQ7V5R5/S
	 tNBBHQ50i61ChoLK+Gm43OowSe75BX05sloy512mIvMTWtRS0mpc/i44AmziYybD21
	 U4MC8Hl+0ZCGiGDxAm+HKsa8sWadq6NKd5D3W7Rsk3iyLfdXAvgJYzo0mA9Z5OWIbK
	 kTTmdzZ/q0bg1IuxI41xhsaQwdjS845Op6Jh/ai49K58EEjfjfay4UD62j5jtnkLwE
	 tVgdauP5tojoQ==
Date: Wed, 24 Dec 2025 11:22:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 00/13] Enable compound page for p2pdma memory
Message-ID: <20251224092243.GG11869@unreal>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251221121915.GJ13030@unreal>
 <416b2575-f5e7-7faf-9e7c-6e9df170bf1a@huaweicloud.com>
 <996c64ca-8e97-2143-9227-ce65b89ae35e@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <996c64ca-8e97-2143-9227-ce65b89ae35e@huaweicloud.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42EE540006
X-Stat-Signature: 7j5mmexouyms65e7cmbtwcbkusyzh7ru
X-Rspam-User: 
X-HE-Tag: 1766568169-363563
X-HE-Meta: U2FsdGVkX1+tzRtgqASMzmTmjAb5OlWBzDwdBmfSoQYb34e9mQiR3KQi/c/y/Fs5zlNSjR4Jhn1GXvtPiPlSp5WCCtzZvpFOgwG1IlcmhUX/1ntx6Qj0LcX+SC0Ya7P4vsDhpGv6gO0eXhep0z99SSq/2htFhsK1aLXJnI6KepoVJfztTV6TQDl3mbMBW8q2Ck7CPhVEZSvTlnv6iEFaM/DwBUmCQ8Gogw7JCuPwkqin37nF6tSceFCC0b1LUN30e8Ropx1QlEnTAAvkmYZq5Ausr/gUrcCLaMSkWIF7OfPRNIiQYtmTKuY9JIqynS3Cjau+akUINjhVNB9XHzJTf+TWBYwwZAW7uRjJZY+VjR3qW6EDCeR1vddRS8K3gO91fBiWmWzHbFCCn/+mxBQXXeG4X53zzvRok9MP2CG0nrqUQwBuBr80SAdh7U+8MvXX/VQISyDP4SiwP6efQ9WyyFqFskqotpnRKnF3X9BB4WkeIHwRF1dBITY+TrbogXaH6k4anpriRJ/aYXlD47L6YYvn/fk/gPQDmeC0O54DHg1z3e9Wc4q/fRm4hk5T3kHZ89G7kwPTIAbu0qS48STI3tM1Ii2qeUFDOnAeWEbEH9sGmT+6rXbOX8XfrG0t9+CsH7lkyTfAGPMMmz4P34jngtZei59HU1uuPk47q6XKIpTFLhs7KHywm7HvT+3qEu+1oZhdhKFEM1Kt2jnGG3qR7g8MojvLA7o6btSBEcPOxlooGc/PhuzobcQ8Xle854p/uGV9Pa+xI/uzBueqqnMjoRX4tvHZ7dtl6nWCSCokBJ2z5TwMhLDmUlD0gsXATi3f98DjWtEQITRROXi4sFp293Dnp/GNpdG00dNfl40LTYNvBlKz3IRXcATPaCHIYyFqx9Amxe72Ags28Iz/6YhXHK6Q2Q0PKubcPAJn6/gPwphghjYpKXyNsSGW2EZLGhbyDyaBjlQJrJwhfj2y3ME
 FcQUtIQm
 51xZs5hKtASaDo8Seg0ChLgVNcfRDKZQSGURQEVkUXqoAqsDudtcH37mwgSo7K8HyulJtttsYLr0LRUTl1U0WjcTi6NrBYQnhJ8ebcyeRHdfciSXVSONlVjHSAc914uB3tGaZnS29AbpX2dH8QSQmGF2hTo/11pGOAi0fVwuRxN/WeMVNvApqizw4V90p1qh7c/w2IZmIYYyKXcUKFgJTq3qxQ9CqrsU8yCHEuyUmkrXjXA51jGkNF32RSU0quGHLndwDf4A8arzc5pe8c6P9kfYhi1ebeKoSV+cklXQgGbmaAvmsehTqmCLyzMGEPf1ybYmSpl6o+Hcjg5OxISrTdAvV/umqe9GOHG/z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 09:37:39AM +0800, Hou Tao wrote:
> 
> 
> On 12/24/2025 9:18 AM, Hou Tao wrote:
> > Hi,
> >
> > On 12/21/2025 8:19 PM, Leon Romanovsky wrote:
> >> On Sat, Dec 20, 2025 at 12:04:33PM +0800, Hou Tao wrote:
> >>> From: Hou Tao <houtao1@huawei.com>
> >>>
> >>> Hi,
> >>>
> >>> device-dax has already supported compound page. It not only reduces the
> >>> cost of struct page significantly, it also improve the performance of
> >>> get_user_pages when 2MB or 1GB page size is used. We are experimenting
> >>> to use p2p dma to directly transfer the content of NVMe SSD into NPU.
> >> I’ll admit my understanding here is limited, and lately everything tends  
> >> to look like a DMABUF problem to me. Could you explain why DMABUF support 
> >> is not being used for this use case?
> > I have limited knowledge of dma-buf, so correct me if I am wrong. It
> > seems that as for now there is no available way to use the dma-buf to
> > read/write files. For the userspace vaddr backended by  the dma-buf, it
> > is a PFN mapping, get_user_pages() will reject such address.
> 
> Hit the send button too soon :) So In my understanding, the advantage of
> dma-buf is that it doesn't need struct page.

The primary advantage of dma-buf is that it provides a safe mechanism for
sharing a DMA region between devices or subsystems. This allows reliable
p2p communication between two devices. For example, a GPU and an RDMA NIC
can share a memory region for data transfer.

The ability to operate without a struct page is an important part of this
design.

> and it also means that it needs special handling to support IO
> from/to dma-buf (e.g.,  [RFC v2 00/11] Add dmabuf read/write via io_uring [1])

It looks like that read/write support is needed for IO data transfer,
but you talked about CMB.

I would imagine that NVMe exported CMB through dmabuf and your NPU will
import it without need to do any read/write at all.

Thanks

> 
> [1]
> https://lore.kernel.org/io-uring/cover.1763725387.git.asml.silence@gmail.com/
> >> Thanks
> >>
> >>> The size of NPU HBM is 32GB or larger and there are at most 8 NPUs in
> >>> the host. When using the base page, the memory overhead is about 4GB for
> >>> 128GB HBM, and the mapping of 32GB HBM into userspace takes about 0.8
> >>> second. Considering ZONE_DEVICE memory type has already supported the
> >>> compound page, enabling the compound page support for p2pdma memory as
> >>> well. After applying the patch set, when using the 1GB page, the memory
> >>> overhead is about 2MB and the mmap costs about 0.04 ms.
> >>>
> >>> The main difference between the compound page support of device-dax and
> >>> p2pdma is that p2pdma inserts the page into user vma during mmap instead
> >>> of page fault. The main reason is simplicity. The patch set is
> >>> structured as shown below:
> >>>
> >>> Patch #1~#2: tiny bug fixes for p2pdma
> >>> Patch #3~#5: add callbacks support in kernfs and sysfs, include
> >>> pagesize, may_split and get_unmapped_area. These callbacks are necessary
> >>> for the support of compound page when mmaping sysfs binary file.
> >>> Patch #6~#7: create compound page for p2pdma memory in the kernel. 
> >>> Patch #8~#10: support the mapping of compound page in userspace. 
> >>> Patch #11~#12: support the compound page for NVMe CMB.
> >>> Patch #13: enable the support for compound page for p2pdma memory.
> >>>
> >>> Please see individual patches for more details. Comments and
> >>> suggestions are always welcome.
> >>>
> >>> Hou Tao (13):
> >>>   PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page()
> >>>     fails
> >>>   PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()
> >>>   kernfs: add support for get_unmapped_area callback
> >>>   kernfs: add support for may_split and pagesize callbacks
> >>>   sysfs: support get_unmapped_area callback for binary file
> >>>   PCI/P2PDMA: add align parameter for pci_p2pdma_add_resource()
> >>>   PCI/P2PDMA: create compound page for aligned p2pdma memory
> >>>   mm/huge_memory: add helpers to insert huge page during mmap
> >>>   PCI/P2PDMA: support get_unmapped_area to return aligned vaddr
> >>>   PCI/P2PDMA: support compound page in p2pmem_alloc_mmap()
> >>>   PCI/P2PDMA: add helper pci_p2pdma_max_pagemap_align()
> >>>   nvme-pci: introduce cmb_devmap_align module parameter
> >>>   PCI/P2PDMA: enable compound page support for p2pdma memory
> >>>
> >>>  drivers/accel/habanalabs/common/hldio.c |   3 +-
> >>>  drivers/nvme/host/pci.c                 |  10 +-
> >>>  drivers/pci/p2pdma.c                    | 140 ++++++++++++++++++++++--
> >>>  fs/kernfs/file.c                        |  79 +++++++++++++
> >>>  fs/sysfs/file.c                         |  15 +++
> >>>  include/linux/huge_mm.h                 |   4 +
> >>>  include/linux/kernfs.h                  |   3 +
> >>>  include/linux/pci-p2pdma.h              |  30 ++++-
> >>>  include/linux/sysfs.h                   |   4 +
> >>>  mm/huge_memory.c                        |  66 +++++++++++
> >>>  10 files changed, 339 insertions(+), 15 deletions(-)
> >>>
> >>> -- 
> >>> 2.29.2
> >>>
> >>>
> 
> 

