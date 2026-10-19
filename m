Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F16DCCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC836B00FF; Sun, 18 Oct 2026 23:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACF76B0100; Sun, 18 Oct 2026 23:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C086B0101; Sun, 18 Oct 2026 23:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F15C6B00FF
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:53:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1A7C80607
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:12 +0000 (UTC)
X-FDA: 85338005424.30.73C1514
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id AFD96100003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ebo0RkkE;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792381991;
	b=UrPjxByWHS3xU/PnCgq7/Fwa2289LqjzN0XSSbWFtYiVptpoxqfQvqQcbMDqElriBK9p+5
	FEIMegOuVLNz0ODTziYOarL5lsKfXmdrqatpn/jTTxoUBtmoW1Ce1HxGR7vf1VdHTit2UP
	79KvPkkj20JzQ6csw2yOOxLFA+vQCoY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ebo0RkkE;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792381991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ypNEatq3xAc+7aH37IDz4t9w7jxS25XVp62+iu5fps=;
	b=X44jT6voCoTiCyktyLY2xhEIVAU5iSpig4a4UQrfqxYrvs1k4Fm1LV1FVHMzwTrG4Y3CiV
	O7jwzKftzQS/sv+4M77/SB++7KpXQSW0iDwnFyzu4R4IlDuOZRgU01XoiHh08a+RztzsJm
	kDKJbzrx17rkQI2tKgdw7Y/NQzMAF4I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wf3HFTJhVfeY9yUmZhJB3MQ0b0ETjxoSHCzWGVLQFnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792381988; v=1; x=1792986788;
 b=ebo0RkkEdtEcxStiY2jOra/1PKA1rXk1Jq0eff9l9bH3Z/2UCM3l+x3ucTxZT1V5CS5VUbKX
 SqmIXZj9y2aUFowsYuRiq21y1L+j3prWehZp8lQwP94XszS/FHQtpGrXz1yL+d0bsrGStNN6Ktr
 SOYeAHM1Ey12meA7VlskX+Xo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id daa68f2621494a39;
	Mon, 19 Oct 2026 03:53:08 +0000
X-Mizu-Trace-ID: daa68f2621494a39
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 1/9] mm/memcontrol: drop unused vmscan tracepoint include
Date: Mon, 19 Oct 2026 11:52:44 +0800
Message-Id: <20261019035252.2357900-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AFD96100003
X-Stat-Signature: cfouu5pwobs8oajrm7hjkndzifsknsa5
X-Rspam-User: 
X-HE-Tag: 1792381990-166636
X-HE-Meta: U2FsdGVkX1+V4ZAZpiyMEgegDvmtYVJpeYk2Wl3qJ4AaUzRfm7xbm22Vy2MeCe7z1Gefwe+eOC+4tY93WZ7ltB0ajF/qByKchQTd+JkMgOwh8xxyqoDu9wUmE0A/pF9RGInZjE5FekuKqvHTOGK3Q6ZeS/8jAQFWShOtL00Z/Kgv7ol4cUcq2DMuYFl5QPLud7r1E/dd7PriY3mck+8Uwl6jxrZwMm9aMaCSEg66zPOdtvrul20K+5Ej955zpVyYXPaY1rpFZXpewMBv2w8fh/ra87ze5D5s53y5aOuQUeM9WgpZeiOxCgsK/wZgAtng9+qPAqzzAG9EBwJ+QCw2OmVU6Cm6XH3/ZDU4mFfl6j/xuF5gsxKq3+qOIuGDYxGavyYLydrtFZs85tFD0fSngqsxNzOWRVJdQPO67PpUZ/aJUU/K1BN9VNFjYUXRUVibUMy6GIXpf7y5Nd6+/X4+4W/bGRACx4dm+ymg2/3UIKgDoTym9cWeVze3k+s5NRCUDYVRM1JVL9HQm3xUWyvJ3FFgKSyCtGp6XrqamXG45UoAFxJiG1yuW7MX+c/VoZsv+n+ozFgf9QQvMaaK5c3+mT+ZkbNtEKoI872nyT8gS/Or5t1RV3DglTHzY8gUOmYl/Mprm4mL8S5Qjb6PbBOdBdf2Z7XECGnX1mGTI6l7LlyaVPDt873Tngtr8RZ0oKPCCYc2EIqfrV836MtteWlszx/sGNy2vsFQAl6uPAXnDwHnStKvqn+S0x0Q0bgRhrbHeudF2Fuld1yNbtXvoBTAIzcoBkk3zq4YBJNlhM2qtjENQsDyGAvDvfkexXDQYmddpjtTW8uhjmVDrxSXIviFqGAOoelg0Ok6AM8E1auWX4vD7Hji2NYF4wNoJeGvtXAqYAM22mha09w6tRYwuZgmn4WTZ0rlbxSBjCkbJ8Bj50VE5tRv8SYWpH8t6Eqtvcq7MA7ipL4oqWxzs5d8EHt
 5aYXo0lj
 9ay3ZPxger1oEPw3rkCR3g5S4UwxFy6NsaXDR3L9ZfKkxNttQBH8j5G8lxj1eu3gXENAgS+s6zfjCSyXA5dhNV0+8uwOd/6hZcMVxhJM4GKvgnzED/PvOztoHnV3lPx7/zVqyfh2UUd4H8Csez2vGvPBTVaNBg0FicALqyzhnvXTXt+JL0JvyyPn3OB2XwahT+h3TXvUWLJYWR7w2Ygl90Vm5GwR3MnHvISWMeUnaP6JNPUaM0A7vgApBxqDbtcNtem6diPfCYNbh6yvyJH/+/1vBHglR+Bj7S6KK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.

Drop it ahead of moving the vmscan trace header under mm/, after which
<trace/events/vmscan.h> will no longer exist.

No functional change.

Assisted-by: LLM
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..95c2322d4a6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
-- 
2.34.1


