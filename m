Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCF71073C9F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC4D6B0089; Wed,  8 Apr 2026 07:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3CD6B008A; Wed,  8 Apr 2026 07:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0BD6B008C; Wed,  8 Apr 2026 07:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1FDF6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:36:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 939E9140A65
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:36:53 +0000 (UTC)
X-FDA: 84635186706.01.1C9CC03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B8F616000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:36:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tyc+ZDtX;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775648211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRFz4qrlYe2T4To4MwhNJij8uVy+cIcUloAamrZKv+w=;
	b=teKpt5BNuquAbFbKxTbA75mZjmpamFCJzN2XLstI78mHAQEYtDncgRdS7cZD1VsAV5wHRz
	T2N3voodmKfOvcCE4K2EtwpDiE4x/iiLqa1ykIQ3oitfZIi4P1Lpw80kd0r9TqhFHUV/B6
	uaftFt8em1zEJIlvJAHs+0JFARDaKSQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tyc+ZDtX;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775648211; a=rsa-sha256;
	cv=none;
	b=kjb88cO3nSx55gZ53QBok//ixXsTvP/7llGUo43aq/ohLC/yKWQeFhPK4vISZtflv59nQE
	ejqvzyPIbUS0Ac5N8hh6K6E6rdnWdYt07yMWYnSqCO21OJMBbwQ/4vzFXF0108We2Ad5Ww
	9UH2kINVNvcC/gJsIlfpNt1gjy1PzTg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF0263161;
	Wed,  8 Apr 2026 04:36:44 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E7CFE3F641;
	Wed,  8 Apr 2026 04:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775648210; bh=TIvBYgco5Q0zBdawPxnIjX/uGosAzf3bmZeuxmZn3AQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tyc+ZDtXxSniCkUDIjLP6KKzflE6CwlBnHALqx63GTUFrNyU2JF3Ef62mtN/YsHmb
	 7ZEmNUADsIcp/gy+CcyNXX5DahMmcxjlRYvvs8Yq3SrrwZoM/CCxHo98FmeQUtJ6BB
	 3JVJIanKmDREHSh3cxE5uq5C9ysDoD1/Bt4VzYbc=
Message-ID: <90cfbbb4-9f75-4c67-a1c5-34780b2f7108@arm.com>
Date: Wed, 8 Apr 2026 17:06:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/8] mm/vmalloc: Coalesce same page_shift mappings in
 vmap to avoid pgtable zigzag
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-8-baohua@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260408025115.27368-8-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B8F616000E
X-Stat-Signature: 54nybd1fz5uga3ju9mqqbzmupt9z5ytt
X-Rspamd-Server: rspam06
X-HE-Tag: 1775648211-713238
X-HE-Meta: U2FsdGVkX19yzW3K2OQVTqJe4T/YbCCEksUqFcRxwlNQ19i21ePtmGaUblvOMHnHeXN4RZrgVUPYVCN0TKdKHV/j/iXmG+D/1lRUc0c6GTwa0pZD0PT9TsbVlqNbypDM2MutSXe4nR3VOemuoZwTapJRCCDLz8gUqQsGK5882TCFemFpNwiS9c+HqwGnrQoykBnLVnXAu9Ctn63UiT5E9sgKMwuqZPA91yl8deUbYHpBKT6FCIOgqxgd0ZXACe+kbcYtjEtLh+CG1dgBE+ZY1sFTU7KOyXfWxH5B7IGjV+CODBgj+YtMQAczqWiqB6dPGvskSd3Jx8q2NVW+7uXyYgnbUkGqZrdBURGTionulp3l7GeUMjBksEMkaRD5TsMyjEJKYfeK59HYBTfIAXu+5SL5H6RqZczVe/XPvCbpUAJYPQDlX3+aW7WlH0hWVuypNFpPwZxMYc1ywDXcBxi6dd1iJ4idVLzo5HYCl5MHmetOgpRnT4r5jpdYLfALgq/UOOlqpXpBbEwYYr655h+C4zO7R+of1BfQ0pnI7V90CIAzt/M3gNYe4Pm8clznPSeVHHcI463vfujPX+s+n+TM1xbeo7W6V2Tagex8E8/co5GZ1SL8DZwp8W0+hN8hcUafjs01YdeopRMJHYaJu0XjIrJERY5WfnAYW5YkNG+z5kk/q8x3uH09P4RvW0YLxJeR0M/GEDSNqvJXOX0yYPy73nubXxFCS94R1x/JAi07OPM1RlF1erFR+uPOHr+VG9ftqOWrPVfvCYEVnUmdZCBZ/L6bCwudvmey3D2Y1kY8w06HGgDLE6ozBsZfBbOfs6P5SreOqrM8/MA7/HO5sSqUz1jncKhOHHEqzZp6n7Cn4wEEcbAZXI+fAndFvIaubr1FdctM1tlA0QBJiYHRD3LV5VDlMOf562xXGn+5EdwWs7GFTBDVdtW5RSgk98LzuX5Z1XpN332idcTcdc0s0U0
 9IorjaiK
 gC+nr3K8/kHCHq7gIi4zQZ01Z0v3U2HXsOcXXw1sIAfOimrCK2DCc0mUKJAzd3M8PnhxBLP9Qcl10ityq/9eoHD6gklwuClj9AFKpF3fiRWLx8maRtvMmpMMiW6y4Ch4y9zSBDfbNTsZ2nJ594WN+YddA+W/pkmWGkkErqYsLmsA3kgYxYPM7cQPCqxwJRCuIszHHiVjzFGpIOPt8lm9CvwRian7n9ApJ3D4rkJYVYz+HepzSJzrZ3l7XDxkXkawJe/DyyacU+eJjY8JJHTkly1V8IgEdikUbgq/TawS6nMf2j305RbFQwramyhrjIy9ujoRGuo29ouBSQFnmPQjkEfzw+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> For vmap(), detect pages with the same page_shift and map them in
> batches, avoiding the pgtable zigzag caused by per-page mapping.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

In patch 4, you eliminate the pagetable rewalk, and in patch 5,
you re-introduce it, then in this patch you eliminate it again.
So please just squash this into #5.

>  mm/vmalloc.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6643ec0288cd..3c3b7217693a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3551,6 +3551,8 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages)
>  {
>  	unsigned int count = (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift = 0, idx = 0;
> +	unsigned long map_addr = addr;
>  	int err;
>  
>  	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> @@ -3562,15 +3564,29 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
>  		unsigned int shift = PAGE_SHIFT +
>  			get_vmap_batch_order(pages, count - i, i);
>  
> -		err = vmap_range_noflush(addr, addr + (1UL << shift),
> -				page_to_phys(pages[i]), prot, shift);
> -		if (err)
> -			goto out;
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_small_pages_range_noflush(map_addr, addr,
> +					prot, pages + idx,
> +					min(prev_shift, PMD_SHIFT));
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			map_addr = addr;
> +			idx = i;
> +		}
>  
>  		addr += 1UL << shift;
>  		i += 1U << (shift - PAGE_SHIFT);
>  	}
>  
> +	/* Remaining */
> +	if (map_addr < end)
> +		err = vmap_small_pages_range_noflush(map_addr, end,
> +				prot, pages + idx, min(prev_shift, PMD_SHIFT));
> +
>  out:
>  	flush_cache_vmap(addr, end);
>  	return err;


