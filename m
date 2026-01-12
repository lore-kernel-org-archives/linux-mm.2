Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D97AC9EC80
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566526B0088; Mon, 12 Jan 2026 07:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513E46B0089; Mon, 12 Jan 2026 07:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F476B008A; Mon, 12 Jan 2026 07:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300C66B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:44:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C629A160C53
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:44:06 +0000 (UTC)
X-FDA: 84323279292.06.17C10B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADC014000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:44:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768221845; a=rsa-sha256;
	cv=none;
	b=a6GhZAX31iPEkzAECBATByM3U9f5mOOfOPLZs6T0PjUyeMf9BbQkHlStdPxcTG22bmmGR5
	t/bDFVeCZhlayKyWVCWVHtDQbDlmBbsLZlwan8QPDHh5uChn2XdLFD3+/3cbgN6MbnNEam
	ymOBZNdv0e/cHZ2lVdkZBPzuv+f/9wQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768221845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yToGWUbCD942WlyvWSP9ffiCgHobRzEmroyLKU5pC1c=;
	b=UGC7NPntk+xxv7d3eBfKRiCSqm3rIf5rXbrw1WJ6XgPDVVyrXzmS+yhWF/IEwYEF4J9q4s
	W0x3JrZChg5EJCiu0xoAouDNH6m9Ws+l77DEBSrEvtobFknFO2gbs3yfOeVmRwMFHgTXnu
	kW7FfEdEvi5nqqTstp+I8i9NuPZ2K/A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0F33497;
	Mon, 12 Jan 2026 04:43:56 -0800 (PST)
Received: from [10.57.48.115] (unknown [10.57.48.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3C243F59E;
	Mon, 12 Jan 2026 04:44:00 -0800 (PST)
Message-ID: <03daf175-fcab-45a4-812b-9a338415565e@arm.com>
Date: Mon, 12 Jan 2026 12:43:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dma-pool: don't allocate DMA32 pool if no 32-bit
 memory
To: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>, lkp@intel.com,
 mick@ics.forth.gr, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 akpm@linux-foundation.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 hch@infradead.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 palmer@dabbelt.com, paul.walmsley@sifive.com
References: <202601120747.TAMpIDnI-lkp@intel.com>
 <20260112065857.3137331-1-vladimir.kondratiev@mobileye.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260112065857.3137331-1-vladimir.kondratiev@mobileye.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uwrit9h8xmkrfikf8fadahtuq6kq1mqq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADC014000B
X-Rspam-User: 
X-HE-Tag: 1768221844-794478
X-HE-Meta: U2FsdGVkX1/KhBAn+hvUWdmzJ7ggpzrAU//pChxbNOHR0HvsYVlRnhdLCnhcNfQTTc0ppUUxi629x7GGYcQmRYQj2jMB6L2ueHpueERSHjyEPt77c7u3av1DYIHNbFEY/ND7aeMTGm1y0tO3DJdabfy44+v6ZNFqCkHNWaMBkgl9T7xrVd3lcv4pw6VdDGNYNVBc8+HoRIAAm+LC0XxoayZ4pr+eZ/77mQ5va1C9Lz2JZvCa9d9Gj3uwfI4cWDns/37JHi/Cp2EdLPbNBKonArTETpRhc5A9EEERDZn5cBbXUq3jTQjp/x7sAyUObi1XnW4JYMSS4KRQNTEX9mnoIrr2Xe1FwK38J1fV/dDMMTvmok9CR5dQpS/uUY2q1DOGFjnQtj+vY/75fBI8vEfoRbdmT0XguMN0VA5cqJlNwAXbu1A+dx/U4rNLiGpMZtaztVDNgKeXsxiWWWyh/aKXTEKET8OfmVJoZ7WjvjK8qaQOCUeehZLDUGATiSI2fxj0oQKsvS7qsyJ6Q4XRd0fKgs/ylYSMQZZm4Gmu0MQQHrg7xq1LTrCwqBMA/Pag4Hl0n/jgpKWMpA367qKdxMk875KXMZe4Cri0RlUj0vz7MV1B3JQfeaB4yPnEgWvmwrW8mOUZe9BM7QxrSzEGdq+y6f5tG/a0x3cNYWe/+Up0x2+9I5b2q/dU4ASHUeRxkCMu3Bz/DtetCQ78Pd5lI7xRrggqsUHz5xXJ4pDLFX+wqwabI0Im+9NJvUbuhQkZSzNVENwY76zXwqL+gjYbfh5xb0raisGln3fDExzTm/fPkCGrHORGMIeCDh/vIfZ3Xoa5q7HqvTBBheNddGg+Ii+6Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 6:58 am, Vladimir Kondratiev wrote:
> If system have no 32-bit memory, GFP_DMA32 pool allocation will
> obviously fail, so skip it.

Note that the rest of the code doesn't quite work right if 
CONFIG_ZONE_DMA32 is enabled but atomic_pool_dma32 is NULL - seems such 
a setup wasn't really anticipated. Funnily enough, I also recently wrote 
a patch series to improve this more generally, but hadn't got round to 
writing a cover letter yet - lemme finish that up and post it...

Thanks,
Robin.

> Changes in v2: use arch-independent "memblock_start_of_DRAM" to get
> DRAM base address
> 
> Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
> ---
>   kernel/dma/pool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index ee45dee33d49..ecd77a0272f2 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -209,7 +209,7 @@ static int __init dma_atomic_pool_init(void)
>   		if (!atomic_pool_dma)
>   			ret = -ENOMEM;
>   	}
> -	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
> +	if (IS_ENABLED(CONFIG_ZONE_DMA32) && memblock_start_of_DRAM() < BIT_ULL(32)) {
>   		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
>   						GFP_KERNEL | GFP_DMA32);
>   		if (!atomic_pool_dma32)
> 
> base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449


