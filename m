Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00903FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE536B008A; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B43B6B0093; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D3C6B0093; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 393856B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E25268C391
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:47 +0000 (UTC)
X-FDA: 84703254174.11.1DADC6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id B180D40005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pef69yLT;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777268866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygQv3cd/d6ZnzPpLtGgPiea5e9G4tp+RhrNmKE3qxDU=;
	b=S6b2BVnejnOy+5HuZwOYoARlLCqxS3p9eJzLdch2Jj5QzIgqS84hpwZ9hWDeNRtbHvP/Ee
	baoqn/NLlWM5YhyjmR1uacory3NpvKH8zoxVvHo5XQbknzEQHjCMq6CjDL8Zazz3Fdcz22
	7u58/A1TpemZXUJaLifjjytbnoZ9eMA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pef69yLT;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777268866; a=rsa-sha256;
	cv=none;
	b=28LgmwoCEqA0h0Ovn7DkZvh5bR1q9deOyOlSs4RSTVlsnPDQEoXny3zwtcI/uV5ct9LHjL
	uwsAePFjPM9qYQs8woYPgzNK2HQsTF61YRXQVpPjsKU0dd1Llg/H76C4VD3HDhVqLmBBCZ
	a+RBsZCzVcgfffFagCmjUjY8fvSrXzM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B8E6201B;
	Sun, 26 Apr 2026 22:47:39 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 964703F763;
	Sun, 26 Apr 2026 22:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777268864; bh=ngRPe+T8+pfMcyU8uwuNPQvzrwRnanR3vGyANQFeZgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pef69yLTqmqAHGJ71C93lPlB3Su8jASuYyUAC2fCmHsuHgLe9jDusMtbS5I9SKGPc
	 36hXyuk7pVOs4J03x9phVIpvlzkpLz/F4HScu7DBaZ0WkFBgrf8mG0D8+t49bDN903
	 eJhc1vifL1Tr4x71vI6SyZPddxbFoe68Iyk4+m7Q=
Message-ID: <c132e0b3-ff1f-496e-aac5-3d65848dc324@arm.com>
Date: Mon, 27 Apr 2026 11:17:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260427052000.196402-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B180D40005
X-Rspam-User: 
X-Stat-Signature: xg9kco593dueyw4yzxzotpfymybtckjd
X-HE-Tag: 1777268865-482166
X-HE-Meta: U2FsdGVkX1/99ONhm6nmnxAnxl03PXzJYhyDVadqjH7zMSwAYA+4TnJxZJT+47ret5z456rjA45BuQo/GvDgZWNK1qr4Du53ymcM/RdI7ebUQg8dNYBIiAqcFc8EUAsyg2UpWJGyBI4r0R9vCxd015pd27dIFtnoRibyfL5vh2Gjef/m8fgxZ3RHLI0xpjYLxSimIZBNhgtRc9FbM02jgtAb9NzHr+9+ne1j6XxcWMTD7Cz026KUJRHOjPzg0UxmSJvPVHSzeFkJT6fExbjsq/5z9Gk0QTPWMI2C9xmgHomeYmZIDwiM1S3g20ySXhDA2Zt/vKZIkPyjeYBuJ/U27kNdzGYieVi0rOL3uBFa+4+i9XZXyglBe3sApghPygBbNamnd4hQn7emNzyHI+rWgzUNbs2vsGr3aHHS0j+y2nyEWMMsTlR+7rxlP5xsEb3w3J9Rj3itw/KE+lVJyv0rlH3yfR+t6fGwoKixEHhmdFCOkGdzG2Jy4IqPULFZ9I+L2OjmNAaApKUWcYFhiEiZWejp7QvzUVMIovtdfn3t5QUs+L0DCcXyk/78aNFGfl14p2cwow5V/PWWFwkPnYzfvbQBYfQmxHPGqtE0c+LC8Wxj7az2lDf0nX7LUn5KSkpfT14+eSqrt7uPHinhyQz9RkAE5M9OOIVDfIWKfr3/Vs85I3V885WnrAG34UmOap2FA/d9FtL0cSLe8uz75iN6MGOG78+DEC9XyDnEdWft7ZAPb/i+UrTMlC1zCuQYNIT81/C11ozQsRoVhwrZbo4W/AfSVvZ6BOmIvwkW0m4r0rCgoRQYoLEyjXNgZfPdk2ozMaX4gMf386HzRwtFDAY1bUzyy1VFsgRkcjuU7Ce5Jaqtf00nttkH6JEMZODfrE7YqwKbyGQC66QNr1dOvFhEhz7Ljnr4fbfbfEQU1lKQxs5cHmvMn6kOUnKlo2U5z7b4+I5aEN25mmFpF7gNoGt
 VLKk2L9k
 TMTdR8p5C80ooJ1bU7UaBAhNUdFwFBoGklhnQJByYx2NIjuNJxmnBejNhqu6WU/hULs6rsTWYTONEI2YORbtV0OMYsEpoEcjG8+MOF1cs9Ow1Hmga33zI0TH+ssdBrQDoZO6jCYBAdRbKcJv8/9OGdPv1+JuIx02gcBFx6z+PoLHtfX74phYCU1NtGM4EK29nv9o3WBUVUjK1jM4dGQl1i6WjmV8enGPvPD17S3A6nJzhljaTqU2+VVmI3z0V9BV5rLxaqHYFgPaQsTyUS31JnxYWF//S9km7i9gpqVmKOWBn53NwMmylrGnjkFTlTAcieTkLm0Uqc8qOXLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/04/26 10:50 AM, Alexander Gordeev wrote:
> Convert pgtable direct entry dereferences to the corresponding
> pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
> reads when no lock is taken.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/page_vma_mapped.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971..a4520bb10d2a 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>  	if (!pvmw->pte)
>  		return false;
>  
> -	ptent = ptep_get(pvmw->pte);
> +	ptent = ptep_get_lockless(pvmw->pte);
>  
>  	if (pte_none(ptent)) {
>  		return false;
> @@ -219,17 +219,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  restart:
>  	do {
>  		pgd = pgd_offset(mm, pvmw->address);
> -		if (!pgd_present(*pgd)) {
> +		if (!pgd_present(pgdp_get(pgd))) {
>  			step_forward(pvmw, PGDIR_SIZE);
>  			continue;
>  		}
>  		p4d = p4d_offset(pgd, pvmw->address);
> -		if (!p4d_present(*p4d)) {
> +		if (!p4d_present(p4dp_get(p4d))) {
>  			step_forward(pvmw, P4D_SIZE);
>  			continue;
>  		}
>  		pud = pud_offset(p4d, pvmw->address);
> -		if (!pud_present(*pud)) {
> +		if (!pud_present(pudp_get(pud))) {
>  			step_forward(pvmw, PUD_SIZE);
>  			continue;
>  		}
> @@ -244,7 +244,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  
>  		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -			pmde = *pvmw->pmd;
> +			pmde = pmdp_get(pvmw->pmd);
>  			if (!pmd_present(pmde)) {
>  				softleaf_t entry;
>  
> @@ -317,7 +317,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +		} while (pte_none(ptep_get_lockless(pvmw->pte)));
>  
>  		if (!pvmw->ptl) {
>  			spin_lock(ptl);

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

