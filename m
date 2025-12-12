Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37B2D4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3F86B0005; Fri, 12 Dec 2025 00:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174B36B0006; Fri, 12 Dec 2025 00:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AC56B0007; Fri, 12 Dec 2025 00:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB9B36B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:48:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92BE514046B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:48:40 +0000 (UTC)
X-FDA: 84209739600.04.D5E93DE
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0DC21C001D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:48:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W7bVQuu1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765518518; a=rsa-sha256;
	cv=none;
	b=uKk0ARm/4ZCKjRJDflpTMO3v41S0IcNgTiyiZdMVrCud2n0iuA6Gy8jH7n3U15zoGaJiFM
	dhXYqcJPwHx6mzotjguFpBt3YzEJsrM4y5cgRmU4dUl6NmMjUkRCuf6TLQ55NPpKfH6r2M
	4er2LcZ4o8DB4cydbMz1OdSYtMZpYQg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W7bVQuu1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765518518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zzX2IhdyHL+K9V+o1socKE9g1Ws1/CmO0XCpwAXjFQ=;
	b=HW37U1uM5G9v82w/5PyRuYc5MA4N5kgs2kWiFyaGBtjmM67IuLn8yz544aKnK57abutfT3
	YjLHuX1S8ml0ImOP6niY5aWztVcleZ2ze2yp5CprrStV3UamOOb4sPZqkXB+xqtKsXS10f
	CZkxCtLfOgLZ4O9gG+wtwo6uvql1DIw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765518514; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0zzX2IhdyHL+K9V+o1socKE9g1Ws1/CmO0XCpwAXjFQ=;
	b=W7bVQuu1YhAGqRyw7SMcvmMCv40e3ociO+Czj8+dNoHVab7xNQmZEaZ7ZehXOSsW8uYKsuf6i6ABNE0Es7GS1qw1LWje4hAvVaxCf6vRMR5iYHF9B5Z5GaO2HCWImsGLBD/Gss77KDMlGqi2X2DO2taZ58NPIoa2DPYiY9wd/jg=
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wud5Ubw_1765518513 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 13:48:33 +0800
Message-ID: <7f681d9d-0b24-4230-bd5a-bf056c6c396e@linux.alibaba.com>
Date: Fri, 12 Dec 2025 13:48:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/shmem: add mTHP swpout fallback statistics in
 shmem_writeout()
To: Weilin Tong <tongweilin@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251212031250.206571-2-tongweilin@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251212031250.206571-2-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0DC21C001D
X-Stat-Signature: nsmmffrhny4omqtwh3yzod39ofm3jpaw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765518517-972963
X-HE-Meta: U2FsdGVkX1/xPKU80wm4AvP+h+vWgNOt2BWeKIfxK3v1NqyR7gTa6J+SO/C5wMqfnOIVUwUi7gJ5kSSZ3F9BceTlrx5n2Q6WCjlMwXA9oC3i9muUuQ2rISjLRcVICZr7wmWfVzc6l+AWfhztGBb08q0YZAt7trIihHXI56nzibA8fziH/RNanqgOJSsRZ1O0pCUp8oxxgsW3pJAbqEVW5lqjj7zJYxb003ikGRZHdBAlT04ti7icxl4bq+F+GvScBvHZuT9PN7ctBW/hvlCGjkEcqmV5a8GjKlAxZZKzX6ejCE2Tk0RuDuHs0wHfo7DY7wZgZezvwMOUVTtqRkDJuTiulBrjHASyKQPLsVFv/aQWvh805+meddr+wVtKWhx4j2vWQ6v4slJBGjgtS0dhbp8yizLoE/QpCRzfnVSB617l8nrH1SrcysAemVPuwQkjHB5+l87vPZAreWwKpA0kJLClvg2FTTilHuvNOuw1MAq5HyD1RafjHCu+go/4PurqTHQq4gm0RnuLcpCjKIKMondv3gcRL4451AYklstB1GfJxOi/AcMUs8KSbGvKl+ZXbs6Rxbfu5EvSvye/2XVckEPXsRhGcISpnamOqciZ27QoTFzm6ge6IABN2tbyIbx71KLV0KhTyHeLcx3kMI2r9pHDwWS0Cgz+TeG4yGO4cucP1IijMWp7sbLSh+3HAYh6hJ1SWWjBmlJV8eWHiM0OpyJrwhQcd1/bIhoRtdPxh76y3Yrpb6qjdmvj0qRwPMRUEtkdhsV8KIVVWrRClH+A+bI5NSYexyO003H9ejXaQqAqBzZ7ECOB4YV13xJbKjBMdqPeTXnIYSzjFsoVCGSCdE0T0vkkt4ZFg4dRyYsu8i6ZmSVLEp5KtaLODbnraI97RzY4sz5H+4HR3NqWu2JkB33x+xuGl8htPikp4LuYL9m+LNRrsouzI+HRQGewSzASqGIQtNawnV79GMk1zFI
 jn4C43GG
 4VAWyATUlsNO5PLL67ZGxV/9KbcFywtlQeykUcL4mF6FlQ8dCW3kSTefCvCEN3tHGSvJxI4D6peTsmV76NgSdOD4MhF3rMiixdb6TbA8exK1L4ulC34umfnn+q/Cvm5R6TVZHMPHAjAcyndteFN0/sjQKNmYy0tgrvHQ/8Cr7mwE0exaVo68AAeZpSpvgYFAk1n6y7F6oo98/RS6GFZKMMFza4yhRlD+IU8+RM0rKaEZLeDV+l7FuNWneSAtGyCmMWikitlI9QD9LKD81Euxkjk92HYajPPaP4pTajg2d5GRzkgoabfS8UJU9nnkMKfYc7ymYJOy4VlNx2ewnkfjR0/NJ6voRIKxyNy5tX9bdYdimwrJ+lcn+G+uc1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/12 11:12, Weilin Tong wrote:
> Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
> there are no unified statistics to trace these mTHP swpout fallback events.
> This makes it difficult to analyze the prevalence of mTHP splitting and
> fallback during swap operations, which is important for memory diagnostics.
> 
> Here we add statistics counting for mTHP fallback to small pages
> when splitting and swapping out in shmem_writeout().
> 
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---

Looks reasonable to me. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3f194c9842a8..aa624c447358 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	}
>   
>   	if (split) {
> +		int order;
> +
>   try_split:
> +		order = folio_order(folio);
>   		/* Ensure the subpages are still dirty */
>   		folio_test_set_dirty(folio);
>   		if (split_folio_to_list(folio, folio_list))
>   			goto redirty;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +		if (order >= HPAGE_PMD_ORDER) {
> +			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
> +			count_vm_event(THP_SWPOUT_FALLBACK);
> +		}
> +#endif
> +		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
> +
>   		folio_clear_dirty(folio);
>   	}
>   


