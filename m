Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F805CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC9A6B0088; Mon, 11 May 2026 03:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5665B6B008A; Mon, 11 May 2026 03:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DE26B008C; Mon, 11 May 2026 03:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3266B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:28:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F9F1C0548
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:28:35 +0000 (UTC)
X-FDA: 84754311390.29.5A91C9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4973180007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:28:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLrKqB5r;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYE2/Lupd6WSGBnEvTVhRdhdUakkJhK5KBp5//rTCkQ=;
	b=2kgPb5CDBP+GhLcE9HqboL+1misZK7qHe8qfN1hIuuNqOXkMIL8DEpC0NXv7apOMftWvuH
	6c8YJp+GwYkk6XMSasMFPsKKgdbTHoEc2XjTK4qsFXPy/8DSzZ2ByTDWLfzz7bfK1/8XDS
	eYmcN3pIXIiPdCvsVb4C0BYpxj5jfXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLrKqB5r;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484514; a=rsa-sha256;
	cv=none;
	b=Vi+lWc7En5N1xsBnXdELlBTy5oZ8L4Ic0Ygi8aV9MGRhHEA/am5SDwwtb4sWdNDwY/W05r
	rmuf2TiLttgD+i2n6rO2LIJBrG/Pcm+bHcXmUYDhZtwV5ongS7kTtax6FXNhINiGwArawW
	YktUOouehkxU5yEDoP/UK9Owns+vJX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC90C44537;
	Mon, 11 May 2026 07:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D241C2BCFB;
	Mon, 11 May 2026 07:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778484512;
	bh=z4etdteC6a+eoV7l6TMQcUNahaazWQQbBskrDTGHzX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iLrKqB5rvvFeu94eo3XrsentSFfG/eI+jaIFbWU3IqN1+FuG73fdGExozgmxXVYnX
	 Hf2AvgrjbGrchMF/wL/RRio4aT+F2HFswp5XWqfs/6q8KXUNIZHDDGwr5fWyjFmBCv
	 HZpV3HA43DjzuJPMVm+jZ4HBtfSztnJrMnnbeFeog04nijPPxlODilc+/g42O4At/O
	 lnY3WEF3wfbKZZjnKwI6SGF7JXCOgsL/QGnHoAEQXRWHiVqyiLCGbcI2H77tkP+7wx
	 uMjE4G8z55XPM6fbN+4Z5F8tsAHaeruruAnU7nOARa7Sg+cO2Ay7LxcBSuffDA/kMs
	 ty/7AjxNeVpQw==
Message-ID: <ff178d28-6a3d-4981-800d-aa9e050a7f45@kernel.org>
Date: Mon, 11 May 2026 09:28:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm/rmap: refactor some code around lazyfree folio
 unmapping
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
 <20260506094504.2588857-4-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4973180007
