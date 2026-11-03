Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705F0606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cp2Z//Ry
Received: by kanga.kvack.org (Postfix)
	id 39F2C6B05B3; Mon,  2 Nov 2026 21:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376DB6B05B4; Mon,  2 Nov 2026 21:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D986B05B5; Mon,  2 Nov 2026 21:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF6A66B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:56:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82F931A02FC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:56:49 +0000 (UTC)
X-FDA: 85392295338.08.EE29AFA
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	by imf18.hostedemail.com (Postfix) with ESMTP id 947FB1C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:56:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cp2Z//Ry";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIOkkGnIZaSPy1/KAD5FiiNG0GgLq7eCUC5R8WcHZHE=;
	b=YBI2gFJi+mm32dAbHtNRItXKB1zQ53lU8AaHP9PhA28TPCmso5+jSd8gWyyZdc7VuNU8MW
	ZRfrT8YxpUUULBwdEsoOIVjUhnTUG+wvy+W9qyoHN5Khl37tLHlDsy+Ey5DDl5WpxWtY3u
	i23jd1tFHlJSvW+/Cv81o3V6ss/zLV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674607;
	b=E2HCTCPHkpjbPBE4naE0IHA3oxgjncQd7JZkzl2dvyG8JpSuI6kFNaivtv31g+/MCb2gR+
	zoiTStS0kCvCPpWRWsnMr0cG/v1KkhwSg+yRHpcHNWXDbicX+RwDBGy4af+aoUUK//as+2
	Ev+SI5h4Ymthn4pLL/T3Ac9YsWYxbms=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cp2Z//Ry";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9n/hwIsY+R5F+Nl0olpxr58NPq3L66rvI7ss+scwvow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674606; v=1; x=1794279406;
 b=cp2Z//RyDRGkFzDFCZCmu1hbgRc4Q5bqkhpgGOy3i1hGpm1LxihWaKRiMUUz2EBrXHw5U7WV
 vEESiX2Wbe2xTpBf4rH31pN6dXsGkU23VFOtygJCr1dwNnr1RrlpoEqDq+NhfHKz/jhlOeToPCi
 qblVZMc2F24LY08wvwjI8e9A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ddeccf7e7d3279f7;
	Tue, 03 Nov 2026 02:56:46 +0000
X-Mizu-Trace-ID: ddeccf7e7d3279f7
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
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v6 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Tue,  3 Nov 2026 10:56:04 +0800
Message-Id: <20261103025610.3738894-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 54fm3n4dfhu3wce6syrkdi18138igwgr
X-Rspamd-Queue-Id: 947FB1C0004
X-Rspam-User: 
X-HE-Tag: 1793674607-671158
X-HE-Meta: U2FsdGVkX19yQO0a76fgtJuRXIREGYSmTLLKMM7CyZ4CDjPy++UHR7v4cRZgFRIfPJrOp5CEdrRms6x41L/7Ph2/7GbQ/B3ZHLszrlfk8MrKVtbKH3mD+0tIqv6WA30suDlpgvIpoIG508VBrJGiRO014S1SqRr/2mB3EsKfS1w1ayZIGV8upeF1BW5A/c00Ea/HHl+DF5d0d6WJy6JDKDWFOt96hfwpgqxQdxRgTlcbbA/fmCnUpPXGTNOTyslbXCEb4OSzfNPdnNTsVK5PO9soeOsboU236RsPr70rwKW7w3mZ91P1zBUvgH9NuITfnHZmdAgr9PX7wrpx9MAuVQJOpnoS8QPbdoD1YG/JJRF03bqfUs/F3s4qTkSKkXCPdNzrDUUCzNUlMwIufbjeb/98Zp5JNkCTYyzT+wr360VeA9Z1j3YdFTgCZ9ymrJw0PQ257bXorVkGDo9tG5bmwbFQjweattvwvzFq/z56ajb/mPHdqv8FeNU3bKI8PKlRgZh8c3nI0RPapXlRf/ws/IvLimub+PEz+sXQEd2r7TACIsC2AoywgJZUnefceBXsr6adzxfLmV/fE1DHxayOLkMqAxy0Xv9WYMqr48WlNdwRSXZ88qgoUQqhWFR3wCPLcsxHH24ThsLAa4hY01Frwad+VztoZVg1z2JccpgASpGgVKBtkWDU+x/K9QVigmZcU4EWD7LEF8SgvINLNyh0fwjeKolPu2AWfZF4SP2IH/xXVghrB5/UpHzJB0lWfWDW1p1/8IFjbe0rLzoGnLOcvanUamF8A8JCcJODVgpdKtheaKHIlxA39Ur4FzQmZXPit6kYwFw/D3E0wRFlvsuthckLwL3QBxW0oV/21VVqmRcJXvITcb8i8I5pOKD0hqsiij1eJDyap0KX0/XJbRjjrEIWdAV76+5IDPWXyIR81S1RCyFvhBs2Ub7ir98x7chlo+8OaeAd0pczQSYZd+g
 PPgASqOO
 Yx3WRRCDPLBvOXYvHNwThevfP/oV7S3N0LH44N1BvgR0hy8P5jYUn6ssUNRiWQ04+INVSi76dafQ3NIR3X4WHTv3C+s0O9JVstoGVO9jPq/1YjLDd7gS8Jxss9KNfh2gCm5tQrvuHpNLDVl72hYRxI71vZJIsi1SJeHZnfGYEG3NjMU+dxRn2y9X+Ipg5osJaNL3VvqgOj4OyDhErCqCCxTxTeElUOaR6wyfjVC80J0Gr1GufXdCGcGMXWLdYQNPLx3+Cw3ZZH/7fyzgFE9sV/p3Kow==
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
index ac6c43ea8c5a..5bad742dc381 100644
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


