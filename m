Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4FDCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7909001B3; Thu, 14 Aug 2025 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37842900172; Thu, 14 Aug 2025 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290119001B3; Thu, 14 Aug 2025 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18740900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:31:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5751117C98
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:31:51 +0000 (UTC)
X-FDA: 83776055622.05.F845916
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA90D140009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:31:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YPw7uzxK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755192710; a=rsa-sha256;
	cv=none;
	b=tFHOXFvpQZ6U2OWioyttBqHcL0wGD6d9kWe9B75vmVzlRy20QDpXQ1pKD4h+bLKvpuV0SJ
	TnXzuLbEv5qj8aFK2Pe2iHoflILEAERnxZ60cDZPVbkGhfn2rgcPFFeNQgSTA4l0BTjPKO
	4tKnVvWNdLJyV3mGxnc+jymVciz/Dfk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YPw7uzxK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755192710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh0ycP22zg5SwNs/Sb7kUvxkXVrYAjgQSgUwJWJ2qBI=;
	b=LJsE5E81xH86Boe9dm0lae/5XRCySv/4nNODP9uzGYh2qQEmOs0mGqBaxGYt12LfST+CCE
	PyrSa1MCNKauCZ5Zb6mR1hE9tB9uB9pWSxKCSM7Qoqh2qno7dT/++Cl7IH07xvRNwB2ycx
	guFwNeu2qY7VK3iUgEtHr6EFAAW0/VE=
Date: Thu, 14 Aug 2025 10:31:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755192706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kh0ycP22zg5SwNs/Sb7kUvxkXVrYAjgQSgUwJWJ2qBI=;
	b=YPw7uzxKbUm4M5AjV2Aa4v0RZDZyekL6TSoj+zSl53Zsqa8t/9IKw9FyIDkO9POAeEh6xp
	DsjMM5khXrgGQu9clFlekVh2UEcM99xFCt2tIlEIvvTzbcX76SYf+PiRi5dWrtkiwYLrmi
	wP2vR4ldS2BSSzjgsV14Buoq8kyryFo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matyas Hurtik <matyas.hurtik@cdn77.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <okedwjaepuw2b55eki6zyn6l3ngstmml2amoebyvc4orzsxqjs@45tbzonckct5>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
 <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
 <qsncixzj7s7jd7f3l2erjjs7cx3fanmlbkh4auaapsvon45rx3@62o2nqwrb43e>
 <4937aca8-8ebb-47d5-986f-7bb27ddbdaba@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4937aca8-8ebb-47d5-986f-7bb27ddbdaba@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BA90D140009
