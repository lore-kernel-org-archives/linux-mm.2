Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B43D606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgfZAIyb
Received: by kanga.kvack.org (Postfix)
	id 38E086B05B6; Fri, 13 Nov 2026 14:23:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365A26B05B7; Fri, 13 Nov 2026 14:23:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C3E6B05C9; Fri, 13 Nov 2026 14:23:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 007426B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:23:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C5A414024E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:23:46 +0000 (UTC)
X-FDA: 85431070452.05.2613984
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9D4B140011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:23:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgfZAIyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZxr9Ep6aHh8ddParUSsye3s6V8xF5fudX0wgl2EMag=;
	b=gz7gIoHxhCfKSYaHB3fpGqzSVeB2SLuXzJrWYRPjflYNEfe2pG04q1XsscOb/EmLqDdv9H
	tbUJb6hFu+n9aLZAxjan0z3N2z1tJlQgDrXuGGR4A0QUVSMXuTC28pMM7inrbiJwu+9yVM
	ohpl490CeRDyKugO9v+HytFA1YvHrgU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgfZAIyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597824;
	b=hXlhtC/L1co1dC+4zkJ1uufAG34dHdCayXAwyivZIj2qLuNdy22lqQfOOcl4MsrpPWJ7w4
	xzLXYqcq9j4EnXdzths+1FjJiNX2N+bmqH1t4Cd/fk3OVkm1DmwyY7eDTvpuPFIHAR/OgR
	4qgOyObT/8yfzjqhdbTscDvtmtubGkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A1BB60D60;
	Fri, 13 Nov 2026 19:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE9B1F000C4;
	Fri, 13 Nov 2026 19:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597824;
	bh=UZxr9Ep6aHh8ddParUSsye3s6V8xF5fudX0wgl2EMag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bgfZAIybHQ4boLlLTaD68XYZ3p8BUC77geB9/nH0ZR9wJQCpbR6xYtXxh2G7XQD46
	 XwW/5bf9LWGbh9Z35wDLUSHAv//hWBV+AarzJqrBaib6+C0xd3qQ3Nw9Lz6ksYrgFQ
	 VWw7A4VAUJI7WirFfBUH9vzcsFrfMLDw9a5WzisPKmo/oOgFaSBupXTfV1Bo/4wrBM
	 8g3WtvN62Buws/bDP1BrYw/F4+XM0cI9opHhrDc82j9ovdMJpLztQxurqynEkzFNiv
	 grK6KhMoX3XuT73AjkWbW0I7GVyY4dheodjwNHB7XDR9weZWVDxukTz0HcBShxk1aF
	 2rNydqh0lkZQA==
