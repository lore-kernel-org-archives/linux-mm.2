Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8495C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7180A6B0157; Tue,  1 Sep 2026 08:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C86E6B015A; Tue,  1 Sep 2026 08:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6BC6B015B; Tue,  1 Sep 2026 08:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 348766B0157
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E76B802E0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:01:54 +0000 (UTC)
X-FDA: 85165054548.05.BF693F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C85C04000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:01:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNCIx8Hy;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788264112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZeZ5z1io+JXvJ9SjEpRD3rg5z31zLq/vQ8rd29RbRw=;
	b=vKeppErF+6/JpHD+JVK5Kyqpfqc9MBN3tmEoIQQguKvTfD5nCZl30/i7lI8OCxJuoCJtrL
	LEA4T1eaprd2yPkJAGZQ84LxUyq1VCJtKEr/iC31npDmRk41aVW1PbQ/vR1Y+7iBCbMUuS
	yXDVW/OMJbh/WT9jjG9lv1xAH/Qj1us=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788264112;
	b=srSceiAEBSoZl16G3S/zdpSc4/jmDwpuBQDyKZN1NZV+lC0RS+SZedya1iYDkCFVrwkGMo
	7OnGvunfZ7rOIiZvc759/+IW1Jk+Ph7SGg0z0WRZCVLxPhafNb3RCSuFbDXBkAoRhMJfYe
	wMFTHTk+iorpx8ORxriEHmdMogVuwHo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNCIx8Hy;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64F0F41759;
	Tue,  1 Sep 2026 12:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F821F000E9;
	Tue,  1 Sep 2026 12:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264107;
	bh=UZeZ5z1io+JXvJ9SjEpRD3rg5z31zLq/vQ8rd29RbRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LNCIx8HyxE0C0GimP6YmdWgLiB61HFusPK9NlVs4pEdW6tXaSiLthMT19zo3zVt5o
	 Ny4xjCLyqoAD/a81rXEoo6DYlQ0vBjc647cjWj1LKugWyiJso8WoYF2GrZAX3yqEkP
	 /zSdQr1lcwLka1XKTtrDWcdOIhjoq8u0XAJmMZ7wkd7jVjlkZO2re7+Qpo/7Wl0ezt
	 1VZjC0Avsup3v6VcvQijMM1myhSYP5gfZUWQPW42wS/wa+W4oQqskwzmQMKhHfjnvg
	 oJSAoOpUW+uC53zJbe9IthmM/+B73Y252UlAbIuPjXr2h3ASy2P1hQtqnK1oo59jZ6
	 78ZdXpfDAWJwQ==
