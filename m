Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C12C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F6D6B00C6; Tue,  1 Sep 2026 06:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616136B00C7; Tue,  1 Sep 2026 06:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CC06B00C8; Tue,  1 Sep 2026 06:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 313246B00C6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:21:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90DB580212
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:21:42 +0000 (UTC)
X-FDA: 85164802044.11.C0F2248
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id B5C56100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:21:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Azliz5Ri;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788258101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpdeMGfd8b+o9KqD26nR/EnRAqCD0c+UXHsElmYi9Kc=;
	b=Kk7qjUgL4pvmoYyNPoEPVTyVS4iYHIEtTQklKDopIBBpThMFP4brdKD+NTkxDgeCYyT0lP
	LUcs7OGV01q/A3ZoZrrUe7FpH0IMCq2xc07UGksC5HRrOhulr3xtApyZjNC81bBYmsElx8
	IutpWwwEadgpxRkBNlxViRcoSlTraRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788258101;
	b=KCiS1ipYsqSMr6p+dgisTsPq9v0rzvqSugndVI0o62RJHrO6yVfipF6y44qP7oLfTLsz28
	CU3zlX7HaBVxe59f9ZJVkeINb+0IWvVCHbjXrbCIKLA1/I5NAhSx8QbrVsLcJ1Nn4qlE7G
	Gf0m/MQ21kg/cmUsbvrvd9PM1NKu8+o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Azliz5Ri;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UpdeMGfd8b+o9KqD26nR/EnRAqCD0c+UXHsElmYi9Kc=; b=Azliz5RiKxMn72G8mt17665AVO
	zpTiqmOt8IT5ymxcithw/Mwjj9BlR2HWjn8pQRKcEhUXXzisvVwjFAee68KPIbURnUoSG9pqHaXYu
	RSyC39k+6+phOvdvtrEaEX1FK/ActlGwfx4gNkHoUHQk1OvOUYMNxLqSzqLnq5fY9fobKWhQRhljF
	oDgWJwXLqP+RwVVIyUBycWtpmjRfNhC4a4rtC1CUunjVuG+EWWtvjYOpJznbP2sUTtyPYWEUlLU6v
	lyx3xSNM56wD7kd5Za0FfI8gOabLrTSk6Kt3APAupcTzZq72c6e24hX9srKWrQ7Vg3vVXnc2ywQE9
	tPYQMj8Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1LcP-0000000AqjP-1FAU;
	Tue, 01 Sep 2026 10:21:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9339D300578; Tue, 01 Sep 2026 12:21:27 +0200 (CEST)
Date: Tue, 1 Sep 2026 12:21:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jianyong.wu@outlook.com" <jianyong.wu@outlook.com>,
	Yuan Zhong <zhongyuan@hygon.cn>, Huangsj <huangsj@hygon.cn>,
	Fengyu Wang <wangfengyu@hygon.cn>,
	Zhiwei Ying <yingzhiwei@hygon.cn>,
	"justin.he@arm.com" <justin.he@arm.com>
Subject: Re: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks
 NUMA preferred counter
Message-ID: <20260901102127.GY687043@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
 <20260831132414.GN4120091@noisy.programming.kicks-ass.net>
 <8eb55be5c1e9497c9f34f15436b9d665@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eb55be5c1e9497c9f34f15436b9d665@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5C56100004
