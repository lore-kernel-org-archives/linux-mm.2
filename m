Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F369C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DAE6B008A; Tue,  8 Sep 2026 04:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEEE6B008C; Tue,  8 Sep 2026 04:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F116B0092; Tue,  8 Sep 2026 04:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2046B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:30:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B727C03A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:30:08 +0000 (UTC)
X-FDA: 85189922496.23.394D027
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D07F4100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:30:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfMk3wkz;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebCInI9e4Od3AHhat/r530l+pPuLJ5UuOoklobhTgGY=;
	b=fV32xyPRkeN7d6AESRiyr3YkpxvPQMR4yJhub1QNxuph6ydMKQx0AaFLZt1cITjAA+oPGi
	4xyU8GvRTnX/Lzla3xjF/pcqoQOzLEZb9Y6f8ze36A0ZCdGhEg3b0DwiH10V7yo4auhwlt
	aolDf/lDF74U3EhO5fO55fu5MYbsUVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfMk3wkz;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788856206;
	b=PNWoq1h3cMviROi6y+MoahQoRuWqDrsVHI2+yFfqEidPkHanyThIpeL26Y54iAoIt4Rhs9
	1e9/bPkZtyQXeODDv32+OhLFWFWmoT3YFZB6Ieb5cLKBeaTLMkSM9+7HMVkL1uXikkuofZ
	gLC4QtiV7oTtRbeKlT+RfR8u9zLKb8U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20FDC601DB;
	Tue,  8 Sep 2026 08:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B861B1F00A3A;
	Tue,  8 Sep 2026 08:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788856205;
	bh=ebCInI9e4Od3AHhat/r530l+pPuLJ5UuOoklobhTgGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LfMk3wkzpvMtWNa9uiopWPpLLfLC13UUn6mEqFqhG/qMNhTUxJTv7gWgiL7w95bRD
	 0vKcjlDAq/jahkdL2mFfijUfIk0dy98QCKqCYCoBiamLeocjj2qYqrxrBv7ARFcR5C
	 Rxvjll3Oi27ywmi1n3bgfo8nr6Os4VRAiVCza9J/7bwfxXclMu+540O9RdZLegUk+b
	 kRZQPL9CXB4lsxrAYrOFu5r6ACtrJAHouHzOogyfavu/f5tFWxhEAWPThHykKFonwd
	 pH04EutZIU3bIOPIhD/5bI+sY9aOEhpBUDY+xHn3JTHWCT0ZZ093A872Pyd4rJMQRk
	 39FODpLeFY51A==
