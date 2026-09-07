Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6791C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94EDE6B009B; Mon,  7 Sep 2026 05:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900256B009F; Mon,  7 Sep 2026 05:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815AF6B00A0; Mon,  7 Sep 2026 05:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59E526B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:05:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C07E1140692
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:05:29 +0000 (UTC)
X-FDA: 85186382778.30.2B756E1
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id 20AFB4000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:05:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s1QvXXpe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788771928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXvYn9pGOWVNNZIM5zX5lrQlK0lUQ4h6ryyAL9cZz38=;
	b=VxlB/fWAQ30J9mXQzFLXS1XCWpHn4zAb6momM2wcEkrBDpD6f7i/K3VeD/ZTW3iOdSxiAk
	mafnI5GUijceRPlRO4BuXejrugkZZ+ipbfxVkDY7Oh0+0+Q03CG5GCsdDlgc4Dg4ZfpS1+
	h1HKHI2wOOK8oIVaLXuga7x44NLjgdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788771928;
	b=vuh7EINrcq22MNuO2GjWbggXdLfUp3wyJUy5SqE9FbzFwgAsKQ57IPXi6tmaz8dW5DLH8g
	tzqJ9gN+pTICplXTpoJH5lzglyrMLVFiqFXWsETGnTuvPL9I0EAW/rmb4HemcAE5TAz6hE
	1OAheDiKL73bKz2pmk1zk2HVyxhHChc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s1QvXXpe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788771922; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iXvYn9pGOWVNNZIM5zX5lrQlK0lUQ4h6ryyAL9cZz38=;
	b=s1QvXXpeSrKkKhu45ylvC0vTNwpp8qnQyESsoxK6gKtlDsmw73q6GhMl6YQy/jHQaCiK53rY5phDnUEU8FZ1icasRhCZT76mxn+EVSO7Llbsc0WCR/Et+cE7m+xNA2IEtlzjHXpQ4c4URRKngv5bVZrnq71A3LP+xzf6ktkm2cs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XATAmni_1788771920;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XATAmni_1788771920 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 17:05:21 +0800
Message-ID: <c070e67a-4c1e-478f-aa28-09fb88f8a786@linux.alibaba.com>
Date: Mon, 7 Sep 2026 17:05:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] mm/collapse: state what a collapse may do in the
 policy
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20AFB4000B
X-Stat-Signature: swzeuyp7ohyxj5prspcxyd1oh3aj9i1z
X-Rspam-User: 
X-HE-Tag: 1788771924-149557
X-HE-Meta: U2FsdGVkX1/67ErMzqKxdLkN+u31zIHk64JGzctR7yJPr04Q9Rvlb+YW7YTMUEjSQU+fnjYNRFtSCvfVqsY+eZ+F9nNSHN4gLD/tySYAeXHtWJHP/Bep+PvGqZrf/OhVsAytgrQtSvcacUE9wZrO08KDcEVdkH/k5L9rzjmcSAY3CPSiQg1wLw8EyTDqMewS1qiWCwMrnRTxNRlgSewQEsHBvmfEazc9ylIX6dl2sPqJrhULirJYezIkjN4Deg7fCvEnIi3x0npn3+/KWsm4UxDT32PareeCqyrA1fn383LT7hUxxlIh22fhfAOw2RgVIE/vAoqmvhIFz5lrrTHbQaB3cApVTqcMS2dq66NJXO+jnQ79xNEJlaw27NNdFo3bAAG26tbHlYDYXS+SxDGsluLbyH37pROcLvwmGcLwPtNVwqzfDGeeu4lKjaKLdUf6v9yA7VM2z+Bg+evv7Ka/t5xn4G5a8h96pl5Fke1BxpZ/TJebQLUc0mSOVReyTT85hW2OxerDsTVYeapdbr9H7N5I/IvQf/j/v5qcU0i+sBAReQ7SumPitsDe9IX+bfSTN5R1kxImZ3C7aT3IGWkKY1lYCsr1qz5lFVEHwC5/5QpFniPz9ja+DUbPx4CHAr5IZYTTkrVETZWOuouOhP2FTQpOOR0dcj0JQUNAnvFYfMc1lXHtnQkfRQ7vAwaEj+EKzUqKwbWnBb5LCo/pMFP3GRh8yQr+QaI3ufV0zSo1YTBe0UJc9I/vtrXHxWCJVuXhvVuuRVGE2NOq6/l02EL9aS4p6t01xcNpvGbnh1ksgNQoatZm90HKjovKOx5fSu/CB6WGnjWCUIci2cxKl49Wkd1anS6mr7JFiJgvBGFTJRpwwsIYfrsOy/8q5OytnrKzIBT501VaCiz1kFqJgxg0hP02a+gdSJnHHCLw/i28px5dMUKBa1Kb2N3BXQYXBQ5XYYAeWQ59T/1D39sfQDR
 g4HmNXWB
 Q+zSqTOGlbL07Z0fyVaNW54tfigMpHe/Itiwyamt06Le5EDwBxMg6INtwEpROC71aTbl+FNKFrgcrUpTsZyt1dsrBqFJ879e0j+pV2V4Ood3C3/TeVen6n8ZtFI4WIECDTULP5k44ZeonLmFTqEdiNA+HaCZGCrYbfvMffBCe4M0kgh6PfSVpO/9MIA6/6dnHwoGR+fM/ixV3NlEcaBsbjDPVaM8lQ0dstwjGRAWST6uDARgWxxluOvBa9HsHyNkYJ58yaR7+gNEAaM7fgCrOU6d7TFtAGLGCGuFAlya8We9dWxPlz+SWpSjWmGfmo1uDmHqHLYwbk0mYQ7NFoHkB1wa02g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
