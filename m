Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53446CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981CF6B00A3; Tue, 12 May 2026 15:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932FA6B00A4; Tue, 12 May 2026 15:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821FD6B00A5; Tue, 12 May 2026 15:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70C706B00A3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:02:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2649FA05B8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:02:48 +0000 (UTC)
X-FDA: 84759689616.04.6A2B7BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5123F18000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:02:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1fWPQ7Z;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778612566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9bYSBdDjZt6M/T0gkacCWwzYwMuBwq+RbVY1r8CX58=;
	b=6+78t7NgfUaUCVLsX7w8j+n7txXatENr+jwuoLVRj1jtWysy2K7Vazm9W+m+zeCKcoKzx1
	tB/y3QO0z73uLIhMnHiSuGjpdjeJcmgGxR6844/SG2urKTr5osVtyH2/doz6a88RlD1c4l
	oPgoF8yfHfJ1jQyeNuCc0XEpYP0G9+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778612566; a=rsa-sha256;
	cv=none;
	b=3F4GoOpwhBBd7Mlb/+3uQbEiE3JAnonRKr6C9RK6dmG5v3Aeq/cWiHHZiZz1qMxK0CYees
	z7SpwqWnpYOMp3XnZfZhl+Nx6a98lTM5rVpmbuyRg8QeS7to8Hh7Go+oDHwXZXWW8oKExh
	+suF52XgimQRVSQmErIFgRoG+smqqM8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1fWPQ7Z;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE3BF600CB;
	Tue, 12 May 2026 19:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6264C2BCB0;
	Tue, 12 May 2026 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778612565;
	bh=3bKefQy4otYYbwFyZp2DMFsGUMMldQvQElaEAhgQEPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B1fWPQ7ZuqcooVGxOfdhvR9DcNqaVCyLuK75rN+m0Cso54z+Fz7LqMW4WD8uxdP1X
	 wcl4yFkXreCtfjhROssalZ+AL07V/LYHrMOBVzY36cwnOcQZzrnhJHM/fLqcYolcmr
	 IyyUDpcDKKl2fGI/Wp60yVPN2IHrIgSeEtziMicfSLJILWd4jShL4uKwNdvbu6mLnI
	 tGT+jNG/RGBSrPvAyLq6kwsS3oDs1d9KKLB3pR651iyI7hM61j5xwOiDJ94K3Thtyn
	 NsK0Tq7wjGyR1kmi2f9bUyQGxxW1FJXpScfmVVdqjZ1qQUL2KKUYvN7iqyUN+bT0fG
	 CqLec+OvMDR+Q==
Message-ID: <f2f218fe-a14b-4714-9893-465a4edb4570@kernel.org>
Date: Tue, 12 May 2026 21:02:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org,
 dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org,
 akpm@linux-foundation.org
References: <20260508170509.640851-1-npache@redhat.com>
 <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
 <CAA1CXcBGEUUzUYdot9j5ftNrwhxDa+2C-aOMCtKfUBEobHP0Wg@mail.gmail.com>
 <2b2feeda-e4a0-49f3-800e-b2391b67e018@kernel.org>
 <CAA1CXcCkd7HWH6MpLQ+EeHzjJ9D=+=CdX2OsQAb8MMWMn=Rx2Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCkd7HWH6MpLQ+EeHzjJ9D=+=CdX2OsQAb8MMWMn=Rx2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5123F18000B
