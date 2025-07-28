Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D50C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAF36B0088; Mon, 28 Jul 2025 13:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2456B0089; Mon, 28 Jul 2025 13:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8CE6B008A; Mon, 28 Jul 2025 13:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE946B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:07:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B8021D897F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:07:51 +0000 (UTC)
X-FDA: 83714305542.21.685D9A3
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26E2618000D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:07:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=XHjgXFrK;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf24.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753722469; a=rsa-sha256;
	cv=none;
	b=QyadfNugc+MkM+jbsheQuiDCOsn2x2rsvyt0QwVPiFvMz8IDN+aNb+lerzcTybhBfHIyXl
	8T/sHw5Yh0O7cCt5r3A6GxF+l2AOrjryW0enS5CJYibvzZyJKax+wkEBugU6U0O3ei1GzZ
	6w+IZQiIJq0uGPIBFjDaMA3GD0H1zH8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=XHjgXFrK;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf24.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753722469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCTi7Vmk9aRE1IKFUsfxXldYjrZeeC/iIVRDXKgVHWo=;
	b=nDYKJVZ459O7Em6FovY4wtpKQDvYpbX5/LO0Fa98Pq3b45el846vQ8SJJj1msFM7NL2uBe
	DJmX6D/WTEIRGmIaZ1JoyuSIfsIBRK+yOhvYc6PhEXdQ//73bgheNLQ3JKZWZmx5UN4VJG
	oBO2cyhsWzTPGC9B1ZV76/Tn7FGe4Vs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=vCTi7Vmk9aRE1IKFUsfxXldYjrZeeC/iIVRDXKgVHWo=; b=XHjgXFrKuAhiveJ6zCrvJT8Pvw
	re9J8LZpJpl40TreVfHUPY2lnYVRFy+PufGoNxDVEgTuS0s84xxDxMwecbKLo3UpnvzoMVqFabY5O
	fns6daDQC4GZzjzk81dgUnIBncap8IUcFBgRQ+FDj7GtQEkK7F51IIrGWpfK4rRTXW5sfS9q1MDKQ
	6/wNP0s/OHbfhbpmZL9kyyw6F9TOJplnVRRzeSNunWZGOK7MaBeHKnz82mVkMDabojTslET5bVvMG
	d6AG/BDnrsJDD6etzDoLtYTAaCoD+hgyhnRjFdBQiaqbGi/0dIRgNCr5slZOAZysPyyIWQSEA7f7t
	Ibk+mOxA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ugRK6-008OdV-0r;
	Mon, 28 Jul 2025 11:07:39 -0600
Message-ID: <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
Date: Mon, 28 Jul 2025 11:07:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Alex Williamson <alex.williamson@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
 <20250728164136.GD402218@unreal>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250728164136.GD402218@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, jgg@nvidia.com, hch@lst.de, alex.williamson@redhat.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Queue-Id: 26E2618000D
