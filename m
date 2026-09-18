Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB9AC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5306B0093; Fri, 18 Sep 2026 05:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6BF6B0095; Fri, 18 Sep 2026 05:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC396B0096; Fri, 18 Sep 2026 05:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAB16B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:06:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE3FD4063D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:06:21 +0000 (UTC)
X-FDA: 85226301762.14.5C1F69A
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id C786C40007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:06:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ioNvN02Z;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722380;
	b=z9f/XmfiQur2jzMp53qkfey0RwPNIb3OvVm4oMoaxZ2UEaxJplLR/GehasJ+6j2lcJoswI
	aaCo39Xy36ixSZKES26Ju8KdVBuVwJFdNhC4vZoeJx+WVBhSh+wPTrdbHlGZMTfv3sH0RH
	BpOoyGPD4S+JNb6Mf7C6bvk1mgILVDo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ioNvN02Z;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xiz4ClEGfoyBjTaUK3UJ93XNcGn3MukFPVK9wlb3W2Y=;
	b=Qa8K9AbAO2vx6d006KZzQoRwLRnBEGSf4P4ZPeVqC1VZtcSv/JcvUSoA280JJmCOH5z3Na
	qXbjlFTw71aXp7AGb3fEKmQGfbBWs74M0vd5HhnvBb8U0kp5iFpplM0LVwNFYk7p3sjiD4
	ZpfXMl1rSBqYPaov1LWaoTEZwUxJC0E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789722376; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xiz4ClEGfoyBjTaUK3UJ93XNcGn3MukFPVK9wlb3W2Y=;
	b=ioNvN02ZygKJDwda2sInrmF2a8fmScPeKvMsMIxG/7YP3v0l+rIGVOTxqbY89XiytCWUB+lXZBVjSaU2ZksR0aK4rnfHxWhwlMo+HQ0Om2wQko1OmLPdPniYjRd8IcnGJKTKwv2zmx972H/JcIc+CHFZ8Gz0GjJL42rLCK0y9Qo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XBAoH36_1789722373;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBAoH36_1789722373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 17:06:14 +0800
Message-ID: <0230e861-8364-4302-a607-c34809a4a809@linux.alibaba.com>
Date: Fri, 18 Sep 2026 17:06:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
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
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-9-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260916093145.4022188-9-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C786C40007
X-Stat-Signature: z8ui9yiq8d8y6cc7qmcmgsg3czx33acb
X-HE-Tag: 1789722378-638529
X-HE-Meta: U2FsdGVkX1+GFulJ8QaPq3PKGK71ZPjo9DL+5si8AGaco9d8cW0nusTyGkGXHhCulK83YpmwdVfJgJzHwQcwCM0pPe9zurvV9CUVXqtqwT6buKUxUn03j1APz/jO7Y97FAz7WaO12ELYQecWqHPBL0XxOxejYt4wLBXAJNWtismqFk4bEps5mFmhXGvUQdAxvVwBy3/pMT8j5rrR6pmBE9gyWBxdjtRO2AWAsycwFRIEhMJvU2IU+MH99tihQ3BZrnog+ycdsVQ0Jg6Dn2+cNMbamqAFfMKbiwYsJc6OvNgUGbQjx14zQlM/gZAuObxKHNpwfGV+oaniHRODskhgzNP3/8zNYHI+qtAYjaSqQ3Gmzr6n7c/jTnqcF9dfeiVJrs+WWsLvEy7i31BDDxW6grPrtA+KwjhJsYRCrpxUqSGZPYiK4kAADL5d47KXUvva+b5JUHPQq5QLLqzYFubpm5u/DYeFcT9eMO16wo7ludVpSPWIMrChFCOKF/as4fPdTUl03OJ8REhv4Q8DuXpk69YEjccEFievnYSiYrkV1cAInPD2tXci9QGlYYw5pA+fLzkSa10q4noOOXHp1j+yr/BtyJ+yyejaV4ZaGffkeamP4oIGZDELhKywEWsao9Q770aUbkDR5Ci1JtLMNVxjUizlzcnPJK+DdctaLIoUoQ1hEcSfeLSJdBqdJcPfpnJoqHnMFnC3izqonn5/2aC5vsfU+4HfJ1vfSf655Xc340TRHmMOjEer5L+tYXuYYoMayGnNu0c8T5tro3+VOwAvHiXXLX4mdcIaEWXU/NpEATeICm6y52iQbVqkuCglx9CPl83WX/MxJIRHzJDDktI0cK872nUMxj3+eCGT+o4uPWMjuMK6RD8m1r1jl4GvRU7/XMnfT9WaePZ93OvF+cVwzS2KSfzNT44y3uC3/EA9qAVtY5lO7Jh6trMFXsjpN9XHZh7xX11PgBDZga85Dyi
 uTpFJx81
 ccFb1n0X2evRd/9ZiwElZwrjVu9gvDzznFxvkphXls7oPxZ05D1s8WqMP60GgZV3Py/wnQds3j4WVMbA2sFmj5OW78bM0KZFpy33KRefUtfMDaHNxCw4QOKHPNanPky/EbhU1rV8FFJysfTXi4W1Vk74eRdUnhMm3NShZn23eQAXDVOob74Zk6evrcXYz7FbXoLLopJxoFq6RvdcOCY15IeGFxr5D85hK4DYphz9cI+lC6QxGLOlN/rsKnL7qnUZ5dEP4aSTHkXVKpgipy44chmbx+oejmKFYewWN6ZXxUE9D3DR3ZMzM5lATiDtcLhpFq55TnW56Ur7do63AfVlrTdQr8oAHmyQuoA99
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/26 5:31 PM, Kiryl Shutsemau wrote:
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
>    - collapse_scan_pmd() scans one table and only reads.  The anonymous
>      scan that used to carry that name keeps its body as
>      collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
>      that picks the anonymous or the file side.
> 
>    - collapse_run_pmd() does the collapse the scan asked for, and is
>      handed what the scan returned.  SCAN_SUCCEED means there is
>      something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
>      cache already holds the PMD folio and only the PTE table is left to
>      retract.  Both are work for the run; anything else is why there is
>      nothing to do.
> 
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.
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
> anonymous scan and only reads; the run does the collapse.  A file
> collapse works on the page cache and never sees a VMA, so the scan takes
> the file reference while it still has one and the run gives it back.
> 
> That changes what a refused file table costs khugepaged.  Every file
> table it scanned used to end its pass over that mm, because the lock had
> been dropped to scan it; now only a table it goes on to collapse does.
> 
> Two things on the file side stop being rescanned.  When the page cache
> already holds the PMD folio, the scan says so and the run goes straight
> to retracting the PTE table.  A run that refuses dirty pages and may
> write them back retries collapse_file() alone.  The checks the scan makes
> ahead of it are ones collapse_file() repeats under the page cache lock.
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

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

