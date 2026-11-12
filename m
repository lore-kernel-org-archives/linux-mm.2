Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50242606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZUR1Pivf
Received: by kanga.kvack.org (Postfix)
	id 517786B00EF; Wed, 11 Nov 2026 20:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C81C6B05B0; Wed, 11 Nov 2026 20:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F886B05B1; Wed, 11 Nov 2026 20:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1043F6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:49:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97C67140493
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:49:09 +0000 (UTC)
X-FDA: 85424784018.26.C75314B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8F3E2A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:49:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZUR1Pivf;
	spf=pass (imf25.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794448147;
	b=H/SLTPjFgNiRWxvLm9YSXCqhJZ8L0JP6VP9nUSvJoLoEXp7VJ04fFtwVM4iUAQZXva7qVU
	RlOcQxu9XMyRV656Nwot7GlNTDFBgrKjJ6AdgKNbOl+F/ZJT79Oz1J+wnMRL3ABWIxyM/B
	O2nXBbIkL+2J6jzHDqjz9XaSv2K9Gf0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZUR1Pivf;
	spf=pass (imf25.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794448147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vIz8xYau+WtFrk0xTr9b5QoDkJ8T5uH0TopCPW+Ht0=;
	b=L/rC++HspHdjRVK+JnVNHMtiaL9v531MmSlmGHr7YtOtPz8GlvjluT0AuFYD1Z5d4xZm9E
	XUcCRxyBquZc8Zr43K99ENAAWZQ+JOSnhvYvbLZxBYEKqSvHXiYPj6z1MdstZO1H485Qsg
	9r9QtJz8pa6wc+bCUy14YwMsitYNRTo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=8vIz8xYau+WtFrk0xTr9b5QoDkJ8T5uH0TopCPW+Ht0=; b=ZUR1Pivf7YfAPwvJVMDDsk3Jzp
	0grOW/HpN24mmm5CWYJw548vD7py3YwdfURplC+tK3WNgHgaeIg97N5X5IGC60uprIDaFcaXyldV0
	2DDUf82sallNIesdaI5ir+Q5DxcH4WUNSi3ZaXYfklmnu+JhczffaiyoWlhpis9DDh7ke2D0Wnm1/
	E8ejpeBozWlDmjGCvrWyNho5YVnSCC5MJdfvxhCr1tpAItxFYwXbla0UNRiy8fC7NOVOGZgzTMGDD
	cy9/lqEVBA9tJCrOPHsaM7rk7Dslgfi23hgjhP/gtg02gehiZhyG+jNlFvmxiYZaacJUI0k6lYz0T
	MxJBZESQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRJvz-00000008RjV-3qVJ;
	Thu, 12 Nov 2026 01:49:03 +0000
Message-ID: <e6f8e81b-3c49-4112-b119-778fb8b89f38@infradead.org>
Date: Wed, 11 Nov 2026 17:49:02 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/40] nitro_enclaves: Add support for Nitro Sandboxes
To: Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>
Cc: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, linux-doc@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 nh-open-source@amazon.com, linux-mm@kvack.org,
 Jonathan Corbet <corbet@lwn.net>
References: <cover.1794300002.git.graf@amazon.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4n1urpf8zzwgkyq847tfc9t9j7szucfa
X-Rspamd-Queue-Id: 8F3E2A0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794448147-974477
X-HE-Meta: U2FsdGVkX18/H7BSPP2N9QJ/J0zyR3B05D2u0XnvY/9sIIEcItNwYNUfoFzluViueqCLvaB4iRdrdhcc/ab1RNcb5wVRp/zVSLTb5UImB6LLLpOBDSh/hsWwBM6xWUJuccVscpqks989hePUYURg+ovoonU+hpRISGK8zZjy6/D1ZLVTHi8XrvmHBZPuIOzmxJND5y2xcLeo3Ti+5A+rK9Yyjv3TL9ykkY/je4D6FDDAoyWeXXJMd+3dCEl0U41WJdpUyOBKpV7uk1oobpqireuHrYYTEVLqtun132yEuJJp+2QxBIqVgUl8jcuSUyaWQ7BEZsN5QNAyKzpusP4PO0/s+xlvDG2aU0bQQOfXqiBvMMLW6Ral7wXKQi9OrB1fdR0Bk07aRenfl8gMln601tCPG6BV2d7UyPPFDwjVIqivnzLpwCRKaawgFflnqH70E130cGdM9df9Fj5V1jp7rKdztdbIez1gE/EwQlEW8yka7oJ+tbskySxKi3KWjK7iiYBK1Qx/8ksrzuLGa6KN8R4sVUD9GGLj8OxHStw4RlJ4mtWhYsaDQpabQQ7kfFbwRx8IEklcUCqBvpftVkDjawdzx3lrVl8wUXNXvlbQdeqaVICWuN3zBGzRc0Exve3W+8Dgc0S9Vl/uCCK1Fy1cbl4fmBolwAQyi/Sk+Yy+rddNwlDyUBUw5Igba45dP6orvdyyf+KFnvLfySSjGxb9jYnzR60gtd3y1Qsgvh8eSwqIkJVhL1mfYsWaWfhy9ntKMMGF9wQ6OT0WztL9HqVxf2sCvvO7b/o6Oi8f+Z5oWCG8aZLy2gX+7S8S6/W3pd7dDJhc4OCKN12KgbaAgcl7fds0IJ9qinUB17iEHyY912cRRBQHcbkSsodVE48sbGbdjvQLEvjN0pl3DD56B2lWLyvlXNkZXMfkXfKbTLkrpFhWFUfj6OAy+BmevNQV2EzM2jlXyj5cxtSWlNauKQG
 8sT5is2k
 8C8N3cS+ZsYnbJKDP0yp+dbAwJ44TZXdGwz/hn7INBuv6dHASyQdg+s96tc27J0dv+YAScBVnYdCCqklDKisEMPZr5NGv2tqY9WzMD7cdiYcqjdYGneqvGoANlQ2ypoW9calVxnovKAySSxq9xGAEv2LCAJ0JBu5QtBg5WTVZpBVkowUybsqCwBUow7BIpX/44mfz+87x3xPLcZtny50mzfhCBy/gf6O7/xxVQaQzWdvJsBGOoLHqo/G5hQ3aZT7OqxQ+kcxD3OhRdo6oBv4ciYZ3c37zJqIy9Tsd4U0EBoeKj15OSRbsifQrRWZud6iVyrithyw6Gl9TctJQyeTXjqPc4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 2:41 PM, Alexander Graf wrote:
> 
> Alexander Graf (40):
>   nitro_enclaves: Allow the CPU pool to span NUMA nodes
>   nitro_enclaves: Add NE_ADD_ANY_VCPU
>   nitro_enclaves: Expose CPU pool state under sysfs
>   nitro_enclaves: Document multi-NUMA CPU pools
>   dma-contiguous: add dma_get_numa_cma_area() accessor
>   nitro_enclaves: Allocate physically contiguous enclave memory
>   nitro_enclaves: Add NE_MEMORY_SHARED
>   nitro_enclaves: Add NE_ADD_MEMORY_REGION
>   nitro_enclaves: Document the memory pool
>   nitro_enclaves: Add NE_CREATE_VM2 with a launch flag word
>   nitro_enclaves: Add NE_ENCLAVE_PCIE_MODE launch flag
>   nitro_enclaves: Name the device's error codes in the UAPI header
>   nitro_enclaves: Log a reached device limit at info level
>   nitro_enclaves: Add NE_SET_INFO_PAGE
>   nitro_enclaves: Document the info page in the memory pool
>   nitro_enclaves: Turn the command reply into a per-command union
>   nitro_enclaves: Add the slot pool donation commands
>   nitro_enclaves: Donate memory for the slot pool
>   nitro_enclaves: Add the slot pool growth commands
>   nitro_enclaves: Add a helper to grow the slot pool
>   nitro_enclaves: Document the slot pool
>   nitro_enclaves: Expose slot pool state under sysfs
>   nitro_enclaves: Add the device add command
>   nitro_enclaves: Add NE_ADD_DEVICE
>   nitro_enclaves: Read the interrupt multiplexer geometry at probe
>   nitro_enclaves: Donate a bitmap page per multiplexed vector
>   nitro_enclaves: Dispatch multiplexed interrupts to per-queue bindings
>   nitro_enclaves: Add NE_SET_NOTIFY_EVENTFD
>   nitro_enclaves: Report the device's info notification
>   nitro_enclaves: Count multiplexed interrupts under debugfs
>   nitro_enclaves: Map the doorbell window at probe
>   nitro_enclaves: Add NE_SET_VRING_CALL
>   nitro_enclaves: Assert the layout of the ioctl argument structs
>   nitro_enclaves: Pass on the Nitro Sandbox launch flags
>   nitro_enclaves: Add NE_ENCLAVE_DIRECT_MODE
>   nitro_enclaves: Add NE_ENCLAVE_PCIE_HOTPLUG_MODE
>   nitro_enclaves: Add NE_ENCLAVE_CPU_OVERCOMMIT_MODE
>   nitro_enclaves: Add NE_GET_CAPS
>   nitro_enclaves: Add NE_UPDATE_DEVICE_CONFIG
>   nitro_enclaves: Document the driver side of Nitro Sandboxes
> 
>  .../sysfs-devices-virtual-misc-nitro_enclaves |  232 +
>  Documentation/virt/ne_overview.rst            |  256 +-
>  MAINTAINERS                                   |    1 +
>  drivers/virt/nitro_enclaves/Kconfig           |   19 +
>  drivers/virt/nitro_enclaves/ne_misc_dev.c     | 4832 +++++++++++++++--
>  drivers/virt/nitro_enclaves/ne_misc_dev.h     |  206 +-
>  drivers/virt/nitro_enclaves/ne_pci_dev.c      | 1568 +++++-
>  drivers/virt/nitro_enclaves/ne_pci_dev.h      |  599 +-
>  include/linux/dma-map-ops.h                   |    7 +
>  include/uapi/linux/nitro_enclaves.h           | 1182 +++-
>  kernel/dma/contiguous.c                       |   36 +
>  samples/nitro_enclaves/ne_ioctl_sample.c      |   10 +-
>  12 files changed, 8282 insertions(+), 666 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

That's 7.4-rc1, but I can't get this series to apply cleanly to
7.4-rc1 or linux-next...

IMO it would be better if the series applied to something
newer than 7.4-rc1.

> prerequisite-patch-id: 542b3d78fda912095b75a49becd1b93109befdbc
> prerequisite-patch-id: 318368e966c1925652b7976948f435d42b87c72f
> prerequisite-patch-id: eb35b5d713e7f50f6d1d02310c9afe10b1628fc6
> prerequisite-patch-id: 223bf6e60620ca8fe72f3ff6f3bd3f5839cdd6d5
> prerequisite-patch-id: e5305ce0515a02f7f88e72adf02c6a2bee2fd2e0
> prerequisite-patch-id: 759b5920f842d70e675770608d9088639c10559e
> prerequisite-patch-id: e1837df37663da3d3ce53afa4594828b2d602152
> prerequisite-patch-id: f0d4302bd36f94de95951a0db1ae9eb9747076aa
> prerequisite-patch-id: 41159b92e250fef705be52f714b6e2761a2cd1f7
> prerequisite-patch-id: a0c3a56907acac2297c800209faa2849a8df0e48
> prerequisite-patch-id: a80a95bd682b540be5760e8fdf7044379fe32d61
> prerequisite-patch-id: 9c01e0fecd6810f3448582715c87cd3dd7a6cdf1
> prerequisite-patch-id: b94dfc8bb1039740d88a30535445bb7b3dd1fe74
> prerequisite-patch-id: bd76f15728dc0ee2ca3417cd95a6b23a7d63e91f
> prerequisite-patch-id: 0c60f1574b590f68885a25760017e9ff87752f66
> prerequisite-patch-id: 63dff43da52934a6e6f5e65c3e235a7114b6b4dc
> prerequisite-patch-id: af52cf938525874cadd6d879aa76495e563876d2
> prerequisite-patch-id: f53ee22764b5f13708cacd3e48a59a82d71a270c
> prerequisite-patch-id: 258b8c18168db49aacbda5156e33978b539666ab

-- 
~Randy


