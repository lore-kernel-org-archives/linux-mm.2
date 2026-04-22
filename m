Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D64FA1FE6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251DD6B0088; Wed, 22 Apr 2026 14:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202006B0095; Wed, 22 Apr 2026 14:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F13B6B0096; Wed, 22 Apr 2026 14:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F28666B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:53:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A44A58AB58
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:53:31 +0000 (UTC)
X-FDA: 84687090222.08.C6C69C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7537A0011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:53:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwyj0THX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776884009; a=rsa-sha256;
	cv=none;
	b=KPnH9BpZ82Ma1esC8X1Na9TTecfQNQHXxoqi8/p/LNeyuPu0Sqh92I/KBjGc1cDl1OX+tk
	Ec5vDPaJXK2CHpbJvNbdRQvV9fISQ4HXIKvIcD9WOjln0H4AbLi9JIR2Wo6Em75Dd//uOU
	vzdC+0YJAd92IPQLLW2VbCk3MvVWX8U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwyj0THX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776884009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMWkNXGb4uRWkmzx2z4SAVEgWBaOlNb/x8aKLsCCEts=;
	b=7WpEHN56hWdNo54qHVZHscCNf7DNz5oq5YyA78oOe5eWtQi96h1NqDWGnUYsekW3DQ+Qjp
	KP4BeHXqGm4ifYe4O4zHuky0MUK9AdKKUsU3SIfstqWrSrf0IljFtetwTPaqbboIeXXgG3
	9Y9Sb7/Lg5LVeDfmRpHh99zLTF80CCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C00861863;
	Wed, 22 Apr 2026 18:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F09C19425;
	Wed, 22 Apr 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776884009;
	bh=U87fwgfTqFjGiF46tna1zdVOQGR1zoZjFWnweyTJR9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gwyj0THXKUdy3H44NX9JOdYHEuS6oKYDicb8ibWRSEhm2QFkXXBQmuY73naxBVXzh
	 ZMLtsipa6EuMXndPGtanXm4c/6oUg1AAB/biwri480BwAs4d8IcPvMGJ/gkyg2e5E1
	 v0u9w6BJktmtP8w6ZAy4ps2kOR1i9MXkPV8naJCcH6BTvkAkrswbQ7JMJ6L8PkvK5G
	 Mr5P7wVRUUUBbxbywmX26/QySDh6P1ynvwb+Cz9OZw0mnDWr9RtGqv/OnKnFHst6t6
	 HvuvcE9e1FqZKpv5SEG+09xBDD2czYln9zZmhwCV1O2sYJkMEMDALRPDoUseveVIe2
	 9dT4SiIRTcttw==
Message-ID: <168f3ddd-de39-4896-a334-23a6fb8959e8@kernel.org>
Date: Wed, 22 Apr 2026 20:53:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422081420.4009847-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E7537A0011
X-Rspamd-Server: rspam12
X-Stat-Signature: 8ekz1emqho596puyshjhuieqx5s1fdpa
X-Rspam-User: 
X-HE-Tag: 1776884009-402024
X-HE-Meta: U2FsdGVkX18PKrpz/UMundhxoYvXpHvGXB/v5nKWYzgdKyrz/Gp8cnA+otwxTCpaB9NIEUSEcrQOviVDQTJEPmwBLtOQVI0LZ9MQYTYl0a+6yDj7UqcTklOmAXTRjqDN89GW/SSR8u2c07XS4pMJx5U18f4CqCX192JH5gv3ZoTIzSeEbqLdlwfz81uwujlnjhMhk8ZKlACbyIcTKHXHjDgcobnA74f6ayalehFkOeTRmr+BS+KAAv4DhoxM+g4KKgEqEKnREwEzvo+LuZa0bgOJopCnlGxmP2We5/UmnxA3RW5p8cSlUl2kKRezTB63RgEQaBEqXPqEAJlCrw2j/Ine5tUP+EFFxcZcjpJdfE24iWXo77bNAfJydryKiJOdU7M3oHUu38C1/WMU9oDQNVA7tZOWj2WIrhfeBHL3wZS2ncyfyrW9/tLLw5lSNaY4wZALpCDSmSmcg5FdjthpVBWTpBfphwPaQvVai67cOu6l9qrvjnkXWGO2kYucj+XpCfSmI1cFezjTf/YGOMS+IbH/b+DQg75ro2WeLECdidV21P6+t2qxOKxjt7R7JxY2gL4oiUUv7K9JIl0hXPMmP40nAn4GPJpcU0A5EAgRehAWBivNbHRFxy1AgrBh6z0M9PlMNy8Ti0juuHTGRdjfe0nWvLRxTtQMQjjemzz4AI11hwiT5Wg2FtVxBy46ua5Mb4KPk3HHMis1lf6s3lkPqbyHNte1kT1rMNKs6BIAoKUyF5DnXPOWuFHAItmjYyCsd9XEq1FdsoLnq+uG+QhfJ+uJ1w52dJCDLJL+b6CXNEpDQ4z1QcM1eFWj6WkQZswdSpfBjpLvzfdeQFIAYhY0zmz+tVEbTtXLHhvAgQyUm4lauT9WmmXawnGnigxF9cWzE8ObIOz3b8tkFjr/kOiBgSgkIDGzTt/Xw7Wma1ZpOt1ieA4K6SzJNrPm0rikPsLKvioUhgYHzRryYQv/R5w
 d/ASY6P4
 w6XUYNJS6F0ShWNDpvsq01bJx9nhBNnHlLmRCE5iSEt11kI5cJqcbnurt2h7lbTYRwTnQ5D55dqvB2K16qzRaGacPhsq8Z1MIm2o2l3r9MFP/8Hvn2O0lprl/IOmiPekzL6ouT0y6oDtz9QhdF1Ze0FvBoKaVjJJkc01GU99KhR8iO8Oaa+YzT2KrD5E1wk8el4mSnUY3xVJxO+NSVHozoPB2eHzGUDL7lVkIT6ZYI5NjxuoEVwECu7SXfp/96u7YjhMcfGvssUxFh/lcMkAI0Y2pKj201TuRv82EzIGg6NCF9djDiTq6+bouhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:14, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index c208187a4b00..fcc5e0eda9e7 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -652,6 +652,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> +static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,

I'd have called this "section_nr_vmemmap_pages"

> +					   struct vmem_altmap *altmap,
> +					   struct dev_pagemap *pgmap)

Two-tab indent.

> +{
> +	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	unsigned long pages_per_compound = 1L << order;

1UL

Both can be const.

> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound,
> +							PAGES_PER_SECTION)));

Maybe simply

	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));

Which is more readable?


> +	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
> +
> +	if (!vmemmap_can_optimize(altmap, pgmap))
> +		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +
> +	if (order < PFN_SECTION_SHIFT)
> +		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +
> +	if (IS_ALIGNED(pfn, pages_per_compound))
> +		return VMEMMAP_RESERVE_NR;
> +

I'll have to trust you on these ones :)

> +	return 0;
> +}

-- 
Cheers,

David

