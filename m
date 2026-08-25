Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305A0C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1536B6B00B1; Tue, 25 Aug 2026 11:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105606B00B2; Tue, 25 Aug 2026 11:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F389C6B00B3; Tue, 25 Aug 2026 11:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6D586B00B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:51:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 365B01604A3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:49 +0000 (UTC)
X-FDA: 85140232338.21.3435131
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 692E040005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eV/6svoh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787673107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wlX47j7KvOqq3N1z9WGWY+GrAh5lBy8NZIVpXI65Dw=;
	b=uEXVnHAsjAodPedLQ4+yzCihw8VMxX8srQ8iO2RTSicDicRB6AxMTlPLP60RoOkY59dI8P
	ivHsaMQqq4b2BaiRQLlXuGvuHyNlH24Ruzzao6TTieP31aejsSXHmH+HbZ3yCTQkHmcU3x
	w42Be+d5wxWoKmG+qkwFlyV5nRsn1aE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eV/6svoh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787673107;
	b=S/fNN1tIEItonSH3htVHoj0AyJB/Fg6EYaVqBoV3HYUNB/WLfH1qDdZHm7KN1zwSXeFQwF
	LHVB42q4DDssZXO25w4No5vXehE1qRdTIGRGrubsw1aFTQO19VTz037xjaZMfP1cefgCRo
	YeQzTStD45v8P6U9fqd7YrW4VJOR9bk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9285B60133;
	Tue, 25 Aug 2026 15:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9347A1F00A3A;
	Tue, 25 Aug 2026 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673106;
	bh=+wlX47j7KvOqq3N1z9WGWY+GrAh5lBy8NZIVpXI65Dw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eV/6svohXqoRl4XVoK1J7U2ZjwjErN5URCFh3KdhlIXf9gduiYQcr5pYblYJypRGO
	 bj8hXMQJZvBk6kYaJ7A7+HpLuvdg+kB64RtpCjWJUDnYOQle9mHB3cZ5JKZMqfSXtU
	 tNfJCaoU56uOlgi5u+5NibV0OfMBetQDlhQV1tM9opB7z5yqwjUAUAWtUWiqZCuK7V
	 jYAiRFxMnlITtgasNisHbMzza6WYrFwMOPwQq4JrD0estoZ1tcsWN6SgvxQDZaCBvt
	 18UqadOd+ef9yT3fQ8ue3YuuPYdej8RftGV4aiNH1x8/H8evLpARasnkd8R/x0l6FP
	 XG1RI9ZzlbDoQ==
Message-ID: <fd78d494-7f47-4cf8-b66e-c95c2e3ed889@kernel.org>
Date: Tue, 25 Aug 2026 17:51:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-2-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730090647.2401252-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nm7njkk9m8pukbcpmr47ajw7dyu9e9z8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 692E040005
X-Rspam-User: 
X-HE-Tag: 1787673107-660809
X-HE-Meta: U2FsdGVkX1/U/RzQciqA/U9BDDC9vSJkbAZ/NZybfTPvXp44RraYt3+K0iFDBQGsHXB+gEBiT15FHoa8E3rEbJGDwpSAzWhUueKSxfzo8TXitQnVxZRp/qnAGahgcw3UohibXVIi4P/Gd2820xyQCZWfxE65vKRwy10Y/G4wUFhcL8swqsOLGtI5Az/nea4OjuQrGA8FsfmL9fc2+BSh0EZGoKl6QU8pxfAD3KVxy0PF7KRZHuqZvdMwe980V+0lteYXn1iQSB2zQYX91byDgIOgZA4UDDYjeTail2Q9DSj0Joe1IS75B8ZYZEFnfzxNQXODFPmJrjyEyYWVc6F8X+Ayv0C0OENTEXF1IhiVV5BsKXWXbTMfthHzSYkV4zK7Tkti4pHQQxH3hwDHfGtZJ1hEVWmmPyTzX3KsyNzAYufJZC/rb4oTcJeJdfUO3FssQREwBMun8DGJXG5qj1R9NT7X5wxw4NLPbs4NiHz1XRQTomu7baolUvyX0LRPVZypDhp+US37pdAoHBkPHktjDAKetvaE6MdQfsJAKbDAlyz+tRbunWk8vRDQ6bXWzGxlTuB42WRroXNy8v/rdLjpPU4Sp3ZbXB2tjGuRbiQw609dARJrh7AyhIQB5l8hwSNKmrPPYKptXkGDs9cmvHSzgaISbT6QPFCG0YgjkSpdV/g8R2CDMTb2gpaszzkY3SpYxV39QVocTdHiNt30z+EoXiuY2BSHQUZvXMmPXOc49LMn5Z+dMsDZ2sw30ARjsnRdAGbXQHhUPQwOWaHFv6xIql8v49CD3pLxDbm2ZbgkRVYoGW05XaakQQ9Nx1P1eOdEs5B5VZRg7JgEvUqkgITMH48OOFDctxmlITTJumWJi1G2ylNnL6aIno/Ix1lBj2McRSNZSi4D5pQlCfqCVTM8ZjPQgM9j9Rc41JM8ejEx/Ws53/CPvk9NyCkvwd1HVpJocliLBwWL2Uekfr2kuHS
 NLJjJ1I3
 K6+KhrLBTcjp2Zg4zWYNHn38YcVd/rvxDW7rLO8C61729oQT8moEYbgacUh7Y1H99XD8/lm2YdA/bDC2sCsOFyU2F3IL5aXYcpvUpDy1DhI9w+WP9/XdGpd1AXsyX7GFQngLvc+660XsFRy4cFVM8gDM2ZJihKEpvn0pWXP3pBgWs0ikTMONG2lSf7SLPoin6IOmM+BcZ6U7H8pnQHYX4PY8rvhtKh/zWvmrXAHWxlU8cTNSyh4SLjKJU0yQnJ9J3tFANa6XaLjFEbvbBGeGO964YDc7jkXbd4su9X9sWWUZ/X3HQlV7KeODWaQHwFNtXRBp95oaBoe7O9kLy+bCSjH0K1GKpq2qeg4VTFRFDiMvPpTS4MLZsw1zmjc8jR65G9AjL/9qHCDoOS77fnt6KTgtxn9Iukp/ofWVJSZMFfzPQAeqNPtnukfBRw9wrbv5Fj0JTxy9swZ55ooyzt2YrKrSAJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 11:06, Xueyuan Chen wrote:
