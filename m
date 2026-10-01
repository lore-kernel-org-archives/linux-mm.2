Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62EACA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D936B0092; Thu,  1 Oct 2026 04:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A167B6B0093; Thu,  1 Oct 2026 04:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7236B0095; Thu,  1 Oct 2026 04:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B57B6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:35:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B51FAA033D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:35:05 +0000 (UTC)
X-FDA: 85273397370.02.3DDF850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B37580005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:35:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpwGDrY5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790843704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Beu3PTH0hGN+3Qc/F8w3XSUtWyseEXXZRw/+4Um0mjo=;
	b=6iAs3xylKa9hfjiOAjnarCgQL7Ii3aPOs1O4blLEzrYo/vOZ4IdufnaxWjXprh7mBW7Vyk
	5W3NLmY6QDT19sGUtx9pL1Z9kOf2uXtA8fnH7Ib6BxgniLTPZJKr1lVuJVjeem1h24kIn4
	757c7u9g0og8FopOqJxBM+FYLXskR6o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790843704;
	b=zNoSAO5pYLALlK8MugyZFnY3PQCYIaTM+mrk/rsRr6vLBTHN5JmqLhcvB9dZBLqtjN9ieV
	3BhHX6XP6/nlsbzuZv81IIkfSlsrtW+W1DRw3FYLzpogg0b9e9RUVYZJEIy5qT0lSTUHJ9
	jrelICi5ucJmwtdapYMax50mYOGibj8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpwGDrY5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E954601FE;
	Thu,  1 Oct 2026 08:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07121F000FF;
	Thu,  1 Oct 2026 08:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843702;
	bh=Beu3PTH0hGN+3Qc/F8w3XSUtWyseEXXZRw/+4Um0mjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YpwGDrY5ZFPShy38M7zct/x7SvYt5v87AXBKQjVt4OTx5QQT/w1dOKlAk8T0WW1Qb
	 +y6KZLI1PD6p622hdijB9L5s07rsZ1UAI6d/OJQ+225ZHG3bHxaPrizZ9HMkvM2IKa
	 tmwOlJ5lzOU3krwHs8bLTr4Qw7/YQgmevD6Lg5Sl1QP7wjY0L2dMyp5Nwl6C3z3PUA
	 436dXWUSBlCeC2NZRFNziVzDm2AogHd11r5/kZCsVU6XzNqeMLqo1zI/tf768cj4k4
	 OJ5KQBdY9cqUHsC5gfaRBEDArH+rqSrVTOf1ivoWmHnj61ZoW7ISTjAveduCY9Oxmh
	 GvMoH78UTDN7g==
