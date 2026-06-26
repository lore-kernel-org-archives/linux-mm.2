Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2878C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A696B0005; Fri, 26 Jun 2026 09:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C015F6B0088; Fri, 26 Jun 2026 09:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC0D6B008A; Fri, 26 Jun 2026 09:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 848916B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:33:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD373A047D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:32:59 +0000 (UTC)
X-FDA: 84922154478.29.3EC224A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 190C6100012
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:32:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KknXDcpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782480778;
	b=ZNLSrF4Ae+/QQC1NWwDd2oqKX0IGz/SKDm0YV3DQMKo56lfJ133jXkwsNZuBP3pu18S9FU
	/SPoTvA0NXhrhFCtfDAfDzoF5F8xdD0TwfnsS6V3nK8rb9PiEi1XA/zNgPwc6A4abUaZuC
	WckkSb+kVOv85htG6tCc7ZuadMbxsSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaO137k9ESePU7sdwWcBSv4s5Zn0qfvXRZJyXbKdsxk=;
	b=HrKZvD4tnCfCxJxk8qVw1BbB+2d0QsmNHRdiztRZLj3p5Kr46CeFGwyQ6aA4eAPf/UAGaQ
	YcVmHM7npYL6Z9GKiBf6MvaM+PbL/lpcLfN4jK+RaiEEkiMrTi9pW5zHdRfzFYagbsEnrB
	VbrC3jaTZy2bLimtLQPSPG0yr4R7mT0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KknXDcpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75257600C8;
	Fri, 26 Jun 2026 13:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A8E1F000E9;
	Fri, 26 Jun 2026 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782480777;
	bh=HaO137k9ESePU7sdwWcBSv4s5Zn0qfvXRZJyXbKdsxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KknXDcpT9qDP0G0ctdgx/f7jWR4NYYFILzHGGLDUp9d5j3dZmjrR+DAOk11Fc1D20
	 TPlzFdyeb/hQV3C8nilEN2WYaElBwWO7R9BrRjq6w50YxjmcB/fvzo0Apa5p+lo7Ua
	 1z9jdKNWp8AD7AF3sYRO9RwFNcFE43nTWt9GIPaSBBJ7LUgE4pM2uO0IswJL849z0w
	 Kw9PfegouqFgUx72igUN4/W/etJqVOapFsIettiQOuvGd+Df6B4wjNsa2CTzS+meha
	 rmf1ttXrVCiE8SCwKRgJce4zedUXJ7W34Rj0NG89Pxk22fA0cA6ceaYSiPiRQmAujz
	 BW5Cizw/KTTgg==
Date: Fri, 26 Jun 2026 14:32:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org, 
	vbabka@kernel.org, harry@kernel.org, jannh@google.com, sj@kernel.org, 
	balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <aj5_ckeeiyLvB8k9@lucifer>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <aj5XVwsQ4rOLTzr5@lucifer>
 <f9290e0c-0841-4b02-baf7-8f03c4cf800e@kernel.org>
 <7AB41DDE-42E4-4EDE-87B8-CF47BE0C6DD1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7AB41DDE-42E4-4EDE-87B8-CF47BE0C6DD1@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 190C6100012
