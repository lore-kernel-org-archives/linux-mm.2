Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B39C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3948A6B0088; Thu, 24 Sep 2026 03:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C796B008A; Thu, 24 Sep 2026 03:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282276B008C; Thu, 24 Sep 2026 03:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC2086B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:36:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49B251A0229
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:10 +0000 (UTC)
X-FDA: 85247847300.02.346B6F5
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7437180006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1b9WN7Ta;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cGA4BclgCv1i/IvFkHJAXUEs0wfbHqkLQowiIIB8YsE=;
	b=PNGsl0C3QboVg/X/mUKQn8yVPRCzCXZlTuNgbKRfvnNyuhgpmAxZQ+luYtG6/n5OKc7LB7
	14YhRcsm5jeTSxNjgx+tIpf3o1E8byem75Fkm+xva86wGNLt08J+elnbALGYvYim20ERUI
	OpHJRiiXGRx/Tu30wwXpWLlLnlzLkr8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1b9WN7Ta;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235368;
	b=TT7GOt+XU1XOFvHHMgQ1eeYLuH/mbf015I4ko9Otu7Y39BwUNI0CZpygDMPWcS0Ov2jBJ8
	Wq3wYQM66jgY150a2fe3Qv+cdREfCcBjh6bQxA0TP+1MydNYSXNm1ThT6ypoh/7VGB0TxJ
	IOSCmmAbiSKLLzQ0CAd11qGmwckqlOE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cGA4BclgCv1i/IvFkHJAXUEs0wfbHqkLQowiIIB8YsE=;
	b=1b9WN7Tap6vm0/csUpWLxjCK7jZxPzWlkenA5HYWoo3km5g/8gjhEqjXwv+SHF04NYGTP481a
	1JBpT4tNmWxq7DOZen+2Y19oOUGWD+Jxse3VRq3FeRbeyMMJ+c5d8gY1rGi1Ej4CguGiJH+W35b
	iVtkDC08d4gSlIk7gP3TR7E=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hr5181gbNznTVk;
	Thu, 24 Sep 2026 15:23:56 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B42340578;
	Thu, 24 Sep 2026 15:36:00 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:35:57 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg upfront
Date: Thu, 24 Sep 2026 16:02:14 +0800
Message-ID: <20260924080219.1036588-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)
X-Stat-Signature: 4d1d6sig3msj37yx9h4ebapqo3sdswuh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7437180006
X-HE-Tag: 1790235366-165665
X-HE-Meta: U2FsdGVkX18FIXBEZO1nCMyDw9M5VlR99WeBRGHtOTDebaGvyIm/lU7tjjKu8gY0w5pPXQoBMR7uTTuDktD1/Q8ygehQA329DhDmnLcUFlviWW6+DY2oXtCRDVwv6Mx7+6SkLvGfCZowzrswhfIK40/IswkVZYUXJpNjCJx49IxX5NifV11hp3NiqmpsOE8+rfwaUfP6vqKSW+jEbvGFp2vMmR1aOsyPNBEez9wdHB7CYO2uqgijwdBinDuM87Aq4VzZqEMV+oPGFL1VABdpenjWKCvtBk0xpp361lYBkuQISXM1DlGpFGLy6DFAyhvCC8Hby+B0fG6Shl8HYQbpvPoG/+JdlUe/8BdbWIjDCwdas0AYkKrQ9JY6L5U3RVgF4HTZasCeY1QyJPET1jJdaXQqE6nyPBVKe/+r2T/21bDO70KrZ6m1WTQ0NpzUQ350gv+rwPcC0P2HUCLRitm4FG5LUfGSPGrXZ5TMsufCHj3LHcOaKIntIHVTHwLkV4BHzsCfYI7jCterPS5VWG/aMGkJpU+xDd42nRW4FFj+pmiWJPanLvhyPjPubyMTBa2pNWBMFzWZkDw6YvvrPOE2FbwKkoakQgvq88wyDcEhkj6FV9uppoTDGTDvcp+RI4p4hjzQIVhLPZ9o+BFVniOeEmbxjiA+4XfNvQ7h5Iy8JbRZAMyhwr0YMazUj/u0BvQPo89BQnalRNNoG9QzkXb+kuSmdG2D7HXeJg+KyH58DB5EbeqExaftdnEOCW7GjDh7AM75oNvOmgIpCa0RvQGcfECP6MztwnHhhZLGcZ73uyx/1bVxJGgxTSkh67YFYwzPurT90B2FFJfI72OGsLeBgVW9CcDfEEJdFoJbuGuiO/pWhfsmQaYRBJlfwAwofWkpVNlOmwQtx2NeRG7etLdG4lSvwvwSIo9AOimtjF1292EmWEef7Kd/lI71I9SrExU4ko4ajHJRFTJWeRm4h5X
 7xR4hye+
 G/nGYj/qj7GF7YFW7pinXzWnJyWiplKg4+oZFpOSeM+L1diXm1hjn+QTvZJX5GViS2XGsnrF+FISoXomErTf8gF78dc7zlPa9l4BXrRAFzu6LK9ZcVsoiLK4dKojrbJH744tdaU4WqmUNfC+ot0N89p3rPU27CZq667vgIONJdteuDhK5GKrvv3NJijuMp7NpSS8L/j+wy7heZrb6DWdEQyZCOPsk7y8/WtzrNp1AQkBTkfBdhQD8h3PgEf914zsOuB8tC0VhhvXyLFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg socket accounting currently charges pages to the memory
