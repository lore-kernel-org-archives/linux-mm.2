Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D535F41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB86C6B0092; Wed, 15 Apr 2026 06:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69966B0093; Wed, 15 Apr 2026 06:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57A96B0095; Wed, 15 Apr 2026 06:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C39D86B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:50:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AC32B8DA5
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:50:08 +0000 (UTC)
X-FDA: 84660470496.30.65B8B05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC43540011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:50:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kxpj4DTv;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776250206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FhEAh2yMY3ZRUW3oRYhtfOc6QKCMV5gEvjNOl2w+lg=;
	b=vtGA+mxUVfs67Yi02/QXmUyEphrOZKDLPziAdyDI3QxnX3f+WojRsLaWHV6h2PozTAJ0Q5
	xWnTOLKzbgkHaBmK5M+k9dLD7OFHxK4MtfxX17dT+mXU0gEQGKoQvDwyfj6iYNsvUqSFRl
	juLTe6PzRcEAk4HDeCe4LfRUgzrS95M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kxpj4DTv;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776250206; a=rsa-sha256;
	cv=none;
	b=N5mH3rMtmmdMpAwgYJkQRhrrxTHYk7gM+yBVelZPfFgDim1OVD/kSWLhhS4XnRhKzZrqc9
	M1PYgFWAg/wpwudqb0BQh1plCaREpvZQtRROrL4beQzcY0RmS/PfbM78h8meUVLJxuiVfq
	L+3sqSBxeexCAw89z2ZBDTCWjQVfjEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6F8A42B25;
	Wed, 15 Apr 2026 10:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D0CC19424;
	Wed, 15 Apr 2026 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776250205;
	bh=7Y9LZV6U1xyrOHwAijlBN1vXwQsWgvG1uZWTDoxA/OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kxpj4DTv/Yk7p5jvwdsLH5oWgEvb10ysaAyxQKmqcTsDbjN7noPDFcF4XY92vYNJb
	 dOBvecYWIYwyaKhU51xhNFbJzDK1/r+r7irvKFZf0QXmrqleaKgjuTdx9MEhpQPWHC
	 a/kBEIAQAcdivAYufyXZYmLM/fymJTb/ieawaY6CT9YD/021Wf0MNWjlUDAJiUu6r8
	 j0zwzpWv45cWJNWchRO6obf4PwTSAA+kyao49lACKA2EfoMqYVDGORFxrazmDTg6Qa
	 NooZUVllQoJyWF1P2kWtY0IE5W9KG6V0laP8BmIxTjn241wOO3SCgCxFMx9RDe2gzP
	 lV1YlUpVXGoGw==
Date: Wed, 15 Apr 2026 12:50:03 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 08/12] workqueue, mm: Support dynamic housekeeping
 mask updates
Message-ID: <ad9tWw-J_t-f6AcB@localhost.localdomain>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-8-06df21caba5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-wujing-dhm-v2-8-06df21caba5d@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BC43540011
X-Stat-Signature: axyw3dtta8t81t6w8dtpprxabgk35uiz
X-Rspamd-Server: rspam06
X-HE-Tag: 1776250206-446849
X-HE-Meta: U2FsdGVkX19XAwbwez5xXsWBGYnOmDsGRWavIyNM7gtUIsQ8E8qnounqiTyy9dANFQeguk/qo+bW2ZHYpXDNiFhX07qkLpXz0qNTT/xilrB3GCBhEqep9oV9MqQcPjygzqDVrat7IhKLwbe6NCIJYi80ztGRqrf0RArjZGFkV5MFRnPilabKfYUoWitZV/NXKrR7vwUvjGTtqLq9zbxvsRU6dnJm0zjijz7MpoNDRLTZG2+e+h7Tn9crPrTxI5WjKCE+hoiaFAIknA+N6IZah12omIiO1o3zwZmL72KRWd2sx9Q6GEHdeA7TZeOuIv3Aen7YpCrdlcPc63grEXYAd4upY5N9B4l/PLuAgH3/8wNs3mh7cmR85Yo+3t0h+k5SvH2ZCxRnNWYjEXFqhHreImhArsTS4EAjsRbQZDu4wdkimotsgnytercQJgHM6630Og8JkEIKTDSwf+io/vH45xw4YWNHgBhwdVISQ8ExBF2ZxKinx1UqwKaY+lLRJb7QEWpvlqC/1ykGPrOmYMe+VqYtkiD6GJcZORD1Ijt0KtXhKCG6g08kaoolC14Za3EfEu5ZIYTHVhIU2m0PnWRxt6PBeHIYE6Pqol1L5HXOEJG32ecwYxsVL6coTgpvmJ0FVDHOUl1m2bJMqXLdBU3IUskFJGo8p4D3pSiB2TeFx70iCI8QrW1DyhvLNe1wuR1aEY7BwcIaXhcy9lNQOQ8cyVNz2yTrQbaNG14pSly8UuEjVOonA1HhgvND5w1n1X9sgQZOVpFzYygMFcwIVlM6wvUT45KLTjKCjMumonxnUPbXylFxOALw7MebGoOdbkzr4o6A4/PaS0FTyTUqrFA1M9woYatNS4xWHmAFFWUSY1sXKkjtXeHntmx5hMHhh2ccrf8YSLpvjTVL/2HGVkbSO72G0kV8+vKnVbOzR2JyKWTyVc/rW7yVpcfDfeNF0nMW3vF770GKnCwpwqYUGyK
 Lx3PAkE2
 Of+H8lcPgYeT2CEdc3TD7kQCjEKKZ4+2CQoXY5gXyr/CeuUV4kk4P/VQn6cBForAyUjATvQUlqMzzrqkztg6EOG96v7hwlENqblh7lXYlSTReKz3E2Mqrx21M1UpQ7QpIHzq5RvMiOZUf8F1o9GMRJQxNO+o2Z5FqoZlazyYkYCTVjZHWE+7XKyUxenYmWcZSjpAHVCU+sUYXNs0qRqif1Ih//NYV/2WlBMQGVzeK87qITiCs2WAg796Vz59abXaBJ0+JUt2d0oV5qKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Apr 13, 2026 at 03:43:14PM +0800, Qiliang Yuan a écrit :
> Unbound workqueues and kcompactd threads determine their default CPU
> affinity from housekeeping masks (HK_TYPE_WQ, HK_TYPE_DOMAIN, and
> HK_TYPE_KTHREAD) at boot. Currently, these boundaries are static and
> are not updated if housekeeping is reconfigured at runtime.
> 
> Implement housekeeping notifiers for both workqueue and mm compaction.
> 
> This ensures that unbound workqueue tasks and background compaction
> threads honor dynamic isolation boundaries configured via sysfs or
> cpuset at runtime.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Unbound workqueues and kthreads are already handled by cpuset
isolated partitions.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

