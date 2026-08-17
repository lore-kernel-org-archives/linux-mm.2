Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A933BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3A66B08AC; Mon, 17 Aug 2026 07:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E3A6B08B0; Mon, 17 Aug 2026 07:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F916B08B2; Mon, 17 Aug 2026 07:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31F4E6B08AC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:33:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD550C0688
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:20 +0000 (UTC)
X-FDA: 85110550560.14.23522C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D730240004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSlvKGye;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966399;
	b=xowGG3TbZgKHPJ1PeXlqMlZP7hHcNlK+KWNSaq2QLYguESTq3vFh8vXy3exH4LtniBtDjR
	96ik6AwN5L3VJhqsLQSPMSPb1i/5d4hkF5IwFBfymH+r0j113pPGP4vuHZHe1+ttAivsoY
	OBEkBbs9jxsmws7HUKst8TAWPHWqF7Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSlvKGye;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rooeZ8QU6qiTJ1cGCyiZI7tHS4KBiE0X6oZIZ8snEcA=;
	b=NWlSa9U/zHaECu2NmWdwOLBTDV8KuSRAMU4gTg03YwgIQFUWeCDLPqWUSMP4gfhGiqbpcW
	/N/KlAumIBWJwjPC+K/LfiTlxXwfShZS3v6Ic8bOe0J4tmnfUNVJZL3oQQ+EBnLv0/7NMe
	Fj3rKLkpxy+FPUh1wv4HRvZh0zfBsTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0582C4404C;
	Mon, 17 Aug 2026 11:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F61F000E9;
	Mon, 17 Aug 2026 11:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966397;
	bh=rooeZ8QU6qiTJ1cGCyiZI7tHS4KBiE0X6oZIZ8snEcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LSlvKGyeOtQd6EtwQ08LK7eerYTvIu2GijmsWNpdq1dIfFlOruBhleO1m1XcPBoV3
	 oXvkcy+ABqqeeMDMJijlBe66A6d7LluLyrV9vS4LmaRMu8fEulqddY8XGLDGSbbAeQ
	 6gto6EMlyVuCbDXiU76m8QfhC31wqx6LLaxy1Utfb+gE8lLwbQ/xHLN0vAc/sOYaSJ
	 ynkszPhai0xVCGLgSTDI0sVf/NbJCVAAW6+7zqSlxbOEm9P0q5OpZTuUlCAxibTg9Y
	 p55qCCoqzp/keYhgczSfa1wJ1gJ/BjyESFzqPMEOR6yEfsENjnlMWYWVjpsv/TgtK5
	 ELU8x42U+n9mw==
Date: Mon, 17 Aug 2026 12:32:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
Message-ID: <aoLxMzu8-L7i_Xm0@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
X-Rspamd-Queue-Id: D730240004
X-Rspam-User: 
X-Stat-Signature: x7k9ioheij8x4s3rzbk39k5wy5cr6onz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786966398-813486
X-HE-Meta: U2FsdGVkX18GxL9qlaL8yLjVxLU0K1xzXI1frcjH2BKVRFwQcA8szvMoExRuJyEhqq6RC8YerszsImNPHff6Y1Lg2dN2vMOdF9xCkWuoLlLV4GAPeMbsmRqbow8eSU5RNfFg5OeBsAb6H2MElJgHn/Y0yo/M6Mc8T7/PIDJ4UdmW9SNOLuO4qibXOAFWtOVV4DHCwPzMYH7OFDiYciFHTIDdNJcxwohHz4WQBASB71ocS7jXZSr+T7MXFlovgA4adsBaJ+sqcfGUbIlUZ3ms6jAxx1HzgYAqbaDFKStYwIV7ox1SSXgI9Gz10lItq3kcRVhd+YCV1q7fbMdv5Bg3qeKI92k8X/1kKFich+cJ1VzOvF/TW1fFT+tQ0BsUKKAkf9L/8GK/ZZI76n8xclLnhtc8xMk0qx6meMFuaq5deGpKzhP//dy43EJlSlzHOcDGWzScN/FaET+v6LhRjajSGHdocH5wE09WzVyaeXTQov9L+At9xAp9brC+jNe2LqswgHHbpsnGRc1o4Xf8ofqjldp8mKGkA9WYm7rbXFgX8ZBKhaHoR9lPWe2hdkrAIlQ00ZLiOLUJzMDr7khqmvD7eDIZxhYT3Zx4ai4JbDB3rRNjlTgAbhIhgu/9DzQDhzX9cAdFsHoaZXaIYST+lzJ7I8YfB7RAgypfz+ko/NlBLb1PIyf1yhwHb390s+4sKYYjNkWorScQYSyHOlN/m3gmgOaBV+s5J+63/6b+fgdxPz9oWTLPbkU3/WStwgjrKZO8eDjAnQwyflfEkHZjBODH0FiUVEZpz6AB4ArxoVfy5FsBDQIVXykbGAUivWCaFWpzwy8lMcDcUf73yes03ACl8GpVn591VPNatSGsEM1By2FZk8NLPMDUiGJk/VhVrwtGsAs30Iwwf8dMsywMGCSPq+R3+XdaLcblOEY9t9Hq2DKOrxzTDzyoIxiMlXxo1K+9cUYAQLqvnfTqGaQij+W
 EcPF5kRE
 5M2URxsF2uTghv8Ep08S8ZFRt+7ej7lguFgDSvWJ67TgHB7PtC6fz5yz5dJDfUhrS1LprHAhq0mCVI8uGHJpYgFl3b2/fAbguIqsAOorW/solHiiSzBYqCbMpQXvHN3PghC6DK6QC/GaV2VX29KL4myb9iSt0mUolyUv5rLXqvvy3VPFza7oooU1h3E3c8Nn9kN5ojnafKcYQ/zfZ8/kj8r6p8YOFvAcI7RoKPKhzyYOJsH9wWXSxJlMxrlhElsiag9cI1M8sxcU7Cs0ze+uWjmEy/+25d7V49wqkrXphggQJcKWZfcF93HbmV91XO/0IfX7/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:34AM -0600, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
>
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

With below addressed nice cleanup so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e26ea97381a..8babd4c97db6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>
> +/*
> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
> + *
> + * Return: true if recent access was observed through either the folio state
> + * or the current PTE mapping.
> + */

As discussed please drop :)

> +static inline bool folio_pte_referenced(struct folio *folio,

Please remove inline, for any sane compiler (i.e. any we reasonably support)
this makes no difference for a static function within a compilation unit.

> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
> +{
> +	/* The folio was referenced previously ... */
> +	if (folio_test_young(folio) || folio_test_referenced(folio))
> +		return true;
> +	/* ... or the PTE mapping was recently used */
> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -810,14 +826,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (folio_test_large(folio))
>  			list_add_tail(&folio->lru, compound_pagelist);
>  next:
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
>  		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		    folio_pte_referenced(folio, vma, addr, pteval))
>  			referenced++;
>  	}
>
> @@ -1766,14 +1776,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			goto out_unmap;
>  		}
>
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
>  		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		    folio_pte_referenced(folio, vma, addr, pteval))
>  			referenced++;
>  	}
>  	if (cc->is_khugepaged &&
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

