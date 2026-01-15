Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC3AD4661A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D396B0005; Thu, 15 Jan 2026 14:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EAC6B00BE; Thu, 15 Jan 2026 14:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B5A6B00BF; Thu, 15 Jan 2026 14:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6A296B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:19:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA49BC1D97
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:19:50 +0000 (UTC)
X-FDA: 84335162940.29.BD5D0A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D071340016
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:19:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EZpMaRLc;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768504789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouCAkWBQMyZEvna5P25Kpi3sQh3yj2jemuR/ruDbnKg=;
	b=46g8S/iUP2IMnRxO2Ph0DHY2xSbEx/vlSC92L6cDv3XdzOWWoMwKfN/LMvgYKy43ZKSLis
	QTuH75ly3fuQht4q0CmKAEvEl8J9t2jFouvu37chYXuH890bbJ5cmD/0HX1OUwyutqQEJ4
	AFv7iw6nj2b0XiBgemgJauVmZL1UFw8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EZpMaRLc;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768504789; a=rsa-sha256;
	cv=none;
	b=FFbYGH2aZeOnk2RNBMbHcpgiiSoRJxkQSv8To5LDc8PSl9Wmma6niZR1SiaTXOBfKvOUzz
	510B6u9wEMzb/bVzd5Tw22H/gtmT9m2cR4+FF4OX+xvASG1PX8PKpg6MlP5PIjrtFo0KN6
	PqRyrKBA7OUvXwGdhx1ZbfrE3tVOnuU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDE3A40A0D;
	Thu, 15 Jan 2026 19:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47885C116D0;
	Thu, 15 Jan 2026 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768504787;
	bh=4IqFlSgd50KOXhq32VEtfl/4QDI6mWXEtIVrRCZB74k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EZpMaRLcj6fcjYWJwT1eFKHu1o9k0+GiTV/xZtcAsCVZtvAXL6mg0KN1e33qbC9JM
	 YVh6ORLZqfcmx8dCnplNSwfgftwbHiwas//xD4BlxyUXlLz828/H2LKzYH1mBUReGX
	 dLWAaMoLVj2x+aphE6GwOmUX6sqO9jzAtIwmxWyY=
Date: Thu, 15 Jan 2026 11:19:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Wupeng Ma
 <mawupeng1@huawei.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/hugetlb: Restore failed global reservations to
 subpool
Message-Id: <20260115111946.4b50c5dbe6c6bd01638e4b16@linux-foundation.org>
In-Reply-To: <20260115181438.223620-2-joshua.hahnjy@gmail.com>
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
	<20260115181438.223620-2-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 64gato87zmcfprc9c5iz9gumrm3y9ed5