Message-ID: <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
Date: Tue, 8 Sep 2026 10:29:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, kas@kernel.org, rppt@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zin5e1huw7ymebid5sb9hw9isn5dtyca
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D07F4100002
X-Rspam-User: 
X-HE-Tag: 1788856206-715670
X-HE-Meta: U2FsdGVkX18ObFTA2LtQpDxvA5PPWsMHuMBzQAu/ViSSHOHPIt/I/sMqRSaTK6IYo29VtCExTOm4gIN5yMnPUyEa+nC5KTesJ4IOuEXzvxDFK93bz7PxO3hzVv8hq+MLMZM/Of3gS4FNDLkeB/TD5bkjNobR0C5nKgN0mKtt22BkEyKIfckVHeyKCvoKFFs66AhR/L9CE9sUgicTzIqqCCpJk6uphyxDT9hWPrUwqwfyZIDGaZOaj3XcMPTl49/ReaA5kq9lbxAmGzZoAMTmtMZ9sMJTKLAxDaaKL8ISv2egQ6/4SarR7zqJvEAcLViLbS6zsANatucGaBUX0o/yjceGsiVGMM7+JA/8mroVIZpnwnc0Aclt0vf8vezpSsW5e2HMuC/zG0+qsr7QdqlRnrjWXEXGKR8/CHDQF4PmgTvnx2c2Zyq4+wkFweI5cHMS1Y9aReflIhg+NOGvyoOQiT2NGd894GqfZ++aC/s9A4N0swC29YZfZPi8oOQNgTUF12dClvlvzr03bYV3I3kXGmg3k4dc8lCgtEUObjylarjDFo3atAAXQ/porPxluOHTr9N0GxXonb6DhG89NBK+zJz/mQqrhIvDDjRQl2GhJXE9V+M1hkYqxGPFBXkHO0s4Vcx8PqKSHM4aCZbaer6JazBjnEnOvNmrRy+WpxHyT4z+Dz/hDxk9Pf2ompGAn+CVP1ZhyESg2v9wlR514kYQfSkvtiM/b8TQjIWSQVQXj8S9EpLVZ4BhEfL1hrqcSecn+SqCNKK8GeRwTSQLzmdjWnBxT1oabVgCz4S8ZPXgYZcTYIg/AT+zvZdUk9FytDFXV1rNHwXXgGT6aPDYIa3BMVu1Z0eZlCRxdMZ4Z1ErSwSW6nXmadpuDcc+j7ah/Q8gJ8vlPfFqTbLFi97WNXpCCgmhDaADl0oO/fdRZca7j2LkYNf+F0Gesxdv85bn3yMTFxBM7jKN5d/bPKpZXBF
 7/4rkJVB
 dbDb5HdCN+JAVhfBSa3FpqTs8qTibWrEQKxXxmGCA23Xiud85aUMDmRg4Ve4/yD5dCU6ynwlnUUAEbmsU53LOKmb5P/X0DXT6UpwxhE/aGSCdDtKhx9aY6N+3Zr22CZXRqEpgLCu6bRC9ANoGTNG9ZR7pvIkfMYCr39O2oK/cksakBHusTXP1mlPOWquSXdcA1fX8ib3Y6esrorelhxiiLXNqFfefw0DS4B8uKOR9tAYYDQykCWJUNFbEmuWlrDO9LmRO3mrhByrC6hDFqucoZnY3dessdfE+kOVmjfNTjKX839oP6SbNBR7FMuWlXzNvZfCBPEInp0WNtEyvZXIVCLjtwPGZ9eHXyILJU0wLvFzUTGgGjR+lm/UKnZMO0M1iAfGK9HrE7mnzhUxyZa0AZgz4LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 17:18, Xueyuan Chen wrote:
> The persistent huge zero folio is shared globally and should stay zero
> after initialization. As Jann Horn pointed out [1], kernel bugs have
> ended up writing to pages that were meant to be read-only, including in
> security-sensitive cases. Making the folio read-only in the direct map
> turns such writes into faults instead of silent zero-page corruption.
> 
> Add a page-based helper consistent with the existing direct-map interfaces.
> Handle TLB invalidation in the architecture implementation; unsupported
> architectures retain their current behavior.
> 
> Protect the folio after initialization. Skip highmem folios, which have no
> permanent direct-map mapping.
> 
> Inspired by Jann Horn's read-only zero page work [1] and follow-up
> discussion [3] with Yang Shi.
> 
> Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
> Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
> Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/set_memory.h | 17 +++++++++++++++++
>  mm/huge_memory.c           | 13 ++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3fe293cfed8c..ed9ce04b18a1 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
>  #endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
> +#ifndef set_direct_map_ro
> +/**
> + * set_direct_map_ro - make a direct-map range read-only
> + * @page: first page in the direct-map range
> + * @nr: number of pages in the range
> + *
> + * Make the direct-map range starting at @page read-only and invalidate stale
> + * writable translations before returning.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_X86_64
>  int set_mce_nospec(unsigned long pfn);
>  int clear_mce_nospec(unsigned long pfn);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 54494c3fa983..742283b36d74 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -42,6 +42,7 @@
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
>  #include <linux/cleanup.h>
> +#include <linux/set_memory.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
>  	huge_zero_folio = alloc_huge_zero_folio();
>  	if (!huge_zero_folio) {
>  		pr_warn("Allocating persistent huge zero folio failed\n");
> -	} else {
> -		huge_zero_pfn = folio_pfn(huge_zero_folio);
> -		count_vm_event(THP_ZERO_PAGE_ALLOC);
> +		return 0;
>  	}
> +
> +	huge_zero_pfn = folio_pfn(huge_zero_folio);
> +	count_vm_event(THP_ZERO_PAGE_ALLOC);
> +
> +	/* Highmem folios have no permanent direct-map mapping to protect. */
> +	if (!folio_test_highmem(huge_zero_folio))
> +		set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);

Assuming we keep the page-based approach, can't we just move the highmem test in
there?

-- 
Cheers,

David

