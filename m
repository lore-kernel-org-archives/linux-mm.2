Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBF4CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA0C6B008C; Tue, 29 Sep 2026 14:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2776B0092; Tue, 29 Sep 2026 14:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA4E6B0093; Tue, 29 Sep 2026 14:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC87C6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:50:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 528B1805B7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:50:21 +0000 (UTC)
X-FDA: 85267690242.27.0198DF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AB66510000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:50:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AKL/NQJo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790707819;
	b=AIEJibx3XtCb2R4T79Ie5EiUqC46yOfqvTGS1IVnvCg2zy9TV5/KH/lcLCO2sDByZynU3n
	0WTnr1FK3YbYOpmasTrZiyPqAwxFLz86FOqhK60RzQKBJBHA2dgTyaawY5hgXRpnJojQWO
	NXdH0RtKb4dQFfc+lFyEgQpjCEiN8W8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AKL/NQJo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790707819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0j9ZYPE0kpuxcGqfOeJqb1F8DjbAgg+aDr2TDXJr2k=;
	b=CYuI+aCvfgScsLzNGFTiXHKNSko+QEkr8hOOeJHqa1nxJceVGWRRgaki8PFrE/kNDqcIll
	BC/lSFFGlM4iPim+98Lw5stkxb5hDhyQpga24XuPfgkyaN7T0/BiAk3u2sV8/tn8cwTzdL
	lCgN+H4oHfwJEmfmE4TFUA9P9F6wzaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA7F040252;
	Tue, 29 Sep 2026 18:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C211F000FF;
	Tue, 29 Sep 2026 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790707818;
	bh=a0j9ZYPE0kpuxcGqfOeJqb1F8DjbAgg+aDr2TDXJr2k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AKL/NQJoQyB/VbLk21OaTs+Mad4FePYdN1yez5LipKrQ8ppXndkJ5NvSAie+kvhQ7
	 Yqyl0+b/kdqogNgUALIq95bXiZ9mFnXgC+4UviSh6lZef0lMj6jNLORKe9IN31zuNT
	 Vu8/t9RdpxSVVjF9Al3+GYkpLpqdUtRfCxKhcz0Wriu/JQRqpMn8u5EoboVp/bfF4C
	 cAB0XC1Pnny4KkDArsPRqCbt9dFO62WiZa9rNGDOdAyit5ChZkRHAy8b14ZbocdFUt
	 CA+EzLSqc4y19uaW8WZ9YTKy0iq3H/SVKVhdX4xUFyS1KmdYw5GkoFZzzmgjoSkYbO
	 7CDUOnBLTgKsA==
From: Thomas Gleixner <tglx@kernel.org>
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Waiman Long <longman@redhat.com>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, "Paul E. McKenney" <paulmck@kernel.org>, Frederic
 Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>, Kees Cook
 <kees@kernel.org>, Joel Granados <joel.granados@kernel.org>, Anna-Maria
 Behnsen <anna-maria@linutronix.de>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Mike Rapoport <rppt@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowangio@gmail.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
 netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 rcu@vger.kernel.org, virtualization@lists.linux.dev,
 linux-rt-devel@lists.linux.dev, llvm@lists.linux.dev, Yury Norov
 <yury.norov@gmail.com>
