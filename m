Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4BAEA3C4B
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DC16B0005; Thu,  9 Apr 2026 06:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364DC6B0088; Thu,  9 Apr 2026 06:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1916B008A; Thu,  9 Apr 2026 06:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16E346B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:38:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F21A8BD69
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:38:05 +0000 (UTC)
X-FDA: 84638667330.22.2930577
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96BA58000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:38:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QmNCOPRP;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uq24EilmIdS76nXGDAwJu8G3CVqetL9sNwY4U4OjvNI=;
	b=C2WuhIWyZAoC7F7Oh73PX+XLCZ5HBWrvxOS53Sn1w3ooi/qHdEJBcl0EHS3awLywT+JwUm
	jI4mR1mamHKgpJmQpAOd6+GFoRKqTqADhf4Vonqw8HvRamgBxE4rpmyC4akZzZ+sMhXsg1
	TYDz/eMz8y/O7Umxp9irB5Ymof5LkBs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QmNCOPRP;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731083; a=rsa-sha256;
	cv=none;
	b=ui+dL0tU+bCxvgzPUHmc1hY2IDdlfXc285fWYWxIOIwcBSxGko8ospyJaVr4tDkHVl07a8
	hyvC3Lz2RhPxRm+WvNcIVrlR1l3YC7gJDeFXzlY8qO/uK6D9NnQEPemiPnksm2dKXw8ibn
	ixw1cqwZhy53RnhaU5XZJrSpYIW15Po=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 914B641851;
	Thu,  9 Apr 2026 10:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93843C4CEF7;
	Thu,  9 Apr 2026 10:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775731082;
	bh=976DNqeQEs7Pl86bSQIumgGXPxpOrVddLnDDmQWOHVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QmNCOPRP43UhzksR5XQpFQQoocT2bmpB7xLiO8PisbEJ+AXcLEkykvdo55fWP3r+n
	 dsZssJP/kYRRyzIhHvcVafJaWpGsgo9h6GFwGgr0oap6IlXPbfNbqvQKIVIUpBTqb5
	 VwxcYF9KUnhIpRqTf8ZO5MIu/NxSPZFVMadq5ELnHLLcGRsGat01tlsqwV1uAtGoPo
	 n5vPo1Pv0g/MOsD/d/7Qb9RIXa8H6jK+kD5jSd+ijK3Mgts74y6z8x42c/muXrOQjL
	 p8BOJGYMNnkMiTzYr2CH2yTi2aHvRDh+mYu2d4n4BEYrwgD8AjaOqiVPeKDrRLEhYO
	 VSf+/+rUX3yfQ==
Date: Thu, 9 Apr 2026 13:37:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V1 02/16] mm: Add read-write accessors for vm_page_prot
Message-ID: <adeBg_eZvmz-ST67@kernel.org>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-3-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051153.3150613-3-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: 96BA58000F
X-Stat-Signature: gf3sk45nmoxeu8qsjcunszebtx4jpt9m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775731083-690547
X-HE-Meta: U2FsdGVkX18PBdrBD1D471k99j/3Iw5gxFnWF5InWjUQKcgsFoAgE06lV/+hdEUDTDa1/0R412Ekglk3BY3v0PqZn5/qZSx47XdX8E6aOmpsInJZ5o8hhO5lKysYyB1r83ci+DGQsNH5BqP57+MxxGi/HxErQ12SGQfyq6/fMdWqt+3h26WwNH1+e3NGQ/aawF07+K96FjzV+d8CDC9060/wHO5xvgARS0EQUN8+nXtsYA3q1x7DJggTJ509zbcsIfXWDXiQB1CwpzVj1qzPWYPlm6A500wQoDHBoUQUKaglI05ckNNUxV11D9S5u1GwElm4c8EhNn87OXgZ09xW2xZTc9gOwqgCxoHG9UeYVTd1/R8GPxBO9Pfe2bFhoOXi1NUHnjrFFr3TRcKgaBHrDRzsbnIGedsfIX/6YSgzBPX8GmrnPUVOp6aaKekpjbP9N6xpU3SlAHEL3Q6uueBU5m8oWK896ZnEwx6G3z2f948h5uJytw13NpO4eVt5T4hZ0pyqFo/ONtE6Bw63lMkVIDqsEp+i2PCbrlI23ehDLYcfkH9v+TRRL7NaoLtWRMgYnJMeFDKxj6wYw48Da/ALC93gwF8ZWafPVjQIGUOpc3Vk9rbuQiiFM2/O/16JIOh4l3gS4sGtkro5xU1NGvWvMgH/PyYmztlXNruerPauK7YFoq6ZDUw1bZ77FbmYezDHpVsuULNH7P43RzlCfTY67wuFMJy2xd2jpaKMpjrafwkmozFoZFYksRSfrW633TlM37bm6XUmG8s0B8qNy8T6PZoJErTjJO/lI/hFusJN/C47P7rdI0Ty+3DD9f+rA9afBwjKphdeiMZhja2jjCHeq4TDRlk3R8jfey61CKyU2x8VvWS5AVE0v21/+RJzjOZZ6XS7Q11rgBPAsV3BTCKS7CqNZObb0ENYi71UPD4q4AmbfmbE9DmCVvBsvWK0AU8tRmtYygErAdgjOTCiIAZ
 Ri+p29Z3
 x26M6r2Pngt3hkqdeib8N+QPikkT2ZiL7+Of0PqgUjNFkWsK+vOV00WX9qsK2rdjtzUZKhB1Cyc5QmLDnpZNIyViFu0DCFbREJqFHPspMaIgCRFKE7azMNo1YAPSZhxsnm2q9rS0bvPPf28H415u1+BqUl8ztwuVotoJanLQINH1LPxIXkHjpdxeUokid3FVJnXGG2oUp5G+xmk/zq8FEiCFYkttKU0rVXFWb4s29DrcYq9l4ZPyuw/Nwr1bMzbR77NZKVdgQj1qDIKBYj6JtZJEIxV/GSiO49vXZXfDUrxCkxZPtx165ZZPbB1+f/+7uKuCSKSo2HKWAawzIu11M35KRtVitiN1RLsLWewiBTKXjEY9eLL6WyjpYqIPyxkoDUOFRNuliInd9i250rRzTgMo/dQS0Nf5pquc1Kg0zYoVTyfT2tUsejcpuWw7/5iePvF3i6RFItaZubG/wTC+u0tME/5IfHLObbwWzN3uW3HqBf63fqhh5AKuJkXkf+/tuIgtzK+PJ8Oq/KI5AX/zqGSOs5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman,

On Tue, Feb 24, 2026 at 10:41:39AM +0530, Anshuman Khandual wrote:
> Currently vma->vm_page_prot is safely read from and written to, without any
> locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
> tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
> be handled with READ_ONCE() and WRITE_ONCE().
> 
> Add read and write accessors for vm_page_prot like pgprot_read/write_once()
> which any platform can override when required, although still defaulting as
> READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/pgtable.h | 14 ++++++++++++++
>  mm/huge_memory.c        |  4 ++--
>  mm/memory.c             |  2 +-
>  mm/migrate.c            |  2 +-
>  mm/mmap.c               |  2 +-
>  5 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index da17139a1279..8858b8b03a02 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -495,6 +495,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
>  }
>  #endif
>  
> +#ifndef pgprot_read_once
> +static inline pgprot_t pgprot_read_once(pgprot_t *prot)

I don't think we need _once in the helper name. Presence of the helper
already implies that pointer should not be just dereferenced from one side
and that using the helper will do The Right Thing from the other side.


-- 
Sincerely yours,
Mike.

