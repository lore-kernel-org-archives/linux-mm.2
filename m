Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4F01073CA5
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E24F6B0088; Wed,  8 Apr 2026 08:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693AE6B0089; Wed,  8 Apr 2026 08:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581E76B008A; Wed,  8 Apr 2026 08:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4703C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:28:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4DB5140AC1
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:28:14 +0000 (UTC)
X-FDA: 84635316108.30.CD2900B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECC8D140005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:28:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kAEBB8kz;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aMf679OPttM6U5ARxRngz3Ey50x1fQtVbKPfutV6O0=;
	b=URZAu3ShEyoUNvlmzLv5at0atD3tx4jUBfQS8BEtAgi209sB3ONpfo4zBHcoY7nY1OggM5
	i0Ra/SyxOGa0o1Kub/+v+1yhNK5+7CtoniAaXMSKq4qKn/zprLq5v2h8/pj0kRB4BJwFKr
	mPS76Aim5EYbHov/7QDhV8aOMJG5aNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651293; a=rsa-sha256;
	cv=none;
	b=Xv6m7jbh0fBBOClqpva6Sok/TrlSGnHkJXg39T2NYo6y3yJwQmfh7XL9plwGqg6zh7S4Mb
	9uYWm7Uu9abP2lzbWoC9qm5bxlcY05dRoL7zXem5x7TN5SYco3TGE88gMdQsfTQDW/gQ/H
	nAWl2ojKynknHvOhFjypO750DMMDShM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kAEBB8kz;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 004D441A33;
	Wed,  8 Apr 2026 12:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96885C19421;
	Wed,  8 Apr 2026 12:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775651291;
	bh=eCmVTS83bSAS8xQjAy1lmOxcoN300rRw+xckrc2hsRY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kAEBB8kzYQwMLJGcNYis8/369QPvVGiPjye3nlYnvyT5nT9mHWY8qcWW+MFlrn25U
	 csMT2NcfMYjPEdLfnU9H67DuPPIX2avOkV/NEYTpW8TZJipN21NcsWNz8SQBRd33Ko
	 Q+9D4+V01Rc3dX5MoNVqSALi189uEt/d43kv5sfmwVhxwGmmsQaktmN2TakJcH75BM
	 9DTl2ZR2gKC+pyx+uoehWwMzoJsFae7BCPQA/lWZt8rInQu3p8ALLTx5aVFnNtUQTq
	 4GJ2Rd9at0Y/wFkTNmVwy3SnbuKo26oOtNj6sitxgXGBStqs9HGKoxyN6F+2q8BJA8
	 xxrLI0TbrglFA==
Message-ID: <4290fcdb-47d1-4f74-97f3-51ac581efeaf@kernel.org>
Date: Wed, 8 Apr 2026 14:28:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 12/16] arm64/mm: Abstract printing of pxd_val()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-13-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-13-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ss4p4f3d96ntkxqxdz4rosuisjqajcyi
X-Rspamd-Queue-Id: ECC8D140005
X-Rspam-User: 
X-HE-Tag: 1775651292-840731
X-HE-Meta: U2FsdGVkX1++0k8VjPEjFT5JJm19Hqt9uVU36Rkncl8GMZSyo0hbQm4ntqBL/9KSKPpYZ2T+rEclL+9Pms+E2IA3pg8zCLEuG0jaV/dujl7uB4kR67d431DxEcHyQ6gL9e6lCAJhOr4YhGoGGL1JPKSw7po1GUi/h3OcztYkGJeVagImX7oGLzCnR7XqLALmE7HDxly2tVm4AlEihxiOKWNWvR+QECvbwXp4aBX+7FYIKT3ILIQYnz3C9Ko10IRXK6vhu/A2sjmVxctxs/gPAHZ4IAy6zunHWNAJtRL9G11UkE21ZJ1fCcPV6JtXAXncgtG6K9ufDZiH32mnM9B2AzT5mQNiaeGbKRxTo5ELThuJ6N19vgQPo+B/18UhtFmNiwbPRfLTTZ0aOZSZRwGmO/eFB2mSuDaaD82izXKM5oYBX1sHa+wYc0kztKXLhRqG6gSVLBek6TQV1/7rbOyzgubQnQARna4uOBlW8/C+cOPilgE2o9Yct7oBUkoEHiebAN3fXdd5gqBlABW8NX+pyA9Ao84PtjQqagXt3hDrNGRLAyxdmkouteoMy1JBrBroZZFFt3BCqgCSpkhBqhqG0z5VSBjGv3o66/r4Io2MfiNnanGWj13BomLTRXv89xr5c3tjRSMdR2z4vj17yg5AuiPPX0TX7wywJYA9UjHnMhg3XvyZT8Kj+NmDb/i44fYoMqCHjs/2TQBX41l/1n15thrMTdcoPgTXbS0Mlb5QQubtefoqjcJR+EZrnx7WZ79p/gX74+gc680LQ9IdH3PXA8i00LYer2ONWx1DXcCTlZzbRns8BxcxuXTWl/Ai5imO67CtOB8wiTF/kCIOqWmXn5RpCpmEc11ryNXKG8GY0l6ARK3Z/8SwFndQ9Dkbhs6C4v0xZLuP/0Zlor8EE15qA0bBFdz2d10Wnonx9szTuV/tpqsoFFnUncPmyAXEo8WMZC6isprq2s+nISXlWX9
 CtR+Npy0
 mdoPZkI89NvlTUZxb8jdLduJ/h5UC92QQ1z+QSFzp5D3twk6pUChHbGz0EUXhtDnhidVZr07k2Ig/Vonqv7uzxB2Ze+FBfKD9dS9pL/0rWPHTsDdeq77s52zhyVxKbWpeJ375T/GHGrKZ2D4F/AevqrZj0VPjMPhaMPsZNCsCigHFLHxhRGNjhQZBU4BlubSl4OGc6rPuABMDsLED+jDSAMCJJdhDRNYCePzsq1GycJfTh3Ql9+XR9ItXOZ/wXf1ltwjvDv6Lwj6pglTU5cnFYugPpO7FJHbZ6tyy9BdzHpNIadQwlfi3AkZB8Ib7juAb1cEtve4YsSb0yGxH/sIqZJJS487Ew1EMRU3PLCDAw09w+llhUeLzvYlQiwUGSaECXLVYgfTOYKVlQxu3I4b53K2B+z24gi4dbrZPF3aN06pUh8fH6z2oCh/DyD91LsME+hSv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:

Subject: you probably mean "pxx_val()" ?

> Ahead of adding support for D128 pgtables, refactor places that print
> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
> macro to prepare the argument(s). When using D128 pgtables in future,
> we can simply redefine __PRIpte and __PTIpte_args().
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-types.h |  3 +++
>  arch/arm64/include/asm/pgtable.h       | 22 +++++++++++-----------
>  arch/arm64/mm/fault.c                  | 10 +++++-----
>  3 files changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
> index 265e8301d7ba..dc3791dc9f14 100644
> --- a/arch/arm64/include/asm/pgtable-types.h
> +++ b/arch/arm64/include/asm/pgtable-types.h
> @@ -11,6 +11,9 @@
>  
>  #include <asm/types.h>
>  
> +#define __PRIpte		"016llx"
> +#define __PRIpte_args(val)	((u64)val)

Same comment regarding "pte" being misleading.


-- 
Cheers,

David

