Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A630FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117EC8E0020; Mon, 17 Nov 2025 06:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFD98E0003; Mon, 17 Nov 2025 06:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C118E0020; Mon, 17 Nov 2025 06:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5E338E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:23:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C3DE5CF5E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:45 +0000 (UTC)
X-FDA: 84119864010.02.BC939DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE70FA000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mI2M+SGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378624; a=rsa-sha256;
	cv=none;
	b=aWm6ob3GEslz0WqEgPDCh/N1Q6cNvz45/dlGNM+OdIn9/gWpvfUdmex2wAVnO8LIBfY67F
	kwz4VyTojnVUvxRSYUpRJAbsT/lGrqBkOASpy1wtA/e0Y5Y2gStSZWDoI+2usZXmMkt17Q
	KiEZNqZ0Dq2j4TekoRrZkZa7i2wk5x0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mI2M+SGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCaySQh8kklKAYlqDtgRlLbv3sGSXbwe58B+5cNMuzQ=;
	b=h78eHgibGY2A79n4xZu+5YcHoCbbQV9FsVXO5L7P/PD/OzHJ1D687azuQxgqUYr/x6aPMm
	iON1R2Zg8sXbKONZtnKpC3CmccdXq6DvEBurXFMtxOGEli0oNYifgsdiOOP/O8p9dpMz4a
	MFjNskTkbDecXf3Dg1P/+thFhhs1UVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03CDE407F9;
	Mon, 17 Nov 2025 11:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1272C4CEF1;
	Mon, 17 Nov 2025 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763378622;
	bh=AS2LOdZB9mGe8g+PTF2d3HZ0vp9cklG1f8pIgTQRq+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mI2M+SGsm9caH86sXqrWFYAILM/5jD96wHWRsWaZ9Y/ikSIoYC5zTmEouwBUzllC0
	 TZgKQQ3QNY7ALqjO9/QbMJTNt8+IrF6Wp1sVZToAcy/IX6QhaMzLwFbC2k19OnWDc1
	 NkBJ7t5o4AlfQysgofzrrF7tBUtdjZOjWivHCDSqjjyP+MDomvSNsYVA9I1AHQt4ak
	 DVNXsdg1SKU8oLcMTKyOFkh5oCAyoUjziAuunPJLyFaeKfUVAaben8Kf6slF78d3NO
	 FYCpLpmF1MFK67/xcRRQVTLIbG0sX8jPQj2U+NCuVYy46g+ux4eANLg+MrxwJDVqzp
	 Utx3AI8iCMu2g==
Message-ID: <4b81bc10-59a0-4ff2-99db-12dc7157da85@kernel.org>
Date: Mon, 17 Nov 2025 12:23:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Donet Tom
 <donettom@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nathan Chancellor <nathan@kernel.org>
References: <20251114214920.2550676-1-david@kernel.org>
 <fb95d369-dda3-47a9-b294-6d5038cee4d4@csgroup.eu>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <fb95d369-dda3-47a9-b294-6d5038cee4d4@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE70FA000E
