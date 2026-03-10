Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C96FCC9D9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D926B0088; Tue, 10 Mar 2026 04:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB416B0089; Tue, 10 Mar 2026 04:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24FB6B008A; Tue, 10 Mar 2026 04:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0B4B6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:10:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 449501C282
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:10:35 +0000 (UTC)
X-FDA: 84529431630.28.6D4A61B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84A9514000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:10:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etPBCatw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773130233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOjZ6Bsfoa5SMpkYpp8EKnL7zElLqk1G+4q5vwPQuRc=;
	b=TNKF2JTv6GwbgQ/g/dSNfbG9P+wI1ho1jFRhv/Bp6/8DhFMgvrBPxAa/LaHjDrEMWsZbkt
	nEJ+9zrwqAglFWMk7i9U9GgNRlyRIH1m6UmRcwOandBe7kBpboKRYufZTGekA03K89mTUg
	0w2xOxwgjbJtieRH8I3nUWgAJQnN9mo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etPBCatw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773130233; a=rsa-sha256;
	cv=none;
	b=jeAhMlcu+RIPJuGxA1QTnDW0rctYEfJWCJPHJeOsep5hwJxptyJhKnDe6UF+n4konzbfWu
	KVIr7NK1XT2i5uQx6BL4OS4dY8jHDNHQ7J7391HJcL2XZzCcfP1kh+OC1uoyqVGZRDcFNn
	O2mgDRKpS8/RgwdAhPvJucJfAzicKfw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 721CB40517;
	Tue, 10 Mar 2026 08:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59300C19423;
	Tue, 10 Mar 2026 08:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773130232;
	bh=u08KMBTx5tv08lCkpWxnrhuJz/6gwcsx9mpAQVrzOWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=etPBCatwxDtpg6nAJGISl9a9A4kQKbPEFHduEraDOnh3urqN+nHcBg5s5QSiS30V3
	 eFMKi7Pt3NamhZriFd1psR+5ZJW41b2tcaol0RuF3Vn+5KKjpJrb6D21RJ44vO9LWa
	 ysQsmdGZpsjBYYktkXCFM21VEPcMVLaaQU3YVoZ+W1C/rP0YZjt2jKa64LJ1l4A/7Y
	 Da1imeFP7JWqYhYcjc56AWo+ntasG6Flr78aBmLdZDVfc36yx4Orrt6oSZWlLg2AI4
	 y2XuZ0GAo0Z7f9LN4GSJ3Zersidb0gOMCTRcfp9UFkomL74wskO+hOys4VQIMCYMyu
	 lP3jrDuXc0fEQ==
