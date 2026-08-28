Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9600CC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F416B0092; Fri, 28 Aug 2026 11:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400D46B0095; Fri, 28 Aug 2026 11:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7C76B0096; Fri, 28 Aug 2026 11:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F22A36B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:10:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62270A3C28
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:10:30 +0000 (UTC)
X-FDA: 85151014620.03.89C14F2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id BAAC9C0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:10:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="k1yC3/1T";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4BPKwfdr;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787929828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txJxc7ggr3poI2FLO7VfIUDXdgIFyMuKHMC/a4AMXzQ=;
	b=pRWc97Ow6bXfvPza51Qxulmwp8SdQI9YbCdJBClGTG7dyzwfkvkp2iNFCMtvyo6gBvRQGZ
	7qRa5uBmC3HzHcnm0J5WTXI8FIYYx5jg5NBYiRmYAUCXrvzB93G1NzIvA7nUM4S0EsvHyR
	+zeI+Uf4Wa28O21rQRYoMAv6lRrD0KA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="k1yC3/1T";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4BPKwfdr;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787929828;
	b=CXUlCVD4C+2QSy8sCx2NngZ78mVI49zx8zl9w/VYzg/s5htuEn+N+K5njDgpL9o7VLjvEw
	0w1nydmtnwNwNXurfU62O1qQQr/7LiS1ZuC+PyS2yag9gCFpZwLFUwNNBqRyFBjEhFNHmb
	t0XvhOLjKEH/qR1LENx+0GHpK/sdTXw=
Date: Fri, 28 Aug 2026 17:10:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787929820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txJxc7ggr3poI2FLO7VfIUDXdgIFyMuKHMC/a4AMXzQ=;
	b=k1yC3/1TSLVucW+G2hOymttYJNyxemcF0Wij24KbbvzrWJWTl2dTj6e6PoI5S0HrfHyPXp
	oI4RGa6W3u5aoEJG/2uXG7Yr1esVzqcii9kIAcVvca2UlTbIgjnuyFklJJzrTKZXRqX+fu
	ejgAg7ZLLzBYuFgz7MtDzaMLtFU/HLtc0BAfv8hKr3HpJsrtlz2g3lJ/Sqlfh3LdKWrn1S
	GTsJ4NmbyXAzkDLkFbgBjQNfoTov42PXv67fjZOSlBNDbwHx3Uq0FYD8NUjYTI3ReNlsL6
	lO/wJgykH2TvEmnn79Xfqs7ZjEmbXcCqXW/IiJFI0ER3lTMAlcw/3g0ZxDwYLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787929820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txJxc7ggr3poI2FLO7VfIUDXdgIFyMuKHMC/a4AMXzQ=;
	b=4BPKwfdrdUNYh8LjOXHLTIAFqeXqMCtM1JBZhaIPoExx/1SClqrf3LjHhwWJfGMIRfuC0h
	PrxrqZaP9E/FVKAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20260828151018.HnR9xV1N@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260828135947.GU776954@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAAC9C0006
