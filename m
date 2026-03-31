Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0379DFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2E96B0098; Tue, 31 Mar 2026 05:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563486B009E; Tue, 31 Mar 2026 05:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4798A6B009F; Tue, 31 Mar 2026 05:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36D306B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:39:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3BA41A09F4
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:39:35 +0000 (UTC)
X-FDA: 84605860710.26.3544F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 799D92000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:39:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBDGmWNN;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949974; a=rsa-sha256;
	cv=none;
	b=Dk/5MCxfFwnausF6Tur2jNBlc2YV0FBU3aLimy5qK6M4/6whEJ5TRVxXTO8QHW0MwpfDrA
	0GwMZdafBI5TjPEgZo4wW1QwDCceAcv4yAf0kqy1RoAmXReRjeWwIGeCvgAVwRJWW8lGTs
	Co4yDPluh9VT7OURj+oNU9yTe+u+0RI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rN2qV6CkBIHeYUKou63HlhH7nsgLyN5vKrUD/UQv/Q=;
	b=wheDVygaXdu1QiGjxm4Tf13RvY6TV01bIOKRO+cLmidcVUH90KXVIDN3/q2FjEZc1OoIU/
	Kpj1w7okcAqXUi09s5avw/RaFmgzivr0qJf4vJf8OVXnm1taTIAwV188738SX18K+X8lTx
	VYod7TEPDfpfYWYhx7McCNBvGXzGNOk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBDGmWNN;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B59EF60126;
	Tue, 31 Mar 2026 09:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7361C2BCB0;
	Tue, 31 Mar 2026 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949973;
	bh=BLhBqZ3dvy+/k+BE7sIj/+ih1uPmppiKzXtrrL8OQ7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TBDGmWNNI0rjYGNQr3ld25h4CGuuCOPmh6/TFscaT5pT3nTJrNnALBiWYkkG9HhgX
	 Z8D+bRzXWuIiip6lEfhjIcY1UST5helZGtSt+gRnvJnCiYCgdGoqtsVTiJIhb66bcJ
	 dcu6f8xCOjaEcUE+pcU4ACxX4ZxdQbIaKsN5ziHCkNfv8OPcDHvgwv6dRgQifeNXbs
	 Z/ttuv3CfskP69Cr/+WfIcrbVJrbcNU8VV5329ditHYcS92mISwcO0Qqb2Lhgcs+rl
	 NvRGRTJK/3vcqZiXNghn1SR+KWSVodebBTL1Y4C6ZtXaKkaDgDsfpFoIaBqU/1oO3K
	 G126pJ2ggyx3Q==
Date: Tue, 31 Mar 2026 11:39:31 +0200
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
Subject: Re: [PATCH 08/15] workqueue: Support dynamic housekeeping mask
 updates
Message-ID: <acuWU9bMGGE4AMEz@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-8-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-8-919cca23cadf@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 799D92000B
X-Stat-Signature: 5ye3683kz4dno49urb6puohzdbtctnjy
X-HE-Tag: 1774949974-746521
X-HE-Meta: U2FsdGVkX1/0Csidx7FeeZITRCjzilhZHZgjgSvYb2w/YRKcIZ+kjrGzKTEe+jh7TuLZj1CLg3oN/iL8SOYPSnGFU3Un+XpV1Y1Q99/JvPhNdb+XSY5NExoMnwmWEiCLaECq86nQN2cKuGgqE/VoCY9pU1NmHiY6mqlPspBFbK8LdRoOkHQtvU6Q01I9brkeFkTPVgafNee+7Bjwk12vdDM4R5XN86xg7nEXVVPhyWglC0YEkiWWVrSMijSJ3jlitrfoZV8dCsQr1c6uXKQgBDxt/ftF+o4D+KtpUuDC1xRIqnCcI8NwO34jDs7YpRXuM6Rr1cw9V4UyGo42OIqQDBebNT4KZIureR/miMg6ojjGkXKfYhZQNOUnhgIDBXSaE/YrvZcoA78UYBvKZs7VEsC1BQk7K5HZ7HMlSRL1i3m+/h6D7jEt/rxZgsRI/5RKOF0qkjp+ucNEV0qCTkNn83BA5/MJrZSVQQFwhDMwSgjBN8yCXnw88iF6GNN1YNv7o/xSjKg+Mv0NUrYXnWsHClK1B2HmNk9Ufx+v2l5KWhf/rRW168ysZ8Lhi3Gr/vLkiDdazA5+2TkUWBGCCCt2EsJdMQq5+ZHcLmlsaRQnJal2sm0Wl2n+N2Mf0V4j39UgGUVkzIg5zWqAQkw6PjVholx5nJXBy+EQuVttc9pBqMhZYixW9/Nn5qhq1i3HVbeT2Ydij5AdsEx5r29LsfYm63JaoOJuDsMzdHuCfCctRa9OT8EQGS2IuVMyuloaqXAxLC68XzXOJrzv8WiPeAFnshOFwzXj0UB7XNiONp/gJLHQgVgrvwMBjQbaT5M73Plh/mAuHvOODE5ukHaO6DoHBZRF4cmeo8V+q9x/w3q3MpZ6N6T9qCufaPAbMKeBayk96E6Z6p53U2n3TksGNNgCn69Iq3erQOZyiYeq70urkBLfW0ecs8S3EsmdbDOre7soXegF5X22Bl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Mar 25, 2026 at 05:09:39PM +0800, Qiliang Yuan a écrit :
> Unbound workqueues use HK_TYPE_WQ and HK_TYPE_DOMAIN to determine
> their default CPU affinity. These boundaries are currently static and
> only enforced during early boot.
> 
> Implement a housekeeping notifier to update unbound workqueue affinity.
> 
> This enables unbound workqueue tasks to respect dynamic isolation
> boundaries at runtime.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

This is already handled by HK_TYPE_DOMAIN with cgroup v2.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

