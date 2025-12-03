Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B48D15DB7
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 17:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9A96B0023; Wed,  3 Dec 2025 12:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0986B0026; Wed,  3 Dec 2025 12:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6826B0028; Wed,  3 Dec 2025 12:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1596B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 12:32:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB078C0677
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:32:18 +0000 (UTC)
X-FDA: 84178853556.06.9F1CB2C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6E0514000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:32:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pBY6Sr50;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764783137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXfrLUBUUNxWrlXQZfRVAlemBKM14MYadMSOQJLP4KM=;
	b=1aK8XMQc2QLQ1FxFsMTimVSFnioGGvnmR/12A0f78j0brI9kpAYpYQ9AsFvOC0WvGO4jOj
	bCw75a28sRQEoT9Fa17Pl4YnpKrnWVoBH/5CoIpx13O3FUXEIFwzbVSujOUdotq+AltXL9
	R1UXa899aNEekUtZ+pFdf8C92cH4Z68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764783137; a=rsa-sha256;
	cv=none;
	b=SAzY5mzTjLeQSK5CAMimfiYpkfAJq9tuhlXBN4DzwcapcmIQw71OBymK+P2QwslWrl9tip
	NuqhsWc16DtA2jdwuIImgXJOgizJvtFp5g6zCOHVDsJHRCHHPz4dFBnUtrDvBsKaAImna7
	avZR9FwMLhp09CoW86iwBS9TJ2lcBYE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pBY6Sr50;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so272111cf.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 09:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764783136; x=1765387936; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXfrLUBUUNxWrlXQZfRVAlemBKM14MYadMSOQJLP4KM=;
        b=pBY6Sr50uepHUCSkosc4pEujTfYXBNN6+so9+OcwNZLaxRaa4DGJ2lSzTsHK37j50w
         LgyxdWFPjBKyO3QVf0sF6Ko8OZ/ZPz3G0URUpbG2X/+qq5wat+71Mnak6aSukqRUIrJM
         VgsDFwuHUSccRji8EE4QJkPnhGgtGBwFAZbU5dQq2W181OIDPuv1egi0YuHdKN8qeHnS
         3uP0JxETvnWpAIa9Bmg/hLcRiPSsehWEZggaNkOVYs7dm9gkRvGqhUjp0ZO/Nny0Lqw9
         +AwUEZWsq57XcUfYB122A5oTABlEdzraB6qi2O6N+x1WxrOVJCdUEcKC59m2DT54z2vR
         pTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764783136; x=1765387936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RXfrLUBUUNxWrlXQZfRVAlemBKM14MYadMSOQJLP4KM=;
        b=nqZ1wkUndf0sblG82uRfJJGma0NJ6j4GaFszY+GzJlwTo5QMMVIG8OdkpozHMHFdr8
         35Y8CCaI6kEqU1ILh4xOGlqZ3dmNCQKDn+8BFltagEgL0EubYJJL6OECztBG8dVss3eg
         ma24aYq5z4XDQgg8STwGZdhOzE4sK7dmWssqKasrj/9SRK1uFHA6dptyPe+DL8Vci5NE
         lupgVxNeifUXbq9/zbfpujk9BMV9hpd2UvoKffefiGFWoqZWYBWTmooGghFO2vllmGwx
         QQBQxEZhA65Hl5wQQTdzjjuBwkZMp8wrpN8JZFajg7dCbOUvlhZGbl3vAqXz+mnxSxQr
         CeTQ==
X-Gm-Message-State: AOJu0YysZLldAzH3NN3yMky/y3zc8JyUh8IRU7plLIgbCbUqEonDtqkm
	+jYbVrwZdD3wffHZKyDRmEdQFLxqAlu5B5xVFEQbZOcMUxveiLbtGqFJ6QBRR+1CXTQ=