X-Stat-Signature: eh6m6hpmhc5r45xqw1jqm4fagpee9mke
X-Rspam-User: 
X-HE-Tag: 1787929827-188817
X-HE-Meta: U2FsdGVkX1+6tyNSvKz/qIvRQnrE+VJPodqsfYcXVrOHBrQQfFQ8O4vktykKXvjbgqlySU4JFRHcSZplR24w52s+du7CVdVI1A4TqZuYSRHkJWIlyJ4GGHyuSMYdTy/d87UraLFDXpodaUTcquyETHDr8kTyDV4BbgLOhK5iFWiUN4govoPU4D7JPt0JgdjNCb0FF2XZV1Cu1LuIno25kZlIsHF6y+n7u2ShVj9a4YBDY68n5b/lF0XRxanEkEDCovYeFHMpVyQ4Cu8NFGq2+JLdbdw+sY0xGANMS6nf6kX/nC2Q90pV5skfWQjZip/PbTMXZJAYtzpYUP57EnyWQQpw1HSpMKu/AanQ4LVADYbf8kbClIAUrw1r6PnSyszyl57jjis3wI+cnt5Vu4joV+pvPk99jFqSA1eixFTQtr9KWv/OoCO51lRbU2o77esCWpbXJ1yqcA4TONUry2gfY1HiyX/CVyyURo7/C1+mQ3sK+NeZ1BRNxh46D0lE+rYs1FZ/GZV8JJ5BgA+iycgN2UMSisq8/OSHKaXq94zuIBze7mMnaBg5/RdBCYgfZovp1zUutHAl4/sqLwXzbPTYmnWJSwOXnjrqbcLSpjPJ68axZK/XuJ7zFTm/gtk9UN5QB3J7ie7vCs0ss9ljUaXV1zu4uGky5Z6+DTyg/PLM5PuqEKmDPoCeOloSla/IwWIFZgcMxdmRnaxzic3CoiRAYihN8NySv92XbDR2nsXH612ZByfwQh5k4s0hnf4QjubdjJgGxGDD8eqvKGFP7Llq4Vkp6/Rg5nyAgxPz11OzpsyHjAhyJTqrbbXmmgVdF/WXuNYcR2peO7rx424CSHLu+hltGohFwZdSpAuZmcPVAYjTTfqnGony5UDzuE5KIc0VUmwoAyxWAOcR6JMv4u08iFwBBbpX/g3F3aXyVmP4UyU7foU/UAJbNMu/09IxFoP3kIQL4snLZ4quzcjymCA
 6HWVKjbo
 933Z7nvROp0415rTHcwtI7RQNPRF1kwE/ceye7eh2tb/Pasu8sV7Mx1Fbmyd+LXLBzEAjmJLKyQUb/Y/+9xAuKwlYIhvDKlBHWTD5rhdMvHB8fGrzxFAzxEkobmVUHcfPIXalb+Ku3b42n0IWR2LlRazhqP9CT+DE1okHrdCZeKERKCf28g8VGuPj9OGj07wWjzHn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-28 15:59:47 [+0200], Peter Zijlstra wrote:
> > > +
> > > +	  The wakeup latency of tasks with reclaimed stacks may increase,
> > > +	  especially while the system is under memory pressure.
> >=20
> > It says *may* increase and on RT it _definitely_ will increase since
> > there is a kworker involved not to mention the memory allocation itself.
> > Anyway. This either needs to stay away from PREEMPT_RT or find a way to
> > exclude at the very least mlock()ed tasks.
> > Did lockdep see this?
>=20
> It should have. They're taking spinlock inside raw_spinlock and lockdep
> should very much warn about that by default.

Yes. My point was that this was hidden from lockdep.

> > If I understood the whole exercise correct then you have a kernel stack
> > of two pages and in best case you can unmap and release the second page
> > while the task is napping.
>=20
> THREAD_SIZE_ORDER	2
> THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
>=20
> that makes for 4 pages.

Oh. I wasn't aware that we have 16kib stacks these days. But looking
at it we have it now for over 10 years=E2=80=A6 Judging from 6538b8ea886e4
("x86_64: expand kernel stack to 16K") it might be temporary and things
are better now? Arm64 has a different story according to 845ad05ec31e0
("arm64: Change kernel stack size to 16K"). Risc-V also mentions "for
now" in 0cac21b02ba5f ("riscv: use 16KB kernel stack on 64-bit").

I just booted my XFS kvm box and did things and 8KiB works so far.

> > What might be a tad simpler is to memset(,0,) the remaining part of the
> > stack. Since the stack is vmap-ed it should be swapped out on its own
> > without additional tricks. That memset() would help zram to compress
> > better so it uses less memory. ta-da.
>=20
> That would still be a 12k memset with IRQs-disabled and rq->lock held.

Right, because the stack grew a bit. Probably still cheaper compared to
the other things done here ;)

> > What also should be simpler (and I am not saying just to move you away
> > from the scheduler) is to have a shrinker which iterates over all tasks
> > which are marked for reclaim and then similar to swap just unmap both
> > stack pages and release the second page which is not used.
> > Upon wake up the task should create a page_fault which would be used to
> > allocate the second stack page and map the whole stack again.
>=20
> Right, so you can FREEZE the task, unmap its stack and then thaw it or
> something. But there should be a definite opt-out on all this, because
> taking faults on your stack will be horrible.

Definitely. Not something for the currently visible app.

> Not to mention you'll suffer wakeup latencies while frozen.

Right but you would use it under memory pressure and steal the stack
=66rom the most idle tasks rather from everyone.=20

> This all really sounds like what should be addressed is this insane
> number of tasks rather than trying to cope with the consequences of
> that.

Sebastian

