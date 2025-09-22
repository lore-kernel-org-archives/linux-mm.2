Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF91CAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D144C8E0008; Sun, 21 Sep 2025 23:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBE78E0001; Sun, 21 Sep 2025 23:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C289C8E0008; Sun, 21 Sep 2025 23:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB12D8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:21:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F0861A0441
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:21:08 +0000 (UTC)
X-FDA: 83915435016.15.D1257FE
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id CFAF340002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:21:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QWHMP4Xw;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758511266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixrh/iVBsgE1vkoJFlHD/3G5r4MUeYbHEFcICJyE87Y=;
	b=53hFeqNC/PvByDJkUI+YhxCUA61bHK/pLcaoW5tWrOwxCMEjQgaDgVVK8Kd57TFxtipCbt
	tJHmMnSFcIpIOAbeXrVmgidxL+CSZ9A08tswe9o1WNWfPPdJ3uC53XPF1W0Zl7D33L90H4
	NCBUESr1kdSdir0QP3pX+XAdJmoRF5M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758511266; a=rsa-sha256;
	cv=none;
	b=kLDpOt9lL/FQNDWuiemq3r7+QyqrRWga9aIPkQj+8/KEs+ExyA5iOdOB2JAcBQ1t+OHygi
	SM0HLToor2njcVD86+csdNl+9scS8rHYu2xZa+pu4HY/VO09E0Z14YoyctxYCPYkYECB+I
	X66Daikr+bwJ3EKlb3pdpFpTmRvaI9A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QWHMP4Xw;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758511261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ixrh/iVBsgE1vkoJFlHD/3G5r4MUeYbHEFcICJyE87Y=;
	b=QWHMP4XwUybhElJDbhCyY83TXMtb2YGooMSDkXEZOmQ9fO4TIyJf/5FgxEVxeq354emc6kGB6MvV8g0M6qJAEOQzJ8Z5e8qgwlegQho/Ps9YIds/+ppcShldHJxCAQvDbcVKxZF8zjUTF4CWPhF4p0/92wNUWoI/WKm202kiB/M=
