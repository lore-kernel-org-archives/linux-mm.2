Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0201AD3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DB76B00B6; Mon,  8 Dec 2025 01:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED666B00B7; Mon,  8 Dec 2025 01:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5046B00B8; Mon,  8 Dec 2025 01:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 357EA6B00B6
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:41:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCFBC52F54
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:41:42 +0000 (UTC)
X-FDA: 84195358044.02.E4FE672
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id EFC6F1C0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:41:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765176101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nfLTIPM5hr9t61pK0q+EaqxFBeNtRWK81ODtXs5wDMc=;
	b=TMR5OLJVhcesPcCf4jK099UYdHAXzzHdkF0STxJk1nV9GfjsVrysnjcMudmxRbGeooyfpr
	W4UUt6BeCdahO7sS6A/pdL+MGQAF+P0vt1mnIqYRTHmzbFgilYKlWN3DbFqPRFW+JxlmC5
	0OmQw57qvBja4c28p56nQn5GY3iiXuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765176101; a=rsa-sha256;
	cv=none;
	b=CGLSedOFo16Dha1NmlnH/Fzf4b2edoGYUXNdqi2soM6p9yxqiUJQ24W3lBRTH8xWTO+WEX
	p7os61cAc9GWyhKxYobs2C5984Opv3EDeCM7yppUaZ4JdTmms6VU8E2mlLKGM/9tmHgc6J
	3zZKzozdhbDS8scBQrdBu4hyh+4s0dI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBC01169C;
	Sun,  7 Dec 2025 22:41:32 -0800 (PST)
Received: from [10.164.18.52] (unknown [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886633F740;
	Sun,  7 Dec 2025 22:41:38 -0800 (PST)
Message-ID: <96aa9bf7-1f1d-4870-90d2-84d3d6d4254c@arm.com>
Date: Mon, 8 Dec 2025 12:11:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nogtaym3ugdpyt7b7er1ufy8ax8dsghc
X-Rspamd-Queue-Id: EFC6F1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765176100-970308
X-HE-Meta: U2FsdGVkX1/eeU3SnEAM68kro7+TCooU66VMeiZKvTVHRsGvfiZk+kC3zT7q3TKo8PNRN5FGpPHLreBhVDxQmNzHECoUTGRGU8wy6Z8FaAN9ss0ke3xUguNstRkaNoYF6shNFapFzOpe5PjzpUsXznYc+pEL332eXkP8lx+jbh288ZaMNlaG6MVuV7JB+D09m8cLt+nFW1JkL4ezQLCt3g0IT16Apl7fV/I45OFpUiKSIs5NJZrOSUueuc+BkDfCNADhG7DyrNvEv0JvH8R6JEr61lWdLE3XOvIM0UzOhaEaRBtsBPaqCSlfGEl90gi5p9dD6Ij9JS4bZQooJD2lKnnvO+pq6sw+qK1iLczhBixS5LI6G3dq0gxpSvILzf9j+JPEbEGDOD7tZOcDl0pQQV3ehV8GFSOob8rtESTDyFtWNgvv4deGEJrQGCN+pcoGNDTzFDQHUK2ALP425s8KLD48SEa2KOHolo/r4e0kb4/N7bHw/aceerOsrnoYq3xfPrI7RI5VaKKkKCd1pbKw1DFWWkKZtPo69fiuH81HshkNydyrPDFROkXbj1UiOKySt9XmVMzWsy5Mlx+3WHSCtBBTsaKZd9nCezEE+GAlCcnvN5xYrKXAPtr8KO0hAEM4tLpsCJx0513m6wGdA0ojyq8snPWr6eNVSwgBe55nmyx3+26BOb5rSs68B7tuOArqsQ9NxLckCNvNcLWOI2T7CGKPNFBjmhheSx2C99yxutDV0/vrnVb1lg7wWjDyBnEEu1kph9qmbBSro/HWP70PEPY46d6tALT/kZVbLoya1skfVMbeb2vbheME80mCGCUDpAvhoaRjhHyWmUqE0QzsBidirz6yyI0SXVHoqJP2OGzBH3XanTjiQ654cpuiTbRrek/JzTE/0iZlk3FSR0RG8L6NXudDAwj7z+QXvp7pSkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/12/25 10:49 AM, Brendan Jackman wrote:
> The only reason vmap_range_noflush() can sleep is because of pagetable
> allocations. This might_sleep() is accurate, but we have a more
> precise way to express this particular case, so help readers out by
> using that.
> 
> Note that the actual GFP flags used to allocate here are arch-specific.
> But as long as GFP_PGTABLE_KERNEL includes blockable flags, it should

Currently GFP_PGTABLE_KERNEL does have a blocking flag via GFP_KERNEL.

#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
#define GFP_KERNEL		(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
#define __GFP_RECLAIM 		((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))

> serve as a reasonable common-denominator here.

Agreed.

> 
> This also ensures there is an fs_reclaim_acquire() even no pagetables
> are actually allocated, which could potentially do a better job at
> catching filesystem bugs.

Makes sense.

> 
> ---
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a53c7462671bdd896f95712af71398ffbe22fb80..ff1876588b94ec69168324e93399dbd117a6959a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -305,7 +305,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	int err;
>  	pgtbl_mod_mask mask = 0;
>  
> -	might_sleep();
> +	might_alloc(GFP_PGTABLE_KERNEL);

This will invariably add a might_sleep() and hence preserves the existing
behaviour besides adding fs_reclaim_acquire() which is an improvement.

>  	BUG_ON(addr >= end);
>  
>  	start = addr;
> 
> ---
> base-commit: ecc46e02e0abe025a6e840cba2d647f23fd1d721
> change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
> 
> Best regards,

Please add <asm-generic/pgalloc.h> in mm/vmalloc.c - otherwise it does not
get built as GFP_PGTABLE_KERNEL is not available. But otherwise LGTM.

After fixing the build.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

