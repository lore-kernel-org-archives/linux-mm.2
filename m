Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF7EC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146E86B0131; Thu, 16 Jul 2026 11:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7E46B0134; Thu, 16 Jul 2026 11:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E006B0135; Thu, 16 Jul 2026 11:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB9186B0131
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27CB1A0081
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:52:55 +0000 (UTC)
X-FDA: 84994780710.24.52A0447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8944840011
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:52:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLDjiQ9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqoUQDDVg1sK22IYjK8mURPEC3+0dDYihfXJb+e4fcI=;
	b=ox6Gu6VREhpv0u0GEN+KEcIg045CwmqF6tsDDojpI5tdlkY4jPCSLBAp8Yoqheo7KqDDgY
	wJPCd2JKC1rvRmsmDHELmWt2Fk4I8ooo6R48p8U3bZf/Y0GC8dfijl0NHg4k7le2jArQqx
	Kq4xL4hUbhCq5yqC7JQOsbcorrZWhhc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLDjiQ9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209973;
	b=QDT+QYRfLaUryLaA5ypYAijKuZ3TeCVOwlIsBon7ncoeUhbMfHLABZVAVugaq49lESn5YN
	Z9WRhXVif6p56goxzN3KcPgEo4KzbPhXjkvCbkfH6KMIEymVpaqjpEjmcKG7vI8Guz82IS
	N30tqSdQ7h8buD6LZ2BtOz38Lfb7n7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DEE743D2D;
	Thu, 16 Jul 2026 13:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAB71F00AC4;
	Thu, 16 Jul 2026 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209972;
	bh=VqoUQDDVg1sK22IYjK8mURPEC3+0dDYihfXJb+e4fcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VLDjiQ9iOXUUY8bOLQFvqxEdqqtdbOCPGqvGtmXLmzaerr9D/xa3YPyvzQ+HRD8PM
	 iIVZD2/lGd3qpd2NK79RQdFKbmM933CEfj+gDCTnTCvZ2SryyRjrjz5tThoF3lkpE7
	 xM2Fewy+p2GkcTyZdBc4sT9xhtwNmYlP6w5cdiBO6DulLF+VGQoTzhKeZ20XYecNIz
	 rm7SOE9rYMjKlXyzzn1RLHnnsjJ2mMkEUM8knPJDt+aL+0fD+RRZPptIOt/KN18Y0b
	 IVtAqH0xXLR4SiBouYC6euNNSmlc081bTEnwp9bSrA5SsNxRn15gSSIKKqGjNP4jaL
	 0Y8o7qgQLCotA==
Date: Thu, 16 Jul 2026 14:52:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 2/2] mm/huge_memory: fold split_folio_to_list_to_order()
 into split_folio_to_order()
Message-ID: <aljh_T3LOqtxRCVS@lucifer>
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716100345.473473-3-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8944840011
X-Stat-Signature: npnfja8ej689gtedghjofoe5fkb51z9q
X-HE-Tag: 1784209973-27997
X-HE-Meta: U2FsdGVkX19c7eTNl1SBzYUOYXvMDiJXSqArlL6ntjKMiJm8iqA5MFSzS1dCK1qHZbZ6FJXBF4yGpkquix5k/bwGwv0sms3McP+xaXDhvgocxa26fmPyaL7A9EY3ftwSMH9PxvsgfR/17yVorjXGTxhqrc2PmSDxsKtO3l7/1sv8uHk7gLNAQoNsPNkVgbA6LGw/Myy0NxuvZrvcptu5tftDxNT7gUvAASZ+lAFM6XKmEgAHt1Q21/xUXrm479Vn1W6L3SQL6EJ5IHRpPDrHEZjonkpefsOeEP9m9H36FCLiRFMuxxbht6uWaZBPXqWX7Q1x672J8xh0viCpumNtPhZtuohASmrCIbLSQ1du8x8J7zUNZSeNeISu3nykwZA/VLsL+bfCRYJH8mFwixQP3Xj4f2A90rxKRPw7pNsPhs7LUglhq8B9vegdmbGFFJMmVhI67zzJlR1f0ohSviZtxJyp5YrAK1xbr1pIPXI2Y490Qm4tlPXKCRwznijvNtv0wYNIO1EBF6kCYr//ratGHQdphb6cxchfZGwlajVUYmuXhsflJN5m0r0OEMzCL22E5LEWMnCI2sHs59VNBTTofsb4nXlgkc/TLrASjDBY4StpRwozY2F9hH9z8uHP6RTIDhzJ0V0bWO4uyCboYe4nUWBP8JOXgFHsyrdroeYXbURybgdar0KyfHp2KqnZ4idYu4WF50gXZ1iqUfHjBTaL8C+amVQasvyaeaUgOGWuHTlNnctaGiM7VSS8IWX4O+KXaNOh+bAIgKSv97B+6/cHszUNtX+Co+fvk2oD5xhVc251mX5cOcwozLQ53hF6e/GckxOUZPT8rWsz2BcvXKMkPWPJP/W82XM+0JdmB0hGRJ9lVe7xjh9PFAJHtuL8SXWACkbANk0BdcYfJX4lNEyenj3IMLDO3cDKlkngW7uIPmb87oRWHFniqHzjYLBCVTJ3sDSpwsfnMZadDVTaLFt
 k9Otvyvq
 H6YAn5Vu192D0NIqCA36RX2az3mZxjJDl3ZqnJmZJfmbYeEat7oFjJe6w/s+S8OYlyoA7ClgbuBLR/vqgFc1m63bgPd8Jhifa/iPOOhAEluc855b2Nue0YXDEpX/qJ+ulD1ErIc6ZpGS2q2YHh3HXXlZ2qOjW0pGPxMMVrDoFD+ZS9g8GNspWmrGl0BYluBfKBkhbUS4vHXTNNuKnwskzzs7gZ55rEGvY20UIhqPnvwRlwInnTLDavAIctzdf5Y3gS06a366RKGbPCvtxFNhWfdm0+sRiG3afVlmQkY0lcHNVTK07/XziKyFCeUDbDF6YD4+S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:03:45AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> split_folio_to_list_to_order() had no direct callers; its only user was
> split_folio_to_order(), which always passed a NULL list.  Fold it into
> split_folio_to_order() and call split_huge_page_to_list_to_order()
> directly.
>
> No functional change.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/huge_mm.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 6961db4d1591..1842b1e6862a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -792,15 +792,9 @@ static inline bool is_pmd_order(unsigned int order)
>  	return order == HPAGE_PMD_ORDER;
>  }
>
> -static inline int split_folio_to_list_to_order(struct folio *folio,
> -		struct list_head *list, int new_order)
> -{
> -	return split_huge_page_to_list_to_order(&folio->page, list, new_order);
> -}
> -
>  static inline int split_folio_to_order(struct folio *folio, int new_order)
>  {
> -	return split_folio_to_list_to_order(folio, NULL, new_order);
> +	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
>  }
>
>  /**
> --
> 2.54.0
>

Cheers, Lorenzo

