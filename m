Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498F3606A323
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U9NDiSg5
Received: by kanga.kvack.org (Postfix)
	id 59D976B0B01; Fri, 23 Oct 2026 02:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5753A6B0B02; Fri, 23 Oct 2026 02:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C126B0B03; Fri, 23 Oct 2026 02:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2634B6B0B01
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:54:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1F43A7BAB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:54:21 +0000 (UTC)
X-FDA: 85352977122.27.1A6DDB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id C566B40007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:54:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U9NDiSg5;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792738460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkPUzX7yhv3Hj1YrE4gniaaxsv2duW0NiwdJ652sT1E=;
	b=xGOnC2xLdwcDJ0hA5G0hIV41EQGWwL2Hg/ShqhUNegH5v4b2QPC3Fui5RU0MEz7XoBlde3
	6FHhOQtFjMSxIErL6PTZqtClYaFoTDH7ETM/BRi948QO2lwrv1K4BpxhPos8UPf9VvGhQn
	jfWT4FOGRD3RgiMLPQy9PhHO4lz9vCs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U9NDiSg5;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792738460;
	b=1I9gw4RaijzsooKTx8QYlpp1sCvABWriw+9cv94deHa/m8zGQtmNOm0ruq8r5pQihSpSFA
	bpCeDaRWLLUaFNX2IdPERlvsV7hNuD0RL8PbLrdA1iwk4FBmr6Rg78CqO0JN94FrZlP7IA
	ed4zw2GowETJ+Nlb8jReo/PR3Uog0Tg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC32C1691;
	Thu, 22 Oct 2026 23:54:15 -0700 (PDT)
Received: from [10.163.161.88] (unknown [10.163.161.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4574F3F7D8;
	Thu, 22 Oct 2026 23:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792738458; bh=n9iGNDoxlwolv/doJTrw9CQIV0VtE1mAf67LSVSFTkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U9NDiSg5x3wMh7Dn/T+WLMA7s67zHvMpwLFZue2JOpO+uC+wR7Nb2WZ6SnuFFtNAr
	 56iU0zsI0Fpwb9hFfmGoi6l6OjLMtft5Pa/UfcrAXXvEhAaC6qcMvQn/4LvPcJfq45
	 uYukVwJDKDgW3ZzCeNtEXsdyHhtuDIbyu1sbXud0=
Message-ID: <18c9c7bd-0d89-45dd-8425-64f10e83fbb1@arm.com>
Date: Fri, 23 Oct 2026 12:24:13 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C566B40007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: umhqggs6i91zwtc7wmfggxp9x6yuwwk9
X-HE-Tag: 1792738459-996351
X-HE-Meta: U2FsdGVkX1/TSpv0SP62kdM6f+d8e3+vJzRDc4LvCXAAIKbqyMQ/OsvmSzUwc7SbwOT21658Bz8QVKkdnJ6/PjO8cM8aJbKeAnFL/IJPqIVpx3dFe4SxZ6iPndluc5JFM0efH7zkklKXItFUwwY6ws+Kn2nzwqMgAS4KMypT17OSTLFGjX63qYMfEeB0CjB0z9j4h6rUfAFr7B/1KJCwzflmOGCqD7LKKGrMBIWB74MT4EmQmP85QtmdY5rODonS2zV3yJkxh7eObMhyqR6Db8oWoSztCxoO+/2xCkz+ABBjbDqi+PQmVrw/nxwPw4wS00FvtRESKdm28lYTImBkqxMZnJKstBOFGejoI/LZYGwPVPvlA+eLp8sDKJPXfJtinm9Sh2+rH1sqHURSnQ2cr+z4f9LR3b4YDE1d7P7NSoba08SwCYsfebPwNvwJc/lsxjSxjU2qQZuOWrbkvD5XwL+KlCjaI2is7/zybBdZJ/VTyMph6bGlDn3sogX7RUHa7e36cY8MPstS5x5Xt+tdLr3OXii+7cjbVWmmS7hFCU1yrghHW4+9UOZYFViu8vBAsAEVFJAl/AqbGGAKyPWBuCObIB1Wzih7+HJwjOAMxVpu1nEqzG3Uofv+9x+p+d3ViY2ecGx+R5QE2VwWzERIGXdpLphzyNAnylVnr69A7zMK/XH8GjdW/kOxyrs6GUElsHaWQk8ghxhKVPN01187awOUfNR9jhPcVK7kOVvs7VXhJxZqStnhK7sWUbC1UUC1t5uOw73UG2w4iqK8ycjNCBxrx1WDgFOUIU0wIy/XCBQDqcvouuitz22N00cNGWMrkC8tBTuwctj2+krszZw/Ta2CBzqxlD6pSBgFWzn52p5mTCDHBCrZgWy+D1toMNOKgtgMu0Fx4tVFGnvtbxb0+lKDrugI0cqzz9f5Tc7aVSo7XgO6gh33tC2DKdN883LjIC6ocJyxWqBl2DhT1VE
 3Jhf5orV
 zkwp5fksg3C2S5O+to5LGGILDmBwmkYrqqwVF7iN5XcSlqnWuQUNBTTUsvU65c+UZAjtQXZ02894G0tY0HQGyX4+lPoSoayzZ/zInfLvjtYqX6I4xnYcwHYB29nOE/zLx5a3cFgYX72u7zjARRnPGfNhd94lQLf96lLH4NeN35QV2xqXi0FDvY7maxDhy707TrBcaZrAOYGCvCs+Ut0iDe+6cXE2pBsbvULipz3qHF7ERFRqEtulCbOtgsCM+hCRNJHdf+ssSq3RTkHASoJAfKAnMP621xfFOXDuoD01J03Axxo8roQxWDxJx0kk1qfLRSR6+AJdQxHVdEpGKnhnjZX7rKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/10/26 5:05 am, Shubhang Kaushik (Ampere) wrote:
> vm_map_ram() converts its unsigned int page count to an unsigned long
> byte size without checking for overflow.
> 
> On 32-bit kernels, a count greater than ULONG_MAX >> PAGE_SHIFT wraps
> the byte size.  vm_map_ram() passes that size to both alloc_vmap_area()
> and vmap_pages_range(), so it can allocate and map only the wrapped
> number of pages while returning success for the original larger request.

I would expect the caller to take care of this?

In vmap(), the check is count > totalram_pages(), is this check more
appropriate to be used in vm_map_ram too?

> 
> For example, with 4 KiB pages, a count of 1048577 produces a
> PAGE_SIZE byte size after wrapping, allowing a one-page mapping.
> 
> Reject page counts whose byte size cannot be represented.
> 
> Fixes: db64fe02258f ("mm: rewrite vmap layer")
> Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
> ---
>  mm/vmalloc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74247d4ce919250c2f02dd5c36483..e98d3aa551fe205ebd9826daad9ad6bd578b91ea 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3083,10 +3083,15 @@ EXPORT_SYMBOL(vm_unmap_ram);
>   */
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> +	unsigned long size;
>  	unsigned long addr;
>  	void *mem;
>  
> +	if (count > ULONG_MAX >> PAGE_SHIFT)
> +		return NULL;
> +
> +	size = (unsigned long)count << PAGE_SHIFT;
> +
>  	if (likely(count <= VMAP_MAX_ALLOC)) {
>  		mem = vb_alloc(size, GFP_KERNEL);
>  		if (IS_ERR(mem))
> 
> ---
> base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
> change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa
> 
> Best regards,


