Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803C6C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810FC6B008C; Thu, 10 Sep 2026 10:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C23B6B0098; Thu, 10 Sep 2026 10:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D87D6B009D; Thu, 10 Sep 2026 10:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 535366B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:35:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F00841A057B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:35:02 +0000 (UTC)
X-FDA: 85198099644.13.1494D1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4AA0A4000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:35:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oni/6koP";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqJhoyGyHJP6091fs8CPorGbMcEbisH8T+p5PtFRPtQ=;
	b=eIkkJaPfU/vJ581xbjP80Q3lzLrNrzDHLA4FmJTQRrgGncPXXDCkh3hmut6J99i+/JyRKV
	CPl2GXrWVTHa5kWBohBbevp0cfrP/95qk+6qgVx71ZKGG7k6+9p3qaqb84osMk6DInCT5i
	98zex16OxdhxAqhvDLUcENDkXG4nObs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oni/6koP";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050901;
	b=M968eXOELbILP8n9QzpZKIoR+ht9vxUnrHiOWGUphhSK/fEAjHI+7nKY03D7TCgRNT7xL6
	5eeV/qFDBgl2Nc7fkaztx4H6jUMhEIHmvOOhl5O171l7j6lD9WwLMThvhe/4PtHTgY/6x0
	npMQg9GAdPeJGjkM1VHU9tfH4UZJCdA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 719F4415B3;
	Thu, 10 Sep 2026 14:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182601F00893;
	Thu, 10 Sep 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050900;
	bh=yqJhoyGyHJP6091fs8CPorGbMcEbisH8T+p5PtFRPtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oni/6koPplPswfXrbVStzvD8BZnPMK7/76eM+7w6wrqlEmb5xa12DEsFgxA/zTkgU
	 loc/Pa8KbIYCVvhH0SrreuqsAooZJ+A0MmyWanzPVIvVJgoeL6/jxO59IH74sXO55n
	 rYqC2aI1Z0DKoTcmeXrVFHdjTJTzOfJ3nNRTvBx9S51pnj7xHVpg2oUH4BRrAQmQBC
	 +GcQcj7dKvvrvkMBVVmAp27Z6utx8cNPIGqNtPi9MNtz/UJiGVYPpDgMP0m9ijacUv
	 CdI89qXab5ILhisHh4VfSpPjtWJa+u2ea+DkZZHl2CEuIR5NvbytiQ0c9k4+EZO7fN
	 WJCFuP1DPybHA==
Date: Thu, 10 Sep 2026 15:34:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm/sparse: remove flags parameter from
 sparse_init_one_section()
