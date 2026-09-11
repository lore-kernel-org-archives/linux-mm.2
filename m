Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B96C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881E36B0092; Fri, 11 Sep 2026 14:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859386B0093; Fri, 11 Sep 2026 14:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EB76B009D; Fri, 11 Sep 2026 14:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5078C6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:36:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 431D2C031A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:36:08 +0000 (UTC)
X-FDA: 85202336016.13.4B4617B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C6841C0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:36:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFU+6C09;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFU+6C09;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789151766;
	b=ihC7q8ZMOq61Wp/DZZheuVETdeNoPXIDvojWwQCSn+m+WtljxTwGWTlBMl8ngpfUrI0kGn
	DU6aSmd53vfuVU4/hNLEAisgIfNzhDsR3+7ULOn1F/LuNV6ppeZnfg7hkbgFRpDRVSEqLJ
	1Zba1N1tH79nJkLs6fGaaGxxzrVTLig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18g5sLAF7nSxm6nZmjffovZ5kQJJB+eSmE+3wi/6upw=;
	b=hABDUpUnI9vBRXW74dVo6ECAjoe7G8REpnjnmhnnuNecbbJJf73F3Yb0oeJxPD5UUfwZBk
	rVWVfp5EgNOrcPb56jVj4Pt1JR40kUjf0W2SfM7A4Q3XfBV4uAjKww42ccvYaOcAJoPRso
	qKFP16bHddQO54cTqdNqGUmWWFsZlYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF3F641A66;
	Fri, 11 Sep 2026 18:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4396F1F000FF;
	Fri, 11 Sep 2026 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789151764;
	bh=18g5sLAF7nSxm6nZmjffovZ5kQJJB+eSmE+3wi/6upw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WFU+6C09Ll9KN6W/MYsq5Lpe1+McoistwpeIdC9zJhAajXY77frVc9EveTcqKQNZn
	 AtsPQ5+VXGeHjZ4G3hhMZu8riMuhD4FbFpOkhkIbo3lrvCf4KwTKM5uZSw/uFbitGR
	 PifRZJqShvJ5lFmS1qJECuah8hqp7nppxV906dpPcNvkKaOGwZPCf8WJ8onjI5Ri73
	 17fBuRFPwV/N2FHh6//xhVIwCJ4ZEzLxnLIyNr8P8OhiWlD3cgB7e5K/57vEDCQS1l
	 bVzCVFzx2d996DZIumDz6pLwQ/eDSBg8kfzMCM7Taq6/5c8pc9IcrN/YtKlf0R1wZG
	 Fan38NZjIeqxg==
Message-ID: <33d05dbb-9f99-4887-a4c1-415a27baf306@kernel.org>
Date: Fri, 11 Sep 2026 20:35:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] mm/collapse: separate a collapse from its
 callers
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <8170ef17-0de3-45dc-8c8c-de15f088214d@kernel.org>
 <aqQf9hSy0iNjnL6t@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqQf9hSy0iNjnL6t@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6841C0004
X-Stat-Signature: yjnmfi7mdqcmk15has5zmgw81x5rza9k
X-Rspamd-Server: rspam01
X-HE-Tag: 1789151766-464700
X-HE-Meta: U2FsdGVkX194A/8nmEde6H2sPau0LkV95RtjPdHpprcewRg6MtRnRm1vb1rJSSkwJhcsBKOD8Er1JD6gYXXjVJHTEJR1zLmD9oB8wrr6dEtiHMS5pa0w7gu2eXKumAPJ6EarvnoV29JLP95ESLUGxoQbbH/Wy80GMgZOk1asQAMrxBHyoe15rwzx/IZeOWndpBt2XtF3j7HmdbZhxOq0dqZcUPOKi0JxwkqI0dP7ecfSVW66h2y2Ai8w65vxGyvY76B2hSL4k7dmb4lM/R2hxv3/sqTsk4tQr4Hv3n5y99P7LVavlYn/s5yOY2NEzgGTpzpxg2kHJsFrP7n3aOpTKCN9IiWw34Db4vOU+4f2R6oz9G8CgmsSWoTq6oQ5LGRTdGSOhgk8XjXcXDKbwFU9X/tjfbQbleHWdDLqMIZV1rU434ZcoQFeipZMF+1jeYMr+rPxl+8CrY72UI6Aw5OG1eWC2CY5mpQCsNYXcyQ4hWjuDoG8iYsyIwLgRqA6ut/MfODjap7/MvasBZSRMM9nMm+xRsHCsbVK7sIR+u2f+AmcEXh2FFxQARzhXW7FnsfwOhpQRq9YkU2j2Yo0pWSfGx1ELIdrXWOjBzD42XKEy7ytgf4dLBRjysh8v12eU8NegJVEWPgB0Xz7D4g2wGfX2p0d4shR1vfovN+atY6aKO9qp+bXVO/ri6DWLOoJXSdbPOHyOKJB6vqZquWKUEnTQybfACZqly0g46kmDYeTmFUQZe/DirNLyBgl17LRBF17B5Gwp099+hp6iXVFH3VUt/LIDlPhN8An7Er5WgJySa+ocWjpa3UsmfP6lf7WZiAL4zd7fOrWb1L0slQiHvYXj/nd+mz/mSm+mj63KiRokWnfgalDWVyMa07vH/k251aC7L8WJ4TFEy/fSpB/0Zw/zC1K7hlz9+CtCdAPdTLrTdhBeh/+/SAv3RN2HA4v4URW2LB/aCGOmW6r75uN0Dj
 OOj6kOlU
 0L7brbWAg06dbLTDkaeEEzFT/DY2EL8K2L/fXap/N2aaRMRcvU2w3i4vERyCbqVpw9tHJli/5Ne1ORe+FMpJezbmqr9wjwcSRQZa8bqoMh81G+sj5d8iCqA7J5CIrKvDcm3c9vZteMY3RhhKESoXNsmSCsdpSq/G244R30J7fkp1a6aHXte3fJM58Z3k2HsZGPIQ+wM4ULo5mzeAQq0cG6pBZFjrkdH6MVYCzrbTtBaxqdKJVaEK6f7Fxj2s5IOgn94M/XcwjyClXaqZbQfhZhrKi94bvAufzBAmv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 17:56, Kiryl Shutsemau wrote:
