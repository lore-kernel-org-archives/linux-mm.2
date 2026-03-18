Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF179FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346C46B0127; Wed, 18 Mar 2026 04:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DD46B0129; Wed, 18 Mar 2026 04:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B8C6B012A; Wed, 18 Mar 2026 04:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15A626B0127
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:21:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B20921D360
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:21:07 +0000 (UTC)
X-FDA: 84558488574.05.A859698
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2E6AC40011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:21:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dopbr9ya;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNio4ocBHgQ4v2WEdI1XT3k/LjRB8Ux8VLQ82Nh0FmY=;
	b=mjyR7QjGH6JbeIdrKx3tcILHE56cxIUo4e6JyYJX2+mPdgR5ziLKPXdm1YUtEeJO/R4CpE
	BUR8vOKvs5P6/4am6FCmDwGYgib5GFpWOxeummWE1ASY0BRYIkjDT9evfRUvfGYfNBsMd5
	crM047M7XVUqhl2TEmb44Nfhd85GYT0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dopbr9ya;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773822066; a=rsa-sha256;
	cv=none;
	b=USIbeo94OuElUcGP7TrwpRH+2B1x00dfwiPgO3NB48u8VSp8Ulm0ZAdzVQL4fil4GaSOfY
	lWk5Y+M0gj9SyhRdpR4a5tkjplLZZX3zTUfPfZWOw1LHFm0vYCAgI7TngkHZOvJkD+jE2h
	o7WYeNWmt02pGQP4H8tf/5KS0rIb+Uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABBF2600AE;
	Wed, 18 Mar 2026 08:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209E8C19421;
	Wed, 18 Mar 2026 08:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773822065;
	bh=EA79S28YVeZYHQpiP11IUWT/puy5gsehhvHI39K5RCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dopbr9yafQgjd3ZiDSZBGn/mrAXnmFXRG0L6C4WtOtDytHn3DWBdmF6Yn8Mb7Yxl0
	 Ulwn3CljS3CGdFVb0E46PE1tphGRF6X0dV6JP45JIvTBuFdX7043OZKOgisLM7Nw65
	 vBUyo5nIeT/oKBeASofgIeXFwhVo7Zphn/Kvn9jECbGCGcFM/4ILQm8/XEGMs1/MYY
	 yfB1kz+TUiMTsP8cH+KOvkBB7472VS8/1FEfJCvIsydVdViqkiK0PmcF216+iWLf2k
	 89atoDsTCZVmnzV/XgzPCJVvcWLEb+VaA5IQGFHZ25s6FteU3fFl3606PSa2MXOsoG
	 ihSq7wogzqhRw==
