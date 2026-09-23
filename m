Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB39EC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002046B0098; Wed, 23 Sep 2026 09:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4DC6B0099; Wed, 23 Sep 2026 09:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4716B009B; Wed, 23 Sep 2026 09:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6BB76B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:04:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E63EFA07C7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:04:15 +0000 (UTC)
X-FDA: 85245045270.30.7D870EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 254402000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:04:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4cyk92U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LDdXZe7aP54MEtVISWDMWsj8byXvFIS3gsAEgZkebg=;
	b=IFgncyjtOJDfNGP47Nym0wKxpgLvCE0FbDfs6AgbsR2EBXMn2FdfjVtn14vGWMdovKDRtD
	9qQSFcJnDbXAFCJR8udJKrDnB8tlaHQSux01H6qN79DmKNInULm6EMKrEQloWC6L3Ge8B9
	KBZtU3vTFR3jAgKYJb9HtjVDQ8JNZhE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4cyk92U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790168654;
	b=Fm6qBYNmxxQlQ/RDU+38oGVgOk4ldFn+eDYy6zMdSZZwHt+pByCh8jpLgH/I0V3RuL2W/s
	CUEufor/U0NzLm6DzDcp6mzSepkDvyvcMQJ2Kl9qVcdZC2XJcb6l8EZfVCtG3bjySnlkdu
	q14dRCMwx5s1R0WsijzXyUf4Dxm7V30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 608DE405E8;
	Wed, 23 Sep 2026 13:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41721F00893;
	Wed, 23 Sep 2026 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790168653;
	bh=0LDdXZe7aP54MEtVISWDMWsj8byXvFIS3gsAEgZkebg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4cyk92UpE9FeGyijLqzL/lEcDqL5aFokFTsQdVwQuimh5FbmdvC2wNvc4wk9cqlZ
	 K5wvIlIOB2+/5UQ5B6qf4Dcvevkg6VvountM9T/eZe9cPNB5sG+lZE5cUS14ERHCl0
	 pNKgwJ+mSWDydWBPcYL8/mBW3fC+YjjRY3KDByw8PzgoEn4YCDg3EtmHzXrVlSpcFO
	 t1q4YgwJdkSFRq6y8mbcf1aAqyby+g2dz/f2mVjZVfxncIibl0LxUmbnggDQ3EUjW2
	 A8/BJhxO8IRFBVtG+YDAKj2Fl2UMKSkTw0XiIsv+V+GMIW0BS+FQbEvAWXnaeqJL2P
	 AUFo9WXcOtjPw==
Message-ID: <ebf8972a-0c92-41c4-9f42-22ffb820d07a@kernel.org>
Date: Wed, 23 Sep 2026 15:04:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
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
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-9-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-9-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dsemfjozu1ch8k6ddthwhu9usp3nbsuf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 254402000E
X-HE-Tag: 1790168654-339983
X-HE-Meta: U2FsdGVkX18iyOdifkAmDSPi1zeQwbdAmba+TmZzEuXqPN6ozNLFJK4YAN7TSMr+MzSvp89bE5jqE+IgE/9ruJjd4piO7anD2g+K/AtAm0ukt7vjSSjly+//3L9kXfBeFOz4icI1DiGa6SgRvIFpjHweaC2KJxWK2qwkBidqSRCkDdPTpCyU1T1AZCe6q4NPpLSZsH8veUg6/pJ0ZB0d5KJaTQePuQESqPzIVPELDT/QSBNTZOAbyoRN6/A8rh8JeD6NyLummpVWOnKKliP9skT63h8QnjrGRuJuJHbBlb2z59TfWG2M3jzzMSMPv28cK8wRa23lUwnk1nGmKMcmmrFjeKO/+fgr5zCU0wa5Bq2ibxARYaGP9E/r7GoaqWeBaZU3UC2Cy+H38r0a+dJx1YFEUp6d9jlzB/zmSEubC4Qmhe82VYijaS5y4IUTQyhgi+jDoSrJSRXrOFBb93Rj/xnftgUFWjjYq6DShbNY9BhACNwDaaqd/RaTl6QjNsjr9RdN6qP+6VpPWJ1ZHWqPXXOcZiSDlbd3IOu+a2RuuFdMFA8NWHIxA+XAQytcM7R4HbJ1x4n5ZA5IUPdx9sLpXF/BdIYvQk/rE/ieRcD7G0LUg5TDkqnWpEWw5VVW4fIKmBEZyRzPNfeOOEp24UzBUlGyja0C5/6VbNaWy7t8I+nD1VGXIOg6Cq797ORY7F18vP8dXhJNGnIIU6N+qB5KMY6JSzX0dxKk1oa9KXqravE43kVJEywq0F3NC/+GN9oebnvD2Cv6Pw1x2nGXLtN/M2ACvBCtZHNLMaxbEY2dqpQbMyEprbYo2s0nD9HHwYBxj3T18dsGC4wwxV07S4UaPy5FO66qnaBBuBOIZPWhrLSz9RQh7P2Wk/L0PezXWsKq4Wsv1x85OAwr1TzYEjIrY0IzJ3zQm8Pc0GXugFmF1sHlCeRWuytdljFXOpFQvDfMtL8zDbh/WJqslm0UztL
 9I0qETq8
 tariP5ut0+ifgKRXaVcV5lrkt/2C32eDBMT33T3EHupTYwHfM9FL0xc4AdklaYpBxe+0BIL9Xr4mXfksNuBF0g0VHVYHiNEGZrF6My18MR9S6MhxZmXKf0ikfJmLaLFcSrRPFaHEwTmtWbqlD4Zi8fWZ+fzSEzeRc8SzdhIL1eEU7jeEtIGk61o3Sbcatr6XIe2ZQWZoYA+/vNzDkiqY7tunLxc1BVwlH3w35hUjbDaI8ohx3YAtS2VbrU83TNwA1uNO8J2+b4nbOszkKUpKd7/6zfwTrkrGqe0hTXdZZkf59usgn0N10wvI+Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
