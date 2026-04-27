Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83377FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6856B0005; Mon, 27 Apr 2026 05:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CCE6B0088; Mon, 27 Apr 2026 05:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB49E6B008A; Mon, 27 Apr 2026 05:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C934B6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:02:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69EDF407D9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:02:59 +0000 (UTC)
X-FDA: 84703746078.27.DC739D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9020040008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:02:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7OC+bA9;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777280577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K9hSDj3qOWcD40GbOfOAjuH5bh6JAGNRgKzvnVNLl8=;
	b=kAazzSFbFs45hBYSbphYiN7UaN06Hv7lBlP+aOJ9PME/unGg6CURWwCvNKZn7vc4p4c2sa
	HEV3eKZymMcIBnSAFN9u+k8+6I0TehH24kGkGgN/3ulCd7NC/9mQLZ/w06Rpi86Eq2HXHZ
	9Oq0WbFbg/dssIK9ppSZnhAyA9gkHUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777280577; a=rsa-sha256;
	cv=none;
	b=fPxS3ufmoPTxBhLEXlwBQPKbtYYAt9ug9JHo2ZGitviWmqDyHRPpgsfmLkH5kfB4Iy6JkQ
	YiZBUiF3aIUBdBF/rpfZuqkAh4PlCkECJLZmHNynEs4nmJLkdE8Ot8rZNMHsdWz+pYsUN2
	/JIIhqPg/jGg98wgs6BKk8ythBMnqvE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7OC+bA9;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DD1543D82;
	Mon, 27 Apr 2026 09:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ADDC2BCB8;
	Mon, 27 Apr 2026 09:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280576;
	bh=wy/P39pQu9CaZ8geWArqNl3zzbwhV+vR+8sJLe05890=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R7OC+bA99ctkDyeRAb0p7Lgp2eukG7MR2xNPuMwyaYvUtoSOole8/rtRG50kNqGgg
	 qwCzQ4prrx3lS75jyF70qfCYRg24/RsNKGyLNAJQehTk8TxxFqVJpXKvnM2DNQn2Pz
	 TsKcQQITzo+ejHHF5etfd7/QVHr7Q9KdzJOyA28sTKll7Xe5suu5sylKc3NEQmOsLl
	 UybVepF43lh5cxDUpcW0E7OzYK9MKD5almH+qNP1ANsXefb9KHU98ExrQUqUrHWKJH
	 dalubLruZlmy9oNt78mDSnLPsbw5t/oocDg2uv9qFalsyscYLElLE75eIGRY1iB7hd
	 KH6GIgM4UrbHg==
Message-ID: <69c4c12c-7cdc-4a17-9eb7-6fb1a61f9834@kernel.org>
Date: Mon, 27 Apr 2026 11:02:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260427052000.196402-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9020040008
X-Stat-Signature: wt8cm8x4zwudwy5moeiexy8p8859ewy6
X-Rspam-User: 
X-HE-Tag: 1777280577-37437
X-HE-Meta: U2FsdGVkX19PnDmtzf70gCt//FKwhoMo2t/V2TvuD0PM+/AcyLAKH7X8Uj2nrlQPlFxj8VYwbLQakQzGDFarEn5Y3H8mwaAG0EbFEGRZCIOOJDRovgjF4EdvTXyVi4pF7CWkzMMz7cW1EXnXQGBauPJUH69txNcUwNIAEP5NEiKPd7thBz69Fd4ml7JZ319zwbO9c0Pviroussyjqzf5OXyRNA1U4pO9yY+Dpg4NnWhwQEceHaIWggMHUdQbyH5DgnEiOOyWWA9N22I+sCJ5J1gVTjHgcbprJNKazunZbJWWsc+2vlt2SWjrSEhYHL4b3HAJLoWoYupjBEt2HSr1ZMOsrzShv/8wysgIXLHI4clTqULYkKqKO9XhxjoYAMrppM77ut47DRuHZqZsqsbVZnEBjlAbXgjVE6NgC6h1exWyxo4blWf257vpIB1VLaqb//IOhezX6jEqQ1cT/EBmz4uSkvXeyhfOnYx0UyYCnFsG257/7VIh3rVPmF/wYiW37AMll5eoY9aA8w+UmOfnQ1zvH9d9FalL+pqQLoVMYVPeBaD8GW7uKXUDV1C+X5BTosjMHF7d2TjLfDLuEvLCcKK5FnH6vGKc8tsWcUdiD1LyuCsD58G7Zu7oBVh8iPs3ELw2XZ4SvEjM+Gk/72rPUZhPa89ZZOJfcawXe6GBAXoQoKF10KMAgmgienjJD3kXGlpzSNyssDo3xZiURVuMGCWbGC+DCbz1xteB87p0dsufRcmVcyHJ+zzgJUKck8583HKdiFvyWh8FxL/Jvx6LEIKNZATFwkk8IQ2GgEAwz/NHnJDae1M3H5GIEReHFWflqC0s5BsX6B6d5UzaYxhEeD1ahg05eJiXT4xAtLYQU9vfY9K+GuU8Tn6IwI2aNbbBnq3RKi3R14dPDOW6Uo2JfvDHXGbMIrtSkoh0HKVAdhTIf93/gCwcsUuq9LMwQ7gFp/0mAyOlGh+t/wl0/Ia
 tD2lI/0T
 gidupVHMnQix/NHMoi/jTzYrTHEvjtA6KzRbVXA91zONOAu5DgvcPfz2AepiVODgjW5ZjTyzuMYgxtE4y1q3YassLXSfpSj5RZvC6kjIE/CZ64pVW631rK+azqxHrx1tWfhKLohcP9qTO4N1Ud64yEXlk3lSUt1b1CIkKLxNA8anjg0ZID36aPg3s7GFg5uct67kiGfSxoqFMvA118zAqxxj/i+cLcLPGkQysY7yZwKvj4oaGdnBe73w2Fa5IQNxbRwmGtKswQ2BUgpxUdxDZneYyfwzdu2/OVXY/a5KVO9AsdpdIzYm+eGy6i2CYQ5VFNBqSLmFq4CL2wQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 07:20, Alexander Gordeev wrote:
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

Wasn't there a problem with folded page tables, where we would no longer be able
to optimize out the folded page table accesses?

I thought we discussed ways to resolve that. Let me dig ...

-- 
Cheers,

David