Subject: Re: [PATCH 12/17] timers: assert static storage for DEFINE_TIMER()
In-Reply-To: <20260915031334.1194975-7-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915031334.1194975-7-ynorov@nvidia.com>
Date: Tue, 29 Sep 2026 20:50:15 +0200
Message-ID: <87o6dfj3iw.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: hyjtd8tbn1z9ic8pma4cmnucrzir5khs
X-Rspam-User: 
X-Rspamd-Queue-Id: AB66510000C
X-HE-Tag: 1790707819-57281
X-HE-Meta: U2FsdGVkX19z4MVbyz0nzpbJ1EFEYuy4QV1WgcHbfIXKgOAI+SqhIm72JFP2o5jfF/qXEnQ/SiFRus9ZASMVuF25+B4gUhHcUwV2WBkgP3OOLAncqMv0eOGWGTbIsp/Oawa30mCNB3XoizQUp7emUSsL33/GC1N1gqZf77E7CtM3GH7Ii+x2SRpMi4J+fvstjCIhFK8CT+EngIsP2hnVdZuJD8C9SmQI47nHYqxjnyhv2gTphd0SzAdmUpZfl8rp8G8pDcB0bZMFY/axrkUCN8sVfeuNHvlrJzFrpV3H4iz+qvxtn76GsFvEStRgxYtFfOSvmqWmaUbj8Fy58zV9r48+72unv2SKF71RINczjs4tYHnQ84SO8UuZ9x7OQ0EGlfzZy3laPI8H/kMhjWr2zPaaYfZfOHf6nhdkPiF9KxGwWUhtC9AagXPj3odmcnTHUSto8RiJjpI6uqrPgZqIlFsu08o3EsUTVLpfjx0Z5zGaTLnG5+s0jElNzVFvNFfDmU89a/7qeZ0WErkMeiN8PHg5gIKrkfb9GE00OMxI9R8tquVHgFjODdxlFwX3IGE/dATa0gmU/x57v3X7nIIXOybolvJ57jUT0KMw1NKul/gK5HAfkb9aHI3HJcODTq44uViTyUU0R5MZZNdXltsh49KpcPywFB/lFG7nPdQ0Rrw9Nj56qGmQ1u5V6fji+8C5S6wkugLZk3J4Ty7p4WCE+9BxYP2KSz2EMxoC/9iAp2vT04KkxNMY3BNr8bIz9PUdH57YJ+IbNFaA6qYC164WQnPEQx9f30SyotxqwHVqsVsOLwF/LAwJzNHhfurR4+DeUFVccLaCL5mUXGfVCd44lYU2M4+vDhIb8G2Ho3O2yIbbfnPgaXb5zX4BjzF9vB4Widobr69dtGNm1wxr455r7C0liqTilftThgYyRSk9z7ZU/WYiw7vJFUbEhNK0ljN4fSmtVAlWYis6YZ1BSzH
 cZF/QFhL
 n7du3YkLwuldDozljEKkriMJ8zk+7cFlO4jkVKjxaPSZkyK+DfS0ZydTyIV6gnwpXYYOUg8zOysOkbDjfoX3GjjI4HEqCciGQPckScPBOzvAUaBpMG5t4Xz4GBv6viRnqSZPCmKzlvF4cFIccvoTNWHpjfAaaNZRljxKSuuuD5HoduvTiCZmDdfdNBU5OcNBPHIVI9Mp1XYRWX+G5kFTxeeuoHFLmk0ktKUXQhpbqcp6rT9dYK962Vf0RZCLrLfmBtQAQPw5+kC+14AK3fha2lQE5znupgynTHmY5cJ35I1WajHDwudYMgMEk4JHNACWnu6Ix0DkeZjmesbYyv4/3zSFRINepGaGDfnUjEwMB2DhtpIpP/BN4b+cfLDXiQbb0x8WK38eAYCUzLWsoFJs2zxbVZrntvxkwAfDFOXxq0JAitzSZ8hqQPInGMoaM8V6lt6iM/BK6iW7QgdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14 2026 at 23:13, Yury Norov wrote:
> DEFINE_TIMER() marks a timer as statically initialized for debugobjects.
> An automatic local timer instead needs timer_setup_on_stack() and the
> corresponding on-stack destruction before leaving scope.
>
> Add ASSERT_STATIC_STORAGE() to catch automatic declarations at compile
> time. The timer lockdep key is already static; this check enforces the
> debugobjects storage contract. Leave __TIMER_INITIALIZER() unchanged.
>
> Assisted-by: OpenAI Codex
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Reviewed-by: Thomas Gleixner <tglx@kernel.org>

