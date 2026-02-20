Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 120EDC5ACC0
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B529C6B0005; Fri, 20 Feb 2026 17:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00D46B0089; Fri, 20 Feb 2026 17:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C636B008A; Fri, 20 Feb 2026 17:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 785266B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:36:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0ACA113A872
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:36:42 +0000 (UTC)
X-FDA: 84466295844.15.D6B7872
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 10435140005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:36:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKvJjS9D;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771627000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17l9wsknqpDh3Ho+puVaM2L51kBHPZptdt5u/gzymAg=;
	b=OOkIUC/5TePOD4GlBzwKxY1iFPsUdiH4AKPyqJJyAbo6wioMo+mBlv6i7kWHKd7j9EE4qT
	f+0pXKDNpwxdJ3ZNXF6ICYJ7NBT8381cU0BxavCh3LTLJOFuaOgValLgdq2ioMR/I1Gzvr
	rm6NTXY5AvjS1CEE/2OGnz0ErsOr3WQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKvJjS9D;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771627000; a=rsa-sha256;
	cv=none;
	b=u36h125lVPrPRHwct2HTtwqa2hs1Vwvn2dKDsxO4vCUw1tQNAenCojXZGnvsg81uic2NyX
	W2SzxCAGKTTqsFe6xsV4nhGpPmDGZTZxCy3KSDn2/9LYNPaDNVnJp+hljvoCveX9UnTAFC
	QAu25r/fsvUH1reWEaA8ny+nivaIMg0=
Date: Fri, 20 Feb 2026 14:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771626997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17l9wsknqpDh3Ho+puVaM2L51kBHPZptdt5u/gzymAg=;
	b=pKvJjS9DhaYP6P189MDYI9eqKNgtG2SFJBPkLvlJ+EBhb2h1Hrm9vIr1r3RBj6tuvWybPL
	HOqCqJcKbLRyHd56eGCI5eEreqe8BzOONEYoL5854Uq/71x6q4FoY5OEOnRKxdpxmLsDRx
	8fv3ZkcV40+xfqzepF/mQibG5VpBqV8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
	kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH 0/4] mm: zone lock tracepoint instrumentation
Message-ID: <aZjg6PWn_xhZV7Nb@linux.dev>
References: <cover.1770821420.git.d@ilvokhin.com>
 <06b2a2b6-d5c8-4522-8e22-10616f887846@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06b2a2b6-d5c8-4522-8e22-10616f887846@amd.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 10435140005
