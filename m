Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCE4CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C08D6B008A; Fri, 29 May 2026 02:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171CA6B008C; Fri, 29 May 2026 02:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087ED6B0092; Fri, 29 May 2026 02:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEE7E6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:07:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 945A2121063
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:07:07 +0000 (UTC)
X-FDA: 84819424494.01.3184B53
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A800118000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:07:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SkU6pnDJ;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780034825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9obVAHQrw+ENpLNs1uO9YRPt2EFA0yXLwmKqvF5fn8=;
	b=TuKk61yUDUL0bIryfF+qwkSiC9WC2NeYfBOAMluB9H9iiDdnpysuGYaDHvpxRc1ocwXwSL
	lS7xo+vlMULB6EHspNH4ydhlxskKHgc02Nk1oYhajsmSAZWMtgjx2lWh+MYcpLMfeiVOYW
	oUNFiMRhW/FC7VLASVYOUR6mrBkyB1w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SkU6pnDJ;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780034825; a=rsa-sha256;
	cv=none;
	b=Qdmx/Iyof7Lm1VOb6Nl2hollSOGxn0yeqHgzQrk8JUOiyfi7JXGBl5QZLU+NGIxUHdz95T
	6bzYs9Eo+9pMPdvl4woCEsS34IJn8D9ie8dF7VpsCOEz0nGhkCTk6hjtozey6d/666ExoY
	/nKSl+r87i15wbFywBHjv5EKd4qLbuo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F4D42103;
	Thu, 28 May 2026 23:06:59 -0700 (PDT)
