Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E76C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD346B00E2; Tue,  4 Aug 2026 10:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5086B00E4; Tue,  4 Aug 2026 10:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB526B00E8; Tue,  4 Aug 2026 10:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4816B00E2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:11:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBD02A1078
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:11:11 +0000 (UTC)
X-FDA: 85063773942.11.567A513
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 00B531C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:11:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYqiid8N;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AufxVfVqAXJ04dLvj2G+UKWqnrgLOywdNZpBIg0K+AA=;
	b=pLXFP7Q7JguDejABGKWgtajvP0gbNgMeZqS3ELD1FuSmtmyR0ClVlWLkQPph9es4Vruuys
	M3qzfCtcWeeKrgysgfQgnfuSVklD9+Zwff0URNqOSm+0rBl6vmbldXkZwu5ee92H33dNIP
	algx8NKnR3nk93Sm+LA2Si7xsUod75s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYqiid8N;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852670;
	b=vKzwOJcDgc6/f6f3/emK7/YzD0MscFQgTK3ok5vG8GuSLmHgr8FS0IjPmR04KgDLKy/WLF
	m+emF8pOCsCSOY+ZJl2IXB+r6JNNuIFpDfKCmetlKMEShHe9KFlu7p/hafGIrQ4tY+C6Oh
	JAW2E4/wuVZLyn0uOzlGT6CeZ0h7hdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BB4D60A83;
	Tue,  4 Aug 2026 14:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C9B1F000E9;
	Tue,  4 Aug 2026 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785852669;
	bh=AufxVfVqAXJ04dLvj2G+UKWqnrgLOywdNZpBIg0K+AA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YYqiid8NmHYJgTJOTcM/2lckkag+h29MgmTSxhEyDoqLjxn4b7Mw4M02LJS+QLHfP
	 712NEqVkBYpA1fcQ36d+VAYTuvfkJY3Cl3PP5y+3zppwx48xfBqSVGbAHhIVOmnkIR
	 IbFkzcZmN5WFb2swCGl2/lm1Kcjk2S6fXRCk8nzdmsc7Y76n4Flx667YFinV5LwlTh
	 xDWR/zxga8xRlBixGmMBc05wzFo/ePD/rzt5r8v8jaZp42j7huD7BO+C2cMVpLLUC2
	 qB0zL15MXilJaPTAq1VbxnIlCNcBB0vxNdZAEegzIrZR3dw2A2kiN3sfQUPeo5Cx+x
	 VZlqDFz+CX0GQ==
Message-ID: <65b4baa3-77bd-4d2c-a128-9884f858e63d@kernel.org>
Date: Tue, 4 Aug 2026 16:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
 <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org>
 <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
 <anHxPU17Ui4MTcCb@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anHxPU17Ui4MTcCb@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00B531C000C
