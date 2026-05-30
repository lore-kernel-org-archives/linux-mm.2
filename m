Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828BBCD6E4C
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7456B0088; Sat, 30 May 2026 05:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29866B0092; Sat, 30 May 2026 05:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C386B0093; Sat, 30 May 2026 05:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 955636B0088
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:06:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A6BEC03EC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:06:36 +0000 (UTC)
X-FDA: 84823505592.25.E1168E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4724D14000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:06:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dNEg1+6p;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCBniN88NBrAU11hxUYCzYT71eLxOw57Wf0bmI/f5BA=;
	b=zVK3X6ONCUAoaZunD3IJ0vLd+cDPacb1qCHolzMtiWd/8cSorN0EE8Mf5mrmJYc6eDwFcP
	+OMnc5o3Hkgo4sspXpjoYJaTqgeBQug9VZEcUzCDLxcdyzHCGDQPB8zQKGhyVfLBuJSuHn
	SGGP+WH6CtZNiYFp3Jha6nfP1sZniWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131994; a=rsa-sha256;
	cv=none;
	b=Mg+u9x1S1yI4eWZ9+BJqd7iZPhobBbxyEwkkuOuzDpxTdHk2Xj0yc/tPRVGufYBhiTpYyU
	XjAWYwkvxmHEb0RFpc0OpEE0cKYx62T5jTomOxBzStu149ubxfMu3cXvsAkCKhFEAHdUVp
	SHZvSFJyZlpPRuRD3t/XJy2zufwevB8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dNEg1+6p;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1805D3515;
	Sat, 30 May 2026 02:06:28 -0700 (PDT)
