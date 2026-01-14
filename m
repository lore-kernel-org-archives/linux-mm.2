Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B359D31A1E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6BF6B0088; Wed, 14 Jan 2026 02:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D836B0089; Wed, 14 Jan 2026 02:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ED56B008C; Wed, 14 Jan 2026 02:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82BAD6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:41:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543641A03E2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:12 +0000 (UTC)
X-FDA: 84329773584.20.D266AB5
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92A5E40004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qbtaZJTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768376470; a=rsa-sha256;
	cv=none;
	b=4YalpAlpj32IZ1zxqzvjzRwyUnW0BXVmu5BznhP6/9WkfOR9dACLtPuJCTjokIKRXs6o+d
	zibVuo0c1djUnL5bVVqFh1wNfFy3pgva08J1BI4Kz7rx5jpRtQQNG330CJc3xh8mkHflgg
	rBBKqHbBhXcxHl2cG5saYS1zF8BIhMk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qbtaZJTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768376470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4x1WKLBadjpEQ3Km12q1uw9Rkf2I+GKwMESTXQhTwz0=;
	b=kjvQu7RxnN44Qo1okZIK5q5dKXzei178MHLOmJpiD3PkA/uZHej8Zg/K8LO/ZR6oWC95u3
	K3KbAFjsMPUOVs53pRH7aOlN3YwqwApi5X1CYZniChQh5psiLp7h1J6l9wrX1wqFLzmGcY
	ein806+rduE+T5jOEU1isWbCEwJsBpg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768376467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4x1WKLBadjpEQ3Km12q1uw9Rkf2I+GKwMESTXQhTwz0=;
	b=qbtaZJTR3LvAkz+81bdXF0KphGoGYZa2i+C7bhOLOM2TKPD3oVYRtJr/ZN7/wk5KOnbB86
	envUAFzPxp4pb+C/3cc3zJWfB6a+mLcg7W/zqn+iVK18C84WhLg9s81cbT4FCkTq+azXho
	HGbbIbxafS8U3GD56NMPS1DtHRq8FwM=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org,
	shakeel.butt@linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] mm/vmscan: mitigate spurious kswapd_failures reset and add tracepoints
Date: Wed, 14 Jan 2026 15:40:34 +0800
Message-ID: <20260114074049.229935-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92A5E40004
X-Stat-Signature: p5n6n9pmnr9cnekpgsqpnbizjfo17i7y
X-Rspam-User: 
X-HE-Tag: 1768376470-442059
X-HE-Meta: U2FsdGVkX199P+BXoDjtPgdukoH9x4N8vgkgC4EHd4NDJZDH0Cl+E6gnndBG5d8TkkqtbI/FN5zhZRcPNyp+RZVt8WyaiyK2meejwN7gD1XuBV5yPHQT+iTxrXtUTtm5qKG8bNjIUhcvkZQFrrq/19XaBOw30RoVsBZrdT6zxavNs/ZwScuw8d61A5ZVPtX481Y03Qtc1YjIsVAmZ3r4tDh0vhw0Msi2iglXYsDRfkpn4jxDIkaRb9arYvZ832gBOamnRpAqp23CTB73lgmhJk8lezgxSqH2vb0b2FkkFoFnNZZ0UwSXea2Q9Cv5bgVrBYIBFozHy1GUZC7nNV4FK2ovfvrIP3Yw8Fpmf+cijtCIeklhV7aVpw2OS/Geid4uRnbi5cXJS+fNOei0ZiHX0aYwHFQFwam6qTJhzfyMJuhfX4Mu1aRI0b+VqKj/3s7mU272l1FCfiZq++s8TkOgv0Nt8UCFervV2batV4nFKqm+i0qzGylPS8RXULS0PV7xEJdpssO0xOpPZm3CGVL6Xyge19CXQnC/s5GaHbAqtxsiPxYwN0VUhwkWs1MuG2r8x0xfa1ku9zv+t7Vgo5XL9y4uXHQwKDVPpZHnzVmqqF8SBx/QSX271eRykduJsHlBFnTfedhssIzCri5PrbfuEvdIsIaE6EYwA6E12BXC/wVmpe2igE6IYRSigHYGw6G9YIHEG77YzBQFxqA3LdDwc1SK0+P4lYqGZJRuYSCHvcObvyWzxYWWI5balffVXNH8YOiEA8G9s8byQZYg/8yGISav/beK0uO3CC2p3tC4JszY5eo+mE66gvY2RzKBz8I3g1tRGqjYibZwqM4BIdhk/p5jygrBPxCoYq7fl9k6kU6ZXCF2IHyH+L48WauLO8oRbNWNpazs8A8dCY+2DoYzpKr/h/jUEeYEeThhjMu/kWBZVjQ5kX9G+E9pa3WZKtIBR9uVqfv3qtoaTlVB/h4
 GSK0nybQ
 QLrDlX3E4gnX22HrhZYEJ4p+6qB+k0+AtQhL4rRD1dTZ06A3lozuihl6AyxIRgsDGP4uekYrE/2eQ+rQI5x70EC2FCa8DyKjk3jr8ell4eDaXZhuIB7gSyOgwwtbtzLVVoSMr6GD/iuQoKSfneYWqM5guO3OBvnXbhbw9FsnK3I0Mt81b0R9fihClwbk1pesrIhx0zuDnwBtOcj7603Osj02nulOhCWwFLQJoWWy2G+XEOOLW/oY2wFO+pBDSAvK33fY6vt5RP1uaWdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

