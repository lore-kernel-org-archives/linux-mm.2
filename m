Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F96CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4DD86B0095; Mon,  8 Jun 2026 07:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEDD6B0099; Mon,  8 Jun 2026 07:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C150E6B009D; Mon,  8 Jun 2026 07:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B010A6B0095
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:37:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C903140AAA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:37:35 +0000 (UTC)
X-FDA: 84856545270.20.367C8D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF1D0C000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:37:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+uCzJA0;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918653;
	b=ttBhDIkCJyLH6sPva1qHnafCTym+xJDcwE6FqKS6hZwKg93+dLgFtE7tN0g8kvmjlUroBD
	irwTBJosBgN6OAaaayjZFJ1CmThKBpjb/InNohBdhKQhtQEgh3rnbfjgkvMoAIjIcnj6os
	aWnsqBZaLtcrkWnUnCPBH/Dgj1Szwmw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+uCzJA0;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbKY+/QgX1YlcLcIfrnvHn6Xg3zI9+wq5m+o05G1544=;
	b=j60rE0oD7m+8F2F6hT17qhymgcPUjG84F+lTAuHqJexMaYzvMzBJY+Wiw/KawQQZBCNnaL
	07F7foLZBjMh34JIFVz6J2RnMTtoMGRymSOx2WbxOMAGstbFW827lyTbMCaNjHLkTWa01a
	uWh1NEsrha3AoIlTX4m/4TpmkqNNnhQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B7466001D;
	Mon,  8 Jun 2026 11:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D61F00893;
	Mon,  8 Jun 2026 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918652;
	bh=bbKY+/QgX1YlcLcIfrnvHn6Xg3zI9+wq5m+o05G1544=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W+uCzJA04h4lzxITom15y9mpKUyp140CgqBFDgSwg5WCzBbgjz/KQrJTlLC9P2y5B
	 GjViMKOTSs2jqW7wAmxaLRD5EEQGdDrbYaXJRCqraK10o1SZ54CalvhU6r55CtO/sO
	 jmJSb0GEQGsgpELKbh/8NPOTf8xqHRwlOaTS9hKais/K5iHw1Ke8HcmHKrGL6jjP1g
	 MymtfUnNk2bMmRaXi24NC4ciKkRiMulBpz1Np958dlIjoVj1iuni/TcDw2dxRgyh6m
	 5QGtocN/+xw66CFrL3NmgNqaFmiu5JRZZE9RIZJMWSTy2mo24LsUtUvNubxScWlBYZ
	 i6I9IJqXpFSHA==
Date: Mon, 8 Jun 2026 12:37:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 16/37] mm: alloc_swap_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <aiapFvxPXuPd4-OP@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <d2be78654e9dcc7cf5b8a542c2c8f331187c80c9.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2be78654e9dcc7cf5b8a542c2c8f331187c80c9.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF1D0C000C
X-Rspam-User: 
X-Stat-Signature: bco9bwpp3e8yo8ur6944isz1sqqaxmwh
X-HE-Tag: 1780918653-771910
X-HE-Meta: U2FsdGVkX18WUC7ooZf7yrPNNm5cwP4DoLV9XmTIXj+SRogRq2xAt+2psxBtUk0k9xoT/p6b9kU2VjiPaAgL0qGd7h0VwecjUFccKRnG08EaJEM9o2OBOpOaljJqRIaZ1NvEK5tMSiPaer2bKdkcznm170eFKNGvw3nwnix+4tNaU31uz6By5N8OP0YZux5/rT/i3mDeeqm/nR4pVnpp7hDOBwAz4Z2UYr4dSgdGu7sg4edYQXd/Jzq3fzEUM1BltoHrJOYP7MG6l+pVJx1eDZrnvsRyakKX6NlDxVCXWm9LX4inny5nheQ1Z09dy+udbsSzNargf4ZO/JBvhqIUot3IfAyS2gfYawzLqPeoQRoLVY3ze5uiSjuT+GR7+RW9oHqyLfybnS3iPOwiwRr/rM4GoahxvVP9/gPZAcXdsJJKVL/oRIvxmfe3EJf8el9V1FJN1bBy/U+Hwp8r5jFBCA1rwMb23Pag5zvFlk5LpBBT4BNnXFJyWGIxYkzURgrC471ek+pUvMC464YVjCPBvSyWjfh+GHPDWQsTlK+Vg6ymed11v7C0pczPThEDCXPsbtZKWsjFlF3ewrthswbo3fRatzZopxUR68ZuIm9XUrUVchgV1B+P15BAGvA8DsDBIWUjpuXikkcgjp68UQ0wkYJJ0sWU064JCzToNramSf9jXIZoYWZvXdIgBUcWukg8NWhqGZw5NY2c69S5Z3/I6bnOh31i9ykSxuPoClJvZ54hDKrqZWbuktDhx2wBP64jFJin7INME+oRaYgHRSTos8ysa1Q6p2t6cBWn40DmsDEpfSxTlmcP0FpOcFh8zy7IJO7MRTJDWelRWwyU39E6azH3BdqyjrqqEciSzP3oIl3NKLNkp30t43iSBJdrLD2UbNPnb4NZhtWYW7aGDzf+ZqE/nS2/gK9rd3ZcKDbO7GY+ZYwRKy923XuFZSt/clguSrOCb3O8M51KrdDB7k3
 1FpVQHsM
 +90DZ7+P0ck4JivP8bjj+Pcwbhrt+O3enz+pqV7Titsa5WNuATj3NJyQhdIG3uqWuBQ831a5vGAVuqYDbyhTkGW15Ic3aQ9qej8fk4HRv/zbnoftYCGfD1/e+QGS5Cg/bGx79/UEf2T7rLC39ZSe53/0It9M5wOgE0xjgCCoLwHy2Hvyyqo3ChrZCavMQXN59KwcY8XWhqu4Rl5jx7oOpUMps3LyAiCVUNCj/fSWUHS57/tQpjZV4YCRLMjNzWutLjLyWgNdu+krNBTve+lRHaVnqP/3r4mkXagifqsD+VbZQvBJwG/8QXRnZ+lygr3GHBD9uhUbz6ijqrQgT3KkM9v72CMCLYLjGlYSj1b2+t9HnvCbGrBM2srQ/5QSpVvqtOq/D0AxHkwTuNxNbHLughiiaXqc2dxs/Tp8auS5DkFc9a+WxZfBdX5LqQS90rkmIguYpFoyLPOuJjXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:41AM -0400, Michael S. Tsirkin wrote:
> Same change as the previous patch but for alloc_swap_folio:

Please don't say 'same change as the previous patch' :) explain what you're
doing here. It's a pain to have to go check otherwise.

> pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
>
> Note: NUMA interleave is not affected by the raw address;
> the ilx calculation shifts addr >> PAGE_SHIFT >> order,
> dropping sub-page bits regardless of alignment.

You're expressing the same thing as the last patch differently, but then
eliding other explanations from that?

All the same questions as I asked for the last apply to this also.

And also - if you've now made this a _requirement_ that is broken
otherwise, then aren't these bisection hazards and should be squashed into
the change?...

No patch should break anything at any point.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 21f640674c4f..6c14b90f558e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4750,8 +4750,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  	/* Try allocating the highest of the remaining orders. */
>  	gfp = vma_thp_gfp_mask(vma);
>  	while (orders) {
> -		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> -		folio = vma_alloc_folio(gfp, order, vma, addr);
> +		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
>  		if (folio) {
>  			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
>  							    gfp, entry))
> --
> MST
>

Thanks, Lorenzo

