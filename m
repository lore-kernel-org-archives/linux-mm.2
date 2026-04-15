Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8B0F4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52F16B0096; Wed, 15 Apr 2026 06:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2AE96B0098; Wed, 15 Apr 2026 06:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968206B0099; Wed, 15 Apr 2026 06:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8893D6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:02:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3528B13A9E2
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:02:51 +0000 (UTC)
X-FDA: 84660351342.13.A87D18E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8BF2F14000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:02:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQhxAiKe;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776247369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3n4iWaSs/X7nhGkPWfWqOpyvbwnwhRA4EfuF7TC5M4=;
	b=GeFO0sZLwVghZ9TM5KmMQsO9oNxHIAKIwGFeGo/+s8lKgL5yicf+iRkGugB9zycjUZYwxy
	QOsUZf0HtmP2+2h0rGK5D/Ttl172ItBgTtdFoHJ+Ik2ez3Y+243BhURNItL1G0nXlzDVsM
	EBCnPpcXniAwtYPT0JlvqyPw2gIlQOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776247369; a=rsa-sha256;
	cv=none;
	b=xUJAs4cOlgPCbNOIBswU72o3kIInn5I/DNd4+y79u8pdHPP/km6cAwablbRNBTijU2zUhJ
	VY9LdKG0MuyjSDHB9ylbz3vyDT6KCn5/NIFTa0n2Kw6Ydb6xokMy61UNohlBsOWBh2yZTY
	JXzKbq22mc8SqweG7jV72A/J00YwNZM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQhxAiKe;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D867C600AD;
	Wed, 15 Apr 2026 10:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ECEC19424;
	Wed, 15 Apr 2026 10:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776247368;
	bh=PiXJdW3kZWWKz5fjJpgKb9m4Wz+/cknIAv+flbdQIuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQhxAiKeGXat7xSllrdQgMuU3NlrY5J4zXg7WbTjtLVim6Pa+EFRh5ab5us4ML0tb
	 YB6BVgh5tuDWN+LUkb9oK6q+8zti+kGwuWOROVuxvpib5nOIJ47auNzzZK9vvOJeYK
	 iLfjRw7PwWfxmE6JpftYw8riHE5Gp1jIAQKtFWQlMvDvxfPL7FTNZGFQDOS23p4Y66
	 c45Y/UE6uE1WWgq2oWcsxXBgEbThqAE9D3xfvpPJ12JKymhYypKk4jcuDt5TWKYOOv
	 TtA0pFuBoSlaORK0YghptTx42cO1k6TPIF7P3/+ZMviNa2UfliakbM+aV29yJ98xyG
	 /NWLvUBGTJRCQ==
Date: Wed, 15 Apr 2026 12:02:46 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Chen Ridong <chenridong@huaweicloud.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 01/12] sched/isolation: Separate housekeeping types in
 enum hk_type
Message-ID: <ad9iRi7xrX89nbFV@localhost.localdomain>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-1-06df21caba5d@gmail.com>
 <fd77bca8-bee8-4997-a11a-932a1693edf7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd77bca8-bee8-4997-a11a-932a1693edf7@redhat.com>
X-Rspamd-Queue-Id: 8BF2F14000E
X-Stat-Signature: as4qs6w4icdu4gg6caad9icckdiwkacq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776247369-642823
X-HE-Meta: U2FsdGVkX19newPtjMXVMZQPCPAeG7sLvNvvYvbDu0aHoGs3oWusfdfzKiZ+HFxLiCU9vhnVzAwoYUhr5eSiLHdZW0s9vyJNY0m/HBO56JWqIeJLBDxsKsR01qqOh2hWXnqHwcdoZ04uYuAZfPMei7Lg2gMbSroHvkgsLAimUFRmRj3Wy5yYPM4R/J1w46LkvRof19VrYSWDCDPZKkLsnM74cGr+7+SkITE0rDNThGsje389nqHzf1pKG16f8Ved6r47JMfzzoFCYf1sVRvFasWsmMCqvNuEIBPQnkM84deXHYjQ3kMJBxCaF9Pgnx92k1Ny18kVbSrKeZX5QVUelT+9JqHvOcWHdnHMvbL2NpKT08Waiglsb8NPjdp1iuS3odPOMiM25WWQBsJhOFzgvn9g4XGSByjnNI3OxYvwrumVg6BRg7lgVl2P9rtZvx/XX5gTgWV1wF7RBtmM8KeHug9n7H7M98EAlo1F23j4cStz6eKRmrZdOVNk1F7nZMGBV8LxY4OV6IqYPnWULB0/1PjN+Q490be+IyQo9tZyyChLV9gM6c43ftAuYpUj5LzR7BjZ3tCcLlixK5R6XL8RHHsMZwk2o/4bHidXtGaE8/XVPhR1ae3Ag3rGWdqCjaJMEazF3N1JXhAkiuxX/v1N/amim82Jgh0MxrOqlQ7TxSKLqQHz4Rx27tmVV15m7t4UdOvOafPuupD/PpQsJk5eQmrjYQu55cWqJuKlCB4tPGQa7yYT6oSCP81JoZY9TDkM45ZJ/eCWja0x0H0RD7VEJP2nYV6MFsflobom/R6nP+ryCeptWBDkN4p8ADYqB10XlNp4EaRe4QcEhVSk9NcYl45zYTAK2pFMk0RK8eVdw9HHrIhxwOB1/v2CpTc/p544W64r1+rnBrcmV2dLGUzdAcScOQpYsRte032xw4dw1sRW1QPOuD1RR2GeWuJW29pGYxeyIPEdTskD+tSeJfa
 l9d1o5oL
 zynq1cU2MH6PT8g7XpLDaE2DDDrJVnTTEA7tOBOKnwCXOURxkXyO5W96aSS04NvDOvRT4e2+2raT4yDk+OtHqareVFf9Q3nuHiISSzawmsDBxQXaLnu6Ye+RoHUz1rhDhhssuxWPXxzmUkFGq3IfqqQi2V4HWh9ufZep9JfrZgiOp/fcbjNpVxrH+00qhlWYPIKmXde2qx+NFhcm/3ed9q+ZsQRJqXgJbCXlUupR9g9cleVEGKauRFHpLzaQK5uZ90KhrkHLJsc3A/tYcBwno4IVyo5AGL87kebA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Apr 13, 2026 at 03:25:46PM -0400, Waiman Long a écrit :
> On 4/13/26 3:43 AM, Qiliang Yuan wrote:
> > Most kernel noise types (TICK, TIMER, RCU, etc.) are currently aliased
> > to a single HK_TYPE_KERNEL_NOISE enum value. This prevents fine-grained
> > runtime isolation control as all masks are forced to be identical.
> > 
> > Un-alias service-specific housekeeping types in enum hk_type. This
> > separation provides the necessary granularity for DHM subsystems to
> > subscribe to and maintain independent affinity masks.
> 
> Usually, if we want to run a latency sensitive workload like DPDK, we try to
> minimize all sorts of kernel noises or interference as much as possible. Do
> you have a good use case where it is advantageous to remove some types of
> kernel noises from a given set of CPUs but not the others?

Right what we want to do here is to remove the aliases (HK_TYPE_TIMER,
HK_TYPE_WQ, ...) and rename them to HK_TYPE_KERNEL_NOISE.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

