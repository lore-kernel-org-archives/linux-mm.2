Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E770EEC142E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBB46B010C; Tue,  3 Mar 2026 06:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EAD6B0110; Tue,  3 Mar 2026 06:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A51D6B0112; Tue,  3 Mar 2026 06:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 394766B010C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:08:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEE021B723A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:08:14 +0000 (UTC)
X-FDA: 84504477708.28.C7B2374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8324C20013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:08:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi97jkDc;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIt4ITi+By4AbKL/dIBaDVHvVVQ+lcrikGYk06XOcrA=;
	b=iKyU5oVvAp8QBeB6wfao33YmGbcofxly+zWj6Nh8QwAZqfWjRGhG4xWhWjVsJ9Cw/Xgnun
	ZDa0nb2e2g2mmYRjP6ckvYKPC3Rc8Qb1nkgfPEbC40LS98vL2Yr55WsrzQlp+uIeJZIMbo
	fZDcG0/pUui0imSBKJ8Et/G0J+QreTg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi97jkDc;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772536093; a=rsa-sha256;
	cv=none;
	b=z5cVLd3gxCSe7kS4hMpsJ0YJZ+otl6XvW+rRwyb9EfZV1p/OTZ0rlp3n5/lEnLV496Ono0
	Tm6pYSk7id+EsIlhCO8pFD0AjU+mYsaUwUu1FgV6NAVJreUVEqzgvZuP1xj5NjVqlzahbL
	BpqfMWS7t5bhzaedp75mh+VxvtoBIhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DAA9F60123;
	Tue,  3 Mar 2026 11:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F5C116C6;
	Tue,  3 Mar 2026 11:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772536092;
	bh=Pg+bxff6RLm2vjCjXAjEClO/zTnaUHcveVBLVQYUn1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pi97jkDcT/ZjH3j1UUJ6X1W7VKCwQsInCbpeBFP2WSVyZpLzXJu8QPzcM+MpXLHaP
	 v5fS7YCVHzOkRmsCOTvuoXmGSPdwd3i7T6x9y8gY1ZZEe7GFJ0w4TFdDGSPW2IFV0O
	 Rl7Ox3oKMYqpsUiSjnHzKLW80EIJLqCnlDmaidVAx9ChJ9HN8OizgUIjCoqB6JFQjw
	 9wBJDinzGnXWndQrjDIPTncYKV9DPeK2E/9jBboaAV2+942cFv7Vb5JkoLtFKJUHFK
	 b9HlDor/+weZnR5MYZV+X3vw19vXWqNARlzTRdKwKemmjkEwoDKfcf9zbEO4CUb1c7
	 LlzlaYyt5bL8A==
Date: Tue, 3 Mar 2026 12:08:09 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aabBGcuhVaFVwtus@pavilion.home>
References: <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZzM_44L1vKzcOCy@pavilion.home>
 <aZ3ejedS7nE5mnva@tpad>
 <aZ9ugjKvb4U7_R93@pavilion.home>
 <aaAxVbt/DQyTgIs3@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaAxVbt/DQyTgIs3@tpad>
