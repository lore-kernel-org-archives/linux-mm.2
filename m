Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2904C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 16:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5367F6B0092; Wed, 30 Jul 2025 12:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E066B0093; Wed, 30 Jul 2025 12:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B846B0095; Wed, 30 Jul 2025 12:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 345476B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:32:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D762F59281
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:32:52 +0000 (UTC)
X-FDA: 83721474984.20.EE57A4F
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06C48C000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:32:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=tQBF5gQj;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753893170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSL5Fd5ey+NSvWwk5RIT5oUBgeHAV3OrGjQZ6pf7CNI=;
	b=SPeNqaZspEX12w0wjUY2tBRd0oAZ+pTCn1SqudGShPjmZkztKwc1SutoLj6al484QBfDjM
	WJ2g08MG4fYpGuwIHm3/lZnoUCUgCJjTbGJqqcyygPIY9SicXvHjEkd6BSm6y36tTc7Ln0
	H8cAymNcFZwpxsq9GMJO6vX/WuUZtFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753893170; a=rsa-sha256;
	cv=none;
	b=F/qFYan2hsU56yq9Y07LNKSbaKZnfCON3WagLHgbRHehAT1p1SE3ZYW2k0bj281zgMVmk2
	Lc/O5jzpuPSnNRm4OzrTyjJoSZIVdI7CpHioWSt+V3ReZGihhgx+xHcIlmYwhW/TQO19Ms
	zGUpkrU1Di4b3vtaV4xbKwefFYXiQLs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=tQBF5gQj;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250730163247euoutp0123cd10879d63b6e4cc4a50e42983a196~XFIsds6So2008220082euoutp01C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:32:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250730163247euoutp0123cd10879d63b6e4cc4a50e42983a196~XFIsds6So2008220082euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753893167;
	bh=BSL5Fd5ey+NSvWwk5RIT5oUBgeHAV3OrGjQZ6pf7CNI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=tQBF5gQjRFWWD3NkMzd2sWMQdocEpPuublYXo+DODrhkpC+sAkqpV7G/5+SLj9y3k
	 FAXICFoay1/ibpDiaHyufgBQba2SMsBA7uyao3fLdxKNV0z8FjK9Dw3fJfuRxBPoak
	 rpKYzTJHpu47CanwUZWJZBKrP3JwtACld7b3bvho=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730163246eucas1p2c966d8d5061fc0214cf993906aeab2f5~XFIrva-kQ2815928159eucas1p2i;
	Wed, 30 Jul 2025 16:32:46 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250730163244eusmtip2f48699419babf589223e18bf9ee0d79d~XFIp1n5Qn1925219252eusmtip2o;
	Wed, 30 Jul 2025 16:32:44 +0000 (GMT)
Message-ID: <ff84b386-4bfa-423b-9364-040598a1ece0@samsung.com>
Date: Wed, 30 Jul 2025 18:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
To: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leon@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
	Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
	<eperezma@redhat.com>, Alexander Potapenko <glider@google.com>, Marco Elver
	<elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	iommu@lists.linux.dev, virtualization@lists.linux.dev,
	kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250730163246eucas1p2c966d8d5061fc0214cf993906aeab2f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf
X-EPHeader: CA
X-CMS-RootMailID: 20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
	<cover.1750854543.git.leon@kernel.org>
	<35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
	<20250627170213.GL17401@unreal> <20250630133839.GA26981@lst.de>
	<69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
	<f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
X-Rspamd-Queue-Id: 06C48C000A
X-Stat-Signature: x8b1p4d7eu5tia1u4k349nun7a1t9cf4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753893169-977641
X-HE-Meta: U2FsdGVkX1/P7vYoTvgIdJf0JKo/+JDi2f+LqWMsTYXAIn08n3N5rwlCciu8FtibB97kynIxuCzvNBh2eNb5z0+jlX1dgCiPQHTBAF27F3WbG/65PEjhPPDbAVX+YWg/ySc5nJXhwiID/SJgcJat7M4hVYj7D09cqkthNm38wxI9QPSeRt8p19c4mCzfW17mQA1+SDde5T1Zw4wPTdnP1pw3gKPPrtt8yza+fmdSH/PX2ZZafF49B9VSOdhowi6yol6Tw+31/qVq5BxdyrLv6q9bpY9AmdyrTySbEBGGeb0lSGoMuXr9c5+ILH01AkcPpPp2m/8MELJnc7ZFlujF0Roc3Bg2wcygIiO81s2xGN1cagdXU2UuXoZ3qnuftJ9y6kjeu59FeVTnSdc1eq89ikxFoQ9l/CpIb7afNVFs24d0F0r307PNfx1o36FFqhbVcapTaum26M0UAP7NB/Z8o5/caTavmH+xMlO8iS5JcV4HkhKbtRIi1XWGq4JagQrhftWMV8bHA5CsTTsQDCDRzA50mHuIHGSzxIhkO//Su3ooWeC9W/oRbKaLoZtC3TO9W/udg/FMo5uDg21MUkV5uKyLwVdpztpbtj9GgZC9gEAwXDEyEYh81ve072ZNWDjIjui7VmQj6jSO2oHXD+j5DSJ5hmwJ8XBdeuWvT62KEn2j/MrjMd+oLk5oSVVLFLA3wImvPSrNK+CMxFEQ3DbsirFMhsGjZJJPWeWh0nacsF44GIP7Sao6eWyPn9CwcHV38qNsQgkUtbq0XYOouimfgdEcQwQEibpLXbA8jWC1pCSutcOhtGcPhbcoTUApDAdomVVCQ8DPTydZ5AEGV8bQkP1TgQApGt+UvMDoNd46p/sujN94AjrcjalNs3NqqKma9XynBybUejSYx5JKJ9C7XQaPR5R+9nBeTd2yt8UW/OcJp/WJXuNDerc7w+Yw/VVmyUc7ROGycMhiAG5hqMO
 YQYdFA6o
 kkdc7/pGw+HVE2E60bTyRQak9mlyKbXziVZxJ2aTkbTugamaMMtqpOueA/DooJ7atm8mue6pE2RHGFQpP4csxfr0YBwIntLX/mAE7cHUYTo9p2iQNPrg6uV4aRi3NQLU8JSSJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.2025 13:11, Robin Murphy wrote:
> On 2025-07-08 11:27 am, Marek Szyprowski wrote:
>> On 30.06.2025 15:38, Christoph Hellwig wrote:
>>> On Fri, Jun 27, 2025 at 08:02:13PM +0300, Leon Romanovsky wrote:
>>>>> Thanks for this rework! I assume that the next step is to add 
>>>>> map_phys
>>>>> callback also to the dma_map_ops and teach various dma-mapping 
>>>>> providers
>>>>> to use it to avoid more phys-to-page-to-phys conversions.
>>>> Probably Christoph will say yes, however I personally don't see any
>>>> benefit in this. Maybe I wrong here, but all existing .map_page()
>>>> implementation platforms don't support p2p anyway. They won't benefit
>>>> from this such conversion.
>>> I think that conversion should eventually happen, and rather sooner 
>>> than
>>> later.
>>
>> Agreed.
>>
>> Applied patches 1-7 to my dma-mapping-next branch. Let me know if one
>> needs a stable branch with it.
>
> As the maintainer of iommu-dma, please drop the iommu-dma patch 
> because it is broken. It does not in any way remove the struct page 
> dependency from iommu-dma, it merely hides it so things can crash more 
> easily in circumstances that clearly nobody's bothered to test.
>
>> Leon, it would be great if You could also prepare an incremental patch
>> adding map_phys callback to the dma_maps_ops, so the individual
>> arch-specific dma-mapping providers can be then converted (or simplified
>> in many cases) too.
>
> Marek, I'm surprised that even you aren't seeing why that would at 
> best be pointless churn. The fundamental design of dma_map_page() 
> operating on struct page is that it sits in between alloc_pages() at 
> the caller and kmap_atomic() deep down in the DMA API implementation 
> (which also subsumes any dependencies on having a kernel virtual 
> address at the implementation end). The natural working unit for 
> whatever replaces dma_map_page() will be whatever the replacement for 
> alloc_pages() returns, and the replacement for kmap_atomic() operates 
> on. Until that exists (and I simply cannot believe it would be an 
> unadorned physical address) there cannot be any *meaningful* progress 
> made towards removing the struct page dependency from the DMA API. If 
> there is also a goal to kill off highmem before then, then logically 
> we should just wait for that to land, then revert back to 
> dma_map_single() being the first-class interface, and dma_map_page() 
> can turn into a trivial page_to_virt() wrapper for the long tail of 
> caller conversions.
>
> Simply obfuscating the struct page dependency today by dressing it up 
> as a phys_addr_t with implicit baggage is not not in any way helpful. 
> It only makes the code harder to understand and more bug-prone. 
> Despite the disingenuous claims, it is quite blatantly the opposite of 
> "efficient" for callers to do extra work to throw away useful 
> information with page_to_phys(), and the implementation then have to 
> re-derive that information with pfn_valid()/phys_to_page().
>
> And by "bug-prone" I also include greater distractions like this 
> misguided idea that the same API could somehow work for non-memory 
> addresses too, so then everyone can move on bikeshedding VFIO while 
> overlooking the fundamental flaws in the whole premise. I mean, 
> besides all the issues I've already pointed out in that regard, not 
> least the glaring fact that it's literally just a worse version of *an 
> API we already have*, as DMA API maintainer do you *really* approve of 
> a design that depends on callers abusing DMA_ATTR_SKIP_CPU_SYNC, yet 
> will still readily blow up if they did then call a dma_sync op?
>
Robin, Your concerns are right. I missed the fact that making everything 
depend on phys_addr_t would make DMA-mapping API prone for various 
abuses. I need to think a bit more on this and try to understand more 
the PCI P2P case, what means that I will probably miss this merge 
window. I'm sorry for the lack of being active in the discussion, but I 
just got back from my holidays and I'm trying to catch up.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


