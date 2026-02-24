Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB805E9B25B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008426B0088; Tue, 24 Feb 2026 07:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8D26B0089; Tue, 24 Feb 2026 07:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04696B008A; Tue, 24 Feb 2026 07:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCA8B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:49:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76F4C1A058B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:49:18 +0000 (UTC)
X-FDA: 84479330796.16.980D7DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92C9B140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:49:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771937356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jStwzl94e6w9RaNtwPvY25gm5RLmRTo7TsomKDClnlo=;
	b=c+OieRnWgpawVjtbz/sOXY05f6S0c4hmlX0E0FboPho+m/YZxlYZmhNnUZzuw/yPyYm7U9
	xbq11htP4WttjQMy9dOsHUs5d5ytMjPx0r2nQIi+s68qMpOrCMWuSRh9U9jn5I7UFzT2Zr
	kCSe4munPQ0Jezcp80w+Y2cTGxNM6Yc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771937356; a=rsa-sha256;
	cv=none;
	b=EAhIVMfqd9vGVJClGqsW1abS+MLMx09M9tH7bbCi/CR9LYgKY/ISAfzmB2vHDqoYyWglkU
	Gtlbon6XctZR8qu7UyQyEsDbt/l9MZjyzmUUx6OAqceKCT/SQKp5oILVAJay4GHj1bNP0L
	qFPu+dI/9kXHATrI5imDUeiNqrtgTho=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39386339;
	Tue, 24 Feb 2026 04:49:09 -0800 (PST)
Received: from [10.163.172.181] (unknown [10.163.172.181])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C3EB3F62B;
	Tue, 24 Feb 2026 04:49:09 -0800 (PST)
Message-ID: <9ef5f8e4-0cc5-404e-8287-ce43fcf5c139@arm.com>
Date: Tue, 24 Feb 2026 18:19:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
To: Ryan Roberts <ryan.roberts@arm.com>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
 <aZ14lUwuA86aiOH-@J2N7QTR9R3>
 <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
 <6812706f-1ea3-416d-8ba1-da522238e040@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <6812706f-1ea3-416d-8ba1-da522238e040@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3yhfsc5aht847xqa4x56ifu8xtn7ipa9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92C9B140006
X-HE-Tag: 1771937356-131586
X-HE-Meta: U2FsdGVkX18hPW77efvSsEaJm9gHBVv/DMIkA0kG1uIHbCHO/tPLCK7qNu0hXkOBVRv0AJfulbwBMXAs8jHx693G6tC9ze/ixatPihX4LqjfRRnbL1Zm1oujQXK61MMH44O/y+wzZnWSYesrM49kM1Jw51bAL17mtSfBhyPcyaqEmQf+od1CByoSbIFpm+JrWb8Y2USNHCmax6A2q8W6kZ6fJDbqZI4v4U6AUk1AULbDB0IbSpplSAr2lvzKoAB1LOxNoU88MTLCboWcyN9ONSyiFDkRAnjKb1LL7EnPR4LE7+dKMsSxerJHLsL6sfpj7BVJs0YgT4XLh8xF8SeA5DIcgH0al1ttfDbHFbopzJrV8IrebUHNklmq2Bil6j35QK9D6XkqeMNk2SpMIcg0pNommcYuM10XcraV75RGiV/FBxaPTsoj1q+FubUv4SsY2zwaqa5q4z7bMq9cFu+oaz6Gw3C1jFbntVYqh2cl8Q8LIaYTpM4t8pLlLxMDS92LkMof8zh7BXGzT9NNLrBnkkczlWdrgjYiI+suPxQ5rsh8yJ/GlEOeoza+kOdX+NefJrGLouLJyXZSkIhmhh5rALR3j7ki+Y9wpVLYLSeHpEMX5q73BUAtLHXrsOqgNOoOLnDTaMMcerWyCuqwkniVZJTUHlxIYfRU1ibkOKHzu8CkrkC/WvClg3S0/007gTNIk1hawRvbMFLrc1VID4m2VTTiZ9JjqdZK+pFSJ04mO0X3s+fRTla4SuncvWzoNWa2EH8TCqTv2NUmtuXB/uDjVHYwZvoGtFo47MlbF91xLxhtZe3lSojK087yq9Htiid+RyHDSa2rHjzO+pfOgcX5BPejDXKrRbotBHEasGSvzOiwXucbUELiEkAHbOYFVPJp1z9VDE/XTlkM6L66nUGePvX7aoGZ8KuzOojeSdXuzOIMdJ1boOkcadP2F5enZxzBMneDBfskgHL//KZYlsv
 9xkFKNvN
 K1TNx1tDqUWeYubp64rJZftLCGsDWfefev2LN5XN+Qb5E4HltOR1fzj1NPv+c5oEemqrj1trvLeUy1TtYryFaUQcbe8vA62nTorIXCL0/O69BVq/1GeU3FmBKTAVnHdGC6MuLpO6ibdE7iR0D9StRGno1vjAmBkPDrxsvPfxbeemzi9bjkTVVaY49g+Gfp75tlXgTkQkaLbyzrut3Jx+sOlA/10KyVLV+7vEHiVWtPKXFHXpO7RAlOpFLHKS2EVonjdeXnEJbeLyq8Ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/02/26 4:52 PM, Ryan Roberts wrote:
> On 24/02/2026 10:41, Peter Zijlstra wrote:
>> On Tue, Feb 24, 2026 at 10:08:21AM +0000, Mark Rutland wrote:
>>> On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
>>>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>>>> anyways default into READ_ONCE() in cases where platform do not override.
>>>
>>> For each of the patches where you make this sort of change, please
>>> explain in the commit message *why* it is necessary to do this.
>>>
>>> IIUC the entire point of this is that in subsequent patches, arm64 will
>>> need to use something other than READ_ONCE() for all pXX levels in order
>>> to support D128 translation tables.
>>>
>>> Spelling that out in the commit message makes it much easier for
>>> reviewers to see what's going on, and to focus any discussion/questions,
>>> e.g. *why* won't READ_ONCE() work?
>>
>> That, and only being sent *one* patch, I have no clue what the rest of
>> them are doing. Didn't even get 0/n.
>>
>> I hate people sending me just one patch; just send the whole series
>> already.
> 
> Perhaps Anshuman can forward you the rest of the series, but FWIW, the cover
> letter is here:
> https://lore.kernel.org/all/20260224051153.3150613-1-anshuman.khandual@arm.com/

I have already forwarded the entire series to Peter.

> 
> High level summary is that we are adding support for 128 bit page tables on
> arm64. Existing places that use READ_ONCE() to read PTEs now require 128-bit
> single copy atomicity guarrantees, which READ_ONCE() doesn't allow (on arm64 at
> least) - it fails to compile if used on anything over 64 bit.
> 
> load pair/store pair (ldp/stp) are only single copy atomic if FEAT_LSE128 is
> supported (which is required if FEAT_D128 - 128 bit pgtables - is suported).
> Currently 128 bit pgtables is a compile time decision so we could have chosen to
> extend READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But
> it's a general purpose API and we were concerned that other users might
> eventually creep in that expect 128 and then fail to compile in the other configs.
> 
> But worse, we are considering eventually making D128 a boot time option, at
> which point we'd have to make READ_ONCE() always allow 128 bit at compile time
> but then it might silently tear at runtime.
> 
> So our preference is to standardize on these existing helpers, which we can
> override in arm64 to give the 128 bit SCA guarrantee when we need it.

That summarizes the intent for this change - will update the commit message
as required. Thanks Ryan for such a detailed explanation. 