X-Stat-Signature: ti1dznwg3ooqrh8db31zzxg69n6dkc46
X-HE-Tag: 1778484513-37677
X-HE-Meta: U2FsdGVkX1+S2l44hyuI4b+SPC3ODzihD6G1G4VIpnNfyR6Uz+XqrL7luAasrtuuLc3CRkgJrGR3gsxkswZzBIm/EUBLLg0ZMy+NoGnWeso0TbbtUO8f75NkbT8iNFWrw8CQnPHL7M65nzFHed+Cw3Dckk8gslUP4wgZAoKL620s7DSlZG/iATA5aKPLfVyaHfx5wKs7Js6uIqCi4orklOlsrN5y1X4kFPZULWOvKMgA1+goDLSPROHmwJJruJ+Zsi/CQ5RJscymtdW1DYmbNsaIzlSXCSONcfzsxJqmAV8C6mmQA7vBjmfGajhl25mGEaiUQEo3oJj6S3Pd2YpPNH08J2KfR+LildKGLQ8OpBTa0LX8R8spwxk46C1412xDmbf9U3SzkbhsoLx2s75SKGvRBWq3O23NjCtxEADJUXlCVz4KfCOzTPhKF26Vof/2i7TMthy4UVaYAZ7GOOBAkHBRZb4c94TteRBkPeNdg1yhu0LgzJ6R3pdAukDj+JgF/f8+85N+KesyI89T6ho3s2NDGeifUTDMatsm7Jr5AhgTogU8ZecHEwFtFE4ed8kLTti4z5X7m4PgB8R+AlEK90xsdlBPU4TN60pyAXyhl3v8Mrpe8mkqvspJGXg7j+9t6IHgEVDttADNmp/Cz1iNISCnr/Rrr+DrtszS3HuvCZ+nWqIlRSQ7rh7gqWkV1/jMgzh5X4/ryfgOTmWZRANVc29UO2/ByF5tO84KveYmZl6qNAW7Rgctep519Bnb0K0VuF/jHPT+rP0bOYvx4xYhGhIFXXo5AVdx6YAvV6UxtKoz3fDQfcpuhBsDbJfkniGjLRUImeTSN7wCKoM3FB6TYQCNkL9SPJjbPgiT1za50CMQED75ydi4KLgtLJknkSxJ1oY8S7OV9YWN9XcM0EL2p7yCU8SJ+5ER/59x9VjYSDcbV7D13Vl7XqSKHujlEP59AkE8Q/IJpb60FiSy1rX
 QCSWrW81
 XHMfk0YGGSSMO2NT7Hnc79EKrQxdvqhrgS+PKbNWZaQKYzhfuDwtQlGD9IuH1Wfj+jqLDcG4hYfGnLAkcpw45DjFQX0pjK6OUbRZ2LUf5l4ejHsQsZgyFaVRRmvHxOFDEAV0NMDSCyx2223k7LLCvHSihD8cgG7DrGQUvxVvAKusPn42PllfaFPQwwo1BS+jHD1AeA82+HVYhWmIvBJIJGxwriiT7ByOPrnC4MaMeLCggF4H37QKBw8tYy5q4oX1qlmC6apk8in88H/78VC4aEFLkkqQCO4mhU6sk+1qbA1dV1Rqy65PjoudYOAuVzjsVBvW9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:44, Dev Jain wrote:
> For lazyfree folio unmapping, after clearing the ptes we must abort the
> operation if the folio got dirtied or it has unexpected references.
> 
> Refactor this logic into a function which will return whether we need
> to abort or not.
> 
> If we abort, we restore the ptes and bail out of try_to_unmap_one.
> Otherwise adjust the rss stats of the mm and jump to a label.
> 
> Also rename that label from "discard" to "finish_unmap"; the former
> is appropriate in the lazyfree context, but the code following the label
> is executed for other successful unmap code paths too, so 'discard' does
> not sound correct for them.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 95 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a98acdea0530a..bd4e3639e26ed 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,56 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
> +static inline bool can_unmap_lazyfree_folio_range(struct vm_area_struct *vma,
> +		struct folio *folio, unsigned long address, pte_t *ptep,
> +		pte_t pteval, unsigned long nr_pages)


Similar comment: ttu_...*

> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	int ref_count, map_count;
> +
> +	/*
> +	 * Synchronize with gup_pte_range():
> +	 * - clear PTE; barrier; read refcount
> +	 * - inc refcount; barrier; read PTE
> +	 */
> +	smp_mb();
> +
> +	ref_count = folio_ref_count(folio);
> +	map_count = folio_mapcount(folio);
> +
> +	/*
> +	 * Order reads for page refcount and dirty flag
> +	 * (see comments in __remove_mapping()).
> +	 */
> +	smp_rmb();
> +
> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> +		/*
> +		 * redirtied either using the page table or a previously
> +		 * obtained GUP reference.
> +		 */
> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> +		folio_set_swapbacked(folio);
> +		return false;
> +	}
> +
> +	if (ref_count != 1 + map_count) {
> +		/*
> +		 * Additional reference. Could be a GUP reference or any
> +		 * speculative reference. GUP users must mark the folio
> +		 * dirty if there was a modification. This folio cannot be
> +		 * reclaimed right now either way, so act just like nothing
> +		 * happened.
> +		 * We'll come back here later and detect if the folio was
> +		 * dirtied when the additional reference is gone.
> +		 */
> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> +		return false;
> +	}
> +
> +	return true;


Doing the set_ptes() in a function called "can_unmap_lazyfree_folio_range" is
not appropriate.

Can we just leave that in the caller? We only do the when we return false.

And hey, then you can call this function ttu_can_unmap_lazyfree_folio() and
avoid passing pte ranges. :)


-- 
Cheers,

David

