Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A26606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjl5uRMQ
Received: by kanga.kvack.org (Postfix)
	id 82A106B0718; Tue, 27 Oct 2026 14:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8015E6B0746; Tue, 27 Oct 2026 14:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717746B0752; Tue, 27 Oct 2026 14:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4864E6B0718
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:22:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 226931C44EA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:22:48 +0000 (UTC)
X-FDA: 85369227216.06.73E0B37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1152340005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:22:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjl5uRMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793125366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obb3v5fGKU85iJO0mD69p2W4FjTOwMdMp1biTOE7W0o=;
	b=pDOXqEYPzdmKA18ggla1F+xXBcX0rvGxxyWBGIKqGeyrQeFyjuNWQ/nZckRG06cCnqJgMl
	VpzcXxSQOEdKEsrYHhPKBszequFMgEMwaNLGMso/6OdfYjPW+0vacrp5AZ2di6/wY87+KO
	jYUhxy4c+V5J9siWSb5mJfWUCz+KNPg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjl5uRMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793125366;
	b=exE4+rtFlr78yU5fMQoyPbg2S/7FhjTxtvSAEJ+ODKy97vreklUw+/rIeBxCb7ngvlHILh
	mrBUVK6BeogIllZOew23Gw/M6FPOkGfLtdZVYtGgXxm9zj+eb904i7IoDk+Le/9Jvt7gDZ
	vylXckmt/sub/hkaY/3/CjL/5Wt24BU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3741A402D8;
	Tue, 27 Oct 2026 18:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F691F01825;
	Tue, 27 Oct 2026 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793125365;
	bh=obb3v5fGKU85iJO0mD69p2W4FjTOwMdMp1biTOE7W0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjl5uRMQtDw4sa7ePF37pVMx7YTRvjHfgTVH2kK4v5aMm/kdR84Gput75aBN0JtBv
	 dTEDp2qN23JkdcUBqwdjrxdvyvpSrtmXrEkI5JTxxVNtyRDbS+ichyyMWpim0YxFuk
	 Ga5J6xZ0fMZKkcJz9pFEvxXtaQVpNRCUmh9mERWWpcBIYycYEwrME+WpYT3BC/SiHS
	 AVNIW844Kf5MJ1O1irSPBzC8+fo/sqd8X8vHZePFA7I+mIabnWnArtyEegbojyGhvZ
	 djNFgZWNVQ1PGFgX2XKF8KienI7P2OFXOOwQPEH0QIoI8Wyk8WqGpDPgTRCPcrbq87
	 Bm0HEzOO5/qdw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id A25441980054;
	Tue, 27 Oct 2026 14:22:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 27 Oct 2026 14:22:41 -0400
X-ME-Sender: <xms:7uvgakq1wd2xHX6qAWwxIQ7jeohXQ7CxdSZSvPDl98-8rM09O4d-nw>
    <xme:7uvgagyQHb6s2qkFKbijyVxCPYzpGsLKQ8Xr54O0HPTSUQl-Z-MMpWrant5F9k5Bz
    nfiUvNRYvHEK-OymhPopbXEYTQ2WG3QFUkkIPzq-jdDcZeKgZ5gHMh2>