Received: from 30.74.144.144(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoRD3UW_1758511258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Sep 2025 11:20:59 +0800
Message-ID: <29d9fa8a-5ff2-47f3-8503-fe3032097e5e@linux.alibaba.com>
Date: Mon, 22 Sep 2025 11:20:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 5/5] mm/rmap: Improve mlock tracking for large folios
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-6-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250919124036.455709-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9b74749gizhoho5jjtyu57gs84jyoce6
X-Rspam-User: 
X-Rspamd-Queue-Id: CFAF340002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758511265-487055
X-HE-Meta: U2FsdGVkX18KzLDHgmW5AOGGylCVKCACxClqVnpc4XGk2DAYj+DvO01gbe9bCVA6T/lQBVqEWvX5M24rGhM6ONGa0b7jg4M2UVAJf2VcdRyi59+83BJmXncQIKuZxf373vUmsfi79NteY66TJ9strso5xN/1mS/+b0FsPZglpfOiPksCn9b5XJ8SQz/Db931/apxsSndCkGMyFJwKiuP++2MTWWy7Nq793EOf5oW3z8zgUyJU+xYZz0T95OZ9DWqHmHZ8x8veoOxppM7rA/mEhYDCezUHKi2O/lrggp3OZarLiGzdvMNzsonSEVhUDdl1fEDRka7I3HWXbyBGyKnWw3GXWNgqgb4LWZj4gd1xEjZ6D+SaZPCWGfsZ85tAOoDSerwFw6qg8kcgnMU8nvqUbNkup0izWv+vRTtNcGGIJUeBB+nAo9DwVWNjwJjiot21Tn9aTwv0BO8sEUiL8/HGBpDtn2ae6ijuM7cbwnJVpKG4P9NRv19a5Mzory+rMYTJXL4TxX2lkCl0vnBIEKruPodHrMdk14qh4OL8c0Rn9gcTXGnGjvCJ/p8KBGIu9iX/wLC8j8IiRpBnBa7G19DHCf+MkYvSvJCT5MR2QwkWg8KdX6+kCpGX41zjuLy0OKCZyb/pVhd/EhnNde7KsFC/AiO+N5fN5uaBzoDjhL55SMbnJIOQHsbAPiyrsEhsTC3W1FvBZjLY7Azyve1x/+JPdMQRHV26dmtNTrXhZ+bmPNqwJLfIMsvQA0/z/5W5872fzOvFOWRAt1hdsif3GX1EFX2kcciJ1j3XUmpgXVTOL3M9TSYV/0hMa7KpRnQPYtiCqkOroP7yAtJE+q4befzxFz0SCvn+wJCi5IrBjzPM1Yj59ljDO+exvFgUb3GL/3Fp5nIgZFv/pHfQ9DAfhazOl2FC5XLcHElVr3nmyj/U/X1mLhZSkkYdhVeiXgtudqQpYemeYANWUuBtQp3sed
 1z8UsmI2
 YeahoROUa7BIOJ+CqzOlZcrECx67tKPXNk/hGe/CUrTL4Sa1AyiuvlEMSaB3PLuF6KwBuxf9us3EVgMx7DSVKnoqB3/OtH0futqNN9xKVv9Q2G2i/Wzlm/jWriqsD2hvViDqHw/EPfMuS9aZGZU5YQu+zrukM5UkxgZnPaK4jpxMbwNnyJAr+WqKCYB6Za+s2hB0F4hduuHly/p6fbsw+HAybML9DIqwJezKtja7ECPOfkqpIABVbqhnGpHk2x5ATze5j7zmefDxRFlKXgKIo5Fov8Ag2VWfunXANEczt57JJZDSWN/bwRG7eGcfR8SsvvKjCAcW+s3X4n411FURSKhlV/fnXYae1U4DrYqOfp0JEzGP+5yp3ta0TBr1dgwnBAmPT8LzcgYbk4uY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 20:40, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The kernel currently does not mlock large folios when adding them to
> rmap, stating that it is difficult to confirm that the folio is fully
> mapped and safe to mlock it.
> 
> This leads to a significant undercount of Mlocked in /proc/meminfo,
> causing problems in production where the stat was used to estimate
> system utilization and determine if load shedding is required.
> 
> However, nowadays the caller passes a number of pages of the folio that
> are getting mapped, making it easy to check if the entire folio is
> mapped to the VMA.
> 
> mlock the folio on rmap if it is fully mapped to the VMA.
> 
> Mlocked in /proc/meminfo can still undercount, but the value is closer
> the truth and is useful for userspace.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/rmap.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 482e6504fa88..6e09956670f4 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1462,12 +1462,12 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>   	}
>   
>   	/*
> -	 * For large folio, only mlock it if it's fully mapped to VMA. It's
> -	 * not easy to check whether the large folio is fully mapped to VMA
> -	 * here. Only mlock normal 4K folio and leave page reclaim to handle
> -	 * large folio.
> +	 * Only mlock it if the folio is fully mapped to the VMA.
> +	 *
> +	 * Partially mapped folios can be split on reclaim and part outside
> +	 * of mlocked VMA can be evicted or freed.
>   	 */
> -	if (!folio_test_large(folio))
> +	if (folio_nr_pages(folio) == nr_pages)
>   		mlock_vma_folio(folio, vma);
>   }
>   
> @@ -1603,8 +1603,13 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
>   	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
>   	__folio_mod_stat(folio, nr, nr_pmdmapped);
>   
> -	/* See comments in folio_add_anon_rmap_*() */
> -	if (!folio_test_large(folio))
> +	/*
> +	 * Only mlock it if the folio is fully mapped to the VMA.
> +	 *
> +	 * Partially mapped folios can be split on reclaim and part outside
> +	 * of mlocked VMA can be evicted or freed.
> +	 */
> +	if (folio_nr_pages(folio) == nr_pages)
>   		mlock_vma_folio(folio, vma);
>   }
>   


