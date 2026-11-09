Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1EF606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dW2hIoim
Received: by kanga.kvack.org (Postfix)
	id 4023E6B05B3; Mon,  9 Nov 2026 10:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9706B05B4; Mon,  9 Nov 2026 10:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317556B05B5; Mon,  9 Nov 2026 10:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 104EE6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:24:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DED61206AE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:24:37 +0000 (UTC)
X-FDA: 85415952594.20.C40FBA8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CA151A0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:24:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dW2hIoim;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794237876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05PSSj9KAFKOlOAqbcefgviQBOp2FmRn72Lc22GkBCE=;
	b=zndG6cgwtutdtVGRu4YDN7AMfOpTESo17iL2n4ZdbTZ8U85CR5G/MK12GNMV/dGJacFGPn
	I+DAL5k62IhCMoB81EvievhlPWt9mQPdbSCYI3UBkLfHfFVDuH74Y+Gizr9efeU8PK6A5f
	pDuO+GlVkAtDT64B9JHIeNLLqKvRANs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794237876;
	b=xjOSiZoormjTtz2n59DTGcdJvCY8wvR3GfwU4WhUPBPP14lCV2PmeufA5O02+ctOGogAhz
	u5bRQaRSTmQpzLA1prZBT1LtTuSNqiqNojUFvXRak7Ct/SZkUzVPPfObyYRrwyKPPiQqUK
	tubN3ehXjWACntHlrNWBwAx+gdJef/I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dW2hIoim;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AFAE14BF;
	Mon,  9 Nov 2026 07:24:30 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 066483F632;
	Mon,  9 Nov 2026 07:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794237873; bh=5m0+4MkLWcNQHhoWxQ/fZjW/kH3KPYnBjU3kMCC73T0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dW2hIoimCnQ4aKC8wFf3cXyw0LwNNqLNkYtgmSRm+3yJohT9NFUKs1o/pkWDFnJRT
	 1wKRX/L73wDMpIEmpsF9AhxYzUsWJZITwwrPlodIg5trvqYhZD/NzK9X9gVmZ6nJSB
	 yOgP4lk2Y95HlkvimKrTvBU+9ZtrzIzSVdrIsDto=
Date: Mon, 9 Nov 2026 15:24:28 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/6] mm: khugepaged: ignore MADV_HUGEPAGE for shadow
 stacks
Message-ID: <avHlrEfKXDNtFJG4@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-1-2aaef02df0e1@arm.com>
 <3a2d4135-f531-4797-8dd2-a2732a846e45@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a2d4135-f531-4797-8dd2-a2732a846e45@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 444ayzghpu871d3p416nscei7w796du1
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9CA151A0002
X-Rspam-User: 
X-HE-Tag: 1794237875-695957
X-HE-Meta: U2FsdGVkX1+WcXmI232iJDIZ86KvT8Nuzup6C3yN0mOsZ65eRF1xhKFoXhFeMKwQYhucODogdS/XxHSCJlMVKkJN1eIy93ospwDgRHORdnV7SEgGy7EGvd8gZQmga5ZpN57sR38lsQZjH29CqebO5fL4MlmfFfISHehfObGLHiQVMZdpMTwaNj+Wizx1XcuEq+sv/E+F3fPJiVz1QfTRS4FWudx1VHxHjBDSesGhNvGPFsankwX+CWqoQODF0ERY75/6lVfNAZ/9SlBkGexClFEw2lvgJ7ZVTc0/GWDmvXglN9aAM5MhmRweF994+UeRFzfWY0QV18qXSL+yMZbm480wD1Ha5ykT3u2W9aqo0MjvDICpiBgR44m8f763DgvasSlu2H+dCM6xYsNbbmBwIcpLbGR+x+OEK85QR87t9+7lQRdPsTXd1Oh5wFqrNcBF1it5QnCD70WnhsRheH/0/jsItpSNMyPDktkE2EHPCGasGKAirewig2eryq4p0UWtq/v3nSvE/YMMGRME4LhVlWfeQ15VCAZGnHAZahQtxbB2pp2f6vumTUmpclA9KBQIVR7NK6b9IGdbpqQz1ALlJ6xFQp+1SHo4WTgI4DWG2S5MaXdYOEs2ikvqxkK/o5JklX4v0SRRFX1TobdTGlkb3jXh+OpjuH0oOuwFSQ10YZ24fZjzSnNUUdHPqnsuOSSwcR95T/Z6iG6HLvT+HDgTnrkjiFsWuEIpKmsBQoAnGRNHt8mkKnhaeR5N94SV9+KNQ4sowye09Xt5PU1bgxf5O5LbASbX8D717NKzvM2B1sKgFo9BvtQ0ph8lzD7Hondc+FlE6wZAW2ARbhWr87O/LG/OFJ/+HnGmiziBhZTOJaGjvIzgOBXxAY2P8hiBZjO9oH3fqhiOtPtTGoMe6+kIJmLsQF39SYyGJy075C7xKii9mKiWumAoRSEMojH7aRLBBcw+i1U+BvanmfTj/Sg
 ATZ1ELpu
 SPRCbUStSAgFa5OvBaOdApMysidPLNkkjIumn22whYT4xbv6Pv6p9BpwoWDFeqJxMcLsdrPmGH9rHXtmq4zgPhzFA3rdlZng6bin7ArC7rAma/164EP3YzDrf2aQpXmXyVegHe4XeiDJ050UeHQWafAnny7yEufPT+IOXvW7Y9IN7GjuhYHAJ5YuYhiH8Nh3Bw+fmkXobSjtrA+TZTb86Nlq31aLq58uIb9jnThfhSFOxhJw+Ma8IpZlOxNO0I9UTOn1J7sefOhTI/li+HWZa+MplQHIpPERqlnhOnGIcC78DwQNo+zCO/tdXqeD7V+IjeduHlrwJCZdOKsFfgEf3LqddjNYCzGCLjSqnLlzRESuJ76Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On 11/9/26 13:32, Yeoreum Yun wrote:
