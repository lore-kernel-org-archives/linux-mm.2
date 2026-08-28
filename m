Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45C6C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCD96B0092; Fri, 28 Aug 2026 08:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CCB6B0095; Fri, 28 Aug 2026 08:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD956B0096; Fri, 28 Aug 2026 08:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB2A96B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:04:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC3F3160369
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:04:18 +0000 (UTC)
X-FDA: 85150545396.24.F58844B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA6F640018
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:04:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="g+U/AXhX";
	spf=pass (imf17.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787918657;
	b=Zpd7HzIFynDMQX0d1EfhsRSLKFKI5qH8IU3bC5Fyv98HwDSm65zunMFKKo5KWa5y6cQXgk
	i6XEdc+K56zneoD99bGBVc0Sp8YIFX/HG2Mr7CK3Rh/me1vVSIyrPUSAca7089de1VFMdp
	dAs5W40RJB5WF5xQNDdQZJhK8I+Ckvs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="g+U/AXhX";
	spf=pass (imf17.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787918657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StE6yv7xm+286I4g7RWcb83gyYNv11/og1VLCuJGGrg=;
	b=PFNo1uOWuZCZyI8gSWToFd7N7teIK6FK4XqA9RnfB0s3MAsJHXoyjgZNGlgQdgOHDDFDSP
	meBwIYwuroJEzWUTLsteIoDqvfCmBdg6OW9dlc+9CT8qERrxk1df2Z907BIvDWieVULb1j
	L2s8PSPWxtqFORy75ggUYFHBbwt3D+s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=StE6yv7xm+286I4g7RWcb83gyYNv11/og1VLCuJGGrg=; b=g+U/AXhX8u1eDgBpqdk1xR7ga/
	Kt2hts3Z9eGty/byZBIGMnrQhk/z73YD7BnlLXJwvr6ynDNUvl0iUhKu+cG2shbEd3kuLi992Vcro
	vmMiuuboTD5xG7X9MClGy68OxbgmVZxEfM4tAgWp1DY+SGyMeUPMCpfN8bw9sC57YlIi3JTqGiFh0
	hUOoveqNeQM+T12KwEUktnDJFQ4VMR3Wl6HGEQ0el6HwnDTxlhplPqU0nH0qLgaMIoFPXlLLWNOEy
	xxvq5k4GVM+EAGtMijScxqO2e+VjpG5pl9SoXYrzoimnOXM4XI/KPJcx4fglBC4lXtT0B/Y+oGdS8
	GioRT/cA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzvJY-0000000EeNr-2cYx;
	Fri, 28 Aug 2026 12:04:08 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2AC2230030F; Fri, 28 Aug 2026 14:04:08 +0200 (CEST)
Date: Fri, 28 Aug 2026 14:04:08 +0200
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
Message-ID: <20260828120408.GN687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA6F640018
X-Stat-Signature: tuujqk9yti5agygm58swdzwtzgc5hjgj
X-Rspam-User: 
X-HE-Tag: 1787918656-484608
X-HE-Meta: U2FsdGVkX18324R56W0IFRPSH4Se5j0Tm0Pgol2ht+IRqQNTT8jVDL/ZukNmZ3sWQ3hfDl+PI+mdAzN1MF2FYjEsJHhCRZn83X9JaD2ir3xph/+bjEWHFsQPOwbxq/pnv+BGiCOeE+QkI3HqwvCNIFXipwjctnfC+QP2Aiua4AbAyfxoE9eATPbqawdxPyMumXy/t28oIQZMNdLFX8PC8qHYt+54eXF7/hc4EiNur4NffFvup6lZQq3nw8AUJ5LgKy4PL9yiJfxirZYOEAHa0sMZzI+YFCt8o1koWQTjTGIePvp7hjGwVDEfc1VhMfgU0g3W2/uJkacYWC7Fo4U/Jkl6q2+sf95ksGfk8lo7iG8Yplw9w240qeD0NZcgiJj0DLqvLD9SmB2sDz46Oeo9frwEnnLgb981z74A60Zap1diJ44FEQ3gnJ9m1pNJn636JlAm/kWFITCYHK1WJSEhroQ+EMTzDDWVpaM7LClD/FZ5tT7F3BMDbFo5lK8Hp6EaF69YNwLbuFPnQoh2bc8GXB6QtAeb76MRURs3EOutKEG3OGd/EeJcAc5h+KJEsJcp51E+e0L0jmAV7VoFuYjLzjujbPwb4r3Djsvsc29CRzvjmdqxuLrXV80Fap4RogSY+xHoSefVDTiWuG7R8k5aPnFEje//S6CpM6eivcFmkUHYjNbVf2kHhuA/CorW2ykmqaMSmrkLppHAU07TDUU10LnwlfevFmqpnklTqc/K2Y5u2fIEEbHLsrbgC/4l4eKICOmNyJbJhNwOsiu41fMm6rJxb8kbltZGIEKWhaXUlU+sEaIIc0WUJSo9KFYEslaAte7xpIpwfC/M4b/WZAQKMzf3QHC6jEoLNER9VoVtX9n5tcVjdqeBa/yLUplUDS4Lt01LHLAjiEdhvTKOKQMBr1vbc3+wfn4+Z7MbzD1JzPaMbA4mjiJ9VlA+nTwe0uihoi7ZORBPw+MQzVRfKja
 fmgWP6ML
 vgqwfBaGJ47GbvFCnlglAo6hQo1ejMrc88BiFCzyGJdIAO45FVH8j7QtzBQezMuZhKupwnr9co12X/xhMAECzlvvwjaDwWkzKo8OZW1kGH4zaVetzDf8M0OEjKKznYtELMXf2ZhFXh86mfO4UY92tawQ9COvRrd8as3vVyp/zYbVdWnBCICXOLmcs3eLtVHB0RRexxTAKZW6IAxGCBy3RkO0RAx2Q/0MUEN/18DnCknqya5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> @@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		 * A similar smp_rmb() lives in __task_needs_rq_lock().
>  		 */
>  		smp_rmb();
> -		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
> +		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags)) {
> +			trace_sched_waking(p);
> +			break;
> +		}
> +
> +		if (!ensure_stack_is_present(p, &need_deferred_repopulate)) {
> +			WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
> +			do_deferred_repopulate_wake = need_deferred_repopulate;
>  			break;
> +		}
> +
> +		trace_sched_waking(p);

Absolutely not; ensure_stack_is_present() must not call
repopulate_stack() while holding ->pi_lock. Not happening.