> The persistent huge zero folio is shared globally and should stay zero
> after initialization. As Jann Horn pointed out[1], kernel bugs have ended
> up writing to pages that were meant to be read-only, including in
> security-sensitive cases. Making the persistent huge zero folio read-only
> in the direct map turns such writes into faults instead of silent zero-page
> corruption.
> 
> Add set_direct_map_ro_noflush() so mm code can make a direct-map range
> read-only. Use an address-based signature to match ongoing direct-map
> helper work[2], where existing page-based helpers may move the same way.
> The helper is direct-map specific and leaves TLB invalidation to its
> caller. Architectures without direct-map permission support keep existing
> behavior through the generic stub.
> 
> The folio is allocated and zeroed through the writable direct map before
> thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
> from hugepage_init(), which is registered as a subsys_initcall and runs
> after SMP initialization. Stale writable kernel TLB entries may therefore
> exist. Flush the direct-map range immediately after the page-table update
> so they cannot bypass the read-only mapping.
> 
> GFP_TRANSHUGE includes __GFP_HIGHMEM. On 32-bit systems, the persistent
> folio may therefore reside in high memory, where folio_address() returns
> NULL. Such a folio has no permanent direct-map mapping to protect, so skip
> the permission change and TLB flush.
> 
> Treat the direct-map permission change as best-effort. Architectures that
> do not implement the helper keep the existing behavior via the generic
> stub.
> 
> Inspired by Jann Horn's read-only zero page work[1] and follow-up
> discussion[3] with Yang Shi.
> 
> Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
> Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
> Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
> Link: https://lore.kernel.org/r/20260727113530.5cd347581a66b3279490a604@linux-foundation.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/set_memory.h | 29 +++++++++++++++++++++++++++++
>  mm/huge_memory.c           | 20 +++++++++++++++++++-
>  2 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..e83ced6a3827 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -40,6 +40,24 @@ static inline int set_direct_map_valid_noflush(struct page *page,
>  	return 0;
>  }
>  
> +/**
> + * set_direct_map_ro_noflush - make a direct-map range read-only
> + * @addr: start address in the direct map
> + * @nr_pages: number of pages starting at @addr
> + *
> + * Make the direct-map range starting at @addr read-only without invalidating
> + * TLBs. Callers must either ensure that no stale writable translations can
> + * be used, or treat the permission change as a best-effort hardening step.
> + *
> + * Return: 0 on success or when direct-map permission changes are unsupported,
> + * or a negative errno on failure.
> + */
> +static inline int set_direct_map_ro_noflush(const void *addr,
> +					    unsigned long nr_pages)

Two tabs here in MM land.

> +{
> +	return 0;
> +}

Nobody checks the return value, so how helpful is it to return it? Do we expect
other users to check for the return code?

I guess we just try to keep consistency with the other functions?

[...]


> @@ -932,6 +934,8 @@ static int __init thp_shrinker_init(void)
>  	shrinker_register(deferred_split_shrinker);
>  
>  	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
> +		unsigned long addr;
> +
>  		/*
>  		 * Bump the reference of the huge_zero_folio and do not
>  		 * initialize the shrinker.
> @@ -940,8 +944,22 @@ static int __init thp_shrinker_init(void)
>  		 * that get_huge_zero_folio() will most likely not fail as
>  		 * thp_shrinker_init() is invoked early on during boot.
>  		 */
> -		if (!get_huge_zero_folio())
> +		if (!get_huge_zero_folio()) {
>  			pr_warn("Allocating persistent huge zero folio failed\n");
> +			return 0;
> +		}
> +
> +		/* Highmem folios have no permanent direct-map mapping to protect. */
> +		if (folio_test_highmem(huge_zero_folio))
> +			return 0;
> +
> +		addr = (unsigned long)folio_address(huge_zero_folio);
> +		/*
> +		 * The folio was zeroed through the writable direct map. Flush
> +		 * after the page-table update to invalidate stale translations.
> +		 */
> +		set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);
> +		flush_tlb_kernel_range(addr, addr + HPAGE_PMD_SIZE);
>  		return 0;
>  	}
>  

The code changed upstream in the meantime. There is now the huge_zero_init() we
can hook into instead.

-- 
Cheers,

David

