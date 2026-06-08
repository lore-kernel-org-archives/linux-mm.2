Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE7BCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C65C6B0005; Mon,  8 Jun 2026 08:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176B66B0088; Mon,  8 Jun 2026 08:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D916B008A; Mon,  8 Jun 2026 08:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAC5F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:14:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 810DF1A0A4C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:14:34 +0000 (UTC)
X-FDA: 84856638468.16.D8590B3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CBCE1C0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:14:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nsVYtCvw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780920872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5o2TRur9x0ddEQ5S1UjxIZP9cFGroi39DgA97WlM4k=;
	b=u2MXmzimb8B+VDEZjU83e0SzkXi0e7L7sHqfEiKoLZuHPsb3+xBvFGLArbmr+eHIsYkGBo
	TnSofnIbLkSjUKc+Zn5gdjdkB3McH9Lo/eOeaUBETbpM9YoU02cVUHZEpyI5eBDbVVYyGT
	snwTDMrRsti1EKQJsWwfW5u2UHAN3xU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nsVYtCvw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780920872;
	b=6Gd9eTT6mG8HOgvC4qsVLbZwO991g81fhZJ/HsEw5Ai37aRNtPN54XNOtYHLDZhsWjAIpV
	kBRfzr3J/5Xr/4eK+UklJBzwm6lM0c5WQ4SttPjvM896Tj4gOp1BSLBcKr92ZpQinuxPdC
	ODnsPm0UZFULPf3qoZ1XHbi9qR3XxKw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780920869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5o2TRur9x0ddEQ5S1UjxIZP9cFGroi39DgA97WlM4k=;
	b=nsVYtCvwz5kJ/fDZNfegNk2vh28gl5OGT8lmDDl8FnDOkfQ1uX81bOLtIbveMzdycnp3mZ
	6xambuCN2z3PCH86CXshNpvd8eCNp/50D+EnoQhd/wXFb5ATcf8SHNKF3X4N95BpUoryRS
	jXeK0MS3kF3w5lFyYMcp0nIVwO9kNlw=
From: Lance Yang <lance.yang@linux.dev>
To: xieyuanbin1@huawei.com
Cc: david@kernel.org,
	qiuxu.zhuo@intel.com,
	bp@alien8.de,
	akpm@linux-foundation.org,
	rostedt@goodmis.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	mhiramat@kernel.org,
	mchehab+huawei@kernel.org,
	tony.luck@intel.com,
	yi1.lai@intel.com,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	lilinjie8@huawei.com,
	liaohua4@huawei.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/memory-failure: trace: change memory_failure_event to ras subsystem