Message-ID: <9bf6623e-ad1b-415c-9720-6063a1ac11ea@kernel.org>
Date: Thu, 1 Oct 2026 10:34:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/13] mm/collapse: separate scanning a PTE table from
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
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-10-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928100630.21870-10-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B37580005
X-Stat-Signature: wok4pbjhkmzr1d7xh33aowda1keb8jdn
X-HE-Tag: 1790843703-257347
X-HE-Meta: U2FsdGVkX19D3yX/yvZulsGMu/jJZ41eC994E7oV4RIzqR0+4j1SOMP7txywnbelInisu6RD1bI/ChKd7eynit6JLSh+sHyk0PfdL33SOvdDwN6vswZwi8KNH9SuHXV6Y8yq/qO6KZhqxsjELuozAY7V8iPFHXHRrviChSUOrUh5YaKVoYe+XUIGSHPLaJTb3oPEVGq1FZ4b1eGYIYPIclxTSAMxFfy0imRH6JK1pGHMsgD5TTA1pvymF3A/gtPmVqItKJnmptI/bt4uGrR9eAij4WTXPIV7INfVKFE78T0TcUQ4E1tFO/yfCcvbUVqSYRsICv66bi0S4BrHYZEY59TaT7Q/i8EQQCZrvPBwep8ml+hYGkJG7ss5K/YQOTnCqlWvNL07IPOeIJb+aqdXCWEnaj1d0Vd0lRulxmwq2JAAtVyQPC6PdQ4t9EqWvcnOqVOMG28ygjoITiPDoo1/2y623nKQ1xWO2Fh2hI0S8lBz8TotnBltAwRxz8PXoh6UFLSQQ30k5bAriTfFFrDyg45xqQ1cHGsG3ZzCXXQ1G7KSnOaAM4RVLIqJ8uyi2FB828nBUAiHlGa447kalwr/YRugH1HQCsswidyxC8J0hatEOYdEkdc40V7kf8NgesCFmducX/WlXutce15KEG6b7e2Z95LJ94lzuaUOgQplkd3/RHA1jYuSOKOH0WI66zpnHBRvZXnHh3BKE5pm2lbjNEWU+hU2h2AloS0gvpWy2y73QMhZHGbFjSLxH920pPXn9cUudC8u8V+6oYzap83M3/oGUiQJFbU+v1A2wIOTQNPVOUNOkWlBUcC3Nx+oRDjna6Df5zfSRGIhVZut77SIfT6aV6uBXp3yRd+FSXRUeQ2IbTQuNFHinTLuMO9x9ru0ir+sMib8dFOM7jgtlY+HW3oAtZ78ozyninyCZgKIeI/rVwSbhjo2iRh7gmI2p7+fSxKR+Ka75fF/Mpot7GQ
 XaD4rz2V
 uUcQS9VuJnHedC9LTKV98pEK/RiVGOC3kJhfDFN6Bz8m0DhTSMTC/WMG9vrMd8o+oJA2l9VDPGrwIGPvmynPEX1oLBAz7fY38Brc//bNqHQcjzN1/4FSR94cAtwaKYFQmoo345UvpTOGxcWjuNKg67Sg6RGgZZWsTzHMnMMqiBJPueJqWUI0oyOPkvyXiNQSyD2O+HLZRm5gt3mJpR8e0p1lJtuKIEgUdEhcdQS3Q/QCYS2b6dy2mte2E+RI5KHcd0rUVgKHdCTShH2947n+espzWQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 12:06, Kiryl Shutsemau wrote:
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
>   - collapse_scan_pmd() scans one table.  The anonymous scan that used to
>     carry that name keeps its body as collapse_scan_anon_pmd(), and
>     collapse_scan_pmd() is now the entry that picks the anonymous or the
>     file side.
> 
>   - collapse_run_pmd() does the collapse the scan asked for, and is
>     handed what the scan returned.  SCAN_SUCCEED means there is
>     something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
>     cache already holds the PMD folio and only the PTE table is left to
>     retract.  Both are work for the run; anything else is why there is
>     nothing to do.

I raised that I don't like the "run" in collapse_run_pmd(). That hasn't changed,
as we are adding more inconsistency.

We do have after your patch set

	collapse_scan_pmd calling
	-> collapse_scan_file
	-> collapse_scan_anon_pmd

Inconsistency: why not simply collapse_scan_anon? Alternatively
collapse_scan_file_pmd, although for this internal helper including the "pmd" is
not particularly helpful.

The we have

	collapse_run_pmd calling
	-> mthp_collapse
	-> collapse_file

Inconsistency: a lot, including the "run" thing.


So I suggest the following in the context of this patch here:

	collapse_scan_pmd
	-> collapse_scan_file
	-> collapse_scan_anon

	collapse_pmd
	-> collapse_anon
	-> collapse_file

(as I previously said, "scanned" could be thrown in there, to make the
expectation clearer, but I don't particularly care about that)

> 
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.  collapse_control_init()
> sets a control up before its first scan.

You should mention that collapse_single_pmd() is only temporary.

> 
> What the scan found and the run needs travels in collapse_control.  For
> an anonymous table that is the orders and the referenced and swapped-out
> counts, which mthp_collapse() and collapse_huge_page() now read from
> there instead of taking as arguments.  For a file it is the file itself
> and the offset in it: a file collapse works on the page cache and never
> sees a VMA, so the scan takes the reference while it still has one and
> the run gives it back.
> 
> The file scan moves under mmap_lock with the anonymous one, where before
> the lock was given up first.  The lock is now held over the page cache
> walk, an RCU walk over one table's worth of slots with no PTL, and taken
> fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
> dropped, so a refused file table used to cost khugepaged an unlock, a
> trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
> only a table that goes on to be collapsed does.

[...]

>  
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */

I'd just not add that doc if you intend to remove the whole thing in the same
comment.


-- 
Cheers,

David

