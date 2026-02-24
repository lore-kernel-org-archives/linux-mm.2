Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE0CE9B24B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F4E6B0088; Tue, 24 Feb 2026 05:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCE76B0089; Tue, 24 Feb 2026 05:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAE36B008A; Tue, 24 Feb 2026 05:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E416B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:08:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2F221B678B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:08:31 +0000 (UTC)
X-FDA: 84478925622.12.DCB9887
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3ED41A0004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:08:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771927710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZQZhFCQRs3FRpnRYHy4Ear07Y00uoEUsCQ9F2s8RQ0=;
	b=i/sKAbgQlL1sLrn+RIUCaOLURBH1HvtS3FD3afqS9dpkQOM8HbsePqd8lD3819LWNOOH+i
	dgg4EA5Wo5T35wnuQpodgp0n+G4wEtvUxd2lP+qiCRTdJ3YO5/ocFlJYqfFNdqZz+Aa7Tk
	nVqWq1gE9L4z43U0rEpydAQUkWZF4kU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771927710; a=rsa-sha256;
	cv=none;
	b=TF/cJlyXYAq8BCEGVOLD+Ji8x28BquL1Mk7ROBTbZSmuLUmbfzNzeZwe7IvSDyOaFdBcw7
	RE9nTtOnovfKKofClJ1SFlX6359tYYq/BFBonYBnI8hLiYqGfBlqrFHkwujuTslG0rslTt
	PcyJY/8cRASrt9GxIKsj4YCDJIeOrXo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96CE2339;
	Tue, 24 Feb 2026 02:08:22 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AF0B3F62B;
	Tue, 24 Feb 2026 02:08:26 -0800 (PST)
Date: Tue, 24 Feb 2026 10:08:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
Message-ID: <aZ14lUwuA86aiOH-@J2N7QTR9R3>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051153.3150613-5-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3ED41A0004
X-Stat-Signature: 713gtdqk1jmgogbtrwd5h46wpmf1i56r
X-HE-Tag: 1771927709-81174
X-HE-Meta: U2FsdGVkX18OPqGGxMPZYSKqQMGVZ1plcGSHvKwiYRoR+F8QsJCyvXq470Oi04FHc1iI5GUDxU1L+61Lxmf73v6d7E/+bv171gLhP1K0pgN230YUDtzFttghpUUy4TAXvsK1opyyyq5H+Gwg9quy8IM/lGdU75DAJ7PlSVAE2L3dhqa5z8Z2YU4UPAA+YHQt/20UjV7uZJ6eJbXwr2MSpODaa3JDbr6h/ElAZ6SsmHihZOyZ1UYc+GFf1Bwo7Di+me6R9SkOdLegi47mtoHbO9cnv0XveCZ3NP3ASI0izx8++RkF0NBDCqQfaep+7lOikR4DQR2krTqfMEoTyiiEo/msFSTAzfFfcFCn9a0W3g8mJF9jbFzGmrLp5MJairZ5OajEKhpxAkom6IhJM4iGan0bYVquw15vkCWleAcs8E3Ke0rruFZJiXCUhiqzhQjPpULnu33Pq8NacuU6PuQ1Qpk3vXDtr2jxVD+TUFzC7htvsbBCtIbPZrGAtCEo+ztBEusEVj9Af48gA3aMBoLgXfVE9AliZsVuztwhD+lxhh2MrlEDb7jjGBzJis86/8hBVbkW6CYej/jx7M1viz/U9cGWD7mj7pZwTiEQII771XzXYWy4N4R50M5lYRQe7cHlF5MlTGieyRWedGRotG/RTwRxRgVHWJFmQprRY8Saxo89mqi6LYJsbI4P5o1qD3YOhWHPbrx9fYBsuYBEV56/+/2mklsalh11CO0tOf54VrnOERfsCcUls1zLc5BYuxKEQ7k9GbhBk6g7bXHrhB1jKtl4rZGKU3IVG6IfdEcn1Hl5L8vLpKXak80QHLoXDV8ZXuRYiu7UIK1giV/59vIWoYM6suBsKvJYBYhvoTFfXaZirQSJiJBXvVuLbVMKjMA5+aXSgF8RMY7+TnABaQ7yIPmyBjjEvaDDpzx4v3CO/37jtTWV4c3sOOl2+GbZVgZyu1+Yb/v0P+ecP7GpJT1
 gtZHXpEh
 pXEPKLvwIbmPYBizcB8F7OG4KEeqo7RBBkeZyc3ScA5EzdmKo1k6nmJL6gmGPaBSLDHcvZNoBxvDt7G+KNi0qtREfXrY9Ws1zDuvhfrs7aqDnxKB7lLKRRfUEV5oOlzhTpQyF0W9OkfuSBi5TflHV3jRN8kT7zhMJc1KSwoi61OpClU1hR1d4LxTQawzHm/SVb0eCWnD7wvt0Ng5s0yc5JsP9I3DKlXOh5ZVGVTKN0/wlRUEhu6uKxErk8edGKx3eetPJhVAeP1H4hPqc1BWAFVfOqJbYXHLqz5qyLkNPV61EEqfxHfHmX2aIzgHrbOqDRDzCoHu1SQCqPYGA07B2jwYwYTGrsyFX8q2i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform do not override.

For each of the patches where you make this sort of change, please
explain in the commit message *why* it is necessary to do this.

IIUC the entire point of this is that in subsequent patches, arm64 will
need to use something other than READ_ONCE() for all pXX levels in order
to support D128 translation tables.

Spelling that out in the commit message makes it much easier for
reviewers to see what's going on, and to focus any discussion/questions,
e.g. *why* won't READ_ONCE() work?

Mark.

> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  kernel/events/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ac70d68217b6..4ee151cd2c6d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8422,7 +8422,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  	pte_t *ptep, pte;
>  
>  	pgdp = pgd_offset(mm, addr);
> -	pgd = READ_ONCE(*pgdp);
> +	pgd = pgdp_get(pgdp);
>  	if (pgd_none(pgd))
>  		return 0;
>  
> @@ -8430,7 +8430,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return pgd_leaf_size(pgd);
>  
>  	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
> -	p4d = READ_ONCE(*p4dp);
> +	p4d = p4dp_get(p4dp);
>  	if (!p4d_present(p4d))
>  		return 0;
>  
> @@ -8438,7 +8438,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return p4d_leaf_size(p4d);
>  
>  	pudp = pud_offset_lockless(p4dp, p4d, addr);
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>  	if (!pud_present(pud))
>  		return 0;
>  
> -- 
> 2.43.0
> 

