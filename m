Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAC5C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE74D6B008C; Fri, 28 Aug 2026 10:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B984B6B0092; Fri, 28 Aug 2026 10:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85D26B0095; Fri, 28 Aug 2026 10:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5206B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:26:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D77D41203D8
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:26:04 +0000 (UTC)
X-FDA: 85150902648.01.A62723C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB27340007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:26:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WCbV4WdJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0OQQM96cRuVu1FTu7WqbsC1AtHFFzwK+Yp7CP8KbN0=;
	b=ipBr19Rk/mvX6qbOJxzj3zVBWbzS929b8jyO3Wb7gqz2P6d5ksKy95qMaRVOAtik0rt6VB
	+vTyJk+bXGkXG5iPk6fTNI4gXe0hFEk6s3x8GZDBaqnljuK6m9EHb6G7CE1OlWUrhtLS6I
	1fj0fUQJdSnFb90RXJ0UxYszcLT5n9I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WCbV4WdJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927162;
	b=ddrU4bNbz4bjGS8PiQHyeXbCoOEaPMRXHI6evXPSCfu3UOx5L+R3UCsoLmKKb+vB2gP+0O
	lHz9IXetC2dsXNzqIBxOXr9xmADzECJPSKHYMKlswMgdK6f7ZbMyy1OrBbwtcVM3z3AWFz
	97u0Oec5Vj7MiSheuqu8IG+ImYhwj24=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G0OQQM96cRuVu1FTu7WqbsC1AtHFFzwK+Yp7CP8KbN0=; b=WCbV4WdJizqDtTanXClaA1BwAe
	Jjs+oePpTqjB1oPSb26S2hl/+wnoLIJGLla0PnZ6b0Beam3zsMbSC8WaAq93PDlR1udof1RGiUv+K
	KQdbq5Tj7gJJI9IvkTDGLZdQhps+NZUtcD6B1FYK31lRBFQQx/oORxCe3SdO3dFR8FgUOZ7/FuepD
	PHyGlYqPwCULkIL3vDy3h4sVaDulX+MEKgtwi538lReReUUWAz0zj0qtXppeYzqHAfoKSUkpsfdQ3
	ea0MLXzia3rEQ58B8NVuTDl28douQsFa2aHC8V2hS58kKAT1ITSVOdNRKBt2abcnDLl1OLNK/eJbx
	3gsPn1kg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzxWj-0000000EpCU-3vkK;
	Fri, 28 Aug 2026 14:25:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DE3C930116A; Fri, 28 Aug 2026 16:25:52 +0200 (CEST)
Date: Fri, 28 Aug 2026 16:25:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828142552.GN788244@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828135947.GU776954@noisy.programming.kicks-ass.net>
X-Stat-Signature: yjnyea7bang49yng9d9p9ex4eckzui1y
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB27340007
X-Rspam-User: 
X-HE-Tag: 1787927162-992666
X-HE-Meta: U2FsdGVkX19mWeLo3FjwPxxkFNF3oG145GMDWs5juFBlDpfQp+vAJyuTq3F7ygClpzyGt7Jn4clV0YmxvLW5FJc50+4aai8TZNBdzeuvOvbOUAOSOd4MNhSy7nqQDAFP4oD3TfTUq7SDtysO2zWxbUguoPmPzTro+t1ymTlpRDvg+J+vvvbFt7wcqPhPzS/vVptIQkomONCamsC31brPnxvisQWMnh5zfPRRmEd+F1VUkJ6YETBx8LoHYzz7H0Ae5vKfl1+aGsK/gEs005kr4m33ET0ijhR2Yw7rcCoaeL4FNcUfuUk92RX5OT89Q77UJzZC0eYx9mCam4IN+FCDk8d2v+EoH1iZDQ6mUzsdpTctAfGpviIdoRNUqG+e00+KCLIMAfSaFNhXdJa/+ZA2RG2d+l4BgeK4tjPPb77MZY3TfZjrhEKlVXDhKVthhHs50kpQzbD9uUmZWgd0BI/aPsY+g97fHGw9XQT3LXQsQNQK51iQ5umXUEP9/vyTnZey/kJYK8nA7lo+hGYFRr+XbRAl/7tcaf17GQXj4FbYswHShGHaALPagXNdD2DqAATTZ24M9pijyuWj9aSX4965N31AowIp82eIILU50E3R6DleclAUIIhFEIDl1U06gVTxLs7s1Ju/jq2uMUF6a118wwBxGFy+gOBLihVYRptg1ddTiaHzs7CXSuB0sgB6+ZV3x8JF7/unVjfjQrwaT0Ur16WJHbmC/xxDnsrDG2w/qbLDkBmIk1E0QHym5Eqeb/+zg2Ddw1IgJzpTT5aQQaj7U1VWlSUJD6mg8aIP+esxecdaKtnEZQn9f8KqKm+kabIEGzTWTOfvPpn8q8FSVjFsQwR1u3hvSOclMiAPt2i1BHaFtny2cXUJCJkeizjB+se5bOqA572wjl/RUNpibUvKdJH7+nUSYQgL2bDQ2Dms9n/bTmP4AVBOH9CoSbjGtV5ou16LkV4hlSN8Axt6CKd
 RRSSE14j
 yyyLjTBakS9bEEHuW+MQKvsUDC3agdBuiSEfADPqLxv5wdt1PZt4ZUmjQZ7iTr0kxeOtgmmUkq5rW01jIZgYjH46teZ0bO7LKtqP/qbfMsYDWyFVN4eJy/LxDQfvPBAGQUGN3GhZ53uLjdCNsEqWWyLWhlTE4cmZT/6Z6tMGGsaLIKZ7ePKVXiA+oyv1rX5veEDNDN7d+RYc40fzAwxeP8hROqGncHsL0q5T8lR+x4+qpM5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:59:47PM +0200, Peter Zijlstra wrote:

> > What also should be simpler (and I am not saying just to move you away
> > from the scheduler) is to have a shrinker which iterates over all tasks
> > which are marked for reclaim and then similar to swap just unmap both
> > stack pages and release the second page which is not used.
> > Upon wake up the task should create a page_fault which would be used to
> > allocate the second stack page and map the whole stack again.
> 
> Right, so you can FREEZE the task, unmap its stack and then thaw it or
> something. But there should be a definite opt-out on all this, because
> taking faults on your stack will be horrible.
> 
> Not to mention you'll suffer wakeup latencies while frozen.
> 
> This all really sounds like what should be addressed is this insane
> number of tasks rather than trying to cope with the consequences of
> that.

Taking faults on the task-stack is not going to work. That fault will
happen while you have locks held and IRQs disabled. Ideally, it'll
happen when you're knee deep in the allocator.

That fault will then again call the allocator to allocator your stack
page, and...