X-Stat-Signature: 8kmn8pft3hhw6ieqfbe479o4rjffwqqk
X-HE-Tag: 1788258100-177274
X-HE-Meta: U2FsdGVkX1/a907/x4638mZ7TKdb78rehll5vHIbFea0ypXRIWCUc7Gw3p24agsdleTqgJ20qbPlq/wMoSCSob6W5B9K8JEV1NvewzNTo6rxe7+s/+k3jQ9EEJ7H5Td008M0njRtJgyzm9jC7w4/Bpg6KgEVlBnke1sL6MD6MqVz9ePstMsNkCmx9SxBYdEeKXMu4GJrUdO7kg5+EaJOU/X6zuMzA0JvHw51JV6/NeI0HwLUFIztFYO1U7JE/Db02cKnyhaGA4yc17d3dEiE5LDl2Z1GBfHfhoRv02dITBRZvKpp+X9KSDZJRIEgzZZSW78yv2Ak9Y5u2WHTYrOUdkLmzxK5cSqT76FgroFky9bpQt9DwW4l/7H6xbR8vDw5ANg677wyzLy0zGTWoJvsjsHzN5UexiZ+ZBXPLsBg5YSDAJSZpF93wSol07fYpr+S4xb9Ns4BVzlYt0gjhRnknpCYhetnTQ2kunmyxqeI3yndiuOr3mrJmfLYnby6Mu4csyzNQVC3n5Xuy5QVDYNSFOCWVqya/gDyII7hxGmgIDqcJoXwJsgZSDL1/08j2nOsDif5kYY915FFTuPJ/WdArUaVOrzGLaJkX5oynUDJnm+937Dcl3hh5Dzv8Jr/dP4P3RUBRU7x0fvGV2e53vJWObj7zx9MMo8Ny4uRXOnMssTitnW4MHP6b1eYz7Ab/qHXQMGqzgER0j+ksIM2O68uY/ssKROQZdu9l5+jU+RbXHoSR1oe87DeOdTxoGPF4DxmnC/IzbPpPmaWfT0eqNAu1WyONy/PFQn52Tq0CLdA6lIU46TRQWzwYhlfoA4GfinFkTzZGszQWswfTl8yWeR6ZyCuq+icyO2cCBrv6NGXJNycqCipfkPtxtU2FesB/UEB0NqC01JVQWH0TqjHqSIavyuB1SQEiSKHN+7PXX/sB7+GluleAOcZdtNx7Nzoa4RmpckO0mTEoPeTNm24dBq
 WeZiZ8nw
 2YPtQZUBZjwnWgkj8IpsvpyF6tfG5HyXEIOQesdYWP7HVJzvOhRpPPQAfviHpga28ymHyX+xbsYloiAxK0zD6vO9RPL7HPeHYlKE1hQ6NYoIxqjIS5LwB6EKjSG3is2gg6VdomU+VofUW/e/Gd2UmqtvDLmFsLybCWp10/JIcwm1Dl+dh050gOh3WB1HDwh6TgbwltAPOguzM79I2dLHa60AiFyBCSerX03wN4iYGL6mTwUHpn3aDWBGi5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 08:31:35AM +0000, Jianyong Wu wrote:

> > On Thu, Aug 27, 2026 at 08:28:01PM +0800, Jianyong Wu wrote:
> > > Like the existed task LLC preferred counter, sd->llc_counts, introduce
> > > sd->numa_counts to denotes the task number that prefer each NUMA node in
> > > a certain rq.
> > >
> > 
> > To what purpose? Is not the node occupancy the direct sum of its
> > constituent llc occupancy?
> 
> numa_counts is used by the affinity score in patch 12. It holds, for each
> NUMA node, the number of tasks on this rq whose preferred LLC falls in
> that node.
> 
> You're right that numerically it equals the per-node sum of llc_counts.
> The reason to keep it is granularity: NUMA-level load balance scores at
> node granularity (numa_counts[node] * distance_delta), while NODE-level
> balancing scores at LLC granularity (llc_counts[llc] * ...). Maintaining
> the node aggregate costs only a single llc_to_node() lookup (an O(1)
> array read) plus one increment in enqueue/dequeue, whereas recomputing
> the per-node sum would have to walk every LLC of a node each time the
> NUMA-level score is evaluated.

Consider the trade-off. Adding the accounting adds a cache-miss to every
enqueue/dequeue, while re-computing the value on-demand adds some little
cost to the balancing (slow) path.

If the llc_counts[] array is dense in node order, then it is likely all
relevant numbers are in a single line and computing the sum is in fact
fairly cheap.

