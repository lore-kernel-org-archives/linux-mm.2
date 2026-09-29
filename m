Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4F6CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BACC6B008C; Tue, 29 Sep 2026 04:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093126B0099; Tue, 29 Sep 2026 04:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14716B009D; Tue, 29 Sep 2026 04:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF1CB6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:12:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BC4AA6A23
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:12:16 +0000 (UTC)
X-FDA: 85266082272.13.41AF8B3
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6EC3440007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:12:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OgT2mO3A;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZvOcQbNwGkg9vO+2V5t5LeOYPL7QIELv6/Cs3Ys1xY=;
	b=nfFDk1PxPM06HGJrT7diZZ9pDcIIrfmN8KxZeFrf4NYTmVx3cGUTyz9PG85M870rQWTIGk
	JVuMeTT25rLzMUfV2FyU12MrbebtTc5EjsDPNcXPtjEjfYq1MX/F8MALdErkaQCIdSiOlL
	rUuIE14C+hh4nd4eQVy5i+x6fNNKz/Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OgT2mO3A;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669533;
	b=TMC9Ua4bynj7vOBQQ8YjUIEAwjrC+0emtbH2U0BWmN78UBPDykMbVOMGY9k9CP7akc2t4U
	+L/aVdWcmZGZ8II/5Jt+eY5B8+mAGJuRQJlQFhrehCM5XUJx3GrTfaRvDsFOdIAgqStpWZ
	Eogu1R631cXKo0/kg7qPhC6pnyKN47k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790669526; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jZvOcQbNwGkg9vO+2V5t5LeOYPL7QIELv6/Cs3Ys1xY=;
	b=OgT2mO3Ai0D3UYvylXIM5aw6cWsa5cCRZeuASNHC7dB+6drHNzJ+p3kohMqt0lEGx0QdTGm8CDc35A/L2PEXO2qpASSZk2fNK/CcfmYLehzzn+1djMvPcZB6fV18nEaLcX06/VEk1dstvI2VLQ4X1JPr+TD+efn8qZ+7rkSt3jY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XBsUzwy_1790669524;
Received: from 30.74.144.142(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBsUzwy_1790669524 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 16:12:05 +0800
Message-ID: <200efe18-5570-43b7-bbb5-7fdd2ce7b4a9@linux.alibaba.com>
Date: Tue, 29 Sep 2026 16:12:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] mm/collapse: state what a collapse may do in the
 policy
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-6-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260928100630.21870-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EC3440007
X-Rspam-User: 
X-Stat-Signature: nm35h7nwcwgq5hkr15q95m35qz6otzqn
X-HE-Tag: 1790669530-911590
X-HE-Meta: U2FsdGVkX19sbcglqqZbh6/knuqZvRDjiJr4Zlj3+DagLnwXIZZz/6ZsEzD15eE8+wzAJ5NaSxuBGuUr89tYN1mj/7cYTR0rxlsAJVDtkkqLseiXTHdPS+9b/73gcas4ep7sUbHsvS/z4jwv593g96UtDLWp7HTAXLA0lFarWpPh60TvG+V91/lbmgWfot8UyJf800LtDOSkk85hG+bUo/WKlgD78dQG5Os6an4hrg6vMtBA3c4GfyPfJ7OBP6k0wKRtOi84zBom2YSNDHVotvT70hDmaLiZRCnu3oexGIFrXxetVr9S7wAL5+ufA7HepbsgBwcU35+E36iAlLaeMeuKVq8wL1WRIoMtTx3bHMBWzbu52wywefTxRbEcEhYfYWLONEkLRJKZDDy2E2tnSirgmpzvmVgBUs2WAenfxDIcvs4fd7t3EJUhAwE97UpHDS/qixqkgIkd9yR6JkSB4GVUgpIeS0Vmdfvoeti71Bmu5kxgKJCrKAe3M1SjVa8UEuT/V8wQtHhdgWI9NvqcdxOBGYBaqURAs2dd44CvrtSC49QlukFdH+gTZwW3Y4OKPd6mMTNf3/V2S0T9524whOe6zDuE2Ks1mA1O5KzYdZdb1xrIHMAAApUl4zjelMfJ+x49TW9j1bNIVPw/ucQBLsGZX6lOeeC9kUV/lo7o76IhMY8K+7wWiX0rDhOcL/INMK2/jxJ6KbkXDbt4pfmHknEIPxWzW7PTJWsAse79WhXwmJB1mSE7kN5DSmE4sHzv5Om77TrJ8+YV5AnwATIDIJZJ4M+aIr6vVUQzWUm/+Gw8RSFE0IGICdqhghOzktuE4oHVVxmXMADGeRecRwnEZLt44cG/k1uyxohQsBsJakEZo+xvOtaNhlzxSuc0HngxtSoo2mePonbnCAD2df8fD6MYOJYcQSEjmb3tp/LR0moDurS6AzORPi71K99Hh+RkbeaJO5rp/qu21dYDsqP
 5x5qrWf+
 cJBg6SSD9P++GwTJKaJn4dbpVCqiOvKioWO3vRUyC4ItosZI7lh15+HEtWBUT4H4KDVpReYZRw1/q2XsRkgexIRuBhOocWna+6fWWqQ2vzvvEQ5qdtADulMMh3A1Kf/QYlWL3+aMI3+9/sId8HmPuDBvHE9B5ne5PuCoR2h/o9ajUeZCW8zYLiPwS/JVUryBTJ2p6zuSD9TUbgOsoTT656Ap+gFzoK+ujohwBzP+96GP4INBjU9jWieI9nVbWHdYw+TWi6nlWZVs+vlWetOIBKmktr6+4rEmNPWXnZi607wINHtpLcomhuQAxFfEEsP6cIFCPKZVHiL641sE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/26 6:06 PM, Kiryl Shutsemau wrote:
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
> The PTE limits come as two sets, one for a PMD-sized window and one for
> anything smaller, so that the helpers pick a set for the order and read
> it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
> and empty PTEs only when the knob says all or nothing; the warning for a
> knob value in between moves to where khugepaged fills its policy.  The
> fields only one side reads say which: anon_ or file_.  David Hildenbrand
> asked for both.
> 
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and the
> defrag setting behind the allocation mask are sampled once per pass rather
> than on every table.  A table scanned early in a pass and one scanned late
> are then treated alike.
> 
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereferences
> cc unconditionally, so the check was already dead.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   mm/collapse.h   |  41 +++++++++++++-
>   mm/khugepaged.c | 147 +++++++++++++++++++++++++-----------------------
>   2 files changed, 118 insertions(+), 70 deletions(-)
> 
> diff --git a/mm/collapse.h b/mm/collapse.h
> index b115034d9018..dcd117071955 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -45,8 +45,47 @@ enum scan_result {
>   	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>   };
>   
> +/* How many PTEs of a window may be missing, swapped out or shared */
> +struct collapse_limits {
> +	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
> +/* What a collapse is allowed to do, decided by the caller that asks for it */
> +struct collapse_policy {
> +	/* Limits for a PMD-sized window */
> +	struct collapse_limits pmd;
> +
> +	/*
> +	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
> +	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
> +	 * window whatever its order; any other value counts as 0.
> +	 */
> +	struct collapse_limits sub_pmd;

Much better than before. Thanks.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

