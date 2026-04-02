Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FECCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26A86B009D; Thu,  2 Apr 2026 02:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEEF6B009E; Thu,  2 Apr 2026 02:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B956B009F; Thu,  2 Apr 2026 02:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D19DE6B009D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:46:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72049C1E1E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:46:24 +0000 (UTC)
X-FDA: 84612681888.17.6E99366
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B70CC40004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:46:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkV6Cenw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775112382; a=rsa-sha256;
	cv=none;
	b=Z+F3NShb990sNy8ybepL3x4aunSaRsvVXZ7VrFZnKwhewES72gusg9GcTKux24B8rUd2HN
	qyrMcb6TAnU0zdq5eqPobwlXkguAZIVwtRRIdKjKUdk4deAtnwRux87Zv6+ZOntF6EnABt
	JdGuDRJgRK9kQfS/Nn+2p0mz0QKDY1M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkV6Cenw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775112382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDLhRFZlwkXXed3zNjcYADJvj9yB9O+gLoZDJAZVwss=;
	b=6Civ358BTBfOCE0fS2BsNT8lcumG8L/4DmVY+/AzZJatmre2lNOxyGlBc2tIa8r+liOoCD
	rWwb84p60rmVBtVkn3VvJbPkFyrk1BBg6Armeuaf9wvFZoibCCecG7SMWDwPAHgoSlqssK
	f8CdQ1zBLH+vRy2+W9c60w+CwwXLQYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4B4B44512;
	Thu,  2 Apr 2026 06:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95157C19423;
	Thu,  2 Apr 2026 06:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775112381;
	bh=u8XZ3VzvqsviQrHUux2s9/j1pn9XnpSL8LG/NS0Vp4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkV6CenwGQBON7GN8GGdQGkikYra7OsZ70Xu5PafBI3DATrXmXEK3tYje+RHm/teQ
	 Uy61VkPlzHR8gk5CzLPsnPTC0bzU8YkAgehHuPTH/iKnBo4pSGyXZcOegXjxmNm66E
	 panvTK8UWqNUVwDBsrXsqJKJHXbaSeINDMS5nRKgN16D5j5XwIapPTzo4l6JIi9R4D
	 Ldg3jMk1eZ50jf+qFEs5R9kr9paSdGUubYnDOMDaQDLYO86Qe1aCXaRB7q3oYAOpJd
	 u52+pEQRhQ+VTu9AoOvRW7kQzV4LdgrcA7BG0HBjWPz6UpOg3/bU4uyEKYecc12ppQ
	 6BeYRJ/KeUaEg==
