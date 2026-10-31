Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0244606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ikWGtFFr
Received: by kanga.kvack.org (Postfix)
	id EEAAE6B05B2; Sat, 31 Oct 2026 05:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B5A6B05B3; Sat, 31 Oct 2026 05:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8A66B05B4; Sat, 31 Oct 2026 05:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0CC16B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:01:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69A211408B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:16 +0000 (UTC)
X-FDA: 85382327352.15.8761BC1
Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EBCBA0013
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ikWGtFFr;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437274;
	b=d1b/ctpRI1+bqLkqJEJOh4NvU66XD/c2EUYk/Tt8Qa9tp3AMOzzEFKbv0G7WSW7+kgapy6
	ekHKH1zsfBY4UGqITMUXtvJiOnMY7YKzL12Pug2LqJZWxx20821nl5CDJMDMVunLxq3kPN
	ZQ/DTufu6GoRenhnufqc5E4OXnZChGM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ikWGtFFr;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ncgEC9IMszXot5VibjqpArUmCGpn+ctDoSwbL7FfHA=;
	b=tYLKLgP3SgavV3d59CiNRl7b4H+SVQ1o/Aw7a4AXua48fhuU532pwx2zNxYTt8SYuEJ5yW
	4VbrZB9mvsAJXLO9/CHN8wH8926JqGuYF8JKdKybtIckV4sQOTlHHFdeaUnOB04Tlt20xM
	Pq0Nzv/F7AzWg3ndqRCwGR3R2hsUcJg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LhFhTvoRvl7pKSSWDkFqwayWFuSIT7ln2mRB/yDhXK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437266; v=1; x=1794042066;
 b=ikWGtFFrvYwxh65llgEgf+rVkllVvrnYHhAHT5ljaIjsc57mJZzNVjLFk7t3y8fCSvNv1wRu
 SiPMPRugi7WCpWmYdhj6H+KCS/68ZtB/I8Mdk9BBW2FOCH/iHR9R5j23iwhKsxRRv7VpaHYsPga
 gy9XSSvqcciOvogN9RxjohOQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5cbd8b44e2e7798;
	Sat, 31 Oct 2026 09:01:06 +0000
X-Mizu-Trace-ID: e5cbd8b44e2e7798
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
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 1/6] mm/memcontrol: drop unused vmscan tracepoint include
Date: Sat, 31 Oct 2026 17:00:36 +0800
Message-ID: <20261031090041.58574-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EBCBA0013
X-Stat-Signature: rtqi4qfwbgj7wwcb4wgrj5efbtsqaw5y
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793437274-718285
X-HE-Meta: U2FsdGVkX1+cts5h+wGaWw3PgxJKuFwA2w5bxZ4ALZMsCV/SCq2hguO6AiUl9VFksYECeFdQjJv00s9k6iWSFLrzcJ5QeCqj1meVj5Lm4NRLm4rpT/hXm3iip+e5f1vleqPSgM7ZJQrhIoz7BBJcTrxRXtgR3Wr2qCK/SFfEI3X6X7c4qP7VetJ5wysxG2GrrIErGTrMIRCw9KL8BpbFbBDTetLEh0PUFP+Ci4WvgBb3SbxX2S0i05BPoxl+LbxiyHK8aprTt/FUA9o1eQdZBQnobUbea+JUgjg3FGtAKLYWI0vFjM0CrN/d3fFPnL8UQFmTxfEoNir3wRKa3XPG7/p7XxTUElYHDA3ZHEDeeHHaYhyhsbpul4EXChhNgBTQjW24twIH5ivykLyxTTEzJm0yI6I9TYOjW99fsVMORRl37PEABNpneNiGBmrpY/td0sOq3QOBuHcHsxQ+MKLFLCBQzF0nYTHyt2nLaxgL1alAVx3F9wmCxTxhqsX2ClPvfSmfVF3Lh4SFwLYkY3MzPIPWDmcmUEP6+wVlbDGYOIp+SEtT80lGHDxqCYJLFDgBCUoPNVKk4uJVm+eDCkyR2fa1q4203K5Oy2/8Yi0VG/zAoztjkfV2L5F6VUUNt96EfiH3C+6kdHZSkXL/WKhwcI4NbGgeMZBxL3stw0cFxGBjr5JfOQogdZkyBNdgVHKEu468B86KtB+CGfoOpix/zyunBdDdmogTGBKzigA5z5ieZ8T/4SFyTOeP3BJH9d2jr88q9Kk2MZ4lOwlWWF+ldCuhi24L4xZgEJV58DD2C/bd1n0OJc9m1ROEvrK7YMCU7MCfdT3XICnrb6UmGtfSEgNoAgkiHhsduhApknaeUR7+mF6PGDQN51FbIwHUJM1aWiAaNrIjaA9h2TEheQ6UmGF1UPsp9eXMFrR7BtWlGo3LF7v6QeRKWpgv//lFpo7D/fjpupADGyywSo/zxnq
 TT95LCL8
 NGaHHG3bS7SnjT4P04w3/y0QUbBnk+fS5O+0STX67UXVcRk9BkM+eq12CtWbpPiBWlZ1GPyvueobXaMwvtZ0eMLsaQCIWgdqm1SwQh5p0pm/eiyrwWlloaeGpVCboUJVY9w+N7SbB8ckE5u3A40G0h8MiKApuvQiAuvVjo5fNwFmVx54vJWCq+i81m2gQFz+2MbSsUHUXpFYn+4EJJR+bSraYxrryYTzAbkKzz7l043vogWDEDB/Dcxr97215nOzC6b5MB07RQqh29ApWBy1+PFSFtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.

Drop it ahead of moving the vmscan trace header under mm/, after which
<trace/events/vmscan.h> will no longer exist.

No functional change.

Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..8a35f5b635e0 100644
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
2.43.0