X-Stat-Signature: 4icaxkfbx3j9omfg8sfrjh3ddm1gffq4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753722469-323535
X-HE-Meta: U2FsdGVkX18IBe3j233J+qPzmz6XA3EtN27EiWIUjHMM/iX0kEfoUuBviY2EdtXrMkKlq8kkGQQ3XmzrezoDYFTMpABKGyEY7e1hdtqBZMEcnrzuB2Z9jr9+dfQiwCz4WStMDufiy52IMbmxzBq6RdgfSE/EONP1zsVClIv8M43ywStZ0scjv5+Qmc2D434wN1xY9vihR8P42IvjMKk35RRuRfM4a4AaBm6Y8MJDwZfR1oLm2hrnSJf8Iuny/BHvWmGcCXzhM8wfiu2cJpcCVqHnSRGUHdaG/ogGkI6eisTT1cApZNWxKSTjkf+07MfXRhxfsjume3nu//kBT9Tdln2KhMVBHFiNhtzq1Ih64Fc4VEj3LlLZdF0cwfngd7pI2BOOyL7E/sGzSzK1EYHx2r25GEtjTDAldNbpJLdUPsOSrDY/51bpGAdJWJgIvTtS5l2ub3mdvhxKvURI4x6oGPoWOQF/PQFpNvvdzaiY4wYd2I/zKClyPBigiHPyO1I+/rxSccpVAraVl6FLHkVZsGNaSoyL6oGO8n03BFbmv0EH1NM5c1AmuS844bRTMULX1QiNd9R+y5qD7fpw4fd7FmVVhP4isteFLG6ZgNrHLghkLK1Bnh10kuPgSbJmXr805nBAbjxWv9ExIfONZmdYl/dDYQO+igj+5h7tbojJPV9BuFzMqm6YtcnDA8w+5wYnW/4t3kL7Rf8r3Ry7QQzLPdNQNlbS4T54r/rRgFxL6ESq7EPB8IQkUqy6bUgWsda15LNLdgQ5NxwRO+CNO6ONT8puTmHOyS1SfxSGIp2GTtGQP6sOILvmzGm9/47B00WPe5+NabjCjpy4FRWPYNRPwigN6CEyBIiSkcKi2pHkxE8hgK09IThzhiazISisVgYPNowNOdB+TyscwDd1h5eBhnu9cy6HMpI4rNow4JmXEBRJGPdytlLZ6j3tJ/pHGXRbxa6Y3PslrnD2x9t/n8r
 d2KAgU0b
 eIlQ9Ybhl+Is+5yS7H+ewidKiqAeCw2kvqG95OMTyAduKhktMbVsJnyVIp4zhBGz3lin5rWuZj+obrwiZYW0kqtdMnwSozQhi02uL07GZifatJM5Rq7RtmK9zCNeN62tf63IsANrDLe0LgkjNUMyCP1afClHYZMm+oiE0aBEayEZsRjwu97Xo68NZWwj3KLhtFyVbAiJzC6xOp/i0+XvfZGoWhv+wbrA+7nv4WUH03l5CkzEhuxW9ox64Iob0SqR9H0Ajt9gzV2I492pUkHnQkiLUosqZ3MXXByGZd1lnTT+SW4eT2ZJbWSJzegJWOhEfvp9rbYBT7Z32touDXg/Ep1Rn6GDBCHowq76dqf/1G16EI6ZQH+ZHOlQH+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-07-28 10:41, Leon Romanovsky wrote:
> On Mon, Jul 28, 2025 at 10:12:31AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 2025-07-27 13:05, Jason Gunthorpe wrote:
>>> On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
>>>>
>>>>
>>>> On 2025-07-24 02:13, Leon Romanovsky wrote:
>>>>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
>>>>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
>>>>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>>>>
>>>>>>> Export the pci_p2pdma_map_type() function to allow external modules
>>>>>>> and subsystems to determine the appropriate mapping type for P2PDMA
>>>>>>> transfers between a provider and target device.
>>>>>>
>>>>>> External modules have no business doing this.
>>>>>
>>>>> VFIO PCI code is built as module. There is no way to access PCI p2p code
>>>>> without exporting functions in it.
>>>>
>>>> The solution that would make more sense to me would be for either
>>>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
>>>> P2PDMA case.
>>>
>>> This has nothing to do with dma-iommu.c, the decisions here still need
>>> to be made even if dma-iommu.c is not compiled in.
>>
>> Doesn't it though? Every single call in patch 10 to the newly exported
>> PCI functions calls into the the dma-iommu functions. If there were
>> non-iommu paths then I would expect the code would use the regular DMA
>> api directly which would then call in to dma-iommu.
> 
> If p2p type is PCI_P2PDMA_MAP_BUS_ADDR, there will no dma-iommu and DMA
> at all.

I understand that and it is completely beside my point.

If the dma mapping for P2P memory doesn't need to create an iommu
mapping then that's fine. But it should be the dma-iommu layer to decide
that. It's not a decision that should be made by every driver doing this
kind of thing.

With P2PDMA memory we are still creating a DMA mapping. It's just the
dma address will be a PCI bus address instead of an IOVA. My opinion
remains: none of these details should be exposed to the drivers.

Logan

