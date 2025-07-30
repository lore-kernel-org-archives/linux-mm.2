Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F613C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36266B008A; Wed, 30 Jul 2025 07:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5B86B008C; Wed, 30 Jul 2025 07:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB5D6B0092; Wed, 30 Jul 2025 07:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 773B96B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:11:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E602580539
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:11:41 +0000 (UTC)
X-FDA: 83720665602.02.808614A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF2F1180002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:11:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753873900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tTgLyvTZgN5Rt8Z+AwFysB1xxPIwzHY5WQRBxQh+D0k=;
	b=cKCeGuU2UW1TVZH7G0/Obk/nWhVNPGZ/+aOORursVY9VShGz+zw5YTVMl1EgmXav8mrmkB
	jp3dlkRLJz6HErEQBYQc6w+vLnHvB/4wBTmt0YR7damMZ1wQ5P7LyWI3y0Ub5LOfnIUZM7
	Bs2mZ9HNiio3BdOiNClRiRpS/uE4aM0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753873900; a=rsa-sha256;
	cv=none;
	b=Yg50WuoE+0aU7ypHnWntGbdNBM1RJ715+o7WObdrmV24YqghpgkFBMvEls59TQ/A/1LZ0D
	92MfJiohNcPpBZlR8zvjHPP64IfDzOw5n3XF/zdPFnh7MN3NfJx1wq0dpetDvl3KrzZYkD
	Ku1u0cYeFeWPHBaJCs3IgNbAkoMMz4M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E047C1E5E;
	Wed, 30 Jul 2025 04:11:30 -0700 (PDT)
