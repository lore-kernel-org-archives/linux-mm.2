Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CBBEC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0A76B00BE; Mon,  6 Jul 2026 13:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0808B6B00C0; Mon,  6 Jul 2026 13:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00426B00C1; Mon,  6 Jul 2026 13:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4EB26B00BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:09:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42C0D167DA2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:09:23 +0000 (UTC)
X-FDA: 84958987806.25.337E104
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09504100007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:09:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d3jbBOgl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783357761;
	b=avUX5MzrS56u44CK0PZUyp/vifB7vDaivPfByfMB71eh3YfiyigYgKdTDFEYX7ek6jGWUE
	2+fQeLCewZMLzfkxuXkA09kM7mLrg1p/4JQTOA4hPabd7rY/zALNz9o4c43Dqwh7NKIGHV
	B4eNLnZkAjZ+ziCkLW/mqmE6imo4bf8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d3jbBOgl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783357761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEEP6HfNVLyOFs0jzNs9G2ZgaVMSbs/x+hiGxEjlRwg=;
	b=uUt/rVpVWHMYKVwlYhj7J1OGDGIR4/H30ckPs5a4StsILobaTKhzvu/K7kWfatRlOj6eRf
	RZdXbm4Dmbas5vbUDYHI6xB/p0LCLiXuaOdXpCB7V2KlkdBoFluBOrVLpqWALVa+UByuPw
	D0QZUwd+Ab7ST4iK3SAppY3T+QYcv6w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783357757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jEEP6HfNVLyOFs0jzNs9G2ZgaVMSbs/x+hiGxEjlRwg=;
	b=d3jbBOglN5JIdR5PvfpA9r5yTSpxdTGLlTAddwub7ON2jgkA4BLg6CTNx3NX91nSSQuhKh
	ZvA5ZuWBvxyC5yOncbu3EI5qeCONFBOlhUsqgoG9lhfPiTAuhnwRd/BESEgtj3KotF31MJ
	pa4uj4gP7TL/bMZtUu9wbTfYwMD8XoU=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/8] mm/khugepaged: extract young page check into collapse_is_young() helper
Date: Mon,  6 Jul 2026 10:09:09 -0700
Message-ID: <20260706170911.3430281-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-3-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 09504100007
X-Rspam-User: 
X-Stat-Signature: cuywys3k915abnfqjsaxjp6hg6wzs6y8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783357759-535668
X-HE-Meta: U2FsdGVkX191Z+tBnmccAsF2ohPxGT5sxNvQnVB5KWB8VbtHdB/f4j32wVz2Y3c9kaNtzqaXm8D3dtwBbOx9YBSOOhtv/62JayixyI0cW0TKYu13pfDchB+W8AS5HdH7sia1NvC/AvHCXtT09dUn/ubEeva1Ox/Tw9ZiwesF5w1XiGVV715SJO1EOYPeVrvzDhSfH20YZRsgyobvXRKY88LlviP5434PTbagSYMpPzhxu9eHwRLrgOE16VB6fWZE4KiAjbraQxYqt6dkywGz7zev6Zb+YIL9GwOKDoTRlxZ+Vg/fVJ2n0O/NcwSNWS+D8lKvL9AdRrVPgtWJh/BiITF3wSaVUvkucAQsRudGOyptuMhDP5Lig0dQk1+BGCmekguPZAG0iTdaDVYr4sPhWG+kdCQcfORJgDN0JgRhHwN0JAFUl6Mhg9ifEwoAVO4rAHJmZ3xzBpMl3YQWrsBB4pyWic5nfdmsltSOivr8v6Ia56s4TUsEibWfOicp+8EotNAJQtkZIoNhq15WjgmvnldI9wt+ncsZgZDy2dIIICnC+Uihte/k7+RdQT2XZHka9vGD4FwwRr7HTKA/E618SQPleKLKEn48/5HmuWihPBBL4dN4ffIABfr9/hC6gyu02CaWEho88wBnRbcdYt3bsP8YeLRGCUhv/r+eTtLEqM210wf0FoO4x7/Lu/GPGIYg11PiP8BT2d+jP9yFD5hdCAT7SSG2URK2xeok3i05inw9UnIqPwYiCl1kR/pqSZApp2/OBg0JPdrDe31YUOMFEgK4rYK+RSQxR9dpGqobmyHt/X08VYSnUT0ek1zTXnGI/vNPviE2hEwrQqQhLzNSZoFCnzHaNQFvdjXVx/lBvZNpiHY5OyCH7aiPlRcVd/N9IfzmKD/sefSKKjkPvx3jFYTR2TnkCfv4x4MfKjtTBhO8y4WV2PBIst38TOsNVD80a5mKCR/X7wa7NRExS0k
 d8pU4zvg
 QK8zRlupUVGjoF0usu3QD1UjwNtyby31wpET9WzKlsEmkZ2Oe9VVPqXUvhaIwDCD4YFZnkUr9QEl8TGMDDnanRvqpe5+eZiYqv01KRlW6HySqclN3oTFGrpA77fl38mV56fv1GJNx7n03BgGLxxU/LwvUJ6grgGf4zxobnGg7m5rALTqbBlEGLqYdwWOC4Cj17GUMx7Q+Oon8S0ppWBAAQEWOvK81E7Dp8Arq6dBnpIOGaTI42FmplJwUXZ7LMgfWosMet5/t8aTs7B8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:49 -0600 Nico Pache <npache@redhat.com> wrote:

> The change deduplicates the "is this PTE young enough to count as
> referenced" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: Usama Arif <usama.arif@linux.dev>


> ---
>  mm/khugepaged.c | 35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b3985b854e77..48b008a3c891 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -675,6 +675,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> +/*
> + * collapse_is_young() - Check for enough young pte to justify collapsing
> + *
> + * If collapse was initiated by khugepaged, check that the page has been
> + * recently accessed (young pte) to justify collapsing the page.
> + *
> + * Return: true if the page has been recently accessed (young pte).
> + */
> +static inline bool collapse_is_young(struct collapse_control *cc, pte_t pteval,
> +	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return cc->is_khugepaged &&
> +	       (pte_young(pteval) || folio_test_young(folio) ||
> +		folio_test_referenced(folio) ||
> +		mmu_notifier_test_young(vma->vm_mm, addr));
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -813,14 +830,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (folio_test_large(folio))
>  			list_add_tail(&folio->lru, compound_pagelist);
>  next:
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
> -		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		if (collapse_is_young(cc, pteval, folio, vma, addr))
>  			referenced++;
>  	}
>  
> @@ -1769,14 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			goto out_unmap;
>  		}
>  
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
> -		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		if (collapse_is_young(cc, pteval, folio, vma, addr))
>  			referenced++;
>  	}
>  	if (cc->is_khugepaged &&
> -- 
> 2.54.0
> 
> 

