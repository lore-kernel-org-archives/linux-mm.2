Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14422C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4746B0465; Thu, 13 Aug 2026 05:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BC46B0467; Thu, 13 Aug 2026 05:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B816B0468; Thu, 13 Aug 2026 05:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E78DC6B0465
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:57:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7882CA0533
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:57:43 +0000 (UTC)
X-FDA: 85095794406.12.2DF84D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B274C1C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:57:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4qMIT3A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOm/HVQGc0+vyDqcjuSjHJXpyPlAxFtMu2bcfagRXwc=;
	b=4/v+94ZfYWIOwCiJpfflEpgFrJqfT9y205jIZAVPkdu4AgYduRX3tA275uO1TnE6uBD0Dr
	2yV9UBX4Qhs5+QeDeXPn5P6eTwB03MRphl7PjqTxRg0cyc+/mTDyKFY1P6kw2Eyycdc/Ha
	7HcxSCmn6ERY9tku5n7veTekXiQ0hyQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4qMIT3A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615061;
	b=RUtj9PW/qWv5knjk8gz878F0wgUvU1MParJ4OhZDHBG5R1FtxDngl6v5NGTJKeCQW0yNlb
	rGHvhlE8pBxNf32FKzgKN4KNFlZj2oIFlmIcHkneBzKM2izMGE5VgVIIs1UAQJv4sH49Zg
	JF7zjmt5C27/G2wu2sB53jAhDH1Nya8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D528E406A5;
	Thu, 13 Aug 2026 09:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D721F000E9;
	Thu, 13 Aug 2026 09:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786615060;
	bh=uOm/HVQGc0+vyDqcjuSjHJXpyPlAxFtMu2bcfagRXwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U4qMIT3A6rZHjtcyXEEybCh8POXH7dLazzJarsH0hV4h1vlj2vQbELL0fPk55R9lV
	 Rd2v4LECeKnv2Pezfcuo+PLr3J7u8vKEANQ7s/aIfChapu9P38haIjF9oufWLB+ZRS
	 fzgtjGpDR7GQb+8YSs5Wg9s9awF/mdtmMKmVlHMfWbbv3ggR+9wFnQWcVFF1xuVO6n
	 GNNcEL0LNlpFVJCVWF1Oa6AhIjCXqE42XIkMK1FUkpNivMLI7ZjjpOOQx3QcMLNXQH
	 m6tHrgGTmCXch4SBhK1oTlHhT1XsWPZZcdZobnB0i6U37pgaG1TBvz22DRMGI89YYN
	 09eDLQs37hleQ==
Message-ID: <f2dbbe27-ba09-4213-ab74-92db526dde7f@kernel.org>
Date: Thu, 13 Aug 2026 11:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: Karim Manaouil <kmanaouil.dev@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Kinsey Ho <kinseyho@google.com>,
 Wei Xu <weixugc@google.com>, Bharata B Rao <bharata@amd.com>,
 David Rientjes <rientjes@google.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
 <20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B274C1C0003
