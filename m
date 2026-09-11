Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1354C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159356B00A9; Fri, 11 Sep 2026 11:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12ECE6B00AA; Fri, 11 Sep 2026 11:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035626B00AB; Fri, 11 Sep 2026 11:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D90086B00A9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:07:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F79BC02A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:07:09 +0000 (UTC)
X-FDA: 85201809378.03.608B8CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B0B314000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:07:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDV8SFI7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=993TfVUqxah6p+9ru7SHYLSMQ1D9Z3b73DF2QhhB5to=;
	b=XUq2VjBNZ07UQEXvgQzOXl4brU17n82Cfnj/s6P7Qu0aUbPy3VPkNbwdAIhetoQy1+PmxI
	goUEJ/cIfKoKwXkgkp5y+cBgufJ3VRXUtiVhkoocBk2KeFqKa7e2+cREMtuAm3zMIjCy5q
	BcpcqvgE+rwJtzOmMn8zXkBgLmmo8/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDV8SFI7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789139227;
	b=I+noZm/WHVQBW0JdF4+eZevt2Ks8+2xoyKvxIQVrY71equxpQLugESodQjGHfvuRGG2d/Q
	ydhBcKcADOC5ai2s/o2IxMxI3k+Zt/+Lzw2wcrhpnNatRIJvulK98kxLw5/rmKkwkuWIGB
	W/QbVD6FDtmb7fZF0x2jbYx2UiMmndM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6CD86022D;
	Fri, 11 Sep 2026 15:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C9C1F00893;
	Fri, 11 Sep 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789139226;
	bh=993TfVUqxah6p+9ru7SHYLSMQ1D9Z3b73DF2QhhB5to=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gDV8SFI7oNEqbwx1x4YqwzWsWDpq6fbK7G8af48m3PrQ+UhnjSF3yGpxcl7v45+iu
	 ExM1/F1IJd8qIBvc/k0n1LeRgzV2/Wb8stVD7qctVPf4JitLk/97CLOmuLtpM9j8qu
	 bK+30wRy8pHk9G/PCm9eedhXFrhHziF7LAxJapXLLxisW/w7dd31TMvcn4VwLadJ4y
	 iAzoBrIP0gM8E0iy8boxjPFiOR/AYPC2irWP5ZgGjmHQEXxmIA1mQc5s+RN9lLut9f
	 7MuFfuRPxulKQQox1Rln0vAZl171csJVOvAv/ouYk0Jxz0wbRYYzqmQB5ArIgLprW5
	 ATEz2eLsefDfw==
Message-ID: <8170ef17-0de3-45dc-8c8c-de15f088214d@kernel.org>
Date: Fri, 11 Sep 2026 17:06:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] mm/collapse: separate a collapse from its
 callers
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260910120238.2529819-1-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B0B314000C
X-Stat-Signature: 9g9hr5pon5p6ypnada9f1h9f7p8xfdry
X-Rspam-User: 
X-HE-Tag: 1789139227-28838
X-HE-Meta: U2FsdGVkX1/9PEfCwlhjvbr4+u+2na5KMm2pzCyc1XQKbiptkOG7mRLVFd8y+bSOMC6REz5n46hprCt4urIXcy2/cR/44e+H0a95kJuwt96jUHrZLDtVfjjTSOsgaKvBHz+XWKgGLfpyDHJx87NE9S4rhuxab9U1KEGAIOpReb5BtiCpQIS1NlvE76CSqsCjHO8RlSCsUyPV1rA+rUprkQvpXqYONJvOJNFofK0TlEsTRg4DzuZ5Ik73O77IIxFerxim4QI1WR2q/2a8K2ptLs9tCeE98eOdG+PGnc2TAC+waGB/P2gX1LcqCKUbDYzh5EUrhzISaGE7hLEBkcsTBEk4V0C/Kzqt/wJSTEAteghbFg+IXSL9xQmpgkcqZ+Y5tVBOE6yidjZqH0pn4A6ItB/qxeEOqvsg8fNY6qSPO4P0detRQUIOy5KOtzaH3Kzjf6wJyC75E6WaJ4K+rWKHn1Zo9RmSghdqLny+OHWJ+cbakg0SZEd5xCyP6kBb9Dd9/BZqbbUM+JVpIanzRI9fSMRp0+HvBPxF6/umf3r6h9KGKAqmPKsSP/xAp6M5Oi7JUQWkTeJt+OAbDo/GwJlvrmzgRhYfL/Go+mSuciPvajFrZFM30PNqwvKWvLUJIEAa+qg9qqPNWyupqi1v7lkgIN9ZE94lZ5KyqcLzzYV5iumMYbnZKVRJp/RFQIiycKQBsHIJZqKSpbTfwu0Z2qwkiB7UqYS2haivoEzjgB/4DmBNC0+7qfupSpXlGokuZsB4vckSpVJT8ypZR94OAcMCJiI0tYhgRtH6DDnng2MgHqcued91Z3kNs8Ziooano4wbkfraE/lc0X9d5cQPaWZvHzz453pAWIQZB7ESRyo2cjeF7lv7z88HyT5CieOX6Cw1zEmaUctEMUTC+bd8pWkpjD2BjqcNjVBDiYHhOGzS1St+DuiFp4bECNJ5Xi9k8sz0LN6HzOxz9/wn+fBZ5jb
 cVSt8mF+
 +o6ndpuyfjuce2ic56qcOCl73oxVRIRIisDOsHny1pZi/KeimSODYgyeuQM+XNCPgFBsEQKTHA8bxRhTD3fXsc1OZyIlSR9l6fkN8L6t1GskEmXNCJP4fDBYtENunuxMizegDcmoZwMiOMgMePWvKnCvut+fgQfJH4xNusOnBnc4T6eMuW8K/Ckb/lw1FjZzVw9Zt2TAEgKSTvtDA45iLnjqf78UgFawfeYN484KqYKdf5z48J2s7JTgQoiQ6Yy/AGFAq1+uwPhLf8MQYSs+K03X/DZ0c2KzP1sDu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 14:02, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> [ This is the first of the cleanups I said I would front-load ]