> whether the range is worth collapsing.  The other allocates, isolates,
> copies and flushes, and wants the lock given up first.
> 
> collapse_single_pmd() did both, so the boundary between them was somewhere
> in the middle of a function.
> 
> Give each half its own function:
> 
>   - collapse_scan_pmd() scans one table and only reads.  The anonymous
>     scan that used to carry that name keeps its body as
>     collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
>     that picks the anonymous or the file side.
> 
>   - collapse_run_pmd() does the collapse the scan asked for, and is
>     handed what the scan returned.  SCAN_SUCCEED means there is
>     something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
>     cache already holds the PMD folio and only the PTE table is left to
>     retract.  Both are work for the run; anything else is why there is
>     nothing to do.

Makes sense.

The naming is a bit suboptimal and inconsistent.

collapse_single_pmd
-> collapse_scan_pmd()
-> collapse_run_pmd()

Maybe it would be clearer:

collapse_pmd() ["single" is rather useless]
-> collapse_scan_pmd()
-> collapse_scanned_pmd()

> 
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.

Ack

> 
> What the scan found and the run needs travels in collapse_control.  For
> an anonymous table that is the orders and the referenced and swapped-out
> counts, which mthp_collapse() and collapse_huge_page() now read from
> there instead of taking as arguments.  For a file it is the file itself
> and the offset in it.
> 
> The file side moves with the anonymous one.  collapse_scan_file() used to
> run with mmap_lock already given up, and called collapse_file() itself
> when the page cache looked worth it.  It now runs under the lock like the
> anonymous scan and only reads; the run does the collapse.

So we add more locking to the file path to merge both paths cleanly? Or did I
misunderstand that paragraph?

What do you mean with "and only reads"?

>  A file
> collapse works on the page cache and never sees a VMA, so the scan takes
> the file reference while it still has one and the run gives it back.
> 
> That changes what a refused file table costs khugepaged.  Every file
> table it scanned used to end its pass over that mm, because the lock had
> been dropped to scan it; now only a table it goes on to collapse does.

The last sentence makes no sense. At least to me :)

> 
> Two things on the file side stop being rescanned.  When the page cache
> already holds the PMD folio, the scan says so and the run goes straight
> to retracting the PTE table.  A run that refuses dirty pages and may
> write them back retries collapse_file() alone.  The checks the scan makes
> ahead of it are ones collapse_file() repeats under the page cache lock.

Is there any way we could move these changes into separate patches? These
changes are bit squeezed into the last part of this description. And having to
much happening at once makes this rather hard to grasp.

> 
> Tracing changes with it.  mm_khugepaged_scan_pmd and
> mm_khugepaged_scan_file used to fire after the collapse, so for an
> accepted table their status field carried what the collapse made of it.
> They now fire before it and read SCAN_SUCCEED for an accepted table.  What
> the collapse then made of it is for mm_collapse_huge_page and
> mm_khugepaged_collapse_file to report.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  14 ++++
>  mm/khugepaged.c | 166 +++++++++++++++++++++++++++++++++---------------
>  2 files changed, 130 insertions(+), 50 deletions(-)

[...]

> -/*
> - * Try to collapse a single PMD starting at a PMD aligned addr, and return
> - * the results.
> - */
> -static enum scan_result collapse_single_pmd(unsigned long addr,
> -		struct vm_area_struct *vma, bool *lock_dropped,
> -		struct collapse_control *cc)
> +static void collapse_control_init(struct collapse_control *cc)
> +{
> +	cc->progress = 0;
> +	cc->scan_file = NULL;
> +}
> +
> +/* A scan that took a file reference should have been run */
> +static void collapse_put_scan_file(struct collapse_control *cc)
> +{
> +	if (WARN_ON_ONCE(cc->scan_file)) {
> +		fput(cc->scan_file);
> +		cc->scan_file = NULL;
> +	}

See below regarding _release: having _put functions that are not supposed to put
anything except with BUG is akward.

> +}
> +
> +static void collapse_control_release(struct collapse_control *cc)
> +{
> +	collapse_put_scan_file(cc);
> +}

Do we really have to introduce collapse_control_release() just to perform some
safety checks for BUGs? I'd rather keep the collapse interface minimal and not
introduce _release semantics when there is actually nothing to be released?

Or will you add more into _release in later patches in this series?


-- 
Cheers,

David