X-Gm-Gg: ASbGncu6ahHrEC9Bpqct2VOmmHhfgwlTgHUWk4b20qWx3q2rolfLo1i1h8QzMKMFY9Y
	+WlezbJx5XojAt62nrhoV5BCZus8OSmh9l9c5VFdgbhGyeSJUKbggLATRhGzXpLfqnOeW9o5d8I
	dvf6KAKDzqS7UIPlkxXMQHw01BrdZVrpQ2XzN331E/0gquXPRakSUIWWMrBGtGr+TfmLvNS9eX/
	bwJRm/DZ+0zFmXUkk1Y81q6iF02QluamxK04namHHtdglgjNhBK32MCeBI+/oRoS5CLPfARAlQL
	TsrXNkRRNK5G6Nv5RQMqKWQbaSGEAxGpfols/kBqytLRWcnq7hFhnqfOVw84i9u2hpdt9TPVX4x
	z6G5hEST28q3QlSDnMqZOa1t6F8Su+RniiJW5c8oV2b7ExXsmCf4EItEbFX+wIWQxrp5VFuQLhW
	HEwWBArAn/IQ==
X-Google-Smtp-Source: AGHT+IHjhRSsYojqPIH4nCotrtO7/FPORpmU3S+uq1yOdc4D+I4pkxVbp8jOs/i2z+ku8NQQIlusKQ==
X-Received: by 2002:a05:622a:1489:b0:4ed:a744:adc with SMTP id d75a77b69052e-4f01757f2e8mr38710771cf.10.1764783135284;
        Wed, 03 Dec 2025 09:32:15 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd341f2f8sm115763391cf.22.2025.12.03.09.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:32:14 -0800 (PST)
Date: Wed, 3 Dec 2025 12:32:09 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, x86@kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251203173209.GA478168@cmpxchg.org>
References: <20251203063004.185182-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203063004.185182-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6E0514000D
X-Stat-Signature: 7iuwdytp4mbjzuq368b17qdfz34s6i5o
X-HE-Tag: 1764783136-664985
X-HE-Meta: U2FsdGVkX19TtrHI+Kq73GWtFlvt58rGWZU/8qg3/tjNo7T7dI+Fl2/HIzm7Rgh57FFWoJmbPdERiVvPs9zjsFU9J6nv4CNzgFNmmXCgmCA0q7oKEXl1xQtQgm5OhMzrGL+SryH+oLFHK05ogXHfKwBXL/mn+RyeHOOXhL5O9tkJlINUcbTMvx7wXTrcQBVt1vVRqFNZ89fsDhH7UHF6jgzFfRAjhs+c7jugTLA0admoWS7JRuncd3GwhXL+ILT1128RlI75WnY8xbCSdKU9DxBEaWIsifehXfcxlgKDDVgfgyso/S6YXA3bF30y8zBYyXWQn5u7xMwJxlF6d62t4Fnfg23jY1dRoYrYLRKRDccx/VzGkU73rxz3mipPbrsRxPYlXKOCm021gWHx0lOA0NQ8aZgxgOLwqiWnvqyC3hlyyRL93kUCLcqGM4aJJMm9l1LT6WLDLHlDTEM2dQRKV6J6ZXSLORTK+sEnc0/GI8D6aH+Y5BFp0tx+SZwsO7zXQow706Lt2rhzThHPjQA1sSc0W3ItJqadqsQM3OAR67Tsu8DxT7eqovJk6sAH8ZUuRvHG5Y5wl7CMwr+qskVqBdVeuEBfKu2UkoOxwPDeTsZAbcIKWGpBG2ylbqyRFoKOENrETuUW9kfj5nkzN+mSB8ycm/j5ayjw+TJgAvt+j+PpaKCU2Wo2xZtWPk0ZelD8Ci9gvxUTgGtZ3v1zXb1bK6OQo6BislFLcFwqEdKPn9JaGPIjdBx8FmziO8UJYsGx/gjGUjibgUetL9zkHxh4cZs7ndsjmFr8ntrmphuL6PAwbv+HCNgvy7zRQ0vZmITFrzn4ZetT8Cg4lLNrXauEMIFo1ilfeDaI3XJmLb0fVdWuI+6KI9tjvlyjaxokwlT/ICdceN0vNk42DlBmFQS0r5hJQoMImwLMVzOPiuGzipKWJykjZRoE1Yhxs+Jjccegw9yP9GwivdEH44mqxya
 kDHP1UTX
 VrqwmNzUrqd9zQ02TUoN+TWc4g0qqSaklNVgoYb5QrQtRIKDWnx2rGLdfsJosrAvPXoNp6Y6WFr6gm8D00kurjeLOs79nSHRQ3mEhphZYMyukWLOfGXpW97iMpMf2xCgM1f+T3liU80tEAu+3Ax1KYKxN91RQG0K0dvcSyBNXP8xhJe+d5hE2DttGg6nT2xr4m7zDzisj3Sf9hrsDyIiIMzT1AOziR3+x/OW+1M4u4IJYE75Nb5WpdqlTaN5aL1PlJX0gGVde37dZf19jx92ddYjIrLc3zUzem60F6a61qLUIYUevU3ShJb95LXkpYB1VTHX5gRMQK8T130HRTd/IqAxFyfBE1+8DajYKJOtxNJzP3GRRai9q7cpcWlN8HaimDyegsDmmaaIqjQdENmrU5OARe6fbFWjyh7ZosPI2A2y8y1JA3deJ2Iu6bjbTy/En7N/aa3Cud0yjNLCAmHG2pG33qwiEvQaoUQ4ZwDLsgyQL8EV7l1UtJcRgu4T/ZF84ok65xD9EMHXJCISypjQj4eGDVhg6LsJlYIO0RW4NEqzlhYfllpQ2BkU489woKBdYsr4hgcL+lxYdeMlC5xoJZhW+vbVSEQ8O2U5Ff5LPOcCH4TJUS7UvkJk1PgssB09BfpDvA5J79uIKCgpXImGXzZL1Wr25U1Xr+NnX0MDpOxMDay7xU7jY/kWxRvF2Fc4EdPHZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  This will cause otherwise-movable
