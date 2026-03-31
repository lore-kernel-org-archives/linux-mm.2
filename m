Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD15AFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559386B008C; Tue, 31 Mar 2026 05:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5307A6B0095; Tue, 31 Mar 2026 05:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446806B0096; Tue, 31 Mar 2026 05:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3320E6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:31:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4036BBD73
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:31:51 +0000 (UTC)
X-FDA: 84605841222.09.B7D08B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECBDC1C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:31:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLNqIU+H;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oB80UKRd6mgxruEr1Zu34FFI9gz25XbWFLxRNX/V4kM=;
	b=ydPLfnaP2FlEfMuqc+Vm5PIqQja/hl5IyAf27TxZVVodkxzfOhTH3Wy1Dz1kVjg/uvgNIU
	GvxQJLphFKS3qak91MrGp3BYSU2WnLr1oM/oqUFMB5v367CoeWQ6hukKxnv3y8gI62S2/C
	xmPLUYUSFeyvS0MhpfWRNz/j3GD3Els=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949509; a=rsa-sha256;
	cv=none;
	b=YRVkN2UghEKyqWwrPF2BjKr1ptirMZIs/7N9hTyT2aIwZrn8ueYjcaAtPZemzR3/BOmS9c
	+0adKjJ3kE8E+897+ruWIHKDa4PgtKQdfC+WSb/xLUtYnnRI+gEj4iy42cDkxjpva6FzqZ
	GzxkDROGwISGmhaTw+xilO/j2ZnNmOg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLNqIU+H;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CB266001A;
	Tue, 31 Mar 2026 09:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D8BC19423;
	Tue, 31 Mar 2026 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949508;
	bh=xEbwMXX5FwDKtE4Hwy0RcLBu0twcGDuQxIoulpWwrMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SLNqIU+HPX8HQGGsvhZ7yjZ3n5e7cXBnyU5LZXR45P/nOrHty29WbPCPqBGHGvOj4
	 31sHfS+yn+fQ0AkoIPif4J7sSmfXJCSovvEUhbkINEOe09L2zp8dx5xU3NPM+Iv8o9
	 e2mCohSVbds6ALcAGxRx7WZ8wpzpJ8M1JPk13QIEEqVIdf7aZq32lgtLd6wcLW7Q+X
	 R8MjFeZYpeGKhsMEt/r0HFSys4a/bVDdVJ2/SANVKbw8rbPt6hQ+468+gJzUWTEyza
	 3QuL3tsJ887pp5C40kONZ+bEPzKYbDf4KvzI8JSTFC53TUdwFBiCBAjAponfTiddVf
	 S9n8DUw1RK4sw==
Date: Tue, 31 Mar 2026 11:31:46 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 01/15] sched/isolation: Support dynamic allocation for
 housekeeping masks
Message-ID: <acuUgmG-Makv9mp6@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-1-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-1-919cca23cadf@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: se1gh6ued6357uiusnyqzjn4ofyhmkxy
X-Rspamd-Queue-Id: ECBDC1C0002
X-Rspam-User: 
X-HE-Tag: 1774949509-553408
X-HE-Meta: U2FsdGVkX18ML8EarCk4ahfgJqrok7IQTpbzVkjAY9u2Gf4FLSOamS+WDTdqT2I+Gn7bgV8vyX3Z5R9pzYG64BmcIUQ+IsR+TnUUx4yFvOBC9O18YfwZIvhJy2dn7oiiWFZAYCExS1ofyyaBvAiB/c3oRKgR7utwZHrDPcCO9vqo8C44URgO+SSksFeuOPQvK92NifSba40gzNsjyt4kMGPNDg+A4ZdOu9MEgG1wpzV8f47BUsLQ5r1TtgKXAZurRKI7xZkZp0ocXriDW4EK20dxRFU8p5esFgyUgr6CMlMhSeqUWDoqm8LyaHirtn/GyNG3dvgDYylLyWETW+rf3aB5RnOM/xQLyI9ttqgZCshYBe1AqOYBS2B3+28gms1CP2X0AK7jOJ6ADZzvxum00kwOj66MPdx8crph44BN1OjWFlG0yxsMTPnuN34rDqrQqg/ZYoWfq/OW+DLc4oCAAQ09sbI+8RmKgoJdXT0xXJ/QnnWC6KBfEY4ZELcepKhG8i9rlbj4jCebrOM+nko7lK2AdYacpy4bpvYP6+1Y6uZLvjm6I7WWPvUBZeQJ6fUZIryD9OJccROVrat5nmIznkmsBJHntsPmYwkSW8cdQC9VxNQoxNdhtiiGeSG/G8OwUUIKGoxys7B/bCK1id/8g94nWG0lTqfJqoqkqPaZ7uYMtJD5pRURwnLek9t/j3Mb4cPls4VtyzC30HtJpnybhYeBtwwNJLOT9zmLSxH/0iwLAcMSMsnLTN3VqdPBRGnX0GfKFG86ey8wRnE0vyAoZq/NBQ32/qx23duOI8/BLBF5f6f1Vtpd3aD4pinsq5IqB9WiWSh8y+rerRQ+ywrCHZvUz6tXjpmQoobp9j7nipkSQRRHABmFzUYSFmYhRqB9lpBVpPwUsEkjUfn8u94LGvGeWKtl44j8GUinWxikpL3bQQbR5jpp97TebeypZdxo8zg9UCKKf2ktlApGAJQ
 a0Gp5q9M
 CZAqnnt68ix1hpaIllngeXvsY/xVWpJXVzmM647VurdRMZYzyJ0KJPOjLRHNrPzlqEFMcsjosvPfM65/bVUKr4/bd5H1n+WhNsPtia0NW9AZ4ycnaywyuhyoIbmjC6ZbZ5J5+j4lGhUJEzqCxDdHJtKMjvlAk4i/lR+54LeULk6K8V+5dkL4q/fVTnz4vh8j6+WKD6bbwI2XFSigAG0ziJNnEu1x+dCBz+bG9WibzGUK6BrueidO8XXFTD52gaky+HrHPcl/Mh/YkE//LB/fKwO91BqPbkIPRN8gqw8HTQmHTjWutFCNeGaWnQpwLSKOj9OfLTx+KdF4jkRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Le Wed, Mar 25, 2026 at 05:09:32PM +0800, Qiliang Yuan a écrit :
> The existing housekeeping infrastructure uses a single static cpumask
> for all isolation types. This prevents independent runtime
> reconfiguration of different services (like RCU vs. timers).
> 
> Introduce dynamic allocation for housekeeping masks to support DHEI.
> 
> This allows subsequent patches to manage service-specific masks
> independently at runtime.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Have a look at housekeeping_update(), it should provide the basis
for what you want. But I think Waiman is already working on making
nohz_full dynamically configurable.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

