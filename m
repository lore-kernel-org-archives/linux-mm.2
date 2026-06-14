Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63276CD8CA8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 01:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD706B0005; Sat, 13 Jun 2026 21:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADF76B008A; Sat, 13 Jun 2026 21:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC38F6B008C; Sat, 13 Jun 2026 21:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB95A6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 21:48:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CAD71205F3
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 01:48:45 +0000 (UTC)
X-FDA: 84876834210.07.E6AE2FE
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 328A7C0002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 01:48:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sUYFAKqt;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781401723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzjGDj2ejPIFCiun0MsPB5P0vlqMvB9lE1U6mFzN0Ps=;
	b=fY/i+zYtQ+DJR66l2YVizFDJ2izRzkt8aDlnwzBnhADR8DYOn9X9El3BuEDapy4/Uk/eHG
	JU1xU3UocgK5Gk77f2vJJGNkuBMyjf3vVGFcEarIJHmWFqU9tFKXwgCSbxV+tulWYd7rQq
	LvtKwE/dNPNTawPVYXhXQsNplU2nHfY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sUYFAKqt;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781401723;
	b=WOJyCCvCjD7XAF8BCOcjXheBXJnrhvsXXTgHIlTd7peLhG+CLtsKU2e8cQIu0mDU5U2q9Q
	yk2+f2vEIsXn89BS16tIZWXy939FlXwKERch5sDE0PqsP5TI5lfGzE/ESMwxp/5Uk+ZppJ
	NM5S13JCWx+FIVoLP0lnTqBJurjJqVU=
Message-ID: <b08cafbb-a4b7-4609-84ae-dbb2cfcfc8be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781401720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzjGDj2ejPIFCiun0MsPB5P0vlqMvB9lE1U6mFzN0Ps=;
	b=sUYFAKqtwM4RJf6fCmx+1mgrbZe2fNy90UH6Dz0sMWf9THOBHRjr/8xpLW9NMR5yF1I6hg
	DLAzI1CLKsdTGwB6mWiMkBZKmCzHxLTFXBYSwebKQ6q0Bk7ExwfKgD31y1ypL02WzML/Dv
	WeRWbCTudTh8FwDEyK/GZ3zTwOAJI7Q=
Date: Sun, 14 Jun 2026 09:48:30 +0800
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com>
 <e68d5c68-9b4e-4959-a507-a9f94f3ce6e0@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e68d5c68-9b4e-4959-a507-a9f94f3ce6e0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 328A7C0002
X-Stat-Signature: omq8xtfums6x7eywm1pr5ubwmieacqp6
X-Rspam-User: 
X-HE-Tag: 1781401723-593261
X-HE-Meta: U2FsdGVkX193Hbx7Az0NL2s/OeotTcalZzJhTN+crY988rc7Af3y3cUpK2ZiLFBASLTEuUms4A2EjYGWsJZTeV1ThhNcY1QvuUKFzDYKuw1GIEwoV6V2GnxZcYW2UWY5o1yeqLsJsFyr2ZbztGfsDWCy/q876WfFxZTKYkcrp4wbqTLDzQb1dzqE+CxAWQAh4IBARCMzubgMdt0FNG4ICsmlZpbwQYcSPCsfobjNElVJW/038wIkyV4a/zRPvCughaWxtpLOwd6dXJUQPpqjs08Y4VxU8f4px81XCMcAu+M9BuiKbyGFaAwqsYOwj1J5rc2ApPJ0iixAFLnlNkjae1QuWNIaBHyRxv1OLZGkAB2EnJtFUCg4Op1prQU3Hn3pkBCFOhim4E+Ls6+lNNrwWycbYrnCbm+iE9fFO9z9vW0ds+o20A5hkZVH836XUyxSfD5SmDlvlIh3hfjghLwMMYwvXXaf8MBfsMJhAjgPuTuAsp8xZ+O2BCrD2J7086cctdhXsnlpjoKwbYd8jdZ2vcedgEN5H9dqi6QsJ199oRJk2H6apqpgi7oT3H+rg0meMOcNSY0fv3g4ExEba/s4ulOZd/vud7ViraDwTHEVJboQ1f6T4br3As337EUkSIbIQimBrWkdc2utVMjToNnHjQCBd2jj9dAPes6c3arKp8A+cNP8ZfJkUwX69o+ICqJrv3vCtDASTLnbPLEvf9tmYn3vgsLRqECxZpDrkGEsaYuTO2JFOavtaHnlpGLbhb2W16snWSdgfZM5L7xJWLvvegKKp1T/lDqUpws0bnilAg7ZCGu+XP8V29M885FfG76dCKerLRqI+7XHszGNnx2WrNek9bx1xNyZRcxowjKK1PHmGM+mrZGJhhuujFLLzNMD3DM7eIg87VGggRSFboF0p/AijfwvgUMvkxDh57D6tlE8NoWg3+uLCz7jhhpyyWcQURbSb14VGlqb0VdfBqZ
 6djW1dAR
 +qNETl1NCK/y+fPpmZOfY/6HuIHFF4ESESsJBAfDrOm4Ub/Xa0B0mfJ6AE8yv73EDbdqztZiz44SUpxjNldu5qtRs1omzTq58bLVFMQnel60FiCg5SuWi6bx44ZUIi6EQJxF6mAdBTr3+h4wkM+4JhuYbyWKolt8oS4s0mt7CGtDs4TBR7n70R7IuypuGaWZqwUqwvxMKaGogD6hqGTp6XHHevg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/14 03:34, Usama Arif wrote:
> 
> 
> On 13/06/2026 20:27, Zi Yan wrote:
>> On 9 Jun 2026, at 10:29, Usama Arif wrote:
>>
>>> On 02/06/2026 15:24, Usama Arif wrote:
>>>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>>>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>>>> unmap.
>>>>
>>>> This series introduces a PMD-level swap entry. The huge mapping is
>>>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>>>> resolves the entire 2 MB region in a single fault on swap-in,
>>>> no khugepaged involvement is needed. swap_map metadata is identical
>>>> either way (512 single-slot counts), so the PTE split buys nothing
>>>> on the swap side, it is purely a page-table representation change.
>>>>
>>>
>>> Hello!
>>>
>>> Just following up if there were any reviews/comments on this series!
>>>
>>> I know its a large series but was just checking if there was any
>>> feedback?
>>
>> Maybe send first 6 clean-up patches separately to get them merged first?
> 
> Good idea! Will do that. Thanks!

Yeah, sounds good. Less churn, and the cleanups can land first, and
life is easier for everyone :D