> 2MB HugeTLB pages to be considered unmovable, and will make 1GB
> hugepages more difficult to allocate on systems utilizing both.
> 
> Instead, if hugepage migration is enabled, consider regions with
> hugepages smaller than the target contiguous allocation request
> as valid targets for allocation.
> 
> isolate_migrate_pages_block() has similar logic, and the hugetlb code
> does a migratable check in folio_isolate_hugetlb() during isolation.
> So the code servicing the subsequent allocaiton and migration already
> supports this exact use case (it's just unreachable).
> 
> To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
> and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
> (Scale to your machine's memory capacity).
> 
> echo 24576 > .../hugepages-2048kB/nr_hugepages
> echo 4 > .../hugepages-1048576kB/nr_hugepages
> 
> Prior to this patch, the 1GB page allocation can fail if no contiguous
> 1GB pages remain.  After this patch, the kernel will try to move 2MB
> pages and successfully allocate the 1GB pages (assuming overall
> sufficient memory is available).
> 
> folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
> other users are debug or init-time allocations and largely unaffected.
> - ppc/memtrace is a debugfs interface
> - x86/tdx memory allocation occurs once on module-init
> - kfence/core happens once on module (late) init
> - THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 95d8b812efd0..8ca3273f734a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7069,8 +7069,27 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>  
> -		if (PageHuge(page))
> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.

This one makes sense to me.

> +		 *     Don't move 1GB pages to free up a 2MB range.

This one I might be missing something. We don't use cma for 2M pages,
so I don't see how we can end up in this path for 2M allocations.

The reason I'm bringing this up is because this function overall looks
kind of unnecessary. Page isolation checks all of these conditions
already, and arbitrates huge pages on hugepage_migration_supported() -
which seems to be the semantics you also desire here.

Would it make sense to just remove pfn_range_valid_contig()?

