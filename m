Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE59BEC1EB5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F3C6B0088; Thu,  5 Feb 2026 08:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A29F6B0092; Thu,  5 Feb 2026 08:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A19A6B0093; Thu,  5 Feb 2026 08:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5016B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:31:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6D041B285D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:31:34 +0000 (UTC)
X-FDA: 84410490108.12.207DC45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0560C000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:31:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dN0ZAemY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770298293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxw1eOKiyczaQcbDt5YSi33dT/0b5MEZgX/sF9l+FnM=;
	b=Jn9CnJQ4ZdpeBrUA0Q9PmZPu3myn3SvL7W+b3vLLkUeqrklJQgoQMQfGLwLBG3GMKVreEV
	W+t+MzR0sPzz8zrcyLh6fbzjDx8X9XZskmm8sGd8OqrNjxYXe5Xr1XT8XXYDHDW9ZL3uN/
	MFstbBj6LLRgjy2DA2hh9PfMnWbGoKQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dN0ZAemY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770298293; a=rsa-sha256;
	cv=none;
	b=G+sdi+BfFq7lG2U1+GG/hCBoXljimltwT+LxpAau7HmRDPrN7ZXWBQECpgklXPSKJDoAZu
	WMQGR2uxAlKO1c5gUJDbOsXykW0p3lLBh0H4C+n5uZIkmpaHiRQq3MlzpURm2k6KegYiS5
	dUrylvx4rFbcA+YqGplAM9NzRXgEAZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF2C040DB5;
	Thu,  5 Feb 2026 13:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1ABC4CEF7;
	Thu,  5 Feb 2026 13:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770298291;
	bh=DkyAfYT/bvAKfYlPhoTvpNcAopuiG0l6VfM4hIZTwXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dN0ZAemYnR/7svCmpc2YMVy0ygxmA5qmYsXMLnQkjXGN8pxBM4Kzb3Q6QYrxUhlV/
	 V/A3GBUffRSnH01yXfnI1EjAwYPsTbieyN+FBS5n0fPYEgAf/HkJVuRsTAJN0KKVIk
	 H0WrP7ntllmKDPrDb034BI7RcNRY+cGT1tBqtp9847MhF3WHERfeVBzCbRuPfKy7H0
	 nlVeyCzIy1aPOzqr0inqemLThwkUez9Z/Ec5JuFtdJILTAFlx/PSMRrTFEgikh+spS
	 sBMQN2KLD2DLOvdZbRlAfiQRbmZZG57/gH2P1pE/Xm8SsncipN6YcGUj+pCeJOeesT
	 /sSCaEO1GEt/A==
Message-ID: <ef1f6ec1-7036-400c-9d4f-fc4f6f969ef7@kernel.org>
Date: Thu, 5 Feb 2026 14:31:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-10-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-10-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0560C000A
X-Stat-Signature: rxw4g6hd156njt98u8k981hcgzpsifg8
X-Rspam-User: 
X-HE-Tag: 1770298292-751635
X-HE-Meta: U2FsdGVkX19jbcadnDa4x8SXdaZxm7CmelZUR73j8FBSthwcgFYR08J4Zuv3p1GfJZU5RWMmjALub3tXyay9t2cuwN0E5DgmYbGyY5j7sAzGqxW65uSIn3j11GNYYUMiCQrT5AAX2JEkgG9XTf1clU6chOFqv0qcg7OtJjX1AAMC0xTvXDRgdc0k8PfsgdAhAnrtL8pmXS9/Z7bShMpeGNshebtAJF/Gqoy+HuYjqnZ1pOkzPaz4dVMhSA8sr9DM+b62xjEleww6+Bs4/HEr3A1tbo7ZKZcciGu5G78mi9PEpaHjrZPdRx0Bx3skI6f8LewEzCVmXIoVay4dh4BmyJ4Fv8mxyNznnGWHW8gDCBK5Awl6PXLBW1HOpGadO4ggAZv3vzZhuqGrPEvJFSoYymPKOmO7GSnpdW/uitw6DCoWcP3PNO+fo5BhtS2xDMsg2cBKt8MPVS82vhSW7jpdzs2JxLlu5UId9B+2nIGVROQiCqCNVEgzAheJY4ScU4r3Qx2zJeX4cG2aZln54XdYQBeAGol+6dP3Jmmyp15rgcOEXfTh2mmBiMLXLL6oaZlD7MzY2sVa0jdjNVHshypUxgYB2pQTyhdOu0v4czuWjMAha+u8LHjQJB332t31++49p1woyn5tsK8TmRPCyTkLegvLIsBk+OG49MFdpNNCrwZNIX0pWSwNoZSA0sBGdEiR+sXGH+Qmu/md1xo0kukyCbue5wh1DjULEiS9ZbH531iEgX+lyhm6bUr41J6zi5bLL+L22DWMzUmpVyb9KbJpaeoha5KAQYr7KAGyhZMb4kH9ZNDnHm13NOy5I7BMDnhq5duSwDnpWMow98BeHSJrtRYrXtLSfKvmuEHTh9OkRRszV1cC/m4f57x85dFap9Thsy00rjzFjsK8ItEKpTBVN53/X1IJ5bujBKh12Ls5GcuB2ICPwnzlcadA8fnQtj7UwL6tl0S0HSnnrVtXeF2
 pWshjzzx
 gwCz5v3963maFEY6VmQhR1awB4kqjj2ZtP9uNxMZ+gVkx4QBEfwBqZYSL4+wjgRJ4wtP9WPwA6ubW9BSKxKgghKaIiuaVjBbPGu7D4PIDIy7zhPKJliMvoGphy6QpnEsnZKT90NnHwcmoyXy3EIw1de7/La3PRewA6CkH/fG0LBsc9eLOmfR6KUzHE7g4Ku+SdBrMQa9EHnIMRAkfDUIqyEjHWKYCfzudZ+WaoeWEGf4FmGPI23d7qSx+s8hXB2TeRy5f152LJjQpzGtLRBkZS2QfrSlyl+dpv8tv77xTu2L2l9Y3lJIKuHvtfC2cdo+JBlVV26lrzQBVCwPMUt658FEirzefOZoRnTnN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> If page->compound_info encodes a mask, it is expected that vmemmap to be
> naturally aligned to the maximum folio size.
> 
> Add a VM_BUG_ON() to check the alignment.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/sparse.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b5b2b6f7041b..6c9b62607f3f 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,13 @@ void __init sparse_init(void)
>   	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>   	memblocks_present();
>   
> +	if (compound_info_has_mask()) {
> +		unsigned long alignment;
> +
> +		alignment = MAX_FOLIO_NR_PAGES * sizeof(struct page);
> +		VM_BUG_ON(!IS_ALIGNED((unsigned long) pfn_to_page(0), alignment));

No VM_BUG_ON. VM_WARN_ON_ONCE() should be good enough, no?

As discussed in the other thread, is checking for MAX_FOLIO_NR_PAGES 
alignment sufficient?

-- 
Cheers,

David