> On Fri, Sep 11, 2026 at 05:06:58PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/10/26 14:02, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> [ This is the first of the cleanups I said I would front-load ]
>>>
>>> There is no line between the collapse engine and the callers that ask for
>>> a collapse.  khugepaged.c holds both, and they reach into each other.
>>>
>>>  - Sixteen tests through the collapse path read cc->is_khugepaged to work
>>>    out what they are allowed to do, when every one of those decisions was
>>>    made by the caller before it asked.
>>>
>>>  - collapse_single_pmd() does both halves of a collapse behind one call and
>>>    drops mmap_lock somewhere in the middle.  Which of its paths dropped it
>>>    is not something a caller can see, so it hands back a bool and the
>>>    caller keeps track.
>>>
>>>  - MADV_COLLAPSE's implementation -- the walk over the user's range, the
>>>    per-PMD loop, the errno translation -- sits in khugepaged.c, which is
>>>    the daemon's file.
>>>
>>> So: draw the line.  State what a caller allows in a policy, split the call
>>> in two with the lock as the boundary, and move the syscall to madvise.c.
>>> What the engine offers is then four calls, with the lock state written
>>> down against each, and a policy the caller fills for itself:
>>>
>>>     collapse_control_init(cc)         once, before the first table
>>>     collapse_policy_*(&cc->policy)    what this caller allows
>>>     collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
>>>     collapse_run_pmd(mm, addr, cc)    when a scan found work, no mmap_lock
>>>     collapse_control_release(cc)      once, when done
>>>
>>> The engine stays in khugepaged.c for now; what changes is that it has an
>>> interface, and that neither half has to ask about the other.  madvise.c
>>> gains the operation it should have had all along.
>>>
>>> Changes since v1
>>> ================
>>>
>>>   https://lore.kernel.org/all/cover.1788533997.git.kas@kernel.org/
>>>
>>>  - Rebased onto mm-new with Vernon Yang's tracepoint fixes in it.  Patch 8
>>>    no longer merges the two calls to each scan tracepoint, since the base
>>>    already has one; its changelog now says what the status field reports.
>>>
>>>  - Patch 3: nr_occupied_ptes is nr_eligible_ptes, and the mthp_collapse()
>>>    comment counts eligible PTEs too (Zi, Baolin).
>>>
>>>  - Patch 4: no comments on the two constants (Baolin).
>>>
>>>  - Patch 5: one line per policy field (Baolin).
>>>
>>>  - Patch 8: the file side is split like the anonymous one (Zi).
>>>    collapse_scan_file() runs under mmap_lock in the scan and only judges;
>>>    collapse_file() runs in the run.  See Behaviour below.
>>>
>>>  - Reviewed-by from Zi Yan and Baolin Wang on 1-4, 6 and 7.
>>>
>>
>> I'll hopefully get too look at this soon (after digging through older stuff in
>> my queue).
>>
>> Skimming over some patches,  a note that we should not be undoing recent
>> cleanups without a very good reason.
> 
> I don't think we undo it.

Good, I only skimmed it and read "[PATCH v2 09/12] mm/collapse: open-code
collapse_single_pmd() in its two callers".



> 
> Both madvise and khugepaged use the same interface to the collapse
> engine. Anon and file paths are handled internally in the engine. What
> changed is that we have two calls into the engine instead of one.
> 
> Collapse consists of two phases: finding what to collapse and collapsing
> the found range. These two phases have vastly different locking
> expectations.
> 
> The scan reads a PTE table under mmap_lock, fails often and doesn't drop
> the lock to move to next range.
> 
> The collapse allocates, may sleep in writeback and takes mmap_lock for
> write itself. So the lock inherited from scan is no good.
> 
> collapse_single_pmd() hid that boundary inside one call. It had to drop
> the lock somewhere in the middle, on some paths and not others, and the
> only way for the caller to find out was the lock_dropped bool.
> 
> With scan and run as separate calls each has one lock rule: scan is
> called locked and returns locked, run is called unlocked. There is
> nothing left to report, so the ugly lock_dropped goes away.
> 
> It is the same move as Nico's da98790891a4 ("require collapse_huge_page
> to enter/exit with the lock dropped"), one level up.
> 

Makes sense. I'll get to this next week!

-- 
Cheers,

David

