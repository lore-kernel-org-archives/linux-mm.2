Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B562CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2508E0034; Tue, 19 Aug 2025 06:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0931F8E0001; Tue, 19 Aug 2025 06:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11DA8E0034; Tue, 19 Aug 2025 06:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE0778E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:39:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77B58C075A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:39:29 +0000 (UTC)
X-FDA: 83793160458.01.CB9D5A3
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AE59C000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:39:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q7pHrA4j;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUo/E7MX7ZlLeG9dbgUOO6MiVIKVlTr9fiPY+zyrs9I=;
	b=NngdWvvq2bzMIsbnkZ9FJEI9yD8BsgwxBTD2qAsR0exxjRo7qwUGUlsAW3ZWJ6/qqLvKs4
	c3SoRzFmHIq42gez8v3GUzUX87xlPMkLD2+1iNjWw0C7pIMzj8Uh6sYZiS1GM4Xh4fYDDP
	b/19jVzQKggZHxwThfhqm1VwAAGqPVg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q7pHrA4j;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599968; a=rsa-sha256;
	cv=none;
	b=R0yjuRhW+xv2vf4j94LXvwUVZ5dGrTj/2RgN0rOBV9xcxlf9HaI1xKOqemwqHkN452l4Ms
	oXspWkBL197LGY9IbY/H7Yo73sHJ8FARD4v+h9aqLJ1eL6He8ghIxUovQDqlywV6Q4K1t5
	prX8Ga+97nBuspzJuAPgdPyi5CLw1hU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id E00AA5C5C85;
	Tue, 19 Aug 2025 10:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B851EC4CEF1;
	Tue, 19 Aug 2025 10:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755599964;
	bh=C3p/9tmSjjIf5jIYjuZ3vrujwfpwDa8Gx8cZIkEqXH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q7pHrA4jSdouObZRf5BBF4zPfFQZpkvTr3HvXjroPz2apoCJKu9JXovzqRcsFf2zN
	 RxUoa8NbRRdr+TQxroiXzSSImFDGYRFd3fxbcgibPcZAOQIVuNyg8Qh4uyYi1dxYBz
	 rvH9cUP3sb7qPSGDLzYXl9D42w/VOc/OEXmeItlziBzmo9eXB/mBjs+as+69qT+TvM
	 PZ57tEyT75kHH2htMbXdQEBacH8gEEzvLTZBjZTHxE6rLef9y8O7V+klQjdwQ8j833
	 ar1xQpPVlR9PmVzi5Z05JRXWCQyaAdvGXwOTjOpFCgZ/dZ8+r0XKu2dkuM9/2UWmbv
	 InJbnYCAV2UUA==
Date: Tue, 19 Aug 2025 13:39:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 3/4] mm/mm_init: drop deferred_init_maxorder()
Message-ID: <aKRUUzq48xW5qPOp@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-4-rppt@kernel.org>
 <408d7eaa-5aea-4490-9fd0-978c4eb94d32@redhat.com>
 <20250819092254.cddlg6npwl75fvbn@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819092254.cddlg6npwl75fvbn@master>
X-Rspamd-Queue-Id: 0AE59C000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d7p3yuxgpqhm3tu57brcty5i7d5px8ke
X-HE-Tag: 1755599967-924223
X-HE-Meta: U2FsdGVkX1/t+pS/q8FP1rAu6LeoWQYSdC8FDV3Cb6vF8YM/QyIaroKxr6f4I8mV5sPCyCgUw7vMCXuU2uBWVaxQYkOHUWbB4WWyiv/dsgLR0tJ4icK7nxwGlJW2cPUhsaEWAmjHC0+gd/aaTqPDkmRlTAPhk8B3+mslnLFlxX2G6/QlPWuo09gx35Vai9khnL2Gm3ohayZS5Wz05phTMn2IYUQ6Uhij+K1oVUxXH9fW6a1NVc2N7aiZ2raAOeaXzOVZ+nwppzj412i5oYy/x1EtNN4HYwGNFwBjoQbPhvuh/X2nUna7q9o9C3KJ+6sn7B8fz8jgdPc/y+ugbKT0hLPRu8i+//J50qDK/FfK/Xx8uijrH6NLxz0iISSa51Q8x2/k+VzcqTKhraRB4qH2TWG/2DVFFiFbkyQTG+YTBfNaOA5xJYJAWYoub0dKH1klwM8eM9bZNuM/vxCXnMNromlBdzl+OLMOiq6d1vIi1yLKPsw9dZe2YLxk3EADwjfHYow17x5jyWjXFDKVQmleRDsWnUx1GYSxDyNnKeM9qoWFVz++mupumCBWc7BuXKD168SBLb55Kl3hFNBMVItCMgrDxIMdazCOw6wO6q95p0Vvd54/bX3x8qqu8q1U4kEA3rYkHQbk7QWFZIYrKuTjmbBJjrjq68h+/cqFLpzkdKak9Vdo9qEUqlu7u6X3BX33HTTYwKfG0SDDi5rvcD6Abj6C+D5LzRR2XZXdUhrHJLhUMj5Nx79EALde8oLTAnV1N/F+I/Q93KfirhTkd98UkCwoT0bkH9UE5cbpxtb85m7OmySvRWGq2TRjOZCvqWQ4OK6KtVBO+sW1ZrWv89yIPX+om/qyvP/tqHoIprbLqVou/rsLOH2+WnM6jWtR7hTNRuTn/cYT/Uu2Z6qPNkMEj0zoIBDOsgEI+ie6+AIVkfvomQUL4w+5GQDyFTnR3tCfnUXgItYdoKMQl+73G/F
 C5m3qomR
 KnNAPFE9Mucm1k79dy8hJTeyNFQbVK7bCPupXqqvel9er5puCYaVHK9ZkpFqpHWjvUlbud4GX4QROn8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 09:22:54AM +0000, Wei Yang wrote:
> On Tue, Aug 19, 2025 at 09:54:22AM +0200, David Hildenbrand wrote:
> >> -static unsigned long __init
> >> -deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> >> -			   struct zone *zone)
> >> -{
> >> -	unsigned long nr_pages = 0;
> >> -	unsigned long spfn, epfn;
> >> -	u64 i = 0;
> >> +		while (spfn < epfn) {
> >> +			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
> >> +			unsigned long chunk_end = min(mo_pfn, epfn);
> >> -	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
> >> +			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
> >> +			deferred_free_pages(spfn, chunk_end - spfn);
> >
> >
> >I assume the expectation is that all PFNs in the start_pfn -> end_pfn range
> >will go to this zone, correct?
> 
> I think so.
> 
> defer_init only apply to the highest zone in one node.

Right, we defer initialization of last zone in every node and there is a
thread per node that does the initialization.

-- 
Sincerely yours,
Mike.

