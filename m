Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4B0CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 09:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4126B000E; Sun, 23 Nov 2025 04:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784176B0092; Sun, 23 Nov 2025 04:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0E76B0093; Sun, 23 Nov 2025 04:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD676B000E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 04:27:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E00C2C0B64
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:27:29 +0000 (UTC)
X-FDA: 84141343818.25.65D886B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32A6AC0015
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:27:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uv94iUmH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763890048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGJBxA3HpMNht2r+f4Xo2T/V6gkIV+T8N1PxUbEDDvw=;
	b=T9glsxaRUDemcgd7Z8yPTj0CtFuRijN+93286iZ46689sH/KULM9LQDrTz4nnq4L9/BYw6
	edbF5N8cTz97/YoGuoxmWE/BX5Je5JBo6kguZPgjMGYWILjiMG83B0QXTPqvDRJrqU1r6h
	kDr3dZ+Fb7lLp7L3keUbcKbeM88z+10=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uv94iUmH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763890048; a=rsa-sha256;
	cv=none;
	b=2r5xHjSnEwOFcczYpm6exl/0FRw0lzcK/UIC1NHsj27dsg+ogap6dRG2YQdHv/vULILUeK
	md9YygLwovElz+Gfjow2NxlzzzFDVq0pR86vBfOrkkm8x2BQqCwRRLYViIqg56yS/9roA+
	FQxHH91kuh2GRSq+UGgM33aDyPUjOfY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05A0D4434A;
	Sun, 23 Nov 2025 09:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E48C116B1;
	Sun, 23 Nov 2025 09:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763890046;
	bh=5u89c6u7PmgUNyXcIwwe0ortgOiu9oUgVZBpk9oXbqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uv94iUmHued1v2Q4orS2+AolylSWhtdqajQaxRz+LM6oKZ1dsvahXFkJfRAbyEfCI
	 J69bPl2Q5R+eo9qpF5RWgUiTwHb4Cnaejhd3cC3J1vp3lJVp/PNKwSBroHCdZs43Ji
	 xkyGSqx4e7WI+Eoy3a4zMUzDcBKv9jur1CP769YTXrtu+e6ggpCztMqjPjC2FPmn+L
	 g+xrh8j1qsLR9LDL1NT97JYL8+HxMuRg8YkboaEjLk4ct8HEtDKHNnxsTAXWhHzTuS
	 epE8pdwJh5skTw58RJCZkBs3uTYO8QBPzVmcIHKrIP9SUKGQXIfqR+6Xtd7v/UpGeI
	 1CuF6xraQ5nvw==
Date: Sun, 23 Nov 2025 11:27:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com,
	changyuanl@google.com, graf@amazon.com, pasha.tatashin@soleen.com,
	pratyush@kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] KHO: Fix boot failure due to kmemleak access to
 non-PRESENT pages
