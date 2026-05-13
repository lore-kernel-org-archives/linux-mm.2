Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C67CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629046B0005; Wed, 13 May 2026 15:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3D56B0088; Wed, 13 May 2026 15:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ACF6B008A; Wed, 13 May 2026 15:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31ECF6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:26:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7639A402CE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:26:19 +0000 (UTC)
X-FDA: 84763377678.13.67ED38F
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4652C0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:26:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HJfkqXV+;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778700377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jXgOm2W/v1Vl1bT+RF7zk/Xq/msqAlwEyLXpPVPOgA=;
	b=pzOWhQwrIbVpnjotZJtX0iwRbljYqsBtQwSIJ+VH9U0erGEqCYwGDG1BAvSIQn87TNhZFR
	rMQ/mPkjyVpf/IOZi534vPi6gKV/PKqZvk240ATylrZr53LFnYWGhX7TwLUIrQ+t+T/uCI
	QiCnV76rW3WMry7BCAVYp7B4VD3yH1o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HJfkqXV+;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778700377; a=rsa-sha256;
	cv=none;
	b=noXEVndTMqK/hBWxFKOy6EVXN4gSjD84f6zY7Oy7vqqHCA4465fveo1tz9BEnM7hyzWSdr
	4RCbTM0pzzRv0RrWlUsMA9urBukVODirrO8dP+j1K7BWuVKietkQfOImIBlyPVb8RL7msP
	RGohBx9KWWO94C6E2lfYI1jz5EfWgHM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5jXgOm2W/v1Vl1bT+RF7zk/Xq/msqAlwEyLXpPVPOgA=; b=HJfkqXV+o9pZuHWl156uv9ZV1+
	pAU2fPeisDFyWOFbut8ow8ktjj2bC4mXW5tWR+lScGE4ycAW6WnbitCChoduuN8LwzsBfUbDl5BmP
	xNdaqsf20yeJuhpMBbzq2iMviJaFhZVTbHMaR1plTPwOBP1MwX60viyi+7jsK35C5KXa6K4hktEVX
	iMOqPFzM+nEy/L+epKsE8B9XQ/5fOffw66BfqUQEvXN4YvlywwsuficHa+2WKTXnd5TqL3mT5mKtV
	+tdwDCAUbR8KJ1Gd7i/flhb1qvyv1NeielP4naekfJ1Inewrcigqg8s4qjK7BJ25kK6KNmpCg319C
	D6FKTjZw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNFDa-000000018qi-2vA8;
	Wed, 13 May 2026 19:26:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 026183007A4; Wed, 13 May 2026 21:26:05 +0200 (CEST)
Date: Wed, 13 May 2026 21:26:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/7] locking: contended_release tracepoint
 instrumentation
Message-ID: <20260513192605.GA2545104@noisy.programming.kicks-ass.net>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D4652C0003
X-Stat-Signature: t6ucjwyyxnb3qn7fp8i9nob3uw9igmoc
X-HE-Tag: 1778700376-654171
X-HE-Meta: U2FsdGVkX1/bvSRKoqk6+e/+G79z/pKAbustoWMKec/gY1s6poZuDL/r74WUgYrotDlfOe1IVOn4VOMAc6jEH92Ue1+AhhqQT7h5zQlueRR64En5BdLXBQoBSryAmDktPj8npwYnnJ2ikbleY59Tk3swJ1EW9efP6K5pYqAkW4QF0Ntfl+l76NJ50OCn5hCmzXYvqUEkAdmPmFCQivtO3Q35835PBVqeLlRRuNohUwTwNqMR4SSUtxvGIeze2eFK6Jd1P4y9LAc3ilWGeqLZqfa+pBBjfm1fzxYssJnsOj/yfqkZYZvckbyDEJPStBgxpXmq0ENUQSBspsG0cmRapV2t5hRl8kttQBci77srP2cM+RkHwSgkIlgQQqZDYEaTs3t57Z2jHGNQEuFfoEnra6eO1f/C/X2agSb0ud51swIaHpKbe4TBvswSDl8ZQgSkd5OMOdmTleCGR88i5IWNEeyNRErdWiNG0gx7m+64TU2gFhz2YG8h+7GW8hpsidXt45AsS7ljfRQYMDBAdTxLo7aKLQmyhaIcxIzur4JBYIAUvrWbPg0mJ6zWdq/u0w/M1mi+v3i4hF0LxYvYK5PiLst9F7zZmGtErCL+H0h/I0phYNcUCLb0Er1wxlgzS5goUCg9TOw9KyPxIFXy0Qk5DgjYMcnX5vFcRNDaRuwiykBsTmNMkTKr1nH496W7HVugDVGlp8efcRXWgWvSBDfROfIW5tPIVty4MOTF6B5erd0Gt78Gqqa+9tIxYkQpnugpae3+9c1K2fwlaCiB7n7rqn6t7jBCk3rni0Zr3+vnjtjaBfzKAI1D24nfOva2HAh1foOApLNOVf+3yYIZUg03YHWw8ZczyVRg0tiT9e8plwba39sGyiY03Ay4FirQwE/CFRusy9j7iJJlUdPR9kEy+PMlS3UCZAcI7bdCDyRv5NviDthvKY8pC1h5oQqV54hIKP2cZct/0ecdv2GQLgO
 E48nyOGU
 q9xd6ldH9qQNwEuGgxSCYWNrJ1v2nF7kH/2sU8Ue06EOlXf1sCVJEbY9cV3uAZdnIM1MhRi6/SoWJ0DQhWfdRAqpYpF9yWvn7ss6zkVu0U1EXbUVo9bZzBedbyD51H7BJ9EcqDVlmhX+33Y4R8C1LxJ6CcxF8bJvWjGqgXJiJXaRsVRHLt1lYRdye+HDhjPA8QjY5uf6epF13Fch9yKBq4dh1C6hOUPxBl8xvAJo1sVMEWQECHJokYMwUYFzNWz/B4biNqwZaRhqbtz/w3NcCucoLAbHKI69YGEN8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 05:09:29PM +0000, Dmitry Ilvokhin wrote:

> This series adds a contended_release tracepoint that fires on the
> holder side when a lock with waiters is released. This provides:
> 
> - Hold time estimation: when the holder's own acquisition was
>   contended, its contention_end (acquisition) and contended_release
>   can be correlated to measure how long the lock was held under
>   contention.
> 
> - The holder's stack at release time, which may differ from what perf lock
>   contention --lock-owner captures if the holder does significant work between
>   the waiter's arrival and the unlock.
> 
> Note: for reader/writer locks, the tracepoint fires for every reader
> releasing while a writer is waiting, not only for the last reader.

And for qspinlock.

I am really not sure this is worth the overhead for qspinlock / rwlock.