Date: Tue, 10 Mar 2026 08:10:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 2/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
Message-ID: <92b8f168-b135-4c2b-a0be-36c8f8079684@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-3-dev.jain@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84A9514000D
X-Stat-Signature: rff4yjyhfyu9uxcy35f7tx7r5r99fhcy
X-Rspam-User: 
X-HE-Tag: 1773130233-466497
X-HE-Meta: U2FsdGVkX18oJYL/M5tBWRR1wLkQb2F0dJHxvBTODG+Twc8ytT76iOcShV1t2isUmn1q3dqxwt0/1gnacRPBeQkUbyyNu7sc8K2k/PBcEg97bzGk/9OQXM24agaE49h+8sD2SmTFewB8rNALh6ueTSjzY84gbjd383B7J4dkDE5uny/2Tk3qrfinvt6uzEFa2j4c0XSaHz6uTidKD897cWMGIR84znQfLprcsGF2pmTUyA/F045lKdfd6YbJNyM/e0CXR5lXimlqNPsTYm0lMVvifRPeJ6ymTriXWwiEVdZj2H81WO9whNE+TqHOEHgWV7sXS7Q4E9NSXIZU1yCv/61jN8xdYF0UL9dy3JYJAiN47Mn3HqQ30BMlTbu60ipfCuQit5Jmn7K8cHjGMIDPy2Wf0eQeNLSblsKBVg8jvCdKgWff9pebYOL7SUr082H4V9o1R8zdLEvD6VxQvBfyh3kULt4E/SNvaMvxC04B8Vt5X/0buwyRMOivTJyVh7Pu+wNCDsEke0O7sjE3ZHcSmGTRudZ2PCdm3Evgm9pvxzSRCMZRugjKCMwInjgnS4uYlsxTX38Okp2vJ8gUjcixKZbT+dcrr06fZJdYR1HbztUQD7kumaJyfsrl35c7Mh2y6Es5PfQXIgGzt9I6ulRNnvhiklAANQ+v85Df0giMoO9eQ6Nwq1korTtRygxBzNJV6XNJdJkiii8l9TGy5DXsiMmzbfZAXRTeEXTPdBwzQDbaHbFbae/LHFpCaWglIlDim1DxbAA7cMY3ozrs8T+fdCbRVD7pmlxE6Zj/cYwaYi1kTmlwKiCGRxszyYSznzZfvHFzl9tna9fpOrmvY2B66oQAk7N3Z6i+QeWkGeKl19OWcIUWQYk0VQ+6jIwAG7rh+GwjEKoJH/7YN1NpjIobA6Z569F647HkBiiSPHKDMwXZkOBMEFxUGu58bCVFwZ+pbINwhh9GiqcU8CCPTXy
 gn3fhJTP
 ng3rKyGh4NBp4ESFCKLyTcXBVqZGUIRU+WtCRGNQFBfxC/x6jKKHEaS0pqY6RTB/R/F30AqVOKlcp0zGzvCBdeNSiE9EC4GNAv8rG298KI/VArXQJcZDDAupAPVdABRaUJyb721E27HaJzoQX/rbVpK+HRXHHPfmr/UVjmaaWjytPgRpdnDMWhWmZw7PiwxO4Jm4Oi8428IAKJoJQupSWIdSz6Rss2T3Od2SsVvMmxTv1IRLR//6RlEp07QyLlbtTxnbKVJenVUqodCTN9HxcckD0aCrcSmomm2cM+L8I36ivbjirI3XbLwkzU3civNX4DeP7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:06PM +0530, Dev Jain wrote:
> Initialize nr_pages to 1 at the start of the loop, similar to what is being
> done in folio_referenced_one(). It may happen that the nr_pages computed
> from a previous call to folio_unmap_pte_batch gets reused without again
> going through folio_unmap_pte_batch, messing up things. Although, I don't
> think there is any bug right now; a bug would have been there, if in the
> same instance of a call to try_to_unmap_one, we end up in the
> pte_present(pteval) branch, then in the else branch doing pte_clear() for
> device-exclusive ptes. This means that a lazyfree folio has some present
> entries and some device entries mapping it. Since a pte being
> device-exclusive means that a GUP reference on the underlying folio is
> held, the lazyfree unmapping path upon witnessing this will abort
> try_to_unmap_one.

Dude, paragraphs. PARAGRAPHS :) this is one dense set of words.

It's also a very compressed 'stream of consciousness' hard-to-read block here.

I'm not sure it's really worth having this as a separate commit either, it's
pretty trivial.

>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 087c9f5b884fe..1fa020edd954a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1982,7 +1982,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	unsigned long end_addr;
>  	unsigned long pfn;
>  	unsigned long hsz = 0;
> -	long nr_pages = 1;
> +	long nr_pages;
>  	int ptes = 0;
>
>  	/*
> @@ -2019,6 +2019,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		nr_pages = 1;
> +

This seems valid but I really hate how we default-set it then in some branch set
it to something else.

But I think fixing that would be part of a bigger cleanup...

>  		/*
>  		 * If the folio is in an mlock()d vma, we must not swap it out.
>  		 */
> --
> 2.34.1
>

