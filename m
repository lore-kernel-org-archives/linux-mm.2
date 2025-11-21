Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECFBCFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144756B0027; Fri, 21 Nov 2025 14:31:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BD76B00A1; Fri, 21 Nov 2025 14:31:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059016B00A3; Fri, 21 Nov 2025 14:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9F196B0027
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:31:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 800E916071D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:31:42 +0000 (UTC)
X-FDA: 84135608844.22.4E13089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A879820007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:31:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XlfmxEk3;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763753500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB6p3uSkvhuU5q3krUe+UZRcvlU4M/5mD1B8lsFST04=;
	b=Rt5XlFZcda/3y1ox5ljXREiNok5ZsTFSAGgdtG/5P72IJ37Q8I8Oa77fpCXpnaspMSQrCR
	ZWRYi59r4UBPk8fZQtipTgTB0kpRDIej3MqB7iIcJqekHT2Fm9ZSgURqUf52blJhIo9WWq
	SfCpDZdNa7pfkVTzNpbM3SQVnr1j1O8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763753500; a=rsa-sha256;
	cv=none;
	b=Up0imGXGPHuEcferVonvR2qMDqUH5Rl9MT9ALrQkUnAXqDnQ9Hi8dWP11ZgRCQXjU9Wtiw
	/3OJqQCViXwrM1vCNDFMvWhgDV8nu4J4nLaEtLDqXIeenLMs27qUbAFT7lEaSWQLPhPrPK
	Jb/MD4iP6xRUF8c3tp4sZcW1xNdP2qw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XlfmxEk3;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BE6D44369;
	Fri, 21 Nov 2025 19:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81DAC4CEF1;
	Fri, 21 Nov 2025 19:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763753499;
	bh=Od/tHklQw3fH6Wn+uk2dHPMmYlEu13bGh861GdW3NVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XlfmxEk3vKdIgqeJxzR/KtNt94w6/kXkFJYkVLu3TgNUX5PP3Rl0MeOjqsd58kvYl
	 1mNP2dehRPrbMn3lW0bm/4RZzPaZ+N1twwqR29YDSEcXcpsk8nWr3tjPXs8H1Sboq0
	 JCBL8JLdhV2R2sL1vdvbgqX6J3mrvFwYx4mCTsgU=
Date: Fri, 21 Nov 2025 11:31:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-kernel@vger.kernel.org, David
 Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>, Oscar
 Salvador <osalvador@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-Id: <20251121113138.9955cb18d9b6c7ce812d5c0a@linux-foundation.org>
In-Reply-To: <20251121191540.253624-1-gourry@gourry.net>
References: <20251121191540.253624-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A879820007
X-Stat-Signature: f88h1qpa1f7u6t7wzxkudmfetoa3u5ac
X-HE-Tag: 1763753500-158680
X-HE-Meta: U2FsdGVkX18RzH5OjwA5AQfQxL4JQkRyCLYBGdZZebGfkY1sp1hEH3pxPd4mzoR1Pf+JyuCEurjGljEqLbro/qLH2Iogsa1vH5tvaYEZK8UGsf8YXsrYdoMHgq5lyhX5k/xjBENk8BqCeCGkcPSPhJR67AejjIw2y8liGfrP51B3K2AgakgUYdrpac/pm8V44o8ZUK9pNO1Ffk+EIoI92J+ZR1hi39+TWAXxQGbvc9tYPJWHi1/1cPx5X6n+njBZVGBYT3bQqgRwYzSJmmLI5+Uw2Dvr23PqgSbzxcAue6gOKI3E+M989sfBSq5BaF0ifR0OVdhn+OhhWqFOjsj82xmelBWeYJWnpSxPIc5pkRmsWCadHWVQurdmP/uo4hqF0DutIJKMIt4ufvm/y0dXp8HegkqwNh/hpx2vaiDD9STwaOWyvypYenjW0a2x7DsiCQyqtfc7fYcw+BV3NPA3fo7cxx/SJcj7fgepepqUdq7e1VxRHQM9uxgT+2oT9BokO8yniool4bn0njzVcKcthwnUHnvt8MMYEMzQBln4vhCrJSb7Pz8DUeIkFE0x+BOGQhNBfjJX1/Ms2c+xlthG0UgrcVbPmJIiZHalE5YbJbqFwKja23FJzLkRJc6jKKE+qBxgxH8J9ZUAdbLY5QIAw51l+Dxr60H8wE9mA2OflMZ0MXPdEiC3HxdASJPiOiyDAxzgwI/9ts8Cz/Wn6e0F9RLdLu8gzW+ywdBmAUHzMcyHpYIrbsgsp7XHz3Qmv5ia5uAN0EPvpe+YgE9b+rC36LLB3praAiDHlQAhcCEwH77K4/KVLK8jjEFmYPHwz4RmHCFHhtUXfgco9IfjENla3qlF47cAueyAGdIPF3IOJXigfXrxYpgmm/8JneVT//Sd4bv2GWrHWqQJw4HM3LeudlBITAE8uw8gmACR8szMmCR5TGQDBzigaDezZTdmIg1NtxuttjUPEnTMB1kKUPZ
 ycR+zxoU
 PFcKw0/6m8rO5XTJZ0OzSgGloDnOx11cJINQw8LiLy4L8KDxlEUGtWq4g3h7mMnQSLCLVgHmcsfVPj+hIEm4C5LmDI7ByzVIVLoDGV+rSMSy1H+DsQsW6sbfbn5e87H6SPtBk8J1/Lvgkjn5MshnP66o4CS9bKqfOc62Su79ctZZgiPjrXT5XrbCrk/tpPAVhcHLD5ELVLWUwZkokHRhv/aeiors0KiOdLbowfFoAJRavJWyESJY3ENEogl+U6yq25w0N+k1gPSuUdKGhqQlwgiNAob7mjnw2iZIzDn6EwpxxhIQIiSOMgXaWXaTFMIYlBRuTZdUEfGGrkAsgeZp6EaxLSICsIqcuEL0gy0dXviF3OMpmIAMyR8Ou+NdNHu587+WIoxyPR9CchXImix6XfnQA6Yz4KGuo61pGVkSSxMRedKVzysWQP65rDaocQKN5RSPB0DsjQRo5cUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 14:15:40 -0500 Gregory Price <gourry@gourry.net> wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.

Why?  What benefit does this have to our users?

Some runtime testing results might be helpful?

> isolate_migrate_pages_block() already expects requests with hugepages
> to originate from alloc_contig, and hugetlb code also does a migratable
> check when isolating in folio_isolate_hugetlb().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>

A Link: here might be illuminating.

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6849,8 +6849,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>  
> -		if (PageHuge(page))
> -			return false;
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			/* Don't consider moving same size/larger pages */

Comment says "what" (which was fairly obvious).  Please reveal "why".

> +			page = compound_head(page);
> +			order = compound_order(page);
> +			if ((order >= MAX_FOLIO_ORDER) ||
> +			    (nr_pages <= (1 << order)))
> +				return false;
> +		}
>  	}
>  	return true;
>  }


