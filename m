Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73ECBE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7DB6B00D0; Sun, 21 Dec 2025 07:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96036B00D1; Sun, 21 Dec 2025 07:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9950A6B00D2; Sun, 21 Dec 2025 07:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 834116B00D0
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:19:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A992137D65
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:19:23 +0000 (UTC)
X-FDA: 84243383406.26.7CCE933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 881751A000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:19:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkR4deFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766319561; a=rsa-sha256;
	cv=none;
	b=OF2sQkl5sHPasVkKeDbLd9Te2BgBaB2isqSX37649vgJcPhSkp1ZD75uRw12/tBIPk7Pll
	04ocB6UecNh1Eaua40GBd62o6Mir/q5dqP60LXMaq4VIeSRsAC1XM1vqf6XtFZZGAD4IQn
	Szv0atoVo0LiH3/DK11vNVYhDXEr50g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkR4deFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766319561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltBr3XzB1GrPvRZcKpV7voX0AAOWySj0uwjCYD+lBmY=;
	b=W9vOL8i7OmQJ0stP7rhmnrce+A350ewEEZXqdVQ3anK73uXgUN8jc+2zlNMDmuBvTpN96m
	w7rWe6VfzAVa284WJY9IlyZgQ1cxm7PCJehqy/bqZhCn4G9vZddBsVZkQNTbAyop2QURxv
	v8PdjAG2DYeA33pg4gjiHndkkQZ55e4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9CA160007;
	Sun, 21 Dec 2025 12:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6261BC4CEFB;
	Sun, 21 Dec 2025 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766319560;
	bh=ZeOPwShHRhwYUB1pry9WKHZ3vg3L8IaUwEYKG8XWhQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XkR4deFJRzYHolHakfbtdIDJtIK9Yk8DEnj/EqcYYdZgFW2I1C4gWIMRhYEV5SKlb
	 zNNLh8pdxlqTYU8eLvtzQuykfloKYp1KfpB9SWgR6ATsaOlCXkSzolIV4RqxuYbkNu
	 Qezx9UnTHfcahw/4ucIhdrMlFMdPbBrRUTgqw4qP7l6X2MRvlprvOu6D1F35hO3i7I
	 gvWhoZ0/htR6bJx7t+Iwr4AoPRZlXmIRhv7uSUibBOmkzDZB8FmpHXChxqlNfMx3DS
	 8SoqCN11kEmL2lhLaJZPKGoubgNsGbJu+CBNrzIOwiRaqNY0G3olfpPtH8xPiYE17/
	 SD8VhXCcxIn8Q==
Date: Sun, 21 Dec 2025 14:19:15 +0200
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
Message-ID: <20251221121915.GJ13030@unreal>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 881751A000C
X-Stat-Signature: hpnxer5mctaiet19b6n666z3doxirryn
X-HE-Tag: 1766319561-501303
X-HE-Meta: U2FsdGVkX1/xx9AErUB8v865lQObE8v3TuOx2EL0eUZIRerVhY02AwEbsTiwAqwp+o1KRA+3H+L6+b+xqNz+fLTlbKcSVDKV96oa754qkT5QJ6U3CMBYlZMVhmCD+nl2NODZdfOLSfKMHLRzPWvaShGqVZArEhyz/+NysVcktrEuw975fzLryOFIqU0AbyR5jIHk9dY5duVs5NKyPtmkd8QoLjfzjG0f0y+RfLJ3rQsDMBHeCmzwBPLX0zckwodoy9w9GQ0UOaPcLyWSmc6DILjakNJVCkLu0vmgkJjzCREP96/rPpw/STHo2w9iBbO9EBx99C+2jTLmjw42Xnihqd4k+LFfs3a/H/Wbsv/3yXDMBkRvnucmsv8Z0D3269ZbmJHPnJD6SqPYpaXYt0SMO7x6b6H3eEAiCDoTG/n1rsrKDb0x8pR8gia4p1QYCNkM6gZuxj+Jz1o0gTCNgtS7iysLkOeILUlHWNkrOLKKM/iLC2WqBj+K/1t7DaXyqgDlTVP/IDTpuYYfYPcaMKBxFWlTnOT+iGEZ18Liku+jGq2a45sAoCcUY8ZXfjl490sHTq9XSJG+sYkCCmQs0KEzFMf0Hs/uf7wenjx9n0b4KGAjUWZQ8ceAL266LFlTjy+o6N/6RpBwsT4C6bQYjo2m1BU85hW0dincIcXrg9mpXzPI3Y+5yLUWzvTawefTKk4Tl9T108mCFIqhBOWR9P2Ra71uJ62TfONNYsy7mqIAWgyOXiQcbsu4l32aYUNhiK24bJd8SDFGxmSNdqqWsV3js66+rcNYmh8Yy8yecAicJbNGdUsgkQlThE1sNu43hY22JkUwbIY4g5rmXmXBb9CeHIFbLjk/TRFwnrxIm6z1zOHtyoeqTYmhZT660cVPTxUbxHnT7GR84u7orehkjdOOx866rXpKu1Ye9qt7mbM1axXYbn2J2KzhrEmFQ1CTWLxGJz6A9pyeASHNFygmrLX
 FrTpvXCf
 QRV11fIm6v2CJYyfsRVkVC8QcY+Q+lU1i4qu8iTXur/HONMifT3eZshiu6QkDORdqsJfGmx4rVPmrx9b3idRNUJFB78X+GrC+bYtoj9y+ugSZScBPlHtFyJUMS9B2henFi0p+tZwx3gIPzYgaF+FE/9DouCmVz+R4GEuQw5OA79yA8zZt4LycaNaYWDmO0w0VpPBzoKGRqcQ7ZrBIlb+3Arq+540QNyk4wcH2AKcDF6bZuo2hsriOz46h+l9n+GPsEB0E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 12:04:33PM +0800, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Hi,
