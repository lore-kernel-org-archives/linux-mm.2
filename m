Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D714BC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21F76B0088; Fri, 28 Aug 2026 08:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB9A6B008A; Fri, 28 Aug 2026 08:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972C66B008C; Fri, 28 Aug 2026 08:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7293E6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:41:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB5E5A3BB5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:41:16 +0000 (UTC)
X-FDA: 85150638552.27.BC8CF09
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCEA0100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:41:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HzpcEx3Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787920875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsdYFNlmu3mZtC0DhffCWqMCuB12dqERlIoFUoVuPCg=;
	b=5PRPrwYbI1BBX+7kBr2O8vzIeOWflUUTQX3gKNdjYT0LoBL89r71fW7sDwj6oYHk7i3NIX
	/iIBsZrQQcf4SCGq3yJW9v8YE4rGZ5cNaNxkFkd8r6CqEW2+FsFAp6JmbaKwhMhmK5eI/r
	LGWL0UxQNAXjXIHPgdIrrT7/v3Ef5jI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787920875;
	b=7CTvbLntEvaFyfH3bq4hkoRoEC9RH/uGa1Wk888b1mbZb7CwD8yR/Urfwk13Kdhl6RUyQy
	/eChTknSFyaZ+JKBqRCUsRVbkny2P29hlxcjDoKzaUNBs0qktoZJfJPa9CGABb3uChFbx1
	pSXkcwD7CpGgGTwUv2a+d6zI/E9Gbtc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HzpcEx3Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JsdYFNlmu3mZtC0DhffCWqMCuB12dqERlIoFUoVuPCg=; b=HzpcEx3Zje4gJfUb+ceU/x1FvE
	Zl3Mh4+eWu1HIJa93GBWDAjBGZo41IkX2S3AHDLV+ABH8Iudi6x4SUr8JFb7Xp+1f8Ta90NUfIQpx
	xATI1wocphSZX/9LCrdJL9vLsfbJVD4ikAX0dnigoFCt2X36M6tqukfVSkYUTSw7/RpzWURd7G2B7
	ky42+wb5W0wgO3bhKN8rW0nZqed7CeNX1TYQw6coaPu0LDtCbvXRJ5cNfOXMnNwCO/uM4nFSEQZzM
	jAGWSRVFbt1xFQbORlb47ptVlPQUcPizFCQgguncsUiMarbI0Ol/17cCxaQrLbrIovxFgxl4kOQLa
	mZsBqG5g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzvtH-00000008FbN-2c6I;
	Fri, 28 Aug 2026 12:41:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 07F9C30030F; Fri, 28 Aug 2026 14:41:01 +0200 (CEST)
Date: Fri, 28 Aug 2026 14:41:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828124100.GO687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCEA0100003
X-Stat-Signature: hx81wycr9iizira9aadsnzpu35joc1sm
X-Rspam-User: 
X-HE-Tag: 1787920874-16234
X-HE-Meta: U2FsdGVkX18fntYezw1gywtz1b3z7+6/pk5/7kqRH4ZbA6QDrVczV01ao++PXx5czIxapFL2/YHL0AUpgpXugj4eTuIV53AmihZe1aitNFKjODx4SSI9knHjAolnGyWcqP8rduNtGIyLFcb7hHnmxWjWJWG8Icm4cSJCIpQ6Rs1NzDfFckppTSdI32/3lmmYOjphN4FTcKSEJG06w+Z04bS8RJKwzCxBIOtv1/8J7iit5h3Mu7xNNvYEhi2G21CDdEl+Zc/SUlK3AX6ul2wHE66IVekXXeWT1/suYMav3xXRw3a3qxpERxItqP9PcaO+w2Ct5J4pEsePWxccs40lQ7a2JaezoyKY92iGKcQXcqsGmMN8Nginq+NaWGy3IC1he1/3aPrR4yrCNLwdeCqDL/nNzRwajwSsc2kOZWA2qiBMXepsDERu0KxIZofHlDYPstAWOZs5caRxsIKxSTrbRqgx+DD+G389uIWxWDgCVn5s+3+5HceD11Ow57Ad/sQaer9/ViqsZoLoDkZWxNBgPmlATSs8wTbi8lEpscs5l1AXrNpoaLMt86qsO6UFMPSahgI4TwMl3QKRwo2OC5On08/TdWf1xBMfOnz8ZA5iW+TW2qqgZXE7pPyP33uv/h0RpSkCMYubgxyJbzmre+BZRKLLYpO9Ex3w6W/hjIfhs0W7zG96DaCFbA8i7ifnsCLPkFJUgzmu4bO1YFqMxm0JmCPo4DaoMbrTtxnsFSp4QMMv/uckmak2p2bAgym/mOAPz54jWq34RGRB4RUcqHiTkPIs3fX9PbnGt6ayLsEGZN08jZf85i9n2MuJeVfKreI1TvIR6v8hMi+wpO/Xhz6Y2nL+siVlBF/ADLfTrk1K4egIKl9TsXxTKiVws3yvGPV0yyqFtyUuYUVk20iB/01DJoga79mgIEaOWzGeEIUglwm5COUEvivg5dtqyFJe+evqZt+kiX4G2SD8588KrVS
 SQx2m0tb
 km1m6nOQtDmS9LsR1WLib6QWV9eZvr6h9KxUvMgiiONS9k0QzIXyzVkwX9s6ED5gkEf87VebVg9IKsHprGITCzMLUWvtrzR9Uwia3PaNN1eGLEwPs1zatXpJAC70GwneLjhBPQYnViuDBeonaU9sFIQIBtvWVKLNemGwYlgTxK6Lqd4/JefZbVJEUseLpBP6+yJ14zj5y3j8MiAxUY7VUnk/DIsCbDzl/k57lUdxiCAcFhNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> This feature does work on PREEMPT_RT, but is likely undesirable due to
> the extra uncertainty. The fact that alloc_pages_nolock_noprof() cannot
> be called from under the scheduler lock also makes repopulating stacks
> more expensive.

Aaah, so you knew it was hot garbage :-(

Please don't ever post anything like this again.

