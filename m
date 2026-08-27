Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD686C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CDE6B0098; Thu, 27 Aug 2026 12:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4AC6B0099; Thu, 27 Aug 2026 12:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FAB06B009B; Thu, 27 Aug 2026 12:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 772B46B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:00:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D439C0485
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:00:44 +0000 (UTC)
X-FDA: 85147512408.27.335AA00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1DFE3180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:00:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6PLoF46;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787846442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrlTIkFE6/b+AXgWzKleN3cfwGZ9PDfL2MFZp1jZv4Q=;
	b=cMU1D5p2QznX7Kjq8CQ9H3F+nuCmnJ32MR+nLhmZd76VJcdZzU8AlO3TJIyflEsbhA9jzu
	LQqGHtvg3XFrsOQ0D3P9siLEFDTL8UoR+sRU8ARuOt784eHZ709CXvg9+PSXkRCDKsSs6T
	nXXXjUJu6Dey2s/TvBT1DgM7s++qQiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787846442;
	b=jNELQwvJXs99AVKoyNpg/4nmhyWrovQEnxDP+pSOujJgXqEV//aXux9wDaIPK3PG0y2Pfn
	oCsi+6APrRIFty2HO9oUIDC+a/edSDnzOXLsMGLAk+5bOGpW0BfpczrwmAHwN0KnoJ8WXL
	1uq/KJVB9MsFhd8AUbQoLTo4BeR02QQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6PLoF46;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B86A43CFC;
	Thu, 27 Aug 2026 16:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F31F00A3A;
	Thu, 27 Aug 2026 16:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846441;
	bh=nrlTIkFE6/b+AXgWzKleN3cfwGZ9PDfL2MFZp1jZv4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V6PLoF46F//II/OdhzDITrpykl+/+mbZDkIJ1ZNNRSekUZU6bmwIaBJz56zGOZ/5Y
	 ne5bquWchpCIPzExXuryY1wCxc1k+4iAzhulroW5fLso0mWRAl/D3RIFffydZ7ZRna
	 b6DU9tM3u0SIIzy/L59PsuwrCKZNt4nre6bTiCdLuE6Nubbah45+V0trbyJEjkOAmw
	 HWK5BHRHASZrz+MJT51IXZSsuraIa6Z1WMePep8glLJ/qkqX6Ta/eg1dOXyhtP0Wf6
	 Tchx9Mcl3qJwc20YDL5y8vjEEl/JnjlK+NFIkuLCdPlbRSi2LtlVgfUuIMS3wqCYpR
	 5EwP0YrjgL9wA==
Message-ID: <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
Date: Thu, 27 Aug 2026 18:00:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DFE3180009
X-Stat-Signature: cgzuuafbcyyyj5pfuti3tziqg15ujwyb
X-HE-Tag: 1787846441-27582
X-HE-Meta: U2FsdGVkX19qqgzHQCdr888Brlyf0j8mxr7InPy7S9YKwRNVYqG/JYqLyyhBnCbtYF2Xnk3VF5pf3RJe4BlEmeJuRQk6PO5wDAev88xCcmA90FFjB3DiB7dRgyrEYb3QE5wxlaItarUkOrPCp/3LjqmJ2B8ql9Cc2qPFV4KNynfkadDh2uIX7Ty3qa1A8kIoCimQtJQ7Vz450mAvS5GOB8XGm/oTTssjkZWaEZCTpSCPesGBzPik6O3hglUMxyVwsePs2xzMKPL8siEYY3e4tLyNO9fpgpoR+kx0XELlD/YGuJ2A7PgHUAtUTUZojiCQ0emzshoDB3oJ2QRBz2XLyadZNkGrzfYJv67Ri/Ozil83XYXE9JeEmEwy1Acs3cQaiofATdbTezs/X0w0glnMlSOQZIx2YQISWZVGYy9xMEjW9lpLNqZmwIIHwLFPzVvhrcRo1I33qNGQd2lJUca6kpnXooUQZC7wkWkDn/0zXVFgAASZeUcUOVkUPI2X+6lLJaDhUct2MiQ8Tf7KaCJMqwkw62HG+LM3mHe8pyls2Awz1EwNWJxokJXMxegpLpOaXvRA8eMXipjJoz/vysSxvcHZjSmu0DidMhkTN7ACu2eoT0OkepE5DO3SxxuIIDt6U1FwcIfAfbPA53u2wLu2ZMDz+Y/580ecTwpGye2gBzNF6b9T32WXtoprF1f7q8K/9xZqoUBaTQ6JHEVH7XuoLn5jqxbZsRMJjMjLCzb9Zzf5byX4GvsO5KpRZ9Nt+GbX1MJOT/z+nkEj5fSm6sTY75TmzqPNbFXFgZrOUeCpH3qesNAN1fq17qrYfhf7dUOo49JEK7WBbIHEoCzhTIDXCk9RQNuFS6AmIc/2OckyY4h3eMdNzOW2dDTAf1wiJg/Uzn9RO58GnFA8cnU3noVysdmvKT89v67qAW0tOrX8Pt5WrvFqXlXycm8RFYpumVomcntIpU09gx9kHDtJO7z
 jlVtmvsE
 JggHXTLUwHrErQk6pQYyEdu/0XPIdQuQ4Zx5x5ZSjdkm/NHoj05Psv7qarykORUYvY+40SHCPixxJECUeQQBJzvip1YVZordzflOxF3/V1ozxvuRjw6qFMmHq0PtAgRnZKYIx/jT+3IKaUeFrkSsZhgJOQHP8BAQl5w8dwCaLrN60OeWvV+nPxNerbzJvy+Eg9NpNzm5yKcaW6S9TaLFTt2fGTtCex951NPYNAE2zIoYOSZTRCM7Jhi9dPg/KGrJaVH/qv4xXPf6jnJKxidzH8LuBiiyMm767tPjtWJo/NEEAINqD3CZhDDaWfe2E9bDtWtsnFS0u/CpEmwl4gi38wIZVBYKjOr2Juv7n9JyGtyPJ70UQcV+Mw1YHS5o/2OqWNOsP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> A folio in the swap cache cannot be split if it has a mapping (shmem).
> The split code does a defensive check for this in
> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> rejects the split and returns -EINVAL without unfreezing the folio or
> restoring the counters. That error path is buggy: if it is ever taken,
> it leaves the folio frozen and stuck, skews the counters, and fires
> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
> 
> Check for this case up front in folio_check_splittable and return
> -EBUSY before any state is modified, so the split routine always backs
> out cleanly.
> 
> Also fix a bracket style issue that checkpatch.pl keeps complaining
> about.
> 
> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..a6759a14e057 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  			   enum split_type split_type)
>  {
> +	bool is_anon = folio_test_anon(folio);
> +	bool is_swapcache = folio_test_swapcache(folio);

Both const please.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

