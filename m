Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CEBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5376B0088; Thu,  9 Jul 2026 04:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D1B6B008A; Thu,  9 Jul 2026 04:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2966B008C; Thu,  9 Jul 2026 04:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF426B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:03:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EFC11C399D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:03:20 +0000 (UTC)
X-FDA: 84968498160.14.6F62775
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 610451C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:03:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l1fg/Ke4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5ZMUXMkvr/7WHhhpVtDxbUpZkY1abuvie4G1/u+VcI=;
	b=dkmKSjcPyQrZH6lx4Hvl0A6iWeSSRCx/BrKjciRVddukQXpi5y/Y7C1CxNnJKqdJgPn++e
	GQ6NthR6ymBlmbXX5VgOjUSL2ULKK3y1TtweozysLYK7aaSa1kmmbQ+Ar9g5V+R//1RJnR
	O/X29VhUh6f9FH/SVwXWinI0nwzth6c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l1fg/Ke4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584198;
	b=b9TTvwIioUZ7+xlMCuuDfYGSYCQBmQwYg6C6P6TM/18rmjfFKoRlkdH+pAwe9gNR7np/9Z
	L+RrWghjmeWTfSDaCqf1obpK2OwNk5lO0iHYejhbQ9Tm2aoPgAQW204RA/6MNXMG4SgzZU
	dk+NgHFRS6BE/Vg9xQiSYxRKbXAZ7vU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 759DE41432;
	Thu,  9 Jul 2026 08:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E4F1F00A3A;
	Thu,  9 Jul 2026 08:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783584197;
	bh=h5ZMUXMkvr/7WHhhpVtDxbUpZkY1abuvie4G1/u+VcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l1fg/Ke4z/FFhff5Njov+OQVa7rzHpXWK45MA/ebH+hWYUEWCOkvhG9FH+6MP8upf
	 DT+WlYGmyLAf+Fl7bm8Yd+tcYXlzOJxa8VWpumeH2G/j+DeFo/KG9uAUHD3pSgGYRi
	 5ztQu7K620YTfozDColg9z6eKx71L9ADEQj9RK0d481+ERvUAzLjiMLbfjqRNBW5Kf
	 MS3tdlg3PjzyzRSbBoADOtUE/3BqWJNHv4VY1nf5lmu4N9rHqxdNsd2s3lAGHsH+AM
	 b3cKB7ug4okAbiHX0DO4A8r093MKgdQsgQcoIEFL1looLIQxX5/s3W9tsAoc2RmpuH
	 EfyhpT/QHJrkQ==
Message-ID: <97d3831f-ce7e-4408-ae0c-60e45d00d69e@kernel.org>
Date: Thu, 9 Jul 2026 10:03:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 610451C0002
X-Stat-Signature: eqabkx8mfgxt6kjcfbayeqkc18ftegpc
X-Rspam-User: 
X-HE-Tag: 1783584198-122016
X-HE-Meta: U2FsdGVkX19lvynb37EKayzdJqKMX4k0R1Xie7tHzfglKXbvLKkhy5zWpG6XZ3tN9cjrWBwMMrcYdX2pQNokjHLiFSQZqL/54/eqWW332OKz8QodlobMPWZQomr9OGY9KEm0/bMHP3BCsO2HvRqcVzTTQkJvRNNEzoV5vTfYV9cNaWF4WzwgWY3Kg4Ffqjwai5rSTsXZmR1K7U/F6ZyLre3clb0rtqI83krrPhMnDQskMQ06MH1WWBhehL/21THP7+WpWO+FZbfAmKeTVSgB6n+lRcaF6xgR7cYhXor6ZJU/Rhv1A0JCLURTGcQ63hX8sRXnjrXjhKSxJ5afhZrPrMqT2im6+KgdFvOWmo5/0UyGcmVPRi1VXNDSYpnarSJFEGeQ64RdKAKP1QpsHwwxbi1SgqhHhKs5tR7/YotTnYGXunuPOK+yOK1gFFqnzswf3UchxGxF+lg5Lw0fjkbTMjJwKmW+HQz0xsiQaThe1iF0BNZU98QrKDxO6K+Ti0zu5tf6FTd1aLHsApZHCLYz8qEUehG0mxTdENLjISbgsmTsP5kIrTDwETIeLqgL3evZ/j4E2dPTqmsyctddP8TYXkp3iQwnwtScywOw7pcEyiHzQhgwkr+BPRx3DvL8FmOmtr3PHzPAAcMq5VwDMlurESUThCuCIZ8GdGS94uMU8pZKpak0zrQ/4UPRLy/FFbrAvNcQ6GUOSFi673tyU21EwFmmJP+m3UG5sCR//lbEZ2NLTPsuzeHXa8Izy7KZomUo2morYQfQtPu7qXZbK73KW4zD9UqgI8XmvV12+Z1xJMD+xAVpg4jjgvMOY18fnXGOxtPdZCBU7nlGSHjtmHlOKM8uKRO4/C9XHq8wL4WcbxJBVLszCAdR+m2M/1pKepRhMg7FkHSy6roIDpGi+02aOSMSQFY7SFJD8+9ffYzSmJz6nu0UiaxrsCAC1SvBjjh67MgN52LunySFYgzGHGD
 TWDwaGJq
 A9DeV74fTpBhFL5u9fmLvktTjAULRU6IDCLjestL6edZ4yQqfDbS31qTVM54ZKi0ZGiC1AbKpeddro7HW/CtsBpHRS3ue66/k9HmNkG3Z2FjpMGgfbAKKtrRRtpmttQC6AKQZLKKX0dnr61OMn8dBIsAlN7q9vfKdAQkV2v3MDM7rqTjYaGjBaxRh0W2oDKorK2CwSlPHOraY/D+pRAP4uWwS2/kaLrk983E9INIo/jdEtE1BsppJ7UuobRHZimQ4bbwnYh1D8vOca2UwhihCCjiAVyOyjWdk4x5N19mgW3Cvjik9gdMnQwsJsqomDc4ojvMmuq7JGY5/yRZLmEWx75BrSDtvgGs8LQgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> page->private should not be set in tail pages. Commit 4265d67e405a
> ("mm/migrate_device: add THP splitting during migration") removed it

I would say e.g. "a DEBUG_VM check" instead of "it"

> without a proper reason[1]. Add it back.
> 
> Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/huge_memory.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bdd8635922f96..06d0671cff899 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3591,6 +3591,13 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  		new_folio->mapping = folio->mapping;
>  		new_folio->index = folio->index + i;
>  
> +		/*
> +		 * page->private should not be set in tail pages. Warn once
> +		 * if private is unexpectedly set. Do it before swap.val assignment
> +		 * since private overlaps with swap.val.
> +		 */
> +		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
> +
>  		if (folio_test_swapcache(folio))
>  			new_folio->swap.val = folio->swap.val + i;
>  
> 


