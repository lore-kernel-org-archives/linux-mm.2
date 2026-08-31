Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70704C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0AD76B0088; Mon, 31 Aug 2026 03:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBBFA6B008A; Mon, 31 Aug 2026 03:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAAFA6B008C; Mon, 31 Aug 2026 03:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1D926B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:07:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 033DCC0271
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:07:51 +0000 (UTC)
X-FDA: 85160684784.19.0A2A520
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id 086331A0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:07:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="a67/WBXc";
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788160070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlHsLIomUZDuyupnnAtNJaCHYl4a5Rg7e9MyiEzSdUU=;
	b=ZGlSoDK5wBXdowCjXwjZqXsHi3+HI4HbV94CYw+kZjDeGlYh62CtXcp98tbVVL2rYZbaoQ
	E5tgNvJ7URj+CY2A4P5N0HHn6Lq00PFLgMSGgoXfZ901ELN9yJEVPYX46vHr3bMEPQfWki
	R/0oXSaeAqxNRhb9QoiNSotDkl6+nIw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="a67/WBXc";
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788160070;
	b=yv01KgtdWrMUlxBWYpXJomEZHMvuOxWO0jH6+uOUJ775nJDslh8tfQbRiDMJs8ISCKmcJH
	/GyR+K7IBaTrRA0hvUmGQX3hNf22FuxUKKGGDk8VfTi5dd6uFIjoaPkIRZ9VWJV7thhzdI
	C+7Yy+VvuIDxmuVpEIP20CmQMJ0OqFA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rlHsLIomUZDuyupnnAtNJaCHYl4a5Rg7e9MyiEzSdUU=; b=a67/WBXciwwfTXKyxpcVqnkgrD
	AlJwjFjl6pELrCGWf+akgeocN9/XKhybGbgvTSS9Zx5nrvlXfgo2SBaz14PrrOZPS2VukRTfhD/q6
	Jfr/OkRBqX0gkCPkMqhchghylTHtfrNvF52sQ+iAYXZbgLQaIpyZ/xgqDRNwxVXvgKMeQfd8kuRAF
	A8SN9TtFhnhAFtadO1lcrnkSC0ny7YBwnc8+GDgsWrgg06hTDeGotwS9qoQdZKgI50gJWin2KZt6a
	+qD2ksvaqTbKHuXTK4U/3I7+FKvGqy6LrTtZznalbKweNDNmLTET1K6dItlPFsOZHxPKP0vvF9ZXo
	iSIhEE9A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x0w7E-00000009b4c-0xtJ;
	Mon, 31 Aug 2026 07:07:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 26E203002D8; Mon, 31 Aug 2026 09:07:33 +0200 (CEST)
Date: Mon, 31 Aug 2026 09:07:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	David Stevens <stevensd@google.com>,
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
Message-ID: <20260831070733.GS687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <20260828151018.HnR9xV1N@linutronix.de>
 <20260828150836.2d5b378c@gandalf.local.home>
 <20260828151313.5c4a5e4b@gandalf.local.home>
 <20260828151747.20035d50@gandalf.local.home>
 <20260831065509.qqEtERDB@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831065509.qqEtERDB@linutronix.de>
X-Stat-Signature: 1bbbwneg6zxeeahrrc4rjj9ucbhkbkxp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 086331A0003
X-Rspam-User: 
X-HE-Tag: 1788160068-967590
X-HE-Meta: U2FsdGVkX1+HixZEPdEzoWZL9i51LZB4Eqbj1fWV3qgl8P0VDVMyai+yzmBafhaTtWyU1AK9odoFR6oaRq8uP66xMNXsj5rFveqOAavxAFLm1jRi+qckgWj9KSO3kF6RmftkfgcbWzCC84015LZqg5TN5PT1jHNXoMCjgDOr0Dx4UGvO6Zhthy5UQU5Ldyg3vZOfM25YajY/1F2YxX7rcxkIPM2JHj+JgW7SXLNHTwbFRijyZsUyC7nF5079WoH9HzYLQz4gGbDkAe8zd5CImA0/cApmYCEGxAfhf8oFdBxyukpCuqBUdnZi8TL1MAp9ZqxcGNTEo+2hrP+MXtS+zcQbOcksFkQIvuJqLnrhW8lXDZMeHFc2IeV9uu1PjDZOnicMeb2eP0VoWs7mKO4hzIPb0xrczpTsxp25jut3QAol2961AHkbTr0/AOesC2wc8DHSOTDkoBp+UMoizMJbiV3rnER2nMiPqb1bui2MeD+ULxN+yBxaYCa80FlP9NKlQy00z90PhMzVY1HZawqiOVfdmRWXYHUw6/kEoRl5bifuFq1Z8nmoSrNvQkbAwoJwkuSd+ovIdbjnRSr7TAj+F+WyR8DnQmEmK62MAPI8T1NFxNT3x5UfaxFLxRnG9pyyzfdq3Yiia6q6pXWWzgxwsFk5I49h0arHk1NWxohC7oMen2acKh0ukyBqFs2wOcrNZlUpAYd2bCxs4cWfX6+/ydx35nO0UdMs8zLnuBdZLTeThJzhYz37LKLJjvjCamIv/4g0KvjVyZpM94hFT4uvNIu3TJKv3Td50D47lUKoKq6PVt5ukgIxkLsCv57tFFd4/K0JhQoZeIu2kxhwpiYEsJnIBFzmNWs7FpFUt/Czczd4OOKA27L41ltovtS/i1Gp0lNYWPUuS+vNpWJbgjVckC1k/2ba/mK04hnnzpDwBnElznwmMz4+RabnGrQOUMoyNzKeiVuaf0SMHG0sWaE
 5tsRafA5
 kWeAl7ZvABRLnPkJ3JFt0T6GsOiALiy3JMOnafOzYpUUvqWuHppVO5C0m9czzXjj47VQYXrdZyPvwul/l9S1X7tAuEHTSQpGRIR4SvQLTogBUsa4Ef8fJRlL2p9P7gGUP+8cAmPFqzRfdyo8XSGr0ckk2zhnxsBUmp2t0aafKnNI8jUvbTOrVmKWkGz8QZY1rcDo7O5vj8pbbCOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 08:55:09AM +0200, Sebastian Andrzej Siewior wrote:
> (stack tracer running)
>         Depth    Size   Location    (60 entries)
>         -----    ----   --------
>   0)     8176      48   __css_rstat_updated+0x9/0x150
>   1)     8128       8   __cgroup_account_cputime+0x2f/0x50
>   2)     8120      48   update_se+0x10c/0x1b0
>   3)     8072      48   update_curr+0x31/0x180
>   4)     8024      56   put_prev_entity+0x153/0x1f0
>   5)     7968     136   pick_next_task_fair+0x684/0x8e0
>   6)     7832     120   __schedule+0x1ca/0x1130
>   7)     7712       8   preempt_schedule_irq+0x38/0x60
>   8)     7704      72   irqentry_exit+0x148/0x6b0
>   9)     7632     136   asm_sysvec_apic_timer_interrupt+0x1a/0x20
>  10)     7496     240   HUF_compress1X_usingCTable_internal_bmi2+0x12d2/0x1c40

> 
> Does this stack tracer distinguish between the kernel-stack and
> IRQ-stack? I would expect asm_sysvec_apic_timer_interrupt() on the
> IRQ-stack and not adding weight to the kernel stack.

This is the return from interrupt path, irqentry_exit() is right after
we switch back from the IRQ stack and are back on the task stack. We
have to be, in order to schedule the task and all that.

