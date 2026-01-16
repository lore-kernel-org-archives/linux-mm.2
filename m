Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9AAD4A5E6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 01:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117CB6B0005; Thu, 15 Jan 2026 20:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5C66B0088; Thu, 15 Jan 2026 20:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14396B0089; Thu, 15 Jan 2026 20:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD63B6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:39:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6484813B210
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:39:50 +0000 (UTC)
X-FDA: 84336120540.26.F4328E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD10B40007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:39:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IO46qOxp;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768527588; a=rsa-sha256;
	cv=none;
	b=pWirR+63jZVkracIqftR5ePr50KYY3rU97xWFHZ1HYci9ewK4vmdNqpqPbp19GvWRTBKIN
	Nr3BjpAgsRZZcwQxH07wKgRdrutIGZs/mdRPx1My+5pNBp3w9eebVqs0NT6B2xUMtd7W8T
	xOjGLyaQz0LgGoaDtsz76WVX42VxurU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IO46qOxp;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768527588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wagRFh8zMEEOySKPXbn/pSsjsMIjnEMxAV9//1mvHBM=;
	b=ASMp4TBOFgp1DZbEg/ZKGj7L0FLNW9lQHx1Opu3Luip0bdSAmmJKUm71u97gpCQvkbb/Ok
	lBzAvX6C1ZUTRaTwQvxfx9TwgK2zHlW7spnNlkffw3u09nc5L/GsqO/9OS328BvECd2IuC
	QIxnkO10B3sxqZI8UopXW/Ux4fkylAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AF14440EA;
	Fri, 16 Jan 2026 01:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EDFC116D0;
	Fri, 16 Jan 2026 01:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768527587;
	bh=82eNo2ktX6tFblTMXptqgcZVGgL/M43Bb4N1IqpG96U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IO46qOxpPTKW3OjU/Ekhv9YjvIsBitQhXx3/seRIzjz1YcrjQ8AiCpO6gXhXcV5X2
	 q+DLVYchsL69T4G9dAknQ5KfYuIgMr8oUXPuxkm9kU5ADKf1bU8gXkVNovkkcSq0uT
	 sjoW8ZTnlMJIn6VS4RZ5BeHkIkpAgdpxuzi96Zx+pKOc0+EVuFpZeS47a+9RGivKiL
	 Oa8DwmgPl4+tXehH6K1RzkHLchxlsI34Nr5BAKiJgC/q2NkB0wS8beYuGXRULqvSZm
	 d3X3tBbDtRJUofSPCxtwkd0LMk9YmKAPXQJqtuj9nz2Pjt3hUScIQJQgLOui2qNx99
	 n25Pr77VJbNJA==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Date: Thu, 15 Jan 2026 17:39:39 -0800
Message-ID: <20260116013940.71199-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115181438.223620-3-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rc9gac9wwbzari6359j7yfptc8ew1thc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD10B40007
X-Rspam-User: 
X-HE-Tag: 1768527588-442057
X-HE-Meta: U2FsdGVkX18UH7US0gQ1VHIx1eAEdd4fzMChLmW7137DGPrLpINs7lp6RJQgm8ZkmSoFUJgYgKydzp8ahIYBWg9Nfwe40XdyK/pdAdMAtfpysOaNT0vZjg1gUkQSADjlYdk7hxTKNOBzYig+WrV4XaYrs+dVWhBanvoT0eYn/nXPH4oT+dSkoVZNV98S59GBo3JQ28kd4aHW+Z+oyUDVaPfV4dYKINQUETQ7tx7zoJnNyJeLnstC+p4ZX80Nqc74SBWBjOzgAl+m8j89/Tn/ojEbJTBILxBGu5lv2NPAZC14I8z5oZpl2y3gvAC/wL8FhXP/ioyzGKr65mUpApmEkkagoI+rfaNtSiVMmw1eu0IwKflVB/xvzYAoAIbENVJ7yAo5m19XeRxupzO+ncsQW9RBiZVtD26CeeWVusF2q82t96n6qoStmczwJdqHyBRYOAEUy/ifiW5/thEJwPRzYJeeqNf2MtH8a9xZcVtO5mo7kUnWAwuORFlnalvcV3bWXN8rwG3e2BbgoOOCKvJO1CA+1PcCApMmKjUba9cMeSESwe6GWLUVJeOcDm0rVf82Uz4Kt1Hi4454Z56+9FZh55ymJprS4j0OLDc/CkwWo9UIVCCOspq1wM0CqNm/n2ev50a7OThk2MvlhqZu6OJatuFu7+b+VL1cqx+ybYM2E48oLVNyB99p+0nOxLn5TWDjuyNtPyknwx2+cmEN2iNxPGHPZhpdaWOTQi1/NKOjBuQ5bEsNsENInayx3VVO+9l7hFxkDmk2fxJSjHq1uAqf6GMVb6bQYVX8mkuMmbPhKYxpwoozwFprTHGA5sQdL0MS4avQm5oCIuY0VNwhDVywm2k9g8EM263ILum8SMIMiK3MbQZfTTWihbOvkr3GV8x1adk8BM4CjqiTsZm5gYyUnnYNJ4NNYsDQbfvTw3RRQp/pe74kNZfhgfLaeWgq6yeu0mjYtz/oFgTmRb4P/Pj
 qztR4ym1
 DklA8+BZaQpTlkPFUcmslhLjK2IUDodwCBI1zxuONPu3sZf00ggw9yDTCc9r1IkFnqODGxldNR065pWhKlZJS1UTO6JzWJrzT6KfQDRDzs25F9lBT5CCC+7oT3NQDkzpmYTheiBfNxwVmeqWTT5GEy2YmgYK7A+EsdelVnclns1i605kaVR6TRQdZ7nDqkSmepQfuJOurbgcRaftRebH4j1RrOI3pZJ4lPU6Q6jyY4OmDwbgSWK1amlAhjHLIky6AGzXklGhmEcNXfrCieRjHqRNMjMU71HcbaTVDWzsotaqFjHTPq0Wr6v98MgSch6yyLXXrMWJe5SL6qVg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 13:14:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> if (map_chg) is always true, since it is nested in another if statement
> which checks for it already. Remove the check and un-indent for readability.
> 
> if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
> 	...
> 
> 	if (map_chg) {
> 		...
> 	}
> }
> 
> No functional change intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/hugetlb.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 88b9e997c9da..432a5054ca1d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  
>  			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
>  			hugetlb_acct_memory(h, -rsv_adjust);
> -			if (map_chg) {
> -				spin_lock_irq(&hugetlb_lock);
> -				hugetlb_cgroup_uncharge_folio_rsvd(
> -				    hstate_index(h), pages_per_huge_page(h),
> -				    folio);
> -				spin_unlock_irq(&hugetlb_lock);
> -			}
> +			spin_lock_irq(&hugetlb_lock);
> +			hugetlb_cgroup_uncharge_folio_rsvd(
> +			    hstate_index(h), pages_per_huge_page(h),
> +			    folio);

Nit.  Good chance to reduce one more line by putting 'folio' on the upper line?

> +			spin_unlock_irq(&hugetlb_lock);
>  		}
>  	}
>  
> -- 
> 2.47.3


Thanks,
SJ

