Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B2CCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA6A8E005B; Wed,  8 Oct 2025 22:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB428E0002; Wed,  8 Oct 2025 22:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299C58E005B; Wed,  8 Oct 2025 22:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 171DD8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:03:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D27201A0884
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:03:13 +0000 (UTC)
X-FDA: 83976928266.05.FD01DD8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id D999040005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:03:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xp9YWhOQ7C5kg/scVIQrKgu6iiKmSBvthLq5t2UYrco=;
	b=20jtezZ1fIezLxEcTx+h6IpaZ1A4lmzHQxJ7vODm+bBH61rF3yHmGYrIhVefhk79G7hYV5
	IZ0YLgqFzXhD8hVD0jmln7xFusmXaPFasJfxg9xXjLugBC7mACehHgEYIE7Z1Mxlh2r1rc
	AcNNDq7f9QjCRFMln05DYqOteOtjyEk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975392; a=rsa-sha256;
	cv=none;
	b=O491zdfHxA5ejIxRAW9c6occVunnbX1o1vnLaURhJ5BVbUcHO/PY9SkK7BuAluti+nQJpo
	Yv0ueevpTQGi9VsClYkJbHKsc28UoBsuZPvqIEeYYyKHzr/JGMep48stPTyajvd4xnBS8j
	p4s3Vyvrr7YT3L7my/Nmqv3e0h+4lbg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5AFA1A32;
	Wed,  8 Oct 2025 19:03:02 -0700 (PDT)
Received: from [10.163.35.84] (unknown [10.163.35.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E94173F738;
	Wed,  8 Oct 2025 19:03:06 -0700 (PDT)
Message-ID: <24beaa64-d144-42c3-945f-a37e1cac384d@arm.com>
Date: Thu, 9 Oct 2025 07:33:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/18] perf/core: Replace READ_ONCE() with standard
 page table accessors
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Conor Dooley <conor@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-3-samuel.holland@sifive.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251009015839.3460231-3-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mmwij5sead4skpzhrfctb9qac5snz1s3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D999040005
X-HE-Tag: 1759975391-507176
X-HE-Meta: U2FsdGVkX18qRv16Y2diZ2ETpScfzWQxjKTZjIqgGvrsF9p7eYzNAwAU+Z+nw15b3i5PSHvIFaVmRxHMCkwQ3cnpflaT8l2dWyx6Srhv0XrDw9ds3/diIz5d2Iv49WJFTg1M4Mgk9IPgQa+f6xZmkRymyCvGGBVhoYOewq7iGpJWkwZeJX3di/zdMfltPgFK4zv7qhB0gibAdVu50B9ISaz7hruxZnE9CMtGXuQEuPf5XRFIyUVBWo2LWDxFSaGhr+45yKJKd3zcmm4zRfgesikUucavhvhvGGnZolXf1En6tUWBYzoMpWSjjmldcW4FjJ33LkkOAt8HKfTV4VbNYFK6EY4JYF/ElpSFmH0rAwspdC5T9q816J6Pv9oMLqbuZuvl7aRxk5cdVoMLz/9R/cM13aQ34RwGfRua+B50pi6RQwIuRlQruHc5+da2LIgBfRyBMvAEikU3EK1V9l7rbR7AngmJQ+Xu3srRryz+uQqs83OyJY9VCeWWK0sy9DENGA4ljs7N6xWsul1o7ARupYb1mFzfI5aj3Ft35lTctJW3SZofScO6LqThgxzkvnbXWjH2rlDLbdRIwFwb4zLofB+LxDNvdcaea4K2bVPjR0mmIUErSvN9MogYiBXqHwqwc2wI6QWpXjdi7KRZ1NUnxXKmizVbat0sCc1d/ihLDLGtbsnCfDL/hwZ3FTtoxSaNLRDaEfIpeApCHtAQvBz7Vp3ji7ZtsvTTinvV+KldoUZm7hL4d/Ey7w48wUdlMoUq0hIQI/REjt2m2TFsicE0eJXEDlUVBeAUqWiTnzWSamsIhad206l1SIFwPVEug0E7t/p/FDPBP0niIu840T+H4IWkDcJFOIrjT1h8aZrg11IPhXvYCtbxDKeeBYgOrgQK2Xe17qTVNU6W0BSoEzTkNSxPOQz553RTppepBDW0zMlnTpTUPXpNiYPMJ9RKaBRfRQ/S3GG8WKeKpi+4fgP
 t8T3Cb2/
 mGKPaCYDTtMUr71RPGHh2vHdKLbakS8wgnms0KRfhNi+LeLhx/+/yfp0zepiAx3QlKaR3f2FuTuXScaj1sqf3Zd6bfIorU9uWd2WQz8mHy23xmvx/NBz0XoCU4EwCZ1Wa2Al1I8mSvIJ07VhwIAOeL0ci0GsS9FJf4QnzX/ch22P63QDmeWBijuiEnSU22k3GdFN6M+aKmVcHc9dto/8BGmsKN2v1c5COd0PFrPiK0ORmS72bJIwpv0UjNvqIW0YSV6hlMKoP2sR/rIpo9acFq6JeUgOJrMKomIOPh5uZj1oqSYnwRBkfTDwWSuV3GvD+LBIg2pphrpnKV/fKG7Io4QlQkhlcu+usoEHDLoTUvss1ZA+tIu9FOxIU1J/iv4wFTn6ksZw+kKnFt+GjM6Py2rkQWrK7qP3k84BCs2SqbntyCtkSnMsefra0PFxYSNGLA/Hh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/10/25 7:27 AM, Samuel Holland wrote:
> Replace READ_ONCE() with standard page table accessors, i.e. pXXp_get(),
> which have a default implementation of READ_ONCE() if the architecture
> does not override them.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
> Changes in v2:
>  - New patch for v2
> 
>  kernel/events/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 820127536e62b..952ba4e3d8815 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8110,7 +8110,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  	pte_t *ptep, pte;
>  
>  	pgdp = pgd_offset(mm, addr);
> -	pgd = READ_ONCE(*pgdp);
> +	pgd = pgdp_get(pgdp);
>  	if (pgd_none(pgd))
>  		return 0;
>  
> @@ -8118,7 +8118,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return pgd_leaf_size(pgd);
>  
>  	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
> -	p4d = READ_ONCE(*p4dp);
> +	p4d = p4dp_get(p4dp);
>  	if (!p4d_present(p4d))
>  		return 0;
>  
> @@ -8126,7 +8126,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return p4d_leaf_size(p4d);
>  
>  	pudp = pud_offset_lockless(p4dp, p4d, addr);
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>  	if (!pud_present(pud))
>  		return 0;
>  

This is already under discussion here.

https://lore.kernel.org/all/20251006042622.1743675-1-anshuman.khandual@arm.com/


