Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0453BC5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 07:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D42F6B007B; Mon, 10 Aug 2026 03:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E3D6B008A; Mon, 10 Aug 2026 03:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326016B008C; Mon, 10 Aug 2026 03:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 054E46B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:43:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B883A28DD
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:43:43 +0000 (UTC)
X-FDA: 85084570326.04.3505D58
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49EA1140008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:43:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C6S/P4gc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786347822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mVpJ6V0RufPJd4lqnhOejWws1ST4k7JNg7UsqaSq5+w=;
	b=5n+fGKC8yhmpeloWP7+8+mQ4/kWFZgbTqmjyLxnG9IqELgcUXsCGrEaxM+fizFBlC89XFj
	yYgNRwNnpC44nnWJaC37KHJBZpYdhIZYaxSXfHWpycLNaCFWXt/ML+JiLQvqPoEEsxsGNs
	B1eyPIlP4WkI4MSPitD5mGn6SqAE0JI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C6S/P4gc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786347822;
	b=Jt3vtu198L1EgzN+iNsBU1aUhTK4xOd/um7lqjuH5qQNCHD2Uvuq6Ozw/jOaR3B/H2mozg
	txDDEEfGTIXU7oHEQUykWwYxeGjswkVTz5fkXWFFpv9MKqLVzvQ3mdcpcG1sPfkCB7Foux
	rDeachKvPCPLIYgYnvThuWtCBXP/mbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786347816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mVpJ6V0RufPJd4lqnhOejWws1ST4k7JNg7UsqaSq5+w=;
	b=C6S/P4gcr49W+z0/h6tyOrwCcOMOribH32iiXx1Sfgz5nXuliLAvIh5TOkjzxGhe4Xr9Rh
	oUDXvbtPjLXkTTYni8ltgBToVEWjftn677uo/eUDMzsGKvldXWr2A+24lmXWbOmoioUsrq
	64SFBOrMp2V9nBkeUOzy0SdB0wUayFM=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Date: Mon, 10 Aug 2026 15:42:47 +0800
Message-ID: <20260810074247.52747-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49EA1140008
X-Stat-Signature: 4iaxujstpxpnqzotowaa9icqi5g5i4mq
X-Rspam-User: 
X-HE-Tag: 1786347820-337944
X-HE-Meta: U2FsdGVkX19eeze1QpazRw3pCGZDrcrA8oR/wa9/zorYXrQ8REZ/NpUxwMvnmz/ZHdcCmJAOFii2KuwetG+9lyMStTused+Tag+2JLQ6D5VoKTMDF6RNQWAFrX+oJCfm+kMwYy0O+BeyXwnkz17ZeVGJhDzS0KGqiGVlFPCxYUWSCLRc1rMLb94/dOGBRSpZnS6jCBvc5p9Rf+tEWRXbHsmGIDrcqUle+PMbnwEctCkxtbXmIsctFqaBJt71IhLhfVenIoaARMTQMjJSHpwN48Crnw8FxANUIsGDOhISb426drYfue+K8f4in+ul4mCZaIw9KAr4IB3VngQmpCPQloaWfvQWx2tqux86+9D5ce81u9tHX3tCSEH4grsIcNLHNWJZjXrQKENEy0gpdSVM+t1lrFQfEv19kQrEDZrdGAdg6TG+MwhoQ2tKboW1OBisJMFdIb3bN1JnSw6Y6UlyGi59lPNBr8108uQGyqAWwuMME71ncHa1F/7yLZxE3O4684H48bZJ2NtDlzRl+fSmMHGgkgXONg3/pR5gesMRCWFkqYE3TRNJCzdE2u5EZ1O+Hq/hG5qoLdDrNmpACTwtMisxNDdqaYmuDAAqgF7FzchW0tgEZTych8k3G7gzk1OMmlmHnYSs+N5DjYZC/+9ENk0T9UY153gRXt70LQYtmy8+JK9nikIwqCjI6p+OAAT/J0IWE+9E1edf9S0Duo5nPuiIl7PQtN9brS1WO3wAE9EaAsqhzo7YvBCm46RnnPo6+Y31AZpKGZcG43GwTattZPb2jATVnXYjGh5wmVYHQDCTwltUDYILBpATXzh39KbnmQkhN3LfMn8sv3LGqi4mZbx9n/CV1x3P8z3MR/av4v+pIva3hRQUljbYaJ8Er0XGILx4AG7MBcPpjb58K7crjuSduD01TLXHjGtlqEVHdBvlJDMwBjvD2nv8B6tKqvIx6l1/cs0dErBCJ4uDtPN
 LLLQmIrA
 cJQHjhlwqmOlForZ+ZooDa6goq8ZDn1y1XoE2L4Kiz6LWEabk6/EyqYUb8kmTF4RiKT82I0RzgzVsbx+s0WqGJZlXFYqz9Y0yal4kOruA1u3VwUyNe8oIwmmNspm57IPx9Y5td0Noq3oWTwpYAmE1R6SrvsGFzKO9u8Ujzb8qhrwgdSgh3S7OO03gYqrtp8EKe/Wz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt. It
enabled the flag for memcg->memory, but not for memcg->memsw.

Consequently, memory.memsw.failcnt remains zero when the memory+swap
limit is hit. Enable failcnt accounting for the v1 memsw counter.

Reproducer:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0. With the patch,
memory.memsw.failcnt is greater than 0.

Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6939a4fbb991..4ffe5b3733d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
-- 
2.43.0


