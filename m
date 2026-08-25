Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C007C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797936B0088; Tue, 25 Aug 2026 11:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76ED56B00B4; Tue, 25 Aug 2026 11:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6840C6B00B6; Tue, 25 Aug 2026 11:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE076B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:52:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4C361C1B99
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:52:31 +0000 (UTC)
X-FDA: 85140234102.06.A97056E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E75C3140004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:52:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oI2Zk6aP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787673150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXk+8AC9tMdedJd5dFONsAVyXoD+TKxKvDZGwEn5NWc=;
	b=N3bE2Y4iQXR8naYkFOjE+413kwmBMj6+ljrU8oK03odNmdsp5d3ije1u2Qd0WpSIzPRoDr
	VC6UADdFlRXp6ShBwoLtBi7jBiFyBH+CJO+R9atC+YZFv271rWVcWj8oi3WfJsFKzcszPD
	ZfyXeRfMmEYfW71uUWOH2VZEamAmvyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787673150;
	b=bXWYP585dIS0tMv2KcRij7w0yEJbsayd8KDx3bv2Fa4ijefsL/w704coR2nNBjN+bS6LMf
	F8gppCWg0fkjG1f7bfeeB1fpKR8a01RX5mc3qQVMuIJdYpEokyxLTmEPwFQY/pXhqg8P+w
	glzxD60gD6c0i9Y7OA50xODHDc46qzI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oI2Zk6aP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40A5440266;
	Tue, 25 Aug 2026 15:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23831F000E9;
	Tue, 25 Aug 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673149;
	bh=ZXk+8AC9tMdedJd5dFONsAVyXoD+TKxKvDZGwEn5NWc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oI2Zk6aPcKkinmBuXHsTZ0lPJ4zsulOOd+7Q8ro+fhQrEaP7SevErk++Sfea1CJHw
	 RTBp0SQ0bSsWlDvvcmXRJ0fkpWy7wuwH18ye7GWtdS442r3bFLRANmLUtv0GBoMf4k
	 loic+XmPvhLSIQlKZS3Otbd5tQDJe9tlzll4BHZzYLDH00tWHwOKOQdrmEdE8C2tHa
	 E6Y2ySQ+ywO71VP3c7v9uDXbV9Fo+xdyoP2wyUOH9bSLvYStTgwwTNsEmeqk+ZddGd
	 nKb4s3xFXsLeVwCfjLCXrP20slkDnhpBM2ZVH0Vs0QxetWz+wIrI6DkAcu9PjWZm86
	 UGrGKqcDgz/WA==
Message-ID: <c81ff923-800c-4ef4-b6e4-ec9f5eb1671f@kernel.org>
Date: Tue, 25 Aug 2026 17:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] arm64/mm: add set_direct_map_ro_noflush()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-3-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730090647.2401252-3-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E75C3140004
X-Stat-Signature: iqmkjyd4eusffhbfodho4nofs4ao5ztr
X-Rspam-User: 
X-HE-Tag: 1787673149-11949
X-HE-Meta: U2FsdGVkX19i0y8Hp3XS91skOOTuQ4Ve1xxvHyOxw6vRs26T1UqOIWOIoUOTa3b2GIAUwgSUYfh87csBuM01xDTOB+IFJkRprtXB9lMiRc1PS2Bp9BZ76hHObGsTTiqzGTPSeqnpfLXRWKuSmTJpDjO8tk/ibkSnRpSAoXNlvftqzffD00F+M/I+A9jYlLEZgdc+xBbLVKs/xW9mXy66iNtdOv6K929UPwht5va+5dm4yyKAO18r5Ib7AUmAPtd/T5IswAiyJd5DOF8xruHw4y0wMl8JOPJLvHrDbJOKOhaY7hf4UST5NJahk7lBBNP7c96l5PCF0voiIATjYnhQO8xXEjr/kfUvwH/g6XAgq4NtcKGB2cN67Huo8xUDKLlPvmPNeaMsNPJ+F7O4K8HnFiBg/BcqeBb55Vcu8oaVkuDfTFUiKT4MjLPfjywKNoqHYkqcwhMWB9XEcxbyRy0VOs2zB+pLci503OPqh4mS1udpT2st9+2LdnOZkmvA8lrYYCjYcEEoW7kikMqJ175sXMs669La9SGiyDat0O9QL4i7gWDqmRnt1Vi1Lrl07YksPEHDcf2bYQ0bVB9Kn7FKRwQvJPKNov3f1Gxr+mwXpNA/HIo7wrtHqsofA2G3L3sTJWJU7VMhZBVvg/DCJpNQoYvO96d2zeJ7a22NSBzrhtFB/x3/EtamNOsAvOxocpfNVGeuI2iz+4ORsSLgmd2MrmOOZg06EgC2himjX7GJ233tY+urLCbzVyqTsCHnbdxtDuZqNBt7yIdWyFE7GhuxGbUkEh4IGY7di450A86bKvFxKjQf9l+iA79E97DtdBk4UByuQfLRo2U1udZOTCMMrh+BS1sIXQxoCZSTzKYjJ8rFPVimqIwNH/Xljj12gto2ts77kJLdvAJonDxKXMFj6Yw4iInBFQKvle7gNMuWzGg8yUZDLGsZdgmuzLA3onnqIfPMO6jdDa6En7JK1nI
 3XKoYnK0
 YFH72rjWqC3bqr6tzwPmK30DSR8L1ZmvFE23UhTDaAhCQ3lWboQjjH2xX9zls4eirKmn0LONF7BuvypE+OR7sjFEfEINQB+85EZgZ0xfIS64U8S6q1Bw1VFDGBB+bqZTpMO6Rj6xaTaj6dsF7S+ryLoYZ/IbbP8/F6HBgOmAhIrhw4Zi9ZP7q+Da432h2mEoMUw3ERCPJtclcUcDg5iHrJjddSf4e6hQL7jDONi9kGg+wD6xG+m73Gr7EAh8GdFDu8UwFmKUV7dSDc9lCxDAS4VN/z8J7mu8LvYhh1mkl1ly6Uhym73xGPReYES/9vzqmQo21hojfLEgK4VM3tWXZ2V07X6Tw5SQZhLHCMOO5pmOfXOmv2fwuMPrpzZEpnKsdFon2UzBFVKhC3VvRzQBHt7fiiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 11:06, Xueyuan Chen wrote:
> Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
> the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
> existing can_set_direct_map() guard and leave TLB invalidation to the
> caller.
> 
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/include/asm/set_memory.h |  2 ++
>  arch/arm64/mm/pageattr.c            | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> index 90f61b17275e..7083260303c3 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
> +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
>  bool kernel_page_present(struct page *page);
>  
>  int set_memory_encrypted(unsigned long addr, int numpages);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index ce035e1b4eaf..c51236b61651 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	return set_memory_valid(addr, nr, valid);
>  }
>  
> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
> +{
> +	if (!can_set_direct_map())
> +		return 0;
> +
> +	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
> +				 __pgprot(PTE_RDONLY),
> +				 __pgprot(PTE_WRITE));
> +}
> +
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  /*
>   * This is - apart from the return value - doing the same

We'll need an ACK from arm64 maintaines. To me this looks good.

-- 
Cheers,

David