X-ME-Received: <xmr:7uvgavvOQn91cJKYJokEUFXgSr7-3UoSd47QBFRQNuIviiaZkQ--UY6JUZU>
X-ME-Proxy-Cause: dmFkZTFDuv05WNRSWeTXX4SOcM7Pq283a1SrPxRBy6wxzcTjoiCC3072NyqldomkTfni0J
    GiuRYiLi5KHo1dePm8l4jtqdi9xDlu9LGkfK6YNuj4I2rqeh9S6fYtfOaTxXshHlL3s06U
    Z9Vstktyy1izTtY4tHGm5r1KzQaGPk8mtWShCrIKlbj0EZC3kn5zI7OGVGXi2YAl51X6bb
    +MXAC1+hkQDv3qLpjgV3bAoxJTCRioJdUHKc7aO6M4C6YC189TpUkvxUpCHcLoROBVHeO7
    Et20anx0vJidDdWj3x+AmccUEc8fDklq0rukrhnix6n3NY91aw6KvJkdI3wbn9c1UmtfAx
    zcE8AhVh2ZluJIXmS0kWMAyi7muAT6qXMSFPfk8BDg6oiM0T/Chv+GPwPKCXXceYTh5rwS
    Kw/0OE+DWJ92UTUtK+NQt7OGa72wmiInlxBY3FriUs8+dBVnco7Vur9gklpOVJKNtB4s2Z
    u60ViphjBMnRfflYQt+H5iAGjOFv2kfyjfNfKoptKTJLj/hOwNrIe8+u6tLTHk2wZnLSUF
    h8r0xSvSrEh+qT8WygkzMTo3aPzS8lFPTcHx3gQmRc8zQVh2u0+KO7l0Fgwt8x6tkZ+hzS
    DKvnUzj9UzjqfbmaOZ1JPTeQRNloecnzswl0CgoMRZjlLJsb16wmXn7NFx3Q
X-ME-Proxy: <xmx:7uvgal44ZH_cTnH_wQR6kp8ZYa5XkDTCw1aZ-qQ1rROSRp2xXDBwcg>
    <xmx:7uvganiT_5UfFRj5BACHraH3bOMchZfQSPgP_A6WmAIOFPRAwKjrIg>
    <xmx:7uvgavICY8PZOvyS5w2ggmDoEFrukcxsq3aPNdQg0fFgcnqtmw3I-A>
    <xmx:7uvgatdTk0tUwXMz1Gj8T-Mo-FkaH8TYboxQ_0t6Bq21jovGNeDvqQ>
    <xmx:7uvgavPM1IklvtjqhPvu18zPi0AlJOS24sn61Gv5WJjKhFUh6_9_Zwhk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 14:22:37 -0400 (EDT)
Date: Tue, 27 Oct 2026 18:22:36 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/3] mm: add anonymous mTHP folios to the deferred
 split list
Message-ID: <auDqq827gVJePL-z@thinkstation>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
 <20261023230006.3759543-4-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023230006.3759543-4-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: 1152340005
X-Stat-Signature: roppu5z4geu8tffgbce86swird59i1d6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793125365-842895
X-HE-Meta: U2FsdGVkX1+Fq2YymfIIelcufqVi3y5I5sQFYm1QnmQBjXubo9xpLuHyv0OfRsry/tuXPe9NvoO9u+RJStLOie2bB4DxdC0jp3raXP1mtu9ZH9PNqfAGQfijM7DvUPo8AcqRbolazoV/69bIWL8OGP54EEIUYYxYx48em0C7V77TUN3kQkRRPeJJeoGhZch9D2QFN/G73StlxUN1zmpLmu0go1OG6kayjNR7jFcXXPAm8SmpV0GpK6aNG/puGu0TZMmPMiB8kWevRwyLAyfTJgPhiettGlUeRSSGOXID15KqDh8H4BR0ohYsgFfatqfrx0OVqnKf1YQWaip5irIJkso0MKJB+36W5CVgR/i2hBKchU7x1vd+lX44Xlz84pE8yVWPdVlKax6aXU2vHwEXpCUdXq8YniJ+EgeVzJ3sCUpNT1RTaKIzuuFk352yL1+yPWTRjpbCNoFU7Mupze0M4rSnE9B0FYn7QcGVOQb95OPg6vegdlpiGUDt2+gNo3QdWKRrpOjZWActaMhWwqLNLR4oPaBqQ8JlKNHYCnDyrFs3c4WvydA6A3kaFdLeh4eKIp3NlmTGnVW9LCRQJRiI3R2RDzIdORoQ6Ior7WroByOwN8AmM9JPrKP+ecJioz24dzmK+vUS4WvxlNJEPEctZ4UhrjvF+R7UJKgTtXVEI+pefLEZIRLLpbfXXnUQnDbKWOicWSQiU/3xZ6jJNKOqqtzu8YWXVM4cvO22HIYC6kcu87+MMw6NSlBulL6bcRYsBRs2WNWQKaCaIpbu8RYSI/FQj5bG0ypKnJ1Xk+hAd1PEijwrANUHjkoKzkyLkOqhSqVAxHTHg857b83r34gGfKJcCMt7wIgEANLEb3MeA2yAt2dM0NbYeDVa3eKImUy2yCKB3L7AFTobzQNwHo2nHws+wOO2xshhl+kwO5Zde6h85u7eAGant7N1NU3/xM4LyEVJ1F+EiGO0I1CIh7J
 luOorU0q
 TJweZY8CbWuBwebzKjjqXkg4dRKDoRBn2avByzh4QJHFCSJAjMKh3maCBs4t8HswsnrszLEinn90SJVd0yakkQd20S7tzPPZUVa21DD/0q2FYVUCnfKeAoRgQVYsDb8cBGnLxUC5HQdXTADFKqam8/0ZVbuogDbEsSWQ/URyW5DRIHAZPSy80Ob/qXckAtLZcdjwG/X8zXULh8/hH5C6gsb3SGvcgRo3TfbXp0kdYMn1ADXw1zG7EK8tWOcDci3bI7UAgWHPaWQ7XZhSaDR1vx+fstA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 04:00:06PM -0700, Joanne Koong wrote:
> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> to the deferred split list at fault or collapse time. As a result, a
> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> the deferred split shrinker when the system is under memory pressure.
> 
> At Meta we would like to deploy 2M THP=always on arm64 with 64k base
> pages, as 2M gives the contpte benefits while the PMD size (512M) is too
> big to use. Without underused splitting this causes memory regressions,
> as the unused parts of those folios can never be broken down and
> reclaimed.
> 
> Add anonymous mTHP folios to the deferred split list from
> map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
> already does for PMD-sized folios. This covers both the fault path and
> the khugepaged mTHP collapse path. If there is memory pressure, a
> zero-filled mTHP can then be split with its zero pages remapped to the
> shared zero page and reclaimed.
> 
> Only queue mTHP folios of at least 2M for underused splitting. With
> thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
> folio of order 2 or above could in principle be underused, but for small
> folios it is unlikely to be worth it. An order-2 folio on 4k base pages
> can free at most four pages and on systems that only enable small mTHP
> sizes (eg Android's order-2-only configuration) zero-filled subpages
> tend to be few and short-lived.
> 
> The minimum is hard-coded rather than a knob, since admins have no good
> way of choosing it, and is a size rather than an order since what a
> split recovers depend on the folio's size in bytes, and the same order

s/depend/depends/

> means very different sizes across different base page sizes. It can be
> lowered later if data shows smaller sizes are worth it. PMD-sized folios
> are exempt from the minimum in order to maintain backwards compatibility
> since on some architectures (s390, with a 1M PMD) the PMD size can be
> below 2M.

...

> diff --git a/mm/memory.c b/mm/memory.c
> index 976cd03954e3..0622425649c6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5501,6 +5501,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>  	folio_add_lru_vma(folio, vma);
>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +	if (folio_test_large(folio))
> +		deferred_split_folio(folio, false);
>  }

With this, thp_underused_split_page starts counting mTHP splits.
thp_split_page and thp_deferred_split_page count PMD-sized folios only,
and mTHPs get per-order stats instead. thp_underused_split_page can now
be larger than thp_split_page, and the per-order split counter does not
tell underused splits from the rest.

Should thp_underused_split_page stay PMD-only, with a per-order counter
for underused splits?

This is messy. I am not sure excluding non-PMD splits from the counter
is the right call, but it seems to be the most consistent solution.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

