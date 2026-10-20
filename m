Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B730D606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D667A6B0174; Tue, 20 Oct 2026 13:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16826B0177; Tue, 20 Oct 2026 13:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05E36B017C; Tue, 20 Oct 2026 13:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955726B0174
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:03:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F80DA5BDA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:03:43 +0000 (UTC)
X-FDA: 85343626326.28.5D69FAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E05E40017
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:03:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792515821;
	b=HU6e8dX8mkKOariyEsLXp5kUn0tysG6KMiAmnGkRg3pjcvwuJ1iCuhPmBHsj9WaEuN7qVE
	rN8m1263ivqe+shSoMstGeiVYKDSwIZgH1fnGnt/w13lh8KsVRe9mmiHPL7Fx7A6JmUAAc
	jLjzHjvhwXuTwF7WFi13joXnZ/L0gXQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jDKBdDNUgnFBiehR+3AYyTsALn1WTufXGDvPpnjpNx0=;
	b=zUtyXNWXaInsd7cJ0wrFpjfJN/dyBWglhrOMem1kEpytMahiIk+rRWH7ZVA9vISeN6MtNp
	who6NlRtLuaReJVPeHU7gIPJRQfsisPtOU/nbcwq5yoltQk3bImdN8t9+iTXsv5dYU9bmF
	iXJQPvJCWcJE7cZeYCLboKqwRx2Xu04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E0C660120;
	Tue, 20 Oct 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7E81F000CB;
	Tue, 20 Oct 2026 17:03:39 +0000 (UTC)
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3F2E3198003A;
	Tue, 20 Oct 2026 13:03:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 20 Oct 2026 13:03:08 -0400
X-ME-Sender: <xms:yZ7XavrOIw1_gBGyaziF-ZMtgVeJKE3nH4r7UYLRU8Y_TmizNyllgQ>
    <xme:yZ7Xai_uCVDX6P-UZwskLNQK_Mr3csTBsbSsWKN6waTl5OqsQzGqJ8Pr7dRL0iRZX
    _j46ke_378wETQ-1RfIPMOFkPjph_MOCCCeXi4ExGr8hh3RNejt16E>
X-ME-Received: <xmr:yZ7XakMNXp-fEx-jQVJ_YQhHVX32jE6ZzgozHV5e2RzwwSTx2ezWknKte_0>
X-ME-Proxy-Cause: dmFkZTGkGIb3di2YCLCxxSDu64sQiSzl5RCtVWfkYdh889CF9jK0BQXmVxD4pT3c/xsx5j
    bF0l00c2FSQwMLsevVaWcEbFPrXZuV+j1kO8K6B1q9AIA+Z+td5APm+by2UaUaK7szc4Me
    F65Gr85Jd0nqGWJM4ya7q/ASMJXeMwMqWPC2tHJk1dvqfMc+2MyQv1t2c6LbWGl7yl8lQo
    TGH5DoJc62V0ssUipmWTQVdTt8a87oJAlHy4qY7seWpswcRl33BqtDXMTtlbURGtse1ax3
    XUC6RgZUTGjQrJssIhC+MCX/eTdgBorlngyx26IU2FgGV287DaSW3cBmdqwUiozfPp6eVc
    Uuy/BU9SxgF9qXafjZnRjQguUd+sWoMGPWmJBQZJcnt1SyDhl2lvyck9NPZ7YWuVcRQuI9
    uptTq9sDU8HOH3tpAFHtEKTLJ33COusQ9TyvQuqW5GEgNl6zD8AcFc7KhnbJk1HgiWDxyO
    7wqF7sTEKFe/yTMuXdVBeqEDu1kpBy+PVdFzDIYiVslmun31rtXOUs7TPPeEgbUBMPeccx
    Xg+0EsFUeebSIOe8QPMw9tldi9hpcm4QF0/9Oo1dR+IptD03LRAShFAxx9IicHQmIyygHt
    BtYTOTUxrTbXLY0Z0hSARlrNk8pxjQ3RU3URtGrxyz4WYeeMEDT6svAs0gYQ
X-ME-Proxy: <xmx:yZ7Xask2yfKJnejDpG-XGtzdGptLMV-MvfelgPB05-wMZsR7SuRf7Q>
    <xmx:yZ7Xap-TIprOdGX76uDRQL4kechcy6IhLgA-hmO2QebI2OSgdgUArQ>
    <xmx:yZ7XalMM5WFHMSFizZATTLbYyOTLMMWGJvVe-p3dTm_7yfhoWsc-SQ>
    <xmx:yZ7XatHnwFey-_M-_7WScr6IEHhyu5C6LPVCwwIxzX66l9O6IOPodQ>
    <xmx:yZ7XariDxe-NaLtuu9lzGit0tTgE4P1aXPEkype1kUEKlxfbegLwihNk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Oct 2026 13:03:04 -0400 (EDT)
Date: Tue, 20 Oct 2026 18:03:03 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shaos <shawnq1@163.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
Message-ID: <atede4rPZKNVqwDr@thinkstation>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
 <b61cbf73-b92a-4869-af94-72c30bbe9527@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b61cbf73-b92a-4869-af94-72c30bbe9527@kernel.org>
