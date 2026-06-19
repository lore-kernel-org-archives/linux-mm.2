Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62785CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538286B008C; Fri, 19 Jun 2026 10:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510306B0092; Fri, 19 Jun 2026 10:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428006B0093; Fri, 19 Jun 2026 10:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B596B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:33:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77E3C1A0485
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:33:39 +0000 (UTC)
X-FDA: 84896905758.20.BF7E097
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 718EAC0004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:33:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hw84xs+b;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781879617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exaTeWRC+1G/MNN0r0FHXxl0TThR7yNTr1AtypUUTOI=;
	b=tdtiR0+SRQhymEGXN1F7qObi4khYWaAehcXCPY63f80lgXv+r9HB7tUKBjc9n8zt/kI0gd
	PE5GGaSE8ON8wWpGaWJDjEp7UbyBvIj1qhdLz2i/G9FJyyJz3XkjO/Fo7+FsIt6daQeHfC
	OYeHUBFEzk9pescaAW1IwPCH1TLpzVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781879617;
	b=ANFmE7HsuJ26XyaYuAlk1dlQ35A4a5thqQ2Ki8UwpotX9WCFGOjX5vAtsNJIeu6+8ytgJ4
	F5dP9F7QpxCxfgtLSsgSnDjqKVhexDdr9JvDWa1Y5/HDvO2ovYn0iJ2ND7HtAjf/NxgQao
	P+DCs0CnSTcMB+7TniTAt5cP/TJiOUQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hw84xs+b;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73D3843E70;
	Fri, 19 Jun 2026 14:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7BB1F000E9;
	Fri, 19 Jun 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781879616;
	bh=exaTeWRC+1G/MNN0r0FHXxl0TThR7yNTr1AtypUUTOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hw84xs+bLI+esRnD70Kv9kYVJdr+LWH8V+qMvuFIO2gyNAv3/Hpe/t64wU7E2Eybk
	 XmwWFokRliq6LlAnN1KQ/l83Z3E+QZNPvNm1PF5MZ8g1wFUgHlN+jFUx4JwQHdv0/P
	 BW4xWviVJx874g5GvIxU2Y6/zsUr1ce2X4nwC56DsLDEnAiYB7YQNwReThK4cSqPM0
	 OUQQjh8schHd9UQPLjF5KPYfylp11shZoW8owYS3Z31Ja/Hae2URQA5xeRf7KhzNIr
	 oEX0sLsNYWG/g+7zUdVELjTwyK7XqXjuhqWOt5RQxoXT41/qf62rUCi+I75GARc0e8
	 uQf/pPSbMGajQ==
Message-ID: <946a09a5-0eea-4f76-946d-19c193242640@kernel.org>
Date: Fri, 19 Jun 2026 16:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
To: Suren Baghdasaryan <surenb@google.com>, Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
References: <20260616190300.1509639-1-riel@surriel.com>
 <20260616190300.1509639-4-riel@surriel.com>
 <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
 <af82cd43ef0c5bd4a5337942650fba3b8bccd94b.camel@surriel.com>
 <CAJuCfpHa_1G+krJJDOS6z8QakngaV9jpns9Psu0zUJ=wb6rJQA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpHa_1G+krJJDOS6z8QakngaV9jpns9Psu0zUJ=wb6rJQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 718EAC0004