X-Stat-Signature: d4ch99mhqupmhtc7q9phyoz97hzk8tag
X-HE-Tag: 1763378623-67456
X-HE-Meta: U2FsdGVkX18D25+ldQGx7IX43uMMxWJAPeASvNpQPni+f0dpBQlRuyMGvTPg6dt7J+qoKo5vKSablTpQuFhMdvtlYYma32Ckl57pTgVKtsNkmNg1hq2QE/LslJ5ZxX8CAvz9iuwIRFiwASEfFt2lVoMviaoWJkEg5ytmxNOhl98ZjHamlmX/R3ZHsYuJXUkOJlaAd6mVveXhk6NiiXCNgJ9Il6mbjuFL+vMKLyqlFSEMxyWx7CPzCh18SLLXZLdCHVd9SbRH5iSpIPPmGr+L5gLr4x6jFB7meoiGM0O+sa/plvZvVZ2bj/824ULHyU9v1+I/+wmfIQHIwLPuUKUgn+WHZX7WD9kqyzI6Un9wpCL/bdCsZBm0kJRR1prnC7rNK87qwFSvAQKtp1wpyDm1V3r9167oColOJDczNgcPpiOo7JWG8XCNy6sBGjC6leE9/sJyefaGaNCqFIqYcGtKppZVRdBGqi+aqcIPENFxXpuQzlwqcezuU3i3mSAPuRD2nmxiZzThX2uWR6DU8Ckpg8HLiECUeXkVc8GbhJ12FT1D81TU9Sm2IDyvTFHwYuGC8kbTvkBE9t6hN5AeDnPL1VkWuaeKxCW9KSuFkF/8Yl8lb2ywUG3Q3hcbi9MR+ooYQQC+8yoZAX/F/TXE+/wg2Jaeb3QaAiLZGjneCFbnMcZ4j+GgII2BqOcclA7YfRppSoDmEzTsM920Jbm4G3k5w3fuGFDuv6ch6UobiQQ0cIsl6eauMfMZKES2+JxPmwtLwJTwuEPR6G94gyv5RyG4gN6aseBwOIKEbiiKNSgwxYkYefOwBoGuES98us9D8JzZ4nV8azbEJGTzU8S9nXJBcRoVe++QxMtWe+KG7pjj8g7/QZqslt6KxoHGDKMZAGpezkGu0CxjtJc4XfnBHBzmgb3FU1n2eR3aM3VYAq1v96SLBuA/hoLH3u/brOk4a04iII0Hfw7akg6Z+95uSwc
 FT/4f+P1
 TZUfEEdKnnDBOL1MtCHfGU3wNuk6xzi67IpPn6M1IaW3/sdUNiVaW0USpc3M65EdOgFc+o5ZxPV785BequIjKQw+te9P2wWzkVOvAPjnv05UiHGzBti+pz7DtfV+BDZ4gFddmawM6nGcBihatVuc5gxEQwNdpVsH/lCoDXPC+gxtIErpa4FVo8yQxMNvZtn0JrNF1j0hphEN9cH2JrLrjRZFDGLKBEI04+CHHhjljaO8R+Dac+H9OgEpMulxJ77qfODEjqoro/fGhEk6D9Cv6MGUXR7tr0eKXHJ1KHlkPxbNEBmMWk85i2k9AWzFNara3t0O4qGCP1orceLHf4wD1oe8vy+Ul69RDGywANHBNhzw3UaDxWTJkUWbgsfMiIFowfy2uHbkFazIdJo1VHsvjcMX0qX93w+KWgkKOF9iV2x8I1x4xhvTWvL0+2iHIWizzyekZhgCUD6ftg2w4YSGi2UhAsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.11.25 10:37, Christophe Leroy wrote:
> 
> 
> Le 14/11/2025 à 22:49, David Hildenbrand (Red Hat) a écrit :
>> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
>> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
>> into a generic way for the architecture to state that it supports
>> gigantic hugetlb folios.
>>
>> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
>> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
>> have folios larger than what the buddy can handle. In the context of
>> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
>> when dumping tail pages of folios. Before that commit, we assumed that
>> we cannot have folios larger than the highest buddy order, which was
>> obviously wrong.
>>
>> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
>> when registering hstate"), we used MAX_FOLIO_ORDER to detect
>> inconsistencies, and in fact, we found some now.
>>
>> Powerpc allows for configs that can allocate gigantic folio during boot
>> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
>> exceed PUD_ORDER.
>>
>> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
>> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
>> GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
>> Note that on some powerpc configurations, whether we actually have gigantic
>> pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
>> nothing really problematic about setting it unconditionally: we just try to
>> keep the value small so we can better detect problems in __dump_folio()
>> and inconsistencies around the expected largest folio in the system.
>>
>> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
>> and detect ourselves whether we really end up with gigantic folios. Let's
>> defer bigger changes and fix the warnings first.
>>
>> While at it, handle gigantic DAX folios more clearly: DAX can only
>> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
>>
>> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
>> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
>> HUGETLB_PAGE.
>>
>> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
>> also allow for runtime allocations of folios in some more powerpc configs.
>> I don't think this is a problem, but if it is we could handle it through
>> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
> 
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> Tested on powerpc 8xx with CONFIG_ARCH_FORCE_MAX_ORDER=8 instead of 9.
> It is now possible to add hugepages with the following command:
> 
> echo 4 > /sys/kernel/mm/hugepages/hugepages-8192kB/nr_hugepages
> 
> But only if CONFIG_CMA is set.
> 
> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Thanks a lot for the review and test!

(thanks to the other reviewers obviously as well :) )

-- 
Cheers

David