X-Stat-Signature: 464z4t5ec8dpbg5etypgcmkjnphdh3e6
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E05E40017
X-Rspam-User: 
X-HE-Tag: 1792515821-891755
X-HE-Meta: U2FsdGVkX19/1nGP5TIxuEGsbKsH6NEBJWmKbLqG+RWsFWgW3Iu+/War45Tm8aUgnGBl1zMlsi1sgRe6FWfE3eG5VGXuhdqRtsNZhGXAfUwDDVflO27cCRITx5JPT/M3ZqVPmviBd1PGkvXsmAJOQksIqrbC/7L2pR1vL3msT9Vb1rQyTQ4E6U72jaPTbhJ6p8r3qOKw3Zv2XguY3YoQK8gQReRE1l4npD8KfgqWcF3v5K88sGEzZo0qYxvJ0sxyEt8oWjZ85Ixhw1+ox4xKOhp5e4q5ABELNSowz0gTIxcJWQ9oWpfjEn4UBiqNoKWJpcueu02Rgx0aOyUX09z9Ecwb+8Eec+wusqQvXUuik/F4kQkKIbEi3va9k/eu+6r0n7y8k6bUDIw3ymMsQeVsBRJYVSe+orRH03tZA5Buy/ncVDpCT6QaMJFrVYIeAjrA8U6mf4qXJgr8T4Zdcj37zCIbWsW4GKOYrg43Fk5PZaXLUnMOWOxpnCVQ0mtZpqGAqRZ8NZ+0GdGwND2+F+NiwWvYXL2gO6WX5z8yGjgIiDP3a4UL2K3b9r/hd4ATrznZWNU2+2PTi8za0UsplcS0J52ILGaFop5d7hQ87OL/AlgYwGBKVUX3qJOuG/4lMhs0PD54rMsx+xgMOlQhESzbQwYJWWzC9LJR/kgyZv5+5rMx+Z3adhwM+V3NpoTqVKd8vQp+y5EfR+il4Xu/tOJVQdChxU4U0FDyBWM+j6zPMTUbAwt7bpPmaMjAd14kJhHDJyCpqT2tsqlnUaQDghlD/nNJg2eJhpcIVardIpfuFCiODqPEQF2dmbDSS1DhjHVGrjsxyHnPQ18XvkhCNA6fLVCtKV3fFSuk+n47yM60MCoB75H45K+ezJQ162K80y9ib8vEw3EXebEmDsWzjemIntXoSurEFLUvnW2tri3o3Pk/SXHCW5RKuUHgkrzLs7s1/Q/5ZK/1w+hi1rt8N9f
 KjntYI3Z
 xImfDL4DXewTdlDmZLz4/ZiO3dGZtAMJjpK+aCznqiUAIcThJJ+rDllmX5Hg75zcvCyVS5CMgBPW8J7uTWK90NbjFo8HR79aohwbsT/ngollKnLj3APzUv0oP5lU7uYtb1brsu5x0woX0zVJFwpeR9vBGFt6rHiBGx0r8S+DwUooHJJT1uL2APBxE2hzjYPFuE6n4mxnNKgRZ+iEiJ9P0jVBAFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 05:51:12PM +0200, David Hildenbrand (Arm) wrote:
> On 10/20/26 16:55, Lorenzo Stoakes (ARM) wrote:
> > Userfaultfd often causes unexpected interactions within mm, and does so at
> > the intersection of uffd, mremap() and VMA merging.
> > 
> > When an mremap of a VMA occurs, copy_vma_and_data() calls
> > mremap_userfaultfd_prep() to notify uffd of this.
> > 
> > However, mremap_userfaultfd_prep() simply drops the UFFD context for the
> > VMA if the user did not register it for remap, i.e. didn't specify the
> > UFFD_FEATURE_EVENT_REMAP flag.
> > 
> > This is OK for the VMA itself, as upon page table move, move_ptes() clears
> > UFFD page table flags, using vma_has_uffd_without_event_remap() to
> > determine whether to do so.
> > 
> > However, this doesn't account for merging with adjacent VMAs, whose page
> > tables won't have received this treatment, and thus latent UFFD markers
> > will be left around.
> > 
> > Worse, it'll break UFFD for any VMAs it is merged with. This is very
> > surprising behaviour for a user, who will then simply not receive UFFD
> > events for VMAs they ought to.
> > 
> > Resolve the issue by explicitly checking for this case via
> > vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
> > function explicitly designated for mremap() operations.
> > 
> > Also update the userland VMA tests accordingly.
> > 
> > Reported-by: shaos <shawnq1@163.com>
> > Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
> > Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c                          | 5 +++++
> >  tools/testing/vma/include/stubs.h | 5 +++++
> >  2 files changed, 10 insertions(+)
> > 
> > diff --git a/mm/vma.c b/mm/vma.c
> > index de5ebc57e7a5..1be613044b4a 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1211,6 +1211,11 @@ static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vm
> >  
> >  	vmg->copied_from = vmg->middle;
> >  	vmg->middle = NULL;
> > +
> > +	/* If not registered for remap, uffd context will be cleared. */
> > +	if (vma_has_uffd_without_event_remap(vmg->copied_from))
> > +		return NULL;
> > +
> >  	return vma_merge_new_range(vmg);
> >  }
> >  
> > diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> > index be8f5161f92a..f786a585caf0 100644
> > --- a/tools/testing/vma/include/stubs.h
> > +++ b/tools/testing/vma/include/stubs.h
> > @@ -386,6 +386,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> >  	return true;
> >  }
> >  
> > +static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> > +{
> > +	return false;
> > +}
> > +
> >  static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
> >  				    struct anon_vma_name *anon_name2)
> >  {
> > 
> 
> @Kiryl that should solve the issue I was raising the other day with leftover
> uffd PTE bits outside of uffd areas? Can you review?

Yes, it is the same copy_vma() merge.

With the merge refused, the reset in mremap_userfaultfd_prep() only
covers the moved range, and move_ptes() has already cleared the uffd
bits there.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

P.S. vma_has_uffd_without_event_remap() is a mouthful. With negation in
the name...

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