X-Stat-Signature: 7y8grrxbfwyxhq1y7cp9a5ohcfie5mw9
X-HE-Tag: 1782480777-156531
X-HE-Meta: U2FsdGVkX18Y+8C6AqvUQ5btZQUzSlwwEhoj3bn869Q4zO9c0Ee/kQjvZIHpjapDMvgVtbxX9AB3N8VjnA0Xm0jHXRU7izEqSL0Rq7f14QV129SVwEQ6qqDFQwmIqi4ljwscT+W68IC1H4+bmHuRRSxtGdQFfcraWDTjtdN6rqBiBJREZ0xnRJRY+jKYzS+h9+O0Dl5wg+fGRChBQh8En/9z8Fqaja2pO/+fhWCinkXorB5LpXyX6Qv1HD1lzYB9V4nwCa8xtFnurSWWakJTfK4al5pnBtDaZ3x4KoYDlPcQthSQVmkBrFbvLT8EebUcy+zbVNmNQjkf2FikF6Ftfk9gaJkBPnQYiGW/h87kxKpW/qzHNaxEEEnXmiyWcVMu5sKcKxGgi4vziq9GZWC17Wh3BXlTF5PlNeNQttBPnfvfjkInR6LzCOmZsKb+1R1sbzXNY0gxPk3TN5+xCimTZsh7Zb4p/OAODAAIxjRpXjEPCI51AgLFKq8BnLd4bbepj+GNE+YhuRSPAfua0ALqP/eW6OTByrh8cQoiYCvNlxT+mNQz8/ursTKkTWObukdTiTML3ECK+eDK6JH0/qWlZNF0XTNQhEoeksDwK63SGqle5fzXhxroJ1NurHysAAa9tEPV+zpd3uRNIDgrVQvALm+Z97j6wr+o8mLWiULHiA71fZnz+nvN8bY46ekI/lxcNPIszBSwvRr/e1158gF3HybdUl0ME//Iuc0uKUx5ghiPTVCWLLqw5ZMUnY5Uj/q1Sx48gupjzQrpMI1vaP1NhLkKEW6XjWncIj4XvAb0P2BMO9A0bQK3vjgWIvEo6lNmVktNcIhpIQXIC+o4awYALfjASQXkHM2UgJl3ANgm2Hi1Fy/JatyjybWs5TlEiKWp8XUEfr0U8h/VHvQMlqG4b+8fRrlufME5P/2yvMzlGhfb50K55KTZXPSyZXComVqb35ZimomFEJVd0LV5cJB
 /PUchP3i
 yQPlJ0n/ojtVazm7JyeSddrshZNlI/chOaC0ZYzQ1PAN/a/4vuZPz1lNCgjQVitXJzH8u5Qm1hGiXDaY/1cn1CSlz9ZmXy7sqluyZ+FtD68n/eNjrhFyG9ELdfPSHJLVXwa8RTNXrG1alV2wWoxtlnscffHInbCbKTXcVeCRKpt/V9A3hvtVN/F5XitGs+RGELARTxH7iVLTbAFHiZmkTbV/Rxhz66JGkKGGnn+F02mNXVcDtfmY793n+uJXrhBHQ+vLplg9N+Bor8V9mkpPqP3m3Sb6JemnDci1t0S+dTFluYpkZXwvOV6p21pqUEzU2ALPZ36Q3DSTCY9g8ZEEGLQh8NGuHey5lMpUuMHy0ykRZo4ntoxABRD7HKNBzXOkiWdkzlbHGHAzPbIgYT/+XMPyoef32nYtegRdzs+WMYQUrQDjNFNCyATq/4nfwDH3u5z/LAdfSDVt8q7jDACIqPv7JUmQ9pXHF9D6vHk2eO5kmhxvvRYV/CBrKnP+6nYOA80ac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 09:24:06AM -0400, Zi Yan wrote:
> On 26 Jun 2026, at 7:31, David Hildenbrand (Arm) wrote:
> 
> > On 6/26/26 12:42, Lorenzo Stoakes wrote:
> >> On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
> >>> On 6/24/26 08:53, Wei Yang wrote:
> >>>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> >>>> device-private entries") introduced the concept of device-private
> >>>> PMD entries, but did not correctly update the rmap walk code to
> >>>> account for them.
> >>>>
> >>>> As a result, when page_vma_mapped_walk() encounters device-private
> >>>> PMD entries, it takes no action other than to acquire the PMD lock
> >>>> and exit.
> >>>>
> >>>> However this is highly problematic for two reasons - firstly,
> >>>> device private entries possess a PFN so check_pmd() needs to be
> >>>> called to ensure an overlapping PFN range.
> >>>>
> >>>> Secondly, and more importantly, if PVMW_MIGRATION is set the
> >>>> caller assumes the returned entry is a migration entry, resulting
> >>>> in memory corruption when the caller tries to interpret the device
> >>>> private entry as such.
> >>>>
> >>>> In addition, commit 146287290023 ("mm/huge_memory: implement
> >>>> device-private THP splitting") allowed device private PMDs to be
> >>>> split like THP mappings, but again did not update this code path.
> >>>>
> >>>> As a result, we might race a PMD split prior to acquiring the PMD
> >>>> lock.
> >>>>
> >>>> This patch addresses all of these issues by invoking check_pmd(),
> >>>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
> >>>> us we do for PMD THP and migration entries.
> >>>>
> >>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> >>>> Cc: <stable@vger.kernel.org>
> >>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>>> Suggested-by: David Hildenbrand <david@kernel.org>
> >>>> Cc: David Hildenbrand <david@kernel.org>
> >>>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>>> Cc: SeongJae Park <sj@kernel.org>
> >>>> Cc: Zi Yan <ziy@nvidia.com>
> >>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
> >>>> Cc: Lance Yang <lance.yang@linux.dev>
> >>>>
> >>>> ---
> >>>> v4:
> >>>>   * refine subject and commit log based on Lorenzo's suggestion
> >>>>   * put pmd device-private entry handling in its own if branch,
> >>>>     suggested by Lorenzo
> >>>>
> >>>> v3:
> >>>>   * remove cleanup part, only fix the issue for device-private entry
> >>>>   * refine user effect description based on Lorenzo's suggestion
> >>>>
> >>>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
> >>>>   * specify the possible error case of current code and user visible effect
> >>>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
> >>>>
> >>>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> >>>> ---
> >>>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
> >>>>  1 file changed, 15 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> >>>> index 2ccbabfb2cc1..17dff8aab9f9 100644
> >>>> --- a/mm/page_vma_mapped.c
> >>>> +++ b/mm/page_vma_mapped.c
> >>>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >>>>  			/* THP pmd was split under us: handle on pte level */
> >>>>  			spin_unlock(pvmw->ptl);
> >>>>  			pvmw->ptl = NULL;
> >>>> -		} else if (!pmd_present(pmde)) {
> >>>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> >>>> +		} else if (pmd_is_device_private_entry(pmde)) {
> >>>> +			softleaf_t entry;
> >>>> +
> >>>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> >>>> +			pmde = *pvmw->pmd;
> >>>> +			entry = softleaf_from_pmd(pmde);
> >>>>
> >>>> -			if (softleaf_is_device_private(entry)) {
> >>>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> >>>> +			if (likely(softleaf_is_device_private(entry))) {
> >>>> +				if (pvmw->flags & PVMW_MIGRATION)
> >>>> +					return not_found(pvmw);
> >>>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> >>>> +					return not_found(pvmw);
> >>>>  				return true;
> >>>>  			}
> >>>> -
> >>>> +			/* device-private pmd was split under us: handle on pte level */
> >>>> +			spin_unlock(pvmw->ptl);
> >>>> +			pvmw->ptl = NULL;
> >>>> +		} else if (!pmd_present(pmde)) {
> >>>>  			if ((pvmw->flags & PVMW_SYNC) &&
> >>>>  			    thp_vma_suitable_order(vma, pvmw->address,
> >>>>  						   PMD_ORDER) &&
> >>>
> >>> This is extremely hard to review given the existing crap handling here. I'm
> >>> really sorry, but it makes my head hurt (I'm not kidding :) ).
> >>>
> >>> It's completely unclear why we only have to check for a subset of the cases
> >>> after taking the lock.
> >>>
> >>> Could we simply extend the existing migration pmd handling and leave the
> >>> !pmd_present() case for pmd_none()?
> >>>
> >>> That leaves no question to "which transitions are actually allowed", including
> >>> "could we accidentally assume something is a page table when really it isn't".
> >>>
> >>>
> >>> So what about something like the following?
> >>>
> >>> The "thp_migration_supported()" is not required when checking for
> >>> pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
> >>>
> >>> Untested:
> >>>
> >>>
> >>> From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
> >>> From: "David Hildenbrand (Arm)" <david@kernel.org>
> >>> Date: Fri, 26 Jun 2026 12:03:40 +0200
> >>> Subject: [PATCH] tmp
> >>>
> >>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> ---
> >>>  mm/page_vma_mapped.c | 29 +++++++++++++++++------------
> >>>  1 file changed, 17 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> >>> index 2ccbabfb2cc17..ed2a23a90e8dd 100644
> >>> --- a/mm/page_vma_mapped.c
> >>> +++ b/mm/page_vma_mapped.c
> >>> @@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >>>  		 */
> >>>  		pmde = pmdp_get_lockless(pvmw->pmd);
> >>>
> >>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
> >>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> >>> +		    pmd_is_device_private_entry(pmde)) {
> >>>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> >>>  			pmde = *pvmw->pmd;
> >>> -			if (!pmd_present(pmde)) {
> >>> +			if (pmd_is_migration_entry(pmde)) {
> >>>  				softleaf_t entry;
> >>>
> >>> -				if (!thp_migration_supported() ||
> >>
> >> Do we care about this? Or is !tmp_migration_supported() -> implies you
> >> wouldn't see a migration entry here anyway?
> >
> > Yeah, I noted above
> >
> > "The "thp_migration_supported()" is not required when checking for
> > pmd_is_migration_entry(), as that defaults to "false" when not compiled in."
> >
> > Given that
> >
> > tmp_migration_supported() -> IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);$
> >
> > And
> >
> > pmd_is_migration_entry() -> softleaf_is_migration(softleaf_from_pmd(pmd));
> >
> > whereby softleaf_from_pmd() only returns something non-none for
> > CONFIG_ARCH_ENABLE_THP_MIGRATION.
> >
> >>
> >> Maybe worth a VM_WARN_ON_ONCE()?
> >
> > I think it was primarily a a hack to slightly optimize code generated for
> > !CONFIG_ARCH_ENABLE_THP_MIGRATION, not really something for correctness as it seems.
> >
> > So I think we can safely drop it. :)
> 
> thp_migration_supported() here is legacy code[1] from v4.14 when I added
> the THP migration support. IIRC, the purpose was to avoid checking
> PMD migration entry if the support is not enabled, but looking at it again
> today, that thp_migration_supported() is unnecessary since
> is_migration_entry(pmd_to_swp_entry(*pvmw->pmd)) returns false if
> !CONFIG_ARCH_ENABLE_THP_MIGRATION.
> 
> [1] https://elixir.bootlin.com/linux/v4.14/source/mm/page_vma_mapped.c#L157

Thanks guys, let's drop it then!

> 
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

