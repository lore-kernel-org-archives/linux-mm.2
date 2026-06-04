Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F14CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713936B008A; Thu,  4 Jun 2026 10:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA3A6B0093; Thu,  4 Jun 2026 10:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626CB6B0095; Thu,  4 Jun 2026 10:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 518D16B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:41:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F125A1A00EC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:41:14 +0000 (UTC)
X-FDA: 84842492868.18.C63E6A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE500A0018
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:41:05 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780584065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtDt3lYeen32tJjPtVhK83NQYah0kpWdJdJve8FYL6Y=;
	b=KWLIHFYTSwf/GRjnv338lx/4TQaWCr/vI3GB8oBwr4q4h7x+snKc/SzFXy736itNT1mr5d
	q3gMzZp42t/Pjy+J9fKS4AJFGumY2ooGVV2XHRmYv1KR93IsmQi4nck47KplRF1MGRrF81
	+3iJ2csV7grBGlI9K0ORdZ55OD3ORjo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ip7V26mZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780584065;
	b=3SVtLcFBZqhwqWvjzFaqnqhtq6Y19Versf62ZS5N2TiEGsv/xSG3KozK+bigTiQ7OFt+pB
	07iRMxAKQGcXEtuLxC3ac3R4KttqFdaGh+yg2VYciAniCu6wfxfRwBXzOLzyIf/rQrrGm+
	LQ3coM6xsBmFkSRM3odvWneDLfjVLew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35C57600FC;
	Thu,  4 Jun 2026 14:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813361F00893;
	Thu,  4 Jun 2026 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780584064;
	bh=CtDt3lYeen32tJjPtVhK83NQYah0kpWdJdJve8FYL6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ip7V26mZ3lpilTPjqq54piAcvOldqnXrk4MptULiPvlt1TPj3O9KC/WGiBCpb6sS+
	 FE/PcYpQMfmHU4JeXTJyoK7qBUwLxMAT46k1dxOCBZ+IVZ/92S6R53dGbiuMpcfyZK
	 62TXYPA9ty+/tG9g1H445TrGZInqnRDINE0QCHnsRCJNisxk2ShRvoayrgTln0h3JT
	 Qh3k1N7Iic1u2ZWCI5CxGC92BdXhxeVP4kM4LU68/a0v9PaxSay2rbsuPPl8Q0du7s
	 QwF1SpaHIfafTST+QIOw9/ekg10tpWZbR3mnERIgDF6duw7/NNe4JE8yOrvpGwcnGK
	 FJin50Cz7XUIw==
Date: Thu, 4 Jun 2026 15:40:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <aiGOZyvD6lHskQSH@lucifer>
References: <20260522150009.121603-12-npache@redhat.com>
 <20260531071845.10875-1-lance.yang@linux.dev>
 <CAA1CXcA+oZmp=cxiC2_EBDxqGX94gAd335d9eFPNv=j_0=og7Q@mail.gmail.com>
 <185f5699-3797-4300-8c54-bb99fc2a45e0@linux.dev>
 <46bb9d9e-03f0-4e26-9ac9-1cdc5ba9bf4d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46bb9d9e-03f0-4e26-9ac9-1cdc5ba9bf4d@kernel.org>
X-HE-Tag: 1780584065-784942
X-HE-Meta: U2FsdGVkX1/evkp42QV1ZY5ML1pPutV/7B21kj1L2zN2Z5qADR+6mVY49GoG5X0XT7zWFoy32aNTIuYiJaUgmn5pFV4wettId9e9NImrsrmBtfXMwwZrUzcOFR/LSR+jV9rloOwS1bX0sk/pNKeoIP706g7zj/Fxr4R80sPvpQlNpBpLMg+GlOGwDZPMmDydu3XRBJdv0UuEgOEE5dPV/fBi+tpwnoAIzP4uf6rlvkfycIs5QRrTBqmGtjFRMt9UixCtEiOHpIRy8BirxSKcNYxlm3yk6DZngr0dhEA/rNhIX++BrK21n/pS/1jFxPY0YFVnBL1q86hm9BaDgOXaiUpWOnAOTLG5JgLyCXhuvN2uWVcS5GhpJAODc8VpZnrqQDRolcGCsDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:05:08AM +0200, David Hildenbrand (Arm) wrote:
> On 6/2/26 17:44, Lance Yang wrote:
> >
> >
> > On 2026/6/2 18:58, Nico Pache wrote:
> >> On Sun, May 31, 2026 at 1:19 AM Lance Yang <lance.yang@linux.dev> wrote:
> >>>
> >>>
> >>> [...]
> >>>
> >>> Hmm ... don't we lose the allocation-failure result here?
> >>>
> >>> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
> >>> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
> >>> in khugepaged_do_scan().
> >>>
> >>> Now if allocation fails and nr_collapsed stays 0, we just return
> >>> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?
> >>
> >> Ok I did the error propagation! I think I handled both of these cases
> >> you brought up pretty easily.
> >
> > Thanks.
> >
> >> However I don't know what to do in the following case: We successfully
> >> collapsed some portion of the PMD, but during that process, we also
> >> hit an allocation failure. Is it best to back off entirely? or can we
> >> treat some forward progress as a sign we can continue trying collapses
> >> without sleeping.
> >>
> >> Basically, do we prioritize SCAN_ALLOC_HUGE_PAGE_FAIL or the
> >> successful collapses as the returned value?
> >
> > Thinking out loud, forward progress should win here, the allocation
> > failure only matter if we made no progress at all?
>
> Agreed, in the first approach, forward progress makes sense.

Sounds sensible to me.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