cgroup per grant (__sk_mem_schedule() publishing forward allocation)
and refunds them later from skb destructors.  The refund side folds
per-skb "was this charged" snapshots back into the socket balance
under concurrent lockless RMW, and races there can drive the memcg
socket balance negative, ending with:

    page_counter underflow
    WARNING: ... mm/page_counter.c ... page_counter_cancel()

This series flips the model: a socket is charged its whole memory
budget (sk_sndbuf + sk_rcvbuf + sk_reserved_mem) to its memcg when the
budget is established or grows, and refunded when the budget shrinks
or the socket dies.  Grants and per-skb charge/uncharge stop touching
the memcg entirely, so the racy refund pairing has no code left to go
wrong: refunds can never exceed charges and the balance cannot
underflow by construction.

Beyond removing the racy pairing, charging the budget is the more
accurate accounting: once the budget is established the memory is
effectively allocated to that socket - the protocol fills the buffers
on demand and no other socket in the cgroup can spend that capacity.
The "sock" counter therefore reports memory the sockets already own
rather than memory that happens to be in flight at the sampling
instant, the same model vm_committed_as uses for claimed address
space and hugetlb uses for reservations (charged at creation, not at
first touch).  The visible consequence is that an idle socket holds
its full budget charged for its lifetime.  Global protocol accounting
(memory_allocated, tcp_mem pressure) is untouched.

Patch overview:

  1/5 net: charge socket memory budget to memcg upfront
     Core tracker (sk_memcg_budget), lifecycle charge points, memcg
     removal from the grant path, lazy shrink sync in sk_mem_reclaim().

  2/5 tcp: sync memcg budget on protocol buffer updates
     tcp_init_sock(), tcp_set_rcvlowat() and the four autotune/pressure
     buffer writes in tcp_input.c.

  3/5 mptcp: sync memcg budget and drop backlog page compensation
     MPTCP budget writes, memcg inheritance transfer, and removal of
     the now double-charging backlog_unaccounted compensation.

  4/5 Docs/admin-guide/cgroup-v2: document upfront socket budget
charging

  5/5 selftests/cgroup: compare socket memory deltas in test_memcg_sock
     Make the test valid under both the old and the new model.

Tested: full arm64 build with 0 warnings; each intermediate state
compiles (bisectable); tools/testing/selftests/cgroup builds clean.
Runtime validation on the workload that used to trigger the underflow
is pending.

Cai Xinchen (5):
  net: charge socket memory budget to memcg upfront
  tcp: sync memcg budget on protocol buffer updates
  mptcp: sync memcg budget and drop backlog page compensation
  Docs/admin-guide/cgroup-v2: document upfront socket budget charging
  selftests/cgroup: compare socket memory deltas in test_memcg_sock

 Documentation/admin-guide/cgroup-v2.rst       |   6 +-
 include/net/sock.h                            |  21 ++
 net/core/sock.c                               | 237 ++++++++++++++----
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_input.c                          |  10 +-
 net/mptcp/protocol.c                          |  42 +---
 net/mptcp/protocol.h                          |   2 +-
 net/mptcp/sockopt.c                           |   3 +
 net/mptcp/subflow.c                           |   5 +
 .../selftests/cgroup/test_memcontrol.c        |  18 +-
 10 files changed, 261 insertions(+), 94 deletions(-)

-- 
2.18.0.huawei.25