X-Rspam-User: 
X-Stat-Signature: 5swx9irgubouxuwey8je481y5dj61t4w
X-HE-Tag: 1778612566-733897
X-HE-Meta: U2FsdGVkX1+2QBUpyrRyDi24lJdzN49jagrqbluNE/CDETo8MduuN4pPBNSPdv7InglhwjYqHcptSt7OqFGM2t9HCBr3qPMqDG5GXH1LsudcX6og3mMshbw2hUM2hMw44g4kHyv5aoAOkINmPMG0ClDd8P+sGteLwn7kWQrpOBwrrtGwp/TYpET85vn8nAMnocWIdx+Ql5BO4X4cX1dlDWhwP/VhHy98Ofx94rv7EjlG0pFc7ezEYr5cNP+hutN8gprXjsQjUaOoUvarj08c6ixD3kslW9HQ1a/kLJM1ecYYfWBoScofUz8HnE08lldsFOg1359vgNxQy2TFAWATwxf2mlOH3PW8EPl+UbUplZZhM1ZJlnVG/rTWh2HLjyZfjnJMdgTvUu8Ur9D0Mzs4jhrDRzTXX9QjLi9uIvNk2PLuZSUc9uWcGo+MHLHwNHFDNN4H/N/hNJkzR0QJIHfSrfSt+cy6COvuLDUApWTvoyEy0JmIRe7yDqqeCE+jWaZvMPjjOJSAR7X65NTwjpXP8Kks1pFIDq3smFfBXRE4AVOcawVVPp8bSuwUfBq1UG1i05IjR3mCvuvdlkGM/y4JebY9TEuekGDJlhRgtgaduuN6s29sV1tb8sz7zNohl6m9BNaIwLjVh+7za5TKNVcgrF8slZQ10owkF0sY+mF2EtqJqQ3BkK33jRrOHgJ49ve7wHNJyeUi3sUmumlGj3TdqpfDGkQ9MAwVFR4r0tGwQ/EbD8pdtcJA81jn3VoNIZEC2egUL1Q+JErekl0ld9KoTg+WoTyRuCK6J6gUt3Xxz70ta076pie0884w5DSkSLlcoxvTLrE/kFP4kw1zbcZPtxEF/40iak4FPmRNe6M8WlIUY+Y7Ito1sae2lTYMF0xtgR3530BsIDthNwlD1FXkI8UmpZq1Ghy9yqQW/9ScJnJ5ZgMozLG0HcoPxiz3JdrLn86HxSGiRZy3VU6oXyp
 vrRb9yHJ
 AJUhiNq+pWEeuY3EUgUBH81R+LuhDdvEKdvf7snbX7NXIMU9eOaVrkREqh9hWINtHEV4M/T1wvV4SYx8SUbnOPtsyjEucbIsvISeUkKDeGp9EIsdJBfMvhDHkYPfciclGrUnnFghIMGZLfE01wVzg8I7O1jM9tTsblTJ1mrJ3dH6Xkt272Q+wBfrCmX1+0scFaFpyRM1FcpnUyVDOz8Pw59uQSvtoTDskdTkWWmhOs95j2clKlwLYKYYL5m/n1u9Fc5N4yIzAqgJhTsgkM0m2JIWEE0KhWGFkZxli0SyAFKaJFWy1/RRR57cSqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 20:36, Nico Pache wrote:
> On Tue, May 12, 2026 at 1:05 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 5/11/26 20:40, Nico Pache wrote:
>>>
>>> And what was the expected behavior before this commit? Did we just
>>> deal with the wasted memory?
>>
>> Before your change, splitting will always free memory, no matter who triggers
>> splitting. So there is no wasted memory (regarding underused THPs).
>>
>> With your change, if we happen to split before the deferred shrinker runs, we
>> end up with zero-filled pages that waste memory. And reclaiming them (through
>> the deferred shrinker) first requires another re-collapse to a THP.
>>
>> Or am I misunderstanding your question?
> 
> I meant before b1f202060afe ("mm: remap unused subpages to shared
> zeropage when splitting isolated thp"). Sorry, I should have been more
> specific.
> 
> As in before the underutilized shrinker (and commit b1f202060afe), we
> had the exact problem you describe above and no way to handle it.
> Correct?

Right. That's why the underused shrinker was added, to directly free pages that
have been over-allocated with a THP, but are actually never "used" (remain zero).

> 
> I guess at reclaim THPs would be split and we would swap out a zero filled page?
We don't necessarily split during swapout, we try to swap out the THP if
supported. But yes, that can happen.

I'm more thinking about other reasons to split a THP (e.g., migration, partial
MADV_PAGEOUT/MADV_COLD/MADV_FREE), where the behavior would be changed.

-- 
Cheers,

David