> 
> device-dax has already supported compound page. It not only reduces the
> cost of struct page significantly, it also improve the performance of
> get_user_pages when 2MB or 1GB page size is used. We are experimenting
> to use p2p dma to directly transfer the content of NVMe SSD into NPU.

I’ll admit my understanding here is limited, and lately everything tends  
to look like a DMABUF problem to me. Could you explain why DMABUF support 
is not being used for this use case?

Thanks

> The size of NPU HBM is 32GB or larger and there are at most 8 NPUs in
> the host. When using the base page, the memory overhead is about 4GB for
> 128GB HBM, and the mapping of 32GB HBM into userspace takes about 0.8
> second. Considering ZONE_DEVICE memory type has already supported the
> compound page, enabling the compound page support for p2pdma memory as
> well. After applying the patch set, when using the 1GB page, the memory
> overhead is about 2MB and the mmap costs about 0.04 ms.
> 
> The main difference between the compound page support of device-dax and
> p2pdma is that p2pdma inserts the page into user vma during mmap instead
> of page fault. The main reason is simplicity. The patch set is
> structured as shown below:
> 
> Patch #1~#2: tiny bug fixes for p2pdma
> Patch #3~#5: add callbacks support in kernfs and sysfs, include
> pagesize, may_split and get_unmapped_area. These callbacks are necessary
> for the support of compound page when mmaping sysfs binary file.
> Patch #6~#7: create compound page for p2pdma memory in the kernel. 
> Patch #8~#10: support the mapping of compound page in userspace. 
> Patch #11~#12: support the compound page for NVMe CMB.
> Patch #13: enable the support for compound page for p2pdma memory.
> 
> Please see individual patches for more details. Comments and
> suggestions are always welcome.
> 
> Hou Tao (13):
>   PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page()
>     fails
>   PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()
>   kernfs: add support for get_unmapped_area callback
>   kernfs: add support for may_split and pagesize callbacks
>   sysfs: support get_unmapped_area callback for binary file
>   PCI/P2PDMA: add align parameter for pci_p2pdma_add_resource()
>   PCI/P2PDMA: create compound page for aligned p2pdma memory
>   mm/huge_memory: add helpers to insert huge page during mmap
>   PCI/P2PDMA: support get_unmapped_area to return aligned vaddr
>   PCI/P2PDMA: support compound page in p2pmem_alloc_mmap()
>   PCI/P2PDMA: add helper pci_p2pdma_max_pagemap_align()
>   nvme-pci: introduce cmb_devmap_align module parameter
>   PCI/P2PDMA: enable compound page support for p2pdma memory
> 
>  drivers/accel/habanalabs/common/hldio.c |   3 +-
>  drivers/nvme/host/pci.c                 |  10 +-
>  drivers/pci/p2pdma.c                    | 140 ++++++++++++++++++++++--
>  fs/kernfs/file.c                        |  79 +++++++++++++
>  fs/sysfs/file.c                         |  15 +++
>  include/linux/huge_mm.h                 |   4 +
>  include/linux/kernfs.h                  |   3 +
>  include/linux/pci-p2pdma.h              |  30 ++++-
>  include/linux/sysfs.h                   |   4 +
>  mm/huge_memory.c                        |  66 +++++++++++
>  10 files changed, 339 insertions(+), 15 deletions(-)
> 
> -- 
> 2.29.2
> 
> 

