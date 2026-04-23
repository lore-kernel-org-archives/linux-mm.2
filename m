Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF52BFDEE28
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB096B0088; Thu, 23 Apr 2026 19:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C5E6B008A; Thu, 23 Apr 2026 19:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4956B008C; Thu, 23 Apr 2026 19:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC68E6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:38:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75FA8A0611
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:38:24 +0000 (UTC)
X-FDA: 84691436928.21.4352ABF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0A6C1C0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:38:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ur5+oKf5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776987502; a=rsa-sha256;
	cv=none;
	b=SXNmOMHaCQigOhC5eCuaKymMCkpsEB9QT+Vo0KbqcbYWIEl1v6cCAO47peFYGqmSqdP/TH
	ff1f/VkgF0F7Ad0wJgFTxF069892t+WymtFmBdPyma9s7cJdDKU18HkF081SgFPSXbr0E/
	bsY7hOfqq6YCBfFyl64B6bViD0pUDes=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ur5+oKf5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776987502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiJvIwJhZcsDA7qVIi02suylcG9PDqq5tTpCpeZq8kc=;
	b=g9l2D/pilLIfthBEqkzrR9rnB9+uIrLZR7bhwkh/tOZanAv7lKbX8kl1tafCXEZZjpDLEG
	6CCZANSn2YUdsvVlL4IdTMUX2i9OisKpnhpMqQ68DbO5dsdT7xgCiMlwK4w0fr1ka2ZnGC
	QP8hRpudMBsfqSl6B5KkQu4/RGD3KUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E0384332C;
	Thu, 23 Apr 2026 23:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A10C2BCAF;
	Thu, 23 Apr 2026 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776987501;
	bh=m87qmd7Z7VaIUVFoNxdf2avdmQw/zQ+LpBXrHU3kp3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ur5+oKf5omajvu4YTf4FQLfJpFR7xWxwrKvdnuS6jTpwApmMfG/zUCz7pTF1gdkHq
	 EDd3QWmhLxHPGclw5caWcxpq8S9oZC003AqYOb4pj8tDoNiVotVcyaMxyd01Y/+BWH
	 vpykZTPIqeo5syvHkBnrgJtvqVImkYnH/H4ZXw33xkch4F9Af+N1wVRk5EidtAwXPl
	 cvEojTI8NOTZzK4UFmVPpkNUpjcJd7uLcZkSR9KcP0ECZdrfyGontr+eA0W+0LCs+G
	 ouvortnDt7jiSXxzb8F8NcPgzaYJ4hc1RkSXuRsqmKE2uR0hqm9+fBy2q61lqiZqXE
	 rjjeh4jG8sOcA==
