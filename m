Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9D5D1037B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140686B0026; Wed, 26 Nov 2025 06:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1086B002C; Wed, 26 Nov 2025 06:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21FC6B002D; Wed, 26 Nov 2025 06:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBDDB6B0026
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:19:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F315140506
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:19:31 +0000 (UTC)
X-FDA: 84152512542.17.CFC2227
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 091CEA000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:19:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PYh8Cm+A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764155969; a=rsa-sha256;
	cv=none;
	b=0VjCIaazDrzyWfLuk92pQX5qaJAR/0b6onj0dHWgyJyGY0H3d3ebk1dO1qEiTdu7Dhskki
	z8QxHZLH28by+SClS9xDcEPdh554+ElK4A7AlWcUpfFhptgEBG8sjBKziqJu9mKyy0HYc5
	9hKJtV5ViNPrRWgsm/00jXQndClsz9c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PYh8Cm+A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764155969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tTKYzeAKmskwEPJDRmck9uGQFR/WVms+j+qZKExltA=;
	b=oVy2WuMbJ3MH591G72W3Qxlf0KDepdxG67bb0ixPQp0Ccqxz18fHSeZk9CCk/NO4V6KuZD
	/qBAW/uVUyU21WUp+az0/LpuUmJWB1WRtOKf/HC4Mic6ZDcQI56va7QXhjzWtS/UZKbQgW
	BgvRERrTs/sJSNYvvrBI3DmPdeuDjOs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2tTKYzeAKmskwEPJDRmck9uGQFR/WVms+j+qZKExltA=; b=PYh8Cm+AKY2HDhGNqmTBb+P628
	lyPzPGWODdXXmy6U/BH6q7HVErfsldyWJOSRNKrAh/BqAKBlMdSolR1ypFm08JzNP5i/HH1cpjpTm
	9YH6RvMwTjWrFdzPhtdU0JIPeLOqE5yEWRGug3zudo8gkdzXNQZc1I8IRJZGq58hagsm24Tm2fSS6
	WNsONjHKzKX07FKo5WXjmkWa656cPIDjsk9LyDCvn39sXH/SoHxxRyf4j+aADXUjUigzTThIetH6E
	nfakfO7YAa+CmXi9/U7Obv+UiET4nLpWI4GZDCH6nra3MgM+fcsKs7pwG4Ml5uS5B4ZXSBtP4SA7y
	rUv8lcww==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vODYR-0000000A0Jm-09VP;
	Wed, 26 Nov 2025 11:19:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EB17A30036B; Wed, 26 Nov 2025 12:19:21 +0100 (CET)
Date: Wed, 26 Nov 2025 12:19:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Xianying Wang <wangxianying546@gmail.com>, akpm@linux-foundation.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	linux-perf-users@vger.kernel.org
Subject: Re: [BUG] WARNING in __alloc_frozen_pages_noprof
Message-ID: <20251126111921.GU4067720@noisy.programming.kicks-ass.net>
References: <CAOU40uAHO9-59HB2VmCBfC5OiNg3BZBd-32jphtRd-nkvhD6Dg@mail.gmail.com>
 <4cb9f727-734b-43fa-92d2-80559df76c84@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cb9f727-734b-43fa-92d2-80559df76c84@suse.cz>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 091CEA000A
X-Stat-Signature: y7ofxmdhe44aj6h39k1w19nxpb6at7o6
X-Rspam-User: 
X-HE-Tag: 1764155968-936372
X-HE-Meta: U2FsdGVkX1+qfpel6TbIVeTYQuNdSVg4yGu86NfMgsXHRYbHa/ZQ/UI89vXLbTcfVHjMp2t0fMJ1ztJFbGxvEV8svxRFXwzmptGrNxg3kOaCl4URvQ5foAm+SxbKzifgtumlLyD+AdRW8KETrXtRaEvITBxnCcr1BZpHQ/3SzNImLVoo+1d8WKzUnN3fmaLpSD0UdxgplA/xWKzuZAMvC+gidR9Yz58Y+71s5f3kJgr6UzAlD5Nt2KG3mMLO3t6d+SVQJN3zoKo0ZVrKBs58yXrjND2NunfgpwA4D/1yXS3Y8xjjKdWEI/SP3t7hqRGsoSh5G1McQHboKODOkLIzD0DDTXiQ7jsGeC8Ay6IyMegYjnTJEOHFITrk9GXZiSV/CroHeuAgGSowwGnYfw1hAqZnIbUOK6rvBk3JxjTA7DO9bitzY66hiRwGDxRlGtcmrHGkXv7fCwojPsp68uhY82CxVrqwEM6J2oMMDwn2JrLnpdLN/+sQGbztFFuSHrKB9YYEkaRZNVP0OiSaGDLJtBrVvEMXP/9FtY+3ZCW+ax5ptr8LHHoh0P8dPaud3fHqAzFAMWvmdOdIWE3MG6SpvS5oRAC2FGjqTXM2qv6KZ5/b4rx8Iw9h+2QceEVJXTtiiP/9mTch1WSyP04f80cfLN266d+DPTQhdhrZc9aderU6ZJh3JYy8GkrGHSVIwYg96HEWS9dLMKgS7GrehF6Yl4hngx91QEWZayBXRK+tgXIyszrSWGQCPZZp+5WVYDCbzWlRVdd9f1CTCimqqiJRuv/vyA2DzRgutvwsa0bK6v4H84CsZwH8VtugabHfiSHRv0OOm8jYjSucceIoFOHAes3Svys/5d02MN5Ycwk58f/cMoZlf75sSiFYxkCfuaSKNCcK4nqbWm2teZTVl+XZik6p8gyxZLDiayRFsFvkCJv7Nw0JX2nWJqukccfUgbxatOCkFosJ2xqFxWajMmn
 zU8ldIy6
 olLFLeJY5Kv8Obg0/MmoUQnO4GxrWnhEBlt1wNdOBkJ7/ech+nr68Lb6uBdEf8dM6/gqzRhCwnZitZNLi7mEHgBd0w+LXYrf0zLEEWuePA4FrYoSLCRiuGe/aaH64ORS11PYL9lq33MX6b2/PKvLcoj+zlpx9a2c2fBNtrWEd0r1qKS7QHvuPN+vhVlPUeSIoiOWkN9ivjIGRxWSPmJ56pcWhG7KmfMnPi0PWy0yE5t2Bn+xAepgB/n7V/lM3ShiRifis
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 10:46:38AM +0100, Vlastimil Babka wrote:
> +CC perf people as AFAIU the problem originates there. Should the limit
> be lowered, or the allocations e.g. switched to kvmalloc, to avoid
> requesting impossibly high order allocations?
> 
>         /*
>          * There are several places where we assume that the order value is sane
>          * so bail out early if the request is out of bound.
>          */
>         if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
>                 return NULL;
> 
> 
> 
> On 11/19/25 10:07 AM, Xianying Wang wrote:
> > Hi,
> > 
> > I hit the following warning in the page allocator when opening a perf
> > event with callchain sampling after increasing
> > kernel.perf_event_max_stack.This warning can be triggered by first
> > writing a large value into kernel.perf_event_max_stack and then
> > opening a perf event with callchain sampling enabled.
> > 
> > The reproducer does two things:
> > 
> > 1) It writes a large (but still accepted) value to the sysctl:
> > 
> > echo 0x40132 > /proc/sys/kernel/perf_event_max_stack
> > 

Yeah, that is far too large. I suppose the actual max is somewhere near
8k, which would give 64k data for just the callchain -- given that a
single perf buffer entry is limited to 64k (IIRC) and all that.