> 
> There is no line between the collapse engine and the callers that ask for
> a collapse.  khugepaged.c holds both, and they reach into each other.
> 
>  - Sixteen tests through the collapse path read cc->is_khugepaged to work
>    out what they are allowed to do, when every one of those decisions was
>    made by the caller before it asked.
> 
>  - collapse_single_pmd() does both halves of a collapse behind one call and
>    drops mmap_lock somewhere in the middle.  Which of its paths dropped it
>    is not something a caller can see, so it hands back a bool and the
>    caller keeps track.
> 
>  - MADV_COLLAPSE's implementation -- the walk over the user's range, the
>    per-PMD loop, the errno translation -- sits in khugepaged.c, which is
>    the daemon's file.
> 
> So: draw the line.  State what a caller allows in a policy, split the call
> in two with the lock as the boundary, and move the syscall to madvise.c.
> What the engine offers is then four calls, with the lock state written
> down against each, and a policy the caller fills for itself:
> 
>     collapse_control_init(cc)         once, before the first table
>     collapse_policy_*(&cc->policy)    what this caller allows
>     collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
>     collapse_run_pmd(mm, addr, cc)    when a scan found work, no mmap_lock
>     collapse_control_release(cc)      once, when done
> 
> The engine stays in khugepaged.c for now; what changes is that it has an
> interface, and that neither half has to ask about the other.  madvise.c
> gains the operation it should have had all along.
> 
> Changes since v1
> ================
> 
>   https://lore.kernel.org/all/cover.1788533997.git.kas@kernel.org/
> 
>  - Rebased onto mm-new with Vernon Yang's tracepoint fixes in it.  Patch 8
>    no longer merges the two calls to each scan tracepoint, since the base
>    already has one; its changelog now says what the status field reports.
> 
>  - Patch 3: nr_occupied_ptes is nr_eligible_ptes, and the mthp_collapse()
>    comment counts eligible PTEs too (Zi, Baolin).
> 
>  - Patch 4: no comments on the two constants (Baolin).
> 
>  - Patch 5: one line per policy field (Baolin).
> 
>  - Patch 8: the file side is split like the anonymous one (Zi).
>    collapse_scan_file() runs under mmap_lock in the scan and only judges;
>    collapse_file() runs in the run.  See Behaviour below.
> 
>  - Reviewed-by from Zi Yan and Baolin Wang on 1-4, 6 and 7.
> 

I'll hopefully get too look at this soon (after digging through older stuff in
my queue).

Skimming over some patches,  a note that we should not be undoing recent
cleanups without a very good reason.

E.g.,:

commit a155d945b73c5b0668e898df5495afe45bb261cd
Author: Nico Pache <nico.pache@linux.dev>
Date:   Wed Mar 25 05:40:22 2026 -0600

    mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()

    The khugepaged daemon and madvise_collapse have two different
    implementations that do almost the same thing.  Create collapse_single_pmd
    to increase code reuse and create an entry point to these two users.

    Refactor madvise_collapse and collapse_scan_mm_slot to use the new
    collapse_single_pmd function.  To help reduce confusion around the
    mmap_locked variable, we rename mmap_locked to lock_dropped in the
    collapse_scan_mm_slot() function, and remove the redundant mmap_locked in
    madvise_collapse(); this further unifies the code readiblity.  the
    SCAN_PTE_MAPPED_HUGEPAGE enum is no longer reachable in the
    madvise_collapse() function, so we drop it from the list of "continuing"
    enums.

    This introduces a minor behavioral change that is most likely an
    undiscovered bug.  The current implementation of khugepaged tests
    collapse_test_exit_or_disable() before calling collapse_pte_mapped_thp,
    but we weren't doing it in the madvise_collapse case.  By unifying these
    two callers madvise_collapse now also performs this check.  We also modify
    the return value to be SCAN_ANY_PROCESS which properly indicates that this
    process is no longer valid to operate on.

-- 
Cheers,

David