Date: Tue, 1 Sep 2026 13:01:37 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
	David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
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
Message-ID: <apa-ocvQBOi8gy_E@willie-the-truck>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <20260828151018.HnR9xV1N@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260828151018.HnR9xV1N@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C85C04000F
X-Stat-Signature: iigbycnadzb1dhwedny9zr4gfsxnn1y8
X-HE-Tag: 1788264112-890373
X-HE-Meta: U2FsdGVkX1+GnlUnjnJZe1/c0sk6W+S8cw5yD24BoF8GXTLcS2aK9NoGUTDM8ba6ykCBWfr4Efrr8vR5kCzp5tJk/yxYaVsfDoOo4/hbErUeS6DhnDSXxfRT/sQKmujKbPSZG1XONnZpjq9H5RvccLFBoksz2gJHLsufUeI3Q0FAQ0ii1VF3lKkengg7nEOawl562E5TEZ2sZ577Fm1QgWZNhA7DGK3VlB22g7GPAPHi+Ot/85rCQD53d6YD4B+ygbezDO2zywM/6bWk8rv+c16ulMM1yJ3JWtABGL+71Y6DUS2hPOL2bTkaB0rUCaAf9myIRMMqpf5vYM3pUml/xXEFVuAjtRkULtfrcVNWxmRFLpLbVpR47hGiso/GrIbvTn+nkaofwiMiAEKkiPLQQIxn5ieKeSb1mc0oPESp+xK+Grk9W9n62TFqTNdX99HLk8mtamcbbiiw2+KH4sKyuS829Dfr/KMY8ZpNA1+RtQOA15s9FVQ8AYaQUk1reIDxHp7gKHT/ExnccGqA2DuwTNe1C1m3HUs9FzClPRZ4YcDn5Oo2CklNzEV3fR8S0yQPS92lmeOk3yCBfxvKj0m83cj5QVk9zU9oKqBdscrMmSjNx5k4gKe8WAcLfia/mqjRurbyNxy8J1ZyplyQTwBC73J3JBh+OHvD/5sINKsC85DoRL4O4p7LUx94zFmEpakZ3mAfynwzYEoHBmR+u4L4ukPvTGyw1sUAXOBAnwMVNNMT53M7aJE3HjbfclBDkRw60PT5/6r84ahnZ8JL+ZuPPoVOJQV6acsLbEIRwiM4w/YI9eLNELORmyGZxJXJrKJvoivz6M0AvMksZ1pg77sfJdXyC7ecjLAbYj4z4ihcjXFoyYX1c8xXdpB5w5PuxEzK8VXlfualIIFioTozgllXkGp9fOSQXH4MKLt+HVX1FeYi4NsduahbO8aSwpqE6KgMviwoRA855IdAEoI/ZoC
 t0sg8pm0
 /TMCEBBFNcB6ocLA7yyZLECTQ9rIlulVbYrfdDXlzBwoZWGre9957OUtgC40EfduEVzWApyMN6VUl7MhgsaKELotYxqZSqgmpClsP7/rcdQ1AVjq0Y7f5zUSgr117N/uHSG3U5HzlsVpajN3wOdXGtwwLjD8SEbyT030+qkf/mwmmOXVQgIS5GCmuiFs5wgFLp/o9dAlARHitxLfQJfTKZlPq/4bH10stLIwctlMGIC3dlTsYoX20PVuU1WXqcHYWNET/aJtrBjf6gsEW9zCEgchXhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 05:10:18PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-08-28 15:59:47 [+0200], Peter Zijlstra wrote:
> > > > +
> > > > +	  The wakeup latency of tasks with reclaimed stacks may increase,
> > > > +	  especially while the system is under memory pressure.
> > > 
> > > It says *may* increase and on RT it _definitely_ will increase since
> > > there is a kworker involved not to mention the memory allocation itself.
> > > Anyway. This either needs to stay away from PREEMPT_RT or find a way to
> > > exclude at the very least mlock()ed tasks.
> > > Did lockdep see this?
> > 
> > It should have. They're taking spinlock inside raw_spinlock and lockdep
> > should very much warn about that by default.
> 
> Yes. My point was that this was hidden from lockdep.
> 
> > > If I understood the whole exercise correct then you have a kernel stack
> > > of two pages and in best case you can unmap and release the second page
> > > while the task is napping.
> > 
> > THREAD_SIZE_ORDER	2
> > THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
> > 
> > that makes for 4 pages.
> 
> Oh. I wasn't aware that we have 16kib stacks these days. But looking
> at it we have it now for over 10 years… Judging from 6538b8ea886e4
> ("x86_64: expand kernel stack to 16K") it might be temporary and things
> are better now? Arm64 has a different story according to 845ad05ec31e0
> ("arm64: Change kernel stack size to 16K"). Risc-V also mentions "for
> now" in 0cac21b02ba5f ("riscv: use 16KB kernel stack on 64-bit").

FWIW, I'm hoping to make the arm64 stack size configurable on the kernel
cmdline with a view to changing the default back to 8k (assuming a 4k
page size). With 8k, we currently see some overflows in direct reclaim
(mirrored by a later stacktrace in this thread), but Suren has been
looking at ways to improve that (e.g. by moving it into a separate
kthread) which look promising.

Will

