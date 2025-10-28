Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E718CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A74C80148; Tue, 28 Oct 2025 09:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857A68013F; Tue, 28 Oct 2025 09:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DF380148; Tue, 28 Oct 2025 09:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 622078013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:47:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D9B85873D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:47:05 +0000 (UTC)
X-FDA: 84047649210.16.1EAD3DD
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0AC1320010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:47:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yZD3TcbU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761659222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdP4P384sbs4h39646JsReKLjr8gZ9zv4XENPQNf9Lk=;
	b=cK9beK05uACddEINl1CtwVfHCNqa33IALLHAPw7SPsOuODsbx3UJn7KB93uEp8YtXw1Vgh
	GYtVD/lbRqfSUc6vw0mHzQAgtWJAzy2CujUFSAbtKUrW2KYLaj5GKnvqfAeE0VKLzL8r1N
	3+tS+JD3vQ0fY70+17bxbMcF3TlGczA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761659222; a=rsa-sha256;
	cv=none;
	b=IGCjW0zpsYmSsRnEb7zxq7Iw0ms8AjALhe1V71jJKJ8LxGJrnrCrPfHXqrTNxkPLIYn0GP
	63NOwl7fWzOm1CRE2s/lmjYqaVZlwzyhaSHEZBZtkiraWkLqBPfemej5oPlahqe68fE/X2
	2cDZ/rIQsyKWdrIdy9EOr9JPPLqvAmQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yZD3TcbU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761659216; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SdP4P384sbs4h39646JsReKLjr8gZ9zv4XENPQNf9Lk=;
	b=yZD3TcbU4iXD+wMzZjH4GR5HiKt7xEU8lon77KFyyc7pq/xmTJvvCG9KF4Yn4wDeylPMs5DxpmC1gEowCmgQWE/aAmqD21s2ZsxhyNbJqOD//Reu1PSu3DdD2PY+xsQtsVMYuvnUYOyT5gy3vhlcgobiO68Q01ePHTQWIpCa7gU=
