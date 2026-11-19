Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D11606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I962Fy36
Received: by kanga.kvack.org (Postfix)
	id F2E776B065F; Thu, 19 Nov 2026 09:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F066E6B0672; Thu, 19 Nov 2026 09:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42DC6B0673; Thu, 19 Nov 2026 09:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C48EB6B065F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:06:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 682FC1C45C0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:06:14 +0000 (UTC)
X-FDA: 85452043068.06.686FD70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BC9024000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:06:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I962Fy36;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795097172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjCeHxZksMiuQk8qi3/5sRJwJN7rQU7or9TBiPA7fVg=;
	b=kb8aWPRY5PAWIH3CrfQNKLrVWydrbHRoOWUe/QYhqmdpxmhHJg60RQU1C/HuWq2wtWHhHa
	sdyT7As0/2xr1qCdRXafkjK5pT4POV7kBslT0zUW5n4q4ghiB11cP2meahMpSkdqNTWhlw
	soQQ7JAz+lVSDPV698J51W3oix9rtIk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I962Fy36;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795097172;
	b=QKoHpqsJ0CLLJluWMmEULCz0ApXjuLuWcjYI9XdGsm/Kzwqb5eP+wMHX/XIIOZEVP1jpd4
	TnfRKpcPnuYwXG0UeGevXET+XXZHnob8gmxrOX3x8geehAcc85suFZ+7L+yFQDs9H7olq9
	j3xG50og/9ifRhS1jKTqq8i+EpY0MKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA88940F2A;
	Thu, 19 Nov 2026 14:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6611B1F000C4;
	Thu, 19 Nov 2026 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795097171;
	bh=UjCeHxZksMiuQk8qi3/5sRJwJN7rQU7or9TBiPA7fVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I962Fy3629DgiSuo3zu7CICQuwivgtJs+aj4wSGBpeu6krM6gscogwdrDpAk8amkO
	 FXiKVdlaClj0oNGYJMpAfcBwol0KYMWPNk9hPBAyiY8ZHegngv+D8gn48FUbtD606O
	 Abk2xxKkgd5u3c7+MZfD4g79qgKGlqg/6tuF3ZRKAq7Yg0ehBZl6IDZoWpECGEsrnE
	 K8/uohreO1Qj2HRWo45FghMUcRa/2aJCGTzDtluksttAWxJjzc6tMb0ioW0Ahh8y9p
	 A0ODGBE8dtuHhS5igCemKtOu1v2DuhjsjTy+RXX44YRgr/oFrZ3IWgTd7sSlqjntyb
	 xN2RkrgwpnlbQ==
Date: Thu, 19 Nov 2026 15:06:06 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
Message-ID: <av8CTrxr_NdRgpKL@localhost.localdomain>
References: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
X-Stat-Signature: urmw7k1tq9t3zfgbrubzrnshoom3myba
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC9024000C
X-HE-Tag: 1795097172-236875
X-HE-Meta: U2FsdGVkX19gv/Jb7psZO10abC1yaozMdlAIDX8ZfboDTDl0G5ZdUgcgvAE9oeEbix51j/icUy41ks4ODbck34HgKGsPkaWA9ZJob53WgHBxWVcxztFVWaHnIkTBamB+7LxrTdpT9rB9JJw5cZyl+hOd3Q73JVVwUsfqzV3u1nayklaLux7YtRJW6wBK6KP4MCp6gDOP2VnWr/qyoEaK1QaZv5loRI2uSl2Es6bGFlCpFpcDEuhtJ+w17QNl42O0C6PIt/uDw6OdmZ/nv+VxCxwG+kBw95DMDpqhh4tLwrTBgM07hxNqrnQ3AsWsmo3YlHxdLKaTq5nI/7zYwAre7s6lGpoQdXcOMtoSlavNNhMmrtGAa31Na8o1SG+F7vJI/G3byBOVgNj/s1TSzByOR4vqaX820tlLzUJvl+U2zvlIGxzalNG5tSPq4g+N7Xj/q6bbPYatwiE2gXRwx1JXKFjeHuU5bb5CjmqrEBf/VnpuTqF7xmg/gJ1vSDW1f98F5xoTHGnARaJnteCAq+UWkj4VVgxeJBhitZSIJp7DYEuIKX57yqfOyQQ9RlaXEG7G8+9nsFdjvCuDyBLyrJXrUjMrCTeZXVko0ccTewCKck6Fc2nSj5BIqB0GxyMEti4/DkhBwgR0GW/mILtMdx1x3q1AsfEZNZfFTBVOfQC5BsJXjAX2NxoVUqdkXy84CuV6kSKY4gH8NtMEaqk2yRxy6e2RG8GAyIuZqTRDA7/0CU0rIF8KAtQUvEFxDiB31h1D3hZK5ep+DH9Wb/9SDc1s21/yHxEmP+d3T03OKNb62D7m3V8rw1Mqggy8clRe/TCOftXQEsPMgf26bfd+BtenWqAp3qhlYFhAlqT7QtH3GXoLKsy7DnZyLyLGyb5xk92mbUgkl9NmLLSEcEq1qxyCAizLOXtGel17uxGCjRIguFo7m41uMA8duZYJdN9UpO4XyT/SdX9qhc/ogK9S1+M
 HtuHpNsN
 rce9c8AkJz+vOwXdflFIifby+z4qB3/2rF4trNvIaJjp1Rl5EqAajmFSlJ6vWble20UWkVhedjToMFV2p3VtFpDBrMsxi1CaNIbfm68uq8/eRsEzw+DZICKCCV30doZ1bmUtKyF6YDulpDe7kMMLDRci5cxnFtqebxEjQF/efhL7o1CIHrrqx+X/YNqB7K6aVDmdLkHhHrLYaE6GjhbKRmKUs+yLA8C8xNkX9nwp7K0FOpuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 05:49:45PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
> and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
> introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
> for pinning memfd folios"), when the fallback path in
> alloc_hugetlb_folio_nodemask() could still call
> alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
> decided the zone and migratetype of freshly allocated pages.
> 
> Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
> resv_huge_pages leak"), this call site uses alloc_hugetlb_folio_reserve(),
> which only dequeues folios from the existing hugetlb pool and never falls
> back to the buddy allocator. The mask therefore no longer decides where
> any page comes from.
> 
> Long-term pinning safety no longer depends on the mask either:
> memfd_pin_folios() obtains its folios (dequeued from the pool, or freshly
> allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
> dequeue_hugetlb_folio_node_exact() skip any folio that fails
> folio_is_longterm_pinnable(), and current_gfp_context() already clears
> __GFP_MOVABLE from any page allocator request made under PF_MEMALLOC_PIN.
> 
> Clearing __GFP_HIGHMEM was a lowmem constraint for these folios, which
> were meant to be accessed by a DMA driver. It is not required any more:
> the users of memfd_pin_folios() work on pages and scatterlists, which
> support highmem, as does the shmem path with its default
> GFP_HIGHUSER_MOVABLE mask.
> 
> Drop the narrowing, which has had no effect since 26a8ea80929c.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

