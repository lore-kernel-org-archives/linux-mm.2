Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12917CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F58C8E00C8; Tue, 14 Oct 2025 16:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCEE8E0090; Tue, 14 Oct 2025 16:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E28E8E00C8; Tue, 14 Oct 2025 16:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC068E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:33:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D44C6140AEB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:33:03 +0000 (UTC)
X-FDA: 83997869046.30.1C6A69B
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id D7CD480002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:33:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l8rkUGSB;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760473982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwSCDIXETHGxMb4XVhxx+vCGIG2/jXfEf6gnZuLgFYM=;
	b=FRz+5gR8zwkaOARvoofGChXAk5YOI2tyJHzTDhMh+YjlM1oaPjsShnMnyqo9KIk965vWCX
	3fB+zLSso+6U/fSfhzZKTanJkiA6Tdmws9qbo8rmwe5JpEJLEXhgJEC6Ir+bjlk0DGee7A
	GPrQI8dHAHz4YEIhOoYACtSsvLTsKlo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l8rkUGSB;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760473982; a=rsa-sha256;
	cv=none;
	b=EmDcPxpBQ5eiIV2RmDK3hDILuQNuGV2feAr3x+e3gcmZoaK1m1s+IyoPfqMecWC4+0W2no
	MpQYJEflxYqEEJ9F8dFXwHZlfbFlCEMRKt1UtgZW8q3cD2Ro3dPB8GOEs5FxUTaKYq5Sin
	saGLWIOPWvOwWSETXQxtZkAnmzdxHzM=
Date: Tue, 14 Oct 2025 13:32:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760473979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwSCDIXETHGxMb4XVhxx+vCGIG2/jXfEf6gnZuLgFYM=;
	b=l8rkUGSBKEErpxxVuhjASwkfNV0le9MZVTgo0/omQyPwbZWoxaOHRfDsXonsm2OiEnPEVz
	W5vMr040iTYoxIiuHH9PuZwFY8z9h94Ft3umWPAWbd4NJ7FVCaq4rGQ6ORDABsdwVb5eaP
	QJR9wYJ8cy/x7gXJhRCQJSVURJFVwsc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev>
 <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
 <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev>
 <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D7CD480002
X-Stat-Signature: 8xkx3cc1n3iwqi1kpi9p6fqt5nubp1ky
X-Rspam-User: 
X-HE-Tag: 1760473981-886792
X-HE-Meta: U2FsdGVkX180vU2zdL1fMZWtRz2DTyYiVbapITH48W74P3IcuugMOdIai3EymEUQ2JmR/XHwRHqu+WUVCA/PtZHzk1Dfi9+LZER49sj5Pa3o5N6GvT19CJ7Jg0Dql0xHtDU1v074noqQsQe/3M/E6cwmWkIDbpvKMFCBPEdiyxW3AHLIb2mqd88AO2OgxGZJHL/iXojQxEyJAW0Uaok778UzeV9D9wh5AmqlB2ykl8Uku8Wn/1dCYrcNeDSejR312dfelHaw2SUiRL3uMksYTEuzZjE5nvyOXCTmFQEoSZMeMLJ/H42u3ebpHAmcQ43e6kwiPYC72k52JUJWFtFqMEc9NklejstL0nHL1bec720neyGFeYZnX7/w0U1NX3Ooj0CLPuUNyUlbvVDDgGBmN3N/bqcvihznKtjS3BeZsl3sqVZ4enYMo8BeRQ8Kc8y10mcAqC8rCim6pTfNqpdtzsA3aiWeHtXNy/+G53TczN9dr8VkBzxziCA+/EymqL6AFARC2eQS+0dwXKO+g+oR6lLqjWxVeAPbO+DpvFzawKW+Qseh1jvAPtK8M8y4d1buZHHPadjM4Igf3fPAflvdFVIM9A4QLkEYgY8p0EQLhEmYRNa/UiVd2iXT1HOCK9Y2stkCowSywJ0E/KgGvol94zr+oIoI1Z9cQ7Z4YVFwQGpdrSbE8SSo2bRb8EkM1XPtSVghHV3DzfYTrCG4ykIIbajbwVdSBcMAwhdIME0f2BJwyJm7LltQcPP7b9yBJFC/Jkwgp8jt8lsRI+gLPQPzNJ5/Mvw0fmoPVeIA261FnVEFK4KNVflYtVf7poP+mb9qubOeWej/9DgPDaqOd9xDR1Jod+5ERfoYxAzUb50+HDbpmMcNZEdr5k8DGpgKbuhJztoLdRnFPV+mSU/Ui4Lavp12L1NlnqcHnIgQK6AhHk657TBhTDzueXn986dy4/dFtnRu5/4v9J2WhiBpDe9
 7j7A3a3O
 MlaZ0dUmsRwYQPKgQOeOy6QY4iQR3X05JB1b+tv9Jqm/yr0l2yNj//QgQ6ihLMY0XI+sbeEObm5ZjRHoKnRoBKuDV5nGtjxVRdF6AoNzctitBiALmixz7aZtq4MtLy+BjVzwKppY/fxoLDMqSp2F7OF6/Z/LcEPS+SlP1l5gocq2Q89M97pTeTDF85NqLQ4BoYgdi3GAUYXNW81A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
