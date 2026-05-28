Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77BD7CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800556B0005; Thu, 28 May 2026 07:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0C26B0088; Thu, 28 May 2026 07:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6696B008A; Thu, 28 May 2026 07:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDD16B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:24:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E02151207C0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:24:43 +0000 (UTC)
X-FDA: 84816596046.12.1CF8733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B7E44000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:24:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5V4HWOr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779967482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5hCo12AieiEvQS5ItXa2ui3IkPos7/8NxeCJceX1Y0=;
	b=7LgtlCn4WvzdvzpIqdPugozHVp/P5aO7jsVT/wN7qy58maSTheYAw7QjLCRUenn/kFw3PN
	Imo0DSwq2Ja5uoL5HMrImhiXQdpZ5SiWsfiuwtZc4dl4EdExlGxQSzXh8L1xncE1n0xVaH
	1x5cd8IRKCP/q8hPASCiim/SZwOU8+s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5V4HWOr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779967482; a=rsa-sha256;
	cv=none;
	b=usK/0XFXe3Dg6SC4WJArBfG6kM4egF6FUcfackWCTOQ27O5wVcGSTwX+U7whBF/QwK7dHR
	LyOHfWBGVwSDYbo9TmU6+GL9PfFO1jAAj6X8QpItcz28OyNH6ty+jZOB/sj1tNUYUdAFTv
	bpkcB4B+cFl3EcC0pRLfN9StHhASbkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D09EF60123;
	Thu, 28 May 2026 11:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4291F000E9;
	Thu, 28 May 2026 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779967481;
	bh=O5hCo12AieiEvQS5ItXa2ui3IkPos7/8NxeCJceX1Y0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5V4HWOrNTniIGkD6RJ7hWNU512A5PG9HjVtLbsM6xvKMRcBua/iBKeDeVeuGX/nu
	 NKWYjAa4sxiU7gyqJYZ152vRl1uwKCu8bDG7ncq0ntCA0KbLJh12t1MwBHP03tIyKA
	 TZbffnMlqF+CqYGTA5tzi4z5SLhCCzred5iqDfNicDfgsE5uQrQvxXHCApZ/zNS3C2
	 aZt7Zv1LtigVX5KOGdBftiUdxxLOA4uwzskycZbd2CiK7NqfdWLp38Yyxw987Pobx5
	 ggoOISBudB3sVaEDjpiG1dBD4OKtqASqQSY7nLOb+0rGd3EXo664eI6x1L/x+NMWcM
	 Z91A0jRsVrWvw==
Date: Thu, 28 May 2026 12:24:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <ahglqif-I4TjFK9X@lucifer>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528075507.1821939-1-agordeev@linux.ibm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B7E44000C
X-Stat-Signature: bxgqozzsg9w7h3miigoqwptb3ok3m4nt
X-Rspam-User: 
X-HE-Tag: 1779967482-595622
X-HE-Meta: U2FsdGVkX1+SA630W+PlxxYkvQTmANZlX4V0DIHp+TLZT8CwpF5CUftK1wsYlrvAuEyxEEMJxHe6rS21eHWGHQ4hSRgOSOGCoXmNz6nuHWVDnunC6IvodI6NU36T/lNESJIk0wwVLHQ3AuC4O0B591poKLS/cqx8wYdWUKC6z1f7JHhUbaOoWwWsmacz7VDepyJdUwNecOcH+uATaxb3kf9D4Z+G8/bv2p4oG1u7oijqfZzN8PMDft8Ac6txqXPa4HtAUnqC33tc3m9qRfbMh65dSxm6/8dr/WcfNsUKn8PwLA9lq3tJdCtyHud8nDPiaLGnyyyA9KaJzhSz3SrK32RF/biYqSvH4J7WecxwWwJo7QhtNnZOgX5unAcFqWa2z7p19Oqy5hz93Oi58ph9i4wvNlwUj5tt4NbOhmtP7Q6dvd0M1zSLCakJeByaU0DbJK+Qh6K6OdWsY6PDbw+8UlpNke6pjf4A3SSKN+mmiUgDDrynuBvWz4nDnyAIBfR163Ol1skMEQan52bbF3oOZv6VOXR2YPH7swD6AhwWnP1sR4s7wz/8eN5PyOEK91epqKzZrV0KdgekI1LiUtCudjH5c0Hw2bLo2n8sy2UBB121F5heQGkLZmUUUca9IO+bvj9FyCFbhoczecnN4gMwrcveLFVwEelidpnHqRbf7j95g+vMJU+Lj5KTCqa/KI3r1GjF3BKYmnZ4gSS25C5N/wpGBiZ8tTobRLD8H0sXsDkr+e+a0BfR3xOJyEtLhUghzKxKmY+eUS0yQAUevAUpIZ3de4vuS4DDSzY7DL05LZ2tJJeBf8YdtTZuuTz0uf3lXD+Zg5DL7BJxYpfsZtXYxeL4P36mz4eS0UMiI2Xh3WkRczaZFz5VAcAP+SKpBPPzvrjG7F8IQNw1jH2JLVHF+mYJ9pcJ1vLrvblEefRXecV5pwkSEZeHQOYvvgbsXKoV61/EJXJnBPP/7sx1zJG
 c4ePBEEA
 LWzuG4vDanao2ers2YTaQHQh/opiV/sS4fhF/CStZ8sW+yjQ+E9RUIDgfgVjiq2N48Uee82zmt/4GBGsTLb3xUwOlWqspHD8oxZlpYNu9/NAAxqDYAHZXSpj4LYITre0iYF9wS7wAxshr5bRPNuSfg+cmG6J4F/Ujv2baQHkWDkSQerA6Bm5qX6W8tfTD7m7uASwtrfWVce866mV1JDUiZuAFoiehXpdmhIRecZ5iXMKnzr0gqxWHcyxP16BkS8b+4NWbbhU69kIKheEUPo6dvrW0/mV2QYHK4ZKJsSRFaZm4VEWCq7/Rx7ZclB52Hj9AKJ90KHAfYLOoAXRnbrTrNZT2O6ewOBMWpMjmT7WRaDkSNrDIt3sODc6+XDC5hxXlmWFB/Y2eHYA+LO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
> Switch from ptep_get() to ptep_get_lockless() accessor for
> PTE reads when no lock is taken.

This is an insufficient commit message that's just saying what you're doing,
which isn't very useful.

Please explain why you're doing this and what the benefit is please.

Thanks, Lorenzo

>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/page_vma_mapped.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..2ccbabfb2cc1 100644
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
> @@ -183,6 +183,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long end;
>  	spinlock_t *ptl;
> +	pte_t pteval;
>  	pgd_t *pgd;
>  	p4d_t *p4d;
>  	pud_t *pud;
> @@ -310,7 +311,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +			if (!pvmw->ptl)
> +				pteval = ptep_get_lockless(pvmw->pte);
> +			else
> +				pteval = ptep_get(pvmw->pte);
> +		} while (pte_none(pteval));
>
>  		if (!pvmw->ptl) {
>  			spin_lock(ptl);
> --
> 2.51.0
>