X-Rspamd-Queue-Id: 8324C20013
X-Stat-Signature: d4bkba4uidifi7464middtmufr4muieq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772536093-46407
X-HE-Meta: U2FsdGVkX18q2xBdoGW0XbFYMtO8GGX5SdckHi+Sj+lVnXh8H7C5qejPj/JXyg6H/n/so42vIAnNPCoJIlAH/UWHT0sOfiL9jI7rFldPO4rPGYCd92SrnNJbbQHLNKM142DW56mXxHqvxB7uy1Uj/6uAHBqrwfMAiIwyrU4rqd3x2d8dd4v6yMgdPRudnTrRqCDtMSdeLgEJEcb4YQ7y3osm74jY2QS5O9vaqfQw7XAS328e6SiXQuoh3C3xyZyUkmIRCHOB0QTOlOJoiPE3g8KZmVborZ4ItnT7S0/BeaP5HdEqK3wlDPu7VCeVXGf/XqGJ8es1qxo+Sp0Fdsu0/VZrOLzKiLnotj1yiy9EqEaZJdX0ZxDlXZPvyi10o8fvObav0tY6PlsOaRSQwG5BMr/gDtYMMKJQcIq0c8CF7cTLKLzAFSyz0cwiKHzCcHBFw2YHby0eVTCwczbHS0UUdcgV5ZYP37csLKEeKp/ZjpPBf4+LCZBAL6FNZyouIGpoeKtURGt2DNahCw7E06jZhqADA2Dr35RR7jGdect2Dt08rSIEwyjfGnPZjepCMgML7URP6OP1ohJX4d2kpivsF+JvKvDEHaP+4EXYg8WwHUpiXnnBWbWzv2JuNlb8heoPWbhiJmSAFrLCgYkm8q/CjxeHHQQRfJfaz3Cuxo7RiY9WQ3bjviSLja/grVRLXxEWWwhfcIDybX+Rpc5oVGYNSOEjuKFOWHgeWc5xj1FmI2yfI1nuhaHcYzLz94XaHTOVUeyMrMBEgyy0mkyibZoLFHZg3A00GBbQNHL88SDhWdve3cxGSZB+5WXM6oAW9wKnBGTikIBQdxCnBBdYTL/uU0kloiknqg6Qw5KDCYniSgHVU5bFQZOGA8zP74aSseoE1ZOZkMi6Oqlafff/xI/bGh6RT4jngVX1p1DLrmGA90XAFZtu1yCuyqoS9JSwfQfnUZfDbZ0ZahGCidcSaZ+
 kMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Feb 26, 2026 at 08:41:09AM -0300, Marcelo Tosatti a écrit :
> On Wed, Feb 25, 2026 at 10:49:54PM +0100, Frederic Weisbecker wrote:
> 
> <snip>
> 
> > > There are specific parts of a simulation that are intensive, but
> > > researchers try to minimize them:
> > > 
> > > I/O Operations: Writing "checkpoints" or large trajectory files to disk
> > > (using write()). This is why high-end HPC systems use Asynchronous I/O
> > > or dedicated I/O nodes—to keep the compute cores from getting bogged
> > > down in system calls.
> > > 
> > > Memory Allocation: Constantly calling malloc/free involves the brk or
> > > mmap system calls. Optimized simulation tools pre-allocate all the
> > > memory they need at startup to avoid this.
> > 
> > Ok. I asked a similar question and got this (you made me use an LLM for the
> > first time btw, I held out for 4 years... I'm sure I can wait 4 more years until
> > the next usage :o)
> 
> You should use it more often, it can save a significant amount of time
> :-)

I fear the earth doesn't have the resources to serve daily use of LLM to us
all. Meanwhile it was a pleasant surprise to see it in action and answer questions
I had to myself for a long while. And I might use it again on the rare occasions
where a simple search engine request doesn't do the job.

> > ### 2. The "Slow Path" (System Calls / Syscalls)
> > 
> > Passing through the kernel (a syscall) is necessary in certain situations, but it is "expensive" because it forces a **context switch**, which flushes CPU caches.
> > 
> > * **Initialization:** During startup (`MPI_Init`), many syscalls are used to create sockets, map shared memory (`mmap`), and configure network interfaces.
> > * **Standard TCP/IP:** If you are not using a high-performance network (RDMA) but simple Ethernet instead, MPI must call `send()` and `recv()`, which are syscalls. The Linux kernel then takes over to manage the TCP/IP stack.
> > * **Sleep Mode (Blocking):** If an MPI process waits for a message for too long, it may decide to "go to sleep" to yield the CPU to another task via syscalls like `futex()` or `poll()`.
> > 
> > **In summary:** MPI synchronization aims to be **100% User-Space** (via memory polling) to avoid syscall latency. It is precisely because MPI tries to bypass the kernel that we use `nohz_full`: we are asking the kernel not to even "knock on the CPU's door" with its clock interruptions.
> 
> Of course, there is a cost to system calls. However, considering
> "low latency applications must necessarily remain in userspace,
> therefore lets optimize only for that case" is limiting IMHO.
> 
> Should avoid interruptions whenever possible, for isolated CPUs
> (in userspace _and_ kernelspace).

Very low latency requirements really should bend toward full userspace.
But you're right that isolation (even full with nohz_full) should probably
not be limited to that. HPC shows such a usecase where the workload is not
perfectly isolated and yet nohz_full brings improvements.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

