Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171B2CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18ED46B0092; Tue, 13 Oct 2026 05:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140DC6B0096; Tue, 13 Oct 2026 05:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0562A6B0098; Tue, 13 Oct 2026 05:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4E506B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:30:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FCAFA03FA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:30:46 +0000 (UTC)
X-FDA: 85317083292.04.40B77C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D05C014000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:30:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mihHl0rN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDCBsEYoZUsLsXk6wyffkPfdwkrEP+ByhgCH/FzXMM0=;
	b=TANHlWNsSR6OebMxjkbxXj6BufozfGDr6zMQrdWdX0c1sQJJKwrer3VrzR8mAJ4ZF5SpqU
	3FT3jnQHzLsM1cFnA/y9nt3NfubiitMRDf2JpOzUaRK9SFs2KFiKW1yB1ucUA/WJtEErEq
	sSB8PczChHK9lNGur8mlerJyL4PPyg0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mihHl0rN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883844;
	b=zC9S7sSFPx49+LokyE0NSiykfWR1bodSnxSbmS/slCmMjqgU8hVTQrgVrMMnp0TQ7TQP3X
	TdbVdEYBLYzryLd+0Nl2ehElWckHHEAV44zKP3gae5tUx5hARvmgLutfIgbssxPpeo3mg3
	YjtiRIQa4mgCPLygFkd8wVRbAn4P+HM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51DCF600D1;
	Tue, 13 Oct 2026 09:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AA61F000FF;
	Tue, 13 Oct 2026 09:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791883844;
	bh=GDCBsEYoZUsLsXk6wyffkPfdwkrEP+ByhgCH/FzXMM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mihHl0rNLCQg4W0s0+z1en8+7AJqOHOYrKKJKz5IhLlWBh/WFVyTbeSQjkYoIVSzt
	 DGPTrHwtRRyDPBfIaEcFHjYmdI9jiru9Fxn6+uf2Fg3fjT5HSDPt1gvNul1q3TwYl4
	 I7Oeat+WqwQguzZL/k3f5B0O2N10bHH4poIAs2B5oxBRQTxPbNdopI0BoH6kenivHs
	 6n0br9igd382Ry5UeEOmzq6VovM50w6O4ULlzX2G2Ubxn/ahH/pFLWqkEBX+PnDLhY
	 nZ11PYfc9VBqj2iBPNUVlwOq1CvyCOPPJ5AomYRjP4Nk7omM6k+IILv674Q4Xl2REy
	 LS/CIKh05DgiA==
Date: Tue, 13 Oct 2026 10:30:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <as36Kesa_k70jOva@gremlin>
References: <20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com>
X-Stat-Signature: c3zfgy9y34qksfogf818kyfkkfe8gk1x
X-Rspam-User: 
X-Rspamd-Queue-Id: D05C014000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791883844-45504
X-HE-Meta: U2FsdGVkX1/FXHg8ipMGU8zubJIA6NH+YZQferysk8tR0hyqcGM3w7RO1K1IqHoPGRBPqcUGyouN+wP2S6GVE01zR0sR9WVv5q0J9HS3x0XUst4eMaxnQsDDFq0usKahdPBCgLTgbMcv2MMeZgDPjbPqUSNzjoxwzXDnN5IUiccGawTtUYv+WRH2V8g/aQsGYpbkv2y6xX8n52cdY00+4dMXQ3bLTKF1ot9+tcRW3b4dP3FTpge+2Wp9vthI9GBohDTJvN77fnzqt6gKr+gi0IvkIuYr62so0f3qRIl2z/oiNt4MqKCq5XRb/UHBsbvkPClzVc5qxT2UGTeaCaSKgpN3eZvX9L91Q1n79dFS4OJ5ucnP056Rrfr1teDISSwpzDpAp1ztzmgSvUgBnVprbfuKLTW0Hb0lRDnNJbk+fAl7JJ2aIcIscfDlL7ddAhyj5oPzDauIUfumQuFOVV11GRDNsJpvA33NBghCXoxB5QDKD45wbYYBLwXO4c9cOr3dNwok1s0dNzkw6PDU8/IYAPNgSm889jCsY421VxzwemQKCZymeWf9pq3FgGlMbOQzDY4CnY1zy4DIVPz3RvoNBLq3nCiyd9MeAei3NsbTL0vnAgddCaupJBRYSRIa0fG/H6hB+naQ0ZgJ8PqLiiM2oFSodM1xUAcIG6L/kXfCuYknF05Aib6SZdbxpEHsfaq0e/LrXOU5jgy2WteO/0r+O4mTy2hOrxK7gaCqxmizUX/1yaHCV8GA25fSGpBAcS0BjcbdN+yKmKSfMfuudonm/JkwkOUQfyH2C7/I+Ld9LxIhCUcXdbYeewIxUeh6H9jqIDLIZdnGFP0p93gavpwOzfOq8LToCcUGBUh+QzXRaMvz2xzE/u7qRn4CXBdvLKCTv8rI3TK7RtubJ+u6nuQOKuxf1homtNLFzuMfzUOd74u3vatQxCJTlGwFCdwNcmOBPhTUn10kdr2mKWIGt7t
 +4mbfZSY
 wX++WlIvB93xqWttAo01CCAlpq1+0iUsHqyHis/SxfpcoxHbe6NlfmsD9rIvO7Kbn3GHjvA1EtbIHds6MlpcwDo4s4XXM8tBHaIujWfTVFcOPg/LDVlQPnwPNHB822oUOcv6Kr3Hpu/oT8sQrpSqdLdNjqZqdCMY4gmfomRONEnvD8AKeTgmSv2tAXILSVquID/Q0bGq+WZPMlqUJw++cKz8qSTyYku5HXYGz9iaUqwx6AcU2xQFF8q438S2e7TC/ZpdqlZyAYKJo1HDlX+2z1NXIQYypXFEcZp8WB1I12UWAkhc/QHZgB2evu+Gg2MI4TrHoHUiKIIL2TdGcFBb3ng6Q6wINUXM2PkXjNhZn688bT02aT8ARkQz8r4PqcLfUMo7wSk+YdGjx5S2S05QVZc/yMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:20:16PM -0400, Zi Yan wrote:
> __discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
> determines whether the folio can be discarded, and restores it if the folio
> is dirty or has extra references. It is done under only the PMD lock and
> the anon_vma read lock inside try_to_unmap_one() and no mmap lock is held.
> The temporarily none PMD causes UAF.
>
> A parallel munmap() or mremap() is supposed to serialize with it on the PMD
> lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
> (called by mremap()) do not take the lock when they see the temporarily
> none PMD and skip the PMD. There is no more page table walk after the none
> PMD is restored:
>
> - munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
>   lock, then free_pmd_range() drops the restored PMD as bad without
>   removing the rmap, so the folio keeps a stale mapcount.
>
> - whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
>   from its anon_vma while the restored PMD still maps the folio.
>
> - plain mremap(): the THP is not moved but unmapped, so the THP's data is
>   lost.
>
> In the first two cases, the folio stays mapped, but no VMA that maps it is
> linked to its anon_vma. When the anon_vma is freed, it is still reachable
> when one rmap walks the folio. Racing lazyfree reclaim against
> MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
> in folio_lock_anon_vma_read() as reported in the Closes link.
>
> One solution is to use an invalidated PMD instead of a cleared one until
> the discard is committed, but it needs arch fixes first.
> 1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
> 2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
>    cleared.
>
> To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
> level instead. try_to_unmap_one() splits the PMD and discards the folio at
> PTE level.
>
> unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
> place, unused, to minimize this fix for backport and the invalidated PMD
> approach is planned as a follow-up series to use them again.
>

Amazing, thanks for that! All LGTM.

> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Reviewed-by: Kyle Zeng <kylebot@openai.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The proposed fix[1] requires additional arch code fixes[2]. Disable it
> first for stable fix. The function will be re-enabled along with arch code
> fixes.
>
> Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.com/ [1]
> Link: https://lore.kernel.org/all/DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com/ [2]
> ---
> Changes in v2:
> 1. added more details on how UAF can happen.
> 2. provides more details on why the invalidated PMD approach is not used.
> 3. explained why unmap_huge_pmd_locked() and
>    __discard_anon_folio_pmd_locked() are left unused.
> - Link to v1: https://patch.msgid.link/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
> ---
>  mm/rmap.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 805db93fe0428..1131b76bbbc28 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>
>  		if (!pvmw.pte) {
> -			if (folio_test_lazyfree(folio)) {
> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
> -					goto walk_done;
> -				/*
> -				 * unmap_huge_pmd_locked has either already marked
> -				 * the folio as swap-backed or decided to retain it
> -				 * due to GUP or speculative references.
> -				 */
> -				goto walk_abort;
> -			}
> -
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
>  				 * We temporarily have to drop the PTL and
>
> ---
> base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
> change-id: 20261009-lazyfree-stable-fix-67712b2049dd
>
> Best regards,
> --
> Yan, Zi
>

--
Cheers, Lorenzo

