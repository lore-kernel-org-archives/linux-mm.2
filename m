Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B3FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896476B0088; Fri, 28 Aug 2026 08:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849B26B008A; Fri, 28 Aug 2026 08:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737626B008C; Fri, 28 Aug 2026 08:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5708B6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:48:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E41911C1CC6
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:48:24 +0000 (UTC)
X-FDA: 85150656528.27.7CB91C6
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 842D480009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:48:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=apd9kBBL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787921303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AY84rfjFkNDjAWFNf8AP9fCrg78WzFe8p1rGWp/UIAo=;
	b=0xyz4Y79/bXB0PJN2GtboW9Fvb1jd6i5KoOc4qW3yIWyDu9Ui4SdTR46w9vWfM8bG1Vq96
	uSt7/rkqS8mfROJI+r2VO+kcs3KGjPEBlX/rH7mWWfAbbpuEHiZ0uNtXSiwlOpmKVUPM6r
	DKKnbkr5OBYp4htEsURy4kdlweFA9zw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=apd9kBBL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787921303;
	b=laMYSSdUyuJVc+vvx2/6OFg+2Dt5lPbOhvIF+5na/E4WOwVva5FeEJ3W56jrFW7gIK7COZ
	xRS0uEJ7Ra70N/c4FiJ/cwcKtDmKjoKCtkjQ3yoACxvqM2pYD/h7d71NlWtQZLSfIi0G9J
	nchRqBYyfznr+RKD1ZN+fkghuJc1YGs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AY84rfjFkNDjAWFNf8AP9fCrg78WzFe8p1rGWp/UIAo=; b=apd9kBBLyOu58CYgPPP5CX3ADi
	bQwvk9xWrikcjNqyLtRx2ifMpANi76pueMtJCNpfBW3hS6hNFriUiwNXeOieYmaxYoWVEhH4yeyGQ
	B4ChwuMdqS6J+KGWO6Pa3/maqlBEgbclayatiFx/Nevfd831UN+Hiq0OeBqw4epE32rqEZruKNo5h
	Q94YyBfUjvAiC772y/3ECHbKipiJm4gmgQlmEjGqyB2krabU5/5qZDMZWTDH1+KD+eIB+yuwmHYHm
	GaTodGV5H2Mm+kMp6XQEbWwM8QktRq9qECMqOyA+DpA1ltXatP778QCi/VudQMVEmDm5i25tjrCUk
	2pUDBrnA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzw00-00000008FkC-1X7M;
	Fri, 28 Aug 2026 12:48:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C791030030F; Fri, 28 Aug 2026 14:47:58 +0200 (CEST)
Date: Fri, 28 Aug 2026 14:47:58 +0200
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
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	jstultz@google.com
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
Message-ID: <20260828124758.GP687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 842D480009
X-Stat-Signature: fki6k1srbjued4tzd9rc91aq467ke69p
X-Rspam-User: 
X-HE-Tag: 1787921302-493438
X-HE-Meta: U2FsdGVkX1/SNccP1rGJFgWPTDn35Zw/TzKZ6PSluaadSPkDN/9i2dGx5eDXghPyGzIk3ytTSf9J1SC1juC71aiI2YNdNQve30UEgor4zuIKv9wzhRTEY3IYDzP4ijC5JkUutrv//WQrv04zYuxAk+BHnnx34bLvY2bBnKQRn+pwb3tRT7TTI1s9oknNc55wWdU+arIgjNPb9JF7EIanUA3bwUx6xTeSRgtf7wZzgJgdEDG6g9YhKHhTRO9RIU0d0DxMV4c5E3jwKzWZh33zM7O4wEAJzvcibQxnxqqBFzyyQfVZN8djYHd4jUdheE6sp0QrYT2C3Lb21Z9Nc+y1gh/buvDQhM3tUIPKFxFRhDi5Z4AHuY4HAEe/8VhvJm8Ve91X1WzehtjDoEVW8M3DTS05s86Ryg68t/lw5fWD4bNOARxCXj/BqvXbm9bvhopfV7fVZ0sWXzaqeac2NvogMBN2yRhamni+ZzHsOIBoA5oTOkPJLCnPyjHafbyjvQHoYS65J8kr7ThZ+IEY2E997jgswizU37o1pE/i0LRNqt70g2dxwJS+gZUf2rg8F0Hg4TL2Bj3ntJ4t9kEMDDv7+UaJmjtnO72MaIxUCyDT4KhJep+4Qk1moQ6PJDCu/1ZR84ahtoZsVIKqy5BS9P2Iqg29nLtmHLo41cGh6i0ONQRtEH66wb1AnwUpG/3GnNPFDNVhjjG4+N8L+d5T1yuOJtvKtn/UUfFtNehgB9vnOyCPoCASN3shAnxA27jSunm2XEiaz54BU1PnqgjSWJ61AMUZbiFfQpNg8GLSjzh9NAN+9Fxv5MamW9WS7EOus+1Z/Hgbc0PddM1FxJhwyNxZTSe9vce7FZIY0iHyXViQkXJ38YvlQJoZedD0MJ0yoap8GKKNIN9SjAvynBEJV/u4erEq0MKi48uLTsKmXdHOzpvucfLf6QZ7+oNQZFOXC/4tGqH9yrPqwKhVayGgP72
 4kGcr9uI
 +YrKnF07tnGvdgVVZeqaAoqDAnMoIV1m4xsxc/js3pc0h7HSfJpdnEaC/bZhpLu+La0Rz8Er1ESyUxaNwE7nM2AUmf18Q+K0JoqSxeR3JIFGH7cUx75JGZXbNzoHnkmdNx7vpA8njN2QQrDaSpjx5OaSEvuiSZWtykEGnQZx6pX4ks3om4ZIsNtby3ulDCMMN51JyWKZnD2r4009IVbxuuWf4oi4pQ1TB0n0tVc4X3PFNylw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:38PM -0700, David Stevens wrote:

> On Android, system processes typically have 2000-3000 threads. App
> processes add 1000s more threads on top of this.

WTF ?!? Why does that all spawn *that* many threads? Perhaps work on
reducing that some?

> Tracking blocked state and when it is safe to reclaim a stack is done
> via a series of hooks in the scheduler. The actual reclaim of stacks is
> done asynchronously in a shrinker.
> 
> Once a task's stack has been reclaimed, it cannot be rescheduled until
> its stack is repopulated. Although there can be a repopulation fast path
> within the scheduler, reliably allocating memory to repopulate the stack
> requires a fallback path that defers the repopulation and wakeup to a
> workqueue context that can use GFP_KERNEL.

I am really confused. On the one hand you have John working on proxy
execution, with the aim on reducing latencies, and then here you are,
posting something that will introduce basically unbound latencies.



