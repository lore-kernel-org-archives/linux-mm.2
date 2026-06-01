Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A717CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AFF6B032B; Mon,  1 Jun 2026 07:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9318B6B032D; Mon,  1 Jun 2026 07:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E3D6B032E; Mon,  1 Jun 2026 07:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74C9B6B032B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:15:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2870E162330
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:15:12 +0000 (UTC)
X-FDA: 84831087264.21.A0A51A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 80BB52000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:15:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WknMiUk2;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aCdQEidT1zbm+20lHSO0oVsxoz4jxFB9Q2z05FwPro=;
	b=i1Q9tWEBOs79mZe4jSjDl4Gtk8830Fj2FTW3JgwftCejCTmz4UWBypsmuKm2v2HOMbFFhx
	v3KUZ5h6pAO8f48lTP0RuLvdZzZWJrNRwVxKL1YAasB9A7HqN9HNotvgEYJY+Xak/HVddK
	EOeI3bGOCLIWeeziqXqtlSNms6efSsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312510; a=rsa-sha256;
	cv=none;
	b=6+x+30vFY683e3MExd+1uX3ZPjW6a/mdqRCmKSBuILXuQR2zZzahidL6KhsenGc8grqAsp
	n2xfX3U4Mh0RsWCAKrszrui3NUe5ckyZ5c2pTHbvo9BGcRA2jcPLd33b6xDffO+ehAbjYk
	57xSnSofI+XloKPvIYzXxQYRGt3LF7o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WknMiUk2;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E492402A3;
	Mon,  1 Jun 2026 11:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8141F00893;
	Mon,  1 Jun 2026 11:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780312509;
	bh=6aCdQEidT1zbm+20lHSO0oVsxoz4jxFB9Q2z05FwPro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WknMiUk27Rm5jyFgkEggWAdBc0woi0LmOHoYl3nCFeOEzqLdDxyfyJk/Rt/qXc4mQ
	 o3nJAOXL+d+9XeqFftbou6JkatIrGwvoR52t5Yx3rKyeoPDiFD+W52eYvl8gxh1Ocd
	 vhr9TW75IFNyDknV78WWdxHtU+Kz5OR+i1PWmLpDrdNfHk/1zhQjCZekuRzwOrJMvh
	 gl/NwKRIJiuPeIgha/Y+Q96HKfuIKO0agp6KIIScgdwWrv6n63JoYVzrLRGdWODirI
	 F1+/hr8/NbiHp0oUlN8NDro8fA0tGBvrsAdZvuNXSunF/ivFAX40TyZXdVwHH4eAHX
	 wLAbla1absC0g==
Date: Mon, 1 Jun 2026 14:15:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mm_init: use div64_ul() instead of do_div()
Message-ID: <ah1puPfob4Ux3BWi@kernel.org>
References: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: ucaa8k4tuciwb3oejyfathybgwgzfj86
X-Rspamd-Queue-Id: 80BB52000C
X-Rspam-User: 
X-HE-Tag: 1780312510-743868
X-HE-Meta: U2FsdGVkX1+w1SK4u3QBGLYLuwYwnKv5goaFKtkkboNLtlI6Sky2ffdBpDmRM8+FygX3eyYtlHrUmRi2excLvPjN+vmwBYKkGozG/0rvQeG9ocrs8RumiwVvmKNHWQKDdpigfqm9aHSBYnLwag+CP0uEWbRO268NpTV3vKHJ80HrGYPtXNXTwPHUdVS4sWD375BWdCjoE4G0bMURFhYkshOLYhj6Ilmmi02jFGzkZxfVtPcgZwdSLTSZsGEbIGv4S7N3mppaJFSa15gIny/s4JV0NxGviBQIiO7GLcs7MNdwqNzowkAwOVuawu+Ao6lIOt1Hv2izqMjO2OHLPs4HmDIm4w2tZtxTWv6J3du2UI33k5i24fSIF1fPk1OTE5BVbMryb58mTFR0vXfBiBW81uljHvhQxDG2lBh6z+mn4Pl0TvInj+wM2TZQm9U9D58fKdDc19it2l+Onen6RAPQGvJrWVe/yntk/AIN3Jt12Vpa85LwgTpoXEUPsUcJZZSIdpWGIXalF4je68LQ/f+4DaCuCYmlwT//62HHvNqh3fo0L3OlKP6t2apTWaESh72ngLA+9lxzJTwCxEHGH8GfVqlDhUeN83RCg+MvWv+DBFsHUP3TwoCqYX3cRVQYiDv6MaAmTLUPImeyPe7a7t8OIebE8vSL/57vwz8OMlBB8V86PJHI3LtBpsSgf5k0s6mbXa2XA8uFrbO9I0iz2eb1uwYmAOMjMW+XCmwE53QTLyzRyNPJ18Mh2QHWjqtISh5mNkxBq7rrpMrz36Nli6BNLWxnCxxvMQrHEoj30LPJ+9W/tAOPowUUEoz/26gMBeQ2Y03fsPX7h3tuJzGEKYR/CaccVYwMuMbuDW9FSuQ1OeqYxHNywE82xWupYH6qWNoRQj/JiQgtYLfOiyGaT4c1KlTCPJz6P6hhAheiLpUnHhrFfwpbDhtvvvfNZGuh6CS4cSzeZQy66QOCOKFRqv4
 a+Pvo3s2
 Y9vNNBDxZYeL4fSmArcYETln6I8iZ/NgcNgKuLMM+4MKgbATVd3mLrB9AQHlgED+PKfqmG+ToL+EsU8QLyytxtX0VSiV/MbyI+N+d4/2EhtGJGX0M6DGdMrc5l7k57NYVGdVNem6ttkI5tv8It0+qw6D3t8MNucRB8dvGAam/XYT3WggAcgHS/Zkm/wdQ6ECuwJ1YjvSJPmELnoXUYQRHRzP4SJxOtuCrZ+ztLgkHDjzBj2kKJ9NZR5tEZq8TlAXBjsbBgEggfCrPwiOtK7ICxss43tbIoUimAjYZsYaOopRq+yRF+ieahfkaTc/em6vVDJRn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Jun 01, 2026 at 04:11:23PM +0400, Giorgi Tchankvetadze wrote:
> Fixes Coccinelle/coccicheck warning reported by do_div.cocci.
> 
> Compared to do_div(), div64_ul() does not implicitly cast the divisor and
> does not unnecessarily calculate the remainder.

Can you describe what are the actual visible effects?
 
> Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index db5568cf36e1..4d335eb799e6 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2426,7 +2426,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>  	/* limit allocation size to 1/16 total memory by default */
>  	if (max == 0) {
>  		max = ((unsigned long long)nr_all_pages << PAGE_SHIFT) >> 4;
> -		do_div(max, bucketsize);
> +		max = div64_ul(max, bucketsize);
>  	}
>  	max = min(max, 0x80000000ULL);
>  
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

