Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995AFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8546B0092; Mon, 14 Sep 2026 10:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B17A6B0095; Mon, 14 Sep 2026 10:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5B66B00AC; Mon, 14 Sep 2026 10:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20B606B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:54:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BC5E1C00A8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:54:22 +0000 (UTC)
X-FDA: 85212663564.03.EC631D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8511014000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:54:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqtdz8iU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397660;
	b=MvffB49xAgp9u2i+fm/Foq1eEEgQ2TZEmlT61/SRBOL6vFQhZFNdeYGPG1icFerVOV8WqX
	1m4ePP+dRgDFCzoaXN6tV6C56HpdFm7MUp1UC6Y9QaJdRV6WGVNj3qo8Y1NGI79kvYoueJ
	NwrROvw93PmtHGC4xTz1QpvONO9a9Tg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqtdz8iU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqQv6KMy1U28ryoZhijvrEOBD1yTQeJF18hN0VAMPnU=;
	b=vkwFbtauCEKdL/GGA+PtAo1I4rmvRdoz7BcYGxHhXILtPZ82UUsygF+YnrHL6HAjKh33QD
	Cqx26NnAfd/iF8iiKdMoZxPaQZW+yTx2VH1XvDXjWGCZ17y61MIGqHo8xwdGOZkaEiej3M
	+eAvPKfkJPSyHiGTcjUbzqN8xVKff7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C956760142;
	Mon, 14 Sep 2026 14:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE731F000FF;
	Mon, 14 Sep 2026 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397658;
	bh=WqQv6KMy1U28ryoZhijvrEOBD1yTQeJF18hN0VAMPnU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aqtdz8iUgW6ucLIZQPX3jcGa3cZwKaxATGczLsWk5HkTtLjwNgVOr9h/zsxClIatn
	 RuxwPSckGUkH7sXnJMOHR2il5yg1Mmtj+fDesIaZxY3V26H/wt6Q0jq5RAdoYx8P8Q
	 AmfEwx2NI2SbMwLh1N75+IDkwaJaVqstWGbJR8ZRSCCnhsND7bLOQ/lvHIZUIebj0I
	 cV0vZvRdZL6iogCMScFXBhExrRuDX+1JF1WBfJfJ+t35R/lLrUtUgiHsdaQhb8XgpV
	 ZdgDwd/ixQSdc61RU2SwHW77KoPdWcLshOHIODE5EAbFiuqRYykIHD0p88nHYoBieL
	 NLooPdayPATNQ==
Message-ID: <25a39c58-a188-4dda-a832-5deff2c8b8c0@kernel.org>
Date: Mon, 14 Sep 2026 16:54:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org,
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev,
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com,
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org,
 pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer> <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer> <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
 <aoXn1B7cPnPq7uxd@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoXn1B7cPnPq7uxd@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8511014000F
X-Stat-Signature: 7zefznf7pkmqkdwn781g71p3gpqkbjps
X-HE-Tag: 1789397660-977389
X-HE-Meta: U2FsdGVkX1/Tkd5+B4jBJ7OQnNYBufL4tzfhThYfxasSLobLGmnKXO+wHFsI0eNymp746WKXV0gqv+68KFuaxDqN2/jUfhP1v8QRx9tMJq+HKgzagPs3FTJckuftyaeqEQFjnxQN1TUqqlkyrkWnmezn41bijJX/9ZO80Cv/NT70qbv3vv6j0Fsraa9HbmakFVV/EOcURGQ2fC3sSt29P1q053auIr3Q2qylpD+p+yu+Jg1XCX5UcZIEbUpW6Q8uOU2n7UrZiYbzhFy7aWvyChoDYXaudY3DpZfqWtnCNKIGiW3SGN0cKt8ep884d/vpuZzODbdKEYzUvgAvMPEXEN5aWwrPwo4FKkkfDtWlZkRAiyRtOJDoJBG6F3e7xrY8orfesxOs1SMzSHYpNVQKzPz2ifDvMhGaVQp+G629quvr3K7Cs0TpJuTdhGWTj5EUbkRUe4ttvxfCgNbeKD2dQR4QhSxqEVJ7HeIVjBO7jWruX++3Z5htqiylvRoz5+39Z4+ehS63ZGoOo8IMQ+IyIgToHLw5j8848Y4qjLQUjWKFfoxqM5WRdNHeIlvRcZrbcxJTQPmwqdxWkF/l7mPiUNw+PXoCvdBMjDlF5h82u5mz2oA23YkcuZneg4s5l3pE7Pe8rvD4Tppc3iwugcstLXu5Ki17d/KvcoxHpY9WwPG11Y4DZmdV2Wua+DVbcd4Q02uaFOw07RPJPa7l/QS2tV84XynGxXNrNvMzzU/CqiMTGOLhzMxcI53otdwNcckWM5+DEDa/PkdCWFmt5N61/JGh14HOmjvg+g88BCX0KkvjEd8TUbG6plzHORATP/MPIDjCaW4PiK/FmTxd9EW9iiP6l17M6RWZUbgX2sPuvBm+L6FKH3tw5KojoOE+gBR8gc/YXmj5CYnwb85Cy/BYztPE5np6HV0coGc6iGO+6Ll7RFxz8WJAc/JxCUGxgdejqr+dTrNBxRwAuYt6K8o
 gEzveXwk
 4oZ4MVRfXqDHgjW1wA+8jkJsHoFEZgcjYXpNs2V7SvmI2vY/vdQguAb8ZSkwSDLYMOUfTYxCdSg2/Y8N50WhUwSG/lU4XUkVXBjvdsHRyp5DvFi0lEDTj1sjUgWSgzpYnu2ugeh33knAnfOgrKcwtarm3c4bL5lqkl8OtD0TMsdtQOzMIpOkaw+LBDk22opNHbe5ho9gUus/XY3lXjbKesoxYFsehBbStCJtfusZt/FZRwrvhEuUXc+eTlE2E7dr9pko5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following up on some older threads (sorry, the last month was insane)

