Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC59C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC59B6B00A2; Thu, 30 Jul 2026 10:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CDA6B00A5; Thu, 30 Jul 2026 10:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E546B00A7; Thu, 30 Jul 2026 10:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7107A6B00A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:45:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E88F41C017A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:45:13 +0000 (UTC)
X-FDA: 85045715706.29.67A0A5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 45B5D10000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:45:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFgpgcap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785422712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0PRcloglS2eplyMT6C9pAo053hn3uqwraPzhkmyKgw=;
	b=S+CAo+qy4OwvVb8g8Z2sfb2z818Fhl+m5mPKxg23DFTplHy5/mkfcIz9HKu8LaheqgUCDP
	QoPXvz7qNVa5iJl1yhuSCCSd1fZDS3WuOoFz4tz55hlK+p1vWS8RwmEF3nXbt9u2+LlWMV
	Df6SK50HfcEAAlIa9y10llY1bYWAewY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFgpgcap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785422712;
	b=jKRrZvDLJll0P7HlYMcSf2RjPO30Wdh4T7siUkxoh1Ahq+qgVPY1OLbUznZjYhCSWkyu8h
	Xpr5oaT7hozihIaylLYZDzulTtczmfFAl6p3DwUdt86ogoE+Tmv2Y2Csflyvtz1zUhzl6O
	y45wwbFWgKZxE8/ygnIEU2Gi6NXm1O8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 712F942E19;
	Thu, 30 Jul 2026 14:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E2F1F00A3E;
	Thu, 30 Jul 2026 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785422711;
	bh=i0PRcloglS2eplyMT6C9pAo053hn3uqwraPzhkmyKgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AFgpgcapG7OU/hcXjDFHKIFCFmcCMN72NvzEDyn9FOt4KAKFujQN+u156ODNvlN3I
	 Wuc+FqHYixDczgEfW1b5x8yBPuXZ6mFh4A2CfomEXNaQWfBp5ioVb+vhI8GmhrPZF5
	 WAh7ipsUZtbMJ3YbF0jqFD8Taa9GPhGIgd7C6fN2XxroAIlVnp6TriEoQ2oQn/jdaL
	 S+eKQ5iUAffXqeU4+4jpn5ikCh+Ip78uSznja1SdXSbxBFX+mHpz5RZXmakJIM15G+
	 TJZoquq+Zq3WP+m6Qlh8zY7MD/d97N48IxkHBmFuQ7MnR8RUUtXWq5+qhD/0pmjsQt
	 bM0XzPmA2O3CQ==
Date: Thu, 30 Jul 2026 15:44:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
Message-ID: <amtjMRG7sXlGsj_t@lucifer>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-2-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715025941.1571316-2-npache@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45B5D10000E
X-Rspam-User: 
X-Stat-Signature: 9jn4q99fznhmz7dwkffd4ryehzzosoyu
X-HE-Tag: 1785422712-563071
X-HE-Meta: U2FsdGVkX1+vSGzmDoC/ocHGGNa2gE9ESTqbhM4iThtkbVRF+41YgyZQFL82OQKv3ktNKDbHQDaP/IQ3OZba2pwkwEzKxyNWsw9OwS5VmgzUI+I8LqJbrbqkLqN15iBjg2EMFaK2N8dHbm/3O9a10nx8pyIiWk+mk1EFA2V4Tj2XVOCvEPsvuQ3mLapan548WYQEw7mKLlMleEmvnmMM2/Hw+qKRRhjbIaXfHtwxWYDJb06/VZTFCfxl3EgX6lj4lrhtiSZyMlMEkZJwrGC9YnJDjviadum/LGcE9ggDu69ME8bvlNjiW4SqZZReP5UDDf2nv5zD4g37HIlXSerRK6Aj+7xYvk0dvgAlHnJ+bZaSDmCajfCDQMryc8aT8RO+Z35PBIfrq1bzEEByKcL13gtL9V25jjtSmreXXhYTsGG5JugRbknZTfGaz3Pc56K7rJisWsz+FNkXJWt0kCj9pEckybTwP/fy4B+R+r/js2uxsYAojNZXOnky8cKaDJeWs80mPVgvOru/TZpFyHt+Hu/arahMIPLRZts84bV65tp9bH9OruFjm+1ZD4/drL+ywbRpn3BsYmCN9QPQFTrYO+J4U9d+DOOa3YLdvl1WFZxXMoNE4sHOGtC5vatThZohWPHRr9SXQrH+xG5ORTsU5Ve80euno5oZp7KNpxZ3WwbWIhAlks5NIk1oOulhiKSG6tIWqY2a1WYxshy4spVFTbUiohzcIduMCvBDl2q+9zrrNDO4Bg0YAYlXFC87BcRqIyzzwfC/jXL0fmVv8HxjIKGdtKhQjvS0g/MNxXNj8kOJ83u193X1oCvZ3e2ZlYFCE2e5y4Y1TruUfKb5r8VU6yTwInUFCyJJ6SKemPxFjE3lv1uWGbAQNuYmsSXUrD+CHz6+BHzRY+78PUZEh8YWNhnusBw43IZCIvo1/55kmnmIs4pQRy86Puq8w+VjiyR2xz4ohbCywYSpuaKtkGF
 i46kWtMb
 6igM4dNUxdSYT7H8aVRA4z9BDxlYOS3Bcsmzg31We9Jo9mEeo5jNHzbqxLrMN5nNVGfLpU9IGeQ7SI4W36rWHVlTSqlsUOYUpwJFIKRlBu2y0YPaJdYvT7+svuu7DRZo1VnWPy54Z+jhcFOOgKvIaLEz5vxsHgZUdds42DYOku+4K+TIr1116BskrysIWxRXxZWYqICwALNn2/pflbaCbg33oaPfhoY127pRlRaIfTdXvIao3z1qtLbrMlG6TZqaSrPHzOhgdzPOqsnQcc2tIH+Liw1E78DHg8q74hVeOtsd6/J1xsC45qIJWKlPIkY3u7L7RJf/QS6Er9IKq4utqespKYt7ZnczBN8aZzTOkLFQ3eWNr+ePao9FDug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 08:59:30PM -0600, Nico Pache wrote:
> Extract the repeated clearing of node_load, alloc_nmask, and
> mthp_present_ptes into a helper to reduce duplication in
> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
> current use the bitmap, they will in the future, and clearing it now is
> harmless.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 55157567dc4c..6ec0812210b6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -629,6 +629,13 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	}
>  }
>
> +static void collapse_control_init_scan(struct collapse_control *cc)
> +{
> +	memset(cc->node_load, 0, sizeof(cc->node_load));
> +	nodes_clear(cc->alloc_nmask);
> +	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> +}
> +
>  static void release_pte_folio(struct folio *folio)
>  {
>  	node_stat_mod_folio(folio,
> @@ -1617,9 +1624,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>
> -	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> -	memset(cc->node_load, 0, sizeof(cc->node_load));
> -	nodes_clear(cc->alloc_nmask);
> +	collapse_control_init_scan(cc);
>
>  	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
>
> @@ -2691,8 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>
>  	present = 0;
>  	swap = 0;
> -	memset(cc->node_load, 0, sizeof(cc->node_load));
> -	nodes_clear(cc->alloc_nmask);
> +	collapse_control_init_scan(cc);
>  	rcu_read_lock();
>  	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
>  		if (xas_retry(&xas, folio))
> --
> 2.54.0
>

Cheers, Lorenzo

