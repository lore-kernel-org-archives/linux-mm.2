Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F99C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00746B0093; Wed, 16 Sep 2026 09:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0C76B00A1; Wed, 16 Sep 2026 09:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E166B00A2; Wed, 16 Sep 2026 09:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A910A6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:39:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 056438071B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:39:39 +0000 (UTC)
X-FDA: 85219732878.29.D344A1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 33753140015
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:39:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXQtV7ay;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565977;
	b=ig6j0fCLm88y9yCqMumubT8/AqcIVPP0Uxo0WEIyjJIcQFHuJ/DJNPVTyXBENZsopiRiJr
	mtnZcRwywF70geBeoAwZabrX1EjWGiI8IHX1ea048jLLbFZ85rYhGoDl6J70qFW7Zmx7C4
	FoBnO6jCAHopAGuh0BGKkcxK1j99xlY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXQtV7ay;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CJKTKLi7BcZoiOMOqeOWLjpP8wwIDKBXVGpShZbw04=;
	b=SLsOKJaJ5ysFWEqKkdK04g22ow7LIr52pUV0xWRJvRbn++L8sGypm9rtxkj0vGEXfJ2nbc
	jIFRkt7Hs3ItUrxtXBxheq3/GvcS83kgkbycvmx3tPa9ygKpCJKKfZFyYX5bJOZ6nqe1mO
	jokPGBlB4ZgZ1XHvf3SaE7IhIlMJjBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D1F540064;
	Wed, 16 Sep 2026 13:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124571F000FF;
	Wed, 16 Sep 2026 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565976;
	bh=8CJKTKLi7BcZoiOMOqeOWLjpP8wwIDKBXVGpShZbw04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WXQtV7ay4gN/YNNAauRSJqHtJ0VSotrNqFfDJUGMVHnVWut9ye6AgxhWmmWcVk7ag
	 fUv5fSxpMSSRWPTgqzAl8ayMt0cQ2qnQ712DFhyu6FKIgxuR+tDm5J8se/eE9Nn831
	 /Lr7fnIbv67BsV1wXPovIpJWyeaJs+5GW+qqkK/arJtUCXzwcczMF+UQhFa8bPezFT
	 7D0hc3CcgIeqmuKB3MlqiNCfPysFgetZusD+wdfqQCuDcRjyJD6n7nVQVbKpMbpVRW
	 nrm0xblVIENDvUYC4ox0BgMVLyUmRFLjYH9gnzEwwV8XNXSncO+ovWJRPr+FLbSjtW
	 7T3veWrMx3aDQ==
Message-ID: <51993407-083f-45b7-990b-105a0c08a5a0@kernel.org>
Date: Wed, 16 Sep 2026 15:39:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/14] arm64/mm: Override read-write accessors for
 vm_page_prot
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-6-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907035030.2839978-6-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33753140015
X-Stat-Signature: k9979w76utpn4m6rrrgtz1h7gomm3o67
X-Rspam-User: 
X-HE-Tag: 1789565977-242595
X-HE-Meta: U2FsdGVkX1+dNQoE4sbwQJJ+IcgHa0AjwRz4KgD9+2TQeVN0xnXU1hyKJp9rWsmdoN88iYQLcI8Db5RTNYME5Bx8RsKw9+QxGZ76ABV/Rq2NYO6MSQmAjYedbNi6AlMkscXqDCLZXxJuYQ6TaezfHP8RAwjqnmgd4vNwFodEgUZWd+Jcor9bu1iuo71InF8oiBhGeUZpmLaxiEl6DJXQExpKQBuspkUQwJSy9kiavqlx5Tm31s0eX9yP0/p9pV207PGhODBSQDlC3Le6qs6DcQI4lzMBkZUuyR9ClJPlaLZF28OEn6E9UgeEP9mtsDrustWFDi2uiHdX+PigJS+Q0jT+03TiFlK/2lFvc5AZ7PrC9uVWgL83ZE0Pe6a8uIH/mf+bAWHJwfc1bvi0s1iKFgP1Xm4Q15W/sqZ7ccyH26LdcA2Ya3rtb6dHJvw4e/leTDOPwa7qt6ra8lIlQT5+m30boxR6e8TISaCPvkBIcaLi50LZ6hePh9Wj5EW2UCuV93EIm2X/okVyGT7hxCr+DOyuJWW998iuqs91JjITDayo4BT184AeJqDuqLwYkJABV0DoGhWoDRZ6pK4shyIJONRe5lO1TI0oTgLPXI6Dk3mrn0xCF/IwEmsYoCWY6igHU4Xqvaf78KhBjFKg3EhgZILWh9fz2rNg8NdEcIl2RsVcLfw2V35ENwWlOmsv+UBKOQ6BecxXZEO+DEhCZm/YV8ojSBATdm4fxZy3+WiOciibsnA4EaowCofMpRKBYnVKV4qH7aeEVPJCdHPILnB+xCCVOIvm05NrAW1xE5z9fL0VKXDKLc2z0Wuz0NR4bQufit14a5R6fp4MP3bwZvuqc0G2Gm84owJOX2j21e0e608KMxjQ87GH4dWBbV6du8dLWBqCqe3+LDr672HUzYe3ndSH8MyygHIq+zHt4tgLPGFUvXm6xiDo8/nxuYzH9DBg1LXqTKrfdXIZf/d4+I9
 bhH9njmf
 dni0vz6yv5KQV/mh9NfjHcc+p3icYFzCDNobpKRo+uMqNifW+gL57m7jC7Z8SvdYhvBopX3jFCtEsyzgXJnECd3T5uZYp9UrceRbMOOKWvMvxmvPb4eo+PZ8GO+6sAGESK9G6RqkAyheANhHoLHdL4ASKKW1tC63IsnvVeebo4cXecREWrMNfLQXebxJJBezBDzdjw2Y0EagMHUpwpOrs4CFRTJlRUpcS3VmZ3Hri+NkK+JKBZUGs0inUYtDpolZolMAmI80V6GnrSNZfbjn27ccmTlHphOgDWZ0z/7vASvQ8bVta/rUOG465dQSyIjdrkEUWf5WDCvqjGobKpj5UlNlyaItj3RpbEU/SVv6dvCW5TPVGywVoEyRvhVrBDut7fGz3eNpIGpzAPwe65r52/1ZuR7WjvGsgdQGhcsX27nWkfne6+YxEX2ADsUZEMAN9VGf4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Override pgprot_[read|write]() accessors using ptval_[get|set]() providing
> required single copy atomic operation for vma->vm_page_prot.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 66bf5bbe484e..2b457db19be0 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
>  	return ptval_get(*pgdp);
>  }
>  
> +#define pgprot_read pgprot_read
> +static inline pgprot_t pgprot_read(pgprot_t *prot)
> +{
> +	return ptval_get(*prot);
> +}

Similarly a const pointer here.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