X-Rspamd-Queue-Id: D071340016
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768504788-979785
X-HE-Meta: U2FsdGVkX1/FLD6RjgFIW9+E47o6zJiCXC/8M6qu1iQ+O8rciDqhwlRkLQiY6zCue2TS0IxgPuK8N3Nei1brViQwf+PluYDw44VE0S+l8Aqp12kk1H8a4N3BW7CyQuLB+LbC8NM6LA8MHwDlyFQ3N5Gtr6sMw+jGtEGBm+D5vn63w2rkguHQc86Ncxrq9NKJikLP+WI83nJMoAnHx4AqzFEBU8VbS6hRJrndWp25/d59T6+vJzwlOLRox+geuv7sE8i/8Zvvp04D3yfPAn7REYPZVnodc8o9IdVXb4XnOKPsUfyuc+/SO1p8VZN67SOudCtDQNKXAuVyWwS1j+Akf9g8FyFez2SKarHCyINu2szQwiXM1AE7uFw2uU8hQY2jBvz1Vdw1fmOEJr308glulb5oIp64dAXF1GZ6hBF4vD0UhEvHUGSLWBJK+RkDhA7AnrKh9xNyeCTZ2c52bOwi4vUiSMD0hr5sQuBSeJ4EqXnI9/43htL3RmCV21y4PeJOa56Q72dynFolWFfReajlnxG8hnlmSKHO1LIhRw9yZLLmrs5rEOhgVJWRwZYHcsz07xs0Khrrpr/tJNh8NpS2SCeBrwN/sdAOnvrOr3hY/CvETibcxzieeE6YwZSqjVNO0YRdkOmI3neitBLv6viEfcueXVhj/mP4guYx6j3UwR/ODLlbJbTm7f/oXX8e72kZRRf502Yip95nuMPdhUOGz9/dC/djUM8pwSWICWQn2Do/+EyDVod66i818sztdg+vNgTc9hY/eG3Xhd1Og8TsOBmpJBhtLDczl9HYDJVjsHMq/AKFi2Ap4HMbxXZUD6mqan0PVfHf/cT+SzrPUI9fGpX8aS7D6gqCmHn7xwbLlpsKv+Hl1Sdb8wQwURYW9gah42CScwHag0bQagrWtr5cdAd/D8nEco9OMUlXrSFOZIQISXdcv2Nfb9Mem3T87UiODU1dZTQA4OfZYwn3wCr
 0DMvgwZZ
 eVIn9hDf04z6LPeZMfV+oSvErwUFqUiyx9+Biq6hB0YnPiate5hP20ACB51UJY6BZlksqSJrLkZIqzUuTrgC5oW3J/du3V+MVOhoXU8H+9BfHch4d5h8HynHOKJuDe+tbP9FI8UgDkDi67wXbbqckLI1BJY0tv31e28grfG8IZJEduELxv7E/R7MfuYcRscEDLtjyJWqvdX1BhvYrNPJUpqRg00KliN6vimPDGu9Pr8c204Tr7bneWqcgXSLDrPkyYTsQPqRqgdH2a4oR2/3aOZau3i40m/+Xhj4ndrMxaOeYtin3jiXKdAuTsCiMRLara6Sk9R8xC7tSxkRsfLGUzu7x4kbHwDW5s6mGz4WJJo1839Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 13:14:35 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> fixed an underflow error for hstate->resv_huge_pages caused by
> incorrectly attributing globally requested pages to the subpool's
> reservation.
> 
> Unfortunately, this fix also introduced the opposite problem, which would
> leave spool->used_hpages elevated if the globally requested pages could
> not be acquired. This is because while a subpool's reserve pages only
> accounts for what is requested and allocated from the subpool, its
> "used" counter keeps track of what is consumed in total, both from the
> subpool and globally. Thus, we need to adjust spool->used_hpages in the
> other direction, and make sure that globally requested pages are
> uncharged from the subpool's used counter.
> 
> Each failed allocation attempt increments the used_hpages counter by
> how many pages were requested from the global pool. Ultimately, this
> renders the subpool unusable, as used_hpages approaches the max limit.
> 
> The issue can be reproduced as follows:
> 1. Allocate 4 hugetlb pages
> 2. Create a hugetlb mount with max=4, min=2
> 3. Consume 2 pages globally
> 4. Request 3 pages from the subpool (2 from subpool + 1 from global)
> 	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
> 		used_hpages += 3
> 	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
> 		used_hpages -= 2
> 5. Subpool now has used_hpages = 1, despite not being able to
>    successfully allocate any hugepages. It believes it can now only
>    allocate 3 more hugepages, not 4.
> 
> Repeating this process will ultimately render the subpool unable to
> allocate any hugepages, since it believes that it is using the maximum
> number of hugepages that the subpool has been allotted.
> 
> The underflow issue that commit a833a693a490 fixes still remains fixed
> as well.

Thanks, I submitted the above to the Changelog Of The Year judging
committee.

> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: stable@vger.kernel.org

I'll add this to mm.git's mm-hotfixes queue, for testing and review
input.

> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6560,6 +6560,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
>  	long gbl_reserve, regions_needed = 0;
> +	unsigned long flags;

This could have been local to the {block} which uses it, which would be
nicer, no?

>  	int err;
>  
>  	/* This should never happen */
> @@ -6704,6 +6705,13 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		 */
>  		hugetlb_acct_memory(h, -gbl_resv);
>  	}
> +	/* Restore used_hpages for pages that failed global reservation */
> +	if (gbl_reserve && spool) {
> +		spin_lock_irqsave(&spool->lock, flags);
> +		if (spool->max_hpages != -1)
> +			spool->used_hpages -= gbl_reserve;
> +		unlock_or_release_subpool(spool, flags);
> +	}

I'll add [2/3] and [3/3] to the mm-new queue while discarding your
perfectly good [0/N] :(

Please, let's try not to mix backportable patches with the
non-backportable ones?


