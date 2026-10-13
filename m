Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8321CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0936B008C; Tue, 13 Oct 2026 09:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8B36B0092; Tue, 13 Oct 2026 09:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B456B0095; Tue, 13 Oct 2026 09:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F29A6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:13:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04E371C459B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:43 +0000 (UTC)
X-FDA: 85317645168.04.D934D0D
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4E32C0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m+BY8Gcq;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897222;
	b=xoyKs1qTkcYJ6NK3vXOPiRdNlXJJzDPUaLPHYmI7Mp+vJCRt3jmIW7bmnn9KwDqPY7Iy3J
	LYUg7BmmqykjiV/4liFkkfq/KIGZt0guJDzAzwX+jG09NbMCmoW0U4dwzPYhSwP1fj+Xp8
	UOTYWAa0V+8/ihsYY/uyfnWiEFz65Pg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m+BY8Gcq;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ypNEatq3xAc+7aH37IDz4t9w7jxS25XVp62+iu5fps=;
	b=S8w6RiEhGAUeeldogmsfIgx1cdHPnEeGrM9zZWsuTmSK6AkSqmUvqz3lbaYIT5gBlPsa+0
	VKI+y1hR5CVTj8AAm4/EepmXw+jZ3ErwyNG5yTFj93+tzduBZ/y4xgtHq2R8rZPHIYhfeJ
	NsR1DHq6n2lE1nVx0lfZhPaYJvuzG6k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wf3HFTJhVfeY9yUmZhJB3MQ0b0ETjxoSHCzWGVLQFnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897220; v=1; x=1792502020;
 b=m+BY8Gcqu1+2Cfum7IyPU/EBxZG9nplXzofr/44k1dGB5r7ECyV8ecs1PDdWLY6APjgjAdvB
 Xu6BgJkfBMe82Q7tdjcY24NkdFpmZylnYl+HCzZlwo5HRX1f1IWg5YIniajWp+pn9QOfOVJRbYP
 nEmXm6fPdNW4SHVR5Au8nys4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 55508975d0a73f72;
	Tue, 13 Oct 2026 13:13:40 +0000
X-Mizu-Trace-ID: 55508975d0a73f72
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Tue, 13 Oct 2026 21:13:03 +0800
Message-Id: <20261013131309.2790253-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mkswsec3jh378hee5qkmo8atw8apaufd
X-Rspamd-Queue-Id: E4E32C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791897221-605302
X-HE-Meta: U2FsdGVkX1+SgF7hkzpRZfmTsq/5W//8+DovFop5jNYI14f6Y6/eGFqfvv3y7wbOr0WRdGGuiHYxGSZmbQHjoy+YpgWa9moSFnqERM4zevQOdYfR/K5H0TnhwRFDVp052a1rLZwynHGO+lCkfYqOkBsyIu3UogzSqtR1Sqnn5BEFBnF/lkofwknHYK0xG8U/M+O9+ckD6WTg1Aqq+WnOx28sg73FGUWLg4aBJ0eygav9rwcEK9s41p5csPMfGHOYnwzzssoFBvSWLty+I0+9Kt/Jd1XZvnhAy1ZLUShDfsVVqFbmB/iJGFGC7y3QQBxIu/vYoq3tZ8rk8kVLLv6I03Yn40Tnke813kche/Zh85HEMWeQ91ghfWel78WGdgvME2PSFE7Rkp1isPljBA7dWGT44mnU+Dep+gZi95Qfwfwgq6S0h/7qHNCrtsSI+rMuqx8WX8R2+b6+pHD71Q8EtL4bN0659wS7yATITorHECexT5swBUGFxEHsVIgfHqsqFtc0Y8mNmEVWid/i5Nwb6bsXR+Jo+y+b0xZ33mjJ/eBTXyIfBV/SXJa4W5D+OifTWZcXLC4SXEKUDY8L9j7x9WkQcsHJTrMpB9fYxz1K3M7aeEEh9ZnkjSmXcIaHJTZG7YWroAi1G/eis8vGQReDDBYXDMG8ZAL8G2eIGAxjxDNtmwUOW2i6pYMxLiFRIc8F8RquKkEiGV66bYhEYMaP9fOqC26X/Ql0A67lz443Xbo6IUSOlo5SIMiMznjEVieuGgqE8Yg2FmMLbKTlyRT8VkfyTB8ySJjBV9tgM9/obIYyMcWjXtLmz51GcAJIohLPxs4eDthZnL7JPVYfBPN44D2ouTPZTXdY863he78hyCSyJOBfO6bj03oR5GGLlOP4EGF99q+vpBc0JvhxoPVOULNvp7JuRsCT+p8vl9jOlo0CtZxm9JaKgMYzqi0a60v5z+1dSKDINVZc/AZMa/I
 CgRtkF37
 ziEXSdomvd6dLGLbWl4MgJdYVwFmfaB9QVfEtuzcjW/8Yj9c0nVRm5povE5U+JUyHyLLnGgjhsVeWZ0Uy4YOG5eUuQ57JHUwl+N/MIHlDCl0Pyb2saijE7eTumL3BhCxnJb9tTu5qEPVtwQ1gkyrOjNNpHbfF7suWj0CKbxYnxppM3j1H51GbWESrk7jh9ZfawkOyY38jPTVSMst6CNFfVHEas4Okz3SF4rTC+OWbWIl69QBHS77tOhmLJfW0ClyyUkwWH6d9AdwQsVY/jWLZslC5mIKWxb4WulUlH7+mLHPk1q1WPnbHkdAb9fgKg5tF38ovcrLRd6zqwl+/aSEIj+Uul92paqhU/MaAI6XaD9XkzY6a5/Q0xpwbx4vKL07v7G8WfABoAWKsAnr5b6bwFMjuDlWt8h50B2FmW7kgJJmmNH89FS1BSU8cr05OG+fEYu6JGOsqiRHCqtl4q6qnPuxC3ZeLLfMvrEvaLakKhGKqJARBh15YjbBtLSOfB0IQJQus9qGICBSxjGlMBSLqe4enujlmYYn1GBc9W6iiX/JjfGwztLsJpNIr7c9/dwiW62gVot7vUydVGjhoB0zY4Cah4FzgPzB85Gc68/kvGGJlpiJ+qE10xwCSPc/PdYQRVNkAe0Gw6TkmZJnzjFqZAcCd6Trx3NZAi7SgeleV+6SKZWULOIzGIlQmfnuLbbygf5mydozUqsc2QFHlzYGFylM2rCrfhv29Qm4D/C/PkGj21KOrJAYkhdaqiHe3Zs3sEDxlxpHBgphNN/TVFF1rUxLZZK0s2732NkBsB0YW13SvSg4yFk6ZpxWinZAGLxejXu9yGpd6rit6s+mTLPKAtahq4MF89H02vOd6An312ZpvihN3K+dGKHxsERCFD9+Tdgri4ns50jeLi0SGsC1VqqJAmoU+hDoM6Qe1e2SD/KjG8Zg49fqHb/z/XmRdCR6KQySW3eYduA63ka0zV+kfvjdPPQQD
 yOTrW6Qb
 3aYoJiCr1Hq5FXVaubbsvZ9BpU05/21breJKyGt1ufAOok7GX+4szR57fpHeMDe3
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