> > commit 3efb9800557b ("mm: do not map the shadow stack as THP") makes
> > shadow stack mappings default to VM_NOHUGEPAGE. However, userspace can
> > still clear this flag and set VM_HUGEPAGE through madvise().
> > 
> > Allowing large folios in x86 shadow stacks exposes a limitation in
> > folio_pte_batch_flags(). For example:
> > 
> >   1. create a shadow stack mapping.
> >   2. apply MADV_HUGEPAGE and populate the mapping with a PTE-mapped
> >      large folio.
> >   3. apply MADV_DONTFORK to the first base page of that folio.
> >   4. call fork().
> > 
> > In the parent, the first page remains writable and anonymous-exclusive,
> > while the remaining pages shared with the child become write-protected
> > and lose PageAnonExclusive(). These pages can still belong to the same
> > large folio.
> > 
> > On x86, writable shadow-stack PTEs have _PAGE_RW clear and _PAGE_DIRTY
> > set. Write-protected PTEs have both bits clear, with the dirty state
> > preserved in _PAGE_SAVED_DIRTY.
> > 
> > When FPB_RESPECT_WRITE is set without FPB_RESPECT_DIRTY,
> > folio_pte_batch_flags() normalizes PTEs using pte_mkclean(), which clears
> > both dirty bits. This loses the distinction between writable
> > shadow-stack PTEs and write-protected PTEs, allowing them to be grouped
> > into the same batch. GUP-fast can encounter such a batch when walking
> > across the VMA boundary created by MADV_DONTFORK.
> > 
> > Since there is no practical use-case shadow stack with large folio,
> > ignore MADV_HUGEPAGE for shadow stack mappings, preserving their
> > VM_NOHUGEPAGE setting and preventing large-folio allocation.
> > 
> > Fixes: 3efb9800557b ("mm: do not map the shadow stack as THP")
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/khugepaged.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 40fad28c52f6f..51ec043fa26c3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
> >  {
> >  	switch (advice) {
> >  	case MADV_HUGEPAGE:
> > +		/* PTE batching doesn't work reliably. */
> > +		if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> > +			break;
> >  		*vm_flags &= ~VM_NOHUGEPAGE;
> >  		*vm_flags |= VM_HUGEPAGE;
> >  		break;
> > 
> 
> Ack, I prefer this solution for now until we know how to make pte_mkclean() on
> x86 shadow stack PTEs not result in an implicit pte_wrprotect().

Yeap. As we discussed in offline, just skip clearing dirty bit for
shstk in pte_mkclear() wouldn't work since it would make a another
regression -- wouldn't be page-outed.

Might it would be good to use another soft-bit for shstk in x86.
But, for now, it seems enough as you said.

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

-- 
Sincerely,
Yeoreum Yun