X-Stat-Signature: 4ytohco9r6antt3bdb3janodez9iihmj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786615061-617380
X-HE-Meta: U2FsdGVkX1/3YMC+o/I9+lpLxInXUs0azDsBeYBvGlOZZeLFvztt36bQlGRg3+2jW8Td8+EcbNjpHRUlKJwyxaNl462JXjgmUtLDbvd7SFr8AdEwvfiIPQna+f6AWZjW8u/QedIkfeUsJg7DxACp6j7J84jfVvNhzUref7908t04vlIE+bT/yQ+srkZ1VvwnVssCibE+RXlx+XqvJIw9aIX33jgSy01hHPZ4pFukwJiSEbi428nX7k/0G6xutrrKA+TO2vQebmqMt7zvp25GjAgSdRF2G1lIAzSNv/3tJNXPEvQw5pJ2p4/lrQMBIZ4yXDiUk4iWl5sJ9OYTR3WhyNMutLpp3T8Fw5+TzdqoZrfisVDFk1/nZN8TWKlYM1mjBaWobM0o4B2av7PsnVolgC1kAS91oK3Ck+s6kd/fhqewuApI+AMss8KrV8bDblvgk9siaGrxfsKoODcwrB2fC2qLtDqwQhPRLrEHD6JppvTNN7A/2Uk0a+y/lPj+UG9qCxeu/eEGhFbBe3vLOZ+mcDE7G4Etigu/NCi+J2vLm2OXyMMqzyOQjgu4XcNJ+T7xFcpGATa6fUrolfvA8ygBr10FEThBd3qAqCnaq2Fwil9Cjvm4azbDT6YWqYc4xFec7IahD/zhus/pVbp96TBshHIksyyHX6kXNiHyOAY7z39sWk3STYtFgpguoHiGS2Wo6JlvjpWrfy0oaXQo/it3sQWzJksTk8HOxAiV3yb7lAmZsNMK24RKafPvdGOHMkaLwpFdP7vCJvR6YX1+6OkHGCIjeILOKIwFaU0UKrRg5CuPxT79O1wUNPBllMXLb/wLT2lluMiHiIZDzaAuo0iDckANWQHGE/6w1KOyramZ1bXWSC84pX0GEQiWIA3XhaPENFYYJpbyd3qaORffYf2DrZzYK8vLEhhgz33W24PsdAPcHVjGKoz9VW7R2sIuJXlLz0l4CHEyAcf7Lez34EQ
 DikfcF2F
 hv/CLQiserBTfOAOsIxBtUJTKrM6CH6R8Jtgm/MHnC+ONyL0yNnXaA0g6BPslPzAB5El0faui8i2YzsFukMJ4myq+d+wg8E7AehXZLV0cxXXOrNhcACRx6kv+bTLld/rtZFxSNGHg7N8f0fPr3spp+C+Uss+2B9xAkwHbMZqkpNDAhHmNpjG3cU695+ipYuJvmkuCkm+a1uM+vgLZsKAkHY2OCR2rGJiUbw+FXv/H05tDiBhozWGf5wUBa6l0SK7qMqYL+3qMF/cLmIaP6wFq6xJ7KNDSnLqFjxlFzCb0GqVwqKZlWE9gACsZ5fnuRea53HtxkZ92jYsCMfXkQUFaTsQ2A2U1Z52VVdJauCq0F7IS0zhgoIMyZ6VbXQD1jaGxxdE1l79c618pXgQmUoEqJpKsHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 06:23, Shivank Garg wrote:
> Factor out the generic PTE batch detection logic from swap_pte_batch()
> into softleaf_pte_batch() helper, so that it can be reused by upcoming
> patch that adds restore-side batching of migration entries.
> 
> swap_pte_batch() now keeps only its swap-specific concerns and
> delegates the batch detection to softleaf_pte_batch().
> 
> No functional changes intended.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/internal.h | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index a5d0488a54dc..1e1ab53b642e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -560,6 +560,26 @@ static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
>  	}
>  }
>  
> +static inline int softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
> +{
> +	pte_t expected_pte = pte_next_softleaf_offset(pte);
> +	const pte_t *end_ptep = start_ptep + max_nr;
> +	pte_t *ptep = start_ptep + 1;
> +

Wouldn't we want some way to make sure that the softleaf entries actually carry
offsets or pfns of sorts?

> +	VM_WARN_ON(max_nr < 1);
> +
> +	while (ptep < end_ptep) {
> +		pte = ptep_get(ptep);
> +
> +		if (!pte_same(pte, expected_pte))
> +			break;
> +		expected_pte = pte_next_softleaf_offset(expected_pte);
> +		ptep++;
> +	}
> +
> +	return ptep - start_ptep;
> +}
> +
>  /**
>   * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
>   * @start_ptep: Page table pointer for the first entry.
> @@ -577,23 +597,9 @@ static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
>   */
>  static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>  {
> -	pte_t expected_pte = pte_next_softleaf_offset(pte);
> -	const pte_t *end_ptep = start_ptep + max_nr;
> -	pte_t *ptep = start_ptep + 1;
> -
> -	VM_WARN_ON(max_nr < 1);
>  	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));

Any reason we cannot simply rename this thing and drop the VM_WARN_ON? I mean, a
caller can just do that.

-- 
Cheers,

David

