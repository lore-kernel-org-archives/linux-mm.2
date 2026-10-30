Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD3F606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HLnG1BJU
Received: by kanga.kvack.org (Postfix)
	id 2739C6B05B6; Fri, 30 Oct 2026 16:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF8A6B05B7; Fri, 30 Oct 2026 16:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BED36B05B8; Fri, 30 Oct 2026 16:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D326D6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 675F1140598
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:47 +0000 (UTC)
X-FDA: 85380496614.12.CBADFD9
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6EA1CC0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLnG1BJU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LOOMBiRudcRqqourx6yGwP6bpaJtTp0XqlHxDY1cLk=;
	b=fsT49QeTcH8dX5f/y8iK2aFxLuC1ta+g71iqSVqNrdELc1FYBbWUmjzr+gecsKy/NaEza9
	gLTzf5s+sQN9WdhXl5G629BcXwWUqOhY278QTid+sllHyvv4Fw3v5i5Fdj85/3OOreGqz/
	zPYlV6Yw+PKD/Mn1LuSbJ0Y2SEhHJc0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLnG1BJU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393685;
	b=TUf6qt1pmRMUo+L69xg3lNA2o52f0n0i1P9cqGO4YnbE2dy6HsIInEoBamATEy+DY0ALKL
	sXas20Y690ZjrFCDtI3FnU+5izMhHk1yZam5iz07GRIinXWkZsxsUoIcVWbqrdeidDK1Rr
	cDed/WaL0UtPNBKOEHEB2hTVl1i2yBs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xZeayaJ9A4XXrBIo9cgThSGbAkjlrpMHtlIOd0m03/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393684; v=1; x=1793998484;
 b=HLnG1BJURJTLZ1LncN0Z2qcRAyII+KMaZKF4L2tHQhNjHHsajh5PT+R8AE7AC6lxsPg+p2rc
 0HFhcpowfb4uvaN5VdumBpcMt36rtEOist1HkbpArNpG74ib1SXKxeoTWnHv70jKJvdF2hIXl4b
 L9yLEmgpw4sc7t6nGWZE/ZF8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 07d861093bbb3087;
	Fri, 30 Oct 2026 20:54:44 +0000
X-Mizu-Trace-ID: 07d861093bbb3087
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 4/5] memcg: use high_work for remote charges
Date: Fri, 30 Oct 2026 13:54:15 -0700
Message-ID: <20261030205418.341214-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EA1CC0002
X-Stat-Signature: zse3x1mgxmooz4btzm1c3f1kukiir93j
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	T_SPF_HELO_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793393685-919635
X-HE-Meta: U2FsdGVkX1+IkoIaCjGOvrs64o9A+5hUtScpG9sO6T4CJ2LNNpOq+mti2UASUK+cSMTtr0qb7earT6ERLDBKBLxte1vmkLA2jMmcUl09jXPL5YrhsKfAqXkqiyoob0PM5FzgUW1xqpxstg4aAfD2Ob+8FBfC2xv9+fsv1RolkrVAtJSXKhbHTHobPUl06sR+yNoMjMfrA0FyOXAu1cJI2lwylksS8ngi8aoNZaqkm3Ojh1nEvmPwWfgLE8EaBVHTTQQBHP8LXxWzng3cfG2eshJ8ZgBLmQvvDIMw5AEpKZOGKOqgDCw3v7CETwDZOFPcZBp2Fp8cnTz7a+woZiBnHNxstKFZdVykLvzs3zyFbibRoKsZsjUD3+MR4YH/8asbVaoONDneRu41/RYPYK3HWToIHNQea+dUL9qnt8hE945fAc16ivu6vokCVYhbDUuOeFOGfX5Wgkw/LFJdJ1eg0XDmbvIwuFcoi5gAaguybgDgbshCWX3LwVbOfDtFBZLEy5z6N/vPIKxUgrNbUjdMggQ3IvT5f9BMGHNP6LTAU7SJ7Ex62jaDguIDOl/lxDp3mLbyIGATJjLFNEh27OVQwpet0o2ACrvDhKh5uHLauevrkWkz0Ze2/j4fYpAqfdzgMZ9n4n5Pz8KeTMr0a1+xvXcOy5+QPU744w72Luc99TjeUjtOcySGv8Lx89QYmbKc/p7aedSWgiNjfd7MwUQCwVmB41OupU1XN087iGqdp5Xw25n4bS6h2nP52vuuDY52QD2Yzg79m3vefsvJCaR7fwmQiE4gHa0E9XBJtxRcH3eKVm91sHbMglEQpVQH7XvFiw+N2pp6EzHo5zrB7hUbUN1sMOsGv5ZB4wvhY18zkAFLs3pLAmTl/hiTXmWEIGCSeFabx6CpfqJmbBQRg9KizJPvRzdg6qR34GZH7q+O8IVqvzkJmCGIr0afGrwrDhK6Ewwpbc7fyZEZzYgJLdK
 ERiQURYl
 V5kdcPbzQPA3Qd4GqyruT4Vd0vWPlvOVxLJkAN1uG/k/+kF+ihK3j2TYhVj9ccsadi/NVao+0gh5Zu4a7kLoZ9euNiuY4og1rzm9Zpdbvds/AuvlI4vpcCCwwLQxASqnYWMVikx2i3yzu1iyjQ6rj+HY8yv8oVSM/z/lYcZwoxG2viu5+VvQyLSWLhhZ/kI4NkuhD5OIocUpv8jRCYb+8mo9Rh5yeKsuIxWMuRxYLo9xhKhJ3FFA28UPWBsWhtLYt8zjnClWOhP2550U4jeBg6C9HZwefQkS2PbrLfLUD6KyXw1lC0L1liB+2i//zU0OVYMbtheSR0CrtTmoyFJ2hp2hPi564cBUds1GLsg6waXrOkHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Some charges go to a cgroup outside the current mm's cgroup and its
ancestors. The high handler uses current->mm, so it cannot handle these
overages. Filesystem notifications and remote page faults can take
this path.

Use mm_match_cgroup() before checking the high limits. If it does not
match, use high_work instead of recording task overage or doing
synchronous reclaim and throttling. Charges to the current mm's cgroup
or one of its ancestors keep their current handling. Tasks without an
mm also use the worker.

Like kernel threads, remote chargers skip memory.swap.high throttling
and its high-event reporting, and a fast allocator can outrun the worker.
The memory.max and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 42bdaaacafb7..e8d9c001b6ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,7 +2708,8 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2731,6 +2732,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		 * Don't make an unrelated interrupted task handle this charge.
 		 * Kernel threads may be working for other tasks, so let a worker
 		 * reclaim instead.
+		 * Remote charges need reclaim from their charged hierarchy.
 		 */
 		if (use_worker) {
 			if (mem_high) {
@@ -2759,7 +2761,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
-	/* Interrupts and kernel threads stop here. */
+	/* Interrupts, kernel threads, and remote chargers stop here. */
 	if (use_worker)
 		return;
 
-- 
2.53.0-Meta


