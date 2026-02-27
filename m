Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9348C1039894
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B116B00EC; Fri, 27 Feb 2026 15:55:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38736B00EE; Fri, 27 Feb 2026 15:55:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A956B00EF; Fri, 27 Feb 2026 15:55:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2D26B00EC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:55:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60763140949
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:26 +0000 (UTC)
X-FDA: 84491442252.03.6FB4673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A95191C0010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pOXn5XWE;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jhI9FUCWYVO2k0iNdiwAaoEYetc6c4Oh6fXJ9S4Opw=;
	b=i3L6GO7LlbBjNR1winwZ/RHmeS6G6rwo4KwvVtBUe0l28flaIl7ynuzs3jJCOkKKI9qMQ3
	nH2dPSYjq6yBD2ZSBDPhpBEgGkXh6uIA1qDlukhjjXB7mO8d1nuKxUvzYW+7fetLsKcS+b
	s94B3L3JvgAyGV3TfK6/pVpRp/KjTDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225724; a=rsa-sha256;
	cv=none;
	b=HBmk8XROgZ8A8bB9IZAfFZOckA0aScCbp3ifJLpinVUPIr0oipuCvvNZ+x8/dTYMLK+gdE
	PImXf/5ggSqCvRcYQsu/rxmupfJRNWxEPc5nVLVh3xd2m6/xkA4xbdTFzFLn9HzWXBYmW+
	ApOGKdvGvqw+jawOIIZrQwGr33vgg8A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pOXn5XWE;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1343C60054;
	Fri, 27 Feb 2026 20:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E545C116C6;
	Fri, 27 Feb 2026 20:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225723;
	bh=AWTR2K3dBXApAFBSFFqFKURejpZca+nk5sb7sA2btn4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pOXn5XWEcNoi0kYL+zqUzWF1ShgtL9v4L49YHqamUKLPOS5dtEVajb96mplr9Sbm8
	 yJQKqwE2l+kmf1oUWqMj+mx0dFXHPbo2TurFgO+o2e62qIxcy5fG22NHBZkoGmhlox
	 mScGjjtimSHCSHDcu7uMjRAdKE8vLsrFohYmIiPIiOfpARyT0IEScy1f0yHnw1nyjr
	 qdVXVx+W4+2ZLNi+XQ8EqTFfrbmFupYKgBoj+ECnPCLQxfutqCfCxVj21dKURnzdBN
	 h3bPcjGOyw0YyoHXP+hq3VPfe8RGbpyBYS9ZoMZNJ/jt0WnAkP+ip0G9UgRonJDzK2
	 akxm3aT6u+I7A==
Message-ID: <e16f31ea-3713-4149-b60d-655b52845644@kernel.org>
Date: Fri, 27 Feb 2026 21:55:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug_vm_pgtable: Replace WRITE_ONCE() with
 pxd_clear()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260227061204.2215395-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227061204.2215395-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A95191C0010
