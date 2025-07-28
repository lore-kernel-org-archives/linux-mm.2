Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDEFC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7126B008A; Mon, 28 Jul 2025 12:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80FE6B008C; Mon, 28 Jul 2025 12:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948756B0092; Mon, 28 Jul 2025 12:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8F26B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:13:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECC511402E4
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:13:01 +0000 (UTC)
X-FDA: 83714167362.19.CA1D3B6
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0A6D160011
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:12:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=NuShxQGB;
	spf=pass (imf08.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753719180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSF5wX9vjIP6fRF1ybWxqYJSZXcEgqAR8cCPBeo7HdU=;
	b=P08ZKq9vPu5TUbG4/xUV1E+haGZ/k9sAkcLq7wdvXEj5v1EcbIT8EGZIT0/0HQ6Xq7GWnL
	bjNYziVmuCu9rLBSl27Z7Xgz10gvmyXeoxsPrFcVh91jenCQI5yC4JCeQpuHQoi/f+ocZJ
	ZSQBzs+iNxpMgIijs/CsAs0BxVS/zUc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=NuShxQGB;
	spf=pass (imf08.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753719180; a=rsa-sha256;
	cv=none;
	b=LAnfZDS8wVr80BwcOfCpuSns71L7sWTInOiXIL5IEEPLBT87fMJJaN/kh/A//khcxSsJ95
	mQIVtxr9KrPEQIhSFkhS09rf1wO0ks57dasOvvCNGPkQ4fQV6eCIGHLi1VrmND1q0WcweZ
	q0qAeguyRo3FP7YdtE4UGnJhAH0eSr0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=VSF5wX9vjIP6fRF1ybWxqYJSZXcEgqAR8cCPBeo7HdU=; b=NuShxQGBV5IaVLB+r9+8Z5iKvq
	dFIGr5esAaj+hCO3a4jw+w6/OlzvIoB6kvaxTwpkrr6lmTchzYodZvaI+lNSnKbAzMm0EglMM03Vv
	crZTKZAcuqrSFjxZewSYCzRT/HYo/mkFbMKO7es26V5QoeFZvRVj7QgbRx/G4WDAZX6VXrq9/YsDD
	xRRo8ObEJbFOXuNbyFVv5S0ZE/n4R76NpOr3WVRG9mlUx6T3DEJBkwhVcxvUHoaulcQa3MefNqBEW
	9lVNjow5xoGlNwMQVVuWUtFAwKyMGUtxejZnJC6r2JA2ZkfHlVUptsg1l/w1rFXLBfEBhBC4DZjlx
	SCCTlj+w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ugQSy-008Nxz-1h;
	Mon, 28 Jul 2025 10:12:45 -0600
Message-ID: <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
Date: Mon, 28 Jul 2025 10:12:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250727190514.GG7551@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: jgg@nvidia.com, leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Rspamd-Queue-Id: B0A6D160011
X-Rspamd-Server: rspam06
X-Stat-Signature: dj57qqkeu5kfpz1f9x6f89e5ft8epa5e
X-HE-Tag: 1753719179-312644
X-HE-Meta: U2FsdGVkX1/NPfHOObF4Cdse/hjYvvMX253Evvj30nKHYNQP8a12/Ym5XA326+8svfSTW4vaqmzSTtHPnTciIjmk/g8y+Cxw/H3971QOVgLI9Gv+t4Qlve51Fq1KTzCeJNBu314qr3cPpf0aIbgQYlWLiZKf5nKTwVb9+ZppPHpS4zy+uoJGZ6v7OlynkoDpCP/HtEsjAy3lZgMup9tMokDantWzShPJcE39XKnJNqYGEW7uiTdapsb4McKw9tG/hPmqstz5eyNdTur77e69+gSBJPENvopg8Yy+sSRjE7vuK4iQe7PKFcG0Af9IzWt6kkBUikPv5ebTRTBUsTNvwRVzy4K3gZUD6vOx5Cvhbc5fpAIVhnqRa2OjeXbSMQXI9si9ZmKtlop38GQDJlcmjgY7gINxZSm22f9HcPkgwz49GVNbD8rq5GXmFpWLJK0HP5bbZbj401Y0i85/ZWH/5WfJjd9qvLuA/lm0wjIqRt9fEHu/CSMpFVnMUmD1EDoODx5QUcWQdI6WmuNi/8yQVEQEVsUoKZm0BKibStidTTqpFHrx45TgIHMA0m35iPslRqkigThtnZfXc4OJm3GfOn+b16jguDDQkhRmW5X/M5S0PuwT4ZpqF4p/hY2fkB/VCSnRdQnViE1RSgPlkh43+3ndjpXjPFJOJHNVbTfj2ZaVKPwrFgkuzudZYHn3TEWlleqG8j+TTUkkNkwHG+sXkXHnCmvJGSAtafDV+/LkdZIEVCLgkvN+mafuPCPW3mpV+Bh7LSm7QIX+Q+hEUEF9lk1lfvxkI0tYzu0+oO2exlPeefFqvtSYJsz2B2bZF4sGbQsBgioad8Ef+1WI9CTnvNhXK2w5g6LT2IENZg9Zr4zzh4ErYjE8Ue+Q7DCzR9un5A/kCpl0r2tQrCMxuhsryiqRIHfgRXiQqnqW5tNwjfOO0i5M/L39fnZlEHVCVIMQCuxAbyOAsHNsOxROGFP
 k7pUuk4S
 V35VbUX7zTF6SdRuk/4Hyd977/09u8H+l6ec3/ONvhTwmlOBrZ63DOfzNFef+36BWCzsLtvbNPu4jpmDPtlWAkszYuk/EXsVdpGoBzL439gIGiUGv+9L0+f125gd7rdFPKu8u4+2/o0gavaCaQsiih2R+L4NHyiQSSINDuqNBdw7JQut8WZ+rLJD3euvjuBMPIMqQIfkVpLwt3B5mBejfqQt0YTt0D3pByR+btWXMRymFS3kHmBjbfbrpqdNl9WmM3j1S62ZnQVI2id+MOJAD4taKW5coN3z5GaEujDrKAxDotrjgEQnINXU1NRoxY9qbuI+rrdh3Hgjbc+Whw1kUMVI2ueet87QzJ2LAmg1WZOAmIRpsFzaKP0SuCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-07-27 13:05, Jason Gunthorpe wrote:
> On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 2025-07-24 02:13, Leon Romanovsky wrote:
>>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
>>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
>>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>>
>>>>> Export the pci_p2pdma_map_type() function to allow external modules
>>>>> and subsystems to determine the appropriate mapping type for P2PDMA
>>>>> transfers between a provider and target device.
>>>>
>>>> External modules have no business doing this.
>>>
>>> VFIO PCI code is built as module. There is no way to access PCI p2p code
>>> without exporting functions in it.
>>
>> The solution that would make more sense to me would be for either
>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
>> P2PDMA case.
> 
> This has nothing to do with dma-iommu.c, the decisions here still need
> to be made even if dma-iommu.c is not compiled in.

Doesn't it though? Every single call in patch 10 to the newly exported
PCI functions calls into the the dma-iommu functions. If there were
non-iommu paths then I would expect the code would use the regular DMA
api directly which would then call in to dma-iommu.

I can't imagine a use case where someone would want to call the p2pdma
functions to map p2p memory and not have a similar path to do the exact
same mapping with vanilla memory and thus call the DMA API. And it seems
much better to me to export higher level functions to drivers that take
care of the details correctly than to expose the nuts and bolts to every
driver.

The thing that seems special to me about VFIO is that it is calling
directly into dma-iommu code to setup unique mappings as opposed to
using the higher level DMA API. I don't see in what way it is special
that it needs to know intimate details of the memory it's mapping and
have different paths to map different types of memory. That's what the
dma layer is for.

Logan


