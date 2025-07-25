Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C756BC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FFC6B008A; Fri, 25 Jul 2025 15:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2079A6B008C; Fri, 25 Jul 2025 15:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144B16B0092; Fri, 25 Jul 2025 15:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 071F26B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:12:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77DB81DBEA6
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:12:54 +0000 (UTC)
X-FDA: 83703734268.25.BA48E3B
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4BB7F180009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:12:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=DrqrpaR7;
	spf=pass (imf16.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753470772; a=rsa-sha256;
	cv=none;
	b=D/qO5SXuhZ4pWOdwLHbv6rIx+Roqi3h5qSKs/1T4g/ZBSwji/kng98elA/aExJ/DEA4sLr
	zjXY0/qsvq+AN2jrCxNWZMe9t2cTJh//wSsajUS/5RcsSanyd+TP+tb6xlf3a4IghqbaQ5
	AP/b+i58a/vo2oc0z65Gk5wcPypIYGY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=DrqrpaR7;
	spf=pass (imf16.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753470772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeOo9vMPBFT+62n5mqYkCAxWsQk1Wvt4dBFyCgwjFrk=;
	b=G1cZ+wul/CMioNEGvAjOMomDMZZYhthO4twa8PBMSsMFcgWwCr8BQCteEoGd6cQX8vCIxr
	gDYpuJRxAqdSFbeSJj1ickEB84gng3Y2/hQ7zDjtq7nHIpoctiXtW9Chg5+2UMeYuhFKfL
	IQX7UawqGtExfvNOP57OEbtURvAg08c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=EeOo9vMPBFT+62n5mqYkCAxWsQk1Wvt4dBFyCgwjFrk=; b=DrqrpaR7S9OrXgfKiTlAraouUx
	i4ghrIDe0rHZjeUNlfEzZoAUiPbvMyzYgY3NP/FMkua4fsEG4BUEfWmG08NaN3AJaxLLtN7IEqbhj
	4WALY5AeeenGjVOoB5wbIg0n3jzsD5dSSYuovvsWyo6RrCK5quFSZw02fh++FfvIYO/9zgKYx9SHc
	ffj80QXJEfFoR9tRFdpABXThOf1TAKdNiRKAY7HTLi6iU5GP9OmSa0ys2SxJ5ifdpvS0AuGd7so8G
	WtqXMuLWHNwwZap6WIJ6fbeihB/YIucDtjbo21c+DH8bj/20oQ4+GwAjSz3Bt9RGNE02AWYwVosV8
	6WQn0Kww==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ufNqT-006E5j-0X;
	Fri, 25 Jul 2025 13:12:42 -0600
Message-ID: <a749c502-7794-42f0-8f86-163efd4640b2@deltatee.com>
Date: Fri, 25 Jul 2025 13:12:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250725185402.GU402218@unreal>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250725185402.GU402218@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, jgg@nvidia.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BB7F180009
X-Stat-Signature: 4ccr7nqz85eg6i6cpfrkonaw3jt1y83y
X-HE-Tag: 1753470772-755708
X-HE-Meta: U2FsdGVkX19DoovyJbxs5lcd7up777lmuoAwo7pUNuIq0oQVvad0oRkd/wZlBERXaoGOTiVu6rboZOhnme6lVBGYs3YHuN3wwhv1MfxKP3P5HiGPMHflrKqi9ljypes+UOHjZDWZ6AWtF5BWe/wnz6d2HcJ2JrHBDs5xPKNIuMl12AWjsDWgnhYGAg8ErqG+pR8FPvs+dMueJ6/fKL6OtfeIjecWz/+JkRKO1XLUfrb1oOFdmp/Vi6cMTOx8kMZ1tPFzvIEEsUdodwkdrjoU1b8eLMvzbLfG2QTf5N0F9rdM0WODzrh5i7CK1j/hR5IZpyEy9vlIZj5zNpZpXOxvLzeFYBqdgzO/MWVW1Vo9b2+peNbDD9RlAaFJOf/oaT0+vrFEM/LG/atL15COSaXgGYHFLHaGtDWNrg8APbDQyFFxnL0zvHdrg2IYIG/ijI2SksN5OZcyDoLdnarqsvU679lBbN1VPdl9J/ZZTd2F6pDY3vgmaTuJ6lut7oYrRsW40O9Tgp2QzWIxyCXPPJ4pOKLtDhJqznRdpiYgitGL7xNB/2WQcpyMSk/ToHikbeKruTy96iQGOsg0L0aKi76CSkYKvbZSSzdFu8WDrHIJp4UyBPtD9122+dE1vnwVjK51Opeaueeq7MqQVUlE4LPtxJA44Mi0PhapROb6GcbxTUWzYbtbQ2zqigRYCVNnvSxPx79PWHYO/s5RS//Fco8/UTXOwz9CWllW5rFGjYNE00nsB5pdXU8Kvk4NXRkc38mQe7M73CD3SpLQZSKkLZPVo0sn/3+0PCg6sCKxLqGNmXTNIn8yBPBWEapMckEb+QcAApNkFbYuvw1hATJqsjuDqHGpLRoyBAhqNGpS0IvaGUyP3wRfth1rHysgSEAfT6EtAerdKgnJV+Mc0PLLmHdUaC7jaaVOTf6kh2A0blqkmPKabqkd/5P5vtkNG+yREjcRN6i7FR6rMobumXvq66w
 RBSUQgQC
 YCl1N0m+r+g/Phg8KfzxJfBOrjIMtDZ7nb/yhK7A5FnPUwq0fLgzqRs1DXM9egefr8GnKPTvDSqINDwhugVap2LHz1co4JHYC5o8792dKvLMPBNCxvkODNV/sKDTparI98nMuNfmatpaXfh6e6N4NrT7g2fhg+N5tsCmpTDIozivBVaPLXqylxFE+0ARVJdP3/ftoMmEOBsoE4LsekPtf/tILajJG6a5UUht+xdtKNzwXfTc4h763+XA8LjCLBzo1Hdz6qS1YP8l2EkibaPFSEmma3dBX2iQCtQC5cu7Wo9IS5SvBdMb0dBK3sfp50UX39/aylRsG7kvnvPqsy6eD+1eZAZtZ+YPiqCPO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-07-25 12:54, Leon Romanovsky wrote:
>> The solution that would make more sense to me would be for either
>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
>> P2PDMA case. dma-iommu.c already uses those same interfaces and thus
>> there would be no need to export the low level helpers from the p2pdma code.
> 
> I had same idea in early versions of DMA phys API discussion and it was
> pointed (absolutely right) that this is layering violation.

Respectfully, I have to disagree with this. Having the layer (ie.
dma-iommu) that normally checks how to handle a P2PDMA request now check
 how to handle these DMA requests is the exact opposite of a layering
violation. Expecting every driver that wants to do P2PDMA to have to
figure out for themselves how to map the memory before calling into the
DMA API doesn't seem like a good design choice to me.

> So unfortunately, I think that dma*.c|h is not right place for p2p
> type check.

dma*.c is already where those checks are done. I'm not sure patches to
remove the code from that layer and put it into the NVMe driver would
make a lot of sense (and then, of course, we'd have to put it into every
other driver that wants to participate in p2p transactions).

Logan


