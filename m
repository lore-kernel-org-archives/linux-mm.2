Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CE5CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0D56B008C; Thu,  1 Oct 2026 04:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79AB6B0095; Thu,  1 Oct 2026 04:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D736B0098; Thu,  1 Oct 2026 04:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B63E06B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:08:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2545214032B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:08:19 +0000 (UTC)
X-FDA: 85273329918.23.8F49E65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 61D3B40002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:08:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTK7DYyu;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790842097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBoILZl5w3rVZdYCV2v/uH/WRs7MvT7FJjqh3dz2DgY=;
	b=0VSTeVbgmUh/DuC4ai2mBNGe6cfvevin35XkZ1GyrqyLBRI4l9q6h14crLwfmPaJuQDlqp
	VtnLqY8LUhWbJheOZ0PlqsaYs6JZ7Gg/YWMroxIUYuWyG1iqieZB34vwYAOpEVHqJv9Iq3
	zOPJyUoqEp5uLNp/iJOhBx5B3s70Qn0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTK7DYyu;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790842097;
	b=H8J5nFBf0XOwEGGHf+DJGhEbwYhOl3LPmOa6Ag4XjGOB/SOCF1clqSCQ9IgpVn+e4g+TuP
	5e/WtG0y1VE8pzEg4hFGuATPKPbb05YVnH4RD4rGJWBNVUyJBlYCcuer3vHJt/tZ7tz/RB
	P1Si4fKwaga32Z3J8LsMjIulpmyEJyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDD9960234;
	Thu,  1 Oct 2026 08:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BE81F00898;
	Thu,  1 Oct 2026 08:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790842096;
	bh=JBoILZl5w3rVZdYCV2v/uH/WRs7MvT7FJjqh3dz2DgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TTK7DYyuhN9N2otVMELrHbTGkXbrOThlT22Y7LYi0nOdcFMAlHlFk6f3pekWwcF7R
	 ou7xnpphnEv8hHBv1eP0diT7ejGGq3gUWoBnD2ZO4xgfTQGPc8t0TrD+7YaPtapy/G
	 2nHyNzjqBSNXC2hDTgXkSTqNGvaPXRqQqixRcuN3U87nprDU9UmLKxhp2ygzs3NZfi
	 2QCiaeFC27NwpdxZueJwfbbPW3LSzAhaDRsU3tPPtFheq94+zDgiHdy0OeQgZCJMV1
	 HrBl7Rn2ZDXexNFUETf6cQRsddZEtyg8mtAnwIsKLjAtS3q5zNzvg7kSOGUEVb/6Q0
	 YNnzsEAGai/zw==
Message-ID: <67034af3-9849-49ab-8904-6d661178222f@kernel.org>
Date: Thu, 1 Oct 2026 10:08:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/13] mm/collapse: call collapse_file() from
 collapse_single_pmd()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-9-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928100630.21870-9-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 61D3B40002
