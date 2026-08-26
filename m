Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2D0C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E546B009B; Wed, 26 Aug 2026 04:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F8D6B009F; Wed, 26 Aug 2026 04:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555A36B00A1; Wed, 26 Aug 2026 04:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360286B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:11:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3DD6A31EE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:11:49 +0000 (UTC)
X-FDA: 85142701938.29.7F0270B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21AE2C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:11:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePHnLnjC;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTz+XP2ZmEJS+adHOO/Ohz8zpeHQ/sJQxx0X7QLGjQE=;
	b=6zgJiGg/fx8OTmq+zt9+TCxaWr/63yOu9BEqnjL8IgN4qF2+CqGZUtQI57HkTvzB9naOfS
	zi7i4yj3nzaf9vBY5uuaBZS6k6gmD+UgvAfT/S2NLTnELpj3uJTf11pRK4MvrBONaAupuI
	EAZlyu4LO6tQ6yKsXIgYeCJlDSMvObc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePHnLnjC;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731908;
	b=RYszt8nGyRVPj5bCM8apd0NF+mN+cl1K1Dm47aN2kaWA/6AobPklR7rzusKSuVnvvpNj5H
	DRfuvWF0Ic24dUJ9OrvOl05MIFvJ560IRiHFq4eyystKBsMGVhWMtLrE77eNGacYNekWMU
	rAWOsfrvFU+pFBKTl+/e8BfbpkG0eUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44F3440C54;
	Wed, 26 Aug 2026 08:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A965C1F000E9;
	Wed, 26 Aug 2026 08:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731907;
	bh=NTz+XP2ZmEJS+adHOO/Ohz8zpeHQ/sJQxx0X7QLGjQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ePHnLnjC++XvojUVKd/BioxVavElfpLaXW3WK+6BYE6qBGUJ/b1aud5whdp1KQYDw
	 ZtzgLxJ3Q1eV4ZNT+DivuCFM0UCNDK/Cj2ggZZxOxGQvbXExjKEQQKZ9wcv0M51jvk
	 BA3JxyBdJr3e5VPvhNPJBXtuiKvaBAGYhkbsTxU7cHXLBYY52/B8B1BhZKgqBoh1cu
	 eU57qdTZnBw+AZpKNTwyDHxCrin6ioJKb+2A6U4pHLPGOqDUKra7ncHmmoaixbFHv0
	 PsyAul+BvYzKh0z6Dw93KDuotgBQlmN/aZPaXT5K9yLrTwvrK8SppYHorvfL7DEOGO
	 7s7jfE9aFKyeg==
Date: Wed, 26 Aug 2026 09:11:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <ao6fSHW_nX8YC9QK@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
 <ao6c6Oe_KV0O1LJn@gremlin>
 <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
X-Stat-Signature: z7ndbgf8nrkknoc5agq9875bezec4c9h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21AE2C0002
X-Rspam-User: 
X-HE-Tag: 1787731908-656023
X-HE-Meta: U2FsdGVkX1/kH1mbWDJMjTEWDHD7kYaFrC+M3fRw9xuo/MERUFiXcoYTbCtPHBRAL3LQ+M+eVmjMaTIg0bj6GEHTnahgGhNVu23s/UN+GS3i7g2erwmSLxrWcO+sBt9uBMCENZP8K+fzVXKsTDC5XZ1AGIPFCUkMRTwuDJN+nR6WctbC6Qhi+rqX5bYLAHWcEtdpTQF62ls6HYcki3sA02GxGc3N4VuISBeZeAmNGZyFPJJlylV9OUfuiN4Y0XcRM532HmDb3E+NXTXEsgkmMritbV7CU1s1zgMFAFKNL6GfWDfc9wSXPNOZfJwvn6JvBAseckpmAHR3DHxSoK3U2fhyUtRavtoTatNXOO8nzzOzDuP/Ryrieu3407gGqsZFxgv45wG/oNYhEBDqpW68DYRn9y2dowdE+FJDe552x9W/ATuDFZaGLvWByWhatC9HGhgZzRlyHdsWm3a1N4cjR0biMrA6Yu/Gr5MYEflyavhMlCKS1q12tO5DYqn7iMcAK423Bup1xRAKEX3llnd5XgV31NsE0q3o9it6NmeyEUnzdbV+x7zZOo6Vy772bRX+Kdqm4sDe713fRxwx5fTKJjMV7gTrAGRlPmdPvV9NDpnfzgxeUHotuDYSqzjK6DYOhgQpAbenDmDniChvK+ifigihx00wTs0tcabSKLmiC70jAddsdWBpcy3WZRT4MdzEcfywXvj/AKpib+poS95w1d8X6BMpZ+MJZRcE8JCqbjoTuxCD3sBjJVOn+VQOqZfglZnuWf5LdHo16NmKjx3X/RAkvdp4ArG5JY72gVhHXHPVyPVt39nAHH0LauFeItYwEre/mQxg3mUKLumhoOq3MVIfcLBTrptt+/GhO0K6Cp4DuaHQq7Y5liNj3nmsMQ3FbKTW1Qn7d0LD2YSWV3EvoSBV68MhLHAl2sIOBZdr5kU9KSOYV39TaQj+A+CEJ274jNLUV4TrT9bTyV5hob8
 LWjwNis4
 Y6RJ941/Kaj6SUU65x7IHVRSfavaf9AE+5lntNVZZYEgz0FOkuoSWc/26AAVv3H912udSP3uEx2lDyP6voVaRO5TKZqfIpNLpUbN6Rxdv/4IJruNbh9VWiNMHcOho62/g5g0v1jUMduuXPGuhUx/EzWHPXpDcYDR8f8CopylfQOazl4hh2bCRAEb2/lIkBWtCHXqomqj2HMmTEXPNX/fdsXbv8ImiOYqIYKC9TZ+QizmuAaBP969K7aynzUTy8eBzMFv79ydD9uIwawkoNIkGDBeexmFFrMrr9SZN7qUx0VjaZKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:08:58AM +0200, David Hildenbrand (Arm) wrote:
> On 8/26/26 10:07, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 26, 2026 at 09:57:05AM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/26/26 04:44, Vernon Yang wrote:
> >>>
> >>> When the `xas_for_each()` iteration to terminate and the folio operation
> >>> preceding is normal, but pfn will be incorrect.
> >>
> >> The PFN is only relevant when a folio participated in the failure. Maybe the
> >> following would be cleanest?
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 75639298efc27..371ee0b16d10c 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct
> >> mm_struct *mm,
> >>         int present, swap;
> >>         int node = NUMA_NO_NODE;
> >>         enum scan_result result = SCAN_SUCCEED;
> >> +       unsigned long problematic_pfn = -1;
> >
> > I find this name... problematic :)
>
> Elaborate.

It's overly long, I read it and am confused as to what is 'problematic' or not,
it reads weirdly in English and pfn_xxx is the usual convention for naming of
pfn's anyway.

I made a suggestion in the reply as to how to refactor this to avoid the need
for assigning the name like that anyway, if you branch the result ==
SCAN_SUCCEED then it's implied.

I did wonder about pfn_folio but then that's confusing wrt the function, maybe
pfn_fail if you really want the name not to be pfn.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