Date: Mon,  8 Jun 2026 20:14:20 +0800
Message-Id: <20260608121420.64197-1-lance.yang@linux.dev>
In-Reply-To: <20260605081213.154660-1-xieyuanbin1@huawei.com>
References: <20260605081213.154660-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 55dshobw3f4s319a93yfrrx4jupoi3p6
X-Rspamd-Queue-Id: 2CBCE1C0009
X-HE-Tag: 1780920872-69736
X-HE-Meta: U2FsdGVkX1819dnhV6uCCZp/Sxj4kYqvjPO81tOroqLawbk+xwjhMnYdKY3xOZfpcbn25BgBR4O0ayo0FNU1d78+VElIqOKQvcSmMeYVVGtT8PSCVjxsMfBYx1ge2UMImrJJN0RGW5Q36lbehhNmcHkWBgA0Mwq/ab7Y1uuYMQaGWM7qCTeNCqbfICF0jZIXb3jLudUZJwHI4W+z2Nrk65k4o0EX79P6KxxpzdzJ/KNloMynZCSFBng2yU2Hp4wVtdF+SIwKLpzfTUUsZjFVgacGBqbIFa02Jp8xvgH0V5eM8tOK3utKvE5iwX0eHUGozV9qENj7E/28zjebfXzOCwrZwLp/W/aLgv207wDokvVf+OXao5LgLoOUGCiu67iDQubBcd/Zs+IXBbXIuPaIqedu0JYg33qI5zOpzq4ICawHdqnBpZHAY9oqPiobj+529V+PNMbK2toVQV8lwnCc9W1nUrYsP2spyMHTVhXLFIJmQtm9rhuxEc1v0WgyGCtoKH6Jvf5Y5PNQ7yk0NjZ21UxGk6GeZSCe9RJo8nm63EXXQqc28kVds+vRNDEa0p4n0Qdr3pXcuAuTtB3tsPpb5N3LDCXusoEB1U1WKpsOihOaMyMD/pBO6vPvaxd1J/LaE7w0A4uLypPsonaka0hBCZFHtLOc/ThO0JjncGsNtmxQh9ycgf5o5GpECuBg5MqDSvBkgekHo4ILWKegpYHQt0UET5XnI2OycULMzFUpKKuwIxJm6nuEiwwpwQunbZ7AiT7tmt4wZKSspT6dAyCnBh5LL4z9H0DNIwuNpKTYTi68uryDE8qZ49KQeADJBub7FLC816uGBz8jCNaRjposojiPtMMfIP/gQKCHKiThX7nDdDAKZTO06UW7qJHT/0kO5ubtEn8XSBvY7mD/yfTtDbvWVG22aRPHuwc85RqX7yt5H6rpfFxqCMhBJY4gUGEIY48QN7PxxfZBbsXm/OA
 ztmnuhPx
 IpTDuyTXT3YwTNPx28EsDKEtwjLScgJVLxd5gOn7TOodotvLY0mJ/WKAFP9MMGXTyBVzSPFfxXJjlKh1PgwioiA9md/LHPAed6n9GllcbacWc+FjhIR4a6nWc7ShpxWnmJiT2Pmlk9tqyUBugGZlObN6UQiuzCOyCgBcgkFP9Run22ChY85DTs6+EYwj1vEnlOzGLtCFadOPLmj4i3cpeLkGokGKjdFfmWWvtl9wR3KgOlWCtGiIuNxItOOSZGSQXeiz8TF9U3ADbJUYh3YaFnFkV0xqGkXMSejAv2kHTwYSq4DNdXvHc4BZzBYdSfXstpyoLzI4eZ+IZq15wIn/Yyyf+v7fpBAWAx+lN7avidpGkMDhOYAtFKBqvsmBWrfTlnEVqk5dTa+In8Po+u6sJhy64s5DEN70gDSRehokQFwOa+UZAadaFIxeaWrDJ1JAUXkYf0+4/2bTbVbyK7w+fD797X1eb2W5O5bAmS4ppm+V1Aa9cs4lps8wjkwrh09pC3fjUzmEcM6E2qibrUhyZkxhIG9UdsVCUtAIo/mPPkG2ByDY6vpXzdtbk3fPmIt3RTeZXliI9zx5W2Mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 04:12:13PM +0800, Xie Yuanbin wrote:
>For historical version, commit 97f0b1345219 ("tracing: add trace event
>for memory-failure") introduced memory_failure_event in ras subsystem.
>commit 31807483d395 ("mm/memory-failure: remove the selection of RAS")
>changed memory_failure_event to memory_failure subsystem. This breaks
>the backward compatibility, some user programs rely on it.
>
>Change memory_failure_event to ras subsystem to keep backward
>compatibility.
>
>Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")
>
>Reported-by: Yi Lai <yi1.lai@intel.com>
>Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>Closes: https://lore.kernel.org/linux-mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com
>Cc: David Hildenbrand <david@kernel.org>
>Cc: Steven Rostedt <rostedt@goodmis.org>
>Cc: Borislav Petkov <bp@alien8.de>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Miaohe Lin <linmiaohe@huawei.com>
>Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
>---
> include/trace/events/memory-failure.h | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
>index aa57cc8f896b..7a8ee5d1a44e 100644
>--- a/include/trace/events/memory-failure.h
>+++ b/include/trace/events/memory-failure.h
>@@ -1,6 +1,10 @@
> /* SPDX-License-Identifier: GPL-2.0 */
> #undef TRACE_SYSTEM
>-#define TRACE_SYSTEM memory_failure
>+/*
>+ * For historical versions, memory_failure_event is in ras subsystem,
>+ * some user programs depend on it.
>+ */
>+#define TRACE_SYSTEM ras
> #define TRACE_INCLUDE_FILE memory-failure
> 
> #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
>-- 

Thanks. Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