X-Rspam-User: 
X-Stat-Signature: b8e33ewiyofqp17n9chojcd1ui4beoou
X-HE-Tag: 1790842097-174358
X-HE-Meta: U2FsdGVkX1/mb8SRvVG5/yxK108DgtpSjqpqhuK5vBi0sDVKxcHF9w8g4FZ/b2ueuCrdgTwHzFZBC5/AywcBRwh1CHTZ0w7j+fQHAWG3x+fv57t6mP5PAb1jpdKT0CNBGB9wUItAoqkcCqnhbQyBl+yAOEK1ZCFnOmS3ppdRjLbvwxaEq569MWvONywODiokQVmbqQlXnwfgoVU7OUnj4k9eiCLPdWRcbs9B44wPpkQbkEBfoDglBS7nL/MrHlwhiAC4wLLqt3pD0MdpC1dppXxuZ6Md/fbHHXRPGzseXac+892lrvozZAaCr4849sdFBAHw+h/qAFEkN70SWglszMWouIyLczVkU5/cXT+8SKl09salqSr6qLF1obmqamlcjv5d6S8F9mytM3xls8aTNUf83I1ftfD2CqJZ8Gob2ICbiugg+L/k2AI0VH4bcHObLPLpmX3ylJMUW0FRswG3riv2Zf9mBGMaR7bfSB83LARwuyt8fQZdaxJwOurl43Pu6WNj84zt7v7/H3yt6MMM+lPgLr87IYgO+9VVXorUtem3KEus21bmSt4riyh8+8kPhADbqB3lYQaHIi3lzbw74QYvJrRAELgCJTqrTiosVLFx5gevs4OBZyKSI9Q/GeZ0vkF92XJPhKbUSrjM4bntwcTXR8DEGPPcwNQQdS0cKucwCD1QiSvgUWXxR0GaauBGVIcj3pH5FxnW15SypOE75zOg7jYpYo6pnO19cSSBHvmOLo4Ywr3lF0zHQ7YxgoVzrLT0CsD0tuuW66JBcSsHGi5v20xDs1YL7y8fpRvJBvBkVM5gsXQuQ9b2LLGCOskU1Z+oGtC2axJ5IQuxKvHtq+6dnhhlwW8AJ+J5kS+0euJV2tneFV1LgIlGxLCadA18IEZ5F6MnpgjeicQ/iXcyarf7+Odsbd7VEQSVC8SK98wDl+d9DhTQc4cxVw1Uy9P4VKYpW3AbbA+p1Dj1S30
 pU/sCXAI
 5ZStJR05djCLqPMrRoKh+hwBiirNo+2aw6FnTcaR6DBtIlBkbOOaLSqXg8TE41+to2VyJM4wgNG9nzpjwpHzkD4/J73kGl1a+hQou6DkhRQCv2G7YCr1fYak41zycujLUtp/UtNV12TGrmAf22P29fDBoJwdYqz3WFZLPsU3df9qK56iO5lGUd10fd/2Fk8p2zfUvYygloZsQyYu0a63GkKrNDf4Ph+qYZFCc85zbTyeoDoehAU8FN3buJOjj3N7SIs/8DK6uo6SzBy486bkQ1vWNeA7fDZEmnl7QVv9+QP+Ds8G8anHyRBrODaG9vmbDxGlogObuqJf/GkkZlGBDfOdkrTHI6oLpZBJiPLdl/VulW8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 12:06, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_scan_file() reads the page cache to decide whether a table is
> worth collapsing and, when it is, calls collapse_file() itself.  The
> caller cannot get between the decision and the collapse.
> 
> Move the collapse_file() call up into collapse_single_pmd(), so the scan
> stops at the decision.
> 
> Two things change with it.  The writeback retry re-runs collapse_file()> alone instead of rescanning first; collapse_file() repeats the scan's
> checks under the page cache lock anyway.  

That change wasn't actually required for "call collapse_file() from
collapse_single_pmd()", right? You merely decided to move the retry label in the
same patch.

> And mm_khugepaged_scan_file
> fires before the collapse, so for an accepted table its status reads
> SCAN_SUCCEED; what the collapse made of the table is for
> mm_khugepaged_collapse_file to report.

Ack.

> 
> Preparation for splitting a collapse into a scan under mmap_lock and a
> run without it.  The file scan has to stop where the anonymous one will.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 60ec7e80d554..89a4c3f5a91c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2737,13 +2737,9 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	else
>  		cc->progress += HPAGE_PMD_NR;
>  
> -	if (result == SCAN_SUCCEED) {
> -		if (present < HPAGE_PMD_NR - max_ptes_none) {
> -			result = SCAN_EXCEED_NONE_PTE;
> -			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -		} else {
> -			result = collapse_file(mm, addr, file, start, cc);
> -		}
> +	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
> +		result = SCAN_EXCEED_NONE_PTE;
> +		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>  	}
>  
>  	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
> @@ -2774,8 +2770,16 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
>  
>  	mmap_read_unlock(mm);
>  	*lock_dropped = true;
> -retry:
> +
> +	/*
> +	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
> +	 * the PMD folio, and only the PTE table is left to retract.
> +	 */
>  	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +	if (result != SCAN_SUCCEED)
> +		goto put;
> +retry:
> +	result = collapse_file(mm, addr, file, pgoff, cc);
>  
>  	/* Dirty pages are worth a writeback and one more try, if asked for */
>  	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> @@ -2787,6 +2791,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
>  		triggered_wb = true;
>  		goto retry;
>  	}
> +put:
>  	fput(file);
>  
>  	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

