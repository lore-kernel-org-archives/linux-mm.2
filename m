Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0867CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DF16B008A; Thu,  1 Oct 2026 14:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5636B008C; Thu,  1 Oct 2026 14:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133AC6B0093; Thu,  1 Oct 2026 14:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E08676B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:59:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70CB1C050F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:59:40 +0000 (UTC)
X-FDA: 85274971320.25.D9200D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4B33180004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:59:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqmkmC+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790881178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbqpPhdVg+JjB04z8Xrp7o2CiVP31iN8OSuqPExIta4=;
	b=B24vNMRn2TzuTvNjal7VW4t59t7eNyRDggIhEVRfDoEPf3psdMIibxpCT5RUV344jxZRGM
	s5gozvnEa2igeNuS+ClrKmvl0CV1IZ8C5Ayln4TVM3gif1mTrVGAAk3tRvGmth6VA8fAOi
	wcu1FnVFsAnA7Jyp5bxfBQKYxpLb9vQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqmkmC+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790881178;
	b=oACGU1JW69W1wPhgEVrJCdtmgD99TSeM3M6T30f4J6JrgnpgBlud0DDbfwVQTviCIpLNrx
	gkshe1/sP9fuDygnTMXzvb4pUY1cyG+r9yGE5nwqDJk1YIgoshPMby1TTNhT+50COKWs2f
	UDP1dpA4vTO8nEH3/bQIZVmfByb7nfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 949C64094F;
	Thu,  1 Oct 2026 18:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547CB1F000FF;
	Thu,  1 Oct 2026 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790881177;
	bh=dbqpPhdVg+JjB04z8Xrp7o2CiVP31iN8OSuqPExIta4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OqmkmC+Ba6BnMRAC8P/rjHkzAwaaowPo5wlSsyTYeNoXx77Gdgz1fAznYvNzNJCr3
	 fdxcp+352A26HkH9iW5RwIUvEzNH555zBtM5tkW35ULQWFKqz+nfvl6Pg+7QUocZbz
	 IXz1Hv+KmDuEgeLFHh39ze2SZ9daSCUthTAEWRbGTYjIvHaxYPhylfXkXu5bs+eT4W
	 Rrub4xGtfhMMTgb4RbUi5JnmTEQKpY+U2pOXEdne0addK0xQVq6NpQ8ErLdOzmSFKj
	 tnP2H8TKpVMuCDOltGWIZFWu4/pPc6PtFUhr4hTAAZCCKC5UxR8mRkn64waBdzs7r8
	 DF4bfCPwjmANw==
Date: Thu, 01 Oct 2026 08:59:36 -1000
Message-ID: <4a8e64483eae4a8b7524650c7d54453f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 David Dai <david.dai@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>,
 Frederic Weisbecker <frederic@kernel.org>,
 Aaron Lu <ziqianlu@bytedance.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Hao Lee <haolee.swjtu@gmail.com>,
 kernel-team@meta.com,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8arf8mnic4hwznbm5mqws4ncmtsz1q7s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4B33180004
X-HE-Tag: 1790881178-100738
X-HE-Meta: U2FsdGVkX1+M9gmxwFEvmw272XTbSjyup6fLUT+SpU03z4MleyCxXhFcsTqzk9ZpwVhNTIDIE9QpNF9EyCekVpLCvlOOWjmrmoxMBF1ymEwWDsJ/DRLyZsisHnOryT5uB/HZs5UsZ0DscrBtN6IpogC8QQ9j7ydOSRmPGG2he+Kly6CijnPok048Wy1f6Tpka7mUftRDWiDWd0051sQ5AmtSupMsTVpDeVikwgZCPk1nDEJHWI2uw7S9rFBONBPTWC4lvPJNdrOPAIzdI5IGIiNEG5yjNYf2ZhGy81O8yQstXoPzg9kSUK38uZzCzKv+WURuVkYxravqYsH3peggS949M3+eWACHbHRaQTpKS0NoJbHCbNF68XPKz6vd1obIUiTR4jraymmcN16cdRCW8suwfmcMMCccGzLRTWSAE8hB9cPHrUiZ2cQGfbnMXeLB9nO+6v5OT5ls2DGHuZU+GFD+GXqxiiVGCQ8xjk960wx4JRydFMF2GMCwQDUUfuO5oQ2b0s1onBVouwo7LSw8Jklgv+1FXvBRKo91XmGVnHBv5ZikaBLDcBW3oP+M6ulTFkoegBxn73KBVIP7CR+DJRmSgetT8djDq39t9QcRWSagUK7x3pbN6S8AarUg2Z4I1/R2jH13IbnBKM9RbSWEnskgK981JBdfWJ2Uru+XXWPtQc44BknhqjB1HQtO8VcnrDzbCuO98a0RmjW6Qs19W6OC49RIYh8S95nt1oQQmM91I/9llIiPmNn+akQQVbwfxD+Sn2OT1FCNBWABvcIcvxo7mI5IUsWoa9RqXZa9tMU1YjU31OMKUrk7YYPPwaJSCisbtLI6LsYaDRmhlg75HNMgd30Gx9xnvaraGJ/Rm0NKqndBuWBOxqLCfsl0vJ8DKQtXEYb+zOdYkjlCEUQbjxVWDRhzMksItnYlp6U4eI7qCLhNeCvuDHeTfzk/pvf7U3yYzGp7VtM99q1J8di
 Xgf/JMSF
 m3eDcQTEKmDSrfFLj7dcEsGoFx0l1AG/NRBtMaPdVxhUORIr8BEKD7G851Q2C7ZR0lhvq9nBWnxArWY+CG22q1kqlK750btY6UYl1m78IgOS3rEsKOly/wacq5uIrQBoaLSQRliTnRBqt9Y/mTg5KGhTKy/x+xtAjrzJR/UkOZ6XO1/G7yc2T1L2dKS/ZeX2LZfe0CuDj4ECI8Ap8tw4pTfyz+Yh5D7+AbREwctpc0fIwWAMDmo+LAfV2HmHfXcOnJKiIbty6+8KTEG1hOf/hIw3kPKLfQaE36eMpt4kWhQ2TC48ZXUPwsP2xZLHDrW7sngLVtBpDdXDRLBNCCKWjqv/lwZ7yIUcB7T5s9lDnYVRmw7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Peter.

On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> Ideally RX would be split for each network queue, rather than lumped
> into the one giant softirq that nobody owns.

Rx can be split per queue but the granularity doesn't match. There can be
way more cgroups than the hardware can split queues for.

> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.

If rx processing slows down, the rx traffic slows down with it. We'd
likely still want to allot some minimum amount of time to non-rx work
while making sure the debt doesn't spiral out of control. If a dedicated
kthread were handling rx for the cgroup, rx would be sharing CPU time with
the rest of the cgroup without choking it completely. The back charging
can follow the same corollary.

> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Same limit here. There are setups with a lot more cgroups than CPUs.

Thanks.

--
tejun

