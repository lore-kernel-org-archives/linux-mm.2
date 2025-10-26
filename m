Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23253CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 07:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2088E015F; Sun, 26 Oct 2025 03:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA138E0150; Sun, 26 Oct 2025 03:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86F58E015F; Sun, 26 Oct 2025 03:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF168E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:55:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C54116039E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 07:55:18 +0000 (UTC)
X-FDA: 84039505116.18.EC64118
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DF3E140007
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 07:55:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uWaRGsje;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761465316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbW6lsAeQnITBSvhA7va7FPK1N1OCTuc7ZM09ubMnwE=;
	b=siWmMONIlMs4Aqun6kFSTq0JdiakC/xI69q5x11rI5o5u7WmP/FSRL8B1fhs7K495RNSFJ
	hZ6PEpgtQTBz8fXBDF5H3LYjvJzsY4kMwxGlsZ2u32ErbzCG3gzwwbL8vm7KSxszceFRKp
	gFstm+IFyjouET77cauQTUDHut/qfq0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uWaRGsje;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761465316; a=rsa-sha256;
	cv=none;
	b=BO+Qd3pOZ+w89VMs2Ckf0Ek3MxYo6CY9geAOGeZhTmeOoJYUbJwse/jdneZiZ4NQ0MG4e2
	kBwW70IW+r6ebFrK6R1E8WSCFZzLZJQCq5Qf/afma4YQp2asNRI+z/vhyIjaxcXdteI3is
	Q9OCzT5a5WNy9By2/Waw/wa3S48n3wY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761465309; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gbW6lsAeQnITBSvhA7va7FPK1N1OCTuc7ZM09ubMnwE=;
	b=uWaRGsjebUdzH2whT3j5S+i/fAtGVXCjOMCOlz2NN3eCmuwsKvKJ40zCwftesgr2ikX/2jJnolz39m3RxVGZCz/jOPjf+dta4Qwm3qAmMA4GHwxKAszjPDoY8iI7uigsFF+c+Y/Aj8i7+ZwfHMbYs7JTxyE/MhMmYFagpMgQM9w=
Received: from 30.246.176.102(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqyle5w_1761465304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Oct 2025 15:55:06 +0800
Message-ID: <3db524e7-b6ce-4652-8420-fdb4639ac73a@linux.alibaba.com>
Date: Sun, 26 Oct 2025 15:55:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
To: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Leon Romanovsky <leonro@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251022125012.GB244727@nvidia.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20251022125012.GB244727@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: csqnc8et951ohbkn3x764e7e7or1z3ra
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1DF3E140007
X-HE-Tag: 1761465314-807171
X-HE-Meta: U2FsdGVkX19amITOi4e3Pnj2boUw4VdaM5R8dIDDS9Nwq6T+8S6OQB0OPxVH+Xy/hFWDx7YW0S8CQIOqB1JX6ZpL9bFFlA9mdKYPXU5jfGqJPFGK9qQEFnszFgzOkA3CEf43SC9M0iigz12KSd827E/6u+yFmmkOcZmSg1D85GTRdP7SGPnyRBjw1Df3IqcquBNa/W8UOcyruoyCClmGvCiqKtRy74kvv955LW9ItDqFepUHV2hB9BPWwFH+ZNI5Yl7eCtuY2n6Lpn1UYB5p/yxYuri0Do57rAnsSGuMcUZK6evjkpzKj6vJnz1sBiknLsvS+PBTyLuZG1b8IQ8DSrtZz3Mxk35OaWMwvRkJ1LW1gUrTrqQ7+KuYeQH3YJ7ZNheFp1Gwl7DCu9T7x746fp2MVZhhwbkjenKAr3l5dgrFzG32/iLnWyOakYyuczzj4tcuuuJa7uldPVrP+ANdBOXFMJOnn5/fAdDXEt3nnvV4WfZpxxHZDasK9t+TaEExhSwUsSiibvl3ny/OZRZMcYOP+/+BY6ROewvidB/76jAI29PY8zZ6bLBsv7y71n3soW0R7N8UJawHJIoNH6TLg5UApQ82XL+Z8nqjBtzfEvKbfSTSJJJZ1mDH0sF5l/Wdx3pTqNe3Zzyl0EN2e3cEfBlouQp7SMpX4QRY3sCOcSwrLg6YgqCbNU1OYorttcgVOs9evoYXIhXvjl5ldwZ+YfVghWXDAszcJBUtSHIs1P8iOF0Ei3tkCNWisDqNgXQlqdoo3solRTEdboWmFHBy77J2DC6zoYQ3Scy9Uk6YhM9pD7lt5omc7/cKmpGLhvnf5JaXaIbLhIjGeso5CVjPinwC7vNEGdcE47TfWfSeYOODHKEicczJM2Qm+nxN4/hErUWcqr6pxp8zrtmrgjFlPJxCvcRnBa1+1GUl4TWijge5Rh0DP4bgGXvZdFqY/xp7xHGtGFCVpy3cPUUXyxT
 0u3J8pLz
 DMARX99LSopKdt1rD2QRR9GLRJi7wKvcsdm5SV3q8Z0WL+6YUOxkUJAiMHaKZMk7+/JQMx49esNtOU7s7MFLAl6BPCj2wFZC5+DigDRs99yB3fOo8T0ZNv0ee8FDp8+Qu/uuCAFpWVMSvJymidCW/X/wjyBoty9OOZoCVMPuo/qx/k+7m/4yR646id721ymTIO0CcNnJWiTNVBmE2mrxOXQ8A9JNI5PixUtdXhTMnXQ5lMD8MeE1g2VNnMtHMfmk2E+vwWAgFjjmJjOMCW5NcepnzRifx+3zNbyDXowyRuQmH3wvhvaOahqdD2KHNLhWqLl62
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/22 20:50, Jason Gunthorpe 写道:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> Add support for exporting PCI device MMIO regions through dma-buf,
>> enabling safe sharing of non-struct page memory with controlled
>> lifetime management. This allows RDMA and other subsystems to import
>> dma-buf FDs and build them into memory regions for PCI P2P operations.
>>
>> The implementation provides a revocable attachment mechanism using
>> dma-buf move operations. MMIO regions are normally pinned as BARs
>> don't change physical addresses, but access is revoked when the VFIO
>> device is closed or a PCI reset is issued. This ensures kernel
>> self-defense against potentially hostile userspace.
> 
> Let's enhance this:
> 
> Currently VFIO can take MMIO regions from the device's BAR and map
> them into a PFNMAP VMA with special PTEs. This mapping type ensures
> the memory cannot be used with things like pin_user_pages(), hmm, and
> so on. In practice only the user process CPU and KVM can safely make
> use of these VMA. When VFIO shuts down these VMAs are cleaned by
> unmap_mapping_range() to prevent any UAF of the MMIO beyond driver
> unbind.
> 
> However, VFIO type 1 has an insecure behavior where it uses
> follow_pfnmap_*() to fish a MMIO PFN out of a VMA and program it back
> into the IOMMU. This has a long history of enabling P2P DMA inside
> VMs, but has serious lifetime problems by allowing a UAF of the MMIO
> after the VFIO driver has been unbound.

Hi, Jason,

Can you elaborate on this more?

 From my understanding of the VFIO type 1 implementation:

- When a device is opened through VFIO type 1, it increments the
   device->refcount
- During unbind, the driver waits for this refcount to drop to zero via
   wait_for_completion(&device->comp)
- This should prevent the unbind() from completing while the device is
   still in use

Given this refcount mechanism, I do not figure out how the UAF can
occur.

Thanks.

