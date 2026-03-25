Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B207B106B538
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286F66B008A; Wed, 25 Mar 2026 09:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2374A6B008C; Wed, 25 Mar 2026 09:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174526B0092; Wed, 25 Mar 2026 09:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 023256B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:59:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6A00160989
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:59:11 +0000 (UTC)
X-FDA: 84584742102.26.7221215
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16B688000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:59:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ux8oIrbz;
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ux8oIrbz;
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447150; a=rsa-sha256;
	cv=none;
	b=4MC42uNo7ySoumGkm4yFRgiK/q3KN6t041YOda9DpvkmPL0vkRPDrhNGNoRzHOP5lyBY2F
	PFR7A5900IgvxIxQzEE2rZauLQMFnPERmV/WoNEpZzF7i3APKZ09lDOcKNAfiwsYXg0vpV
	+HPrjNnd+0PJRGSB2n/tH2O5p0Cqa3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2s+G5suXmI9oLXQ//HZ2D1vtF3Umo6K3pnwzbiOYHI=;
	b=qUSJef4vKC9y8a6kJutyaFfnPdELiSSRJ4sHTcgSxIJ9dlg6Kf8CKIO6j4RQu4pcI8SViJ
	q8UAz2zFLL8mbpsOprrw1K7kr9FGgPSF+reO/q+a9K6sLrh2yh/Q7k3dneVyUc5dDDJzSr
	KU+HHHJOJpOt9+NoCRzM306SfTYeWB4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c2s+G5suXmI9oLXQ//HZ2D1vtF3Umo6K3pnwzbiOYHI=; b=Ux8oIrbzAFZvHaWUOdHG7SKeNa
	bLJRymJg5lIv33LglJg/4K5iVMBZWxJj63x5mjT/d9LcwROFeuw1U7vhxnpmW48sFnUJVZqNlebde
	m9CCdHTKOv1IRWsGDkVhxLGN9+W+Tesas6ihcFWg0wvECmSPu7TsniaiDUXxCBAjmq9T9wAd5h4nP
	vJfaOd0iHc2ZJd8nVSnopiHpGMTpGnrM6257/kp+Y1Kbd5cMNkz6N25u88M9clIcBTLc4kq3vL4gB
	y4lIImLt72V8GA+MD1rxgxxk+qRfiv3ABFaK2t15+SjnO3uY/LIF877ftltBdZlY+Pp6ckke5CnOU
	Z8lNYeTQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5OlE-00000006I3e-3ZDt;
	Wed, 25 Mar 2026 13:59:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 716D8300400; Wed, 25 Mar 2026 14:59:04 +0100 (CET)
Date: Wed, 25 Mar 2026 14:59:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: Re: [PATCH 03/15] sched/isolation: Separate housekeeping types in
 enum hk_type
Message-ID: <20260325135904.GB3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-3-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-3-919cca23cadf@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16B688000E
X-Stat-Signature: mbtkq7kraac816865fysitf9irpn7sca
X-Rspam-User: 
X-HE-Tag: 1774447149-680216
X-HE-Meta: U2FsdGVkX1+tNCFSk4nFWcCUDrCotgbhHCUT9EM4HcJj51AabUzLajxENQzYSxLsAG8FuSvQ8ey4uXo22kxzP5G4cqwJXgZSIJx0M9Ki2r6urUD+7eEHNeTdDijtWAChsFCh7JKufMCB3JGceMi+xGIJ7DqCqnPDVfK12IToACq5003lDa8WccmIrLTyEzLF76JgGiURoI2TnvLTs4pRSf0qw0lDbxOBQY5fY8czgxwmIlq+YqGP385GnS1K0/8H2MTrQmvRUQBXlSTa7H1jF6lhcQl/HLz6tQR5gUz2Uktd5pRoa015kDxEy4+vTkDaWxM1IXJcPXojQKDGafoK5heawf7Q2XdLywLSqvWFkWKTC3NnQfXbJF62bpelbwonGQ6AZkrmN4tNsCNoBlJHa02geunKgaimAVn9497N1CN22/N87VYQ61WoU66pKmv8oguLAKcjZ6/Cbcf7M42MGt3Dk/835bGZUoZNwRg7T84bUFjHAVOBXDpqK8yDcPhxF3DjCVnTRhgPNoC4ggrIFn9MGGZ7McXxHLrTgD0ZZYLP0SN9r+FuIu2VQwYdHExyg2SRqSqn5YORBTlUiVa8peZOK8SmflpTTYt13egJbdPSrgG+5hM5FBPXSzHzP0iu5DcuvlhOcfOGxe8/JnZkGacZYHo3vOOF/Pz+JWzesSrUGYpx+5/MjKMm+Dr/5fIpHhz0b5q5M54glHdlH7oSd2tt4PyJ1piiGddXiNrcuWTb0RdaNyu9vn5QazxNWPJTwQ2Ikkeoq2Az2qUDP+z2hb9zuh4FgcPMel5CFiwCFfbDCO8r4FBxGWfeZG3ZloSGn/gFQydSvFhP9pKF4fLTJGyPps6QWljiQrKYfi+zvvxTjGbm6i/cQvoJ7L4fBb8mXbnOo0VZX+Baq1Ijh+l0WtU23HNzibZ5JS2QhEEfrXbLqe8OujOgdr6hgyj0Tir08ikO7ydjGzHJzNTE0+D
 GN33py+T
 WyLAaB67kUfnmmQtKvh4COl5kULh6Nt6r4jnDLNjMh829L4wMges3V83emHMpnRCv6ogDlu9oQ6yPDVj2satEYZCcfk5L9oH/RcWc5Usv5lzVQ1MQ9S4nYfwHXy4XfZe5XdAbrbnLVn+exKgltRX6s3rBgqGkZkWh17Wi1rHu9h4iuwLxcYiM+xgKXEQcjethXZpVnlVBLzmtMwolc13+FDP3GGj5up2E+hjU4u6qr0Wul8F3Lyr6sZIEvcmdxTBhLX87Opzc/dRuyVzcJHjYkLKdqeV065lfguzTwC5mA2REwPhQSyiIDyKb8cYup0nsqUM6IUEa+muGm0bWFf9ITxZWw4RYwC8wGolNlIrU7905TKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:34PM +0800, Qiliang Yuan wrote:
> Most kernel noise types (TICK, TIMER, RCU, etc.) are currently
> aliased to a single HK_TYPE_KERNEL_NOISE enum value. This prevents
> fine-grained runtime isolation control as all masks are forced to be
> identical.
> 
> Un-alias service-specific housekeeping types in enum hk_type.
> 
> This separation provides the necessary granularity for DHEI subsystems
> to subscribe to and maintain independent affinity masks.

What the hell for?

