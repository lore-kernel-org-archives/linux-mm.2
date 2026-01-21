Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990BDC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C694A6B00B4; Wed, 21 Jan 2026 13:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C406F6B00B5; Wed, 21 Jan 2026 13:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B229F6B00B6; Wed, 21 Jan 2026 13:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD8E6B00B4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:44:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A8C6160BCF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:44:21 +0000 (UTC)
X-FDA: 84356846322.16.E673E49
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id ACF1818000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:44:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Yobx9b/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=78Gec1+B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Yobx9b/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=78Gec1+B;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769021059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6ugDYYexV6tlXTntW5lrwN365JGB8kSnp3GfE2NxRw=;
	b=iLKOInHNKE75RXf5EWrZyzYcO/9ZAmnoCXTQ2yBIgmf7ThwUk0YrAS0c0WCzzQFWsFdGpU
	Oqt/kFypV2U72Bzpv+YaRGw2jcmF0K/pTwlBDHccnumK88d4T4qov43504ZwgGPxHSv9ZS
	SswLllSk5PmkioPrePSYZ1wM4RqoIG4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Yobx9b/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=78Gec1+B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Yobx9b/q";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=78Gec1+B;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769021059; a=rsa-sha256;
	cv=none;
	b=Z/qXdBYhZrkTu4R7KySVTuDOKAiLg3FS9JsqMJ2yvjiM0bBT7BYnNXk87nmR0+B0bEMkLC
	HiVIsnsgW7eCVXp+J3vhr4F4vcwlJUvKVu0acntw7pXBk+ypN3/R5CiqekbM7mqWTfdYYa
	hoJT7C9QIKfXGEEgMJ80neJyQ/C2MLE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 90FE4336F7;
	Wed, 21 Jan 2026 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769021056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i6ugDYYexV6tlXTntW5lrwN365JGB8kSnp3GfE2NxRw=;
	b=Yobx9b/qU+2xsltTGpMlbWRHGjIh8/EvBhQoQOErqZTeiSG/4c2u+EnMyOhDWvjvtrc23/
	DhdaQ/aRtGjfbaFpzwHUYt3HOb3ihqB4kqORbAM7EQHrXGVHSR5yzk2upFRMHnM1G/Vm/y
	45cGyh9mn6kwGMqdYIIOXOBCC8TYQu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769021056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i6ugDYYexV6tlXTntW5lrwN365JGB8kSnp3GfE2NxRw=;
	b=78Gec1+B22YqNlEi+i5I6v/CgZgXFbmmGN61w+o4SBoWVoXyZXRpY03i56UNDu99R7Crrv
	KxHEYpNDvI3CHzBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769021056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i6ugDYYexV6tlXTntW5lrwN365JGB8kSnp3GfE2NxRw=;
	b=Yobx9b/qU+2xsltTGpMlbWRHGjIh8/EvBhQoQOErqZTeiSG/4c2u+EnMyOhDWvjvtrc23/
	DhdaQ/aRtGjfbaFpzwHUYt3HOb3ihqB4kqORbAM7EQHrXGVHSR5yzk2upFRMHnM1G/Vm/y
	45cGyh9mn6kwGMqdYIIOXOBCC8TYQu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769021056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i6ugDYYexV6tlXTntW5lrwN365JGB8kSnp3GfE2NxRw=;
	b=78Gec1+B22YqNlEi+i5I6v/CgZgXFbmmGN61w+o4SBoWVoXyZXRpY03i56UNDu99R7Crrv
	KxHEYpNDvI3CHzBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B9B23EA63;
	Wed, 21 Jan 2026 18:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kUnzDIAecWmEZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 18:44:16 +0000
