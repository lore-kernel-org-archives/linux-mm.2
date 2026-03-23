Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64417EC01CD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85B36B0005; Mon, 23 Mar 2026 07:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A367D6B0088; Mon, 23 Mar 2026 07:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C656B0089; Mon, 23 Mar 2026 07:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4B66B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:51:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32D4E160B50
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:51:23 +0000 (UTC)
X-FDA: 84577162446.27.01E77A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DBBC40007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:51:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShF8suCu;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774266681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDxF4awYAm8MdAgDFgjT764jQ86yg9huZk7Uzo+BVHE=;
	b=8T3I/ddz/YlwselObkLShk43hymSpdWf/mASxlcd9c43Lc+CrKbtnLelvwF5BYWB/q39vN
	kVlVPeMENKl0C2fgi8XZr9yzemKxDd/sBnr9dZMMDnuHBMSvxFN9CeoaMetO0oqY90K3H4
	8oPIK3wi61/e1VP+DBwqUbaDZQekLpA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShF8suCu;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774266681; a=rsa-sha256;
	cv=none;
	b=Ml7OYFdOp4YpIMNQh9hQGY0mpO1x22eZNLC1S/Xk1WWv1S66RGAup+DLdfZUttYxzKePDC
	/jR3USB+1QCD4OsezWMIWnT2DRfbw58nitrQd5AA6TXV2LGBtLWTv5hkoE6k39ikzTJlMx
	QWEhTwFTqISkBhCjJkwetPrWxN8G8Wg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 700BF43C6A;
	Mon, 23 Mar 2026 11:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854F5C4CEF7;
	Mon, 23 Mar 2026 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774266680;
	bh=Dt+bOuxM+mfvDdyqEPo+p9Blwv4Fd6GpODUcVdZHmsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ShF8suCu0EIYttE51LjmUkUNKgnfiaXhrGdhtkAuCSVDtz5eowsLmJ41LC75ubyRd
	 j3SilNylxvIIzRO5Q/lVctIWxftc1xnyE7ZnAT1rW5SIw5Lair09qzcpDMaYIxjkFT
	 E+mQ2cZTXx60HmOGmHkkhZoQo81EMRrc4qPp4NndJT9s1/VqIb2E6V1hicIOQsnLUK
	 zJy89psnogeKxkdwkYQrtQBqQJQgzzLBhO9GOjRhSpwW5/j4fFCT+uPcAJDGaOAQsv
	 5A66hl153VQ/yRjQOlb18s5PrGG46+ENAxN5m47k/HQ4IXVk/XVOV6eISXASY7b+ZO
	 suKNADU5PNDGQ==
Date: Mon, 23 Mar 2026 13:51:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Message-ID: <acEpLz9zfAF6gS05@kernel.org>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319095622.1130380-1-yuan1.liu@intel.com>
X-Rspamd-Queue-Id: 6DBBC40007
X-Stat-Signature: f5qyjg5rhkdd7ayj6ictkmhxacicxdyt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774266681-428553
X-HE-Meta: U2FsdGVkX18d3dmO6zxXnC/od6vnVAfFGTfWrnq0Xm0Z4fkapll8K4a1ipoXZkcdWgp8GokjQiWTwjdiZEpkn5o2UFmiupROR0pVGMNOLAuLU9VfKW+2InLseWpuMKwOhkVy7FhRJxUC+RAzXoKfkf0tG6MzxCOG9sTQMWyWjSDOljOdQRZccd893nWuVPleltqQFTzzqr0UWFLHnCc+hALRprqzZPtaXZ12M34ttLzwe327WoqtnWvHc+5k89GnB5E5vPpd/oygupRtKk615l9tjsaUE5XtESkMXWSHtio3m9BZTpYwjf+NtPI4ugVkryi5AWSSyUdHdjoH4Y+xViP0Kon3dliN653Y3UcpzK9t9Uq7+F/Hx2uruSxvdw0Y/toRhCqJARzeAb0Bqoz51muhxB15SboEnOdlieW7GrJyWJKHBhWXzqacwiX239amXhBGZFPe/Trt6S0IFWZ8r0CtUW564DxdMK265wNkC/9aJPVrpETFDa6KkGfi03SJqELMQ2B0LknnyxafZbeh71wBPxLLc3NJ/zrxp2I0JykPaLPz8OeT+DRZ4PcQsaldCsTKZihZU4vG7r20XOmRmSkkeR2438QdQyual1n7inSMEdI0JAPfjzQa1evdyFeZ0yAN5c82CKHJBfJSAnWt18zEfPh+D2AZYCaghenHYp25TaQe74hgfmU6cjzArtnsznfvuZtPIurd+yHIwh1bY6RpEKaXvzUBtOS8Kp925qne7Zq/TEkl9747/y3tdB+sEhv+G3wSnF+D+x+vTf4E+iLNToeKXQViTRjRWnjp6xV06Mw8WEVvt4egi1Lp08uA8pBQHvEexnm6oyXK3fke4hWwMV2mm98btNs05ypKdiphVId6VN5kqVYgjfMJuWETpWAZ7wmgSQgn6UmSA8AneJuRuuE6tr+msVUnTHaZaPmbmrH8LFxxuXM1GRJ3AZ73H0j/lW+A6In54Gsgrf9
 S/86aQ00
 e50rb08tuLwfacSXGcB+aqsqvKjNYml07PSlHGsmMIJVwh+zoEczwOWz8Sjm6VQzz+t0qPWZulVKZUbwqdlG6w9TYTQ4DbIdVX+K2RvnlcwBzyP8/Flm06vYEd45pgz2/rJZXJxS9id91zU4qJvsB0LUJcP8sQ7pJPCyg/2AGDIOl1QDRj+egQMDvuc41cVh7ZQitlMoPVWkODYZPMFlFae6mbJCNRxmuB5c4CztSm3UsNOe7Y/jirJV5K7JwXcp0ewlQdPVzhVNhjDWiLFlH8WRI4ZDOOaMkjP9v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Mar 19, 2026 at 05:56:22AM -0400, Yuan Liu wrote:

...

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..96690e550024 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>  	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	unsigned long zone_hole_start, zone_hole_end;
>  
>  	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>  	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
>  
> -	if (*hole_pfn < start_pfn)
> +	WRITE_ONCE(zone->pages_with_online_memmap,
> +		   READ_ONCE(zone->pages_with_online_memmap) +
> +		   (end_pfn - start_pfn));
> +
> +	if (*hole_pfn < start_pfn) {
>  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone_hole_start = clamp(*hole_pfn, zone_start_pfn, zone_end_pfn);
> +		zone_hole_end = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> +		if (zone_hole_start < zone_hole_end)
> +			WRITE_ONCE(zone->pages_with_online_memmap,
> +				   READ_ONCE(zone->pages_with_online_memmap) +
> +				   (zone_hole_end - zone_hole_start));
> +	}

I didn't have time to review it, but it really jumped at me.
memmap_init_zone_range() runs before SMP, there is no need for
WRITE_ONCE()/READ_ONCE() here.

-- 
Sincerely yours,
Mike.

