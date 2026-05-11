Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7AC8CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A6B6B0088; Mon, 11 May 2026 03:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D656B008C; Mon, 11 May 2026 03:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CDB6B0092; Mon, 11 May 2026 03:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D13456B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:41:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819001C04AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:41:15 +0000 (UTC)
X-FDA: 84754343310.28.42A2D89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B39F28000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:41:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5iDMqJC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778485273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/IlovaGGIqOnk0RyMvg+UhpluUT5TQU69Ci8/oGPHI=;
	b=st8RChap++EU02vAcO+AuhMuWZgTgfvlKcjOAt4dgPGvDJ6q2HCmlIg0l8/z3NyC8gARWX
	gvbuTHZI5L4JJe875/j0U6k2PpGcVxLuVrw6k1iH6Xn5sMFcy/3iPsxY9BW8gPDeqMHunu
	+b4R41YV+SoerhNs3rUyHTJnjI7PVh0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5iDMqJC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778485273; a=rsa-sha256;
	cv=none;
	b=IGDwsRRCPesvpJw5RsvYh/TCSMXbYry7mtffc27ngRWJrrsCnTYGX61az/jLqVJc3MmDXm
	ENj90HtmkfsQsxOr8s0JVRBVvXqzeLT1jB4gaRntVa0WzlTrJ6NljBnWaisUs0bMG9QL7f
	he2IKrXOC25uc0Qjiy60n/mS6yQTqQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1DFF41570;
	Mon, 11 May 2026 07:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B45C2BCB0;
	Mon, 11 May 2026 07:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778485272;
	bh=U3UWLJCbG5+TuhXiZDe4L1Pq4fZFdjK/HrwVHEa7ONE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b5iDMqJCBC1aU7JpWvScNn24L8blw4eqpRra2otsN93uWoz3OMEDrrCZ5GJ6LBTiU
	 MXzOzb/PTKR+IOEma0tAqB2pCRgOY2l35r1PThRcu1HiWKgtVDbgF2tytBMp7uv53h
	 8DD1bT7I0ywHgRogmT+wJho1Dbak1+glBsKRkiE5/iL/+4yyfPRt2gUMXmNVjWcJTS
	 6o5+blWnHlaC7Zn2+xy3ZpnitfmIykuGxyWqsVcZo+PdfV1KdUfm7bFlQ6dF38A2O/
	 U6ifEOQqSObypThyn8dl7/RVTRXRv5z1tVO+7QcQJzNIGJm2Tyv7wU8Nbd0vld+jMx
	 sxofWNdQFmXyQ==