Message-ID: <bc7b8c62-a8b3-4407-a69f-30b3fd269566@suse.cz>
Date: Wed, 21 Jan 2026 19:44:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 00/14] mm: Eliminate fake head pages from vmemmap
 optimization
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260121162253.2216580-1-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: ACF1818000B
X-Rspamd-Server: rspam07
X-Stat-Signature: jd6jjq9o3munzwfjntzcgbs5w6hsou6p
X-HE-Tag: 1769021058-410942
X-HE-Meta: U2FsdGVkX1/LkBRePKSqXSshIJRayEo7HXTA3TErceSxkxraGCjjZo4STWnYvKgthf1Ao1Us06KtpwhuTaa9o23qulq2UZXw0zwkfqMa72bpXbCPRYn/+zGpcNnAhwirIhnsgiSFsb4U1NOnbvG5bCqFJx1VsTPGad9WZ+nSvo2mcJWJVeTmgjsHNskaVqDHKlVYJ2g/6a/fM1n8xTrOcCVAt1ZkMK/I+q4uMWTc7B7o2KS+p3mtLer1D44cKVZCaI59SXOe0NYnLar21FnyJA/sybwqPSD3yAYeIj8n7cmprSVsj7lKBfUfz8uDvtUQpZMu6MONkGyLRq0Ag143C3XL9OXlQIr8hXg9VZVIIVf30bAbbSMBezP7AcF0uyfPcJkeXNHJzcy8PhTX2VDBwJYRlz6vCj/Qs3itJ+bxxSqQr7qBu1laKq+vVuEqmsXEwz3aIvCg3DYMtMQmvTtUcCKuX3+6Ti9c9+GVe1A2zCQazp8cz4AqoMDvmPYYBlkEPuRDghFywhp023Fas0grZZuy2NPx9Zv6cuPVNrioD/ezNpttvsuq6ftdrU7MtbqhPAvGodLk0XN4vJDXEZo45cURS/Wy1BYDaM/TnypWIGEaCmpANoQK6rP3R4KhN6ePsyukZJyS9EOBOykLS250Dgq8T2L7TnHhivc/P9QMGTQ7EzJuTQE8FaQLW2bgTpQVwmXVNJqRcbNjjt1YIiZ+sqJ6u2Ebk+8pDLVbtFVZtMNgMXLXo9tPLTRAY8JbS3ctt1DPr3jPm/VMxEO0uAgNfC4VX4XySTKZYYyuRrOAh2qlGBsNnC8VZtZHqcOMPRMLiVXiIBF2kuycoGxkUIjbe2DEHP3bz9PzZWW0IXhsfQkHutBp9BBlVNfcdM2Gtq10xtKbAxDsB3Ooq8Xto/C4SD4pVSP4eOWy9nKp4KCvsR6+w6pL65cBUx46qebracos4HfpWMX+xv8+/nUNjRW
 HmflTiBs
 Vg5vZaOcxX7/8zZUNqvf+QA4BlGdwBULxVtjVNzH+1i62y6CKgyJ3HbsMjyc8g+rogqPG1ka3hq5sbUymBH8LVpy7pPHDoROz/BbO3LsLm4WxXzID/RxDMx0D22Et08QfAjHl9tnZZJOwOAEhKiV07FeLMzMbUNM5kXlvOPYhE6JVEXIH6y2ymUKeK3bQhahT0TtpNmghtnGJqnlkVB4tbDI5UNzezdEG2mQ57sNwU04GpA2is9bTzWsGrfj85DvO4WuVn+ZPn6GFCOUNxxc6nlbuq26/avvTfb4u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 17:22, Kiryl Shutsemau wrote:
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.

We never got the definitive answer in the previous version discussions
whether it's worth to do this now with the upcoming memdesc stuff, right?

> Background
> ==========
> 
> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> and remapping the freed virtual addresses to a single physical page.
> Previously, all tail page vmemmap entries were remapped to the first
> vmemmap page (containing the head struct page), creating "fake heads" -
> tail pages that appear to have PG_head set when accessed through the
> deduplicated vmemmap.
> 
> This required special handling in compound_head() to detect and work
> around fake heads, adding complexity and overhead to a very hot path.

So a very stupid question, why did we remap everything to the first page,
and not instead create two pages, where the first one would contain the head
and the first batch of tails, and the second one would be used for the rest
of the tails? I'd expect it wouldn't make the memory savings that much
worse, and eliminate most of the issues?