X-Stat-Signature: rqhpzhwdz9fiu5cj46zdsq6mxyar19c1
X-Rspam-User: 
X-HE-Tag: 1771626999-941899
X-HE-Meta: U2FsdGVkX19lShAHraj6wO+d2N9zpS6y9NGxD2RQXBd7g4RNS10u/wYku5wVzfPu8ffMLkwtaLDnripZHj8EYvzWngvTQf9Th1KD3HQVzLOz0EKBy8vck/5+00Z2K7I61g64tA3rNpGNteKjNkN+CZJGUMH+uSqIm30fmwh65fIOSkaH5wf9mzjy4DSXE3eOyl3rrFVl8i3tiTpj3dOvTG8UjNGPebq9RxHrUA9OyeV9pBB94US3QkeaN4JD6fzY8loYeeALQepCiAoGxHsyytGykeUPxY5D2b56Rp9Z26BDMsGwawoQFIWwj7psmvpPwfne1Bd5g9ibvfmE1JWkO47gIXwtzyBtYR4WGDzdGpQacsNP4OZgNntd3xH8XOEXVdIpKGIL9wWWkNHqR9mpliARekQKUuLc6FU3C1Pamwin8EvnUCH5CjEeQzWsS/RuZdpQiO74+cQTEHyoGth+cJDY/s3ngbdFaink3ylp4p8ETRVv1Z/qPe/dmLkHX8x4NrMepcm2Pwwr7pIvEVmKSe/P3fQyMJSZ9NkRvedgTc9bCBKwa1NDDDED8ojNYbrdqexQPjY0bb4WMG3Wt+p7ePHl2JCSEgQ6ODR1B1z3B75LUspcqgja6RsIz4XRJ/uzPYaD2x6ETAhcYeKDLcXcovZd/zv0KS6/UCQXpvyvyt9Z+yP+lZtEx0MAr2SeziOB8aKg8+cI09t8kyWvQm2Hg1quthM7P+cMVQszfjZU8Be1WYIvIB2OQulHzAvREIcwJjdnltTgmY39fqvhKfY8ZP6HvsbkxMOW/Y4ZRAdbVF4x8XWtU9h1rujvQdeaaEmOIlVw+sp6WjDaLqbvlcczZQGGNVowD16WVQoYuas58f5Re0PWZ/zo69hOmrzE8Be8BiFKmAfsOTMrgqSBIy+hfRwZtbRTfRHYqqsnOtXB2WCd5sZxsbRzjECUWO03N6QTrcmgl6G+5UtyThHN81g
 Qd1gwPZx
 AsErN1+6S2IXxSYpYuxPSwxKmdYwGAVrqj10zhJXJfPkza6Ld/WZceWrFfcdMDwz+J2Sm8S3IRRuuuYKZANyLvQ8+tFD4tJROSC6k1FX94oc/QerhOJSJ5GWEiYtAfhEhQH8kx9smksqcyreE5MdQsim3FP4zlvMIBpI7bpGcnZ/7yJuCUX46FLvFnrh8LLEpunpQf86qLwe+dwzI7jz8d8wNFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:09:59PM -0600, Cheatham, Benjamin wrote:
> On 2/11/2026 9:22 AM, Dmitry Ilvokhin wrote:
> > Zone lock contention can significantly impact allocation and
> > reclaim latency, as it is a central synchronization point in
> > the page allocator and reclaim paths. Improved visibility into
> > its behavior is therefore important for diagnosing performance
> > issues in memory-intensive workloads.
> > 
> > On some production workloads at Meta, we have observed noticeable
> > zone lock contention. Deeper analysis of lock holders and waiters
> > is currently difficult with existing instrumentation.
> > 
> > While generic lock contention_begin/contention_end tracepoints
> > cover the slow path, they do not provide sufficient visibility
> > into lock hold times. In particular, the lack of a release-side
> > event makes it difficult to identify long lock holders and
> > correlate them with waiters. As a result, distinguishing between
> > short bursts of contention and pathological long hold times
> > requires additional instrumentation.
> > 
> > This patch series adds dedicated tracepoint instrumentation to
> > zone lock, following the existing mmap_lock tracing model.
> > 
> > The goal is to enable detailed holder/waiter analysis and lock
> > hold time measurements without affecting the fast path when
> > tracing is disabled.
> > 
> > The series is structured as follows:
> > 
> >   1. Introduce zone lock wrappers.
> >   2. Mechanically convert zone lock users to the wrappers.
> >   3. Convert compaction to use the wrappers (requires minor
> >      restructuring of compact_lock_irqsave()).
> >   4. Add zone lock tracepoints.
> 
> I think you can improve the flow of this series if reorder as follows:
> 	1. Introduce zone lock wrappers
> 	4. Add zone lock tracepoints
> 	2. Mechanically convert zone lock users to the wrappers
> 	3. Convert compaction to use the wrappers...
> 
> and possibly squash 1 & 4 (though that might be too big of a patch). It's better to introduce the
> wrappers and their tracepoints together before the reviewer (i.e. me) forgets what was added in
> patch 1 by the time they get to patch 4.

I don't think this suggestion will make anything better. This just seems like a
different taste. If I make a suggestion, I would request to squash (1) and (2)
i.e. patch containing wrappers and their use together but that is just my taste
and would be a nit. The series ordering is good as is.