== Problem ==

We observed an issue in production on a multi-NUMA system where kswapd
runs endlessly, causing sustained heavy IO READ pressure across the
entire system.

The root cause is that direct reclaim triggered by cgroup memory.high
keeps resetting kswapd_failures to 0, even when the node cannot be
balanced. This prevents kswapd from ever stopping after reaching
MAX_RECLAIM_RETRIES.

```bash
bpftrace -e '
 #include <linux/mmzone.h>
 #include <linux/shrinker.h>
kprobe:balance_pgdat {
	$pgdat = (struct pglist_data *)arg0;
	if ($pgdat->kswapd_failures > 0) {
		printf("[node %d] [%lu] kswapd end, kswapd_failures %d\n",
                       $pgdat->node_id, jiffies, $pgdat->kswapd_failures);
	}
}
tracepoint:vmscan:mm_vmscan_direct_reclaim_end {
	printf("[cpu %d] [%ul] reset kswapd_failures %d \n", cpu, jiffies,
               args.nr_reclaimed)
}
'
```

The trace results showed that when kswapd_failures reaches 15, continuous
direct reclaim keeps resetting it to 0. This was accompanied by a flood of
kswapd_failures log entries, and shortly after, we observed massive
refaults occurring.

== Solution ==

Patch 1 fixes the issue by only resetting kswapd_failures when the node
is actually balanced. This introduces pgdat_try_reset_kswapd_failures()
as a wrapper that checks pgdat_balanced() before resetting.

Patch 2 extends the wrapper to track why kswapd_failures was reset,
adding tracepoints for better observability:
  - mm_vmscan_reset_kswapd_failures: traces each reset with reason
  - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

---
v2 -> v3: https://lore.kernel.org/all/20251226080042.291657-1-jiayuan.chen@linux.dev/
  - Add tracepoints for kswapd_failures reset and reclaim failure
  - Expand commit message with test results

v1 -> v2: https://lore.kernel.org/all/20251222122022.254268-1-jiayuan.chen@linux.dev/

Jiayuan Chen (2):
  mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
  mm/vmscan: add tracepoint and reason for kswapd_failures reset

 include/linux/mmzone.h        |  9 +++++++
 include/trace/events/vmscan.h | 51 +++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |  2 +-
 mm/page_alloc.c               |  2 +-
 mm/vmscan.c                   | 33 ++++++++++++++++++++---
 5 files changed, 91 insertions(+), 6 deletions(-)

-- 
2.43.0


