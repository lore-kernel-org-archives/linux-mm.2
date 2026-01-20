Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B351D2ECFF
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 02:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29A36B0346; Mon, 19 Jan 2026 21:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6CC6B0348; Mon, 19 Jan 2026 21:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03DD6B0349; Mon, 19 Jan 2026 21:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE8C06B0346
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:44:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72AED1AEC32
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:44:42 +0000 (UTC)
X-FDA: 84350799204.06.DCC727D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A2C21C000F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:44:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUyaBr+Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768877081; a=rsa-sha256;
	cv=none;
	b=WVTY80+Sv95BO1pI0ZATphiDE8GNVDMhusxGDKnbWYnCTSiPC6HLLBTvtGp/dkA/M7vMXK
	lhX7ONWE1wlAiR78EOWV00ILXARHyNBk6wUn6o47IQJMVq4VtudIBlD87hxiRTX5+wa8O4
	skIIcqsqX606sR8RNbGHLqHtQP237FM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUyaBr+Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768877081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K6wbMkRwjKapK5CoBKSnPQTD2eR277R70T25OkML4K4=;
	b=0YLZhRPklOK7jmqbwIknrRFQtOaca5alpmosVD52x51v50ZW+cjLW7xaiP5dNarDnAV1Jx
	zIvnC31hYIABBMx9Yyypker38GPCy2CRaT2uLU5VLbcs2zxEyg/+bpb864B11viF1YswbI
	uznjPbkJk0JUwRX4PSRdTC0s+qWkjuI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768877076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K6wbMkRwjKapK5CoBKSnPQTD2eR277R70T25OkML4K4=;
	b=QUyaBr+Zbc1RpsjkBxPDIQhd9bVXyI/ftOUnCU4cBBZ02m5kSTnVOQXr6Qn2AttbjeE7sY
	Y7Cqo9hS00h++vca6yMk5n/Lh7a8dubUI3CEJmyWwp+PRN01xmw1gaLQ7ugKVeFvpFYnic
	OrK+shqWr2bTuYNdZKk2VPLMslNftQs=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
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
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] mm/vmscan: mitigate spurious kswapd_failures reset and add tracepoints
Date: Tue, 20 Jan 2026 10:43:47 +0800
Message-ID: <20260120024402.387576-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A2C21C000F
X-Stat-Signature: moth4u7srhpmfogfu5hzbtje4wdrd3op
X-Rspam-User: 
X-HE-Tag: 1768877078-787826
X-HE-Meta: U2FsdGVkX19ZefqO/hg5MTeSNv2D7lY4a7I8aXaGLy07lBz7uz2KxkQQiKSJuZW6FptcEZySu678XhNDvmWv9tWkxbkBI6IhGEFPYYudo7NazjIfKA3xnwsDtKaDpU7bVl4kEaRmI7CpFChriZFagMrIUtZWymdSEM7tIgcQuvGkDRlELO4Q4qk5FgKV1R7AifyYdLKt9JiIYBivD1nsDsyRVN8bCFXHWf4obCPNaACXqf/gt2cIKjYXO6qwEF/fvrRHwARDToN9qYNR9jwnHhbns7dlceQj3jPlbNGsOiOmc93JLF/UP3/D2UWZ+Ufl9TKXRjkk6hmShqdym6tbMy265FO7FORuQ4FLaA35mTsO0RPMlFzlhf2RUPO9GZH+BCHqbZKd+e6sxPSHMy3CFRCSNnBcYhmlHlP+gNdKVNxaAe7V7+0p7fFWoTFx/5gkFZEyx9FbWLdsq0PAOsvBWHTJ1/xbHufY8K5wr4ga0EfTpyyPeLPab9CGElcc2OaSRZFKEXb8pK8+SP5gwIt15iizm6Fs8eFV70Gt0TN8s6tSaiO37t8PPSizfKoXXIFy9DTOmZMK2ZIGZ6pCUfLZbj/BM6X9017ytuPEXE5YMdl+3v+Kd8YIohpNCbK7dcLvvWxeruK6fRMdY+AmWvmO0RxT1B52/GR9zVZNTvWwJgHNnsRj/nvXhNlF9dPDzfd7nlaQ2z8UYyWtXCI5ZlhzSTyZVyYQQ1FUZRt6trCcaVgpjzFcJXsegjNtRBQbiCZEJLMYvoK2ExlBecWnXPdckhsgDNxDAZYcXQzNqr6s3uM+YvG+3MZZ0KLLknAW/RH+A/ozuVXIN19e/3SIaDusVvrrQHi+O1m/kBhF0yhRPhT4Ww4f7jjTlBQ2yLT4NaJi3EIX8+m3oP66FfPXPorI21R05z78Zq5I9OCnbgQnJIfwYwMcHq1z2b4C10RgfPynYzgyIEDjaXeN2t/n0N6
 sqhXSqo2
 IxuCeSkzXVEavVUydmWE02jjNL1pGbW2UKDOAdkyDeBGOOEazV41Urf4lsCb/bb85nvFaGYcEJp9ijoUCoFXHzaC5UIgx6ydKJlfVNR37ZbFvPktCz0k7mjgLS8kzLMXLz8AYjSR1u+Uzww3GfDrvjVKl9o1ioDrAkKmrhuCjHqLxc2k8M1Cdf0E43TPwKo0cNYIKhlHhfTNWvDsf0JSy2H6aKLIUB3C4z/+mqNhPEhtO0M4plavCtAF64RngJFNoy6TimCouYTATqLs=
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

v3 -> v4: https://lore.kernel.org/linux-mm/20260114074049.229935-1-jiayuan.chen@linux.dev/
  - Add Acked-by tags
  - Some modifications suggested by Johannes Weiner 
v2 -> v3: https://lore.kernel.org/all/20251226080042.291657-1-jiayuan.chen@linux.dev/
  - Add tracepoints for kswapd_failures reset and reclaim failure
  - Expand commit message with test results

v1 -> v2: https://lore.kernel.org/all/20251222122022.254268-1-jiayuan.chen@linux.dev/

Jiayuan Chen (2):
  mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
  mm/vmscan: add tracepoint and reason for kswapd_failures reset

 include/linux/mmzone.h        | 17 ++++++++++--
 include/trace/events/vmscan.h | 51 +++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |  2 +-
 mm/page_alloc.c               |  4 +--
 mm/show_mem.c                 |  3 +--
 mm/vmscan.c                   | 45 +++++++++++++++++++++++++------
 mm/vmstat.c                   |  2 +-
 7 files changed, 108 insertions(+), 16 deletions(-)

-- 
2.43.0