Received: from 30.246.176.102(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WrCJu3H_1761659211 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Oct 2025 21:46:52 +0800
Message-ID: <0d95b8af-97e4-43b6-a35a-aa3ce153f0ee@linux.alibaba.com>
Date: Tue, 28 Oct 2025 21:46:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
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
 <3db524e7-b6ce-4652-8420-fdb4639ac73a@linux.alibaba.com>
 <20251027120904.GA896317@nvidia.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20251027120904.GA896317@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 3ny74ad5tbtz4tt38u4tgp9zsryaofoi
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AC1320010
X-HE-Tag: 1761659220-666992
X-HE-Meta: U2FsdGVkX1+oSfJ3V/SDXpFvUkSrwJinAff/l+1n2CvjsUHctfcJm6J+x96d5DLDIPTl7afq0AenaY+5AnZ3x3XKsjUa1zoJPSnLHon+MWMJ7KejW+0OfsKA1xvFPDmwbJ/BgCQ124CnanX/7Qs1bcvNUBclSl1aIVUdhOhN1Tcte5Ap+49QESRp5BZK1o7w8mZlLdSByGGEikd3Fo3purcdRTn9Xwx7iwQ6vI/nZ00xhpGI8BWp6/RF3Mf3azr+OOAojpxOhc9Ubc2uuIUaSd5bjeTju1YcjYQ4IvHG0BSVHAJB15687qXkEe/Ky+VZeUddvpZqrhMu0MreaM47o/JAZ7FhmczLnkhdlXjbBAsEhv5p3WErNfmR140///tauTBkd06qUoGx599G+ACMt0Pt/50uhsmjamGYMkP8bsRmgeJRs0MiTQ110OjGR1ClXS2YW/hugZElbgZg6x617KKci2eXQ8hiQPJSzcf1+wOyp7agDJnS/LW9aTAUtsFBUjdD4OWNNPO1gmMfDtb8kSCjSWAPaljGXiQo6C0cBLf4rdrNvkODvx2KgkfOZXXwqb2DlqSccWGHij7ybHHHKL87Esb/dGNJvpEAkpv58Wp8IwFa/Z14flOHYtFT4q7a+bg0zUQdyARwF5Lt7FDB9JyQNQ31YbZAck3tqWLCZ1orOEmBuTvT2LOpUyUXFhMX9ghKRhruMRrXzZVNFkQFG96+9N86kSCf6GVy8IkXvqviLRzaqywiWAe01OHsV16dEOJG3h8FPl1LZpqJbfr/nKyQ1WpauhkoAxD1DfKcYbXD8vtzKVhO0q3uZ0NmlQwryTGFT8Q/0vDUOKc/5INjcbt42K4Uc3Z2XLUtwkyMQwu2tKRZ4/6y1cS6+y7lXs8l5QlxpJ6V6bNp/KHcHTntF7B+xEV2HoOwI2nNCb6s+43XyOF4nTIUsDaR34bzZxNNI1dwv3xVhzGY+hD2kBh
 B20CMcWQ
 esvqzATdDxHytDjyd4FFeJGBUprPZOf6hA9uZrj0H1ov1DfZLKVspdy6g2k+pb2fLgAQtf1RkayqR8u+jUKQ/JUCSBgVh/UHUgNccr4koDNQhBUUvQk2x6OQ6u87kVveG5eDz7g+2vw5NO4VYVKMeGVQ4kuhFnD7K2BDgvBNTu3HkKwI4YUQp1LrIXoqnO4K14BwnDzCT/OkXJ20w7FxuTkG2RBu0YKIj1tlnq4dCNCUwpjGh958QPJ4S1pJ9nbPvQ1yg/cOGd24hm+qm+UxqcajRwYkOBhDPHAMDUY1c43YZ9yGfqMQf5aG2e7MLVDVM4YMA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/27 20:09, Jason Gunthorpe 写道:
> On Sun, Oct 26, 2025 at 03:55:04PM +0800, Shuai Xue wrote:
>>
>>
>> 在 2025/10/22 20:50, Jason Gunthorpe 写道:
>>> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>
>>>> Add support for exporting PCI device MMIO regions through dma-buf,
>>>> enabling safe sharing of non-struct page memory with controlled
>>>> lifetime management. This allows RDMA and other subsystems to import
>>>> dma-buf FDs and build them into memory regions for PCI P2P operations.
>>>>
>>>> The implementation provides a revocable attachment mechanism using
>>>> dma-buf move operations. MMIO regions are normally pinned as BARs
>>>> don't change physical addresses, but access is revoked when the VFIO
>>>> device is closed or a PCI reset is issued. This ensures kernel
>>>> self-defense against potentially hostile userspace.
>>>
>>> Let's enhance this:
>>>
>>> Currently VFIO can take MMIO regions from the device's BAR and map
>>> them into a PFNMAP VMA with special PTEs. This mapping type ensures
>>> the memory cannot be used with things like pin_user_pages(), hmm, and
>>> so on. In practice only the user process CPU and KVM can safely make
>>> use of these VMA. When VFIO shuts down these VMAs are cleaned by
>>> unmap_mapping_range() to prevent any UAF of the MMIO beyond driver
>>> unbind.
>>>
>>> However, VFIO type 1 has an insecure behavior where it uses
>>> follow_pfnmap_*() to fish a MMIO PFN out of a VMA and program it back
>>> into the IOMMU. This has a long history of enabling P2P DMA inside
>>> VMs, but has serious lifetime problems by allowing a UAF of the MMIO
>>> after the VFIO driver has been unbound.
>>
>> Hi, Jason,
>>
>> Can you elaborate on this more?
>>
>>  From my understanding of the VFIO type 1 implementation:
>>
>> - When a device is opened through VFIO type 1, it increments the
>>    device->refcount
>> - During unbind, the driver waits for this refcount to drop to zero via
>>    wait_for_completion(&device->comp)
>> - This should prevent the unbind() from completing while the device is
>>    still in use
>>
>> Given this refcount mechanism, I do not figure out how the UAF can
>> occur.
> 
> A second vfio device can be opened and then use follow_pfnmap_*() to
> read the first vfio device's PTEs. There is no relationship betweent
> the first and second VFIO devices, so once the first is unbound it
> sails through the device->comp while the second device retains the PFN
> in its type1 iommu_domain.
> 
> Jason

I see.

Thanks.

Best Regard,
Shuai