Message-ID: <f85863e3-6551-4f01-83a2-d63121ed2e60@kernel.org>
Date: Mon, 11 May 2026 09:41:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/rmap: batch unmap folios belonging to uffd-wp
 VMAs
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-6-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4nx3yhuqh7ecfx96meiy4jr94oj7hksm
X-Rspamd-Queue-Id: B39F28000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778485273-109893
X-HE-Meta: U2FsdGVkX1+KXV4lxyuw1U2I8FcSgjsy9JpoS0A7C68WqsAfyAjzFitLhEE1k81Wy7MaKyCW+8vgdQXc0a1SZ3xNgaj9PsOBP1Tne4TvbrI2CtpqucVd3/gk+mQ/KhiEtV754Z8c9XPs766Rv7uNQvkj3mRjSaw+UXS7szELq9NUAbJLx4qc53Ncshjj4YgEt/5BAdeEG9BKb5YB9ajW5xTmoS+UcuFhfatkOutOXp5he1egrqPX+ZYpuM6xdR6MpUqe+W17T30BFQ5NUW7unc/bCYqqUZEVN/oPfidLxoc+r15inXXj0L2/LWX997sXWzJb7eSxr+2LhCJeiGtpLg6opH9yWHVlb+YcaunCACWZXHMhSBrJMPf+gX1L9s8SzrOOxSSjdGoH79vMpJ1xHOeRaex3oPC+T2hZBuBphepsM33xgFr1PWAYLcRSEBWVtvFYGIgxDpOOnzLy8bP4V2nvGgassYzACuMtGSiQYyd5fA1WlEFRmmkgtmYFjwCdalMqwm+N4xTVVxQqTuDlngj9WgYMk46nW3cypBPibXglgOG2Tuz8kBAuRqw+swPSALCUEQx3zcQHazU0ZYWeSyp6QaBiN4ZpG/RkmbkbGdaTxaOVja5uflPY021q4QIj9/VYrTgWCm82LFnZ7vJe4EhDnl/bLqGjRnfWLJ69T2wc3PwP89nKpSSgetWlt52vgLTUcNjNUjRIFVcpbtXToNoy0qY+2ld2KUEGSyLSF9UzDPBLKi15z5YXFNguW+PJRWKAcbFOeM1x2s09xeUJYINGUlIrh4B7UXfWU+PdsVXCEYD4iAkkblBeTYXrsFHVIpRhMK6U/fQBTjlVYtoRQG8TSBSyhVycImCmsO8G18+Og3lEbyc5YQ7lQRrzu0dFRUS3lPkBnR+kyjRIQ2lLO/MyzJ9U29HvHgPMjsfhNndATrxZu3sspFUMxIVlVhlhznZsTCXIyqm/EruW8jk
 b76LRwFM
 oB2HSoLCek+pcH7neSWSGg7Imotarwn0Y3dge1m2l3Q3zE2Ps99gVrJ48Xd/9HiEB3oA9IzFFxFkbOJRc2mk4vEUofUcuCDCKtHbLcmclh73oqzkBe5cjzocCEH5MHd5Z118toymHmq726Me6X3jnAVKTEOx27ilP6OBylDdaki1zl8tiWgiKtrGFR/hLJniAQDmWs8DRCE4DaNUGg7P9l59/9ytuKujQbjeEb/+prMVGH+NnNwy/dxvk4zi8cUYcUEa6iG4gJbVPTCH+vHppjxaTP4R1vPZwPm9O2N4YHkPNOMi3V+PItDsfPZIsF47eMTfeJBHLJKYQX4MW7/Xg4DC5WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:45, Dev Jain wrote:
> Commit a67fe41e214f ("mm: rmap: support batched unmapping for file large folios")
> extended batched unmapping for file folios. That also required making
> install_uffd_wp_ptes_if_needed() support batching, but that was left
> out for the time being, and correctness was maintained by stopping
> batching in case the VMA the folio belongs to is marked uffd-wp.
> 
> Now that we have a batched version called install_uffd_wp_ptes_if_needed,
> simply call that. folio_unmap_pte_batch() ensures that the original state
> of the ptes is either all uffd or all non-uffd, so we maintain
> correctness.
> 
> If uffd-wp bit is there, we have the following transitions of ptes
> after unmapping:
> 
> 1) anon folio: present -> uffd-wp swap
> 2) file folio: present -> uffd-wp marker
> 
> We must ensure that these ptes are not reprocessed by the while loop -
> if the batch length is less than the number of pages in the folio, then
> we must skip over this batch.
> 
> The page_vma_mapped_walk API ensures this - check_pte() will return true
> only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
> There is no pfn underlying either a uffd-wp swap pte or a uffd-wp marker
> pte, so check_pte returns false and we keep skipping until we hit a
> present entry, which is where we want to batch from next.

Right. Or a non-present ZONE_DEVICE entry. Your patch shouldn't change anything
about that.

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b17dce752a1ea..25813e3605991 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1965,9 +1965,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	if (pte_unused(pte))
>  		return 1;
>  
> -	if (userfaultfd_wp(vma))
> -		return 1;
> -
>  	/*
>  	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>  	 * upgrading write permissions for ptes that were not originally
> @@ -2266,7 +2263,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * we may want to replace a none pte with a marker pte if
>  		 * it's file-backed, so we don't lose the tracking info.
>  		 */
> -		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
>  
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);

Yes, that should do the trick. folio_pte_batch_flags() will still respect the
uffd-wp bit.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