Date: Thu, 2 Apr 2026 07:46:15 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Yin Tirui <yintirui@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
Message-ID: <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
X-Rspamd-Queue-Id: B70CC40004
X-Stat-Signature: augthsfm633c3fqnxy6be4xgmch93hp8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775112382-972499
X-HE-Meta: U2FsdGVkX19vMjIKRgSrqJs+/0mGa6rKZFE1sYib0M5gYsSrFwKESJag5k4aerkzag5/+hnJZ5hxpJMJbKX42jWL80Wlrt1MsDkaQXWxR1pnGQb+b24b+MkAcpdIgPc8ol8W1Z8m2G7JXbA4GuBW3uU+3XJKOs10TGt11DVxcWTDKbENMmazDg88R2iqDWWFxslX3bY3fnJR8qotsETboSw7BNQCdGOzRGpCvhEEXZoIzW+IedrWBOfYjX3tg9iwLODi0yFBo3bIjehMLx6mCJ4BANyT15fwlrR99U4cWuDz6FRHlfqXbl/yfzuxLoBwBMBQg4Ii4lsdQiQL/VHVN52JCPKER/Qf/xrU2Mh1isc9EbWbuVDGREeG//uxJlSqH/m78U2jDhnydlNITLykCpEE+X9F0S3+Rm94/jLgQFYsVzlBWlyhtCBDtPMHGyJ5Ubhtus0bKlTMnaC9ClCPBxDFcMK/7EYNZrryB5rFg3o9fMqTUh7ClKnzDovCJB7G6EQwAkDLbMJfxkYK8xI29Ci5xjJ6EKQ8BBp0BpkyD6vApEH0DWIxaYoue47bn6y17Tj6W0wrfaA6m5+/ubHEXo8amENExWIcx0+USj38EQP+jihQd4+FmFYFAvmypkMiV+I7akHW2o3L+m5PhRg7BBZPWVujG0iY9pE+uEhU80/CLgPYSVLfZMZ1M7WNjag9NpwpemSskye6M9zey91EBs/7U/zAvIxRLuXAMY3zPquPRrKudK/iqy9qx5hFNyuf/kastfx0tSivghjyvWvnEOl1CVdwg0zHb6Ds/Q9sJNJwqSN/ddA5BaFAEKpbAaL5KRWZ5bp5C63C4l99aQa+5FIzyaSYBQ5xB19AUdXt87FSJ5BLwJyRl4i/L4ueJ1c9g+9ykyYXjw4bvN+WyZ84mDRxc5tuFAzOGyj46SfTbCyJT/oCpL9CAXEMoxfO/juW11DNvqNx87+YBw06c/6
 XI7n2oP2
 iUf4Ta0BBn9BLO+LtnllhW6d3Ru33oNhJv4CWGW5w+q27Q7gP5SM/kD8gqywsIP0c1YLF8Q/6/MZ6Qug9FxTRgVXMCilCO3yoHB70dGJ5G9ZgzvkJv9fRmMoAckiMZksHDWJh0B8OLKz0suyPxG1mp0Gd5Eh956FUb2rAxDO2so4Hhi49SHW5UbQ64f+QtqKIlhq27BsZF2V6Tv71/BflOA8w6w9Eqww5ue3mpqbAXTHRMia8lfkrmNGWFy7J/hrY5ebyzw/YOXB0hh2XemRb2seiULy4F14riBHPYI299TbwSAwSSifQDvieVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 11:19:07AM +0800, Yin Tirui wrote:
>
>
> On 3/21/26 02:07, Lorenzo Stoakes (Oracle) wrote:
>
> > +static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
> > +		struct folio *folio)
> > +{
> > +	/* Some architectures require unconditional depositing. */
> > +	if (arch_needs_pgtable_deposit())
> > +		return true;
> > +
> > +	/*
> > +	 * Huge zero always deposited except for DAX which handles itself, see
> > +	 * set_huge_zero_folio().
> > +	 */
> > +	if (is_huge_zero_pmd(pmdval))
> > +		return !vma_is_dax(vma);
> > +
> > +	/*
> > +	 * Otherwise, only anonymous folios are deposited, see
> > +	 * __do_huge_pmd_anonymous_page().
> > +	 */
> > +	return folio && folio_test_anon(folio);
> > +}
>
> Hi Lorenzo,
>
> I just wanted to mention a potential intersection with my upcoming v4 of
> the "mm: add huge pfnmap support for remap_pfn_range()" series [1].
>
> To safely support PMD splitting on partial unmaps, my series makes
> VM_PFNMAP huge pages allocate and deposit page tables. However, they
> neither have an underlying struct folio nor are anonymous.
>
> Given the has_deposited_pgtable() helper, do you have any suggestions on
> what would be the cleanest way to integrate the VM_PFNMAP condition into it?


I mean you would have needed to handle this case in any event, since this change
is strictly an equivalent reworking of zap_huge_pmd().

But it seems that doing so has clarified the requirements somewhat here :)

I haven't had a look at that series yet (please cc this email if you weren't
already, I do filter a lot of stuff due to how much mail I get daily)

So if this is a PMD leaf entry it will be present and PFN map, so I'd have
thought simply adding:

	/* Huge PFN map must deposit, as cannot refault. */
	if (vma_test(vma, VMA_PFNMAP_BIT))
		return true;

Would suffice?

By the way, I am wondering if the prot bits are correctly preserved on page
table deposit, as this is key for pfn map (e.g. if the range is uncached, for
instance). That's something to check and ensure is correct.

I _suspect_ they will be, as we have pretty well established mechanisms for that
(propagate vma->vm_page_prot etc.) but definitely worth making sure.

>
> [1]
> https://lore.kernel.org/linux-mm/20260228070906.1418911-5-yintirui@huawei.com/
>
> --
> Yin Tirui
>

Cheers, Lorenzo