Message-ID: <aqK_yg8L-BbovObs@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-10-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-10-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AA0A4000D
X-Stat-Signature: 9637ufufayjnhbexoeo1g1dt3sxsjuqk
X-Rspam-User: 
X-HE-Tag: 1789050901-261503
X-HE-Meta: U2FsdGVkX1/H6imwRbzfIgClg1PvGrKRQIOGcKdZC1MAbtmOdJ6JrgaUtJLOqWb0FO5kl3MypSbltEgpJP2jXrTvFBXryyaLWXr3ymnWuO+XxI36EYi27hSvDJy+kYz1l2kNWOJAscx+KV/1RKHsy2jnhD9i1ZM8OrOBApVNw2cgvsK36BzbJL1o7b3xca6h/YC1GmWr5VxtL+2lnwa+Hx7XkCkKYoTZfzUFUDldyq6jUb9yaMTIxMu2azjIZF2NgBPMgUPwtrQmSaboZshWescyx8JLtnqQ/OW/iR0FYGxf8WtQpZJW7kEQBadWkSd4fMCQCnaELSKLTmwP2brDr/Sme51JwbM8l20v5Qljwtpf52F5WXacoSEMDZUmwdWvwMYdUSDj7S+nBUcKIW9/OMub4+hUO/4iDSr1BlBxadmmr5XHM53wuZFxZYd2wiSQp++FfnZU2iVdkRv/YVXJ2R6Q/CKZjExj1wXO8PHeiAEim+Yj7E/BRFDdPVH7/dfbrmlTJJXMmkkdyg6m2/XaYbKgb7aT6XuWNY5RSBGeCdJhz3qXwF5oJG+72sSmnMmAwy30SD/pQf/Y3Lf9lQhR3cBMwa9AYLxSDgP0+eemGF+VVXNxD+BAPET/1dkUWMV9m1ZgBJsddbdxuaGY/OB7c1SCelG7reQMOj2WLecWvSbwwFLmlLR17dKQNiBgk9ahWE+hy0Ekvs4jKiJ5pzCu0wkd6u9bb9IJCy2KLTsdb7u91sVEE8js09WO0nHvJGPKzV+laLwd3SUKure9oTmj6GcsXgmLe3r0gn8pltyzNRTVPILY75n86JAJsiUVLQFwmr6yaErmXFBkLNxD0Xq2shHDVeG2Wq3KdelmGoo8hJzoUq7iiz47gPOTHIvt8VjxXaFs9NMFK1qaCzi1T6dlZaA25MPRm522pguq1Hu4RI69UH+pj/NiVB5cKRlMXzTVTL+0XVrAKvjtVb1EObk
 m1Ide9dP
 m8pG5z5YNR25eARClIqcdQyz17AHBcIUbiw7/KbcAA8cvmZIja1aETZCTKJiv9wgiB9DtFBBWdJ9FwxFvYj+bEAdi/Aj2iNiTbB6ls3hZP4fhKytyyTIwz9zIxAhy6/M2TtrTBf4Ol6Yk3NEseogaY3pNzDwUWDuNZsfS2kHUM5MXw7wmABT+o7yZd+lhDU2fBuNqnnUygRUXa+OqGIk4p+YsRg0XASQlxKo8fKi6ktUX+gNg/diEo5gC+y1WX4bw5EhfJ9N2mo+rvxZPUW4lrKLd9yzLuQkR/U0v4vxmyS5FSnOLXec2qkNtP0t0pRvmKhJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:03PM +0200, David Hildenbrand (Arm) wrote:
> Unused, let's remove it.

Might be worth saying because of the changes ;)

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

But this is a nice change, always good to remove params/code if possible... :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


> ---
>  mm/sparse-vmemmap.c | 2 +-
>  mm/sparse.c         | 2 +-
>  mm/sparse.h         | 5 ++---
>  3 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 5aba058df6b67..25d3472972363 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -894,7 +894,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>  	/* Align memmap to section boundary in the subsection case */
>  	if (section_nr_to_pfn(section_nr) != start_pfn)
>  		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
> -	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
> +	sparse_init_one_section(ms, section_nr, memmap, ms->usage);
>
>  	return 0;
>  }
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 344acaaed94db..d2e7c21319e27 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -245,7 +245,7 @@ static void __init sparse_metadata_init_nid(int nid,
>  		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
>  							       NULL, NULL));
>  		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
> -					mem_map, usage, 0);
> +					mem_map, usage);
>  		usage = (void *)usage + mem_section_usage_size();
>  	}
>  }
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 03351f2467e34..f45dd280db6ff 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -91,7 +91,7 @@ int sparse_index_init(unsigned long section_nr, int nid);
>
>  static inline void sparse_init_one_section(struct mem_section *ms,
>  		unsigned long section_nr, struct page *mem_map,
> -		struct mem_section_usage *usage, unsigned long flags)
> +		struct mem_section_usage *usage)
>  {
>  	unsigned long coded_mem_map;
>
> @@ -109,8 +109,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
>
>  	ms->section_mem_map &= ~SECTION_MAP_MASK;
> -	ms->section_mem_map |= coded_mem_map;
> -	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
> +	ms->section_mem_map |= coded_mem_map | SECTION_HAS_MEM_MAP;
>  	ms->usage = usage;
>  }
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

