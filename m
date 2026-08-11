Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF97C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7985F6B0099; Tue, 11 Aug 2026 12:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F526B009E; Tue, 11 Aug 2026 12:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685C96B00A2; Tue, 11 Aug 2026 12:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 494D96B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:24:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBD0112010A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:24:01 +0000 (UTC)
X-FDA: 85089510282.06.F00A7B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3372F16000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:24:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afTVKARn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lnFNRxNEuxRRD6qwiMyyus8GQcj7my2tN3yiVz05cM=;
	b=vWfdqezOexuR1FDm8aeNsM9RHisg/wy47LjHk5fTwv7PSFrqGAtFcc0Alrl1AqgF8acqhW
	bHW+M1G32ffrwjjC6jRJsRw5gn7dwF9JIRcOj281zvXqiEUpGOF8QYaJMNNDC8CN+JHkwl
	e2yhwiMfPhdQvA/9jOG/H5Hc/p4yPdA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afTVKARn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465440;
	b=kxiyI64zFi/mWjj/2JrcK2WiKiV6VoaMarZgcP7MFOob6m8QfMfagH8/M4twWfqJyJNbss
	7Mxt1hteirWtIs5kSbjOgYkVzM8j11cXH1m84YXMbCwjAvbMwicGwRPHpq9PCxmeJ3iQii
	HxWGgSP+MhqmICMoDOzARDdjXfUfHVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 568FF434C6;
	Tue, 11 Aug 2026 16:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584AD1F000E9;
	Tue, 11 Aug 2026 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465439;
	bh=8lnFNRxNEuxRRD6qwiMyyus8GQcj7my2tN3yiVz05cM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afTVKARnHiFWaEXzsU4/sBOjrpH93UFBUPgRj0BZGyWL1VOmEplr5QaL/Q2uYLtQu
	 5jl8ulKd+ljnVQnFSAa9VmxepQiQwU21cZC8cdNTmMr1XiyNzyNoAR3c02bsHzkLfy
	 Y8dwiNS2mYggmNWKyTjLD8OaXW6KiYbD4AzVePL2/5WNxE5+J0PfmxG8nqAZ8oCl8l
	 hRk7QxwzU+T2URA8geCSKDd8/1BBrXih1qUkXhv/X6+mZMQTpszZl6pF7zfyBmXpIq
	 tEVJ3n3PrGFJArBV/mUDt/jZK4dAc8w0a422wcNlCsexd+Ed5s2LvSlLphyVy1XkxI
	 y2Oat7ktQokRw==