[...]

>> Ideally, we'd get b), in small, nice-to-review chunks that incrementally improve
>> the code without inflating it heavily or moving everything around.
> 
> It is not a cleanup and I would rather not sell it as one.  It replaces a
> mechanism, so judged as (b) it fails by construction.
> 
> I believe the end result is much cleaner. But I might be biased. :)
> 

It should start with cleanups, though, and not moving stuff around and rewriting
it in a rather uncontrolled manner.

I saw that you started sending out cleanups, good. :)

>> The current locking is nasty, so anything that moves us one step closer into
>> something that is not only simpler but also more scalable is nice. I am a bit
>> concerned with the churn in the series as is.
>>
>> After this series, mm/collapse.c itself is way larger than just mm/khugepaged.c
>> originally, which raises some eyebrows.
> 
> Line count is a poor proxy for simplicity or scalability.  What the
> engine changes is the serialization model, and that is the part collapse
> needs changed: the PMD granularity and the exclusion both come out of
> the locking.
> 
> Incremental does not reach it, though.  The old mechanism is correct
> because it holds mmap_write_lock, the anon_vma write lock and a reference
> from the LRU; the engine is correct because the sources are frozen behind
> migration entries.  There is no halfway state that is correct under both,
> so the switch lands as one patch.
> 
> What can be incremental is everything around it: the engine goes in beside
> the old mechanism, patch 25 points the anon path at it, and 28 removes what
> it replaces.  Until 28 both are in the tree with only one of them
> reachable, so the switch can be reverted on its own.

What I am saying is that there must be a way where we slowly move into that
direction.

We try to move in small, controlled increments where possible.

Huge rewrites are not helpful, neither for reviewers nor for maintainers nor for
consumers.

Sure, at some point there will be a switch, and bigger changes but what has been
presented in this RFC was way too much and way too radical for one series.

Nobody can really review 39 patches of RFC.

Often it's more helpful to propose an overall design idea, and then discuss if
and how to get there.

(and the design idea should not read like schlop otherwise nobody will have an
interest in engaging with it)

> 
>> We should also be aware that people are proposing file/shmem mTHP collapse, so
>> ideally what we refactor would naturally unify some of these code paths.
>>
>> I am wondering whether shmem mTHP collapse should come first. (I'm hoping that
>> shmem mTHP collapse can unify some of the anon+file collapse code in a nice way,
>> to similarly just look like a cleanup while enabling a new scenario.
> 
> mTHP collapse as it stands has limited usability: PMD-aligned windows only,
> and one VMA has to own the PMD.  Bolting file collapse onto the same
> structure adds to the debt instead of paying it down.
> 
> It would fit the new design.  The frame -- scan, candidate selection, the
> round and its passes -- has nothing anon-specific in it; what is
> anon-specific sits in the freeze (folio_test_anon(), PageAnonExclusive())
> and the unshare in the fault-in pass.  A file source would bring its own
> check, freeze, copy and install.
> 
> I am not sure it should, though.
> 
> Do we want to find file collapse candidates by walking the virtual
> address space at all?

In guest_memfd, we recently discussed that we actually would want a mechanism to
collapse even without walking the VA space .... but maybe guest_memfd is just
too special, not sure.

You still need a mmap to identify the candidate file IIRC.

> 
> collapse_file() already works on the mapping -- it builds the folio in
> the page cache and then repairs every mapping through
> retract_page_tables() -- so the VMA walk only picks which inode range to
> try, and it reaches only what a registered mm maps right now.  Large
> folios buy more than TLB reach: fewer page cache entries, cheaper
> writeback, natural locking batch, etc.  Those apply whether the file is
> mapped or not, and going at the inode directly would reach them.
> 
>> Agreed, I think we really should unify+cleanup the existing code first before
>> doing more drastic changes.
>>
>> Having a series that throws all of khugepaged.c into a mixer and pours something
>> new into collapse.c is ... concerning :)
> 
> The moving around is patches 29-35 and the tracing after them.  None of it
> is needed for the engine: 1-28 add it, switch the anon path over and delete
> the old mechanism, without moving anything else out of khugepaged.c.  If
> the churn is the problem, v2 can stop there and the moves can come later as
> their own series.
> 

The churn is always the problem.

Small, controlled increments please.

-- 
Cheers,

David