Received: from [10.57.3.116] (unknown [10.57.3.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E3A73F673;
	Wed, 30 Jul 2025 04:11:34 -0700 (PDT)
Message-ID: <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
Date: Wed, 30 Jul 2025 12:11:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 iommu@lists.linux.dev, virtualization@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal> <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1c5uj6yb9kk3os8unkoqhgxtw6s5oq78
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF2F1180002
X-Rspam-User: 
X-HE-Tag: 1753873899-990820
X-HE-Meta: U2FsdGVkX182+bttvc7fipLjjgRT2Wn2xuIbUHekRyFcJrbeEYNjbCzQsFh0GEHuobjCZkqCMGyLnikiMhIhtzu8Ylgq7dBGch37JcH6cGUufHtGy3UjeKUr5kguZS55I+GSyC9roBSKBLS/uAGOIujL32novsahRJT0xUzoxsVbltApQSvoppn73TgnxtaEsDlk6LBkjTtzXa3SHEwdFFW30shsWoNVLC6bMkx1SVHHqeltCgSJT/mG581E6VW9bPAC0u4VBB60qlCgwx/hDXcDZm+xJkqs0XazbmcHg8h1QNKqve89DXs34qLj6PPF1+737SK7sBWBtL6DuFUDsFGH3MiNb98qJpC1/Jvznj3m1aPmUBn0CJM1M6VpX7oqMBxxevB2jSXUxrg+2ibMhOUs3C6sTmiot5pk5gCW5VVzZv+EdEy+K7zcTfGQi2r1mDQ89XDBaWpDrVbYqrq16Dj55YZtcvAjV2qD6SD68YvnzaWRBwyrfxZ7uHy6PSq3Jqu7g4/0udHn9lHZcMU+Uqui3zr0csCH+It2XuVt/4BHqFpZ5uxpQSD5dN3YAmIl4hark29nJY7V/5NbHaeW1GlQaNo8sKyrpBQLL5EO8LlJ5XNUv3ccgD8CgU4dGN5zO2pALx8Lsmf66kqAxlWoYfuDEaFdfZBcfKSIBySOsS+RfgmmfLIGR+NgE4u1cfcw16i90204YyZqfmNS+iWZwTcrrLsaoDr/9xY5RdY4ZZtwKyghObSFRWsxoqfCsrYnCHo0XlHP0Plq4VTb16MFA9SuhwCMh7aoelSweIXImCRWSYIQlXta5dKyIQXGBaPQCxke1ik1/qwse+pOReveBVf9Pcqp6rVUsOAtLR481IX3Nf9Qqa7SteqoC75qIt4hB/ndDFaQcZLu6c+aTYxoG4ohqJ06bV+q68WDESCleO2qMFJg2h8sMdE1GS/dJXG/6+TqLZP6QTZkSEDUOMQ
 q8OHs8NB
 fKcbJAw70L2BilNmvWwFDenFLMKkdy94B/fjFEe8SFpmRrThZv5q6rkvY1XKgQgTaf53oBgv0chZxjFt/RM4f1Rihuqki84I/fEqy6pxfcQlENojiPycrK5zNqB7E4sYJVnXtvVTJKcFeRvw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-07-08 11:27 am, Marek Szyprowski wrote:
> On 30.06.2025 15:38, Christoph Hellwig wrote:
>> On Fri, Jun 27, 2025 at 08:02:13PM +0300, Leon Romanovsky wrote:
>>>> Thanks for this rework! I assume that the next step is to add map_phys
>>>> callback also to the dma_map_ops and teach various dma-mapping providers
>>>> to use it to avoid more phys-to-page-to-phys conversions.
>>> Probably Christoph will say yes, however I personally don't see any
>>> benefit in this. Maybe I wrong here, but all existing .map_page()
>>> implementation platforms don't support p2p anyway. They won't benefit
>>> from this such conversion.
>> I think that conversion should eventually happen, and rather sooner than
>> later.
> 
> Agreed.
> 
> Applied patches 1-7 to my dma-mapping-next branch. Let me know if one
> needs a stable branch with it.

As the maintainer of iommu-dma, please drop the iommu-dma patch because 
it is broken. It does not in any way remove the struct page dependency 
from iommu-dma, it merely hides it so things can crash more easily in 
circumstances that clearly nobody's bothered to test.

> Leon, it would be great if You could also prepare an incremental patch
> adding map_phys callback to the dma_maps_ops, so the individual
> arch-specific dma-mapping providers can be then converted (or simplified
> in many cases) too.

Marek, I'm surprised that even you aren't seeing why that would at best 
be pointless churn. The fundamental design of dma_map_page() operating 
on struct page is that it sits in between alloc_pages() at the caller 
and kmap_atomic() deep down in the DMA API implementation (which also 
subsumes any dependencies on having a kernel virtual address at the 
implementation end). The natural working unit for whatever replaces 
dma_map_page() will be whatever the replacement for alloc_pages() 
returns, and the replacement for kmap_atomic() operates on. Until that 
exists (and I simply cannot believe it would be an unadorned physical 
address) there cannot be any *meaningful* progress made towards removing 
the struct page dependency from the DMA API. If there is also a goal to 
kill off highmem before then, then logically we should just wait for 
that to land, then revert back to dma_map_single() being the first-class 
interface, and dma_map_page() can turn into a trivial page_to_virt() 
wrapper for the long tail of caller conversions.

Simply obfuscating the struct page dependency today by dressing it up as 
a phys_addr_t with implicit baggage is not not in any way helpful. It 
only makes the code harder to understand and more bug-prone. Despite the 
disingenuous claims, it is quite blatantly the opposite of "efficient" 
for callers to do extra work to throw away useful information with 
page_to_phys(), and the implementation then have to re-derive that 
information with pfn_valid()/phys_to_page().

And by "bug-prone" I also include greater distractions like this 
misguided idea that the same API could somehow work for non-memory 
addresses too, so then everyone can move on bikeshedding VFIO while 
overlooking the fundamental flaws in the whole premise. I mean, besides 
all the issues I've already pointed out in that regard, not least the 
glaring fact that it's literally just a worse version of *an API we 
already have*, as DMA API maintainer do you *really* approve of a design 
that depends on callers abusing DMA_ATTR_SKIP_CPU_SYNC, yet will still 
readily blow up if they did then call a dma_sync op?

Thanks,
Robin.

