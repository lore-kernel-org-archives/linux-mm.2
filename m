Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9E5CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BADE88E00EB; Thu, 18 Sep 2025 06:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85A18E0093; Thu, 18 Sep 2025 06:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC28C8E00EB; Thu, 18 Sep 2025 06:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7368E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:33:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5620D86930
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:33:42 +0000 (UTC)
X-FDA: 83902009884.20.DA83F8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8114C0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:33:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm9RBWiC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758191620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzPcxYR7J16IPg8Wif4qihXzYFB0g9kUppaANUnIgAY=;
	b=m710uZEu9uJwxGU5dyYAFbb2u2YR6g97/YMa+yn1jgamY3VpXb7HydCHZkV8wNjutQl50b
	4cqbCosKgnvQbfcR60HGgE7xQP2igUfJhHhy9SB0cKgxTmvuQvVCXzojfFCKxSfF2Fr5gI
	8aBlIqGWMyxtx/ibsgCV3mx3rNVU5u4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm9RBWiC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758191620; a=rsa-sha256;
	cv=none;
	b=T2H1GYEAJSxLXs6s9cBcU3vpG6o8PsOzTAhf54RHy2AFJEp4/fxs2Y84BdHwAAXy1bkpqf
	GNLI0kY7Mj7ME3GuK+58qP3U25BEhpXFg1a5mkaSi220QoGl0NwTt7K6osJK4TQjoNA/Sv
	XMgQ6WywmS/D3atU+olTWjwQNlJukUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BCF944C18;
	Thu, 18 Sep 2025 10:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E100C4CEE7;
	Thu, 18 Sep 2025 10:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191619;
	bh=TVVwkNO7iGB7t5rAzhUJHNIbjpPOZCjci5g14ssAF1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qm9RBWiCNRRPZwoAE/MGVvcH1Fb0Bq5Z4VYyttWdudvb2XA3c15rpA8dayNhJTmUa
	 WNyM7eDlgDYa4S5PYFDRhR9bf89NkOoLmgy62i3y7aIpt3H2QeEXuEpwRX2w6ft4Ia
	 mAy0zTswlIo2jcv1xq/37MZNbvndohUPQTV6gNGXj+zj/8zpI2s8EJU7Gz46n+4fKs
	 +hIpY7IKelaY2ulXUQRL5H1nMWAFaIfYUb8xvZtt0cnXzP80i+SgENOLx4OsCPvxvI
	 4oj3coRJv6+0ENBXpkuR0kBSE7Luhf587W4eu/ohVWswm934fBm/qIsHgCppYefjcS
	 7RMb12iu8M4gA==
Date: Thu, 18 Sep 2025 13:33:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
Message-ID: <aMvf_R4ttLibbnQ1@kernel.org>
References: <20250918093453.75676-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918093453.75676-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: A8114C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: thekzz5zxoou7zh76b3pr599mgao5eei
X-HE-Tag: 1758191620-962736
X-HE-Meta: U2FsdGVkX1/UVKwihBwlD2Q5L5wWMaAa6Lb4uhE0tumS8tgY6nMQdIjW+1CBwakjSZLVSUA4WMtdXGxduiZgx6V0gEBGl4Td/x7F0DLcvsFWuCWJj4zpjjCNmy/+lYuo5E6bOw4M3dcqaJHdVs7W0q0kJEjZr84O1p4H7PvkTfKsDyGccSjZjUvp39IxFDeHxGuPW4gcvwTUaL1htFv2124mKuJHxd5d7EgkCO2ULit2O5avBcsZ/eYJIa+iROzMT9i95Nry3U77fZNqOepfd/C8uKopmWWo4nagLNMap/mQ8nfHsLY5EMkg9wXyn2P2nOiP2/MoewTtUccJw+64bmEekEpy9/EqHj2xfPf9NoB3zgiPNnlt7pi/1QsBhxQqO6+vbIrMPGaoWLz3Ztp3lx9Z9VZJgAJl2TTdpV3mjq2hUSHD+mHWHXlzXxOEYJbzKzT+uF20CyMP7i+rIPEWhupEmPlwa/eW7TBRgnz4el+LWmjVdzsNSiHe7vOOScZfx3g/lJEFK+lx+7oHh+5dp0kRyF2259ZyPeklC5X2V3OYZs6AnN2QZiiqdQXTPmmEag8hZEsVRo4g7Mz5oT3jTsxHYNXag4bP8c3opidD11mhMDc4qw+hLD4/lBmKDLd6oCl51WCY0hRsGIqpB9ePzH8ZPGZHsvGJOApFP+Ro0kjv+FcrzMqJXfvej1Hp8oynjiKVJRwGUUgrJQgR1nUZjHdA+AdAyQTdPhv3Sg+C6rfOKjKu1VKwAuFu1aUiaSq4nLgVNgaX5OgyKdEn/Joa7ExbhJ/FwvI+sM53UkhlGH3vE3qdVtJsUZhM0nHE4v/VFWB3xJhBwqt2Vs9XdBd3AFfZgbGI5XGD+atGy4231G1IAFWmURzXrUe7lfgO2+bu0ig6uBpIpT0SOlvLf4P97EM8CCqjGa6d7kgTN8dSzMfcEkfDJVInvIIOfCl4sqYSRrH/HVmxKTZDvSd0C/D
 rnBVmpPt
 M9qnEVr/FNzDHbjZqq+PCwhrBIfcY425JHvzAKq21P4r2RBGDuRCHnzFTW+cmIy5uDmh+qQeWfUbz5CJVnfu3b2vT4k4NO+pXhT0EGm4jUCracaf+nI9cGKuV6GFifRWeo0X//Q/Hf+OEtD4HaLbC6LJwCqiZ7ODNDTkfKVYx6HYD1UIqvNvb4LEn4jH0E4YtxuiJUyqD7MrQnINneYfG/wt1GJhUmxNPZDsSnSvr1uboa73ml7rpAosi6UTBM8QV4qe6CsV6KlmFWXDDScBzHdDyZjoEqGjn9coKIhPlUUjSchLbpi0b0HKujVegmLyr2eGG5BNH1afs2oFWUrmyXIAZd+bpmNqggKiGgeSP0tXB7++92ZRAfbFpXY4VM9p6U1Z3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 03:04:53PM +0530, Dev Jain wrote:
> When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
> to PMD_SIZE internally, if it deems huge mappings to be eligible.
> Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
> from this, it also reduces the probability of allocation in case vmalloc
> fails to allocate hugepages - in the fallback case, vmalloc tries to use
> the original alignment and allocate basepages, which unfortunately will
> again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
> the search for a free space in vmalloc region.
> 
> Therefore, remove this constraint.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> mm-selftests pass, but I am not sure if they touch execmem code, and I
> have no experience with this code.
> 
>  mm/execmem.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 0822305413ec..810a4ba9c924 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
>  	if (kasan)
>  		vm_flags |= VM_DEFER_KMEMLEAK;
>  
> -	if (vm_flags & VM_ALLOW_HUGE_VMAP)
> -		align = PMD_SIZE;
> -
>  	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
>  				 pgprot, vm_flags, NUMA_NO_NODE,
>  				 __builtin_return_address(0));
> -- 
> 2.30.2
> 

-- 
Sincerely yours,
Mike.