X-Stat-Signature: hfxagugh9hub3dqw5axz63oz7t4bn4s9
X-HE-Tag: 1781879617-508874
X-HE-Meta: U2FsdGVkX1/7LfsswQYWFJZuovXVLTNazAYxNE39wTmVYeR9YT6BewkmrCuGlPPLWnLziKnKBIaThoYKv0+LnJqniXAFVfD1ewXfpa8Gmd/5t+rshgsAXgzTuq7DYW7/HkrFB0qmxiA6dckCwh3j0evhWwN6myUIsDymUREh2Kcoj+F+Rkk/yHp7wkIIqjePrubt4MApqJymguv76Ami7yne95PpNWJ5dCc1nmtN170dDSA91U5kUXKaylP1+bMlPxmc4ACK4BC007Ps/FW/QKoHcvh4xOT3ZGfu8QuRvsAVOJzbgOnLr6QfjHzNr2LhST8I9C71mviUTJGThpkjJqLJ3ONMgESkO1DkZrCPX4lY+pqC2aWCvI1A9xZa5RS5MYMmA95wunSOoXcLvW5cvZb+EBjYoCeCR7jHTYWrFf5CEQ5mqs90I1qk1otOdEQtG/bErN9bg0ayLICuoz3YWWzepjIA7uAKCTsIctXX1FV3tWBlKhRVsE4OnFbIUNw0Y72hLdgTIijIP3eaXTQGfb8tVSxDS2z4/ad5wVrCbuefvhyYFcjXKKdbazJQSRh6YkYfhp1wiYg7LJ7xZG+t/tvAhpfrLytt8yGZf19gK/YSt80wyZurGqrx4hQTL/VAqjnfo80/FmG7Nk5QL/7UOy+WJQ64ZfBsozjRQS5Y7L4jB1hvWB4vQZLYsQZNAUk5qQbgUCfzdWLsMpDxIcxi8NbppBlzwkCd23aRkoZaAiuvtWQDVtIC2XDUQjWAuI03V+ugtEQxu6oWBv/xCBUfCld5OQPXFT0YwO4FR5H+HHMwqYHsvG0nBSxeJtOBVla6OVmrCp5SKxbIHeAR4Ig+SbxZKzyRWEV31Rc4N79zccb1rnss0c9bUPnY44L472dw5hOTMwzjBd8TNom6lL0zCe7mRoXgu17OZMS4fdqZh1I4avwTXJt8zhTb57uo2DX2uTSB42P6PO8bJycjcGL
 PFnP0qyY
 8Kx7x0aCq8IwPzQhsSzimw6liI6TPiJjiZnWS6lwUXq4vqQzmi777/sNSAdjRv4E+M5vA8WORlJzfJlLgwCeBF2X4STROUUN44N5tO0gLI2QHLOkR4ehHMDrMAOcChyAAhsqpEcRE+pA0XOJeO6e1O36YX4NZ4qJIQD62XXtao7zzFnmlyvt1eXm3kCkL1ru8c6cy0LylvaLe4Dz+bdmYUrV58oPpDGMSvGz3lSdJ1WufI8GJMHSr/pqqTuGbN3xKtHdigwNOw7crWoebkJgZcg5FF2WK50YrM+f0vzUlG4fvUN0PzPejR34z0mxwh6WmTLqolFcUNxbwZ8C30EqF3ogytA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 16:03, Suren Baghdasaryan wrote:
> On Fri, Jun 19, 2026 at 6:47 AM Rik van Riel <riel@surriel.com> wrote:
>>
>> On Tue, 2026-06-16 at 23:19 -0700, Suren Baghdasaryan wrote:
>>>
>>> I don't think we should be using per-VMA locks if the read spans
>>> multiple VMAs. Doing that would risk a possibility of reading
>>> inconsistent data since we are locking one VMA at a time. While we
>>> load and read VMA, its neighboring VMA can be unmapped and another
>>> one
>>> can be mapped in its place.
>>
>> How is that different from userspace overwriting
>> data while we are reading it, and us reading half
>> new, and half old contents?
>>
>> We already have nothing synchronizing the contents
>> today.
>>
>> All our locking does is protect the metadata we
>> use to find the memory.
> 
> Current locking ensures that when reading across VMAs, the structure
> of the VMA tree stays consistent during that read. I think that
> *structural consistency* of the area we are reading is important to
> preserve.

I tend to agree: if more than one VMA is involved, it's best to fallback to the
mmap lock for now.

-- 
Cheers,

David