Date: Tue, 11 Aug 2026 17:23:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-ID: <antMR-ypJfB3urzQ@gremlin>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-2-imv4bel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811161949.3879321-2-imv4bel@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 7nwnb11mo65i5g6oufozx3j9uya8ejcw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3372F16000D
X-HE-Tag: 1786465440-482614
X-HE-Meta: U2FsdGVkX1+PoXxsQjM8S4dvENhxd0Hy2sdcj7KSx4s9DJfnj3Q81Y1P05n68IiuyZx+OHLm7c6oyGh8dog6p0cg2SXvRg56gRA07eY8RUu3V3rfoif/7WAbQY0pZFnDqHVs8T02D1wjgCamOQvIYHzHAAkGYAhhl4RifyjnEugUS1GuKn0vYZ2Ld9+hpPjY4Nx86HFFCwzN3KKGEXJZQn3xvRS1zhntPH0dufLpuyei2zkmCqA/VncrlXmfHdCVLVDwIp39H2aoTvW1d79lOmut60RogmawfhoPXajcuI2Eo/27YsquO2MlLfaeYMzyH1CYF8iSHRxQizugNymVzsw9epQrQY+tHojoD3PoMPHtESVqT/odi4Pmk1Ww1xgGToMTjQv3AxybSQmqfyXd8Qh8ls6kfDbZuOvpWlPpfHVX5peP0NPsDWeJKzkrzYv+ACfD4O3xHwX2W+ZBeQCQluywB5iWmnkMB7F4vOn30kMEpq2cBaFmEgLNw8gcISfoCqxWNGdDEPBWYxQFbQG1bxNwQU9Z66CJobQPfz0+Ba20kikEZ5LyTJnrLdXS/8OQpvyfB8bOZPIKn7ZjALlUBpzG50yXCT8lyWtFwP/9LKF1bgPlrQWzt7rxDr1FY6JO+uYz6m0Fg8iyye/GtaS36XU2FBJSzoxwaEUH96aU5C9xe9w1HCVNkp95Ar6JdQ9LR+Ge4Tu6t38toKVTJHdZuCZHVYzVtENzHgiqVWs6XZp3RKq1wVrVuupd+Ju4BE4/aZ5occd4YuYxRdekS0/1pgKlgz0LYLMwUywRYUTPKJpaFzBuraQocQMO0kkarNhxA0SII3FOKq7Wsjcc2g6j1lZnXUHu5O2R88MxIytMJAW1a2lOcKeefMptBdtj8x8qyWX+fn5KG+6IF/bBqOS+eJ4CTzXu/300WcKxDdweAmrWvTwsaFdU60BgMubG5wGxwOWh4+slAbJNiGCYL2y
 6p6B8fZ1
 8q/xd48p4UzgLeOcqSBYv18wLZr4aRt1PGjdmeoGOQUsofy8TJKyZPXRqc5gHzKVBwM84l924632AEiea7cuKkpcRt/c0BNBhnVEXH07RHceqWEXRzng37jQeWWkW0uRPoNm4lqbjKuy3CdROvB3sR0QX/NYCDFakCD9Hcyl+h2TMmbPbyh6vZTI57/lr0jDSGKeUr1XNHwtnx59d4SF9swy9/xaRNF8GtWrn0oL03y+1QG7KgH7ysb8e/DdTgKklm7jVRoU4yDilwW5x+stpRTtW3my5Fl48GdVwVXxDmLX0ImTXAsokmmh8NC5qdBTuag1w5DB5hAitnnGgSoglQK9kydsLCz0kjSyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:18:57AM +0900, Hyunwoo Kim wrote:
> If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> check is retried. The PMD entry may be cleared at the point of retry.
>
> In this case, if walk->ops->install_pte is not specified, the code
> continues to the next PMD entry in the range without resetting
> walk->action to ACTION_SUBTREE.
>
> This leaves walk->action erroneously set to ACTION_AGAIN, which is
> incorrect.
>
> This was incorrect but not problematic up until commit 3b89863c3fa4
> ("mm/pagewalk: fix race between concurrent split and refault")
> which updated walk_pud_range() to check for walk->action ==
> ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> to be retried.
>
> In this case this results in duplicate walk callbacks being
> invoked, which is erroneous and will break any caller that is not
> idempotent with respect to this (and waste time for those which
> are).
>
> A specific example of this breaking things is mincore which walks
> an internal cursor data structure a byte at a time on assumption
> that page table entry callbacks are called only once for each
> entry.
>
> Fix the problem by resetting walk->action to ACTION_SUBTREE prior
> to the none check.
>
> The pattern also exists in walk_pud_range() so fix it there too.
>
> This issue was found through AI-based fuzzing.
>
> Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

Thanks, LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/pagewalk.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 5d87c632a25507..d3bfece3193366 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -126,6 +126,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	pmd = pmd_offset(pud, addr);
>  	do {
>  again:
> +		walk->action = ACTION_SUBTREE;
>  		next = pmd_addr_end(addr, end);
>  		if (pmd_none(*pmd)) {
>  			if (has_install)
> @@ -138,8 +139,6 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  				continue;
>  		}
>
> -		walk->action = ACTION_SUBTREE;
> -
>  		/*
>  		 * This implies that each ->pmd_entry() handler
>  		 * needs to know about pmd_trans_huge() pmds
> @@ -196,6 +195,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  	pud = pud_offset(p4d, addr);
>  	do {
>   again:
> +		walk->action = ACTION_SUBTREE;
>  		next = pud_addr_end(addr, end);
>  		if (pud_none(*pud)) {
>  			if (has_install)
> @@ -208,8 +208,6 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  				continue;
>  		}
>
> -		walk->action = ACTION_SUBTREE;
> -
>  		if (ops->pud_entry)
>  			err = ops->pud_entry(pud, addr, next, walk);
>  		if (err)
> --
> 2.43.0
>

--
Cheers, Lorenzo

