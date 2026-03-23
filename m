Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CAEEC01BE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CDD6B0005; Mon, 23 Mar 2026 06:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DAB6B0088; Mon, 23 Mar 2026 06:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144686B0096; Mon, 23 Mar 2026 06:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2B656B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:42:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A18B11B9045
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:42:54 +0000 (UTC)
X-FDA: 84576989868.23.E875A99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2BBF160003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:42:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAN43XMC;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aIcoKw1B4lZXDlORkn1YTWocVX79AJVMudqEMsMQXI=;
	b=SzRGIIKiK3lJIBmwp8CqNZoDwp5PcxwtntajiGwLo1JF6yoHTFrHCdVTymwLlzsTqQ3UDv
	tDE4ssZHRTJi4V8UhM6/BUiCcDc8ANkpZo9FROc1xfz4bZXV9eJstZNkz/f6RlKAHV8D8d
	nP92h9PX3w4N43KNsAwTwqmkiWFcfCA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAN43XMC;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262573; a=rsa-sha256;
	cv=none;
	b=yXPwNqT+XznZ/CnMW7xTrHFF3XOl7TIkaI3QPsjFcpZ4yUSr/VnKO0CE+eZcIu+VWo+hR5
	s+Dpyi2lxoPo01/ikePPFo9ykhC/Wb2Y+9g2eEVLd1PM1OfIsuq8KA/IxX7mlhpJNJI4bb
	cWEOVbzbkVZ5hDOX8x6hMfc9MZ2HmIc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA47740215;
	Mon, 23 Mar 2026 10:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B536C2BC87;
	Mon, 23 Mar 2026 10:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262571;
	bh=kxiLoYmlf4q3ke2uGxZ7iSgE18S0jNgx4Yf9uf826Gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JAN43XMCFGd9Ew29jBoMUxset0rjSufmFyTX8A97NfjSPz9m6uH6ufeayplDx2FJl
	 8SnErMDsP4gx7h2lP7GTzcezJd3SK6vyIrI82J4Bubbf1qXi+ZGSr7WUAENmuWv9OL
	 Fd5oGcdVoMxSvNh0H03OVve7Me51FK2unI72h4N+Ynvl4SqmxAN6Ob+e4mv82A3hxc
	 22WYsRXX6fNzsKXJ9CldUwU9KqflMPDnKd1LcZy+2ynCEAFjeJPdshC0IU8q83PivN
	 L/wgbmi+UWQqxi3DnnxllYN2Dq4ocspCN4jxeJfyH21mMGkMvjrHX6Z3rtbP4l7JGu
	 4UNpN/S+HRVdg==
Date: Mon, 23 Mar 2026 10:42:49 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/13] mm/huge_memory: separate out the folio part of
 zap_huge_pmd()
Message-ID: <2f8decdb-4ff7-4482-b50d-6718f25df8f9@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
 <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2BBF160003
