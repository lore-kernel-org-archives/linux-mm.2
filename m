Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC47C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C656B008C; Thu, 17 Sep 2026 11:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCCB6B0092; Thu, 17 Sep 2026 11:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCC26B0093; Thu, 17 Sep 2026 11:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 936396B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:38:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D813E1A03BB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:38:49 +0000 (UTC)
X-FDA: 85223661978.15.BC7A4EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1601120008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:38:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQZwVmSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQZwVmSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659528;
	b=1IMUPomBZ4sHL7lRapSTD26OKvnIGhcTQVKXBUjnSF9VkHA+Xcru2t8FrSVRhi5zOPmA0T
	JcWaCvvv9bEVoxkPyv0gvzUev1f+B10mbyrDIbnsq8tL0P+zBLz0GH0qh7WT5jrhTd+l+p
	2fbhvZBofJXyFPZfL2ow7AUKgon3Q30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbSgagK4EFOCUpu2UGkI95umgUxv4F6MMs1fhwfHLOM=;
	b=UJ3O84jNAULTdpE6KDdIZju5A3KWluD3hZUVHYOXMVg67d1YLCrsDuGesNRJKr+LdFBFcs
	FDsQkqMjXcVneSjufTKieSpwYiZgD7mBW56VKI2ZMuf1D0Xunw863v+ro3Ob3qeCCWqd6l
	2lE1FDFWXj/Zs1nEc3lcL/vj/T9F1qo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 737CC601F1;
	Thu, 17 Sep 2026 15:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DEB1F00898;
	Thu, 17 Sep 2026 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789659527;
	bh=zbSgagK4EFOCUpu2UGkI95umgUxv4F6MMs1fhwfHLOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YQZwVmSXvyJGDGxoiIKuILLAsmdM03f+GMfUozW8IVPM7vAEbHpx8A2UTwTex3jHf
	 DifV3qiO4PBwahZum1RTZFZGYdnV1lJwKpDYrawDZ6vHn233grx/DJDDdsbQLnMF99
	 GgIYJrm1CE/B7BdcJrccaQ16wJIF22i/Nf5MUKCFpuRkGTPwPZUJRAXdj4fbkYF+Vs
	 UBEGjHU6DnDn14B6ltXxuUfyosVkJpwNhOJPi12iwasHixlxEqvlEI6AQ4YnpsUJxt
	 t1ZVlKu0aPEMvUqour9cd3YjV1lNaKfadqLD48IqwghpXrEVWwtEjw6yGEUdfHK8Xv
	 Me9TNxuE23Shg==
Message-ID: <15977036-c5a4-477f-8cef-3bfd0a585c55@kernel.org>
Date: Thu, 17 Sep 2026 17:38:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge
 zero page
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260917121010.60966-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917121010.60966-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1601120008
X-Stat-Signature: chncpssps6zrx6s4icmd4um5699fhs9h
X-Rspamd-Server: rspam01
X-HE-Tag: 1789659527-501579
X-HE-Meta: U2FsdGVkX1+3G9GxJNxQAGJj7+ja5zUf4A2FFFWzANsQnm0PzSLJHXnF2ZSdx32U851zQKo33WpTx1qQqKe3miI9yiZnoNogRbAVX+HdGjRZOJqCsNaVpy8Q1agC0jc/gIfqzXJN8U35c8cFCwWV6/2W+AHad2jjVc2HYT/sHXA55fav8pLstEDx179fxRNZ+Ae04rAJxMr5/lfkUvUKhi9w4F+VWivlp3zcPHxn3rPMD0E1q9C4AzhOuZjCrGZMWDIsQb2fptC18hWH4kuSG7flw+jKpnBcTJbHr+wxSJdhceU/VZaN1OeFoP+gmrHndmFEAEluBJOMDedR7s0fhm/gQFJ7Rn1yMczqdo6SRxpV5aSp8GJr26/ABjIE6xR3tAglkfz0Ie1s0vDGQtoSE7bCSJwKa3+bLoF9hOlb3ClT1ZHxZoN4bAbdg/6eSttHAIfHoQk8hc/O3DRrlAg/xCTudIDyrdPcGijMx3ihq56C8aLhiCecd/zGETh0bDxJWdo8BsBkQ+ZMoKoE15Dbwi2wzfHem+M2CIp5eNBM8Kh4/ccLlNKiyU0oHlOfrrPflMG2GkpCd5RFI2YbX4ElwVL0uOBLipQpR7PNj0GuTdf0zyJiEF64GXZXXX01eUruOmTMFkUXKVSjIZst7Px1598MmbLlsJajW/ta+pwHHsdlIh3aqiUO36zQP3HvXj1iq+WiFC8ADskNXQJSUg2fnltbnmeDkOCaNkY79Mbuh2iRArKoHG3bWz1MLgSTd4OHNn6A4CeShELhLqzmKNBUSdGXUzCFUSg0mARMEQFBhrt31nDc0gm0A/ixJuR7HGDXkCkjcxKen6/toyg9RIEvzNaHf4mNj1QHIOUD5gYjNtCM+eVnXaK5VozeG/FtS3qbJG5RvP0yMuWogfltK99wD7yjzW4hobpTmVEjHlV/aCJWQGYzAKjHy0ZozLDaKF83V/jIammYDMLw/D9ojnz
 Lr5Qezta
 zP2cNBJRhcpRUnCbiUnXNfixq1yhfCLCqiKVpq0XNxy3kEmU24v9et0aSuxE/iVkEd1MlPlHPfIWw92Zxe31Uw/+mTuMqVbhA0Ds4NsMN6vs6WWOZgWXFqR7AlNeAyxLOJwLPcKEBy7u9wvTTbTNt0FZ8iw+Qfuf7DEgmS4s+YM8U6zjlkVczwATJ0z7K9jYmHh2+Afxp2QpqITAe9Yw8/YcvcsE7F17zTsG5rSUQqcgYCKM1OTqOPlSnjvLXsXJ1Ou0RoIXoTzRm2yTEp5TbzTNh91kIZP3wd5CTuDOtmJCq5J+H0pteGmGephYSPDlPMfRT+evmY+jOw/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 14:10, Lance Yang wrote:
> vm_mixed_zeropage_allowed() validates zeropage insertion into
> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
> through vmf_insert_pfn_pmd().

I think we want a clear description why we would want to forbid it. Is it
related to vm_mixed_ok/vm_mixed_zeropage_allowed?

Once again I am confused about which interfaces are actually valid for
VM_MIXEDMAP.>
> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
> 
> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bfd972b997f9..c02f21ce4f4c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1728,6 +1728,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
>  						(VM_PFNMAP|VM_MIXEDMAP));
>  	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
>  
> +	if (unlikely(is_huge_zero_pfn(pfn)))
> +		return VM_FAULT_SIGBUS;
> +
>  	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>  
>  	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);

-- 
Cheers,

David

