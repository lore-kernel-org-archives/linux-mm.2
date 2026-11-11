Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9DB606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ly0OFOvQ
Received: by kanga.kvack.org (Postfix)
	id BACA86B00EF; Wed, 11 Nov 2026 12:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DC96B05B3; Wed, 11 Nov 2026 12:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74496B05B4; Wed, 11 Nov 2026 12:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81DD46B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:06:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCADE802FE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:06:06 +0000 (UTC)
X-FDA: 85423465932.03.F9A9C35
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98BB640003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:06:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ly0OFOvQ;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794416765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6N6m0qW3yIxjKSp7U7uVNjBd3wWLQIrayrMA06twuQ=;
	b=TipUba4h9wcdPQvx6DlhgCiscwDoMBhpdh2xAFEM+HFLAAPhd1w0eJDbmJl187tP0jmxS1
	7DQkmlbwOHktfldtAtFO0NAXaTmXfoezcoV5p1aRT2c3N6L7VS0LJZHHf96QXt6uApAQVa
	n1nL14G8245/eG7cGYw4802EsLLlC28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794416765;
	b=YOWvEb8jIKcYpA3ATBciAcb+ajzrCmsKKeBEWC1BEjGsSRb53fXiRoL5iqQ2hIKxDCNDHS
	/WeX4d8Q8bPgp/ovqeCIWJ/XwGSzB3bNspzahzLGrsjCSbl0p1NVNbtHq+fF175/WaTADj
	sK3XwkUGKYo3/nk1/F95v9ggoMjtKNo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ly0OFOvQ;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A6N6m0qW3yIxjKSp7U7uVNjBd3wWLQIrayrMA06twuQ=; b=Ly0OFOvQAbh1Fx0woCgwdzl4JN
	IqhyJ02ZWh1sH6Y60OeSUyaTxEe4zvEbIiO5jUgAIJqQ7N1FrHRSTSdEIrTTlqoK44EOSWh5/exRb
	5Fl0/laB8l4pLvLdxHFGJAS3lmR5tgT/u08JtvLHdRN9NUb7f9HoFjKhUAZoTt+wSRtNjLAwopClU
	o0DGfIVxFfBJCzJTukpVP86uXjrt4XvS2HRxbogLMjPjzt5KB79aAKN6vqbcx5aaaCoJbWfmPqFRz
	j39TwPGH1a2pFYyYURkIbkRJPH4ZyNxGdi8156kmC6oPk4vJFnmNTs7gA5/ILZxqidjOdkM00yBBh
	D0eYKEuA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRBlp-0000000Blaz-10Mh;
	Wed, 11 Nov 2026 17:06:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CB0F230031E; Wed, 11 Nov 2026 18:06:00 +0100 (CET)
Date: Wed, 11 Nov 2026 18:06:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Huacai Chen <chenhuacai@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
Message-ID: <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111092421.3771992-1-chenhuacai@loongson.cn>
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: p41ozufeq5bp8guro3ewfkpupoztr85m
X-Rspamd-Queue-Id: 98BB640003
X-Rspam-User: 
X-HE-Tag: 1794416764-52360
X-HE-Meta: U2FsdGVkX1/tTHbqdVzPSWavsCp92F5b/w3lwbzVudZH6EBLfCpXEbHKwGdWP/0RRPp6qLDiNUEJDM/noyFeEO81DMDCqTFxnZsQurKQRoFwMA75dH6Nzq4v8KFnO0s9z3ZlOEy5HMcOy8LfJXc0Or1mQgDdtb0StLLCkO65thmmSNgoKU4fbkFHmg/Za5OxUPsQIL+8xmPq/OXTPW9P9VLSAe5iT6cIZesCyVqPnn3V3mX4UyPIgM9oNxL6eePj0u5Ycz1YaPXq3SsDi/G2rcSeQZ3XRb1AlaCh72UmHgzTMR/DEO/OZjsdpTXdb5iMtj/YN7dCgtjz9DShvl2GGT86eqmcQ4x27L/FNog3W26HKhVn0/76+0/eGi0vVXmgTuyS8OZNaXsdwUdnfPR17Yu3drw6BNeHT6AF5HBcR1N8Usnt3+PQ53j9tAoc4AdjRJpJj4jpW8agY/eWel491672LGo7f0zkMIezqjnh8sz89CZSCvpeP3LQnPnEbicx9BfNkCI9wu7oz05LADT5Xl5aWp5GBrQPnw4ijGBQr9iifD9CGiBSG9tbvklXlGGp84zIWxNiyzhT71XvjpHNjJIFigZT4I9dfr35lx7WXS4+HGkoN4sytshZLIY93sa6ANJhFPLu8oSCADomUpXPQPS2ET6JCTAUZIMw27+ksgZ+doBIQ6+ilAhjeu9EZvM2+mhpBeDqfVnacB7nDMUtbd4iHD/c0B+jkEZlFE2JQF3wxJnXKTywY38I+RSWvXNOFnC/IVZiDR5pEp3J16Jcm2yQ1HdKxTKKXgud349jPEd2e+yTiReq0B/gJ3zfsiPawS9VmiLVzLZ6nI763F4TlnnaqxbjgjNnAo8pQeS1lN4qoIwsbMIstZB5UxDsO4OMnsCK8ElviT3i7//9wtG9W5gpUc9warDlF2yl4IcNopkNd5WbSKBFUTw5P5BGn6A1LxVhBqzsL46JwZWdNEW
 BdB47BYI
 xZ+V8WA4SAuVHhQtudtb2EqwcqrTiyeTiKSYCCVE+6qhJ80qIdv0a4wGKGgF2fq8wbBRq1PGG/m8Wf4Yu4lv8LbzUqe9kw73OXGU1w/Veemmgk0W5Tu/Pr5ZeAVZa07gugLg0E9l5DprQgK5kVyN2XZ5XIC/OmeAGC2uPpRAxcWe++jyRgSI9YgOD8KL1vnpMuRIb8Z9nt1gSUwuhKcbYmChg2jhL48JE/l+YkkLKQM+pU1vxMQ+CgiZ9VJnK8vvrqmlg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 05:24:21PM +0800, Huacai Chen wrote:
> When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> calls to smp_processor_id() in preemptible contexts trigger some false
> positive "BUG: using smp_processor_id() in preemptible" warnings, which
> are harmless noise because the process always executes on CPU 0 and CPU
> migration is impossible.

The check is still valid, you don't want to have any code that uses
smp_processor_id() outside of preempt_disable(). Such code would be
invalid on SMP, even when ran on UP.

All code must be SMP ready.

Aside from that, nr_cpu_ids is the wrong number to check.