Date: Thu, 23 Apr 2026 16:38:19 -0700
From: Minchan Kim <minchan@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <aeqta5Uqta0uw_eE@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <b6a6eead-cfd2-4459-9c6d-384dc6cd72d8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a6eead-cfd2-4459-9c6d-384dc6cd72d8@linux.alibaba.com>
X-Rspamd-Queue-Id: C0A6C1C0002
X-Rspamd-Server: rspam12
X-Stat-Signature: 1ce57gn8rgoaxr3hjqcjjft3188ke9fu
X-Rspam-User: 
X-HE-Tag: 1776987502-23964
X-HE-Meta: U2FsdGVkX1+C7DSIyiL2AR4TD1R+2Q5KPs17pR6c5KEDFXD222j6FtUc0r5NhNdyyQ1faCV4+X/mGrqOWaq1F9LiHH0lh6DocVfaQhiqTQICIcqNlKcW45l5gCYcdtS1L77IE9rceTnhsJdINadRbA8J7mzHTC5i4AiNseChZfrlNIRrsHOpZOHnx/z2BaHpnAu7Tmj5GKFdhnUs7Cjk+T4HnPDpsB44blB9liqbxzpusgXDwbAp945/CuT9wuEAWv71AWYjLFjI4axItuXRFfcYBiHyCB3j7Gap1TObGeNISRWgXyw6Uxa/9NaKx7wBi69XJi9WAh1gPDxm+VXLBAb2nB2xCdphQyAcswH+qTe90SsDWIsCt911cBR558DC1H86xl9KmKYdwj1OHOuQ66blifvd7PUgovzZ8k6pMDORZyCLXxBKXNdvBRMKKtXznGQ88SQhl0hwxXaQ6axBl7IUO98ckpzGzuw/Jqfe4YZAR/AK3w++8o1HNV4deOskNX0khTc9hoUhrkJ2KZTlu00npgG/49RWShpK7xbXxItKbOy5Y5u565A71NYs388+aLamxBnoy4QqmS1fcFAkb9dF/OyJIiIZ8E2W/OH8Id+jXCSG5ExOerg9I9HftEf9yh4ixOffeZMMlLQZanqIkersisXvTJfOFukio2SWr+IZV8J26R73ucmZXFo5EGoxZT5IUHRBgQPDmcw49bO9sWxslJn7PpsENdgUrTQ7RZTFDY4mcOaNOfjPxpjLYAovPeaQ4AfsXLtBr4/6hk0g1g3INoLJ8IwD7LQ4hZiFaV3Mn/a7LAC0WW/ACGGEgnj5/wvrTu4NUXqZRw6XX2LsbpavCoYlJQSqWN4gG9hWDfIR8vCq3PWfq8qgGN/JMXeApUS16E1D6g6+G7Oyh913flRKaAOvegEcDEWi+N7RPkwgp/TDuK/T7KHsfh6s8Vdp6RYC8ZGu2KEw2i0E36J
 iAL3A81y
 0f0Eyinerbg0qkWhyZ+xzC1BfolPgT/BIYPbzUYjBFvqFzzE0D7hWFIMls3n99u6hu/+C+WWQGAg9sKjNmYsSqaeqlNRpGXk6m/bzHFAjS/K4YZm5mvQvCShGwqAjS0BhwAvZg7xAIbqwvrG3xvrn4eWP6Rcd7yUD+eDNHiWYkAt+TIqRuit7OFRjx29WzatIzNOmeWfLkj31buVUUbjaS8tUkiny2QD4vDnhN2oeuAWxA7QDwvDoBsXfYkbkrnUGhW0ZB/svq7nbA1fCLU8wEinQgnuJWPhxh+FYQ+4Im9wnBSOeLFelhSFVIPPf9tUA1CYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:22:46PM +0800, Baolin Wang wrote:
> 
> 
> On 4/22/26 7:02 AM, Minchan Kim wrote:
> > For the process_mrelease reclaim, skip LRU handling for exclusive
> > file-backed folios since they will be freed soon so pointless
> > to move around in the LRU.
> > 
> > This avoids costly LRU movement which accounts for a significant portion
> > of the time during unmap_page_range.
> > 
> > -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> >       exit_mm
> >       __mmput
> >       exit_mmap
> >       unmap_vmas
> >     - unmap_page_range
> >        - 55.75% folio_mark_accessed
> >           + 48.79% __folio_batch_add_and_move
> >             4.23% workingset_activation
> >        + 12.94% folio_remove_rmap_ptes
> >        + 9.86% page_table_check_clear
> >        + 3.34% tlb_flush_mmu
> >          1.06% __page_table_check_pte_clear
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >   mm/memory.c | 13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 2f815a34d924..fcb57630bb8d 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> >   	bool delay_rmap = false;
> >   	if (!folio_test_anon(folio)) {
> > +		bool skip_mark_accessed;
> > +
> >   		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
> >   		if (pte_dirty(ptent)) {
> >   			folio_mark_dirty(folio);
> > @@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> >   				*force_flush = true;
> >   			}
> >   		}
> > -		if (pte_young(ptent) && likely(vma_has_recency(vma)))
> > +
> > +		/*
> > +		 * For the process_mrelease reclaim, skip LRU handling for exclusive
> > +		 * file-backed folios since they will be freed soon so pointless
> > +		 * to move around in the LRU.
> > +		 */
> > +		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
> > +				     !folio_maybe_mapped_shared(folio);
> > +		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
> > +		    likely(vma_has_recency(vma)))
> >   			folio_mark_accessed(folio);
> >   		rss[mm_counter(folio)] -= nr;
> >   	} else {
> 
> Seems we should also skip marking exclusive pmd-sized folios as accessed in
> zap_huge_pmd_folio().

Good catch.

Will update in next revision.

Thank you.

