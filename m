Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CF2606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=coHRrqJ5
Received: by kanga.kvack.org (Postfix)
	id EAB526B05D1; Wed,  4 Nov 2026 08:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C796B05D2; Wed,  4 Nov 2026 08:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D990D6B05D3; Wed,  4 Nov 2026 08:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC71B6B05D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:08:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DF601A0708
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:08:56 +0000 (UTC)
X-FDA: 85397466672.19.338B493
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53ED340004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:08:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=coHRrqJ5;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797734;
	b=kEebT7ZHeF6CpqIh3dZGA5qpjnRbvmaPQcasdsi4fKwUqpLyNtGUicsjiUFjGjVKy82C+W
	NnFgJ+mkErKNPRDHCnNH+XYmxzaPUONwADPIQvfF4C2nVsM8VzZNrwJfSMb/kbYsQQL+xw
	0gg+yGYPLuKkhiTYk82EpinA7RfN334=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=coHRrqJ5;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Km4Cv0O0nuE0+Y+BE7m08mP9J2XXD5bcoWZppFqnwaU=;
	b=u/SYFirt3LUhvfhkYra6fLuN8KkfRNlxpj6hDOPzNXl0BHrreXnnATx3V29iW82ZVgH4zP
	cFUsBE4m2SzRUyNVM7p6Z0xF67/vfxIv1b8Y9lTPFHQwo8spX1B58RWydyzFKQtrCiXMSj
	n4IjWUme5Lp8cIkQZMLSHNzJ8JtctVg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jyyu3ZdXnJNcUGMDlH0RvUqU3YiWZYptJtZdAQQmKqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797732; v=1; x=1794402532;
 b=coHRrqJ5FeVPLaMeCy3cHUAwJS5EOlqMiGUb5qf0LjOAVY9qtA/qtyfzDG+SPiSctla8760I
 sNVTorqDFIe6qhN9j3QkzoqDYOO+/gca9qdmqFCamDcDotddFY4lBRUINMwG4zPas5wzQf/T7IF
 OIGrhoeu9HFnjyGfsoNnCl10=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 25592fce0d3f543f;
	Wed, 04 Nov 2026 13:08:52 +0000
X-Mizu-Trace-ID: 25592fce0d3f543f
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Wed,  4 Nov 2026 21:08:11 +0800
Message-Id: <20261104130817.849089-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 61j1zon7deyar8xusawkxayxsohjgxhg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53ED340004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797734-258658
X-HE-Meta: U2FsdGVkX18gXjg41UwIQt2N6RddYVolHBGEwQ/leXXwy9Bpr76jNblZ7UChHZMuOcOip8S54ISCo/ug9JII3Gm7pXa0mYiaGa/wc6UQ+ukbN25AEGHu5nmtrO8089bRtcrzMzfY0ae8k0WhX7KsdXOzYbjvwLA4t8KXnn8mQOGEMTSo/fXYxQthWnErwGdwQmH1RxNkIHuvHpoend+K4qN1+D6WO1DdPl74U4y2CQrrDxu5+J91+JHG1xEvNxXaxdlujrQKVrPZjDFZrpNCZdNJNeH3//P51Kw9RF35co4osZTGVc1IkeFX8EAFkmhBUuTe5KM37Lxmf/ipSu492RbwL/Xiv4HRGmOUP6es4ahnR7uCJK09S5hrIF3mmrTZeHtS6xrXiKbgolGKWBCxYvUJyFbwc8xdvDZTTa0jFUDJrcXTsGN7mCGacqUPOIyCdWycu9tyQKiJe0cgSfBx58a+USpJUTk6ytsvZjQb4J2od+HlJoavqPjbUo9p7vwDAGrN5oreynxoICC+6HRfaeHsdI0zuf+6W2ClkWIGBopcMtvCxgLAbgX3vdXMAlAMqBkwr1rg2GpbSX/aZHLlToIsu1iODxQBCjXAaaCXHbkg+1UPbnqohugJHlzKGPwpU8mw9ZUK5eWb7FYfMEsUHtsmYr8sdMxLp2NAuXWzI8yHwBLEq3cPeH1/hoJeqoDYEHEfMNwynxdWFKnXVCEh6H2QzWbDr6SsRo3GCnVaoMTYbKciW47uuQi2VAXYa20GA9t5Hyt/rTD2VJav1ONU0wseIU45UFaTvVuEvAVMfQxEDtiLeGygsNgVMOtFdFOG/mzsNaINhrx347eRwI6BqaGJZ86TcBn0U32sQaRIDkZyWPLDmxZC06Pvr82NTMg94NRDNPV800CtlJXuwNV+gOslv67YMr+cFMt1KH4sd4lP0LoHTvcQ5LIDJ9awPw1vdXJsVeydOQrRfYT92gU
 BZYCpg+/
 6aO+Ai+aENeFz7nULeY0qkbnnP137o11tUXmEWwJ8Gb97QbcWOYWK0GZlpF+chWX9U/WWfgbnvxuKlePfFzLHUhHRBWRNRT9XN//BIK9EXmSIZ9sB8kH/16A/TyGnkJN8UPvxE3KvB7IqK03714SZudEHyy4+4gIK16HSa60ByN2oeNc288SJKI5Zax5QAah2xIrNGceWvSG17MPacdd72QG/YZGKdH5pSRQtCzG3VGp1UQ0MMEYUi0GrpISW+jVMiNQA1dsyxE4KxMpVjgiGduqYXA==
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
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffbcea28a608..1ebc9330aeae 100644
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


