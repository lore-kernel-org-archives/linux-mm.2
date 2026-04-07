Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4D9FB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5A16B0088; Mon,  6 Apr 2026 23:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757046B0089; Mon,  6 Apr 2026 23:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C926B008A; Mon,  6 Apr 2026 23:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 565756B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:28:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD91A8C0E7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:28:56 +0000 (UTC)
X-FDA: 84630328272.19.D72A540
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A20640006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:28:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J8sN6vHT;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775532535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ne7ER4wy4Jl5TRr+P2TDdubMY/wDGQsCieUqEyE32e0=;
	b=ay5/JzWwuhlzYAefLwhaDIYN+b6C1RSxtWecwxhBaRu9bDfck8IGqyihiOCRh4KCyfO81w
	4dTzAs+mvmMtBO9CLSIT3sEsZlOH4eVBs6UaHe1R72DIJ/w/b79rHJqIdMPEhBN7GE4i2r
	uzYiIr7M/jePby3pxP1gXhHEvbv1y4c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J8sN6vHT;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775532535; a=rsa-sha256;
	cv=none;
	b=epMYaPqX9lHbsFtATtMrx6DZSh1gGajotyOHXSzFWYHglZ7L9qivNwYNcsfPpmQx8/+eZh
	H4e5Md7Tb+negC3ON0Ywmgirpa3fRUxOlQ9tOJcA64y18zgxe7Sn+KD7Qrik1gxFVmf7NZ
	NMM1S+OBWPSNdMzlmWQOwunwr6o6eyw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DCE22ECB;
	Mon,  6 Apr 2026 20:28:47 -0700 (PDT)
Received: from [10.164.18.83] (unknown [10.164.18.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03EC03F7D8;
	Mon,  6 Apr 2026 20:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775532533; bh=rGxJ/GFPxD1fTxFc6L3HZVbz/GVhPSIOf5Qf+kTZAcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J8sN6vHT6wwFlL7w+ibtbyy+RquT3UJgu31Rqk6lPgGMfOEtwfVy0CDOl0+tf2hL+
	 P+5722EfEjo8+QgJZlfBEyhlP2lqjI1tiMA8hoLKpVioc1QG7k/fkkQDQpBfWRMEwE
	 TiXiGNaYeB1yOH41Pu6Vrltn9LQFfwVlfj8zKXSQ=
Message-ID: <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
Date: Tue, 7 Apr 2026 08:58:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260227062744.2215491-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g5myogyn8zcue11suxoj9jn8jzmmsqwu
X-Rspamd-Queue-Id: 6A20640006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775532534-421646
X-HE-Meta: U2FsdGVkX18BosvmMvGSjOpBaP4YBYeRKTKG8YKPw78Qc2d/f0nejTDbh62dlV/totT0+wvMawxFh8u0tBJNEQ0flNHKYHRa++uNLElyXqsfPmkejSG7FT9yDrqboPuVjBcBCx6kkhlQmadigGx3xqrFhxAV9S+bd33KdTc+hioxyn1X4rZobe/vqZDSqU3U3zr2RwyKJLrl4ABW6YNi1OnVPOX5Cb+Gn79XvyFpb9rM2m4xBwGO9JPX71PAIEu1OWERqyrv3AwnBG5j8x8OeMk4JPrITL8Epr01XNrhjBgzmDVSKea7q1skmfF3rRq0LnP5yLTHb+dAWStJC80bnRnO83AEdOmYIzMnxPCo2f2fwvYNTvoKfIqT+NKlA9bCAdS5mqTFBYGl3tRZAMgHO8SSVpwALeuqGrb+Yy8/vEHDzNG0ynP+Tmvu10OS3tCNcIvjD+n1RFhlwKE5bxA5JDX4SttUkbREocpg/o4Mp+ogk9z6f3rySHHnos20rD6gZzNY7cSXVc+BhFoKPwx9hpgMN2MvQMNIE7NDw9UqlrlWgXlRdR6xyc2WgDJsfc9Oo184JBz7qM7NuP2NlQC2pWhp/P2OesFUR5lFWkY5tbBT1Rsu5ehHI1MABmkQol6W7dotSc/d4cC9ByyhSHQENg3Hwyi+BOAWALhWC8WXStB9UUiFYl/GPgboF++o3UKXaIwgcJFQNOwjC/dqwBbQvr18RMoQKA2SAYno3Ush9WvqxrsRg59aeAKvoeoLwebpIrpXjU10jsJ2pl98r9hGxUuhbf+aVK/6tZumJgzYyRdqyL2CR8qfaG5QHc1I/6xE2elGQovA8ijh1CqK4kIKi3nUnZ1kUxRpv92/ZtjhiBjGKkipHwnDye6XLFzvFxxbmFSF7QjmFPm71HCqVrYEK9WC36pGzbI2J33d9xj+s02D/hVugkhvYi4cbmQ+vhMUpaG2+1ar5/EzjRGxXsk
 Jk9fPgYU
 w/MaIaME+C0lyTH1yF3MA/RrnuzduEtTkqWzxnhDz8KzqMTybmFqm5j9KIOCjZzx8TcAS3Od3qvIeFZk/68FVb9nBf2C1HdMHWqahja5q+mBbVy+2DPrcLtnimnLblhyPyeWO0B4i6zb4agCk6pECgN4Q0YOcCUswJLXod20rlAHrEUvWWs4IUn4TxNJHbv3ZZBDFNbgbQmnkXcl0BQNqFRQJIWfG1LmGQF4An9BblPvJFQXP9oaZ8PRw3J64SZAA8YP1T1Ew3n2BM+16/rIqSsUTNBRDKCZCmAPmw/O6NVjb0wcvDJ92ANN2/8bJ2u8tBfQraO+4cz0vn83Fqg9/7scSXOjpmcjQbe9DtECbeuVr65oCilRdnEDsATAzdCNQEv8n0I0HXUJ/RE1F4xnEN9BiMwjHRUsE9pauBH127DQhTWvIe0JkV7rmVm/qQsv/J2THbK2RDYwJE8tXi1IpyVtB4CMJXthZbIXpjoN56pWClU23wP+kagamsuR/2HGSsRzOHyjHJx4FHryQR+mYR9hfaRBFgzqcRxzyjZ6i2+BJ6Au9N/YJ2vjy4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/02/26 11:57 AM, Anshuman Khandual wrote:
> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> accessors default to READ_ONCE() on platforms that don't override them. So
> there is no functional change on such platforms.
> 
> However arm64 platform is being extended to support 128 bit page tables via
> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> provide required single copy atomic access for 128 bit page table entries.
> Although pxdp_get() accessors can later be overridden on arm64 platform to
> extend required single copy atomicity support on 128 bit entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies both on v7.0-rc1 and mm-unstable.
> 
> Part of the D128 series but independent. Hence could be considered on its own.
> 
> https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/
> 
> Collected Peter's tag from an off list conversation.

Gentle ping. 

Still don't see this patch in latest next-20260406. Hence just
wondering which tree and branch this patch is being picked up ?

Thank you

- Anshuman
  
> 
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


