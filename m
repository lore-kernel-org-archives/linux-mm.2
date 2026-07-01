Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC56C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0A66B00AF; Wed,  1 Jul 2026 12:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978AF6B00B0; Wed,  1 Jul 2026 12:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F976B00B2; Wed,  1 Jul 2026 12:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F45C6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:49:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CED131C7374
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:49:47 +0000 (UTC)
X-FDA: 84940794414.01.8603B13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12821180006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:49:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZkTNtmp;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782924586;
	b=hM1uGoSpC6bZlcV9U0RIOmg6AtimACcbVdhYmrhUBn8q/2vLRp6uCWItgclxj0T6v2UJN+
	uOwEyEnXzgQgOduSgE+m0f7b3qVHckUUIKF7shTaLINT5M6geYuKT7Qxa0PQT05KyfvRry
	mUgFiJAFu43kqnZzuOHP4+QMrhrePFQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782924586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewTcjC2YNzXZmdVVFzcmi3ViWYP+V41foEbY5CbQbA4=;
	b=BiKLgV/mhz+DkL/Q7GIT/WaeLDuCnawAYL38lSAyCQ1Z0fJJ2o2IB0Tk0rHuLlM5mysKrI
	rNIxKMMp4nSrrjhy7xa8iJF2WMP5rAdh2j8MIjuKks8FAYrINPEWibG96ntE07n8VvyR0n
	VaclX7fFIVhOgOiB6Tn3OlUW50SeOds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZkTNtmp;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 894EA60138;
	Wed,  1 Jul 2026 16:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F81F00A3A;
	Wed,  1 Jul 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782924585;
	bh=ewTcjC2YNzXZmdVVFzcmi3ViWYP+V41foEbY5CbQbA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UZkTNtmpKRaME4zjJl/r6A13mMXd1FfSdDxLmZ1795hN67MKNO4BVBvojv24PZjzM
	 1P6qSXhQZh3H/kawABE1PLrZDTKIO7roA/+MS9ddZz0k/DRiI+DWtjXk2dlvetM2Im
	 hgV24I3m34Wg9VDKK65SlSJyXN9tM31ZRQf6mSjd8i0cZ85ihdamfUBW3ozh6mfBNY
	 cy3nU46+8JQ/NWZCaSFohbKXtR4DEtlGxgH2NrctfLiWyK/kgAot0nwJEuUYlnQGVK
	 eKIYogZ4WXRmBTvGZQ+4EZf9WJF8EsGX6/BCvMW+AqWPZyCCInwQ1H9ePeAzHdojKi
	 5riMsS/WKqOzw==
Message-ID: <65671a65-a2de-4f12-994a-a96d2acbc92e@kernel.org>
Date: Wed, 1 Jul 2026 18:49:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: pin large folios before splitting
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, kernel-team@meta.com,
 sashiko-bot <sashiko-bot@kernel.org>
References: <20260701140638.840773-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701140638.840773-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ykrkfaiqjpbjoehj6isit1g7xb6xpt5p
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12821180006
X-HE-Tag: 1782924585-475420
X-HE-Meta: U2FsdGVkX1+bz4RWBKlMs16UmUfnhh+GejrlOzQ599XrB2sqxCQV4wlvQgX6AH/eOTX9fllpKVPiBlyXZzapMV2we67lxrJ5GLYwrE3yNHE0pd5iCoXJ+TVTsd79AnFPhoPDRYvB0oREOYXVBAc7+HjpqHSVAlvhkp+JjX99C88oUIIA1G+ne8kk7vVDpWClR7isjG9bys5DGxqNEMB0ZGwKBZL/IKTmshMxx05OHwVxXkT40yZwv437yM5d5AjSURy53Cw48VuIRL0Xv0t/5qaeAsbHa2mX799ZypJtldwKqAahYxMcUI96zskmYvg5/al235do62F98GZd7HJS+v9D13VWJEm14Um0bMXbLHcZewWSDoJfOjjyfnJkYn7f0+IkR9LdLSbHCHbWV+Wy8V6lt3zKMeEbY8mbRtG7xJG4dXX/cfFevM/mcXKCALDQMfS8kEuqua6YBK8wSgG+PMCISlzDXSc3Dzk6wsv1YimpCtBLW4GGUE/WBriG3VGF5Rif9CrITly62MM0nAtQmJc9MM2mXXQVehRNPpJNd3SEp7dScNkxeDcWDxH3obXNdWXwwn/la/N5bZuMjINOTJXSsVChpgyvLY9YKLxr99UCVN3G8wx74XIQaDy2k4AaZueSqxslZq8R+4Jjmlw2tUvWw3CoOw7QfVQ+AFz/VlXKR4KPKN5Eie1kV8ExLwYk4+VJXPGCpmQhhiOLAH2HAz9f4YXcmUk922pzsa5JAoM/pL1krP4YkJKXRKD0ehoXrkEJGaAAk5hGE3KlGJtklyc5EByLiF/SebJxL60SQ7pIgeGOlwik6Qw+d1isHP3GjiU/5z+k5YU02awuS38nC5tO01cKYvvjsP6cT9ntqByG1ULe3pU8oZ3jxqHWJIX5uW6ykmaapPgU6HQjmerWgnl9+jGdJx+QM/J4BSewciKKjY6h9AFnKtkWxksIZcyQultyuIa8bvjbYjz80r/
 T7eaHA2a
 vgxCYDuBPrJSZVQ1j/VUBKDW37aq62GQMO77D23lv6hdvAUxMcXOO+ojxqu+Nib6T9jl0YUrhMPPegClrRO7BbLb3UWhQEkYJcPJ5WQ+hFcps+znWfsrEF31rY6zd7eQOJP6Y8xSSgerRSVBj+tPPbESIIhUHAokyE60H40mtz2d1WOtN9WxdLzlKR6NPcmyzihBIAEcwhRJCEXb703XcfdGDjYKrdlHJXrTCsJp5GcVzdWh1GQkZ6e0tIKK8pmScVtunrq1dIvBSW9Asl4IxYR1rp0ZEm0bdFzywoKWJuQ5ytv8RTYm6/N33w5QhDsEtXdrryCH2HQhlqJXJhqLh0QAZLjM1m9hXQttqw5xfgS/RY/1gPjDtEo23QyzFi1Jl7TP6FSI5fW5Ef38rR5UmjaCYsdvsAzkwEtgIi/Sibqxl2YZOtMZb2EHNMPDGtAkhrOLhzgY+S5K62N/JaR+bDi/W5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 16:06, Usama Arif wrote:
> migrate_vma_collect_pmd() can detect a large folio while holding the PTE
> lock, then drop the PTE lock before calling migrate_vma_split_folio(). The
> split helper took its own reference, but only after the lock had already
> been dropped.
> 
> One way to hit this is device migration over a range that contains a large
> folio. The walker reads the PTE while holding the PTE lock and derives the
> folio either from a present PTE via vm_normal_page(), or from a non-present
> PTE that encodes a device-private softleaf entry. It then has to drop the
> PTE lock because split_folio() can block. Before migrate_vma_split_folio()
> gets a folio reference, concurrent reclaim, migration, or truncation can
> replace or clear the entry and drop the last reference to the folio. The
> split helper would then take a reference and lock on a stale folio pointer.
> 
> Take a temporary reference before dropping the PTE lock and pass that
> reference into migrate_vma_split_folio(). The helper consumes the
> reference, so split_folio() still sees only the expected caller pin instead
> of an extra pin that could make the split fail.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif%40linux.dev
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 2f8b646302c2..f5a5f699e98e 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -77,6 +77,9 @@ static int migrate_vma_collect_hole(unsigned long start,
>   * @folio: the folio to split
>   * @fault_page: struct page associated with the fault if any
>   *
> + * If @folio is not the folio containing @fault_page, the caller must hold a
> + * reference on @folio. The helper consumes that reference.
> + *
>   * Returns 0 on success
>   */
>  static int migrate_vma_split_folio(struct folio *folio,
> @@ -86,10 +89,8 @@ static int migrate_vma_split_folio(struct folio *folio,
>  	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
>  	struct folio *new_fault_folio = NULL;
>  
> -	if (folio != fault_folio) {
> -		folio_get(folio);
> +	if (folio != fault_folio)
>  		folio_lock(folio);
> -	}
>  
>  	ret = split_folio(folio);
>  	if (ret) {
> @@ -310,6 +311,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			if (folio_test_large(folio)) {
>  				int ret;
>  
> +				/*
> +				 * Keep the folio stable after dropping the PTE
> +				 * lock. migrate_vma_split_folio() consumes this
> +				 * reference.
> +				 */

Do we really need that comment (same below?). It's a common mechanism when
keeping to refer to folios after dropping the PTL.

> +				if (folio != fault_folio)
> +					folio_get(folio);
>  				lazy_mmu_mode_disable();
>  				pte_unmap_unlock(ptep, ptl);
>  				ret = migrate_vma_split_folio(folio,
> @@ -353,6 +361,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			if (folio && folio_test_large(folio)) {
>  				int ret;
>  
> +				/*
> +				 * Keep the folio stable after dropping the
> +				 * PTE lock. migrate_vma_split_folio() consumes
> +				 * this reference.
> +				 */
> +				if (folio != fault_folio)
> +					folio_get(folio);
>  				lazy_mmu_mode_disable();
>  				pte_unmap_unlock(ptep, ptl);
>  				ret = migrate_vma_split_folio(folio,

LGTM. The code duplication in this function is concerning.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