> 
>   - which VMAs are eligible, and how hard to try for a folio;
>   - how many empty, swapped-out or shared PTEs a window may contain, and
>     whether a sub-PMD window is held to a stricter rule than a PMD;
>   - whether a range has to look used, and whether a MADV_FREE'd page is
>     left alone;
>   - whether the PMD is mapped as part of the request, and whether dirty
>     pages are worth writing back and retrying.
> 
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
> 
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
> 
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and the
> defrag setting behind the allocation mask are sampled once per pass rather
> than on every table.  A table scanned early in a pass and one scanned late
> are then judged alike.
> 
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereferences
> cc unconditionally, so the check was already dead.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   mm/collapse.h   |  40 ++++++++++++++++-
>   mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
>   2 files changed, 102 insertions(+), 52 deletions(-)
> 
> diff --git a/mm/collapse.h b/mm/collapse.h
> index 1c40229b9554..05282eed9a35 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -48,8 +48,46 @@ enum scan_result {
>   	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>   };
>   
> +/* What a collapse is allowed to do, decided by the caller that asks for it */
> +struct collapse_policy {
> +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +
> +	/*
> +	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-out
> +	 * and no shared PTEs at all, and max_ptes_none as
> +	 * collapse_max_ptes_none() scales it.
> +	 */
> +	bool strict_sub_pmd;

This is a bit confusing to me. Actually, the check for mTHP collapse is 
stricter.

How about naming it 'allow_mthp_collapse'? That way we can keep the most 
original comments for the collapse_max_ptes_xxx() functions, which is 
clearer to me.

If others have a better name, please ignore my comment.

> +	/*
> +	 * Collapse only where it looks worth doing: require some sign the
> +	 * range is in use, and leave clean lazyfree folios for reclaim rather
> +	 * than collapsing them into a folio that is not lazyfree.
> +	 */
> +	bool skip_lazyfree;
> +	bool require_referenced;
> +
> +	/*
> +	 * Finish the job rather than leaving it half done for a fault to pick
> +	 * up: map the PMD over a file collapse before returning, and write
> +	 * dirty pages back and retry once instead of refusing them.  Both cost
> +	 * latency the caller has to be willing to pay.
> +	 */

Can you simplify theses comments? I think the 'install_pmd' is easy to 
expalain. :)

> +	bool install_pmd;
> +	bool writeback_dirty;
> +
> +	/* How hard to try for a destination folio */
> +	gfp_t gfp;
> +
> +	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
> +	enum tva_type tva_type;
> +};

