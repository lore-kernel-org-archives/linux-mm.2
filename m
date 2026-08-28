Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CABC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17B3A6B0088; Fri, 28 Aug 2026 08:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12BA16B008A; Fri, 28 Aug 2026 08:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041BD6B008C; Fri, 28 Aug 2026 08:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA4286B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:57:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F0B3A0367
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:57:18 +0000 (UTC)
X-FDA: 85150678956.28.DA22A48
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83C441C0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:57:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZBP0PlIg;
	spf=pass (imf21.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787921836;
	b=pdvhi958g7j/zPmwagOlmz33/lk78AnTZp1zuqCWwVsa26GQqyi5lVrxjqw20rw4z7pJAi
	ekViR1urEttHTsr2WK0qqVSP3FdglT0rX/HXehmWx7PkT/R/gJVcJsKbxqImHhwb8jjVDY
	DXj7OlXYmOXcCQwwETFj/fgnJsUbJVk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZBP0PlIg;
	spf=pass (imf21.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787921836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHN2OGlf9GRTtKA96vHo/h+pDHfL02/7NECu7KyWS+I=;
	b=DxBzfEgdL/D3dEnuwM1Yb9IYsXPORXxrr9G54iQJvhOBx1fzyQFH2E6VTfZ1shaHVatTey
	Hu+WO9Jt8eq6tZ8JbJVaSAZyfnKfaOCAogXFZmsL2QV/DUXFzG5P6pl2A6ZEjtObVv0KSS
	29vVtTPfMFua+AYgeLRUsOy9swA7yfM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qHN2OGlf9GRTtKA96vHo/h+pDHfL02/7NECu7KyWS+I=; b=ZBP0PlIgUBT5PXNCWPnT6ZNLza
	iqi8pjnn5U2zgxLE3/f1oPZ9VivUarl90IrtBOBu31xNSGl542Eh2cQMsbuXL8RhZI7DhRsskA9Ov
	9C4dP5+Pwos2L2HWhnCqdm9+DLYTiHOEm8b8L+wIALCO+s8eaRWQDHTNysdJS3RfEZmJ/Z2v+ePz6
	+a5Nb5uJOArtDnR8MEwaQG+AR1VGkPILsrjEtlxSAmpUHVbTu9adhmtvtwM2kOgyivnGev1wctlAd
	c63CCdNSci5tpTj6b9w2phQOg1GEBotE4nJuU+zmBShMnRddlInXXJyDYh+NPB3FJbKSJCWhodF24
	EYMbarmQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzw8p-0000000Eih6-0Dlt;
	Fri, 28 Aug 2026 12:57:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3A54630116A; Fri, 28 Aug 2026 14:57:06 +0200 (CEST)
Date: Fri, 28 Aug 2026 14:57:06 +0200
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
Message-ID: <20260828125706.GQ687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83C441C0007
X-Stat-Signature: ekh7mujronq6qiiwmohmed1kggtmq5g4
X-HE-Tag: 1787921836-491681
X-HE-Meta: U2FsdGVkX1+CYjTmidCTIKYHEIb3ptYxWS2qwlXmHDjJHKAFURurrOPE1H2RnJ16Ao8g647xsnemiGO32qHxzUB0NpaixHrmJxxju48rtJGluBmFHAiCPndlKMKGKWypXXLnqz4/xOldte8iODSVAtd8TITPYSIpJFC4cDxan5kip3ebzOwP39q9xfJs5QvXM/qte5fLfX8efxVHwAKa9Mz1TlQFmGyiBfHEaAm4OFsq9DwaoiqETLmypMm26cSVNNAT+glYMgcUGSkiyzufa2fmiqLLlsto5fpO5zM6BrHv68ICvz4kxs1p+QFRhClTZ1h3MWsZTZyzi6kaMtl1MdNVIn3A4izev2RIwYxrPr8Hnsat4qxRIMG3Ps3YpUSOL7Zq8fbU/8B17ug9GHaXDEqa4n+Cruf1UJJN0jgHTHzJdJ7LT9WbjysNDg1L1XM2UxGqCSz+vsPW/s9hWcn23KqRXq8J0IlQoustX8ZKGGKIcN7+gGRqoFnHI3ufN79oTKn2yZB7cUbhrU477uNBJlRTWQ+1X5wP4eHCXwOjL5f6JQZKg9o8rKIQ1k2r84UheuUSfqSHsHcqwrc6a9Ti/Om+mYGCYiOJVtM3lbo46hy2u8eKLqpjCRCIQIgfp55axJUyGKWGgtkd2999AOhzJW6JNklOIV3lT31E5jtD+RXE67ItGjaa5SjWxjotPlhAp6+NbgyETS0Hp6MCpeeZtg6XMWFgkLsGLRhDOi6FNdtZe8AEO7di+YVSPvP4bv3SQiXpJAmt9KV5d9jfqDf25scIRrT4LHfXOHm3oqlYOne/8hIv/Q0eAiPMgwgO4DvtO7695El8eu6ED5ZVxPneqAYxUcrFkQ1hGQQdyIBRofg44f/yS5X0lgKN6vn7fPawYEjuK6CSN8tSi/946XIyCKst/L0LLvweNeN0+8NGbardPt34YQQnESnSyw8GNzlk0CqIXH6Qusa/23daHTc
 yTndrKiD
 kckAVt/XYYOKgO4GayfkRd5nh9gYYVZEyh7szL/IacXm48qG+2xPrcbtmdJb+9qXwPpnDEiLD8RKvlzoQuDCPUzDCLb1jDsJtePEYr16bK85VkjoigBiNFGtfBIuEIU3IVDxF6RiQ9yEoNEGvb+jHLs24HNfGUqgbURXZudhwcaob3Lo4YvR61rLkBrJnPd84u3+PLSNN/BOB+jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> +DEFINE_CLASS(allow_stack_reclaim, bool,
> +	     ({
> +		if (!_T)
> +			current->flags &= ~PF_RECLAIMABLE_STACK;
> +	      }),
> +	     ({
> +		bool was_set = current->flags & PF_RECLAIMABLE_STACK;
> +
> +		current->flags |= PF_RECLAIMABLE_STACK;
> +		was_set;
> +	      }),
> +	     void)

> +	allow_stack_reclaim(prev);

> +void __allow_stack_reclaim(struct task_struct *tsk)
> +{
> +	union stack_reclaim_state prev_state, target_state;
> +
> +	if (WARN_ON_ONCE(tsk->__state == TASK_DEAD))
> +		return;
> +
> +	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
> +	do {
> +		target_state.val = prev_state.val;
> +
> +		if (prev_state.stack_state != STACK_PREPARE_RECLAIM) {
> +			WARN(prev_state.stack_state != STACK_IN_USE,
> +			     "Reclaimable state %x for previously running task", prev_state.val);
> +			return;
> +		}
> +		target_state.stack_state = STACK_RECLAIMABLE;
> +	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
> +
> +	if (irq_work_queue(&tsk->stack_reclaim_work->irq_work)) {
> +		/*
> +		 * Take a ref that gets released by do_reclaim_stack() so we don't
> +		 * have to worry about races with remove_from_stack_shrinker().
> +		 */
> +		get_task_struct(tsk);
> +	}
> +}

> +static inline void allow_stack_reclaim(struct task_struct *tsk)
> +{
> +	if (unlikely(tsk->flags & PF_RECLAIMABLE_STACK))
> +		__allow_stack_reclaim(tsk);
> +}

So you have a guard with the same name as a function, but the function
only functions when inside the guard of the same name. WTF ?!

Anyway, it looks like you're sprinkling this guard around a few specific
block sites. Which seems to suggest your PF_ flag *should* have been a
TASK_ flag, no?