Date: Wed, 18 Mar 2026 10:20:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 08/14] mm/sparse: remove sparse_decode_mem_map()
Message-ID: <abpgagKxOP7klxWC@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-9-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-9-david@kernel.org>
X-Rspamd-Queue-Id: 2E6AC40011
X-Stat-Signature: cejdfdhrxhtfpwjfk1qs4zs6y99rb5fg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773822065-87646
X-HE-Meta: U2FsdGVkX18IX1AZ+l+tbuSFXHMnUcLPNJ4PTVf6qO8NVtIrC6MovSYm3sOgCI1bTnO8aIooS95Ig+3wBFf15qM7Ln0i0/um4VbPlUeEUpKw4BZbG1XWeg6BZSXt4AQIBmwUcRcl9KIsZU0a2kvrSx/V/1myo0t8lvUI9BrBGr0lfdvwN0qr9ZONXTQPDXKpzA0W/KtRf6Ok8I2hPSFqlb2SgW61oV8BOsDveUIPztLpTh9DVodXPLoP6da5NLjXjEm52pNUC4LnwJIAD1QEjTWq2U/ku8ozN2HUqoPZEXtLFo1nTiNXyqjHs6ZVl1Pqf28uYCJeZGE18SNR4qi/OeeHgRH1zWqZ/nPjuzTR741Gt54/cDQYuSjpnUwKwCbfV670bknlv1Sowqk2mDlL3m6jcPyRfzhhM6zj0B/T+nu+e1H3rxgyZisGg8V81HB1lMORKgn6T4tLbl2dg7xyKSqAnhpt2ZqTm2GyzLrRTdW3YTcgew2T5o/9coO29CXwbbUVtowCr/9yVn7TPONkTU5vGAW0/iuK4FY0te13Dw3hZieGEgNtt9DbZvbKTP11EeGdlBCAEg0xUcMEIcoSf7xm5hlxm3lX86nQmazaiTWhOdYpJrnu/Wpeh4JR/44umxQ5dI4OXDUrPyyVHfyEub/3ko3ZL1zutZrk7psXjeVgmeqyAeQiyns5kf0k5FnQYz3EknB45prjaBvefLvkLyeTiwc7EzHPHm++AvYxKWdzKQGxQl79gt+tbKk/J+JtIHBNIY/ekvgiB6LK2pjXTq3djV2z4fkKM2rbtAPfhi+18bwCRdA7K7LuWtcFQFGdY/83pZGYq1sYsLV6IDqcHRZOon32PLV5ulFTcgoN4NPWROALtNeamvO4iAz0251Rra+FHwDqx/wgdLfvwkxiS8zwEgZVAn24bjgSVhYOXpE+WwNSVQNggUFIdVnNT/+woD8/N7gV6E9vfi3/Bjl
 h+M7/q6Q
 kRttgON3X/WCelYTHly5+eJ/Nyf9mg/FxbKHVe0HYH3W3+7gIzumqk7nn7764dU01cWtg6sYkf7Lg0hyrAeCaDdAfCi+vga/CNRgWE139ywW/vd8pUs9B42sbHYBz/7StHp4/Vb1OitLLiT7j45nivRLoGnW4i0MFulCb6/rJaD/VNwHdWpOvpwvCF3GISdoRoR/nWBYQCskwL5dHFYvhvGx3U3L2DC761K0n3WaX5fbLmGxuqjJqumWKDx8aI/g3Jxf0kgW13GaBnGdmC70qV7/0T7uL2/uINmIpIih/2l/xazjtTmYfTuCD+fs1tpYsYDpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:46PM +0100, David Hildenbrand (Arm) wrote:
> section_deactivate() applies to CONFIG_SPARSEMEM_VMEMMAP only. So we can
> just use pfn_to_page() (after making sure we have the start PFN of the
> section), and remove sparse_decode_mem_map().
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memory_hotplug.h |  2 --
>  mm/sparse.c                    | 16 +---------------
>  2 files changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index e77ef3d7ff73..815e908c4135 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -308,8 +308,6 @@ extern int sparse_add_section(int nid, unsigned long pfn,
>  		struct dev_pagemap *pgmap);
>  extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
>  				  struct vmem_altmap *altmap);
> -extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
> -					  unsigned long pnum);
>  extern struct zone *zone_for_pfn_range(enum mmop online_type,
>  		int nid, struct memory_group *group, unsigned long start_pfn,
>  		unsigned long nr_pages);
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 636a4a0f1199..2a1f662245bc 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -274,18 +274,6 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
>  	return coded_mem_map;
>  }
>  
> -#ifdef CONFIG_MEMORY_HOTPLUG
> -/*
> - * Decode mem_map from the coded memmap
> - */
> -struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
> -{
> -	/* mask off the extra low bits of information */
> -	coded_mem_map &= SECTION_MAP_MASK;
> -	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
> -}
> -#endif /* CONFIG_MEMORY_HOTPLUG */
> -
>  static void __meminit sparse_init_one_section(struct mem_section *ms,
>  		unsigned long pnum, struct page *mem_map,
>  		struct mem_section_usage *usage, unsigned long flags)
> @@ -758,8 +746,6 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  
>  	empty = is_subsection_map_empty(ms);
>  	if (empty) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -
>  		/*
>  		 * Mark the section invalid so that valid_section()
>  		 * return false. This prevents code from dereferencing
> @@ -778,7 +764,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  			kfree_rcu(ms->usage, rcu);
>  			WRITE_ONCE(ms->usage, NULL);
>  		}
> -		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> +		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
>  	}
>  
>  	/*
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