[...]
> > > > > How about we track the actions taken by the callers of
> > > > > mem_cgroup_sk_under_memory_pressure()? Basically if network stack
> > > > > reduces the buffer size or whatever the other actions it may take when
> > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
> > > > > is what I think is needed here, at least for the debugging use-case.
> 
> I am not against it, but I feel that conveying those tracked actions (or how
> to represent them) to the user will be much harder. Are there already
> existing APIs to push this information to the user?
> 

I discussed with Wei Wang and she suggested we should start tracking the
calls to tcp_adjust_rcv_ssthresh() first. So, something like the
following. I would like feedback frm networking folks as well:


From 54bd2bf6681c1c694295646532f2a62a205ee41a Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Tue, 14 Oct 2025 13:27:36 -0700
Subject: [PATCH] memcg: track network throttling due to memcg memory pressure

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol.c            | 2 ++
 net/ipv4/tcp_input.c       | 5 ++++-
 net/ipv4/tcp_output.c      | 8 ++++++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 873e510d6f8d..5fe254813123 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -52,6 +52,7 @@ enum memcg_memory_event {
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
+	MEMCG_SOCK_THROTTLED,
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..9207bba34e2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4463,6 +4463,8 @@ static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
 	seq_printf(m, "oom_group_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
+	seq_printf(m, "sock_throttled %lu\n",
+		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 31ea5af49f2d..2206968fb505 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -713,6 +713,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 		 * Adjust rcv_ssthresh according to reserved mem
 		 */
 		tcp_adjust_rcv_ssthresh(sk);
+		memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
 	}
 }
 
@@ -5764,8 +5765,10 @@ static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
 
 	if (!tcp_can_ingest(sk, in_skb))
 		tcp_clamp_window(sk);
-	else if (tcp_under_memory_pressure(sk))
+	else if (tcp_under_memory_pressure(sk)) {
 		tcp_adjust_rcv_ssthresh(sk);
+		memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
+	}
 
 	if (tcp_can_ingest(sk, in_skb))
 		return 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bb3576ac0ad7..8fe8d973d7ac 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3275,8 +3275,10 @@ u32 __tcp_select_window(struct sock *sk)
 	if (free_space < (full_space >> 1)) {
 		icsk->icsk_ack.quick = 0;
 
-		if (tcp_under_memory_pressure(sk))
+		if (tcp_under_memory_pressure(sk)) {
 			tcp_adjust_rcv_ssthresh(sk);
+			memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
+		}
 
 		/* free_space might become our new window, make sure we don't
 		 * increase it due to wscale.
@@ -3334,8 +3336,10 @@ u32 __tcp_select_window(struct sock *sk)
 	if (free_space < (full_space >> 1)) {
 		icsk->icsk_ack.quick = 0;
 
-		if (tcp_under_memory_pressure(sk))
+		if (tcp_under_memory_pressure(sk)) {
 			tcp_adjust_rcv_ssthresh(sk);
+			memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
+		}
 
 		/* if free space is too low, return a zero window */
 		if (free_space < (allowed_space >> 4) || free_space < mss ||
-- 
2.47.3