X-Stat-Signature: bqe6dqd6ctmznwzmih3zb5339mssyr4a
X-Rspam-User: 
X-HE-Tag: 1772225724-725788
X-HE-Meta: U2FsdGVkX1+GI4r/gk2XcozAZUwujQbC1lmLBNfGmXOAaVoSniXsJIhlwEd5EPR626+CD1EoiBIiWjektScrXvSAaxXZPaUE12Jvphaea6nbAUQx+LjmTbS/aGa9uIKU35i2ZDPanAfzwvyosDm4/pYvh0pteqNjYW6zrlcuWIyo1PefzQk3h85xKei5KuDz3DXLht8wOlCKIM119TtNSAchPuRY9rvrVz51jAT5q/8CabDet4Spj069JyJyzIvsqR8D68+lSBLUkqQca/CF46IfoV8ZHT8Y6TzIC5lHBbTnrcvG7UccrMOE7okgeOgXHyKkHpiDxpFFnmNaRWcm+iwMTmnKQcnxTiNlurJbVOAbP005JCzz/gb4kdzMFan3mTeiAjejCPEMUXbIXmQkttmNcNnMFGh8SFpkJp1GYd28WGCbmb7opYsb8f/s/lZvfTqRW3yFn/aTVrb8OrUES++r8utaEPGU+q5WoFytKBt2rswi4FUyhVJgQa6Inca7MsM/LroVQ6qzk/CsmggwCwsn4FPyCoUqCEj0FBt7g5w/NvRrpQjGb52K/dzoOSvSSGja3+xu5Qo2IBjCa+Wu626a8uGTXGvoVFHTeC8B2dehdbgz3uWDajV3ZHKW98xjTdDYpaTRNJDLOWuLPdtK3ecD+AGQRChG20WI62f7nQkxZKZpEbGsdIXsIJ7pC32pyZcJhJ0275Xc4J2eZsTvQ0VPLqQkosY32z9nA6J9ep2QX6NGg6PXYEp1Lt4DjuHHm/UGVnQ7V0+7sl6E0+4dN/B9Dp9UEb+lSOPgfGEIKGvoq96f0XHwgNcP6vOsx+dPpYd9Exyfc0u0NIyLpQeqY2u9T3DnANnmNOQoBiezydETfZa41dUMGUGlnqYbuo2plYKfLQT/ivqIi2+RL16ZXwh8Uny59Jz9gCbIQDudIii+PGibX1fIx++Q6KSzptQmj5PSWLAD7ioBgWlYrrM
 jEKmHdgf
 evCa4v2bYa2ih3BwzBqgA7UAYmvQay6MtowWRhU+mK3pr5El6k7pCA3tiD+LjDWdJrBIldxWvAckCP/VJk9j8EGAzlW8EXr/qxIGcla9q5U4dVRAtlDVfJRd3NHo9OeAkA1wqmX6YIWQJ7QxPd7xr53B7RebN6wKWui+p/9N6htP/aygm/65sXIPrkoLxh4/rQa5FgAdrcjbnOBPhDYpU/B3Lz6E2Q3hnrHGYeyrYXeGM8hfXX/j2tQVS95EHuYVFeSdtf3kPFlXV1/m0RKH7EbDfc4NSkCb+XAcFsZX1587YFwHSAW46sF6GV28ZsZpAttzXdiXsqQhckWVE3UTi59UYN4AUm98l7GD/69F+W6StxiwV+2yZ8M4lEybLxwoqe7DNzgtChWEie/nU10oDc7VYxCuTUCPfKDXpdvSKh+Dh6b0G87DMmfWz0DaD2JINffmJ0rJlXXtSvc164zzRxYn0vGcNDxOLxEgQ5hB56gI7rV7gioNJuI2Mqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 07:12, Anshuman Khandual wrote:
> Replace WRITE_ONCE() with generic pxd_clear() to clear out the page table
> entries as required. Besides this does not cause any functional change as
> well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Applies on mm-unstable and tested only on arm64 platform.
> 
>  mm/debug_vm_pgtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 83cf07269f13..23dc3ee09561 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pmd_set_huge() verifies that the given
>  	 * PMD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pmdp, __pmd(0));
> +	pmd_clear(args->pmdp);
>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>  	pmd = pmdp_get(args->pmdp);
> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pud_set_huge() verifies that the given
>  	 * PUD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pudp, __pud(0));
> +	pud_clear(args->pudp);
>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>  	WARN_ON(!pud_clear_huge(args->pudp));
>  	pud = pudp_get(args->pudp);

On some architectures, pmd_clear() does not set the pmd to zero.

See s390x as an example:

	set_pmd(pmdp, __pmd(_SEGMENT_ENTRY_EMPTY));

Which results on 0x20 being set.

Maybe we're lucky and all relevant architectures do not have
CONFIG_HAVE_ARCH_HUGE_VMAP.

Or maybe it just doesn't matter.

We'll find out :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