Message-ID: <aSLTd7pAWgalkT7X@kernel.org>
References: <20251122182929.92634-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122182929.92634-1-ranxiaokai627@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32A6AC0015
X-Stat-Signature: 4e5otoqsk5bnjcs6jxptty7isbnh137b
X-Rspam-User: 
X-HE-Tag: 1763890048-586824
X-HE-Meta: U2FsdGVkX196oySPBGm/1p80Xf3P22rlCCtst3CdA2+PESJI058r6kRrttkfzFC36xo/khIPfmlRY+ahfWwlMd4eUFPXxImm949s6NneFfjKVD7leKGg7oHw4H02J3IVx4WH3ORDADQOTXOuBFR5Rz76IkgwSVAIYtdFGqtHiWnWExDvVE6Fo76uMaJyP+RjLniJN502MKZ4JWdsGphZMbi6N0EXN4NiOKV+vXutO402WCPML8M1u+sk/EuJ3no6GX2a5fTrY+Ev0aoof9dCvMtbtC7DamsyP3d+NT/WqFCYyUR2IOhuvIuKEI/i18FxgCfLnz5r9PmrIahHHjxhzCIpykTuRPQ4Bh3KTdHSiOY4v4t8iwiCKA31+s/DztGFyjFhBJqt5vQV7n+7149GYxtRNYGfg5ujRdrqYNR7eCLzYUHgJSCAC4fSczUqEPWZHk23osy4pgP0I/aF+jdTvArs9BEDUJDtfsJtL0mofgcrKZbLOQ24OWAs7px+FVdOzj/q7/u5Y3snx0INQHtCxCZtFOInVjWdztFViQ4bwJym5i2Oqf7zDfAykajsUpGiTEFLwNvDFgNbPIpQjqanBLnqI7ND+Jpmm5km0J2qFPNDOAVyk0FY7Q+QfHAZAxlS+CEwnqItolKgPk6JO1naAIOy01idRN6TJCt1h9Rg8XB/2xaDCd4Ddv3LQ5FIRwzhiWXu5W3yDpGM6nYcIyDN+pLHf2D+JfFSqHFUJRkIBEt+VqeiphHa3V0XMq/AykWnVWBYFKXws2D5jZrxxrBamtckC2yfVWUX5rjQtuluDMaRNh86oXqzJ8VwEUeMOyRHOAiDI+DvRjLWfHY5MAG67Fk/HJWyiPOdqZdcO5kIyvbeStF9e4jOvGAh8q6gdk+YGjQpHFuhIzCafvpdGfdpl5A5iQXhPUySuMFNwwQu8FSCFw8u3kN1uEEUbUI3+I3xaKD7NdKj8WmspLzwMKq
 9ocguMNN
 QfOjGVE4clVEZuNnNFq3cztxeC0excEbU32tnITzTIEcYaeJkwZAetmEOQb88z/eaCyTXdzHlrSXPrD+bIny+RjL+33XH78isvuBFM/vzyROwTKHT+e7QZ4xa4B8GkfvJYS6i6Jkzrubs15xv9otR93XhWwY06MUpVtm/U+Re6DY+MTtSLD64XlqyrNurEjlyORP4P74o0B9o0204a9p2/ND4Koy96OhnRDjrYUPCLRS8yuvh8phZOdCkusp3vzZ86a2T/uWforuEJWt5zsV0Cydd+ZhbCKeuQW/3RGTHvt2XwyqpWs4ZzAr9JQvDt8lPaah+PJuGsxjDJKGdlKr2AE52l4o0cdA57jEaxOVvWiPl/Hk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Nov 22, 2025 at 06:29:29PM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> When booting with debug_pagealloc=on while having:
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
> the system fails to boot due to page faults during kmemleak scanning.
> 
> This occurs because:
> With debug_pagealloc is enabled, __free_pages() invokes
> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
> freed pages in the kernel page table.
> Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> triggers this when releases the KHO scratch region calling
> init_cma_reserved_pageblock(). Subsequent kmemleak scanning accesses
> these non-PRESENT pages, leading to fatal page faults.

I believe this is more clear:

With debug_pagealloc is enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
freed pages in the kernel page table.
KHO scratch areas are allocated from memblock and noted by kmemleak. But
these areas don't remain reserved but released later to the page allocator
using init_cma_reserved_pageblock(). This causes subsequent kmemleak scans
access non-PRESENT pages, leading to fatal page faults.
 
> Call kmemleak_ignore_phys() from kho_init() to exclude
> the reserved region from kmemleak scanning before
> it is released to the buddy allocator to fix this.

I'd suggest

Mark scratch areas with kmemleak_ignore_phys() after they are allocated
from memblock to exclude them from kmemleak scanning before they are
released to buddy allocator to fix this.

> 

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")

> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

With the changes above

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 224bdf5becb6..c729d455ee7b 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cma.h>
> +#include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -1369,6 +1370,7 @@ static __init int kho_init(void)
>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
>  		unsigned long pfn;
>  
> +		kmemleak_ignore_phys(kho_scratch[i].addr);
>  		for (pfn = base_pfn; pfn < base_pfn + count;
>  		     pfn += pageblock_nr_pages)
>  			init_cma_reserved_pageblock(pfn_to_page(pfn));
> -- 
> 2.25.1
> 
> 

-- 
Sincerely yours,
Mike.