Received: from [10.164.11.56] (unknown [10.164.11.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF8283F905;
	Sat, 30 May 2026 02:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780131993; bh=F0p1JUNXdPw9WM8ZvqkieC/oNoI7GZ3ZiURm7l0kcHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dNEg1+6pYnhWTOOlXa+3OmugwTNXX7EZHMrHrspJwwLNfQDM1rNven1dKHpjKewYT
	 6w//+zwvelx4A/tz5Lh4kJsIuq+P/tFD2r/IbDvWryJcclu/5qukk3oUdgkFDdr439
	 rZsOVxjnqYg+pqg8TXWRsqSj4+Xq+6fVzqtIvwtA=
Message-ID: <593c5a6c-efcd-4790-9398-1b0e6b94fa8a@arm.com>
Date: Sat, 30 May 2026 14:36:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] mm: memory: flatten alloc_anon_folio() retry loop
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
 Mikhail Zaslonko <zaslonko@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-9-hannes@cmpxchg.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260527204757.2544958-9-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4724D14000A
X-Stat-Signature: yq5iujhmzqnw8kp94sjrd9e6rzer73ki
X-Rspamd-Server: rspam06
X-HE-Tag: 1780131994-139230
X-HE-Meta: U2FsdGVkX19b4WnyZQ8enfP9tXVwnug5s4Gd1BnyfFkC6lFdNHPEYWyqR0mCGDN86q3BI1ld0OSvotCQO/U9XNNpK8Lpz0/May3+OdjIzZNbsibP3mvl0JvsmH0PMxS58tmYJvNPot672/TfvLxSB/p8X+6L199Oc2PcRw7Ia+Wd7FUvI/l2EUW2TXriAxjiUbTgiPFXMdZmnqA0qOknLc5Z1Ra1YysajDOzK0cQojIlOmWuuurtEoF7/IIdo+/PDWWwLVeir+lZkF43y8/R8Pr9+QZY2/9Psxp782qfGmwAq7EwaPS/us5A0cdiZOi4w6mAAn1NZIARGN3nf9nmlIeUPxi6lK2c5zm23t7bcHmdmuutriqIjfmISjd4cTTHPN5hBh0tLj6eQXKarZ76PD1C38TOmJMY9wg4YAL16iUozi1ZInyRws9GkXAu+/wrTYrez+04DwVxxLqjzdyG9vGqs8qxosPNJO2Qo8+ffAohOf+FqfubLcDunuSNLHi0i7whgZvfko09yic2ZfbaS5fvEOICLOI4V4se2fPBHEGGw4vgk1Bh2qy2ZMsTh/aTFeZz3vs7neOAUUUfr2HvagVtozfaAK/XKqj5pNO9pPW6PwSaaYiSrxyuRk49LB3n4M5MHWRmxI46ozfqEulF6IZo8VsL2ZLnSMKU3WMSJxSzCC8AiND233sk+5jqbDmXGZEk8xUokcOmnoK8wlav1MkCZ4zatQwHXXO7sA+bi4oBzlB7FqPibg31FdTDHcuqdQnsbbyQmhJ2+wJ75ZAimXlDVYCygww/jUb/hO5FuvMVnXw+6gDBKNF321u4mY1x0QcqVMNHpQJHw1kuPLbvNgIAlnskuXD3fTUeV/qh8t7oHF25DIwyqQ61DWjON9UCrhPsAh6qchAWkt924SA2MEM1mAQtI05o6NbDeDE7+jBV0YattOp2g818s2dC5Rx3ImcejprbTkPJckEe5Ej
 vXts4Z6+
 8wZKgj3V2BgY5C655ITPb+88+p26NczjScFDkB+l0q2TzefUa5xSMft2EB+Uc+QBZsCkLqDILhEMR5mR7ITo5KfRGE+UoTjZZKkD6T8eJwRxcPp1mdLCDlre7K4xXkcBVGVO7t2yPJTWnlivNT74OdlhhkrEw0EGWBS39cJ8JPdCE3TjoNwAj57F1uydg6hJj2kYg5j+bTSeoYZSpPWwdR6pG7Z/DB6jdb/tWBqUDUd1J8J1sqo9Aa2qRwPB66CKJc1+a4AaQHKBO9gwSTwLqyiC+iV8pGM1EC8lhayqkRd/vPxjGY1rdCHCYzuJpLWe9HtrrsDxc1yNpikTjtH4JjZX4rdPdct4oktHY289524z+H3AMbWPHbAtlOzZaLqfr9YYhh31qjhApg1alS/boDV1EToM57b9wS1gsnutkI6HIlOmhtYFnN30v9xVR9kmzp4u/oqbSzT/U5a8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/26 2:15 am, Johannes Weiner wrote:
> alloc_anon_folio() uses a top-level if (folio) that buries the success
> path four levels deep. This makes for awkward long lines and wrapping.
> The next patch will add more code here, so flatten this now to keep
> things clean and simple.
> 
> The next label is already there, use it for !folio.
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/memory.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7c020995eafc..135f5c0f57bd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5215,24 +5215,24 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	while (orders) {
>  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>  		folio = vma_alloc_folio(gfp, order, vma, addr);
> -		if (folio) {
> -			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> -				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> -				folio_put(folio);
> -				goto next;
> -			}
> -			folio_throttle_swaprate(folio, gfp);
> -			/*
> -			 * When a folio is not zeroed during allocation
> -			 * (__GFP_ZERO not used) or user folios require special
> -			 * handling, folio_zero_user() is used to make sure
> -			 * that the page corresponding to the faulting address
> -			 * will be hot in the cache after zeroing.
> -			 */
> -			if (user_alloc_needs_zeroing())
> -				folio_zero_user(folio, vmf->address);
> -			return folio;
> +		if (!folio)
> +			goto next;
> +		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> +			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> +			folio_put(folio);
> +			goto next;
>  		}
> +		folio_throttle_swaprate(folio, gfp);
> +		/*
> +		 * When a folio is not zeroed during allocation
> +		 * (__GFP_ZERO not used) or user folios require special
> +		 * handling, folio_zero_user() is used to make sure
> +		 * that the page corresponding to the faulting address
> +		 * will be hot in the cache after zeroing.
> +		 */
> +		if (user_alloc_needs_zeroing())
> +			folio_zero_user(folio, vmf->address);
> +		return folio;
>  next:
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
>  		order = next_order(&orders, order);