X-Stat-Signature: d8j7d8g4u5zn4xt1hy7cg4ssckjoqrnq
X-HE-Tag: 1755192709-536980
X-HE-Meta: U2FsdGVkX19cbKnkcGnQiPnokj2/bQpA97RWkJUdNWpifZj2VzuLCCIjEwt4x5o+IGpYWkBQolo9uodJtHnEzIk6xNKwk7rZ6c94oRjH6acMKo6htnjNkjTfZQT99ykqDRVIkInOSpT0OcbbEgl0CjkkiCy72WDISrX3qx2uorVFv5NZtJmsii7wIoclv/URC0EK2bYKm6OEV/29XhmARSQJy3d/O8mggUZX1CSsqTjVpKG+8H3PIAAUBo1pXzrbXOuy+fD7KuoKA+UQUtr6YN6vc9xwu3v42QLYNWl3vHw7GxqjbV4soDx/lW2UwHg6GhbbL8Ckbklg+8a0t3x6MtpMEfduNuYDagOor4RnB9Z6MZL0TW8agRO1Uw2USuwxLdcvQyq076jhJPUCsznoD3vHmlgF7gydRp6ZXyqYtgGu1AWVF00/oWfCwqpFDRaENYoERCXJ95kHgIVItGv6hL+zPfnWv37y4cvE3l6PiY5NMdn8HLVRU9lw0xkahhJh7Dpv6KmhLhJnwd2blwteTmGerbobsNHIqKJ4lWBCiH5RUcbxGkmxfQnJSkyQKrk0VGtIxIaVfnrjBT4ipttkJjRld51nrRMk2vVq0GiOCL5YKfAdpHH6wbeatmiGrhLqI8H9BZT6F7oSJLL/aeaRhGZIlR90F7gfvNi08B9D4SOX8V4CC/g8dRj5CfhIJbRYQo8ftYaw+eduNwplFKRYhOtdd6+gJenrcy+QrNms23d77t6Nv036aTFXppoevj8S+6d63p02G86/tzqARqPcv7F4PaNfYR6kRJ4nCk8j71mk4FyGgbmlgQ9dwCQKbgkXarvb/8Z6gKd9IJQVTq9X4qxzTf/oGuq6Hk7BsncT7b3RPXK1Rr8mgTUF2kgzcALN8vkHaIhXCJN9p+hyVyfMrXUtkJVgQH8snetlGV5G6izwWWHKdMYQBrMpMSGKxxn/R3qYzdC69zlhC7ODpfb
 dFU5upFa
 Q4IOiuT1lRFzSJYCPll8MbG+ee1awwcs/D/y73FCYwk2OZV1okbcXiaJ9yPiBbarzeyeAB6LoNjcwQ4V8n7OBDZCS3Y/H7G0dRppYLWyRXE2FhV7ACmVl0lOnMvvLIu9nK7HJtXqYrVfHCPVoisIjoqqVTHArq0vmLQlOgFfx5SP66o4cXgTk/gq1BP7PA+QgPWQiB23lW7XLmJcO1/pCPbbPb936GsKt90+Z6o+6LI9GOd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 06:27:22PM +0200, Matyas Hurtik wrote:
> On 8/7/25 10:52 PM, Shakeel Butt wrote:
> 
> > We definitely don't need a global lock. For memcg->net_pressure_lock, we
> > need to be very clear why we need this lock. Basically we are doing RMW
> > on memcg->socket_pressure and we want known 'consistently' how much
> > further we are pushing memcg->socket_pressure. In other words the
> > consistent value of diff. The lock is one way to get that consistent
> > diff. We can also play some atomic ops trick to get the consistent value
> > without lock but I don't think that complexity is worth it.
> 
> Hello,
> 
> 
> I tried implementing the second option, making the diff consistent using
> atomics.
> Would something like this work?
> 
> if (level > VMPRESSURE_LOW) {
>   unsigned long new_socket_pressure;
>   unsigned long old_socket_pressure;
>   unsigned long duration_to_add;
>   /*
>     * Let the socket buffer allocator know that
>     * we are having trouble reclaiming LRU pages.
>     *
>     * For hysteresis keep the pressure state
>     * asserted for a second in which subsequent
>     * pressure events can occur.
>     */
>   new_socket_pressure = jiffies + HZ;

Add an if condition here if old_socket_pressure is already equal to
the new_socket_pressure and skip all of the following.

>   old_socket_pressure = atomic_long_xchg(
>     &memcg->socket_pressure, new_socket_pressure);
> 
>   duration_to_add = jiffies_to_usecs(
>     min(new_socket_pressure - old_socket_pressure, HZ));

Here if duration_to_add is zero skip the upwards following traversal.

> 
>   do {
>     atomic_long_add(duration_to_add, &memcg->socket_pressure_duration);
>   } while ((memcg = parent_mem_cgroup(memcg)));
> }
> 
> memcg->socket_pressure would need to be changed into atomic_long_t,
> but we avoid adding the memcg->net_pressure_lock.

Awesome, seems fine to me.

> 
> > We don't need memcg->net_pressure_lock's protection for
> > sk_pressure_duration of the memcg and its ancestors if additions to
> > sk_pressure_duration are atomic.
> 
> With regards to the hierarchical propagation I noticed during testing that
> vmpressure() was sometimes called with memcgs, created for systemd oneshot
> services, that were at that time no longer present in the /sys/fs/cgroup
> tree.
> This then made their parent counters a lot larger than just sum of the
> subtree
> plus value of self. Would this behavior be correct?
> 

That is intentional. You can see couple of other similar monotonically
increasing stats in memory.stat like workkingset refaults and demotes.