Received: from [10.164.19.8] (unknown [10.164.19.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64EFC3F632;
	Thu, 28 May 2026 23:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780034824; bh=j1QJ/JmF3RS+ozhNYH5F0EegwZ0H7PPlXq/gF5R0ts8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SkU6pnDJjmyiq7jNIHs/4qjwq4joS6Tv4B4sKtWqsFNbqhAWZOAr7vvM6LdOyv2pu
	 G6IotSJ1X+DveHH0bhwTU6BC6wRX4wLL1CdEZI/7Ieq+SVSSeqEYZGJElKJAC72i3I
	 DeY2Ugfk/8/NJ+9Tyfsn3yfkI6UhlMMozIVbzpeE=
Message-ID: <403181bc-eab0-4f4a-b986-dab1d8c49bf3@arm.com>
Date: Fri, 29 May 2026 11:36:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
 <3b4176f4-e099-490c-a5e2-6a36d00b1207@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <3b4176f4-e099-490c-a5e2-6a36d00b1207@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qdcdbq7kdiqsm87ussgqzrs3ber7n359
X-Rspamd-Queue-Id: A800118000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780034825-737006
X-HE-Meta: U2FsdGVkX19jTILgbHZjRb/ZoXqj9+ySVEVgVU0qLeIt6AGYoo4xFOvW5AbaoYqhtjVuT2FhLYT9snD5ziZNo8HuvlaEwNqJMs06UON1PZj897rDYYcOL5soNvkmrWVwc0BhxRzA9UHQy/ewDIa2zg99zXJ/eBoW0kata4SOlivMF+iMFZROnmvYfv3gRSWq84EenrlD0R1Dg6cIRp6O1QfXbqIZj4yKyS74cyk5OSA9s8yZpRCdp5rolGIjVilJgXj8DPi8h8LPrs6DGaXpY217KolEn6DENeLfZlUVJ7+caTbc4NN1Irp93vbt3ubL1v/vCxvW1QsUwI6wmdqfhuDOUbTOBA7dN/xiY/a8tO92cwZ614asRUsOQBfVNl6Pzfwhc9D5BmhpJC4bIj49QLXXxVBtWD/KHPtRXWjHRadvDfZ20QF8RI0g4ivQyUGFwGnmoA1owfTBYXwjm4L6zIP1ebS2snTrKsuwwyzm7L/9VCjjGq7JeucXGQZjv9IWJoMgFukMfbpOZ1mWxBEM2+Rcum3DR2JuBf2wY6u4pWjTLWgeIb1M6yeP+z/oVayEXJJo+Kt2n9jvhyyGgR1dyz5vQdtKPwfC/1+C4jRBwL9y57HUU0LjxhxiW1vFmRx2LpP/L0wyaEXlu1r9N0KM7E/oRGIgskd/FAakE7xjwNYVZsam+ldkE2qWBhh+0Q4Lye4d1jaMeyCVbswOJGqlgNYtQPFenyzk+6gjou//hGllt86xylAxhL1TB/LhgF8BN08Du77CesgAkP5FDaaGzGrGmk8pxAJrEtVC2DywM4wJ0vRnPHPhzBnp8lVfaD3bgj2nfncmOu+4XlrdAgI4RuaRfal2ey8k74qglw0ybCe3NGUZ0TIL80FIswFRgwm1P1oBI/hZ3bCSi/8999r49wVO0SMdSo6B2nMusadl7lcxY6on5CRpC1XIrQrAKcOQU0FoE5ld0s9NkNsf6lx
 4Ih08CVY
 856eTHWtgHT+KTSiwI0TawdxVWw9oG5SauXmr9LSz8uj2fGR0x+xuZ0u180t8tZkA+3yKp5HBiBM20DP34ekDzgnLC1Bs4RpnuG35TJRZ8WFynE7Z2PLBf1W6tz57wK4y6jQqoYAvJPf44igr7L4uwPWuh4SCUF9YmIVqwfc5caNXejHoaBFxE+Nsni8a7OtwgwEoLytTUXLzjfspDcDtA9MjWSVC/3EciDmrk3H1CIg7eJekzsW+rp73zhYKFeYbiO6IIx+8eHBOvuzP0z/1s0eUK9LEVLea1M+3VmIzzMyxUOXBxNkzUe0eIF/oDbnPExex/dV3ON9SuQLdoEuW/Gq9/mZ675IUJRB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 11:27 am, Sarthak Sharma wrote:
> Hi Andrew!
> 
> On 5/28/26 12:17 AM, Andrew Morton wrote:
>> On Wed, 27 May 2026 19:54:27 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:
>>
>>> gup_test.c currently serves two distinct purposes: microbenchmarking
>>> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
>>> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
>>> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
>>> tests cannot be run or reported individually and run_vmtests.sh must
>>> invoke the binary multiple times with different flag combinations to
>>> cover all configurations.
>>>
>>> This patch series separates the two concerns: tools/mm/gup_bench for
>>> benchmarking and tools/testing/selftests/mm/gup_test for functional
>>> testing. To avoid duplicating HugeTLB and related file helpers, the
>>> series first prepares the existing file helpers for sharing, then moves
>>> the common helper code to tools/lib/mm/ so it can be shared by both
>>> selftests and tools/mm.
>>
>> Thanks.  I'll duck this for now, see what reviewers have to say.
>>
>> Sashiko still has a couple of nags.  Minor stuff, arguably ignorable.
>> 	https://sashiko.dev/#/patchset/20260527142432.230127-1-sarthak.sharma@arm.com
> 
> Thanks! I went through Sashiko's review.
> 
> Both the points are valid but look very minor to me: one is a temporary
> x86 build issue fixed by the next patch and the other is stricter

For the sake of bisection, we try to make patches such that each patch
when applied one by one, does not break the build. Sashiko says that
applying this patch breaks mm-selftests build for x86, so this needs
to be fixed : )

Although if there is no other major review comment, instead of respinning
you could simply reply to this patch with a fix patch and Andrew can
incorporate that : )

> argument validation for -F in gup_bench.

> 
> I don't feel they require a v5 on their own. Let's wait for reviewer
> feedback. If a respin is needed then I'll fold these cleanups in as well.
> 