X-Stat-Signature: j5c7d1x5xfyb443cm5z46d9bou874amy
X-Rspam-User: 
X-HE-Tag: 1774262572-80839
X-HE-Meta: U2FsdGVkX195OkpDOyMy10Ss4/tH2albJ21HdSZA2XO9MsgSkka7qwZyZT3leOLMmQnNaW6BTEO85WWnZayAcCee9mXX0ZW1WUDTyuyL2wrGTWZCLdgM5i6tyZrNNR4XhE7kYF3AyghYHGGUwc+NLqeE679yfnq/J9Ygy1okYK9Rv75It9UfB8BJZIBlVoD3hAfpobQdzE/xH1cCN7kZYFJcWydqYu8p+bRbfoSpHi42UhMpABs5i3MU30QhYs2rYmEp0aZziu0bHWtGH/ZuRwoEefMaYygShWGp9VJiz01C27cZ6lpuqdeBQtogwVbFgC8HP+tr7MHvFBHRuonzB+83JM1fN8XkJL2DW7IULFuRIHZ64qK8XK/+ZYQydi98YNbGrNp7NFUOtM/R3Qgr4JNNKau6TkZ+jG4X+7z4tuZFxyqRF1tcd6V8o1jPwChfx+pl1dFXTsqSdQ7AVx5K/eYmPrwndeQWoEa4t/zZhREHgm9hyCNVkQbosQyfmNBU06GzztenkKE2SXjcGU2FtdOq4oo5wdlei/BMaqLKgqgTE1/fVn3HG72rEUXQP86zuZD5zCTrGyQuqg3KpAMikjqvHlh7xw3EHEJqEsnBG1s29nyllLLG6eNQ+dUgxTLgnT+L+bNcBXpVf5ik3mlyl+t3KqO787qExYahyHpWSI65tj993OQK2scft9Q4vVnQI7/qcj3VTnLXc2/KZoykrb0XyIEUd/zNG4tb2Xa+PqePkCMPpsY2JXwJ9rr+n8YOzHP2ka+uNwexest72g6WGRrNfU63ip1WI+hW6eclMGjR8WeoexMSCBF95jcNPF456N8cFflFjd52FOiPhp07uJk6ehFk8wD3ivRmynoC02YXI0t7XVh6uls1lNYUddbiMZd+aELf/qfi7Ci5nd8JUge1yIE9bC2u8C5wC6+h30w7rguww2WU0a2Gx87xEer5doE2MxZBxgztQDeUjal
 FLJ9V1GJ
 IMw4AqRMAtBYWaTwBSH0I058kHcE5qoQOiSzk16nsJXbdoi42eHqjQRK44+U64iLJnVWWCUI2wN91rD3prBdMKyLEDvHypz3iPoW/9lzuCDLWIWT/FF2Zv+wJBgqfAoOddcejtZmJ8kLt6GwsxcxrIzI6k1x8ZIyMDxO3rmCYmt0nmw69fsYSFMkTD8vXYIfD3JBeWoFGRGkQfGOr9FxHWBK6HTP5fgUPswfoBxJEJK9aiDwKTbhYl/eQGs1mq3dwOY0LvEqVM/F8O2Wfg3qXLUDrFEqZazkjbaThNSDNTHOKA/VxySdfYcERRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 01:59:34PM +0800, Baolin Wang wrote:
>
>
> On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> > Place the part of the logic that manipulates counters and possibly updates
> > the accessed bit of the folio into its own function to make zap_huge_pmd()
> > more readable.
> >
> > Also rename flush_needed to is_present as we only require a flush for
> > present entries.
> >
> > Additionally add comments as to why we're doing what we're doing with
> > respect to softleaf entries.
> >
> > This also lays the ground for further refactoring.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >   mm/huge_memory.c | 61 +++++++++++++++++++++++++++---------------------
> >   1 file changed, 35 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 673d0c4734ad..9ddf38d68406 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2325,6 +2325,37 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
> >   	mm_dec_nr_ptes(mm);
> >   }
> > +static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> > +		pmd_t pmdval, struct folio *folio, bool is_present,
> > +		bool *has_deposit)
> > +{
> > +	const bool is_device_private = folio_is_device_private(folio);
> > +
> > +	/* Present and device private folios are rmappable. */
> > +	if (is_present || is_device_private)
> > +		folio_remove_rmap_pmd(folio, &folio->page, vma);
> > +
> > +	if (folio_test_anon(folio)) {
> > +		*has_deposit = true;
> > +		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
> > +	} else {
> > +		add_mm_counter(mm, mm_counter_file(folio),
> > +			       -HPAGE_PMD_NR);
> > +
> > +		/*
> > +		 * Use flush_needed to indicate whether the PMD entry
> > +		 * is present, instead of checking pmd_present() again.
> > +		 */
> > +		if (is_present && pmd_young(pmdval) &&
> > +		    likely(vma_has_recency(vma)))
> > +			folio_mark_accessed(folio);
>
> Nit: these comments were added by me to explain why 'flush_needed' was
> used:). Since it has been renamed to the more readable 'is_present', these
> comments are now redundant and can be removed.

Ack, I think it's _probably_ ok to leave that as a later commit removes it
anyway, if that works for you?

>
> With that,
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks!

Cheers, Lorenzo