> New Approach
> ============
> 
> For architectures/configs where sizeof(struct page) is a power of 2 (the
> common case), this series changes how position of the head page is encoded
> in the tail pages.
> 
> Instead of storing a pointer to the head page, the ->compound_info
> (renamed from ->compound_head) now stores a mask.
> 
> The mask can be applied to any tail page's virtual address to compute
> the head page address. Critically, all tail pages of the same order now
> have identical compound_info values, regardless of which compound page
> they belong to.
> 
> The key insight is that all tail pages of the same order now have
> identical compound_info values, regardless of which compound page they
> belong to. This allows a single page of tail struct pages to be shared
> across all huge pages of the same order on a NUMA node.
> 
> Benefits
> ========
> 
> 1. Simplified compound_head(): No fake head detection needed, can be
>    implemented in a branchless manner.
> 
> 2. Simplified page_ref_add_unless(): RCU protection removed since there's
>    no race with fake head remapping.
> 
> 3. Cleaner architecture: The shared tail pages are truly read-only and
>    contain valid tail page metadata.
> 
> If sizeof(struct page) is not power-of-2, there are no functional changes.
> HVO is not supported in this configuration.
> 
> I had hoped to see performance improvement, but my testing thus far has
> shown either no change or only a slight improvement within the noise.
> 
> Series Organization
> ===================
> 
> Patch 1: Preparation - move MAX_FOLIO_ORDER to mmzone.h
> Patches 2-4: Refactoring - interface changes, field rename, code movement
> Patch 5: Core change - new mask-based compound_head() encoding
> Patch 6: Correctness fix - page_zonenum() must use head page
> Patch 7: Add memmap alignment check for compound_info_has_mask()
> Patch 8: Refactor vmemmap_walk for new design
> Patch 9: Eliminate fake heads with shared tail pages
> Patches 10-13: Cleanup - remove fake head infrastructure
> Patch 14: Documentation update
> 
> Changes in v4:
> ==============
>   - Fix build issues due to linux/mmzone.h <-> linux/pgtable.h
>     dependency loop by avoiding including linux/pgtable.h into
>     linux/mmzone.h
> 
>   - Rework vmemmap_remap_alloc() interface. (Muchun)
> 
>   - Use &folio->page instead of folio address for optimization
>     target. (Muchun)
> 
> Changes in v3:
> ==============
>   - Fixed error recovery path in vmemmap_remap_free() to pass correct start
>     address for TLB flush. (Muchun)
> 
>   - Wrapped the mask-based compound_info encoding within CONFIG_SPARSEMEM_VMEMMAP
>     check via compound_info_has_mask(). For other memory models, alignment
>     guarantees are harder to verify. (Muchun)
> 
>   - Updated vmemmap_dedup.rst documentation wording: changed "vmemmap_tail
>     shared for the struct hstate" to "A single, per-node page frame shared
>     among all hugepages of the same size". (Muchun)
> 
>   - Fixed build error with MAX_FOLIO_ORDER expanding to undefined PUD_ORDER
>     in certain configurations. (kernel test robot)
> 
> Changes in v2:
> ==============
> 
> - Handle boot-allocated huge pages correctly. (Frank)
> 
> - Changed from per-hstate vmemmap_tail to per-node vmemmap_tails[] array
>   in pglist_data. (Muchun)
> 
> - Added spin_lock(&hugetlb_lock) protection in vmemmap_get_tail() to fix
>   a race condition where two threads could both allocate tail pages.
>   The losing thread now properly frees its allocated page. (Usama)
> 
> - Add warning if memmap is not aligned to MAX_FOLIO_SIZE, which is
>   required for the mask approach. (Muchun)
> 
> - Make page_zonenum() use head page - correctness fix since shared
>   tail pages cannot have valid zone information. (Muchun)
> 
> - Added 'const' qualifier to head parameter in set_compound_head() and
>   prep_compound_tail(). (Usama)
> 
> - Updated commit messages.
> 
> Kiryl Shutsemau (14):
>   mm: Move MAX_FOLIO_ORDER definition to mmzone.h
>   mm: Change the interface of prep_compound_tail()
>   mm: Rename the 'compound_head' field in the 'struct page' to
>     'compound_info'
>   mm: Move set/clear_compound_head() next to compound_head()
>   mm: Rework compound_head() for power-of-2 sizeof(struct page)
>   mm: Make page_zonenum() use head page
>   mm/sparse: Check memmap alignment for compound_info_has_mask()
>   mm/hugetlb: Refactor code around vmemmap_walk
>   mm/hugetlb: Remove fake head pages
>   mm: Drop fake head checks
>   hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
>   mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
>   mm: Remove the branch from compound_head()
>   hugetlb: Update vmemmap_dedup.rst
> 
>  .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
>  Documentation/mm/vmemmap_dedup.rst            |  62 ++--
>  include/linux/mm.h                            |  31 --
>  include/linux/mm_types.h                      |  20 +-
>  include/linux/mmzone.h                        |  47 +++
>  include/linux/page-flags.h                    | 167 +++++-----
>  include/linux/page_ref.h                      |   8 +-
>  include/linux/types.h                         |   2 +-
>  kernel/vmcore_info.c                          |   2 +-
>  mm/hugetlb.c                                  |   8 +-
>  mm/hugetlb_vmemmap.c                          | 300 ++++++++----------
>  mm/internal.h                                 |  12 +-
>  mm/mm_init.c                                  |   2 +-
>  mm/page_alloc.c                               |   4 +-
>  mm/slab.h                                     |   2 +-
>  mm/sparse-vmemmap.c                           |  44 ++-
>  mm/sparse.c                                   |   5 +
>  mm/util.c                                     |  16 +-
>  18 files changed, 369 insertions(+), 365 deletions(-)
> 


