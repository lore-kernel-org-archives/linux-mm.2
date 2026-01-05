Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEE4C2A07F
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B406B00C0; Mon,  5 Jan 2026 04:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1626B00DC; Mon,  5 Jan 2026 04:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947F96B00EE; Mon,  5 Jan 2026 04:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8120C6B00C0
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:33:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ABE41607F4
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:33:08 +0000 (UTC)
X-FDA: 84297396456.12.4BFDEF9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B66512000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:33:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767605586; a=rsa-sha256;
	cv=none;
	b=g9KdJ7LXYWwAFzjWRzknExnYK8SeUiYpo4RrKqAh2kxgK1O6BZB/kbTPPLOmriIdtrHdun
	44Rt3pk2GlLhjohK3/u0zR65sz0AEAi1Y/IRRrS4aKvEHdXHRX9gWSxrXDhW0wic3Lwsgj
	HbmBdIUbxx56bWNt0sbdk3Kzwlpz1Ws=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767605586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gFXxsU+UsyLdB6Z+mPbyGvEYKxFrszh+6SMRER0e2qA=;
	b=CVSRvmRW2gVns0TJ6ebShiQuD8cHFWNs5uFGjjGjzi7W1lePfS/5lHFH+yA/upF0NO2sZv
	v8ADfysRsqSY9RMnA872uTTzy66Um1aen24SogIOq3MkhAjdCdf7f39hQAFCbzIUhslF2G
	jW+Z0YA38XQAqQEywq99pMo0v6WgmDs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FB2E497;
	Mon,  5 Jan 2026 01:32:58 -0800 (PST)
Received: from [10.163.86.15] (unknown [10.163.86.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A8603F5A1;
	Mon,  5 Jan 2026 01:33:04 -0800 (PST)
Message-ID: <f1087282-43fc-4239-88c5-84aa909ce823@arm.com>
Date: Mon, 5 Jan 2026 15:03:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memblock test: include <linux/sizes.h> from tools mm.h
 stub
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
References: <20251228183942.3628918-1-rppt@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251228183942.3628918-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B66512000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 1g4sw74tyqqhs5f3uaq1oy1r6md78h93
X-HE-Tag: 1767605586-619903
X-HE-Meta: U2FsdGVkX1/VtzS8iBVQRB0pHZlkBtm6ohX3toCaHMfKE/UosNQo42a0W8JXqy5wQK7HGqex8Nz1Hk5Y+rgB/UiobfnmaTrV6jLb1C7niqam3Co7aWJ24jystJr2CAmfIdugUByTa48FD4SuoDjNGZsE5M4WgWHBeJVbkdASWUgrNxv64uZ6sAhRqcsKPyY3/IRf9Ol6fx5bBbV/axhfVUEHPQ8WHdMBMk6Ngs9UkDlXBEF5xZ1WjYg5iXATvf/h+8YN3RDK8hzkH/X+0q7FNcHgS8Ukn+E89i6sSvSfd2gnv2wbSlYvvYN1nBg/2OMNvLXrygI2K4m76mPgar/LdBZRSZ4HFuCfH1lqwyJaLTUZ65CPqEuX4xjOVDTVvyAtI0y7yIORtp5FfiLTohd5N+716qVcD8NVglPjuSs4rkg1Jgjpbhk8KW+mYzsKkaDjPsGPkZar3dQ4z0Pb96sQ3YzRVnZgRoVS0hQ0nz1tOwD8TY7YA9dJj0UVzEgd7RhfiZksJcwkP0j4pJmbHmCotuTbW73JEGXP8yVRDX7/FRewZJuzQWnJMq1QHU3Plsg5azfjfWnUkIJ5/KCG8hkV/ftWmJgmvUJcx5JyDgUkjYyQ+IUOQwYCNinZRc7+bSSIWnoVmkPyqh/PRQyjsTsu8BghcoQhy4w2Tw0hNVYNz0FiQqHNmxt/2mLdsyxPjvE1o92iJuY/lJxtasYVgY6lVlv2apNBcBxJ0a382PVkaf3cBQSmXTZfho7GLFlOAA+QEUZ2Y+Gs8uEv60jpT38XsLvj+bUuEfskM1vO00Q2uWymTnKqgK0TSAYGN6ZYSNud5NzuNTQcCTo819vdL74pxw3ecqjy8zDz0Tdgde3rAY9lKtfT8jmRzeTuN2ag33hpsmrheQphSJ1WtChTZrSHMjP7ALypNDn+7y9o3pS08WT3ikE7qOZJ1alSYKfzXAAvwcZH9Jb07q11tsY5jx7
 j4weE0N/
 pZQb7/EDVq1elqQoirg0owm1drj+dIMdBwThWERY7vxEt2Jgotzmkrmiiu8mI+vOPo94W/pko+cXeNyl3lZJI3W9NEvLh4RAiI8v3OmwXBWdOK4mLsg693/1mp3nCIdBf2CHSEuIqIveY1qpLCe9m2+oQ4Swmka4SClazVCSUrPKOurtIKsW3wp1XpHFkJchvvbbnvLsVi6k/rcZ4rKbwsLD8Lq347yY+4tzojRLXGlI03r9j55PbxsG6c0JZpz2/Jet6+Lj98C8hcDr3Mugs2JuQyE4OFE2TQPJH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/12/25 12:09 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> memblock test compilation fails:
> 
> memblock.c: In function ‘memblock_validate_numa_coverage’:
> memblock.c:784:58: error: ‘SZ_1M’ undeclared (first use in this function)
>   784 |                 mem_size_mb = memblock_phys_mem_size() / SZ_1M;
>       |                                                          ^~~~~
> 
> The SZ_1M is defined in sizes.h, but it is not included by stub version of
> mm.h in tools/include/linux.
> 
> Add include of sizes.h to tools/include/linux/mm.h to fix the compilation
> of memblock tests.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/include/linux/mm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
> index 677c37e4a18c..028f3faf46e7 100644
> --- a/tools/include/linux/mm.h
> +++ b/tools/include/linux/mm.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/align.h>
>  #include <linux/mmzone.h>
> +#include <linux/sizes.h>
>  
>  #define PAGE_SHIFT		12
>  #define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

