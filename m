Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22CACD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEACC6B0088; Tue,  9 Jun 2026 03:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1F96B008A; Tue,  9 Jun 2026 03:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFECB6B008C; Tue,  9 Jun 2026 03:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2B166B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:35:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 694C3A047C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:35:42 +0000 (UTC)
X-FDA: 84859564524.04.B4D8C61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF7B2C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:35:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKM7zKoO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7BX3CVcz1NCkcZ9VRBH6DdOLwzw/KIRmNNQBjRMkfQ=;
	b=GGfmna8G5Nf2B7npRmeeLTtNj4s4DhzMj6afi5lI/CbF0Q95NAVnfqbeoY/DvvBbOM9jc4
	kdr4629FU/dkxyBcgoN4XxoHPKyuCQakBSEM2EIuqBQp5L5e/OGjmjejZK4hpOJrdxvF5w
	wM6A2A3rx2tqK/DMxxKsDUCqfTILc/Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKM7zKoO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780990540;
	b=ubsTRYgHVCLoXcG6oZ1cyYXNriRcsNJLoEO6RZjqBaPJSX1e0AORfJl3uPpzV0+V37T2a9
	LnXi5eu/fmx6fdcSdxW3Yb4+lnBmVkAdVkkuFZ1qXSOGjIOmYHYs6KWNN6wAT2/I07XjBI
	NFQbX5rq+QDk7bul6DPbc7WxtP71Mvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A511541856;
	Tue,  9 Jun 2026 07:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D521F00893;
	Tue,  9 Jun 2026 07:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990539;
	bh=y7BX3CVcz1NCkcZ9VRBH6DdOLwzw/KIRmNNQBjRMkfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QKM7zKoOEGCmMOgjqz22FaKfmugoiB47u0nOGoRF+NOmN4l3nOkdpksy+GKxK4DWw
	 4WYMWzVXJI9bMUCaTElKkEpgWpCvycuMhBRMi9/Kyc7WnxI/o0F1HEYfT4OJPt2gwV
	 riQ4+si0ZdaOzfmaT5XiUDCG1nF3cyT2H8LjMY2KxQcEhxAM6gjWI59jaAgMxBsZMd
	 /J7YJBXZnPGAhxBqBCDJXfiw3gGo+Y6FCNaomGkb9Yt1KNyfICXjtq8UOOz61RIsXN
	 SCVTcDdXsg9MUCvSC5qXuq6jKSFtShI3F19CxxVnfKCdj013Dw2LsQ4QuwouEHROp4
	 QJSRvJNsI0rbw==
Date: Tue, 9 Jun 2026 08:35:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: hannes@cmpxchg.org, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, david@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org, 
	usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org, ryncsn@gmail.com, 
	zaslonko@linux.ibm.com, gor@linux.ibm.com, baohua@kernel.org, dev.jain@arm.com, 
	npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <aifB-YGdJAGzgprt@lucifer>
References: <ah3MuK3GuimKVORB@cmpxchg.org>
 <20260609032058.23770-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609032058.23770-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF7B2C0008
X-Stat-Signature: afrki8up5ibb3j1nxnb5afhsc88sktqt
X-HE-Tag: 1780990540-886482
X-HE-Meta: U2FsdGVkX1+4PETTHcag11uGaoWpT42tgMTwuq439HnW/GdJutLVNQBRhhBm/uB9faF4P0Qc0yIWBcSU4YMvSY2IKLLZqlk2V7zMSBRihLBRv4e4/OJ1lHJtAJW4oI7925fRi0r31bvly6B7Yt9c5uReOSs2+MQoTzL6MwwepUi2OHIX/79yha1ojAxG1pN+qiEUkF1uXa/RJXBQYzXGFV61R4VweN84XxHIkmMURaulcGq2hZW8E3hxUL++4+FHwCShq+ozZZ5MprslmhwqrUPN/e9HVRTC92k0t42VNyddAmpLBSLgLyu2tnk3D7SVmLD8RpDlpuQkUbOGvdRrQo91TXAuLjlrvarFGGWT5XZubOXTxnw1y10gPxY77LhegiPe3H6kdC1/a5JreA1q+18ujmPZhpEgLgOhCpZlVN6ZLjv5yYcVK2uUhglRh9Hu8PWAbw9blH+v7JFw3Vu5igTrTO8CWKnjOa/7qZNWfC1/4lz7Q+Fc0r2tX6HjeTQ44Aw26M0+wpZa9OZXDylP0t+GMvOpCJFeGHZ6hz3EG/MSCmhQleovg97bFTRftcRN5dgXVlERPdxkUDySdyNjriLgL1H+XjRqvcrtC6XHRHfaQW6Q0yy5qDVVpNgV61xP++fMRMcpzFDhRqTFN8tXFS/N7DVPDzTCkkmw0OuROCPHNNYZYGLl7bDWqhvMb/EZ9FK1nJ2WVlFR9Br5wmE1pcL2o0gxCfHlhbPP0gDGAy6CK5CbtuJS+WDdERAqmm6/Oh4/Srb+SVqued+khZXT7/1PO8ETzBp/RDSOyyAsgMZRRbbEylSxomeoYGBPWbbiv+2hEbTOtHMzSeDuAEGVFFbE+RzXfl5oiePseIcTNJOjwO4Jcex0/tQJzvYoggae9Fl4+qoOSVERjjOyLTZIiwh/AxTBJGtgcYsci3EAI64hOzo1IVBj80I3BN1Fnz52Y1areHJWYW2XCTfyJQ6
 5+Hc9GBD
 Q/v9eywjnwyyQrBX6Ep1hPDze5jCCBSBPFkYLO1PgdVS2uvd8ta+KXNa0yE19wT+BHABeMl2s8F8XOsSrd0cMU1oNv9thODXo6m2//F+L2CcTI3O2Hyiw0yKo7DW5kIJSU2GeKnVk5pHKveNw4AMGxhXbwxnpnPMdZAwroSegaqQ9wbeMzJaNXh2KvHZk0uxarsWw1doECrka/jL+IfgX/HT2YytpdqvsSN6O7Tcazra6xOrATW7XWQ/vhMyXcEv10js1Yeg0WUL5mgYqv+IJU4R50QvTHejXoOZZTOguloNEiMRM5TQAarkftJdxui7ZdTKw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:20:58AM +0800, Lance Yang wrote:
>
> On Mon, Jun 01, 2026 at 02:17:28PM -0400, Johannes Weiner wrote:
> >On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
> >>
> >> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
> >> [...]
> >> >diff --git a/mm/swap_state.c b/mm/swap_state.c
> >> >index 04f5ce992401..9c3a5cf99778 100644
> >> >--- a/mm/swap_state.c
> >> >+++ b/mm/swap_state.c
> >> >@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> >> > 		return ERR_PTR(-ENOMEM);
> >> > 	}
> >> >
> >>
> >> Shouldn't this be limited to anon swapin?
> >>
> >> e.g. vmf && vma_is_anonymous(vmf->vma)
> >>
> >> >+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> >>
> >> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
> >> get here too when handling a large swap entry:
> >>
> >> shmem_get_folio_gfp()
> >>   shmem_swapin_folio()
> >>     shmem_swap_alloc_folio()
> >>       swapin_sync()
> >>         swap_cache_alloc_folio()
> >>           __swap_cache_alloc()
> >>             folio_memcg_alloc_deferred()
> >
> >Good catch, I think you're right. I shouldn't have dismissed that
> >branch due to "/* Direct swapin skipping swap cache & readahead */"
> >
> >> @Baolin please correct me if I got it wrong :)
> >>
> >> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
> >> only allocates the memcg list_lru metadata for deferred_split_lru:
> >>
> >> int folio_memcg_alloc_deferred(struct folio *folio)
> >> {
> >> 	if (mem_cgroup_disabled())
> >> 		return 0;
> >> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
> >> }
> >>
> >> Since deferred_split_lru only queues anon large folios, doing this for
> >> shmem swapin doesn't buy us anything :)
> >
> >Yes, agreed. I don't think it's a big deal / show stopper in terms of
> >user-visible effect, but of course still worth fixing.
> >
> >I'll send a follow-up patch.
>
> Thanks.
>
> Looks like this has already landed in mm-stable. If you're okay with it,
> I can send the follow-up.
>
> From: Lance Yang <lance.yang@linux.dev>
> Date: Tue, 9 Jun 2026 10:56:45 +0800
> Subject: [PATCH] mm: prepare deferred split metadata only for anon swapin
>
> __swap_cache_alloc() prepares deferred split metadata for large swapcache
> folios.
>
> That also covers shmem swapin, because shmem_swap_alloc_folio() can call
> swapin_sync() with a large order[1]. But shmem folios are not queued on
> the deferred split queue, so preparing the metadata doesn't buy us
> anything there.
>
> So let's limit it to anon swapin.
>
> [1] https://lore.kernel.org/all/20260601132135.14272-1-lance.yang@linux.dev/
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/swap_state.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9c3a5cf99778..7adac957c2b8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -465,7 +465,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  		return ERR_PTR(-ENOMEM);
>  	}
>
> -	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> +	if (order > 1 && vma && vma_is_anonymous(vma) &&

A folio can be anon for a non-shmem file-backed VMA though?
E.g. MAP_PRIVATE-mapped file-backed mappings?

Not sure if that's something that'd be a factor here/meaningful though.

> +	    folio_memcg_alloc_deferred(folio)) {
>  		spin_lock(&ci->lock);
>  		__swap_cache_do_del_folio(ci, folio, entry, shadow);
>  		spin_unlock(&ci->lock);
> --
> 2.39.3 (Apple Git-146)

Cheers, Lorenzo

