Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8917ACCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 08:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6888E0005; Sat, 18 Oct 2025 04:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557B68E0002; Sat, 18 Oct 2025 04:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D2C8E0005; Sat, 18 Oct 2025 04:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 350098E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 04:47:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE6F3C03F3
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 08:47:02 +0000 (UTC)
X-FDA: 84010605084.28.441ACB8
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id 829F720003
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 08:46:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AD5XR7Nm;
	spf=pass (imf03.hostedemail.com: domain of xiaqinxin@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xiaqinxin@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760777221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtXeoyMbEb3nG99AFaMa2rNFJ1WX4VazwCqad42ukB8=;
	b=o0T9SXCSubAlSRMJ/ejQlNDec9QCYse+sZCFeucCz4gAu8qiZeAOq7i/97dBuZqCaqZ3iU
	2WP2Fg9SVf9l5K1820XKvtka3uZSRjnxxFwNZtJkDU/Nde33Ks7sjQ2dyOp0fCSJ60Nsbe
	Z/27XOuTjvx2im3LBckYcrAwIBUpQ3M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AD5XR7Nm;
	spf=pass (imf03.hostedemail.com: domain of xiaqinxin@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xiaqinxin@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760777221; a=rsa-sha256;
	cv=none;
	b=RmdyUUAWJdaA448h8opVnvodlUrcH5bAPgyngcxzrQ9fpW1c05kv2gw8ST/s97nYahSIqT
	0x35K0Vkn9fQsvZuA6x4ggvCe3dLJJucj3rKyyn+VzvF4xu9cYgAVwdpVKcGnf+7uTPNx7
	b3vrKtELtR6XPBat9rQRNWD86NAQUVY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PtXeoyMbEb3nG99AFaMa2rNFJ1WX4VazwCqad42ukB8=;
	b=AD5XR7NmSD71grdrmY7EqMR7hVnfBjEGjLO/Sn5nWEGBbnS3ZCsHvokz8iNNa8zYKy9/+j/PE
	hk2ALKCefi0mTib91JeeloNYzPxN4DEKO+rPT4UbOzKZ55lxbTgqqDcU4DZd4sJNyvnYb9/uqHf
	jlx3exQ0zEZsGJKliLGJLh0=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cpZzq0xH6zLlVc;
	Sat, 18 Oct 2025 16:46:31 +0800 (CST)
Received: from kwepemj200003.china.huawei.com (unknown [7.202.194.15])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EC951A016C;
	Sat, 18 Oct 2025 16:46:53 +0800 (CST)
Received: from [10.67.120.170] (10.67.120.170) by
 kwepemj200003.china.huawei.com (7.202.194.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 16:46:52 +0800
Message-ID: <9ce597a0-9df4-4c92-913b-ca75fc028972@huawei.com>
Date: Sat, 18 Oct 2025 16:46:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
To: Mostafa Saleh <smostafa@google.com>, <linux-mm@kvack.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <rppt@kernel.org>
References: <20251003173229.1533640-1-smostafa@google.com>
From: Qinxin Xia <xiaqinxin@huawei.com>
In-Reply-To: <20251003173229.1533640-1-smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.120.170]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj200003.china.huawei.com (7.202.194.15)
X-Stat-Signature: sac3iyzy3qiqa583obxcbon9udiogt6t
X-Rspamd-Queue-Id: 829F720003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760777219-207712
X-HE-Meta: U2FsdGVkX1/Iv5HHfp4bH2wOrdBe4db4sKwlC2vh829myURPx6iOs6d6VanaJxe4RatLWReN7loCat8KBvtrE7ULl5Nxg9K3oGONQz1kt5npGtPjXGv7a7Gtb1wQ4QjUWt5fju4b9Rvfhq1/UO4kjADVMVd+QyvY4Th4j2ymZD9nHzPxM64sdXHw2Z32vX/cNnvaPYBw5vTxiCROyFvmy+JBQqIhdMTPvZLQ9gKzQM7dC1IHmXnBz7/Nvwe2A2AOod++yNJ0F57mIohngNVjY+Cq5LxqNlZjqlJ8jvDCjE0lxr7W6qYa4UP8Hx9WYBpQ47ykUFJAlF4KMSvGy4ijeRYscPEQgg7+ML/FVLYWDecjsHOi3UWSNca1UOTI61+FK7FjdVtpD1n1KGN0S6L0FZYPjuJ0/MCUCLDP0WMCzy+MPx3qFYnrQEM7Sh9jJ1u1kPOeI2q+o10/zZk7E0lgAe9xXM9XR5czS45RxI8eKZz5X1bt59VfyQzCa3Sdf7UFK4bHriL0G7cJADd1tYMcUlizI0xohI3N+xFKkc/D8aRp1gtBNHYuVlCEkW5KZT1X3mQonhvlQYFnrUIldiCSktGKrlR8wWICefvU8PwL3iPFMlkFqB1ulHgLTpwkYdMz/RqtmnmJHZKPdLnzwFBjnhlxa6rwUyBkaaLDoARLTi011ipWmf9VYJNt03JV2cdhdXX4t5JCsmZf7GxFSaiFzA5fVzMm2rGH9lARII6BxC7saofa7VnYujODXmQqK4uP7jP5XENX7n+h08TU5SgSx/8PLlCRhTDykE2QjTIBK1QVprrinOls7XwgO4/XTrP/zEvCrRNYBsJ6zhqxkM4K9+qS2EILVymkTnqDc2VvpCZtfkCJL8a2U3fhDAHVuvkY9n0TQTLgzEFnBzv+1FKswmtSFFF1S8/ROOkKdP186YQFfecdHaRuc+A2vq6WoC1trBJedfaZQ+ArmmX5CJo
 R8KMiPlG
 ICvT44r54yqcvhM0PtNu0nnSJyKvI7NjDXDkl47cVAqwT01Lpfwvu62Vfnde+aTnS6/IqcD2psx7iRO16wZ61/MpxZq04/dwBI3Fs1eGdznElwuqM4F1sQxvt9GXm9Ek5g9Souwf7D3Nu4iTn1z5WoQ5XQh61qTewAUA74fJuLufCTocDUOr1288GzqiUKW5+JnokqS2y8wwXiIRvMHss/I2Pv3xSLJ1m0h4hM1O/hsPly5Hh3RaNwxpS/iJEeUuRFnMhW+hthIaI0H2jOPP/SseQTOjLOwk5DtGGijJguXwROvCDwd1Mca+MINeSVwKPmiOxBGCk/+c09UCOIj33cc0EXBdvxfuknEkZ4EXkr91MX1aN+dlIOOIVmhh/Awmh8x+HYQpSebD1slrTerUfStJ/9QqHEfOOp8JH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/4 1:32, Mostafa Saleh 写道:
> Overview
> --------
> This patch series introduces a new debugging feature,
> IOMMU_DEBUG_PAGEALLOC, designed to catch DMA use-after-free bugs
> and IOMMU mapping leaks from buggy drivers.
> 
> The kernel has powerful sanitizers like KASAN and DEBUG_PAGEALLOC
> for catching CPU-side memory corruption. However, there is limited
> runtime sanitization for DMA mappings managed by the IOMMU. A buggy
> driver can free a page while it is still mapped for DMA, leading to
> memory corruption or use-after-free vulnerabilities when that page is
> reallocated and used for a different purpose.
> 
> Inspired by DEBUG_PAGEALLOC, this sanitizer tracks IOMMU mappings on a
> per-page basis, as it’s not possible to unmap the pages, because it
> requires to lock and walk all domains on every kernel free, instead we
> rely on page_ext to add an IOMMU-specific mapping reference count for
> each page.
> And on each page allocated/freed from the kernel we simply check the
> count and WARN if it is not zero.
> 
> Concurrency
> -----------
> By design this check is racy where one caller can map pages just after
> the check, which can lead to false negatives.
> In my opinion this is acceptable for sanitizers (for ex KCSAN have
> that property).
> Otherwise we have to implement locks in iommu_map/unmap for all domains
> which is not favourable even for a debug feature.
> The sanitizer only guarantees that the refcount itself doesn’t get
> corrupted using atomics. And there are no false positives.
> 
> CPU vs IOMMU Page Size
> ----------------------
> IOMMUs can use different page sizes and which can be non-homogeneous;
> not even all of them have the same page size.
> 
> To solve this, the refcount is always incremented and decremented in
> units of the smallest page size supported by the IOMMU domain. This
> ensures the accounting remains consistent regardless of the size of
> the map or unmap operation, otherwise double counting can happen.
> 
> Testing & Performance
> ---------------------
> This was tested on Morello with Arm64 + SMMUv3
> Also I booted RockPi-4b with Rockchip IOMMU.
> Did some tests on Qemu including different SMMUv3/CPU page size (arm64).
> 
> I also ran dma_map_benchmark on Morello:
> 
> echo dma_map_benchmark > /sys/bus/pci/devices/0000\:06\:00.0/driver_override
> echo 0000:06:00.0 >  /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
> echo 0000:06:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
> ./dma_map_bechmark -t $threads -g $nr_pages
> 
> CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
> cmdline refer to "iommu.debug_pagealloc"
> Numbers are (map latency)/(unmap latency), lower is better.
> 
> 			CONFIG=n    CONFIG=y    CONFIG=y
> 			            cmdline=0   cmdline=1
> 4K - 1 thread		0.1/0.6     0.1/0.6     0.1/0.7
> 4K - 4 threads		0.1/1.0     0.1/1.1     0.1/1.1
> 1M - 1 thread		0.8/21.2    0.8/21.2    5.6/42.5
> 1M - 4 threads		1.1/46.3    1.1/46.1    5.9/45.5
> 
> Thanks,
> Mostafa
> 
> Mostafa Saleh (4):
>    drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
>    drivers/iommu: Add calls for iommu debug
>    drivers/iommu-debug: Track IOMMU pages
>    drivers/iommu-debug: Check state of mapped/unmapped kernel memory
> 
>   .../admin-guide/kernel-parameters.txt         |   6 +
>   drivers/iommu/Kconfig                         |  14 ++
>   drivers/iommu/Makefile                        |   1 +
>   drivers/iommu/iommu-debug.c                   | 160 ++++++++++++++++++
>   drivers/iommu/iommu.c                         |  21 ++-
>   include/linux/iommu-debug.h                   |  24 +++
>   include/linux/mm.h                            |   7 +
>   mm/page_ext.c                                 |   4 +
>   8 files changed, 235 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/iommu/iommu-debug.c
>   create mode 100644 include/linux/iommu-debug.h
> 
Hi,

I have tested the patch on kunpeng 920 and it works as expected.

Tested-by: Qinxin Xia <xiaqinxin@huawei.com>

Thanks,
Qinxin Xia


