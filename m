Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0746ECCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648C28E000B; Tue, 21 Oct 2025 21:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA0C8E0002; Tue, 21 Oct 2025 21:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F708E000B; Tue, 21 Oct 2025 21:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 408508E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:41:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A67E11406CC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:41:03 +0000 (UTC)
X-FDA: 84024046806.18.6EB56CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13F35140002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:41:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6R32oOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761097262; a=rsa-sha256;
	cv=none;
	b=OzgSjC2lt5LYK1kmMbRgeDZMPpsVY911CDUktAnp3400vR3iH0VDaDHLv/gy/3viRrAQFn
	nbm4EX4KmV8Fv+EHlSEoGp7nPi2W5kUTe1oE0sr0Hji42SI/2Z4nonSqmiQFLSUFNbL8G9
	mHZcy0FaApO/IQq9DTiDBPo6BoF0+rA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6R32oOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761097262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fd20mApyK+mxKG08w0fEseGb80gG5WJAMvek68TMoBo=;
	b=P7PhghkJdJhwqCaZrEZHGSC5XztwL5civiV/seU6Aqtjg/OWZTLKxWLYmcjeE9DSyAFC5n
	zWzn8xGDVbNXXQFj0sgaO5NOB2RPuLpb2WOdV3Qs64vLTHhqLReAiDIAll6S2U2/5MCpaf
	ewX6stsMHHJstR+Fp9o7zl/Q8uOkwLo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5740B623C1;
	Wed, 22 Oct 2025 01:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D019C4CEF1;
	Wed, 22 Oct 2025 01:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761097261;
	bh=pFBBzB2arJXkNPRvMZSCJ6eRnA/xFysNEdKKlZiu1IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6R32oOqgjh3e7Ejgb67KUf7y3yistL/0VVbArQ3XlTq2vuLG4aSIamn8YoqIw2rX
	 qpnrTOSv1Q3UIRJbNgplZQPp9QZsZwbdN2E5um551ARVWFkRRCWEX0bCfB5ZSNu1kg
	 CRrAqr14Q3cBcUy5YDnahW48ltXD0duwPo38jkBa8EhIvT54aE0ao3PzEJt33kpNdz
	 G5ki0cy+bkMYyLrWurXwzb4TH3djBQpEzot7JKTWqeZJlblufIHXbAOUwFjMkiKxBm
	 tFUPOT5JjDySmsY7sG/TRFZr6RiRaM+kRRVLQCiBleiFMfpK77ua+Zp/tVHSEuQ0sQ
	 lOlFa9KXZ/uGA==
From: SeongJae Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages during contig_alloc.
Date: Tue, 21 Oct 2025 18:40:57 -0700
Message-ID: <20251022014057.128900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020210816.1089910-1-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8t4rqght798uqhw7mt8qfu31rgt7hamf
X-Rspamd-Queue-Id: 13F35140002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761097261-137104
X-HE-Meta: U2FsdGVkX19SskOj0gCYDvvvRx8UuJrbZBPNuZFgaastgd9kIUcxEz68BlWVVhPsqDu/oOotCGxuKrkDphm+5MkjrqrkxU/JNmaFdTB/L4e/pid+BWVSDH6W/jGtjS36NK8J3kc6zYsYAQlCLKfyqrV1vXCQfE7ApfCjGwZGbXyzBXM5Sh2coQjwzXN/tURqhy0SZu1vfVSsioUtWvK7E2WYt6S5ZCq5iFjdD9V0Yf3Fq+IByMqhYFKMWXEp1ADPg6xZ6pDBHP5BrhKZuW8k62tuPeUYOxg8QQDuZwpK7+lNyVz7Is6x/cwl/CaP4vn2GgSMgSsB5yu81YnRBooVUdzSI/1WWUfr5+CdtcVQ1lALIxFA5NSpuAY9HNmvtD9E4hzfQm1MKGtzZ2wTGZo3F8b2xmhpMTQQQ6yg+xcofJWGmgKHdYahum14IeAgHCmtaT8dzcSnp0EIaANz45GVmJTgbCSgN1+sxJtIrO3uT5e6QpCbcQ8eYR8bQ3llP3MDlflyh21geqio1DuNdlgwbPh/4YwMbhakN4Zb3kfHUNNlHJBfA8M91n896hdmYQ9VWIGF2r9Nznt1gDq1SCn/u1hVhzq/QRthHHW8gnAwUmmOhlp/BlRmSmbm8QZm179n+RFSKKB0J+6k2V6vvZUDaiKdUZ629xXfJr2/+7UJvF6K707w4SRRX/lxX0m7imcrxRqJra5ua7NbeDTSC7HlPI5/TT+5kK1/8DjE3l0X2z3g1DaLKugnZGAUXd1LIGRBHP/BiOMs59pPKnhb2qUqoDNvXOY1WkzGvXAb6axPNJZ8zi9x7yuNmFX0q24JeFyN5NAzyAEGm5xBKSDlJcqVu/lTIWIpCgRF0iSK/+aJVyMvaN5ss8IhcpZ91XQK1+zk9dn6LfoBveAqP1NCGyauoQEj5M9l5Y4NZ7UDF1e54eda9oM45D4joDQabsXlNAXqRpWxIUR1vYcycJcv81w
 hSHyt6bw
 S9mTtknVqhNAMKD+bd89zU+iTX2471j92xZ7utCASdLytkh383gEWRpKCLdTcrJ2/zCXQ3Sdq3KYGSPW6nrtDDeM9DbP7ySFrFayPSihK/bZWR+pGKSt9kiwN9g1sPhTphAcCcM792repzKJKg4r/Y40hcmy8zpNinnoblRgGbUSI4J0Rf6bkOlz8Nv1WDrg8F1Dgx073jgvg0EEyfQUlpAebIVjxaLkbrRuUmhK6epOsWe5iLveckopTAlZLOrJztZwQ8i7ePUwBFNvpxO1OyQx9Pp3tSh8ubo788/3P4rejnkMfh1dD6b1f3gCRog/MjZpHBMG/D48JPycxvutWL6CcYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 17:08:16 -0400 Gregory Price <gourry@gourry.net> wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the requested allocation.
> 
> Compaction `isolate_migrate_pages_block()` already expects requests
> with hugepages to originate from alloc_contig, and hugetlb code also
> does a migratable check when isolating in `folio_isolate_hugetlb()`.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23..da2e65bf63e3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
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
> +			page = compound_head(page);
> +			order = compound_order(page);
> +			if ((order >= MAX_PAGE_ORDER) ||
> +			    (nr_pages < (1 << order)))
> +				return false;

Shouldn't the comparison of 'nr_pages' against '1 << order' use '<=' instead of
'<', to match the commit description?

> +		}
>  	}
>  	return true;
>  }
> -- 
> 2.51.0


Thanks,
SJ

