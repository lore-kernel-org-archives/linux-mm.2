Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB455C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B8B6B0088; Tue, 28 Jul 2026 08:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CB96B0098; Tue, 28 Jul 2026 08:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31F36B0099; Tue, 28 Jul 2026 08:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 743FF6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:09:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3009140377
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:09:06 +0000 (UTC)
X-FDA: 85038064692.02.5823B93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F17A20007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:09:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGXgV9YQ;
	spf=pass (imf31.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coBQCYguauEUFlE+zRehCazJ7YtpgsT9g1InCofXSTM=;
	b=X5ppY6D8xFm8coJKxeICah3AJppOY2iNyQtTzg537KaM/aRbRdK7m9ISAxc410WL6DnvJY
	dmRF/Bmm5bcYdOFSW5zVb3ZQ9vnyUpDLXx5z74VM005ZSdnXoGh3fCqLUVlSAoYBVGhU92
	zdQoSNn4ieKoG9Qz2jynrTkdQZXWm48=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGXgV9YQ;
	spf=pass (imf31.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240545;
	b=T6Gf6Jv1swXFPRfzLC3z/anSt93zLl+xtUF1uOLukkZ3kU6MzjSpouNhM4/BFwnJyRip1C
	uSIYhlJ73meQJq77u3scNd1pmdI9e1bdxR7RcznEUE1869W0ttgdeUlO9nc9N4Q0R1yq54
	PAqf0k/os6qA25I54xtd/gnqVxfQLRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 164A9436F6;
	Tue, 28 Jul 2026 12:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BC31F000E9;
	Tue, 28 Jul 2026 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785240544;
	bh=coBQCYguauEUFlE+zRehCazJ7YtpgsT9g1InCofXSTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eGXgV9YQEy+iglnVsOeKzzWKZ51pMguT48dsQ8WNzvcPPyWqhIhse1zFPQy9NWsIF
	 qR86lFypyCG8ra+bC1hW5gF+wH7jsWK+lPfg1wkaIotLjtodukmtZKhhq2BTpfMRqr
	 b6nawRofbM/q0NSkooh8JKp2tFvaigsqZ+dWMTjlIt4LBQNzlxyMoGVcVH690kopwH
	 UgyTOkip3FZucPLm+wg1g8QucTaKogZr3lUhBbGPAfFYJhINOM6jVtCQ2tdXv4+/ye
	 7aVrMzkj2hvtxI5Ig/pW5pIHk/4IhA3fmIR44zXT3CU1PIARgFC1Qbfu4pB2rE1PtI
	 aWsWTI5hPg5ig==
Date: Tue, 28 Jul 2026 13:08:57 +0100
From: Will Deacon <will@kernel.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, david@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, Wen Jiang <jiangwen6@xiaomi.com>,
	Leo Yan <leo.yan@arm.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
Message-ID: <amib2d8um2ZwsMDU@willie-the-truck>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-3-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F17A20007
X-Stat-Signature: 95ow97aa9csrp7ktbsaaskwcn8eo567n
X-HE-Tag: 1785240545-531815
X-HE-Meta: U2FsdGVkX1+F08+id0JKYvqEiznVsHH/oRZYm4GVpEkmj/AyUMH6rX7OCQPeOcIgkHBWTvv/x3XjZyEXTJ4XRDzWFFPUapqFic8eqTyjhEJ+mk+/KXNrSi506FonV8Pqjhz5oL4Ik0taSppWFvYX/PPSpuJZI9ruqBZZGpsCaM5JWrvYjIhRR1NnlEXieyOLP5t33YMyk442P0AeO5VciuGiTMNydvu22LRJ3WSKcaEjQb0MrA9XoKXsfniIbTujHhNKbVDSQdtdNx9+4U0tzatn0mlDSDwYbVCQUssyNO62lonxsm5ZYSwrjPn4LEN5CgtBsAOikUMrEbR5pwPQoZA3vHMr0q0m3fQg7qQeQkqCj0QQWYANtW0yODE3iw5SxBv2cEBbQ/fEicehP83aodnD3UDD6j9W5FI9ZXBtgh726zg9EcqNdQqsGI3dpMMv4iZ2y+Hc/kN0YdoQjvH/DsCGqhH4i/0huj8IX6zVxbylJrT8AJyt18H3R1xPNSUHpshuu+q+TeBEVvdfOQ9g1C/TcF9ttrOuCV8yauy8OZs4GVQb3ArgXDVl1OFnMznmb/w1CtD8x/Kse+Ebrn5Ru4psGXL/TG7rDovD+IywPmdGPTiSAWheBkIDXTFcHzuBm6WazSdq1y32W0PZ5C7x1O2JU3BlrsTBwTPTXBob9n1x8jpQUn3lRT5ATMq8CA7bOnL86pQRXje3q+kTetQM3LrrWeg8qy/Rn3OaScb7ODg+eonz/Jj+dxD/YmHHp+j0q4DA8CTC8M787IqisvmIJkj9AnUeA/T4FXZM1awKLb9MNeu1bDpQqFXuxPz3l+1C5T2xUS5R/V2FxHh+/Z2hE5a9MNCVCq0VuUCCSv2J62veSffZ51QQkbP6BNNw3/NPrjWUBjxGttZvc6BTUxZNBo8BWJQ+jSJcCEKqM2oAn1jqL2cbIgayRqPrXoTgVeZTJqem7ds/2uuNSSVvGEX
 KgEiR2Jr
 yIqyEG0EVvHygcVzSfk25ycCKYSJ35vKCs5DK3kTKtPAP3Cc7M4H+svhNKOFTwn3rSabeylKfLrzmwVHjHJ79u1JNxjscOVMYofGf0H4FhVHVjEYbpczHBbr1GsxbEXDAZGCEU3Q+SPuhhYsucvolcY3Ei26aWjVswGJcEFOzzqVmA4x2sN7+JgnNef2HA1QRZvzSspGi2kBeiwTPIUuYrixEMNweamz3awE4/W+VvuRjd1G99prrs3JVpcXgveTv/Qg93k8d5Vp4JYUKeHEI1erIjy+GJujymDIymtLqPLqNkJP8b2Kgz+NkJNLt9fzLfzMuWfa8oFUYp9iiNopmt95eou7jLVYFLRkQOet32hKcJpKvS07tpxCYdHp0knFfUc+meRPEfLcjbedNRPel1qCMZZ+0zyRvWw0SntQiP0nAkhxk+kuWL8bronfj7ajq9ZFdSRXzfEIVVCGKy3A0wTCFXBn6vlY5EfQRPzWDgXPgz7x9y1CUDVLL4RllSuiV9hLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 08:08:08PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.
> 
> For CONT_PTE_SIZE-aligned ranges, return a power-of-two mapping size that
> may cover multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes
> are vmalloc mapping spans, not HugeTLB hstate sizes.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..d665f9d687422 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
>  	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
>  	 * aligned in both virtual and physical space, then we can pte-map the
>  	 * block using the PTE_CONT bit for more efficient use of the TLB.
> +	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
> +	 * capped below PMD_SIZE.
>  	 */
>  	if (max_page_shift < CONT_PTE_SHIFT)
>  		return PAGE_SIZE;
> @@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
> 
> -	return CONT_PTE_SIZE;
> +	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> +	size = rounddown_pow_of_two(size);
> +	return size;

Why does this have to be a power of two? We should be able to work with
regions where the start and end are suitably aligned. Is it because the
hugetlb code works in terms of shifts?

Will