Message-ID: <a127857b-d1f6-409d-8c14-3622ea553ae7@kernel.org>
Date: Fri, 13 Nov 2026 20:23:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>,
 SJ Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>, azpijr@gmail.com
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
 <CAJnrk1aMwrEHdv9v=1cC54QpxzRGpRMbiu07KGfyEhzQNP4XFg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1aMwrEHdv9v=1cC54QpxzRGpRMbiu07KGfyEhzQNP4XFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9D4B140011
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ks7ghbpcqwe46fxmg8bsmbjr1y3ke6ty
X-HE-Tag: 1794597824-542342
X-HE-Meta: U2FsdGVkX19Co5QZWLFaSciGBNN9QFc2IkfwHUZhMy46I/I2Jl3zFtunvQI8l4Zdy9m2dR+FOFJeyefgN7TP3F9U24R97vB04ST1Cx/40PLHASBM4Xu7QuGdVFVAhC+kaetQ+a/fudGszIgWEtGxhb41PhfJmtA4kDwtfQWGrYuElydvkhvGjmWH+/UtMVXNpAzs6xBeU3+RdfhA/MOw/Y8U401WwbelN/X2jlAm1fQut50xWRlli+9vbxG2arE3rUPqycAiyjNwXQBeMxP709SBxlwXR0lmwCM/W86LP6MMsiZkCVqQ0Gr1iXc0WhyQig5OMDiM+B6hq+TgEbSWACXwy4UDlnLu0AvKeIrlcPVDTykyLMPK7+jc6PluQ/zpuEOOSr8ms4D1nQ9MzLm5WYSSiTWBmOIAJJfs2rN88fGOGw2mkvCEKp+ZWUIUt1HGtIbqQTztZmOioOjEJewh6aaBY8LhQhcSt4O+6ckRg1NGCRas2343W1rrfRTEwq8XgYY0tY7iVePayDD3IWJcSouZXJ8gd6doWCF/L5hX4Cgqw+buWNy9mC7ueW3geZ+AXgQI2xRmO4DltdiHH3ldgTuhvNjhK716d5sHnVUXF7q1wataFp6ySvMBqmBt6fgCxZ7yTQK+ALd3IrbY/cpzy6MP5ShjHiUQEn4xZWc4IIURNFoQgI1BdgbQc2FSa4Sm+Az+PDDzx+Isu0ILqkl4LeGG5ieGShs+rYMoJekFoB4qbv5fOHjJTrMLoml1RL7VwGG3X3ym8/jTBhQKQWbFouoMEnmlrwqsfaXMNACy6j6YUurxOG9SmjvKDV9aaGWGfKWkOFNSn+ATXp4bESLIqGsRkOyWa4/KgJyeKDgvscQPh5jptwDk4w6wt8af8Wstu9ZFRFNzBAjx0yO9QqsMotd2Aw9qeihBgpmwwk4I+t7hbQOIvouPH1hdpVvBidxLYJNU4uh9SdBElugNaXE
 6zhoYICt
 luRXpCrBMzW6AwMbMA63EyRibFD+/rnqATARCSCYoPmd801BsfA10dnsFN4osaQtdJolqG3lGnG5Z5EAFc8vsnC1TN8uCAFo3BiBzjC37IyWNadOEWsTWg5wSUXMba9k9SMmA30X97Q9njCn2i0oRyFZQWv6D559CSqacIM5Zkwl+LuoyS4bcc+ZV9W9SCunRM4U6Oqczs4OrgIDZMkkYxd73LjhEW6wezyzb+23cM943V+GAc07wLMkvK4Jl2aVseDhylpOKh6r3RG22q/cjjm5+hDy7lS2eAt1o0WG3OZWOFtaPzFfGfdVYyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 00:28, Joanne Koong wrote:
> On Tue, Nov 10, 2026 at 3:49 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> Batching resolves the problem in the common case. For the remaining parts, we
>> should likely just check in the deferred split handler whether actually
>> partially mapped to then clear the flag if not.
> 
> As I understand it, there's no simple way to check if a folio is
> partially mapped or not under CONFIG_NO_PAGE_MAPCOUNT without doing a
> rmap walk. 

Yes. With CONFIG_PAGE_MAPCOUNT you can (still) read the information from the
folio, but the grand plan is to phase that out and remove it.

I just keep getting distracted :)

> Would it make sense to do something simpler here instead
> where we just check the folio's partially mapped flag and cache that
> before we replace the PTEs with migration entries, and then for those
> edge cases that the batching solution doesn't cover, just restore that
> flag back to its original state?

As a last resort if we cannot get something else working (and we really care).
It is rather hacky.

> 
> I think this would add coverage for the migration and reclaim paths,
> instead of just the deferred split shrinker, but would miss the race
> where someone tries to do a partial unmap while the folio has the
> migration PTEs, but I think this is already a race that exists in the
> batching case. imo it seems acceptable though given that the race is
> pretty rare and doesn't have any adverse effects except delaying
> freeing the unmapped pages until the whole folio gets unmapped.
> 
> Do you think something like this makes sense, or would you prefer
> having the check in the deferred split handler?

The question is, do we really care once we have the PTE batching in place?

We would still split for if we cannot batch (multiple VMAs, PTE differences that
we have to respect). Do we have any idea how much that matters in practice?

(I raised once that, just because a folio is fully mapped doesn't really telly
you anything. It could be mapped into various processes partially, or scattered
in a single process.)

-- 
Cheers,

David

