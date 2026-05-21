Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C21CFCD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FB86B008A; Thu, 21 May 2026 04:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFF06B008C; Thu, 21 May 2026 04:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5DB6B0092; Thu, 21 May 2026 04:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFE16B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:50:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A84C4120568
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:50:11 +0000 (UTC)
X-FDA: 84790805022.10.FA57A5A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6704240002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:50:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="KRb/njuA";
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xo9jNx72J31UDHUkHSULoe2IcJFJnFlT88xcGflytr0=;
	b=TXrB/XGGBOG4otHR9ffFbal1++yJkyS6Eb6OkMiwUmCb/pHbgmwNw1iuL51aJJk5QXeUQj
	dxcjdT+4gJQl7Vjxog/P1NWlP4pN+oRPJhK1NpfipoHE9EnQbtqRuzo4zRVtRNKG0mL1KE
	+G3zFVX3/u7eg2uN7+9AH4Ro8zNISps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779353410; a=rsa-sha256;
	cv=none;
	b=EhLzGCkec8OUQeixeOfoa+en1LYmDjZOQCrMifxX07Np50AAH1CLd8+bHobDWwnAJ/9Xsg
	S2wdsW/IBf603Fh3OEahKpuoxhj7ZJ7eHan5s318/bFzJ65U3naMp1E0ATON9sGgdegToL
	5djFOjtWAVuneIBYbuRrwPw3JQU3QbQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="KRb/njuA";
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30B541BF7;
	Thu, 21 May 2026 01:50:03 -0700 (PDT)