X-Stat-Signature: 3g3s8fpnj5i4krmebsipuzu8q6fbkcog
X-HE-Tag: 1785852669-614903
X-HE-Meta: U2FsdGVkX1+mXtqwAwDszJaiR3e+YGFwuWySP0VhUqDoPS/rZZrg5D75H+GSxCOSUIf+sdmTUAftz+AcrcwnW8PqvXuy4jinaqqrkw7/YyScvgIL/m67f9eZ7O3HuHv6jzjPjgmuyGzz1bhgEXEGBysuUYW0O+h5LujduNCkMxGARnfhZJ2+VxnG2Ol0/bI8mw+YmZytFNuXKSUkMvCBOwBqEEnJLADR7EZ1T5uIZsC+FxoRcRY4cLa/4VU1odBWIDGzsuGrpLHOXWckcgA7HpS1xC4h/rdPww3WR+qlUWvJhqyy/h7iI3NRabBWMB5Mjf0awdtRGY9p2GRyiOCbeWQtPXNn2Q4tNdGs9PXxesWz6i2+w0CAUwoAeWd0GrNnmZYpOJa9oL9Qrez6I84KPuPyyt+Blqp06sPW8hkQJNaKFjJwLakIgu4g430c0n8wuTLIzdUjh6m10Zz9RjdvzWY7zkmgApacFibkW7RNyvtJJKuYJJBwOV71gqJ213fbjDKyxpnQLECKoglt405P/EX2u7Wn2joM9pqWtwh7EPk9IMYzFSJyCHXkMgpqmB6q5VwfPx9SBGW7Nr5173gysg2XU4K3KYwdMLaRlmSbYU9ilw5sr/4teNVBMLe9puOafp8++YS8nfVF9KpZDJNDz9+b2agD6TDgSxBE8ssXtD5Gm9Cdtj2iY+wfi3+TVbad96n0IBBULcGb8D5wRNie/Y7QCT1Zg0LBvJ1VV/pmzjqucs+thaKBzqP9xkJoz64HqZ9zF42mp+Dhfm9h70X3RbUpIYBuAWBulmRG8JK6RIBorzbAb7rE6uB0GoaCrpMg0l6z710+BJpOFU38dtngyqZm+0WvkkPg0mx+fkt5M/1RoRi97whW2GDtG4JkrRf69RnsbwvgJfjSVAVglOpviPKCi6iYHamZK4TzuHNqInWK5CdRGFbpR1ZtGaKEDYdJSqwweXq6fJZDvZ8CuYY
 oECZLkR1
 xOyNXjCv/tP4CO1xis5kYBEmOTAyWoKDQUXhU3uE2tWGMT+UU4dCNJGbMp12nS4ontrqfZifWf9R+rMk1EYCIOUQX8Aqd0+8AjP7QfY67mqtuqCd5JEAwdKaerVJIDiJhXugZTVrvLJSLCb/Ykr5lzydAGGNSwt2XUgBUQCXX2+econB5xlk3i4bQ70mWEPpSO54l+u/fSrhwtgB2ifFIiyXUTRGR4jP4/+jRJ0E40vOGB2U2Y6LvkJo51NO3LEReRuKxXhXIIMlYvn0qkHmP8U0sUrD5hdPW2Ze8lcRr3UCa/cCnVqwam0JhGCXOa7ioA7rsULf+nIl4c25tXsZ17q7TAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 16:03, Johannes Weiner wrote:
> On Tue, Aug 04, 2026 at 10:03:14AM +0800, Barry Song wrote:
>> On Tue, Aug 4, 2026 at 8:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>>
>> [...]
>>>
>>> I am very confused. Did you not see my proposal above?
>>>
>>> Why not this?
>>
>> Hi Johannes,
>>
>> For arm64, if the base page size is 64KB, a PMD would be 512MB,
>> and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
>> order-5, not PMD-1 on arm64.
>>
>> BTW, I assume khugepaged_max_ptes_none is intended for collapse,
>> not splitting. I am a bit concerned that reusing it for this
>> purpose would be quite disruptive.
> 
> It already is:
> 
> static bool thp_underused(struct folio *folio)
> {
> 	int num_zero_pages = 0, num_filled_pages = 0;
> 	int i;
> 
> 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> 		return false;
> 
> 	if (folio_contain_hwpoisoned_page(folio))
> 		return false;
> 
> 	for (i = 0; i < folio_nr_pages(folio); i++) {
> 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> 			if (++num_zero_pages > khugepaged_max_ptes_none)
> 				return true;
> 		} else {
> 			/*
> 			 * Another path for early exit once the number
> 			 * of non-zero filled pages exceeds threshold.
> 			 */
> 			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
> 				return false;
> 		}
> 	}
> 	return false;
> }
> 
> That's ABI and setups are relying on it.
> 
> All I'm proposing is to only queue pages that the shrinker would
> actually split under currently existing rules. That's a mostly
> transparent optimization, not a new policy.

I yet have to reply to some stuff here (sorry, it's a mess :( ), but one thing
that annoyed me right from the start is that we have:

static bool split_underused_thp = true;

But the default khugepaged settings actually don't result in any splits.

I think it would already be a big improvement to not default to adding all pages
in default setups.

When we last discussed changing that, one concern raised in the past was that
changing the khugepaged setting later would then not be able to reclaim pages
allocated up to that point.

When someone actually changes khugepaged settings such that the underused
shrinker would get active, could we walk the LRU and add all eligible anon THPs
to the underused shrinker? We could remember "already scanned for underused" per
THP, but maybe we could avoid that initially.

-- 
Cheers,

David