Received: from [10.57.91.212] (unknown [10.57.91.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 646F43F7B4;
	Thu, 21 May 2026 01:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779353408; bh=MhXGOMEd2ldhJe/G+pIUhlGCzdCvGYuxSKbJNXUFwXc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KRb/njuApSQvSrZXK69MxzbGVc+jTfDi1eLbtHMzb0Bzm96Zr5kSL+qO7AKIrUAqU
	 c9mByq/mzLEvf3pqVXjeDZ8b4WmkeMNNBumUECFH2081l5PACk4vRK6GilZCgx2XzZ
	 QZTfkmo4Y4f6HQ2vn6b62Bs3Cb6alv21CCqc1t7U=
Message-ID: <bc96d822-bb68-4945-9f74-68f77e389ac6@arm.com>
Date: Thu, 21 May 2026 09:50:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] arm64: mmu: use range based TLB flushing when hot
 unplugging memory
Content-Language: en-GB
To: Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 catalin.marinas@arm.com, will@kernel.org, david@kernel.org,
 anshuman.khandual@arm.com, dev.jain@arm.com, balbirs@nvidia.com,
 jhubbard@nvidia.com
References: <20260521042426.2128731-1-apopple@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260521042426.2128731-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6704240002
X-Stat-Signature: pbcf5seo7wxzwni6ug3r54wiyeh7u54a
X-Rspamd-Server: rspam06
X-HE-Tag: 1779353409-443401
X-HE-Meta: U2FsdGVkX18XWxe0HRQna0i2WQbvFiQE0bKZ3oyaTEkTWeQmIRpxdYSQr2FMS1ZuRrpjtliMyS/j3sLGSUnrTkLVlF+psmv7k+N7Mh+cmnreSrCu6O22Ao0GyyzgMTHQjdHeb70QWoTG1IWdc3SMYOqrEE7+z8lxtsLoZinNOWJEzm/HaPLzdEub0cbe13qVhpxK0OnlHw1ykW9RYApM2dQvQwAG3rkPRU2GRrY3aS7xk4+0wnAUycwMygXpEEg4vfpOEKQrvKvrpRCA6CFMXEeBdlcLDYqGbqMCPwa9uFWLf1++zaLa0+7566ha0/rF5IjsDG+M6YCnnaIahZ+ZIdVrVRxEVXum4fKsPMcGOyJKfx9P7G0Qft5ImzrsvuQ9np9c+UB+MEMG6PwINSfD8I5iUF/tA7siJYQZkbhE3XeaUJLwxMWA/+1A+d6GWWNi9miwYDT4WZ8YiO8QEG0t5Z+dtuP9ZG0Y2Rwj/9TTtAq530GQ9dCRNgcjg5/uVX0bPSb7enRLTFO2PVG+hgqyyj6xtOUWNkzmgDJ5CEV4Kl+HtSIXkuQK67vARWSGoRtz1zCa+MExDGgg/htvx82eeGG6W4ExAmW0mWgP6lv3hEa9vQeLloTVMdeX1MNdUj7lfEbDktpGczrciY9NIOm3NmOKHMKHzJeIprAwTG5NXe4sdOXSDAiLdD9h4I9PwwhNp/lLE7yABdIVyL1zefS/wMJ89MNITTt1ZDdtOh5CA6F94wiA6dNudlthGJZcp4WmUvnwfdSj3ZHJtMNd3B3UfQxx1qMnibumaXznhMW/EDrCjlDlltub9nZkUug2cTlHGvNsxbuI+WsyWA6hpakg6YzVvKUP3MtMLfAWSxVTQMhrgg9qFvK+969VDe3C/Z4Ow/quQmLMWxz9Q3V2PREXEW/Psqll9I0HIoIKQd69pt2PvHPwl2EJd7F1HP1q5BLA2BaktLrADbp4mOz8XOt
 90D6laT5
 RrhsO/Y4bVAScxa88p13z9U9e+q3cRhqwJhaKqZ7Tqy17eKZ3FFV3bpeHEjUXsuWBjQR5qsZy6RWgZKiu1KmrvOBKn2drvvpkvigGmy04h1Td2PA8ZqTocJG4dWZUpvxin9BC/I5FzcFn9v2I9fVu6bvxjsf6bmP7vNyEkTImTIGJkm+qGdMC2Hak3Re7fXnMmtQ9/IyVb2d9OZJA7xjuKSa40AEwJSM2IH0PLygV1GX/0IVAOAvfLpuZ/mQ6pH9cKGmK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/05/2026 05:24, Alistair Popple wrote:
> Hot unplugging memory on ARM64 requires a TLB invalidate after unmapping
> the page to be hot unplugged from the direct map. Currently that happens
> one page at a time, meaning range based invalidates cannot be used. The
> result of this is that removing large amounts of memory takes a long
> time and in some cases can trigger an RCU stall warning.
> 
> For example on one system hot unplugging 480GB of memory takes ~1
> minute. With this change the same operation took ~1 second, a 60x
> improvement.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> This is an RFC, because I'm not sure the change is correct as it frees
> the PTE page before flushing the TLB. I'm not familiar enough with ARM64
> architecture to be sure this is safe, for example I don't know if HW
> can update PTE bits such as access/dirty in the page through a stale
> TLB entry.
> 
> If so this would open a window during which the page is free but could
> still be written to. Likely the safe option would be to collect all the
> pages to be free on a list and free them after doing the range based TLB
> flush, but wanted to get feedback on the approach before implementing it
> which is the goal of this RFC.

Hi Alistair,

This patch doesn't apply on v7.1-rc4 because it conflicts with this patch:

Commit 48478b9f79137 ("arm64/mm: Enable batched TLB flush in unmap_hotplug_range()")

which has a very similar performance improvement, so hopefully it solves your
problem?

There are two paths which use this logic; unmapping the linear map and unmapping
the corresponding vmemmap. In the latter case, the memory is also freed, so we
can't safely do the range optimizaiton there since the TLB needs to be flushed
before freeing the memory. But the linear map is the big, slow bit so hopefully
it's sufficent for you?

Thanks,
Ryan



> ---
>  arch/arm64/mm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 0c24fe650e95..75c773232c14 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1459,11 +1459,12 @@ static void unmap_hotplug_pte_range(pmd_t *pmdp, unsigned long addr,
>  
>  		WARN_ON(!pte_present(pte));
>  		__pte_clear(&init_mm, addr, ptep);
> -		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>  		if (free_mapped)
>  			free_hotplug_page_range(pte_page(pte),
>  						PAGE_SIZE, altmap);
>  	} while (addr += PAGE_SIZE, addr < end);
> +
> +	flush_tlb_kernel_range(addr, end);
>  }
>  
>  static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,


